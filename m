Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3AUJra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:47:30 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:45780 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab3AUJr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:47:26 -0500
X-Greylist: delayed 1321 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 04:47:25 EST
Date: Mon, 21 Jan 2013 11:25:20 +0200 (EET)
From: Meelis Roos <mroos@ut.ee>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Jani Nikula <jani.nikula@intel.com>
Subject: New i915 warning from intel_dp_aux_ch
Message-ID: <alpine.SOC.1.00.1301211105280.6731@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing out 3.8.0-rc4-00071-g9a92841 on a PC where I have 
ironlake_crtc_disable warning 
(https://bugzilla.kernel.org/show_bug.cgi?id=52061), I saw a new warning 
today that was not there with 3.8.0-rc3-00074. The previous warning is 
also still there.

EDID is occasionally wrong on this PC, probably some timing issue in 
trying to read it out.

It is not 100% reproducible - happened 3 out of 6 reboots. It happens 
together with the EDID warning - probably related. But since it is not 
always there, I do now knwo exactly since when it might be present.

I managed to capture drm.debug=0xe output, full dmesg with debug is 
below is the main one.

[    0.270838] i915 0000:00:02.0: setting latency timer to 64
[    0.283426] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.283431] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.283470] [drm] Driver supports precise vblank timestamp query.
[    0.283532] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.366758] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status 0x0015003f
[    0.375148] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 142
[    0.375210] Raw EDID:
[    0.375239]          00 ff ff ff ff ff ff 00 22 f0 49 29 00 00 00 00
[    0.375275]          15 15 01 04 a5 33 1d 78 26 01 f5 a2 57 52 9f 27
[    0.375312]          0a 50 54 a1 08 00 81 c0 81 80 95 00 b3 00 d1 c0
[    0.375348]          01 01 01 01 01 01 02 3a 80 18 71 38 2d 40 58 2c
[    0.375385]          45 00 fe 1f 11 00 00 1e 00 00 00 fd 00 32 4c 18
[    0.375421]          5e 11 00 0a 0a 0a 0a 0a 20 20 20 20 20 00 00 00
[    0.375458]          fc 00 48 50 20 4c 41 32 33 30 36 0a 20 20 20 00
[    0.375495]          00 00 ff 00 43 4e 43 31 32 31 31 32 50 42 0a 20
[    0.389465] ------------[ cut here ]------------
[    0.389502] WARNING: at drivers/gpu/drm/i915/intel_dp.c:410 intel_dp_aux_ch+0x131/0x4e0()
[    0.389563] Hardware name: HP Compaq 8100 Elite SFF PC
[    0.389598] dp_aux_ch not started status 0x8025003f
[    0.389632] Modules linked in:
[    0.389671] Pid: 6, comm: kworker/u:0 Not tainted 3.8.0-rc4-00071-g9a92841 #80
[    0.389729] Call Trace:
[    0.389762]  [<ffffffff81036a29>] ? warn_slowpath_common+0x79/0xc0
[    0.389801]  [<ffffffff81036b25>] ? warn_slowpath_fmt+0x45/0x50
[    0.389838]  [<ffffffff812d7d61>] ? intel_dp_aux_ch+0x131/0x4e0
[    0.389877]  [<ffffffff812d82e2>] ? intel_dp_aux_native_write+0xa2/0xe0
[    0.389916]  [<ffffffff812d8021>] ? intel_dp_aux_ch+0x3f1/0x4e0
[    0.389953]  [<ffffffff812d8fbc>] ? intel_dp_set_link_train+0xbc/0x300
[    0.389993]  [<ffffffff812d82e2>] ? intel_dp_aux_native_write+0xa2/0xe0
[    0.390032]  [<ffffffff812da2f2>] ? intel_dp_start_link_train+0xf2/0x2f0
[    0.390072]  [<ffffffff812da831>] ? intel_dp_check_link_status+0x91/0x180
[    0.390113]  [<ffffffff812a8bce>] ? i915_hotplug_work_func+0x6e/0xa0
[    0.390153]  [<ffffffff8104d1e0>] ? process_one_work+0x120/0x430
[    0.390686]  [<ffffffff812a8b60>] ? i915_error_work_func+0x100/0x100
[    0.390725]  [<ffffffff8104ef7d>] ? worker_thread+0x15d/0x450
[    0.390762]  [<ffffffff8104ee20>] ? schedule_delayed_work+0x20/0x20
[    0.390801]  [<ffffffff81053ca3>] ? kthread+0xb3/0xc0
[    0.390837]  [<ffffffff81053bf0>] ? kthread_create_on_node+0x110/0x110
[    0.390878]  [<ffffffff8145a7ec>] ? ret_from_fork+0x7c/0xb0
[    0.390917]  [<ffffffff81053bf0>] ? kthread_create_on_node+0x110/0x110
[    0.390958] ---[ end trace 0f2d76d213a31275 ]---

[    0.000000] Linux version 3.8.0-rc4-00071-g9a92841 (mroos@prometheus) (gcc version 4.7.2 (Debian 4.7.2-5) ) #80 SMP Mon Jan 21 09:52:32 EET 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc4-00071-g9a92841 root=/dev/sda1 ro drm.debug=0xe
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e8000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000db7ac43f] usable
[    0.000000] BIOS-e820: [mem 0x00000000db7ac440-0x00000000db7ae49f] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000db7ae4a0-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f4000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed45000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000117ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP Compaq 8100 Elite SFF PC/304Ah, BIOS 786H1 v01.13 07/14/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x118000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-back
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   2 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb7ac max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f9bf0-0x000f9bff] mapped at [ffff8800000f9bf0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xdb7abfff]
[    0.000000]  [mem 0x00000000-0xdb5fffff] page 2M
[    0.000000]  [mem 0xdb600000-0xdb7abfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xdb7abfff @ [mem 0x1fffa000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x117ffffff]
[    0.000000]  [mem 0x100000000-0x117ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x117ffffff @ [mem 0xdb7aa000-0xdb7abfff]
[    0.000000] ACPI: RSDP 00000000000e5210 00014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 00000000db7d0540 00040 (v01 HPQOEM SLIC-BPC 20110714      00000000)
[    0.000000] ACPI: FACP 00000000db7d05e8 00074 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000050/0x0 (20121018/tbfadt-598)
[    0.000000] ACPI BIOS Bug: Warning: Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20121018/tbfadt-648)
[    0.000000] ACPI: DSDT 00000000db7d0a4f 0A69E (v01 COMPAQ DSDT_PRJ 00000001 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000db7d0500 00040
[    0.000000] ACPI: APIC 00000000db7d065c 000BC (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: ASF! 00000000db7d0718 00063 (v32 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: MCFG 00000000db7d077b 0003C (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: TCPA 00000000db7d07b7 00032 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: SLIC 00000000db7d07e9 00176 (v01 HPQOEM SLIC-BPC 00000001      00000000)
[    0.000000] ACPI: HPET 00000000db7d095f 00038 (v01 COMPAQ IBEXPEAK 00000001      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880113800000-ffff8801175fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x117ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdb7abfff]
[    0.000000]   node   0: [mem 0x100000000-0x117ffffff]
[    0.000000] On node 0 totalpages: 997179
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13983 pages used for memmap
[    0.000000]   DMA32 zone: 880909 pages, LIFO batch:31
[    0.000000]   Normal zone: 1536 pages used for memmap
[    0.000000]   Normal zone: 96768 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000db7ac000 - 00000000db7ad000
[    0.000000] PM: Registered nosave memory: 00000000db7ad000 - 00000000db7ae000
[    0.000000] PM: Registered nosave memory: 00000000db7ae000 - 00000000db7af000
[    0.000000] PM: Registered nosave memory: 00000000db7af000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fe000000
[    0.000000] PM: Registered nosave memory: 00000000fe000000 - 00000000fed40000
[    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000fed45000
[    0.000000] PM: Registered nosave memory: 00000000fed45000 - 0000000100000000
[    0.000000] e820: [mem 0xe0000000-0xf3ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880117c00000 s74304 r8192 d24000 u262144
[    0.000000] pcpu-alloc: s74304 r8192 d24000 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 981590
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc4-00071-g9a92841 root=/dev/sda1 ro drm.debug=0xe
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3842424k/4587520k available (4473k kernel code, 598804k absent, 146292k reserved, 4072k data, 492k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3325.340 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6650.68 BogoMIPS (lpj=13301360)
[    0.000062] pid_max: default: 32768 minimum: 301
[    0.000110] Mount-cache hash table entries: 256
[    0.000253] CPU: Physical Processor ID: 0
[    0.000280] CPU: Processor Core ID: 0
[    0.000308] mce: CPU supports 9 MCE banks
[    0.000342] CPU0: Thermal monitoring enabled (TM1)
[    0.000375] process: using mwait in idle threads
[    0.000405] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.000405] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000405] tlb_flushall_shift: 6
[    0.000553] Freeing SMP alternatives: 20k freed
[    0.000587] ACPI: Core revision 20121018
[    0.004748] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044347] smpboot: CPU0: Intel(R) Core(TM) i5 CPU         660  @ 3.33GHz (fam: 06, model: 25, stepping: 05)
[    0.151287] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.151367] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.151407] ... version:                3
[    0.151439] ... bit width:              48
[    0.151471] ... generic registers:      4
[    0.151504] ... value mask:             0000ffffffffffff
[    0.151540] ... max period:             000000007fffffff
[    0.151575] ... fixed-purpose events:   3
[    0.151607] ... event mask:             000000070000000f
[    0.165028] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.151766] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.191408] Brought up 4 CPUs
[    0.191464] smpboot: Total of 4 processors activated (26602.72 BogoMIPS)
[    0.193322] PM: Registering ACPI NVS region [mem 0xdb7ac440-0xdb7ae49f] (8288 bytes)
[    0.193389] reboot: BIOS series board detected. Selecting HP Compaq Laptop-method for reboots.
[    0.193492] NET: Registered protocol family 16
[    0.193596] ACPI: bus type pci registered
[    0.193666] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf4000000-0xf7ffffff] (base 0xf4000000)
[    0.193731] PCI: MMCONFIG at [mem 0xf4000000-0xf7ffffff] reserved in E820
[    0.196352] PCI: Using configuration type 1 for base access
[    0.196773] bio: create slab <bio-0> at 0
[    0.196841] ACPI: Added _OSI(Module Device)
[    0.196875] ACPI: Added _OSI(Processor Device)
[    0.196910] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.196944] ACPI: Added _OSI(Processor Aggregator Device)
[    0.197466] ACPI: EC: Look up EC in DSDT
[    0.202202] ACPI: SSDT 00000000db7dc771 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.202430] ACPI: Dynamic OEM Table Load:
[    0.202471] ACPI: SSDT           (null) 003BA (v01 COMPAQ  CPU_TM2 00000001 MSFT 0100000E)
[    0.202606] ACPI: SSDT 00000000db7dc399 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.202811] ACPI: Dynamic OEM Table Load:
[    0.202851] ACPI: SSDT           (null) 003D8 (v01 COMPAQ      CST 00000001 MSFT 0100000E)
[    0.206327] ACPI: Interpreter enabled
[    0.206361] ACPI: (supports S0 S3 S4 S5)
[    0.206418] ACPI: Using IOAPIC for interrupt routing
[    0.208537] ACPI: No dock devices found.
[    0.208572] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.208749] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.208789] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.208889] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20121018/dsfield-211)
[    0.208966] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113432668), AE_ALREADY_EXISTS (20121018/psparse-537)
[    0.209053] ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
[    0.209123] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20121018/nspredef-359)
[    0.209225] ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20121018/dsfield-211)
[    0.209300] ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880113432668), AE_ALREADY_EXISTS (20121018/psparse-537)
[    0.209881] ACPI Warning: For \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, ACPI requires 4 (20121018/nspredef-359)
[    0.209960] pci_root PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.210022] pci_root PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.210260] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.210345] PCI host bridge to bus 0000:00
[    0.210379] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.210415] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xfdffffff]
[    0.210455] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.210493] pci_bus 0000:00: root bus resource [io  0x1000-0x2fff]
[    0.210531] pci_bus 0000:00: root bus resource [io  0x3000-0x6fff]
[    0.210569] pci_bus 0000:00: root bus resource [io  0x7000-0xafff]
[    0.210606] pci_bus 0000:00: root bus resource [io  0xb000-0xffff]
[    0.210644] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.210684] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf3ffffff]
[    0.210723] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.210768] pci 0000:00:00.0: [8086:0040] type 00 class 0x060000
[    0.210781] DMAR: Disabling batched IOTLB flush on Ironlake
[    0.210832] pci 0000:00:02.0: [8086:0042] type 00 class 0x030000
[    0.210840] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.210844] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.210848] pci 0000:00:02.0: reg 20: [io  0x1170-0x1177]
[    0.210890] pci 0000:00:16.0: [8086:3b64] type 00 class 0x078000
[    0.210915] pci 0000:00:16.0: reg 10: [mem 0xf0427100-0xf042710f 64bit]
[    0.211002] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.211023] pci 0000:00:16.3: [8086:3b67] type 00 class 0x070002
[    0.211037] pci 0000:00:16.3: reg 10: [io  0x1188-0x118f]
[    0.211044] pci 0000:00:16.3: reg 14: [mem 0xf0424000-0xf0424fff]
[    0.211132] pci 0000:00:19.0: [8086:10ef] type 00 class 0x020000
[    0.211145] pci 0000:00:19.0: reg 10: [mem 0xf0400000-0xf041ffff]
[    0.211152] pci 0000:00:19.0: reg 14: [mem 0xf0425000-0xf0425fff]
[    0.211158] pci 0000:00:19.0: reg 18: [io  0x1100-0x111f]
[    0.211206] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.211225] pci 0000:00:1a.0: [8086:3b3c] type 00 class 0x0c0320
[    0.211242] pci 0000:00:1a.0: reg 10: [mem 0xf0426800-0xf0426bff]
[    0.211314] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.211334] pci 0000:00:1b.0: [8086:3b56] type 00 class 0x040300
[    0.211346] pci 0000:00:1b.0: reg 10: [mem 0xf0420000-0xf0423fff 64bit]
[    0.211398] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.211414] pci 0000:00:1c.0: [8086:3b42] type 01 class 0x060400
[    0.211467] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.211486] pci 0000:00:1c.4: [8086:3b4a] type 01 class 0x060400
[    0.211538] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.211554] pci 0000:00:1c.6: [8086:3b4e] type 01 class 0x060400
[    0.211605] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.211628] pci 0000:00:1d.0: [8086:3b34] type 00 class 0x0c0320
[    0.211644] pci 0000:00:1d.0: reg 10: [mem 0xf0426c00-0xf0426fff]
[    0.211716] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.211733] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.211780] pci 0000:00:1f.0: [8086:3b0a] type 00 class 0x060100
[    0.211882] pci 0000:00:1f.2: [8086:3b22] type 00 class 0x010601
[    0.211896] pci 0000:00:1f.2: reg 10: [io  0x1190-0x1197]
[    0.211901] pci 0000:00:1f.2: reg 14: [io  0x11a8-0x11ab]
[    0.211908] pci 0000:00:1f.2: reg 18: [io  0x1198-0x119f]
[    0.211913] pci 0000:00:1f.2: reg 1c: [io  0x11ac-0x11af]
[    0.211919] pci 0000:00:1f.2: reg 20: [io  0x1120-0x113f]
[    0.211925] pci 0000:00:1f.2: reg 24: [mem 0xf0426000-0xf04267ff]
[    0.211959] pci 0000:00:1f.2: PME# supported from D3hot
[    0.212000] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.212068] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.212136] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.212221] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
[    0.212266] pci 0000:00:1e.0:   bridge window [mem 0xf8000000-0xfdffffff] (subtractive decode)
[    0.212267] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.212268] pci 0000:00:1e.0:   bridge window [io  0x1000-0x2fff] (subtractive decode)
[    0.212269] pci 0000:00:1e.0:   bridge window [io  0x3000-0x6fff] (subtractive decode)
[    0.212271] pci 0000:00:1e.0:   bridge window [io  0x7000-0xafff] (subtractive decode)
[    0.212272] pci 0000:00:1e.0:   bridge window [io  0xb000-0xffff] (subtractive decode)
[    0.212273] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.212274] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf3ffffff] (subtractive decode)
[    0.212275] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.212288] pci_bus 0000:00: on NUMA node 0
[    0.212300] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[    0.212326] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX5._PRT]
[    0.212349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX7._PRT]
[    0.212371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[    0.212424] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.215605] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.215712] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.215817] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.215922] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.216026] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 14 15)
[    0.216131] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 14 15)
[    0.216236] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
[    0.216342] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
[    0.216484] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.216546] vgaarb: loaded
[    0.216576] vgaarb: bridge control possible 0000:00:02.0
[    0.216641] SCSI subsystem initialized
[    0.216674] ACPI: bus type scsi registered
[    0.216726] libata version 3.00 loaded.
[    0.216742] PCI: Using ACPI for IRQ routing
[    0.217878] PCI: Discovered peer bus 3f
[    0.217910] PCI: root bus 3f: using default resources
[    0.217911] PCI: Probing PCI hardware (bus 3f)
[    0.217924] PCI host bridge to bus 0000:3f
[    0.217957] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.217995] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
[    0.218035] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    0.218099] pci 0000:3f:00.0: [8086:2c61] type 00 class 0x060000
[    0.218112] pci 0000:3f:00.1: [8086:2d01] type 00 class 0x060000
[    0.218128] pci 0000:3f:02.0: [8086:2d10] type 00 class 0x060000
[    0.218140] pci 0000:3f:02.1: [8086:2d11] type 00 class 0x060000
[    0.218152] pci 0000:3f:02.2: [8086:2d12] type 00 class 0x060000
[    0.218164] pci 0000:3f:02.3: [8086:2d13] type 00 class 0x060000
[    0.218182] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.218245] PCI: pci_cache_line_size set to 64 bytes
[    0.218278] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.218279] e820: reserve RAM buffer [mem 0xdb7ac440-0xdbffffff]
[    0.218346] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.218421] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.220457] Switching to clocksource hpet
[    0.220523] pnp: PnP ACPI init
[    0.220558] ACPI: bus type pnp registered
[    0.220617] pnp 00:00: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.220625] pnp 00:01: [dma 4]
[    0.220633] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.220649] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.220661] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.220676] pnp 00:04: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
[    0.220692] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.220843] pnp 00:06: [dma 3]
[    0.220878] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.221027] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    0.221065] pnp 00:08: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.221079] pnp 00:09: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    0.221105] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.221220] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.221246] system 00:0c: [io  0x04d0-0x04d1] has been reserved
[    0.221285] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.221312] system 00:0d: [io  0x0400-0x041f] has been reserved
[    0.221350] system 00:0d: [io  0x0420-0x043f] has been reserved
[    0.221388] system 00:0d: [io  0x0440-0x045f] has been reserved
[    0.221425] system 00:0d: [io  0x0460-0x047f] has been reserved
[    0.221462] system 00:0d: [io  0x0480-0x048f] has been reserved
[    0.221500] system 00:0d: [io  0xf800-0xf81f] has been reserved
[    0.221537] system 00:0d: [io  0xf820-0xf83f] has been reserved
[    0.221575] system 00:0d: [io  0xf840-0xf85f] has been reserved
[    0.221612] system 00:0d: [io  0xf860-0xf87f] has been reserved
[    0.221649] system 00:0d: [io  0xfa00-0xfa3f] has been reserved
[    0.221687] system 00:0d: [io  0xfc00-0xfc7f] has been reserved
[    0.221724] system 00:0d: [io  0xfc80-0xfcff] has been reserved
[    0.221761] system 00:0d: [io  0xfe00-0xfe7f] has been reserved
[    0.221800] system 00:0d: [io  0xfe80-0xfeff] has been reserved
[    0.221838] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.222009] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.222051] system 00:0e: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.222091] system 00:0e: [mem 0x000e4000-0x000fffff] could not be reserved
[    0.222131] system 00:0e: [mem 0xfec01000-0xfecfffff] has been reserved
[    0.222170] system 00:0e: [mem 0xfed00400-0xfed3ffff] has been reserved
[    0.222209] system 00:0e: [mem 0xfed45000-0xffffffff] has been reserved
[    0.222248] system 00:0e: [mem 0xf4000000-0xf7ffffff] has been reserved
[    0.222287] system 00:0e: [mem 0x000cfe00-0x000e3fff] has been reserved
[    0.222327] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.222334] pnp: PnP ACPI: found 15 devices
[    0.222367] ACPI: ACPI bus type pnp unregistered
[    0.227356] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 18] add_size 1000
[    0.227359] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 18] add_size 200000
[    0.227361] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 18] add_size 200000
[    0.227367] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 24] add_size 1000
[    0.227369] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 24] add_size 200000
[    0.227370] pci 0000:00:1c.4: bridge window [mem 0x00100000-0x000fffff] to [bus 24] add_size 200000
[    0.227376] pci 0000:00:1c.6: bridge window [io  0x1000-0x0fff] to [bus 30] add_size 1000
[    0.227377] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 30] add_size 200000
[    0.227379] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff] to [bus 30] add_size 200000
[    0.227389] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.227390] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.227391] pci 0000:00:1c.4: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.227393] pci 0000:00:1c.4: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.227394] pci 0000:00:1c.6: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.227396] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.227397] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.227399] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.227400] pci 0000:00:1c.6: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.227403] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf8000000-0xf81fffff]
[    0.227443] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.227504] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf8400000-0xf85fffff]
[    0.227544] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.227604] pci 0000:00:1c.6: BAR 14: assigned [mem 0xf8800000-0xf89fffff]
[    0.227644] pci 0000:00:1c.6: BAR 15: assigned [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.227706] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.227744] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.227783] pci 0000:00:1c.6: BAR 13: assigned [io  0x4000-0x4fff]
[    0.227821] pci 0000:00:1c.0: PCI bridge to [bus 18]
[    0.227857] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.227897] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf81fffff]
[    0.227938] pci 0000:00:1c.0:   bridge window [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.228001] pci 0000:00:1c.4: PCI bridge to [bus 24]
[    0.228036] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.228076] pci 0000:00:1c.4:   bridge window [mem 0xf8400000-0xf85fffff]
[    0.228117] pci 0000:00:1c.4:   bridge window [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.228180] pci 0000:00:1c.6: PCI bridge to [bus 30]
[    0.228215] pci 0000:00:1c.6:   bridge window [io  0x4000-0x4fff]
[    0.228255] pci 0000:00:1c.6:   bridge window [mem 0xf8800000-0xf89fffff]
[    0.228295] pci 0000:00:1c.6:   bridge window [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.228358] pci 0000:00:1e.0: PCI bridge to [bus 0d]
[    0.228418] pci 0000:00:1e.0: setting latency timer to 64
[    0.228421] pci_bus 0000:00: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.228422] pci_bus 0000:00: resource 5 [io  0x0000-0x0cf7]
[    0.228423] pci_bus 0000:00: resource 6 [io  0x1000-0x2fff]
[    0.228424] pci_bus 0000:00: resource 7 [io  0x3000-0x6fff]
[    0.228426] pci_bus 0000:00: resource 8 [io  0x7000-0xafff]
[    0.228427] pci_bus 0000:00: resource 9 [io  0xb000-0xffff]
[    0.228428] pci_bus 0000:00: resource 10 [mem 0x000a0000-0x000bffff]
[    0.228429] pci_bus 0000:00: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.228430] pci_bus 0000:00: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.228432] pci_bus 0000:18: resource 0 [io  0x2000-0x2fff]
[    0.228433] pci_bus 0000:18: resource 1 [mem 0xf8000000-0xf81fffff]
[    0.228434] pci_bus 0000:18: resource 2 [mem 0xf8200000-0xf83fffff 64bit pref]
[    0.228435] pci_bus 0000:24: resource 0 [io  0x3000-0x3fff]
[    0.228437] pci_bus 0000:24: resource 1 [mem 0xf8400000-0xf85fffff]
[    0.228438] pci_bus 0000:24: resource 2 [mem 0xf8600000-0xf87fffff 64bit pref]
[    0.228439] pci_bus 0000:30: resource 0 [io  0x4000-0x4fff]
[    0.228440] pci_bus 0000:30: resource 1 [mem 0xf8800000-0xf89fffff]
[    0.228442] pci_bus 0000:30: resource 2 [mem 0xf8a00000-0xf8bfffff 64bit pref]
[    0.228443] pci_bus 0000:0d: resource 4 [mem 0xf8000000-0xfdffffff]
[    0.228444] pci_bus 0000:0d: resource 5 [io  0x0000-0x0cf7]
[    0.228445] pci_bus 0000:0d: resource 6 [io  0x1000-0x2fff]
[    0.228447] pci_bus 0000:0d: resource 7 [io  0x3000-0x6fff]
[    0.228448] pci_bus 0000:0d: resource 8 [io  0x7000-0xafff]
[    0.228449] pci_bus 0000:0d: resource 9 [io  0xb000-0xffff]
[    0.228450] pci_bus 0000:0d: resource 10 [mem 0x000a0000-0x000bffff]
[    0.228451] pci_bus 0000:0d: resource 11 [mem 0xe0000000-0xf3ffffff]
[    0.228452] pci_bus 0000:0d: resource 12 [mem 0xfed40000-0xfed44fff]
[    0.228454] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.228455] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.228475] NET: Registered protocol family 2
[    0.228585] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.228711] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.228816] TCP: Hash tables configured (established 32768 bind 32768)
[    0.228875] TCP: reno registered
[    0.228907] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.228954] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.229040] NET: Registered protocol family 1
[    0.229081] pci 0000:00:02.0: Boot video device
[    0.229138] PCI: CLS 64 bytes, default 64
[    0.229150] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.229189] software IO TLB [mem 0xd77aa000-0xdb7aa000] (64MB) mapped at [ffff8800d77aa000-ffff8800db7a9fff]
[    0.229579] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.230346] VFS: Disk quotas dquot_6.5.2
[    0.230403] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.230610] msgmni has been set to 7504
[    0.230798] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.230859] io scheduler noop registered
[    0.230891] io scheduler deadline registered
[    0.230926] io scheduler cfq registered (default)
[    0.231079] intel_idle: MWAIT substates: 0x1120
[    0.231080] intel_idle: v0.4 model 0x25
[    0.231081] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.231137] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.231200] ACPI: Power Button [PBTN]
[    0.231253] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.231313] ACPI: Power Button [PWRF]
[    0.231367] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.251728] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.272035] 0000:00:16.3: ttyS1 at I/O 0x1188 (irq = 17) is a 16550A
[    0.272173] Linux agpgart interface v0.103
[    0.272233] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    0.272305] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.273011] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    0.273121] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.273193] [drm] Initialized drm 1.1.0 20060810
[    0.273340] [drm:i915_dump_device_info], i915 device info: gen=5, pciid=0x0042 flags=need_gfx_hws,has_hotplug,has_bsd_ring,
[    0.273347] i915 0000:00:02.0: setting latency timer to 64
[    0.285867] [drm:intel_detect_pch], Found Ibex Peak PCH
[    0.285917] [drm:intel_opregion_setup], graphic opregion physical addr: 0xdb7ac440
[    0.285922] [drm:intel_opregion_setup], SWSCI supported
[    0.285943] i915 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.285948] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.285987] [drm] Driver supports precise vblank timestamp query.
[    0.286024] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    0.286027] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT IRONLAKE-DESK  d
[    0.286029] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_clock_mode 0
[    0.286030] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    0.286032] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    0.286034] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    0.286036] [drm:parse_lfp_panel_data], VBT initial LVDS value 300
[    0.286037] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    0.286038] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    0.286040] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    0.286046] [drm:intel_dsm_pci_probe], no _DSM method for intel device
[    0.286054] [drm:intel_modeset_init], 2 display pipes available.
[    0.286062] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.286465] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
[    0.287484] [drm:ironlake_init_pch_refclk], has_panel 0 has_lvds 0 has_pch_edp 0 has_cpu_edp 0 has_ck505 0
[    0.287486] [drm:ironlake_init_pch_refclk], Disabling SSC entirely
[    0.289198] [drm:init_status_page], render ring hws offset: 0x00001000
[    0.289535] [drm:init_status_page], bsd ring hws offset: 0x00025000
[    0.289870] [drm:intel_modeset_setup_hw_state], [CRTC:3] hw state readout: enabled
[    0.289871] [drm:intel_modeset_setup_hw_state], [CRTC:5] hw state readout: disabled
[    0.289873] [drm:intel_modeset_setup_hw_state], [ENCODER:8:DAC-8] hw state readout: disabled, pipe=0
[    0.289875] [drm:intel_modeset_setup_hw_state], [ENCODER:9:TMDS-9] hw state readout: disabled, pipe=0
[    0.289877] [drm:intel_modeset_setup_hw_state], [ENCODER:13:TMDS-13] hw state readout: enabled, pipe=0
[    0.289880] [drm:intel_modeset_setup_hw_state], [CONNECTOR:7:VGA-1] hw state readout: disabled
[    0.289881] [drm:intel_modeset_setup_hw_state], [CONNECTOR:10:HDMI-A-1] hw state readout: disabled
[    0.289883] [drm:intel_modeset_setup_hw_state], [CONNECTOR:14:DP-1] hw state readout: enabled
[    0.289888] [drm:intel_connector_check_state], [CONNECTOR:14:DP-1]
[    0.289890] [drm:intel_modeset_check_state], [ENCODER:8:DAC-8]
[    0.289892] [drm:intel_modeset_check_state], [ENCODER:9:TMDS-9]
[    0.289894] [drm:intel_modeset_check_state], [ENCODER:13:TMDS-13]
[    0.289895] [drm:intel_modeset_check_state], [CRTC:3]
[    0.289897] [drm:intel_modeset_check_state], [CRTC:5]
[    0.289900] [drm:intel_crt_reset], pch crt adpa set to 0xf40000
[    0.289926] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[    0.289928] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40000
[    0.304248] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[    0.304250] [drm:intel_crt_detect], CRT not detected via hotplug
[    0.312224] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[    0.312226] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    0.312227] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[    0.312228] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[    0.312542] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[    0.312543] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[    0.312544] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    0.312546] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[    0.312547] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[    0.320200] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    0.320201] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    0.320202] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[    0.320203] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[    0.320512] [drm:intel_dp_detect], DPCD: 11 06 84 01 00 00 01 00 02 02 06 00 00 00 00
[    0.321537] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.348538] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.349564] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.366540] [drm:i915_hotplug_work_func], running encoder hotplug functions
[    0.372966] [drm:intel_dp_check_link_status], TMDS-13: channel EQ not ok, retraining
[    0.377668] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.377670] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 224
[    0.377731] Raw EDID:
[    0.377759]  	00 ff ff ff ff ff ff 00 22 f0 49 29 00 00 00 00
[    0.377796]  	15 15 01 04 a5 33 1d 78 26 01 f5 a2 57 52 9f 27
[    0.377833]  	0a 50 54 a1 08 00 81 c0 81 80 95 00 b3 00 d1 c0
[    0.377869]  	01 01 01 01 01 01 02 3a 80 18 71 38 2d 40 58 2c
[    0.377906]  	45 00 fe 1f 11 00 00 1e 00 00 00 fd 00 32 4c 18
[    0.377942]  	5e 11 00 0a 20 20 20 20 20 20 00 00 00 fc 00 48
[    0.377978]  	50 20 4c 41 32 33 30 36 0a 20 20 00 00 00 ff 00
[    0.378015]  	43 4e 43 31 32 31 31 32 50 42 0a 20 20 00 5a 00
[    0.395969] ------------[ cut here ]------------
[    0.396007] WARNING: at drivers/gpu/drm/i915/intel_dp.c:410 intel_dp_aux_ch+0x131/0x4e0()
[    0.396069] Hardware name: HP Compaq 8100 Elite SFF PC
[    0.396104] dp_aux_ch not started status 0x8015003f
[    0.396138] Modules linked in:
[    0.396173] Pid: 6, comm: kworker/u:0 Not tainted 3.8.0-rc4-00071-g9a92841 #80
[    0.396232] Call Trace:
[    0.396268]  [<ffffffff81036a29>] ? warn_slowpath_common+0x79/0xc0
[    0.396306]  [<ffffffff81036b25>] ? warn_slowpath_fmt+0x45/0x50
[    0.396343]  [<ffffffff812d7d61>] ? intel_dp_aux_ch+0x131/0x4e0
[    0.396381]  [<ffffffff812d82e2>] ? intel_dp_aux_native_write+0xa2/0xe0
[    0.396421]  [<ffffffff812da24f>] ? intel_dp_start_link_train+0x4f/0x2f0
[    0.396460]  [<ffffffff812da831>] ? intel_dp_check_link_status+0x91/0x180
[    0.396504]  [<ffffffff812a8bce>] ? i915_hotplug_work_func+0x6e/0xa0
[    0.396543]  [<ffffffff8104d1e0>] ? process_one_work+0x120/0x430
[    0.396581]  [<ffffffff812a8b60>] ? i915_error_work_func+0x100/0x100
[    0.396620]  [<ffffffff8104ef7d>] ? worker_thread+0x15d/0x450
[    0.396658]  [<ffffffff8104ee20>] ? schedule_delayed_work+0x20/0x20
[    0.396698]  [<ffffffff81053ca3>] ? kthread+0xb3/0xc0
[    0.396734]  [<ffffffff81053bf0>] ? kthread_create_on_node+0x110/0x110
[    0.397269]  [<ffffffff8145a7ec>] ? ret_from_fork+0x7c/0xb0
[    0.397306]  [<ffffffff81053bf0>] ? kthread_create_on_node+0x110/0x110
[    0.397348] ---[ end trace 872ab3aea478e207 ]---
[    0.397383] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.405066] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    0.405086] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[    0.405099] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] probed modes :
[    0.405100] [drm:drm_mode_debug_printmodeline], Modeline 16:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.405102] [drm:drm_mode_debug_printmodeline], Modeline 20:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    0.405104] [drm:drm_mode_debug_printmodeline], Modeline 47:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[    0.405105] [drm:drm_mode_debug_printmodeline], Modeline 42:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[    0.405107] [drm:drm_mode_debug_printmodeline], Modeline 41:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[    0.405109] [drm:drm_mode_debug_printmodeline], Modeline 46:"1600x900" 60 118963 1600 1696 1864 2128 900 901 904 932 0x0 0x6
[    0.405110] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    0.405112] [drm:drm_mode_debug_printmodeline], Modeline 18:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    0.405114] [drm:drm_mode_debug_printmodeline], Modeline 43:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[    0.405115] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[    0.405117] [drm:drm_mode_debug_printmodeline], Modeline 38:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    0.405119] [drm:drm_mode_debug_printmodeline], Modeline 45:"1366x768" 60 85885 1366 1439 1583 1800 768 769 772 795 0x0 0x6
[    0.405120] [drm:drm_mode_debug_printmodeline], Modeline 40:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[    0.405122] [drm:drm_mode_debug_printmodeline], Modeline 37:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[    0.405124] [drm:drm_mode_debug_printmodeline], Modeline 36:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[    0.405126] [drm:drm_mode_debug_printmodeline], Modeline 33:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    0.405127] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[    0.405129] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[    0.405131] [drm:drm_mode_debug_printmodeline], Modeline 17:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[    0.405133] [drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    0.405134] [drm:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[    0.405136] [drm:drm_mode_debug_printmodeline], Modeline 24:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    0.405138] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x576" 60 46970 1024 1064 1168 1312 576 577 580 597 0x0 0x6
[    0.405139] [drm:drm_mode_debug_printmodeline], Modeline 28:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[    0.405141] [drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    0.405143] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    0.405144] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[    0.405146] [drm:drm_mode_debug_printmodeline], Modeline 30:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[    0.405148] [drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    0.405149] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[    0.405151] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    0.405153] [drm:drm_mode_debug_printmodeline], Modeline 23:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    0.405155] [drm:drm_setup_crtcs], 
[    0.405156] [drm:drm_enable_connectors], connector 7 enabled? no
[    0.405157] [drm:drm_enable_connectors], connector 10 enabled? no
[    0.405158] [drm:drm_enable_connectors], connector 14 enabled? yes
[    0.405159] [drm:drm_target_preferred], looking for cmdline mode on connector 14
[    0.405160] [drm:drm_target_preferred], looking for preferred mode on connector 14
[    0.405161] [drm:drm_target_preferred], found mode 1920x1080
[    0.405162] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    0.405163] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 3
[    0.412639] [drm:intel_dp_start_link_train], clock recovery OK
[    0.417632] [drm:intelfb_create], allocated 1920x1080 fb: 0x00047000, bo ffff880112e3c200
[    0.417666] fbcon: inteldrmfb (fb0) is primary device
[    0.419730] [drm:intel_dp_link_down], 
[    0.444025] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.444740] [drm:intel_dp_start_link_train], clock recovery OK
[    0.451823] [drm:intel_dp_link_down], 
[    0.479915] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.480631] [drm:intel_dp_start_link_train], clock recovery OK
[    0.487713] [drm:intel_dp_link_down], 
[    0.515806] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.516521] [drm:intel_dp_start_link_train], clock recovery OK
[    0.523604] [drm:intel_dp_link_down], 
[    0.551696] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.552412] [drm:intel_dp_start_link_train], clock recovery OK
[    0.559495] [drm:intel_dp_link_down], 
[    0.587587] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.588303] [drm:intel_dp_start_link_train], clock recovery OK
[    0.595386] [drm:intel_dp_link_down], 
[    0.623478] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    0.624193] [drm:intel_dp_start_link_train], clock recovery OK
[    0.624194] [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
[    0.624195] [drm:intel_dp_link_down], 
[    0.651397] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    0.651398] [drm:intel_set_config_compute_mode_changes], crtc has no fb, full mode set
[    0.651399] [drm:intel_set_config_compute_mode_changes], modes are different, full mode set
[    0.651401] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 0 0 0 0 0 0 0x0 0x0
[    0.651402] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.651404] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[    0.651404] [drm:intel_crtc_set_config], attempting to set mode from userspace
[    0.651406] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.651407] [drm:intel_set_mode], set mode pipe masks: modeset: 1, prepare: 1, disable: 0
[    0.651409] [drm:intel_dp_mode_fixup], DP link computation with max lane count 4 max bw 06 pixel clock 148500KHz
[    0.651410] [drm:intel_dp_mode_fixup], DP link bw 06 lane count 4 clock 162000 bpp 24
[    0.651411] [drm:intel_dp_mode_fixup], DP link bw required 356400 available 518400
[    0.651411] [drm:intel_modeset_adjusted_mode], [CRTC:3]
[    0.651619] [drm:intel_dp_link_down], 
[    0.782787] ------------[ cut here ]------------
[    0.782792] WARNING: at drivers/gpu/drm/i915/intel_display.c:1028 ironlake_crtc_disable+0xb1/0x860()
[    0.782792] Hardware name: HP Compaq 8100 Elite SFF PC
[    0.782793] pipe_off wait timed out
[    0.782793] Modules linked in:
[    0.782795] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc4-00071-g9a92841 #80
[    0.782795] Call Trace:
[    0.782800]  [<ffffffff81036a29>] ? warn_slowpath_common+0x79/0xc0
[    0.782801]  [<ffffffff81036b25>] ? warn_slowpath_fmt+0x45/0x50
[    0.782802]  [<ffffffff812c6262>] ? intel_wait_for_pipe_off+0x62/0x170
[    0.782803]  [<ffffffff812c6bf1>] ? ironlake_crtc_disable+0xb1/0x860
[    0.782806]  [<ffffffff8128ee74>] ? drm_ut_debug_printk+0x44/0x70
[    0.782807]  [<ffffffff812cdf0e>] ? intel_set_mode+0x30e/0x900
[    0.782809]  [<ffffffff812cebe1>] ? intel_crtc_set_config+0x6e1/0x930
[    0.782811]  [<ffffffff814581b1>] ? __mutex_lock_slowpath+0xd1/0x140
[    0.782813]  [<ffffffff81282abf>] ? drm_fb_helper_set_par+0x6f/0xe0
[    0.782816]  [<ffffffff81216bdf>] ? fbcon_init+0x55f/0x5f0
[    0.782819]  [<ffffffff81266ddc>] ? visual_init+0xac/0x110
[    0.782820]  [<ffffffff8126863c>] ? bind_con_driver+0x16c/0x340
[    0.782821]  [<ffffffff81268870>] ? take_over_console+0x60/0x70
[    0.782822]  [<ffffffff81214f8b>] ? fbcon_takeover+0x5b/0xc0
[    0.782825]  [<ffffffff81059685>] ? notifier_call_chain+0x45/0x60
[    0.782827]  [<ffffffff81059865>] ? __blocking_notifier_call_chain+0x55/0x80
[    0.782828]  [<ffffffff8120e57f>] ? register_framebuffer+0x1af/0x2e0
[    0.782829]  [<ffffffff81282d24>] ? drm_fb_helper_single_fb_probe+0x1f4/0x330
[    0.782830]  [<ffffffff81283022>] ? drm_fb_helper_initial_config+0x1c2/0x220
[    0.782832]  [<ffffffff812eaa42>] ? intel_fbdev_init+0x32/0xb0
[    0.782835]  [<ffffffff810de64d>] ? __kmalloc+0xed/0x130
[    0.782836]  [<ffffffff812eaa8d>] ? intel_fbdev_init+0x7d/0xb0
[    0.782838]  [<ffffffff812a6f47>] ? i915_driver_load+0xbd7/0xdf0
[    0.782840]  [<ffffffff81291695>] ? drm_get_pci_dev+0x185/0x2c0
[    0.782842]  [<ffffffff811fbcb8>] ? pci_device_probe+0x98/0xe0
[    0.782845]  [<ffffffff812fde18>] ? driver_probe_device+0x68/0x220
[    0.782846]  [<ffffffff812fe063>] ? __driver_attach+0x93/0xa0
[    0.782847]  [<ffffffff812fdfd0>] ? driver_probe_device+0x220/0x220
[    0.782848]  [<ffffffff812fc2ad>] ? bus_for_each_dev+0x4d/0x80
[    0.782849]  [<ffffffff812fd588>] ? bus_add_driver+0x178/0x260
[    0.782850]  [<ffffffff812fe664>] ? driver_register+0x84/0x180
[    0.782852]  [<ffffffff8188dd1b>] ? drm_core_init+0x12f/0x12f
[    0.782854]  [<ffffffff810002e2>] ? do_one_initcall+0x122/0x170
[    0.782857]  [<ffffffff8186dba8>] ? kernel_init_freeable+0x102/0x192
[    0.782858]  [<ffffffff8186d54a>] ? do_early_param+0x83/0x83
[    0.782860]  [<ffffffff81446d00>] ? rest_init+0x70/0x70
[    0.782860]  [<ffffffff81446d09>] ? kernel_init+0x9/0xf0
[    0.782862]  [<ffffffff8145a7ec>] ? ret_from_fork+0x7c/0xb0
[    0.782863]  [<ffffffff81446d00>] ? rest_init+0x70/0x70
[    0.782863] ---[ end trace 872ab3aea478e208 ]---
[    0.838618] [drm:ironlake_disable_pch_transcoder] *ERROR* failed to disable transcoder 0
[    0.838826] [drm:intel_choose_pipe_bpp_dither], clamping display bpc (was -1) to EDID reported max of 8
[    0.838827] [drm:intel_choose_pipe_bpp_dither], setting pipe bpc to 8 (max display bpc 8)
[    0.838828] [drm:ironlake_crtc_mode_set], Mode for pipe 0:
[    0.838830] [drm:drm_mode_debug_printmodeline], Modeline 48:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[    0.838831] [drm:intel_get_pch_pll], CRTC:3 using pre-allocated PCH PLL c6014
[    0.838832] [drm:intel_get_pch_pll], using pll 0 for pipe 0
[    0.838833] [drm:intel_get_pch_pll], switching PLL c6014 off
[    0.839143] [drm:ironlake_check_fdi_lanes], checking fdi config on pipe 0, lanes 2
[    0.894447] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    0.894450] [drm:ironlake_update_plane], Writing base 00047000 00000000 0 0 7680
[    0.894454] [drm:intel_crtc_mode_set], [ENCODER:13:TMDS-13] set [MODE:48:1920x1080]
[    0.894456] [drm:ironlake_update_wm], FIFO watermarks For pipe A - plane 9, cursor: 6
[    0.894459] [drm:ironlake_check_srwm], watermark 1: display plane 91, fbc lines 3, cursor 6
[    0.894460] [drm:ironlake_check_srwm], watermark 2: display plane 202, fbc lines 4, cursor 10
[    0.950277] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    1.006107] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    1.006414] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x700
[    1.006415] [drm:ironlake_fdi_link_train], FDI train 1 done.
[    1.006567] [drm:ironlake_fdi_link_train], FDI_RX_IIR 0x600
[    1.006569] [drm:ironlake_fdi_link_train], FDI train 2 done.
[    1.006569] [drm:ironlake_fdi_link_train], FDI train done
[    1.006570] [drm:ironlake_enable_pch_pll], enable PCH PLL c6014 (active 0, on? 0)for crtc 3
[    1.006571] [drm:ironlake_enable_pch_pll], enabling PCH PLL c6014
[    1.008189] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.008906] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[    1.009622] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.010339] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.011055] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.011772] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.012488] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.013204] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.013921] [drm:intel_dp_start_link_train], too many voltage retries, give up
[    1.015141] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.015857] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.016574] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.017290] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.018006] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[    1.018723] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.019439] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.020156] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.020872] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.021588] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.022305] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.023021] [drm:intel_dp_start_link_train], too many voltage retries, give up
[    1.024241] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.024957] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.025674] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.026391] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.027107] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[    1.027823] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.028540] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.029256] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.029972] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.030689] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.031405] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.032122] [drm:intel_dp_start_link_train], too many voltage retries, give up
[    1.033341] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.034058] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.034774] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04400000
[    1.035491] [drm:intel_dp_start_link_train], training pattern 1 signal levels 00000000
[    1.036207] [drm:intel_dp_start_link_train], training pattern 1 signal levels 02000000
[    1.036923] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.037639] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.038356] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.039072] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.039789] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.040505] [drm:intel_dp_start_link_train], training pattern 1 signal levels 04000000
[    1.041221] [drm:intel_dp_start_link_train], clock recovery OK
[    1.042234] [drm:intel_dp_complete_link_train], Channel EQ done. DP Training successfull
[    1.065929] [drm:intel_connector_check_state], [CONNECTOR:14:DP-1]
[    1.065930] [drm:intel_modeset_check_state], [ENCODER:8:DAC-8]
[    1.065932] [drm:intel_modeset_check_state], [ENCODER:9:TMDS-9]
[    1.065933] [drm:intel_modeset_check_state], [ENCODER:13:TMDS-13]
[    1.065934] [drm:intel_modeset_check_state], [CRTC:3]
[    1.065935] [drm:intel_modeset_check_state], [CRTC:5]
[    1.065936] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[    1.065938] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[    1.065956] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    1.065957] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[    1.070039] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    1.070040] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[    1.074095] Console: switching to colour frame buffer device 240x67
[    1.074098] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[    1.074099] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[    1.088406] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.089577] i915 0000:00:02.0: registered panic notifier
[    1.090802] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD (20121018/video-1163)
[    1.091998] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[    1.093214] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    1.094440] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.095703] ahci 0000:00:1f.2: version 3.0
[    1.095743] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    1.095791] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x17 impl SATA mode
[    1.097024] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part sxs apst 
[    1.098259] ahci 0000:00:1f.2: setting latency timer to 64
[    1.098570] scsi0 : ahci
[    1.099846] scsi1 : ahci
[    1.101104] scsi2 : ahci
[    1.102362] scsi3 : ahci
[    1.103610] scsi4 : ahci
[    1.104843] scsi5 : ahci
[    1.106063] ata1: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426100 irq 41
[    1.107288] ata2: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426180 irq 41
[    1.108502] ata3: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426200 irq 41
[    1.109696] ata4: DUMMY
[    1.110889] ata5: SATA max UDMA/133 abar m2048@0xf0426000 port 0xf0426300 irq 41
[    1.112098] ata6: DUMMY
[    1.113342] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    1.117261] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.118519] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.119789] mousedev: PS/2 mouse device common for all mice
[    1.121028] rtc_cmos 00:02: RTC can wake from S4
[    1.122324] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.123564] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.124828] cpuidle: using governor ladder
[    1.126099] cpuidle: using governor menu
[    1.127386] TCP: cubic registered
[    1.128668] NET: Registered protocol family 10
[    1.130005] mip6: Mobile IPv6
[    1.131235] NET: Registered protocol family 17
[    1.132467] Key type dns_resolver registered
[    1.133792] PM: Hibernation image not present or could not be loaded.
[    1.133799] registered taskstats version 1
[    1.135283] rtc_cmos 00:02: setting system clock to 2013-01-21 09:20:46 UTC (1358760046)
[    1.225508] tsc: Refined TSC clocksource calibration: 3325.374 MHz
[    1.226823] Switching to clocksource tsc
[    1.428896] ata5: SATA link down (SStatus 0 SControl 300)
[    1.430724] ata3: SATA link down (SStatus 0 SControl 300)
[    1.432002] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.433801] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.435212] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.436495] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.437824] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.439557] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.441270] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.442967] ata2.00: ATAPI: hp       CDDVDW TS-H653T, H6D1, max UDMA/100
[    1.444677] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.444887] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.444894] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.446242] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.447529] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.449844] ata1.00: ATA-8: Hitachi HDS721025CLA682, JP1OA41A, max UDMA/133
[    1.451203] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.452567] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.454443] ata2.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.456223] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.458038] ata2.00: configured for UDMA/100
[    1.459811] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.460915] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
[    1.462263] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
[    1.463795] ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.464012] ata1.00: ACPI cmd e3/00:00:00:00:00:a0 (IDLE) succeeded
[    1.464018] ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.465471] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.466838] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.469390] ata1.00: failed to get Identify Device Data, Emask 0x1
[    1.469397] ata1.00: configured for UDMA/133
[    1.471047] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72102 JP1O PQ: 0 ANSI: 5
[    1.472662] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.474141] sd 0:0:0:0: [sda] Write Protect is off
[    1.474441] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-H653T  H6D1 PQ: 0 ANSI: 5
[    1.477020] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.477035] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.522753]  sda: sda1 sda2 < sda5 >
[    1.524333] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.597567] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.598998] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    1.600897] Freeing unused kernel memory: 492k freed
[    1.602365] Write protecting the kernel read-only data: 8192k
[    1.606503] Freeing unused kernel memory: 1660k freed
[    1.609246] Freeing unused kernel memory: 668k freed
[    4.433441] microcode: CPU0 sig=0x20655, pf=0x2, revision=0x2
[    4.489234] processor LNXCPU:00: Invalid PBLK length [7]
[    4.490743] ACPI: Requesting acpi_cpufreq
[    4.492392] processor LNXCPU:01: Invalid PBLK length [7]
[    4.493931] processor LNXCPU:02: Invalid PBLK length [7]
[    4.495356] processor LNXCPU:03: Invalid PBLK length [7]
[    4.612786] mei 0000:00:16.0: setting latency timer to 64
[    4.612840] mei 0000:00:16.0: irq 42 for MSI/MSI-X
[    4.615607] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    4.617060] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    4.618489] e1000e 0000:00:19.0: setting latency timer to 64
[    4.618530] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.620039] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    4.658631] microcode: CPU0 updated to revision 0x3, date = 2011-09-01
[    4.660089] microcode: CPU1 sig=0x20655, pf=0x2, revision=0x2
[    4.661685] microcode: CPU1 updated to revision 0x3, date = 2011-09-01
[    4.663138] microcode: CPU2 sig=0x20655, pf=0x2, revision=0x2
[    4.664702] microcode: CPU2 updated to revision 0x3, date = 2011-09-01
[    4.666150] microcode: CPU3 sig=0x20655, pf=0x2, revision=0x2
[    4.668144] microcode: CPU3 updated to revision 0x3, date = 2011-09-01
[    4.669969] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.723888] wmi: Mapper loaded
[    4.745733] ACPI: bus type usb registered
[    4.747384] usbcore: registered new interface driver usbfs
[    4.749198] usbcore: registered new interface driver hub
[    4.751033] usbcore: registered new device driver usb
[    4.762296] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.783967] parport_pc 00:06: reported by Plug and Play ACPI
[    4.785445] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    4.814140] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 78:e3:b5:a0:e5:e4
[    4.815590] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.817068] e1000e 0000:00:19.0 eth0: MAC: 9, PHY: 9, PBA No: A002FF-0FF
[    4.837165] ehci-pci: EHCI PCI platform driver
[    4.838703] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    4.838706] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    4.840168] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.841645] ehci-pci 0000:00:1a.0: debug port 2
[    4.847031] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    4.847050] ehci-pci 0000:00:1a.0: irq 20, io mem 0xf0426800
[    4.858377] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.859836] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.861270] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.862703] usb usb1: Product: EHCI Host Controller
[    4.864130] usb usb1: Manufacturer: Linux 3.8.0-rc4-00071-g9a92841 ehci_hcd
[    4.865562] usb usb1: SerialNumber: 0000:00:1a.0
[    4.867110] hub 1-0:1.0: USB hub found
[    4.868560] hub 1-0:1.0: 3 ports detected
[    4.870125] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    4.870127] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    4.871604] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.873050] ehci-pci 0000:00:1d.0: debug port 2
[    4.878366] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    4.878372] ehci-pci 0000:00:1d.0: irq 20, io mem 0xf0426c00
[    4.890312] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.891738] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    4.893146] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.894550] usb usb2: Product: EHCI Host Controller
[    4.895933] usb usb2: Manufacturer: Linux 3.8.0-rc4-00071-g9a92841 ehci_hcd
[    4.897328] usb usb2: SerialNumber: 0000:00:1d.0
[    4.898780] hub 2-0:1.0: USB hub found
[    4.900131] hub 2-0:1.0: 3 ports detected
[    4.978063] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    5.061758] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.063102] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.064482] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.070031] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.071524] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.105526] tpm_tis 00:09: 1.2 TPM (device-id 0xB, rev-id 16)
[    5.133355] gpio_ich: GPIO from 180 to 255 on gpio_ich
[    5.177452] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    5.257846] iTCO_vendor_support: vendor-support=0
[    5.259481] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.260831] iTCO_wdt: Found a Q57 TCO device (Version=2, TCOBASE=0xf860)
[    5.262234] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.309452] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    5.312285] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.315288] hub 1-1:1.0: USB hub found
[    5.317083] hub 1-1:1.0: 6 ports detected
[    5.368903] tpm_tis 00:09: TPM is disabled/deactivated (0x7)
[    5.428687] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    5.560666] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    5.562074] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.563511] hub 2-1:1.0: USB hub found
[    5.565100] hub 2-1:1.0: 8 ports detected
[    5.640131] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    5.720890] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[    5.732166] usb 1-1.1: New USB device found, idVendor=0424, idProduct=2512
[    5.734115] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.736353] hub 1-1.1:1.0: USB hub found
[    5.737699] hub 1-1.1:1.0: 2 ports detected
[    5.770138] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    5.811615] usb 1-1.2: new low-speed USB device number 4 using ehci-pci
[    5.932899] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c30e
[    5.934269] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.935548] usb 1-1.2: Product: HID compliant keyboard
[    5.936801] usb 1-1.2: Manufacturer: Logitech
[    5.954444] input: HDA Intel MID HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    5.955866] input: HDA Intel MID Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    5.957169] input: HDA Intel MID Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    5.958482] input: HDA Intel MID Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    5.959823] input: HDA Intel MID Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    6.419587] usbcore: registered new interface driver usbhid
[    6.420936] usbhid: USB HID core driver
[    6.467576] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input10
[    6.468995] hid-generic 0003:046D:C30E.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input0
[    6.473161] input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.1/input/input11
[    6.474572] hid-generic 0003:046D:C30E.0002: input,hidraw1: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.0-1.2/input1
[    6.606068] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    8.039162] Adding 7532540k swap on /dev/sda5.  Priority:-1 extents:1 across:7532540k 
[    8.066752] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.273258] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    8.651925] fuse init (API version 7.20)
[    8.678872] loop: module loaded
[   12.570033] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   12.670672] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   12.670791] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.942915] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[   12.942921] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[   16.105314] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   16.107067] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.456287] lp0: using parport0 (interrupt-driven).
[   21.533384] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[   21.533388] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[   21.626686] [drm:i915_driver_open], 
[   21.626728] [drm:intel_crtc_set_config], [CRTC:3] [FB:49] #connectors=1 (x y) (0 0)
[   21.626734] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[   21.626737] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[   21.626740] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[   21.626776] [drm:i915_driver_open], 
[   21.655271] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   21.655280] [drm:drm_mode_getresources], CRTC[2] CONNECTORS[3] ENCODERS[3]
[   21.655332] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   21.655335] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   21.655337] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   21.655339] [drm:intel_crt_detect], CRT not detected via hotplug
[   21.662892] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   21.662898] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.662901] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   21.662904] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   21.663226] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.663228] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   21.663230] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   21.663232] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   21.663237] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   21.663239] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   21.663242] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   21.663243] [drm:intel_crt_detect], CRT not detected via hotplug
[   21.670841] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   21.670847] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.670850] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   21.670852] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   21.671173] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.671176] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   21.671178] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   21.671181] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   21.671240] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   21.671243] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   21.678814] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   21.678820] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   21.678824] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   21.678831] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   21.678834] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   21.686787] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   21.686790] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   21.686792] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   21.686826] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   21.686828] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[   21.687140] [drm:intel_dp_detect], DPCD: 11 06 84 01 00 00 01 00 02 02 06 00 00 00 00
[   21.688166] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.715159] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.716193] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.743204] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.743278] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   21.743321] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] probed modes :
[   21.743322] [drm:drm_mode_debug_printmodeline], Modeline 16:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[   21.743324] [drm:drm_mode_debug_printmodeline], Modeline 20:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   21.743326] [drm:drm_mode_debug_printmodeline], Modeline 47:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[   21.743327] [drm:drm_mode_debug_printmodeline], Modeline 42:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[   21.743329] [drm:drm_mode_debug_printmodeline], Modeline 41:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[   21.743330] [drm:drm_mode_debug_printmodeline], Modeline 46:"1600x900" 60 118963 1600 1696 1864 2128 900 901 904 932 0x0 0x6
[   21.743332] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   21.743334] [drm:drm_mode_debug_printmodeline], Modeline 18:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   21.743335] [drm:drm_mode_debug_printmodeline], Modeline 43:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   21.743337] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   21.743339] [drm:drm_mode_debug_printmodeline], Modeline 38:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   21.743340] [drm:drm_mode_debug_printmodeline], Modeline 45:"1366x768" 60 85885 1366 1439 1583 1800 768 769 772 795 0x0 0x6
[   21.743342] [drm:drm_mode_debug_printmodeline], Modeline 40:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[   21.743344] [drm:drm_mode_debug_printmodeline], Modeline 37:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[   21.743345] [drm:drm_mode_debug_printmodeline], Modeline 36:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[   21.743347] [drm:drm_mode_debug_printmodeline], Modeline 33:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   21.743349] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[   21.743350] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[   21.743352] [drm:drm_mode_debug_printmodeline], Modeline 17:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   21.743354] [drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   21.743355] [drm:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   21.743357] [drm:drm_mode_debug_printmodeline], Modeline 24:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   21.743358] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x576" 60 46970 1024 1064 1168 1312 576 577 580 597 0x0 0x6
[   21.743360] [drm:drm_mode_debug_printmodeline], Modeline 28:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   21.743362] [drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   21.743363] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   21.743365] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   21.743366] [drm:drm_mode_debug_printmodeline], Modeline 30:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   21.743368] [drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   21.743370] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[   21.743371] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   21.743373] [drm:drm_mode_debug_printmodeline], Modeline 23:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   21.743381] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   21.743421] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   21.743422] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   21.743424] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   21.743425] [drm:intel_crt_detect], CRT not detected via hotplug
[   21.750616] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   21.750622] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.750625] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   21.750627] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   21.750944] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.750945] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   21.750947] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   21.750948] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   21.750950] [drm:drm_mode_getconnector], [CONNECTOR:7:?]
[   21.750952] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[   21.750953] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40000, result 0
[   21.750954] [drm:intel_crt_detect], CRT not detected via hotplug
[   21.758583] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 0050 r(1)
[   21.758588] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.758591] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retry using GPIO bit-banging
[   21.758593] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 gmbus vga. force bit now 1
[   21.758910] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus vga
[   21.758911] [drm:intel_gmbus_force_bit], disabling bit-banging on i915 gmbus vga. force bit now 0
[   21.758912] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   21.758913] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[   21.758955] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   21.758957] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   21.766597] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   21.766604] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   21.766608] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   21.766615] [drm:drm_mode_getconnector], [CONNECTOR:10:?]
[   21.766619] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1]
[   21.774543] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   21.774548] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   21.774552] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:10:HDMI-A-1] disconnected
[   21.774596] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   21.774600] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[   21.774912] [drm:intel_dp_detect], DPCD: 11 06 84 01 00 00 01 00 02 02 06 00 00 00 00
[   21.775940] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.803055] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.804095] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.831127] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   21.831150] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   21.831163] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] probed modes :
[   21.831165] [drm:drm_mode_debug_printmodeline], Modeline 16:"1920x1080" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x48 0x5
[   21.831166] [drm:drm_mode_debug_printmodeline], Modeline 20:"1680x1050" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   21.831168] [drm:drm_mode_debug_printmodeline], Modeline 47:"1680x945" 60 131481 1680 1784 1960 2240 945 946 949 978 0x0 0x6
[   21.831170] [drm:drm_mode_debug_printmodeline], Modeline 42:"1400x1050" 75 156000 1400 1504 1648 1896 1050 1053 1057 1099 0x40 0x6
[   21.831171] [drm:drm_mode_debug_printmodeline], Modeline 41:"1400x1050" 60 121750 1400 1488 1632 1864 1050 1053 1057 1089 0x40 0x6
[   21.831173] [drm:drm_mode_debug_printmodeline], Modeline 46:"1600x900" 60 118963 1600 1696 1864 2128 900 901 904 932 0x0 0x6
[   21.831174] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   21.831176] [drm:drm_mode_debug_printmodeline], Modeline 18:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   21.831178] [drm:drm_mode_debug_printmodeline], Modeline 43:"1440x900" 75 136750 1440 1536 1688 1936 900 903 909 942 0x40 0x6
[   21.831179] [drm:drm_mode_debug_printmodeline], Modeline 19:"1440x900" 60 106500 1440 1520 1672 1904 900 903 909 934 0x40 0x6
[   21.831181] [drm:drm_mode_debug_printmodeline], Modeline 38:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   21.831182] [drm:drm_mode_debug_printmodeline], Modeline 45:"1366x768" 60 85885 1366 1439 1583 1800 768 769 772 795 0x0 0x6
[   21.831184] [drm:drm_mode_debug_printmodeline], Modeline 40:"1360x768" 60 85500 1360 1424 1536 1792 768 771 777 795 0x40 0x5
[   21.831186] [drm:drm_mode_debug_printmodeline], Modeline 37:"1280x800" 75 106500 1280 1360 1488 1696 800 803 809 838 0x40 0x6
[   21.831187] [drm:drm_mode_debug_printmodeline], Modeline 36:"1280x800" 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[   21.831189] [drm:drm_mode_debug_printmodeline], Modeline 33:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   21.831191] [drm:drm_mode_debug_printmodeline], Modeline 35:"1280x768" 75 102250 1280 1360 1488 1696 768 771 778 805 0x40 0x9
[   21.831192] [drm:drm_mode_debug_printmodeline], Modeline 34:"1280x768" 60 79500 1280 1344 1472 1664 768 771 778 798 0x40 0x6
[   21.831194] [drm:drm_mode_debug_printmodeline], Modeline 17:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   21.831195] [drm:drm_mode_debug_printmodeline], Modeline 32:"1024x768" 75 78750 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   21.831197] [drm:drm_mode_debug_printmodeline], Modeline 31:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   21.831199] [drm:drm_mode_debug_printmodeline], Modeline 24:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   21.831200] [drm:drm_mode_debug_printmodeline], Modeline 44:"1024x576" 60 46970 1024 1064 1168 1312 576 577 580 597 0x0 0x6
[   21.831202] [drm:drm_mode_debug_printmodeline], Modeline 28:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   21.831203] [drm:drm_mode_debug_printmodeline], Modeline 29:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   21.831205] [drm:drm_mode_debug_printmodeline], Modeline 21:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   21.831207] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   21.831208] [drm:drm_mode_debug_printmodeline], Modeline 30:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   21.831210] [drm:drm_mode_debug_printmodeline], Modeline 26:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   21.831211] [drm:drm_mode_debug_printmodeline], Modeline 25:"640x480" 73 31500 640 664 704 832 480 489 492 520 0x40 0xa
[   21.831213] [drm:drm_mode_debug_printmodeline], Modeline 22:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   21.831214] [drm:drm_mode_debug_printmodeline], Modeline 23:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   21.831219] [drm:drm_mode_getconnector], [CONNECTOR:14:?]
[   21.964052] [drm:drm_mode_addfb], [FB:50]
[   21.964194] [drm:drm_mode_setcrtc], [CRTC:3]
[   21.964196] [drm:drm_mode_setcrtc], [CONNECTOR:14:DP-1]
[   21.964198] [drm:intel_crtc_set_config], [CRTC:3] [FB:50] #connectors=1 (x y) (0 0)
[   21.964200] [drm:intel_modeset_stage_output_state], [CONNECTOR:14:DP-1] to [CRTC:3]
[   21.975707] [drm:ironlake_update_plane], Writing base 00830000 00000000 0 0 7680

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
