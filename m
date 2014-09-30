Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaI3K0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:26:13 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:44465 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaI3K0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:26:03 -0400
Date: Tue, 30 Sep 2014 13:25:58 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: kernel:[ 1155.839866] NMI watchdog: BUG: soft lockup - CPU#2
 stuck for 22s! [kworker/u8:5:71]
In-Reply-To: <alpine.LRH.2.11.1409281201160.9728@adalberg.ut.ee>
Message-ID: <alpine.LRH.2.11.1409301323210.18017@adalberg.ut.ee>
References: <alpine.LRH.2.11.1409281201160.9728@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While trying yesterdays 3.17 git snapshot on a i5-2400 + intel graphics 
> computer, it seems to go into soft lockup. Still pings but no ssh to it 
> any more, and active ssh session got the following kind of NMI watchdog 
> soft lockups during aptitude list update:
> 
> essage from syslogd@ilves at Sep 27 11:43:55 ...
>  kernel:[ 1015.866355] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u8:5:71]

Tested 3.17-rc5 on the same computer, still not good. It survived a day 
of desktop usage and then processes started to hang and NMI is detecting 
hard lockups (full dmesg and config below).

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc7 (mroos@ilves) (gcc version 4.9.1 (Debian 4.9.1-15) ) #127 SMP Mon Sep 29 09:45:34 EEST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.17.0-rc7 root=/dev/sda1 ro
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000bc970fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bc971000-0x00000000bc9bbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bc9bc000-0x00000000bc9c3fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bc9c4000-0x00000000bcab6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bcab7000-0x00000000bcab8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bcab9000-0x00000000bcbc4fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bcbc5000-0x00000000bcbc5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bcbc6000-0x00000000bcbd5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bcbd6000-0x00000000bcbf4fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bcbf5000-0x00000000bcc18fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bcc19000-0x00000000bcc5bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bcc5c000-0x00000000bce7bfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bce7c000-0x00000000bcffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bd800000-0x00000000bf9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI:                  /DQ67OW, BIOS SWQ6710H.86A.0066.2012.1105.1504 11/05/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x23e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0BD800000 mask FFF800000 uncachable
[    0.000000]   3 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 base 23E600000 mask FFFE00000 uncachable
[    0.000000]   6 base 23E800000 mask FFF800000 uncachable
[    0.000000]   7 base 23F000000 mask FFF000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 8GB, type WB
[    0.000000] reg 1, base: 8GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3032MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3040MB, range: 32MB, type UC
[    0.000000] reg 4, base: 3GB, range: 1GB, type UC
[    0.000000] reg 5, base: 9190MB, range: 2MB, type UC
[    0.000000] reg 6, base: 9192MB, range: 8MB, type UC
[    0.000000] reg 7, base: 9200MB, range: 16MB, type UC
[    0.000000] total RAM covered: 8126M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 9  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3032MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3040MB, range: 32MB, type UC
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] reg 5, base: 8GB, range: 1GB, type WB
[    0.000000] reg 6, base: 9190MB, range: 2MB, type UC
[    0.000000] reg 7, base: 9192MB, range: 8MB, type UC
[    0.000000] reg 8, base: 9200MB, range: 16MB, type UC
[    0.000000] e820: update [mem 0xbd800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbd000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd9a0-0x000fd9af] mapped at [ffff8800000fd9a0]
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x019e9000, 0x019e9fff] PGTABLE
[    0.000000] BRK [0x019ea000, 0x019eafff] PGTABLE
[    0.000000] BRK [0x019eb000, 0x019ebfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23e400000-0x23e5fffff]
[    0.000000]  [mem 0x23e400000-0x23e5fffff] page 2M
[    0.000000] BRK [0x019ec000, 0x019ecfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23c000000-0x23e3fffff]
[    0.000000]  [mem 0x23c000000-0x23e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
[    0.000000]  [mem 0x200000000-0x23bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40200000-0xbc970fff]
[    0.000000]  [mem 0x40200000-0xbc7fffff] page 2M
[    0.000000]  [mem 0xbc800000-0xbc970fff] page 4k
[    0.000000] BRK [0x019ed000, 0x019edfff] PGTABLE
[    0.000000] BRK [0x019ee000, 0x019eefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbcab7000-0xbcab8fff]
[    0.000000]  [mem 0xbcab7000-0xbcab8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbcbc5000-0xbcbc5fff]
[    0.000000]  [mem 0xbcbc5000-0xbcbc5fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbce7c000-0xbcffffff]
[    0.000000]  [mem 0xbce7c000-0xbcffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0450 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000BC9BC070 00005C (v01 INTEL  DQ67OW   01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000BC9C3B28 0000F4 (v04 INTEL  DQ67OW   01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000BC9BC158 0079CA (v02 INTEL  DQ67OW   00000016 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BCBDBF80 000040
[    0.000000] ACPI: APIC 0x00000000BC9C3C20 000072 (v03 INTEL  DQ67OW   01072009 AMI  00010013)
[    0.000000] ACPI: TCPA 0x00000000BC9C3C98 000032 (v02 INTEL  DQ67OW   00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 0x00000000BC9C3CD0 000102 (v01 INTEL  DQ67OW   00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BC9C3DD8 00003C (v01 INTEL  DQ67OW   01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BC9C3E18 000038 (v01 INTEL  DQ67OW   01072009 AMI. 00000004)
[    0.000000] ACPI: ASF! 0x00000000BC9C3E50 0000A0 (v32 INTEL  DQ67OW   00000001 TFSM 000F4240)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880235c00000-ffff88023dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xbc970fff]
[    0.000000]   node   0: [mem 0xbcab7000-0xbcab8fff]
[    0.000000]   node   0: [mem 0xbcbc5000-0xbcbc5fff]
[    0.000000]   node   0: [mem 0xbce7c000-0xbcffffff]
[    0.000000]   node   0: [mem 0x100000000-0x23e5fffff]
[    0.000000] On node 0 totalpages: 2075793
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 153 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11996 pages used for memmap
[    0.000000]   DMA32 zone: 767736 pages, LIFO batch:31
[    0.000000]   Normal zone: 20376 pages used for memmap
[    0.000000]   Normal zone: 1304064 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xbda00000-0xbf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc971000-0xbc9bbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc9bc000-0xbc9c3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbc9c4000-0xbcab6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcab9000-0xbcbc4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcbc6000-0xbcbd5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcbd6000-0xbcbf4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcbf5000-0xbcc18fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcc19000-0xbcc5bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcc5c000-0xbce7bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd000000-0xbd7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd800000-0xbf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfa00000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed3ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed40000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xbfa00000-0xfed1bfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88023e200000 s76544 r8192 d21760 u524288
[    0.000000] pcpu-alloc: s76544 r8192 d21760 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2043204
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.17.0-rc7 root=/dev/sda1 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 8082376K/8303172K available (4532K kernel code, 451K rwdata, 1432K rodata, 788K init, 684K bss, 220796K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NO_HZ: Full dynticks CPUs: 1-7.
[    0.000000] NR_IRQS:4352 nr_irqs:456 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches HPET. 1 loops
[    0.000000] tsc: Detected 3093.859 MHz processor
[    0.000040] Calibrating delay loop (skipped), value calculated using timer frequency.. 6187.71 BogoMIPS (lpj=12375436)
[    0.000101] pid_max: default: 32768 minimum: 301
[    0.000136] ACPI: Core revision 20140724
[    0.004848] ACPI: All ACPI Tables successfully acquired
[    0.005222] Security Framework initialized
[    0.005261] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.005295] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.005574] Initializing cgroup subsys memory
[    0.005606] Initializing cgroup subsys devices
[    0.005635] Initializing cgroup subsys freezer
[    0.005663] Initializing cgroup subsys net_cls
[    0.005691] Initializing cgroup subsys blkio
[    0.005719] Initializing cgroup subsys perf_event
[    0.005748] Initializing cgroup subsys hugetlb
[    0.005799] CPU: Physical Processor ID: 0
[    0.005826] CPU: Processor Core ID: 0
[    0.005855] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.005855] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.005914] mce: CPU supports 9 MCE banks
[    0.005956] CPU0: Thermal monitoring enabled (TM1)
[    0.005994] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.005994] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.006199] Freeing SMP alternatives memory: 20K (ffffffff81937000 - ffffffff8193c000)
[    0.007242] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.046959] smpboot: CPU0: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz (fam: 06, model: 2a, stepping: 07)
[    0.047033] TSC deadline timer enabled
[    0.047052] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.047157] ... version:                3
[    0.047184] ... bit width:              48
[    0.047210] ... generic registers:      8
[    0.047237] ... value mask:             0000ffffffffffff
[    0.047267] ... max period:             0000ffffffffffff
[    0.047296] ... fixed-purpose events:   3
[    0.047322] ... event mask:             00000007000000ff
[    0.048237] x86: Booting SMP configuration:
[    0.048265] .... node  #0, CPUs:      #1
[    0.061420] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.061582]  #2 #3
[    0.088016] x86: Booted up 1 node, 4 CPUs
[    0.088065] smpboot: Total of 4 processors activated (24750.87 BogoMIPS)
[    0.092224] devtmpfs: initialized
[    0.092461] PM: Registering ACPI NVS region [mem 0xbc971000-0xbc9bbfff] (307200 bytes)
[    0.092515] PM: Registering ACPI NVS region [mem 0xbcbd6000-0xbcbf4fff] (126976 bytes)
[    0.092565] PM: Registering ACPI NVS region [mem 0xbcc19000-0xbcc5bfff] (274432 bytes)
[    0.092763] pinctrl core: initialized pinctrl subsystem
[    0.092915] NET: Registered protocol family 16
[    0.093050] cpuidle: using governor ladder
[    0.093078] cpuidle: using governor menu
[    0.093140] ACPI: bus type PCI registered
[    0.093249] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.093301] PCI: not using MMCONFIG
[    0.093327] PCI: Using configuration type 1 for base access
[    0.100353] ACPI: Added _OSI(Module Device)
[    0.100382] ACPI: Added _OSI(Processor Device)
[    0.100409] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.100438] ACPI: Added _OSI(Processor Aggregator Device)
[    0.103114] ACPI: Executed 1 blocks of module-level executable AML code
[    0.106083] ACPI: Dynamic OEM Table Load:
[    0.106126] ACPI: SSDT 0xFFFF880232F13400 00038C (v01 AMI    IST      00000001 MSFT 03000001)
[    0.106603] ACPI: Dynamic OEM Table Load:
[    0.106642] ACPI: SSDT 0xFFFF880232EE2E40 000084 (v01 AMI    CST      00000001 MSFT 03000001)
[    0.107601] ACPI: Interpreter enabled
[    0.107632] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.107695] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.107768] ACPI: (supports S0 S3 S4 S5)
[    0.107796] ACPI: Using IOAPIC for interrupt routing
[    0.107847] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.107966] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.108109] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.108445] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.114829] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.114866] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.115134] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.115415] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.115504] PCI host bridge to bus 0000:00
[    0.115533] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.115564] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.115596] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.115628] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.115659] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.115691] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.115724] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.115757] pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xffffffff]
[    0.115799] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.115911] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.115956] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.116002] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.116107] pci 0000:00:02.0: [8086:0102] type 00 class 0x030000
[    0.116121] pci 0000:00:02.0: reg 0x10: [mem 0xfe000000-0xfe3fffff 64bit]
[    0.116130] pci 0000:00:02.0: reg 0x18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.116136] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.116330] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.116395] pci 0000:00:16.0: reg 0x10: [mem 0xfe42a000-0xfe42a00f 64bit]
[    0.116620] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.116748] pci 0000:00:16.2: [8086:1c3c] type 00 class 0x010185
[    0.116799] pci 0000:00:16.2: reg 0x10: [io  0xf130-0xf137]
[    0.116824] pci 0000:00:16.2: reg 0x14: [io  0xf120-0xf123]
[    0.116849] pci 0000:00:16.2: reg 0x18: [io  0xf110-0xf117]
[    0.116871] pci 0000:00:16.2: reg 0x1c: [io  0xf100-0xf103]
[    0.116897] pci 0000:00:16.2: reg 0x20: [io  0xf0f0-0xf0ff]
[    0.117156] pci 0000:00:16.3: [8086:1c3d] type 00 class 0x070002
[    0.117204] pci 0000:00:16.3: reg 0x10: [io  0xf0e0-0xf0e7]
[    0.117229] pci 0000:00:16.3: reg 0x14: [mem 0xfe429000-0xfe429fff]
[    0.117587] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.117642] pci 0000:00:19.0: reg 0x10: [mem 0xfe400000-0xfe41ffff]
[    0.117666] pci 0000:00:19.0: reg 0x14: [mem 0xfe428000-0xfe428fff]
[    0.117692] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.117906] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.117976] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.118083] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.118143] pci 0000:00:1a.0: reg 0x10: [mem 0xfe427000-0xfe4273ff]
[    0.118412] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.118483] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.118591] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.118642] pci 0000:00:1b.0: reg 0x10: [mem 0xfe420000-0xfe423fff 64bit]
[    0.118881] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.119030] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.119091] pci 0000:00:1d.0: reg 0x10: [mem 0xfe426000-0xfe4263ff]
[    0.119347] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.119412] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.119496] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.119716] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.119812] pci 0000:00:1f.0: [8086:1c4e] type 00 class 0x060100
[    0.120215] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.120279] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.120305] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.120332] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.120355] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.120381] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.120407] pci 0000:00:1f.2: reg 0x24: [mem 0xfe425000-0xfe4257ff]
[    0.120576] pci 0000:00:1f.2: PME# supported from D3hot
[    0.120699] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.120745] pci 0000:00:1f.3: reg 0x10: [mem 0xfe424000-0xfe4240ff 64bit]
[    0.120818] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.121008] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.121224] pci 0000:00:1e.0: PCI bridge to [bus 02] (subtractive decode)
[    0.121285] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.121287] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.121289] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.121292] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.121294] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.121296] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.121299] pci 0000:00:1e.0:   bridge window [mem 0xbfa00000-0xffffffff] (subtractive decode)
[    0.121323] pci_bus 0000:00: on NUMA node 0
[    0.122105] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.122257] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.122410] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.122560] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.122711] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.122865] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.123035] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.123190] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.123370] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.123498] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.123529] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.123578] vgaarb: loaded
[    0.123602] vgaarb: bridge control possible 0000:00:02.0
[    0.123695] SCSI subsystem initialized
[    0.123767] libata version 3.00 loaded.
[    0.123817] PCI: Using ACPI for IRQ routing
[    0.129979] PCI: pci_cache_line_size set to 64 bytes
[    0.130072] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
[    0.130075] e820: reserve RAM buffer [mem 0xbc971000-0xbfffffff]
[    0.130078] e820: reserve RAM buffer [mem 0xbcab9000-0xbfffffff]
[    0.130081] e820: reserve RAM buffer [mem 0xbcbc6000-0xbfffffff]
[    0.130084] e820: reserve RAM buffer [mem 0xbd000000-0xbfffffff]
[    0.130086] e820: reserve RAM buffer [mem 0x23e600000-0x23fffffff]
[    0.130246] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.130325] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.132392] Switched to clocksource hpet
[    0.132537] pnp: PnP ACPI init
[    0.132682] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.132717] system 00:00: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.132750] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.132783] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.132816] system 00:00: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.132850] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.133073] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.133106] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.133462] pnp 00:02: [dma 2]
[    0.133516] pnp 00:02: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.133945] pnp 00:03: [dma 3]
[    0.134110] pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.134150] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.134212] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.134245] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.134469] pnp 00:06: [dma 0 disabled]
[    0.134525] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.134671] pnp 00:07: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.134873] system 00:08: [io  0x0400-0x0453] could not be reserved
[    0.134906] system 00:08: [io  0x0458-0x047f] has been reserved
[    0.134938] system 00:08: [io  0x1180-0x119f] has been reserved
[    0.134970] system 00:08: [io  0x0500-0x057f] has been reserved
[    0.135002] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.135035] system 00:08: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.135069] system 00:08: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.135102] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.135136] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.135205] system 00:09: [io  0x0454-0x0457] has been reserved
[    0.135237] system 00:09: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.135494] pnp: PnP ACPI: found 10 devices
[    0.142790] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.142826] pci 0000:00:1e.0: PCI bridge to [bus 02]
[    0.142888] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.142891] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.142893] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.142896] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.142898] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.142900] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.142903] pci_bus 0000:00: resource 10 [mem 0xbfa00000-0xffffffff]
[    0.142906] pci_bus 0000:02: resource 4 [io  0x0000-0x03af]
[    0.142908] pci_bus 0000:02: resource 5 [io  0x03e0-0x0cf7]
[    0.142911] pci_bus 0000:02: resource 6 [io  0x03b0-0x03df]
[    0.142913] pci_bus 0000:02: resource 7 [io  0x0d00-0xffff]
[    0.142915] pci_bus 0000:02: resource 8 [mem 0x000a0000-0x000bffff]
[    0.142918] pci_bus 0000:02: resource 9 [mem 0x000c0000-0x000dffff]
[    0.142920] pci_bus 0000:02: resource 10 [mem 0xbfa00000-0xffffffff]
[    0.142948] NET: Registered protocol family 2
[    0.143177] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.143363] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.143564] TCP: Hash tables configured (established 65536 bind 65536)
[    0.143618] TCP: reno registered
[    0.143646] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.143709] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.143827] NET: Registered protocol family 1
[    0.143882] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; disabling
[    0.143946] pci 0000:00:02.0: Video device with shadowed ROM
[    0.496427] PCI: CLS 64 bytes, default 64
[    0.496449] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.496483] software IO TLB [mem 0xb8971000-0xbc971000] (64MB) mapped at [ffff8800b8971000-ffff8800bc970fff]
[    0.496807] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.497212] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.497266] audit: initializing netlink subsys (disabled)
[    0.497307] audit: type=2000 audit(1411976023.500:1): initialized
[    0.497658] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.499986] msgmni has been set to 15785
[    0.500076] Key type big_key registered
[    0.500427] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.500541] io scheduler noop registered
[    0.500578] io scheduler deadline registered (default)
[    0.500760] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.500863] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.500898] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.500965] intel_idle: MWAIT substates: 0x1120
[    0.500966] intel_idle: v0.4 model 0x2A
[    0.500968] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.501214] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.522337] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.544010] 0000:00:16.3: ttyS1 at I/O 0xf0e0 (irq = 17, base_baud = 115200) is a 16550A
[    0.544370] Linux agpgart interface v0.103
[    0.544599] mei_me 0000:00:16.0: irq 25 for MSI/MSI-X
[    0.548578] ahci 0000:00:1f.2: version 3.0
[    0.548710] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    0.564380] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    0.564431] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems sxs apst 
[    0.605238] scsi host0: ahci
[    0.605651] scsi host1: ahci
[    0.605995] scsi host2: ahci
[    0.606365] scsi host3: ahci
[    0.606685] scsi host4: ahci
[    0.606985] scsi host5: ahci
[    0.607086] ata1: SATA max UDMA/133 abar m2048@0xfe425000 port 0xfe425100 irq 26
[    0.607137] ata2: SATA max UDMA/133 abar m2048@0xfe425000 port 0xfe425180 irq 26
[    0.607188] ata3: SATA max UDMA/133 abar m2048@0xfe425000 port 0xfe425200 irq 26
[    0.607239] ata4: SATA max UDMA/133 abar m2048@0xfe425000 port 0xfe425280 irq 26
[    0.607290] ata5: SATA max UDMA/133 abar m2048@0xfe425000 port 0xfe425300 irq 26
[    0.607340] ata6: SATA max UDMA/133 abar m2048@0xfe425000 port 0xfe425380 irq 26
[    0.607450] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.610918] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.610955] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.611241] mousedev: PS/2 mouse device common for all mice
[    0.611348] rtc_cmos 00:04: RTC can wake from S4
[    0.611677] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.611772] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.611831] Intel P-state driver initializing.
[    0.612070] TCP: cubic registered
[    0.612223] NET: Registered protocol family 10
[    0.612606] mip6: Mobile IPv6
[    0.612636] NET: Registered protocol family 17
[    0.612677] Key type dns_resolver registered
[    0.613672] registered taskstats version 1
[    0.614409] rtc_cmos 00:04: setting system clock to 2014-09-29 07:33:43 UTC (1411976023)
[    0.614559] PM: Hibernation image not present or could not be loaded.
[    0.924299] ata5: SATA link down (SStatus 0 SControl 300)
[    0.924381] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.924448] ata6: SATA link down (SStatus 0 SControl 300)
[    0.924519] ata4: SATA link down (SStatus 0 SControl 300)
[    0.926682] ata3.00: ATAPI: TSSTcorp CDDVDW SH-222BB, SB00, max UDMA/100
[    0.931034] ata3.00: configured for UDMA/100
[    0.932311] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.932369] ata2: SATA link down (SStatus 0 SControl 300)
[    0.933726] ata1.00: ATA-8: ST500DM002-1BD142, KC45, max UDMA/133
[    0.933760] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.935457] ata1.00: configured for UDMA/133
[    0.935697] scsi 0:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 KC45 PQ: 0 ANSI: 5
[    0.936125] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.936273] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.936549] sd 0:0:0:0: [sda] Write Protect is off
[    0.936581] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.936677] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.941248] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-222BB  SB00 PQ: 0 ANSI: 5
[    0.952550]  sda: sda1 sda2 sda3
[    0.953523] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.966540] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
[    0.974858] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
[    1.004380] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.004435] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.038764] devtmpfs: mounted
[    1.039481] Freeing unused kernel memory: 788K (ffffffff81872000 - ffffffff81937000)
[    1.039528] Write protecting the kernel read-only data: 8192k
[    1.043928] Freeing unused kernel memory: 1600K (ffff880001470000 - ffff880001600000)
[    1.045646] Freeing unused kernel memory: 616K (ffff880001766000 - ffff880001800000)
[    1.496170] tsc: Refined TSC clocksource calibration: 3092.973 MHz
[    1.690918] random: systemd urandom read with 49 bits of entropy available
[    1.700348] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[    1.700604] systemd[1]: Detected architecture 'x86-64'.
[    1.978591] systemd[1]: Inserted module 'autofs4'
[    1.991401] systemd[1]: Set hostname to <ilves>.
[    2.496209] Switched to clocksource tsc
[    3.228677] random: nonblocking pool is initialized
[    3.885350] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[    3.885985] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    3.886113] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    3.886171] systemd[1]: Starting Remote File Systems (Pre).
[    3.886313] systemd[1]: Reached target Remote File Systems (Pre).
[    3.886371] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    3.886608] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    3.886677] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    3.886767] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    3.886824] systemd[1]: Starting Paths.
[    3.886937] systemd[1]: Reached target Paths.
[    3.886977] systemd[1]: Expecting device dev-sda2.device...
[    3.887081] systemd[1]: Expecting device dev-sda3.device...
[    3.887183] systemd[1]: Starting Root Slice.
[    3.896731] systemd[1]: Created slice Root Slice.
[    3.896771] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    3.896931] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    3.896973] systemd[1]: Starting Delayed Shutdown Socket.
[    3.897107] systemd[1]: Listening on Delayed Shutdown Socket.
[    3.897146] systemd[1]: Starting Journal Socket (/dev/log).
[    3.897287] systemd[1]: Listening on Journal Socket (/dev/log).
[    3.897327] systemd[1]: Starting Syslog Socket.
[    3.897454] systemd[1]: Listening on Syslog Socket.
[    3.897490] systemd[1]: Starting LVM2 metadata daemon socket.
[    3.897627] systemd[1]: Listening on LVM2 metadata daemon socket.
[    3.897666] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    3.944095] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    3.944148] systemd[1]: Starting User and Session Slice.
[    3.944489] systemd[1]: Created slice User and Session Slice.
[    3.944537] systemd[1]: Starting udev Control Socket.
[    3.944693] systemd[1]: Listening on udev Control Socket.
[    3.944737] systemd[1]: Starting udev Kernel Socket.
[    3.944867] systemd[1]: Listening on udev Kernel Socket.
[    3.944910] systemd[1]: Starting Journal Socket.
[    3.945059] systemd[1]: Listening on Journal Socket.
[    3.945113] systemd[1]: Starting System Slice.
[    3.945426] systemd[1]: Created slice System Slice.
[    3.945476] systemd[1]: Starting File System Check on Root Device...
[    3.946014] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    3.946391] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    3.946447] systemd[1]: Starting udev Coldplug all Devices...
[    3.947067] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    3.947703] systemd[1]: Mounting Huge Pages File System...
[    4.100107] systemd[1]: Started Set Up Additional Binary Formats.
[    4.100171] systemd[1]: Mounting POSIX Message Queue File System...
[    4.100796] systemd[1]: Mounting Debug File System...
[    4.101347] systemd[1]: Starting system-getty.slice.
[    4.101689] systemd[1]: Created slice system-getty.slice.
[    4.101750] systemd[1]: Starting Nameserver information manager...
[    4.204087] systemd[1]: Starting Load Kernel Modules...
[    4.204654] systemd[1]: Starting Journal Service...
[    4.205321] systemd[1]: Started Journal Service.
[    4.448395] fuse init (API version 7.23)
[    4.658968] loop: module loaded
[    4.941746] w83627ehf: Found NCT6775F chip at 0x290
[    5.072654] systemd-udevd[138]: starting version 215
[    6.601689] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    6.616058] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    6.616063] ACPI: Power Button [PWRB]
[    6.616109] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    6.616112] ACPI: Power Button [PWRF]
[    6.637065] Floppy drive(s): fd0 is 1.44M
[    6.652903] FDC 0 is a post-1991 82077
[    6.691538] tpm_tis 00:07: 1.2 TPM (device-id 0xFE, rev-id 70)
[    6.697656] [drm] Initialized drm 1.1.0 20060810
[    6.706033] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.706072] scsi 2:0:0:0: Attached scsi generic sg1 type 5
[    6.729611] pps_core: LinuxPPS API ver. 1 registered
[    6.729614] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    6.749321] sr 2:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.749324] cdrom: Uniform CD-ROM driver Revision: 3.20
[    6.749420] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    6.765632] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    6.780207] PTP clock support registered
[    6.787084] parport_pc 00:03: reported by Plug and Play ACPI
[    6.787352] parport0: PC-style at 0x378 (0x778), irq 5, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[    6.821719] ACPI: bus type USB registered
[    6.821740] usbcore: registered new interface driver usbfs
[    6.821749] usbcore: registered new interface driver hub
[    6.821776] usbcore: registered new device driver usb
[    6.822172] iTCO_vendor_support: vendor-support=0
[    6.823624] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.831941] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    6.831973] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    6.832045] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.834547] ehci-pci: EHCI PCI platform driver
[    6.834661] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    6.834666] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    6.834694] ehci-pci 0000:00:1a.0: debug port 2
[    6.838610] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    6.838637] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfe427000
[    6.846926] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.846963] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.846965] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.846966] usb usb1: Product: EHCI Host Controller
[    6.846967] usb usb1: Manufacturer: Linux 3.17.0-rc7 ehci_hcd
[    6.846968] usb usb1: SerialNumber: 0000:00:1a.0
[    6.847051] hub 1-0:1.0: USB hub found
[    6.847056] hub 1-0:1.0: 3 ports detected
[    6.847229] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    6.847233] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    6.847259] ehci-pci 0000:00:1d.0: debug port 2
[    6.851181] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    6.851199] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe426000
[    6.862925] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.862972] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.862982] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.862983] usb usb2: Product: EHCI Host Controller
[    6.862985] usb usb2: Manufacturer: Linux 3.17.0-rc7 ehci_hcd
[    6.862986] usb usb2: SerialNumber: 0000:00:1d.0
[    6.863061] hub 2-0:1.0: USB hub found
[    6.863066] hub 2-0:1.0: 3 ports detected
[    6.879672] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    6.879673] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    6.879846] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    6.879882] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[    7.009197] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x28
[    7.028421] Error: Driver 'pcspkr' is already registered, aborting...
[    7.081448] e1000e 0000:00:19.0 eth0: registered PHC clock
[    7.081453] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:22:4d:6b:eb:3c
[    7.081455] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    7.081504] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    7.081868] snd_hda_intel 0000:00:1b.0: irq 28 for MSI/MSI-X
[    7.098718] [drm] Memory usable by graphics device = 2048M
[    7.098721] [drm] Replacing VGA console driver
[    7.099186] Console: switching to colour dummy device 80x25
[    7.107382] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x28
[    7.108090] microcode: CPU0 updated to revision 0x29, date = 2013-06-12
[    7.108099] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x28
[    7.108122] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x28
[    7.108520] microcode: CPU1 updated to revision 0x29, date = 2013-06-12
[    7.108559] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x28
[    7.108586] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x28
[    7.108982] microcode: CPU2 updated to revision 0x29, date = 2013-06-12
[    7.108990] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x28
[    7.109006] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x28
[    7.109408] microcode: CPU3 updated to revision 0x29, date = 2013-06-12
[    7.109507] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.146894] sound hdaudioC0D2: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    7.146901] sound hdaudioC0D2:    speaker_outs=1 (0x17/0x0/0x0/0x0/0x0)
[    7.146905] sound hdaudioC0D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    7.146909] sound hdaudioC0D2:    mono: mono_out=0x0
[    7.146912] sound hdaudioC0D2:    dig-out=0x1e/0x0
[    7.146914] sound hdaudioC0D2:    inputs:
[    7.146918] sound hdaudioC0D2:      Front Mic=0x19
[    7.146921] sound hdaudioC0D2:      Rear Mic=0x18
[    7.146923] sound hdaudioC0D2:      Line=0x1a
[    7.161118] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    7.161232] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    7.161341] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    7.162853] [drm] GMBUS [i915 gmbus ssc] timed out, falling back to bit banging on pin 1
[    7.162894] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    7.295245] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    7.295250] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.295545] hub 1-1:1.0: USB hub found
[    7.295742] hub 1-1:1.0: 6 ports detected
[    7.378802] [drm] GMBUS [i915 gmbus panel] timed out, falling back to bit banging on pin 3
[    7.406831] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    7.503451] AVX version of gcm_enc/dec engaged.
[    7.539188] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    7.539193] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.539463] hub 2-1:1.0: USB hub found
[    7.539524] hub 2-1:1.0: 8 ports detected
[    7.562774] [drm] GMBUS [i915 gmbus dpc] timed out, falling back to bit banging on pin 4
[    7.610930] usb 1-1.3: new high-speed USB device number 3 using ehci-pci
[    7.703336] usb 1-1.3: New USB device found, idVendor=0424, idProduct=2514
[    7.703341] usb 1-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    7.703717] hub 1-1.3:1.0: USB hub found
[    7.703891] hub 1-1.3:1.0: 4 ports detected
[    7.754731] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    7.810875] usb 2-1.3: new full-speed USB device number 3 using ehci-pci
[    7.905353] usb 2-1.3: New USB device found, idVendor=058f, idProduct=9520
[    7.905358] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.905360] usb 2-1.3: Product: EMV Smartcard Reader
[    7.905362] usb 2-1.3: Manufacturer: Generic
[    7.954776] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[    7.954789] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    7.954790] [drm] Driver supports precise vblank timestamp query.
[    7.954874] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    7.990800] usb 1-1.3.1: new low-speed USB device number 4 using ehci-pci
[    8.063955] fbcon: inteldrmfb (fb0) is primary device
[    8.086812] usb 1-1.3.1: New USB device found, idVendor=046d, idProduct=c05b
[    8.086815] usb 1-1.3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.086816] usb 1-1.3.1: Product: USB Optical Mouse
[    8.086818] usb 1-1.3.1: Manufacturer: Logitech
[    8.099107] Console: switching to colour frame buffer device 240x75
[    8.104248] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.104249] i915 0000:00:02.0: registered panic notifier
[    8.118741] i915: No ACPI video bus found
[    8.118781] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
[    8.158796] usb 1-1.3.2: new low-speed USB device number 5 using ehci-pci
[    8.160293] Adding 8300540k swap on /dev/sda2.  Priority:-1 extents:1 across:8300540k 
[    8.265740] hidraw: raw HID events driver (C) Jiri Kosina
[    8.285956] usb 1-1.3.2: New USB device found, idVendor=03f0, idProduct=034a
[    8.285961] usb 1-1.3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.285964] usb 1-1.3.2: Product: HP Elite USB Keyboard
[    8.285966] usb 1-1.3.2: Manufacturer: Chicony
[    8.306025] usbcore: registered new interface driver usbhid
[    8.306028] usbhid: USB HID core driver
[    8.348110] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3.1/1-1.3.1:1.0/0003:046D:C05B.0001/input/input9
[    8.348272] hid-generic 0003:046D:C05B.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.0-1.3.1/input0
[    8.348455] input: Chicony HP Elite USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3.2/1-1.3.2:1.0/0003:03F0:034A.0002/input/input10
[    8.348643] hid-generic 0003:03F0:034A.0002: input,hidraw1: USB HID v1.10 Keyboard [Chicony HP Elite USB Keyboard] on usb-0000:00:1a.0-1.3.2/input0
[    8.351858] input: Chicony HP Elite USB Keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3.2/1-1.3.2:1.1/0003:03F0:034A.0003/input/input11
[    8.352037] hid-generic 0003:03F0:034A.0003: input,hidraw2: USB HID v1.10 Device [Chicony HP Elite USB Keyboard] on usb-0000:00:1a.0-1.3.2/input1
[    9.188606] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    9.648031] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[   11.859710] WARNING! power/level is deprecated; use power/control instead
[   12.219983] systemd-journald[107]: Received request to flush runtime journal from PID 1
[   12.661063] tun: Universal TUN/TAP device driver, 1.6
[   12.661067] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   12.675292] IPv6: ADDRCONF(NETDEV_UP): tap0: link is not ready
[   12.707308] IPv6: ADDRCONF(NETDEV_UP): tap1: link is not ready
[   12.743301] IPv6: ADDRCONF(NETDEV_UP): tap2: link is not ready
[   12.775329] IPv6: ADDRCONF(NETDEV_UP): tap3: link is not ready
[   12.841370] Bridge firewalling registered
[   12.854585] device eth0 entered promiscuous mode
[   13.004210] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[   13.105636] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[   13.105722] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.115875] device tap0 entered promiscuous mode
[   13.123880] device tap1 entered promiscuous mode
[   13.135806] device tap2 entered promiscuous mode
[   13.151782] device tap3 entered promiscuous mode
[   13.168284] br0: port 5(tap3) entered forwarding state
[   13.168292] br0: port 5(tap3) entered forwarding state
[   13.168296] br0: port 4(tap2) entered forwarding state
[   13.168299] br0: port 4(tap2) entered forwarding state
[   13.168303] br0: port 3(tap1) entered forwarding state
[   13.168306] br0: port 3(tap1) entered forwarding state
[   13.661579] br0: port 3(tap1) entered disabled state
[   13.661698] br0: port 4(tap2) entered disabled state
[   13.661819] br0: port 5(tap3) entered disabled state
[   14.626466] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   14.626473] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[   14.626518] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.626539] br0: port 1(eth0) entered forwarding state
[   14.626544] br0: port 1(eth0) entered forwarding state
[   19.019959] RPC: Registered named UNIX socket transport module.
[   19.019963] RPC: Registered udp transport module.
[   19.019964] RPC: Registered tcp transport module.
[   19.019965] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   19.083690] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[49809.901499] perf interrupt took too long (2506 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[49819.509126] UDP: bad checksum. From 201.93.124.5:15874 to 192.168.74.161:65021 ulen 34
[94971.597381] ------------[ cut here ]------------
[94971.597390] WARNING: CPU: 3 PID: 16509 at kernel/watchdog.c:267 watchdog_overflow_callback+0x90/0xc0()
[94971.597391] Watchdog detected hard LOCKUP on cpu 3
[94971.597392] Modules linked in: nfsv2 cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative snd_seq_dummy snd_hrtimer snd_seq_midi snd_seq_oss snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd sunrpc bridge stp llc tun joydev hid_generic usbhid hid x86_pkg_temp_thermal kvm_intel kvm crc32c_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd snd_hda_codec_realtek snd_hda_codec_generic i915 snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss evdev snd_pcm microcode snd_timer snd soundcore e1000e ehci_pci iTCO_wdt ehci_hcd iTCO_vendor_support usbcore nuvoton_cir ptp pcspkr usb_common sr_mod rc_core pps_core psmouse cdrom parport_pc i2c_algo_bit video drm_kms_helper sg drm tpm_tis tpm processor lpc_ich parport mfd_core floppy thermal_sys button i2c_i801 msr w83627ehf hwmon_vid coretemp hwmon eeprom i2c_core loop fuse autofs4
[94971.597442] CPU: 3 PID: 16509 Comm: chromium Not tainted 3.17.0-rc7 #127
[94971.597443] Hardware name:                  /DQ67OW, BIOS SWQ6710H.86A.0066.2012.1105.1504 11/05/2012
[94971.597445]  0000000000000009 ffffffff814637a3 ffff88023e386cd0 ffffffff81044afd
[94971.597447]  ffff880232e70000 ffff88023e386d20 ffff88023e386db8 ffff88023e386ef8
[94971.597449]  0000000000000000 ffffffff81044b67 ffffffff816e7f98 0000000000000020
[94971.597451] Call Trace:
[94971.597452]  <NMI>  [<ffffffff814637a3>] ? dump_stack+0x41/0x51
[94971.597459]  [<ffffffff81044afd>] ? warn_slowpath_common+0x6d/0x90
[94971.597461]  [<ffffffff81044b67>] ? warn_slowpath_fmt+0x47/0x50
[94971.597464]  [<ffffffff810c6290>] ? watchdog_overflow_callback+0x90/0xc0
[94971.597467]  [<ffffffff810d1bf7>] ? __perf_event_overflow+0x87/0x2c0
[94971.597470]  [<ffffffff8101d0b5>] ? intel_pmu_handle_irq+0x1d5/0x390
[94971.597474]  [<ffffffff81015c86>] ? perf_event_nmi_handler+0x26/0x40
[94971.597476]  [<ffffffff810068e1>] ? nmi_handle+0x61/0xc0
[94971.597478]  [<ffffffff81006a03>] ? do_nmi+0xc3/0x340
[94971.597481]  [<ffffffff8146a9da>] ? end_repeat_nmi+0x1e/0x2e
[94971.597484]  [<ffffffff81468845>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[94971.597486]  [<ffffffff81468845>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[94971.597487]  [<ffffffff81468845>] ? _raw_spin_unlock_irqrestore+0x5/0x10
[94971.597488]  <<EOE>>  <IRQ>  [<ffffffff810946bc>] ? hrtimer_try_to_cancel+0x6c/0x80
[94971.597494]  [<ffffffff810946ea>] ? hrtimer_cancel+0x1a/0x20
[94971.597496]  [<ffffffff810a1bcd>] ? tick_nohz_restart+0xd/0x80
[94971.597498]  [<ffffffff810a1fec>] ? __tick_nohz_full_check+0x9c/0xa0
[94971.597500]  [<ffffffff810c8acc>] ? irq_work_run_list+0x3c/0x70
[94971.597502]  [<ffffffff810c8b15>] ? irq_work_run+0x15/0x40
[94971.597504]  [<ffffffff81093caf>] ? update_process_times+0x4f/0x60
[94971.597506]  [<ffffffff810a1b07>] ? tick_sched_timer+0x37/0x60
[94971.597508]  [<ffffffff810945a1>] ? __run_hrtimer.isra.32+0x41/0xf0
[94971.597510]  [<ffffffff8109493f>] ? hrtimer_interrupt+0xef/0x240
[94971.597513]  [<ffffffff8102cce6>] ? smp_apic_timer_interrupt+0x36/0x50
[94971.597515]  [<ffffffff81469f4a>] ? apic_timer_interrupt+0x6a/0x70
[94971.597516]  <EOI> 
[94971.597518] ---[ end trace 86a8f9a58c486e85 ]---
[95017.589807] INFO: rcu_sched detected stalls on CPUs/tasks:
[95017.589813] 	3: (1313981 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/63e0, nonlazy_posted: 0, .D
[95017.589814] 	(detected by 0, t=15002 jiffies, g=1313681, c=1313680, q=0)
[95017.589816] Task dump for CPU 3:
[95017.589817] chromium        R  running task        0 16509   1944 0x00080108
[95017.589820]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95017.589822]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95017.589823]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95017.589825] Call Trace:
[95017.589831]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95017.589834]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95017.589837]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95017.589839]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95017.589842]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95017.589845]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95017.589847]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95017.589850]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95017.589853]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95017.589857]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95101.261301] INFO: rcu_bh detected stalls on CPUs/tasks:
[95101.261307] 	3: (142 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/b59a, nonlazy_posted: 0, .D
[95101.261309] 	(detected by 0, t=15002 jiffies, g=-158, c=-159, q=0)
[95101.261311] Task dump for CPU 3:
[95101.261312] chromium        R  running task        0 16509   1944 0x00080108
[95101.261315]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95101.261317]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95101.261319]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95101.261321] Call Trace:
[95101.261327]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95101.261331]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95101.261341]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95101.261343]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95101.261346]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95101.261349]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95101.261351]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95101.261354]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95101.261357]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95101.261360]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95141.437391] INFO: task systemd-logind:760 blocked for more than 120 seconds.
[95141.437394]       Tainted: G        W      3.17.0-rc7 #127
[95141.437395] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95141.437404] systemd-logind  D 0000000000000000     0   760      1 0x00000006
[95141.437407]  ffff88022f2e7b60 0000000000000002 000000000000a000 ffff880231319060
[95141.437409]  ffff88022f2e7fd8 ffff88023e211dc0 ffffffff8106453d 7fffffffffffffff
[95141.437410]  ffff88022f2e7c70 ffff880231319060 ffff88022e883840 ffff8800b81b0cb0
[95141.437412] Call Trace:
[95141.437418]  [<ffffffff8106453d>] ? ttwu_do_wakeup+0xd/0x90
[95141.437421]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95141.437423]  [<ffffffff810771bc>] ? __wake_up_common+0x4c/0x80
[95141.437426]  [<ffffffff8111c9fe>] ? __slab_free+0x9e/0x300
[95141.437429]  [<ffffffff8116d66b>] ? ep_poll_callback+0x10b/0x160
[95141.437431]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95141.437433]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95141.437435]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95141.437438]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95141.437440]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95141.437442]  [<ffffffff81070101>] ? rq_offline_fair+0x21/0xa0
[95141.437445]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95141.437449]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95141.437450]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95141.437452]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95141.437455]  [<ffffffff8105c3ac>] ? task_work_run+0xac/0xd0
[95141.437458]  [<ffffffff81046dcf>] ? do_exit+0x34f/0xa00
[95141.437460]  [<ffffffff8106f8a1>] ? enqueue_task_fair+0x51/0x6e0
[95141.437461]  [<ffffffff8106d03c>] ? update_curr+0xac/0xf0
[95141.437463]  [<ffffffff810474e4>] ? do_group_exit+0x34/0xb0
[95141.437466]  [<ffffffff81050c8f>] ? get_signal+0x28f/0x5e0
[95141.437467]  [<ffffffff81061828>] ? finish_task_switch+0xc8/0x130
[95141.437470]  [<ffffffff810022ee>] ? do_signal+0x1e/0xa50
[95141.437472]  [<ffffffff8116d392>] ? ep_poll+0x252/0x420
[95141.437474]  [<ffffffff81002d6c>] ? do_notify_resume+0x4c/0x90
[95141.437476]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95141.437478] INFO: task nmbd:917 blocked for more than 120 seconds.
[95141.437479]       Tainted: G        W      3.17.0-rc7 #127
[95141.437480] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95141.437481] nmbd            D 0000000000000000     0   917      1 0x00000000
[95141.437483]  ffff88022ccf3d40 0000000000000002 000000000000a000 ffff880231080000
[95141.437484]  ffff88022ccf3fd8 dead000000100100 0000100000000000 7fffffffffffffff
[95141.437486]  ffff88022ccf3e50 ffff880231080000 ffff88008cc1ccc0 ffff8800abe5c530
[95141.437488] Call Trace:
[95141.437489]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95141.437492]  [<ffffffff813724d8>] ? sock_sendmsg+0x88/0xc0
[95141.437494]  [<ffffffff813712e1>] ? move_addr_to_user+0xb1/0xd0
[95141.437495]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95141.437497]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95141.437498]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95141.437500]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95141.437502]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95141.437504]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95141.437506]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95141.437508]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95141.437509]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95141.437511]  [<ffffffff8105c38f>] ? task_work_run+0x8f/0xd0
[95141.437512]  [<ffffffff81002d9a>] ? do_notify_resume+0x7a/0x90
[95141.437514]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95141.437528] INFO: task skype:2117 blocked for more than 120 seconds.
[95141.437529]       Tainted: G        W      3.17.0-rc7 #127
[95141.437530] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95141.437531] skype           D 0000000000000000     0  2117   1566 0x20020000
[95141.437532]  ffff8800a29d7d40 0000000000200002 000000000000a000 ffff8800a588a0c0
[95141.437534]  ffff8800a29d7fd8 0000000000011dc0 0000000000011dc0 7fffffffffffffff
[95141.437536]  ffff8800a29d7e50 ffff8800a588a0c0 ffff8800b80fa600 ffff880191ef2ab0
[95141.437537] Call Trace:
[95141.437539]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95141.437541]  [<ffffffff8106f19f>] ? enqueue_entity+0x2df/0x990
[95141.437542]  [<ffffffff8106b9d1>] ? select_task_rq_fair+0x6b1/0x6c0
[95141.437544]  [<ffffffff8106f8a1>] ? enqueue_task_fair+0x51/0x6e0
[95141.437546]  [<ffffffff810922ed>] ? current_fs_time+0xd/0x50
[95141.437548]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95141.437549]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95141.437551]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95141.437553]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95141.437555]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95141.437557]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95141.437559]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95141.437561]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95141.437562]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95141.437564]  [<ffffffff8105c38f>] ? task_work_run+0x8f/0xd0
[95141.437565]  [<ffffffff81002d9a>] ? do_notify_resume+0x7a/0x90
[95141.437567]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95141.437568] INFO: task QThread:2151 blocked for more than 120 seconds.
[95141.437569]       Tainted: G        W      3.17.0-rc7 #127
[95141.437570] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95141.437571] QThread         D 0000000000000000     0  2151   1566 0x20020000
[95141.437572]  ffff8800a2a0bd40 0000000000000002 000000000000a000 ffff8800a588a8f0
[95141.437574]  ffff8800a2a0bfd8 ffffffff813724d8 dead000000200200 7fffffffffffffff
[95141.437575]  ffff8800a2a0be50 ffff8800a588a8f0 ffff8800706b53c0 ffff88021a546fb0
[95141.437577] Call Trace:
[95141.437579]  [<ffffffff813724d8>] ? sock_sendmsg+0x88/0xc0
[95141.437580]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95141.437582]  [<ffffffff813720e2>] ? ___sys_recvmsg+0x112/0x280
[95141.437586]  [<ffffffff8123b228>] ? rhashtable_insert+0x48/0x70
[95141.437587]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95141.437588]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95141.437590]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95141.437592]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95141.437594]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95141.437596]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95141.437598]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95141.437600]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95141.437601]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95141.437603]  [<ffffffff8105c38f>] ? task_work_run+0x8f/0xd0
[95141.437604]  [<ffffffff81002d9a>] ? do_notify_resume+0x7a/0x90
[95141.437606]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95197.574296] INFO: rcu_sched detected stalls on CPUs/tasks:
[95197.574302] 	3: (1313981 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/13ad, nonlazy_posted: 0, .D
[95197.574304] 	(detected by 0, t=60007 jiffies, g=1313681, c=1313680, q=0)
[95197.574306] Task dump for CPU 3:
[95197.574307] chromium        R  running task        0 16509   1944 0x00080108
[95197.574310]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95197.574312]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95197.574314]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95197.574316] Call Trace:
[95197.574329]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95197.574332]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95197.574335]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95197.574338]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95197.574341]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95197.574344]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95197.574346]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95197.574349]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95197.574352]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95197.574356]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95261.413721] INFO: task systemd-logind:760 blocked for more than 120 seconds.
[95261.413725]       Tainted: G        W      3.17.0-rc7 #127
[95261.413726] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95261.413727] systemd-logind  D 0000000000000000     0   760      1 0x00000006
[95261.413731]  ffff88022f2e7b60 0000000000000002 000000000000a000 ffff880231319060
[95261.413733]  ffff88022f2e7fd8 ffff88023e211dc0 ffffffff8106453d 7fffffffffffffff
[95261.413735]  ffff88022f2e7c70 ffff880231319060 ffff88022e883840 ffff8800b81b0cb0
[95261.413737] Call Trace:
[95261.413744]  [<ffffffff8106453d>] ? ttwu_do_wakeup+0xd/0x90
[95261.413754]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95261.413757]  [<ffffffff810771bc>] ? __wake_up_common+0x4c/0x80
[95261.413759]  [<ffffffff8111c9fe>] ? __slab_free+0x9e/0x300
[95261.413762]  [<ffffffff8116d66b>] ? ep_poll_callback+0x10b/0x160
[95261.413764]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95261.413766]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95261.413768]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95261.413771]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95261.413772]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95261.413774]  [<ffffffff81070101>] ? rq_offline_fair+0x21/0xa0
[95261.413777]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95261.413780]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95261.413782]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95261.413784]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95261.413786]  [<ffffffff8105c3ac>] ? task_work_run+0xac/0xd0
[95261.413789]  [<ffffffff81046dcf>] ? do_exit+0x34f/0xa00
[95261.413791]  [<ffffffff8106f8a1>] ? enqueue_task_fair+0x51/0x6e0
[95261.413792]  [<ffffffff8106d03c>] ? update_curr+0xac/0xf0
[95261.413794]  [<ffffffff810474e4>] ? do_group_exit+0x34/0xb0
[95261.413796]  [<ffffffff81050c8f>] ? get_signal+0x28f/0x5e0
[95261.413798]  [<ffffffff81061828>] ? finish_task_switch+0xc8/0x130
[95261.413800]  [<ffffffff810022ee>] ? do_signal+0x1e/0xa50
[95261.413802]  [<ffffffff8116d392>] ? ep_poll+0x252/0x420
[95261.413804]  [<ffffffff81002d6c>] ? do_notify_resume+0x4c/0x90
[95261.413806]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95261.413808] INFO: task nmbd:917 blocked for more than 120 seconds.
[95261.413809]       Tainted: G        W      3.17.0-rc7 #127
[95261.413809] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95261.413810] nmbd            D 0000000000000000     0   917      1 0x00000000
[95261.413812]  ffff88022ccf3d40 0000000000000002 000000000000a000 ffff880231080000
[95261.413813]  ffff88022ccf3fd8 dead000000100100 0000100000000000 7fffffffffffffff
[95261.413815]  ffff88022ccf3e50 ffff880231080000 ffff88008cc1ccc0 ffff8800abe5c530
[95261.413816] Call Trace:
[95261.413818]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95261.413820]  [<ffffffff813724d8>] ? sock_sendmsg+0x88/0xc0
[95261.413822]  [<ffffffff813712e1>] ? move_addr_to_user+0xb1/0xd0
[95261.413823]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95261.413824]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95261.413826]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95261.413828]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95261.413830]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95261.413831]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95261.413833]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95261.413835]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95261.413836]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95261.413838]  [<ffffffff8105c38f>] ? task_work_run+0x8f/0xd0
[95261.413839]  [<ffffffff81002d9a>] ? do_notify_resume+0x7a/0x90
[95261.413841]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95261.413854] INFO: task skype:2117 blocked for more than 120 seconds.
[95261.413855]       Tainted: G        W      3.17.0-rc7 #127
[95261.413856] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95261.413857] skype           D 0000000000000000     0  2117   1566 0x20020000
[95261.413858]  ffff8800a29d7d40 0000000000200002 000000000000a000 ffff8800a588a0c0
[95261.413860]  ffff8800a29d7fd8 0000000000011dc0 0000000000011dc0 7fffffffffffffff
[95261.413861]  ffff8800a29d7e50 ffff8800a588a0c0 ffff8800b80fa600 ffff880191ef2ab0
[95261.413862] Call Trace:
[95261.413864]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95261.413866]  [<ffffffff8106f19f>] ? enqueue_entity+0x2df/0x990
[95261.413867]  [<ffffffff8106b9d1>] ? select_task_rq_fair+0x6b1/0x6c0
[95261.413869]  [<ffffffff8106f8a1>] ? enqueue_task_fair+0x51/0x6e0
[95261.413871]  [<ffffffff810922ed>] ? current_fs_time+0xd/0x50
[95261.413872]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95261.413873]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95261.413875]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95261.413877]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95261.413879]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95261.413880]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95261.413882]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95261.413884]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95261.413885]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95261.413887]  [<ffffffff8105c38f>] ? task_work_run+0x8f/0xd0
[95261.413888]  [<ffffffff81002d9a>] ? do_notify_resume+0x7a/0x90
[95261.413890]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95261.413891] INFO: task QThread:2151 blocked for more than 120 seconds.
[95261.413892]       Tainted: G        W      3.17.0-rc7 #127
[95261.413892] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95261.413893] QThread         D 0000000000000000     0  2151   1566 0x20020000
[95261.413894]  ffff8800a2a0bd40 0000000000000002 000000000000a000 ffff8800a588a8f0
[95261.413896]  ffff8800a2a0bfd8 ffffffff813724d8 dead000000200200 7fffffffffffffff
[95261.413897]  ffff8800a2a0be50 ffff8800a588a8f0 ffff8800706b53c0 ffff88021a546fb0
[95261.413899] Call Trace:
[95261.413901]  [<ffffffff813724d8>] ? sock_sendmsg+0x88/0xc0
[95261.413902]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95261.413904]  [<ffffffff813720e2>] ? ___sys_recvmsg+0x112/0x280
[95261.413907]  [<ffffffff8123b228>] ? rhashtable_insert+0x48/0x70
[95261.413908]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95261.413909]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95261.413911]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95261.413913]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95261.413914]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95261.413916]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95261.413918]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95261.413920]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95261.413921]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95261.413923]  [<ffffffff8105c38f>] ? task_work_run+0x8f/0xd0
[95261.413924]  [<ffffffff81002d9a>] ? do_notify_resume+0x7a/0x90
[95261.413926]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95261.413938] INFO: task pickup:16578 blocked for more than 120 seconds.
[95261.413939]       Tainted: G        W      3.17.0-rc7 #127
[95261.413940] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95261.413941] pickup          D 0000000000000000     0 16578   1278 0x00000000
[95261.413942]  ffff8801ea58bd40 0000000000000002 000000000000a000 ffff88002ea7a0c0
[95261.413943]  ffff8801ea58bfd8 0000000000000000 0000100000000000 7fffffffffffffff
[95261.413945]  ffff8801ea58be50 ffff88002ea7a0c0 ffff88003d0e0540 ffff8801019e1930
[95261.413946] Call Trace:
[95261.413948]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95261.413950]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95261.413953]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95261.413954]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95261.413955]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95261.413957]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95261.413958]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95261.413960]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95261.413962]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95261.413964]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95261.413966]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95261.413967]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95261.413969]  [<ffffffff8105c38f>] ? task_work_run+0x8f/0xd0
[95261.413970]  [<ffffffff81002d9a>] ? do_notify_resume+0x7a/0x90
[95261.413971]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95281.245787] INFO: rcu_bh detected stalls on CPUs/tasks:
[95281.245793] 	3: (142 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/6567, nonlazy_posted: 0, .D
[95281.245794] 	(detected by 0, t=60007 jiffies, g=-158, c=-159, q=0)
[95281.245797] Task dump for CPU 3:
[95281.245798] chromium        R  running task        0 16509   1944 0x00080108
[95281.245801]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95281.245803]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95281.245805]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95281.245807] Call Trace:
[95281.245820]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95281.245824]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95281.245826]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95281.245828]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95281.245832]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95281.245835]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95281.245837]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95281.245840]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95281.245843]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95281.245846]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95377.558780] INFO: rcu_sched detected stalls on CPUs/tasks:
[95377.558786] 	3: (1313981 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/c37a, nonlazy_posted: 0, .D
[95377.558787] 	(detected by 0, t=105012 jiffies, g=1313681, c=1313680, q=0)
[95377.558790] Task dump for CPU 3:
[95377.558791] chromium        R  running task        0 16509   1944 0x00080108
[95377.558794]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95377.558796]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95377.558797]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95377.558799] Call Trace:
[95377.558805]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95377.558808]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95377.558811]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95377.558813]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95377.558816]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95377.558819]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95377.558822]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95377.558824]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95377.558828]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95377.558831]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95381.390055] INFO: task systemd-logind:760 blocked for more than 120 seconds.
[95381.390058]       Tainted: G        W      3.17.0-rc7 #127
[95381.390059] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[95381.390061] systemd-logind  D 0000000000000000     0   760      1 0x00000006
[95381.390064]  ffff88022f2e7b60 0000000000000002 000000000000a000 ffff880231319060
[95381.390066]  ffff88022f2e7fd8 ffff88023e211dc0 ffffffff8106453d 7fffffffffffffff
[95381.390068]  ffff88022f2e7c70 ffff880231319060 ffff88022e883840 ffff8800b81b0cb0
[95381.390070] Call Trace:
[95381.390076]  [<ffffffff8106453d>] ? ttwu_do_wakeup+0xd/0x90
[95381.390079]  [<ffffffff81467fcd>] ? schedule_timeout+0x17d/0x1f0
[95381.390082]  [<ffffffff810771bc>] ? __wake_up_common+0x4c/0x80
[95381.390085]  [<ffffffff8111c9fe>] ? __slab_free+0x9e/0x300
[95381.390088]  [<ffffffff8116d66b>] ? ep_poll_callback+0x10b/0x160
[95381.390090]  [<ffffffff814661b9>] ? wait_for_completion+0xa9/0x110
[95381.390092]  [<ffffffff81066d10>] ? wake_up_state+0x10/0x10
[95381.390095]  [<ffffffff8108f1c0>] ? __call_rcu+0x280/0x280
[95381.390098]  [<ffffffff8108d7e6>] ? wait_rcu_gp+0x46/0x50
[95381.390100]  [<ffffffff8108d790>] ? rcu_panic+0x10/0x10
[95381.390102]  [<ffffffff81070101>] ? rq_offline_fair+0x21/0xa0
[95381.390105]  [<ffffffff813b29ba>] ? netlink_release+0x13a/0x310
[95381.390108]  [<ffffffff81371735>] ? sock_release+0x15/0x80
[95381.390111]  [<ffffffff813717a9>] ? sock_close+0x9/0x10
[95381.390113]  [<ffffffff811320c5>] ? __fput+0xc5/0x1e0
[95381.390116]  [<ffffffff8105c3ac>] ? task_work_run+0xac/0xd0
[95381.390119]  [<ffffffff81046dcf>] ? do_exit+0x34f/0xa00
[95381.390121]  [<ffffffff8106f8a1>] ? enqueue_task_fair+0x51/0x6e0
[95381.390123]  [<ffffffff8106d03c>] ? update_curr+0xac/0xf0
[95381.390125]  [<ffffffff810474e4>] ? do_group_exit+0x34/0xb0
[95381.390127]  [<ffffffff81050c8f>] ? get_signal+0x28f/0x5e0
[95381.390130]  [<ffffffff81061828>] ? finish_task_switch+0xc8/0x130
[95381.390132]  [<ffffffff810022ee>] ? do_signal+0x1e/0xa50
[95381.390134]  [<ffffffff8116d392>] ? ep_poll+0x252/0x420
[95381.390136]  [<ffffffff81002d6c>] ? do_notify_resume+0x4c/0x90
[95381.390138]  [<ffffffff814692a2>] ? int_signal+0x12/0x17
[95461.230274] INFO: rcu_bh detected stalls on CPUs/tasks:
[95461.230280] 	3: (142 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/1534, nonlazy_posted: 0, .D
[95461.230282] 	(detected by 0, t=105012 jiffies, g=-158, c=-159, q=0)
[95461.230284] Task dump for CPU 3:
[95461.230286] chromium        R  running task        0 16509   1944 0x00080108
[95461.230289]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95461.230291]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95461.230293]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95461.230295] Call Trace:
[95461.230300]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95461.230304]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95461.230307]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95461.230309]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95461.230313]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95461.230316]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95461.230318]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95461.230329]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95461.230332]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95461.230335]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95557.543272] INFO: rcu_sched detected stalls on CPUs/tasks:
[95557.543278] 	3: (1313981 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/7347, nonlazy_posted: 0, .D
[95557.543280] 	(detected by 0, t=150017 jiffies, g=1313681, c=1313680, q=0)
[95557.543283] Task dump for CPU 3:
[95557.543284] chromium        R  running task        0 16509   1944 0x00080108
[95557.543287]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95557.543289]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95557.543291]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95557.543301] Call Trace:
[95557.543306]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95557.543309]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95557.543312]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95557.543314]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95557.543318]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95557.543321]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95557.543324]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95557.543326]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95557.543330]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95557.543333]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95641.214766] INFO: rcu_bh detected stalls on CPUs/tasks:
[95641.214771] 	3: (142 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/c501, nonlazy_posted: 0, .D
[95641.214773] 	(detected by 0, t=150017 jiffies, g=-158, c=-159, q=0)
[95641.214775] Task dump for CPU 3:
[95641.214776] chromium        R  running task        0 16509   1944 0x0008010c
[95641.214779]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95641.214789]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95641.214791]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95641.214793] Call Trace:
[95641.214798]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95641.214802]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95641.214804]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95641.214807]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95641.214810]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95641.214813]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95641.214815]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95641.214818]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95641.214822]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95641.214825]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95737.527762] INFO: rcu_sched detected stalls on CPUs/tasks:
[95737.527768] 	3: (1313981 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/2314, nonlazy_posted: 0, .D
[95737.527769] 	(detected by 0, t=195022 jiffies, g=1313681, c=1313680, q=0)
[95737.527772] Task dump for CPU 3:
[95737.527773] chromium        R  running task        0 16509   1944 0x0008010c
[95737.527776]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95737.527778]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95737.527787]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95737.527789] Call Trace:
[95737.527795]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95737.527798]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95737.527801]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95737.527803]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95737.527807]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95737.527810]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95737.527812]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95737.527815]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95737.527819]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95737.527822]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95821.199256] INFO: rcu_bh detected stalls on CPUs/tasks:
[95821.199261] 	3: (142 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/74ce, nonlazy_posted: 0, .D
[95821.199263] 	(detected by 0, t=195022 jiffies, g=-158, c=-159, q=0)
[95821.199265] Task dump for CPU 3:
[95821.199267] chromium        R  running task        0 16509   1944 0x0008010c
[95821.199269]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95821.199271]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95821.199273]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95821.199275] Call Trace:
[95821.199288]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95821.199292]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95821.199294]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95821.199297]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95821.199300]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95821.199303]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95821.199305]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95821.199308]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95821.199311]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95821.199315]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[95917.512254] INFO: rcu_sched detected stalls on CPUs/tasks:
[95917.512260] 	3: (1313981 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/d2e1, nonlazy_posted: 0, .D
[95917.512261] 	(detected by 0, t=240027 jiffies, g=1313681, c=1313680, q=0)
[95917.512264] Task dump for CPU 3:
[95917.512265] chromium        R  running task        0 16509   1944 0x0008010c
[95917.512268]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[95917.512270]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[95917.512272]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[95917.512274] Call Trace:
[95917.512287]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[95917.512291]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[95917.512294]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[95917.512296]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[95917.512299]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[95917.512302]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[95917.512304]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[95917.512307]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[95917.512311]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[95917.512314]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[96001.183749] INFO: rcu_bh detected stalls on CPUs/tasks:
[96001.183755] 	3: (142 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/249b, nonlazy_posted: 0, .D
[96001.183756] 	(detected by 0, t=240027 jiffies, g=-158, c=-159, q=0)
[96001.183759] Task dump for CPU 3:
[96001.183760] chromium        R  running task        0 16509   1944 0x0008010c
[96001.183763]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[96001.183765]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[96001.183774]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[96001.183776] Call Trace:
[96001.183782]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[96001.183785]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[96001.183788]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[96001.183791]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[96001.183794]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[96001.183797]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[96001.183800]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[96001.183803]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[96001.183806]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[96001.183810]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[96097.496748] INFO: rcu_sched detected stalls on CPUs/tasks:
[96097.496753] 	3: (1313981 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/82ae, nonlazy_posted: 0, .D
[96097.496755] 	(detected by 0, t=285032 jiffies, g=1313681, c=1313680, q=0)
[96097.496757] Task dump for CPU 3:
[96097.496759] chromium        R  running task        0 16509   1944 0x0008010c
[96097.496761]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[96097.496764]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[96097.496773]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[96097.496775] Call Trace:
[96097.496780]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[96097.496784]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[96097.496787]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[96097.496789]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[96097.496792]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[96097.496795]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[96097.496798]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[96097.496801]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[96097.496804]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[96097.496808]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30
[96181.168242] INFO: rcu_bh detected stalls on CPUs/tasks:
[96181.168247] 	3: (142 GPs behind) idle=47b/1/0 softirq=0/0 last_accelerate: 0000/d468, nonlazy_posted: 0, .D
[96181.168249] 	(detected by 0, t=285032 jiffies, g=-158, c=-159, q=0)
[96181.168251] Task dump for CPU 3:
[96181.168252] chromium        R  running task        0 16509   1944 0x0008010c
[96181.168255]  0000000000000000 00000000c000003e ffffffff81863e00 ffff88000de8beb0
[96181.168257]  ffff88011c9fc9b0 ffffffff81863e08 ffff88011c9fc9b0 ffff88011c9fc9b0
[96181.168267]  0000000000000001 ffff88011c9fc9b0 0000000000000000 ffff88023e38e080
[96181.168269] Call Trace:
[96181.168274]  [<ffffffff810e417d>] ? release_pages+0xad/0x230
[96181.168278]  [<ffffffff8112a857>] ? mem_cgroup_commit_charge+0x47/0x80
[96181.168281]  [<ffffffff810fdad8>] ? handle_mm_fault+0xb28/0xea0
[96181.168283]  [<ffffffff81066aab>] ? try_to_wake_up+0xdb/0x2e0
[96181.168287]  [<ffffffff810372e0>] ? __do_page_fault+0x200/0x490
[96181.168290]  [<ffffffff810a57dd>] ? do_futex+0x10d/0xa60
[96181.168292]  [<ffffffff8113006f>] ? new_sync_write+0x6f/0xa0
[96181.168295]  [<ffffffff81167f16>] ? fsnotify+0x2b6/0x390
[96181.168299]  [<ffffffff810c6fbb>] ? __secure_computing+0x8b/0x2a0
[96181.168302]  [<ffffffff8146a6d2>] ? page_fault+0x22/0x30

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.17.0-rc7 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_NO_HZ_FULL_ALL=y
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y
# CONFIG_BUILD_BIN2C is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
# CONFIG_MEMCG_KMEM is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=m
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=m
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_ACPI_CPUFREQ_CPB is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=m
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=m
CONFIG_NFT_EXTHDR=m
CONFIG_NFT_META=m
CONFIG_NFT_CT=m
CONFIG_NFT_RBTREE=m
CONFIG_NFT_HASH=m
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_NAT=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPCOMP=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NFT_CHAIN_NAT_IPV4=m
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NF_TABLES_ARP=m
CONFIG_NF_NAT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_NF_TABLES_IPV6=m
CONFIG_NFT_CHAIN_ROUTE_IPV6=m
CONFIG_NFT_CHAIN_NAT_IPV6=m
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_NF_NAT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_IP6_NF_SECURITY is not set
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
CONFIG_NF_TABLES_BRIDGE=m
CONFIG_NFT_BRIDGE_META=m
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_LOG_BRIDGE=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_ATH3K=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
# CONFIG_NFTL_RW is not set
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_MTD_UBI_BLOCK=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=m
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
CONFIG_PATA_SCH=m
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_MQ=m
CONFIG_DM_CACHE_CLEANER=m
CONFIG_DM_ERA=m
CONFIG_DM_MIRROR=m
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=m
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=m
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_VXLAN=m
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=m
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_XGENE is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_CX_ECAT is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
# CONFIG_I40EVF is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_NET_VENDOR_RDC is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# Host-side USB support is needed for USB Network Adapter support
#
CONFIG_USB_NET_DRIVERS=m
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=m
CONFIG_USB_NET_SR9800=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=m
CONFIG_KEYBOARD_LKKBD=m
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_LM8323=m
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
# CONFIG_KEYBOARD_SAMSUNG is not set
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_SERIAL_WACOM4 is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PINCTRL is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=m
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
CONFIG_IR_LIRC_CODEC=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_XMP_DECODER=m
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
CONFIG_IR_IMG=m
CONFIG_IR_IMG_RAW=y
CONFIG_IR_IMG_HW=y
CONFIG_IR_IMG_NEC=y
CONFIG_IR_IMG_JVC=y
CONFIG_IR_IMG_SONY=y
CONFIG_IR_IMG_SHARP=y
CONFIG_IR_IMG_SANYO=y
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_DTCS033=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_VIDEO_CPIA2=m
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_VIDEO_USBTV=m

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_STK1160_COMMON=m
CONFIG_VIDEO_STK1160_AC97=y
CONFIG_VIDEO_STK1160=m
CONFIG_VIDEO_GO7007=m
CONFIG_VIDEO_GO7007_USB=m
CONFIG_VIDEO_GO7007_LOADER=m
CONFIG_VIDEO_GO7007_USB_S2250_BOARD=m

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
CONFIG_VIDEO_AU0828_RC=y
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_V4L2=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_EM28XX_RC is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_IVTV_ALSA=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_SOLO6X10=m

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
CONFIG_VIDEO_CX25821=m
CONFIG_VIDEO_CX25821_ALSA=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=m
CONFIG_VIDEO_MT9V011=m

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88TS2022=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_PTN3460 is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=m
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=m
CONFIG_HOLTEK_FF=y
# CONFIG_HID_GT683R is not set
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=m
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PRIMAX=m
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_SONY_FF=y
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_OTG_FSM is not set
CONFIG_USB_MON=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
CONFIG_USBIP_HOST=m
# CONFIG_USBIP_DEBUG is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=m
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_F81232=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MXUPORT=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_IE31200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_EDAC_SBRIDGE=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set
# CONFIG_RTC_DRV_MCP795 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_EFI is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_XGENE is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=m
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO=m
CONFIG_VFIO_PCI=m
CONFIG_VFIO_PCI_VGA=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=m
CONFIG_INTEL_SMARTCONNECT=m
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_SI5351 is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=m
CONFIG_EFI_VARS_PSTORE=m
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
CONFIG_EFIVAR_FS=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_NFS_V4_1_MIGRATION=y
CONFIG_NFS_V4_SECURITY_LABEL=y
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_V4_SECURITY_LABEL is not set
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
# CONFIG_CIFS_DEBUG is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_CRCT10DIF is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
CONFIG_KVM_DEVICE_ASSIGNMENT=y
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=m
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_ARCH_HAS_SG_CHAIN=y

-- 
Meelis Roos (mroos@linux.ee)
