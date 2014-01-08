Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbaAHQIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:08:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59099 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755435AbaAHQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:08:09 -0500
Date: Wed, 8 Jan 2014 11:08:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Excessive WARN()s in Intel 915 driver
In-Reply-To: <CAKMK7uFEzOKYjojVop1ouRsJWyeK-rnKH-udBxZcc9fwKCOV6w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1401081102040.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jan 2014, Daniel Vetter wrote:

> I really want users to report these issues, and excessive WARNs seems
> to be the only way to get those reports. Please boot with
> drm.debug=0xe added to your kernel cmdline and reproduce this issues.
> Also, which precise kernel are you running? Testing latest -rc is
> always recommended, this state checker code is fairly new and gets
> constantly extended and bugs fixed ...

Here you go.  This is the dmesg output after booting with
drm.debug=0xe.  Pay no attention to the "AS" suffix in the version
string; this is pristine 3.13-rc7.

Alan Stern


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0-rc7AS (stern@saphir.localdomain) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #1 SMP PREEMPT Wed Jan 8 10:10:57 EST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e1000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007dd9ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007dda0000-0x000000007ddaefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007ddaf000-0x000000007dddffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007dde0000-0x000000007ddfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7dda0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07DE00000 mask FFFE00000 uncachable
[    0.000000]   2 base 07E000000 mask FFE000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2014MB, range: 2MB, type UC
[    0.000000] reg 2, base: 2016MB, range: 32MB, type UC
[    0.000000] total RAM covered: 2014M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 3  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2014MB, range: 2MB, type UC
[    0.000000] reg 2, base: 2016MB, range: 32MB, type UC
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x013fffff]
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x36400000-0x367fffff]
[    0.000000]  [mem 0x36400000-0x367fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x363fffff]
[    0.000000]  [mem 0x30000000-0x363fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x36800000-0x377fdfff]
[    0.000000]  [mem 0x36800000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x01055000, 0x01055fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x36a6a000-0x3752cfff]
[    0.000000] ACPI: RSDP 000f9180 000024 (v02 110209)
[    0.000000] ACPI: XSDT 7dda0100 00008C (v01 _ASUS_ Notebook 20091102 MSFT 00000097)
[    0.000000] ACPI: FACP 7dda0290 0000F4 (v03 110209 FACP1000 20091102 MSFT 00000097)
[    0.000000] ACPI: DSDT 7dda0680 00CF1B (v01  UL20A UL20A207 00000207 INTL 20051117)
[    0.000000] ACPI: FACS 7ddaf000 000040
[    0.000000] ACPI: APIC 7dda0390 00005C (v01 110209 APIC1000 20091102 MSFT 00000097)
[    0.000000] ACPI: MCFG 7dda0430 00003C (v01 110209 OEMMCFG  20091102 MSFT 00000097)
[    0.000000] ACPI: SLIC 7dda0470 000176 (v01 _ASUS_ Notebook 20091102 MSFT 00000097)
[    0.000000] ACPI: ECDT 7dda0620 000054 (v01 110209 OEMECDT  20091102 MSFT 00000097)
[    0.000000] ACPI: DBGP 7dda03f0 000034 (v01 110209 DBGP1000 20091102 MSFT 00000097)
[    0.000000] ACPI: BOOT 7dda05f0 000028 (v01 110209 BOOT1000 20091102 MSFT 00000097)
[    0.000000] ACPI: OEMB 7ddaf040 000071 (v01 110209 OEMB1000 20091102 MSFT 00000097)
[    0.000000] ACPI: HPET 7ddad5a0 000038 (v01 110209 OEMHPET  20091102 MSFT 00000097)
[    0.000000] ACPI: GSCI 7ddaf0c0 002024 (v01 110209 GMCHSCI  20091102 MSFT 00000097)
[    0.000000] ACPI: DMAR 7ddb10f0 000150 (v01 110209 DMAR1000 20091102 MSFT 00000097)
[    0.000000] ACPI: ATKG 7ddb1440 008024 (v01 _ASUS_  OEMATKG 20091102 MSFT 00000097)
[    0.000000] ACPI: SSDT 7ddb9f10 0004F0 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1125MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x01056000, 0x01056fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7dd9ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7dd9ffff]
[    0.000000] On node 0 totalpages: 515389
[    0.000000] free_area_init_node: node 0, pgdat c0a0c200, node_mem_map f5aaa020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2252 pages used for memmap
[    0.000000]   HighMem zone: 288162 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
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
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e1000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xfed1ffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f77c3000 s30464 r0 d22784 u53248
[    0.000000] pcpu-alloc: s30464 r0 d22784 u53248 alloc=13*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 513613
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/test-3.x root=/dev/sda6 ro drm.debug=0xe acpi_backlight=vendor no_console_suspend rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us vconsole.font=latarcyrheb-sun16 rd.luks=0 LANG=en_US.UTF-8 2
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] allocated 4123896 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0007dda0)
[    0.000000] Memory: 2016628K/2061556K available (4026K kernel code, 319K rwdata, 1868K rodata, 392K init, 5980K bss, 44928K reserved, 1152648K highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0a13000 - 0xc0a75000   ( 392 kB)
      .data : 0xc07eedb5 - 0xc0a12c80   (2191 kB)
      .text : 0xc0400000 - 0xc07eedb5   (4027 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5008000 soft=f500a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1300.034 MHz processor
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 2600.06 BogoMIPS (lpj=5200136)
[    0.004263] pid_max: default: 32768 minimum: 301
[    0.008131] Security Framework initialized
[    0.008264] SELinux:  Initializing.
[    0.008481] SELinux:  Starting in permissive mode
[    0.008515] Mount-cache hash table entries: 512
[    0.010261] Initializing cgroup subsys memory
[    0.010425] Initializing cgroup subsys devices
[    0.010582] Initializing cgroup subsys freezer
[    0.010735] Initializing cgroup subsys blkio
[    0.010865] Initializing cgroup subsys perf_event
[    0.011083] CPU: Physical Processor ID: 0
[    0.011212] CPU: Processor Core ID: 0
[    0.011342] mce: CPU supports 6 MCE banks
[    0.011478] CPU0: Thermal monitoring enabled (TM2)
[    0.011624] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
[    0.012213] Freeing SMP alternatives memory: 12K (c0a75000 - c0a78000)
[    0.012348] ACPI: Core revision 20131115
[    0.037530] ACPI: All ACPI Tables successfully acquired
[    0.040598] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.041314] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.082682] smpboot: CPU0: Genuine Intel(R) CPU           U7300  @ 1.30GHz (fam: 06, model: 17, stepping: 0a)
[    0.084000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.084000] ... version:                2
[    0.084000] ... bit width:              40
[    0.084000] ... generic registers:      2
[    0.084000] ... value mask:             000000ffffffffff
[    0.084000] ... max period:             000000007fffffff
[    0.084000] ... fixed-purpose events:   3
[    0.084000] ... event mask:             0000000700000003
[    0.112484] CPU 1 irqstacks, hard=f50c6000 soft=f50d0000
[    0.112489] x86: Booting SMP configuration:
[    0.008000] Initializing CPU#1
[    0.124450] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.112620] .... node  #0, CPUs:      #1
[    0.124884] x86: Booted up 1 node, 2 CPUs
[    0.125132] smpboot: Total of 2 processors activated (5200.13 BogoMIPS)
[    0.128808] devtmpfs: initialized
[    0.132402] PM: Registering ACPI NVS region [mem 0x7ddaf000-0x7dddffff] (200704 bytes)
[    0.132996] RTC time: 15:45:57, date: 01/08/14
[    0.133524] NET: Registered protocol family 16
[    0.136091] cpuidle: using governor ladder
[    0.136223] cpuidle: using governor menu
[    0.136732] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.136964] ACPI: bus type PCI registered
[    0.137333] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.137544] PCI: not using MMCONFIG
[    0.137932] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
[    0.138065] PCI: Using configuration type 1 for base access
[    0.144460] bio: create slab <bio-0> at 0
[    0.144642] ACPI: Added _OSI(Module Device)
[    0.144642] ACPI: Added _OSI(Processor Device)
[    0.146549] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.146680] ACPI: Added _OSI(Processor Aggregator Device)
[    0.163847] ACPI : EC: EC description table is found, configuring boot EC
[    0.190713] ACPI: Executed 1 blocks of module-level executable AML code
[    0.201882] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.212448] ACPI BIOS Warning (bug): Incorrect checksum in table [ATKG] - 0x1F, should be 0x25 (20131115/tbprint-214)
[    0.213558] ACPI: SSDT 7ddb9540 0001C4 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.217888] ACPI: Dynamic OEM Table Load:
[    0.218110] ACPI: SSDT   (null) 0001C4 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.218822] ACPI: SSDT 7ddb97a0 000765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.223095] ACPI: Dynamic OEM Table Load:
[    0.223318] ACPI: SSDT   (null) 000765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.224462] ACPI: SSDT 7ddb9470 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.228775] ACPI: Dynamic OEM Table Load:
[    0.228998] ACPI: SSDT   (null) 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.229604] ACPI: SSDT 7ddb9710 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.233927] ACPI: Dynamic OEM Table Load:
[    0.234150] ACPI: SSDT   (null) 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.235498] ACPI: Interpreter enabled
[    0.235668] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.235979] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.236338] ACPI: (supports S0 S3 S4 S5)
[    0.236467] ACPI: Using IOAPIC for interrupt routing
[    0.236702] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.244890] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.245102] PCI: Using MMCONFIG for extended config space
[    0.245274] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.246803] ACPI: No dock devices found.
[    0.293206] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.293351] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig Segments MSI]
[    0.293969] acpi PNP0A08:00: PCIe port services disabled; not requesting _OSC control
[    0.295415] PCI host bridge to bus 0000:00
[    0.295551] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.295685] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.295821] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.295957] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.296012] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.296148] pci_bus 0000:00: root bus resource [mem 0x7de00000-0xffffffff]
[    0.296376] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
[    0.296993] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
[    0.297034] pci 0000:00:02.0: reg 0x10: [mem 0xfe400000-0xfe7fffff 64bit]
[    0.297060] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.297079] pci 0000:00:02.0: reg 0x20: [io  0xdc00-0xdc07]
[    0.297634] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
[    0.297669] pci 0000:00:02.1: reg 0x10: [mem 0xfe800000-0xfe8fffff 64bit]
[    0.298218] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.298336] pci 0000:00:1a.0: reg 0x20: [io  0xd880-0xd89f]
[    0.298846] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.299129] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.299248] pci 0000:00:1a.1: reg 0x20: [io  0xd800-0xd81f]
[    0.299700] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.300096] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.300215] pci 0000:00:1a.2: reg 0x20: [io  0xd480-0xd49f]
[    0.300670] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.300976] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.301030] pci 0000:00:1a.7: reg 0x10: [mem 0xfe9fbc00-0xfe9fbfff]
[    0.301261] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.301807] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.302104] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.302152] pci 0000:00:1b.0: reg 0x10: [mem 0xfe9f4000-0xfe9f7fff 64bit]
[    0.302358] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.302655] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.302938] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.303149] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.303587] pci 0000:00:1c.5: [8086:294a] type 01 class 0x060400
[    0.303800] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.304119] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.304405] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.304524] pci 0000:00:1d.0: reg 0x20: [io  0xd400-0xd41f]
[    0.304980] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.305278] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.305397] pci 0000:00:1d.1: reg 0x20: [io  0xd080-0xd09f]
[    0.305859] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.306143] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.306262] pci 0000:00:1d.2: reg 0x20: [io  0xd000-0xd01f]
[    0.306717] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.307020] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.307075] pci 0000:00:1d.7: reg 0x10: [mem 0xfe9fb800-0xfe9fbbff]
[    0.307305] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.307790] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.308085] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.308491] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.308766] pci 0000:00:1f.0: [8086:2917] type 00 class 0x060100
[    0.309395] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
[    0.309454] pci 0000:00:1f.2: reg 0x10: [io  0xcc00-0xcc07]
[    0.309479] pci 0000:00:1f.2: reg 0x14: [io  0xc880-0xc883]
[    0.309504] pci 0000:00:1f.2: reg 0x18: [io  0xc800-0xc807]
[    0.309528] pci 0000:00:1f.2: reg 0x1c: [io  0xc480-0xc483]
[    0.309553] pci 0000:00:1f.2: reg 0x20: [io  0xc400-0xc41f]
[    0.309578] pci 0000:00:1f.2: reg 0x24: [mem 0xfe9fb000-0xfe9fb7ff]
[    0.309725] pci 0000:00:1f.2: PME# supported from D3hot
[    0.310479] pci 0000:01:00.0: [8086:0083] type 00 class 0x028000
[    0.310653] pci 0000:01:00.0: reg 0x10: [mem 0xfeafe000-0xfeafffff 64bit]
[    0.311446] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.311731] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.311877] pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.312159] pci 0000:02:00.0: [1969:1062] type 00 class 0x020000
[    0.312214] pci 0000:02:00.0: reg 0x10: [mem 0xfebc0000-0xfebfffff 64bit]
[    0.312244] pci 0000:02:00.0: reg 0x18: [io  0xec00-0xec7f]
[    0.312480] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.312581] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.312831] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.312970] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.312982] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.313238] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.313398] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.313405] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.313412] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.313419] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.313426] pci 0000:00:1e.0:   bridge window [mem 0x7de00000-0xffffffff] (subtractive decode)
[    0.313521] pci_bus 0000:00: on NUMA node 0
[    0.319042] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
[    0.319893] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 *10 12)
[    0.320613] ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
[    0.321134] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 12)
[    0.321888] ACPI: PCI Interrupt Link [LNKE] (IRQs 6) *0, disabled.
[    0.322502] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 12)
[    0.323303] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 12)
[    0.324127] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 7 10 12)
[    0.327073] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.327312] ACPI: \_SB_.PCI0: notify handler is installed
[    0.327723] Found 1 acpi root devices
[    0.328303] ACPI : EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
[    0.328918] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.328918] vgaarb: loaded
[    0.328918] vgaarb: bridge control possible 0000:00:02.0
[    0.328918] SCSI subsystem initialized
[    0.329126] libata version 3.00 loaded.
[    0.329126] PCI: Using ACPI for IRQ routing
[    0.329126] PCI: pci_cache_line_size set to 64 bytes
[    0.329126] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.329126] e820: reserve RAM buffer [mem 0x7dda0000-0x7fffffff]
[    0.332156] cfg80211: Calling CRDA to update world regulatory domain
[    0.332391] NetLabel: Initializing
[    0.332509] NetLabel:  domain hash size = 128
[    0.332637] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.332852] NetLabel:  unlabeled traffic allowed by default
[    0.333052] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.333052] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.333052] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.336116] Switched to clocksource hpet
[    0.336778] pnp: PnP ACPI init
[    0.336976] ACPI: bus type PNP registered
[    0.337297] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.337484] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.337581] pnp 00:01: [dma 4]
[    0.337672] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.337807] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.337995] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.338240] pnp 00:04: Plug and Play ACPI device, IDs SYN0a06 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    0.338351] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.338471] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.339063] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.339196] system 00:07: [io  0x0800-0x087f] could not be reserved
[    0.339284] system 00:07: [io  0x0400-0x041f] has been reserved
[    0.339420] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.339557] system 00:07: [mem 0xfe9fac00-0xfe9facff window] has been reserved
[    0.339768] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.339906] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.340065] system 00:07: [mem 0xfed45000-0xfed89fff] has been reserved
[    0.340203] system 00:07: [mem 0xfed90000-0xfed90fff] has been reserved
[    0.340341] system 00:07: [mem 0xfed91000-0xfed91fff] has been reserved
[    0.340479] system 00:07: [mem 0xfed92000-0xfed92fff] has been reserved
[    0.340616] system 00:07: [mem 0xfed93000-0xfed93fff] has been reserved
[    0.340754] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.340891] system 00:07: [mem 0xfff00000-0xffffffff] has been reserved
[    0.341034] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.341317] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.341621] system 00:09: [mem 0xffa00000-0xffbfffff] could not be reserved
[    0.341762] system 00:09: [mem 0xffe00000-0xffffffff] could not be reserved
[    0.341904] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.342162] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
[    0.342305] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.342587] system 00:0b: [io  0x0250-0x0253] has been reserved
[    0.342725] system 00:0b: [io  0x0256-0x025f] has been reserved
[    0.342863] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.343000] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.343137] system 00:0b: [mem 0xfec10000-0xfec17fff] has been reserved
[    0.343275] system 00:0b: [mem 0xfec38000-0xfec3ffff] has been reserved
[    0.343416] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.343707] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.343850] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.345070] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.345211] system 00:0d: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.345351] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.345490] system 00:0d: [mem 0x00100000-0x7ddfffff] could not be reserved
[    0.345633] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.346136] pnp: PnP ACPI: found 14 devices
[    0.346266] ACPI: bus type PNP unregistered
[    0.390735] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.390764] pci 0000:00:1c.5: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.390777] pci 0000:00:1c.5: BAR 9: assigned [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.390990] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.391131] pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.391282] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.391416] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.391558] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.391698] pci 0000:00:1c.5:   bridge window [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.391917] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.392093] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.392099] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.392106] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392112] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.392118] pci_bus 0000:00: resource 8 [mem 0x7de00000-0xffffffff]
[    0.392125] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.392131] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.392138] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.392144] pci_bus 0000:02: resource 2 [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.392151] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.392157] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.392163] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392170] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.392176] pci_bus 0000:03: resource 8 [mem 0x7de00000-0xffffffff]
[    0.392273] NET: Registered protocol family 2
[    0.393168] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.393386] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.394720] TCP: Hash tables configured (established 8192 bind 8192)
[    0.394927] TCP: reno registered
[    0.395061] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.395353] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.396043] NET: Registered protocol family 1
[    0.396204] pci 0000:00:02.0: Boot video device
[    0.396522] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.396528] pci 0000:00:1a.0: Performing full reset
[    0.397085] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.397091] pci 0000:00:1a.1: Performing full reset
[    0.397645] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.397651] pci 0000:00:1a.2: Performing full reset
[    0.398777] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.398783] pci 0000:00:1d.0: Performing full reset
[    0.399326] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.399332] pci 0000:00:1d.1: Performing full reset
[    0.399872] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.399878] pci 0000:00:1d.2: Performing full reset
[    0.400771] PCI: CLS 32 bytes, default 64
[    0.401196] Unpacking initramfs...
[    1.027082] Freeing initrd memory: 11020K (f6a6a000 - f752d000)
[    1.049905] DMA-API: preallocated 65536 debug entries
[    1.050044] DMA-API: debugging enabled by kernel config
[    1.050499] Simple Boot Flag at 0x51 set to 0x1
[    1.051905] Scanning for low memory corruption every 60 seconds
[    1.053104] audit: initializing netlink socket (disabled)
[    1.053328] type=2000 audit(1389195958.052:1): initialized
[    1.054378] bounce pool size: 64 pages
[    1.060899] VFS: Disk quotas dquot_6.5.2
[    1.061191] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.063114] fuse init (API version 7.22)
[    1.063587] msgmni has been set to 1709
[    1.064137] SELinux:  Registering netfilter hooks
[    1.066479] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.066718] io scheduler noop registered
[    1.066846] io scheduler deadline registered
[    1.067125] io scheduler cfq registered (default)
[    1.067731] intel_idle: does not run on family 6 model 23
[    1.068833] ACPI: AC Adapter [AC0] (on-line)
[    1.069280] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    1.069569] ACPI: Sleep Button [SLPB]
[    1.069902] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.076541] ACPI: Lid Switch [LID]
[    1.076832] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.077048] ACPI: Power Button [PWRF]
[    1.078329] Monitor-Mwait will be used to enter C-1 state
[    1.078457] Monitor-Mwait will be used to enter C-3 state
[    1.078481] tsc: Marking TSC unstable due to TSC halts in idle
[    1.078706] ACPI: acpi_idle registered with cpuidle
[    1.086098] thermal LNXTHERM:00: registered as thermal_zone0
[    1.086233] ACPI: Thermal Zone [THRM] (46 C)
[    1.086582] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.090381] Non-volatile memory driver v1.3
[    1.090577] Linux agpgart interface v0.103
[    1.091208] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    1.093631] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.095821] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.096600] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.096982] [drm] Initialized drm 1.1.0 20060810
[    1.100932] [drm:i915_dump_device_info], i915 device info: gen=4, pciid=0x2a42 flags=is_mobile,need_gfx_hws,is_g4x,has_fbc,has_pipe_cxsr,has_hotplug,supports_tv,
[    1.101136] [drm:intel_detect_pch], 
[    1.101140] No PCH found?
[    1.101327] [drm] Memory usable by graphics device = 2048M
[    1.101538] [drm:i915_gem_gtt_init], GMADR size = 256M
[    1.101543] [drm:i915_gem_gtt_init], GTT stolen size = 32M
[    1.102803] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7ddaf0e4
[    1.102822] [drm:intel_opregion_setup], Public ACPI methods supported
[    1.102828] [drm:intel_opregion_setup], SWSCI supported
[    1.116421] [drm:swsci_setup], SWSCI BIOS requested (00000241) SBCB callbacks that are not supported (000000c1)
[    1.116474] [drm:swsci_setup], SWSCI GBDA callbacks 000004f3, SBCB callbacks 00000241
[    1.116480] [drm:intel_opregion_setup], ASLE supported
[    1.116766] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.116795] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.116930] [drm] Driver supports precise vblank timestamp query.
[    1.117061] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    1.117069] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT CANTIGA        d
[    1.117076] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 96 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    1.117083] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.117092] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.117097] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 0 71900 1366 1414 1480 1486 768 774 782 806 0x8 0xa
[    1.117106] [drm:parse_lfp_panel_data], VBT initial LVDS value 4200033c
[    1.117112] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    1.117117] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    1.117126] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.117132] [drm:parse_mipi], No MIPI BDB found
[    1.117159] [drm:intel_dsm_pci_probe], 
[    1.117163] no _DSM method for intel device
[    1.117330] [drm:i915_gem_init_stolen], found 33554432 bytes of stolen memory at 7e000000
[    1.117720] [drm:intel_modeset_init], 2 display pipes available.
[    1.117804] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    1.117820] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    1.117826] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
[    1.117842] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.154948] ACPI: Battery Slot [BAT0] (battery present)
[    1.204143] [drm:intel_lvds_init], using preferred mode from EDID: 
[    1.204150] [drm:drm_mode_debug_printmodeline], 
[    1.204157] Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.204296] [drm:intel_lvds_init], detected single-link lvds configuration
[    1.204469] [drm:intel_panel_get_backlight], get backlight PWM = 1398348
[    1.204478] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[    1.204860] [drm:intel_dp_init_connector], Adding DP connector on port D
[    1.204974] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    1.207521] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450064
[    1.207536] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.209912] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450064
[    1.209926] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.210029] [drm:intel_tv_init], Integrated TV is not present.
[    1.210038] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, 7ffff000]
[    1.216839] [drm:init_status_page], render ring hws offset: 0x00001000
[    1.216846] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    1.216855] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[    1.216997] [drm:init_status_page], bsd ring hws offset: 0x00024000
[    1.217004] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    1.217012] [drm:i915_pages_create_for_stolen], offset=0x20000, size=131072
[    1.217079] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
[    1.217118] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
[    1.217141] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
[    1.217150] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
[    1.217160] [drm:intel_modeset_readout_hw_state], [ENCODER:12:DAC-12] hw state readout: enabled, pipe B
[    1.217168] [drm:intel_modeset_readout_hw_state], [ENCODER:13:TMDS-13] hw state readout: disabled, pipe A
[    1.217177] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
[    1.217184] [drm:intel_modeset_readout_hw_state], [CONNECTOR:11:VGA-1] hw state readout: enabled
[    1.217192] [drm:intel_modeset_readout_hw_state], [CONNECTOR:14:DP-1] hw state readout: disabled
[    1.217201] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    1.217207] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.217213] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.217218] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.217226] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.217233] [drm:intel_dump_pipe_config], requested mode:
[    1.217238] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.217246] [drm:intel_dump_pipe_config], adjusted mode:
[    1.217251] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.217259] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
[    1.217266] [drm:intel_dump_pipe_config], port clock: 0
[    1.217271] [drm:intel_dump_pipe_config], pipe src size: 0x0
[    1.217277] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.217284] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.217290] [drm:intel_dump_pipe_config], ips: 0
[    1.217295] [drm:intel_dump_pipe_config], double wide: 0
[    1.217303] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    1.217309] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.217314] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.217319] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.217327] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.217334] [drm:intel_dump_pipe_config], requested mode:
[    1.217339] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.217347] [drm:intel_dump_pipe_config], adjusted mode:
[    1.217352] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.217360] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.217368] [drm:intel_dump_pipe_config], port clock: 72000
[    1.217373] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.217379] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00008000
[    1.217385] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.217392] [drm:intel_dump_pipe_config], ips: 0
[    1.217397] [drm:intel_dump_pipe_config], double wide: 0
[    1.217404] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.217413] [drm:intel_connector_check_state], [CONNECTOR:11:VGA-1]
[    1.217421] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.217428] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.217435] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.217442] [drm:check_crtc_state], [CRTC:3]
[    1.217449] [drm:check_crtc_state], [CRTC:4]
[    1.217488] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    1.217494] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    1.217510] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    1.217516] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.217525] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    1.217530] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    1.232065] [drm:intel_crt_detect], CRT not detected via hotplug
[    1.236059] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    1.236067] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.236073] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    1.236078] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    1.236443] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.236449] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    1.236455] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    1.236461] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    1.236467] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    1.236473] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    1.236480] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    1.236485] [drm:drm_setup_crtcs], 
[    1.236491] [drm:drm_enable_connectors], connector 5 enabled? yes
[    1.236497] [drm:drm_enable_connectors], connector 11 enabled? no
[    1.236502] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.236508] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    1.236513] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    1.236519] [drm:drm_target_preferred], found mode 1366x768
[    1.236524] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.236531] [drm:drm_setup_crtcs], desired mode 1366x768 set on crtc 3
[    1.236541] [drm:i915_gem_object_create_stolen], creating stolen object: size=408000
[    1.236565] [drm:i915_pages_create_for_stolen], offset=0x40000, size=4227072
[    1.238531] [drm:intelfb_create], allocated 1366x768 fb: 0x00046000, bo f531cb00
[    1.239226] fbcon: inteldrmfb (fb0) is primary device
[    1.241255] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.241261] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    1.241265] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    1.241272] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.241279] [drm:drm_mode_debug_printmodeline], Modeline 17:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.241284] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
[    1.241290] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.241295] [drm:intel_modeset_stage_output_state], [CONNECTOR:11:VGA-1] to [CRTC:4]
[    1.241299] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[    1.241305] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    1.241312] [drm:connected_sink_compute_bpp], [CONNECTOR:5:LVDS-1] checking for sink bpp constrains
[    1.241322] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
[    1.241328] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
[    1.241333] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    1.241337] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.241341] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[    1.241347] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.241352] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.241356] [drm:intel_dump_pipe_config], requested mode:
[    1.241363] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.241367] [drm:intel_dump_pipe_config], adjusted mode:
[    1.241374] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.241380] [drm:intel_dump_crtc_timings], crtc timings: 71900 1366 1414 1480 1486 768 774 782 806, type: 0x48 flags: 0xa
[    1.241384] [drm:intel_dump_pipe_config], port clock: 71900
[    1.241388] [drm:intel_dump_pipe_config], pipe src size: 1366x768
[    1.241393] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.241398] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.241402] [drm:intel_dump_pipe_config], ips: 0
[    1.241406] [drm:intel_dump_pipe_config], double wide: 0
[    1.241595] [drm:i9xx_set_pipeconf], disabling CxSR downclocking
[    1.241638] [drm:i9xx_update_plane], Writing base 00046000 00000000 0 0 5504
[    1.241650] [drm:intel_update_fbc], no output, disabling
[    1.241659] [drm:intel_crtc_mode_set], [ENCODER:6:LVDS-6] set [MODE:0:1366x768]
[    1.242546] [drm:g4x_check_srwm], SR watermark: display plane 56, cursor 6
[    1.242553] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=25, cursor=6, B: plane=2, cursor=2, SR: plane=56, cursor=6
[    1.280134] [drm:intel_update_fbc], disabled per chip default
[    1.280147] [drm:intel_panel_enable_backlight], pipe A
[    1.280179] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[    1.280184] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[    1.280252] [drm:i965_irq_handler], pipe B underrun
[    1.280330] [drm:asle_work], No request on ASLC interrupt 0x00000000
[    1.280346] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.280354] [drm:intel_connector_check_state], [CONNECTOR:11:VGA-1]
[    1.280361] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.280367] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.280373] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.280378] [drm:check_crtc_state], [CRTC:3]
[    1.280404] [drm:check_crtc_state], [CRTC:4]
[    1.280430] [drm:intel_pipe_config_compare] *ERROR* mismatch in gmch_pfit.lvds_border_bits (expected 32768, found 0)
[    1.280432] ------------[ cut here ]------------
[    1.280441] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_display.c:9285 check_crtc_state+0x7d4/0x816()
[    1.280443] pipe state doesn't match!
[    1.280446] Modules linked in:
[    1.280451] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7AS #1
[    1.280454] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[    1.280468]  00000000 00000000 f507b830 c07e7bc1 c0961c52 f507b848 c042cb79 c0667cba
[    1.280481]  f5142000 00000000 f6db2380 f507b860 c042cbf4 00000009 f507b858 c0961c52
[    1.280493]  f507b874 f507bad4 c0667cba c0960b41 00002445 c0961c52 0445a186 f507b88c
[    1.280495] Call Trace:
[    1.280503]  [<c07e7bc1>] dump_stack+0x48/0x69
[    1.280511]  [<c042cb79>] warn_slowpath_common+0x5c/0x73
[    1.280517]  [<c0667cba>] ? check_crtc_state+0x7d4/0x816
[    1.280522]  [<c042cbf4>] warn_slowpath_fmt+0x26/0x2a
[    1.280528]  [<c0667cba>] check_crtc_state+0x7d4/0x816
[    1.280540]  [<c06726be>] intel_modeset_check_state+0x305/0x581
[    1.280546]  [<c067295b>] intel_set_mode+0x21/0x2a
[    1.280552]  [<c0672e96>] intel_crtc_set_config+0x532/0x6e5
[    1.280560]  [<c0640437>] drm_mode_set_config_internal+0x39/0x90
[    1.280566]  [<c0634963>] drm_fb_helper_set_par+0x4c/0x88
[    1.280573]  [<c05d838a>] fbcon_init+0x2cd/0x3a9
[    1.280580]  [<c061d8c3>] visual_init+0x9a/0xed
[    1.280587]  [<c061ece9>] do_bind_con_driver+0x142/0x230
[    1.280594]  [<c061eee6>] do_take_over_console+0x10f/0x137
[    1.280599]  [<c05d5168>] do_fbcon_takeover+0x4c/0x8e
[    1.280605]  [<c05d89ba>] fbcon_event_notify+0x26d/0x544
[    1.280612]  [<c0444d77>] ? __blocking_notifier_call_chain+0x1e/0x4a
[    1.280617]  [<c0444c20>] notifier_call_chain+0x25/0x46
[    1.280622]  [<c0444d8b>] __blocking_notifier_call_chain+0x32/0x4a
[    1.280628]  [<c0444daf>] blocking_notifier_call_chain+0xc/0xe
[    1.280634]  [<c05cd919>] fb_notifier_call_chain+0x11/0x13
[    1.280640]  [<c05ce8bf>] register_framebuffer+0x1eb/0x244
[    1.280646]  [<c0634cb2>] drm_fb_helper_initial_config+0x313/0x3a1
[    1.280653]  [<c07ed07c>] ? _raw_spin_unlock_irqrestore+0x33/0x49
[    1.280661]  [<c069c25c>] intel_fbdev_initial_config+0x19/0x1b
[    1.280667]  [<c064b431>] i915_driver_load+0x8f9/0xb15
[    1.280675]  [<c063b8a7>] drm_dev_register+0xdf/0x174
[    1.280681]  [<c063cd4d>] drm_get_pci_dev+0x7c/0xe9
[    1.280686]  [<c0648d2e>] i915_pci_probe+0x5d/0x66
[    1.280692]  [<c05c5769>] pci_device_probe+0x59/0xa2
[    1.280698]  [<c06a1279>] driver_probe_device+0x7f/0x16f
[    1.280704]  [<c06a13ac>] __driver_attach+0x43/0x5f
[    1.280709]  [<c069ff7a>] bus_for_each_dev+0x3e/0x68
[    1.280715]  [<c06a0e73>] driver_attach+0x14/0x16
[    1.280720]  [<c06a1369>] ? driver_probe_device+0x16f/0x16f
[    1.280725]  [<c06a0c0a>] bus_add_driver+0xb7/0x17a
[    1.280731]  [<c06a1843>] driver_register+0x6e/0xa0
[    1.280736]  [<c05c50c1>] __pci_register_driver+0x45/0x48
[    1.280742]  [<c0a3427d>] ? drm_core_init+0xe4/0xe4
[    1.280748]  [<c063ce22>] drm_pci_init+0x68/0xc0
[    1.280753]  [<c0a3427d>] ? drm_core_init+0xe4/0xe4
[    1.280757]  [<c0a342db>] i915_init+0x5e/0x60
[    1.280763]  [<c04003e7>] do_one_initcall+0x79/0x102
[    1.280769]  [<c0440200>] ? param_set_charp+0x7/0xa3
[    1.280775]  [<c0a133b5>] ? loglevel+0x2b/0x2b
[    1.280780]  [<c0440460>] ? parse_args+0x168/0x206
[    1.280786]  [<c0a13ae9>] kernel_init_freeable+0x166/0x1f0
[    1.280793]  [<c07e25d5>] kernel_init+0x8/0xda
[    1.280799]  [<c07edc37>] ret_from_kernel_thread+0x1b/0x28
[    1.280805]  [<c07e25cd>] ? rest_init+0xa1/0xa1
[    1.280874] ---[ end trace c51b5631285aa705 ]---
[    1.280879] [drm:intel_dump_pipe_config], [CRTC:4][hw state] config for pipe B
[    1.280883] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.280887] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.280893] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.280899] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.280903] [drm:intel_dump_pipe_config], requested mode:
[    1.280909] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.280913] [drm:intel_dump_pipe_config], adjusted mode:
[    1.280920] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.280926] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.280930] [drm:intel_dump_pipe_config], port clock: 72000
[    1.280934] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.280940] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00000000
[    1.280945] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.280949] [drm:intel_dump_pipe_config], ips: 0
[    1.280953] [drm:intel_dump_pipe_config], double wide: 0
[    1.280957] [drm:intel_dump_pipe_config], [CRTC:4][sw state] config for pipe B
[    1.280961] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.280965] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.280971] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.280977] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.280981] [drm:intel_dump_pipe_config], requested mode:
[    1.280987] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.280991] [drm:intel_dump_pipe_config], adjusted mode:
[    1.280997] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.281004] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.281008] [drm:intel_dump_pipe_config], port clock: 72000
[    1.281012] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.281017] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00008000
[    1.281022] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.281026] [drm:intel_dump_pipe_config], ips: 0
[    1.281030] [drm:intel_dump_pipe_config], double wide: 0
[    1.281038] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    1.281045] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    1.281050] [drm:intel_modeset_stage_output_state], [CONNECTOR:11:VGA-1] to [NOCRTC]
[    1.281054] [drm:intel_modeset_stage_output_state], encoder changed, full mode switch
[    1.281059] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.281064] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[    1.281070] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[    1.288131] [drm:i9xx_pfit_disable], disabling pfit, current: 0xa0000000
[    1.288141] [drm:g4x_check_srwm], SR watermark: display plane 56, cursor 6
[    1.288148] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=25, cursor=6, B: plane=2, cursor=2, SR: plane=56, cursor=6
[    1.288167] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.288176] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.288182] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.288188] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.288193] [drm:check_crtc_state], [CRTC:3]
[    1.288218] [drm:check_crtc_state], [CRTC:4]
[    1.288266] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.288273] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.288279] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.299618] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.299625] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.299630] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.310832] Console: switching to colour frame buffer device 170x48
[    1.310844] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.310851] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.310856] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.463437] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.466223] i915 0000:00:02.0: registered panic notifier
[    1.469486] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    1.473319] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.476278] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.483293] loop: module loaded
[    1.486382] ACPI Warning: 0x00000828-0x0000082f SystemIO conflicts with Region \PMIO 1 (20131115/utaddress-251)
[    1.489510] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.492678] ACPI Warning: 0x00000530-0x0000053f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[    1.495936] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.499318] ACPI Warning: 0x00000500-0x0000052f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[    1.502751] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.506228] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    1.510056] ahci 0000:00:1f.2: version 3.0
[    1.510528] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.510660] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    1.514233] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
[    1.517840] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    1.523783] scsi0 : ahci
[    1.527952] scsi1 : ahci
[    1.531784] scsi2 : ahci
[    1.535551] scsi3 : ahci
[    1.539154] ata1: SATA max UDMA/133 abar m2048@0xfe9fb000 port 0xfe9fb100 irq 41
[    1.542690] ata2: DUMMY
[    1.546191] ata3: DUMMY
[    1.549662] ata4: DUMMY
[    1.553514] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.561241] i8042: Detected active multiplexing controller, rev 1.1
[    1.567115] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.571211] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.574988] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.578691] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.582361] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.586304] mousedev: PS/2 mouse device common for all mice
[    1.591454] rtc_cmos 00:02: RTC can wake from S4
[    1.595602] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.599206] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.602856] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    1.606594] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0860)
[    1.610907] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.614651] iTCO_vendor_support: vendor-support=0
[    1.618776] asus_laptop: Asus Laptop Support version 0.42
[    1.622839] asus_laptop:   UL20A model detected
[    1.628535] [drm:asle_set_backlight], bclp = 0x800000b3
[    1.628557] [drm:asle_set_backlight], updating opregion backlight 179/255
[    1.628581] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[    1.628587] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[    1.628594] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[    1.628665] [drm:asle_work], No request on ASLC interrupt 0x00000000
[    1.628729] input: Asus Laptop extra buttons as /devices/platform/asus_laptop/input/input5
[    1.633283] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.812982] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.817815] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.822191] TCP: cubic registered
[    1.826174] Initializing XFRM netlink socket
[    1.830123] NET: Registered protocol family 17
[    1.834083] NET: Registered protocol family 15
[    1.838747] Using IPI No-Shortcut mode
[    1.843114] registered taskstats version 1
[    1.848060]   Magic number: 14:395:790
[    1.851828] rtc_cmos 00:02: setting system clock to 2014-01-08 15:45:59 UTC (1389195959)
[    1.857520] PM: Hibernation image not present or could not be loaded.
[    1.876113] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.884866] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.890737] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.890745] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.946240] ata1.00: ATA-8: ST9250315AS, 0002SDM1, max UDMA/133
[    1.949547] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.958223] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.963822] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    1.963830] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.968802] ata1.00: configured for UDMA/133
[    1.973149] scsi 0:0:0:0: Direct-Access     ATA      ST9250315AS      0002 PQ: 0 ANSI: 5
[    1.977417] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.977860] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.983912] sd 0:0:0:0: [sda] Write Protect is off
[    1.989298] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.989435] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.056972]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
[    2.063093] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.066712] Freeing unused kernel memory: 392K (c0a13000 - c0a75000)
[    2.070492] Write protecting the kernel text: 4028k
[    2.074049] Write protecting the kernel read-only data: 1872k
[    2.097273] systemd[1]: systemd 197 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    2.104170] systemd[1]: Running in initial RAM disk.
[    2.120182] systemd[1]: Failed to insert module 'autofs4'
[    2.123936] systemd[1]: No hostname configured.
[    2.127649] systemd[1]: Set hostname to <localhost>.
[    2.131861] random: systemd urandom read with 21 bits of entropy available
[    2.135621] systemd[1]: Initializing machine ID from random generator.
[    2.165749] systemd[1]: Starting Encrypted Volumes.
[    2.173804] systemd[1]: Reached target Encrypted Volumes.
[    2.177713] systemd[1]: Starting udev Kernel Socket.
[    2.185622] systemd[1]: Listening on udev Kernel Socket.
[    2.189484] systemd[1]: Starting udev Control Socket.
[    2.197348] systemd[1]: Listening on udev Control Socket.
[    2.201041] systemd[1]: Starting Journal Socket.
[    2.208931] systemd[1]: Listening on Journal Socket.
[    2.212538] systemd[1]: Starting dracut cmdline hook...
[    2.223093] systemd[1]: Started Load Kernel Modules.
[    2.226769] systemd[1]: Starting Journal Service...
[    2.242671] systemd[1]: Started Journal Service.
[    2.247325] systemd[1]: Starting Sockets.
[    2.254771] systemd[1]: Reached target Sockets.
[    2.258310] systemd[1]: Starting Swap.
[    2.265568] systemd[1]: Reached target Swap.
[    2.269001] systemd[1]: Starting Local File Systems.
[    2.276147] systemd[1]: Reached target Local File Systems.
[    2.479750] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    2.479758] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    2.479763] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    2.520071] systemd-udevd[123]: starting version 197
[    2.728699] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 600854
[    2.773630] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input13
[    3.013971] [drm:i915_gem_open], 
[    3.014272] [drm:intel_crtc_cursor_set], cursor off
[    3.014289] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    3.014299] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.014307] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.014315] [drm:intel_crtc_cursor_set], cursor off
[    3.014321] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.014327] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.014333] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.014395] [drm:i915_gem_open], 
[    3.014435] [drm:intel_crtc_cursor_set], cursor off
[    3.014441] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    3.014449] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.014455] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.014462] [drm:intel_crtc_cursor_set], cursor off
[    3.014468] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.014474] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.014481] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.014531] [drm:i915_gem_open], 
[    3.014818] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    3.014854] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    3.014879] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    3.014894] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    3.014900] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    3.014918] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    3.014924] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    3.014936] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    3.032995] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    3.033010] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    3.033016] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    3.040162] [drm:intel_crt_detect], CRT not detected via hotplug
[    3.044188] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.044197] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.044203] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.044208] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.044563] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.044569] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.044574] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    3.044581] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    3.044599] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    3.044607] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    3.044612] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    3.052080] [drm:intel_crt_detect], CRT not detected via hotplug
[    3.056212] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.056221] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.056227] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.056232] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.056585] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.056590] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.056596] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    3.056602] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    3.056625] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    3.056635] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    3.056640] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    3.056647] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    3.056656] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    3.056662] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    3.056667] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    3.056673] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    3.056932] [drm:drm_mode_addfb], [FB:19]
[    4.376272] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    4.651140] random: nonblocking pool is initialized
[    4.793817] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    5.293382] systemd-journald[64]: Received SIGTERM
[    6.883105] type=1404 audit(1389195964.528:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    7.064375] SELinux: 2048 avtab hash slots, 98400 rules.
[    7.132124] SELinux: 2048 avtab hash slots, 98400 rules.
[    7.468859] SELinux:  9 users, 15 roles, 4414 types, 249 bools, 1 sens, 1024 cats
[    7.468870] SELinux:  83 classes, 98400 rules
[    7.490580] SELinux:  Permission attach_queue in class tun_socket not defined in policy.
[    7.494042] SELinux: the above unknown classes and permissions will be allowed
[    7.497475] SELinux:  Completing initialization.
[    7.497479] SELinux:  Setting up existing superblocks.
[    7.497698] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    7.497880] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    7.498075] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    7.498178] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    7.498572] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.498754] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    7.501038] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    7.501195] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    7.501728] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    7.501887] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    7.502035] SELinux: initialized (dev aio, type aio), not configured for labeling
[    7.502143] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    7.502365] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    7.502525] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    7.502690] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    7.506640] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    7.506690] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.506708] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.506982] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.507180] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507248] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507303] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507491] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507566] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507600] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507629] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507704] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.507851] SELinux: initialized (dev sda6, type ext4), uses xattr
[    7.571818] type=1403 audit(1389195965.216:3): policy loaded auid=4294967295 ses=4294967295
[    7.683987] systemd[1]: Successfully loaded SELinux policy in 872.450ms.
[    8.064065] systemd[1]: Relabelled /dev and /run in 49.308ms.
[   11.770995] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[   11.771002] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   11.771008] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   11.834206] systemd-sysctl[287]: Duplicate assignment of kernel/sysrq in file '/usr/lib/sysctl.d/00-system.conf', ignoring.
[   11.914639] systemd-journald[298]: Vacuuming done, freed 0 bytes
[   11.987499] systemd-udevd[295]: starting version 201
[   12.028464] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   12.044151] EXT4-fs (sda6): re-mounted. Opts: (null)
[   13.774956] ACPI: bus type USB registered
[   13.779451] usbcore: registered new interface driver usbfs
[   13.792630] usbcore: registered new interface driver hub
[   13.803172] usbcore: registered new device driver usb
[   13.849653] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[   13.852889] Copyright(c) 2003-2013 Intel Corporation
[   13.857583] iwlwifi 0000:01:00.0: irq 42 for MSI/MSI-X
[   13.925471] iwlwifi 0000:01:00.0: loaded firmware version 39.31.5.1 build 35138 op_mode iwldvm
[   13.984728] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   13.987773] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   13.991511] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   13.994570] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   13.999863] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   14.027776] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   14.066624] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   14.069784] ehci_hcd: block sizes: qh 80 qtd 96 itd 160 sitd 96
[   14.073694] uhci_hcd: USB Universal Host Controller Interface driver
[   14.079899] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   14.083318] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   14.086487] uhci_hcd 0000:00:1a.0: detected 2 ports
[   14.089673] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   14.089679] uhci_hcd 0000:00:1a.0: Performing full reset
[   14.089701] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   14.089828] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
[   14.093988] usb usb1: default language 0x0409
[   14.094059] usb usb1: udev 1, busnum 1, minor = 0
[   14.094066] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   14.097253] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.100428] usb usb1: Product: UHCI Host Controller
[   14.103557] usb usb1: Manufacturer: Linux 3.13.0-rc7AS uhci_hcd
[   14.106832] usb usb1: SerialNumber: 0000:00:1a.0
[   14.111737] usb usb1: usb_probe_device
[   14.111745] usb usb1: configuration #1 chosen from 1 choice
[   14.112335] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   14.112798] hub 1-0:1.0: usb_probe_interface
[   14.112805] hub 1-0:1.0: usb_probe_interface - got id
[   14.112829] hub 1-0:1.0: USB hub found
[   14.116342] hub 1-0:1.0: 2 ports detected
[   14.119342] hub 1-0:1.0: standalone hub
[   14.119348] hub 1-0:1.0: no power switching (usb 1.0)
[   14.119353] hub 1-0:1.0: individual port over-current protection
[   14.119361] hub 1-0:1.0: power on to power good time: 2ms
[   14.119853] hub 1-0:1.0: local power source is good
[   14.123873] usb usb1: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.123881] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   14.125456] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   14.128452] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[   14.131392] uhci_hcd 0000:00:1a.1: detected 2 ports
[   14.134327] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[   14.134332] uhci_hcd 0000:00:1a.1: Performing full reset
[   14.134354] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[   14.134413] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[   14.137582] usb usb2: default language 0x0409
[   14.137653] usb usb2: udev 1, busnum 2, minor = 128
[   14.137660] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   14.140659] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.140824] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   14.146567] usb usb2: Product: UHCI Host Controller
[   14.149550] usb usb2: Manufacturer: Linux 3.13.0-rc7AS uhci_hcd
[   14.152519] usb usb2: SerialNumber: 0000:00:1a.1
[   14.153842] atl1c 0000:02:00.0: version 1.0.1.1-NAPI
[   14.159885] usb usb2: usb_probe_device
[   14.159893] usb usb2: configuration #1 chosen from 1 choice
[   14.159948] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   14.160633] hub 2-0:1.0: usb_probe_interface
[   14.160640] hub 2-0:1.0: usb_probe_interface - got id
[   14.160652] hub 2-0:1.0: USB hub found
[   14.163616] hub 2-0:1.0: 2 ports detected
[   14.166524] hub 2-0:1.0: standalone hub
[   14.166529] hub 2-0:1.0: no power switching (usb 1.0)
[   14.166535] hub 2-0:1.0: individual port over-current protection
[   14.166542] hub 2-0:1.0: power on to power good time: 2ms
[   14.166596] hub 2-0:1.0: local power source is good
[   14.168644] usb usb2: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.168652] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   14.169679] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   14.172648] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[   14.172722] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   14.176014] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
[   14.191521] uhci_hcd 0000:00:1a.2: detected 2 ports
[   14.194492] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[   14.194498] uhci_hcd 0000:00:1a.2: Performing full reset
[   14.194520] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[   14.194583] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000d480
[   14.197752] usb usb3: default language 0x0409
[   14.197824] usb usb3: udev 1, busnum 3, minor = 256
[   14.197830] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   14.200852] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.203876] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   14.207001] usb usb3: Product: UHCI Host Controller
[   14.210061] usb usb3: Manufacturer: Linux 3.13.0-rc7AS uhci_hcd
[   14.213120] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   14.214046] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
[   14.231066] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.231477] hub 1-0:1.0: hub_suspend
[   14.231624] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.232216] usb usb1: bus auto-suspend, wakeup 1
[   14.232233] usb usb1: suspend_rh
[   14.233872] usb usb3: SerialNumber: 0000:00:1a.2
[   14.242953] usb usb3: usb_probe_device
[   14.242962] usb usb3: configuration #1 chosen from 1 choice
[   14.243024] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   14.243175] hub 3-0:1.0: usb_probe_interface
[   14.243181] hub 3-0:1.0: usb_probe_interface - got id
[   14.243194] hub 3-0:1.0: USB hub found
[   14.246377] hub 3-0:1.0: 2 ports detected
[   14.249472] hub 3-0:1.0: standalone hub
[   14.249478] hub 3-0:1.0: no power switching (usb 1.0)
[   14.249483] hub 3-0:1.0: individual port over-current protection
[   14.249490] hub 3-0:1.0: power on to power good time: 2ms
[   14.249546] hub 3-0:1.0: local power source is good
[   14.251142] usb usb3: usb port2's DeviceRemovable is changed to 1 according to platform information.
[   14.251149] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   14.251761] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   14.254981] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[   14.258183] uhci_hcd 0000:00:1d.0: detected 2 ports
[   14.261358] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   14.261363] uhci_hcd 0000:00:1d.0: Performing full reset
[   14.261385] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   14.261444] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[   14.264803] usb usb4: default language 0x0409
[   14.264875] usb usb4: udev 1, busnum 4, minor = 384
[   14.264881] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   14.267966] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.271141] usb usb4: Product: UHCI Host Controller
[   14.274513] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[   14.274745] hub 2-0:1.0: port 1: status 0101 change 0001
[   14.275391] usb usb4: Manufacturer: Linux 3.13.0-rc7AS uhci_hcd
[   14.278554] usb usb4: SerialNumber: 0000:00:1d.0
[   14.282114] usb usb4: usb_probe_device
[   14.282121] usb usb4: configuration #1 chosen from 1 choice
[   14.282172] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   14.282274] hub 4-0:1.0: usb_probe_interface
[   14.282280] hub 4-0:1.0: usb_probe_interface - got id
[   14.282292] hub 4-0:1.0: USB hub found
[   14.285708] hub 4-0:1.0: 2 ports detected
[   14.288799] hub 4-0:1.0: standalone hub
[   14.288805] hub 4-0:1.0: no power switching (usb 1.0)
[   14.288810] hub 4-0:1.0: individual port over-current protection
[   14.288817] hub 4-0:1.0: power on to power good time: 2ms
[   14.288876] hub 4-0:1.0: local power source is good
[   14.290486] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   14.291225] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   14.294304] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[   14.297433] uhci_hcd 0000:00:1d.1: detected 2 ports
[   14.300561] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   14.300567] uhci_hcd 0000:00:1d.1: Performing full reset
[   14.300589] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   14.300610] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d080
[   14.303950] usb usb5: default language 0x0409
[   14.304057] usb usb5: udev 1, busnum 5, minor = 512
[   14.304064] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   14.307134] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.310380] usb usb5: Product: UHCI Host Controller
[   14.313509] usb usb5: Manufacturer: Linux 3.13.0-rc7AS uhci_hcd
[   14.316654] ehci-pci: EHCI PCI platform driver
[   14.316674] usb usb5: SerialNumber: 0000:00:1d.1
[   14.325058] usb usb5: usb_probe_device
[   14.325067] usb usb5: configuration #1 chosen from 1 choice
[   14.325129] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   14.325236] hub 5-0:1.0: usb_probe_interface
[   14.325242] hub 5-0:1.0: usb_probe_interface - got id
[   14.325255] hub 5-0:1.0: USB hub found
[   14.328387] hub 5-0:1.0: 2 ports detected
[   14.331395] hub 5-0:1.0: standalone hub
[   14.331400] hub 5-0:1.0: no power switching (usb 1.0)
[   14.331405] hub 5-0:1.0: individual port over-current protection
[   14.331412] hub 5-0:1.0: power on to power good time: 2ms
[   14.331468] hub 5-0:1.0: local power source is good
[   14.333332] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   14.334037] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   14.337457] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[   14.340544] uhci_hcd 0000:00:1d.2: detected 2 ports
[   14.343552] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   14.343557] uhci_hcd 0000:00:1d.2: Performing full reset
[   14.343578] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   14.343637] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[   14.347009] usb usb6: default language 0x0409
[   14.347082] usb usb6: udev 1, busnum 6, minor = 640
[   14.347088] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   14.350384] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.350404] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.350538] hub 3-0:1.0: hub_suspend
[   14.350880] usb usb3: bus auto-suspend, wakeup 1
[   14.350885] usb usb3: suspend_rh
[   14.353469] usb usb6: Product: UHCI Host Controller
[   14.356630] usb usb6: Manufacturer: Linux 3.13.0-rc7AS uhci_hcd
[   14.359729] usb usb6: SerialNumber: 0000:00:1d.2
[   14.364182] usb usb6: usb_probe_device
[   14.364191] usb usb6: configuration #1 chosen from 1 choice
[   14.364346] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   14.364456] hub 6-0:1.0: usb_probe_interface
[   14.364462] hub 6-0:1.0: usb_probe_interface - got id
[   14.364475] hub 6-0:1.0: USB hub found
[   14.367645] hub 6-0:1.0: 2 ports detected
[   14.370769] hub 6-0:1.0: standalone hub
[   14.370775] hub 6-0:1.0: no power switching (usb 1.0)
[   14.370780] hub 6-0:1.0: individual port over-current protection
[   14.370787] hub 6-0:1.0: power on to power good time: 2ms
[   14.370950] hub 6-0:1.0: local power source is good
[   14.372120] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
[   14.372589] hub 2-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[   14.374119] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   14.375302] usb usb1: usb auto-resume
[   14.375313] usb usb1: wakeup_rh
[   14.396129] hub 1-0:1.0: hub_resume
[   14.396556] usb usb1: unregistering interface 1-0:1.0
[   14.400014] uhci_hcd 0000:00:1a.0: shutdown urb f49b5f80 ep1in-intr
[   14.403103] usb usb1: usb_disable_device nuking non-ep0 URBs
[   14.404177] usb usb1: bus auto-suspend, wakeup 0
[   14.404185] usb usb1: suspend_rh
[   14.484114] usb 2-1: new full-speed USB device number 2 using uhci_hcd
[   14.734560] usb 2-1: skipped 1 descriptor after configuration
[   14.734570] usb 2-1: skipped 6 descriptors after interface
[   14.734576] usb 2-1: skipped 1 descriptor after endpoint
[   14.734582] usb 2-1: skipped 8 descriptors after interface
[   14.740536] usb 2-1: default language 0x0409
[   14.762545] usb 2-1: udev 2, busnum 2, minor = 129
[   14.762554] usb 2-1: New USB device found, idVendor=04f2, idProduct=b036
[   14.765753] usb 2-1: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[   14.768840] usb 2-1: Product: USB2.0 0.3M UVC WebCam
[   14.771875] usb 2-1: Manufacturer: Chicony Electronics Co., Ltd.
[   14.775023] usb 2-1: SerialNumber: SN0001
[   14.778965] usb 2-1: usb_probe_device
[   14.778974] usb 2-1: configuration #1 chosen from 1 choice
[   14.782562] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[   14.787094] usb 2-1: adding 2-1:1.1 (config #1, interface 1)
[   14.787307] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.787317] usb usb2: unregistering interface 2-0:1.0
[   14.787335] hub 4-0:1.0: hub_suspend
[   14.787374] usb usb4: bus auto-suspend, wakeup 1
[   14.787381] usb usb4: suspend_rh
[   14.787423] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.787444] hub 5-0:1.0: hub_suspend
[   14.787475] usb usb5: bus auto-suspend, wakeup 1
[   14.787481] usb usb5: suspend_rh
[   14.787532] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.787552] hub 6-0:1.0: hub_suspend
[   14.787582] usb usb6: bus auto-suspend, wakeup 1
[   14.787588] usb usb6: suspend_rh
[   14.787915] uhci_hcd 0000:00:1a.1: shutdown urb f490f200 ep1in-intr
[   14.787958] usb 2-1: USB disconnect, device number 2
[   14.790980] usb 2-1: unregistering device
[   14.790987] usb 2-1: unregistering interface 2-1:1.0
[   14.793437] usb 2-1: unregistering interface 2-1:1.1
[   14.793739] usb 2-1: usb_disable_device nuking all URBs
[   14.801103] usb usb2: usb_disable_device nuking non-ep0 URBs
[   14.801385] usb usb2: bus auto-suspend, wakeup 0
[   14.801392] usb usb2: suspend_rh
[   14.801423] usb usb3: usb auto-resume
[   14.801434] usb usb3: wakeup_rh
[   14.824448] hub 3-0:1.0: hub_resume
[   14.825057] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.825079] usb usb3: unregistering interface 3-0:1.0
[   14.825664] uhci_hcd 0000:00:1a.2: shutdown urb f48cc480 ep1in-intr
[   14.826042] usb usb3: usb_disable_device nuking non-ep0 URBs
[   14.826320] usb usb3: bus auto-suspend, wakeup 0
[   14.826327] usb usb3: suspend_rh
[   14.826369] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   14.830298] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 7
[   14.833399] ehci-pci 0000:00:1a.7: debug port 1
[   14.836382] ehci-pci 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   14.836391] ehci-pci 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   14.836609] ehci-pci 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   14.840497] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
[   14.840504] ehci-pci 0000:00:1a.7: supports USB remote wakeup
[   14.840536] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfe9fbc00
[   14.843451] ehci-pci 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   14.852073] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   14.855504] usb usb7: default language 0x0409
[   14.855582] usb usb7: udev 1, busnum 7, minor = 768
[   14.855589] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[   14.858587] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.861587] usb usb7: Product: EHCI Host Controller
[   14.864531] usb usb7: Manufacturer: Linux 3.13.0-rc7AS ehci_hcd
[   14.867537] usb usb7: SerialNumber: 0000:00:1a.7
[   14.872182] usb usb7: usb_probe_device
[   14.872190] usb usb7: configuration #1 chosen from 1 choice
[   14.872511] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   14.873004] hub 7-0:1.0: usb_probe_interface
[   14.873010] hub 7-0:1.0: usb_probe_interface - got id
[   14.873036] hub 7-0:1.0: USB hub found
[   14.876349] hub 7-0:1.0: 6 ports detected
[   14.879183] hub 7-0:1.0: standalone hub
[   14.879188] hub 7-0:1.0: no power switching (usb 1.0)
[   14.879193] hub 7-0:1.0: individual port over-current protection
[   14.879201] hub 7-0:1.0: power on to power good time: 20ms
[   14.879536] hub 7-0:1.0: local power source is good
[   14.885456] usb usb7: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.885464] usb usb7: usb port3's DeviceRemovable is changed to 1 according to platform information.
[   14.885470] usb usb7: usb port6's DeviceRemovable is changed to 1 according to platform information.
[   14.885476] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   14.886320] ehci-pci 0000:00:1a.7: HS companion for 0000:00:1a.0
[   14.886333] usb usb1: usb auto-resume
[   14.886339] usb usb1: wakeup_rh
[   14.912163] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   14.912302] hub 1-0:1.0: usb_probe_interface
[   14.912308] hub 1-0:1.0: usb_probe_interface - got id
[   14.912321] hub 1-0:1.0: USB hub found
[   14.915160] hub 1-0:1.0: 2 ports detected
[   14.917988] hub 1-0:1.0: standalone hub
[   14.917994] hub 1-0:1.0: no power switching (usb 1.0)
[   14.917999] hub 1-0:1.0: individual port over-current protection
[   14.918006] hub 1-0:1.0: power on to power good time: 2ms
[   14.918366] hub 1-0:1.0: local power source is good
[   14.920684] usb usb1: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.920691] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   14.921300] ehci-pci 0000:00:1a.7: HS companion for 0000:00:1a.1
[   14.921313] usb usb2: usb auto-resume
[   14.921319] usb usb2: wakeup_rh
[   14.948417] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   14.948672] hub 2-0:1.0: usb_probe_interface
[   14.948679] hub 2-0:1.0: usb_probe_interface - got id
[   14.948691] hub 2-0:1.0: USB hub found
[   14.951597] hub 2-0:1.0: 2 ports detected
[   14.954458] hub 2-0:1.0: standalone hub
[   14.954465] hub 2-0:1.0: no power switching (usb 1.0)
[   14.954470] hub 2-0:1.0: individual port over-current protection
[   14.954477] hub 2-0:1.0: power on to power good time: 2ms
[   14.954659] hub 2-0:1.0: local power source is good
[   14.956839] usb usb2: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.956846] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   14.957251] ehci-pci 0000:00:1a.7: HS companion for 0000:00:1a.2
[   14.957264] usb usb3: usb auto-resume
[   14.957270] usb usb3: wakeup_rh
[   14.980148] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   14.980440] hub 3-0:1.0: usb_probe_interface
[   14.980447] hub 3-0:1.0: usb_probe_interface - got id
[   14.980458] hub 3-0:1.0: USB hub found
[   14.983210] hub 3-0:1.0: 2 ports detected
[   14.986074] hub 3-0:1.0: standalone hub
[   14.986079] hub 3-0:1.0: no power switching (usb 1.0)
[   14.986085] hub 3-0:1.0: individual port over-current protection
[   14.986092] hub 3-0:1.0: power on to power good time: 2ms
[   14.986497] hub 3-0:1.0: local power source is good
[   14.988143] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[   14.988178] hub 7-0:1.0: port 3: status 0501 change 0001
[   14.996767] usb usb3: usb port2's DeviceRemovable is changed to 1 according to platform information.
[   14.996774] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   14.998799] usb usb4: usb auto-resume
[   14.998806] usb usb4: wakeup_rh
[   15.020093] hub 4-0:1.0: hub_resume
[   15.020159] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.020170] usb usb4: unregistering interface 4-0:1.0
[   15.020181] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.020196] hub 1-0:1.0: hub_suspend
[   15.020228] usb usb1: bus auto-suspend, wakeup 1
[   15.020235] usb usb1: suspend_rh
[   15.020418] uhci_hcd 0000:00:1d.0: shutdown urb f48cc100 ep1in-intr
[   15.020715] usb usb4: usb_disable_device nuking non-ep0 URBs
[   15.020753] usb usb4: bus auto-suspend, wakeup 0
[   15.020760] usb usb4: suspend_rh
[   15.020788] usb usb5: usb auto-resume
[   15.020794] usb usb5: wakeup_rh
[   15.044054] hub 5-0:1.0: hub_resume
[   15.044135] usb usb5: unregistering interface 5-0:1.0
[   15.044380] uhci_hcd 0000:00:1d.1: shutdown urb f4824e00 ep1in-intr
[   15.044709] usb usb5: usb_disable_device nuking non-ep0 URBs
[   15.044747] usb usb5: bus auto-suspend, wakeup 0
[   15.044754] usb usb5: suspend_rh
[   15.044782] usb usb6: usb auto-resume
[   15.044788] usb usb6: wakeup_rh
[   15.056073] uhci_hcd 0000:00:1a.1: port 1 portsc 008a,00
[   15.068084] hub 6-0:1.0: hub_resume
[   15.068162] usb usb6: unregistering interface 6-0:1.0
[   15.068726] uhci_hcd 0000:00:1d.2: shutdown urb f4976600 ep1in-intr
[   15.069805] usb usb6: usb_disable_device nuking non-ep0 URBs
[   15.069968] usb usb6: bus auto-suspend, wakeup 0
[   15.069975] usb usb6: suspend_rh
[   15.070007] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   15.072964] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 8
[   15.075722] ehci-pci 0000:00:1d.7: debug port 1
[   15.079700] ehci-pci 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   15.079711] ehci-pci 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   15.079806] ehci-pci 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   15.083714] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[   15.083720] ehci-pci 0000:00:1d.7: supports USB remote wakeup
[   15.083743] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfe9fb800
[   15.086449] ehci-pci 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   15.097049] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   15.100375] usb usb8: default language 0x0409
[   15.100455] usb usb8: udev 1, busnum 8, minor = 896
[   15.100462] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[   15.103169] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.105905] usb usb8: Product: EHCI Host Controller
[   15.108622] usb usb8: Manufacturer: Linux 3.13.0-rc7AS ehci_hcd
[   15.111325] usb usb8: SerialNumber: 0000:00:1d.7
[   15.114690] usb usb8: usb_probe_device
[   15.114698] usb usb8: configuration #1 chosen from 1 choice
[   15.114951] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[   15.115225] hub 8-0:1.0: usb_probe_interface
[   15.115232] hub 8-0:1.0: usb_probe_interface - got id
[   15.115246] hub 8-0:1.0: USB hub found
[   15.118120] hub 8-0:1.0: 6 ports detected
[   15.120794] hub 8-0:1.0: standalone hub
[   15.120799] hub 8-0:1.0: no power switching (usb 1.0)
[   15.120805] hub 8-0:1.0: individual port over-current protection
[   15.120812] hub 8-0:1.0: power on to power good time: 20ms
[   15.120995] hub 8-0:1.0: local power source is good
[   15.127255] hub 8-0:1.0: trying to enable port power on non-switchable hub
[   15.127883] ehci-pci 0000:00:1d.7: HS companion for 0000:00:1d.0
[   15.127895] usb usb4: usb auto-resume
[   15.127902] usb usb4: wakeup_rh
[   15.148136] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   15.148382] hub 4-0:1.0: usb_probe_interface
[   15.148389] hub 4-0:1.0: usb_probe_interface - got id
[   15.148401] hub 4-0:1.0: USB hub found
[   15.151079] hub 4-0:1.0: 2 ports detected
[   15.153710] hub 4-0:1.0: standalone hub
[   15.153716] hub 4-0:1.0: no power switching (usb 1.0)
[   15.153721] hub 4-0:1.0: individual port over-current protection
[   15.153728] hub 4-0:1.0: power on to power good time: 2ms
[   15.153917] hub 4-0:1.0: local power source is good
[   15.155428] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   15.155713] ehci-pci 0000:00:1d.7: HS companion for 0000:00:1d.1
[   15.155724] hub 7-0:1.0: state 7 ports 6 chg 0008 evt 0000
[   15.155727] usb usb5: usb auto-resume
[   15.155732] usb usb5: wakeup_rh
[   15.156070] hub 7-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[   15.176180] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   15.176296] hub 5-0:1.0: usb_probe_interface
[   15.176302] hub 5-0:1.0: usb_probe_interface - got id
[   15.176314] hub 5-0:1.0: USB hub found
[   15.180314] hub 5-0:1.0: 2 ports detected
[   15.183117] hub 5-0:1.0: standalone hub
[   15.183124] hub 5-0:1.0: no power switching (usb 1.0)
[   15.183129] hub 5-0:1.0: individual port over-current protection
[   15.183136] hub 5-0:1.0: power on to power good time: 2ms
[   15.183194] hub 5-0:1.0: local power source is good
[   15.185836] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   15.186943] ehci-pci 0000:00:1d.7: HS companion for 0000:00:1d.2
[   15.186956] usb usb6: usb auto-resume
[   15.186963] usb usb6: wakeup_rh
[   15.208374] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   15.208498] hub 6-0:1.0: usb_probe_interface
[   15.208505] hub 6-0:1.0: usb_probe_interface - got id
[   15.208516] hub 6-0:1.0: USB hub found
[   15.211210] hub 6-0:1.0: 2 ports detected
[   15.213744] hub 6-0:1.0: standalone hub
[   15.213749] hub 6-0:1.0: no power switching (usb 1.0)
[   15.213754] hub 6-0:1.0: individual port over-current protection
[   15.213761] hub 6-0:1.0: power on to power good time: 2ms
[   15.213940] hub 6-0:1.0: local power source is good
[   15.215873] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   15.216350] ehci-pci 0000:00:1a.7: port 3 reset complete, port enabled
[   15.216362] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   15.272199] usb 7-3: new high-speed USB device number 2 using ehci-pci
[   15.380350] ehci-pci 0000:00:1a.7: port 3 reset complete, port enabled
[   15.380363] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   15.500536] usb 7-3: skipped 1 descriptor after configuration
[   15.500544] usb 7-3: skipped 6 descriptors after interface
[   15.500551] usb 7-3: skipped 1 descriptor after endpoint
[   15.500556] usb 7-3: skipped 8 descriptors after interface
[   15.501271] usb 7-3: default language 0x0409
[   15.507268] usb 7-3: udev 2, busnum 7, minor = 769
[   15.507276] usb 7-3: New USB device found, idVendor=04f2, idProduct=b036
[   15.510010] usb 7-3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[   15.512661] usb 7-3: Product: USB2.0 0.3M UVC WebCam
[   15.516836] usb 7-3: Manufacturer: Chicony Electronics Co., Ltd.
[   15.519472] usb 7-3: SerialNumber: SN0001
[   15.522759] usb 7-3: usb_probe_device
[   15.522767] usb 7-3: configuration #1 chosen from 1 choice
[   15.523165] usb 7-3: adding 7-3:1.0 (config #1, interface 0)
[   15.525511] usb 7-3: adding 7-3:1.1 (config #1, interface 1)
[   15.525720] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.525747] hub 3-0:1.0: hub_suspend
[   15.525784] usb usb3: bus auto-suspend, wakeup 1
[   15.525791] usb usb3: suspend_rh
[   15.525833] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.525854] hub 2-0:1.0: hub_suspend
[   15.525884] usb usb2: bus auto-suspend, wakeup 1
[   15.525890] usb usb2: suspend_rh
[   15.525932] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   15.525952] hub 8-0:1.0: hub_suspend
[   15.525982] usb usb8: bus auto-suspend, wakeup 1
[   15.525988] ehci-pci 0000:00:1d.7: suspend root hub
[   15.526078] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.526098] hub 4-0:1.0: hub_suspend
[   15.526128] usb usb4: bus auto-suspend, wakeup 1
[   15.526134] usb usb4: suspend_rh
[   15.526174] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.526194] hub 5-0:1.0: hub_suspend
[   15.526223] usb usb5: bus auto-suspend, wakeup 1
[   15.526229] usb usb5: suspend_rh
[   15.526269] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.526289] hub 6-0:1.0: hub_suspend
[   15.526319] usb usb6: bus auto-suspend, wakeup 1
[   15.526325] usb usb6: suspend_rh
[   16.050303] Adding 8389624k swap on /dev/sda7.  Priority:-1 extents:1 across:8389624k 
[   16.246807] SELinux: initialized (dev sda1, type vfat), uses genfs_contexts
[   16.390038] SELinux: initialized (dev sda5, type vfat), uses genfs_contexts
[   17.175963] EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
[   17.179267] SELinux: initialized (dev sda8, type ext4), uses xattr
[   17.694097] systemd-journald[298]: Received request to flush runtime journal from PID 1
[   22.412016] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   22.419611] iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
[   22.490787] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   22.503096] iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
[   22.505305] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[   22.512307] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[   22.512723] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[   22.513095] uhci_hcd 0000:00:1a.1: hcd_pci_runtime_suspend: 0
[   22.513433] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[   22.513799] uhci_hcd 0000:00:1a.2: hcd_pci_runtime_suspend: 0
[   22.514282] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[   22.514650] uhci_hcd 0000:00:1d.0: hcd_pci_runtime_suspend: 0
[   22.514981] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[   22.515347] uhci_hcd 0000:00:1d.1: hcd_pci_runtime_suspend: 0
[   22.515677] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[   22.523715] uhci_hcd 0000:00:1d.2: hcd_pci_runtime_suspend: 0
[   22.525067] ehci-pci 0000:00:1d.7: hcd_pci_runtime_suspend: 0
[   22.647745] atl1c 0000:02:00.0: irq 43 for MSI/MSI-X
[   22.817651] [drm:intel_crtc_cursor_set], cursor off
[   22.817662] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[   22.817673] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   22.817680] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   22.817688] [drm:intel_crtc_cursor_set], cursor off
[   22.817695] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[   22.817701] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   22.817707] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   24.290028] wlan0: authenticate with 00:24:36:a6:21:91
[   24.310492] wlan0: send auth to 00:24:36:a6:21:91 (try 1/3)
[   24.315956] wlan0: authenticated
[   24.324517] wlan0: associate with 00:24:36:a6:21:91 (try 1/3)
[   24.336898] wlan0: RX AssocResp from 00:24:36:a6:21:91 (capab=0x1431 status=0 aid=13)
[   24.383120] wlan0: associated
[  601.053058] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
[  601.053084] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  601.054092] [drm:asle_work], No request on ASLC interrupt 0x00000000
[  601.324169] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=2, cursor=2, SR: plane=0, cursor=0
[  601.324182] [drm:intel_update_fbc], no output, disabling
[  601.324200] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[  601.324208] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[  601.324216] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[  601.324224] [drm:check_crtc_state], [CRTC:3]
[  601.324233] [drm:check_crtc_state], [CRTC:4]
[  601.324473] [drm:intel_panel_update_status], updating intel_backlight, brightness=1398348/1992060
[  601.324514] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  601.325511] [drm:asle_set_backlight], bclp = 0x800000b3
[  601.325519] [drm:asle_set_backlight], updating opregion backlight 179/255
[  601.325528] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  715.020721] [drm:g4x_check_srwm], SR watermark: display plane 56, cursor 6
[  715.020731] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=25, cursor=6, B: plane=2, cursor=2, SR: plane=56, cursor=6
[  715.060163] [drm:intel_update_fbc], disabled per chip default
[  715.068160] [drm:intel_panel_enable_backlight], pipe A
[  715.068171] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[  715.068180] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  715.068218] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[  715.068231] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[  715.068240] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[  715.068248] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[  715.068255] [drm:check_crtc_state], [CRTC:3]
[  715.068290] [drm:check_crtc_state], [CRTC:4]
[  715.068302] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[  715.068312] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[  715.068320] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[  715.068328] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[  715.068335] [drm:check_crtc_state], [CRTC:3]
[  715.068365] [drm:check_crtc_state], [CRTC:4]
[  715.068385] [drm:intel_panel_update_status], updating intel_backlight, brightness=1398348/1992060
[  715.068395] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  715.068399] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[  715.068407] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  715.069333] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[  715.069344] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[  715.069352] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[  715.086940] [drm:asle_set_backlight], bclp = 0x800000b3
[  715.086953] [drm:asle_set_backlight], updating opregion backlight 179/255
[  715.086966] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  715.086974] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[  715.086985] [drm:intel_panel_get_max_backlight], max backlight PWM = 1992060
[  715.087020] [drm:asle_work], No request on ASLC interrupt 0x00000000
[  729.943162] type=1006 audit(1389196687.587:4): pid=543 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1 res=1

