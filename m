Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3IJIly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:41:54 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:36828 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3IJIln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:41:43 -0400
Message-ID: <522EDB3D.7040504@t-online.de>
Date: Tue, 10 Sep 2013 10:41:33 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, ville.syrjala@linux.intel.com
Subject: Re: [PATCH] drm/i915/sdvo: Fully translate sync flags in the dtd->mode
 conversion
References: <522A5008.6060005@t-online.de> <1378800168-32277-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1378800168-32277-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: multipart/mixed;
 boundary="------------090900040203050500080206"
X-ID: ZY9WH6Z1ohD1DtkdRkOXHP0iCEDkzNlCm01xGBqnepbK7tbOmBT9Enbjc0pLQokgJt
X-TOI-MSGID: ccc38b84-e53a-49c2-831d-5b6bc7b0ab27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090900040203050500080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10.09.2013 10:02, Daniel Vetter wrote:
> Instead of just a flag bit for each of the positive/negative sync
> modes drm actually uses a separate flag for each ... This upsets the
> modeset checker since the adjusted mode filled out at modeset time
> doesn't match the one reconstructed at check time (since the
> ->get_config callback already gets this right).
>
> Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> Cc: Knut Petersen <Knut_Petersen@t-online.de>
> References: http://www.gossamer-threads.com/lists/linux/kernel/1778688?do=post_view_threaded

Thanks for the patch, but it does _not_ cure the problem, see attached boot dmesg.

cu,
  Knut


> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>   drivers/gpu/drm/i915/intel_sdvo.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
> index 85037b9..5033c74 100644
> --- a/drivers/gpu/drm/i915/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/intel_sdvo.c
> @@ -866,8 +866,12 @@ static void intel_sdvo_get_mode_from_dtd(struct drm_display_mode * mode,
>   		mode->flags |= DRM_MODE_FLAG_INTERLACE;
>   	if (dtd->part2.dtd_flags & DTD_FLAG_HSYNC_POSITIVE)
>   		mode->flags |= DRM_MODE_FLAG_PHSYNC;
> +	else
> +		mode->flags |= DRM_MODE_FLAG_NHSYNC;
>   	if (dtd->part2.dtd_flags & DTD_FLAG_VSYNC_POSITIVE)
>   		mode->flags |= DRM_MODE_FLAG_PVSYNC;
> +	else
> +		mode->flags |= DRM_MODE_FLAG_NVSYNC;
>   }
>   
>   static bool intel_sdvo_check_supp_encode(struct intel_sdvo *intel_sdvo)


--------------090900040203050500080206
Content-Type: text/plain; charset=UTF-8;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-main+ (knut@linux-ktth.site) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #70 PREEMPT Tue Sep 10 10:17:52 CEST 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007f7effff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f7f0000-0x000000007f7f2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007f7f3000-0x000000007f7fffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI:    /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7f7f0 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-F7FFF uncachable
[    0.000000]   F8000-FBFFF write-through
[    0.000000]   FC000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] initial memory mapped: [mem 0x00000000-0x011fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37800000-0x379fffff]
[    0.000000]  [mem 0x37800000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x377fffff]
[    0.000000]  [mem 0x34000000-0x377fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x00db7000, 0x00db7fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37bcf000-0x37feffff]
[    0.000000] Allocated new RAMDISK: [mem 0x377ae000-0x37bce4b6]
[    0.000000] Move RAMDISK from [mem 0x37bcf000-0x37fef4b6] to [mem 0x377ae000-0x37bce4b6]
[    0.000000] ACPI: RSDP 000f9320 00014 (v00 AOpen )
[    0.000000] ACPI: RSDT 7f7f3040 00038 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 7f7f30c0 00074 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 7f7f3180 042E3 (v01 AOPEN  AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f7f0000 00040
[    0.000000] ACPI: MCFG 7f7f7580 0003C (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 7f7f74c0 0005A (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 7f7f7600 001E0 (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.000000] ACPI: SSDT 7f7f7a00 000E0 (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1147MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x00db8000, 0x00db8fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x7f7effff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7f7effff]
[    0.000000] On node 0 totalpages: 522126
[    0.000000] free_area_init_node: node 0, pgdat c07c9a28, node_mem_map f67be020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2296 pages used for memmap
[    0.000000]   HighMem zone: 293874 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xdfffffff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520342
[    0.000000] Kernel command line: root=/dev/hda2 acpi_enforce_resources=lax sky2.legacy_pme=1 splash=verbose quiet edd=off 3 resume=/dev/hda1      drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:0007f7f0)
[    0.000000] Memory: 2053892K/2088504K available (4387K kernel code, 387K rwdata, 2204K rodata, 492K init, 5500K bss, 34612K reserved, 1175496K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc07d3000 - 0xc084e000   ( 492 kB)
[    0.000000]       .data : 0xc05492b2 - 0xc07d2fc0   (2599 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05492b2   (4388 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=f6008000 soft=f600a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1200.112 MHz processor
[    0.008002] Calibrating delay loop (skipped), value calculated using timer frequency.. 2400.22 BogoMIPS (lpj=4800448)
[    0.008011] pid_max: default: 32768 minimum: 301
[    0.008119] Security Framework initialized
[    0.008140] AppArmor: AppArmor initialized
[    0.008178] Mount-cache hash table entries: 512
[    0.012196] Disabled fast string operations
[    0.012213] mce: CPU supports 5 MCE banks
[    0.012228] CPU0: Thermal monitoring enabled (TM1)
[    0.012253] Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
[    0.012253] Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8
[    0.012253] tlb_flushall_shift: 6
[    0.012260] CPU: Intel(R) Pentium(R) M processor 1.20GHz (fam: 06, model: 0d, stepping: 08)
[    0.012339] ACPI: Core revision 20130725
[    0.026265] ACPI: All ACPI Tables successfully acquired
[    0.028028] ftrace: allocating 22198 entries in 44 pages
[    0.044921] Performance Events: p6 PMU driver.
[    0.044958] ... version:                0
[    0.044963] ... bit width:              32
[    0.044968] ... generic registers:      2
[    0.044973] ... value mask:             00000000ffffffff
[    0.044977] ... max period:             000000007fffffff
[    0.044982] ... fixed-purpose events:   0
[    0.044986] ... event mask:             0000000000000003
[    0.046613] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.048294] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052230] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.092000] devtmpfs: initialized
[    0.092000] PM: Registering ACPI NVS region [mem 0x7f7f0000-0x7f7f2fff] (12288 bytes)
[    0.092000] NET: Registered protocol family 16
[    0.093214] cpuidle: using governor ladder
[    0.093221] cpuidle: using governor menu
[    0.093501] ACPI: bus type PCI registered
[    0.093844] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.093853] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.093857] PCI: Using MMCONFIG for extended config space
[    0.093862] PCI: Using configuration type 1 for base access
[    0.101446] bio: create slab <bio-0> at 0
[    0.101851] ACPI: Added _OSI(Module Device)
[    0.101858] ACPI: Added _OSI(Processor Device)
[    0.101864] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.101871] ACPI: Added _OSI(Processor Aggregator Device)
[    0.108387] ACPI: EC: Look up EC in DSDT
[    0.128735] ACPI: Interpreter enabled
[    0.128776] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    0.128888] ACPI: (supports S0 S1 S3 S4 S5)
[    0.128894] ACPI: Using IOAPIC for interrupt routing
[    0.129008] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.161649] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.161672] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.161680] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.162185] acpi PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.162193] acpi PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.162201] acpi PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.162209] acpi PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    0.162217] acpi PNP0A08:00: host bridge window [mem 0x7f800000-0xfebfffff] (ignored)
[    0.162224] PCI: root bus 00: using default resources
[    0.162233] acpi PNP0A08:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.162602] PCI host bridge to bus 0000:00
[    0.162635] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.162644] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.162651] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.162818] pci 0000:00:00.0: [8086:2590] type 00 class 0x060000
[    0.163622] pci 0000:00:02.0: [8086:2592] type 00 class 0x030000
[    0.163655] pci 0000:00:02.0: reg 0x10: [mem 0xd2280000-0xd22fffff]
[    0.163674] pci 0000:00:02.0: reg 0x14: [io  0xe000-0xe007]
[    0.163693] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff pref]
[    0.163712] pci 0000:00:02.0: reg 0x1c: [mem 0xd2300000-0xd233ffff]
[    0.164232] pci 0000:00:02.1: [8086:2792] type 00 class 0x038000
[    0.164261] pci 0000:00:02.1: reg 0x10: [mem 0xd2200000-0xd227ffff]
[    0.164892] pci 0000:00:1b.0: [8086:2668] type 00 class 0x040300
[    0.164936] pci 0000:00:1b.0: reg 0x10: [mem 0xd2340000-0xd2343fff 64bit]
[    0.165125] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.165641] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.166016] pci 0000:00:1c.0: [8086:2660] type 01 class 0x060400
[    0.166199] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.166549] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.166731] pci 0000:00:1c.1: [8086:2662] type 01 class 0x060400
[    0.166928] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.167276] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.167462] pci 0000:00:1c.2: [8086:2664] type 01 class 0x060400
[    0.167659] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.168020] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.168226] pci 0000:00:1c.3: [8086:2666] type 01 class 0x060400
[    0.168407] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.168754] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.168938] pci 0000:00:1d.0: [8086:2658] type 00 class 0x0c0300
[    0.169039] pci 0000:00:1d.0: reg 0x20: [io  0xe100-0xe11f]
[    0.169418] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.169587] pci 0000:00:1d.1: [8086:2659] type 00 class 0x0c0300
[    0.169688] pci 0000:00:1d.1: reg 0x20: [io  0xe200-0xe21f]
[    0.170069] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.170242] pci 0000:00:1d.2: [8086:265a] type 00 class 0x0c0300
[    0.170343] pci 0000:00:1d.2: reg 0x20: [io  0xe300-0xe31f]
[    0.170723] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.170892] pci 0000:00:1d.3: [8086:265b] type 00 class 0x0c0300
[    0.170992] pci 0000:00:1d.3: reg 0x20: [io  0xe400-0xe41f]
[    0.171372] pci 0000:00:1d.3: System wakeup disabled by ACPI
[    0.171557] pci 0000:00:1d.7: [8086:265c] type 00 class 0x0c0320
[    0.171598] pci 0000:00:1d.7: reg 0x10: [mem 0xd2344000-0xd23443ff]
[    0.171770] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.172116] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.172294] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.172752] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.172928] pci 0000:00:1f.0: [8086:2641] type 00 class 0x060100
[    0.173139] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.173158] pci 0000:00:1f.0: quirk: [io  0x4000-0x407f] claimed by ICH6 ACPI/GPIO/TCO
[    0.173173] pci 0000:00:1f.0: quirk: [io  0x4080-0x40bf] claimed by ICH6 GPIO
[    0.173183] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0280-02ff
[    0.173194] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 1640-164f
[    0.173640] pci 0000:00:1f.1: [8086:266f] type 00 class 0x01018a
[    0.173674] pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]
[    0.173698] pci 0000:00:1f.1: reg 0x14: [io  0x0000-0x0003]
[    0.173722] pci 0000:00:1f.1: reg 0x18: [io  0x0000-0x0007]
[    0.173747] pci 0000:00:1f.1: reg 0x1c: [io  0x0000-0x0003]
[    0.173771] pci 0000:00:1f.1: reg 0x20: [io  0xf000-0xf00f]
[    0.174274] pci 0000:00:1f.2: [8086:2653] type 00 class 0x01018f
[    0.174314] pci 0000:00:1f.2: reg 0x10: [io  0xe500-0xe507]
[    0.174339] pci 0000:00:1f.2: reg 0x14: [io  0xe600-0xe603]
[    0.174363] pci 0000:00:1f.2: reg 0x18: [io  0xe700-0xe707]
[    0.174388] pci 0000:00:1f.2: reg 0x1c: [io  0xe800-0xe803]
[    0.174412] pci 0000:00:1f.2: reg 0x20: [io  0xe900-0xe90f]
[    0.174437] pci 0000:00:1f.2: reg 0x24: [mem 0xd2345000-0xd23453ff]
[    0.174525] pci 0000:00:1f.2: PME# supported from D3hot
[    0.174998] pci 0000:00:1f.3: [8086:266a] type 00 class 0x0c0500
[    0.175116] pci 0000:00:1f.3: reg 0x20: [io  0x5000-0x501f]
[    0.175788] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.175807] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.175824] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
[    0.176083] pci 0000:02:00.0: [11ab:4362] type 00 class 0x020000
[    0.176142] pci 0000:02:00.0: reg 0x10: [mem 0xd2120000-0xd2123fff 64bit]
[    0.176175] pci 0000:02:00.0: reg 0x18: [io  0xc000-0xc0ff]
[    0.176281] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.176449] pci 0000:02:00.0: supports D1 D2
[    0.176455] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.176649] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.176874] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.176886] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.176899] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.177150] pci 0000:03:00.0: [11ab:4362] type 00 class 0x020000
[    0.177209] pci 0000:03:00.0: reg 0x10: [mem 0xd2020000-0xd2023fff 64bit]
[    0.177241] pci 0000:03:00.0: reg 0x18: [io  0xd000-0xd0ff]
[    0.177346] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.177513] pci 0000:03:00.0: supports D1 D2
[    0.177520] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.177713] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.177740] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.177752] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.177764] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.177968] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.177985] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff]
[    0.178003] pci 0000:00:1c.3:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
[    0.178182] pci 0000:05:03.0: [11c1:5811] type 00 class 0x0c0010
[    0.178227] pci 0000:05:03.0: reg 0x10: [mem 0xd1000000-0xd1000fff]
[    0.178409] pci 0000:05:03.0: supports D1 D2
[    0.178416] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
[    0.178611] pci 0000:05:04.0: [10ee:3fc3] type 00 class 0x040100
[    0.178647] pci 0000:05:04.0: reg 0x10: [mem 0xd0000000-0xd0ffffff]
[    0.179006] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.179024] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.179042] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.179050] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.179150] pci_bus 0000:00: on NUMA node 0
[    0.182850] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.183246] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.183638] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 11 *12 14 15)
[    0.184042] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.184436] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.184827] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.185221] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.185618] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.186909] ACPI: \_SB_.PCI0: notify handler is installed
[    0.187177] Found 1 acpi root devices
[    0.188266] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.188296] vgaarb: loaded
[    0.188300] vgaarb: bridge control possible 0000:00:02.0
[    0.188616] SCSI subsystem initialized
[    0.188816] libata version 3.00 loaded.
[    0.188845] ACPI: bus type USB registered
[    0.188936] usbcore: registered new interface driver usbfs
[    0.188980] usbcore: registered new interface driver hub
[    0.189065] usbcore: registered new device driver usb
[    0.189187] PCI: Using ACPI for IRQ routing
[    0.204288] PCI: pci_cache_line_size set to 64 bytes
[    0.204442] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.204467] e820: reserve RAM buffer [mem 0x7f7f0000-0x7fffffff]
[    0.206217] hpet clockevent registered
[    0.206227] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.206238] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.206252] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.208428] Switched to clocksource hpet
[    0.236547] AppArmor: AppArmor Filesystem Enabled
[    0.236634] pnp: PnP ACPI init
[    0.236737] ACPI: bus type PNP registered
[    0.237517] system 00:00: [io  0x0b78-0x0b7b] has been reserved
[    0.237528] system 00:00: [io  0x0f78-0x0f7b] has been reserved
[    0.237538] system 00:00: [io  0x0a78-0x0a7b] has been reserved
[    0.237547] system 00:00: [io  0x0e78-0x0e7b] has been reserved
[    0.237556] system 00:00: [io  0x0bbc-0x0bbf] has been reserved
[    0.237566] system 00:00: [io  0x0fbc-0x0fbf] has been reserved
[    0.237575] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.237584] system 00:00: [io  0x0290-0x0297] has been reserved
[    0.237593] system 00:00: [io  0x0880-0x088f] has been reserved
[    0.237832] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.237896] pnp 00:01: [dma 4]
[    0.238002] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.238187] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.238324] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.238474] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.239614] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.240552] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.241941] pnp 00:07: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.242609] system 00:08: [io  0x4000-0x40bf] could not be reserved
[    0.242625] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.242818] pnp 00:09: Plug and Play ACPI device, IDs INT0800 (active)
[    0.244075] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.244090] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.245026] system 00:0b: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.245037] system 00:0b: [mem 0x000db800-0x000dbfff] has been reserved
[    0.245047] system 00:0b: [mem 0x000f0000-0x000fbfff] could not be reserved
[    0.245058] system 00:0b: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.245068] system 00:0b: [mem 0x7f7f0000-0x7f7fffff] could not be reserved
[    0.245078] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.245089] system 00:0b: [mem 0x00100000-0x7f7effff] could not be reserved
[    0.245099] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.245109] system 00:0b: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.245155] system 00:0b: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.245165] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.245174] system 00:0b: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.245184] system 00:0b: [mem 0xfff00000-0xffffffff] has been reserved
[    0.245193] system 00:0b: [mem 0x000e0000-0x000effff] has been reserved
[    0.245207] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.245249] pnp: PnP ACPI: found 12 devices
[    0.245254] ACPI: bus type PNP unregistered
[    0.288621] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.288638] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.288648] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.288674] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x001fffff pref] to [bus 02] add_size 200000
[    0.288699] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x001fffff pref] to [bus 03] add_size 200000
[    0.288724] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.288733] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    0.288742] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000
[    0.288782] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.288790] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.288799] pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.288807] pci 0000:00:1c.2: res[9]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.288815] pci 0000:00:1c.3: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.288823] pci 0000:00:1c.3: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.288831] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.288839] pci 0000:00:1c.3: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.288857] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
[    0.288868] pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.288879] pci 0000:00:1c.1: BAR 9: assigned [mem 0x80400000-0x806fffff pref]
[    0.288889] pci 0000:00:1c.2: BAR 9: assigned [mem 0x80700000-0x809fffff pref]
[    0.288899] pci 0000:00:1c.3: BAR 8: assigned [mem 0x80a00000-0x80bfffff]
[    0.288910] pci 0000:00:1c.3: BAR 9: assigned [mem 0x80c00000-0x80dfffff 64bit pref]
[    0.288923] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.288934] pci 0000:00:1c.3: BAR 7: assigned [io  0x2000-0x2fff]
[    0.288951] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.288962] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.288977] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.288989] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.289009] pci 0000:02:00.0: BAR 6: assigned [mem 0x80400000-0x8041ffff pref]
[    0.289017] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.289026] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.289041] pci 0000:00:1c.1:   bridge window [mem 0xd2100000-0xd21fffff]
[    0.289053] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x806fffff pref]
[    0.289072] pci 0000:03:00.0: BAR 6: assigned [mem 0x80700000-0x8071ffff pref]
[    0.289080] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.289089] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.289104] pci 0000:00:1c.2:   bridge window [mem 0xd2000000-0xd20fffff]
[    0.289116] pci 0000:00:1c.2:   bridge window [mem 0x80700000-0x809fffff pref]
[    0.289132] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.289141] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.289155] pci 0000:00:1c.3:   bridge window [mem 0x80a00000-0x80bfffff]
[    0.289168] pci 0000:00:1c.3:   bridge window [mem 0x80c00000-0x80dfffff 64bit pref]
[    0.289185] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.289200] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd1ffffff]
[    0.289223] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.289230] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.289238] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.289245] pci_bus 0000:01: resource 1 [mem 0x80000000-0x801fffff]
[    0.289252] pci_bus 0000:01: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.289260] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.289267] pci_bus 0000:02: resource 1 [mem 0xd2100000-0xd21fffff]
[    0.289275] pci_bus 0000:02: resource 2 [mem 0x80400000-0x806fffff pref]
[    0.289282] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.289289] pci_bus 0000:03: resource 1 [mem 0xd2000000-0xd20fffff]
[    0.289296] pci_bus 0000:03: resource 2 [mem 0x80700000-0x809fffff pref]
[    0.289304] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.289311] pci_bus 0000:04: resource 1 [mem 0x80a00000-0x80bfffff]
[    0.289319] pci_bus 0000:04: resource 2 [mem 0x80c00000-0x80dfffff 64bit pref]
[    0.289326] pci_bus 0000:05: resource 1 [mem 0xd0000000-0xd1ffffff]
[    0.289333] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    0.289340] pci_bus 0000:05: resource 5 [mem 0x00000000-0xffffffff]
[    0.289453] NET: Registered protocol family 2
[    0.290523] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.290692] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.292375] TCP: Hash tables configured (established 8192 bind 8192)
[    0.292517] TCP: reno registered
[    0.292530] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.292753] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.293438] NET: Registered protocol family 1
[    0.293481] pci 0000:00:02.0: Boot video device
[    1.896033] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    1.896505] PCI: CLS 32 bytes, default 64
[    1.897069] Unpacking initramfs...
[    2.150279] Freeing initrd memory: 4228K (f77ae000 - f7bcf000)
[    2.151216] microcode: CPU0 sig=0x6d8, pf=0x20, revision=0x20
[    2.151504] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.152712] audit: initializing netlink socket (disabled)
[    2.152837] type=2000 audit(1378801894.152:1): initialized
[    2.209240] bounce pool size: 64 pages
[    2.209257] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.209534] VFS: Disk quotas dquot_6.5.2
[    2.209564] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.210226] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.210794] fuse init (API version 7.22)
[    2.210972] msgmni has been set to 1723
[    2.229354] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.229409] io scheduler noop registered
[    2.229416] io scheduler deadline registered
[    2.229432] io scheduler cfq registered (default)
[    2.229956] pcieport 0000:00:1c.0: enabling device (0100 -> 0103)
[    2.230714] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.231618] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.232439] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    2.232638] pcieport 0000:00:1c.3: enabling device (0100 -> 0103)
[    2.233156] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    2.233867] intel_idle: does not run on family 6 model 13
[    2.234229] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    2.234365] ACPI: Power Button [PWRB]
[    2.234616] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.234629] ACPI: Power Button [PWRF]
[    2.235054] ACPI: Fan [FAN] (on)
[    2.235362] ACPI: Requesting acpi_cpufreq
[    2.238977] ACPI: AOpen i915GMm-HFS detected: disabling all active thermal trip points
[    2.238984] ACPI: AOpen i915GMm-HFS detected: disabling all passive thermal trip points
[    2.238990] ACPI: AOpen i915GMm-HFS detected: enabling thermal zone polling
[    2.241394] thermal LNXTHERM:00: registered as thermal_zone0
[    2.241401] ACPI: Thermal Zone [THRM] (53 C)
[    2.241735] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
[    2.263011] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.284334] 00:06: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    2.289999] lp: driver loaded but no devices found
[    2.290373] Non-volatile memory driver v1.3
[    2.290379] Linux agpgart interface v0.103
[    2.290553] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    2.290736] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    2.291456] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    2.291911] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.292121] [drm] Initialized drm 1.1.0 20060810
[    2.296388] [drm:i915_dump_device_info], i915 device info: gen=3, pciid=0x2592 flags=is_mobile,cursor_needs_physical,has_overlay,overlay_needs_physical,supports_tv,
[    2.296575] [drm] Memory usable by graphics device = 256M
[    2.296582] [drm:i915_gem_gtt_init], GMADR size = 256M
[    2.296588] [drm:i915_gem_gtt_init], GTT stolen size = 8M
[    2.296729] i915 0000:00:02.0: setting latency timer to 64
[    2.296863] [drm:intel_detect_pch], No PCH found?
[    2.297769] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[    2.297777] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[    2.297874] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.297879] [drm] Driver supports precise vblank timestamp query.
[    2.297885] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    2.298382] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 0 lvds_use_ssc 0 lvds_ssc_freq 96 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    2.298393] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    2.298435] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    2.298441] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.298471] [drm:parse_lfp_panel_data], VBT initial LVDS value 40000300
[    2.298497] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    2.298504] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.298517] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[    2.298525] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1, addr=70, wiring=1, ddc_pin=29, i2c_pin=5
[    2.298534] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
[    2.298542] [drm:parse_sdvo_device_mapping], SDVO device: dvo=2, addr=72, wiring=0, ddc_pin=29, i2c_pin=5
[    2.298715] [drm:i915_gem_init_stolen], found 8388608 bytes of stolen memory at 7f800000
[    2.299143] [drm:intel_modeset_init], 2 display pipes available.
[    2.299279] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.299286] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    2.299335] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.299341] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    2.299348] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
[    2.299366] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.299733] [drm] Skipping LVDS initialization for AOpen i915GMm-HFS
[    2.300157] [drm:intel_setup_outputs], probing SDVOB
[    2.300169] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 1
[    2.385056] [drm:intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.387333] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 02 3C 06 01 01 01 01 00
[    2.399233] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
[    2.399233]   vendor_id: 2
[    2.399233]   device_id: 60
[    2.399233]   device_rev_id: 6
[    2.399233]   sdvo_version_major: 1
[    2.399233]   sdvo_version_minor: 1
[    2.399233]   sdvo_inputs_mask: 1
[    2.399233]   smooth_scaling: 0
[    2.399233]   sharp_scaling: 0
[    2.399233]   up_scaling: 0
[    2.399233]   down_scaling: 0
[    2.399233]   stall_support: 0
[    2.399233]   output_flags: 1
[    2.399252] [drm:intel_sdvo_debug_write], SDVOB: W: 0C                         (SDVO_CMD_GET_HOT_PLUG_SUPPORT)
[    2.401542] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.405521] [drm:intel_sdvo_debug_write], SDVOB: W: 0D 01 00                   (SDVO_CMD_SET_ACTIVE_HOT_PLUG)
[    2.409678] [drm:intel_sdvo_debug_write], SDVOB: W: 9D                         (SDVO_CMD_GET_SUPP_ENCODE)
[    2.411953] [drm:intel_sdvo_read_response], SDVOB: R: (Not supported)... failed
[    2.413431] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    2.416655] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    2.417983] [drm:intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    2.420266] [drm:intel_sdvo_read_response], SDVOB: R: (Success) C4 09 20 4E
[    2.426871] [drm:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    2.426882] [drm:intel_setup_outputs], probing SDVOC
[    2.426889] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 2
[    2.511489] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.513773] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 C2 01 01 01 3D 3E 00
[    2.525677] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
[    2.525677]   vendor_id: 2
[    2.525677]   device_id: 194
[    2.525677]   device_rev_id: 1
[    2.525677]   sdvo_version_major: 1
[    2.525677]   sdvo_version_minor: 1
[    2.525677]   sdvo_inputs_mask: 1
[    2.525677]   smooth_scaling: 1
[    2.525677]   sharp_scaling: 1
[    2.525677]   up_scaling: 1
[    2.525677]   down_scaling: 1
[    2.525677]   stall_support: 0
[    2.525677]   output_flags: 62
[    2.525826] [drm:intel_sdvo_debug_write], SDVOC: W: 11 08 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.529985] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    2.531314] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.533600] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.542909] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.545200] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.549173] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.551448] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.558077] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.560365] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.564341] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.564352] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.566627] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.573255] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.575529] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.579510] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.579519] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.581806] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.588430] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.590705] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.594678] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.594686] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.596970] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.603578] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.605863] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.609840] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.609848] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.612134] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    2.618742] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.621030] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    2.625011] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.625019] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.627294] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.633919] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    2.636200] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.640173] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    2.640182] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    2.642457] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.649076] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    2.651350] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.655330] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    2.655339] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    2.657624] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    2.664252] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    2.666527] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    2.670507] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    2.670516] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    2.672805] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    2.679416] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    2.681700] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    2.685680] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    2.685689] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    2.687964] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    2.694589] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    2.696872] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    2.700847] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    2.700856] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    2.703131] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    2.709756] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    2.712045] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    2.716025] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    2.716034] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    2.718309] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    2.724934] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    2.727208] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.731189] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    2.731197] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    2.733477] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.737457] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    2.737591] [drm:intel_sdvo_debug_write], SDVOC: W: 11 04 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.741742] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    2.743071] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.745361] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.754641] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.756929] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.760908] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.763182] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.769805] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.772094] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.776076] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.776085] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.778360] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.784974] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.787249] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.791232] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.791240] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.793526] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.800155] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.802429] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.806410] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.806418] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.808708] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.815315] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.817599] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.821574] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.821583] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.823857] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    2.830483] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.832772] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    2.836749] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.836758] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.839033] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.845655] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    2.847930] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.851909] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    2.851918] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    2.854200] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.860828] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    2.863103] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.867077] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    2.867085] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    2.869372] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    2.875981] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    2.878271] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    2.882246] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    2.882255] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    2.884544] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    2.891156] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    2.893444] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    2.897425] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    2.897433] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    2.899708] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    2.906329] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    2.908618] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    2.912595] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    2.912603] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    2.914878] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    2.921506] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    2.923781] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    2.927761] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    2.927769] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    2.930059] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    2.936678] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    2.938953] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.942930] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    2.942938] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    2.945226] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.949206] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    2.949328] [drm:intel_sdvo_debug_write], SDVOC: W: 11 10 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.953478] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    2.954807] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.957096] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.966422] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.968710] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.972689] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.974964] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.981589] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.983863] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.987846] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.987855] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.990135] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.996763] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.999038] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    3.003014] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    3.003023] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    3.005312] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    3.011923] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    3.014212] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    3.018189] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    3.018198] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    3.020482] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    3.027096] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    3.029379] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    3.033360] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    3.033368] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    3.035643] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    3.042273] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    3.044561] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    3.048538] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    3.048547] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    3.050822] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    3.057440] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    3.059714] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    3.063695] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    3.063703] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    3.065989] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    3.072617] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    3.074891] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    3.078871] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    3.078880] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    3.081168] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    3.087777] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    3.090061] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    3.094035] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    3.094043] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    3.096332] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    3.102940] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    3.105225] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    3.109205] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    3.109214] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    3.111489] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    3.118114] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    3.120401] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    3.124375] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    3.124384] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    3.126659] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    3.133285] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    3.135560] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    3.139540] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    3.139553] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    3.148207] tsc: Refined TSC clocksource calibration: 1199.999 MHz
[    3.141839] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    3.148711] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    3.150986] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.154960] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    3.154969] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    3.157258] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.161238] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    3.161367] [drm:intel_sdvo_debug_write], SDVOC: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    3.164590] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    3.165918] [drm:intel_sdvo_debug_write], SDVOC: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    3.168200] [drm:intel_sdvo_read_response], SDVOC: R: (Success) C4 09 D8 40
[    3.174805] [drm:intel_sdvo_init], SDVOC device VID/DID: 02:C2.01, clock range 25MHz - 166MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    3.175004] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [0, ffff000]
[    3.178972] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    3.179121] [drm:i915_pages_create_for_stolen], offset=0x0, size=131072
[    3.179246] [drm:i915_gem_context_init], Disabling HW Contexts; old hardware
[    3.179719] [drm] initialized overlay support
[    3.179739] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: enabled
[    3.179748] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: disabled
[    3.179758] [drm:intel_modeset_readout_hw_state], [ENCODER:6:DAC-6] hw state readout: enabled, pipe=0
[    3.179768] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.182062] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.186031] [drm:intel_modeset_readout_hw_state], [ENCODER:7:TMDS-7] hw state readout: disabled, pipe=0
[    3.186041] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.188330] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.192303] [drm:intel_modeset_readout_hw_state], [ENCODER:9:DAC-9] hw state readout: disabled, pipe=0
[    3.192313] [drm:intel_modeset_readout_hw_state], [ENCODER:63:TV-63] hw state readout: disabled, pipe=0
[    3.192325] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:VGA-1] hw state readout: enabled
[    3.192334] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.194610] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.198588] [drm:intel_modeset_readout_hw_state], [CONNECTOR:8:DVI-D-1] hw state readout: disabled
[    3.198597] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.200887] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.204861] [drm:intel_modeset_readout_hw_state], [CONNECTOR:10:SVIDEO-1] hw state readout: disabled
[    3.204870] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.207145] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.211123] [drm:intel_modeset_readout_hw_state], [CONNECTOR:27:SVIDEO-2] hw state readout: disabled
[    3.211132] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.213413] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.217390] [drm:intel_modeset_readout_hw_state], [CONNECTOR:44:SVIDEO-3] hw state readout: disabled
[    3.217399] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.219674] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.223647] [drm:intel_modeset_readout_hw_state], [CONNECTOR:61:VGA-2] hw state readout: disabled
[    3.223656] [drm:intel_modeset_readout_hw_state], [CONNECTOR:62:SVIDEO-4] hw state readout: disabled
[    3.223669] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    3.223676] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    3.223682] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    3.223689] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.223697] [drm:intel_dump_pipe_config], requested mode:
[    3.223703] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 800 0 0 0 600 0 0 0 0x0 0x0
[    3.223712] [drm:intel_dump_pipe_config], adjusted mode:
[    3.223718] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 40000 0 0 0 0 0 0 0 0 0x0 0x5
[    3.223727] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.223734] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.223741] [drm:intel_dump_pipe_config], ips: 0
[    3.223750] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    3.223757] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.223763] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    3.223769] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.223777] [drm:intel_dump_pipe_config], requested mode:
[    3.223783] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    3.223792] [drm:intel_dump_pipe_config], adjusted mode:
[    3.223798] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    3.223807] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.223814] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.223821] [drm:intel_dump_pipe_config], ips: 0
[    3.223829] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.223838] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.226129] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.230098] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.232385] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.236361] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.238638] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.242614] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.244905] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.248877] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.251154] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.255132] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.255140] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.255149] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.257437] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.261410] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.261419] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.263694] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.267670] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.267678] [drm:check_crtc_state], [CRTC:3]
[    3.267703] [drm:check_crtc_state], [CRTC:4]
[    3.267784] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    3.267791] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[    3.268032] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.268043] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.268050] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.268057] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.308965] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.308973] [drm:intel_crt_detect_ddc], CRT detected via DDC:0x50 [EDID]
[    3.312029] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    3.312038] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    3.312045] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    3.312051] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    3.352945] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    3.353002] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[    3.353023] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] probed modes :
[    3.353030] [drm:drm_mode_debug_printmodeline], Modeline 86:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.353041] [drm:drm_mode_debug_printmodeline], Modeline 78:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.353051] [drm:drm_mode_debug_printmodeline], Modeline 93:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    3.353061] [drm:drm_mode_debug_printmodeline], Modeline 87:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    3.353071] [drm:drm_mode_debug_printmodeline], Modeline 88:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    3.353081] [drm:drm_mode_debug_printmodeline], Modeline 89:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    3.353091] [drm:drm_mode_debug_printmodeline], Modeline 90:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[    3.353101] [drm:drm_mode_debug_printmodeline], Modeline 91:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    3.353111] [drm:drm_mode_debug_printmodeline], Modeline 92:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    3.353121] [drm:drm_mode_debug_printmodeline], Modeline 79:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    3.353131] [drm:drm_mode_debug_printmodeline], Modeline 80:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    3.353141] [drm:drm_mode_debug_printmodeline], Modeline 81:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    3.353150] [drm:drm_mode_debug_printmodeline], Modeline 82:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[    3.353160] [drm:drm_mode_debug_printmodeline], Modeline 83:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[    3.353170] [drm:drm_mode_debug_printmodeline], Modeline 84:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    3.353180] [drm:drm_mode_debug_printmodeline], Modeline 85:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    3.353191] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[    3.353198] [drm:intel_sdvo_detect], [CONNECTOR:8:DVI-D-1]
[    3.353206] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.355481] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.359458] [drm:intel_sdvo_detect], SDVO response 0 0 [1]
[    3.359466] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] disconnected
[    3.359474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1]
[    3.359481] [drm:intel_sdvo_detect], [CONNECTOR:10:SVIDEO-1]
[    3.359488] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.361773] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.412014] [drm:intel_sdvo_detect], SDVO response 0 0 [8]
[    3.412022] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:SVIDEO-1] disconnected
[    3.412030] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2]
[    3.412037] [drm:intel_sdvo_detect], [CONNECTOR:27:SVIDEO-2]
[    3.412045] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.414320] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.463999] [drm:intel_sdvo_detect], SDVO response 0 0 [4]
[    3.464022] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:27:SVIDEO-2] disconnected
[    3.464030] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:SVIDEO-3]
[    3.464037] [drm:intel_sdvo_detect], [CONNECTOR:44:SVIDEO-3]
[    3.464044] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.466319] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.515999] [drm:intel_sdvo_detect], SDVO response 0 0 [10]
[    3.516021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:44:SVIDEO-3] disconnected
[    3.516029] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:61:VGA-2]
[    3.516036] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[    3.516043] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    3.518319] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.567999] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[    3.568021] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:61:VGA-2] disconnected
[    3.568029] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:62:SVIDEO-4]
[    3.568036] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=1
[    3.568045] [drm:intel_get_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[    3.568086] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    3.568397] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[    3.568408] [drm:connected_sink_compute_bpp], [CONNECTOR:62:SVIDEO-4] checking for sink bpp constrains
[    3.568416] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    3.568423] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    3.568430] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[    3.568437] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.568443] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    3.568450] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.568458] [drm:intel_dump_pipe_config], requested mode:
[    3.568464] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    3.568474] [drm:intel_dump_pipe_config], adjusted mode:
[    3.568480] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    3.568490] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.568497] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.568504] [drm:intel_dump_pipe_config], ips: 0
[    3.582369] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[    3.582391] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.582400] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.582407] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.582416] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.582425] [drm:i9xx_update_wm], memory self refresh disabled
[    3.582434] [drm:intel_crtc_mode_set], [ENCODER:63:TV-63] set [MODE:0:NTSC 480i]
[    3.587601] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.587609] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    3.587615] [drm:intel_calculate_wm], FIFO watermark level: -8
[    3.587623] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.587630] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 29
[    3.587638] [drm:i9xx_update_wm], self-refresh entries: 80
[    3.587645] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 29, C: 2, SR 15
[    3.587656] [drm:i9xx_update_wm], memory self refresh enabled
[    3.612038] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.612050] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.614497] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.618618] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.620989] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.625107] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.627465] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.631588] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.633956] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.638069] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.640441] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.644556] [drm:intel_connector_check_state], [CONNECTOR:62:SVIDEO-4]
[    3.644565] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.644573] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.644583] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.646940] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.651399] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.651409] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.653782] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.657903] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.657912] [drm:check_crtc_state], [CRTC:3]
[    3.657940] [drm:check_crtc_state], [CRTC:4]
[    3.657965] [drm:intel_pipe_config_compare] *ERROR* mismatch in adjusted_mode.flags(DRM_MODE_FLAG_NHSYNC) (expected 2, found 0)
[    3.658266] ------------[ cut here ]------------
[    3.658279] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/i915/intel_display.c:8746 check_crtc_state+0x6c5/0x6f9()
[    3.658284] pipe state doesn't match!
[    3.658288] Modules linked in:
[    3.658298] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-main+ #70
[    3.658303] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 11/04/2005
[    3.658308]  00000000 c07045ea f607989c c053ce72 f60798b4 c012a920 c03c86e3 00000000
[    3.658329]  f635b000 f6354c48 f60798cc c012a9aa 00000009 f60798c4 c07045ea f60798e0
[    3.658348]  f6079b34 c03c86e3 c07034b0 0000222a c07045ea f606a4f8 f634d344 f606a4fc
[    3.658368] Call Trace:
[    3.658381]  [<c053ce72>] dump_stack+0x16/0x18
[    3.658393]  [<c012a920>] warn_slowpath_common+0x5f/0x76
[    3.658402]  [<c03c86e3>] ? check_crtc_state+0x6c5/0x6f9
[    3.658411]  [<c012a9aa>] warn_slowpath_fmt+0x2b/0x2f
[    3.658420]  [<c03c86e3>] check_crtc_state+0x6c5/0x6f9
[    3.658448]  [<c03d1b57>] intel_modeset_check_state+0x30c/0x58b
[    3.658459]  [<c03d1dfc>] intel_set_mode+0x26/0x2f
[    3.658469]  [<c03d2d2b>] intel_get_load_detect_pipe+0x2b4/0x308
[    3.658482]  [<c03ecb4b>] intel_tv_detect+0x108/0x444
[    3.658500]  [<c0390d0e>] drm_helper_probe_single_connector_modes+0xa0/0x270
[    3.658513]  [<c038e812>] drm_fb_helper_probe_connector_modes+0x39/0x4c
[    3.658522]  [<c038fcf7>] drm_fb_helper_initial_config+0x143/0x3ac
[    3.658533]  [<c0542880>] ? _raw_spin_unlock_irqrestore+0x38/0x5b
[    3.658543]  [<c054288c>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.658553]  [<c054288c>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.658563]  [<c03ec49b>] intel_fbdev_initial_config+0x1e/0x20
[    3.658572]  [<c03a9e6d>] i915_driver_load+0xb48/0xd23
[    3.658587]  [<c039a63e>] drm_get_pci_dev+0x172/0x266
[    3.658596]  [<c054288c>] ? _raw_spin_unlock_irqrestore+0x44/0x5b
[    3.658606]  [<c03a7145>] i915_pci_probe+0x46/0x4f
[    3.658617]  [<c0307e94>] pci_device_probe+0x5e/0x96
[    3.658628]  [<c0404d2d>] driver_probe_device+0x83/0x17a
[    3.658637]  [<c0404e77>] __driver_attach+0x53/0x6f
[    3.658648]  [<c040378a>] bus_for_each_dev+0x43/0x6d
[    3.658657]  [<c040496b>] driver_attach+0x19/0x1b
[    3.658665]  [<c0404e24>] ? driver_probe_device+0x17a/0x17a
[    3.658674]  [<c04045b5>] bus_add_driver+0xc3/0x1ee
[    3.658683]  [<c0405375>] driver_register+0x73/0xa5
[    3.658692]  [<c0307f77>] __pci_register_driver+0x4a/0x4d
[    3.658705]  [<c07fc7bd>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[    3.658714]  [<c039a79f>] drm_pci_init+0x6d/0xc5
[    3.658724]  [<c07fc7bd>] ? ftrace_define_fields_drm_vblank_event+0x45/0x45
[    3.658734]  [<c07fc81b>] i915_init+0x5e/0x60
[    3.658743]  [<c01003b5>] do_one_initcall+0x6f/0xea
[    3.658752]  [<c0141331>] ? parameq+0x21/0x25
[    3.658761]  [<c014143d>] ? parse_args+0x108/0x209
[    3.658774]  [<c07d39c2>] kernel_init_freeable+0xce/0x153
[    3.658784]  [<c0537216>] kernel_init+0xd/0xb9
[    3.658794]  [<c0547f37>] ret_from_kernel_thread+0x1b/0x28
[    3.658802]  [<c0537209>] ? rest_init+0xa5/0xa5
[    3.658979] ---[ end trace 01950f85b98518f1 ]---
[    3.658984] [drm:intel_dump_pipe_config], [CRTC:4][hw state] config for pipe B
[    3.658992] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.658998] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    3.659005] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.659014] [drm:intel_dump_pipe_config], requested mode:
[    3.659020] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 1280 0 0 0 1024 0 0 0 0x0 0x0
[    3.659029] [drm:intel_dump_pipe_config], adjusted mode:
[    3.659035] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 108000 0 0 0 0 0 0 0 0 0x0 0x0
[    3.659045] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.659052] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.659059] [drm:intel_dump_pipe_config], ips: 0
[    3.659065] [drm:intel_dump_pipe_config], [CRTC:4][sw state] config for pipe B
[    3.659072] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    3.659078] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    3.659085] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.659093] [drm:intel_dump_pipe_config], requested mode:
[    3.659099] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    3.659109] [drm:intel_dump_pipe_config], adjusted mode:
[    3.659115] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 108000 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0xa
[    3.659125] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.659133] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.659140] [drm:intel_dump_pipe_config], ips: 0
[    3.696028] [drm:intel_tv_detect_type], TV detected: 400c0c07, 7f0000aa
[    3.696036] [drm:intel_tv_detect_type], Unrecognised TV connection
[    3.728028] [drm:intel_release_load_detect_pipe], [CONNECTOR:62:SVIDEO-4], [ENCODER:63:TV-63]
[    3.728038] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[    3.766923] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.766932] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.766939] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.766947] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.766956] [drm:i9xx_update_wm], memory self refresh disabled
[    3.766971] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.766980] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.769345] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.773462] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.775817] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.779936] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.782302] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.786421] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.788786] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.792900] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.795254] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.799369] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.799377] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.799386] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.801753] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.805869] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.805878] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.808241] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.812361] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.812369] [drm:check_crtc_state], [CRTC:3]
[    3.812394] [drm:check_crtc_state], [CRTC:4]
[    3.812403] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    3.814893] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:62:SVIDEO-4] disconnected
[    3.814902] [drm:drm_setup_crtcs], 
[    3.814910] [drm:drm_enable_connectors], connector 5 enabled? yes
[    3.814916] [drm:drm_enable_connectors], connector 8 enabled? no
[    3.814923] [drm:drm_enable_connectors], connector 10 enabled? no
[    3.814929] [drm:drm_enable_connectors], connector 27 enabled? no
[    3.814936] [drm:drm_enable_connectors], connector 44 enabled? no
[    3.814942] [drm:drm_enable_connectors], connector 61 enabled? no
[    3.814948] [drm:drm_enable_connectors], connector 62 enabled? no
[    3.814955] [drm:drm_target_preferred], looking for cmdline mode on connector 5
[    3.814962] [drm:drm_target_preferred], looking for preferred mode on connector 5
[    3.814970] [drm:drm_target_preferred], found mode 1280x1024
[    3.814976] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[    3.814986] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    3.815000] [drm:i915_gem_object_create_stolen], creating stolen object: size=500000
[    3.815041] [drm:i915_pages_create_for_stolen], offset=0x20000, size=5242880
[    3.819152] [drm:intelfb_create], allocated 1280x1024 fb: 0x00020000, bo f6376c80
[    3.820497] fbcon: inteldrmfb (fb0) is primary device
[    3.823651] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.823667] [drm:intel_set_config_compute_mode_changes], inactive crtc, full mode set
[    3.823672] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    3.823679] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    3.823688] [drm:drm_mode_debug_printmodeline], Modeline 94:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.823693] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
[    3.823700] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.823707] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    3.823715] [drm:connected_sink_compute_bpp], [CONNECTOR:5:VGA-1] checking for sink bpp constrains
[    3.823722] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    3.823727] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    3.823731] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    3.823736] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    3.823742] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.823746] [drm:intel_dump_pipe_config], requested mode:
[    3.823754] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.823758] [drm:intel_dump_pipe_config], adjusted mode:
[    3.823766] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    3.823771] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.823776] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000
[    3.823780] [drm:intel_dump_pipe_config], ips: 0
[    3.853645] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.853652] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.853656] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.853664] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.853670] [drm:i9xx_update_wm], memory self refresh disabled
[    3.854024] [drm:i9xx_update_plane], Writing base 00020000 00000000 0 0 5120
[    3.854035] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.854041] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.854046] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.854053] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.854060] [drm:i9xx_update_wm], memory self refresh disabled
[    3.854067] [drm:intel_crtc_mode_set], [ENCODER:6:DAC-6] set [MODE:0:1280x1024]
[    3.854075] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.854081] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.854086] [drm:intel_calculate_wm], FIFO entries required for mode: 43
[    3.854090] [drm:intel_calculate_wm], FIFO watermark level: -14
[    3.854095] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    3.854102] [drm:i9xx_update_wm], self-refresh entries: 80
[    3.854108] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[    3.854117] [drm:i9xx_update_wm], memory self refresh enabled
[    3.876037] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    3.876058] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.883173] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.883192] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.890298] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.890317] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.897424] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.897442] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.904550] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.904568] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.911661] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.911668] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.911674] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.911694] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.918795] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 00 00
[    3.918800] [drm:check_encoder_state], [ENCODER:9:DAC-9]
[    3.918820] [drm:intel_sdvo_debug_write], SDVOC: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.925922] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    3.925928] [drm:check_encoder_state], [ENCODER:63:TV-63]
[    3.925934] [drm:check_crtc_state], [CRTC:3]
[    3.925962] [drm:check_crtc_state], [CRTC:4]
[    3.925970] [drm:i9xx_crtc_clock_get], Unknown DPLL mode 00000000 in programmed mode
[    3.925978] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.925987] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.925993] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.926056] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.926065] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.926071] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.940553] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.940562] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.940568] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.954898] Console: switching to colour frame buffer device 160x64
[    3.954912] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[    3.954921] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.954926] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[    3.969511] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.969518] i915 0000:00:02.0: registered panic notifier
[    3.969584] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.970214] parport_pc 00:07: reported by Plug and Play ACPI
[    3.970381] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    4.068887] lp0: using parport0 (interrupt-driven).
[    4.074637] loop: module loaded
[    4.074840] ACPI Warning: 0x00004028-0x0000402f SystemIO conflicts with Region \PM2S 1 (20130725/utaddress-251)
[    4.074857] ACPI: This conflict may cause random problems and system instability
[    4.074863] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.074878] ACPI Warning: 0x000040b0-0x000040bf SystemIO conflicts with Region \GPO2 1 (20130725/utaddress-251)
[    4.074892] ACPI: This conflict may cause random problems and system instability
[    4.074897] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.074903] ACPI Warning: 0x00004080-0x000040af SystemIO conflicts with Region \GPO_ 1 (20130725/utaddress-251)
[    4.074917] ACPI: This conflict may cause random problems and system instability
[    4.074922] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.075051] Uniform Multi-Platform E-IDE driver
[    4.075175] piix 0000:00:1f.1: IDE controller (0x8086:0x266f rev 0x04)
[    4.075842] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    4.075854]     ide0: BM-DMA at 0xf000-0xf007
[    4.075870]     ide1: BM-DMA at 0xf008-0xf00f
[    4.075883] Probing IDE interface ide0...
[    4.148331] Switched to clocksource tsc
[    4.364325] hda: FUJITSU MHV2080AT, ATA DISK drive
[    5.036317] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.041273] hda: UDMA/100 mode selected
[    5.045873] Probing IDE interface ide1...
[    5.612342] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.637120] ide1 at 0x170-0x177,0x376 on irq 15
[    5.637571] ide-gd driver 1.18
[    5.637761] hda: max request size: 128KiB
[    5.637933] hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=65535/16/63
[    5.642593] hda: cache flushes supported
[    5.652578]  hda: hda1 hda2
[    5.654229] ide-cd driver 5.00
[    5.654649] ata_piix 0000:00:1f.2: version 2.13
[    5.655118] ata_piix 0000:00:1f.2: MAP [
[    5.655123]  P0 P2 -- -- ]
[    5.655295] ata_piix 0000:00:1f.2: setting latency timer to 64
[    5.657220] scsi0 : ata_piix
[    5.657877] scsi1 : ata_piix
[    5.658067] ata1: SATA max UDMA/133 cmd 0xe500 ctl 0xe600 bmdma 0xe900 irq 19
[    5.658074] ata2: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xe908 irq 19
[    5.658295] sky2: driver version 1.30
[    5.658572] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    5.658675] sky2 0000:02:00.0: irq 44 for MSI/MSI-X
[    5.659563] sky2 0000:02:00.0 eth0: addr 00:01:80:62:cf:b1
[    5.660585] sky2 0000:03:00.0: Yukon-2 EC chip revision 2
[    5.660677] sky2 0000:03:00.0: irq 45 for MSI/MSI-X
[    5.661152] sky2 0000:03:00.0 eth1: addr 00:01:80:62:cf:b2
[    5.661280] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.661285] ehci-pci: EHCI PCI platform driver
[    5.661787] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    5.661953] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    5.662356] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    5.666558] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    5.666667] ehci-pci 0000:00:1d.7: irq 23, io mem 0xd2344000
[    5.676026] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.676714] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.676723] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.676730] usb usb1: Product: EHCI Host Controller
[    5.676738] usb usb1: Manufacturer: Linux 3.11.0-main+ ehci_hcd
[    5.676744] usb usb1: SerialNumber: 0000:00:1d.7
[    5.678413] hub 1-0:1.0: USB hub found
[    5.678603] hub 1-0:1.0: 8 ports detected
[    5.680768] uhci_hcd: USB Universal Host Controller Interface driver
[    5.681269] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.681327] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.681373] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.681421] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e100
[    5.681703] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.681712] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.681719] usb usb2: Product: UHCI Host Controller
[    5.681726] usb usb2: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.681732] usb usb2: SerialNumber: 0000:00:1d.0
[    5.682261] hub 2-0:1.0: USB hub found
[    5.682337] hub 2-0:1.0: 2 ports detected
[    5.683377] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.683388] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.683411] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    5.683459] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e200
[    5.683660] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.683668] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.683676] usb usb3: Product: UHCI Host Controller
[    5.683682] usb usb3: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.683689] usb usb3: SerialNumber: 0000:00:1d.1
[    5.684262] hub 3-0:1.0: USB hub found
[    5.684296] hub 3-0:1.0: 2 ports detected
[    5.685273] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.685284] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.685336] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    5.685402] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e300
[    5.685603] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.685612] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.685618] usb usb4: Product: UHCI Host Controller
[    5.685625] usb usb4: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.685632] usb usb4: SerialNumber: 0000:00:1d.2
[    5.686228] hub 4-0:1.0: USB hub found
[    5.686262] hub 4-0:1.0: 2 ports detected
[    5.687231] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.687242] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.687266] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    5.687315] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e400
[    5.687512] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.687521] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.687528] usb usb5: Product: UHCI Host Controller
[    5.687535] usb usb5: Manufacturer: Linux 3.11.0-main+ uhci_hcd
[    5.687541] usb usb5: SerialNumber: 0000:00:1d.3
[    5.688070] hub 5-0:1.0: USB hub found
[    5.688106] hub 5-0:1.0: 2 ports detected
[    5.688713] usbcore: registered new interface driver usblp
[    5.688804] usbcore: registered new interface driver usb-storage
[    5.689218] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.859325] ata1.00: ATA-8: ST31000340NS, SN06, max UDMA/133
[    5.859333] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.915751] ata1.00: configured for UDMA/133
[    5.916906] scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN06 PQ: 0 ANSI: 5
[    5.919079] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.920406] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    5.920628] sd 0:0:0:0: [sda] Write Protect is off
[    5.920636] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.920729] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.924383]  sda: sda1 sda2 sda3 sda4
[    5.926285] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.940410] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.941607] mousedev: PS/2 mouse device common for all mice
[    5.943227] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    5.943558] rtc_cmos 00:02: RTC can wake from S4
[    5.944239] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    5.944305] rtc_cmos 00:02: alarms up to one month, 242 bytes nvram, hpet irqs
[    5.944907] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    5.945129] w83627hf: w83627hf: Found W83627THF chip at 0x290
[    5.945166] ACPI Warning: 0x00000295-0x00000296 SystemIO conflicts with Region \SEN1 1 (20130725/utaddress-251)
[    5.945182] ACPI: This conflict may cause random problems and system instability
[    5.945187] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.945880] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.945933] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x4060)
[    5.946617] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.946668] device-mapper: uevent: version 1.0.3
[    5.946885] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
[    5.948078] hidraw: raw HID events driver (C) Jiri Kosina
[    5.948491] usbcore: registered new interface driver usbhid
[    5.948496] usbhid: USB HID core driver
[    5.948847] TCP: cubic registered
[    5.948852] Initializing XFRM netlink socket
[    5.949505] Using IPI Shortcut mode
[    5.949905] PM: Checking hibernation image partition /dev/hda1
[    5.949947] PM: Hibernation image partition 3:1 present
[    5.949951] PM: Looking for hibernation image.
[    5.953596] PM: Image not found (code -22)
[    5.953603] PM: Hibernation image not present or could not be loaded.
[    5.953685] registered taskstats version 1
[    5.953698] AppArmor: AppArmor sha1 policy hashing enabled
[    5.954934] rtc_cmos 00:02: setting system clock to 2013-09-10 08:31:38 UTC (1378801898)
[    5.956471] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.956476] EDD information not available.
[    5.957398] Freeing unused kernel memory: 492K (c07d3000 - c084e000)
[    5.957766] Write protecting the kernel text: 4392k
[    5.958080] Write protecting the kernel read-only data: 2208k
[    5.958085] NX-protecting the kernel data: 4824k
[    6.084672] systemd-udevd[85]: starting version 195
[    6.580290] tsc: Marking TSC unstable due to cpufreq changes
[    6.580503] Switched to clocksource hpet
[    7.065605] EXT4-fs (hda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    7.445056] EXT4-fs (hda2): re-mounted. Opts: acl,user_xattr
[    8.542812] systemd[1]: systemd 195 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; suse)
[    8.647247] systemd[1]: Set hostname to <linux-ktth.site>.
[   10.100590] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[   10.101378] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   10.101460] systemd[1]: Starting Syslog Socket.
[   10.101814] systemd[1]: Listening on Syslog Socket.
[   10.101881] systemd[1]: Starting Remote File Systems.
[   10.101971] systemd[1]: Reached target Remote File Systems.
[   10.102039] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[   10.102243] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   10.102306] systemd[1]: Starting Delayed Shutdown Socket.
[   10.102531] systemd[1]: Listening on Delayed Shutdown Socket.
[   10.102634] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   10.103056] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   10.103472] systemd[1]: Starting udev Kernel Socket.
[   10.103666] systemd[1]: Listening on udev Kernel Socket.
[   10.103975] systemd[1]: Starting udev Control Socket.
[   10.104327] systemd[1]: Listening on udev Control Socket.
[   10.104395] systemd[1]: Starting Encrypted Volumes.
[   10.104484] systemd[1]: Reached target Encrypted Volumes.
[   10.104798] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[   10.106787] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   10.106856] systemd[1]: Expecting device dev-hda1.device...
[   10.106956] systemd[1]: Starting Journal Socket.
[   10.107584] systemd[1]: Listening on Journal Socket.
[   10.107663] systemd[1]: Starting LSB: Set default boot entry if called...
[   10.111282] systemd[1]: Starting Create dynamic rule for /dev/root link...
[   10.321094] systemd[1]: Starting Load Kernel Modules...
[   10.327632] systemd[1]: Mounting Huge Pages File System...
[   10.392124] systemd[1]: Started Set Up Additional Binary Formats.
[   10.392233] systemd[1]: Starting Setup Virtual Console...
[   10.395381] systemd[1]: Mounting POSIX Message Queue File System...
[   10.401152] systemd[1]: Started File System Check on Root Device.
[   10.401285] systemd[1]: Starting Remount Root and Kernel File Systems...
[   10.407280] systemd[1]: Starting Journal Service...
[   10.409677] systemd[1]: Started Journal Service.
[   11.459700] EXT4-fs (hda2): re-mounted. Opts: acl,user_xattr
[   12.644216] systemd-udevd[220]: starting version 195
[   13.030892] systemd-journald[196]: Received SIGUSR1
[   13.984574] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   13.984610] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   13.987027] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   14.047173] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   14.047194] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[   14.108170] [drm:intel_crtc_set_config], [CRTC:3] [FB:95] #connectors=1 (x y) (0 0)
[   14.108190] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   14.108203] [drm:intel_modeset_stage_output_state], [CONNECTOR:5:VGA-1] to [CRTC:3]
[   16.089001] Adding 4192252k swap on /dev/hda1.  Priority:-1 extents:1 across:4192252k 
[   16.904488] pci 0000:00:1e.0: setting latency timer to 64
[   19.480527] systemd-logind[354]: Watching system buttons on /dev/input/event1 (Power Button)
[   19.481218] systemd-logind[354]: Watching system buttons on /dev/input/event0 (Power Button)
[   20.621945] NET: Registered protocol family 10
[   24.064065] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   24.064089] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   24.067285] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   24.121586] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   24.121605] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[   32.693524] sky2 0000:02:00.0 eth0: enabling interface
[   32.693863] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.144088] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   34.144113] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   34.147308] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   34.205683] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   34.205694] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0
[   35.279585] sky2 0000:02:00.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   35.279835] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   44.224054] [drm:intel_sdvo_detect], [CONNECTOR:61:VGA-2]
[   44.224078] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[   44.227709] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[   44.281574] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[   44.281593] [drm:intel_tv_detect], [CONNECTOR:62:SVIDEO-4] force=0

--------------090900040203050500080206--
