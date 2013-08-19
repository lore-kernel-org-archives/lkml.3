Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab3HSJXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:23:50 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:42024 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab3HSJXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:23:44 -0400
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2013 05:23:43 EDT
Date: Mon, 19 Aug 2013 11:58:50 +0300 (EEST)
From: Meelis Roos <mroos@ut.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: 3.11-rc3: radeon WARNING at kernel/workqueue.c:1378
 __queue_work+0x132/0x16d()
In-Reply-To: <alpine.SOC.1.00.1307310017380.19288@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1308191158220.19642@math.ut.ee>
References: <alpine.SOC.1.00.1307310017380.19288@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just got this WARNING while loading radeon driver on a test PC that was 
> running 3.10 fine (full dmesg below). The machine is a Intel 850 chipst 
> PC with AGP Radeon 7000 and no monitor attached. lspci and config are 
> also below.

Still there with 3.11-rc6 and fully reproducible.

> Linux version 3.11.0-rc3 (mroos@d850) (gcc version 4.8.1 (Debian 4.8.1-3) ) #48 Mon Jul 29 12:54:00 EEST 2013
> e820: BIOS-provided physical RAM map:
> BIOS-e820: [mem 0x0000000000000000-0x000000000009bbff] usable
> BIOS-e820: [mem 0x000000000009bc00-0x000000000009bfff] reserved
> BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> BIOS-e820: [mem 0x0000000000100000-0x000000003ffbffff] usable
> BIOS-e820: [mem 0x000000003ffc0000-0x000000003fff7fff] ACPI data
> BIOS-e820: [mem 0x000000003fff8000-0x000000003fffffff] ACPI NVS
> BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> BIOS-e820: [mem 0x00000000ffb80000-0x00000000ffbfffff] reserved
> BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
> Notice: NX (Execute Disable) protection missing in CPU!
> Legacy DMI 2.3 present.
> DMI: MicroLink                               /D850MV                         , BIOS MV85010A.86A.0067.P24.0304081124 04/08/2003
> e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> e820: remove [mem 0x000a0000-0x000fffff] usable
> e820: last_pfn = 0x3ffc0 max_arch_pfn = 0x100000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-CFFFF write-protect
>   D0000-DFFFF uncachable
>   E0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 000000000 mask FC0000000 write-back
>   1 disabled
>   2 disabled
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> Warning only 895MB will be used.
> Use a HIGHMEM enabled kernel.
> found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [c00ff780]
> initial memory mapped: [mem 0x00000000-0x017fffff]
> Base memory trampoline at [c0097000] 97000 size 16384
> init_memory_mapping: [mem 0x00000000-0x000fffff]
>  [mem 0x00000000-0x000fffff] page 4k
> init_memory_mapping: [mem 0x37800000-0x37bfffff]
>  [mem 0x37800000-0x37bfffff] page 2M
> init_memory_mapping: [mem 0x30000000-0x377fffff]
>  [mem 0x30000000-0x377fffff] page 2M
> init_memory_mapping: [mem 0x00100000-0x2fffffff]
>  [mem 0x00100000-0x003fffff] page 4k
>  [mem 0x00400000-0x2fffffff] page 2M
> init_memory_mapping: [mem 0x37c00000-0x37f9ffff]
>  [mem 0x37c00000-0x37f9ffff] page 4k
> BRK [0x013f2000, 0x013f2fff] PGTABLE
> ACPI: RSDP 000ff980 00014 (v00 AMI   )
> ACPI: RSDT 3fff0000 0002C (v01 D850MV MV85010A 20030408 MSFT 00001011)
> ACPI: FACP 3fff1000 00074 (v01 D850MV MV85010A 20030408 MSFT 00001011)
> ACPI: DSDT 3ffe0000 03954 (v01 D850MV MV85010A 00000010 MSFT 0100000B)
> ACPI: FACS 3fff8000 00040
> ACPI: APIC 3ffe3954 00068 (v01 D850MV MV85010A 20030408 MSFT 00001011)
> ACPI: Local APIC address 0xfee00000
> 895MB LOWMEM available.
>   mapped low ram: 0 - 37fa0000
>   low ram: 0 - 37fa0000
> Zone ranges:
>   DMA      [mem 0x00001000-0x00ffffff]
>   Normal   [mem 0x01000000-0x37f9ffff]
> Movable zone start for each node
> Early memory node ranges
>   node   0: [mem 0x00001000-0x0009afff]
>   node   0: [mem 0x00100000-0x3ffbffff]
> On node 0 totalpages: 229178
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3994 pages, LIFO batch:0
>   Normal zone: 1760 pages used for memmap
>   Normal zone: 225184 pages, LIFO batch:31
> Using APIC driver default
> ACPI: PM-Timer IO Port: 0x408
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
> ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Using ACPI (MADT) for SMP configuration information
> nr_irqs_gsi: 40
> PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
> PM: Registered nosave memory: [mem 0x0009c000-0x000dffff]
> PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> e820: [mem 0x40000000-0xfebfffff] available for PCI devices
> pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> pcpu-alloc: [0] 0 
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227386
> Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0-rc3 root=/dev/sda1 ro
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Initializing CPU#0
> Memory: 903552K/916712K available (2259K kernel code, 249K rwdata, 936K rodata, 296K init, 260K bss, 13160K reserved)
> virtual kernel memory layout:
>     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
>     vmalloc : 0xf87a0000 - 0xfffa0000   ( 120 MB)
>     lowmem  : 0xc0000000 - 0xf7fa0000   ( 895 MB)
>       .init : 0xc1360000 - 0xc13aa000   ( 296 kB)
>       .data : 0xc123516a - 0xc135f580   (1193 kB)
>       .text : 0xc1000000 - 0xc123516a   (2260 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> NR_IRQS:2304 nr_irqs:256 16
> CPU 0 irqstacks, hard=f7008000 soft=f700a000
> Console: colour VGA+ 80x25
> console [tty0] enabled
> tsc: Fast TSC calibration failed
> tsc: PIT calibration matches PMTIMER. 1 loops
> tsc: Detected 1993.873 MHz processor
> Calibrating delay loop (skipped), value calculated using timer frequency.. 3987.74 BogoMIPS (lpj=7975492)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> mce: CPU supports 4 MCE banks
> CPU0: Thermal monitoring enabled (TM1)
> Last level iTLB entries: 4KB 64, 2MB 64, 4MB 64
> Last level dTLB entries: 4KB 64, 2MB 0, 4MB 64
> tlb_flushall_shift: 6
> CPU: Intel(R) Pentium(R) 4 CPU 2.00GHz (fam: 0f, model: 02, stepping: 04)
> ACPI: Core revision 20130517
> ACPI: All ACPI Tables successfully acquired
> Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
> ... version:                0
> ... bit width:              40
> ... generic registers:      18
> ... value mask:             000000ffffffffff
> ... max period:             0000007fffffffff
> ... fixed-purpose events:   0
> ... event mask:             000000000003ffff
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> PM: Registering ACPI NVS region [mem 0x3fff8000-0x3fffffff] (32768 bytes)
> NET: Registered protocol family 16
> ACPI: bus type PCI registered
> PCI: PCI BIOS revision 2.10 entry at 0xfda95, last bus=2
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: Added _OSI(Module Device)
> ACPI: Added _OSI(Processor Device)
> ACPI: Added _OSI(3.0 _SCP Extensions)
> ACPI: Added _OSI(Processor Aggregator Device)
> ACPI: EC: Look up EC in DSDT
> ACPI: Executed 1 blocks of module-level executable AML code
> ACPI: Interpreter enabled
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20130517/hwxface-571)
> ACPI: (supports S0 S1 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> ACPI: No dock devices found.
> ACPI: Power Resource [FDDP] (off)
> ACPI: Power Resource [URP1] (off)
> ACPI: Power Resource [URP2] (off)
> ACPI: Power Resource [LPTP] (off)
> ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> acpi PNP0A03:00: host bridge window [mem 0x40000000-0xffafffff] (ignored)
> PCI: root bus 00: using default resources
> acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [bus 00-ff]
> pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> pci 0000:00:00.0: [8086:2530] type 00 class 0x060000
> pci 0000:00:00.0: reg 0x10: [mem 0xe0000000-0xefffffff pref]
> pci 0000:00:01.0: [8086:2532] type 01 class 0x060400
> pci 0000:00:1e.0: [8086:244e] type 01 class 0x060400
> pci 0000:00:1e.0: System wakeup disabled by ACPI
> pci 0000:00:1f.0: [8086:2440] type 00 class 0x060100
> pci 0000:00:1f.0: address space collision: [io  0x0400-0x047f] conflicts with ACPI CPU throttle [??? 0x00000410-0x00000415 flags 0x80000000]
> pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH4 GPIO
> pci 0000:00:1f.1: [8086:244b] type 00 class 0x010180
> pci 0000:00:1f.1: reg 0x20: [io  0xffa0-0xffaf]
> pci 0000:00:1f.2: [8086:2442] type 00 class 0x0c0300
> pci 0000:00:1f.2: reg 0x20: [io  0xef40-0xef5f]
> pci 0000:00:1f.2: System wakeup disabled by ACPI
> pci 0000:00:1f.3: [8086:2443] type 00 class 0x0c0500
> pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefaf]
> pci 0000:00:1f.3: System wakeup disabled by ACPI
> pci 0000:00:1f.4: [8086:2444] type 00 class 0x0c0300
> pci 0000:00:1f.4: reg 0x20: [io  0xef80-0xef9f]
> pci 0000:00:1f.4: System wakeup disabled by ACPI
> pci 0000:00:1f.5: [8086:2445] type 00 class 0x040100
> pci 0000:00:1f.5: reg 0x10: [io  0xe800-0xe8ff]
> pci 0000:00:1f.5: reg 0x14: [io  0xef00-0xef3f]
> pci 0000:01:00.0: [1002:5159] type 00 class 0x030000
> pci 0000:01:00.0: reg 0x10: [mem 0xd0000000-0xd7ffffff pref]
> pci 0000:01:00.0: reg 0x14: [io  0xc800-0xc8ff]
> pci 0000:01:00.0: reg 0x18: [mem 0xff8f0000-0xff8fffff]
> pci 0000:01:00.0: reg 0x30: [mem 0xff8c0000-0xff8dffff pref]
> pci 0000:01:00.0: supports D1 D2
> pci 0000:00:01.0: PCI bridge to [bus 01]
> pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
> pci 0000:00:01.0:   bridge window [mem 0xff800000-0xff8fffff]
> pci 0000:00:01.0:   bridge window [mem 0xce900000-0xde9fffff pref]
> pci 0000:02:08.0: [8086:2449] type 00 class 0x020000
> pci 0000:02:08.0: reg 0x10: [mem 0xff9ff000-0xff9fffff]
> pci 0000:02:08.0: reg 0x14: [io  0xdf00-0xdf3f]
> pci 0000:02:08.0: supports D1 D2
> pci 0000:02:08.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:1e.0: PCI bridge to [bus 02] (subtractive decode)
> pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
> pci 0000:00:1e.0:   bridge window [mem 0xff900000-0xff9fffff]
> pci 0000:00:1e.0:   bridge window [mem 0xdea00000-0xdeafffff pref]
> pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
> pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
> pci_bus 0000:00: on NUMA node 0
> acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
> ACPI: Enabled 1 GPEs in block 10 to 1F
> ACPI: \_SB_.PCI0: notify handler is installed
> Found 1 acpi root devices
> vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> vgaarb: bridge control possible 0000:01:00.0
> SCSI subsystem initialized
> ACPI: bus type ATA registered
> libata version 3.00 loaded.
> PCI: Using ACPI for IRQ routing
> PCI: pci_cache_line_size set to 64 bytes
> e820: reserve RAM buffer [mem 0x0009bc00-0x0009ffff]
> e820: reserve RAM buffer [mem 0x3ffc0000-0x3fffffff]
> Switched to clocksource refined-jiffies
> pnp: PnP ACPI init
> ACPI: bus type PNP registered
> system 00:00: [io  0x04d0-0x04d1] has been reserved
> system 00:00: [io  0x0884-0x0885] has been reserved
> system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> system 00:01: [io  0x0400-0x047f] could not be reserved
> system 00:01: [io  0x0500-0x053f] has been reserved
> system 00:01: [io  0x0800-0x087f] has been reserved
> system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
> system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
> system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:02: [dma 4]
> pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
> pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
> pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
> pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
> pnp 00:06: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
> pnp 00:07: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> pnp 00:08: [dma 2]
> pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
> pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
> pnp 00:0a: Plug and Play ACPI device, IDs PNP0501 (active)
> pnp 00:0b: [dma 3]
> pnp 00:0b: Plug and Play ACPI device, IDs PNP0401 (active)
> pnp 00:0c: Plug and Play ACPI device, IDs INT0800 (active)
> system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
> system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
> system 00:0d: [mem 0x00100000-0x3fffffff] could not be reserved
> system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
> pnp: PnP ACPI: found 14 devices
> ACPI: bus type PNP unregistered
> Switched to clocksource acpi_pm
> pci 0000:00:1f.0: BAR 7: [io  0x0400-0x047f] has bogus alignment
> pci 0000:00:01.0: PCI bridge to [bus 01]
> pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
> pci 0000:00:01.0:   bridge window [mem 0xff800000-0xff8fffff]
> pci 0000:00:01.0:   bridge window [mem 0xce900000-0xde9fffff pref]
> pci 0000:00:1e.0: PCI bridge to [bus 02]
> pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
> pci 0000:00:1e.0:   bridge window [mem 0xff900000-0xff9fffff]
> pci 0000:00:1e.0:   bridge window [mem 0xdea00000-0xdeafffff pref]
> pci 0000:00:1e.0: setting latency timer to 64
> pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
> pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
> pci_bus 0000:01: resource 1 [mem 0xff800000-0xff8fffff]
> pci_bus 0000:01: resource 2 [mem 0xce900000-0xde9fffff pref]
> pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
> pci_bus 0000:02: resource 1 [mem 0xff900000-0xff9fffff]
> pci_bus 0000:02: resource 2 [mem 0xdea00000-0xdeafffff pref]
> pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
> pci_bus 0000:02: resource 5 [mem 0x00000000-0xffffffff]
> NET: Registered protocol family 2
> TCP established hash table entries: 8192 (order: 4, 65536 bytes)
> TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
> TCP: Hash tables configured (established 8192 bind 8192)
> TCP: reno registered
> UDP hash table entries: 512 (order: 1, 8192 bytes)
> UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
> NET: Registered protocol family 1
> pci 0000:01:00.0: Boot video device
> pci 0000:02:08.0: Firmware left e100 interrupts enabled; disabling
> PCI: CLS 32 bytes, default 64
> msgmni has been set to 1764
> alg: No test for stdrng (krng)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler cfq registered (default)
> Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> ata_piix 0000:00:1f.1: version 2.13
> ata_piix 0000:00:1f.1: setting latency timer to 64
> scsi0 : ata_piix
> scsi1 : ata_piix
> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> e100 0000:02:08.0 eth0: addr 0xff9ff000, irq 20, MAC addr 00:07:e9:94:ce:33
> i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mousedev: PS/2 mouse device common for all mice
> rtc_cmos 00:03: RTC can wake from S4
> rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> rtc_cmos 00:03: alarms up to one month, 114 bytes nvram
> cpuidle: using governor ladder
> cpuidle: using governor menu
> TCP: cubic registered
> NET: Registered protocol family 17
> Key type dns_resolver registered
> Using IPI Shortcut mode
> PM: Hibernation image not present or could not be loaded.
> rtc_cmos 00:03: setting system clock to 2013-07-29 10:05:08 UTC (1375092308)
> ata1.00: ATA-7: HDS728080PLAT20, PF2OA21B, max UDMA/133
> ata1.00: 160836480 sectors, multi 16: LBA48 
> ata1.00: configured for UDMA/100
> scsi 0:0:0:0: Direct-Access     ATA      HDS728080PLAT20  PF2O PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 160836480 512-byte logical blocks: (82.3 GB/76.6 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2 < sda5 >
> sd 0:0:0:0: [sda] Attached SCSI disk
> ata2.01: ATAPI: LITE-ON LTR-32123S, XS0R, max UDMA/33
> ata2.01: configured for UDMA/33
> scsi 1:0:1:0: CD-ROM            LITE-ON  LTR-32123S       XS0R PQ: 0 ANSI: 5
> EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
> EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> Freeing unused kernel memory: 296K (c1360000 - c13aa000)
> tsc: Refined TSC clocksource calibration: 1993.938 MHz
> Switched to clocksource tsc
> input: PC Speaker as /devices/platform/pcspkr/input/input0
> sr0: scsi3-mmc drive: 22x/40x writer cd/rw xa/form2 cdda tray
> cdrom: Uniform CD-ROM driver Revision: 3.20
> sr 1:0:1:0: Attached scsi CD-ROM sr0
> microcode: CPU0 sig=0xf24, pf=0x4, revision=0xf
> input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> ACPI: Power Button [PBTN]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> ACPI: Power Button [PWRF]
> Linux agpgart interface v0.103
> ACPI: bus type USB registered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> intel_rng: Firmware space is locked read-only. If you can't or
> intel_rng: don't want to disable this in firmware setup, and if
> intel_rng: you are certain that your system has a functional
> intel_rng: RNG, try using the 'no_fwh_detect' option.
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> sr 1:0:1:0: Attached scsi generic sg1 type 5
> Floppy drive(s): fd0 is 1.44M
> agpgart-intel 0000:00:00.0: Intel i850 Chipset
> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
> FDC 0 is a post-1991 82077
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> uhci_hcd: USB Universal Host Controller Interface driver
> uhci_hcd 0000:00:1f.2: setting latency timer to 64
> uhci_hcd 0000:00:1f.2: UHCI Host Controller
> uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
> uhci_hcd 0000:00:1f.2: irq 19, io base 0x0000ef40
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: UHCI Host Controller
> usb usb1: Manufacturer: Linux 3.11.0-rc3 uhci_hcd
> usb usb1: SerialNumber: 0000:00:1f.2
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> uhci_hcd 0000:00:1f.4: setting latency timer to 64
> uhci_hcd 0000:00:1f.4: UHCI Host Controller
> uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1f.4: irq 23, io base 0x0000ef80
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: UHCI Host Controller
> usb usb2: Manufacturer: Linux 3.11.0-rc3 uhci_hcd
> usb usb2: SerialNumber: 0000:00:1f.4
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> parport_pc 00:0b: reported by Plug and Play ACPI
> parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
> [drm] Initialized drm 1.1.0 20060810
> ACPI Warning: 0x00000500-0x0000052f SystemIO conflicts with Region \GLED 1 (20130517/utaddress-251)
> ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> usb 2-2: new full-speed USB device number 2 using uhci_hcd
> snd_intel8x0 0000:00:1f.5: setting latency timer to 64
> microcode: CPU0 sig=0xf24, pf=0x4, revision=0xf
> microcode: CPU0 updated to revision 0x1e, date = 2003-06-05
> microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> usb 2-2: New USB device found, idVendor=0424, idProduct=0140
> usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> hub 2-2:1.0: USB hub found
> hub 2-2:1.0: 4 ports detected
> [drm] radeon kernel modesetting enabled.
> [drm] initializing kernel modesetting (RV100 0x1002:0x5159 0x2023:0x148C).
> [drm] register mmio base: 0xFF8F0000
> [drm] register mmio size: 65536
> agpgart-intel 0000:00:00.0: AGP 2.0 bridge
> agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
> radeon 0000:01:00.0: putting AGP V2 device into 4x mode
> radeon 0000:01:00.0: GTT: 256M 0xE0000000 - 0xEFFFFFFF
> radeon 0000:01:00.0: VRAM: 128M 0x00000000D0000000 - 0x00000000D7FFFFFF (32M used)
> [drm] Detected VRAM RAM=128M, BAR=128M
> [drm] RAM width 64bits DDR
> [TTM] Zone  kernel: Available graphics memory: 451924 kiB
> [TTM] Initializing pool allocator
> [drm] radeon: 32M of VRAM memory ready
> [drm] radeon: 256M of GTT memory ready.
> radeon 0000:01:00.0: WB disabled
> radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x00000000e0000000 and cpu addr 0xf87e2000
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] Driver supports precise vblank timestamp query.
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 243 at kernel/workqueue.c:1378 __queue_work+0x132/0x16d()
> Modules linked in: radeon(+) mperf snd_intel8x0(+) drm_kms_helper snd_ac97_codec ttm ac97_bus lpc_ich drm snd_pcm snd_page_alloc mfd_core cfbfillrect parport_pc parport cfbimgblt cfbcopyarea i2c_algo_bit uhci_hcd ehci_hcd backlight evdev intel_agp floppy sg snd_timer intel_gtt usbcore processor snd agpgart psmouse rng_core button microcode thermal_sys sr_mod i2c_i801 soundcore usb_common cdrom pcspkr i2c_core
> CPU: 0 PID: 243 Comm: modprobe Not tainted 3.11.0-rc3 #48
> Hardware name: MicroLink                               /D850MV                         , BIOS MV85010A.86A.0067.P24.0304081124 04/08/2003
>  c12319b3 c1022600 c12c0968 00000000 000000f3 c12c18ac 00000562 c1031010
>  c1031010 f7794500 f700f500 f71056b0 00000000 c102269e 00000009 00000000
>  c1031010 00000082 00000082 c13b9618 00000400 000001aa 00000001 00000286
> Call Trace:
>  [<c12319b3>] ? dump_stack+0xa/0x13
>  [<c1022600>] ? warn_slowpath_common+0x75/0x8a
>  [<c1031010>] ? __queue_work+0x132/0x16d
>  [<c1031010>] ? __queue_work+0x132/0x16d
>  [<c102269e>] ? warn_slowpath_null+0x1b/0x1f
>  [<c1031010>] ? __queue_work+0x132/0x16d
>  [<c103107b>] ? queue_work_on+0x30/0x40
>  [<f8aed3f3>] ? r100_irq_process+0x16d/0x1e6 [radeon]
>  [<f8ae77cf>] ? radeon_driver_irq_preinstall_kms+0xc2/0xc5 [radeon]
>  [<f8974d77>] ? drm_irq_install+0xb2/0x1ac [drm]
>  [<f897604d>] ? drm_vblank_init+0x196/0x1d2 [drm]
>  [<f8ae78d3>] ? radeon_irq_kms_init+0x33/0xc6 [radeon]
>  [<f8aef35a>] ? r100_startup+0x1a3/0x1d6 [radeon]
>  [<f8ad77c8>] ? radeon_ttm_init+0x26e/0x287 [radeon]
>  [<f8aef752>] ? r100_init+0x2b3/0x309 [radeon]
>  [<c118082e>] ? vga_client_register+0x39/0x40
>  [<f8ac535f>] ? radeon_device_init+0x54b/0x61b [radeon]
>  [<f8ac40fd>] ? cail_mc_write+0x13/0x13 [radeon]
>  [<f8ac6864>] ? radeon_driver_load_kms+0x82/0xda [radeon]
>  [<f8978bbd>] ? drm_get_pci_dev+0x136/0x22d [drm]
>  [<f8ac409b>] ? radeon_pci_probe+0x6c/0x86 [radeon]
>  [<c112acf6>] ? pci_device_probe+0x4c/0x83
>  [<c11846c7>] ? driver_probe_device+0x80/0x184
>  [<c112a848>] ? pci_match_id+0x18/0x36
>  [<c1184837>] ? __driver_attach+0x44/0x5f
>  [<c11833f4>] ? bus_for_each_dev+0x50/0x5a
>  [<c118433e>] ? driver_attach+0x14/0x16
>  [<c11847f3>] ? __device_attach+0x28/0x28
>  [<c1184045>] ? bus_add_driver+0xd6/0x1bf
>  [<c1184c22>] ? driver_register+0x78/0xcf
>  [<f8ba8000>] ? 0xf8ba7fff
>  [<c10003bf>] ? do_one_initcall+0x8b/0x121
>  [<c101e668>] ? change_page_attr_clear+0x2e/0x33
>  [<f8ba8000>] ? 0xf8ba7fff
>  [<c101e689>] ? set_memory_ro+0x1c/0x20
>  [<c104de94>] ? set_page_attributes+0x11/0x12
>  [<c104f6e1>] ? load_module+0x12fa/0x17e8
>  [<c107483b>] ? map_vm_area+0x22/0x31
>  [<c104fc36>] ? SyS_init_module+0x67/0x7d
>  [<c1234245>] ? sysenter_do_call+0x12/0x26
> ---[ end trace ff78978d3ff2661f ]---
> [drm] radeon: irq initialized.
> [drm] Loading R100 Microcode
> [drm] radeon: ring at 0x00000000E0001000
> [drm] ring test succeeded in 1 usecs
> [drm] ib test succeeded in 0 usecs
> [drm] No TV DAC info found in BIOS
> [drm] Radeon Display Connectors
> [drm] Connector 0:
> [drm]   VGA-1
> [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
> [drm]   Encoders:
> [drm]     CRT1: INTERNAL_DAC1
> [drm] Connector 1:
> [drm]   DVI-I-1
> [drm]   HPD1
> [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
> [drm]   Encoders:
> [drm]     CRT2: INTERNAL_DAC2
> [drm]     DFP1: INTERNAL_TMDS1
> [drm] Connector 2:
> [drm]   SVIDEO-1
> [drm]   Encoders:
> [drm]     TV1: INTERNAL_DAC2
> radeon 0000:01:00.0: No connectors reported connected with modes
> [drm] Cannot find any crtc or sizes - going 1024x768
> [drm] fb mappable at 0xD0040000
> [drm] vram apper at 0xD0000000
> [drm] size 786432
> [drm] fb depth is 8
> [drm]    pitch is 1024
> fbcon: radeondrmfb (fb0) is primary device
> Console: switching to colour frame buffer device 128x48
> radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
> radeon 0000:01:00.0: registered panic notifier
> [drm] Initialized radeon 2.34.0 20080528 for 0000:01:00.0 on minor 0
> Error: Driver 'pcspkr' is already registered, aborting...
> intel8x0_measure_ac97_clock: measured 52075 usecs (2916 samples)
> intel8x0: clocking to 41145
> Adding 1002492k swap on /dev/sda5.  Priority:-1 extents:1 across:1002492k 
> EXT4-fs (sda1): re-mounted. Opts: (null)
> EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
> loop: module loaded
> smsc47m1: Found SMSC LPC47M14x
> ACPI Warning: 0x00000804-0x00000804 SystemIO conflicts with Region \_SB_.PCI0.SBRG.RNT3 1 (20130517/utaddress-251)
> ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> NET: Registered protocol family 10
> IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> e100 0000:02:08.0 eth0: NIC Link is Up 100 Mbps Full Duplex
> IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> 
> 
> 00:00.0 Host bridge: Intel Corporation 82850 850 (Tehama) Chipset Host Bridge (MCH) (rev 04)
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
> 	Capabilities: [a0] AGP version 2.0
> 		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
> 		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
> 	Kernel driver in use: agpgart-intel
> 00: 86 80 30 25 06 01 90 20 04 00 00 06 00 00 00 00
> 10: 08 00 00 e0 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00
> 40: d4 d4 d4 d4 80 80 80 80 80 80 80 80 80 80 80 80
> 50: 05 0a 02 00 00 00 00 00 00 10 11 11 01 00 11 31
> 60: 10 00 20 08 30 10 40 18 40 18 40 18 40 18 40 18
> 70: 40 18 40 18 40 18 40 18 40 18 40 18 40 18 40 18
> 80: 00 00 00 00 00 00 00 00 0f 00 00 00 00 00 00 00
> 90: 0f 00 0f 00 e1 01 01 08 55 19 00 00 80 0a 38 00
> a0: 02 00 20 00 17 02 00 1f 04 03 00 00 00 00 00 00
> b0: 80 00 00 00 00 00 00 00 00 00 a4 35 20 10 8b 00
> c0: 44 40 50 11 00 40 00 00 00 c0 00 00 00 00 00 00
> d0: 02 28 00 0e 03 00 00 33 af 09 31 b5 01 00 00 00
> e0: 00 00 00 00 00 00 00 00 2c 23 2f 23 07 00 00 00
> f0: 00 00 01 00 74 f8 30 80 38 0f 00 00 00 00 00 00
> 
> 00:01.0 PCI bridge: Intel Corporation 82850 850 (Tehama) Chipset AGP Bridge (rev 04) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 32
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
> 	I/O behind bridge: 0000c000-0000cfff
> 	Memory behind bridge: ff800000-ff8fffff
> 	Prefetchable memory behind bridge: ce900000-de9fffff
> 	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 00: 86 80 32 25 07 01 a0 00 04 00 04 06 00 20 01 00
> 10: 00 00 00 00 00 00 00 00 00 01 01 20 c0 c0 a0 02
> 20: 80 ff 80 ff 90 ce 90 de 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 04) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
> 	I/O behind bridge: 0000d000-0000dfff
> 	Memory behind bridge: ff900000-ff9fffff
> 	Prefetchable memory behind bridge: dea00000-deafffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 00: 86 80 4e 24 07 01 80 00 04 00 04 06 00 00 01 00
> 10: 00 00 00 00 00 00 00 00 00 02 02 20 d0 d0 80 02
> 20: 90 ff 90 ff a0 de a0 de 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00
> 40: 00 28 20 20 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 c0 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 10 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 01 00 02 00 03 00 c0 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801BA ISA Bridge (LPC) (rev 04)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Kernel driver in use: lpc_ich
> 00: 86 80 40 24 0f 00 80 02 04 00 01 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 01 04 00 00 10 00 00 00 00 00 00 00 00 00 02 00
> 50: 00 00 00 00 00 00 00 00 01 05 00 00 10 00 00 00
> 60: 8b 89 80 85 d0 00 00 00 8b 80 80 8a 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: ff fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 10 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 01 02 00 00 00 00
> c0: 00 00 00 00 00 00 84 08 00 00 00 00 10 00 00 00
> d0: 96 21 00 00 02 0f 00 00 04 00 00 00 00 00 00 00
> e0: 10 00 00 c0 01 08 0f 34 33 22 11 00 00 00 67 45
> f0: 00 00 40 00 00 00 00 00 47 0f 00 00 00 00 00 02
> 
> 00:1f.1 IDE interface: Intel Corporation 82801BA IDE U100 Controller (rev 04) (prog-if 80 [Master])
> 	Subsystem: Intel Corporation Device 4d44
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
> 	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
> 	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
> 	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
> 	Region 4: I/O ports at ffa0 [size=16]
> 	Kernel driver in use: ata_piix
> 00: 86 80 4b 24 05 00 80 02 04 80 01 01 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: a1 ff 00 00 00 00 00 00 00 00 00 00 86 80 44 4d
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 07 e3 30 c0 b0 00 00 00 09 00 01 20 00 00 00 00
> 50: 00 00 00 00 10 14 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.2 USB controller: Intel Corporation 82801BA/BAM USB Controller #1 (rev 04) (prog-if 00 [UHCI])
> 	Subsystem: Intel Corporation Device 4d44
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 19
> 	Region 4: I/O ports at ef40 [size=32]
> 	Kernel driver in use: uhci_hcd
> 00: 86 80 42 24 05 00 80 02 04 00 03 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 41 ef 00 00 00 00 00 00 00 00 00 00 86 80 44 4d
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 05 04 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.3 SMBus: Intel Corporation 82801BA/BAM SMBus Controller (rev 04)
> 	Subsystem: Intel Corporation Device 4d44
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin B routed to IRQ 17
> 	Region 4: I/O ports at efa0 [size=16]
> 	Kernel driver in use: i801_smbus
> 00: 86 80 43 24 01 00 80 02 04 00 05 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: a1 ef 00 00 00 00 00 00 00 00 00 00 86 80 44 4d
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00
> 40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.4 USB controller: Intel Corporation 82801BA/BAM USB Controller #1 (rev 04) (prog-if 00 [UHCI])
> 	Subsystem: Intel Corporation Device 4d44
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 23
> 	Region 4: I/O ports at ef80 [size=32]
> 	Kernel driver in use: uhci_hcd
> 00: 86 80 44 24 05 00 80 02 04 00 03 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 81 ef 00 00 00 00 00 00 00 00 00 00 86 80 44 4d
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 03 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801BA/BAM AC'97 Audio Controller (rev 04)
> 	Subsystem: Intel Corporation Device 4d44
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 17
> 	Region 0: I/O ports at e800 [size=256]
> 	Region 1: I/O ports at ef00 [size=64]
> 	Kernel driver in use: snd_intel8x0
> 00: 86 80 45 24 05 00 80 02 04 00 01 04 00 00 00 00
> 10: 01 e8 00 00 01 ef 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 44 4d
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] RV100 [Radeon 7000 / Radeon VE] (prog-if 00 [VGA controller])
> 	Subsystem: Device 2023:148c
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
> 	Region 1: I/O ports at c800 [size=256]
> 	Region 2: Memory at ff8f0000 (32-bit, non-prefetchable) [size=64K]
> 	Expansion ROM at ff8c0000 [disabled] [size=128K]
> 	Capabilities: [58] AGP version 2.0
> 		Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
> 		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
> 	Capabilities: [50] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: radeon
> 00: 02 10 59 51 87 01 b0 02 00 00 00 03 08 20 00 00
> 10: 08 00 00 d0 01 c8 00 00 00 00 8f ff 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 23 20 8c 14
> 30: 00 00 8c ff 58 00 00 00 00 00 00 00 0b 01 08 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 23 20 8c 14
> 50: 01 00 02 06 00 00 00 00 02 50 20 00 07 02 00 2f
> 60: 04 03 00 1f 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 02:08.0 Ethernet controller: Intel Corporation 82801BA/BAM/CA/CAM Ethernet Controller (rev 03)
> 	Subsystem: Intel Corporation EtherExpress PRO/100 VE
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 20
> 	Region 0: Memory at ff9ff000 (32-bit, non-prefetchable) [size=4K]
> 	Region 1: I/O ports at df00 [size=64]
> 	Capabilities: [dc] Power Management version 2
> 		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
> 	Kernel driver in use: e100
> 00: 86 80 49 24 17 01 90 02 03 00 00 02 08 20 00 00
> 10: 00 f0 9f ff 01 df 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 13 30
> 30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 08 38
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 22 fe
> e0: 00 40 00 3a 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 
> 
> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86 3.11.0-rc3 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> # CONFIG_FHANDLE is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_STALL_COMMON is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_CGROUPS is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> # CONFIG_NET_NS is not set
> CONFIG_UIDGID_CONVERTED=y
> # CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> # CONFIG_BLK_DEV_INITRD is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_SLUB_CPU_PARTIAL=y
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> CONFIG_JUMP_LABEL=y
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_MODULE_SIG is not set
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> # CONFIG_BLK_DEV_BSGLIB is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> # CONFIG_ACORN_PARTITION_CUMANA is not set
> # CONFIG_ACORN_PARTITION_EESOX is not set
> CONFIG_ACORN_PARTITION_ICS=y
> # CONFIG_ACORN_PARTITION_ADFS is not set
> # CONFIG_ACORN_PARTITION_POWERTEC is not set
> CONFIG_ACORN_PARTITION_RISCIX=y
> CONFIG_AIX_PARTITION=y
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> CONFIG_ATARI_PARTITION=y
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_BSD_DISKLABEL=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_UNIXWARE_DISKLABEL=y
> CONFIG_LDM_PARTITION=y
> # CONFIG_LDM_DEBUG is not set
> CONFIG_SGI_PARTITION=y
> CONFIG_ULTRIX_PARTITION=y
> CONFIG_SUN_PARTITION=y
> CONFIG_KARMA_PARTITION=y
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_DEADLINE is not set
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> CONFIG_INLINE_READ_UNLOCK=y
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> CONFIG_INLINE_WRITE_UNLOCK=y
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_32_IRIS is not set
> CONFIG_SCHED_OMIT_FRAME_POINTER=y
> # CONFIG_HYPERVISOR_GUEST is not set
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> CONFIG_MPENTIUM4=y
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=7
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> # CONFIG_HPET_TIMER is not set
> CONFIG_DMI=y
> CONFIG_NR_CPUS=1
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_X86_UP_APIC=y
> CONFIG_X86_UP_IOAPIC=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> # CONFIG_X86_ANCIENT_MCE is not set
> CONFIG_X86_MCE_THRESHOLD=y
> # CONFIG_X86_MCE_INJECT is not set
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> # CONFIG_X86_REBOOTFIXUPS is not set
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_LIB=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> # CONFIG_X86_PAE is not set
> CONFIG_NEED_NODE_MEMMAP_SIZE=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_COMPACTION is not set
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_FRONTSWAP is not set
> # CONFIG_ZBUD is not set
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATE_CALLBACKS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_PM_SLEEP=y
> # CONFIG_PM_AUTOSLEEP is not set
> # CONFIG_PM_WAKELOCKS is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> CONFIG_PM_ADVANCED_DEBUG=y
> # CONFIG_PM_TEST_SUSPEND is not set
> CONFIG_PM_SLEEP_DEBUG=y
> # CONFIG_PM_TRACE_RTC is not set
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=m
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_I2C=m
> CONFIG_ACPI_PROCESSOR=m
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=m
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> CONFIG_X86_APM_BOOT=y
> CONFIG_APM=m
> # CONFIG_APM_IGNORE_USER_SUSPEND is not set
> # CONFIG_APM_DO_ENABLE is not set
> # CONFIG_APM_CPU_IDLE is not set
> # CONFIG_APM_DISPLAY_BLANK is not set
> # CONFIG_APM_ALLOW_INTS is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=m
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> CONFIG_CPU_FREQ_GOV_USERSPACE=m
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> # CONFIG_X86_PCC_CPUFREQ is not set
> CONFIG_X86_ACPI_CPUFREQ=m
> # CONFIG_X86_ACPI_CPUFREQ_CPB is not set
> # CONFIG_X86_POWERNOW_K6 is not set
> # CONFIG_X86_POWERNOW_K7 is not set
> # CONFIG_X86_POWERNOW_K8 is not set
> # CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
> # CONFIG_X86_GX_SUSPMOD is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> CONFIG_X86_SPEEDSTEP_ICH=m
> CONFIG_X86_SPEEDSTEP_SMI=m
> CONFIG_X86_P4_CLOCKMOD=m
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> # CONFIG_X86_LONGRUN is not set
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=m
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> CONFIG_PCI_IOAPIC=y
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_OLPC is not set
> # CONFIG_ALIX is not set
> # CONFIG_NET5501 is not set
> # CONFIG_GEOS is not set
> CONFIG_AMD_NB=y
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=m
> CONFIG_BINFMT_MISC=m
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=m
> CONFIG_UNIX=y
> CONFIG_UNIX_DIAG=m
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=m
> CONFIG_XFRM_USER=m
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=m
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_ROUTE_CLASSID=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE_DEMUX=m
> CONFIG_NET_IP_TUNNEL=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> # CONFIG_IP_MROUTE is not set
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=m
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> # CONFIG_INET_XFRM_MODE_BEET is not set
> CONFIG_INET_LRO=m
> CONFIG_INET_DIAG=m
> CONFIG_INET_TCP_DIAG=m
> CONFIG_INET_UDP_DIAG=m
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> CONFIG_IPV6=m
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> CONFIG_INET6_IPCOMP=m
> CONFIG_IPV6_MIP6=m
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_SIT=m
> CONFIG_IPV6_SIT_6RD=y
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=m
> CONFIG_IPV6_GRE=m
> CONFIG_IPV6_MULTIPLE_TABLES=y
> CONFIG_IPV6_SUBTREES=y
> CONFIG_IPV6_MROUTE=y
> CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
> CONFIG_IPV6_PIMSM_V2=y
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_ACCT=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_ZONES=y
> CONFIG_NF_CONNTRACK_PROCFS=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> CONFIG_NF_CONNTRACK_TIMEOUT=y
> CONFIG_NF_CONNTRACK_TIMESTAMP=y
> CONFIG_NF_CONNTRACK_LABELS=y
> CONFIG_NF_CT_PROTO_DCCP=m
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CT_PROTO_SCTP=m
> CONFIG_NF_CT_PROTO_UDPLITE=m
> CONFIG_NF_CONNTRACK_AMANDA=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_H323=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_BROADCAST=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_SNMP=m
> CONFIG_NF_CONNTRACK_PPTP=m
> CONFIG_NF_CONNTRACK_SANE=m
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NF_CT_NETLINK=m
> CONFIG_NF_CT_NETLINK_TIMEOUT=m
> CONFIG_NF_CT_NETLINK_HELPER=m
> CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_NF_NAT_PROTO_DCCP=m
> CONFIG_NF_NAT_PROTO_UDPLITE=m
> CONFIG_NF_NAT_PROTO_SCTP=m
> CONFIG_NF_NAT_AMANDA=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_SIP=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NETFILTER_TPROXY=m
> CONFIG_NETFILTER_XTABLES=m
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=m
> CONFIG_NETFILTER_XT_CONNMARK=m
> CONFIG_NETFILTER_XT_SET=m
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_CT=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_HL=m
> CONFIG_NETFILTER_XT_TARGET_HMARK=m
> CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
> CONFIG_NETFILTER_XT_TARGET_LOG=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NETMAP=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> CONFIG_NETFILTER_XT_TARGET_RATEEST=m
> CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
> CONFIG_NETFILTER_XT_TARGET_TEE=m
> CONFIG_NETFILTER_XT_TARGET_TPROXY=m
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
> 
> #
> # Xtables matches
> #
> CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
> CONFIG_NETFILTER_XT_MATCH_BPF=m
> CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_CPU=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ECN=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> CONFIG_NETFILTER_XT_MATCH_HL=m
> CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_NFACCT=m
> CONFIG_NETFILTER_XT_MATCH_OSF=m
> CONFIG_NETFILTER_XT_MATCH_OWNER=m
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> CONFIG_NETFILTER_XT_MATCH_RATEEST=m
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_RECENT=m
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_SOCKET=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_TIME=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_IP_SET=m
> CONFIG_IP_SET_MAX=256
> CONFIG_IP_SET_BITMAP_IP=m
> CONFIG_IP_SET_BITMAP_IPMAC=m
> CONFIG_IP_SET_BITMAP_PORT=m
> CONFIG_IP_SET_HASH_IP=m
> CONFIG_IP_SET_HASH_IPPORT=m
> CONFIG_IP_SET_HASH_IPPORTIP=m
> CONFIG_IP_SET_HASH_IPPORTNET=m
> CONFIG_IP_SET_HASH_NET=m
> CONFIG_IP_SET_HASH_NETPORT=m
> CONFIG_IP_SET_HASH_NETIFACE=m
> CONFIG_IP_SET_LIST_SET=m
> # CONFIG_IP_VS is not set
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=m
> CONFIG_NF_CONNTRACK_IPV4=m
> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_RPFILTER=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT_IPV4=m
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_NF_NAT_SNMP_BASIC=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_NF_NAT_H323=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_CLUSTERIP=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_RAW=m
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV6=m
> CONFIG_NF_CONNTRACK_IPV6=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_IP6_NF_MATCH_AH=m
> CONFIG_IP6_NF_MATCH_EUI64=m
> CONFIG_IP6_NF_MATCH_FRAG=m
> CONFIG_IP6_NF_MATCH_OPTS=m
> CONFIG_IP6_NF_MATCH_HL=m
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> CONFIG_IP6_NF_MATCH_MH=m
> CONFIG_IP6_NF_MATCH_RPFILTER=m
> CONFIG_IP6_NF_MATCH_RT=m
> CONFIG_IP6_NF_TARGET_HL=m
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> CONFIG_IP6_NF_MANGLE=m
> CONFIG_IP6_NF_RAW=m
> CONFIG_NF_NAT_IPV6=m
> CONFIG_IP6_NF_TARGET_MASQUERADE=m
> CONFIG_IP6_NF_TARGET_NPT=m
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> # CONFIG_BRIDGE is not set
> CONFIG_HAVE_NET_DSA=y
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
> # CONFIG_VSOCKETS is not set
> CONFIG_NETLINK_MMAP=y
> # CONFIG_NETLINK_DIAG is not set
> # CONFIG_NET_MPLS_GSO is not set
> CONFIG_NET_LL_RX_POLL=y
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=m
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_FIB_RULES=y
> # CONFIG_WIRELESS is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> # CONFIG_NFC is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_CMA is not set
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> CONFIG_PARPORT=m
> CONFIG_PARPORT_PC=m
> CONFIG_PARPORT_SERIAL=m
> CONFIG_PARPORT_PC_FIFO=y
> CONFIG_PARPORT_PC_SUPERIO=y
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=m
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_DRBD is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> # CONFIG_SENSORS_LIS3LV02D is not set
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ICS932S401 is not set
> # CONFIG_ATMEL_SSC is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_SENSORS_BH1780 is not set
> # CONFIG_SENSORS_BH1770 is not set
> # CONFIG_SENSORS_APDS990X is not set
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> # CONFIG_BMP085_I2C is not set
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> # CONFIG_SRAM is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=m
> CONFIG_EEPROM_LEGACY=m
> # CONFIG_EEPROM_MAX6875 is not set
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> # CONFIG_VMWARE_VMCI is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_ZPODD=y
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> CONFIG_ATA_PIIX=y
> # CONFIG_SATA_HIGHBANK is not set
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_RCAR is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_RZ1000 is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> # CONFIG_ATA_GENERIC is not set
> # CONFIG_PATA_LEGACY is not set
> # CONFIG_MD is not set
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> CONFIG_NET_CORE=y
> # CONFIG_BONDING is not set
> # CONFIG_DUMMY is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_NET_FC is not set
> # CONFIG_NET_TEAM is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_VXLAN is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> CONFIG_TUN=m
> # CONFIG_VETH is not set
> # CONFIG_NLMON is not set
> # CONFIG_ARCNET is not set
> 
> #
> # CAIF transport drivers
> #
> 
> #
> # Distributed Switch Architecture drivers
> #
> # CONFIG_NET_DSA_MV88E6XXX is not set
> # CONFIG_NET_DSA_MV88E6060 is not set
> # CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
> # CONFIG_NET_DSA_MV88E6131 is not set
> # CONFIG_NET_DSA_MV88E6123_61_65 is not set
> CONFIG_ETHERNET=y
> CONFIG_NET_VENDOR_3COM=y
> CONFIG_VORTEX=m
> # CONFIG_TYPHOON is not set
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> # CONFIG_NET_VENDOR_ALTEON is not set
> # CONFIG_NET_VENDOR_AMD is not set
> # CONFIG_NET_VENDOR_ARC is not set
> # CONFIG_NET_VENDOR_ATHEROS is not set
> # CONFIG_NET_CADENCE is not set
> # CONFIG_NET_VENDOR_BROADCOM is not set
> # CONFIG_NET_VENDOR_BROCADE is not set
> # CONFIG_NET_CALXEDA_XGMAC is not set
> # CONFIG_NET_VENDOR_CHELSIO is not set
> # CONFIG_NET_VENDOR_CISCO is not set
> # CONFIG_DNET is not set
> CONFIG_NET_VENDOR_DEC=y
> CONFIG_NET_TULIP=y
> CONFIG_DE2104X=m
> CONFIG_DE2104X_DSL=0
> CONFIG_TULIP=m
> CONFIG_TULIP_MWI=y
> CONFIG_TULIP_MMIO=y
> CONFIG_TULIP_NAPI=y
> CONFIG_TULIP_NAPI_HW_MITIGATION=y
> CONFIG_DE4X5=m
> CONFIG_WINBOND_840=m
> CONFIG_DM9102=m
> # CONFIG_ULI526X is not set
> # CONFIG_NET_VENDOR_DLINK is not set
> # CONFIG_NET_VENDOR_EMULEX is not set
> # CONFIG_NET_VENDOR_EXAR is not set
> # CONFIG_NET_VENDOR_HP is not set
> CONFIG_NET_VENDOR_INTEL=y
> CONFIG_E100=y
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IGB is not set
> # CONFIG_IGBVF is not set
> # CONFIG_IXGB is not set
> # CONFIG_IXGBE is not set
> # CONFIG_NET_VENDOR_I825XX is not set
> # CONFIG_IP1000 is not set
> # CONFIG_JME is not set
> # CONFIG_NET_VENDOR_MARVELL is not set
> # CONFIG_NET_VENDOR_MELLANOX is not set
> # CONFIG_NET_VENDOR_MICREL is not set
> # CONFIG_NET_VENDOR_MYRI is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> # CONFIG_NET_VENDOR_NVIDIA is not set
> # CONFIG_NET_VENDOR_OKI is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_PACKET_ENGINE is not set
> # CONFIG_NET_VENDOR_QLOGIC is not set
> CONFIG_NET_VENDOR_REALTEK=y
> # CONFIG_ATP is not set
> CONFIG_8139CP=m
> CONFIG_8139TOO=m
> # CONFIG_8139TOO_PIO is not set
> CONFIG_8139TOO_TUNE_TWISTER=y
> CONFIG_8139TOO_8129=y
> # CONFIG_8139_OLD_RX_RESET is not set
> CONFIG_R8169=m
> # CONFIG_SH_ETH is not set
> # CONFIG_NET_VENDOR_RDC is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> # CONFIG_NET_VENDOR_SILAN is not set
> # CONFIG_NET_VENDOR_SIS is not set
> # CONFIG_SFC is not set
> # CONFIG_NET_VENDOR_SMSC is not set
> # CONFIG_NET_VENDOR_STMICRO is not set
> # CONFIG_NET_VENDOR_SUN is not set
> # CONFIG_NET_VENDOR_TEHUTI is not set
> # CONFIG_NET_VENDOR_TI is not set
> # CONFIG_NET_VENDOR_VIA is not set
> # CONFIG_NET_VENDOR_WIZNET is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_PHYLIB is not set
> # CONFIG_PLIP is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> CONFIG_USB_RTL8152=m
> # CONFIG_USB_USBNET is not set
> # CONFIG_USB_IPHETH is not set
> # CONFIG_WLAN is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> # CONFIG_WAN is not set
> # CONFIG_VMXNET3 is not set
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=m
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=m
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_CYAPA is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=m
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_APANEL is not set
> # CONFIG_INPUT_WISTRON_BTNS is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_KXTJ9 is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> # CONFIG_INPUT_UINPUT is not set
> # CONFIG_INPUT_PCF8574 is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_IMS_PCU is not set
> # CONFIG_INPUT_CMA3000 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PARKBD is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> # CONFIG_SERIO_ARC_PS2 is not set
> CONFIG_GAMEPORT=m
> CONFIG_GAMEPORT_NS558=m
> CONFIG_GAMEPORT_L4=m
> CONFIG_GAMEPORT_EMU10K1=m
> CONFIG_GAMEPORT_FM801=m
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=32
> CONFIG_SERIAL_8250_RUNTIME_UARTS=8
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> CONFIG_PRINTER=m
> # CONFIG_LP_CONSOLE is not set
> # CONFIG_PPDEV is not set
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=m
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_INTEL=m
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_GEODE is not set
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_NVRAM=m
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=m
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=m
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=m
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> CONFIG_I2C_I801=m
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> # CONFIG_I2C_XILINX is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> # CONFIG_I2C_PARPORT is not set
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_BQ2415X is not set
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_BATTERY_GOLDFISH is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> # CONFIG_SENSORS_ABITUGURU3 is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADM1021 is not set
> CONFIG_SENSORS_ADM1025=m
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7410 is not set
> # CONFIG_SENSORS_ADT7411 is not set
> # CONFIG_SENSORS_ADT7462 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> # CONFIG_SENSORS_ASB100 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS620 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_FSCHMD is not set
> # CONFIG_SENSORS_G760A is not set
> # CONFIG_SENSORS_G762 is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_HIH6130 is not set
> # CONFIG_SENSORS_CORETEMP is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM73 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4151 is not set
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4261 is not set
> # CONFIG_SENSORS_LM95234 is not set
> # CONFIG_SENSORS_LM95241 is not set
> # CONFIG_SENSORS_LM95245 is not set
> # CONFIG_SENSORS_MAX16065 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX1668 is not set
> # CONFIG_SENSORS_MAX197 is not set
> # CONFIG_SENSORS_MAX6639 is not set
> # CONFIG_SENSORS_MAX6642 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_MAX6697 is not set
> # CONFIG_SENSORS_MCP3021 is not set
> # CONFIG_SENSORS_NCT6775 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_SMM665 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_EMC1403 is not set
> # CONFIG_SENSORS_EMC2103 is not set
> # CONFIG_SENSORS_EMC6W201 is not set
> CONFIG_SENSORS_SMSC47M1=m
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_ADS1015 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_AMC6821 is not set
> # CONFIG_SENSORS_INA209 is not set
> # CONFIG_SENSORS_INA2XX is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> # CONFIG_SENSORS_TMP421 is not set
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83795 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_SENSORS_APPLESMC is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=m
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> # CONFIG_CPU_THERMAL is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> # CONFIG_X86_PKG_TEMP_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=m
> # CONFIG_MFD_CS5535 is not set
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> CONFIG_LPC_ICH=m
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_KEMPLD is not set
> # CONFIG_MFD_VIPERBOARD is not set
> # CONFIG_MFD_RETU is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> # CONFIG_MFD_SI476X_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_SYSCON is not set
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_REGULATOR is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=m
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=m
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> # CONFIG_AGP_VIA is not set
> # CONFIG_AGP_EFFICEON is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=m
> CONFIG_DRM_KMS_HELPER=m
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=m
> 
> #
> # I2C encoder or helper chips
> #
> # CONFIG_DRM_I2C_CH7006 is not set
> # CONFIG_DRM_I2C_SIL164 is not set
> # CONFIG_DRM_I2C_NXP_TDA998X is not set
> CONFIG_DRM_TDFX=m
> CONFIG_DRM_R128=m
> CONFIG_DRM_RADEON=m
> # CONFIG_DRM_RADEON_UMS is not set
> # CONFIG_DRM_NOUVEAU is not set
> CONFIG_DRM_I810=m
> CONFIG_DRM_I915=m
> CONFIG_DRM_I915_KMS=y
> CONFIG_DRM_MGA=m
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_VMWGFX is not set
> # CONFIG_DRM_GMA500 is not set
> # CONFIG_DRM_UDL is not set
> # CONFIG_DRM_AST is not set
> # CONFIG_DRM_MGAG200 is not set
> # CONFIG_DRM_CIRRUS_QEMU is not set
> # CONFIG_DRM_QXL is not set
> CONFIG_VGASTATE=m
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> CONFIG_HDMI=y
> CONFIG_FB=y
> # CONFIG_FIRMWARE_EDID is not set
> CONFIG_FB_DDC=m
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=m
> CONFIG_FB_CFB_COPYAREA=m
> CONFIG_FB_CFB_IMAGEBLIT=m
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> # CONFIG_FB_SYS_FILLRECT is not set
> # CONFIG_FB_SYS_COPYAREA is not set
> # CONFIG_FB_SYS_IMAGEBLIT is not set
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> # CONFIG_FB_SYS_FOPS is not set
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> # CONFIG_FB_HGA is not set
> # CONFIG_FB_S1D13XXX is not set
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> CONFIG_FB_I740=m
> # CONFIG_FB_I810 is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> # CONFIG_FB_GOLDFISH is not set
> # CONFIG_FB_VIRTUAL is not set
> # CONFIG_FB_METRONOME is not set
> # CONFIG_FB_MB862XX is not set
> # CONFIG_FB_BROADSHEET is not set
> # CONFIG_FB_AUO_K190X is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> # CONFIG_LCD_PLATFORM is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> CONFIG_BACKLIGHT_GENERIC=m
> # CONFIG_BACKLIGHT_APPLE is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> # CONFIG_BACKLIGHT_LM3630 is not set
> # CONFIG_BACKLIGHT_LM3639 is not set
> # CONFIG_BACKLIGHT_LP855X is not set
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> # CONFIG_LOGO is not set
> CONFIG_SOUND=m
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_SEQUENCER=m
> CONFIG_SND_SEQ_DUMMY=m
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> CONFIG_SND_SEQUENCER_OSS=y
> CONFIG_SND_HRTIMER=m
> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> CONFIG_SND_DYNAMIC_MINORS=y
> CONFIG_SND_MAX_CARDS=32
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_VERBOSE_PROCFS=y
> CONFIG_SND_VERBOSE_PRINTK=y
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=m
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_PCSP=m
> CONFIG_SND_DUMMY=m
> CONFIG_SND_ALOOP=m
> CONFIG_SND_VIRMIDI=m
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_MTS64 is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
> # CONFIG_SND_PORTMAN2X4 is not set
> CONFIG_SND_AC97_POWER_SAVE=y
> CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ASIHPI is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> CONFIG_SND_INTEL8X0=m
> CONFIG_SND_INTEL8X0M=m
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SIS7019 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> # CONFIG_SND_USB is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=m
> 
> #
> # HID support
> #
> CONFIG_HID=m
> CONFIG_HIDRAW=y
> CONFIG_UHID=m
> CONFIG_HID_GENERIC=m
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=m
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=m
> # CONFIG_HID_APPLEIR is not set
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=m
> CONFIG_HID_CHERRY=m
> CONFIG_HID_CHICONY=m
> # CONFIG_HID_PRODIKEYS is not set
> CONFIG_HID_CYPRESS=m
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_ELECOM is not set
> # CONFIG_HID_ELO is not set
> CONFIG_HID_EZKEY=m
> # CONFIG_HID_HOLTEK is not set
> # CONFIG_HID_HUION is not set
> # CONFIG_HID_KEYTOUCH is not set
> CONFIG_HID_KYE=m
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=m
> # CONFIG_HID_LCPOWER is not set
> CONFIG_HID_LENOVO_TPKBD=m
> CONFIG_HID_LOGITECH=m
> # CONFIG_HID_LOGITECH_DJ is not set
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> # CONFIG_LOGIG940_FF is not set
> # CONFIG_LOGIWHEELS_FF is not set
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MICROSOFT=m
> CONFIG_HID_MONTEREY=m
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_ROCCAT is not set
> # CONFIG_HID_SAITEK is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SONY is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_STEELSERIES is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TIVO is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_THINGM is not set
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_WACOM is not set
> # CONFIG_HID_WIIMOTE is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_HID_SENSOR_HUB=m
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=m
> CONFIG_HID_PID=y
> CONFIG_USB_HIDDEV=y
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=m
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=m
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEFAULT_PERSIST=y
> CONFIG_USB_DYNAMIC_MINORS=y
> # CONFIG_USB_OTG is not set
> CONFIG_USB_MON=m
> # CONFIG_USB_WUSB_CBAF is not set
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> # CONFIG_USB_XHCI_HCD is not set
> CONFIG_USB_EHCI_HCD=m
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_PCI=m
> # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_ISP1362_HCD is not set
> # CONFIG_USB_FUSBH200_HCD is not set
> CONFIG_USB_OHCI_HCD=m
> CONFIG_USB_OHCI_HCD_PCI=m
> # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=m
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=m
> CONFIG_USB_WDM=m
> CONFIG_USB_TMC=m
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_REALTEK=m
> CONFIG_REALTEK_AUTOPM=y
> CONFIG_USB_STORAGE_DATAFAB=m
> CONFIG_USB_STORAGE_FREECOM=m
> CONFIG_USB_STORAGE_ISD200=m
> CONFIG_USB_STORAGE_USBAT=m
> CONFIG_USB_STORAGE_SDDR09=m
> CONFIG_USB_STORAGE_SDDR55=m
> CONFIG_USB_STORAGE_JUMPSHOT=m
> CONFIG_USB_STORAGE_ALAUDA=m
> CONFIG_USB_STORAGE_ONETOUCH=m
> CONFIG_USB_STORAGE_KARMA=m
> CONFIG_USB_STORAGE_CYPRESS_ATACB=m
> CONFIG_USB_STORAGE_ENE_UB6250=m
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> # CONFIG_USB_DWC3 is not set
> # CONFIG_USB_CHIPIDEA is not set
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=m
> CONFIG_USB_SERIAL=m
> CONFIG_USB_SERIAL_GENERIC=y
> CONFIG_USB_SERIAL_AIRCABLE=m
> CONFIG_USB_SERIAL_ARK3116=m
> CONFIG_USB_SERIAL_BELKIN=m
> CONFIG_USB_SERIAL_CH341=m
> CONFIG_USB_SERIAL_WHITEHEAT=m
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
> CONFIG_USB_SERIAL_CP210X=m
> CONFIG_USB_SERIAL_CYPRESS_M8=m
> CONFIG_USB_SERIAL_EMPEG=m
> CONFIG_USB_SERIAL_FTDI_SIO=m
> CONFIG_USB_SERIAL_FUNSOFT=m
> CONFIG_USB_SERIAL_VISOR=m
> CONFIG_USB_SERIAL_IPAQ=m
> CONFIG_USB_SERIAL_IR=m
> CONFIG_USB_SERIAL_EDGEPORT=m
> CONFIG_USB_SERIAL_EDGEPORT_TI=m
> CONFIG_USB_SERIAL_F81232=m
> CONFIG_USB_SERIAL_GARMIN=m
> CONFIG_USB_SERIAL_IPW=m
> CONFIG_USB_SERIAL_IUU=m
> CONFIG_USB_SERIAL_KEYSPAN_PDA=m
> CONFIG_USB_SERIAL_KEYSPAN=m
> CONFIG_USB_SERIAL_KLSI=m
> CONFIG_USB_SERIAL_KOBIL_SCT=m
> CONFIG_USB_SERIAL_MCT_U232=m
> # CONFIG_USB_SERIAL_METRO is not set
> CONFIG_USB_SERIAL_MOS7720=m
> CONFIG_USB_SERIAL_MOS7715_PARPORT=y
> CONFIG_USB_SERIAL_MOS7840=m
> CONFIG_USB_SERIAL_MOTOROLA=m
> CONFIG_USB_SERIAL_NAVMAN=m
> CONFIG_USB_SERIAL_PL2303=m
> CONFIG_USB_SERIAL_OTI6858=m
> CONFIG_USB_SERIAL_QCAUX=m
> CONFIG_USB_SERIAL_QUALCOMM=m
> CONFIG_USB_SERIAL_SPCP8X5=m
> CONFIG_USB_SERIAL_HP4X=m
> CONFIG_USB_SERIAL_SAFE=m
> CONFIG_USB_SERIAL_SAFE_PADDED=y
> CONFIG_USB_SERIAL_SIEMENS_MPI=m
> CONFIG_USB_SERIAL_SIERRAWIRELESS=m
> CONFIG_USB_SERIAL_SYMBOL=m
> CONFIG_USB_SERIAL_TI=m
> CONFIG_USB_SERIAL_CYBERJACK=m
> CONFIG_USB_SERIAL_XIRCOM=m
> CONFIG_USB_SERIAL_WWAN=m
> CONFIG_USB_SERIAL_OPTION=m
> CONFIG_USB_SERIAL_OMNINET=m
> CONFIG_USB_SERIAL_OPTICON=m
> CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
> # CONFIG_USB_SERIAL_XSENS_MT is not set
> CONFIG_USB_SERIAL_ZIO=m
> # CONFIG_USB_SERIAL_WISHBONE is not set
> CONFIG_USB_SERIAL_ZTE=m
> CONFIG_USB_SERIAL_SSU100=m
> CONFIG_USB_SERIAL_QT2=m
> CONFIG_USB_SERIAL_FLASHLOADER=m
> CONFIG_USB_SERIAL_DEBUG=m
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_EZUSB_FX2=m
> # CONFIG_USB_HSIC_USB3503 is not set
> # CONFIG_USB_PHY is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=m
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_LM3530 is not set
> # CONFIG_LEDS_LM3642 is not set
> # CONFIG_LEDS_PCA9532 is not set
> # CONFIG_LEDS_LP3944 is not set
> # CONFIG_LEDS_LP5521 is not set
> # CONFIG_LEDS_LP5523 is not set
> # CONFIG_LEDS_LP5562 is not set
> # CONFIG_LEDS_CLEVO_MAIL is not set
> # CONFIG_LEDS_PCA955X is not set
> # CONFIG_LEDS_PCA9633 is not set
> # CONFIG_LEDS_BD2802 is not set
> # CONFIG_LEDS_INTEL_SS4200 is not set
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> # CONFIG_LEDS_OT200 is not set
> # CONFIG_LEDS_BLINKM is not set
> 
> #
> # LED Triggers
> #
> # CONFIG_LEDS_TRIGGERS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_SYSTOHC=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> # CONFIG_RTC_DRV_ISL12022 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> # CONFIG_RTC_DRV_PCF2127 is not set
> # CONFIG_RTC_DRV_PCF8523 is not set
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> # CONFIG_RTC_DRV_M41T80 is not set
> # CONFIG_RTC_DRV_BQ32K is not set
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> # CONFIG_RTC_DRV_EM3027 is not set
> # CONFIG_RTC_DRV_RV3029C2 is not set
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> # CONFIG_RTC_DRV_DS2404 is not set
> 
> #
> # on-CPU RTC drivers
> #
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> # CONFIG_VIRT_DRIVERS is not set
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_STAGING is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_MAILBOX is not set
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> # CONFIG_IPACK_BUS is not set
> # CONFIG_RESET_CONTROLLER is not set
> # CONFIG_FMC is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> # CONFIG_EXT2_FS is not set
> # CONFIG_EXT3_FS is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_USE_FOR_EXT23=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=m
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> CONFIG_AUTOFS4_FS=m
> CONFIG_FUSE_FS=m
> CONFIG_CUSE=m
> CONFIG_GENERIC_ACL=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=m
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> # CONFIG_CACHEFILES is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> CONFIG_MSDOS_FS=m
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
> # CONFIG_MISC_FILESYSTEMS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V2=m
> CONFIG_NFS_V3=m
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=m
> # CONFIG_NFS_SWAP is not set
> CONFIG_NFS_V4_1=y
> CONFIG_NFS_V4_2=y
> CONFIG_PNFS_FILE_LAYOUT=m
> CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
> # CONFIG_NFS_FSCACHE is not set
> # CONFIG_NFS_USE_LEGACY_DNS is not set
> CONFIG_NFS_USE_KERNEL_DNS=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> CONFIG_SUNRPC_BACKCHANNEL=y
> # CONFIG_SUNRPC_DEBUG is not set
> # CONFIG_CEPH_FS is not set
> CONFIG_CIFS=m
> # CONFIG_CIFS_STATS is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_UPCALL=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_CIFS_ACL=y
> # CONFIG_CIFS_DEBUG is not set
> CONFIG_CIFS_DFS_UPCALL=y
> CONFIG_CIFS_SMB2=y
> # CONFIG_CIFS_FSCACHE is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="utf8"
> CONFIG_NLS_CODEPAGE_437=m
> # CONFIG_NLS_CODEPAGE_737 is not set
> CONFIG_NLS_CODEPAGE_775=m
> CONFIG_NLS_CODEPAGE_850=m
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> CONFIG_NLS_CODEPAGE_1250=m
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> CONFIG_NLS_ISO8859_13=m
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=m
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_MAC_ROMAN is not set
> # CONFIG_NLS_MAC_CELTIC is not set
> # CONFIG_NLS_MAC_CENTEURO is not set
> # CONFIG_NLS_MAC_CROATIAN is not set
> # CONFIG_NLS_MAC_CYRILLIC is not set
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> # CONFIG_NLS_MAC_ROMANIAN is not set
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=m
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> # CONFIG_PRINTK_TIME is not set
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> # CONFIG_FRAME_POINTER is not set
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_DEBUG_KERNEL is not set
> 
> #
> # Memory Debugging
> #
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_DEBUG_BUGVERBOSE=y
> 
> #
> # RCU Debugging
> #
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_TEST_STRING_HELPERS is not set
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_DEBUG_SET_MODULE_RONX=y
> CONFIG_DOUBLEFAULT=y
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> CONFIG_OPTIMIZE_INLINING=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_ENCRYPTED_KEYS is not set
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=m
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> CONFIG_CRYPTO_WORKQUEUE=y
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=m
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=m
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=m
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=m
> CONFIG_CRYPTO_HMAC=m
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> # CONFIG_CRYPTO_CRC32C_INTEL is not set
> # CONFIG_CRYPTO_CRC32 is not set
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> # CONFIG_CRYPTO_GHASH is not set
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> CONFIG_CRYPTO_SHA1=m
> CONFIG_CRYPTO_SHA256=m
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=m
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=m
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=m
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_586 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_586 is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> CONFIG_CRYPTO_ZLIB=m
> CONFIG_CRYPTO_LZO=m
> # CONFIG_CRYPTO_LZ4 is not set
> # CONFIG_CRYPTO_LZ4HC is not set
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> # CONFIG_CRYPTO_USER_API_HASH is not set
> # CONFIG_CRYPTO_USER_API_SKCIPHER is not set
> # CONFIG_CRYPTO_HW is not set
> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> # CONFIG_CRC_CCITT is not set
> CONFIG_CRC16=y
> # CONFIG_CRC_T10DIF is not set
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=m
> # CONFIG_CRC8 is not set
> CONFIG_ZLIB_INFLATE=m
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=m
> CONFIG_TEXTSEARCH_BM=m
> CONFIG_TEXTSEARCH_FSM=m
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> # CONFIG_CORDIC is not set
> # CONFIG_DDR is not set
> CONFIG_OID_REGISTRY=m
> CONFIG_FONT_SUPPORT=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> 
> 

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
