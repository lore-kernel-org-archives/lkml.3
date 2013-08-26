Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3HZNOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:14:14 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:36305 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3HZNOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:14:12 -0400
Date: Mon, 26 Aug 2013 16:14:05 +0300 (EEST)
From: Meelis Roos <mroos@ut.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: i915 pipe A assertion failure (expected on, current off)
Message-ID: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried 3.11-rc7 on Thinkpad X30 (first 3-11-rc tried on this hw). Works 
but i915 gives strange assertion failure with WARNING stack trace. This 
is new since 3.10.

The only monitor is internal LCD. lspci -vvvnn is also below.

[    0.000000] Linux version 3.11.0-rc7 (mroos@x30) (gcc version 4.8.1 (Debian 4.8.1-5) ) #4 Mon Aug 26 11:42:19 EEST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001f76ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f770000-0x000000001f77dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000001f77e000-0x000000001f77ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000001f780000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: IBM 26724XG/26724XG, BIOS 1KET48WW (1.09 ) 06/16/2006
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x1f770 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FE0000000 write-back
[    0.000000]   1 base 01FF80000 mask FFFF80000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 512MB, type WB
[    0.000000] reg 1, base: 523776KB, range: 512KB, type UC
[    0.000000] total RAM covered: 511M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 2  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 512MB, type WB
[    0.000000] reg 1, base: 523776KB, range: 512KB, type UC
[    0.000000] initial memory mapped: [mem 0x00000000-0x017fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x1f000000-0x1f3fffff]
[    0.000000]  [mem 0x1f000000-0x1f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x18000000-0x1effffff]
[    0.000000]  [mem 0x18000000-0x1effffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x17ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x17ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x1f400000-0x1f76ffff]
[    0.000000]  [mem 0x1f400000-0x1f76ffff] page 4k
[    0.000000] BRK [0x014da000, 0x014dafff] PGTABLE
[    0.000000] ACPI: RSDP 000f7090 00024 (v02 IBM   )
[    0.000000] ACPI: XSDT 1f772a76 0004C (v01 IBM    TP-1K    00001090  LTP 00000000)
[    0.000000] ACPI: FACP 1f772b00 00081 (v01 IBM    TP-1K    00001090 IBM  00000001)
[    0.000000] ACPI: DSDT 1f772be7 0B22C (v01 IBM    TP-1K    00001090 MSFT 0100000D)
[    0.000000] ACPI: FACS 1f77f000 00040
[    0.000000] ACPI: SSDT 1f772bb4 00033 (v01 IBM    TP-1K    00001090 MSFT 0100000D)
[    0.000000] ACPI: ECDT 1f77de13 00052 (v01 IBM    TP-1K    00001090 IBM  00000001)
[    0.000000] ACPI: TCPA 1f77de65 00032 (v01 IBM    TP-1K    00001090 PTL  00000001)
[    0.000000] ACPI: BOOT 1f77dfd8 00028 (v01 IBM    TP-1K    00001090  LTP 00000001)
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f770000
[    0.000000]   low ram: 0 - 1f770000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x1f76ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1f76ffff]
[    0.000000] On node 0 totalpages: 128782
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 124784 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
[    0.000000] e820: [mem 0x20000000-0xff7fffff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127775
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0-rc7 root=/dev/sda1 ro lapic
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 505532K/515128K available (3143K kernel code, 231K rwdata, 920K rodata, 316K init, 320K bss, 9596K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     vmalloc : 0xdff70000 - 0xfffa0000   ( 512 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf770000   ( 503 MB)
[    0.000000]       .init : 0xc1434000 - 0xc1483000   ( 316 kB)
[    0.000000]       .data : 0xc1312179 - 0xc1433c00   (1158 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1312179   (3144 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=dec06000 soft=dec08000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1196.090 MHz processor
[    0.008005] Calibrating delay loop (skipped), value calculated using timer frequency.. 2392.18 BogoMIPS (lpj=4784360)
[    0.008146] pid_max: default: 32768 minimum: 301
[    0.008320] Mount-cache hash table entries: 512
[    0.012344] mce: CPU supports 5 MCE banks
[    0.012465] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 2
[    0.012465] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
[    0.012465] tlb_flushall_shift: 6
[    0.012635] CPU: Mobile Intel(R) Pentium(R) III CPU - M  1200MHz (fam: 06, model: 0b, stepping: 04)
[    0.012852] ACPI: Core revision 20130517
[    0.022371] ACPI: All ACPI Tables successfully acquired
[    0.022765] ACPI: setting ELCR to 0200 (from 0820)
[    0.024201] Performance Events: p6 PMU driver.
[    0.028011] ... version:                0
[    0.028331] ... bit width:              32
[    0.028650] ... generic registers:      2
[    0.028960] ... value mask:             00000000ffffffff
[    0.029291] ... max period:             000000007fffffff
[    0.029612] ... fixed-purpose events:   0
[    0.029931] ... event mask:             0000000000000003
[    0.030548] Enabling APIC mode:  Flat.  Using 0 I/O APICs
[    0.032000] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.032000] devtmpfs: initialized
[    0.032000] PM: Registering ACPI NVS region [mem 0x1f77e000-0x1f77ffff] (8192 bytes)
[    0.032000] NET: Registered protocol family 16
[    0.032000] ACPI: bus type PCI registered
[    0.032000] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.032000] PCI: PCI BIOS revision 2.10 entry at 0xfd90e, last bus=7
[    0.032000] PCI: Using configuration type 1 for base access
[    0.032000] bio: create slab <bio-0> at 0
[    0.032000] ACPI: Added _OSI(Module Device)
[    0.032000] ACPI: Added _OSI(Processor Device)
[    0.032000] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.032000] ACPI: Added _OSI(Processor Aggregator Device)
[    0.033425] ACPI: EC: EC description table is found, configuring boot EC
[    0.044785] ACPI: Interpreter enabled
[    0.044785] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130517/hwxface-571)
[    0.044858] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130517/hwxface-571)
[    0.045037] ACPI: (supports S0 S3 S4 S5)
[    0.045106] ACPI: Using PIC for interrupt routing
[    0.045210] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.049355] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.056823] ACPI: Power Resource [PUBS] (on)
[    0.064378] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.064879] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11)
[    0.065373] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.065866] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.066630] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.067335] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.068187] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.069217] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.070150] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.070569] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.070576] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.070582] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.070589] acpi PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
[    0.070596] acpi PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.070602] acpi PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.070609] acpi PNP0A03:00: host bridge window [mem 0x20000000-0xfebfffff] (ignored)
[    0.070615] PCI: root bus 00: using default resources
[    0.070624] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.071398] PCI host bridge to bus 0000:00
[    0.071723] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.072006] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.072349] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.072715] pci 0000:00:00.0: [8086:3575] type 00 class 0x060000
[    0.072870] pci 0000:00:02.0: [8086:3577] type 00 class 0x030000
[    0.072886] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe7ffffff pref]
[    0.072897] pci 0000:00:02.0: reg 0x14: [mem 0xd0000000-0xd007ffff]
[    0.072932] pci 0000:00:02.0: supports D1
[    0.073044] pci 0000:00:02.1: [8086:3577] type 00 class 0x038000
[    0.073058] pci 0000:00:02.1: reg 0x10: [mem 0xe8000000-0xefffffff pref]
[    0.073067] pci 0000:00:02.1: reg 0x14: [mem 0xd0080000-0xd00fffff]
[    0.073100] pci 0000:00:02.1: supports D1
[    0.073229] pci 0000:00:1d.0: [8086:2482] type 00 class 0x0c0300
[    0.073270] pci 0000:00:1d.0: reg 0x20: [io  0x1800-0x181f]
[    0.073453] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.073453] pci 0000:00:1d.1: [8086:2484] type 00 class 0x0c0300
[    0.073453] pci 0000:00:1d.1: reg 0x20: [io  0x1820-0x183f]
[    0.073453] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.073453] pci 0000:00:1d.2: [8086:2487] type 00 class 0x0c0300
[    0.073453] pci 0000:00:1d.2: reg 0x20: [io  0x1840-0x185f]
[    0.073453] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.073453] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060400
[    0.073453] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.073453] pci 0000:00:1f.0: [8086:248c] type 00 class 0x060100
[    0.073453] pci 0000:00:1f.0: address space collision: [io  0x1000-0x107f] conflicts with ACPI CPU throttle [??? 0x00001010-0x00001015 flags 0x80000000]
[    0.073453] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH4 GPIO
[    0.073453] pci 0000:00:1f.1: [8086:248a] type 00 class 0x01018a
[    0.073453] pci 0000:00:1f.1: reg 0x10: [io  0x01f0-0x01f7]
[    0.073453] pci 0000:00:1f.1: reg 0x14: [io  0x03f4-0x03f7]
[    0.073453] pci 0000:00:1f.1: reg 0x18: [io  0x0170-0x0177]
[    0.073453] pci 0000:00:1f.1: reg 0x1c: [io  0x0374-0x0377]
[    0.073453] pci 0000:00:1f.1: reg 0x20: [io  0x1860-0x186f]
[    0.073453] pci 0000:00:1f.1: reg 0x24: [mem 0x00000000-0x000003ff]
[    0.073564] pci 0000:00:1f.3: [8086:2483] type 00 class 0x0c0500
[    0.073605] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
[    0.073722] pci 0000:00:1f.5: [8086:2485] type 00 class 0x040100
[    0.073739] pci 0000:00:1f.5: reg 0x10: [io  0x1c00-0x1cff]
[    0.073752] pci 0000:00:1f.5: reg 0x14: [io  0x18c0-0x18ff]
[    0.076052] pci 0000:00:1f.6: [8086:2486] type 00 class 0x070300
[    0.076069] pci 0000:00:1f.6: reg 0x10: [io  0x2400-0x24ff]
[    0.076082] pci 0000:00:1f.6: reg 0x14: [io  0x2000-0x207f]
[    0.076183] pci 0000:00:1f.6: System wakeup disabled by ACPI
[    0.076438] acpiphp: Slot [1] registered
[    0.076528] pci 0000:01:00.0: [1180:0476] type 02 class 0x060700
[    0.076546] pci 0000:01:00.0: reg 0x10: [mem 0x50000000-0x50000fff]
[    0.076572] pci 0000:01:00.0: supports D1 D2
[    0.076578] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.076695] pci 0000:01:00.1: [1180:0476] type 02 class 0x060700
[    0.076714] pci 0000:01:00.1: reg 0x10: [mem 0x50100000-0x50100fff]
[    0.076740] pci 0000:01:00.1: supports D1 D2
[    0.076746] pci 0000:01:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.076842] pci 0000:01:00.2: [1180:0552] type 00 class 0x0c0010
[    0.076860] pci 0000:01:00.2: reg 0x10: [mem 0xd0205000-0xd02057ff]
[    0.076919] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    0.077024] pci 0000:01:02.0: [14b9:a504] type 00 class 0x028000
[    0.077043] pci 0000:01:02.0: reg 0x10: [io  0x7000-0x70ff]
[    0.077055] pci 0000:01:02.0: reg 0x14: [mem 0xd0200000-0xd0203fff]
[    0.077067] pci 0000:01:02.0: reg 0x18: [mem 0xd0400000-0xd07fffff]
[    0.077095] pci 0000:01:02.0: reg 0x30: [mem 0x00000000-0x001fffff pref]
[    0.077125] pci 0000:01:02.0: supports D1 D2
[    0.077210] pci 0000:01:08.0: [8086:1031] type 00 class 0x020000
[    0.077228] pci 0000:01:08.0: reg 0x10: [mem 0xd0204000-0xd0204fff]
[    0.077240] pci 0000:01:08.0: reg 0x14: [io  0x7400-0x743f]
[    0.077292] pci 0000:01:08.0: supports D1 D2
[    0.077297] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.077404] pci 0000:00:1e.0: PCI bridge to [bus 01-07] (subtractive decode)
[    0.077483] pci 0000:00:1e.0:   bridge window [io  0x3000-0x7fff]
[    0.077491] pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xdfffffff]
[    0.077500] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff pref]
[    0.077506] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.077512] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.077578] pci_bus 0000:02: busn_res: can not insert [bus 02-ff] under [bus 01-07] (conflicts with (null) [bus 01-07])
[    0.077588] pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 05
[    0.077655] pci_bus 0000:06: busn_res: can not insert [bus 06-ff] under [bus 01-07] (conflicts with (null) [bus 01-07])
[    0.077664] pci_bus 0000:06: busn_res: [bus 06-ff] end is updated to 06
[    0.077678] pci_bus 0000:00: on NUMA node 0
[    0.077686] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.077813] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.078355] ACPI: \_SB_.PCI0: notify handler is installed
[    0.078355] Found 1 acpi root devices
[    0.078355] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.080164] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.080285] vgaarb: loaded
[    0.080351] vgaarb: bridge control possible 0000:00:02.0
[    0.080596] SCSI subsystem initialized
[    0.080667] ACPI: bus type ATA registered
[    0.080844] libata version 3.00 loaded.
[    0.080912] PCI: Using ACPI for IRQ routing
[    0.081084] PCI: pci_cache_line_size set to 32 bytes
[    0.081133] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.081139] e820: reserve RAM buffer [mem 0x1f770000-0x1fffffff]
[    0.081400] Switched to clocksource refined-jiffies
[    0.081533] pnp: PnP ACPI init
[    0.081620] ACPI: bus type PNP registered
[    0.082745] pnp 00:00: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.083411] pnp 00:00: disabling [mem 0x000c0000-0x000c3fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.084013] pnp 00:00: disabling [mem 0x000c4000-0x000c7fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.084678] pnp 00:00: disabling [mem 0x000c8000-0x000cbfff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.085338] pnp 00:00: disabling [mem 0x000cc000-0x000cffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.086001] pnp 00:00: disabling [mem 0x000d0000-0x000cffff disabled] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.086672] pnp 00:00: disabling [mem 0x000d4000-0x000d3fff disabled] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.087324] pnp 00:00: disabling [mem 0x000d8000-0x000d7fff disabled] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.088010] pnp 00:00: disabling [mem 0x000dc000-0x000dffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.088666] pnp 00:00: disabling [mem 0x000e0000-0x000e3fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.089328] pnp 00:00: disabling [mem 0x000e4000-0x000e7fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.089989] pnp 00:00: disabling [mem 0x000e8000-0x000ebfff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.090504] pnp 00:00: disabling [mem 0x000ec000-0x000effff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.091564] pnp 00:00: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.091691] pnp 00:00: disabling [mem 0x00100000-0x1fffffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.091885] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.092009] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.092160] system 00:01: [io  0x1000-0x107f] could not be reserved
[    0.092237] system 00:01: [io  0x1180-0x11bf] has been reserved
[    0.092311] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.092385] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.092460] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.092494] pnp 00:02: [dma 4]
[    0.092544] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.092606] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.092672] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.092738] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.092801] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.092865] pnp 00:07: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    0.092941] pnp 00:08: [dma 2]
[    0.093016] pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.093312] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.093605] pnp 00:0a: [dma 0]
[    0.093754] pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.093941] pnp 00:0b: [dma 3]
[    0.094102] pnp 00:0b: Plug and Play ACPI device, IDs IBM0071 PNP0511 (active)
[    0.094162] pnp: PnP ACPI: found 12 devices
[    0.094162] ACPI: bus type PNP unregistered
[    0.133330] Switched to clocksource acpi_pm
[    0.133702] pci 0000:00:1f.0: BAR 7: [io  0x1000-0x107f] has bogus alignment
[    0.134072] pci 0000:00:1f.1: BAR 5: assigned [mem 0x20000000-0x200003ff]
[    0.134425] pci 0000:01:00.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.134432] pci 0000:01:00.0: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.134440] pci 0000:01:00.1: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.134447] pci 0000:01:00.1: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.134453] pci 0000:01:00.0: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.134459] pci 0000:01:00.0: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.134466] pci 0000:01:00.1: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.134472] pci 0000:01:00.1: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.134479] pci 0000:01:00.0: BAR 9: assigned [mem 0xf0000000-0xf3ffffff pref]
[    0.135081] pci 0000:01:00.0: BAR 10: assigned [mem 0xd4000000-0xd7ffffff]
[    0.135422] pci 0000:01:00.1: BAR 9: assigned [mem 0xf4000000-0xf7ffffff pref]
[    0.135422] pci 0000:01:00.1: BAR 10: assigned [mem 0xd8000000-0xdbffffff]
[    0.135422] pci 0000:01:02.0: BAR 6: assigned [mem 0xd0800000-0xd09fffff pref]
[    0.135685] pci 0000:01:00.0: BAR 7: assigned [io  0x3000-0x30ff]
[    0.136036] pci 0000:01:00.0: BAR 8: assigned [io  0x3400-0x34ff]
[    0.136376] pci 0000:01:00.1: BAR 7: assigned [io  0x3800-0x38ff]
[    0.136726] pci 0000:01:00.1: BAR 8: assigned [io  0x3c00-0x3cff]
[    0.137081] pci 0000:01:00.0: CardBus bridge to [bus 02-05]
[    0.137411] pci 0000:01:00.0:   bridge window [io  0x3000-0x30ff]
[    0.137761] pci 0000:01:00.0:   bridge window [io  0x3400-0x34ff]
[    0.138113] pci 0000:01:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
[    0.138724] pci 0000:01:00.0:   bridge window [mem 0xd4000000-0xd7ffffff]
[    0.139065] pci 0000:01:00.1: CardBus bridge to [bus 06]
[    0.139266] pci 0000:01:00.1:   bridge window [io  0x3800-0x38ff]
[    0.139341] pci 0000:01:00.1:   bridge window [io  0x3c00-0x3cff]
[    0.139416] pci 0000:01:00.1:   bridge window [mem 0xf4000000-0xf7ffffff pref]
[    0.139535] pci 0000:01:00.1:   bridge window [mem 0xd8000000-0xdbffffff]
[    0.139612] pci 0000:00:1e.0: PCI bridge to [bus 01-07]
[    0.139686] pci 0000:00:1e.0:   bridge window [io  0x3000-0x7fff]
[    0.139763] pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xdfffffff]
[    0.139840] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff pref]
[    0.139974] pci 0000:00:1e.0: setting latency timer to 64
[    0.140414] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.140489] PCI: setting IRQ 11 as level-triggered
[    0.140824] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
[    0.140896] PCI: setting IRQ 5 as level-triggered
[    0.140909] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.140915] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.140921] pci_bus 0000:01: resource 0 [io  0x3000-0x7fff]
[    0.140927] pci_bus 0000:01: resource 1 [mem 0xd0200000-0xdfffffff]
[    0.140933] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff pref]
[    0.140939] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.140945] pci_bus 0000:01: resource 5 [mem 0x00000000-0xffffffff]
[    0.140951] pci_bus 0000:02: resource 0 [io  0x3000-0x30ff]
[    0.140956] pci_bus 0000:02: resource 1 [io  0x3400-0x34ff]
[    0.140963] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.140968] pci_bus 0000:02: resource 3 [mem 0xd4000000-0xd7ffffff]
[    0.140975] pci_bus 0000:06: resource 0 [io  0x3800-0x38ff]
[    0.140980] pci_bus 0000:06: resource 1 [io  0x3c00-0x3cff]
[    0.140986] pci_bus 0000:06: resource 2 [mem 0xf4000000-0xf7ffffff pref]
[    0.140992] pci_bus 0000:06: resource 3 [mem 0xd8000000-0xdbffffff]
[    0.141084] NET: Registered protocol family 2
[    0.141532] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[    0.141677] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[    0.141786] TCP: Hash tables configured (established 4096 bind 4096)
[    0.141911] TCP: reno registered
[    0.141984] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.142065] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.142263] NET: Registered protocol family 1
[    0.142368] pci 0000:00:02.0: Boot video device
[    0.142393] pci 0000:00:1d.0: power state changed by ACPI to D0
[    0.142578] pci 0000:00:1d.1: power state changed by ACPI to D0
[    0.143017] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.143455] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.143623] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.143744] PCI: CLS 32 bytes, default 32
[    0.143834] Simple Boot Flag at 0x35 set to 0x1
[    0.144411] audit: initializing netlink socket (disabled)
[    0.144505] type=2000 audit(1377507957.144:1): initialized
[    0.145028] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.148706] msgmni has been set to 987
[    0.149299] cryptomgr_test (19) used greatest stack depth: 7688 bytes left
[    0.149826] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.150435] io scheduler noop registered
[    0.150872] io scheduler cfq registered (default)
[    0.151271] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.151904] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.152568] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    0.153167] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    0.154261] Non-volatile memory driver v1.3
[    0.154587] Linux agpgart interface v0.103
[    0.154926] agpgart-intel 0000:00:00.0: Intel 830M Chipset
[    0.155294] agpgart-intel 0000:00:00.0: detected gtt size: 131072K total, 131072K mappable
[    0.156713] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.157122] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[    0.157333] ata_piix 0000:00:1f.1: version 2.13
[    0.157352] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    0.157554] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.158116] scsi0 : ata_piix
[    0.158664] scsi1 : ata_piix
[    0.159037] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
[    0.159113] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
[    0.159322] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.165066] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.165388] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.166074] mousedev: PS/2 mouse device common for all mice
[    0.166471] rtc_cmos 00:05: RTC can wake from S4
[    0.166964] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.167335] rtc_cmos 00:05: alarms up to one month, y3k, 114 bytes nvram
[    0.167704] cpuidle: using governor ladder
[    0.168038] cpuidle: using governor menu
[    0.168573] TCP: cubic registered
[    0.169159] NET: Registered protocol family 10
[    0.169933] NET: Registered protocol family 17
[    0.170499] Using IPI Shortcut mode
[    0.170912] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.171793] PM: Hibernation image not present or could not be loaded.
[    0.171820] registered taskstats version 1
[    0.172636] rtc_cmos 00:05: setting system clock to 2013-08-26 09:05:57 UTC (1377507957)
[    0.328465] ata1.00: ATA-7: ST96023A, 3.06, max UDMA/100
[    0.328541] ata1.00: 117210240 sectors, multi 16: LBA48 
[    0.344316] ata1.00: configured for UDMA/100
[    0.344613] scsi 0:0:0:0: Direct-Access     ATA      ST96023A         3.06 PQ: 0 ANSI: 5
[    0.345109] sd 0:0:0:0: [sda] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    0.345327] sd 0:0:0:0: [sda] Write Protect is off
[    0.345401] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.345449] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.396314]  sda: sda1 sda2 < sda5 >
[    0.396869] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.420066] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
[    0.420895] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
[    0.450246] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    0.450884] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    0.485577] devtmpfs: mounted
[    0.486321] Freeing unused kernel memory: 316K (c1434000 - c1483000)
[    0.486836] Write protecting the kernel text: 3148k
[    0.487194] Write protecting the kernel read-only data: 924k
[    1.144035] tsc: Refined TSC clocksource calibration: 1196.015 MHz
[    1.197248] stty (36) used greatest stack depth: 6404 bytes left
[    2.144103] Switched to clocksource tsc
[    2.223101] udevd[147]: starting version 175
[    3.237720] microcode: CPU0 sig=0x6b4, pf=0x20, revision=0x2
[    3.309703] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.310119] modprobe (234) used greatest stack depth: 6200 bytes left
[    3.354912] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    3.414089] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    3.417158] ACPI: Lid Switch [LID]
[    3.418553] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    3.419385] ACPI: Sleep Button [SLPB]
[    3.419940] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    3.420738] ACPI: Power Button [PWRF]
[    3.426984] ACPI: AC Adapter [AC] (on-line)
[    3.428358] modprobe (293) used greatest stack depth: 6044 bytes left
[    3.499926] parport_pc 00:0a: reported by Plug and Play ACPI
[    3.500379] parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    3.554332] Floppy drive(s): fd0 is 1.44M
[    3.571043] FDC 0 is a National Semiconductor PC87306
[    3.607731] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.632098] intel_rng: FWH not detected
[    3.750150] ACPI: Battery Slot [BAT0] (battery absent)
[    3.775031] thermal LNXTHERM:00: registered as thermal_zone0
[    3.775119] ACPI: Thermal Zone [THM0] (59 C)
[    3.786169] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    3.786657] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/LNXVIDEO:00/input/input5
[    3.952149] firewire_ohci 0000:01:00.2: added OHCI v1.0 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    3.973039] ACPI: Requesting acpi_cpufreq
[    3.973360] tsc: Marking TSC unstable due to TSC halts in idle
[    3.973453] ACPI: acpi_idle registered with cpuidle
[    3.976825] Switched to clocksource acpi_pm
[    4.214250] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.214607] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.216293] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
[    4.240240] e100 0000:01:08.0 eth0: addr 0xd0204000, irq 11, MAC addr 00:09:6b:a0:c7:55
[    4.255242] airo(): Probing for PCI adapters
[    4.256498] airo(): Found an MPI350 card
[    4.452263] firewire_core 0000:01:00.2: created device fw0: GUID 00061b0201022780, S400
[    4.479584] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    4.596288] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    4.596375] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.596444] thinkpad_acpi: ThinkPad BIOS 1KET48WW (1.09 ), EC 1KHT18WW-1.06
[    4.599842] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    4.615588] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.621789] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    4.793788] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    4.810093] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input7
[    5.203639] airo(eth1): Firmware version 5.2.19
[    5.204037] airo(eth1): WPA unsupported with firmware versions older than 5.30.17.
[    5.204665] airo(eth1): MAC enabled 00:02:8a:25:27:a8
[    5.204921] yenta_cardbus 0000:01:00.0: CardBus bridge found [1014:0185]
[    5.205099] airo(): Finished probing for PCI adapters
[    5.206201] modprobe (309) used greatest stack depth: 5752 bytes left
[    5.228109] ACPI: bus type USB registered
[    5.229256] usbcore: registered new interface driver usbfs
[    5.229718] usbcore: registered new interface driver hub
[    5.229923] usbcore: registered new device driver usb
[    5.332495] yenta_cardbus 0000:01:00.0: ISA IRQ mask 0x0418, PCI irq 11
[    5.332873] yenta_cardbus 0000:01:00.0: Socket status: 30000006
[    5.333235] yenta_cardbus 0000:01:00.0: pcmcia: parent PCI bridge window: [io  0x3000-0x7fff]
[    5.333877] yenta_cardbus 0000:01:00.0: pcmcia: parent PCI bridge window: [mem 0xd0200000-0xdfffffff]
[    5.334539] pcmcia_socket pcmcia_socket0: cs: memory probe 0xd0200000-0xdfffffff:
[    5.335181]  excluding 0xd0200000-0xd09fffff 0xd3a00000-0xdc1fffff 0xdfa00000-0xe01fffff
[    5.335984] yenta_cardbus 0000:01:00.0: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf7ffffff pref]
[    5.342470] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xf7ffffff:
[    5.342634]  excluding 0xf0000000-0xf7ffffff
[    5.346456] yenta_cardbus 0000:01:00.1: CardBus bridge found [1014:0185]
[    5.397931] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.456460] uhci_hcd: USB Universal Host Controller Interface driver
[    5.457952] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.457968] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.458067] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    5.458244] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
[    5.458435] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.458524] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.458645] usb usb1: Product: UHCI Host Controller
[    5.458721] usb usb1: Manufacturer: Linux 3.11.0-rc7 uhci_hcd
[    5.458798] usb usb1: SerialNumber: 0000:00:1d.0
[    5.459587] hub 1-0:1.0: USB hub found
[    5.459674] hub 1-0:1.0: 2 ports detected
[    5.460163] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.460173] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.460260] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    5.460416] uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
[    5.460584] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.460665] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.460787] usb usb2: Product: UHCI Host Controller
[    5.460862] usb usb2: Manufacturer: Linux 3.11.0-rc7 uhci_hcd
[    5.460939] usb usb2: SerialNumber: 0000:00:1d.1
[    5.461515] hub 2-0:1.0: USB hub found
[    5.461596] hub 2-0:1.0: 2 ports detected
[    5.461969] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.461979] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.462066] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    5.462219] uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
[    5.462386] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.462468] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.462589] usb usb3: Product: UHCI Host Controller
[    5.462665] usb usb3: Manufacturer: Linux 3.11.0-rc7 uhci_hcd
[    5.462742] usb usb3: SerialNumber: 0000:00:1d.2
[    5.463295] hub 3-0:1.0: USB hub found
[    5.463624] hub 3-0:1.0: 2 ports detected
[    5.472468] yenta_cardbus 0000:01:00.1: ISA IRQ mask 0x0418, PCI irq 5
[    5.472562] yenta_cardbus 0000:01:00.1: Socket status: 30000006
[    5.472653] yenta_cardbus 0000:01:00.1: pcmcia: parent PCI bridge window: [io  0x3000-0x7fff]
[    5.472780] yenta_cardbus 0000:01:00.1: pcmcia: parent PCI bridge window: [mem 0xd0200000-0xdfffffff]
[    5.472907] pcmcia_socket pcmcia_socket1: cs: memory probe 0xd0200000-0xdfffffff:
[    5.473032]  excluding 0xd0200000-0xd09fffff 0xd3a00000-0xdc1fffff 0xdfa00000-0xe01fffff
[    5.473268] yenta_cardbus 0000:01:00.1: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf7ffffff pref]
[    5.473396] pcmcia_socket pcmcia_socket1: cs: memory probe 0xf0000000-0xf7ffffff:
[    5.473534]  excluding 0xf0000000-0xf7ffffff
[    5.653298] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
[    5.653691]  excluding 0xc0000-0xc7fff 0xcc000-0xcffff 0xdc000-0xfffff
[    5.654187] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
[    5.654681]  clean.
[    5.654793] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
[    5.654936]  clean.
[    5.655420] pcmcia_socket pcmcia_socket1: cs: memory probe 0x0c0000-0x0fffff:
[    5.655516]  excluding 0xc0000-0xc7fff 0xcc000-0xcffff 0xdc000-0xfffff
[    5.655729] pcmcia_socket pcmcia_socket1: cs: memory probe 0xa0000000-0xa0ffffff:
[    5.655872]  clean.
[    5.655984] pcmcia_socket pcmcia_socket1: cs: memory probe 0x60000000-0x60ffffff:
[    5.656177]  clean.
[    5.875677] [drm] Initialized drm 1.1.0 20060810
[    5.966496] snd_intel8x0m 0000:00:1f.6: setting latency timer to 64
[    6.142628] snd_intel8x0 0000:00:1f.5: setting latency timer to 64
[    6.712051] intel8x0_measure_ac97_clock: measured 55387 usecs (2662 samples)
[    6.712148] intel8x0: clocking to 48000
[    6.945880] [drm] Memory usable by graphics device = 128M
[    6.945987] i915 0000:00:02.0: setting latency timer to 64
[    6.948125] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.948500] [drm] Driver supports precise vblank timestamp query.
[    6.949002] [drm] applying pipe a force quirk
[    6.949365] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.959066] [drm] initialized overlay support
[    6.977969] fbcon: inteldrmfb (fb0) is primary device
[    7.056415] ------------[ cut here ]------------
[    7.056535] WARNING: CPU: 0 PID: 199 at drivers/gpu/drm/i915/intel_display.c:1074 assert_pipe+0x80/0xe0 [i915]()
[    7.056538] pipe A assertion failure (expected on, current off)
[    7.056604] Modules linked in: i915(+) snd_intel8x0 i2c_algo_bit drm_kms_helper snd_intel8x0m snd_ac97_codec drm ac97_bus pcmcia snd_pcm uhci_hcd ehci_hcd usbcore snd_page_alloc thinkpad_acpi snd_seq snd_seq_device snd_timer snd yenta_socket pcmcia_rsrc airo e100 acpi_cpufreq mperf mii psmouse pcmcia_core processor firewire_ohci firewire_core video thermal battery rfkill crc_itu_t shpchp rng_core soundcore floppy i2c_i801 thermal_sys parport_pc parport serio_raw usb_common ac button evdev i2c_core pcspkr microcode
[    7.056612] CPU: 0 PID: 199 Comm: modprobe Not tainted 3.11.0-rc7 #4
[    7.056615] Hardware name: IBM 26724XG/26724XG, BIOS 1KET48WW (1.09 ) 06/16/2006
[    7.056627]  c130dc47 c102db05 e04b8528 def058b8 000000c7 e04b73e8 00000432 e0478580
[    7.056635]  e0478580 dc480000 00000041 00000000 00000000 c102db53 00000009 def058a0
[    7.056644]  e04b8528 def058b8 e0478580 e04b73e8 00000432 e04b8528 00000041 e04bdefb
[    7.056646] Call Trace:
[    7.056663]  [<c130dc47>] ? dump_stack+0xa/0x13
[    7.056676]  [<c102db05>] ? warn_slowpath_common+0x75/0x90
[    7.056732]  [<e0478580>] ? assert_pipe+0x80/0xe0 [i915]
[    7.056785]  [<e0478580>] ? assert_pipe+0x80/0xe0 [i915]
[    7.056793]  [<c102db53>] ? warn_slowpath_fmt+0x33/0x40
[    7.056846]  [<e0478580>] ? assert_pipe+0x80/0xe0 [i915]
[    7.056901]  [<e04788ce>] ? intel_enable_pll+0xe/0xc0 [i915]
[    7.056954]  [<e0478dde>] ? i9xx_crtc_enable+0x5e/0x220 [i915]
[    7.057010]  [<e047eb2c>] ? __intel_set_mode+0x65c/0x11d0 [i915]
[    7.057069]  [<e04814bd>] ? intel_set_mode+0x1d/0x40 [i915]
[    7.057125]  [<e0481cc8>] ? intel_crtc_set_config+0x6f8/0x8e0 [i915]
[    7.057155]  [<e0150de3>] ? drm_mode_set_config_internal+0x43/0xb0 [drm]
[    7.057167]  [<e0364225>] ? drm_fb_helper_set_par+0x45/0xb0 [drm_kms_helper]
[    7.057178]  [<c11a6822>] ? fbcon_init+0x482/0x4d0
[    7.057188]  [<c11e2fae>] ? set_inverse_trans_unicode.isra.4+0xfe/0x120
[    7.057196]  [<c11e42d6>] ? visual_init+0x96/0xf0
[    7.057203]  [<c11e6444>] ? do_bind_con_driver+0x104/0x2d0
[    7.057211]  [<c1101f96>] ? sysfs_add_file_mode+0x76/0xa0
[    7.057219]  [<c11e6ae6>] ? do_take_over_console+0xf6/0x190
[    7.057225]  [<c11a2437>] ? do_fbcon_takeover+0x57/0xc0
[    7.057234]  [<c1047156>] ? notifier_call_chain+0x46/0x60
[    7.057240]  [<c1047387>] ? __blocking_notifier_call_chain+0x37/0x50
[    7.057247]  [<c10473b7>] ? blocking_notifier_call_chain+0x17/0x20
[    7.057259]  [<c119aa00>] ? register_framebuffer+0x1b0/0x2d0
[    7.057269]  [<e0363f35>] ? drm_fb_helper_initial_config+0x2e5/0x490 [drm_kms_helper]
[    7.057287]  [<e014fb33>] ? drm_mode_config_reset+0x93/0xb0 [drm]
[    7.057297]  [<c10af8d3>] ? __kmalloc+0xb3/0xe0
[    7.057306]  [<e03632f8>] ? drm_fb_helper_single_add_all_connectors+0x58/0xa0 [drm_kms_helper]
[    7.057354]  [<e045e667>] ? i915_driver_load+0xdc7/0xe00 [i915]
[    7.057400]  [<e045b6d0>] ? i915_emit_breadcrumb+0xe0/0xe0 [i915]
[    7.057423]  [<e014d529>] ? drm_get_pci_dev+0x129/0x230 [drm]
[    7.057434]  [<c118c2a3>] ? pci_device_probe+0x63/0xb0
[    7.057442]  [<c1200220>] ? __device_attach+0x30/0x30
[    7.057447]  [<c1200073>] ? driver_probe_device+0x53/0x1d0
[    7.057456]  [<c11721ea>] ? kobject_add_internal+0x7a/0x2a0
[    7.057461]  [<c1200291>] ? __driver_attach+0x71/0x80
[    7.057474]  [<c11fe91f>] ? bus_for_each_dev+0x3f/0x70
[    7.057480]  [<c11ffc76>] ? driver_attach+0x16/0x20
[    7.057485]  [<c1200220>] ? __device_attach+0x30/0x30
[    7.057490]  [<c11ff94f>] ? bus_add_driver+0x18f/0x230
[    7.057497]  [<c118b370>] ? pci_device_shutdown+0x50/0x50
[    7.057503]  [<c1200773>] ? driver_register+0x63/0x120
[    7.057513]  [<e04cd000>] ? 0xe04ccfff
[    7.057520]  [<c1000402>] ? do_one_initcall+0xe2/0x130
[    7.057529]  [<c10a56e0>] ? __vunmap+0x80/0xe0
[    7.057536]  [<c10af3fe>] ? kfree+0x8e/0xc0
[    7.057541]  [<c10a56c7>] ? __vunmap+0x67/0xe0
[    7.057547]  [<c10a56c7>] ? __vunmap+0x67/0xe0
[    7.057553]  [<c10af3fe>] ? kfree+0x8e/0xc0
[    7.057563]  [<c1067ddb>] ? load_module+0x151b/0x1cd0
[    7.057573]  [<c10685fb>] ? SyS_init_module+0x6b/0xa0
[    7.057585]  [<c13110c1>] ? sysenter_do_call+0x12/0x22
[    7.057589] ---[ end trace eb2d805753ac7bfc ]---
[    7.121008] Console: switching to colour frame buffer device 128x48
[    7.444185] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    7.449459] i915 0000:00:02.0: registered panic notifier
[    7.463258] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    7.493033] modprobe (199) used greatest stack depth: 5288 bytes left
[    8.791178] Adding 1028092k swap on /dev/sda5.  Priority:-1 extents:1 across:1028092k 
[    8.839671] EXT4-fs (sda1): re-mounted. Opts: (null)
[    9.157098] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    9.559484] fuse init (API version 7.22)
[    9.635294] loop: module loaded
[   13.389812] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.529988] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input8
[   17.139984] Bluetooth: Core ver 2.16
[   17.149446] NET: Registered protocol family 31
[   17.155706] Bluetooth: HCI device and connection manager initialized
[   17.162938] Bluetooth: HCI socket layer initialized
[   17.169879] Bluetooth: L2CAP socket layer initialized
[   17.176189] Bluetooth: SCO socket layer initialized
[   17.250563] Bluetooth: RFCOMM TTY layer initialized
[   17.256795] Bluetooth: RFCOMM socket layer initialized
[   17.262697] Bluetooth: RFCOMM ver 1.11
[   17.325204] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   17.330933] Bluetooth: BNEP filters: protocol multicast
[   17.338496] Bluetooth: BNEP socket layer initialized

00:00.0 Host bridge [0600]: Intel Corporation 82830M/MG/MP Host Bridge [8086:3575] (rev 04)
	Subsystem: IBM ThinkPad A/T/X Series [1014:021d]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at <unassigned> (32-bit, prefetchable)
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation 82830M/MG Integrated Graphics Controller [8086:3577] (rev 04) (prog-if 00 [VGA controller])
	Subsystem: IBM ThinkPad A/T/X Series [1014:0513]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at d0000000 (32-bit, non-prefetchable) [size=512K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:02.1 Display controller [0380]: Intel Corporation 82830M/MG Integrated Graphics Controller [8086:3577]
	Subsystem: IBM ThinkPad A/T/X Series [1014:0513]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at d0080000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:1d.0 USB controller [0c03]: Intel Corporation 82801CA/CAM USB Controller #1 [8086:2482] (rev 02) (prog-if 00 [UHCI])
	Subsystem: IBM ThinkPad A/T/X Series [1014:0220]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 4: I/O ports at 1800 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB controller [0c03]: Intel Corporation 82801CA/CAM USB Controller #2 [8086:2484] (rev 02) (prog-if 00 [UHCI])
	Subsystem: IBM ThinkPad A/T/X Series [1014:0220]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 1820 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB controller [0c03]: Intel Corporation 82801CA/CAM USB Controller #3 [8086:2487] (rev 02) (prog-if 00 [UHCI])
	Subsystem: IBM ThinkPad A/T/X Series [1014:0220]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 4: I/O ports at 1840 [size=32]
	Kernel driver in use: uhci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 42) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=07, sec-latency=64
	I/O behind bridge: 00003000-00007fff
	Memory behind bridge: d0200000-dfffffff
	Prefetchable memory behind bridge: f0000000-f7ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1f.0 ISA bridge [0601]: Intel Corporation 82801CAM ISA Bridge (LPC) [8086:248c] (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:1f.1 IDE interface [0101]: Intel Corporation 82801CAM IDE U100 Controller [8086:248a] (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: IBM ThinkPad A/T/X Series [1014:0220]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374
	Region 4: I/O ports at 1860 [size=16]
	Region 5: Memory at 20000000 (32-bit, non-prefetchable) [size=1K]
	Kernel driver in use: ata_piix

00:1f.3 SMBus [0c05]: Intel Corporation 82801CA/CAM SMBus Controller [8086:2483] (rev 02)
	Subsystem: IBM ThinkPad A/T/X Series [1014:0220]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at 1880 [size=32]
	Kernel driver in use: i801_smbus

00:1f.5 Multimedia audio controller [0401]: Intel Corporation 82801CA/CAM AC'97 Audio Controller [8086:2485] (rev 02)
	Subsystem: IBM ThinkPad A/T/X Series [1014:051c]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 5
	Region 0: I/O ports at 1c00 [size=256]
	Region 1: I/O ports at 18c0 [size=64]
	Kernel driver in use: snd_intel8x0

00:1f.6 Modem [0703]: Intel Corporation 82801CA/CAM AC'97 Modem Controller [8086:2486] (rev 02) (prog-if 00 [Generic])
	Subsystem: IBM ThinkPad A/T/X Series [1014:0223]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 5
	Region 0: I/O ports at 2400 [size=256]
	Region 1: I/O ports at 2000 [size=128]
	Kernel driver in use: snd_intel8x0m

01:00.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev a8)
	Subsystem: IBM ThinkPad A/T/X Series [1014:0185]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at 50000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: f0000000-f3ffffff (prefetchable)
	Memory window 1: d4000000-d7ffffff
	I/O window 0: 00003000-000030ff
	I/O window 1: 00003400-000034ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

01:00.1 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev a8)
	Subsystem: IBM ThinkPad A/T/X Series [1014:0185]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168
	Interrupt: pin B routed to IRQ 5
	Region 0: Memory at 50100000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=06, subordinate=06, sec-latency=176
	Memory window 0: f4000000-f7ffffff (prefetchable)
	Memory window 1: d8000000-dbffffff
	I/O window 0: 00003800-000038ff
	I/O window 1: 00003c00-00003cff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

01:00.2 FireWire (IEEE 1394) [0c00]: Ricoh Co Ltd R5C552 IEEE 1394 Controller [1180:0552] (prog-if 10 [OHCI])
	Subsystem: IBM ThinkPad A/T/X Series [1014:0511]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at d0205000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci

01:02.0 Network controller [0280]: Cisco Aironet Wireless Communications Cisco Aironet Wireless 802.11b [14b9:a504]
	Subsystem: Cisco Aironet Wireless Communications Device [14b9:5000]
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1000ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 7000 [size=256]
	Region 1: Memory at d0200000 (32-bit, non-prefetchable) [size=16K]
	Region 2: Memory at d0400000 (32-bit, non-prefetchable) [size=4M]
	[virtual] Expansion ROM at d0800000 [disabled] [size=2M]
	Capabilities: <access denied>
	Kernel driver in use: airo

01:08.0 Ethernet controller [0200]: Intel Corporation 82801CAM (ICH3) PRO/100 VE (LOM) Ethernet Controller [8086:1031] (rev 42)
	Subsystem: IBM ThinkPad A/T/X Series [1014:0209]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 66 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d0204000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at 7400 [size=64]
	Capabilities: <access denied>
	Kernel driver in use: e100



-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
