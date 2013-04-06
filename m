Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab3DFTj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 15:39:28 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33973 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab3DFTjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 15:39:25 -0400
MIME-Version: 1.0
Date: Sat, 6 Apr 2013 16:39:25 -0300
Message-ID: <CAAAP30FOjuXNTZb-NarVpfU80Ad60=KbXN8x_EoUb7BUuEKmwA@mail.gmail.com>
Subject: IMX23 usb instability on 3.9-rc5
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        alexander.shishkin@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: fabio.estevam@freescale.com, Otavio Salvador <otavio@ossystems.com.br>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am testing a usb key connected on a IMX23-Olinuxino board. The
kernel panics at heavy usb trafic. This was build with the mxs
defconfig

This happens everytime with "dd if=/dev/sda of=/dev/null bs=4k". The
messages of the failure varies a lot from run to run.

I tested also on kernel version 3.7.10 and the results are the same.

Please let me know if you need any more details.

Here its the panic messages:
# dd if=/dev/sda of=/dev/null bs=4k
[   83.490000] Unable to handle kernel paging request at virtual
address be7a170c
[   83.490000] pgd = c2b54000
[   83.490000] [be7a170c] *pgd=00000000
[   83.490000] Internal error: Oops: 80000005 [#1] ARM
[   83.490000] Modules linked in:
[   83.490000] CPU: 0    Not tainted  (3.9.0-rc5-00009-ge04a3b9 #4)
[   83.490000] PC is at 0xbe7a170c
[   83.490000] LR is at new_slab+0x274/0x2c4
[   83.490000] pc : [<be7a170c>]    lr : [<c00ba89c>]    psr: 60000093
[   83.490000] sp : c2bc9c68  ip : c3345000  fp : 00000020
[   83.490000] r10: 00000000  r9 : 60000013  r8 : c111f880
[   83.490000] r7 : c3345000  r6 : c3344fc0  r5 : c3344000  r4 : c3401b80
[   83.490000] r3 : 00000000  r2 : 00000040  r1 : c3344fc0  r0 : c3401b80
[   83.490000] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment user
[   83.490000] Control: 0005317f  Table: 42b54000  DAC: 00000015
[   83.490000] Process dd (pid: 112, stack limit = 0xc2bc81b8)
[   83.490000] Stack: (0xc2bc9c68 to 0xc2bca000)
[   83.490000] 9c60:                   c113f300 00000000 c3401b80
c34005c0 00008050 c0401cec
[   83.490000] 9c80: 00000001 c29b4588 00000000 c00e8064 c29b4588
c2bced80 00000001 00400040
[   83.490000] 9ca0: 00000000 c0221334 c29b4588 c2bced80 c0221268
00000000 c3401b80 00008050
[   83.490000] 9cc0: c00e8064 c10dd220 000ec6ff 00000000 00000020
c00ba998 c3401b80 00008050
[   83.490000] 9ce0: 00000001 00000000 00000000 00001000 00000001
c10dd220 00000000 c00e8064
[   83.490000] 9d00: 00000000 c00e8a34 00000001 c10dd220 00000000
00000020 c10dd220 00000001
[   83.490000] 9d20: 00000000 c00e8ad8 c10dd220 c10dd220 00000020
c00e8c28 c3005104 c00eb51c
[   83.490000] 9d40: c3343fc0 c3005114 c00889d0 c3005114 00001d40
c3004ff0 000ec6ff 00000000
[   83.490000] 9d60: c3005108 c00ee1ec c3005114 c3005104 c3005114
c3005104 c3005114 c0406cc0
[   83.490000] 9d80: c10dd220 c0088a4c 60000013 c3005104 00000004
00000020 c10dd220 00000001
[   83.490000] 9da0: 000ec6ff 00000000 00000020 c0091754 00000001
00000000 c00915f4 c00569fc
[   83.490000] 9dc0: 00000001 c2a6d1c0 00000000 91827364 c2a6dee0
c2a6dee0 c2bc9dd8 c2bc9dd8
[   83.490000] 9de0: c10dc994 c10dd254 00001d1c c10dc1a0 00001d1c
c3005104 00000000 c2a6d1c0
[   83.490000] 9e00: 00001d1b 01d1c000 00000000 c0091a28 00000020
c3005104 c2a6d1c0 c0089d1c
[   83.490000] 9e20: 00001d1c 00000001 c2952000 c2935400 01d1c000
00000000 00001000 00000000
[   83.490000] 9e40: c2bc9f40 000cc081 00000000 00000000 00000000
c2a6d248 01d1b000 00000000
[   83.490000] 9e60: 01d1c000 00000000 c2bc9ef8 c3004ff0 00001d1d
00000001 00000002 00000000
[   83.490000] 9e80: 00001000 01421008 00000000 00000000 00000000
c2a6d1c0 00001000 c2bc9f80
[   83.490000] 9ea0: c2b05d80 01d1c000 00000000 00000000 01421008
c00bf214 01d1c000 00000000
[   83.490000] 9ec0: 00000000 00000000 00000000 00000001 ffffffff
c2a6d1c0 00000000 00000000
[   83.490000] 9ee0: 00000000 00000000 c2b05d80 00000000 00000000
00000000 01d1c000 00000000
[   83.490000] 9f00: 00000000 00000000 00001000 00000000 00001000
00000000 00000000 00000000
[   83.490000] 9f20: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   83.490000] 9f40: 01421008 00001000 c2a6d1c0 00001000 c2a6d1c0
01421008 c2bc9f80 c00bf934
[   83.490000] 9f60: c2a6d1c0 01421008 c2a6d1c0 00000000 01421008
00001000 01d1c000 c00bfbb4
[   83.490000] 9f80: 01d1c000 00000000 00001000 000ac968 00000000
01421008 00000003 c000e268
[   83.490000] 9fa0: c2bc8000 c000e0c0 000ac968 00000000 00000000
01421008 00001000 00000000
[   83.490000] 9fc0: 000ac968 00000000 01421008 00000003 00001000
01421008 00001000 01421008
[   83.490000] 9fe0: 00001000 bed23ac8 0000e0dc b6f7e97c 60000010
00000000 00000000 00000000
[   83.490000] [<c00ba89c>] (new_slab+0x274/0x2c4) from [<c0401cec>]
(__slab_alloc.constprop.44+0x394/0x504)
[   83.490000] [<c0401cec>] (__slab_alloc.constprop.44+0x394/0x504)
from [<c00ba998>] (kmem_cache_alloc+0x54/0x154)
[   83.490000] [<c00ba998>] (kmem_cache_alloc+0x54/0x154) from
[<c00e8064>] (alloc_buffer_head+0x14/0x4c)
[   83.490000] [<c00e8064>] (alloc_buffer_head+0x14/0x4c) from
[<c00e8a34>] (alloc_page_buffers+0x1c/0xac)
[   83.490000] [<c00e8a34>] (alloc_page_buffers+0x1c/0xac) from
[<c00e8ad8>] (create_empty_buffers+0x14/0x130)
[   83.490000] [<c00e8ad8>] (create_empty_buffers+0x14/0x130) from
[<c00e8c28>] (create_page_buffers+0x34/0x4c)
[   83.490000] [<c00e8c28>] (create_page_buffers+0x34/0x4c) from
[<c00eb51c>] (block_read_full_page+0x28/0x348)
[   83.490000] [<c00eb51c>] (block_read_full_page+0x28/0x348) from
[<c0091754>] (__do_page_cache_readahead+0x1c0/0x218)
[   83.490000] [<c0091754>] (__do_page_cache_readahead+0x1c0/0x218)
from [<c0091a28>] (ra_submit+0x20/0x24)
[   83.490000] [<c0091a28>] (ra_submit+0x20/0x24) from [<c0089d1c>]
(generic_file_aio_read+0x2c8/0x6c0)
[   83.490000] [<c0089d1c>] (generic_file_aio_read+0x2c8/0x6c0) from
[<c00bf214>] (do_sync_read+0x84/0xc4)
[   83.490000] [<c00bf214>] (do_sync_read+0x84/0xc4) from [<c00bf934>]
(vfs_read+0xac/0x17c)
[   83.490000] [<c00bf934>] (vfs_read+0xac/0x17c) from [<c00bfbb4>]
(sys_read+0x3c/0x60)
[   83.490000] [<c00bfbb4>] (sys_read+0x3c/0x60) from [<c000e0c0>]
(ret_fast_syscall+0x0/0x38)
[   83.490000] Code: 00000000 00000000 00000000 00000000 (00000000)
[   83.490000] ---[ end trace 237a7ee381e8119e ]---
[   83.490000] ------------[ cut here ]------------
[   83.490000] WARNING: at kernel/exit.c:715 do_exit+0x5c/0x854()
[   83.490000] Modules linked in:
[   83.490000] [<c001308c>] (unwind_backtrace+0x0/0xe0) from
[<c001b33c>] (warn_slowpath_common+0x4c/0x68)
[   83.490000] [<c001b33c>] (warn_slowpath_common+0x4c/0x68) from
[<c001b370>] (warn_slowpath_null+0x18/0x1c)
[   83.490000] [<c001b370>] (warn_slowpath_null+0x18/0x1c) from
[<c001fd0c>] (do_exit+0x5c/0x854)
[   83.490000] [<c001fd0c>] (do_exit+0x5c/0x854) from [<c0011270>]
(die+0x210/0x24c)
[   83.490000] [<c0011270>] (die+0x210/0x24c) from [<c00152c0>]
(__do_kernel_fault+0x64/0x84)
[   83.490000] [<c00152c0>] (__do_kernel_fault+0x64/0x84) from
[<c0015608>] (do_page_fault+0x328/0x344)
[   83.490000] [<c0015608>] (do_page_fault+0x328/0x344) from
[<c0008634>] (do_PrefetchAbort+0x34/0x98)
[   83.490000] [<c0008634>] (do_PrefetchAbort+0x34/0x98) from
[<c000ddfc>] (__pabt_svc+0x3c/0x80)
[   83.490000] Exception stack(0xc2bc9c20 to 0xc2bc9c68)
[   83.490000] 9c20: c3401b80 c3344fc0 00000040 00000000 c3401b80
c3344000 c3344fc0 c3345000
[   83.490000] 9c40: c111f880 60000013 00000000 00000020 c3345000
c2bc9c68 c00ba89c be7a170c
[   83.490000] 9c60: 60000093 ffffffff
[   83.490000] [<c000ddfc>] (__pabt_svc+0x3c/0x80) from [<be7a170c>]
(0xbe7a170c)
[   83.490000] ---[ end trace 237a7ee381e8119f ]---

And the boot log:
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.9.0-rc5-00009-ge04a3b9 (alex@alexcmp)
(gcc version 4.6.3 (Sourcery CodeBench Lite 2012.03-56) ) #4 Sat Apr 6
15:57:57 BRT 2013
[    0.000000] CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: Freescale i.MX23 (Device Tree), model: i.MX23
Olinuxino Low Cost Board
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 16384
[    0.000000] free_area_init_node: node 0, pgdat c0b64784,
node_mem_map c10b9000
[    0.000000]   Normal zone: 128 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 16384 pages, LIFO batch:3
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 16256
[    0.000000] Kernel command line: console=ttyAMA0,115200
root=/dev/nfs ip=dhcp nfsroot=192.168.1.54:,v3,tcp
[    0.000000] PID hash table entries: 256 (order: -2, 1024 bytes)
[    0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 64MB = 64MB total
[    0.000000] Memory: 47764k/47764k available, 17772k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc4800000 - 0xff000000   ( 936 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
[    0.000000]     modules : 0xbf000000 - 0xc0000000   (  16 MB)
[    0.000000]       .text : 0xc0008000 - 0xc05b4d28   (5812 kB)
[    0.000000]       .init : 0xc05b5000 - 0xc0b23b04   (5563 kB)
[    0.000000]       .data : 0xc0b24000 - 0xc0b66d08   ( 268 kB)
[    0.000000]        .bss : 0xc0b66d08 - 0xc10b8b2c   (5448 kB)
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0,
CPUs=1, Nodes=1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] of_irq_init: children remain, but no parents
[    0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns,
wraps every 4294967286ms
[    0.000000] Console: colour dummy device 80x30
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3695 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.070000] Calibrating delay loop... 226.09 BogoMIPS (lpj=1130496)
[    0.070000] pid_max: default: 32768 minimum: 301
[    0.070000] Mount-cache hash table entries: 512
[    0.080000] CPU: Testing write buffer coherency: ok
[    0.080000] Setting up static identity map for 0xc0406f00 - 0xc0406f58
[    0.090000] BUG: spinlock bad magic on CPU#0, swapper/1
[    0.090000]  lock: 0xc346a044, .magic: dead00ad, .owner: <none>/-1,
.owner_cpu: -1
[    0.090000] [<c001308c>] (unwind_backtrace+0x0/0xe0) from
[<c023de50>] (do_raw_spin_lock+0x20/0x124)
[    0.090000] [<c023de50>] (do_raw_spin_lock+0x20/0x124) from
[<c04066f0>] (_raw_spin_lock_irqsave+0x44/0x50)
[    0.090000] [<c04066f0>] (_raw_spin_lock_irqsave+0x44/0x50) from
[<c0406560>] (__down_write_nested+0x14/0xb4)
[    0.090000] [<c0406560>] (__down_write_nested+0x14/0xb4) from
[<c00c1eb0>] (sget+0x21c/0x404)
[    0.090000] [<c00c1eb0>] (sget+0x21c/0x404) from [<c00c20bc>]
(mount_nodev+0x24/0xa0)
[    0.090000] [<c00c20bc>] (mount_nodev+0x24/0xa0) from [<c00c2b50>]
(mount_fs+0x10/0xbc)
[    0.090000] [<c00c2b50>] (mount_fs+0x10/0xbc) from [<c00d87fc>]
(vfs_kern_mount+0x4c/0xc0)
[    0.090000] [<c00d87fc>] (vfs_kern_mount+0x4c/0xc0) from
[<c05be530>] (shmem_init+0x6c/0xcc)
[    0.090000] [<c05be530>] (shmem_init+0x6c/0xcc) from [<c05b57ec>]
(kernel_init_freeable+0x68/0x1b0)
[    0.090000] [<c05b57ec>] (kernel_init_freeable+0x68/0x1b0) from
[<c03fdef0>] (kernel_init+0x8/0xe4)
[    0.090000] [<c03fdef0>] (kernel_init+0x8/0xe4) from [<c000e168>]
(ret_from_fork+0x14/0x2c)
[    0.090000] devtmpfs: initialized
[    0.100000] pinctrl core: initialized pinctrl subsystem
[    0.100000] regulator-dummy: no parameters
[    0.100000] NET: Registered protocol family 16
[    0.100000] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.110000] gpiochip_add: registered GPIOs 0 to 31 on device: gpio.0
[    0.120000] gpiochip_add: registered GPIOs 32 to 63 on device: gpio.1
[    0.120000] gpiochip_add: registered GPIOs 64 to 95 on device: gpio.2
[    0.130000] Serial: AMBA PL011 UART driver
[    0.130000] 80070000.serial: ttyAMA0 at MMIO 0x80070000 (irq = 129)
is a PL011 rev2
[    0.430000] console [ttyAMA0] enabled
[    0.450000] bio: create slab <bio-0> at 0
[    0.460000] mxs-dma 80004000.dma-apbh: initialized
[    0.470000] mxs-dma 80024000.dma-apbx: initialized
[    0.480000] of_get_named_gpio_flags exited with status 17
[    0.480000] usb0_vbus: 5000 mV
[    0.490000] SCSI subsystem initialized
[    0.490000] usbcore: registered new interface driver usbfs
[    0.500000] usbcore: registered new interface driver hub
[    0.500000] usbcore: registered new device driver usb
[    0.510000] pps_core: LinuxPPS API ver. 1 registered
[    0.510000] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    0.520000] PTP clock support registered
[    0.520000] Advanced Linux Sound Architecture Driver Initialized.
[    0.530000] Switching to clocksource mxs_timer
[    0.700000] NET: Registered protocol family 2
[    0.710000] TCP established hash table entries: 512 (order: 0, 4096 bytes)
[    0.720000] TCP bind hash table entries: 512 (order: 2, 18432 bytes)
[    0.720000] TCP: Hash tables configured (established 512 bind 512)
[    0.730000] TCP: reno registered
[    0.730000] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.740000] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.750000] NET: Registered protocol family 1
[    0.750000] RPC: Registered named UNIX socket transport module.
[    0.760000] RPC: Registered udp transport module.
[    0.760000] RPC: Registered tcp transport module.
[    0.770000] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.240000] NetWinder Floating Point Emulator V0.97 (double precision)
[    1.310000] NFS: Registering the id_resolver key type
[    1.320000] Key type id_resolver registered
[    1.320000] Key type id_legacy registered
[    1.330000] jffs2: version 2.2. (NAND) �© 2001-2006 Red Hat, Inc.
[    1.340000] msgmni has been set to 93
[    1.390000] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 250)
[    1.400000] io scheduler noop registered (default)
[    1.400000] uart-pl011 80070000.serial: no DMA platform data
[    1.410000] 8006c000.serial: ttyAPP0 at MMIO 0x8006c000 (irq = 126)
is a 8006c000.serial
[    1.420000] mxs-auart 8006c000.serial: Found APPUART 3.0.0
[    1.440000] usbcore: registered new interface driver asix
[    1.440000] usbcore: registered new interface driver ax88179_178a
[    1.450000] usbcore: registered new interface driver cdc_ether
[    1.460000] usbcore: registered new interface driver smsc95xx
[    1.460000] usbcore: registered new interface driver net1080
[    1.470000] usbcore: registered new interface driver cdc_subset
[    1.480000] usbcore: registered new interface driver zaurus
[    1.480000] usbcore: registered new interface driver cdc_ncm
[    1.490000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.500000] Initializing USB Mass Storage driver...
[    1.500000] usbcore: registered new interface driver usb-storage
[    1.510000] USB Mass Storage support registered.
[    1.510000] imx_usb 80080000.usb: pinctrl get/select failed, err=-19
[    1.520000] ci_hdrc ci_hdrc.0: doesn't support gadget
[    1.530000] ci_hdrc ci_hdrc.0: EHCI Host Controller
[    1.530000] ci_hdrc ci_hdrc.0: new USB bus registered, assigned bus number 1
[    1.560000] ci_hdrc ci_hdrc.0: USB 2.0 started, EHCI 1.00
[    1.560000] hub 1-0:1.0: USB hub found
[    1.570000] hub 1-0:1.0: 1 port detected
[    1.570000] mousedev: PS/2 mouse device common for all mice
[    1.590000] stmp3xxx-rtc 8005c000.rtc: rtc core: registered
8005c000.rtc as rtc0
[    1.590000] i2c /dev entries driver
[    1.600000] of_get_named_gpio_flags: can't parse gpios property
[    1.650000] mxs-mmc 80010000.ssp: initialized
[    1.650000] of_get_named_gpio_flags exited with status 65
[    1.660000] of_get_named_gpio_flags exited with status 65
[    1.680000] usbcore: registered new interface driver usbhid
[    1.680000] usbhid: USB HID core driver
[    1.690000] TCP: cubic registered
[    1.690000] NET: Registered protocol family 17
[    1.700000] Key type dns_resolver registered
[    1.710000] registered taskstats version 1
[    1.720000] mmc0: host does not support reading read-only switch.
assuming write-enable.
[    1.730000] stmp3xxx-rtc 8005c000.rtc: setting system clock to
1970-01-01 00:10:48 UTC (648)
[    1.740000] mmc0: new SD card at address e40c
[    1.740000] mmcblk0: mmc0:e40c SU02G 1.89 GiB
[    1.760000]  mmcblk0: p1 p2 p3
[    1.890000] usb 1-1: new high-speed USB device number 2 using ci_hdrc
[    2.040000] hub 1-1:1.0: USB hub found
[    2.040000] hub 1-1:1.0: 3 ports detected
[    2.330000] usb 1-1.1: new high-speed USB device number 3 using ci_hdrc
[    2.460000] smsc95xx v1.0.4
[    2.540000] smsc95xx 1-1.1:1.0 eth0: register 'smsc95xx' at
usb-ci_hdrc.0-1.1, smsc95xx USB 2.0 Ethernet, 8a:e5:a5:9b:f7:a2
[    2.790000] usb 1-1.2: new high-speed USB device number 4 using ci_hdrc
[    2.840000] smsc95xx 1-1.1:1.0 eth0: hardware isn't capable of remote wakeup
[    2.930000] scsi0 : usb-storage 1-1.2:1.0
[    3.940000] scsi 0:0:0:0: Direct-Access     Generic- SD/MMC
  1.00 PQ: 0 ANSI: 0 CCS
[    4.270000] smsc95xx 1-1.1:1.0 eth0: link up, 100Mbps, full-duplex,
lpa 0xC5E1
[    4.600000] sd 0:0:0:0: [sda] 7747584 512-byte logical blocks:
(3.96 GB/3.69 GiB)
[    4.610000] sd 0:0:0:0: [sda] Write Protect is off
[    4.620000] sd 0:0:0:0: [sda] Mode Sense: 03 00 00 00
[    4.630000] sd 0:0:0:0: [sda] No Caching mode page present
[    4.630000] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    4.650000] sd 0:0:0:0: [sda] No Caching mode page present
[    4.650000] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    4.660000]  sda: sda1
[    4.670000] sd 0:0:0:0: [sda] No Caching mode page present
[    4.680000] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    4.690000] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    4.310000] Sending DHCP requests ., OK
[    5.330000] IP-Config: Got DHCP answer from 192.168.1.1, my address
is 192.168.1.114
[    5.330000] IP-Config: Complete:
[    5.340000]      device=eth0, hwaddr=8a:e5:a5:9b:f7:a2,
ipaddr=192.168.1.114, mask=255.255.255.0, gw=192.168.1.1
[    5.350000]      host=192.168.1.114, domain=, nis-domain=(none)
[    5.350000]      bootserver=0.0.0.0, rootserver=192.168.1.54, rootpath=
[    5.360000]      nameserver0=201.6.2.85, nameserver1=8.8.8.8
[    5.370000] ALSA device list:
[    5.370000]   No soundcards found.
[    5.410000] Freeing init memory: 5560K
[    5.780000] udevd[53]: starting version 182
