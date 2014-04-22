Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaDVOAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:00:19 -0400
Received: from mailout03.t-online.de ([194.25.134.81]:53610 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaDVN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:59:52 -0400
Message-ID: <535675CC.1020402@t-online.de>
Date: Tue, 22 Apr 2014 15:59:40 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Intel-gfx] [Bug 3.15-rc2] [bisected] intel framebuffer broken
References: <53554B59.8080107@t-online.de> <87tx9lh95w.fsf@intel.com>
In-Reply-To: <87tx9lh95w.fsf@intel.com>
Content-Type: multipart/mixed;
 boundary="------------050504000602040001040002"
X-ID: ZZnCNrZr8hJi3sfLADYD06G0v7bKZB7lRVHadmi+xNWNUq25bU7NWtp5QLIgiy4g64
X-TOI-MSGID: c789be6b-6108-4b61-aa64-1e1164c30d16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050504000602040001040002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 22.04.2014 13:54, Jani Nikula wrote:
> On Mon, 21 Apr 2014, Knut Petersen <Knut_Petersen@t-online.de> wrote:
>> Booting kernel 3.15-rc2 on an AOpen i915GMm-hfs, I see the framebuffer broken.
>> Only about the upper left quarter of the monitor is used for displaying the boot messages,
>> these (and the cursor) are replicated at the right of that area.
> Is this before or after i915.ko is loaded?
No .ko, it's compiled directly into the kernel.

First bad commit is d978ef14456a38034f6c0e94a794129501f89200
(drm/i915: Wrap the preallocated BIOS framebuffer and preserve for KMS fbcon v12)

Probably there needs to be a v13 ;-)

cu,
  Knut


>
>> Approximately the lower half of the monitor stays black. The output of the xserver
>> is not affected.
> Most likely the fastest way to root cause is to bisect, please do. To
> keep track of all the bugs we have, please file a bug on DRM/Intel at
> [1] and while at it attach dmesg with drm.debug=0xe from the boot.
>
> BR,
> Jani.
>
>
> [1] https://bugs.freedesktop.org/enter_bug.cgi?product=DRI
>
>


--------------050504000602040001040002
Content-Type: text/plain; charset=UTF-8;
 name="dmesg_315rc2bug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg_315rc2bug"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-main-01064-gd978ef1 (knut@golem) (gcc version 4.8.1 20130909 [gcc-4_8-branch revision 202388] (SUSE Linux) ) #131 PREEMPT Tue Apr 22 15:32:59 CEST 2014
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
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
[    0.000000] DMI:    /i915GMm-HFS, BIOS 6.00 PG 09/14/2005
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x013fffff]
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37600000-0x377fffff]
[    0.000000]  [mem 0x37600000-0x377fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x34000000-0x375fffff]
[    0.000000]  [mem 0x34000000-0x375fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37800000-0x37bfdfff]
[    0.000000]  [mem 0x37800000-0x379fffff] page 2M
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x00de1000, 0x00de1fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x379fb000-0x37feffff]
[    0.000000] Allocated new RAMDISK: [mem 0x37406000-0x379fa331]
[    0.000000] Move RAMDISK from [mem 0x379fb000-0x37fef331] to [mem 0x37406000-0x379fa331]
[    0.000000] ACPI: RSDP 000f9320 000014 (v00 AOpen )
[    0.000000] ACPI: RSDT 7f7f3040 000038 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 7f7f30c0 000074 (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 7f7f3180 0042E3 (v01 AOPEN  AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f7f0000 000040
[    0.000000] ACPI: MCFG 7f7f7580 00003C (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 7f7f74c0 00005A (v01 AOpen  AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: SSDT 7f7f7600 000222 (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
[    0.000000] ACPI: SSDT 7f7f7a00 0000E0 (v01  PmRef    CpuPm 00003000 INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1147MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x00de2000, 0x00de2fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x7f7effff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x7f7effff]
[    0.000000] On node 0 totalpages: 522125
[    0.000000] free_area_init_node: node 0, pgdat c07ee748, node_mem_map f6416020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
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
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xdfffffff] available for PCI devices
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520341
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-KINGSTON_SKC100S3120G_50026B722C05CA1A-part1        netconsole=6665@192.168.22.15/eth0,6666@192.168.22.31/00:01:80:62:cf:b1        sky2.legacy_pme=1 acpi_enforce_resources=lax drm.debug=0xe 3 resume=/dev/sda3 i915.fastboot=1 pci=use_crs
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00037bfe:0007f7f0)
[    0.000000] Memory: 2051848K/2088500K available (4486K kernel code, 392K rwdata, 2252K rodata, 500K init, 5504K bss, 36652K reserved, 1175496K highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
      .init : 0xc07f9000 - 0xc0876000   ( 500 kB)
      .data : 0xc0561c7f - 0xc07f8100   (2649 kB)
      .text : 0xc0100000 - 0xc0561c7f   (4487 kB)
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
[    0.000000] tsc: Detected 1862.782 MHz processor
[    0.008002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3725.56 BogoMIPS (lpj=7451128)
[    0.008276] pid_max: default: 32768 minimum: 301
[    0.008476] Security Framework initialized
[    0.008623] AppArmor: AppArmor initialized
[    0.008774] Mount-cache hash table entries: 512
[    0.010338] Disabled fast string operations
[    0.010480] mce: CPU supports 5 MCE banks
[    0.010621] CPU0: Thermal monitoring enabled (TM1)
[    0.010774] Last level iTLB entries: 4KB 128, 2MB 0, 4MB 2
Last level dTLB entries: 4KB 128, 2MB 0, 4MB 8
tlb_flushall_shift: 6
[    0.011132] CPU: Intel(R) Pentium(R) M processor 1.86GHz (fam: 06, model: 0d, stepping: 08)
[    0.011488] ACPI: Core revision 20131115
[    0.020622] ACPI: All ACPI Tables successfully acquired
[    0.024017] ftrace: allocating 22743 entries in 45 pages
[    0.036596] Performance Events: p6 PMU driver.
[    0.036777] ... version:                0
[    0.036909] ... bit width:              32
[    0.037041] ... generic registers:      2
[    0.037173] ... value mask:             00000000ffffffff
[    0.037310] ... max period:             000000007fffffff
[    0.037446] ... fixed-purpose events:   0
[    0.037578] ... event mask:             0000000000000003
[    0.040928] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.041531] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044149] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.084000] devtmpfs: initialized
[    0.084000] PM: Registering ACPI NVS region [mem 0x7f7f0000-0x7f7f2fff] (12288 bytes)
[    0.084000] NET: Registered protocol family 16
[    0.084000] cpuidle: using governor ladder
[    0.084006] cpuidle: using governor menu
[    0.084310] ACPI: bus type PCI registered
[    0.084660] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.084907] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.085047] PCI: Using MMCONFIG for extended config space
[    0.085183] PCI: Using configuration type 1 for base access
[    0.090388] bio: create slab <bio-0> at 0
[    0.090801] ACPI: Added _OSI(Module Device)
[    0.090936] ACPI: Added _OSI(Processor Device)
[    0.091072] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.091206] ACPI: Added _OSI(Processor Aggregator Device)
[    0.108176] ACPI: Interpreter enabled
[    0.108321] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
[    0.108617] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.108971] ACPI: (supports S0 S3 S4 S5)
[    0.109104] ACPI: Using IOAPIC for interrupt routing
[    0.109311] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.129899] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.130047] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.130402] acpi PNP0A08:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.131088] PCI host bridge to bus 0000:00
[    0.131224] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.131364] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.131503] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.131644] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.131786] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.131927] pci_bus 0000:00: root bus resource [mem 0x7f800000-0xfebfffff]
[    0.132104] pci 0000:00:00.0: [8086:2590] type 00 class 0x060000
[    0.132605] pci 0000:00:02.0: [8086:2592] type 00 class 0x030000
[    0.132626] pci 0000:00:02.0: reg 0x10: [mem 0xd5300000-0xd537ffff]
[    0.132638] pci 0000:00:02.0: reg 0x14: [io  0xe400-0xe407]
[    0.132652] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff pref]
[    0.132665] pci 0000:00:02.0: reg 0x1c: [mem 0xd5400000-0xd543ffff]
[    0.132984] pci 0000:00:02.1: [8086:2792] type 00 class 0x038000
[    0.133002] pci 0000:00:02.1: reg 0x10: [mem 0xd5380000-0xd53fffff]
[    0.133397] pci 0000:00:1b.0: [8086:2668] type 00 class 0x040300
[    0.133424] pci 0000:00:1b.0: reg 0x10: [mem 0xd5440000-0xd5443fff 64bit]
[    0.133538] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.133967] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.134209] pci 0000:00:1c.0: [8086:2660] type 01 class 0x060400
[    0.134318] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.134539] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.134778] pci 0000:00:1c.1: [8086:2662] type 01 class 0x060400
[    0.134900] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.135121] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.135360] pci 0000:00:1c.2: [8086:2664] type 01 class 0x060400
[    0.135477] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.135700] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.136029] pci 0000:00:1c.3: [8086:2666] type 01 class 0x060400
[    0.136146] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.136368] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.136613] pci 0000:00:1d.0: [8086:2658] type 00 class 0x0c0300
[    0.136677] pci 0000:00:1d.0: reg 0x20: [io  0xe000-0xe01f]
[    0.136916] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.137154] pci 0000:00:1d.1: [8086:2659] type 00 class 0x0c0300
[    0.137218] pci 0000:00:1d.1: reg 0x20: [io  0xe100-0xe11f]
[    0.137457] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.137695] pci 0000:00:1d.2: [8086:265a] type 00 class 0x0c0300
[    0.137759] pci 0000:00:1d.2: reg 0x20: [io  0xe200-0xe21f]
[    0.137998] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.138235] pci 0000:00:1d.3: [8086:265b] type 00 class 0x0c0300
[    0.138299] pci 0000:00:1d.3: reg 0x20: [io  0xe300-0xe31f]
[    0.138538] pci 0000:00:1d.3: System wakeup disabled by ACPI
[    0.138788] pci 0000:00:1d.7: [8086:265c] type 00 class 0x0c0320
[    0.138815] pci 0000:00:1d.7: reg 0x10: [mem 0xd5444000-0xd54443ff]
[    0.138930] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.139141] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.139383] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
[    0.139668] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.139908] pci 0000:00:1f.0: [8086:2641] type 00 class 0x060100
[    0.140046] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.140058] pci 0000:00:1f.0: quirk: [io  0x4000-0x407f] claimed by ICH6 ACPI/GPIO/TCO
[    0.140306] pci 0000:00:1f.0: quirk: [io  0x4080-0x40bf] claimed by ICH6 GPIO
[    0.140452] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0280-02ff
[    0.140593] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 1640-164f
[    0.141015] pci 0000:00:1f.2: [8086:2653] type 00 class 0x010180
[    0.141039] pci 0000:00:1f.2: reg 0x10: [io  0x0000-0x0007]
[    0.141054] pci 0000:00:1f.2: reg 0x14: [io  0x0000-0x0003]
[    0.141068] pci 0000:00:1f.2: reg 0x18: [io  0x0000-0x0007]
[    0.141082] pci 0000:00:1f.2: reg 0x1c: [io  0x0000-0x0003]
[    0.141097] pci 0000:00:1f.2: reg 0x20: [io  0xf000-0xf00f]
[    0.141158] pci 0000:00:1f.2: PME# supported from D3hot
[    0.141459] pci 0000:00:1f.3: [8086:266a] type 00 class 0x0c0500
[    0.141533] pci 0000:00:1f.3: reg 0x20: [io  0x5000-0x501f]
[    0.141952] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.142095] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.142105] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff 64bit pref]
[    0.142248] pci 0000:02:00.0: [11ab:4362] type 00 class 0x020000
[    0.142283] pci 0000:02:00.0: reg 0x10: [mem 0xd5220000-0xd5223fff 64bit]
[    0.142302] pci 0000:02:00.0: reg 0x18: [io  0xa000-0xa0ff]
[    0.142363] pci 0000:02:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.142461] pci 0000:02:00.0: supports D1 D2
[    0.142465] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.142583] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.144137] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.144277] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.144285] pci 0000:00:1c.1:   bridge window [mem 0xd5200000-0xd52fffff]
[    0.144437] pci 0000:03:00.0: [11ab:4362] type 00 class 0x020000
[    0.144471] pci 0000:03:00.0: reg 0x10: [mem 0xd5020000-0xd5023fff 64bit]
[    0.144490] pci 0000:03:00.0: reg 0x18: [io  0xb000-0xb0ff]
[    0.144551] pci 0000:03:00.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    0.144649] pci 0000:03:00.0: supports D1 D2
[    0.144653] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.144771] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.145029] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.145169] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
[    0.145177] pci 0000:00:1c.2:   bridge window [mem 0xd5000000-0xd50fffff]
[    0.145322] pci 0000:04:00.0: [1095:3132] type 00 class 0x010400
[    0.145361] pci 0000:04:00.0: reg 0x10: [mem 0xd5184000-0xd518407f 64bit]
[    0.145391] pci 0000:04:00.0: reg 0x18: [mem 0xd5180000-0xd5183fff 64bit]
[    0.145411] pci 0000:04:00.0: reg 0x20: [io  0xc000-0xc07f]
[    0.145448] pci 0000:04:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.145541] pci 0000:04:00.0: supports D1 D2
[    0.145644] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.145908] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.146048] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.146055] pci 0000:00:1c.3:   bridge window [mem 0xd5100000-0xd51fffff]
[    0.146169] pci 0000:05:04.0: [1397:2bd0] type 00 class 0x028000
[    0.148008] pci 0000:05:04.0: reg 0x10: [io  0xd000-0xd007]
[    0.148025] pci 0000:05:04.0: reg 0x14: [mem 0xd4000000-0xd40000ff]
[    0.148128] pci 0000:05:04.0: supports D1 D2
[    0.148132] pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
[    0.148262] pci 0000:05:05.0: [14f1:8800] type 00 class 0x040000
[    0.148293] pci 0000:05:05.0: reg 0x10: [mem 0xd0000000-0xd0ffffff]
[    0.148525] pci 0000:05:05.1: [14f1:8801] type 00 class 0x048000
[    0.148552] pci 0000:05:05.1: reg 0x10: [mem 0xd1000000-0xd1ffffff]
[    0.148767] pci 0000:05:05.2: [14f1:8802] type 00 class 0x048000
[    0.148794] pci 0000:05:05.2: reg 0x10: [mem 0xd2000000-0xd2ffffff]
[    0.149010] pci 0000:05:05.4: [14f1:8804] type 00 class 0x048000
[    0.149037] pci 0000:05:05.4: reg 0x10: [mem 0xd3000000-0xd3ffffff]
[    0.149294] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.149435] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.149443] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd4ffffff]
[    0.149454] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.149459] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.149464] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.149469] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.149474] pci 0000:00:1e.0:   bridge window [mem 0x7f800000-0xfebfffff] (subtractive decode)
[    0.149538] pci_bus 0000:00: on NUMA node 0
[    0.151829] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.152467] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 *12 14 15)
[    0.153101] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.153737] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.154371] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.155152] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.155931] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.156704] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 12 14 15)
[    0.157899] ACPI: \_SB_.PCI0: notify handler is installed
[    0.158068] Found 1 acpi root devices
[    0.158733] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.158992] vgaarb: loaded
[    0.159123] vgaarb: bridge control possible 0000:00:02.0
[    0.159465] SCSI subsystem initialized
[    0.159727] libata version 3.00 loaded.
[    0.159747] ACPI: bus type USB registered
[    0.159934] usbcore: registered new interface driver usbfs
[    0.160032] usbcore: registered new interface driver hub
[    0.160222] usbcore: registered new device driver usb
[    0.160430] PCI: Using ACPI for IRQ routing
[    0.168904] PCI: pci_cache_line_size set to 64 bytes
[    0.169011] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.169026] e820: reserve RAM buffer [mem 0x7f7f0000-0x7fffffff]
[    0.170027] hpet clockevent registered
[    0.170034] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.170177] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.170403] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.172268] Switched to clocksource hpet
[    0.192062] AppArmor: AppArmor Filesystem Enabled
[    0.192292] pnp: PnP ACPI init
[    0.192494] ACPI: bus type PNP registered
[    0.193133] system 00:00: [io  0x0b78-0x0b7b] has been reserved
[    0.193278] system 00:00: [io  0x0f78-0x0f7b] has been reserved
[    0.193419] system 00:00: [io  0x0a78-0x0a7b] has been reserved
[    0.193558] system 00:00: [io  0x0e78-0x0e7b] has been reserved
[    0.193700] system 00:00: [io  0x0bbc-0x0bbf] has been reserved
[    0.193839] system 00:00: [io  0x0fbc-0x0fbf] has been reserved
[    0.193980] system 00:00: [io  0x04d0-0x04d1] has been reserved
[    0.194119] system 00:00: [io  0x0290-0x0297] has been reserved
[    0.194259] system 00:00: [io  0x0880-0x088f] has been reserved
[    0.194541] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.194582] pnp 00:01: [dma 4]
[    0.194650] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.194761] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.194847] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.194945] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.195660] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.196252] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.197211] pnp 00:07: [dma 3]
[    0.197323] pnp 00:07: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.197510] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.197712] system 00:09: [io  0x4000-0x40bf] could not be reserved
[    0.197859] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197981] pnp 00:0a: Plug and Play ACPI device, IDs INT0800 (active)
[    0.198771] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.198918] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.199426] system 00:0c: [mem 0x000d7800-0x000d7fff] has been reserved
[    0.199571] system 00:0c: [mem 0x000f0000-0x000f7fff] could not be reserved
[    0.199714] system 00:0c: [mem 0x000f8000-0x000fbfff] could not be reserved
[    0.199858] system 00:0c: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.200001] system 00:0c: [mem 0x7f7f0000-0x7f7fffff] could not be reserved
[    0.200155] system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.200298] system 00:0c: [mem 0x00100000-0x7f7effff] could not be reserved
[    0.200441] system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.200583] system 00:0c: [mem 0xfed13000-0xfed1dfff] has been reserved
[    0.200727] system 00:0c: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.200868] system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.201012] system 00:0c: [mem 0xffb00000-0xffb7ffff] has been reserved
[    0.201153] system 00:0c: [mem 0xfff00000-0xffffffff] has been reserved
[    0.201296] system 00:0c: [mem 0x000e0000-0x000effff] has been reserved
[    0.201441] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.201467] pnp: PnP ACPI: found 13 devices
[    0.201601] ACPI: bus type PNP unregistered
[    0.241904] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.241914] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.241920] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.241935] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x001fffff pref] to [bus 02] add_size 200000
[    0.241950] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x001fffff pref] to [bus 03] add_size 200000
[    0.241965] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x001fffff pref] to [bus 04] add_size 200000
[    0.241988] pci 0000:00:1c.0: res[8]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.241993] pci 0000:00:1c.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.241999] pci 0000:00:1c.1: res[9]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.242004] pci 0000:00:1c.2: res[9]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.242009] pci 0000:00:1c.3: res[9]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    0.242014] pci 0000:00:1c.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.242024] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x801fffff]
[    0.242171] pci 0000:00:1c.0: BAR 9: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.242417] pci 0000:00:1c.1: BAR 9: assigned [mem 0x80400000-0x806fffff pref]
[    0.242660] pci 0000:00:1c.2: BAR 9: assigned [mem 0x80700000-0x809fffff pref]
[    0.242903] pci 0000:00:1c.3: BAR 9: assigned [mem 0x80a00000-0x80cfffff pref]
[    0.243148] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.243290] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.243429] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.243572] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.243717] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.243967] pci 0000:02:00.0: BAR 6: assigned [mem 0x80400000-0x8041ffff pref]
[    0.244216] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.244355] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.244497] pci 0000:00:1c.1:   bridge window [mem 0xd5200000-0xd52fffff]
[    0.244642] pci 0000:00:1c.1:   bridge window [mem 0x80400000-0x806fffff pref]
[    0.244889] pci 0000:03:00.0: BAR 6: assigned [mem 0x80700000-0x8071ffff pref]
[    0.245128] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.245265] pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
[    0.245411] pci 0000:00:1c.2:   bridge window [mem 0xd5000000-0xd50fffff]
[    0.245555] pci 0000:00:1c.2:   bridge window [mem 0x80700000-0x809fffff pref]
[    0.245802] pci 0000:04:00.0: BAR 6: assigned [mem 0x80a00000-0x80a7ffff pref]
[    0.246044] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.246181] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
[    0.246324] pci 0000:00:1c.3:   bridge window [mem 0xd5100000-0xd51fffff]
[    0.246467] pci 0000:00:1c.3:   bridge window [mem 0x80a00000-0x80cfffff pref]
[    0.246716] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.246853] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    0.246998] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd4ffffff]
[    0.247147] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.247152] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.247156] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.247161] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.247165] pci_bus 0000:00: resource 8 [mem 0x7f800000-0xfebfffff]
[    0.247170] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.247174] pci_bus 0000:01: resource 1 [mem 0x80000000-0x801fffff]
[    0.247179] pci_bus 0000:01: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.247184] pci_bus 0000:02: resource 0 [io  0xa000-0xafff]
[    0.247188] pci_bus 0000:02: resource 1 [mem 0xd5200000-0xd52fffff]
[    0.247192] pci_bus 0000:02: resource 2 [mem 0x80400000-0x806fffff pref]
[    0.247197] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
[    0.247202] pci_bus 0000:03: resource 1 [mem 0xd5000000-0xd50fffff]
[    0.247206] pci_bus 0000:03: resource 2 [mem 0x80700000-0x809fffff pref]
[    0.247211] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.247215] pci_bus 0000:04: resource 1 [mem 0xd5100000-0xd51fffff]
[    0.247219] pci_bus 0000:04: resource 2 [mem 0x80a00000-0x80cfffff pref]
[    0.247224] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.247228] pci_bus 0000:05: resource 1 [mem 0xd0000000-0xd4ffffff]
[    0.247233] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.247237] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.247242] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.247246] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000dffff]
[    0.247250] pci_bus 0000:05: resource 8 [mem 0x7f800000-0xfebfffff]
[    0.247326] NET: Registered protocol family 2
[    0.248104] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.248323] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.249510] TCP: Hash tables configured (established 8192 bind 8192)
[    0.249731] TCP: reno registered
[    0.249867] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.250144] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.250721] NET: Registered protocol family 1
[    0.250882] pci 0000:00:02.0: Boot video device
[    1.852022] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    1.852465] PCI: CLS 32 bytes, default 64
[    1.852853] Unpacking initramfs...
[    2.103109] Freeing initrd memory: 6100K (f7406000 - f79fb000)
[    2.103891] microcode: CPU0 sig=0x6d8, pf=0x20, revision=0x20
[    2.104297] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.105286] audit: initializing netlink socket (disabled)
[    2.105504] type=2000 audit(1398174179.104:1): initialized
[    2.145984] bounce pool size: 64 pages
[    2.146121] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.146615] VFS: Disk quotas dquot_6.5.2
[    2.146765] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.147322] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.147796] fuse init (API version 7.22)
[    2.148062] msgmni has been set to 1723
[    2.161978] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.162254] io scheduler noop registered
[    2.162388] io scheduler deadline registered
[    2.162527] io scheduler cfq registered (default)
[    2.163007] pcieport 0000:00:1c.0: enabling device (0100 -> 0103)
[    2.163645] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.164295] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.164727] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    2.165139] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    2.165603] intel_idle: does not run on family 6 model 13
[    2.165824] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    2.166146] ACPI: Power Button [PWRB]
[    2.166436] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.166682] ACPI: Power Button [PWRF]
[    2.167069] ACPI: Fan [FAN] (on)
[    2.167381] ACPI: AOpen i915GMm-HFS detected: disabling all active thermal trip points
[    2.167622] ACPI: AOpen i915GMm-HFS detected: disabling all passive thermal trip points
[    2.167861] ACPI: AOpen i915GMm-HFS detected: enabling thermal zone polling
[    2.169578] thermal LNXTHERM:00: registered as thermal_zone0
[    2.169717] ACPI: Thermal Zone [THRM] (61 C)
[    2.169971] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
[    2.190965] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.212060] 00:06: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    2.216353] lp: driver loaded but no devices found
[    2.216724] Non-volatile memory driver v1.3
[    2.216855] Linux agpgart interface v0.103
[    2.217101] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    2.217336] agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
[    2.218068] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    2.218520] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    2.218758] [drm] Initialized drm 1.1.0 20060810
[    2.221333] [drm:i915_dump_device_info], i915 device info: gen=3, pciid=0x2592 flags=is_mobile,has_fbc,cursor_needs_physical,has_overlay,overlay_needs_physical,supports_tv,
[    2.221459] [drm:intel_detect_pch], No PCH found?
[    2.221465] [drm] Memory usable by graphics device = 256M
[    2.221601] [drm:i915_gem_gtt_init], GMADR size = 256M
[    2.221604] [drm:i915_gem_gtt_init], GTT stolen size = 8M
[    2.222858] [drm:intel_opregion_setup], graphic opregion physical addr: 0x0
[    2.222864] [drm:intel_opregion_setup], ACPI OpRegion not supported!
[    2.222931] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.223076] [drm] Driver supports precise vblank timestamp query.
[    2.223216] [drm:init_vbt_defaults], Set default to SSC at 100000 kHz
[    2.223653] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 1 int_crt_support 0 lvds_use_ssc 0 lvds_ssc_freq 96000 display_clock_mode 0 fdi_rx_polarity_inverted 0
[    2.223659] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    2.223692] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    2.223698] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.223720] [drm:parse_lfp_panel_data], VBT initial LVDS value 40000300
[    2.223733] [drm:parse_lfp_backlight], VBT backlight PWM modulation frequency 200 Hz, active low, min brightness 0, level 0
[    2.223755] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    2.223761] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    2.223767] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 70 is found on SDVOB port
[    2.223773] [drm:parse_sdvo_device_mapping], SDVO device: dvo=1, addr=70, wiring=1, ddc_pin=29, i2c_pin=5
[    2.223777] [drm:parse_sdvo_device_mapping], the SDVO device with slave addr 72 is found on SDVOC port
[    2.223782] [drm:parse_sdvo_device_mapping], SDVO device: dvo=2, addr=72, wiring=0, ddc_pin=29, i2c_pin=5
[    2.223833] [drm:parse_mipi], No MIPI BDB found
[    2.223922] [drm:i915_gem_init_stolen], found 8388608 bytes of stolen memory at 7f800000
[    2.223985] [drm:intel_display_power_get], enabling always-on
[    2.224405] [drm:intel_modeset_init], 2 display pipes available.
[    2.224508] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.224512] [drm:intel_modeset_init], pipe A sprite A init failed: -19
[    2.224524] [drm:intel_crtc_init], swapping pipes & planes for FBC
[    2.224528] [drm:intel_modeset_init], pipe B sprite B init failed: -19
[    2.224540] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.225123] [drm] Skipping LVDS initialization for AOpen i915GMm-HFS
[    2.228383] [drm:intel_setup_outputs], probing SDVOB
[    2.228388] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 1
[    2.301204] [drm:intel_sdvo_debug_write], SDVOB: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.313354] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 02 3C 06 01 01 01 01 00
[    2.313362] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
  vendor_id: 2
  device_id: 60
  device_rev_id: 6
  sdvo_version_major: 1
  sdvo_version_minor: 1
  sdvo_inputs_mask: 1
  smooth_scaling: 0
  sharp_scaling: 0
  up_scaling: 0
  down_scaling: 0
  stall_support: 0
  output_flags: 1
[    2.313376] [drm:intel_sdvo_dvi_init], initialising DVI device 0
[    2.313383] [drm:intel_sdvo_debug_write], SDVOB: W: 0C                         (SDVO_CMD_GET_HOT_PLUG_SUPPORT)
[    2.318730] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.318736] [drm:intel_sdvo_debug_write], SDVOB: W: 0D 01 00                   (SDVO_CMD_SET_ACTIVE_HOT_PLUG)
[    2.322303] [drm:intel_sdvo_debug_write], SDVOB: W: 9D                         (SDVO_CMD_GET_SUPP_ENCODE)
[    2.325385] [drm:intel_sdvo_read_response], SDVOB: R: ... failed
[    2.325475] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    2.329359] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    2.329365] [drm:intel_sdvo_debug_write], SDVOB: W: 1D                         (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE)
[    2.336975] [drm:intel_sdvo_read_response], SDVOB: R: (Success) C4 09 20 4E
[    2.336980] [drm:intel_sdvo_init], SDVOB device VID/DID: 02:3C.06, clock range 25MHz - 200MHz, input 1: Y, input 2: N, output 1: Y, output 2: N
[    2.336985] [drm:intel_setup_outputs], probing SDVOC
[    2.336992] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus dpb. force bit now 2
[    2.409700] [drm:intel_sdvo_debug_write], SDVOC: W: 02                         (SDVO_CMD_GET_DEVICE_CAPS)
[    2.421845] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 C2 01 01 01 3D 3E 00
[    2.421852] [drm:intel_sdvo_get_capabilities], SDVO capabilities:
  vendor_id: 2
  device_id: 194
  device_rev_id: 1
  sdvo_version_major: 1
  sdvo_version_minor: 1
  sdvo_inputs_mask: 1
  smooth_scaling: 1
  sharp_scaling: 1
  up_scaling: 1
  down_scaling: 1
  stall_support: 0
  output_flags: 62
[    2.421866] [drm:intel_sdvo_tv_init], initialising TV type 8
[    2.421959] [drm:intel_sdvo_debug_write], SDVOC: W: 11 08 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    2.426662] [drm:intel_sdvo_read_response], SDVOC: R: (Success)
[    2.426668] [drm:intel_sdvo_debug_write], SDVOC: W: 27                         (SDVO_CMD_GET_SUPPORTED_TV_FORMATS)
[    2.436547] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF FF FF FF FF 1F
[    2.436581] [drm:intel_sdvo_debug_write], SDVOC: W: 84                         (SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS)
[    2.441931] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FA DF
[    2.441937] [drm:intel_sdvo_debug_write], SDVOC: W: 61                         (SDVO_CMD_GET_MAX_OVERSCAN_H)
[    2.449558] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.449564] [drm:intel_sdvo_debug_write], SDVOC: W: 62                         (SDVO_CMD_GET_OVERSCAN_H)
[    2.454913] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.454921] [drm:intel_sdvo_create_enhance_property_tv], h_overscan: max 47, default 32, current 32
[    2.454927] [drm:intel_sdvo_debug_write], SDVOC: W: 64                         (SDVO_CMD_GET_MAX_OVERSCAN_V)
[    2.462549] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 2F 00 20 00
[    2.462554] [drm:intel_sdvo_debug_write], SDVOC: W: 65                         (SDVO_CMD_GET_OVERSCAN_V)
[    2.467902] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 20 00
[    2.467909] [drm:intel_sdvo_create_enhance_property_tv], v_overscan: max 47, default 32, current 32
[    2.467915] [drm:intel_sdvo_debug_write], SDVOC: W: 67                         (SDVO_CMD_GET_MAX_HPOS)
[    2.475537] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.475543] [drm:intel_sdvo_debug_write], SDVOC: W: 68                         (SDVO_CMD_GET_HPOS)
[    2.480891] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.480897] [drm:intel_sdvo_create_enhance_property_tv], hpos: max 1023, default 512, current 512
[    2.480902] [drm:intel_sdvo_debug_write], SDVOC: W: 6A                         (SDVO_CMD_GET_MAX_VPOS)
[    2.488523] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 03 00 02
[    2.488529] [drm:intel_sdvo_debug_write], SDVOC: W: 6B                         (SDVO_CMD_GET_VPOS)
[    2.493875] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 02
[    2.493881] [drm:intel_sdvo_create_enhance_property_tv], vpos: max 1023, default 512, current 512
[    2.493886] [drm:intel_sdvo_debug_write], SDVOC: W: 55                         (SDVO_CMD_GET_MAX_SATURATION)
[    2.501502] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 45 00
[    2.501508] [drm:intel_sdvo_debug_write], SDVOC: W: 56                         (SDVO_CMD_GET_SATURATION)
[    2.506857] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 45 00
[    2.506863] [drm:intel_sdvo_create_enhance_property_tv], saturation: max 127, default 69, current 69
[    2.506869] [drm:intel_sdvo_debug_write], SDVOC: W: 5E                         (SDVO_CMD_GET_MAX_CONTRAST)
[    2.514491] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.514497] [drm:intel_sdvo_debug_write], SDVOC: W: 5F                         (SDVO_CMD_GET_CONTRAST)
[    2.519846] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.519852] [drm:intel_sdvo_create_enhance_property_tv], contrast: max 127, default 64, current 64
[    2.519857] [drm:intel_sdvo_debug_write], SDVOC: W: 58                         (SDVO_CMD_GET_MAX_HUE)
[    2.527473] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 7F 00 40 00
[    2.527479] [drm:intel_sdvo_debug_write], SDVOC: W: 59                         (SDVO_CMD_GET_HUE)
[    2.532832] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 40 00
[    2.532838] [drm:intel_sdvo_create_enhance_property_tv], hue: max 127, default 64, current 64
[    2.532844] [drm:intel_sdvo_debug_write], SDVOC: W: 6D                         (SDVO_CMD_GET_MAX_SHARPNESS)
[    2.540467] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 04 00
[    2.540473] [drm:intel_sdvo_debug_write], SDVOC: W: 6E                         (SDVO_CMD_GET_SHARPNESS)
[    2.545819] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 04 00
[    2.545825] [drm:intel_sdvo_create_enhance_property_tv], sharpness: max 7, default 4, current 4
[    2.545830] [drm:intel_sdvo_debug_write], SDVOC: W: 5B                         (SDVO_CMD_GET_MAX_BRIGHTNESS)
[    2.553446] [drm:intel_sdvo_read_response], SDVOC: R: (Success) FF 00 80 00
[    2.553451] [drm:intel_sdvo_debug_write], SDVOC: W: 5C                         (SDVO_CMD_GET_BRIGHTNESS)
[    2.558797] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 80 00
[    2.558804] [drm:intel_sdvo_create_enhance_property_tv], brightness: max 255, default 128, current 128
[    2.558809] [drm:intel_sdvo_debug_write], SDVOC: W: 7B                         (SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE)
[    2.566432] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00 07 00
[    2.566438] [drm:intel_sdvo_debug_write], SDVOC: W: 50                         (SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE)
[    2.571783] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 07 00
[    2.571789] [drm:intel_sdvo_create_enhance_property_tv], flicker_filter_adaptive: max 7, default 7, current 7
[    2.571795] [drm:intel_sdvo_debug_write], SDVOC: W: 74                         (SDVO_CMD_GET_MAX_TV_CHROMA_FILTER)
[    2.579413] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 03 00 01 00
[    2.579418] [drm:intel_sdvo_debug_write], SDVOC: W: 75                         (SDVO_CMD_GET_TV_CHROMA_FILTER)
[    2.584769] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 01 00
[    2.584775] [drm:intel_sdvo_create_enhance_property_tv], tv_chroma_filter: max 3, default 1, current 1
[    2.584781] [drm:intel_sdvo_debug_write], SDVOC: W: 77                         (SDVO_CMD_GET_MAX_TV_LUMA_FILTER)
[    2.592397] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 02 00 00 00
[    2.592402] [drm:intel_sdvo_debug_write], SDVOC: W: 78                         (SDVO_CMD_GET_TV_LUMA_FILTER)
[    2.597751] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.597757] [drm:intel_sdvo_create_enhance_property_tv], tv_luma_filter: max 2, default 0, current 0
[    2.597763] [drm:intel_sdvo_debug_write], SDVOC: W: 70                         (SDVO_CMD_GET_DOT_CRAWL)
[    2.603112] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[    2.603118] [drm:intel_sdvo_create_enhance_property_tv], dot crawl: current 0
[    2.603121] [drm:intel_sdvo_tv_init], initialising TV type 4
[    2.603235] ------------[ cut here ]------------
[    2.603371] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:486 sysfs_warn_dup+0x68/0x7a()
[    2.603605] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:02.0/i2c-7/i2c-7'
[    2.603841] Modules linked in:
[    2.603992] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-main-01064-gd978ef1 #131
[    2.604232] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 09/14/2005
[    2.604367]  00000000 f6079c64 f6079c3c c055593e f6079c54 c012a6a9 c022bc73 f6366000
[    2.604781]  f6366000 f6367200 f6079c6c c012a6eb 00000009 f6079c64 c06f0720 f6079c80
[    2.605194]  f6079c90 c022bc73 c06f06d0 000001e6 c06f0720 f6366000 f6367200 f6371c00
[    2.605606] Call Trace:
[    2.605736]  [<c055593e>] dump_stack+0x16/0x18
[    2.605871]  [<c012a6a9>] warn_slowpath_common+0x5f/0x76
[    2.606005]  [<c022bc73>] ? sysfs_warn_dup+0x68/0x7a
[    2.606139]  [<c012a6eb>] warn_slowpath_fmt+0x2b/0x2f
[    2.606273]  [<c022bc73>] sysfs_warn_dup+0x68/0x7a
[    2.606407]  [<c022bcaa>] sysfs_add_one+0x25/0x2c
[    2.606541]  [<c022c567>] sysfs_do_create_link_sd.isra.2+0xc4/0x136
[    2.606678]  [<c022c5fd>] sysfs_create_link+0x24/0x2e
[    2.606814]  [<c0405e55>] intel_sdvo_connector_init+0x82/0xa2
[    2.606950]  [<c0407ad4>] intel_sdvo_tv_init+0x81/0x1cf
[    2.607086]  [<c0408a7b>] intel_sdvo_init+0x2ef/0x658
[    2.607221]  [<c039e331>] ? drm_ut_debug_printk+0x41/0x55
[    2.607358]  [<c03ed664>] intel_modeset_init+0xabd/0xdae
[    2.607494]  [<c055e27a>] ? preempt_count_sub+0xa8/0xb5
[    2.607630]  [<c055ae44>] ? _raw_spin_unlock_irqrestore+0x44/0x56
[    2.607768]  [<c03cfec6>] ? i915_irq_postinstall+0xee/0xf8
[    2.607903]  [<c039c688>] ? drm_irq_install+0x155/0x1b5
[    2.608046]  [<c03d0fbf>] ? i965_irq_handler+0x480/0x480
[    2.608181]  [<c040c7b4>] i915_driver_load+0xa53/0xcc3
[    2.608318]  [<c039e8cb>] drm_dev_register+0xb8/0x11b
[    2.608452]  [<c03a04d1>] drm_get_pci_dev+0xec/0x18a
[    2.608587]  [<c03acd4a>] i915_pci_probe+0x3e/0x47
[    2.608722]  [<c030d636>] pci_device_probe+0x5c/0xa4
[    2.608857]  [<c0419fce>] driver_probe_device+0x83/0x17a
[    2.608991]  [<c041a149>] __driver_attach+0x53/0x6f
[    2.609127]  [<c0418b32>] bus_for_each_dev+0x58/0x67
[    2.609261]  [<c0419bf2>] driver_attach+0x19/0x1b
[    2.609394]  [<c041a0f6>] ? __device_attach+0x31/0x31
[    2.609528]  [<c0419912>] bus_add_driver+0xd4/0x18b
[    2.609661]  [<c041a609>] driver_register+0x74/0xa9
[    2.609795]  [<c030ce6f>] __pci_register_driver+0x4a/0x4d
[    2.609932]  [<c08231bb>] ? ftrace_define_fields_drm_vblank_event_delivered+0x65/0x65
[    2.610168]  [<c03a05c5>] drm_pci_init+0x56/0xc9
[    2.610302]  [<c08231bb>] ? ftrace_define_fields_drm_vblank_event_delivered+0x65/0x65
[    2.610538]  [<c082321d>] i915_init+0x62/0x64
[    2.610670]  [<c01003e7>] do_one_initcall+0x7c/0x105
[    2.610805]  [<c07f9400>] ? do_early_param+0x3d/0x73
[    2.610940]  [<c0140cc6>] ? parse_args+0x16c/0x203
[    2.611074]  [<c07f9a4f>] kernel_init_freeable+0xdb/0x158
[    2.611210]  [<c054f9fe>] kernel_init+0xd/0xdf
[    2.611344]  [<c0560937>] ret_from_kernel_thread+0x1b/0x28
[    2.611479]  [<c054f9f1>] ? rest_init+0xa5/0xa5
[    2.611666] ---[ end trace cd346fb3f5b5c52d ]---
[    2.613964] [drm:intel_sdvo_init], SDVO output failed to setup on SDVOC
[    2.614565] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus dpb. force bit now 1
[    2.614731] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state readout: enabled
[    2.614737] [drm:intel_modeset_readout_hw_state], [CRTC:4] hw state readout: disabled
[    2.614743] [drm:intel_modeset_readout_hw_state], [ENCODER:6:DAC-6] hw state readout: disabled, pipe A
[    2.614750] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.620297] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.620304] [drm:intel_sdvo_debug_write], SDVOB: W: 12                         (SDVO_CMD_GET_INPUT_TIMINGS_PART1)
[    2.632814] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 10 0B D0 B4 20 90 31 10
[    2.632820] [drm:intel_sdvo_debug_write], SDVOB: W: 13                         (SDVO_CMD_GET_INPUT_TIMINGS_PART2)
[    2.645339] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 2D 6C C2 00 1C 00 00 00
[    2.645346] [drm:intel_sdvo_debug_write], SDVOB: W: 20                         (SDVO_CMD_GET_CLOCK_RATE_MULT)
[    2.649684] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 08
[    2.649688] [drm:intel_modeset_readout_hw_state], [ENCODER:7:TMDS-7] hw state readout: enabled, pipe A
[    2.649694] [drm:intel_modeset_readout_hw_state], [ENCODER:10:TV-10] hw state readout: disabled, pipe A
[    2.649700] [drm:intel_modeset_readout_hw_state], [CONNECTOR:5:VGA-1] hw state readout: disabled
[    2.649706] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.655201] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.655205] [drm:intel_modeset_readout_hw_state], [CONNECTOR:8:DVI-D-1] hw state readout: enabled
[    2.655210] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:SVIDEO-1] hw state readout: disabled
[    2.655213] [drm:intel_modeset_setup_hw_state], [CRTC:3] found active mode: 
[    2.655219] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 28320 720 765 873 900 400 412 414 449 0x0 0x6
[    2.655227] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] config for pipe A
[    2.655230] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    2.655234] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    2.655239] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.655243] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.655247] [drm:intel_dump_pipe_config], requested mode:
[    2.655252] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 720 0 0 0 400 0 0 0 0x0 0x0
[    2.655255] [drm:intel_dump_pipe_config], adjusted mode:
[    2.655260] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x6
[    2.655266] [drm:intel_dump_crtc_timings], crtc timings: 28320 720 765 873 900 400 412 414 449, type: 0x0 flags: 0x6
[    2.655269] [drm:intel_dump_pipe_config], port clock: 113280
[    2.655273] [drm:intel_dump_pipe_config], pipe src size: 720x400
[    2.655277] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    2.655281] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    2.655284] [drm:intel_dump_pipe_config], ips: 0
[    2.655288] [drm:intel_dump_pipe_config], double wide: 0
[    2.655293] [drm:intel_dump_pipe_config], [CRTC:4][setup_hw_state] config for pipe B
[    2.655297] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    2.655300] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    2.655305] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.655309] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.655313] [drm:intel_dump_pipe_config], requested mode:
[    2.655318] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    2.655321] [drm:intel_dump_pipe_config], adjusted mode:
[    2.655326] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    2.655331] [drm:intel_dump_crtc_timings], crtc timings: 0 0 0 0 0 0 0 0 0, type: 0x0 flags: 0x0
[    2.655335] [drm:intel_dump_pipe_config], port clock: 0
[    2.655338] [drm:intel_dump_pipe_config], pipe src size: 0x0
[    2.655342] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    2.655346] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    2.655349] [drm:intel_dump_pipe_config], ips: 0
[    2.655353] [drm:intel_dump_pipe_config], double wide: 0
[    2.655361] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.660867] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.660871] [drm:intel_connector_check_state], [CONNECTOR:8:DVI-D-1]
[    2.660877] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.666381] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.666386] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    2.666392] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    2.666398] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.671900] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.671904] [drm:check_encoder_state], [ENCODER:10:TV-10]
[    2.671909] [drm:check_crtc_state], [CRTC:3]
[    2.671925] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.677425] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.677431] [drm:intel_sdvo_debug_write], SDVOB: W: 12                         (SDVO_CMD_GET_INPUT_TIMINGS_PART1)
[    2.689935] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 10 0B D0 B4 20 90 31 10
[    2.689941] [drm:intel_sdvo_debug_write], SDVOB: W: 13                         (SDVO_CMD_GET_INPUT_TIMINGS_PART2)
[    2.702442] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 2D 6C C2 00 1C 00 00 00
[    2.702449] [drm:intel_sdvo_debug_write], SDVOB: W: 20                         (SDVO_CMD_GET_CLOCK_RATE_MULT)
[    2.706782] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 08
[    2.706787] [drm:check_crtc_state], [CRTC:4]
[    2.706799] [drm:i9xx_get_plane_config], pipe/plane 0/1 with fb: size=720x400@32, offset=0, pitch 3200, size 0x139000
[    2.706804] [drm:i915_gem_object_create_stolen_for_preallocated], creating preallocated stolen object: stolen_offset=0, gtt_offset=0, size=139000
[    2.706879] [drm:i915_pages_create_for_stolen], offset=0x0, size=1282048
[    2.706966] [drm:intel_alloc_plane_obj], plane fb obj f6373e40
[    2.706972] [drm:i915_gem_setup_global_gtt], reserving preallocated space: 0 + 139000
[    2.706976] [drm:i915_gem_setup_global_gtt], clearing unused GTT space: [139000, ffff000]
[    2.709450] [drm:i915_gem_object_create_stolen], creating stolen object: size=20000
[    2.709471] [drm:i915_pages_create_for_stolen], offset=0x139000, size=131072
[    2.709884] [drm] initialized overlay support
[    2.710017] [drm:intel_fbdev_init_bios], found possible fb from plane A
[    2.710020] [drm:intel_fbdev_init_bios], pipe B not active or no fb, skipping
[    2.710024] [drm:intel_fbdev_init_bios], checking plane A for BIOS fb
[    2.710028] [drm:intel_fbdev_init_bios], pipe A area: 288000
[    2.710031] [drm:intel_fbdev_init_bios], total size 1152000 (bpp 4)
[    2.710035] [drm:intel_fbdev_init_bios], fb big enough for plane A (1282048 >= 1152000)
[    2.710039] [drm:intel_fbdev_init_bios], pipe B not active, skipping
[    2.710044] [drm:intel_fbdev_init_bios], using BIOS fb for initial console
[    2.710054] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1]
[    2.710059] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=1
[    2.712024] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    2.712028] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.712032] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    2.712036] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    2.712368] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.712372] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    2.712375] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.712380] [drm:intel_get_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[    2.712402] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    2.712499] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[    2.712505] [drm:connected_sink_compute_bpp], [CONNECTOR:5:VGA-1] checking for sink bpp constrains
[    2.712533] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    2.712537] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[    2.712541] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    2.712544] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    2.712549] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.712553] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.712557] [drm:intel_dump_pipe_config], requested mode:
[    2.712562] [drm:drm_mode_debug_printmodeline], Modeline 0:"640x480" 0 31500 640 664 704 832 480 489 491 520 0x10 0xa
[    2.712566] [drm:intel_dump_pipe_config], adjusted mode:
[    2.712571] [drm:drm_mode_debug_printmodeline], Modeline 0:"640x480" 0 31500 640 664 704 832 480 489 491 520 0x10 0xa
[    2.712577] [drm:intel_dump_crtc_timings], crtc timings: 31500 640 664 704 832 480 489 491 520, type: 0x10 flags: 0xa
[    2.712580] [drm:intel_dump_pipe_config], port clock: 31500
[    2.712584] [drm:intel_dump_pipe_config], pipe src size: 640x480
[    2.712588] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    2.712592] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    2.712595] [drm:intel_dump_pipe_config], ips: 0
[    2.712599] [drm:intel_dump_pipe_config], double wide: 0
[    2.714954] [drm:i9xx_update_plane], Writing base 00160000 00000000 0 0 2560
[    2.714960] [drm:intel_update_fbc], disabled per chip default
[    2.714967] [drm:intel_crtc_mode_set], [ENCODER:6:DAC-6] set [MODE:0:640x480]
[    2.715720] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    2.715725] [drm:intel_calculate_wm], FIFO entries required for mode: 10
[    2.715728] [drm:intel_calculate_wm], FIFO watermark level: 16
[    2.715733] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    2.715736] [drm:intel_calculate_wm], FIFO entries required for mode: 9
[    2.715739] [drm:intel_calculate_wm], FIFO watermark level: 20
[    2.715743] [drm:i9xx_update_wm], FIFO watermarks - A: 16, B: 20
[    2.715748] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 16, B: 20, C: 2, SR 1
[    2.715752] [drm:i9xx_update_wm], memory self refresh disabled
[    2.736020] [drm:intel_update_fbc], more than one pipe active, disabling compression
[    2.736030] [drm:intel_connector_check_state], [CONNECTOR:5:VGA-1]
[    2.736037] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.741571] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.741575] [drm:intel_connector_check_state], [CONNECTOR:8:DVI-D-1]
[    2.741582] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.747093] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.747098] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    2.747104] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    2.747110] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.752626] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.752630] [drm:check_encoder_state], [ENCODER:10:TV-10]
[    2.752635] [drm:check_crtc_state], [CRTC:3]
[    2.752652] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.758158] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.758164] [drm:intel_sdvo_debug_write], SDVOB: W: 12                         (SDVO_CMD_GET_INPUT_TIMINGS_PART1)
[    2.770686] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 10 0B D0 B4 20 90 31 10
[    2.770692] [drm:intel_sdvo_debug_write], SDVOB: W: 13                         (SDVO_CMD_GET_INPUT_TIMINGS_PART2)
[    2.783214] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 2D 6C C2 00 1C 00 00 00
[    2.783220] [drm:intel_sdvo_debug_write], SDVOB: W: 20                         (SDVO_CMD_GET_CLOCK_RATE_MULT)
[    2.787557] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 08
[    2.787561] [drm:check_crtc_state], [CRTC:4]
[    2.804021] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    2.804025] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.804029] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    2.804033] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    2.804374] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    2.804378] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    2.804382] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.804385] [drm:intel_crt_load_detect], starting load-detect on CRT
[    2.812019] [drm:intel_release_load_detect_pipe], [CONNECTOR:5:VGA-1], [ENCODER:6:DAC-6]
[    2.812024] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[    2.844985] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    2.844990] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    2.844993] [drm:intel_calculate_wm], FIFO entries required for mode: 9
[    2.844997] [drm:intel_calculate_wm], FIFO watermark level: 20
[    2.845000] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 20
[    2.845004] [drm:i9xx_update_wm], self-refresh entries: 45
[    2.845009] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 20, C: 2, SR 50
[    2.845014] [drm:i9xx_update_wm], memory self refresh enabled
[    2.845017] [drm:intel_update_fbc], disabled per chip default
[    2.845031] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.850537] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.850541] [drm:intel_connector_check_state], [CONNECTOR:8:DVI-D-1]
[    2.850548] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.856056] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.856061] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    2.856066] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    2.856073] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.861589] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.861593] [drm:check_encoder_state], [ENCODER:10:TV-10]
[    2.861597] [drm:check_crtc_state], [CRTC:3]
[    2.861613] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    2.867118] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.867124] [drm:intel_sdvo_debug_write], SDVOB: W: 12                         (SDVO_CMD_GET_INPUT_TIMINGS_PART1)
[    2.879645] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 10 0B D0 B4 20 90 31 10
[    2.879650] [drm:intel_sdvo_debug_write], SDVOB: W: 13                         (SDVO_CMD_GET_INPUT_TIMINGS_PART2)
[    2.892173] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 2D 6C C2 00 1C 00 00 00
[    2.892179] [drm:intel_sdvo_debug_write], SDVOB: W: 20                         (SDVO_CMD_GET_CLOCK_RATE_MULT)
[    2.896517] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 08
[    2.896521] [drm:check_crtc_state], [CRTC:4]
[    2.896657] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:5:VGA-1] disconnected
[    2.896662] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1]
[    2.896666] [drm:intel_sdvo_detect], [CONNECTOR:8:DVI-D-1]
[    2.896672] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[    2.902454] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    2.902458] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[    2.902465] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    2.906363] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    2.943050] [drm:intel_sdvo_get_ddc_modes], [CONNECTOR:8:DVI-D-1]
[    2.943057] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    2.946942] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[    2.983605] [drm:intel_sdvo_connector_matches_edid], connector_is_digital? 1, monitor_is_digital? 1
[    2.983626] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:8:DVI-D-1] probed modes :
[    2.983633] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    2.983639] [drm:drm_mode_debug_printmodeline], Modeline 30:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    2.983645] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    2.983651] [drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    2.983657] [drm:drm_mode_debug_printmodeline], Modeline 29:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    2.983661] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:SVIDEO-1]
[    2.983665] [drm:intel_tv_detect], [CONNECTOR:9:SVIDEO-1] force=1
[    2.983670] [drm:intel_get_load_detect_pipe], [CONNECTOR:9:SVIDEO-1], [ENCODER:10:TV-10]
[    2.983674] [drm:intel_get_load_detect_pipe], creating tmp fb for load-detection
[    2.983693] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 2, prepare: 2, disable: 0
[    2.983699] [drm:connected_sink_compute_bpp], [CONNECTOR:9:SVIDEO-1] checking for sink bpp constrains
[    2.983703] [drm:intel_tv_compute_config], forcing bpc to 8 for TV
[    2.983709] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    2.983713] [drm:intel_dump_pipe_config], [CRTC:4][modeset] config for pipe B
[    2.983716] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    2.983720] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    2.983724] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.983729] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    2.983732] [drm:intel_dump_pipe_config], requested mode:
[    2.983738] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    2.983741] [drm:intel_dump_pipe_config], adjusted mode:
[    2.983747] [drm:drm_mode_debug_printmodeline], Modeline 0:"NTSC 480i" 0 107520 1280 1368 1496 1712 1024 1027 1034 1104 0x40 0x0
[    2.983752] [drm:intel_dump_crtc_timings], crtc timings: 108000 1280 1368 1496 1712 1024 1027 1034 1104, type: 0x40 flags: 0x0
[    2.983756] [drm:intel_dump_pipe_config], port clock: 108000
[    2.983760] [drm:intel_dump_pipe_config], pipe src size: 1280x1024
[    2.983764] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    2.983768] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    2.983771] [drm:intel_dump_pipe_config], ips: 0
[    2.983774] [drm:intel_dump_pipe_config], double wide: 0
[    2.993290] [drm:i9xx_update_plane], Writing base 00160000 00000000 0 0 5120
[    2.993305] [drm:intel_crtc_mode_set], [ENCODER:10:TV-10] set [MODE:0:NTSC 480i]
[    2.999122] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    2.999126] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    2.999130] [drm:intel_calculate_wm], FIFO watermark level: -8
[    2.999134] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    2.999138] [drm:intel_calculate_wm], FIFO entries required for mode: 9
[    2.999141] [drm:intel_calculate_wm], FIFO watermark level: 20
[    2.999145] [drm:i9xx_update_wm], FIFO watermarks - A: 1, B: 20
[    2.999150] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 1, B: 20, C: 2, SR 1
[    2.999154] [drm:i9xx_update_wm], memory self refresh disabled
[    3.020020] [drm:intel_update_fbc], more than one pipe active, disabling compression
[    3.020035] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.025549] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.025554] [drm:intel_connector_check_state], [CONNECTOR:8:DVI-D-1]
[    3.025560] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.031068] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.031073] [drm:intel_connector_check_state], [CONNECTOR:9:SVIDEO-1]
[    3.031078] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.031084] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.031090] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.036595] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.036599] [drm:check_encoder_state], [ENCODER:10:TV-10]
[    3.036603] [drm:check_crtc_state], [CRTC:3]
[    3.036621] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.042131] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.042137] [drm:intel_sdvo_debug_write], SDVOB: W: 12                         (SDVO_CMD_GET_INPUT_TIMINGS_PART1)
[    3.054659] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 10 0B D0 B4 20 90 31 10
[    3.054665] [drm:intel_sdvo_debug_write], SDVOB: W: 13                         (SDVO_CMD_GET_INPUT_TIMINGS_PART2)
[    3.067186] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 2D 6C C2 00 1C 00 00 00
[    3.067192] [drm:intel_sdvo_debug_write], SDVOB: W: 20                         (SDVO_CMD_GET_CLOCK_RATE_MULT)
[    3.071529] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 08
[    3.071535] [drm:check_crtc_state], [CRTC:4]
[    3.100115] tsc: Refined TSC clocksource calibration: 1862.713 MHz
[    3.108021] [drm:intel_tv_detect_type], TV detected: 400c0c07, 7f0000aa
[    3.108025] [drm:intel_tv_detect_type], Unrecognised TV connection
[    3.140020] [drm:intel_release_load_detect_pipe], [CONNECTOR:9:SVIDEO-1], [ENCODER:10:TV-10]
[    3.140026] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 0, prepare: 0, disable: 2
[    3.184984] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.184989] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.184993] [drm:intel_calculate_wm], FIFO entries required for mode: 9
[    3.184996] [drm:intel_calculate_wm], FIFO watermark level: 20
[    3.185000] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 20
[    3.185004] [drm:i9xx_update_wm], self-refresh entries: 45
[    3.185009] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 20, C: 2, SR 50
[    3.185013] [drm:i9xx_update_wm], memory self refresh enabled
[    3.185017] [drm:intel_update_fbc], disabled per chip default
[    3.185031] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.190539] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.190544] [drm:intel_connector_check_state], [CONNECTOR:8:DVI-D-1]
[    3.190550] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.196056] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.196061] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.196066] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.196072] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.201576] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.201580] [drm:check_encoder_state], [ENCODER:10:TV-10]
[    3.201584] [drm:check_crtc_state], [CRTC:3]
[    3.201600] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.207107] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.207113] [drm:intel_sdvo_debug_write], SDVOB: W: 12                         (SDVO_CMD_GET_INPUT_TIMINGS_PART1)
[    3.219632] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 10 0B D0 B4 20 90 31 10
[    3.219638] [drm:intel_sdvo_debug_write], SDVOB: W: 13                         (SDVO_CMD_GET_INPUT_TIMINGS_PART2)
[    3.232158] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 2D 6C C2 00 1C 00 00 00
[    3.232165] [drm:intel_sdvo_debug_write], SDVOB: W: 20                         (SDVO_CMD_GET_CLOCK_RATE_MULT)
[    3.236510] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 08
[    3.236515] [drm:check_crtc_state], [CRTC:4]
[    3.236626] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:SVIDEO-1] disconnected
[    3.236631] [drm:drm_setup_crtcs], 
[    3.236635] [drm:drm_enable_connectors], connector 5 enabled? no
[    3.236639] [drm:drm_enable_connectors], connector 8 enabled? yes
[    3.236643] [drm:drm_enable_connectors], connector 9 enabled? no
[    3.236647] [drm:intel_fb_initial_config], connector 5 not enabled, skipping
[    3.236651] [drm:intel_fb_initial_config], looking for cmdline mode on connector 8
[    3.236655] [drm:intel_fb_initial_config], looking for preferred mode on connector 8
[    3.236659] [drm:intel_fb_initial_config], connector DVI-D-1 on crtc 3: 1280x1024
[    3.236663] [drm:intel_fb_initial_config], connector 9 not enabled, skipping
[    3.236667] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
[    3.236676] [drm:intelfb_create], re-using BIOS fb
[    3.236892] [drm:intelfb_create], allocated 720x400 fb: 0x00000000, bo f6373e40
[    3.237675] fbcon: inteldrmfb (fb0) is primary device
[    3.241496] [drm:intel_crtc_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    3.241501] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    3.241506] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 28320 720 765 873 900 400 412 414 449 0x0 0x6
[    3.241510] [drm:drm_mode_debug_printmodeline], Modeline 31:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    3.241512] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=1, fb_changed=0
[    3.241515] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.241519] [drm:intel_modeset_affected_pipes], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    3.241523] [drm:connected_sink_compute_bpp], [CONNECTOR:8:DVI-D-1] checking for sink bpp constrains
[    3.241526] [drm:intel_sdvo_compute_config], forcing bpc to 8 for SDVO
[    3.241540] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: 24, dithering: 0
[    3.241542] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for pipe A
[    3.241544] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    3.241546] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    3.241549] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.241551] [drm:intel_dump_pipe_config], dp: 0, gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    3.241553] [drm:intel_dump_pipe_config], requested mode:
[    3.241557] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    3.241559] [drm:intel_dump_pipe_config], adjusted mode:
[    3.241562] [drm:drm_mode_debug_printmodeline], Modeline 0:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[    3.241566] [drm:intel_dump_crtc_timings], crtc timings: 108000 1280 1328 1440 1688 1024 1025 1028 1066, type: 0x48 flags: 0x5
[    3.241568] [drm:intel_dump_pipe_config], port clock: 108000
[    3.241570] [drm:intel_dump_pipe_config], pipe src size: 1280x1024
[    3.241572] [drm:intel_dump_pipe_config], gmch pfit: control: 0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[    3.241575] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, size: 0x00000000, disabled
[    3.241576] [drm:intel_dump_pipe_config], ips: 0
[    3.241578] [drm:intel_dump_pipe_config], double wide: 0
[    3.241583] [drm:intel_sdvo_debug_write], SDVOB: W: 05 00 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.246688] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.260987] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.260990] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.260992] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 29
[    3.260995] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 29, C: 2, SR 1
[    3.260998] [drm:i9xx_update_wm], memory self refresh disabled
[    3.260999] [drm:intel_update_fbc], no output, disabling
[    3.261240] [drm:i9xx_update_plane], Writing base 00000000 00000000 0 0 3200
[    3.261248] [drm:intel_crtc_mode_set], [ENCODER:7:TMDS-7] set [MODE:0:1280x1024]
[    3.261253] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
[    3.268071] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.268075] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
[    3.273147] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.273153] [drm:intel_sdvo_debug_write], SDVOB: W: 16 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
[    3.283457] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.283462] [drm:intel_sdvo_debug_write], SDVOB: W: 17 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART2)
[    3.293770] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.293775] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
[    3.297977] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.297982] [drm:intel_sdvo_debug_write], SDVOB: W: 9F 00                      (SDVO_CMD_SET_ENCODE)
[    3.302181] [drm:intel_sdvo_read_response], SDVOB: R: ... failed
[    3.302187] [drm:intel_sdvo_debug_write], SDVOB: W: 14 30 2A 00 98 51 00 2A 40 (SDVO_CMD_SET_INPUT_TIMINGS_PART1)
[    3.312503] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.312508] [drm:intel_sdvo_debug_write], SDVOB: W: 15 30 70 13 00 1E 00 00 00 (SDVO_CMD_SET_INPUT_TIMINGS_PART2)
[    3.322809] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.322814] [drm:intel_sdvo_debug_write], SDVOB: W: 21 01                      (SDVO_CMD_SET_CLOCK_RATE_MULT)
[    3.327010] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.327784] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) A: 28
[    3.327787] [drm:i9xx_get_fifo_size], FIFO size - (0x00001d9c) B: 31
[    3.327789] [drm:intel_calculate_wm], FIFO entries required for mode: 34
[    3.327791] [drm:intel_calculate_wm], FIFO watermark level: -5
[    3.327793] [drm:i9xx_update_wm], FIFO watermarks - A: 26, B: 1
[    3.327795] [drm:i9xx_update_wm], self-refresh entries: 80
[    3.327798] [drm:i9xx_update_wm], Setting FIFO watermarks - A: 26, B: 1, C: 2, SR 15
[    3.327802] [drm:i9xx_update_wm], memory self refresh enabled
[    3.348019] [drm:intel_update_fbc], disabled per chip default
[    3.380022] [drm:intel_sdvo_debug_write], SDVOB: W: 03                         (SDVO_CMD_GET_TRAINED_INPUTS)
[    3.384583] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01
[    3.384587] [drm:intel_sdvo_debug_write], SDVOB: W: 05 01 00                   (SDVO_CMD_SET_ACTIVE_OUTPUTS)
[    3.389658] [drm:intel_sdvo_read_response], SDVOB: R: (Success)
[    3.389666] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.395449] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.395451] [drm:intel_connector_check_state], [CONNECTOR:8:DVI-D-1]
[    3.395456] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.401241] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.401245] [drm:check_encoder_state], [ENCODER:6:DAC-6]
[    3.401249] [drm:check_encoder_state], [ENCODER:7:TMDS-7]
[    3.401254] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.407033] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.407036] [drm:check_encoder_state], [ENCODER:10:TV-10]
[    3.407038] [drm:check_crtc_state], [CRTC:3]
[    3.407056] [drm:intel_sdvo_debug_write], SDVOB: W: 04                         (SDVO_CMD_GET_ACTIVE_OUTPUTS)
[    3.412852] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[    3.412857] [drm:intel_sdvo_debug_write], SDVOB: W: 12                         (SDVO_CMD_GET_INPUT_TIMINGS_PART1)
[    3.426023] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 30 2A 00 98 51 00 2A 40
[    3.426028] [drm:intel_sdvo_debug_write], SDVOB: W: 13                         (SDVO_CMD_GET_INPUT_TIMINGS_PART2)
[    3.439507] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 30 70 13 00 1E 00 00 00
[    3.439512] [drm:intel_sdvo_debug_write], SDVOB: W: 20                         (SDVO_CMD_GET_CLOCK_RATE_MULT)
[    3.444085] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01
[    3.444087] [drm:check_crtc_state], [CRTC:4]
[    3.444093] [drm:intel_crtc_set_config], [CRTC:4] [NOFB]
[    3.444098] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:4], mode_changed=0, fb_changed=0
[    3.444101] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.444129] [drm:intel_crtc_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    3.444134] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.444136] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.446774] [drm:intel_crtc_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    3.446779] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.446782] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.449753] Console: switching to colour frame buffer device 90x25
[    3.449760] [drm:intel_crtc_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[    3.449765] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[    3.449768] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[    3.455199] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.456384] i915 0000:00:02.0: registered panic notifier
[    3.457613] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.459287] parport_pc 00:07: reported by Plug and Play ACPI
[    3.460641] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    3.560558] lp0: using parport0 (interrupt-driven).
[    3.564759] loop: module loaded
[    3.566136] ACPI Warning: 0x00004028-0x0000402f SystemIO conflicts with Region \PM2S 1 (20131115/utaddress-251)
[    3.568770] ACPI: This conflict may cause random problems and system instability
[    3.570118] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.572842] ACPI Warning: 0x000040b0-0x000040bf SystemIO conflicts with Region \GPO2 1 (20131115/utaddress-251)
[    3.575761] ACPI: This conflict may cause random problems and system instability
[    3.577297] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.580449] ACPI Warning: 0x00004080-0x000040af SystemIO conflicts with Region \GPO_ 1 (20131115/utaddress-251)
[    3.583752] ACPI: This conflict may cause random problems and system instability
[    3.585482] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.589035] Uniform Multi-Platform E-IDE driver
[    3.590849] ide-gd driver 1.18
[    3.592566] ide-cd driver 5.00
[    3.594437] sata_sil24 0000:04:00.0: version 1.1
[    3.595856] scsi0 : sata_sil24
[    3.597881] scsi1 : sata_sil24
[    3.599576] ata1: SATA max UDMA/100 host m128@0xd5184000 port 0xd5180000 irq 19
[    3.601314] ata2: SATA max UDMA/100 host m128@0xd5184000 port 0xd5182000 irq 19
[    3.603328] ata_piix 0000:00:1f.2: version 2.13
[    3.603623] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    3.606198] scsi2 : ata_piix
[    3.607871] scsi3 : ata_piix
[    3.609448] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    3.610913] ata4: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    3.612450] sky2: driver version 1.30
[    3.614005] sky2 0000:02:00.0: Yukon-2 EC chip revision 1
[    3.615426] sky2 0000:02:00.0: irq 44 for MSI/MSI-X
[    3.615990] sky2 0000:02:00.0 eth0: addr 00:01:80:62:25:4b
[    3.617863] sky2 0000:03:00.0: Yukon-2 EC chip revision 1
[    3.619183] sky2 0000:03:00.0: irq 45 for MSI/MSI-X
[    3.619513] sky2 0000:03:00.0 eth1: addr 00:01:80:62:25:4c
[    3.620830] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.622055] ehci-pci: EHCI PCI platform driver
[    3.623683] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    3.625075] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.630227] ehci-pci 0000:00:1d.7: cache line size of 32 is not supported
[    3.630292] ehci-pci 0000:00:1d.7: irq 23, io mem 0xd5444000
[    3.640021] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.641536] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.642578] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.643620] usb usb1: Product: EHCI Host Controller
[    3.644663] usb usb1: Manufacturer: Linux 3.13.0-main-01064-gd978ef1 ehci_hcd
[    3.645769] usb usb1: SerialNumber: 0000:00:1d.7
[    3.647888] hub 1-0:1.0: USB hub found
[    3.649147] hub 1-0:1.0: 8 ports detected
[    3.651481] uhci_hcd: USB Universal Host Controller Interface driver
[    3.653001] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.654178] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.655367] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e000
[    3.656724] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    3.657917] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.659136] usb usb2: Product: UHCI Host Controller
[    3.660335] usb usb2: Manufacturer: Linux 3.13.0-main-01064-gd978ef1 uhci_hcd
[    3.661564] usb usb2: SerialNumber: 0000:00:1d.0
[    3.663098] hub 2-0:1.0: USB hub found
[    3.664378] hub 2-0:1.0: 2 ports detected
[    3.666229] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.667440] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.668729] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e100
[    3.670060] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.671288] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.672540] usb usb3: Product: UHCI Host Controller
[    3.673782] usb usb3: Manufacturer: Linux 3.13.0-main-01064-gd978ef1 uhci_hcd
[    3.675044] usb usb3: SerialNumber: 0000:00:1d.1
[    3.676608] hub 3-0:1.0: USB hub found
[    3.677842] hub 3-0:1.0: 2 ports detected
[    3.679658] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.680864] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.682124] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e200
[    3.683491] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.684736] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.685978] usb usb4: Product: UHCI Host Controller
[    3.687201] usb usb4: Manufacturer: Linux 3.13.0-main-01064-gd978ef1 uhci_hcd
[    3.688460] usb usb4: SerialNumber: 0000:00:1d.2
[    3.689990] hub 4-0:1.0: USB hub found
[    3.691218] hub 4-0:1.0: 2 ports detected
[    3.693001] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.694192] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    3.695424] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e300
[    3.696739] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.697965] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.699207] usb usb5: Product: UHCI Host Controller
[    3.700441] usb usb5: Manufacturer: Linux 3.13.0-main-01064-gd978ef1 uhci_hcd
[    3.701705] usb usb5: SerialNumber: 0000:00:1d.3
[    3.703233] hub 5-0:1.0: USB hub found
[    3.704490] hub 5-0:1.0: 2 ports detected
[    3.706034] usbcore: registered new interface driver usblp
[    3.707276] usbcore: registered new interface driver usb-storage
[    3.708533] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.709709] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    3.713047] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.714994] mousedev: PS/2 mouse device common for all mice
[    3.717248] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    3.718730] rtc_cmos 00:02: RTC can wake from S4
[    3.720549] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.721854] rtc_cmos 00:02: alarms up to one month, 242 bytes nvram, hpet irqs
[    3.723487] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    3.724891] w83627hf: w83627hf: Found W83627THF chip at 0x290
[    3.726201] ACPI Warning: 0x00000295-0x00000296 SystemIO conflicts with Region \SEN1 1 (20131115/utaddress-251)
[    3.729640] ACPI: This conflict may cause random problems and system instability
[    3.731040] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.734295] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    3.735750] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x4060)
[    3.737604] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.739060] device-mapper: uevent: version 1.0.3
[    3.740715] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.743911] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.747832] hidraw: raw HID events driver (C) Jiri Kosina
[    3.750358] usbcore: registered new interface driver usbhid
[    3.751951] usbhid: USB HID core driver
[    3.753692] TCP: cubic registered
[    3.755210] Initializing XFRM netlink socket
[    3.757156] Using IPI Shortcut mode
[    3.758914] registered taskstats version 1
[    3.760845] AppArmor: AppArmor sha1 policy hashing enabled
[    3.763285] rtc_cmos 00:02: setting system clock to 2014-04-22 13:43:01 UTC (1398174181)
[    3.767393] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    3.769169] PM: Checking hibernation image partition /dev/sda3
[    3.776285] tsc: Marking TSC unstable due to cpufreq changes
[    3.780763] ata4.00: ATAPI: AOpen   DVRW2412PRO, 1.64, max UDMA/33
[    3.800255] ata4.00: configured for UDMA/33
[    3.804440] ata3.00: ATA-8: Hitachi HUA722010CLA330, JP4OA3EA, max UDMA/133
[    3.807721] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.811214] ata3.01: ATA-7: HDT722525DLA380, V44OA91A, max UDMA/133
[    3.814472] ata3.01: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.832368] ata3.00: configured for UDMA/133
[    3.849099] ata3.01: configured for UDMA/133
[    3.960127] usb 1-2: new high-speed USB device number 2 using ehci-pci
[    4.103316] usb 1-2: New USB device found, idVendor=04b8, idProduct=011b
[    4.106371] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.109373] usb 1-2: Product: EPSON Scanner
[    4.111499] usb 1-2: Manufacturer: EPSON
[    4.224106] usb 1-3: new high-speed USB device number 3 using ehci-pci
[    4.356693] usb 1-3: New USB device found, idVendor=1a40, idProduct=0101
[    4.359538] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    4.362453] usb 1-3: Product: USB 2.0 Hub
[    4.366019] hub 1-3:1.0: USB hub found
[    4.369046] hub 1-3:1.0: 4 ports detected
[    4.868063] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[    5.055696] usb 5-2: New USB device found, idVendor=046d, idProduct=c52b
[    5.058754] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.061636] usb 5-2: Product: USB Receiver
[    5.064371] usb 5-2: Manufacturer: Logitech
[    5.077307] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2:1.0/input/input4
[    5.082613] hid-generic 0003:046D:C52B.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.3-2/input0
[    5.092226] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2:1.1/input/input5
[    5.096306] hid-generic 0003:046D:C52B.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.3-2/input1
[    5.106935] hid-generic 0003:046D:C52B.0003: hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.3-2/input2
[    5.308198] usb 1-3.4: new full-speed USB device number 5 using ehci-pci
[    5.405819] usb 1-3.4: New USB device found, idVendor=03f0, idProduct=1d17
[    5.409341] usb 1-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    5.412910] usb 1-3.4: Product: hp LaserJet 1320 series
[    5.416462] usb 1-3.4: Manufacturer: Hewlett-Packard
[    5.417994] usb 1-3.4: SerialNumber: 00CNHW646GZH
[    5.421067] usblp 1-3.4:1.0: usblp0: USB Bidirectional printer dev 5 if 0 alt 1 proto 2 vid 0x03F0 pid 0x1D17
[    5.800070] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    5.805665] ata1.00: ATA-8: KINGSTON SKC100S3120G, 501ABBF0, max UDMA/133
[    5.809390] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    5.815601] ata1.00: configured for UDMA/100
[    5.834084] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SKC100S 501A PQ: 0 ANSI: 5
[    5.843662] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    5.848453] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.850657] sd 0:0:0:0: [sda] Write Protect is off
[    5.852791] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.852845] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.857891]  sda: sda1 sda2 sda3
[    5.860857] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.932067] ata2: SATA link down (SStatus 0 SControl 0)
[    7.948446] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HUA72201 JP4O PQ: 0 ANSI: 5
[    7.955565] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    7.959313] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    7.962840] sd 2:0:0:0: [sdb] Write Protect is off
[    7.966273] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.966355] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.969460] scsi 2:0:1:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0 ANSI: 5
[    7.972841] sd 2:0:1:0: [sdc] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    7.974488] sd 2:0:1:0: [sdc] Write Protect is off
[    7.975996] sd 2:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    7.976292] sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.979883] sd 2:0:1:0: Attached scsi generic sg2 type 0
[    7.982786]  sdb: sdb1 sdb2 sdb3 sdb4
[    7.984492] scsi 3:0:0:0: CD-ROM            AOPEN    DVRW2412PRO      1.64 PQ: 0 ANSI: 5
[    7.988948] sd 2:0:0:0: [sdb] Attached SCSI disk
[    7.991247] sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
[    7.992779] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.994996] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    7.995175] sr 3:0:0:0: Attached scsi generic sg3 type 5
[    8.058214]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 sdc9 >
[    8.064585] sd 2:0:1:0: [sdc] Attached SCSI disk
[    8.067998] PM: Hibernation image partition 8:3 present
[    8.068035] PM: Looking for hibernation image.
[    8.071701] PM: Image not found (code -22)
[    8.071711] PM: Hibernation image not present or could not be loaded.
[    8.072512] Freeing unused kernel memory: 500K (c07f9000 - c0876000)
[    8.074558] Write protecting the kernel text: 4488k
[    8.076665] Write protecting the kernel read-only data: 2256k
[    8.078335] NX-protecting the kernel data: 4728k
[    8.196506] systemd-udevd[90]: starting version 208
[    8.817893] random: nonblocking pool is initialized
[    9.587815] platform microcode: Direct firmware load failed with error -2
[    9.591670] platform microcode: Falling back to user helper
[   13.472325] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   13.476038] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   13.476045] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   13.476049] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   13.476054] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   13.476395] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   13.476399] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   13.476403] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   13.476478] [drm:intel_tv_detect], [CONNECTOR:9:SVIDEO-1] force=0
[   14.778136] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: discard,errors=remount-ro
[   14.826261] EXT4-fs (sda1): re-mounted. Opts: discard,errors=remount-ro
[   15.029583] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX -IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   15.118801] NET: Registered protocol family 10
[   15.124315] systemd[1]: Inserted module 'ipv6'
[   15.126644] systemd[1]: Set hostname to <golem>.
[   15.183033] LVM: Logical Volume autoactivation enabled.
[   15.185303] LVM: Activation generator successfully completed.
[   15.311540] systemd[1]: Starting Remote File Systems (Pre).
[   15.316221] systemd[1]: Reached target Remote File Systems (Pre).
[   15.317953] systemd[1]: Starting Remote File Systems.
[   15.321672] systemd[1]: Reached target Remote File Systems.
[   15.323419] systemd[1]: Starting Syslog Socket.
[   15.327122] systemd[1]: Listening on Syslog Socket.
[   15.328820] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[   15.331851] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   15.333287] systemd[1]: Starting Delayed Shutdown Socket.
[   15.336210] systemd[1]: Listening on Delayed Shutdown Socket.
[   15.337533] systemd[1]: Starting LVM2 metadata daemon socket.
[   15.340369] systemd[1]: Listening on LVM2 metadata daemon socket.
[   15.341702] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   15.343342] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   15.344736] systemd[1]: Starting Paths.
[   15.347608] systemd[1]: Reached target Paths.
[   15.349096] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[   15.354344] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   15.357277] systemd[1]: Starting Encrypted Volumes.
[   15.360435] systemd[1]: Reached target Encrypted Volumes.
[   15.361957] systemd[1]: Starting Journal Socket.
[   15.365335] systemd[1]: Listening on Journal Socket.
[   15.366865] systemd[1]: Mounting POSIX Message Queue File System...
[   15.375572] systemd[1]: Starting Load Kernel Modules...
[   15.382417] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[   15.402740] systemd[1]: Started Set Up Additional Binary Formats.
[   15.405020] systemd[1]: Starting Setup Virtual Console...
[   15.413643] systemd[1]: Starting Create dynamic rule for /dev/root link...
[   15.424935] systemd[1]: Starting LSB: Set default boot entry if called...
[   15.432288] systemd[1]: Starting Journal Service...
[   15.463472] systemd[1]: Started Journal Service.
[   15.498137] systemd-journald[202]: Vacuuming done, freed 0 bytes
[   15.569620] [drm:intel_crtc_set_config], [CRTC:3] [FB:24] #connectors=1 (x y) (0 0)
[   15.569627] [drm:intel_set_config_compute_mode_changes], computed changes for [CRTC:3], mode_changed=0, fb_changed=0
[   15.569631] [drm:intel_modeset_stage_output_state], [CONNECTOR:8:DVI-D-1] to [CRTC:3]
[   15.621781] EXT4-fs (sda1): re-mounted. Opts: discard,errors=remount-ro
[   15.909733] systemd-udevd[241]: starting version 208
[   16.379683] Linux video capture interface: v2.00
[   16.521180] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
[   16.542699] WARNING! power/level is deprecated; use power/control instead
[   16.733638] Adding 7119316k swap on /dev/sda3.  Priority:-1 extents:1 across:7119316k SS
[   17.074286] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   17.139216] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=3 (0x14/0x17/0x16/0x0/0x0) type:line
[   17.139224] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   17.139229] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=1 (0x19/0x0/0x0/0x0/0x0)
[   17.139233] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[   17.139237] ALSA sound/pci/hda/hda_auto_parser.c:405    dig-out=0x1e/0x0
[   17.139240] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[   17.139244] ALSA sound/pci/hda/hda_auto_parser.c:410      Rear Mic=0x18
[   17.139248] ALSA sound/pci/hda/hda_auto_parser.c:410      Front Mic=0x1b
[   17.139252] ALSA sound/pci/hda/hda_auto_parser.c:410      Line=0x1a
[   17.139257] ALSA sound/pci/hda/patch_realtek.c:491 realtek: No valid SSID, checking pincfg 0x411111f0 for NID 0x1d
[   17.139261] ALSA sound/pci/hda/patch_realtek.c:572 realtek: Enable default setup for auto mode as fallback
[   17.162783] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[   17.222696] input: HDA Intel Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   17.236290] input: HDA Intel Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   17.255391] input: HDA Intel Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   17.261287] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   17.274087] tveeprom 8-0050: Hauppauge model 69100, rev B4C3, serial# 7900937
[   17.292122] input: HDA Intel Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   17.303670] tveeprom 8-0050: MAC address is 00:0d:fe:78:8f:09
[   17.315320] tveeprom 8-0050: tuner model is Conexant CX24118A (idx 123, type 4)
[   17.321311] tveeprom 8-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
[   17.329373] input: HDA Intel Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   17.335654] tveeprom 8-0050: audio processor is None (idx 0)
[   17.347089] tveeprom 8-0050: decoder processor is CX880 (idx 20)
[   17.357408] tveeprom 8-0050: has no radio, has IR receiver, has no IR transmitter
[   17.367460] cx88[0]: hauppauge eeprom: model=69100
[   17.416091] Registered IR keymap rc-hauppauge
[   17.418847] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0/input13
[   17.431663] rc0: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/rc/rc0
[   17.449327] IR RC5(x) protocol handler initialized
[   17.454480] cx88[0]/2: cx2388x 8802 Driver Manager
[   17.457159] cx88[0]/2: found at 0000:05:05.2, rev: 5, irq: 17, latency: 32, mmio: 0xd2000000
[   17.461726] lirc_dev: IR Remote Control driver registered, major 250 
[   17.466631] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
[   17.472116] IR LIRC bridge handler initialized
[   17.482251] cx88[0]/0: found at 0000:05:05.0, rev: 5, irq: 17, latency: 32, mmio: 0xd0000000
[   17.487398] cx88[0]/0: registered device video0 [v4l2]
[   17.497932] cx88[0]/0: registered device vbi0
[   17.509908] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[   17.511501] cx88/2: registering cx8802 driver, type: dvb access: shared
[   17.514289] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[   17.521114] cx88[0]/2: cx2388x based DVB/ATSC card
[   17.524146] cx8802_alloc_frontends() allocating 1 frontend(s)
[   17.552650] DVB: registering new adapter (cx88[0])
[   17.554415] cx88-mpeg driver manager 0000:05:05.2: DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
[   17.767120] REISERFS (device sdb4): found reiserfs format "3.6" with standard journal
[   17.769248] REISERFS (device sdb4): using ordered data mode
[   17.770792] reiserfs: using flush barriers
[   17.782609] REISERFS (device sdb4): journal params: device sdb4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   17.787278] REISERFS (device sdb4): checking transaction log (sdb4)
[   17.892494] REISERFS (device sdb4): Using r5 hash to sort names
[   17.917237] usblp0: removed
[   18.063161] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: discard,errors=remount-ro
[   18.112358] systemd-journald[202]: Received request to flush runtime journal from PID 1
[   18.898204] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   19.019782] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   19.048657] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.004540] sky2 0000:02:00.0 eth0: enabling interface
[   21.004816] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.171576] NET: Registered protocol family 17
[   22.799130] sky2 0000:02:00.0 eth0: Link is up at 100 Mbps, full duplex, flow control both
[   22.799313] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   23.488060] [drm:intel_crt_detect], [CONNECTOR:5:VGA-1] force=0
[   23.492456] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   23.492470] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   23.492479] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   23.492489] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   23.492967] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   23.492978] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   23.492986] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   23.493001] [drm:intel_tv_detect], [CONNECTOR:9:SVIDEO-1] force=0

--------------050504000602040001040002--
