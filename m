Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3E0Mf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:35:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37132 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab3E0Mf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:35:26 -0400
Date: Mon, 27 May 2013 14:35:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.10-rc3: WARNING: at kernel/time/tick-broadcast.c:578
Message-ID: <20130527123520.GA4806@pd.tnic>
References: <alpine.SOC.1.00.1305271406050.2372@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1305271406050.2372@math.ut.ee>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 02:09:33PM +0300, Meelis Roos wrote:
> I enabled the new full dynctick on one of my test PCs - Intel 815 

Do you mean CONFIG_NO_HZ_FULL? If so, it is not enabled in the .config
below.

> chipset single-CPU P3 1 GHz. Got a warning from tick-broadcast.c:578 but 
> othwerise it seems to work so far. Full dmesg and config are below.

Also, there are a bunch of timers fixes from Thomas in tip - you could
try to merge tip/master ontop of -rc3 and retest.

Leaving in the rest for reference.

> [    0.000000] Linux version 3.10.0-rc3 (mroos@matrox) (gcc version 4.7.2 (Debian 4.7.2-5) ) #2 PREEMPT Mon May 27 10:22:34 EEST 2013
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001ffdffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000001ffe0000-0x000000001ffeffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000001fff0000-0x000000001fffffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
> [    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
> [    0.000000] Legacy DMI 2.3 present.
> [    0.000000] DMI: Packard Bell NEC 00000000000000000000000/i815                            , BIOS 2.0Q                             09/27/2001
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x1ffe0 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-C7FFF write-protect
> [    0.000000]   C8000-FFFFF uncachable
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask FE0000000 write-back
> [    0.000000]   1 base 020000000 mask FFFF80000 write-back
> [    0.000000]   2 base 020000000 mask FFFF80000 uncachable
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] PAT not supported by CPU.
> [    0.000000] original variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 512MB, type WB
> [    0.000000] reg 1, base: 512MB, range: 512KB, type WB
> [    0.000000] reg 2, base: 512MB, range: 512KB, type UC
> [    0.000000] total RAM covered: 512M
> [    0.000000] Found optimal setting for mtrr clean up
> [    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 1  	lose cover RAM: 0G
> [    0.000000] New variable MTRRs
> [    0.000000] reg 0, base: 0GB, range: 512MB, type WB
> [    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x1f800000-0x1fbfffff]
> [    0.000000]  [mem 0x1f800000-0x1fbfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x18000000-0x1f7fffff]
> [    0.000000]  [mem 0x18000000-0x1f7fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x17ffffff]
> [    0.000000]  [mem 0x00100000-0x003fffff] page 4k
> [    0.000000]  [mem 0x00400000-0x17ffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1ffdffff]
> [    0.000000]  [mem 0x1fc00000-0x1ffdffff] page 4k
> [    0.000000] BRK [0x01519000, 0x01519fff] PGTABLE
> [    0.000000] ACPI: RSDP 000fbe70 00014 (v00 AMI   )
> [    0.000000] ACPI: RSDT 1ffe0000 00028 (v01 AMIINT AMIINT10 00000011 MSFT 0100000C)
> [    0.000000] ACPI: FACP 1ffe0030 00074 (v01 AMIINT AMIINT10 00000011 MSFT 0100000C)
> [    0.000000] ACPI: DSDT 1ffe00b0 0317F (v01  INTEL   SOLANO 00001004 MSFT 0100000D)
> [    0.000000] ACPI: FACS 1ffe8000 00040
> [    0.000000] 511MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 1ffe0000
> [    0.000000]   low ram: 0 - 1ffe0000
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x1ffdffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x1ffdffff]
> [    0.000000] On node 0 totalpages: 130942
> [    0.000000] free_area_init_node: node 0, pgdat c1478120, node_mem_map dfbe0020
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 992 pages used for memmap
> [    0.000000]   Normal zone: 126944 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] Local APIC disabled by BIOS -- reenabling.
> [    0.000000] Found and enabled local APIC!
> [    0.000000] e820: [mem 0x20000000-0xfff7ffff] available for PCI devices
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129918
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.10.0-rc3 root=/dev/sda1 ro lapic
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Memory: 513920k/524160k available (3394k kernel code, 9848k reserved, 1201k data, 328k init, 0k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
> [    0.000000]     vmalloc : 0xe07e0000 - 0xfffe0000   ( 504 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xdffe0000   ( 511 MB)
> [    0.000000]       .init : 0xc147e000 - 0xc14d0000   ( 328 kB)
> [    0.000000]       .data : 0xc1350ba5 - 0xc147d1e0   (1201 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc1350ba5   (3394 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] NR_IRQS:16 nr_irqs:16 16
> [    0.000000] CPU 0 irqstacks, hard=df406000 soft=df408000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 1003.973 MHz processor
> [    0.008003] Calibrating delay loop (skipped), value calculated using timer frequency.. 2007.94 BogoMIPS (lpj=4015892)
> [    0.008114] pid_max: default: 32768 minimum: 301
> [    0.008231] Mount-cache hash table entries: 512
> [    0.008731] mce: CPU supports 5 MCE banks
> [    0.008830] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 2
> [    0.008830] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
> [    0.008830] tlb_flushall_shift: 6
> [    0.008964] CPU: Intel Pentium III (Coppermine) (fam: 06, model: 08, stepping: 0a)
> [    0.009155] ACPI: Core revision 20130328
> [    0.013169] ACPI: All ACPI Tables successfully acquired
> [    0.013255] ACPI: setting ELCR to 0200 (from 0a20)
> [    0.020080] Performance Events: p6 PMU driver.
> [    0.020160] ... version:                0
> [    0.020214] ... bit width:              32
> [    0.020267] ... generic registers:      2
> [    0.020321] ... value mask:             00000000ffffffff
> [    0.020377] ... max period:             000000007fffffff
> [    0.020432] ... fixed-purpose events:   0
> [    0.020484] ... event mask:             0000000000000003
> [    0.024000] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> [    0.024000] NET: Registered protocol family 16
> [    0.024000] ACPI: bus type PCI registered
> [    0.024000] PCI: PCI BIOS revision 2.10 entry at 0xfdb71, last bus=2
> [    0.024000] PCI: Using configuration type 1 for base access
> [    0.030032] bio: create slab <bio-0> at 0
> [    0.030424] ACPI: Added _OSI(Module Device)
> [    0.030486] ACPI: Added _OSI(Processor Device)
> [    0.030542] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.030598] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.031851] ACPI: EC: Look up EC in DSDT
> [    0.037978] ACPI: Interpreter enabled
> [    0.038058] ACPI: (supports S0 S5)
> [    0.038113] ACPI: Using PIC for interrupt routing
> [    0.038343] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [    0.046436] ACPI: Power Resource [URP1] (off)
> [    0.046636] ACPI: Power Resource [URP2] (off)
> [    0.046818] ACPI: Power Resource [FDDP] (off)
> [    0.047001] ACPI: Power Resource [LPTP] (off)
> [    0.053135] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.053772] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    0.053780] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    0.053788] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    0.053796] acpi PNP0A03:00: host bridge window [mem 0x000cb000-0x000dffff] (ignored)
> [    0.053803] acpi PNP0A03:00: host bridge window [mem 0x20000000-0xffdfffff] (ignored)
> [    0.053810] PCI: root bus 00: using default resources
> [    0.053820] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    0.054051] PCI host bridge to bus 0000:00
> [    0.054114] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.054175] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [    0.054235] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> [    0.054316] pci 0000:00:00.0: [8086:1130] type 00 class 0x060000
> [    0.054336] pci 0000:00:00.0: reg 10: [mem 0xe8000000-0xebffffff pref]
> [    0.054544] pci 0000:00:01.0: [8086:1131] type 01 class 0x060400
> [    0.054744] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060400
> [    0.054910] pci 0000:00:1f.0: [8086:2440] type 00 class 0x060100
> [    0.054991] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH4 ACPI/GPIO/TCO
> [    0.055094] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH4 GPIO
> [    0.055289] pci 0000:00:1f.1: [8086:244b] type 00 class 0x010180
> [    0.055342] pci 0000:00:1f.1: reg 20: [io  0xff00-0xff0f]
> [    0.055498] pci 0000:00:1f.2: [8086:2442] type 00 class 0x0c0300
> [    0.055551] pci 0000:00:1f.2: reg 20: [io  0xd000-0xd01f]
> [    0.055717] pci 0000:00:1f.3: [8086:2443] type 00 class 0x0c0500
> [    0.055771] pci 0000:00:1f.3: reg 20: [io  0x0540-0x054f]
> [    0.055936] pci 0000:00:1f.4: [8086:2444] type 00 class 0x0c0300
> [    0.055989] pci 0000:00:1f.4: reg 20: [io  0xd400-0xd41f]
> [    0.056225] pci 0000:00:1f.5: [8086:2445] type 00 class 0x040100
> [    0.056247] pci 0000:00:1f.5: reg 10: [io  0xdc00-0xdcff]
> [    0.056263] pci 0000:00:1f.5: reg 14: [io  0xd800-0xd83f]
> [    0.056543] pci 0000:01:00.0: [102b:2527] type 00 class 0x030000
> [    0.056569] pci 0000:01:00.0: reg 10: [mem 0xe4000000-0xe5ffffff pref]
> [    0.056583] pci 0000:01:00.0: reg 14: [mem 0xef9fc000-0xef9fffff]
> [    0.056597] pci 0000:01:00.0: reg 18: [mem 0xef000000-0xef7fffff]
> [    0.056629] pci 0000:01:00.0: reg 30: [mem 0xef9c0000-0xef9dffff pref]
> [    0.056780] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.056847] pci 0000:00:01.0:   bridge window [mem 0xee900000-0xef9fffff]
> [    0.056856] pci 0000:00:01.0:   bridge window [mem 0xe2600000-0xe66fffff pref]
> [    0.056965] pci 0000:02:01.0: [8086:1229] type 00 class 0x020000
> [    0.056989] pci 0000:02:01.0: reg 10: [mem 0xefeff000-0xefefffff]
> [    0.057004] pci 0000:02:01.0: reg 14: [io  0xac00-0xac3f]
> [    0.057019] pci 0000:02:01.0: reg 18: [mem 0xefd00000-0xefdfffff]
> [    0.057056] pci 0000:02:01.0: reg 30: [mem 0xfff00000-0xffffffff pref]
> [    0.057081] pci 0000:02:01.0: supports D1 D2
> [    0.057089] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.057234] pci 0000:00:1e.0: PCI bridge to [bus 02] (subtractive decode)
> [    0.057299] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
> [    0.057310] pci 0000:00:1e.0:   bridge window [mem 0xefa00000-0xefefffff]
> [    0.057319] pci 0000:00:1e.0:   bridge window [mem 0xe6700000-0xe67fffff pref]
> [    0.057327] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
> [    0.057335] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
> [    0.057354] pci_bus 0000:00: on NUMA node 0
> [    0.057362] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    0.059410] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> [    0.059783] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
> [    0.060191] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> [    0.060580] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> [    0.060947] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> [    0.061338] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
> [    0.061706] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> [    0.062095] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> [    0.062667] acpi root: \_SB_.PCI0 notify handler is installed
> [    0.062746] Found 1 acpi root devices
> [    0.062971] ACPI: No dock devices found.
> [    0.063272] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.063369] vgaarb: loaded
> [    0.063421] vgaarb: bridge control possible 0000:01:00.0
> [    0.063831] SCSI subsystem initialized
> [    0.063890] ACPI: bus type ATA registered
> [    0.064229] libata version 3.00 loaded.
> [    0.064544] PCI: Using ACPI for IRQ routing
> [    0.064608] PCI: pci_cache_line_size set to 32 bytes
> [    0.064663] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.064671] e820: reserve RAM buffer [mem 0x1ffe0000-0x1fffffff]
> [    0.065137] Switching to clocksource refined-jiffies
> [    0.065347] pnp: PnP ACPI init
> [    0.065419] ACPI: bus type PNP registered
> [    0.065811] pnp 00:00: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.065888] pnp 00:01: [dma 4]
> [    0.065990] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.066113] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.066225] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.066338] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.066542] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
> [    0.066785] pnp 00:06: [dma 2]
> [    0.066960] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.067689] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.068533] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.069492] pnp 00:09: [dma 3]
> [    0.069771] pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
> [    0.070344] pnp 00:0a: Plug and Play ACPI device, IDs PNPb02f (active)
> [    0.070954] pnp 00:0b: Plug and Play ACPI device, IDs PNPb006 (active)
> [    0.071454] pnp: PnP ACPI: found 12 devices
> [    0.071517] ACPI: bus type PNP unregistered
> [    0.112290] Switching to clocksource acpi_pm
> [    0.112391] pci 0000:02:01.0: address space collision: [mem 0xfff00000-0xffffffff pref] conflicts with reserved [mem 0xfff80000-0xffffffff]
> [    0.112525] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.112590] pci 0000:00:01.0:   bridge window [mem 0xee900000-0xef9fffff]
> [    0.112653] pci 0000:00:01.0:   bridge window [mem 0xe2600000-0xe66fffff pref]
> [    0.112761] pci 0000:02:01.0: BAR 6: assigned [mem 0xe6700000-0xe67fffff pref]
> [    0.112857] pci 0000:00:1e.0: PCI bridge to [bus 02]
> [    0.112917] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
> [    0.112982] pci 0000:00:1e.0:   bridge window [mem 0xefa00000-0xefefffff]
> [    0.113047] pci 0000:00:1e.0:   bridge window [mem 0xe6700000-0xe67fffff pref]
> [    0.113164] pci 0000:00:1e.0: setting latency timer to 64
> [    0.113175] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> [    0.113182] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
> [    0.113190] pci_bus 0000:01: resource 1 [mem 0xee900000-0xef9fffff]
> [    0.113198] pci_bus 0000:01: resource 2 [mem 0xe2600000-0xe66fffff pref]
> [    0.113205] pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
> [    0.113213] pci_bus 0000:02: resource 1 [mem 0xefa00000-0xefefffff]
> [    0.113220] pci_bus 0000:02: resource 2 [mem 0xe6700000-0xe67fffff pref]
> [    0.113227] pci_bus 0000:02: resource 4 [io  0x0000-0xffff]
> [    0.113234] pci_bus 0000:02: resource 5 [mem 0x00000000-0xffffffff]
> [    0.113315] NET: Registered protocol family 2
> [    0.113802] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.113950] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.114052] TCP: Hash tables configured (established 4096 bind 4096)
> [    0.114194] TCP: reno registered
> [    0.114249] UDP hash table entries: 256 (order: 0, 4096 bytes)
> [    0.114318] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
> [    0.114496] NET: Registered protocol family 1
> [    0.114985] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 9
> [    0.115048] PCI: setting IRQ 9 as level-triggered
> [    0.115345] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 9
> [    0.115491] pci 0000:01:00.0: Boot video device
> [    0.115529] pci 0000:02:01.0: Firmware left e100 interrupts enabled; disabling
> [    0.115628] PCI: CLS 32 bytes, default 32
> [    0.117000] msgmni has been set to 1003
> [    0.117585] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.117686] io scheduler noop registered
> [    0.117747] io scheduler cfq registered (default)
> [    0.118059] Serial: 8250/16550 driver, 16 ports, IRQ sharing disabled
> [    0.138666] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.159142] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    0.161126] Non-volatile memory driver v1.3
> [    0.161194] Linux agpgart interface v0.103
> [    0.161320] agpgart-intel 0000:00:00.0: Intel i815 Chipset
> [    0.165745] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xe8000000
> [    0.165917] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    0.166015] Hangcheck: Using getrawmonotonic().
> [    0.166413] Floppy drive(s): fd0 is 1.44M
> [    0.167423] ata_piix 0000:00:1f.1: version 2.13
> [    0.167564] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    0.168514] scsi0 : ata_piix
> [    0.169565] scsi1 : ata_piix
> [    0.171208] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
> [    0.171274] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
> [    0.171807] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> [    0.171868] e100: Copyright(c) 1999-2006 Intel Corporation
> [    0.172390] ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
> [    0.172452] PCI: setting IRQ 11 as level-triggered
> [    0.183510] FDC 0 is a post-1991 82077
> [    0.198166] e100 0000:02:01.0 eth0: addr 0xefeff000, irq 11, MAC addr 00:02:b3:09:1e:59
> [    0.198567] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    0.198627] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [    0.199750] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.200207] mousedev: PS/2 mouse device common for all mice
> [    0.200578] rtc_cmos 00:02: RTC can wake from S4
> [    0.200889] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    0.200975] rtc_cmos 00:02: alarms up to one month, 114 bytes nvram
> [    0.201117] cpuidle: using governor ladder
> [    0.201173] cpuidle: using governor menu
> [    0.201364] hidraw: raw HID events driver (C) Jiri Kosina
> [    0.202427] TCP: cubic registered
> [    0.202507] NET: Registered protocol family 10
> [    0.203087] NET: Registered protocol family 17
> [    0.203174] Key type dns_resolver registered
> [    0.203691] Using IPI Shortcut mode
> [    0.204566] console [netcon0] enabled
> [    0.204629] netconsole: network logging started
> [    0.204724] rtc_cmos 00:02: setting system clock to 2013-05-27 08:00:14 UTC (1369641614)
> [    0.225840] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [    0.324698] ata2.00: ATAPI: CDU5211, YYS2, max UDMA/33, CDB intr
> [    0.332626] ata2.00: configured for UDMA/33
> [    0.376561] ata1.00: ATA-7: ST380215A, 3.AAD, max UDMA/100
> [    0.376623] ata1.00: 156301488 sectors, multi 16: LBA48 
> [    0.443090] ata1.00: configured for UDMA/100
> [    0.443403] scsi 0:0:0:0: Direct-Access     ATA      ST380215A        3.AA PQ: 0 ANSI: 5
> [    0.444096] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
> [    0.444318] sd 0:0:0:0: [sda] Write Protect is off
> [    0.444378] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.444433] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.445729] scsi 1:0:0:0: CD-ROM            SONY     CDU5211          YYS2 PQ: 0 ANSI: 5
> [    0.513797]  sda: sda1 sda2 < sda5 >
> [    0.514719] sd 0:0:0:0: [sda] Attached SCSI disk
> [    0.537206] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
> [    0.537572] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
> [    0.566003] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [    0.566148] VFS: Mounted root (ext4 filesystem) readonly on device 259:524288.
> [    0.566301] Freeing unused kernel memory: 328k freed
> [    0.567459] Write protecting the kernel text: 3396k
> [    0.567576] Write protecting the kernel read-only data: 976k
> [    1.112044] tsc: Refined TSC clocksource calibration: 1003.901 MHz
> [    1.112129] Switching to clocksource tsc
> [    2.820085] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    2.820209] ACPI: Power Button [PWRB]
> [    2.820423] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
> [    2.820524] ACPI: Sleep Button [SLPB]
> [    2.820675] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> [    2.820773] ACPI: Power Button [PWRF]
> [    2.828199] tsc: Marking TSC unstable due to TSC halts in idle
> [    2.828383] ACPI: acpi_idle registered with cpuidle
> [    2.836115] Switching to clocksource acpi_pm
> [    2.858964] intel_rng: FWH not detected
> [    3.178623] input: PC Speaker as /devices/platform/pcspkr/input/input4
> [    3.182978] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
> [    3.183058] PCI: setting IRQ 5 as level-triggered
> [    3.264843] IT8712 SuperIO detected.
> [    3.265163] parport_pc 00:09: reported by Plug and Play ACPI
> [    3.265283] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
> [    3.301070] gameport gameport0: NS558 PnP Gameport is pnp00:0a/gameport0, io 0x201, speed 994kHz
> [    3.350001] sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
> [    3.350080] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    3.351571] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    3.397955] microcode: CPU0 sig=0x68a, pf=0x10, revision=0x1
> [    3.422718] ACPI: bus type USB registered
> [    3.423818] usbcore: registered new interface driver usbfs
> [    3.424379] usbcore: registered new interface driver hub
> [    3.424974] usbcore: registered new device driver usb
> [    3.445042] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.447507] uhci_hcd: USB Universal Host Controller Interface driver
> [    3.447788] uhci_hcd 0000:00:1f.2: setting latency timer to 64
> [    3.447798] uhci_hcd 0000:00:1f.2: UHCI Host Controller
> [    3.447877] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
> [    3.448086] uhci_hcd 0000:00:1f.2: irq 9, io base 0x0000d000
> [    3.448252] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.448316] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.448414] usb usb1: Product: UHCI Host Controller
> [    3.448471] usb usb1: Manufacturer: Linux 3.10.0-rc3 uhci_hcd
> [    3.448532] usb usb1: SerialNumber: 0000:00:1f.2
> [    3.449141] hub 1-0:1.0: USB hub found
> [    3.449213] hub 1-0:1.0: 2 ports detected
> [    3.449557] uhci_hcd 0000:00:1f.4: setting latency timer to 64
> [    3.449567] uhci_hcd 0000:00:1f.4: UHCI Host Controller
> [    3.449635] uhci_hcd 0000:00:1f.4: new USB bus registered, assigned bus number 2
> [    3.449765] uhci_hcd 0000:00:1f.4: irq 9, io base 0x0000d400
> [    3.449910] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    3.449972] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    3.450064] usb usb2: Product: UHCI Host Controller
> [    3.450119] usb usb2: Manufacturer: Linux 3.10.0-rc3 uhci_hcd
> [    3.450176] usb usb2: SerialNumber: 0000:00:1f.4
> [    3.450656] hub 2-0:1.0: USB hub found
> [    3.450727] hub 2-0:1.0: 2 ports detected
> [    3.582761] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.582886] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    3.812397] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    3.872061] ------------[ cut here ]------------
> [    3.872161] WARNING: at kernel/time/tick-broadcast.c:578 tick_broadcast_oneshot_control+0x181/0x190()
> [    3.872258] Modules linked in: ac97_bus snd_pcm snd_page_alloc sg snd_seq uhci_hcd ehci_hcd usbcore microcode snd_seq_device sr_mod snd_timer parport_pc ns558 cdrom snd parport usb_common evdev i2c_i801 gameport pcspkr soundcore rng_core processor button
> [    3.872726] CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0-rc3 #2
> [    3.872785] Hardware name: Packard Bell NEC 00000000000000000000000/i815                            , BIOS 2.0Q                             09/27/2001
> [    3.872892]  00000000 00000000 c1447e74 c134c98c c1447e9c c102877f c13e47ea c13e58c8
> [    3.873063]  00000242 c1059aa1 c1059aa1 00200002 c14716a0 c145ce00 c1447eac c10287bb
> [    3.873234]  00000009 00000000 c1447ecc c1059aa1 00000001 00200046 c14524c0 00000004
> [    3.873405] Call Trace:
> [    3.873467]  [<c134c98c>] dump_stack+0x16/0x18
> [    3.873527]  [<c102877f>] warn_slowpath_common+0x5f/0x80
> [    3.873588]  [<c1059aa1>] ? tick_broadcast_oneshot_control+0x181/0x190
> [    3.873650]  [<c1059aa1>] ? tick_broadcast_oneshot_control+0x181/0x190
> [    3.873713]  [<c10287bb>] warn_slowpath_null+0x1b/0x20
> [    3.873772]  [<c1059aa1>] tick_broadcast_oneshot_control+0x181/0x190
> [    3.873835]  [<c1059167>] tick_notify+0x287/0x3b0
> [    3.873903]  [<c10499d0>] notifier_call_chain+0x40/0x60
> [    3.873965]  [<c1049a89>] __raw_notifier_call_chain+0x19/0x20
> [    3.874027]  [<c1049aaa>] raw_notifier_call_chain+0x1a/0x20
> [    3.874089]  [<c105852a>] clockevents_notify+0x2a/0x120
> [    3.874158]  [<c1270414>] ? menu_select+0x274/0x5d0
> [    3.874227]  [<e0807523>] lapic_timer_state_broadcast+0x2e/0x31 [processor]
> [    3.874293]  [<e08075d6>] acpi_idle_enter_simple+0x4a/0xb0 [processor]
> [    3.874357]  [<c126ed85>] cpuidle_enter_state+0x35/0xc0
> [    3.874420]  [<c126ee8c>] cpuidle_idle_call+0x7c/0x130
> [    3.874488]  [<c10085c8>] arch_cpu_idle+0x8/0x20
> [    3.874557]  [<c1051599>] cpu_startup_entry+0x49/0x100
> [    3.874625]  [<c1347b98>] rest_init+0x68/0x70
> [    3.874691]  [<c147e9e1>] start_kernel+0x2b4/0x2ba
> [    3.874751]  [<c147e562>] ? repair_env_string+0x51/0x51
> [    3.874812]  [<c147e3a6>] i386_start_kernel+0x15c/0x15f
> [    3.874869] ---[ end trace 04f82d195c58c7d9 ]---
> [    4.096835] snd_intel8x0 0000:00:1f.5: setting latency timer to 64
> [    4.420050] intel8x0_measure_ac97_clock: measured 55997 usecs (2690 samples)
> [    4.420131] intel8x0: clocking to 48000
> [    5.491480] Adding 1005564k swap on /dev/sda5.  Priority:-1 extents:1 across:1005564k 
> [    5.535389] EXT4-fs (sda1): re-mounted. Opts: (null)
> [    5.914900] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
> [    6.321727] loop: module loaded
> [    6.400593] it87: Found IT8712F chip at 0x290, revision 4
> [    6.401421] ACPI Warning: 0x00000295-0x00000296 SystemIO conflicts with Region \HWMI 1 (20130328/utaddress-251)
> [    6.401563] ACPI Warning: 0x00000295-0x00000296 SystemIO conflicts with Region \_TZ_.I712 2 (20130328/utaddress-251)
> [    6.401687] ACPI Warning: 0x00000295-0x00000296 SystemIO conflicts with Region \_SB_.PCI0.SBRG.HWMT 3 (20130328/utaddress-251)
> [    6.401812] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   10.052236] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   10.056344] e100 0000:02:01.0 eth0: NIC Link is Up 100 Mbps Full Duplex
> [   10.056611] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> 
> 
> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86 3.10.0-rc3 Kernel Configuration
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
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
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
> # CONFIG_TREE_PREEMPT_RCU is not set
> CONFIG_TINY_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> # CONFIG_RCU_STALL_COMMON is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_BOOST is not set
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
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HOTPLUG=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
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
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
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
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
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
> # CONFIG_ACORN_PARTITION is not set
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
> CONFIG_SYSV68_PARTITION=y
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
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> # CONFIG_X86_MPPARSE is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_GOLDFISH is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
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
> CONFIG_MPENTIUMIII=y
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
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
> CONFIG_X86_INTERNODE_CACHE_SHIFT=5
> CONFIG_X86_L1_CACHE_SHIFT=5
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
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_UP_APIC=y
> # CONFIG_X86_UP_IOAPIC is not set
> CONFIG_X86_LOCAL_APIC=y
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
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> CONFIG_NOHIGHMEM=y
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> # CONFIG_X86_PAE is not set
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_COMPACTION is not set
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_MEMORY_FAILURE is not set
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_FRONTSWAP is not set
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
> CONFIG_PHYSICAL_ALIGN=0x100000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> # CONFIG_ACPI_PROC_EVENT is not set
> CONFIG_ACPI_AC=m
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_I2C=y
> CONFIG_ACPI_PROCESSOR=m
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> # CONFIG_ACPI_THERMAL is not set
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
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
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
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
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> # CONFIG_PACKET_DIAG is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=m
> # CONFIG_XFRM_USER is not set
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_XFRM_IPCOMP=m
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
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
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_INET_UDP_DIAG is not set
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> CONFIG_IPV6_OPTIMISTIC_DAD=y
> # CONFIG_INET6_AH is not set
> # CONFIG_INET6_ESP is not set
> CONFIG_INET6_IPCOMP=m
> CONFIG_IPV6_MIP6=m
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> # CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
> # CONFIG_INET6_XFRM_MODE_TUNNEL is not set
> # CONFIG_INET6_XFRM_MODE_BEET is not set
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
> # CONFIG_NETFILTER is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> CONFIG_STP=m
> CONFIG_GARP=m
> CONFIG_MRP=m
> # CONFIG_BRIDGE is not set
> CONFIG_HAVE_NET_DSA=y
> CONFIG_VLAN_8021Q=m
> CONFIG_VLAN_8021Q_GVRP=y
> CONFIG_VLAN_8021Q_MVRP=y
> # CONFIG_DECNET is not set
> CONFIG_LLC=m
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
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> # CONFIG_DEVTMPFS is not set
> # CONFIG_STANDALONE is not set
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
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
> CONFIG_BLK_DEV_FD=y
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
> # CONFIG_INTEL_MID_PTI is not set
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
> CONFIG_EEPROM_93CX6=m
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
> # CONFIG_INTEL_MEI is not set
> # CONFIG_INTEL_MEI_ME is not set
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
> # CONFIG_CHR_DEV_SCH is not set
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
> # CONFIG_SATA_PMP is not set
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> CONFIG_SATA_SIL24=m
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
> CONFIG_PATA_CMD64X=m
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> CONFIG_PATA_HPT366=m
> CONFIG_PATA_HPT37X=m
> CONFIG_PATA_HPT3X2N=m
> CONFIG_PATA_HPT3X3=m
> CONFIG_PATA_HPT3X3_DMA=y
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
> CONFIG_PATA_SIL680=m
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
> CONFIG_FIREWIRE=m
> CONFIG_FIREWIRE_OHCI=m
> CONFIG_FIREWIRE_SBP2=m
> CONFIG_FIREWIRE_NET=m
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> # CONFIG_BONDING is not set
> # CONFIG_DUMMY is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_NET_FC is not set
> CONFIG_MII=y
> # CONFIG_NET_TEAM is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_VXLAN is not set
> CONFIG_NETCONSOLE=y
> CONFIG_NETCONSOLE_DYNAMIC=y
> CONFIG_NETPOLL=y
> CONFIG_NETPOLL_TRAP=y
> CONFIG_NET_POLL_CONTROLLER=y
> CONFIG_TUN=m
> # CONFIG_VETH is not set
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
> CONFIG_TYPHOON=m
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> # CONFIG_NET_VENDOR_ALTEON is not set
> # CONFIG_NET_VENDOR_AMD is not set
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
> CONFIG_ULI526X=m
> # CONFIG_NET_VENDOR_DLINK is not set
> # CONFIG_NET_VENDOR_EMULEX is not set
> # CONFIG_NET_VENDOR_EXAR is not set
> # CONFIG_NET_VENDOR_HP is not set
> CONFIG_NET_VENDOR_INTEL=y
> CONFIG_E100=y
> CONFIG_E1000=m
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
> CONFIG_PHYLIB=m
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_AT803X_PHY is not set
> # CONFIG_AMD_PHY is not set
> # CONFIG_MARVELL_PHY is not set
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> # CONFIG_LXT_PHY is not set
> # CONFIG_CICADA_PHY is not set
> # CONFIG_VITESSE_PHY is not set
> # CONFIG_SMSC_PHY is not set
> # CONFIG_BROADCOM_PHY is not set
> # CONFIG_BCM87XX_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> # CONFIG_NATIONAL_PHY is not set
> # CONFIG_STE10XP is not set
> # CONFIG_LSI_ET1011C_PHY is not set
> # CONFIG_MICREL_PHY is not set
> # CONFIG_MDIO_BITBANG is not set
> # CONFIG_PLIP is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> 
> #
> # USB Network Adapters
> #
> CONFIG_USB_CATC=m
> CONFIG_USB_KAWETH=m
> CONFIG_USB_PEGASUS=m
> CONFIG_USB_RTL8150=m
> CONFIG_USB_RTL8152=m
> CONFIG_USB_USBNET=m
> CONFIG_USB_NET_AX8817X=m
> CONFIG_USB_NET_AX88179_178A=m
> CONFIG_USB_NET_CDCETHER=m
> CONFIG_USB_NET_CDC_EEM=m
> CONFIG_USB_NET_CDC_NCM=m
> CONFIG_USB_NET_CDC_MBIM=m
> CONFIG_USB_NET_DM9601=m
> CONFIG_USB_NET_SMSC75XX=m
> CONFIG_USB_NET_SMSC95XX=m
> CONFIG_USB_NET_GL620A=m
> CONFIG_USB_NET_NET1080=m
> CONFIG_USB_NET_PLUSB=m
> CONFIG_USB_NET_MCS7830=m
> CONFIG_USB_NET_RNDIS_HOST=m
> CONFIG_USB_NET_CDC_SUBSET=m
> CONFIG_USB_ALI_M5632=y
> CONFIG_USB_AN2720=y
> CONFIG_USB_BELKIN=y
> CONFIG_USB_ARMLINUX=y
> CONFIG_USB_EPSON2888=y
> CONFIG_USB_KC2190=y
> CONFIG_USB_NET_ZAURUS=m
> CONFIG_USB_NET_CX82310_ETH=m
> CONFIG_USB_NET_KALMIA=m
> CONFIG_USB_NET_QMI_WWAN=m
> CONFIG_USB_NET_INT51X1=m
> CONFIG_USB_IPHETH=m
> CONFIG_USB_SIERRA_NET=m
> CONFIG_USB_VL600=m
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
> CONFIG_INPUT_FF_MEMLESS=y
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
> CONFIG_INPUT_JOYDEV=m
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
> CONFIG_MOUSE_PS2=y
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
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
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
> CONFIG_SERIAL_8250_NR_UARTS=16
> CONFIG_SERIAL_8250_RUNTIME_UARTS=16
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
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
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
> CONFIG_I2C_PIIX4=m
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
> # CONFIG_I2C_INTEL_MID is not set
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
> 
> #
> # Qualcomm MSM SSBI bus support
> #
> # CONFIG_SSBI is not set
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
> CONFIG_HWMON=m
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
> # CONFIG_SENSORS_ADM1025 is not set
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
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_HIH6130 is not set
> # CONFIG_SENSORS_CORETEMP is not set
> CONFIG_SENSORS_IT87=m
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
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_SCH5627 is not set
> # CONFIG_SENSORS_SCH5636 is not set
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
> CONFIG_THERMAL=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=m
> # CONFIG_ACQUIRE_WDT is not set
> # CONFIG_ADVANTECH_WDT is not set
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> # CONFIG_F71808E_WDT is not set
> # CONFIG_SP5100_TCO is not set
> # CONFIG_SC520_WDT is not set
> # CONFIG_SBC_FITPC2_WATCHDOG is not set
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> # CONFIG_IBMASR is not set
> # CONFIG_WAFER_WDT is not set
> # CONFIG_I6300ESB_WDT is not set
> # CONFIG_IE6XX_WDT is not set
> # CONFIG_ITCO_WDT is not set
> # CONFIG_IT8712F_WDT is not set
> # CONFIG_IT87_WDT is not set
> # CONFIG_HP_WATCHDOG is not set
> # CONFIG_SC1200_WDT is not set
> # CONFIG_PC87413_WDT is not set
> # CONFIG_NV_TCO is not set
> # CONFIG_60XX_WDT is not set
> # CONFIG_SBC8360_WDT is not set
> # CONFIG_SBC7240_WDT is not set
> # CONFIG_CPU5_WDT is not set
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> # CONFIG_VIA_WDT is not set
> # CONFIG_W83627HF_WDT is not set
> # CONFIG_W83697HF_WDT is not set
> # CONFIG_W83697UG_WDT is not set
> # CONFIG_W83877F_WDT is not set
> # CONFIG_W83977F_WDT is not set
> # CONFIG_MACHZ_WDT is not set
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> 
> #
> # USB-based Watchdog Cards
> #
> # CONFIG_USBPCWATCHDOG is not set
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
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_CS5535 is not set
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_DA9052_I2C is not set
> # CONFIG_MFD_DA9055 is not set
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_88PM800 is not set
> # CONFIG_MFD_88PM805 is not set
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX8907 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> # CONFIG_MFD_VIPERBOARD is not set
> # CONFIG_MFD_RETU is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_SI476X_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_MFD_SMSC is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_STMPE is not set
> # CONFIG_MFD_SYSCON is not set
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> # CONFIG_MFD_LP8788 is not set
> # CONFIG_MFD_PALMAS is not set
> # CONFIG_TPS6105X is not set
> # CONFIG_TPS6507X is not set
> # CONFIG_MFD_TPS65090 is not set
> # CONFIG_MFD_TPS65217 is not set
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS80031 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> # CONFIG_MFD_WL1273_CORE is not set
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> # CONFIG_MFD_ARIZONA_I2C is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> # CONFIG_REGULATOR is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> # CONFIG_AGP_AMD64 is not set
> CONFIG_AGP_INTEL=y
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
> # CONFIG_DRM_TDFX is not set
> CONFIG_DRM_R128=m
> CONFIG_DRM_RADEON=m
> # CONFIG_DRM_RADEON_UMS is not set
> CONFIG_DRM_NOUVEAU=m
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> # CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
> # CONFIG_DRM_I915 is not set
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
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
> # CONFIG_FB_MODE_HELPERS is not set
> CONFIG_FB_TILEBLITTING=y
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
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_I810 is not set
> # CONFIG_FB_LE80578 is not set
> CONFIG_FB_MATROX=m
> CONFIG_FB_MATROX_MILLENIUM=y
> CONFIG_FB_MATROX_MYSTIQUE=y
> CONFIG_FB_MATROX_G=y
> CONFIG_FB_MATROX_I2C=m
> CONFIG_FB_MATROX_MAVEN=m
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
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> # CONFIG_BACKLIGHT_GENERIC is not set
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
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_LOGO is not set
> CONFIG_SOUND=m
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
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
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=m
> CONFIG_SND_OPL3_LIB_SEQ=m
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> CONFIG_SND_EMU10K1_SEQ=m
> CONFIG_SND_MPU401_UART=m
> CONFIG_SND_OPL3_LIB=m
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_PCSP=m
> # CONFIG_SND_DUMMY is not set
> CONFIG_SND_ALOOP=m
> # CONFIG_SND_VIRMIDI is not set
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
> CONFIG_SND_BT87X=m
> CONFIG_SND_BT87X_OVERCLOCK=y
> CONFIG_SND_CA0106=m
> CONFIG_SND_CMIPCI=m
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
> CONFIG_SND_EMU10K1=m
> CONFIG_SND_EMU10K1X=m
> CONFIG_SND_ENS1370=m
> CONFIG_SND_ENS1371=m
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
> # CONFIG_SND_FIREWIRE is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=m
> 
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> CONFIG_HIDRAW=y
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=m
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> # CONFIG_HID_ACRUX is not set
> CONFIG_HID_APPLE=y
> # CONFIG_HID_APPLEIR is not set
> # CONFIG_HID_AUREAL is not set
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> # CONFIG_HID_PRODIKEYS is not set
> CONFIG_HID_CYPRESS=y
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_ELECOM is not set
> CONFIG_HID_EZKEY=y
> # CONFIG_HID_HOLTEK is not set
> # CONFIG_HID_KEYTOUCH is not set
> CONFIG_HID_KYE=m
> # CONFIG_HID_UCLOGIC is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=y
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=y
> CONFIG_HID_LOGITECH_DJ=m
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> # CONFIG_LOGIG940_FF is not set
> CONFIG_LOGIWHEELS_FF=y
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_PS3REMOTE is not set
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
> # CONFIG_HID_THRUSTMASTER is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> # CONFIG_HID_SENSOR_HUB is not set
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
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_ARCH_HAS_XHCI=y
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
> CONFIG_USB_OHCI_HCD=m
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
> CONFIG_USB_SERIAL_KEYSPAN_MPR=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
> CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19=y
> CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
> CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
> CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
> CONFIG_USB_SERIAL_KLSI=m
> CONFIG_USB_SERIAL_KOBIL_SCT=m
> CONFIG_USB_SERIAL_MCT_U232=m
> CONFIG_USB_SERIAL_METRO=m
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
> CONFIG_USB_SERIAL_XSENS_MT=m
> CONFIG_USB_SERIAL_ZIO=m
> # CONFIG_USB_SERIAL_WISHBONE is not set
> CONFIG_USB_SERIAL_ZTE=m
> CONFIG_USB_SERIAL_SSU100=m
> CONFIG_USB_SERIAL_QT2=m
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
> # CONFIG_NEW_LEDS is not set
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
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_CHROMEOS_LAPTOP is not set
> # CONFIG_DELL_WMI is not set
> # CONFIG_DELL_WMI_AIO is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_TC1100_WMI is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WMI is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> CONFIG_ACPI_WMI=m
> # CONFIG_MSI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_ACPI_TOSHIBA is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> CONFIG_MXM_WMI=m
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_PVPANIC is not set
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
> CONFIG_DMI_SYSFS=m
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
> # CONFIG_OCFS2_FS is not set
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
> CONFIG_FAT_DEFAULT_CODEPAGE=775
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
> CONFIG_CONFIGFS_FS=y
> # CONFIG_MISC_FILESYSTEMS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V2=m
> CONFIG_NFS_V3=m
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=m
> # CONFIG_NFS_SWAP is not set
> CONFIG_NFS_V4_1=y
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
> # CONFIG_NFSD_FAULT_INJECTION is not set
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
> CONFIG_NLS_CODEPAGE_866=m
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=m
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
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
> # CONFIG_DLM is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> # CONFIG_SCHED_DEBUG is not set
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_DEBUG_SLAB is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_PREEMPT is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_LIST=y
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU_DELAY is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_DEBUG_BLOCK_EXT_DEVT=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_LKDTM is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
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
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> # CONFIG_TEST_STRING_HELPERS is not set
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_DEBUG_SET_MODULE_RONX=y
> # CONFIG_DEBUG_NX_TEST is not set
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> CONFIG_IO_DELAY_NONE=y
> CONFIG_DEFAULT_IO_DELAY_TYPE=3
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
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
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
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
> CONFIG_CRYPTO_CBC=y
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
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=y
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
> CONFIG_CRYPTO_DES=y
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
> # CONFIG_CRYPTO_ZLIB is not set
> # CONFIG_CRYPTO_LZO is not set
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
> # CONFIG_LIBCRC32C is not set
> # CONFIG_CRC8 is not set
> CONFIG_ZLIB_INFLATE=m
> CONFIG_ZLIB_DEFLATE=m
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
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
> 
> -- 
> Meelis Roos (mroos@linux.ee)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
