Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaDTVQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 17:16:16 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:42618 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbaDTVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 17:16:11 -0400
X-Greylist: delayed 1170 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2014 17:16:10 EDT
Date: Sun, 20 Apr 2014 22:56:39 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: 3.14 on Xenserver (non-HVM): "cannot allocate memory")
Message-ID: <20140420205639.GA22293@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have one rented Vserver which is hosted on Xenserver 6.2 at Hoster
A. I can use my own kernels there, and I use the kernel that also run
on my bare metal servers.

This works fine up to and including 3.13.2 (didn't try any higher 3.13
kernel).

Linux 3.14, however, does not yet beyond the initramfs state ("cannot
allocate memory". This also happens when i set cgroup_disable=memory.

Here a log:
|Initializing cgroup subsys cpuset
|Initializing cgroup subsys cpu
|Initializing cgroup subsys cpuacct
|Linux version 3.14.0-zgsrv20080 (mh@fan) (gcc version 4.8.2 (Debian 4.8.2-18) ) #2 SMP PREEMPT Tue Apr 1 20:00:43 UTC 2014
|Command line: root=/dev/mapper/fake-root ro
|KERNEL supported cpus:
|  Intel GenuineIntel
|  AMD AuthenticAMD
|  Centaur CentaurHauls
|ACPI in unprivileged domain disabled
|e820: BIOS-provided physical RAM map:
|Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
|Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
|Xen: [mem 0x0000000000100000-0x000000000fffffff] usable
|NX (Execute Disable) protection: active
|DMI not present or invalid.
|No AGP bridge found
|e820: last_pfn = 0x10000 max_arch_pfn = 0x400000000
|init_memory_mapping: [mem 0x00000000-0x000fffff]
|init_memory_mapping: [mem 0x0fe00000-0x0fffffff]
|init_memory_mapping: [mem 0x0c000000-0x0fdfffff]
|init_memory_mapping: [mem 0x00100000-0x0bffffff]
|RAMDISK: [mem 0x01bb6000-0x02b8efff]
|NUMA turned off
|Faking a node at [mem 0x0000000000000000-0x000000000fffffff]
|Initmem setup node 0 [mem 0x00000000-0x0fffffff]
|  NODE_DATA [mem 0x0ff9a000-0x0ff9dfff]
|Zone ranges:
|  DMA      [mem 0x00001000-0x00ffffff]
|  DMA32    [mem 0x01000000-0xffffffff]
|  Normal   empty
|Movable zone start for each node
|Early memory node ranges
|  node   0: [mem 0x00001000-0x0009ffff]
|  node   0: [mem 0x00100000-0x0fffffff]
|SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
|smpboot: Allowing 1 CPUs, 0 hotplug CPUs
|e820: [mem 0x10000000-0xffffffff] available for PCI devices
|Booting paravirtualized kernel on Xen
|Xen version: 4.1.5 (preserve-AD)
|setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
|PERCPU: Embedded 27 pages/cpu @ffff88000fc00000 s80384 r8192 d22016 u2097152
|Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64522
|Policy zone: DMA32
|Kernel command line: root=/dev/mapper/fake-root ro
|PID hash table entries: 1024 (order: 1, 8192 bytes)
|Checking aperture...
|No AGP bridge found
|Memory: 232832K/261756K available (4338K kernel code, 539K rwdata, 1496K rodata, 896K init, 456K bss, 28924K reserved)
|Preemptible hierarchical RCU implementation.
|CONFIG_RCU_FANOUT set to non-default value of 32
|RCU dyntick-idle grace-period acceleration is enabled.
|RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=1.
|RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
|NR_IRQS:4352 nr_irqs:256 16
|xen:events: Using 2-level ABI
|Console: colour dummy device 80x25
|console [tty0] enabled
|console [hvc0] enabled
|allocated 1048576 bytes of page_cgroup
|please try 'cgroup_disable=memory' option if you don't want memory cgroups
|installing Xen timer for CPU 0
|tsc: Detected 2266.796 MHz processor
|Calibrating delay loop (skipped), value calculated using timer frequency.. 4533.59 BogoMIPS (lpj=9067184)
|pid_max: default: 32768 minimum: 301
|Security Framework initialized
|Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
|Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
|Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
|Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
|Initializing cgroup subsys memory
|Initializing cgroup subsys devices
|Initializing cgroup subsys freezer
|Initializing cgroup subsys net_cls
|Initializing cgroup subsys blkio
|CPU: Physical Processor ID: 1
|CPU: Processor Core ID: 1
|Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
|Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
|tlb_flushall_shift: 6
|Freeing SMP alternatives memory: 16K (ffffffff8171d000 - ffffffff81721000)
|Performance Events: unsupported p6 CPU model 26 no PMU driver, software events only.
|x86: Booted up 1 node, 1 CPUs
|NMI watchdog: disabled (cpu0): hardware events not enabled
|devtmpfs: initialized
|prandom: seed boundary self test passed
|prandom: 100 self tests passed
|pinctrl core: initialized pinctrl subsystem
|NET: Registered protocol family 16
|xen:grant_table: Grant tables using version 1 layout
|Grant table initialized
|PCI: setting up Xen PCI frontend stub
|bio: create slab <bio-0> at 0
|ACPI: Interpreter disabled.
|xen:balloon: Initialising balloon driver
|xen_balloon: Initialising balloon driver
|vgaarb: loaded
|SCSI subsystem initialized
|PCI: System does not support PCI
|PCI: System does not support PCI
|NetLabel: Initializing
|NetLabel:  domain hash size = 128
|NetLabel:  protocols = UNLABELED CIPSOv4
|NetLabel:  unlabeled traffic allowed by default
|Switched to clocksource xen
|pnp: PnP ACPI: disabled
|NET: Registered protocol family 2
|TCP established hash table entries: 2048 (order: 2, 16384 bytes)
|TCP bind hash table entries: 2048 (order: 3, 32768 bytes)
|TCP: Hash tables configured (established 2048 bind 2048)
|TCP: reno registered
|UDP hash table entries: 256 (order: 1, 8192 bytes)
|UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
|NET: Registered protocol family 1
|Unpacking initramfs...
|Freeing initrd memory: 16228K (ffff880001bb6000 - ffff880002b8f000)
|platform rtc_cmos: registered platform RTC device (no PNP device found)
|futex hash table entries: 256 (order: 2, 16384 bytes)
|Initialise system trusted keyring
|audit: initializing netlink subsys (disabled)
|audit: type=2000 audit(1397169380.032:1): initialized
|bounce pool size: 64 pages
|VFS: Disk quotas dquot_6.5.2
|Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
|msgmni has been set to 486
|alg: No test for stdrng (krng)
|Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
|io scheduler noop registered
|io scheduler deadline registered (default)
|pci_hotplug: PCI Hot Plug PCI Core version: 0.5
|pciehp: PCI Express Hot Plug Controller Driver version: 0.4
|xen:xen_evtchn: Event-channel device installed
|Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
|Linux agpgart interface v0.103
|xen_netfront: Initialising Xen virtual ethernet driver
|Fusion MPT base driver 3.04.20
|Copyright (c) 1999-2008 LSI Corporation
|Fusion MPT SPI Host driver 3.04.20
|i8042: PNP: No PS/2 controller found. Probing ports directly.
|i8042: No controller found
|mousedev: PS/2 mouse device common for all mice
|blkfront: xvda: barrier: enabled; persistent grants: disabled; indirect descriptors: disabled;
| xvda: xvda1 xvda2 < xvda5 >
|rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
|rtc_cmos: probe of rtc_cmos failed with error -38
|hidraw: raw HID events driver (C) Jiri Kosina
|GACT probability on
|TCP: cubic registered
|NET: Registered protocol family 10
|NET: Registered protocol family 17
|NET: Registered protocol family 15
|Key type dns_resolver registered
|Loading compiled-in X.509 certificates
|registered taskstats version 1
|drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
|Freeing unused kernel memory: 896K (ffffffff8163d000 - ffffffff8171d000)
|Loading, please wait...
|udevd[367]: starting version 175
|Begin: Loading essential drivers ... done.
|Begin: Running /scripts/init-premount ... done.
|Begin: Mounting root file system ... Begin: Running /scripts/local-top ... ------------[ cut here ]------------
|WARNING: CPU: 0 PID: 401 at mm/vmalloc.c:126 vmap_page_range_noflush+0x2d1/0x370()
|Modules linked in:
|CPU: 0 PID: 401 Comm: busybox Not tainted 3.14.0-zgsrv20080 #2
| 0000000000000009 ffffffff8143336b 0000000000000000 ffffffff8104ecbd
| ffff880002c15000 ffffffffc0013000 0000000000000001 ffff88000270cbc0
| ffffffffc0000000 ffffffff81102921 0000000000000163 ffffffffc0013000
|Call Trace:
| [<ffffffff8143336b>] ? dump_stack+0x49/0x6a
| [<ffffffff8104ecbd>] ? warn_slowpath_common+0x6d/0x90
| [<ffffffff81102921>] ? vmap_page_range_noflush+0x2d1/0x370
| [<ffffffff811029e5>] ? map_vm_area+0x25/0x40
| [<ffffffff81103b52>] ? __vmalloc_node_range+0x182/0x280
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff8103cd52>] ? module_alloc+0x52/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a761b>] ? load_module+0x83b/0x2170
| [<ffffffff811028ad>] ? vmap_page_range_noflush+0x25d/0x370
| [<ffffffff811029e5>] ? map_vm_area+0x25/0x40
| [<ffffffff81103b52>] ? __vmalloc_node_range+0x182/0x280
| [<ffffffff810a8fb7>] ? SyS_init_module+0x67/0xc0
| [<ffffffff810a8fe1>] ? SyS_init_module+0x91/0xc0
| [<ffffffff814390b9>] ? system_call_fastpath+0x16/0x1b
|---[ end trace eef5601df5f97c30 ]---
|vmalloc: allocation failure, allocated 77824 of 81920 bytes
|busybox: page allocation failure: order:0, mode:0xd2
|CPU: 0 PID: 401 Comm: busybox Tainted: G        W    3.14.0-zgsrv20080 #2
| ffff8800027c5d40 ffffffff8143336b 00000000000000d2 ffffffff810d6fe7
| ffffffff8152b4d8 ffff8800027c5cd8 ffffffff00000018 ffff8800027c5d50
| ffff8800027c5cf0 ffffffffc0013000 ffffffffc0012fff ffffffffc0012fff
|Call Trace:
| [<ffffffff8143336b>] ? dump_stack+0x49/0x6a
| [<ffffffff810d6fe7>] ? warn_alloc_failed+0xd7/0x130
| [<ffffffff81103c1b>] ? __vmalloc_node_range+0x24b/0x280
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff8103cd52>] ? module_alloc+0x52/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a761b>] ? load_module+0x83b/0x2170
| [<ffffffff811028ad>] ? vmap_page_range_noflush+0x25d/0x370
| [<ffffffff811029e5>] ? map_vm_area+0x25/0x40
| [<ffffffff81103b52>] ? __vmalloc_node_range+0x182/0x280
| [<ffffffff810a8fb7>] ? SyS_init_module+0x67/0xc0
| [<ffffffff810a8fe1>] ? SyS_init_module+0x91/0xc0
| [<ffffffff814390b9>] ? system_call_fastpath+0x16/0x1b
|Mem-Info:
|Node 0 DMA per-cpu:
|CPU    0: hi:    0, btch:   1 usd:   0
|Node 0 DMA32 per-cpu:
|CPU    0: hi:   90, btch:  15 usd:  15
|active_anon:883 inactive_anon:0 isolated_anon:0
| active_file:445 inactive_file:3741 isolated_file:0
| unevictable:0 dirty:0 writeback:0 unstable:0
| free:55216 slab_reclaimable:269 slab_unreclaimable:778
| mapped:252 shmem:7 pagetables:253 bounce:0
| free_cma:0
|Node 0 DMA free:15520kB min:124kB low:152kB high:184kB active_anon:252kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15996kB managed:15912kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:24kB pagetables:32kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
|lowmem_reserve[]: 0 227 227 227
|Node 0 DMA32 free:205344kB min:1868kB low:2332kB high:2800kB active_anon:3280kB inactive_anon:0kB active_file:1780kB inactive_file:14964kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:245760kB managed:234060kB mlocked:0kB dirty:0kB writeback:0kB mapped:1008kB shmem:28kB slab_reclaimable:1076kB slab_un
|eclaimable:3112kB kernel_stack:456kB pagetables:980kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
|lowmem_reserve[]: 0 0 0 0
|Node 0 DMA: 2*4kB (M) 4*8kB (UM) 1*16kB (M) 1*32kB (M) 1*64kB (M) 2*128kB (UM) 1*256kB (U) 1*512kB (M) 2*1024kB (UM) 2*2048kB (UM) 2*4096kB (MR) = 15512kB
|Node 0 DMA32: 2*4kB (UE) 1*8kB (M) 9*16kB (UM) 2*32kB (M) 3*64kB (UEM) 3*128kB (UEM) 1*256kB (E) 5*512kB (EM) 5*1024kB (M) 4*2048kB (EM) 46*4096kB (MR) = 205344kB
|4197 total pagecache pages
|0 pages in swap cache
|Swap cache stats: add 0, delete 0, find 0/0
|Free swap  = 0kB
|Total swap = 0kB
|65439 pages RAM
|0 pages HighMem/MovableOnly
|2925 pages reserved
|modprobe: can't load module dm-mod (kernel/drivers/md/dm-mod.ko): Cannot allocate memory
|------------[ cut here ]------------
|WARNING: CPU: 0 PID: 405 at mm/vmalloc.c:126 vmap_page_range_noflush+0x2d1/0x37
|()
|Modules linked in:
|CPU: 0 PID: 405 Comm: modprobe Tainted: G        W    3.14.0-zgsrv20080 #2
| 0000000000000009 ffffffff8143336b 0000000000000000 ffffffff8104ecbd
| ffff880002c150a0 ffffffffc0027000 0000000000000001 ffff88000270cbc0
| ffffffffc0014000 ffffffff81102921 0000000000000163 ffffffffc0027000
|Call Trace:
| [<ffffffff8143336b>] ? dump_stack+0x49/0x6a
| [<ffffffff8104ecbd>] ? warn_slowpath_common+0x6d/0x90
| [<ffffffff81102921>] ? vmap_page_range_noflush+0x2d1/0x370
| [<ffffffff811029e5>] ? map_vm_area+0x25/0x40
| [<ffffffff81103b52>] ? __vmalloc_node_range+0x182/0x280
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff8103cd52>] ? module_alloc+0x52/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a761b>] ? load_module+0x83b/0x2170
| [<ffffffff811028ad>] ? vmap_page_range_noflush+0x25d/0x370
| [<ffffffff81438dea>] ? error_exit+0x2a/0x60
| [<ffffffff814388bf>] ? retint_restore_args+0x5/0x6
| [<ffffffff810a8fe1>] ? SyS_init_module+0x91/0xc0
| [<ffffffff814390b9>] ? system_call_fastpath+0x16/0x1b
|---[ end trace eef5601df5f97c31 ]---
|vmalloc: allocation failure, allocated 77824 of 81920 bytes
|modprobe: page allocation failure: order:0, mode:0xd2
|CPU: 0 PID: 405 Comm: modprobe Tainted: G        W 3.14.0-zgsrv20080 #2
| ffff88000278fd40 ffffffff8143336b 00000000000000d2 ffffffff810d6fe7
| ffffffff8152b4d8 ffff88000278fcd8 ffffffff00000018 ffff88000278fd50
| ffff88000278fcf0 ffffffffc0027000 ffffffffc0026fff ffffffffc0026fff
|Call Trace:
| [<ffffffff8143336b>] ? dump_stack+0x49/0x6a
| [<ffffffff810d6fe7>] ? warn_alloc_failed+0xd7/0x130
| [<ffffffff81103c1b>] ? __vmalloc_node_range+0x24b/0x280
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff8103cd52>] ? module_alloc+0x52/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a6d6a>] ? module_alloc_update_bounds+0xa/0x60
| [<ffffffff810a761b>] ? load_module+0x83b/0x2170
| [<ffffffff811028ad>] ? vmap_page_range_noflush+0x25d/0x370
| [<ffffffff81438dea>] ? error_exit+0x2a/0x60
| [<ffffffff814388bf>] ? retint_restore_args+0x5/0x6
| [<ffffffff810a8fe1>] ? SyS_init_module+0x91/0xc0
| [<ffffffff814390b9>] ? system_call_fastpath+0x16/0x1b
|Mem-Info:
|Node 0 DMA per-cpu:
|CPU    0: hi:    0, btch:   1 usd:   0
|Node 0 DMA32 per-cpu:
|CPU    0: hi:   90, btch:  15 usd:  27
|active_anon:936 inactive_anon:0 isolated_anon:0
| active_file:510 inactive_file:3676 isolated_file:0
| unevictable:0 dirty:0 writeback:0 unstable:0
| free:55135 slab_reclaimable:269 slab_unreclaimable:778
| mapped:469 shmem:7 pagetables:267 bounce:0
| free_cma:0
|Node 0 DMA free:15496kB min:124kB low:152kB high:184kB
active_anon:264kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15996kB
managed:15912kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB
kernel_stack:24kB pagetables:32kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
|lowmem_reserve[]: 0 227 227 227
|Node 0 DMA32 free:205044kB min:1868kB low:2332kB high:2800kB
active_anon:3480kB inactive_anon:0kB active_file:2040kB
inactive_file:14704kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:245760kB managed:234060kB mlocked:0kB
dirty:0kB writeback:0kB mapped:1876kB shmem:28kB
slab_reclaimable:1076kB slab_unreclaimable:3112kB kernel_stack:456kB
pagetables:1036kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
|lowmem_reserve[]: 0 0 0 0
|Node 0 DMA: 1*4kB (M) 2*8kB (U) 1*16kB (M) 1*32kB (M) 1*64kB (M)
2*128kB (UM) 1*256kB (U) 1*512kB (M) 2*1024kB (UM) 2*2048kB (UM)
2*4096kB (MR) = 15492kB
|Node 0 DMA32: 1*4kB (U) 2*8kB (EM) 2*16kB (U) 0*32kB 1*64kB (U)
3*128kB (UEM) 1*256kB (E) 5*512kB (EM) 5*1024kB (M) 4*2048kB (EM)
46*4096kB (MR) = 205044kB
|4197 total pagecache pages
|0 pages in swap cache
|Swap cache stats: add 0, delete 0, find 0/0
|Free swap  = 0kB
|Total swap = 0kB
|65439 pages RAM
|0 pages HighMem/MovableOnly
|2925 pages reserved
|  /dev/mapper/control: open failed: No such device
|  Failure to communicate with kernel device-mapper driver.
|  Check that device-mapper is available in the kernel.
|random: lvm urandom read with 25 bits of entropy available
|  Command failed with status code 5.
|Unable to find LVM volume fake/root
|done.
|BUG: unable to handle kernel paging request at ffff88000001d000
|IP: [<ffffffff811e6e27>] clear_page_c+0x7/0x10
|PGD 15c3067 PUD 15c4067 PMD 2c15067 PTE 0
|Oops: 0002 [#1] PREEMPT SMP 
|Modules linked in:
|CPU: 0 PID: 1 Comm: init Tainted: G        W    3.14.0-zgsrv20080 #2
|task: ffff88000edb1030 ti: ffff88000edb2000 task.ti: ffff88000edb2000
|RIP: e030:[<ffffffff811e6e27>]  [<ffffffff811e6e27>]
clear_page_c+0x7/0x10
|RSP: e02b:ffff88000edb3b08  EFLAGS: 00010246
|RAX: 0000000000000000 RBX: ffff880000000000 RCX: 0000000000000200
|RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88000001d000
|RBP: 6db6db6db6db6db7 R08: ffffffff81528a3f R09: ffffea0000000690
|R10: ffff88000ff9a080 R11: 0000000000000001 R12: 0000000000000690
|R13: ffffea0000000658 R14: 0000000000000658 R15: ffff88000fc15be8
|FS:  00007f58506d8700(0000) GS:ffff88000fc00000(0000)
knlGS:0000000000000000
|CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
|CR2: ffff88000001d000 CR3: 00000000024f9000 CR4: 0000000000002660
|Stack:
| ffffffff810d92bf 0000000000000200 00000000000284d0 0000000000000001
| 0000000000000010 ffff88000ff9b818 00000000ffffffff 00000041ffffffff
| 0000000000000000 0000000200000000 0000000000000000 0000000000000000
|Call Trace:
| [<ffffffff810d92bf>] ? get_page_from_freelist+0x5ef/0x930
| [<ffffffff810d9fd8>] ? __alloc_pages_nodemask+0x128/0xa40
| [<ffffffff810d9fd8>] ? __alloc_pages_nodemask+0x128/0xa40
| [<ffffffff810d9fd8>] ? __alloc_pages_nodemask+0x128/0xa40
| [<ffffffff8110c867>] ? alloc_pages_current+0x97/0x150
| [<ffffffff810d63d5>] ? __get_free_pages+0x5/0x50
| [<ffffffff810f4d98>] ? __pud_alloc+0x18/0xe0
| [<ffffffff810f5cde>] ? copy_page_range+0x41e/0x450
| [<ffffffff8110058c>] ? anon_vma_clone+0xcc/0x160
| [<ffffffff8104d766>] ? copy_process.part.31+0x1456/0x1b80
| [<ffffffff8104e02c>] ? do_fork+0xcc/0x2a0
| [<ffffffff81142e8e>] ? mntput_no_expire+0xe/0x160
| [<ffffffff810692c4>] ? task_work_run+0x94/0xd0
| [<ffffffff81439419>] ? stub_clone+0x69/0x90
| [<ffffffff814390b9>] ? system_call_fastpath+0x16/0x1b
|Code: da 89 d1 7f c7 85 d2 7f 9d 89 d0 eb bf 0f 1f 80 00 00 00 00 e8
eb 7c e6 ff 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3>
48 ab c3 0f 1f 44 00 00 b9 00 10 00 00 31 c0 f3 aa c3 66 0f 
|RIP  [<ffffffff811e6e27>] clear_page_c+0x7/0x10
| RSP <ffff88000edb3b08>
|CR2: ffff88000001d000
|---[ end trace eef5601df5f97c32 ]---
|note: init[1] exited with preempt_count 1
|BUG: scheduling while atomic: init/1/0x00000002
|Modules linked in:
|CPU: 0 PID: 1 Comm: init Tainted: G      D W    3.14.0-zgsrv20080 #2
| ffff88000edb1030 ffffffff8143336b ffff88000edb1030 ffffffff814323ca
| ffffffff81435669 0000000000012d40 0000000000012d40 ffff88000edb3fd8
| ffff88000edb1030 0000000000040001 ffffffff8100122a 0000000000040001
|Call Trace:
| [<ffffffff8143336b>] ? dump_stack+0x49/0x6a
| [<ffffffff814323ca>] ? __schedule_bug+0x43/0x50
| [<ffffffff81435669>] ? __schedule+0x629/0x730
| [<ffffffff8100122a>] ? xen_hypercall_xen_version+0xa/0x20
| [<ffffffff8100122a>] ? xen_hypercall_xen_version+0xa/0x20
| [<ffffffff8100122a>] ? xen_hypercall_xen_version+0xa/0x20
| [<ffffffff81007869>] ? xen_force_evtchn_callback+0x9/0x10
| [<ffffffff81008182>] ? check_events+0x12/0x20
| [<ffffffff81437905>] ? rwsem_down_read_failed+0xc5/0x120
| [<ffffffff811e86a4>] ? call_rwsem_down_read_failed+0x14/0x30
| [<ffffffff8143743e>] ? down_read+0xe/0x10
| [<ffffffff810aad2e>] ? acct_collect+0x3e/0x190
| [<ffffffff81051350>] ? do_exit+0x790/0xa60
| [<ffffffff814381ad>] ? _raw_spin_unlock_irqrestore+0xd/0x30
| [<ffffffff8100f365>] ? oops_end+0x75/0xa0
| [<ffffffff81431c1b>] ? no_context+0x27a/0x286
| [<ffffffff8104338e>] ? __do_page_fault+0x2be/0x480
| [<ffffffff810d21b2>] ? find_get_page+0x52/0x80
| [<ffffffff81120a77>] ? __mem_cgroup_try_charge+0x3f7/0x7b0
| [<ffffffff81438b88>] ? page_fault+0x28/0x30
| [<ffffffff811e6e27>] ? clear_page_c+0x7/0x10
| [<ffffffff810d92bf>] ? get_page_from_freelist+0x5ef/0x930
| [<ffffffff810d9fd8>] ? __alloc_pages_nodemask+0x128/0xa40
| [<ffffffff810d9fd8>] ? __alloc_pages_nodemask+0x128/0xa40
| [<ffffffff810d9fd8>] ? __alloc_pages_nodemask+0x128/0xa40
| [<ffffffff8110c867>] ? alloc_pages_current+0x97/0x150
| [<ffffffff810d63d5>] ? __get_free_pages+0x5/0x50
| [<ffffffff810f4d98>] ? __pud_alloc+0x18/0xe0
| [<ffffffff810f5cde>] ? copy_page_range+0x41e/0x450
| [<ffffffff8110058c>] ? anon_vma_clone+0xcc/0x160
| [<ffffffff8104d766>] ? copy_process.part.31+0x1456/0x1b80
| [<ffffffff8104e02c>] ? do_fork+0xcc/0x2a0
| [<ffffffff81142e8e>] ? mntput_no_expire+0xe/0x160
| [<ffffffff810692c4>] ? task_work_run+0x94/0xd0
| [<ffffffff81439419>] ? stub_clone+0x69/0x90
| [<ffffffff814390b9>] ? system_call_fastpath+0x16/0x1b
|BUG: unable to handle kernel paging request at ffff880000017f08
|IP: [<ffffffff81085df3>] __wake_up_common+0x23/0x80
|PGD 15c3067 PUD 15c4067 PMD 2c15067 PTE 0
|Oops: 0000 [#2] PREEMPT SMP 
|Modules linked in:
|CPU: 0 PID: 367 Comm: udevd Tainted: G      D W    3.14.0-zgsrv20080 #2
|task: ffff88000efdd470 ti: ffff880000084000 task.ti: ffff880000084000
|RIP: e030:[<ffffffff81085df3>]  [<ffffffff81085df3>]
__wake_up_common+0x23/0x80
|RSP: e02b:ffff880000085d40  EFLAGS: 00010082
|RAX: ffff880002540078 RBX: ffff880002535540 RCX: 0000000000000000
|RDX: ffff880000017f08 RSI: 0000000000000003 RDI: ffff880002535570
|RBP: ffff880002535578 R08: 0000000000000000 R09: e000000000000000
|R10: 66f8000000000000 R11: 0001fa84cde2acdf R12: 0000000000000000
|R13: 0000000000000000 R14: 0000000000000003 R15: ffff880002636c00
|FS:  00007fa3c50e07a0(0000) GS:ffff88000fc00000(0000)
knlGS:0000000000000000
|CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
|CR2: ffff880000017f08 CR3: 0000000000083000 CR4: 0000000000002660
|Stack:
| 00000001003729d8 ffff880002535540 ffff880002541a00 0000000000000000
| 0000000000000000 0000000000000003 ffff880002636c00 ffffffff81164f39
| ffff880002540078 0000000000000000 ffff880002636c18 0000000000000000
|Call Trace:
| [<ffffffff81164f39>] ? ep_poll_callback+0x99/0x170
| [<ffffffff81085e1f>] ? __wake_up_common+0x4f/0x80
| [<ffffffff8108602f>] ? __wake_up+0x2f/0x50
| [<ffffffff8105bc16>] ? __send_signal+0x3a6/0x3b0
| [<ffffffff8105c6e6>] ? do_send_sig_info+0x36/0x70
| [<ffffffff8105caa1>] ? kill_pid_info+0x31/0x60
| [<ffffffff8105df86>] ? SyS_kill+0x86/0x190
| [<ffffffff810772a0>] ? wake_up_process+0x30/0x30
| [<ffffffff814390b9>] ? system_call_fastpath+0x16/0x1b
|Code: 0f 1f 84 00 00 00 00 00 41 57 41 56 41 89 f6 41 55 41 89 cd 41
54 4d 89 c4 55 48 8d 6f 08 53 48 83 ec 08 89 54 24 04 48 8b 57 08 <48>
8b 0a 48 39 d5 48 8d 42 e8 4c 8d 79 e8 75 0b eb 3b 0f 1f 00 
|RIP  [<ffffffff81085df3>] __wake_up_common+0x23/0x80
| RSP <ffff880000085d40>
|CR2: ffff880000017f08
|---[ end trace eef5601df5f97c33 ]---
|note: udevd[367] exited with preempt_count 3

The same kernel runs fine on Hoster T's Xenserver 6.2 (which seems to
by a HVM DomU). The kernel log differs already at the beginning which
is probably caused by HVM.

Here a kernel log from Hoster T's Vserver:
|Initializing cgroup subsys cpuset
|Initializing cgroup subsys cpu
|Initializing cgroup subsys cpuacct
|Linux version 3.14.0-zgsrv20080 (mh@fan) (gcc version 4.8.2 (Debian
4.8.2-18) ) #2 SMP PREEMPT Tue Apr 1 20:00:43 UTC 2014
|Command line: BOOT_IMAGE=/boot/vmlinuz-3.14.0-zgsrv20080
root=/dev/mapper/news1-root ro
|KERNEL supported cpus:
|  Intel GenuineIntel
|  AMD AuthenticAMD
|  Centaur CentaurHauls
|e820: BIOS-provided physical RAM map:
|BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
|BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
|BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
|BIOS-e820: [mem 0x0000000000100000-0x000000007fbfffff] usable
|BIOS-e820: [mem 0x00000000fc000000-0x00000000ffffffff] reserved
|Notice: NX (Execute Disable) protection missing in CPU!
|SMBIOS 2.4 present.
|DMI: Xen HVM domU, BIOS 4.1.5 06/14/2013
|Hypervisor detected: Xen HVM
|Xen version 4.1.
|Xen Platform PCI: I/O protocol version 1
|Netfront and the Xen platform PCI driver have been compiled for this
kernel: unplug emulated NICs.
|Blkfront and the Xen platform PCI driver have been compiled for this
kernel: unplug emulated disks.
|You might have to change the root device
|from /dev/hd[a-d] to /dev/xvd[a-d]
|in your root= kernel command line option
|HVMOP_pagetable_dying not supported
|e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
|e820: remove [mem 0x000a0000-0x000fffff] usable

Here a config diff between the working Linux 3.12.6 and the
non-working Linux 3.14.

|[2/502]mh@impetus:~$ diff -u /boot/config-3.1* | grep '^[+-]'
|--- /boot/config-3.12.6-zgsrv20080      2013-12-21 19:48:28.000000000 +0100
|+++ /boot/config-3.14.0-zgsrv20080      2014-04-01 22:00:47.000000000 +0200
|-# Linux/x86_64 3.12.6 Kernel Configuration
|+# Linux/x86_64 3.14.0 Kernel Configuration
|-CONFIG_ARCH_CPU_PROBE_RELEASE=y
|-# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
|+CONFIG_ARCH_SUPPORTS_INT128=y
|-CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
|-CONFIG_USE_GENERIC_SMP_HELPERS=y
|+CONFIG_HAVE_CC_STACKPROTECTOR=y
|+CONFIG_CC_STACKPROTECTOR=y
|+# CONFIG_CC_STACKPROTECTOR_NONE is not set
|+CONFIG_CC_STACKPROTECTOR_REGULAR=y
|+# CONFIG_CC_STACKPROTECTOR_STRONG is not set
|+CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
|+CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
|+CONFIG_SYSTEM_TRUSTED_KEYRING=y
|-# CONFIG_BLK_DEV_INTEGRITY is not set
|+CONFIG_BLK_DEV_INTEGRITY=y
|+CONFIG_XEN_PVH=y
|-CONFIG_MICROCODE_INTEL_LIB=y
|+CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
|+CONFIG_NEED_BOUNCE_POOL=y
|+# CONFIG_ZSMALLOC is not set
|-# CONFIG_CC_STACKPROTECTOR is not set
|+CONFIG_RANDOMIZE_BASE=y
|+CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
|+CONFIG_X86_NEED_RELOCS=y
|-# CONFIG_ACPI_PROCFS_POWER is not set
|-CONFIG_ACPI_BLACKLIST_YEAR=0
|+CONFIG_ACPI_EXTLOG=m
|-CONFIG_CPU_FREQ_TABLE=y
|-CONFIG_IPV6_PRIVACY=y
|+CONFIG_IPV6_VTI=m
|+CONFIG_NF_TABLES=m
|+CONFIG_NF_TABLES_INET=m
|+CONFIG_NFT_EXTHDR=m
|+CONFIG_NFT_META=m
|+CONFIG_NFT_CT=m
|+CONFIG_NFT_RBTREE=m
|+CONFIG_NFT_HASH=m
|+CONFIG_NFT_COUNTER=m
|+CONFIG_NFT_LOG=m
|+CONFIG_NFT_LIMIT=m
|+CONFIG_NFT_NAT=m
|+CONFIG_NFT_QUEUE=m
|+CONFIG_NFT_REJECT=m
|+CONFIG_NFT_REJECT_INET=m
|+CONFIG_NFT_COMPAT=m
|+CONFIG_NETFILTER_XT_MATCH_CGROUP=m
|+CONFIG_NETFILTER_XT_MATCH_IPCOMP=m
|+CONFIG_NETFILTER_XT_MATCH_L2TP=m
|+CONFIG_IP_SET_HASH_NETPORTNET=m
|+CONFIG_IP_SET_HASH_NETNET=m
|+CONFIG_NF_TABLES_IPV4=m
|+CONFIG_NFT_CHAIN_ROUTE_IPV4=m
|+CONFIG_NFT_CHAIN_NAT_IPV4=m
|+CONFIG_NFT_REJECT_IPV4=m
|+CONFIG_NF_TABLES_ARP=m
|+CONFIG_NF_TABLES_IPV6=m
|+CONFIG_NFT_CHAIN_ROUTE_IPV6=m
|+CONFIG_NFT_CHAIN_NAT_IPV6=m
|+CONFIG_NFT_REJECT_IPV6=m
|+CONFIG_NF_TABLES_BRIDGE=m
|+CONFIG_NET_SCH_HHF=m
|+CONFIG_NET_SCH_PIE=m
|+CONFIG_NET_CLS_BPF=m
|+# CONFIG_HSR is not set
|-CONFIG_NETPRIO_CGROUP=m
|+CONFIG_CGROUP_NET_PRIO=m
|+CONFIG_CGROUP_NET_CLASSID=y
|+CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
|+# CONFIG_BLK_DEV_NULL_BLK is not set
|-# CONFIG_BLK_CPQ_DA is not set
|+# CONFIG_BLK_DEV_SKD is not set
|+CONFIG_INTEL_MIC_HOST=m
|+CONFIG_INTEL_MIC_CARD=m
|+# CONFIG_GENWQE is not set
|-# CONFIG_SCSI_AIC7XXX_OLD is not set
|+CONFIG_BLK_DEV_DM_BUILTIN=y
|+# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
|-# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
|-CONFIG_DM_RAID=m
|+CONFIG_DM_RAID=m
|+CONFIG_VHOST_RING=m
|+# CONFIG_I40EVF is not set
|+CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
|-# CONFIG_SERIAL_ST_ASC is not set
|+CONFIG_HPET_MMAP_DEFAULT=y
|+# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
|-CONFIG_GPIO_DEVRES=y
|-# CONFIG_CPU_THERMAL is not set
|+CONFIG_ACPI_INT3403_THERMAL=m
|+# CONFIG_MFD_LP3943 is not set
|+CONFIG_INTEL_GTT=y
|+# CONFIG_FB_OPENCORES is not set
|+# CONFIG_USB_MUSB_HDRC is not set
|+# CONFIG_USB_DWC2 is not set
|+# CONFIG_USB_SERIAL_MXUPORT is not set
|+# CONFIG_USB_OTG_FSM is not set
|-# CONFIG_AM335X_PHY_USB is not set
|+# CONFIG_RTC_DRV_ISL12057 is not set
|-# CONFIG_CHROMEOS_LAPTOP is not set
|+# CONFIG_HP_WIRELESS is not set
|+# CONFIG_CHROME_PLATFORMS is not set
|-# CONFIG_COMMON_CLK_DEBUG is not set
|+# CONFIG_MCP3422 is not set
|-# CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS is not set
|+# CONFIG_CM32181 is not set
|+# CONFIG_CM36651 is not set
|+# CONFIG_GP2AP020A00F is not set
|+# CONFIG_TCS3472 is not set
|+# CONFIG_TSL4531 is not set
|+# CONFIG_MAG3110 is not set
|+# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
|+# CONFIG_MPL3115 is not set
|+CONFIG_GENERIC_PHY=y
|+# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
|+# CONFIG_BCM_KONA_USB2_PHY is not set
|+CONFIG_POWERCAP=y
|+CONFIG_INTEL_RAPL=m
|+CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
|+CONFIG_UEFI_CPER=y
|-CONFIG_GENERIC_ACL=y
|+CONFIG_SQUASHFS_FILE_CACHE=y
|+# CONFIG_SQUASHFS_FILE_DIRECT is not set
|+CONFIG_SQUASHFS_DECOMP_SINGLE=y
|+# CONFIG_SQUASHFS_DECOMP_MULTI is not set
|+# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
|+CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
|+CONFIG_PANIC_TIMEOUT=0
|+# CONFIG_PERCPU_TEST is not set
|+# CONFIG_TEST_MODULE is not set
|+# CONFIG_TEST_USER_COPY is not set
|+CONFIG_PERSISTENT_KEYRINGS=y
|+# CONFIG_BIG_KEYS is not set
|-CONFIG_CRYPTO_ABLK_HELPER_X86=m
|+CONFIG_CRYPTO_ABLK_HELPER=m
|+CONFIG_CRYPTO_HASH_INFO=y
|+CONFIG_CRYPTO_DEV_CCP=y
|+CONFIG_CRYPTO_DEV_CCP_DD=m
|+CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
|+CONFIG_KVM_VFIO=y
|-CONFIG_CMPXCHG_LOCKREF=y
|+CONFIG_RANDOM32_SELFTEST=y
|+CONFIG_ASSOCIATIVE_ARRAY=y

Any ideas?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 31958061
Nordisch by Nature |  How to make an American Quilt | Fax: *49 621 31958062
