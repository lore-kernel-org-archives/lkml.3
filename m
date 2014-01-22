Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaAVPdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:33:45 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:37847 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbaAVPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:33:38 -0500
Date: Wed, 22 Jan 2014 17:33:32 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: Re: 3.13: BUG: unable to handle kernel paging request at
 00000000b4343e88
In-Reply-To: <20140121141037.f76dba61212c5597ff733207@linux-foundation.org>
Message-ID: <alpine.SOC.1.00.1401221731150.3033@math.ut.ee>
References: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee> <20140121141037.f76dba61212c5597ff733207@linux-foundation.org>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks like gcov exploded when running a module's constructors or
> init function, but I'm unable to work out which module it was :(
[...]

> Maybe it's tg3.
> 
> Could you add `ignore_loglevel' to the kernel boot parameters?  That
> should make all pr_debug()s come out and they include the module's
> name.

Not much help - perhaps initcall_debug=1 ? Last one ise also below.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0 (mroos@dl585) (gcc version 4.7.2 (Debian 4.7.2-5) ) #45 SMP Tue Jan 21 11:57:29 EET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro ignore_loglevel
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
[    0.000000] debug: ignoring loglevel setting.
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
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ fc7e000000 size 32 MB
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
[    0.000000] tsc: Detected 2196.885 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.008219] Calibrating delay loop (skipped), value calculated using timer frequency.. 4393.77 BogoMIPS (lpj=8787540)
[    0.008641] pid_max: default: 32768 minimum: 301
[    0.011313] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.029485] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.037717] Mount-cache hash table entries: 256
[    0.038357] Initializing cgroup subsys memory
[    0.038592] Initializing cgroup subsys devices
[    0.038787] Initializing cgroup subsys freezer
[    0.038995] Initializing cgroup subsys net_cls
[    0.039203] Initializing cgroup subsys blkio
[    0.039407] Initializing cgroup subsys perf_event
[    0.039607] Initializing cgroup subsys hugetlb
[    0.039844] tseg: 0000000000
[    0.040022] mce: CPU supports 5 MCE banks
[    0.040242] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.040242] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.040242] tlb_flushall_shift: 4
[    0.040825] Freeing SMP alternatives memory: 20K (ffffffff81dba000 - ffffffff81dbf000)
[    0.041172] ACPI: Core revision 20131115
[    0.045216] ACPI: All ACPI Tables successfully acquired
[    0.046398] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.086259] smpboot: CPU0: AMD Opteron (tm) Processor 848 (fam: 0f, model: 05, stepping: 08)
[    0.088000] Performance Events: AMD PMU driver.
[    0.088000] ... version:                0
[    0.088000] ... bit width:              48
[    0.088000] ... generic registers:      4
[    0.088000] ... value mask:             0000ffffffffffff
[    0.088000] ... max period:             00007fffffffffff
[    0.088000] ... fixed-purpose events:   0
[    0.088000] ... event mask:             000000000000000f
[    0.088000] x86: Booting SMP configuration:
[    0.097962] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.088000] .... node  #1, CPUs:      #1
[    0.176539] .... node  #2, CPUs:   #2
[    0.264578] .... node  #3, CPUs:   #3
[    0.352176] x86: Booted up 4 nodes, 4 CPUs
[    0.352498] smpboot: Total of 4 processors activated (17577.45 BogoMIPS)
[    0.354663] devtmpfs: initialized
[    0.354663] gcov: version magic: 0x3430372a
[    0.356285] NET: Registered protocol family 16
[    0.356594] cpuidle: using governor ladder
[    0.356762] cpuidle: using governor menu
[    0.356936] node 0 link 0: io port [1000, 5fff]
[    0.357107] node 1 link 0: io port [6000, ffff]
[    0.357278] TOM: 00000000c0000000 aka 3072M
[    0.357448] node 0 link 0: mmio [f5f00000, f7ffffff]
[    0.357680] node 0 link 0: mmio [f5e00000, f5efffff]
[    0.357910] node 0 link 0: mmio [a0000, bffff]
[    0.358138] node 0 link 0: mmio [fe000000, ffffffff]
[    0.358367] node 1 link 0: mmio [f8000000, fdffffff]
[    0.358596] TOM2: 0000000400000000 aka 16384M
[    0.358768] bus: [bus 00-03] on node 0 link 0
[    0.358936] bus: 00 [io  0x0000-0x5fff]
[    0.359102] bus: 00 [mem 0xc0000000-0xf7ffffff]
[    0.359272] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.359440] bus: 00 [mem 0xfe000000-0xffffffff]
[    0.359609] bus: 00 [mem 0x400000000-0xfcffffffff]
[    0.359779] bus: [bus 04-08] on node 1 link 0
[    0.360010] bus: 04 [io  0x6000-0xffff]
[    0.360176] bus: 04 [mem 0xf8000000-0xfdffffff]
[    0.360365] ACPI: bus type PCI registered
[    0.360592] PCI: Using configuration type 1 for base access
[    0.360979] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.361155] mtrr: probably your BIOS does not setup all CPUs.
[    0.361329] mtrr: corrected configuration.
[    0.362146] bio: create slab <bio-0> at 0
[    0.362146] ACPI: Added _OSI(Module Device)
[    0.362146] ACPI: Added _OSI(Processor Device)
[    0.362146] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.362146] ACPI: Added _OSI(Processor Aggregator Device)
[    0.368545] ACPI: Interpreter enabled
[    0.368721] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.369123] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.369523] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131115/hwxface-580)
[    0.369931] ACPI: (supports S0 S4 S5)
[    0.370098] ACPI: Using IOAPIC for interrupt routing
[    0.370317] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.378023] ACPI: PCI Root Bridge [CFG0] (domain 0000 [bus 00-03])
[    0.378211] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.378392] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.380273] acpi PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
[    0.380456] acpi PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
[    0.380637] acpi PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
[    0.380819] acpi PNP0A03:00: host bridge window [io  0x03e0-0x0fff] (ignored)
[    0.381001] acpi PNP0A03:00: host bridge window [io  0x1000-0x5fff] (ignored)
[    0.381183] acpi PNP0A03:00: host bridge window [mem 0xf5f00000-0xf7ffffff] (ignored)
[    0.381460] acpi PNP0A03:00: host bridge window [mem 0xf5e00000-0xf5efffff] (ignored)
[    0.381736] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.382014] PCI: root bus 00: hardware-probed resources
[    0.382197] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.382558] PCI host bridge to bus 0000:00
[    0.382730] pci_bus 0000:00: root bus resource [bus 00-03]
[    0.382905] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
[    0.383082] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xf7ffffff]
[    0.383263] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.383444] pci_bus 0000:00: root bus resource [mem 0xfe000000-0xffffffff]
[    0.383624] pci_bus 0000:00: root bus resource [mem 0x400000000-0xfcffffffff]
[    0.383829] pci 0000:00:03.0: [1022:7460] type 01 class 0x060400
[    0.384173] pci 0000:00:04.0: [1022:7468] type 00 class 0x060100
[    0.384473] pci 0000:00:04.1: [1022:7469] type 00 class 0x01018a
[    0.384685] pci 0000:00:04.1: reg 0x20: [io  0x2000-0x200f]
[    0.384938] pci 0000:00:04.3: [1022:746b] type 00 class 0x068000
[    0.385248] pci 0000:00:07.0: [1022:7450] type 01 class 0x060400
[    0.385533] pci 0000:00:07.1: [1022:7451] type 00 class 0x080010
[    0.385811] pci 0000:00:08.0: [1022:7450] type 01 class 0x060400
[    0.386090] pci 0000:00:08.1: [1022:7451] type 00 class 0x080010
[    0.386387] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.386646] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.386895] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.387142] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.387390] pci 0000:00:19.0: [1022:1100] type 00 class 0x060000
[    0.387654] pci 0000:00:19.1: [1022:1101] type 00 class 0x060000
[    0.387904] pci 0000:00:19.2: [1022:1102] type 00 class 0x060000
[    0.388071] pci 0000:00:19.3: [1022:1103] type 00 class 0x060000
[    0.388326] pci 0000:00:1a.0: [1022:1100] type 00 class 0x060000
[    0.388589] pci 0000:00:1a.1: [1022:1101] type 00 class 0x060000
[    0.388836] pci 0000:00:1a.2: [1022:1102] type 00 class 0x060000
[    0.389091] pci 0000:00:1a.3: [1022:1103] type 00 class 0x060000
[    0.389337] pci 0000:00:1b.0: [1022:1100] type 00 class 0x060000
[    0.389596] pci 0000:00:1b.1: [1022:1101] type 00 class 0x060000
[    0.389843] pci 0000:00:1b.2: [1022:1102] type 00 class 0x060000
[    0.390092] pci 0000:00:1b.3: [1022:1103] type 00 class 0x060000
[    0.390413] pci 0000:01:00.0: [1022:7464] type 00 class 0x0c0310
[    0.390603] pci 0000:01:00.0: reg 0x10: [mem 0xf7ef0000-0xf7ef0fff]
[    0.392121] pci 0000:01:00.1: [1022:7464] type 00 class 0x0c0310
[    0.392312] pci 0000:01:00.1: reg 0x10: [mem 0xf7ee0000-0xf7ee0fff]
[    0.392617] pci 0000:01:02.0: [0e11:b203] type 00 class 0x088000
[    0.392814] pci 0000:01:02.0: reg 0x10: [io  0x4800-0x48ff]
[    0.392999] pci 0000:01:02.0: reg 0x14: [mem 0xf7eb0000-0xf7eb01ff]
[    0.393324] pci 0000:01:02.2: [0e11:b204] type 00 class 0x088000
[    0.393563] pci 0000:01:02.2: reg 0x10: [io  0x4000-0x40ff]
[    0.393783] pci 0000:01:02.2: reg 0x14: [mem 0xf7ea0000-0xf7ea07ff]
[    0.394014] pci 0000:01:02.2: reg 0x18: [mem 0xf7e90000-0xf7e91fff]
[    0.394241] pci 0000:01:02.2: reg 0x1c: [mem 0xf7e00000-0xf7e7ffff]
[    0.394493] pci 0000:01:02.2: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.394741] pci 0000:01:02.2: PME# supported from D0 D3hot D3cold
[    0.395053] pci 0000:01:03.0: [1002:4752] type 00 class 0x030000
[    0.395286] pci 0000:01:03.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.396028] pci 0000:01:03.0: reg 0x14: [io  0x4400-0x44ff]
[    0.396213] pci 0000:01:03.0: reg 0x18: [mem 0xf5ff0000-0xf5ff0fff]
[    0.396430] pci 0000:01:03.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.396640] pci 0000:01:03.0: supports D1 D2
[    0.396902] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.397077] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.397257] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.397520] pci 0000:02:04.0: [0e11:b178] type 00 class 0x010400
[    0.397714] pci 0000:02:04.0: reg 0x10: [mem 0xf7fc0000-0xf7ffffff 64bit]
[    0.397899] pci 0000:02:04.0: reg 0x18: [io  0x5000-0x50ff]
[    0.398082] pci 0000:02:04.0: reg 0x1c: [mem 0xf5ef0000-0xf5ef3fff 64bit pref]
[    0.398366] pci 0000:02:04.0: reg 0x30: [mem 0x00000000-0x00003fff pref]
[    0.398573] pci 0000:02:04.0: supports D1
[    0.398815] pci 0000:02:06.0: [14e4:1648] type 00 class 0x020000
[    0.399005] pci 0000:02:06.0: reg 0x10: [mem 0xf7fb0000-0xf7fbffff 64bit]
[    0.399239] pci 0000:02:06.0: PME# supported from D3hot D3cold
[    0.399488] pci 0000:02:06.1: [14e4:1648] type 00 class 0x020000
[    0.399678] pci 0000:02:06.1: reg 0x10: [mem 0xf7fa0000-0xf7faffff 64bit]
[    0.399913] pci 0000:02:06.1: PME# supported from D3hot D3cold
[    0.400094] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.400270] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.400449] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.400632] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.401071] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.402282] ACPI: PCI Root Bridge [CFG1] (domain 0000 [bus 04-08])
[    0.402463] acpi PNP0A03:01: _OSC: OS supports [Segments MSI]
[    0.402643] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.404387] acpi PNP0A03:01: host bridge window [io  0x6000-0xffff] (ignored)
[    0.404571] PCI: root bus 04: hardware-probed resources
[    0.404745] acpi PNP0A03:01: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.405085] PCI host bridge to bus 0000:04
[    0.405255] pci_bus 0000:04: root bus resource [bus 04-08]
[    0.405430] pci_bus 0000:04: root bus resource [io  0x6000-0xffff]
[    0.405608] pci_bus 0000:04: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.405807] pci 0000:04:09.0: [1022:7450] type 01 class 0x060400
[    0.406102] pci 0000:04:09.1: [1022:7451] type 00 class 0x080010
[    0.406385] pci 0000:04:0a.0: [1022:7450] type 01 class 0x060400
[    0.406672] pci 0000:04:0a.1: [1022:7451] type 00 class 0x080010
[    0.406954] pci 0000:04:0b.0: [1022:7450] type 01 class 0x060400
[    0.407228] pci 0000:04:0b.1: [1022:7451] type 00 class 0x080010
[    0.407501] pci 0000:04:0c.0: [1022:7450] type 01 class 0x060400
[    0.407774] pci 0000:04:0c.1: [1022:7451] type 00 class 0x080010
[    0.408193] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.408498] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.408835] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.409158] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.409581] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 *7 10 11)
[    0.410230] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 7 *10 11)
[    0.410875] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 7 10 *11)
[    0.411519] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *5 7 10 11)
[    0.412143] ACPI: \_SB_.CFG0: notify handler is installed
[    0.412342] ACPI: \_SB_.CFG1: notify handler is installed
[    0.412546] Found 2 acpi root devices
[    0.412880] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    0.412880] vgaarb: loaded
[    0.412880] vgaarb: bridge control possible 0000:01:03.0
[    0.412880] SCSI subsystem initialized
[    0.413010] PCI: Using ACPI for IRQ routing
[    0.413180] PCI: pci_cache_line_size set to 64 bytes
[    0.413435] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.413613] e820: reserve RAM buffer [mem 0xbfff6800-0xbfffffff]
[    0.413789] e820: reserve RAM buffer [mem 0x3fffff000-0x3ffffffff]
[    0.414281] Switched to clocksource refined-jiffies
[    0.414281] pnp: PnP ACPI init
[    0.414281] ACPI: bus type PNP registered
[    0.416457] system 00:00: [io  0x0230-0x0233] has been reserved
[    0.416639] system 00:00: [io  0x0260-0x0267] has been reserved
[    0.416821] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.417002] system 00:00: [io  0x0800-0x081f] has been reserved
[    0.417182] system 00:00: [io  0x0900-0x0903] has been reserved
[    0.417363] system 00:00: [io  0x0904-0x0907] has been reserved
[    0.417545] system 00:00: [io  0x0908-0x090b] has been reserved
[    0.417726] system 00:00: [io  0x090c-0x092e] has been reserved
[    0.417907] system 00:00: [io  0x092f] has been reserved
[    0.418086] system 00:00: [io  0x0930-0x09ff] has been reserved
[    0.418267] system 00:00: [io  0x0c80-0x0c87] has been reserved
[    0.418449] system 00:00: [io  0x0cf9] could not be reserved
[    0.418630] system 00:00: [io  0x02f8-0x02ff] has been reserved
[    0.418817] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.419021] pnp 00:01: [dma 7]
[    0.419224] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.419441] pnp 00:02: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.419697] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.420053] pnp 00:04: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.420371] pnp 00:05: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.420827] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.421307] pnp 00:07: [dma 2]
[    0.421525] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.421964] pnp: PnP ACPI: found 8 devices
[    0.422137] ACPI: bus type PNP unregistered
[    0.429307] Switched to clocksource acpi_pm
[    0.429307] pci 0000:00:03.0: BAR 15: assigned [mem 0xc0000000-0xc00fffff pref]
[    0.429307] pci 0000:01:03.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
[    0.429307] pci 0000:01:02.2: BAR 6: assigned [mem 0xc0020000-0xc002ffff pref]
[    0.429307] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.429481] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.429668] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.429858] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xc00fffff pref]
[    0.430151] pci 0000:02:04.0: BAR 6: assigned [mem 0xf5e00000-0xf5e03fff pref]
[    0.430436] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.430616] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.430838] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.431028] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.431319] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.431507] pci_bus 0000:00: resource 4 [io  0x0000-0x5fff]
[    0.431689] pci_bus 0000:00: resource 5 [mem 0xc0000000-0xf7ffffff]
[    0.431873] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.432072] pci_bus 0000:00: resource 7 [mem 0xfe000000-0xffffffff]
[    0.432258] pci_bus 0000:00: resource 8 [mem 0x400000000-0xfcffffffff]
[    0.432443] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    0.432624] pci_bus 0000:01: resource 1 [mem 0xf5f00000-0xf7efffff]
[    0.432808] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc00fffff pref]
[    0.432996] pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
[    0.433178] pci_bus 0000:02: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    0.433361] pci_bus 0000:02: resource 2 [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.433672] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.433859] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.434046] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.434230] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.434415] pci_bus 0000:04: resource 4 [io  0x6000-0xffff]
[    0.434597] pci_bus 0000:04: resource 5 [mem 0xf8000000-0xfdffffff]
[    0.434943] NET: Registered protocol family 2
[    0.435635] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.436996] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.437995] TCP: Hash tables configured (established 131072 bind 65536)
[    0.438308] TCP: reno registered
[    0.438539] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.438994] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.439623] NET: Registered protocol family 1
[    0.439850] pci 0000:00:04.3: boot interrupts on device [1022:746b] already disabled
[    0.440191] pci 0000:00:07.0: MSI quirk detected; subordinate MSI disabled
[    0.440380] pci 0000:00:07.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.440573] pci 0000:00:08.0: MSI quirk detected; subordinate MSI disabled
[    0.440760] pci 0000:00:08.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.584087] pci 0000:01:03.0: Boot video device
[    0.584287] pci 0000:04:09.0: MSI quirk detected; subordinate MSI disabled
[    0.584516] pci 0000:04:09.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.584753] pci 0000:04:0a.0: MSI quirk detected; subordinate MSI disabled
[    0.584981] pci 0000:04:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.585218] pci 0000:04:0b.0: MSI quirk detected; subordinate MSI disabled
[    0.585443] pci 0000:04:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.585677] pci 0000:04:0c.0: MSI quirk detected; subordinate MSI disabled
[    0.585903] pci 0000:04:0c.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.586093] PCI: CLS 64 bytes, default 64
[    0.589330] PCI-DMA: Disabling AGP.
[    0.589875] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    0.590090] PCI-DMA: using GART IOMMU.
[    0.590295] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.599674] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.617401] gcov: could not create file
[    0.684694] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.689464] msgmni has been set to 30074
[    0.690090] cryptomgr_test (65) used greatest stack depth: 7224 bytes left
[    0.690359] cryptomgr_test (66) used greatest stack depth: 6840 bytes left
[    0.690932] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.691293] io scheduler noop registered
[    0.691507] io scheduler deadline registered
[    0.691763] io scheduler cfq registered (default)
[    0.692134] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.692523] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.692890] ACPI: Power Button [PWRF]
[    0.693183] ACPI: processor limited to max C-state 1
[    0.693658] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.714472] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.763827] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    0.764812] Linux agpgart interface v0.103
[    0.765016] HP CISS Driver (v 3.6.26)
[    0.765605] cciss 0000:02:04.0: Controller reports max supported commands of 0, an obvious lie. Using 16.  Ensure that firmware is up to date.
[    0.964349] cciss 0000:02:04.0: cciss0: <0xb178> at PCI 0000:02:04.0 IRQ 18 using DAC
[    0.967412]  cciss/c0d0: p1 p2 < p5 >
[    0.968125] scsi0 : cciss
[    0.968593] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.970780] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.970963] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.971359] mousedev: PS/2 mouse device common for all mice
[    0.971622] rtc_cmos rtc_cmos: RTC can wake from S4
[    0.971997] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.972268] rtc_cmos rtc_cmos: alarms up to one year, y3k, 114 bytes nvram
[    0.972659] TCP: cubic registered
[    0.973034] NET: Registered protocol family 10
[    0.973520] NET: Registered protocol family 17
[    0.973705] Key type dns_resolver registered
[    0.974399] registered taskstats version 1
[    0.976689] rtc_cmos rtc_cmos: setting system clock to 2014-01-22 15:33:41 UTC (1390404821)
[    1.022923] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.031144] EXT4-fs (cciss!c0d0p1): couldn't mount as ext3 due to feature incompatibilities
[    1.031820] EXT4-fs (cciss!c0d0p1): couldn't mount as ext2 due to feature incompatibilities
[    1.034725] EXT4-fs (cciss!c0d0p1): INFO: recovery required on readonly filesystem
[    1.035002] EXT4-fs (cciss!c0d0p1): write access will be enabled during recovery
[    1.081519] EXT4-fs (cciss!c0d0p1): recovery complete
[    1.083430] EXT4-fs (cciss!c0d0p1): mounted filesystem with ordered data mode. Opts: (null)
[    1.083802] VFS: Mounted root (ext4 filesystem) readonly on device 104:1.
[    1.098495] devtmpfs: mounted
[    1.100440] Freeing unused kernel memory: 872K (ffffffff81ce0000 - ffffffff81dba000)
[    1.100761] Write protecting the kernel read-only data: 10240k
[    1.108396] Freeing unused kernel memory: 1912K (ffff880001622000 - ffff880001800000)
[    1.111602] Freeing unused kernel memory: 772K (ffff88000193f000 - ffff880001a00000)
[    1.675465] modprobe (79) used greatest stack depth: 4664 bytes left
[    2.414806] udevd[196]: starting version 175
[    2.499868] mv (220) used greatest stack depth: 4648 bytes left
[    2.738629] shpchp 0000:00:07.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.738945] shpchp 0000:00:07.0: Cannot reserve MMIO region
[    2.739146] shpchp 0000:00:08.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.739459] shpchp 0000:00:08.0: Cannot reserve MMIO region
[    2.739763] shpchp 0000:04:09.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.740193] shpchp 0000:04:09.0: Cannot reserve MMIO region
[    2.743391] shpchp 0000:04:0a.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.743690] shpchp 0000:04:0a.0: Cannot reserve MMIO region
[    2.743986] shpchp 0000:04:0b.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.744325] shpchp 0000:04:0b.0: Cannot reserve MMIO region
[    2.744603] shpchp 0000:04:0c.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.744895] shpchp 0000:04:0c.0: Cannot reserve MMIO region
[    2.745371] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.778828] Floppy drive(s): fd0 is 1.44M
[    2.800978] FDC 0 is a National Semiconductor PC87306
[    2.823899] ioapic: probe of 0000:00:07.1 failed with error -22
[    2.824281] ioapic: probe of 0000:00:08.1 failed with error -22
[    2.829318] ioapic: probe of 0000:04:09.1 failed with error -22
[    2.829564] ioapic: probe of 0000:04:0a.1 failed with error -22
[    2.829764] ioapic: probe of 0000:04:0b.1 failed with error -22
[    2.829962] ioapic: probe of 0000:04:0c.1 failed with error -22
[    2.839512] hpwdt 0000:01:02.0: This server does not have an iLO2+ ASIC.
[    2.891602] EDAC MC: Ver: 3.0.0
[    2.898151] libata version 3.00 loaded.
[    2.902840] BUG: unable to handle kernel paging request at 00000000b4343e88
[    2.903158] IP: [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.903408] PGD 0 
[    2.903510] AMD768 RNG detected
[    2.903823] Oops: 0000 [#1] SMP 
[    2.904131] Modules linked in: amd_rng pata_amd(+) libata edac_core usb_common hpwdt ioapic k8temp floppy shpchp evdev
[    2.905151] CPU: 3 PID: 323 Comm: modprobe Not tainted 3.13.0 #45
[    2.905332] Hardware name: HP ProLiant DL585 G1, BIOS A01 02/14/2007
[    2.905514] task: ffff8801f9f76600 ti: ffff8801f9d8e000 task.ti: ffff8801f9d8e000
[    2.905793] RIP: 0010:[<ffffffff8109e31b>]  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.905883] RSP: 0018:ffff8801f9d8fd78  EFLAGS: 00010202
[    2.905883] RAX: ffffffff81ba70c0 RBX: 00000000b4343e88 RCX: 0000000000001951
[    2.905883] RDX: ffffffff81ac40a8 RSI: 00000000000149a0 RDI: 00000000b4343e88
[    2.905883] RBP: ffffffffa0012718 R08: 00000000000149a0 R09: ffff8803ffa149a0
[    2.905883] R10: ffffea000fe69680 R11: ffff8800b8803b00 R12: ffffffffa0012700
[    2.905883] R13: ffff8801f9d8fe78 R14: 0000000000000000 R15: 0000000000000000
[    2.905883] FS:  00007f387d0e7700(0000) GS:ffff8803ffa00000(0000) knlGS:0000000000000000
[    2.905883] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.905883] CR2: 00000000b4343e88 CR3: 00000003f99fe000 CR4: 00000000000007e0
[    2.905883] Stack:
[    2.905883]  ffffffff81ac40a0 ffffffff81607663 ffffffffa0011240 ffffffff8160772b
[    2.905883]  0000000000000000 ffffffff81110ac5 0000000000000000 ffffffff810f7b2b
[    2.908898]  ffffffff810f4000 0000000000000000 0000000000000000 ffffffff00000003
[    2.908898] Call Trace:
[    2.908898]  [<ffffffff81607663>] ? __mutex_unlock_slowpath+0x53/0x80
[    2.908898]  [<ffffffff8160772b>] ? mutex_unlock+0x2b/0x40
[    2.908898]  [<ffffffff81110ac5>] ? __gcov_init+0x65/0xb0
[    2.908898]  [<ffffffff810f7b2b>] ? load_module+0x223b/0x2710
[    2.908898]  [<ffffffff810f4000>] ? get_modinfo.isra.35+0x110/0x110
[    2.908898]  [<ffffffff8160a0f2>] ? page_fault+0x22/0x30
[    2.908898]  [<ffffffff810f80ee>] ? SyS_init_module+0xee/0x140
[    2.908898]  [<ffffffff816131a1>] ? tracesys+0xd4/0xd9
[    2.908898] Code: 48 83 ec 08 31 d2 48 ff 05 13 58 da 00 e8 ae fb ff ff 48 ff 05 0f 58 da 00 48 83 c4 08 c3 66 90 48 ff 05 a9 54 da 00 53 48 89 fb <48> 8b 07 a8 0c 75 18 48 89 df 31 d2 be 03 00 00 00 e8 7f fb ff 
[    2.908898] RIP  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.908898]  RSP <ffff8801f9d8fd78>
[    2.908898] CR2: 00000000b4343e88
[    2.916317] ---[ end trace 973dd11151d177ba ]---
[    2.917618] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.946614] ACPI: bus type USB registered
[    2.946891] usbcore: registered new interface driver usbfs
[    2.947109] usbcore: registered new interface driver hub
[    2.947510] usbcore: registered new device driver usb
[    2.954139] pps_core: LinuxPPS API ver. 1 registered
[    2.954339] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.966554] PTP clock support registered
[    2.990198] tg3.c:v3.134 (Sep 16, 2013)
[    3.003316] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.007771] MCE: In-kernel MCE decoding enabled.
[    3.029302] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.039727] tg3 0000:02:06.0 eth0: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e3
[    3.040053] tg3 0000:02:06.0 eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    3.040342] tg3 0000:02:06.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[    3.040620] tg3 0000:02:06.0 eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[    3.051824] AMD64 EDAC driver v3.4.0
[    3.052083] EDAC amd64: DRAM ECC enabled.
[    3.052259] EDAC amd64: K8 revE or earlier detected (node 0).
[    3.052500] EDAC amd64: CS6: Registered Double data rate SDRAM
[    3.052677] EDAC amd64: CS7: Registered Double data rate SDRAM
[    3.053106] EDAC MC0: Giving out device to module amd64_edac controller K8: DEV 0000:00:18.2 (INTERRUPT)
[    3.053506] EDAC amd64: DRAM ECC enabled.
[    3.055500] EDAC amd64: K8 revE or earlier detected (node 1).
[    3.055759] EDAC amd64: CS6: Registered Double data rate SDRAM
[    3.055945] EDAC amd64: CS7: Registered Double data rate SDRAM
[    3.056572] EDAC MC1: Giving out device to module amd64_edac controller K8: DEV 0000:00:19.2 (INTERRUPT)
[    3.057060] EDAC amd64: DRAM ECC enabled.
[    3.057280] EDAC amd64: K8 revE or earlier detected (node 2).
[    3.057559] EDAC amd64: CS6: Registered Double data rate SDRAM
[    3.057742] EDAC amd64: CS7: Registered Double data rate SDRAM
[    3.058162] EDAC MC2: Giving out device to module amd64_edac controller K8: DEV 0000:00:1a.2 (INTERRUPT)
[    3.058594] EDAC amd64: DRAM ECC enabled.
[    3.058799] EDAC amd64: K8 revE or earlier detected (node 3).
[    3.059088] EDAC amd64: CS6: Registered Double data rate SDRAM
[    3.059274] EDAC amd64: CS7: Registered Double data rate SDRAM
[    3.059742] EDAC MC3: Giving out device to module amd64_edac controller K8: DEV 0000:00:1b.2 (INTERRUPT)
[    3.060252] EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
[    3.104784] tg3 0000:02:06.1 eth1: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e2
[    3.105083] tg3 0000:02:06.1 eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    3.105368] tg3 0000:02:06.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    3.105645] tg3 0000:02:06.1 eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[    3.107665] ohci-pci: OHCI PCI platform driver
[    3.108335] ohci-pci 0000:01:00.0: OHCI PCI host controller
[    3.108579] ohci-pci 0000:01:00.0: new USB bus registered, assigned bus number 1
[    3.108959] ohci-pci 0000:01:00.0: irq 19, io mem 0xf7ef0000
[    3.166199] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    3.166393] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.166667] usb usb1: Product: OHCI PCI host controller
[    3.166849] usb usb1: Manufacturer: Linux 3.13.0 ohci_hcd
[    3.167023] usb usb1: SerialNumber: 0000:01:00.0
[    3.167465] hub 1-0:1.0: USB hub found
[    3.167679] hub 1-0:1.0: 3 ports detected
[    3.168438] ohci-pci 0000:01:00.1: OHCI PCI host controller
[    3.168625] ohci-pci 0000:01:00.1: new USB bus registered, assigned bus number 2
[    3.168935] ohci-pci 0000:01:00.1: irq 19, io mem 0xf7ee0000
[    3.226121] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.226308] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.226658] usb usb2: Product: OHCI PCI host controller
[    3.226863] usb usb2: Manufacturer: Linux 3.13.0 ohci_hcd
[    3.227067] usb usb2: SerialNumber: 0000:01:00.1
[    3.227459] hub 2-0:1.0: USB hub found
[    3.227685] hub 2-0:1.0: 3 ports detected
[    3.443046] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    3.601263] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
[    4.052221] random: nonblocking pool is initialized
[    4.080996] Adding 2927612k swap on /dev/cciss/c0d0p5.  Priority:-1 extents:1 across:2927612k 
[    4.106768] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: (null)
[    4.238578] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: errors=remount-ro
[    4.440808] loop: module loaded
[    5.898495] ip (1493) used greatest stack depth: 4264 bytes left
[    6.332945] RPC: Registered named UNIX socket transport module.
[    6.333233] RPC: Registered udp transport module.
[    6.333403] RPC: Registered tcp transport module.
[    6.333573] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    6.358649] FS-Cache: Loaded
[    6.401705] FS-Cache: Netfs 'nfs' registered for caching
[    6.467861] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    6.846236] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.086894] powernow-k8: Power state transitions not supported
[    8.087107] powernow-k8: Power state transitions not supported
[    8.087334] powernow-k8: Power state transitions not supported
[    8.087561] powernow-k8: Power state transitions not supported
[    8.470772] tg3 0000:02:06.0 eth0: Link is up at 100 Mbps, full duplex
[    8.471071] tg3 0000:02:06.0 eth0: Flow control is on for TX and on for RX
[    8.471307] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready


================================

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0 (mroos@dl585) (gcc version 4.7.2 (Debian 4.7.2-5) ) #45 SMP Tue Jan 21 11:57:29 EET 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro ignore_loglevel initcall_debug=1
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
[    0.000000] debug: ignoring loglevel setting.
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
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0 root=/dev/cciss/c0d0p1 ro ignore_loglevel initcall_debug=1
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
[    0.000000] tsc: Detected 2197.104 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.012223] Calibrating delay loop (skipped), value calculated using timer frequency.. 4394.20 BogoMIPS (lpj=8788416)
[    0.012647] pid_max: default: 32768 minimum: 301
[    0.015439] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.032956] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.041193] Mount-cache hash table entries: 256
[    0.041819] Initializing cgroup subsys memory
[    0.042062] Initializing cgroup subsys devices
[    0.042270] Initializing cgroup subsys freezer
[    0.042480] Initializing cgroup subsys net_cls
[    0.042689] Initializing cgroup subsys blkio
[    0.042891] Initializing cgroup subsys perf_event
[    0.043095] Initializing cgroup subsys hugetlb
[    0.043340] tseg: 0000000000
[    0.043544] mce: CPU supports 5 MCE banks
[    0.043765] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.043765] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.043765] tlb_flushall_shift: 4
[    0.044110] Freeing SMP alternatives memory: 20K (ffffffff81dba000 - ffffffff81dbf000)
[    0.044460] ACPI: Core revision 20131115
[    0.048761] ACPI: All ACPI Tables successfully acquired
[    0.050020] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.089886] smpboot: CPU0: AMD Opteron (tm) Processor 848 (fam: 0f, model: 05, stepping: 08)
[    0.092000] calling  set_real_mode_permissions+0x0/0xbf @ 1
[    0.092000] initcall set_real_mode_permissions+0x0/0xbf returned 0 after 0 usecs
[    0.092000] calling  init_hw_perf_events+0x0/0x6e0 @ 1
[    0.092000] Performance Events: AMD PMU driver.
[    0.092000] ... version:                0
[    0.092000] ... bit width:              48
[    0.092000] ... generic registers:      4
[    0.092000] ... value mask:             0000ffffffffffff
[    0.092000] ... max period:             00007fffffffffff
[    0.092000] ... fixed-purpose events:   0
[    0.092000] ... event mask:             000000000000000f
[    0.092000] initcall init_hw_perf_events+0x0/0x6e0 returned 0 after 0 usecs
[    0.092000] calling  register_trigger_all_cpu_backtrace+0x0/0x21 @ 1
[    0.092000] initcall register_trigger_all_cpu_backtrace+0x0/0x21 returned 0 after 0 usecs
[    0.092000] calling  spawn_ksoftirqd+0x0/0x46 @ 1
[    0.092000] initcall spawn_ksoftirqd+0x0/0x46 returned 0 after 0 usecs
[    0.092000] calling  init_workqueues+0x0/0x773 @ 1
[    0.092000] initcall init_workqueues+0x0/0x773 returned 0 after 0 usecs
[    0.092006] calling  migration_init+0x0/0x9d @ 1
[    0.092209] initcall migration_init+0x0/0x9d returned 0 after 0 usecs
[    0.092430] calling  check_cpu_stall_init+0x0/0x26 @ 1
[    0.092643] initcall check_cpu_stall_init+0x0/0x26 returned 0 after 0 usecs
[    0.092848] calling  rcu_register_oom_notifier+0x0/0x1f @ 1
[    0.093068] initcall rcu_register_oom_notifier+0x0/0x1f returned 0 after 0 usecs
[    0.093413] calling  rcu_scheduler_really_started+0x0/0x14 @ 1
[    0.093631] initcall rcu_scheduler_really_started+0x0/0x14 returned 0 after 0 usecs
[    0.093974] calling  rcu_spawn_gp_kthread+0x0/0x1a5 @ 1
[    0.094565] initcall rcu_spawn_gp_kthread+0x0/0x1a5 returned 0 after 0 usecs
[    0.094785] calling  cpu_stop_init+0x0/0xa5 @ 1
[    0.095024] initcall cpu_stop_init+0x0/0xa5 returned 0 after 0 usecs
[    0.095246] calling  jump_label_init_module+0x0/0x1d @ 1
[    0.095460] initcall jump_label_init_module+0x0/0x1d returned 0 after 0 usecs
[    0.095686] calling  rand_initialize+0x0/0x50 @ 1
[    0.096030] initcall rand_initialize+0x0/0x50 returned 0 after 0 usecs
[    0.096456] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.096971] x86: Booting SMP configuration:
[    0.097178] .... node  #1, CPUs:      #1
[    0.188602] .... node  #2, CPUs:   #2
[    0.276537] .... node  #3, CPUs:   #3
[    0.364163] x86: Booted up 4 nodes, 4 CPUs
[    0.364485] smpboot: Total of 4 processors activated (17577.91 BogoMIPS)
[    0.366624] devtmpfs: initialized
[    0.366624] gcov: version magic: 0x3430372a
[    0.366624] calling  ipc_ns_init+0x0/0x21 @ 1
[    0.368028] initcall ipc_ns_init+0x0/0x21 returned 0 after 0 usecs
[    0.368208] calling  init_mmap_min_addr+0x0/0x18 @ 1
[    0.368382] initcall init_mmap_min_addr+0x0/0x18 returned 0 after 0 usecs
[    0.368566] calling  init_cpufreq_transition_notifier_list+0x0/0x26 @ 1
[    0.368751] initcall init_cpufreq_transition_notifier_list+0x0/0x26 returned 0 after 0 usecs
[    0.369031] calling  net_ns_init+0x0/0x167 @ 1
[    0.369336] initcall net_ns_init+0x0/0x167 returned 0 after 0 usecs
[    0.369336] calling  e820_mark_nvs_memory+0x0/0x52 @ 1
[    0.369336] initcall e820_mark_nvs_memory+0x0/0x52 returned 0 after 0 usecs
[    0.369336] calling  cpufreq_tsc+0x0/0x4c @ 1
[    0.369336] initcall cpufreq_tsc+0x0/0x4c returned 0 after 0 usecs
[    0.369336] calling  reboot_init+0x0/0x32 @ 1
[    0.369336] initcall reboot_init+0x0/0x32 returned 0 after 0 usecs
[    0.369336] calling  init_lapic_sysfs+0x0/0x36 @ 1
[    0.369471] initcall init_lapic_sysfs+0x0/0x36 returned 0 after 0 usecs
[    0.369651] calling  cpu_hotplug_pm_sync_init+0x0/0x1f @ 1
[    0.369827] initcall cpu_hotplug_pm_sync_init+0x0/0x1f returned 0 after 0 usecs
[    0.370101] calling  alloc_frozen_cpus+0x0/0xa @ 1
[    0.370272] initcall alloc_frozen_cpus+0x0/0xa returned 0 after 0 usecs
[    0.370451] calling  wq_sysfs_init+0x0/0x1f @ 1
[    0.372044] initcall wq_sysfs_init+0x0/0x1f returned 0 after 0 usecs
[    0.372224] calling  ksysfs_init+0x0/0xe6 @ 1
[    0.372399] initcall ksysfs_init+0x0/0xe6 returned 0 after 0 usecs
[    0.372577] calling  pm_init+0x0/0xca @ 1
[    0.372781] initcall pm_init+0x0/0xca returned 0 after 0 usecs
[    0.372960] calling  pm_disk_init+0x0/0x25 @ 1
[    0.373135] initcall pm_disk_init+0x0/0x25 returned 0 after 0 usecs
[    0.373315] calling  swsusp_header_init+0x0/0x50 @ 1
[    0.373489] initcall swsusp_header_init+0x0/0x50 returned 0 after 0 usecs
[    0.373670] calling  init_jiffies_clocksource+0x0/0x1d @ 1
[    0.373848] initcall init_jiffies_clocksource+0x0/0x1d returned 0 after 0 usecs
[    0.374121] calling  cgroup_wq_init+0x0/0x49 @ 1
[    0.374308] initcall cgroup_wq_init+0x0/0x49 returned 0 after 0 usecs
[    0.374488] calling  init_zero_pfn+0x0/0x42 @ 1
[    0.374660] initcall init_zero_pfn+0x0/0x42 returned 0 after 0 usecs
[    0.374839] calling  memory_failure_init+0x0/0xc8 @ 1
[    0.375013] initcall memory_failure_init+0x0/0xc8 returned 0 after 0 usecs
[    0.375193] calling  fsnotify_init+0x0/0x38 @ 1
[    0.375365] initcall fsnotify_init+0x0/0x38 returned 0 after 0 usecs
[    0.375543] calling  filelock_init+0x0/0xaf @ 1
[    0.375717] initcall filelock_init+0x0/0xaf returned 0 after 0 usecs
[    0.375895] calling  init_script_binfmt+0x0/0x2f @ 1
[    0.376010] initcall init_script_binfmt+0x0/0x2f returned 0 after 0 usecs
[    0.376190] calling  init_elf_binfmt+0x0/0x30 @ 1
[    0.376362] initcall init_elf_binfmt+0x0/0x30 returned 0 after 0 usecs
[    0.376542] calling  init_compat_elf_binfmt+0x0/0x31 @ 1
[    0.376717] initcall init_compat_elf_binfmt+0x0/0x31 returned 0 after 0 usecs
[    0.376898] calling  debugfs_init+0x0/0x86 @ 1
[    0.377072] initcall debugfs_init+0x0/0x86 returned 0 after 0 usecs
[    0.377250] calling  prandom_init+0x0/0x100 @ 1
[    0.377424] initcall prandom_init+0x0/0x100 returned 0 after 0 usecs
[    0.377602] calling  cpufreq_core_init+0x0/0x5f @ 1
[    0.377775] initcall cpufreq_core_init+0x0/0x5f returned 0 after 0 usecs
[    0.377955] calling  cpuidle_init+0x0/0x69 @ 1
[    0.378129] initcall cpuidle_init+0x0/0x69 returned 0 after 0 usecs
[    0.378307] calling  bsp_pm_check_init+0x0/0x1f @ 1
[    0.378479] initcall bsp_pm_check_init+0x0/0x1f returned 0 after 0 usecs
[    0.378659] calling  sock_init+0x0/0xec @ 1
[    0.378921] initcall sock_init+0x0/0xec returned 0 after 0 usecs
[    0.379140] calling  net_inuse_init+0x0/0x38 @ 1
[    0.379354] initcall net_inuse_init+0x0/0x38 returned 0 after 0 usecs
[    0.380006] calling  netpoll_init+0x0/0x32 @ 1
[    0.380214] initcall netpoll_init+0x0/0x32 returned 0 after 0 usecs
[    0.380433] calling  netlink_proto_init+0x0/0x2b1 @ 1
[    0.380652] NET: Registered protocol family 16
[    0.380877] initcall netlink_proto_init+0x0/0x2b1 returned 0 after 0 usecs
[    0.381101] calling  bdi_class_init+0x0/0x72 @ 1
[    0.381353] initcall bdi_class_init+0x0/0x72 returned 0 after 0 usecs
[    0.381574] calling  kobject_uevent_init+0x0/0x1d @ 1
[    0.381780] initcall kobject_uevent_init+0x0/0x1d returned 0 after 0 usecs
[    0.381993] calling  pcibus_class_init+0x0/0x24 @ 1
[    0.384028] initcall pcibus_class_init+0x0/0x24 returned 0 after 0 usecs
[    0.384251] calling  pci_driver_init+0x0/0x1d @ 1
[    0.384472] initcall pci_driver_init+0x0/0x1d returned 0 after 0 usecs
[    0.384689] calling  tty_class_init+0x0/0x48 @ 1
[    0.384905] initcall tty_class_init+0x0/0x48 returned 0 after 0 usecs
[    0.385118] calling  vtconsole_class_init+0x0/0x129 @ 1
[    0.385361] initcall vtconsole_class_init+0x0/0x129 returned 0 after 0 usecs
[    0.385585] calling  wakeup_sources_debugfs_init+0x0/0x36 @ 1
[    0.385803] initcall wakeup_sources_debugfs_init+0x0/0x36 returned 0 after 0 usecs
[    0.386148] calling  register_node_type+0x0/0x24 @ 1
[    0.386378] initcall register_node_type+0x0/0x24 returned 0 after 0 usecs
[    0.386600] calling  init_ladder+0x0/0x1f @ 1
[    0.386802] cpuidle: using governor ladder
[    0.387005] initcall init_ladder+0x0/0x1f returned 0 after 0 usecs
[    0.387222] calling  init_menu+0x0/0x1d @ 1
[    0.387424] cpuidle: using governor menu
[    0.387629] initcall init_menu+0x0/0x1d returned 0 after 0 usecs
[    0.387824] calling  amd_postcore_init+0x0/0x1ed @ 1
[    0.388012] node 0 link 0: io port [1000, 5fff]
[    0.388223] node 1 link 0: io port [6000, ffff]
[    0.388435] TOM: 00000000c0000000 aka 3072M
[    0.388646] node 0 link 0: mmio [f5f00000, f7ffffff]
[    0.388909] node 0 link 0: mmio [f5e00000, f5efffff]
[    0.389182] node 0 link 0: mmio [a0000, bffff]
[    0.389453] node 0 link 0: mmio [fe000000, ffffffff]
[    0.389726] node 1 link 0: mmio [f8000000, fdffffff]
[    0.389990] TOM2: 0000000400000000 aka 16384M
[    0.390196] bus: [bus 00-03] on node 0 link 0
[    0.390401] bus: 00 [io  0x0000-0x5fff]
[    0.390604] bus: 00 [mem 0xc0000000-0xf7ffffff]
[    0.390809] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.391015] bus: 00 [mem 0xfe000000-0xffffffff]
[    0.391218] bus: 00 [mem 0x400000000-0xfcffffffff]
[    0.391427] bus: [bus 04-08] on node 1 link 0
[    0.391635] bus: 04 [io  0x6000-0xffff]
[    0.391828] bus: 04 [mem 0xf8000000-0xfdffffff]
[    0.392006] initcall amd_postcore_init+0x0/0x1ed returned 0 after 3906 usecs
[    0.392243] calling  arch_kdebugfs_init+0x0/0x3b @ 1
[    0.392459] initcall arch_kdebugfs_init+0x0/0x3b returned 0 after 0 usecs
[    0.392680] calling  mtrr_if_init+0x0/0x9a @ 1
[    0.392891] initcall mtrr_if_init+0x0/0x9a returned 0 after 0 usecs
[    0.393109] calling  ffh_cstate_init+0x0/0x3f @ 1
[    0.393320] initcall ffh_cstate_init+0x0/0x3f returned -1 after 0 usecs
[    0.393543] calling  acpi_pci_init+0x0/0xa1 @ 1
[    0.393741] ACPI: bus type PCI registered
[    0.393949] initcall acpi_pci_init+0x0/0xa1 returned 0 after 0 usecs
[    0.394170] calling  dmi_id_init+0x0/0x4d4 @ 1
[    0.394419] initcall dmi_id_init+0x0/0x4d4 returned 0 after 0 usecs
[    0.394639] calling  iommu_init+0x0/0x7d @ 1
[    0.394832] initcall iommu_init+0x0/0x7d returned 0 after 0 usecs
[    0.395049] calling  pci_arch_init+0x0/0xbc @ 1
[    0.395270] PCI: Using configuration type 1 for base access
[    0.395491] initcall pci_arch_init+0x0/0xbc returned 0 after 0 usecs
[    0.395721] calling  topology_init+0x0/0xe9 @ 1
[    0.396219] initcall topology_init+0x0/0xe9 returned 0 after 0 usecs
[    0.396439] calling  mtrr_init_finialize+0x0/0x64 @ 1
[    0.396652] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.396860] mtrr: probably your BIOS does not setup all CPUs.
[    0.397077] mtrr: corrected configuration.
[    0.397285] initcall mtrr_init_finialize+0x0/0x64 returned 0 after 0 usecs
[    0.397507] calling  init_vdso+0x0/0x27e @ 1
[    0.397720] initcall init_vdso+0x0/0x27e returned 0 after 0 usecs
[    0.397938] calling  sysenter_setup+0x0/0x2d8 @ 1
[    0.398153] initcall sysenter_setup+0x0/0x2d8 returned 0 after 0 usecs
[    0.398364] calling  param_sysfs_init+0x0/0x296 @ 1
[    0.399081] initcall param_sysfs_init+0x0/0x296 returned 0 after 0 usecs
[    0.399296] calling  pm_sysrq_init+0x0/0x24 @ 1
[    0.399507] initcall pm_sysrq_init+0x0/0x24 returned 0 after 0 usecs
[    0.399723] calling  default_bdi_init+0x0/0x93 @ 1
[    0.400153] initcall default_bdi_init+0x0/0x93 returned 0 after 3906 usecs
[    0.400341] calling  mem_cgroup_init+0x0/0x2a3 @ 1
[    0.400579] initcall mem_cgroup_init+0x0/0x2a3 returned 0 after 0 usecs
[    0.400799] calling  init_bio+0x0/0x193 @ 1
[    0.401012] bio: create slab <bio-0> at 0
[    0.401302] initcall init_bio+0x0/0x193 returned 0 after 0 usecs
[    0.401302] calling  fsnotify_notification_init+0x0/0xad @ 1
[    0.401302] initcall fsnotify_notification_init+0x0/0xad returned 0 after 0 usecs
[    0.401302] calling  cryptomgr_init+0x0/0x1d @ 1
[    0.401302] initcall cryptomgr_init+0x0/0x1d returned 0 after 0 usecs
[    0.401302] calling  blk_settings_init+0x0/0x2c @ 1
[    0.401414] initcall blk_settings_init+0x0/0x2c returned 0 after 0 usecs
[    0.401630] calling  blk_ioc_init+0x0/0x35 @ 1
[    0.401842] initcall blk_ioc_init+0x0/0x35 returned 0 after 0 usecs
[    0.402060] calling  blk_softirq_init+0x0/0x99 @ 1
[    0.402260] initcall blk_softirq_init+0x0/0x99 returned 0 after 0 usecs
[    0.404007] calling  blk_iopoll_setup+0x0/0x99 @ 1
[    0.404220] initcall blk_iopoll_setup+0x0/0x99 returned 0 after 0 usecs
[    0.404429] calling  blk_mq_init+0x0/0x8c @ 1
[    0.404636] initcall blk_mq_init+0x0/0x8c returned 0 after 0 usecs
[    0.404853] calling  genhd_device_init+0x0/0xa2 @ 1
[    0.405129] initcall genhd_device_init+0x0/0xa2 returned 0 after 0 usecs
[    0.405129] calling  pci_slot_init+0x0/0x70 @ 1
[    0.405129] initcall pci_slot_init+0x0/0x70 returned 0 after 0 usecs
[    0.405129] calling  acpi_init+0x0/0x3f1 @ 1
[    0.405129] ACPI: Added _OSI(Module Device)
[    0.405180] ACPI: Added _OSI(Processor Device)
[    0.405357] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.405528] ACPI: Added _OSI(Processor Aggregator Device)
[    0.411943] ACPI: Interpreter enabled
[    0.412014] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.412416] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.412816] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131115/hwxface-580)
[    0.413225] ACPI: (supports S0 S4 S5)
[    0.413391] ACPI: Using IOAPIC for interrupt routing
[    0.413608] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.421877] ACPI: PCI Root Bridge [CFG0] (domain 0000 [bus 00-03])
[    0.422064] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.422247] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.424209] acpi PNP0A03:00: host bridge window [io  0x0000-0x03af] (ignored)
[    0.424391] acpi PNP0A03:00: host bridge window [io  0x03b0-0x03bb] (ignored)
[    0.424573] acpi PNP0A03:00: host bridge window [io  0x03c0-0x03df] (ignored)
[    0.424754] acpi PNP0A03:00: host bridge window [io  0x03e0-0x0fff] (ignored)
[    0.424936] acpi PNP0A03:00: host bridge window [io  0x1000-0x5fff] (ignored)
[    0.425120] acpi PNP0A03:00: host bridge window [mem 0xf5f00000-0xf7ffffff] (ignored)
[    0.425397] acpi PNP0A03:00: host bridge window [mem 0xf5e00000-0xf5efffff] (ignored)
[    0.425674] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.425953] PCI: root bus 00: hardware-probed resources
[    0.426134] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.426502] PCI host bridge to bus 0000:00
[    0.426675] pci_bus 0000:00: root bus resource [bus 00-03]
[    0.426850] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
[    0.427028] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xf7ffffff]
[    0.427208] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.427389] pci_bus 0000:00: root bus resource [mem 0xfe000000-0xffffffff]
[    0.427569] pci_bus 0000:00: root bus resource [mem 0x400000000-0xfcffffffff]
[    0.427774] pci 0000:00:03.0: [1022:7460] type 01 class 0x060400
[    0.428143] pci 0000:00:04.0: [1022:7468] type 00 class 0x060100
[    0.428453] pci 0000:00:04.1: [1022:7469] type 00 class 0x01018a
[    0.428668] pci 0000:00:04.1: reg 0x20: [io  0x2000-0x200f]
[    0.428925] pci 0000:00:04.3: [1022:746b] type 00 class 0x068000
[    0.429238] pci 0000:00:07.0: [1022:7450] type 01 class 0x060400
[    0.429524] pci 0000:00:07.1: [1022:7451] type 00 class 0x080010
[    0.429804] pci 0000:00:08.0: [1022:7450] type 01 class 0x060400
[    0.430080] pci 0000:00:08.1: [1022:7451] type 00 class 0x080010
[    0.430385] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.430643] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.430898] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.431146] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.431400] pci 0000:00:19.0: [1022:1100] type 00 class 0x060000
[    0.431666] pci 0000:00:19.1: [1022:1101] type 00 class 0x060000
[    0.431916] pci 0000:00:19.2: [1022:1102] type 00 class 0x060000
[    0.432076] pci 0000:00:19.3: [1022:1103] type 00 class 0x060000
[    0.432333] pci 0000:00:1a.0: [1022:1100] type 00 class 0x060000
[    0.432597] pci 0000:00:1a.1: [1022:1101] type 00 class 0x060000
[    0.432848] pci 0000:00:1a.2: [1022:1102] type 00 class 0x060000
[    0.433100] pci 0000:00:1a.3: [1022:1103] type 00 class 0x060000
[    0.433354] pci 0000:00:1b.0: [1022:1100] type 00 class 0x060000
[    0.433615] pci 0000:00:1b.1: [1022:1101] type 00 class 0x060000
[    0.433868] pci 0000:00:1b.2: [1022:1102] type 00 class 0x060000
[    0.434118] pci 0000:00:1b.3: [1022:1103] type 00 class 0x060000
[    0.434444] pci 0000:01:00.0: [1022:7464] type 00 class 0x0c0310
[    0.434634] pci 0000:01:00.0: reg 0x10: [mem 0xf7ef0000-0xf7ef0fff]
[    0.434928] pci 0000:01:00.1: [1022:7464] type 00 class 0x0c0310
[    0.435120] pci 0000:01:00.1: reg 0x10: [mem 0xf7ee0000-0xf7ee0fff]
[    0.435425] pci 0000:01:02.0: [0e11:b203] type 00 class 0x088000
[    0.435620] pci 0000:01:02.0: reg 0x10: [io  0x4800-0x48ff]
[    0.435805] pci 0000:01:02.0: reg 0x14: [mem 0xf7eb0000-0xf7eb01ff]
[    0.436143] pci 0000:01:02.2: [0e11:b204] type 00 class 0x088000
[    0.436341] pci 0000:01:02.2: reg 0x10: [io  0x4000-0x40ff]
[    0.436527] pci 0000:01:02.2: reg 0x14: [mem 0xf7ea0000-0xf7ea07ff]
[    0.438422] pci 0000:01:02.2: reg 0x18: [mem 0xf7e90000-0xf7e91fff]
[    0.438609] pci 0000:01:02.2: reg 0x1c: [mem 0xf7e00000-0xf7e7ffff]
[    0.438818] pci 0000:01:02.2: reg 0x30: [mem 0x00000000-0x0000ffff pref]
[    0.439032] pci 0000:01:02.2: PME# supported from D0 D3hot D3cold
[    0.439297] pci 0000:01:03.0: [1002:4752] type 00 class 0x030000
[    0.439492] pci 0000:01:03.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.439680] pci 0000:01:03.0: reg 0x14: [io  0x4400-0x44ff]
[    0.439864] pci 0000:01:03.0: reg 0x18: [mem 0xf5ff0000-0xf5ff0fff]
[    0.440045] pci 0000:01:03.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.440259] pci 0000:01:03.0: supports D1 D2
[    0.440518] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.440694] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.440874] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.441127] pci 0000:02:04.0: [0e11:b178] type 00 class 0x010400
[    0.441322] pci 0000:02:04.0: reg 0x10: [mem 0xf7fc0000-0xf7ffffff 64bit]
[    0.441507] pci 0000:02:04.0: reg 0x18: [io  0x5000-0x50ff]
[    0.441690] pci 0000:02:04.0: reg 0x1c: [mem 0xf5ef0000-0xf5ef3fff 64bit pref]
[    0.441974] pci 0000:02:04.0: reg 0x30: [mem 0x00000000-0x00003fff pref]
[    0.442183] pci 0000:02:04.0: supports D1
[    0.442422] pci 0000:02:06.0: [14e4:1648] type 00 class 0x020000
[    0.442612] pci 0000:02:06.0: reg 0x10: [mem 0xf7fb0000-0xf7fbffff 64bit]
[    0.442847] pci 0000:02:06.0: PME# supported from D3hot D3cold
[    0.443092] pci 0000:02:06.1: [14e4:1648] type 00 class 0x020000
[    0.443282] pci 0000:02:06.1: reg 0x10: [mem 0xf7fa0000-0xf7faffff 64bit]
[    0.443517] pci 0000:02:06.1: PME# supported from D3hot D3cold
[    0.443780] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.444009] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.444189] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.444372] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.444815] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.446032] ACPI: PCI Root Bridge [CFG1] (domain 0000 [bus 04-08])
[    0.446363] acpi PNP0A03:01: _OSC: OS supports [Segments MSI]
[    0.446543] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.448241] acpi PNP0A03:01: host bridge window [io  0x6000-0xffff] (ignored)
[    0.448425] PCI: root bus 04: hardware-probed resources
[    0.448600] acpi PNP0A03:01: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.448941] PCI host bridge to bus 0000:04
[    0.449110] pci_bus 0000:04: root bus resource [bus 04-08]
[    0.449286] pci_bus 0000:04: root bus resource [io  0x6000-0xffff]
[    0.449463] pci_bus 0000:04: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.449664] pci 0000:04:09.0: [1022:7450] type 01 class 0x060400
[    0.449957] pci 0000:04:09.1: [1022:7451] type 00 class 0x080010
[    0.450242] pci 0000:04:0a.0: [1022:7450] type 01 class 0x060400
[    0.450528] pci 0000:04:0a.1: [1022:7451] type 00 class 0x080010
[    0.450814] pci 0000:04:0b.0: [1022:7450] type 01 class 0x060400
[    0.451088] pci 0000:04:0b.1: [1022:7451] type 00 class 0x080010
[    0.451365] pci 0000:04:0c.0: [1022:7450] type 01 class 0x060400
[    0.451639] pci 0000:04:0c.1: [1022:7451] type 00 class 0x080010
[    0.452051] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.452361] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.452706] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.453039] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.453472] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 *7 10 11)
[    0.454124] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 7 *10 11)
[    0.454770] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 7 10 *11)
[    0.455416] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *5 7 10 11)
[    0.456161] ACPI: \_SB_.CFG0: notify handler is installed
[    0.456361] ACPI: \_SB_.CFG1: notify handler is installed
[    0.456565] Found 2 acpi root devices
[    0.456809] initcall acpi_init+0x0/0x3f1 returned 0 after 50781 usecs
[    0.456990] calling  pnp_init+0x0/0x1d @ 1
[    0.457172] initcall pnp_init+0x0/0x1d returned 0 after 0 usecs
[    0.457349] calling  misc_init+0x0/0x116 @ 1
[    0.457535] initcall misc_init+0x0/0x116 returned 0 after 0 usecs
[    0.457714] calling  vga_arb_device_init+0x0/0x147 @ 1
[    0.457957] vgaarb: device added: PCI:0000:01:03.0,decodes=io+mem,owns=io+mem,locks=none
[    0.457957] vgaarb: loaded
[    0.457957] vgaarb: bridge control possible 0000:01:03.0
[    0.457957] initcall vga_arb_device_init+0x0/0x147 returned 0 after 0 usecs
[    0.457957] calling  dma_buf_init+0x0/0xa4 @ 1
[    0.457957] initcall dma_buf_init+0x0/0xa4 returned 0 after 0 usecs
[    0.457957] calling  init_scsi+0x0/0xfd @ 1
[    0.457957] SCSI subsystem initialized
[    0.457957] initcall init_scsi+0x0/0xfd returned 0 after 0 usecs
[    0.457957] calling  serio_init+0x0/0x43 @ 1
[    0.460009] initcall serio_init+0x0/0x43 returned 0 after 3906 usecs
[    0.460190] calling  input_init+0x0/0x1ac @ 1
[    0.460371] initcall input_init+0x0/0x1ac returned 0 after 0 usecs
[    0.460548] calling  rtc_init+0x0/0x82 @ 1
[    0.460722] initcall rtc_init+0x0/0x82 returned 0 after 0 usecs
[    0.460899] calling  power_supply_class_init+0x0/0x5b @ 1
[    0.461079] initcall power_supply_class_init+0x0/0x5b returned 0 after 0 usecs
[    0.461351] calling  hwmon_init+0x0/0x19a @ 1
[    0.461532] initcall hwmon_init+0x0/0x19a returned 0 after 0 usecs
[    0.461709] calling  watchdog_init+0x0/0x95 @ 1
[    0.461885] initcall watchdog_init+0x0/0x95 returned 0 after 0 usecs
[    0.462063] calling  leds_init+0x0/0x50 @ 1
[    0.462237] initcall leds_init+0x0/0x50 returned 0 after 0 usecs
[    0.462415] calling  pci_subsys_init+0x0/0x90 @ 1
[    0.462586] PCI: Using ACPI for IRQ routing
[    0.462755] PCI: pci_cache_line_size set to 64 bytes
[    0.463014] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.463192] e820: reserve RAM buffer [mem 0xbfff6800-0xbfffffff]
[    0.463369] e820: reserve RAM buffer [mem 0x3fffff000-0x3ffffffff]
[    0.463551] initcall pci_subsys_init+0x0/0x90 returned 0 after 0 usecs
[    0.463730] calling  proto_init+0x0/0x1d @ 1
[    0.463903] initcall proto_init+0x0/0x1d returned 0 after 0 usecs
[    0.464007] calling  net_dev_init+0x0/0x2e1 @ 1
[    0.464338] initcall net_dev_init+0x0/0x2e1 returned 0 after 0 usecs
[    0.464517] calling  neigh_init+0x0/0xa7 @ 1
[    0.464687] initcall neigh_init+0x0/0xa7 returned 0 after 0 usecs
[    0.464864] calling  fib_rules_init+0x0/0xf9 @ 1
[    0.465036] initcall fib_rules_init+0x0/0xf9 returned 0 after 0 usecs
[    0.465214] calling  pktsched_init+0x0/0x169 @ 1
[    0.465390] initcall pktsched_init+0x0/0x169 returned 0 after 0 usecs
[    0.465568] calling  tc_filter_init+0x0/0x6e @ 1
[    0.465740] initcall tc_filter_init+0x0/0x6e returned 0 after 0 usecs
[    0.465918] calling  tc_action_init+0x0/0x6e @ 1
[    0.466089] initcall tc_action_init+0x0/0x6e returned 0 after 0 usecs
[    0.466268] calling  genl_init+0x0/0xc5 @ 1
[    0.466446] initcall genl_init+0x0/0xc5 returned 0 after 0 usecs
[    0.466644] calling  nmi_warning_debugfs+0x0/0x32 @ 1
[    0.466821] initcall nmi_warning_debugfs+0x0/0x32 returned 0 after 0 usecs
[    0.467002] calling  hpet_late_init+0x0/0x18f @ 1
[    0.467173] initcall hpet_late_init+0x0/0x18f returned -19 after 0 usecs
[    0.467352] calling  init_amd_nbs+0x0/0x66 @ 1
[    0.467617] initcall init_amd_nbs+0x0/0x66 returned 0 after 0 usecs
[    0.467797] calling  clocksource_done_booting+0x0/0x69 @ 1
[    0.468105] Switched to clocksource refined-jiffies
[    0.468330] initcall clocksource_done_booting+0x0/0x69 returned 0 after 0 usecs
[    0.468619] calling  init_pipe_fs+0x0/0x6c @ 1
[    0.468958] initcall init_pipe_fs+0x0/0x6c returned 0 after 0 usecs
[    0.469144] calling  eventpoll_init+0x0/0xf3 @ 1
[    0.469338] initcall eventpoll_init+0x0/0xf3 returned 0 after 0 usecs
[    0.469525] calling  anon_inode_init+0x0/0x7c @ 1
[    0.469721] initcall anon_inode_init+0x0/0x7c returned 0 after 0 usecs
[    0.469909] calling  blk_scsi_ioctl_init+0x0/0x4cd @ 1
[    0.470093] initcall blk_scsi_ioctl_init+0x0/0x4cd returned 0 after 0 usecs
[    0.470281] calling  acpi_event_init+0x0/0x7a @ 1
[    0.470502] initcall acpi_event_init+0x0/0x7a returned 0 after 0 usecs
[    0.470688] calling  pnp_system_init+0x0/0x1d @ 1
[    0.470925] initcall pnp_system_init+0x0/0x1d returned 0 after 0 usecs
[    0.471111] calling  pnpacpi_init+0x0/0xd2 @ 1
[    0.471288] pnp: PnP ACPI init
[    0.471497] ACPI: bus type PNP registered
[    0.472224] system 00:00: [io  0x0230-0x0233] has been reserved
[    0.472408] system 00:00: [io  0x0260-0x0267] has been reserved
[    0.472592] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.472776] system 00:00: [io  0x0800-0x081f] has been reserved
[    0.472960] system 00:00: [io  0x0900-0x0903] has been reserved
[    0.473144] system 00:00: [io  0x0904-0x0907] has been reserved
[    0.473329] system 00:00: [io  0x0908-0x090b] has been reserved
[    0.473511] system 00:00: [io  0x090c-0x092e] has been reserved
[    0.473695] system 00:00: [io  0x092f] has been reserved
[    0.473876] system 00:00: [io  0x0930-0x09ff] has been reserved
[    0.474060] system 00:00: [io  0x0c80-0x0c87] has been reserved
[    0.474245] system 00:00: [io  0x0cf9] could not be reserved
[    0.474426] system 00:00: [io  0x02f8-0x02ff] has been reserved
[    0.474616] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.474822] pnp 00:01: [dma 7]
[    0.475027] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.475247] pnp 00:02: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.475508] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.475739] pnp 00:04: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.476047] pnp 00:05: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.476513] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.476996] pnp 00:07: [dma 2]
[    0.477216] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.477651] pnp: PnP ACPI: found 8 devices
[    0.477826] ACPI: bus type PNP unregistered
[    0.478003] initcall pnpacpi_init+0x0/0xd2 returned 0 after 7812 usecs
[    0.478190] calling  chr_dev_init+0x0/0x122 @ 1
[    0.480080] initcall chr_dev_init+0x0/0x122 returned 0 after 3906 usecs
[    0.480269] calling  firmware_class_init+0x0/0x11f @ 1
[    0.480462] initcall firmware_class_init+0x0/0x11f returned 0 after 0 usecs
[    0.480650] calling  thermal_init+0x0/0xf7 @ 1
[    0.480853] initcall thermal_init+0x0/0xf7 returned 0 after 0 usecs
[    0.484015] calling  cpufreq_gov_performance_init+0x0/0x1d @ 1
[    0.484200] initcall cpufreq_gov_performance_init+0x0/0x1d returned 0 after 0 usecs
[    0.484487] calling  cpufreq_gov_dbs_init+0x0/0x1d @ 1
[    0.484667] initcall cpufreq_gov_dbs_init+0x0/0x1d returned 0 after 0 usecs
[    0.486663] calling  init_acpi_pm_clocksource+0x0/0x151 @ 1
[    0.491459] Switched to clocksource acpi_pm
[    0.491459] initcall init_acpi_pm_clocksource+0x0/0x151 returned 0 after 4155 usecs
[    0.491459] calling  pcibios_assign_resources+0x0/0xfe @ 1
[    0.491459] pci 0000:00:03.0: BAR 15: assigned [mem 0xc0000000-0xc00fffff pref]
[    0.491459] pci 0000:01:03.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
[    0.491459] pci 0000:01:02.2: BAR 6: assigned [mem 0xc0020000-0xc002ffff pref]
[    0.491459] pci 0000:00:03.0: PCI bridge to [bus 01]
[    0.491459] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
[    0.491459] pci 0000:00:03.0:   bridge window [mem 0xf5f00000-0xf7efffff]
[    0.491459] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xc00fffff pref]
[    0.491459] pci 0000:02:04.0: BAR 6: assigned [mem 0xf5e00000-0xf5e03fff pref]
[    0.491459] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.491459] pci 0000:00:07.0:   bridge window [io  0x5000-0x5fff]
[    0.491459] pci 0000:00:07.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.491459] pci 0000:00:07.0:   bridge window [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.491660] pci 0000:00:08.0: PCI bridge to [bus 03]
[    0.491846] pci_bus 0000:00: resource 4 [io  0x0000-0x5fff]
[    0.492042] pci_bus 0000:00: resource 5 [mem 0xc0000000-0xf7ffffff]
[    0.492224] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.492405] pci_bus 0000:00: resource 7 [mem 0xfe000000-0xffffffff]
[    0.492589] pci_bus 0000:00: resource 8 [mem 0x400000000-0xfcffffffff]
[    0.492772] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    0.492951] pci_bus 0000:01: resource 1 [mem 0xf5f00000-0xf7efffff]
[    0.493133] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xc00fffff pref]
[    0.493317] pci_bus 0000:02: resource 0 [io  0x5000-0x5fff]
[    0.493496] pci_bus 0000:02: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    0.493677] pci_bus 0000:02: resource 2 [mem 0xf5e00000-0xf5efffff 64bit pref]
[    0.493985] pci 0000:04:09.0: PCI bridge to [bus 05]
[    0.494169] pci 0000:04:0a.0: PCI bridge to [bus 06]
[    0.494351] pci 0000:04:0b.0: PCI bridge to [bus 07]
[    0.494534] pci 0000:04:0c.0: PCI bridge to [bus 08]
[    0.494716] pci_bus 0000:04: resource 4 [io  0x6000-0xffff]
[    0.494895] pci_bus 0000:04: resource 5 [mem 0xf8000000-0xfdffffff]
[    0.495080] initcall pcibios_assign_resources+0x0/0xfe returned 0 after 6140 usecs
[    0.495364] calling  sysctl_core_init+0x0/0x3e @ 1
[    0.495571] initcall sysctl_core_init+0x0/0x3e returned 0 after 28 usecs
[    0.495754] calling  inet_init+0x0/0x4fb @ 1
[    0.496038] NET: Registered protocol family 2
[    0.496673] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.498004] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.499020] TCP: Hash tables configured (established 131072 bind 65536)
[    0.499340] TCP: reno registered
[    0.499565] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.500092] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.500694] initcall inet_init+0x0/0x4fb returned 0 after 4642 usecs
[    0.500879] calling  ipv4_offload_init+0x0/0x9d @ 1
[    0.501059] initcall ipv4_offload_init+0x0/0x9d returned 0 after 3 usecs
[    0.501243] calling  af_unix_init+0x0/0x75 @ 1
[    0.501419] NET: Registered protocol family 1
[    0.501602] initcall af_unix_init+0x0/0x75 returned 0 after 180 usecs
[    0.501787] calling  ipv6_offload_init+0x0/0xd0 @ 1
[    0.501969] initcall ipv6_offload_init+0x0/0xd0 returned 0 after 3 usecs
[    0.502154] calling  pci_apply_final_quirks+0x0/0x184 @ 1
[    0.502367] pci 0000:00:04.3: boot interrupts on device [1022:746b] already disabled
[    0.502656] pci 0000:00:07.0: MSI quirk detected; subordinate MSI disabled
[    0.502849] pci 0000:00:07.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.503041] pci 0000:00:08.0: MSI quirk detected; subordinate MSI disabled
[    0.503232] pci 0000:00:08.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.644092] pci 0000:01:03.0: Boot video device
[    0.644283] pci 0000:04:09.0: MSI quirk detected; subordinate MSI disabled
[    0.644472] pci 0000:04:09.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.644665] pci 0000:04:0a.0: MSI quirk detected; subordinate MSI disabled
[    0.644854] pci 0000:04:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.645047] pci 0000:04:0b.0: MSI quirk detected; subordinate MSI disabled
[    0.645237] pci 0000:04:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.645431] pci 0000:04:0c.0: MSI quirk detected; subordinate MSI disabled
[    0.645622] pci 0000:04:0c.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
[    0.645813] PCI: CLS 64 bytes, default 64
[    0.645988] initcall pci_apply_final_quirks+0x0/0x184 returned 0 after 140285 usecs
[    0.646273] calling  default_rootfs+0x0/0x99 @ 1
[    0.646517] initcall default_rootfs+0x0/0x99 returned 0 after 64 usecs
[    0.646704] calling  pci_iommu_init+0x0/0x68 @ 1
[    0.649145] PCI-DMA: Disabling AGP.
[    0.649606] PCI-DMA: aperture base @ b4000000 size 65536 KB
[    0.649785] PCI-DMA: using GART IOMMU.
[    0.649962] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.657992] initcall pci_iommu_init+0x0/0x68 returned 0 after 10825 usecs
[    0.658198] calling  ir_dev_scope_init+0x0/0x2a @ 1
[    0.658376] initcall ir_dev_scope_init+0x0/0x2a returned 0 after 1 usecs
[    0.658583] calling  i8259A_init_ops+0x0/0x36 @ 1
[    0.658763] initcall i8259A_init_ops+0x0/0x36 returned 0 after 3 usecs
[    0.658946] calling  vsyscall_init+0x0/0x39 @ 1
[    0.659155] initcall vsyscall_init+0x0/0x39 returned 0 after 32 usecs
[    0.659342] calling  sbf_init+0x0/0x199 @ 1
[    0.659519] initcall sbf_init+0x0/0x199 returned 0 after 1 usecs
[    0.659701] calling  init_tsc_clocksource+0x0/0x126 @ 1
[    0.659909] initcall init_tsc_clocksource+0x0/0x126 returned 0 after 27 usecs
[    0.660131] calling  add_rtc_cmos+0x0/0x100 @ 1
[    0.660437] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.660789] initcall add_rtc_cmos+0x0/0x100 returned 0 after 444 usecs
[    0.661015] calling  i8237A_init_ops+0x0/0x1f @ 1
[    0.661225] initcall i8237A_init_ops+0x0/0x1f returned 0 after 1 usecs
[    0.661432] calling  cache_sysfs_init+0x0/0xa3 @ 1
[    0.661831] initcall cache_sysfs_init+0x0/0xa3 returned 0 after 183 usecs
[    0.662054] calling  amd_uncore_init+0x0/0x1c1 @ 1
[    0.662266] initcall amd_uncore_init+0x0/0x1c1 returned -19 after 1 usecs
[    0.662491] calling  amd_iommu_pc_init+0x0/0x203 @ 1
[    0.662711] initcall amd_iommu_pc_init+0x0/0x203 returned -19 after 2 usecs
[    0.662936] calling  intel_uncore_init+0x0/0x50b @ 1
[    0.663154] initcall intel_uncore_init+0x0/0x50b returned -19 after 1 usecs
[    0.663374] calling  amd_ibs_init+0x0/0x36a @ 1
[    0.663592] initcall amd_ibs_init+0x0/0x36a returned -19 after 1 usecs
[    0.663816] calling  ioapic_init_ops+0x0/0x1f @ 1
[    0.664063] initcall ioapic_init_ops+0x0/0x1f returned 0 after 1 usecs
[    0.664292] calling  add_pcspkr+0x0/0x71 @ 1
[    0.664528] initcall add_pcspkr+0x0/0x71 returned 0 after 24 usecs
[    0.664749] calling  sysfb_init+0x0/0xe7 @ 1
[    0.664979] initcall sysfb_init+0x0/0xe7 returned 0 after 16 usecs
[    0.665202] calling  ia32_binfmt_init+0x0/0x11 @ 1
[    0.665424] initcall ia32_binfmt_init+0x0/0x11 returned 0 after 14 usecs
[    0.665649] calling  init_aout_binfmt+0x0/0x2f @ 1
[    0.665865] initcall init_aout_binfmt+0x0/0x2f returned 0 after 2 usecs
[    0.666089] calling  proc_execdomains_init+0x0/0x3b @ 1
[    0.666307] initcall proc_execdomains_init+0x0/0x3b returned 0 after 12 usecs
[    0.666535] calling  ioresources_init+0x0/0x6a @ 1
[    0.666744] initcall ioresources_init+0x0/0x6a returned 0 after 4 usecs
[    0.666967] calling  uid_cache_init+0x0/0xd9 @ 1
[    0.667186] initcall uid_cache_init+0x0/0xd9 returned 0 after 14 usecs
[    0.667410] calling  init_posix_timers+0x0/0x275 @ 1
[    0.667664] initcall init_posix_timers+0x0/0x275 returned 0 after 45 usecs
[    0.667881] calling  init_posix_cpu_timers+0x0/0xa8 @ 1
[    0.668124] initcall init_posix_cpu_timers+0x0/0xa8 returned 0 after 2 usecs
[    0.668356] calling  proc_schedstat_init+0x0/0x3b @ 1
[    0.668570] initcall proc_schedstat_init+0x0/0x3b returned 0 after 3 usecs
[    0.668794] calling  init_sched_debug_procfs+0x0/0x51 @ 1
[    0.669011] initcall init_sched_debug_procfs+0x0/0x51 returned 0 after 2 usecs
[    0.669358] calling  snapshot_device_init+0x0/0x1d @ 1
[    0.669727] initcall snapshot_device_init+0x0/0x1d returned 0 after 147 usecs
[    0.669958] calling  irq_pm_init_ops+0x0/0x1f @ 1
[    0.670171] initcall irq_pm_init_ops+0x0/0x1f returned 0 after 2 usecs
[    0.670391] calling  create_proc_profile+0x0/0x3b0 @ 1
[    0.670611] initcall create_proc_profile+0x0/0x3b0 returned 0 after 1 usecs
[    0.670837] calling  timekeeping_init_ops+0x0/0x1f @ 1
[    0.671059] initcall timekeeping_init_ops+0x0/0x1f returned 0 after 1 usecs
[    0.671277] calling  init_clocksource_sysfs+0x0/0xae @ 1
[    0.671531] initcall init_clocksource_sysfs+0x0/0xae returned 0 after 48 usecs
[    0.671865] calling  init_timer_list_procfs+0x0/0x51 @ 1
[    0.672120] initcall init_timer_list_procfs+0x0/0x51 returned 0 after 4 usecs
[    0.672343] calling  alarmtimer_init+0x0/0x1f6 @ 1
[    0.672612] initcall alarmtimer_init+0x0/0x1f6 returned 0 after 52 usecs
[    0.672836] calling  clockevents_init_sysfs+0x0/0x161 @ 1
[    0.673211] initcall clockevents_init_sysfs+0x0/0x161 returned 0 after 160 usecs
[    0.673544] calling  init_tstats_procfs+0x0/0x51 @ 1
[    0.673765] initcall init_tstats_procfs+0x0/0x51 returned 0 after 4 usecs
[    0.673983] calling  futex_init+0x0/0x89 @ 1
[    0.674210] initcall futex_init+0x0/0x89 returned 0 after 14 usecs
[    0.674431] calling  proc_dma_init+0x0/0x3b @ 1
[    0.674652] initcall proc_dma_init+0x0/0x3b returned 0 after 2 usecs
[    0.674877] calling  proc_modules_init+0x0/0x3b @ 1
[    0.675091] initcall proc_modules_init+0x0/0x3b returned 0 after 3 usecs
[    0.675310] calling  kallsyms_init+0x0/0x40 @ 1
[    0.675524] initcall kallsyms_init+0x0/0x40 returned 0 after 3 usecs
[    0.675749] calling  user_namespaces_init+0x0/0x38 @ 1
[    0.675979] initcall user_namespaces_init+0x0/0x38 returned 0 after 12 usecs
[    0.676230] calling  pid_namespaces_init+0x0/0x38 @ 1
[    0.676442] initcall pid_namespaces_init+0x0/0x38 returned 0 after 11 usecs
[    0.676656] calling  gcov_init+0x0/0x1d @ 1
[    0.676869] initcall gcov_init+0x0/0x1d returned 0 after 2 usecs
[    0.677084] calling  gcov_fs_init+0x0/0x13f @ 1
[    0.693718] gcov: could not create file
[    0.741798] initcall gcov_fs_init+0x0/0x13f returned 0 after 62987 usecs
[    0.741995] calling  init_kprobes+0x0/0x1f5 @ 1
[    0.758444] initcall init_kprobes+0x0/0x1f5 returned 0 after 15889 usecs
[    0.760801] calling  hung_task_init+0x0/0x6f @ 1
[    0.761149] initcall hung_task_init+0x0/0x6f returned 0 after 131 usecs
[    0.761362] calling  utsname_sysctl_init+0x0/0x1f @ 1
[    0.761600] initcall utsname_sysctl_init+0x0/0x1f returned 0 after 21 usecs
[    0.761824] calling  irq_work_init_cpu_notifier+0x0/0x34 @ 1
[    0.762049] initcall irq_work_init_cpu_notifier+0x0/0x34 returned 0 after 6 usecs
[    0.762385] calling  perf_event_sysfs_init+0x0/0xe0 @ 1
[    0.762732] initcall perf_event_sysfs_init+0x0/0xe0 returned 0 after 129 usecs
[    0.763073] calling  init_per_zone_wmark_min+0x0/0x131 @ 1
[    0.764762] initcall init_per_zone_wmark_min+0x0/0x131 returned 0 after 1433 usecs
[    0.765115] calling  kswapd_init+0x0/0xb8 @ 1
[    0.765755] initcall kswapd_init+0x0/0xb8 returned 0 after 422 usecs
[    0.765952] calling  extfrag_debug_init+0x0/0xb1 @ 1
[    0.766160] initcall extfrag_debug_init+0x0/0xb1 returned 0 after 27 usecs
[    0.766373] calling  setup_vmstat+0x0/0x12c @ 1
[    0.766623] initcall setup_vmstat+0x0/0x12c returned 0 after 37 usecs
[    0.766854] calling  mm_sysfs_init+0x0/0x40 @ 1
[    0.767064] initcall mm_sysfs_init+0x0/0x40 returned 0 after 5 usecs
[    0.767287] calling  mm_compute_batch_init+0x0/0xb5 @ 1
[    0.767506] initcall mm_compute_batch_init+0x0/0xb5 returned 0 after 1 usecs
[    0.767734] calling  slab_proc_init+0x0/0x3e @ 1
[    0.767951] initcall slab_proc_init+0x0/0x3e returned 0 after 3 usecs
[    0.768192] calling  init_reserve_notifier+0x0/0xa @ 1
[    0.768400] initcall init_reserve_notifier+0x0/0xa returned 0 after 1 usecs
[    0.768629] calling  init_admin_reserve+0x0/0x50 @ 1
[    0.768847] initcall init_admin_reserve+0x0/0x50 returned 0 after 1 usecs
[    0.769071] calling  init_user_reserve+0x0/0x50 @ 1
[    0.769288] initcall init_user_reserve+0x0/0x50 returned 0 after 1 usecs
[    0.769509] calling  proc_vmalloc_init+0x0/0x3e @ 1
[    0.769726] initcall proc_vmalloc_init+0x0/0x3e returned 0 after 3 usecs
[    0.769949] calling  procswaps_init+0x0/0x3b @ 1
[    0.770164] initcall procswaps_init+0x0/0x3b returned 0 after 3 usecs
[    0.770382] calling  hugetlb_init+0x0/0x757 @ 1
[    0.770602] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.770862] initcall hugetlb_init+0x0/0x757 returned 0 after 257 usecs
[    0.771078] calling  mmu_notifier_init+0x0/0x1d @ 1
[    0.771300] initcall mmu_notifier_init+0x0/0x1d returned 0 after 5 usecs
[    0.771523] calling  ksm_init+0x0/0x20d @ 1
[    0.771854] initcall ksm_init+0x0/0x20d returned 0 after 129 usecs
[    0.772093] calling  slab_sysfs_init+0x0/0x163 @ 1
[    0.774042] initcall slab_sysfs_init+0x0/0x163 returned 0 after 1698 usecs
[    0.774269] calling  hugepage_init+0x0/0x1e5 @ 1
[    0.775908] initcall hugepage_init+0x0/0x1e5 returned 0 after 1404 usecs
[    0.776154] calling  fcntl_init+0x0/0x35 @ 1
[    0.776362] initcall fcntl_init+0x0/0x35 returned 0 after 5 usecs
[    0.776584] calling  proc_filesystems_init+0x0/0x3b @ 1
[    0.776809] initcall proc_filesystems_init+0x0/0x3b returned 0 after 5 usecs
[    0.777038] calling  dio_init+0x0/0x38 @ 1
[    0.777251] initcall dio_init+0x0/0x38 returned 0 after 3 usecs
[    0.777468] calling  fsnotify_mark_init+0x0/0x60 @ 1
[    0.777784] initcall fsnotify_mark_init+0x0/0x60 returned 0 after 97 usecs
[    0.778018] calling  dnotify_init+0x0/0x9b @ 1
[    0.778314] initcall dnotify_init+0x0/0x9b returned 0 after 79 usecs
[    0.778540] calling  inotify_user_setup+0x0/0x82 @ 1
[    0.778763] initcall inotify_user_setup+0x0/0x82 returned 0 after 6 usecs
[    0.778987] calling  fanotify_user_setup+0x0/0x64 @ 1
[    0.779209] initcall fanotify_user_setup+0x0/0x64 returned 0 after 5 usecs
[    0.779435] calling  aio_setup+0x0/0x9d @ 1
[    0.779682] initcall aio_setup+0x0/0x9d returned 0 after 33 usecs
[    0.779895] calling  proc_locks_init+0x0/0x3d @ 1
[    0.780137] initcall proc_locks_init+0x0/0x3d returned 0 after 8 usecs
[    0.780358] calling  init_sys32_ioctl+0x0/0x33 @ 1
[    0.780668] initcall init_sys32_ioctl+0x0/0x33 returned 0 after 100 usecs
[    0.780895] calling  init_mbcache+0x0/0x1f @ 1
[    0.781112] initcall init_mbcache+0x0/0x1f returned 0 after 1 usecs
[    0.781333] calling  proc_cmdline_init+0x0/0x3b @ 1
[    0.781546] initcall proc_cmdline_init+0x0/0x3b returned 0 after 2 usecs
[    0.781773] calling  proc_consoles_init+0x0/0x3b @ 1
[    0.781984] initcall proc_consoles_init+0x0/0x3b returned 0 after 2 usecs
[    0.782205] calling  proc_cpuinfo_init+0x0/0x3b @ 1
[    0.782417] initcall proc_cpuinfo_init+0x0/0x3b returned 0 after 2 usecs
[    0.782642] calling  proc_devices_init+0x0/0x3b @ 1
[    0.782863] initcall proc_devices_init+0x0/0x3b returned 0 after 2 usecs
[    0.783081] calling  proc_interrupts_init+0x0/0x3b @ 1
[    0.783301] initcall proc_interrupts_init+0x0/0x3b returned 0 after 2 usecs
[    0.783530] calling  proc_loadavg_init+0x0/0x3c @ 1
[    0.783751] initcall proc_loadavg_init+0x0/0x3c returned 0 after 2 usecs
[    0.783977] calling  proc_meminfo_init+0x0/0x3b @ 1
[    0.784200] initcall proc_meminfo_init+0x0/0x3b returned 0 after 3 usecs
[    0.784425] calling  proc_stat_init+0x0/0x3b @ 1
[    0.784639] initcall proc_stat_init+0x0/0x3b returned 0 after 3 usecs
[    0.784854] calling  proc_uptime_init+0x0/0x3b @ 1
[    0.785070] initcall proc_uptime_init+0x0/0x3b returned 0 after 2 usecs
[    0.785297] calling  proc_version_init+0x0/0x3b @ 1
[    0.785516] initcall proc_version_init+0x0/0x3b returned 0 after 2 usecs
[    0.785739] calling  proc_softirqs_init+0x0/0x3b @ 1
[    0.785943] initcall proc_softirqs_init+0x0/0x3b returned 0 after 3 usecs
[    0.786166] calling  proc_kcore_init+0x0/0x10b @ 1
[    0.786384] initcall proc_kcore_init+0x0/0x10b returned 0 after 13 usecs
[    0.786607] calling  proc_kmsg_init+0x0/0x3e @ 1
[    0.786812] initcall proc_kmsg_init+0x0/0x3e returned 0 after 3 usecs
[    0.787035] calling  proc_page_init+0x0/0x70 @ 1
[    0.787255] initcall proc_page_init+0x0/0x70 returned 0 after 4 usecs
[    0.787466] calling  init_devpts_fs+0x0/0x95 @ 1
[    0.787723] initcall init_devpts_fs+0x0/0x95 returned 0 after 40 usecs
[    0.787938] calling  ext4_init_fs+0x0/0x3cf @ 1
[    0.788439] initcall ext4_init_fs+0x0/0x3cf returned 0 after 269 usecs
[    0.788665] calling  journal_init+0x0/0x1e7 @ 1
[    0.789097] initcall journal_init+0x0/0x1e7 returned 0 after 210 usecs
[    0.789313] calling  init_ramfs_fs+0x0/0x93 @ 1
[    0.789528] initcall init_ramfs_fs+0x0/0x93 returned 0 after 1 usecs
[    0.789755] calling  init_hugetlbfs_fs+0x0/0x1ed @ 1
[    0.790081] initcall init_hugetlbfs_fs+0x0/0x1ed returned 0 after 104 usecs
[    0.790307] calling  ipc_init+0x0/0x43 @ 1
[    0.790517] msgmni has been set to 30074
[    0.790731] initcall ipc_init+0x0/0x43 returned 0 after 213 usecs
[    0.790952] calling  ipc_sysctl_init+0x0/0x1f @ 1
[    0.791181] initcall ipc_sysctl_init+0x0/0x1f returned 0 after 12 usecs
[    0.791409] calling  init_mqueue_fs+0x0/0xf3 @ 1
[    0.791720] initcall init_mqueue_fs+0x0/0xf3 returned 0 after 90 usecs
[    0.791948] calling  key_proc_init+0x0/0x53 @ 1
[    0.792180] initcall key_proc_init+0x0/0x53 returned 0 after 4 usecs
[    0.792397] calling  crypto_wq_init+0x0/0x4a @ 1
[    0.792783] initcall crypto_wq_init+0x0/0x4a returned 0 after 162 usecs
[    0.793015] calling  crypto_algapi_init+0x0/0x18 @ 1
[    0.793237] initcall crypto_algapi_init+0x0/0x18 returned 0 after 4 usecs
[    0.793454] calling  chainiv_module_init+0x0/0x1e @ 1
[    0.793674] initcall chainiv_module_init+0x0/0x1e returned 0 after 3 usecs
[    0.793901] calling  eseqiv_module_init+0x0/0x1d @ 1
[    0.794119] initcall eseqiv_module_init+0x0/0x1d returned 0 after 1 usecs
[    0.794338] calling  md5_mod_init+0x0/0x1d @ 1
[    0.794700] cryptomgr_test (65) used greatest stack depth: 6840 bytes left
[    0.794711] initcall md5_mod_init+0x0/0x1d returned 0 after 152 usecs
[    0.794714] calling  aes_init+0x0/0x1d @ 1
[    0.795482] initcall aes_init+0x0/0x1d returned 0 after 745 usecs
[    0.795713] calling  crc32c_mod_init+0x0/0x1d @ 1
[    0.796095] initcall crc32c_mod_init+0x0/0x1d returned 0 after 162 usecs
[    0.796324] calling  krng_mod_init+0x0/0x1d @ 1
[    0.796693] initcall krng_mod_init+0x0/0x1d returned 0 after 148 usecs
[    0.796921] calling  proc_genhd_init+0x0/0x6c @ 1
[    0.797153] initcall proc_genhd_init+0x0/0x6c returned 0 after 14 usecs
[    0.797358] calling  bsg_init+0x0/0x1ab @ 1
[    0.797626] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.797970] initcall bsg_init+0x0/0x1ab returned 0 after 391 usecs
[    0.798194] calling  noop_init+0x0/0x1d @ 1
[    0.798393] io scheduler noop registered
[    0.798602] initcall noop_init+0x0/0x1d returned 0 after 204 usecs
[    0.798823] calling  deadline_init+0x0/0x1d @ 1
[    0.799038] io scheduler deadline registered
[    0.799249] initcall deadline_init+0x0/0x1d returned 0 after 205 usecs
[    0.799461] calling  cfq_init+0x0/0x110 @ 1
[    0.799739] io scheduler cfq registered (default)
[    0.799942] initcall cfq_init+0x0/0x110 returned 0 after 260 usecs
[    0.800202] calling  percpu_counter_startup+0x0/0x2b @ 1
[    0.800418] initcall percpu_counter_startup+0x0/0x2b returned 0 after 6 usecs
[    0.800645] calling  pci_proc_init+0x0/0x98 @ 1
[    0.800969] initcall pci_proc_init+0x0/0x98 returned 0 after 110 usecs
[    0.801190] calling  pci_hotplug_init+0x0/0x68 @ 1
[    0.801390] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.801575] initcall pci_hotplug_init+0x0/0x68 returned 0 after 179 usecs
[    0.801760] calling  acpi_reserve_resources+0x0/0x13f @ 1
[    0.801949] initcall acpi_reserve_resources+0x0/0x13f returned 0 after 10 usecs
[    0.802229] calling  acpi_button_driver_init+0x0/0x1d @ 1
[    0.802553] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.802844] ACPI: Power Button [PWRF]
[    0.803055] initcall acpi_button_driver_init+0x0/0x1d returned 0 after 629 usecs
[    0.803336] calling  acpi_processor_driver_init+0x0/0x7f @ 1
[    0.803545] ACPI: processor limited to max C-state 1
[    0.803849] initcall acpi_processor_driver_init+0x0/0x7f returned 0 after 323 usecs
[    0.804157] calling  acpi_pad_init+0x0/0x167 @ 1
[    0.804335] initcall acpi_pad_init+0x0/0x167 returned -22 after 1 usecs
[    0.804519] calling  pty_init+0x0/0x2a5 @ 1
[    0.804786] initcall pty_init+0x0/0x2a5 returned 0 after 89 usecs
[    0.804969] calling  sysrq_init+0x0/0x14e @ 1
[    0.805150] initcall sysrq_init+0x0/0x14e returned 0 after 6 usecs
[    0.805331] calling  serial8250_init+0x0/0x26b @ 1
[    0.805509] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.826241] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.872640] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    0.873240] initcall serial8250_init+0x0/0x26b returned 0 after 66142 usecs
[    0.875636] calling  serial_pci_driver_init+0x0/0x26 @ 1
[    0.875975] initcall serial_pci_driver_init+0x0/0x26 returned 0 after 114 usecs
[    0.876356] calling  hpet_init+0x0/0xa1 @ 1
[    0.876663] initcall hpet_init+0x0/0xa1 returned 0 after 82 usecs
[    0.876885] calling  agp_init+0x0/0x3b @ 1
[    0.877096] Linux agpgart interface v0.103
[    0.877306] initcall agp_init+0x0/0x3b returned 0 after 204 usecs
[    0.877528] calling  agp_amd64_mod_init+0x0/0x40 @ 1
[    0.877746] initcall agp_amd64_mod_init+0x0/0x40 returned -19 after 1 usecs
[    0.877970] calling  topology_sysfs_init+0x0/0xa0 @ 1
[    0.878212] initcall topology_sysfs_init+0x0/0xa0 returned 0 after 25 usecs
[    0.878442] calling  cciss_init+0x0/0xf5 @ 1
[    0.878653] HP CISS Driver (v 3.6.26)
[    0.879250] cciss 0000:02:04.0: Controller reports max supported commands of 0, an obvious lie. Using 16.  Ensure that firmware is up to date.
[    0.999857] cciss 0000:02:04.0: cciss0: <0xb178> at PCI 0000:02:04.0 IRQ 18 using DAC
[    1.002977]  cciss/c0d0: p1 p2 < p5 >
[    1.003728] scsi0 : cciss
[    1.004097] initcall cciss_init+0x0/0xf5 returned 0 after 122500 usecs
[    1.004137] calling  1_do_scan_async+0x0/0x260 @ 7
[    1.004474] calling  init_sd+0x0/0x220 @ 1
[    1.004712] initcall 1_do_scan_async+0x0/0x260 returned 0 after 549 usecs
[    1.004718] initcall init_sd+0x0/0x220 returned 0 after 57 usecs
[    1.004722] calling  net_olddevs_init+0x0/0x92 @ 1
[    1.004736] initcall net_olddevs_init+0x0/0x92 returned 0 after 9 usecs
[    1.004738] calling  i8042_init+0x0/0x5b5 @ 1
[    1.004786] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    1.006736] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.006915] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.007113] initcall i8042_init+0x0/0x5b5 returned 0 after 2312 usecs
[    1.007293] calling  mousedev_init+0x0/0xd9 @ 1
[    1.007677] mousedev: PS/2 mouse device common for all mice
[    1.007856] initcall mousedev_init+0x0/0xd9 returned 0 after 381 usecs
[    1.008070] calling  atkbd_init+0x0/0x39 @ 1
[    1.008274] initcall atkbd_init+0x0/0x39 returned 0 after 24 usecs
[    1.008453] calling  cmos_init+0x0/0xaa @ 1
[    1.008687] rtc_cmos rtc_cmos: RTC can wake from S4
[    1.009071] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    1.009319] rtc_cmos rtc_cmos: alarms up to one year, y3k, 114 bytes nvram
[    1.009511] initcall cmos_init+0x0/0xaa returned 0 after 867 usecs
[    1.009690] calling  sock_diag_init+0x0/0x1d @ 1
[    1.009876] initcall sock_diag_init+0x0/0x1d returned 0 after 13 usecs
[    1.010054] calling  flow_cache_init_global+0x0/0x1ef @ 1
[    1.010354] initcall flow_cache_init_global+0x0/0x1ef returned 0 after 120 usecs
[    1.010629] calling  blackhole_module_init+0x0/0x1d @ 1
[    1.010807] initcall blackhole_module_init+0x0/0x1d returned 0 after 3 usecs
[    1.010988] calling  init_cgroup_cls+0x0/0x67 @ 1
[    1.011163] initcall init_cgroup_cls+0x0/0x67 returned 0 after 2 usecs
[    1.011355] calling  sysctl_ipv4_init+0x0/0xc5 @ 1
[    1.011582] initcall sysctl_ipv4_init+0x0/0xc5 returned 0 after 52 usecs
[    1.011762] calling  ipv4_netfilter_init+0x0/0x1d @ 1
[    1.011937] initcall ipv4_netfilter_init+0x0/0x1d returned 0 after 1 usecs
[    1.012153] calling  cubictcp_register+0x0/0x7c @ 1
[    1.012331] TCP: cubic registered
[    1.012500] initcall cubictcp_register+0x0/0x7c returned 0 after 165 usecs
[    1.012682] calling  tcp_memcontrol_init+0x0/0x49 @ 1
[    1.012859] initcall tcp_memcontrol_init+0x0/0x49 returned 0 after 3 usecs
[    1.013039] calling  inet6_init+0x0/0x659 @ 1
[    1.013409] NET: Registered protocol family 10
[    1.013893] initcall inet6_init+0x0/0x659 returned 0 after 666 usecs
[    1.014073] calling  packet_init+0x0/0x67 @ 1
[    1.014243] NET: Registered protocol family 17
[    1.014417] initcall packet_init+0x0/0x67 returned 0 after 169 usecs
[    1.014595] calling  init_dns_resolver+0x0/0x136 @ 1
[    1.014778] Key type dns_resolver registered
[    1.014949] initcall init_dns_resolver+0x0/0x136 returned 0 after 176 usecs
[    1.015131] calling  mcheck_init_device+0x0/0x1bf @ 1
[    1.015526] initcall mcheck_init_device+0x0/0x1bf returned 0 after 215 usecs
[    1.015729] calling  mcheck_debugfs_init+0x0/0x5d @ 1
[    1.015924] initcall mcheck_debugfs_init+0x0/0x5d returned 0 after 21 usecs
[    1.016130] calling  severities_debugfs_init+0x0/0x62 @ 1
[    1.016320] initcall severities_debugfs_init+0x0/0x62 returned 0 after 14 usecs
[    1.016595] calling  threshold_init_device+0x0/0x78 @ 1
[    1.016773] initcall threshold_init_device+0x0/0x78 returned 0 after 3 usecs
[    1.016955] calling  hpet_insert_resource+0x0/0x38 @ 1
[    1.017132] initcall hpet_insert_resource+0x0/0x38 returned 1 after 1 usecs
[    1.017313] calling  update_mp_table+0x0/0x6a1 @ 1
[    1.017488] initcall update_mp_table+0x0/0x6a1 returned 0 after 1 usecs
[    1.017668] calling  lapic_insert_resource+0x0/0x53 @ 1
[    1.017847] initcall lapic_insert_resource+0x0/0x53 returned 0 after 4 usecs
[    1.018029] calling  io_apic_bug_finalize+0x0/0x24 @ 1
[    1.018204] initcall io_apic_bug_finalize+0x0/0x24 returned 0 after 1 usecs
[    1.018384] calling  print_ICs+0x0/0x6d2 @ 1
[    1.018556] initcall print_ICs+0x0/0x6d2 returned 0 after 1 usecs
[    1.018733] calling  check_early_ioremap_leak+0x0/0x8d @ 1
[    1.018910] initcall check_early_ioremap_leak+0x0/0x8d returned 0 after 1 usecs
[    1.019184] calling  pat_memtype_list_init+0x0/0x47 @ 1
[    1.019364] initcall pat_memtype_list_init+0x0/0x47 returned 0 after 4 usecs
[    1.019546] calling  init_oops_id+0x0/0x50 @ 1
[    1.019721] initcall init_oops_id+0x0/0x50 returned 0 after 3 usecs
[    1.019900] calling  sched_init_debug+0x0/0x31 @ 1
[    1.020100] initcall sched_init_debug+0x0/0x31 returned 0 after 4 usecs
[    1.020279] calling  pm_qos_power_init+0x0/0x8b @ 1
[    1.020678] initcall pm_qos_power_init+0x0/0x8b returned 0 after 218 usecs
[    1.020859] calling  pm_debugfs_init+0x0/0x2f @ 1
[    1.021038] initcall pm_debugfs_init+0x0/0x2f returned 0 after 6 usecs
[    1.021218] calling  printk_late_init+0x0/0x64 @ 1
[    1.021403] initcall printk_late_init+0x0/0x64 returned 0 after 2 usecs
[    1.021583] calling  tk_debug_sleep_time_init+0x0/0x55 @ 1
[    1.021763] initcall tk_debug_sleep_time_init+0x0/0x55 returned 0 after 4 usecs
[    1.022039] calling  debugfs_kprobe_init+0x0/0xe0 @ 1
[    1.022222] initcall debugfs_kprobe_init+0x0/0xe0 returned 0 after 7 usecs
[    1.022403] calling  taskstats_init+0x0/0x85 @ 1
[    1.022596] registered taskstats version 1
[    1.022766] initcall taskstats_init+0x0/0x85 returned 0 after 186 usecs
[    1.022946] calling  max_swapfiles_check+0x0/0xa @ 1
[    1.023122] initcall max_swapfiles_check+0x0/0xa returned 0 after 1 usecs
[    1.023305] calling  set_recommended_min_free_kbytes+0x0/0xe0 @ 1
[    1.024931] initcall set_recommended_min_free_kbytes+0x0/0xe0 returned 0 after 1412 usecs
[    1.025210] calling  init_root_keyring+0x0/0x16 @ 1
[    1.025409] initcall init_root_keyring+0x0/0x16 returned 0 after 24 usecs
[    1.025593] calling  prandom_reseed+0x0/0x75 @ 1
[    1.025789] initcall prandom_reseed+0x0/0x75 returned 0 after 23 usecs
[    1.025969] calling  pci_resource_alignment_sysfs_init+0x0/0x2f @ 1
[    1.026151] initcall pci_resource_alignment_sysfs_init+0x0/0x2f returned 0 after 3 usecs
[    1.026428] calling  pci_sysfs_init+0x0/0x78 @ 1
[    1.026986] initcall pci_sysfs_init+0x0/0x78 returned 0 after 376 usecs
[    1.027167] calling  deferred_probe_initcall+0x0/0xa0 @ 1
[    1.027536] initcall deferred_probe_initcall+0x0/0xa0 returned 0 after 187 usecs
[    1.027811] calling  rtc_hctosys+0x0/0x17d @ 1
[    1.028087] rtc_cmos rtc_cmos: setting system clock to 2014-01-22 15:37:51 UTC (1390405071)
[    1.028371] initcall rtc_hctosys+0x0/0x17d returned 0 after 378 usecs
[    1.028550] calling  firmware_memmap_init+0x0/0x43 @ 1
[    1.028777] initcall firmware_memmap_init+0x0/0x43 returned 0 after 51 usecs
[    1.028959] calling  pci_mmcfg_late_insert_resources+0x0/0x69 @ 1
[    1.029139] initcall pci_mmcfg_late_insert_resources+0x0/0x69 returned 0 after 1 usecs
[    1.029414] calling  tcp_congestion_default+0x0/0x1d @ 1
[    1.029591] initcall tcp_congestion_default+0x0/0x1d returned 0 after 2 usecs
[    1.029773] calling  software_resume+0x0/0x400 @ 1
[    1.029947] initcall software_resume+0x0/0x400 returned -2 after 1 usecs
[    1.059989] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.067489] async_waiting @ 1
[    1.067658] async_continuing @ 1 after 1 usec
[    1.068402] EXT4-fs (cciss!c0d0p1): couldn't mount as ext3 due to feature incompatibilities
[    1.069091] EXT4-fs (cciss!c0d0p1): couldn't mount as ext2 due to feature incompatibilities
[    1.083041] EXT4-fs (cciss!c0d0p1): mounted filesystem with ordered data mode. Opts: (null)
[    1.083338] VFS: Mounted root (ext4 filesystem) readonly on device 104:1.
[    1.099070] devtmpfs: mounted
[    1.099245] async_waiting @ 1
[    1.099411] async_continuing @ 1 after 1 usec
[    1.101272] Freeing unused kernel memory: 872K (ffffffff81ce0000 - ffffffff81dba000)
[    1.101551] Write protecting the kernel read-only data: 10240k
[    1.109064] Freeing unused kernel memory: 1912K (ffff880001622000 - ffff880001800000)
[    1.112288] Freeing unused kernel memory: 772K (ffff88000193f000 - ffff880001a00000)
[    1.538484] modprobe (78) used greatest stack depth: 5264 bytes left
[    1.629710] stty (82) used greatest stack depth: 4648 bytes left
[    2.028489] mountpoint (131) used greatest stack depth: 4640 bytes left
[    2.277946] udevd[196]: starting version 175
[    2.494424] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 261
[    2.494706] initcall acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] returned -19 after 72 usecs
[    2.513747] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 255
[    2.514115] initcall acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] returned -19 after 103 usecs
[    2.547566] calling  shpcd_init+0x0/0x1000 [shpchp] @ 273
[    2.549728] shpchp 0000:00:07.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.550013] shpchp 0000:00:07.0: Cannot reserve MMIO region
[    2.550204] shpchp 0000:00:08.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.550500] shpchp 0000:00:08.0: Cannot reserve MMIO region
[    2.550844] shpchp 0000:04:09.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.551195] shpchp 0000:04:09.0: Cannot reserve MMIO region
[    2.554702] shpchp 0000:04:0a.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.555005] shpchp 0000:04:0a.0: Cannot reserve MMIO region
[    2.555202] shpchp 0000:04:0b.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.555492] shpchp 0000:04:0b.0: Cannot reserve MMIO region
[    2.555697] shpchp 0000:04:0c.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
[    2.555987] shpchp 0000:04:0c.0: Cannot reserve MMIO region
[    2.556393] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.556602] initcall shpcd_init+0x0/0x1000 [shpchp] returned 0 after 6775 usecs
[    2.558520] calling  evdev_init+0x0/0x1000 [evdev] @ 270
[    2.561274] initcall evdev_init+0x0/0x1000 [evdev] returned 0 after 2453 usecs
[    2.581726] calling  ata_init+0x0/0x4dc [libata] @ 275
[    2.587599] calling  mod_init+0x0/0x1000 [amd_rng] @ 277
[    2.587843] AMD768 RNG detected
[    2.588288] initcall mod_init+0x0/0x1000 [amd_rng] returned 0 after 463 usecs
[    2.593908] libata version 3.00 loaded.
[    2.594160] initcall ata_init+0x0/0x4dc [libata] returned 0 after 11893 usecs
[    2.600377] calling  i2c_init+0x0/0x1000 [i2c_core] @ 277
[    2.600726] initcall i2c_init+0x0/0x1000 [i2c_core] returned 0 after 76 usecs
[    2.602350] calling  hpwdt_driver_init+0x0/0x1000 [hpwdt] @ 309
[    2.602711] hpwdt 0000:01:02.0: This server does not have an iLO2+ ASIC.
[    2.603646] initcall hpwdt_driver_init+0x0/0x1000 [hpwdt] returned 0 after 1040 usecs
[    2.616355] calling  ilo_init+0x0/0x1000 [hpilo] @ 311
[    2.618458] initcall ilo_init+0x0/0x1000 [hpilo] returned 0 after 1812 usecs
[    2.623247] calling  amd756_driver_init+0x0/0x1000 [i2c_amd756] @ 277
[    2.624300] calling  amd_pci_driver_init+0x0/0x1000 [pata_amd] @ 275
[    2.624883] pata_amd 0000:00:04.1: version 0.4.1
[    2.624916] initcall amd756_driver_init+0x0/0x1000 [i2c_amd756] returned 0 after 1375 usecs
[    2.632660] scsi1 : pata_amd
[    2.640282] scsi2 : pata_amd
[    2.640696] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
[    2.640945] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
[    2.641292] initcall amd_pci_driver_init+0x0/0x1000 [pata_amd] returned 0 after 16348 usecs
[    2.646837] calling  usb_init+0x0/0x266 [usbcore] @ 308
[    2.647100] ACPI: bus type USB registered
[    2.647391] usbcore: registered new interface driver usbfs
[    2.647663] usbcore: registered new interface driver hub
[    2.654477] usbcore: registered new device driver usb
[    2.654742] initcall usb_init+0x0/0x266 [usbcore] returned 0 after 7425 usecs
[    2.680624] calling  phy_init+0x0/0x59 [libphy] @ 359
[    2.680926] initcall phy_init+0x0/0x59 [libphy] returned 0 after 82 usecs
[    2.690525] calling  pps_init+0x0/0x1000 [pps_core] @ 351
[    2.690755] pps_core: LinuxPPS API ver. 1 registered
[    2.690929] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.691215] initcall pps_init+0x0/0x1000 [pps_core] returned 0 after 481 usecs
[    2.701327] calling  ptp_init+0x0/0x1000 [ptp] @ 351
[    2.701547] PTP clock support registered
[    2.701723] initcall ptp_init+0x0/0x1000 [ptp] returned 0 after 193 usecs
[    2.703333] calling  ioapic_driver_init+0x0/0x1000 [ioapic] @ 356
[    2.705061] calling  ehci_hcd_init+0x0/0x1000 [ehci_hcd] @ 308
[    2.705276] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.705468] initcall ehci_hcd_init+0x0/0x1000 [ehci_hcd] returned 0 after 184 usecs
[    2.724097] ioapic: probe of 0000:00:07.1 failed with error -22
[    2.729857] ioapic: probe of 0000:00:08.1 failed with error -22
[    2.730851] ioapic: probe of 0000:04:09.1 failed with error -22
[    2.731127] ioapic: probe of 0000:04:0a.1 failed with error -22
[    2.731360] ioapic: probe of 0000:04:0b.1 failed with error -22
[    2.731597] ioapic: probe of 0000:04:0c.1 failed with error -22
[    2.731926] initcall ioapic_driver_init+0x0/0x1000 [ioapic] returned 0 after 27701 usecs
[    2.758948] calling  psmouse_init+0x0/0xc7 [psmouse] @ 383
[    2.759571] initcall psmouse_init+0x0/0xc7 [psmouse] returned 0 after 374 usecs
[    2.767517] BUG: unable to handle kernel paging request at 00000000b4343e88
[    2.767842] IP: [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.768109] PGD 0 
[    2.768290] calling  pcspkr_platform_driver_init+0x0/0x1000 [pcspkr] @ 385
[    2.768440] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    2.768673] initcall pcspkr_platform_driver_init+0x0/0x1000 [pcspkr] returned 0 after 365 usecs
[    2.768252] Oops: 0000 [#1] SMP 
[    2.768252] Modules linked in: pcspkr k8temp(+) psmouse ehci_hcd ioapic ptp pps_core libphy usbcore pata_amd i2c_amd756 hpilo usb_common hpwdt i2c_core amd_rng libata evdev shpchp
[    2.770697] CPU: 1 PID: 369 Comm: modprobe Not tainted 3.13.0 #45
[    2.770697] Hardware name: HP ProLiant DL585 G1, BIOS A01 02/14/2007
[    2.770697] task: ffff8800b30f3300 ti: ffff8800b321a000 task.ti: ffff8800b321a000
[    2.770697] RIP: 0010:[<ffffffff8109e31b>]  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.770697] RSP: 0018:ffff8800b321bd78  EFLAGS: 00010202
[    2.770697] RAX: ffffffff81ba70c0 RBX: 00000000b4343e88 RCX: 0000000000003334
[    2.770697] RDX: ffffffff81ac40a8 RSI: 00000000000149a0 RDI: 00000000b4343e88
[    2.770697] RBP: ffffffffa00af6b8 R08: 00000000000149a0 R09: ffff8801fbc149a0
[    2.770697] R10: ffffea000be73140 R11: ffff8800b8803b00 R12: ffffffffa00af6a0
[    2.770697] R13: ffff8800b321be78 R14: 0000000000000000 R15: 0000000000000000
[    2.770697] FS:  00007fd0f5614700(0000) GS:ffff8801fbc00000(0000) knlGS:0000000000000000
[    2.770697] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.770697] CR2: 00000000b4343e88 CR3: 00000001f9f37000 CR4: 00000000000007e0
[    2.770697] Stack:
[    2.770697]  ffffffff81ac40a0 ffffffff81607663 ffffffffa00af220 ffffffff8160772b
[    2.770697]  0000000000000000 ffffffff81110ac5 0000000000000000 ffffffff810f7b2b
[    2.770697]  ffffffff810f4000 0000000000000000 0000000000000000 ffffffff00000003
[    2.770697] Call Trace:
[    2.770697]  [<ffffffff81607663>] ? __mutex_unlock_slowpath+0x53/0x80
[    2.770697]  [<ffffffff8160772b>] ? mutex_unlock+0x2b/0x40
[    2.770697]  [<ffffffff81110ac5>] ? __gcov_init+0x65/0xb0
[    2.770697]  [<ffffffff810f7b2b>] ? load_module+0x223b/0x2710
[    2.770697]  [<ffffffff810f4000>] ? get_modinfo.isra.35+0x110/0x110
[    2.770697]  [<ffffffff8160a0f2>] ? page_fault+0x22/0x30
[    2.770697]  [<ffffffff810f80ee>] ? SyS_init_module+0xee/0x140
[    2.770697]  [<ffffffff816131a1>] ? tracesys+0xd4/0xd9
[    2.770697] Code: 48 83 ec 08 31 d2 48 ff 05 13 58 da 00 e8 ae fb ff ff 48 ff 05 0f 58 da 00 48 83 c4 08 c3 66 90 48 ff 05 a9 54 da 00 53 48 89 fb <48> 8b 07 a8 0c 75 18 48 89 df 31 d2 be 03 00 00 00 e8 7f fb ff 
[    2.770697] RIP  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
[    2.770697]  RSP <ffff8800b321bd78>
[    2.770697] CR2: 00000000b4343e88
[    2.783281] ---[ end trace 38add4c3f78d74c5 ]---
[    2.786341] calling  ohci_hcd_mod_init+0x0/0x1000 [ohci_hcd] @ 310
[    2.786569] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.786768] initcall ohci_hcd_mod_init+0x0/0x1000 [ohci_hcd] returned 0 after 191 usecs
[    2.798568] calling  edac_init+0x0/0xe9b [edac_core] @ 374
[    2.798766] EDAC MC: Ver: 3.0.0
[    2.799490] initcall edac_init+0x0/0xe9b [edac_core] returned 0 after 698 usecs
[    2.801651] calling  floppy_module_init+0x0/0xbea [floppy] @ 350
[    2.802239] Floppy drive(s): fd0 is 1.44M
[    2.818740] FDC 0 is a National Semiconductor PC87306
[    2.820578] calling  tg3_driver_init+0x0/0x1000 [tg3] @ 359
[    2.820908] tg3.c:v3.134 (Sep 16, 2013)
[    2.822985] initcall floppy_module_init+0x0/0xbea [floppy] returned 0 after 20583 usecs
[    2.847117] calling  ohci_pci_init+0x0/0x1000 [ohci_pci] @ 308
[    2.847357] ohci-pci: OHCI PCI platform driver
[    2.847899] ohci-pci 0000:01:00.0: OHCI PCI host controller
[    2.848195] ohci-pci 0000:01:00.0: new USB bus registered, assigned bus number 1
[    2.848618] ohci-pci 0000:01:00.0: irq 19, io mem 0xf7ef0000
[    2.862807] calling  mce_amd_init+0x0/0x1000 [edac_mce_amd] @ 360
[    2.863044] MCE: In-kernel MCE decoding enabled.
[    2.863266] initcall mce_amd_init+0x0/0x1000 [edac_mce_amd] returned 0 after 215 usecs
[    2.876804] tg3 0000:02:06.0 eth0: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e3
[    2.877178] tg3 0000:02:06.0 eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    2.877539] tg3 0000:02:06.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
[    2.877863] tg3 0000:02:06.0 eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
[    2.890170] calling  amd64_edac_init+0x0/0x1000 [amd64_edac_mod] @ 374
[    2.890412] AMD64 EDAC driver v3.4.0
[    2.890777] EDAC amd64: DRAM ECC enabled.
[    2.890986] EDAC amd64: K8 revE or earlier detected (node 0).
[    2.891244] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.891459] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.891861] EDAC MC0: Giving out device to module amd64_edac controller K8: DEV 0000:00:18.2 (INTERRUPT)
[    2.892632] EDAC amd64: DRAM ECC enabled.
[    2.892855] EDAC amd64: K8 revE or earlier detected (node 1).
[    2.893167] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.893392] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.895958] EDAC MC1: Giving out device to module amd64_edac controller K8: DEV 0000:00:19.2 (INTERRUPT)
[    2.896517] EDAC amd64: DRAM ECC enabled.
[    2.896771] EDAC amd64: K8 revE or earlier detected (node 2).
[    2.897065] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.897284] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.897708] EDAC MC2: Giving out device to module amd64_edac controller K8: DEV 0000:00:1a.2 (INTERRUPT)
[    2.898167] EDAC amd64: DRAM ECC enabled.
[    2.898425] EDAC amd64: K8 revE or earlier detected (node 3).
[    2.898732] EDAC amd64: CS6: Registered Double data rate SDRAM
[    2.898921] EDAC amd64: CS7: Registered Double data rate SDRAM
[    2.899423] EDAC MC3: Giving out device to module amd64_edac controller K8: DEV 0000:00:1b.2 (INTERRUPT)
[    2.901186] EDAC PCI0: Giving out device to module amd64_edac controller EDAC PCI controller: DEV 0000:00:18.2 (POLLED)
[    2.901523] initcall amd64_edac_init+0x0/0x1000 [amd64_edac_mod] returned 0 after 10840 usecs
[    2.916393] ata1.00: ATAPI: COMPAQ  CD-ROM SN-124, N104, max PIO4
[    2.925664] tg3 0000:02:06.1 eth1: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e2
[    2.925970] tg3 0000:02:06.1 eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    2.926256] tg3 0000:02:06.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.926532] tg3 0000:02:06.1 eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
[    2.928980] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.929021] initcall tg3_driver_init+0x0/0x1000 [tg3] returned 0 after 105679 usecs
[    2.929455] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.929738] usb usb1: Product: OHCI PCI host controller
[    2.929921] usb usb1: Manufacturer: Linux 3.13.0 ohci_hcd
[    2.930096] usb usb1: SerialNumber: 0000:01:00.0
[    2.930581] hub 1-0:1.0: USB hub found
[    2.930786] hub 1-0:1.0: 3 ports detected
[    2.931633] ohci-pci 0000:01:00.1: OHCI PCI host controller
[    2.931823] ohci-pci 0000:01:00.1: new USB bus registered, assigned bus number 2
[    2.932184] ohci-pci 0000:01:00.1: irq 19, io mem 0xf7ee0000
[    2.933338] ata1.00: configured for PIO4
[    2.934299] scsi 1:0:0:0: CD-ROM            COMPAQ   CD-ROM SN-124    N104 PQ: 0 ANSI: 5
[    2.934945] ata2: port disabled--ignoring
[    2.954973] calling  cdrom_init+0x0/0x1000 [cdrom] @ 405
[    2.955190] initcall cdrom_init+0x0/0x1000 [cdrom] returned 0 after 16 usecs
[    2.959414] calling  init_sr+0x0/0x1000 [sr_mod] @ 405
[    2.963608] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    2.963800] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.964366] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.964641] initcall init_sr+0x0/0x1000 [sr_mod] returned 0 after 4904 usecs
[    2.990169] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.990395] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.990738] usb usb2: Product: OHCI PCI host controller
[    2.990951] usb usb2: Manufacturer: Linux 3.13.0 ohci_hcd
[    2.991164] usb usb2: SerialNumber: 0000:01:00.1
[    2.991600] hub 2-0:1.0: USB hub found
[    2.991830] hub 2-0:1.0: 3 ports detected
[    2.992466] initcall ohci_pci_init+0x0/0x1000 [ohci_pci] returned 0 after 141686 usecs
[    3.011707] calling  init_sg+0x0/0x1000 [sg] @ 406
[    3.012222] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    3.012449] initcall init_sg+0x0/0x1000 [sg] returned 0 after 491 usecs
[    3.251943] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    3.407998] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input3
[   63.903788] random: nonblocking pool is initialized
[   64.426955] Adding 2927612k swap on /dev/cciss/c0d0p5.  Priority:-1 extents:1 across:2927612k 
[   64.453187] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: (null)
[   64.589877] EXT4-fs (cciss!c0d0p1): re-mounted. Opts: errors=remount-ro
[   64.792149] calling  loop_init+0x0/0x1000 [loop] @ 1062
[   64.797878] loop: module loaded
[   64.798086] initcall loop_init+0x0/0x1000 [loop] returned 0 after 5588 usecs
[   66.268625] ip (1882) used greatest stack depth: 4264 bytes left
[   66.766098] calling  init_sunrpc+0x0/0xd0 [sunrpc] @ 1982
[   66.766808] RPC: Registered named UNIX socket transport module.
[   66.766995] RPC: Registered udp transport module.
[   66.767232] RPC: Registered tcp transport module.
[   66.767406] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   66.767615] initcall init_sunrpc+0x0/0xd0 [sunrpc] returned 0 after 1171 usecs
[   66.787687] calling  fscache_init+0x0/0x2c6 [fscache] @ 1984
[   66.788262] FS-Cache: Loaded
[   66.788476] initcall fscache_init+0x0/0x2c6 [fscache] returned 0 after 539 usecs
[   66.802289] calling  init_nlm+0x0/0x1000 [lockd] @ 1984
[   66.802518] initcall init_nlm+0x0/0x1000 [lockd] returned 0 after 24 usecs
[   66.826604] calling  init_nfs_fs+0x0/0x255 [nfs] @ 1984
[   66.826815] FS-Cache: Netfs 'nfs' registered for caching
[   66.827571] initcall init_nfs_fs+0x0/0x255 [nfs] returned 0 after 733 usecs
[   66.867947] calling  init_rpcsec_gss+0x0/0x1000 [auth_rpcgss] @ 1986
[   66.868266] initcall init_rpcsec_gss+0x0/0x1000 [auth_rpcgss] returned 0 after 39 usecs
[   66.893334] calling  init_nfsd+0x0/0x1000 [nfsd] @ 1986
[   66.893571] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   66.894240] initcall init_nfsd+0x0/0x1000 [nfsd] returned 0 after 630 usecs
[   67.182938] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   68.277569] calling  cpufreq_stats_init+0x0/0x1000 [cpufreq_stats] @ 2368
[   68.277783] initcall cpufreq_stats_init+0x0/0x1000 [cpufreq_stats] returned 0 after 7 usecs
[   68.320894] calling  cpufreq_gov_powersave_init+0x0/0x1000 [cpufreq_powersave] @ 2437
[   68.321220] initcall cpufreq_gov_powersave_init+0x0/0x1000 [cpufreq_powersave] returned 0 after 5 usecs
[   68.345768] calling  cpufreq_gov_userspace_init+0x0/0x1000 [cpufreq_userspace] @ 2470
[   68.346089] initcall cpufreq_gov_userspace_init+0x0/0x1000 [cpufreq_userspace] returned 0 after 4 usecs
[   68.489130] calling  cpufreq_gov_dbs_init+0x0/0x1000 [cpufreq_conservative] @ 2492
[   68.489427] initcall cpufreq_gov_dbs_init+0x0/0x1000 [cpufreq_conservative] returned 0 after 3 usecs
[   68.560281] calling  powernowk8_init+0x0/0x2fb [powernow_k8] @ 2553
[   68.560510] powernow-k8: Power state transitions not supported
[   68.560714] powernow-k8: Power state transitions not supported
[   68.560925] powernow-k8: Power state transitions not supported
[   68.561168] powernow-k8: Power state transitions not supported
[   68.561389] initcall powernowk8_init+0x0/0x2fb [powernow_k8] returned -19 after 869 usecs
[   68.587095] calling  acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] @ 2590
[   68.587392] initcall acpi_cpufreq_init+0x0/0x1000 [acpi_cpufreq] returned -19 after 77 usecs
[   68.878402] tg3 0000:02:06.0 eth0: Link is up at 100 Mbps, full duplex
[   68.878750] tg3 0000:02:06.0 eth0: Flow control is on for TX and on for RX
[   68.878997] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

-- 
Meelis Roos (mroos@linux.ee)
