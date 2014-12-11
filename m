Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934304AbaLKJYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:24:22 -0500
Received: from dub004-omc1s6.hotmail.com ([157.55.0.205]:57757 "EHLO
	DUB004-OMC1S6.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbaLKJYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:24:13 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2014 04:24:13 EST
X-TMN: [BLZcKdld1M6Trp0s6aSX7WRQF0zCD+a4]
X-Originating-Email: [pupilla@hotmail.com]
Message-ID: <DUB126-W86C77A2434004F601B9878B2630@phx.gbl>
From: Marco Berizzi <pupilla@hotmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
Date: Thu, 11 Dec 2014 10:19:09 +0100
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Dec 2014 09:19:10.0019 (UTC) FILETIME=[856B6130:01D01523]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

I'm running slackware linux 14 32 bits as a firewall/ipsec
gateway with linux 3.18.0
I got this error just after 12 hours uptime:

WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:303 dev_watchdog+0xee/0x174()
NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
Modules linked in: xfrm4_tunnel af_key authenc xfrm4_mode_tunnel deflate zlib_deflate zlib_inflate ctr twofish_generic twofish_i586 twofish_common serpent_sse2_i586 serpent_generic glue_helper blowfish_generic blowfish_common cbc ecb sha512_generic hmac tunnel4 ipcomp xfrm_ipcomp esp4 xts lrw gf128mul ablk_helper cryptd aes_i586 des_generic md5 sha1_generic sha256_generic nf_nat_pptp nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp nf_conntrack_ftp xt_helper xt_mark xt_statistic xt_nat xt_multiport xt_limit xt_tcpudp xt_policy xt_conntrack iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables uhci_hcd ehci_pci tg3 ehci_hcd 8250 ptp usbcore pps_core serial_core libphy rtc_cmos r8169 usb_common mii processor thermal_sys hwmon loop [last unloaded: af_key]
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0 #1
Hardware name: Hewlett-Packard HP xw4400 Workstation/0A68h, BIOS 786D7 v02.07 10/28/2010
 00000000 c125fe2a f580bf6c c10282cb c1202130 f5904000 00000000 02b1e170
 00000000 c1028346 00000009 f580bf6c c1302f9c f580bf84 c1202130 c1302fd5
 0000012f c1302f9c f5904000 f812e2e0 00000000 80000100 c1202042 f580bfbc
Call Trace:
 [<c125fe2a>] ? dump_stack+0x3e/0x4e
 [<c10282cb>] ? warn_slowpath_common+0x61/0x74
 [<c1202130>] ? dev_watchdog+0xee/0x174
 [<c1028346>] ? warn_slowpath_fmt+0x29/0x2d
 [<c1202130>] ? dev_watchdog+0xee/0x174
 [<c1202042>] ? pfifo_fast_dequeue+0xa2/0xa2
 [<c1051446>] ? call_timer_fn.isra.30+0xf/0x5a
 [<c10516b1>] ? run_timer_softirq+0x126/0x16f
 [<c102a10c>] ? __do_softirq+0x8f/0x16c
 [<c102a07d>] ? __hrtimer_tasklet_trampoline+0x13/0x13
 [<c1002e71>] ? do_softirq_own_stack+0x1a/0x1f
 <IRQ>  [<c102a313>] ? irq_exit+0x31/0x70
 [<c101cbec>] ? smp_apic_timer_interrupt+0x30/0x39
 [<c1263609>] ? apic_timer_interrupt+0x2d/0x34
 [<c1007502>] ? default_idle+0x2/0x3
 [<c1007a0f>] ? arch_cpu_idle+0x6/0x7
 [<c1046686>] ? cpu_startup_entry+0xeb/0x211
 [<c135a95c>] ? start_kernel+0x2d2/0x2d5
---[ end trace 71b9cfb317b62846 ]---
r8169 0000:10:00.0 eth0: link up

Is this error related to ASPM?
Any response are welcome.
TIA
Here is dmesg output

Linux version 3.18.0 (root@Pleiadi) (gcc version 4.7.1 (GCC) ) #1 SMP Tue Dec 9 16:46:26 CET 2014
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000bffc62ff] usable
BIOS-e820: [mem 0x00000000bffc6300-0x00000000bfffffff] reserved
BIOS-e820: [mem 0x00000000f0000000-0x00000000f3ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fed3ffff] reserved
BIOS-e820: [mem 0x00000000fed45000-0x00000000ffffffff] reserved
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
SMBIOS 2.4 present.
DMI: Hewlett-Packard HP xw4400 Workstation/0A68h, BIOS 786D7 v02.07 10/28/2010
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0xbffc6 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-E3FFF write-protect
  E4000-EFFFF write-back
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 080000000 mask FC0000000 write-back
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [mem 0x000f9bf0-0x000f9bff] mapped at [c00f9bf0]
initial memory mapped: [mem 0x00000000-0x017fffff]
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
init_memory_mapping: [mem 0x37000000-0x373fffff]
 [mem 0x37000000-0x373fffff] page 2M
init_memory_mapping: [mem 0x30000000-0x36ffffff]
 [mem 0x30000000-0x36ffffff] page 2M
init_memory_mapping: [mem 0x00100000-0x2fffffff]
 [mem 0x00100000-0x003fffff] page 4k
 [mem 0x00400000-0x2fffffff] page 2M
init_memory_mapping: [mem 0x37400000-0x377fdfff]
 [mem 0x37400000-0x377fdfff] page 4k
BRK [0x0141c000, 0x0141cfff] PGTABLE
ACPI: Early table checksum verification disabled
ACPI: RSDP 0x000E7810 000014 (v00 COMPAQ)
ACPI: RSDT 0xBFFC6340 000044 (v01 HPQOEM SLIC-WKS 20101028      00000000)
ACPI: FACP 0xBFFC63EC 000074 (v01 COMPAQ GLENWOOD 00000001      00000000)
ACPI: DSDT 0xBFFC6763 00037B (v01 COMPAQ DSDT_PRJ 00000001 MSFT 0100000E)
ACPI: FACS 0xBFFC6300 000040
ACPI: SSDT 0xBFFC6ADE 008C6C (v01 COMPAQ DSDT_HW  00000001 MSFT 0100000E)
ACPI: APIC 0xBFFC6460 000084 (v01 COMPAQ GLENWOOD 00000001      00000000)
ACPI: ASF! 0xBFFC64E4 000063 (v32 COMPAQ GLENWOOD 00000001      00000000)
ACPI: MCFG 0xBFFC6547 00003C (v01 COMPAQ GLENWOOD 00000001      00000000)
ACPI: TCPA 0xBFFC6583 000032 (v01 COMPAQ GLENWOOD 00000001      00000000)
ACPI: SLIC 0xBFFC65B5 000176 (v01 HPQOEM SLIC-WKS 00000001      00000000)
ACPI: HPET 0xBFFC672B 000038 (v01 COMPAQ GLENWOOD 00000001      00000000)
ACPI: Local APIC address 0xfee00000
2183MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
BRK [0x0141d000, 0x0141dfff] PGTABLE
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  Normal   [mem 0x01000000-0x377fdfff]
  HighMem  [mem 0x377fe000-0xbffc5fff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009efff]
  node   0: [mem 0x00100000-0xbffc5fff]
Initmem setup node 0 [mem 0x00001000-0xbffc5fff]
On node 0 totalpages: 786276
free_area_init_node: node 0, pgdat c13542c0, node_mem_map f5ffe020
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3998 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 223230 pages, LIFO batch:31
  HighMem zone: 4368 pages used for memmap
  HighMem zone: 559048 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0xf808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
e820: [mem 0xc0000000-0xefffffff] available for PCI devices
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 14 pages/cpu @f5fd0000 s25664 r0 d31680 u57344
pcpu-alloc: s25664 r0 d31680 u57344 alloc=14*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 784500
Kernel command line: auto BOOT_IMAGE=Linux ro root=801 vt.default_utf8=0
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:000bffc6)
Initializing Movable for node 0 (00000000:00000000)
Memory: 3115256K/3145104K available (2448K kernel code, 182K rwdata, 788K rodata, 332K init, 404K bss, 29848K reserved, 2236192K highmem)
virtual kernel memory layout:
    fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc135a000 - 0xc13ad000   ( 332 kB)
      .data : 0xc126462f - 0xc1358a40   ( 977 kB)
      .text : 0xc1000000 - 0xc126462f   (2449 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:2304 nr_irqs:440 0
CPU 0 irqstacks, hard=f5808000 soft=f580a000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2400.197 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 4800.39 BogoMIPS (lpj=2400197)
pid_max: default: 32768 minimum: 301
ACPI: Core revision 20140926
ACPI: All ACPI Tables successfully acquired
Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
Freeing SMP alternatives memory: 12K (c13ad000 - c13b0000)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz (fam: 06, model: 0f, stepping: 06)
Performance Events: PEBS fmt0-, 4-deep LBR, Core2 events, Intel PMU driver.
perf_event_intel: PEBS disabled due to CPU errata
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
CPU 1 irqstacks, hard=f5892000 soft=f5894000
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
Initializing CPU#1
x86: Booted up 1 node, 2 CPUs
smpboot: Total of 2 processors activated (9600.78 BogoMIPS)
devtmpfs: initialized
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI: bus type PCI registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT 0xF5A10000 0004DF (v01 COMPAQ CPU_TM2  00000001 MSFT 0100000E)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
ACPI BIOS Error (bug): \_SB_.PCI0._OSC: Excess arguments - ASL declared 5, ACPI requires 4 (20140926/nsarguments-189)
ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20140926/dsfield-211)
ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node f58326c0), AE_ALREADY_EXISTS (20140926/psparse-536)
acpi PNP0A08:00: _OSC failed (AE_ALREADY_EXISTS); disabling ASPM
acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [mem 0xf4000000-0xfebfffff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x1000-0x2fff]
pci_bus 0000:00: root bus resource [io  0x3000-0x6fff]
pci_bus 0000:00: root bus resource [io  0x7000-0xafff]
pci_bus 0000:00: root bus resource [io  0xb000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xefffffff]
pci 0000:00:00.0: [8086:277c] type 00 class 0x060000
pci 0000:00:01.0: [8086:277d] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
pci 0000:00:1b.0: reg 0x10: [mem 0x00000000-0x00003fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: [8086:27e0] type 01 class 0x060400
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: [8086:27e2] type 01 class 0x060400
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 0x20: [io  0x4000-0x401f]
pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 0x20: [io  0x4020-0x403f]
pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 0x20: [io  0x4040-0x405f]
pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
pci 0000:00:1d.3: reg 0x20: [io  0x4060-0x407f]
pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 0x10: [mem 0xe9004000-0xe90043ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1f.0: [8086:27b8] type 00 class 0x060100
pci 0000:00:1f.0: can't claim BAR 7 [io  0xf800-0xf87f]: address conflict with ACPI CPU throttle [io  0xf810-0xf815]
pci 0000:00:1f.0: quirk: [io  0xfa00-0xfa3f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0400 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0480 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0cb0 (mask 000f)
pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
pci 0000:00:1f.1: reg 0x10: [io  0x40c0-0x40c7]
pci 0000:00:1f.1: reg 0x14: [io  0x40e0-0x40e3]
pci 0000:00:1f.1: reg 0x18: [io  0x40c8-0x40cf]
pci 0000:00:1f.1: reg 0x1c: [io  0x40e4-0x40e7]
pci 0000:00:1f.1: reg 0x20: [io  0x40a0-0x40af]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
pci 0000:00:1f.2: [8086:27c1] type 00 class 0x010601
pci 0000:00:1f.2: reg 0x10: [io  0x40d0-0x40d7]
pci 0000:00:1f.2: reg 0x14: [io  0x40e8-0x40eb]
pci 0000:00:1f.2: reg 0x18: [io  0x40d8-0x40df]
pci 0000:00:1f.2: reg 0x1c: [io  0x40ec-0x40ef]
pci 0000:00:1f.2: reg 0x20: [io  0x40b0-0x40bf]
pci 0000:00:1f.2: reg 0x24: [mem 0xe9004400-0xe90047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:01:00.0: [1002:5b63] type 00 class 0x030000
pci 0000:01:00.0: reg 0x10: [mem 0xe0000000-0xe7ffffff pref]
pci 0000:01:00.0: reg 0x14: [io  0x3000-0x30ff]
pci 0000:01:00.0: reg 0x18: [mem 0xe8b00000-0xe8b0ffff]
pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: [1002:5b73] type 00 class 0x038000
pci 0000:01:00.1: reg 0x10: [mem 0xe8b10000-0xe8b1ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:01.0:   bridge window [mem 0xe8b00000-0xe8dfffff]
pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe81fffff 64bit pref]
pci 0000:10:00.0: [10ec:8168] type 00 class 0x020000
pci 0000:10:00.0: reg 0x10: [io  0x2000-0x20ff]
pci 0000:10:00.0: reg 0x18: [mem 0xe9600000-0xe9600fff 64bit]
pci 0000:10:00.0: reg 0x20: [mem 0xe8500000-0xe850ffff 64bit pref]
pci 0000:10:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
pci 0000:10:00.0: supports D1 D2
pci 0000:10:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1c.0: PCI bridge to [bus 10]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xe9400000-0xe96fffff]
pci 0000:00:1c.0:   bridge window [mem 0xe8500000-0xe87fffff 64bit pref]
pci 0000:28:00.0: [10ec:8168] type 00 class 0x020000
pci 0000:28:00.0: reg 0x10: [io  0x1000-0x10ff]
pci 0000:28:00.0: reg 0x18: [mem 0xe9100000-0xe9100fff 64bit]
pci 0000:28:00.0: reg 0x20: [mem 0xe8400000-0xe840ffff 64bit pref]
pci 0000:28:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
pci 0000:28:00.0: supports D1 D2
pci 0000:28:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1c.4: PCI bridge to [bus 28]
pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.4:   bridge window [mem 0xe9100000-0xe93fffff]
pci 0000:00:1c.4:   bridge window [mem 0xe8200000-0xe84fffff 64bit pref]
pci 0000:3f:00.0: [14e4:167b] type 00 class 0x020000
pci 0000:3f:00.0: reg 0x10: [mem 0xe8a00000-0xe8a0ffff 64bit]
pci 0000:3f:00.0: PME# supported from D3hot D3cold
pci 0000:00:1c.5: PCI bridge to [bus 3f]
pci 0000:00:1c.5:   bridge window [mem 0xe8800000-0xe8afffff]
pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x1000-0x2fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xb000-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xefffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
vgaarb: setting as boot device: PCI:0000:01:00.0
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
e820: reserve RAM buffer [mem 0xbffc6300-0xbfffffff]
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switched to clocksource hpet
pnp: PnP ACPI init
pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:03: [dma 3]
pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
pnp 00:05: [dma 2]
pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active)
system 00:06: [io  0x04d0-0x04d1] has been reserved
system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:07: [io  0x4e00-0x4e01] has been reserved
system 00:07: [io  0x0400-0x048f] has been reserved
system 00:07: [io  0x0cb0-0x0cbf] has been reserved
system 00:07: [io  0xf800-0xf87f] could not be reserved
system 00:07: [io  0xfa00-0xfa3f] has been reserved
system 00:07: [io  0xfc00-0xfc7f] has been reserved
system 00:07: [io  0xfc80-0xfcff] has been reserved
system 00:07: [io  0x0cb0-0x0cbf] has been reserved
system 00:07: [io  0xfe80-0xfeff] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:08: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:08: [mem 0x000d4000-0x000fffff] could not be reserved
system 00:08: [mem 0xfec01000-0xfecfffff] has been reserved
system 00:08: [mem 0xfed00400-0xfed3ffff] has been reserved
system 00:08: [mem 0xfed40000-0xffffffff] could not be reserved
system 00:08: [mem 0xf0000000-0xf3ffffff] has been reserved
system 00:08: [mem 0x000cd000-0x000e3fff] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 9 devices
pci 0000:00:1c.5: bridge window [io  0x1000-0x0fff] to [bus 3f] add_size 1000
pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 3f] add_size 200000
pci 0000:00:1f.0: BAR 7: [io  0xf800-0xf87f] has bogus alignment
pci 0000:00:1c.5: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
pci 0000:00:1c.5: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
pci 0000:00:1c.5: BAR 9: assigned [mem 0xf4000000-0xf41fffff 64bit pref]
pci 0000:00:1b.0: BAR 0: assigned [mem 0xf4200000-0xf4203fff 64bit]
pci 0000:00:1c.5: BAR 7: assigned [io  0x5000-0x5fff]
pci 0000:01:00.0: BAR 6: assigned [mem 0xe8b20000-0xe8b3ffff pref]
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:01.0:   bridge window [mem 0xe8b00000-0xe8dfffff]
pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe81fffff 64bit pref]
pci 0000:10:00.0: BAR 6: assigned [mem 0xe9400000-0xe941ffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 10]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xe9400000-0xe96fffff]
pci 0000:00:1c.0:   bridge window [mem 0xe8500000-0xe87fffff 64bit pref]
pci 0000:28:00.0: BAR 6: assigned [mem 0xe9120000-0xe913ffff pref]
pci 0000:00:1c.4: PCI bridge to [bus 28]
pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.4:   bridge window [mem 0xe9100000-0xe93fffff]
pci 0000:00:1c.4:   bridge window [mem 0xe8200000-0xe84fffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 3f]
pci 0000:00:1c.5:   bridge window [io  0x5000-0x5fff]
pci 0000:00:1c.5:   bridge window [mem 0xe8800000-0xe8afffff]
pci 0000:00:1c.5:   bridge window [mem 0xf4000000-0xf41fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 05]
pci_bus 0000:00: resource 4 [mem 0xf4000000-0xfebfffff]
pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 6 [io  0x1000-0x2fff]
pci_bus 0000:00: resource 7 [io  0x3000-0x6fff]
pci_bus 0000:00: resource 8 [io  0x7000-0xafff]
pci_bus 0000:00: resource 9 [io  0xb000-0xffff]
pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 11 [mem 0xc0000000-0xefffffff]
pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:01: resource 1 [mem 0xe8b00000-0xe8dfffff]
pci_bus 0000:01: resource 2 [mem 0xe0000000-0xe81fffff 64bit pref]
pci_bus 0000:10: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:10: resource 1 [mem 0xe9400000-0xe96fffff]
pci_bus 0000:10: resource 2 [mem 0xe8500000-0xe87fffff 64bit pref]
pci_bus 0000:28: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:28: resource 1 [mem 0xe9100000-0xe93fffff]
pci_bus 0000:28: resource 2 [mem 0xe8200000-0xe84fffff 64bit pref]
pci_bus 0000:3f: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:3f: resource 1 [mem 0xe8800000-0xe8afffff]
pci_bus 0000:3f: resource 2 [mem 0xf4000000-0xf41fffff 64bit pref]
pci_bus 0000:05: resource 4 [mem 0xf4000000-0xfebfffff]
pci_bus 0000:05: resource 5 [io  0x0000-0x0cf7]
pci_bus 0000:05: resource 6 [io  0x1000-0x2fff]
pci_bus 0000:05: resource 7 [io  0x3000-0x6fff]
pci_bus 0000:05: resource 8 [io  0x7000-0xafff]
pci_bus 0000:05: resource 9 [io  0xb000-0xffff]
pci_bus 0000:05: resource 10 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 11 [mem 0xc0000000-0xefffffff]
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 3, 32768 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:01:00.0: Video device with shadowed ROM
PCI: CLS 64 bytes, default 64
futex hash table entries: 512 (order: 3, 32768 bytes)
SGI XFS with security attributes, no debug enabled
msgmni has been set to 1716
bounce: pool size: 64 pages
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
pcieport 0000:00:1c.4: irq 26 for MSI/MSI-X
pcieport 0000:00:1c.5: irq 27 for MSI/MSI-X
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
scsi host0: ahci
scsi host1: ahci
scsi host2: ahci
scsi host3: ahci
ata1: SATA max UDMA/133 abar m1024@0xe9004400 port 0xe9004500 irq 28
ata2: SATA max UDMA/133 abar m1024@0xe9004400 port 0xe9004580 irq 28
ata3: SATA max UDMA/133 abar m1024@0xe9004400 port 0xe9004600 irq 28
ata4: SATA max UDMA/133 abar m1024@0xe9004400 port 0xe9004680 irq 28
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata1.00: supports DRM functions and may not be fully accessible
ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
ata1.00: ATA-9: SAMSUNG MZ7TD256HAFV-000L9, DXT02L5Q, max UDMA/133
ata1.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata4: SATA link down (SStatus 0 SControl 300)
ata1.00: supports DRM functions and may not be fully accessible
ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MZ7TD256 2L5Q PQ: 0 ANSI: 5
ata3: SATA link down (SStatus 0 SControl 300)
sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10>
sd 0:0:0:0: [sda] Attached SCSI disk
XFS (sda1): Mounting V4 Filesystem
XFS (sda1): Ending clean mount
VFS: Mounted root (xfs filesystem) readonly on device 8:1.
devtmpfs: mounted
Freeing unused kernel memory: 332K (c135a000 - c13ad000)
loop: module loaded
udevd[543]: starting version 182
rtc_cmos 00:00: RTC can wake from S4
rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:10:00.0: can't disable ASPM; OS doesn't have ASPM control
r8169 0000:10:00.0: irq 29 for MSI/MSI-X
r8169 0000:10:00.0 eth0: RTL8168c/8111c at 0xf8130000, 00:e0:4c:68:48:d2, XID 1c4000c0 IRQ 29
r8169 0000:10:00.0 eth0: jumbo features [frames: 6128 bytes, tx checksumming: ko]
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:28:00.0: can't disable ASPM; OS doesn't have ASPM control
r8169 0000:28:00.0: irq 30 for MSI/MSI-X
r8169 0000:28:00.0 eth1: RTL8168c/8111c at 0xf8132000, 00:e0:4c:68:48:2b, XID 1c4000c0 IRQ 30
r8169 0000:28:00.0 eth1: jumbo features [frames: 6128 bytes, tx checksumming: ko]
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
PTP clock support registered
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00004000
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 18, io base 0x00004020
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00004040
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 22, io base 0x00004060
hub 4-0:1.0: USB hub found
tg3.c:v3.137 (May 11, 2014)
hub 4-0:1.0: 2 ports detected
serial 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1d.7: EHCI Host Controller
ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci-pci 0000:00:1d.7: debug port 1
ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
ehci-pci 0000:00:1d.7: irq 20, io mem 0xe9004000
tg3 0000:3f:00.0 eth2: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:1a:4b:44:37:50
tg3 0000:3f:00.0 eth2: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
tg3 0000:3f:00.0 eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:3f:00.0 eth2: dma_rwctrl[76180000] dma_mask[64-bit]
ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Adding 9076688k swap on /dev/sda10.  Priority:-1 extents:1 across:9076688k SS
tsc: Refined TSC clocksource calibration: 2400.084 MHz
Switched to clocksource tsc
XFS (sda5): Mounting V4 Filesystem
XFS (sda5): Ending clean mount
XFS (sda6): Mounting V4 Filesystem
XFS (sda6): Ending clean mount
XFS (sda7): Mounting V4 Filesystem
XFS (sda7): Ending clean mount
XFS (sda8): Mounting V4 Filesystem
XFS (sda8): Ending clean mount
XFS (sda9): Mounting V4 Filesystem
XFS (sda9): Ending clean mount
random: dd urandom read with 85 bits of entropy available
r8169 0000:10:00.0 eth0: link down
r8169 0000:10:00.0 eth0: link down
r8169 0000:28:00.0 eth1: link down
r8169 0000:28:00.0 eth1: link down
tg3 0000:3f:00.0: irq 31 for MSI/MSI-X
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
tg3 0000:3f:00.0 eth2: Link is up at 100 Mbps, full duplex
tg3 0000:3f:00.0 eth2: Flow control is off for TX and off for RX
r8169 0000:28:00.0 eth1: link up
r8169 0000:10:00.0 eth0: link up
NET: Registered protocol family 15
capability: warning: `squid' uses 32-bit capabilities (legacy support in use)
nf_conntrack: automatic helper assignment is deprecated and it will be removed soon. Use the iptables CT target to attach helpers instead.
random: nonblocking pool is initialized



 		 	   		  