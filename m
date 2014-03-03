Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaCCOUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:20:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaCCOUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:20:16 -0500
Date: Mon, 3 Mar 2014 15:20:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>
cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
In-Reply-To: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014, Jiri Kosina wrote:

> Hi,
> 
> first things first: this is hard to bisect, because it doesn't happen 
> reliably and I don't really know what is the first good version, as I had 
> a delay in following Linus' tree.
> 
> What happens is that after resumption from S4 (disk), Xorg session is in 
> complete havoc -- the windows don't redraw properly, sometimes the mouse 
> pointer is "jailed" on a small rectangle in the middle of the screen, etc.
> 
> I have captured 'drm.debug=14' output of the failing resume ... I guess 
> this is realted to the
> 
> *ERROR* render ring initialization failed ctl 0001f001 head 00003004 tail 00000000 start 00003000
> 
> as it doesn't seem to be there in case of resumption that works properly.
> 
> Please see the dmesg from the broken case below.

I encountered this again with -rc5.

If there is anything I can do to help debug this, please let me know.

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.14.0-rc4-00034-g6dba6ec (jkosina@noe) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP Wed Feb 26 15:40:14 CET 2014
> [    0.000000] Command line: root=/dev/sda2 resume=/dev/sda1  showopts pcie_aspm=force vga=0x314 drm.debug=14 log_buf_len=20M
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007c4a0fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007c4a1000-0x000000007c4a6fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007c4a7000-0x000000007c5b6fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007c5b7000-0x000000007c60efff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007c60f000-0x000000007c6c5fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007c6c6000-0x000000007c6d0fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007c6d1000-0x000000007c6d3fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007c6d4000-0x000000007c6d7fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007c6d8000-0x000000007c6dbfff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007c6dc000-0x000000007c6defff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007c6df000-0x000000007c705fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007c706000-0x000000007c707fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007c708000-0x000000007c90efff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000007c90f000-0x000000007c99efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000007c99f000-0x000000007c9fefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000007c9ff000-0x000000007c9fffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000007cc00000-0x000000007effffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x7ca00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-D3FFF write-protect
> [    0.000000]   D4000-DBFFF uncachable
> [    0.000000]   DC000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 07D000000 mask FFF000000 uncachable
> [    0.000000]   1 base 07E000000 mask FFE000000 uncachable
> [    0.000000]   2 base 000000000 mask F80000000 write-back
> [    0.000000]   3 base 07CE00000 mask FFFE00000 uncachable
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] found SMP MP-table at [mem 0x000f73c0-0x000f73cf] mapped at [ffff8800000f73c0]
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 28672
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x025e9000, 0x025e9fff] PGTABLE
> [    0.000000] BRK [0x025ea000, 0x025eafff] PGTABLE
> [    0.000000] BRK [0x025eb000, 0x025ebfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x7c200000-0x7c3fffff]
> [    0.000000]  [mem 0x7c200000-0x7c3fffff] page 2M
> [    0.000000] BRK [0x025ec000, 0x025ecfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x7c000000-0x7c1fffff]
> [    0.000000]  [mem 0x7c000000-0x7c1fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x78000000-0x7bffffff]
> [    0.000000]  [mem 0x78000000-0x7bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x77ffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x77ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x7c400000-0x7c4a0fff]
> [    0.000000]  [mem 0x7c400000-0x7c4a0fff] page 4k
> [    0.000000] BRK [0x025ed000, 0x025edfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x7c4a7000-0x7c5b6fff]
> [    0.000000]  [mem 0x7c4a7000-0x7c5b6fff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x7c60f000-0x7c6c5fff]
> [    0.000000]  [mem 0x7c60f000-0x7c6c5fff] page 4k
> [    0.000000] BRK [0x025ee000, 0x025eefff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x7c9ff000-0x7c9fffff]
> [    0.000000]  [mem 0x7c9ff000-0x7c9fffff] page 4k
> [    0.000000] log_buf_len: 33554432
> [    0.000000] early log buf free: 256536(97%)
> [    0.000000] RAMDISK: [mem 0x35713000-0x37feffff]
> [    0.000000] ACPI: RSDP 00000000000f7380 000024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT 000000007c97bdcc 00009C (v01 LENOVO TP-6D    00002020  LTP 00000000)
> [    0.000000] ACPI: FACP 000000007c97bf00 0000F4 (v03 LENOVO TP-6D    00002020 LNVO 00000001)
> [    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20131218/tbfadt-603)
> [    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20131218/tbfadt-684)
> [    0.000000] ACPI: DSDT 000000007c97c2f4 00D889 (v01 LENOVO TP-6D    00002020 MSFT 03000000)
> [    0.000000] ACPI: FACS 000000007c98e000 000040
> [    0.000000] ACPI: SSDT 000000007c97c0b4 000240 (v01 LENOVO TP-6D    00002020 MSFT 03000000)
> [    0.000000] ACPI: ECDT 000000007c989b7d 000052 (v01 LENOVO TP-6D    00002020 LNVO 00000001)
> [    0.000000] ACPI: APIC 000000007c989bcf 000078 (v01 LENOVO TP-6D    00002020 LNVO 00000001)
> [    0.000000] ACPI: MCFG 000000007c989c47 00003C (v01 LENOVO TP-6D    00002020 LNVO 00000001)
> [    0.000000] ACPI: HPET 000000007c989c83 000038 (v01 LENOVO TP-6D    00002020 LNVO 00000001)
> [    0.000000] ACPI: SLIC 000000007c989dc2 000176 (v01 LENOVO TP-6D    00002020  LTP 00000000)
> [    0.000000] ACPI: BOOT 000000007c989f38 000028 (v01 LENOVO TP-6D    00002020  LTP 00000001)
> [    0.000000] ACPI: ASF! 000000007c989f60 0000A0 (v16 LENOVO TP-6D    00002020 PTL  00000001)
> [    0.000000] ACPI: SSDT 000000007c98d203 00055F (v01 LENOVO TP-6D    00002020 INTL 20050513)
> [    0.000000] ACPI: TCPA 000000007c707000 000032 (v00                 00000000      00000000)
> [    0.000000] ACPI: DMAR 000000007c706000 000120 (v01               ? 00000001      00000000)
> [    0.000000] ACPI: SSDT 000000007c6d3000 000655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
> [    0.000000] ACPI: SSDT 000000007c6d2000 000274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
> [    0.000000] ACPI: SSDT 000000007c6d1000 000242 (v01  PmRef    ApTst 00003000 INTL 20050624)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007c9fffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x7c9fffff]
> [    0.000000]   NODE_DATA [mem 0x7c6b0000-0x7c6c4fff]
> [    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880077c00000-ffff8800797fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
> [    0.000000]   node   0: [mem 0x00100000-0x7c4a0fff]
> [    0.000000]   node   0: [mem 0x7c4a7000-0x7c5b6fff]
> [    0.000000]   node   0: [mem 0x7c60f000-0x7c6c5fff]
> [    0.000000]   node   0: [mem 0x7c9ff000-0x7c9fffff]
> [    0.000000] On node 0 totalpages: 509446
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 22 pages reserved
> [    0.000000]   DMA zone: 3997 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 6923 pages used for memmap
> [    0.000000]   DMA32 zone: 505449 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dbfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c4a1000-0x7c4a6fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c5b7000-0x7c60efff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c6c6000-0x7c6d0fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c6d1000-0x7c6d3fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c6d4000-0x7c6d7fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c6d8000-0x7c6dbfff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c6dc000-0x7c6defff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c6df000-0x7c705fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c706000-0x7c707fff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c708000-0x7c90efff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c90f000-0x7c99efff]
> [    0.000000] PM: Registered nosave memory: [mem 0x7c99f000-0x7c9fefff]
> [    0.000000] e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
> [    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007a200000 s83904 r8192 d22592 u524288
> [    0.000000] pcpu-alloc: s83904 r8192 d22592 u524288 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 502445
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: root=/dev/sda2 resume=/dev/sda1  showopts pcie_aspm=force vga=0x314 drm.debug=14 log_buf_len=20M
> [    0.000000] PCIe ASPM is forcibly enabled
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 1910780K/2037784K available (5873K kernel code, 793K rwdata, 2684K rodata, 1460K init, 9908K bss, 127004K reserved)
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> [    0.000000] NR_IRQS:33024 nr_irqs:712 16
> [    0.000000] ACPI: Core revision 20131218
> [    0.000000] kmemleak: Kernel memory leak detector disabled
> [    0.000000] ACPI: All ACPI Tables successfully acquired
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 5855 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] kmemleak: Early log buffer exceeded (27536), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 1862.024 MHz processor
> [    0.004003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3724.04 BogoMIPS (lpj=7448096)
> [    0.004015] pid_max: default: 32768 minimum: 301
> [    0.008071] Security Framework initialized
> [    0.009022] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.010484] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.011004] Mount-cache hash table entries: 256
> [    0.012255] Initializing cgroup subsys devices
> [    0.012286] Initializing cgroup subsys freezer
> [    0.012308] Initializing cgroup subsys net_cls
> [    0.012315] Initializing cgroup subsys blkio
> [    0.012321] Initializing cgroup subsys perf_event
> [    0.012446] Disabled fast string operations
> [    0.012456] CPU: Physical Processor ID: 0
> [    0.012461] CPU: Processor Core ID: 0
> [    0.012466] mce: CPU supports 6 MCE banks
> [    0.012479] CPU0: Thermal monitoring enabled (TM2)
> [    0.012491] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> [    0.012491] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
> [    0.012491] tlb_flushall_shift: -1
> [    0.012632] Freeing SMP alternatives memory: 20K (ffffffff81c35000 - ffffffff81c3a000)
> [    0.013558] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.053259] smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     L9400  @ 1.86GHz (fam: 06, model: 17, stepping: 06)
> [    0.056000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
> [    0.056000] ... version:                2
> [    0.056000] ... bit width:              40
> [    0.056000] ... generic registers:      2
> [    0.056000] ... value mask:             000000ffffffffff
> [    0.056000] ... max period:             000000007fffffff
> [    0.056000] ... fixed-purpose events:   3
> [    0.056000] ... event mask:             0000000700000003
> [    0.056000] x86: Booting SMP configuration:
> [    0.056000] .... node  #0, CPUs:      #1
> [    0.008000] Disabled fast string operations
> [    0.068150] x86: Booted up 1 node, 2 CPUs
> [    0.068165] smpboot: Total of 2 processors activated (7448.09 BogoMIPS)
> [    0.072934] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.073378] devtmpfs: initialized
> [    0.084092] PM: Registering ACPI NVS region [mem 0x7c6c6000-0x7c6d0fff] (45056 bytes)
> [    0.084107] PM: Registering ACPI NVS region [mem 0x7c6d8000-0x7c6dbfff] (16384 bytes)
> [    0.084117] PM: Registering ACPI NVS region [mem 0x7c6df000-0x7c705fff] (159744 bytes)
> [    0.084145] PM: Registering ACPI NVS region [mem 0x7c90f000-0x7c99efff] (589824 bytes)
> [    0.086049] regulator-dummy: no parameters
> [    0.086264] RTC time: 10:48:58, date: 02/27/14
> [    0.086635] NET: Registered protocol family 16
> [    0.087762] cpuidle: using governor ladder
> [    0.087769] cpuidle: using governor menu
> [    0.087844] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.087865] ACPI: bus type PCI registered
> [    0.088398] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
> [    0.088409] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
> [    0.101661] PCI: Using configuration type 1 for base access
> [    0.109876] bio: create slab <bio-0> at 0
> [    0.109876] ACPI: Added _OSI(Module Device)
> [    0.109876] ACPI: Added _OSI(Processor Device)
> [    0.109876] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.109876] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.121292] ACPI : EC: EC description table is found, configuring boot EC
> [    0.147275] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.169692] ACPI: SSDT 000000007c6d6c20 0002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> [    0.172004] ACPI: Dynamic OEM Table Load:
> [    0.172013] ACPI: SSDT           (null) 0002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> [    0.172501] ACPI: SSDT 000000007c6d4020 00087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> [    0.174961] ACPI: Dynamic OEM Table Load:
> [    0.174969] ACPI: SSDT           (null) 00087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> [    0.197067] ACPI: SSDT 000000007c6d5ca0 0001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
> [    0.199486] ACPI: Dynamic OEM Table Load:
> [    0.199494] ACPI: SSDT           (null) 0001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
> [    0.208307] ACPI: SSDT 000000007c6d5f20 00008D (v01  PmRef    ApCst 00003000 INTL 20050624)
> [    0.210637] ACPI: Dynamic OEM Table Load:
> [    0.210645] ACPI: SSDT           (null) 00008D (v01  PmRef    ApCst 00003000 INTL 20050624)
> [    0.224574] ACPI: Interpreter enabled
> [    0.224589] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
> [    0.224607] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
> [    0.224672] ACPI: (supports S0 S3 S4 S5)
> [    0.224679] ACPI: Using IOAPIC for interrupt routing
> [    0.224808] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.228224] ACPI: ACPI Dock Station Driver: 3 docks/bays found
> [    0.268409] ACPI: Power Resource [PUBS] (on)
> [    0.293038] ACPI: \_PR_.CPU2: failed to get CPU APIC ID.
> [    0.293066] ACPI: \_PR_.CPU3: failed to get CPU APIC ID.
> [    0.293556] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.294039] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.294518] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.294996] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.295474] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.295951] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.296450] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.296930] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.297052] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.297068] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.299307] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
> [    0.299429] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
> [    0.299834] PCI host bridge to bus 0000:00
> [    0.299844] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.299852] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.299860] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.299868] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.299875] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.299883] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.299890] pci_bus 0000:00: root bus resource [mem 0x7f000000-0xfebfffff]
> [    0.299954] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
> [    0.300540] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
> [    0.300567] pci 0000:00:02.0: reg 0x10: [mem 0xf2000000-0xf23fffff 64bit]
> [    0.300583] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.300594] pci 0000:00:02.0: reg 0x20: [io  0x1800-0x1807]
> [    0.301192] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
> [    0.301214] pci 0000:00:02.1: reg 0x10: [mem 0xf2400000-0xf24fffff 64bit]
> [    0.301757] pci 0000:00:03.0: [8086:2a44] type 00 class 0x078000
> [    0.301786] pci 0000:00:03.0: reg 0x10: [mem 0xf2826800-0xf282680f 64bit]
> [    0.301881] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    0.302455] pci 0000:00:03.2: [8086:2a46] type 00 class 0x010185
> [    0.302480] pci 0000:00:03.2: reg 0x10: [io  0x1828-0x182f]
> [    0.302492] pci 0000:00:03.2: reg 0x14: [io  0x180c-0x180f]
> [    0.302504] pci 0000:00:03.2: reg 0x18: [io  0x1820-0x1827]
> [    0.302517] pci 0000:00:03.2: reg 0x1c: [io  0x1808-0x180b]
> [    0.302529] pci 0000:00:03.2: reg 0x20: [io  0x1810-0x181f]
> [    0.303066] pci 0000:00:03.3: [8086:2a47] type 00 class 0x070002
> [    0.303090] pci 0000:00:03.3: reg 0x10: [io  0x1830-0x1837]
> [    0.303102] pci 0000:00:03.3: reg 0x14: [mem 0xf2624000-0xf2624fff]
> [    0.303722] pci 0000:00:19.0: [8086:10f5] type 00 class 0x020000
> [    0.303759] pci 0000:00:19.0: reg 0x10: [mem 0xf2600000-0xf261ffff]
> [    0.303776] pci 0000:00:19.0: reg 0x14: [mem 0xf2625000-0xf2625fff]
> [    0.303792] pci 0000:00:19.0: reg 0x18: [io  0x1840-0x185f]
> [    0.303927] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.304193] pci 0000:00:19.0: System wakeup disabled by ACPI
> [    0.304595] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
> [    0.304678] pci 0000:00:1a.0: reg 0x20: [io  0x1860-0x187f]
> [    0.305020] pci 0000:00:1a.0: System wakeup disabled by ACPI
> [    0.305431] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
> [    0.305515] pci 0000:00:1a.1: reg 0x20: [io  0x1880-0x189f]
> [    0.306080] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
> [    0.306164] pci 0000:00:1a.2: reg 0x20: [io  0x18a0-0x18bf]
> [    0.306478] pci 0000:00:1a.2: System wakeup disabled by ACPI
> [    0.306898] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
> [    0.306936] pci 0000:00:1a.7: reg 0x10: [mem 0xf2826c00-0xf2826fff]
> [    0.307101] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.307302] pci 0000:00:1a.7: System wakeup disabled by ACPI
> [    0.307716] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
> [    0.307747] pci 0000:00:1b.0: reg 0x10: [mem 0xf2620000-0xf2623fff 64bit]
> [    0.307909] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.308142] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.308552] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
> [    0.308719] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.308925] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.309329] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
> [    0.309496] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.309700] pci 0000:00:1c.1: System wakeup disabled by ACPI
> [    0.310106] pci 0000:00:1c.3: [8086:2946] type 01 class 0x060400
> [    0.310272] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.310478] pci 0000:00:1c.3: System wakeup disabled by ACPI
> [    0.310891] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
> [    0.310974] pci 0000:00:1d.0: reg 0x20: [io  0x18c0-0x18df]
> [    0.311288] pci 0000:00:1d.0: System wakeup disabled by ACPI
> [    0.311693] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
> [    0.311777] pci 0000:00:1d.1: reg 0x20: [io  0x18e0-0x18ff]
> [    0.312352] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
> [    0.312435] pci 0000:00:1d.2: reg 0x20: [io  0x1c00-0x1c1f]
> [    0.313026] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
> [    0.313063] pci 0000:00:1d.7: reg 0x10: [mem 0xf2827000-0xf28273ff]
> [    0.313227] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.313440] pci 0000:00:1d.7: System wakeup disabled by ACPI
> [    0.313843] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> [    0.314417] pci 0000:00:1f.0: [8086:2917] type 00 class 0x060100
> [    0.315107] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
> [    0.315149] pci 0000:00:1f.2: reg 0x10: [io  0x1c48-0x1c4f]
> [    0.315165] pci 0000:00:1f.2: reg 0x14: [io  0x183c-0x183f]
> [    0.315182] pci 0000:00:1f.2: reg 0x18: [io  0x1c40-0x1c47]
> [    0.315198] pci 0000:00:1f.2: reg 0x1c: [io  0x1838-0x183b]
> [    0.315214] pci 0000:00:1f.2: reg 0x20: [io  0x1c20-0x1c3f]
> [    0.315231] pci 0000:00:1f.2: reg 0x24: [mem 0xf2826000-0xf28267ff]
> [    0.315337] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.315910] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
> [    0.315942] pci 0000:00:1f.3: reg 0x10: [mem 0xf2827400-0xf28274ff 64bit]
> [    0.315985] pci 0000:00:1f.3: reg 0x20: [io  0x1c60-0x1c7f]
> [    0.316788] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.317226] pci 0000:03:00.0: [8086:4237] type 00 class 0x028000
> [    0.317403] pci 0000:03:00.0: reg 0x10: [mem 0xf2500000-0xf2501fff 64bit]
> [    0.318100] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.318805] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.318821] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
> [    0.319103] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> [    0.319115] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.319122] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
> [    0.319133] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
> [    0.319452] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
> [    0.319477] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.319480] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.319484] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.319487] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.319490] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.319495] pci 0000:00:1e.0:   bridge window [mem 0x7f000000-0xfebfffff] (subtractive decode)
> [    0.319569] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
> [    0.325040] ACPI: Enabled 3 GPEs in block 00 to 3F
> [    0.325483] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
> [    0.325944] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.325944] vgaarb: loaded
> [    0.325944] vgaarb: bridge control possible 0000:00:02.0
> [    0.325944] SCSI subsystem initialized
> [    0.328116] libata version 3.00 loaded.
> [    0.328582] PCI: Using ACPI for IRQ routing
> [    0.331536] PCI: pci_cache_line_size set to 64 bytes
> [    0.331700] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
> [    0.331711] e820: reserve RAM buffer [mem 0x7c4a1000-0x7fffffff]
> [    0.331717] e820: reserve RAM buffer [mem 0x7c5b7000-0x7fffffff]
> [    0.331721] e820: reserve RAM buffer [mem 0x7c6c6000-0x7fffffff]
> [    0.331725] e820: reserve RAM buffer [mem 0x7ca00000-0x7fffffff]
> [    0.333137] NetLabel: Initializing
> [    0.333144] NetLabel:  domain hash size = 128
> [    0.333149] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.333254] NetLabel:  unlabeled traffic allowed by default
> [    0.333306] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.333320] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.333331] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    0.335428] Switched to clocksource hpet
> [    0.365494] pnp: PnP ACPI init
> [    0.365622] ACPI: bus type PNP registered
> [    0.388195] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.388207] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> [    0.388217] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> [    0.388226] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
> [    0.388235] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
> [    0.388244] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
> [    0.388254] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
> [    0.388263] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> [    0.388273] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> [    0.388282] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> [    0.388292] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> [    0.388301] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.388311] system 00:00: [mem 0x00100000-0x7effffff] could not be reserved
> [    0.388321] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
> [    0.388330] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
> [    0.388367] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.409294] system 00:01: [io  0x164e-0x164f] has been reserved
> [    0.409306] system 00:01: [io  0x1000-0x107f] could not be reserved
> [    0.409314] system 00:01: [io  0x1180-0x11ff] has been reserved
> [    0.409323] system 00:01: [io  0x0800-0x080f] has been reserved
> [    0.409332] system 00:01: [io  0x15e0-0x15ef] has been reserved
> [    0.409340] system 00:01: [io  0x1600-0x1641] has been reserved
> [    0.409348] system 00:01: [io  0x1600-0x161b] has been reserved
> [    0.409357] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.409366] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.409375] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.409384] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.409393] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.409401] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
> [    0.409414] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.409747] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.409782] pnp 00:03: [dma 4]
> [    0.409981] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.410212] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.410448] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.410699] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.410934] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.411175] pnp 00:08: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
> [    0.431962] pnp 00:09: Plug and Play ACPI device, IDs PNP0c31 (active)
> [    0.432991] pnp: PnP ACPI: found 10 devices
> [    0.432998] ACPI: bus type PNP unregistered
> [    0.453928] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
> [    0.453935] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
> [    0.453940] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
> [    0.453956] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
> [    0.453961] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
> [    0.453998] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
> [    0.454002] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> [    0.454005] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> [    0.454008] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    0.454011] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    0.454021] pci 0000:00:1c.0: BAR 14: assigned [mem 0x7f000000-0x7f1fffff]
> [    0.454033] pci 0000:00:1c.0: BAR 15: assigned [mem 0x7f200000-0x7f3fffff 64bit pref]
> [    0.454045] pci 0000:00:1c.1: BAR 15: assigned [mem 0x7f400000-0x7f5fffff 64bit pref]
> [    0.454056] pci 0000:00:1c.0: BAR 13: assigned [io  0x3000-0x3fff]
> [    0.454065] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
> [    0.454076] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.454085] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    0.454098] pci 0000:00:1c.0:   bridge window [mem 0x7f000000-0x7f1fffff]
> [    0.454109] pci 0000:00:1c.0:   bridge window [mem 0x7f200000-0x7f3fffff 64bit pref]
> [    0.454126] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.454134] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
> [    0.454147] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
> [    0.454158] pci 0000:00:1c.1:   bridge window [mem 0x7f400000-0x7f5fffff 64bit pref]
> [    0.454174] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> [    0.454182] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.454195] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
> [    0.454206] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
> [    0.454222] pci 0000:00:1e.0: PCI bridge to [bus 0d]
> [    0.454246] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.454249] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.454252] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.454255] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.454258] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.454261] pci_bus 0000:00: resource 9 [mem 0x7f000000-0xfebfffff]
> [    0.454264] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
> [    0.454267] pci_bus 0000:02: resource 1 [mem 0x7f000000-0x7f1fffff]
> [    0.454271] pci_bus 0000:02: resource 2 [mem 0x7f200000-0x7f3fffff 64bit pref]
> [    0.454274] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
> [    0.454277] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
> [    0.454280] pci_bus 0000:03: resource 2 [mem 0x7f400000-0x7f5fffff 64bit pref]
> [    0.454283] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
> [    0.454286] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
> [    0.454289] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
> [    0.454292] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
> [    0.454295] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
> [    0.454298] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.454301] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.454304] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.454307] pci_bus 0000:0d: resource 9 [mem 0x7f000000-0xfebfffff]
> [    0.454497] NET: Registered protocol family 2
> [    0.455147] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> [    0.455666] TCP bind hash table entries: 16384 (order: 8, 1048576 bytes)
> [    0.457086] TCP: Hash tables configured (established 16384 bind 16384)
> [    0.457494] TCP: reno registered
> [    0.457567] UDP hash table entries: 1024 (order: 5, 163840 bytes)
> [    0.457825] UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes)
> [    0.458441] NET: Registered protocol family 1
> [    0.458478] pci 0000:00:02.0: Boot video device
> [    0.463235] PCI: CLS 64 bytes, default 64
> [    0.463989] Unpacking initramfs...
> [    1.391375] Freeing initrd memory: 41844K (ffff880035713000 - ffff880037ff0000)
> [    1.391447] Simple Boot Flag at 0x35 set to 0x1
> [    1.392993] Scanning for low memory corruption every 60 seconds
> [    1.395274] futex hash table entries: 1024 (order: 5, 131072 bytes)
> [    1.395470] audit: initializing netlink subsys (disabled)
> [    1.395640] audit: type=2000 audit(1393498139.392:1): initialized
> [    1.433502] bounce pool size: 64 pages
> [    1.433525] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.434317] VFS: Disk quotas dquot_6.5.2
> [    1.434383] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.435520] msgmni has been set to 3813
> [    1.436824] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    1.436979] io scheduler noop registered
> [    1.436986] io scheduler deadline registered
> [    1.437042] io scheduler cfq registered (default)
> [    1.439457] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
> [    1.440488] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
> [    1.441409] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
> [    1.442245] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
> [    1.442265] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
> [    1.442380] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
> [    1.442388] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [    1.442400] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
> [    1.442503] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
> [    1.442515] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
> [    1.443065] vesafb: mode is 800x600x16, linelength=1600, pages=33
> [    1.443072] vesafb: scrolling: redraw
> [    1.443078] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> [    1.443568] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90004500000, using 1875k, total 32704k
> [    1.453086] Console: switching to colour frame buffer device 100x37
> [    1.461502] fb0: VESA VGA frame buffer device
> [    1.461719] intel_idle: does not run on family 6 model 23
> [    1.461833] GHES: HEST is not enabled!
> [    1.462164] Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
> [    1.498771] 0000:00:03.3: ttyS4 at I/O 0x1830 (irq = 17, base_baud = 115200) is a 16550A
> [    1.500142] Non-volatile memory driver v1.3
> [    1.500255] Linux agpgart interface v0.103
> [    1.500883] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
> [    1.501186] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [    1.503811] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
> [    1.504490] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [    1.505325] ahci 0000:00:1f.2: version 3.0
> [    1.505749] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
> [    1.506023] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> [    1.506227] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
> [    1.510614] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
> [    1.519809] scsi0 : ahci
> [    1.525060] scsi1 : ahci
> [    1.529946] scsi2 : ahci
> [    1.534746] scsi3 : ahci
> [    1.539233] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 43
> [    1.543353] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 43
> [    1.547365] ata3: DUMMY
> [    1.551262] ata4: DUMMY
> [    1.555724] libphy: Fixed MDIO Bus: probed
> [    1.559506] PPP generic driver version 2.4.2
> [    1.563503] PPP BSD Compression module registered
> [    1.567204] PPP Deflate Compression module registered
> [    1.570955] PPP MPPE Compression module registered
> [    1.574726] NET: Registered protocol family 24
> [    1.578637] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    1.592880] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.596845] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.601265] mousedev: PS/2 mouse device common for all mice
> [    1.605608] rtc_cmos 00:06: RTC can wake from S4
> [    1.610121] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [    1.614017] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    1.618024] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.622296] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    1.622697] TCP: cubic registered
> [    1.630199] NET: Registered protocol family 10
> [    1.637077] registered taskstats version 1
> [    1.642462]   Magic number: 2:850:831
> [    1.646281] rtc_cmos 00:06: setting system clock to 2014-02-27 10:49:00 UTC (1393498140)
> [    1.651057] PM: Checking hibernation image partition /dev/sda1
> [    1.872044] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.876531] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.876535] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.880486] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    1.884638] ata1.00: ATA-7: INTEL SSDSA2M080G2GN, 2CV102HA, max UDMA/133
> [    1.888569] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    1.893162] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.893167] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.897189] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    1.901393] ata1.00: configured for UDMA/133
> [    1.906268] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M080 2CV1 PQ: 0 ANSI: 5
> [    1.911661] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
> [    1.916060] sd 0:0:0:0: [sda] Write Protect is off
> [    1.920201] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.920294] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.930972]  sda: sda1 sda2
> [    1.937288] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.103269] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
> [    2.232055] ata2: SATA link down (SStatus 0 SControl 300)
> [    2.392082] tsc: Refined TSC clocksource calibration: 1861.999 MHz
> [    2.479441] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [    2.502161] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input2
> [    2.511426] PM: Hibernation image partition 8:1 present
> [    2.511429] PM: Looking for hibernation image.
> [    2.512039] PM: Image not found (code -22)
> [    2.512042] PM: Hibernation image not present or could not be loaded.
> [    2.514720] Freeing unused kernel memory: 1460K (ffffffff81ac8000 - ffffffff81c35000)
> [    2.519756] Write protecting the kernel read-only data: 10240k
> [    2.526122] Freeing unused kernel memory: 260K (ffff8800015bf000 - ffff880001600000)
> [    2.536450] Freeing unused kernel memory: 1412K (ffff88000189f000 - ffff880001a00000)
> [    2.616830] thermal LNXTHERM:00: registered as thermal_zone0
> [    2.621829] ACPI: Thermal Zone [THM0] (48 C)
> [    2.650054] thermal LNXTHERM:01: registered as thermal_zone1
> [    2.655083] ACPI: Thermal Zone [THM1] (48 C)
> [    2.667588] scsi4 : ata_generic
> [    2.673095] scsi5 : ata_generic
> [    2.678232] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
> [    2.682993] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
> [    3.034744] Monitor-Mwait will be used to enter C-1 state
> [    3.034826] Monitor-Mwait will be used to enter C-2 state
> [    3.034852] Monitor-Mwait will be used to enter C-3 state
> [    3.034873] tsc: Marking TSC unstable due to TSC halts in idle
> [    3.039783] ACPI: acpi_idle registered with cpuidle
> [    3.059358] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
> [    3.080260] systemd-udevd[109]: starting version 195
> [    3.137107] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
> [    3.148166] ACPI: Lid Switch [LID]
> [    3.153410] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input4
> [    3.165923] ACPI: Sleep Button [SLPB]
> [    3.171334] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
> [    3.181825] ACPI: Power Button [PWRF]
> [    3.202682] [drm] Initialized drm 1.1.0 20060810
> [    3.223135] ACPI: bus type USB registered
> [    3.229050] usbcore: registered new interface driver usbfs
> [    3.235023] usbcore: registered new interface driver hub
> [    3.246994] usbcore: registered new device driver usb
> [    3.265254] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.278450] [drm:i915_dump_device_info], i915 device info: gen=4, pciid=0x2a42 flags=is_mobile,need_gfx_hws,is_g4x,has_fbc,has_pipe_cxsr,has_hotplug,supports_tv,
> [    3.278637] [drm:intel_detect_pch], No PCH found?
> [    3.278642] [drm] Memory usable by graphics device = 2048M
> [    3.283500] [drm:i915_gem_gtt_init], GMADR size = 256M
> [    3.283503] [drm:i915_gem_gtt_init], GTT stolen size = 32M
> [    3.283530] checking generic (d0000000 1ff0000) vs hw (d0000000 10000000)
> [    3.283533] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
> [    3.288657] Console: switching to colour dummy device 80x25
> [    3.301341] uhci_hcd: USB Universal Host Controller Interface driver
> [    3.358049] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7c98b1f3
> [    3.358068] [drm:intel_opregion_setup], Public ACPI methods supported
> [    3.358070] [drm:intel_opregion_setup], SWSCI supported
> [    3.380252] [drm:swsci_setup], SWSCI BIOS requested (00010673) SBCB callbacks that are not supported (00080673)
> [    3.380258] [drm:swsci_setup], SWSCI GBDA callbacks 00000cf3, SBCB callbacks 00010673
> [    3.380260] [drm:intel_opregion_setup], ASLE supported
> [    3.380491] i915 0000:00:02.0: irq 44 for MSI/MSI-X
> [    3.380531] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    3.380541] [drm] Driver supports precise vblank timestamp query.
> [    3.380549] [drm:init_vbt_defaults], Set default to SSC at 100000 kHz
> [    3.380552] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT CANTIGA        d
> [    3.380556] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 1 lvds_ssc_freq 100000 display_clock_mode 0 fdi_rx_polarity_inverted 0
> [    3.380559] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
> [    3.380564] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
> [    3.380569] [drm:drm_mode_debug_printmodeline], Modeline 0:"1440x900" 0 74080 1440 1464 1480 1600 900 903 909 926 0x8 0xa
> [    3.380572] [drm:parse_lfp_panel_data], VBT initial LVDS value 42300300
> [    3.380575] [drm:parse_lfp_backlight], VBT backlight PWM modulation frequency 165 Hz, active high, min brightness 4, level 0
> [    3.380579] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
> [    3.380583] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
> [    3.380586] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
> [    3.380590] [drm:parse_mipi], No MIPI BDB found
> [    3.380644] [drm:intel_dsm_pci_probe], no _DSM method for intel device
> [    3.380742] [drm:i915_gem_init_stolen], found 33554432 bytes of stolen memory at 7d000000
> [    3.381150] [drm:intel_modeset_init], 2 display pipes available.
> [    3.381236] [drm:intel_modeset_init], pipe A sprite A init failed: -19
> [    3.381258] [drm:intel_modeset_init], pipe B sprite B init failed: -19
> [    3.381268] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    3.464136] [drm:intel_lvds_init], using preferred mode from EDID: 
> [    3.464143] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [    3.464150] [drm:intel_lvds_init], detected single-link lvds configuration
> [    3.464983] [drm:intel_panel_setup_backlight], backlight initialized, enabled, brightness 3211215/3211215, sysfs interface registered
> [    3.465296] [drm:intel_setup_outputs], probing SDVOB
> [    3.465305] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 1
> [    3.478161] [drm:intel_sdvo_read_byte], i2c transfer returned -6
> [    3.478165] [drm:intel_sdvo_init], No SDVO device found on SDVOB
> [    3.478677] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus dpb. force bit now 0
> [    3.478681] [drm:intel_setup_outputs], probing HDMI on SDVOB
> [    3.479243] [drm:intel_dp_init_connector], Adding DP connector on port B
> [    3.479562] [drm:intel_dp_i2c_init], i2c_init DPDDC-B
> [    3.482038] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.482047] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
> [    3.484406] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.484415] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
> [    3.484681] [drm:intel_setup_outputs], probing SDVOC
> [    3.484689] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 1
> [    3.497606] [drm:intel_sdvo_read_byte], i2c transfer returned -6
> [    3.497609] [drm:intel_sdvo_init], No SDVO device found on SDVOC
> [    3.497704] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus dpb. force bit now 0
> [    3.497708] [drm:intel_setup_outputs], probing HDMI on SDVOC
> [    3.498007] [drm:intel_dp_init_connector], Adding DP connector on port C
> [    3.498277] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
> [    3.500635] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.500644] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
> [    3.503002] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.503010] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
> [    3.503227] [drm:intel_dp_init_connector], Adding DP connector on port D
> [    3.503480] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
> [    3.505843] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.505852] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
> [    3.508211] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.508219] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
> [    3.508429] [drm:intel_tv_init], Integrated TV is not present.
> [    3.508437] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, 7ffff000]
> [    3.511157] [drm:init_status_page], render ring hws offset: 0x00001000
> [    3.511160] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
> [    3.511165] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
> [    3.511275] [drm:init_status_page], bsd ring hws offset: 0x00024000
> [    3.511277] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
> [    3.511282] [drm:i915_pages_create_for_stolen], offset=0x20000, size=131072
> [    3.511365] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
> [    3.511377] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
> [    3.511382] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
> [    3.511386] [drm:intel_modeset_readout_hw_state], [ENCODER:13:DAC-13] hw state readout: disabled, pipe A
> [    3.511389] [drm:intel_modeset_readout_hw_state], [ENCODER:14:TMDS-14] hw state readout: disabled, pipe A
> [    3.511392] [drm:intel_modeset_readout_hw_state], [ENCODER:18:TMDS-18] hw state readout: disabled, pipe A
> [    3.511395] [drm:intel_modeset_readout_hw_state], [ENCODER:20:TMDS-20] hw state readout: disabled, pipe A
> [    3.511398] [drm:intel_modeset_readout_hw_state], [ENCODER:22:TMDS-22] hw state readout: disabled, pipe A
> [    3.511402] [drm:intel_modeset_readout_hw_state], [ENCODER:24:TMDS-24] hw state readout: disabled, pipe A
> [    3.511405] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
> [    3.511408] [drm:intel_modeset_readout_hw_state], [CONNECTOR:12:VGA-1] hw state readout: disabled
> [    3.511411] [drm:intel_modeset_readout_hw_state], [CONNECTOR:15:HDMI-A-1] hw state readout: disabled
> [    3.511414] [drm:intel_modeset_readout_hw_state], [CONNECTOR:19:DP-1] hw state readout: disabled
> [    3.511417] [drm:intel_modeset_readout_hw_state], [CONNECTOR:21:HDMI-A-2] hw state readout: disabled
> [    3.511420] [drm:intel_modeset_readout_hw_state], [CONNECTOR:23:DP-2] hw state readout: disabled
> [    3.511423] [drm:intel_modeset_readout_hw_state], [CONNECTOR:25:DP-3] hw state readout: disabled
> [    3.511428] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
> [    3.511430] [drm:intel_dump_pipe_config], cpu_transcoder: A
> [    3.511432] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
> [    3.511435] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [    3.511438] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [    3.511440] [drm:intel_dump_pipe_config], requested mode:
> [    3.511443] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> [    3.511445] [drm:intel_dump_pipe_config], adjusted mode:
> [    3.511448] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> [    3.511451] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
> [    3.511453] [drm:intel_dump_pipe_config], port clock: 0
> [    3.511455] [drm:intel_dump_pipe_config], pipe src size: 0x0
> [    3.511457] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
> [    3.511460] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
> [    3.511462] [drm:intel_dump_pipe_config], ips: 0
> [    3.511464] [drm:intel_dump_pipe_config], double wide: 0
> [    3.511467] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
> [    3.511469] [drm:intel_dump_pipe_config], cpu_transcoder: B
> [    3.511471] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
> [    3.511474] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [    3.511476] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [    3.511478] [drm:intel_dump_pipe_config], requested mode:
> [    3.511482] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 800 0 0 0 600 0 0 0 0x0 0x0
> [    3.511484] [drm:intel_dump_pipe_config], adjusted mode:
> [    3.511487] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
> [    3.511490] [drm:intel_dump_crtc_timings], crtc timings: 73810 1440 1464 1480 1600 900 903 909 926, type: 0x0 flags: 0xa
> [    3.511492] [drm:intel_dump_pipe_config], port clock: 73810
> [    3.511494] [drm:intel_dump_pipe_config], pipe src size: 800x600
> [    3.511497] [drm:intel_dump_pipe_config], gmch pfit: control: 0xa0000000, ratios: 0x0aab08e4, lvds border: 0x00008000
> [    3.511499] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
> [    3.511501] [drm:intel_dump_pipe_config], ips: 0
> [    3.511503] [drm:intel_dump_pipe_config], double wide: 0
> [    3.511506] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
> [    3.511513] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
> [    3.511516] [drm:check_encoder_state], [ENCODER:13:DAC-13]
> [    3.511519] [drm:check_encoder_state], [ENCODER:14:TMDS-14]
> [    3.511522] [drm:check_encoder_state], [ENCODER:18:TMDS-18]
> [    3.511524] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
> [    3.511527] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
> [    3.511530] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
> [    3.511533] [drm:check_crtc_state], [CRTC:3]
> [    3.511536] [drm:check_crtc_state], [CRTC:4]
> [    3.511562] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [    3.511565] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [    3.511578] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [    3.511582] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [    3.511584] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [    3.511587] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [    3.524126] [drm:intel_crt_detect], CRT not detected via hotplug
> [    3.528116] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [    3.528121] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [    3.528124] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [    3.528127] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [    3.528446] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [    3.528448] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [    3.528450] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [    3.528453] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [    3.528456] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [    3.528458] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [    3.584116] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
> [    3.596171] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [    3.596175] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [    3.596177] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [    3.596180] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [    3.598609] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.606458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.614533] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.620062] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [    3.620066] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [    3.620068] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [    3.628063] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [    3.628067] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [    3.628070] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [    3.628073] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [    3.628075] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [    3.630477] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.638457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.646458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.652061] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [    3.652064] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [    3.652066] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [    3.654467] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.662457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.670546] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    3.676061] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [    3.676064] [drm:drm_setup_crtcs], 
> [    3.676068] [drm:drm_enable_connectors], connector 5 enabled? yes
> [    3.676070] [drm:drm_enable_connectors], connector 12 enabled? no
> [    3.676073] [drm:drm_enable_connectors], connector 15 enabled? no
> [    3.676075] [drm:drm_enable_connectors], connector 19 enabled? no
> [    3.676077] [drm:drm_enable_connectors], connector 21 enabled? no
> [    3.676079] [drm:drm_enable_connectors], connector 23 enabled? no
> [    3.676082] [drm:drm_enable_connectors], connector 25 enabled? no
> [    3.676085] [drm:drm_target_preferred], looking for cmdline mode on connector 5
> [    3.676087] [drm:drm_target_preferred], looking for preferred mode on connector 5
> [    3.676090] [drm:drm_target_preferred], found mode 1440x900
> [    3.676092] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
> [    3.676097] [drm:drm_setup_crtcs], desired mode 1440x900 set on crtc 3
> [    3.676104] [drm:intelfb_create], no BIOS fb, allocating a new one
> [    3.676106] [drm:i915_gem_object_create_stolen], creating stolen object: size=4f2000
> [    3.676113] [drm:i915_pages_create_for_stolen], offset=0x40000, size=5185536
> [    3.678526] [drm:intelfb_create], allocated 1440x900 fb: 0x00046000, bo ffff8800377db740
> [    3.679044] fbcon: inteldrmfb (fb0) is primary device
> [    3.679587] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [    3.679592] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
> [    3.679594] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
> [    3.679597] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> [    3.679600] [drm:drm_mode_debug_printmodeline], Modeline 9:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [    3.679602] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
> [    3.679604] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    3.679605] [drm:intel_modeset_stage_output_state], crtc changed, full mode switch
> [    3.679609] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 2
> [    3.679614] [drm:connected_sink_compute_bpp], [CONNECTOR:5:LVDS-1] checking for sink bpp constrains
> [    3.679636] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
> [    3.679638] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
> [    3.679640] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
> [    3.679641] [drm:intel_dump_pipe_config], cpu_transcoder: A
> [    3.679642] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
> [    3.679644] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [    3.679646] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [    3.679647] [drm:intel_dump_pipe_config], requested mode:
> [    3.679651] [drm:drm_mode_debug_printmodeline], Modeline 0:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [    3.679652] [drm:intel_dump_pipe_config], adjusted mode:
> [    3.679655] [drm:drm_mode_debug_printmodeline], Modeline 0:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [    3.679657] [drm:intel_dump_crtc_timings], crtc timings: 74080 1440 1464 1480 1600 900 903 909 926, type: 0x48 flags: 0xa
> [    3.679659] [drm:intel_dump_pipe_config], port clock: 74080
> [    3.679660] [drm:intel_dump_pipe_config], pipe src size: 1440x900
> [    3.679662] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
> [    3.679663] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
> [    3.679665] [drm:intel_dump_pipe_config], ips: 0
> [    3.679666] [drm:intel_dump_pipe_config], double wide: 0
> [    3.679686] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
> [    3.679829] [drm:asle_work], No request on ASLC interrupt 0x00000000
> [    3.980146] [drm:i9xx_pfit_disable], disabling pfit, current: 0xa0000000
> [    3.980156] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=2, cursor=2, SR: plane=0, cursor=0
> [    3.980161] [drm:intel_update_fbc], no output, disabling
> [    3.980173] [drm:i9xx_get_refclk], using SSC reference clock of 100000 kHz
> [    3.980218] [drm:i9xx_set_pipeconf], disabling CxSR downclocking
> [    3.980254] [drm:i9xx_update_plane], Writing base 00046000 00000000 0 0 5760
> [    3.980268] [drm:intel_crtc_mode_set], [ENCODER:6:LVDS-6] set [MODE:0:1440x900]
> [    3.981006] [drm:g4x_check_srwm], SR watermark: display plane 58, cursor 6
> [    3.981008] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=26, cursor=6, B: plane=2, cursor=2, SR: plane=58, cursor=6
> [    4.044128] [drm:intel_update_fbc], disabled per chip default
> [    4.180151] [drm:intel_panel_enable_backlight], pipe A
> [    4.180155] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3211215
> [    4.180165] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
> [    4.180174] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
> [    4.180177] [drm:check_encoder_state], [ENCODER:13:DAC-13]
> [    4.180180] [drm:check_encoder_state], [ENCODER:14:TMDS-14]
> [    4.180183] [drm:check_encoder_state], [ENCODER:18:TMDS-18]
> [    4.180186] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
> [    4.180189] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
> [    4.180192] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
> [    4.180194] [drm:check_crtc_state], [CRTC:3]
> [    4.180209] [drm:asle_work], No request on ASLC interrupt 0x00000000
> [    4.180213] [drm:check_crtc_state], [CRTC:4]
> [    4.180218] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [    4.180223] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [    4.180226] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    4.180239] Console: switching to colour frame buffer device 180x56
> [    4.180252] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [    4.180263] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [    4.180265] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    4.184146] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    4.184178] i915 0000:00:02.0: registered panic notifier
> [    4.185431] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    4.189353] [drm:asle_set_backlight], bclp = 0x80000007
> [    4.189365] [drm:asle_set_backlight], updating opregion backlight 7/255
> [    4.189384] [drm:intel_panel_actually_set_backlight], set backlight PWM = 88151
> [    4.189416] [drm:asle_set_pwm_freq], PWM freq is not supported
> [    4.189420] [drm:asle_work], No request on ASLC interrupt 0x00010000
> [    4.191738] [drm:asle_set_backlight], bclp = 0x800000ff
> [    4.191742] [drm:asle_set_backlight], updating opregion backlight 255/255
> [    4.191745] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3211215
> [    4.191750] [drm:asle_set_pwm_freq], PWM freq is not supported
> [    4.193049] [drm:asle_work], No request on ASLC interrupt 0x00010000
> [    4.193822] acpi device:02: registered as cooling_device2
> [    4.194594] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
> [    4.195426] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    4.196154] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    4.196382] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    4.196457] uhci_hcd 0000:00:1a.0: detected 2 ports
> [    4.196633] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
> [    4.197318] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.197359] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.197402] usb usb1: Product: UHCI Host Controller
> [    4.197431] usb usb1: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec uhci_hcd
> [    4.197472] usb usb1: SerialNumber: 0000:00:1a.0
> [    4.199985] hub 1-0:1.0: USB hub found
> [    4.200275] hub 1-0:1.0: 2 ports detected
> [    4.202213] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    4.202269] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
> [    4.202332] uhci_hcd 0000:00:1a.1: detected 2 ports
> [    4.202457] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
> [    4.202985] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.203027] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.203070] usb usb2: Product: UHCI Host Controller
> [    4.203101] usb usb2: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec uhci_hcd
> [    4.203143] usb usb2: SerialNumber: 0000:00:1a.1
> [    4.204551] hub 2-0:1.0: USB hub found
> [    4.204608] hub 2-0:1.0: 2 ports detected
> [    4.206787] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    4.206834] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
> [    4.208320] uhci_hcd 0000:00:1a.2: detected 2 ports
> [    4.209857] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
> [    4.211536] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.213057] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.214453] usb usb3: Product: UHCI Host Controller
> [    4.215839] usb usb3: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec uhci_hcd
> [    4.217262] usb usb3: SerialNumber: 0000:00:1a.2
> [    4.219796] hub 3-0:1.0: USB hub found
> [    4.221328] hub 3-0:1.0: 2 ports detected
> [    4.224174] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    4.225577] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
> [    4.226975] uhci_hcd 0000:00:1d.0: detected 2 ports
> [    4.228469] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
> [    4.230289] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.231664] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.233047] usb usb4: Product: UHCI Host Controller
> [    4.234411] usb usb4: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec uhci_hcd
> [    4.235770] usb usb4: SerialNumber: 0000:00:1d.0
> [    4.238147] hub 4-0:1.0: USB hub found
> [    4.239557] hub 4-0:1.0: 2 ports detected
> [    4.242199] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    4.243534] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
> [    4.244900] uhci_hcd 0000:00:1d.1: detected 2 ports
> [    4.246281] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
> [    4.247992] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.249321] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.250616] usb usb5: Product: UHCI Host Controller
> [    4.251883] usb usb5: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec uhci_hcd
> [    4.253181] usb usb5: SerialNumber: 0000:00:1d.1
> [    4.255390] hub 5-0:1.0: USB hub found
> [    4.256726] hub 5-0:1.0: 2 ports detected
> [    4.259244] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    4.260521] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
> [    4.261789] uhci_hcd 0000:00:1d.2: detected 2 ports
> [    4.263034] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
> [    4.264723] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    4.266055] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    4.267385] usb usb6: Product: UHCI Host Controller
> [    4.268726] usb usb6: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec uhci_hcd
> [    4.269974] usb usb6: SerialNumber: 0000:00:1d.2
> [    4.272172] hub 6-0:1.0: USB hub found
> [    4.273469] hub 6-0:1.0: 2 ports detected
> [    4.405964] [drm:i915_gem_open], 
> [    4.406129] [drm:intel_crtc_cursor_set], cursor off
> [    4.406139] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [    4.406146] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [    4.406149] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    4.406153] [drm:intel_crtc_cursor_set], cursor off
> [    4.406156] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [    4.406160] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [    4.406163] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    4.406221] [drm:i915_gem_open], 
> [    4.406244] [drm:intel_crtc_cursor_set], cursor off
> [    4.406248] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [    4.406253] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [    4.406255] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    4.406259] [drm:intel_crtc_cursor_set], cursor off
> [    4.406261] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [    4.406265] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [    4.406268] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    4.406318] [drm:i915_gem_open], 
> [    4.406472] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[7] ENCODERS[7]
> [    4.406491] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[7] ENCODERS[7]
> [    4.406509] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [    4.406517] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [    4.406520] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [    4.406539] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [    4.406544] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [    4.406548] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [    4.411274] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [    4.411282] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [    4.411285] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [    4.424150] [drm:intel_crt_detect], CRT not detected via hotplug
> [    4.428131] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [    4.428136] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [    4.428140] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [    4.428143] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [    4.428456] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [    4.428458] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [    4.428460] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [    4.428464] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [    4.428470] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [    4.428474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [    4.428477] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [    4.436128] [drm:intel_crt_detect], CRT not detected via hotplug
> [    4.440124] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [    4.440129] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [    4.440131] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [    4.440134] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [    4.440446] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [    4.440448] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [    4.440450] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [    4.440453] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [    4.440462] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [    4.440466] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [    4.440469] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [    4.452707] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [    4.452711] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [    4.452715] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [    4.452718] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [    4.452720] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [    4.464978] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [    4.464981] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [    4.464989] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [    4.464992] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [    4.464995] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [    4.467460] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.474459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.482544] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.488061] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [    4.488067] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [    4.488071] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [    4.488073] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [    4.490474] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.498458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.506457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.512061] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [    4.512070] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [    4.512074] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [    4.512077] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [    4.516059] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [    4.516063] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [    4.516066] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [    4.516071] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [    4.516075] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [    4.516077] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [    4.520058] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [    4.520062] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [    4.520065] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [    4.520075] usb 2-1: new full-speed USB device number 2 using uhci_hcd
> [    4.520076] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [    4.520079] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [    4.520081] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [    4.523817] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.530539] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.538458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.544061] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [    4.544067] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [    4.544071] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [    4.544074] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [    4.546475] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.554458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.562457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.568060] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [    4.568070] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [    4.568074] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [    4.568076] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [    4.570476] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.578458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.586541] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.592062] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [    4.592067] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [    4.592071] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [    4.592074] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [    4.594475] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.602458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.610457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [    4.616061] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [    4.616269] [drm:drm_mode_addfb], [FB:27]
> [    4.670528] PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
> [    4.670535] PM: Marking nosave pages: [mem 0x7c4a1000-0x7c4a6fff]
> [    4.670538] PM: Marking nosave pages: [mem 0x7c5b7000-0x7c60efff]
> [    4.670542] PM: Marking nosave pages: [mem 0x7c6c6000-0x7c9fefff]
> [    4.670563] PM: Basic memory bitmaps created
> [    4.680981] PM: Basic memory bitmaps freed
> [    4.681036] video LNXVIDEO:00: Restoring backlight state
> [    4.684265] [drm:asle_set_backlight], bclp = 0x800000ff
> [    4.684270] [drm:asle_set_backlight], updating opregion backlight 255/255
> [    4.684275] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3211215
> [    4.684313] [drm:asle_set_pwm_freq], PWM freq is not supported
> [    4.684332] [drm:asle_work], No request on ASLC interrupt 0x00010000
> [    4.687592] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
> [    4.687637] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    4.687678] usb 2-1: Product: Fingerprint Sensor
> [    4.705743] PM: Starting manual resume from disk
> [    4.705800] PM: Hibernation image partition 8:1 present
> [    4.705803] PM: Looking for hibernation image.
> [    4.706313] PM: Image not found (code -22)
> [    4.706318] PM: Hibernation image not present or could not be loaded.
> [    4.765812] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
> [    4.801952] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr
> [    4.808066] usb 2-2: new full-speed USB device number 3 using uhci_hcd
> [    4.968632] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
> [    4.968682] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    4.968724] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
> [    4.968764] usb 2-2: Manufacturer: Lenovo Computer Corp
> [    5.171050] random: systemd urandom read with 93 bits of entropy available
> [    5.333994] systemd-readahead[260]: Bumped block_nr parameter of 8:0 to 20480. This is a temporary hack and should be removed one day.
> [    5.422707] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr
> [    5.483891] systemd-udevd[291]: starting version 195
> [    5.639947] random: nonblocking pool is initialized
> [    5.819921] systemd-journald[265]: Received SIGUSR1
> [    6.199644] [drm:intel_crtc_cursor_set], cursor off
> [    6.199653] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [    6.199661] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [    6.199665] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    6.199671] [drm:intel_crtc_cursor_set], cursor off
> [    6.199674] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [    6.199678] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [    6.199682] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [    6.248230] tpm_tis 00:09: 1.2 TPM (device-id 0x1020, rev-id 6)
> [    6.248232] tpm_tis 00:09: Intel iTPM workaround enabled
> [    6.269758] ACPI: Battery Slot [BAT0] (battery present)
> [    6.272422] ACPI: AC Adapter [AC] (on-line)
> [    6.316422] wmi: Mapper loaded
> [    6.361415] pps_core: LinuxPPS API ver. 1 registered
> [    6.362681] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    6.376757] PTP clock support registered
> [    6.400215] ehci-pci: EHCI PCI platform driver
> [    6.427404] WARNING! power/level is deprecated; use power/control instead
> [    6.429470] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
> [    6.430830] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
> [    6.432103] usb 2-1: USB disconnect, device number 2
> [    6.436566] usb 2-2: USB disconnect, device number 3
> [    6.467117] ehci-pci 0000:00:1a.7: EHCI Host Controller
> [    6.468633] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 7
> [    6.470006] ehci-pci 0000:00:1a.7: debug port 1
> [    6.475410] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
> [    6.475505] ehci-pci 0000:00:1a.7: irq 23, io mem 0xf2826c00
> [    6.488075] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    6.490519] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
> [    6.491931] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.493362] usb usb7: Product: EHCI Host Controller
> [    6.494760] usb usb7: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec ehci_hcd
> [    6.496232] usb usb7: SerialNumber: 0000:00:1a.7
> [    6.514396] hub 7-0:1.0: USB hub found
> [    6.516194] hub 7-0:1.0: 6 ports detected
> [    6.557523] hub 1-0:1.0: USB hub found
> [    6.560824] hub 1-0:1.0: 2 ports detected
> [    6.562667] input: PC Speaker as /devices/platform/pcspkr/input/input7
> [    6.585670] Bluetooth: Core ver 2.18
> [    6.587094] NET: Registered protocol family 31
> [    6.588563] Bluetooth: HCI device and connection manager initialized
> [    6.590056] Bluetooth: HCI socket layer initialized
> [    6.591457] Bluetooth: L2CAP socket layer initialized
> [    6.592914] Bluetooth: SCO socket layer initialized
> [    6.601126] usbcore: registered new interface driver btusb
> [    6.608530] hub 2-0:1.0: USB hub found
> [    6.623305] hub 2-0:1.0: 2 ports detected
> [    6.648172] cfg80211: Calling CRDA to update world regulatory domain
> [    6.652627] hub 3-0:1.0: USB hub found
> [    6.654689] hub 3-0:1.0: 2 ports detected
> [    6.699274] Intel(R) Wireless WiFi driver for Linux, in-tree:d
> [    6.700712] Copyright(c) 2003- 2014 Intel Corporation
> [    6.702602] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
> [    6.718505] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692 op_mode iwldvm
> [    6.729554] ehci-pci 0000:00:1d.7: EHCI Host Controller
> [    6.731033] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 8
> [    6.732582] ehci-pci 0000:00:1d.7: debug port 1
> [    6.737946] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
> [    6.738166] ehci-pci 0000:00:1d.7: irq 19, io mem 0xf2827000
> [    6.786608] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    6.882230] thinkpad_acpi: ThinkPad ACPI Extras v0.25
> [    6.883665] thinkpad_acpi: http://ibm-acpi.sf.net/
> [    6.885135] thinkpad_acpi: ThinkPad BIOS 6DET38WW (2.02 ), EC 7XHT21WW-1.03
> [    6.886547] thinkpad_acpi: Lenovo ThinkPad X200s, model 7470BN2
> [    6.914655] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
> [    6.916395] thinkpad_acpi: radio switch found; radios are enabled
> [    6.917920] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [    6.919414] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [    6.925233] thinkpad_acpi: setting the hotkey mask to 0x00ffffff is likely not the best way to go about it
> [    6.926795] thinkpad_acpi: please consider using the driver defaults, and refer to up-to-date thinkpad-acpi documentation
> [    6.959698] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [    6.961569] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [    6.963153] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [    6.964659] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [    6.966167] iwlwifi 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
> [    6.967993] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [    6.994052] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [    6.998828] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> [    7.001509] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    7.003340] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
> [    7.004856] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.006347] usb usb8: Product: EHCI Host Controller
> [    7.007828] usb usb8: Manufacturer: Linux 3.14.0-rc4-00034-g6dba6ec ehci_hcd
> [    7.009418] usb usb8: SerialNumber: 0000:00:1d.7
> [    7.014441] hub 8-0:1.0: USB hub found
> [    7.017144] hub 8-0:1.0: 6 ports detected
> [    7.022604] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [    7.038011] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
> [    7.044481] hub 4-0:1.0: USB hub found
> [    7.046753] hub 4-0:1.0: 2 ports detected
> [    7.093019] hub 5-0:1.0: USB hub found
> [    7.095245] hub 5-0:1.0: 2 ports detected
> [    7.120780] hub 6-0:1.0: USB hub found
> [    7.129446] hub 6-0:1.0: 2 ports detected
> [    7.144463] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    7.146137] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [    7.215551] cfg80211: World regulatory domain updated:
> [    7.217168] cfg80211:  DFS Master region: unset
> [    7.217196] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [    7.220371] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    7.221927] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [    7.223587] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [    7.225175] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    7.226714] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    7.359711] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1f:16:15:7a:65
> [    7.361349] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> [    7.362952] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
> [    7.365144] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
> [    7.367369] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20131218/utaddress-258)
> [    7.370745] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    7.372502] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20131218/utaddress-258)
> [    7.376091] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    7.377956] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20131218/utaddress-258)
> [    7.381810] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    7.383741] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    7.386865] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> [    7.405724] iTCO_vendor_support: vendor-support=0
> [    7.414664] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
> [    7.416778] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
> [    7.422078] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    7.424368] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
> [    7.427045] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=1 (0x1a/0x0/0x0/0x0/0x0) type:speaker
> [    7.427050] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    7.427053] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=2 (0x19/0x16/0x0/0x0/0x0)
> [    7.427055] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
> [    7.427058] ALSA sound/pci/hda/hda_auto_parser.c:405    dig-out=0x1c/0x0
> [    7.427060] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
> [    7.427064] ALSA sound/pci/hda/hda_auto_parser.c:410      Mic=0x18
> [    7.427068] ALSA sound/pci/hda/hda_auto_parser.c:410      Internal Mic=0x1d
> [    7.427072] ALSA sound/pci/hda/hda_auto_parser.c:410      Dock Mic=0x17
> [    7.428885] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
> [    7.431459] ALSA sound/pci/hda/patch_conexant.c:3517 hda_codec: Enable sync_write for stable communication
> [    7.438609] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
> [    7.443221] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> [    7.447215] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> [    7.449807] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [    7.509056] Adding 2104476k swap on /dev/sda1.  Priority:-1 extents:1 across:2104476k SS
> [    7.756120] usb 2-1: new full-speed USB device number 4 using uhci_hcd
> [    7.928170] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
> [    7.928176] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [    7.928179] usb 2-1: Product: Fingerprint Sensor
> [    8.172104] usb 2-2: new full-speed USB device number 5 using uhci_hcd
> [    8.342173] usb 2-2: New USB device found, idVendor=0a5c, idProduct=2145
> [    8.342179] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    8.342183] usb 2-2: Product: ThinkPad Bluetooth with Enhanced Data Rate II
> [    8.342186] usb 2-2: Manufacturer: Lenovo Computer Corp
> [    8.439036] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    8.439042] Bluetooth: BNEP filters: protocol multicast
> [    8.439063] Bluetooth: BNEP socket layer initialized
> [    8.441923] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [    8.442325] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [    8.487517] Bluetooth: RFCOMM TTY layer initialized
> [    8.487541] Bluetooth: RFCOMM socket layer initialized
> [    8.487560] Bluetooth: RFCOMM ver 1.11
> [    8.552245] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [    8.552641] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [    8.584478] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [    9.701221] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    9.761600] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    9.828618] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [    9.941027] tun: Universal TUN/TAP device driver, 1.6
> [    9.941032] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [   10.198811] [drm:i915_gem_open], 
> [   10.198875] [drm:intel_crtc_cursor_set], cursor off
> [   10.198882] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [   10.198889] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [   10.198893] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.198898] [drm:intel_crtc_cursor_set], cursor off
> [   10.198902] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [   10.198906] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [   10.198909] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.221815] [drm:i915_gem_open], 
> [   10.221853] [drm:intel_crtc_cursor_set], cursor off
> [   10.221858] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [   10.221864] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [   10.221868] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.221872] [drm:intel_crtc_cursor_set], cursor off
> [   10.221875] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [   10.221878] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [   10.221881] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.221936] [drm:i915_gem_open], 
> [   10.221981] [drm:intel_crtc_cursor_set], cursor off
> [   10.221985] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [   10.221989] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [   10.221992] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.221996] [drm:intel_crtc_cursor_set], cursor off
> [   10.221999] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [   10.222002] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [   10.222005] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.222220] [drm:i915_gem_open], 
> [   10.222248] [drm:intel_crtc_cursor_set], cursor off
> [   10.222252] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [   10.222257] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [   10.222260] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.222263] [drm:intel_crtc_cursor_set], cursor off
> [   10.222266] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [   10.222269] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [   10.222272] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.222326] [drm:i915_gem_open], 
> [   10.222785] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[7] ENCODERS[7]
> [   10.222796] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[7] ENCODERS[7]
> [   10.222883] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   10.222887] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   10.222890] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   10.222906] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   10.222910] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   10.222914] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   10.224499] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   10.224504] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   10.224508] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   10.232155] [drm:intel_crt_detect], CRT not detected via hotplug
> [   10.236353] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   10.236365] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.236372] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   10.236379] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   10.236790] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.236797] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   10.236803] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   10.236811] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   10.236825] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   10.236835] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   10.236842] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   10.244216] [drm:intel_crt_detect], CRT not detected via hotplug
> [   10.248281] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   10.248291] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.248297] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   10.248304] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   10.248715] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.248722] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   10.248728] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   10.248735] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   10.248872] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   10.248884] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   10.248891] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   10.260888] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   10.260897] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   10.260942] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   10.260953] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   10.260959] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   10.272941] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   10.272945] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   10.273010] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   10.273014] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   10.273017] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   10.275451] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.282579] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.290611] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.296163] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   10.296179] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   10.296189] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   10.296196] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   10.298652] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.306648] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.314602] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.320863] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   10.321006] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   10.321017] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   10.321024] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   10.324267] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   10.324276] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   10.324284] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   10.324297] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   10.324307] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   10.324313] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   10.328240] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   10.328251] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   10.328260] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   10.328404] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   10.328416] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   10.328422] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   10.330843] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.338620] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.346598] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.352214] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   10.352231] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   10.352241] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   10.352248] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   10.354706] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.362603] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.370609] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.376206] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   10.376365] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   10.376377] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   10.376384] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   10.378840] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.386616] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.394605] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.400209] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   10.400226] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   10.400236] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   10.400243] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   10.402698] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.410614] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.419318] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.424279] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   10.424459] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   10.424471] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   10.424479] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   10.424512] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   10.424523] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   10.424535] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   10.428495] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   10.428503] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   10.428507] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   10.436152] [drm:intel_crt_detect], CRT not detected via hotplug
> [   10.440221] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   10.440226] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.440229] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   10.440233] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   10.440555] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.440559] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   10.440562] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   10.440565] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   10.440572] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   10.440577] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   10.440580] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   10.448145] [drm:intel_crt_detect], CRT not detected via hotplug
> [   10.452201] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   10.452207] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.452210] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   10.452213] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   10.452536] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   10.452540] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   10.452543] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   10.452546] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   10.452623] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   10.452629] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   10.452633] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   10.464593] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   10.464597] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   10.464625] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   10.464630] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   10.464633] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   10.476630] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   10.476634] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   10.476713] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   10.476718] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   10.476722] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   10.479151] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.486580] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.494608] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.500159] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   10.500176] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   10.500186] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   10.500192] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   10.502649] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.510652] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.518605] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.524161] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   10.524292] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   10.524303] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   10.524310] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   10.528491] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   10.528502] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   10.528510] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   10.528524] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   10.528533] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   10.528540] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   10.532239] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   10.532251] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   10.532259] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   10.532391] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   10.532403] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   10.532409] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   10.534829] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.542609] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.550605] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.556124] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   10.556141] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   10.556151] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   10.556158] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   10.558607] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.566602] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.574577] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.580210] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   10.580343] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   10.580354] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   10.580361] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   10.582818] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.590601] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.598607] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.604207] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   10.604223] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   10.604233] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   10.604239] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   10.606696] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.614612] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.622530] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   10.628141] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   10.713095] [drm:asle_set_backlight], bclp = 0x800000ff
> [   10.713103] [drm:asle_set_backlight], updating opregion backlight 255/255
> [   10.713110] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3211215
> [   10.713119] [drm:asle_set_pwm_freq], PWM freq is not supported
> [   10.713124] [drm:asle_work], No request on ASLC interrupt 0x00010000
> [   10.715211] [drm:asle_set_backlight], bclp = 0x800000ff
> [   10.715216] [drm:asle_set_backlight], updating opregion backlight 255/255
> [   10.715220] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3211215
> [   10.715225] [drm:asle_set_pwm_freq], PWM freq is not supported
> [   10.715904] [drm:asle_work], No request on ASLC interrupt 0x00010000
> [   10.717049] [drm:drm_mode_addfb], [FB:27]
> [   10.717218] [drm:drm_mode_setcrtc], [CRTC:3]
> [   10.717254] [drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
> [   10.717258] [drm:intel_crtc_set_config], [CRTC:3] [FB:27] #connectors=1 (x y) (0 0)
> [   10.717264] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=1
> [   10.717268] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.759214] [drm:i9xx_update_plane], Writing base 00538000 00000000 0 0 15360
> [   10.764633] [drm:drm_mode_setcrtc], [CRTC:4]
> [   10.764643] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [   10.764656] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [   10.764664] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.778383] [drm:drm_mode_addfb], [FB:28]
> [   10.778523] [drm:drm_mode_setcrtc], [CRTC:3]
> [   10.778534] [drm:drm_mode_setcrtc], [CONNECTOR:5:LVDS-1]
> [   10.778538] [drm:intel_crtc_set_config], [CRTC:3] [FB:28] #connectors=1 (x y) (0 0)
> [   10.778555] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=1
> [   10.778560] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [   10.790282] [drm:i9xx_update_plane], Writing base 01938000 00000000 0 0 6144
> [   11.057334] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   11.057342] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   11.057346] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   11.057364] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   11.057369] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   11.057375] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   11.057688] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   11.057694] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   11.057697] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   11.072181] [drm:intel_crt_detect], CRT not detected via hotplug
> [   11.076273] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   11.076283] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   11.076290] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   11.076297] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   11.076711] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   11.076718] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   11.076723] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   11.076731] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   11.076745] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   11.076754] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   11.076761] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   11.084204] [drm:intel_crt_detect], CRT not detected via hotplug
> [   11.088279] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   11.088291] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   11.088298] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   11.088304] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   11.088717] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   11.088724] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   11.088730] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   11.088738] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   11.088784] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   11.088796] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   11.088803] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   11.100796] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   11.100806] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   11.100868] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   11.100879] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   11.100885] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   11.112834] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   11.112838] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   11.112860] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   11.112864] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   11.112867] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   11.115301] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.122579] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.130608] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.136152] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   11.136190] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   11.136200] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   11.136207] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   11.138664] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.146649] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.154611] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.160155] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   11.160204] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   11.160215] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   11.160222] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   11.164500] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   11.164511] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   11.164518] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   11.164532] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   11.164542] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   11.164548] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   11.168232] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   11.168246] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   11.168255] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   11.168284] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   11.168295] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   11.168301] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   11.170725] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.178610] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.186607] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.192200] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   11.192236] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   11.192247] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   11.192254] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   11.194711] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.202610] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.210601] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.216205] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   11.216256] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   11.216267] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   11.216274] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   11.218732] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.226605] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.234599] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.240202] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   11.240238] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   11.240249] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   11.240256] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   11.242712] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.250612] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.258580] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   11.264213] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   12.099257] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   12.101689] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.110466] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.118465] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.124177] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   12.126577] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.134469] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.142469] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.148191] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   12.150591] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.158484] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.166449] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.172169] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   12.184187] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   12.184515] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   12.188251] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   12.188256] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   12.188373] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   12.188482] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   12.196072] [drm:intel_crt_detect], CRT not detected via hotplug
> [   12.200198] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   12.200203] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   12.200206] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   12.200210] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   12.200533] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   12.200537] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   12.200539] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   12.288331] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   12.288341] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   12.288345] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   12.288363] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   12.288368] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   12.288374] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   12.288705] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   12.288711] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   12.288715] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   12.296093] [drm:intel_crt_detect], CRT not detected via hotplug
> [   12.300187] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   12.300193] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   12.300196] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   12.300199] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   12.300510] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   12.300513] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   12.300516] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   12.300519] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   12.300527] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   12.300531] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   12.300534] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   12.308058] [drm:intel_crt_detect], CRT not detected via hotplug
> [   12.312192] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   12.312197] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   12.312200] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   12.312203] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   12.312514] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   12.312517] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   12.312519] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   12.312523] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   12.312550] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   12.312555] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   12.312558] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   12.324461] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   12.324466] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   12.325360] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   12.325366] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   12.325369] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   12.337276] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   12.337280] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   12.337668] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   12.337674] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   12.337678] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   12.340081] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.350433] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.358480] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.364065] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   12.364084] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   12.364089] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   12.364092] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   12.366489] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.374445] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.382447] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.388048] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   12.388079] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   12.388084] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   12.388087] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   12.392482] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   12.392487] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   12.392491] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   12.392538] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   12.392543] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   12.392546] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   12.396575] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   12.396580] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   12.396584] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   12.396598] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   12.396602] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   12.396606] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   12.399005] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.406448] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.414481] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.420043] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   12.420073] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   12.420078] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   12.420081] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   12.422480] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.431057] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.438429] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.444054] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   12.444096] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   12.444102] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   12.444105] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   12.446506] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.446577] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
> [   12.454458] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.462459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.468092] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   12.468117] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   12.468123] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   12.468126] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   12.470525] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.478496] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.486449] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   12.492072] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   14.117491] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   14.220373] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   14.220809] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   19.208223] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   19.208233] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   19.208236] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   19.208256] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   19.208261] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   19.208266] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   19.208607] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   19.208613] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   19.208616] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   19.216054] [drm:intel_crt_detect], CRT not detected via hotplug
> [   19.220280] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   19.220287] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.220290] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   19.220294] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   19.220618] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.220621] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   19.220624] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   19.220629] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   19.220640] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   19.220645] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   19.220649] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   19.228033] [drm:intel_crt_detect], CRT not detected via hotplug
> [   19.232186] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   19.232192] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.232196] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   19.232199] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   19.232521] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.232525] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   19.232528] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   19.232532] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   19.232563] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   19.232569] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   19.232572] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   19.244708] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   19.244713] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   19.244737] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   19.244742] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   19.244745] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   19.256851] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   19.256855] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   19.256888] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   19.256893] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   19.256896] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   19.259326] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.266549] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.274545] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.280182] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   19.280220] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   19.280231] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   19.280238] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   19.282696] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.290619] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.298597] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.304199] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   19.304249] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   19.304260] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   19.304267] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   19.308318] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   19.308329] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   19.308336] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   19.308370] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   19.308380] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   19.308386] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   19.312231] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   19.312242] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   19.312251] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   19.312281] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   19.312291] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   19.312300] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   19.314724] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.322610] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.330639] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.336159] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   19.336193] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   19.336204] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   19.336211] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   19.338668] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.346604] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.354659] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.360162] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   19.360212] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   19.360223] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   19.360229] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   19.362686] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.370617] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.378616] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.388188] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   19.388225] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   19.388235] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   19.388242] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   19.390698] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.398620] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.406545] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.412185] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   19.413989] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   19.414003] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   19.414011] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   19.414048] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   19.414059] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   19.414071] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   19.414796] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   19.414809] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   19.414816] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   19.428342] [drm:intel_crt_detect], CRT not detected via hotplug
> [   19.432290] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   19.432301] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.432307] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   19.432313] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   19.432721] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.432728] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   19.432734] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   19.432742] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   19.432756] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   19.432766] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   19.432773] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   19.440143] [drm:intel_crt_detect], CRT not detected via hotplug
> [   19.444227] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   19.444233] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.444236] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   19.444239] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   19.444560] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.444564] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   19.444567] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   19.444571] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   19.444596] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   19.444601] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   19.444604] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   19.456740] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   19.456744] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   19.457661] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   19.457667] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   19.457670] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   19.469807] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   19.469811] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   19.470240] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   19.470245] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   19.470248] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   19.472648] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.482465] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.490459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.496077] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   19.496093] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   19.496098] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   19.496100] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   19.498498] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.506457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.514459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.520070] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   19.520091] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   19.520096] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   19.520099] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   19.524483] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   19.524487] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   19.524491] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   19.524497] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   19.524501] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   19.524504] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   19.528455] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   19.528460] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   19.528463] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   19.528475] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   19.528480] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   19.528483] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   19.530880] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.538461] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.546470] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.552035] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   19.552052] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   19.552057] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   19.552060] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   19.554457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.562459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.570472] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.576057] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   19.576078] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   19.576083] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   19.576085] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   19.578483] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.586451] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.594443] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.600057] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   19.600072] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   19.600077] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   19.600080] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   19.602478] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.610460] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.618472] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.624064] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   19.624457] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   19.624463] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   19.624466] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   19.624481] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   19.624486] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   19.624491] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   19.624772] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   19.624777] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   19.624780] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   19.632058] [drm:intel_crt_detect], CRT not detected via hotplug
> [   19.636241] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   19.636245] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.636248] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   19.636251] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   19.636560] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.636563] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   19.636566] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   19.636569] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   19.636575] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   19.636579] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   19.636581] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   19.644067] [drm:intel_crt_detect], CRT not detected via hotplug
> [   19.648186] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   19.648190] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.648193] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   19.648196] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   19.648505] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   19.648508] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   19.648511] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   19.648514] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   19.648533] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   19.648538] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   19.648541] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   19.660702] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   19.660706] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   19.661556] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   19.661562] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   19.661564] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   19.673723] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   19.673727] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   19.674150] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   19.674155] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   19.674158] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   19.676557] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.686457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.694459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.700078] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   19.700094] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   19.700099] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   19.700101] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   19.702499] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.710451] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.718450] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.724070] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   19.724093] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   19.724098] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   19.724101] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   19.728354] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   19.728358] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   19.728362] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   19.728376] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   19.728381] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   19.728383] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   19.732447] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   19.732451] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   19.732455] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   19.732467] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   19.732471] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   19.732474] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   19.734870] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.742451] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.750462] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.756064] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   19.756080] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   19.756085] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   19.756088] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   19.758485] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.766450] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.774461] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.780065] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   19.780086] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   19.780091] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   19.780093] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   19.782491] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.790450] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.798465] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.804077] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   19.804094] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   19.804098] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   19.804101] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   19.806499] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.814471] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.822471] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   19.828056] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   20.992151] NET: Registered protocol family 17
> [   22.191519] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   22.191918] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   22.224598] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   23.158032] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   23.260224] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   23.260453] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   23.604660] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   23.605062] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   23.636678] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   28.560654] wlan0: authenticate with 00:0b:6b:3c:8c:e4
> [   28.567208] wlan0: send auth to 00:0b:6b:3c:8c:e4 (try 1/3)
> [   28.572353] wlan0: authenticated
> [   28.576284] wlan0: associate with 00:0b:6b:3c:8c:e4 (try 1/3)
> [   28.579491] wlan0: RX AssocResp from 00:0b:6b:3c:8c:e4 (capab=0x431 status=0 aid=3)
> [   28.590345] wlan0: associated
> [   28.590709] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   28.592239] cfg80211: Calling CRDA for country: NA
> [   28.653970] wlan0: Limiting TX power to 27 (27 - 0) dBm as advertised by 00:0b:6b:3c:8c:e4
> [   32.665852] [drm:intel_crtc_cursor_set], cursor off
> [   50.122755] PM: Hibernation mode set to 'shutdown'
> [   50.124529] PM: Syncing filesystems ... done.
> [   50.142782] Freezing user space processes ... (elapsed 0.002 seconds) done.
> [   50.145233] PM: Marking nosave pages: [mem 0x0009e000-0x000fffff]
> [   50.145242] PM: Marking nosave pages: [mem 0x7c4a1000-0x7c4a6fff]
> [   50.145245] PM: Marking nosave pages: [mem 0x7c5b7000-0x7c60efff]
> [   50.145250] PM: Marking nosave pages: [mem 0x7c6c6000-0x7c9fefff]
> [   50.145274] PM: Basic memory bitmaps created
> [   50.145277] PM: Preallocating image memory... done (allocated 299546 pages)
> [   50.953248] PM: Allocated 1198184 kbytes in 0.80 seconds (1497.73 MB/s)
> [   50.953252] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> [   50.956285] Suspending console(s) (use no_console_suspend to debug)
> [   50.957285] wlan0: deauthenticating from 00:0b:6b:3c:8c:e4 by local choice (reason=3)
> [   50.971657] cfg80211: Calling CRDA to update world regulatory domain
> [   51.008309] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
> [   51.008589] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
> [   51.312263] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=2, cursor=2, SR: plane=0, cursor=0
> [   51.312274] [drm:intel_update_fbc], no output, disabling
> [   51.312881] PM: freeze of devices complete after 356.513 msecs
> [   51.315605] PM: late freeze of devices complete after 2.716 msecs
> [   51.319531] PM: noirq freeze of devices complete after 3.917 msecs
> [   51.319565] Disabling non-boot CPUs ...
> [   51.325788] kvm: disabling virtualization on CPU1
> [   51.428156] smpboot: CPU 1 is now offline
> [   51.439766] PM: Creating hibernation image:
> [   51.440065] PM: Need to copy 185697 pages
> [   51.440065] PM: Normal pages needed: 185697 + 1024, available pages: 323710
> [   51.440065] Enabling non-boot CPUs ...
> [   51.441384] x86: Booting SMP configuration:
> [   51.441386] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [   51.325869] Disabled fast string operations
> [   51.325869] kvm: enabling virtualization on CPU1
> [   51.455951] CPU1 is up
> [   51.493830] PM: noirq restore of devices complete after 33.991 msecs
> [   51.494901] PM: early restore of devices complete after 0.998 msecs
> [   51.735407] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   51.737777] usb usb1: root hub lost power or was reset
> [   51.737829] usb usb2: root hub lost power or was reset
> [   51.737877] usb usb3: root hub lost power or was reset
> [   51.737944] usb usb7: root hub lost power or was reset
> [   51.742305] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
> [   51.742701] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> [   51.743331] usb usb4: root hub lost power or was reset
> [   51.743378] usb usb5: root hub lost power or was reset
> [   51.743425] usb usb6: root hub lost power or was reset
> [   51.743472] usb usb8: root hub lost power or was reset
> [   51.747806] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
> [   51.755170] [drm:intel_opregion_setup], graphic opregion physical addr: 0x7c98b1f3
> [   51.755205] [drm:intel_opregion_setup], Public ACPI methods supported
> [   51.755206] [drm:intel_opregion_setup], SWSCI supported
> [   51.755251] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
> [   51.776112] [drm:swsci_setup], SWSCI BIOS requested (00010673) SBCB callbacks that are not supported (00080673)
> [   51.776116] [drm:swsci_setup], SWSCI GBDA callbacks 00000cf3, SBCB callbacks 00010673
> [   51.776119] [drm:intel_opregion_setup], ASLE supported
> [   51.776342] dpm_run_callback(): pnp_bus_resume+0x0/0xb0 returns -19
> [   51.776352] PM: Device 00:09 failed to restore: error -19
> [   51.776801] [drm:init_status_page], render ring hws offset: 0x00001000
> [   51.776806] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
> [   51.776881] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
> [   51.840138] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 00003004 tail 00000000 start 00003000
> [   51.840480] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
> [   51.840508] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
> [   51.840518] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
> [   51.840525] [drm:intel_modeset_readout_hw_state], [ENCODER:13:DAC-13] hw state readout: disabled, pipe A
> [   51.840532] [drm:intel_modeset_readout_hw_state], [ENCODER:14:TMDS-14] hw state readout: disabled, pipe A
> [   51.840539] [drm:intel_modeset_readout_hw_state], [ENCODER:18:TMDS-18] hw state readout: disabled, pipe A
> [   51.840545] [drm:intel_modeset_readout_hw_state], [ENCODER:20:TMDS-20] hw state readout: disabled, pipe A
> [   51.840551] [drm:intel_modeset_readout_hw_state], [ENCODER:22:TMDS-22] hw state readout: disabled, pipe A
> [   51.840557] [drm:intel_modeset_readout_hw_state], [ENCODER:24:TMDS-24] hw state readout: disabled, pipe A
> [   51.840565] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
> [   51.840571] [drm:intel_modeset_readout_hw_state], [CONNECTOR:12:VGA-1] hw state readout: disabled
> [   51.840577] [drm:intel_modeset_readout_hw_state], [CONNECTOR:15:HDMI-A-1] hw state readout: disabled
> [   51.840583] [drm:intel_modeset_readout_hw_state], [CONNECTOR:19:DP-1] hw state readout: disabled
> [   51.840589] [drm:intel_modeset_readout_hw_state], [CONNECTOR:21:HDMI-A-2] hw state readout: disabled
> [   51.840598] [drm:intel_modeset_readout_hw_state], [CONNECTOR:23:DP-2] hw state readout: disabled
> [   51.840601] [drm:intel_modeset_readout_hw_state], [CONNECTOR:25:DP-3] hw state readout: disabled
> [   51.840607] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
> [   51.840608] [drm:intel_dump_pipe_config], cpu_transcoder: A
> [   51.840610] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
> [   51.840612] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [   51.840614] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [   51.840616] [drm:intel_dump_pipe_config], requested mode:
> [   51.840619] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> [   51.840621] [drm:intel_dump_pipe_config], adjusted mode:
> [   51.840623] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> [   51.840626] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
> [   51.840627] [drm:intel_dump_pipe_config], port clock: 0
> [   51.840629] [drm:intel_dump_pipe_config], pipe src size: 0x0
> [   51.840631] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
> [   51.840633] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
> [   51.840634] [drm:intel_dump_pipe_config], ips: 0
> [   51.840635] [drm:intel_dump_pipe_config], double wide: 0
> [   51.840639] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
> [   51.840641] [drm:intel_dump_pipe_config], cpu_transcoder: B
> [   51.840642] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
> [   51.840644] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [   51.840647] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [   51.840648] [drm:intel_dump_pipe_config], requested mode:
> [   51.840651] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 800 0 0 0 600 0 0 0 0x0 0x0
> [   51.840652] [drm:intel_dump_pipe_config], adjusted mode:
> [   51.840655] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0xa
> [   51.840658] [drm:intel_dump_crtc_timings], crtc timings: 73810 1440 1464 1480 1600 900 903 909 926, type: 0x0 flags: 0xa
> [   51.840660] [drm:intel_dump_pipe_config], port clock: 73810
> [   51.840661] [drm:intel_dump_pipe_config], pipe src size: 800x600
> [   51.840663] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
> [   51.840665] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
> [   51.840666] [drm:intel_dump_pipe_config], ips: 0
> [   51.840668] [drm:intel_dump_pipe_config], double wide: 0
> [   51.840673] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 2
> [   51.840679] [drm:connected_sink_compute_bpp], [CONNECTOR:5:LVDS-1] checking for sink bpp constrains
> [   51.840683] [drm:intel_lvds_compute_config], forcing display bpp (was 24) to LVDS (18)
> [   51.840687] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 18, dithering: 1
> [   51.840689] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
> [   51.840690] [drm:intel_dump_pipe_config], cpu_transcoder: A
> [   51.840692] [drm:intel_dump_pipe_config], pipe bpp: 18, dithering: 1
> [   51.840694] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [   51.840696] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> [   51.840698] [drm:intel_dump_pipe_config], requested mode:
> [   51.840701] [drm:drm_mode_debug_printmodeline], Modeline 0:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   51.840702] [drm:intel_dump_pipe_config], adjusted mode:
> [   51.840706] [drm:drm_mode_debug_printmodeline], Modeline 0:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   51.840709] [drm:intel_dump_crtc_timings], crtc timings: 74080 1440 1464 1480 1600 900 903 909 926, type: 0x48 flags: 0xa
> [   51.840710] [drm:intel_dump_pipe_config], port clock: 74080
> [   51.840712] [drm:intel_dump_pipe_config], pipe src size: 1440x900
> [   51.840714] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
> [   51.840716] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
> [   51.840717] [drm:intel_dump_pipe_config], ips: 0
> [   51.840719] [drm:intel_dump_pipe_config], double wide: 0
> [   51.840730] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
> [   51.840809] [drm:asle_work], No request on ASLC interrupt 0x00000000
> [   52.064143] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   52.065231] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [   52.065239] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [   52.065244] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [   52.067182] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [   52.067189] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [   52.067194] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [   52.067496] ata1.00: configured for UDMA/133
> [   52.068202] ata2: SATA link down (SStatus 0 SControl 300)
> [   52.076183] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=2, cursor=2, B: plane=2, cursor=2, SR: plane=0, cursor=0
> [   52.076212] [drm:i9xx_get_refclk], using SSC reference clock of 100000 kHz
> [   52.076299] [drm:i9xx_set_pipeconf], disabling CxSR downclocking
> [   52.076358] [drm:i9xx_update_plane], Writing base 01938000 00000000 0 0 6144
> [   52.076366] [drm:intel_crtc_mode_set], [ENCODER:6:LVDS-6] set [MODE:0:1440x900]
> [   52.077083] [drm:g4x_check_srwm], SR watermark: display plane 58, cursor 6
> [   52.077086] [drm:g4x_update_wm], Setting FIFO watermarks - A: plane=26, cursor=6, B: plane=2, cursor=2, SR: plane=58, cursor=6
> [   52.080387] sd 0:0:0:0: [sda] Starting disk
> [   52.140162] [drm:intel_update_fbc], disabled per chip default
> [   52.192781] usb 2-1: reset full-speed USB device number 4 using uhci_hcd
> [   52.236111] [drm:intel_panel_enable_backlight], pipe A
> [   52.236120] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3211215
> [   52.236171] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 0
> [   52.236181] [drm:intel_connector_check_state], [CONNECTOR:5:LVDS-1]
> [   52.236196] [drm:check_encoder_state], [ENCODER:6:LVDS-6]
> [   52.236202] [drm:check_encoder_state], [ENCODER:13:DAC-13]
> [   52.236207] [drm:check_encoder_state], [ENCODER:14:TMDS-14]
> [   52.236212] [drm:check_encoder_state], [ENCODER:18:TMDS-18]
> [   52.236217] [drm:check_encoder_state], [ENCODER:20:TMDS-20]
> [   52.236222] [drm:check_encoder_state], [ENCODER:22:TMDS-22]
> [   52.236227] [drm:check_encoder_state], [ENCODER:24:TMDS-24]
> [   52.236233] [drm:check_crtc_state], [CRTC:3]
> [   52.236261] [drm:check_crtc_state], [CRTC:4]
> [   52.236279] [drm:intel_resume_hotplug], running encoder hotplug functions
> [   52.236286] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=0
> [   52.236305] [drm:asle_work], No request on ASLC interrupt 0x00000000
> [   52.244164] [drm:intel_crt_detect], CRT not detected via hotplug
> [   52.248188] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   52.248195] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   52.248198] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   52.248203] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   52.248635] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   52.248639] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   52.248642] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   52.248648] [drm:drm_helper_hpd_irq_event], [CONNECTOR:12:VGA-1] status updated from unknown to disconnected
> [   52.248653] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   52.268903] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   52.268910] [drm:drm_helper_hpd_irq_event], [CONNECTOR:15:HDMI-A-1] status updated from unknown to disconnected
> [   52.268916] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   52.271422] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.278462] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.286493] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.292115] [drm:drm_helper_hpd_irq_event], [CONNECTOR:19:DP-1] status updated from unknown to disconnected
> [   52.292119] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   52.296168] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   52.296175] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   52.296182] [drm:drm_helper_hpd_irq_event], [CONNECTOR:21:HDMI-A-2] status updated from unknown to disconnected
> [   52.296186] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   52.298641] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.306522] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.314607] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.320112] [drm:drm_helper_hpd_irq_event], [CONNECTOR:23:DP-2] status updated from unknown to disconnected
> [   52.320116] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   52.322537] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.330543] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.338558] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   52.344145] [drm:drm_helper_hpd_irq_event], [CONNECTOR:25:DP-3] status updated from unknown to disconnected
> [   52.344943] dpm_run_callback(): pci_pm_restore+0x0/0xf0 returns -5
> [   52.344958] PM: Device 0000:00:02.0 failed to restore async: error -5
> [   52.359461] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   52.359856] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   52.444338] usb 2-2: reset full-speed USB device number 5 using uhci_hcd
> [   52.604674] PM: restore of devices complete after 871.176 msecs
> [   53.085032] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
> [   53.448490] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [   53.468116] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input15
> [   53.476316] PM: Image restored successfully.
> [   53.476378] PM: Basic memory bitmaps freed
> [   53.476384] Restarting tasks ... done.
> [   53.484090] video LNXVIDEO:00: Restoring backlight state
> [   53.492514] [drm:asle_set_backlight], bclp = 0x800000ff
> [   53.492521] [drm:asle_set_backlight], updating opregion backlight 255/255
> [   53.492526] [drm:intel_panel_actually_set_backlight], set backlight PWM = 3211215
> [   53.492543] [drm:asle_set_pwm_freq], PWM freq is not supported
> [   53.492556] [drm:asle_work], No request on ASLC interrupt 0x00010000
> [   53.519751] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   53.522160] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.522342] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   53.530564] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.538449] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.544341] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   53.546744] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.552384] cfg80211: World regulatory domain updated:
> [   53.552389] cfg80211:  DFS Master region: unset
> [   53.552391] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   53.552394] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   53.552397] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   53.552399] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   53.552402] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   53.552404] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   53.554477] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.562481] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.568077] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [   53.568082] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   53.568101] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [   53.568106] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [   53.568118] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
> [   53.568179] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   53.570582] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.582536] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.590597] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.596403] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   53.596818] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   53.616766] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   53.617123] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   53.620161] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   53.620167] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   53.620292] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   53.620298] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   53.628087] [drm:intel_crt_detect], CRT not detected via hotplug
> [   53.632189] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   53.632200] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   53.632210] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   53.632217] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   53.632633] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   53.632639] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   53.632645] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   53.632656] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   53.632682] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
> [   53.632690] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [   53.632763] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [   53.632771] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   53.640159] [drm:intel_crt_detect], CRT not detected via hotplug
> [   53.644188] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   53.644200] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   53.644206] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   53.644213] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   53.644624] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   53.644631] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   53.644637] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   53.644645] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [   53.644680] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   53.644692] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   53.644699] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   53.664974] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   53.664983] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   53.665049] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
> [   53.665063] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [   53.665070] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [   53.680851] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [   53.680860] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [   53.680927] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   53.680935] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [   53.688180] [drm:intel_crt_detect], CRT not detected via hotplug
> [   53.692189] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [   53.692203] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   53.692210] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [   53.692217] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [   53.692659] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [   53.692667] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [   53.692673] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [   53.693125] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   53.693134] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   53.695556] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.702527] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.710487] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.716051] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   53.716060] [drm:drm_mode_getconnector], [CONNECTOR:19:?]
> [   53.716064] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [   53.716067] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [   53.718466] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.726493] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.734480] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.740068] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [   53.740090] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   53.740096] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   53.740099] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   53.744330] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   53.744335] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   53.744338] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   53.744344] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
> [   53.744348] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [   53.744351] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [   53.748283] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [   53.748287] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [   53.748290] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [   53.748302] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   53.748307] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   53.748309] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   53.750708] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.758466] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.766459] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.772071] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   53.772078] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
> [   53.772082] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [   53.772085] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [   53.774482] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.782475] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.790457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.796066] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [   53.796080] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   53.796084] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   53.796087] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   53.798485] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.806477] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.814457] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.820194] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   53.820202] [drm:drm_mode_getconnector], [CONNECTOR:25:?]
> [   53.820207] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [   53.820210] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [   53.822610] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.834550] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.842561] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [   53.848167] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [   54.428394] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   54.428794] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   54.458019] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   55.058772] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   55.160360] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   55.160765] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   59.041479] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   59.041880] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   59.074124] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   63.497156] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   63.497555] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   63.525237] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   64.074683] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   64.176250] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   64.176644] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   64.550243] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   64.550645] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   64.582086] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   66.684345] wlan0: authenticate with 00:1a:1e:a6:f9:c9
> [   66.687689] wlan0: send auth to 00:1a:1e:a6:f9:c9 (try 1/3)
> [   66.687832] wlan0: deauthenticating from 00:1a:1e:a6:f9:c9 by local choice (reason=3)
> [   66.698106] wlan0: authenticate with 00:1a:1e:a6:f9:c1
> [   66.701386] wlan0: send auth to 00:1a:1e:a6:f9:c1 (try 1/3)
> [   66.702393] wlan0: deauthenticating from 00:1a:1e:a6:f9:c1 by local choice (reason=3)
> [   66.703885] wlan0: authenticate with 00:1a:1e:a6:f7:61
> [   66.707023] wlan0: send auth to 00:1a:1e:a6:f7:61 (try 1/3)
> [   66.709258] wlan0: authenticated
> [   66.709310] iwlwifi 0000:03:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
> [   66.709314] iwlwifi 0000:03:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [   66.712100] wlan0: associate with 00:1a:1e:a6:f7:61 (try 1/3)
> [   66.723794] wlan0: RX AssocResp from 00:1a:1e:a6:f7:61 (capab=0x431 status=0 aid=4)
> [   66.727192] wlan0: associated
> [   66.727308] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   66.727493] cfg80211: Calling CRDA for country: CZ
> [   66.732797] cfg80211: Regulatory domain changed to country: CZ
> [   66.732801] cfg80211:  DFS Master region: unset
> [   66.732803] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   66.732807] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   66.732809] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
> [   66.732812] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> [   66.732814] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
> [   66.969780] wlan0: Limiting TX power to 20 (20 - 0) dBm as advertised by 00:1a:1e:a6:f7:61
> [  121.711266] [drm:intel_crtc_cursor_set], cursor off
> [  122.870600] [drm:intel_crtc_cursor_set], cursor off
> [  124.183193] [drm:intel_crtc_cursor_set], cursor off
> [  127.951165] [drm:intel_crtc_cursor_set], cursor off
> [  128.304448] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [  128.304465] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=1
> [  128.304471] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [  128.304616] [drm:i9xx_update_plane], Writing base 00046000 00000000 0 0 5760
> [  128.312225] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [  128.312235] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [  128.312240] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [  128.312251] [drm:drm_fb_helper_hotplug_event], 
> [  128.312255] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1]
> [  128.312259] [drm:intel_lvds_detect], [CONNECTOR:5:LVDS-1]
> [  128.312316] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:LVDS-1] probed modes :
> [  128.312324] [drm:drm_mode_debug_printmodeline], Modeline 8:"1440x900" 50 74080 1440 1464 1480 1600 900 903 909 926 0x48 0xa
> [  128.312328] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1]
> [  128.312332] [drm:intel_crt_detect], [CONNECTOR:12:VGA-1] force=1
> [  128.320210] [drm:intel_crt_detect], CRT not detected via hotplug
> [  128.324249] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
> [  128.324259] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [  128.324261] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
> [  128.324263] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
> [  128.324591] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
> [  128.324592] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
> [  128.324594] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
> [  128.324596] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:VGA-1] disconnected
> [  128.324599] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1]
> [  128.324601] [drm:intel_hdmi_detect], [CONNECTOR:15:HDMI-A-1]
> [  128.337418] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
> [  128.337421] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:HDMI-A-1] disconnected
> [  128.337423] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1]
> [  128.337426] [drm:intel_dp_detect], [CONNECTOR:19:DP-1]
> [  128.339883] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.346529] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.354475] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.360084] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:19:DP-1] disconnected
> [  128.360089] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2]
> [  128.360093] [drm:intel_hdmi_detect], [CONNECTOR:21:HDMI-A-2]
> [  128.364208] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
> [  128.364213] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
> [  128.364218] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:HDMI-A-2] disconnected
> [  128.364222] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2]
> [  128.364226] [drm:intel_dp_detect], [CONNECTOR:23:DP-2]
> [  128.366679] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.374528] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.382540] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.388112] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-2] disconnected
> [  128.388117] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3]
> [  128.388121] [drm:intel_dp_detect], [CONNECTOR:25:DP-3]
> [  128.390542] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.398538] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.406616] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x51450085
> [  128.412206] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:25:DP-3] disconnected
> [  128.412214] [drm:drm_setup_crtcs], 
> [  128.412223] [drm:drm_enable_connectors], connector 5 enabled? yes
> [  128.412226] [drm:drm_enable_connectors], connector 12 enabled? no
> [  128.412229] [drm:drm_enable_connectors], connector 15 enabled? no
> [  128.412232] [drm:drm_enable_connectors], connector 19 enabled? no
> [  128.412234] [drm:drm_enable_connectors], connector 21 enabled? no
> [  128.412237] [drm:drm_enable_connectors], connector 23 enabled? no
> [  128.412240] [drm:drm_enable_connectors], connector 25 enabled? no
> [  128.412244] [drm:drm_target_preferred], looking for cmdline mode on connector 5
> [  128.412247] [drm:drm_target_preferred], looking for preferred mode on connector 5
> [  128.412250] [drm:drm_target_preferred], found mode 1440x900
> [  128.412253] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
> [  128.412261] [drm:drm_setup_crtcs], desired mode 1440x900 set on crtc 3
> [  128.412303] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [  128.412313] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [  128.412318] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [  128.412324] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
> [  128.412332] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
> [  128.412336] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [  128.412349] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [  128.412356] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [  128.412360] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> [  128.412398] [drm:intel_crtc_set_config], [CRTC:3] [FB:26] #connectors=1 (x y) (0 0)
> [  128.412406] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
> [  128.412410] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:LVDS-1] to [CRTC:3]
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 

-- 
Jiri Kosina
SUSE Labs
