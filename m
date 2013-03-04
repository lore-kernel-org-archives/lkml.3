Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3CDQmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:42:38 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:59928 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758312Ab3CDQmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:42:36 -0500
Message-ID: <5134CEF9.5070502@mimc.co.uk>
Date: Mon, 04 Mar 2013 16:42:33 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, dedekind1@gmail.com,
        adrian.hunter@intel.com
Subject: MTD : Kernel oops when remounting ubifs as read/write
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm encountering an oops when remounting my ubifs volume as read/write.

# mount -o remount,rw /
[   89.434974] UBIFS assert failed in ubifs_write_node at 869 (pid 628)
[   89.442122] [<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4)
[   89.451896] [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4) from [<c01b3878>] (ubifs_write_master+0x9c/0x134)
[   89.462018] [<c01b3878>] (ubifs_write_master+0x9c/0x134) from [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8)
[   89.472133] [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8) from [<c010dbf4>] (do_remount_sb+0x98/0x16c)
[   89.481790] [<c010dbf4>] (do_remount_sb+0x98/0x16c) from [<c0128268>] (do_mount+0x830/0x888)
[   89.490708] [<c0128268>] (do_mount+0x830/0x888) from [<c0128344>] (sys_mount+0x84/0xb8)
[   89.499178] [<c0128344>] (sys_mount+0x84/0xb8) from [<c0013800>] (ret_fast_syscall+0x0/0x3c)
[   89.510997] UBIFS assert failed in ubifs_write_node at 869 (pid 628)
[   89.517884] [<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4)
[   89.527641] [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4) from [<c01b38b4>] (ubifs_write_master+0xd8/0x134)
[   89.537760] [<c01b38b4>] (ubifs_write_master+0xd8/0x134) from [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8)
[   89.547869] [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8) from [<c010dbf4>] (do_remount_sb+0x98/0x16c)
[   89.557526] [<c010dbf4>] (do_remount_sb+0x98/0x16c) from [<c0128268>] (do_mount+0x830/0x888)
[   89.566435] [<c0128268>] (do_mount+0x830/0x888) from [<c0128344>] (sys_mount+0x84/0xb8)
[   89.574905] [<c0128344>] (sys_mount+0x84/0xb8) from [<c0013800>] (ret_fast_syscall+0x0/0x3c)
[   89.585939] UBIFS: start fixing up free space
[   89.592237] UBIFS: background thread "ubifs_bgt0_0" started, PID 629
[   91.419951] UBIFS: free space fixup complete
#

If it's any help, if the remount is put into my inittab, I don't get any oops.

I've attached my full dmesg log below.

Regards
Mark J.
---
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.8.0-next-20130225-dirty (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot 2012.11) ) #24 SMP Mon Mar 4 16:34:01 GMT 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x BeagleBone
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 65280
[    0.000000] free_area_init_node: node 0, pgdat c062cd40, node_mem_map c0b7f000
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65280 pages, LIFO batch:15
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES1.0 (neon )
[    0.000000] PERCPU: Embedded 9 pages/cpu @c0d89000 s13696 r8192 d14976 u36864
[    0.000000] pcpu-alloc: s13696 r8192 d14976 u36864 alloc=9*4096
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: console=ttyO0,115200n8 noinitrd ip=off mem=256M rootwait=1 ubi.mtd=6,2048 rootfstype=ubifs root=ubi0:rootfs
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 255MB = 255MB total
[    0.000000] Memory: 247020k/247020k available, 15124k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc0570d40   (5540 kB)
[    0.000000]       .init : 0xc0571000 - 0xc05b7580   ( 282 kB)
[    0.000000]       .data : 0xc05b8000 - 0xc062ee20   ( 476 kB)
[    0.000000]        .bss : 0xc062ee20 - 0xc0b7b0ac   (5425 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=2 to nr_cpu_ids=1.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER1 at 26000000 Hz
[    0.000000] sched_clock: 32 bits at 26MHz, resolution 38ns, wraps every 165191ms
[    0.000000] OMAP clocksource: GPTIMER2 at 26000000 Hz
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.001029] Calibrating delay loop... 476.77 BogoMIPS (lpj=2383872)
[    0.109730] pid_max: default: 32768 minimum: 301
[    0.110239] Security Framework initialized
[    0.110390] Mount-cache hash table entries: 512
[    0.122195] CPU: Testing write buffer coherency: ok
[    0.123700] CPU0: thread -1, cpu 0, socket -1, mpidr 0
[    0.123782] Setting up static identity map for 0xc03dcc10 - 0xc03dcc80
[    0.126543] Brought up 1 CPUs
[    0.126571] SMP: Total of 1 processors activated (476.77 BogoMIPS).
[    0.126582] CPU: All CPU(s) started in SVC mode.
[    0.129543] devtmpfs: initialized
[    0.200486] pinctrl core: initialized pinctrl subsystem
[    0.206508] regulator-dummy: no parameters
[    0.209137] NET: Registered protocol family 16
[    0.210033] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.232968] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
[    0.233440] OMAP GPIO hardware version 0.1
[    0.236662] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
[    0.239725] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
[    0.243187] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
[    0.261824] omap-gpmc 50000000.gpmc: could not find pctldev for node /pinmux@44e10800/gpmc_pins, deferring probe
[    0.261887] platform 50000000.gpmc: Driver omap-gpmc requests probe deferral
[    0.262681] No ATAGs?
[    0.262701] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.304231] bio: create slab <bio-0> at 0
[    0.387496] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[    0.395855] usbcore: registered new interface driver usbfs
[    0.396368] usbcore: registered new interface driver hub
[    0.397147] usbcore: registered new device driver usb
[    0.398661] omap_i2c 44e0b000.i2c: could not find pctldev for node /pinmux@44e10800/i2c1_pins, deferring probe
[    0.398718] platform 44e0b000.i2c: Driver omap_i2c requests probe deferral
[    0.406386] Switching to clocksource gp_timer
[    0.519200] NET: Registered protocol family 2
[    0.521153] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.521373] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.522320] TCP: Hash tables configured (established 2048 bind 2048)
[    0.522536] TCP: reno registered
[    0.522571] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.522834] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.523741] NET: Registered protocol family 1
[    0.524885] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.525389] CPU PMU: probing PMU on CPU 0
[    0.525426] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.663288] msgmni has been set to 482
[    0.667007] io scheduler noop registered
[    0.667037] io scheduler deadline registered
[    0.667120] io scheduler cfq registered (default)
[    0.668378] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
[    0.670265] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.678667] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0
[    1.235540] console [ttyO0] enabled
[    1.242117] 48022000.serial: ttyO1 at MMIO 0x48022000 (irq = 89) is a OMAP UART1
[    1.252377] 48024000.serial: ttyO2 at MMIO 0x48024000 (irq = 90) is a OMAP UART2
[    1.262667] 481a6000.serial: ttyO3 at MMIO 0x481a6000 (irq = 60) is a OMAP UART3
[    1.272625] 481a8000.serial: ttyO4 at MMIO 0x481a8000 (irq = 61) is a OMAP UART4
[    1.282562] 481aa000.serial: ttyO5 at MMIO 0x481aa000 (irq = 62) is a OMAP UART5
[    1.325018] brd: module loaded
[    1.349325] loop: module loaded
[    1.357873] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.370800] usbcore: registered new interface driver asix
[    1.377503] usbcore: registered new interface driver cdc_ether
[    1.384213] usbcore: registered new interface driver smsc95xx
[    1.391176] usbcore: registered new interface driver net1080
[    1.397890] usbcore: registered new interface driver cdc_subset
[    1.404614] usbcore: registered new interface driver zaurus
[    1.411265] usbcore: registered new interface driver cdc_ncm
[    1.419765] usbcore: registered new interface driver cdc_wdm
[    1.426276] usbcore: registered new interface driver usbtest
[    1.432925] i2c /dev entries driver
[    1.440628] omap_wdt: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec
[    1.449772] omap_cpufreq_init: unable to get MPU regulator
[    1.459889] usbcore: registered new interface driver usbhid
[    1.465775] usbhid: USB HID core driver
[    1.471348] oprofile: using arm/armv7
[    1.476037] TCP: cubic registered
[    1.479741] Initializing XFRM netlink socket
[    1.484420] NET: Registered protocol family 17
[    1.489421] NET: Registered protocol family 15
[    1.494608] Key type dns_resolver registered
[    1.499276] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
[    1.507466] ThumbEE CPU extension supported.
[    1.517358] omap-gpmc 50000000.gpmc: GPMC revision 6.0
[    1.525144] enabling NAND BCH ecc with 8-bit correction
[    1.531104] ONFI param page 0 valid
[    1.534783] ONFI flash detected
[    1.538156] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xda (Micron MT29F2G08ABAEAWP), 256MiB, page size: 2048, OOB size: 64
[    1.551636] 8 ofpart partitions found on MTD device omap2-nand.0
[    1.558151] Creating 8 MTD partitions on "omap2-nand.0":
[    1.563762] 0x000000000000-0x000000020000 : "spl1"
[    1.571474] 0x000000020000-0x000000040000 : "spl2"
[    1.577809] 0x000000040000-0x000000060000 : "spl3"
[    1.583860] 0x000000060000-0x000000080000 : "spl4"
[    1.590131] 0x000000080000-0x0000001e0000 : "boot"
[    1.597440] 0x0000001e0000-0x000000200000 : "env"
[    1.603610] 0x000000200000-0x000004200000 : "rootfs"
[    1.664996] 0x000004200000-0x000010000000 : "data"
[    1.839910] omap_i2c 44e0b000.i2c: bus 0 rev0.11 at 400 kHz
[    1.847622] mcp230xx 0-0020: invalid or missing platform data
[    1.847685] mcp230xx: probe of 0-0020 failed with error -22
[    1.859992] DCDC1: at 1800 mV
[    1.865608] vdd_mpu: 925 <--> 1325 mV at 3300 mV
[    1.873303] vdd_core: 925 <--> 1150 mV at 1100 mV
[    1.880881] LDO1: at 1800 mV
[    1.886270] LDO2: at 3300 mV
[    1.891856] LDO3: at 1800 mV
[    1.897534] LDO4: at 2800 mV
[    1.902559] tps65217 0-0024: TPS65217 ID 0x7 version 1.1
[    1.910147] at24 0-0053: 256 byte 24c02 EEPROM, writable, 8 bytes/write
[    1.922166] rtc-ds1307 0-0068: rtc core: registered ds1307 as rtc0
[    1.928868] rtc-ds1307 0-0068: 56 bytes nvram
[    1.935768] UBI: attaching mtd6 to ubi0
[    2.149654] UBI: scanning is finished
[    2.176900] UBI: volume 0 ("rootfs") re-sized from 70 to 468 LEBs
[    2.187282] UBI: attached mtd6 (name "rootfs", size 64 MiB) to ubi0
[    2.193900] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[    2.201128] UBI: min./max. I/O unit sizes: 2048/2048, sub-page size 512
[    2.208132] UBI: VID header offset: 2048 (aligned 2048), data offset: 4096
[    2.215365] UBI: good PEBs: 512, bad PEBs: 0, corrupted PEBs: 0
[    2.221638] UBI: user volume: 1, internal volumes: 1, max. volumes count: 128
[    2.229181] UBI: max/mean erase counter: 1/0, WL threshold: 4096, image sequence number: 1914774876
[    2.238733] UBI: available PEBs: 0, total reserved PEBs: 512, PEBs reserved for bad PEB handling: 40
[    2.249764] UBI: background thread "ubi_bgt0d" started, PID 576
[    2.336921] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.343360] davinci_mdio 4a101000.mdio: detected phy mask fffffffc
[    2.378217] libphy: 4a101000.mdio: probed
[    2.382476] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver SMSC LAN8710/LAN8720
[    2.392256] davinci_mdio 4a101000.mdio: phy[1]: device 4a101000.mdio:01, driver SMSC LAN8710/LAN8720
[    2.402381] Random MACID = e6:b4:66:78:35:b1
[    2.429661] rtc-ds1307 0-0068: setting system clock to 2013-01-27 21:26:00 UTC (1359321960)
[    2.588287] UBIFS: mounted UBI device 0, volume 0, name "rootfs", R/O mode
[    2.595557] UBIFS: LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
[    2.605273] UBIFS: FS size: 58155008 bytes (55 MiB, 458 LEBs), journal size 8253440 bytes (7 MiB, 65 LEBs)
[    2.615473] UBIFS: reserved for root: 0 bytes (0 KiB)
[    2.620832] UBIFS: media format: w4/r0 (latest is w4/r0), UUID 76C80FF1-386C-4669-B183-CD1C0D6026E3, small LPT model
[    2.689548] VFS: Mounted root (ubifs filesystem) readonly on device 0:12.
[    2.699409] devtmpfs: mounted
[    2.703068] Freeing init memory: 280K
[   89.434974] UBIFS assert failed in ubifs_write_node at 869 (pid 628)
[   89.442122] [<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4)
[   89.451896] [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4) from [<c01b3878>] (ubifs_write_master+0x9c/0x134)
[   89.462018] [<c01b3878>] (ubifs_write_master+0x9c/0x134) from [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8)
[   89.472133] [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8) from [<c010dbf4>] (do_remount_sb+0x98/0x16c)
[   89.481790] [<c010dbf4>] (do_remount_sb+0x98/0x16c) from [<c0128268>] (do_mount+0x830/0x888)
[   89.490708] [<c0128268>] (do_mount+0x830/0x888) from [<c0128344>] (sys_mount+0x84/0xb8)
[   89.499178] [<c0128344>] (sys_mount+0x84/0xb8) from [<c0013800>] (ret_fast_syscall+0x0/0x3c)
[   89.510997] UBIFS assert failed in ubifs_write_node at 869 (pid 628)
[   89.517884] [<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4)
[   89.527641] [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4) from [<c01b38b4>] (ubifs_write_master+0xd8/0x134)
[   89.537760] [<c01b38b4>] (ubifs_write_master+0xd8/0x134) from [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8)
[   89.547869] [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8) from [<c010dbf4>] (do_remount_sb+0x98/0x16c)
[   89.557526] [<c010dbf4>] (do_remount_sb+0x98/0x16c) from [<c0128268>] (do_mount+0x830/0x888)
[   89.566435] [<c0128268>] (do_mount+0x830/0x888) from [<c0128344>] (sys_mount+0x84/0xb8)
[   89.574905] [<c0128344>] (sys_mount+0x84/0xb8) from [<c0013800>] (ret_fast_syscall+0x0/0x3c)
[   89.585939] UBIFS: start fixing up free space
[   89.592237] UBIFS: background thread "ubifs_bgt0_0" started, PID 629
[   91.419951] UBIFS: free space fixup complete
