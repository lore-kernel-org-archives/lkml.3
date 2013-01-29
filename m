Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3A2KrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:47:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab3A2Kq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:46:56 -0500
Message-ID: <5107A899.9080109@redhat.com>
Date: Tue, 29 Jan 2013 11:46:49 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, hmh@hmh.eng.br, joe@perches.com
Subject: ACPI undocking on 3.8-rc5 no longer works with Lenovo T61
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

No exactly sure which patch did it - but when I'm now checking 3.8-rc5 kernel,
I cannot use anymore this 'undock' command:

echo 1 >/sys/devices/platform/dock.0/undock

which works ok with 3.7 kernel - to properly undock my T61 before suspend.


Dmesg shows this:

[ 2657.087414] ACPI: \_SB_.PCI0.LPC_.EC__.BAT1: undocking
[ 2658.613494] ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 2658.613508] ata4.00: ST_FIRST: !(DRQ|ERR|DF)
[ 2658.613522] sr 3:0:0:0: CDB:
[ 2658.613530] Get event status notification: 4a 01 00 00 10 00 00 00 08 00
[ 2658.613583] ata4.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
          res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x2 (HSM violation)
[ 2658.613670] ata4: soft resetting link
[ 2658.766888] ata4.00: NODEV after polling detection
[ 2658.766900] ata4.00: revalidation failed (errno=-2)


Here is boot log attached, my HW is Lenovo T61, C2D


Zdenek


boot log:

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.8.0-rc5-00006-g0e5e62f (@linux) (gcc version 4.8.0 20130124 
(Red Hat 4.8.0-0.6) (GCC) ) #119 SMP PREEMPT Mon Jan 28 14:36:02 CET 2013
Command line: ro root=/dev/sda2 selinux=0 intel_iommu=on kmemleak=off 
lockdep.prove_locking=0 lockdep.lock_stat=0 SYSFONT=latarcyrheb-sun16 
LANG=cs_CZ.UTF-8 KEYTABLE=us systemd.log_level=info systemd.log_target=kmsg 
ipv6.disable=1
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000bf6affff] usable
BIOS-e820: [mem 0x00000000bf6b0000-0x00000000bf6cbfff] ACPI data
BIOS-e820: [mem 0x00000000bf6cc000-0x00000000bf6fffff] ACPI NVS
BIOS-e820: [mem 0x00000000bf700000-0x00000000bfffffff] reserved
BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000013bffffff] usable
kmemleak: Kernel memory leak detector disabled
NX (Execute Disable) protection: active
SMBIOS 2.4 present.
DMI: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 03/18/2011
e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x13c000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
   00000-9FFFF write-back
   A0000-BFFFF uncachable
   C0000-CFFFF write-protect
   D0000-DFFFF uncachable
   E0000-FFFFF write-protect
MTRR variable ranges enabled:
   0 base 0C0000000 mask FC0000000 uncachable
   1 base 13C000000 mask FFC000000 uncachable
   2 base 000000000 mask F00000000 write-back
   3 base 100000000 mask FC0000000 write-back
   4 base 0BF700000 mask FFFF00000 uncachable
   5 base 0BF800000 mask FFF800000 uncachable
   6 disabled
   7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 3GB, range: 1GB, type UC
reg 1, base: 5056MB, range: 64MB, type UC
reg 2, base: 0GB, range: 4GB, type WB
reg 3, base: 4GB, range: 1GB, type WB
reg 4, base: 3063MB, range: 1MB, type UC
reg 5, base: 3064MB, range: 8MB, type UC
total RAM covered: 4023M
Found optimal setting for mtrr clean up
  gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 2GB, type WB
reg 1, base: 2GB, range: 1GB, type WB
reg 2, base: 3063MB, range: 1MB, type UC
reg 3, base: 3064MB, range: 8MB, type UC
reg 4, base: 4GB, range: 1GB, type WB
reg 5, base: 5056MB, range: 64MB, type UC
e820: update [mem 0xbf700000-0xffffffff] usable ==> reserved
e820: last_pfn = 0xbf6b0 max_arch_pfn = 0x400000000
found SMP MP-table at [mem 0x000f68f0-0x000f68ff] mapped at [ffff8800000f68f0]
initial memory mapped: [mem 0x00000000-0x1fffffff]
Base memory trampoline at [ffff880000097000] 97000 size 24576
init_memory_mapping: [mem 0x00000000-0xbf6affff]
  [mem 0x00000000-0xbf5fffff] page 2M
  [mem 0xbf600000-0xbf6affff] page 4k
kernel direct mapping tables up to 0xbf6affff @ [mem 0x1fffb000-0x1fffffff]
init_memory_mapping: [mem 0x100000000-0x13bffffff]
  [mem 0x100000000-0x13bffffff] page 2M
kernel direct mapping tables up to 0x13bffffff @ [mem 0xbf6ae000-0xbf6affff]
RAMDISK: [mem 0x37824000-0x37feffff]
ACPI: RSDP 00000000000f68c0 00024 (v02 LENOVO)
ACPI: XSDT 00000000bf6bb496 0009C (v01 LENOVO TP-7U    00002290  LTP 00000000)
ACPI: FACP 00000000bf6bb600 000F4 (v03 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI BIOS Bug: Warning: 32/64X length mismatch in FADT/Gpe1Block: 0/32 
(20121018/tbfadt-567)
ACPI BIOS Bug: Warning: Optional FADT field Gpe1Block has zero address or 
length: 0x000000000000102C/0x0 (20121018/tbfadt-598)
ACPI: DSDT 00000000bf6bba1d 1003C (v01 LENOVO TP-7U    00002290 MSFT 03000000)
ACPI: FACS 00000000bf6e4000 00040
ACPI: SSDT 00000000bf6bb7b4 00269 (v01 LENOVO TP-7U    00002290 MSFT 03000000)
ACPI: ECDT 00000000bf6cba59 00052 (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: TCPA 00000000bf6cbaab 00032 (v02 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: APIC 00000000bf6cbadd 00068 (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: MCFG 00000000bf6cbb45 0003C (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: HPET 00000000bf6cbb81 00038 (v01 LENOVO TP-7U    00002290 LNVO 00000001)
ACPI: SLIC 00000000bf6cbbb9 00176 (v01 LENOVO TP-7U    00002290  LTP 00000000)
ACPI: SLAC 00000000bf6cbdf0 00176 (v01 LENOVO TP-7U    00002290  LTP 00000000)
ACPI: BOOT 00000000bf6cbf66 00028 (v01 LENOVO TP-7U    00002290  LTP 00000001)
ACPI: ASF! 00000000bf6cbf8e 00072 (v16 LENOVO TP-7U    00002290 PTL  00000001)
ACPI: SSDT 00000000bf6e26d9 0025F (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: SSDT 00000000bf6e2938 000A6 (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: SSDT 00000000bf6e29de 004F7 (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: SSDT 00000000bf6e2ed5 001D8 (v01 LENOVO TP-7U    00002290 INTL 20050513)
ACPI: DMI detected: Lenovo ThinkPad T61
ACPI: Local APIC address 0xfee00000
  [ffffea0000000000-ffffea0004ffffff] PMD -> 
[ffff880137600000-ffff88013b5fffff] on node 0
Zone ranges:
   DMA      [mem 0x00010000-0x00ffffff]
   DMA32    [mem 0x01000000-0xffffffff]
   Normal   [mem 0x100000000-0x13bffffff]
Movable zone start for each node
Early memory node ranges
   node   0: [mem 0x00010000-0x0009cfff]
   node   0: [mem 0x00100000-0xbf6affff]
   node   0: [mem 0x100000000-0x13bffffff]
On node 0 totalpages: 1029693
   DMA zone: 64 pages used for memmap
   DMA zone: 6 pages reserved
   DMA zone: 3911 pages, LIFO batch:0
   DMA32 zone: 12187 pages used for memmap
   DMA32 zone: 767765 pages, LIFO batch:31
   Normal zone: 3840 pages used for memmap
   Normal zone: 241920 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bf6b0000 - 00000000bf6cc000
PM: Registered nosave memory: 00000000bf6cc000 - 00000000bf700000
PM: Registered nosave memory: 00000000bf700000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
e820: [mem 0xc0000000-0xefffffff] available for PCI devices
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 476 pages/cpu @ffff880137200000 s1918592 r8192 d22912 u2097152
pcpu-alloc: s1918592 r8192 d22912 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1013596
Kernel command line: ro root=/dev/sda2 selinux=0 intel_iommu=on kmemleak=off 
lockdep.prove_locking=0 lockdep.lock_stat=0 SYSFONT=latarcyrheb-sun16 
LANG=cs_CZ.UTF-8 KEYTABLE=us systemd.log_level=info systemd.log_target=kmsg 
ipv6.disable=1
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
__ex_table already sorted, skipping sort
Checking aperture...
No AGP bridge found
Memory: 3944444k/5177344k available (5558k kernel code, 1058572k absent, 
174328k reserved, 5482k data, 2624k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
	RCU debugfs-based tracing is enabled.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU lockdep checking is enabled.
	Additional per-CPU info printed with stalls.
NR_IRQS:4352 nr_irqs:512 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
  memory used by lock dependency info: 6367 kB
  per task-struct memory footprint: 2688 bytes
allocated 16777216 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2194.399 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 
4390.66 BogoMIPS (lpj=7314663)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
Initializing cgroup subsys hugetlb
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
process: using mwait in idle threads
Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift: -1
Freeing SMP alternatives: 20k freed
ACPI: Core revision 20121018
ftrace: allocating 18992 entries in 75 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz (fam: 06, 
model: 0f, stepping: 0a)
Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
perf_event_intel: PEBS disabled due to CPU errata
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
SMP alternatives: lockdep: fixing up alternatives
smpboot: Booting Node   0, Processors  #1 OK
TSC synchronization [CPU#0 -> CPU#1]:
Measured 399333 cycles TSC warp between CPUs, turning off TSC clock.
tsc: Marking TSC unstable due to check_tsc_sync_source failed
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
Brought up 2 CPUs
smpboot: Total of 2 processors activated (8781.32 BogoMIPS)
devtmpfs: initialized
EVM: security.selinux
EVM: security.capability
PM: Registering ACPI NVS region [mem 0xbf6cc000-0xbf6fffff] (212992 bytes)
regulator-dummy: no parameters
RTC time:  9:52:42, date: 01/29/13
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 
0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Added _OSI(Linux)
ACPI: EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via DMI
ACPI: SSDT 00000000bf6e1b32 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 002C4 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
ACPI: SSDT 00000000bf6e1e7b 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
ACPI: SSDT 00000000bf6e1a6a 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
ACPI: SSDT 00000000bf6e1df6 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [PUBS] (on)
ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
ACPI: ACPI Dock Station Driver: 3 docks/bays found
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and 
report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
pci_root PNP0A08:00: Requesting ACPI _OSC control (0x1d)
pci_root PNP0A08:00: ACPI _OSC control (0x1d) granted
pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] 
only partially covers this bridge
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
pci 0000:00:02.0: [8086:2a02] type 00 class 0x030000
pci 0000:00:02.0: reg 10: [mem 0xf8100000-0xf81fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
pci 0000:00:02.1: [8086:2a03] type 00 class 0x038000
pci 0000:00:02.1: reg 10: [mem 0xf8200000-0xf82fffff 64bit]
pci 0000:00:19.0: [8086:1049] type 00 class 0x020000
pci 0000:00:19.0: reg 10: [mem 0xfe000000-0xfe01ffff]
pci 0000:00:19.0: reg 14: [mem 0xfe025000-0xfe025fff]
pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
pci 0000:00:1a.7: reg 10: [mem 0xfe226c00-0xfe226fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xfe020000-0xfe023fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: [8086:2843] type 01 class 0x060400
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: [8086:2845] type 01 class 0x060400
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:2847] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 20: [io  0x18a0-0x18bf]
pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 20: [io  0x18c0-0x18df]
pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 20: [io  0x18e0-0x18ff]
pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 10: [mem 0xfe227000-0xfe2273ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
pci 0000:00:1f.0: [8086:2811] type 00 class 0x060100
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1c00-0x1c0f]
pci 0000:00:1f.2: [8086:2829] type 00 class 0x010601
pci 0000:00:1f.2: reg 10: [io  0x1c50-0x1c57]
pci 0000:00:1f.2: reg 14: [io  0x1c44-0x1c47]
pci 0000:00:1f.2: reg 18: [io  0x1c48-0x1c4f]
pci 0000:00:1f.2: reg 1c: [io  0x1c40-0x1c43]
pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
pci 0000:00:1f.2: reg 24: [mem 0xfe226000-0xfe2267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:283e] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 10: [mem 0xfe227400-0xfe2274ff]
pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
pci 0000:03:00.0: [8086:4227] type 00 class 0x028000
pci 0000:03:00.0: reg 10: [mem 0xdf3ff000-0xdf3fffff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
pci 0000:15:00.0: [1180:0476] type 02 class 0x060700
pci 0000:15:00.0: proprietary Ricoh MMC controller disabled (via cardbus function)
pci 0000:15:00.0: MMC cards are now supported by standard SDHCI controller
pci 0000:15:00.0: reg 10: [mem 0xf8300000-0xf8300fff]
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.2: [1180:0822] type 00 class 0x080500
pci 0000:15:00.2: reg 10: [mem 0xf8301000-0xf83010ff]
pci 0000:15:00.2: supports D1 D2
pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.4: [1180:0592] type 00 class 0x088000
pci 0000:15:00.4: reg 10: [mem 0xf8301800-0xf83018ff]
pci 0000:15:00.4: supports D1 D2
pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.5: [1180:0852] type 00 class 0x088000
pci 0000:15:00.5: reg 10: [mem 0xf8301c00-0xf8301cff]
pci 0000:15:00.5: supports D1 D2
pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed4bfff] (subtractive decode)
pci_bus 0000:16: busn_res: can not insert [bus 16-ff] under [bus 15-18] 
(conflicts with (null) [bus 15-18])
pci_bus 0000:16: busn_res: [bus 16-ff] end is updated to 17
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
ACPI: bus type scsi registered
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
e820: reserve RAM buffer [mem 0xbf6b0000-0xbfffffff]
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
system 00:01: [io  0x164e-0x164f] has been reserved
system 00:01: [io  0x1000-0x107f] has been reserved
system 00:01: [io  0x1180-0x11bf] has been reserved
system 00:01: [io  0x0800-0x080f] has been reserved
system 00:01: [io  0x15e0-0x15ef] has been reserved
system 00:01: [io  0x1600-0x165f] could not be reserved
system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xfc000000-0xfdffffff]
pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf80fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0xdc000000-0xdf3fffff]
pci 0000:00:1c.1:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 04]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:1c.2:   bridge window [mem 0xdfb00000-0xdfbfffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.3:   bridge window [mem 0xd4000000-0xd5ffffff]
pci 0000:00:1c.3:   bridge window [mem 0xdf800000-0xdf8fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 0d-14]
pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
pci 0000:00:1c.4:   bridge window [mem 0xd0000000-0xd1ffffff]
pci 0000:00:1c.4:   bridge window [mem 0xdf500000-0xdf5fffff 64bit pref]
pci 0000:15:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size 
add_size 4000000
pci 0000:15:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size 
add_size 4000000
pci 0000:15:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:15:00.0: BAR 15: assigned [mem 0xf4000000-0xf7ffffff pref]
pci 0000:15:00.0: BAR 16: assigned [mem 0xc0000000-0xc3ffffff]
pci 0000:15:00.0: BAR 13: assigned [io  0x7000-0x70ff]
pci 0000:15:00.0: BAR 14: assigned [io  0x7400-0x74ff]
pci 0000:15:00.0: CardBus bridge to [bus 16-17]
pci 0000:15:00.0:   bridge window [io  0x7000-0x70ff]
pci 0000:15:00.0:   bridge window [io  0x7400-0x74ff]
pci 0000:15:00.0:   bridge window [mem 0xf4000000-0xf7ffffff pref]
pci 0000:15:00.0:   bridge window [mem 0xc0000000-0xc3ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 15-18]
pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff]
pci 0000:00:1e.0:   bridge window [mem 0xf8300000-0xfbffffff]
pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xf7ffffff 64bit pref]
pci 0000:00:1e.0: enabling device (0005 -> 0007)
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: resource 11 [mem 0xc0000000-0xfebfffff]
pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed4bfff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xfc000000-0xfdffffff]
pci_bus 0000:02: resource 2 [mem 0xf8000000-0xf80fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:03: resource 1 [mem 0xdc000000-0xdf3fffff]
pci_bus 0000:03: resource 2 [mem 0xdfe00000-0xdfefffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:04: resource 1 [mem 0xd8000000-0xd9ffffff]
pci_bus 0000:04: resource 2 [mem 0xdfb00000-0xdfbfffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:05: resource 1 [mem 0xd4000000-0xd5ffffff]
pci_bus 0000:05: resource 2 [mem 0xdf800000-0xdf8fffff 64bit pref]
pci_bus 0000:0d: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:0d: resource 1 [mem 0xd0000000-0xd1ffffff]
pci_bus 0000:0d: resource 2 [mem 0xdf500000-0xdf5fffff 64bit pref]
pci_bus 0000:15: resource 0 [io  0x7000-0xafff]
pci_bus 0000:15: resource 1 [mem 0xf8300000-0xfbffffff]
pci_bus 0000:15: resource 2 [mem 0xf4000000-0xf7ffffff 64bit pref]
pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:15: resource 10 [mem 0x000dc000-0x000dffff]
pci_bus 0000:15: resource 11 [mem 0xc0000000-0xfebfffff]
pci_bus 0000:15: resource 12 [mem 0xfed40000-0xfed4bfff]
pci_bus 0000:16: resource 0 [io  0x7000-0x70ff]
pci_bus 0000:16: resource 1 [io  0x7400-0x74ff]
pci_bus 0000:16: resource 2 [mem 0xf4000000-0xf7ffffff pref]
pci_bus 0000:16: resource 3 [mem 0xc0000000-0xc3ffffff]
NET: Registered protocol family 2
TCP established hash table entries: 32768 (order: 7, 524288 bytes)
TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
TCP: Hash tables configured (established 32768 bind 32768)
TCP: reno registered
UDP hash table entries: 2048 (order: 6, 393216 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
pci 0000:00:1a.1: power state changed by ACPI to D0
pci 0000:00:1d.0: power state changed by ACPI to D0
pci 0000:00:1d.2: power state changed by ACPI to D0
PCI: CLS mismatch (64 != 32), using 64 bytes
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 7984k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xbb6ae000-0xbf6ae000] (64MB) mapped at 
[ffff8800bb6ae000-ffff8800bf6adfff]
Simple Boot Flag at 0x35 set to 0x1
sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
audit: initializing netlink socket (disabled)
type=2000 audit(1359453161.626:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 7719
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered (default)
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Deprecated procfs I/F for AC is loaded, please retry with 
CONFIG_ACPI_PROCFS_POWER cleared
ACPI: AC Adapter [AC] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Requesting acpi_cpufreq
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (52 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (51 C)
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
brd: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226100 irq 45
ata2: DUMMY
ata3: SATA max UDMA/133 abar m2048@0xfe226000 port 0xfe226200 irq 45
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi3 : ata_piix
ACPI: Deprecated procfs I/F for battery is loaded, please retry with 
CONFIG_ACPI_PROCFS_POWER cleared
scsi4 : ata_piix
ACPI: Battery Slot [BAT0] (battery present)
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1c00 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1c08 irq 15
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
ata5: port disabled--ignoring
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
hdaps: inverting axis (3) readings
hdaps: LENOVO ThinkPad T61 detected
input: hdaps as /devices/platform/hdaps/input/input3
hdaps: driver successfully loaded
TCP: cubic registered
NET: Registered protocol family 17
Key type dns_resolver registered
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Key type encrypted registered
EVM: Error registering secfs
   Magic number: 13:440:880
rtc_cmos 00:06: setting system clock to 2013-01-29 09:52:42 UTC (1359453162)
ata4.00: ATAPI: MATSHITADVD-RAM UJ-842 z, RC01, max UDMA/33
ata4.00: configured for UDMA/33
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ATA-9: SAMSUNG SSD 830 Series, CXM03B1Q, max UDMA/133
ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG SSD 830  CXM0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-842 z RC01 PQ: 0 ANSI: 5
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
scsi 3:0:0:0: Attached scsi generic sg1 type 5
sd 0:0:0:0: [sda] Attached SCSI disk
Freeing unused kernel memory: 2624k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 576k freed
Freeing unused kernel memory: 1800k freed
systemd[1]: systemd 197 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX 
+IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
systemd[1]: Running in initial RAM disk.
systemd[1]: Inserted module 'autofs4'
systemd[1]: Set hostname to <linux>.
systemd[1]: Starting udev Kernel Socket.
systemd[1]: Listening on udev Kernel Socket.
systemd[1]: Starting udev Control Socket.
systemd[1]: Listening on udev Control Socket.
systemd[1]: Starting Journal Socket.
systemd[1]: Listening on Journal Socket.
systemd[1]: Started Load Kernel Modules.
systemd[1]: Starting Journal Service...
systemd[1]: Started Journal Service.
systemd[1]: Starting Sockets.
systemd[1]: Reached target Sockets.
systemd[1]: Starting dracut cmdline hook...
systemd[1]: Starting Swap.
systemd[1]: Reached target Swap.
systemd[1]: Starting Local File Systems.
systemd[1]: Reached target Local File Systems.
systemd[1]: Started dracut cmdline hook.
systemd[1]: Starting Setup Virtual Console...
systemd[1]: Starting dracut pre-udev hook...
systemd[1]: Started dracut pre-udev hook.
systemd[1]: Started Setup Virtual Console.
systemd[1]: Starting System Initialization.
systemd[1]: Reached target System Initialization.
systemd[1]: Starting udev Kernel Device Manager...
systemd-udevd[123]: starting version 197
systemd[1]: Started udev Kernel Device Manager.
systemd[1]: Starting dracut pre-trigger hook...
systemd[1]: Started dracut pre-trigger hook.
systemd[1]: Starting udev Coldplug all Devices...
systemd[1]: Started udev Coldplug all Devices.
systemd[1]: Starting Show Plymouth Boot Screen...
ACPI: bus type usb registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 3.8.0-rc5-00006-g0e5e62f uhci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
systemd[1]: Starting dracut initqueue hook...
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.8.0-rc5-00006-g0e5e62f uhci_hcd
usb usb2: SerialNumber: 0000:00:1a.1
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.8.0-rc5-00006-g0e5e62f uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.8.0-rc5-00006-g0e5e62f uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018e0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.8.0-rc5-00006-g0e5e62f uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
yenta_cardbus 0000:15:00.0: Socket status: 30000006
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x7000-0xafff]
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 
0xf8300000-0xfbffffff]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xf8300000-0xfbffffff:
  excluding 0xf8300000-0xf86cffff
yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 
0xf4000000-0xf7ffffff 64bit pref]
pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4000000-0xf7ffffff:
  excluding 0xf4000000-0xf7ffffff
sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim 
to support it.
sdhci-pci 0000:15:00.2: setting latency timer to 64
mmc0: no vqmmc regulator found
mmc0: no vmmc regulator found
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim 
to support it.
mmc0: SDHCI controller on PCI [0000:15:00.2] using DMA
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim 
to support it.
EXT4-fs (sda2): orphan cleanup on readonly fs
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 1701960
EXT4-fs (sda2): ext4_orphan_cleanup: deleting unreferenced inode 1734388
EXT4-fs (sda2): 2 orphan inodes deleted
EXT4-fs (sda2): recovery complete
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim 
to support it.
usb 1-2: new full-speed USB device number 2 using uhci_hcd
systemd[1]: Started Show Plymouth Boot Screen.
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim 
to support it.
systemd[1]: Starting Forward Password Requests to Plymouth Directory Watch.
systemd[1]: Started Forward Password Requests to Plymouth Directory Watch.
systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
systemd[1]: Starting Basic System.
systemd[1]: Reached target Basic System.
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: data=ordered
sdhci-pci 0000:15:00.2: Will use DMA mode even though HW doesn't fully claim 
to support it.
systemd[1]: Started dracut initqueue hook.
systemd[1]: Starting dracut pre-pivot and cleanup hook...
usb 1-2: New USB device found, idVendor=0483, idProduct=2016
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: Biometric Coprocessor
usb 1-2: Manufacturer: STMicroelectronics
systemd[1]: Stopping dracut pre-pivot and cleanup hook...
systemd[1]: Stopping Basic System.
systemd[1]: Stopped target Basic System.
systemd[1]: Stopping Forward Password Requests to Plymouth Directory Watch.
systemd[1]: Stopped Forward Password Requests to Plymouth Directory Watch.
systemd[1]: Stopping Show Plymouth Boot Screen...
systemd[1]: Stopped Show Plymouth Boot Screen.
systemd[1]: Stopping udev Coldplug all Devices...
systemd[1]: Stopped udev Coldplug all Devices.
systemd[1]: Stopping Sockets.
systemd[1]: Stopped target Sockets.
systemd[1]: Stopping System Initialization.
systemd[1]: Stopped target System Initialization.
systemd[1]: Stopping Setup Virtual Console...
systemd[1]: Stopped Setup Virtual Console.
systemd[1]: Stopping Swap.
systemd[1]: Stopped target Swap.
systemd[1]: Stopping Local File Systems.
systemd[1]: Stopped target Local File Systems.
systemd[1]: Starting Plymouth switch root service...
systemd[1]: Stopping udev Kernel Device Manager...
systemd[1]: Stopped dracut pre-pivot and cleanup hook.
systemd[1]: Stopped udev Kernel Device Manager.
systemd[1]: Started Plymouth switch root service.
systemd[1]: Stopping udev Kernel Socket.
systemd[1]: Closed udev Kernel Socket.
systemd[1]: Stopping udev Control Socket.
systemd[1]: Closed udev Control Socket.
systemd[1]: Starting Cleanup udevd DB...
systemd[1]: Started Cleanup udevd DB.
systemd[1]: Starting Switch Root.
systemd[1]: Reached target Switch Root.
systemd[1]: Starting Switch Root...
usb 2-2: new full-speed USB device number 2 using uhci_hcd
systemd[1]: Switching root.
systemd-journald[76]: Received SIGTERM
usb 2-2: New USB device found, idVendor=04b3, idProduct=4485
usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
systemd[1]: systemd 197 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX 
+IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
systemd[1]: Set hostname to <linux>.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
LVM: Activation generator successfully completed.
systemd[1]: Cannot add dependency job for unit mdmonitor-takeover.service, 
ignoring: Unit mdmonitor-takeover.service failed to load: No such file or 
directory. See system logs and 'systemctl status mdmonitor-takeover.service' 
for details.
systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
systemd[1]: Started Forward Password Requests to Wall Directory Watch.
systemd[1]: Mounting RPC Pipe File System...
systemd[1]: Mounting RPC Pipe File System...
systemd[1]: Starting Login Prompts.
systemd[1]: Reached target Login Prompts.
systemd[1]: Starting Syslog Socket.
systemd[1]: Listening on Syslog Socket.
systemd[1]: Starting Syslog.
systemd[1]: Reached target Syslog.
systemd[1]: Starting Load legacy module configuration...
systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
usb 2-2.4: new low-speed USB device number 3 using uhci_hcd
systemd[1]: Starting Delayed Shutdown Socket.
systemd[1]: Listening on Delayed Shutdown Socket.
systemd[1]: Starting Apply Kernel Variables...
systemd[1]: Mounting Debug File System...
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
systemd[1]: Starting Setup Virtual Console...
systemd[1]: Started Load Kernel Modules.
systemd[1]: Mounting Huge Pages File System...
systemd[1]: Mounted FUSE Control File System.
systemd[1]: Mounting POSIX Message Queue File System...
systemd[1]: Starting Arbitrary Executable File Formats File System Automount 
Point.
systemd[1]: Set up automount Arbitrary Executable File Formats File System 
Automount Point.
systemd[1]: Starting Set Up Additional Binary Formats...
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
systemd[1]: Mounted Configuration File System.
systemd[1]: Starting Swap.
systemd[1]: Reached target Swap.
systemd[1]: Started Import network configuration from initramfs.
systemd[1]: Started File System Check on Root Device.
systemd[1]: Starting Configure read-only root support...
systemd[1]: Starting Remount Root and Kernel File Systems...
systemd[1]: Starting udev Kernel Socket.
systemd[1]: Listening on udev Kernel Socket.
systemd[1]: Starting udev Control Socket.
systemd[1]: Listening on udev Control Socket.
systemd[1]: Starting udev Coldplug all Devices...
EXT4-fs (sda2): re-mounted. Opts: data=ordered
usb 2-2.4: New USB device found, idVendor=046d, idProduct=c016
usb 2-2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2.4: Product: Optical USB Mouse
usb 2-2.4: Manufacturer: Logitech
systemd[1]: Starting udev Kernel Device Manager...
systemd[1]: Starting boot.automount.
systemd[1]: boot.automount: Directory /boot to mount over is not empty, 
mounting anyway.
systemd[1]: Set up automount boot.automount.
systemd[1]: Expecting device dev-sda5.device...
systemd[1]: Starting mnt-sda7.automount.
systemd[1]: Set up automount mnt-sda7.automount.
systemd-udevd[281]: starting version 197
systemd[1]: Started udev Kernel Device Manager.
systemd[1]: Mounted RPC Pipe File System.
systemd[1]: Mounted RPC Pipe File System.
systemd[1]: Started Apply Kernel Variables.
systemd[1]: Mounted Debug File System.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
systemd[1]: Started Setup Virtual Console.
systemd[1]: Mounted Huge Pages File System.
systemd[1]: Mounted POSIX Message Queue File System.
loop: module loaded
systemd[1]: Started Configure read-only root support.
systemd[1]: Started Load legacy module configuration.
systemd[1]: Started Remount Root and Kernel File Systems.
systemd[1]: Starting Local File Systems (Pre).
systemd[1]: Reached target Local File Systems (Pre).
systemd[1]: Starting Load Random Seed...
systemd[1]: systemd-journald.service holdoff time over, scheduling restart.
systemd[1]: Stopping Journal Service...
systemd[1]: Starting Journal Service...
systemd[1]: Started Journal Service.
systemd[1]: Mounting Arbitrary Executable File Formats File System...
systemd[1]: Started Load Random Seed.
systemd[1]: Mounted Arbitrary Executable File Formats File System.
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
systemd[1]: Started Set Up Additional Binary Formats.
systemd[1]: Started udev Coldplug all Devices.
systemd[1]: Starting udev Wait for Complete Device Initialization...
systemd[1]: Starting Show Plymouth Boot Screen...
Non-volatile memory driver v1.3
thinkpad_acpi: ThinkPad ACPI Extras v0.24
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7LETC9WW (2.29 ), EC 7KHT24WW-1.08
thinkpad_acpi: Lenovo ThinkPad T61, model 6464CTO
thinkpad_acpi: detected a 8-level brightness capable ThinkPad
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1a.7: setting latency timer to 64
ehci-pci 0000:00:1a.7: EHCI Host Controller
ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
ehci-pci 0000:00:1a.7: irq 22, io mem 0xfe226c00
ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: EHCI Host Controller
usb usb6: Manufacturer: Linux 3.8.0-rc5-00006-g0e5e62f ehci_hcd
usb usb6: SerialNumber: 0000:00:1a.7
e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
wmi: Mapper loaded
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
thinkpad_acpi: ACPI backlight control delay disabled
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, 
supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
ehci-pci 0000:00:1d.7: setting latency timer to 64
ehci-pci 0000:00:1d.7: EHCI Host Controller
ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci-pci 0000:00:1d.7: debug port 1
ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
ehci-pci 0000:00:1d.7: irq 19, io mem 0xfe227000
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: EHCI Host Controller
usb usb7: Manufacturer: Linux 3.8.0-rc5-00006-g0e5e62f ehci_hcd
usb usb7: SerialNumber: 0000:00:1d.7
thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic 
conservative mode
e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
r592 0000:15:00.4: setting latency timer to 64
r592: driver successfully loaded
pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
  excluding 0xc0000-0xcffff 0xe0000-0xfffff
pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
  excluding 0xa0000000-0xa0ffffff
r852 0000:15:00.5: setting latency timer to 64
r852: driver loaded successfully
pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
  excluding 0x60000000-0x60ffffff
usb 1-2: USB disconnect, device number 2
microcode: CPU0 sig=0x6fa, pf=0x80, revision=0x95
cfg80211: Calling CRDA to update world regulatory domain
microcode: CPU1 sig=0x6fa, pf=0x80, revision=0x95
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter 
Oruba
usb 2-2: USB disconnect, device number 2
usb 2-2.4: USB disconnect, device number 3
e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:25:14:4a:e2
e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0 eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
ACPI Warning: 0x0000000000001028-0x000000000000102f SystemIO conflicts with 
Region \_SB_.PCI0.LPC_.PMIO 1 (20121018/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it 
instead of the native driver
ACPI Warning: 0x00000000000011b0-0x00000000000011bf SystemIO conflicts with 
Region \_SB_.PCI0.LPC_.LPIO 1 (20121018/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it 
instead of the native driver
ACPI Warning: 0x0000000000001180-0x00000000000011af SystemIO conflicts with 
Region \_SB_.PCI0.LPC_.LPIO 1 (20121018/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it 
instead of the native driver
lpc_ich: Resource conflict(s) found affecting gpio_ich
i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
hda_intel: probe_mask set to 0x1 for device 17aa:20ac
snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
systemd[1]: Starting Sound Card.
systemd[1]: Reached target Sound Card.
systemd[1]: Found device SAMSUNG_SSD_830_Series.
systemd[1]: Starting File System Check on /dev/sda5...
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 
in-tree:s
iwl3945: Copyright(c) 2003-2011 Intel Corporation
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
systemd[1]: Started File System Check on /dev/sda5.
systemd[1]: Mounting /home...
systemd[1]: home.mount: Directory /home to mount over is not empty, mounting 
anyway.
iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
iwl3945 0000:03:00.0: irq 48 for MSI/MSI-X
ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: 
data=ordered,user_xattr
systemd[1]: Mounted /home.
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)

