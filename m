Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3CDSkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:40:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35598 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab3CDSkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:40:52 -0500
Date: Mon, 4 Mar 2013 13:40:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, bskeggs@redhat.com, marcin.slusarz@gmail.com,
        martin.peres@labri.fr, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: nouveau shuts the machine down with v3.9-rc1 (temperature (72 C) hit
 the 'shutdown' threshold).
Message-ID: <20130304184022.GA8222@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After git merge ab7826595e9ec51a51f622c5fc91e2f59440481a
(Merge tag 'mfd-3.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6)
the nouveau driver ends up shutting of the machine when booting.


I hadn't done a git bisection yet and was wondering if there are some
juice commits I ought to look at?

Here is the serial console:


ÿûÿýÿûÿýPXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/vmlinuz........................................................................
Loading latest/initramfs.cpio.gz..................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0upstream-10478-g31c7742-dirty (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Sun Mar 3 18:09:03 EST 2013
[    0.000000] Command line: initrd=latest/initramfs.cpio.gz zcache nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b7edffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b7ee0000-0x00000000b7ee2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b7ee3000-0x00000000b7eeffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b7ef0000-0x00000000b7efffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b8000000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 09/03/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 000100000000 mask FFFFC0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000140000000 aka 5120M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xb7ee0 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f3a30-0x000f3a3f] mapped at [ffff8800000f3a30]
[    0.000000]   mpc: f1f44-f2088
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] ACPI: RSDP 00000000000f7e60 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 00000000b7ee3000 00038 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI: FACP 00000000b7ee3080 00074 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20130117/tbfadt-599)
[    0.000000] ACPI: DSDT 00000000b7ee3100 05B85 (v01 NVIDIA NVDAACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000b7ee0000 00040
[    0.000000] ACPI: SSDT 00000000b7ee8d80 008F5 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 00000000b7ee9680 00038 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000098)
[    0.000000] ACPI: MCFG 00000000b7ee96c0 0003C (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI: APIC 00000000b7ee8cc0 00098 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f2000 (        fee00000)
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01cbb000, 0x01cbbfff] PGTABLE
[    0.000000] BRK [0x01cbc000, 0x01cbcfff] PGTABLE
[    0.000000] BRK [0x01cbd000, 0x01cbdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
[    0.000000]  [mem 0x13fe00000-0x13fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
[    0.000000]  [mem 0x13c000000-0x13fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
[    0.000000]  [mem 0x100000000-0x13bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xb7edffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xb7dfffff] page 2M
[    0.000000]  [mem 0xb7e00000-0xb7edffff] page 4k
[    0.000000] RAMDISK: [mem 0x7ba08000-0x7fffefff]
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
[    0.000000]   NODE_DATA [mem 0x13fffa000-0x13fffdfff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff88013b800000-ffff88013effffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xb7edffff]
[    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
[    0.000000] On node 0 totalpages: 1015422
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10245 pages used for memmap
[    0.000000]   DMA32 zone: 749280 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 262144 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f2000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 4, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfeff0000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000b7ee0000 - 00000000b7ee3000
[    0.000000] PM: Registered nosave memory: 00000000b7ee3000 - 00000000b7ef0000
[    0.000000] PM: Registered nosave memory: 00000000b7ef0000 - 00000000b7f00000
[    0.000000] PM: Registered nosave memory: 00000000b7f00000 - 00000000b8000000
[    0.000000] PM: Registered nosave memory: 00000000b8000000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] e820: [mem 0xc0000000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88013fc00000 s84928 r8192 d21568 u524288
[    0.000000] pcpu-alloc: s84928 r8192 d21568 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1001515
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: initrd=latest/initramfs.cpio.gz zcache nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ f000000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ ac000000
[    0.000000] PM: Registered nosave memory: 00000000ac000000 - 00000000b0000000
[    0.000000] Memory: 3787248k/5242880k available (6610k kernel code, 1181192k absent, 274440k reserved, 4308k data, 1032k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2913.414 MHz processor
[    0.000002] Calibrat cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.031872] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.039525] Mount-cache hash table entries: 256
[    0.044214] Initializing cgroup subsys cpuacct
[    0.048661] Initializing cgroup subsys freezer
[    0.053122] tseg: 00b7f00000
[    0.056008] CPU: Physical Processor ID: 0
[    0.060014] CPU: Processor Core ID: 0
[    0.063675] mce: CPU supports 6 MCE banks
[    0.067685] LVT offset 0 assigned for vector 0xf9
[    0.072384] process: using AMD E400 aware idle routine
[    0.077515] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.077515] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.077515] tlb_flushall_shift: 4
[    0.092150] Freeing SMP alternatives: 24k freed
[    0.098197] ACPI: Core revision 20130117
[    0.105006] ACPI: All ACPI Tables successfully acquired
[    0.111854] Getting VERSION: 80050010
[    0.115519] Getting VERSION: 80050010
[    0.119179] Getting ID: 0
[    0.121801] Getting ID: ff000000
[    0.125020] Getting LVT0: 700
[    0.127988] Getting LVT1: 400
[    0.130962] enabled ExtINT on CPU#0
[    0.134761] ESR value before enabling vector: 0x00000008  after: 0x00000000
[    0.141707] ENABLING IO-APIC IRQs
[    0.145022] init IO_APIC IRQs
[    0.147991]  apic 4 pin 0 not connected
[    0.151830] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.159743] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.167645] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.175547] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.183448] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.191352] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.199252] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.207154] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.215057] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.222960] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.231033] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.239109] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.247184] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.255260] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.263333] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.271408]  apic 4 pin 16 not connected
[    0.275323]  apic 4 pin 17 not connected
[    0.279237]  apic 4 pin 18 not connected
[    0.283147]  apic 4 pin 19 not connected
[    0.287060]  apic 4 pin 20 not connected
[    0.290971]  apic 4 pin 21 not connected
[    0.294884]  apic 4 pin 22 not connected
[    0.298795]  apic 4 pin 23 not connected
[    0.302846] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.318824] smpboot: CPU0: AMD Athlon(tm) II X2 245 Processor (fam: 10, model: 06, stepping: 02)
[    0.327635] Using local [    0.436857] ... lapic delta = 1255740
[    0.440510] ... PM-Timer delta = 357941
[    0.444336] ... PM-Timer result ok
[    0.447729] ..... delta 1255740
[    0.450862] ..... mult: 53933622
[    0.454081] ..... calibration result: 200918
[    0.458340] ..... CPU clock speed is 2913.0316 MHz.
[    0.463205] ..... host bus clock speed is 200.0918 MHz.
[    0.468428] Performance Events: AMD PMU driver.
[    0.472978] ... version:                0
[    0.476976] ... bit width:              48
[    0.481059] ... generic registers:      4
[    0.485058] ... value mask:             0000ffffffffffff
[    0.490354] ... max period:             00007fffffffffff
[    0.495653] ... fixed-purpose events:   0
[    0.499651] ... event mask:             000000000000000f
[    0.505134] MCE: In-kernel MCE decoding enabled.
[    0.509801] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.517885] smpboot: Booting Node   0, Processors  #1[    0.533763] masked ExtINT on CPU#1

[    0.539280] Brought up 2 CPUs
[    0.542432] smpboot: Total of 2 processors activated (11653.65 BogoMIPS)
[    0.552539] PM: Registering ACPI NVS region [mem 0xb7ee0000-0xb7ee2fff] (12288 bytes)
[    0.560502] kworker/u:0 (20) used greatest stack depth: 6152 bytes left
[    0.560542] RTC time:  1:28:43, date: 03/04/13
[    0.571571] NET: Registered protocol family 16
[    0.576483] node 0 link 0: io port [8000, ffff]
[    0.581020] TOM: 00000000c0000000 aka 3072M
[    0.585205] Fam 10h mmconf [mem 0xf0000000-0xf00fffff]
[    0.590329] node 0 link 0: mmio [a0000, bffff]
[    0.594775] node 0 link 0: mmio [c0000000, efffffff]
[    0.599744] node 0 link 0: mmio [f4000000, fe02ffff]
[    0.604713] node 0 link 0: mmio [f0000000, f03fffff] ==> [f0100000, f03fffff]
[    0.611861] TOM2: 0000000140000000 aka 5120M
[    0.616122] bus: [bus 00-04] on node 0 link 0
[    0.620474] bus: 00 [io  0x0000-0xffff]
[    0.624300] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.628818] bus: 00 [mem 0xc0000000-0xefffffff]
[    0.633335] bus: 00 [mem 0xf0400000-0xffffffff]
[    0.637853] bus: 00 [mem 0xf0100000-0xf03fffff]
[    0.642371] bus: 00 [mem 0x140000000-0xfcffffffff]
[    0.647199] ACPI: bus type pci registered
[    0.651340] dca service started, version 1.12.1
[    0.655952] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.665240] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.674578] PCI: Using configuration type 1 for base access
[    0.680761] kworker/u:0 (49) used greatest stack depth: 5720 bytes left
[    0.693709] bio: create slab <bio-0> at 0
[    0.697951] ACPI: Added _OSI(Module Device)
[    0.702299] ACPI: Added _OSI(Processor Device)
[    0.706739] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.711429] ACPI: Added _OSI(Processor Aggregator Device)
[    0.717645] ACPI: EC: Look up EC in DSDT
[    0.725257] ACPI: Interpreter enabled
[    0.728914] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.739730] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.748958]  S3 S4 S5)
[    0.751370] ACPI: Using IOAPIC for interrupt routing
[    0.756413] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.775318] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-04])
[    0.781733] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.787901] acpi PNP0A08:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0c
[    0.798110] PCI host bridge to bus 0000:00
[    0.802205] pci_bus 0000:00: root bus resource [bus 00-04]
[    0.807702] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.813869] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.820030] pci_bus 0000:00: root bus resource [io  0x8000-0xffff]
[    0.826193] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.832357] pci_bus 0000:00: root bus resource [io  0x1c00-0x1c80]
[    0.838528] pci_bus 0000:00: root bus resource [mem 0xfec80000-0xfecbffff]
[    0.845391] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.852253] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xefffffff]
[    0.859108] pci_bus 0000:00: root bus resource [mem 0xf4000000-0xfe02ffff]
[    0.865986] pci 0000:00:00.0: [10de:03ea] type 00 class 0x050000
[    0.872269] pci 0000:00:01.0: [10de:03e0] type 00 class 0x060100
[    0.878276] pci 0000:00:01.0: reg 18: [io  0x1d00-0x1dff]
[    0.883782] pci 0000:00:01.1: [10de:03eb] type 00 class 0x0c0500
[    0.889782] pci 0000:00:01.1: reg 10: [io  0xfc00-0xfc3f]
[    0.895177] pci 0000:00:01.1: reg 20: [io  0x1c00-0x1c3f]
[    0.900568] pci 0000:00:01.1: reg 24: [io  0xf400-0xf43f]
[    0.905983] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.911912] pci 0000:00:01.2: [10de:03f5] type 00 class 0x050000
[    0.918058] pci 0000:00:02.0: [10de:03f1] type 00 class 0x0c0310
[    0.924063] pci 0000:00:02.0: reg 10: [mem 0xfe02f000-0xfe02ffff]
[    0.930169] pci 0000:00:02.0: supports D1 D2
[    0.934431] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.941054] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.946807] pci 0000:00:02.1: [10de:03f2] type 00 class 0x0c0320
[    0.952819] pci 0000:00:02.1: reg 10: [mem 0xfe02e000-0xfe02e0ff]
[    0.958939] pci 0000:00:02.1: supports D1 D2
[    0.963202] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.969892] pci 0000:00:02.1: System wakeup disabled by ACPI
[    0.975678] pci 0000:00:04.0: [10de:03f3] type 01 class 0x060401
[    0.981711] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.987457] pci 0000:00:05.0: [10de:03f0] type 00 class 0x040300
[    0.993464] pci 0000:00:05.0: reg 10: [mem 0xfe024000-0xfe027fff]
[    0.999581] pci 0000:00:05.0: PME# supported from D3hot D3cold
[    1.005433] pci 0000:00:05.0: System wakeup disabled by ACPI
[    1.011158] pci 0000:00:06.0: [10de:03ec] type 00 class 0x01018a
[    1.017166] pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
[    1.022682] pci 0000:00:07.0: [10de:03ef] type 00 class 0x068000
[    1.028687] pci 0000:00:07.0: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    1.034775] pci 0000:00:07.0: reg 14: [io  0xec00-0xec07]
[    1.040191] pci 0000:00:07.0: supports D1 D2
[    1.044453] pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.051082] pci 0000:00:07.0: System wakeup disabled by ACPI
[    1.056804] pci 0000:00:08.0: [10de:03f6] type 00 class 0x010185
[    1.062804] pci 0000:00:08.0: reg 10: [io  0x09f0-0x09f7]
[    1.068196] pci 0000:00:08.0: reg 14: [io  0x0bf0-0x0bf3]
[    1.073595] pci 0000:00:08.0: reg 18: [io  0x0970-0x0977]
[    1.078981] pci 0000:00:08.0: reg 1c: [io  0x0b70-0x0b73]
[    1.084371] pci 0000:00:08.0: reg 20: [io  0xd800-0xd80f]
[    1.089764] pci 0000:00:08.0: reg 24: [mem 0xfe02c000-0xfe02cfff]
[    1.095941] pci 0000:00:08.1: [10de:03f6] type 00 class 0x010185
[    1.101941] pci 0000:00:08.1: reg 10: [io  0x09e0-0x09e7]
[    1.107333] pci 0000:00:08.1: reg 14: [io  0x0be0-0x0be3]
[    1.112726] pci 0000:00:08.1: reg 18: [io  0x0960-0x0967]
[    1.118118] pci 0000:00:08.1: reg 1c: [io  0x0b60-0x0b63]
[    1.123511] pci 0000:00:08.1: reg 20: [io  0xc400-0xc40f]
[    1.128901] pci 0000:00:08.1: reg 24: [mem 0xfe02b000-0xfe02bfff]
[    1.135102] pci 0000:00:09.0: [10de:03e8] type 01 class 0x060400
[    1.141129] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.147746] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.153481] pci 0000:00:0b.0: [10de:03e9] type 01 class 0x060400
[    1.159505] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.166138] pci 0000:00:0b.0: System wakeup disabled by ACPI
[    1.171856] pci 0000:00:0c.0: [10de:03e9] type 01 class 0x060400
[    1.177880] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.184503] pci 0000:00:0c.0: System wakeup disabled by ACPI
[    1.190237] pci 0000:00:0d.0: [10de:03d0] type 00 class 0x030000
[    1.196241] pci 0000:00:0d.0: reg 10: [mem 0xfb000000-0xfbffffff]
[    1.202323] pci 0000:00:0d.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.209359] pci 0000:00:0d.0: reg 1c: [mem 0xfc000000-0xfcffffff 64bit]
[    1.215964] pci 0000:00:0d.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.222571] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.228691] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.234802] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.240938] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.247138] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.253374] pci 0000:01:06.0: [8086:1026] type 00 class 0x020000
[    1.259402] pci 0000:01:06.0: reg 10: [mem 0xfd8c0000-0xfd8dffff 64bit]
[    1.266011] pci 0000:01:06.0: reg 18: [mem 0xfd880000-0xfd8bffff 64bit]
[    1.272610] pci 0000:01:06.0: reg 20: [io  0xbc00-0xbc3f]
[    1.278010] pci 0000:01:06.0: reg 30: [mem 0x00000000-0x0003ffff pref]
[    1.284550] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    1.290743] pci 0000:01:08.0: [10b7:1700] type 00 class 0x020000
[    1.296750] pci 0000:01:08.0: reg 10: [mem 0xfd8fc000-0xfd8fffff]
[    1.302835] pci 0000:01:08.0: reg 14: [io  0xb800-0xb8ff]
[    1.308248] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.314788] pci 0000:01:08.0: supports D1 D2
[    1.319048] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.325737] pci 0000:00:04.0: PCI bridge to [bus 01] (subtractive decode)
[    1.332510] pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
[    1.338593] pci 0000:00:04.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    1.345369] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
[    1.352579] pci 0000:00:04.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    1.360480] pci 0000:00:04.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    1.368373] pci 0000:00:04.0:   bridge window [io  0x8000-0xffff] (subtractive decode)
[    1.376266] pci 0000:00:04.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    1.384165] pci 0000:00:04.0:   bridge window [io  0x1c00-0x1c80] (subtractive decode)
[    1.392061] pci 0000:00:04.0:   bridge window [mem 0xfec80000-0xfecbffff] (subtractive decode)
[    1.400648] pci 0000:00:04.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.409241] pci 0000:00:04.0:   bridge window [mem 0xc0000000-0xefffffff] (subtractive decode)
[    1.417828] pci 0000:00:04.0:   bridge window [mem 0xf4000000-0xfe02ffff] (subtractive decode)
[    1.426505] pci 0000:00:09.0: PCI bridge to [bus 02]
[    1.431462] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
[    1.437544] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    1.444320] pci 0000:00:09.0:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
[    1.452138] pci 0000:00:0b.0: PCI bridge to [bus 03]
[    1.457102] pci 0000:00:0b.0:   bridge window [io  0x9000-0x9fff]
[    1.463179] pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    1.469948] pci 0000:00:0b.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    1.477766] pci 0000:00:0c.0: PCI bridge to [bus 04]
[    1.482734] pci 0000:00:0c.0:   bridge window [io  0x8000-0x8fff]
[    1.488815] pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    1.495584] pci 0000:00:0c.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    1.503318] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.510130] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 *7 9 10 11 14 15)
[    1.516762] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.524551] ACPI: PCI Interrupt Link [LNK3] (IRQs *5 7 9 10 11 14 15)
[    1.531188] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.538985] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.546775] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.554565] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.562353] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.570154] ACPI: PCI Interrupt Link [LIGP] (IRQs 5 7 9 10 *11 14 15)
[    1.576782] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.584573] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 *11 14 15)
[    1.591203] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 *15)
[    1.597834] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[    1.604477] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.612268] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
[    1.618900] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 *7 9 10 11 14 15)
[    1.625541] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.633337] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
[    1.639979] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 *10 11 14 15)
[    1.646667] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
[    1.652135] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    1.658570] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    1.664029] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    1.670459] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    1.676893] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[    1.683321] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[    1.689754] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    1.696184] ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22) *0
[    1.702198] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
[    1.708212] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
[    1.714229] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22) *0, disabled.
[    1.721212] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22) *0
[    1.727230] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22) *0
[    1.733243] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
[    1.739259] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
[    1.746243] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
[    1.753229] ACPI: PCI Interrupt Link [APSI] (IRQs 23) *0
[    1.758690] ACPI: PCI Interrupt Link [APSJ] (IRQs 23) *0
[    1.764254] ACPI: Enabled 1 GPEs in block 00 to 1F
[    1.769079] acpi root: \_SB_.PCI0 notify handler is installed
[    1.774852] Found 1 acpi root devices
[    1.778692] ACPI: No dock devices found.
[    1.782831] vgaarb: device added: PCI:0000:00:0d.0,decodes=io+mem,owns=io+mem,locks=none
[    1.790902] vgaarb: loaded
[    1.793605] vgaarb: bridge control possible 0000:00:0d.0
[    1.799068] ACPI: bus type usb registered
[    1.803237] usbcore: registered new interface driver usbfs
[    1.808790] usbcore: registered new interface driver hub
[    1.814179] usbcore: registered new device driver usb
[    1.819388] pps_core: LinuxPPS API ver. 1 registered
[    1.824345] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.833531] PTP clock support registered
[    1.837596] PCI: Using ACPI for IRQ routing
[    1.843202] PCI: pci_cache_line_size set to 64 bytes
[    1.848170] pci 0000:00:01.0: no compatible bridge window for [io  0x1d00-0x1dff]
[    1.855666] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    1.861661] e820: reserve RAM buffer [mem 0xb7ee0000-0xb7ffffff]
[    1.867882] NetLabel: Initializing
[    1.871284] NetLabel:  domain hash size = 128
[    1.875633] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.880595] NetLabel:  unlabeled traffic allowed by default
[    1.886319] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.893368] hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
[    1.898401] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.906342] Switching to clocksource hpet
[    1.912241] pnp: PnP ACPI init
[    1.915320] ACPI: bus type pnp registered
[    1.919586] system 00:00: [io  0x1000-0x107f] has been reserved
[    1.925495] system 00:00: [io  0x1080-0x10ff] has been reserved
[    1.931404] system 00:00: [io  0x1400-0x147f] has been reserved
[    1.937317] system 00:00: [io  0x1480-0x14ff] has been reserved
[    1.943227] system 00:00: [io  0x1800-0x187f] has been reserved
[    1.949138] system 00:00: [io  0x1880-0x18ff] has been reserved
[    1.955051] system 00:00: [io  0x2000-0x207f] has been reserved
[    1.960963] system 00:00: [io  0x2080-0x20ff] has been reserved
[    1.966874] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.973700] pnp 00:01: disabling [io  0x0010-0x001f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    1.983769] pnp 00:01: disabling [io  0x0022-0x003f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    1.993833] pnp 00:01: disabling [io  0x0044-0x005f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.003899] pnp 00:01: disabling [io  0x0062-0x0063] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.013969] pnp 00:01: disabling [io  0x0065-0x006f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.024030] pnp 00:01: disabling [io  0x0074-0x007f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.034095] pnp 00:01: disabling [io  0x0091-0x0093] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.044162] pnp 00:01: disabling [io  0x00a2-0x00bf] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.054225] pnp 00:01: disabling [io  0x00e0-0x00ef] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.064402] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    2.070332] system 00:01: [io  0x0800-0x087f] has been reserved
[    2.076245] system 00:01: [io  0x0290-0x029f] has been reserved
[    2.082158] system 00:01: [io  0x0290-0x0297] has been reserved
[    2.088070] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.094855] pnp 00:02: [dma 4]
[    2.097998] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.104585] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.112577] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.119195] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.125796] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.132323] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:3)
[    2.140466] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.147347] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.155344] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.162866] system 00:08: [mem 0xf0000000-0xf3ffffff] has been reserved
[    2.169477] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.176445] system 00:09: [mem 0x000f0000-0x000fffff] could not be reserved
[    2.183394] system 00:09: [mem 0xfeff0000-0xfeff00ff] has been reserved
[    2.189999] system 00:09: [mem 0xb7ee0000-0xb7efffff] could not be reserved
[    2.196947] system 00:09: [mem 0xffff0000-0xffffffff] has been reserved
[    2.203549] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.210502] system 00:09: [mem 0x00100000-0xb7edffff] could not be reserved
[    2.217452] system 00:09: [mem 0xb8000000-0xbfffffff] has been reserved
[    2.224054] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.231005] system 00:09: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.237609] system 00:09: [mem 0xfefff000-0xfeffffff] has been reserved
[    2.244212] system 00:09: [mem 0xfff80000-0xfff80fff] has been reserved
[    2.250816] system 00:09: [mem 0xfff90000-0xfffbffff] has been reserved
[    2.257419] system 00:09: [mem 0xfffed000-0xfffeffff] has been reserved
[    2.264023] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.270808] pnp: PnP ACPI: found 10 devices
[    2.274988] ACPI: ACPI bus type pnp unregistered
[    2.287847] pci 0000:00:0d.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
[    2.295062] pci 0000:00:01.0: BAR 2: assig46] pci 0000:01:06.0: BAR 6: assigned [mem 0xfdf00000-0xfdf3ffff pref]
[    2.308353] pci 0000:01:08.0: BAR 6: assigned [mem 0xfdf40000-0xfdf5ffff pref]
[    2.315564] pci 0000:00:04.0: PCI bridge to [bus 01]
[    2.320522] pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
[    2.326608] pci 0000:00:04.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    2.333384] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
[    2.340595] pci 0000:00:09.0: PCI bridge to [bus 02]
[    2.345553] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
[    2.351637] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    2.358415] pci 0000:00:09.0:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
[    2.366144] pci 0000:00:0b.0: PCI bridge to [bus 03]
[    2.371101] pci 0000:00:0b.0:   bridge window [io  0x9000-0x9fff]
[    2.377186] pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    2.383962] pci 0000:00:0b.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    2.391692] pci 0000:00:0c.0: PCI bridge to [bus 04]
[    2.396650] pci 0000:00:0c.0:   bridge window [io  0x8000-0x8fff]
[    2.402737] pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    2.409513] pci 0000:00:0c.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    2.417249] pci 0000:00:04.0: setting latency timer to 64
[    2.422646] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    2.428206] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    2.433771] pci_bus 0000:00: resource 6 [io  0x8000-0xffff]
[    2.439336] pci_bus 0000:00: resource 7 [io  0x03b0-0x03df]
[    2.444902] pci_bus 0000:00: resource 8 [io  0x1c00-0x1c80]
[    2.450466] pci_bus 0000:00: resource 9 [mem 0xfec80000-0xfecbffff]
[    2.456724] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    2.463068] pci_bus 0000:00: resource 11 [mem 0xc0000000-0xefffffff]
[    2.469413] pci_bus 0000:00: resource 12 [mem 0xf4000000-0xfe02ffff]
[    2.475758] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    2.481322] pci_bus 0000:01: resource 1 [mem 0xfd800000-0xfd8fffff]
[    2.487585] pci_bus 0000:01: resource 2 [mem 0xfdf00000-0xfdffffff pref]
[    2.494278] pci_bus 0000:01: resource 4 [io  0x0000-0x03af]
[    2.499843] pci_bus 0000:01: resource 5 [io  0x03e0-0x0cf7]
[    2.505409] pci_bus 0000:01: resource 6 [io  0x8000-0xffff]
[    2.510975] pci_bus 0000:01: resource 7 [io  0x03b0-0x03df]
[    2.516538] pci_bus 0000:01: resource 8 [io  0x1c00-0x1c80]
[    2.522103] pci_bus 0000:01: resource 9 [mem 0xfec80000-0xfecbffff]
[    2.528362] pci_bus 0000:01: resource 10 [mem 0x000a0000-0x000bffff]
[    2.534704] pci_bus 0000:01: resource 11 [mem 0xc0000000-0xefffffff]
[    2.541049] pci_bus 0000:01: resource 12 [mem 0xf4000000-0xfe02ffff]
[    2.547395] pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
[    2.552958] pci_bus 0000:02: resource 1 [mem 0xfde00000-0xfdefffff]
[    2.559215] pci_bus 0000:02: resource 2 [mem 0xfdd00000-0xfddfffff 64bit pref]
[    2.566426] pci_bus 0000:03: resource 0 [io  0x9000-0x9fff]
[    2.571991] pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdcfffff]
[    2.578249] pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    2.585460] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
[    2.591024] pci_bus 0000:04: resource 1 [mem 0xfda00000-0xfdafffff]
[    2.597281] pci_bus 0000:04: resource 2 [mem 0xfd900000-0xfd9fffff 64bit pref]
[    2.604531] NET: Registered protocol family 2
[    2.609056] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    2.616441] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    2.623178] TCP: Hash tables configured (established 32768 bind 32768)
[    2.629738] TCP: reno registered
[    2.632971] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.638999] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.645514] NET: Registered protocol family 1
[    2.649981] RPC: Registered named UNIX socket transport module.
[    2.655896] RPC: Registered udp transport module.
[    2.660592] RPC: Registered tcp transport module.
[    2.665291] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.672039] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
[    2.677788] IOAPIC[0]: Set routing entry (4-22 -> 0x41 -> IRQ 22 Mode:1 Active:1 Dest:3)
[    2.748603] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 21
[    2.754362] IOAPIC[0]: Set routing entry (4-21 -> 0x51 -> Ist:3)
[    2.762562] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.768099] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.773635] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.779170] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.784702] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.790244] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.795779] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.801330] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.806819] pci 0000:00:0d.0: Boot video device
[    2.811354] PCI: CLS 64 bytes, default 64
[    2.815434] Unpacking initramfs...
[    4.064465] Freeing initrd memory: 71644k freed
[    4.091372] PCI-DMA: Disabling AGP.
[    4.096149] PCI-DMA: aperture base @ ac000000 size 65536 KB
[    4.101721] PCI-DMA: using GART IOMMU.
[    4.105479] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    4.114763] Machine check injector initialized
[    4.119215] LVT offset 1 assigned for vector 0x400
[    4.124006] IBS: LV patch_level=0x01000098
[    4.142514] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.151281] Scanning for low memory corruption every 60 seconds
[    4.157508] audit: initializing netlink socket (disabled)
[    4.162926] type=2000 audit(1362360524.432:1): initialized
[    4.181598] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.188400] VFS: Disk quotas dquot_6.5.2
[    4.192665
[    4.220903] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    4.228301] io scheduler noop registered
[    4.232224] io scheduler deadline registered
[    4.236499] io scheduler cfq registered (default)
[    4.241359] pcieport 0000:00:09.0: irq 40 for MSI/MSI-X
[    4.246745] pcieport 0000:00:0b.0: irq 41 for MSI/MSI-X
[    4.252085] pcieport 0000:00:0c.0: irq 42 for MSI/MSI-X
[    4.257508] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.263343] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.271692] ACPI: Power Button [PWRB]
[    4.275455] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.282863] ACPI: Power Button [PWRF]
[    4.286704] ACPI: Fan [FAN] (on)
[    4.292508] ACPI Warning: For \_TZ_.THRM._PSL: Return Package has no elements (empty) (20130117/nsprepkg-119)
[    4.302456] ACPI: [Package] has zero elements (ffff88012b0b7fc0)
[    4.308454] ACPI: Invalid passive threshold
[    4.312934] thermal LNXTHERM:00: registered as thermal_zone0
[    4.318598] ACPI: Thermal Zone [THRM] (18 C)
[    4.323034] GHES: HEST is not enabled!
[    4.326787] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.352959] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.379695] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.386064] Non-volatile memory driver v1.3
[    4.390339] Linux agpgart interface v0.103
[    4.394635] [drm] Initialized drm 1.1.0 20060810
[    4.400186] loop: module loaded
[    4.403476] libphy: Fixed MDIO Bus: probed
[    4.407579] tun: Universal TUN/TAP device driver, 1.6
[    4.412623] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.418934] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    4.426497] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 20
[    4.432246] IOAPIC[0]: Set routing entry (4-20 -> 0x91 -> IRQ 20 Mode:1 Active:1 Dest:3)
[    4.440330] forcedeth 0000:00:07.0: setting latency timer to 64
[    4.967103] forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:30:67:6a:6f:d1
[    4.975367] forcedeth 0000:00:ghdma pwrctl mgmt lnktim msi desc-v3
[    4.982508] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.989033] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.995031] ehci-pci: EHCI PCI platform driver
[    4.999602] ehci-pci 0000:00:02.1: setting latency timer to 64
[    5.005433] ehci-pci 0000:00:02.1: EHCI Host Controller
[    5.010791] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    5.018182] ehci-pci 0000:00:02.1: debug port 1
[    5.022713] ehci-pci 0000:00:02.1: reset hcs_params 0x101a8a dbg=1 cc=1 pcc=10 !ppc ports=10
[    5.031150] ehci-pci 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[    5.037751] ehci-pci 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[    5.045838] ehci-pci 0000:00:02.1: park 0
[    5.049846] ehci-pci 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[    5.058700] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    5.065473] ehci-pci 0000:00:02.1: supports USB remote wakeup
[    5.071232] ehci-pci 0000:00:02.1: irq 21, io mem 0xfe02e000
[    5.076881] ehci-pci 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    5.090094] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    5.095884] usb usb1: default language 0x0409
[    5.100248] usb usb1: udev 1, busnum 1, minor = 0
[    5.104949] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.111725] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.118936] usb usb1: Product: EHCI Host Controller
[    5.123806] usb usb1: Manufacturer: Linux 3.8.0upstream-10478-g31c7742-dirty ehci_hcd
[    5.131622] usb usb1: SerialNumber: 0000:00:02.1
[    5.136337] tsc: Refined TSC clocksource calibration: 2913.425 MHz
[    5.142514] Switching to clocksource tsc
[    5.146455] usb usb1: usb_probe_device
[    5.150197] usb usb1: configuration #1 chosen from 1 choice
[    5.155763] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.161591] hub 1-0:1.0: usb_probe_interface
[    5.165860] hub 1-0:1.0: usb_probe_interface - got id
[    5.170906] hub 1-0:1.0: USB hub found
[    5.174657] hub 1-0:1.0: 10 ports detected
[    5.178745] hub 1-0:1.0: standalone hub
[    5.182573] hub 1-0:1.0: no power switching (usb 1.0)
[    5.187618] hub 1-0:1.0: individual port over-current protection
[    5.193615] hub 1-0:1.0: power on to power good time: 20ms
[    5.199086] hub 1-0:1.0: local power source is good
[    5.203988] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    5.211003] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.217182] ohci_hcd: block sizes: ed 80 td 96
[    5.221768] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    5.227611] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    5.232959] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    5.240349] ohci_hcd 0000:00:02.0: created debug files
[    5.245477] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    5.251234] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
[    5.309796] ohci_hcd 0000:00:02.0: OHCI controller state
[    5.315106] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support r:00:02.0: intrstatus 0x00000004 SF
[    5.341774] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    5.348462] ohci_hcd 0000:00:02.0: hcca frame #0029
[    5.353333] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[    5.360447] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[    5.367042] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    5.372946] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    5.379636] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    5.386317] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    5.393000] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    5.399691] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    5.406380] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    5.413061] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    5.419743] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    5.426425] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    5.433106] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    5.439805] usb usb2: default language 0x0409
[    5.444163] usb usb2: udev 1, busnum 2, minor = 128
[    5.449031] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.455799] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.463000] usb usb2: Product: OHCI Host Controller
[    5.467865] usb usb2: Manufacturer: Linux 3.8.0upstream-10478-g31c7742-dirty ohci_hcd
[    5.475679] usb usb2: SerialNumber: 0000:00:02.0
[    5.480390] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.485963] usb usb2: usb_probe_device
[    5.489714] usb usb2: configuration #1 chosen from 1 choice
[    5.495280] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.501116] hub 2-0:1.0: usb_probe_interface
[    5.505384] hub 2-0:1.0: usb_probe_interface - got id
[    5.510429] hub 2-0:1.0: USB hub found
[    5.514173] hub 2-0:1.0: 10 ports detected
[    5.518262] hub 2-0:1.0: standalone hub
[    5.522087] hub 2-0:1.0: no power switching (usb 1.0)
[    5.527125] hub 2-0:1.0: global over-current protection
[    5.532343] hub 2-0:1.0: power on to power good time: 2ms
[    5.537729] hub 2-0:1.0: local power source is good
[    5.542602] hub 2-0:1.0: no over-current condition exists
[    5.548021] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.554912] ehci-pci 0000:00:02.1: HS companion for 0000:00:02.0
[    5.561035] uhci_hcd: USB Universal Host Controller Interface driver
[    5.567535] usbcore: registered new interface driver usblp
[    5.573196] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.614302] i8042: Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    5.622198] i8042: If AUX port is really absent please use the 'i8042.noaux' option
[    5.654369] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.879128] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.884273] mousedev: PS/2 mouse device common for all mice
[    5. core: registered rtc_cmos as rtc0
[    5.901115] rtc_cmos 00:04: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    5.908823] cpuidle: using governor ladder
[    5.912909] cpuidle: using governor menu
[    5.916829] EFI Variables Facility v0.08 2004-May-17
[    5.922045] zram: Created 1 device(s) ...
[    5.926257] Netfilter messages via NETLINK v0.30.
[    5.930965] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    5.937117] ctnetlink v0.93: registering with nfnetlink.
[    5.942597] ip_tables: (C) 2000-2006 Netfilter Core Team
[    5.948070] TCP: cubic registered
[    5.951399] Initializing XFRM netlink socket
[    5.955704] NET: Registered protocol family 10
[    5.960288] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    5.965833] sit: IPv6 over IPv4 tunneling driver
[    5.970724] NET: Registered protocol family 17
[    5.975214] Key type dns_resolver registered
[    5.979802] 
[    5.979802] printing PIC contents
[    5.984599] ... PIC  IMR: ffff
[    5.987654] ... PIC  IRR: 0ca0
[    5.990717] ... PIC  ISR: 0000
[    5.993765] ... PIC ELCR: 8ca0
[    5.996832] printing local APIC contents on CPU#0/0:
[    6.001784] ... APIC ID:      00000000 (0)
[    6.005870] ... APIC VERSION: 80050010
[    6.009607] ... APIC TASKPRI: 00000000 (00)
[    6.013780] ... APIC ARBPRI: 000000e0 (e0)
[    6.017865] ... APIC PROCPRI: 00000000
[    6.021603] ... APIC LDR: 01000000
[    6.024995] ... APIC DFR: ffffffff
[    6.028389] ... APIC SPIV: 000001ff
[    6.031868] ... APIC ISR field:
[    6.035001] 0000000000000000000000000000000000000000000000000000000000000000
[    6.042167] ... APIC TMR field:
[    6.045300] 0000000000000000000000000000000000000000000000000000000000000000
[    6.052467] ... APIC IRR field:
[    6.055600] 0000000000000000000000000000000000000000000000000000000000008000
[    6.062767] ... APIC ESR: 00000000
[    6.066158] ... APIC ICR: 000208fd
[    6.069552] ... APIC ICR2: 02000000
[    6.073032] ... APIC LVTT: 000000ef
[    6.076511] ... APIC LVTPC: 00000400
[    6.080075] ... APIC LVT0: 00010700
[    6.083555] ... APIC LVT1: 00000400
[    6.087034] ... APIC LVTERR: 000000fe
[    6.090687] ... APIC TMICT: 00003003
[    6.094254] ... APIC TMCCT: 00000000
[    6.097819] ... APIC TDCR: 00000003
[    6.101298] ... APIC EFEAT: 00040007
[    6.104863] ... APIC ECTRL: 00000000
[    6.108430] ... APIC EILVT0: 000000f9
[    6.112083] ... APIC EILVT1: 00000400
[    6.115733] ... APIC EILVT2: 00010000
[    6.119386] ... APIC EILVT3: 00010000
[    6.123038] 
[    6.124527] number of MP IRQ sources: 15.
[    6.128533] number of IO-APIC #4 registers: 24.
[    6.133054] testing the IO APIC.......................
[    6.138183] IO APIC #4......
[    6.141065] .... register #00: 00000000
[    6.144895] .......    : physical APIC id: 00
[    6.149241] .......    : Delivery Type: 0
[    6.153246] .......    : LTS          : 0
[    6.157245] .... register #01: 00170011
[    6.161070] .......     : max redirection entries: 17
[    6.166107] .......     : PRQ implemented: 0
[    6.170366] .......     : IO APIC version: 11
[    6.174712] .... register #02: 00000000
[    6.178537] .......     : arbitration: 00
[    6.182535] .... IRQ redirection table:
[    6.186364] 1    0    0   0   0    0    0    00
[    6.190891] 0    0    0   0   0    1    1    31
[    6.195418] 0    0    0   0   0    1    1    30
[    6.199943] 0    0    0   0   0    1    1    33
[    6.204470] 0    0    0   0   0    1    1    34
[    6.208996] 1    0    0   0   0    1    1    35
[    6.213523] 0    0    0   0   0    1    1    36
[    6.218051] 1    0    0   0   0    1    1    37
[    6.222577] 0    0    0   0   0    1    1    38
[    6.227102] 0    1    0   0   0    1    1    39
[    6.231629] 1    0    0   0   0    1    1    3A
[    6.236155] 1    0    0   0   0    1    1    3B
[    6.240682] 1    0    0   0   0    1    1    3C
[    6.245210] 0    0    0   0   0    1    1    3D
[    6.249736] 0    0    0   0   0    1    1    3E
[    6.254263] 0    0    0   0   0    1    1    3F
[    6.258788] 1    0    0   0   0    0    0    00
[    6.263315] 1    0    0   0   0    0    0    00
[    6.267842] 1    0    0   0   0    0    0    00
[    6.272367] 1    0    0   0   0    0    0    00
[    6.276894] 1    1    0   1   0    1    1    91
[    6.281420] 0    1    0   1   0    1    1    51
[    6.285948] 0    1    0   1   0    1    1    41
[    6.290475] 1    0    0   0   0    0    0    00
[    6.294998] IRQ to pin mappings:
[    6.298226] IRQ0 -> 0:2
[    6.300698] IRQ1 -> 0:1
[    6.303173] IRQ3 -> 0:3
[    6.305649] IRQ4 -> 0:4
[    6.308132] IRQ5 -> 0:5
[    6.310607] IRQ6 -> 0:6
[    6.313085] IRQ7 -> 0:7
[    6.315560] IRQ8 -> 0:8
[    6.318034] IRQ9 -> 0:9
[    6.320511] IRQ10 -> 0:10
[    6.323157] IRQ11 -> 0:11
[    6.325806] IRQ12 -> 0:12
[    6.328456] IRQ13 -> 0:13
[    6.331103] IRQ14 -> 0:14
[    6.333752] IRQ15 -> 0:15
[    6.336403] IRQ20 -> 0:20
[    6.339048] IRQ21 -> 0:21
[    6.341697] IRQ22 -> 0:22
[    6.344353] .................................... done.
[    6.349624] PM: Hibernation image not present or could not be loaded.
[    6.356061] registered taskstats version 1
[    6.360598]   Magic number: 5:309:457
[    6.364471] zcache: using lzo compressor
[    6.368430] zcache: cleancache enabled using kernel transcendent memory and compression buddies
[    6.377106] zcache: cleancache: ignorenonactive = 1
[    6.381970] zcache: frontswap enabled using kernel transcendent memory and compression buddies
[    6.390557] zcache: frontswap: excl gets = 1 active only = 1
[    6.397032] Freeing unused kernel memory: 1032k freed
[    6.402360] Write protecting the kernel read-only data: 10240k
[    6.411453] Freeing unused kernel memory: 1568k freed
[    6.417241] Freeing unused kernel memory: 116k freed
init started: BusyBox v1.14.3 ([    6.424574] consoletype (1171) used greatest stack depth: 5288 bytes left
2013-03-03 18:12:45 EST)
Mounting directories  [  OK  ]
mount: mount point /proc/bus/usb does not exist
mount: mount po[    6.543225] core_filesystem (1172) used greatest stack depth: unary operator expected
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    6.606301] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.613341] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.619356] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[    6.625102] IOAPIC[0]: Set routing entry (4-18 -> 0xa1 -> IRQ 18 Mode:1 Active:1 Dest:3)
[    6.636562] SCSI subsystem initialized
[    6.644606] ACPI: bus type scsi registered
[    6.649123] wmi: Mapper loaded
[    6.654654] libata version 3.00 loaded.
udevd-work[1536]: error opening ATTR{/sys/devices/system/cpu/cpu0/online} for writing: No such file or directory

[    6.721681] ip (1700) used greatest stack depth: 3928 bytes left
Waiting for devices [  OK  ]
[    6.900112] sata_nv 0000:00:08.0: version 3.5
[    6.904730] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
[    6.91047G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    6.946301] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 23
[    6.953260] ata2: SATA max UDMA/133 cmd 0x9700:01:06.0 eth1: (PCI:33MHz:32-bit) 00:04:23:a7:5a:01
[    6.981504] e1000 0000:01:06.0 eth1: Intel(R) PRO/1000 Network Connection
^G^G^G^G^G^G^G^G[    6.988624] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
^G^G^G^G^G^G^G^G[    6.995447] IOAPIC[0]: Set routing entry (4-16 -> 0xc1 -> IRQ 16 Mode:1 Active:1 Dest:3)
^G^G^G^G^G^G^G^G[    7.004948] skge: 1.14 addr 0xfd8fc000 irq 16 chip Yukon rev 1
^G^G^G^G^G^G^G^G[    7.012792] skge 0000:01:08.0 eth2: addr 00:0a:5e:65:74:93
^G^G^G[    7.021419] scsi2 : sata_nv
[    7.024680] scsi3 : sata_nv
[    7.027618] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 23
[    7.034564] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 23
[    7.041611] nouveau 0000:00:0d.0: setting latency timer to 64
[    7.047592] ACPI: PCI Interrupt Link [AIGP] enabled at IRQ 22
[    7.053647] nouveau  [  DEVICE][0000:00:0d.0] BOOT0  : 0x04c000a2
[    7.059735] nouveau  [  DEVICE][0000:00:0d.0] Chipset: C61 (NV4C)
[    7.065815] nouveau  [  DEVICE][0000:00:0d.0] Family : NV40
[    7.072133] nouveau  [   VBIOS][0000:00:0d.0] checking PRAMIN for image...
[    7.117667] nouveau  [   VBIOS][0000:00:0d.0] ... appears to be valid
[    7.124097] nouveau  [   VBIOS][0000:00:0d.0] using
[    7.136743] nouveau  [   VBIOS][0000:00:0d.0] version 05.61.32.22.01
^G^G^G[    7.143324] nouveau  [     PFB][0000:00:0d.0] RAM type: unknown
^G^G^G^G^G^G^G^G[    7.149626] nouveau  [     PFB][0000:00:0d.0] RAM size: 128 MiB
[    7.156922] nouveau  [     PFB][0000:00:0d.0]    ZCOMP: 0 tags
^G^G^G^G^G[    7.188682] nouveau  [  PTHERM][0000:00:0d.0] FAN control: none / external
[    7.195547] nouveau  [  PTHERM][0000:00:0d.0] d.0] programmed thresholds [ 90(2), 95(3), 145(2), 135(5) ]
[    7.221515] nouveau  [  PTHERM][0000:00:0d.0] temperature (70 C) hit the 'fanboost' threshold
[    7.230012] nouveau  [  PTHERM][0000:00:0d.0] Thermal management: automatic
[    7.236965] nouveau  [  PTHERM][0000:00:0d.0] temperature (70 C) hit the 'downclock' threshold
[    7.245557] nouveau  [  PTHERM][0000:00:0d.0] temperature (74 C) hit the 'critical' threshold
[    7.254056] nouveau  [  PTHERM][0000:00:0d.0] temperature (72 C) hit the 'shutdown' threshold
^G^G^G^G^G^G^G^G[    7.262725] [TTM] Zone  kernel: Available graphics memory: 1963792 kiB
[    7.270566] [TTM] Initializing pool allocator
^G^G^G^G[    7.274924] [TTM] Initializing DMA pool allocator
[    7.285469] ata1: SATA link down (SStatus 0 SControl 300)
[    7.291190] nouveau  [     DRM] VRAM: 125 MiB
[    7.295546] nouveau  [     DRM] GART: 512 MiB
[    7.299898] nouveau  [     DRM] TMDS table version 1.1
[    7.305028] nouveau  [     DRM] DCB version 3.0
Usage: /etc/init[    7.309556] nouveau  [     DRM] DCB outp 00: 01000310 00000023
.d/halt {start}[    7.316756] nouveau  [     DRM] DCB outp 01: 00110204 97e50000

[    7.323955] nouveau  [     DRM] DCB conn 00: 0000
The system is g[    7.328890] nouveau  [     DRM] Saving VGA fonts
oing down NOW!
Sent SIGTERM to all processes
[    7.375488] ata3: SATA link down (SStatus 0 SControl 300)
[    7.375645] nouveau W[     DRM] DCB type 4 not known
[    7.375646] nouveau W[     DRM] Unknown-1 has no encoders, removing
[    7.377229] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    7.377230] [drm] No driver support for vblank timestamp query.
[    7.377761] nouveau  [     DRM] 1 available performance level(s)
[    7.377763] nouveau  [     DRM] 0: core 425MHz shader 425MHz fanspeed 100%
[    7.377764] nouveau  [     DRM] c:
[    7.421179] nouveau  [     DRM] MM: using M2MF for buffer copies
[    7.460877] nouveau 0000:00:0d.0: No connectors reported connected with modes
[    7.468003] [drm] Cannot find any crtc or sevice
[    7.489812] Console: switching to colour frame buffer device 128x48
[    7.502602] nouveau 0000:00:0d.0: fb0: nouveaufb frame buffer device
[    7.508947] nouveau 0000:00:0d.0: registered panic notifier
[    7.514525] [drm] Initialized nouveau 1.1.0 20120801 for 0000:00:0d.0 on minor 0
^G^G^G^G^G^G[    7.522018] kvm: Nested Virtualization enabled
^G^G^G^G^G^G^G^G[    7.527416] kvm: Nested Paging enabled
^G^G^G^G^G^G^G^Gudevd-work[1273]: '/sbin/modprobe -b pci:v000010DEd000003D0sv00001565sd00001405bc03sc00i00' unexpected exit with status 0x000f

udevd-work[1536]: '/sbin/modprobe -b x86cpu:vendor:0002:family:0010:model:0006:feature:,0000,0001,0002,0003,0004,0005,0006,0007,0008,0009,000B,000C,000D,000E,000F,0010,0011,0013,0017,0018,0019,001A,001C,0020,0021,0022,0023,0024,0025,0026,0027,0028,0029,002B,002C,002D,002E,002F,0030,0031,0034,0036,0037,0038,0039,003A,003B,003D,003E,003F,0064,0068,006A,006E,0070,0071,0074,0078,007A,0080,0083,008D,0097,00C0,00C1,00C2,00C3,00C4,00C5,00C6,00C7,00C8,00C9,00CA,00CC,00CD,00E8,0105,0106,0107,0108
' unexpected exit with status 0x000f

[    7.634071] acpi-cpufreq: overriding BIOS provided _PSD data
[    7.784456] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.793724] ata2.00: ATA-7: HDT722516DLA380, V43OA96A,red for UDMA/133
^G^G^G^G[    7.817326] scsi 1:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
^G^G^G^G^G[    8.138296] ata4: SATA link down (SStatus 0 SControl 300)
Sent SIGKILL to all processes
Requesting system poweroff
[    9.326549] kvm: exiting hardware virtualization
[    9.332053] pci 0000:00:04.0: System wakeup enabled by ACPI
[    9.370526] ACPI: Preparing to enter system sleep state S5
[    9.376550] Disabling non-boot CPUs ...
[    9.381985] Power down.
[    9.384756] acpi_power_off called

PXELINUX 3.82 2009-06-09  Copyright (C) 1994-2009 H. Peter Anvin et al
Loading latest/vmlinuz......................................................................
Loading latest/initramfs.cpio.gz...................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................ready.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0upstream-10478-g31c7742-dirty (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP Sun Mar 3 18:33:20 EST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b7edffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000b7ee0000-0x00000000b7ee2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000b7ee3000-0x00000000b7eeffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000b7ef0000-0x00000000b7efffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000b8000000-0x00000000bfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: BIOSTAR Group N61PB-M2S/N61PB-M2S, BIOS 6.00 PG 09/03/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 000100000000 mask FFFFC0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000140000000 aka 5120M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f3a30-0x000f3a3f] mapped at [c00f3a30]
[    0.000000]   mpc: f1f44-f2088
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] ACPI: RSDP 000f7e60 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT b7ee3000 00038 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI: FACP b7ee3080 00074 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20130117/tbfadt-599)
[    0.000000] ACPI: DSDT b7ee3100 05B85 (v01 NVIDIA NVDAACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS b7ee0000 00040
[    0.000000] ACPI: SSDT b7ee8d80 008F5 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET b7ee9680 00038 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000098)
[    0.000000] ACPI: MCFG b7ee96c0 0003C (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI: APIC b7ee8cc0 00098 (v01 Nvidia NVDAACPI 42302E31 NVDA 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] initial memory mapped: [mem 0x00000000-0x01dfffff]
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x018ca000, 0x018cafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x34000000-0x379fffff]
[    0.000000]  [mem 0x34000000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] RAMDISK: [mem 0x7bcfd000-0x7fffefff]
[    0.000000] Allocated new RAMDISK: [mem 0x338fc000-0x37bfdc28]
[    0.000000] Move RAMDISK from [mem 0x7bcfd000-0x7fffec28] to [mem 0x338fc000-0x37bfdc28]
[    0.000000] 4228MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x018cb000, 0x018cbfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x3fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xb7edffff]
[    0.000000]   node   0: [mem 0x00000000-0x3fffffff]
[    0.000000] On node 0 totalpages: 1015422
[    0.000000] free_area_init_node: node 0, pgdat c1772700, node_mem_map f10fc020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8457 pages used for memmap
[    0.000000]   HighMem zone: 787170 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 4, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 4, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 0e, APIC ID 4, APIC INT 0e
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 0f, APIC ID 4, APIC INT 0f
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 4, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 4, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 4, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 4, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 4, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 4, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 4, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 4, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 4, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 4, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 4, APIC INT 0d
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfeff0000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0xc0000000-0xefffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f10b2000 s35072 r0 d22272 u57344
[    0.000000] pcpu-alloc: s35072 r0 d22272 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1013638
[    0.000000] Kernel command line: initrd=latest/initramfs.cpio.gz zcache nofb debug selinux=0 console=ttyS0,115200 loglevel=10 apic=debug BOOT_IMAGE=latest/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:00140000)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 3941936k/5242880k available (5761k kernel code, 119752k reserved, 1921k data, 544k init, 3148680k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff14000 - 0xfffff000   ( 940 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc1781000 - 0xc1809000   ( 544 kB)
[    0.000000]       .data : 0xc15a0633 - 0xc1780bc0   (1921 kB)
[    0.000000]       .text : 0xc1000000 - 0xc15a0633   (5761 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f0806000 soft=f0808000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2913.496 MHz processor
[    0.000001] Calibratped), value calculated using timer frequency.. 5826.99 BogoMIPS (lpj=2913496)
[    0.010611] pid_max: default: 32768 minimum: 301
[    0.015243] Security Framework initialized
[    0.019336] SELinux:  Disabled at boot.
[    0.023176] Mount-cache hash table entries: 512
[    0.027830] Initializing cgroup subsys cpuacct
[    0.032275] Initializing cgroup subsys freezer
[    0.036729] CPU: Physical Processor ID: 0
[    0.040739] CPU: Processor Core ID: 0
[    0.044409] mce: CPU supports 6 MCE banks
[    0.048419] LVT offset 0 assigned for vector 0xf9
[    0.053126] process: using AMD E400 aware idle routine
[    0.058260] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.058260] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.058260] tlb_flushall_shift: 4
[    0.072938] Freeing SMP alternatives: 24k freed
[    0.078911] ACPI: Core revision 20130117
[    0.085610] ACPI: All ACPI Tables successfully acquired
[    0.092445] Getting VERSION: 80050010
[    0.096105] Getting VERSION: 80050010
[    0.099765] Getting ID: 0
[    0.102387] Getting ID: f000000
[    0.105521] Getting LVT0: 700
[    0.108489] Getting LVT1: 400
[    0.111459] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.116853] enabled ExtINT on CPU#0
[    0.120644] ESR value before enabling vector: 0x00000008  after: 0x00000000
[    0.127592] ENABLING IO-APIC IRQs
[    0.130905] init IO_APIC IRQs
[    0.133875]  apic 4 pin 0 not connected
[    0.137712] IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.145626] IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.153527] IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.161429] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.169332] IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.177233] IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.185136] IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.193037] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.200939] IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.208841] IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.216917] IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.224992] IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.233067] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.241142] IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.249217] IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.257291]  apic 4 pin 16 not connected
[    0.261208]  apic 4 pin 17 not connected
[    0.265120]  apic 4 pin 18 not connected
[    0.269031]  apic 4 pin 19 not connected
[    0.272943]  apic 4 pin 20 not connected
[    0.276854]  apic 4 pin 21 not connected
[    0.280766]  apic 4 pin 22 not connected
[    0.284680]  apic 4 pin 23 not connected
[    0.288729] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.304706] smpboot: CPU0: AMD Athlon(tm) II X2 245 Processor (fam: 10, model: 06, stepping: 02)
[    0.313519] Using local [    0.422871] ... lapic delta = 1255731
[    0.426523] ... PM-Timer delta = 357938
[    0.430348] ... PM-Timer result ok
[    0.433741] ..... delta 1255731
[    0.436873] ..... mult: 53933235
[    0.440093] ..... calibration result: 200916
[    0.444353] ..... CPU clock speed is 2913.0295 MHz.
[    0.449216] ..... host bus clock speed is 200.0916 MHz.
[    0.454442] Performance Events: AMD PMU driver.
[    0.458982] ... version:                0
[    0.462979] ... bit width:              48
[    0.467063] ... generic registers:      4
[    0.471063] ... value mask:             0000ffffffffffff
[    0.476359] ... max period:             00007fffffffffff
[    0.481656] ... fixed-purpose events:   0
[    0.485655] ... event mask:             000000000000000f
[    0.491118] MCE: In-kernel MCE decoding enabled.
[    0.495771] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.503848] CPU 1 irqstacks, hard=f08b8000 soft=f08ba000
[    0.509146] smpboot: Booting Node   0, Processors  #1[    0.524076] Initializing CPU#1
[    0.527142] masked ExtINT on CPU#1

[    0.532640] Brought up 2 CPUs
[    0.535793] smp
[    0.543403] PM: Registering ACPI NVS region [mem 0xb7ee0000-0xb7ee2fff] (12288 bytes)
[    0.551381] kworker/u:0 (20) used greatest stack depth: 7220 bytes left
[    0.551423] RTC time:  1:44:12, date: 03/04/13
[    0.562458] NET: Registered protocol family 16
[    0.567272] kworker/u:0 (29) used greatest stack depth: 7072 bytes left
[    0.573932] node 0 link 0: io port [8000, ffff]
[    0.578457] TOM: 00000000c0000000 aka 3072M
[    0.582634] Fam 10h mmconf [mem 0xf0000000-0xf00fffff]
[    0.587759] node 0 link 0: mmio [a0000, bffff]
[    0.592205] node 0 link 0: mmio [c0000000, efffffff]
[    0.597174] node 0 link 0: mmio [f4000000, fe02ffff]
[    0.602140] node 0 link 0: mmio [f0000000, f03fffff] ==> [f0100000, f03fffff]
[    0.609291] TOM2: 0000000140000000 aka 5120M
[    0.613551] bus: [bus 00-04] on node 0 link 0
[    0.617902] bus: 00 [io  0x0000-0xffff]
[    0.621729] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.626247] bus: 00 [mem 0xc0000000-0xefffffff]
[    0.630764] bus: 00 [mem 0xf0400000-0xffffffff]
[    0.635281] bus: 00 [mem 0xf0100000-0xf03fffff]
[    0.639801] bus: 00 [mem 0x140000000-0xfcffffffff]
[    0.644644] ACPI: bus type pci registered
[    0.648783] dca service started, version 1.12.1
[    0.653390] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.662679] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.669457] PCI: Using MMCONFIG for extended config space
[    0.674845] PCI: Using configuration type 1 for base access
[    0.686986] bio: create slab <bio-0> at 0
[    0.691224] ACPI: Added _OSI(Module Device)
[    0.695457] ACPI: Added _OSI(Pr(3.0 _SCP Extensions)
[    0.704582] ACPI: Added _OSI(Processor Aggregator Device)
[    0.710756] ACPI: EC: Look up EC in DSDT
[    0.718178] ACPI: Interpreter enabled
[    0.721837] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.732650] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.741878]  S3 S4 S5)
[    0.744290] ACPI: Using IOAPIC for interrupt routing
[    0.749332] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.767542] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-04])
[    0.773908] acpi PNP0A08:00: Requesting ACPI _OSC contACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0c
[    0.790191] PCI host bridge to bus 0000:00
[    0.794297] pci_bus 0000:00: root bus resource [bus 00-04]
[    0.799769] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.805930] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.812095] pci_bus 0000:00: root bus resource [io  0x8000-0xffff]
[    0.818266] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.824434] pci_bus 0000:00: root bus resource [io  0x1c00-0x1c80]
[    0.830599] pci_bus 0000:00: root bus resource [mem 0xfec80000-0xfecbffff]
[    0.837463] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.844324] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xefffffff]
[    0.851181] pci_bus 0000:00: root bus resource [mem 0xf4000000-0xfe02ffff]
[    0.858063] pci 0000:00:00.0: [10de:03ea] type 00 class 0x050000
[    0.864336] pci 0000:00:01.0: [10de:03e0] type 00 class 0x060100
[    0.870349] pci 0000:00:01.0: reg 18: [io  0x1d00-0x1dff]
[    0.875845] pci 0000:00:01.1: [10de:03eb] type 00 class 0x0c0500
[    0.881848] pci 0000:00:01.1: reg 10: [io  0xfc00-0xfc3f]
[    0.887248] pci 0000:00:01.1: reg 20: [io  0x1c00-0x1c3f]
[    0.892640] pci 0000:00:01.1: reg 24: [io  0xf400-0xf43f]
[    0.898054] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.903976] pci 0000:00:01.2: [10de:03f5] type 00 class 0x050000
[    0.910136] pci 0000:00:02.0: [10de:03f1] type 00 class 0x0c0310
[    0.916135] pci 0000:00:02.0: reg 10: [mem 0xfe02f000-0xfe02ffff]
[    0.922241] pci 0000:00:02.0: supports D1 D2
[    0.926503] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.933123] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.938854] pci 0000:00:02.1: [10de:03f2] type 00 class 0x0c0320
[    0.944854] pci 0000:00:02.1: reg 10: [mem 0xfe02e000-0xfe02e0ff]
[    0.950986] pci 0000:00:02.1: supports D1 D2
[    0.955246] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.961880] pci 0000:00:02.1: System wakeup disabled by ACPI
[    0.967618] pci 0000:00:04.0: [10de:03f3] type 01 class 0x060401
[    0.973657] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.979381] pci 0000:00:05.0: [10de:03f0] type 00 class 0x040300
[    0.985384] pci 0000:00:05.0: reg 10: [mem 0xfe024000-0xfe027fff]
[    0.991505] pci 0000:00:05.0: PME# supported from D3hot D3cold
[    0.997356] pci 0000:00:05.0: System wakeup disabled by ACPI
[    1.003083] pci 0000:00:06.0: [10de:03ec] type 00 class 0x01018a
[    1.009103] pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
[    1.014594] pci 0000:00:07.0: [10de:03ef] type 00 class 0x068000
[    1.020601] pci 0000:00:07.0: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    1.026686] pci 0000:00:07.0: reg 14: [io  0xec00-0xec07]
[    1.032107] pci 0000:00:07.0: supports D1 D2
[    1.036369] pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.042996] pci 0000:00:07.0: System wakeup disabled by ACPI
[    1.048725] pci 0000:00:08.0: [10de:03f6] type 00 class 0x010185
[    1.054734] pci 0000:00:08.0: reg 10: [io  0x09f0-0x09f7]
[    1.060120] pci 0000:00:08.0: reg 14: [io  0x0bf0-0x0bf3]
[    1.065513] pci 0000:00:08.0: reg 18: [io  0x0970-0x0977]
[    1.070905] pci 0000:00:08.0: reg 1c: [io  0x0b70-0x0b73]
[    1.076296] pci 0000:00:08.0: reg 20: [io  0xd800-0xd80f]
[    1.081689] pci 0000:00:08.0: reg 24: [mem 0xfe02c000-0xfe02cfff]
[    1.087876] pci 0000:00:08.1: [10de:03f6] type 00 class 0x010185
[    1.093884] pci 0000:00:08.1: reg 10: [io  0x09e0-0x09e7]
[    1.099276] pci 0000:00:08.1: reg 14: [io  0x0be0-0x0be3]
[    1.104666] pci 0000:00:08.1: reg 18: [io  0x0960-0x0967]
[    1.110059] pci 0000:00:08.1: reg 1c: [io  0x0b60-0x0b63]
[    1.115452] pci 0000:00:08.1: reg 20: [io  0xc400-0xc40f]
[    1.120843] pci 0000:00:08.1: reg 24: [mem 0xfe02b000-0xfe02bfff]
[    1.127029] pci 0000:00:09.0: [10de:03e8] type 01 class 0x060400
[    1.133047] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.139667] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.145403] pci 0000:00:0b.0: [10de:03e9] type 01 class 0x060400
[    1.151425] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.158047] pci 0000:00:0b.0: System wakeup disabled by ACPI
[    1.163783] pci 0000:00:0c.0: [10de:03e9] type 01 class 0x060400
[    1.169801] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.176430] pci 0000:00:0c.0: System wakeup disabled by ACPI
[    1.182148] pci 0000:00:0d.0: [10de:03d0] type 00 class 0x030000
[    1.188149] pci 0000:00:0d.0: reg 10: [mem 0xfb000000-0xfbffffff]
[    1.194239] pci 0000:00:0d.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.201275] pci 0000:00:0d.0: reg 1c: [mem 0xfc000000-0xfcffffff 64bit]
[    1.207879] pci 0000:00:0d.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.214502] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.220622] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.226741] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.232855] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.238976] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.245158] pci 0000:01:06.0: [8086:1026] type 00 class 0x020000
[    1.251165] pci 0000:01:06.0: reg 10: [mem 0xfd8c0000-0xfd8dffff 64bit]
[    1.257770] pci 0000:01:06.0: reg 18: [mem 0xfd880000-0xfd8bffff 64bit]
[    1.264371] pci 0000:01:06.0: reg 20: [io  0xbc00-0xbc3f]
[    1.269768] pci 0000:01:06.0: reg 30: [mem 0x00000000-0x0003ffff pref]
[    1.276308] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    1.282483] pci 0000:01:08.0: [10b7:1700] type 00 class 0x020000
[    1.288493] pci 0000:01:08.0: reg 10: [mem 0xfd8fc000-0xfd8fffff]
[    1.294590] pci 0000:01:08.0: reg 14: [io  0xb800-0xb8ff]
[    1.300007] pci 0000:01:08.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.306548] pci 0000:01:08.0: supports D1 D2
[    1.310807] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.317506] pci 0000:00:04.0: PCI bridge to [bus 01] (subtractive decode)
[    1.324286] pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
[    1.330382] pci 0000:00:04.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    1.337154] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
[    1.344364] pci 0000:00:04.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    1.352264] pci 0000:00:04.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    1.360159] pci 0000:00:04.0:   bridge window [io  0x8000-0xffff] (subtractive decode)
[    1.368059] pci 0000:00:04.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    1.375955] pci 0000:00:04.0:   bridge window [io  0x1c00-0x1c80] (subtractive decode)
[    1.383855] pci 0000:00:04.0:   bridge window [mem 0xfec80000-0xfecbffff] (subtractive decode)
[    1.392440] pci 0000:00:04.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.401026] pci 0000:00:04.0:   bridge window [mem 0xc0000000-0xefffffff] (subtractive decode)
[    1.409612] pci 0000:00:04.0:   bridge window [mem 0xf4000000-0xfe02ffff] (subtractive decode)
[    1.418285] pci 0000:00:09.0: PCI bridge to [bus 02]
[    1.423245] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
[    1.429339] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    1.436116] pci 0000:00:09.0:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
[    1.443930] pci 0000:00:0b.0: PCI bridge to [bus 03]
[    1.448900] pci 0000:00:0b.0:   bridge window [io  0x9000-0x9fff]
[    1.454991] pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    1.461769] pci 0000:00:0b.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    1.469571] pci 0000:00:0c.0: PCI bridge to [bus 04]
[    1.474530] pci 0000:00:0c.0:   bridge window [io  0x8000-0x8fff]
[    1.480613] pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    1.487386] pci 0000:00:0c.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    1.495112] pci_bus 0000:00: on NUMA node 0
[    1.499285] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.506004] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 *7 9 10 11 14 15)
[    1.512636] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.520425] ACPI: PCI Interrupt Link [LNK3] (IRQs *5 7 9 10 11 14 15)
[    1.527059] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.534844] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.542633] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.550423] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.558213] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.566003] ACPI: PCI Interrupt Link [LIGP] (IRQs 5 7 9 10 *11 14 15)
[    1.572631] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.580431] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 *11 14 15)
[    1.587062] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 *15)
[    1.593690] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[    1.600319] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.608109] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
[    1.614738] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 *7 9 10 11 14 15)
[    1.621368] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    1.629156] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
[    1.635786] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 *10 11 14 15)
[    1.642458] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
[    1.647918] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    1.654335] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    1.659792] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    1.666211] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    1.672633] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[    1.679055] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[    1.685475] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    1.691900] ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22) *0
[    1.697908] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
[    1.703913] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
[    1.709921] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22) *0, disabled.
[    1.716896] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22) *0
[    1.722901] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22) *0
[    1.728909] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
[    1.734915] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
[    1.741890] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
[    1.748867] ACPI: PCI Interrupt Link [APSI] (IRQs 23) *0
[    1.754317] ACPI: PCI Interrupt Link [APSJ] (IRQs 23) *0
[    1.759870] ACPI: Enabled 1 GPEs in block 00 to 1F
[    1.764702] acpi root: \_SB_.PCI0 notify handler is installed
[    1.770481] Found 1 acpi root devices
[    1.774301] ACPI: No dock devices found.
[    1.778419] vgaarb: device added: PCI:0000:00:0d.0,decodes=io+mem,owns=io+mem,locks=none
[    1.786503] vgaarb: loaded
[    1.789209] vgaarb: bridge control possible 0000:00:0d.0
[    1.794676] ACPI: bus type usb registered
[    1.798772] usbcore: registered new interface driver usbfs
[    1.804303] usbcore: registered new interface driver hub
[    1.809682] usbcore: registered new device driver usb
[    1.814892] pps_core: LinuxPPS API ver. 1 registered
[    1.819855] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.829018] PTP clock support registered
[    1.833054] PCI: Using ACPI for IRQ routing
[    1.838655] PCI: pci_cache_line_size set to 64 bytes
[    1.843621] pci 0000:00:01.0: no compatible bridge window for [io  0x1d00-0x1dff]
[    1.851110] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    1.857107] e820: reserve RAM buffer [mem 0xb7ee0000-0xb7ffffff]
[    1.863301] NetLabel: Initializing
[    1.866704] NetLabel:  domain hash size = 128
[    1.871050] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.876016] NetLabel:  unlabeled traffic allowed by default
[    1.881747] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.888782] hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
[    1.893818] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    1.901748] Switching to clocksource hpet
[    1.907379] pnp: PnP ACPI init
[    1.910452] ACPI: bus type pnp registered
[    1.914698] system 00:00: [io  0x1000-0x107f] has been reserved
[    1.920613] system 00:00: [io  0x1080-0x10ff] has been reserved
[    1.926522] system 00:00: [io  0x1400-0x147f] has been reserved
[    1.932434] system 00:00: [io  0x1480-0x14ff] has been reserved
[    1.938345] system 00:00: [io  0x1800-0x187f] has been reserved
[    1.944261] system 00:00: [io  0x1880-0x18ff] has been reserved
[    1.950169] system 00:00: [io  0x2000-0x207f] has been reserved
[    1.956078] system 00:00: [io  0x2080-0x20ff] has been reserved
[    1.961992] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.968816] pnp 00:01: disabling [io  0x0010-0x001f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    1.978878] pnp 00:01: disabling [io  0x0022-0x003f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    1.988942] pnp 00:01: disabling [io  0x0044-0x005f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    1.999008] pnp 00:01: disabling [io  0x0062-0x0063] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.009075] pnp 00:01: disabling [io  0x0065-0x006f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.019138] pnp 00:01: disabling [io  0x0074-0x007f] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.029207] pnp 00:01: disabling [io  0x0091-0x0093] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.039271] pnp 00:01: disabling [io  0x00a2-0x00bf] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.049337] pnp 00:01: disabling [io  0x00e0-0x00ef] because it overlaps 0000:00:01.0 BAR 2 [io  0x0000-0x00ff]
[    2.059505] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    2.065431] system 00:01: [io  0x0800-0x087f] has been reserved
[    2.071337] system 00:01: [io  0x0290-0x029f] has been reserved
[    2.077249] system 00:01: [io  0x0290-0x0297] has been reserved
[    2.083159] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.089946] pnp 00:02: [dma 4]
[    2.093086] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.099668] IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    2.107664] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.114385] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.120978] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    2.127528] IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:3)
[    2.135714] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.142591] IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    2.150600] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.158071] system 00:08: [mem 0xf0000000-0xf3ffffff] has been reserved
[    2.164673] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.171624] system 00:09: [mem 0x000f0000-0x000fffff] could not be reserved
[    2.178583] system 00:09: [mem 0xfeff0000-0xfeff00ff] has been reserved
[    2.185185] system 00:09: [mem 0xb7ee0000-0xb7efffff] could not be reserved
[    2.192136] system 00:09: [mem 0xffff0000-0xffffffff] has been reserved
[    2.198740] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.205686] system 00:09: [mem 0x00100000-0xb7edffff] could not be reserved
[    2.212638] system 00:09: [mem 0xb8000000-0xbfffffff] has been reserved
[    2.219243] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    2.226193] system 00:09: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.232794] system 00:09: [mem 0xfefff000-0xfeffffff] has been reserved
[    2.239400] system 00:09: [mem 0xfff80000-0xfff80fff] has been reserved
[    2.246004] system 00:09: [mem 0xfff90000-0xfffbffff] has been reserved
[    2.252608] system 00:09: [mem 0xfffed000-0xfffeffff] has been reserved
[    2.259210] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.265994] pnp: PnP ACPI: found 10 devices
[    2.270176] ACPI: ACPI bus type pnp unregistered
[    2.312720] pci 0000:00:0d.0: BAR 6: assigned [mem 0xc0000000-0xc001ffff pref]
[    2.319935] pci 0000:00:01.0: BAR 2: assig2.340436] pci 0000:00:04.0: PCI bridge to [bus 01]
[    2.345396] pci 0000:00:04.0:   bridge window [io  0xb000-0xbfff]
[    2.351482] pci 0000:00:04.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    2.358257] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff pref]
[    2.365475] pci 0000:00:09.0: PCI bridge to [bus 02]
[    2.370434] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff]
[    2.376520] pci 0000:00:09.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    2.383301] pci 0000:00:09.0:   bridge window [mem 0xfdd00000-0xfddfffff 64bit pref]
[    2.391041] pci 0000:00:0b.0: PCI bridge to [bus 03]
[    2.396006] pci 0000:00:0b.0:   bridge window [io  0x9000-0x9fff]
[    2.402094] pci 0000:00:0b.0:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    2.408878] pci 0000:00:0b.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    2.416616] pci 0000:00:0c.0: PCI bridge to [bus 04]
[    2.421584] pci 0000:00:0c.0:   bridge window [io  0x8000-0x8fff]
[    2.427676] pci 0000:00:0c.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    2.434455] pci 0000:00:0c.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    2.442191] pci 0000:00:04.0: setting latency timer to 64
[    2.447595] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    2.453165] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    2.458735] pci_bus 0000:00: resource 6 [io  0x8000-0xffff]
[    2.464303] pci_bus 0000:00: resource 7 [io  0x03b0-0x03df]
[    2.469875] pci_bus 0000:00: resource 8 [io  0x1c00-0x1c80]
[    2.475443] pci_bus 0000:00: resource 9 [mem 0xfec80000-0xfecbffff]
[    2.481706] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    2.488053] pci_bus 0000:00: resource 11 [mem 0xc0000000-0xefffffff]
[    2.494405] pci_bus 0000:00: resource 12 [mem 0xf4000000-0xfe02ffff]
[    2.500759] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    2.506330] pci_bus 0000:01: resource 1 [mem 0xfd800000-0xfd8fffff]
[    2.512597] pci_bus 0000:01: resource 2 [mem 0xfdf00000-0xfdffffff pref]
[    2.519297] pci_bus 0000:01: resource 4 [io  0x0000-0x03af]
[    2.524868] pci_bus 0000:01: resource 5 [io  0x03e0-0x0cf7]
[    2.530435] pci_bus 0000:01: resource 6 [io  0x8000-0xffff]
[    2.536007] pci_bus 0000:01: resource 7 [io  0x03b0-0x03df]
[    2.541584] pci_bus 0000:01: resource 8 [io  0x1c00-0x1c80]
[    2.547149] pci_bus 0000:01: resource 9 [mem 0xfec80000-0xfecbffff]
[    2.553408] pci_bus 0000:01: resource 10 [mem 0x000a0000-0x000bffff]
[    2.559756] pci_bus 0000:01: resource 11 [mem 0xc0000000-0xefffffff]
[    2.566102] pci_bus 0000:01: resource 12 [mem 0xf4000000-0xfe02ffff]
[    2.572455] pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
[    2.578027] pci_bus 0000:02: resource 1 [mem 0xfde00000-0xfdefffff]
[    2.584294] pci_bus 0000:02: resource 2 [mem 0xfdd00000-0xfddfffff 64bit pref]
[    2.591513] pci_bus 0000:03: resource 0 [io  0x9000-0x9fff]
[    2.597082] pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdcfffff]
[    2.603351] pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    2.610571] pci_bus 0000:04: resource 0 [io  0x8000-0x8fff]
[    2.616138] pci_bus 0000:04: resource 1 [mem 0xfda00000-0xfdafffff]
[    2.622400] pci_bus 0000:04: resource 2 [mem 0xfd900000-0xfd9fffff 64bit pref]
[    2.629653] NET: Registered protocol family 2
[    2.634123] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    2.641206] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    2.647673] TCP: Hash tables configured (established 8192 bind 8192)
[    2.654039] TCP: reno registered
[    2.657275] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.663198] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.669595] NET: Registered protocol family 1
[    2.674045] RPC: Registered named UNIX socket transport module.
[    2.680020] RPC: Registered udp transport module.
[    2.684727] RPC: Registered tcp transport module.
[    2.689434] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.696154] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
[    2.701904] IOAPIC[0]: Set routing entry (4-22 -> 0x41 -> IRQ 22 Mode:1 Active:1 Dest:3)
[    2.772929] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 21
[    2.778681] IOAPIC[0]: Set routing entry (4-21 -> 0x51 -> IRQ 21 Mode:1 Active:1 Dest:3)
[    2.786854] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.792380] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.797910] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.803437] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.808969] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.814503] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.820036] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.825576] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.831052] pci 0000:00:0d.0: Boot video device
[    2.835584] PCI: CLS 64 bytes, default 64
[    2.839666] Unpacking initramfs...
[    4.187454] Freeing initrd memory: 68616k freed
[    4.213393] Machine check injector initialized
[    4.217845] LVT offset 1 assigned for vector 0x400
[    4.222660] IBS: LVT offset 1 assigned
[    4.226431] perf: AMD IBS detected (0x0000001f)
[    4.231342] microcode: CPU0: patch_level=0x01000098
[    4.236216] microcode: CPU1: patch_level=0x01000098
[    4.241169] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.249947] Scanning for low memory corruption every 60 seconds
[    4.256211] audit: initializing netlink socket (disabled)
[    4.261620] type=2000 audit(1362361452.833:1): initialized
[    4.280126] bounce pool size: 64 pages
[    4.283886] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.290611024 (order 0, 4096 bytes)
[    4.301269] NFS: Registering the id_resolver key type
[    4.306332] Key type id_resolver registered
[    4.310515] Key type id_legacy registered
[    4.314526] NTFS driver 2.1.30 [Flags: R/W].
[    4.318926] msgmni has been set to 1683
[    4.323143] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    4.330541] io scheduler noop registered
[    4.334459] io scheduler deadline registered
[    4.338736] io scheduler cfq registered (default)
[    4.343580] pcieport 0000:00:09.0: irq 40 for MSI/MSI-X
[    4.348898] pcieport 0000:00:0b.0: irq 41 for MSI/MSI-X
[    4.354218] pcieport 0000:00:0c.0: irq 42 for MSI/MSI-X
[    4.359641] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.365518] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.373863] ACPI: Power Button [PWRB]
[    4.377609] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.384990] ACPI: Power Button [PWRF]
[    4.388825] ACPI: Fan [FAN] (on)
[    4.394530] ACPI Warning: For \_TZ_.THRM._PSL: Return Package has no elements (empty) (20130117/nsprepkg-119)
[    4.404480] ACPI: [Package] has zero elements (f0a23220)
[    4.409783] ACPI: Invalid passive threshold
[    4.414251] thermal LNXTHERM:00: registered as thermal_zone0
[    4.419903] ACPI: Thermal Zone [THRM] (20 C)
[    4.424397] GHES: HEST is not enabled!
[    4.428146] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    4.438341] kworker/u:1 (672) used greatest stack depth: 6992 bytes left
[    4.459055] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.485801] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.492168] Non-volatile memory driver v1.3
[    4.496504] Linux agpgart interface v0.103
[    4.501234] [drm] Initialized drm 1.1.0 20060810
[    4.506755] loop: module loaded
[    4.510098] libphy: Fixed MDIO Bus: probed
[    4.514203] tun: Universal TUN/TAP device driver, 1.6
[    4.519244] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.525570] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    4.533139] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 20
[    4.538878] IOAPIC[0]: Set routing entry (4-20 -> 0x91 -> IRQ 20 Mode:1 Active:1 Dest:3)
[    4.546954] forcedeth 0000:00:07.0: setting latency timer to 64
[    5.074382] forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:30:67:6a:6f:d1
[    5.082646] forcedeth 0000:00:ehci_hcd: block sizes: qh 64 qtd 96 itd 160 sitd 96
[    5.102179] ehci-pci: EHCI PCI platform driver
[    5.106723] ehci-pci 0000:00:02.1: setting latency timer to 64
[    5.112549] ehci-pci 0000:00:02.1: EHCI Host Controller
[    5.117856] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    5.125258] ehci-pci 0000:00:02.1: debug port 1
[    5.129783] ehci-pci 0000:00:02.1: reset hcs_params 0x101a8a dbg=1 cc=1 pcc=10 !ppc ports=10
[    5.138209] ehci-pci 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[    5.144821] ehci-pci 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[    5.152911] ehci-pci 0000:00:02.1: park 0
[    5.156923] ehci-pci 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
[    5.165786] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    5.172560] ehci-pci 0000:00:02.1: supports USB remote wakeup
[    5.178333] ehci-pci 0000:00:02.1: irq 21, io mem 0xfe02e000
[    5.183993] ehci-pci 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
[    5.197338] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    5.203123] usb usb1: default language 0x0409
[    5.207490] usb usb1: udev 1, busnum 1, minor = 0
[    5.212193] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.218968] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.226176] usb usb1: Product: EHCI Host Controller
[    5.231052] usb usb1: Manufacturer: Linux 3.8.0upstream-10478-g31c7742-dirty ehci_hcd
[    5.231302] tsc: Refined TSC clocksource calibration: 2913.425 MHz
[    5.231306] Switching to clocksource tsc
[    5.248942] usb usb1: SerialNumber: 0000:00:02.1
[    5.253667] usb usb1: usb_probe_device
[    5.257414] usb usb1: configuration #1 chosen from 1 choice
[    5.262983] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.268806] hub 1-0:1.0: usb_probe_interface
[    5.273068] hub 1-0:1.0: usb_probe_interface - got id
[    5.278113] hub 1-0:1.0: USB hub found
[    5.281853] hub 1-0:1.0: 10 ports detected
[    5.285944] hub 1-0:1.0: standalone hub
[    5.289770] hub 1-0:1.0: no power switching (usb 1.0)
[    5.294807] hub 1-0:1.0: individual port over-current protection
[    5.300798] hub 1-0:1.0: power on to power good time: 20ms
[    5.306279] hub 1-0:1.0: local power source is good
[    5.311181] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    5.318156] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.324322] ohci_hcd: block sizes: ed 64 td 64
[    5.328865] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    5.334682] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    5.339981] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    5.347383] ohci_hcd 0000:00:02.0: created debug files
[    5.352511] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[    5.358270] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
[    5.416048] ohci_hcd 0000:00:02.0: OHCI controller state
[    5.421356] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers, rh state running
[    5.429609] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[    5.436998] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[    5.442477] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[    5.448041] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[    5.454734] ohci_hcd 0000:00:02.0: hcca frame #0029
[    5.459614] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[    5.466737] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[    5.473340] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[    5.479253] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[    5.485950] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[    5.492641] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[    5.499332] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[    5.506021] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[    5.512712] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[    5.519406] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[    5.526100] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[    5.532791] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[    5.539483] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[    5.546183] usb usb2: default language 0x0409
[    5.550546] usb usb2: udev 1, busnum 2, minor = 128
[    5.555422] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.562201] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.569411] usb usb2: Product: OHCI Host Controller
[    5.574281] usb usb2: Manufacturer: Linux 3.8.0upstream-10478-g31c7742-dirty ohci_hcd
[    5.582092] usb usb2: SerialNumber: 0000:00:02.0
[    5.586793] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.586860] usb usb2: usb_probe_device
[    5.586862] usb usb2: configuration #1 chosen from 1 choice
[    5.586871] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.586913] hub 2-0:1.0: usb_probe_interface
[    5.586914] hub 2-0:1.0: usb_probe_interface - got id
[    5.586916] hub 2-0:1.0: USB hub found
[    5.586921] hub 2-0:1.0: 10 ports detected
[    5.586922] hub 2-0:1.0: standalone hub
[    5.586922] hub 2-0:1.0: no power switching (usb 1.0)
[    5.586923] hub 2-0:1.0: global over-current protection
[    5.586924] hub 2-0:1.0: power on to power good time: 2ms
[    5.586927] hub 2-0:1.0: local power source is good
[    5.586928] hub 2-0:1.0: no over-current condition exists
[    5.586961] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    5.587002] ehci-pci 0000:00:02.1: HS companion for 0000:00:02.0
[    5.587039] uhci_hcd: USB Universal Host Controller Interface driver
[    5.673476] usbcore: registered new interface driver usblp
[    5.679121] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.719322] i8042: Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    5.727222] i8042: If AUX port is 0:1.0: state 7 ports 10 chg 0000 evt 0000
[    5.984374] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.989513] mousedev: PS/2 mouse device common for all mice
[    5.19] rtc_cmos 00:04: RTC can wake from S4
[    6.000125] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    6.006247] rtc_cmos 00:04: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    6.013966] cpuidle: using governor ladder
[    6.018071] cpuidle: using governor menu
[    6.021987] EFI Variables Facility v0.08 2004-May-17
[    6.027147] zram: Created 1 device(s) ...
[    6.031371] Netfilter messages via NETLINK v0.30.
[    6.036087] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    6.042221] ctnetlink v0.93: registering with nfnetlink.
[    6.047683] ip_tables: (C) 2000-2006 Netfilter Core Team
[    6.053032] TCP: cubic registered
[    6.056353] Initializing XFRM netlink socket
[    6.060646] NET: Registered protocol family 10
[    6.065230] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.070733] sit: IPv6 over IPv4 tunneling driver
[    6.075533] NET: Registered protocol family 17
[    6.080005] Key type dns_resolver registered
[    6.084528] 
[    6.084528] printing PIC contents
[    6.089319] ... PIC  IMR: ffff
[    6.092369] ... PIC  IRR: 0ca0
[    6.095446] ... PIC  ISR: 0000
[    6.098497] ... PIC ELCR: 8ca0
[    6.101551] printing local APIC contents on CPU#0/0:
[    6.106508] ... APIC ID:      00000000 (0)
[    6.110592] ... APIC VERSION: 80050010
[    6.114332] ... APIC TASKPRI: 00000000 (00)
[    6.118503] ... APIC ARBPRI: 000000e0 (e0)
[    6.122589] ... APIC PROCPRI: 00000000
[    6.126326] ... APIC LDR: 01000000
[    6.129719] ... APIC DFR: ffffffff
[    6.133113] ... APIC SPIV: 000001ff
[    6.136591] ... APIC ISR field:
[    6.139726] 0000000000000000000000000000000000000000000000000000000000000000
[    6.146890] ... APIC TMR field:
[    6.150025] 0000000000000000000000000000000000000000000000000000000000000000
[    6.157190] ... APIC IRR field:
[    6.160323] 0000000000000000000000000000000000000000000000000000000000008000
[    6.167490] ... APIC ESR: 00000000
[    6.170882] ... APIC ICR: 000208fd
[    6.174275] ... APIC ICR2: 02000000
[    6.177753] ... APIC LVTT: 000000ef
[    6.181235] ... APIC LVTPC: 00000400
[    6.184799] ... APIC LVT0: 00010700
[    6.188280] ... APIC LVT1: 00000400
[    6.191758] ... APIC LVTERR: 000000fe
[    6.195410] ... APIC TMICT: 00001965
[    6.198976] ... APIC TMCCT: 00000000
[    6.202543] ... APIC TDCR: 00000003
[    6.206022] ... APIC EFEAT: 00040007
[    6.209588] ... APIC ECTRL: 00000000
[    6.213152] ... APIC EILVT0: 000000f9
[    6.216806] ... APIC EILVT1: 00000400
[    6.220458] ... APIC EILVT2: 00010000
[    6.224110] ... APIC EILVT3: 00010000
[    6.227762] 
[    6.229258] number of MP IRQ sources: 15.
[    6.233262] number of IO-APIC #4 registers: 24.
[    6.237788] testing the IO APIC.......................
[    6.242932] IO APIC #4......
[    6.245817] .... register #00: 00000000
[    6.249650] .......    : physical APIC id: 00
[    6.253997] .......    : Delivery Type: 0
[    6.258003] .......    : LTS          : 0
[    6.262010] .... register #01: 00170011
[    6.265844] .......     : max redirection entries: 17
[    6.270890] .......     : PRQ implemented: 0
[    6.275152] .......     : IO APIC version: 11
[    6.279510] .... register #02: 00000000
[    6.283346] .......     : arbitration: 00
[    6.287353] .... IRQ redirection table:
[    6.291191] 1    0    0   0   0    0    0    00
[    6.295720] 0    0    0   0   0    1    1    31
[    6.300247] 0    0    0   0   0    1    1    30
[    6.304775] 0    0    0   0   0    1    1    33
[    6.309299] 0    0    0   0   0    1    1    34
[    6.313824] 1    0    0   0   0    1    1    35
[    6.318353] 0    0    0   0   0    1    1    36
[    6.322877] 1    0    0   0   0    1    1    37
[    6.327408] 0    0    0   0   0    1    1    38
[    6.331932] 0    1    0   0   0    1    1    39
[    6.336459] 1    0    0   0   0    1    1    3A
[    6.340984] 1    0    0   0   0    1    1    3B
[    6.345513] 1    0    0   0   0    1    1    3C
[    6.350036] 0    0    0   0   0    1    1    3D
[    6.354565] 0    0    0   0   0    1    1    3E
[    6.359089] 0    0    0   0   0    1    1    3F
[    6.363618] 1    0    0   0   0    0    0    00
[    6.368143] 1    0    0   0   0    0    0    00
[    6.372672] 1    0    0   0   0    0    0    00
[    6.377196] 1    0    0   0   0    0    0    00
[    6.381722] 1    1    0   1   0    1    1    91
[    6.386250] 0    1    0   1   0    1    1    51
[    6.390778] 0    1    0   1   0    1    1    41
[    6.395304] 1    0    0   0   0    0    0    00
[    6.399831] IRQ to pin mappings:
[    6.403061] IRQ0 -> 0:2
[    6.405542] IRQ1 -> 0:1
[    6.408036] IRQ3 -> 0:3
[    6.410510] IRQ4 -> 0:4
[    6.412987] IRQ5 -> 0:5
[    6.415463] IRQ6 -> 0:6
[    6.417954] IRQ7 -> 0:7
[    6.420438] IRQ8 -> 0:8
[    6.422931] IRQ9 -> 0:9
[    6.425408] IRQ10 -> 0:10
[    6.428063] IRQ11 -> 0:11
[    6.430722] IRQ12 -> 0:12
[    6.433386] IRQ13 -> 0:13
[    6.436052] IRQ14 -> 0:14
[    6.438719] IRQ15 -> 0:15
[    6.441383] IRQ20 -> 0:20
[    6.444050] IRQ21 -> 0:21
[    6.446706] IRQ22 -> 0:22
[    6.449373] .................................... done.
[    6.454505] Using IPI No-Shortcut mode
[    6.458443] PM: Hibernation image not present or could not be loaded.
[    6.464892] registered taskstats version 1
[    6.469471]   Magic number: 5:68:710
[    6.473207] zcache: using lzo compressor
[    6.477169] zcache: cleancache enabled using kernel transcendent memory and compression buddies
[    6.485847] zcache: cleancache: ignorenonactive = 1
[    6.490719] zcache: frontswap enabled using kernel transcendent memory and compression buddies
[    6.499305] zcache: frontswap: excl gets = 1 active only = 1
[    6.505147] Freeing unused kernel memory: 544k freed
[    6.510283] Write protecting the kernel text: 5764k
[    6.515201] Write protecting the kernel read-only data: 1556k
[    6.520936] NX-protecting the kernel data: 4476k
init started: BusyBox v1.14.3 ([    6.527765] consoletype (1175) used greatest stack depth: 6860 bytes left
2013-03-03 18:36:49 EST)
Mounting directories  [  OK  ]
[    6.542085] mv (1179) used greatest stack depth: 6752 bytes left
[    6.616064] mv (1189) used greatest stack depth: 6576 bytes left
mount: mount point /proc/bus/usb does not exist
mount: mount point /proc/xen does not exist
mount: mount point /sys/kernel/conNo such file or directory
/usr/bin/load_xen_modu[    6.659654] modprobe (1350) used greatest stack depth: 6488 bytes left
les: line 3: [: ==: unary operator expected
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    6.675659] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[    6.681436] IOAPIC[0]: Set routing entry (4-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:3)
[    6.689546] skge: 1.14 addr 0xfd8fc000 irq 16 chip Yukon rev 1
[    6.699425] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.700000] skge 0000:01:08.0 eth1: addr 00:0a:5e:65:74:93
[    6.700174] wmi: Mapper loaded
[    6.714984] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.720795] modprobe (1441) used greatest stack depth: 5804 bytes left
[    6.721112] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[    6.721121] IOAPIC[0]: Set routing entry (4-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:3)
[    6.742544] SCSI subsystem initialized
[    6.761104] ACPI: bus type scsi registered
[    6.782983] nouveau 0000:00:0d.0: setting latency timer to 64
[    6.788963] ACPI: PCI Interrupt Link [AIGP] enabled at IRQ ^G[    6.795716] nouveau  [  DEVICE][0000:00:0d.0] BOOT0  : 0x04c000a2
[    6.795718] nouveau  [  DEVICE][0000:00:0d.0] Chipset: VBIOS][0000:00:0d.0] checking PRAMIN for image...
[    6.834790] nouveau  [   VBIOS][0000:00:0d.0] ... appears to be valid
[    6.834791] nouveau  [   VBIOS][0000:00:0d.0] using image from PRAMIN
[    6.834929] nouveau  [   VBIOS][0000:00:0d.0] BIT signature found
[    6.834930] nouveau  [   VBIOS][0000:00:0d.0] version 05.61.32.22.01
^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G^G[    6.887478] nouveau  [     PFB][0000:00:0d.0] RAM type: unknown
^G^G^G^G^G[    6.894308] nouveau  [     PFB][0000:00:0d.0] RAM size: 128 MiB
[    6.901058] nouveau  [     PFB][0000:00:0d.0]    ZCOMP: 0 tags
[    6.933757] nouveau  [  PTHERM][0000:00:0d.0] FAN control: none / external
[    6.940628] nouveau  [  PTHERM][0000:00:0d.0] Thermal management: disabled
[    6.957474] nouveau  [  PTHERM][0000:00:0d.0] programmed thresholds [ 90(2), 95(3), 145(2), 135(5) ]
[    6.966594] nouveau     6.975100] nouveau  [  PTHERM][0000:00:0d.0] Thermal management: automatic
[    6.982059] nouveau  [  PTHERM][0000:00:0d.0] temperature (88 C) hit the 'downclock' threshold
[    6.990680] nouveau  [  PTHERM][0000:00:0d.0] temperature (88 C) hit the 'critical' threshold
[    6.999194] nouveau  [  PTHERM][0000:00:0d.0] temperature (90 C) hit the 'shutdown' threshold
[    7.007711] hpet1: lost 1 rtc interrupts
^G^G^G^G^G^G^G^G[    7.013194] [TTM] Zone  kernel: Available graphics memory: 431220 kiB
^G^G^G^G^G^G^G^G[    7.020985] [TTM] Zone highmem: Available graphics memory: 2005560 kiB
Usage: /etc/init[    7.028895] [TTM] Initializing pool allocator
.d/halt {start}[    7.034635] [TTM] Initializing DMA pool allocator

The system is [    7.041068] nouveau  [     DRM] VRAM: 125 MiB
going down NOW![    7.046442] nouveau  [     DRM] GART: 512 MiB

Sent SIGTERM t[    7.052175] nouveau  [     DRM] TMDS table version 1.1
o all processes[    7.058683] nouveau  [     DRM] DCB version 3.0
[    7.064499] nouveau  [     DRM] DCB outp 00: 01000310 00000023
[    7.065252] libata version 3.00 loaded.

[    7.074156] nouveau  [     DRM] DCB outp 01: 00110204 97e50000
[    7.074158] nouveau  [     DRM] DCB conn 00: 0000
[    7.074284] nouveau  [     DRM] Saving VGA fonts
udevd-work[1396]: '/sbin/modprobe -b pci:v000010DEd000003F6sv00001565sd00005405bc01sc01i85' unexpected exit with status 0x000f

udevd-work[1343]: '/sbin/modprobe -b pci:v000[    7.103550] e1000 0000:01:06.0 eth2: (PCI:66MHz:32-bit) 00:04:23:a7:5a:01
010DEd000003F6sv[    7.111633] e1000 0000:01:06.0 eth2: Intel(R) PRO/1000 Network Connection
00001565sd000054[    7.119940] modprobe (1431) used greatest stack depth: 5748 bytes left
05bc01sc01i85' unexpected exit with status 0x000f

udevd-work[1328]: '/sbin/m[    7.133729] nouveau W[     DRM] DCB type 4 not known
odprobe -b pci:v[    7.139812] nouveau W[     DRM] Unknown-1 has no encoders, removing
000010DEd000003E[    7.148157] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Csv00001565sd000[    7.155297] [drm] No driver support for vblank timestamp query.
03407bc01sc01i8a[    7.163011] nouveau  [     DRM] 1 available performance level(s)
' unexpected exi[    7.169916] nouveau  [     DRM] 0: core 425MHz shader 425MHz fanspeed 100%
t with status 0x[    7.178154] nouveau  [     DRM] c:
000f

udevd-work[1344]: '/sbi[    7.184291] nouveau  [     DRM] MM: using M2MF for buffer copies
n/modprobe -b pci:v00008086d00001026sv00008086sd00001001bc02sc00i00' unexpected exit with status 0x000f

[    7.225592] nouveau 0000:00:0d.0: No connectors reported connected with modes
[    7.232730] [drm] Cannot find any crtc or smary device
[    7.250046] Console: switching to colour frame buffer device 128x48
[    7.262237] nouveau 0000:00:0d.0: fb0: nouveaufb frame buffer device
[    7.268581] nouveau 0000:00:0d.0: registered panic notifier
[    7.274141] [drm] Initialized nouveau 1.1.0 20120801 for 0000:00:0d.0 on minor 0
^G^G^G^G^G^G^G^G[    7.281828] modprobe (1458) used greatest stack depth: 5640 bytes left
^G^G^G^G^G^G^G^G^G^G^G^Gudevd-work[1298]: '/sbin/modprobe -b pci:v000010DEd000003D0sv00001565sd00001405bc03sc00i00' unexpected exit with status 0x000f

Sent SIGKILL to all processes
Requesting system poweroff
[    9.063560] pci 0000:00:04.0: System wakeup enabled by ACPI
[    9.102275] ACPI: Preparing to enter system sleep state S5
[    9.108294] Disabling non-boot CPUs ...
[    9.113600] Power 

