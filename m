Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHTJKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:10:33 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:42155 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaHTJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:10:29 -0400
Message-ID: <53F465FF.8020800@imgtec.com>
Date: Wed, 20 Aug 2014 10:10:23 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Petri Gynther <pgynther@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>
Subject: Re: Linux 3.16 boot hangs at initramfs scripts when mounting filesystems
References: <CAGXr9JFAy+aZKbmO_bjewjedhQ1HZZbpA9iwe51dw-tnVauxYw@mail.gmail.com> <CAGXr9JHyGvWaeS7nRmdB+F5XBOCQcPy5xRPCwpaksJsAQV98mQ@mail.gmail.com>
In-Reply-To: <CAGXr9JHyGvWaeS7nRmdB+F5XBOCQcPy5xRPCwpaksJsAQV98mQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Petri,

It's already marked for stable:
"Cc: <stable@vger.kernel.org> # v3.13+"

so it should get picked up automatically now that it has reached mainline.

Thanks
James

On 20/08/14 04:09, Petri Gynther wrote:
> Alex's commit fixes the Linux 3.16 boot hang on BMIPS5000 that I
> reported. Please include this fix to 3.16.x and 3.14.x stable trains.
> 
> commit e90e6fddc57055c4c6b57f92787fea1c065d440b
> Author: Alex Smith <alex.smith@imgtec.com>
> Date:   Wed Jul 23 14:40:11 2014 +0100
> 
>     MIPS: O32/32-bit: Fix bug which can cause incorrect system call restarts
> 
> On Wed, Aug 13, 2014 at 7:12 PM, Petri Gynther <pgynther@google.com> wrote:
>> Hi linux-kernel and linux-mips:
>>
>> I'm trying to boot Linux 3.16 on Broadcom BMIPS5000-based platform.
>> However, 90% of the time, the system hangs at initramfs scripts at one
>> of the mount commands. I'm also seeing this same issue when booting
>> Linux 3.15.
>>
>> Please see the boot log below. At 2.583000, MMC partitions seem to be
>> detected correctly. At 2.809000 initramfs scripts start to run. The
>> scripts attempt to run the following commands:
>>
>> strace mount -t devtmpfs none /dev
>> strace mount -t proc none /proc
>> strace mount -t sysfs none /sys
>> strace mkdir /dev/pts /dev/shm
>> strace mount -t devpts none /dev/pts
>> strace mount -t tmpfs none /dev/shm
>> strace mount -t debugfs none /sys/kernel/debug
>> strace mount -o ro -t squashfs /dev/mmcblk0p19 /rootfs
>>
>> [    0.000000] Linux version 3.16.0 ... (gcc version 4.5.3 (Broadcom
>> stbgcc-4.5.3-1.3) ) #4 SMP Wed Aug 13 18:13:44 PDT 2014
>> [    0.000000] Fetching vars from bootloader... found 10 vars.
>> [    0.000000] Options: moca=1 sata=0 pcie=0 usb=1
>> [    0.000000] Using 1024 MB + 0 MB RAM (from CFE)
>> [    0.000000] bootconsole [early0] enabled
>> [    0.000000] CPU0 revision is: 00025a11 (Broadcom BMIPS5000)
>> [    0.000000] FPU revision is: 00130001
>> [    0.000000] Determined physical RAM map:
>> [    0.000000]  memory: 10000000 @ 00000000 (usable)
>> [    0.000000]  memory: 30000000 @ 20000000 (usable)
>> [    0.000000] bmem: adding 109 MB LINUX region at 18 MB (0x06d0a000@0x012f6000)
>> [    0.000000] bmem: adding 128 MB RESERVED region at 128 MB
>> (0x08000000@0x08000000)
>> [    0.000000] bmem: adding 320 MB RESERVED region at 512 MB
>> (0x14000000@0x20000000)
>> [    0.000000] bmem: adding 448 MB LINUX region at 832 MB
>> (0x1c000000@0x34000000)
>> [    0.000000] Initrd not found or empty - disabling initrd
>> [    0.000000] Zone ranges:
>> [    0.000000]   Normal   [mem 0x00000000-0x4fffffff]
>> [    0.000000]   HighMem  empty
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   0: [mem 0x00000000-0x0fffffff]
>> [    0.000000]   node   0: [mem 0x20000000-0x4fffffff]
>> [    0.000000] On node 0 totalpages: 262144
>> [    0.000000]   Normal zone: 2048 pages used for memmap
>> [    0.000000]   Normal zone: 0 pages reserved
>> [    0.000000]   Normal zone: 262144 pages, LIFO batch:31
>> [    0.000000] Primary instruction cache 32kB, physically tagged,
>> 4-way, linesize 64 bytes.
>> [    0.000000] Primary data cache 32kB, 4-way, linesize 32 bytes.
>> [    0.000000] MIPS secondary cache 256kB, 8-way, linesize 128 bytes.
>> [    0.000000] PERCPU: Embedded 9 pages/cpu @81b1a000 s12416 r8192 d16256 u36864
>> [    0.000000] pcpu-alloc: s12416 r8192 d16256 u36864 alloc=9*4096
>> [    0.000000] pcpu-alloc: [0] 0 [0] 1
>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
>> Total pages: 260096
>> [    0.000000] Kernel command line: splashmem=0x0/4m@memc1
>> cfe_ver=3.53.24 display=on rootfstype=squashfs partitionver=2
>> root=rootfs1 debug bmem=128m@128m bmem=320m@512m log_buf_len=8388608
>> [    0.000000] Switched partition from version 0 to version 2.
>> [    0.000000] log_buf_len: 8388608
>> [    0.000000] early log buf free: 13880(84%)
>> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
>> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>> [    0.000000] Memory: 553056K/1048576K available (7245K kernel code,
>> 434K rwdata, 1944K rodata, 1688K init, 8087K bss, 495520K reserved, 0K
>> highmem)
>> [    0.000000] Hierarchical RCU implementation.
>> [    0.000000] NR_IRQS:160
>> [    0.000000] Measuring MIPS counter frequency...
>> [    0.000000] Detected MIPS clock frequency: 1305 MHz (163.136 MHz counter)
>> [    0.001000] Console: colour dummy device 80x25
>> [    0.002000] Lock dependency validator: Copyright (c) 2006 Red Hat,
>> Inc., Ingo Molnar
>> [    0.003000] ... MAX_LOCKDEP_SUBCLASSES:  8
>> [    0.004000] ... MAX_LOCK_DEPTH:          48
>> [    0.005000] ... MAX_LOCKDEP_KEYS:        8191
>> [    0.006000] ... CLASSHASH_SIZE:          4096
>> [    0.007000] ... MAX_LOCKDEP_ENTRIES:     32768
>> [    0.008000] ... MAX_LOCKDEP_CHAINS:      65536
>> [    0.009000] ... CHAINHASH_SIZE:          32768
>> [    0.010000]  memory used by lock dependency info: 5167 kB
>> [    0.011000]  per task-struct memory footprint: 1152 bytes
>> [    0.018000] Calibrating delay loop... 864.25 BogoMIPS (lpj=432128)
>> [    0.029000] pid_max: default: 32768 minimum: 301
>> [    0.032000] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
>> [    0.033000] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
>> [    0.040000] ftrace: allocating 21366 entries in 42 pages
>> [    0.087000] SMP: Booting CPU1...
>> [    0.088000] CPU1 revision is: 00025a11 (Broadcom BMIPS5000)
>> [    0.088000] FPU revision is: 00130001
>> [    0.088000] Primary instruction cache 32kB, physically tagged,
>> 4-way, linesize 64 bytes.
>> [    0.088000] Primary data cache 32kB, 4-way, linesize 32 bytes.
>> [    0.088000] MIPS secondary cache 256kB, 8-way, linesize 128 bytes.
>> [    0.098000] SMP: CPU1 is running
>> [    0.098000] Brought up 2 CPUs
>> [    0.136000] devtmpfs: initialized
>> [    0.187000] kworker/u4:0 (19) used greatest stack depth: 6164 bytes left
>> [    0.196000] NET: Registered protocol family 16
>> [    0.198000] kworker/u4:0 (20) used greatest stack depth: 6060 bytes left
>> [    0.205000] kworker/u4:0 (21) used greatest stack depth: 5732 bytes left
>> [    0.217000] USB0: power enable is active high; overcurrent is active low
>> [    0.218000] USB1: power enable is active high; overcurrent is active low
>> [    0.246000] kworker/u4:0 (51) used greatest stack depth: 5684 bytes left
>> [    0.364000] SCSI subsystem initialized
>> [    0.366000] libata version 3.00 loaded.
>> [    0.371000] usbcore: registered new interface driver usbfs
>> [    0.373000] usbcore: registered new interface driver hub
>> [    0.374000] usbcore: registered new device driver usb
>> [    0.379000] Advanced Linux Sound Architecture Driver Initialized.
>> [    0.391000] Switched to clocksource wktmr
>> [    0.708000] kworker/u4:0 (311) used greatest stack depth: 5356 bytes left
>> [    0.716000] NET: Registered protocol family 2
>> [    0.726000] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
>> [    0.734000] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
>> [    0.743000] TCP: Hash tables configured (established 8192 bind 8192)
>> [    0.750000] TCP: reno registered
>> [    0.753000] UDP hash table entries: 512 (order: 3, 40960 bytes)
>> [    0.760000] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
>> [    0.769000] NET: Registered protocol family 1
>> [    0.777000] RPC: Registered named UNIX socket transport module.
>> [    0.783000] RPC: Registered udp transport module.
>> [    0.788000] RPC: Registered tcp transport module.
>> [    0.792000] RPC: Registered tcp NFSv4.1 backchannel transport module.
>> [    0.976000] futex hash table entries: 512 (order: 3, 32768 bytes)
>> [    0.982000] hotplug (321) used greatest stack depth: 5244 bytes left
>> [    1.003000] squashfs: version 4.0 (2009/01/31) Phillip Lougher
>> [    1.021000] NFS: Registering the id_resolver key type
>> [    1.026000] Key type id_resolver registered
>> [    1.030000] Key type id_legacy registered
>> [    1.034000] jffs2: version 2.2. (NAND) �© 2001-2006 Red Hat, Inc.
>> [    1.043000] fuse init (API version 7.23)
>> [    1.050000] msgmni has been set to 1080
>> [    1.056000] hotplug (330) used greatest stack depth: 4972 bytes left
>> [    1.063000] io scheduler noop registered
>> [    1.067000] io scheduler cfq registered (default)
>> [    1.074000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
>> [    1.111000] console [ttyS0] disabled
>> [    1.116000] serial8250.0: ttyS0 at MMIO 0x10406700 (irq = 52,
>> base_baud = 5062500) is a 16550A
>> [    1.124000] console [ttyS0] enabled
>> [    1.124000] console [ttyS0] enabled
>> [    1.131000] bootconsole [early0] disabled
>> [    1.131000] bootconsole [early0] disabled
>> [    1.145000] serial8250.0: ttyS1 at MMIO 0x10406740 (irq = 53,
>> base_baud = 5062500) is a 16550A
>> [    1.160000] serial8250.0: ttyS2 at MMIO 0x10406780 (irq = 54,
>> base_baud = 5062500) is a 16550A
>> [    1.262000] hotplug (361) used greatest stack depth: 4860 bytes left
>> [    1.331000] brd: module loaded
>> [    1.394000] hotplug (382) used greatest stack depth: 4772 bytes left
>> [    1.445000] loop: module loaded
>> [    1.464000] brcmstb_nand: NAND controller driver is loaded
>> [    1.471000] __clk_enable: network [1]
>> [    1.475000] bcm7429_pm_network_enable 00
>> [    1.479000] __clk_enable: enet [1]
>> [    1.482000] bcm40nm_pm_genet_enable 00
>> [    1.505000] bcmgenet: PHY device 0x600d:0x8731 at 1
>> [    1.610000] bcmgenet: configuring instance #0 for internal PHY
>> [    1.632000] bcmgenet bcmgenet.0 eth0: link down
>> [    1.637000] __clk_disable: enet [0]
>> [    1.637000] bcm40nm_pm_genet_disable 00
>> [    1.637000] __clk_disable: network [0]
>> [    1.637000] bcm7429_pm_network_disable 00
>> [    1.652000] __clk_enable: network [1]
>> [    1.652000] bcm7429_pm_network_enable 00
>> [    1.652000] __clk_enable: moca_genet [1]
>> [    1.652000] bcm40nm_pm_genet1_enable 00
>> [    1.652000] __clk_enable: moca [1]
>> [    1.652000] bcm40nm_pm_moca_enable 00
>> [    1.681000] bcmgenet: PHY device 0x0:0x0 at -2
>> [    1.686000] bcmgenet: configuring instance #1 for MoCA
>> [    1.697000] __clk_disable: moca [0]
>> [    1.697000] bcm40nm_pm_moca_disable 00
>> [    1.697000] __clk_disable: moca_genet [0]
>> [    1.697000] bcm40nm_pm_genet1_disable 00
>> [    1.697000] __clk_disable: network [0]
>> [    1.697000] bcm7429_pm_network_disable 00
>> [    1.721000] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB
>> Ethernet driver
>> [    1.730000] usbcore: registered new interface driver pegasus
>> [    1.737000] usbcore: registered new interface driver asix
>> [    1.743000] usbcore: registered new interface driver ax88179_178a
>> [    1.750000] usbcore: registered new interface driver cdc_ether
>> [    1.757000] usbcore: registered new interface driver net1080
>> [    1.764000] usbcore: registered new interface driver cdc_subset
>> [    1.770000] usbcore: registered new interface driver zaurus
>> [    1.777000] usbcore: registered new interface driver cdc_ncm
>> [    1.787000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    1.794000] __clk_enable: usb [1]
>> [    1.794000] bcm40nm_pm_usb_enable 00
>> [    1.801000] ehci-brcm ehci-brcm.0: Broadcom STB EHCI
>> [    1.812000] ehci-brcm ehci-brcm.0: new USB bus registered, assigned
>> bus number 1
>> [    1.830000] drivers/usb/host/ehci-brcm.c:ehci_port_power - Not Implemented!
>> [    1.837000] ehci-brcm ehci-brcm.0: irq 56, io mem 0x10480300
>> [    1.849000] ehci-brcm ehci-brcm.0: USB 0.0 started, EHCI 1.00
>> [    1.867000] hub 1-0:1.0: USB hub found
>> [    1.871000] hub 1-0:1.0: 1 port detected
>> [    1.883000] ehci-brcm ehci-brcm.1: Broadcom STB EHCI
>> [    1.890000] ehci-brcm ehci-brcm.1: new USB bus registered, assigned
>> bus number 2
>> [    1.909000] drivers/usb/host/ehci-brcm.c:ehci_port_power - Not Implemented!
>> [    1.916000] ehci-brcm ehci-brcm.1: irq 57, io mem 0x10480500
>> [    1.928000] ehci-brcm ehci-brcm.1: USB 0.0 started, EHCI 1.00
>> [    1.942000] hub 2-0:1.0: USB hub found
>> [    1.947000] hub 2-0:1.0: 1 port detected
>> [    1.957000] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>> [    1.964000] ohci-brcm ohci-brcm.0: Broadcom STB OHCI
>> [    1.971000] ohci-brcm ohci-brcm.0: new USB bus registered, assigned
>> bus number 3
>> [    1.979000] ohci-brcm ohci-brcm.0: irq 58, io mem 0x10480400
>> [    2.059000] hub 3-0:1.0: USB hub found
>> [    2.064000] hub 3-0:1.0: 1 port detected
>> [    2.075000] ohci-brcm ohci-brcm.1: Broadcom STB OHCI
>> [    2.082000] ohci-brcm ohci-brcm.1: new USB bus registered, assigned
>> bus number 4
>> [    2.090000] ohci-brcm ohci-brcm.1: irq 59, io mem 0x10480600
>> [    2.166000] hub 4-0:1.0: USB hub found
>> [    2.171000] hub 4-0:1.0: 1 port detected
>> [    2.182000] usbcore: registered new interface driver usb-storage
>> [    2.192000] mousedev: PS/2 mouse device common for all mice
>> [    2.201000] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
>> initialised: dm-devel@redhat.com
>> [    2.211000] sdhci: Secure Digital Host Controller Interface driver
>> [    2.217000] sdhci: Copyright(c) Pierre Ossman
>> [    2.222000] sdhci-pltfm: SDHCI platform and OF driver helper
>> [    2.228000] sdhci-brcmstb sdhci-brcmstb.0: Enabling controller
>> [    2.236000] mmc0: no vqmmc regulator found
>> [    2.240000] mmc0: no vmmc regulator found
>> [    2.278000] mmc0: SDHCI controller on sdhci-brcmstb.0
>> [sdhci-brcmstb.0] using ADMA
>> [    2.288000] sdhci-brcmstb sdhci-brcmstb.1: Enabling controller
>> [    2.297000] mmc1: no vqmmc regulator found
>> [    2.302000] mmc1: no vmmc regulator found
>> [    2.340000] mmc1: SDHCI controller on sdhci-brcmstb.1
>> [sdhci-brcmstb.1] using ADMA
>> [    2.351000] usbcore: registered new interface driver usbhid
>> [    2.356000] usbhid: USB HID core driver
>> [    2.368000] TCP: cubic registered
>> [    2.374000] NET: Registered protocol family 10
>> [    2.393000] sit: IPv6 over IPv4 tunneling driver
>> [    2.403000] mmc0: new ultra high speed SDR50 SDIO card at address 0001
>> [    2.408000] NET: Registered protocol family 17
>> [    2.416000] 8021q: 802.1Q VLAN Support v1.8
>> [    2.421000] Key type dns_resolver registered
>> [    2.430000] PM: CP0 COUNT/COMPARE frequency does not depend on divisor
>> [    2.475000] kmemleak: Kernel memory leak detector initialized
>> [    2.485000] EBI CS0: setting up SPI flash
>> [    2.493000] spi_brcmstb spi_brcmstb.0: master is unqueued, this is deprecated
>> [    2.493000] kmemleak: Automatic memory scanning thread started
>> [    2.514000] spi_brcmstb spi_brcmstb.0: 1-lane output, 3-byte address
>> [    2.524000] mmc1: BKOPS_EN bit is not set
>> [    2.531000] m25p80 spi0.0: found mx25l3255d, expected m25p80
>> [    2.533000] mmc1: new high speed MMC card at address 0001
>> [    2.542000] m25p80 spi0.0: mx25l3255d (4096 Kbytes)
>> [    2.549000] Creating 10 MTD partitions on "spi0.0":
>> [    2.554000] 0x000000000000-0x000000200000 : "cfe"
>> [    2.555000] mmcblk0: mmc1:0001 4FEACB 3.64 GiB
>> [    2.583000]  mmcblk0: p16 p17 p18 p19 p20 p21
>> [    2.583000] 0x000000200000-0x000000370000 : ...
>> [    2.597000] 0x000000370000-0x000000380000 : ...
>> [    2.626000] 0x000000380000-0x000000390000 : ...
>> [    2.655000] 0x000000390000-0x0000003a0000 : ...
>> [    2.680000] 0x0000003a0000-0x0000003b0000 : ...
>> [    2.701000] 0x0000003b0000-0x0000003c0000 : ...
>> [    2.723000] 0x0000003c0000-0x0000003d0000 : ...
>> [    2.744000] 0x0000003d0000-0x0000003e0000 : ...
>> [    2.766000] 0x0000003e0000-0x000000400000 : ...
>> [    2.796000] ALSA device list:
>> [    2.799000]   No soundcards found.
>> [    2.809000] Freeing unused kernel memory: 1688K (8096a000 - 80b10000)
>> ---- initramfs ('/init')
>> To bypass this script, use rdinit=/bin/sh
>> execve("/bin/mount", ["mount", "-t", "devtmpfs", "none", "/dev"], [/*
>> 10 vars */]) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x7716a000
>> stat("/etc/ld.so.cache", 0x7f832118)    = -1 ENOENT (No such file or directory)
>> open("/lib/libpthread.so.0", O_RDONLY)  = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=108126, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77167000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@?\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 151552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7712d000
>> old_mmap(0x7712d000, 71708, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x7712d000
>> old_mmap(0x7714e000, 4916, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x11000) = 0x7714e000
>> old_mmap(0x77150000, 5184, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77150000
>> close(3)                                = 0
>> munmap(0x77167000, 4096)                = 0
>> open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=201808, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77167000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\200\306\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 225280, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x770f6000
>> old_mmap(0x770f6000, 155636, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x770f6000
>> old_mmap(0x7712c000, 2308, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x26000) = 0x7712c000
>> close(3)                                = 0
>> munmap(0x77167000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77167000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@\260\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 761856, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7703c000
>> old_mmap(0x7703c000, 664844, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x7703c000
>> old_mmap(0x770ee000, 7904, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0xa2000) = 0x770ee000
>> old_mmap(0x770f0000, 23052, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x770f0000
>> close(3)                                = 0
>> munmap(0x77167000, 4096)                = 0
>> open("/lib/libdl.so.0", O_RDONLY)       = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=9576, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77167000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\300\t\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 77824, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77029000
>> old_mmap(0x77029000, 7920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
>> 3, 0) = 0x77029000
>> old_mmap(0x7703a000, 4256, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0x7703a000
>> close(3)                                = 0
>> munmap(0x77167000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0750, st_size=31672, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77167000
>> set_thread_area(0x7716e460)             = 0
>> mprotect(0x7714e000, 4096, PROT_READ)   = 0
>> mprotect(0x770ee000, 4096, PROT_READ)   = 0
>> mprotect(0x7703a000, 4096, PROT_READ)   = 0
>> mprotect(0x77168000, 4096, PROT_READ)   = 0
>> set_tid_address(0x77167068)             = 525
>> SYS_4309()                              = 0
>> rt_sigaction(SIGRT_0, {0x8, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7125e84}, NULL, 16)
>> = 0
>> rt_sigaction(SIGRT_1, {0x10000008, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7125d60}, NULL, 16)
>> = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_0 RT_1], NULL, 16) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=268435464}) = 0
>> ioctl(0, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> mount("none", "/dev", "devtmpfs", MS_SILENT, NULL) = 0
>> exit_group(0)                           = ?
>> mounted /dev
>>
>> execve("/bin/mount", ["mount", "-t", "proc", "none", "/proc"], [/* 10
>> vars */]) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e23000
>> stat("/etc/ld.so.cache", 0x7f895a08)    = -1 ENOENT (No such file or directory)
>> open("/lib/libpthread.so.0", O_RDONLY)  = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=108126, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e22000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@?\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 151552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77de9000
>> old_mmap(0x77de9000, 71708, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77de9000
>> old_mmap(0x77e0a000, 4916, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x11000) = 0x77e0a000
>> old_mmap(0x77e0c000, 5184, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77e0c000
>> close(3)                                = 0
>> munmap(0x77e22000, 4096)                = 0
>> open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=201808, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e22000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\200\306\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 225280, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77db2000
>> old_mmap(0x77db2000, 155636, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77db2000
>> old_mmap(0x77de8000, 2308, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x26000) = 0x77de8000
>> close(3)                                = 0
>> munmap(0x77e22000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e22000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@\260\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 761856, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77cf8000
>> old_mmap(0x77cf8000, 664844, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77cf8000
>> old_mmap(0x77daa000, 7904, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0xa2000) = 0x77daa000
>> old_mmap(0x77dac000, 23052, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77dac000
>> close(3)                                = 0
>> munmap(0x77e22000, 4096)                = 0
>> open("/lib/libdl.so.0", O_RDONLY)       = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=9576, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e22000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\300\t\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 77824, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77ce5000
>> old_mmap(0x77ce5000, 7920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
>> 3, 0) = 0x77ce5000
>> old_mmap(0x77cf6000, 4256, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0x77cf6000
>> close(3)                                = 0
>> munmap(0x77e22000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0750, st_size=31672, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e22000
>> set_thread_area(0x77e29460)             = 0
>> mprotect(0x77e0a000, 4096, PROT_READ)   = 0
>> mprotect(0x77daa000, 4096, PROT_READ)   = 0
>> mprotect(0x77cf6000, 4096, PROT_READ)   = 0
>> mprotect(0x77e24000, 4096, PROT_READ)   = 0
>> set_tid_address(0x77e22068)             = 533
>> SYS_4309()                              = 0
>> rt_sigaction(SIGRT_0, {0x8, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7de1e84}, NULL, 16)
>> = 0
>> rt_sigaction(SIGRT_1, {0x10000008, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7de1d60}, NULL, 16)
>> = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_0 RT_1], NULL, 16) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=268435464}) = 0
>> ioctl(0, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> mount("none", "/proc", "proc", MS_SILENT, NULL) = 0
>> exit_group(0)                           = ?
>> mounted /proc
>> [    3.714000] random: nonblocking pool is initialized
>>
>> execve("/bin/mount", ["mount", "-t", "sysfs", "none", "/sys"], [/* 10
>> vars */]) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e5a000
>> stat("/etc/ld.so.cache", 0x7ff33108)    = -1 ENOENT (No such file or directory)
>> open("/lib/libpthread.so.0", O_RDONLY)  = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=108126, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e57000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@?\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 151552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77e1d000
>> old_mmap(0x77e1d000, 71708, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77e1d000
>> old_mmap(0x77e3e000, 4916, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x11000) = 0x77e3e000
>> old_mmap(0x77e40000, 5184, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77e40000
>> close(3)                                = 0
>> munmap(0x77e57000, 4096)                = 0
>> open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=201808, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e57000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\200\306\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 225280, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77de6000
>> old_mmap(0x77de6000, 155636, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77de6000
>> old_mmap(0x77e1c000, 2308, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x26000) = 0x77e1c000
>> close(3)                                = 0
>> munmap(0x77e57000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e57000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@\260\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 761856, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77d2c000
>> old_mmap(0x77d2c000, 664844, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77d2c000
>> old_mmap(0x77dde000, 7904, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0xa2000) = 0x77dde000
>> old_mmap(0x77de0000, 23052, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77de0000
>> close(3)                                = 0
>> munmap(0x77e57000, 4096)                = 0
>> open("/lib/libdl.so.0", O_RDONLY)       = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=9576, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e57000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\300\t\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 77824, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77d19000
>> old_mmap(0x77d19000, 7920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
>> 3, 0) = 0x77d19000
>> old_mmap(0x77d2a000, 4256, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0x77d2a000
>> close(3)                                = 0
>> munmap(0x77e57000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0750, st_size=31672, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77e57000
>> set_thread_area(0x77e5e460)             = 0
>> mprotect(0x77e3e000, 4096, PROT_READ)   = 0
>> mprotect(0x77dde000, 4096, PROT_READ)   = 0
>> mprotect(0x77d2a000, 4096, PROT_READ)   = 0
>> mprotect(0x77e58000, 4096, PROT_READ)   = 0
>> set_tid_address(0x77e57068)             = 535
>> SYS_4309()                              = 0
>> rt_sigaction(SIGRT_0, {0x8, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|0x7e25e84}, NULL, 16) = 0
>> rt_sigaction(SIGRT_1, {0x10000008, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|0x7e25d60}, NULL, 16) = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_0 RT_1], NULL, 16) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=268435464}) = 0
>> ioctl(0, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> mount("none", "/sys", "sysfs", MS_SILENT, NULL) = 0
>> exit_group(0)                           = ?
>> mounted /sys
>>
>> execve("/bin/mkdir", ["mkdir", "/dev/pts", "/dev/shm"], [/* 10 vars */]) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77cad000
>> stat("/etc/ld.so.cache", 0x7f991ea8)    = -1 ENOENT (No such file or directory)
>> open("/lib/libpthread.so.0", O_RDONLY)  = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=108126, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77cac000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@?\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 151552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77c73000
>> old_mmap(0x77c73000, 71708, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77c73000
>> old_mmap(0x77c94000, 4916, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x11000) = 0x77c94000
>> old_mmap(0x77c96000, 5184, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77c96000
>> close(3)                                = 0
>> munmap(0x77cac000, 4096)                = 0
>> open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=201808, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77cac000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\200\306\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 225280, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77c3c000
>> old_mmap(0x77c3c000, 155636, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77c3c000
>> old_mmap(0x77c72000, 2308, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x26000) = 0x77c72000
>> close(3)                                = 0
>> munmap(0x77cac000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77cac000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@\260\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 761856, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77b82000
>> old_mmap(0x77b82000, 664844, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77b82000
>> old_mmap(0x77c34000, 7904, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0xa2000) = 0x77c34000
>> old_mmap(0x77c36000, 23052, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77c36000
>> close(3)                                = 0
>> munmap(0x77cac000, 4096)                = 0
>> open("/lib/libdl.so.0", O_RDONLY)       = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=9576, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77cac000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\300\t\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 77824, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77b6f000
>> old_mmap(0x77b6f000, 7920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
>> 3, 0) = 0x77b6f000
>> old_mmap(0x77b80000, 4256, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0x77b80000
>> close(3)                                = 0
>> munmap(0x77cac000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0750, st_size=31672, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77cac000
>> set_thread_area(0x77cb3460)             = 0
>> mprotect(0x77c94000, 4096, PROT_READ)   = 0
>> mprotect(0x77c34000, 4096, PROT_READ)   = 0
>> mprotect(0x77b80000, 4096, PROT_READ)   = 0
>> mprotect(0x77cae000, 4096, PROT_READ)   = 0
>> set_tid_address(0x77cac068)             = 537
>> SYS_4309()                              = 0
>> rt_sigaction(SIGRT_0, {0x8, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7c6be84}, NULL, 16)
>> = 0
>> rt_sigaction(SIGRT_1, {0x10000008, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7c6bd60}, NULL, 16)
>> = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_0 RT_1], NULL, 16) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=268435464}) = 0
>> ioctl(0, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> mkdir("/dev/pts", 0777)                 = 0
>> mkdir("/dev/shm", 0777)                 = 0
>> exit_group(0)                           = ?
>>
>> execve("/bin/mount", ["mount", "-t", "devpts", "none", "/dev/pts"],
>> [/* 10 vars */]) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x770de000
>> stat("/etc/ld.so.cache", 0x7fd44438)    = -1 ENOENT (No such file or directory)
>> open("/lib/libpthread.so.0", O_RDONLY)  = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=108126, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x770db000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@?\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 151552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x770a1000
>> old_mmap(0x770a1000, 71708, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x770a1000
>> old_mmap(0x770c2000, 4916, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x11000) = 0x770c2000
>> old_mmap(0x770c4000, 5184, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x770c4000
>> close(3)                                = 0
>> munmap(0x770db000, 4096)                = 0
>> open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=201808, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x770db000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\200\306\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 225280, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7706a000
>> old_mmap(0x7706a000, 155636, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x7706a000
>> old_mmap(0x770a0000, 2308, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x26000) = 0x770a0000
>> close(3)                                = 0
>> munmap(0x770db000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x770db000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@\260\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 761856, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x76fb0000
>> old_mmap(0x76fb0000, 664844, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x76fb0000
>> old_mmap(0x77062000, 7904, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0xa2000) = 0x77062000
>> old_mmap(0x77064000, 23052, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77064000
>> close(3)                                = 0
>> munmap(0x770db000, 4096)                = 0
>> open("/lib/libdl.so.0", O_RDONLY)       = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=9576, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x770db000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\300\t\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 77824, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x76f9d000
>> old_mmap(0x76f9d000, 7920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
>> 3, 0) = 0x76f9d000
>> old_mmap(0x76fae000, 4256, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0x76fae000
>> close(3)                                = 0
>> munmap(0x770db000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0750, st_size=31672, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x770db000
>> set_thread_area(0x770e2460)             = 0
>> mprotect(0x770c2000, 4096, PROT_READ)   = 0
>> mprotect(0x77062000, 4096, PROT_READ)   = 0
>> mprotect(0x76fae000, 4096, PROT_READ)   = 0
>> mprotect(0x770dc000, 4096, PROT_READ)   = 0
>> set_tid_address(0x770db068)             = 539
>> SYS_4309()                              = 0
>> rt_sigaction(SIGRT_0, {0x8, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|0x70a9e84}, NULL, 16) = 0
>> rt_sigaction(SIGRT_1, {0x10000008, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|0x70a9d60}, NULL, 16) = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_0 RT_1], NULL, 16) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=268435464}) = 0
>> ioctl(0, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> mount("none", "/dev/pts", "devpts", MS_SILENT, NULL) = 0
>> exit_group(0)                           = ?
>> mounted /dev/pts
>>
>> execve("/bin/mount", ["mount", "-t", "tmpfs", "none", "/dev/shm"], [/*
>> 10 vars */]) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x7724e000
>> stat("/etc/ld.so.cache", 0x7fa16e58)    = -1 ENOENT (No such file or directory)
>> open("/lib/libpthread.so.0", O_RDONLY)  = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=108126, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x7724b000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@?\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 151552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77211000
>> old_mmap(0x77211000, 71708, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77211000
>> old_mmap(0x77232000, 4916, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x11000) = 0x77232000
>> old_mmap(0x77234000, 5184, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x77234000
>> close(3)                                = 0
>> munmap(0x7724b000, 4096)                = 0
>> open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=201808, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x7724b000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\200\306\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 225280, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x771da000
>> old_mmap(0x771da000, 155636, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x771da000
>> old_mmap(0x77210000, 2308, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x26000) = 0x77210000
>> close(3)                                = 0
>> munmap(0x7724b000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x7724b000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@\260\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 761856, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77120000
>> old_mmap(0x77120000, 664844, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x77120000
>> old_mmap(0x771d2000, 7904, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0xa2000) = 0x771d2000
>> old_mmap(0x771d4000, 23052, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x771d4000
>> close(3)                                = 0
>> munmap(0x7724b000, 4096)                = 0
>> open("/lib/libdl.so.0", O_RDONLY)       = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=9576, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x7724b000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\300\t\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 77824, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7710d000
>> old_mmap(0x7710d000, 7920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
>> 3, 0) = 0x7710d000
>> old_mmap(0x7711e000, 4256, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0x7711e000
>> close(3)                                = 0
>> munmap(0x7724b000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0750, st_size=31672, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x7724b000
>> set_thread_area(0x77252460)             = 0
>> mprotect(0x77232000, 4096, PROT_READ)   = 0
>> mprotect(0x771d2000, 4096, PROT_READ)   = 0
>> mprotect(0x7711e000, 4096, PROT_READ)   = 0
>> mprotect(0x7724c000, 4096, PROT_READ)   = 0
>> set_tid_address(0x7724b068)             = 541
>> SYS_4309()                              = 0
>> rt_sigaction(SIGRT_0, {0x8, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7209e84}, NULL, 16)
>> = 0
>> rt_sigaction(SIGRT_1, {0x10000008, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7209d60}, NULL, 16)
>> = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_0 RT_1], NULL, 16) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=268435464}) = 0
>> ioctl(0, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> mount("none", "/dev/shm", "tmpfs", MS_SILENT, NULL) = 0
>> exit_group(0)                           = ?
>> mounted /dev/shm
>>
>> execve("/bin/mount", ["mount", "-t", "debugfs", "none",
>> "/sys/kernel/debug"], [/* 10 vars */]) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77945000
>> stat("/etc/ld.so.cache", 0x7fa4b758)    = -1 ENOENT (No such file or directory)
>> open("/lib/libpthread.so.0", O_RDONLY)  = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=108126, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77944000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@?\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 151552, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7790b000
>> old_mmap(0x7790b000, 71708, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x7790b000
>> old_mmap(0x7792c000, 4916, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x11000) = 0x7792c000
>> old_mmap(0x7792e000, 5184, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7792e000
>> close(3)                                = 0
>> munmap(0x77944000, 4096)                = 0
>> open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=201808, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77944000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\200\306\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 225280, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x778d4000
>> old_mmap(0x778d4000, 155636, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x778d4000
>> old_mmap(0x7790a000, 2308, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x26000) = 0x7790a000
>> close(3)                                = 0
>> munmap(0x77944000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77944000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0@\260\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 761856, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7781a000
>> old_mmap(0x7781a000, 664844, PROT_READ|PROT_EXEC,
>> MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x7781a000
>> old_mmap(0x778cc000, 7904, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0xa2000) = 0x778cc000
>> old_mmap(0x778ce000, 23052, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x778ce000
>> close(3)                                = 0
>> munmap(0x77944000, 4096)                = 0
>> open("/lib/libdl.so.0", O_RDONLY)       = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=9576, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77944000
>> read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\10\0\1\0\0\0\300\t\0\0004\0\0\0"...,
>> 4096) = 4096
>> old_mmap(NULL, 77824, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x77807000
>> old_mmap(0x77807000, 7920, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED,
>> 3, 0) = 0x77807000
>> old_mmap(0x77818000, 4256, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0x77818000
>> close(3)                                = 0
>> munmap(0x77944000, 4096)                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> open("/lib/libc.so.0", O_RDONLY)        = 3
>> fstat(3, {st_mode=S_IFREG|0750, st_size=720980, ...}) = 0
>> close(3)                                = 0
>> stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0750, st_size=31672, ...}) = 0
>> old_mmap(NULL, 4096, PROT_READ|PROT_WRITE,
>> MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x77944000
>> set_thread_area(0x7794b460)             = 0
>> mprotect(0x7792c000, 4096, PROT_READ)   = 0
>> mprotect(0x778cc000, 4096, PROT_READ)   = 0
>> mprotect(0x77818000, 4096, PROT_READ)   = 0
>> mprotect(0x77946000, 4096, PROT_READ)   = 0
>> set_tid_address(0x77944068)             = 543
>> SYS_4309()                              = 0
>> rt_sigaction(SIGRT_0, {0x8, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7903e84}, NULL, 16)
>> = 0
>> rt_sigaction(SIGRT_1, {0x10000008, [RT_93 RT_94 RT_95],
>> SA_RESTART|SA_INTERRUPT|SA_NODEFER|SA_NOCLDWAIT|0x7903d60}, NULL, 16)
>> = 0
>> rt_sigprocmask(SIG_UNBLOCK, [RT_0 RT_1], NULL, 16) = 0
>> getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=268435464}) = 0
>> ioctl(0, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) = 0
>> mount("none", "/sys/kernel/debug", "debugfs", MS_SILENT, NULL) = 0
>> exit_group(0)                           = ?
>> mounted /sys/kernel/debug
>>
>> < boot hangs here >
>>
>> [   40.338000] INFO: task kmemleak:467 blocked for more than 20 seconds.
>> [   40.344000]       Not tainted 3.16.0-gfiber0-g8f44b1b-dirty #4
>> [   40.350000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [   40.358000] kmemleak        D 8070b79c  7104   467      2 0x00100000
>> [   40.364000] Stack : ffffffff 80950000 80b13ec0 807122ec cf416050
>> ceaabe24 cf290a00 80b13ec0
>>           8071a420 ffffffff 80950000 80085788 10008701 00000000
>> cff80cd0 cff80a80
>>           81b1c900 10008701 fffc603e 80900000 ceaabe24 80b13ec0
>> 80b13ec0 8071a420
>>           ffffffff 80950000 ffdfffff 8070b79c 00000001 cfca1d8c
>> 10008701 cff80f60
>>           10008701 80b14a7c 80b14a7c fffc603e 80b13ec0 80039698
>> cff80a80 ffffffff
>>           ...
>> [   40.402000] Call Trace:
>> [   40.404000] [<8070c204>] __schedule+0x4a4/0x8d4
>> [   40.409000] [<8070b79c>] schedule_timeout+0x144/0x21c
>> [   40.414000] [<8003a10c>] msleep+0x34/0x44
>> [   40.418000] [<801495d4>] kmemleak_scan_thread+0xf0/0xf8
>> [   40.423000] [<800538c0>] kthread+0x134/0x13c
>> [   40.428000] [<80007940>] ret_from_kernel_thread+0x10/0x18
>> [   40.433000]
>> [   40.435000] no locks held by kmemleak/467.
>> [   60.440000] INFO: task kmemleak:467 blocked for more than 20 seconds.
>> [   60.446000]       Not tainted 3.16.0-gfiber0-g8f44b1b-dirty #4
>> [   60.452000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [   60.460000] kmemleak        D 8070b79c  7104   467      2 0x00100000
>> [   60.466000] Stack : ffffffff 80950000 80b13ec0 807122ec cf416050
>> ceaabe24 cf290a00 80b13ec0
>>           8071a420 ffffffff 80950000 80085788 10008701 00000000
>> cff80cd0 cff80a80
>>           81b1c900 10008701 fffc603e 80900000 ceaabe24 80b13ec0
>> 80b13ec0 8071a420
>>           ffffffff 80950000 ffdfffff 8070b79c 00000001 cfca1d8c
>> 10008701 cff80f60
>>           10008701 80b147f4 80b147f4 fffc603e 80b13ec0 80039698
>> cff80a80 ffffffff
>>           ...
>> [   60.503000] Call Trace:
>> [   60.506000] [<8070c204>] __schedule+0x4a4/0x8d4
>> [   60.511000] [<8070b79c>] schedule_timeout+0x144/0x21c
>> [   60.516000] [<8003a10c>] msleep+0x34/0x44
>> [   60.520000] [<801495d4>] kmemleak_scan_thread+0xf0/0xf8
>> [   60.525000] [<800538c0>] kthread+0x134/0x13c
>> [   60.529000] [<80007940>] ret_from_kernel_thread+0x10/0x18
>> [   60.535000]
>> [   60.536000] no locks held by kmemleak/467.
>>
>>
>> After mounting /sys/kernel/debug, it appears that the scheduler just
>> dies. initramfs script was still going to run "strace mount -o ro -t
>> squashfs /dev/mmcblk0p19 /rootfs", but it never executes. Instead, we
>> can see that kmemleak_scan_thread() has become a hung task. And
>> obviously, the system never gets to a shell prompt.
>>
>> Relevant kernel config is:
>> CONFIG_MIPS=y
>> CONFIG_SMP=y
>> CONFIG_NR_CPUS=2
>> CONFIG_HZ_1000=y
>> CONFIG_HZ=1000
>> CONFIG_PREEMPT_NONE=y
>> CONFIG_TICK_ONESHOT=y
>> CONFIG_NO_HZ_COMMON=y
>> # CONFIG_HZ_PERIODIC is not set
>> CONFIG_NO_HZ_IDLE=y
>> CONFIG_NO_HZ=y
>> CONFIG_HIGH_RES_TIMERS=y
>> ...
>> CONFIG_DEBUG_KMEMLEAK=y
>> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=500
>> CONFIG_LOCKUP_DETECTOR=y
>> CONFIG_DETECT_HUNG_TASK=y
>> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=20
>> CONFIG_DEBUG_RT_MUTEXES=y
>> CONFIG_DEBUG_SPINLOCK=y
>> CONFIG_DEBUG_MUTEXES=y
>> CONFIG_DEBUG_LOCK_ALLOC=y
>> CONFIG_PROVE_LOCKING=y
>> CONFIG_LOCKDEP=y
>>
>> Workaround:
>> Interestingly, there is a workaround to avoid this hang. Once I turn
>> on preemption with CONFIG_PREEMPT=y, the issue goes away.
>>
>> Can someone with scheduler expertise help me debug this further?
> 
