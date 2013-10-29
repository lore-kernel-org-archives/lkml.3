Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3J2SvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:51:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:12677 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3J2SvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:51:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,595,1378882800"; 
   d="asc'?scan'208";a="424738964"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: 3.12-rc7 kernel crash
Thread-Topic: 3.12-rc7 kernel crash
Thread-Index: AQHO1NfCrPl6XmN1FU+8bOUX2NzclA==
Date: Tue, 29 Oct 2013 18:50:38 +0000
Message-ID: <1D7389E7-1DC1-449A-9019-A9BEA5F8D06F@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.147]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_3BCF4D16-B66A-44FB-BA57-2758915309F5";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_3BCF4D16-B66A-44FB-BA57-2758915309F5
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_BCF13790-841E-45E0-92BA-A00F1D7D1256"


--Apple-Mail=_BCF13790-841E-45E0-92BA-A00F1D7D1256
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Folks,

I started trying to run the 3.12 kernel yesterday and ran into crashes, =
but I couldn't see enough on the video to make a good report. This =
morning I updated and got a serial console hooked up. The kernel was =
built from commit c9ca72fc56 which just happened to be the latest when I =
updated. There are no patches on top of this and no additional or =
out-of-tree drivers involved. I assume that the crashes I was seeing =
yesterday were similar, but don't have the captures to know that for a =
fact.

This kernel was built on a RHEL 6.4 system and installed on that same =
system. The kernel configuration is custom - reduced - and I tried some =
variations of configuration yesterday without success. That is why there =
are more debugging options turned on. Without object debugging on, I =
still get the crash, but don't see the earlier complaint.

I have attached the kernel config as crash.config and pasted the serial =
capture below:

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.12.0-rc7-mdr+ (root@n0647) (gcc version 4.4.7 20120313 =
(Red Hat 4.4.7-3) (GCC) ) #5 SMP Tue Oct 29 09:23:04 PDT 2013
Command line: ro root=3D/dev/mapper/vg_n0647-lv_root =
rd_LVM_LV=3Dvg_n0647/lv_swap LANG=3Den_US.UTF-8 =
rd_LVM_LV=3Dvg_n0647/lv_root rd_NO_MD SYSFONT=3Dlatarcyrheb-sun16 =
rd_NO_LUKS KEYBOARDTYPE=3Dpc KEYTABLE=3Dus rd_NO_DM  biosdevname=3D0 =
console=3DttyS0,115200
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000ce8c2fff] usable
BIOS-e820: [mem 0x00000000ce8c3000-0x00000000cea68fff] reserved
BIOS-e820: [mem 0x00000000cea69000-0x00000000cea74fff] ACPI data
BIOS-e820: [mem 0x00000000cea75000-0x00000000ceacdfff] reserved
BIOS-e820: [mem 0x00000000ceace000-0x00000000cead2fff] ACPI data
BIOS-e820: [mem 0x00000000cead3000-0x00000000ceb55fff] usable
BIOS-e820: [mem 0x00000000ceb56000-0x00000000cebe8fff] ACPI NVS
BIOS-e820: [mem 0x00000000cebe9000-0x00000000ceea3fff] reserved
BIOS-e820: [mem 0x00000000ceea4000-0x00000000ceea4fff] usable
BIOS-e820: [mem 0x00000000ceea5000-0x00000000ceee7fff] ACPI NVS
BIOS-e820: [mem 0x00000000ceee8000-0x00000000cf7fffff] usable
BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000012effffff] usable
NX (Execute Disable) protection: active
SMBIOS 2.7 present.
No AGP bridge found
e820: last_pfn =3D 0x12f000 max_arch_pfn =3D 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
total RAM covered: 4080M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 32M 	num_reg: 6  	lose =
cover RAM: 0G
e820: last_pfn =3D 0xcf800 max_arch_pfn =3D 0x400000000
found SMP MP-table at [mem 0x000fd880-0x000fd88f] mapped at =
[ffff8800000fd880]
init_memory_mapping: [mem 0x00000000-0x000fffff]
init_memory_mapping: [mem 0x12ee00000-0x12effffff]
init_memory_mapping: [mem 0x12c000000-0x12edfffff]
init_memory_mapping: [mem 0x100000000-0x12bffffff]
init_memory_mapping: [mem 0x00100000-0xce8c2fff]
init_memory_mapping: [mem 0xcead3000-0xceb55fff]
init_memory_mapping: [mem 0xceea4000-0xceea4fff]
init_memory_mapping: [mem 0xceee8000-0xcf7fffff]
RAMDISK: [mem 0x379f9000-0x37feffff]
ACPI: RSDP 00000000000f0490 00024 (v02  INTEL)
ACPI: XSDT 00000000cea69078 0006C (v01  INTEL   DZ77GA 0000002B AMI  =
00010013)
ACPI: FACP 00000000cea73300 000F4 (v04  INTEL   DZ77GA 0000002B AMI  =
00010013)
ACPI: DSDT 00000000cea69170 0A18D (v02  INTEL   DZ77GA 00000019 INTL =
20051117)
ACPI: FACS 00000000cebe7f80 00040
ACPI: APIC 00000000cea733f8 00092 (v03  INTEL   DZ77GA 0000002B AMI  =
00010013)
ACPI: FPDT 00000000cea73490 00044 (v01  INTEL   DZ77GA 0000002B AMI  =
00010013)
ACPI: MCFG 00000000cea734d8 0003C (v01  INTEL   DZ77GA 0000002B MSFT =
00000097)
ACPI: HPET 00000000cea73518 00038 (v01  INTEL   DZ77GA 0000002B ^.^  =
00000005)
ACPI: SSDT 00000000cea73550 0036D (v01 SataRe SataTabl 00001000 INTL =
20091112)
ACPI: SSDT 00000000cea738c0 009AA (v01  PmRef  Cpu0Ist 00003000 INTL =
20051117)
ACPI: SSDT 00000000cea74270 00A92 (v01  PmRef    CpuPm 00003000 INTL =
20051117)
ACPI: DMAR 00000000cea74d08 00080 (v01 INTEL      SNB  00000001 INTL =
00000001)
No NUMA configuration found
Faking a node at [mem 0x0000000000000000-0x000000012effffff]
Initmem setup node 0 [mem 0x00000000-0x12effffff]
  NODE_DATA [mem 0x12efd5000-0x12effbfff]
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x12effffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009cfff]
  node   0: [mem 0x00100000-0xce8c2fff]
  node   0: [mem 0xcead3000-0xceb55fff]
  node   0: [mem 0xceea4000-0xceea4fff]
  node   0: [mem 0xceee8000-0xcf7fffff]
  node   0: [mem 0x100000000-0x12effffff]
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a701 base: 0xfed00000
smpboot: Allowing 8 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
PM: Registered nosave memory: [mem 0xce8c3000-0xcea68fff]
PM: Registered nosave memory: [mem 0xcea69000-0xcea74fff]
PM: Registered nosave memory: [mem 0xcea75000-0xceacdfff]
PM: Registered nosave memory: [mem 0xceace000-0xcead2fff]
PM: Registered nosave memory: [mem 0xceb56000-0xcebe8fff]
PM: Registered nosave memory: [mem 0xcebe9000-0xceea3fff]
PM: Registered nosave memory: [mem 0xceea5000-0xceee7fff]
PM: Registered nosave memory: [mem 0xcf800000-0xefffffff]
PM: Registered nosave memory: [mem 0xf0000000-0xf7ffffff]
PM: Registered nosave memory: [mem 0xf8000000-0xfebfffff]
PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
e820: [mem 0xcf800000-0xefffffff] available for PCI devices
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 28 pages/cpu @ffff88012ec00000 s83392 r8192 d23104 =
u262144
Built 1 zonelists in Node order, mobility grouping on.  Total pages: =
1026636
Policy zone: Normal
Kernel command line: ro root=3D/dev/mapper/vg_n0647-lv_root =
rd_LVM_LV=3Dvg_n0647/lv_swap LANG=3Den_US.UTF-8 =
rd_LVM_LV=3Dvg_n0647/lv_root rd_NO_MD SYSFONT=3Dlatarcyrheb-sun16 =
rd_NO_LUKS KEYBOARDTYPE=3Dpc KEYTABLE=3Dus rd_NO_DM  biosdevname=3D0 =
console=3DttyS0,115200
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave: enabled xstate_bv 0x7, cntxt size 0x340
Checking aperture...
No AGP bridge found
Memory: 4007284K/4163564K available (4992K kernel code, 1021K rwdata, =
2372K rodata, 1868K init, 10056K bss, 156280K reserved)
Hierarchical RCU implementation.
	Additional per-CPU info printed with stalls.
	RCU restricting CPUs from NR_CPUS=3D4096 to nr_cpu_ids=3D8.
NR_IRQS:262400 nr_irqs:744 16
Console: colour VGA+ 80x25
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 5855 kB
 per task-struct memory footprint: 1920 bytes
tsc: Fast TSC calibration using PIT
tsc: Detected 3392.271 MHz processor
Calibrating delay loop (skipped), value calculated using timer =
frequency.. 6784.54 BogoMIPS (lpj=3D3392271)
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
Freeing SMP alternatives memory: 16K (ffffffff81cd4000 - =
ffffffff81cd8000)
ACPI: Core revision 20130725
ACPI: All ACPI Tables successfully acquired
ftrace: allocating 19321 entries in 76 pages
dmar: Host address width 36
dmar: DRHD base: 0x000000fed90000 flags: 0x1
dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap =
f010da
dmar: RMRR base: 0x000000cea48000 end: 0x000000cea64fff
IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
HPET id 0 under DRHD base 0xfed90000
Enabled IRQ remapping in x2apic mode
Enabling x2apic
Enabled x2apic
Switched APIC routing to cluster x2apic.
..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
smpboot: CPU0: Genuine Intel(R) CPU  @ 3.30GHz (fam: 06, model: 3a, =
stepping: 04)
Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, =
full-width counters, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             0000ffffffffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node   0, Processors  #   1NMI watchdog: enabled on all =
CPUs, permanently consumes one hw-PMU counter.

SMP alternatives: lockdep: fixing up alternatives
 #   2
SMP alternatives: lockdep: fixing up alternatives
 #   3
SMP alternatives: lockdep: fixing up alternatives
 #   4
SMP alternatives: lockdep: fixing up alternatives
 #   5
SMP alternatives: lockdep: fixing up alternatives
 #   6
SMP alternatives: lockdep: fixing up alternatives
 #   7 OK
Brought up 8 CPUs
smpboot: Total of 8 processors activated (54276.33 BogoMIPS)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xceb56000-0xcebe8fff] (602112 =
bytes)
PM: Registering ACPI NVS region [mem 0xceea5000-0xceee7fff] (274432 =
bytes)
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] =
(base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 00000000cea7e018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL =
20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL =
20051117)
ACPI: SSDT 00000000cea7fa98 00303 (v01  PmRef    ApIst 00003000 INTL =
20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL =
20051117)
ACPI: SSDT 00000000cea80c18 00119 (v01  PmRef    ApCst 00003000 INTL =
20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL =
20051117)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] =
(20130725/hwxface-571)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] =
(20130725/hwxface-571)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" =
and report a bug
ACPI: Power Resource [FN00] (off)
ACPI: Power Resource [FN01] (off)
ACPI: Power Resource [FN02] (off)
ACPI: Power Resource [FN03] (off)
ACPI: Power Resource [FN04] (off)
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
acpi PNP0A08:00: ACPI _OSC control (0x18) granted
ACPI: \_SB_.PCI0.TPMX: can't evaluate _ADR (0x5)
ACPI: \_SB_.PCI0.RLED: can't evaluate _ADR (0x5)
ACPI: \_SB_.PCI0.PDRC: can't evaluate _ADR (0x5)
ACPI: \_SB_.PCI0.WMI1: can't evaluate _ADR (0x5)
ACPI: \_SB_.PCI0.DOCK: can't evaluate _ADR (0x5)
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-7e]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfeafffff]
pci 0000:00:01.0: System wakeup disabled by ACPI
pci 0000:00:14.0: System wakeup disabled by ACPI
pci 0000:00:19.0: System wakeup disabled by ACPI
pci 0000:00:1a.0: System wakeup disabled by ACPI
pci 0000:00:1c.0: System wakeup disabled by ACPI
pci 0000:00:1c.4: System wakeup disabled by ACPI
pci 0000:00:1c.5: System wakeup disabled by ACPI
pci 0000:00:1c.7: System wakeup disabled by ACPI
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:02:00.0: System wakeup disabled by ACPI
pci 0000:00:1c.0: PCI bridge to [bus 02-32]
pci 0000:02:00.0: PCI bridge to [bus 03-32]
pci 0000:03:00.0: PCI bridge to [bus 04]
pci 0000:03:03.0: PCI bridge to [bus 05-2f]
pci 0000:05:00.0: PCI bridge to [bus 06-2f]
pci 0000:06:03.0: PCI bridge to [bus 07-0a]
pci 0000:07:00.0: PCI bridge to [bus 08-0a]
pci 0000:08:01.0: PCI bridge to [bus 09]
pci 0000:08:02.0: PCI bridge to [bus 0a]
pci 0000:06:04.0: PCI bridge to [bus 0b-2e]
pci 0000:06:05.0: PCI bridge to [bus 2f]
pci 0000:03:04.0: PCI bridge to [bus 30]
pci 0000:03:05.0: PCI bridge to [bus 31]
pci 0000:03:06.0: PCI bridge to [bus 32]
pci 0000:33:00.0: System wakeup disabled by ACPI
pci 0000:00:1c.4: PCI bridge to [bus 33]
pci 0000:34:00.0: System wakeup disabled by ACPI
pci 0000:00:1c.5: PCI bridge to [bus 34-3b]
pci 0000:34:00.0: PCI bridge to [bus 35-3b]
pci 0000:35:01.0: PCI bridge to [bus 36]
pci 0000:35:04.0: PCI bridge to [bus 37]
pci 0000:35:05.0: PCI bridge to [bus 38]
pci 0000:35:07.0: PCI bridge to [bus 39]
pci 0000:35:09.0: PCI bridge to [bus 3a-3b]
pci 0000:3a:00.0: PCI bridge to [bus 3b]
pci 0000:3c:00.0: System wakeup disabled by ACPI
pci 0000:00:1c.7: PCI bridge to [bus 3c]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, =
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, =
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
ACPI: Enabled 5 GPEs in block 00 to 3F
vgaarb: device added: =
PCI:0000:01:00.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
SCSI subsystem initialized
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:07:00.0: address space collision: [mem 0xe7100000-0xe711ffff] =
conflicts with PCI Bus 0000:08 [mem 0xe7100000-0xe71fffff]
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switched to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
system 00:04: [io  0x0680-0x069f] has been reserved
system 00:04: [io  0x0200-0x020f] has been reserved
system 00:04: [io  0xffff] has been reserved
system 00:04: [io  0xffff] has been reserved
system 00:04: [io  0x0400-0x0453] could not be reserved
system 00:04: [io  0x0458-0x047f] has been reserved
system 00:04: [io  0x0500-0x057f] has been reserved
system 00:04: [io  0x164e-0x164f] has been reserved
system 00:06: [io  0x0454-0x0457] has been reserved
system 00:07: [io  0x0a00-0x0a0f] has been reserved
system 00:09: [io  0x04d0-0x04d1] has been reserved
system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0c: [mem 0xfed10000-0xfed17fff] has been reserved
system 00:0c: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:0c: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:0c: [mem 0xf0000000-0xf7ffffff] has been reserved
system 00:0c: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0c: [mem 0xfed90000-0xfed93fff] could not be reserved
system 00:0c: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
system 00:0c: [mem 0xfee00000-0xfeefffff] could not be reserved
system 00:0c: [mem 0xe2100000-0xe2100fff] has been reserved
pnp: PnP ACPI: found 13 devices
ACPI: bus type PNP unregistered
pci 0000:0a:00.0: no compatible bridge window for [mem =
0xe7180000-0xe71fffff pref]
pci 0000:0a:00.1: no compatible bridge window for [mem =
0xe7100000-0xe717ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:01.0:   bridge window [mem 0xe6000000-0xe70fffff]
pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xd9ffffff 64bit pref]
pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:04.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:03:04.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:05.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:03:05.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:06.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:03:06.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:00.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:04.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:05.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:06.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:06.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:03:06.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:06.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:05.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:03:05.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:05.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:04.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:03:04.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:04.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:00.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:03:00.0: BAR 13: can't assign io (size 0x1000)
pci 0000:03:00.0: PCI bridge to [bus 04]
pci 0000:03:00.0:   bridge window [mem 0xef000000-0xef0fffff]
pci 0000:06:05.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:06:05.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:06:05.0: BAR 13: can't assign io (size 0x1000)
pci 0000:06:05.0: BAR 14: can't assign mem (size 0x200000)
pci 0000:06:05.0: BAR 15: can't assign mem pref (size 0x200000)
pci 0000:06:05.0: BAR 13: can't assign io (size 0x1000)
pci 0000:07:00.0: BAR 0: can't assign mem (size 0x20000)
pci 0000:07:00.0: BAR 0: trying firmware assignment [mem =
0xe7100000-0xe711ffff]
pci 0000:07:00.0: BAR 0: [mem 0xe7100000-0xe711ffff] conflicts with PCI =
Bus 0000:08 [mem 0xe7100000-0xe71fffff]
pci 0000:07:00.0: BAR 0: can't assign mem (size 0x20000)
pci 0000:07:00.0: BAR 0: trying firmware assignment [mem =
0xe7100000-0xe711ffff]
pci 0000:07:00.0: BAR 0: [mem 0xe7100000-0xe711ffff] conflicts with PCI =
Bus 0000:08 [mem 0xe7100000-0xe71fffff]
pci 0000:08:02.0: BAR 14: can't assign mem (size 0x500000)
pci 0000:08:02.0: BAR 14: assigned [mem 0xe7100000-0xe71fffff]
pci 0000:08:02.0: BAR 14: can't assign mem (size 0x100000)
pci 0000:08:01.0: PCI bridge to [bus 09]
pci 0000:0a:00.0: BAR 6: assigned [mem 0xe7100000-0xe717ffff pref]
pci 0000:0a:00.1: BAR 6: assigned [mem 0xe7180000-0xe71fffff pref]
pci 0000:0a:00.0: BAR 7: can't assign mem (size 0x100000)
pci 0000:0a:00.0: BAR 10: can't assign mem (size 0x100000)
pci 0000:0a:00.1: BAR 7: can't assign mem (size 0x100000)
pci 0000:0a:00.1: BAR 10: can't assign mem (size 0x100000)
pci 0000:0a:00.0: BAR 6: assigned [mem 0xe7100000-0xe717ffff pref]
pci 0000:0a:00.1: BAR 6: assigned [mem 0xe7180000-0xe71fffff pref]
pci 0000:0a:00.1: BAR 10: can't assign mem (size 0x100000)
pci 0000:0a:00.1: BAR 7: can't assign mem (size 0x100000)
pci 0000:0a:00.0: BAR 10: can't assign mem (size 0x100000)
pci 0000:0a:00.0: BAR 7: can't assign mem (size 0x100000)
pci 0000:08:02.0: PCI bridge to [bus 0a]
pci 0000:08:02.0:   bridge window [io  0x5000-0x5fff]
pci 0000:08:02.0:   bridge window [mem 0xe7100000-0xe71fffff]
pci 0000:08:02.0:   bridge window [mem 0xda100000-0xda2fffff 64bit pref]
pci 0000:07:00.0: PCI bridge to [bus 08-0a]
pci 0000:07:00.0:   bridge window [io  0x5000-0x5fff]
pci 0000:07:00.0:   bridge window [mem 0xe7100000-0xe71fffff]
pci 0000:07:00.0:   bridge window [mem 0xda100000-0xda2fffff 64bit pref]
pci 0000:06:03.0: PCI bridge to [bus 07-0a]
pci 0000:06:03.0:   bridge window [io  0x5000-0x5fff]
pci 0000:06:03.0:   bridge window [mem 0xe7100000-0xe71fffff]
pci 0000:06:03.0:   bridge window [mem 0xda100000-0xda2fffff 64bit pref]
pci 0000:06:04.0: PCI bridge to [bus 0b-2e]
pci 0000:06:04.0:   bridge window [io  0x6000-0xafff]
pci 0000:06:04.0:   bridge window [mem 0xe7200000-0xeeffffff]
pci 0000:06:04.0:   bridge window [mem 0xda300000-0xe20fffff 64bit pref]
pci 0000:06:05.0: PCI bridge to [bus 2f]
pci 0000:05:00.0: PCI bridge to [bus 06-2f]
pci 0000:05:00.0:   bridge window [io  0x5000-0xafff]
pci 0000:05:00.0:   bridge window [mem 0xe7100000-0xeeffffff]
pci 0000:05:00.0:   bridge window [mem 0xda100000-0xe20fffff 64bit pref]
pci 0000:03:03.0: PCI bridge to [bus 05-2f]
pci 0000:03:03.0:   bridge window [io  0x5000-0xafff]
pci 0000:03:03.0:   bridge window [mem 0xe7100000-0xeeffffff]
pci 0000:03:03.0:   bridge window [mem 0xda100000-0xe20fffff 64bit pref]
pci 0000:03:04.0: PCI bridge to [bus 30]
pci 0000:03:05.0: PCI bridge to [bus 31]
pci 0000:03:06.0: PCI bridge to [bus 32]
pci 0000:02:00.0: PCI bridge to [bus 03-32]
pci 0000:02:00.0:   bridge window [io  0x5000-0xafff]
pci 0000:02:00.0:   bridge window [mem 0xe7100000-0xef0fffff]
pci 0000:02:00.0:   bridge window [mem 0xda100000-0xe20fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 02-32]
pci 0000:00:1c.0:   bridge window [io  0x5000-0xafff]
pci 0000:00:1c.0:   bridge window [mem 0xe7100000-0xef0fffff]
pci 0000:00:1c.0:   bridge window [mem 0xda100000-0xe20fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 33]
pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.4:   bridge window [mem 0xef400000-0xef4fffff]
pci 0000:35:01.0: PCI bridge to [bus 36]
pci 0000:35:04.0: PCI bridge to [bus 37]
pci 0000:35:04.0:   bridge window [io  0xc000-0xcfff]
pci 0000:35:04.0:   bridge window [mem 0xef100000-0xef1fffff]
pci 0000:35:05.0: PCI bridge to [bus 38]
pci 0000:35:07.0: PCI bridge to [bus 39]
pci 0000:3a:00.0: PCI bridge to [bus 3b]
pci 0000:35:09.0: PCI bridge to [bus 3a-3b]
pci 0000:34:00.0: PCI bridge to [bus 35-3b]
pci 0000:34:00.0:   bridge window [io  0xc000-0xcfff]
pci 0000:34:00.0:   bridge window [mem 0xef100000-0xef1fffff]
pci 0000:00:1c.5: PCI bridge to [bus 34-3b]
pci 0000:00:1c.5:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.5:   bridge window [mem 0xef100000-0xef2fffff]
pci 0000:00:1c.7: PCI bridge to [bus 3c]
pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.7:   bridge window [mem 0xef300000-0xef3fffff]
pci_bus 0000:00: Some PCI device resources are unassigned, try booting =
with pci=3Drealloc
NET: Registered protocol family 2
TCP established hash table entries: 32768 (order: 7, 524288 bytes)
TCP bind hash table entries: 32768 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP: reno registered
UDP hash table entries: 2048 (order: 6, 327680 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 6108K (ffff8800379f9000 - ffff880037ff0000)
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xca8c3000-0xce8c3000] (64MB) mapped at =
[ffff8800ca8c3000-ffff8800ce8c2fff]
audit: initializing netlink socket (disabled)
type=3D2000 audit(1383040300.337:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7838
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: driver skip pci_set_master, fix it!
pcieport 0000:00:1c.5: driver skip pci_set_master, fix it!
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
kobject: 'pciehp_dummy' (ffff88012787ba00): kobject_release, parent =
ffff880127812a48 (delayed)
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
input: Power Button as =
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: Fan [FAN0] (off)
ACPI: Fan [FAN1] (off)
ACPI: Fan [FAN2] (off)
ACPI: Fan [FAN3] (off)
ACPI: Fan [FAN4] (off)
ACPI: Requesting acpi_cpufreq
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (28 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (30 C)
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
kobject: 'agpgart-amd64' (ffff880127900400): kobject_release, parent =
ffff880129434248 (delayed)
brd: module loaded
loop: module loaded
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1a.0: EHCI Host Controller
ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1a.0: debug port 2
ehci-pci 0000:00:1a.0: irq 16, io mem 0xef534000
ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.12.0-rc7-mdr+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci-pci 0000:00:1d.0: EHCI Host Controller
ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci-pci 0000:00:1d.0: debug port 2
ehci-pci 0000:00:1d.0: irq 23, io mem 0xef533000
ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.12.0-rc7-mdr+ ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
kobject: 'i8042 kbd' (ffff8801279d2c00): kobject_release, parent =
ffff880129649648 (delayed)
kobject: 'i8042 aux' (ffff8801279d2a00): kobject_release, parent =
ffff880129649648 (delayed)
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
kobject: '(null)' (ffff880127f4db08): kobject_release, parent           =
(null) (delayed)
drop_monitor: Initializing network drop monitor service
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
rtc_cmos 00:05: setting system clock to 2013-10-29 09:51:42 UTC =
(1383040302)
kobject: '(null)' (ffff880127f51308): kobject_release, parent           =
(null) (delayed)
Freeing unused kernel memory: 1868K (ffffffff81b01000 - =
ffffffff81cd4000)
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1140K (ffff8800014e3000 - =
ffff880001600000)
Freeing unused kernel memory: 1724K (ffff880001851000 - =
ffff880001a00000)
dracut: dracut-004-303.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised: =
dm-devel@redhat.com
udev: starting version 147
udevd (106): /proc/106/oom_adj is deprecated, please use =
/proc/106/oom_score_adj instead.
wmi: Mapper loaded
[drm] Initialized drm 1.1.0 20060810
MXM: GUID detected in BIOS
nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0d9000a1
nouveau  [  DEVICE][0000:01:00.0] Chipset: GF119 (NVD9)
nouveau  [  DEVICE][0000:01:00.0] Family : NVD0
nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
usb 1-1: new high-speed USB device number 2 using ehci-pci
nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
nouveau  [   VBIOS][0000:01:00.0] BIT signature found
nouveau  [   VBIOS][0000:01:00.0] version 75.19.1b.00.01
nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D0024
usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
nouveau  [  PTHERM][0000:01:00.0] FAN control: PWM
nouveau  [  PTHERM][0000:01:00.0] fan management: disabled
nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[TTM] Zone  kernel: Available graphics memory: 2009070 kiB
[TTM] Initializing pool allocator
[TTM] Initializing DMA pool allocator
nouveau  [     DRM] VRAM: 1024 MiB
nouveau  [     DRM] GART: 1048576 MiB
nouveau  [     DRM] TMDS table version 2.0
nouveau  [     DRM] DCB version 4.0
nouveau  [     DRM] DCB outp 00: 02000300 00000000
nouveau  [     DRM] DCB outp 01: 01000302 00020030
nouveau  [     DRM] DCB outp 02: 02011362 00020010
nouveau  [     DRM] DCB outp 03: 04022310 00000000
nouveau  [     DRM] DCB conn 00: 00001030
nouveau  [     DRM] DCB conn 01: 00002161
nouveau  [     DRM] DCB conn 02: 00000200
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
nouveau  [     DRM] 2 available performance level(s)
nouveau  [     DRM] 1: core 270MHz shader 540MHz memory 405MHz voltage =
900mV
nouveau  [     DRM] 3: core 810MHz shader 1620MHz memory 700MHz voltage =
1040mV
usb 2-1: new high-speed USB device number 2 using ehci-pci
nouveau  [     DRM] c: core 270MHz shader 540MHz memory 405MHz voltage =
900mV fanspeed 40%
nouveau  [     DRM] MM: using COPY0 for buffer copies
nouveau  [     DRM] allocated 1920x1200 fb: 0x60000, bo ffff8800ca4ae400
fbcon: nouveaufb (fb0) is primary device
usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D0024
usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
Console: switching to colour frame buffer device 240x75
nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
nouveau 0000:01:00.0: registered panic notifier
tsc: Refined TSC clocksource calibration: 3392.295 MHz
[drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 on minor 0
dracut: Starting plymouth daemon
Gahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x28 impl =
SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst=20
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: DUMMY
ata2: DUMMY
ata3: DUMMY
ata4: SATA max UDMA/133 abar m2048@0xef532000 port 0xef532280 irq 61
ata5: DUMMY
ata6: SATA max UDMA/133 abar m2048@0xef532000 port 0xef532380 irq 61
ahci 0000:37:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA =
mode
ahci 0000:37:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part =
sxs=20
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 abar m512@0xef120000 port 0xef120100 irq 62
ata8: SATA max UDMA/133 abar m512@0xef120000 port 0xef120180 irq 62
pcieport 0000:00:1c.7: driver skip pci_set_master, fix it!
ahci 0000:3c:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA =
mode
ahci 0000:3c:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part =
sxs=20
scsi8 : ahci
scsi9 : ahci
ata9: SATA max UDMA/133 abar m512@0xef320000 port 0xef320100 irq 63
ata10: SATA max UDMA/133 abar m512@0xef320000 port 0xef320180 irq 63
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered =
out
ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) =
filtered out
ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered =
out
ata7: SATA link down (SStatus 0 SControl 300)
ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) =
filtered out
ata8: SATA link down (SStatus 0 SControl 300)
ata4.00: ATAPI: ATAPI   iHAS124   Y, BL0V, max UDMA/100
ata6.00: ATA-8: INTEL SSDSC2MH250A2, PWG4, max UDMA/133
ata6.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered =
out
ata9: SATA link down (SStatus 0 SControl 300)
ata10: SATA link down (SStatus 0 SControl 300)
ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) =
filtered out
ata6.00: configured for UDMA/133
ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered =
out
ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) =
filtered out
ata4.00: configured for UDMA/100
scsi 3:0:0:0: CD-ROM            ATAPI    iHAS124   Y      BL0V PQ: 0 =
ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      INTEL SSDSC2MH25 PWG4 PQ: 0 =
ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sd 5:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 5:0:0:0: [sda] Write Protect is off
sd 5:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA
 sda: sda1 sda2
sd 5:0:0:0: [sda] Attached SCSI disk
FATAL: Module scsi_wait_scan not found.
dracut: Scanning devices sda2  for LVM logical volumes vg_n0647/lv_swap =
vg_n0647/lv_root=20
dracut: inactive '/dev/vg_n0647/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_n0647/lv_home' [178.55 GiB] inherit
dracut: inactive '/dev/vg_n0647/lv_swap' [3.84 GiB] inherit
bio: create slab <bio-1> at 1
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/mapper/vg_n0647-lv_root
dracut: /sbin/load_policy: Can't load policy: No such device
dracut: Switching root
readahead: starting
		Welcome to Red Hat Enterprise Linux Server
Starting udev: Switched to clocksource tsc
udev: starting version 147
WARNING! power/level is deprecated; use power/control instead
Gpps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti =
<giometti@linux.it>
PTP clock support registered
e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic =
conservative mode
e1000e 0000:00:19.0 eth0: registered PHC clock
e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) =
00:22:4d:81:9f:8d
e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
e1000e 0000:33:00.0: Disabling ASPM L0s L1
pcieport 0000:00:1c.4: driver skip pci_set_master, fix it!
e1000e 0000:33:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic =
conservative mode
e1000e 0000:33:00.0 eth1: registered PHC clock
e1000e 0000:33:00.0 eth1: (PCI Express:2.5GT/s:Width x1) =
00:22:4d:81:9f:8e
e1000e 0000:33:00.0 eth1: Intel(R) PRO/1000 Network Connection
e1000e 0000:33:00.0 eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
xhci_hcd 0000:00:14.0: xHCI Host Controller
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: xHCI Host Controller
usb usb3: Manufacturer: Linux 3.12.0-rc7-mdr+ xhci_hcd
usb usb3: SerialNumber: 0000:00:14.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 4 ports detected
xhci_hcd 0000:00:14.0: xHCI Host Controller
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0003
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: xHCI Host Controller
usb usb4: Manufacturer: Linux 3.12.0-rc7-mdr+ xhci_hcd
usb usb4: SerialNumber: 0000:00:14.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 4 ports detected
ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts =
with Region \PMIO 1 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it =
instead of the native driver
ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts =
with Region \GPIO 1 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it =
instead of the native driver
ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts =
with Region \GPIO 1 (20130725/utaddress-251)
ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts =
with Region \_SB_.PCI0.RLED.DBG0 2 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it =
instead of the native driver
lpc_ich: Resource conflict(s) found affecting gpio_ich
input: PC Speaker as /devices/platform/pcspkr/input/input2
ACPI Warning: 0x000000000000f000-0x000000000000f01f SystemIO conflicts =
with Region \_SB_.PCI0.SBUS.SMBI 1 (20130725/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it =
instead of the native driver
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
microcode: CPU0 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8800c58a28d8): kobject_release, =
parent           (null) (delayed)
microcode: CPU1 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 837 at /root/git/linux/include/linux/kref.h:47 =
kobject_get+0x42/0x50()
Modules linked in: microcode(+) shpchp i2c_i801 pcspkr lpc_ich mfd_core =
xhci_hcd e1000e ptp pps_core acpi_cpufreq freq_table ext4 jbd2 mbcache =
sd_mod sr_mod cdrom ahci libahci nouveau ttm drm_kms_helper drm =
i2c_algo_bit i2c_core mxm_wmi video wmiusb 4-1: new SuperSpeed USB =
device number 2 using xhci_hcd
 dm_mirror dm_region_hash dm_log dm_mod
CPU: 0 PID: 837 Comm: modprobe Not tainted 3.12.0-rc7-mdr+ #5
Hardware name:                  /DZ77RE-75K, BIOS =
GAZ7711H.86A.0043.2012.0524.1602 05/24/2012
 000000000000002f ffff8800c7841a38 ffffffff814d4f7e 000000000000002f
 0000000000000000 ffff8800c7841a78 ffffffff8104ccfc ffffffff826aad48usb =
4-1: New USB device found, idVendor=3D05e3, idProduct=3D0612
usb 4-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 4-1: Product: USB3.0 Hub 123
usb 4-1: Manufacturer: GenesysLogic

 ffff8800c6d39020 ffff8800c6d39010 ffff8800c58a20c8 00000000ffffffea
Call Trace:
 [<ffffffff814d4f7e>] dump_stack+0x59/0x7b
 [<ffffffff8104ccfc>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104cd4a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8124f9f2>] kobject_get+0x42/0x50
 [<ffffffff81333edc>] get_device_parent+0xcc/0x230
 [<ffffffff81334358>] device_add+0xb8/0x500
 [<ffffffff813326c1>] ? dev_set_name+0x41/0x50
 [<ffffffff81346b00>] _request_firmware_load+0x50/0x260
 [<ffffffff81347e38>] _request_firmware+0x158/0x1c0
 [<ffffffff81347f3f>] request_firmware+0x3f/0x60
hub 4-1:1.0: USB hub found
 [<ffffffffa03efb90>] request_microcode_fw+0x70/0xf0 [microcode]
hub 4-1:1.0: 3 ports detected
 [<ffffffffa03ef574>] microcode_init_cpu+0xf4/0x130 [microcode]
 [<ffffffffa03ef62d>] mc_device_add+0x7d/0xb0 [microcode]
 [<ffffffff81334eb9>] subsys_interface_register+0xb9/0xf0
 [<ffffffffa040b000>] ? 0xffffffffa040afff
 [<ffffffffa040b000>] ? 0xffffffffa040afff
 [<ffffffffa040b0b8>] microcode_init+0xb8/0x1b4 [microcode]
 [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
 [<ffffffff81079d25>] ? __blocking_notifier_call_chain+0x65/0x80
 [<ffffffff810c7154>] do_init_module+0x44/0x1b0
 [<ffffffff810c8f2a>] load_module+0x50a/0x620
 [<ffffffff810c67c0>] ? mod_sysfs_teardown+0x150/0x150
 [<ffffffff810c5dc0>] ? module_sect_show+0x30/0x30
 [<ffffffff810c9217>] SyS_init_module+0xe7/0x130
 [<ffffffff814dbf12>] system_call_fastpath+0x16/0x1b
---[ end trace 298aac36b4f59bf2 ]---
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8800c58a20d8): kobject_release, =
parent           (null) (delayed)
microcode: CPU2 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8801288d98d8): kobject_release, =
parent           (null) (delayed)
microcode: CPU3 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8801289680d8): kobject_release, =
parent           (null) (delayed)
microcode: CPU4 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8800c7ad58d8): kobject_release, =
parent           (null) (delayed)
microcode: CPU5 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8800c7ad50d8): kobject_release, =
parent           (null) (delayed)
microcode: CPU6 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8800c7a728d8): kobject_release, =
parent           (null) (delayed)
microcode: CPU7 sig=3D0x306a4, pf=3D0x2, revision=3D0x0
usb 4-4: new SuperSpeed USB device number 3 using xhci_hcd
kobject: 'firmware' (ffff8800ca787c00): kobject_release, parent =
ffff8800c6d39020 (delayed)
kobject: 'intel-ucode!06-3a-04' (ffff8800c58288d8): kobject_release, =
parent           (null) (delayed)
BUG: unable to handle kernel NULL pointer dereference at =
0000000000000018
IP: [<ffffffff81059ed8>] get_next_timer_interrupt+0x168/0x240
PGD 37a62067 PUD c5852067 PMD 0=20
Oops: 0000 [#1] SMP=20
Modules linked in: microcode(+) shpchp i2c_i801 pcspkr lpc_ich mfd_core =
xhci_hcd e1000e ptp pps_core acpi_cpufreq freq_table ext4 jbd2 mbcache =
sd_mod sr_mod cdrom ahci libahci nouveau ttm drm_kms_helper drm =
i2c_algo_bit i2c_core mxm_wmi video wmi dm_mirror dm_region_hash dm_log =
dm_mod
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W    3.12.0-rc7-mdr+ #5
Hardware name:                  /DZ77RE-75K, BIOS =
GAZ7711H.86A.0043.2012.0524.1602 05/24/2012
task: ffffffff81a104c0 ti: ffffffff81a00000 task.ti: ffffffff81a00000
RIP: 0010:[<ffffffff81059ed8>]  [<ffffffff81059ed8>] =
get_next_timer_interrupt+0x168/0x240
RSP: 0018:ffffffff81a01d88  EFLAGS: 00010013
RAX: 0000000000000000 RBX: ffffffff81d39888 RCX: ffffffff81d39858
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff81d39858
RBP: ffffffff81a01de8 R08: 000000000000003f R09: 0000000000fffb7f
R10: ffffffff81a01da0 R11: ffffffff81a01db8 R12: 000000013ffb7e8a
R13: 00000000fffb7e8b R14: ffffffff81d38800 R15: 0000000000000040
FS:  0000000000000000(0000) GS:ffff88012ec00000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 00000000c584f000 CR4: 00000000001407f0
Stack:
 ffffffff81a01da8 ffffffff810b9515 ffffffff81d39858 ffffffff81d39c58
 ffffffff81d3a058 ffffffff81d3a458 ffffffff81a10d98 ffff88012ec0db00
 00000000fffb7e8b 0000000000000000 ffff88012ec0cfc0 000000000000183a
Call Trace:
 [<ffffffff810b9515>] ? trace_hardirqs_on_caller+0x105/0x1d0
 [<ffffffff810b3755>] tick_nohz_stop_sched_tick+0x1d5/0x330
 [<ffffffff810b3956>] __tick_nohz_idle_enter+0xa6/0x140
 [<ffffffff810b3a67>] tick_nohz_idle_enter+0x37/0x70
 [<ffffffff810a2149>] cpu_idle_loop+0x39/0x250
 [<ffffffff810a23d0>] cpu_startup_entry+0x70/0x80
 [<ffffffff814d2898>] rest_init+0xd8/0xf0
 [<ffffffff814d27c0>] ? csum_partial_copy_generic+0x170/0x170
 [<ffffffff81b171e9>] start_kernel+0x425/0x432
 [<ffffffff81b16be2>] ? repair_env_string+0x5b/0x5b
 [<ffffffff81b165a3>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81b166df>] x86_64_start_kernel+0x13a/0x141
Code: 45 c8 45 89 c8 41 83 e0 3f 44 89 c6 0f 1f 80 00 00 00 00 48 63 ce =
48 c1 e1 04 48 8b 04 39 48 8d 0c 0f 48 39 c8 74 22 0f 1f 40 00 <f6> 40 =
18 01 75 10 48 8b 50 10 48 39 da 48 0f 48 da ba 01 00 00=20
RIP  [<ffffffff81059ed8>] get_next_timer_interrupt+0x168/0x240
 RSP <ffffffff81a01d88>
CR2: 0000000000000018
---[ end trace 298aac36b4f59bf3 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
drm_kms_helper: panic occurred, switching back to text console
BUG: spinlock lockup suspected on CPU#0, swapper/0/0
 lock: boot_tvec_bases+0x0/0x2080, .magic: dead4ead, .owner: =
swapper/0/0, .owner_cpu: 0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W    3.12.0-rc7-mdr+ #5
Hardware name:                  /DZ77RE-75K, BIOS =
GAZ7711H.86A.0043.2012.0524.1602 05/24/2012
 ffffffff81a104c0 ffff88012ec03d90 ffffffff814d4f7e 0000000000000000
 ffffffff81d38800 ffff88012ec03db0 ffffffff81262438 ffffffff81d38800
 00000000ca31f298 ffff88012ec03de0 ffffffff81262686 0000000000000001
Call Trace:
 <IRQ>  [<ffffffff814d4f7e>] dump_stack+0x59/0x7b
 [<ffffffff81262438>] spin_dump+0x78/0xc0
 [<ffffffff81262686>] do_raw_spin_lock+0x126/0x160
 [<ffffffff814da5df>] _raw_spin_lock_irq+0x4f/0x60
 [<ffffffff8105aae8>] ? run_timer_softirq+0x48/0x2c0
 [<ffffffff8105aae8>] run_timer_softirq+0x48/0x2c0
 [<ffffffff812552b0>] ? timerqueue_add+0x60/0xb0
 [<ffffffff810aa764>] ? ktime_get+0x54/0xe0
 [<ffffffff81051f57>] __do_softirq+0x137/0x2e0
 [<ffffffff814dd78c>] call_softirq+0x1c/0x30
 [<ffffffff81005fcd>] do_softirq+0x8d/0xc0
 [<ffffffff81051af5>] irq_exit+0xd5/0xe0
 [<ffffffff814ddf0a>] smp_apic_timer_interrupt+0x4a/0x60
 [<ffffffff814dcb6f>] apic_timer_interrupt+0x6f/0x80
 <EOI>  [<ffffffff81175dd8>] ? cache_grow+0x258/0x2f0
 [<ffffffff81175ddc>] ? cache_grow+0x25c/0x2f0
 [<ffffffff81175dd8>] ? cache_grow+0x258/0x2f0
 [<ffffffff81176118>] cache_alloc_refill+0x2a8/0x310
 [<ffffffff81176f10>] __kmalloc+0x150/0x240
 [<ffffffffa00cc31d>] ? drm_crtc_helper_set_config+0x22d/0xc00 =
[drm_kms_helper]
 [<ffffffffa00cc31d>] drm_crtc_helper_set_config+0x22d/0xc00 =
[drm_kms_helper]
 [<ffffffff810b552d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff814dae77>] ? _raw_spin_unlock_irqrestore+0x67/0x70
 [<ffffffffa017872c>] nouveau_crtc_set_config+0x6c/0x140 [nouveau]
 [<ffffffffa0073892>] drm_mode_set_config_internal+0x62/0xf0 [drm]
 [<ffffffffa00c9b73>] drm_fb_helper_restore_fbdev_mode+0xb3/0xe0 =
[drm_kms_helper]
 [<ffffffffa00c9ca8>] drm_fb_helper_panic+0x78/0xa0 [drm_kms_helper]
 [<ffffffff81079825>] notifier_call_chain+0x55/0x80
 [<ffffffff81079ac2>] __atomic_notifier_call_chain+0x82/0xc0
 [<ffffffff81079a40>] ? srcu_notifier_call_chain+0x20/0x20
 [<ffffffff81032fc0>] ? clear_local_APIC+0x120/0x2b0
 [<ffffffff81079b16>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff814d4cff>] panic+0xe4/0x1df
 [<ffffffff8104efdd>] do_exit+0x44d/0x470
 [<ffffffff81007649>] oops_end+0xa9/0xf0
 [<ffffffff81040d0e>] no_context+0x11e/0x1f0
 [<ffffffff81040f0d>] __bad_area_nosemaphore+0x12d/0x230
 [<ffffffff81041023>] bad_area_nosemaphore+0x13/0x20
 [<ffffffff810413e4>] __do_page_fault+0xc4/0x440
 [<ffffffff810ba7c5>] ? __lock_acquire+0x315/0x580
 [<ffffffff810ba7c5>] ? __lock_acquire+0x315/0x580
 [<ffffffff8125a39d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8104176e>] do_page_fault+0xe/0x10
 [<ffffffff814db6e2>] page_fault+0x22/0x30
 [<ffffffff81059ed8>] ? get_next_timer_interrupt+0x168/0x240
 [<ffffffff81059dc3>] ? get_next_timer_interrupt+0x53/0x240
 [<ffffffff810b9515>] ? trace_hardirqs_on_caller+0x105/0x1d0
 [<ffffffff810b3755>] tick_nohz_stop_sched_tick+0x1d5/0x330
 [<ffffffff810b3956>] __tick_nohz_idle_enter+0xa6/0x140
 [<ffffffff810b3a67>] tick_nohz_idle_enter+0x37/0x70
 [<ffffffff810a2149>] cpu_idle_loop+0x39/0x250
 [<ffffffff810a23d0>] cpu_startup_entry+0x70/0x80
 [<ffffffff814d2898>] rest_init+0xd8/0xf0
 [<ffffffff814d27c0>] ? csum_partial_copy_generic+0x170/0x170
 [<ffffffff81b171e9>] start_kernel+0x425/0x432
 [<ffffffff81b16be2>] ? repair_env_string+0x5b/0x5b
 [<ffffffff81b165a3>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81b166df>] x86_64_start_kernel+0x13a/0x141
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W    3.12.0-rc7-mdr+ #5
Hardware name:                  /DZ77RE-75K, BIOS =
GAZ7711H.86A.0043.2012.0524.1602 05/24/2012
task: ffffffff81a104c0 ti: ffffffff81a00000 task.ti: ffffffff81a00000
RIP: 0010:[<ffffffff8125ebac>]  [<ffffffff8125ebac>] =
find_next_bit+0x3c/0xb0
RSP: 0018:ffff88012ec03d20  EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffff880129eec600 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000008 RDI: 0000000000000008
RBP: ffff88012ec03d20 R08: ffff880129eec600 R09: 0000000000000000
R10: 0000000000001fe0 R11: 0000000000001fe0 R12: ffff880129eec800
R13: 0000000000080000 R14: 000000000000d080 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88012ec00000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 00000000c584f000 CR4: 00000000001407f0
Stack:
 ffff88012ec03d80 ffffffff81039191 0000000000000086 00000002814d4ef0
 000000000000d088 0000000100000000 ffff88012ec03d60 0000000000000000
 00000000ca31f298 00000000ca31f298 ffffffff81d39858 0000000000000104
Call Trace:
 <IRQ>=20
 [<ffffffff81039191>] __x2apic_send_IPI_mask+0xa1/0x1a0
 [<ffffffff810392ac>] x2apic_send_IPI_all+0x1c/0x20
 [<ffffffff810350dc>] arch_trigger_all_cpu_backtrace+0x6c/0xb0
 [<ffffffff8126268b>] do_raw_spin_lock+0x12b/0x160
 [<ffffffff814da5df>] _raw_spin_lock_irq+0x4f/0x60
 [<ffffffff8105aae8>] ? run_timer_softirq+0x48/0x2c0
 [<ffffffff8105aae8>] run_timer_softirq+0x48/0x2c0
 [<ffffffff812552b0>] ? timerqueue_add+0x60/0xb0
 [<ffffffff810aa764>] ? ktime_get+0x54/0xe0
 [<ffffffff81051f57>] __do_softirq+0x137/0x2e0
 [<ffffffff814dd78c>] call_softirq+0x1c/0x30
 [<ffffffff81005fcd>] do_softirq+0x8d/0xc0
 [<ffffffff81051af5>] irq_exit+0xd5/0xe0
 [<ffffffff814ddf0a>] smp_apic_timer_interrupt+0x4a/0x60
 [<ffffffff814dcb6f>] apic_timer_interrupt+0x6f/0x80
 <EOI>=20
 [<ffffffff81175dd8>] ? cache_grow+0x258/0x2f0
 [<ffffffff81175ddc>] ? cache_grow+0x25c/0x2f0
 [<ffffffff81175dd8>] ? cache_grow+0x258/0x2f0
 [<ffffffff81176118>] cache_alloc_refill+0x2a8/0x310
 [<ffffffff81176f10>] __kmalloc+0x150/0x240
 [<ffffffffa00cc31d>] ? drm_crtc_helper_set_config+0x22d/0xc00 =
[drm_kms_helper]
 [<ffffffffa00cc31d>] drm_crtc_helper_set_config+0x22d/0xc00 =
[drm_kms_helper]
 [<ffffffff810b552d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff814dae77>] ? _raw_spin_unlock_irqrestore+0x67/0x70
 [<ffffffffa017872c>] nouveau_crtc_set_config+0x6c/0x140 [nouveau]
 [<ffffffffa0073892>] drm_mode_set_config_internal+0x62/0xf0 [drm]
 [<ffffffffa00c9b73>] drm_fb_helper_restore_fbdev_mode+0xb3/0xe0 =
[drm_kms_helper]
 [<ffffffffa00c9ca8>] drm_fb_helper_panic+0x78/0xa0 [drm_kms_helper]
 [<ffffffff81079825>] notifier_call_chain+0x55/0x80
 [<ffffffff81079ac2>] __atomic_notifier_call_chain+0x82/0xc0
 [<ffffffff81079a40>] ? srcu_notifier_call_chain+0x20/0x20
 [<ffffffff81032fc0>] ? clear_local_APIC+0x120/0x2b0
 [<ffffffff81079b16>] atomic_notifier_call_chain+0x16/0x20
 [<ffffffff814d4cff>] panic+0xe4/0x1df
 [<ffffffff8104efdd>] do_exit+0x44d/0x470
 [<ffffffff81007649>] oops_end+0xa9/0xf0
 [<ffffffff81040d0e>] no_context+0x11e/0x1f0
 [<ffffffff81040f0d>] __bad_area_nosemaphore+0x12d/0x230
 [<ffffffff81041023>] bad_area_nosemaphore+0x13/0x20
 [<ffffffff810413e4>] __do_page_fault+0xc4/0x440
 [<ffffffff810ba7c5>] ? __lock_acquire+0x315/0x580
 [<ffffffff810ba7c5>] ? __lock_acquire+0x315/0x580
 [<ffffffff8125a39d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8104176e>] do_page_fault+0xe/0x10
 [<ffffffff814db6e2>] page_fault+0x22/0x30
 [<ffffffff81059ed8>] ? get_next_timer_interrupt+0x168/0x240
 [<ffffffff81059dc3>] ? get_next_timer_interrupt+0x53/0x240
 [<ffffffff810b9515>] ? trace_hardirqs_on_caller+0x105/0x1d0
 [<ffffffff810b3755>] tick_nohz_stop_sched_tick+0x1d5/0x330
 [<ffffffff810b3956>] __tick_nohz_idle_enter+0xa6/0x140
 [<ffffffff810b3a67>] tick_nohz_idle_enter+0x37/0x70
 [<ffffffff810a2149>] cpu_idle_loop+0x39/0x250
 [<ffffffff810a23d0>] cpu_startup_entry+0x70/0x80
 [<ffffffff814d2898>] rest_init+0xd8/0xf0
 [<ffffffff814d27c0>] ? csum_partial_copy_generic+0x170/0x170
 [<ffffffff81b171e9>] start_kernel+0x425/0x432
 [<ffffffff81b16be2>] ? repair_env_string+0x5b/0x5b
 [<ffffffff81b165a3>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81b166df>] x86_64_start_kernel+0x13a/0x141
Code: 89 d1 49 89 d1 48 c1 e9 06 49 83 e1 c0 4c 8d 04 cf 48 89 f7 4c 29 =
cf 83 e2 3f 74 3f 48 c7 c0 ff ff ff ff 89 d1 48 d3 e0 49 23 00 <48> 83 =
ff 3f 76 3e 48 85 c0 75 4f 49 83 c0 08 48 83 ef 40 49 83=20
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long =
to run: 404.672 msecs


--Apple-Mail=_BCF13790-841E-45E0-92BA-A00F1D7D1256
Content-Disposition: attachment;
	filename=crash.config
Content-Type: application/octet-stream;
	name="crash.config"
Content-Transfer-Encoding: 7bit

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 3.12.0-rc7 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION="-mdr"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
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
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=19
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
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
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
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
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
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
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_UV is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_HYPERVISOR_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
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
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
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
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

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
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=m
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
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
CONFIG_HOTPLUG_PCI_PCIE=y
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
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
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
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=m
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
CONFIG_NF_CT_PROTO_UDPLITE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=m
# CONFIG_NF_CT_NETLINK_TIMEOUT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE_CT is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LOG is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_ECN=m
# CONFIG_IP_NF_MATCH_RPFILTER is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_SYNPROXY is not set
CONFIG_IP_NF_TARGET_ULOG=m
# CONFIG_NF_NAT_IPV4 is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
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
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
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
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=m
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_INGRESS=m
# CONFIG_NET_SCH_PLUG is not set

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
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
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
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
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
# CONFIG_ATMEL_SSC is not set
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
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
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
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
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
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_HIGHBANK is not set
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
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
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
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
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
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
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_RAID=m
CONFIG_DM_LOG_USERSPACE=m
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=m
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

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
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
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
CONFIG_IXGBEVF=m
# CONFIG_I40E is not set
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MYRI is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_SH_ETH is not set
# CONFIG_NET_VENDOR_RDC is not set
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
# CONFIG_PHYLIB is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
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
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
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
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

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
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
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
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
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
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
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
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
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
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
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
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

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
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
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
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
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
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=m

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
# CONFIG_DRM_I810 is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
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
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
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
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_ZTE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
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
CONFIG_EDAC_X38=m
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
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
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=m
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

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
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
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
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
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
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V2=m
CONFIG_NFS_V3=m
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
# CONFIG_NFS_V4_2 is not set
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_NFS_USE_LEGACY_DNS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
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
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
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
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_KOBJECT=y
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
# CONFIG_INTEL_TXT is not set
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
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
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
# CONFIG_CRYPTO_CMAC is not set
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
# CONFIG_CRYPTO_SHA256 is not set
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
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
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
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

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
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
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
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_OID_REGISTRY=m
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--Apple-Mail=_BCF13790-841E-45E0-92BA-A00F1D7D1256
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



-- 
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_BCF13790-841E-45E0-92BA-A00F1D7D1256--

--Apple-Mail=_3BCF4D16-B66A-44FB-BA57-2758915309F5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJScAN9AAoJEDwO/+eO4+5uxd0P/j1iNrD0Y7Yg5E+Kb3bOMcXZ
GjT9ZMHVLqvPBSxtom3PcsIgOx4jC0gWeQA3CnTNXCeG9UMpMu44c3oNYnCzb4FC
ddWJNjf1qP1255OIoKb7U5OoViWvF3utZbiSeapBn3RXs7d71sAQfs8F/Y6KdyEx
tVj9m+nSeUF1QePRmnbVjBVNL2D4K36LVLNPXboDFGMO50MBxMKfm+U94TlQ7xD1
XTA4CLOcyRKVwPa1ZcZb8ZZ7HLXI0ZHeNsSGyTtOcTOma/H7k3rcdJ12BerCBDPs
dreOq5YVATkjal88pj+AyIOvJbuR7GR+xI3dDnWoHbZahvoz8Q38chGyuXhcIgyb
xJonRj7slR/Hod0GKQ5HfrGhdIG+f0w/ZQv8NJVNiwr13g+e8LYWU+fA90nyvIhG
VbvUzFufbb/iJ6Kz//dFNDRL2tfxGrLCV04v/5l9VWnNHGEvNKRZfhJ5/62+ttl+
Bfygj1dig4heiV585ef09PmJhBBHpgVv2Z12SxUkuZmlDgbvyLrL7jSQdiLn5A+I
ijBwnM0yP3RNPApWhrZFF9iTHZxHIxwElOBduoW5yArgIXKa54hd/lst40R1EIVw
CebWv7LGCcYgd0kkUiFjue/eL5yMW4Wr8uhs1g1jkR5E+kEB/dszvjHhsfJtBQL6
ub3nAMe5gQf1tQ09mgbt
=2WXc
-----END PGP SIGNATURE-----

--Apple-Mail=_3BCF4D16-B66A-44FB-BA57-2758915309F5--
