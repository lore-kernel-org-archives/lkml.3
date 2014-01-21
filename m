Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaAULD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 06:03:58 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:51212 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbaAULDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:03:53 -0500
X-Greylist: delayed 1764 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jan 2014 06:03:52 EST
Date: Tue, 21 Jan 2014 12:34:24 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 3.13: BUG: unable to handle kernel paging request at
 00000000b4343e88
Message-ID: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My HP DL585 G1 gets a the following BUG on module load with 3.13. Have 
not noticed it with any earlier kernel, including 3.13-rc8.

BUG: unable to handle kernel paging request at 00000000b4343e88

This is somewhat reproducible - on second boot, it was ordered 
differently with respect to other boot messages. Second dmesg is also 
below.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0 (mroos@dl585) (gcc version 4.7.2 (Debian 4.7.2-5) ) #45 SMP Tue Jan 21 11:57:29 EET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfff67ff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfff6800-0x00000000bfffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000fdc00000-0x00000000fdc00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fdc10000-0x00000000fdc10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fdc20000-0x00000000fdc20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fdc30000-0x00000000fdc30fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000003ffffefff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: HP ProLiant DL585 G1, BIOS A01 02/14/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x3fffff max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FFC0000000 write-back
[    0.000000]   1 base 0000000000 mask FF80000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FE00000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbfff6 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f4fa0-0x000f4faf] mapped at [ffff8800000f4fa0]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02106000, 0x02106fff] PGTABLE
[    0.000000] BRK [0x02107000, 0x02107fff] PGTABLE
[    0.000000] BRK [0x02108000, 0x02108fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3ffc00000-0x3ffdfffff]
[    0.000000]  [mem 0x3ffc00000-0x3ffdfffff] page 2M
[    0.000000] BRK [0x02109000, 0x02109fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3fc000000-0x3ffbfffff]
[    0.000000]  [mem 0x3fc000000-0x3ffbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x380000000-0x3fbffffff]
[    0.000000]  [mem 0x380000000-0x3fbffffff] page 2M
[    0.000000] BRK [0x0210a000, 0x0210afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbfff5fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbfff5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x37fffffff]
[    0.000000]  [mem 0x100000000-0x37fffffff] page 2M
[    0.000000] BRK [0x0210b000, 0x0210bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3ffe00000-0x3ffffefff]
[    0.000000]  [mem 0x3ffe00000-0x3ffffefff] page 4k
[    0.000000] ACPI: RSDP 00000000000f4f20 000024 (v02 HP    )
[    0.000000] ACPI: XSDT 00000000bfff6c00 000044 (v01 HP     A01      00000002   \xffffffd2? 0000162E)
[    0.000000] ACPI: FACP 00000000bfff6c80 0000F4 (v03 HP     A01      00000002   \xffffffd2? 0000162E)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20131115/tbfadt-653)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1bControlBlock: 32, using default 16 (20131115/tbfadt-653)
[    0.000000] ACPI: DSDT 00000000bfff6d80 0051D5 (v01 HP         DSDT 00000001 MSFT 02000001)
[    0.000000] ACPI: FACS 00000000bfff68c0 000040
[    0.000000] ACPI: APIC 00000000bfff6900 0000D0 (v01 HP     00000083 00000002      00000000)
[    0.000000] ACPI: SPCR 00000000bfff6a00 000050 (v01 HP     SPCRRBSU 00000001   \xffffffd2? 0000162E)
[    0.000000] ACPI: SRAT 00000000bfff6a80 000150 (v01 HP     A01      00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 1 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x01 -> Node 1
[    0.000000] SRAT: PXM 3 -> APIC 0x02 -> Node 2
[    0.000000] SRAT: PXM 4 -> APIC 0x03 -> Node 3
[    0.000000] SRAT: Node 0 PXM 1 [mem 0x00000000-0xffffffff]
[    0.000000] SRAT: Node 1 PXM 2 [mem 0x100000000-0x1ffffffff]
[    0.000000] SRAT: Node 2 PXM 3 [mem 0x200000000-0x2ffffffff]
[    0.000000] SRAT: Node 3 PXM 4 [mem 0x300000000-0x3ffffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xffffffff]
[    0.000000]   NODE_DATA [mem 0xbfff3000-0xbfff5fff]
[    0.000000] Initmem setup node 1 [mem 0x100000000-0x1ffffffff]
[    0.000000]   NODE_DATA [mem 0x1ffffd000-0x1ffffffff]
[    0.000000] Initmem setup node 2 [mem 0x200000000-0x2ffffffff]
[    0.000000]   NODE_DATA [mem 0x2ffffd000-0x2ffffffff]
[    0.000000] Initmem setup node 3 [mem 0x300000000-0x3ffffefff]
[    0.000000]   NODE_DATA [mem 0x3ffffc000-0x3ffffefff]
[    0.000000]  [ffffea0000000000-ffffea0002ffffff] PMD -> [ffff8800bce00000-ffff8800bfdfffff] on node 0
[    0.000000]  [ffffea0004000000-ffffea0007ffffff] PMD -> [ffff8801fbe00000-ffff8801ffdfffff] on node 1
[    0.000000]  [ffffea0008000000-ffffea000bffffff] PMD -> [ffff8802fbe00000-ffff8802ffdfffff] on node 2
[    0.000000]  [ffffea000c000000-ffffea000fffffff] PMD -> [ffff8803fb400000-ffff8803ff3fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x3ffffefff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xbfff5fff]
[    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
[    0.000000]   node   2: [mem 0x200000000-0x2ffffffff]
[    0.000000]   node   3: [mem 0x300000000-0x3ffffefff]
[    0.000000] On node 0 totalpages: 786324
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12224 pages used for memmap
[    0.000000]   DMA32 zone: 782326 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 1048575
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1048575 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, version 17, address 0xfec10000, GSI 24-27
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec20000] gsi_base[28])
[    0.000000] IOAPIC[2]: apic_id 6, version 17, address 0xfec20000, GSI 28-31
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfdc00000] gsi_base[32])
[    0.000000] IOAPIC[3]: apic_id 7, version 17, address 0xfdc00000, GSI 32-35
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfdc10000] gsi_base[36])
[    0.000000] IOAPIC[4]: apic_id 8, version 17, address 0xfdc10000, GSI 36-39
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfdc20000] gsi_base[40])
[    0.000000] IOAPIC[5]: apic_id 9, version 17, address 0xfdc20000, GSI 40-43
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfdc30000] gsi_base[44])
[    0.000000] IOAPIC[6]: apic_id 10, version 17, address 0xfdc30000, GSI 44-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfff6000-0xbfff6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfff7000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xfdbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc00000-0xfdc00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc01000-0xfdc0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc10000-0xfdc10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc11000-0xfdc1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc20000-0xfdc20fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc21000-0xfdc2ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc30000-0xfdc30fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc31000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfec1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec20000-0xfec20fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec21000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee10000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xfdbfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8 nr_node_ids:4
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bcc00000 s76032 r8192 d22272 u1048576
[    0.000000] pcpu-alloc: s76032 r8192 d22272 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 4 [1] 1 5 [2] 2 6 [3] 3 7 
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 3870590
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ fc3e000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ b4000000
[    0.000000] PM: Registered nosave memory: [mem 0xb4000000-0xb7ffffff]
[    0.000000] Memory: 15332028K/15728204K available (6233K kernel code, 2939K rwdata, 1276K rodata, 872K init, 3348K bss, 396176K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] NR_IRQS:4352 nr_irqs:1152 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2197.041 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.012227] Calibrating delay loop (skipped), value calculated using timer frequency.. 4394.08 BogoMIPS (lpj=8788164)
[    0.012655] pid_max: default: 32768 minimum: 301
[    0.015382] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.032886] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.041065] Mount-cache hash table entries: 256
[    0.041702] Initializing cgroup subsys memory
[    0.041931] Initializing cgroup subsys devices
[    0.042138] Initializing cgroup subsys freezer
[    0.042346] Initializing cgroup subsys net_cls
[    0.042549] Initializing cgroup subsys blkio
[    0.042755] Initializing cgroup subsys perf_event
[    0.042965] Initializing cgroup subsys hugetlb
[    0.043212] tseg: 0000000000
[    0.043227] mce: CPU supports 5 MCE banks
[    0.043455] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.043455] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.043455] tlb_flushall_shift: 4
[    0.044068] Freeing SMP alternatives memory: 20K (ffffffff81dba000 - ffffffff81dbf000)
[    0.044404] ACPI: Core revision 20131115
[    0.048403] ACPI: All ACPI Tables successfully acquired
[    0.049673] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.089566] smpboot: CPU0: AMD Opteron (tm) Processor 848 (fam: 0f, model: 05, stepping: 08)
[    0.092000] Performance Events: AMD PMU driver.
[    0.092000] ... version:                0
[    0.092000] ... bit width:              48
[    0.092000] ... generic registers:      4
[    0.092000] ... value mask:             0000ffffffffffff
[    0.092000] ... max period:             00007fffffffffff
[    0.092000] ... fixed-purpose events:   0
[    0.092000] ... event mask:             000000000000000f
[    0.092000] x86: Booting SMP configuration:
[    0.101933] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.092000] .... node  #1, CPUs:      #1
[    0.180576] .... node  #2, CPUs:   #2
[    0.268542] .... node  #3, CPUs:   #3
[    0.356220] x86: Booted up 4 nodes, 4 CPUs
[    0.356539] smpboot: Total of 4 processors activated (17577.77 BogoMIPS)
[    0.358680] devtmpfs: initialized
[    0.358680] gcov: version magic: 0x3430372a
[    0.360280] NET: Registered protocol family 16
[    0.360584] cpuidle: using governor ladder
[    0.360752] cpuidle: using governor menu
[    0.360925] node 0 link 0: io port [1000, 5fff]
[    0.360929] node 1 link 0: io port [6000, ffff]
[    0.360931] TOM: 00000000c0000000 aka 3072M
[    0.361100] node 0 link 0: mmio [f5f00000, f7ffffff]
[    0.361105] node 0 link 0: mmio [f5e00000, f5efffff]
[    0.361108] node 0 link 0: mmio [a0000, bffff]
[    0.361111] node 0 link 0: mmio [fe000000, ffffffff]
[    0.361113] node 1 link 0: mmio [f8000000, fdffffff]
[    0.361116] TOM2: 0000000400000000 aka 16384M
[    0.361289] bus: [bus 00-03] on node 0 link 0
[    0.361291] bus: 00 [io  0x0000-0x5fff]
[    0.361293] bus: 00 [mem 0xc0000000-0xf7ffffff]
[    0.361295] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.361297] bus: 00 [mem 0xfe000000-0xffffffff]
[    0.361299] bus: 00 [mem 0x400000000-0xfcffffffff]
[    0.361301] bus: [bus 04-08] on node 1 link 0
[    0.361302] bus: 04 [io  0x6000-0xffff]
[    0.361304] bus: 04 [mem 0xf8000000-0xfdffffff]
[    0.361321] ACPI: bus type PCI registered
[    0.361547] PCI: Using configuration type 1 for base access
[    0.361922] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.362098] mtrr: probably your BIOS does not setup all CPUs.
[    0.362272] mtrr: corrected configuration.
[    0.363094] bio: create slab <bio-0> at 0
[    0.363094] ACPI: Added _OSI(Module Device)
[    0.364016] ACPI: Added _OSI(Processor Device)
[    0.364186] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.364355] ACPI: Added _OSI(Processor Aggregator Device)
[    0.369476] ACPI: Interpreter enabled
[    0.369653] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.370053] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.370451] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131115/hwxface-580)
[    0.370859] ACPI: (supports S0 S4 S5)
[    0.371025] ACPI: Using IOAPIC for interrupt routing
[    0.371240] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.379134] ACPI: PCI Root Bridge [CFG0] (domain 0000 [bus 00-03])
[    0.379326] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.379507] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.381434] acpi PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
[    0.381438] acpi PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
[    0.381441] acpi PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
[    0.381444] acpi PNP0A03:00: host bridge window [io  0x03e0-0x0fff] (ignored)
[    0.381446] acpi PNP0A03:00: host bridge window [io  0x1000-0x5fff] (ignored)
[    0.381450] acpi PNP0A03:00: host bridge window [mem 0xf5f00000-0xf7ffffff] (ignored)
[    0.381453] acpi PNP0A03:00: host bridge window [mem 0xf5e00000-0xf5efffff] (ignored)
[    0.381456] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.381460] PCI: root bus 00: hardware-probed resources
[    0.381471] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.381830] PCI host bridge to bus 0000:00
[    0.382001] pci_bus 0000:00: root bus resource [bus 00-03]
[    0.382175] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
[    0.382352] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xf7ffffff]
[    0.382532] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.382712] pci_bus 0000:00: root bus resource [mem 0xfe000000-0xffffffff]
[    0.382892] pci_bus 0000:00: root bus resource [mem 0x400000000-0xfcffffffff]
[    0.383098] pci 0000:00:03.0: [1022:7460] type 01 class 0x060400
[    0.383261] pci 0000:00:04.0: [1022:7468] type 00 class 0x060100
[    0.383386] pci 0000:00:04.1: [1022:7469] type 00 class 0x01018a
[    0.383423] pci 0000:00:04.1: reg 0x20: [io  0x2000-0x200f]
[    0.383504] pci 0000:00:04.3: [1022:746b] type 00 class 0x068000
[    0.383638] pci 0000:00:07.0: [1022:7450] type 01 class 0x060400
[    0.383748] pci 0000:00:07.1: [1022:7451] type 00 class 0x080010
[    0.383852] pci 0000:00:08.0: [1022:7450] type 01 class 0x060400
[    0.383959] pci 0000:00:08.1: [1022:7451] type 00 class 0x080010
[    0.384098] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.384186] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.384257] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.384329] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.384406] pci 0000:00:19.0: [1022:1100] type 00 class 0x060000
[    0.384496] pci 0000:00:19.1: [1022:1101] type 00 class 0x060000
[    0.384570] pci 0000:00:19.2: [1022:1102] type 00 class 0x060000
[    0.384637] pci 0000:00:19.3: [1022:1103] type 00 class 0x060000
[    0.384723] pci 0000:00:1a.0: [1022:1100] type 00 class 0x060000
[    0.384810] pci 0000:00:1a.1: [1022:1101] type 00 class 0x060000
[    0.384885] pci 0000:00:1a.2: [1022:1102] type 00 class 0x060000
[    0.384959] pci 0000:00:1a.3: [1022:1103] type 00 class 0x060000
[    0.385031] pci 0000:00:1b.0: [1022:1100] type 00 class 0x060000
[    0.385117] pci 0000:00:1b.1: [1022:1101] type 00 class 0x060000
[    0.385188] pci 0000:00:1b.2: [1022:1102] type 00 class 0x060000
[    0.385263] pci 0000:00:1b.3: [1022:1103] type 00 class 0x060000
[    0.385404] pci 0000:01:00.0: [1022:7464] type 00 class 0x0c0310
[    0.385421] pci 0000:01:00.0: reg 0x10: [mem 0xf7ef0000-0xf7ef0fff]
[    0.385534] pci 0000:01:00.1: [1022:7464] type 00 class 0x0c0310
[    0.385550] pci 0000:01:00.1: reg 0x10: [mem 0xf7ee0000-0xf7ee0fff]
[    0.385679] pci 0000:01:02.0: [0e11:b203] type 00 class 0x088000
[    0.385700] pci 0000:01:02.0: reg 0x10: [io  0x4800-0x48ff]
[    0.385712] pci 0000:01:02.0: reg 0x14: [mem 0xf7eb0000-0xf7eb01ff]
[    0.385855] pci 0000:01:02.2: [0e11:b204] type 00 class 0x088000
[    0.385878] pci 0000:01:02.2: reg 0x10: [io  0x4000-0x40ff]
[    0.385891] pci 0000:01:02.2: reg 0x14: [mem 0xf7ea0000-0xf7ea07ff]
[    0.385904] pci 0000:01:02.2: reg 0x18: [mem 0xf7e90000-0xf7e91fff]
[    0.385917] pci 0000:01:02.2: reg 0x1c: [mem 0xf7e00000-0xf7e7ffff]
[    0.385951] pci 0000:01:02.2: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.385988] pci 0000:01:02.2: PME# supported from D0 D3hot D3cold
[    0.386073] pci 0000:01:03.0: [1002:4752] type 00 class 0x030000
[    0.386093] pci 0000:01:03.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.386106] pci 0000:01:03.0: reg 0x14: [io  0x4400-0x44ff]
[    0.386118] pci 0000:01:03.0: reg 0x18: [mem 0xf5ff0000-0xf5ff0fff]
[    0.386159] pci 0000:01:03.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.386194] pci 0000:01:03.0: supports D1 D2
[    0.386288] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.386464] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.386469] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.386538] pci 0000:02:04.0: [0e11:b178] type 00 class 0x010400
[    0.386558] pci 0000:02:04.0: reg 0x10: [mem 0xf7fc0000-0xf7ffffff 64bit]
[    0.386566] pci 0000:02:04.0: reg 0x18: [io  0x5000-0x50ff]
[    0.386577] pci 0000:02:04.0: reg 0x1c: [mem 0xf5ef0000-0xf5ef3fff 64bit pref]
[    0.386590] pci 0000:02:04.0: reg 0x30: [mem 0x00000000-0x00003fff pref]
[    0.386620] pci 0000:02:04.0: supports D1
[    0.386695] pci 0000:02:06.0: [14e4:1648] type 00 class 0x020000
[    0.386711] pci 0000:02:06.0: reg 0x10: [mem 0xf7fb0000-0xf7fbffff 64bit]
[    0.386768] pci 0000:02:06.0: PME# supported from D3hot D3cold
[    0.386837] pci 0000:02:06.1: [14e4:1648] type 00 class 0x020000
[    0.386853] pci 0000:02:06.1: reg 0x10: [mem 0xf7fa0000-0xf7faffff 64bit]
[    0.386910] pci 0000:02:06.1: PME# supported from D3hot D3cold
[    0.386997] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.387173] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.387177] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.387182] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.387348] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.388612] ACPI: PCI Root Bridge [CFG1] (domain 0000 [bus 04-08])
[    0.388793] acpi PNP0A03:01: _OSC: OS supports [Segments MSI]
[    0.388972] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.390613] acpi PNP0A03:01: host bridge window [io  0x6000-0xffff] (ignored)
[    0.390616] PCI: root bus 04: hardware-probed resources
[    0.390621] acpi PNP0A03:01: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.390962] PCI host bridge to bus 0000:04
[    0.391131] pci_bus 0000:04: root bus resource [bus 04-08]
[    0.391305] pci_bus 0000:04: root bus resource [io  0x6000-0xffff]
[    0.391482] pci_bus 0000:04: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.391681] pci 0000:04:09.0: [1022:7450] type 01 class 0x060400
[    0.391794] pci 0000:04:09.1: [1022:7451] type 00 class 0x080010
[    0.391899] pci 0000:04:0a.0: [1022:7450] type 01 class 0x060400
[    0.392014] pci 0000:04:0a.1: [1022:7451] type 00 class 0x080010
[    0.392127] pci 0000:04:0b.0: [1022:7450] type 01 class 0x060400
[    0.392227] pci 0000:04:0b.1: [1022:7451] type 00 class 0x080010
[    0.392315] pci 0000:04:0c.0: [1022:7450] type 01 class 0x060400
[    0.392409] pci 0000:04:0c.1: [1022:7451] type 00 class 0x080010
[    0.392633] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.392931] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.393259] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.393578] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.393996] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 *7 10 11)
[    0.394642] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 7 *10 11)
[    0.395284] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 7 10 *11)
[    0.395926] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *5 7 10 11)
[    0.396645] ACPI: \_SB_.CFG0: notify handler is installed
[    0.396671] ACPI: \_SB_.CFG1: notify handler is installed
[    0.396703] Found 2 acpi root devices
[    0.396870] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    0.396870] vgaarb: loaded
[    0.396870] vgaarb: bridge control possible 0000:01:03.0
[    0.396870] SCSI subsystem initialized
[    0.397002] PCI: Using ACPI for IRQ routing
[    0.397172] PCI: pci_cache_line_size set to 64 bytes
[    0.397260] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.397265] e820: reserve RAM buffer [mem 0xbfff6800-0xbfffffff]
[    0.397267] e820: reserve RAM buffer [mem 0x3fffff000-0x3ffffffff]
[    0.397563] Switched to clocksource refined-jiffies
[    0.397563] pnp: PnP ACPI init
[    0.397563] ACPI: bus type PNP registered
[    0.397563] system 00:00: [io  0x0230-0x0233] has been reserved
[    0.397563] system 00:00: [io  0x0260-0x0267] has been reserved
[    0.400014] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.400197] system 00:00: [io  0x0800-0x081f] has been reserved
[    0.400377] system 00:00: [io  0x0900-0x0903] has been reserved
[    0.400559] system 00:00: [io  0x0904-0x0907] has been reserved
[    0.400740] system 00:00: [io  0x0908-0x090b] has been reserved
[    0.400921] system 00:00: [io  0x090c-0x092e] has been reserved
[    0.401103] system 00:00: [io  0x092f] has been reserved
[    0.401281] system 00:00: [io  0x0930-0x09ff] has been reserved
[    0.401462] system 00:00: [io  0x0c80-0x0c87] has been reserved
[    0.401644] system 00:00: [io  0x0cf9] could not be reserved
[    0.401824] system 00:00: [io  0x02f8-0x02ff] has been reserved
[    0.402012] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.402034] pnp 00:01: [dma 7]
[    0.402070] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.402106] pnp 00:02: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.402179] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.402225] pnp 00:04: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.402264] pnp 00:05: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.402536] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.402733] pnp 00:07: [dma 2]
[    0.402784] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.403034] pnp: PnP ACPI: found 8 devices
[    0.403207] ACPI: bus type PNP unregistered
[    0.410262] Switched to clocksource acpi_pm
[    0.410262] pci 0000:00:03.0: BAR 15: assigned [mem 0xc0000000-0xc00fffff pref]
[    0.410262] pci 0000:01:03.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
[    0.410262] pci 0000:01:02.2: BAR 6: assigned [mem 0xc0020000-0xc002ffff pref]
[    0.410262] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.410262] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.410262] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.410262] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xc00fffff pref]
[    0.410262] pci 0000:02:04.0: BAR 6: assigned [mem 0xf5e00000-0xf5e03fff pref]
[    0.410385] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.410564] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.410746] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.410933] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.411218] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.411402] pci_bus 0000:00: resource 4 [io  0x0000-0x5fff]
[    0.411406] pci_bus 0000:00: resource 5 [mem 0xc0000000-0xf7ffffff]
[    0.411409] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.411412] pci_bus 0000:00: resource 7 [mem 0xfe000000-0xffffffff]
[    0.411415] pci_bus 0000:00: resource 8 [mem 0x400000000-0xfcffffffff]
[    0.411418] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    0.411421] pci_bus 0000:01: resource 1 [mem 0xf5f00000-0xf7efffff]
[    0.411424] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc00fffff pref]
[    0.411427] pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
[    0.411430] pci_bus 0000:02: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    0.411433] pci_bus 0000:02: resource 2 [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.411464] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.411649] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.411833] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.412032] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.412215] pci_bus 0000:04: resource 4 [io  0x6000-0xffff]
[    0.412218] pci_bus 0000:04: resource 5 [mem 0xf8000000-0xfdffffff]
[    0.412380] NET: Registered protocol family 2
[    0.413090] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.414480] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.415517] TCP: Hash tables configured (established 131072 bind 65536)
[    0.415825] TCP: reno registered
[    0.416137] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.416605] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.417201] NET: Registered protocol family 1
[    0.417418] pci 0000:00:04.3: boot interrupts on device [1022:746b] already disabled
[    0.417706] pci 0000:00:07.0: MSI quirk detected; subordinate MSI disabled
[    0.417892] pci 0000:00:07.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.418082] pci 0000:00:08.0: MSI quirk detected; subordinate MSI disabled
[    0.418268] pci 0000:00:08.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.560094] pci 0000:01:03.0: Boot video device
[    0.560111] pci 0000:04:09.0: MSI quirk detected; subordinate MSI disabled
[    0.560304] pci 0000:04:09.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.560535] pci 0000:04:0a.0: MSI quirk detected; subordinate MSI disabled
[    0.560760] pci 0000:04:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.560993] pci 0000:04:0b.0: MSI quirk detected; subordinate MSI disabled
[    0.561218] pci 0000:04:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.561451] pci 0000:04:0c.0: MSI quirk detected; subordinate MSI disabled
[    0.561668] pci 0000:04:0c.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.561896] PCI: CLS 64 bytes, default 64
[    0.564784] PCI-DMA: Disabling AGP.
[    0.565374] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    0.565552] PCI-DMA: using GART IOMMU.
[    0.565727] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.575606] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.593214] gcov: could not create file
[    0.659644] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.664181] msgmni has been set to 30074
[    0.664751] cryptomgr_test (65) used greatest stack depth: 7224 bytes left
[    0.664991] cryptomgr_test (66) used greatest stack depth: 6840 bytes left
[    0.665329] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.665624] io scheduler noop registered
[    0.665791] io scheduler deadline registered
[    0.666017] io scheduler cfq registered (default)
[    0.666305] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.666614] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.666895] ACPI: Power Button [PWRF]
[    0.667116] ACPI: processor limited to max C-state 1
[    0.667510] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.688224] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.730243] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    0.731109] Linux agpgart interface v0.103
[    0.731298] HP CISS Driver (v 3.6.26)
[    0.731839] cciss 0000:02:04.0: Controller reports max supported commands of 0, an obvious lie. Using 16.  Ensure that firmware is up to date.
[    0.872416] cciss 0000:02:04.0: cciss0: <0xb178> at PCI 0000:02:04.0 IRQ 18 using DAC
[    0.877382]  cciss/c0d0: p1 p2 < p5 >
[    0.878191] scsi0 : cciss
[    0.878585] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.880785] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.880994] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.881387] mousedev: PS/2 mouse device common for all mice
[    0.881739] rtc_cmos rtc_cmos: RTC can wake from S4
[    0.882205] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.882524] rtc_cmos rtc_cmos: alarms up to one year, y3k, 114 bytes nvram
[    0.882997] TCP: cubic registered
[    0.883414] NET: Registered protocol family 10
[    0.883936] NET: Registered protocol family 17
[    0.884175] Key type dns_resolver registered
[    0.884741] registered taskstats version 1
[    0.887179] rtc_cmos rtc_cmos: setting system clock to 2014-01-21 10:31:39 UTC (1390300299)
[    0.933094] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.941431] EXT4-fs (cciss!c0d0p1): couldn't mount as ext3 due to feature incompatibilities
[    0.942217] EXT4-fs (cciss!c0d0p1): couldn't mount as ext2 due to feature incompatibilities
[    0.953652] EXT4-fs (cciss!c0d0p1): mounted filesystem with ordered data mode. Opts: (null)
[    0.954025] VFS: Mounted root (ext4 filesystem) readonly on device 104:1.
[    0.969624] devtmpfs: mounted
[    0.971649] Freeing unused kernel memory: 872K (ffffffff81ce0000 - ffffffff81dba000)
[    0.971936] Write protecting the kernel read-only data: 10240k
[    0.979810] Freeing unused kernel memory: 1912K (ffff880001622000 - ffff880001800000)
[    0.983189] Freeing unused kernel memory: 772K (ffff88000193f000 - ffff880001a00000)
[    1.408114] modprobe (80) used greatest stack depth: 4616 bytes left
[    2.155425] udevd[198]: starting version 175
[    2.416089] shpchp 0000:00:07.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.416394] shpchp 0000:00:07.0: Cannot reserve MMIO region
[    2.416689] shpchp 0000:00:08.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.416987] shpchp 0000:00:08.0: Cannot reserve MMIO region
[    2.417342] shpchp 0000:04:09.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.417690] shpchp 0000:04:09.0: Cannot reserve MMIO region
[    2.417972] shpchp 0000:04:0a.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.418265] shpchp 0000:04:0a.0: Cannot reserve MMIO region
[    2.418470] shpchp 0000:04:0b.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.418761] shpchp 0000:04:0b.0: Cannot reserve MMIO region
[    2.418959] shpchp 0000:04:0c.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.419253] shpchp 0000:04:0c.0: Cannot reserve MMIO region
[    2.419515] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.425824] ioapic: probe of 0000:00:07.1 failed with error -22
[    2.427377] ioapic: probe of 0000:00:08.1 failed with error -22
[    2.427607] ioapic: probe of 0000:04:09.1 failed with error -22
[    2.427809] ioapic: probe of 0000:04:0a.1 failed with error -22
[    2.428098] ioapic: probe of 0000:04:0b.1 failed with error -22
[    2.428300] ioapic: probe of 0000:04:0c.1 failed with error -22
[    2.449575] libata version 3.00 loaded.
[    2.453281] AMD768 RNG detected
[    2.454634] pata_amd 0000:00:04.1: version 0.4.1
[    2.470241] scsi1 : pata_amd
[    2.484421] scsi2 : pata_amd
[    2.484862] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
[    2.485093] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
[    2.504619] hpwdt 0000:01:02.0: This server does not have an iLO2+ ASIC.
[    2.523020] pps_core: LinuxPPS API ver. 1 registered
[    2.523242] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.548143] ACPI: bus type USB registered
[    2.548486] usbcore: registered new interface driver usbfs
[    2.548730] usbcore: registered new interface driver hub
[    2.555879] usbcore: registered new device driver usb
[    2.567628] PTP clock support registered
[    2.594803] tg3.c:v3.134 (Sep 16, 2013)
[    2.606767] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.617386] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.634146] BUG: unable to handle kernel paging request at 00000000b4343e88
[    2.634499] IP: [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.634766] PGD 0 
[    2.635009] Oops: 0000 [#1] SMP 
[    2.635210] Floppy drive(s): fd0 is 1.44M
[    2.635718] Modules linked in: floppy(+) edac_core(+) pcspkr k8temp(+) ehci_hcd tg3(+) ptp usbcore pps_core libphy hpwdt hpilo usb_common i2c_amd756 i2c_core pata_amd amd_rng libata ioapic evdev shpchp
[    2.636037] CPU: 2 PID: 368 Comm: modprobe Not tainted 3.13.0 #45
[    2.636037] Hardware name: HP ProLiant DL585 G1, BIOS A01 02/14/2007
[    2.636037] task: ffff8803f981c400 ti: ffff8803f98be000 task.ti: ffff8803f98be000
[    2.636037] RIP: 0010:[<ffffffff8109e31b>]  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.636037] RSP: 0018:ffff8803f98bfd78  EFLAGS: 00010206
[    2.636037] RAX: ffffffff81ba70c0 RBX: 00000000b4343e88 RCX: 00000000000010cd
[    2.636037] RDX: ffffffff81ac40a8 RSI: 00000000000149a0 RDI: 00000000b4343e88
[    2.636037] RBP: ffffffffa0231958 R08: 00000000000149a0 R09: ffff8802fbc149a0
[    2.636037] R10: ffffea0007e73980 R11: ffff8800b8803b00 R12: ffffffffa0231940
[    2.636037] R13: ffff8803f98bfe78 R14: 0000000000000000 R15: 0000000000000000
[    2.636037] FS:  00007f375b73a700(0000) GS:ffff8802fbc00000(0000) knlGS:0000000000000000
[    2.636037] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.636037] CR2: 00000000b4343e88 CR3: 00000000bc337000 CR4: 00000000000007e0
[    2.636037] Stack:
[    2.636037]  ffffffff81ac40a0 ffffffff81607663 ffffffffa0230400 ffffffff8160772b
[    2.636037]  0000000000000000 ffffffff81110ac5 0000000000000004 ffffffff810f7b2b
[    2.636037]  ffffffff810f4000 0000000000000000 0000000000000000 ffffffff00000003
[    2.636037] Call Trace:
[    2.636037]  [<ffffffff81607663>] ? __mutex_unlock_slowpath+0x53/0x80
[    2.636037]  [<ffffffff8160772b>] ? mutex_unlock+0x2b/0x40
[    2.636037]  [<ffffffff81110ac5>] ? __gcov_init+0x65/0xb0
[    2.636037]  [<ffffffff810f7b2b>] ? load_module+0x223b/0x2710
[    2.636037]  [<ffffffff810f4000>] ? get_modinfo.isra.35+0x110/0x110
[    2.636037]  [<ffffffff8160a0f2>] ? page_fault+0x22/0x30
[    2.636037]  [<ffffffff810f80ee>] ? SyS_init_module+0xee/0x140
[    2.636037]  [<ffffffff816131a1>] ? tracesys+0xd4/0xd9
[    2.649431] tg3 0000:02:06.0 eth0: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e3
[    2.649435] tg3 0000:02:06.0 eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    2.649438] tg3 0000:02:06.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[    2.649441] tg3 0000:02:06.0 eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[    2.636037] Code: 48 83 ec 08 31 d2 48 ff 05 13 58 da 00 e8 ae fb ff ff 48 ff 05 0f 58 da 00 48 83 c4 08 c3 66 90 48 ff 05 a9 54 da 00 53 48 89 fb <48> 8b 07 a8 0c 75 18 48 89 df 31 d2 be 03 00 00 00 e8 7f fb ff 
[    2.651880] FDC 0 is a National Semiconductor PC87306
[    2.650994] RIP  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.650994]  RSP <ffff8803f98bfd78>
[    2.650994] CR2: 00000000b4343e88
[    2.653524] ---[ end trace 1c83e7195a307878 ]---
[    2.705936] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.707494] ohci-pci: OHCI PCI platform driver
[    2.708957] tg3 0000:02:06.1 eth1: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e2
[    2.709270] tg3 0000:02:06.1 eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    2.709581] tg3 0000:02:06.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.709858] tg3 0000:02:06.1 eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[    2.710323] ohci-pci 0000:01:00.0: OHCI PCI host controller
[    2.710525] ohci-pci 0000:01:00.0: new USB bus registered, assigned bus number 1
[    2.710884] ohci-pci 0000:01:00.0: irq 19, io mem 0xf7ef0000
[    2.764430] ata1.00: ATAPI: COMPAQ  CD-ROM SN-124, N104, max PIO4
[    2.766281] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.766512] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.766858] usb usb1: Product: OHCI PCI host controller
[    2.767073] usb usb1: Manufacturer: Linux 3.13.0 ohci_hcd
[    2.767293] usb usb1: SerialNumber: 0000:01:00.0
[    2.767948] hub 1-0:1.0: USB hub found
[    2.768245] hub 1-0:1.0: 3 ports detected
[    2.769201] ohci-pci 0000:01:00.1: OHCI PCI host controller
[    2.769398] ohci-pci 0000:01:00.1: new USB bus registered, assigned bus number 2
[    2.769723] ohci-pci 0000:01:00.1: irq 19, io mem 0xf7ee0000
[    2.774138] ata1.00: configured for PIO4
[    2.777134] scsi 1:0:0:0: CD-ROM            COMPAQ   CD-ROM SN-124    N104 PQ: 0 ANSI: 5
[    2.778189] ata2: port disabled--ignoring
[    2.826315] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.826519] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.826812] usb usb2: Product: OHCI PCI host controller
[    2.826989] usb usb2: Manufacturer: Linux 3.13.0 ohci_hcd
[    2.827187] usb usb2: SerialNumber: 0000:01:00.1
[    2.827811] hub 2-0:1.0: USB hub found
[    2.829783] hub 2-0:1.0: 3 ports detected
[    2.848876] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    2.849088] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.849653] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.904261] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    3.114130] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    3.270271] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
[   63.829832] random: nonblocking pool is initialized
[   64.340712] Adding 2927612k swap on /dev/cciss/c0d0p5.  Priority:-1 extents:1 across:2927612k 
[   64.366248] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: (null)
[   64.507995] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: errors=remount-ro
[   64.715372] loop: module loaded
[   66.167305] ip (1882) used greatest stack depth: 4264 bytes left
[   66.692131] RPC: Registered named UNIX socket transport module.
[   66.692442] RPC: Registered udp transport module.
[   66.692620] RPC: Registered tcp transport module.
[   66.692796] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   66.725621] FS-Cache: Loaded
[   66.768870] FS-Cache: Netfs 'nfs' registered for caching
[   66.830715] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   66.889416] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   68.357541] powernow-k8: Power state transitions not supported
[   68.357762] powernow-k8: Power state transitions not supported
[   68.357984] powernow-k8: Power state transitions not supported
[   68.358210] powernow-k8: Power state transitions not supported
[   68.560384] tg3 0000:02:06.0 eth0: Link is up at 100 Mbps, full duplex
[   68.560579] tg3 0000:02:06.0 eth0: Flow control is on for TX and on for RX
[   68.560864] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

===================================================================

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0 (mroos@dl585) (gcc version 4.7.2 (Debian 4.7.2-5) ) #45 SMP Tue Jan 21 11:57:29 EET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bfff67ff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfff6800-0x00000000bfffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000fdc00000-0x00000000fdc00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fdc10000-0x00000000fdc10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fdc20000-0x00000000fdc20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fdc30000-0x00000000fdc30fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec20000-0x00000000fec20fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000003ffffefff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: HP ProLiant DL585 G1, BIOS A01 02/14/2007
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x3fffff max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-back
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FFC0000000 write-back
[    0.000000]   1 base 0000000000 mask FF80000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FE00000000 write-back
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbfff6 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f4fa0-0x000f4faf] mapped at [ffff8800000f4fa0]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02106000, 0x02106fff] PGTABLE
[    0.000000] BRK [0x02107000, 0x02107fff] PGTABLE
[    0.000000] BRK [0x02108000, 0x02108fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3ffc00000-0x3ffdfffff]
[    0.000000]  [mem 0x3ffc00000-0x3ffdfffff] page 2M
[    0.000000] BRK [0x02109000, 0x02109fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3fc000000-0x3ffbfffff]
[    0.000000]  [mem 0x3fc000000-0x3ffbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x380000000-0x3fbffffff]
[    0.000000]  [mem 0x380000000-0x3fbffffff] page 2M
[    0.000000] BRK [0x0210a000, 0x0210afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbfff5fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbfdfffff] page 2M
[    0.000000]  [mem 0xbfe00000-0xbfff5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x37fffffff]
[    0.000000]  [mem 0x100000000-0x37fffffff] page 2M
[    0.000000] BRK [0x0210b000, 0x0210bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3ffe00000-0x3ffffefff]
[    0.000000]  [mem 0x3ffe00000-0x3ffffefff] page 4k
[    0.000000] ACPI: RSDP 00000000000f4f20 000024 (v02 HP    )
[    0.000000] ACPI: XSDT 00000000bfff6c00 000044 (v01 HP     A01      00000002   \xffffffd2? 0000162E)
[    0.000000] ACPI: FACP 00000000bfff6c80 0000F4 (v03 HP     A01      00000002   \xffffffd2? 0000162E)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20131115/tbfadt-653)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1bControlBlock: 32, using default 16 (20131115/tbfadt-653)
[    0.000000] ACPI: DSDT 00000000bfff6d80 0051D5 (v01 HP         DSDT 00000001 MSFT 02000001)
[    0.000000] ACPI: FACS 00000000bfff68c0 000040
[    0.000000] ACPI: APIC 00000000bfff6900 0000D0 (v01 HP     00000083 00000002      00000000)
[    0.000000] ACPI: SPCR 00000000bfff6a00 000050 (v01 HP     SPCRRBSU 00000001   \xffffffd2? 0000162E)
[    0.000000] ACPI: SRAT 00000000bfff6a80 000150 (v01 HP     A01      00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 1 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x01 -> Node 1
[    0.000000] SRAT: PXM 3 -> APIC 0x02 -> Node 2
[    0.000000] SRAT: PXM 4 -> APIC 0x03 -> Node 3
[    0.000000] SRAT: Node 0 PXM 1 [mem 0x00000000-0xffffffff]
[    0.000000] SRAT: Node 1 PXM 2 [mem 0x100000000-0x1ffffffff]
[    0.000000] SRAT: Node 2 PXM 3 [mem 0x200000000-0x2ffffffff]
[    0.000000] SRAT: Node 3 PXM 4 [mem 0x300000000-0x3ffffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xffffffff]
[    0.000000]   NODE_DATA [mem 0xbfff3000-0xbfff5fff]
[    0.000000] Initmem setup node 1 [mem 0x100000000-0x1ffffffff]
[    0.000000]   NODE_DATA [mem 0x1ffffd000-0x1ffffffff]
[    0.000000] Initmem setup node 2 [mem 0x200000000-0x2ffffffff]
[    0.000000]   NODE_DATA [mem 0x2ffffd000-0x2ffffffff]
[    0.000000] Initmem setup node 3 [mem 0x300000000-0x3ffffefff]
[    0.000000]   NODE_DATA [mem 0x3ffffc000-0x3ffffefff]
[    0.000000]  [ffffea0000000000-ffffea0002ffffff] PMD -> [ffff8800bce00000-ffff8800bfdfffff] on node 0
[    0.000000]  [ffffea0004000000-ffffea0007ffffff] PMD -> [ffff8801fbe00000-ffff8801ffdfffff] on node 1
[    0.000000]  [ffffea0008000000-ffffea000bffffff] PMD -> [ffff8802fbe00000-ffff8802ffdfffff] on node 2
[    0.000000]  [ffffea000c000000-ffffea000fffffff] PMD -> [ffff8803fb400000-ffff8803ff3fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x3ffffefff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xbfff5fff]
[    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
[    0.000000]   node   2: [mem 0x200000000-0x2ffffffff]
[    0.000000]   node   3: [mem 0x300000000-0x3ffffefff]
[    0.000000] On node 0 totalpages: 786324
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12224 pages used for memmap
[    0.000000]   DMA32 zone: 782326 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 1048575
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1048575 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, version 17, address 0xfec10000, GSI 24-27
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec20000] gsi_base[28])
[    0.000000] IOAPIC[2]: apic_id 6, version 17, address 0xfec20000, GSI 28-31
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfdc00000] gsi_base[32])
[    0.000000] IOAPIC[3]: apic_id 7, version 17, address 0xfdc00000, GSI 32-35
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfdc10000] gsi_base[36])
[    0.000000] IOAPIC[4]: apic_id 8, version 17, address 0xfdc10000, GSI 36-39
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfdc20000] gsi_base[40])
[    0.000000] IOAPIC[5]: apic_id 9, version 17, address 0xfdc20000, GSI 40-43
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfdc30000] gsi_base[44])
[    0.000000] IOAPIC[6]: apic_id 10, version 17, address 0xfdc30000, GSI 44-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfff6000-0xbfff6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfff7000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xfdbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc00000-0xfdc00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc01000-0xfdc0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc10000-0xfdc10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc11000-0xfdc1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc20000-0xfdc20fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc21000-0xfdc2ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc30000-0xfdc30fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfdc31000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfec1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec20000-0xfec20fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec21000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee10000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0xc0000000-0xfdbfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:8 nr_node_ids:4
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff8800bcc00000 s76032 r8192 d22272 u1048576
[    0.000000] pcpu-alloc: s76032 r8192 d22272 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 4 [1] 1 5 [2] 2 6 [3] 3 7 
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 3870590
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ b4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ b4000000
[    0.000000] PM: Registered nosave memory: [mem 0xb4000000-0xb7ffffff]
[    0.000000] Memory: 15332028K/15728204K available (6233K kernel code, 2939K rwdata, 1276K rodata, 872K init, 3348K bss, 396176K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] NR_IRQS:4352 nr_irqs:1152 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2197.164 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.012231] Calibrating delay loop (skipped), value calculated using timer frequency.. 4394.32 BogoMIPS (lpj=8788656)
[    0.012648] pid_max: default: 32768 minimum: 301
[    0.015311] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.032957] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.041188] Mount-cache hash table entries: 256
[    0.041829] Initializing cgroup subsys memory
[    0.042069] Initializing cgroup subsys devices
[    0.042280] Initializing cgroup subsys freezer
[    0.042491] Initializing cgroup subsys net_cls
[    0.042692] Initializing cgroup subsys blkio
[    0.042897] Initializing cgroup subsys perf_event
[    0.043107] Initializing cgroup subsys hugetlb
[    0.043352] tseg: 0000000000
[    0.043367] mce: CPU supports 5 MCE banks
[    0.043592] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.043592] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.043592] tlb_flushall_shift: 4
[    0.044110] Freeing SMP alternatives memory: 20K (ffffffff81dba000 - ffffffff81dbf000)
[    0.044460] ACPI: Core revision 20131115
[    0.048571] ACPI: All ACPI Tables successfully acquired
[    0.049828] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.089731] smpboot: CPU0: AMD Opteron (tm) Processor 848 (fam: 0f, model: 05, stepping: 08)
[    0.092000] Performance Events: AMD PMU driver.
[    0.092000] ... version:                0
[    0.092000] ... bit width:              48
[    0.092000] ... generic registers:      4
[    0.092000] ... value mask:             0000ffffffffffff
[    0.092000] ... max period:             00007fffffffffff
[    0.092000] ... fixed-purpose events:   0
[    0.092000] ... event mask:             000000000000000f
[    0.092000] x86: Booting SMP configuration:
[    0.101942] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.092000] .... node  #1, CPUs:      #1
[    0.180565] .... node  #2, CPUs:   #2
[    0.268498] .... node  #3, CPUs:   #3
[    0.356178] x86: Booted up 4 nodes, 4 CPUs
[    0.356498] smpboot: Total of 4 processors activated (17578.03 BogoMIPS)
[    0.358634] devtmpfs: initialized
[    0.358634] gcov: version magic: 0x3430372a
[    0.360275] NET: Registered protocol family 16
[    0.360588] cpuidle: using governor ladder
[    0.360757] cpuidle: using governor menu
[    0.360931] node 0 link 0: io port [1000, 5fff]
[    0.360935] node 1 link 0: io port [6000, ffff]
[    0.360938] TOM: 00000000c0000000 aka 3072M
[    0.361108] node 0 link 0: mmio [f5f00000, f7ffffff]
[    0.361113] node 0 link 0: mmio [f5e00000, f5efffff]
[    0.361116] node 0 link 0: mmio [a0000, bffff]
[    0.361119] node 0 link 0: mmio [fe000000, ffffffff]
[    0.361121] node 1 link 0: mmio [f8000000, fdffffff]
[    0.361124] TOM2: 0000000400000000 aka 16384M
[    0.361296] bus: [bus 00-03] on node 0 link 0
[    0.361298] bus: 00 [io  0x0000-0x5fff]
[    0.361300] bus: 00 [mem 0xc0000000-0xf7ffffff]
[    0.361302] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.361304] bus: 00 [mem 0xfe000000-0xffffffff]
[    0.361306] bus: 00 [mem 0x400000000-0xfcffffffff]
[    0.361308] bus: [bus 04-08] on node 1 link 0
[    0.361309] bus: 04 [io  0x6000-0xffff]
[    0.361311] bus: 04 [mem 0xf8000000-0xfdffffff]
[    0.361328] ACPI: bus type PCI registered
[    0.361554] PCI: Using configuration type 1 for base access
[    0.361934] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.362110] mtrr: probably your BIOS does not setup all CPUs.
[    0.362284] mtrr: corrected configuration.
[    0.363135] bio: create slab <bio-0> at 0
[    0.363135] ACPI: Added _OSI(Module Device)
[    0.364011] ACPI: Added _OSI(Processor Device)
[    0.364181] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.364351] ACPI: Added _OSI(Processor Aggregator Device)
[    0.369593] ACPI: Interpreter enabled
[    0.369770] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.370171] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.370569] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131115/hwxface-580)
[    0.370977] ACPI: (supports S0 S4 S5)
[    0.371142] ACPI: Using IOAPIC for interrupt routing
[    0.371362] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.379391] ACPI: PCI Root Bridge [CFG0] (domain 0000 [bus 00-03])
[    0.379579] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.379760] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.381558] acpi PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
[    0.381561] acpi PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
[    0.381564] acpi PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
[    0.381567] acpi PNP0A03:00: host bridge window [io  0x03e0-0x0fff] (ignored)
[    0.381570] acpi PNP0A03:00: host bridge window [io  0x1000-0x5fff] (ignored)
[    0.381573] acpi PNP0A03:00: host bridge window [mem 0xf5f00000-0xf7ffffff] (ignored)
[    0.381576] acpi PNP0A03:00: host bridge window [mem 0xf5e00000-0xf5efffff] (ignored)
[    0.381579] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.381583] PCI: root bus 00: hardware-probed resources
[    0.381594] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.381955] PCI host bridge to bus 0000:00
[    0.382127] pci_bus 0000:00: root bus resource [bus 00-03]
[    0.382302] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
[    0.382481] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xf7ffffff]
[    0.382661] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.382841] pci_bus 0000:00: root bus resource [mem 0xfe000000-0xffffffff]
[    0.383022] pci_bus 0000:00: root bus resource [mem 0x400000000-0xfcffffffff]
[    0.383227] pci 0000:00:03.0: [1022:7460] type 01 class 0x060400
[    0.383391] pci 0000:00:04.0: [1022:7468] type 00 class 0x060100
[    0.383517] pci 0000:00:04.1: [1022:7469] type 00 class 0x01018a
[    0.383555] pci 0000:00:04.1: reg 0x20: [io  0x2000-0x200f]
[    0.383635] pci 0000:00:04.3: [1022:746b] type 00 class 0x068000
[    0.383773] pci 0000:00:07.0: [1022:7450] type 01 class 0x060400
[    0.383882] pci 0000:00:07.1: [1022:7451] type 00 class 0x080010
[    0.383989] pci 0000:00:08.0: [1022:7450] type 01 class 0x060400
[    0.384112] pci 0000:00:08.1: [1022:7451] type 00 class 0x080010
[    0.384235] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.384331] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.384402] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.384474] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.384551] pci 0000:00:19.0: [1022:1100] type 00 class 0x060000
[    0.384642] pci 0000:00:19.1: [1022:1101] type 00 class 0x060000
[    0.384715] pci 0000:00:19.2: [1022:1102] type 00 class 0x060000
[    0.384785] pci 0000:00:19.3: [1022:1103] type 00 class 0x060000
[    0.384871] pci 0000:00:1a.0: [1022:1100] type 00 class 0x060000
[    0.384963] pci 0000:00:1a.1: [1022:1101] type 00 class 0x060000
[    0.385038] pci 0000:00:1a.2: [1022:1102] type 00 class 0x060000
[    0.385113] pci 0000:00:1a.3: [1022:1103] type 00 class 0x060000
[    0.385189] pci 0000:00:1b.0: [1022:1100] type 00 class 0x060000
[    0.385278] pci 0000:00:1b.1: [1022:1101] type 00 class 0x060000
[    0.385354] pci 0000:00:1b.2: [1022:1102] type 00 class 0x060000
[    0.385428] pci 0000:00:1b.3: [1022:1103] type 00 class 0x060000
[    0.385574] pci 0000:01:00.0: [1022:7464] type 00 class 0x0c0310
[    0.385590] pci 0000:01:00.0: reg 0x10: [mem 0xf7ef0000-0xf7ef0fff]
[    0.385707] pci 0000:01:00.1: [1022:7464] type 00 class 0x0c0310
[    0.385724] pci 0000:01:00.1: reg 0x10: [mem 0xf7ee0000-0xf7ee0fff]
[    0.385852] pci 0000:01:02.0: [0e11:b203] type 00 class 0x088000
[    0.385873] pci 0000:01:02.0: reg 0x10: [io  0x4800-0x48ff]
[    0.385885] pci 0000:01:02.0: reg 0x14: [mem 0xf7eb0000-0xf7eb01ff]
[    0.386029] pci 0000:01:02.2: [0e11:b204] type 00 class 0x088000
[    0.386052] pci 0000:01:02.2: reg 0x10: [io  0x4000-0x40ff]
[    0.386065] pci 0000:01:02.2: reg 0x14: [mem 0xf7ea0000-0xf7ea07ff]
[    0.386078] pci 0000:01:02.2: reg 0x18: [mem 0xf7e90000-0xf7e91fff]
[    0.386091] pci 0000:01:02.2: reg 0x1c: [mem 0xf7e00000-0xf7e7ffff]
[    0.386125] pci 0000:01:02.2: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.386162] pci 0000:01:02.2: PME# supported from D0 D3hot D3cold
[    0.386251] pci 0000:01:03.0: [1002:4752] type 00 class 0x030000
[    0.386271] pci 0000:01:03.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.386284] pci 0000:01:03.0: reg 0x14: [io  0x4400-0x44ff]
[    0.386296] pci 0000:01:03.0: reg 0x18: [mem 0xf5ff0000-0xf5ff0fff]
[    0.386338] pci 0000:01:03.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.386372] pci 0000:01:03.0: supports D1 D2
[    0.386466] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.386642] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.386647] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.386716] pci 0000:02:04.0: [0e11:b178] type 00 class 0x010400
[    0.386736] pci 0000:02:04.0: reg 0x10: [mem 0xf7fc0000-0xf7ffffff 64bit]
[    0.386743] pci 0000:02:04.0: reg 0x18: [io  0x5000-0x50ff]
[    0.386754] pci 0000:02:04.0: reg 0x1c: [mem 0xf5ef0000-0xf5ef3fff 64bit pref]
[    0.386767] pci 0000:02:04.0: reg 0x30: [mem 0x00000000-0x00003fff pref]
[    0.386798] pci 0000:02:04.0: supports D1
[    0.386870] pci 0000:02:06.0: [14e4:1648] type 00 class 0x020000
[    0.386886] pci 0000:02:06.0: reg 0x10: [mem 0xf7fb0000-0xf7fbffff 64bit]
[    0.386944] pci 0000:02:06.0: PME# supported from D3hot D3cold
[    0.387015] pci 0000:02:06.1: [14e4:1648] type 00 class 0x020000
[    0.387030] pci 0000:02:06.1: reg 0x10: [mem 0xf7fa0000-0xf7faffff 64bit]
[    0.387088] pci 0000:02:06.1: PME# supported from D3hot D3cold
[    0.387173] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.387348] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.387352] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.387357] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.387526] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.388748] ACPI: PCI Root Bridge [CFG1] (domain 0000 [bus 04-08])
[    0.388929] acpi PNP0A03:01: _OSC: OS supports [Segments MSI]
[    0.389108] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.390650] acpi PNP0A03:01: host bridge window [io  0x6000-0xffff] (ignored)
[    0.390654] PCI: root bus 04: hardware-probed resources
[    0.390659] acpi PNP0A03:01: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.391001] PCI host bridge to bus 0000:04
[    0.391172] pci_bus 0000:04: root bus resource [bus 04-08]
[    0.391347] pci_bus 0000:04: root bus resource [io  0x6000-0xffff]
[    0.391525] pci_bus 0000:04: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.391724] pci 0000:04:09.0: [1022:7450] type 01 class 0x060400
[    0.391844] pci 0000:04:09.1: [1022:7451] type 00 class 0x080010
[    0.391951] pci 0000:04:0a.0: [1022:7450] type 01 class 0x060400
[    0.392075] pci 0000:04:0a.1: [1022:7451] type 00 class 0x080010
[    0.392184] pci 0000:04:0b.0: [1022:7450] type 01 class 0x060400
[    0.392287] pci 0000:04:0b.1: [1022:7451] type 00 class 0x080010
[    0.392380] pci 0000:04:0c.0: [1022:7450] type 01 class 0x060400
[    0.392476] pci 0000:04:0c.1: [1022:7451] type 00 class 0x080010
[    0.392707] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.393008] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.393347] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.393678] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.394104] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 *7 10 11)
[    0.394753] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 7 *10 11)
[    0.395398] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 7 10 *11)
[    0.396061] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *5 7 10 11)
[    0.396781] ACPI: \_SB_.CFG0: notify handler is installed
[    0.396809] ACPI: \_SB_.CFG1: notify handler is installed
[    0.396843] Found 2 acpi root devices
[    0.397011] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    0.397011] vgaarb: loaded
[    0.397011] vgaarb: bridge control possible 0000:01:03.0
[    0.397011] SCSI subsystem initialized
[    0.397011] PCI: Using ACPI for IRQ routing
[    0.397180] PCI: pci_cache_line_size set to 64 bytes
[    0.397263] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.397267] e820: reserve RAM buffer [mem 0xbfff6800-0xbfffffff]
[    0.397270] e820: reserve RAM buffer [mem 0x3fffff000-0x3ffffffff]
[    0.397568] Switched to clocksource refined-jiffies
[    0.397568] pnp: PnP ACPI init
[    0.397568] ACPI: bus type PNP registered
[    0.397568] system 00:00: [io  0x0230-0x0233] has been reserved
[    0.400016] system 00:00: [io  0x0260-0x0267] has been reserved
[    0.400197] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.400380] system 00:00: [io  0x0800-0x081f] has been reserved
[    0.400561] system 00:00: [io  0x0900-0x0903] has been reserved
[    0.400743] system 00:00: [io  0x0904-0x0907] has been reserved
[    0.400924] system 00:00: [io  0x0908-0x090b] has been reserved
[    0.401105] system 00:00: [io  0x090c-0x092e] has been reserved
[    0.401287] system 00:00: [io  0x092f] has been reserved
[    0.401465] system 00:00: [io  0x0930-0x09ff] has been reserved
[    0.401646] system 00:00: [io  0x0c80-0x0c87] has been reserved
[    0.401829] system 00:00: [io  0x0cf9] could not be reserved
[    0.402010] system 00:00: [io  0x02f8-0x02ff] has been reserved
[    0.402196] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.402220] pnp 00:01: [dma 7]
[    0.402256] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.402293] pnp 00:02: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.402367] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.402416] pnp 00:04: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.402457] pnp 00:05: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.402738] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.402942] pnp 00:07: [dma 2]
[    0.402991] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.403243] pnp: PnP ACPI: found 8 devices
[    0.403417] ACPI: bus type PNP unregistered
[    0.410520] Switched to clocksource acpi_pm
[    0.410520] pci 0000:00:03.0: BAR 15: assigned [mem 0xc0000000-0xc00fffff pref]
[    0.410520] pci 0000:01:03.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
[    0.410520] pci 0000:01:02.2: BAR 6: assigned [mem 0xc0020000-0xc002ffff pref]
[    0.410520] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.410520] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.410520] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.410520] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xc00fffff pref]
[    0.410520] pci 0000:02:04.0: BAR 6: assigned [mem 0xf5e00000-0xf5e03fff pref]
[    0.410520] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.410569] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.410751] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.410937] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.411221] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.411405] pci_bus 0000:00: resource 4 [io  0x0000-0x5fff]
[    0.411408] pci_bus 0000:00: resource 5 [mem 0xc0000000-0xf7ffffff]
[    0.411411] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.411414] pci_bus 0000:00: resource 7 [mem 0xfe000000-0xffffffff]
[    0.411417] pci_bus 0000:00: resource 8 [mem 0x400000000-0xfcffffffff]
[    0.411421] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    0.411424] pci_bus 0000:01: resource 1 [mem 0xf5f00000-0xf7efffff]
[    0.411427] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc00fffff pref]
[    0.411430] pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
[    0.411433] pci_bus 0000:02: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    0.411436] pci_bus 0000:02: resource 2 [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.411467] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.411652] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.411835] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.412032] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.412216] pci_bus 0000:04: resource 4 [io  0x6000-0xffff]
[    0.412220] pci_bus 0000:04: resource 5 [mem 0xf8000000-0xfdffffff]
[    0.412380] NET: Registered protocol family 2
[    0.413110] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.414497] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.415512] TCP: Hash tables configured (established 131072 bind 65536)
[    0.415838] TCP: reno registered
[    0.416150] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.416624] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.417223] NET: Registered protocol family 1
[    0.417442] pci 0000:00:04.3: boot interrupts on device [1022:746b] already disabled
[    0.417728] pci 0000:00:07.0: MSI quirk detected; subordinate MSI disabled
[    0.417915] pci 0000:00:07.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.418105] pci 0000:00:08.0: MSI quirk detected; subordinate MSI disabled
[    0.418289] pci 0000:00:08.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.560095] pci 0000:01:03.0: Boot video device
[    0.560112] pci 0000:04:09.0: MSI quirk detected; subordinate MSI disabled
[    0.560300] pci 0000:04:09.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.560492] pci 0000:04:0a.0: MSI quirk detected; subordinate MSI disabled
[    0.560676] pci 0000:04:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.560867] pci 0000:04:0b.0: MSI quirk detected; subordinate MSI disabled
[    0.561052] pci 0000:04:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.561243] pci 0000:04:0c.0: MSI quirk detected; subordinate MSI disabled
[    0.561428] pci 0000:04:0c.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.561616] PCI: CLS 64 bytes, default 64
[    0.564484] PCI-DMA: Disabling AGP.
[    0.564940] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    0.565119] PCI-DMA: using GART IOMMU.
[    0.565296] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.574274] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.591848] gcov: could not create file
[    0.658982] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.663476] msgmni has been set to 30074
[    0.664056] cryptomgr_test (65) used greatest stack depth: 7224 bytes left
[    0.664348] cryptomgr_test (66) used greatest stack depth: 6824 bytes left
[    0.664687] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.665046] io scheduler noop registered
[    0.665244] io scheduler deadline registered
[    0.665512] io scheduler cfq registered (default)
[    0.665833] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.666188] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.666526] ACPI: Power Button [PWRF]
[    0.666786] ACPI: processor limited to max C-state 1
[    0.667228] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.688025] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.730748] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    0.731611] Linux agpgart interface v0.103
[    0.731801] HP CISS Driver (v 3.6.26)
[    0.732407] cciss 0000:02:04.0: Controller reports max supported commands of 0, an obvious lie. Using 16.  Ensure that firmware is up to date.
[    0.852930] cciss 0000:02:04.0: cciss0: <0xb178> at PCI 0000:02:04.0 IRQ 18 using DAC
[    0.857656]  cciss/c0d0: p1 p2 < p5 >
[    0.858450] scsi0 : cciss
[    0.858840] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.861580] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.861800] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.862190] mousedev: PS/2 mouse device common for all mice
[    0.862509] rtc_cmos rtc_cmos: RTC can wake from S4
[    0.862955] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.863277] rtc_cmos rtc_cmos: alarms up to one year, y3k, 114 bytes nvram
[    0.863739] TCP: cubic registered
[    0.864217] NET: Registered protocol family 10
[    0.864734] NET: Registered protocol family 17
[    0.864924] Key type dns_resolver registered
[    0.865492] registered taskstats version 1
[    0.867897] rtc_cmos rtc_cmos: setting system clock to 2014-01-21 10:38:13 UTC (1390300693)
[    0.913701] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.922173] EXT4-fs (cciss!c0d0p1): couldn't mount as ext3 due to feature incompatibilities
[    0.922965] EXT4-fs (cciss!c0d0p1): couldn't mount as ext2 due to feature incompatibilities
[    0.935319] EXT4-fs (cciss!c0d0p1): mounted filesystem with ordered data mode. Opts: (null)
[    0.935627] VFS: Mounted root (ext4 filesystem) readonly on device 104:1.
[    0.951380] devtmpfs: mounted
[    0.953292] Freeing unused kernel memory: 872K (ffffffff81ce0000 - ffffffff81dba000)
[    0.953579] Write protecting the kernel read-only data: 10240k
[    0.961249] Freeing unused kernel memory: 1912K (ffff880001622000 - ffff880001800000)
[    0.964585] Freeing unused kernel memory: 772K (ffff88000193f000 - ffff880001a00000)
[    1.368522] modprobe (80) used greatest stack depth: 4616 bytes left
[    2.127804] udevd[198]: starting version 175
[    2.406772] AMD768 RNG detected
[    2.418385] BUG: unable to handle kernel paging request at 00000000b4343e88
[    2.418723] IP: [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.418981] PGD 0 
[    2.419197] ioapic: probe of 0000:00:07.1 failed with error -22
[    2.419315] ioapic: probe of 0000:00:08.1 failed with error -22
[    2.419583] Oops: 0000 [#1] SMP 
[    2.419879] Modules linked in: ioapic(+) i2c_core(+) amd_rng evdev
[    2.420351] CPU: 1 PID: 281 Comm: modprobe Not tainted 3.13.0 #45
[    2.420351] Hardware name: HP ProLiant DL585 G1, BIOS A01 02/14/2007
[    2.420351] task: ffff8800bc403300 ti: ffff8800b31d2000 task.ti: ffff8800b31d2000
[    2.420351] RIP: 0010:[<ffffffff8109e31b>]  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.420351] RSP: 0018:ffff8800b31d3d78  EFLAGS: 00010202
[    2.420351] RAX: ffffffff81ba70c0 RBX: 00000000b4343e88 RCX: 0000000000000c89
[    2.420351] RDX: ffffffff81ac40a8 RSI: 00000000000149a0 RDI: 00000000b4343e88
[    2.420351] RBP: ffffffffa000b038 R08: 00000000000149a0 R09: ffff8801fbc149a0
[    2.420351] R10: ffffea0007e76480 R11: ffff8800b8803b00 R12: ffffffffa000b020
[    2.420351] R13: ffff8800b31d3e78 R14: 0000000000000000 R15: 0000000000000000
[    2.420351] FS:  00007f24c6b1b700(0000) GS:ffff8801fbc00000(0000) knlGS:0000000000000000
[    2.420351] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.422955] CR2: 00000000b4343e88 CR3: 00000001f9dad000 CR4: 00000000000007e0
[    2.422955] Stack:
[    2.422955]  ffffffff81ac40a0 ffffffff81607663 ffffffffa0009260 ffffffff8160772b
[    2.422955]  0000000000000000 ffffffff81110ac5 0000000000000000 ffffffff810f7b2b
[    2.422955]  ffffffff810f4000 0000000000000000 0000000000000000 ffffffff00000003
[    2.422955] Call Trace:
[    2.422955]  [<ffffffff81607663>] ? __mutex_unlock_slowpath+0x53/0x80
[    2.422955]  [<ffffffff8160772b>] ? mutex_unlock+0x2b/0x40
[    2.422955]  [<ffffffff81110ac5>] ? __gcov_init+0x65/0xb0
[    2.422955]  [<ffffffff810f7b2b>] ? load_module+0x223b/0x2710
[    2.422955]  [<ffffffff810f4000>] ? get_modinfo.isra.35+0x110/0x110
[    2.422955]  [<ffffffff8160a0f2>] ? page_fault+0x22/0x30
[    2.422955]  [<ffffffff810f80ee>] ? SyS_init_module+0xee/0x140
[    2.422955]  [<ffffffff816131a1>] ? tracesys+0xd4/0xd9
[    2.422955] Code: 48 83 ec 08 31 d2 48 ff 05 13 58 da 00 e8 ae fb ff ff 48 ff 05 0f 58 da 00 48 83 c4 08 c3 66 90 48 ff 05 a9 54 da 00 53 48 89 fb <48> 8b 07 a8 0c 75 18 48 89 df 31 d2 be 03 00 00 00 e8 7f fb ff 
[    2.429521] RIP  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.429521]  RSP <ffff8800b31d3d78>
[    2.429521] CR2: 00000000b4343e88
[    2.431890] ---[ end trace 0a363fc577f200bc ]---
[    2.437265] ioapic: probe of 0000:04:09.1 failed with error -22
[    2.437635] ioapic: probe of 0000:04:0a.1 failed with error -22
[    2.437878] ioapic: probe of 0000:04:0b.1 failed with error -22
[    2.438076] ioapic: probe of 0000:04:0c.1 failed with error -22
[    2.457220] libata version 3.00 loaded.
[    2.468706] pata_amd 0000:00:04.1: version 0.4.1
[    2.472980] scsi1 : pata_amd
[    2.475770] scsi2 : pata_amd
[    2.476105] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
[    2.476290] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
[    2.479315] shpchp 0000:00:07.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.479620] shpchp 0000:00:07.0: Cannot reserve MMIO region
[    2.479837] shpchp 0000:00:08.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.480206] shpchp 0000:00:08.0: Cannot reserve MMIO region
[    2.480682] shpchp 0000:04:09.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.481030] shpchp 0000:04:09.0: Cannot reserve MMIO region
[    2.481336] shpchp 0000:04:0a.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.481632] shpchp 0000:04:0a.0: Cannot reserve MMIO region
[    2.481839] shpchp 0000:04:0b.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.482133] shpchp 0000:04:0b.0: Cannot reserve MMIO region
[    2.482334] shpchp 0000:04:0c.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.482622] shpchp 0000:04:0c.0: Cannot reserve MMIO region
[    2.482878] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.514443] Floppy drive(s): fd0 is 1.44M
[    2.553238] hpwdt 0000:01:02.0: This server does not have an iLO2+ ASIC.
[    2.557128] FDC 0 is a National Semiconductor PC87306
[    2.571647] pps_core: LinuxPPS API ver. 1 registered
[    2.571855] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.579664] PTP clock support registered
[    2.582727] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.606762] tg3.c:v3.134 (Sep 16, 2013)
[    2.628580] EDAC MC: Ver: 3.0.0
[    2.663683] tg3 0000:02:06.0 eth0: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e3
[    2.663978] tg3 0000:02:06.0 eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    2.664288] tg3 0000:02:06.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[    2.664566] tg3 0000:02:06.0 eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[    2.691072] ACPI: bus type USB registered
[    2.691494] usbcore: registered new interface driver usbfs
[    2.691765] usbcore: registered new interface driver hub
[    2.692281] usbcore: registered new device driver usb
[    2.714797] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.720380] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.724330] tg3 0000:02:06.1 eth1: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e2
[    2.724632] tg3 0000:02:06.1 eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    2.724918] tg3 0000:02:06.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.725197] tg3 0000:02:06.1 eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[    2.752381] ata1.00: ATAPI: COMPAQ  CD-ROM SN-124, N104, max PIO4
[    2.768267] ata1.00: configured for PIO4
[    2.769278] scsi 1:0:0:0: CD-ROM            COMPAQ   CD-ROM SN-124    N104 PQ: 0 ANSI: 5
[    2.770300] ata2: port disabled--ignoring
[    2.793159] ohci-pci: OHCI PCI platform driver
[    2.793616] ohci-pci 0000:01:00.0: OHCI PCI host controller
[    2.793810] ohci-pci 0000:01:00.0: new USB bus registered, assigned bus number 1
[    2.794149] ohci-pci 0000:01:00.0: irq 19, io mem 0xf7ef0000
[    2.799683] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    2.799885] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.800383] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.810962] MCE: In-kernel MCE decoding enabled.
[    2.849243] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    2.850833] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.851058] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.851338] usb usb1: Product: OHCI PCI host controller
[    2.851515] usb usb1: Manufacturer: Linux 3.13.0 ohci_hcd
[    2.851693] usb usb1: SerialNumber: 0000:01:00.0
[    2.854488] hub 1-0:1.0: USB hub found
[    2.854748] hub 1-0:1.0: 3 ports detected
[    2.855773] ohci-pci 0000:01:00.1: OHCI PCI host controller
[    2.855976] ohci-pci 0000:01:00.1: new USB bus registered, assigned bus number 2
[    2.856385] ohci-pci 0000:01:00.1: irq 19, io mem 0xf7ee0000
[    2.856446] AMD64 EDAC driver v3.4.0
[    2.858498] EDAC amd64: DRAM ECC enabled.
[    2.858676] EDAC amd64: K8 revE or earlier detected (node 0).
[    2.859122] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.859308] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.859725] EDAC MC0: Giving out device to module amd64_edac controller K8: DEV 0000:00:18.2 (INTERRUPT)
[    2.860220] EDAC amd64: DRAM ECC enabled.
[    2.860445] EDAC amd64: K8 revE or earlier detected (node 1).
[    2.860738] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.860930] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.861457] EDAC MC1: Giving out device to module amd64_edac controller K8: DEV 0000:00:19.2 (INTERRUPT)
[    2.861874] EDAC amd64: DRAM ECC enabled.
[    2.862102] EDAC amd64: K8 revE or earlier detected (node 2).
[    2.862430] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.862625] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.863354] EDAC MC2: Giving out device to module amd64_edac controller K8: DEV 0000:00:1a.2 (INTERRUPT)
[    2.865352] EDAC amd64: DRAM ECC enabled.
[    2.865566] EDAC amd64: K8 revE or earlier detected (node 3).
[    2.865879] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.866081] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.866595] EDAC MC3: Giving out device to module amd64_edac controller K8: DEV 0000:00:1b.2 (INTERRUPT)
[    2.868712] EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
[    2.914360] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.914593] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.914890] usb usb2: Product: OHCI PCI host controller
[    2.915102] usb usb2: Manufacturer: Linux 3.13.0 ohci_hcd
[    2.915291] usb usb2: SerialNumber: 0000:01:00.1
[    2.915858] hub 2-0:1.0: USB hub found
[    2.916158] hub 2-0:1.0: 3 ports detected
[    2.917434] modprobe (351) used greatest stack depth: 4424 bytes left
[    3.106874] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    3.263036] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
[    3.684663] random: nonblocking pool is initialized
[    3.810175] Adding 2927612k swap on /dev/cciss/c0d0p5.  Priority:-1 extents:1 across:2927612k 
[    3.837569] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: (null)
[    3.973001] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: errors=remount-ro
[    4.167126] loop: module loaded
[    5.620763] ip (1514) used greatest stack depth: 4264 bytes left
[    6.106409] RPC: Registered named UNIX socket transport module.
[    6.106690] RPC: Registered udp transport module.
[    6.106873] RPC: Registered tcp transport module.
[    6.107049] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.127667] FS-Cache: Loaded
[    6.170867] FS-Cache: Netfs 'nfs' registered for caching
[    6.236861] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    6.548432] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.839665] powernow-k8: Power state transitions not supported
[    7.839877] powernow-k8: Power state transitions not supported
[    7.840108] powernow-k8: Power state transitions not supported
[    7.840348] powernow-k8: Power state transitions not supported
[    8.130772] tg3 0000:02:06.0 eth0: Link is up at 100 Mbps, full duplex
[    8.130966] tg3 0000:02:06.0 eth0: Flow control is on for TX and on for RX
[    8.131198] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready


-- 
Meelis Roos (mroos@linux.ee)
