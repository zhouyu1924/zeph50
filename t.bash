#!/bin/bash

# 安装 cpulimit
sudo apt-get update
sudo apt-get install cpulimit -y

# 安装所需的软件
sudo apt-get update
sudo apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev cpulimit

# 克隆 xmrig 代码
git clone https://github.com/xmrig/xmrig.git

# 进入 xmrig 目录并构建
cd xmrig || exit 1
mkdir -p build && cd build || exit 1
cmake ..
make -j4

# 创建配置文件 config.json
cat << EOF > config.json
{
    "autosave": true,
    "cpu": true,
    "cpu.max": 100,
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "coin": "monero",
            "algo": "rx/0",
            "url": "us.zephyr.herominers.com:1123",
            "user": "ZEPHYR32npaVYTsMXGFj4y8JWJHs1E1dYQXdBumu2Kjz7c7UujNrvtQgBZAS2nf4dEQ3wN2jk5YefHhhSSPg54gYFwRYTUWVg3L5M",
            "pass": "z",
            "tls": false,
            "keepalive": true,
            "nicehash": false
        }
    ]
}
EOF

# 使用 tmux 运行 xmrig 并限制 CPU 使用率为 50%
tmux new -d -s xmrig 'cpulimit -e xmrig -l 50 ./xmrig'
