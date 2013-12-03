Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3LCWMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:12:49 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61087 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3LCWMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:12:46 -0500
Date: Tue, 3 Dec 2013 23:13:30 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [i915] WARNING: [...] drivers/gpu/drm/i915/intel_display.c:9948
 intel_get_pipe_from_connector
Message-ID: <20131203221330.GW27344@phenom.ffwll.local>
Mail-Followup-To: Paul Bolle <pebolle@tiscali.nl>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	David Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1385843936.10971.5.camel@x41.thuisdomein>
 <CAKMK7uHRW-1OiMY44s2G9dwbbQLMUxZ4fHf=Eaf9gJ_WASpvLQ@mail.gmail.com>
 <1385917025.7199.4.camel@x41.thuisdomein>
 <CAKMK7uE_L8cqyYk6mQ4paXeh2m7tmoMXRv_KxoAeBq9MEAnFqw@mail.gmail.com>
 <1385978027.2972.3.camel@x41.thuisdomein>
 <CAKMK7uE=Wr95XM85XVS1nT_8cV4e1Z_SubSVjQyP8BuLz-bTQg@mail.gmail.com>
 <1386007525.9830.4.camel@x41.thuisdomein>
 <20131203151935.GD27344@phenom.ffwll.local>
 <1386108185.2552.5.camel@x41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386108185.2552.5.camel@x41.thuisdomein>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:03:05PM +0100, Paul Bolle wrote:
> On Tue, 2013-12-03 at 16:19 +0100, Daniel Vetter wrote:
> > I'd like to confirm the actual cause (I suspect that we switch
> > pipes&planes around) for why you see this but other machines don't show
> > this to augment the commit message. But I've merged the fix already.
> 
> The dmesg, up to and including the WARNING, is attached. Have fun! 

Yeah, we have a machine where we want to switch planes/pipes and it all
blows to pieces while we try to fix that up. Usually the bios does that
already, so no need for us to change anything. And it's only used on old
gen2/3 machines.

Theory perfectly confirmed, thanks ;-)
-Daniel

> 
> 
> Paul Bolle
> 
> <6>[    0.000000] Initializing cgroup subsys cpuset
> <6>[    0.000000] Initializing cgroup subsys cpu
> <6>[    0.000000] Initializing cgroup subsys cpuacct
> <5>[    0.000000] Linux version 3.13.0-0.rc2.1.local1.fc18.i686 ([...]) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #1 SMP Sun Dec 1 11:58:49 CET 2013
> <6>[    0.000000] Disabled fast string operations
> <6>[    0.000000] e820: BIOS-provided physical RAM map:
> <6>[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
> <6>[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000000d0000-0x00000000000d3fff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007f6dffff] usable
> <6>[    0.000000] BIOS-e820: [mem 0x000000007f6e0000-0x000000007f6f4fff] ACPI data
> <6>[    0.000000] BIOS-e820: [mem 0x000000007f6f5000-0x000000007f6fffff] ACPI NVS
> <6>[    0.000000] BIOS-e820: [mem 0x000000007f700000-0x000000007fffffff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000f0008000-0x00000000f000bfff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000fed14000-0x00000000fed19fff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000fed20000-0x00000000fed8ffff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> <6>[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> <5>[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
> <6>[    0.000000] SMBIOS 2.3 present.
> <7>[    0.000000] DMI: IBM 2525FAG/2525FAG, BIOS 74ET61WW (2.06 ) 03/14/2006
> <7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> <7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> <6>[    0.000000] e820: last_pfn = 0x7f6e0 max_arch_pfn = 0x100000
> <7>[    0.000000] MTRR default type: uncachable
> <7>[    0.000000] MTRR fixed ranges enabled:
> <7>[    0.000000]   00000-9FFFF write-back
> <7>[    0.000000]   A0000-BFFFF uncachable
> <7>[    0.000000]   C0000-CFFFF write-protect
> <7>[    0.000000]   D0000-DBFFF uncachable
> <7>[    0.000000]   DC000-DFFFF write-back
> <7>[    0.000000]   E0000-FFFFF write-protect
> <7>[    0.000000] MTRR variable ranges enabled:
> <7>[    0.000000]   0 base 000000000 mask F80000000 write-back
> <7>[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
> <7>[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
> <7>[    0.000000]   3 disabled
> <7>[    0.000000]   4 disabled
> <7>[    0.000000]   5 disabled
> <7>[    0.000000]   6 disabled
> <7>[    0.000000]   7 disabled
> <6>[    0.000000] PAT not supported by CPU.
> <7>[    0.000000] initial memory mapped: [mem 0x00000000-0x013fffff]
> <7>[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> <6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> <7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> <6>[    0.000000] init_memory_mapping: [mem 0x36c00000-0x36ffffff]
> <7>[    0.000000]  [mem 0x36c00000-0x36ffffff] page 2M
> <6>[    0.000000] init_memory_mapping: [mem 0x30000000-0x36bfffff]
> <7>[    0.000000]  [mem 0x30000000-0x36bfffff] page 2M
> <6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
> <7>[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
> <7>[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
> <6>[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fdfff]
> <7>[    0.000000]  [mem 0x37000000-0x373fdfff] page 4k
> <7>[    0.000000] BRK [0x00e6d000, 0x00e6dfff] PGTABLE
> <7>[    0.000000] BRK [0x00e6e000, 0x00e6ffff] PGTABLE
> <6>[    0.000000] RAMDISK: [mem 0x33f7c000-0x35fb5fff]
> <5>[    0.000000] ACPI: RSDP 000f6c00 000024 (v02 IBM   )
> <5>[    0.000000] ACPI: XSDT 7f6e4770 00005C (v01 IBM    TP-74    00002060  LTP 00000000)
> <5>[    0.000000] ACPI: FACP 7f6e4800 0000F4 (v03 IBM    TP-74    00002060 IBM  00000001)
> <5>[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe1Block: 0/32 (20131115/tbfadt-572)
> <5>[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20131115/tbfadt-603)
> <5>[    0.000000] ACPI: DSDT 7f6e49e7 01038A (v01 IBM    TP-74    00002060 MSFT 0100000E)
> <5>[    0.000000] ACPI: FACS 7f6f6000 000040
> <5>[    0.000000] ACPI: SSDT 7f6e49b4 000033 (v01 IBM    TP-74    00002060 MSFT 0100000E)
> <5>[    0.000000] ACPI: ECDT 7f6f4d71 000052 (v01 IBM    TP-74    00002060 IBM  00000001)
> <5>[    0.000000] ACPI: TCPA 7f6f4dc3 000032 (v01 IBM    TP-74    00002060 PTL  00000001)
> <5>[    0.000000] ACPI: APIC 7f6f4df5 00005A (v01 IBM    TP-74    00002060 IBM  00000001)
> <5>[    0.000000] ACPI: MCFG 7f6f4e4f 00003E (v01 IBM    TP-74    00002060 IBM  00000001)
> <5>[    0.000000] ACPI: BOOT 7f6f4fd8 000028 (v01 IBM    TP-74    00002060  LTP 00000001)
> <7>[    0.000000] ACPI: Local APIC address 0xfee00000
> <5>[    0.000000] 1154MB HIGHMEM available.
> <5>[    0.000000] 883MB LOWMEM available.
> <6>[    0.000000]   mapped low ram: 0 - 373fe000
> <6>[    0.000000]   low ram: 0 - 373fe000
> <7>[    0.000000] BRK [0x00e70000, 0x00e70fff] PGTABLE
> <5>[    0.000000] Zone ranges:
> <5>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> <5>[    0.000000]   Normal   [mem 0x01000000-0x373fdfff]
> <5>[    0.000000]   HighMem  [mem 0x373fe000-0x7f6dffff]
> <5>[    0.000000] Movable zone start for each node
> <5>[    0.000000] Early memory node ranges
> <5>[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> <5>[    0.000000]   node   0: [mem 0x00100000-0x7f6dffff]
> <7>[    0.000000] On node 0 totalpages: 521854
> <7>[    0.000000] free_area_init_node: node 0, pgdat c0c94840, node_mem_map f640e020
> <7>[    0.000000]   DMA zone: 32 pages used for memmap
> <7>[    0.000000]   DMA zone: 0 pages reserved
> <7>[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> <7>[    0.000000]   Normal zone: 1736 pages used for memmap
> <7>[    0.000000]   Normal zone: 222206 pages, LIFO batch:31
> <7>[    0.000000]   HighMem zone: 2310 pages used for memmap
> <7>[    0.000000]   HighMem zone: 295650 pages, LIFO batch:31
> <6>[    0.000000] Using APIC driver default
> <6>[    0.000000] ACPI: PM-Timer IO Port: 0x1008
> <7>[    0.000000] ACPI: Local APIC address 0xfee00000
> <6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> <6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> <6>[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> <6>[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> <6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> <6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> <7>[    0.000000] ACPI: IRQ0 used by override.
> <7>[    0.000000] ACPI: IRQ2 used by override.
> <7>[    0.000000] ACPI: IRQ9 used by override.
> <6>[    0.000000] Using ACPI (MADT) for SMP configuration information
> <6>[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
> <7>[    0.000000] nr_irqs_gsi: 40
> <6>[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
> <6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000cffff]
> <6>[    0.000000] PM: Registered nosave memory: [mem 0x000d0000-0x000d3fff]
> <6>[    0.000000] PM: Registered nosave memory: [mem 0x000d4000-0x000dbfff]
> <6>[    0.000000] PM: Registered nosave memory: [mem 0x000dc000-0x000fffff]
> <6>[    0.000000] e820: [mem 0x80000000-0xdfffffff] available for PCI devices
> <6>[    0.000000] Booting paravirtualized kernel on bare hardware
> <6>[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
> <6>[    0.000000] PERCPU: Embedded 13 pages/cpu @f63f5000 s32704 r0 d20544 u53248
> <7>[    0.000000] pcpu-alloc: s32704 r0 d20544 u53248 alloc=13*4096
> <7>[    0.000000] pcpu-alloc: [0] 0 
> <5>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520086
> <5>[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.13.0-0.rc2.1.local1.fc18.i686 root=/dev/mapper/[...] ro rhgb LANG=en_US.UTF-8 vconsole.keymap=us-acentos quiet drm.debug=0xe 3
> <6>[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> <6>[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> <6>[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> <6>[    0.000000] Initializing CPU#0
> <6>[    0.000000] allocated 4175608 bytes of page_cgroup
> <6>[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> <6>[    0.000000] Initializing HighMem for node 0 (000373fe:0007f6e0)
> <5>[    0.000000] Memory: 2022360K/2087416K available (5906K kernel code, 572K rwdata, 2400K rodata, 728K init, 1016K bss, 65056K reserved, 1182600K highmem)
> <6>[    0.000000] virtual kernel memory layout:
>     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
>     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
>     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
>     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
>       .init : 0xc0cad000 - 0xc0d63000   ( 728 kB)
>       .data : 0xc09c4be3 - 0xc0cad000   (2977 kB)
>       .text : 0xc0400000 - 0xc09c4be3   (5906 kB)
> <6>[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> <6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> <6>[    0.000000] Hierarchical RCU implementation.
> <6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=1.
> <6>[    0.000000] NR_IRQS:2304 nr_irqs:256 16
> <7>[    0.000000] CPU 0 irqstacks, hard=f3406000 soft=f3408000
> <6>[    0.000000] Console: colour dummy device 80x25
> <6>[    0.000000] console [tty0] enabled
> <6>[    0.000000] tsc: Fast TSC calibration using PIT
> <6>[    0.000000] tsc: Detected 1595.980 MHz processor
> <6>[    0.002004] Calibrating delay loop (skipped), value calculated using timer frequency.. 3191.96 BogoMIPS (lpj=1595980)
> <6>[    0.002009] pid_max: default: 32768 minimum: 301
> <6>[    0.002077] Security Framework initialized
> <6>[    0.002095] SELinux:  Initializing.
> <7>[    0.002108] SELinux:  Starting in permissive mode
> <6>[    0.002189] Mount-cache hash table entries: 512
> <6>[    0.002561] Initializing cgroup subsys memory
> <6>[    0.002576] Initializing cgroup subsys devices
> <6>[    0.002580] Initializing cgroup subsys freezer
> <6>[    0.002583] Initializing cgroup subsys net_cls
> <6>[    0.002587] Initializing cgroup subsys blkio
> <6>[    0.002591] Initializing cgroup subsys perf_event
> <6>[    0.002634] Disabled fast string operations
> <6>[    0.002645] mce: CPU supports 5 MCE banks
> <6>[    0.002659] CPU0: Thermal monitoring enabled (TM2)
> <6>[    0.002679] Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
> Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8
> tlb_flushall_shift: 6
> <6>[    0.008992] Freeing SMP alternatives memory: 24K (c0d63000 - c0d69000)
> <6>[    0.010599] ACPI: Core revision 20131115
> <5>[    0.019971] ACPI: All ACPI Tables successfully acquired
> <6>[    0.020016] ftrace: allocating 24857 entries in 49 pages
> <6>[    0.030161] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> <6>[    0.030640] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> <6>[    0.040979] smpboot: CPU0: Intel(R) Pentium(R) M processor 1.60GHz (fam: 06, model: 0d, stepping: 08)
> <6>[    0.041000] Performance Events: p6 PMU driver.
> <6>[    0.041000] ... version:                0
> <6>[    0.041000] ... bit width:              32
> <6>[    0.041000] ... generic registers:      2
> <6>[    0.041000] ... value mask:             00000000ffffffff
> <6>[    0.041000] ... max period:             000000007fffffff
> <6>[    0.041000] ... fixed-purpose events:   0
> <6>[    0.041000] ... event mask:             0000000000000003
> <6>[    0.042667] x86: Booted up 1 node, 1 CPUs
> <6>[    0.042672] smpboot: Total of 1 processors activated (3191.96 BogoMIPS)
> <6>[    0.043045] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> <6>[    0.043357] devtmpfs: initialized
> <6>[    0.043919] PM: Registering ACPI NVS region [mem 0x7f6f5000-0x7f6fffff] (45056 bytes)
> <6>[    0.045885] atomic64 test passed for i586+ platform with CX8 and with SSE
> <6>[    0.045924] RTC time: 21:34:37, date: 12/03/13
> <6>[    0.045989] NET: Registered protocol family 16
> <6>[    0.046267] cpuidle: using governor menu
> <6>[    0.046461] ACPI: bus type PCI registered
> <6>[    0.046465] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> <6>[    0.046579] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> <6>[    0.046584] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> <6>[    0.046586] PCI: Using MMCONFIG for extended config space
> <6>[    0.046588] PCI: Using configuration type 1 for base access
> <6>[    0.048591] bio: create slab <bio-0> at 0
> <6>[    0.048726] ACPI: Added _OSI(Module Device)
> <6>[    0.048729] ACPI: Added _OSI(Processor Device)
> <6>[    0.048732] ACPI: Added _OSI(3.0 _SCP Extensions)
> <6>[    0.048734] ACPI: Added _OSI(Processor Aggregator Device)
> <6>[    0.051011] ACPI : EC: EC description table is found, configuring boot EC
> <6>[    0.187822] ACPI: Interpreter enabled
> <5>[    0.187835] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
> <5>[    0.187842] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
> <6>[    0.187861] ACPI: (supports S0 S3 S4 S5)
> <6>[    0.187864] ACPI: Using IOAPIC for interrupt routing
> <6>[    0.187897] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> <6>[    0.189759] ACPI: ACPI Dock Station Driver: 5 docks/bays found
> <6>[    0.194719] ACPI: Power Resource [PUBS] (on)
> <6>[    0.202340] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.202507] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.202672] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.202836] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.203004] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.203169] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.203333] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.203496] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
> <6>[    0.203577] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> <6>[    0.203587] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> <6>[    0.203595] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> <7>[    0.203631] acpi PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> <7>[    0.203635] acpi PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
> <7>[    0.203639] acpi PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> <7>[    0.203644] acpi PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
> <7>[    0.203647] acpi PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
> <7>[    0.203652] acpi PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
> <7>[    0.203655] PCI: root bus 00: using default resources
> <6>[    0.203891] PCI host bridge to bus 0000:00
> <6>[    0.203896] pci_bus 0000:00: root bus resource [bus 00-ff]
> <6>[    0.203900] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> <6>[    0.203904] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> <7>[    0.203918] pci 0000:00:00.0: [8086:2590] type 00 class 0x060000
> <7>[    0.204059] pci 0000:00:02.0: [8086:2592] type 00 class 0x030000
> <7>[    0.204073] pci 0000:00:02.0: reg 0x10: [mem 0xa0080000-0xa00fffff]
> <7>[    0.204082] pci 0000:00:02.0: reg 0x14: [io  0x1800-0x1807]
> <7>[    0.204090] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff pref]
> <7>[    0.204098] pci 0000:00:02.0: reg 0x1c: [mem 0xa0000000-0xa003ffff]
> <7>[    0.204215] pci 0000:00:02.1: [8086:2792] type 00 class 0x038000
> <7>[    0.204226] pci 0000:00:02.1: reg 0x10: [mem 0x00000000-0x0007ffff]
> <7>[    0.204398] pci 0000:00:1c.0: [8086:2660] type 01 class 0x060400
> <7>[    0.204517] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> <6>[    0.204587] pci 0000:00:1c.0: System wakeup disabled by ACPI
> <7>[    0.204653] pci 0000:00:1d.0: [8086:2658] type 00 class 0x0c0300
> <7>[    0.204716] pci 0000:00:1d.0: reg 0x20: [io  0x1820-0x183f]
> <6>[    0.205074] pci 0000:00:1d.0: System wakeup disabled by ACPI
> <7>[    0.205109] pci 0000:00:1d.1: [8086:2659] type 00 class 0x0c0300
> <7>[    0.205172] pci 0000:00:1d.1: reg 0x20: [io  0x1840-0x185f]
> <6>[    0.205276] pci 0000:00:1d.1: System wakeup disabled by ACPI
> <7>[    0.205328] pci 0000:00:1d.2: [8086:265a] type 00 class 0x0c0300
> <7>[    0.205391] pci 0000:00:1d.2: reg 0x20: [io  0x1860-0x187f]
> <7>[    0.205514] pci 0000:00:1d.3: [8086:265b] type 00 class 0x0c0300
> <7>[    0.205576] pci 0000:00:1d.3: reg 0x20: [io  0x1880-0x189f]
> <6>[    0.206086] pci 0000:00:1d.3: System wakeup disabled by ACPI
> <7>[    0.206151] pci 0000:00:1d.7: [8086:265c] type 00 class 0x0c0320
> <7>[    0.206179] pci 0000:00:1d.7: reg 0x10: [mem 0xa0040000-0xa00403ff]
> <7>[    0.206294] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> <6>[    0.206355] pci 0000:00:1d.7: System wakeup disabled by ACPI
> <7>[    0.206415] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> <6>[    0.206549] pci 0000:00:1e.0: System wakeup disabled by ACPI
> <7>[    0.206610] pci 0000:00:1e.2: [8086:266e] type 00 class 0x040100
> <7>[    0.206635] pci 0000:00:1e.2: reg 0x10: [io  0x1c00-0x1cff]
> <7>[    0.206649] pci 0000:00:1e.2: reg 0x14: [io  0x18c0-0x18ff]
> <7>[    0.206663] pci 0000:00:1e.2: reg 0x18: [mem 0xa0040800-0xa00409ff]
> <7>[    0.206678] pci 0000:00:1e.2: reg 0x1c: [mem 0xa0040400-0xa00404ff]
> <7>[    0.206748] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
> <7>[    0.206864] pci 0000:00:1f.0: [8086:2641] type 00 class 0x060100
> <7>[    0.206986] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
> <6>[    0.206999] pci 0000:00:1f.0: address space collision: [io  0x1000-0x107f] conflicts with ACPI CPU throttle [??? 0x00001010-0x00001015 flags 0x80000000]
> <6>[    0.207009] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
> <6>[    0.207015] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 1600-167f
> <6>[    0.207020] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 15c0-15cf
> <7>[    0.207128] pci 0000:00:1f.2: [8086:2653] type 00 class 0x010180
> <7>[    0.207150] pci 0000:00:1f.2: reg 0x10: [io  0x0000-0x0007]
> <7>[    0.207165] pci 0000:00:1f.2: reg 0x14: [io  0x0000-0x0003]
> <7>[    0.207179] pci 0000:00:1f.2: reg 0x18: [io  0x0000-0x0007]
> <7>[    0.207193] pci 0000:00:1f.2: reg 0x1c: [io  0x0000-0x0003]
> <7>[    0.207207] pci 0000:00:1f.2: reg 0x20: [io  0x1810-0x181f]
> <7>[    0.207268] pci 0000:00:1f.2: PME# supported from D3hot
> <7>[    0.207374] pci 0000:00:1f.3: [8086:266a] type 00 class 0x0c0500
> <7>[    0.207454] pci 0000:00:1f.3: reg 0x20: [io  0x18a0-0x18bf]
> <7>[    0.207693] pci 0000:02:00.0: [14e4:167d] type 00 class 0x020000
> <7>[    0.207729] pci 0000:02:00.0: reg 0x10: [mem 0xa0100000-0xa010ffff 64bit]
> <7>[    0.207908] pci 0000:02:00.0: PME# supported from D3hot D3cold
> <6>[    0.207979] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> <6>[    0.207995] pci 0000:00:1c.0: PCI bridge to [bus 02]
> <7>[    0.208011] pci 0000:00:1c.0:   bridge window [mem 0xa0100000-0xa01fffff]
> <7>[    0.208136] pci 0000:04:00.0: [1180:0476] type 02 class 0x060700
> <7>[    0.208169] pci 0000:04:00.0: reg 0x10: [mem 0xa0200000-0xa0200fff]
> <7>[    0.208218] pci 0000:04:00.0: supports D1 D2
> <7>[    0.208221] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> <7>[    0.208303] pci 0000:04:00.1: [1180:0822] type 00 class 0x080500
> <7>[    0.208334] pci 0000:04:00.1: reg 0x10: [mem 0xa0201000-0xa02010ff]
> <7>[    0.208466] pci 0000:04:00.1: supports D1 D2
> <7>[    0.208469] pci 0000:04:00.1: PME# supported from D0 D1 D2 D3hot D3cold
> <7>[    0.208567] pci 0000:04:02.0: [8086:4224] type 00 class 0x028000
> <7>[    0.208599] pci 0000:04:02.0: reg 0x10: [mem 0xa0202000-0xa0202fff]
> <7>[    0.208734] pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
> <6>[    0.208860] pci 0000:00:1e.0: PCI bridge to [bus 04-07] (subtractive decode)
> <7>[    0.208867] pci 0000:00:1e.0:   bridge window [io  0x2000-0x5fff]
> <7>[    0.208874] pci 0000:00:1e.0:   bridge window [mem 0xa0200000-0xafffffff]
> <7>[    0.208884] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
> <7>[    0.208888] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
> <7>[    0.208891] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
> <7>[    0.208962] pci_bus 0000:05: busn_res: can not insert [bus 05-ff] under [bus 04-07] (conflicts with (null) [bus 04-07])
> <7>[    0.208970] pci_bus 0000:05: busn_res: [bus 05-ff] end is updated to 06
> <7>[    0.208997] pci_bus 0000:00: on NUMA node 0
> <7>[    0.210981] ACPI: \_SB_.PCI0: notify handler is installed
> <7>[    0.211060] Found 1 acpi root devices
> <6>[    0.211167] ACPI : EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
> <6>[    0.211265] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> <6>[    0.211270] vgaarb: loaded
> <6>[    0.211272] vgaarb: bridge control possible 0000:00:02.0
> <5>[    0.211404] SCSI subsystem initialized
> <7>[    0.211451] libata version 3.00 loaded.
> <6>[    0.211488] ACPI: bus type USB registered
> <6>[    0.211521] usbcore: registered new interface driver usbfs
> <6>[    0.211535] usbcore: registered new interface driver hub
> <6>[    0.211567] usbcore: registered new device driver usb
> <6>[    0.211648] PCI: Using ACPI for IRQ routing
> <7>[    0.223123] PCI: pci_cache_line_size set to 64 bytes
> <7>[    0.223191] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
> <7>[    0.223195] e820: reserve RAM buffer [mem 0x7f6e0000-0x7fffffff]
> <6>[    0.223344] NetLabel: Initializing
> <6>[    0.223347] NetLabel:  domain hash size = 128
> <6>[    0.223349] NetLabel:  protocols = UNLABELED CIPSOv4
> <6>[    0.223371] NetLabel:  unlabeled traffic allowed by default
> <7>[    0.223682] hpet clockevent registered
> <6>[    0.223688] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> <6>[    0.223695] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> <6>[    0.223701] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> <6>[    0.225053] Switched to clocksource hpet
> <6>[    0.236434] pnp: PnP ACPI init
> <6>[    0.236467] ACPI: bus type PNP registered
> <6>[    0.237287] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> <6>[    0.237294] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> <6>[    0.237298] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> <6>[    0.237302] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
> <6>[    0.237307] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
> <6>[    0.237311] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
> <6>[    0.237315] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
> <6>[    0.237319] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> <6>[    0.237323] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> <6>[    0.237328] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> <6>[    0.237332] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> <6>[    0.237336] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> <6>[    0.237340] system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
> <6>[    0.237345] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
> <7>[    0.237353] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> <6>[    0.237519] system 00:01: [io  0x1000-0x107f] could not be reserved
> <6>[    0.237524] system 00:01: [io  0x1180-0x11bf] has been reserved
> <6>[    0.237528] system 00:01: [io  0x15e0-0x15ef] has been reserved
> <6>[    0.237532] system 00:01: [io  0x1600-0x162f] has been reserved
> <6>[    0.237536] system 00:01: [io  0x1632-0x167f] has been reserved
> <6>[    0.237540] system 00:01: [io  0x15c0-0x15df] has been reserved
> <6>[    0.237545] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
> <6>[    0.237549] system 00:01: [mem 0xf0008000-0xf000bfff] has been reserved
> <6>[    0.237554] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
> <6>[    0.237558] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> <6>[    0.237562] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> <7>[    0.237567] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> <7>[    0.237591] pnp 00:02: [dma 4]
> <7>[    0.237626] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
> <7>[    0.237666] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
> <7>[    0.237725] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
> <7>[    0.237777] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> <7>[    0.237823] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
> <7>[    0.237868] pnp 00:07: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
> <7>[    0.238192] pnp 00:08: Plug and Play ACPI device, IDs ATM1100 (active)
> <6>[    0.239338] pnp: PnP ACPI: found 9 devices
> <6>[    0.239341] ACPI: bus type PNP unregistered
> <7>[    0.276442] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
> <7>[    0.276451] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
> <4>[    0.276481] pci 0000:00:1f.0: BAR 13: [io  0x1000-0x107f] has bogus alignment
> <7>[    0.276487] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> <7>[    0.276492] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> <6>[    0.276500] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
> <6>[    0.276505] pci 0000:00:02.1: BAR 0: assigned [mem 0x80200000-0x8027ffff]
> <6>[    0.276514] pci 0000:00:1c.0: BAR 13: assigned [io  0x6000-0x6fff]
> <6>[    0.276519] pci 0000:00:1c.0: PCI bridge to [bus 02]
> <6>[    0.276525] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
> <6>[    0.276533] pci 0000:00:1c.0:   bridge window [mem 0xa0100000-0xa01fffff]
> <6>[    0.276540] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
> <7>[    0.276554] pci 0000:04:00.0: res[15]=[mem 0x04000000-0x03ffffff pref] get_res_add_size add_size 4000000
> <7>[    0.276558] pci 0000:04:00.0: res[16]=[mem 0x04000000-0x03ffffff] get_res_add_size add_size 4000000
> <7>[    0.276562] pci 0000:04:00.0: res[13]=[io  0x0100-0x00ff] get_res_add_size add_size 100
> <7>[    0.276566] pci 0000:04:00.0: res[14]=[io  0x0100-0x00ff] get_res_add_size add_size 100
> <6>[    0.276570] pci 0000:04:00.0: BAR 15: assigned [mem 0xd0000000-0xd3ffffff pref]
> <6>[    0.276575] pci 0000:04:00.0: BAR 16: assigned [mem 0xa4000000-0xa7ffffff]
> <6>[    0.276579] pci 0000:04:00.0: BAR 13: assigned [io  0x2000-0x20ff]
> <6>[    0.276583] pci 0000:04:00.0: BAR 14: assigned [io  0x2400-0x24ff]
> <6>[    0.276587] pci 0000:04:00.0: CardBus bridge to [bus 05-06]
> <6>[    0.276591] pci 0000:04:00.0:   bridge window [io  0x2000-0x20ff]
> <6>[    0.276598] pci 0000:04:00.0:   bridge window [io  0x2400-0x24ff]
> <6>[    0.276606] pci 0000:04:00.0:   bridge window [mem 0xd0000000-0xd3ffffff pref]
> <6>[    0.276614] pci 0000:04:00.0:   bridge window [mem 0xa4000000-0xa7ffffff]
> <6>[    0.276621] pci 0000:00:1e.0: PCI bridge to [bus 04-07]
> <6>[    0.276626] pci 0000:00:1e.0:   bridge window [io  0x2000-0x5fff]
> <6>[    0.276634] pci 0000:00:1e.0:   bridge window [mem 0xa0200000-0xafffffff]
> <6>[    0.276641] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
> <7>[    0.276652] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> <7>[    0.276656] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
> <7>[    0.276660] pci_bus 0000:02: resource 0 [io  0x6000-0x6fff]
> <7>[    0.276663] pci_bus 0000:02: resource 1 [mem 0xa0100000-0xa01fffff]
> <7>[    0.276667] pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
> <7>[    0.276671] pci_bus 0000:04: resource 0 [io  0x2000-0x5fff]
> <7>[    0.276675] pci_bus 0000:04: resource 1 [mem 0xa0200000-0xafffffff]
> <7>[    0.276679] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
> <7>[    0.276682] pci_bus 0000:04: resource 4 [io  0x0000-0xffff]
> <7>[    0.276686] pci_bus 0000:04: resource 5 [mem 0x00000000-0xffffffff]
> <7>[    0.276690] pci_bus 0000:05: resource 0 [io  0x2000-0x20ff]
> <7>[    0.276693] pci_bus 0000:05: resource 1 [io  0x2400-0x24ff]
> <7>[    0.276697] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd3ffffff pref]
> <7>[    0.276701] pci_bus 0000:05: resource 3 [mem 0xa4000000-0xa7ffffff]
> <6>[    0.276773] NET: Registered protocol family 2
> <6>[    0.277049] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
> <6>[    0.277085] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
> <6>[    0.277151] TCP: Hash tables configured (established 8192 bind 8192)
> <6>[    0.277203] TCP: reno registered
> <6>[    0.277207] UDP hash table entries: 512 (order: 2, 16384 bytes)
> <6>[    0.277226] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> <6>[    0.277336] NET: Registered protocol family 1
> <7>[    0.277361] pci 0000:00:02.0: Boot video device
> <7>[    0.278111] PCI: CLS 32 bytes, default 64
> <6>[    0.278199] Unpacking initramfs...
> <6>[    1.395863] Freeing initrd memory: 33000K (f3f7c000 - f5fb6000)
> <6>[    1.396116] Simple Boot Flag at 0x35 set to 0x1
> <6>[    1.396413] IBM machine detected. Enabling interrupts during APM calls.
> <6>[    1.396417] apm: BIOS not found.
> <5>[    1.396955] Initialise system trusted keyring
> <6>[    1.397058] audit: initializing netlink socket (disabled)
> <5>[    1.397081] type=2000 audit(1386106478.396:1): initialized
> <5>[    1.428603] bounce pool size: 64 pages
> <6>[    1.428622] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> <6>[    1.430736] zbud: loaded
> <5>[    1.430869] VFS: Disk quotas dquot_6.5.2
> <5>[    1.430947] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> <6>[    1.431615] msgmni has been set to 1704
> <7>[    1.431720] SELinux:  Registering netfilter hooks
> <6>[    1.432584] alg: No test for stdrng (krng)
> <6>[    1.432590] NET: Registered protocol family 38
> <5>[    1.432594] Key type asymmetric registered
> <5>[    1.432597] Asymmetric key parser 'x509' registered
> <6>[    1.432657] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> <6>[    1.432695] io scheduler noop registered
> <6>[    1.432697] io scheduler deadline registered
> <6>[    1.432745] io scheduler cfq registered (default)
> <7>[    1.433082] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
> <6>[    1.433221] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> <6>[    1.433247] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> <6>[    1.433324] vesafb: mode is 1024x768x32, linelength=4096, pages=0
> <6>[    1.433327] vesafb: scrolling: redraw
> <6>[    1.433330] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> <6>[    1.433546] vesafb: framebuffer at 0xc0000000, mapped to 0xf7c80000, using 3072k, total 3072k
> <6>[    1.473714] Console: switching to colour frame buffer device 128x48
> <6>[    1.509987] fb0: VESA VGA frame buffer device
> <7>[    1.510023] intel_idle: does not run on family 6 model 13
> <6>[    1.510334] ACPI: AC Adapter [AC] (on-line)
> <6>[    1.510423] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> <6>[    1.510591] ACPI: Lid Switch [LID]
> <6>[    1.510759] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
> <6>[    1.510766] ACPI: Sleep Button [SLPB]
> <6>[    1.510935] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> <6>[    1.510939] ACPI: Power Button [PWRF]
> <6>[    1.511477] tsc: Marking TSC unstable due to TSC halts in idle
> <7>[    1.511491] ACPI: acpi_idle registered with cpuidle
> <6>[    1.512665] thermal LNXTHERM:00: registered as thermal_zone0
> <6>[    1.512669] ACPI: Thermal Zone [THM0] (53 C)
> <6>[    1.512723] GHES: HEST is not enabled!
> <6>[    1.512794] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> <6>[    1.513489] Non-volatile memory driver v1.3
> <6>[    1.513492] Linux agpgart interface v0.103
> <6>[    1.513597] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
> <6>[    1.513655] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
> <6>[    1.514443] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
> <6>[    1.514611] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
> <6>[    1.516607] loop: module loaded
> <7>[    1.516792] ahci 0000:00:1f.2: version 3.0
> <4>[    1.516822] ahci: probe of 0000:00:1f.2 failed with error -22
> <7>[    1.516856] ata_piix 0000:00:1f.2: version 2.13
> <6>[    1.516869] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> <6>[    1.528256] ACPI: Battery Slot [BAT0] (battery present)
> <6>[    1.667858] scsi0 : ata_piix
> <6>[    1.667950] scsi1 : ata_piix
> <6>[    1.668015] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
> <6>[    1.668018] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
> <6>[    1.668101] libphy: Fixed MDIO Bus: probed
> <6>[    1.668182] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> <6>[    1.668187] ehci-pci: EHCI PCI platform driver
> <6>[    1.668297] ehci-pci 0000:00:1d.7: EHCI Host Controller
> <6>[    1.668347] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
> <6>[    1.668368] ehci-pci 0000:00:1d.7: debug port 1
> <7>[    1.672283] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
> <6>[    1.672523] ehci-pci 0000:00:1d.7: irq 19, io mem 0xa0040000
> <6>[    1.678070] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> <6>[    1.678161] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> <6>[    1.678165] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> <6>[    1.678169] usb usb1: Product: EHCI Host Controller
> <6>[    1.678172] usb usb1: Manufacturer: Linux 3.13.0-0.rc2.1.local1.fc18.i686 ehci_hcd
> <6>[    1.678175] usb usb1: SerialNumber: 0000:00:1d.7
> <6>[    1.678333] hub 1-0:1.0: USB hub found
> <6>[    1.678345] hub 1-0:1.0: 8 ports detected
> <6>[    1.678782] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> <6>[    1.678785] ohci-pci: OHCI PCI platform driver
> <6>[    1.678803] uhci_hcd: USB Universal Host Controller Interface driver
> <6>[    1.678888] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> <6>[    1.678937] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> <6>[    1.678978] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
> <6>[    1.679055] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> <6>[    1.679059] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> <6>[    1.679062] usb usb2: Product: UHCI Host Controller
> <6>[    1.679066] usb usb2: Manufacturer: Linux 3.13.0-0.rc2.1.local1.fc18.i686 uhci_hcd
> <6>[    1.679069] usb usb2: SerialNumber: 0000:00:1d.0
> <6>[    1.679209] hub 2-0:1.0: USB hub found
> <6>[    1.679219] hub 2-0:1.0: 2 ports detected
> <6>[    1.679413] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> <6>[    1.679464] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> <6>[    1.679506] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
> <6>[    1.679566] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> <6>[    1.679570] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> <6>[    1.679574] usb usb3: Product: UHCI Host Controller
> <6>[    1.679577] usb usb3: Manufacturer: Linux 3.13.0-0.rc2.1.local1.fc18.i686 uhci_hcd
> <6>[    1.679580] usb usb3: SerialNumber: 0000:00:1d.1
> <6>[    1.679710] hub 3-0:1.0: USB hub found
> <6>[    1.679720] hub 3-0:1.0: 2 ports detected
> <6>[    1.679903] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> <6>[    1.679953] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> <6>[    1.679994] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
> <6>[    1.680069] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> <6>[    1.680073] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> <6>[    1.680076] usb usb4: Product: UHCI Host Controller
> <6>[    1.680080] usb usb4: Manufacturer: Linux 3.13.0-0.rc2.1.local1.fc18.i686 uhci_hcd
> <6>[    1.680083] usb usb4: SerialNumber: 0000:00:1d.2
> <6>[    1.680206] hub 4-0:1.0: USB hub found
> <6>[    1.680215] hub 4-0:1.0: 2 ports detected
> <6>[    1.680390] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> <6>[    1.680447] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> <6>[    1.680474] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
> <6>[    1.680538] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> <6>[    1.680542] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> <6>[    1.680546] usb usb5: Product: UHCI Host Controller
> <6>[    1.680549] usb usb5: Manufacturer: Linux 3.13.0-0.rc2.1.local1.fc18.i686 uhci_hcd
> <6>[    1.680552] usb usb5: SerialNumber: 0000:00:1d.3
> <6>[    1.680691] hub 5-0:1.0: USB hub found
> <6>[    1.680701] hub 5-0:1.0: 2 ports detected
> <6>[    1.680899] usbcore: registered new interface driver usbserial
> <6>[    1.680915] usbcore: registered new interface driver usbserial_generic
> <6>[    1.680926] usbserial: USB Serial support registered for generic
> <6>[    1.680986] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> <6>[    1.688960] serio: i8042 KBD port at 0x60,0x64 irq 1
> <6>[    1.688967] serio: i8042 AUX port at 0x60,0x64 irq 12
> <6>[    1.689103] mousedev: PS/2 mouse device common for all mice
> <6>[    1.689346] rtc_cmos 00:05: RTC can wake from S4
> <6>[    1.689504] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> <6>[    1.689541] rtc_cmos 00:05: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> <6>[    1.689674] device-mapper: uevent: version 1.0.3
> <6>[    1.689762] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> <6>[    1.690229] hidraw: raw HID events driver (C) Jiri Kosina
> <6>[    1.690382] usbcore: registered new interface driver usbhid
> <6>[    1.690385] usbhid: USB HID core driver
> <6>[    1.690448] drop_monitor: Initializing network drop monitor service
> <6>[    1.690563] ip_tables: (C) 2000-2006 Netfilter Core Team
> <6>[    1.690592] TCP: cubic registered
> <6>[    1.690595] Initializing XFRM netlink socket
> <6>[    1.690797] NET: Registered protocol family 10
> <6>[    1.691127] mip6: Mobile IPv6
> <6>[    1.691131] NET: Registered protocol family 17
> <6>[    1.691432] Using IPI No-Shortcut mode
> <5>[    1.691536] Loading compiled-in X.509 certificates
> <5>[    1.698468] Loaded X.509 cert 'Magrathea: Glacier signing key: 053e8b6b8132b4c7f4b2fd741d6984fb4b33e83f'
> <6>[    1.698486] registered taskstats version 1
> <6>[    1.698854]   Magic number: 9:519:600
> <6>[    1.698951] rtc_cmos 00:05: setting system clock to 2013-12-03 21:34:38 UTC (1386106478)
> <7>[    1.699024] PM: Hibernation image not present or could not be loaded.
> <6>[    1.699691] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> <6>[    1.827689] ata1.00: ATA-6: HTC426060G9AT00, 00P3A0B5, max UDMA/100
> <6>[    1.827693] ata1.00: 117210240 sectors, multi 16: LBA 
> <6>[    1.827698] ata1.00: applying bridge limits
> <6>[    1.833369] ata1.00: configured for UDMA/100
> <5>[    1.833526] scsi 0:0:0:0: Direct-Access     ATA      HTC426060G9AT00  00P3 PQ: 0 ANSI: 5
> <5>[    1.833756] sd 0:0:0:0: [sda] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
> <5>[    1.833836] sd 0:0:0:0: [sda] Write Protect is off
> <7>[    1.833840] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> <5>[    1.833875] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> <5>[    1.834102] sd 0:0:0:0: Attached scsi generic sg0 type 0
> <6>[    1.971305]  sda: sda1 sda2 sda3 sda4 < sda5 >
> <5>[    1.971817] sd 0:0:0:0: [sda] Attached SCSI disk
> <6>[    1.972234] Freeing unused kernel memory: 728K (c0cad000 - c0d63000)
> <6>[    1.972305] Write protecting the kernel text: 5908k
> <6>[    1.972366] Write protecting the kernel read-only data: 2404k
> <30>[    1.978182] systemd[1]: systemd 201 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
> <30>[    1.978340] systemd[1]: Running in initial RAM disk.
> <30>[    1.978484] systemd[1]: No hostname configured.
> <30>[    1.978492] systemd[1]: Set hostname to <localhost>.
> <5>[    1.978636] random: systemd urandom read with 25 bits of entropy available
> <30>[    1.978657] systemd[1]: Initializing machine ID from random generator.
> <28>[    1.988704] systemd[1]: Found ordering cycle on basic.target/start
> <30>[    1.988715] systemd[1]: Walked on cycle path to sysinit.target/start
> <30>[    1.988721] systemd[1]: Walked on cycle path to multipathd.service/start
> <30>[    1.988727] systemd[1]: Walked on cycle path to basic.target/start
> <28>[    1.988733] systemd[1]: Breaking ordering cycle by deleting job multipathd.service/start
> <27>[    1.988739] systemd[1]: Job multipathd.service/start deleted to break ordering cycle starting with basic.target/start
> <30>[    1.989699] systemd[1]: Expecting device dev-mapper-[...].device...
> <30>[    1.989721] systemd[1]: Starting Timers.
> <30>[    1.989744] systemd[1]: Reached target Timers.
> <30>[    1.989767] systemd[1]: Starting Journal Socket.
> <30>[    1.989871] systemd[1]: Listening on Journal Socket.
> <30>[    1.990180] systemd[1]: Starting dracut cmdline hook...
> <30>[    1.990805] systemd[1]: Starting Journal Service...
> <30>[    1.995463] systemd[1]: Started Journal Service.
> <30>[    1.998390] systemd[1]: Started Load Kernel Modules.
> <30>[    1.998472] systemd[1]: Starting udev Kernel Socket.
> <30>[    1.998531] systemd[1]: Listening on udev Kernel Socket.
> <30>[    1.998608] systemd[1]: Starting udev Control Socket.
> <30>[    1.998664] systemd[1]: Listening on udev Control Socket.
> <30>[    1.998685] systemd[1]: Starting Sockets.
> <30>[    1.998706] systemd[1]: Reached target Sockets.
> <30>[    1.998728] systemd[1]: Starting Encrypted Volumes.
> <30>[    1.998748] systemd[1]: Reached target Encrypted Volumes.
> <30>[    1.998769] systemd[1]: Starting Swap.
> <30>[    1.998788] systemd[1]: Reached target Swap.
> <30>[    1.998808] systemd[1]: Starting Local File Systems.
> <30>[    1.998828] systemd[1]: Reached target Local File Systems.
> <46>[    2.002357] systemd-journald[52]: Vacuuming done, freed 0 bytes
> <6>[    2.116182] psmouse serio1: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
> <7>[    2.131924] psmouse serio1: hgpk: ID: 10 00 64
> <5>[    2.227144] sunrpc: module verification failed: signature and/or  required key missing - tainting kernel
> <6>[    2.229384] RPC: Registered named UNIX socket transport module.
> <6>[    2.229388] RPC: Registered udp transport module.
> <6>[    2.229390] RPC: Registered tcp transport module.
> <6>[    2.229392] RPC: Registered tcp NFSv4.1 backchannel transport module.
> <6>[    2.336035] usb 4-2: new full-speed USB device number 2 using uhci_hcd
> <30>[    2.380362] systemd-udevd[146]: starting version 201
> <6>[    2.470345] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> <6>[    2.485123] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input5
> <6>[    2.499087] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
> <6>[    2.499094] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> <6>[    2.499098] usb 4-2: Product: Biometric Coprocessor
> <6>[    2.499102] usb 4-2: Manufacturer: STMicroelectronics
> <6>[    2.568931] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> <6>[    2.570173] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
> <6>[    2.617611] pps_core: LinuxPPS API ver. 1 registered
> <6>[    2.617617] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> <6>[    2.617858] PTP clock support registered
> <6>[    2.619376] tg3.c:v3.134 (Sep 16, 2013)
> <6>[    2.655784] [drm] Initialized drm 1.1.0 20060810
> <6>[    2.660649] yenta_cardbus 0000:04:00.0: CardBus bridge found [1014:0555]
> <6>[    2.683439] tg3 0000:02:00.0 eth0: Tigon3 [partno(BCM95751M) rev 4101] (PCI Express) MAC address [...]
> <6>[    2.683449] tg3 0000:02:00.0 eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
> <6>[    2.683454] tg3 0000:02:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
> <6>[    2.683458] tg3 0000:02:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
> <7>[    2.688061] [drm:i915_dump_device_info], i915 device info: gen=3, pciid=0x2592 flags=is_mobile,cursor_needs_physical,has_overlay,overlay_needs_physical,supports_tv,
> <7>[    2.688126] [drm:intel_detect_pch], 
> <5>[    2.688129] No PCH found?
> <6>[    2.688133] [drm] Memory usable by graphics device = 256M
> <7>[    2.688136] [drm:i915_gem_gtt_init], GMADR size = 256M
> <7>[    2.688138] [drm:i915_gem_gtt_init], GTT stolen size = 8M
> <7>[    2.688143] checking generic (c0000000 300000) vs hw (c0000000 10000000)
> <6>[    2.688146] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
> <6>[    2.688173] Console: switching to colour dummy device 80x25
> <7>[    2.690411] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
> <7>[    2.690415] [drm:intel_opregion_setup], ACPI OpRegion not supported!
> <6>[    2.690451] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> <6>[    2.690453] [drm] Driver supports precise vblank timestamp query.
> <7>[    2.690457] [drm:init_vbt_defaults], Set default to SSC at 100MHz
> <7>[    2.690491] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 0 lvds_use_ssc 1 lvds_ssc_freq 100 display_clock_mode 0 fdi_rx_polarity_inverted 0
> <7>[    2.690495] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
> <7>[    2.690502] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
> <7>[    2.690505] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 54160 1024 1048 1184 1344 768 771 777 806 0x8 0xa
> <7>[    2.690511] [drm:parse_lfp_panel_data], VBT initial LVDS value 40000300
> <7>[    2.690515] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
> <7>[    2.690519] [drm:parse_mipi], No MIPI BDB found
> <7>[    2.690525] [drm:intel_dsm_pci_probe], 
> <5>[    2.690527] no _DSM method for intel device
> <7>[    2.690535] [drm:i915_gem_init_stolen], found 8388608 bytes of stolen memory at 7f800000
> <7>[    2.690561] [drm:intel_modeset_init], 2 display pipes available.
> <7>[    2.690567] [drm:intel_crtc_init], swapping pipes & planes for FBC
> <7>[    2.690570] [drm:intel_modeset_init], pipe A sprite A init failed: -19
> <7>[    2.690575] [drm:intel_crtc_init], swapping pipes & planes for FBC
> <7>[    2.690577] [drm:intel_modeset_init], pipe B sprite B init failed: -19
> <7>[    2.690580] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
> <6>[    2.690587] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> <7>[    2.694135] [drm:gmbus_xfer], GMBUS [i915 gmbus panel] NAK for addr: 0050 r(1)
> <7>[    2.694140] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus panel
> <7>[    2.694144] [drm:intel_lvds_init], using mode from VBT: 
> <7>[    2.694147] [drm:drm_mode_debug_printmodeline], 
> <5>[    2.694152] Modeline 0:"1024x768" 0 54160 1024 1048 1184 1344 768 771 777 806 0x8 0xa
> <7>[    2.694156] [drm:intel_lvds_init], detected single-link lvds configuration
> <7>[    2.694204] [drm:intel_panel_get_backlight], get backlight PWM = 13875
> <7>[    2.694208] [drm:intel_panel_get_max_backlight], max backlight PWM = 13875
> <7>[    2.694356] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, ffff000]
> <7>[    2.700164] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
> <7>[    2.700171] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
> <7>[    2.700210] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
> <6>[    2.700337] [drm] initialized overlay support
> <7>[    2.700341] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: disabled
> <7>[    2.700351] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: enabled
> <7>[    2.700356] [drm:intel_modeset_readout_hw_state], [ENCODER:6:LVDS-6] hw state readout: enabled, pipe B
> <7>[    2.700360] [drm:intel_modeset_readout_hw_state], [ENCODER:10:DAC-10] hw state readout: disabled, pipe A
> <7>[    2.700364] [drm:intel_modeset_readout_hw_state], [ENCODER:12:TV-12] hw state readout: disabled, pipe A
> <7>[    2.700369] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:LVDS-1] hw state readout: enabled
> <7>[    2.700372] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:VGA-1] hw state readout: disabled
> <7>[    2.700376] [drm:intel_modeset_readout_hw_state], [CONNECTOR:11:SVIDEO-1] hw state readout: disabled
> <7>[    2.700382] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
> <7>[    2.700385] [drm:intel_dump_pipe_config], cpu_transcoder: A
> <7>[    2.700387] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
> <7>[    2.700390] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> <7>[    2.700393] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
> <7>[    2.700397] [drm:intel_dump_pipe_config], requested mode:
> <7>[    2.700400] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> <7>[    2.700404] [drm:intel_dump_pipe_config], adjusted mode:
> <7>[    2.700406] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
> <7>[    2.700411] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
> <7>[    2.700415] [drm:intel_dump_pipe_config], port clock: 0
> <7>[    2.700417] [drm:intel_dump_pipe_config], pipe src size: 0x0
> <7>[    2.700420] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
> <7>[    2.700423] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
> <7>[    2.700426] [drm:intel_dump_pipe_config], ips: 0
> <7>[    2.700428] [drm:intel_dump_pipe_config], double wide: 0
> <7>[    2.700432] [drm:intel_sanitize_crtc], [CRTC:4] wrong plane connection detected!
> <4>[    2.700435] ------------[ cut here ]------------
> <4>[    2.700496] WARNING: CPU: 0 PID: 173 at drivers/gpu/drm/i915/intel_display.c:9948 intel_get_pipe_from_connector+0x42/0x50 [i915]()
> <5>[    2.700498] Modules linked in: i915(F+) ata_generic(F) pata_acpi(F) yenta_socket(F+) i2c_algo_bit(F) drm_kms_helper(F) drm(F) tg3(F) ptp(F) pps_core(F) i2c_core(F) video(F) sunrpc(F)
> <5>[    2.700517] CPU: 0 PID: 173 Comm: systemd-udevd Tainted: GF            3.13.0-0.rc2.1.local1.fc18.i686 #1
> <5>[    2.700520] Hardware name: IBM 2525FAG/2525FAG, BIOS 74ET61WW (2.06 ) 03/14/2006
> <5>[    2.700522]  00000000 00000000 f548d9f4 c09b66d2 00000000 f548da24 c0449b14 c0b541a4
> <5>[    2.700530]  00000000 000000ad f82c9524 000026dc f82826a2 f82826a2 f558d280 00061200
> <5>[    2.700537]  f56a0000 f548da34 c0449b52 00000009 00000000 f548da40 f82826a2 f5666800
> <5>[    2.700544] Call Trace:
> <5>[    2.700556]  [<c09b66d2>] dump_stack+0x41/0x52
> <5>[    2.700563]  [<c0449b14>] warn_slowpath_common+0x84/0xa0
> <5>[    2.700599]  [<f82826a2>] ? intel_get_pipe_from_connector+0x42/0x50 [i915]
> <5>[    2.700635]  [<f82826a2>] ? intel_get_pipe_from_connector+0x42/0x50 [i915]
> <5>[    2.700640]  [<c0449b52>] warn_slowpath_null+0x22/0x30
> <5>[    2.700676]  [<f82826a2>] intel_get_pipe_from_connector+0x42/0x50 [i915]
> <5>[    2.700717]  [<f829b171>] intel_panel_disable_backlight+0x21/0x160 [i915]
> <5>[    2.700754]  [<f8287051>] intel_disable_lvds+0x41/0x160 [i915]
> <5>[    2.700789]  [<f8278540>] i9xx_crtc_disable+0x200/0x2c0 [i915]
> <5>[    2.700794]  [<c049373d>] ? vprintk+0x3d/0x40
> <5>[    2.700831]  [<f8284abe>] intel_modeset_setup_hw_state+0x92e/0xb00 [i915]
> <5>[    2.700836]  [<c09b3e00>] ? power_down+0x8c/0x8d
> <5>[    2.700878]  [<f82b3bc0>] ? gen4_write64+0xa0/0xa0 [i915]
> <5>[    2.700915]  [<f8284cb0>] intel_modeset_gem_init+0x20/0x30 [i915]
> <5>[    2.700944]  [<f824ab83>] i915_driver_load+0xb53/0xdd0 [i915]
> <5>[    2.700973]  [<f8248280>] ? i915_switcheroo_set_state+0xa0/0xa0 [i915]
> <5>[    2.700999]  [<f80c4d5c>] drm_dev_register+0x8c/0x1a0 [drm]
> <5>[    2.701035]  [<f80c6895>] drm_get_pci_dev+0x85/0x130 [drm]
> <5>[    2.701042]  [<c05be578>] ? sysfs_do_create_link_sd.isra.3+0xa8/0x1c0
> <5>[    2.701049]  [<c09bffc3>] ? notifier_call_chain+0x43/0x60
> <5>[    2.701077]  [<f82474ba>] i915_pci_probe+0x3a/0x80 [i915]
> <5>[    2.701084]  [<c06cc8d9>] pci_device_probe+0x79/0xc0
> <5>[    2.701088]  [<c05be6b5>] ? sysfs_create_link+0x25/0x40
> <5>[    2.701095]  [<c077d9b9>] driver_probe_device+0x79/0x360
> <5>[    2.701100]  [<c06cc81e>] ? pci_match_device+0x9e/0xb0
> <5>[    2.701104]  [<c077dd31>] __driver_attach+0x91/0xa0
> <5>[    2.701109]  [<c077dca0>] ? driver_probe_device+0x360/0x360
> <5>[    2.701113]  [<c077bf52>] bus_for_each_dev+0x42/0x80
> <5>[    2.701117]  [<c077d3ce>] driver_attach+0x1e/0x20
> <5>[    2.701121]  [<c077dca0>] ? driver_probe_device+0x360/0x360
> <5>[    2.701126]  [<c077d07c>] bus_add_driver+0xec/0x210
> <5>[    2.701130]  [<c077e349>] driver_register+0x59/0xe0
> <5>[    2.701134]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.701139]  [<c06cba63>] __pci_register_driver+0x33/0x40
> <5>[    2.701142]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.701158]  [<f80c6a3d>] drm_pci_init+0xfd/0x110 [drm]
> <5>[    2.701162]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.701189]  [<f7fb205e>] i915_init+0x5e/0x60 [i915]
> <5>[    2.701194]  [<c040049a>] do_one_initcall+0xda/0x1a0
> <5>[    2.701198]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.701203]  [<c04eff41>] ? __add_event_to_tracers+0x21/0x30
> <5>[    2.701207]  [<f7fb2000>] ? 0xf7fb1fff
> <5>[    2.701212]  [<c043dff7>] ? set_memory_ro+0x37/0x40
> <5>[    2.701220]  [<c04b15ad>] load_module+0x1abd/0x2390
> <5>[    2.701227]  [<c04b1f27>] SyS_init_module+0xa7/0x110
> <5>[    2.701233]  [<c052214b>] ? vm_mmap_pgoff+0x8b/0xb0
> <5>[    2.701240]  [<c09c3a0d>] sysenter_do_call+0x12/0x28
> <4>[    2.701243] ---[ end trace 8caa41d2a02740d1 ]---
> 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
