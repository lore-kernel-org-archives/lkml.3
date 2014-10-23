Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaJWNV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:21:28 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58217 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaJWNVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:21:22 -0400
Date: Thu, 23 Oct 2014 16:21:17 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: hung tasks in 3.18.0-rc1-00221-gc3351df
Message-ID: <alpine.LRH.2.11.1410231619340.11555@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is first real test on a computer where 3.17 did hang. Fist the hung 
task info, then full dmesg.

[  960.346611] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
[  960.346616]       Tainted: G        W      3.18.0-rc1-00221-gc3351df #150
[  960.346618] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  960.346621] kworker/u16:0   D 0000000000000000     0     6      2 0x00000000
[  960.346633] Workqueue: netns cleanup_net
[  960.346635]  ffff880111c4d1e0 0000000000000002 ffff880111c4d1e0 ffff880111c53fd8
[  960.346639]  ffff880111c4d1e0 000000000000a000 ffff880111c4d1e0 0000000000000296
[  960.346642]  0000000000000000 7fffffffffffffff 7fffffffffffffff ffffffff8182e010
[  960.346646] Call Trace:
[  960.346654]  [<ffffffff8153dcfd>] ? schedule_timeout+0x18d/0x200
[  960.346660]  [<ffffffff810915a0>] ? get_state_synchronize_rcu+0x10/0x10
[  960.346664]  [<ffffffff8153c544>] ? wait_for_completion+0xb4/0x110
[  960.346669]  [<ffffffff8153e5d5>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[  960.346672]  [<ffffffff8153c539>] ? wait_for_completion+0xa9/0x110
[  960.346677]  [<ffffffff81069450>] ? wake_up_state+0x10/0x10
[  960.346681]  [<ffffffff8109285a>] ? _rcu_barrier+0x14a/0x1d0
[  960.346686]  [<ffffffff8145f13c>] ? netdev_run_todo+0x5c/0x310
[  960.346691]  [<ffffffff81458775>] ? rollback_registered_many+0x265/0x2d0
[  960.346696]  [<ffffffff81459db6>] ? default_device_exit_batch+0x136/0x150
[  960.346701]  [<ffffffff8107a240>] ? __wake_up_sync+0x10/0x10
[  960.346704]  [<ffffffff81454310>] ? cleanup_net+0xf0/0x1d0
[  960.346709]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
[  960.346713]  [<ffffffff81058ca7>] ? pwq_activate_delayed_work+0x27/0x40
[  960.346716]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
[  960.346720]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
[  960.346723]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
[  960.346726]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
[  960.346729]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[  960.346734]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
[  960.346737]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[ 1080.363583] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
[ 1080.363589]       Tainted: G        W      3.18.0-rc1-00221-gc3351df #150
[ 1080.363591] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1080.363594] kworker/u16:0   D 0000000000000000     0     6      2 0x00000000
[ 1080.363604] Workqueue: netns cleanup_net
[ 1080.363607]  ffff880111c4d1e0 0000000000000002 ffff880111c4d1e0 ffff880111c53fd8
[ 1080.363610]  ffff880111c4d1e0 000000000000a000 ffff880111c4d1e0 0000000000000296
[ 1080.363614]  0000000000000000 7fffffffffffffff 7fffffffffffffff ffffffff8182e010
[ 1080.363617] Call Trace:
[ 1080.363625]  [<ffffffff8153dcfd>] ? schedule_timeout+0x18d/0x200
[ 1080.363633]  [<ffffffff810915a0>] ? get_state_synchronize_rcu+0x10/0x10
[ 1080.363637]  [<ffffffff8153c544>] ? wait_for_completion+0xb4/0x110
[ 1080.363641]  [<ffffffff8153e5d5>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[ 1080.363645]  [<ffffffff8153c539>] ? wait_for_completion+0xa9/0x110
[ 1080.363649]  [<ffffffff81069450>] ? wake_up_state+0x10/0x10
[ 1080.363653]  [<ffffffff8109285a>] ? _rcu_barrier+0x14a/0x1d0
[ 1080.363658]  [<ffffffff8145f13c>] ? netdev_run_todo+0x5c/0x310
[ 1080.363663]  [<ffffffff81458775>] ? rollback_registered_many+0x265/0x2d0
[ 1080.363667]  [<ffffffff81459db6>] ? default_device_exit_batch+0x136/0x150
[ 1080.363672]  [<ffffffff8107a240>] ? __wake_up_sync+0x10/0x10
[ 1080.363676]  [<ffffffff81454310>] ? cleanup_net+0xf0/0x1d0
[ 1080.363681]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
[ 1080.363684]  [<ffffffff81058ca7>] ? pwq_activate_delayed_work+0x27/0x40
[ 1080.363688]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
[ 1080.363691]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
[ 1080.363695]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
[ 1080.363698]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
[ 1080.363702]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[ 1080.363706]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
[ 1080.363709]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180




[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.0-rc1-00221-gc3351df (mroos@prometheus) (gcc version 4.9.1 (Debian 4.9.1-18) ) #150 SMP Thu Oct 23 14:21:19 EEST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc1-00221-gc3351df root=/dev/sda1 ro drm.debug=0xe
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000db7ac43f] usable
[    0.000000] BIOS-e820: [mem 0x00000000db7ac440-0x00000000db7ae49f] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db7ae4a0-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f4000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed45000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000117ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP Compaq 8100 Elite SFF PC/304Ah, BIOS 786H1 v01.13 07/14/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x118000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   2 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb7ac max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f9bf0-0x000f9bff] mapped at [ffff8800000f9bf0]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x019ef000, 0x019effff] PGTABLE
[    0.000000] BRK [0x019f0000, 0x019f0fff] PGTABLE
[    0.000000] BRK [0x019f1000, 0x019f1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x117e00000-0x117ffffff]
[    0.000000]  [mem 0x117e00000-0x117ffffff] page 2M
[    0.000000] BRK [0x019f2000, 0x019f2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x114000000-0x117dfffff]
[    0.000000]  [mem 0x114000000-0x117dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x113ffffff]
[    0.000000]  [mem 0x100000000-0x113ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdb7abfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdb5fffff] page 2M
[    0.000000]  [mem 0xdb600000-0xdb7abfff] page 4k
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000E5210 000014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 0x00000000DB7D0540 000040 (v01 HPQOEM SLIC-BPC 20110714      00000000)
[    0.000000] ACPI: FACP 0x00000000DB7D05E8 000074 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000050/0x0 (20140828/tbfadt-649)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20140828/tbfadt-699)
[    0.000000] ACPI: DSDT 0x00000000DB7D0A4F 00A69E (v01 COMPAQ DSDT_PRJ 00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x00000000DB7D0500 000040
[    0.000000] ACPI: APIC 0x00000000DB7D065C 0000BC (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: ASF! 0x00000000DB7D0718 000063 (v32 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: MCFG 0x00000000DB7D077B 00003C (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: TCPA 0x00000000DB7D07B7 000032 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: SLIC 0x00000000DB7D07E9 000176 (v01 HPQOEM SLIC-BPC 00000001      00000000)
[    0.000000] ACPI: HPET 0x00000000DB7D095F 000038 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880113800000-ffff8801175fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x117ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdb7abfff]
[    0.000000]   node   0: [mem 0x100000000-0x117ffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x117ffffff]
[    0.000000] On node 0 totalpages: 997194
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13983 pages used for memmap
[    0.000000]   DMA32 zone: 894892 pages, LIFO batch:31
[    0.000000]   Normal zone: 1536 pages used for memmap
[    0.000000]   Normal zone: 98304 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xde000000-0xdfffffff
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e8000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb7ac000-0xdb7acfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb7ad000-0xdb7adfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb7ae000-0xdb7aefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb7af000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xf3ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf4000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfed3ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed40000-0xfed44fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed45000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xf3ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880117c00000 s76672 r8192 d29824 u262144
[    0.000000] pcpu-alloc: s76672 r8192 d29824 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 981590
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc1-00221-gc3351df root=/dev/sda1 ro drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3841836K/3988776K available (5388K kernel code, 463K rwdata, 1712K rodata, 796K init, 688K bss, 146940K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:488 0
[    0.000000] NO_HZ: Clearing 0 from nohz_full range for timekeeping
[    0.000000] NO_HZ: Full dynticks CPUs: 1-7.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16252928 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3325.272 MHz processor
[    0.000020] Calibrating delay loop (skipped), value calculated using timer frequency.. 6650.54 BogoMIPS (lpj=13301088)
[    0.000080] pid_max: default: 32768 minimum: 301
[    0.000115] ACPI: Core revision 20140828
[    0.002049] ACPI: All ACPI Tables successfully acquired
[    0.004468] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.004509] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.004702] Initializing cgroup subsys memory
[    0.004739] Initializing cgroup subsys devices
[    0.004774] Initializing cgroup subsys freezer
[    0.004810] Initializing cgroup subsys blkio
[    0.004844] Initializing cgroup subsys perf_event
[    0.004880] Initializing cgroup subsys hugetlb
[    0.004927] CPU: Physical Processor ID: 0
[    0.004959] CPU: Processor Core ID: 0
[    0.004993] mce: CPU supports 9 MCE banks
[    0.005033] CPU0: Thermal monitoring enabled (TM1)
[    0.005074] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.005231] Freeing SMP alternatives memory: 20K (ffffffff8193c000 - ffffffff81941000)
[    0.005714] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045441] smpboot: CPU0: Intel(R) Core(TM) i5 CPU         660  @ 3.33GHz (fam: 06, model: 25, stepping: 05)
[    0.151571] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.151662] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.151702] ... version:                3
[    0.151735] ... bit width:              48
[    0.151768] ... generic registers:      4
[    0.151800] ... value mask:             0000ffffffffffff
[    0.151835] ... max period:             000000007fffffff
[    0.151871] ... fixed-purpose events:   3
[    0.151904] ... event mask:             000000070000000f
[    0.152158] x86: Booting SMP configuration:
[    0.152192] .... node  #0, CPUs:      #1
[    0.165511] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.165671]  #2 #3
[    0.192070] x86: Booted up 1 node, 4 CPUs
[    0.192127] smpboot: Total of 4 processors activated (26602.17 BogoMIPS)
[    0.193902] devtmpfs: initialized
[    0.194074] PM: Registering ACPI NVS region [mem 0xdb7ac440-0xdb7ae49f] (8288 bytes)
[    0.194142] reboot: HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
[    0.194296] pinctrl core: initialized pinctrl subsystem
[    0.194419] NET: Registered protocol family 16
[    0.195579] cpuidle: using governor ladder
[    0.199575] cpuidle: using governor menu
[    0.199632] ACPI: bus type PCI registered
[    0.199714] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.199778] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.199865] PCI: Using configuration type 1 for base access
[    0.203809] ACPI: Added _OSI(Module Device)
[    0.203844] ACPI: Added _OSI(Processor Device)
[    0.203878] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.203912] ACPI: Added _OSI(Processor Aggregator Device)
[    0.219606] ACPI: Dynamic OEM Table Load:
[    0.219651] ACPI: SSDT 0xFFFF880111EB3400 0003BA (v01 COMPAQ CPU_TM2  00000001 MSFT 0100000E)
[    0.227603] ACPI: Dynamic OEM Table Load:
[    0.227647] ACPI: SSDT 0xFFFF880111EB3800 0003D8 (v01 COMPAQ CST      00000001 MSFT 0100000E)
[    0.239755] ACPI: Interpreter enabled
[    0.239792] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140828/hwxface-580)
[    0.239865] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140828/hwxface-580)
[    0.239945] ACPI: (supports S0 S3 S4 S5)
[    0.239978] ACPI: Using IOAPIC for interrupt routing
[    0.240027] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.245856] acpi LNXCPU:00: Invalid PBLK length [7]
[    0.245896] acpi LNXCPU:01: Invalid PBLK length [7]
[    0.245935] acpi LNXCPU:02: Invalid PBLK length [7]
[    0.245974] acpi LNXCPU:03: Invalid PBLK length [7]
[    0.247670] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.247710] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.247774] ACPI BIOS Error (bug): \_SB_.PCI0._OSC: Excess arguments - ASL declared 5, ACPI requires 4 (20140828/nsarguments-189)
[    0.247878] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20140828/dsfield-211)
[    0.247956] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff88011302c668), AE_ALREADY_EXISTS (20140828/psparse-536)
[    0.248048] acpi PNP0A08:00: _OSC failed (AE_ALREADY_EXISTS); disabling ASPM
[    0.248261] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.248372] PCI host bridge to bus 0000:00
[    0.248406] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.248443] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.248483] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.248520] pci_bus 0000:00: root bus resource [io  0x1000-0x2fff]
[    0.248558] pci_bus 0000:00: root bus resource [io  0x3000-0x6fff]
[    0.248597] pci_bus 0000:00: root bus resource [io  0x7000-0xafff]
[    0.248635] pci_bus 0000:00: root bus resource [io  0xb000-0xffff]
[    0.248672] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.248713] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf3ffffff]
[    0.248754] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.248798] pci 0000:00:00.0: [8086:0040] type 00 class 0x060000
[    0.248813] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.248893] pci 0000:00:02.0: [8086:0042] type 00 class 0x030000
[    0.248902] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.248906] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.248909] pci 0000:00:02.0: reg 0x20: [io  0x1170-0x1177]
[    0.248982] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.249008] pci 0000:00:16.0: reg 0x10: [mem 0xf0427100-0xf042710f 64bit]
[    0.249096] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.249145] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.249161] pci 0000:00:16.3: reg 0x10: [io  0x1188-0x118f]
[    0.249170] pci 0000:00:16.3: reg 0x14: [mem 0xf0424000-0xf0424fff]
[    0.249284] pci 0000:00:19.0: [8086:10ef] type 00 class 0x020000
[    0.249297] pci 0000:00:19.0: reg 0x10: [mem 0xf0400000-0xf041ffff]
[    0.249303] pci 0000:00:19.0: reg 0x14: [mem 0xf0425000-0xf0425fff]
[    0.249309] pci 0000:00:19.0: reg 0x18: [io  0x1100-0x111f]
[    0.249358] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.249380] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.249449] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.249467] pci 0000:00:1a.0: reg 0x10: [mem 0xf0426800-0xf0426bff]
[    0.249540] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.249565] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.249631] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.249643] pci 0000:00:1b.0: reg 0x10: [mem 0xf0420000-0xf0423fff 64bit]
[    0.249700] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.249747] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.249802] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.249826] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.249892] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.249948] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.249971] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.250034] pci 0000:00:1c.6: [8086:3b4e] type 01 class 0x060400
[    0.250089] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.250112] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.250180] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.250196] pci 0000:00:1d.0: reg 0x10: [mem 0xf0426c00-0xf0426fff]
[    0.250269] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.250293] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.250354] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.250407] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.250471] pci 0000:00:1f.0: [8086:3b0a] type 00 class 0x060100
[    0.250601] pci 0000:00:1f.2: [8086:3b22] type 00 class 0x010601
[    0.250615] pci 0000:00:1f.2: reg 0x10: [io  0x1190-0x1197]
[    0.250620] pci 0000:00:1f.2: reg 0x14: [io  0x11a8-0x11ab]
[    0.250626] pci 0000:00:1f.2: reg 0x18: [io  0x1198-0x119f]
[    0.250632] pci 0000:00:1f.2: reg 0x1c: [io  0x11ac-0x11af]
[    0.250637] pci 0000:00:1f.2: reg 0x20: [io  0x1120-0x113f]
[    0.250643] pci 0000:00:1f.2: reg 0x24: [mem 0xf0426000-0xf04267ff]
[    0.250678] pci 0000:00:1f.2: PME# supported from D3hot
[    0.250770] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.250857] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.250944] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.251061] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
[    0.251107] pci 0000:00:1e.0:   bridge window [mem 0xf8000000-0xfdffffff] (subtractive decode)
[    0.251108] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.251109] pci 0000:00:1e.0:   bridge window [io  0x1000-0x2fff] (subtractive decode)
[    0.251110] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff] (subtractive decode)
[    0.251111] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff] (subtractive decode)
[    0.251112] pci 0000:00:1e.0:   bridge window [io  0xb000-0xffff] (subtractive decode)
[    0.251114] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.251115] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf3ffffff] (subtractive decode)
[    0.251116] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.251131] pci_bus 0000:00: on NUMA node 0
[    0.251403] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.251519] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.251638] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.251752] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.251865] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.251978] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.252093] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.252207] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.252403] ACPI: Enabled 1 GPEs in block 00 to 3F
[    0.252493] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.252531] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.252592] vgaarb: loaded
[    0.252622] vgaarb: bridge control possible 0000:00:02.0
[    0.252694] SCSI subsystem initialized
[    0.252755] libata version 3.00 loaded.
[    0.252782] PCI: Using ACPI for IRQ routing
[    0.253908] PCI: Discovered peer bus 3f
[    0.253941] PCI: root bus 3f: using default resources
[    0.253943] PCI: Probing PCI hardware (bus 3f)
[    0.253961] PCI host bridge to bus 0000:3f
[    0.253995] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.254033] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
[    0.254074] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    0.254136] pci_bus 0000:3f: busn_res: can not insert [bus 3f-ff] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    0.254139] pci 0000:3f:00.0: [8086:2c61] type 00 class 0x060000
[    0.254169] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    0.254198] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    0.254225] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    0.254253] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    0.254280] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    0.254314] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.254315] pci_bus 0000:3f: busn_res: can not insert [bus 3f] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    0.254317] PCI: pci_cache_line_size set to 64 bytes
[    0.254347] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.254348] e820: reserve RAM buffer [mem 0xdb7ac440-0xdbffffff]
[    0.254437] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.254512] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.256570] Switched to clocksource hpet
[    0.256651] pnp: PnP ACPI init
[    0.256717] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.256736] pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.256753] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.256907] pnp 00:03: [dma 3]
[    0.256944] pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.257093] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.257127] pnp 00:05: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.257246] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.257273] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.257312] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.257340] system 00:08: [io  0x0400-0x041f] has been reserved
[    0.257378] system 00:08: [io  0x0420-0x043f] has been reserved
[    0.257416] system 00:08: [io  0x0440-0x045f] has been reserved
[    0.257454] system 00:08: [io  0x0460-0x047f] has been reserved
[    0.257492] system 00:08: [io  0x0480-0x048f] has been reserved
[    0.257529] system 00:08: [io  0xf800-0xf81f] has been reserved
[    0.257567] system 00:08: [io  0xf820-0xf83f] has been reserved
[    0.257605] system 00:08: [io  0xf840-0xf85f] has been reserved
[    0.257643] system 00:08: [io  0xf860-0xf87f] has been reserved
[    0.257680] system 00:08: [io  0xfa00-0xfa3f] has been reserved
[    0.257717] system 00:08: [io  0xfc00-0xfc7f] has been reserved
[    0.257755] system 00:08: [io  0xfc80-0xfcff] has been reserved
[    0.257792] system 00:08: [io  0xfe00-0xfe7f] has been reserved
[    0.257830] system 00:08: [io  0xfe80-0xfeff] has been reserved
[    0.257869] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.259619] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.259660] system 00:09: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.259700] system 00:09: [mem 0x000e4000-0x000fffff] could not be reserved
[    0.259740] system 00:09: [mem 0xfec01000-0xfecfffff] has been reserved
[    0.259779] system 00:09: [mem 0xfed00400-0xfed3ffff] has been reserved
[    0.259818] system 00:09: [mem 0xfed45000-0xffffffff] has been reserved
[    0.259858] system 00:09: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.259898] system 00:09: [mem 0x000cfe00-0x000e3fff] has been reserved
[    0.259938] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.259946] pnp: PnP ACPI: found 10 devices
[    0.265700] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 18] add_size 1000
[    0.265703] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 18] add_size 200000
[    0.265704] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 18] add_size 200000
[    0.265710] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 24] add_size 1000
[    0.265711] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 24] add_size 200000
[    0.265713] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 24] add_size 200000
[    0.265718] pci 0000:00:1c.6: bridge window [io  0x1000-0x0fff] to [bus 30] add_size 1000
[    0.265720] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 30] add_size 200000
[    0.265721] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff] to [bus 30] add_size 200000
[    0.265729] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.265731] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.265732] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.265733] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.265735] pci 0000:00:1c.6: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.265736] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.265737] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.265739] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.265740] pci 0000:00:1c.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.265743] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf8000000-0xf81fffff]
[    0.265785] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.265846] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf8400000-0xf85fffff]
[    0.265888] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.265949] pci 0000:00:1c.6: BAR 14: assigned [mem 0xf8800000-0xf89fffff]
[    0.265991] pci 0000:00:1c.6: BAR 15: assigned [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.266052] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.266092] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.266131] pci 0000:00:1c.6: BAR 13: assigned [io  0x4000-0x4fff]
[    0.266171] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.266207] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.266247] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf81fffff]
[    0.266288] pci 0000:00:1c.0:   bridge window [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.266351] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.266387] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.266427] pci 0000:00:1c.4:   bridge window [mem 0xf8400000-0xf85fffff]
[    0.266469] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.266532] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.266567] pci 0000:00:1c.6:   bridge window [io  0x4000-0x4fff]
[    0.266608] pci 0000:00:1c.6:   bridge window [mem 0xf8800000-0xf89fffff]
[    0.266649] pci 0000:00:1c.6:   bridge window [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.266713] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    0.266755] pci_bus 0000:00: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.266757] pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
[    0.266758] pci_bus 0000:00: resource 6 [io  0x1000-0x2fff]
[    0.266759] pci_bus 0000:00: resource 7 [io  0x3000-0x6fff]
[    0.266760] pci_bus 0000:00: resource 8 [io  0x7000-0xafff]
[    0.266761] pci_bus 0000:00: resource 9 [io  0xb000-0xffff]
[    0.266762] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    0.266764] pci_bus 0000:00: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.266765] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.266766] pci_bus 0000:18: resource 0 [io  0x2000-0x2fff]
[    0.266767] pci_bus 0000:18: resource 1 [mem 0xf8000000-0xf81fffff]
[    0.266768] pci_bus 0000:18: resource 2 [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.266770] pci_bus 0000:24: resource 0 [io  0x3000-0x3fff]
[    0.266771] pci_bus 0000:24: resource 1 [mem 0xf8400000-0xf85fffff]
[    0.266772] pci_bus 0000:24: resource 2 [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.266773] pci_bus 0000:30: resource 0 [io  0x4000-0x4fff]
[    0.266774] pci_bus 0000:30: resource 1 [mem 0xf8800000-0xf89fffff]
[    0.266776] pci_bus 0000:30: resource 2 [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.266777] pci_bus 0000:0d: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.266778] pci_bus 0000:0d: resource 5 [io  0x0000-0x0cf7]
[    0.266779] pci_bus 0000:0d: resource 6 [io  0x1000-0x2fff]
[    0.266780] pci_bus 0000:0d: resource 7 [io  0x3000-0x6fff]
[    0.266781] pci_bus 0000:0d: resource 8 [io  0x7000-0xafff]
[    0.266783] pci_bus 0000:0d: resource 9 [io  0xb000-0xffff]
[    0.266784] pci_bus 0000:0d: resource 10 [mem 0x000a0000-0x000bffff]
[    0.266785] pci_bus 0000:0d: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.266786] pci_bus 0000:0d: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.266788] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.266789] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.266807] NET: Registered protocol family 2
[    0.266961] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.267067] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.267182] TCP: Hash tables configured (established 32768 bind 32768)
[    0.267242] TCP: reno registered
[    0.267274] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.267324] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.267411] NET: Registered protocol family 1
[    0.267456] pci 0000:00:02.0: Video device with shadowed ROM
[    0.267751] PCI: CLS 64 bytes, default 64
[    0.267766] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.267805] software IO TLB [mem 0xd77ac000-0xdb7ac000] (64MB) mapped at [ffff8800d77ac000-ffff8800db7abfff]
[    0.268216] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.268415] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.269472] VFS: Disk quotas dquot_6.5.2
[    0.269530] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.269767] msgmni has been set to 7503
[    0.269838] Key type big_key registered
[    0.270049] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.270112] io scheduler noop registered
[    0.270145] io scheduler deadline registered
[    0.270196] io scheduler cfq registered (default)
[    0.270581] intel_idle: MWAIT substates: 0x1120
[    0.270582] intel_idle: v0.4 model 0x25
[    0.270583] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.270727] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.270791] ACPI: Power Button [PBTN]
[    0.270847] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.270907] ACPI: Power Button [PWRF]
[    0.270982] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.291404] serial 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.311947] serial 0000:00:16.3: ttyS1 at I/O 0x1188 (irq = 17, base_baud = 115200) is a 16550A
[    0.312121] Linux agpgart interface v0.103
[    0.312180] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.312228] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.312829] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.312989] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.313063] [drm] Initialized drm 1.1.0 20060810
[    0.313420] [drm:i915_dump_device_info] i915 device info: gen=5, pciid=0x0042 rev=0x02 flags=need_gfx_hws,has_hotplug,
[    0.313432] [drm:intel_detect_pch] Found Ibex Peak PCH
[    0.313435] [drm] Memory usable by graphics device = 2048M
[    0.313472] [drm:i915_gem_gtt_init] GMADR size = 256M
[    0.313473] [drm:i915_gem_gtt_init] GTT stolen size = 32M
[    0.313474] [drm:i915_gem_gtt_init] ppgtt mode: 0
[    0.313475] [drm] Replacing VGA console driver
[    0.313882] Console: switching to colour dummy device 80x25
[    0.314142] [drm:intel_opregion_setup] graphic opregion physical addr: 0xdb7ac440
[    0.314145] [drm:intel_opregion_setup] SWSCI supported
[    0.328592] [drm:swsci] SWSCI request error 2
[    0.328593] [drm:swsci_setup] SWSCI GBDA callbacks 00000081, SBCB callbacks 00000001
[    0.328651] i915 0000:00:02.0: irq 24 for MSI/MSI-X
[    0.328655] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.328657] [drm] Driver supports precise vblank timestamp query.
[    0.328660] [drm:init_vbt_defaults] Set default to SSC at 120000 kHz
[    0.328661] [drm:validate_vbt] Using VBT from OpRegion: $VBT IRONLAKE-DESK  d
[    0.328663] [drm:parse_general_features] BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120000 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    0.328665] [drm:parse_general_definitions] crt_ddc_bus_pin: 2
[    0.328666] [drm:parse_lfp_panel_data] DRRS supported mode is seamless
[    0.328668] [drm:parse_lfp_panel_data] Found panel mode in BIOS VBT tables:
[    0.328670] [drm:drm_mode_debug_printmodeline] Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    0.328671] [drm:parse_lfp_panel_data] VBT initial LVDS value 300
[    0.328673] [drm:parse_lfp_backlight] VBT backlight PWM modulation frequency 200 Hz, active low, min brightness 0, level 0
[    0.328674] [drm:parse_sdvo_panel_data] Found SDVO panel mode in BIOS VBT tables:
[    0.328676] [drm:drm_mode_debug_printmodeline] Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    0.328677] [drm:parse_sdvo_device_mapping] No SDVO device info is found in VBT
[    0.328679] [drm:parse_driver_features] DRRS State Enabled:0
[    0.328684] [drm:intel_dsm_pci_probe] no _DSM method for intel device
[    0.328687] [drm:i915_gem_init_stolen] found 33554432 bytes of stolen memory at de000000
[    0.328690] [drm:intel_display_power_get] enabling always-on
[    0.328723] [drm:intel_print_wm_latency] Primary WM0 latency 7 (0.7 usec)
[    0.328724] [drm:intel_print_wm_latency] Primary WM1 latency 19 (9.5 usec)
[    0.328725] [drm:intel_print_wm_latency] Primary WM2 latency 43 (21.5 usec)
[    0.328726] [drm:intel_print_wm_latency] Sprite WM0 latency 13 (1.3 usec)
[    0.328727] [drm:intel_print_wm_latency] Sprite WM1 latency 19 (9.5 usec)
[    0.328728] [drm:intel_print_wm_latency] Sprite WM2 latency 43 (21.5 usec)
[    0.328729] [drm:intel_print_wm_latency] Cursor WM0 latency 13 (1.3 usec)
[    0.328730] [drm:intel_print_wm_latency] Cursor WM1 latency 19 (9.5 usec)
[    0.328731] [drm:intel_print_wm_latency] Cursor WM2 latency 43 (21.5 usec)
[    0.328733] [drm:intel_modeset_init] 2 display pipes available.
[    0.328743] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.329074] [drm:intel_crt_reset] pch crt adpa set to 0xf40000
[    0.329101] [drm:intel_dp_init_connector] Adding DP connector on port C
[    0.329118] [drm:intel_dp_aux_init] registering DPDDC-C bus for card0-DP-1
[    0.329132] [drm:ironlake_init_pch_refclk] has_panel 0 has_lvds 0 has_ck505 0
[    0.329134] [drm:ironlake_init_pch_refclk] Disabling SSC entirely
[    0.329547] [drm:intel_modeset_readout_hw_state] [CRTC:8] hw state readout: enabled
[    0.329548] [drm:intel_modeset_readout_hw_state] [CRTC:12] hw state readout: disabled
[    0.329552] [drm:intel_modeset_readout_hw_state] PCH DPLL A hw state readout: refcount 1, on 1
[    0.329555] [drm:intel_modeset_readout_hw_state] PCH DPLL B hw state readout: refcount 0, on 0
[    0.329557] [drm:intel_modeset_readout_hw_state] [ENCODER:15:DAC-15] hw state readout: disabled, pipe A
[    0.329559] [drm:intel_modeset_readout_hw_state] [ENCODER:16:TMDS-16] hw state readout: disabled, pipe A
[    0.329566] [drm:intel_modeset_readout_hw_state] [ENCODER:21:TMDS-21] hw state readout: enabled, pipe A
[    0.329568] [drm:intel_modeset_readout_hw_state] [CONNECTOR:14:VGA-1] hw state readout: disabled
[    0.329570] [drm:intel_modeset_readout_hw_state] [CONNECTOR:17:HDMI-A-1] hw state readout: disabled
[    0.329571] [drm:intel_modeset_readout_hw_state] [CONNECTOR:22:DP-1] hw state readout: enabled
[    0.329574] [drm:intel_dump_pipe_config] [CRTC:8][setup_hw_state] config for pipe A
[    0.329575] [drm:intel_dump_pipe_config] cpu_transcoder: A
[    0.329576] [drm:intel_dump_pipe_config] pipe bpp: 24, dithering: 0
[    0.329577] [drm:intel_dump_pipe_config] fdi/pch: 1, lanes: 4, gmch_m: 586736, gmch_n: 8388608, link_m: 48894, link_n: 524288, tu: 64
[    0.329579] [drm:intel_dump_pipe_config] dp: 1, gmch_m: 977894, gmch_n: 8388608, link_m: 81491, link_n: 524288, tu: 64
[    0.329580] [drm:intel_dump_pipe_config] dp: 1, gmch_m2: 0, gmch_n2: 0, link_m2: 0, link_n2: 0, tu2: 0
[    0.329581] [drm:intel_dump_pipe_config] requested mode:
[    0.329582] [drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 720 0 0 0 400 0 0 0 0x0 0x0
[    0.329583] [drm:intel_dump_pipe_config] adjusted mode:
[    0.329584] [drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    0.329586] [drm:intel_dump_crtc_timings] crtc timings: 25179 640 656 752 800 480 490 492 525, type: 0x0 flags: 0xa
[    0.329587] [drm:intel_dump_pipe_config] port clock: 162000
[    0.329588] [drm:intel_dump_pipe_config] pipe src size: 720x400
[    0.329589] [drm:intel_dump_pipe_config] gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    0.329590] [drm:intel_dump_pipe_config] pch pfit: pos: 0x00000000, size: 0x028001e0, enabled
[    0.329591] [drm:intel_dump_pipe_config] ips: 0
[    0.329591] [drm:intel_dump_pipe_config] double wide: 0
[    0.329593] [drm:i915_get_vblank_timestamp] crtc 1 is disabled
[    0.329595] [drm:gm45_get_vblank_counter] trying to get vblank count for disabled pipe B
[    0.329596] [drm:i915_get_vblank_timestamp] crtc 1 is disabled
[    0.329597] [drm:gm45_get_vblank_counter] trying to get vblank count for disabled pipe B
[    0.329598] [drm:intel_dump_pipe_config] [CRTC:12][setup_hw_state] config for pipe B
[    0.329599] [drm:intel_dump_pipe_config] cpu_transcoder: B
[    0.329600] [drm:intel_dump_pipe_config] pipe bpp: 0, dithering: 0
[    0.329601] [drm:intel_dump_pipe_config] fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.329602] [drm:intel_dump_pipe_config] dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    0.329603] [drm:intel_dump_pipe_config] dp: 0, gmch_m2: 0, gmch_n2: 0, link_m2: 0, link_n2: 0, tu2: 0
[    0.329604] [drm:intel_dump_pipe_config] requested mode:
[    0.329606] [drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.329606] [drm:intel_dump_pipe_config] adjusted mode:
[    0.329608] [drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.329609] [drm:intel_dump_crtc_timings] crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
[    0.329610] [drm:intel_dump_pipe_config] port clock: 0
[    0.329611] [drm:intel_dump_pipe_config] pipe src size: 0x0
[    0.329612] [drm:intel_dump_pipe_config] gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    0.329613] [drm:intel_dump_pipe_config] pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    0.329613] [drm:intel_dump_pipe_config] ips: 0
[    0.329614] [drm:intel_dump_pipe_config] double wide: 0
[    0.329620] [drm:intel_connector_check_state] [CONNECTOR:22:DP-1]
[    0.329622] [drm:check_encoder_state] [ENCODER:15:DAC-15]
[    0.329624] [drm:check_encoder_state] [ENCODER:16:TMDS-16]
[    0.329626] [drm:check_encoder_state] [ENCODER:21:TMDS-21]
[    0.329627] [drm:check_crtc_state] [CRTC:8]
[    0.329646] [drm:check_crtc_state] [CRTC:12]
[    0.329647] [drm:check_shared_dpll_state] PCH DPLL A
[    0.329650] [drm:check_shared_dpll_state] PCH DPLL B
[    0.329657] [drm:ironlake_get_plane_config] pipe/plane 0/0 with fb: size=720x400@32, offset=0, pitch 0, size 0x0
[    0.329659] [drm:i915_gem_setup_global_gtt] clearing unused GTT space: [0, 7ffff000]
[    0.331096] [drm:i915_gem_context_init] fake context support initialized
[    0.331112] [drm:init_status_page] render ring hws offset: 0x00001000
[    0.331114] [drm:i915_gem_object_create_stolen] creating stolen object: size=20000
[    0.331116] [drm:i915_pages_create_for_stolen] offset=0x0, size=131072
[    0.331133] [drm:intel_init_pipe_control] render ring pipe control offset: 0x00024000
[    0.331137] [drm:init_status_page] bsd ring hws offset: 0x00025000
[    0.331138] [drm:i915_gem_object_create_stolen] creating stolen object: size=20000
[    0.331139] [drm:i915_pages_create_for_stolen] offset=0x20000, size=131072
[    0.331205] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20140828/video-1197)
[    0.331210] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[    0.331259] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1]
[    0.331262] [drm:intel_crt_detect] [CONNECTOR:14:VGA-1] force=1
[    0.331265] [drm:intel_ironlake_crt_detect_hotplug] trigger hotplug detect cycle: adpa=0xf40000
[    0.331274] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    0.331288] [drm] Initialized i915 1.6.0 20140905 for 0000:00:02.0 on minor 0
[    0.331425] mei_me 0000:00:16.0: irq 25 for MSI/MSI-X
[    0.334921] ahci 0000:00:1f.2: version 3.0
[    0.335044] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    0.335090] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x17 impl SATA mode
[    0.335094] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part sxs apst 
[    0.335939] scsi host0: ahci
[    0.336126] scsi host1: ahci
[    0.336222] scsi host2: ahci
[    0.336299] scsi host3: ahci
[    0.336368] scsi host4: ahci
[    0.336436] scsi host5: ahci
[    0.336468] ata1: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426100 irq 26
[    0.336471] ata2: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426180 irq 26
[    0.336474] ata3: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426200 irq 26
[    0.336476] ata4: DUMMY
[    0.336478] ata5: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426300 irq 26
[    0.336480] ata6: DUMMY
[    0.336533] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.338793] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.338801] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.338903] mousedev: PS/2 mouse device common for all mice
[    0.338927] rtc_cmos 00:00: RTC can wake from S4
[    0.339038] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.339064] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.339121] TCP: cubic registered
[    0.339194] NET: Registered protocol family 10
[    0.339365] mip6: Mobile IPv6
[    0.339369] NET: Registered protocol family 17
[    0.339379] Key type dns_resolver registered
[    0.339643] registered taskstats version 1
[    0.339924] rtc_cmos 00:00: setting system clock to 2014-10-23 12:57:57 UTC (1414069077)
[    0.339964] PM: Hibernation image not present or could not be loaded.
[    0.344603] [drm:intel_ironlake_crt_detect_hotplug] ironlake hotplug adpa=0xf40000, result 0
[    0.344604] [drm:intel_crt_detect] CRT not detected via hotplug
[    0.344806] [drm:gmbus_xfer] GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    0.344811] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[    0.344813] [drm:intel_crt_get_edid] CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    0.344816] [drm:intel_gmbus_force_bit] enabling bit-banging on i915 gmbus vga. force bit now 1
[    0.345166] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[    0.345167] [drm:intel_gmbus_force_bit] disabling bit-banging on i915 gmbus vga. force bit now 0
[    0.345168] [drm:intel_crt_detect_ddc] CRT not detected via DDC:0x50 [no valid EDID found]
[    0.345170] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1] disconnected
[    0.345171] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1]
[    0.345172] [drm:intel_hdmi_detect] [CONNECTOR:17:HDMI-A-1]
[    0.345377] [drm:gmbus_xfer] GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    0.345382] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus dpc
[    0.345386] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1] disconnected
[    0.345389] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1]
[    0.345392] [drm:intel_dp_detect] [CONNECTOR:22:DP-1]
[    0.345666] [drm:intel_dp_get_dpcd] DPCD: 11 06 84 01 00 00 01 00 02 02 06 00 00 00 00
[    0.365941] [drm:drm_edid_to_eld] ELD: no CEA Extension found
[    0.365945] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1] probed modes :
[    0.365948] [drm:drm_mode_debug_printmodeline] Modeline 24:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.365949] [drm:drm_mode_debug_printmodeline] Modeline 28:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    0.365951] [drm:drm_mode_debug_printmodeline] Modeline 26:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    0.365953] [drm:drm_mode_debug_printmodeline] Modeline 27:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[    0.365954] [drm:drm_mode_debug_printmodeline] Modeline 25:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[    0.365956] [drm:drm_mode_debug_printmodeline] Modeline 32:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    0.365958] [drm:drm_mode_debug_printmodeline] Modeline 29:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    0.365959] [drm:drm_mode_debug_printmodeline] Modeline 30:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    0.365961] [drm:drm_mode_debug_printmodeline] Modeline 31:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    0.365962] [drm:drm_setup_crtcs] 
[    0.365963] [drm:drm_enable_connectors] connector 14 enabled? no
[    0.365964] [drm:drm_enable_connectors] connector 17 enabled? no
[    0.365965] [drm:drm_enable_connectors] connector 22 enabled? yes
[    0.365966] [drm:intel_fb_initial_config] connector VGA-1 not enabled, skipping
[    0.365967] [drm:intel_fb_initial_config] connector HDMI-A-1 not enabled, skipping
[    0.365969] [drm:intel_fb_initial_config] looking for cmdline mode on connector DP-1
[    0.365969] [drm:intel_fb_initial_config] looking for preferred mode on connector DP-1
[    0.365971] [drm:intel_fb_initial_config] connector DP-1 on pipe A [CRTC:8]: 1920x1080
[    0.365972] [drm:drm_setup_crtcs] desired mode 1920x1080 set on crtc 8
[    0.365974] [drm:intelfb_create] no BIOS fb, allocating a new one
[    0.365975] [drm:i915_gem_object_create_stolen] creating stolen object: size=7e9000
[    0.365977] [drm:i915_pages_create_for_stolen] offset=0x40000, size=8294400
[    0.367551] [drm:intelfb_create] allocated 1920x1080 fb: 0x00047000, bo ffff8801118ac000
[    0.367619] fbcon: inteldrmfb (fb0) is primary device
[    0.367686] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[    0.367689] [drm:intel_set_config_compute_mode_changes] crtc has no fb, will flip
[    0.367690] [drm:intel_set_config_compute_mode_changes] modes are different, full mode set
[    0.367694] [drm:drm_mode_debug_printmodeline] Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.367697] [drm:drm_mode_debug_printmodeline] Modeline 33:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.367699] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=1, fb_changed=1
[    0.367702] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[    0.367705] [drm:intel_modeset_affected_pipes] set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    0.367707] [drm:connected_sink_compute_bpp] [CONNECTOR:22:DP-1] checking for sink bpp constrains
[    0.367710] [drm:intel_dp_compute_config] DP link computation with max lane count 4 max bw 06 pixel clock 148500KHz
[    0.367716] [drm:intel_dp_compute_config] DP link bw 06 lane count 4 clock 162000 bpp 24
[    0.367716] [drm:intel_dp_compute_config] DP link bw required 356400 available 518400
[    0.367718] [drm:ironlake_check_fdi_lanes] checking fdi config on pipe A, lanes 2
[    0.367719] [drm:intel_modeset_pipe_config] plane bpp: 24, pipe bpp: 24, dithering: 0
[    0.367720] [drm:intel_dump_pipe_config] [CRTC:8][modeset] config for pipe A
[    0.367720] [drm:intel_dump_pipe_config] cpu_transcoder: A
[    0.367720] [drm:intel_dump_pipe_config] pipe bpp: 24, dithering: 0
[    0.367721] [drm:intel_dump_pipe_config] fdi/pch: 1, lanes: 2, gmch_m: 6920601, gmch_n: 8388608, link_m: 288358, link_n: 524288, tu: 64
[    0.367722] [drm:intel_dump_pipe_config] dp: 1, gmch_m: 5767168, gmch_n: 8388608, link_m: 240298, link_n: 262144, tu: 64
[    0.367723] [drm:intel_dump_pipe_config] dp: 1, gmch_m2: 0, gmch_n2: 0, link_m2: 0, link_n2: 0, tu2: 0
[    0.367723] [drm:intel_dump_pipe_config] requested mode:
[    0.367724] [drm:drm_mode_debug_printmodeline] Modeline 0:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.367725] [drm:intel_dump_pipe_config] adjusted mode:
[    0.367726] [drm:drm_mode_debug_printmodeline] Modeline 0:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.367727] [drm:intel_dump_crtc_timings] crtc timings: 148500 1920 2008 2052 2200 1080 1084 1089 1125, type: 0x48 flags: 0x5
[    0.367727] [drm:intel_dump_pipe_config] port clock: 162000
[    0.367728] [drm:intel_dump_pipe_config] pipe src size: 1920x1080
[    0.367729] [drm:intel_dump_pipe_config] gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    0.367729] [drm:intel_dump_pipe_config] pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    0.367730] [drm:intel_dump_pipe_config] ips: 0
[    0.367730] [drm:intel_dump_pipe_config] double wide: 0
[    0.476654] ------------[ cut here ]------------
[    0.476663] WARNING: CPU: 0 PID: 6 at drivers/gpu/drm/i915/intel_display.c:997 ironlake_crtc_disable+0x8d/0x7b0()
[    0.476663] pipe_off wait timed out
[    0.476665] Modules linked in:
[    0.476669] CPU: 0 PID: 6 Comm: kworker/u16:0 Not tainted 3.18.0-rc1-00221-gc3351df #150
[    0.476670] Hardware name: Hewlett-Packard HP Compaq 8100 Elite SFF PC/304Ah, BIOS 786H1 v01.13 07/14/2011
[    0.476676] Workqueue: events_unbound async_run_entry_fn
[    0.476679]  0000000000000000 0000000000000009 ffffffff81538f84 ffff880111c53878
[    0.476681]  ffffffff8104676d ffff8800d71f0000 ffff880111e41800 0000000000000000
[    0.476683]  ffff880111e41b28 ffff880111e41b30 ffffffff810467d5 ffffffff81754e9e
[    0.476684] Call Trace:
[    0.476690]  [<ffffffff81538f84>] ? dump_stack+0x41/0x51
[    0.476694]  [<ffffffff8104676d>] ? warn_slowpath_common+0x6d/0x90
[    0.476697]  [<ffffffff810467d5>] ? warn_slowpath_fmt+0x45/0x50
[    0.476700]  [<ffffffff813757bd>] ? ironlake_crtc_disable+0x8d/0x7b0
[    0.476704]  [<ffffffff8136fd02>] ? __intel_set_mode+0x7d2/0x16e0
[    0.476708]  [<ffffffff8137867d>] ? intel_set_mode+0xd/0x30
[    0.476712]  [<ffffffff8137975c>] ? intel_crtc_set_config+0xa7c/0xe60
[    0.476717]  [<ffffffff813096e9>] ? drm_mode_set_config_internal+0x59/0xe0
[    0.476722]  [<ffffffff812f8b34>] ? restore_fbdev_mode+0xc4/0xe0
[    0.476725]  [<ffffffff812f8b6d>] ? drm_fb_helper_restore_fbdev_mode_unlocked+0x1d/0x30
[    0.476728]  [<ffffffff812fa551>] ? drm_fb_helper_set_par+0x21/0x70
[    0.476732]  [<ffffffff81383e51>] ? intel_fbdev_set_par+0x11/0x60
[    0.476737]  [<ffffffff8127fd10>] ? fbcon_init+0x590/0x620
[    0.476741]  [<ffffffff812d4c9c>] ? visual_init+0xac/0x110
[    0.476744]  [<ffffffff812d70a4>] ? do_bind_con_driver+0x174/0x3c0
[    0.476747]  [<ffffffff812d7873>] ? do_take_over_console+0xa3/0x190
[    0.476751]  [<ffffffff8127b68b>] ? do_fbcon_takeover+0x5b/0xc0
[    0.476754]  [<ffffffff810609b5>] ? notifier_call_chain+0x45/0x70
[    0.476757]  [<ffffffff81060c5c>] ? __blocking_notifier_call_chain+0x3c/0x60
[    0.476761]  [<ffffffff81287f26>] ? register_framebuffer+0x1f6/0x320
[    0.476764]  [<ffffffff812fa7fd>] ? drm_fb_helper_initial_config+0x25d/0x3c0
[    0.476767]  [<ffffffff81061f7d>] ? async_run_entry_fn+0x2d/0xe0
[    0.476771]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
[    0.476778]  [<ffffffff81096457>] ? try_to_del_timer_sync+0x47/0x60
[    0.476779]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
[    0.476780]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
[    0.476781]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
[    0.476782]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
[    0.476783]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[    0.476785]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
[    0.476786]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[    0.476787] ---[ end trace d239a2c32f37d2ca ]---
[    0.476789] [drm:intel_dp_link_down] 
[    0.544680] [drm:ironlake_disable_pch_transcoder] *ERROR* failed to disable transcoder A
[    0.544685] [drm:intel_disable_shared_dpll] disable PCH DPLL A (active 1, on? 1) for crtc 8
[    0.544689] [drm:intel_disable_shared_dpll] disabling PCH DPLL A
[    0.545107] [drm:intel_get_shared_dpll] CRTC:8 dropping existing PCH DPLL A
[    0.545107] [drm:intel_get_shared_dpll] CRTC:8 using pre-allocated PCH DPLL A
[    0.545108] [drm:intel_get_shared_dpll] using PCH DPLL A for pipe A
[    0.545109] [drm:intel_prepare_shared_dpll] setting up PCH DPLL A
[    0.545942] [drm:ironlake_fdi_link_train] FDI_RX_IIR 0x700
[    0.545943] [drm:ironlake_fdi_link_train] FDI train 1 done.
[    0.546096] [drm:ironlake_fdi_link_train] FDI_RX_IIR 0x600
[    0.546098] [drm:ironlake_fdi_link_train] FDI train 2 done.
[    0.546098] [drm:ironlake_fdi_link_train] FDI train done
[    0.546099] [drm:intel_enable_shared_dpll] enable PCH DPLL A (active 0, on? 0) for crtc 8
[    0.546099] [drm:intel_enable_shared_dpll] enabling PCH DPLL A
[    0.546337] [drm:ibx_irq_handler] *ERROR* PCH transcoder A FIFO underrun
[    0.547934] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.548413] [drm:intel_dp_set_signal_levels] Using signal levels 02000000
[    0.548886] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.549354] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.549834] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.550297] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.550776] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.551240] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.551717] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.552182] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.552660] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.553125] [drm:intel_dp_start_link_train] *ERROR* too many full retries, give up
[    0.554212] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.554686] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.555151] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.555627] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.556091] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.556567] [drm:intel_dp_set_signal_levels] Using signal levels 02000000
[    0.557034] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.557502] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.557978] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.558447] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.558922] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.559391] [drm:intel_dp_start_link_train] *ERROR* too many full retries, give up
[    0.560480] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.560956] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.561425] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.561898] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.562365] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.562838] [drm:intel_dp_set_signal_levels] Using signal levels 02000000
[    0.563305] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.563771] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.564248] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.564713] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.565189] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.565653] [drm:intel_dp_start_link_train] *ERROR* too many full retries, give up
[    0.566740] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.567216] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.567682] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.568159] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.568622] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.569099] [drm:intel_dp_set_signal_levels] Using signal levels 02000000
[    0.569565] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.570034] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.570508] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.570978] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.571453] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.571921] [drm:intel_dp_start_link_train] *ERROR* too many full retries, give up
[    0.573010] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.573485] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.573953] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.574429] [drm:intel_dp_set_signal_levels] Using signal levels 04400000
[    0.574897] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.575373] [drm:intel_dp_set_signal_levels] Using signal levels 02000000
[    0.575841] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.576308] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.576786] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.577250] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.577725] [drm:intel_dp_set_signal_levels] Using signal levels 04000000
[    0.578189] [drm:intel_dp_start_link_train] *ERROR* too many full retries, give up
[    0.579275] [drm:intel_dp_set_signal_levels] Using signal levels 00000000
[    0.579747] [drm:intel_dp_start_link_train] clock recovery OK
[    0.580519] [drm:intel_dp_complete_link_train] Channel EQ done. DP Training successful
[    0.580676] [drm:ironlake_update_primary_plane] Writing base 00047000 00000000 0 0 7680
[    0.580683] [drm:intel_connector_check_state] [CONNECTOR:22:DP-1]
[    0.580684] [drm:check_encoder_state] [ENCODER:15:DAC-15]
[    0.580686] [drm:check_encoder_state] [ENCODER:16:TMDS-16]
[    0.580687] [drm:check_encoder_state] [ENCODER:21:TMDS-21]
[    0.580688] [drm:check_crtc_state] [CRTC:8]
[    0.580704] [drm:check_crtc_state] [CRTC:12]
[    0.580704] [drm:check_shared_dpll_state] PCH DPLL A
[    0.580707] [drm:check_shared_dpll_state] PCH DPLL B
[    0.580710] [drm:intel_crtc_set_config] [CRTC:12] [NOFB]
[    0.580711] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:12], mode_changed=0, fb_changed=0
[    0.580712] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[    0.580736] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[    0.580737] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[    0.580737] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[    0.584511] Console: switching to colour frame buffer device 240x67
[    0.584513] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[    0.584514] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[    0.584515] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[    0.601568] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    0.602784] i915 0000:00:02.0: registered panic notifier
[    0.652753] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.654482] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.656744] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    0.658395] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    0.660043] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    0.661643] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    0.663261] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.664862] ata2.00: ATAPI: hp       CDDVDW TS-H653T, H6D1, max UDMA/100
[    0.666483] ata3: SATA link down (SStatus 0 SControl 300)
[    0.667742] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    0.667764] ata5: SATA link down (SStatus 0 SControl 300)
[    0.669039] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    0.669042] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.670400] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.672003] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.673686] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    0.675023] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    0.676580] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.678110] ata2.00: configured for UDMA/100
[    0.679939] ata1.00: ATA-8: Hitachi HDS721025CLA682, JP1OA41A, max UDMA/133
[    0.681580] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.684267] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    0.685450] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    0.686816] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    0.687080] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    0.687085] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.688277] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.689423] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    0.691654] ata1.00: configured for UDMA/133
[    0.692946] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72102 A41A PQ: 0 ANSI: 5
[    0.694206] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    0.695452] sd 0:0:0:0: [sda] Write Protect is off
[    0.695757] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-H653T  H6D1 PQ: 0 ANSI: 5
[    0.697838] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.697846] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.742235]  sda: sda1 sda2 < sda5 >
[    0.743959] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.775280] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
[    0.776817] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
[    0.814809] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    0.816045] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    0.859525] devtmpfs: mounted
[    0.861350] Freeing unused kernel memory: 796K (ffffffff81875000 - ffffffff8193c000)
[    0.862606] Write protecting the kernel read-only data: 8192k
[    0.865094] Freeing unused kernel memory: 744K (ffff880001546000 - ffff880001600000)
[    0.866919] Freeing unused kernel memory: 336K (ffff8800017ac000 - ffff880001800000)
[    1.264826] tsc: Refined TSC clocksource calibration: 3325.374 MHz
[    1.692753] random: systemd urandom read with 16 bits of entropy available
[    1.708313] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[    1.709790] systemd[1]: Detected architecture 'x86-64'.
[    2.060589] systemd[1]: Inserted module 'autofs4'
[    2.078928] systemd[1]: Set hostname to <prometheus>.
[    2.265146] Switched to clocksource tsc
[    4.445759] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[    4.447436] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    4.448897] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    4.450328] systemd[1]: Starting Remote File Systems (Pre).
[    4.453289] systemd[1]: Reached target Remote File Systems (Pre).
[    4.454707] systemd[1]: Starting Encrypted Volumes.
[    4.457595] systemd[1]: Reached target Encrypted Volumes.
[    4.459012] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    4.462069] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    4.463569] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    4.465070] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    4.466555] systemd[1]: Starting Paths.
[    4.469563] systemd[1]: Reached target Paths.
[    4.471036] systemd[1]: Expecting device dev-sda5.device...
[    4.474041] systemd[1]: Starting Root Slice.
[    4.482792] systemd[1]: Created slice Root Slice.
[    4.484275] systemd[1]: Starting User and Session Slice.
[    4.487422] systemd[1]: Created slice User and Session Slice.
[    4.488911] systemd[1]: Starting Delayed Shutdown Socket.
[    4.491925] systemd[1]: Listening on Delayed Shutdown Socket.
[    4.493389] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    4.496439] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    4.497947] systemd[1]: Starting Journal Socket (/dev/log).
[    4.500993] systemd[1]: Listening on Journal Socket (/dev/log).
[    4.502489] systemd[1]: Starting Syslog Socket.
[    4.505510] systemd[1]: Listening on Syslog Socket.
[    4.506992] systemd[1]: Starting udev Control Socket.
[    4.509982] systemd[1]: Listening on udev Control Socket.
[    4.511435] systemd[1]: Starting udev Kernel Socket.
[    4.514354] systemd[1]: Listening on udev Kernel Socket.
[    4.515784] systemd[1]: Starting Journal Socket.
[    4.518654] systemd[1]: Listening on Journal Socket.
[    4.520041] systemd[1]: Starting System Slice.
[    4.522945] systemd[1]: Created slice System Slice.
[    4.524323] systemd[1]: Starting File System Check on Root Device...
[    4.527403] systemd[1]: Starting system-getty.slice.
[    4.530348] systemd[1]: Created slice system-getty.slice.
[    4.531714] systemd[1]: Starting Nameserver information manager...
[    4.733541] systemd[1]: Started Set Up Additional Binary Formats.
[    4.735001] systemd[1]: Mounting Debug File System...
[    4.738176] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    4.741154] systemd[1]: Mounting POSIX Message Queue File System...
[    4.952269] systemd[1]: Starting Load Kernel Modules...
[    4.955404] systemd[1]: Starting udev Coldplug all Devices...
[    4.958417] systemd[1]: Mounting Huge Pages File System...
[    4.961271] systemd[1]: Starting LSB: Set keymap...
[    4.964483] systemd[1]: Starting Journal Service...
[    4.968867] systemd[1]: Started Journal Service.
[    5.495916] lp: driver loaded but no devices found
[    5.534711] parport_pc 00:03: reported by Plug and Play ACPI
[    5.535990] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[    5.633869] lp0: using parport0 (interrupt-driven).
[    5.733449] fuse init (API version 7.23)
[    5.959444] loop: module loaded
[    6.113403] systemd-udevd[140]: starting version 215
[    7.587471] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    7.607691] systemd-journald[116]: Received request to flush runtime journal from PID 1
[    8.085349] pps_core: LinuxPPS API ver. 1 registered
[    8.086753] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    8.095531] PTP clock support registered
[    8.146380] tpm_tis 00:05: 1.2 TPM (device-id 0xB, rev-id 16)
[    8.149048] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    8.169114] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    8.170426] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    8.171842] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    8.173167] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[    8.202252] wmi: Mapper loaded
[    8.346047] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.347425] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    8.357374] sr 1:0:0:0: [sr0] scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    8.358765] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.360235] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.363992] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 78:e3:b5:a0:e5:e4
[    8.365343] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    8.366718] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 9, PBA No: A002FF-0FF
[    8.394357] tpm_tis 00:05: TPM is disabled/deactivated (0x7)
[    8.462083] systemd-journald[116]: Received request to flush runtime journal from PID 1
[    8.560216] iTCO_vendor_support: vendor-support=0
[    8.588554] SSE version of gcm_enc/dec engaged.
[    8.642699] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    8.644081] iTCO_wdt: Found a Q57 TCO device (Version=2, TCOBASE=0xf860)
[    8.645459] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.681771] Error: Driver 'pcspkr' is already registered, aborting...
[    8.742078] ACPI: bus type USB registered
[    8.743480] usbcore: registered new interface driver usbfs
[    8.744877] usbcore: registered new interface driver hub
[    8.746377] usbcore: registered new device driver usb
[    8.751469] snd_hda_intel 0000:00:1b.0: irq 28 for MSI/MSI-X
[    8.796077] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    8.811166] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    8.826432] sound hdaudioC0D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    8.827778] sound hdaudioC0D0:    speaker_outs=1 (0x15/0x0/0x0/0x0/0x0)
[    8.829122] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    8.830519] sound hdaudioC0D0:    mono: mono_out=0x0
[    8.832360] sound hdaudioC0D0:    inputs:
[    8.834223] sound hdaudioC0D0:      Mic=0x19
[    8.836137] sound hdaudioC0D0:      Line=0x18
[    8.837532] ehci-pci: EHCI PCI platform driver
[    8.839028] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    8.840339] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    8.841651] ehci-pci 0000:00:1a.0: debug port 2
[    8.846875] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    8.846897] ehci-pci 0000:00:1a.0: irq 20, io mem 0xf0426800
[    8.858422] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    8.859842] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    8.861147] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.862497] usb usb1: Product: EHCI Host Controller
[    8.863800] usb usb1: Manufacturer: Linux 3.18.0-rc1-00221-gc3351df ehci_hcd
[    8.865092] usb usb1: SerialNumber: 0000:00:1a.0
[    8.866504] hub 1-0:1.0: USB hub found
[    8.867856] hub 1-0:1.0: 3 ports detected
[    8.869518] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    8.870868] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    8.872180] ehci-pci 0000:00:1d.0: debug port 2
[    8.877383] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    8.877388] ehci-pci 0000:00:1d.0: irq 20, io mem 0xf0426c00
[    8.894456] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    8.895888] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    8.897210] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.898511] usb usb2: Product: EHCI Host Controller
[    8.899790] usb usb2: Manufacturer: Linux 3.18.0-rc1-00221-gc3351df ehci_hcd
[    8.901083] usb usb2: SerialNumber: 0000:00:1d.0
[    8.902530] hub 2-0:1.0: USB hub found
[    8.904282] hub 2-0:1.0: 3 ports detected
[    8.912347] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    8.913703] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    8.915065] input: HDA Intel MID Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.916420] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.917787] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    9.178528] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    9.214520] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    9.310895] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    9.312185] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.313816] hub 1-1:1.0: USB hub found
[    9.315750] hub 1-1:1.0: 6 ports detected
[    9.342742] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input6
[    9.350891] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    9.353583] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.356987] hub 2-1:1.0: USB hub found
[    9.359765] hub 2-1:1.0: 8 ports detected
[    9.586681] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    9.678973] usb 1-1.1: New USB device found, idVendor=0424, idProduct=2512
[    9.680277] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.681747] hub 1-1.1:1.0: USB hub found
[    9.683583] hub 1-1.1:1.0: 2 ports detected
[    9.754723] usb 1-1.2: new low-speed USB device number 4 using ehci-pci
[    9.876491] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c30e
[    9.877722] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.878994] usb 1-1.2: Product: HID compliant keyboard
[    9.880234] usb 1-1.2: Manufacturer: Logitech
[   10.349158] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[   10.349161] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[   10.349162] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   10.493032] hidraw: raw HID events driver (C) Jiri Kosina
[   10.557816] usbcore: registered new interface driver usbhid
[   10.559119] usbhid: USB HID core driver
[   10.586350] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:046D:C30E.0001/input/input12
[   10.587727] hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input0
[   10.591510] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/0003:046D:C30E.0002/input/input13
[   10.592984] hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input1
[   11.109673] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[   11.114071] Adding 7532540k swap on /dev/sda5.  Priority:-1 extents:1 across:7532540k 
[   11.210984] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[   11.211079] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.080920] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   15.082220] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.520361] e1000e: eth0 NIC Link is Down
[   17.715245] random: nonblocking pool is initialized
[   18.693652] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   21.662075] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[   21.662078] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[   21.662079] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   22.424454] [drm:i915_gem_open] 
[   22.424496] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[   22.424499] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[   22.424501] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   22.424502] [drm:intel_crtc_set_config] [CRTC:12] [NOFB]
[   22.424504] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:12], mode_changed=0, fb_changed=0
[   22.424505] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.278238] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[   23.278241] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[   23.278243] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.284093] [drm:i915_gem_open] 
[   23.284108] [drm:drm_mode_getresources] CRTC[2] CONNECTORS[3] ENCODERS[3]
[   23.299241] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[   23.299249] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[   23.299253] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.299259] [drm:intel_crtc_set_config] [CRTC:12] [NOFB]
[   23.299261] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:12], mode_changed=0, fb_changed=0
[   23.299263] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.299326] [drm:i915_gem_open] 
[   23.299335] [drm:drm_mode_getresources] CRTC[2] CONNECTORS[3] ENCODERS[3]
[   23.299340] [drm:drm_mode_getresources] CRTC[2] CONNECTORS[3] ENCODERS[3]
[   23.299354] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[   23.299356] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[   23.299358] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.299360] [drm:intel_crtc_set_config] [CRTC:12] [NOFB]
[   23.299362] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:12], mode_changed=0, fb_changed=0
[   23.299364] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.322763] [drm:i915_gem_open] 
[   23.322783] [drm:intel_crtc_set_config] [CRTC:8] [FB:34] #connectors=1 (x y) (0 0)
[   23.322786] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=0
[   23.322788] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.322790] [drm:intel_crtc_set_config] [CRTC:12] [NOFB]
[   23.322791] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:12], mode_changed=0, fb_changed=0
[   23.322792] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.322798] [drm:i915_gem_open] 
[   23.323014] [drm:drm_mode_getresources] CRTC[2] CONNECTORS[3] ENCODERS[3]
[   23.323018] [drm:drm_mode_getresources] CRTC[2] CONNECTORS[3] ENCODERS[3]
[   23.323051] [drm:drm_mode_getconnector] [CONNECTOR:14:?]
[   23.323054] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1]
[   23.323056] [drm:intel_crt_detect] [CONNECTOR:14:VGA-1] force=1
[   23.323061] [drm:intel_ironlake_crt_detect_hotplug] ironlake hotplug adpa=0xf40000, result 0
[   23.323062] [drm:intel_crt_detect] CRT not detected via hotplug
[   23.323249] [drm:gmbus_xfer] GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   23.323251] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.323252] [drm:intel_crt_get_edid] CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   23.323253] [drm:intel_gmbus_force_bit] enabling bit-banging on i915 gmbus vga. force bit now 1
[   23.323597] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.323599] [drm:intel_gmbus_force_bit] disabling bit-banging on i915 gmbus vga. force bit now 0
[   23.323600] [drm:intel_crt_detect_ddc] CRT not detected via DDC:0x50 [no valid EDID found]
[   23.323601] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1] disconnected
[   23.323606] [drm:drm_mode_getconnector] [CONNECTOR:14:?]
[   23.323607] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1]
[   23.323608] [drm:intel_crt_detect] [CONNECTOR:14:VGA-1] force=1
[   23.323610] [drm:intel_ironlake_crt_detect_hotplug] ironlake hotplug adpa=0xf40000, result 0
[   23.323611] [drm:intel_crt_detect] CRT not detected via hotplug
[   23.323804] [drm:gmbus_xfer] GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   23.323806] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.323807] [drm:intel_crt_get_edid] CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   23.323808] [drm:intel_gmbus_force_bit] enabling bit-banging on i915 gmbus vga. force bit now 1
[   23.324144] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.324145] [drm:intel_gmbus_force_bit] disabling bit-banging on i915 gmbus vga. force bit now 0
[   23.324146] [drm:intel_crt_detect_ddc] CRT not detected via DDC:0x50 [no valid EDID found]
[   23.324147] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1] disconnected
[   23.324176] [drm:drm_mode_getconnector] [CONNECTOR:17:?]
[   23.324178] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1]
[   23.324179] [drm:intel_hdmi_detect] [CONNECTOR:17:HDMI-A-1]
[   23.324378] [drm:gmbus_xfer] GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   23.324381] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus dpc
[   23.324383] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1] disconnected
[   23.324389] [drm:drm_mode_getconnector] [CONNECTOR:17:?]
[   23.324392] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1]
[   23.324393] [drm:intel_hdmi_detect] [CONNECTOR:17:HDMI-A-1]
[   23.324558] [drm:gmbus_xfer] GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   23.324562] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus dpc
[   23.324566] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1] disconnected
[   23.324605] [drm:drm_mode_getconnector] [CONNECTOR:22:?]
[   23.324609] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1]
[   23.324612] [drm:intel_dp_detect] [CONNECTOR:22:DP-1]
[   23.324881] [drm:intel_dp_get_dpcd] DPCD: 11 06 84 01 00 00 01 00 02 02 06 00 00 00 00
[   23.345079] [drm:drm_edid_to_eld] ELD: no CEA Extension found
[   23.345090] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1] probed modes :
[   23.345094] [drm:drm_mode_debug_printmodeline] Modeline 24:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[   23.345098] [drm:drm_mode_debug_printmodeline] Modeline 28:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   23.345101] [drm:drm_mode_debug_printmodeline] Modeline 26:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   23.345104] [drm:drm_mode_debug_printmodeline] Modeline 27:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   23.345107] [drm:drm_mode_debug_printmodeline] Modeline 25:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   23.345110] [drm:drm_mode_debug_printmodeline] Modeline 32:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   23.345113] [drm:drm_mode_debug_printmodeline] Modeline 29:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   23.345116] [drm:drm_mode_debug_printmodeline] Modeline 30:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   23.345119] [drm:drm_mode_debug_printmodeline] Modeline 31:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   23.345131] [drm:drm_mode_getconnector] [CONNECTOR:22:?]
[   23.345300] [drm:drm_mode_getconnector] [CONNECTOR:14:?]
[   23.345303] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1]
[   23.345306] [drm:intel_crt_detect] [CONNECTOR:14:VGA-1] force=1
[   23.345312] [drm:intel_ironlake_crt_detect_hotplug] ironlake hotplug adpa=0xf40000, result 0
[   23.345313] [drm:intel_crt_detect] CRT not detected via hotplug
[   23.345491] [drm:gmbus_xfer] GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   23.345493] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.345494] [drm:intel_crt_get_edid] CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   23.345495] [drm:intel_gmbus_force_bit] enabling bit-banging on i915 gmbus vga. force bit now 1
[   23.345838] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.345840] [drm:intel_gmbus_force_bit] disabling bit-banging on i915 gmbus vga. force bit now 0
[   23.345842] [drm:intel_crt_detect_ddc] CRT not detected via DDC:0x50 [no valid EDID found]
[   23.345844] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1] disconnected
[   23.345850] [drm:drm_mode_getconnector] [CONNECTOR:14:?]
[   23.345852] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1]
[   23.345854] [drm:intel_crt_detect] [CONNECTOR:14:VGA-1] force=1
[   23.345856] [drm:intel_ironlake_crt_detect_hotplug] ironlake hotplug adpa=0xf40000, result 0
[   23.345858] [drm:intel_crt_detect] CRT not detected via hotplug
[   23.346067] [drm:gmbus_xfer] GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   23.346072] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.346074] [drm:intel_crt_get_edid] CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   23.346077] [drm:intel_gmbus_force_bit] enabling bit-banging on i915 gmbus vga. force bit now 1
[   23.346425] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   23.346427] [drm:intel_gmbus_force_bit] disabling bit-banging on i915 gmbus vga. force bit now 0
[   23.346429] [drm:intel_crt_detect_ddc] CRT not detected via DDC:0x50 [no valid EDID found]
[   23.346431] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1] disconnected
[   23.346472] [drm:drm_mode_getconnector] [CONNECTOR:17:?]
[   23.346475] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1]
[   23.346477] [drm:intel_hdmi_detect] [CONNECTOR:17:HDMI-A-1]
[   23.346681] [drm:gmbus_xfer] GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   23.346685] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus dpc
[   23.346689] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1] disconnected
[   23.346698] [drm:drm_mode_getconnector] [CONNECTOR:17:?]
[   23.346701] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1]
[   23.346704] [drm:intel_hdmi_detect] [CONNECTOR:17:HDMI-A-1]
[   23.346904] [drm:gmbus_xfer] GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   23.346908] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus dpc
[   23.346911] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1] disconnected
[   23.346960] [drm:drm_mode_getconnector] [CONNECTOR:22:?]
[   23.346964] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1]
[   23.346966] [drm:intel_dp_detect] [CONNECTOR:22:DP-1]
[   23.347238] [drm:intel_dp_get_dpcd] DPCD: 11 06 84 01 00 00 01 00 02 02 06 00 00 00 00
[   23.367859] [drm:drm_edid_to_eld] ELD: no CEA Extension found
[   23.367866] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1] probed modes :
[   23.367869] [drm:drm_mode_debug_printmodeline] Modeline 24:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[   23.367873] [drm:drm_mode_debug_printmodeline] Modeline 28:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   23.367876] [drm:drm_mode_debug_printmodeline] Modeline 26:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   23.367879] [drm:drm_mode_debug_printmodeline] Modeline 27:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   23.367882] [drm:drm_mode_debug_printmodeline] Modeline 25:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   23.367885] [drm:drm_mode_debug_printmodeline] Modeline 32:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   23.367887] [drm:drm_mode_debug_printmodeline] Modeline 29:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   23.367890] [drm:drm_mode_debug_printmodeline] Modeline 30:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   23.367893] [drm:drm_mode_debug_printmodeline] Modeline 31:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   23.367899] [drm:drm_mode_getconnector] [CONNECTOR:22:?]
[   23.421382] [drm:drm_mode_addfb] [FB:35]
[   23.421524] [drm:drm_mode_setcrtc] [CRTC:8]
[   23.421528] [drm:drm_mode_setcrtc] [CONNECTOR:22:DP-1]
[   23.421531] [drm:intel_crtc_set_config] [CRTC:8] [FB:35] #connectors=1 (x y) (0 0)
[   23.421535] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:8], mode_changed=0, fb_changed=1
[   23.421537] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   23.433872] [drm:ironlake_update_primary_plane] Writing base 00830000 00000000 0 0 7680
[   23.441327] [drm:drm_mode_setcrtc] [CRTC:12]
[   23.441333] [drm:intel_crtc_set_config] [CRTC:12] [NOFB]
[   23.441338] [drm:intel_set_config_compute_mode_changes] computed changes for [CRTC:12], mode_changed=0, fb_changed=0
[   23.441341] [drm:intel_modeset_stage_output_state] [CONNECTOR:22:DP-1] to [CRTC:8]
[   24.837961] [drm:add_framebuffer_internal] [FB:36]
[   40.434501] [drm:drm_mode_getconnector] [CONNECTOR:14:?]
[   40.434509] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1]
[   40.434513] [drm:intel_crt_detect] [CONNECTOR:14:VGA-1] force=1
[   40.434520] [drm:intel_ironlake_crt_detect_hotplug] ironlake hotplug adpa=0xf40000, result 0
[   40.434522] [drm:intel_crt_detect] CRT not detected via hotplug
[   40.434729] [drm:gmbus_xfer] GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   40.434733] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   40.434736] [drm:intel_crt_get_edid] CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   40.434739] [drm:intel_gmbus_force_bit] enabling bit-banging on i915 gmbus vga. force bit now 1
[   40.435094] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   40.435097] [drm:intel_gmbus_force_bit] disabling bit-banging on i915 gmbus vga. force bit now 0
[   40.435099] [drm:intel_crt_detect_ddc] CRT not detected via DDC:0x50 [no valid EDID found]
[   40.435103] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1] disconnected
[   40.435112] [drm:drm_mode_getconnector] [CONNECTOR:14:?]
[   40.435115] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1]
[   40.435117] [drm:intel_crt_detect] [CONNECTOR:14:VGA-1] force=1
[   40.435121] [drm:intel_ironlake_crt_detect_hotplug] ironlake hotplug adpa=0xf40000, result 0
[   40.435123] [drm:intel_crt_detect] CRT not detected via hotplug
[   40.435327] [drm:gmbus_xfer] GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   40.435332] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   40.435334] [drm:intel_crt_get_edid] CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   40.435337] [drm:intel_gmbus_force_bit] enabling bit-banging on i915 gmbus vga. force bit now 1
[   40.435728] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus vga
[   40.435732] [drm:intel_gmbus_force_bit] disabling bit-banging on i915 gmbus vga. force bit now 0
[   40.435734] [drm:intel_crt_detect_ddc] CRT not detected via DDC:0x50 [no valid EDID found]
[   40.435737] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:14:VGA-1] disconnected
[   40.435750] [drm:drm_mode_getconnector] [CONNECTOR:17:?]
[   40.435754] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1]
[   40.435756] [drm:intel_hdmi_detect] [CONNECTOR:17:HDMI-A-1]
[   40.435945] [drm:gmbus_xfer] GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   40.435950] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus dpc
[   40.435955] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1] disconnected
[   40.435964] [drm:drm_mode_getconnector] [CONNECTOR:17:?]
[   40.435967] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1]
[   40.435970] [drm:intel_hdmi_detect] [CONNECTOR:17:HDMI-A-1]
[   40.436214] [drm:gmbus_xfer] GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   40.436220] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter i915 gmbus dpc
[   40.436225] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:HDMI-A-1] disconnected
[   40.436246] [drm:drm_mode_getconnector] [CONNECTOR:22:?]
[   40.436251] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1]
[   40.436254] [drm:intel_dp_detect] [CONNECTOR:22:DP-1]
[   40.436523] [drm:intel_dp_get_dpcd] DPCD: 11 06 84 01 00 00 01 00 02 02 06 00 00 00 00
[   40.456350] [drm:drm_edid_to_eld] ELD: no CEA Extension found
[   40.456362] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:22:DP-1] probed modes :
[   40.456367] [drm:drm_mode_debug_printmodeline] Modeline 24:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[   40.456372] [drm:drm_mode_debug_printmodeline] Modeline 28:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   40.456376] [drm:drm_mode_debug_printmodeline] Modeline 26:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   40.456381] [drm:drm_mode_debug_printmodeline] Modeline 27:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   40.456386] [drm:drm_mode_debug_printmodeline] Modeline 25:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   40.456390] [drm:drm_mode_debug_printmodeline] Modeline 32:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   40.456395] [drm:drm_mode_debug_printmodeline] Modeline 29:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   40.456399] [drm:drm_mode_debug_printmodeline] Modeline 30:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   40.456404] [drm:drm_mode_debug_printmodeline] Modeline 31:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   40.456422] [drm:drm_mode_getconnector] [CONNECTOR:22:?]
[   59.219361] [drm:intel_crtc_cursor_set_obj] cursor off
[   68.250056] [drm:add_framebuffer_internal] [FB:37]
[   74.775948] [drm:i915_gem_open] 
[  595.226140] perf interrupt took too long (2517 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  669.503072] [drm:intel_crtc_cursor_set_obj] cursor off
[  669.802514] [drm:add_framebuffer_internal] [FB:38]
[  762.474956] [drm:intel_crtc_cursor_set_obj] cursor off
[  782.386901] [drm:add_framebuffer_internal] [FB:39]
[  804.804197] [drm:intel_crtc_cursor_set_obj] cursor off
[  806.417079] [drm:add_framebuffer_internal] [FB:40]
[  809.524852] [drm:intel_crtc_cursor_set_obj] cursor off
[  817.493876] [drm:add_framebuffer_internal] [FB:41]
[  840.451241] [drm:intel_crtc_cursor_set_obj] cursor off
[  854.806748] [drm:add_framebuffer_internal] [FB:42]
[  855.606560] [drm:intel_crtc_cursor_set_obj] cursor off
[  856.267166] [drm:add_framebuffer_internal] [FB:43]
[  856.934716] [drm:intel_crtc_cursor_set_obj] cursor off
[  857.178200] [drm:add_framebuffer_internal] [FB:44]
[  858.831069] [drm:intel_crtc_cursor_set_obj] cursor off
[  859.408421] [drm:add_framebuffer_internal] [FB:45]
[  864.458510] [drm:intel_crtc_cursor_set_obj] cursor off
[  915.055361] [drm:add_framebuffer_internal] [FB:46]
[  948.506032] [drm:intel_crtc_cursor_set_obj] cursor off
[  949.080472] [drm:add_framebuffer_internal] [FB:47]
[  960.346611] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
[  960.346616]       Tainted: G        W      3.18.0-rc1-00221-gc3351df #150
[  960.346618] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  960.346621] kworker/u16:0   D 0000000000000000     0     6      2 0x00000000
[  960.346633] Workqueue: netns cleanup_net
[  960.346635]  ffff880111c4d1e0 0000000000000002 ffff880111c4d1e0 ffff880111c53fd8
[  960.346639]  ffff880111c4d1e0 000000000000a000 ffff880111c4d1e0 0000000000000296
[  960.346642]  0000000000000000 7fffffffffffffff 7fffffffffffffff ffffffff8182e010
[  960.346646] Call Trace:
[  960.346654]  [<ffffffff8153dcfd>] ? schedule_timeout+0x18d/0x200
[  960.346660]  [<ffffffff810915a0>] ? get_state_synchronize_rcu+0x10/0x10
[  960.346664]  [<ffffffff8153c544>] ? wait_for_completion+0xb4/0x110
[  960.346669]  [<ffffffff8153e5d5>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[  960.346672]  [<ffffffff8153c539>] ? wait_for_completion+0xa9/0x110
[  960.346677]  [<ffffffff81069450>] ? wake_up_state+0x10/0x10
[  960.346681]  [<ffffffff8109285a>] ? _rcu_barrier+0x14a/0x1d0
[  960.346686]  [<ffffffff8145f13c>] ? netdev_run_todo+0x5c/0x310
[  960.346691]  [<ffffffff81458775>] ? rollback_registered_many+0x265/0x2d0
[  960.346696]  [<ffffffff81459db6>] ? default_device_exit_batch+0x136/0x150
[  960.346701]  [<ffffffff8107a240>] ? __wake_up_sync+0x10/0x10
[  960.346704]  [<ffffffff81454310>] ? cleanup_net+0xf0/0x1d0
[  960.346709]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
[  960.346713]  [<ffffffff81058ca7>] ? pwq_activate_delayed_work+0x27/0x40
[  960.346716]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
[  960.346720]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
[  960.346723]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
[  960.346726]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
[  960.346729]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[  960.346734]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
[  960.346737]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[ 1080.363583] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
[ 1080.363589]       Tainted: G        W      3.18.0-rc1-00221-gc3351df #150
[ 1080.363591] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1080.363594] kworker/u16:0   D 0000000000000000     0     6      2 0x00000000
[ 1080.363604] Workqueue: netns cleanup_net
[ 1080.363607]  ffff880111c4d1e0 0000000000000002 ffff880111c4d1e0 ffff880111c53fd8
[ 1080.363610]  ffff880111c4d1e0 000000000000a000 ffff880111c4d1e0 0000000000000296
[ 1080.363614]  0000000000000000 7fffffffffffffff 7fffffffffffffff ffffffff8182e010
[ 1080.363617] Call Trace:
[ 1080.363625]  [<ffffffff8153dcfd>] ? schedule_timeout+0x18d/0x200
[ 1080.363633]  [<ffffffff810915a0>] ? get_state_synchronize_rcu+0x10/0x10
[ 1080.363637]  [<ffffffff8153c544>] ? wait_for_completion+0xb4/0x110
[ 1080.363641]  [<ffffffff8153e5d5>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[ 1080.363645]  [<ffffffff8153c539>] ? wait_for_completion+0xa9/0x110
[ 1080.363649]  [<ffffffff81069450>] ? wake_up_state+0x10/0x10
[ 1080.363653]  [<ffffffff8109285a>] ? _rcu_barrier+0x14a/0x1d0
[ 1080.363658]  [<ffffffff8145f13c>] ? netdev_run_todo+0x5c/0x310
[ 1080.363663]  [<ffffffff81458775>] ? rollback_registered_many+0x265/0x2d0
[ 1080.363667]  [<ffffffff81459db6>] ? default_device_exit_batch+0x136/0x150
[ 1080.363672]  [<ffffffff8107a240>] ? __wake_up_sync+0x10/0x10
[ 1080.363676]  [<ffffffff81454310>] ? cleanup_net+0xf0/0x1d0
[ 1080.363681]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
[ 1080.363684]  [<ffffffff81058ca7>] ? pwq_activate_delayed_work+0x27/0x40
[ 1080.363688]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
[ 1080.363691]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
[ 1080.363695]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
[ 1080.363698]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
[ 1080.363702]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[ 1080.363706]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
[ 1080.363709]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[ 1182.643193] [drm:intel_crtc_cursor_set_obj] cursor off
[ 1200.380576] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
[ 1200.380582]       Tainted: G        W      3.18.0-rc1-00221-gc3351df #150
[ 1200.380583] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1200.380586] kworker/u16:0   D 0000000000000000     0     6      2 0x00000000
[ 1200.380596] Workqueue: netns cleanup_net
[ 1200.380599]  ffff880111c4d1e0 0000000000000002 ffff880111c4d1e0 ffff880111c53fd8
[ 1200.380603]  ffff880111c4d1e0 000000000000a000 ffff880111c4d1e0 0000000000000296
[ 1200.380606]  0000000000000000 7fffffffffffffff 7fffffffffffffff ffffffff8182e010
[ 1200.380610] Call Trace:
[ 1200.380618]  [<ffffffff8153dcfd>] ? schedule_timeout+0x18d/0x200
[ 1200.380624]  [<ffffffff810915a0>] ? get_state_synchronize_rcu+0x10/0x10
[ 1200.380628]  [<ffffffff8153c544>] ? wait_for_completion+0xb4/0x110
[ 1200.380632]  [<ffffffff8153e5d5>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[ 1200.380636]  [<ffffffff8153c539>] ? wait_for_completion+0xa9/0x110
[ 1200.380641]  [<ffffffff81069450>] ? wake_up_state+0x10/0x10
[ 1200.380645]  [<ffffffff8109285a>] ? _rcu_barrier+0x14a/0x1d0
[ 1200.380650]  [<ffffffff8145f13c>] ? netdev_run_todo+0x5c/0x310
[ 1200.380654]  [<ffffffff81458775>] ? rollback_registered_many+0x265/0x2d0
[ 1200.380659]  [<ffffffff81459db6>] ? default_device_exit_batch+0x136/0x150
[ 1200.380663]  [<ffffffff8107a240>] ? __wake_up_sync+0x10/0x10
[ 1200.380667]  [<ffffffff81454310>] ? cleanup_net+0xf0/0x1d0
[ 1200.380672]  [<ffffffff8105b566>] ? process_one_work+0x136/0x380
[ 1200.380675]  [<ffffffff81058ca7>] ? pwq_activate_delayed_work+0x27/0x40
[ 1200.380679]  [<ffffffff8105ba83>] ? worker_thread+0x63/0x480
[ 1200.380682]  [<ffffffff8105ba20>] ? rescuer_thread+0x270/0x270
[ 1200.380686]  [<ffffffff8105fc9e>] ? kthread+0xce/0xf0
[ 1200.380689]  [<ffffffff81060000>] ? queue_kthread_work+0x80/0x80
[ 1200.380692]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[ 1200.380696]  [<ffffffff8153ed2c>] ? ret_from_fork+0x7c/0xb0
[ 1200.380700]  [<ffffffff8105fbd0>] ? kthread_create_on_node+0x180/0x180
[ 1208.075392] [drm:add_framebuffer_internal] [FB:48]
[ 1214.794014] [drm:intel_crtc_cursor_set_obj] cursor off


-- 
Meelis Roos (mroos@linux.ee)
