Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3AVQDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:03:41 -0500
Received: from mail.palosanto.com ([201.234.196.171]:35259 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3AVQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:03:38 -0500
Message-ID: <50FEB852.70304@palosanto.com>
Date: Tue, 22 Jan 2013 11:03:30 -0500
From: =?ISO-8859-1?Q?Alex_Villac=ED=ADs_Lasso?= 
	<a_villacis@palosanto.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Kernel command line seems broken when compiling vanilla source under
 Fedora 18
Content-Type: multipart/mixed;
 boundary="------------000800090100060105050007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000800090100060105050007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

If this is not the correct list for this discussion, please indicate which list should be used.

I am having this strange issue. My computer has a LCD display that does not send any EDID, and therefore I need the command parameter "drm_kms_helper.edid_firmware=edid/1280x1024.bin" In Fedora 16, the stock kernel does not have 
CONFIG_DRM_LOAD_EDID_FIRMWARE set. Therefore I compiled my own kernel from vanilla sources, and the parameter worked. I have just now upgraded to Fedora 18. The new stock kernel is supposed to have CONFIG_DRM_LOAD_EDID_FIRMWARE set, but when I boot with 
the drm_kms_helper parameter, I get a message "drm_kms_helper: Unknown parameter `bin'". I thought this was a kernel bug caused by some patch in the stock kernel, so I filed https://bugzilla.redhat.com/show_bug.cgi?id=901899 , and then proceeded to compile 
3.8-rc4 from vanilla sources. However, I am surprised to find that the vanilla sources, when compiled under Fedora 18, exhibit the same bug. Has anyone seen a situation like this? Is this a possible compiler bug in Fedora 18? A grub2 bug? Apparently the 
kernel is misparsing the commandline parameter and thinks "bin" is the module parameter, not "edid_firmware".

I checked that I have CONFIG_DYNAMIC_DEBUG=y in my kernel config, and I tried adding dyndbg="file params.c +p" to the kernel command line, but I see no additional debug output that might point out what is happening.

--------------000800090100060105050007
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc4 (alex@karlalex.palosanto.com) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #19 SMP PREEMPT Sat Jan 19 18:47:11 ECT 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc4 root=UUID=34116aa2-ba9e-47a6-9371-9342830b4820 ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=es rd.luks=0 rhgb quiet zcache memmap=768M@4G LANG=es_ES.UTF-8 drm_kms_helper.edid_firmware=edid/1280x1024.bin
[    0.000000] e820: BIOS-provided physical RAM map:
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
[    0.000000] e820: user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] user: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x00000000cf58ffff] usable
[    0.000000] user: [mem 0x00000000cf590000-0x00000000cf5e2fff] ACPI NVS
[    0.000000] user: [mem 0x00000000cf5e3000-0x00000000cf5effff] ACPI data
[    0.000000] user: [mem 0x00000000cf5f0000-0x00000000cf5fffff] reserved
[    0.000000] user: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] user: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: OEM OEM/G31MVP, BIOS 6.00 PG 09/11/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
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
[    0.000000] e820: last_pfn = 0xcf590 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f3df0-0x000f3dff] mapped at [ffff8800000f3df0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcf58ffff]
[    0.000000]  [mem 0x00000000-0xcf3fffff] page 2M
[    0.000000]  [mem 0xcf400000-0xcf58ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcf58ffff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12fffffff]
[    0.000000]  [mem 0x100000000-0x12fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x12fffffff @ [mem 0xcf58e000-0xcf58ffff]
[    0.000000] RAMDISK: [mem 0x3708c000-0x3783dfff]
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
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000012fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12ffec000-0x12fffffff]
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012b600000-ffff88012f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcf58ffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000] On node 0 totalpages: 1045791
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13207 pages used for memmap
[    0.000000]   DMA32 zone: 831993 pages, LIFO batch:31
[    0.000000]   Normal zone: 3072 pages used for memmap
[    0.000000]   Normal zone: 193536 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: 00000000cf590000 - 00000000cf5e3000
[    0.000000] PM: Registered nosave memory: 00000000cf5e3000 - 00000000cf5f0000
[    0.000000] PM: Registered nosave memory: 00000000cf5f0000 - 00000000cf600000
[    0.000000] PM: Registered nosave memory: 00000000cf600000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] e820: [mem 0xcf600000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88012fc00000 s84928 r8192 d21568 u524288
[    0.000000] pcpu-alloc: s84928 r8192 d21568 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029442
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.8.0-rc4 root=UUID=34116aa2-ba9e-47a6-9371-9342830b4820 ro rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=es rd.luks=0 rhgb quiet zcache memmap=768M@4G LANG=es_ES.UTF-8 drm_kms_helper.edid_firmware=edid/1280x1024.bin
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 4027212k/4980736k available (6567k kernel code, 797572k absent, 155952k reserved, 6655k data, 1076k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:8448 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2755.619 MHz processor
[    0.001004] Calibrating delay loop (skipped), value calculated using timer frequency.. 5511.23 BogoMIPS (lpj=2755619)
[    0.001007] pid_max: default: 32768 minimum: 301
[    0.001044] Security Framework initialized
[    0.001056] SELinux:  Initializing.
[    0.001066] SELinux:  Starting in permissive mode
[    0.001449] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003741] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004688] Mount-cache hash table entries: 256
[    0.004914] Initializing cgroup subsys cpuacct
[    0.004918] Initializing cgroup subsys memory
[    0.004936] Initializing cgroup subsys devices
[    0.004937] Initializing cgroup subsys freezer
[    0.004939] Initializing cgroup subsys net_cls
[    0.004941] Initializing cgroup subsys blkio
[    0.004942] Initializing cgroup subsys perf_event
[    0.004972] CPU: Physical Processor ID: 0
[    0.004973] CPU: Processor Core ID: 0
[    0.004975] mce: CPU supports 6 MCE banks
[    0.004983] CPU0: Thermal monitoring enabled (TM2)
[    0.005010] process: using mwait in idle threads
[    0.005015] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
[    0.005111] Freeing SMP alternatives: 24k freed
[    0.006232] ACPI: Core revision 20121018
[    0.009009] ftrace: allocating 24310 entries in 95 pages
[    0.016416] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026427] smpboot: CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz (fam: 06, model: 17, stepping: 06)
[    0.027000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.027000] ... version:                2
[    0.027000] ... bit width:              40
[    0.027000] ... generic registers:      2
[    0.027000] ... value mask:             000000ffffffffff
[    0.027000] ... max period:             000000007fffffff
[    0.027000] ... fixed-purpose events:   3
[    0.027000] ... event mask:             0000000700000003
[    0.047104] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.035082] smpboot: Booting Node   0, Processors  #1
[    0.047120] Brought up 2 CPUs
[    0.047123] smpboot: Total of 2 processors activated (11022.47 BogoMIPS)
[    0.048089] devtmpfs: initialized
[    0.048170] PM: Registering ACPI NVS region [mem 0xcf590000-0xcf5e2fff] (339968 bytes)
[    0.049622] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.049645] RTC time:  0:49:48, date: 01/20/13
[    0.049693] NET: Registered protocol family 16
[    0.049867] ACPI: bus type pci registered
[    0.049918] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.049921] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.069012] PCI: Using configuration type 1 for base access
[    0.070033] bio: create slab <bio-0> at 0
[    0.070063] ACPI: Added _OSI(Module Device)
[    0.070063] ACPI: Added _OSI(Processor Device)
[    0.070063] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.070063] ACPI: Added _OSI(Processor Aggregator Device)
[    0.070797] ACPI: EC: Look up EC in DSDT
[    0.073570] ACPI: SSDT 00000000cf5e8500 002AE (v01  PmRef  Cpu0Ist 00003000 INTL 20041203)
[    0.073756] ACPI: Dynamic OEM Table Load:
[    0.073758] ACPI: SSDT           (null) 002AE (v01  PmRef  Cpu0Ist 00003000 INTL 20041203)
[    0.073919] ACPI: SSDT 00000000cf5e89c0 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20041203)
[    0.074104] ACPI: Dynamic OEM Table Load:
[    0.074107] ACPI: SSDT           (null) 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20041203)
[    0.074265] ACPI: Interpreter enabled
[    0.074269] ACPI: (supports S0 S3 S4 S5)
[    0.074281] ACPI: Using IOAPIC for interrupt routing
[    0.077574] ACPI: No dock devices found.
[    0.077579] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.077622] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.077624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.077684] pci_root PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.077687] pci_root PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.077771] PCI host bridge to bus 0000:00
[    0.077774] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.077777] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.077779] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.077781] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.077783] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.077785] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.077787] pci_bus 0000:00: root bus resource [mem 0xcf600000-0xfebfffff]
[    0.077796] pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000
[    0.077837] pci 0000:00:02.0: [8086:29c2] type 00 class 0x030000
[    0.077846] pci 0000:00:02.0: reg 10: [mem 0xfdf00000-0xfdf7ffff]
[    0.077851] pci 0000:00:02.0: reg 14: [io  0xff00-0xff07]
[    0.077857] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.077862] pci 0000:00:02.0: reg 1c: [mem 0xfdb00000-0xfdbfffff]
[    0.077920] pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
[    0.077933] pci 0000:00:1b.0: reg 10: [mem 0xfdff8000-0xfdffbfff 64bit]
[    0.077991] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.078017] pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
[    0.078076] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.078096] pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
[    0.078155] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.078177] pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
[    0.078212] pci 0000:00:1d.0: reg 20: [io  0xfe00-0xfe1f]
[    0.078241] pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
[    0.078275] pci 0000:00:1d.1: reg 20: [io  0xfd00-0xfd1f]
[    0.078302] pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
[    0.078336] pci 0000:00:1d.2: reg 20: [io  0xfc00-0xfc1f]
[    0.078363] pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
[    0.078397] pci 0000:00:1d.3: reg 20: [io  0xfb00-0xfb1f]
[    0.078432] pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
[    0.078448] pci 0000:00:1d.7: reg 10: [mem 0xfdfff000-0xfdfff3ff]
[    0.078518] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.078535] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.078590] pci 0000:00:1f.0: [8086:27b8] type 00 class 0x060100
[    0.078660] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 003f)
[    0.078663] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 003f)
[    0.078666] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 000b)
[    0.078702] pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
[    0.078713] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.078721] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.078729] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.078737] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.078745] pci 0000:00:1f.1: reg 20: [io  0xfa00-0xfa0f]
[    0.078776] pci 0000:00:1f.2: [8086:27c0] type 00 class 0x01018f
[    0.078788] pci 0000:00:1f.2: reg 10: [io  0xf900-0xf907]
[    0.078795] pci 0000:00:1f.2: reg 14: [io  0xf800-0xf803]
[    0.078802] pci 0000:00:1f.2: reg 18: [io  0xf700-0xf707]
[    0.078809] pci 0000:00:1f.2: reg 1c: [io  0xf600-0xf603]
[    0.078816] pci 0000:00:1f.2: reg 20: [io  0xf500-0xf50f]
[    0.078823] pci 0000:00:1f.2: reg 24: [mem 0xfdffe000-0xfdffe3ff]
[    0.078848] pci 0000:00:1f.2: PME# supported from D3hot
[    0.078862] pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
[    0.078906] pci 0000:00:1f.3: reg 20: [io  0x0500-0x051f]
[    0.078969] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.078972] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.078976] pci 0000:00:1c.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.078981] pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.079043] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.079059] pci 0000:02:00.0: reg 10: [io  0xee00-0xeeff]
[    0.079087] pci 0000:02:00.0: reg 18: [mem 0xfddff000-0xfddfffff 64bit]
[    0.079119] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.079190] pci 0000:02:00.0: supports D1 D2
[    0.079192] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.081021] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.081028] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.081034] pci 0000:00:1c.1:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.081042] pci 0000:00:1c.1:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.081118] pci 0000:00:1e.0: PCI bridge to [bus 03] (subtractive decode)
[    0.081121] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.081125] pci 0000:00:1e.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    0.081130] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    0.081132] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.081134] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.081136] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.081138] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.081140] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.081142] pci 0000:00:1e.0:   bridge window [mem 0xcf600000-0xfebfffff] (subtractive decode)
[    0.081164] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.081189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.081217] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.081270] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.086854] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.086892] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.086929] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.086965] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 12 14 *15)
[    0.087008] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.087045] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.087082] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.087119] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.087175] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.087175] vgaarb: loaded
[    0.087175] vgaarb: bridge control possible 0000:00:02.0
[    0.087175] SCSI subsystem initialized
[    0.087175] ACPI: bus type scsi registered
[    0.087175] libata version 3.00 loaded.
[    0.087175] ACPI: bus type usb registered
[    0.087175] usbcore: registered new interface driver usbfs
[    0.087175] usbcore: registered new interface driver hub
[    0.087175] usbcore: registered new device driver usb
[    0.087175] PCI: Using ACPI for IRQ routing
[    0.092380] PCI: pci_cache_line_size set to 64 bytes
[    0.092425] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    0.092427] e820: reserve RAM buffer [mem 0xcf590000-0xcfffffff]
[    0.092517] NetLabel: Initializing
[    0.092519] NetLabel:  domain hash size = 128
[    0.092520] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.092530] NetLabel:  unlabeled traffic allowed by default
[    0.092581] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.092585] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.092588] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.098013] Switching to clocksource hpet
[    0.105228] pnp: PnP ACPI init
[    0.105249] ACPI: bus type pnp registered
[    0.105394] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.105397] system 00:00: [io  0x0290-0x029f] has been reserved
[    0.105399] system 00:00: [io  0x0800-0x087f] has been reserved
[    0.105401] system 00:00: [io  0x0290-0x0297] has been reserved
[    0.105403] system 00:00: [io  0x0880-0x088f] has been reserved
[    0.105408] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.105418] pnp 00:01: [dma 4]
[    0.105435] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.105514] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.105553] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.105575] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.105603] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.105724] pnp 00:06: [dma 2]
[    0.105752] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.105933] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.106180] pnp 00:08: Plug and Play ACPI device, IDs PNP0510 (active)
[    0.106415] pnp 00:09: [dma 3]
[    0.106456] pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.106503] pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.106549] pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.106598] system 00:0c: [io  0x0400-0x04bf] has been reserved
[    0.106602] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.106632] pnp 00:0d: Plug and Play ACPI device, IDs INT0800 (active)
[    0.106809] system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
[    0.106812] system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.106892] system 00:0f: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.106895] system 00:0f: [mem 0xcf600000-0xcf6fffff] has been reserved
[    0.106897] system 00:0f: [mem 0xfed00000-0xfed000ff] has been reserved
[    0.106899] system 00:0f: [mem 0xcf590000-0xcf5fffff] could not be reserved
[    0.106901] system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.106904] system 00:0f: [mem 0x00100000-0xcf58ffff] could not be reserved
[    0.106906] system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.106908] system 00:0f: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.106911] system 00:0f: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.106913] system 00:0f: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.106915] system 00:0f: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.106917] system 00:0f: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.106919] system 00:0f: [mem 0xfff00000-0xffffffff] has been reserved
[    0.106921] system 00:0f: [mem 0x000e0000-0x000effff] has been reserved
[    0.106924] system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.106932] pnp: PnP ACPI: found 16 devices
[    0.106933] ACPI: ACPI bus type pnp unregistered
[    0.113334] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.113338] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.113343] pci 0000:00:1c.0:   bridge window [mem 0xfd800000-0xfd8fffff]
[    0.113347] pci 0000:00:1c.0:   bridge window [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.113355] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdc00000-0xfdc1ffff pref]
[    0.113357] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.113360] pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
[    0.113364] pci 0000:00:1c.1:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.113367] pci 0000:00:1c.1:   bridge window [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.113373] pci 0000:00:1e.0: PCI bridge to [bus 03]
[    0.113375] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.113379] pci 0000:00:1e.0:   bridge window [mem 0xfda00000-0xfdafffff]
[    0.113383] pci 0000:00:1e.0:   bridge window [mem 0xfd900000-0xfd9fffff 64bit pref]
[    0.113408] pci 0000:00:1e.0: setting latency timer to 64
[    0.113412] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.113413] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.113415] pci_bus 0000:00: resource 6 [mem 0xfed40000-0xfed44fff]
[    0.113417] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.113419] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.113421] pci_bus 0000:00: resource 9 [mem 0xcf600000-0xfebfffff]
[    0.113423] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.113425] pci_bus 0000:01: resource 1 [mem 0xfd800000-0xfd8fffff]
[    0.113427] pci_bus 0000:01: resource 2 [mem 0xfde00000-0xfdefffff 64bit pref]
[    0.113429] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.113431] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.113433] pci_bus 0000:02: resource 2 [mem 0xfdc00000-0xfdcfffff 64bit pref]
[    0.113435] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.113437] pci_bus 0000:03: resource 1 [mem 0xfda00000-0xfdafffff]
[    0.113439] pci_bus 0000:03: resource 2 [mem 0xfd900000-0xfd9fffff 64bit pref]
[    0.113441] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.113443] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.113445] pci_bus 0000:03: resource 6 [mem 0xfed40000-0xfed44fff]
[    0.113447] pci_bus 0000:03: resource 7 [mem 0x000a0000-0x000bffff]
[    0.113449] pci_bus 0000:03: resource 8 [mem 0x000c0000-0x000dffff]
[    0.113451] pci_bus 0000:03: resource 9 [mem 0xcf600000-0xfebfffff]
[    0.113490] NET: Registered protocol family 2
[    0.113674] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.113903] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.114097] TCP: Hash tables configured (established 32768 bind 32768)
[    0.114140] TCP: reno registered
[    0.114149] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.114176] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.114257] NET: Registered protocol family 1
[    0.114274] pci 0000:00:02.0: Boot video device
[    0.114399] PCI: CLS 64 bytes, default 64
[    0.114446] Unpacking initramfs...
[    0.242324] Freeing initrd memory: 7880k freed
[    0.245502] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.245509] software IO TLB [mem 0xcb58e000-0xcf58e000] (64MB) mapped at [ffff8800cb58e000-ffff8800cf58dfff]
[    0.246105] Initialise module verification
[    0.246145] audit: initializing netlink socket (disabled)
[    0.246160] type=2000 audit(1358642988.245:1): initialized
[    0.262024] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.263511] VFS: Disk quotas dquot_6.5.2
[    0.263552] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.263954] msgmni has been set to 7881
[    0.264021] SELinux:  Registering netfilter hooks
[    0.264535] alg: No test for stdrng (krng)
[    0.264542] NET: Registered protocol family 38
[    0.264546] Key type asymmetric registered
[    0.264547] Asymmetric key parser 'x509' registered
[    0.264582] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.264608] io scheduler noop registered
[    0.264610] io scheduler deadline registered
[    0.264618] io scheduler cfq registered (default)
[    0.264734] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.264811] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.264880] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.264896] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.264898] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.265156] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    0.265158] vesafb: scrolling: redraw
[    0.265160] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.265269] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90010800000, using 1216k, total 1216k
[    0.276633] Console: switching to colour frame buffer device 80x30
[    0.286509] fb0: VESA VGA frame buffer device
[    0.286519] intel_idle: does not run on family 6 model 23
[    0.286573] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.286577] ACPI: Power Button [PWRB]
[    0.286615] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.286618] ACPI: Power Button [PWRF]
[    0.286656] ACPI: Fan [FAN] (on)
[    0.286782] ACPI: Requesting acpi_cpufreq
[    0.290413] thermal LNXTHERM:00: registered as thermal_zone0
[    0.290416] ACPI: Thermal Zone [THRM] (201 C)
[    0.290440] GHES: HEST is not enabled!
[    0.290507] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.310977] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.331495] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.331818] Non-volatile memory driver v1.3
[    0.331820] Linux agpgart interface v0.103
[    0.331870] agpgart-intel 0000:00:00.0: Intel G33 Chipset
[    0.331929] agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
[    0.332404] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.332509] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.333214] loop: module loaded
[    0.333287] ata_piix 0000:00:1f.1: version 2.13
[    0.333324] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.333561] scsi0 : ata_piix
[    0.333803] scsi1 : ata_piix
[    0.333943] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    0.333946] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    0.333961] ata_piix 0000:00:1f.2: MAP [
[    0.333962]  P0 P2 P1 P3 ]
[    0.333989] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.334009] ata2: port disabled--ignoring
[    0.334290] scsi2 : ata_piix
[    0.334487] scsi3 : ata_piix
[    0.334655] ata3: SATA max UDMA/133 cmd 0xf900 ctl 0xf800 bmdma 0xf500 irq 19
[    0.334658] ata4: SATA max UDMA/133 cmd 0xf700 ctl 0xf600 bmdma 0xf508 irq 19
[    0.334717] libphy: Fixed MDIO Bus: probed
[    0.334840] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.334842] ehci-pci: EHCI PCI platform driver
[    0.334869] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    0.334872] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    0.334907] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.334919] ehci-pci 0000:00:1d.7: debug port 1
[    0.338833] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    0.338848] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfdfff000
[    0.344022] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.344057] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.344062] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.344066] usb usb1: Product: EHCI Host Controller
[    0.344070] usb usb1: Manufacturer: Linux 3.8.0-rc4 ehci_hcd
[    0.344074] usb usb1: SerialNumber: 0000:00:1d.7
[    0.344184] hub 1-0:1.0: USB hub found
[    0.344188] hub 1-0:1.0: 8 ports detected
[    0.344295] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.344303] uhci_hcd: USB Universal Host Controller Interface driver
[    0.344322] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.344325] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.344357] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.344377] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fe00
[    0.344407] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.344409] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.344411] usb usb2: Product: UHCI Host Controller
[    0.344413] usb usb2: Manufacturer: Linux 3.8.0-rc4 uhci_hcd
[    0.344415] usb usb2: SerialNumber: 0000:00:1d.0
[    0.344488] hub 2-0:1.0: USB hub found
[    0.344494] hub 2-0:1.0: 2 ports detected
[    0.344553] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.344556] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.344588] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.344608] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fd00
[    0.344633] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.344635] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.344637] usb usb3: Product: UHCI Host Controller
[    0.344639] usb usb3: Manufacturer: Linux 3.8.0-rc4 uhci_hcd
[    0.344641] usb usb3: SerialNumber: 0000:00:1d.1
[    0.344712] hub 3-0:1.0: USB hub found
[    0.344716] hub 3-0:1.0: 2 ports detected
[    0.344776] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.344779] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.344822] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.344851] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fc00
[    0.344878] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.344880] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.344882] usb usb4: Product: UHCI Host Controller
[    0.344884] usb usb4: Manufacturer: Linux 3.8.0-rc4 uhci_hcd
[    0.344886] usb usb4: SerialNumber: 0000:00:1d.2
[    0.344955] hub 4-0:1.0: USB hub found
[    0.344962] hub 4-0:1.0: 2 ports detected
[    0.345030] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.345033] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.345074] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.345100] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fb00
[    0.345126] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.345128] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.345130] usb usb5: Product: UHCI Host Controller
[    0.345132] usb usb5: Manufacturer: Linux 3.8.0-rc4 uhci_hcd
[    0.345134] usb usb5: SerialNumber: 0000:00:1d.3
[    0.345204] hub 5-0:1.0: USB hub found
[    0.345207] hub 5-0:1.0: 2 ports detected
[    0.345304] usbcore: registered new interface driver usbserial
[    0.345312] usbcore: registered new interface driver usbserial_generic
[    0.345318] usbserial: USB Serial support registered for generic
[    0.345353] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.345674] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.345699] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.345759] mousedev: PS/2 mouse device common for all mice
[    0.345902] rtc_cmos 00:03: RTC can wake from S4
[    0.346000] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.346028] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.346111] device-mapper: uevent: version 1.0.3
[    0.346169] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[    0.346204] cpuidle: using governor ladder
[    0.346206] cpuidle: using governor menu
[    0.346449] EFI Variables Facility v0.08 2004-May-17
[    0.346536] usbcore: registered new interface driver usbhid
[    0.346537] usbhid: USB HID core driver
[    0.346558] drop_monitor: Initializing network drop monitor service
[    0.346629] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.346652] TCP: cubic registered
[    0.346654] Initializing XFRM netlink socket
[    0.346752] NET: Registered protocol family 10
[    0.346904] mip6: Mobile IPv6
[    0.346907] NET: Registered protocol family 17
[    0.347129] PM: Hibernation image not present or could not be loaded.
[    0.347131] Loading module verification certificates
[    0.348040] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 25f0be326082d0c7988fdd20c884a075a1fe48bc'
[    0.348050] registered taskstats version 1
[    0.348497]   Magic number: 13:255:810
[    0.348585] rtc_cmos 00:03: setting system clock to 2013-01-20 00:49:49 UTC (1358642989)
[    0.349171] zcache: using lzo compressor
[    0.349265] zcache: cleancache enabled using kernel transcendent memory and compression buddies
[    0.349267] zcache: cleancache: ignorenonactive = 1
[    0.349268] zcache: frontswap enabled using kernel transcendent memory and compression buddies
[    0.349269] zcache: frontswap: excl gets = 1 active only = 1
[    0.366728] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    0.486419] ata4.01: NODEV after polling detection
[    0.488356] ata3.00: ATA-8: WDC WD5000AAKS-00V1A0, 05.01D05, max UDMA/133
[    0.488362] ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.488571] ata3.00: failed to get Identify Device Data, Emask 0x1
[    0.490182] ata4.00: ATAPI: Optiarc DVD RW AD-7280S, 1.01, max UDMA/100
[    0.494548] ata3.00: failed to get Identify Device Data, Emask 0x1
[    0.494555] ata3.00: configured for UDMA/133
[    0.496183] ata4.00: configured for UDMA/100
[    0.504531] ata1.00: ATA-6: ST3160021A, 8.01, max UDMA/100
[    0.504535] ata1.00: 312581808 sectors, multi 16: LBA48 
[    0.526436] ata1.00: configured for UDMA/100
[    0.526594] scsi 0:0:0:0: Direct-Access     ATA      ST3160021A       8.01 PQ: 0 ANSI: 5
[    0.526824] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    0.526882] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.526961] sd 0:0:0:0: [sda] Write Protect is off
[    0.526967] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.527025] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.527217] scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 05.0 PQ: 0 ANSI: 5
[    0.527465] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    0.527487] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.527578] sd 2:0:0:0: [sdb] Write Protect is off
[    0.527583] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.527623] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.528264] scsi 3:0:0:0: CD-ROM            Optiarc  DVD RW AD-7280S  1.01 PQ: 0 ANSI: 5
[    0.530309] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    0.530314] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.530464] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    0.530616] sr 3:0:0:0: Attached scsi generic sg2 type 5
[    0.532788]  sda: sda1
[    0.533161] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.566551]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
[    0.566894] sd 2:0:0:0: [sdb] Attached SCSI disk
[    0.568146] Freeing unused kernel memory: 1076k freed
[    0.568468] Write protecting the kernel read-only data: 12288k
[    0.572263] Freeing unused kernel memory: 1612k freed
[    0.575731] Freeing unused kernel memory: 1344k freed
[    0.628062] systemd[1]: systemd 195 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; fedora)
[    0.628277] systemd[1]: Running in initial RAM disk.
[    0.628495] systemd[1]: Set hostname to <karlalex.palosanto.com>.
[    0.647961] systemd[1]: Starting udev Kernel Socket.
[    0.648052] systemd[1]: Listening on udev Kernel Socket.
[    0.648163] systemd[1]: Starting udev Control Socket.
[    0.648225] systemd[1]: Listening on udev Control Socket.
[    0.648245] systemd[1]: Starting Journal Socket.
[    0.648340] systemd[1]: Listening on Journal Socket.
[    0.648363] systemd[1]: Starting dracut cmdline hook...
[    0.656462] systemd[1]: Started Load Kernel Modules.
[    0.656488] systemd[1]: Starting Journal Service...
[    0.668259] systemd[1]: Started Journal Service.
[    0.671372] systemd[1]: Starting Sockets.
[    0.671402] systemd[1]: Reached target Sockets.
[    0.671425] systemd[1]: Starting Swap.
[    0.671446] systemd[1]: Reached target Swap.
[    0.671463] systemd[1]: Starting Local File Systems.
[    0.671483] systemd[1]: Reached target Local File Systems.
[    0.774795] systemd-udevd[108]: starting version 195
[    0.868850] [drm] Initialized drm 1.1.0 20060810
[    0.870514] drm_kms_helper: Unknown parameter `bin'
[    1.100850] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    1.248020] tsc: Refined TSC clocksource calibration: 2755.321 MHz
[    1.248027] Switching to clocksource tsc
[    1.288067] zcache: created ephemeral local tmem pool, id=0
[    1.289997] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    1.369789] zcache: destroyed local pool id=0
[    1.422387] zcache: created ephemeral local tmem pool, id=0
[    1.423354] EXT4-fs (sdb2): mounted filesystem with ordered data mode. Opts: (null)
[    1.673820] systemd-journald[65]: Received SIGTERM
[    2.153676] type=1404 audit(1358642991.303:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    2.246752] SELinux: 2048 avtab hash slots, 94087 rules.
[    2.264207] SELinux: 2048 avtab hash slots, 94087 rules.
[    2.535822] SELinux:  9 users, 15 roles, 4356 types, 237 bools, 1 sens, 1024 cats
[    2.535827] SELinux:  83 classes, 94087 rules
[    2.540227] SELinux:  Completing initialization.
[    2.540232] SELinux:  Setting up existing superblocks.
[    2.540243] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.540248] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    2.540263] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    2.540269] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    2.540279] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.540296] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    2.540977] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    2.540982] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    2.542709] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    2.542718] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    2.542722] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    2.542743] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    2.542750] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    2.542758] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    2.542780] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.543546] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    2.543549] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.543555] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.543634] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.543664] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543669] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543679] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543710] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543724] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543730] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543735] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543741] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543752] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.543763] SELinux: initialized (dev sdb2, type ext4), uses xattr
[    2.561205] type=1403 audit(1358642991.711:3): policy loaded auid=4294967295 ses=4294967295
[    2.569180] systemd[1]: Successfully loaded SELinux policy in 432ms 442us.
[    2.757280] systemd[1]: Relabelled /dev and /run in 19ms 246us.
[    3.249478] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    3.306564] systemd-readahead[225]: Bumped block_nr parameter of 8:16 to 20480. This is a temporary hack and should be removed one day.
[    3.738618] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.866439] zcache: created ephemeral local tmem pool, id=1
[    3.866447] EXT4-fs (sdb2): re-mounted. Opts: (null)
[    3.933239] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.082770] systemd-udevd[232]: starting version 195
[    4.362063] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[    4.505229] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    5.773656] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
[    5.843106] parport_pc 00:09: reported by Plug and Play ACPI
[    5.843161] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[    5.859929] microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
[    5.863538] microcode: CPU1 sig=0x10676, pf=0x1, revision=0x60c
[    5.864515] microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
[    5.868409] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.039559] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    6.056304] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    6.064217] ppdev: user-space parallel port driver
[    6.064422] intel_rng: FWH not detected
[    6.237544] Floppy drive(s): fd0 is 1.44M
[    6.251206] FDC 0 is a post-1991 82077
[    6.381984] drm_kms_helper: Unknown parameter `bin'
[    6.701420] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PM2S 1 (20121018/utaddress-251)
[    6.701427] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.701431] ACPI Warning: 0x00000000000004b0-0x00000000000004bf SystemIO conflicts with Region \GPO2 1 (20121018/utaddress-251)
[    6.701434] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.701436] ACPI Warning: 0x0000000000000480-0x00000000000004af SystemIO conflicts with Region \GPO_ 1 (20121018/utaddress-251)
[    6.701439] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.701440] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    6.721048] leds_ss4200: no LED devices found
[    6.889381] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.889590] r8169 0000:02:00.0: irq 42 for MSI/MSI-X
[    6.889747] r8169 0000:02:00.0 eth0: RTL8168b/8111b at 0xffffc90000674000, 00:22:68:44:17:2f, XID 98500000 IRQ 42
[    6.889750] r8169 0000:02:00.0 eth0: jumbo features [frames: 4080 bytes, tx checksumming: ko]
[    7.005155] systemd-udevd[280]: renamed network interface eth0 to p17p1
[    7.374497] iTCO_vendor_support: vendor-support=0
[    7.386261] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    7.386302] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
[    7.386645] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    7.513718] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[    7.692217] ALSA sound/pci/hda/patch_realtek.c:1241 SKU: Nid=0x1d sku_cfg=0x40038601
[    7.692221] ALSA sound/pci/hda/patch_realtek.c:1243 SKU: port_connectivity=0x1
[    7.692223] ALSA sound/pci/hda/patch_realtek.c:1244 SKU: enable_pcbeep=0x0
[    7.692226] ALSA sound/pci/hda/patch_realtek.c:1245 SKU: check_sum=0x00000003
[    7.692228] ALSA sound/pci/hda/patch_realtek.c:1246 SKU: customization=0x00000086
[    7.692230] ALSA sound/pci/hda/patch_realtek.c:1247 SKU: external_amp=0x0
[    7.692232] ALSA sound/pci/hda/patch_realtek.c:1248 SKU: platform_type=0x0
[    7.692234] ALSA sound/pci/hda/patch_realtek.c:1249 SKU: swap=0x0
[    7.692235] ALSA sound/pci/hda/patch_realtek.c:1250 SKU: override=0x1
[    7.692241] ALSA sound/pci/hda/hda_auto_parser.c:306 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[    7.692243] ALSA sound/pci/hda/hda_auto_parser.c:310    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.692246] ALSA sound/pci/hda/hda_auto_parser.c:314    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    7.692248] ALSA sound/pci/hda/hda_auto_parser.c:315    mono: mono_out=0x0
[    7.692250] ALSA sound/pci/hda/hda_auto_parser.c:318    dig-out=0x1e/0x0
[    7.692252] ALSA sound/pci/hda/hda_auto_parser.c:319    inputs:
[    7.692254] ALSA sound/pci/hda/hda_auto_parser.c:323      Front Mic=0x19
[    7.692256] ALSA sound/pci/hda/hda_auto_parser.c:323      Rear Mic=0x18
[    7.692258] ALSA sound/pci/hda/hda_auto_parser.c:323      Line=0x1a
[    7.694071] ALSA sound/pci/hda/patch_realtek.c:1304 realtek: No valid SSID, checking pincfg 0x40038601 for NID 0x1d
[    7.694074] ALSA sound/pci/hda/patch_realtek.c:1320 realtek: Enabling init ASM_ID=0x8601 CODEC_ID=10ec0662
[    7.705155] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    7.705301] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    7.705377] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    7.705450] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    7.705524] input: HDA Intel Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.327963] zcache: created persistent local tmem pool, id=2
[    8.327971] Adding 8388604k swap on /dev/sdb3.  Priority:-1 extents:1 across:8388604k FS
[    8.642069] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
[    8.697222] zcache: created ephemeral local tmem pool, id=3
[    8.697542] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    8.697554] SELinux: initialized (dev sda1, type ext3), uses xattr
[    9.382572] EXT4-fs (sdb5): mounting ext3 file system using the ext4 subsystem
[    9.441418] zcache: created ephemeral local tmem pool, id=4
[    9.442057] EXT4-fs (sdb5): mounted filesystem with ordered data mode. Opts: (null)
[    9.442067] SELinux: initialized (dev sdb5, type ext3), uses xattr
[    9.902797] zcache: created ephemeral local tmem pool, id=5
[    9.902915] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[   10.151692] SELinux: initialized (dev sdb1, type ext4), uses xattr
[   11.618165] systemd-journald[234]: Received SIGUSR1
[   12.343977] Loading iSCSI transport class v2.0-870.
[   12.459255] iscsi: registered transport (tcp)
[   12.475328] iscsi: registered transport (iser)
[   12.479111] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[   12.479116] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
[   12.485164] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[   12.485196] iscsi: registered transport (cxgb3i)
[   12.492267] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
[   12.492681] iscsi: registered transport (cxgb4i)
[   12.497420] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05, 2012)
[   12.499492] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2012)
[   12.499523] iscsi: registered transport (bnx2i)
[   12.507270] iscsi: registered transport (be2iscsi)
[   12.507274] In beiscsi_module_init, tt=ffffffffa02c7000
[   12.614617] it87: Found IT8718F chip at 0x290, revision 4
[   12.614635] it87: Beeping is supported
[   12.614664] ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \IP__ 1 (20121018/utaddress-251)
[   12.614669] ACPI Warning: 0x0000000000000295-0x0000000000000296 SystemIO conflicts with Region \SIOR 2 (20121018/utaddress-251)
[   12.614673] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   14.159210] drm_kms_helper: Unknown parameter `bin'
[   14.390065] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   14.418700] Ebtables v2.0 registered
[   14.475675] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   14.682439] r8169 0000:02:00.0 p17p1: link down
[   14.682455] r8169 0000:02:00.0 p17p1: link down
[   14.682478] IPv6: ADDRCONF(NETDEV_UP): p17p1: link is not ready
[   14.699994] Bluetooth: Core ver 2.16
[   14.700144] NET: Registered protocol family 31
[   14.700146] Bluetooth: HCI device and connection manager initialized
[   14.700159] Bluetooth: HCI socket layer initialized
[   14.700161] Bluetooth: L2CAP socket layer initialized
[   14.700169] Bluetooth: SCO socket layer initialized
[   14.728512] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   14.728516] Bluetooth: BNEP filters: protocol multicast
[   14.728529] Bluetooth: BNEP socket layer initialized
[   16.469156] r8169 0000:02:00.0 p17p1: link up
[   16.469170] IPv6: ADDRCONF(NETDEV_CHANGE): p17p1: link becomes ready
[   19.969854] cgroup: libvirtd (1115) created nested cgroup for controller "memory" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   19.969858] cgroup: "memory" requires setting use_hierarchy to 1 on the root.
[   19.969933] cgroup: libvirtd (1115) created nested cgroup for controller "devices" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   19.970547] cgroup: libvirtd (1115) created nested cgroup for controller "blkio" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   25.825624] tun: Universal TUN/TAP device driver, 1.6
[   25.825628] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>

--------------000800090100060105050007--
