Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965517AbaDJIFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:05:09 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34461 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934697AbaDJIEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:04:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140409160108.GU16119@n2100.arm.linux.org.uk>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
	<20140409151326.GY29751@pengutronix.de>
	<20140409152711.GT16119@n2100.arm.linux.org.uk>
	<5844640.QRALKyBQaa@wuerfel>
	<20140409160108.GU16119@n2100.arm.linux.org.uk>
Date: Thu, 10 Apr 2014 10:04:54 +0200
Message-ID: <CACmBeS3YwapANCOL5YuNSLUjPis3CdeeKA9ohyvJxOkyQbJDtQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 18:01, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> It would be useful to see the register state from the undefined
> instruction exception.  That needs this patch, CONFIG_DEBUG_USER in the
> kernel config enabled, and user_debug=1 passed on the kernel command
> line.

I have done two tests, one with user_debug=1, and one with
user_debug=31, since I expected more information on user_debug=1.

As Arnd pointed out, this is booting into a non-thumb userspace, built
with gcc version 4.9.0 20140316 and buildroot 2014.02.

Buildroot config:
https://code.google.com/p/mkrom-uc7112lx/source/browse/configs/buildroot-2014-02_eglibc-2.17_binutils-2.22_external-toolchain.config

Results:

user_debug=1 ( https://bitbucket.org/Kasreyn/linux-next/commits/3a32b929d7a399751c6397f0c973b356c6c9a71d
):

    Uncompressing Linux... done, booting the kernel.
    [    0.000000] Booting Linux on physical CPU 0x0
    [    0.000000] Linux version 3.14.0-next-20140409+ (i@Ildjarn)
(gcc version 4.9.0 20140316 (experimental) (crosstool-NG 1.19.0) )
#2431 PREEMPT Thu Apr 10 09:12:35 CEST 2014
..
    [    0.000000] Kernel command line: console=ttyS0,115200n8
earlyprintk root=/dev/mmcblk0p1 rw rootwait debug user_debug=1
..
    [    2.700000] Freeing unused kernel memory: 104K (c02f4000 - c030e000)
    [    3.380000] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
    [    3.380000]
    [    3.380000] CPU: 0 PID: 1 Comm: init Not tainted
3.14.0-next-20140409+ #2431
    [    3.380000] [<c000d4e0>] (unwind_backtrace) from [<c000bcbc>]
(show_stack+0x10/0x14)
    [    3.380000] [<c000bcbc>] (show_stack) from [<c0268f74>]
(panic+0x98/0x1f4)
    [    3.380000] [<c0268f74>] (panic) from [<c0016bcc>] (do_exit+0x908/0x938)
    [    3.380000] [<c0016bcc>] (do_exit) from [<c0016c70>]
(do_group_exit+0x4c/0xe8)
    [    3.380000] [<c0016c70>] (do_group_exit) from [<c0022098>]
(get_signal_to_deliver+0x218/0x5f0)
    [    3.380000] [<c0022098>] (get_signal_to_deliver) from
[<c000b358>] (do_signal+0x100/0x48c)
    [    3.380000] [<c000b358>] (do_signal) from [<c000b8ac>]
(do_work_pending+0xd4/0xe4)
    [    3.380000] [<c000b8ac>] (do_work_pending) from [<c000933c>]
(work_pending+0xc/0x20)
    [    3.380000] Rebooting in 10 seconds..

user_debug=31 (
https://bitbucket.org/Kasreyn/linux-next/commits/8ed2db951baca29c6254de328765873fe5457727
):

    [    0.000000] Booting Linux on physical CPU 0x0
    [    0.000000] Linux version 3.14.0-next-20140409+ (i@Ildjarn)
(gcc version 4.9.0 20140316 (experimental) (crosstool-NG 1.19.0) )
#2431 PREEMPT Thu Apr 10 09:12:35 CEST 2014
    [    0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
    [    0.000000] CPU: VIVT data cache, VIVT instruction cache
    [    0.000000] Machine model: MOXA UC-7112-LX
    [    0.000000] bootconsole [earlycon0] enabled
    [    0.000000] Memory policy: Data cache writeback
    [    0.000000] On node 0 totalpages: 8192
    [    0.000000] free_area_init_node: node 0, pgdat c0322324,
node_mem_map c1fba000
    [    0.000000]   Normal zone: 64 pages used for memmap
    [    0.000000]   Normal zone: 0 pages reserved
    [    0.000000]   Normal zone: 8192 pages, LIFO batch:0
    [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
    [    0.000000] pcpu-alloc: [0] 0
    [    0.000000] Built 1 zonelists in Zone order, mobility grouping
on.  Total pages: 8128
    [    0.000000] Kernel command line: console=ttyS0,115200n8
earlyprintk root=/dev/mmcblk0p1 rw rootwait debug user_debug=31
    [    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
    [    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
    [    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
    [    0.000000] Memory: 29092K/32768K available (2542K kernel code,
74K rwdata, 448K rodata, 104K init, 116K bss, 3676K reserved)
    [    0.000000] Virtual kernel memory layout:
    [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    [    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    [    0.000000]     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
    [    0.000000]     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
    [    0.000000]       .text : 0xc0008000 - 0xc02f3d80   (2992 kB)
    [    0.000000]       .init : 0xc02f4000 - 0xc030e36c   ( 105 kB)
    [    0.000000]       .data : 0xc0310000 - 0xc0322aa0   (  75 kB)
    [    0.000000]        .bss : 0xc0322aac - 0xc033fbc0   ( 117 kB)
    [    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
    [    0.000000] Preemptible hierarchical RCU implementation.
    [    0.000000] NR_IRQS:16 nr_irqs:16 16
    [    0.000000] sched_clock: 32 bits at 100 Hz, resolution
10000000ns, wraps every 21474836480000000ns
    [    0.010000] Calibrating delay loop... 146.84 BogoMIPS (lpj=734208)
    [    0.100000] pid_max: default: 4096 minimum: 301
    [    0.100000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
    [    0.110000] Mountpoint-cache hash table entries: 1024 (order:
0, 4096 bytes)
    [    0.120000] CPU: Testing write buffer coherency: ok
    [    0.130000] Setting up static identity map for 0x26e308 - 0x26e390
    [    0.150000] devtmpfs: initialized
    [    0.160000] NET: Registered protocol family 16
    [    0.180000] DMA: preallocated 256 KiB pool for atomic coherent
allocations
    [    0.330000] Switched to clocksource moxart_timer
    [    0.370000] NET: Registered protocol family 2
    [    0.390000] TCP established hash table entries: 1024 (order: 0,
4096 bytes)
    [    0.410000] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
    [    0.410000] TCP: Hash tables configured (established 1024 bind 1024)
    [    0.430000] TCP: reno registered
    [    0.430000] UDP hash table entries: 256 (order: 0, 4096 bytes)
    [    0.450000] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
    [    0.470000] NET: Registered protocol family 1
    [    0.490000] futex hash table entries: 16 (order: -5, 192 bytes)
    [    0.590000] jffs2: version 2.2. (NAND) Â© 2001-2006 Red Hat, Inc.
    [    0.610000] msgmni has been set to 56
    [    0.610000] io scheduler noop registered
    [    0.640000] io scheduler cfq registered (default)
    [    0.640000] gpiochip_add: registered GPIOs 0 to 31 on device: moxart-gpio
    [    0.660000] Serial: 8250/16550 driver, 3 ports, IRQ sharing enabled
    [    0.690000] console [ttyS0] disabled
    [    0.690000] 98200000.uart: ttyS0 at MMIO 0x98200000 (irq = 21,
base_baud = 921600) is a 16550A
    [    0.700000] console [ttyS0] enabled
    [    0.700000] console [ttyS0] enabled
    [    0.710000] bootconsole [earlycon0] disabled
    [    0.710000] bootconsole [earlycon0] disabled
    [    0.720000] MOXA Smartio/Industio family driver version 2.0.5
    [    0.730000] mxser: found MOXA UC-7112-LX board (CAP=0x0)
    [    0.740000] ttyMX0 at I/O 0xf9820040 (irq = 21, base_baud = 0)
is a 16550A
    [    0.750000] ttyMX1 at I/O 0xf9820060 (irq = 21, base_baud = 0)
is a 16550A
    [    0.760000] mxser: mxser_initbrd success IRQ=21 max baud=921600 bps
    [    0.820000] loop: module loaded
    [    0.860000] 80000000.flash: Found 1 x16 devices at 0x0 in
16-bit bank. Manufacturer ID 0x000089 Chip ID 0x000018
    [    0.870000] Intel/Sharp Extended Query Table at 0x0031
    [    0.880000] Intel/Sharp Extended Query Table at 0x0031
    [    0.890000] Using buffer write method
    [    0.890000] cfi_cmdset_0001: Erase suspend on write enabled
    [    0.900000] erase region 0: offset=0x0,size=0x20000,blocks=128
    [    0.900000] 4 ofpart partitions found on MTD device 80000000.flash
    [    0.910000] Creating 4 MTD partitions on "80000000.flash":
    [    0.910000] 0x000000000000-0x000000040000 : "bootloader"
    [    0.930000] 0x000000040000-0x000000200000 : "linux kernel"
    [    0.950000] 0x000000200000-0x000000a00000 : "root filesystem"
    [    0.970000] 0x000000a00000-0x000001000000 : "user filesystem"
    [    1.600000] libphy: MOXA ART Ethernet MII: probed
    [    2.220000] libphy: MOXA ART Ethernet MII: probed
    [    2.260000] moxart-ethernet 90900000.ethernet eth0:
moxart_mac_probe: IRQ=19 address=00:00:00:00:00:00
    [    2.270000] moxart-ethernet 90900000.ethernet eth0: generated
random MAC address a6:07:0d:68:31:c4
    [    2.280000] moxart-ethernet 92000000.ethernet eth1:
moxart_mac_probe: IRQ=20 address=00:00:00:00:00:00
    [    2.300000] moxart-ethernet 92000000.ethernet eth1: generated
random MAC address 5a:e7:48:87:f5:5e
    [    2.310000] of_get_named_gpiod_flags exited with status 0
    [    2.320000] input: gpio_keys_polled.2 as
/devices/gpio_keys_polled.2/input/input0
    [    2.330000] evbug: Connected device: input0 (gpio_keys_polled.2
at gpio-keys-polled/input0)
    [    2.340000] of_get_named_gpiod_flags exited with status 0
    [    2.350000] of_get_named_gpiod_flags exited with status 0
    [    2.350000] of_get_named_gpiod_flags exited with status 0
    [    2.360000] moxart-rtc rtc.0: rtc core: registered rtc.0 as rtc0
    [    2.380000] of_get_named_gpiod_flags: can't parse gpios
property of node '/soc/mmc@98e00000[0]'
    [    2.390000] of_get_named_gpiod_flags: can't parse gpios
property of node '/soc/mmc@98e00000[0]'
    [    2.450000] of_get_named_gpiod_flags exited with status 0
    [    2.450000] of_get_named_gpiod_flags exited with status 0
    [    2.460000] TCP: cubic registered
    [    2.470000] NET: Registered protocol family 17
    [    2.490000] console [netcon0] enabled
    [    2.490000] netconsole: network logging started
    [    2.500000] moxart-rtc rtc.0: setting system clock to
2014-04-10 07:16:34 UTC (1397114194)
    [    2.510000] Waiting for root device /dev/mmcblk0p1...
    [    2.520000] mmc0: new SDHC card at address 0fd0
    [    2.530000] mmcblk0: mmc0:0fd0 SD04G 3.69 GiB
    [    2.550000]  mmcblk0: p1
    [    2.650000] kjournald starting.  Commit interval 5 seconds
    [    2.650000] EXT3-fs (mmcblk0p1): warning: maximal mount count
reached, running e2fsck is recommended
    [    2.680000] EXT3-fs (mmcblk0p1): using internal journal
    [    2.680000] EXT3-fs (mmcblk0p1): recovery complete
    [    2.690000] EXT3-fs (mmcblk0p1): mounted filesystem with
ordered data mode
    [    2.690000] VFS: Mounted root (ext3 filesystem) on device 179:1.
    [    2.710000] devtmpfs: mounted
    [    2.720000] Freeing unused kernel memory: 104K (c02f4000 - c030e000)
    [    3.390000] init: unhandled page fault (11) at 0xffff1007, code 0x01f
    [    3.400000] pgd = c1a24000
    [    3.400000] [ffff1007] *pgd=01ffd831, *pte=01fff0cf, *ppte=01fff00e
    [    3.400000]
    [    3.410000] CPU: 0 PID: 1 Comm: init Not tainted
3.14.0-next-20140409+ #2431
    [    3.420000] task: c1828000 ti: c182c000 task.ti: c182c000
    [    3.420000] PC is at 0xb6df2478
    [    3.430000] LR is at 0x1c
    [    3.430000] pc : [<b6df2478>]    lr : [<0000001c>]    psr: 60000010
    [    3.430000] sp : bee48eb8  ip : bee48fe0  fp : 00000000
    [    3.440000] r10: 00000000  r9 : b6f34958  r8 : bee48f1c
    [    3.450000] r7 : bee48f14  r6 : bee48f1c  r5 : 00000001  r4 : b6f08000
    [    3.460000] r3 : 00000008  r2 : bee48fd4  r1 : 00115c40  r0 : ffff0fff
    [    3.470000] Flags: nZCv  IRQs on  FIQs on  Mode USER_32  ISA
ARM  Segment user
    [    3.480000] Control: 0000397f  Table: 01a24000  DAC: 00000015
    [    3.490000] CPU: 0 PID: 1 Comm: init Not tainted
3.14.0-next-20140409+ #2431
    [    3.500000] [<c000d4e0>] (unwind_backtrace) from [<c000bcbc>]
(show_stack+0x10/0x14)
    [    3.510000] [<c000bcbc>] (show_stack) from [<c000eb64>]
(__do_user_fault+0xbc/0xc8)
    [    3.520000] [<c000eb64>] (__do_user_fault) from [<c000edd4>]
(do_page_fault+0x264/0x29c)
    [    3.530000] [<c000edd4>] (do_page_fault) from [<c0008444>]
(do_DataAbort+0x34/0x98)
    [    3.540000] [<c0008444>] (do_DataAbort) from [<c000c9a4>]
(__dabt_usr+0x44/0x60)
    [    3.550000] Exception stack(0xc182dfb0 to 0xc182dff8)
    [    3.550000] dfa0:                                     ffff0fff
00115c40 bee48fd4 00000008
    [    3.560000] dfc0: b6f08000 00000001 bee48f1c bee48f14 bee48f1c
b6f34958 00000000 00000000
    [    3.570000] dfe0: bee48fe0 bee48eb8 0000001c b6df2478 60000010 ffffffff
    [    3.580000] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
    [    3.580000]
    [    3.580000] CPU: 0 PID: 1 Comm: init Not tainted
3.14.0-next-20140409+ #2431
    [    3.580000] [<c000d4e0>] (unwind_backtrace) from [<c000bcbc>]
(show_stack+0x10/0x14)
    [    3.580000] [<c000bcbc>] (show_stack) from [<c0268f74>]
(panic+0x98/0x1f4)
    [    3.580000] [<c0268f74>] (panic) from [<c0016bcc>] (do_exit+0x908/0x938)
    [    3.580000] [<c0016bcc>] (do_exit) from [<c0016c70>]
(do_group_exit+0x4c/0xe8)
    [    3.580000] [<c0016c70>] (do_group_exit) from [<c0022098>]
(get_signal_to_deliver+0x218/0x5f0)
    [    3.580000] [<c0022098>] (get_signal_to_deliver) from
[<c000b358>] (do_signal+0x100/0x48c)
    [    3.580000] [<c000b358>] (do_signal) from [<c000b8ac>]
(do_work_pending+0xd4/0xe4)
    [    3.580000] [<c000b8ac>] (do_work_pending) from [<c000933c>]
(work_pending+0xc/0x20)
    [    3.580000] Rebooting in 10 seconds..

    defconfig:
    # CONFIG_LOCALVERSION_AUTO is not set
    CONFIG_SYSVIPC=y
    # CONFIG_USELIB is not set
    CONFIG_NO_HZ_IDLE=y
    CONFIG_IKCONFIG=y
    CONFIG_IKCONFIG_PROC=y
    CONFIG_LOG_BUF_SHIFT=16
    # CONFIG_UID16 is not set
    # CONFIG_ELF_CORE is not set
    # CONFIG_BASE_FULL is not set
    # CONFIG_EVENTFD is not set
    # CONFIG_AIO is not set
    CONFIG_EMBEDDED=y
    # CONFIG_VM_EVENT_COUNTERS is not set
    # CONFIG_SLUB_DEBUG is not set
    # CONFIG_COMPAT_BRK is not set
    # CONFIG_LBDAF is not set
    # CONFIG_BLK_DEV_BSG is not set
    # CONFIG_IOSCHED_DEADLINE is not set
    CONFIG_ARCH_MULTI_V4=y
    CONFIG_ARCH_MULTI_V4T=y
    # CONFIG_ARCH_MULTI_V7 is not set
    CONFIG_ARCH_MOXART=y
    CONFIG_MACH_UC7112LX=y
    CONFIG_PREEMPT=y
    CONFIG_AEABI=y
    # CONFIG_CROSS_MEMORY_ATTACH is not set
    # CONFIG_ATAGS is not set
    CONFIG_ARM_APPENDED_DTB=y
    CONFIG_NET=y
    CONFIG_PACKET=y
    CONFIG_UNIX=y
    CONFIG_INET=y
    CONFIG_IP_MULTICAST=y
    CONFIG_IP_PNP=y
    CONFIG_IP_PNP_DHCP=y
    # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
    # CONFIG_INET_XFRM_MODE_TUNNEL is not set
    # CONFIG_INET_XFRM_MODE_BEET is not set
    # CONFIG_INET_LRO is not set
    # CONFIG_INET_DIAG is not set
    # CONFIG_IPV6 is not set
    # CONFIG_WIRELESS is not set
    CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
    CONFIG_DEVTMPFS=y
    CONFIG_DEVTMPFS_MOUNT=y
    # CONFIG_PREVENT_FIRMWARE_BUILD is not set
    # CONFIG_FW_LOADER is not set
    CONFIG_MTD=y
    CONFIG_MTD_BLOCK=y
    CONFIG_MTD_CFI=y
    CONFIG_MTD_CFI_ADV_OPTIONS=y
    CONFIG_MTD_CFI_GEOMETRY=y
    CONFIG_MTD_CFI_INTELEXT=y
    CONFIG_MTD_COMPLEX_MAPPINGS=y
    CONFIG_MTD_PHYSMAP=y
    CONFIG_MTD_PHYSMAP_OF=y
    CONFIG_BLK_DEV_LOOP=y
    CONFIG_NETDEVICES=y
    CONFIG_NETCONSOLE=y
    CONFIG_NETCONSOLE_DYNAMIC=y
    # CONFIG_NET_VENDOR_ARC is not set
    # CONFIG_NET_CADENCE is not set
    # CONFIG_NET_VENDOR_BROADCOM is not set
    # CONFIG_NET_VENDOR_CIRRUS is not set
    # CONFIG_NET_VENDOR_FARADAY is not set
    # CONFIG_NET_VENDOR_INTEL is not set
    # CONFIG_NET_VENDOR_MARVELL is not set
    # CONFIG_NET_VENDOR_MICREL is not set
    CONFIG_ARM_MOXART_ETHER=y
    # CONFIG_NET_VENDOR_NATSEMI is not set
    # CONFIG_NET_VENDOR_SEEQ is not set
    # CONFIG_NET_VENDOR_SMSC is not set
    # CONFIG_NET_VENDOR_STMICRO is not set
    # CONFIG_NET_VENDOR_VIA is not set
    # CONFIG_NET_VENDOR_WIZNET is not set
    CONFIG_REALTEK_PHY=y
    CONFIG_MDIO_MOXART=y
    # CONFIG_WLAN is not set
    # CONFIG_INPUT_MOUSEDEV is not set
    CONFIG_INPUT_EVDEV=y
    CONFIG_INPUT_EVBUG=y
    # CONFIG_KEYBOARD_ATKBD is not set
    CONFIG_KEYBOARD_GPIO_POLLED=y
    # CONFIG_INPUT_MOUSE is not set
    # CONFIG_SERIO is not set
    # CONFIG_VT is not set
    # CONFIG_LEGACY_PTYS is not set
    CONFIG_MOXA_SMARTIO=y
    # CONFIG_DEVKMEM is not set
    CONFIG_SERIAL_8250=y
    CONFIG_SERIAL_8250_CONSOLE=y
    CONFIG_SERIAL_8250_NR_UARTS=3
    CONFIG_SERIAL_8250_RUNTIME_UARTS=3
    CONFIG_SERIAL_8250_EXTENDED=y
    CONFIG_SERIAL_8250_SHARE_IRQ=y
    CONFIG_SERIAL_OF_PLATFORM=y
    # CONFIG_HW_RANDOM is not set
    CONFIG_DEBUG_GPIO=y
    CONFIG_GPIO_SYSFS=y
    CONFIG_GPIO_MOXART=y
    # CONFIG_HWMON is not set
    CONFIG_WATCHDOG=y
    CONFIG_WATCHDOG_CORE=y
    CONFIG_WATCHDOG_NOWAYOUT=y
    CONFIG_MOXART_WDT=y
    # CONFIG_USB_SUPPORT is not set
    CONFIG_MMC=y
    CONFIG_MMC_MOXART=y
    CONFIG_NEW_LEDS=y
    CONFIG_LEDS_CLASS=y
    CONFIG_LEDS_GPIO=y
    CONFIG_LEDS_TRIGGERS=y
    CONFIG_LEDS_TRIGGER_TIMER=y
    CONFIG_LEDS_TRIGGER_ONESHOT=y
    CONFIG_LEDS_TRIGGER_HEARTBEAT=y
    CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
    CONFIG_RTC_CLASS=y
    CONFIG_RTC_DRV_MOXART=y
    CONFIG_DMADEVICES=y
    CONFIG_MOXART_DMA=y
    # CONFIG_IOMMU_SUPPORT is not set
    CONFIG_MCB=y
    CONFIG_EXT3_FS=y
    CONFIG_TMPFS=y
    CONFIG_CONFIGFS_FS=y
    CONFIG_JFFS2_FS=y
    # CONFIG_NETWORK_FILESYSTEMS is not set
    CONFIG_PRINTK_TIME=y
    CONFIG_DEBUG_INFO=y
    # CONFIG_ENABLE_WARN_DEPRECATED is not set
    # CONFIG_ENABLE_MUST_CHECK is not set
    CONFIG_MAGIC_SYSRQ=y
    CONFIG_PANIC_ON_OOPS=y
    CONFIG_PANIC_TIMEOUT=10
    # CONFIG_SCHED_DEBUG is not set
    # CONFIG_DEBUG_PREEMPT is not set
    # CONFIG_FTRACE is not set
    CONFIG_DEBUG_USER=y
    CONFIG_DEBUG_LL=y
    CONFIG_DEBUG_LL_UART_8250=y
    CONFIG_DEBUG_UART_PHYS=0x98200000
    CONFIG_DEBUG_UART_VIRT=0xf9820000
    CONFIG_EARLY_PRINTK=y
    # CONFIG_CRYPTO_ANSI_CPRNG is not set
    # CONFIG_CRYPTO_HW is not set
    CONFIG_CRC32_BIT=y


Regards,
Jonas
