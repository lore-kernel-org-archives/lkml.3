Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3IWRIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:08:42 -0400
Received: from oker.escape.de ([194.120.234.254]:54162 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab3IWRIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:08:36 -0400
Date: Mon, 23 Sep 2013 18:49:31 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130923164931.GC2322@pompeji.miese-zwerge.org>
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130914112834.GM1509@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20130914112834.GM1509@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	Hello again,

On Sat, Sep 14, 2013 at 01:28:34PM +0200, Jochen Striepe wrote:
> On Mon, Sep 09, 2013 at 03:27:51PM -0700, Paul E. McKenney wrote:
> > rcu: Reject memory-order-induced stall-warning false positives
> 
> I run this patch on top of 3.10.11 vanilla since Wednesday, so far
> without any further stalls, on light to heavy loads. Works smooth
> as pie.

Hmm, perhaps it is not as easy as I thought. On exactly this machine
with exactly this kernel (3.10.11 vanilla with your patch from this
thread), some minutes ago another one came up. The system should have
been mostly idle at that moment. Dmesg appended ... do you need
anything else to have an educated guess? I waited 10 minutes after
the stall message (following your earlier advise), but no further
dmesg lines appeared after that.

Best greetings,
Jochen.

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bar

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.11pm1 (root@sodom) (gcc version 4.7.3 (Debian 4.7.3-4) ) #1 SMP Wed Sep 11 13:05:02 CEST 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e2000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007f64ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f650000-0x000000007f65ffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f660000-0x000000007f66dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007f66e000-0x000000007f6affff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007f6b0000-0x000000007f6bffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f6c8000-0x000000007f7fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7f650 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 080000000 write-back
[    0.000000]   1 base 07F700000 mask 0FFF00000 uncachable
[    0.000000]   2 base 07F800000 mask 0FF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [c00ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x0153e000, 0x0153efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37526000-0x37a8afff]
[    0.000000] Allocated new RAMDISK: [mem 0x36fc1000-0x3752564e]
[    0.000000] Move RAMDISK from [mem 0x37526000-0x37a8a64e] to [mem 0x36fc1000-0x3752564e]
[    0.000000] ACPI: RSDP 000fbfd0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 7f660100 00064 (v01 _ASUS_ Notebook 20091125 MSFT 00000097)
[    0.000000] ACPI: FACP 7f660290 000F4 (v04 112509 FACP1046 20091125 MSFT 00000097)
[    0.000000] ACPI: DSDT 7f660430 095E0 (v02  A1451 A1451000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 7f66e000 00040
[    0.000000] ACPI: APIC 7f660390 0005C (v02 112509 APIC1046 20091125 MSFT 00000097)
[    0.000000] ACPI: MCFG 7f6603f0 0003C (v01 112509 OEMMCFG  20091125 MSFT 00000097)
[    0.000000] ACPI: OEMB 7f66e040 0012C (v01 112509 OEMB1046 20091125 MSFT 00000097)
[    0.000000] ACPI: HPET 7f669a10 00038 (v01 112509 OEMHPET  20091125 MSFT 00000097)
[    0.000000] ACPI: GSCI 7f66e170 02024 (v01 112509 GMCHSCI  20091125 MSFT 00000097)
[    0.000000] ACPI: SSDT 7f670b60 004F0 (v01  PmRef    CpuPm 00003000 INTL 20060113)
[    0.000000] ACPI: SLIC 7f669a50 00176 (v01 _ASUS_ Notebook 20091125 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x0153f000, 0x0153ffff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7f64ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7f64ffff]
[    0.000000] On node 0 totalpages: 521710
[    0.000000] free_area_init_node: node 0, pgdat c147f000, node_mem_map f5fd1020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2301 pages used for memmap
[    0.000000]   HighMem zone: 294482 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e2000
[    0.000000] PM: Registered nosave memory: 00000000000e2000 - 0000000000100000
[    0.000000] e820: [mem 0x7f800000-0xfedfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f77da000 s27456 r0 d21696 u49152
[    0.000000] pcpu-alloc: s27456 r0 d21696 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519934
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10.11pm1 root=/dev/mapper/sodom-root ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f650)
[    0.000000] Memory: 2058604k/2087232k available (3401k kernel code, 28236k reserved, 1232k data, 368k init, 1177928k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8e000 - 0xfffff000   ( 452 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1487000 - 0xc14e3000   ( 368 kB)
[    0.000000]       .data : 0xc135254f - 0xc1486580   (1232 kB)
[    0.000000]       .text : 0xc1000000 - 0xc135254f   (3401 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5806000 soft=f5808000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1331.273 MHz processor
[    0.004004] Calibrating delay loop (skipped), value calculated using timer frequency.. 2662.54 BogoMIPS (lpj=5325092)
[    0.004014] pid_max: default: 32768 minimum: 301
[    0.008062] Mount-cache hash table entries: 512
[    0.008499] Initializing cgroup subsys devices
[    0.008509] Initializing cgroup subsys freezer
[    0.008515] Initializing cgroup subsys net_cls
[    0.008521] Initializing cgroup subsys blkio
[    0.008526] Initializing cgroup subsys perf_event
[    0.008583] Disabled fast string operations
[    0.008593] CPU: Physical Processor ID: 0
[    0.008597] CPU: Processor Core ID: 0
[    0.008602] mce: CPU supports 5 MCE banks
[    0.008618] CPU0: Thermal monitoring enabled (TM2)
[    0.008648] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
[    0.008648] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
[    0.008648] tlb_flushall_shift: 6
[    0.008759] Freeing SMP alternatives: 16k freed
[    0.008789] ACPI: Core revision 20130328
[    0.021274] ACPI: All ACPI Tables successfully acquired
[    0.024197] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024579] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066744] smpboot: CPU0: Intel(R) Atom(TM) CPU Z520   @ 1.33GHz (fam: 06, model: 1c, stepping: 02)
[    0.068000] Performance Events: PEBS fmt0+, LBR disabled due to erratumAtom events, Intel PMU driver.
[    0.068000] ... version:                3
[    0.068000] ... bit width:              40
[    0.068000] ... generic registers:      2
[    0.068000] ... value mask:             000000ffffffffff
[    0.068000] ... max period:             000000007fffffff
[    0.068000] ... fixed-purpose events:   3
[    0.068000] ... event mask:             0000000700000003
[    0.068000] CPU 1 irqstacks, hard=f58e8000 soft=f58ea000
[    0.068000] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] Initializing CPU#1
[    0.008000] Disabled fast string operations
[    0.076117] Brought up 2 CPUs
[    0.076134] smpboot: Total of 2 processors activated (5325.09 BogoMIPS)
[    0.076667] devtmpfs: initialized
[    0.076667] PM: Registering ACPI NVS region [mem 0x7f66e000-0x7f6affff] (270336 bytes)
[    0.076667] regulator-dummy: no parameters
[    0.076667] NET: Registered protocol family 16
[    0.076867] ACPI: bus type PCI registered
[    0.076874] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.077033] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.077042] PCI: not using MMCONFIG
[    0.077325] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
[    0.077329] PCI: Using configuration type 1 for base access
[    0.080461] bio: create slab <bio-0> at 0
[    0.080461] ACPI: Added _OSI(Module Device)
[    0.080461] ACPI: Added _OSI(Processor Device)
[    0.080461] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.080461] ACPI: Added _OSI(Processor Aggregator Device)
[    0.086388] ACPI: EC: Look up EC in DSDT
[    0.089974] ACPI: Executed 1 blocks of module-level executable AML code
[    0.100321] ACPI BIOS Bug: Warning: Incorrect checksum in table [OEMB] - 0xC1, should be 0x11 (20130328/tbutils-324)
[    0.101057] ACPI: SSDT 7f670270 001FA (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
[    0.101953] ACPI: Dynamic OEM Table Load:
[    0.101961] ACPI: SSDT   (null) 001FA (v01  PmRef  Cpu0Ist 00003000 INTL 20060113)
[    0.104065] ACPI: SSDT 7f670500 0065D (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
[    0.104904] ACPI: Dynamic OEM Table Load:
[    0.104911] ACPI: SSDT   (null) 0065D (v01  PmRef  Cpu0Cst 00003001 INTL 20060113)
[    0.105560] ACPI: SSDT 7f6701a0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
[    0.106430] ACPI: Dynamic OEM Table Load:
[    0.106438] ACPI: SSDT   (null) 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20060113)
[    0.106664] ACPI: SSDT 7f670470 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
[    0.107504] ACPI: Dynamic OEM Table Load:
[    0.107511] ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20060113)
[    0.108396] ACPI: Interpreter enabled
[    0.108431] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    0.108444] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    0.108489] ACPI: (supports S0 S3 S4 S5)
[    0.108495] ACPI: Using IOAPIC for interrupt routing
[    0.108575] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.112036] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.112043] PCI: Using MMCONFIG for extended config space
[    0.112091] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.112366] ACPI: No dock devices found.
[    0.130130] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.134505] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.135145] PCI host bridge to bus 0000:00
[    0.135157] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.135166] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.135173] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.135180] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.135188] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.135195] pci_bus 0000:00: root bus resource [mem 0x7f800000-0xdfffffff]
[    0.135202] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xffffffff]
[    0.135229] pci 0000:00:00.0: [8086:8100] type 00 class 0x060000
[    0.135466] pci 0000:00:02.0: [8086:8108] type 00 class 0x030000
[    0.135496] pci 0000:00:02.0: reg 10: [mem 0xf3f80000-0xf3ffffff]
[    0.135512] pci 0000:00:02.0: reg 14: [io  0xc880-0xc887]
[    0.135527] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff]
[    0.135543] pci 0000:00:02.0: reg 1c: [mem 0xf3f40000-0xf3f7ffff]
[    0.135820] pci 0000:00:1b.0: [8086:811b] type 00 class 0x040300
[    0.135848] pci 0000:00:1b.0: reg 10: [mem 0xf3f38000-0xf3f3bfff 64bit]
[    0.135931] pci 0000:00:1b.0: PME# supported from D0 D3hot
[    0.136141] pci 0000:00:1c.0: [8086:8110] type 01 class 0x060400
[    0.136229] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.136336] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.136437] pci 0000:00:1c.1: [8086:8112] type 01 class 0x060400
[    0.136523] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.136628] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.136738] pci 0000:00:1d.0: [8086:8114] type 00 class 0x0c0300
[    0.136788] pci 0000:00:1d.0: reg 20: [io  0xb880-0xb89f]
[    0.136951] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.137052] pci 0000:00:1d.1: [8086:8115] type 00 class 0x0c0300
[    0.137103] pci 0000:00:1d.1: reg 20: [io  0xc080-0xc09f]
[    0.137263] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.137363] pci 0000:00:1d.2: [8086:8116] type 00 class 0x0c0300
[    0.137414] pci 0000:00:1d.2: reg 20: [io  0xc480-0xc49f]
[    0.137573] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.137692] pci 0000:00:1d.7: [8086:8117] type 00 class 0x0c0320
[    0.137728] pci 0000:00:1d.7: reg 10: [mem 0xf3f37c00-0xf3f37fff]
[    0.137864] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.137976] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.138080] pci 0000:00:1f.0: [8086:8119] type 00 class 0x060100
[    0.138315] pci 0000:00:1f.1: [8086:811a] type 00 class 0x010180
[    0.138368] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.138675] pci 0000:03:00.0: [1969:1062] type 00 class 0x020000
[    0.138711] pci 0000:03:00.0: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
[    0.138732] pci 0000:03:00.0: reg 18: [io  0xe880-0xe8ff]
[    0.138861] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.148036] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.148047] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.148057] pci 0000:00:1c.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.148198] pci 0000:01:00.0: [168c:002b] type 00 class 0x028000
[    0.148233] pci 0000:01:00.0: reg 10: [mem 0xfbef0000-0xfbefffff 64bit]
[    0.148366] pci 0000:01:00.0: supports D1
[    0.148373] pci 0000:01:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.156028] pci 0000:00:1c.1: PCI bridge to [bus 01-02]
[    0.156039] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.156049] pci 0000:00:1c.1:   bridge window [mem 0xf4000000-0xfbefffff]
[    0.156059] pci 0000:00:1c.1:   bridge window [mem 0xcc000000-0xcfffffff pref]
[    0.156078] pci_bus 0000:00: on NUMA node 0
[    0.156089] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.156096] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.157451] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.157655] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.157855] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.158055] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.158262] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 7 10 11 12 14 15)
[    0.158463] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.158663] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.158862] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
[    0.159336] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.159357] acpi root: \_SB_.PCI0 notify handler is installed
[    0.159483] Found 1 acpi root devices
[    0.159663] ACPI: EC: GPE = 0xd, I/O: command/status = 0x66, data = 0x62
[    0.160053] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.160064] vgaarb: loaded
[    0.160069] vgaarb: bridge control possible 0000:00:02.0
[    0.160091] PCI: Using ACPI for IRQ routing
[    0.160152] PCI: pci_cache_line_size set to 64 bytes
[    0.160218] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.160225] e820: reserve RAM buffer [mem 0x7f650000-0x7fffffff]
[    0.160567] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.160577] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.160589] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.164053] Switching to clocksource hpet
[    0.164191] pnp: PnP ACPI init
[    0.164222] ACPI: bus type PNP registered
[    0.164606] system 00:00: [mem 0x7f800000-0x7fffffff] has been reserved
[    0.164619] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.164742] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.164903] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.164987] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.165081] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.165582] system 00:05: [io  0x0374-0x0375] has been reserved
[    0.165592] system 00:05: [io  0x03f4-0x03f5] has been reserved
[    0.165601] system 00:05: [io  0x0380-0x0387] has been reserved
[    0.165608] system 00:05: [io  0x09f4-0x09ff] has been reserved
[    0.165617] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.165624] system 00:05: [io  0x0900-0x09f3] has been reserved
[    0.165632] system 00:05: [io  0x0400-0x043f] has been reserved
[    0.165640] system 00:05: [io  0x0480-0x04bf] has been reserved
[    0.165649] system 00:05: [mem 0xf0000000-0xf0003fff] has been reserved
[    0.165658] system 00:05: [mem 0x00000384-0x00000387] could not be reserved
[    0.165667] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.165789] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.165998] pnp 00:07: Plug and Play ACPI device, IDs INT0800 (active)
[    0.166204] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.166543] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.166553] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.166563] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.166782] pnp 00:0a: Plug and Play ACPI device, IDs SYN0a13 SYN0a01 SYN0a04 SYN0002 PNP0f13 (active)
[    0.166961] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.166972] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.167594] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.167605] system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.167613] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.167621] system 00:0c: [mem 0x00100000-0x7f7fffff] could not be reserved
[    0.167631] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.168194] pnp: PnP ACPI: found 13 devices
[    0.168200] ACPI: bus type PNP unregistered
[    0.209203] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff pref] to [bus 03] add_size 200000
[    0.209228] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff pref] get_res_add_size add_size 200000
[    0.209244] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff pref]
[    0.209252] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.209262] pci 0000:00:1c.0:   bridge window [io  0xe000-0xefff]
[    0.209273] pci 0000:00:1c.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.209283] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff pref]
[    0.209296] pci 0000:00:1c.1: PCI bridge to [bus 01-02]
[    0.209304] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.209314] pci 0000:00:1c.1:   bridge window [mem 0xf4000000-0xfbefffff]
[    0.209324] pci 0000:00:1c.1:   bridge window [mem 0xcc000000-0xcfffffff pref]
[    0.209619] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.209629] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.209636] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.209643] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.209650] pci_bus 0000:00: resource 8 [mem 0x7f800000-0xdfffffff]
[    0.209658] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xffffffff]
[    0.209666] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.209673] pci_bus 0000:03: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.209680] pci_bus 0000:03: resource 2 [mem 0x80000000-0x801fffff pref]
[    0.209688] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.209695] pci_bus 0000:01: resource 1 [mem 0xf4000000-0xfbefffff]
[    0.209702] pci_bus 0000:01: resource 2 [mem 0xcc000000-0xcfffffff pref]
[    0.209834] NET: Registered protocol family 2
[    0.210284] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.210358] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.210429] TCP: Hash tables configured (established 8192 bind 8192)
[    0.210538] TCP: reno registered
[    0.210546] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.210567] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.210753] NET: Registered protocol family 1
[    0.210802] pci 0000:00:02.0: Boot video device
[    0.211811] PCI: CLS 32 bytes, default 64
[    0.211944] Unpacking initramfs...
[    0.512610] Freeing initrd memory: 5524k freed
[    0.521954] audit: initializing netlink socket (disabled)
[    0.521991] type=2000 audit(1379952906.520:1): initialized
[    0.522609] bounce pool size: 64 pages
[    0.522645] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.523275] VFS: Disk quotas dquot_6.5.2
[    0.523347] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.523583] msgmni has been set to 1730
[    0.524361] alg: No test for stdrng (krng)
[    0.524445] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.524453] io scheduler noop registered
[    0.524458] io scheduler deadline registered
[    0.524491] io scheduler cfq registered (default)
[    0.524832] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.524888] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.525061] intel_idle: MWAIT substates: 0x3020220
[    0.525078] intel_idle: v0.4 model 0x1C
[    0.525083] intel_idle: lapic_timer_reliable_states 0x2
[    0.525089] tsc: Marking TSC unstable due to TSC halts in idle states deeper than C2
[    0.525180] GHES: HEST is not enabled!
[    0.525325] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.526592] Linux agpgart interface v0.103
[    0.526789] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.551083] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.551104] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.551481] mousedev: PS/2 mouse device common for all mice
[    0.552889] rtc_cmos 00:01: RTC can wake from S4
[    0.553118] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    0.553162] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.553330] cpuidle: using governor ladder
[    0.553498] cpuidle: using governor menu
[    0.553721] TCP: cubic registered
[    0.553808] NET: Registered protocol family 10
[    0.554292] mip6: Mobile IPv6
[    0.554300] NET: Registered protocol family 17
[    0.554343] Key type dns_resolver registered
[    0.554733] Using IPI No-Shortcut mode
[    0.555058] registered taskstats version 1
[    0.555914] rtc_cmos 00:01: setting system clock to 2013-09-23 16:15:06 UTC (1379952906)
[    0.556194] Freeing unused kernel memory: 368k freed
[    0.576991] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.699928] udevd[56]: starting version 175
[    0.806771] ACPI: bus type USB registered
[    0.806905] usbcore: registered new interface driver usbfs
[    0.806966] usbcore: registered new interface driver hub
[    0.815016] usbcore: registered new device driver usb
[    0.816467] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.817417] uhci_hcd: USB Universal Host Controller Interface driver
[    0.817716] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.817732] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.817764] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    0.817874] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000b880
[    0.818048] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    0.818061] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.818071] usb usb1: Product: UHCI Host Controller
[    0.818081] usb usb1: Manufacturer: Linux 3.10.11pm1 uhci_hcd
[    0.818090] usb usb1: SerialNumber: 0000:00:1d.0
[    0.819031] ehci-pci: EHCI PCI platform driver
[    0.820901] atl1c 0000:03:00.0: version 1.0.1.1-NAPI
[    0.834650] hub 1-0:1.0: USB hub found
[    0.834675] hub 1-0:1.0: 2 ports detected
[    0.851744] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    0.852139] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    0.852169] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.852210] ehci-pci 0000:00:1d.7: debug port 1
[    0.856204] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    0.866276] ehci-pci 0000:00:1d.7: irq 19, io mem 0xf3f37c00
[    0.876082] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.876168] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.876180] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.876190] usb usb2: Product: EHCI Host Controller
[    0.876200] usb usb2: Manufacturer: Linux 3.10.11pm1 ehci_hcd
[    0.876209] usb usb2: SerialNumber: 0000:00:1d.7
[    0.876676] hub 2-0:1.0: USB hub found
[    0.876697] hub 2-0:1.0: 8 ports detected
[    0.899811] thermal LNXTHERM:00: registered as thermal_zone0
[    0.899826] ACPI: Thermal Zone [TZ00] (40 C)
[    0.900224] hub 1-0:1.0: USB hub found
[    0.900244] hub 1-0:1.0: 2 ports detected
[    0.901813] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.901830] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.901858] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.901981] uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000c080
[    0.902143] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.902155] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.902164] usb usb3: Product: UHCI Host Controller
[    0.902173] usb usb3: Manufacturer: Linux 3.10.11pm1 uhci_hcd
[    0.902181] usb usb3: SerialNumber: 0000:00:1d.1
[    0.902752] hub 3-0:1.0: USB hub found
[    0.902778] hub 3-0:1.0: 2 ports detected
[    0.903514] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.903535] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.903563] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.903682] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c480
[    0.903867] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.903881] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.903892] usb usb4: Product: UHCI Host Controller
[    0.903902] usb usb4: Manufacturer: Linux 3.10.11pm1 uhci_hcd
[    0.903911] usb usb4: SerialNumber: 0000:00:1d.2
[    0.904503] hub 4-0:1.0: USB hub found
[    0.904526] hub 4-0:1.0: 2 ports detected
[    0.914737] SCSI subsystem initialized
[    0.936542] ACPI: bus type ATA registered
[    0.937588] libata version 3.00 loaded.
[    0.938244] pata_sch 0000:00:1f.1: version 0.2
[    0.938408] pata_sch 0000:00:1f.1: setting latency timer to 64
[    0.939546] scsi0 : pata_sch
[    0.940608] scsi1 : pata_sch
[    0.940867] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.940880] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.150250] ata1.00: ATA-8: ST9250315AS, 0002SDM1, max UDMA/133
[    1.150266] ata1.00: 488397168 sectors, multi 16: LBA48 
[    1.165208] ata1.00: configured for UDMA/100
[    1.165724] scsi 0:0:0:0: Direct-Access     ATA      ST9250315AS      0002 PQ: 0 ANSI: 5
[    1.188311] usb 2-5: new high-speed USB device number 2 using ehci-pci
[    1.335231] usb 2-5: New USB device found, idVendor=13d3, idProduct=5111
[    1.335248] usb 2-5: New USB device strings: Mfr=1, Product=2, SerialNumber=2
[    1.335259] usb 2-5: Product: USB2.0 UVC VGA WebCam
[    1.335269] usb 2-5: Manufacturer: Image Processor
[    1.335278] usb 2-5: SerialNumber: USB2.0 UVC VGA WebCam
[    1.348402] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.348717] sd 0:0:0:0: [sda] Write Protect is off
[    1.348732] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.348864] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.364441]  sda: sda1 sda2 < sda5 >
[    1.365932] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.370600] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.719512] device-mapper: uevent: version 1.0.3
[    1.719736] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   22.850525] bio: create slab <bio-1> at 1
[   23.123895] bio: create slab <bio-1> at 1
[   23.991776] PM: Starting manual resume from disk
[   24.046947] kjournald starting.  Commit interval 5 seconds
[   24.047018] EXT3-fs (dm-1): mounted filesystem with ordered data mode
[   26.375409] udevd[400]: starting version 175
[   27.478951] ACPI: Battery Slot [BAT0] (battery absent)
[   27.495197] input: PC Speaker as /devices/platform/pcspkr/input/input1
[   27.590161] ACPI Warning: 0x00000400-0x0000043f SystemIO conflicts with Region \SMRG 1 (20130328/utaddress-251)
[   27.590185] ACPI Warning: 0x00000400-0x0000043f SystemIO conflicts with Region \_SB_.PCI0.SBRG.SMRG 2 (20130328/utaddress-251)
[   27.590201] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   27.590222] lpc_sch: probe of 0000:00:1f.0 failed with error -16
[   27.638465] microcode: CPU0 sig=0x106c2, pf=0x1, revision=0x211
[   27.639576] ACPI: AC Adapter [AC0] (on-line)
[   27.640309] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[   27.645628] ACPI: Lid Switch [LID]
[   27.645871] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[   27.646054] ACPI: Sleep Button [SLPB]
[   27.646256] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[   27.646399] ACPI: Power Button [PWRB]
[   27.665928] cfg80211: Calling CRDA to update world regulatory domain
[   27.669092] microcode: CPU1 sig=0x106c2, pf=0x1, revision=0x211
[   27.669786] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   27.878347] wmi: Mapper loaded
[   27.895475] ACPI: Requesting acpi_cpufreq
[   28.014754] [drm] Initialized drm 1.1.0 20060810
[   28.075868] gma500 0000:00:02.0: setting latency timer to 64
[   27.947510] asus_wmi: ASUS WMI generic driver loaded
[   28.080311] asus_wmi: Initialization: 0x0asus_wmi: BIOS WMI version: 0.5
[   28.082289] asus_wmi: SFUN value: 0x0<6>[   28.091896] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input5
[   28.116952] ath: phy0: ASPM enabled: 0x42
[   28.116986] ath: EEPROM regdomain: 0x60
[   28.116993] ath: EEPROM indicates we should expect a direct regpair map
[   28.117004] ath: Country alpha2 being used: 00
[   28.117009] ath: Regpair used: 0x60
[   28.124646] acpi device:0c: registered as cooling_device2
[   28.124733] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   28.124920] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
[   28.127317] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   28.127331] [drm] No driver support for vblank timestamp query.
[   28.203103] asus_wmi: Backlight controlled by ACPI video driver
[   28.289781] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   28.290622] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xf83c0000, irq=17
[   29.230001] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 600854
[   29.312093] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   29.529197] fbcon: psbdrmfb (fb0) is primary device
[   29.800819] Console: switching to colour frame buffer device 170x48
[   29.815308] gma500 0000:00:02.0: fb0: psbdrmfb frame buffer device
[   29.815315] gma500 0000:00:02.0: registered panic notifier
[   29.815476] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
[   29.815501] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
[   29.843254] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[   29.848157] input: HDA Intel MID Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   29.848517] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   29.912158] gma500 0000:00:02.0: Backlight lvds set brightness 7a127a12
[   31.952960] EXT3-fs (dm-1): using internal journal
[   33.149211] loop: module loaded
[   33.801621] Adding 4030460k swap on /dev/mapper/sodom-swap_1.  Priority:-1 extents:1 across:4030460k FS
[   34.932831] kjournald starting.  Commit interval 5 seconds
[   34.934073] EXT3-fs (dm-3): using internal journal
[   34.934087] EXT3-fs (dm-3): mounted filesystem with ordered data mode
[   37.506624] atl1c 0000:03:00.0: irq 40 for MSI/MSI-X
[   37.506783] atl1c 0000:03:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   37.815624] RPC: Registered named UNIX socket transport module.
[   37.815637] RPC: Registered udp transport module.
[   37.815644] RPC: Registered tcp transport module.
[   37.815650] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   37.853765] FS-Cache: Loaded
[   37.898674] FS-Cache: Netfs 'nfs' registered for caching
[   38.050597] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  608.014667] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=19848 jiffies, g=1717, c=1716, q=1)
[  608.014701] sending NMI to all CPUs:
[  528.633016] NMI backtrace for cpu 1
[  528.633035] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.10.11pm1 #1
[  528.633326] Hardware name: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
[  528.633669] task: f58d5100 ti: f58da000 task.ti: f58da000
[  528.633907] EIP: 0060:[<c106b8b5>] EFLAGS: 00200246 CPU: 1
[  528.633927] EIP is at cpu_startup_entry+0x105/0x160
[  528.633939] EAX: 00000000 EBX: c14827ec ECX: 00000000 EDX: f58da000
[  528.633951] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: f58dbf8c
[  528.633963]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  528.633975] CR0: 8005003b CR2: b7604000 CR3: 014ea000 CR4: 000007d0
[  528.633987] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  528.633997] DR6: ffff0ff0 DR7: 00000400
[  528.634005] Stack:
[  528.634105]  b0d11cf8 6dcc549c 26cf2573 c1347856 dfd7ffff ff7fffe3 00000000 00000000
[  528.634132]  4248d9c1 26cf2573 01020800 00000000 00000000 00000000 00000000 00000000
[  528.634158]  00000000 0000007b 0000007b 000000d8 000000e0 ffffffff 00000000 00000060
[  528.634185] Call Trace:
[  528.634320]  [<c1347856>] ? start_secondary+0x1e6/0x1ec
[  528.634330] Code: 74 84 e8 ef fb 02 00 fb 89 e0 25 00 e0 ff ff 8b 40 08 a8 08 75 19 89 e2 81 e2 00 e0 ff ff 90 8d b4 26 00 00 00 00 f3 90 8b 42 08 <a8> 08 74 f7 e8 32 fb 02 00 eb 96 e8 1b d9 f9 ff eb b6 e8 34 98
[  608.018015] NMI backtrace for cpu 0
[  608.018031] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.11pm1 #1
[  608.018345] Hardware name: ASUSTeK Computer INC. 1201HA/1201HA, BIOS 0210    11/25/2009
[  608.018561] task: c144e1a0 ti: f5806000 task.ti: c1442000
[  608.018561] EIP: 0060:[<c1021b88>] EFLAGS: 00200006 CPU: 0
[  608.018561] EIP is at arch_trigger_all_cpu_backtrace+0x48/0x70
[  608.018561] EAX: 00000c00 EBX: 00002710 ECX: c1455ba0 EDX: fffff000
[  608.018561] ESI: c145a300 EDI: 00000000 EBP: c145a300 ESP: f5807ea4
[  608.018561]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  608.018561] CR0: 8005003b CR2: b7743000 CR3: 014ea000 CR4: 000007d0
[  608.018561] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  608.018561] DR6: ffff0ff0 DR7: 00000400
[  608.018561] Stack:
[  608.018561]  c13da377 f77dcdc0 c109c7b8 c13e7ee4 00000000 00004d88 000006b5 000006b4
[  608.018561]  00000001 00000001 00000001 00000001 c14827f0 f77dcdc0 c144e1a0 00000000
[  608.018561]  00000000 c1443ebc c103ca66 f77dcc00 907f219e 0000008d c10749dc f77dca50
[  608.018561] Call Trace:
[  608.018561]  [<c109c7b8>] ? rcu_check_callbacks+0x548/0x570
[  608.018561]  [<c103ca66>] ? update_process_times+0x36/0x70
[  608.018561]  [<c10749dc>] ? tick_sched_timer+0x3c/0x80
[  608.018561]  [<c104f397>] ? __remove_hrtimer+0x47/0xa0
[  608.018561]  [<c104f481>] ? __run_hrtimer.isra.29+0x41/0xc0
[  608.018561]  [<c10500c5>] ? hrtimer_interrupt+0x205/0x290
[  608.018561]  [<c1073ab3>] ? tick_do_broadcast.constprop.8+0x63/0x70
[  608.018561]  [<c1073c48>] ? tick_handle_oneshot_broadcast+0x108/0x150
[  608.018561]  [<c122d9d3>] ? credit_entropy_bits.part.10+0xa3/0x140
[  608.018561]  [<c1003aea>] ? timer_interrupt+0xa/0x10
[  608.018561]  [<c10946be>] ? handle_irq_event_percpu+0x2e/0x140
[  608.018561]  [<c102227a>] ? io_apic_modify_irq.isra.13+0x4a/0x60
[  608.018561]  [<c10947fe>] ? handle_irq_event+0x2e/0x50
[  608.018561]  [<c10968e0>] ? handle_simple_irq+0x60/0x60
[  608.018561]  [<c109693a>] ? handle_edge_irq+0x5a/0xe0
[  608.018561]  <IRQ> 
[  608.018561]  [<c10032ae>] ? do_IRQ+0x3e/0xc0
[  608.018561]  [<c1351933>] ? common_interrupt+0x33/0x38
[  608.018561]  [<c10375c1>] ? __do_softirq+0x71/0x160
[  608.018561]  [<c107491a>] ? tick_do_update_jiffies64+0xda/0x130
[  608.018561]  [<c10377d5>] ? irq_exit+0x85/0x90
[  608.018561]  [<c10032b7>] ? do_IRQ+0x47/0xc0
[  608.018561]  [<c10513e4>] ? notifier_call_chain+0x44/0x60
[  608.018561]  [<c1351933>] ? common_interrupt+0x33/0x38
[  608.018561]  [<c106007b>] ? unregister_fair_sched_group+0xb/0xa0
[  608.018561]  [<c125ecd8>] ? cpuidle_enter_state+0x48/0xd0
[  608.018561]  [<c125ede1>] ? cpuidle_idle_call+0x81/0x110
[  608.018561]  [<c10091f5>] ? arch_cpu_idle+0x5/0x20
[  608.018561]  [<c106b839>] ? cpu_startup_entry+0x89/0x160
[  608.018561]  [<c1487a04>] ? start_kernel+0x332/0x338
[  608.018561]  [<c1487513>] ? repair_env_string+0x4d/0x4d
[  608.018561] Code: c1 8b 00 c7 04 24 77 a3 3d c1 a3 e0 26 48 c1 e8 a2 9e 32 00 8b 15 80 5b 45 c1 b8 02 00 00 00 ff 52 7c eb 16 8d b4 26 00 00 00 00 <b8> 58 89 41 00 e8 ae a6 16 00 83 eb 01 74 09 f6 05 e0 26 48 c1

--SUOF0GtieIMvvwua--
