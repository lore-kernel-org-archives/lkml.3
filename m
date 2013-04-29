Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3D2IdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:33:04 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:43418 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756727Ab3D2Ic7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:32:59 -0400
Message-ID: <517E3039.2070204@newflow.co.uk>
Date: Mon, 29 Apr 2013 09:32:57 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        tglx@linutronix.de
CC: lkml <linux-kernel@vger.kernel.org>
Subject: v3.9.0-rc8 : oops in tick_do_update_jiffies64+0xbc/0x110
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been experiencing several crashes all pointing exactly the same place in the same tick routine (see below).

The "exception stack" trace at the end changes depending on when the oops occurs.

I've had the oops occur maybe 6 times in the last 50 reboots.

Any ideas ?

Mark J.
---
[    0.000000] Booting Linux on physical CPU 0x0

[    0.000000] Linux version 3.9.0-rc8-00034-gb395e3d-dirty (mpfj@mpfj-nanobone) (gcc version 4.8.0 (Buildroot 2013.05-git-00527-gc24e66a) ) #30 Sun Apr 28 19:00:18 BST 2013

[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d

[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache

[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: Newflow AM335x NanoBone

[    0.000000] debug: ignoring loglevel setting.

[    0.000000] Memory policy: ECC disabled, Data cache writeback

[    0.000000] On node 0 totalpages: 65280

[    0.000000] free_area_init_node: node 0, pgdat c0597040, node_mem_map c0ac1000

[    0.000000]   Normal zone: 512 pages used for memmap

[    0.000000]   Normal zone: 0 pages reserved

[    0.000000]   Normal zone: 65280 pages, LIFO batch:15

[    0.000000] CPU: All CPU(s) started in SVC mode.

[    0.000000] AM335X ES1.0 (neon )

[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768

[    0.000000] pcpu-alloc: [0] 0 

[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768

[    0.000000] Kernel command line: console=ttyO0,115200n8 noinitrd ip=off mem=256M rootwait=1 ubi.mtd=7,2048 rootfstype=ubifs root=ubi0:rootfs ignore_loglevel

[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)

[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)

[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)

[    0.000000] __ex_table already sorted, skipping sort

[    0.000000] Memory: 255MB = 255MB total

[    0.000000] Memory: 247788k/247788k available, 14356k reserved, 0K highmem

[    0.000000] Virtual kernel memory layout:

[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)

[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)

[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)

[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)

[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)

[    0.000000]       .text : 0xc0008000 - 0xc0513f0c   (5168 kB)

[    0.000000]       .init : 0xc0514000 - 0xc0545d24   ( 200 kB)

[    0.000000]       .data : 0xc0546000 - 0xc0597c20   ( 328 kB)

[    0.000000]        .bss : 0xc0597c20 - 0xc0abca50   (5268 kB)

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

[    0.001049] Calibrating delay loop... 363.72 BogoMIPS (lpj=1818624)

[    0.119700] pid_max: default: 32768 minimum: 301

[    0.120058] Security Framework initialized

[    0.120187] Mount-cache hash table entries: 512

[    0.133586] CPU: Testing write buffer coherency: ok

[    0.135069] Setting up static identity map for 0xc03fda80 - 0xc03fdad8

[    0.139239] devtmpfs: initialized

[    0.204075] pinctrl core: initialized pinctrl subsystem

[    0.210660] regulator-dummy: no parameters

[    0.213362] NET: Registered protocol family 16

[    0.214291] DMA: preallocated 256 KiB pool for atomic coherent allocations

[    0.237564] gpiochip_add: registered GPIOs 0 to 31 on device: gpio

[    0.238071] OMAP GPIO hardware version 0.1

[    0.241695] gpiochip_add: registered GPIOs 32 to 63 on device: gpio

[    0.245058] gpiochip_add: registered GPIOs 64 to 95 on device: gpio

[    0.248148] gpiochip_add: registered GPIOs 96 to 127 on device: gpio

[    0.267223] omap-gpmc 50000000.gpmc: could not find pctldev for node /pinmux@44e10800/gpmc_pins, deferring probe

[    0.267286] platform 50000000.gpmc: Driver omap-gpmc requests probe deferral

[    0.268044] No ATAGs?

[    0.268069] hw-breakpoint: debug architecture 0x4 unsupported.

[    0.316248] bio: create slab <bio-0> at 0

[    0.398502] omap-dma-engine omap-dma-engine: OMAP DMA engine driver

[    0.406548] usbcore: registered new interface driver usbfs

[    0.407057] usbcore: registered new interface driver hub

[    0.407830] usbcore: registered new device driver usb

[    0.409001] omap_i2c 44e0b000.i2c: could not find pctldev for node /pinmux@44e10800/i2c1_pins, deferring probe

[    0.409059] platform 44e0b000.i2c: Driver omap_i2c requests probe deferral

[    0.418173] cfg80211: Calling CRDA to update world regulatory domain

[    0.420429] Switching to clocksource gp_timer

[    0.481436] NET: Registered protocol family 2

[    0.483407] TCP established hash table entries: 2048 (order: 2, 16384 bytes)

[    0.483673] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)

[    0.484907] TCP: Hash tables configured (established 2048 bind 2048)

[    0.485157] TCP: reno registered

[    0.485193] UDP hash table entries: 256 (order: 2, 20480 bytes)

[    0.485532] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)

[    0.486556] NET: Registered protocol family 1

[    0.488239] RPC: Registered named UNIX socket transport module.

[    0.488265] RPC: Registered udp transport module.

[    0.488279] RPC: Registered tcp transport module.

[    0.488292] RPC: Registered tcp NFSv4.1 backchannel transport module.

[    0.489416] NetWinder Floating Point Emulator V0.97 (double precision)

[    0.489960] CPU PMU: probing PMU on CPU 0

[    0.489996] hw perfevents: enabled with ARMv7 Cortex-A8 PMU driver, 5 counters available

[    0.505105] msgmni has been set to 483

[    0.510314] io scheduler noop registered

[    0.510340] io scheduler deadline registered

[    0.510419] io scheduler cfq registered (default)

[    0.512086] pinctrl-single 44e10800.pinmux: 142 pins at pa f9e10800 size 568

[    0.514040] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled

[    0.522768] 44e09000.serial: ttyO0 at MMIO 0x44e09000 (irq = 88) is a OMAP UART0

[    1.135804] console [ttyO0] enabled

[    1.142504] 48022000.serial: ttyO1 at MMIO 0x48022000 (irq = 89) is a OMAP UART1

[    1.152303] 48024000.serial: ttyO2 at MMIO 0x48024000 (irq = 90) is a OMAP UART2

[    1.161987] 481a6000.serial: ttyO3 at MMIO 0x481a6000 (irq = 60) is a OMAP UART3

[    1.171690] 481a8000.serial: ttyO4 at MMIO 0x481a8000 (irq = 61) is a OMAP UART4

[    1.181355] 481aa000.serial: ttyO5 at MMIO 0x481aa000 (irq = 62) is a OMAP UART5

[    1.222192] brd: module loaded

[    1.244621] loop: module loaded

[    1.250649] Internal error: Oops - undefined instruction: 0 [#1] ARM

[    1.257372] CPU: 0    Not tainted  (3.9.0-rc8-00034-gb395e3d-dirty #30)

[    1.264370] PC is at tick_do_update_jiffies64+0xbc/0x110

[    1.269973] LR is at do_timer+0x52c/0x9a8

[    1.274199] pc : [<c006f5f8>]    lr : [<c006a420>]    psr: 00000193

[    1.274199] sp : cf075cf8  ip : c05ac000  fp : 00000000

[    1.286286] r10: c05ac010  r9 : c05ac010  r8 : c05ac008

[    1.291788] r7 : 00000000  r6 : 00989680  r5 : 00000000  r4 : 0098f634

[    1.298661] r3 : 00000000  r2 : 4b1a1300  r1 : 00000000  r0 : 4a817c80

[    1.305536] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel

[    1.313324] Control: 10c5387d  Table: 80004019  DAC: 00000015

[    1.319375] Process kworker/u:0 (pid: 6, stack limit = 0xcf074238)

[    1.325882] Stack: (0xcf075cf8 to 0xcf076000)

[    1.330473] 5ce0:                                                       4a81dc34 00000000

[    1.339091] 5d00: c05745b8 cf075e40 00000000 c0573078 00000000 c006f6f4 c0573078 c05730c8

[    1.347707] 5d20: 4a81dc34 00000000 00000000 c05745b8 c05730c8 c0573078 c006f6c4 c0058210

[    1.356325] 5d40: ffffffff c0573078 00000003 4a81c08f 00000000 c0573078 c0573088 c0058be0

[    1.364943] 5d60: 4a81c08f 00000000 c0573078 00000003 ffffffff 7fffffff ffffffff 7fffffff

[    1.373560] 5d80: 4a81c08f 00000000 4a81c08f 00000000 00000000 c0553dd8 cf009310 00000000

[    1.382177] 5da0: 00000000 00000053 cf0092c0 c0597b3b 00000001 c0024c54 c0024c2c c007ead0

[    1.390795] 5dc0: 00000000 c0080dd8 cf009310 cf0092c0 cf009310 c0553dd8 cf075e40 cf074038

[    1.399410] 5de0: cf044800 00000000 00000000 c007ec68 cf0092c0 cf009310 00000000 c0080e54

[    1.408027] 5e00: c0080dc4 00000053 00000053 c007e49c c057d9e0 c0014294 fa200000 00000053

[    1.416645] 5e20: c059875c c0008678 c0074548 c0076514 80000113 ffffffff cf075e74 c0013004

[    1.425262] 5e40: 00000001 00000008 c0aa4c88 cf06a080 60000113 00000000 cf074000 00000001

[    1.433879] 5e60: cf074038 cf044800 00000000 00000000 c09e58c8 cf075e88 c0074548 c0076514

[    1.442495] 5e80: 80000113 ffffffff 00000002 00000000 00000000 c004ef90 00000000 c05ab380

[    1.451113] 5ea0: cf293440 cf03f0c0 cf293440 c05ab380 cf075ed0 c004f000 00000002 00000000

[    1.459732] 5ec0: c004ef90 c004fb04 00000000 00000002 c05ab35c c065bca4 00000000 c04ab4c4

[    1.468351] 5ee0: cf06a080 cf03f0c0 c05ab380 c05ab3ac cf03f0d4 cf074000 c0597b1b 00000089

[    1.476970] 5f00: c05ab380 c004fbf0 cf06a080 cf04de54 00000000 cf03f0c0 c004fac4 00000000

[    1.485587] 5f20: 00000000 00000000 00000000 c0054e24 cf06a080 00000000 00000001 cf03f0c0

[    1.494204] 5f40: 00000000 00000001 dead4ead ffffffff ffffffff c05abb90 00000000 00000000

[    1.502821] 5f60: c04aa16c cf075f64 cf075f64 00000000 00000001 dead4ead ffffffff ffffffff

[    1.511438] 5f80: c05abb90 00000000 00000000 c04aa16c cf075f90 cf075f90 cf075fac cf04de54

[    1.520054] 5fa0: c0054d70 00000000 00000000 c00134b0 00000000 00000000 00000000 00000000

[    1.528671] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000

[    1.537286] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 f6dfcfd7 b1fa57f7

[    1.545912] [<c006f5f8>] (tick_do_update_jiffies64+0xbc/0x110) from [<c006f6f4>] (tick_sched_timer+0x30/0x74)

[    1.556370] [<c006f6f4>] (tick_sched_timer+0x30/0x74) from [<c0058210>] (__run_hrtimer.isra.32+0x5c/0x138)

[    1.566547] [<c0058210>] (__run_hrtimer.isra.32+0x5c/0x138) from [<c0058be0>] (hrtimer_interrupt+0xf8/0x298)

[    1.576917] [<c0058be0>] (hrtimer_interrupt+0xf8/0x298) from [<c0024c54>] (omap2_gp_timer_interrupt+0x28/0x30)

[    1.587471] [<c0024c54>] (omap2_gp_timer_interrupt+0x28/0x30) from [<c007ead0>] (handle_irq_event_percpu+0x38/0x194)

[    1.598561] [<c007ead0>] (handle_irq_event_percpu+0x38/0x194) from [<c007ec68>] (handle_irq_event+0x3c/0x5c)

[    1.608926] [<c007ec68>] (handle_irq_event+0x3c/0x5c) from [<c0080e54>] (handle_level_irq+0x90/0xf4)

[    1.618554] [<c0080e54>] (handle_level_irq+0x90/0xf4) from [<c007e49c>] (generic_handle_irq+0x2c/0x3c)

[    1.628379] [<c007e49c>] (generic_handle_irq+0x2c/0x3c) from [<c0014294>] (handle_IRQ+0x38/0x84)

[    1.637642] [<c0014294>] (handle_IRQ+0x38/0x84) from [<c0008678>] (omap3_intc_handle_irq+0x68/0x74)

[    1.647178] [<c0008678>] (omap3_intc_handle_irq+0x68/0x74) from [<c0013004>] (__irq_svc+0x44/0x58)

[    1.656614] Exception stack(0xcf075e40 to 0xcf075e88)

[    1.661941] 5e40: 00000001 00000008 c0aa4c88 cf06a080 60000113 00000000 cf074000 00000001

[    1.670558] 5e60: cf074038 cf044800 00000000 00000000 c09e58c8 cf075e88 c0074548 c0076514

[    1.679168] 5e80: 80000113 ffffffff

[    1.682858] [<c0013004>] (__irq_svc+0x44/0x58) from [<c0076514>] (lock_acquire+0x74/0x7c)

[    1.691483] [<c0076514>] (lock_acquire+0x74/0x7c) from [<c004f000>] (process_one_work+0x194/0x424)

[    1.700926] [<c004f000>] (process_one_work+0x194/0x424) from [<c004fbf0>] (worker_thread+0x12c/0x3c0)

[    1.710651] [<c004fbf0>] (worker_thread+0x12c/0x3c0) from [<c0054e24>] (kthread+0xb4/0xb8)

[    1.719366] [<c0054e24>] (kthread+0xb4/0xb8) from [<c00134b0>] (ret_from_fork+0x14/0x24)

[    1.727893] Code: e30cc000 e34cc05a e0922000 e0a33001 (e1cc30f0) 

[    1.734376] ---[ end trace 0e7e6f5b5f850239 ]---

[    1.739244] Kernel panic - not syncing: Fatal exception in interrupt

