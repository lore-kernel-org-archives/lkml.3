Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3HRSCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 14:02:46 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48848 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab3HRSCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 14:02:41 -0400
Date: Sun, 18 Aug 2013 11:02:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130818180232.GL29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813103202.GB2338@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081818-7606-0000-0000-00000E6E7D2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:32:03PM +0200, Jochen Striepe wrote:
> 	Hello,
> 
> just hit this one. Please tell me if you need any more information.

If you wait for a few minutes after the first stall warning message,
do you get a second one with a much larger "t=" number?  That would help
work out what part of the stack trace is responsible for the stall.

> Greetings from Germany,

Regards from USA.  ;-)

							Thanx, Paul
> Jochen.
> 
> [51204.416745] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=21120 jiffies, g=321982, c=321981, q=28)
> [51204.417199] sending NMI to all CPUs:
> [51204.417212] NMI backtrace for cpu 0
> [51204.417225] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.5 #1
> [51204.417410] Hardware name: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
> [51204.417659] task: c144e1a0 ti: f5806000 task.ti: c1442000
> [51204.417830] EIP: 0060:[<c118c070>] EFLAGS: 00200006 CPU: 0
> [51204.417849] EIP is at __const_udelay+0x0/0x20
> [51204.417858] EAX: 00418958 EBX: 00002710 ECX: c1455ba0 EDX: fffff000
> [51204.417867] ESI: c145a300 EDI: 00000001 EBP: c145a300 ESP: f5807ea0
> [51204.417876]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [51204.417886] CR0: 8005003b CR2: b8b22644 CR3: 014ea000 CR4: 000007d0
> [51204.417894] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [51204.417902] DR6: ffff0ff0 DR7: 00000400
> [51204.417908] Stack:
> [51204.417978]  c1021b92 c13da31d f77dcdc0 c109c63e c13e7e80 00000000 00005280 0004e9be
> [51204.417999]  0004e9bd 0000001c 00000001 00000000 00000001 c14827f0 00200083 c144e1a0
> [51204.418019]  00000000 00000000 c1443ebc c103ca86 f77dcc00 f511b9d9 00002e91 c107495c
> [51204.418040] Call Trace:
> [51204.418139]  [<c1021b92>] ? arch_trigger_all_cpu_backtrace+0x52/0x70
> [51204.418155]  [<c109c63e>] ? rcu_check_callbacks+0x4ae/0x4d0
> [51204.418171]  [<c103ca86>] ? update_process_times+0x36/0x70
> [51204.418187]  [<c107495c>] ? tick_sched_timer+0x3c/0x80
> [51204.418201]  [<c104f397>] ? __remove_hrtimer+0x47/0xa0
> [51204.418215]  [<c104f481>] ? __run_hrtimer.isra.29+0x41/0xc0
> [51204.418229]  [<c10500c5>] ? hrtimer_interrupt+0x205/0x290
> [51204.418245]  [<c1073a33>] ? tick_do_broadcast.constprop.8+0x63/0x70
> [51204.418260]  [<c1073bc8>] ? tick_handle_oneshot_broadcast+0x108/0x150
> [51204.418276]  [<c122d5e3>] ? credit_entropy_bits.part.10+0xa3/0x140
> [51204.418291]  [<c1003aea>] ? timer_interrupt+0xa/0x10
> [51204.418305]  [<c10945ce>] ? handle_irq_event_percpu+0x2e/0x140
> [51204.418320]  [<c102227a>] ? io_apic_modify_irq.isra.13+0x4a/0x60
> [51204.418333]  [<c109470e>] ? handle_irq_event+0x2e/0x50
> [51204.418347]  [<c10967f0>] ? handle_simple_irq+0x60/0x60
> [51204.418360]  [<c109684a>] ? handle_edge_irq+0x5a/0xe0
> [51204.418367]  <IRQ> 
> [51204.418437]  [<c10032ae>] ? do_IRQ+0x3e/0xc0
> [51204.418569]  [<f82326c2>] ? scsi_io_completion+0x1d2/0x650 [scsi_mod]
> [51204.418585]  [<c13516f3>] ? common_interrupt+0x33/0x38
> [51204.418600]  [<c10375e1>] ? __do_softirq+0x71/0x160
> [51204.418615]  [<c107489a>] ? tick_do_update_jiffies64+0xda/0x130
> [51204.418629]  [<c10377f5>] ? irq_exit+0x85/0x90
> [51204.418641]  [<c10032b7>] ? do_IRQ+0x47/0xc0
> [51204.418656]  [<c10513e4>] ? notifier_call_chain+0x44/0x60
> [51204.418669]  [<c13516f3>] ? common_interrupt+0x33/0x38
> [51204.418684]  [<c106007b>] ? unregister_fair_sched_group+0xb/0xa0
> [51204.418698]  [<c125e8e8>] ? cpuidle_enter_state+0x48/0xd0
> [51204.418711]  [<c125e9f1>] ? cpuidle_idle_call+0x81/0x110
> [51204.418726]  [<c10091f5>] ? arch_cpu_idle+0x5/0x20
> [51204.418739]  [<c106b7e9>] ? cpu_startup_entry+0x89/0x160
> [51204.418752]  [<c1487a02>] ? start_kernel+0x332/0x338
> [51204.418766]  [<c1487511>] ? repair_env_string+0x4d/0x4d
> [51204.418773] Code: 00 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 90 90 90 90 90 90 c3 90 8d 74 26 00 ff 15 a4 aa 46 c1 90 90 90 90 90 90 c3 8d 76 00 <c1> e0 02 64 8b 15 1c 20 4e c1 6b d2 3e f7 e2 89 d0 83 c0 01 ff
> [51119.954433] NMI backtrace for cpu 1
> [51119.954433] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.5 #1
> [51119.954433] Hardware name: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
> [51119.954433] task: f58d5100 ti: f58da000 task.ti: f58da000
> [51119.954433] EIP: 0060:[<c106b862>] EFLAGS: 00200246 CPU: 1
> [51119.954433] EIP is at cpu_startup_entry+0x102/0x160
> [51119.954433] EAX: 00000000 EBX: c14827ec ECX: 00000000 EDX: f58da000
> [51119.954433] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f58dbf8c
> [51119.954433]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [51119.954433] CR0: 8005003b CR2: b8b2beb8 CR3: 014ea000 CR4: 000007d0
> [51119.954433] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [51119.954433] DR6: ffff0ff0 DR7: 00000400
> [51119.954433] Stack:
> [51119.954433]  7d630dfa 89199db0 4772e76c c134762b dfd7ffff ff7fffe3 00000000 00000000
> [51119.954433]  26c9db13 4772e76c 01020800 00000000 00000000 00000000 00000000 00000000
> [51119.954433]  00000000 0000007b 0000007b 000000d8 000000e0 ffffffff 00000000 00000060
> [51119.954433] Call Trace:
> [51119.954433]  [<c134762b>] ? start_secondary+0x1e6/0x1ec
> [51119.954433] Code: c1 85 c0 74 84 e8 4f fb 02 00 fb 89 e0 25 00 e0 ff ff 8b 40 08 a8 08 75 19 89 e2 81 e2 00 e0 ff ff 90 8d b4 26 00 00 00 00 f3 90 <8b> 42 08 a8 08 74 f7 e8 92 fa 02 00 eb 96 e8 6b d9 f9 ff eb b6

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.10.5 (root@sodom) (gcc version 4.7.3 (Debian 4.7.3-4) ) #1 SMP Sun Aug 4 19:20:49 CEST 2013
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e2000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007f64ffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007f650000-0x000000007f65ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007f660000-0x000000007f66dfff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007f66e000-0x000000007f6affff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007f6b0000-0x000000007f6bffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007f6c8000-0x000000007f7fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> [    0.000000] SMBIOS 2.5 present.
> [    0.000000] DMI: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x7f650 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-DFFFF uncachable
> [    0.000000]   E0000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask 080000000 write-back
> [    0.000000]   1 base 07F700000 mask 0FFF00000 uncachable
> [    0.000000]   2 base 07F800000 mask 0FF800000 uncachable
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [c00ff780]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
> [    0.000000]  [mem 0x37000000-0x373fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
> [    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
> [    0.000000]  [mem 0x00100000-0x003fffff] page 4k
> [    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
> [    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
> [    0.000000] BRK [0x0153e000, 0x0153efff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x37536000-0x37a92fff]
> [    0.000000] Allocated new RAMDISK: [mem 0x36fd9000-0x37535149]
> [    0.000000] Move RAMDISK from [mem 0x37536000-0x37a92149] to [mem 0x36fd9000-0x37535149]
> [    0.000000] ACPI: RSDP 000fbfd0 00024 (v02 ACPIAM)
> [    0.000000] ACPI: XSDT 7f660100 00064 (v01 _ASUS_ Notebook 20091125 MSFT 00000097)
> [    0.000000] ACPI: FACP 7f660290 000F4 (v04 112509 FACP1046 20091125 MSFT 00000097)
> [    0.000000] ACPI: DSDT 7f660430 095E0 (v02  A1451 A1451000 00000000 INTL 20060113)
> [    0.000000] ACPI: FACS 7f66e000 00040
> [    0.000000] ACPI: APIC 7f660390 0005C (v02 112509 APIC1046 20091125 MSFT 00000097)
> [    0.000000] ACPI: MCFG 7f6603f0 0003C (v01 112509 OEMMCFG  20091125 MSFT 00000097)
> [    0.000000] ACPI: OEMB 7f66e040 0012C (v01 112509 OEMB1046 20091125 MSFT 00000097)
> [    0.000000] ACPI: HPET 7f669a10 00038 (v01 112509 OEMHPET  20091125 MSFT 00000097)
> [    0.000000] ACPI: GSCI 7f66e170 02024 (v01 112509 GMCHSCI  20091125 MSFT 00000097)
> [    0.000000] ACPI: SSDT 7f670b60 004F0 (v01  PmRef    CpuPm 00003000 INTL 20060113)
> [    0.000000] ACPI: SLIC 7f669a50 00176 (v01 _ASUS_ Notebook 20091125 MSFT 00000097)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 1150MB HIGHMEM available.
> [    0.000000] 887MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 377fe000
> [    0.000000]   low ram: 0 - 377fe000
> [    0.000000] BRK [0x0153f000, 0x0153ffff] PGTABLE
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
> [    0.000000]   HighMem  [mem 0x377fe000-0x7f64ffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x7f64ffff]
> [    0.000000] On node 0 totalpages: 521710
> [    0.000000] free_area_init_node: node 0, pgdat c147f000, node_mem_map f5fe9020
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1744 pages used for memmap
> [    0.000000]   Normal zone: 223230 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 2301 pages used for memmap
> [    0.000000]   HighMem zone: 294482 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x908
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e2000
> [    0.000000] PM: Registered nosave memory: 00000000000e2000 - 0000000000100000
> [    0.000000] e820: [mem 0x7f800000-0xfedfffff] available for PCI devices
> [    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 12 pages/cpu @f77da000 s27520 r0 d21632 u49152
> [    0.000000] pcpu-alloc: s27520 r0 d21632 u49152 alloc=12*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519934
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10.5 root=/dev/mapper/sodom-root ro quiet
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (000377fe:0007f650)
> [    0.000000] Memory: 2058640k/2087232k available (3400k kernel code, 28200k reserved, 1232k data, 368k init, 1177928k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfff8e000 - 0xfffff000   ( 452 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
> [    0.000000]       .init : 0xc1487000 - 0xc14e3000   ( 368 kB)
> [    0.000000]       .data : 0xc135230f - 0xc1486580   (1232 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc135230f   (3400 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=f5806000 soft=f5808000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 1331.276 MHz processor
> [    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 2662.55 BogoMIPS (lpj=5325104)
> [    0.004012] pid_max: default: 32768 minimum: 301
> [    0.008065] Mount-cache hash table entries: 512
> [    0.008501] Initializing cgroup subsys devices
> [    0.008511] Initializing cgroup subsys freezer
> [    0.008517] Initializing cgroup subsys net_cls
> [    0.008523] Initializing cgroup subsys blkio
> [    0.008528] Initializing cgroup subsys perf_event
> [    0.008585] Disabled fast string operations
> [    0.008595] CPU: Physical Processor ID: 0
> [    0.008599] CPU: Processor Core ID: 0
> [    0.008604] mce: CPU supports 5 MCE banks
> [    0.008619] CPU0: Thermal monitoring enabled (TM2)
> [    0.008648] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
> [    0.008648] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
> [    0.008648] tlb_flushall_shift: 6
> [    0.008763] Freeing SMP alternatives: 16k freed
> [    0.008793] ACPI: Core revision 20130328
> [    0.020556] ACPI: All ACPI Tables successfully acquired
> [    0.028187] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.028587] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.068305] smpboot: CPU0: Intel(R) Atom(TM) CPU Z520   @ 1.33GHz (fam: 06, model: 1c, stepping: 02)
> [    0.072000] Performance Events: PEBS fmt0+, LBR disabled due to erratumAtom events, Intel PMU driver.
> [    0.072000] ... version:                3
> [    0.072000] ... bit width:              40
> [    0.072000] ... generic registers:      2
> [    0.072000] ... value mask:             000000ffffffffff
> [    0.072000] ... max period:             000000007fffffff
> [    0.072000] ... fixed-purpose events:   3
> [    0.072000] ... event mask:             0000000700000003
> [    0.072000] CPU 1 irqstacks, hard=f58e8000 soft=f58ea000
> [    0.072000] smpboot: Booting Node   0, Processors  #1 OK
> [    0.008000] Initializing CPU#1
> [    0.008000] Disabled fast string operations
> [    0.080116] Brought up 2 CPUs
> [    0.080132] smpboot: Total of 2 processors activated (5325.10 BogoMIPS)
> [    0.080663] devtmpfs: initialized
> [    0.080663] PM: Registering ACPI NVS region [mem 0x7f66e000-0x7f6affff] (270336 bytes)
> [    0.080663] regulator-dummy: no parameters
> [    0.080663] NET: Registered protocol family 16
> [    0.080860] ACPI: bus type PCI registered
> [    0.080867] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.081030] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.081039] PCI: not using MMCONFIG
> [    0.081322] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
> [    0.081327] PCI: Using configuration type 1 for base access
> [    0.084445] bio: create slab <bio-0> at 0
> [    0.084445] ACPI: Added _OSI(Module Device)
> [    0.084445] ACPI: Added _OSI(Processor Device)
> [    0.084445] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.084445] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.090334] ACPI: EC: Look up EC in DSDT
> [    0.093868] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.104327] ACPI BIOS Bug: Warning: Incorrect checksum in table [OEMB] - 0xC1, should be 0x11 (20130328/tbutils-324)
> [    0.108265] ACPI: SSDT 7f670270 001FA (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
> [    0.109140] ACPI: Dynamic OEM Table Load:
> [    0.109149] ACPI: SSDT   (null) 001FA (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
> [    0.109483] ACPI: SSDT 7f670500 0065D (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
> [    0.110305] ACPI: Dynamic OEM Table Load:
> [    0.110313] ACPI: SSDT   (null) 0065D (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
> [    0.110946] ACPI: SSDT 7f6701a0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
> [    0.111790] ACPI: Dynamic OEM Table Load:
> [    0.111798] ACPI: SSDT   (null) 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
> [    0.112023] ACPI: SSDT 7f670470 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
> [    0.112845] ACPI: Dynamic OEM Table Load:
> [    0.112852] ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
> [    0.113711] ACPI: Interpreter enabled
> [    0.113745] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
> [    0.113758] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
> [    0.113805] ACPI: (supports S0 S3 S4 S5)
> [    0.113812] ACPI: Using IOAPIC for interrupt routing
> [    0.113889] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    0.117299] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
> [    0.117306] PCI: Using MMCONFIG for extended config space
> [    0.117354] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.117631] ACPI: No dock devices found.
> [    0.138111] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.142452] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.143076] PCI host bridge to bus 0000:00
> [    0.143089] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.143097] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.143105] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.143112] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.143119] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
> [    0.143127] pci_bus 0000:00: root bus resource [mem 0x7f800000-0xdfffffff]
> [    0.143134] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xffffffff]
> [    0.143161] pci 0000:00:00.0: [8086:8100] type 00 class 0x060000
> [    0.143399] pci 0000:00:02.0: [8086:8108] type 00 class 0x030000
> [    0.143430] pci 0000:00:02.0: reg 10: [mem 0xf3f80000-0xf3ffffff]
> [    0.143446] pci 0000:00:02.0: reg 14: [io  0xc880-0xc887]
> [    0.143461] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff]
> [    0.143477] pci 0000:00:02.0: reg 1c: [mem 0xf3f40000-0xf3f7ffff]
> [    0.143735] pci 0000:00:1b.0: [8086:811b] type 00 class 0x040300
> [    0.143763] pci 0000:00:1b.0: reg 10: [mem 0xf3f38000-0xf3f3bfff 64bit]
> [    0.143847] pci 0000:00:1b.0: PME# supported from D0 D3hot
> [    0.144019] pci 0000:00:1c.0: [8086:8110] type 01 class 0x060400
> [    0.144108] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.144187] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.144287] pci 0000:00:1c.1: [8086:8112] type 01 class 0x060400
> [    0.144374] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.144455] pci 0000:00:1c.1: System wakeup disabled by ACPI
> [    0.144564] pci 0000:00:1d.0: [8086:8114] type 00 class 0x0c0300
> [    0.144614] pci 0000:00:1d.0: reg 20: [io  0xb880-0xb89f]
> [    0.144763] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.144864] pci 0000:00:1d.1: [8086:8115] type 00 class 0x0c0300
> [    0.144915] pci 0000:00:1d.1: reg 20: [io  0xc080-0xc09f]
> [    0.145067] pci 0000:00:1d.1: System wakeup disabled by ACPI
> [    0.145166] pci 0000:00:1d.2: [8086:8116] type 00 class 0x0c0300
> [    0.145217] pci 0000:00:1d.2: reg 20: [io  0xc480-0xc49f]
> [    0.145373] pci 0000:00:1d.2: System wakeup disabled by ACPI
> [    0.145491] pci 0000:00:1d.7: [8086:8117] type 00 class 0x0c0320
> [    0.145528] pci 0000:00:1d.7: reg 10: [mem 0xf3f37c00-0xf3f37fff]
> [    0.145663] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.145777] pci 0000:00:1d.7: System wakeup disabled by ACPI
> [    0.145880] pci 0000:00:1f.0: [8086:8119] type 00 class 0x060100
> [    0.146059] pci 0000:00:1f.1: [8086:811a] type 00 class 0x010180
> [    0.146111] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
> [    0.146384] pci 0000:03:00.0: [1969:1062] type 00 class 0x020000
> [    0.146421] pci 0000:03:00.0: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
> [    0.146442] pci 0000:03:00.0: reg 18: [io  0xe880-0xe8ff]
> [    0.146571] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.156037] pci 0000:00:1c.0: PCI bridge to [bus 03]
> [    0.156049] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
> [    0.156058] pci 0000:00:1c.0:   bridge window [mem 0xfbf00000-0xfbffffff]
> [    0.156200] pci 0000:01:00.0: [168c:002b] type 00 class 0x028000
> [    0.156236] pci 0000:01:00.0: reg 10: [mem 0xfbef0000-0xfbefffff 64bit]
> [    0.156368] pci 0000:01:00.0: supports D1
> [    0.156375] pci 0000:01:00.0: PME# supported from D0 D1 D3hot D3cold
> [    0.164029] pci 0000:00:1c.1: PCI bridge to [bus 01-02]
> [    0.164040] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
> [    0.164050] pci 0000:00:1c.1:   bridge window [mem 0xf4000000-0xfbefffff]
> [    0.164059] pci 0000:00:1c.1:   bridge window [mem 0xcc000000-0xcfffffff pref]
> [    0.164079] pci_bus 0000:00: on NUMA node 0
> [    0.164091] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
> [    0.164098] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    0.165438] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.165636] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.165832] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.166026] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
> [    0.166222] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 7 10 11 12 14 15)
> [    0.166421] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.166616] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.166810] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
> [    0.167274] ACPI: Enabled 2 GPEs in block 00 to 1F
> [    0.167295] acpi root: \_SB_.PCI0 notify handler is installed
> [    0.167421] Found 1 acpi root devices
> [    0.167601] ACPI: EC: GPE = 0xd, I/O: command/status = 0x66, data = 0x62
> [    0.168053] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.168064] vgaarb: loaded
> [    0.168068] vgaarb: bridge control possible 0000:00:02.0
> [    0.168068] PCI: Using ACPI for IRQ routing
> [    0.168087] PCI: pci_cache_line_size set to 64 bytes
> [    0.168152] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.168158] e820: reserve RAM buffer [mem 0x7f650000-0x7fffffff]
> [    0.168501] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.168511] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.168523] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.172053] Switching to clocksource hpet
> [    0.172191] pnp: PnP ACPI init
> [    0.172224] ACPI: bus type PNP registered
> [    0.172612] system 00:00: [mem 0x7f800000-0x7fffffff] has been reserved
> [    0.172626] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.172748] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.172908] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> [    0.172992] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.173085] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.173574] system 00:05: [io  0x0374-0x0375] has been reserved
> [    0.173585] system 00:05: [io  0x03f4-0x03f5] has been reserved
> [    0.173593] system 00:05: [io  0x0380-0x0387] has been reserved
> [    0.173601] system 00:05: [io  0x09f4-0x09ff] has been reserved
> [    0.173609] system 00:05: [io  0x04d0-0x04d1] has been reserved
> [    0.173617] system 00:05: [io  0x0900-0x09f3] has been reserved
> [    0.173625] system 00:05: [io  0x0400-0x043f] has been reserved
> [    0.173633] system 00:05: [io  0x0480-0x04bf] has been reserved
> [    0.173642] system 00:05: [mem 0xf0000000-0xf0003fff] has been reserved
> [    0.173651] system 00:05: [mem 0x00000384-0x00000387] could not be reserved
> [    0.173661] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.173782] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.173992] pnp 00:07: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.174195] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.174529] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
> [    0.174539] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
> [    0.174549] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.174763] pnp 00:0a: Plug and Play ACPI device, IDs SYN0a13 SYN0a01 SYN0a04 SYN0002 PNP0f13 (active)
> [    0.174948] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.174959] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.175573] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.175584] system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
> [    0.175593] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
> [    0.175601] system 00:0c: [mem 0x00100000-0x7f7fffff] could not be reserved
> [    0.175611] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.176158] pnp: PnP ACPI: found 13 devices
> [    0.176165] ACPI: bus type PNP unregistered
> [    0.217237] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff pref] to [bus 03] add_size 200000
> [    0.217261] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff pref] get_res_add_size add_size 200000
> [    0.217277] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff pref]
> [    0.217285] pci 0000:00:1c.0: PCI bridge to [bus 03]
> [    0.217295] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
> [    0.217307] pci 0000:00:1c.0:   bridge window [mem 0xfbf00000-0xfbffffff]
> [    0.217317] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff pref]
> [    0.217330] pci 0000:00:1c.1: PCI bridge to [bus 01-02]
> [    0.217338] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
> [    0.217348] pci 0000:00:1c.1:   bridge window [mem 0xf4000000-0xfbefffff]
> [    0.217358] pci 0000:00:1c.1:   bridge window [mem 0xcc000000-0xcfffffff pref]
> [    0.217652] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.217661] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.217669] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.217676] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
> [    0.217683] pci_bus 0000:00: resource 8 [mem 0x7f800000-0xdfffffff]
> [    0.217690] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xffffffff]
> [    0.217699] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
> [    0.217706] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfbffffff]
> [    0.217713] pci_bus 0000:03: resource 2 [mem 0x80000000-0x801fffff pref]
> [    0.217721] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
> [    0.217728] pci_bus 0000:01: resource 1 [mem 0xf4000000-0xfbefffff]
> [    0.217735] pci_bus 0000:01: resource 2 [mem 0xcc000000-0xcfffffff pref]
> [    0.217866] NET: Registered protocol family 2
> [    0.218315] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.218390] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.218460] TCP: Hash tables configured (established 8192 bind 8192)
> [    0.218571] TCP: reno registered
> [    0.218580] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.218602] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.218785] NET: Registered protocol family 1
> [    0.218833] pci 0000:00:02.0: Boot video device
> [    0.219836] PCI: CLS 32 bytes, default 64
> [    0.219969] Unpacking initramfs...
> [    0.520906] Freeing initrd memory: 5492k freed
> [    0.530290] audit: initializing netlink socket (disabled)
> [    0.530329] type=2000 audit(1376337638.528:1): initialized
> [    0.530955] bounce pool size: 64 pages
> [    0.530992] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    0.531641] VFS: Disk quotas dquot_6.5.2
> [    0.531712] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.531951] msgmni has been set to 1730
> [    0.532685] alg: No test for stdrng (krng)
> [    0.532767] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.532775] io scheduler noop registered
> [    0.532780] io scheduler deadline registered
> [    0.532813] io scheduler cfq registered (default)
> [    0.533155] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.533213] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.533385] intel_idle: MWAIT substates: 0x3020220
> [    0.533401] intel_idle: v0.4 model 0x1C
> [    0.533407] intel_idle: lapic_timer_reliable_states 0x2
> [    0.533413] tsc: Marking TSC unstable due to TSC halts in idle states deeper than C2
> [    0.533505] GHES: HEST is not enabled!
> [    0.533647] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.534903] Linux agpgart interface v0.103
> [    0.535102] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [    0.557213] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.557233] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.557610] mousedev: PS/2 mouse device common for all mice
> [    0.558814] rtc_cmos 00:01: RTC can wake from S4
> [    0.559032] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
> [    0.559073] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.559236] cpuidle: using governor ladder
> [    0.559407] cpuidle: using governor menu
> [    0.559637] TCP: cubic registered
> [    0.559723] NET: Registered protocol family 10
> [    0.560277] mip6: Mobile IPv6
> [    0.560290] NET: Registered protocol family 17
> [    0.560330] Key type dns_resolver registered
> [    0.560710] Using IPI No-Shortcut mode
> [    0.561029] registered taskstats version 1
> [    0.561896] rtc_cmos 00:01: setting system clock to 2013-08-12 20:00:38 UTC (1376337638)
> [    0.562182] Freeing unused kernel memory: 368k freed
> [    0.585758] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    0.705914] udevd[56]: starting version 175
> [    0.826750] SCSI subsystem initialized
> [    0.835131] ACPI: bus type USB registered
> [    0.835257] usbcore: registered new interface driver usbfs
> [    0.835316] usbcore: registered new interface driver hub
> [    0.846364] atl1c 0000:03:00.0: version 1.0.1.1-NAPI
> [    0.853979] usbcore: registered new device driver usb
> [    0.855361] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.856410] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.856699] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    0.856715] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    0.856740] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> [    0.856844] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000b880
> [    0.857010] ehci-pci: EHCI PCI platform driver
> [    0.857024] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.857035] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.857044] usb usb1: Product: UHCI Host Controller
> [    0.857052] usb usb1: Manufacturer: Linux 3.10.5 uhci_hcd
> [    0.857060] usb usb1: SerialNumber: 0000:00:1d.0
> [    0.857550] hub 1-0:1.0: USB hub found
> [    0.857572] hub 1-0:1.0: 2 ports detected
> [    0.858315] ehci-pci 0000:00:1d.7: setting latency timer to 64
> [    0.858618] ehci-pci 0000:00:1d.7: EHCI Host Controller
> [    0.858652] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    0.858692] ehci-pci 0000:00:1d.7: debug port 1
> [    0.862543] ACPI: bus type ATA registered
> [    0.862678] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
> [    0.862799] ehci-pci 0000:00:1d.7: irq 19, io mem 0xf3f37c00
> [    0.876082] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    0.876160] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.876172] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.876183] usb usb2: Product: EHCI Host Controller
> [    0.876193] usb usb2: Manufacturer: Linux 3.10.5 ehci_hcd
> [    0.876203] usb usb2: SerialNumber: 0000:00:1d.7
> [    0.876970] hub 2-0:1.0: USB hub found
> [    0.876994] hub 2-0:1.0: 8 ports detected
> [    0.886801] libata version 3.00 loaded.
> [    0.900261] hub 1-0:1.0: USB hub found
> [    0.900286] hub 1-0:1.0: 2 ports detected
> [    0.901462] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    0.901480] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    0.901508] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> [    0.901627] uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000c080
> [    0.901805] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.901818] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.901828] usb usb3: Product: UHCI Host Controller
> [    0.901837] usb usb3: Manufacturer: Linux 3.10.5 uhci_hcd
> [    0.901846] usb usb3: SerialNumber: 0000:00:1d.1
> [    0.903397] hub 3-0:1.0: USB hub found
> [    0.903423] hub 3-0:1.0: 2 ports detected
> [    0.904169] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    0.904185] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    0.904211] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> [    0.904318] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c480
> [    0.904489] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    0.904501] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.904511] usb usb4: Product: UHCI Host Controller
> [    0.904519] usb usb4: Manufacturer: Linux 3.10.5 uhci_hcd
> [    0.904527] usb usb4: SerialNumber: 0000:00:1d.2
> [    0.905041] hub 4-0:1.0: USB hub found
> [    0.905065] hub 4-0:1.0: 2 ports detected
> [    0.906803] pata_sch 0000:00:1f.1: version 0.2
> [    0.906970] pata_sch 0000:00:1f.1: setting latency timer to 64
> [    0.908328] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.908342] ACPI: Thermal Zone [TZ00] (52 C)
> [    0.910199] scsi0 : pata_sch
> [    0.911442] scsi1 : pata_sch
> [    0.911722] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> [    0.911732] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> [    1.117827] ata1.00: ATA-8: ST9250315AS, 0002SDM1, max UDMA/133
> [    1.117842] ata1.00: 488397168 sectors, multi 16: LBA48 
> [    1.133423] ata1.00: configured for UDMA/100
> [    1.133938] scsi 0:0:0:0: Direct-Access     ATA      ST9250315AS      0002 PQ: 0 ANSI: 5
> [    1.188074] usb 2-5: new high-speed USB device number 2 using ehci-pci
> [    1.310021] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
> [    1.310334] sd 0:0:0:0: [sda] Write Protect is off
> [    1.310348] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.310483] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.325613] usb 2-5: New USB device found, idVendor=13d3, idProduct=5111
> [    1.325632] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=2
> [    1.325645] usb 2-5: Product: USB2.0 UVC VGA WebCam
> [    1.325656] usb 2-5: Manufacturer: Image Processor
> [    1.325667] usb 2-5: SerialNumber: USB2.0 UVC VGA WebCam
> [    1.332207]  sda: sda1 sda2 < sda5 >
> [    1.333708] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.340807] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.588211] device-mapper: uevent: version 1.0.3
> [    1.588433] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
> [   13.597499] bio: create slab <bio-1> at 1
> [   14.142507] bio: create slab <bio-1> at 1
> [   14.810004] PM: Starting manual resume from disk
> [   14.865102] kjournald starting.  Commit interval 5 seconds
> [   14.865174] EXT3-fs (dm-1): mounted filesystem with ordered data mode
> [   17.337114] udevd[397]: starting version 175
> [   18.465242] microcode: CPU0 sig=0x106c2, pf=0x1, revision=0x211
> [   18.486974] microcode: CPU1 sig=0x106c2, pf=0x1, revision=0x211
> [   18.487178] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   18.514715] input: PC Speaker as /devices/platform/pcspkr/input/input1
> [   18.518609] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
> [   18.524315] ACPI: Lid Switch [LID]
> [   18.528706] ACPI Warning: 0x00000400-0x0000043f SystemIO conflicts with Region \SMRG 1 (20130328/utaddress-251)
> [   18.528730] ACPI Warning: 0x00000400-0x0000043f SystemIO conflicts with Region \_SB_.PCI0.SBRG.SMRG 2 (20130328/utaddress-251)
> [   18.528746] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   18.528766] lpc_sch: probe of 0000:00:1f.0 failed with error -16
> [   18.529953] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
> [   18.531050] ACPI: Sleep Button [SLPB]
> [   18.531264] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
> [   18.531426] ACPI: Power Button [PWRB]
> [   18.549201] ACPI: AC Adapter [AC0] (on-line)
> [   18.551344] ACPI: Battery Slot [BAT0] (battery absent)
> [   18.551750] ACPI: Requesting acpi_cpufreq
> [   18.601560] wmi: Mapper loaded
> [   18.729346] [drm] Initialized drm 1.1.0 20060810
> [   18.826428] cfg80211: Calling CRDA to update world regulatory domain
> [   18.841749] gma500 0000:00:02.0: setting latency timer to 64
> [   18.872990] acpi device:0c: registered as cooling_device2
> [   18.873078] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [   18.873267] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
> [   18.873524] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   18.873533] [drm] No driver support for vblank timestamp query.
> [   18.848302] asus_wmi: ASUS WMI generic driver loaded
> [   18.905518] asus_wmi: Initialization: 0x0asus_wmi: BIOS WMI version: 0.5
> [   18.905838] asus_wmi: SFUN value: 0x0<6>[   18.912947] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input6
> [   19.031840] asus_wmi: Backlight controlled by ACPI video driver
> [   19.361604] ath: phy0: ASPM enabled: 0x42
> [   19.361619] ath: EEPROM regdomain: 0x60
> [   19.361625] ath: EEPROM indicates we should expect a direct regpair map
> [   19.361636] ath: Country alpha2 being used: 00
> [   19.361641] ath: Regpair used: 0x60
> [   19.412738] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [   19.413679] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xf83e0000, irq=17
> [   19.961121] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 600854
> [   20.044088] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
> [   20.263194] fbcon: psbdrmfb (fb0) is primary device
> [   20.532079] Console: switching to colour frame buffer device 170x48
> [   20.546005] gma500 0000:00:02.0: fb0: psbdrmfb frame buffer device
> [   20.546012] gma500 0000:00:02.0: registered panic notifier
> [   20.546171] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
> [   20.546196] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
> [   20.577164] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
> [   20.581955] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [   20.582320] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [   20.644112] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
> [   22.660762] EXT3-fs (dm-1): using internal journal
> [   23.824908] loop: module loaded
> [   24.696850] Adding 4030460k swap on /dev/mapper/sodom-swap_1.  Priority:-1 extents:1 across:4030460k FS
> [   25.872284] kjournald starting.  Commit interval 5 seconds
> [   25.876882] EXT3-fs (dm-3): using internal journal
> [   25.876895] EXT3-fs (dm-3): mounted filesystem with ordered data mode
> [   28.469594] RPC: Registered named UNIX socket transport module.
> [   28.469607] RPC: Registered udp transport module.
> [   28.469614] RPC: Registered tcp transport module.
> [   28.469620] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   28.560979] FS-Cache: Loaded
> [   28.611290] atl1c 0000:03:00.0: irq 40 for MSI/MSI-X
> [   28.611464] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
> [   28.651618] FS-Cache: Netfs 'nfs' registered for caching
> [   28.768893] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [  639.129551] gma500 0000:00:02.0: Backlight lvds set brightness 7a122848
> [  639.493091] gma500 0000:00:02.0: Backlight lvds set brightness 7a122366
> [  639.765298] gma500 0000:00:02.0: Backlight lvds set brightness 7a121d4c
> [  639.938960] gma500 0000:00:02.0: Backlight lvds set brightness 7a12186a
> [  640.097548] gma500 0000:00:02.0: Backlight lvds set brightness 7a12124e
> [ 2446.554090] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62
> [ 2446.554174] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62
> [ 8579.139722] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62
> [ 8579.139805] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62
> [10384.601305] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62
> [10384.601378] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62
> [51070.453907] NTFS driver 2.1.30 [Flags: R/W MODULE].
> [51204.416745] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=21120 jiffies, g=321982, c=321981, q=28)
> [51204.417199] sending NMI to all CPUs:
> [51204.417212] NMI backtrace for cpu 0
> [51204.417225] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.5 #1
> [51204.417410] Hardware name: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
> [51204.417659] task: c144e1a0 ti: f5806000 task.ti: c1442000
> [51204.417830] EIP: 0060:[<c118c070>] EFLAGS: 00200006 CPU: 0
> [51204.417849] EIP is at __const_udelay+0x0/0x20
> [51204.417858] EAX: 00418958 EBX: 00002710 ECX: c1455ba0 EDX: fffff000
> [51204.417867] ESI: c145a300 EDI: 00000001 EBP: c145a300 ESP: f5807ea0
> [51204.417876]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [51204.417886] CR0: 8005003b CR2: b8b22644 CR3: 014ea000 CR4: 000007d0
> [51204.417894] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [51204.417902] DR6: ffff0ff0 DR7: 00000400
> [51204.417908] Stack:
> [51204.417978]  c1021b92 c13da31d f77dcdc0 c109c63e c13e7e80 00000000 00005280 0004e9be
> [51204.417999]  0004e9bd 0000001c 00000001 00000000 00000001 c14827f0 00200083 c144e1a0
> [51204.418019]  00000000 00000000 c1443ebc c103ca86 f77dcc00 f511b9d9 00002e91 c107495c
> [51204.418040] Call Trace:
> [51204.418139]  [<c1021b92>] ? arch_trigger_all_cpu_backtrace+0x52/0x70
> [51204.418155]  [<c109c63e>] ? rcu_check_callbacks+0x4ae/0x4d0
> [51204.418171]  [<c103ca86>] ? update_process_times+0x36/0x70
> [51204.418187]  [<c107495c>] ? tick_sched_timer+0x3c/0x80
> [51204.418201]  [<c104f397>] ? __remove_hrtimer+0x47/0xa0
> [51204.418215]  [<c104f481>] ? __run_hrtimer.isra.29+0x41/0xc0
> [51204.418229]  [<c10500c5>] ? hrtimer_interrupt+0x205/0x290
> [51204.418245]  [<c1073a33>] ? tick_do_broadcast.constprop.8+0x63/0x70
> [51204.418260]  [<c1073bc8>] ? tick_handle_oneshot_broadcast+0x108/0x150
> [51204.418276]  [<c122d5e3>] ? credit_entropy_bits.part.10+0xa3/0x140
> [51204.418291]  [<c1003aea>] ? timer_interrupt+0xa/0x10
> [51204.418305]  [<c10945ce>] ? handle_irq_event_percpu+0x2e/0x140
> [51204.418320]  [<c102227a>] ? io_apic_modify_irq.isra.13+0x4a/0x60
> [51204.418333]  [<c109470e>] ? handle_irq_event+0x2e/0x50
> [51204.418347]  [<c10967f0>] ? handle_simple_irq+0x60/0x60
> [51204.418360]  [<c109684a>] ? handle_edge_irq+0x5a/0xe0
> [51204.418367]  <IRQ> 
> [51204.418437]  [<c10032ae>] ? do_IRQ+0x3e/0xc0
> [51204.418569]  [<f82326c2>] ? scsi_io_completion+0x1d2/0x650 [scsi_mod]
> [51204.418585]  [<c13516f3>] ? common_interrupt+0x33/0x38
> [51204.418600]  [<c10375e1>] ? __do_softirq+0x71/0x160
> [51204.418615]  [<c107489a>] ? tick_do_update_jiffies64+0xda/0x130
> [51204.418629]  [<c10377f5>] ? irq_exit+0x85/0x90
> [51204.418641]  [<c10032b7>] ? do_IRQ+0x47/0xc0
> [51204.418656]  [<c10513e4>] ? notifier_call_chain+0x44/0x60
> [51204.418669]  [<c13516f3>] ? common_interrupt+0x33/0x38
> [51204.418684]  [<c106007b>] ? unregister_fair_sched_group+0xb/0xa0
> [51204.418698]  [<c125e8e8>] ? cpuidle_enter_state+0x48/0xd0
> [51204.418711]  [<c125e9f1>] ? cpuidle_idle_call+0x81/0x110
> [51204.418726]  [<c10091f5>] ? arch_cpu_idle+0x5/0x20
> [51204.418739]  [<c106b7e9>] ? cpu_startup_entry+0x89/0x160
> [51204.418752]  [<c1487a02>] ? start_kernel+0x332/0x338
> [51204.418766]  [<c1487511>] ? repair_env_string+0x4d/0x4d
> [51204.418773] Code: 00 00 00 00 8d bc 27 00 00 00 00 48 75 fd 48 90 90 90 90 90 90 c3 90 8d 74 26 00 ff 15 a4 aa 46 c1 90 90 90 90 90 90 c3 8d 76 00 <c1> e0 02 64 8b 15 1c 20 4e c1 6b d2 3e f7 e2 89 d0 83 c0 01 ff
> [51119.954433] NMI backtrace for cpu 1
> [51119.954433] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.5 #1
> [51119.954433] Hardware name: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
> [51119.954433] task: f58d5100 ti: f58da000 task.ti: f58da000
> [51119.954433] EIP: 0060:[<c106b862>] EFLAGS: 00200246 CPU: 1
> [51119.954433] EIP is at cpu_startup_entry+0x102/0x160
> [51119.954433] EAX: 00000000 EBX: c14827ec ECX: 00000000 EDX: f58da000
> [51119.954433] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f58dbf8c
> [51119.954433]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [51119.954433] CR0: 8005003b CR2: b8b2beb8 CR3: 014ea000 CR4: 000007d0
> [51119.954433] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [51119.954433] DR6: ffff0ff0 DR7: 00000400
> [51119.954433] Stack:
> [51119.954433]  7d630dfa 89199db0 4772e76c c134762b dfd7ffff ff7fffe3 00000000 00000000
> [51119.954433]  26c9db13 4772e76c 01020800 00000000 00000000 00000000 00000000 00000000
> [51119.954433]  00000000 0000007b 0000007b 000000d8 000000e0 ffffffff 00000000 00000060
> [51119.954433] Call Trace:
> [51119.954433]  [<c134762b>] ? start_secondary+0x1e6/0x1ec
> [51119.954433] Code: c1 85 c0 74 84 e8 4f fb 02 00 fb 89 e0 25 00 e0 ff ff 8b 40 08 a8 08 75 19 89 e2 81 e2 00 e0 ff ff 90 8d b4 26 00 00 00 00 f3 90 <8b> 42 08 a8 08 74 f7 e8 92 fa 02 00 eb 96 e8 6b d9 f9 ff eb b6
> [51224.078233] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62
> [51224.078309] gma500 0000:00:02.0: Backlight lvds set brightness 7a122e62

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.10.5 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_CPU_PROBE_RELEASE=y
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> CONFIG_FHANDLE=y
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_WATCH=y
> CONFIG_AUDIT_TREE=y
> CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_RCU_FAST_NO_HZ=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_NOCB_CPU is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_FREEZER=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> CONFIG_PROC_PID_CPUSET=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_RESOURCE_COUNTERS=y
> # CONFIG_MEMCG is not set
> # CONFIG_CGROUP_HUGETLB is not set
> CONFIG_CGROUP_PERF=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_CFS_BANDWIDTH is not set
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_UIDGID_CONVERTED=y
> # CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HOTPLUG=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> CONFIG_VM_EVENT_COUNTERS=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> CONFIG_JUMP_LABEL=y
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_MODULE_SIG is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_THROTTLING is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> CONFIG_LDM_PARTITION=y
> # CONFIG_LDM_DEBUG is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> CONFIG_KARMA_PARTITION=y
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_CFQ_GROUP_IOSCHED=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_PADATA=y
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> CONFIG_INLINE_READ_UNLOCK=y
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> CONFIG_INLINE_WRITE_UNLOCK=y
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_GOLDFISH is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_X86_32_IRIS is not set
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> # CONFIG_HYPERVISOR_GUEST is not set
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> CONFIG_MATOM=y
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> CONFIG_NR_CPUS=2
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> # CONFIG_X86_ANCIENT_MCE is not set
> CONFIG_X86_MCE_THRESHOLD=y
> # CONFIG_X86_MCE_INJECT is not set
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_LIB=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_NEED_BOUNCE_POOL=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> # CONFIG_CLEANCACHE is not set
> CONFIG_FRONTSWAP=y
> CONFIG_HIGHPTE=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> # CONFIG_KEXEC_JUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
> # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATE_CALLBACKS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> CONFIG_PM_WAKELOCKS=y
> CONFIG_PM_WAKELOCKS_LIMIT=100
> CONFIG_PM_WAKELOCKS_GC=y
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_I2C=m
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_IPMI=m
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
> CONFIG_ACPI_THERMAL=m
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_SBS=m
> CONFIG_ACPI_HED=y
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> CONFIG_ACPI_APEI=y
> CONFIG_ACPI_APEI_GHES=y
> CONFIG_ACPI_APEI_PCIEAER=y
> CONFIG_ACPI_APEI_MEMORY_FAILURE=y
> # CONFIG_ACPI_APEI_EINJ is not set
> # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> CONFIG_SFI=y
> CONFIG_X86_APM_BOOT=y
> CONFIG_APM=m
> # CONFIG_APM_IGNORE_USER_SUSPEND is not set
> # CONFIG_APM_DO_ENABLE is not set
> # CONFIG_APM_CPU_IDLE is not set
> # CONFIG_APM_DISPLAY_BLANK is not set
> # CONFIG_APM_ALLOW_INTS is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=m
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> CONFIG_CPU_FREQ_GOV_USERSPACE=m
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
> 
> #
> # x86 CPU frequency scaling drivers
> #
> # CONFIG_X86_INTEL_PSTATE is not set
> CONFIG_X86_PCC_CPUFREQ=m
> CONFIG_X86_ACPI_CPUFREQ=m
> CONFIG_X86_ACPI_CPUFREQ_CPB=y
> CONFIG_X86_POWERNOW_K6=m
> CONFIG_X86_POWERNOW_K7=m
> CONFIG_X86_POWERNOW_K7_ACPI=y
> CONFIG_X86_POWERNOW_K8=m
> # CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
> CONFIG_X86_GX_SUSPMOD=m
> CONFIG_X86_SPEEDSTEP_CENTRINO=m
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> CONFIG_X86_SPEEDSTEP_ICH=m
> CONFIG_X86_SPEEDSTEP_SMI=m
> CONFIG_X86_P4_CLOCKMOD=m
> CONFIG_X86_CPUFREQ_NFORCE2=m
> CONFIG_X86_LONGRUN=m
> CONFIG_X86_LONGHAUL=m
> # CONFIG_X86_E_POWERSAVER is not set
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=m
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> CONFIG_INTEL_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=y
> CONFIG_PCIEAER=y
> # CONFIG_PCIE_ECRC is not set
> # CONFIG_PCIEAER_INJECT is not set
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> # CONFIG_PCIEASPM_DEFAULT is not set
> CONFIG_PCIEASPM_POWERSAVE=y
> # CONFIG_PCIEASPM_PERFORMANCE is not set
> CONFIG_PCIE_PME=y
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> CONFIG_PCI_STUB=m
> CONFIG_HT_IRQ=y
> CONFIG_PCI_ATS=y
> CONFIG_PCI_IOV=y
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> CONFIG_PCI_IOAPIC=y
> CONFIG_PCI_LABEL=y
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_OLPC is not set
> # CONFIG_ALIX is not set
> # CONFIG_NET5501 is not set
> # CONFIG_GEOS is not set
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=m
> CONFIG_PCMCIA=m
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_PD6729=m
> CONFIG_I82092=m
> CONFIG_PCCARD_NONSTATIC=y
> CONFIG_HOTPLUG_PCI=y
> # CONFIG_HOTPLUG_PCI_COMPAQ is not set
> # CONFIG_HOTPLUG_PCI_IBM is not set
> CONFIG_HOTPLUG_PCI_ACPI=y
> CONFIG_HOTPLUG_PCI_ACPI_IBM=m
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> # CONFIG_HOTPLUG_PCI_SHPC is not set
> # CONFIG_RAPIDIO is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> CONFIG_BINFMT_MISC=m
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> CONFIG_UNIX_DIAG=y
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=m
> CONFIG_XFRM_USER=m
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=m
> CONFIG_NET_KEY=m
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_IP_FIB_TRIE_STATS=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> CONFIG_IP_ROUTE_CLASSID=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE_DEMUX=m
> CONFIG_NET_IP_TUNNEL=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_NET_IPVTI=m
> CONFIG_INET_AH=m
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> CONFIG_INET_LRO=m
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> CONFIG_INET_UDP_DIAG=m
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> CONFIG_TCP_CONG_HSTCP=m
> CONFIG_TCP_CONG_HYBLA=m
> CONFIG_TCP_CONG_VEGAS=m
> CONFIG_TCP_CONG_SCALABLE=m
> CONFIG_TCP_CONG_LP=m
> CONFIG_TCP_CONG_VENO=m
> CONFIG_TCP_CONG_YEAH=m
> CONFIG_TCP_CONG_ILLINOIS=m
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> CONFIG_INET6_IPCOMP=m
> CONFIG_IPV6_MIP6=y
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_SIT=m
> CONFIG_IPV6_SIT_6RD=y
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=m
> CONFIG_IPV6_GRE=m
> CONFIG_IPV6_MULTIPLE_TABLES=y
> CONFIG_IPV6_SUBTREES=y
> CONFIG_IPV6_MROUTE=y
> CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IPV6_PIMSM_V2=y
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> CONFIG_BRIDGE_NETFILTER=y
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> # CONFIG_NETFILTER_NETLINK_ACCT is not set
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_ZONES=y
> # CONFIG_NF_CONNTRACK_PROCFS is not set
> CONFIG_NF_CONNTRACK_EVENTS=y
> # CONFIG_NF_CONNTRACK_TIMEOUT is not set
> CONFIG_NF_CONNTRACK_TIMESTAMP=y
> CONFIG_NF_CONNTRACK_LABELS=y
> CONFIG_NF_CT_PROTO_DCCP=m
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CT_PROTO_SCTP=m
> CONFIG_NF_CT_PROTO_UDPLITE=m
> CONFIG_NF_CONNTRACK_AMANDA=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_H323=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_BROADCAST=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_SNMP=m
> CONFIG_NF_CONNTRACK_PPTP=m
> CONFIG_NF_CONNTRACK_SANE=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NF_CT_NETLINK=m
> # CONFIG_NF_CT_NETLINK_TIMEOUT is not set
> # CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_NF_NAT_PROTO_DCCP=m
> CONFIG_NF_NAT_PROTO_UDPLITE=m
> CONFIG_NF_NAT_PROTO_SCTP=m
> CONFIG_NF_NAT_AMANDA=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_SIP=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NETFILTER_TPROXY=m
> CONFIG_NETFILTER_XTABLES=m
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=m
> CONFIG_NETFILTER_XT_CONNMARK=m
> CONFIG_NETFILTER_XT_SET=m
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_AUDIT=m
> CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
> CONFIG_NETFILTER_XT_TARGET_CT=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_HL=m
> # CONFIG_NETFILTER_XT_TARGET_HMARK is not set
> CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
> CONFIG_NETFILTER_XT_TARGET_LED=m
> CONFIG_NETFILTER_XT_TARGET_LOG=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NETMAP=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> # CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
> CONFIG_NETFILTER_XT_TARGET_RATEEST=m
> CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
> CONFIG_NETFILTER_XT_TARGET_TEE=m
> CONFIG_NETFILTER_XT_TARGET_TPROXY=m
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_SECMARK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
> 
> #
> # Xtables matches
> #
> CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
> CONFIG_NETFILTER_XT_MATCH_BPF=m
> CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_CPU=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ECN=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> CONFIG_NETFILTER_XT_MATCH_HL=m
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
> CONFIG_NETFILTER_XT_MATCH_IPVS=m
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> # CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
> CONFIG_NETFILTER_XT_MATCH_OSF=m
> CONFIG_NETFILTER_XT_MATCH_OWNER=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_RATEEST=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_RECENT=m
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_SOCKET=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_TIME=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_IP_SET=m
> CONFIG_IP_SET_MAX=256
> CONFIG_IP_SET_BITMAP_IP=m
> CONFIG_IP_SET_BITMAP_IPMAC=m
> CONFIG_IP_SET_BITMAP_PORT=m
> CONFIG_IP_SET_HASH_IP=m
> CONFIG_IP_SET_HASH_IPPORT=m
> CONFIG_IP_SET_HASH_IPPORTIP=m
> CONFIG_IP_SET_HASH_IPPORTNET=m
> CONFIG_IP_SET_HASH_NET=m
> CONFIG_IP_SET_HASH_NETPORT=m
> CONFIG_IP_SET_HASH_NETIFACE=m
> CONFIG_IP_SET_LIST_SET=m
> CONFIG_IP_VS=m
> CONFIG_IP_VS_IPV6=y
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_AH_ESP=y
> CONFIG_IP_VS_PROTO_ESP=y
> CONFIG_IP_VS_PROTO_AH=y
> CONFIG_IP_VS_PROTO_SCTP=y
> 
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=m
> CONFIG_IP_VS_WRR=m
> CONFIG_IP_VS_LC=m
> CONFIG_IP_VS_WLC=m
> CONFIG_IP_VS_LBLC=m
> CONFIG_IP_VS_LBLCR=m
> CONFIG_IP_VS_DH=m
> CONFIG_IP_VS_SH=m
> CONFIG_IP_VS_SED=m
> CONFIG_IP_VS_NQ=m
> 
> #
> # IPVS SH scheduler
> #
> CONFIG_IP_VS_SH_TAB_BITS=8
> 
> #
> # IPVS application helper
> #
> CONFIG_IP_VS_FTP=m
> CONFIG_IP_VS_NFCT=y
> CONFIG_IP_VS_PE_SIP=m
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=m
> CONFIG_NF_CONNTRACK_IPV4=m
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_RPFILTER=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT_IPV4=m
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_NF_NAT_SNMP_BASIC=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_NF_NAT_H323=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_CLUSTERIP=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV6=m
> CONFIG_NF_CONNTRACK_IPV6=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_IP6_NF_MATCH_AH=m
> CONFIG_IP6_NF_MATCH_EUI64=m
> CONFIG_IP6_NF_MATCH_FRAG=m
> CONFIG_IP6_NF_MATCH_OPTS=m
> CONFIG_IP6_NF_MATCH_HL=m
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> CONFIG_IP6_NF_MATCH_MH=m
> CONFIG_IP6_NF_MATCH_RPFILTER=m
> CONFIG_IP6_NF_MATCH_RT=m
> CONFIG_IP6_NF_TARGET_HL=m
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> CONFIG_IP6_NF_MANGLE=m
> CONFIG_IP6_NF_RAW=m
> CONFIG_NF_NAT_IPV6=m
> CONFIG_IP6_NF_TARGET_MASQUERADE=m
> CONFIG_IP6_NF_TARGET_NPT=m
> 
> #
> # DECnet: Netfilter Configuration
> #
> CONFIG_DECNET_NF_GRABULATOR=m
> CONFIG_BRIDGE_NF_EBTABLES=m
> CONFIG_BRIDGE_EBT_BROUTE=m
> CONFIG_BRIDGE_EBT_T_FILTER=m
> CONFIG_BRIDGE_EBT_T_NAT=m
> CONFIG_BRIDGE_EBT_802_3=m
> CONFIG_BRIDGE_EBT_AMONG=m
> CONFIG_BRIDGE_EBT_ARP=m
> CONFIG_BRIDGE_EBT_IP=m
> CONFIG_BRIDGE_EBT_IP6=m
> CONFIG_BRIDGE_EBT_LIMIT=m
> CONFIG_BRIDGE_EBT_MARK=m
> CONFIG_BRIDGE_EBT_PKTTYPE=m
> CONFIG_BRIDGE_EBT_STP=m
> CONFIG_BRIDGE_EBT_VLAN=m
> CONFIG_BRIDGE_EBT_ARPREPLY=m
> CONFIG_BRIDGE_EBT_DNAT=m
> CONFIG_BRIDGE_EBT_MARK_T=m
> CONFIG_BRIDGE_EBT_REDIRECT=m
> CONFIG_BRIDGE_EBT_SNAT=m
> CONFIG_BRIDGE_EBT_LOG=m
> CONFIG_BRIDGE_EBT_ULOG=m
> CONFIG_BRIDGE_EBT_NFLOG=m
> CONFIG_IP_DCCP=m
> CONFIG_INET_DCCP_DIAG=m
> 
> #
> # DCCP CCIDs Configuration
> #
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=y
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_TFRC_LIB=y
> CONFIG_IP_SCTP=m
> # CONFIG_SCTP_DBG_MSG is not set
> # CONFIG_SCTP_DBG_OBJCNT is not set
> CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
> CONFIG_SCTP_COOKIE_HMAC_MD5=y
> CONFIG_SCTP_COOKIE_HMAC_SHA1=y
> CONFIG_RDS=m
> CONFIG_RDS_TCP=m
> # CONFIG_RDS_DEBUG is not set
> CONFIG_TIPC=m
> CONFIG_TIPC_PORTS=8191
> CONFIG_ATM=m
> CONFIG_ATM_CLIP=m
> # CONFIG_ATM_CLIP_NO_ICMP is not set
> CONFIG_ATM_LANE=m
> CONFIG_ATM_MPOA=m
> CONFIG_ATM_BR2684=m
> # CONFIG_ATM_BR2684_IPFILTER is not set
> CONFIG_L2TP=m
> CONFIG_L2TP_DEBUGFS=m
> CONFIG_L2TP_V3=y
> CONFIG_L2TP_IP=m
> CONFIG_L2TP_ETH=m
> CONFIG_STP=m
> CONFIG_GARP=m
> CONFIG_BRIDGE=m
> CONFIG_BRIDGE_IGMP_SNOOPING=y
> # CONFIG_BRIDGE_VLAN_FILTERING is not set
> CONFIG_HAVE_NET_DSA=y
> CONFIG_VLAN_8021Q=m
> CONFIG_VLAN_8021Q_GVRP=y
> # CONFIG_VLAN_8021Q_MVRP is not set
> CONFIG_DECNET=m
> # CONFIG_DECNET_ROUTER is not set
> CONFIG_LLC=m
> CONFIG_LLC2=m
> CONFIG_IPX=m
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=m
> CONFIG_DEV_APPLETALK=m
> CONFIG_IPDDP=m
> CONFIG_IPDDP_ENCAP=y
> # CONFIG_X25 is not set
> CONFIG_LAPB=m
> CONFIG_PHONET=m
> CONFIG_IEEE802154=m
> CONFIG_IEEE802154_6LOWPAN=m
> CONFIG_MAC802154=m
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=m
> CONFIG_NET_SCH_HTB=m
> CONFIG_NET_SCH_HFSC=m
> CONFIG_NET_SCH_ATM=m
> CONFIG_NET_SCH_PRIO=m
> CONFIG_NET_SCH_MULTIQ=m
> CONFIG_NET_SCH_RED=m
> CONFIG_NET_SCH_SFB=m
> CONFIG_NET_SCH_SFQ=m
> CONFIG_NET_SCH_TEQL=m
> CONFIG_NET_SCH_TBF=m
> CONFIG_NET_SCH_GRED=m
> CONFIG_NET_SCH_DSMARK=m
> CONFIG_NET_SCH_NETEM=m
> CONFIG_NET_SCH_DRR=m
> CONFIG_NET_SCH_MQPRIO=m
> CONFIG_NET_SCH_CHOKE=m
> CONFIG_NET_SCH_QFQ=m
> CONFIG_NET_SCH_CODEL=m
> CONFIG_NET_SCH_FQ_CODEL=m
> CONFIG_NET_SCH_INGRESS=m
> # CONFIG_NET_SCH_PLUG is not set
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=m
> CONFIG_NET_CLS_TCINDEX=m
> CONFIG_NET_CLS_ROUTE4=m
> CONFIG_NET_CLS_FW=m
> CONFIG_NET_CLS_U32=m
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=m
> CONFIG_NET_CLS_RSVP6=m
> CONFIG_NET_CLS_FLOW=m
> CONFIG_NET_CLS_CGROUP=y
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=m
> CONFIG_NET_EMATCH_NBYTE=m
> CONFIG_NET_EMATCH_U32=m
> CONFIG_NET_EMATCH_META=m
> CONFIG_NET_EMATCH_TEXT=m
> # CONFIG_NET_EMATCH_IPSET is not set
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=m
> CONFIG_NET_ACT_GACT=m
> CONFIG_GACT_PROB=y
> CONFIG_NET_ACT_MIRRED=m
> CONFIG_NET_ACT_IPT=m
> CONFIG_NET_ACT_NAT=m
> CONFIG_NET_ACT_PEDIT=m
> CONFIG_NET_ACT_SIMP=m
> CONFIG_NET_ACT_SKBEDIT=m
> CONFIG_NET_ACT_CSUM=m
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> CONFIG_DCB=y
> CONFIG_DNS_RESOLVER=y
> CONFIG_BATMAN_ADV=m
> # CONFIG_BATMAN_ADV_BLA is not set
> # CONFIG_BATMAN_ADV_DAT is not set
> # CONFIG_BATMAN_ADV_NC is not set
> # CONFIG_BATMAN_ADV_DEBUG is not set
> CONFIG_OPENVSWITCH=m
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_MMAP is not set
> # CONFIG_NETLINK_DIAG is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> CONFIG_NETPRIO_CGROUP=m
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=m
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_AF_RXRPC=m
> # CONFIG_AF_RXRPC_DEBUG is not set
> CONFIG_RXKAD=m
> CONFIG_FIB_RULES=y
> CONFIG_WIRELESS=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_CFG80211=m
> # CONFIG_NL80211_TESTMODE is not set
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> # CONFIG_CFG80211_REG_DEBUG is not set
> CONFIG_CFG80211_DEFAULT_PS=y
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> CONFIG_CFG80211_WEXT=y
> # CONFIG_LIB80211 is not set
> CONFIG_MAC80211=m
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> CONFIG_MAC80211_MESH=y
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_MESSAGE_TRACING is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> # CONFIG_WIMAX is not set
> CONFIG_RFKILL=m
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> # CONFIG_RFKILL_REGULATOR is not set
> CONFIG_NET_9P=m
> # CONFIG_NET_9P_DEBUG is not set
> # CONFIG_CAIF is not set
> CONFIG_CEPH_LIB=m
> # CONFIG_CEPH_LIB_PRETTYDEBUG is not set
> # CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
> # CONFIG_NFC is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_FW_LOADER_USER_HELPER is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_CMA is not set
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=m
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> CONFIG_BLK_DEV_DRBD=m
> # CONFIG_DRBD_FAULT_INJECTION is not set
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_OSD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> CONFIG_BLK_DEV_RAM=m
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=8192
> # CONFIG_BLK_DEV_XIP is not set
> CONFIG_CDROM_PKTCDVD=m
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> CONFIG_ATA_OVER_ETH=m
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_BLK_DEV_RBD=m
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ICS932S401 is not set
> # CONFIG_ATMEL_SSC is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_SENSORS_BH1780 is not set
> # CONFIG_SENSORS_BH1770 is not set
> # CONFIG_SENSORS_APDS990X is not set
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> # CONFIG_TI_DAC7512 is not set
> # CONFIG_BMP085_I2C is not set
> # CONFIG_BMP085_SPI is not set
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> # CONFIG_LATTICE_ECP3_CONFIG is not set
> # CONFIG_SRAM is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> # CONFIG_EEPROM_AT25 is not set
> # CONFIG_EEPROM_LEGACY is not set
> # CONFIG_EEPROM_MAX6875 is not set
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_EEPROM_93XX46 is not set
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> # CONFIG_INTEL_MEI is not set
> # CONFIG_INTEL_MEI_ME is not set
> # CONFIG_VMWARE_VMCI is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=m
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=m
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=m
> CONFIG_CHR_DEV_ST=m
> CONFIG_CHR_DEV_OSST=m
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> CONFIG_SCSI_FC_ATTRS=m
> CONFIG_SCSI_FC_TGT_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=m
> CONFIG_SCSI_SAS_ATTRS=m
> CONFIG_SCSI_SAS_LIBSAS=m
> CONFIG_SCSI_SAS_ATA=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=m
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=m
> CONFIG_ISCSI_BOOT_SYSFS=m
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> # CONFIG_SCSI_CXGB4_ISCSI is not set
> # CONFIG_SCSI_BNX2_ISCSI is not set
> # CONFIG_SCSI_BNX2X_FCOE is not set
> # CONFIG_BE2ISCSI is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_HPSA is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_MVUMI is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_MPT3SAS is not set
> # CONFIG_SCSI_UFSHCD is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_VMWARE_PVSCSI is not set
> CONFIG_LIBFC=m
> # CONFIG_LIBFCOE is not set
> # CONFIG_FCOE is not set
> # CONFIG_FCOE_FNIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_GDTH is not set
> # CONFIG_SCSI_ISCI is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_NSP32 is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_PMCRAID is not set
> # CONFIG_SCSI_PM8001 is not set
> # CONFIG_SCSI_SRP is not set
> # CONFIG_SCSI_BFA_FC is not set
> # CONFIG_SCSI_CHELSIO_FCOE is not set
> CONFIG_SCSI_LOWLEVEL_PCMCIA=y
> # CONFIG_PCMCIA_AHA152X is not set
> # CONFIG_PCMCIA_FDOMAIN is not set
> # CONFIG_PCMCIA_NINJA_SCSI is not set
> # CONFIG_PCMCIA_QLOGIC is not set
> # CONFIG_PCMCIA_SYM53C500 is not set
> CONFIG_SCSI_DH=m
> CONFIG_SCSI_DH_RDAC=m
> CONFIG_SCSI_DH_HP_SW=m
> CONFIG_SCSI_DH_EMC=m
> CONFIG_SCSI_DH_ALUA=m
> CONFIG_SCSI_OSD_INITIATOR=m
> CONFIG_SCSI_OSD_ULD=m
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=m
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_ATA_PIIX=m
> # CONFIG_SATA_HIGHBANK is not set
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARASAN_CF is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> CONFIG_PATA_SCH=m
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_PCMCIA is not set
> # CONFIG_PATA_RZ1000 is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_LEGACY is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> CONFIG_MD_LINEAR=m
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> CONFIG_MD_MULTIPATH=m
> CONFIG_MD_FAULTY=m
> # CONFIG_BCACHE is not set
> CONFIG_BLK_DEV_DM=m
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=m
> CONFIG_DM_BIO_PRISON=m
> CONFIG_DM_PERSISTENT_DATA=m
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_THIN_PROVISIONING=m
> # CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
> # CONFIG_DM_CACHE is not set
> CONFIG_DM_MIRROR=m
> CONFIG_DM_RAID=m
> CONFIG_DM_LOG_USERSPACE=m
> CONFIG_DM_ZERO=m
> CONFIG_DM_MULTIPATH=m
> CONFIG_DM_MULTIPATH_QL=m
> CONFIG_DM_MULTIPATH_ST=m
> CONFIG_DM_DELAY=m
> CONFIG_DM_UEVENT=y
> CONFIG_DM_FLAKEY=m
> CONFIG_DM_VERITY=m
> CONFIG_TARGET_CORE=m
> CONFIG_TCM_IBLOCK=m
> CONFIG_TCM_FILEIO=m
> CONFIG_TCM_PSCSI=m
> CONFIG_LOOPBACK_TARGET=m
> CONFIG_TCM_FC=m
> CONFIG_ISCSI_TARGET=m
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> CONFIG_I2O=m
> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
> CONFIG_I2O_EXT_ADAPTEC=y
> CONFIG_I2O_CONFIG=m
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=m
> CONFIG_I2O_BLOCK=m
> CONFIG_I2O_SCSI=m
> CONFIG_I2O_PROC=m
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> CONFIG_BONDING=m
> CONFIG_DUMMY=m
> CONFIG_EQUALIZER=m
> # CONFIG_NET_FC is not set
> CONFIG_MII=m
> CONFIG_IFB=m
> CONFIG_NET_TEAM=m
> CONFIG_NET_TEAM_MODE_BROADCAST=m
> CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
> # CONFIG_NET_TEAM_MODE_RANDOM is not set
> CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
> CONFIG_NET_TEAM_MODE_LOADBALANCE=m
> CONFIG_MACVLAN=m
> CONFIG_MACVTAP=m
> # CONFIG_VXLAN is not set
> CONFIG_NETCONSOLE=m
> CONFIG_NETCONSOLE_DYNAMIC=y
> CONFIG_NETPOLL=y
> # CONFIG_NETPOLL_TRAP is not set
> CONFIG_NET_POLL_CONTROLLER=y
> CONFIG_TUN=m
> CONFIG_VETH=m
> # CONFIG_ARCNET is not set
> # CONFIG_ATM_DRIVERS is not set
> 
> #
> # CAIF transport drivers
> #
> 
> #
> # Distributed Switch Architecture drivers
> #
> # CONFIG_NET_DSA_MV88E6XXX is not set
> # CONFIG_NET_DSA_MV88E6060 is not set
> # CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
> # CONFIG_NET_DSA_MV88E6131 is not set
> # CONFIG_NET_DSA_MV88E6123_61_65 is not set
> CONFIG_ETHERNET=y
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> # CONFIG_NET_VENDOR_ALTEON is not set
> # CONFIG_NET_VENDOR_AMD is not set
> CONFIG_NET_VENDOR_ATHEROS=y
> # CONFIG_ATL2 is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> CONFIG_ATL1C=m
> # CONFIG_ALX is not set
> # CONFIG_NET_CADENCE is not set
> # CONFIG_NET_VENDOR_BROADCOM is not set
> # CONFIG_NET_VENDOR_BROCADE is not set
> # CONFIG_NET_CALXEDA_XGMAC is not set
> # CONFIG_NET_VENDOR_CHELSIO is not set
> # CONFIG_NET_VENDOR_CISCO is not set
> # CONFIG_DNET is not set
> # CONFIG_NET_VENDOR_DEC is not set
> # CONFIG_NET_VENDOR_DLINK is not set
> # CONFIG_NET_VENDOR_EMULEX is not set
> # CONFIG_NET_VENDOR_EXAR is not set
> # CONFIG_NET_VENDOR_FUJITSU is not set
> # CONFIG_NET_VENDOR_HP is not set
> # CONFIG_NET_VENDOR_INTEL is not set
> # CONFIG_IP1000 is not set
> # CONFIG_JME is not set
> # CONFIG_NET_VENDOR_MARVELL is not set
> # CONFIG_NET_VENDOR_MELLANOX is not set
> # CONFIG_NET_VENDOR_MICREL is not set
> # CONFIG_NET_VENDOR_MICROCHIP is not set
> # CONFIG_NET_VENDOR_MYRI is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> # CONFIG_NET_VENDOR_NVIDIA is not set
> # CONFIG_NET_VENDOR_OKI is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_PACKET_ENGINE is not set
> # CONFIG_NET_VENDOR_QLOGIC is not set
> # CONFIG_NET_VENDOR_REALTEK is not set
> # CONFIG_NET_VENDOR_RDC is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> # CONFIG_NET_VENDOR_SILAN is not set
> # CONFIG_NET_VENDOR_SIS is not set
> # CONFIG_SFC is not set
> # CONFIG_NET_VENDOR_SMSC is not set
> # CONFIG_NET_VENDOR_STMICRO is not set
> # CONFIG_NET_VENDOR_SUN is not set
> # CONFIG_NET_VENDOR_TEHUTI is not set
> # CONFIG_NET_VENDOR_TI is not set
> # CONFIG_NET_VENDOR_VIA is not set
> # CONFIG_NET_VENDOR_WIZNET is not set
> # CONFIG_NET_VENDOR_XIRCOM is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=m
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AT803X_PHY=m
> # CONFIG_AMD_PHY is not set
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> # CONFIG_LXT_PHY is not set
> # CONFIG_CICADA_PHY is not set
> # CONFIG_VITESSE_PHY is not set
> # CONFIG_SMSC_PHY is not set
> # CONFIG_BROADCOM_PHY is not set
> # CONFIG_BCM87XX_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> # CONFIG_NATIONAL_PHY is not set
> # CONFIG_STE10XP is not set
> # CONFIG_LSI_ET1011C_PHY is not set
> # CONFIG_MICREL_PHY is not set
> CONFIG_MDIO_BITBANG=m
> # CONFIG_MDIO_GPIO is not set
> # CONFIG_MICREL_KS8995MA is not set
> CONFIG_PPP=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_MPPE=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPPOATM=m
> CONFIG_PPPOE=m
> CONFIG_PPTP=m
> CONFIG_PPPOL2TP=m
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> # CONFIG_SLIP is not set
> CONFIG_SLHC=m
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_RTL8152 is not set
> CONFIG_USB_USBNET=m
> # CONFIG_USB_NET_AX8817X is not set
> # CONFIG_USB_NET_AX88179_178A is not set
> CONFIG_USB_NET_CDCETHER=m
> # CONFIG_USB_NET_CDC_EEM is not set
> # CONFIG_USB_NET_CDC_NCM is not set
> # CONFIG_USB_NET_CDC_MBIM is not set
> # CONFIG_USB_NET_DM9601 is not set
> # CONFIG_USB_NET_SMSC75XX is not set
> # CONFIG_USB_NET_SMSC95XX is not set
> # CONFIG_USB_NET_GL620A is not set
> # CONFIG_USB_NET_NET1080 is not set
> # CONFIG_USB_NET_PLUSB is not set
> # CONFIG_USB_NET_MCS7830 is not set
> CONFIG_USB_NET_RNDIS_HOST=m
> # CONFIG_USB_NET_CDC_SUBSET is not set
> # CONFIG_USB_NET_ZAURUS is not set
> # CONFIG_USB_NET_CX82310_ETH is not set
> # CONFIG_USB_NET_KALMIA is not set
> # CONFIG_USB_NET_QMI_WWAN is not set
> # CONFIG_USB_HSO is not set
> # CONFIG_USB_NET_INT51X1 is not set
> # CONFIG_USB_CDC_PHONET is not set
> CONFIG_USB_IPHETH=m
> # CONFIG_USB_SIERRA_NET is not set
> # CONFIG_USB_VL600 is not set
> CONFIG_WLAN=y
> # CONFIG_PCMCIA_RAYCS is not set
> # CONFIG_LIBERTAS_THINFIRM is not set
> # CONFIG_AIRO is not set
> # CONFIG_ATMEL is not set
> # CONFIG_AT76C50X_USB is not set
> # CONFIG_AIRO_CS is not set
> # CONFIG_PCMCIA_WL3501 is not set
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8180 is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_ADM8211 is not set
> # CONFIG_MAC80211_HWSIM is not set
> # CONFIG_MWL8K is not set
> CONFIG_ATH_COMMON=m
> CONFIG_ATH_CARDS=m
> # CONFIG_ATH_DEBUG is not set
> # CONFIG_ATH5K is not set
> # CONFIG_ATH5K_PCI is not set
> CONFIG_ATH9K_HW=m
> CONFIG_ATH9K_COMMON=m
> # CONFIG_ATH9K_BTCOEX_SUPPORT is not set
> CONFIG_ATH9K=m
> CONFIG_ATH9K_PCI=y
> # CONFIG_ATH9K_AHB is not set
> # CONFIG_ATH9K_DEBUGFS is not set
> # CONFIG_ATH9K_LEGACY_RATE_CONTROL is not set
> # CONFIG_ATH9K_HTC is not set
> # CONFIG_CARL9170 is not set
> # CONFIG_ATH6KL is not set
> # CONFIG_AR5523 is not set
> # CONFIG_WIL6210 is not set
> # CONFIG_B43 is not set
> # CONFIG_B43LEGACY is not set
> # CONFIG_BRCMFMAC is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_IPW2100 is not set
> # CONFIG_IPW2200 is not set
> # CONFIG_IWLWIFI is not set
> # CONFIG_IWL4965 is not set
> # CONFIG_IWL3945 is not set
> # CONFIG_LIBERTAS is not set
> # CONFIG_HERMES is not set
> # CONFIG_P54_COMMON is not set
> # CONFIG_RT2X00 is not set
> # CONFIG_RTLWIFI is not set
> # CONFIG_WL_TI is not set
> # CONFIG_ZD1211RW is not set
> # CONFIG_MWIFIEX is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> CONFIG_IEEE802154_DRIVERS=m
> CONFIG_IEEE802154_FAKEHARD=m
> CONFIG_IEEE802154_FAKELB=m
> # CONFIG_IEEE802154_AT86RF230 is not set
> # CONFIG_IEEE802154_MRF24J40 is not set
> # CONFIG_VMXNET3 is not set
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=m
> CONFIG_INPUT_SPARSEKMAP=m
> CONFIG_INPUT_MATRIXKMAP=m
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1366
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=m
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5588=m
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> CONFIG_KEYBOARD_QT2160=m
> CONFIG_KEYBOARD_LKKBD=m
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> CONFIG_KEYBOARD_TCA8418=m
> # CONFIG_KEYBOARD_MATRIX is not set
> CONFIG_KEYBOARD_LM8323=m
> CONFIG_KEYBOARD_LM8333=m
> CONFIG_KEYBOARD_MAX7359=m
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> CONFIG_KEYBOARD_NEWTON=m
> CONFIG_KEYBOARD_OPENCORES=m
> CONFIG_KEYBOARD_STOWAWAY=m
> CONFIG_KEYBOARD_SUNKBD=m
> CONFIG_KEYBOARD_XTKBD=m
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=m
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_MOUSE_PS2_ELANTECH=y
> CONFIG_MOUSE_PS2_SENTELIC=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> CONFIG_MOUSE_SERIAL=m
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_CYAPA is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_GPIO is not set
> CONFIG_MOUSE_SYNAPTICS_I2C=m
> CONFIG_MOUSE_SYNAPTICS_USB=m
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_ADS7846=m
> CONFIG_TOUCHSCREEN_AD7877=m
> CONFIG_TOUCHSCREEN_AD7879=m
> CONFIG_TOUCHSCREEN_AD7879_I2C=m
> # CONFIG_TOUCHSCREEN_AD7879_SPI is not set
> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
> # CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> # CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
> # CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
> CONFIG_TOUCHSCREEN_DYNAPRO=m
> CONFIG_TOUCHSCREEN_HAMPSHIRE=m
> CONFIG_TOUCHSCREEN_EETI=m
> CONFIG_TOUCHSCREEN_FUJITSU=m
> # CONFIG_TOUCHSCREEN_ILI210X is not set
> CONFIG_TOUCHSCREEN_GUNZE=m
> CONFIG_TOUCHSCREEN_ELO=m
> CONFIG_TOUCHSCREEN_WACOM_W8001=m
> # CONFIG_TOUCHSCREEN_WACOM_I2C is not set
> # CONFIG_TOUCHSCREEN_MAX11801 is not set
> CONFIG_TOUCHSCREEN_MCS5000=m
> # CONFIG_TOUCHSCREEN_MMS114 is not set
> CONFIG_TOUCHSCREEN_MTOUCH=m
> CONFIG_TOUCHSCREEN_INEXIO=m
> CONFIG_TOUCHSCREEN_MK712=m
> CONFIG_TOUCHSCREEN_PENMOUNT=m
> # CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
> CONFIG_TOUCHSCREEN_TOUCHWIN=m
> # CONFIG_TOUCHSCREEN_PIXCIR is not set
> CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
> CONFIG_TOUCHSCREEN_USB_EGALAX=y
> CONFIG_TOUCHSCREEN_USB_PANJIT=y
> CONFIG_TOUCHSCREEN_USB_3M=y
> CONFIG_TOUCHSCREEN_USB_ITM=y
> CONFIG_TOUCHSCREEN_USB_ETURBO=y
> CONFIG_TOUCHSCREEN_USB_GUNZE=y
> CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
> CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
> CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
> CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
> CONFIG_TOUCHSCREEN_USB_GOTOP=y
> CONFIG_TOUCHSCREEN_USB_JASTEC=y
> CONFIG_TOUCHSCREEN_USB_ELO=y
> CONFIG_TOUCHSCREEN_USB_E2I=y
> CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
> CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
> CONFIG_TOUCHSCREEN_USB_NEXIO=y
> CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
> CONFIG_TOUCHSCREEN_TOUCHIT213=m
> # CONFIG_TOUCHSCREEN_TSC_SERIO is not set
> # CONFIG_TOUCHSCREEN_TSC2005 is not set
> CONFIG_TOUCHSCREEN_TSC2007=m
> # CONFIG_TOUCHSCREEN_ST1232 is not set
> CONFIG_TOUCHSCREEN_TPS6507X=m
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=m
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_APANEL is not set
> # CONFIG_INPUT_GP2A is not set
> CONFIG_INPUT_GPIO_TILT_POLLED=m
> # CONFIG_INPUT_WISTRON_BTNS is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_KXTJ9 is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_UINPUT=m
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_IMS_PCU is not set
> # CONFIG_INPUT_CMA3000 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> # CONFIG_SERIO_CT82C710 is not set
> CONFIG_SERIO_PCIPS2=m
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_SERIO_ARC_PS2 is not set
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> CONFIG_N_GSM=m
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_CS=m
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> # CONFIG_SERIAL_MAX310X is not set
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_IFX6X60 is not set
> CONFIG_SERIAL_PCH_UART=m
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> CONFIG_IPMI_HANDLER=m
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=m
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=m
> CONFIG_HW_RANDOM=m
> CONFIG_HW_RANDOM_TIMERIOMEM=m
> CONFIG_HW_RANDOM_INTEL=m
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_GEODE is not set
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_HW_RANDOM_TPM=m
> CONFIG_NVRAM=m
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> 
> #
> # PCMCIA character devices
> #
> # CONFIG_SYNCLINK_CS is not set
> # CONFIG_CARDMAN_4000 is not set
> # CONFIG_CARDMAN_4040 is not set
> # CONFIG_IPWIRELESS is not set
> # CONFIG_MWAVE is not set
> CONFIG_PC8736x_GPIO=m
> CONFIG_NSC_GPIO=m
> CONFIG_RAW_DRIVER=m
> CONFIG_MAX_RAW_DEVS=256
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=m
> CONFIG_TCG_TPM=m
> CONFIG_TCG_TIS=m
> CONFIG_TCG_TIS_I2C_INFINEON=m
> CONFIG_TCG_NSC=m
> CONFIG_TCG_ATMEL=m
> CONFIG_TCG_INFINEON=m
> # CONFIG_TCG_ST33_I2C is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=m
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=m
> CONFIG_I2C_ALGOBIT=m
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=m
> CONFIG_I2C_ISCH=m
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=m
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_CBUS_GPIO is not set
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> CONFIG_I2C_EG20T=m
> # CONFIG_I2C_GPIO is not set
> # CONFIG_I2C_INTEL_MID is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=m
> CONFIG_I2C_PARPORT_LIGHT=m
> CONFIG_I2C_TAOS_EVM=m
> CONFIG_I2C_TINY_USB=m
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_SCx200_ACB is not set
> CONFIG_I2C_STUB=m
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> # CONFIG_SPI_ALTERA is not set
> CONFIG_SPI_BITBANG=m
> # CONFIG_SPI_GPIO is not set
> # CONFIG_SPI_OC_TINY is not set
> # CONFIG_SPI_PXA2XX is not set
> # CONFIG_SPI_PXA2XX_PCI is not set
> # CONFIG_SPI_SC18IS602 is not set
> CONFIG_SPI_TOPCLIFF_PCH=m
> # CONFIG_SPI_XCOMM is not set
> # CONFIG_SPI_XILINX is not set
> # CONFIG_SPI_DESIGNWARE is not set
> 
> #
> # SPI Protocol Masters
> #
> # CONFIG_SPI_SPIDEV is not set
> CONFIG_SPI_TLE62X0=m
> 
> #
> # Qualcomm MSM SSBI bus support
> #
> # CONFIG_SSBI is not set
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_ACPI=y
> # CONFIG_GPIO_SYSFS is not set
> 
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> # CONFIG_GPIO_IT8761E is not set
> # CONFIG_GPIO_TS5500 is not set
> CONFIG_GPIO_SCH=m
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_MAX7300 is not set
> # CONFIG_GPIO_MAX732X is not set
> # CONFIG_GPIO_PCA953X is not set
> # CONFIG_GPIO_PCF857X is not set
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> # CONFIG_GPIO_LANGWELL is not set
> CONFIG_GPIO_PCH=m
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MAX7301 is not set
> # CONFIG_GPIO_MCP23S08 is not set
> # CONFIG_GPIO_MC33880 is not set
> # CONFIG_GPIO_74X164 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> 
> #
> # USB GPIO expanders:
> #
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> CONFIG_CHARGER_GPIO=m
> # CONFIG_CHARGER_MANAGER is not set
> # CONFIG_CHARGER_BQ2415X is not set
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_BATTERY_GOLDFISH is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> # CONFIG_HWMON_VID is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_AD7314 is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADCXX is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7310 is not set
> # CONFIG_SENSORS_ADT7410 is not set
> # CONFIG_SENSORS_ADT7411 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS620 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> CONFIG_SENSORS_GPIO_FAN=m
> # CONFIG_SENSORS_HIH6130 is not set
> CONFIG_SENSORS_CORETEMP=m
> # CONFIG_SENSORS_IBMAEM is not set
> # CONFIG_SENSORS_IBMPEX is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM70 is not set
> # CONFIG_SENSORS_LM73 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4151 is not set
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4261 is not set
> # CONFIG_SENSORS_LM95234 is not set
> # CONFIG_SENSORS_LM95241 is not set
> # CONFIG_SENSORS_LM95245 is not set
> # CONFIG_SENSORS_MAX1111 is not set
> # CONFIG_SENSORS_MAX16065 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_MAX6697 is not set
> # CONFIG_SENSORS_MCP3021 is not set
> # CONFIG_SENSORS_NCT6775 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> # CONFIG_SENSORS_SHT15 is not set
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_EMC1403 is not set
> # CONFIG_SENSORS_EMC2103 is not set
> # CONFIG_SENSORS_EMC6W201 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_SCH5627 is not set
> # CONFIG_SENSORS_SCH5636 is not set
> # CONFIG_SENSORS_ADS1015 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_ADS7871 is not set
> # CONFIG_SENSORS_AMC6821 is not set
> # CONFIG_SENSORS_INA209 is not set
> # CONFIG_SENSORS_INA2XX is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83795 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_SENSORS_APPLESMC is not set
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ACPI_POWER=m
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=m
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_CPU_THERMAL is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=m
> # CONFIG_ACQUIRE_WDT is not set
> # CONFIG_ADVANTECH_WDT is not set
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> # CONFIG_F71808E_WDT is not set
> # CONFIG_SP5100_TCO is not set
> # CONFIG_SC520_WDT is not set
> # CONFIG_SBC_FITPC2_WATCHDOG is not set
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> # CONFIG_IBMASR is not set
> # CONFIG_WAFER_WDT is not set
> CONFIG_I6300ESB_WDT=m
> CONFIG_IE6XX_WDT=m
> CONFIG_ITCO_WDT=m
> CONFIG_ITCO_VENDOR_SUPPORT=y
> # CONFIG_IT8712F_WDT is not set
> # CONFIG_IT87_WDT is not set
> # CONFIG_HP_WATCHDOG is not set
> # CONFIG_SC1200_WDT is not set
> # CONFIG_PC87413_WDT is not set
> # CONFIG_NV_TCO is not set
> # CONFIG_60XX_WDT is not set
> # CONFIG_SBC8360_WDT is not set
> # CONFIG_SBC7240_WDT is not set
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> # CONFIG_VIA_WDT is not set
> # CONFIG_W83627HF_WDT is not set
> # CONFIG_W83697HF_WDT is not set
> # CONFIG_W83697UG_WDT is not set
> # CONFIG_W83877F_WDT is not set
> # CONFIG_W83977F_WDT is not set
> # CONFIG_MACHZ_WDT is not set
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> 
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=m
> # CONFIG_MFD_CS5535 is not set
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_MFD_DA9052_SPI is not set
> # CONFIG_MFD_MC13XXX_SPI is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> CONFIG_LPC_ICH=m
> CONFIG_LPC_SCH=m
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_EZX_PCAP is not set
> # CONFIG_MFD_VIPERBOARD is not set
> # CONFIG_MFD_RETU is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> # CONFIG_MFD_SI476X_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_STMPE is not set
> # CONFIG_MFD_SYSCON is not set
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TPS65912 is not set
> # CONFIG_MFD_TPS65912_SPI is not set
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TIMBERDALE is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_ARIZONA_SPI is not set
> # CONFIG_MFD_WM831X_SPI is not set
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> # CONFIG_REGULATOR_DUMMY is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=m
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> CONFIG_REGULATOR_USERSPACE_CONSUMER=m
> CONFIG_REGULATOR_GPIO=m
> # CONFIG_REGULATOR_AD5398 is not set
> # CONFIG_REGULATOR_FAN53555 is not set
> # CONFIG_REGULATOR_ISL6271A is not set
> # CONFIG_REGULATOR_MAX1586 is not set
> # CONFIG_REGULATOR_MAX8649 is not set
> # CONFIG_REGULATOR_MAX8660 is not set
> # CONFIG_REGULATOR_MAX8952 is not set
> # CONFIG_REGULATOR_MAX8973 is not set
> # CONFIG_REGULATOR_LP3971 is not set
> # CONFIG_REGULATOR_LP3972 is not set
> # CONFIG_REGULATOR_LP8755 is not set
> # CONFIG_REGULATOR_TPS51632 is not set
> # CONFIG_REGULATOR_TPS62360 is not set
> # CONFIG_REGULATOR_TPS65023 is not set
> # CONFIG_REGULATOR_TPS6507X is not set
> # CONFIG_REGULATOR_TPS6524X is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> CONFIG_VGA_SWITCHEROO=y
> CONFIG_DRM=m
> CONFIG_DRM_KMS_HELPER=m
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=m
> 
> #
> # I2C encoder or helper chips
> #
> # CONFIG_DRM_I2C_CH7006 is not set
> # CONFIG_DRM_I2C_SIL164 is not set
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_NOUVEAU is not set
> # CONFIG_DRM_I810 is not set
> # CONFIG_DRM_I915 is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_VMWGFX is not set
> CONFIG_DRM_GMA500=m
> # CONFIG_DRM_GMA600 is not set
> # CONFIG_DRM_GMA3600 is not set
> # CONFIG_DRM_UDL is not set
> # CONFIG_DRM_AST is not set
> # CONFIG_DRM_MGAG200 is not set
> # CONFIG_DRM_CIRRUS_QEMU is not set
> # CONFIG_DRM_QXL is not set
> CONFIG_VGASTATE=m
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> CONFIG_HDMI=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> # CONFIG_FB_DDC is not set
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> CONFIG_FB_VGA16=m
> CONFIG_FB_UVESA=m
> CONFIG_FB_VESA=y
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_I810 is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_GOLDFISH is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> # CONFIG_FB_AUO_K190X is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> # CONFIG_LCD_L4F00242T03 is not set
> # CONFIG_LCD_LMS283GF05 is not set
> # CONFIG_LCD_LTV350QV is not set
> # CONFIG_LCD_ILI922X is not set
> # CONFIG_LCD_ILI9320 is not set
> # CONFIG_LCD_TDO24M is not set
> # CONFIG_LCD_VGG2432A4 is not set
> CONFIG_LCD_PLATFORM=m
> # CONFIG_LCD_S6E63M0 is not set
> # CONFIG_LCD_LD9040 is not set
> # CONFIG_LCD_AMS369FG06 is not set
> # CONFIG_LCD_LMS501KF03 is not set
> # CONFIG_LCD_HX8357 is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=m
> # CONFIG_BACKLIGHT_APPLE is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> # CONFIG_BACKLIGHT_LM3630 is not set
> # CONFIG_BACKLIGHT_LM3639 is not set
> # CONFIG_BACKLIGHT_LP855X is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_LOGO is not set
> CONFIG_SOUND=m
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_JACK=y
> CONFIG_SND_SEQUENCER=m
> CONFIG_SND_SEQ_DUMMY=m
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_SEQUENCER_OSS=y
> CONFIG_SND_HRTIMER=m
> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> CONFIG_SND_DYNAMIC_MINORS=y
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_KCTL_JACK=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=m
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_PCSP=m
> CONFIG_SND_DUMMY=m
> CONFIG_SND_ALOOP=m
> CONFIG_SND_VIRMIDI=m
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> CONFIG_SND_MPU401=m
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ASIHPI is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDA_INTEL=m
> CONFIG_SND_HDA_PREALLOC_SIZE=64
> CONFIG_SND_HDA_HWDEP=y
> CONFIG_SND_HDA_RECONFIG=y
> CONFIG_SND_HDA_INPUT_BEEP=y
> CONFIG_SND_HDA_INPUT_BEEP_MODE=1
> CONFIG_SND_HDA_INPUT_JACK=y
> CONFIG_SND_HDA_PATCH_LOADER=y
> CONFIG_SND_HDA_CODEC_REALTEK=y
> CONFIG_SND_HDA_CODEC_ANALOG=y
> CONFIG_SND_HDA_CODEC_SIGMATEL=y
> CONFIG_SND_HDA_CODEC_VIA=y
> CONFIG_SND_HDA_CODEC_HDMI=y
> CONFIG_SND_HDA_CODEC_CIRRUS=y
> CONFIG_SND_HDA_CODEC_CONEXANT=y
> CONFIG_SND_HDA_CODEC_CA0110=y
> CONFIG_SND_HDA_CODEC_CA0132=y
> # CONFIG_SND_HDA_CODEC_CA0132_DSP is not set
> CONFIG_SND_HDA_CODEC_CMEDIA=y
> CONFIG_SND_HDA_CODEC_SI3054=y
> CONFIG_SND_HDA_GENERIC=y
> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SIS7019 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> # CONFIG_SND_SPI is not set
> # CONFIG_SND_USB is not set
> # CONFIG_SND_PCMCIA is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> 
> #
> # HID support
> #
> CONFIG_HID=m
> CONFIG_HIDRAW=y
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=m
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=m
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=m
> # CONFIG_HID_APPLEIR is not set
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=m
> CONFIG_HID_CHERRY=m
> CONFIG_HID_CHICONY=m
> # CONFIG_HID_PRODIKEYS is not set
> CONFIG_HID_CYPRESS=m
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_ELECOM is not set
> CONFIG_HID_EZKEY=m
> # CONFIG_HID_HOLTEK is not set
> # CONFIG_HID_KEYTOUCH is not set
> # CONFIG_HID_KYE is not set
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=m
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=m
> # CONFIG_HID_LOGITECH_DJ is not set
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> # CONFIG_LOGIG940_FF is not set
> # CONFIG_LOGIWHEELS_FF is not set
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MICROSOFT=m
> CONFIG_HID_MONTEREY=m
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_PS3REMOTE is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_SAITEK is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SONY is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_STEELSERIES is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TIVO is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THINGM is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_WACOM is not set
> # CONFIG_HID_WIIMOTE is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> # CONFIG_HID_SENSOR_HUB is not set
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=m
> # CONFIG_HID_PID is not set
> # CONFIG_USB_HIDDEV is not set
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_ARCH_HAS_XHCI=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=m
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=m
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEFAULT_PERSIST=y
> CONFIG_USB_DYNAMIC_MINORS=y
> # CONFIG_USB_OTG is not set
> CONFIG_USB_MON=m
> CONFIG_USB_WUSB_CBAF=m
> # CONFIG_USB_WUSB_CBAF_DEBUG is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_XHCI_HCD=m
> # CONFIG_USB_XHCI_HCD_DEBUGGING is not set
> CONFIG_USB_EHCI_HCD=m
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_PCI=m
> # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> CONFIG_USB_OHCI_HCD=m
> # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=m
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> # CONFIG_USB_PRINTER is not set
> # CONFIG_USB_WDM is not set
> CONFIG_USB_TMC=m
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_REALTEK is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> CONFIG_USB_STORAGE_FREECOM=m
> CONFIG_USB_STORAGE_ISD200=m
> CONFIG_USB_STORAGE_USBAT=m
> CONFIG_USB_STORAGE_SDDR09=m
> CONFIG_USB_STORAGE_SDDR55=m
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> CONFIG_USB_STORAGE_ONETOUCH=m
> CONFIG_USB_STORAGE_KARMA=m
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> # CONFIG_USB_DWC3 is not set
> # CONFIG_USB_CHIPIDEA is not set
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> CONFIG_USB_SEVSEG=m
> CONFIG_USB_RIO500=m
> # CONFIG_USB_LEGOTOWER is not set
> CONFIG_USB_LCD=m
> CONFIG_USB_LED=m
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> CONFIG_USB_LD=m
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> CONFIG_USB_TEST=m
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_EZUSB_FX2=m
> # CONFIG_USB_HSIC_USB3503 is not set
> CONFIG_USB_ATM=m
> CONFIG_USB_SPEEDTOUCH=m
> CONFIG_USB_CXACRU=m
> CONFIG_USB_UEAGLEATM=m
> CONFIG_USB_XUSBATM=m
> # CONFIG_USB_PHY is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_LM3530 is not set
> # CONFIG_LEDS_LM3642 is not set
> # CONFIG_LEDS_PCA9532 is not set
> CONFIG_LEDS_GPIO=m
> # CONFIG_LEDS_LP3944 is not set
> # CONFIG_LEDS_LP5521 is not set
> # CONFIG_LEDS_LP5523 is not set
> # CONFIG_LEDS_LP5562 is not set
> # CONFIG_LEDS_CLEVO_MAIL is not set
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_PCA9633 is not set
> # CONFIG_LEDS_DAC124S085 is not set
> CONFIG_LEDS_REGULATOR=m
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_INTEL_SS4200 is not set
> # CONFIG_LEDS_LT3593 is not set
> # CONFIG_LEDS_DELL_NETBOOKS is not set
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> # CONFIG_LEDS_OT200 is not set
> # CONFIG_LEDS_BLINKM is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=m
> CONFIG_LEDS_TRIGGER_ONESHOT=m
> CONFIG_LEDS_TRIGGER_HEARTBEAT=m
> CONFIG_LEDS_TRIGGER_BACKLIGHT=m
> # CONFIG_LEDS_TRIGGER_CPU is not set
> # CONFIG_LEDS_TRIGGER_GPIO is not set
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> # CONFIG_LEDS_TRIGGER_CAMERA is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_MM_EDAC=m
> # CONFIG_EDAC_AMD76X is not set
> # CONFIG_EDAC_E7XXX is not set
> # CONFIG_EDAC_E752X is not set
> # CONFIG_EDAC_I82875P is not set
> # CONFIG_EDAC_I82975X is not set
> # CONFIG_EDAC_I3000 is not set
> # CONFIG_EDAC_I3200 is not set
> # CONFIG_EDAC_X38 is not set
> # CONFIG_EDAC_I5400 is not set
> # CONFIG_EDAC_I7CORE is not set
> # CONFIG_EDAC_I82860 is not set
> # CONFIG_EDAC_R82600 is not set
> # CONFIG_EDAC_I5000 is not set
> # CONFIG_EDAC_I5100 is not set
> # CONFIG_EDAC_I7300 is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_SYSTOHC=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF8523 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> # CONFIG_RTC_DRV_EM3027 is not set
> # CONFIG_RTC_DRV_RV3029C2 is not set
> 
> #
> # SPI RTC drivers
> #
> # CONFIG_RTC_DRV_M41T93 is not set
> # CONFIG_RTC_DRV_M41T94 is not set
> # CONFIG_RTC_DRV_DS1305 is not set
> # CONFIG_RTC_DRV_DS1390 is not set
> # CONFIG_RTC_DRV_MAX6902 is not set
> # CONFIG_RTC_DRV_R9701 is not set
> # CONFIG_RTC_DRV_RS5C348 is not set
> # CONFIG_RTC_DRV_DS3234 is not set
> # CONFIG_RTC_DRV_PCF2123 is not set
> # CONFIG_RTC_DRV_RX4581 is not set
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> # CONFIG_RTC_DRV_DS2404 is not set
> 
> #
> # on-CPU RTC drivers
> #
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
> CONFIG_DMADEVICES=y
> # CONFIG_DMADEVICES_DEBUG is not set
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> # CONFIG_INTEL_IOATDMA is not set
> # CONFIG_DW_DMAC is not set
> # CONFIG_TIMB_DMA is not set
> CONFIG_PCH_DMA=m
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> 
> #
> # DMA Clients
> #
> CONFIG_NET_DMA=y
> CONFIG_ASYNC_TX_DMA=y
> # CONFIG_DMATEST is not set
> # CONFIG_AUXDISPLAY is not set
> CONFIG_UIO=m
> # CONFIG_UIO_CIF is not set
> CONFIG_UIO_PDRV=m
> CONFIG_UIO_PDRV_GENIRQ=m
> # CONFIG_UIO_DMEM_GENIRQ is not set
> # CONFIG_UIO_AEC is not set
> # CONFIG_UIO_SERCOS3 is not set
> CONFIG_UIO_PCI_GENERIC=m
> # CONFIG_UIO_NETX is not set
> # CONFIG_VIRT_DRIVERS is not set
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> # CONFIG_ACERHDF is not set
> CONFIG_ASUS_LAPTOP=m
> # CONFIG_CHROMEOS_LAPTOP is not set
> # CONFIG_DELL_WMI is not set
> # CONFIG_DELL_WMI_AIO is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_AMILO_RFKILL is not set
> # CONFIG_TC1100_WMI is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_IDEAPAD_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
> CONFIG_EEEPC_LAPTOP=m
> CONFIG_ASUS_WMI=m
> CONFIG_ASUS_NB_WMI=m
> CONFIG_EEEPC_WMI=m
> CONFIG_ACPI_WMI=m
> CONFIG_MSI_WMI=m
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> CONFIG_ACPI_CMPC=m
> CONFIG_INTEL_IPS=m
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> # CONFIG_MXM_WMI is not set
> CONFIG_INTEL_OAKTRAIL=m
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_PVPANIC is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_MAILBOX is not set
> CONFIG_IOMMU_SUPPORT=y
> # CONFIG_INTEL_IOMMU is not set
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> # CONFIG_IPACK_BUS is not set
> # CONFIG_RESET_CONTROLLER is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> CONFIG_ISCSI_IBFT_FIND=y
> CONFIG_ISCSI_IBFT=m
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=m
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4_FS=m
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD=m
> # CONFIG_JBD_DEBUG is not set
> CONFIG_JBD2=m
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=m
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=m
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=m
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> CONFIG_GENERIC_ACL=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=m
> CONFIG_FSCACHE_STATS=y
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> CONFIG_CACHEFILES=m
> # CONFIG_CACHEFILES_DEBUG is not set
> # CONFIG_CACHEFILES_HISTOGRAM is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_VMCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=m
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=m
> CONFIG_SQUASHFS=m
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> CONFIG_SQUASHFS_LZO=y
> CONFIG_SQUASHFS_XZ=y
> # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> # CONFIG_SQUASHFS_EMBEDDED is not set
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_QNX6FS_FS is not set
> CONFIG_ROMFS_FS=m
> CONFIG_ROMFS_BACKED_BY_BLOCK=y
> CONFIG_ROMFS_ON_BLOCK=y
> CONFIG_PSTORE=y
> # CONFIG_PSTORE_CONSOLE is not set
> # CONFIG_PSTORE_RAM is not set
> # CONFIG_SYSV_FS is not set
> CONFIG_UFS_FS=m
> # CONFIG_UFS_FS_WRITE is not set
> # CONFIG_UFS_DEBUG is not set
> # CONFIG_EXOFS_FS is not set
> # CONFIG_F2FS_FS is not set
> CONFIG_ORE=m
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V2=m
> CONFIG_NFS_V3=m
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=m
> # CONFIG_NFS_SWAP is not set
> CONFIG_NFS_V4_1=y
> CONFIG_PNFS_FILE_LAYOUT=m
> CONFIG_PNFS_BLOCK=m
> CONFIG_PNFS_OBJLAYOUT=m
> CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
> CONFIG_NFS_FSCACHE=y
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> CONFIG_NFS_DEBUG=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_SUNRPC_BACKCHANNEL=y
> CONFIG_RPCSEC_GSS_KRB5=m
> CONFIG_SUNRPC_DEBUG=y
> CONFIG_CEPH_FS=m
> CONFIG_CIFS=m
> # CONFIG_CIFS_STATS is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_UPCALL=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_CIFS_ACL=y
> # CONFIG_CIFS_DEBUG is not set
> CONFIG_CIFS_DFS_UPCALL=y
> # CONFIG_CIFS_SMB2 is not set
> CONFIG_CIFS_FSCACHE=y
> # CONFIG_NCP_FS is not set
> CONFIG_CODA_FS=m
> CONFIG_AFS_FS=m
> # CONFIG_AFS_DEBUG is not set
> CONFIG_AFS_FSCACHE=y
> CONFIG_9P_FS=m
> CONFIG_9P_FSCACHE=y
> CONFIG_9P_FS_POSIX_ACL=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=m
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=m
> CONFIG_NLS_CODEPAGE_852=m
> CONFIG_NLS_CODEPAGE_855=m
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=m
> CONFIG_NLS_CODEPAGE_861=m
> CONFIG_NLS_CODEPAGE_862=m
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=m
> CONFIG_NLS_CODEPAGE_866=m
> CONFIG_NLS_CODEPAGE_869=m
> CONFIG_NLS_CODEPAGE_936=m
> CONFIG_NLS_CODEPAGE_950=m
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=m
> CONFIG_NLS_CODEPAGE_874=m
> CONFIG_NLS_ISO8859_8=m
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=m
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=m
> CONFIG_NLS_ISO8859_5=m
> CONFIG_NLS_ISO8859_6=m
> CONFIG_NLS_ISO8859_7=m
> CONFIG_NLS_ISO8859_9=m
> CONFIG_NLS_ISO8859_13=m
> CONFIG_NLS_ISO8859_14=m
> CONFIG_NLS_ISO8859_15=m
> CONFIG_NLS_KOI8_R=m
> CONFIG_NLS_KOI8_U=m
> # CONFIG_NLS_MAC_ROMAN is not set
> # CONFIG_NLS_MAC_CELTIC is not set
> # CONFIG_NLS_MAC_CENTEURO is not set
> # CONFIG_NLS_MAC_CROATIAN is not set
> # CONFIG_NLS_MAC_CYRILLIC is not set
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> # CONFIG_NLS_MAC_ROMANIAN is not set
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=m
> CONFIG_DLM=m
> CONFIG_DLM_DEBUG=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_STRIP_ASM_SYMS=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> # CONFIG_DEBUG_KERNEL is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> # CONFIG_FRAME_POINTER is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> # CONFIG_LKDTM is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_ASYNC_RAID6_TEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_TEST_STRING_HELPERS is not set
> # CONFIG_TEST_KSTRTOX is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_DEBUG_SET_MODULE_RONX=y
> CONFIG_DOUBLEFAULT=y
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> CONFIG_OPTIMIZE_INLINING=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_TRUSTED_KEYS is not set
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=m
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_ASYNC_PQ=m
> CONFIG_ASYNC_RAID6_RECOV=m
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_FIPS=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=m
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=m
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=m
> CONFIG_CRYPTO_NULL=m
> CONFIG_CRYPTO_PCRYPT=m
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=m
> CONFIG_CRYPTO_AUTHENC=m
> CONFIG_CRYPTO_TEST=m
> CONFIG_CRYPTO_ABLK_HELPER_X86=m
> CONFIG_CRYPTO_GLUE_HELPER_X86=m
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=m
> CONFIG_CRYPTO_GCM=m
> CONFIG_CRYPTO_SEQIV=m
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=m
> CONFIG_CRYPTO_CTR=m
> CONFIG_CRYPTO_CTS=m
> CONFIG_CRYPTO_ECB=m
> CONFIG_CRYPTO_LRW=m
> CONFIG_CRYPTO_PCBC=m
> CONFIG_CRYPTO_XTS=m
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=m
> CONFIG_CRYPTO_XCBC=m
> CONFIG_CRYPTO_VMAC=m
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=m
> CONFIG_CRYPTO_CRC32C_INTEL=m
> CONFIG_CRYPTO_CRC32=m
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_GHASH=m
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=m
> CONFIG_CRYPTO_RMD128=m
> CONFIG_CRYPTO_RMD160=m
> CONFIG_CRYPTO_RMD256=m
> CONFIG_CRYPTO_RMD320=m
> CONFIG_CRYPTO_SHA1=m
> CONFIG_CRYPTO_SHA256=m
> CONFIG_CRYPTO_SHA512=m
> CONFIG_CRYPTO_TGR192=m
> CONFIG_CRYPTO_WP512=m
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=m
> CONFIG_CRYPTO_AES_NI_INTEL=m
> CONFIG_CRYPTO_ANUBIS=m
> CONFIG_CRYPTO_ARC4=m
> CONFIG_CRYPTO_BLOWFISH=m
> CONFIG_CRYPTO_BLOWFISH_COMMON=m
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_CAST_COMMON=m
> CONFIG_CRYPTO_CAST5=m
> CONFIG_CRYPTO_CAST6=m
> CONFIG_CRYPTO_DES=m
> CONFIG_CRYPTO_FCRYPT=m
> CONFIG_CRYPTO_KHAZAD=m
> CONFIG_CRYPTO_SALSA20=m
> CONFIG_CRYPTO_SALSA20_586=m
> CONFIG_CRYPTO_SEED=m
> CONFIG_CRYPTO_SERPENT=m
> CONFIG_CRYPTO_SERPENT_SSE2_586=m
> CONFIG_CRYPTO_TEA=m
> CONFIG_CRYPTO_TWOFISH=m
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_586=m
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_ZLIB=m
> CONFIG_CRYPTO_LZO=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_USER_API=m
> CONFIG_CRYPTO_USER_API_HASH=m
> CONFIG_CRYPTO_USER_API_SKCIPHER=m
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=m
> CONFIG_CRYPTO_DEV_PADLOCK_AES=m
> CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
> CONFIG_CRYPTO_DEV_GEODE=m
> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=m
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=m
> CONFIG_CRC16=m
> CONFIG_CRC_T10DIF=m
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=m
> CONFIG_LIBCRC32C=m
> CONFIG_CRC8=m
> CONFIG_AUDIT_GENERIC=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_LRU_CACHE=m
> CONFIG_AVERAGE=y
> CONFIG_CORDIC=m
> # CONFIG_DDR is not set
> CONFIG_OID_REGISTRY=m

