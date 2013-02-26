Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab3BZMZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:25:50 -0500
Received: from [84.200.39.61] ([84.200.39.61]:41843 "EHLO smtp.eikelenboom.it"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab3BZMZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:25:47 -0500
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2013 07:25:46 EST
Date: Tue, 26 Feb 2013 13:19:11 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <587120702.20130226131911@eikelenboom.it>
To: linux-kernel@vger.kernel.org
Subject: 3.9-rc0: Boot fails:  RIP: 0010:[<ffffffff810d4e9a>]  [<ffffffff810d4e9a>] stop_machine_cpu_stop+0x8a/0x160
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Current tip (with last commit id: c41b3810c09e60664433548c5218cc6ece6a8903 (Merge tag 'pm+acpi-fixes-3.9-rc1') fails to boot with:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc0-20130226 (root@serveerstertje) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP PREEMPT Tue Feb 26 10:31:29 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc0-20130226 root=/dev/mapper/serveerstertje-root ro nomodeset verbose mem=1024M vga=794 video=vesafb acpi_enforce_resources=lax r8169.use_dac=1 max_loop=50 loop_max_part=10 debug loglevel=10 kmemleak=on console=vga console=ttyS0,38400 earlyprint=serial,ttyS0,38
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e4000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000aff8ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000aff90000-0x00000000aff9dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000aff9e000-0x00000000affdffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000affe0000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000024fffffff] usable
[    0.000000] e820: remove [mem 0x40000000-0xfffffffffffffffe] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] user: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000e4000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x000000003fffffff] usable
[    0.000000] user: [mem 0x00000000aff90000-0x00000000aff9dfff] ACPI data
[    0.000000] user: [mem 0x00000000aff9e000-0x00000000affdffff] ACPI NVS
[    0.000000] user: [mem 0x00000000affe0000-0x00000000afffffff] reserved
[    0.000000] user: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x40000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 0000A0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000250000000 aka 9472M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xb0000000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] ACPI: RSDP 00000000000fb100 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000aff90000 00048 (v01 MSI    OEMSLIC  20100913 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000aff90200 00084 (v01 7640MS A7640100 20100913 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000aff905e0 09427 (v01  A7640 A7640100 00000100 INTL 20051117)
[    0.000000] ACPI: FACS 00000000aff9e000 00040
[    0.000000] ACPI: APIC 00000000aff90390 00088 (v01 7640MS A7640100 20100913 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000aff90420 0003C (v01 7640MS OEMMCFG  20100913 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000aff90460 00176 (v01 MSI    OEMSLIC  20100913 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000aff9e040 00072 (v01 7640MS A7640100 20100913 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000aff9a5e0 00108 (v03 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 00000000aff9a6f0 00038 (v01 7640MS OEMHPET  20100913 MSFT 00000097)
[    0.000000] ACPI: IVRS 00000000aff9a730 00100 (v01  AMD     RD890S 00202031 AMD  00000000)
[    0.000000] ACPI: SSDT 00000000aff9a830 00DA4 (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff] 
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xafffffff] 
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x24fffffff] 
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02949000, 0x02949fff] PGTABLE
[    0.000000] BRK [0x0294a000, 0x0294afff] PGTABLE
[    0.000000] BRK [0x0294b000, 0x0294bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3fe00000-0x3fffffff]
[    0.000000]  [mem 0x3fe00000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3c000000-0x3fdfffff]
[    0.000000]  [mem 0x3c000000-0x3fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x3bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3bffffff] page 2M
[    0.000000] RAMDISK: [mem 0x37acd000-0x37feffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0x3fffffff] -> [mem 0x00000000-0x3fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x3fffffff]
[    0.000000]   NODE_DATA [mem 0x3fff5000-0x3fffffff]
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003e600000-ffff88003f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3fffffff]
[    0.000000] On node 0 totalpages: 262046
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 258048 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec20000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-55
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 72
[    0.000000] e820: [mem 0x40000000-0xaff8ffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:6 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88003fc00000 s81984 r8192 d24512 u262144
[    0.000000] pcpu-alloc: s81984 r8192 d24512 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257929
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc0-20130226 root=/dev/mapper/serveerstertje-root ro nomodeset verbose mem=1024M vga=794 video=vesafb acpi_enforce_resources=lax r8169.use_dac=1 max_loop=50 loop_max_part=10 debug loglevel=10 kmemleak=on console=vga console=ttyS0,38400 earlyprint=serial,ttyS0,38400
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 38000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 38000000
[    0.000000] Memory: 934160k/1048576k available (9958k kernel code, 392k absent, 114024k reserved, 5309k data, 1068k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=6.
[    0.000000] NR_IRQS:4352 nr_irqs:1272 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.003333] tsc: Fast TSC calibration using PIT
[    0.006666] tsc: Detected 3200.197 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6402.07 BogoMIPS (lpj=10667323)
[    0.032031] pid_max: default: 32768 minimum: 301
[    0.046219] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.067881] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.088618] Mount-cache hash table entries: 256
[    0.104007] Initializing cgroup subsys cpuacct
[    0.117294] Initializing cgroup subsys freezer
[    0.130587] Initializing cgroup subsys blkio
[    0.143500] tseg: 0000000000
[    0.152133] CPU: Physical Processor ID: 0
[    0.164111] CPU: Processor Core ID: 0
[    0.175058] mce: CPU supports 6 MCE banks
[    0.187049] LVT offset 0 assigned for vector 0xf9
[    0.201112] process: using AMD E400 aware idle routine
[    0.216476] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.216476] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.216476] tlb_flushall_shift: 4
[    0.260294] Freeing SMP alternatives: 32k freed
[    0.274450] ACPI: Core revision 20130117
[    0.333218] ACPI: All ACPI Tables successfully acquired
[    0.351574] [Firmware Bug]: AMD-Vi: IOAPIC[6] not in IVRS table
[    0.369281] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
[    0.390623] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)
[    0.410145] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.461105] smpboot: CPU0: AMD Phenom(tm) II X6 1090T Processor (fam: 10, model: 0a, stepping: 00)
[    0.591782] Performance Events: AMD PMU driver.
[    0.605346] ... version:                0
[    0.617325] ... bit width:              48
[    0.629559] ... generic registers:      4
[    0.641533] ... value mask:             0000ffffffffffff
[    0.657406] ... max period:             00007fffffffffff
[    0.673279] ... fixed-purpose events:   0
[    0.685251] ... event mask:             000000000000000f
[    0.701517] process: System has AMD C1E enabled
[    0.715067] process: Switch to broadcast mode on CPU0
[    0.736159] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.760574] SMP alternatives: lockdep: fixing up alternatives
[    0.777800] smpboot: Booting Node   0, Processors  #1[    0.806595] process: Switch to broadcast mode on CPU1
[    0.807111] SMP alternatives: lockdep: fixing up alternatives
[    0.807113]  #2[    0.820240] process: Switch to broadcast mode on CPU2
[    0.820680] SMP alternatives: lockdep: fixing up alternatives
[    0.820681]  #3[    0.833928] process: Switch to broadcast mode on CPU3
[    0.834226] SMP alternatives: lockdep: fixing up alternatives
[    0.834227]  #4[    0.847484] process: Switch to broadcast mode on CPU4
[    0.847781] SMP alternatives: lockdep: fixing up alternatives
[    0.847782]  #5 OK
[    0.860925] Brought up 6 CPUs
[    0.860928] smpboot: Total of 6 processors activated (38417.46 BogoMIPS)
[    0.861045] process: Switch to broadcast mode on CPU5
[   28.789095] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:8]
[   28.808360] Modules linked in:
[   28.817485] irq event stamp: 67226
[   28.827639] hardirqs last  enabled at (67225): [<ffffffff819b4637>] restore_args+0x0/0x30
[   28.852118] hardirqs last disabled at (67226): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   28.878922] softirqs last  enabled at (67224): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   28.904169] softirqs last disabled at (67219): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   28.928895] CPU 0 
[   28.934369] Pid: 8, comm: migration/0 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   28.964034] RIP: 0010:[<ffffffff810d4e9a>]  [<ffffffff810d4e9a>] stop_machine_cpu_stop+0x8a/0x160
[   28.990581] RSP: 0000:ffff88003da7dcd8  EFLAGS: 00000293
[   29.006453] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   29.027786] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   29.049119] RBP: ffff88003da7dd18 R08: 0000000000000000 R09: 0000000000000001
[   29.070452] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003da7dc48
[   29.091785] R13: ffff88003da80000 R14: ffff88003da7c000 R15: ffff88003da7dfd8
[   29.113118] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   29.137312] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   29.154485] CR2: ffff880002949000 CR3: 0000000001e0c000 CR4: 00000000000007f0
[   29.175817] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.197151] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   29.218484] Process migration/0 (pid: 8, threadinfo ffff88003da7c000, task ffff88003da80000)
[   29.243716] Stack:
[   29.249710]  ffff88003fc0e3c0 000000003fc0e420 ffff88003da7dcf8 ffff88003fc0e3c0
[   29.271874]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003da7c010
[   29.294040]  ffff88003da7dde8 ffffffff810d4b1d ffff88003da7dfd8 ffff88003fc0e400
[   29.316204] Call Trace:
[   29.323501]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   29.341713]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   29.359406]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   29.377617]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   29.397910]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   29.415344]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   29.435638]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   29.453330]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   29.472323]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   29.486896]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.505629]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   29.521761]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.540494] Code: 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 74 53 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c7 48 83 3d df a3 d4 
[   29.629114] BUG: soft lockup - CPU#2 stuck for 23s! [migration/2:23]
[   29.642448] BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
[   29.642450] Modules linked in:
[   29.642450] irq event stamp: 68628
[   29.642456] hardirqs last  enabled at (68627): [<ffffffff819b4637>] restore_args+0x0/0x30
[   29.642458] hardirqs last disabled at (68628): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   29.642461] softirqs last  enabled at (68626): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   29.642462] softirqs last disabled at (68621): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   29.642465] CPU 3 
[   29.642465] Pid: 29, comm: migration/3 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   29.642469] RIP: 0010:[<ffffffff810d4e9a>]  [<ffffffff810d4e9a>] stop_machine_cpu_stop+0x8a/0x160
[   29.642470] RSP: 0000:ffff88003e237cd8  EFLAGS: 00000293
[   29.642470] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   29.642471] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   29.642471] RBP: ffff88003e237d18 R08: 0000000000000000 R09: 0000000000000001
[   29.642472] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003e237c48
[   29.642473] R13: ffff88003dae5230 R14: ffff88003e236000 R15: ffff88003e237fd8
[   29.642474] FS:  0000000000000000(0000) GS:ffff88003fcc0000(0000) knlGS:0000000000000000
[   29.642474] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   29.642475] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   29.642476] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.642476] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   29.642477] Process migration/3 (pid: 29, threadinfo ffff88003e236000, task ffff88003dae5230)
[   29.642478] Stack:
[   29.642480]  ffff88003fcce3c0 000000003fcce420 ffff88003e237cf8 ffff88003fcce3c0
[   29.642482]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003e236010
[   29.642483]  ffff88003e237de8 ffffffff810d4b1d ffff88003e237fd8 ffff88003fcce400
[   29.642484] Call Trace:
[   29.642486]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   29.642488]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   29.642489]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   29.642491]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   29.642493]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   29.642494]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   29.642497]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   29.642499]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   29.642501]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   29.642503]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.642505]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   29.642506]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.642522] Code: 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 74 53 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c7 48 83 3d df a3 d4 
[   29.655782] BUG: soft lockup - CPU#4 stuck for 23s! [migration/4:35]
[   29.655784] Modules linked in:
[   29.655784] irq event stamp: 68660
[   29.655790] hardirqs last  enabled at (68659): [<ffffffff819b4637>] restore_args+0x0/0x30
[   29.655792] hardirqs last disabled at (68660): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   29.655795] softirqs last  enabled at (68658): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   29.655796] softirqs last disabled at (68653): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   29.655799] CPU 4 
[   29.655799] Pid: 35, comm: migration/4 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   29.655803] RIP: 0010:[<ffffffff810d4e9e>]  [<ffffffff810d4e9e>] stop_machine_cpu_stop+0x8e/0x160
[   29.655803] RSP: 0000:ffff88003db17cd8  EFLAGS: 00000293
[   29.655804] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   29.655805] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   29.655805] RBP: ffff88003db17d18 R08: 0000000000000000 R09: 0000000000000001
[   29.655806] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003db17c48
[   29.655806] R13: ffff88003db041c0 R14: ffff88003db16000 R15: ffff88003db17fd8
[   29.655807] FS:  0000000000000000(0000) GS:ffff88003fd00000(0000) knlGS:0000000000000000
[   29.655808] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   29.655809] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   29.655809] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.655810] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   29.655811] Process migration/4 (pid: 35, threadinfo ffff88003db16000, task ffff88003db041c0)
[   29.655811] Stack:
[   29.655814]  ffff88003fd0e3c0 000000003fd0e420 ffff88003db17cf8 ffff88003fd0e3c0
[   29.655816]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003db16010
[   29.655817]  ffff88003db17de8 ffffffff810d4b1d ffff88003db17fd8 ffff88003fd0e400
[   29.655818] Call Trace:
[   29.655820]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   29.655822]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   29.655823]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   29.655825]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   29.655827]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   29.655828]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   29.655831]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   29.655832]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   29.655834]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   29.655837]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.655838]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   29.655840]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.655856] Code: 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 74 53 44 89 e8 f3 90 44 8b 6b 20 <41> 39 c5 74 ec 41 83 fd 02 75 c7 48 83 3d df a3 d4 00 00 0f 84 
[   29.669104] BUG: soft lockup - CPU#5 stuck for 23s! [migration/5:41]
[   29.669106] Modules linked in:
[   29.669106] irq event stamp: 68514
[   29.669111] hardirqs last  enabled at (68513): [<ffffffff819b4637>] restore_args+0x0/0x30
[   29.669113] hardirqs last disabled at (68514): [<ffffffff819b456d>] common_interrupt+0x6d/0x72
[   29.669115] softirqs last  enabled at (68512): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   29.669117] softirqs last disabled at (68507): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   29.669120] CPU 5 
[   29.669120] Pid: 41, comm: migration/5 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   29.669123] RIP: 0010:[<ffffffff810d4e93>]  [<ffffffff810d4e93>] stop_machine_cpu_stop+0x83/0x160
[   29.669124] RSP: 0000:ffff88003db4bcd8  EFLAGS: 00000293
[   29.669125] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   29.669126] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   29.669126] RBP: ffff88003db4bd18 R08: 0000000000000000 R09: 0000000000000001
[   29.669127] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003db4bc48
[   29.669127] R13: ffff88003db2b150 R14: ffff88003db4a000 R15: 0000000000000001
[   29.669128] FS:  0000000000000000(0000) GS:ffff88003fd40000(0000) knlGS:0000000000000000
[   29.669129] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   29.669129] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   29.669130] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   29.669131] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   29.669132] Process migration/5 (pid: 41, threadinfo ffff88003db4a000, task ffff88003db2b150)
[   29.669132] Stack:
[   29.669134]  ffff88003fd4e3c0 000000003fd4e420 ffff88003db4bcf8 ffff88003fd4e3c0
[   29.669136]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003db4a010
[   29.669138]  ffff88003db4bde8 ffffffff810d4b1d ffff88003db4bfd8 ffff88003fd4e400
[   29.669138] Call Trace:
[   29.669140]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   29.669142]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   29.669143]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   29.669145]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   29.669147]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   29.669148]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   29.669151]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   29.669153]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   29.669155]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   29.669157]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.669159]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   29.669161]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   29.669177] Code: 00 00 31 c0 eb 2a 66 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 <74> 53 44 89 e8 f3 90 44 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 
[   32.070531] Modules linked in:
[   32.079655] irq event stamp: 241196
[   32.090068] hardirqs last  enabled at (241195): [<ffffffff819b4637>] restore_args+0x0/0x30
[   32.114807] hardirqs last disabled at (241196): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   32.141872] softirqs last  enabled at (241194): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   32.167378] softirqs last disabled at (241169): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   32.192366] CPU 2 
[   32.197841] Pid: 23, comm: migration/2 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   32.227763] RIP: 0010:[<ffffffff810d4e9a>]  [<ffffffff810d4e9a>] stop_machine_cpu_stop+0x8a/0x160
[   32.254311] RSP: 0000:ffff88003d99fcd8  EFLAGS: 00000293
[   32.270183] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   32.291517] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   32.312850] RBP: ffff88003d99fd18 R08: 0000000000000000 R09: 0000000000000001
[   32.334182] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003d99fc48
[   32.355515] R13: ffff88003dabe2a0 R14: ffff88003d99e000 R15: ffff88003d99ffd8
[   32.376848] FS:  0000000000000000(0000) GS:ffff88003fc80000(0000) knlGS:0000000000000000
[   32.401042] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   32.418215] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   32.439547] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   32.460881] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   32.482214] Process migration/2 (pid: 23, threadinfo ffff88003d99e000, task ffff88003dabe2a0)
[   32.507706] Stack:
[   32.513698]  ffff88003fc8e3c0 000000003fc8e420 ffff88003d99fcf8 ffff88003fc8e3c0
[   32.535864]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003d99e010
[   32.558029]  ffff88003d99fde8 ffffffff810d4b1d ffff88003d99ffd8 ffff88003fc8e400
[   32.580194] Call Trace:
[   32.587490]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   32.605701]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   32.623395]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   32.641607]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   32.661902]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   32.679333]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   32.699628]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   32.717321]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   32.736314]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   32.750886]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   32.769620]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   32.785751]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   32.804483] Code: 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 74 53 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c7 48 83 3d df a3 d4 
[   57.593125] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:8]
[   57.611865] Modules linked in:
[   57.620991] irq event stamp: 134420
[   57.631404] hardirqs last  enabled at (134419): [<ffffffff819b4637>] restore_args+0x0/0x30
[   57.656128] hardirqs last disabled at (134420): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   57.683195] softirqs last  enabled at (134418): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   57.708701] softirqs last disabled at (134413): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   57.733688] CPU 0 
[   57.739162] Pid: 8, comm: migration/0 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   57.768827] RIP: 0010:[<ffffffff810d4e9a>]  [<ffffffff810d4e9a>] stop_machine_cpu_stop+0x8a/0x160
[   57.795373] RSP: 0000:ffff88003da7dcd8  EFLAGS: 00000293
[   57.811245] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   57.832578] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   57.853912] RBP: ffff88003da7dd18 R08: 0000000000000000 R09: 0000000000000001
[   57.875246] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003da7dc48
[   57.896577] R13: ffff88003da80000 R14: ffff88003da7c000 R15: ffff88003da7dfd8
[   57.918248] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   57.942662] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   57.959965] CR2: ffff880002949000 CR3: 0000000001e0c000 CR4: 00000000000007f0
[   57.981442] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   58.002930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   58.024499] Process migration/0 (pid: 8, threadinfo ffff88003da7c000, task ffff88003da80000)
[   58.049861] Stack:
[   58.055983]  ffff88003fc0e3c0 000000003fc0e420 ffff88003da7dcf8 ffff88003fc0e3c0
[   58.078265]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003da7c010
[   58.100858]  ffff88003da7dde8 ffffffff810d4b1d ffff88003da7dfd8 ffff88003fc0e400
[   58.123129] Call Trace:
[   58.130423]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   58.148856]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   58.166681]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   58.185022]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   58.205447]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   58.222996]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   58.243420]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   58.261372]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   58.280495]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   58.295198]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.314073]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   58.330324]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.349174] Code: 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 74 53 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c7 48 83 3d df a3 d4 
[   58.439810] BUG: soft lockup - CPU#2 stuck for 23s! [migration/2:23]
[   58.449810] BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
[   58.449811] Modules linked in:
[   58.449811] irq event stamp: 137276
[   58.449812] hardirqs last  enabled at (137275): [<ffffffff819b4637>] restore_args+0x0/0x30
[   58.449814] hardirqs last disabled at (137276): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   58.449816] softirqs last  enabled at (137274): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   58.449817] softirqs last disabled at (137269): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   58.449819] CPU 3 
[   58.449819] Pid: 29, comm: migration/3 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   58.449821] RIP: 0010:[<ffffffff810d4e9a>]  [<ffffffff810d4e9a>] stop_machine_cpu_stop+0x8a/0x160
[   58.449822] RSP: 0000:ffff88003e237cd8  EFLAGS: 00000293
[   58.449822] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   58.449823] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   58.449823] RBP: ffff88003e237d18 R08: 0000000000000000 R09: 0000000000000001
[   58.449824] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003e237c48
[   58.449825] R13: ffff88003dae5230 R14: ffff88003e236000 R15: ffff88003e237fd8
[   58.449825] FS:  0000000000000000(0000) GS:ffff88003fcc0000(0000) knlGS:0000000000000000
[   58.449826] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   58.449827] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   58.449827] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   58.449828] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   58.449829] Process migration/3 (pid: 29, threadinfo ffff88003e236000, task ffff88003dae5230)
[   58.449829] Stack:
[   58.449831]  ffff88003fcce3c0 000000003fcce420 ffff88003e237cf8 ffff88003fcce3c0
[   58.449832]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003e236010
[   58.449834]  ffff88003e237de8 ffffffff810d4b1d ffff88003e237fd8 ffff88003fcce400
[   58.449834] Call Trace:
[   58.449836]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   58.449838]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   58.449839]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   58.449841]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   58.449842]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   58.449844]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   58.449845]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   58.449847]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   58.449849]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   58.449851]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.449852]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   58.449854]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.449870] Code: 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 74 53 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c7 48 83 3d df a3 d4 
[   58.466476] BUG: soft lockup - CPU#4 stuck for 23s! [migration/4:35]
[   58.466477] Modules linked in:
[   58.466477] irq event stamp: 137316
[   58.466479] hardirqs last  enabled at (137315): [<ffffffff819b4637>] restore_args+0x0/0x30
[   58.466481] hardirqs last disabled at (137316): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   58.466482] softirqs last  enabled at (137314): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   58.466484] softirqs last disabled at (137309): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   58.466485] CPU 4 
[   58.466486] Pid: 35, comm: migration/4 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   58.466487] RIP: 0010:[<ffffffff810d4e8f>]  [<ffffffff810d4e8f>] stop_machine_cpu_stop+0x7f/0x160
[   58.466488] RSP: 0000:ffff88003db17cd8  EFLAGS: 00000246
[   58.466489] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   58.466489] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   58.466490] RBP: ffff88003db17d18 R08: 0000000000000000 R09: 0000000000000001
[   58.466490] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003db17c48
[   58.466491] R13: ffff88003db041c0 R14: ffff88003db16000 R15: ffff88003db17fd8
[   58.466492] FS:  0000000000000000(0000) GS:ffff88003fd00000(0000) knlGS:0000000000000000
[   58.466492] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   58.466493] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   58.466494] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   58.466494] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   58.466495] Process migration/4 (pid: 35, threadinfo ffff88003db16000, task ffff88003db041c0)
[   58.466495] Stack:
[   58.466497]  ffff88003fd0e3c0 000000003fd0e420 ffff88003db17cf8 ffff88003fd0e3c0
[   58.466499]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003db16010
[   58.466500]  ffff88003db17de8 ffffffff810d4b1d ffff88003db17fd8 ffff88003fd0e400
[   58.466501] Call Trace:
[   58.466502]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   58.466504]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   58.466505]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   58.466507]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   58.466508]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   58.466510]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   58.466512]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   58.466513]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   58.466515]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   58.466517]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.466519]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   58.466520]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.466536] Code: 45 cc 00 00 00 00 31 c0 eb 2a 66 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 <41> 83 fd 04 74 53 44 89 e8 f3 90 44 8b 6b 20 41 39 c5 74 ec 41 
[   58.479801] BUG: soft lockup - CPU#5 stuck for 23s! [migration/5:41]
[   58.479802] Modules linked in:
[   58.479802] irq event stamp: 137096
[   58.479804] hardirqs last  enabled at (137095): [<ffffffff819b4637>] restore_args+0x0/0x30
[   58.479805] hardirqs last disabled at (137096): [<ffffffff819b456d>] common_interrupt+0x6d/0x72
[   58.479807] softirqs last  enabled at (137094): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   58.479808] softirqs last disabled at (137089): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   58.479810] CPU 5 
[   58.479810] Pid: 41, comm: migration/5 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   58.479812] RIP: 0010:[<ffffffff810d4e8f>]  [<ffffffff810d4e8f>] stop_machine_cpu_stop+0x7f/0x160
[   58.479812] RSP: 0000:ffff88003db4bcd8  EFLAGS: 00000246
[   58.479813] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   58.479813] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   58.479814] RBP: ffff88003db4bd18 R08: 0000000000000000 R09: 0000000000000001
[   58.479815] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003db4bc48
[   58.479815] R13: ffff88003db2b150 R14: ffff88003db4a000 R15: 0000000000000001
[   58.479816] FS:  0000000000000000(0000) GS:ffff88003fd40000(0000) knlGS:0000000000000000
[   58.479817] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   58.479817] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   58.479818] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   58.479819] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   58.479819] Process migration/5 (pid: 41, threadinfo ffff88003db4a000, task ffff88003db2b150)
[   58.479820] Stack:
[   58.479821]  ffff88003fd4e3c0 000000003fd4e420 ffff88003db4bcf8 ffff88003fd4e3c0
[   58.479823]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003db4a010
[   58.479825]  ffff88003db4bde8 ffffffff810d4b1d ffff88003db4bfd8 ffff88003fd4e400
[   58.479825] Call Trace:
[   58.479827]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   58.479828]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   58.479830]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   58.479831]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   58.479833]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   58.479834]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   58.479836]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   58.479838]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   58.479839]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   58.479841]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.479843]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   58.479844]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   58.479860] Code: 45 cc 00 00 00 00 31 c0 eb 2a 66 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 <41> 83 fd 04 74 53 44 89 e8 f3 90 44 8b 6b 20 41 39 c5 74 ec 41 
[   60.905013] Modules linked in:
[   60.914138] irq event stamp: 455582
[   60.924657] hardirqs last  enabled at (455581): [<ffffffff819b4637>] restore_args+0x0/0x30
[   60.949642] hardirqs last disabled at (455582): [<ffffffff819b5bed>] apic_timer_interrupt+0x6d/0x80
[   60.976812] softirqs last  enabled at (455580): [<ffffffff81071751>] __do_softirq+0x161/0x1d0
[   61.002578] softirqs last disabled at (455555): [<ffffffff819b633c>] call_softirq+0x1c/0x30
[   61.027693] CPU 2 
[   61.033284] Pid: 23, comm: migration/2 Not tainted 3.8.0-rc0-20130226 #1 MSI MS-7640/890FXA-GD70 (MS-7640)  
[   61.063456] RIP: 0010:[<ffffffff810d4e9a>]  [<ffffffff810d4e9a>] stop_machine_cpu_stop+0x8a/0x160
[   61.090121] RSP: 0000:ffff88003d99fcd8  EFLAGS: 00000293
[   61.106123] RAX: 0000000000000001 RBX: ffffffff819b4637 RCX: 0000000000000000
[   61.127717] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003da11dc8
[   61.149179] RBP: ffff88003d99fd18 R08: 0000000000000000 R09: 0000000000000001
[   61.170642] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003d99fc48
[   61.192236] R13: ffff88003dabe2a0 R14: ffff88003d99e000 R15: ffff88003d99ffd8
[   61.213698] FS:  0000000000000000(0000) GS:ffff88003fc80000(0000) knlGS:0000000000000000
[   61.238152] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   61.255454] CR2: 0000000000000000 CR3: 0000000001e0c000 CR4: 00000000000007e0
[   61.276918] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   61.298394] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   61.319973] Process migration/2 (pid: 23, threadinfo ffff88003d99e000, task ffff88003dabe2a0)
[   61.345610] Stack:
[   61.351720]  ffff88003fc8e3c0 000000003fc8e420 ffff88003d99fcf8 ffff88003fc8e3c0
[   61.374002]  ffff88003da11d08 ffffffff810d4e10 ffff88003da11dc8 ffff88003d99e010
[   61.396335]  ffff88003d99fde8 ffffffff810d4b1d ffff88003d99ffd8 ffff88003fc8e400
[   61.418618] Call Trace:
[   61.425911]  [<ffffffff810d4e10>] ? stop_one_cpu_nowait+0x30/0x30
[   61.444341]  [<ffffffff810d4b1d>] cpu_stopper_thread+0x8d/0x170
[   61.462168]  [<ffffffff810d49fd>] ? cpu_stop_should_run+0x2d/0x60
[   61.480511]  [<ffffffff819b4115>] ? _raw_spin_unlock_irqrestore+0x75/0xa0
[   61.500936]  [<ffffffff810b30cd>] ? trace_hardirqs_on+0xd/0x10
[   61.518485]  [<ffffffff819b40f3>] ? _raw_spin_unlock_irqrestore+0x53/0xa0
[   61.538907]  [<ffffffff81092f6e>] smpboot_thread_fn+0x1ce/0x2d0
[   61.556861]  [<ffffffff81092da0>] ? smpboot_create_threads+0x80/0x80
[   61.575983]  [<ffffffff8108a276>] kthread+0xd6/0xe0
[   61.590688]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   61.609536]  [<ffffffff819b4ebc>] ret_from_fork+0x7c/0xb0
[   61.625801]  [<ffffffff8108a1a0>] ? __init_kthread_worker+0x70/0x70
[   61.644662] Code: 90 41 83 fd 03 74 52 f0 41 ff 0e 0f 94 c0 84 c0 74 0e 8b 43 20 8b 53 10 ff c0 89 53 24 89 43 20 41 83 fd 04 74 53 44 89 e8 f3 90 <44> 8b 6b 20 41 39 c5 74 ec 41 83 fd 02 75 c7 48 83 3d df a3 d4 
[   62.469907] INFO: rcu_preempt detected stalls on CPUs/tasks:
[   62.486959]  (detected by 2, t=18008 jiffies, g=18446744073709551325, c=18446744073709551324, q=6)
[   62.513867] INFO: Stall ended before state dump start

--
Sander

