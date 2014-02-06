Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaBFXlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:41:53 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54354 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaBFXlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:41:51 -0500
Message-ID: <52F41DB8.3080802@gmail.com>
Date: Fri, 07 Feb 2014 00:41:44 +0100
From: Bastien Traverse <bastien.traverse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Peter Wu <lekensteyn@gmail.com>
CC: linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
References: <52F2CC7B.80406@gmail.com> <5898085.IKVHQGKOYn@al> <55671594.HynIX0trOC@vostro.rjw.lan>
In-Reply-To: <55671594.HynIX0trOC@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/02/2014 00:28, Rafael J. Wysocki a écrit :
> Well, I suspected that it would result from hotplug changes.
> 
> Please send me a dmesg log including the suspend-resume cycle after which the
> device is missing.
> 
> Thanks!
> 
Sorry, I hadn't seen your messages before sending mine. Here is my dmesg
for the whole cycle, MAC address stripped too:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.9-2-ARCH
(nobody@var-lib-archbuild-extra-x86_64-thomas) (gcc version 4.8.2
20131219 (prerelease) (GCC) ) #1 SMP PREEMPT Fri Jan 31 10:22:54 CET 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-linux
root=/dev/mapper/os-archroot rw quiet
cryptdevice=/dev/sdb2:ssd:allow-discards
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d97d9fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d97da000-0x00000000d9f40fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000d9f41000-0x00000000d9fcbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d9fcc000-0x00000000da06afff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da06b000-0x00000000da560fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000da561000-0x00000000da561fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da562000-0x00000000da5a4fff]
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da5a5000-0x00000000dad41fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dad42000-0x00000000daff2fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000daff3000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: CLEVO CO.                        W54xEU
             /W54xEU                          , BIOS 4.6.5 08/02/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   5 base 21F000000 mask FFF000000 uncachable
[    0.000000]   6 base 21E800000 mask FFF800000 uncachable
[    0.000000]   7 base 21E600000 mask FFFE00000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd7f0-0x000fd7ff] mapped
at [ffff8800000fd7f0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01b32000, 0x01b32fff] PGTABLE
[    0.000000] BRK [0x01b33000, 0x01b33fff] PGTABLE
[    0.000000] BRK [0x01b34000, 0x01b34fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21e400000-0x21e5fffff]
[    0.000000]  [mem 0x21e400000-0x21e5fffff] page 2M
[    0.000000] BRK [0x01b35000, 0x01b35fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21e3fffff]
[    0.000000]  [mem 0x21c000000-0x21e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01b36000, 0x01b36fff] PGTABLE
[    0.000000] BRK [0x01b37000, 0x01b37fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xd97d9fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xd95fffff] page 2M
[    0.000000]  [mem 0xd9600000-0xd97d9fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd9f41000-0xd9fcbfff]
[    0.000000]  [mem 0xd9f41000-0xd9fcbfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda561000-0xda561fff]
[    0.000000]  [mem 0xda561000-0xda561fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda5a5000-0xdad41fff]
[    0.000000]  [mem 0xda5a5000-0xda5fffff] page 4k
[    0.000000]  [mem 0xda600000-0xdabfffff] page 2M
[    0.000000]  [mem 0xdac00000-0xdad41fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdaff3000-0xdaffffff]
[    0.000000]  [mem 0xdaff3000-0xdaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x3745a000-0x37a24fff]
[    0.000000] ACPI: RSDP 00000000000f0490 00024 (v02  Intel)
[    0.000000] ACPI: XSDT 00000000da05b078 00074 (v01  Intel    CHIEF
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000da064fb0 0010C (v05  Intel    CHIEF
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000da05b188 09E26 (v02  Intel    CHIEF
00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000da069080 00040
[    0.000000] ACPI: APIC 00000000da0650c0 00072 (v03  Intel    CHIEF
01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 00000000da065138 00044 (v01  Intel    CHIEF
01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000da065180 0003C (v01  Intel    CHIEF
01072009 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000da0651c0 00F92 (v01 TrmRef PtidDevc
00001000 INTL 20091112)
[    0.000000] ACPI: HPET 00000000da066158 00038 (v01  Intel    CHIEF
01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 00000000da066190 00382 (v01 SataRe SataTabl
00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000da066518 009AA (v01  PmRef  Cpu0Ist
00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000da066ec8 00A92 (v01  PmRef    CpuPm
00003000 INTL 20051117)
[    0.000000] ACPI: ASF! 00000000da067960 000A5 (v32 INTEL       HCG
00000001 TFSM 000F4240)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21e5fffff]
[    0.000000]   NODE_DATA [mem 0x21e5f0000-0x21e5f4fff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD ->
[ffff880215c00000-ffff88021dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd97d9fff]
[    0.000000]   node   0: [mem 0xd9f41000-0xd9fcbfff]
[    0.000000]   node   0: [mem 0xda561000-0xda561fff]
[    0.000000]   node   0: [mem 0xda5a5000-0xdad41fff]
[    0.000000]   node   0: [mem 0xdaff3000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21e5fffff]
[    0.000000] On node 0 totalpages: 2065323
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13881 pages used for memmap
[    0.000000]   DMA32 zone: 888335 pages, LIFO batch:31
[    0.000000]   Normal zone: 18328 pages used for memmap
[    0.000000]   Normal zone: 1172992 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd97da000-0xd9f40fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd9fcc000-0xda06afff]
[    0.000000] PM: Registered nosave memory: [mem 0xda06b000-0xda560fff]
[    0.000000] PM: Registered nosave memory: [mem 0xda562000-0xda5a4fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdad42000-0xdaff2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdb7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128
nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88021e200000 s86464
r8192 d24128 u524288
[    0.000000] pcpu-alloc: s86464 r8192 d24128 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 2033029
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-linux
root=/dev/mapper/os-archroot rw quiet
cryptdevice=/dev/sdb2:ssd:allow-discards
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8045884K/8261292K available (5119K kernel code,
807K rwdata, 1628K rodata, 1144K init, 1288K bss, 215408K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:8448 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 2594.199 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using
timer frequency.. 5190.58 BogoMIPS (lpj=8647330)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000027] Security Framework initialized
[    0.000034] AppArmor: AppArmor disabled by boot time parameter
[    0.000035] Yama: becoming mindful.
[    0.000516] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.002418] Inode-cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.003251] Mount-cache hash table entries: 256
[    0.003404] Initializing cgroup subsys memory
[    0.003412] Initializing cgroup subsys devices
[    0.003414] Initializing cgroup subsys freezer
[    0.003416] Initializing cgroup subsys net_cls
[    0.003417] Initializing cgroup subsys blkio
[    0.003436] CPU: Physical Processor ID: 0
[    0.003437] CPU: Processor Core ID: 0
[    0.003442] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.003804] mce: CPU supports 7 MCE banks
[    0.003813] CPU0: Thermal monitoring enabled (TM1)
[    0.003821] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
[    0.003923] Freeing SMP alternatives memory: 20K (ffffffff819e9000 -
ffffffff819ee000)
[    0.004827] ACPI: Core revision 20130725
[    0.009214] ACPI: All ACPI Tables successfully acquired
[    0.021919] ftrace: allocating 20320 entries in 80 pages
[    0.031168] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064196] smpboot: CPU0: Intel(R) Core(TM) i5-3230M CPU @ 2.60GHz
(fam: 06, model: 3a, stepping: 09)
[    0.064202] TSC deadline timer enabled
[    0.064210] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge
events, full-width counters, Intel PMU driver.
[    0.064216] ... version:                3
[    0.064217] ... bit width:              48
[    0.064218] ... generic registers:      4
[    0.064219] ... value mask:             0000ffffffffffff
[    0.064220] ... max period:             0000ffffffffffff
[    0.064220] ... fixed-purpose events:   3
[    0.064221] ... event mask:             000000070000000f
[    0.104582] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.090995] smpboot: Booting Node   0, Processors  #   1 #   2 #   3 OK
[    0.145121] Brought up 4 CPUs
[    0.145125] smpboot: Total of 4 processors activated (20761.32 BogoMIPS)
[    0.148200] devtmpfs: initialized
[    0.150647] PM: Registering ACPI NVS region [mem
0xd9fcc000-0xda06afff] (651264 bytes)
[    0.150657] PM: Registering ACPI NVS region [mem
0xda562000-0xda5a4fff] (274432 bytes)
[    0.151357] RTC time: 23:17:07, date: 02/06/14
[    0.151389] NET: Registered protocol family 16
[    0.151473] cpuidle: using governor ladder
[    0.151474] cpuidle: using governor menu
[    0.151497] ACPI FADT declares the system doesn't support PCIe ASPM,
so disable it
[    0.151499] ACPI: bus type PCI registered
[    0.151500] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.151545] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.151547] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.158227] PCI: Using configuration type 1 for base access
[    0.158746] bio: create slab <bio-0> at 0
[    0.158834] ACPI: Added _OSI(Module Device)
[    0.158835] ACPI: Added _OSI(Processor Device)
[    0.158836] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.158837] ACPI: Added _OSI(Processor Aggregator Device)
[    0.159932] ACPI: EC: Look up EC in DSDT
[    0.160997] ACPI: Executed 1 blocks of module-level executable AML code
[    0.171881] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.172219] ACPI: SSDT 00000000d9eee018 0083B (v01  PmRef  Cpu0Cst
00003001 INTL 20051117)
[    0.172499] ACPI: Dynamic OEM Table Load:
[    0.172501] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst
00003001 INTL 20051117)
[    0.184947] ACPI: SSDT 00000000d9eefa98 00303 (v01  PmRef    ApIst
00003000 INTL 20051117)
[    0.185253] ACPI: Dynamic OEM Table Load:
[    0.185255] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst
00003000 INTL 20051117)
[    0.195277] ACPI: SSDT 00000000d9ef0c18 00119 (v01  PmRef    ApCst
00003000 INTL 20051117)
[    0.195551] ACPI: Dynamic OEM Table Load:
[    0.195553] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst
00003000 INTL 20051117)
[    0.612156] ACPI: Interpreter enabled
[    0.612163] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20130725/hwxface-571)
[    0.612167] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20130725/hwxface-571)
[    0.612179] ACPI: (supports S0 S3 S4 S5)
[    0.612180] ACPI: Using IOAPIC for interrupt routing
[    0.612205] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.612804] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    0.621014] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.621222] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.621434] acpi PNP0A08:00: ACPI _OSC control (0x18) granted
[    0.621928] PCI host bridge to bus 0000:00
[    0.621931] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.621932] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.621934] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.621936] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff]
[    0.621937] pci_bus 0000:00: root bus resource [mem
0x000d0000-0x000d3fff]
[    0.621938] pci_bus 0000:00: root bus resource [mem
0x000d4000-0x000d7fff]
[    0.621940] pci_bus 0000:00: root bus resource [mem
0x000d8000-0x000dbfff]
[    0.621941] pci_bus 0000:00: root bus resource [mem
0x000dc000-0x000dffff]
[    0.621942] pci_bus 0000:00: root bus resource [mem
0x000e0000-0x000e3fff]
[    0.621944] pci_bus 0000:00: root bus resource [mem
0x000e4000-0x000e7fff]
[    0.621945] pci_bus 0000:00: root bus resource [mem
0xdfa00000-0xfeafffff]
[    0.621952] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.622024] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.622034] pci 0000:00:02.0: reg 0x10: [mem 0xf6400000-0xf67fffff 64bit]
[    0.622040] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff
64bit pref]
[    0.622044] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.622133] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.622155] pci 0000:00:14.0: reg 0x10: [mem 0xf7d00000-0xf7d0ffff 64bit]
[    0.622224] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.622261] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.622293] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.622315] pci 0000:00:16.0: reg 0x10: [mem 0xf7d1b000-0xf7d1b00f 64bit]
[    0.622389] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.622463] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.622483] pci 0000:00:1a.0: reg 0x10: [mem 0xf7d18000-0xf7d183ff]
[    0.622571] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.622621] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.622652] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.622666] pci 0000:00:1b.0: reg 0x10: [mem 0xf7d10000-0xf7d13fff 64bit]
[    0.622732] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.622771] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.622799] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.622874] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.622917] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.622946] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.623022] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.623062] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.623091] pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
[    0.623166] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.623207] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.623239] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.623367] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.623417] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.623451] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.623471] pci 0000:00:1d.0: reg 0x10: [mem 0xf7d17000-0xf7d173ff]
[    0.623558] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.623607] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.623638] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
[    0.623796] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.623813] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.623820] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.623827] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.623834] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.623841] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.623848] pci 0000:00:1f.2: reg 0x24: [mem 0xf7d16000-0xf7d167ff]
[    0.623891] pci 0000:00:1f.2: PME# supported from D3hot
[    0.623950] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.623964] pci 0000:00:1f.3: reg 0x10: [mem 0xf7d15000-0xf7d150ff 64bit]
[    0.623984] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.624107] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.624228] pci 0000:02:00.0: [8086:0887] type 00 class 0x028000
[    0.624265] pci 0000:02:00.0: reg 0x10: [mem 0xf7c00000-0xf7c01fff 64bit]
[    0.624446] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.624483] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.632144] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.632163] pci 0000:00:1c.2:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.632339] pci 0000:03:00.0: [10ec:5289] type 00 class 0xff0000
[    0.632402] pci 0000:03:00.0: reg 0x10: [mem 0xf7200000-0xf720ffff]
[    0.632916] pci 0000:03:00.0: supports D1 D2
[    0.632917] pci 0000:03:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.633016] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.633116] pci 0000:03:00.2: [10ec:8168] type 00 class 0x020000
[    0.633178] pci 0000:03:00.2: reg 0x10: [io  0xe000-0xe0ff]
[    0.633289] pci 0000:03:00.2: reg 0x18: [mem 0xf0a04000-0xf0a04fff
64bit pref]
[    0.633357] pci 0000:03:00.2: reg 0x20: [mem 0xf0a00000-0xf0a03fff
64bit pref]
[    0.633659] pci 0000:03:00.2: supports D1 D2
[    0.633660] pci 0000:03:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.633792] pci 0000:03:00.2: System wakeup disabled by ACPI
[    0.642192] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.642196] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.642199] pci 0000:00:1c.3:   bridge window [mem 0xf7200000-0xf7bfffff]
[    0.642205] pci 0000:00:1c.3:   bridge window [mem
0xf0a00000-0xf13fffff 64bit pref]
[    0.642299] acpiphp: Slot [1] registered
[    0.642305] pci 0000:00:1c.4: PCI bridge to [bus 04-06]
[    0.642309] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.642313] pci 0000:00:1c.4:   bridge window [mem 0xf6800000-0xf71fffff]
[    0.642321] pci 0000:00:1c.4:   bridge window [mem
0xf0000000-0xf09fffff 64bit pref]
[    0.642374] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is
unsupported)
[    0.643273] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12
14 15)
[    0.643317] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14
15) *0, disabled.
[    0.643359] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12
14 15)
[    0.643400] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12
14 15)
[    0.643443] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14
15) *0, disabled.
[    0.643484] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14
15) *0, disabled.
[    0.643526] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12
14 15)
[    0.643566] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 10 11 12
14 15)
[    0.644095] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.644100] ACPI: \_SB_.PCI0: notify handler is installed
[    0.644144] Found 1 acpi root devices
[    0.644172] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.644240] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.644243] vgaarb: loaded
[    0.644244] vgaarb: bridge control possible 0000:00:02.0
[    0.644272] PCI: Using ACPI for IRQ routing
[    0.645783] PCI: pci_cache_line_size set to 64 bytes
[    0.645832] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.645833] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.645835] e820: reserve RAM buffer [mem 0xd97da000-0xdbffffff]
[    0.645836] e820: reserve RAM buffer [mem 0xd9fcc000-0xdbffffff]
[    0.645838] e820: reserve RAM buffer [mem 0xda562000-0xdbffffff]
[    0.645839] e820: reserve RAM buffer [mem 0xdad42000-0xdbffffff]
[    0.645841] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.645842] e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
[    0.645913] NetLabel: Initializing
[    0.645914] NetLabel:  domain hash size = 128
[    0.645915] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.645924] NetLabel:  unlabeled traffic allowed by default
[    0.645942] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.645946] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.647965] Switched to clocksource hpet
[    0.651312] pnp: PnP ACPI init
[    0.651325] ACPI: bus type PNP registered
[    0.651394] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.651397] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.651418] pnp 00:01: [dma 4]
[    0.651432] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.651448] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.651519] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.651550] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.651552] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.651554] system 00:04: [io  0xffff] has been reserved
[    0.651555] system 00:04: [io  0xffff] has been reserved
[    0.651557] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.651559] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.651560] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.651562] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.651564] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.651589] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.651625] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.651627] system 00:06: Plug and Play ACPI device, IDs INT3f0d
PNP0c02 (active)
[    0.651648] pnp 00:07: Plug and Play ACPI device, IDs MSF0303 PNP0303
(active)
[    0.651681] pnp 00:08: Plug and Play ACPI device, IDs MSF0f13 PNP0f13
(active)
[    0.651739] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.651741] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.651761] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.652414] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.652418] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.652419] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.652421] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.652423] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.652424] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.652426] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.652427] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.652429] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.652431] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be
reserved
[    0.652432] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.652434] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.652566] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.652568] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.652570] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.652934] pnp: PnP ACPI: found 13 devices
[    0.652935] ACPI: bus type PNP unregistered
[    0.658946] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.658957] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.658962] pci 0000:00:1c.2:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.658970] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.658972] pci 0000:00:1c.3:   bridge window [io  0xe000-0xefff]
[    0.658976] pci 0000:00:1c.3:   bridge window [mem 0xf7200000-0xf7bfffff]
[    0.658980] pci 0000:00:1c.3:   bridge window [mem
0xf0a00000-0xf13fffff 64bit pref]
[    0.658986] pci 0000:00:1c.4: PCI bridge to [bus 04-06]
[    0.658988] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.658994] pci 0000:00:1c.4:   bridge window [mem 0xf6800000-0xf71fffff]
[    0.658999] pci 0000:00:1c.4:   bridge window [mem
0xf0000000-0xf09fffff 64bit pref]
[    0.659007] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.659008] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.659010] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.659011] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.659013] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.659014] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.659016] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.659017] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.659019] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.659020] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.659022] pci_bus 0000:02: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.659023] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.659025] pci_bus 0000:03: resource 1 [mem 0xf7200000-0xf7bfffff]
[    0.659026] pci_bus 0000:03: resource 2 [mem 0xf0a00000-0xf13fffff
64bit pref]
[    0.659028] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.659029] pci_bus 0000:04: resource 1 [mem 0xf6800000-0xf71fffff]
[    0.659031] pci_bus 0000:04: resource 2 [mem 0xf0000000-0xf09fffff
64bit pref]
[    0.659058] NET: Registered protocol family 2
[    0.659230] TCP established hash table entries: 65536 (order: 8,
1048576 bytes)
[    0.659406] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.659533] TCP: Hash tables configured (established 65536 bind 65536)
[    0.659549] TCP: reno registered
[    0.659559] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.659585] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.659642] NET: Registered protocol family 1
[    0.659652] pci 0000:00:02.0: Boot video device
[    0.660040] PCI: CLS 64 bytes, default 64
[    0.660077] Unpacking initramfs...
[    0.750752] Freeing initrd memory: 5932K (ffff88003745a000 -
ffff880037a25000)
[    0.750758] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.750760] software IO TLB [mem 0xd57da000-0xd97da000] (64MB) mapped
at [ffff8800d57da000-ffff8800d97d9fff]
[    0.750950] Scanning for low memory corruption every 60 seconds
[    0.751162] audit: initializing netlink socket (disabled)
[    0.751172] type=2000 audit(1391728626.736:1): initialized
[    0.762088] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.763145] zbud: loaded
[    0.763285] VFS: Disk quotas dquot_6.5.2
[    0.763315] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.763443] msgmni has been set to 15726
[    0.763665] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 252)
[    0.763700] io scheduler noop registered
[    0.763701] io scheduler deadline registered
[    0.763721] io scheduler cfq registered (default)
[    0.764189] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.764201] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.764236] vesafb: mode is 1366x768x32, linelength=5504, pages=0
[    0.764237] vesafb: scrolling: redraw
[    0.764239] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.764704] vesafb: framebuffer at 0xe0000000, mapped to
0xffffc90004f00000, using 4160k, total 4160k
[    0.830546] Console: switching to colour frame buffer device 170x48
[    0.896123] fb0: VESA VGA frame buffer device
[    0.896133] intel_idle: MWAIT substates: 0x21120
[    0.896134] intel_idle: v0.4 model 0x3A
[    0.896135] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.896240] GHES: HEST is not enabled!
[    0.896280] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.896622] Linux agpgart interface v0.103
[    0.896677] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M]
at 0x60,0x64 irq 1,12
[    0.899893] i8042: Detected active multiplexing controller, rev 1.1
[    0.901531] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.901551] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.901566] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.901578] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.901592] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.901661] mousedev: PS/2 mouse device common for all mice
[    0.901822] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.901854] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes
nvram, hpet irqs
[    0.901861] Intel P-state driver initializing.
[    0.901870] Intel pstate controlling: cpu 0
[    0.901885] Intel pstate controlling: cpu 1
[    0.901893] Intel pstate controlling: cpu 2
[    0.901901] Intel pstate controlling: cpu 3
[    0.901964] drop_monitor: Initializing network drop monitor service
[    0.902019] TCP: cubic registered
[    0.902096] NET: Registered protocol family 10
[    0.902233] NET: Registered protocol family 17
[    0.902240] Key type dns_resolver registered
[    0.902426] registered taskstats version 1
[    0.902957]   Magic number: 2:585:301
[    0.902966] tty tty30: hash matches
[    0.903045] rtc_cmos 00:05: setting system clock to 2014-02-06
23:17:07 UTC (1391728627)
[    0.903091] PM: Hibernation image not present or could not be loaded.
[    0.903563] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    0.903961] Freeing unused kernel memory: 1144K (ffffffff818cb000 -
ffffffff819e9000)
[    0.903962] Write protecting the kernel read-only data: 8192k
[    0.906056] Freeing unused kernel memory: 1012K (ffff880001503000 -
ffff880001600000)
[    0.906903] Freeing unused kernel memory: 420K (ffff880001797000 -
ffff880001800000)
[    0.913879] systemd-udevd[57]: starting version 208
[    0.918821] [drm] Initialized drm 1.1.0 20060810
[    0.919621] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.919627] ACPI: Power Button [PWRB]
[    0.919708] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    0.919712] ACPI: Sleep Button [SLPB]
[    0.919762] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
[    0.924458] ACPI: Lid Switch [LID0]
[    0.924515] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    0.924519] ACPI: Power Button [PWRF]
[    0.927902] [drm] Memory usable by graphics device = 2048M
[    0.927906] checking generic (e0000000 410000) vs hw (e0000000 10000000)
[    0.927907] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
removing generic driver
[    0.927936] Console: switching to colour dummy device 80x25
[    0.928029] i915 0000:00:02.0: setting latency timer to 64
[    0.955976] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.955984] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.955985] [drm] Driver supports precise vblank timestamp query.
[    0.956026] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.997425] fbcon: inteldrmfb (fb0) is primary device
[    1.752112] tsc: Refined TSC clocksource calibration: 2594.107 MHz
[    2.035676] Console: switching to colour frame buffer device 170x48
[    2.039914] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.039917] i915 0000:00:02.0: registered panic notifier
[    2.047377] acpi device:44: registered as cooling_device0
[    2.047459] ACPI: Video Device [GFX0] (multi-head: yes  rom: no
post: no)
[    2.047666] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input11
[    2.047751] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on
minor 0
[    2.079687] ACPI: bus type USB registered
[    2.079731] usbcore: registered new interface driver usbfs
[    2.079751] usbcore: registered new interface driver hub
[    2.079808] usbcore: registered new device driver usb
[    2.081940] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    2.081946] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.081956] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 1
[    2.082064] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.082088] xhci_hcd 0000:00:14.0: irq 41 for MSI/MSI-X
[    2.082211] SCSI subsystem initialized
[    2.082533] hub 1-0:1.0: USB hub found
[    2.082546] hub 1-0:1.0: 4 ports detected
[    2.083921] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.084385] ehci-pci: EHCI PCI platform driver
[    2.084617] libata version 3.00 loaded.
[    2.084827] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.084834] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
bus number 2
[    2.084994] hub 2-0:1.0: USB hub found
[    2.085004] hub 2-0:1.0: 4 ports detected
[    2.092508] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    2.092523] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.092532] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    2.092548] ehci-pci 0000:00:1a.0: debug port 2
[    2.096449] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    2.096472] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7d18000
[    2.105605] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.105778] hub 3-0:1.0: USB hub found
[    2.105790] hub 3-0:1.0: 2 ports detected
[    2.105975] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    2.105981] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.105985] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 4
[    2.105997] ehci-pci 0000:00:1d.0: debug port 2
[    2.109882] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    2.109897] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7d17000
[    2.118954] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.119131] hub 4-0:1.0: USB hub found
[    2.119140] hub 4-0:1.0: 2 ports detected
[    2.119245] ahci 0000:00:1f.2: version 3.0
[    2.119375] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    2.132338] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
0x15 impl SATA mode
[    2.132342] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum
part ems apst
[    2.132345] ahci 0000:00:1f.2: setting latency timer to 64
[    2.146876] scsi0 : ahci
[    2.147033] scsi1 : ahci
[    2.147156] scsi2 : ahci
[    2.147257] scsi3 : ahci
[    2.147361] scsi4 : ahci
[    2.147461] scsi5 : ahci
[    2.147512] ata1: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16100 irq 42
[    2.147515] ata2: DUMMY
[    2.147517] ata3: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16200 irq 42
[    2.147520] ata4: DUMMY
[    2.147522] ata5: SATA max UDMA/133 abar m2048@0xf7d16000 port
0xf7d16300 irq 42
[    2.147524] ata6: DUMMY
[    2.359429] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp on
[    2.415895] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    2.465895] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.465944] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.465977] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.466455] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[    2.466461] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    2.466465] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    2.466757] ata5.00: supports DRM functions and may not be fully
accessible
[    2.469721] ata5.00: ATA-9: Crucial_CT120M500SSD3, MU03, max UDMA/133
[    2.469726] ata5.00: 234441648 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.472513] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[    2.472522] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    2.472528] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    2.473611] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[    2.473617] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    2.473621] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    2.473913] ata5.00: supports DRM functions and may not be fully
accessible
[    2.477722] ata3.00: ATAPI: TSSTcorp CDDVDW TS-U633J, TM00, max UDMA/100
[    2.478960] ata1.00: ATA-8: ST1000LM024 HN-M101MBB, 2AR10002, max
UDMA/133
[    2.478965] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.480196] ata5.00: configured for UDMA/133
[    2.485617] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[    2.485624] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[    2.485627] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    2.488129] ata3.00: configured for UDMA/100
[    2.492062] ata1.00: configured for UDMA/133
[    2.492341] scsi 0:0:0:0: Direct-Access     ATA      ST1000LM024 HN-M
2AR1 PQ: 0 ANSI: 5
[    2.494846] scsi 2:0:0:0: CD-ROM            TSSTcorp CDDVDW TS-U633J
 TM00 PQ: 0 ANSI: 5
[    2.495175] scsi 4:0:0:0: Direct-Access     ATA      Crucial_CT120M50
MU03 PQ: 0 ANSI: 5
[    2.499850] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    2.499857] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.499936] sd 0:0:0:0: [sda] Write Protect is off
[    2.499941] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.499968] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.500249] sd 4:0:0:0: [sdb] 234441648 512-byte logical blocks: (120
GB/111 GiB)
[    2.500255] sd 4:0:0:0: [sdb] 4096-byte physical blocks
[    2.500342] sd 4:0:0:0: [sdb] Write Protect is off
[    2.500345] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.500364] sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.500811]  sdb: sdb1 sdb2
[    2.501116] sd 4:0:0:0: [sdb] Attached SCSI disk
[    2.504069] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    2.504073] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.504291] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.527655]  sda: sda1
[    2.528416] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.539874] hub 3-1:1.0: USB hub found
[    2.539941] hub 3-1:1.0: 6 ports detected
[    2.646019] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    2.663543] device-mapper: uevent: version 1.0.3
[    2.663684] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15)
initialised: dm-devel@redhat.com
[    2.668933] bio: create slab <bio-1> at 1
[    2.752865] Switched to clocksource tsc
[    2.770027] hub 4-1:1.0: USB hub found
[    2.770103] hub 4-1:1.0: 8 ports detected
[    7.372994] EXT4-fs (dm-3): mounted filesystem with ordered data
mode. Opts: (null)
[    7.440187] systemd[1]: systemd 208 running in system mode. (+PAM
-LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    7.440628] systemd[1]: Set hostname to <arch-clevo>.
[    7.491836] systemd[1]: Starting Login Prompts.
[    7.491851] systemd[1]: Reached target Login Prompts.
[    7.491861] systemd[1]: Starting Forward Password Requests to Wall
Directory Watch.
[    7.491911] systemd[1]: Started Forward Password Requests to Wall
Directory Watch.
[    7.491920] systemd[1]: Starting Remote File Systems.
[    7.491929] systemd[1]: Reached target Remote File Systems.
[    7.491936] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    7.491957] systemd[1]: Listening on /dev/initctl Compatibility Named
Pipe.
[    7.491964] systemd[1]: Starting LVM2 metadata daemon socket.
[    7.491986] systemd[1]: Listening on LVM2 metadata daemon socket.
[    7.491994] systemd[1]: Starting Device-mapper event daemon FIFOs.
[    7.492011] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    7.492018] systemd[1]: Starting Delayed Shutdown Socket.
[    7.492034] systemd[1]: Listening on Delayed Shutdown Socket.
[    7.492058] systemd[1]: Starting Arbitrary Executable File Formats
File System Automount Point.
[    7.492136] systemd[1]: Set up automount Arbitrary Executable File
Formats File System Automount Point.
[    7.492147] systemd[1]: Starting Dispatch Password Requests to
Console Directory Watch.
[    7.492172] systemd[1]: Started Dispatch Password Requests to Console
Directory Watch.
[    7.492181] systemd[1]: Starting Journal Socket.
[    7.492215] systemd[1]: Listening on Journal Socket.
[    7.493444] systemd[1]: Starting Create list of required static
device nodes for the current kernel...
[    7.494616] systemd[1]: Starting Apply Kernel Variables...
[    7.494893] systemd[1]: Starting Journal Service...
[    7.495223] systemd[1]: Started Journal Service.
[    7.507880] systemd-journald[230]: Vacuuming done, freed 0 bytes
[    7.556327] EXT4-fs (dm-3): re-mounted. Opts: (null)
[    7.575151] systemd-udevd[258]: starting version 208
[    7.627044] ACPI: Requesting acpi_cpufreq
[    7.627600] ACPI Warning: 0x000000000000f040-0x000000000000f05f
SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1
(20130725/utaddress-251)
[    7.627606] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    7.628481] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.629623] ACPI Warning: 0x0000000000000428-0x000000000000042f
SystemIO conflicts with Region \PMIO 1 (20130725/utaddress-251)
[    7.629630] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    7.629634] ACPI Warning: 0x0000000000000530-0x000000000000053f
SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    7.629637] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    7.629639] ACPI Warning: 0x0000000000000500-0x000000000000052f
SystemIO conflicts with Region \GPIO 1 (20130725/utaddress-251)
[    7.629642] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    7.629644] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    7.641745] ACPI: Battery Slot [BAT0] (battery present)
[    7.642657] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    7.645179] ACPI: AC Adapter [AC] (on-line)
[    7.652438] wmi: Mapper loaded
[    7.655627] thermal LNXTHERM:00: registered as thermal_zone0
[    7.655631] ACPI: Thermal Zone [TZ0] (52 C)
[    7.661795] pcieport 0000:00:1c.3: driver skip pci_set_master, fix it!
[    7.661910] rtsx_pci 0000:03:00.0: irq 44 for MSI/MSI-X
[    7.661925] rtsx_pci 0000:03:00.0: rtsx_pci_acquire_irq: pcr->msi_en
= 1, pci->irq = 44
[    7.662445] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.662454] r8169 0000:03:00.2: can't disable ASPM; OS doesn't have
ASPM control
[    7.662676] r8169 0000:03:00.2: irq 45 for MSI/MSI-X
[    7.666876] r8169 0000:03:00.2 eth0: RTL8411 at 0xffffc9001627e000,
00:90:f5:d7:34:53, XID 08800800 IRQ 45
[    7.666881] r8169 0000:03:00.2 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[    7.669180] input: HDA Intel PCH HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[    7.669409] cfg80211: Calling CRDA to update world regulatory domain
[    7.669574] input: HDA Intel PCH Front Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[    7.669636] input: HDA Intel PCH Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    7.673505] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    7.673508] Copyright(c) 2003-2013 Intel Corporation
[    7.673551] pcieport 0000:00:1c.2: driver skip pci_set_master, fix it!
[    7.673618] iwlwifi 0000:02:00.0: can't disable ASPM; OS doesn't have
ASPM control
[    7.673685] iwlwifi 0000:02:00.0: irq 46 for MSI/MSI-X
[    7.675011] input: PC Speaker as /devices/platform/pcspkr/input/input15
[    7.678683] iwlwifi 0000:02:00.0: loaded firmware version 18.168.6.1
op_mode iwldvm
[    7.684537] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x19
[    7.697208] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    7.697212] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    7.697214] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[    7.697216] iwlwifi 0000:02:00.0: Detected Intel(R) Centrino(R)
Wireless-N 2230 BGN, REV=0xC8
[    7.697273] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[    7.718722] iTCO_vendor_support: vendor-support=0
[    7.719479] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    7.719515] iTCO_wdt: Found a Panther Point TCO device (Version=2,
TCOBASE=0x0460)
[    7.719751] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.723313] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.753481] ACPI Error: [_T_0] Namespace lookup failure,
AE_ALREADY_EXISTS (20130725/dswload2-330)
[    7.753489] ACPI Exception: AE_ALREADY_EXISTS, During name
lookup/catalog (20130725/psobject-222)
[    7.753492] ACPI Error: Method parse/execution failed
[\_SB_.AC__.ADJP] (Node ffff88021286d820), AE_ALREADY_EXISTS
(20130725/psparse-536)
[    7.753499] ACPI Error: Method parse/execution failed
[\_SB_.AC__._PSR] (Node ffff88021286d7d0), AE_ALREADY_EXISTS
(20130725/psparse-536)
[    7.753505] ACPI Exception: AE_ALREADY_EXISTS, Error reading AC
Adapter state (20130725/ac-126)
[    7.754229] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x19
[    7.754569] ACPI: Marking method ADJP as Serialized because of
AE_ALREADY_EXISTS error
[    7.762753] systemd-udevd[276]: renamed network interface eth0 to
enp3s0f2
[    7.768405] ACPI: Marking method _PSR as Serialized because of
AE_ALREADY_EXISTS error
[    7.776670] systemd-udevd[274]: renamed network interface wlan0 to wlp2s0
[    7.780458] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x19
[    7.789063] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x19
[    7.789705] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.792720] EXT4-fs (dm-4): mounted filesystem with ordered data
mode. Opts: (null)
[    7.882746] EXT4-fs (dm-0): mounted filesystem with ordered data
mode. Opts: (null)
[    8.004927] Non-volatile memory driver v1.3
[    8.962045] psmouse serio2: synaptics: Touchpad model: 1, fw: 7.2,
id: 0x1c0b1, caps: 0xd04733/0xa40000/0xa0000, board id: 3655, fw id: 582762
[    8.995988] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio2/input/input17
[    9.817436] EXT4-fs (dm-8): mounted filesystem with ordered data
mode. Opts: (null)
[    9.824867] systemd-journald[230]: Received request to flush runtime
journal from PID 1
[   12.095034] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   12.102629] iwlwifi 0000:02:00.0: Radio type=0x2-0x0-0x0
[   12.353031] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[   12.360568] iwlwifi 0000:02:00.0: Radio type=0x2-0x0-0x0
[   12.422603] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   12.511946] r8169 0000:03:00.2 enp3s0f2: link down
[   12.511987] IPv6: ADDRCONF(NETDEV_UP): enp3s0f2: link is not ready
[   13.723012] wlp2s0: authenticate with [MAC_STRIPPED]
[   13.726635] wlp2s0: send auth to [MAC_STRIPPED] (try 1/3)
[   13.729331] wlp2s0: authenticated
[   13.729872] wlp2s0: associate with [MAC_STRIPPED] (try 1/3)
[   13.734892] wlp2s0: RX AssocResp from [MAC_STRIPPED] (capab=0x411
status=0 aid=4)
[   13.759007] wlp2s0: associated
[   13.759057] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
[   19.366367] fuse init (API version 7.22)
[  193.985549] wlp2s0: deauthenticating from [MAC_STRIPPED] by local
choice (reason=3)
[  194.011365] cfg80211: Calling CRDA to update world regulatory domain
[  199.140614] PM: Syncing filesystems ... done.
[  199.571413] PM: Preparing system for mem sleep
[  199.571809] Freezing user space processes ... (elapsed 0.001 seconds)
done.
[  199.573407] Freezing remaining freezable tasks ... (elapsed 0.001
seconds) done.
[  199.574511] PM: Entering mem sleep
[  199.574564] Suspending console(s) (use no_console_suspend to debug)
[  199.574945] sd 4:0:0:0: [sdb] Synchronizing SCSI cache
[  199.574979] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  199.579754] sd 4:0:0:0: [sdb] Stopping disk
[  199.653817] sd 0:0:0:0: [sda] Stopping disk
[  200.611915] PM: suspend of devices complete after 1036.500 msecs
[  200.612107] PM: late suspend of devices complete after 0.189 msecs
[  200.612303] r8169 0000:03:00.2: System wakeup enabled by ACPI
[  200.638600] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  200.652088] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  200.665220] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  200.678545] PM: noirq suspend of devices complete after 66.397 msecs
[  200.678729] ACPI: Preparing to enter system sleep state S3
[  200.680321] PM: Saving platform NVS memory
[  200.680834] Disabling non-boot CPUs ...
[  200.682252] smpboot: CPU 1 is now offline
[  200.785227] smpboot: CPU 2 is now offline
[  200.888648] smpboot: CPU 3 is now offline
[  200.889828] ACPI: Low-level resume complete
[  200.889865] PM: Restoring platform NVS memory
[  200.890287] Enabling non-boot CPUs ...
[  200.890327] smpboot: Booting Node 0 Processor 1 APIC 0x2
[  200.904045] Intel pstate controlling: cpu 1
[  200.904095] CPU1 is up
[  200.904114] smpboot: Booting Node 0 Processor 2 APIC 0x1
[  200.917782] Intel pstate controlling: cpu 2
[  200.917830] CPU2 is up
[  200.917846] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  200.931516] Intel pstate controlling: cpu 3
[  200.931564] CPU3 is up
[  200.934601] ACPI: Waking up from system sleep state S3
[  200.993469] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  201.006819] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  201.033495] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  201.087040] PM: noirq resume of devices complete after 118.140 msecs
[  201.087233] PM: early resume of devices complete after 0.169 msecs
[  201.087270] i915 0000:00:02.0: setting latency timer to 64
[  201.087272] xhci_hcd 0000:00:14.0: setting latency timer to 64
[  201.087456] ehci-pci 0000:00:1a.0: setting latency timer to 64
[  201.087597] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[  201.090717] ahci 0000:00:1f.2: setting latency timer to 64
[  201.090802] ehci-pci 0000:00:1d.0: setting latency timer to 64
[  201.090889] r8169 0000:03:00.2: System wakeup disabled by ACPI
[  201.430358] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  201.437019] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  201.509645] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[  201.509647] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  201.509649] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[  201.509919] ata5.00: supports DRM functions and may not be fully
accessible
[  201.516754] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[  201.516756] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  201.516757] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[  201.516998] ata5.00: supports DRM functions and may not be fully
accessible
[  201.523170] ata5.00: configured for UDMA/133
[  201.528884] ata3.00: configured for UDMA/100
[  201.533818] sd 4:0:0:0: [sdb] Starting disk
[  202.197508] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp on
[  203.695165] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  203.701879] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[  203.701883] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  203.701885] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[  203.715038] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
succeeded
[  203.715042] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
LOCK) filtered out
[  203.715044] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[  203.721440] ata1.00: configured for UDMA/133
[  203.731960] sd 0:0:0:0: [sda] Starting disk
[  203.757734] PM: resume of devices complete after 2668.846 msecs
[  203.758038] PM: Finishing wakeup.
[  203.758039] Restarting tasks ... done.
[  203.758936] video LNXVIDEO:00: Restoring backlight state
[  203.784008] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
[  203.792083] iwlwifi 0000:02:00.0: Radio type=0x2-0x0-0x0
[  203.856125] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[  203.928106] r8169 0000:03:00.2 enp3s0f2: link down
[  203.928145] IPv6: ADDRCONF(NETDEV_UP): enp3s0f2: link is not ready
[  204.999379] wlp2s0: authenticate with [MAC_STRIPPED]
[  205.003235] wlp2s0: send auth to [MAC_STRIPPED] (try 1/3)
[  205.005976] wlp2s0: authenticated
[  205.009250] wlp2s0: associate with [MAC_STRIPPED] (try 1/3)
[  205.019312] wlp2s0: RX AssocResp from [MAC_STRIPPED] (capab=0x411
status=0 aid=4)
[  205.043032] wlp2s0: associated
[  205.043069] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready


Here's the diff between before/after lspci -nnvt:
9,10c9
<            +-1c.3-[03]--+-00.0  Realtek Semiconductor Co., Ltd. Device
[10ec:5289]
<            |            \-00.2  Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168]
---
>            +-1c.3-[03]--

Please tell me if you need the lspci log in complete form or how to tune
the diff command.

Thanks

