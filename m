Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3AQAYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 19:24:11 -0500
Received: from mail.palosanto.com ([201.234.196.171]:36925 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab3AQAYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 19:24:07 -0500
Message-ID: <50F744A1.1080806@palosanto.com>
Date: Wed, 16 Jan 2013 19:24:01 -0500
From: =?ISO-8859-1?Q?Alex_Villac=EDs_Lasso?= <a_villacis@palosanto.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Use of memmap= to forcibly recover memory in 3GB-4GB range -
 is this safe?
References: <50F606A8.2080804@palosanto.com> <CAE9FiQXg29gdrC8RK0Z8vLexju3yNpu9MvJcYHUoPnCNceSWkw@mail.gmail.com>
In-Reply-To: <CAE9FiQXg29gdrC8RK0Z8vLexju3yNpu9MvJcYHUoPnCNceSWkw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020003080607020802040204"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020003080607020802040204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

El 16/01/13 02:11, Yinghai Lu escribió:
> On Tue, Jan 15, 2013 at 5:47 PM, Alex Villacís Lasso
> <a_villacis@palosanto.com> wrote:
>> [    0.000000] e820: BIOS-provided physical RAM map:
>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
>> [    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff]
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf58ffff] usable
>> [    0.000000] BIOS-e820: [mem 0x00000000cf590000-0x00000000cf5e2fff] ACPI
>> NVS
>> [    0.000000] BIOS-e820: [mem 0x00000000cf5e3000-0x00000000cf5effff] ACPI
>> data
>> [    0.000000] BIOS-e820: [mem 0x00000000cf5f0000-0x00000000cf5fffff]
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff]
>> reserved
>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff]
>> reserved
>> [    0.000000] NX (Execute Disable) protection: active
> ..
>> [    0.000000] original variable MTRRs
>> [    0.000000] reg 0, base: 4GB, range: 512MB, type WB
>> [    0.000000] reg 1, base: 4608MB, range: 256MB, type WB
>> [    0.000000] reg 2, base: 0GB, range: 2GB, type WB
>> [    0.000000] reg 3, base: 2GB, range: 1GB, type WB
>> [    0.000000] reg 4, base: 3GB, range: 256MB, type WB
>> [    0.000000] reg 5, base: 3319MB, range: 1MB, type UC
>> [    0.000000] reg 6, base: 3320MB, range: 8MB, type UC
>> [    0.000000] reg 7, base: 3318MB, range: 1MB, type UC
>> [    0.000000] total RAM covered: 4086M
> Can you apply attached debug patch to see if the raw e820 is right from BIOS ?
>
> Yinghai
Done. The output is attached. I see no difference between raw and 
sanitized maps.

--------------020003080607020802040204
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc3 (alex@karlalex.palosanto.com) (gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #17 SMP PREEMPT Wed Jan 16 18:56:39 ECT 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc3 root=UUID=4837c784-4583-4efc-8a40-260819368469 ro rd.md=0 rd.lvm=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=es_ES.UTF-8 KEYTABLE=es zcache drm_kms_helper.edid_firmware=edid/1280x1024.bin
[    0.000000] Physical RAM map:
[    0.000000] raw: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] raw: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] raw: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] raw: [mem 0x0000000000100000-0x00000000cf58ffff] usable
[    0.000000] raw: [mem 0x00000000cf590000-0x00000000cf5e2fff] ACPI NVS
[    0.000000] raw: [mem 0x00000000cf5e3000-0x00000000cf5effff] ACPI data
[    0.000000] raw: [mem 0x00000000cf5f0000-0x00000000cf5fffff] reserved
[    0.000000] raw: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] raw: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] e820: BIOS-provided physical RAM map (sanitized by setup):
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cf58ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf590000-0x00000000cf5e2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf5e3000-0x00000000cf5effff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cf5f0000-0x00000000cf5fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: OEM OEM/G31MVP, BIOS 6.00 PG 09/11/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xcf590 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-F7FFF uncachable
[    0.000000]   F8000-FBFFF write-through
[    0.000000]   FC000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 100000000 mask FE0000000 write-back
[    0.000000]   1 base 120000000 mask FF0000000 write-back
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 0C0000000 mask FF0000000 write-back
[    0.000000]   5 base 0CF700000 mask FFFF00000 uncachable
[    0.000000]   6 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   7 base 0CF600000 mask FFFF00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 4GB, range: 512MB, type WB
[    0.000000] reg 1, base: 4608MB, range: 256MB, type WB
[    0.000000] reg 2, base: 0GB, range: 2GB, type WB
[    0.000000] reg 3, base: 2GB, range: 1GB, type WB
[    0.000000] reg 4, base: 3GB, range: 256MB, type WB
[    0.000000] reg 5, base: 3319MB, range: 1MB, type UC
[    0.000000] reg 6, base: 3320MB, range: 8MB, type UC
[    0.000000] reg 7, base: 3318MB, range: 1MB, type UC
[    0.000000] total RAM covered: 4086M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 3318MB, range: 2MB, type UC
[    0.000000] reg 4, base: 3320MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4GB, range: 512MB, type WB
[    0.000000] reg 6, base: 4608MB, range: 256MB, type WB
[    0.000000] e820: update [mem 0xcf600000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000f3df0-0x000f3dff] mapped at [ffff8800000f3df0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcf58ffff]
[    0.000000]  [mem 0x00000000-0xcf3fffff] page 2M
[    0.000000]  [mem 0xcf400000-0xcf58ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcf58ffff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] RAMDISK: [mem 0x37474000-0x37a31fff]
[    0.000000] ACPI: RSDP 00000000000f82c0 00024 (v02 IntelR)
[    0.000000] ACPI: XSDT 00000000cf5e3080 00054 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 00000000cf5e80c0 000F4 (v03 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 00000000cf5e3200 04E99 (v01 INTELR AWRDACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000cf590000 00040
[    0.000000] ACPI: HPET 00000000cf5e82c0 00038 (v01 IntelR AWRDACPI 42302E31 AWRD 00000098)
[    0.000000] ACPI: MCFG 00000000cf5e8300 0003C (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: SLIC 00000000cf5e8340 00176 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 00000000cf5e81c0 00084 (v01 IntelR AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 00000000cf5e8b20 007EF (v01  PmRef    CpuPm 00003000 INTL 20041203)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000000cf58ffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0xcf58ffff]
[    0.000000]   NODE_DATA [mem 0xcf57c000-0xcf58ffff]
[    0.000000]  [ffffea0000000000-ffffea00033fffff] PMD -> [ffff8800cb800000-ffff8800cebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcf58ffff]
[    0.000000] On node 0 totalpages: 849183
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13207 pages used for memmap
[    0.000000]   DMA32 zone: 831993 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0xcf600000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800cf200000 s85120 r8192 d21376 u524288
[    0.000000] pcpu-alloc: s85120 r8192 d21376 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 835906
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc3 root=UUID=4837c784-4583-4efc-8a40-260819368469 ro rd.md=0 rd.lvm=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 LANG=es_ES.UTF-8 KEYTABLE=es zcache drm_kms_helper.edid_firmware=edid/1280x1024.bin
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3321024k/3397184k available (6550k kernel code, 452k absent, 75708k reserved, 6675k data, 1076k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 13631488 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2755.442 MHz processor
[    0.001003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5510.88 BogoMIPS (lpj=2755442)
[    0.001007] pid_max: default: 32768 minimum: 301
[    0.001041] Security Framework initialized
[    0.001052] SELinux:  Initializing.
[    0.001062] SELinux:  Starting in permissive mode
[    0.001442] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003543] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004508] Mount-cache hash table entries: 256
[    0.004737] Initializing cgroup subsys cpuacct
[    0.004740] Initializing cgroup subsys memory
[    0.004759] Initializing cgroup subsys devices
[    0.004761] Initializing cgroup subsys freezer
[    0.004762] Initializing cgroup subsys net_cls
[    0.004764] Initializing cgroup subsys blkio
[    0.004766] Initializing cgroup subsys perf_event
[    0.004795] CPU: Physical Processor ID: 0
[    0.004796] CPU: Processor Core ID: 0
[    0.004798] mce: CPU supports 6 MCE banks
[    0.004806] CPU0: Thermal monitoring enabled (TM2)
[    0.004810] process: using mwait in idle threads
[    0.004815] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.004815] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.004815] tlb_flushall_shift: -1
[    0.004915] Freeing SMP alternatives: 24k freed
[    0.006065] ACPI: Core revision 20121018
[    0.008008] ftrace: allocating 24178 entries in 95 pages
[    0.014463] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.024948] smpboot: CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz (fam: 06, model: 17, stepping: 06)
[    0.025000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.025000] ... version:                2
[    0.025000] ... bit width:              40
[    0.025000] ... generic registers:      2
[    0.025000] ... value mask:             000000ffffffffff
[    0.025000] ... max period:             000000007fffffff
[    0.025000] ... fixed-purpose events:   3
[    0.025000] ... event mask:             0000000700000003
[    0.045107] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.033084] smpboot: Booting Node   0, Processors  #1
[    0.045124] Brought up 2 CPUs
[    0.045126] smpboot: Total of 2 processors activated (11021.76 BogoMIPS)
[    0.046099] devtmpfs: initialized
[    0.046169] PM: Registering ACPI NVS region [mem 0xcf590000-0xcf5e2fff] (339968 bytes)
[    0.047615] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.047638] RTC time:  0:05:41, date: 01/17/13
[    0.047682] NET: Registered protocol family 16
[    0.047855] ACPI: bus type pci registered
[    0.047906] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.047908] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.061327] PCI: Using configuration type 1 for base access
[    0.062097] bio: create slab <bio-0> at 0
[    0.062097] ACPI: Added _OSI(Module Device)
[    0.062097] ACPI: Added _OSI(Processor Device)
[    0.062097] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.062097] ACPI: Added _OSI(Processor Aggregator Device)
[    0.063212] ACPI: EC: Look up EC in DSDT
[    0.065824] ACPI: SSDT 00000000cf5e8500 002AE (v01  PmRef  Cpu0Ist 00003000 INTL 20041203)
[    0.066009] ACPI: Dynamic OEM Table Load:
[    0.066011] ACPI: SSDT           (null) 002AE (v01  PmRef  Cpu0Ist 00003000 INTL 20041203)
[    0.066170] ACPI: SSDT 00000000cf5e89c0 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20041203)
[    0.066342] ACPI: Dynamic OEM Table Load:
[    0.066345] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20041203)
[    0.066502] ACPI: Interpreter enabled
[    0.066506] ACPI: (supports S0 S3 S4 S5)
[    0.066518] ACPI: Using IOAPIC for interrupt routing
[    0.069799] ACPI: No dock devices found.
[    0.069803] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.069846] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.069849] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.069909] pci_root PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.069912] pci_root PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.069995] PCI host bridge to bus 0000:00
[    0.070003] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.070005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.070007] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.070009] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.070011] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.070013] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.070015] pci_bus 0000:00: root bus resource [mem 0xcf600000-0xfebfffff]
[    0.070024] pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
[    0.070066] pci 0000:00:02.0: [8086:29c2] type 00 class 0x030000
[    0.070075] pci 0000:00:02.0: reg 10: [mem 0xfdf00000-0xfdf7ffff]
[    0.070080] pci 0000:00:02.0: reg 14: [io  0xff00-0xff07]
[    0.070086] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.070091] pci 0000:00:02.0: reg 1c: [mem 0xfdb00000-0xfdbfffff]
[    0.070149] pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
[    0.070162] pci 0000:00:1b.0: reg 10: [mem 0xfdff8000-0xfdffbfff 64bit]
[    0.070220] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.070240] pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
[    0.070299] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.070319] pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
[    0.070378] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.070400] pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
[    0.070434] pci 0000:00:1d.0: reg 20: [io  0xfe00-0xfe1f]
[    0.070462] pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
[    0.070496] pci 0000:00:1d.1: reg 20: [io  0xfd00-0xfd1f]
[    0.070525] pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
[    0.070560] pci 0000:00:1d.2: reg 20: [io  0xfc00-0xfc1f]
[    0.070587] pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
[    0.070621] pci 0000:00:1d.3: reg 20: [io  0xfb00-0xfb1f]
[    0.070656] pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
[    0.070672] pci 0000:00:1d.7: reg 10: [mem 0xfdfff000-0xfdfff3ff]
[    0.070743] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.070760] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.070814] pci 0000:00:1f.0: [8086:27b8] type 00 class 0x060100
[    0.070885] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 003f)
[    0.070888] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 003f)
[    0.070891] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 000b)
[    0.070927] pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
[    0.070938] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.070946] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.070954] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.070962] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.070970] pci 0000:00:1f.1: reg 20: [io  0xfa00-0xfa0f]
[    0.071007] pci 0000:00:1f.2: [8086:27c0] type 00 class 0x01018f
[    0.071019] pci 0000:00:1f.2: reg 10: [io  0xf900-0xf907]
[    0.071026] pci 0000:00:1f.2: reg 14: [io  0xf800-0xf803]
[    0.071033] pci 0000:00:1f.2: reg 18: [io  0xf700-0xf707]
[    0.071040] pci 0000:00:1f.2: reg 1c: [io  0xf600-0xf603]
[    0.071047] pci 0000:00:1f.2: reg 20: [io  0xf500-0xf50f]
[    0.071055] pci 0000:00:1f.2: reg 24: [mem 0xfdffe000-0xfdffe3ff]
[    0.071080] pci 0000:00:1f.2: PME# supported from D3hot
[    0.071093] pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
[    0.071137] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.071200] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.071203] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.071206] pci 0000:00:1c.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.071212] pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.071269] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.071285] pci 0000:02:00.0: reg 10: [io  0xee00-0xeeff]
[    0.071313] pci 0000:02:00.0: reg 18: [mem 0xfddff000-0xfddfffff 64bit]
[    0.071345] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.071416] pci 0000:02:00.0: supports D1 D2
[    0.071418] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.073022] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.073029] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.073035] pci 0000:00:1c.1:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.073043] pci 0000:00:1c.1:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.073118] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.073121] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.073125] pci 0000:00:1e.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    0.073130] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    0.073132] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.073134] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.073136] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.073138] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.073140] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.073141] pci 0000:00:1e.0:   bridge window [mem 0xcf600000-0xfebfffff] (subtractive decode)
[    0.073163] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.073188] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.073216] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.073269] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.078745] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.078783] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.078819] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.078855] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 12 14 *15)
[    0.078891] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.078928] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.078965] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.079008] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.079064] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.079064] vgaarb: loaded
[    0.079064] vgaarb: bridge control possible 0000:00:02.0
[    0.079094] SCSI subsystem initialized
[    0.079098] ACPI: bus type scsi registered
[    0.079107] libata version 3.00 loaded.
[    0.079107] ACPI: bus type usb registered
[    0.079107] usbcore: registered new interface driver usbfs
[    0.079107] usbcore: registered new interface driver hub
[    0.079107] usbcore: registered new device driver usb
[    0.079107] PCI: Using ACPI for IRQ routing
[    0.084268] PCI: pci_cache_line_size set to 64 bytes
[    0.084312] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.084314] e820: reserve RAM buffer [mem 0xcf590000-0xcfffffff]
[    0.084403] NetLabel: Initializing
[    0.084405] NetLabel:  domain hash size = 128
[    0.084406] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.084417] NetLabel:  unlabeled traffic allowed by default
[    0.084466] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.084470] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.084474] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.090013] Switching to clocksource hpet
[    0.097152] pnp: PnP ACPI init
[    0.097174] ACPI: bus type pnp registered
[    0.097321] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.097324] system 00:00: [io  0x0290-0x029f] has been reserved
[    0.097326] system 00:00: [io  0x0800-0x087f] has been reserved
[    0.097328] system 00:00: [io  0x0290-0x0297] has been reserved
[    0.097330] system 00:00: [io  0x0880-0x088f] has been reserved
[    0.097334] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.097345] pnp 00:01: [dma 4]
[    0.097361] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.097439] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.097478] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.097500] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.097528] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.097649] pnp 00:06: [dma 2]
[    0.097676] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.097858] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.098103] pnp 00:08: Plug and Play ACPI device, IDs PNP0510 (active)
[    0.098334] pnp 00:09: [dma 3]
[    0.098376] pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.098422] pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.098466] pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.098517] system 00:0c: [io  0x0400-0x04bf] has been reserved
[    0.098520] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.098550] pnp 00:0d: Plug and Play ACPI device, IDs INT0800 (active)
[    0.098727] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    0.098730] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.098808] system 00:0f: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.098811] system 00:0f: [mem 0xcf600000-0xcf6fffff] has been reserved
[    0.098813] system 00:0f: [mem 0xfed00000-0xfed000ff] has been reserved
[    0.098816] system 00:0f: [mem 0xcf590000-0xcf5fffff] could not be reserved
[    0.098818] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.098820] system 00:0f: [mem 0x00100000-0xcf58ffff] could not be reserved
[    0.098823] system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.098825] system 00:0f: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.098827] system 00:0f: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.098829] system 00:0f: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.098831] system 00:0f: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.098834] system 00:0f: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.098836] system 00:0f: [mem 0xfff00000-0xffffffff] has been reserved
[    0.098838] system 00:0f: [mem 0x000e0000-0x000effff] has been reserved
[    0.098841] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.098848] pnp: PnP ACPI: found 16 devices
[    0.098850] ACPI: ACPI bus type pnp unregistered
[    0.105257] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.105261] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.105266] pci 0000:00:1c.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.105269] pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.105278] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdc00000-0xfdc1ffff pref]
[    0.105280] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.105283] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.105287] pci 0000:00:1c.1:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.105291] pci 0000:00:1c.1:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.105296] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.105298] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.105303] pci 0000:00:1e.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    0.105306] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    0.105332] pci 0000:00:1e.0: setting latency timer to 64
[    0.105336] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.105338] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.105340] pci_bus 0000:00: resource 6 [mem 0xfed40000-0xfed44fff]
[    0.105342] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.105344] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.105345] pci_bus 0000:00: resource 9 [mem 0xcf600000-0xfebfffff]
[    0.105348] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.105349] pci_bus 0000:01: resource 1 [mem 0xfd800000-0xfd8fffff]
[    0.105351] pci_bus 0000:01: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.105353] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.105355] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.105357] pci_bus 0000:02: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.105359] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.105361] pci_bus 0000:03: resource 1 [mem 0xfda00000-0xfdafffff]
[    0.105363] pci_bus 0000:03: resource 2 [mem 0xfd900000-0xfd9fffff 64bit pref]
[    0.105365] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.105367] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.105369] pci_bus 0000:03: resource 6 [mem 0xfed40000-0xfed44fff]
[    0.105371] pci_bus 0000:03: resource 7 [mem 0x000a0000-0x000bffff]
[    0.105373] pci_bus 0000:03: resource 8 [mem 0x000c0000-0x000dffff]
[    0.105375] pci_bus 0000:03: resource 9 [mem 0xcf600000-0xfebfffff]
[    0.105414] NET: Registered protocol family 2
[    0.105598] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.105840] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.106029] TCP: Hash tables configured (established 32768 bind 32768)
[    0.106070] TCP: reno registered
[    0.106080] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.106106] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.106185] NET: Registered protocol family 1
[    0.106203] pci 0000:00:02.0: Boot video device
[    0.106327] PCI: CLS 64 bytes, default 64
[    0.106377] Unpacking initramfs...
[    0.202608] Freeing initrd memory: 5880k freed
[    0.205594] audit: initializing netlink socket (disabled)
[    0.205612] type=2000 audit(1358381141.204:1): initialized
[    0.221952] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.223406] VFS: Disk quotas dquot_6.5.2
[    0.223448] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.223848] msgmni has been set to 6497
[    0.223904] SELinux:  Registering netfilter hooks
[    0.224356] alg: No test for stdrng (krng)
[    0.224363] NET: Registered protocol family 38
[    0.224398] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.224423] io scheduler noop registered
[    0.224425] io scheduler deadline registered
[    0.224434] io scheduler cfq registered (default)
[    0.224555] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.224635] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.224701] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.224717] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.224719] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.224978] intel_idle: does not run on family 6 model 23
[    0.225046] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.225049] ACPI: Power Button [PWRB]
[    0.225090] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.225092] ACPI: Power Button [PWRF]
[    0.225129] ACPI: Fan [FAN] (on)
[    0.225250] ACPI: Requesting acpi_cpufreq
[    0.228787] thermal LNXTHERM:00: registered as thermal_zone0
[    0.228790] ACPI: Thermal Zone [THRM] (202 C)
[    0.228816] GHES: HEST is not enabled!
[    0.228884] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.249357] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.269866] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.270198] Non-volatile memory driver v1.3
[    0.270200] Linux agpgart interface v0.103
[    0.270250] agpgart-intel 0000:00:00.0: Intel G33 Chipset
[    0.270296] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    0.270749] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.270860] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.271562] loop: module loaded
[    0.271636] ata_piix 0000:00:1f.1: version 2.13
[    0.271675] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.271916] scsi0 : ata_piix
[    0.272163] scsi1 : ata_piix
[    0.272301] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    0.272303] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    0.272319] ata_piix 0000:00:1f.2: MAP [
[    0.272321]  P0 P2 P1 P3 ]
[    0.272347] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.272357] ata2: port disabled--ignoring
[    0.272642] scsi2 : ata_piix
[    0.272835] scsi3 : ata_piix
[    0.272999] ata3: SATA max UDMA/133 cmd 0xf900 ctl 0xf800 bmdma 0xf500 irq 19
[    0.273010] ata4: SATA max UDMA/133 cmd 0xf700 ctl 0xf600 bmdma 0xf508 irq 19
[    0.273068] libphy: Fixed MDIO Bus: probed
[    0.273192] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.273193] ehci-pci: EHCI PCI platform driver
[    0.273217] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    0.273221] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    0.273257] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.277153] ehci-pci 0000:00:1d.7: debug port 1
[    0.277160] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    0.277176] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfdfff000
[    0.283022] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.283052] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.283057] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.283061] usb usb1: Product: EHCI Host Controller
[    0.283065] usb usb1: Manufacturer: Linux 3.8.0-rc3 ehci_hcd
[    0.283068] usb usb1: SerialNumber: 0000:00:1d.7
[    0.283179] hub 1-0:1.0: USB hub found
[    0.283183] hub 1-0:1.0: 8 ports detected
[    0.283289] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.283300] uhci_hcd: USB Universal Host Controller Interface driver
[    0.283319] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.283322] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.283355] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.283376] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fe00
[    0.283407] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.283409] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.283411] usb usb2: Product: UHCI Host Controller
[    0.283413] usb usb2: Manufacturer: Linux 3.8.0-rc3 uhci_hcd
[    0.283415] usb usb2: SerialNumber: 0000:00:1d.0
[    0.283486] hub 2-0:1.0: USB hub found
[    0.283492] hub 2-0:1.0: 2 ports detected
[    0.283553] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.283556] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.283592] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.283611] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fd00
[    0.283637] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.283640] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.283642] usb usb3: Product: UHCI Host Controller
[    0.283643] usb usb3: Manufacturer: Linux 3.8.0-rc3 uhci_hcd
[    0.283645] usb usb3: SerialNumber: 0000:00:1d.1
[    0.283715] hub 3-0:1.0: USB hub found
[    0.283718] hub 3-0:1.0: 2 ports detected
[    0.283779] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.283782] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.283821] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.283850] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fc00
[    0.283877] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.283880] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.283882] usb usb4: Product: UHCI Host Controller
[    0.283884] usb usb4: Manufacturer: Linux 3.8.0-rc3 uhci_hcd
[    0.283886] usb usb4: SerialNumber: 0000:00:1d.2
[    0.283958] hub 4-0:1.0: USB hub found
[    0.283964] hub 4-0:1.0: 2 ports detected
[    0.284033] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.284036] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.284072] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.284101] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fb00
[    0.284126] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.284129] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.284131] usb usb5: Product: UHCI Host Controller
[    0.284132] usb usb5: Manufacturer: Linux 3.8.0-rc3 uhci_hcd
[    0.284134] usb usb5: SerialNumber: 0000:00:1d.3
[    0.284206] hub 5-0:1.0: USB hub found
[    0.284209] hub 5-0:1.0: 2 ports detected
[    0.284308] usbcore: registered new interface driver usbserial
[    0.284316] usbcore: registered new interface driver usbserial_generic
[    0.284322] usbserial: USB Serial support registered for generic
[    0.284355] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.284680] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.284709] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.284770] mousedev: PS/2 mouse device common for all mice
[    0.284910] rtc_cmos 00:03: RTC can wake from S4
[    0.285016] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.285037] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.285121] device-mapper: uevent: version 1.0.3
[    0.285181] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    0.285197] cpuidle: using governor ladder
[    0.285198] cpuidle: using governor menu
[    0.285437] EFI Variables Facility v0.08 2004-May-17
[    0.285524] usbcore: registered new interface driver usbhid
[    0.285526] usbhid: USB HID core driver
[    0.285549] drop_monitor: Initializing network drop monitor service
[    0.285621] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.285646] TCP: cubic registered
[    0.285648] Initializing XFRM netlink socket
[    0.285746] NET: Registered protocol family 10
[    0.285902] mip6: Mobile IPv6
[    0.285904] NET: Registered protocol family 17
[    0.286122] PM: Hibernation image not present or could not be loaded.
[    0.286131] registered taskstats version 1
[    0.286534]   Magic number: 13:753:51
[    0.286634] rtc_cmos 00:03: setting system clock to 2013-01-17 00:05:42 UTC (1358381142)
[    0.287166] zcache: using lzo compressor
[    0.287324] zcache: cleancache enabled using kernel transcendent memory and compression buddies
[    0.287327] zcache: cleancache: ignorenonactive = 1
[    0.287330] zcache: frontswap enabled using kernel transcendent memory and compression buddies
[    0.287333] zcache: frontswap: excl gets = 1 active only = 1
[    0.306912] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    0.424230] ata4.01: NODEV after polling detection
[    0.426255] ata3.00: ATA-8: WDC WD5000AAKS-00V1A0, 05.01D05, max UDMA/133
[    0.426260] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.426464] ata3.00: failed to get Identify Device Data, Emask 0x1
[    0.427178] ata4.00: ATAPI: Optiarc DVD RW AD-7280S, 1.01, max UDMA/100
[    0.432548] ata3.00: failed to get Identify Device Data, Emask 0x1
[    0.432554] ata3.00: configured for UDMA/133
[    0.434178] ata4.00: configured for UDMA/100
[    0.442522] ata1.00: ATA-6: ST3160021A, 8.01, max UDMA/100
[    0.442526] ata1.00: 312581808 sectors, multi 16: LBA48 
[    0.464433] ata1.00: configured for UDMA/100
[    0.464608] scsi 0:0:0:0: Direct-Access     ATA      ST3160021A       8.01 PQ: 0 ANSI: 5
[    0.464846] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    0.464899] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.464944] sd 0:0:0:0: [sda] Write Protect is off
[    0.464950] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.464992] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.465229] scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 05.0 PQ: 0 ANSI: 5
[    0.465492] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.465537] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    0.465612] sd 2:0:0:0: [sdb] Write Protect is off
[    0.465618] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.465659] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.466405] scsi 3:0:0:0: CD-ROM            Optiarc  DVD RW AD-7280S  1.01 PQ: 0 ANSI: 5
[    0.468386] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.468391] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.468544] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    0.468638] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    0.471274]  sda: sda1
[    0.471633] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.497609]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[    0.498232] sd 2:0:0:0: [sdb] Attached SCSI disk
[    0.501240] Freeing unused kernel memory: 1076k freed
[    0.501607] Write protecting the kernel read-only data: 12288k
[    0.507657] Freeing unused kernel memory: 1632k freed
[    0.511661] Freeing unused kernel memory: 1352k freed
[    0.579710] dracut: dracut-018-60.git20120927.fc16
[    0.623536] udevd[105]: starting version 173
[    0.666705] [drm] Initialized drm 1.1.0 20060810
[    0.678765] i915 0000:00:02.0: setting latency timer to 64
[    0.695339] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    0.695355] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.695357] [drm] Driver supports precise vblank timestamp query.
[    0.695400] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.696947] [drm] initialized overlay support
[    0.714558] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[    0.722722] fbcon: inteldrmfb (fb0) is primary device
[    0.773409] Console: switching to colour frame buffer device 160x64
[    0.780049] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    0.780054] i915 0000:00:02.0: registered panic notifier
[    0.780110] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.785402] dracut: Starting plymouth daemon
[    0.820316] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[    0.984976] Floppy drive(s): fd0 is 1.44M
[    1.001697] FDC 0 is a post-1991 82077
[    1.039755] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    1.208054] tsc: Refined TSC clocksource calibration: 2755.321 MHz
[    1.208062] Switching to clocksource tsc
[    1.394025] zcache: created ephemeral local tmem pool, id=0
[    1.394171] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    1.482596] zcache: destroyed local pool id=0
[    1.493547] dracut: Checking ext4: /dev/disk/by-uuid/4837c784-4583-4efc-8a40-260819368469
[    1.493834] dracut: issuing e2fsck -a  /dev/disk/by-uuid/4837c784-4583-4efc-8a40-260819368469
[    1.529752] dracut: /dev/disk/by-uuid/4837c784-4583-4efc-8a40-260819368469: clean, 446215/2621440 files, 3338187/10485760 blocks
[    1.530949] dracut: Remounting /dev/disk/by-uuid/4837c784-4583-4efc-8a40-260819368469 with -o relatime,ro
[    1.539175] zcache: created ephemeral local tmem pool, id=0
[    1.539256] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    1.587069] dracut: Mounted root filesystem /dev/sdb2
[    1.809138] dracut: Switching root
[    2.079647] type=1404 audit(1358381144.292:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    2.163734] SELinux: 2048 avtab hash slots, 99835 rules.
[    2.184719] SELinux: 2048 avtab hash slots, 99835 rules.
[    2.331538] SELinux:  9 users, 13 roles, 3978 types, 222 bools, 1 sens, 1024 cats
[    2.331543] SELinux:  82 classes, 99835 rules
[    2.335351] SELinux:  Permission wake_alarm in class capability2 not defined in policy.
[    2.335355] SELinux:  Permission block_suspend in class capability2 not defined in policy.
[    2.335359] SELinux: the above unknown classes and permissions will be allowed
[    2.335368] SELinux:  Completing initialization.
[    2.335369] SELinux:  Setting up existing superblocks.
[    2.335379] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.335384] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    2.335401] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    2.335406] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    2.335415] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.335434] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    2.335914] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    2.335918] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    2.337788] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    2.337796] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    2.337800] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    2.337816] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    2.337823] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    2.337829] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    2.337852] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.338669] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.338675] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.338700] SELinux: initialized (dev sdb2, type ext4), uses xattr
[    2.356016] type=1403 audit(1358381144.568:3): policy loaded auid=4294967295 ses=4294967295
[    2.381243] systemd[1]: Successfully loaded SELinux policy in 332ms 766us.
[    2.426078] systemd[1]: Successfully loaded SELinux database in 44ms 158us, size on heap is 489K.
[    2.453248] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.458076] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.509598] systemd[1]: Relabelled /dev and /run in 51ms 392us.
[    2.533072] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.538067] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543107] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.548043] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.553047] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.558043] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.563086] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.568035] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.568128] systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
[    2.590637] systemd[1]: Set hostname to <karlalex.palosanto.com>.
[    3.518556] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    4.009395] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.252305] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    4.264709] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    7.364670] RPC: Registered named UNIX socket transport module.
[    7.364674] RPC: Registered udp transport module.
[    7.364675] RPC: Registered tcp transport module.
[    7.364676] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.364941] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[    7.528304] udevd[413]: starting version 173
[   13.646078] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[   13.669373] zcache: created ephemeral local tmem pool, id=1
[   13.669384] EXT4-fs (sdb2): re-mounted. Opts: (null)
[   13.746094] intel_rng: FWH not detected
[   13.748430] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   13.748632] r8169 0000:02:00.0: irq 43 for MSI/MSI-X
[   13.748780] r8169 0000:02:00.0 eth0: RTL8168b/8111b at 0xffffc90000668000, 00:22:68:44:17:2f, XID 98500000 IRQ 43
[   13.748783] r8169 0000:02:00.0 eth0: jumbo features [frames: 4080 bytes, tx checksumming: ko]
[   13.771809] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   13.774272] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PM2S 1 (20121018/utaddress-251)
[   13.774279] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.774282] ACPI Warning: 0x00000000000004b0-0x00000000000004bf SystemIO conflicts with Region \GPO2 1 (20121018/utaddress-251)
[   13.774285] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.774287] ACPI Warning: 0x0000000000000480-0x00000000000004af SystemIO conflicts with Region \GPO_ 1 (20121018/utaddress-251)
[   13.774290] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.774291] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   13.781348] leds_ss4200: no LED devices found
[   13.795941] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   13.826058] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   13.845791] ALSA sound/pci/hda/patch_realtek.c:1241 SKU: Nid=0x1d sku_cfg=0x40038601
[   13.845795] ALSA sound/pci/hda/patch_realtek.c:1243 SKU: port_connectivity=0x1
[   13.845796] ALSA sound/pci/hda/patch_realtek.c:1244 SKU: enable_pcbeep=0x0
[   13.845798] ALSA sound/pci/hda/patch_realtek.c:1245 SKU: check_sum=0x00000003
[   13.845800] ALSA sound/pci/hda/patch_realtek.c:1246 SKU: customization=0x00000086
[   13.845801] ALSA sound/pci/hda/patch_realtek.c:1247 SKU: external_amp=0x0
[   13.845803] ALSA sound/pci/hda/patch_realtek.c:1248 SKU: platform_type=0x0
[   13.845804] ALSA sound/pci/hda/patch_realtek.c:1249 SKU: swap=0x0
[   13.845806] ALSA sound/pci/hda/patch_realtek.c:1250 SKU: override=0x1
[   13.845810] ALSA sound/pci/hda/hda_auto_parser.c:306 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   13.845812] ALSA sound/pci/hda/hda_auto_parser.c:310    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.845814] ALSA sound/pci/hda/hda_auto_parser.c:314    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   13.845816] ALSA sound/pci/hda/hda_auto_parser.c:315    mono: mono_out=0x0
[   13.845817] ALSA sound/pci/hda/hda_auto_parser.c:318    dig-out=0x1e/0x0
[   13.845819] ALSA sound/pci/hda/hda_auto_parser.c:319    inputs:
[   13.845821] ALSA sound/pci/hda/hda_auto_parser.c:323      Front Mic=0x19
[   13.845822] ALSA sound/pci/hda/hda_auto_parser.c:323      Rear Mic=0x18
[   13.845824] ALSA sound/pci/hda/hda_auto_parser.c:323      Line=0x1a
[   13.847623] ALSA sound/pci/hda/patch_realtek.c:1304 realtek: No valid SSID, checking pincfg 0x40038601 for NID 0x1d
[   13.847626] ALSA sound/pci/hda/patch_realtek.c:1320 realtek: Enabling init ASM_ID=0x8601 CODEC_ID=10ec0662
[   13.877145] parport_pc 00:09: reported by Plug and Play ACPI
[   13.877198] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   13.906955] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
[   13.908246] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[   13.908340] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   13.909072] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   13.909304] input: HDA Intel Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   13.924593] input: PC Speaker as /devices/platform/pcspkr/input/input9
[   13.940586] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
[   13.999004] microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
[   14.003041] microcode: CPU1 sig=0x10676, pf=0x1, revision=0x60c
[   14.004002] microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
[   14.007887] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.071304] iTCO_vendor_support: vendor-support=0
[   14.078238] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   14.078297] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
[   14.079862] ppdev: user-space parallel port driver
[   14.082408] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   14.115957] udev-configure-printer[697]: add /bus/pci/drivers/lpc_ich
[   14.116551] udev-configure-printer[697]: Failed to get parent
[   14.119261] udev-configure-printer[698]: add /module/lpc_ich
[   14.119622] udev-configure-printer[698]: Failed to get parent
[   14.194012] r8169 0000:02:00.0: vpd r/w failed.  This is likely a firmware bug on this device.  Contact the card vendor for a firmware update.
[   14.427757] zcache: created persistent local tmem pool, id=2
[   14.427763] Adding 8388604k swap on /dev/sdb3.  Priority:0 extents:1 across:8388604k FS
[   14.514668] systemd-fsck[719]: /dev/sdb1: limpio, 273/51200 ficheros, 61877/204800 bloques
[   14.733768] zcache: created ephemeral local tmem pool, id=3
[   14.733893] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[   14.774347] systemd-fsck[721]: /dev/sda1: limpio, 46106/9773056 ficheros, 38528833/39072080 bloques
[   14.874380] SELinux: initialized (dev sdb1, type ext4), uses xattr
[   14.971508] systemd-fsck[736]: /dev/sdb5: limpio, 691293/27369472 ficheros, 92180236/109460736 bloques
[   15.057196] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
[   15.085117] EXT4-fs (sdb5): mounting ext3 file system using the ext4 subsystem
[   15.094312] zcache: created ephemeral local tmem pool, id=4
[   15.095325] EXT4-fs (sdb5): mounted filesystem with ordered data mode. Opts: (null)
[   15.095338] SELinux: initialized (dev sdb5, type ext3), uses xattr
[   15.133145] fedora-storage-init[739]: Configurando gestor de vol\xffffffc3\xffffffba\xffffffbamenes l\xffffffc3\xffffffb3\xffffffb3gicos:   No volume groups found
[   15.135563] zcache: created ephemeral local tmem pool, id=5
[   15.135912] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   15.135922] SELinux: initialized (dev sda1, type ext3), uses xattr
[   15.143494] fedora-storage-init[739]: [  OK  ]
[   15.366381] fedora-storage-init[769]: Configurando gestor de vol\xffffffc3\xffffffba\xffffffbamenes l\xffffffc3\xffffffb3\xffffffb3gicos:   No volume groups found
[   15.377500] fedora-storage-init[769]: [  OK  ]
[   15.442598] lvm[775]: No volume groups found
[   15.520661] systemd-tmpfiles[778]: Successfully loaded SELinux database in 16ms 644us, size on heap is 490K.
[   15.730615] sandbox[787]: Starting sandbox[  OK  ]
[   15.759547] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   15.767373] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   15.775949] iptables.init[791]: iptables: Aplicando reglas del cortafuegos:[  OK  ]
[   15.777751] auditctl[803]: No rules
[   15.777758] auditctl[803]: AUDIT_STATUS: enabled=0 flag=1 pid=0 rate_limit=0 backlog_limit=320 lost=0 backlog=0
[   15.777920] ip6tables.init[788]: ip6tables: Aplicando las reglas del cortafuegos: [  OK  ]
[   15.786058] auditd[794]: Started dispatcher: /sbin/audispd pid: 836
[   15.786676] audispd[836]: priority_boost_parser called with: 4
[   15.786759] audispd[836]: max_restarts_parser called with: 10
[   15.788150] audispd[836]: audispd initialized with q_depth=120 and 1 active plugins
[   15.810311] /usr/sbin/gpm[843]: *** info [daemon/startup.c(136)]:
[   15.810324] /usr/sbin/gpm[843]: Started gpm successfully. Entered daemon mode.
[   15.826123] abrtd[842]: Init complete, entering main loop
[   15.855127] acpid[851]: starting up with netlink and the input layer
[   15.856176] acpid[851]: skipping incomplete file /etc/acpi/events/videoconf
[   15.856215] acpid[851]: 1 rule loaded
[   15.856316] acpid[851]: waiting for events: event logging is off
[   15.893683] it87: Found IT8718F chip at 0x290, revision 4
[   15.893703] it87: Beeping is supported
[   15.893741] ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \IP__ 1 (20121018/utaddress-251)
[   15.893751] ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \SIOR 2 (20121018/utaddress-251)
[   15.893758] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.895229] auditd[794]: Init complete, auditd 2.2.1 listening for events (startup state enable)
[   15.909812] NetworkManager[865]: <info> NetworkManager (version 0.9.4-6.git20120521.fc16) is starting...
[   15.909834] NetworkManager[865]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
[   15.909851] NetworkManager[865]: <info> WEXT support is enabled
[   15.989720] avahi-daemon[876]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
[   15.989920] avahi-daemon[876]: Successfully dropped root privileges.
[   15.994114] avahi-daemon[876]: avahi-daemon 0.6.30 starting up.
[   16.012757] avahi-daemon[876]: WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
[   16.041285] chronyd[882]: chronyd version 1.26-20110831gitb088b7 starting
[   16.041886] chronyd[882]: Linux kernel major=3 minor=8 patch=0
[   16.041916] chronyd[882]: hz=100 shift_hz=7 freq_scale=1.00000000 nominal_tick=10000 slew_delta_tick=833 max_tick_bias=1000
[   16.055950] chronyd[882]: Frequency 39.799 +- 4.309 ppm read from /var/lib/chrony/drift
[   16.165886] NetworkManager[865]: <info> VPN: loaded org.freedesktop.NetworkManager.openswan
[   16.166025] NetworkManager[865]: <info> VPN: loaded org.freedesktop.NetworkManager.vpnc
[   16.166104] NetworkManager[865]: <info> VPN: loaded org.freedesktop.NetworkManager.openconnect
[   16.166182] NetworkManager[865]: <info> VPN: loaded org.freedesktop.NetworkManager.openvpn
[   16.166260] NetworkManager[865]: <info> VPN: loaded org.freedesktop.NetworkManager.pptp
[   16.168570] avahi-daemon[876]: Successfully called chroot().
[   16.168578] avahi-daemon[876]: Successfully dropped remaining capabilities.
[   16.169056] avahi-daemon[876]: Loading service file /services/ssh.service.
[   16.169063] avahi-daemon[876]: Loading service file /services/udisks.service.
[   16.169614] avahi-daemon[876]: Network interface enumeration completed.
[   16.169620] avahi-daemon[876]: Registering HINFO record with values 'X86_64'/'LINUX'.
[   16.169624] avahi-daemon[876]: Server startup complete. Host name is karlalex.local. Local service cookie is 4094848086.
[   16.169629] avahi-daemon[876]: Service "karlalex" (/services/udisks.service) successfully established.
[   16.169632] avahi-daemon[876]: Service "karlalex" (/services/ssh.service) successfully established.
[   16.169720] systemd-logind[873]: New seat seat0.
[   16.185090] dbus-daemon[889]: dbus[889]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
[   16.185658] dbus[889]: [system] Activating service name='org.freedesktop.PolicyKit1' (using servicehelper)
[   16.202259] dkms_autoinstaller[898]: dkms: running auto installation service for kernel 3.8.0-rc3
[   16.242452] polkitd[900]: started daemon version 0.102 using authority implementation `local' version `0.102'
[   16.312570] r8169 0000:02:00.0 p17p1: link down
[   16.312577] r8169 0000:02:00.0 p17p1: link down
[   16.312673] IPv6: ADDRCONF(NETDEV_UP): p17p1: link is not ready
[   16.527383] Loading iSCSI transport class v2.0-870.
[   16.536463] iscsi: registered transport (tcp)
[   16.597776] vboxdrv: Found 2 processor cores.
[   16.614857] vboxdrv: fAsync=0 offMin=0x28a offMax=0xdb9
[   16.614946] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   16.614947] vboxdrv: Successfully loaded version 4.2.6 (interface 0x001a0004).
[   16.616240] iscsi: registered transport (iser)
[   16.629723] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[   16.629727] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
[   16.633655] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[   16.635207] iscsi: registered transport (cxgb3i)
[   16.652179] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
[   16.652526] iscsi: registered transport (cxgb4i)
[   16.668152] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
[   16.674378] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
[   16.674893] iscsi: registered transport (bnx2i)
[   16.687466] iscsi: registered transport (be2iscsi)
[   16.687470] In beiscsi_module_init, tt=ffffffffa047f000
[   16.792263] Bridge firewalling registered
[   16.800910] tun: Universal TUN/TAP device driver, 1.6
[   16.800913] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   16.807294] device virbr0-nic entered promiscuous mode
[   16.835752] vboxpci: IOMMU not found (not registered)
[   16.891178] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   16.909476] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   17.016907] IPv6: ADDRCONF(NETDEV_UP): virbr0: link is not ready
[   17.224322] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   17.237810] Ebtables v2.0 registered
[   17.361474] cgroup: libvirtd (1069) created nested cgroup for controller "memory" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   17.361477] cgroup: "memory" requires setting use_hierarchy to 1 on the root.
[   17.361542] cgroup: libvirtd (1069) created nested cgroup for controller "devices" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   17.361611] cgroup: libvirtd (1069) created nested cgroup for controller "blkio" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   17.948380] r8169 0000:02:00.0 p17p1: link up
[   17.948391] IPv6: ADDRCONF(NETDEV_CHANGE): p17p1: link becomes ready
[   17.969961] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   17.970171] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   17.985359] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   17.991955] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   18.302247] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   18.316126] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   18.333854] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   18.348020] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   18.365949] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   19.614224] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[   41.875184] fuse init (API version 7.20)
[   41.888975] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   42.024319] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   43.533444] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   43.648327] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   43.668905] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   43.684516] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   43.699843] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   43.731347] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   45.667180] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[   47.067280] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[  143.947166] [drm] Got built-in EDID base block and 0 extensions from "edid/1280x1024.bin" for connector "VGA-1"
[  447.708037] TCP: lp registered

--------------020003080607020802040204--
