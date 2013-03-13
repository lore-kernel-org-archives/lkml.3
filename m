Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3CMLUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:20:48 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:44449 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756262Ab3CMLUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:20:44 -0400
Message-ID: <5140610A.1040205@mimc.co.uk>
Date: Wed, 13 Mar 2013 11:20:42 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: lkml <linux-kernel@vger.kernel.org>, dedekind1@gmail.com,
        adrian.hunter@intel.com
Subject: MTD: UBIFS: Kernel oops when fixing up free space
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm encountering an oops when mounting my ubifs volume.

[    1.658853] UBI: attaching mtd6 to ubi0
[    1.981819] UBI: scanning is finished
[    1.993184] UBI warning: print_rsvd_warning: cannot reserve enough PEBs for bad PEB handling, reserved 4, need 40
[    2.007975] UBI: attached mtd6 (name "rootfs", size 64 MiB) to ubi0
[    2.014612] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[    2.021822] UBI: min./max. I/O unit sizes: 2048/2048, sub-page size 512
[    2.028831] UBI: VID header offset: 2048 (aligned 2048), data offset: 4096
[    2.036086] UBI: good PEBs: 512, bad PEBs: 0, corrupted PEBs: 0
[    2.042357] UBI: user volume: 1, internal volumes: 1, max. volumes count: 128
[    2.050208] UBI: max/mean erase counter: 1/0, WL threshold: 4096, image sequence number: 2046573563
[    2.059802] UBI: available PEBs: 0, total reserved PEBs: 512, PEBs reserved for bad PEB handling: 4
[    2.070158] UBI: background thread "ubi_bgt0d" started, PID 591
[    2.137592] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.144047] davinci_mdio 4a101000.mdio: detected phy mask fffffffc
[    2.153547] libphy: 4a101000.mdio: probed
[    2.157877] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver SMSC LAN8710/LAN8720
[    2.167551] davinci_mdio 4a101000.mdio: phy[1]: device 4a101000.mdio:01, driver SMSC LAN8710/LAN8720
[    2.177632] Random MACID = 12:6f:e6:eb:6d:09
[    2.186115] rtc-ds1307 0-0068: setting system clock to 2013-03-13 11:10:46 UTC (1363173046)
[    2.253106] UBIFS: mounted UBI device 0, volume 0, name "rootfs", R/O mode
[    2.260470] UBIFS: LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
[    2.270157] UBIFS: FS size: 62599168 bytes (59 MiB, 493 LEBs), journal size 8253440 bytes (7 MiB, 65 LEBs)
[    2.280375] UBIFS: reserved for root: 0 bytes (0 KiB)
[    2.285714] UBIFS: media format: w4/r0 (latest is w4/r0), UUID 7721E01C-D036-4C3A-97D1-2AC4CE3C6DD1, small LPT model
[    2.299521] VFS: Mounted root (ubifs filesystem) readonly on device 0:12.
[    2.309191] devtmpfs: mounted
[    2.312782] Freeing init memory: 196K
[    2.433203] UBIFS: start fixing up free space
[    2.460305] Unable to handle kernel paging request at virtual address 90e28e0c
[    2.468018] pgd = cf374000
[    2.470877] [90e28e0c] *pgd=00000000
[    2.474665] Internal error: Oops: 5 [#1] ARM
[    2.479178] CPU: 0    Not tainted  (3.8.0-next-20130225-00001-g2d0ce24-dirty #37)
[    2.487089] PC is at crc32_le+0xf4/0x168
[    2.491232] LR is at ubi_eba_atomic_leb_change+0x1b4/0x410
[    2.497020] pc : [<c01e7228>]    lr : [<c026dcdc>]    psr: 20000013
[    2.497020] sp : cf373db0  ip : 180a7e81  fp : c054f840
[    2.509133] r10: 90e28e08  r9 : c054fc40  r8 : 180a9e87
[    2.514645] r7 : 1596e25d  r6 : 9324fd72  r5 : 90e28e08  r4 : 39f54975
[    2.521533] r3 : c054e040  r2 : 00000004  r1 : 90e28e0b  r0 : 160aeca3
[    2.528421] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    2.535952] Control: 10c5387d  Table: 8f374019  DAC: 00000015
[    2.542013] Process mount (pid: 602, stack limit = 0xcf372238)
[    2.548168] Stack: (0xcf373db0 to 0xcf374000)
[    2.552767] 3da0:                                     c06702fc 00000004 90e28e08 180a9e87
[    2.561400] 3dc0: ca146285 98246676 91960e97 ae4b29df 5ced41d1 c054fc40 c054f040 c054f840
[    2.570031] 3de0: cf2f8554 00000000 d08d1ecc 180a9e88 0a1a0712 90b34fd7 00000000 0592803f
[    2.578665] 3e00: 4f7a25ff c054fc40 c054f040 c054f840 cf2f8000 00000000 d08caffc 00003c00
[    2.587296] 3e20: cf2f8000 cf32de00 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554
[    2.595928] 3e40: d08cb000 0001e000 00000000 d08cb000 00008000 00000000 00000000 0001e000
[    2.604559] 3e60: 00000000 0000000c d08cb000 00000080 0000000c cf373f48 00000000 00000020
[    2.613195] 3e80: 00008000 c026c35c 0001e000 cf32e000 cf32e000 d08cb000 0001e000 c0179a58
[    2.621826] 3ea0: 0000000d c0177a48 0001e000 cf32e000 00000000 cf32eb20 0000000d c0179494
[    2.630458] 3ec0: 00000000 cf32e000 00000000 cf32ea9c 00000000 c0175170 00000001 60000013
[    2.639090] 3ee0: cf326800 00000000 00000000 00000000 cf373f48 00000000 00000020 c00c9e24
[    2.647726] 3f00: 00100100 00200200 cf32ac40 00008000 cf372000 00208020 00000000 cf01a200
[    2.656359] 3f20: cf326800 c00e3d6c 00000000 0000000c cf326840 00000000 c0013968 cf367e40
[    2.664995] 3f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf053000 000a18b4 00000000
[    2.673632] 3f60: 00208020 c0013968 cf372000 00000000 00000003 c00e3e40 00000000 c0071e24
[    2.682266] 3f80: 00000000 00000000 cf367e40 cf367ec0 a0000010 00000000 beb9bc58 b6fcb48c
[    2.690898] 3fa0: 00000015 c00137c0 00000000 beb9bc58 000a18b4 000a18c0 000a18c2 00208020
[    2.699531] 3fc0: 00000000 beb9bc58 b6fcb48c 00000015 00000000 00000000 00000000 00000003
[    2.708166] 3fe0: b6f7df48 beb9bb54 00042994 b6f7df58 a0000010 000a18b4 00000000 00000000
[    2.716814] [<c01e7228>] (crc32_le+0xf4/0x168) from [<cf2f8554>] (0xcf2f8554)
[    2.724350] Code: e3520000 0a000008 e59da008 e28a1003 (e5f1c001)
[    2.730825] ---[ end trace 9593089b6ffc6663 ]---

If I boot the same target using an nfs root, I get no such oops.

I've attached my full dmesg log below.

Regards
Mark J.
---
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.8.0-next-20130225-00001-g2d0ce24-dirty (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot 2012.11) ) #37 Wed Mar 13 11:07:33 GMT 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x BeagleBone
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES1.0 (neon )
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: console=ttyO0,115200n8 noinitrd ip=off mem=256M rootwait=1 ubi.mtd=6,2048 rootfstype=ubifs root=ubi0:rootfs
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 255MB = 255MB total
[    0.000000] Memory: 247768k/247768k available, 14376k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]       .text : 0xc0008000 - 0xc05194ac   (5190 kB)
[    0.000000]       .init : 0xc051a000 - 0xc054bfbc   ( 200 kB)
[    0.000000]       .data : 0xc054c000 - 0xc059d360   ( 325 kB)
[    0.000000]        .bss : 0xc059d360 - 0xc0ac21a0   (5268 kB)
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
[    0.000857] Calibrating delay loop... 476.77 BogoMIPS (lpj=2383872)
[    0.119748] pid_max: default: 32768 minimum: 301
[    0.120029] Security Framework initialized
[    0.120127] Mount-cache hash table entries: 512
[    0.130043] CPU: Testing write buffer coherency: ok
[    0.131312] Setting up static identity map for 0xc0402c38 - 0xc0402c90
[    0.134694] devtmpfs: initialized
[    0.196234] pinctrl core: initialized pinctrl subsystem
[    0.201441] regulator-dummy: no parameters
[    0.203632] NET: Registered protocol family 16
[    0.204364] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.222995] OMAP GPIO hardware version 0.1
[    0.245578] omap-gpmc 50000000.gpmc: could not find pctldev for node /pinmux@44e10800/gpmc_pins, deferring probe
[    0.245628] platform 50000000.gpmc: Driver omap-gpmc requests probe deferral
[    0.246260] No ATAGs?
[    0.246279] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.284146] bio: create slab <bio-0> at 0
[    0.350074] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[    0.356487] usbcore: registered new interface driver usbfs
[    0.356880] usbcore: registered new interface driver hub
[    0.357521] usbcore: registered new device driver usb
[    0.358454] omap_i2c 44e0b000.i2c: could not find pctldev for node /pinmux@44e10800/i2c1_pins, deferring probe
[    0.358501] platform 44e0b000.i2c: Driver omap_i2c requests probe deferral
[    0.365753] cfg80211: Calling CRDA to update world regulatory domain
[    0.367424] Switching to clocksource gp_timer
[    0.416216] NET: Registered protocol family 2
[    0.417963] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.418174] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.419121] TCP: Hash tables configured (established 2048 bind 2048)
[    0.419332] TCP: reno registered
[    0.419362] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.419621] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.420403] NET: Registered protocol family 1
[    0.421617] RPC: Registered named UNIX socket transport module.
[    0.421642] RPC: Registered udp transport module.
[    0.421651] RPC: Registered tcp transport module.
[    0.421661] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.422529] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.422983] CPU PMU: probing PMU on CPU 0
[    0.423012] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.435255] msgmni has been set to 483
[    0.439585] io scheduler noop registered
[    0.439608] io scheduler deadline registered
[    0.439674] io scheduler cfq registered (default)
[    0.440717] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
[    0.442353] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.449612] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0
[    0.994168] console [ttyO0] enabled
[    1.000448] 48022000.serial: ttyO1 at MMIO 0x48022000 (irq = 89) is a OMAP UART1
[    1.009974] 48024000.serial: ttyO2 at MMIO 0x48024000 (irq = 90) is a OMAP UART2
[    1.019403] 481a6000.serial: ttyO3 at MMIO 0x481a6000 (irq = 60) is a OMAP UART3
[    1.028825] 481a8000.serial: ttyO4 at MMIO 0x481a8000 (irq = 61) is a OMAP UART4
[    1.038206] 481aa000.serial: ttyO5 at MMIO 0x481aa000 (irq = 62) is a OMAP UART5
[    1.072639] brd: module loaded
[    1.091600] loop: module loaded
[    1.098627] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.110108] usbcore: registered new interface driver rt2800usb
[    1.116648] usbcore: registered new interface driver asix
[    1.122779] usbcore: registered new interface driver cdc_ether
[    1.129343] usbcore: registered new interface driver smsc95xx
[    1.135769] usbcore: registered new interface driver net1080
[    1.142149] usbcore: registered new interface driver cdc_subset
[    1.148798] usbcore: registered new interface driver zaurus
[    1.155109] usbcore: registered new interface driver cdc_ncm
[    1.162992] usbcore: registered new interface driver cdc_wdm
[    1.169468] usbcore: registered new interface driver usbtest
[    1.175823] i2c /dev entries driver
[    1.182923] omap_wdt: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec
[    1.191488] omap_cpufreq_init: unable to get MPU regulator
[    1.200539] usbcore: registered new interface driver usbhid
[    1.206430] usbhid: USB HID core driver
[    1.211665] oprofile: using arm/armv7
[    1.216243] TCP: cubic registered
[    1.219822] Initializing XFRM netlink socket
[    1.224450] NET: Registered protocol family 17
[    1.229277] NET: Registered protocol family 15
[    1.234412] Key type dns_resolver registered
[    1.239067] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
[    1.247215] ThumbEE CPU extension supported.
[    1.255744] omap-gpmc 50000000.gpmc: GPMC revision 6.0
[    1.263363] enabling NAND BCH ecc with 8-bit correction
[    1.269292] ONFI param page 0 valid
[    1.272978] ONFI flash detected
[    1.276299] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xda (Micron MT29F2G08ABAEAWP), 256MiB, page size: 2048, OOB size: 64
[    1.288586] 8 ofpart partitions found on MTD device omap2-nand.0
[    1.294930] Creating 8 MTD partitions on "omap2-nand.0":
[    1.300600] 0x000000000000-0x000000020000 : "spl1"
[    1.308368] 0x000000020000-0x000000040000 : "spl2"
[    1.314408] 0x000000040000-0x000000060000 : "spl3"
[    1.320335] 0x000000060000-0x000000080000 : "spl4"
[    1.326176] 0x000000080000-0x0000001e0000 : "boot"
[    1.333106] 0x0000001e0000-0x000000200000 : "env"
[    1.338881] 0x000000200000-0x000004200000 : "rootfs"
[    1.399279] 0x000004200000-0x000010000000 : "data"
[    1.571302] omap_i2c 44e0b000.i2c: bus 0 rev0.11 at 400 kHz
[    1.578125] mcp230xx: probe of 0-0020 failed with error -22
[    1.588931] DCDC1: at 1800 mV
[    1.594228] vdd_mpu: 925 <--> 1325 mV at 3300 mV
[    1.601276] vdd_core: 925 <--> 1150 mV at 1100 mV
[    1.608244] LDO1: at 1800 mV
[    1.613290] LDO2: at 3300 mV
[    1.618391] LDO3: at 1800 mV
[    1.623610] LDO4: at 2800 mV
[    1.628375] tps65217 0-0024: TPS65217 ID 0x7 version 1.1
[    1.634898] at24 0-0053: 256 byte 24c02 EEPROM, writable, 8 bytes/write
[    1.645584] rtc-ds1307 0-0068: rtc core: registered ds1307 as rtc0
[    1.652223] rtc-ds1307 0-0068: 56 bytes nvram
[    1.658853] UBI: attaching mtd6 to ubi0
[    1.981819] UBI: scanning is finished
[    1.993184] UBI warning: print_rsvd_warning: cannot reserve enough PEBs for bad PEB handling, reserved 4, need 40
[    2.007975] UBI: attached mtd6 (name "rootfs", size 64 MiB) to ubi0
[    2.014612] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 126976 bytes
[    2.021822] UBI: min./max. I/O unit sizes: 2048/2048, sub-page size 512
[    2.028831] UBI: VID header offset: 2048 (aligned 2048), data offset: 4096
[    2.036086] UBI: good PEBs: 512, bad PEBs: 0, corrupted PEBs: 0
[    2.042357] UBI: user volume: 1, internal volumes: 1, max. volumes count: 128
[    2.050208] UBI: max/mean erase counter: 1/0, WL threshold: 4096, image sequence number: 2046573563
[    2.059802] UBI: available PEBs: 0, total reserved PEBs: 512, PEBs reserved for bad PEB handling: 4
[    2.070158] UBI: background thread "ubi_bgt0d" started, PID 591
[    2.137592] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.144047] davinci_mdio 4a101000.mdio: detected phy mask fffffffc
[    2.153547] libphy: 4a101000.mdio: probed
[    2.157877] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver SMSC LAN8710/LAN8720
[    2.167551] davinci_mdio 4a101000.mdio: phy[1]: device 4a101000.mdio:01, driver SMSC LAN8710/LAN8720
[    2.177632] Random MACID = 12:6f:e6:eb:6d:09
[    2.186115] rtc-ds1307 0-0068: setting system clock to 2013-03-13 11:10:46 UTC (1363173046)
[    2.253106] UBIFS: mounted UBI device 0, volume 0, name "rootfs", R/O mode
[    2.260470] UBIFS: LEB size: 126976 bytes (124 KiB), min./max. I/O unit sizes: 2048 bytes/2048 bytes
[    2.270157] UBIFS: FS size: 62599168 bytes (59 MiB, 493 LEBs), journal size 8253440 bytes (7 MiB, 65 LEBs)
[    2.280375] UBIFS: reserved for root: 0 bytes (0 KiB)
[    2.285714] UBIFS: media format: w4/r0 (latest is w4/r0), UUID 7721E01C-D036-4C3A-97D1-2AC4CE3C6DD1, small LPT model
[    2.299521] VFS: Mounted root (ubifs filesystem) readonly on device 0:12.
[    2.309191] devtmpfs: mounted
[    2.312782] Freeing init memory: 196K
[    2.433203] UBIFS: start fixing up free space
[    2.460305] Unable to handle kernel paging request at virtual address 90e28e0c
[    2.468018] pgd = cf374000
[    2.470877] [90e28e0c] *pgd=00000000
[    2.474665] Internal error: Oops: 5 [#1] ARM
[    2.479178] CPU: 0    Not tainted  (3.8.0-next-20130225-00001-g2d0ce24-dirty #37)
[    2.487089] PC is at crc32_le+0xf4/0x168
[    2.491232] LR is at ubi_eba_atomic_leb_change+0x1b4/0x410
[    2.497020] pc : [<c01e7228>]    lr : [<c026dcdc>]    psr: 20000013
[    2.497020] sp : cf373db0  ip : 180a7e81  fp : c054f840
[    2.509133] r10: 90e28e08  r9 : c054fc40  r8 : 180a9e87
[    2.514645] r7 : 1596e25d  r6 : 9324fd72  r5 : 90e28e08  r4 : 39f54975
[    2.521533] r3 : c054e040  r2 : 00000004  r1 : 90e28e0b  r0 : 160aeca3
[    2.528421] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    2.535952] Control: 10c5387d  Table: 8f374019  DAC: 00000015
[    2.542013] Process mount (pid: 602, stack limit = 0xcf372238)
[    2.548168] Stack: (0xcf373db0 to 0xcf374000)
[    2.552767] 3da0:                                     c06702fc 00000004 90e28e08 180a9e87
[    2.561400] 3dc0: ca146285 98246676 91960e97 ae4b29df 5ced41d1 c054fc40 c054f040 c054f840
[    2.570031] 3de0: cf2f8554 00000000 d08d1ecc 180a9e88 0a1a0712 90b34fd7 00000000 0592803f
[    2.578665] 3e00: 4f7a25ff c054fc40 c054f040 c054f840 cf2f8000 00000000 d08caffc 00003c00
[    2.587296] 3e20: cf2f8000 cf32de00 00000000 0000000c cf2ec000 00000000 0000000c cf2f8554
[    2.595928] 3e40: d08cb000 0001e000 00000000 d08cb000 00008000 00000000 00000000 0001e000
[    2.604559] 3e60: 00000000 0000000c d08cb000 00000080 0000000c cf373f48 00000000 00000020
[    2.613195] 3e80: 00008000 c026c35c 0001e000 cf32e000 cf32e000 d08cb000 0001e000 c0179a58
[    2.621826] 3ea0: 0000000d c0177a48 0001e000 cf32e000 00000000 cf32eb20 0000000d c0179494
[    2.630458] 3ec0: 00000000 cf32e000 00000000 cf32ea9c 00000000 c0175170 00000001 60000013
[    2.639090] 3ee0: cf326800 00000000 00000000 00000000 cf373f48 00000000 00000020 c00c9e24
[    2.647726] 3f00: 00100100 00200200 cf32ac40 00008000 cf372000 00208020 00000000 cf01a200
[    2.656359] 3f20: cf326800 c00e3d6c 00000000 0000000c cf326840 00000000 c0013968 cf367e40
[    2.664995] 3f40: 0000000c 00000000 cf01a210 ce828858 0000000c cf053000 000a18b4 00000000
[    2.673632] 3f60: 00208020 c0013968 cf372000 00000000 00000003 c00e3e40 00000000 c0071e24
[    2.682266] 3f80: 00000000 00000000 cf367e40 cf367ec0 a0000010 00000000 beb9bc58 b6fcb48c
[    2.690898] 3fa0: 00000015 c00137c0 00000000 beb9bc58 000a18b4 000a18c0 000a18c2 00208020
[    2.699531] 3fc0: 00000000 beb9bc58 b6fcb48c 00000015 00000000 00000000 00000000 00000003
[    2.708166] 3fe0: b6f7df48 beb9bb54 00042994 b6f7df58 a0000010 000a18b4 00000000 00000000
[    2.716814] [<c01e7228>] (crc32_le+0xf4/0x168) from [<cf2f8554>] (0xcf2f8554)
[    2.724350] Code: e3520000 0a000008 e59da008 e28a1003 (e5f1c001)
[    2.730825] ---[ end trace 9593089b6ffc6663 ]---
Starting logging: OK
Initializing random number generator... read-only file system detected...done
Starting network...
[    2.946429] net eth0: initializing cpsw version 1.12 (0)
[    2.954419] net eth0: phy found : id is : 0x7c0f1
[    2.959939] net eth0: phy found : id is : 0x7c0f1
udhcpc (v1.20.2) started
Sending discover...
Sending discover...
[    6.028030] libphy: 4a101000.mdio:00 - Link is Up - 100/Full
Sending discover...
Sending select for 10.0.0.124...
Lease of 10.0.0.124 obtained, lease time 259200
deleting routers
route: SIOCDELRT: No such process
adding dns 4.2.2.5
adding dns 208.67.220.220
ip: SIOCGIFFLAGS: No such device
Starting dropbear sshd: mkdir: can't create directory '/etc/dropbear': Read-only file system
generating rsa key... generating dsa key... OK
Starting lighttpd: OK

Welcome to Buildroot
nanobone login: root
Password:
# mount
rootfs on / type rootfs (rw)
ubi0:rootfs on / type ubifs (ro,relatime)
devtmpfs on /dev type devtmpfs (rw,relatime,size=123884k,nr_inodes=30971,mode=755)
proc on /proc type proc (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,gid=5,mode=620)
tmpfs on /dev/shm type tmpfs (rw,relatime,mode=777)
tmpfs on /tmp type tmpfs (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
