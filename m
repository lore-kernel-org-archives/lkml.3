Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaA3OyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:54:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56152 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752956AbaA3Ox4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:53:56 -0500
Date: Thu, 30 Jan 2014 09:53:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Vetter <daniel@ffwll.ch>
cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Excessive WARN()s in Intel 915 driver
In-Reply-To: <20140128194214.GH7444@phenom.ffwll.local>
Message-ID: <Pine.LNX.4.44L0.1401300950420.1208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Daniel Vetter wrote:

> I think I need a bit more debug output first. Can you please apply the
> below patch to drm-intel-nightly and then grab a drm.debug=0xe dmesg from
> boot?

The dmesg output is below.  Since you didn't say whether this should go
on top of the previous patch or in place of it, I put this in place of
the first one.

BTW, I had to fix a bug in the patch:

> @@ -9171,6 +9181,11 @@ intel_modeset_affected_pipes(struct drm_crtc *crtc, unsigned *modeset_pipes,
>  			*disable_pipes |= 1 << intel_crtc->pipe;
>  		else
>  			*prepare_pipes |= 1 << intel_crtc->pipe;
> +
> +		DRM_DEBUG_KMS("[CRTC:%d:%s]: prepare_pipes %u\n",
> +			intel_crtc->base.base.id,
> +			pipe_name(intel_crtc->pipe),
> +			*prepare_pipes);
>  	}

pipe_name() returns char, not char *.  I changed the output format 
specifier from %s to %c.

Alan Stern


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.13.0-rc8AS+ (stern@saphir.localdomain) (gcc version 4.8.2 20131212 (Red Hat 4.8.2-7) (GCC) ) #3 SMP PREEMPT Wed Jan 29 11:46:42 EST 2014
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
[    0.000000] BRK [0x01053000, 0x01053fff] PGTABLE
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
[    0.000000] BRK [0x01054000, 0x01054fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7dd9ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7dd9ffff]
[    0.000000] On node 0 totalpages: 515389
[    0.000000] free_area_init_node: node 0, pgdat c0a0ae80, node_mem_map f5aaa020
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
[    0.000000] PERCPU: Embedded 13 pages/cpu @f77c3000 s30336 r0 d22912 u53248
[    0.000000] pcpu-alloc: s30336 r0 d22912 u53248 alloc=13*4096
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
[    0.000000] Memory: 2016636K/2061556K available (4021K kernel code, 322K rwdata, 1864K rodata, 388K init, 5980K bss, 44920K reserved, 1152648K highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc0a12000 - 0xc0a73000   ( 388 kB)
      .data : 0xc07eda6f - 0xc0a11900   (2191 kB)
      .text : 0xc0400000 - 0xc07eda6f   (4022 kB)
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
[    0.000000] tsc: Detected 1299.973 MHz processor
[    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 2599.94 BogoMIPS (lpj=5199892)
[    0.004265] pid_max: default: 32768 minimum: 301
[    0.004542] Security Framework initialized
[    0.004674] SELinux:  Initializing.
[    0.004890] SELinux:  Starting in permissive mode
[    0.004924] Mount-cache hash table entries: 512
[    0.006621] Initializing cgroup subsys memory
[    0.006783] Initializing cgroup subsys devices
[    0.006940] Initializing cgroup subsys freezer
[    0.007092] Initializing cgroup subsys blkio
[    0.007222] Initializing cgroup subsys perf_event
[    0.007438] CPU: Physical Processor ID: 0
[    0.007567] CPU: Processor Core ID: 0
[    0.008013] mce: CPU supports 6 MCE banks
[    0.008150] CPU0: Thermal monitoring enabled (TM2)
[    0.008297] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
[    0.008847] Freeing SMP alternatives memory: 12K (c0a73000 - c0a76000)
[    0.008980] ACPI: Core revision 20131115
[    0.033669] ACPI: All ACPI Tables successfully acquired
[    0.036581] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.037294] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.079145] smpboot: CPU0: Genuine Intel(R) CPU           U7300  @ 1.30GHz (fam: 06, model: 17, stepping: 0a)
[    0.080000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.080000] ... version:                2
[    0.080000] ... bit width:              40
[    0.080000] ... generic registers:      2
[    0.080000] ... value mask:             000000ffffffffff
[    0.080000] ... max period:             000000007fffffff
[    0.080000] ... fixed-purpose events:   3
[    0.080000] ... event mask:             0000000700000003
[    0.108469] CPU 1 irqstacks, hard=f50c6000 soft=f50d0000
[    0.108474] x86: Booting SMP configuration:
[    0.008000] Initializing CPU#1
[    0.120444] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.108604] .... node  #0, CPUs:      #1
[    0.120875] x86: Booted up 1 node, 2 CPUs
[    0.121122] smpboot: Total of 2 processors activated (5199.89 BogoMIPS)
[    0.124798] devtmpfs: initialized
[    0.128400] PM: Registering ACPI NVS region [mem 0x7ddaf000-0x7dddffff] (200704 bytes)
[    0.128987] RTC time: 16:48:39, date: 01/29/14
[    0.129506] NET: Registered protocol family 16
[    0.130750] cpuidle: using governor ladder
[    0.132090] cpuidle: using governor menu
[    0.132596] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.132827] ACPI: bus type PCI registered
[    0.133190] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.133401] PCI: not using MMCONFIG
[    0.133790] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
[    0.133922] PCI: Using configuration type 1 for base access
[    0.139731] bio: create slab <bio-0> at 0
[    0.140221] ACPI: Added _OSI(Module Device)
[    0.140353] ACPI: Added _OSI(Processor Device)
[    0.142540] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.142671] ACPI: Added _OSI(Processor Aggregator Device)
[    0.159268] ACPI : EC: EC description table is found, configuring boot EC
[    0.185078] ACPI: Executed 1 blocks of module-level executable AML code
[    0.196037] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.208443] ACPI BIOS Warning (bug): Incorrect checksum in table [ATKG] - 0x1F, should be 0x25 (20131115/tbprint-214)
[    0.209537] ACPI: SSDT 7ddb9540 0001C4 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.213809] ACPI: Dynamic OEM Table Load:
[    0.214032] ACPI: SSDT   (null) 0001C4 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.215376] ACPI: SSDT 7ddb97a0 000765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.219599] ACPI: Dynamic OEM Table Load:
[    0.219821] ACPI: SSDT   (null) 000765 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.220930] ACPI: SSDT 7ddb9470 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.225197] ACPI: Dynamic OEM Table Load:
[    0.225419] ACPI: SSDT   (null) 0000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
[    0.226017] ACPI: SSDT 7ddb9710 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.230248] ACPI: Dynamic OEM Table Load:
[    0.230472] ACPI: SSDT   (null) 000085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
[    0.231829] ACPI: Interpreter enabled
[    0.232010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.232320] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.232703] ACPI: (supports S0 S3 S4 S5)
[    0.232831] ACPI: Using IOAPIC for interrupt routing
[    0.233065] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.241029] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.241240] PCI: Using MMCONFIG for extended config space
[    0.241411] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.242934] ACPI: No dock devices found.
[    0.288094] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.288238] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig Segments MSI]
[    0.288838] acpi PNP0A08:00: PCIe port services disabled; not requesting _OSC control
[    0.290233] PCI host bridge to bus 0000:00
[    0.290367] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.290501] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.290635] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.290770] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.290904] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.291039] pci_bus 0000:00: root bus resource [mem 0x7de00000-0xffffffff]
[    0.291258] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
[    0.291860] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
[    0.291900] pci 0000:00:02.0: reg 0x10: [mem 0xfe400000-0xfe7fffff 64bit]
[    0.291925] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.291943] pci 0000:00:02.0: reg 0x20: [io  0xdc00-0xdc07]
[    0.292497] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
[    0.292532] pci 0000:00:02.1: reg 0x10: [mem 0xfe800000-0xfe8fffff 64bit]
[    0.293069] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
[    0.293186] pci 0000:00:1a.0: reg 0x20: [io  0xd880-0xd89f]
[    0.293680] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.293960] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
[    0.294077] pci 0000:00:1a.1: reg 0x20: [io  0xd800-0xd81f]
[    0.294513] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.294793] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
[    0.294910] pci 0000:00:1a.2: reg 0x20: [io  0xd480-0xd49f]
[    0.295344] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.295644] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
[    0.295697] pci 0000:00:1a.7: reg 0x10: [mem 0xfe9fbc00-0xfe9fbfff]
[    0.295925] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.296460] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.296753] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
[    0.296800] pci 0000:00:1b.0: reg 0x10: [mem 0xfe9f4000-0xfe9f7fff 64bit]
[    0.297003] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.297285] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.297565] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
[    0.297774] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.298199] pci 0000:00:1c.5: [8086:294a] type 01 class 0x060400
[    0.298409] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.298696] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.298979] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
[    0.299096] pci 0000:00:1d.0: reg 0x20: [io  0xd400-0xd41f]
[    0.299534] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.299827] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
[    0.299944] pci 0000:00:1d.1: reg 0x20: [io  0xd080-0xd09f]
[    0.300402] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.300682] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
[    0.300799] pci 0000:00:1d.2: reg 0x20: [io  0xd000-0xd01f]
[    0.301234] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.301533] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
[    0.301587] pci 0000:00:1d.7: reg 0x10: [mem 0xfe9fb800-0xfe9fbbff]
[    0.301814] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.302277] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.302555] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.302948] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.303220] pci 0000:00:1f.0: [8086:2917] type 00 class 0x060100
[    0.303834] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
[    0.303890] pci 0000:00:1f.2: reg 0x10: [io  0xcc00-0xcc07]
[    0.303915] pci 0000:00:1f.2: reg 0x14: [io  0xc880-0xc883]
[    0.303939] pci 0000:00:1f.2: reg 0x18: [io  0xc800-0xc807]
[    0.303963] pci 0000:00:1f.2: reg 0x1c: [io  0xc480-0xc483]
[    0.303988] pci 0000:00:1f.2: reg 0x20: [io  0xc400-0xc41f]
[    0.304024] pci 0000:00:1f.2: reg 0x24: [mem 0xfe9fb000-0xfe9fb7ff]
[    0.304168] pci 0000:00:1f.2: PME# supported from D3hot
[    0.304926] pci 0000:01:00.0: [8086:0083] type 00 class 0x028000
[    0.305097] pci 0000:01:00.0: reg 0x10: [mem 0xfeafe000-0xfeafffff 64bit]
[    0.305896] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.306177] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.306321] pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.306584] pci 0000:02:00.0: [1969:1062] type 00 class 0x020000
[    0.306637] pci 0000:02:00.0: reg 0x10: [mem 0xfebc0000-0xfebfffff 64bit]
[    0.306666] pci 0000:02:00.0: reg 0x18: [io  0xec00-0xec7f]
[    0.306899] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.306996] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.307246] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.307384] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.307396] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.307649] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.307808] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.307815] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.307822] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.307828] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.307835] pci 0000:00:1e.0:   bridge window [mem 0x7de00000-0xffffffff] (subtractive decode)
[    0.307930] pci_bus 0000:00: on NUMA node 0
[    0.313214] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
[    0.314054] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 *10 12)
[    0.314747] ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
[    0.315252] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 12)
[    0.315991] ACPI: PCI Interrupt Link [LNKE] (IRQs 6) *0, disabled.
[    0.316554] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 12)
[    0.317343] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 10 12)
[    0.318132] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 7 10 12)
[    0.321018] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.321257] ACPI: \_SB_.PCI0: notify handler is installed
[    0.321656] Found 1 acpi root devices
[    0.322198] ACPI : EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
[    0.322807] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.322807] vgaarb: loaded
[    0.322807] vgaarb: bridge control possible 0000:00:02.0
[    0.322807] SCSI subsystem initialized
[    0.324098] libata version 3.00 loaded.
[    0.324203] PCI: Using ACPI for IRQ routing
[    0.324337] PCI: pci_cache_line_size set to 64 bytes
[    0.324509] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.324525] e820: reserve RAM buffer [mem 0x7dda0000-0x7fffffff]
[    0.325795] cfg80211: Calling CRDA to update world regulatory domain
[    0.326360] NetLabel: Initializing
[    0.326488] NetLabel:  domain hash size = 128
[    0.326616] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.326836] NetLabel:  unlabeled traffic allowed by default
[    0.327030] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.327030] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.328226] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.330470] Switched to clocksource hpet
[    0.330470] pnp: PnP ACPI init
[    0.330470] ACPI: bus type PNP registered
[    0.330470] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.330470] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.330470] pnp 00:01: [dma 4]
[    0.330470] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.330470] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.330470] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.330470] pnp 00:04: Plug and Play ACPI device, IDs SYN0a06 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    0.330470] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.330470] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.330980] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.331120] system 00:07: [io  0x0800-0x087f] could not be reserved
[    0.331261] system 00:07: [io  0x0400-0x041f] has been reserved
[    0.331397] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.331533] system 00:07: [mem 0xfe9fac00-0xfe9facff window] has been reserved
[    0.331744] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.331880] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.332037] system 00:07: [mem 0xfed45000-0xfed89fff] has been reserved
[    0.332174] system 00:07: [mem 0xfed90000-0xfed90fff] has been reserved
[    0.332312] system 00:07: [mem 0xfed91000-0xfed91fff] has been reserved
[    0.332449] system 00:07: [mem 0xfed92000-0xfed92fff] has been reserved
[    0.332584] system 00:07: [mem 0xfed93000-0xfed93fff] has been reserved
[    0.332721] system 00:07: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.332858] system 00:07: [mem 0xfff00000-0xffffffff] has been reserved
[    0.332998] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.333278] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.333574] system 00:09: [mem 0xffa00000-0xffbfffff] could not be reserved
[    0.333715] system 00:09: [mem 0xffe00000-0xffffffff] could not be reserved
[    0.333857] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.334108] system 00:0a: [mem 0xffc00000-0xffdfffff] has been reserved
[    0.334251] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.334531] system 00:0b: [io  0x0250-0x0253] has been reserved
[    0.334668] system 00:0b: [io  0x0256-0x025f] has been reserved
[    0.334805] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.334943] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.335080] system 00:0b: [mem 0xfec10000-0xfec17fff] has been reserved
[    0.335218] system 00:0b: [mem 0xfec38000-0xfec3ffff] has been reserved
[    0.335359] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.335647] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.335790] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.336992] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.337131] system 00:0d: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.337269] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.337408] system 00:0d: [mem 0x00100000-0x7ddfffff] could not be reserved
[    0.337550] system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.338046] pnp: PnP ACPI: found 14 devices
[    0.338176] ACPI: bus type PNP unregistered
[    0.382348] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.382377] pci 0000:00:1c.5: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.382389] pci 0000:00:1c.5: BAR 9: assigned [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.382601] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.382742] pci 0000:00:1c.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.382893] pci 0000:00:1c.5: PCI bridge to [bus 02]
[    0.383028] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.383170] pci 0000:00:1c.5:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.383310] pci 0000:00:1c.5:   bridge window [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.383530] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.383685] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.383691] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.383697] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.383703] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.383708] pci_bus 0000:00: resource 8 [mem 0x7de00000-0xffffffff]
[    0.383715] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.383721] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.383727] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.383733] pci_bus 0000:02: resource 2 [mem 0x7de00000-0x7dffffff 64bit pref]
[    0.383739] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.383745] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.383750] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.383756] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.383762] pci_bus 0000:03: resource 8 [mem 0x7de00000-0xffffffff]
[    0.383857] NET: Registered protocol family 2
[    0.384779] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.384996] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.386338] TCP: Hash tables configured (established 8192 bind 8192)
[    0.386545] TCP: reno registered
[    0.386679] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.386970] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.387634] NET: Registered protocol family 1
[    0.387795] pci 0000:00:02.0: Boot video device
[    0.388127] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.388133] pci 0000:00:1a.0: Performing full reset
[    0.388688] pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.388693] pci 0000:00:1a.1: Performing full reset
[    0.389242] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.389247] pci 0000:00:1a.2: Performing full reset
[    0.390362] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
[    0.390368] pci 0000:00:1d.0: Performing full reset
[    0.390904] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.390910] pci 0000:00:1d.1: Performing full reset
[    0.391445] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.391451] pci 0000:00:1d.2: Performing full reset
[    0.392329] PCI: CLS 32 bytes, default 64
[    0.392745] Unpacking initramfs...
[    1.018343] Freeing initrd memory: 11020K (f6a6a000 - f752d000)
[    1.041104] DMA-API: preallocated 65536 debug entries
[    1.041241] DMA-API: debugging enabled by kernel config
[    1.041695] Simple Boot Flag at 0x51 set to 0x1
[    1.043068] Scanning for low memory corruption every 60 seconds
[    1.044232] audit: initializing netlink socket (disabled)
[    1.044435] type=2000 audit(1391014120.044:1): initialized
[    1.045473] bounce pool size: 64 pages
[    1.051948] VFS: Disk quotas dquot_6.5.2
[    1.052262] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.054123] fuse init (API version 7.22)
[    1.054618] msgmni has been set to 1709
[    1.055130] SELinux:  Registering netfilter hooks
[    1.057505] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.057741] io scheduler noop registered
[    1.057869] io scheduler deadline registered
[    1.058157] io scheduler cfq registered (default)
[    1.058760] intel_idle: does not run on family 6 model 23
[    1.059818] ACPI: AC Adapter [AC0] (on-line)
[    1.060296] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    1.060583] ACPI: Sleep Button [SLPB]
[    1.060914] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.067270] ACPI: Lid Switch [LID]
[    1.067673] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.067889] ACPI: Power Button [PWRF]
[    1.069282] Monitor-Mwait will be used to enter C-1 state
[    1.069307] Monitor-Mwait will be used to enter C-3 state
[    1.069436] tsc: Marking TSC unstable due to TSC halts in idle
[    1.069629] ACPI: acpi_idle registered with cpuidle
[    1.076489] thermal LNXTHERM:00: registered as thermal_zone0
[    1.076623] ACPI: Thermal Zone [THRM] (48 C)
[    1.076999] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.080190] Non-volatile memory driver v1.3
[    1.080380] Linux agpgart interface v0.103
[    1.081055] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    1.083429] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.085668] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.086260] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.086581] [drm] Initialized drm 1.1.0 20060810
[    1.090469] [drm:i915_dump_device_info], i915 device info: gen=4, pciid=0x2a42 flags=is_mobile,need_gfx_hws,is_g4x,has_fbc,has_pipe_cxsr,has_hotplug,supports_tv,
[    1.090660] [drm:intel_detect_pch], No PCH found?
[    1.090667] [drm] Memory usable by graphics device = 2048M
[    1.090841] [drm:i915_gem_gtt_init], GMADR size = 256M
[    1.090846] [drm:i915_gem_gtt_init], GTT stolen size = 32M
[    1.092129] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7ddaf0e4
[    1.092148] [drm:intel_opregion_setup], Public ACPI methods supported
[    1.092152] [drm:intel_opregion_setup], SWSCI supported
[    1.116094] [drm:swsci_setup], SWSCI BIOS requested (00000241) SBCB callbacks that are not supported (000000c1)
[    1.116100] [drm:swsci_setup], SWSCI GBDA callbacks 000004f3, SBCB callbacks 00000241
[    1.116105] [drm:intel_opregion_setup], ASLE supported
[    1.116390] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.116419] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.116554] [drm] Driver supports precise vblank timestamp query.
[    1.116714] [drm:init_vbt_defaults], Set default to SSC at 100000 kHz
[    1.116721] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT CANTIGA        d
[    1.116728] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 96000 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    1.116778] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    1.116786] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.116794] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 0 71900 1366 1414 1480 1486 768 774 782 806 0x8 0xa
[    1.116800] [drm:parse_lfp_panel_data], VBT initial LVDS value 4200033c
[    1.116806] [drm:parse_lfp_backlight], VBT backlight PWM modulation frequency 200 Hz, active high, min brightness 0, level 50
[    1.116813] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    1.116820] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    1.116825] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.116831] [drm:parse_mipi], No MIPI BDB found
[    1.116857] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    1.116904] [drm:i915_gem_init_stolen], found 33554432 bytes of stolen memory at 7e000000
[    1.117365] [drm:intel_modeset_init], 2 display pipes available.
[    1.117449] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    1.117464] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    1.117478] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.144353] ACPI: Battery Slot [BAT0] (battery present)
[    1.200136] [drm:intel_lvds_init], using preferred mode from EDID: 
[    1.200144] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.200156] [drm:intel_lvds_init], detected single-link lvds configuration
[    1.200547] [drm:intel_panel_setup_backlight], backlight initialized, enabled, brightness 1398348/1992060, sysfs interface registered
[    1.200706] [drm:intel_dp_init_connector], Adding DP connector on port D
[    1.200823] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    1.201615] [drm:i965_irq_handler] *ERROR* pipe B underrun
[    1.203826] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x71450064
[    1.203842] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.206396] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x71450064
[    1.206413] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.206517] [drm:intel_tv_init], Integrated TV is not present.
[    1.206526] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, 7ffff000]
[    1.211034] [drm:init_status_page], render ring hws offset: 0x00001000
[    1.211041] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    1.211049] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[    1.211187] [drm:init_status_page], bsd ring hws offset: 0x00024000
[    1.211193] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    1.211200] [drm:i915_pages_create_for_stolen], offset=0x20000, size=131072
[    1.211296] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
[    1.211317] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
[    1.211326] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
[    1.211334] [drm:intel_modeset_readout_hw_state], [ENCODER:12:DAC-12] hw state readout: enabled, pipe B
[    1.211342] [drm:intel_modeset_readout_hw_state], [ENCODER:13:TMDS-13] hw state readout: disabled, pipe A
[    1.211349] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
[    1.211356] [drm:intel_modeset_readout_hw_state], [CONNECTOR:11:VGA-1] hw state readout: enabled
[    1.211362] [drm:intel_modeset_readout_hw_state], [CONNECTOR:14:DP-1] hw state readout: disabled
[    1.211371] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    1.211375] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.211380] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    1.211386] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.211393] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.211397] [drm:intel_dump_pipe_config], requested mode:
[    1.211404] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.211408] [drm:intel_dump_pipe_config], adjusted mode:
[    1.211415] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.211421] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
[    1.211426] [drm:intel_dump_pipe_config], port clock: 0
[    1.211430] [drm:intel_dump_pipe_config], pipe src size: 0x0
[    1.211435] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.211441] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.211445] [drm:intel_dump_pipe_config], ips: 0
[    1.211450] [drm:intel_dump_pipe_config], double wide: 0
[    1.211457] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    1.211461] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.211466] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.211472] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.211479] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.211483] [drm:intel_dump_pipe_config], requested mode:
[    1.211490] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.211494] [drm:intel_dump_pipe_config], adjusted mode:
[    1.211501] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.211508] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.211513] [drm:intel_dump_pipe_config], port clock: 72000
[    1.211517] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.211523] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00008000
[    1.211528] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.211533] [drm:intel_dump_pipe_config], ips: 0
[    1.211537] [drm:intel_dump_pipe_config], double wide: 0
[    1.211544] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.211552] [drm:intel_connector_check_state], [CONNECTOR:11:VGA-1]
[    1.211559] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.211565] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.211571] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.211576] [drm:check_crtc_state], [CRTC:3]
[    1.211582] [drm:check_crtc_state], [CRTC:4]
[    1.211617] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    1.211622] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    1.211638] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    1.211646] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.211652] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    1.211657] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    1.224064] [drm:intel_crt_detect], CRT not detected via hotplug
[    1.228062] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    1.228069] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.228073] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    1.228079] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    1.228441] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    1.228446] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    1.228451] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    1.228456] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    1.228462] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    1.228467] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    1.228473] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    1.228478] [drm:drm_setup_crtcs], 
[    1.228484] [drm:drm_enable_connectors], connector 5 enabled? yes
[    1.228489] [drm:drm_enable_connectors], connector 11 enabled? no
[    1.228493] [drm:drm_enable_connectors], connector 14 enabled? no
[    1.228498] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    1.228503] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    1.228508] [drm:drm_target_preferred], found mode 1366x768
[    1.228513] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    1.228520] [drm:drm_setup_crtcs], desired mode 1366x768 set on crtc 3
[    1.228529] [drm:intelfb_create], no BIOS fb, allocating a new one
[    1.228534] [drm:i915_gem_object_create_stolen], creating stolen object: size=408000
[    1.228542] [drm:i915_pages_create_for_stolen], offset=0x40000, size=4227072
[    1.230474] [drm:intelfb_create], allocated 1366x768 fb: 0x00046000, bo f52ac200
[    1.231188] fbcon: inteldrmfb (fb0) is primary device
[    1.233206] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.233211] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    1.233214] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    1.233219] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    1.233225] [drm:drm_mode_debug_printmodeline], Modeline 17:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.233228] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
[    1.233232] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.233236] [drm:intel_modeset_stage_output_state], [CONNECTOR:11:VGA-1] to [CRTC:4]
[    1.233239] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[    1.233242] [drm:intel_modeset_stage_output_state], crtc enabled, full mode switch
[    1.233247] [drm:intel_modeset_affected_pipes], [ENCODER:6:LVDS-6]: prepare_pipes 3
[    1.233250] [drm:intel_modeset_affected_pipes], [CRTC:3:A]: prepare_pipes 3
[    1.233253] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    1.233258] [drm:connected_sink_compute_bpp], [CONNECTOR:5:LVDS-1] checking for sink bpp constrains
[    1.233284] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
[    1.233288] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
[    1.233292] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    1.233294] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    1.233297] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
[    1.233302] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.233306] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.233308] [drm:intel_dump_pipe_config], requested mode:
[    1.233314] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.233316] [drm:intel_dump_pipe_config], adjusted mode:
[    1.233322] [drm:drm_mode_debug_printmodeline], Modeline 0:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    1.233327] [drm:intel_dump_crtc_timings], crtc timings: 71900 1366 1414 1480 1486 768 774 782 806, type: 0x48 flags: 0xa
[    1.233329] [drm:intel_dump_pipe_config], port clock: 71900
[    1.233332] [drm:intel_dump_pipe_config], pipe src size: 1366x768
[    1.233336] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    1.233339] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.233342] [drm:intel_dump_pipe_config], ips: 0
[    1.233344] [drm:intel_dump_pipe_config], double wide: 0
[    1.233500] [drm:i9xx_set_pipeconf], disabling CxSR downclocking
[    1.233551] [drm:i9xx_update_plane], Writing base 00046000 00000000 0 0 5504
[    1.233560] [drm:intel_update_fbc], no output, disabling
[    1.233567] [drm:intel_crtc_mode_set], [ENCODER:6:LVDS-6] set [MODE:0:1366x768]
[    1.234457] [drm:g4x_check_srwm], SR watermark: display plane 56, cursor 6
[    1.234463] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=25, cursor=6, B: plane=2, cursor=2, SR: plane=56, cursor=6
[    1.288127] [drm:intel_update_fbc], disabled per chip default
[    1.288138] [drm:intel_panel_enable_backlight], pipe A
[    1.288167] ------------[ cut here ]------------
[    1.288176] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_panel.c:714 i965_enable_backlight+0x4a/0x119()
[    1.288177] backlight already enabled
[    1.288179] Modules linked in:
[    1.288184] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc8AS+ #3
[    1.288186] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[    1.288195]  00000000 00000000 f507ba34 c07e6736 f507ba5c f507ba4c c042c880 c06806eb
[    1.288202]  f6e40000 f6e5d800 00000000 f507ba64 c042c8bd 00000009 f507ba5c c0963292
[    1.288210]  f507ba78 f507ba88 c06806eb c0963253 000002ca c0963292 e0000000 f6e41c44
[    1.288212] Call Trace:
[    1.288218]  [<c07e6736>] dump_stack+0x48/0x69
[    1.288224]  [<c042c880>] warn_slowpath_common+0x5c/0x73
[    1.288229]  [<c06806eb>] ? i965_enable_backlight+0x4a/0x119
[    1.288233]  [<c042c8bd>] warn_slowpath_fmt+0x26/0x2a
[    1.288238]  [<c06806eb>] i965_enable_backlight+0x4a/0x119
[    1.288243]  [<c068143e>] intel_panel_enable_backlight+0x98/0xb1
[    1.288248]  [<c0671278>] intel_enable_lvds+0xf0/0x10d
[    1.288252]  [<c0668db6>] i9xx_crtc_enable+0x305/0x31b
[    1.288258]  [<c0692642>] ? gen4_write64+0x3f/0x3f
[    1.288262]  [<c066b6bc>] __intel_set_mode+0xefc/0xfbe
[    1.288267]  [<c066d018>] intel_set_mode+0x12/0x2a
[    1.288272]  [<c066d764>] intel_crtc_set_config+0x663/0x958
[    1.288277]  [<c063d3b5>] drm_mode_set_config_internal+0x39/0x90
[    1.288282]  [<c063275d>] drm_fb_helper_set_par+0x49/0x88
[    1.288288]  [<c05d543c>] fbcon_init+0x2c9/0x3a5
[    1.288294]  [<c061b629>] visual_init+0x9a/0xed
[    1.288298]  [<c061c8dc>] do_bind_con_driver+0x13a/0x22f
[    1.288303]  [<c061ce0f>] do_take_over_console+0x108/0x130
[    1.288308]  [<c05d3284>] do_fbcon_takeover+0x4c/0x90
[    1.288312]  [<c05d5a6a>] fbcon_event_notify+0x273/0x551
[    1.288317]  [<c04448e9>] ? __blocking_notifier_call_chain+0x1e/0x4a
[    1.288322]  [<c044472c>] notifier_call_chain+0x25/0x46
[    1.288326]  [<c04448fd>] __blocking_notifier_call_chain+0x32/0x4a
[    1.288331]  [<c0444921>] blocking_notifier_call_chain+0xc/0xe
[    1.288337]  [<c05cba0b>] fb_notifier_call_chain+0x11/0x16
[    1.288342]  [<c05ccc90>] register_framebuffer+0x1fe/0x251
[    1.288347]  [<c06325f3>] drm_fb_helper_initial_config+0x31d/0x3a9
[    1.288352]  [<c07eb9d9>] ? _raw_spin_unlock_irqrestore+0x33/0x49
[    1.288358]  [<c069747d>] intel_fbdev_initial_config+0x19/0x1b
[    1.288363]  [<c0648c99>] i915_driver_load+0x8d9/0xb0f
[    1.288369]  [<c0638fca>] drm_dev_register+0xb6/0x119
[    1.288373]  [<c063aa10>] drm_get_pci_dev+0xe7/0x182
[    1.288377]  [<c0646712>] i915_pci_probe+0x39/0x42
[    1.288382]  [<c05c36eb>] pci_device_probe+0x57/0x9f
[    1.288388]  [<c06a10e2>] driver_probe_device+0x7f/0x16f
[    1.288392]  [<c06a124c>] __driver_attach+0x4e/0x6a
[    1.288396]  [<c069fd5c>] bus_for_each_dev+0x39/0x65
[    1.288401]  [<c06a0d3b>] driver_attach+0x14/0x16
[    1.288405]  [<c06a11fe>] ? __device_attach+0x2c/0x2c
[    1.288408]  [<c06a0a6a>] bus_add_driver+0xb6/0x183
[    1.288413]  [<c06a16bd>] driver_register+0x6f/0xa4
[    1.288417]  [<c05c2b2d>] __pci_register_driver+0x45/0x48
[    1.288422]  [<c0a330d5>] ? drm_core_init+0xe8/0xe8
[    1.288426]  [<c063aafc>] drm_pci_init+0x51/0xc5
[    1.288430]  [<c0a330d5>] ? drm_core_init+0xe8/0xe8
[    1.288434]  [<c0a33137>] i915_init+0x62/0x64
[    1.288438]  [<c04003e7>] do_one_initcall+0x79/0x102
[    1.288443]  [<c043fe39>] ? parameq+0x1c/0x20
[    1.288446]  [<c043ffa3>] ? parse_args+0x166/0x204
[    1.288453]  [<c0a12aef>] kernel_init_freeable+0x16c/0x1f6
[    1.288457]  [<c07e11d5>] kernel_init+0x8/0xda
[    1.288462]  [<c07ec937>] ret_from_kernel_thread+0x1b/0x28
[    1.288466]  [<c07e11cd>] ? rest_init+0xa1/0xa1
[    1.288525] ---[ end trace 2c676d40ee89ce2b ]---
[    1.288529] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[    1.288549] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.288556] [drm:intel_connector_check_state], [CONNECTOR:11:VGA-1]
[    1.288562] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.288567] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.288572] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.288577] [drm:check_crtc_state], [CRTC:3]
[    1.288601] [drm:check_crtc_state], [CRTC:4]
[    1.288623] [drm:asle_work], No request on ASLC interrupt 0x00000000
[    1.288627] [drm:intel_pipe_config_compare] *ERROR* mismatch in gmch_pfit.lvds_border_bits (expected 32768, found 0)
[    1.288629] ------------[ cut here ]------------
[    1.288634] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_display.c:9573 check_crtc_state+0x7b1/0x7f3()
[    1.288636] pipe state doesn't match!
[    1.288639] Modules linked in:
[    1.288643] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.13.0-rc8AS+ #3
[    1.288646] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[    1.288659]  00000000 00000000 f507b890 c07e6736 f507b8b8 f507b8a8 c042c880 c0662aea
[    1.288671]  f50d9000 f6e03800 00000000 f507b8c0 c042c8bd 00000009 f507b8b8 c095db4f
[    1.288683]  f507b8d4 f507bb28 c0662aea c095c87c 00002565 c095db4f f6e03b90 f6e03b04
[    1.288684] Call Trace:
[    1.288690]  [<c07e6736>] dump_stack+0x48/0x69
[    1.288695]  [<c042c880>] warn_slowpath_common+0x5c/0x73
[    1.288700]  [<c0662aea>] ? check_crtc_state+0x7b1/0x7f3
[    1.288705]  [<c042c8bd>] warn_slowpath_fmt+0x26/0x2a
[    1.288710]  [<c0662aea>] check_crtc_state+0x7b1/0x7f3
[    1.288721]  [<c066cd67>] intel_modeset_check_state+0x2fb/0x552
[    1.288726]  [<c066d027>] intel_set_mode+0x21/0x2a
[    1.288731]  [<c066d764>] intel_crtc_set_config+0x663/0x958
[    1.288737]  [<c063d3b5>] drm_mode_set_config_internal+0x39/0x90
[    1.288742]  [<c063275d>] drm_fb_helper_set_par+0x49/0x88
[    1.288748]  [<c05d543c>] fbcon_init+0x2c9/0x3a5
[    1.288753]  [<c061b629>] visual_init+0x9a/0xed
[    1.288759]  [<c061c8dc>] do_bind_con_driver+0x13a/0x22f
[    1.288765]  [<c061ce0f>] do_take_over_console+0x108/0x130
[    1.288770]  [<c05d3284>] do_fbcon_takeover+0x4c/0x90
[    1.288775]  [<c05d5a6a>] fbcon_event_notify+0x273/0x551
[    1.288780]  [<c04448e9>] ? __blocking_notifier_call_chain+0x1e/0x4a
[    1.288786]  [<c044472c>] notifier_call_chain+0x25/0x46
[    1.288791]  [<c04448fd>] __blocking_notifier_call_chain+0x32/0x4a
[    1.288796]  [<c0444921>] blocking_notifier_call_chain+0xc/0xe
[    1.288802]  [<c05cba0b>] fb_notifier_call_chain+0x11/0x16
[    1.288807]  [<c05ccc90>] register_framebuffer+0x1fe/0x251
[    1.288813]  [<c06325f3>] drm_fb_helper_initial_config+0x31d/0x3a9
[    1.288819]  [<c07eb9d9>] ? _raw_spin_unlock_irqrestore+0x33/0x49
[    1.288826]  [<c069747d>] intel_fbdev_initial_config+0x19/0x1b
[    1.288831]  [<c0648c99>] i915_driver_load+0x8d9/0xb0f
[    1.288837]  [<c0638fca>] drm_dev_register+0xb6/0x119
[    1.288843]  [<c063aa10>] drm_get_pci_dev+0xe7/0x182
[    1.288848]  [<c0646712>] i915_pci_probe+0x39/0x42
[    1.288853]  [<c05c36eb>] pci_device_probe+0x57/0x9f
[    1.288858]  [<c06a10e2>] driver_probe_device+0x7f/0x16f
[    1.288863]  [<c06a124c>] __driver_attach+0x4e/0x6a
[    1.288868]  [<c069fd5c>] bus_for_each_dev+0x39/0x65
[    1.288873]  [<c06a0d3b>] driver_attach+0x14/0x16
[    1.288878]  [<c06a11fe>] ? __device_attach+0x2c/0x2c
[    1.288883]  [<c06a0a6a>] bus_add_driver+0xb6/0x183
[    1.288888]  [<c06a16bd>] driver_register+0x6f/0xa4
[    1.288893]  [<c05c2b2d>] __pci_register_driver+0x45/0x48
[    1.288898]  [<c0a330d5>] ? drm_core_init+0xe8/0xe8
[    1.288904]  [<c063aafc>] drm_pci_init+0x51/0xc5
[    1.288908]  [<c0a330d5>] ? drm_core_init+0xe8/0xe8
[    1.288913]  [<c0a33137>] i915_init+0x62/0x64
[    1.288918]  [<c04003e7>] do_one_initcall+0x79/0x102
[    1.288922]  [<c043fe39>] ? parameq+0x1c/0x20
[    1.288927]  [<c043ffa3>] ? parse_args+0x166/0x204
[    1.288933]  [<c0a12aef>] kernel_init_freeable+0x16c/0x1f6
[    1.288938]  [<c07e11d5>] kernel_init+0x8/0xda
[    1.288943]  [<c07ec937>] ret_from_kernel_thread+0x1b/0x28
[    1.288948]  [<c07e11cd>] ? rest_init+0xa1/0xa1
[    1.288951] ---[ end trace 2c676d40ee89ce2c ]---
[    1.288955] [drm:intel_dump_pipe_config], [CRTC:4][hw state] config for pipe B
[    1.288957] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.288960] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.288965] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.288969] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.288971] [drm:intel_dump_pipe_config], requested mode:
[    1.288976] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.288979] [drm:intel_dump_pipe_config], adjusted mode:
[    1.288983] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.288989] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.288991] [drm:intel_dump_pipe_config], port clock: 72000
[    1.288994] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.288998] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00000000
[    1.289002] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.289004] [drm:intel_dump_pipe_config], ips: 0
[    1.289007] [drm:intel_dump_pipe_config], double wide: 0
[    1.289010] [drm:intel_dump_pipe_config], [CRTC:4][sw state] config for pipe B
[    1.289012] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    1.289015] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    1.289020] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.289024] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    1.289026] [drm:intel_dump_pipe_config], requested mode:
[    1.289031] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 400 0 0 0 0x0 0x0
[    1.289033] [drm:intel_dump_pipe_config], adjusted mode:
[    1.289038] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
[    1.289043] [drm:intel_dump_crtc_timings], crtc timings: 72000 1366 1414 1480 1486 768 774 782 806, type: 0x0 flags: 0xa
[    1.289046] [drm:intel_dump_pipe_config], port clock: 72000
[    1.289049] [drm:intel_dump_pipe_config], pipe src size: 640x400
[    1.289052] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0855077f, lvds border: 0x00008000
[    1.289056] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    1.289058] [drm:intel_dump_pipe_config], ips: 0
[    1.289061] [drm:intel_dump_pipe_config], double wide: 0
[    1.289067] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    1.289073] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    1.289077] [drm:intel_modeset_stage_output_state], [CONNECTOR:11:VGA-1] to [NOCRTC]
[    1.289080] [drm:intel_modeset_stage_output_state], encoder changed, full mode switch
[    1.289083] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.289086] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
[    1.289089] [drm:intel_modeset_stage_output_state], crtc disabled, full mode switch
[    1.289093] [drm:intel_modeset_affected_pipes], [CONNECTOR:11:VGA-1]: prepare_pipes 2
[    1.289097] [drm:intel_modeset_affected_pipes], [ENCODER:12:DAC-12]: prepare_pipes 2
[    1.289100] [drm:intel_modeset_affected_pipes], [CRTC:4:B]: prepare_pipes 2
[    1.289104] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[    1.304131] [drm:i9xx_pfit_disable], disabling pfit, current: 0xa0000000
[    1.304141] [drm:g4x_check_srwm], SR watermark: display plane 56, cursor 6
[    1.304147] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=25, cursor=6, B: plane=2, cursor=2, SR: plane=56, cursor=6
[    1.304166] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
[    1.304173] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
[    1.304178] [drm:check_encoder_state], [ENCODER:12:DAC-12]
[    1.304182] [drm:check_encoder_state], [ENCODER:13:TMDS-13]
[    1.304186] [drm:check_crtc_state], [CRTC:3]
[    1.304208] [drm:check_crtc_state], [CRTC:4]
[    1.304254] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.304260] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.304264] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.316828] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.316834] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.316838] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.328977] Console: switching to colour frame buffer device 170x48
[    1.328988] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    1.328994] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    1.328998] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    1.697472] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.700441] i915 0000:00:02.0: registered panic notifier
[    1.703853] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    1.707843] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.710985] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.718117] loop: module loaded
[    1.721373] ACPI Warning: 0x00000828-0x0000082f SystemIO conflicts with Region \PMIO 1 (20131115/utaddress-251)
[    1.724665] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.728038] ACPI Warning: 0x00000530-0x0000053f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[    1.731546] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.735136] ACPI Warning: 0x00000500-0x0000052f SystemIO conflicts with Region \GPIO 1 (20131115/utaddress-251)
[    1.738823] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.742625] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    1.746738] ahci 0000:00:1f.2: version 3.0
[    1.747198] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.747331] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    1.751154] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x1 impl SATA mode
[    1.754974] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    1.761192] scsi0 : ahci
[    1.765546] scsi1 : ahci
[    1.769601] scsi2 : ahci
[    1.773627] scsi3 : ahci
[    1.777468] ata1: SATA max UDMA/133 abar m2048@0xfe9fb000 port 0xfe9fb100 irq 41
[    1.781249] ata2: DUMMY
[    1.784981] ata3: DUMMY
[    1.788670] ata4: DUMMY
[    1.792742] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.799803] i8042: Detected active multiplexing controller, rev 1.1
[    1.805172] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.809539] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.813545] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.817486] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.821387] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.825574] mousedev: PS/2 mouse device common for all mice
[    1.830916] rtc_cmos 00:02: RTC can wake from S4
[    1.835350] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.839188] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.843066] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    1.847068] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0860)
[    1.851589] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.855554] iTCO_vendor_support: vendor-support=0
[    1.859932] asus_laptop: Asus Laptop Support version 0.42
[    1.864236] asus_laptop:   UL20A model detected
[    1.870159] [drm:asle_set_backlight], bclp = 0x800000b3
[    1.870180] [drm:asle_set_backlight], updating opregion backlight 179/255
[    1.870197] [drm:intel_panel_actually_set_backlight], set backlight PWM = 1398348
[    1.870242] [drm:asle_work], No request on ASLC interrupt 0x00000000
[    1.870333] input: Asus Laptop extra buttons as /devices/platform/asus_laptop/input/input5
[    1.875058] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.053333] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.058394] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.063035] TCP: cubic registered
[    2.067250] Initializing XFRM netlink socket
[    2.071499] NET: Registered protocol family 17
[    2.075758] NET: Registered protocol family 15
[    2.080700] Using IPI No-Shortcut mode
[    2.085364] registered taskstats version 1
[    2.091336]   Magic number: 14:632:844
[    2.095379] rtc_cmos 00:02: setting system clock to 2014-01-29 16:48:41 UTC (1391014121)
[    2.101346] PM: Hibernation image not present or could not be loaded.
[    2.112275] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.120996] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.127337] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.127349] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.179355] ata1.00: ATA-8: ST9250315AS, 0002SDM1, max UDMA/133
[    2.185067] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.194881] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.200858] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[    2.200870] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.208284] ata1.00: configured for UDMA/133
[    2.215750] scsi 0:0:0:0: Direct-Access     ATA      ST9250315AS      0002 PQ: 0 ANSI: 5
[    2.222420] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.222820] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.229614] sd 0:0:0:0: [sda] Write Protect is off
[    2.235159] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.235284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.312074]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
[    2.322110] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.328193] Freeing unused kernel memory: 388K (c0a12000 - c0a73000)
[    2.332239] Write protecting the kernel text: 4024k
[    2.335991] Write protecting the kernel read-only data: 1868k
[    2.366004] systemd[1]: systemd 197 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    2.373086] systemd[1]: Running in initial RAM disk.
[    2.389985] systemd[1]: Failed to insert module 'autofs4'
[    2.394017] systemd[1]: No hostname configured.
[    2.398020] systemd[1]: Set hostname to <localhost>.
[    2.402435] random: systemd urandom read with 20 bits of entropy available
[    2.406452] systemd[1]: Initializing machine ID from random generator.
[    2.435984] systemd[1]: Starting Encrypted Volumes.
[    2.444541] systemd[1]: Reached target Encrypted Volumes.
[    2.448826] systemd[1]: Starting udev Kernel Socket.
[    2.457130] systemd[1]: Listening on udev Kernel Socket.
[    2.461267] systemd[1]: Starting udev Control Socket.
[    2.469643] systemd[1]: Listening on udev Control Socket.
[    2.473546] systemd[1]: Starting Journal Socket.
[    2.481931] systemd[1]: Listening on Journal Socket.
[    2.485755] systemd[1]: Starting dracut cmdline hook...
[    2.496707] systemd[1]: Started Load Kernel Modules.
[    2.500597] systemd[1]: Starting Journal Service...
[    2.520928] systemd[1]: Started Journal Service.
[    2.528328] systemd[1]: Starting Sockets.
[    2.540782] systemd[1]: Reached target Sockets.
[    2.544551] systemd[1]: Starting Swap.
[    2.560383] systemd[1]: Reached target Swap.
[    2.563998] systemd[1]: Starting Local File Systems.
[    2.576133] systemd[1]: Reached target Local File Systems.
[    2.748266] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    2.748274] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    2.748279] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    2.805068] systemd-udevd[125]: starting version 197
[    2.991869] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 600854
[    3.043820] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input13
[    3.259506] [drm:i915_gem_open], 
[    3.259798] [drm:intel_crtc_cursor_set], cursor off
[    3.259815] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    3.259824] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.259831] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.259838] [drm:intel_crtc_cursor_set], cursor off
[    3.259844] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.259850] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.259856] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.259913] [drm:i915_gem_open], 
[    3.259952] [drm:intel_crtc_cursor_set], cursor off
[    3.259959] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[    3.259966] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.259972] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.259978] [drm:intel_crtc_cursor_set], cursor off
[    3.259983] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.259990] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.259995] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[    3.261756] [drm:i915_gem_open], 
[    3.262048] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    3.262083] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[    3.262107] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    3.262121] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
[    3.262126] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
[    3.262145] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
[    3.262153] [drm:drm_mode_debug_printmodeline], Modeline 8:"1366x768" 60 71900 1366 1414 1480 1486 768 774 782 806 0x48 0xa
[    3.262163] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[    3.280077] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    3.280090] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    3.280097] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    3.288093] [drm:intel_crt_detect], CRT not detected via hotplug
[    3.292186] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.292194] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.292199] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.292205] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.292550] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.292555] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.292560] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    3.292566] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    3.292582] [drm:drm_mode_getconnector], [CONNECTOR:11:?]
[    3.292590] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1]
[    3.292595] [drm:intel_crt_detect], [CONNECTOR:11:VGA-1] force=1
[    3.300048] [drm:intel_crt_detect], CRT not detected via hotplug
[    3.304211] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.304219] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.304224] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.304229] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.304577] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.304582] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.304586] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    3.304593] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:11:VGA-1] disconnected
[    3.304616] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    3.304624] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    3.304629] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    3.304635] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    3.304644] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[    3.304650] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    3.304655] [drm:intel_dp_detect], [CONNECTOR:14:DP-1]
[    3.304660] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[    3.304911] [drm:drm_mode_addfb], [FB:19]
[    3.662583] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    4.835366] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    4.941292] random: nonblocking pool is initialized
[    5.300807] systemd-journald[64]: Received SIGTERM
[    6.962094] type=1404 audit(1391014126.364:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    7.364711] SELinux: 2048 avtab hash slots, 96503 rules.
[    7.429096] SELinux: 2048 avtab hash slots, 96503 rules.
[    7.500336] SELinux:  8 users, 83 roles, 4702 types, 269 bools, 1 sens, 1024 cats
[    7.500345] SELinux:  83 classes, 96503 rules
[    7.524101] SELinux:  Completing initialization.
[    7.524107] SELinux:  Setting up existing superblocks.
[    7.524306] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    7.524483] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    7.524674] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    7.524776] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    7.525230] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.525416] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    7.527746] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    7.527900] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    7.528449] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    7.528605] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    7.528749] SELinux: initialized (dev aio, type aio), not configured for labeling
[    7.528853] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    7.529070] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    7.529225] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    7.529389] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    7.533297] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    7.533345] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.533363] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.533637] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    7.533833] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.533898] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.533950] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.534131] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.534205] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.534238] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.534265] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.534337] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    7.534481] SELinux: initialized (dev sda6, type ext4), uses xattr
[    7.608722] type=1403 audit(1391014127.012:3): policy loaded auid=4294967295 ses=4294967295
[    7.762078] systemd[1]: Successfully loaded SELinux policy in 869.583ms.
[    8.084880] systemd[1]: Relabelled /dev and /run in 53.094ms.
[   11.124360] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   11.882017] systemd-journald[286]: Vacuuming done, freed 0 bytes
[   13.257617] systemd-udevd[304]: starting version 208
[   13.335655] EXT4-fs (sda6): re-mounted. Opts: (null)
[   14.641928] ACPI: bus type USB registered
[   14.645742] usbcore: registered new interface driver usbfs
[   14.651292] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[   14.654516] Copyright(c) 2003-2013 Intel Corporation
[   14.660687] iwlwifi 0000:01:00.0: irq 42 for MSI/MSI-X
[   14.661058] usbcore: registered new interface driver hub
[   14.672361] usbcore: registered new device driver usb
[   14.739232] iwlwifi 0000:01:00.0: loaded firmware version 39.31.5.1 build 35138 op_mode iwldvm
[   14.761399] atl1c 0000:02:00.0: version 1.0.1.1-NAPI
[   14.776058] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   14.779377] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   14.783024] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   14.787518] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   14.791519] uhci_hcd: USB Universal Host Controller Interface driver
[   14.792247] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   14.799686] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   14.816732] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   14.817688] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   14.828225] uhci_hcd 0000:00:1a.0: detected 2 ports
[   14.832353] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   14.832514] uhci_hcd 0000:00:1a.0: Performing full reset
[   14.832934] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   14.833960] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000d880
[   14.839000] usb usb1: default language 0x0409
[   14.839103] usb usb1: udev 1, busnum 1, minor = 0
[   14.839115] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   14.845069] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   14.850964] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[   14.854631] ehci_hcd: block sizes: qh 80 qtd 96 itd 160 sitd 96
[   14.855380] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.859360] usb usb1: Product: UHCI Host Controller
[   14.863440] ehci-pci: EHCI PCI platform driver
[   14.867311] usb usb1: Manufacturer: Linux 3.13.0-rc8AS+ uhci_hcd
[   14.870934] usb usb1: SerialNumber: 0000:00:1a.0
[   14.877192] usb usb1: usb_probe_device
[   14.877206] usb usb1: configuration #1 chosen from 1 choice
[   14.879702] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   14.881802] hub 1-0:1.0: usb_probe_interface
[   14.881814] hub 1-0:1.0: usb_probe_interface - got id
[   14.881846] hub 1-0:1.0: USB hub found
[   14.887337] hub 1-0:1.0: 2 ports detected
[   14.891033] hub 1-0:1.0: standalone hub
[   14.891043] hub 1-0:1.0: no power switching (usb 1.0)
[   14.891048] hub 1-0:1.0: individual port over-current protection
[   14.891060] hub 1-0:1.0: power on to power good time: 2ms
[   14.891901] hub 1-0:1.0: local power source is good
[   14.895315] usb usb1: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.895327] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   14.898446] usb usb1: unregistering interface 1-0:1.0
[   14.903273] usb usb1: usb_disable_device nuking non-ep0 URBs
[   14.904110] usb usb1: bus auto-suspend, wakeup 0
[   14.904118] usb usb1: suspend_rh
[   14.904237] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   14.908197] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 2
[   14.911820] ehci-pci 0000:00:1a.7: debug port 1
[   14.915521] ehci-pci 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   14.915535] ehci-pci 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   14.915755] ehci-pci 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   14.919658] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
[   14.919668] ehci-pci 0000:00:1a.7: supports USB remote wakeup
[   14.919756] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfe9fbc00
[   14.923387] ehci-pci 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   14.932090] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   14.936310] usb usb2: default language 0x0409
[   14.936414] usb usb2: udev 1, busnum 2, minor = 128
[   14.936421] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   14.939791] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.943157] usb usb2: Product: EHCI Host Controller
[   14.946493] usb usb2: Manufacturer: Linux 3.13.0-rc8AS+ ehci_hcd
[   14.949886] usb usb2: SerialNumber: 0000:00:1a.7
[   14.954434] usb usb2: usb_probe_device
[   14.954446] usb usb2: configuration #1 chosen from 1 choice
[   14.954877] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   14.955159] hub 2-0:1.0: usb_probe_interface
[   14.955169] hub 2-0:1.0: usb_probe_interface - got id
[   14.955201] hub 2-0:1.0: USB hub found
[   14.958854] hub 2-0:1.0: 6 ports detected
[   14.962169] hub 2-0:1.0: standalone hub
[   14.962178] hub 2-0:1.0: no power switching (usb 1.0)
[   14.962184] hub 2-0:1.0: individual port over-current protection
[   14.962191] hub 2-0:1.0: power on to power good time: 20ms
[   14.962628] hub 2-0:1.0: local power source is good
[   14.970537] usb usb2: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   14.970549] usb usb2: usb port3's DeviceRemovable is changed to 1 according to platform information.
[   14.970555] usb usb2: usb port6's DeviceRemovable is changed to 1 according to platform information.
[   14.970566] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   14.971486] ehci-pci 0000:00:1a.7: HS companion for 0000:00:1a.0
[   14.971502] usb usb1: usb auto-resume
[   14.971508] usb usb1: wakeup_rh
[   14.992589] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   14.997359] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   14.997508] hub 1-0:1.0: usb_probe_interface
[   14.997519] hub 1-0:1.0: usb_probe_interface - got id
[   14.997541] hub 1-0:1.0: USB hub found
[   15.001265] hub 1-0:1.0: 2 ports detected
[   15.004574] hub 1-0:1.0: standalone hub
[   15.004584] hub 1-0:1.0: no power switching (usb 1.0)
[   15.004589] hub 1-0:1.0: individual port over-current protection
[   15.004599] hub 1-0:1.0: power on to power good time: 2ms
[   15.004994] hub 1-0:1.0: local power source is good
[   15.006772] usb usb1: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   15.006783] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   15.007768] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   15.011156] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[   15.014551] uhci_hcd 0000:00:1a.1: detected 2 ports
[   15.017954] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[   15.017966] uhci_hcd 0000:00:1a.1: Performing full reset
[   15.017994] uhci_hcd 0000:00:1a.1: supports USB remote wakeup
[   15.018073] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d800
[   15.021759] usb usb3: default language 0x0409
[   15.021850] usb usb3: udev 1, busnum 3, minor = 256
[   15.021861] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   15.025297] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.028749] usb usb3: Product: UHCI Host Controller
[   15.032180] usb usb3: Manufacturer: Linux 3.13.0-rc8AS+ uhci_hcd
[   15.035610] usb usb3: SerialNumber: 0000:00:1a.1
[   15.041039] usb usb3: usb_probe_device
[   15.041051] usb usb3: configuration #1 chosen from 1 choice
[   15.041338] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   15.041489] hub 3-0:1.0: usb_probe_interface
[   15.041499] hub 3-0:1.0: usb_probe_interface - got id
[   15.041515] hub 3-0:1.0: USB hub found
[   15.044974] hub 3-0:1.0: 2 ports detected
[   15.048257] hub 3-0:1.0: standalone hub
[   15.048263] hub 3-0:1.0: no power switching (usb 1.0)
[   15.048272] hub 3-0:1.0: individual port over-current protection
[   15.048283] hub 3-0:1.0: power on to power good time: 2ms
[   15.048368] hub 3-0:1.0: local power source is good
[   15.050930] usb usb3: usb port1's DeviceRemovable is changed to 1 according to platform information.
[   15.050941] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   15.051798] uhci_hcd 0000:00:1a.1: FS/LS companion for 0000:00:1a.7
[   15.052324] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   15.055816] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   15.059278] uhci_hcd 0000:00:1a.2: detected 2 ports
[   15.062606] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[   15.062611] uhci_hcd 0000:00:1a.2: Performing full reset
[   15.062643] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[   15.062716] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000d480
[   15.066799] usb usb4: default language 0x0409
[   15.066901] usb usb4: udev 1, busnum 4, minor = 384
[   15.066911] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   15.071309] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[   15.071561] hub 2-0:1.0: port 3: status 0501 change 0001
[   15.071985] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.075286] usb usb4: Product: UHCI Host Controller
[   15.078539] usb usb4: Manufacturer: Linux 3.13.0-rc8AS+ uhci_hcd
[   15.081850] usb usb4: SerialNumber: 0000:00:1a.2
[   15.085649] usb usb4: usb_probe_device
[   15.085660] usb usb4: configuration #1 chosen from 1 choice
[   15.085735] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   15.085889] hub 4-0:1.0: usb_probe_interface
[   15.085895] hub 4-0:1.0: usb_probe_interface - got id
[   15.085915] hub 4-0:1.0: USB hub found
[   15.089269] hub 4-0:1.0: 2 ports detected
[   15.092495] hub 4-0:1.0: standalone hub
[   15.092501] hub 4-0:1.0: no power switching (usb 1.0)
[   15.092506] hub 4-0:1.0: individual port over-current protection
[   15.092517] hub 4-0:1.0: power on to power good time: 2ms
[   15.092593] hub 4-0:1.0: local power source is good
[   15.094700] usb usb4: usb port2's DeviceRemovable is changed to 1 according to platform information.
[   15.094711] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   15.095059] uhci_hcd 0000:00:1a.2: FS/LS companion for 0000:00:1a.7
[   15.095578] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   15.098820] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   15.102096] ehci-pci 0000:00:1d.7: debug port 1
[   15.105284] ehci-pci 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   15.105298] ehci-pci 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   15.105439] ehci-pci 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   15.108439] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.108860] hub 1-0:1.0: hub_suspend
[   15.109242] usb usb1: bus auto-suspend, wakeup 1
[   15.109264] usb usb1: suspend_rh
[   15.109376] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[   15.109385] ehci-pci 0000:00:1d.7: supports USB remote wakeup
[   15.109466] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfe9fb800
[   15.112542] ehci-pci 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   15.124075] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   15.127623] usb usb5: default language 0x0409
[   15.127725] usb usb5: udev 1, busnum 5, minor = 512
[   15.127735] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[   15.130918] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.134012] usb usb5: Product: EHCI Host Controller
[   15.137074] usb usb5: Manufacturer: Linux 3.13.0-rc8AS+ ehci_hcd
[   15.140231] usb usb5: SerialNumber: 0000:00:1d.7
[   15.144132] usb usb5: usb_probe_device
[   15.144144] usb usb5: configuration #1 chosen from 1 choice
[   15.144442] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   15.144599] hub 5-0:1.0: usb_probe_interface
[   15.144609] hub 5-0:1.0: usb_probe_interface - got id
[   15.144626] hub 5-0:1.0: USB hub found
[   15.147946] hub 5-0:1.0: 6 ports detected
[   15.151110] hub 5-0:1.0: standalone hub
[   15.151116] hub 5-0:1.0: no power switching (usb 1.0)
[   15.151125] hub 5-0:1.0: individual port over-current protection
[   15.151136] hub 5-0:1.0: power on to power good time: 20ms
[   15.151442] hub 5-0:1.0: local power source is good
[   15.152090] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[   15.159878] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   15.161266] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   15.164433] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   15.167529] uhci_hcd 0000:00:1d.0: detected 2 ports
[   15.168319] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
[   15.168319] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
[   15.187043] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   15.187070] uhci_hcd 0000:00:1d.0: Performing full reset
[   15.188145] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000
[   15.188509] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[   15.192059] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   15.192088] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d400
[   15.195529] usb usb6: default language 0x0409
[   15.195634] usb usb6: udev 1, busnum 6, minor = 640
[   15.195644] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   15.201851] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.203843] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   15.204058] microcode: CPU1 sig=0x1067a, pf=0x80, revision=0xa07
[   15.208011] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
[   15.227188] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   15.244412] ehci-pci 0000:00:1a.7: port 3 reset complete, port enabled
[   15.244425] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   15.272776] usb usb6: Product: UHCI Host Controller
[   15.275974] usb usb6: Manufacturer: Linux 3.13.0-rc8AS+ uhci_hcd
[   15.279310] usb usb6: SerialNumber: 0000:00:1d.0
[   15.283661] usb usb6: usb_probe_device
[   15.283674] usb usb6: configuration #1 chosen from 1 choice
[   15.283765] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   15.283935] hub 6-0:1.0: usb_probe_interface
[   15.283945] hub 6-0:1.0: usb_probe_interface - got id
[   15.283963] hub 6-0:1.0: USB hub found
[   15.302063] usb 2-3: new high-speed USB device number 2 using ehci-pci
[   15.305878] hub 6-0:1.0: 2 ports detected
[   15.309551] hub 6-0:1.0: standalone hub
[   15.309562] hub 6-0:1.0: no power switching (usb 1.0)
[   15.309567] hub 6-0:1.0: individual port over-current protection
[   15.309579] hub 6-0:1.0: power on to power good time: 2ms
[   15.309667] hub 6-0:1.0: local power source is good
[   15.312994] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   15.322356] uhci_hcd 0000:00:1d.0: FS/LS companion for 0000:00:1d.7
[   15.322878] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   15.331051] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   15.335856] uhci_hcd 0000:00:1d.1: detected 2 ports
[   15.343785] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   15.343792] uhci_hcd 0000:00:1d.1: Performing full reset
[   15.343825] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   15.343857] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d080
[   15.349881] usb usb7: default language 0x0409
[   15.349983] usb usb7: udev 1, busnum 7, minor = 768
[   15.349990] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   15.353274] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.356946] usb usb7: Product: UHCI Host Controller
[   15.360638] usb usb7: Manufacturer: Linux 3.13.0-rc8AS+ uhci_hcd
[   15.368106] usb usb7: SerialNumber: 0000:00:1d.1
[   15.374221] usb usb7: usb_probe_device
[   15.374234] usb usb7: configuration #1 chosen from 1 choice
[   15.374354] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   15.378655] hub 7-0:1.0: usb_probe_interface
[   15.378667] hub 7-0:1.0: usb_probe_interface - got id
[   15.378685] hub 7-0:1.0: USB hub found
[   15.382086] hub 7-0:1.0: 2 ports detected
[   15.389604] hub 7-0:1.0: standalone hub
[   15.389611] hub 7-0:1.0: no power switching (usb 1.0)
[   15.389623] hub 7-0:1.0: individual port over-current protection
[   15.389635] hub 7-0:1.0: power on to power good time: 2ms
[   15.389726] hub 7-0:1.0: local power source is good
[   15.393418] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   15.394971] uhci_hcd 0000:00:1d.1: FS/LS companion for 0000:00:1d.7
[   15.395460] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   15.401454] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   15.404834] uhci_hcd 0000:00:1d.2: detected 2 ports
[   15.408112] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   15.408122] uhci_hcd 0000:00:1d.2: Performing full reset
[   15.411044] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   15.411081] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
[   15.414658] ehci-pci 0000:00:1a.7: port 3 reset complete, port enabled
[   15.414669] ehci-pci 0000:00:1a.7: GetStatus port:3 status 001005 0  ACK POWER sig=se0 PE CONNECT
[   15.415230] usb usb8: default language 0x0409
[   15.415327] usb usb8: udev 1, busnum 8, minor = 896
[   15.415338] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   15.424103] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.427551] usb usb8: Product: UHCI Host Controller
[   15.431376] usb usb8: Manufacturer: Linux 3.13.0-rc8AS+ uhci_hcd
[   15.434933] usb usb8: SerialNumber: 0000:00:1d.2
[   15.439127] usb usb8: usb_probe_device
[   15.439140] usb usb8: configuration #1 chosen from 1 choice
[   15.439223] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[   15.439457] hub 8-0:1.0: usb_probe_interface
[   15.439464] hub 8-0:1.0: usb_probe_interface - got id
[   15.439485] hub 8-0:1.0: USB hub found
[   15.445344] hub 8-0:1.0: 2 ports detected
[   15.451360] hub 8-0:1.0: standalone hub
[   15.451371] hub 8-0:1.0: no power switching (usb 1.0)
[   15.451376] hub 8-0:1.0: individual port over-current protection
[   15.451388] hub 8-0:1.0: power on to power good time: 2ms
[   15.451482] hub 8-0:1.0: local power source is good
[   15.455235] hub 8-0:1.0: trying to enable port power on non-switchable hub
[   15.458262] uhci_hcd 0000:00:1d.2: FS/LS companion for 0000:00:1d.7
[   15.534714] usb 2-3: skipped 1 descriptor after configuration
[   15.534726] usb 2-3: skipped 6 descriptors after interface
[   15.534733] usb 2-3: skipped 1 descriptor after endpoint
[   15.534742] usb 2-3: skipped 8 descriptors after interface
[   15.535447] usb 2-3: default language 0x0409
[   15.541448] usb 2-3: udev 2, busnum 2, minor = 129
[   15.541460] usb 2-3: New USB device found, idVendor=04f2, idProduct=b036
[   15.544802] usb 2-3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[   15.548228] usb 2-3: Product: USB2.0 0.3M UVC WebCam
[   15.551496] usb 2-3: Manufacturer: Chicony Electronics Co., Ltd.
[   15.554918] usb 2-3: SerialNumber: SN0001
[   15.560618] usb 2-3: usb_probe_device
[   15.560630] usb 2-3: configuration #1 chosen from 1 choice
[   15.561110] usb 2-3: adding 2-3:1.0 (config #1, interface 0)
[   15.567248] usb 2-3: adding 2-3:1.1 (config #1, interface 1)
[   15.567526] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.567668] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.567685] hub 5-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   15.567701] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.567717] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.567733] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.567759] hub 4-0:1.0: hub_suspend
[   15.567899] usb usb4: bus auto-suspend, wakeup 1
[   15.567906] usb usb4: suspend_rh
[   15.567955] hub 3-0:1.0: hub_suspend
[   15.567972] usb usb3: bus auto-suspend, wakeup 1
[   15.567978] usb usb3: suspend_rh
[   15.568100] hub 5-0:1.0: hub_suspend
[   15.568380] usb usb5: bus auto-suspend, wakeup 1
[   15.568390] ehci-pci 0000:00:1d.7: suspend root hub
[   15.568497] hub 6-0:1.0: hub_suspend
[   15.568876] usb usb6: bus auto-suspend, wakeup 1
[   15.568886] usb usb6: suspend_rh
[   15.568936] hub 7-0:1.0: hub_suspend
[   15.568957] usb usb7: bus auto-suspend, wakeup 1
[   15.568967] usb usb7: suspend_rh
[   15.569009] hub 8-0:1.0: hub_suspend
[   15.569047] usb usb8: bus auto-suspend, wakeup 1
[   15.569056] usb usb8: suspend_rh
[   16.108411] irq 16: nobody cared (try booting with the "irqpoll" option)
[   16.111774] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.13.0-rc8AS+ #3
[   16.112405] Hardware name: ASUSTeK Computer Inc.         UL20A               /UL20A     , BIOS 207     11/02/2009
[   16.112405]  00000000 00000000 f50c7f84 c07e6736 f514b600 f50c7f98 c04675c7 f514b600
[   16.112405]  00000000 00000010 f50c7fb4 c0467936 eb5e8757 fffeeac3 f514b600 00000010
[   16.112405]  00000000 f50c7fd4 c0466052 00000000 00000000 00000000 f514b600 f514b654
[   16.112405] Call Trace:
[   16.112405]  [<c07e6736>] dump_stack+0x48/0x69
[   16.112405]  [<c04675c7>] __report_bad_irq+0x14/0x9e
[   16.112405]  [<c0467936>] note_interrupt+0x137/0x1b5
[   16.112405]  [<c0466052>] handle_irq_event_percpu+0xc5/0x107
[   16.112405]  [<c04660c0>] handle_irq_event+0x2c/0x44
[   16.112405]  [<c046808e>] ? handle_edge_irq+0xa9/0xa9
[   16.112405]  [<c04680f8>] handle_fasteoi_irq+0x6a/0x97
[   16.112405]  <IRQ>  [<c0402f02>] ? do_IRQ+0x35/0x80
[   16.112405]  [<c07eceb8>] ? common_interrupt+0x38/0x3d
[   16.112405]  [<c045007b>] ? enqueue_entity+0xb9/0x479
[   16.112405]  [<c06fd571>] ? cpuidle_enter_state+0x42/0xa7
[   16.112405]  [<c06fd67f>] ? cpuidle_idle_call+0xa9/0xe6
[   16.112405]  [<c06fe550>] ? ladder_select_state+0x184/0x184
[   16.112405]  [<c0407f7c>] ? arch_cpu_idle+0x8/0x1c
[   16.112405]  [<c046595d>] ? cpu_startup_entry+0xd9/0x144
[   16.112405]  [<c041ef0e>] ? start_secondary+0x1d8/0x1dd
[   16.112405] handlers:
[   16.112405] [<f8486e56>] usb_hcd_irq [usbcore]
[   16.112405] Disabling IRQ #16
[   16.909283] SELinux: initialized (dev sda5, type vfat), uses genfs_contexts
[   16.999221] Adding 8389624k swap on /dev/sda7.  Priority:-1 extents:1 across:8389624k 
[   17.290795] EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
[   17.294381] SELinux: initialized (dev sda8, type ext4), uses xattr
[   17.415880] systemd-journald[286]: Received request to flush runtime journal from PID 1
[   25.968686] atl1c 0000:02:00.0: irq 43 for MSI/MSI-X
[   26.019277] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   26.033481] iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
[   26.061451] uhci_hcd 0000:00:1a.0: uhci_pci_suspend
[   26.061890] uhci_hcd 0000:00:1a.0: hcd_pci_runtime_suspend: 0
[   26.062264] uhci_hcd 0000:00:1a.1: uhci_pci_suspend
[   26.062636] uhci_hcd 0000:00:1a.1: hcd_pci_runtime_suspend: 0
[   26.062961] uhci_hcd 0000:00:1a.2: uhci_pci_suspend
[   26.063314] uhci_hcd 0000:00:1a.2: hcd_pci_runtime_suspend: 0
[   26.063790] uhci_hcd 0000:00:1d.0: uhci_pci_suspend
[   26.067472] uhci_hcd 0000:00:1d.0: hcd_pci_runtime_suspend: 0
[   26.067865] uhci_hcd 0000:00:1d.1: uhci_pci_suspend
[   26.074189] uhci_hcd 0000:00:1d.1: hcd_pci_runtime_suspend: 0
[   26.074724] uhci_hcd 0000:00:1d.2: uhci_pci_suspend
[   26.075934] uhci_hcd 0000:00:1d.2: hcd_pci_runtime_suspend: 0
[   26.078229] ehci-pci 0000:00:1d.7: hcd_pci_runtime_suspend: 0
[   26.102529] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
[   26.112748] iwlwifi 0000:01:00.0: Radio type=0x0-0x0-0x3
[   26.404890] [drm:intel_crtc_cursor_set], cursor off
[   26.404901] [drm:intel_crtc_set_config], [CRTC:3] [FB:18] #connectors=1 (x y) (0 0)
[   26.404910] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   26.404917] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   26.404924] [drm:intel_crtc_cursor_set], cursor off
[   26.404930] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[   26.404937] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   26.404943] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
[   27.897439] wlan0: authenticate with 00:13:46:48:f3:2a
[   27.914495] wlan0: send auth to 00:13:46:48:f3:2a (try 1/3)
[   27.938241] wlan0: authenticated
[   27.943117] iwlwifi 0000:01:00.0 wlan0: disabling HT/VHT due to WEP/TKIP use
[   27.947571] iwlwifi 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[   27.952093] iwlwifi 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[   27.952101] wlan0: waiting for beacon from 00:13:46:48:f3:2a
[   28.020683] wlan0: associate with 00:13:46:48:f3:2a (try 1/3)
[   28.034128] wlan0: RX AssocResp from 00:13:46:48:f3:2a (capab=0x431 status=0 aid=7)
[   28.048568] wlan0: associated
[   48.475346] type=1006 audit(1391014167.713:4): pid=490 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1 res=1

