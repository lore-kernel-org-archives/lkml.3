Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3EPNu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:50:27 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:43331 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3EPNuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <201305160054.21064.arnd@arndb.de>
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com>
	<201305151516.52389.arnd@arndb.de>
	<20130515133237.GK18614@n2100.arm.linux.org.uk>
	<201305160054.21064.arnd@arndb.de>
Date: Thu, 16 May 2013 15:50:22 +0200
Message-ID: <CACmBeS2B7TCeqF2rRRVqPw94SpJHQmmbV33SaMO_R_=5Y1DrjQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2013 00:54, Arnd Bergmann <arnd@arndb.de> wrote:
> Ah, I see. I also read the mach-gemini version of the idle code,
> which is apparently the same thing as the code that was commented
> out here, so that has the wakeup race.

The empty moxart_idle is the only way I get a successful boot to init.
It stalls half way using code from gemini or if left out (arm_pm_idle
not set).

"INFO: rcu_preempt detected stalls on CPUs/tasks" is printed in a loop
with the code from gemini though.

logs:

default idle (arm_pm_idle not set):

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.10.0-rc1-next-20130515+ (i@Ildjarn)
(gcc version 4.6.3 (crosstool-NG 1.16.0) ) #130 PREEMPT Thu May 16
09:25:22 CEST 2013
[    0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: MOXA UC-7112-LX, model: MOXA UC-7112-LX
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 8192
[    0.000000] free_area_init_node: node 0, pgdat c02d58c4,
node_mem_map c07f8000
[    0.000000]   Normal zone: 64 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 8192 pages, LIFO batch:0
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 8128
[    0.000000] Kernel command line: initcall_debug debug loglevel=9
console=ttyS0,115200n8 root=/dev/mmcblk0p1 rw rootwait
[    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
[    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Memory: 32MB = 32MB total
[    0.000000] Memory: 24284k/24284k available, 8484k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
[    0.000000]       .text : 0xc0008000 - 0xc02a19bc   (2663 kB)
[    0.000000]       .init : 0xc02a2000 - 0xc02b8638   (  90 kB)
[    0.000000]       .data : 0xc02ba000 - 0xc02d60c0   ( 113 kB)
[    0.000000]        .bss : 0xc02d60c0 - 0xc07f5f14   (5248 kB)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:32 32
[    0.000000] /soc/interrupt-controller@98800000: moxart_of_init finished
[    0.000000] /soc/timer@98400000: count/load (APB_CLK=48000000/HZ=100) IRQ=19
[    0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns,
wraps every 4294967286ms
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
[    0.010000] Calibrating delay loop... 144.79 BogoMIPS (lpj=723968)
[    0.080000] pid_max: default: 4096 minimum: 301
[    0.080000] Mount-cache hash table entries: 512
[    0.110000] CPU: Testing write buffer coherency: ok
[    0.110000] calling  init_static_idmap+0x0/0xd4 @ 1
[    0.120000] Setting up static identity map for 0xc0219820 - 0xc0219868
[    0.120000] initcall init_static_idmap+0x0/0xd4 returned 0 after 0 usecs
[    0.120000] calling  spawn_ksoftirqd+0x0/0x1c @ 1
[    0.120000] initcall spawn_ksoftirqd+0x0/0x1c returned 0 after 0 usecs
[    0.120000] calling  init_workqueues+0x0/0x2c0 @ 1
[    0.130000] initcall init_workqueues+0x0/0x2c0 returned 0 after 9765 usecs
[    0.130000] calling  check_cpu_stall_init+0x0/0x20 @ 1
[    0.130000] initcall check_cpu_stall_init+0x0/0x20 returned 0 after 0 usecs
[    0.130000] calling  rcu_scheduler_really_started+0x0/0x18 @ 1
[    0.130000] initcall rcu_scheduler_really_started+0x0/0x18 returned
0 after 0 usecs
[    0.130000] calling  rcu_spawn_gp_kthread+0x0/0x7c @ 1
[    0.140000] initcall rcu_spawn_gp_kthread+0x0/0x7c returned 0 after
9765 usecs
[    0.150000] devtmpfs: initialized
[    0.160000] calling  ipc_ns_init+0x0/0x18 @ 1
[    0.160000] initcall ipc_ns_init+0x0/0x18 returned 0 after 0 usecs
[    0.160000] calling  init_mmap_min_addr+0x0/0x20 @ 1
[    0.160000] initcall init_mmap_min_addr+0x0/0x20 returned 0 after 0 usecs
[    0.160000] calling  net_ns_init+0x0/0x1d4 @ 1
[    0.160000] initcall net_ns_init+0x0/0x1d4 returned 0 after 0 usecs
[    0.160000] calling  ptrace_break_init+0x0/0x2c @ 1
[    0.160000] initcall ptrace_break_init+0x0/0x2c returned 0 after 0 usecs
[    0.160000] calling  wq_sysfs_init+0x0/0x10 @ 1
[    0.170000] initcall wq_sysfs_init+0x0/0x10 returned 0 after 9765 usecs
[    0.170000] calling  ksysfs_init+0x0/0x98 @ 1
[    0.170000] initcall ksysfs_init+0x0/0x98 returned 0 after 0 usecs
[    0.170000] calling  init_jiffies_clocksource+0x0/0xc @ 1
[    0.170000] initcall init_jiffies_clocksource+0x0/0xc returned 0
after 0 usecs
[    0.170000] calling  init_zero_pfn+0x0/0x44 @ 1
[    0.180000] initcall init_zero_pfn+0x0/0x44 returned 0 after 0 usecs
[    0.180000] calling  fsnotify_init+0x0/0x34 @ 1
[    0.180000] initcall fsnotify_init+0x0/0x34 returned 0 after 0 usecs
[    0.180000] calling  filelock_init+0x0/0x40 @ 1
[    0.180000] initcall filelock_init+0x0/0x40 returned 0 after 0 usecs
[    0.180000] calling  init_script_binfmt+0x0/0x1c @ 1
[    0.180000] initcall init_script_binfmt+0x0/0x1c returned 0 after 0 usecs
[    0.180000] calling  init_elf_binfmt+0x0/0x1c @ 1
[    0.180000] initcall init_elf_binfmt+0x0/0x1c returned 0 after 0 usecs
[    0.180000] calling  prandom_init+0x0/0x88 @ 1
[    0.180000] initcall prandom_init+0x0/0x88 returned 0 after 0 usecs
[    0.180000] calling  sock_init+0x0/0x90 @ 1
[    0.180000] initcall sock_init+0x0/0x90 returned 0 after 0 usecs
[    0.180000] calling  netlink_proto_init+0x0/0x22c @ 1
[    0.190000] NET: Registered protocol family 16
[    0.190000] initcall netlink_proto_init+0x0/0x22c returned 0 after 9765 usecs
[    0.190000] calling  atomic_pool_init+0x0/0x124 @ 1
[    0.200000] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.200000] initcall atomic_pool_init+0x0/0x124 returned 0 after 9765 usecs
[    0.200000] calling  bdi_class_init+0x0/0x44 @ 1
[    0.200000] initcall bdi_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.200000] calling  kobject_uevent_init+0x0/0xc @ 1
[    0.200000] initcall kobject_uevent_init+0x0/0xc returned 0 after 0 usecs
[    0.200000] calling  moxart_gpio_init+0x0/0xc @ 1
[    0.210000] initcall moxart_gpio_init+0x0/0xc returned 0 after 9765 usecs
[    0.210000] calling  tty_class_init+0x0/0x44 @ 1
[    0.210000] initcall tty_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.210000] calling  gate_vma_init+0x0/0x24 @ 1
[    0.210000] initcall gate_vma_init+0x0/0x24 returned 0 after 0 usecs
[    0.210000] calling  customize_machine+0x0/0x44 @ 1
[    0.240000] moxart-gpio 98700000.gpio: finished moxart_gpio_probe
gpio_base=c284a000 pmu_base=c284c000
[    0.290000] initcall customize_machine+0x0/0x44 returned 0 after 78125 usecs
[    0.290000] calling  exceptions_init+0x0/0x90 @ 1
[    0.290000] initcall exceptions_init+0x0/0x90 returned 0 after 0 usecs
[    0.290000] calling  dma_bus_init+0x0/0x14 @ 1
[    0.290000] initcall dma_bus_init+0x0/0x14 returned 0 after 0 usecs
[    0.290000] calling  dma_channel_table_init+0x0/0x11c @ 1
[    0.290000] initcall dma_channel_table_init+0x0/0x11c returned 0
after 0 usecs
[    0.290000] calling  topology_init+0x0/0x28 @ 1
[    0.300000] initcall topology_init+0x0/0x28 returned 0 after 9765 usecs
[    0.300000] calling  param_sysfs_init+0x0/0x2d0 @ 1
[    0.480000] initcall param_sysfs_init+0x0/0x2d0 returned 0 after 175781 usecs
[    0.480000] calling  pm_sysrq_init+0x0/0x1c @ 1
[    0.480000] initcall pm_sysrq_init+0x0/0x1c returned 0 after 0 usecs
[    0.480000] calling  default_bdi_init+0x0/0x7c @ 1
[    0.490000] initcall default_bdi_init+0x0/0x7c returned 0 after 9765 usecs
[    0.490000] calling  init_bio+0x0/0xfc @ 1
[    0.490000] bio: create slab <bio-0> at 0
[    0.490000] initcall init_bio+0x0/0xfc returned 0 after 0 usecs
[    0.490000] calling  fsnotify_notification_init+0x0/0x98 @ 1
[    0.500000] initcall fsnotify_notification_init+0x0/0x98 returned 0
after 0 usecs
[    0.500000] calling  blk_settings_init+0x0/0x34 @ 1
[    0.500000] initcall blk_settings_init+0x0/0x34 returned 0 after 0 usecs
[    0.500000] calling  blk_ioc_init+0x0/0x40 @ 1
[    0.500000] initcall blk_ioc_init+0x0/0x40 returned 0 after 0 usecs
[    0.500000] calling  blk_softirq_init+0x0/0x2c @ 1
[    0.500000] initcall blk_softirq_init+0x0/0x2c returned 0 after 0 usecs
[    0.500000] calling  blk_iopoll_setup+0x0/0x2c @ 1
[    0.500000] initcall blk_iopoll_setup+0x0/0x2c returned 0 after 0 usecs
[    0.500000] calling  genhd_device_init+0x0/0x80 @ 1
[    0.500000] initcall genhd_device_init+0x0/0x80 returned 0 after 0 usecs
[    0.500000] calling  moxart_init+0x0/0xc @ 1
[    0.530000] moxart-dma-engine 90500000.dma: finished moxart_probe IRQ=24
[    0.530000] initcall moxart_init+0x0/0xc returned 0 after 19531 usecs
[    0.530000] calling  misc_init+0x0/0xc0 @ 1
[    0.540000] initcall misc_init+0x0/0xc0 returned 0 after 9765 usecs
[    0.540000] calling  rtc_init+0x0/0x60 @ 1
[    0.540000] initcall rtc_init+0x0/0x60 returned 0 after 0 usecs
[    0.540000] calling  mmc_init+0x0/0x84 @ 1
[    0.550000] initcall mmc_init+0x0/0x84 returned 0 after 9765 usecs
[    0.550000] calling  proto_init+0x0/0xc @ 1
[    0.550000] initcall proto_init+0x0/0xc returned 0 after 0 usecs
[    0.550000] calling  net_dev_init+0x0/0x180 @ 1
[    0.580000] initcall net_dev_init+0x0/0x180 returned 0 after 29296 usecs
[    0.580000] calling  neigh_init+0x0/0xa4 @ 1
[    0.580000] initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
[    0.580000] calling  genl_init+0x0/0x80 @ 1
[    0.580000] initcall genl_init+0x0/0x80 returned 0 after 0 usecs
[    0.580000] calling  proc_cpu_init+0x0/0x24 @ 1
[    0.580000] initcall proc_cpu_init+0x0/0x24 returned 0 after 0 usecs
[    0.580000] calling  dma_debug_do_init+0x0/0x8 @ 1
[    0.580000] initcall dma_debug_do_init+0x0/0x8 returned 0 after 0 usecs
[    0.580000] calling  alignment_init+0x0/0xf4 @ 1
[    0.580000] initcall alignment_init+0x0/0xf4 returned 0 after 0 usecs
[    0.580000] calling  clocksource_done_booting+0x0/0x58 @ 1
[    0.580000] initcall clocksource_done_booting+0x0/0x58 returned 0
after 0 usecs
[    0.580000] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.580000] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
[    0.580000] calling  eventpoll_init+0x0/0xac @ 1
[    0.590000] initcall eventpoll_init+0x0/0xac returned 0 after 9765 usecs
[    0.590000] calling  anon_inode_init+0x0/0x64 @ 1
[    0.590000] initcall anon_inode_init+0x0/0x64 returned 0 after 0 usecs
[    0.590000] calling  blk_scsi_ioctl_init+0x0/0xdc @ 1
[    0.590000] initcall blk_scsi_ioctl_init+0x0/0xdc returned 0 after 0 usecs
[    0.590000] calling  chr_dev_init+0x0/0xd4 @ 1
[    0.640000] initcall chr_dev_init+0x0/0xd4 returned 0 after 48828 usecs
[    0.640000] calling  sysctl_core_init+0x0/0x30 @ 1
[    0.640000] initcall sysctl_core_init+0x0/0x30 returned 0 after 0 usecs
[    0.640000] calling  inet_init+0x0/0x250 @ 1
[    0.650000] NET: Registered protocol family 2
[    0.660000] TCP established hash table entries: 512 (order: 0, 4096 bytes)
[    0.660000] TCP bind hash table entries: 512 (order: 2, 18432 bytes)
[    0.660000] TCP: Hash tables configured (established 512 bind 512)
[    0.660000] TCP: reno registered
[    0.660000] UDP hash table entries: 128 (order: 1, 10240 bytes)
[    0.660000] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
[    0.680000] initcall inet_init+0x0/0x250 returned 0 after 39062 usecs
[    0.680000] calling  ipv4_offload_init+0x0/0x64 @ 1
[    0.680000] initcall ipv4_offload_init+0x0/0x64 returned 0 after 0 usecs
[    0.680000] calling  af_unix_init+0x0/0x54 @ 1
[    0.680000] NET: Registered protocol family 1
[    0.680000] initcall af_unix_init+0x0/0x54 returned 0 after 0 usecs
[    0.680000] calling  ipv6_offload_init+0x0/0x64 @ 1
[    0.680000] initcall ipv6_offload_init+0x0/0x64 returned 0 after 0 usecs
[    0.680000] calling  default_rootfs+0x0/0x70 @ 1
[    0.680000] initcall default_rootfs+0x0/0x70 returned 0 after 0 usecs
[    0.680000] calling  sched_clock_syscore_init+0x0/0x18 @ 1
[    0.680000] initcall sched_clock_syscore_init+0x0/0x18 returned 0
after 0 usecs
[    0.680000] calling  proc_execdomains_init+0x0/0x38 @ 1
[    0.680000] initcall proc_execdomains_init+0x0/0x38 returned 0 after 0 usecs
[    0.680000] calling  ioresources_init+0x0/0x58 @ 1
[    0.680000] initcall ioresources_init+0x0/0x58 returned 0 after 0 usecs
[    0.680000] calling  uid_cache_init+0x0/0x98 @ 1
[    0.680000] initcall uid_cache_init+0x0/0x98 returned 0 after 0 usecs
[    0.680000] calling  init_posix_timers+0x0/0x208 @ 1
[    0.680000] initcall init_posix_timers+0x0/0x208 returned 0 after 0 usecs
[    0.680000] calling  init_posix_cpu_timers+0x0/0xe4 @ 1
[    0.680000] initcall init_posix_cpu_timers+0x0/0xe4 returned 0 after 0 usecs
[    0.680000] calling  timekeeping_init_ops+0x0/0x18 @ 1
[    0.680000] initcall timekeeping_init_ops+0x0/0x18 returned 0 after 0 usecs
[    0.680000] calling  init_clocksource_sysfs+0x0/0x54 @ 1
[    0.690000] initcall init_clocksource_sysfs+0x0/0x54 returned 0
after 9765 usecs
[    0.690000] calling  init_timer_list_procfs+0x0/0x40 @ 1
[    0.690000] initcall init_timer_list_procfs+0x0/0x40 returned 0 after 0 usecs
[    0.690000] calling  alarmtimer_init+0x0/0x1a4 @ 1
[    0.700000] initcall alarmtimer_init+0x0/0x1a4 returned 0 after 9765 usecs
[    0.700000] calling  lockdep_proc_init+0x0/0x74 @ 1
[    0.700000] initcall lockdep_proc_init+0x0/0x74 returned 0 after 0 usecs
[    0.700000] calling  futex_init+0x0/0x84 @ 1
[    0.700000] initcall futex_init+0x0/0x84 returned 0 after 0 usecs
[    0.700000] calling  kallsyms_init+0x0/0x38 @ 1
[    0.700000] initcall kallsyms_init+0x0/0x38 returned 0 after 0 usecs
[    0.700000] calling  ikconfig_init+0x0/0x58 @ 1
[    0.700000] initcall ikconfig_init+0x0/0x58 returned 0 after 0 usecs
[    0.700000] calling  hung_task_init+0x0/0x54 @ 1
[    0.700000] initcall hung_task_init+0x0/0x54 returned 0 after 0 usecs
[    0.710000] calling  utsname_sysctl_init+0x0/0x18 @ 1
[    0.710000] initcall utsname_sysctl_init+0x0/0x18 returned 0 after 0 usecs
[    0.710000] calling  init_per_zone_wmark_min+0x0/0x88 @ 1
[    0.710000] initcall init_per_zone_wmark_min+0x0/0x88 returned 0
after 0 usecs
[    0.710000] calling  kswapd_init+0x0/0x18 @ 1
[    0.710000] initcall kswapd_init+0x0/0x18 returned 0 after 0 usecs
[    0.710000] calling  setup_vmstat+0x0/0x90 @ 1
[    0.710000] initcall setup_vmstat+0x0/0x90 returned 0 after 0 usecs
[    0.710000] calling  mm_sysfs_init+0x0/0x38 @ 1
[    0.710000] initcall mm_sysfs_init+0x0/0x38 returned 0 after 0 usecs
[    0.710000] calling  init_reserve_notifier+0x0/0x8 @ 1
[    0.710000] initcall init_reserve_notifier+0x0/0x8 returned 0 after 0 usecs
[    0.710000] calling  init_admin_reserve+0x0/0x30 @ 1
[    0.710000] initcall init_admin_reserve+0x0/0x30 returned 0 after 0 usecs
[    0.710000] calling  init_user_reserve+0x0/0x30 @ 1
[    0.710000] initcall init_user_reserve+0x0/0x30 returned 0 after 0 usecs
[    0.710000] calling  proc_vmalloc_init+0x0/0x38 @ 1
[    0.710000] initcall proc_vmalloc_init+0x0/0x38 returned 0 after 0 usecs
[    0.710000] calling  slab_sysfs_init+0x0/0x108 @ 1
[    0.940000] initcall slab_sysfs_init+0x0/0x108 returned 0 after 224609 usecs
[    0.940000] calling  fcntl_init+0x0/0x40 @ 1
[    0.950000] initcall fcntl_init+0x0/0x40 returned 0 after 9765 usecs
[    0.950000] calling  proc_filesystems_init+0x0/0x38 @ 1
[    0.950000] initcall proc_filesystems_init+0x0/0x38 returned 0 after 0 usecs
[    0.950000] calling  dio_init+0x0/0x40 @ 1
[    0.960000] initcall dio_init+0x0/0x40 returned 0 after 9765 usecs
[    0.960000] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    0.960000] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 0 usecs
[    0.960000] calling  dnotify_init+0x0/0x80 @ 1
[    0.960000] initcall dnotify_init+0x0/0x80 returned 0 after 0 usecs
[    0.960000] calling  inotify_user_setup+0x0/0x78 @ 1
[    0.960000] initcall inotify_user_setup+0x0/0x78 returned 0 after 0 usecs
[    0.960000] calling  proc_locks_init+0x0/0x38 @ 1
[    0.960000] initcall proc_locks_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  init_mbcache+0x0/0x18 @ 1
[    0.960000] initcall init_mbcache+0x0/0x18 returned 0 after 0 usecs
[    0.960000] calling  proc_cmdline_init+0x0/0x38 @ 1
[    0.960000] initcall proc_cmdline_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_consoles_init+0x0/0x38 @ 1
[    0.960000] initcall proc_consoles_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_cpuinfo_init+0x0/0x38 @ 1
[    0.960000] initcall proc_cpuinfo_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_devices_init+0x0/0x38 @ 1
[    0.960000] initcall proc_devices_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_interrupts_init+0x0/0x38 @ 1
[    0.960000] initcall proc_interrupts_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_loadavg_init+0x0/0x38 @ 1
[    0.960000] initcall proc_loadavg_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_meminfo_init+0x0/0x38 @ 1
[    0.960000] initcall proc_meminfo_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_stat_init+0x0/0x38 @ 1
[    0.960000] initcall proc_stat_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_uptime_init+0x0/0x38 @ 1
[    0.960000] initcall proc_uptime_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_version_init+0x0/0x38 @ 1
[    0.960000] initcall proc_version_init+0x0/0x38 returned 0 after 0 usecs
[    0.970000] calling  proc_softirqs_init+0x0/0x38 @ 1
[    0.970000] initcall proc_softirqs_init+0x0/0x38 returned 0 after 0 usecs
[    0.970000] calling  proc_kmsg_init+0x0/0x38 @ 1
[    0.970000] initcall proc_kmsg_init+0x0/0x38 returned 0 after 0 usecs
[    0.970000] calling  proc_page_init+0x0/0x58 @ 1
[    0.970000] initcall proc_page_init+0x0/0x58 returned 0 after 0 usecs
[    0.970000] calling  init_devpts_fs+0x0/0x68 @ 1
[    0.970000] initcall init_devpts_fs+0x0/0x68 returned 0 after 0 usecs
[    0.970000] calling  init_ext3_fs+0x0/0x8c @ 1
[    0.980000] initcall init_ext3_fs+0x0/0x8c returned 0 after 9765 usecs
[    0.980000] calling  journal_init+0x0/0xb4 @ 1
[    1.000000] initcall journal_init+0x0/0xb4 returned 0 after 19531 usecs
[    1.000000] calling  init_ramfs_fs+0x0/0xc @ 1
[    1.000000] initcall init_ramfs_fs+0x0/0xc returned 0 after 0 usecs
[    1.000000] calling  init_jffs2_fs+0x0/0xd8 @ 1
[    1.000000] jffs2: version 2.2. (NAND) Â© 2001-2006 Red Hat, Inc.
[    1.010000] initcall init_jffs2_fs+0x0/0xd8 returned 0 after 9765 usecs
[    1.010000] calling  ipc_init+0x0/0x24 @ 1
[    1.010000] msgmni has been set to 47
[    1.010000] initcall ipc_init+0x0/0x24 returned 0 after 0 usecs
[    1.010000] calling  ipc_sysctl_init+0x0/0x18 @ 1
[    1.010000] initcall ipc_sysctl_init+0x0/0x18 returned 0 after 0 usecs
[    1.010000] calling  key_proc_init+0x0/0x48 @ 1
[    1.010000] initcall key_proc_init+0x0/0x48 returned 0 after 0 usecs
[    1.010000] calling  crypto_algapi_init+0x0/0x10 @ 1
[    1.010000] initcall crypto_algapi_init+0x0/0x10 returned 0 after 0 usecs
[    1.010000] calling  aes_init+0x0/0xc @ 1
[    1.020000] initcall aes_init+0x0/0xc returned 0 after 9765 usecs
[    1.020000] calling  krng_mod_init+0x0/0xc @ 1
[    1.020000] initcall krng_mod_init+0x0/0xc returned 0 after 0 usecs
[    1.020000] calling  prng_mod_init+0x0/0x10 @ 1
[    1.020000] initcall prng_mod_init+0x0/0x10 returned 0 after 0 usecs
[    1.020000] calling  proc_genhd_init+0x0/0x58 @ 1
[    1.020000] initcall proc_genhd_init+0x0/0x58 returned 0 after 0 usecs
[    1.020000] calling  noop_init+0x0/0xc @ 1
[    1.020000] io scheduler noop registered
[    1.020000] initcall noop_init+0x0/0xc returned 0 after 0 usecs
[    1.020000] calling  cfq_init+0x0/0x94 @ 1
[    1.020000] io scheduler cfq registered (default)
[    1.020000] initcall cfq_init+0x0/0x94 returned 0 after 0 usecs
[    1.020000] calling  pty_init+0x0/0x230 @ 1
[    1.020000] initcall pty_init+0x0/0x230 returned 0 after 0 usecs
[    1.030000] calling  sysrq_init+0x0/0x48 @ 1
[    1.030000] initcall sysrq_init+0x0/0x48 returned 0 after 0 usecs
[    1.030000] calling  serial8250_init+0x0/0x158 @ 1
[    1.030000] Serial: 8250/16550 driver, 1 ports, IRQ sharing enabled
[    1.040000] initcall serial8250_init+0x0/0x158 returned 0 after 9765 usecs
[    1.040000] calling  of_platform_serial_driver_init+0x0/0xc @ 1
[    1.070000] 98200000.uart: ttyS0 at MMIO 0x98200000 (irq = 31) is a 16550A
[    2.960000] console [ttyS0] enabled
[    2.970000] initcall of_platform_serial_driver_init+0x0/0xc
returned 0 after 1884765 usecs
[    2.980000] calling  mxser_module_init+0x0/0x49c @ 1
[    2.990000] MOXA Smartio/Industio family driver version 2.0.5
[    3.000000] mxser: found MOXA UC-7112-LX board (CAP=0x0)
[    3.000000] mxser: mxser_initbrd success IRQ=31 max baud=921600 bps
[    3.020000] initcall mxser_module_init+0x0/0x49c returned 0 after 29296 usecs
[    3.030000] calling  rand_initialize+0x0/0x2c @ 1
[    3.030000] initcall rand_initialize+0x0/0x2c returned 0 after 0 usecs
[    3.040000] calling  topology_sysfs_init+0x0/0x20 @ 1
[    3.050000] initcall topology_sysfs_init+0x0/0x20 returned 0 after 0 usecs
[    3.060000] calling  init_mtd+0x0/0xf8 @ 1
[    3.070000] initcall init_mtd+0x0/0xf8 returned 0 after 9765 usecs
[    3.080000] calling  ofpart_parser_init+0x0/0x38 @ 1
[    3.090000] initcall ofpart_parser_init+0x0/0x38 returned 0 after 0 usecs
[    3.100000] calling  init_mtdblock+0x0/0xc @ 1
[    3.100000] initcall init_mtdblock+0x0/0xc returned 0 after 0 usecs
[    3.110000] calling  cfi_probe_init+0x0/0x18 @ 1
[    3.120000] initcall cfi_probe_init+0x0/0x18 returned 0 after 0 usecs
[    3.120000] calling  physmap_init+0x0/0xc @ 1
[    3.130000] initcall physmap_init+0x0/0xc returned 0 after 0 usecs
[    3.140000] calling  of_flash_driver_init+0x0/0xc @ 1
[    3.170000] 80000000.flash: Found 1 x16 devices at 0x0 in 16-bit
bank. Manufacturer ID 0x000089 Chip ID 0x000018
[    3.180000] Intel/Sharp Extended Query Table at 0x0031
[    3.190000] Intel/Sharp Extended Query Table at 0x0031
[    3.190000] Using buffer write method
[    3.200000] cfi_cmdset_0001: Erase suspend on write enabled
[    3.200000] erase region 0: offset=0x0,size=0x20000,blocks=128
[    3.210000] 4 ofpart partitions found on MTD device 80000000.flash
[    3.220000] Creating 4 MTD partitions on "80000000.flash":
[    3.220000] 0x000000000000-0x000000040000 : "bootloader"
[    3.260000] 0x000000040000-0x000000200000 : "linux kernel"
[    3.300000] 0x000000200000-0x000000a00000 : "root filesystem"
[    3.330000] 0x000000a00000-0x000001000000 : "user filesystem"
[    3.370000] initcall of_flash_driver_init+0x0/0xc returned 0 after
224609 usecs
[    3.370000] calling  net_olddevs_init+0x0/0x68 @ 1
[    3.380000] initcall net_olddevs_init+0x0/0x68 returned 0 after 0 usecs
[    3.390000] calling  moxart_mac_init+0x0/0xc @ 1
[    3.440000] moxart-ethernet 90900000.mac eth0: moxart_mac_probe:
IRQ=25 address=00:90:e8:1b:e2:a5
[    3.500000] moxart-ethernet 92000000.mac eth1: moxart_mac_probe:
IRQ=27 address=00:90:e8:1b:e2:a6
[    3.520000] initcall moxart_mac_init+0x0/0xc returned 0 after 126953 usecs
[    3.520000] calling  moxart_rtc_init+0x0/0xc @ 1
[    3.540000] moxart-rtc rtc.0: rtc core: registered rtc.0 as rtc0
[    3.550000] moxart-rtc rtc.0: finished moxart_rtc_probe
[    3.560000] initcall moxart_rtc_init+0x0/0xc returned 0 after 29296 usecs
[    3.570000] calling  moxart_wdt_init+0x0/0xc @ 1
[    3.580000] moxart-watchdog 98500000.watchdog: finished
moxart_wdt_probe base=c2920000
[    3.600000] initcall moxart_wdt_init+0x0/0xc returned 0 after 29296 usecs
[    3.600000] calling  mmc_blk_init+0x0/0x74 @ 1
[    3.610000] initcall mmc_blk_init+0x0/0x74 returned 0 after 0 usecs
[    3.620000] calling  moxart_init+0x0/0xc @ 1


gemini idle:

Uncompressing Linux... done, booting the kernel.
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.10.0-rc1-next-20130515+ (i@Ildjarn)
(gcc version 4.6.3 (crosstool-NG 1.16.0) ) #129 PREEMPT Thu May 16
09:20:50 CEST 2013
[    0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
[    0.000000] CPU: VIVT data cache, VIVT instruction cache
[    0.000000] Machine: MOXA UC-7112-LX, model: MOXA UC-7112-LX
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 8192
[    0.000000] free_area_init_node: node 0, pgdat c02d58c4,
node_mem_map c07f8000
[    0.000000]   Normal zone: 64 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 8192 pages, LIFO batch:0
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 8128
[    0.000000] Kernel command line: initcall_debug debug loglevel=9
console=ttyS0,115200n8 root=/dev/mmcblk0p1 rw rootwait
[    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
[    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Memory: 32MB = 32MB total
[    0.000000] Memory: 24284k/24284k available, 8484k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
[    0.000000]       .text : 0xc0008000 - 0xc02a19d0   (2663 kB)
[    0.000000]       .init : 0xc02a2000 - 0xc02b865c   (  90 kB)
[    0.000000]       .data : 0xc02ba000 - 0xc02d60c0   ( 113 kB)
[    0.000000]        .bss : 0xc02d60c0 - 0xc07f5f14   (5248 kB)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:32 32
[    0.000000] /soc/interrupt-controller@98800000: moxart_of_init finished
[    0.000000] /soc/timer@98400000: count/load (APB_CLK=48000000/HZ=100) IRQ=19
[    0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns,
wraps every 4294967286ms
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
[    0.010000] Calibrating delay loop... 144.79 BogoMIPS (lpj=723968)
[    0.080000] pid_max: default: 4096 minimum: 301
[    0.080000] Mount-cache hash table entries: 512
[    0.110000] CPU: Testing write buffer coherency: ok
[    0.120000] calling  init_static_idmap+0x0/0xd4 @ 1
[    0.120000] Setting up static identity map for 0xc0219820 - 0xc0219868
[    0.120000] initcall init_static_idmap+0x0/0xd4 returned 0 after 0 usecs
[    0.120000] calling  spawn_ksoftirqd+0x0/0x1c @ 1
[    0.120000] initcall spawn_ksoftirqd+0x0/0x1c returned 0 after 0 usecs
[    0.120000] calling  init_workqueues+0x0/0x2c0 @ 1
[    0.130000] initcall init_workqueues+0x0/0x2c0 returned 0 after 9765 usecs
[    0.130000] calling  check_cpu_stall_init+0x0/0x20 @ 1
[    0.130000] initcall check_cpu_stall_init+0x0/0x20 returned 0 after 0 usecs
[    0.130000] calling  rcu_scheduler_really_started+0x0/0x18 @ 1
[    0.130000] initcall rcu_scheduler_really_started+0x0/0x18 returned
0 after 0 usecs
[    0.130000] calling  rcu_spawn_gp_kthread+0x0/0x7c @ 1
[    0.140000] initcall rcu_spawn_gp_kthread+0x0/0x7c returned 0 after
9765 usecs
[    0.150000] devtmpfs: initialized
[    0.160000] calling  ipc_ns_init+0x0/0x18 @ 1
[    0.160000] initcall ipc_ns_init+0x0/0x18 returned 0 after 0 usecs
[    0.160000] calling  init_mmap_min_addr+0x0/0x20 @ 1
[    0.160000] initcall init_mmap_min_addr+0x0/0x20 returned 0 after 0 usecs
[    0.160000] calling  net_ns_init+0x0/0x1d4 @ 1
[    0.160000] initcall net_ns_init+0x0/0x1d4 returned 0 after 0 usecs
[    0.160000] calling  ptrace_break_init+0x0/0x2c @ 1
[    0.160000] initcall ptrace_break_init+0x0/0x2c returned 0 after 0 usecs
[    0.160000] calling  wq_sysfs_init+0x0/0x10 @ 1
[    0.170000] initcall wq_sysfs_init+0x0/0x10 returned 0 after 9765 usecs
[    0.170000] calling  ksysfs_init+0x0/0x98 @ 1
[    0.170000] initcall ksysfs_init+0x0/0x98 returned 0 after 0 usecs
[    0.170000] calling  init_jiffies_clocksource+0x0/0xc @ 1
[    0.170000] initcall init_jiffies_clocksource+0x0/0xc returned 0
after 0 usecs
[    0.180000] calling  init_zero_pfn+0x0/0x44 @ 1
[    0.180000] initcall init_zero_pfn+0x0/0x44 returned 0 after 0 usecs
[    0.180000] calling  fsnotify_init+0x0/0x34 @ 1
[    0.180000] initcall fsnotify_init+0x0/0x34 returned 0 after 0 usecs
[    0.180000] calling  filelock_init+0x0/0x40 @ 1
[    0.180000] initcall filelock_init+0x0/0x40 returned 0 after 0 usecs
[    0.180000] calling  init_script_binfmt+0x0/0x1c @ 1
[    0.180000] initcall init_script_binfmt+0x0/0x1c returned 0 after 0 usecs
[    0.180000] calling  init_elf_binfmt+0x0/0x1c @ 1
[    0.180000] initcall init_elf_binfmt+0x0/0x1c returned 0 after 0 usecs
[    0.180000] calling  prandom_init+0x0/0x88 @ 1
[    0.180000] initcall prandom_init+0x0/0x88 returned 0 after 0 usecs
[    0.180000] calling  sock_init+0x0/0x90 @ 1
[    0.180000] initcall sock_init+0x0/0x90 returned 0 after 0 usecs
[    0.180000] calling  netlink_proto_init+0x0/0x22c @ 1
[    0.190000] NET: Registered protocol family 16
[    0.190000] initcall netlink_proto_init+0x0/0x22c returned 0 after 9765 usecs
[    0.190000] calling  atomic_pool_init+0x0/0x124 @ 1
[    0.200000] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.200000] initcall atomic_pool_init+0x0/0x124 returned 0 after 9765 usecs
[    0.200000] calling  bdi_class_init+0x0/0x44 @ 1
[    0.200000] initcall bdi_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.200000] calling  kobject_uevent_init+0x0/0xc @ 1
[    0.200000] initcall kobject_uevent_init+0x0/0xc returned 0 after 0 usecs
[    0.200000] calling  moxart_gpio_init+0x0/0xc @ 1
[    0.210000] initcall moxart_gpio_init+0x0/0xc returned 0 after 9765 usecs
[    0.210000] calling  tty_class_init+0x0/0x44 @ 1
[    0.210000] initcall tty_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.210000] calling  gate_vma_init+0x0/0x24 @ 1
[    0.210000] initcall gate_vma_init+0x0/0x24 returned 0 after 0 usecs
[    0.210000] calling  customize_machine+0x0/0x44 @ 1
[    0.240000] moxart-gpio 98700000.gpio: finished moxart_gpio_probe
gpio_base=c284a000 pmu_base=c284c000
[    0.280000] initcall customize_machine+0x0/0x44 returned 0 after 68359 usecs
[    0.290000] calling  exceptions_init+0x0/0x90 @ 1
[    0.290000] initcall exceptions_init+0x0/0x90 returned 0 after 0 usecs
[    0.290000] calling  moxart_idle_init+0x0/0x1c @ 1
[    0.290000] initcall moxart_idle_init+0x0/0x1c returned 0 after 0 usecs
[    0.290000] calling  dma_bus_init+0x0/0x14 @ 1
[    0.290000] initcall dma_bus_init+0x0/0x14 returned 0 after 0 usecs
[    0.290000] calling  dma_channel_table_init+0x0/0x11c @ 1
[    0.290000] initcall dma_channel_table_init+0x0/0x11c returned 0
after 0 usecs
[    0.290000] calling  topology_init+0x0/0x28 @ 1
[    0.290000] initcall topology_init+0x0/0x28 returned 0 after 0 usecs
[    0.300000] calling  param_sysfs_init+0x0/0x2d0 @ 1
[    0.480000] initcall param_sysfs_init+0x0/0x2d0 returned 0 after 175781 usecs
[    0.480000] calling  pm_sysrq_init+0x0/0x1c @ 1
[    0.480000] initcall pm_sysrq_init+0x0/0x1c returned 0 after 0 usecs
[    0.480000] calling  default_bdi_init+0x0/0x7c @ 1
[    0.490000] initcall default_bdi_init+0x0/0x7c returned 0 after 9765 usecs
[    0.490000] calling  init_bio+0x0/0xfc @ 1
[    0.490000] bio: create slab <bio-0> at 0
[    0.490000] initcall init_bio+0x0/0xfc returned 0 after 0 usecs
[    0.490000] calling  fsnotify_notification_init+0x0/0x98 @ 1
[    0.490000] initcall fsnotify_notification_init+0x0/0x98 returned 0
after 0 usecs
[    0.490000] calling  blk_settings_init+0x0/0x34 @ 1
[    0.490000] initcall blk_settings_init+0x0/0x34 returned 0 after 0 usecs
[    0.490000] calling  blk_ioc_init+0x0/0x40 @ 1
[    0.490000] initcall blk_ioc_init+0x0/0x40 returned 0 after 0 usecs
[    0.490000] calling  blk_softirq_init+0x0/0x2c @ 1
[    0.490000] initcall blk_softirq_init+0x0/0x2c returned 0 after 0 usecs
[    0.490000] calling  blk_iopoll_setup+0x0/0x2c @ 1
[    0.490000] initcall blk_iopoll_setup+0x0/0x2c returned 0 after 0 usecs
[    0.490000] calling  genhd_device_init+0x0/0x80 @ 1
[    0.500000] initcall genhd_device_init+0x0/0x80 returned 0 after 9765 usecs
[    0.500000] calling  moxart_init+0x0/0xc @ 1
[    0.520000] moxart-dma-engine 90500000.dma: finished moxart_probe IRQ=24
[    0.530000] initcall moxart_init+0x0/0xc returned 0 after 29296 usecs
[    0.530000] calling  misc_init+0x0/0xc0 @ 1
[    0.530000] initcall misc_init+0x0/0xc0 returned 0 after 0 usecs
[    0.530000] calling  rtc_init+0x0/0x60 @ 1
[    0.540000] initcall rtc_init+0x0/0x60 returned 0 after 0 usecs
[    0.540000] calling  mmc_init+0x0/0x84 @ 1
[    0.550000] initcall mmc_init+0x0/0x84 returned 0 after 9765 usecs
[    0.550000] calling  proto_init+0x0/0xc @ 1
[    0.550000] initcall proto_init+0x0/0xc returned 0 after 0 usecs
[    0.550000] calling  net_dev_init+0x0/0x180 @ 1
[    0.570000] initcall net_dev_init+0x0/0x180 returned 0 after 19531 usecs
[    0.570000] calling  neigh_init+0x0/0xa4 @ 1
[    0.570000] initcall neigh_init+0x0/0xa4 returned 0 after 0 usecs
[    0.570000] calling  genl_init+0x0/0x80 @ 1
[    0.580000] initcall genl_init+0x0/0x80 returned 0 after 9765 usecs
[    0.580000] calling  proc_cpu_init+0x0/0x24 @ 1
[    0.580000] initcall proc_cpu_init+0x0/0x24 returned 0 after 0 usecs
[    0.580000] calling  dma_debug_do_init+0x0/0x8 @ 1
[    0.580000] initcall dma_debug_do_init+0x0/0x8 returned 0 after 0 usecs
[    0.580000] calling  alignment_init+0x0/0xf4 @ 1
[    0.580000] initcall alignment_init+0x0/0xf4 returned 0 after 0 usecs
[    0.580000] calling  clocksource_done_booting+0x0/0x58 @ 1
[    0.580000] initcall clocksource_done_booting+0x0/0x58 returned 0
after 0 usecs
[    0.580000] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.580000] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
[    0.580000] calling  eventpoll_init+0x0/0xac @ 1
[    0.580000] initcall eventpoll_init+0x0/0xac returned 0 after 0 usecs
[    0.580000] calling  anon_inode_init+0x0/0x64 @ 1
[    0.580000] initcall anon_inode_init+0x0/0x64 returned 0 after 0 usecs
[    0.590000] calling  blk_scsi_ioctl_init+0x0/0xdc @ 1
[    0.590000] initcall blk_scsi_ioctl_init+0x0/0xdc returned 0 after 0 usecs
[    0.590000] calling  chr_dev_init+0x0/0xd4 @ 1
[    0.640000] initcall chr_dev_init+0x0/0xd4 returned 0 after 48828 usecs
[    0.640000] calling  sysctl_core_init+0x0/0x30 @ 1
[    0.640000] initcall sysctl_core_init+0x0/0x30 returned 0 after 0 usecs
[    0.640000] calling  inet_init+0x0/0x250 @ 1
[    0.640000] NET: Registered protocol family 2
[    0.650000] TCP established hash table entries: 512 (order: 0, 4096 bytes)
[    0.660000] TCP bind hash table entries: 512 (order: 2, 18432 bytes)
[    0.660000] TCP: Hash tables configured (established 512 bind 512)
[    0.660000] TCP: reno registered
[    0.660000] UDP hash table entries: 128 (order: 1, 10240 bytes)
[    0.660000] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
[    0.670000] initcall inet_init+0x0/0x250 returned 0 after 29296 usecs
[    0.670000] calling  ipv4_offload_init+0x0/0x64 @ 1
[    0.670000] initcall ipv4_offload_init+0x0/0x64 returned 0 after 0 usecs
[    0.670000] calling  af_unix_init+0x0/0x54 @ 1
[    0.670000] NET: Registered protocol family 1
[    0.670000] initcall af_unix_init+0x0/0x54 returned 0 after 0 usecs
[    0.670000] calling  ipv6_offload_init+0x0/0x64 @ 1
[    0.670000] initcall ipv6_offload_init+0x0/0x64 returned 0 after 0 usecs
[    0.670000] calling  default_rootfs+0x0/0x70 @ 1
[    0.670000] initcall default_rootfs+0x0/0x70 returned 0 after 0 usecs
[    0.680000] calling  sched_clock_syscore_init+0x0/0x18 @ 1
[    0.680000] initcall sched_clock_syscore_init+0x0/0x18 returned 0
after 0 usecs
[    0.680000] calling  proc_execdomains_init+0x0/0x38 @ 1
[    0.680000] initcall proc_execdomains_init+0x0/0x38 returned 0 after 0 usecs
[    0.680000] calling  ioresources_init+0x0/0x58 @ 1
[    0.680000] initcall ioresources_init+0x0/0x58 returned 0 after 0 usecs
[    0.680000] calling  uid_cache_init+0x0/0x98 @ 1
[    0.680000] initcall uid_cache_init+0x0/0x98 returned 0 after 0 usecs
[    0.680000] calling  init_posix_timers+0x0/0x208 @ 1
[    0.680000] initcall init_posix_timers+0x0/0x208 returned 0 after 0 usecs
[    0.680000] calling  init_posix_cpu_timers+0x0/0xe4 @ 1
[    0.680000] initcall init_posix_cpu_timers+0x0/0xe4 returned 0 after 0 usecs
[    0.680000] calling  timekeeping_init_ops+0x0/0x18 @ 1
[    0.680000] initcall timekeeping_init_ops+0x0/0x18 returned 0 after 0 usecs
[    0.680000] calling  init_clocksource_sysfs+0x0/0x54 @ 1
[    0.690000] initcall init_clocksource_sysfs+0x0/0x54 returned 0
after 9765 usecs
[    0.690000] calling  init_timer_list_procfs+0x0/0x40 @ 1
[    0.690000] initcall init_timer_list_procfs+0x0/0x40 returned 0 after 0 usecs
[    0.690000] calling  alarmtimer_init+0x0/0x1a4 @ 1
[    0.700000] initcall alarmtimer_init+0x0/0x1a4 returned 0 after 9765 usecs
[    0.700000] calling  lockdep_proc_init+0x0/0x74 @ 1
[    0.700000] initcall lockdep_proc_init+0x0/0x74 returned 0 after 0 usecs
[    0.700000] calling  futex_init+0x0/0x84 @ 1
[    0.700000] initcall futex_init+0x0/0x84 returned 0 after 0 usecs
[    0.700000] calling  kallsyms_init+0x0/0x38 @ 1
[    0.700000] initcall kallsyms_init+0x0/0x38 returned 0 after 0 usecs
[    0.700000] calling  ikconfig_init+0x0/0x58 @ 1
[    0.700000] initcall ikconfig_init+0x0/0x58 returned 0 after 0 usecs
[    0.700000] calling  hung_task_init+0x0/0x54 @ 1
[    0.700000] initcall hung_task_init+0x0/0x54 returned 0 after 0 usecs
[    0.700000] calling  utsname_sysctl_init+0x0/0x18 @ 1
[    0.700000] initcall utsname_sysctl_init+0x0/0x18 returned 0 after 0 usecs
[    0.700000] calling  init_per_zone_wmark_min+0x0/0x88 @ 1
[    0.700000] initcall init_per_zone_wmark_min+0x0/0x88 returned 0
after 0 usecs
[    0.700000] calling  kswapd_init+0x0/0x18 @ 1
[    0.700000] initcall kswapd_init+0x0/0x18 returned 0 after 0 usecs
[    0.700000] calling  setup_vmstat+0x0/0x90 @ 1
[    0.700000] initcall setup_vmstat+0x0/0x90 returned 0 after 0 usecs
[    0.700000] calling  mm_sysfs_init+0x0/0x38 @ 1
[    0.700000] initcall mm_sysfs_init+0x0/0x38 returned 0 after 0 usecs
[    0.710000] calling  init_reserve_notifier+0x0/0x8 @ 1
[    0.710000] initcall init_reserve_notifier+0x0/0x8 returned 0 after 0 usecs
[    0.710000] calling  init_admin_reserve+0x0/0x30 @ 1
[    0.710000] initcall init_admin_reserve+0x0/0x30 returned 0 after 0 usecs
[    0.710000] calling  init_user_reserve+0x0/0x30 @ 1
[    0.710000] initcall init_user_reserve+0x0/0x30 returned 0 after 0 usecs
[    0.710000] calling  proc_vmalloc_init+0x0/0x38 @ 1
[    0.710000] initcall proc_vmalloc_init+0x0/0x38 returned 0 after 0 usecs
[    0.710000] calling  slab_sysfs_init+0x0/0x108 @ 1
[    0.940000] initcall slab_sysfs_init+0x0/0x108 returned 0 after 224609 usecs
[    0.940000] calling  fcntl_init+0x0/0x40 @ 1
[    0.940000] initcall fcntl_init+0x0/0x40 returned 0 after 0 usecs
[    0.940000] calling  proc_filesystems_init+0x0/0x38 @ 1
[    0.940000] initcall proc_filesystems_init+0x0/0x38 returned 0 after 0 usecs
[    0.940000] calling  dio_init+0x0/0x40 @ 1
[    0.950000] initcall dio_init+0x0/0x40 returned 0 after 9765 usecs
[    0.950000] calling  fsnotify_mark_init+0x0/0x40 @ 1
[    0.950000] initcall fsnotify_mark_init+0x0/0x40 returned 0 after 0 usecs
[    0.950000] calling  dnotify_init+0x0/0x80 @ 1
[    0.950000] initcall dnotify_init+0x0/0x80 returned 0 after 0 usecs
[    0.950000] calling  inotify_user_setup+0x0/0x78 @ 1
[    0.950000] initcall inotify_user_setup+0x0/0x78 returned 0 after 0 usecs
[    0.950000] calling  proc_locks_init+0x0/0x38 @ 1
[    0.950000] initcall proc_locks_init+0x0/0x38 returned 0 after 0 usecs
[    0.950000] calling  init_mbcache+0x0/0x18 @ 1
[    0.950000] initcall init_mbcache+0x0/0x18 returned 0 after 0 usecs
[    0.950000] calling  proc_cmdline_init+0x0/0x38 @ 1
[    0.950000] initcall proc_cmdline_init+0x0/0x38 returned 0 after 0 usecs
[    0.950000] calling  proc_consoles_init+0x0/0x38 @ 1
[    0.950000] initcall proc_consoles_init+0x0/0x38 returned 0 after 0 usecs
[    0.950000] calling  proc_cpuinfo_init+0x0/0x38 @ 1
[    0.950000] initcall proc_cpuinfo_init+0x0/0x38 returned 0 after 0 usecs
[    0.950000] calling  proc_devices_init+0x0/0x38 @ 1
[    0.950000] initcall proc_devices_init+0x0/0x38 returned 0 after 0 usecs
[    0.950000] calling  proc_interrupts_init+0x0/0x38 @ 1
[    0.960000] initcall proc_interrupts_init+0x0/0x38 returned 0 after
9765 usecs
[    0.960000] calling  proc_loadavg_init+0x0/0x38 @ 1
[    0.960000] initcall proc_loadavg_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_meminfo_init+0x0/0x38 @ 1
[    0.960000] initcall proc_meminfo_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_stat_init+0x0/0x38 @ 1
[    0.960000] initcall proc_stat_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_uptime_init+0x0/0x38 @ 1
[    0.960000] initcall proc_uptime_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_version_init+0x0/0x38 @ 1
[    0.960000] initcall proc_version_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_softirqs_init+0x0/0x38 @ 1
[    0.960000] initcall proc_softirqs_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_kmsg_init+0x0/0x38 @ 1
[    0.960000] initcall proc_kmsg_init+0x0/0x38 returned 0 after 0 usecs
[    0.960000] calling  proc_page_init+0x0/0x58 @ 1
[    0.960000] initcall proc_page_init+0x0/0x58 returned 0 after 0 usecs
[    0.960000] calling  init_devpts_fs+0x0/0x68 @ 1
[    0.960000] initcall init_devpts_fs+0x0/0x68 returned 0 after 0 usecs
[    0.960000] calling  init_ext3_fs+0x0/0x8c @ 1
[    0.970000] initcall init_ext3_fs+0x0/0x8c returned 0 after 9765 usecs
[    0.970000] calling  journal_init+0x0/0xb4 @ 1
[    0.990000] initcall journal_init+0x0/0xb4 returned 0 after 19531 usecs
[    0.990000] calling  init_ramfs_fs+0x0/0xc @ 1
[    0.990000] initcall init_ramfs_fs+0x0/0xc returned 0 after 0 usecs
[    0.990000] calling  init_jffs2_fs+0x0/0xd8 @ 1
[    0.990000] jffs2: version 2.2. (NAND) Â© 2001-2006 Red Hat, Inc.
[    1.000000] initcall init_jffs2_fs+0x0/0xd8 returned 0 after 9765 usecs
[    1.000000] calling  ipc_init+0x0/0x24 @ 1
[    1.000000] msgmni has been set to 47
[    1.000000] initcall ipc_init+0x0/0x24 returned 0 after 0 usecs
[    1.000000] calling  ipc_sysctl_init+0x0/0x18 @ 1
[    1.000000] initcall ipc_sysctl_init+0x0/0x18 returned 0 after 0 usecs
[    1.000000] calling  key_proc_init+0x0/0x48 @ 1
[    1.000000] initcall key_proc_init+0x0/0x48 returned 0 after 0 usecs
[    1.000000] calling  crypto_algapi_init+0x0/0x10 @ 1
[    1.000000] initcall crypto_algapi_init+0x0/0x10 returned 0 after 0 usecs
[    1.000000] calling  aes_init+0x0/0xc @ 1
[    1.010000] initcall aes_init+0x0/0xc returned 0 after 9765 usecs
[    1.010000] calling  krng_mod_init+0x0/0xc @ 1
[    1.010000] initcall krng_mod_init+0x0/0xc returned 0 after 0 usecs
[    1.010000] calling  prng_mod_init+0x0/0x10 @ 1
[    1.010000] initcall prng_mod_init+0x0/0x10 returned 0 after 0 usecs
[    1.010000] calling  proc_genhd_init+0x0/0x58 @ 1
[    1.010000] initcall proc_genhd_init+0x0/0x58 returned 0 after 0 usecs
[    1.010000] calling  noop_init+0x0/0xc @ 1
[    1.010000] io scheduler noop registered
[    1.010000] initcall noop_init+0x0/0xc returned 0 after 0 usecs
[    1.010000] calling  cfq_init+0x0/0x94 @ 1
[    1.010000] io scheduler cfq registered (default)
[    1.010000] initcall cfq_init+0x0/0x94 returned 0 after 0 usecs
[    1.010000] calling  pty_init+0x0/0x230 @ 1
[    1.020000] initcall pty_init+0x0/0x230 returned 0 after 9765 usecs
[    1.020000] calling  sysrq_init+0x0/0x48 @ 1
[    1.020000] initcall sysrq_init+0x0/0x48 returned 0 after 0 usecs
[    1.020000] calling  serial8250_init+0x0/0x158 @ 1
[    1.020000] Serial: 8250/16550 driver, 1 ports, IRQ sharing enabled
[    1.030000] initcall serial8250_init+0x0/0x158 returned 0 after 9765 usecs
[    1.040000] calling  of_platform_serial_driver_init+0x0/0xc @ 1
[    1.060000] 98200000.uart: ttyS0 at MMIO 0x98200000 (irq = 31) is a 16550A
[    2.960000] console [ttyS0] enabled
[    2.970000] initcall of_platform_serial_driver_init+0x0/0xc
returned 0 after 1884765 usecs
[    2.980000] calling  mxser_module_init+0x0/0x49c @ 1
[    2.990000] MOXA Smartio/Industio family driver version 2.0.5
[    3.000000] mxser: found MOXA UC-7112-LX board (CAP=0x0)
[    3.000000] mxser: mxser_initbrd success IRQ=31 max baud=921600 bps
[    3.020000] initcall mxser_module_init+0x0/0x49c returned 0 after 29296 usecs
[    3.030000] calling  rand_initialize+0x0/0x2c @ 1
[    3.040000] initcall rand_initialize+0x0/0x2c returned 0 after 0 usecs
[    3.040000] calling  topology_sysfs_init+0x0/0x20 @ 1
[    3.050000] initcall topology_sysfs_init+0x0/0x20 returned 0 after 0 usecs
[    3.060000] calling  init_mtd+0x0/0xf8 @ 1
[    3.080000] initcall init_mtd+0x0/0xf8 returned 0 after 19531 usecs
[    3.090000] calling  ofpart_parser_init+0x0/0x38 @ 1
[    3.090000] initcall ofpart_parser_init+0x0/0x38 returned 0 after 0 usecs
[    3.100000] calling  init_mtdblock+0x0/0xc @ 1
[    3.110000] initcall init_mtdblock+0x0/0xc returned 0 after 0 usecs
[    3.110000] calling  cfi_probe_init+0x0/0x18 @ 1
[    3.120000] initcall cfi_probe_init+0x0/0x18 returned 0 after 0 usecs
[    3.130000] calling  physmap_init+0x0/0xc @ 1
[    3.130000] initcall physmap_init+0x0/0xc returned 0 after 0 usecs
[    3.140000] calling  of_flash_driver_init+0x0/0xc @ 1
[    3.170000] 80000000.flash: Found 1 x16 devices at 0x0 in 16-bit
bank. Manufacturer ID 0x000089 Chip ID 0x000018
[    3.180000] Intel/Sharp Extended Query Table at 0x0031
[    3.190000] Intel/Sharp Extended Query Table at 0x0031
[    3.200000] Using buffer write method
[    3.200000] cfi_cmdset_0001: Erase suspend on write enabled
[    3.210000] erase region 0: offset=0x0,size=0x20000,blocks=128
[    3.210000] 4 ofpart partitions found on MTD device 80000000.flash
[    3.220000] Creating 4 MTD partitions on "80000000.flash":
[    3.220000] 0x000000000000-0x000000040000 : "bootloader"
[    3.270000] 0x000000040000-0x000000200000 : "linux kernel"
[    3.300000] 0x000000200000-0x000000a00000 : "root filesystem"
[    3.330000] 0x000000a00000-0x000001000000 : "user filesystem"
[    3.370000] initcall of_flash_driver_init+0x0/0xc returned 0 after
214843 usecs
[    3.380000] calling  net_olddevs_init+0x0/0x68 @ 1
[    3.380000] initcall net_olddevs_init+0x0/0x68 returned 0 after 0 usecs
[    3.390000] calling  moxart_mac_init+0x0/0xc @ 1
[    3.440000] moxart-ethernet 90900000.mac eth0: moxart_mac_probe:
IRQ=25 address=00:90:e8:1b:e2:a5
[    3.500000] moxart-ethernet 92000000.mac eth1: moxart_mac_probe:
IRQ=27 address=00:90:e8:1b:e2:a6
[    3.520000] initcall moxart_mac_init+0x0/0xc returned 0 after 126953 usecs
[    3.520000] calling  moxart_rtc_init+0x0/0xc @ 1
[    3.540000] moxart-rtc rtc.0: rtc core: registered rtc.0 as rtc0
[    3.550000] moxart-rtc rtc.0: finished moxart_rtc_probe
[    3.560000] initcall moxart_rtc_init+0x0/0xc returned 0 after 29296 usecs
[    3.570000] calling  moxart_wdt_init+0x0/0xc @ 1
[    3.580000] moxart-watchdog 98500000.watchdog: finished
moxart_wdt_probe base=c2920000
[    3.600000] initcall moxart_wdt_init+0x0/0xc returned 0 after 29296 usecs
[    3.600000] calling  mmc_blk_init+0x0/0x74 @ 1
[    3.610000] initcall mmc_blk_init+0x0/0x74 returned 0 after 0 usecs
[    3.620000] calling  moxart_init+0x0/0xc @ 1
[   24.650000] INFO: rcu_preempt detected stalls on CPUs/tasks: {}
(detected by 0, t=2102 jiffies, g=4294967164, c=4294967163, q=9)
[   24.650000] INFO: Stall ended before state dump start
[   87.700000] INFO: rcu_preempt detected stalls on CPUs/tasks: {}
(detected by 0, t=8407 jiffies, g=4294967164, c=4294967163, q=9)
[   87.700000] INFO: Stall ended before state dump start
[  150.750000] INFO: rcu_preempt detected stalls on CPUs/tasks: {}
(detected by 0, t=14712 jiffies, g=4294967164, c=4294967163, q=9)
[  150.750000] INFO: Stall ended before state dump start
