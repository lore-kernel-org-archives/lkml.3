Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbaAHXPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:15:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59329 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757355AbaAHXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:15:31 -0500
Date: Wed, 8 Jan 2014 18:15:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel@ffwll.ch>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Excessive WARN()s in Intel 915 driver
In-Reply-To: <20140108202108.GV4770@phenom.ffwll.local>
Message-ID: <Pine.LNX.4.44L0.1401081812560.1659-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014, Daniel Vetter wrote:

> > > That's strange, I've thought we've fixed the last struggling mismatch in
> > > the lvds borber bits stuff. Can you please try latest drm-intel-nightly
> > > from
> > > 
> > > http://cgit.freedesktop.org/~danvet/drm-intel/
> > 
> > I prefer not to clone 1.7 GB of git data if at all possible.  Can you
> > post (or send to me directly) a patch containing the differences with
> > respect to 3.13-rc7?  It should end up being fairly small.
> 
> Shallow clones should reduce the data tremendously, see git help clone.

Here is the result.  This includes a warning about the backlight state 
(which I used to get but haven't seen in some time) as well as the pipe 
state mismatch.

Alan Stern


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0-rc3AS+ (stern@saphir.localdomain) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #1 SMP PREEMPT Wed Jan 8 17:25:09 EST 2014
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
[    0.000000] BRK [0x0105b000, 0x0105bfff] PGTABLE
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
[    0.000000] BRK [0x0105c000, 0x0105cfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7dd9ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7dd9ffff]
[    0.000000] On node 0 totalpages: 515389
[    0.000000] free_area_init_node: node 0, pgdat c0a12280, node_mem_map f5aaa020
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
[    0.000000] Memory: 2016604K/2061556K available (4031K kernel code, 319K rwdata, 1884K rodata, 392K init, 5980K bss, 44952K reserved, 1152648K highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0a19000 - 0xc0a7b000   ( 392 kB)
      .data : 0xc07f02b5 - 0xc0a18d00   (2210 kB)
      .text : 0xc0400000 - 0xc07f02b5   (4032 kB)
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
[    0.000000] tsc: Detected 1299.930 MHz processor
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 2599.86 BogoMIPS (lpj=5199720)
[    0.004264] pid_max: default: 32768 minimum: 301
[    0.004546] Security Framework initialized
[    0.008013] SELinux:  Initializing.
[    0.008229] SELinux:  Starting in permissive mode
[    0.008264] Mount-cache hash table entries: 512
[    0.009985] Initializing cgroup subsys memory
[    0.010150] Initializing cgroup subsys devices
[    0.010306] Initializing cgroup subsys freezer
[    0.010459] Initializing cgroup subsys blkio
[    0.010590] Initializing cgroup subsys perf_event
[    0.010807] CPU: Physical Processor ID: 0
[    0.010935] CPU: Processor Core ID: 0
[    0.011065] mce: CPU supports 6 MCE banks
[    0.011200] CPU0: Thermal monitoring enabled (TM2)
[    0.011346] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
[    0.011899] Freeing SMP alternatives memory: 12K (c0a7b000 - c0a7e000)
[    0.012012] ACPI: Core revision 20131115
[    0.037071] ACPI: All ACPI Tables successfully acquired
[    0.040592] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.041307] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.082201] smpboot: CPU0: Genuine Intel(R) CPU           U7300  @ 1.30GHz (fam: 06, model: 17, stepping: 0a)
[    0.084000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.084000] ... version:                2
[    0.084000] ... bit width:              40
[    0.084000] ... generic registers:      2
[    0.084000] ... value mask:             000000ffffffffff
[    0.084000] ... max period:             000000007fffffff
[    0.084000] ... fixed-purpose events:   3
[    0.084000] ... event mask:             0000000700000003
[    0.112479] CPU 1 irqstacks, hard=f50c6000 soft=f50d0000
[    0.112484] x86: Booting SMP configuration:
[    0.008000] Initializing CPU#1
[    0.124447] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.112615] .... node  #0, CPUs:      #1
[    0.124878] x86: Booted up 1 node, 2 CPUs
[    0.125126] smpboot: Total of 2 processors activated (5199.72 BogoMIPS)
[    0.128903] devtmpfs: initialized
[    0.133204] PM: Registering ACPI NVS region [mem 0x7ddaf000-0x7dddffff] (200704 bytes)
[    0.133204] RTC time: 22:59:10, date: 01/08/14
[    0.133503] NET: Registered protocol family 16
[    0.136160] cpuidle: using governor ladder
[    0.136291] cpuidle: using governor menu
[    0.136804] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.137034] ACPI: bus type PCI registered
[    0.137400] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.137612] PCI: not using MMCONFIG
[    0.138002] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
[    0.138134] PCI: Using configuration type 1 for base access
[    0.144420] bio: create slab <bio-0> at 0
[    0.144638] ACPI: Added _OSI(Module Device)
[    0.144638] ACPI: Added _OSI(Processor Device)
[    0.146532] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.146663] ACPI: Added _OSI(Processor Aggregator Device)
[    0.163837] ACPI : EC: EC description table is found, configuring boot EC
[    0.189249] ACPI: Executed 1 blocks of module-level executable AML code
[    0.200384] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.212454] ACPI BIOS Warning (bug): Incorrect checksum in table 
[ATKG] - 0x1F, should be 0x25 (20131115/tbprint-214)
[    0.213553] ACPI: SSDT 7ddb9540 0001C4 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.217843] ACPI: Dynamic OEM Table Load:
[    0.218066] ACPI: SSDT   (null) 0001C4 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.218772] ACPI: SSDT 7ddb97a0 000765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.223035] ACPI: Dynamic OEM Table Load:
[    0.223258] ACPI: SSDT   (null) 000765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.224394] ACPI: SSDT 7ddb9470 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.228658] ACPI: Dynamic OEM Table Load:
[    0.228881] ACPI: SSDT   (null) 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.229484] ACPI: SSDT 7ddb9710 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.233771] ACPI: Dynamic OEM Table Load:
[    0.233993] ACPI: SSDT   (null) 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.235346] ACPI: Interpreter enabled
[    0.235515] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.235823] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.236211] ACPI: (supports S0 S3 S4 S5)
[    0.236341] ACPI: Using IOAPIC for interrupt routing
[    0.236576] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.244655] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.244864] PCI: Using MMCONFIG for extended config space
[    0.245036] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.247207] ACPI: No dock devices found.
[    0.293517] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.293661] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig Segments MSI]
[    0.294292] acpi PNP0A08:00: PCIe port services disabled; not requesting _OSC control
[    0.295726] PCI host bridge to bus 0000:00
[    0.295861] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.295994] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.296012] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.296147] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.296282] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.296418] pci_bus 0000:00: root bus resource [mem 0x7de00000-0xffffffff]
[    0.296644] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
[    0.297255] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
[    0.297296] pci 0000:00:02.0: reg 0x10: [mem 0xfe400000-0xfe7fffff 64bit]
[    0.297322] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.297341] pci 0000:00:02.0: reg 0x20: [io  0xdc00-0xdc07]
[    0.297788] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
[    0.297823] pci 0000:00:02.1: reg 0x10: [mem 0xfe800000-0xfe8fffff 64bit]
[    0.298375] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.298494] pci 0000:00:1a.0: reg 0x20: [io  0xd880-0xd89f]
[    0.298997] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.299380] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.299499] pci 0000:00:1a.1: reg 0x20: [io  0xd800-0xd81f]
[    0.300095] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.300381] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.300500] pci 0000:00:1a.2: reg 0x20: [io  0xd480-0xd49f]
[    0.300947] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.301256] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.301311] pci 0000:00:1a.7: reg 0x10: [mem 0xfe9fbc00-0xfe9fbfff]
[    0.301541] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.302076] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.302373] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.302420] pci 0000:00:1b.0: reg 0x10: [mem 0xfe9f4000-0xfe9f7fff 64bit]
[    0.302626] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.302922] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.303205] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.303417] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.303851] pci 0000:00:1c.5: [8086:294a] type 01 class 0x060400
[    0.304078] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.304372] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.304662] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.304781] pci 0000:00:1d.0: reg 0x20: [io  0xd400-0xd41f]
[    0.305229] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.305530] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.305649] pci 0000:00:1d.1: reg 0x20: [io  0xd080-0xd09f]
[    0.306107] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.306393] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.306512] pci 0000:00:1d.2: reg 0x20: [io  0xd000-0xd01f]
[    0.306958] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.307265] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.307319] pci 0000:00:1d.7: reg 0x10: [mem 0xfe9fb800-0xfe9fbbff]
[    0.307550] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.308059] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.308340] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.308746] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.309031] pci 0000:00:1f.0: [8086:2917] type 00 class 0x060100
[    0.309660] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
[    0.309718] pci 0000:00:1f.2: reg 0x10: [io  0xcc00-0xcc07]
[    0.309744] pci 0000:00:1f.2: reg 0x14: [io  0xc880-0xc883]
[    0.309768] pci 0000:00:1f.2: reg 0x18: [io  0xc800-0xc807]
[    0.309793] pci 0000:00:1f.2: reg 0x1c: [io  0xc480-0xc483]
[    0.309818] pci 0000:00:1f.2: reg 0x20: [io  0xc400-0xc41f]
[    0.309843] pci 0000:00:1f.2: reg 0x24: [mem 0xfe9fb000-0xfe9fb7ff]
[    0.309989] pci 0000:00:1f.2: PME# supported from D3hot
[    0.310735] pci 0000:01:00.0: [8086:0083] type 00 class 0x028000
[    0.310912] pci 0000:01:00.0: reg 0x10: [mem 0xfeafe000-0xfeafffff 64bit]
[    0.311711] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.311991] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.312022] pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.312279] pci 0000:02:00.0: [1969:1062] type 00 class 0x020000
[    0.312334] pci 0000:02:00.0: reg 0x10: [mem 0xfebc0000-0xfebfffff 64bit]
[    0.312364] pci 0000:02:00.0: reg 0x18: [io  0xec00-0xec7f]
[    0.312600] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.312697] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.312955] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.313095] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.313107] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.313365] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.313524] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.313532] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.313539] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.313545] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.313552] pci 0000:00:1e.0:   bridge window [mem 0x7de00000-0xffffffff] (subtractive decode)
[    0.313647] pci_bus 0000:00: on NUMA node 0
[    0.319235] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
[    0.320103] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 *10 12)
[    0.320809] ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
[    0.321325] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 12)
[    0.322075] ACPI: PCI Interrupt Link [LNKE] (IRQs 6) *0, disabled.
[    0.322687] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 12)
[    0.323485] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 12)
[    0.324253] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 7 10 12)
[    0.327177] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.327416] ACPI: \_SB_.PCI0: notify handler is installed
[    0.327822] Found 1 acpi root devices
[    0.328437] ACPI : EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
[    0.329051] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.329051] vgaarb: loaded
[    0.329051] vgaarb: bridge control possible 0000:00:02.0
[    0.329051] SCSI subsystem initialized
[    0.329172] libata version 3.00 loaded.
[    0.329172] PCI: Using ACPI for IRQ routing
[    0.329172] PCI: pci_cache_line_size set to 64 bytes
[    0.329172] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.329172] e820: reserve RAM buffer [mem 0x7dda0000-0x7fffffff]
[    0.332330] cfg80211: Calling CRDA to update world regulatory domain
[    0.332595] NetLabel: Initializing
[    0.332595] NetLabel:  domain hash size = 128
[    0.332633] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.332853] NetLabel:  unlabeled traffic allowed by default
[    0.333034] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.333034] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.333034] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.336127] Switched to clocksource hpet
[    0.336735] pnp: PnP ACPI init
[    0.336932] ACPI: bus type PNP registered
[    0.337242] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.337428] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.337524] pnp 00:01: [dma 4]
[    0.337616] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.337748] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.337935] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.338180] pnp 00:04: Plug and Play ACPI device, IDs SYN0a06 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    0.338291] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.338410] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.339012] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.339146] system 00:07: [io  0x0800-0x087f] could not be reserved
[    0.339237] system 00:07: [io  0x0400-0x041f] has been reserved
[    0.339373] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.339509] system 00:07: [mem 0xfe9fac00-0xfe9facff window] has been reserved
[    0.339720] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.339858] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.339996] system 00:07: [mem 0xfed45000-0xfed89fff] has been reserved
[    0.340156] system 00:07: [mem 0xfed90000-0xfed90fff] has been reserved
[    0.340294] system 00:07: [mem 0xfed91000-0xfed91fff] has been reserved
[    0.340431] system 00:07: [mem 0xfed92000-0xfed92fff] has been reserved
[    0.340567] system 00:07: [mem 0xfed93000-0xfed93fff] has been reserved
[    0.340705] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.340842] system 00:07: [mem 0xfff00000-0xffffffff] has been reserved
[    0.340985] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.341260] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.341560] system 00:09: [mem 0xffa00000-0xffbfffff] could not be reserved
[    0.341700] system 00:09: [mem 0xffe00000-0xffffffff] could not be reserved
[    0.341842] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.342097] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
[    0.342239] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.342524] system 00:0b: [io  0x0250-0x0253] has been reserved
[    0.342662] system 00:0b: [io  0x0256-0x025f] has been reserved
[    0.342799] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.342937] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.343073] system 00:0b: [mem 0xfec10000-0xfec17fff] has been reserved
[    0.343210] system 00:0b: [mem 0xfec38000-0xfec3ffff] has been reserved
[    0.343351] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.343640] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.343783] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.344995] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.345135] system 00:0d: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.345273] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.345411] system 00:0d: [mem 0x00100000-0x7ddfffff] could not be reserved
[    0.345554] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.346055] pnp: PnP ACPI: found 14 devices
[    0.346185] ACPI: bus type PNP unregistered
[    0.390677] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.390707] pci 0000:00:1c.5: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.390719] pci 0000:00:1c.5: BAR 9: assigned [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.390931] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.391072] pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.391225] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.391360] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.391501] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.391643] pci 0000:00:1c.5:   bridge window [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.391861] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.392038] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.392045] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.392051] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392058] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.392064] pci_bus 0000:00: resource 8 [mem 0x7de00000-0xffffffff]
[    0.392071] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.392077] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.392083] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.392090] pci_bus 0000:02: resource 2 [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.392096] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.392102] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.392109] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392115] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.392121] pci_bus 0000:03: resource 8 [mem 0x7de00000-0xffffffff]
[    0.392230] NET: Registered protocol family 2
[    0.393137] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.393356] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.394685] TCP: Hash tables configured (established 8192 bind 8192)
[    0.394882] TCP: reno registered
[    0.395016] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.395308] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.395979] NET: Registered protocol family 1
[    0.396163] pci 0000:00:02.0: Boot video device
[    0.396476] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.396483] pci 0000:00:1a.0: Performing full reset
[    0.397041] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.397046] pci 0000:00:1a.1: Performing full reset
[    0.397600] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.397605] pci 0000:00:1a.2: Performing full reset
[    0.398732] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.398738] pci 0000:00:1d.0: Performing full reset
[    0.399278] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.399284] pci 0000:00:1d.1: Performing full reset
[    0.399824] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.399830] pci 0000:00:1d.2: Performing full reset
[    0.400721] PCI: CLS 32 bytes, default 64
[    0.401145] Unpacking initramfs...
[    1.034801] Freeing initrd memory: 11020K (f6a6a000 - f752d000)
[    1.058071] DMA-API: preallocated 65536 debug entries
[    1.058209] DMA-API: debugging enabled by kernel config
[    1.058659] Simple Boot Flag at 0x51 set to 0x1
[    1.060126] Scanning for low memory corruption every 60 seconds
[    1.061287] audit: initializing netlink socket (disabled)
[    1.061491] type=2000 audit(1389221950.060:1): initialized
[    1.062538] bounce pool size: 64 pages
[    1.069093] VFS: Disk quotas dquot_6.5.2
[    1.069382] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.071269] fuse init (API version 7.22)
[    1.071736] msgmni has been set to 1708
[    1.072288] SELinux:  Registering netfilter hooks
[    1.074792] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.075028] io scheduler noop registered
[    1.075156] io scheduler deadline registered
[    1.075440] io scheduler cfq registered (default)
[    1.076070] intel_idle: does not run on family 6 model 23
[    1.077130] ACPI: AC Adapter [AC0] (on-line)
[    1.077578] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    1.077865] ACPI: Sleep Button [SLPB]
[    1.078195] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.085825] ACPI: Lid Switch [LID]
[    1.086110] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.086324] ACPI: Power Button [PWRF]
[    1.087524] Monitor-Mwait will be used to enter C-1 state
[    1.087617] Monitor-Mwait will be used to enter C-3 state
[    1.087640] tsc: Marking TSC unstable due to TSC halts in idle
[    1.087831] ACPI: acpi_idle registered with cpuidle
[    1.094784] thermal LNXTHERM:00: registered as thermal_zone0
[    1.094919] ACPI: Thermal Zone [THRM] (47 C)
[    1.096577] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.099770] Non-volatile memory driver v1.3
[    1.099965] Linux agpgart interface v0.103
[    1.100647] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    1.103032] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.105193] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.105878] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.106194] [drm] Initialized drm 1.1.0 20060810
[    1.110402] [drm:i915_dump_device_info], i915 device info: gen=4, pciid=0x2a42 flags=is_mobile,need_gfx_hws,is_g4x,has_fbc,has_pipe_cxsr,has_hotplug,supports_tv,
[    1.110564] [drm:intel_detect_pch], No PCH found?
[    1.110570] [drm] Memory usable by graphics device = 2048M
[    1.110704] [drm:i915_gem_gtt_init], GMADR size = 256M
[    1.110709] [drm:i915_gem_gtt_init], GTT stolen size = 32M
[    1.111940] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7ddaf0e4
[    1.111958] [drm:intel_opregion_setup], Public ACPI methods supported
[    1.111962] [drm:intel_opregion_setup], SWSCI supported
[    1.132056] [drm:swsci_setup], SWSCI BIOS requested (00000241) SBCB callbacks that are not supported (000000c1)
[    1.132063] [drm:swsci_setup], SWSCI GBDA callbacks 000004f3, SBCB callbacks 00000241
[    1.132067] [drm:intel_opregion_setup], ASLE supported
[    1.132281] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.132310] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.132478] [drm] Driver supports precise vblank timestamp query.
[    1.132650] [drm:init_vbt_defaults], Set default to SSC at 100000 kHz
[    1.132657] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT CANTIGA        d
[    1.132665] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 96000 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    1.132670] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.132677] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.132685] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 0 71900 1366 1414 1480 1486 768 774 782 806 0x8 0xa
[    1.132691] [drm:parse_lfp_panel_data], VBT initial LVDS value 4200033c
[    1.132697] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    1.132705] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    1.132710] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.132716] [drm:parse_mipi], No MIPI BDB found
[    1.132742] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    1.132789] [drm:i915_gem_init_stolen], found 33554432 bytes of stolen memory at 7e000000
[    1.133206] [drm:intel_modeset_init], 2 display pipes available.
[    1.133290] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    1.133305] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    1.133310] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
[    1.133325] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.163923] ACPI: Battery Slot [BAT0] (battery present)
[    1.216137] [drm:intel_lvds_init], using preferred mode from EDID: 
[    1.216146] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.216157] [drm:intel_lvds_init], detected single-link lvds configuration
[    1.216555] [drm:intel_panel_setup_backlight], backlight initialized, enabled, brightness 1398348/1992060, sysfs interface registered
[    1.216696] [drm:intel_dp_init_connector], Adding DP connector on port D
[    1.216810] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    1.217499] [drm:i965_irq_handler], pipe B underrun
[    1.217507] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.232528] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.248523] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.264522] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.280526] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.296047] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x71450064
[    1.296062] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.296558] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.312525] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.328525] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.344525] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.360525] [drm:i965_irq_handler], hotplug event received, stat 0x00000040
[    1.376047] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x71450064
[    1.376062] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.376168] [drm:intel_tv_init], Integrated TV is not present.
[    1.376178] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, 7ffff000]
[    1.380898] [drm:init_status_page], render ring hws offset: 0x00001000
[    1.380904] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    1.380912] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[    1.381053] [drm:init_status_page], bsd ring hws offset: 0x00024000
[    1.381059] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    1.381067] [drm:i915_pages_create_for_stolen], offset=0x20000, size=131072
[    1.381168] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
[    1.381191] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
[    1.381200] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
[    1.381209] [drm:intel_modeset_readout_hw_state], [ENCODER:12:DAC-12] hw state readout: enabled, pipe B
[    1.381217] [drm:intel_modeset_readout_hw_state], [ENCODER:13:TMDS-13] hw state readout: disabled, pipe A
[    1.381225] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
[    1.381232] [drm:intel_modeset_readout_hw_state], [CONNECTOR:11:VGA-1] hw state readout: enabled
[    1.381239] [drm:intel_modeset_readout_hw_state], [CONNECTOR:14:DP-1] hw state readout: disabled
[    1.381248] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    1.381253] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.381258] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.381265] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.381272] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.381276] [drm:intel_dump_pipe_config], requested mode:
[    1.381283] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.381288] [drm:intel_dump_pipe_config], adjusted mode:
[    1.381295] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.381302] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
[    1.381307] [drm:intel_dump_pipe_config], port clock: 0
[    1.381311] [drm:intel_dump_pipe_config], pipe src size: 0x0
[    1.381317] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.381322] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.381327] [drm:intel_dump_pipe_config], ips: 0
[    1.381332] [drm:intel_dump_pipe_config], double wide: 0
[    1.381340] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    1.381344] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.381350] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.381356] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.381363] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.381367] [drm:intel_dump_pipe_config], requested mode:
[    1.381374] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.381379] [drm:intel_dump_pipe_config], adjusted mode:
[    1.381386] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.381393] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.381398] [drm:intel_dump_pipe_config], port clock: 72000
[    1.381403] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.381409] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00008000
[    1.381414] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.381419] [drm:intel_dump_pipe_config], ips: 0
[    1.381424] [drm:intel_dump_pipe_config], double wide: 0
[    1.381431] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.381439] [drm:intel_connector_check_state], [CONNECTOR:11:VGA-1]
[    1.381447] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.381453] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.381460] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.381466] [drm:check_crtc_state], [CRTC:3]
[    1.381472] [drm:check_crtc_state], [CRTC:4]
[    1.381510] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    1.381515] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    1.381531] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    1.381539] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.381545] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    1.381551] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    1.396064] [drm:intel_crt_detect], CRT not detected via hotplug
[    1.400063] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    1.400069] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.400074] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    1.400080] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    1.400445] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.400451] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    1.400456] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    1.400462] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    1.400467] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    1.400473] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    1.400479] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    1.400484] [drm:drm_setup_crtcs], 
[    1.400490] [drm:drm_enable_connectors], connector 5 enabled? yes
[    1.400495] [drm:drm_enable_connectors], connector 11 enabled? no
[    1.400500] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.400505] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    1.400510] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    1.400515] [drm:drm_target_preferred], found mode 1366x768
[    1.400520] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.400527] [drm:drm_setup_crtcs], desired mode 1366x768 set on crtc 3
[    1.400536] [drm:intelfb_create], no BIOS fb, allocating a new one
[    1.400541] [drm:i915_gem_object_create_stolen], creating stolen object: size=408000
[    1.400549] [drm:i915_pages_create_for_stolen], offset=0x40000, size=4227072
[    1.402511] [drm:intelfb_create], allocated 1366x768 fb: 0x00046000, bo f52fcb00
[    1.403200] fbcon: inteldrmfb (fb0) is primary device
[    1.405225] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.405230] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    1.405233] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    1.405238] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.405244] [drm:drm_mode_debug_printmodeline], Modeline 17:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.405248] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
[    1.405252] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.405257] [drm:intel_modeset_stage_output_state], [CONNECTOR:11:VGA-1] to [CRTC:4]
[    1.405259] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[    1.405264] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    1.405281] [drm:connected_sink_compute_bpp], [CONNECTOR:5:LVDS-1] checking for sink bpp constrains
[    1.405289] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
[    1.405294] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
[    1.405298] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    1.405300] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.405303] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[    1.405308] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.405312] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.405315] [drm:intel_dump_pipe_config], requested mode:
[    1.405321] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.405323] [drm:intel_dump_pipe_config], adjusted mode:
[    1.405329] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.405334] [drm:intel_dump_crtc_timings], crtc timings: 71900 1366 1414 1480 1486 768 774 782 806, type: 0x48 flags: 0xa
[    1.405337] [drm:intel_dump_pipe_config], port clock: 71900
[    1.405340] [drm:intel_dump_pipe_config], pipe src size: 1366x768
[    1.405344] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.405347] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.405350] [drm:intel_dump_pipe_config], ips: 0
[    1.405353] [drm:intel_dump_pipe_config], double wide: 0
[    1.405507] [drm:i9xx_set_pipeconf], disabling CxSR downclocking
[    1.405549] [drm:i9xx_update_plane], Writing base 00046000 00000000 0 0 5504
[    1.405559] [drm:intel_update_fbc], no output, disabling
[    1.405568] [drm:intel_crtc_mode_set], [ENCODER:6:LVDS-6] set [MODE:0:1366x768]
[    1.406478] [drm:g4x_check_srwm], SR watermark: display plane 56, cursor 6
[    1.406484] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=25, cursor=6, B: plane=2, cursor=2, SR: plane=56, cursor=6
[    1.460067] [drm:intel_update_fbc], disabled per chip default
[    1.460079] [drm:intel_panel_enable_backlight], pipe A
[    1.460109] ------------[ cut here ]------------
[    1.460118] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_panel.c:723 i965_enable_backlight+0x4a/0x11a()
[    1.460119] backlight already enabled
[    1.460122] Modules linked in:
[    1.460126] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc3AS+ #1
[    1.460129] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[    1.460138]  00000000 00000000 f507b9cc c07e90fb c096d208 f507b9e4 c042cb79 c06860fe
[    1.460145]  f6e58000 f6e56000 00000000 f507b9fc c042cbf4 00000009 f507b9f4 c096d208
[    1.460153]  f507ba10 f507ba20 c06860fe c096d1c9 000002d3 c096d208 e0000000 f6e59c48
[    1.460154] Call Trace:
[    1.460162]  [<c07e90fb>] dump_stack+0x48/0x69
[    1.460168]  [<c042cb79>] warn_slowpath_common+0x5c/0x73
[    1.460173]  [<c06860fe>] ? i965_enable_backlight+0x4a/0x11a
[    1.460177]  [<c042cbf4>] warn_slowpath_fmt+0x26/0x2a
[    1.460182]  [<c06860fe>] i965_enable_backlight+0x4a/0x11a
[    1.460188]  [<c0686d7f>] intel_panel_enable_backlight+0x8b/0xa4
[    1.460194]  [<c06770ba>] intel_enable_lvds+0xf1/0x10e
[    1.460199]  [<c066ee11>] i9xx_crtc_enable+0x2fa/0x310
[    1.460204]  [<c069903a>] ? gen4_write64+0x3f/0x3f
[    1.460209]  [<c0671660>] __intel_set_mode+0xe7e/0xf69
[    1.460214]  [<c045b95f>] ? mark_held_locks+0x5c/0x7b
[    1.460220]  [<c046537f>] ? vprintk_emit+0x408/0x42b
[    1.460225]  [<c045baa8>] ? trace_hardirqs_on_caller+0x12a/0x17e
[    1.460231]  [<c0672fed>] intel_set_mode+0x12/0x2a
[    1.460235]  [<c0673537>] intel_crtc_set_config+0x532/0x6e5
[    1.460242]  [<c0640337>] drm_mode_set_config_internal+0x39/0x90
[    1.460246]  [<c063488f>] drm_fb_helper_set_par+0x4c/0x88
[    1.460252]  [<c05d8306>] fbcon_init+0x2cd/0x3a9
[    1.460258]  [<c061d7ef>] visual_init+0x9a/0xed
[    1.460263]  [<c061ec15>] do_bind_con_driver+0x142/0x230
[    1.460268]  [<c061ee12>] do_take_over_console+0x10f/0x137
[    1.460273]  [<c05d50e4>] do_fbcon_takeover+0x4c/0x8e
[    1.460277]  [<c05d8936>] fbcon_event_notify+0x26d/0x544
[    1.460282]  [<c0444ddf>] ? __blocking_notifier_call_chain+0x1e/0x4a
[    1.460286]  [<c0444c88>] notifier_call_chain+0x25/0x46
[    1.460291]  [<c0444df3>] __blocking_notifier_call_chain+0x32/0x4a
[    1.460296]  [<c0444e17>] blocking_notifier_call_chain+0xc/0xe
[    1.460301]  [<c05cd895>] fb_notifier_call_chain+0x11/0x13
[    1.460306]  [<c05ce83b>] register_framebuffer+0x1eb/0x244
[    1.460311]  [<c0634bde>] drm_fb_helper_initial_config+0x313/0x3a1
[    1.460316]  [<c07ee594>] ? _raw_spin_unlock_irqrestore+0x33/0x49
[    1.460322]  [<c069d94f>] intel_fbdev_initial_config+0x19/0x1b
[    1.460327]  [<c064b3f4>] i915_driver_load+0x8e4/0xaee
[    1.460334]  [<c063b7a5>] drm_dev_register+0xdf/0x174
[    1.460339]  [<c063cc4d>] drm_get_pci_dev+0x7c/0xe9
[    1.460343]  [<c0648d9c>] i915_pci_probe+0x39/0x42
[    1.460348]  [<c05c56b4>] pci_device_probe+0x59/0xa2
[    1.460353]  [<c06a2969>] driver_probe_device+0x7f/0x16f
[    1.460357]  [<c06a2a9c>] __driver_attach+0x43/0x5f
[    1.460362]  [<c06a166a>] bus_for_each_dev+0x3e/0x68
[    1.460366]  [<c06a2563>] driver_attach+0x14/0x16
[    1.460370]  [<c06a2a59>] ? driver_probe_device+0x16f/0x16f
[    1.460375]  [<c06a22fa>] bus_add_driver+0xb7/0x17a
[    1.460379]  [<c06a2f33>] driver_register+0x6e/0xa0
[    1.460383]  [<c05c500c>] __pci_register_driver+0x45/0x48
[    1.460388]  [<c0a3a27c>] ? drm_core_init+0xe4/0xe4
[    1.460393]  [<c063cd22>] drm_pci_init+0x68/0xc0
[    1.460397]  [<c0a3a27c>] ? drm_core_init+0xe4/0xe4
[    1.460401]  [<c0a3a2de>] i915_init+0x62/0x64
[    1.460405]  [<c04003e7>] do_one_initcall+0x79/0x102
[    1.460410]  [<c0440300>] ? param_set_charp+0x9f/0xa3
[    1.460414]  [<c0a193b5>] ? loglevel+0x2b/0x2b
[    1.460418]  [<c04404c8>] ? parse_args+0x168/0x206
[    1.460423]  [<c0a19ae9>] kernel_init_freeable+0x166/0x1f0
[    1.460428]  [<c07e3b1d>] kernel_init+0x8/0xda
[    1.460432]  [<c07ef137>] ret_from_kernel_thread+0x1b/0x28
[    1.460436]  [<c07e3b15>] ? rest_init+0xa1/0xa1
[    1.460493] ---[ end trace 094d67ea6d87c546 ]---
[    1.460497] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[    1.460520] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.460527] [drm:intel_connector_check_state], [CONNECTOR:11:VGA-1]
[    1.460533] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.460539] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.460543] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.460548] [drm:check_crtc_state], [CRTC:3]
[    1.460572] [drm:check_crtc_state], [CRTC:4]
[    1.460577] [drm:asle_work], No request on ASLC interrupt 0x00000000
[    1.460600] [drm:intel_pipe_config_compare] *ERROR* mismatch in gmch_pfit.lvds_border_bits (expected 32768, found 0)
[    1.460602] ------------[ cut here ]------------
[    1.460608] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_display.c:9489 check_crtc_state+0x7d4/0x816()
[    1.460610] pipe state doesn't match!
[    1.460614] Modules linked in:
[    1.460619] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-rc3AS+ #1
[    1.460622] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[    1.460635]  00000000 00000000 f507b830 c07e90fb c0967aa4 f507b848 c042cb79 c066821d
[    1.460648]  f5142000 00000000 f6e0cb80 f507b860 c042cbf4 00000009 f507b858 c0967aa4
[    1.460661]  f507b874 f507bad4 c066821d c0966993 00002511 c0967aa4 04080000 f50805b0
[    1.460663] Call Trace:
[    1.460669]  [<c07e90fb>] dump_stack+0x48/0x69
[    1.460674]  [<c042cb79>] warn_slowpath_common+0x5c/0x73
[    1.460680]  [<c066821d>] ? check_crtc_state+0x7d4/0x816
[    1.460685]  [<c042cbf4>] warn_slowpath_fmt+0x26/0x2a
[    1.460691]  [<c066821d>] check_crtc_state+0x7d4/0x816
[    1.460702]  [<c0672d5f>] intel_modeset_check_state+0x305/0x581
[    1.460708]  [<c0672ffc>] intel_set_mode+0x21/0x2a
[    1.460714]  [<c0673537>] intel_crtc_set_config+0x532/0x6e5
[    1.460721]  [<c0640337>] drm_mode_set_config_internal+0x39/0x90
[    1.460726]  [<c063488f>] drm_fb_helper_set_par+0x4c/0x88
[    1.460732]  [<c05d8306>] fbcon_init+0x2cd/0x3a9
[    1.460738]  [<c061d7ef>] visual_init+0x9a/0xed
[    1.460743]  [<c061ec15>] do_bind_con_driver+0x142/0x230
[    1.460749]  [<c061ee12>] do_take_over_console+0x10f/0x137
[    1.460755]  [<c05d50e4>] do_fbcon_takeover+0x4c/0x8e
[    1.460761]  [<c05d8936>] fbcon_event_notify+0x26d/0x544
[    1.460766]  [<c0444ddf>] ? __blocking_notifier_call_chain+0x1e/0x4a
[    1.460771]  [<c0444c88>] notifier_call_chain+0x25/0x46
[    1.460777]  [<c0444df3>] __blocking_notifier_call_chain+0x32/0x4a
[    1.460782]  [<c0444e17>] blocking_notifier_call_chain+0xc/0xe
[    1.460788]  [<c05cd895>] fb_notifier_call_chain+0x11/0x13
[    1.460794]  [<c05ce83b>] register_framebuffer+0x1eb/0x244
[    1.460800]  [<c0634bde>] drm_fb_helper_initial_config+0x313/0x3a1
[    1.460806]  [<c07ee594>] ? _raw_spin_unlock_irqrestore+0x33/0x49
[    1.460812]  [<c069d94f>] intel_fbdev_initial_config+0x19/0x1b
[    1.460818]  [<c064b3f4>] i915_driver_load+0x8e4/0xaee
[    1.460825]  [<c063b7a5>] drm_dev_register+0xdf/0x174
[    1.460831]  [<c063cc4d>] drm_get_pci_dev+0x7c/0xe9
[    1.460836]  [<c0648d9c>] i915_pci_probe+0x39/0x42
[    1.460841]  [<c05c56b4>] pci_device_probe+0x59/0xa2
[    1.460847]  [<c06a2969>] driver_probe_device+0x7f/0x16f
[    1.460852]  [<c06a2a9c>] __driver_attach+0x43/0x5f
[    1.460857]  [<c06a166a>] bus_for_each_dev+0x3e/0x68
[    1.460863]  [<c06a2563>] driver_attach+0x14/0x16
[    1.460868]  [<c06a2a59>] ? driver_probe_device+0x16f/0x16f
[    1.460873]  [<c06a22fa>] bus_add_driver+0xb7/0x17a
[    1.460879]  [<c06a2f33>] driver_register+0x6e/0xa0
[    1.460884]  [<c05c500c>] __pci_register_driver+0x45/0x48
[    1.460889]  [<c0a3a27c>] ? drm_core_init+0xe4/0xe4
[    1.460894]  [<c063cd22>] drm_pci_init+0x68/0xc0
[    1.460899]  [<c0a3a27c>] ? drm_core_init+0xe4/0xe4
[    1.460904]  [<c0a3a2de>] i915_init+0x62/0x64
[    1.460909]  [<c04003e7>] do_one_initcall+0x79/0x102
[    1.460914]  [<c0440300>] ? param_set_charp+0x9f/0xa3
[    1.460919]  [<c0a193b5>] ? loglevel+0x2b/0x2b
[    1.460924]  [<c04404c8>] ? parse_args+0x168/0x206
[    1.460930]  [<c0a19ae9>] kernel_init_freeable+0x166/0x1f0
[    1.460936]  [<c07e3b1d>] kernel_init+0x8/0xda
[    1.460941]  [<c07ef137>] ret_from_kernel_thread+0x1b/0x28
[    1.460946]  [<c07e3b15>] ? rest_init+0xa1/0xa1
[    1.460949] ---[ end trace 094d67ea6d87c547 ]---
[    1.460953] [drm:intel_dump_pipe_config], [CRTC:4][hw state] config for pipe B
[    1.460955] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.460959] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.460963] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.460968] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.460970] [drm:intel_dump_pipe_config], requested mode:
[    1.460976] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.460978] [drm:intel_dump_pipe_config], adjusted mode:
[    1.460983] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.460988] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.460991] [drm:intel_dump_pipe_config], port clock: 72000
[    1.460995] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.460999] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00000000
[    1.461002] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.461005] [drm:intel_dump_pipe_config], ips: 0
[    1.461008] [drm:intel_dump_pipe_config], double wide: 0
[    1.461011] [drm:intel_dump_pipe_config], [CRTC:4][sw state] config for pipe B
[    1.461014] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.461017] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.461022] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.461026] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.461028] [drm:intel_dump_pipe_config], requested mode:
[    1.461034] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.461036] [drm:intel_dump_pipe_config], adjusted mode:
[    1.461041] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.461046] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.461049] [drm:intel_dump_pipe_config], port clock: 72000
[    1.461053] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.461057] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00008000
[    1.461060] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.461063] [drm:intel_dump_pipe_config], ips: 0
[    1.461066] [drm:intel_dump_pipe_config], double wide: 0
[    1.461072] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    1.461078] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    1.461082] [drm:intel_modeset_stage_output_state], [CONNECTOR:11:VGA-1] to [NOCRTC]
[    1.461084] [drm:intel_modeset_stage_output_state], encoder changed, full mode switch
[    1.461088] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.461091] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[    1.461096] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[    1.476131] [drm:i9xx_pfit_disable], disabling pfit, current: 0xa0000000
[    1.476142] [drm:g4x_check_srwm], SR watermark: display plane 56, cursor 6
[    1.476148] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=25, cursor=6, B: plane=2, cursor=2, SR: plane=56, cursor=6
[    1.476168] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.476175] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.476180] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.476185] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.476189] [drm:check_crtc_state], [CRTC:3]
[    1.476212] [drm:check_crtc_state], [CRTC:4]
[    1.476259] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.476264] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.476269] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.487755] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.487762] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.487766] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.498958] Console: switching to colour frame buffer device 170x48
[    1.498969] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.498975] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.498979] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.855208] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.857933] i915 0000:00:02.0: registered panic notifier
[    1.861177] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    1.864986] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.867926] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.874563] loop: module loaded
[    1.877631] ACPI Warning: 0x00000828-0x0000082f SystemIO conflicts with Region \PMIO 1 (20131115/utaddress-251)
[    1.880770] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.883919] ACPI Warning: 0x00000530-0x0000053f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[    1.887204] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.890588] ACPI Warning: 0x00000500-0x0000052f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[    1.894029] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.897497] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    1.901312] ahci 0000:00:1f.2: version 3.0
[    1.901782] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.901920] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    1.905497] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
[    1.909070] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    1.914983] scsi0 : ahci
[    1.919120] scsi1 : ahci
[    1.922940] scsi2 : ahci
[    1.926698] scsi3 : ahci
[    1.930294] ata1: SATA max UDMA/133 abar m2048@0xfe9fb000 port 0xfe9fb100 irq 41
[    1.933810] ata2: DUMMY
[    1.937295] ata3: DUMMY
[    1.940747] ata4: DUMMY
[    1.944587] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.952876] i8042: Detected active multiplexing controller, rev 1.1
[    1.957984] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.962053] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.965770] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.969456] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.973084] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.976969] mousedev: PS/2 mouse device common for all mice
[    1.981906] rtc_cmos 00:02: RTC can wake from S4
[    1.986142] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.989741] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.993437] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    1.997092] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0860)
[    2.001350] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.005142] iTCO_vendor_support: vendor-support=0
[    2.009321] asus_laptop: Asus Laptop Support version 0.42
[    2.013453] asus_laptop:   UL20A model detected
[    2.019244] [drm:asle_set_backlight], bclp = 0x800000b3
[    2.019265] [drm:asle_set_backlight], updating opregion backlight 179/255
[    2.019282] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[    2.019327] [drm:asle_work], No request on ASLC interrupt 0x00000000
[    2.019408] input: Asus Laptop extra buttons as /devices/platform/asus_laptop/input/input5
[    2.029622] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.208838] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.213601] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.218532] TCP: cubic registered
[    2.222465] Initializing XFRM netlink socket
[    2.226402] NET: Registered protocol family 17
[    2.230357] NET: Registered protocol family 15
[    2.234952] Using IPI No-Shortcut mode
[    2.239134] registered taskstats version 1
[    2.244049]   Magic number: 14:346:1007
[    2.247895] input input4: hash matches
[    2.251578] system 00:09: hash matches
[    2.255211] rtc_cmos 00:02: setting system clock to 2014-01-08 22:59:12 UTC (1389221952)
[    2.260711] PM: Hibernation image not present or could not be loaded.
[    2.268156] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.274418] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.280312] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.280324] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.333561] ata1.00: ATA-8: ST9250315AS, 0002SDM1, max UDMA/133
[    2.338658] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.347484] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.352871] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.352878] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.357786] ata1.00: configured for UDMA/133
[    2.362135] scsi 0:0:0:0: Direct-Access     ATA      ST9250315AS      0002 PQ: 0 ANSI: 5
[    2.366819] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.372784] sd 0:0:0:0: [sda] Write Protect is off
[    2.372927] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.379046] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.379128] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.454899]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
[    2.460720] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.464565] Freeing unused kernel memory: 392K (c0a19000 - c0a7b000)
[    2.470633] Write protecting the kernel text: 4036k
[    2.474156] Write protecting the kernel read-only data: 1888k
[    2.495348] systemd[1]: systemd 197 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    2.499631] systemd[1]: Running in initial RAM disk.
[    2.515930] systemd[1]: Failed to insert module 'autofs4'
[    2.519710] systemd[1]: No hostname configured.
[    2.523380] systemd[1]: Set hostname to <localhost>.
[    2.527560] random: systemd urandom read with 23 bits of entropy available
[    2.531259] systemd[1]: Initializing machine ID from random generator.
[    2.561310] systemd[1]: Starting Encrypted Volumes.
[    2.569174] systemd[1]: Reached target Encrypted Volumes.
[    2.573092] systemd[1]: Starting udev Kernel Socket.
[    2.580902] systemd[1]: Listening on udev Kernel Socket.
[    2.584691] systemd[1]: Starting udev Control Socket.
[    2.592278] systemd[1]: Listening on udev Control Socket.
[    2.595774] systemd[1]: Starting Journal Socket.
[    2.603644] systemd[1]: Listening on Journal Socket.
[    2.607254] systemd[1]: Starting dracut cmdline hook...
[    2.617962] systemd[1]: Started Load Kernel Modules.
[    2.621609] systemd[1]: Starting Journal Service...
[    2.637535] systemd[1]: Started Journal Service.
[    2.642357] systemd[1]: Starting Sockets.
[    2.649832] systemd[1]: Reached target Sockets.
[    2.653343] systemd[1]: Starting Swap.
[    2.660602] systemd[1]: Reached target Swap.
[    2.664002] systemd[1]: Starting Local File Systems.
[    2.671223] systemd[1]: Reached target Local File Systems.
[    2.875332] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    2.875340] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    2.875344] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    2.927456] systemd-udevd[125]: starting version 197
[    3.115470] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 600854
[    3.157747] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input13
[    3.381116] [drm:i915_gem_open], 
[    3.381461] [drm:intel_crtc_cursor_set], cursor off
[    3.381478] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    3.381488] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.381495] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.381501] [drm:intel_crtc_cursor_set], cursor off
[    3.381507] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.381514] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.381519] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.381580] [drm:i915_gem_open], 
[    3.381622] [drm:intel_crtc_cursor_set], cursor off
[    3.381629] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    3.381636] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.381642] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.381648] [drm:intel_crtc_cursor_set], cursor off
[    3.381653] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.381660] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.381665] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.381714] [drm:i915_gem_open], 
[    3.382006] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    3.382040] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    3.382065] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    3.382079] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    3.382085] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    3.382103] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    3.382110] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    3.382120] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    3.399567] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    3.399582] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    3.399588] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    3.412079] [drm:intel_crt_detect], CRT not detected via hotplug
[    3.416519] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.416528] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.416533] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.416538] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.416893] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.416898] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.416903] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    3.416910] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    3.416928] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    3.416936] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    3.416941] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    3.424083] [drm:intel_crt_detect], CRT not detected via hotplug
[    3.428570] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.428578] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.428583] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.428589] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.428944] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.428949] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.428954] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    3.428960] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    3.428986] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    3.428994] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    3.428999] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    3.429005] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    3.429014] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    3.429021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    3.429025] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    3.429031] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    3.429281] [drm:drm_mode_addfb], [FB:19]
[    4.686010] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    4.983015] random: nonblocking pool is initialized
[    5.211785] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    5.618657] systemd-journald[65]: Received SIGTERM
[    7.250541] type=1404 audit(1389221957.492:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    7.418294] SELinux: 2048 avtab hash slots, 98400 rules.
[    7.489417] SELinux: 2048 avtab hash slots, 98400 rules.
[    7.823652] SELinux:  9 users, 15 roles, 4414 types, 249 bools, 1 sens, 1024 cats
[    7.823662] SELinux:  83 classes, 98400 rules
[    7.845253] SELinux:  Permission attach_queue in class tun_socket not defined in policy.
[    7.848682] SELinux: the above unknown classes and permissions will be allowed
[    7.852148] SELinux:  Completing initialization.
[    7.852152] SELinux:  Setting up existing superblocks.
[    7.852378] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    7.852562] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    7.852763] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    7.852870] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    7.853263] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.853451] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    7.855687] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    7.855847] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    7.856421] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    7.856587] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    7.856739] SELinux: initialized (dev aio, type aio), not configured for labeling
[    7.856850] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    7.857076] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    7.857237] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    7.857412] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    7.861421] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    7.861471] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.861489] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.861761] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.861961] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862031] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862090] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862282] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862361] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862398] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862428] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862507] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.862658] SELinux: initialized (dev sda6, type ext4), uses xattr
[    7.919850] type=1403 audit(1389221958.160:3): policy loaded auid=4294967295 ses=4294967295
[    8.038189] systemd[1]: Successfully loaded SELinux policy in 869.245ms.
[    8.418021] systemd[1]: Relabelled /dev and /run in 49.394ms.
[   12.035899] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.177135] systemd-sysctl[255]: Duplicate assignment of kernel/sysrq in file '/usr/lib/sysctl.d/00-system.conf', ignoring.
[   12.294953] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.305314] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.428068] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.450604] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.524050] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   12.579219] systemd-udevd[264]: starting version 201
[   12.586964] EXT4-fs (sda6): re-mounted. Opts: (null)
[   12.677719] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.681480] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.694100] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.740160] systemd-binfmt[262]: Failed to add binary format: No such file or directory
[   12.745470] systemd[1]: Unit systemd-binfmt.service entered failed state.
[   12.786433] systemd-journald[267]: Vacuuming done, freed 0 bytes
[   14.165800] ACPI: bus type USB registered
[   14.168948] usbcore: registered new interface driver usbfs
[   14.172143] usbcore: registered new interface driver hub
[   14.177808] usbcore: registered new device driver usb
[   14.210104] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   14.213775] ehci_hcd: block sizes: qh 80 qtd 96 itd 160 sitd 96
[   14.228935] ehci-pci: EHCI PCI platform driver
[   14.232471] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   14.235856] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   14.242591] uhci_hcd: USB Universal Host Controller Interface driver
[   14.245984] ehci-pci 0000:00:1a.7: debug port 1
[   14.249025] ehci-pci 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   14.249035] ehci-pci 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   14.249309] ehci-pci 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   14.254031] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
[   14.254039] ehci-pci 0000:00:1a.7: supports USB remote wakeup
[   14.254158] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfe9fbc00
[   14.257212] ehci-pci 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   14.268087] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   14.278186] usb usb1: default language 0x0409
[   14.278256] usb usb1: udev 1, busnum 1, minor = 0
[   14.278263] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   14.281457] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.285073] usb usb1: Product: EHCI Host Controller
[   14.288001] usb usb1: Manufacturer: Linux 3.13.0-rc3AS+ ehci_hcd
[   14.290961] usb usb1: SerialNumber: 0000:00:1a.7
[   14.297621] usb usb1: usb_probe_device
[   14.297631] usb usb1: configuration #1 chosen from 1 choice
[   14.299948] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   14.301653] hub 1-0:1.0: usb_probe_interface
[   14.301660] hub 1-0:1.0: usb_probe_interface - got id
[   14.301684] hub 1-0:1.0: USB hub found
[   14.304861] hub 1-0:1.0: 6 ports detected
[   14.307715] hub 1-0:1.0: standalone hub
[   14.307721] hub 1-0:1.0: no power switching (usb 1.0)
[   14.307726] hub 1-0:1.0: individual port over-current protection
[   14.307733] hub 1-0:1.0: power on to power good time: 20ms
[   14.308404] hub 1-0:1.0: local power source is good
[   14.326294] usb usb1: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.326303] usb usb1: usb port3's DeviceRemovable is changed to 1 according to platform information.
[   14.326309] usb usb1: usb port6's DeviceRemovable is changed to 1 according to platform information.
[   14.326316] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   14.327834] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   14.331343] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
[   14.334335] uhci_hcd 0000:00:1a.0: detected 2 ports
[   14.337280] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   14.337286] uhci_hcd 0000:00:1a.0: Performing full reset
[   14.337308] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   14.337391] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
[   14.340830] usb usb2: default language 0x0409
[   14.340935] usb usb2: udev 1, busnum 2, minor = 128
[   14.340946] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   14.343858] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.346856] usb usb2: Product: UHCI Host Controller
[   14.349767] usb usb2: Manufacturer: Linux 3.13.0-rc3AS+ uhci_hcd
[   14.352671] usb usb2: SerialNumber: 0000:00:1a.0
[   14.360577] usb usb2: usb_probe_device
[   14.360592] usb usb2: configuration #1 chosen from 1 choice
[   14.360815] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   14.360977] hub 2-0:1.0: usb_probe_interface
[   14.360988] hub 2-0:1.0: usb_probe_interface - got id
[   14.361005] hub 2-0:1.0: USB hub found
[   14.364074] hub 2-0:1.0: 2 ports detected
[   14.366906] hub 2-0:1.0: standalone hub
[   14.366911] hub 2-0:1.0: no power switching (usb 1.0)
[   14.366920] hub 2-0:1.0: individual port over-current protection
[   14.366927] hub 2-0:1.0: power on to power good time: 2ms
[   14.367043] hub 2-0:1.0: local power source is good
[   14.369623] usb usb2: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.369634] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   14.371031] uhci_hcd 0000:00:1a.0: FS/LS companion for 0000:00:1a.7
[   14.371632] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   14.374538] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 3
[   14.377560] ehci-pci 0000:00:1d.7: debug port 1
[   14.380477] ehci-pci 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   14.380490] ehci-pci 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   14.380616] ehci-pci 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   14.384520] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[   14.384530] ehci-pci 0000:00:1d.7: supports USB remote wakeup
[   14.384611] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfe9fb800
[   14.388677] ehci-pci 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   14.400068] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   14.403284] usb usb3: default language 0x0409
[   14.403396] usb usb3: udev 1, busnum 3, minor = 256
[   14.403407] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   14.406392] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.409321] usb usb3: Product: EHCI Host Controller
[   14.412212] usb usb3: Manufacturer: Linux 3.13.0-rc3AS+ ehci_hcd
[   14.419047] usb usb3: SerialNumber: 0000:00:1d.7
[   14.425064] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[   14.425115] hub 1-0:1.0: port 3: status 0501 change 0001
[   14.426140] usb usb3: usb_probe_device
[   14.426152] usb usb3: configuration #1 chosen from 1 choice
[   14.426437] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   14.426610] hub 3-0:1.0: usb_probe_interface
[   14.426616] hub 3-0:1.0: usb_probe_interface - got id
[   14.426637] hub 3-0:1.0: USB hub found
[   14.435427] hub 3-0:1.0: 6 ports detected
[   14.439964] hub 3-0:1.0: standalone hub
[   14.439971] hub 3-0:1.0: no power switching (usb 1.0)
[   14.439980] hub 3-0:1.0: individual port over-current protection
[   14.439987] hub 3-0:1.0: power on to power good time: 20ms
[   14.440351] hub 3-0:1.0: local power source is good
[   14.447350] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[   14.448236] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   14.448979] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   14.448998] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   14.449012] uhci_hcd 0000:00:1a.1: detected 2 ports
[   14.449022] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[   14.449025] uhci_hcd 0000:00:1a.1: Performing full reset
[   14.449044] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[   14.449099] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[   14.449311] usb usb4: default language 0x0409
[   14.449377] usb usb4: udev 1, busnum 4, minor = 384
[   14.449381] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   14.449385] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.449388] usb usb4: Product: UHCI Host Controller
[   14.449392] usb usb4: Manufacturer: Linux 3.13.0-rc3AS+ uhci_hcd
[   14.449395] usb usb4: SerialNumber: 0000:00:1a.1
[   14.449895] usb usb4: usb_probe_device
[   14.449900] usb usb4: configuration #1 chosen from 1 choice
[   14.449948] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   14.450092] hub 4-0:1.0: usb_probe_interface
[   14.450096] hub 4-0:1.0: usb_probe_interface - got id
[   14.450106] hub 4-0:1.0: USB hub found
[   14.450141] hub 4-0:1.0: 2 ports detected
[   14.450144] hub 4-0:1.0: standalone hub
[   14.450147] hub 4-0:1.0: no power switching (usb 1.0)
[   14.450150] hub 4-0:1.0: individual port over-current protection
[   14.450155] hub 4-0:1.0: power on to power good time: 2ms
[   14.450203] hub 4-0:1.0: local power source is good
[   14.451765] usb usb4: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.451769] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   14.452082] uhci_hcd 0000:00:1a.1: FS/LS companion for 0000:00:1a.7
[   14.452429] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   14.452448] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   14.452461] uhci_hcd 0000:00:1a.2: detected 2 ports
[   14.452469] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[   14.452473] uhci_hcd 0000:00:1a.2: Performing full reset
[   14.452491] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[   14.452540] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000d480
[   14.452733] usb usb5: default language 0x0409
[   14.452797] usb usb5: udev 1, busnum 5, minor = 512
[   14.452801] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   14.452805] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.452809] usb usb5: Product: UHCI Host Controller
[   14.452812] usb usb5: Manufacturer: Linux 3.13.0-rc3AS+ uhci_hcd
[   14.452816] usb usb5: SerialNumber: 0000:00:1a.2
[   14.453230] usb usb5: usb_probe_device
[   14.453234] usb usb5: configuration #1 chosen from 1 choice
[   14.453279] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   14.453379] hub 5-0:1.0: usb_probe_interface
[   14.453382] hub 5-0:1.0: usb_probe_interface - got id
[   14.453392] hub 5-0:1.0: USB hub found
[   14.453424] hub 5-0:1.0: 2 ports detected
[   14.453428] hub 5-0:1.0: standalone hub
[   14.453431] hub 5-0:1.0: no power switching (usb 1.0)
[   14.453434] hub 5-0:1.0: individual port over-current protection
[   14.453438] hub 5-0:1.0: power on to power good time: 2ms
[   14.453485] hub 5-0:1.0: local power source is good
[   14.455043] usb usb5: usb port2's DeviceRemovable is changed to 1 according to platform information.
[   14.455047] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   14.455321] uhci_hcd 0000:00:1a.2: FS/LS companion for 0000:00:1a.7
[   14.513393] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   14.513470] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.513906] hub 2-0:1.0: hub_suspend
[   14.514565] usb usb2: bus auto-suspend, wakeup 1
[   14.514581] usb usb2: suspend_rh
[   14.517042] Copyright(c) 2003-2013 Intel Corporation
[   14.524114] hub 1-0:1.0: state 7 ports 6 chg 0008 evt 0000
[   14.524452] hub 1-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[   14.524878] atl1c 0000:02:00.0: version 1.0.1.1-NAPI
[   14.525424] iwlwifi 0000:01:00.0: irq 42 for MSI/MSI-X
[   14.528190] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   14.537429] uhci_hcd 0000:00:1d.0: detected 2 ports
[   14.541861] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   14.541872] uhci_hcd 0000:00:1d.0: Performing full reset
[   14.541902] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   14.541930] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[   14.545564] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[   14.546365] usb usb6: default language 0x0409
[   14.546477] usb usb6: udev 1, busnum 6, minor = 640
[   14.546487] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   14.549414] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.552307] usb usb6: Product: UHCI Host Controller
[   14.555144] usb usb6: Manufacturer: Linux 3.13.0-rc3AS+ uhci_hcd
[   14.558072] usb usb6: SerialNumber: 0000:00:1d.0
[   14.565921] usb usb6: usb_probe_device
[   14.565933] usb usb6: configuration #1 chosen from 1 choice
[   14.566046] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   14.568746] hub 6-0:1.0: usb_probe_interface
[   14.568758] hub 6-0:1.0: usb_probe_interface - got id
[   14.568775] hub 6-0:1.0: USB hub found
[   14.572598] hub 6-0:1.0: 2 ports detected
[   14.575394] hub 6-0:1.0: standalone hub
[   14.575400] hub 6-0:1.0: no power switching (usb 1.0)
[   14.575409] hub 6-0:1.0: individual port over-current protection
[   14.575416] hub 6-0:1.0: power on to power good time: 2ms
[   14.575509] hub 6-0:1.0: local power source is good
[   14.578235] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   14.580736] ehci-pci 0000:00:1a.7: port 3 reset complete, port enabled
[   14.580748] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   14.583993] uhci_hcd 0000:00:1d.0: FS/LS companion for 0000:00:1d.7
[   14.584557] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   14.587414] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   14.590519] uhci_hcd 0000:00:1d.1: detected 2 ports
[   14.593394] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   14.593400] uhci_hcd 0000:00:1d.1: Performing full reset
[   14.593437] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   14.593465] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d080
[   14.596710] usb usb7: default language 0x0409
[   14.596807] usb usb7: udev 1, busnum 7, minor = 768
[   14.596814] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   14.599693] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.602887] usb usb7: Product: UHCI Host Controller
[   14.605784] usb usb7: Manufacturer: Linux 3.13.0-rc3AS+ uhci_hcd
[   14.608726] usb usb7: SerialNumber: 0000:00:1d.1
[   14.614932] usb usb7: usb_probe_device
[   14.614944] usb usb7: configuration #1 chosen from 1 choice
[   14.615032] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   14.622098] hub 7-0:1.0: usb_probe_interface
[   14.622110] hub 7-0:1.0: usb_probe_interface - got id
[   14.622132] hub 7-0:1.0: USB hub found
[   14.626476] hub 7-0:1.0: 2 ports detected
[   14.629402] hub 7-0:1.0: standalone hub
[   14.629412] hub 7-0:1.0: no power switching (usb 1.0)
[   14.629417] hub 7-0:1.0: individual port over-current protection
[   14.629428] hub 7-0:1.0: power on to power good time: 2ms
[   14.629517] hub 7-0:1.0: local power source is good
[   14.633381] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   14.636358] usb 1-3: new high-speed USB device number 2 using ehci-pci
[   14.644679] uhci_hcd 0000:00:1d.1: FS/LS companion for 0000:00:1d.7
[   14.645216] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   14.650251] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   14.666543] uhci_hcd 0000:00:1d.2: detected 2 ports
[   14.671908] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   14.671916] uhci_hcd 0000:00:1d.2: Performing full reset
[   14.671950] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   14.671980] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[   14.675509] usb usb8: default language 0x0409
[   14.675622] usb usb8: udev 1, busnum 8, minor = 896
[   14.675632] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   14.678614] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.682561] usb usb8: Product: UHCI Host Controller
[   14.685733] usb usb8: Manufacturer: Linux 3.13.0-rc3AS+ uhci_hcd
[   14.689027] usb usb8: SerialNumber: 0000:00:1d.2
[   14.693545] usb usb8: usb_probe_device
[   14.693554] usb usb8: configuration #1 chosen from 1 choice
[   14.693618] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[   14.693781] hub 8-0:1.0: usb_probe_interface
[   14.693791] hub 8-0:1.0: usb_probe_interface - got id
[   14.693808] hub 8-0:1.0: USB hub found
[   14.697609] iwlwifi 0000:01:00.0: loaded firmware version 39.31.5.1 build 35138 op_mode iwldvm
[   14.708442] hub 8-0:1.0: 2 ports detected
[   14.711467] hub 8-0:1.0: standalone hub
[   14.711472] hub 8-0:1.0: no power switching (usb 1.0)
[   14.711481] hub 8-0:1.0: individual port over-current protection
[   14.711493] hub 8-0:1.0: power on to power good time: 2ms
[   14.718541] hub 8-0:1.0: local power source is good
[   14.737920] hub 8-0:1.0: trying to enable port power on non-switchable hub
[   14.738459] uhci_hcd 0000:00:1d.2: FS/LS companion for 0000:00:1d.7
[   14.748363] ehci-pci 0000:00:1a.7: port 3 reset complete, port enabled
[   14.748375] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   14.799128] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   14.844529] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   14.848013] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
[   14.861078] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   14.864469] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   14.868149] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
[   14.880698] usb 1-3: skipped 1 descriptor after configuration
[   14.880705] usb 1-3: skipped 6 descriptors after interface
[   14.880715] usb 1-3: skipped 1 descriptor after endpoint
[   14.880727] usb 1-3: skipped 8 descriptors after interface
[   14.881541] usb 1-3: default language 0x0409
[   14.881865] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.886685] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   14.889917] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   14.893004] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   14.893020] usb 1-3: udev 2, busnum 1, minor = 1
[   14.893025] usb 1-3: New USB device found, idVendor=04f2, idProduct=b036
[   14.893028] usb 1-3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[   14.893032] usb 1-3: Product: USB2.0 0.3M UVC WebCam
[   14.893035] usb 1-3: Manufacturer: Chicony Electronics Co., Ltd.
[   14.893038] usb 1-3: SerialNumber: SN0001
[   14.893946] usb 1-3: usb_probe_device
[   14.893951] usb 1-3: configuration #1 chosen from 1 choice
[   14.911299] usb 1-3: adding 1-3:1.0 (config #1, interface 0)
[   14.912230] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   14.916495] usb 1-3: adding 1-3:1.1 (config #1, interface 1)
[   14.916556] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   14.916732] hub 3-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   14.916749] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.916760] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.916770] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.916781] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.916791] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.916812] hub 3-0:1.0: hub_suspend
[   14.917049] usb usb3: bus auto-suspend, wakeup 1
[   14.917053] ehci-pci 0000:00:1d.7: suspend root hub
[   14.917142] hub 5-0:1.0: hub_suspend
[   14.917248] usb usb5: bus auto-suspend, wakeup 1
[   14.917253] usb usb5: suspend_rh
[   14.917291] hub 4-0:1.0: hub_suspend
[   14.917319] usb usb4: bus auto-suspend, wakeup 1
[   14.917323] usb usb4: suspend_rh
[   14.917358] hub 6-0:1.0: hub_suspend
[   14.917384] usb usb6: bus auto-suspend, wakeup 1
[   14.917388] usb usb6: suspend_rh
[   14.917423] hub 7-0:1.0: hub_suspend
[   14.917450] usb usb7: bus auto-suspend, wakeup 1
[   14.917454] usb usb7: suspend_rh
[   14.917489] hub 8-0:1.0: hub_suspend
[   14.917515] usb usb8: bus auto-suspend, wakeup 1
[   14.917519] usb usb8: suspend_rh
[   14.960045] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   15.424423] irq 16: nobody cared (try booting with the "irqpoll" option)
[   15.427564] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.13.0-rc3AS+ #1
[   15.428417] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[   15.428417]  00000000 00000000 f5009f84 c07e90fb f514d700 f5009f98 c0467e6b f514d700
[   15.428417]  00000000 00000010 f5009fb4 c04681d7 215fb4f2 fffeea19 f514d700 00000010
[   15.428417]  00000000 f5009fd4 c046694b 00000000 00000000 00000000 f514d700 f514d754
[   15.428417] Call Trace:
[   15.428417]  [<c07e90fb>] dump_stack+0x48/0x69
[   15.428417]  [<c0467e6b>] __report_bad_irq+0x14/0x9e
[   15.428417]  [<c04681d7>] note_interrupt+0x137/0x1b4
[   15.428417]  [<c046694b>] handle_irq_event_percpu+0xee/0x106
[   15.428417]  [<c046698f>] handle_irq_event+0x2c/0x45
[   15.428417]  [<c046892e>] ? handle_level_irq+0x6f/0x6f
[   15.428417]  [<c0468998>] handle_fasteoi_irq+0x6a/0x97
[   15.428417]  <IRQ>  [<c0402ed0>] ? do_IRQ+0x35/0x80
[   15.428417]  [<c07ef6b8>] ? common_interrupt+0x38/0x3d
[   15.428417]  [<c045007b>] ? dequeue_entity+0x191/0x228
[   15.428417]  [<c06ff108>] ? cpuidle_enter_state+0x42/0xa7
[   15.428417]  [<c06ff216>] ? cpuidle_idle_call+0xa9/0xe6
[   15.428417]  [<c07000f4>] ? ladder_select_state+0x18c/0x18c
[   15.428417]  [<c0408011>] ? arch_cpu_idle+0x8/0x1c
[   15.428417]  [<c046621e>] ? cpu_startup_entry+0xe2/0x160
[   15.428417]  [<c07e3b10>] ? rest_init+0x9c/0xa1
[   15.428417]  [<c0a1997e>] ? start_kernel+0x34d/0x352
[   15.428417]  [<c0a192c3>] ? i386_start_kernel+0x79/0x7d
[   15.428417] handlers:
[   15.428417] [<f810717a>] usb_hcd_irq [usbcore]
[   15.428417] Disabling IRQ #16
[   16.755453] SELinux: initialized (dev sda5, type vfat), uses genfs_contexts
[   16.899311] Adding 8389624k swap on /dev/sda7.  Priority:-1 extents:1 across:8389624k 
[   17.271476] SELinux: initialized (dev sda1, type vfat), uses genfs_contexts
[   18.047018] EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
[   18.050527] SELinux: initialized (dev sda8, type ext4), uses xattr
[   18.609352] systemd-journald[267]: Received request to flush runtime journal from PID 1
[   23.678344] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   23.690006] iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
[   23.747260] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   23.757900] iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
[   23.850059] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[   23.850513] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[   23.850901] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[   23.851275] uhci_hcd 0000:00:1a.1: hcd_pci_runtime_suspend: 0
[   23.851611] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[   23.851977] uhci_hcd 0000:00:1a.2: hcd_pci_runtime_suspend: 0
[   23.856601] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[   23.856975] uhci_hcd 0000:00:1d.0: hcd_pci_runtime_suspend: 0
[   23.857314] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[   23.857679] uhci_hcd 0000:00:1d.1: hcd_pci_runtime_suspend: 0
[   23.858039] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[   23.858405] uhci_hcd 0000:00:1d.2: hcd_pci_runtime_suspend: 0
[   23.859105] ehci-pci 0000:00:1d.7: hcd_pci_runtime_suspend: 0
[   23.938428] atl1c 0000:02:00.0: irq 43 for MSI/MSI-X
[   24.066332] [drm:intel_crtc_cursor_set], cursor off
[   24.066345] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[   24.066354] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   24.066361] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   24.066368] [drm:intel_crtc_cursor_set], cursor off
[   24.066374] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[   24.066380] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   24.066386] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   25.612556] wlan0: authenticate with 00:24:36:a6:21:91
[   25.631314] wlan0: send auth to 00:24:36:a6:21:91 (try 1/3)
[   25.635612] wlan0: authenticated
[   25.640423] wlan0: associate with 00:24:36:a6:21:91 (try 1/3)
[   25.646263] wlan0: RX AssocResp from 00:24:36:a6:21:91 (capab=0x1431 status=0 aid=4)
[   25.672124] wlan0: associated
[   75.816336] type=1006 audit(1389222025.787:4): pid=513 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1 res=1

