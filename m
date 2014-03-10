Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaCJKE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:04:27 -0400
Received: from mout.web.de ([212.227.15.3]:49161 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaCJKEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:04:22 -0400
Date: Mon, 10 Mar 2014 11:04:10 +0100
From: Julian Wollrath <jwollrath@web.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
Message-ID: <20140310110410.5b2218f6@ilfaris>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:WODLg7BaRC2668J7llIUme96kAZR0dEVCOH168lDFzISM2Ax6Ma
 Qsb2dSmiL65hLjpne5rSlyW1iM8rZdT/MdCjPutqv/hizTKISLDT2AMoIf/7Cocux1h5lUM
 0ZNnwwgSQGDknxbw4gJNLSxyZYbiAC/L7+EZkeu/wr7T7iRlZTPxB4eMFqY7jxCdEymmiw3
 0xYrzEYwVfS4iXgM7W2lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on a Thinkpad x121e (AMD E-450 APU) with version 3.13.5 and earlier of
the kernel I get:
[...]
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 1646.619 MHz processor
[    0.000004] Calibrating delay loop (skipped), value calculated using
timer frequency.. 3293.23 BogoMIPS (lpj=1646619)
[...]


but starting with v3.14-rc1 the fast TSC calibration fails:
[...]
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches HPET. 1 loops
[    0.000000] tsc: Detected 1646.490 MHz processor
[...]

If you need more information, please do not hesitate to ask.


With best regards,
Julian Wollrath

Full dmesg output:
[    0.000000] Linux version 3.14.0-rc5 (wolle@ilfaris) (gcc version
4.8.2 (Debian 4.8.2-16) ) #1 SMP Mon Mar 3 16:13:57 CET 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.14.0-rc5
root=/dev/mapper/encrypted-root ro quiet [    0.000000] e820:
BIOS-provided physical RAM map: [    0.000000] BIOS-e820: [mem
0x0000000000000000-0x000000000009d7ff] usable [    0.000000] BIOS-e820:
[mem 0x000000000009d800-0x000000000009ffff] reserved [    0.000000]
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000c6ceafff]
usable [    0.000000] BIOS-e820: [mem
0x00000000c6ceb000-0x00000000c70fafff] reserved [    0.000000]
BIOS-e820: [mem 0x00000000c70fb000-0x00000000c717afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000c717b000-0x00000000c71dafff]
ACPI data [    0.000000] BIOS-e820: [mem
0x00000000c71db000-0x00000000c7bfffff] usable [    0.000000] BIOS-e820:
[mem 0x00000000c7c00000-0x00000000c7ffffff] reserved [    0.000000]
BIOS-e820: [mem 0x00000000fec00000-0x00000000fecfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff]
reserved [    0.000000] BIOS-e820: [mem
0x00000000ffe00000-0x00000000ffffffff] reserved [    0.000000]
BIOS-e820: [mem 0x0000000100000000-0x000000011effffff] usable
[    0.000000] NX (Execute Disable) protection: active [    0.000000]
SMBIOS 2.6 present. [    0.000000] DMI: LENOVO 30515YG/30515YG, BIOS
8RET52WW (1.15 ) 11/15/2011 [    0.000000] e820: update [mem
0x00000000-0x00000fff] usable ==> reserved [    0.000000] e820: remove
[mem 0x000a0000-0x000fffff] usable [    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x11f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable [    0.000000] MTRR fixed
ranges enabled: [    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable [    0.000000]   C0000-FFFFF
write-protect [    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF8000000 write-back
[    0.000000]   3 base 0FFF90000 mask FFFFF0000 uncachable
[    0.000000]   4 base 0FED80000 mask FFFFFF000 uncachable
[    0.000000]   5 disabled [    0.000000]   6 disabled
[    0.000000]   7 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000] TOM2: 000000011f000000 aka 4592M [    0.000000] x86 PAT
enabled: cpu 0, old 0x7040600070406, new 0x7010600070106 [    0.000000]
e820: last_pfn = 0xc7c00 max_arch_pfn = 0x400000000 [    0.000000] Base
memory trampoline at [ffff880000097000] 97000 size 24576 [    0.000000]
Using GB pages for direct mapping [    0.000000] init_memory_mapping:
[mem 0x00000000-0x000fffff] [    0.000000]  [mem 0x00000000-0x000fffff]
page 4k [    0.000000] BRK [0x01a2d000, 0x01a2dfff] PGTABLE
[    0.000000] BRK [0x01a2e000, 0x01a2efff] PGTABLE
[    0.000000] BRK [0x01a2f000, 0x01a2ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11ee00000-0x11effffff]
[    0.000000]  [mem 0x11ee00000-0x11effffff] page 2M
[    0.000000] BRK [0x01a30000, 0x01a30fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11edfffff]
[    0.000000]  [mem 0x11c000000-0x11edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xc6ceafff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xc6bfffff] page 2M
[    0.000000]  [mem 0xc6c00000-0xc6ceafff] page 4k
[    0.000000] init_memory_mapping: [mem 0xc71db000-0xc7bfffff]
[    0.000000]  [mem 0xc71db000-0xc71fffff] page 4k
[    0.000000]  [mem 0xc7200000-0xc7bfffff] page 2M
[    0.000000] BRK [0x01a31000, 0x01a31fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x376c2000-0x37b58fff]
[    0.000000] ACPI: RSDP 00000000000f00e0 000024 (v04 LENOVO)
[    0.000000] ACPI: XSDT 00000000c71da120 000074 (v01 LENOVO TP-8R
00000003 PTEC 00000002) [    0.000000] ACPI: FACP 00000000c71c5000
0000F4 (v04 LENOVO TP-8R    00001150 PTL  00000002) [    0.000000]
ACPI: DSDT 00000000c71c7000 0112E1 (v01 LENOVO TP-8R    00001000 PTEC
00001150) [    0.000000] ACPI: FACS 00000000c7166000 000040
[    0.000000] ACPI: SLIC 00000000c71d9000 000176 (v01 LENOVO TP-8R
00001150 PTEC 00000001) [    0.000000] ACPI: HPET 00000000c71c4000
000038 (v01 LENOVO TP-8R    00001150 PTL  00000002) [    0.000000]
ACPI: APIC 00000000c71c3000 00005E (v02 LENOVO TP-8R    00001150 PTL
00000002) [    0.000000] ACPI: MCFG 00000000c71c2000 00003C (v01 LENOVO
TP-8R    00001150 PTL  00000002) [    0.000000] ACPI: UEFI
00000000c71c1000 00003E (v01 LENOVO TP-8R    00001150 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000c71c0000 000042 (v01 PTL      COMBUF
00000001 PTL  00000001) [    0.000000] ACPI: SSDT 00000000c71bf000
0003DE (v01 AMD    POWERNOW 00000001 AMD  00000001) [    0.000000]
ACPI: SSDT 00000000c71bd000 00168E (v02    AMD     ALIB 00000001 MSFT
04000000) [    0.000000] ACPI: UEFI 00000000c71bc000 00013E (v01 LENOVO
TP-8R    00001150 PTL  00000002) [    0.000000] ACPI: Local APIC
address 0xfee00000 [    0.000000]  [ffffea0000000000-ffffea0003ffffff]
PMD -> [ffff88011ac00000-ffff88011dffffff] on node 0 [    0.000000]
Zone ranges: [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff] [    0.000000]
Normal   [mem 0x100000000-0x11effffff] [    0.000000] Movable zone
start for each node [    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff] [    0.000000]
node   0: [mem 0x00100000-0xc6ceafff] [    0.000000]   node   0: [mem
0xc71db000-0xc7bfffff] [    0.000000]   node   0: [mem
0x100000000-0x11effffff] [    0.000000] On node 0 totalpages: 943788
[    0.000000]   DMA zone: 56 pages used for memmap [    0.000000]
DMA zone: 21 pages reserved [    0.000000]   DMA zone: 3996 pages, LIFO
batch:0 [    0.000000]   DMA32 zone: 11113 pages used for memmap
[    0.000000]   DMA32 zone: 812816 pages, LIFO batch:31
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 126976 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808 [    0.000000] ACPI: Local
APIC address 0xfee00000 [    0.000000] ACPI: LAPIC (acpi_id[0x00]
lapic_id[0x00] enabled) [    0.000000] ACPI: LAPIC (acpi_id[0x01]
lapic_id[0x01] enabled) [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00]
high edge lint[0x1]) [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high
edge lint[0x1]) [    0.000000] ACPI: IOAPIC (id[0x02]
address[0xfec00000] gsi_base[0]) [    0.000000] IOAPIC[0]: apic_id 2,
version 33, address 0xfec00000, GSI 0-23 [    0.000000] ACPI:
INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl) [    0.000000] ACPI:
IRQ0 used by override. [    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc6ceb000-0xc70fafff]
[    0.000000] PM: Registered nosave memory: [mem 0xc70fb000-0xc717afff]
[    0.000000] PM: Registered nosave memory: [mem 0xc717b000-0xc71dafff]
[    0.000000] PM: Registered nosave memory: [mem 0xc7c00000-0xc7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc8000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed80000-0xfed80fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed81000-0xffdfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffe00000-0xffffffff]
[    0.000000] e820: [mem 0xc8000000-0xfebfffff] available for PCI
devices [    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2
nr_cpu_ids:2 nr_node_ids:1 [    0.000000] PERCPU: Embedded 27 pages/cpu
@ffff88011ec00000 s80064 r8192 d22336 u1048576 [    0.000000]
pcpu-alloc: s80064 r8192 d22336 u1048576 alloc=1*2097152 [    0.000000]
pcpu-alloc: [0] 0 1 [    0.000000] Built 1 zonelists in Zone order,
mobility grouping on.  Total pages: 930862 [    0.000000] Kernel
command line: BOOT_IMAGE=/vmlinuz-3.14.0-rc5
root=/dev/mapper/encrypted-root ro quiet [    0.000000] PID hash table
entries: 4096 (order: 3, 32768 bytes) [    0.000000] Dentry cache hash
table entries: 524288 (order: 10, 4194304 bytes) [    0.000000]
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture... [    0.000000] No AGP bridge found
[    0.000000] Memory: 3634188K/3775152K available (4378K kernel code,
586K rwdata, 1428K rodata, 836K init, 776K bss, 140964K reserved)
[    0.000000] Hierarchical RCU implementation. [    0.000000]
RCU dyntick-idle grace-period acceleration is enabled. [    0.000000]
NR_IRQS:4352 nr_irqs:512 16 [    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] spurious 8259A interrupt: IRQ7. [    0.000000] Console:
colour VGA+ 80x25 [    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches HPET. 1 loops
[    0.000000] tsc: Detected 1646.490 MHz processor
[    0.000044] Calibrating delay loop (skipped), value calculated using
timer frequency.. 3292.98 BogoMIPS (lpj=1646490) [    0.000049]
pid_max: default: 32768 minimum: 301 [    0.000113] Mount-cache hash
table entries: 256 [    0.000420] tseg: 00c7c00000
[    0.000424] CPU: Physical Processor ID: 0
[    0.000426] CPU: Processor Core ID: 0
[    0.000429] mce: CPU supports 6 MCE banks
[    0.000444] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.000444] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4, 1GB 0
[    0.000444] tlb_flushall_shift: 6
[    0.000610] Freeing SMP alternatives memory: 16K (ffffffff81965000 -
ffffffff81969000) [    0.001115] ..TIMER: vector=0x30 apic1=0 pin1=2
apic2=-1 pin2=-1 [    0.011123] smpboot: CPU0: AMD E-450 APU with
Radeon(tm) HD Graphics (fam: 14, model: 02, stepping: 00)
[    0.112402] Performance Events: AMD PMU driver. [    0.112410] ...
version:                0 [    0.112412] ... bit width:              48
[    0.112414] ... generic registers:      4
[    0.112416] ... value mask:             0000ffffffffffff
[    0.112419] ... max period:             00007fffffffffff
[    0.112421] ... fixed-purpose events:   0
[    0.112423] ... event mask:             000000000000000f
[    0.112936] x86: Booting SMP configuration:
[    0.112942] .... node  #0, CPUs:      #1
[    0.126168] x86: Booted up 1 node, 2 CPUs
[    0.126172] smpboot: Total of 2 processors activated (6585.96
BogoMIPS) [    0.126852] devtmpfs: initialized
[    0.127236] PM: Registering ACPI NVS region [mem
0xc70fb000-0xc717afff] (524288 bytes) [    0.127623] NET: Registered
protocol family 16 [    0.127764] cpuidle: using governor ladder
[    0.127768] cpuidle: using governor menu
[    0.127943] ACPI: bus type PCI registered
[    0.128062] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem
0xf8000000-0xf9ffffff] (base 0xf8000000) [    0.128067] PCI: not using
MMCONFIG [    0.128070] PCI: Using configuration type 1 for base access
[    0.128072] PCI: Using configuration type 1 for extended access
[    0.129325] bio: create slab <bio-0> at 0
[    0.129525] ACPI: Added _OSI(Module Device)
[    0.129529] ACPI: Added _OSI(Processor Device)
[    0.129532] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.129534] ACPI: Added _OSI(Processor Aggregator Device)
[    0.143453] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.150390] ACPI: Interpreter enabled
[    0.150408] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20131218/hwxface-580) [    0.150417] ACPI Exception:
AE_NOT_FOUND, While evaluating Sleep State [\_S2_]
(20131218/hwxface-580) [    0.150441] ACPI: (supports S0 S3 S4 S5)
[    0.150445] ACPI: Using IOAPIC for interrupt routing [    0.150712]
PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem
0xf8000000-0xf9ffffff] (base 0xf8000000) [    0.151180] PCI: MMCONFIG
at [mem 0xf8000000-0xf9ffffff] reserved in ACPI motherboard resources
[    0.153412] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug [    0.154324] [Firmware Bug]: ACPI:
No _BQC method, cannot determine initial brightness [    0.154349]
[Firmware Bug]: ACPI: No _BQC method, cannot determine initial
brightness [    0.165487] [Firmware Bug]: ACPI: No _BQC method, cannot
determine initial brightness [    0.165529] [Firmware Bug]: ACPI: No
_BQC method, cannot determine initial brightness [    0.169424] ACPI:
PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff]) [    0.169440] acpi
PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments
MSI] [    0.170026] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug
PME AER PCIeCapability] [    0.171823] acpi PNP0A08:00: ignoring host
bridge window [mem 0x000ce000-0x000cffff] (conflicts with Video ROM
[mem 0x000c0000-0x000ce5ff]) [    0.171834] acpi PNP0A08:00: [Firmware
Info]: MMCONFIG for domain 0000 [bus 00-1f] only partially covers this
bridge [    0.171891] PCI host bridge to bus 0000:00 [    0.171897]
pci_bus 0000:00: root bus resource [bus 00-ff] [    0.171902] pci_bus
0000:00: root bus resource [mem 0x000a0000-0x000bffff] [    0.171906]
pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c1fff]
[    0.171910] pci_bus 0000:00: root bus resource [mem
0x000c2000-0x000c3fff] [    0.171914] pci_bus 0000:00: root bus
resource [mem 0x000c4000-0x000c5fff] [    0.171917] pci_bus 0000:00:
root bus resource [mem 0x000c6000-0x000c7fff] [    0.171921] pci_bus
0000:00: root bus resource [mem 0x000c8000-0x000c9fff] [    0.171925]
pci_bus 0000:00: root bus resource [mem 0x000ca000-0x000cbfff]
[    0.171929] pci_bus 0000:00: root bus resource [mem
0x000cc000-0x000cdfff] [    0.171932] pci_bus 0000:00: root bus
resource [mem 0x000d0000-0x000d1fff] [    0.171937] pci_bus 0000:00:
root bus resource [mem 0x000d2000-0x000d3fff] [    0.171940] pci_bus
0000:00: root bus resource [mem 0x000d4000-0x000d5fff] [    0.171944]
pci_bus 0000:00: root bus resource [mem 0x000d6000-0x000d7fff]
[    0.171947] pci_bus 0000:00: root bus resource [mem
0x000d8000-0x000d9fff] [    0.171951] pci_bus 0000:00: root bus
resource [mem 0x000da000-0x000dbfff] [    0.171955] pci_bus 0000:00:
root bus resource [mem 0x000dc000-0x000ddfff] [    0.171958] pci_bus
0000:00: root bus resource [mem 0x000de000-0x000dffff] [    0.171962]
pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e1fff]
[    0.171965] pci_bus 0000:00: root bus resource [mem
0x000e2000-0x000e3fff] [    0.171969] pci_bus 0000:00: root bus
resource [mem 0x000e4000-0x000e5fff] [    0.171972] pci_bus 0000:00:
root bus resource [mem 0x000e6000-0x000e7fff] [    0.171976] pci_bus
0000:00: root bus resource [mem 0x000e8000-0x000e9fff] [    0.171980]
pci_bus 0000:00: root bus resource [mem 0x000ea000-0x000ebfff]
[    0.171983] pci_bus 0000:00: root bus resource [mem
0x000ec000-0x000edfff] [    0.171987] pci_bus 0000:00: root bus
resource [mem 0x000ee000-0x000effff] [    0.171990] pci_bus 0000:00:
root bus resource [mem 0xe0000000-0xf7ffffff] [    0.171994] pci_bus
0000:00: root bus resource [mem 0xf8000000-0xffffffff] [    0.171998]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7] [    0.172001]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff] [    0.172017]
pci 0000:00:00.0: [1022:1510] type 00 class 0x060000 [    0.172182] pci
0000:00:01.0: [1002:9806] type 00 class 0x030000 [    0.172198] pci
0000:00:01.0: reg 0x10: [mem 0xe0000000-0xefffffff pref] [    0.172209]
pci 0000:00:01.0: reg 0x14: [io  0x3000-0x30ff] [    0.172220] pci
0000:00:01.0: reg 0x18: [mem 0xf0300000-0xf033ffff] [    0.172286] pci
0000:00:01.0: supports D1 D2 [    0.172409] pci 0000:00:01.1:
[1002:1314] type 00 class 0x040300 [    0.172423] pci 0000:00:01.1: reg
0x10: [mem 0xf0344000-0xf0347fff] [    0.172498] pci 0000:00:01.1:
supports D1 D2 [    0.172668] pci 0000:00:04.0: [1022:1512] type 01
class 0x060400 [    0.172749] pci 0000:00:04.0: PME# supported from D0
D3hot D3cold [    0.172826] pci 0000:00:04.0: System wakeup disabled by
ACPI [    0.172902] pci 0000:00:06.0: [1022:1514] type 01 class
0x060400 [    0.172981] pci 0000:00:06.0: PME# supported from D0 D3hot
D3cold [    0.173056] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.173133] pci 0000:00:07.0: [1022:1515] type 01 class 0x060400
[    0.173217] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.173291] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.173426] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.173454] pci 0000:00:11.0: reg 0x10: [io  0x3118-0x311f]
[    0.173468] pci 0000:00:11.0: reg 0x14: [io  0x3124-0x3127]
[    0.173482] pci 0000:00:11.0: reg 0x18: [io  0x3110-0x3117]
[    0.173497] pci 0000:00:11.0: reg 0x1c: [io  0x3120-0x3123]
[    0.173511] pci 0000:00:11.0: reg 0x20: [io  0x3100-0x310f]
[    0.173526] pci 0000:00:11.0: reg 0x24: [mem 0xf034a000-0xf034a3ff]
[    0.173748] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.173768] pci 0000:00:12.0: reg 0x10: [mem 0xf0349000-0xf0349fff]
[    0.173926] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.174002] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.174029] pci 0000:00:12.2: reg 0x10: [mem 0xf034a500-0xf034a5ff]
[    0.174140] pci 0000:00:12.2: supports D1 D2 [    0.174143] pci
0000:00:12.2: PME# supported from D0 D1 D2 D3hot [    0.174238] pci
0000:00:12.2: System wakeup disabled by ACPI [    0.174361] pci
0000:00:13.0: [1002:4397] type 00 class 0x0c0310 [    0.174381] pci
0000:00:13.0: reg 0x10: [mem 0xf0348000-0xf0348fff] [    0.174534] pci
0000:00:13.0: System wakeup disabled by ACPI [    0.174658] pci
0000:00:13.2: [1002:4396] type 00 class 0x0c0320 [    0.174685] pci
0000:00:13.2: reg 0x10: [mem 0xf034a400-0xf034a4ff] [    0.174795] pci
0000:00:13.2: supports D1 D2 [    0.174799] pci 0000:00:13.2: PME#
supported from D0 D1 D2 D3hot [    0.174968] pci 0000:00:14.0:
[1002:4385] type 00 class 0x0c0500 [    0.175164] pci 0000:00:14.2:
[1002:4383] type 00 class 0x040300 [    0.175196] pci 0000:00:14.2: reg
0x10: [mem 0xf0340000-0xf0343fff 64bit] [    0.175285] pci
0000:00:14.2: PME# supported from D0 D3hot D3cold [    0.175355] pci
0000:00:14.2: System wakeup disabled by ACPI [    0.175470] pci
0000:00:14.3: [1002:439d] type 00 class 0x060100 [    0.175714] pci
0000:00:14.4: [1002:4384] type 01 class 0x060401 [    0.175821] pci
0000:00:14.4: System wakeup disabled by ACPI [    0.175895] pci
0000:00:18.0: [1022:1700] type 00 class 0x060000 [    0.176039] pci
0000:00:18.1: [1022:1701] type 00 class 0x060000 [    0.176177] pci
0000:00:18.2: [1022:1702] type 00 class 0x060000 [    0.176313] pci
0000:00:18.3: [1022:1703] type 00 class 0x060000 [    0.176464] pci
0000:00:18.4: [1022:1704] type 00 class 0x060000 [    0.176599] pci
0000:00:18.5: [1022:1718] type 00 class 0x060000 [    0.176734] pci
0000:00:18.6: [1022:1716] type 00 class 0x060000 [    0.176866] pci
0000:00:18.7: [1022:1719] type 00 class 0x060000 [    0.177169] pci
0000:01:00.0: [8086:4239] type 00 class 0x028000 [    0.177262] pci
0000:01:00.0: reg 0x10: [mem 0xf0200000-0xf0201fff 64bit]
[    0.177507] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.180291] pci 0000:00:04.0: PCI bridge to [bus 01] [    0.180310]
pci 0000:00:04.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.180416] pci 0000:02:00.0: [1969:1083] type 00 class 0x020000
[    0.180443] pci 0000:02:00.0: reg 0x10: [mem 0xf0100000-0xf013ffff
64bit] [    0.180459] pci 0000:02:00.0: reg 0x18: [io  0x2000-0x207f]
[    0.180574] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
D3cold [    0.183220] pci 0000:00:06.0: PCI bridge to [bus 02]
[    0.183246] pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
[    0.183259] pci 0000:00:06.0:   bridge window [mem
0xf0100000-0xf01fffff] [    0.183430] pci 0000:03:00.0: [10ec:5209]
type 00 class 0xff0000 [    0.183456] pci 0000:03:00.0: reg 0x10: [mem
0xf0000000-0xf0000fff] [    0.183528] pci 0000:03:00.0: reg 0x30: [mem
0xffff0000-0xffffffff pref] [    0.183605] pci 0000:03:00.0: supports
D1 D2 [    0.183609] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
[    0.186193] pci 0000:00:07.0: PCI bridge to [bus 03] [    0.186210]
pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf00fffff]
[    0.186442] pci 0000:00:14.4: PCI bridge to [bus 04] (subtractive
decode) [    0.186456] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode) [    0.186460] pci
0000:00:14.4:   bridge window [mem 0x000c0000-0x000c1fff] (subtractive
decode) [    0.186465] pci 0000:00:14.4:   bridge window [mem
0x000c2000-0x000c3fff] (subtractive decode) [    0.186468] pci
0000:00:14.4:   bridge window [mem 0x000c4000-0x000c5fff] (subtractive
decode) [    0.186472] pci 0000:00:14.4:   bridge window [mem
0x000c6000-0x000c7fff] (subtractive decode) [    0.186476] pci
0000:00:14.4:   bridge window [mem 0x000c8000-0x000c9fff] (subtractive
decode) [    0.186480] pci 0000:00:14.4:   bridge window [mem
0x000ca000-0x000cbfff] (subtractive decode) [    0.186483] pci
0000:00:14.4:   bridge window [mem 0x000cc000-0x000cdfff] (subtractive
decode) [    0.186487] pci 0000:00:14.4:   bridge window [mem
0x000d0000-0x000d1fff] (subtractive decode) [    0.186491] pci
0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive
decode) [    0.186494] pci 0000:00:14.4:   bridge window [mem
0x000d4000-0x000d5fff] (subtractive decode) [    0.186498] pci
0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive
decode) [    0.186502] pci 0000:00:14.4:   bridge window [mem
0x000d8000-0x000d9fff] (subtractive decode) [    0.186506] pci
0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive
decode) [    0.186509] pci 0000:00:14.4:   bridge window [mem
0x000dc000-0x000ddfff] (subtractive decode) [    0.186513] pci
0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive
decode) [    0.186517] pci 0000:00:14.4:   bridge window [mem
0x000e0000-0x000e1fff] (subtractive decode) [    0.186520] pci
0000:00:14.4:   bridge window [mem 0x000e2000-0x000e3fff] (subtractive
decode) [    0.186524] pci 0000:00:14.4:   bridge window [mem
0x000e4000-0x000e5fff] (subtractive decode) [    0.186528] pci
0000:00:14.4:   bridge window [mem 0x000e6000-0x000e7fff] (subtractive
decode) [    0.186531] pci 0000:00:14.4:   bridge window [mem
0x000e8000-0x000e9fff] (subtractive decode) [    0.186535] pci
0000:00:14.4:   bridge window [mem 0x000ea000-0x000ebfff] (subtractive
decode) [    0.186539] pci 0000:00:14.4:   bridge window [mem
0x000ec000-0x000edfff] (subtractive decode) [    0.186542] pci
0000:00:14.4:   bridge window [mem 0x000ee000-0x000effff] (subtractive
decode) [    0.186546] pci 0000:00:14.4:   bridge window [mem
0xe0000000-0xf7ffffff] (subtractive decode) [    0.186550] pci
0000:00:14.4:   bridge window [mem 0xf8000000-0xffffffff] (subtractive
decode) [    0.186554] pci 0000:00:14.4:   bridge window [io
0x0000-0x0cf7] (subtractive decode) [    0.186557] pci 0000:00:14.4:
bridge window [io  0x0d00-0xffff] (subtractive decode) [    0.186674]
pci_bus 0000:00: on NUMA node 0 [    0.187344] ACPI: PCI Interrupt Link
[LNKA] (IRQs 10 11) *0 [    0.187511] ACPI: PCI Interrupt Link [LNKB]
(IRQs 10 11) *0 [    0.187635] ACPI: PCI Interrupt Link [LNKC] (IRQs 10
11) *0 [    0.187757] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
[    0.187859] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
[    0.187939] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
[    0.188019] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
[    0.188100] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
[    0.188741] ACPI: Enabled 2 GPEs in block 00 to 1F [    0.188869]
ACPI : EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.189205] vgaarb: device added:
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none [    0.189222]
vgaarb: loaded [    0.189224] vgaarb: bridge control possible
0000:00:01.0 [    0.189311] PCI: Using ACPI for IRQ routing
[    0.190536] PCI: pci_cache_line_size set to 64 bytes [    0.190820]
e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff] [    0.190825]
e820: reserve RAM buffer [mem 0xc6ceb000-0xc7ffffff] [    0.190828]
e820: reserve RAM buffer [mem 0xc7c00000-0xc7ffffff] [    0.190831]
e820: reserve RAM buffer [mem 0x11f000000-0x11fffffff] [    0.191109]
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0 [    0.191117] hpet0: 3
comparators, 32-bit 14.318180 MHz counter [    0.193264] Switched to
clocksource hpet [    0.199767] pnp: PnP ACPI init [    0.199801] ACPI:
bus type PNP registered [    0.200067] system 00:00: [io
0x0f50-0x0f51] has been reserved [    0.200073] system 00:00: [mem
0xfec00000-0xfec00fff] could not be reserved [    0.200078] system
00:00: [mem 0xfee00000-0xfee00fff] has been reserved [    0.200083]
system 00:00: [mem 0xf8000000-0xf9ffffff] has been reserved
[    0.200090] system 00:00: Plug and Play ACPI device, IDs PNP0c02
(active) [    0.200800] pnp 00:01: [dma 4] [    0.200854] pnp 00:01:
Plug and Play ACPI device, IDs PNP0200 (active) [    0.200926] pnp
00:02: Plug and Play ACPI device, IDs PNP0c04 (active) [    0.200991]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.201046] pnp 00:04: Plug and Play ACPI device, IDs PNP0800
(active) [    0.201107] pnp 00:05: Plug and Play ACPI device, IDs
PNP0303 (active) [    0.201185] pnp 00:06: Plug and Play ACPI device,
IDs LEN0026 PNP0f13 (active) [    0.201362] system 00:07: [io
0x04d0-0x04d1] has been reserved [    0.201367] system 00:07: [io
0x0530-0x0537] has been reserved [    0.201372] system 00:07: [io
0x0800-0x0827] could not be reserved [    0.201376] system 00:07: [io
0x0830] has been reserved [    0.201380] system 00:07: [io
0x0840-0x0847] has been reserved [    0.201384] system 00:07: [io
0x0b00-0x0b1f] has been reserved [    0.201388] system 00:07: [io
0x0b20-0x0b3f] has been reserved [    0.201392] system 00:07: [io
0x0c00-0x0c01] has been reserved [    0.201396] system 00:07: [io
0x0c14] has been reserved [    0.201400] system 00:07: [io
0x0c50-0x0c52] has been reserved [    0.201404] system 00:07: [io
0x0cd0-0x0cd1] has been reserved [    0.201408] system 00:07: [io
0x0cd2-0x0cd3] has been reserved [    0.201412] system 00:07: [io
0x0cd4-0x0cd5] has been reserved [    0.201415] system 00:07: [io
0x0cd6-0x0cd7] has been reserved [    0.201419] system 00:07: [io
0x0cd8-0x0cdf] has been reserved [    0.201423] system 00:07: [io
0x0cf9] could not be reserved [    0.201427] system 00:07: [io
0x8100-0x81ff window] has been reserved [    0.201431] system 00:07:
[io  0x8200-0x82ff window] has been reserved [    0.201437] system
00:07: Plug and Play ACPI device, IDs PNP0c02 (active) [    0.201621]
pnp 00:08: [Firmware Bug]: [mem 0x00000000-0xffffffffffffffff disabled]
covers only part of AMD MMCONFIG area [mem 0xf8000000-0xf9ffffff];
adding more reservations [    0.201670] system 00:08: [mem
0x000e0000-0x000fffff] could not be reserved [    0.201674] system
00:08: [mem 0xffe00000-0xffffffff] has been reserved [    0.201679]
system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.201683] system 00:08: [mem 0xfed00000-0xfed003ff] has been
reserved [    0.201687] system 00:08: [mem 0xfed61000-0xfed613ff] has
been reserved [    0.201691] system 00:08: [mem 0xfed80000-0xfed80fff]
has been reserved [    0.201696] system 00:08: Plug and Play ACPI
device, IDs PNP0c01 (active) [    0.202116] pnp: PnP ACPI: found 9
devices [    0.202123] ACPI: bus type PNP unregistered [    0.212310]
pci 0000:03:00.0: no compatible bridge window for [mem
0xffff0000-0xffffffff pref] [    0.212353] pci 0000:00:07.0: bridge
window [io  0x1000-0x0fff] to [bus 03] add_size 1000 [    0.212360] pci
0000:00:07.0: bridge window [mem 0x00100000-0x001fffff pref] to [bus
03] add_size 200000 [    0.212426] pci 0000:00:07.0: res[15]=[mem
0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.212431] pci 0000:00:07.0: res[13]=[io  0x1000-0x0fff]
get_res_add_size add_size 1000 [    0.212454] pci 0000:00:07.0: BAR 15:
assigned [mem 0xf0400000-0xf06fffff pref] [    0.212463] pci
0000:00:07.0: BAR 13: assigned [io  0x1000-0x1fff] [    0.212469] pci
0000:00:04.0: PCI bridge to [bus 01] [    0.212477] pci 0000:00:04.0:
bridge window [mem 0xf0200000-0xf02fffff] [    0.212486] pci
0000:00:06.0: PCI bridge to [bus 02] [    0.212491] pci 0000:00:06.0:
bridge window [io  0x2000-0x2fff] [    0.212498] pci 0000:00:06.0:
bridge window [mem 0xf0100000-0xf01fffff] [    0.212510] pci
0000:03:00.0: BAR 6: assigned [mem 0xf0400000-0xf040ffff pref]
[    0.212514] pci 0000:00:07.0: PCI bridge to [bus 03] [    0.212519]
pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff] [    0.212525]
pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf00fffff]
[    0.212531] pci 0000:00:07.0:   bridge window [mem
0xf0400000-0xf06fffff pref] [    0.212538] pci 0000:00:14.4: PCI bridge
to [bus 04] [    0.212603] pci_bus 0000:00: resource 4 [mem
0x000a0000-0x000bffff] [    0.212608] pci_bus 0000:00: resource 5 [mem
0x000c0000-0x000c1fff] [    0.212611] pci_bus 0000:00: resource 6 [mem
0x000c2000-0x000c3fff] [    0.212615] pci_bus 0000:00: resource 7 [mem
0x000c4000-0x000c5fff] [    0.212619] pci_bus 0000:00: resource 8 [mem
0x000c6000-0x000c7fff] [    0.212622] pci_bus 0000:00: resource 9 [mem
0x000c8000-0x000c9fff] [    0.212626] pci_bus 0000:00: resource 10 [mem
0x000ca000-0x000cbfff] [    0.212629] pci_bus 0000:00: resource 11 [mem
0x000cc000-0x000cdfff] [    0.212633] pci_bus 0000:00: resource 12 [mem
0x000d0000-0x000d1fff] [    0.212636] pci_bus 0000:00: resource 13 [mem
0x000d2000-0x000d3fff] [    0.212640] pci_bus 0000:00: resource 14 [mem
0x000d4000-0x000d5fff] [    0.212643] pci_bus 0000:00: resource 15 [mem
0x000d6000-0x000d7fff] [    0.212647] pci_bus 0000:00: resource 16 [mem
0x000d8000-0x000d9fff] [    0.212650] pci_bus 0000:00: resource 17 [mem
0x000da000-0x000dbfff] [    0.212654] pci_bus 0000:00: resource 18 [mem
0x000dc000-0x000ddfff] [    0.212657] pci_bus 0000:00: resource 19 [mem
0x000de000-0x000dffff] [    0.212661] pci_bus 0000:00: resource 20 [mem
0x000e0000-0x000e1fff] [    0.212664] pci_bus 0000:00: resource 21 [mem
0x000e2000-0x000e3fff] [    0.212668] pci_bus 0000:00: resource 22 [mem
0x000e4000-0x000e5fff] [    0.212672] pci_bus 0000:00: resource 23 [mem
0x000e6000-0x000e7fff] [    0.212675] pci_bus 0000:00: resource 24 [mem
0x000e8000-0x000e9fff] [    0.212679] pci_bus 0000:00: resource 25 [mem
0x000ea000-0x000ebfff] [    0.212682] pci_bus 0000:00: resource 26 [mem
0x000ec000-0x000edfff] [    0.212686] pci_bus 0000:00: resource 27 [mem
0x000ee000-0x000effff] [    0.212689] pci_bus 0000:00: resource 28 [mem
0xe0000000-0xf7ffffff] [    0.212693] pci_bus 0000:00: resource 29 [mem
0xf8000000-0xffffffff] [    0.212697] pci_bus 0000:00: resource 30 [io
0x0000-0x0cf7] [    0.212700] pci_bus 0000:00: resource 31 [io
0x0d00-0xffff] [    0.212704] pci_bus 0000:01: resource 1 [mem
0xf0200000-0xf02fffff] [    0.212708] pci_bus 0000:02: resource 0 [io
0x2000-0x2fff] [    0.212712] pci_bus 0000:02: resource 1 [mem
0xf0100000-0xf01fffff] [    0.212716] pci_bus 0000:03: resource 0 [io
0x1000-0x1fff] [    0.212719] pci_bus 0000:03: resource 1 [mem
0xf0000000-0xf00fffff] [    0.212723] pci_bus 0000:03: resource 2 [mem
0xf0400000-0xf06fffff pref] [    0.212728] pci_bus 0000:04: resource 4
[mem 0x000a0000-0x000bffff] [    0.212731] pci_bus 0000:04: resource 5
[mem 0x000c0000-0x000c1fff] [    0.212735] pci_bus 0000:04: resource 6
[mem 0x000c2000-0x000c3fff] [    0.212739] pci_bus 0000:04: resource 7
[mem 0x000c4000-0x000c5fff] [    0.212742] pci_bus 0000:04: resource 8
[mem 0x000c6000-0x000c7fff] [    0.212746] pci_bus 0000:04: resource 9
[mem 0x000c8000-0x000c9fff] [    0.212749] pci_bus 0000:04: resource 10
[mem 0x000ca000-0x000cbfff] [    0.212753] pci_bus 0000:04: resource 11
[mem 0x000cc000-0x000cdfff] [    0.212756] pci_bus 0000:04: resource 12
[mem 0x000d0000-0x000d1fff] [    0.212760] pci_bus 0000:04: resource 13
[mem 0x000d2000-0x000d3fff] [    0.212763] pci_bus 0000:04: resource 14
[mem 0x000d4000-0x000d5fff] [    0.212767] pci_bus 0000:04: resource 15
[mem 0x000d6000-0x000d7fff] [    0.212770] pci_bus 0000:04: resource 16
[mem 0x000d8000-0x000d9fff] [    0.212774] pci_bus 0000:04: resource 17
[mem 0x000da000-0x000dbfff] [    0.212777] pci_bus 0000:04: resource 18
[mem 0x000dc000-0x000ddfff] [    0.212780] pci_bus 0000:04: resource 19
[mem 0x000de000-0x000dffff] [    0.212784] pci_bus 0000:04: resource 20
[mem 0x000e0000-0x000e1fff] [    0.212787] pci_bus 0000:04: resource 21
[mem 0x000e2000-0x000e3fff] [    0.212791] pci_bus 0000:04: resource 22
[mem 0x000e4000-0x000e5fff] [    0.212794] pci_bus 0000:04: resource 23
[mem 0x000e6000-0x000e7fff] [    0.212798] pci_bus 0000:04: resource 24
[mem 0x000e8000-0x000e9fff] [    0.212802] pci_bus 0000:04: resource 25
[mem 0x000ea000-0x000ebfff] [    0.212806] pci_bus 0000:04: resource 26
[mem 0x000ec000-0x000edfff] [    0.212809] pci_bus 0000:04: resource 27
[mem 0x000ee000-0x000effff] [    0.212813] pci_bus 0000:04: resource 28
[mem 0xe0000000-0xf7ffffff] [    0.212816] pci_bus 0000:04: resource 29
[mem 0xf8000000-0xffffffff] [    0.212820] pci_bus 0000:04: resource 30
[io  0x0000-0x0cf7] [    0.212823] pci_bus 0000:04: resource 31 [io
0x0d00-0xffff] [    0.212923] NET: Registered protocol family 2
[    0.213325] TCP established hash table entries: 32768 (order: 6,
262144 bytes) [    0.213497] TCP bind hash table entries: 32768 (order:
7, 524288 bytes) [    0.213758] TCP: Hash tables configured
(established 32768 bind 32768) [    0.213860] TCP: reno registered
[    0.213873] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.213915] UDP-Lite hash table entries: 2048 (order: 4, 65536
bytes) [    0.214171] NET: Registered protocol family 1 [    0.214206]
pci 0000:00:01.0: Boot video device [    0.340349] PCI: CLS 32 bytes,
default 64 [    0.340449] Unpacking initramfs... [    0.504434] Freeing
initrd memory: 4700K (ffff8800376c2000 - ffff880037b59000)
[    0.504446] PCI-DMA: Using software bounce buffering for IO
(SWIOTLB) [    0.504451] software IO TLB [mem 0xc2ceb000-0xc6ceb000]
(64MB) mapped at [ffff8800c2ceb000-ffff8800c6ceafff] [    0.504727] LVT
offset 0 assigned for vector 0x400 [    0.504843] perf: AMD IBS
detected (0x000000ff) [    0.505631] futex hash table entries: 512
(order: 3, 32768 bytes) [    0.505770] audit: initializing netlink
subsys (disabled) [    0.505805] audit: type=2000
audit(1393860031.403:1): initialized [    0.506408] HugeTLB registered
2 MB page size, pre-allocated 0 pages [    0.506888] SGI XFS with ACLs,
security attributes, large block/inode numbers, no debug enabled
[    0.507223] msgmni has been set to 7107 [    0.508149] alg: No test
for stdrng (krng) [    0.508211] Block layer SCSI generic (bsg) driver
version 0.4 loaded (major 253) [    0.508219] io scheduler noop
registered [    0.508237] io scheduler cfq registered (default)
[    0.508698] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    0.509020] pcieport 0000:00:06.0: irq 41 for MSI/MSI-X
[    0.509278] pcieport 0000:00:07.0: irq 42 for MSI/MSI-X
[    0.509448] pcieport 0000:00:04.0: Signaling PME through PCIe PME
interrupt [    0.509453] pci 0000:01:00.0: Signaling PME through PCIe
PME interrupt [    0.509459] pcie_pme 0000:00:04.0:pcie01: service
driver pcie_pme loaded [    0.509485] pcieport 0000:00:06.0: Signaling
PME through PCIe PME interrupt [    0.509489] pci 0000:02:00.0:
Signaling PME through PCIe PME interrupt [    0.509495] pcie_pme
0000:00:06.0:pcie01: service driver pcie_pme loaded [    0.509525]
pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    0.509529] pci 0000:03:00.0: Signaling PME through PCIe PME
interrupt [    0.509535] pcie_pme 0000:00:07.0:pcie01: service driver
pcie_pme loaded [    0.509545] pci_hotplug: PCI Hot Plug PCI Core
version: 0.5 [    0.509641] GHES: HEST is not enabled! [    0.509785]
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled [    0.510790]
i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64
irq 1,12 [    0.514775] i8042: Detected active multiplexing controller,
rev 1.1 [    0.516372] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.516383] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.516403] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.516407] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.516411] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.516728] mousedev: PS/2 mouse device common for all mice
[    0.516863] rtc_cmos 00:03: RTC can wake from S4 [    0.517121]
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0 [    0.517215]
rtc_cmos 00:03: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.517368] drop_monitor: Initializing network drop monitor service
[    0.517461] TCP: cubic registered [    0.517563] NET: Registered
protocol family 10 [    0.517963] NET: Registered protocol family 17
[    0.518503] registered taskstats version 1 [    0.519235] rtc_cmos
00:03: setting system clock to 2014-03-03 15:20:32 UTC (1393860032)
[    0.521165] Freeing unused kernel memory: 836K (ffffffff81894000 -
ffffffff81965000) [    0.521173] Write protecting the kernel read-only
data: 8192k [    0.530171] Freeing unused kernel memory: 1756K
(ffff880001449000 - ffff880001600000) [    0.533393] Freeing unused
kernel memory: 620K (ffff880001765000 - ffff880001800000)
[    0.565470] input: AT Translated Set 2 keyboard
as /devices/platform/i8042/serio0/input/input0 [    0.702521]
systemd-udevd[59]: starting version 204 [    0.761883] atl1c
0000:02:00.0: version 1.0.1.1-NAPI [    0.772791] rtsx_pci
0000:03:00.0: irq 43 for MSI/MSI-X [    0.772817] rtsx_pci
0000:03:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 1, pci->irq = 43
[    0.786099] ACPI: bus type USB registered [    0.786163] usbcore:
registered new interface driver usbfs [    0.786196] usbcore:
registered new interface driver hub [    0.787422] thermal LNXTHERM:00:
registered as thermal_zone0 [    0.787431] ACPI: Thermal Zone [THZ0]
(74 C) [    0.788180] SCSI subsystem initialized [    0.789031]
usbcore: registered new device driver usb [    0.789818] ehci_hcd: USB
2.0 'Enhanced' Host Controller (EHCI) Driver [    0.790272] ehci-pci:
EHCI PCI platform driver [    0.790396] ohci_hcd: USB 1.1 'Open' Host
Controller (OHCI) Driver [    0.790709] ohci-pci: OHCI PCI platform
driver [    0.790715] QUIRK: Enable AMD PLL fix [    0.790808] ehci-pci
0000:00:12.2: EHCI Host Controller [    0.790822] ehci-pci
0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.790834] ehci-pci 0000:00:12.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround [    0.790896] ehci-pci
0000:00:12.2: debug port 1 [    0.790959] ehci-pci 0000:00:12.2: irq
17, io mem 0xf034a500 [    0.792755] libata version 3.00 loaded.
[    0.796468] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.796682] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002 [    0.796687] usb usb1: New USB device strings: Mfr=3,
Product=2, SerialNumber=1 [    0.796691] usb usb1: Product: EHCI Host
Controller [    0.796695] usb usb1: Manufacturer: Linux 3.14.0-rc5
ehci_hcd [    0.796698] usb usb1: SerialNumber: 0000:00:12.2
[    0.796963] hub 1-0:1.0: USB hub found [    0.796980] hub 1-0:1.0: 5
ports detected [    0.797752] ehci-pci 0000:00:13.2: EHCI Host
Controller [    0.797767] ehci-pci 0000:00:13.2: new USB bus
registered, assigned bus number 2 [    0.797776] ehci-pci 0000:00:13.2:
applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.797792] ehci-pci 0000:00:13.2: debug port 1 [    0.797838]
ehci-pci 0000:00:13.2: irq 17, io mem 0xf034a400 [    0.803373]
ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00 [    0.803479] usb
usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.803484] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1 [    0.803488] usb usb2: Product: EHCI Host Controller
[    0.803492] usb usb2: Manufacturer: Linux 3.14.0-rc5 ehci_hcd
[    0.803495] usb usb2: SerialNumber: 0000:00:13.2 [    0.804288] hub
2-0:1.0: USB hub found [    0.804310] hub 2-0:1.0: 5 ports detected
[    0.805000] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    0.805026] ohci-pci 0000:00:12.0: new USB bus registered, assigned
bus number 3 [    0.805142] ohci-pci 0000:00:12.0: irq 18, io mem
0xf0349000 [    0.859727] usb usb3: New USB device found,
idVendor=1d6b, idProduct=0001 [    0.859736] usb usb3: New USB device
strings: Mfr=3, Product=2, SerialNumber=1 [    0.859741] usb usb3:
Product: OHCI PCI host controller [    0.859744] usb usb3:
Manufacturer: Linux 3.14.0-rc5 ohci_hcd [    0.859748] usb usb3:
SerialNumber: 0000:00:12.0 [    0.860070] hub 3-0:1.0: USB hub found
[    0.860142] hub 3-0:1.0: 5 ports detected [    0.860546] ahci
0000:00:11.0: version 3.0 [    0.860907] ahci 0000:00:11.0: AHCI
0001.0200 32 slots 1 ports 3 Gbps 0x1 impl SATA mode [    0.860914]
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum
part [    0.868041] scsi0 : ahci [    0.868202] ata1: SATA max UDMA/133
abar m1024@0xf034a000 port 0xf034a100 irq 19 [    0.868648] ohci-pci
0000:00:13.0: OHCI PCI host controller [    0.868670] ohci-pci
0000:00:13.0: new USB bus registered, assigned bus number 4
[    0.868777] ohci-pci 0000:00:13.0: irq 18, io mem 0xf0348000
[    0.878088] microcode: CPU0: patch_level=0x05000101 [    0.884259]
microcode: CPU0: new patch_level=0x05000119 [    0.895149] microcode:
CPU1: patch_level=0x05000101 [    0.901259] microcode: CPU1: new
patch_level=0x05000119 [    0.902455] microcode: Microcode Update
Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba [    0.923607]
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.923616] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1 [    0.923620] usb usb4: Product: OHCI PCI host
controller [    0.923624] usb usb4: Manufacturer: Linux 3.14.0-rc5
ohci_hcd [    0.923628] usb usb4: SerialNumber: 0000:00:13.0
[    0.923990] hub 4-0:1.0: USB hub found [    0.924011] hub 4-0:1.0: 5
ports detected [    1.106739] usb 2-5: new high-speed USB device number
2 using ehci-pci [    1.234596] usb 2-5: New USB device found,
idVendor=5986, idProduct=01a6 [    1.234611] usb 2-5: New USB device
strings: Mfr=1, Product=2, SerialNumber=3 [    1.234619] usb 2-5:
Product: Integrated Camera [    1.234626] usb 2-5: Manufacturer: Image
Processor [    1.234631] usb 2-5: SerialNumber: Integrated Camera
[    1.328689] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.355647] ata1.00: ATA-8: ST320LT007-9ZV142, 0004LVM1, max
UDMA/133 [    1.355657] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ
(depth 31/32) [    1.359554] ata1.00: configured for UDMA/133
[    1.360154] scsi 0:0:0:0: Direct-Access     ATA
ST320LT007-9ZV14 0004 PQ: 0 ANSI: 5 [    1.371367] sd 0:0:0:0: [sda]
625142448 512-byte logical blocks: (320 GB/298 GiB) [    1.371377] sd
0:0:0:0: [sda] 4096-byte physical blocks [    1.371747] sd 0:0:0:0:
[sda] Write Protect is off [    1.371753] sd 0:0:0:0: [sda] Mode Sense:
00 3a 00 00 [    1.371795] sd 0:0:0:0: [sda] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA [    1.385552]  sda: sda1
sda2 [    1.387028] sd 0:0:0:0: [sda] Attached SCSI disk [    1.390557]
sd 0:0:0:0: Attached scsi generic sg0 type 0 [    1.505693] tsc:
Refined TSC clocksource calibration: 1646.492 MHz [    1.725719]
device-mapper: uevent: version 1.0.3 [    1.725828] device-mapper:
ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    1.734716] random: lvm urandom read with 60 bits of entropy
available [    2.506210] Switched to clocksource tsc [    3.257829]
random: nonblocking pool is initialized [    6.442224] sha256_ssse3:
Using SSSE3 optimized SHA-256 implementation [    6.444710] bio: create
slab <bio-1> at 1 [    6.666335] bio: create slab <bio-1> at 1
[    7.086264] PM: Starting manual resume from disk [    7.092253] XFS
(dm-1): Mounting Filesystem [    7.298350] XFS (dm-1): Ending clean
mount [   10.245772] systemd-udevd[427]: starting version 204
[   11.845425] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[   11.932703] ACPI: acpi_idle registered with cpuidle [   11.979458]
input: HD-Audio Generic HDMI/DP,pcm=3
as /devices/pci0000:00/0000:00:01.1/sound/card0/input5 [   11.993048]
hda_codec: CX20590: BIOS auto-probing. [   11.994715] input: HDA
Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
[   12.054192] ACPI Warning: SystemIO range
0x0000000000000b00-0x0000000000000b07 conflicts with OpRegion
0x0000000000000b00-0x0000000000000b0f (\_SB_.PCI0.SMB_.SMB0)
(20131218/utaddress-258) [   12.054208] ACPI: If an ACPI driver is
available for this device, you should use it instead of the native
driver [   12.110101] ACPI: Video Device [VGA] (multi-head: yes  rom:
no  post: no) [   12.110131] [Firmware Bug]: ACPI: No _BQC method,
cannot determine initial brightness [   12.110228] [Firmware Bug]:
ACPI: No _BQC method, cannot determine initial brightness
[   12.113207] acpi device:02: registered as cooling_device2
[   12.113316] input: Video Bus
as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input7
[   12.113436] ACPI: Video Device [VGA1] (multi-head: yes  rom: no
post: no) [   12.133242] acpi device:38: registered as cooling_device3
[   12.133376] input: Video Bus
as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input8
[   12.170303] Linux video capture interface: v2.00 [   12.197243]
cfg80211: Calling CRDA to update world regulatory domain [   12.219165]
Intel(R) Wireless WiFi driver for Linux, in-tree: [   12.219172]
Copyright(c) 2003- 2014 Intel Corporation [   12.219661] iwlwifi
0000:01:00.0: irq 45 for MSI/MSI-X [   12.269003] ACPI: AC Adapter
[ACAD] (on-line) [   12.304159] ACPI: Battery Slot [BAT1] (battery
present) [   12.304295] input: Power Button
as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input9
[   12.304306] ACPI: Power Button [PWRB] [   12.304386] input: Sleep
Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input10
[   12.304391] ACPI: Sleep Button [SLPB] [   12.304514] input: Lid
Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input11
[   12.304857] ACPI: Lid Switch [LID] [   12.304994] input: Power
Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input12 [   12.305001]
ACPI: Power Button [PWRF] [   12.325266] acpi-cpufreq: overriding BIOS
provided _PSD data [   12.344764] Linux agpgart interface v0.103
[   12.374346] [drm] Initialized drm 1.1.0 20060810 [   12.446977]
Non-volatile memory driver v1.3 [   12.453842] wmi: Mapper loaded
[   12.489927] input: PC Speaker
as /devices/platform/pcspkr/input/input13 [   12.512101] uvcvideo:
Found UVC 1.00 device Integrated Camera (5986:01a6) [   12.513891]
input: Integrated Camera
as /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input14
[   12.514037] usbcore: registered new interface driver uvcvideo
[   12.514041] USB Video Class driver (1.1.1) [   12.622854]
thinkpad_acpi: ThinkPad ACPI Extras v0.25 [   12.622862] thinkpad_acpi:
http://ibm-acpi.sf.net/ [   12.622866] thinkpad_acpi: ThinkPad BIOS
8RET52WW (1.15 ), EC unknown [   12.622869] thinkpad_acpi: Lenovo
ThinkPad X121e, model 30515YG [   12.623358] thinkpad_acpi: Unsupported
brightness interface, please contact
ibm-acpi-devel@lists.sourceforge.net [   12.624220] thinkpad_acpi:
radio switch found; radios are enabled [   12.624271] thinkpad_acpi:
possible tablet mode switch found; ThinkPad in laptop mode
[   12.624310] thinkpad_acpi: This ThinkPad has standard ACPI backlight
brightness control, supported by the ACPI video driver [   12.624313]
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   12.647985] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio
is blocked [   12.649643] thinkpad_acpi: Console audio control enabled,
mode: monitor (read only) [   12.654396] input: ThinkPad Extra Buttons
as /devices/platform/thinkpad_acpi/input/input15 [   12.664347] input:
HDA ATI SB Headphone
as /devices/pci0000:00/0000:00:14.2/sound/card1/input17 [   12.664615]
input: HDA ATI SB Mic
as /devices/pci0000:00/0000:00:14.2/sound/card1/input16 [   12.994110]
iwlwifi 0000:01:00.0: loaded firmware version 9.221.4.1 build 25532
op_mode iwldvm [   13.318102] [drm] radeon kernel modesetting enabled.
[   13.319255] [drm] initializing kernel modesetting (PALM
0x1002:0x9806 0x17AA:0x21EC). [   13.319311] [drm] register mmio base:
0xF0300000 [   13.319313] [drm] register mmio size: 262144
[   13.319414] ATOM BIOS: Lenovo [   13.319489] radeon 0000:00:01.0:
VRAM: 384M 0x0000000000000000 - 0x0000000017FFFFFF (384M used)
[   13.319494] radeon 0000:00:01.0: GTT: 1024M 0x0000000018000000 -
0x0000000057FFFFFF [   13.319497] [drm] Detected VRAM RAM=384M,
BAR=256M [   13.319500] [drm] RAM width 32bits DDR [   13.319593] [TTM]
Zone  kernel: Available graphics memory: 1821058 kiB [   13.319596]
[TTM] Initializing pool allocator [   13.319606] [TTM] Initializing DMA
pool allocator [   13.319648] [drm] radeon: 384M of VRAM memory ready
[   13.319651] [drm] radeon: 1024M of GTT memory ready. [   13.319673]
[drm] Loading PALM Microcode [   13.350105] iwlwifi 0000:01:00.0:
CONFIG_IWLWIFI_DEBUG disabled [   13.350120] iwlwifi 0000:01:00.0:
CONFIG_IWLWIFI_DEBUGFS disabled [   13.350128] iwlwifi 0000:01:00.0:
CONFIG_IWLWIFI_DEVICE_TRACING disabled [   13.350137] iwlwifi
0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN,
REV=0x74 [   13.350365] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   13.432938] usb 3-4: new full-speed USB device number 2 using
ohci-pci [   13.589577] usb 3-4: New USB device found, idVendor=0a5c,
idProduct=217f [   13.589592] usb 3-4: New USB device strings: Mfr=1,
Product=2, SerialNumber=3 [   13.589600] usb 3-4: Product: Broadcom
Bluetooth Device [   13.589607] usb 3-4: Manufacturer: Broadcom Corp
[   13.589613] usb 3-4: SerialNumber: E4D53DC801B2 [   13.609251]
ieee80211 phy0: Selected rate control algorithm
'iwl-agn-rs' [   13.720002] psmouse serio4: synaptics: Touchpad model:
1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x123c00, board id:
1917, fw id: 864720 [   13.720031] psmouse serio4: synaptics: serio:
Synaptics pass-through port at isa0060/serio4/input0 [   13.763378]
input: SynPS/2 Synaptics TouchPad
as /devices/platform/i8042/serio4/input/input21 [   13.907564] [drm]
Internal thermal controller without fan control [   13.907769] [drm]
Found smc ucode version: 0x00010601 [   13.908034] [drm] radeon: dpm
initialized [   13.926141] [drm] GART: num cpu pages 262144, num gpu
pages 262144 [   13.947069] [drm] PCIE GART of 1024M enabled (table at
0x0000000000273000). [   13.947701] radeon 0000:00:01.0: WB enabled
[   13.947715] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr
0x0000000018000c00 and cpu addr 0xffff8800376f0c00 [   13.947724]
radeon 0000:00:01.0: fence driver on ring 3 use gpu addr
0x0000000018000c0c and cpu addr 0xffff8800376f0c0c [   13.949267]
radeon 0000:00:01.0: fence driver on ring 5 use gpu addr
0x0000000000072118 and cpu addr 0xffffc900028b2118 [   13.949346] [drm]
Supports vblank timestamp caching Rev 2 (21.10.2013). [   13.949358]
[drm] Driver supports precise vblank timestamp query. [   13.949409]
radeon 0000:00:01.0: irq 46 for MSI/MSI-X [   13.949440] radeon
0000:00:01.0: radeon: using MSI. [   13.949492] [drm] radeon: irq
initialized. [   13.967614] [drm] ring test on 0 succeeded in 1 usecs
[   13.967698] [drm] ring test on 3 succeeded in 1 usecs [   14.024184]
[drm] ring test on 5 succeeded in 1 usecs [   14.044314] [drm] UVD
initialized successfully. [   14.045325] [drm] ib test on ring 0
succeeded in 0 usecs [   14.045426] [drm] ib test on ring 3 succeeded
in 0 usecs [   14.064586] Bluetooth: Core ver 2.18 [   14.064672] NET:
Registered protocol family 31 [   14.064676] Bluetooth: HCI device and
connection manager initialized [   14.065105] Bluetooth: HCI socket
layer initialized [   14.065113] Bluetooth: L2CAP socket layer
initialized [   14.065142] Bluetooth: SCO socket layer initialized
[   14.066485] [drm] ib test on ring 5 succeeded [   14.138967] [drm]
radeon atom DIG backlight initialized [   14.138989] [drm] Radeon
Display Connectors [   14.138995] [drm] Connector 0: [   14.139003]
[drm]   LVDS-1 [   14.139007] [drm]   HPD1 [   14.139015] [drm]   DDC:
0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c [   14.139020]
[drm]   Encoders: [   14.139024] [drm]     LCD1: INTERNAL_UNIPHY
[   14.139028] [drm] Connector 1: [   14.139033] [drm]   HDMI-A-1
[   14.139036] [drm]   HPD2 [   14.139043] [drm]   DDC: 0x6440 0x6440
0x6444 0x6444 0x6448 0x6448 0x644c 0x644c [   14.139046] [drm]
Encoders: [   14.139050] [drm]     DFP1: INTERNAL_UNIPHY [   14.139054]
[drm] Connector 2: [   14.139058] [drm]   VGA-1 [   14.139064] [drm]
DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 0x64e4
[   14.139068] [drm]   Encoders: [   14.139072] [drm]     CRT1:
INTERNAL_KLDSCP_DAC1 [   14.335848] usbcore: registered new interface
driver btusb [   14.390389] cfg80211: World regulatory domain updated:
[   14.390406] cfg80211:  DFS Master region: unset [   14.390411]
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp) [   14.390419] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000
KHz), (N/A, 2000 mBm) [   14.390426] cfg80211:   (2457000 KHz - 2482000
KHz @ 40000 KHz), (N/A, 2000 mBm) [   14.390431] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm) [   14.390437]
cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm)
[   14.390442] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm) [   14.390448] cfg80211:   (57240000 KHz - 63720000 KHz
@ 2160000 KHz), (N/A, 0 mBm) [   14.390799] cfg80211: Calling CRDA for
country: DE [   14.419151] cfg80211: Regulatory domain changed to
country: DE [   14.419163] cfg80211:  DFS Master region: ETSI
[   14.419169] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp) [   14.419175] cfg80211:   (2400000 KHz -
2483500 KHz @ 40000 KHz), (N/A, 2000 mBm) [   14.419179] cfg80211:
(5150000 KHz - 5350000 KHz @ 80000 KHz), (N/A, 2000 mBm) [   14.419182]
cfg80211:   (5470000 KHz - 5725000 KHz @ 80000 KHz), (N/A, 2698 mBm)
[   14.419186] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz),
(N/A, 4000 mBm) [   14.563465] [drm] fb mappable at 0xE0477000
[   14.563474] [drm] vram apper at 0xE0000000 [   14.563477] [drm] size
4325376 [   14.563480] [drm] fb depth is 24 [   14.563483] [drm]
pitch is 5632 [   14.563767] fbcon: radeondrmfb (fb0) is primary device
[   15.127958] Console: switching to colour frame buffer device 170x48
[   15.134456] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer
device [   15.134460] radeon 0000:00:01.0: registered panic notifier
[   15.135419] [drm] Initialized radeon 2.37.0 20080528 for
0000:00:01.0 on minor 0 [   16.792941] Adding 4001788k swap
on /dev/mapper/encrypted-swap.  Priority:-1 extents:1 across:4001788k
[   16.878938] psmouse serio5: alps: Unknown ALPS touchpad: E7=10 00
64, EC=10 00 64 [   18.256795] psmouse serio5: trackpoint: IBM
TrackPoint firmware: 0x0e, buttons: 3/3 [   18.483078] input: TPPS/2
IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input22
[   19.372185] fuse init (API version 7.22) [   19.572798] loop: module
loaded [   20.150009] XFS (sda1): Mounting Filesystem [   20.281452]
XFS (sda1): Ending clean mount
