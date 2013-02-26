Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab3BZPuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:50:22 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:34235 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759651Ab3BZPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:50:20 -0500
Message-ID: <512CD9BA.3080300@mimc.co.uk>
Date: Tue, 26 Feb 2013 15:50:18 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: linux-next: JFFS2 corruption
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tested the current next-20130226 on a custom AM335X board, and if I mount
our JFFS2 image as read/write, the next reboot shows the image as being corrupt.

If I reprogram the jffs2 image into NAND and only mount the volume as read-only,
no corruption occurs and the system remains intact.

I have also tested:-

(a) reprogram ubifs image into nand
(b) boot the volume as read-only (corrupt -> no)
(c) remount the volume as read/write
(d) rebooting the volume as read-only (corrupt -> yes)

Below is the log showing (d) ...

Regards
Mark J.
---
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.8.0-next-20130226-dirty (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot 2012.11) ) #12 SMP Tue Feb 26 14:04:28 GMT 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x BeagleBone
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES1.0 (neon )
[    0.000000] PERCPU: Embedded 9 pages/cpu @c0e02000 s13696 r8192 d14976 u36864
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: console=ttyO0,115200n8 noinitrd ip=off mem=256M rootwait=1 rootfstype=jffs2 root=/dev/mtdblock6 ro
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 255MB = 255MB total
[    0.000000] Memory: 246536k/246536k available, 15608k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0008000 - 0xc05cd3a0   (5909 kB)
[    0.000000]       .init : 0xc05ce000 - 0xc061e580   ( 322 kB)
[    0.000000]       .data : 0xc0620000 - 0xc06a6820   ( 539 kB)
[    0.000000]        .bss : 0xc06a6820 - 0xc0bf4d6c   (5434 kB)
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
[    0.001032] Calibrating delay loop... 476.77 BogoMIPS (lpj=2383872)
[    0.109736] pid_max: default: 32768 minimum: 301
[    0.110266] Security Framework initialized
[    0.110426] Mount-cache hash table entries: 512
[    0.121717] CPU: Testing write buffer coherency: ok
[    0.123210] CPU0: thread -1, cpu 0, socket -1, mpidr 0
[    0.123295] Setting up static identity map for 0xc041e950 - 0xc041e9c0
[    0.126044] Brought up 1 CPUs
[    0.126069] SMP: Total of 1 processors activated (476.77 BogoMIPS).
[    0.126081] CPU: All CPU(s) started in SVC mode.
[    0.129080] devtmpfs: initialized
[    0.200411] pinctrl core: initialized pinctrl subsystem
[    0.206461] regulator-dummy: no parameters
[    0.209043] NET: Registered protocol family 16
[    0.209939] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.233770] OMAP GPIO hardware version 0.1
[    0.263351] omap-gpmc 50000000.gpmc: GPMC revision 6.0
[    0.265960] No ATAGs?
[    0.265988] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.311687] bio: create slab <bio-0> at 0
[    0.398050] omap-dma-engine omap-dma-engine: OMAP DMA engine driver
[    0.405918] usbcore: registered new interface driver usbfs
[    0.406470] usbcore: registered new interface driver hub
[    0.407327] usbcore: registered new device driver usb
[    0.409003] omap_i2c 44e0b000.i2c: did not get pins for i2c error: -19
[    0.411618] omap_i2c 44e0b000.i2c: bus 0 rev0.11 at 400 kHz
[    0.413344] mcp230xx: probe of 0-0020 failed with error -22
[    0.419117] DCDC1: at 1800 mV
[    0.422543] vdd_mpu: 925 <--> 1325 mV at 3300 mV
[    0.424721] vdd_core: 925 <--> 1150 mV at 1100 mV
[    0.426984] LDO1: at 1800 mV
[    0.429065] LDO2: at 3300 mV
[    0.431676] LDO3: at 3300 mV
[    0.433749] LDO4: at 2800 mV
[    0.435554] tps65217 0-0024: TPS65217 ID 0x7 version 1.1
[    0.446197] Switching to clocksource gp_timer
[    0.560007] NET: Registered protocol family 2
[    0.562070] TCP established hash table entries: 2048 (order: 2, 16384 bytes)
[    0.562292] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.563243] TCP: Hash tables configured (established 2048 bind 2048)
[    0.563476] TCP: reno registered
[    0.563510] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.563775] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.564666] NET: Registered protocol family 1
[    0.565819] NetWinder Floating Point Emulator V0.97 (double precision)
[    0.566339] CPU PMU: probing PMU on CPU 0
[    0.566373] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available
[    0.710679] jffs2: version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.711291] msgmni has been set to 481
[    0.714998] io scheduler noop registered
[    0.715027] io scheduler deadline registered
[    0.715110] io scheduler cfq registered (default)
[    0.716538] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568
[    0.721523] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.728884] omap_uart 44e09000.serial: did not get pins for uart0 error: -19
[    0.729525] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0
[    1.319153] console [ttyO0] enabled
[    1.325110] omap_uart 48022000.serial: did not get pins for uart1 error: -19
[    1.333400] 48022000.serial: ttyO1 at MMIO 0x48022000 (irq = 89) is a OMAP UART1
[    1.343363] omap_uart 48024000.serial: did not get pins for uart2 error: -19
[    1.351285] 48024000.serial: ttyO2 at MMIO 0x48024000 (irq = 90) is a OMAP UART2
[    1.360714] omap_uart 481a6000.serial: did not get pins for uart3 error: -19
[    1.368752] 481a6000.serial: ttyO3 at MMIO 0x481a6000 (irq = 60) is a OMAP UART3
[    1.378159] omap_uart 481a8000.serial: did not get pins for uart4 error: -19
[    1.385862] 481a8000.serial: ttyO4 at MMIO 0x481a8000 (irq = 61) is a OMAP UART4
[    1.395315] omap_uart 481aa000.serial: did not get pins for uart5 error: -19
[    1.403172] 481aa000.serial: ttyO5 at MMIO 0x481aa000 (irq = 62) is a OMAP UART5
[    1.446256] brd: module loaded
[    1.471131] loop: module loaded
[    1.478556] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.487714] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    1.496006] enabling NAND BCH ecc with 8-bit correction
[    1.502018] ONFI param page 0 valid
[    1.505695] ONFI flash detected
[    1.509090] NAND device: Manufacturer ID: 0x2c, Chip ID: 0xda (Micron MT29F2G08ABAEAWP), 256MiB, page size: 2048, OOB size: 64
[    1.521348] 8 ofpart partitions found on MTD device omap2-nand.0
[    1.527717] Creating 8 MTD partitions on "omap2-nand.0":
[    1.533316] 0x000000000000-0x000000020000 : "spl1"
[    1.545257] 0x000000020000-0x000000040000 : "spl2"
[    1.555022] 0x000000040000-0x000000060000 : "spl3"
[    1.564408] 0x000000060000-0x000000080000 : "spl4"
[    1.573946] 0x000000080000-0x0000001e0000 : "boot"
[    1.584828] 0x0000001e0000-0x000000200000 : "env"
[    1.594707] 0x000000200000-0x000004200000 : "rootfs"
[    1.659562] 0x000004200000-0x000010000000 : "data"
[    1.839654] usbcore: registered new interface driver asix
[    1.845828] usbcore: registered new interface driver cdc_ether
[    1.852728] usbcore: registered new interface driver smsc95xx
[    1.859890] usbcore: registered new interface driver net1080
[    1.866332] usbcore: registered new interface driver cdc_subset
[    1.873194] usbcore: registered new interface driver zaurus
[    1.879727] usbcore: registered new interface driver cdc_ncm
[    1.888250] usbcore: registered new interface driver cdc_wdm
[    1.894777] usbcore: registered new interface driver usbtest
[    1.904123] rtc-ds1307 0-0068: rtc core: registered ds1307 as rtc0
[    1.910851] rtc-ds1307 0-0068: 56 bytes nvram
[    1.916215] i2c /dev entries driver
[    1.925777] omap_wdt: OMAP Watchdog Timer Rev 0x01: initial timeout 60 sec
[    1.934797] omap_cpufreq_init: unable to get MPU regulator
[    1.944756] usbcore: registered new interface driver usbhid
[    1.950806] usbhid: USB HID core driver
[    1.956489] oprofile: using arm/armv7
[    1.961449] TCP: cubic registered
[    1.964949] Initializing XFRM netlink socket
[    1.969694] NET: Registered protocol family 17
[    1.974613] NET: Registered protocol family 15
[    1.979855] Key type dns_resolver registered
[    1.984457] VFP support v0.3: implementor 41 architecture 3 part 30 variant c rev 3
[    1.992657] ThumbEE CPU extension supported.
[    2.066693] davinci_mdio 4a101000.mdio: davinci mdio revision 1.6
[    2.073130] davinci_mdio 4a101000.mdio: detected phy mask fffffffc
[    2.084362] libphy: 4a101000.mdio: probed
[    2.088760] davinci_mdio 4a101000.mdio: phy[0]: device 4a101000.mdio:00, driver SMSC LAN8710/LAN8720
[    2.098421] davinci_mdio 4a101000.mdio: phy[1]: device 4a101000.mdio:01, driver SMSC LAN8710/LAN8720
[    2.108516] Random MACID = fa:91:6f:36:0e:b0
[    2.118076] rtc-ds1307 0-0068: setting system clock to 2013-01-21 20:34:58 UTC (1358800498)
[    2.652964] jffs2: mtd->read(0x1fc54 bytes from 0x3a03ac) returned ECC error
[    2.676730] jffs2: mtd->read(0x1e260 bytes from 0x3a1da0) returned ECC error
[    2.684150] jffs2: Empty flash at 0x003a1d9c ends at 0x003a2000
[    3.161187] jffs2: notice: (1) jffs2_build_xattr_subsystem: complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead, 0 orphan) found.
[    3.179148] VFS: Mounted root (jffs2 filesystem) readonly on device 31:6.
[    3.188034] devtmpfs: mounted
[    3.191762] Freeing init memory: 320K
[    3.606040]
[    3.607646] ======================================================
[    3.614138] [ INFO: possible circular locking dependency detected ]
[    3.620728] 3.8.0-next-20130226-dirty #12 Not tainted
[    3.626033] -------------------------------------------------------
[    3.632615] rcS/631 is trying to acquire lock:
[    3.637283]  (&mm->mmap_sem){++++++}, at: [<c00f0af4>] might_fault+0x3c/0x90
[    3.644741]
[    3.644741] but task is already holding lock:
[    3.650867]  (&f->sem){+.+.+.}, at: [<c01a278c>] jffs2_readdir+0x44/0x1a8
[    3.658040]
[    3.658040] which lock already depends on the new lock.
[    3.658040]
[    3.666633]
[    3.666633] the existing dependency chain (in reverse order) is:
[    3.674496]
-> #1 (&f->sem){+.+.+.}:
[    3.678463]        [<c0092df0>] lock_acquire+0x9c/0x104
[    3.683975]        [<c0416c04>] mutex_lock_nested+0x3c/0x334
[    3.689941]        [<c01a2fb4>] jffs2_readpage+0x20/0x44
[    3.695530]        [<c00d9d38>] __do_page_cache_readahead+0x2a0/0x2cc
[    3.702313]        [<c00da004>] ra_submit+0x28/0x30
[    3.707446]        [<c00d179c>] filemap_fault+0x304/0x458
[    3.713138]        [<c00f0c58>] __do_fault+0x6c/0x490
[    3.718454]        [<c00f3c5c>] handle_pte_fault+0xb0/0x6f0
[    3.724316]        [<c00f433c>] handle_mm_fault+0xa0/0xd4
[    3.729994]        [<c041b30c>] do_page_fault+0x2a0/0x3d4
[    3.735679]        [<c000845c>] do_DataAbort+0x30/0x9c
[    3.741085]        [<c04197e4>] __dabt_svc+0x44/0x80
[    3.746309]        [<c0222b98>] __clear_user_std+0x1c/0x64
[    3.752089]
-> #0 (&mm->mmap_sem){++++++}:
[    3.756599]        [<c00927ec>] __lock_acquire+0x1d70/0x1de0
[    3.762554]        [<c0092df0>] lock_acquire+0x9c/0x104
[    3.768051]        [<c00f0b18>] might_fault+0x60/0x90
[    3.773364]        [<c011bc3c>] filldir+0x5c/0x158
[    3.778416]        [<c01a2824>] jffs2_readdir+0xdc/0x1a8
[    3.784005]        [<c011becc>] vfs_readdir+0x98/0xb4
[    3.789319]        [<c011bfcc>] sys_getdents+0x74/0xd0
[    3.794724]        [<c0013820>] ret_fast_syscall+0x0/0x3c
[    3.800416]
[    3.800416] other info that might help us debug this:
[    3.800416]
[    3.808824]  Possible unsafe locking scenario:
[    3.808824]
[    3.815041]        CPU0                    CPU1
[    3.819797]        ----                    ----
[    3.824550]   lock(&f->sem);
[    3.827587]                                lock(&mm->mmap_sem);
[    3.833815]                                lock(&f->sem);
[    3.839496]   lock(&mm->mmap_sem);
[    3.843079]
[    3.843079]  *** DEADLOCK ***
[    3.843079]
[    3.849302] 2 locks held by rcS/631:
[    3.853055]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c011be90>] vfs_readdir+0x5c/0xb4
[    3.861778]  #1:  (&f->sem){+.+.+.}, at: [<c01a278c>] jffs2_readdir+0x44/0x1a8
[    3.869404]
[    3.869404] stack backtrace:
[    3.874009] [<c001b158>] (unwind_backtrace+0x0/0xf0) from [<c008f29c>] (print_circular_bug+0x1d0/0x2dc)
[    3.883888] [<c008f29c>] (print_circular_bug+0x1d0/0x2dc) from [<c00927ec>] (__lock_acquire+0x1d70/0x1de0)
[    3.894040] [<c00927ec>] (__lock_acquire+0x1d70/0x1de0) from [<c0092df0>] (lock_acquire+0x9c/0x104)
[    3.903553] [<c0092df0>] (lock_acquire+0x9c/0x104) from [<c00f0b18>] (might_fault+0x60/0x90)
[    3.912427] [<c00f0b18>] (might_fault+0x60/0x90) from [<c011bc3c>] (filldir+0x5c/0x158)
[    3.920844] [<c011bc3c>] (filldir+0x5c/0x158) from [<c01a2824>] (jffs2_readdir+0xdc/0x1a8)
[    3.929533] [<c01a2824>] (jffs2_readdir+0xdc/0x1a8) from [<c011becc>] (vfs_readdir+0x98/0xb4)
[    3.938500] [<c011becc>] (vfs_readdir+0x98/0xb4) from [<c011bfcc>] (sys_getdents+0x74/0xd0)
[    3.947285] [<c011bfcc>] (sys_getdents+0x74/0xd0) from [<c0013820>] (ret_fast_syscall+0x0/0x3c)
Starting logging: OK
Initializing random number generator... [    3.997350] jffs2: mtd->read(0x778 bytes from 0x3a3888) returned ECC error
[    4.021216] jffs2: mtd->read(0x7bc bytes from 0x3a3844) returned ECC error
[    4.043965] jffs2: mtd->read(0x800 bytes from 0x3a3800) returned ECC error
[    4.059373] jffs2: mtd->read(0x44 bytes from 0x3a3888) returned ECC error
[    4.075443] jffs2: mtd->read(0x44 bytes from 0x3a3888) returned ECC error
[    4.083554] jffs2: mtd->read(0x200 bytes from 0x3a38cc) returned ECC error
read-only file system detected...done
Starting network...
Starting dropbear sshd: mkdir: can't create directory '/etc/dropbear': Read-only file system
generating rsa key... generating dsa key... OK
Starting lighttpd: OK

Welcome to Buildroot
beaglebone login:
