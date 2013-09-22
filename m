Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3IVGCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 02:02:25 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:57733 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3IVGCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 02:02:24 -0400
Date: Sun, 22 Sep 2013 09:02:19 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        =?ISO-8859-15?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: i915 pipe A assertion failure (expected on, current off)
In-Reply-To: <CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1309220901430.366@math.ut.ee>
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee> <alpine.SOC.1.00.1309211825490.9193@math.ut.ee> <CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Tried 3.11-rc7 on Thinkpad X30 (first 3-11-rc tried on this hw). Works
> >> but i915 gives strange assertion failure with WARNING stack trace. This
> >> is new since 3.10.
> >
> > It is still there with 3.12-rc1 but now I git around to bisecting it.
> > This is the commit that introduces the warning.
> >
> > commit 9f11a9e4e50006b615ba94722dfc33ced89664cf
> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Date:   Thu Jun 13 00:54:58 2013 +0200
> >
> >     drm/i915: set up PIPECONF explicitly for i9xx/vlv platforms
> 
> My apologies for not responding to your first report, fell through the
> cracks somehow. Can you please boot with drm.debug=0xe, reproduce the
> WARN and grab the full dmesg (please make sure everything from boot-up
> is in there). That's usually enough to figure out what's going wrong
> here.

[    0.000000] Linux version 3.12.0-rc1-00273-g2457aaf (mroos@x30) (gcc version 4.8.1 (Debian 4.8.1-10) ) #31 Sat Sep 21 20:40:43 EEST 2013
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
[    0.000000] BRK [0x014ed000, 0x014edfff] PGTABLE
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
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.12.0-rc1-00273-g2457aaf root=/dev/sda1 ro lapic drm.debug=0xe
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 505452K/515128K available (3197K kernel code, 234K rwdata, 932K rodata, 320K init, 324K bss, 9676K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     vmalloc : 0xdff70000 - 0xfffa0000   ( 512 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf770000   ( 503 MB)
[    0.000000]       .init : 0xc1445000 - 0xc1495000   ( 320 kB)
[    0.000000]       .data : 0xc131fa39 - 0xc1444940   (1171 kB)
[    0.000000]       .text : 0xc1000000 - 0xc131fa39   (3198 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=dec06000 soft=dec08000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1196.056 MHz processor
[    0.008005] Calibrating delay loop (skipped), value calculated using timer frequency.. 2392.11 BogoMIPS (lpj=4784224)
[    0.008147] pid_max: default: 32768 minimum: 301
[    0.008317] Mount-cache hash table entries: 512
[    0.012351] mce: CPU supports 5 MCE banks
[    0.012476] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 2
[    0.012476] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8
[    0.012476] tlb_flushall_shift: 6
[    0.012645] CPU: Mobile Intel(R) Pentium(R) III CPU - M  1200MHz (fam: 06, model: 0b, stepping: 04)
[    0.012862] ACPI: Core revision 20130725
[    0.022555] ACPI: All ACPI Tables successfully acquired
[    0.022952] ACPI: setting ELCR to 0200 (from 0820)
[    0.028028] Performance Events: p6 PMU driver.
[    0.028396] ... version:                0
[    0.028708] ... bit width:              32
[    0.029018] ... generic registers:      2
[    0.029329] ... value mask:             00000000ffffffff
[    0.029659] ... max period:             000000007fffffff
[    0.029970] ... fixed-purpose events:   0
[    0.030280] ... event mask:             0000000000000003
[    0.030907] Enabling APIC mode:  Flat.  Using 0 I/O APICs
[    0.032000] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.032000] devtmpfs: initialized
[    0.032000] PM: Registering ACPI NVS region [mem 0x1f77e000-0x1f77ffff] (8192 bytes)
[    0.032000] NET: Registered protocol family 16
[    0.032000] cpuidle: using governor ladder
[    0.032000] cpuidle: using governor menu
[    0.032000] ACPI: bus type PCI registered
[    0.032000] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.032000] PCI: PCI BIOS revision 2.10 entry at 0xfd90e, last bus=7
[    0.032000] PCI: Using configuration type 1 for base access
[    0.032000] bio: create slab <bio-0> at 0
[    0.032000] ACPI: Added _OSI(Module Device)
[    0.032000] ACPI: Added _OSI(Processor Device)
[    0.032000] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.032000] ACPI: Added _OSI(Processor Aggregator Device)
[    0.033683] ACPI: EC: EC description table is found, configuring boot EC
[    0.044787] ACPI: Interpreter enabled
[    0.044787] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
[    0.044845] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    0.045023] ACPI: (supports S0 S3 S4 S5)
[    0.045092] ACPI: Using PIC for interrupt routing
[    0.048042] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.049114] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.056697] ACPI: Power Resource [PUBS] (on)
[    0.064240] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.064741] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11)
[    0.065235] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.065730] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.066224] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.066657] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.067678] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.068464] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.069386] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.069747] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.070359] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.071041] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.071048] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.071055] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.071062] acpi PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
[    0.071068] acpi PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.071074] acpi PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
[    0.071081] acpi PNP0A03:00: host bridge window [mem 0x20000000-0xfebfffff] (ignored)
[    0.071086] PCI: root bus 00: using default resources
[    0.071094] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.072186] PCI host bridge to bus 0000:00
[    0.072505] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.072833] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.073182] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.073550] pci 0000:00:00.0: [8086:3575] type 00 class 0x060000
[    0.073694] pci 0000:00:02.0: [8086:3577] type 00 class 0x030000
[    0.073710] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe7ffffff pref]
[    0.073721] pci 0000:00:02.0: reg 0x14: [mem 0xd0000000-0xd007ffff]
[    0.073754] pci 0000:00:02.0: supports D1
[    0.073860] pci 0000:00:02.1: [8086:3577] type 00 class 0x038000
[    0.073873] pci 0000:00:02.1: reg 0x10: [mem 0xe8000000-0xefffffff pref]
[    0.073883] pci 0000:00:02.1: reg 0x14: [mem 0xd0080000-0xd00fffff]
[    0.073916] pci 0000:00:02.1: supports D1
[    0.074041] pci 0000:00:1d.0: [8086:2482] type 00 class 0x0c0300
[    0.074082] pci 0000:00:1d.0: reg 0x20: [io  0x1800-0x181f]
[    0.074269] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.074269] pci 0000:00:1d.1: [8086:2484] type 00 class 0x0c0300
[    0.074269] pci 0000:00:1d.1: reg 0x20: [io  0x1820-0x183f]
[    0.074269] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.074269] pci 0000:00:1d.2: [8086:2487] type 00 class 0x0c0300
[    0.074269] pci 0000:00:1d.2: reg 0x20: [io  0x1840-0x185f]
[    0.074269] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.074269] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060400
[    0.074269] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.074269] pci 0000:00:1f.0: [8086:248c] type 00 class 0x060100
[    0.074269] pci 0000:00:1f.0: address space collision: [io  0x1000-0x107f] conflicts with ACPI CPU throttle [??? 0x00001010-0x00001015 flags 0x80000000]
[    0.074269] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH4 GPIO
[    0.076105] pci 0000:00:1f.1: [8086:248a] type 00 class 0x01018a
[    0.076123] pci 0000:00:1f.1: reg 0x10: [io  0x01f0-0x01f7]
[    0.076136] pci 0000:00:1f.1: reg 0x14: [io  0x03f4-0x03f7]
[    0.076148] pci 0000:00:1f.1: reg 0x18: [io  0x0170-0x0177]
[    0.076161] pci 0000:00:1f.1: reg 0x1c: [io  0x0374-0x0377]
[    0.076173] pci 0000:00:1f.1: reg 0x20: [io  0x1860-0x186f]
[    0.076186] pci 0000:00:1f.1: reg 0x24: [mem 0x00000000-0x000003ff]
[    0.076307] pci 0000:00:1f.3: [8086:2483] type 00 class 0x0c0500
[    0.076348] pci 0000:00:1f.3: reg 0x20: [io  0x1880-0x189f]
[    0.076466] pci 0000:00:1f.5: [8086:2485] type 00 class 0x040100
[    0.076483] pci 0000:00:1f.5: reg 0x10: [io  0x1c00-0x1cff]
[    0.076496] pci 0000:00:1f.5: reg 0x14: [io  0x18c0-0x18ff]
[    0.076639] pci 0000:00:1f.6: [8086:2486] type 00 class 0x070300
[    0.076656] pci 0000:00:1f.6: reg 0x10: [io  0x2400-0x24ff]
[    0.076669] pci 0000:00:1f.6: reg 0x14: [io  0x2000-0x207f]
[    0.076768] pci 0000:00:1f.6: System wakeup disabled by ACPI
[    0.077021] acpiphp: Slot [1] registered
[    0.077110] pci 0000:01:00.0: [1180:0476] type 02 class 0x060700
[    0.077128] pci 0000:01:00.0: reg 0x10: [mem 0x50000000-0x50000fff]
[    0.077154] pci 0000:01:00.0: supports D1 D2
[    0.077160] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.077278] pci 0000:01:00.1: [1180:0476] type 02 class 0x060700
[    0.077297] pci 0000:01:00.1: reg 0x10: [mem 0x50100000-0x50100fff]
[    0.077323] pci 0000:01:00.1: supports D1 D2
[    0.077329] pci 0000:01:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.077425] pci 0000:01:00.2: [1180:0552] type 00 class 0x0c0010
[    0.077443] pci 0000:01:00.2: reg 0x10: [mem 0xd0205000-0xd02057ff]
[    0.077502] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    0.077605] pci 0000:01:02.0: [14b9:a504] type 00 class 0x028000
[    0.077625] pci 0000:01:02.0: reg 0x10: [io  0x7000-0x70ff]
[    0.077637] pci 0000:01:02.0: reg 0x14: [mem 0xd0200000-0xd0203fff]
[    0.077649] pci 0000:01:02.0: reg 0x18: [mem 0xd0400000-0xd07fffff]
[    0.077677] pci 0000:01:02.0: reg 0x30: [mem 0x00000000-0x001fffff pref]
[    0.077708] pci 0000:01:02.0: supports D1 D2
[    0.077798] pci 0000:01:08.0: [8086:1031] type 00 class 0x020000
[    0.077816] pci 0000:01:08.0: reg 0x10: [mem 0xd0204000-0xd0204fff]
[    0.077828] pci 0000:01:08.0: reg 0x14: [io  0x7400-0x743f]
[    0.077879] pci 0000:01:08.0: supports D1 D2
[    0.077885] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.077987] pci 0000:00:1e.0: PCI bridge to [bus 01-07] (subtractive decode)
[    0.078066] pci 0000:00:1e.0:   bridge window [io  0x3000-0x7fff]
[    0.078075] pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xdfffffff]
[    0.078083] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff pref]
[    0.078089] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.078095] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.078166] pci_bus 0000:02: busn_res: can not insert [bus 02-ff] under [bus 01-07] (conflicts with (null) [bus 01-07])
[    0.078176] pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 05
[    0.078237] pci_bus 0000:06: busn_res: can not insert [bus 06-ff] under [bus 01-07] (conflicts with (null) [bus 01-07])
[    0.078246] pci_bus 0000:06: busn_res: [bus 06-ff] end is updated to 06
[    0.078261] pci_bus 0000:00: on NUMA node 0
[    0.080137] ACPI: \_SB_.PCI0: notify handler is installed
[    0.080208] Found 1 acpi root devices
[    0.080346] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.080580] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.080702] vgaarb: loaded
[    0.080768] vgaarb: bridge control possible 0000:00:02.0
[    0.081016] SCSI subsystem initialized
[    0.081193] libata version 3.00 loaded.
[    0.081262] PCI: Using ACPI for IRQ routing
[    0.081433] PCI: pci_cache_line_size set to 32 bytes
[    0.081482] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.081488] e820: reserve RAM buffer [mem 0x1f770000-0x1fffffff]
[    0.081766] Switched to clocksource refined-jiffies
[    0.081902] pnp: PnP ACPI init
[    0.081988] ACPI: bus type PNP registered
[    0.083130] pnp 00:00: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.083735] pnp 00:00: disabling [mem 0x000c0000-0x000c3fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.084014] pnp 00:00: disabling [mem 0x000c4000-0x000c7fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.084677] pnp 00:00: disabling [mem 0x000c8000-0x000cbfff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.085338] pnp 00:00: disabling [mem 0x000cc000-0x000cffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.086000] pnp 00:00: disabling [mem 0x000d0000-0x000cffff disabled] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.086671] pnp 00:00: disabling [mem 0x000d4000-0x000d3fff disabled] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.087332] pnp 00:00: disabling [mem 0x000d8000-0x000d7fff disabled] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.088008] pnp 00:00: disabling [mem 0x000dc000-0x000dffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.088665] pnp 00:00: disabling [mem 0x000e0000-0x000e3fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.089326] pnp 00:00: disabling [mem 0x000e4000-0x000e7fff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.092008] pnp 00:00: disabling [mem 0x000e8000-0x000ebfff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.092135] pnp 00:00: disabling [mem 0x000ec000-0x000effff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.092262] pnp 00:00: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.092389] pnp 00:00: disabling [mem 0x00100000-0x1fffffff] because it overlaps 0000:01:02.0 BAR 6 [mem 0x00000000-0x001fffff pref]
[    0.092577] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.092657] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.092813] system 00:01: [io  0x1000-0x107f] could not be reserved
[    0.092890] system 00:01: [io  0x1180-0x11bf] has been reserved
[    0.092964] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.093039] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.093114] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.093148] pnp 00:02: [dma 4]
[    0.093193] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.093258] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.093328] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.093401] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.093463] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.093530] pnp 00:07: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    0.093592] pnp 00:08: [dma 2]
[    0.093661] pnp 00:08: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.093956] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.094251] pnp 00:0a: [dma 0]
[    0.094407] pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.094597] pnp 00:0b: [dma 3]
[    0.094753] pnp 00:0b: Plug and Play ACPI device, IDs IBM0071 PNP0511 (active)
[    0.096054] pnp: PnP ACPI: found 12 devices
[    0.096124] ACPI: bus type PNP unregistered
[    0.134080] Switched to clocksource acpi_pm
[    0.134458] pci 0000:00:1f.0: BAR 7: [io  0x1000-0x107f] has bogus alignment
[    0.134828] pci 0000:00:1f.1: BAR 5: assigned [mem 0x20000000-0x200003ff]
[    0.135182] pci 0000:01:00.0: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.135189] pci 0000:01:00.0: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.135196] pci 0000:01:00.1: res[9]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
[    0.135203] pci 0000:01:00.1: res[10]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
[    0.135210] pci 0000:01:00.0: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.135216] pci 0000:01:00.0: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.135222] pci 0000:01:00.1: res[7]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.135229] pci 0000:01:00.1: res[8]=[io  0x0100-0x00ff] get_res_add_size add_size 100
[    0.135236] pci 0000:01:00.0: BAR 9: assigned [mem 0xf0000000-0xf3ffffff pref]
[    0.135837] pci 0000:01:00.0: BAR 10: assigned [mem 0xd4000000-0xd7ffffff]
[    0.135837] pci 0000:01:00.1: BAR 9: assigned [mem 0xf4000000-0xf7ffffff pref]
[    0.135837] pci 0000:01:00.1: BAR 10: assigned [mem 0xd8000000-0xdbffffff]
[    0.135837] pci 0000:01:02.0: BAR 6: assigned [mem 0xd0800000-0xd09fffff pref]
[    0.135837] pci 0000:01:00.0: BAR 7: assigned [io  0x3000-0x30ff]
[    0.136039] pci 0000:01:00.0: BAR 8: assigned [io  0x3400-0x34ff]
[    0.136378] pci 0000:01:00.1: BAR 7: assigned [io  0x3800-0x38ff]
[    0.136730] pci 0000:01:00.1: BAR 8: assigned [io  0x3c00-0x3cff]
[    0.137084] pci 0000:01:00.0: CardBus bridge to [bus 02-05]
[    0.137415] pci 0000:01:00.0:   bridge window [io  0x3000-0x30ff]
[    0.137764] pci 0000:01:00.0:   bridge window [io  0x3400-0x34ff]
[    0.138116] pci 0000:01:00.0:   bridge window [mem 0xf0000000-0xf3ffffff pref]
[    0.138727] pci 0000:01:00.0:   bridge window [mem 0xd4000000-0xd7ffffff]
[    0.139068] pci 0000:01:00.1: CardBus bridge to [bus 06]
[    0.139355] pci 0000:01:00.1:   bridge window [io  0x3800-0x38ff]
[    0.139430] pci 0000:01:00.1:   bridge window [io  0x3c00-0x3cff]
[    0.139506] pci 0000:01:00.1:   bridge window [mem 0xf4000000-0xf7ffffff pref]
[    0.139624] pci 0000:01:00.1:   bridge window [mem 0xd8000000-0xdbffffff]
[    0.139701] pci 0000:00:1e.0: PCI bridge to [bus 01-07]
[    0.139775] pci 0000:00:1e.0:   bridge window [io  0x3000-0x7fff]
[    0.139852] pci 0000:00:1e.0:   bridge window [mem 0xd0200000-0xdfffffff]
[    0.139929] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff pref]
[    0.140060] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.140067] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.140073] pci_bus 0000:01: resource 0 [io  0x3000-0x7fff]
[    0.140079] pci_bus 0000:01: resource 1 [mem 0xd0200000-0xdfffffff]
[    0.140085] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff pref]
[    0.140091] pci_bus 0000:01: resource 4 [io  0x0000-0xffff]
[    0.140097] pci_bus 0000:01: resource 5 [mem 0x00000000-0xffffffff]
[    0.140103] pci_bus 0000:02: resource 0 [io  0x3000-0x30ff]
[    0.140109] pci_bus 0000:02: resource 1 [io  0x3400-0x34ff]
[    0.140115] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf3ffffff pref]
[    0.140121] pci_bus 0000:02: resource 3 [mem 0xd4000000-0xd7ffffff]
[    0.140127] pci_bus 0000:06: resource 0 [io  0x3800-0x38ff]
[    0.140133] pci_bus 0000:06: resource 1 [io  0x3c00-0x3cff]
[    0.140139] pci_bus 0000:06: resource 2 [mem 0xf4000000-0xf7ffffff pref]
[    0.140145] pci_bus 0000:06: resource 3 [mem 0xd8000000-0xdbffffff]
[    0.140233] NET: Registered protocol family 2
[    0.140689] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[    0.140838] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[    0.140950] TCP: Hash tables configured (established 4096 bind 4096)
[    0.141080] TCP: reno registered
[    0.141153] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.141235] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.141446] NET: Registered protocol family 1
[    0.141553] pci 0000:00:02.0: Boot video device
[    0.142014] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.142090] PCI: setting IRQ 11 as level-triggered
[    0.142468] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.142898] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.143066] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.143196] PCI: CLS 32 bytes, default 32
[    0.143294] Simple Boot Flag at 0x35 set to 0x1
[    0.143877] audit: initializing netlink socket (disabled)
[    0.143974] type=2000 audit(1379829550.140:1): initialized
[    0.144530] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.148151] msgmni has been set to 987
[    0.148732] cryptomgr_test (19) used greatest stack depth: 7688 bytes left
[    0.149244] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.149856] io scheduler noop registered
[    0.150279] io scheduler cfq registered (default)
[    0.150675] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.151219] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.151861] 00:09: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 921600) is a NS16550A
[    0.152811] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 921600) is a NS16550A
[    0.154258] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
[    0.154603] PCI: setting IRQ 5 as level-triggered
[    0.154940] Non-volatile memory driver v1.3
[    0.155271] Linux agpgart interface v0.103
[    0.155613] agpgart-intel 0000:00:00.0: Intel 830M Chipset
[    0.155969] agpgart-intel 0000:00:00.0: detected gtt size: 131072K total, 131072K mappable
[    0.156852] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.157267] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[    0.157477] ata_piix 0000:00:1f.1: version 2.13
[    0.157495] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    0.157698] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.158848] scsi0 : ata_piix
[    0.159041] scsi1 : ata_piix
[    0.159178] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
[    0.159253] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
[    0.159467] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.165151] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.165474] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.166154] mousedev: PS/2 mouse device common for all mice
[    0.166567] rtc_cmos 00:05: RTC can wake from S4
[    0.167092] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.167463] rtc_cmos 00:05: alarms up to one month, y3k, 114 bytes nvram
[    0.168065] TCP: cubic registered
[    0.168642] NET: Registered protocol family 10
[    0.169438] NET: Registered protocol family 17
[    0.170024] Using IPI Shortcut mode
[    0.170451] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.171445] PM: Hibernation image not present or could not be loaded.
[    0.171472] registered taskstats version 1
[    0.172301] rtc_cmos 00:05: setting system clock to 2013-09-22 05:59:10 UTC (1379829550)
[    0.328475] ata1.00: ATA-7: ST96023A, 3.06, max UDMA/100
[    0.328549] ata1.00: 117210240 sectors, multi 16: LBA48 
[    0.344335] ata1.00: configured for UDMA/100
[    0.344628] scsi 0:0:0:0: Direct-Access     ATA      ST96023A         3.06 PQ: 0 ANSI: 5
[    0.345100] sd 0:0:0:0: [sda] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    0.345320] sd 0:0:0:0: [sda] Write Protect is off
[    0.345394] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.345442] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.392456]  sda: sda1 sda2 < sda5 >
[    0.393021] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.416192] EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
[    0.417041] EXT4-fs (sda1): couldn't mount as ext2 due to feature incompatibilities
[    0.445035] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    0.445176] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    0.480291] devtmpfs: mounted
[    0.480733] Freeing unused kernel memory: 320K (c1445000 - c1495000)
[    0.480953] Write protecting the kernel text: 3200k
[    0.481161] Write protecting the kernel read-only data: 936k
[    1.140030] tsc: Refined TSC clocksource calibration: 1196.015 MHz
[    1.294630] stty (34) used greatest stack depth: 6536 bytes left
[    2.140104] Switched to clocksource tsc
[    2.312414] systemd-udevd[144]: starting version 204
[    3.282560] intel_rng: FWH not detected
[    3.374708] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.375160] modprobe (194) used greatest stack depth: 6496 bytes left
[    3.392488] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    3.396045] ACPI: Lid Switch [LID]
[    3.396352] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    3.396478] ACPI: Sleep Button [SLPB]
[    3.396668] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.396787] ACPI: Power Button [PWRF]
[    3.397208] modprobe (204) used greatest stack depth: 6368 bytes left
[    3.412233] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    3.412436] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/LNXVIDEO:00/input/input4
[    3.473722] Floppy drive(s): fd0 is 1.44M
[    3.491029] FDC 0 is a National Semiconductor PC87306
[    3.586061] ACPI: Requesting acpi_cpufreq
[    3.586704] tsc: Marking TSC unstable due to TSC halts in idle
[    3.587061] ACPI: acpi_idle registered with cpuidle
[    3.593299] Switched to clocksource acpi_pm
[    3.632987] modprobe (201) used greatest stack depth: 6344 bytes left
[    3.689632] parport_pc 00:0a: reported by Plug and Play ACPI
[    3.689763] parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    3.705859] ACPI: AC Adapter [AC] (on-line)
[    3.706512] modprobe (221) used greatest stack depth: 6052 bytes left
[    3.916377] pci 0000:00:1e.0: setting latency timer to 64
[    3.916518] yenta_cardbus 0000:01:00.0: CardBus bridge found [1014:0185]
[    4.044498] yenta_cardbus 0000:01:00.0: ISA IRQ mask 0x0418, PCI irq 11
[    4.044588] yenta_cardbus 0000:01:00.0: Socket status: 30000006
[    4.044673] yenta_cardbus 0000:01:00.0: pcmcia: parent PCI bridge window: [io  0x3000-0x7fff]
[    4.044794] yenta_cardbus 0000:01:00.0: pcmcia: parent PCI bridge window: [mem 0xd0200000-0xdfffffff]
[    4.044916] pcmcia_socket pcmcia_socket0: cs: memory probe 0xd0200000-0xdfffffff:
[    4.045037]  excluding 0xd0200000-0xd09fffff 0xd3a00000-0xdc1fffff 0xdfa00000-0xe01fffff
[    4.045252] yenta_cardbus 0000:01:00.0: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf7ffffff pref]
[    4.046299] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xf7ffffff:
[    4.046427]  excluding 0xf0000000-0xf7ffffff
[    4.048862] yenta_cardbus 0000:01:00.1: CardBus bridge found [1014:0185]
[    4.103726] ACPI: Battery Slot [BAT0] (battery absent)
[    4.114522] [drm] Initialized drm 1.1.0 20060810
[    4.120283] thermal LNXTHERM:00: registered as thermal_zone0
[    4.120628] ACPI: Thermal Zone [THM0] (39 C)
[    4.176399] yenta_cardbus 0000:01:00.1: ISA IRQ mask 0x0418, PCI irq 5
[    4.176493] yenta_cardbus 0000:01:00.1: Socket status: 30000006
[    4.176583] yenta_cardbus 0000:01:00.1: pcmcia: parent PCI bridge window: [io  0x3000-0x7fff]
[    4.176709] yenta_cardbus 0000:01:00.1: pcmcia: parent PCI bridge window: [mem 0xd0200000-0xdfffffff]
[    4.176837] pcmcia_socket pcmcia_socket1: cs: memory probe 0xd0200000-0xdfffffff:
[    4.176962]  excluding 0xd0200000-0xd09fffff 0xd3a00000-0xdc1fffff 0xdfa00000-0xe01fffff
[    4.177198] yenta_cardbus 0000:01:00.1: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xf7ffffff pref]
[    4.177338] pcmcia_socket pcmcia_socket1: cs: memory probe 0xf0000000-0xf7ffffff:
[    4.177476]  excluding 0xf0000000-0xf7ffffff
[    4.248539] airo(): Probing for PCI adapters
[    4.249145] airo(): Found an MPI350 card
[    4.369081] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    4.369426] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.369755] thinkpad_acpi: ThinkPad BIOS 1KET48WW (1.09 ), EC 1KHT18WW-1.06
[    4.376938] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    4.401576] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.410609] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
[    4.432665] ACPI: bus type USB registered
[    4.433107] usbcore: registered new interface driver usbfs
[    4.433497] usbcore: registered new interface driver hub
[    4.436192] usbcore: registered new device driver usb
[    4.678712] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.678804] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.889435] snd_intel8x0 0000:00:1f.5: setting latency timer to 64
[    4.905780] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.976215] uhci_hcd: USB Universal Host Controller Interface driver
[    5.201428] airo(eth0): Firmware version 5.2.19
[    5.201782] airo(eth0): WPA unsupported with firmware versions older than 5.30.17.
[    5.202393] airo(eth0): MAC enabled 00:02:8a:25:27:a8
[    5.203251] airo(): Finished probing for PCI adapters
[    5.204042] modprobe (250) used greatest stack depth: 5660 bytes left
[    5.272101] firewire_ohci 0000:01:00.2: added OHCI v1.0 device as card 0, 4 IR + 4 IT contexts, quirks 0x11
[    5.273549] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 11
[    5.299621] snd_intel8x0m: `-2' invalid for parameter `index'
[    5.352404] e100 0000:01:08.0 eth1: addr 0xd0204000, irq 11, MAC addr 00:09:6b:a0:c7:55
[    5.393007] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    5.456060] intel8x0_measure_ac97_clock: measured 55351 usecs (2660 samples)
[    5.456156] intel8x0: clocking to 48000
[    5.457775] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.457791] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.457888] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    5.458057] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
[    5.458342] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.458426] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.458553] usb usb1: Product: UHCI Host Controller
[    5.458641] usb usb1: Manufacturer: Linux 3.12.0-rc1-00273-g2457aaf uhci_hcd
[    5.458724] usb usb1: SerialNumber: 0000:00:1d.0
[    5.459174] hub 1-0:1.0: USB hub found
[    5.459269] hub 1-0:1.0: 2 ports detected
[    5.459729] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.459739] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.459829] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    5.460306] uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
[    5.460520] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.460603] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.460724] usb usb2: Product: UHCI Host Controller
[    5.460800] usb usb2: Manufacturer: Linux 3.12.0-rc1-00273-g2457aaf uhci_hcd
[    5.460880] usb usb2: SerialNumber: 0000:00:1d.1
[    5.462106] hub 2-0:1.0: USB hub found
[    5.462204] hub 2-0:1.0: 2 ports detected
[    5.468332] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.468346] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.468699] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    5.469359] uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
[    5.469833] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.470177] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.470795] usb usb3: Product: UHCI Host Controller
[    5.471127] usb usb3: Manufacturer: Linux 3.12.0-rc1-00273-g2457aaf uhci_hcd
[    5.471452] usb usb3: SerialNumber: 0000:00:1d.2
[    5.471843] hub 3-0:1.0: USB hub found
[    5.471934] hub 3-0:1.0: 2 ports detected
[    5.548431] microcode: CPU0 sig=0x6b4, pf=0x20, revision=0x2
[    5.608302] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.796271] firewire_core 0000:01:00.2: created device fw0: GUID 00061b0201022780, S400
[    6.208124] pcmcia_socket pcmcia_socket1: cs: memory probe 0x0c0000-0x0fffff:
[    6.208225]  excluding 0xc0000-0xc7fff 0xcc000-0xcffff 0xdc000-0xfffff
[    6.208440] pcmcia_socket pcmcia_socket1: cs: memory probe 0xa0000000-0xa0ffffff:
[    6.208584]  clean.
[    6.208699] pcmcia_socket pcmcia_socket1: cs: memory probe 0x60000000-0x60ffffff:
[    6.208841]  clean.
[    6.209331] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
[    6.209413]  excluding 0xc0000-0xc7fff 0xcc000-0xcffff 0xdc000-0xfffff
[    6.209626] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
[    6.209769]  clean.
[    6.209882] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
[    6.210025]  clean.
[    6.221726] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
[    6.536657] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    6.554355] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input7
[    6.566122] systemd-udevd[187]: renamed network interface eth1 to rename4
[    6.568442] systemd-udevd[198]: renamed network interface eth0 to eth1
[    6.617019] systemd-udevd[187]: renamed network interface rename4 to eth0
[    7.889616] [drm:i915_dump_device_info], i915 device info: gen=2, pciid=0x3577 flags=is_mobile,cursor_needs_physical,has_overlay,overlay_needs_physical,
[    7.889791] [drm] Memory usable by graphics device = 128M
[    7.889878] [drm:i915_gem_gtt_init], GMADR size = 128M
[    7.889884] [drm:i915_gem_gtt_init], GTT stolen size = 8M
[    7.889904] i915 0000:00:02.0: setting latency timer to 64
[    7.890801] [drm:intel_detect_pch], No PCH found?
[    7.891800] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[    7.891808] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[    7.891838] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    7.891922] [drm] Driver supports precise vblank timestamp query.
[    7.891998] [drm:init_vbt_defaults], Set default to SSC at 66MHz
[    7.892147] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 0 lvds_use_ssc 0 lvds_ssc_freq 48 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    7.892157] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    7.892166] [drm:parse_sdvo_device_mapping], different child size is found. Invalid.
[    7.892172] [drm:parse_device_mapping], different child size is found. Invalid.
[    7.892185] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    7.892224] [drm] applying pipe a force quirk
[    7.892302] [drm:intel_modeset_init], 2 display pipes available.
[    7.892316] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    7.892330] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    7.892337] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
[    7.892349] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    7.893051] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 2
[    7.893324] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus dpb. force bit now 1
[    7.893332] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 2
[    7.893596] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus dpb. force bit now 1
[    7.893602] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 2
[    7.893865] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus dpb. force bit now 1
[    7.893872] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus ssc. force bit now 2
[    7.896475] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus ssc. force bit now 1
[    7.896737] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, 7fff000]
[    7.900632] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
[    7.900994] [drm] initialized overlay support
[    7.901095] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: enabled
[    7.901109] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
[    7.901118] [drm:intel_modeset_readout_hw_state], [ENCODER:6:DAC-6] hw state readout: disabled, pipe=0
[    7.901128] [drm:intel_modeset_readout_hw_state], [ENCODER:7:None-7] hw state readout: enabled, pipe=0
[    7.902007] [drm:intel_modeset_readout_hw_state], [CONNECTOR:8:LVDS-1] hw state readout: enabled
[    7.902016] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:VGA-1] hw state readout: disabled
[    7.902026] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    7.902034] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    7.902039] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    7.902045] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    7.902053] [drm:intel_dump_pipe_config], requested mode:
[    7.902059] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1024 0 0 0 768 0 0 0 0x0 0x0
[    7.902070] [drm:intel_dump_pipe_config], adjusted mode:
[    7.902075] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 65000 0 0 0 0 0 0 0 0 0x0 0x5
[    7.902086] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    7.902093] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    7.902099] [drm:intel_dump_pipe_config], ips: 0
[    7.907088] [drm:intel_sanitize_crtc], [CRTC:4] hw state adjusted, was enabled, now disabled
[    7.907096] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    7.907102] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    7.907107] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    7.907113] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    7.907121] [drm:intel_dump_pipe_config], requested mode:
[    7.907126] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 640 0 0 0 480 0 0 0 0x0 0x0
[    7.907137] [drm:intel_dump_pipe_config], adjusted mode:
[    7.907142] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 25153 0 0 0 0 0 0 0 0 0x0 0x0
[    7.907152] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    7.907159] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    7.907165] [drm:intel_dump_pipe_config], ips: 0
[    7.908055] [drm:intel_connector_check_state], [CONNECTOR:8:LVDS-1]
[    7.908064] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    7.908071] [drm:check_encoder_state], [ENCODER:7:None-7]
[    7.908078] [drm:check_crtc_state], [CRTC:3]
[    7.908092] [drm:check_crtc_state], [CRTC:4]
[    7.908116] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1]
[    7.908123] [drm:intel_dvo_detect], [CONNECTOR:8:LVDS-1]
[    7.908389] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    7.908406] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1] probed modes :
[    7.908413] [drm:drm_mode_debug_printmodeline], Modeline 9:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[    7.908426] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    7.908433] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[    7.908698] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    7.908704] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    7.908713] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[    7.908720] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[    7.908982] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    7.908989] [drm:drm_setup_crtcs], 
[    7.908995] [drm:drm_enable_connectors], connector 8 enabled? yes
[    7.909001] [drm:drm_enable_connectors], connector 5 enabled? no
[    7.909007] [drm:drm_target_preferred], looking for cmdline mode on connector 8
[    7.909013] [drm:drm_target_preferred], looking for preferred mode on connector 8
[    7.909019] [drm:drm_target_preferred], found mode 1024x768
[    7.909025] [drm:drm_setup_crtcs], picking CRTCs for 2048x2048 config
[    7.909033] [drm:drm_setup_crtcs], desired mode 1024x768 set on crtc 3
[    7.920215] [drm:intelfb_create], allocated 1024x768 fb: 0x00060000, bo dbf002a0
[    7.920589] fbcon: inteldrmfb (fb0) is primary device
[    7.922051] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[    7.922058] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    7.922062] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    7.922072] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    7.922082] [drm:drm_mode_debug_printmodeline], Modeline 10:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[    7.922086] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
[    7.922094] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[    7.922102] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    7.922113] [drm:connected_sink_compute_bpp], [CONNECTOR:8:LVDS-1] checking for sink bpp constrains
[    7.922121] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    7.922126] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    7.922130] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    7.922134] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    7.922140] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    7.922142] [drm:intel_dump_pipe_config], requested mode:
[    7.922152] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[    7.922155] [drm:intel_dump_pipe_config], adjusted mode:
[    7.922164] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[    7.922169] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    7.922173] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    7.922176] [drm:intel_dump_pipe_config], ips: 0
[    7.981163] [drm:i9xx_update_plane], Writing base 00060000 00000000 0 0 4096
[    7.981173] [drm:intel_crtc_mode_set], [ENCODER:7:None-7] set [MODE:0:1024x768]
[    7.983745] VR00: 0xa202
[    7.984627] VR01: 0x0000
[    7.985485] VR30: 0x0000
[    7.987171] VR40: 0x3400
[    7.988058] VR80: 0x0000
[    7.989418] VR81: 0x0000
[    7.991089] VR82: 0x000a
[    7.991955] VR83: 0x000a
[    7.992851] VR84: 0x000a
[    7.993709] VR85: 0x000a
[    7.994566] VR86: 0x000a
[    7.995423] VR87: 0x000a
[    8.008346] VR88: 0x000a
[    8.009215] VR8E: 0x0002
[    8.010072] VR8F: 0x0003
[    8.010089] [drm:i830_get_fifo_size], FIFO size - (0x00017e5f) A: 47
[    8.010094] [drm:intel_calculate_wm], FIFO entries required for mode: 41
[    8.010097] [drm:intel_calculate_wm], FIFO watermark level: 4
[    8.010101] [drm:i830_update_wm], Setting FIFO watermarks - A: 4
[    8.010106] ------------[ cut here ]------------
[    8.010232] WARNING: CPU: 0 PID: 190 at drivers/gpu/drm/i915/intel_display.c:1096 assert_pipe+0x80/0xe0 [i915]()
[    8.010235] pipe A assertion failure (expected on, current off)
[    8.010297] Modules linked in: i915(+) psmouse serio_raw microcode evdev pcspkr uhci_hcd ehci_hcd snd_intel8x0 snd_ac97_codec ac97_bus i2c_algo_bit snd_pcm e100 mii firewire_ohci firewire_core drm_kms_helper snd_page_alloc usbcore thinkpad_acpi pcmcia snd_seq airo crc_itu_t thermal battery drm snd_seq_device snd_timer snd yenta_socket pcmcia_rsrc pcmcia_core ac parport_pc parport acpi_cpufreq processor soundcore rfkill floppy video button shpchp i2c_i801 thermal_sys rng_core i2c_core usb_common
[    8.010305] CPU: 0 PID: 190 Comm: modprobe Not tainted 3.12.0-rc1-00273-g2457aaf #31
[    8.010308] Hardware name: IBM 26724XG/26724XG, BIOS 1KET48WW (1.09 ) 06/16/2006
[    8.010319]  c131b486 c102e155 e0896850 c00438c8 000000be e08954a4 00000448 e08504d0
[    8.010328]  e08504d0 ddae8000 00000041 00000000 00000000 c102e1a3 00000009 c00438b0
[    8.010337]  e0896850 c00438c8 e08504d0 e08954a4 00000448 e0896850 00000041 e089c976
[    8.010338] Call Trace:
[    8.010356]  [<c131b486>] ? dump_stack+0xa/0x13
[    8.010364]  [<c102e155>] ? warn_slowpath_common+0x75/0x90
[    8.010423]  [<e08504d0>] ? assert_pipe+0x80/0xe0 [i915]
[    8.010479]  [<e08504d0>] ? assert_pipe+0x80/0xe0 [i915]
[    8.010486]  [<c102e1a3>] ? warn_slowpath_fmt+0x33/0x40
[    8.010543]  [<e08504d0>] ? assert_pipe+0x80/0xe0 [i915]
[    8.010600]  [<e0850c2d>] ? i9xx_crtc_enable+0xcd/0x3f0 [i915]
[    8.010660]  [<e0856e7c>] ? __intel_set_mode+0x76c/0x12b0 [i915]
[    8.010723]  [<e0859b4d>] ? intel_set_mode+0x1d/0x40 [i915]
[    8.010782]  [<e085a3df>] ? intel_crtc_set_config+0x77f/0x960 [i915]
[    8.010814]  [<e19b5803>] ? drm_mode_set_config_internal+0x43/0xb0 [drm]
[    8.010827]  [<e211e215>] ? drm_fb_helper_set_par+0x45/0xb0 [drm_kms_helper]
[    8.010835]  [<c11b1862>] ? fbcon_init+0x482/0x4d0
[    8.010844]  [<c11ef07e>] ? set_inverse_trans_unicode.isra.4+0xfe/0x120
[    8.010851]  [<c11f03a6>] ? visual_init+0x96/0xf0
[    8.010858]  [<c11f2524>] ? do_bind_con_driver+0x104/0x2d0
[    8.010869]  [<c1105446>] ? sysfs_add_file_mode+0x76/0xa0
[    8.010875]  [<c11f2bc6>] ? do_take_over_console+0xf6/0x190
[    8.010882]  [<c11ad477>] ? do_fbcon_takeover+0x57/0xc0
[    8.010891]  [<c10477d6>] ? notifier_call_chain+0x46/0x60
[    8.010898]  [<c1047a07>] ? __blocking_notifier_call_chain+0x37/0x50
[    8.010904]  [<c1047a37>] ? blocking_notifier_call_chain+0x17/0x20
[    8.010914]  [<c11a5a60>] ? register_framebuffer+0x1b0/0x2d0
[    8.010924]  [<e211df25>] ? drm_fb_helper_initial_config+0x2e5/0x490 [drm_kms_helper]
[    8.010944]  [<e19b4493>] ? drm_mode_config_reset+0x93/0xb0 [drm]
[    8.010956]  [<c10b1781>] ? __kmalloc+0xb1/0xe0
[    8.010965]  [<e211d2e8>] ? drm_fb_helper_single_add_all_connectors+0x58/0xa0 [drm_kms_helper]
[    8.011015]  [<e0830c8f>] ? i915_driver_load+0xeef/0xf30 [i915]
[    8.011062]  [<e082db90>] ? i915_emit_breadcrumb+0xe0/0xe0 [i915]
[    8.011086]  [<e19b22ae>] ? drm_get_pci_dev+0xfe/0x2a0 [drm]
[    8.011095]  [<c11970e3>] ? pci_device_probe+0x63/0xb0
[    8.011107]  [<c120c310>] ? __device_attach+0x30/0x30
[    8.011114]  [<c120c163>] ? driver_probe_device+0x53/0x1d0
[    8.011125]  [<c117608a>] ? kobject_add_internal+0x7a/0x2a0
[    8.011131]  [<c120c381>] ? __driver_attach+0x71/0x80
[    8.011138]  [<c120a9df>] ? bus_for_each_dev+0x3f/0x70
[    8.011144]  [<c120bd66>] ? driver_attach+0x16/0x20
[    8.011151]  [<c120c310>] ? __device_attach+0x30/0x30
[    8.011157]  [<c120ba1f>] ? bus_add_driver+0x19f/0x250
[    8.011164]  [<c120c851>] ? driver_register+0x51/0xd0
[    8.011171]  [<e0800000>] ? 0xe07fffff
[    8.011176]  [<e0800000>] ? 0xe07fffff
[    8.011183]  [<c1000402>] ? do_one_initcall+0xe2/0x130
[    8.011193]  [<c10a6bf0>] ? __vunmap+0x80/0xe0
[    8.011200]  [<c10b151e>] ? kfree+0x8e/0xc0
[    8.011206]  [<c10a6bd7>] ? __vunmap+0x67/0xe0
[    8.011212]  [<c10a6bd7>] ? __vunmap+0x67/0xe0
[    8.011218]  [<c10b151e>] ? kfree+0x8e/0xc0
[    8.011226]  [<c106c59b>] ? load_module+0x151b/0x1cd0
[    8.011239]  [<c106cdbb>] ? SyS_init_module+0x6b/0xa0
[    8.011254]  [<c131e981>] ? sysenter_do_call+0x12/0x22
[    8.011258] ---[ end trace f023ad1d5635ec00 ]---
[    8.070299] [drm:intel_connector_check_state], [CONNECTOR:8:LVDS-1]
[    8.070309] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    8.070314] [drm:check_encoder_state], [ENCODER:7:None-7]
[    8.070319] [drm:check_crtc_state], [CRTC:3]
[    8.070339] [drm:check_crtc_state], [CRTC:4]
[    8.070353] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    8.070362] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    8.070399] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[    8.071137] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[    8.071146] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    8.071152] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[    8.086737] Console: switching to colour frame buffer device 128x48
[    8.086862] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[    8.086868] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    8.086874] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[    8.456640] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.461816] i915 0000:00:02.0: registered panic notifier
[    8.468629] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    8.480340] modprobe (190) used greatest stack depth: 5320 bytes left
[    9.613209] Adding 1028092k swap on /dev/sda5.  Priority:-1 extents:1 across:1028092k 
[    9.673629] EXT4-fs (sda1): re-mounted. Opts: (null)
[    9.927379] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   10.857110] fuse init (API version 7.22)
[   10.916585] loop: module loaded
[   12.661826] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.995892] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[   12.995902] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   12.995909] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   14.779583] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input8
[   16.325067] Bluetooth: Core ver 2.16
[   16.332596] NET: Registered protocol family 31
[   16.338996] Bluetooth: HCI device and connection manager initialized
[   16.345531] Bluetooth: HCI socket layer initialized
[   16.353109] Bluetooth: L2CAP socket layer initialized
[   16.360165] Bluetooth: SCO socket layer initialized
[   16.432300] Bluetooth: RFCOMM TTY layer initialized
[   16.439630] Bluetooth: RFCOMM socket layer initialized
[   16.445820] Bluetooth: RFCOMM ver 1.11
[   16.490518] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   16.496439] Bluetooth: BNEP filters: protocol multicast
[   16.504884] Bluetooth: BNEP socket layer initialized
[   18.157283] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[   18.157294] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   18.157303] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   18.496058] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   18.496352] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   18.496360] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   20.715113] [drm:i915_driver_open], 
[   20.715253] [drm:intel_crtc_cursor_set], cursor off
[   20.715263] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[   20.715278] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   20.715289] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   20.715298] [drm:intel_crtc_cursor_set], cursor off
[   20.715304] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[   20.715311] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   20.715319] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   20.715418] [drm:i915_driver_open], 
[   20.715598] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   20.737028] [drm:intel_crtc_cursor_set], cursor off
[   20.737037] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[   20.737048] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   20.737058] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   20.737067] [drm:intel_crtc_cursor_set], cursor off
[   20.737073] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[   20.737079] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   20.737087] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   20.737410] [drm:i915_driver_open], 
[   20.737480] [drm:intel_crtc_cursor_set], cursor off
[   20.737488] [drm:intel_crtc_set_config], [CRTC:3] [FB:11] #connectors=1 (x y) (0 0)
[   20.737498] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   20.737506] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   20.737513] [drm:intel_crtc_cursor_set], cursor off
[   20.737519] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[   20.737525] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   20.737533] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   20.737627] [drm:i915_driver_open], 
[   20.738536] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   20.738550] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[2] ENCODERS[2]
[   20.738698] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   20.738709] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1]
[   20.738717] [drm:intel_dvo_detect], [CONNECTOR:8:LVDS-1]
[   20.738997] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   20.739016] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1] probed modes :
[   20.739024] [drm:drm_mode_debug_printmodeline], Modeline 9:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[   20.739043] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   20.739607] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   20.739619] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   20.739627] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   20.739896] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.739903] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   20.739912] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   20.739919] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   20.741434] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.741452] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   20.741460] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   20.741467] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   20.741732] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.741739] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   20.741746] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   20.741753] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   20.742015] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.742141] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   20.742151] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1]
[   20.742157] [drm:intel_dvo_detect], [CONNECTOR:8:LVDS-1]
[   20.742422] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   20.742438] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1] probed modes :
[   20.742445] [drm:drm_mode_debug_printmodeline], Modeline 9:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[   20.742461] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   20.744856] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   20.744867] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   20.744874] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   20.745142] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.745148] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   20.745156] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   20.745163] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   20.745426] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.745436] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   20.745444] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   20.745450] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   20.745713] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.745719] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   20.745727] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   20.745733] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   20.745995] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   20.867626] [drm:drm_mode_addfb], [FB:12]
[   20.867802] [drm:drm_mode_setcrtc], [CRTC:3]
[   20.867818] [drm:drm_mode_setcrtc], [CONNECTOR:8:LVDS-1]
[   20.867828] [drm:intel_crtc_set_config], [CRTC:3] [FB:12] #connectors=1 (x y) (0 0)
[   20.867840] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=1
[   20.867851] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   20.879817] [drm:i9xx_update_plane], Writing base 00400000 00000000 0 0 4096
[   20.900198] [drm:drm_mode_setcrtc], [CRTC:4]
[   20.900217] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[   20.900229] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[   20.900239] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:LVDS-1] to [CRTC:3]
[   28.512107] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   28.512415] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   28.512422] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   30.660819] [drm:intel_dvo_detect], [CONNECTOR:8:LVDS-1]
[   30.660894] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   30.661177] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   30.661185] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   30.661194] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   30.661202] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   31.054007] [drm:i8xx_irq_handler], pipe B underrun
[   38.528091] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   38.528382] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   38.528390] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   48.544099] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   48.544395] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   48.544403] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   50.820224] e100 0000:01:08.0 eth0: NIC Link is Up 100 Mbps Full Duplex
[   50.820449] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   58.560104] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   58.560397] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   58.560405] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   64.242801] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   64.242828] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1]
[   64.242837] [drm:intel_dvo_detect], [CONNECTOR:8:LVDS-1]
[   64.243116] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   64.243139] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1] probed modes :
[   64.243147] [drm:drm_mode_debug_printmodeline], Modeline 9:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[   64.243168] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   64.243829] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   64.243840] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   64.243848] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   64.244728] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.244737] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   64.244748] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   64.244755] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   64.245019] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.245032] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   64.245040] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   64.245046] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   64.245310] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.245316] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   64.245323] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   64.245330] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   64.245591] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.246377] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   64.246387] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1]
[   64.246394] [drm:intel_dvo_detect], [CONNECTOR:8:LVDS-1]
[   64.246660] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   64.246675] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1] probed modes :
[   64.246683] [drm:drm_mode_debug_printmodeline], Modeline 9:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[   64.246699] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   64.247275] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   64.247284] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   64.247291] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   64.252165] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.252186] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   64.252199] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   64.252208] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   64.252482] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.252514] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   64.252524] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   64.252530] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   64.252794] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.252800] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   64.252807] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   64.252814] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   64.253076] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.906158] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   64.906187] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1]
[   64.906195] [drm:intel_dvo_detect], [CONNECTOR:8:LVDS-1]
[   64.906477] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   64.906502] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:LVDS-1] probed modes :
[   64.906510] [drm:drm_mode_debug_printmodeline], Modeline 9:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x8 0x5
[   64.906530] [drm:drm_mode_getconnector], [CONNECTOR:8:?]
[   64.907192] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   64.907203] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   64.907211] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   64.907478] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.907485] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   64.907495] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   64.907502] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   64.907765] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.907776] [drm:drm_mode_getconnector], [CONNECTOR:5:?]
[   64.907783] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[   64.907789] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[   64.908053] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   64.908059] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   64.908066] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[   64.908073] [drm:intel_get_load_detect_pipe], no pipe available for load-detect
[   64.912592] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   68.576075] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   68.576362] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   68.576368] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   78.592096] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   78.592385] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   78.592392] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   88.608160] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   88.608450] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   88.608457] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]

-- 
Meelis Roos (mroos@linux.ee)
