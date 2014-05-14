Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaENSUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:20:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50495 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaENSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:20:51 -0400
Date: Wed, 14 May 2014 20:20:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc: regression in suspend
Message-ID: <20140514182046.GA13342@amd.pavel.ucw.cz>
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
 <20140513163734.GA4602@amd.pavel.ucw.cz>
 <20140513214155.GA5087@amd.pavel.ucw.cz>
 <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz>
 <20140514155759.GB9723@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514155759.GB9723@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-05-14 17:57:59, Pavel Machek wrote:
> On Wed 2014-05-14 14:39:19, Jiri Kosina wrote:
> > On Tue, 13 May 2014, Pavel Machek wrote:
> > 
> > > > > There seems to be regression in 3.15 w.r.t. suspend to ram and suspend
> > > > > to disk.
> > > > > 
> > > > > Resume sometiems works, but often, system is half-usable, with "what
> > > > > do you want to do suspend/hibernate" dialog staying on screen.
> > > > > 
> > > > > I did echo disk > /sys/power/state, and echo never returned to the
> > > > > shell prompt. (X was not really working, either.)
> > > > > 
> > > > > It is still there on 3.15.0-rc3+. I'll update to rc5 now.
> > > > 
> > > > 3.15.0-rc5+ seems to behave a bit better. Lets see if it reappears.
> > > 
> > > It did. 
> > 
> > So it might in the end of the day the same thing as I have reported in 
> > 
> > 	https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > 
> > which is not 100% reproducible either (although with newer kernels it's 
> > *much* more reproducible for me than with older).
> > 
> > > It worked few times on -rc5, but then I rebooted and problem 
> > > re-appeared.
> > 
> > If you could capture dmesg of the resume where X fails to resume properly 
> > to see whether you have i915 ring initialization errors there as well?
> 
> I did dmesg and I believe I would have noticed "*ERROR*" there.. but
> I'll of course capture the buffer when it happens. 
> 
> Note that X do work somehow after resume (I can't switch virtual
> desktops and dialog is stuck on screen, but it is not complete
> failure). I can do ctrl-alt-f1 and get to useful prompt.

Oops. You were right. It seems it is duplicate after all.

[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 00001020 tail 00000000 start 00003000

Full dmesg is below.

Oops, I already bisected one i915 regression this release :-(.
		       	       	      	   		  	     	      	  Pavel

Initializing cgroup subsys cpu
Linux version 3.15.0-rc5+ (pavel@amd) (gcc version 4.4.5 (Debian 4.4.5-8) ) #355 SMP Tue May 13 18:19:09 CEST 2014
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000bd87dfff] usable
BIOS-e820: [mem 0x00000000bd87e000-0x00000000bd900fff] ACPI NVS
BIOS-e820: [mem 0x00000000bd901000-0x00000000bda42fff] reserved
BIOS-e820: [mem 0x00000000bda43000-0x00000000bda56fff] ACPI NVS
BIOS-e820: [mem 0x00000000bda57000-0x00000000bdb54fff] reserved
BIOS-e820: [mem 0x00000000bdb55000-0x00000000bdb5dfff] ACPI data
BIOS-e820: [mem 0x00000000bdb5e000-0x00000000bdb67fff] ACPI NVS
BIOS-e820: [mem 0x00000000bdb68000-0x00000000bdb88fff] reserved
BIOS-e820: [mem 0x00000000bdb89000-0x00000000bdb8efff] ACPI NVS
BIOS-e820: [mem 0x00000000bdb8f000-0x00000000bdcfffff] usable
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
SMBIOS 2.4 present.
DMI:                  /DG41MJ, BIOS MJG4110H.86A.0006.2009.1223.1155 12/23/2009
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
e820: last_pfn = 0xbdd00 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-E7FFF uncachable
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F00000000 write-back
  1 base 100000000 mask FC0000000 write-back
  2 base 0BDD00000 mask FFFF00000 write-through
  3 base 0BDE00000 mask FFFE00000 uncachable
  4 base 0BE000000 mask FFE000000 uncachable
  5 base 0C0000000 mask FC0000000 uncachable
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped: [mem 0x00000000-0x053fffff]
Base memory trampoline at [c009a000] 9a000 size 16384
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
init_memory_mapping: [mem 0x37000000-0x373fffff]
 [mem 0x37000000-0x373fffff] page 4k
BRK [0x0510c000, 0x0510cfff] PGTABLE
init_memory_mapping: [mem 0x30000000-0x36ffffff]
 [mem 0x30000000-0x36ffffff] page 4k
BRK [0x0510d000, 0x0510dfff] PGTABLE
BRK [0x0510e000, 0x0510efff] PGTABLE
BRK [0x0510f000, 0x0510ffff] PGTABLE
BRK [0x05110000, 0x05110fff] PGTABLE
BRK [0x05111000, 0x05111fff] PGTABLE
init_memory_mapping: [mem 0x00100000-0x2fffffff]
 [mem 0x00100000-0x2fffffff] page 4k
init_memory_mapping: [mem 0x37400000-0x377fdfff]
 [mem 0x37400000-0x377fdfff] page 4k
ACPI: RSDP 0x000F03C0 000024 (v02 INTEL )
ACPI: XSDT 0xBDB5CE18 000044 (v01 INTEL  DG41MJ   00000006 MSFT 00010013)
ACPI: FACP 0xBDB5BD98 0000F4 (v04 INTEL  DG41RQ   00000006 MSFT 00010013)
ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBDB5FF40/0x00000000BDB64F40, using 64-bit address (20140214/tbfadt-271)
ACPI: DSDT 0xBDB55018 005983 (v01 INTEL  DG41MJ   00000006 INTL 20051117)
ACPI: FACS 0xBDB64F40 000040
ACPI: APIC 0xBDB5BF18 00006C (v02 INTEL  DG41MJ   00000006 MSFT 00010013)
ACPI: MCFG 0xBDB66E18 00003C (v01 INTEL  DG41MJ   00000006 MSFT 00000097)
ACPI: HPET 0xBDB66D98 000038 (v01 INTEL  DG41MJ   00000006 AMI. 00000003)
ACPI: Local APIC address 0xfee00000
2149MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  Normal   [mem 0x01000000-0x377fdfff]
  HighMem  [mem 0x377fe000-0xbdcfffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009dfff]
  node   0: [mem 0x00100000-0xbd87dfff]
  node   0: [mem 0xbdb8f000-0xbdcfffff]
On node 0 totalpages: 776588
free_area_init_node: node 0, pgdat c4b58980, node_mem_map f5885024
  DMA zone: 36 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3997 pages, LIFO batch:0
  Normal zone: 1962 pages used for memmap
  Normal zone: 223230 pages, LIFO batch:31
  HighMem zone: 4836 pages used for memmap
  HighMem zone: 549361 pages, LIFO batch:31
Using APIC driver default
Reserving Intel graphics stolen memory at 0xbe000000-0xbfffffff
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] disabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
e820: [mem 0xc0000000-0xfebfffff] available for PCI devices
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 13 pages/cpu @f7794000 s29312 r0 d23936 u53248
pcpu-alloc: s29312 r0 d23936 u53248 alloc=13*4096
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 774590
Kernel command line: BOOT_IMAGE=(hd0,2)/l/linux-good/arch/x86/boot/bzImage root=/dev/sda3 resume=/dev/sda1
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
xsave: enabled xstate_bv 0x3, cntxt size 0x240
Initializing HighMem for node 0 (000377fe:000bdd00)
Initializing Movable for node 0 (00000000:00000000)
Memory: 3059448K/3106352K available (8175K kernel code, 533K rwdata, 3012K rodata, 492K init, 5108K bss, 46904K reserved, 2197444K highmem)
virtual kernel memory layout:
    fixmap  : 0xffe6f000 - 0xfffff000   (1600 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc4b76000 - 0xc4bf1000   ( 492 kB)
      .data : 0xc47fc1cf - 0xc4b746c0   (3553 kB)
      .text : 0xc4000000 - 0xc47fc1cf   (8176 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
NR_IRQS:2304 nr_irqs:712 16
CPU 0 irqstacks, hard=f541a000 soft=f541c000
spurious 8259A interrupt: IRQ7.
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
 memory used by lock dependency info: 3551 kB
 per task-struct memory footprint: 1152 bytes
ODEBUG: 11 of 11 active objects replaced
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2800.142 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.28 BogoMIPS (lpj=11200568)
pid_max: default: 32768 minimum: 301
ACPI: Core revision 20140214
ACPI: All ACPI Tables successfully acquired
Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
tlb_flushall_shift: -1
debug: unmapping init [mem 0xc4bf1000-0xc4bf8fff]
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz (fam: 06, model: 17, stepping: 0a)
Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
CPU 1 irqstacks, hard=f55b8000 soft=f55ba000
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
Initializing CPU#1
x86: Booted up 1 node, 2 CPUs
smpboot: Total of 2 processors activated (11200.56 BogoMIPS)
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xbd87e000-0xbd900fff] (536576 bytes)
PM: Registering ACPI NVS region [mem 0xbda43000-0xbda56fff] (81920 bytes)
PM: Registering ACPI NVS region [mem 0xbdb5e000-0xbdb67fff] (40960 bytes)
PM: Registering ACPI NVS region [mem 0xbdb89000-0xbdb8efff] (24576 bytes)
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 0xBDB5FC18 0002CC (v01 AMI    IST      00000001 MSFT 03000001)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT 0x00000000 0002CC (v01 AMI    IST      00000001 MSFT 03000001)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: \_PR_.CPU3: failed to get CPU APIC ID.
ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
ACPI: \_PR_.CPU8: failed to get CPU APIC ID.
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments]
acpi PNP0A08:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
pci 0000:00:00.0: [8086:2e30] type 00 class 0x060000
pci 0000:00:01.0: [8086:2e31] type 01 class 0x060400
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: System wakeup disabled by ACPI
pci 0000:00:02.0: [8086:2e32] type 00 class 0x030000
pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff 64bit]
pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:02.0: reg 0x20: [io  0xf140-0xf147]
pci 0000:00:02.1: [8086:2e33] type 00 class 0x038000
pci 0000:00:02.1: reg 0x10: [mem 0xd0400000-0xd04fffff 64bit]
pci 0000:00:1b.0: [8086:27d8] type 00 class 0x040300
pci 0000:00:1b.0: reg 0x10: [mem 0xd0600000-0xd0603fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:27d0] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: System wakeup disabled by ACPI
pci 0000:00:1c.1: [8086:27d2] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: System wakeup disabled by ACPI
pci 0000:00:1d.0: [8086:27c8] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 0x20: [io  0xf080-0xf09f]
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:1d.1: [8086:27c9] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 0x20: [io  0xf060-0xf07f]
pci 0000:00:1d.1: System wakeup disabled by ACPI
pci 0000:00:1d.2: [8086:27ca] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 0x20: [io  0xf040-0xf05f]
pci 0000:00:1d.2: System wakeup disabled by ACPI
pci 0000:00:1d.3: [8086:27cb] type 00 class 0x0c0300
pci 0000:00:1d.3: reg 0x20: [io  0xf020-0xf03f]
pci 0000:00:1d.3: System wakeup disabled by ACPI
pci 0000:00:1d.7: [8086:27cc] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 0x10: [mem 0xd0604000-0xd06043ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: System wakeup disabled by ACPI
pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
pci 0000:00:1e.0: System wakeup disabled by ACPI
pci 0000:00:1f.0: [8086:27b8] type 00 class 0x060100
pci 0000:00:1f.0: can't claim BAR 7 [io  0x0800-0x087f]: address conflict with ACPI CPU throttle [io  0x0810-0x0815]
pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
pci 0000:00:1f.1: [8086:27df] type 00 class 0x01018a
pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 0x14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 0x18: [io  0x08f0-0x08f7]
pci 0000:00:1f.1: reg 0x1c: [io  0x08f8-0x08fb]
pci 0000:00:1f.1: reg 0x20: [io  0xf0f0-0xf0ff]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
pci 0000:00:1f.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
pci 0000:00:1f.2: [8086:27c0] type 00 class 0x01018f
pci 0000:00:1f.2: reg 0x10: [io  0xf0e0-0xf0e7]
pci 0000:00:1f.2: reg 0x14: [io  0xf0d0-0xf0d3]
pci 0000:00:1f.2: reg 0x18: [io  0xf0c0-0xf0c7]
pci 0000:00:1f.2: reg 0x1c: [io  0xf0b0-0xf0b3]
pci 0000:00:1f.2: reg 0x20: [io  0xf0a0-0xf0af]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:27da] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 0x20: [io  0x0400-0x041f]
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
pci 0000:03:00.0: reg 0x10: [io  0xe000-0xe0ff]
pci 0000:03:00.0: reg 0x18: [mem 0xd0514000-0xd0514fff 64bit pref]
pci 0000:03:00.0: reg 0x20: [mem 0xd0510000-0xd0513fff 64bit pref]
pci 0000:03:00.0: reg 0x30: [mem 0xd0500000-0xd050ffff pref]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05fffff]
pci 0000:00:1e.0: PCI bridge to [bus 04] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: Enabled 2 GPEs in block 00 to 1F
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
e820: reserve RAM buffer [mem 0xbd87e000-0xbfffffff]
e820: reserve RAM buffer [mem 0xbdd00000-0xbfffffff]
Bluetooth: Core ver 2.19
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
------------[ cut here ]------------
WARNING: CPU: 1 PID: 1 at net/wireless/reg.c:479 regulatory_init+0x88/0xf5()
db.txt is empty, you should update it...
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc5+ #355
Hardware name:                  /DG41MJ, BIOS MJG4110H.86A.0006.2009.1223.1155 12/23/2009
 000001df f5517e44 c47f5aaf c4a9ff8c f5517e74 c403875a c4aa9e34 f5517ea0
 00000001 c4a9ff8c 000001df c4bac935 c4bac935 00000000 c4bac7d6 f5517ec8
 f5517e8c c40387fe 00000009 f5517e84 c4aa9e34 f5517ea0 f5517ecc c4bac935
Call Trace:
 [<c47f5aaf>] dump_stack+0x41/0x52
 [<c403875a>] warn_slowpath_common+0x7a/0xa0
 [<c4bac935>] ? regulatory_init+0x88/0xf5
 [<c4bac935>] ? regulatory_init+0x88/0xf5
 [<c4bac7d6>] ? cache_initialize+0x86/0x86
 [<c40387fe>] warn_slowpath_fmt+0x2e/0x30
 [<c4bac935>] regulatory_init+0x88/0xf5
 [<c4bac835>] cfg80211_init+0x5f/0xd7
 [<c4babe77>] ? bt_init+0x6e/0x98
 [<c40003fa>] do_one_initcall+0xca/0x180
 [<c406e4ab>] ? __wake_up+0x1b/0x50
 [<c4b76663>] ? repair_env_string+0x15/0x5b
 [<c4051e61>] ? parse_args+0x1f1/0x440
 [<c4b765a9>] kernel_init_freeable+0xec/0x191
 [<c4b7664e>] ? kernel_init_freeable+0x191/0x191
 [<c47f228b>] kernel_init+0xb/0xe0
 [<c47facc1>] ret_from_kernel_thread+0x21/0x30
 [<c47f2280>] ? rest_init+0xb0/0xb0
---[ end trace 61e8190fed118a63 ]---
cfg80211: Calling CRDA to update world regulatory domain
Switched to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type PNP registered
system 00:00: [mem 0xfed14000-0xfed19fff] has been reserved
system 00:00: [mem 0xe0000000-0xefffffff] has been reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
system 00:01: [io  0x0800-0x087f] could not be reserved
system 00:01: [io  0x0480-0x04bf] has been reserved
system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
system 00:01: [mem 0xff000000-0xffffffff] could not be reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [dma 0 disabled]
pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:04: [dma 3]
pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:05: [dma 4]
pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 11 devices
ACPI: bus type PNP unregistered
pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
pci 0000:00:1c.0: BAR 8: assigned [mem 0xd0700000-0xd08fffff]
pci 0000:00:1c.0: BAR 9: assigned [mem 0xd0900000-0xd0afffff 64bit pref]
pci 0000:00:1c.1: BAR 9: assigned [mem 0xd0b00000-0xd0cfffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0xd0700000-0xd08fffff]
pci 0000:00:1c.0:   bridge window [mem 0xd0900000-0xd0afffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
pci 0000:00:1c.1:   bridge window [mem 0xd0500000-0xd05fffff]
pci 0000:00:1c.1:   bridge window [mem 0xd0b00000-0xd0cfffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 04]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:02: resource 1 [mem 0xd0700000-0xd08fffff]
pci_bus 0000:02: resource 2 [mem 0xd0900000-0xd0afffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
pci_bus 0000:03: resource 1 [mem 0xd0500000-0xd05fffff]
pci_bus 0000:03: resource 2 [mem 0xd0b00000-0xd0cfffff 64bit pref]
pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:04: resource 7 [mem 0xc0000000-0xffffffff]
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 3, 32768 bytes)
TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 3, 40960 bytes)
UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
futex hash table entries: 1024 (order: 4, 65536 bytes)
bounce pool size: 64 pages
ntfs: driver 2.1.30 [Flags: R/W].
fuse init (API version 7.23)
msgmni has been set to 1683
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
usbcore: registered new interface driver udlfb
intel_idle: does not run on family 6 model 23
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
GHES: HEST is not enabled!
ERST DBG: ERST support is disabled.
Error: Driver 'battery' is already registered, aborting...
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
lp: driver loaded but no devices found
Non-volatile memory driver v1.3
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel G41 Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 32768K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[drm] Initialized drm 1.1.0 20060810
[drm] Memory usable by graphics device = 2048M
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 192x60
i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
i915 0000:00:02.0: registered panic notifier
ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20140214/video-1251)
ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
parport_pc 00:04: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 5 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
loop: module loaded
nbd: registered device at major 43
ata_piix 0000:00:1f.1: version 2.13
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf0f0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf0f8 irq 15
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata2: port disabled--ignoring
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xf0e0 ctl 0xf0d0 bmdma 0xf0a0 irq 19
ata4: SATA max UDMA/133 cmd 0xf0c0 ctl 0xf0b0 bmdma 0xf0a8 irq 19
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:03:00.0 eth0: RTL8168d/8111d at 0xf8024000, 00:27:0e:2a:43:71, XID 081000c0 IRQ 17
r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:ds
iwl3945: Copyright(c) 2003-2011 Intel Corporation
usbcore: registered new interface driver ax88179_178a
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
usbcore: registered new interface driver cdc_ncm
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1d.7: EHCI Host Controller
ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1d.7: debug port 1
ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
ehci-pci 0000:00:1d.7: irq 23, io mem 0xd0604000
ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.15.0-rc5+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.15.0-rc5+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.15.0-rc5+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.15.0-rc5+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000f020
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
ata3.01: NODEV after polling detection
usb usb5: Manufacturer: Linux 3.15.0-rc5+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ata3.00: ATAPI: HL-DT-ST DVDRAM GT20N, CQ02, max UDMA/133
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver usb-storage
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver usbserial
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver ftdi_sio
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver option
usbserial: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver pl2303
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver ti_usb_3410_5052
usbserial: USB Serial support registered for TI USB 3410 1 port adapter
usbserial: USB Serial support registered for TI USB 5052 2 port adapter
driver ftdi-elan
usbcore: registered new interface driver ftdi-elan
i8042: PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input4
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
ata3.00: configured for UDMA/133
rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT20N     CQ02 PQ: 0 ANSI: 5
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
usbcore: registered new interface driver btusb
lguest: mapped switcher at ffe65000
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
usbcore: registered new interface driver snd-usb-audio
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg0 type 5
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP: cubic registered
NET: Registered protocol family 17
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
Using IPI No-Shortcut mode
ata4.00: ATA-9: ST1000LM014-1EJ164, SM11, max UDMA/133
rtc_cmos 00:06: setting system clock to 2014-05-13 19:46:01 UTC (1400010361)
ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
PM: Checking hibernation image partition /dev/sda1
sound hdaudioC0D2: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
sound hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
sound hdaudioC0D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
sound hdaudioC0D2:    mono: mono_out=0x0
sound hdaudioC0D2:    inputs:
sound hdaudioC0D2:      Front Mic=0x19
sound hdaudioC0D2:      Rear Mic=0x18
sound hdaudioC0D2:      Line=0x1a
input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
input: HDA Intel Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
usb 1-4: new high-speed USB device number 2 using ehci-pci
ata4.00: configured for UDMA/133
scsi 3:0:0:0: Direct-Access     ATA      ST1000LM014-1EJ1 SM11 PQ: 0 ANSI: 5
sd 3:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 3:0:0:0: Attached scsi generic sg1 type 0
sd 3:0:0:0: [sda] 4096-byte physical blocks
sd 3:0:0:0: [sda] Write Protect is off
sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 3:0:0:0: [sda] Attached SCSI disk
PM: Hibernation image partition 8:1 present
PM: Looking for hibernation image.
PM: Image not found (code -22)
PM: Hibernation image not present or could not be loaded.
ALSA device list:
  #0: HDA Intel at 0xd0600000 irq 16
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda3): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
devtmpfs: mounted
debug: unmapping init [mem 0xc4b76000-0xc4bf0fff]
Write protecting the kernel text: 8180k
Write protecting the kernel read-only data: 3016k
usb 1-4: New USB device found, idVendor=058f, idProduct=6362
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: Mass Storage Device
usb 1-4: Manufacturer: Generic
usb 1-4: SerialNumber: 058F312D81B
usb-storage 1-4:1.0: USB Mass Storage device detected
scsi4 : usb-storage 1-4:1.0
tsc: Refined TSC clocksource calibration: 2799.956 MHz
udev[1661]: starting version 164
usb 5-1: new low-speed USB device number 2 using uhci_hcd
usb 5-1: New USB device found, idVendor=046d, idProduct=c050
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: USB-PS/2 Optical Mouse
usb 5-1: Manufacturer: Logitech
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/0003:046D:C050.0001/input/input10
hid-generic 0003:046D:C050.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.3-1/input0
usb 5-2: new low-speed USB device number 3 using uhci_hcd
scsi 4:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
scsi 4:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
sd 4:0:0:0: [sdb] Attached SCSI removable disk
sd 4:0:0:1: Attached scsi generic sg3 type 0
scsi 4:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
sd 4:0:0:1: [sdc] Attached SCSI removable disk
sd 4:0:0:2: Attached scsi generic sg4 type 0
scsi 4:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
sd 4:0:0:2: [sdd] Attached SCSI removable disk
Adding 2097148k swap on /dev/sda1.  Priority:-1 extents:1 across:2097148k 
sd 4:0:0:3: Attached scsi generic sg5 type 0
sd 4:0:0:3: [sde] Attached SCSI removable disk
Switched to clocksource tsc
EXT3-fs (sda3): using internal journal
usb 5-2: New USB device found, idVendor=04f2, idProduct=0111
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: USB Keyboard
usb 5-2: Manufacturer: Chicony
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2:1.0/0003:04F2:0111.0002/input/input11
hid-generic 0003:04F2:0111.0002: input,hidraw1: USB HID v1.10 Keyboard [Chicony USB Keyboard] on usb-0000:00:1d.3-2/input0
input: Chicony USB Keyboard as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2:1.1/0003:04F2:0111.0003/input/input12
hid-generic 0003:04F2:0111.0003: input,hiddev0,hidraw2: USB HID v1.10 Device [Chicony USB Keyboard] on usb-0000:00:1d.3-2/input1
EXT4-fs (sda2): warning: maximal mount count reached, running e2fsck is recommended
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: errors=remount-ro
EXT3-fs (sda4): error: can't find ext3 filesystem on dev sda4.
random: nonblocking pool is initialized
input: ACPI Virtual Keyboard Device as /devices/virtual/input/input13
r8169 0000:03:00.0: Direct firmware load failed with error -2
r8169 0000:03:00.0: Falling back to user helper
r8169 0000:03:00.0 eth1: unable to load firmware patch rtl_nic/rtl8168d-1.fw (-12)
r8169 0000:03:00.0 eth1: link down
r8169 0000:03:00.0 eth1: link down
sshd (3175): /proc/3175/oom_adj is deprecated, please use /proc/3175/oom_score_adj instead.
r8169 0000:03:00.0 eth1: link up
perf interrupt took too long (2509 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
perf interrupt took too long (5008 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.006 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.007 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 3:0:0:0: [sda] Synchronizing SCSI cache
parport_pc 00:04: disabled
sd 3:0:0:0: [sda] Stopping disk
serial 00:03: disabled
serial 00:03: System wakeup disabled by ACPI
PM: suspend of devices complete after 334.723 msecs
PM: suspend devices took 0.336 seconds
PM: late suspend of devices complete after 16.001 msecs
pcieport 0000:00:1c.1: System wakeup enabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.3: System wakeup enabled by ACPI
PM: noirq suspend of devices complete after 16.089 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
Initializing CPU#1
TSC synchronization [CPU#0 -> CPU#1]:
Measured 2298956531 cycles TSC warp between CPUs, turning off TSC clock.
tsc: Marking TSC unstable due to check_tsc_sync_source failed
CPU1 is up
ACPI: Waking up from system sleep state S3
ACPI: \_SB_.PWRB: ACPI_NOTIFY_DEVICE_WAKE event
ACPI: \_SB_.PCI0.USB0: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB1: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB2: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB3: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.EUSB: ACPI_NOTIFY_BUS_CHECK event
Switched to clocksource hpet
uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.3: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
PM: noirq resume of devices complete after 1270502.801 msecs
PM: early resume of devices complete after 1.691 msecs
usb usb2: root hub lost power or was reset
usb usb3: root hub lost power or was reset
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
serial 00:03: activated
parport_pc 00:04: activated
pcieport 0000:00:1c.1: System wakeup disabled by ACPI
ata2: port disabled--ignoring
sd 3:0:0:0: [sda] Starting disk
ata3.01: NODEV after polling detection
ata3.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
ata4.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata4.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
ata3.00: configured for UDMA/133
ata4.00: configured for UDMA/133
usb 5-2: reset low-speed USB device number 3 using uhci_hcd
usb 5-1: reset low-speed USB device number 2 using uhci_hcd
PM: resume of devices complete after 2922.312 msecs
PM: resume devices took 2.924 seconds
ACPI: \_SB_.PCI0.USB0: Bus check in hotplug_event()
PM: Finishing wakeup.
Restarting tasks ... 
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB1: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB2: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB3: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.EUSB: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
done.
video LNXVIDEO:00: Restoring backlight state
r8169 0000:03:00.0 eth1: link down
r8169 0000:03:00.0 eth1: link down
r8169 0000:03:00.0 eth1: link up
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.010 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.011 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 3:0:0:0: [sda] Synchronizing SCSI cache
sd 3:0:0:0: [sda] Stopping disk
parport_pc 00:04: disabled
serial 00:03: disabled
serial 00:03: System wakeup disabled by ACPI
PM: suspend of devices complete after 322.768 msecs
PM: suspend devices took 0.324 seconds
PM: late suspend of devices complete after 15.985 msecs
pcieport 0000:00:1c.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.3: System wakeup enabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
PM: noirq suspend of devices complete after 16.100 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
Initializing CPU#1
CPU1 is up
ACPI: Waking up from system sleep state S3
ACPI: \_SB_.PWRB: ACPI_NOTIFY_DEVICE_WAKE event
ACPI: \_SB_.PCI0.USB0: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB1: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB2: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB3: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.EUSB: ACPI_NOTIFY_BUS_CHECK event
uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.3: System wakeup disabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
PM: noirq resume of devices complete after 13.758 msecs
PM: early resume of devices complete after 1.325 msecs
usb usb2: root hub lost power or was reset
usb usb3: root hub lost power or was reset
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
serial 00:03: activated
parport_pc 00:04: activated
pcieport 0000:00:1c.1: System wakeup disabled by ACPI
ata2: port disabled--ignoring
sd 3:0:0:0: [sda] Starting disk
ata3.01: NODEV after polling detection
ata3.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
ata4.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata4.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
ata3.00: configured for UDMA/133
ata4.00: configured for UDMA/133
usb 5-2: reset low-speed USB device number 3 using uhci_hcd
usb 5-1: reset low-speed USB device number 2 using uhci_hcd
PM: resume of devices complete after 3046.488 msecs
PM: resume devices took 3.048 seconds
ACPI: \_SB_.PCI0.USB0: Bus check in hotplug_event()
PM: Finishing wakeup.
Restarting tasks ... 
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB1: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB2: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB3: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.EUSB: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
done.
video LNXVIDEO:00: Restoring backlight state
r8169 0000:03:00.0 eth1: link down
r8169 0000:03:00.0 eth1: link down
r8169 0000:03:00.0 eth1: link up
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.011 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.003 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 3:0:0:0: [sda] Synchronizing SCSI cache
parport_pc 00:04: disabled
serial 00:03: disabled
serial 00:03: System wakeup disabled by ACPI
sd 3:0:0:0: [sda] Stopping disk
PM: suspend of devices complete after 350.696 msecs
PM: suspend devices took 0.352 seconds
PM: late suspend of devices complete after 15.995 msecs
pcieport 0000:00:1c.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.3: System wakeup enabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
PM: noirq suspend of devices complete after 16.097 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
Initializing CPU#1
CPU1 is up
ACPI: Waking up from system sleep state S3
ACPI: \_SB_.PWRB: ACPI_NOTIFY_DEVICE_WAKE event
ACPI: \_SB_.PCI0.USB0: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB1: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB2: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.USB3: ACPI_NOTIFY_BUS_CHECK event
ACPI: \_SB_.PCI0.EUSB: ACPI_NOTIFY_BUS_CHECK event
uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.3: System wakeup disabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
PM: noirq resume of devices complete after 16.838 msecs
PM: early resume of devices complete after 1.327 msecs
usb usb2: root hub lost power or was reset
usb usb3: root hub lost power or was reset
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
pcieport 0000:00:1c.1: System wakeup disabled by ACPI
serial 00:03: activated
parport_pc 00:04: activated
ata2: port disabled--ignoring
sd 3:0:0:0: [sda] Starting disk
[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head 00001020 tail 00000000 start 00003000
ata3.01: NODEV after polling detection
ata3.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
ata4.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata4.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
dpm_run_callback(): pci_pm_resume+0x0/0x90 returns -5
PM: Device 0000:00:02.0 failed to resume async: error -5
ata3.00: configured for UDMA/133
ata4.00: configured for UDMA/133
usb 5-1: reset low-speed USB device number 2 using uhci_hcd
usb 5-2: reset low-speed USB device number 3 using uhci_hcd
PM: resume of devices complete after 2964.956 msecs
PM: resume devices took 2.964 seconds
ACPI: \_SB_.PCI0.USB0: Bus check in hotplug_event()
PM: Finishing wakeup.
Restarting tasks ... 
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB1: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB2: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.USB3: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
ACPI: \_SB_.PCI0.EUSB: Bus check in hotplug_event()
i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
pci 0000:00:1f.0: BAR 7: [io  0x0800-0x087f] has bogus alignment
pci 0000:00:1e.0: PCI bridge to [bus 04]
agpgart-intel 0000:00:00.0: no hotplug settings from platform
agpgart-intel 0000:00:00.0: using default PCI settings
pcieport 0000:00:01.0: no hotplug settings from platform
i915 0000:00:02.0: no hotplug settings from platform
i915 0000:00:02.0: using default PCI settings
pci 0000:00:02.1: no hotplug settings from platform
pci 0000:00:02.1: using default PCI settings
snd_hda_intel 0000:00:1b.0: no hotplug settings from platform
pcieport 0000:00:1c.0: no hotplug settings from platform
pcieport 0000:00:1c.1: no hotplug settings from platform
r8169 0000:03:00.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: no hotplug settings from platform
uhci_hcd 0000:00:1d.0: using default PCI settings
uhci_hcd 0000:00:1d.1: no hotplug settings from platform
uhci_hcd 0000:00:1d.1: using default PCI settings
uhci_hcd 0000:00:1d.2: no hotplug settings from platform
uhci_hcd 0000:00:1d.2: using default PCI settings
uhci_hcd 0000:00:1d.3: no hotplug settings from platform
uhci_hcd 0000:00:1d.3: using default PCI settings
ehci-pci 0000:00:1d.7: no hotplug settings from platform
ehci-pci 0000:00:1d.7: using default PCI settings
pci 0000:00:1e.0: no hotplug settings from platform
pci 0000:00:1e.0: using default PCI settings
pci 0000:00:1f.0: no hotplug settings from platform
pci 0000:00:1f.0: using default PCI settings
ata_piix 0000:00:1f.1: no hotplug settings from platform
ata_piix 0000:00:1f.1: using default PCI settings
ata_piix 0000:00:1f.2: no hotplug settings from platform
ata_piix 0000:00:1f.2: using default PCI settings
pci 0000:00:1f.3: no hotplug settings from platform
pci 0000:00:1f.3: using default PCI settings
done.
video LNXVIDEO:00: Restoring backlight state
r8169 0000:03:00.0 eth1: link down
r8169 0000:03:00.0 eth1: link down
r8169 0000:03:00.0 eth1: link up


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
