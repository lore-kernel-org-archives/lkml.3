Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3KSXXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:23:16 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58504 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3KSXXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:23:10 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>, Dave.Martin@arm.com,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH v3 0/4] Exynos 5410 Dual cluster support
Date: Wed, 20 Nov 2013 00:23:08 +0100
Message-ID: <1951315.Ol55YFu91h@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
References: <1383811969-32712-1-git-send-email-v.tyrtov@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 07 of November 2013 12:12:45 Vyacheslav Tyrtov wrote:
> The series of patches represent support of Exynos 5410 SoC
> 
> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
> Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
> 
> Patches add new platform description, support of clock controller,
> dual cluster support and device tree for Exynos 5410
> 
> Has been build on v3.12.
> Has been tested on Exynos 5410 reference board (exynos_defconfig).

I've applied the patches on top of today's linux-next and tried to boot
my ODROID-XU using exynos5410-smdk5410.dts and exynos_defconfig, but all
I can get is an imprecise external abort, when the kernel tries to jump
to init. Full boot log below. Any ideas?

Best regards,
Tomasz

8><------------

U-Boot 2012.07-g2bcb371 (Nov 19 2013 - 20:17:37) for Exynos5410

CPU: Exynos5410 Rev2.3 [Samsung SOC on SMP Platform Base on ARM CortexA15]
APLL = 900MHz, KPLL = 600MHz
MPLL = 532MHz, BPLL = 800MHz
DRAM:  2 GiB
WARNING: Caches not enabled

TrustZone Enabled BSP
BL1 version: 
PMIC VER : 0, CHIP REV : 6
VDD MIF : 1.00000V
VDD ARM : 1.00000V
VDD INT : 1.00000V
VDD G3D : 1.00000V
VDD KFC : 1.00000V

Checking Boot Mode ... SDMMC
MMC:   S5P_MSHC2: 0, S5P_MSHC0: 1
MMC Device 0: 14.8 GiB
MMC Device 1: [ERROR] response error : 00000006 cmd 8
[ERROR] response error : 00000006 cmd 55
[ERROR] response error : 00000006 cmd 2
In:    serial
Out:   serial
Err:   serial
Net:   No ethernet found.
Press 'Enter' or 'Space' to stop autoboot:  0 
ODROID-XU # 
ODROID-XU # 
ODROID-XU # pri        
baudrate=115200
bootargs=console=ttySAC2,115200n8 earlyprintk ignore_loglevel mem=1G root=/dev/mmcblk0p1 rootwait
bootcmd=run netboot
bootdelay=1
bootfile=uImage.xu
bootscript=source 40008000
copy_uboot_emmc2sd=emmc open 0;movi r z f 0 40000000;emmc close 0;movi w f 1 40000000;emmc open 0;movi r z b 0 40000000;emmc close 0;movi w b 1 40000000;emmc open 0;movi r z u 0 40000000;emmc close 0;movi w u 1 40000000;emmc open 0;movi r z t 0 40000000;emmc close 0;movi w t 1 40000000;mmc write 1 0x40008000 0x4CF 0x20;
copy_uboot_sd2emmc=movi r f 0 40000000;emmc open 1;movi w z f 1 40000000;emmc close 1;movi r b 0 40000000;emmc open 1;movi w z b 1 40000000;emmc close 1;movi r u 0 40000000;emmc open 1;movi w z u 1 40000000;emmc close 1;movi r t 0 40000000;emmc open 1;movi w z t 1 40000000;emmc close 1;mmc write 1 0x40008000 0x4CF 0x20;
default_bootcmd=echo >>> Run Default Bootcmd <<<;movi read kernel 0 40008000;bootz 40008000
ethact=sms0
ipaddr=192.168.1.20
loadbootscript_1=echo >>> Load Boot Script from mmc 0:1 <<<;fatload mmc 0:1 40008000 boot.scr
loadbootscript_2=echo >>> Load Boot Script from mmc 0:2 <<<;fatload mmc 0:2 40008000 boot.scr
loadbootscript_3=echo >>> Load Boot Script from mmc 1:1 <<<;fatload mmc 1:1 40008000 boot.scr
loadbootscript_4=echo >>> Load Boot Script from mmc 1:2 <<<;fatload mmc 1:2 40008000 boot.scr
netboot=usb start && tftpboot 40008000 && bootm 40008000
rootfslen=100000
serverip=192.168.1.2
stderr=serial
stdin=serial
stdout=serial
usbethaddr=00:11:22:33:44:55

Environment size: 1546/16380 bytes
ODROID-XU # run netboot
(Re)start USB...
USB0:   USB EHCI 1.00
scanning bus 0 for devices... 3 USB Device(s) found
       scanning bus for storage devices... 0 Storage Device(s) found
       scanning usb for ethernet devices... 1 Ethernet Device(s) found
Waiting for Ethernet connection... done.
Using sms0 device
TFTP from server 192.168.1.2; our IP address is 192.168.1.20
Filename 'uImage.xu'.
Load address: 0x40008000
Loading: #################################################################
         #################################################################
         #################################################################
         #########
done
Bytes transferred = 2980232 (2d7988 hex)
## Booting kernel from Legacy Image at 40008000 ...
   Image Name:   Linux-exynos5410-odroidxu
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    2980168 Bytes = 2.8 MiB
   Load Address: 50008000
   Entry Point:  50008000
   Verifying Checksum ... OK
   Loading Kernel Image ... OK
OK
  
Starting kernel ...

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.0-next-20131119-00004-g27f3f5f-dirty (tom3q@flatron) (gcc version 4.7.2 (Gentoo 4.7.2-r1 p1.6, pie-0.5.5) ) #11 SMP PREEMPT Wed Nov 20 00:08:02 CET 2013
[    0.000000] CPU: ARMv7 Processor [412fc0f3] revision 3 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine model: Hardkernel ODROID-XU board based on EXYNOS5410
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] CPU EXYNOS5410 (id 0xe5410023)
[    0.000000] On node 0 totalpages: 262144
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 528 pages used for memmap
[    0.000000]   HighMem zone: 67584 pages, LIFO batch:15
[    0.000000] PERCPU: Embedded 7 pages/cpu @c07e4000 s7552 r8192 d12928 u32768
[    0.000000] pcpu-alloc: s7552 r8192 d12928 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260624
[    0.000000] Kernel command line: console=ttySAC2,115200n8 earlyprintk ignore_loglevel mem=1G root=/dev/mmcblk0p1 rootwait
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 1033268K/1048576K available (3860K kernel code, 254K rwdata, 1300K rodata, 231K init, 288K bss, 15308K reserved, 270336K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0512398   (5161 kB)
[    0.000000]       .init : 0xc0513000 - 0xc054cd80   ( 232 kB)
[    0.000000]       .data : 0xc054e000 - 0xc058d9e0   ( 255 kB)
[    0.000000]        .bss : 0xc058d9ec - 0xc05d5aa8   ( 289 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] sched_clock: 32 bits at 200 Hz, resolution 5000000ns, wraps every 10737418240000000ns
[    0.000000] Console: colour dummy device 80x30
[    0.000000] allocated 2097152 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.020000] Calibrating delay loop... 1785.85 BogoMIPS (lpj=4464640)
[    0.045000] pid_max: default: 32768 minimum: 301
[    0.050000] Mount-cache hash table entries: 512
[    0.055000] Initializing cgroup subsys memory
[    0.060000] Initializing cgroup subsys devices
[    0.065000] Initializing cgroup subsys freezer
[    0.070000] Initializing cgroup subsys blkio
[    0.075000] CPU: Testing write buffer coherency: ok
[    0.080000] CPU0: update cpu_power 1468
[    0.085000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.090000] Setting up static identity map for 0x503a9c48 - 0x503a9ca0
[    0.095000] ARM CCI driver probed
[    0.100000] EDCS power management initialized
[    0.135000] CPU1: Booted secondary processor
[    0.175000] CPU1: update cpu_power 1468
[    0.175000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.185000] CPU2: Booted secondary processor
[    0.225000] CPU2: update cpu_power 1468
[    0.225000] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.235000] CPU3: Booted secondary processor
[    0.275000] CPU3: update cpu_power 1468
[    0.275000] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    1.285000] CPU4: failed to come online
[    2.300000] CPU5: failed to come online
[    3.310000] CPU6: failed to come online
[    4.320000] CPU7: failed to come online
[    4.320000] Brought up 4 CPUs
[    4.325000] SMP: Total of 4 processors activated.
[    4.330000] CPU: All CPU(s) started in SVC mode.
[    4.335000] devtmpfs: initialized
[    4.345000] VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
[    4.350000] pinctrl core: initialized pinctrl subsystem
[    4.355000] regulator-dummy: no parameters
[    4.355000] NET: Registered protocol family 16
[    4.360000] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    4.370000] S3C Power Management, Copyright 2004 Simtec Electronics
[    4.375000] EXYNOS: PMU not supported
[    4.380000] EXYNOS: Initializing architecture
[    4.395000] bio: create slab <bio-0> at 0
[    4.405000] SCSI subsystem initialized
[    4.405000] usbcore: registered new interface driver usbfs
[    4.410000] usbcore: registered new interface driver hub
[    4.420000] usbcore: registered new device driver usb
[    4.425000] Switched to clocksource mct-frc
[    4.440000] NET: Registered protocol family 2
[    4.445000] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    4.455000] TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
[    4.460000] TCP: Hash tables configured (established 8192 bind 8192)
[    4.465000] TCP: reno registered
[    4.470000] UDP hash table entries: 512 (order: 2, 24576 bytes)
[    4.475000] UDP-Lite hash table entries: 512 (order: 2, 24576 bytes)
[    4.485000] NET: Registered protocol family 1
[    4.490000] audit: initializing netlink socket (disabled)
[    4.495000] type=2000 audit(4.495:1): initialized
[    4.500000] bounce pool size: 64 pages
[    4.520000] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.525000] msgmni has been set to 1490
[    4.530000] io scheduler noop registered
[    4.530000] io scheduler deadline registered (default)
[    4.535000] io scheduler cfq registered
[    4.655000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.665000] 12c00000.serial: ttySAC0 at MMIO 0x12c00000 (irq = 83, base_baud = 0) is a S3C6400/10
[    4.675000] 12c10000.serial: ttySAC1 at MMIO 0x12c10000 (irq = 84, base_baud = 0) is a S3C6400/10
[    4.680000] console [tt[SAC2] enabled
    4.680000] console [ttySAC2] enabled
[    4.690000] bootconsole [early[on0] disabled
    4.690000] bootconsole [earlycon0] disabled
[    4.700000] 12c30000.serial: ttySAC3 at MMIO 0x12c30000 (irq = 86, base_baud = 0) is a S3C6400/10
[    4.715000] brd: module loaded
[    4.720000] loop: module loaded
[    4.725000] usbcore: registered new interface driver asix
[    4.730000] usbcore: registered new interface driver ax88179_178a
[    4.735000] usbcore: registered new interface driver cdc_ether
[    4.740000] usbcore: registered new interface driver r815x
[    4.745000] usbcore: registered new interface driver smsc75xx
[    4.755000] usbcore: registered new interface driver smsc95xx
[    4.760000] usbcore: registered new interface driver net1080
[    4.765000] usbcore: registered new interface driver cdc_subset
[    4.770000] usbcore: registered new interface driver zaurus
[    4.775000] usbcore: registered new interface driver cdc_ncm
[    4.780000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.790000] usbcore: registered new interface driver usb-storage
[    4.795000] mousedev: PS/2 mouse device common for all mice
[    4.800000] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    4.810000] sdhci: Secure Digital Host Controller Interface driver
[    4.815000] sdhci: Copyright(c) Pierre Ossman
[    4.820000] Synopsys Designware Multimedia Card Interface Driver
[    4.825000] dwmmc_exynos 12200000.mmc: dummy supplies not allowed
[    4.830000] dwmmc_exynos 12200000.mmc: no vmmc regulator found: -19
[    4.835000] dwmmc_exynos 12200000.mmc: Using internal DMA controller.
[    4.845000] dwmmc_exynos 12200000.mmc: Version ID is 241a
[    4.850000] dwmmc_exynos 12200000.mmc: DW MMC controller at irq 107, 64 bit host data width, 128 deep fifo
[    4.860000] of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12200000/slot@0[0]'
[    4.895000] dwmmc_exynos 12200000.mmc: 1 slots initialized
[    4.895000] dwmmc_exynos 12220000.mmc: dummy supplies not allowed
[    4.905000] dwmmc_exynos 12220000.mmc: no vmmc regulator found: -19
[    4.910000] dwmmc_exynos 12220000.mmc: Using internal DMA controller.
[    4.915000] dwmmc_exynos 12220000.mmc: Version ID is 241a
[    4.920000] dwmmc_exynos 12220000.mmc: DW MMC controller at irq 109, 64 bit host data width, 128 deep fifo
[    4.930000] of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12220000/slot@0[0]'
[    4.970000] dwmmc_exynos 12220000.mmc: 1 slots initialized
[    4.975000] usbcore: registered new interface driver usbhid
[    4.980000] usbhid: USB HID core driver
[    4.980000] TCP: cubic registered
[    4.985000] NET: Registered protocol family 17
[    4.990000] NET: Registered protocol family 15
[    4.995000] Registering SWP/SWPB emulation handler
[    5.000000] registered taskstats version 1
[    5.005000] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    5.010000] Waiting for root device /dev/mmcblk0p1...
[    5.025000] mmc_host mmc1: Bus speed (slot 0) = 50000000Hz (slot req 25000000Hz, actual 25000000HZ div = 1)
[    5.035000] mmc1: new SDHC card at address e624
[    5.040000] isa bounce pool size: 16 pages
[    5.045000] mmcblk0: mmc1:e624 SU16G 14.8 GiB 
[    5.050000]  mmcblk0: p1
[    5.120000] EXT3-fs (mmcblk0p1): error: couldn't mount because of unsupported optional features (240)
[    5.125000] EXT2-fs (mmcblk0p1): error: couldn't mount because of unsupported optional features (240)
[    5.145000] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data mode. Opts: (null)
[    5.150000] VFS: Mounted root (ext4 filesystem) readonly on device 179:1.
[    5.165000] devtmpfs: mounted
[    5.170000] Freeing unused kernel memory: 228K (c0513000 - c054c000)
[    5.195000] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
[    5.210000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007
[    5.210000] 
[    5.210000] CPU: 2 PID: 1 Comm: init Not tainted 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
[    5.210000] [<c0014068>] (unwind_backtrace+0x0/0xf8) from [<c0011438>] (show_stack+0x10/0x14)
[    5.210000] [<c0011438>] (show_stack+0x10/0x14) from [<c03a486c>] (dump_stack+0x7c/0xbc)
[    5.210000] [<c03a486c>] (dump_stack+0x7c/0xbc) from [<c03a1e78>] (panic+0x8c/0x1e4)
[    5.210000] [<c03a1e78>] (panic+0x8c/0x1e4) from [<c001f504>] (do_exit+0x850/0x920)
[    5.210000] [<c001f504>] (do_exit+0x850/0x920) from [<c001f63c>] (do_group_exit+0x3c/0xb0)
[    5.210000] [<c001f63c>] (do_group_exit+0x3c/0xb0) from [<c0029e1c>] (get_signal_to_deliver+0x1d4/0x538)
[    5.210000] [<c0029e1c>] (get_signal_to_deliver+0x1d4/0x538) from [<c0010974>] (do_signal+0x100/0x40c)
[    5.210000] [<c0010974>] (do_signal+0x100/0x40c) from [<c0010fb4>] (do_work_pending+0x68/0xa8)
[    5.210000] [<c0010fb4>] (do_work_pending+0x68/0xa8) from [<c000e620>] (work_pending+0xc/0x20)
[    5.300000] CPU3: stopping
[    5.300000] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
[    5.300000] [<c0014068>] (unwind_backtrace+0x0/0xf8) from [<c0011438>] (show_stack+0x10/0x14)
[    5.300000] [<c0011438>] (show_stack+0x10/0x14) from [<c03a486c>] (dump_stack+0x7c/0xbc)
[    5.300000] [<c03a486c>] (dump_stack+0x7c/0xbc) from [<c00132e0>] (handle_IPI+0x130/0x15c)
[    5.300000] [<c00132e0>] (handle_IPI+0x130/0x15c) from [<c000859c>] (gic_handle_irq+0x60/0x68)
[    5.300000] [<c000859c>] (gic_handle_irq+0x60/0x68) from [<c0011f00>] (__irq_svc+0x40/0x70)
[    5.300000] Exception stack(0xef29ff80 to 0xef29ffc8)
[    5.300000] ff80: c07fc558 00000000 0093a607 00000000 00000000 00000000 c054b558 002b1000
[    5.300000] ffa0: 60000113 00000001 c07fc558 ef29e000 c0556438 ef29ffc8 c0064254 c0064258
[    5.300000] ffc0: 60000113 ffffffff
[    5.300000] [<c0011f00>] (__irq_svc+0x40/0x70) from [<c0064258>] (rcu_idle_exit+0x5c/0xb0)
[    5.300000] [<c0064258>] (rcu_idle_exit+0x5c/0xb0) from [<c005b4a4>] (cpu_startup_entry+0x68/0x148)
[    5.300000] [<c005b4a4>] (cpu_startup_entry+0x68/0x148) from [<50008644>] (0x50008644)
[    5.300000] CPU1: stopping
[    5.300000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
[    5.300000] [<c0014068>] (unwind_backtrace+0x0/0xf8) from [<c0011438>] (show_stack+0x10/0x14)
[    5.300000] [<c0011438>] (show_stack+0x10/0x14) from [<c03a486c>] (dump_stack+0x7c/0xbc)
[    5.300000] [<c03a486c>] (dump_stack+0x7c/0xbc) from [<c00132e0>] (handle_IPI+0x130/0x15c)
[    5.300000] [<c00132e0>] (handle_IPI+0x130/0x15c) from [<c000859c>] (gic_handle_irq+0x60/0x68)
[    5.300000] [<c000859c>] (gic_handle_irq+0x60/0x68) from [<c0011f00>] (__irq_svc+0x40/0x70)
[    5.300000] Exception stack(0xef29bf80 to 0xef29bfc8)
[    5.300000] SMP: failed to stop secondary CPUs
[    5.465000] bf80: c07ec558 00000000 00938a81 00000000 00000000 00000000 c054b558 002a1000
[    5.475000] bfa0: 60000113 00000001 c07ec558 ef29a000 5572448d ef29bfc8 c0064254 c0064258
[    5.480000] bfc0: 60000113 ffffffff
[    5.485000] [<c0011f00>] (__irq_svc+0x40/0x70) from [<c0064258>] (rcu_idle_exit+0x5c/0xb0)
[    5.495000] [<c0064258>] (rcu_idle_exit+0x5c/0xb0) from [<c005b4a4>] (cpu_startup_entry+0x68/0x148)
[    5.505000] [<c005b4a4>] (cpu_startup_entry+0x68/0x148) from [<50008644>] (0x50008644)
[    5.510000] CPU0: stopping
[    5.515000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-next-20131119-00004-g27f3f5f-dirty #11
[    5.525000] [<c0014068>] (unwind_backtrace+0x0/0xf8) from [<c0011438>] (show_stack+0x10/0x14)
[    5.530000] [<c0011438>] (show_stack+0x10/0x14) from [<c03a486c>] (dump_stack+0x7c/0xbc)
[    5.540000] [<c03a486c>] (dump_stack+0x7c/0xbc) from [<c00132e0>] (handle_IPI+0x130/0x15c)
[    5.550000] [<c00132e0>] (handle_IPI+0x130/0x15c) from [<c000859c>] (gic_handle_irq+0x60/0x68)
[    5.555000] [<c000859c>] (gic_handle_irq+0x60/0x68) from [<c0011f00>] (__irq_svc+0x40/0x70)
[    5.565000] Exception stack(0xc054ff60 to 0xc054ffa8)
[    5.570000] ff60: c07e4558 00000000 00001796 00000000 c054e000 c05564b8 c03ab8d4 c054e000
[    5.580000] ff80: c058d3d5 00000001 c058d3d5 c054e000 55529a03 c054ffa8 c000f18c c000f190
[    5.585000] ffa0: 60000113 ffffffff
[    5.590000] [<c0011f00>] (__irq_svc+0x40/0x70) from [<c000f190>] (arch_cpu_idle+0x28/0x30)
[    5.600000] [<c000f190>] (arch_cpu_idle+0x28/0x30) from [<c005b494>] (cpu_startup_entry+0x58/0x148)
[    5.605000] [<c005b494>] (cpu_startup_entry+0x58/0x148) from [<c0513b28>] (start_kernel+0x384/0x3e4)

