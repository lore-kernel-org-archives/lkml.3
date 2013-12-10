Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3LJQkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:40:49 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54619 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3LJQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:40:43 -0500
From: Kevin Hilman <khilman@linaro.org>
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
        nicolas.pitre@linaro.org, tomasz.figa@gmail.com
Subject: Re: [PATCH v5 0/3] Exynos 5410 support
References: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
Date: Tue, 10 Dec 2013 08:40:39 -0800
In-Reply-To: <1386685599-31536-1-git-send-email-v.tyrtov@samsung.com>
	(Vyacheslav Tyrtov's message of "Tue, 10 Dec 2013 18:26:36 +0400")
Message-ID: <87ppp48xrs.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vyacheslav Tyrtov <v.tyrtov@samsung.com> writes:

> The series of patches represent support of Exynos 5410 SoC
>
> The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture
>
> Patches add new platform description, support of clock controller and device 
> tree for Exynos 5410.
>
> Dual cluster support for Exynos 5410 (EDCS) has been removed from this series 
> This patches is activating only the big cluster (all A15 cores)

Testing this series on top of v3.13-rc3, plus a couple of other
necessary changes (which should've probably been noted in the changelog):

1) change CONFIG_NR_CPUS=8 in .config
2) add the exynos combiner patch from Chander:
   [PATCH v2] irqchip: exynos-combiner: remove hard-coded irq_base value

I'm still only seeing 2 out of 4 cores come up on my odroid-xu:

[    0.045000] CPU: Testing write buffer coherency: ok
[    0.045000] CPU0: update cpu_power 1024
[    0.045000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.045000] Setting up static identity map for 0x403717d8 - 0x40371830
[    0.045000] CPU1: Booted secondary processor
[    0.065000] CPU1: update cpu_power 1024
[    0.065000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    1.075000] CPU2: failed to boot: -38
[    2.075000] CPU3: failed to boot: -38
[    2.075000] Brought up 2 CPUs
[    2.075000] SMP: Total of 2 processors activated.
[    2.075000] CPU: All CPU(s) started in SVC mode.

Full boot log below.

Kevin


Connected to odroid-xu console [channel connected] (~$quit to exit)
(user:khilman) is already connected
(user:khilman) is already connected

~$hardreset

/ # 
Command(odroid-xu console)> hardreset
(user:khilman) Reboot odroid-xu
.~;+wQt.

U-Boot 2012.07-g3de3ad26283f (Nov 19 2013 - 13:47:04) for Exynos5410

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
MMC Device 0: 7.4 GiB
MMC Device 1: [ERROR] response error : 00000006 cmd 8
[ERROR] response error : 00000006 cmd 55
[ERROR] response error : 00000006 cmd 2
In:    serial
Out:   serial
Err:   serial
Net:   No ethernet found.
Press 'Enter' or 'Space' to stop autoboot:  3 
 0 
ODROID-XU # 
ODROID-XU # version
version

U-Boot 2012.07-g3de3ad26283f (Nov 19 2013 - 13:47:04) for Exynos5410
arm-linux-gnueabi-gcc (Ubuntu/Linaro 4.7.2-1ubuntu1) 4.7.2
GNU ld (GNU Binutils for Ubuntu) 2.22.90.20120919
ODROID-XU # setenv preboot usb start
setenv preboot usb start
ODROID-XU # setenv bootargs console=ttySAC2,115200n8 debug earlyprintk
setenv bootargs console=ttySAC2,115200n8 debug earlyprintk
ODROID-XU # if test -n ${initenv}; then run initenv; fi
if test -n ${initenv}; then run initenv; fi
ODROID-XU # if test -n ${preboot}; then run preboot; fi
if test -n ${preboot}; then run preboot; fi
(Re)start USB...
USB0:   USB EHCI 1.00
scanning bus 0 for devices... 3 USB Device(s) found
       scanning bus for storage devices... 0 Storage Device(s) found
       scanning usb for ethernet devices... 1 Ethernet Device(s) found
ODROID-XU # setenv autoload no; setenv autoboot no
setenv autoload no; setenv autoboot no
ODROID-XU # dhcp
dhcp
Waiting for Ethernet connection... done.
BOOTP broadcast 1
DHCP client bound to address 192.168.1.187
ODROID-XU # setenv serverip 192.168.1.2
setenv serverip 192.168.1.2
ODROID-XU # if test -n ${netargs}; then run netargs; fi
if test -n ${netargs}; then run netargs; fi
ODROID-XU # tftp 0x40800000 tmp/odroid-xu-erdIn8/tmp9D1Cmd-uImage
tftp 0x40800000 tmp/odroid-xu-erdIn8/tmp9D1Cmd-uImage
Waiting for Ethernet connection... done.
Using sms0 device
TFTP from server 192.168.1.2; our IP address is 192.168.1.187
Filename 'tmp/odroid-xu-erdIn8/tmp9D1Cmd-uImage'.
Load address: 0x40800000
Loading: *#################################################################
	 #################################################################
	 ##########################################################
done
Bytes transferred = 2745780 (29e5b4 hex)
ODROID-XU # tftp 0x42000000 buildroot.cpio.gz.uboot
tftp 0x42000000 buildroot.cpio.gz.uboot
Waiting for Ethernet connection... done.
Using sms0 device
TFTP from server 192.168.1.2; our IP address is 192.168.1.187
Filename 'buildroot.cpio.gz.uboot'.
Load address: 0x42000000
Loading: *############################################
done
Bytes transferred = 639808 (9c340 hex)
ODROID-XU # printenv bootargs
printenv bootargs
bootargs=console=ttySAC2,115200n8 debug earlyprintk
ODROID-XU # bootm 0x40800000 0x42000000 
bootm 0x40800000 0x42000000 
## Booting kernel from Legacy Image at 40800000 ...
   Image Name:   Linux
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    2745716 Bytes = 2.6 MiB
   Load Address: 40008000
   Entry Point:  40008000
   Verifying Checksum ... OK
## Loading init Ramdisk from Legacy Image at 42000000 ...
   Image Name:   
   Image Type:   ARM Linux RAMDisk Image (uncompressed)
   Data Size:    639744 Bytes = 624.8 KiB
   Load Address: 81000000
   Entry Point:  81000000
   Verifying Checksum ... OK
   Loading Kernel Image ... OK
OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.13.0-rc3-linaro-00004-g0a685036323f (khilman@paris) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-1ubuntu1) ) #4 SMP PREEMPT Tue Dec 10 08:35:04 PST 2013
[    0.000000] CPU: ARMv7 Processor [412fc0f3] revision 3 (ARMv7), cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] Machine model: Samsung SMDK5410 board based on EXYNOS5410
[    0.000000] NR_BANKS too low, ignoring high memory
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] CPU EXYNOS5410 (id 0xe5410023)
[    0.000000] On node 0 totalpages: 521728
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2572 pages used for memmap
[    0.000000]   HighMem zone: 327168 pages, LIFO batch:31
[    0.000000] PERCPU: Embedded 7 pages/cpu @c0779000 s7424 r8192 d13056 u32768
[    0.000000] pcpu-alloc: s7424 r8192 d13056 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520208
[    0.000000] Kernel command line: console=ttySAC2,115200n8 debug earlyprintk
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 2063404K/2086912K available (3629K kernel code, 228K rwdata, 1120K rodata, 227K init, 268K bss, 23508K reserved, 1308672K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc04ab7b4   (4750 kB)
[    0.000000]       .init : 0xc04ac000 - 0xc04e4d00   ( 228 kB)
[    0.000000]       .data : 0xc04e6000 - 0xc051f0e0   ( 229 kB)
[    0.000000]        .bss : 0xc051f0ec - 0xc05623bc   ( 269 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] sched_clock: 32 bits at 200 Hz, resolution 5000000ns, wraps every 10737418240000000ns
[    0.000000] Console: colour dummy device 80x30
[    0.045000] Calibrating delay loop... 1785.85 BogoMIPS (lpj=4464640)
[    0.045000] pid_max: default: 32768 minimum: 301
[    0.045000] Mount-cache hash table entries: 512
[    0.045000] CPU: Testing write buffer coherency: ok
[    0.045000] CPU0: update cpu_power 1024
[    0.045000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.045000] Setting up static identity map for 0x403717d8 - 0x40371830
[    0.045000] CPU1: Booted secondary processor
[    0.065000] CPU1: update cpu_power 1024
[    0.065000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    1.075000] CPU2: failed to boot: -38
[    2.075000] CPU3: failed to boot: -38
[    2.075000] Brought up 2 CPUs
[    2.075000] SMP: Total of 2 processors activated.
[    2.075000] CPU: All CPU(s) started in SVC mode.
[    2.075000] devtmpfs: initialized
[    2.080000] VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
[    2.080000] pinctrl core: initialized pinctrl subsystem
[    2.080000] regulator-dummy: no parameters
[    2.080000] NET: Registered protocol family 16
[    2.080000] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    2.085000] S3C Power Management, Copyright 2004 Simtec Electronics
[    2.085000] EXYNOS: PMU not supported
[    2.085000] EXYNOS: Initializing architecture
[    2.100000] bio: create slab <bio-0> at 0
[    2.100000] SCSI subsystem initialized
[    2.100000] usbcore: registered new interface driver usbfs
[    2.100000] usbcore: registered new interface driver hub
[    2.100000] usbcore: registered new device driver usb
[    2.105000] Switched to clocksource mct-frc
[    2.120000] NET: Registered protocol family 2
[    2.120000] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    2.120000] TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
[    2.120000] TCP: Hash tables configured (established 8192 bind 8192)
[    2.120000] TCP: reno registered
[    2.120000] UDP hash table entries: 512 (order: 2, 24576 bytes)
[    2.120000] UDP-Lite hash table entries: 512 (order: 2, 24576 bytes)
[    2.125000] NET: Registered protocol family 1
[    2.125000] Trying to unpack rootfs image as initramfs...
[    2.170000] Freeing initrd memory: 620K (c2001000 - c209c000)
[    2.175000] bounce pool size: 64 pages
[    2.185000] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.185000] msgmni has been set to 1475
[    2.185000] io scheduler noop registered
[    2.185000] io scheduler deadline registered
[    2.185000] io scheduler cfq registered (default)
[    2.280000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.285000] 12c00000.serial: ttySAC0 at MMIO 0x12c00000 (irq = 83, base_baud = 0) is a S3C6400/10
[    2.285000] 12c10000.serial: ttySAC1 at MMIO 0x12c10000 (irq = 84, base_baud = 0) is a S3C6400/10
[    2.285000] 12c20000.serial: ttySAC2 at MMIO 0x12c20000 (irq = 85, base_baud = 0) is a S3C6400/10
[    2.780000] console [ttySAC2] enabled
[    2.785000] 12c30000.serial: ttySAC3 at MMIO 0x12c30000 (irq = 86, base_baud = 0) is a S3C6400/10
[    2.805000] brd: module loaded
[    2.810000] loop: module loaded
[    2.810000] usbcore: registered new interface driver asix
[    2.815000] usbcore: registered new interface driver ax88179_178a
[    2.825000] usbcore: registered new interface driver cdc_ether
[    2.830000] usbcore: registered new interface driver r815x
[    2.835000] usbcore: registered new interface driver smsc75xx
[    2.840000] usbcore: registered new interface driver smsc95xx
[    2.845000] usbcore: registered new interface driver net1080
[    2.850000] usbcore: registered new interface driver cdc_subset
[    2.855000] usbcore: registered new interface driver zaurus
[    2.865000] usbcore: registered new interface driver cdc_ncm
[    2.870000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.875000] usbcore: registered new interface driver usb-storage
[    2.880000] mousedev: PS/2 mouse device common for all mice
[    2.890000] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    2.895000] sdhci: Secure Digital Host Controller Interface driver
[    2.900000] sdhci: Copyright(c) Pierre Ossman
[    2.905000] Synopsys Designware Multimedia Card Interface Driver
[    2.910000] dwmmc_exynos dwmmc0.0: invalid resource
[    2.915000] dwmmc_exynos: probe of dwmmc0.0 failed with error -22
[    2.920000] dwmmc_exynos dwmmc1.1: invalid resource
[    2.925000] dwmmc_exynos: probe of dwmmc1.1 failed with error -22
[    2.935000] dwmmc_exynos dwmmc2.2: invalid resource
[    2.940000] dwmmc_exynos: probe of dwmmc2.2 failed with error -22
[    2.945000] dwmmc_exynos 12200000.mmc: dummy supplies not allowed
[    2.950000] dwmmc_exynos 12200000.mmc: no vmmc regulator found: -19
[    2.955000] dwmmc_exynos 12200000.mmc: Using internal DMA controller.
[    2.965000] dwmmc_exynos 12200000.mmc: Version ID is 241a
[    2.970000] dwmmc_exynos 12200000.mmc: DW MMC controller at irq 107, 64 bit host data width, 128 deep fifo
[    2.980000] of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12200000/slot@0[0]'
[    3.015000] dwmmc_exynos 12200000.mmc: 1 slots initialized
[    3.015000] dwmmc_exynos 12220000.mmc: dummy supplies not allowed
[    3.025000] dwmmc_exynos 12220000.mmc: no vmmc regulator found: -19
[    3.030000] dwmmc_exynos 12220000.mmc: Using internal DMA controller.
[    3.035000] dwmmc_exynos 12220000.mmc: Version ID is 241a
[    3.040000] dwmmc_exynos 12220000.mmc: DW MMC controller at irq 109, 64 bit host data width, 128 deep fifo
[    3.050000] of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12220000/slot@0[0]'
[    3.090000] dwmmc_exynos 12220000.mmc: 1 slots initialized
[    3.095000] usbcore: registered new interface driver usbhid
[    3.100000] usbhid: USB HID core driver
[    3.100000] TCP: cubic registered
[    3.105000] NET: Registered protocol family 17
[    3.110000] NET: Registered protocol family 15
[    3.115000] Registering SWP/SWPB emulation handler
[    3.120000] /work/kernel/linaro/dev/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    3.130000] Freeing unused kernel memory: 224K (c04ac000 - c04e4000)
Starting logging: [    3.155000] mmc_host mmc1: Bus speed (slot 0) = 50000000Hz (slot req 50000000Hz, actual 50000000HZ div = 0)
[    3.165000] mmc1: new high speed SDHC card at address e624
OK
Initializing rand[    3.170000] isa bounce pool size: 16 pages
om number gene[    3.180000] mmcblk0: mmc1:e624 SU08G 7.40 GiB 
rator... [    3.185000]  mmcblk0: p1 p2
[    3.185000] random: dd urandom read with 13 bits of entropy available
done.
Starting network...
mount: mounting none on /sys/kernel/debug failed: No such file or directory
/bin/sh: can't access tty; job control turned off
/ # cat /proc/cmdline
cat /proc/cmdline
console=ttySAC2,115200n8 debug earlyprintk
/ # uname -r
uname -r
3.13.0-rc3-linaro-00004-g0a685036323f
/ # cat /proc/cpuinfo
cat /proc/cpuinfo
processor	: 0
model name	: ARMv7 Processor rev 3 (v7l)
Features	: swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x2
CPU part	: 0xc0f
CPU revision	: 3

processor	: 1
model name	: ARMv7 Processor rev 3 (v7l)
Features	: swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x2
CPU part	: 0xc0f
CPU revision	: 3

Hardware	: SAMSUNG EXYNOS5 (Flattened Device Tree)
Revision	: 0000
Serial		: 0000000000000000
/ # ip -f inet -o addr
ip -f inet -o addr
1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever
/ # # PYBOOT: Time: 22.81 seconds.
# PYBOOT: Result: PASS
