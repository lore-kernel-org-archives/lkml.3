Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3GIQoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:44:22 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:57077 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3GIQoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:44:18 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jul 2013 12:44:17 EDT
Date: Tue, 9 Jul 2013 18:36:01 +0200
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: early microcode on amd is broken when no initramfs provided
Message-ID: <20130709183601.5d567a83@fem.tu-ilmenau.de>
X-Mailer: Claws Mail 3.9.2-dirty (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_MICROCODE_EARLY is enabled on AMD but no initramfs is provided in the
bootmanager (grub2), the system hangs here:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-06005-gd2b4a64 (puck@acer) (gcc version 4.8.1 (Gentoo 4.8.1 p1.0, pie-0.5.6) ) #69 SMP PREEMPT Tue Jul 9 18:22:09 CEST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10.0-06005-gd2b4a64 root=/dev/sda1 ro pcie_aspm=force radeon.dpm=1
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000de555fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de556000-0x00000000de755fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000de756000-0x00000000dfd3efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfd3f000-0x00000000dfdbefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dfdbf000-0x00000000dfebefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dfebf000-0x00000000dfef6fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dfef7000-0x00000000dfefffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dff00000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f7000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Packard Bell EasyNote TK81/SJV52_DN, BIOS V2.14 07/27/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:                                                                                                                                                    
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back                                                                                                                               
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 base 0000FFE00000 mask FFFFFFE00000 write-protect
[    0.000000]   4 base 000100000000 mask FFFFE0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdff00 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 28672
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01c08000, 0x01c08fff] PGTABLE
[    0.000000] BRK [0x01c09000, 0x01c09fff] PGTABLE
[    0.000000] BRK [0x01c0a000, 0x01c0afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x01c0b000, 0x01c0bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xde555fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xde3fffff] page 2M
[    0.000000]  [mem 0xde400000-0xde555fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xde756000-0xdfd3efff]
[    0.000000]  [mem 0xde756000-0xde7fffff] page 4k
[    0.000000]  [mem 0xde800000-0xdfbfffff] page 2M
[    0.000000]  [mem 0xdfc00000-0xdfd3efff] page 4k
[    0.000000] BRK [0x01c0c000, 0x01c0cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdfef7000-0xdfefffff]
[    0.000000]  [mem 0xdfef7000-0xdfefffff] page 4k
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 00000000dfef6120 0005C (v01 ACRSYS ACRPRDCT 00000003      01000013)
[    0.000000] ACPI: FACP 00000000dfef5000 000F4 (v04 ACRSYS ACRPRDCT 00000003 1025 01000013)
[    0.000000] ACPI: DSDT 00000000dfee6000 0B9EF (v01 ACRSYS ACRPRDCT F0000000 1025 01000013)
[    0.000000] ACPI: FACS 00000000dfe99000 00040
[    0.000000] ACPI: HPET 00000000dfef4000 00038 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: APIC 00000000dfef3000 00084 (v02 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: MCFG 00000000dfef2000 0003C (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: BOOT 00000000dfee5000 00028 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SLIC 00000000dfee4000 00176 (v01 ACRSYS ACRPRDCT 00000001 1025 01000013)
[    0.000000] ACPI: SSDT 00000000dfee3000 00386 (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fffa000-0x11fffbfff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b600000-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xde555fff]
[    0.000000]   node   0: [mem 0xde756000-0xdfd3efff]
[    0.000000]   node   0: [mem 0xdfef7000-0xdfefffff]
[    0.000000]   node   0: [mem 0x100000000-0x11fffffff]
[    0.000000] On node 0 totalpages: 1047270
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14254 pages used for memmap
[    0.000000]   DMA32 zone: 912200 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x1002a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xde556000-0xde755fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfd3f000-0xdfdbefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfdbf000-0xdfebefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfebf000-0xdfef6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdff00000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xf6ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf7000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfec10fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec11000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffdfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffe00000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xf6ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88011fc00000 s74880 r8192 d23424 u524288
[    0.000000] pcpu-alloc: s74880 r8192 d23424 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030882
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10.0-06005-gd2b4a64 root=/dev/sda1 ro pcie_aspm=force radeon.dpm=1
[    0.000000] PCIe ASPM is forcibly enabled
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ d4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ d4000000
[    0.000000] PM: Registered nosave memory: [mem 0xd4000000-0xd7ffffff]
[    0.000000] Memory: 3979016K/4189080K available (4684K kernel code, 507K rwdata, 2176K rodata, 792K init, 756K bss, 210064K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 2094.751 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4189.50 BogoMIPS (lpj=2094751)
[    0.000298] pid_max: default: 32768 minimum: 301
[    0.000470] Security Framework initialized
[    0.000915] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002711] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003617] Mount-cache hash table entries: 256
[    0.003982] Initializing cgroup subsys devices
[    0.004136] Initializing cgroup subsys freezer
[    0.004285] Initializing cgroup subsys blkio
[    0.004451] tseg: 00dff00000
[    0.004454] CPU: Physical Processor ID: 0
[    0.004613] CPU: Processor Core ID: 0
[    0.004761] mce: CPU supports 6 MCE banks
[    0.004914] LVT offset 0 assigned for vector 0xf9
[    0.005061] process: using AMD E400 aware idle routine
[    0.005208] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
tlb_flushall_shift: 4
[    0.005653] Freeing SMP alternatives memory: 12K (ffffffff81b46000 - ffffffff81b49000)
[    0.005807] ACPI: Core revision 20130517
[    0.012354] ACPI: All ACPI Tables successfully acquired
[    0.617782] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.627941] smpboot: CPU0: AMD Athlon(tm) II P320 Dual-Core Processor (fam: 10, model: 06, stepping: 03)
[    0.729753] Performance Events: AMD PMU driver.
[    0.729943] ... version:                0
[    0.730092] ... bit width:              48
[    0.730240] ... generic registers:      4
[    0.730388] ... value mask:             0000ffffffffffff
[    0.730536] ... max period:             00007fffffffffff
[    0.730684] ... fixed-purpose events:   0
[    0.730835] ... event mask:             000000000000000f
[    0.731018] process: System has AMD C1E enabled
[    0.731173] process: Switch to broadcast mode on CPU0
[    0.739310] smpboot: Booting Node   0, Processors  #1
[    0.752552] Brought up 2 CPUs
[    0.752572] process: Switch to broadcast mode on CPU1
[    0.752992] smpboot: Total of 2 processors activated (8379.00 BogoMIPS)
[    0.753731] devtmpfs: initialized
[    0.754198] PM: Registering ACPI NVS region [mem 0xde556000-0xde755fff] (2097152 bytes)
[    0.754387] PM: Registering ACPI NVS region [mem 0xdfdbf000-0xdfebefff] (1048576 bytes)
[    0.754719] xor: measuring software checksum speed
[    0.764221]    prefetch64-sse:  6688.000 MB/sec
[    0.774223]    generic_sse:  6424.000 MB/sec
[    0.774367] xor: using function: prefetch64-sse (6688.000 MB/sec)
[    0.774564] NET: Registered protocol family 16
[    0.775357] node 0 link 0: io port [0, ffffff]
[    0.775361] TOM: 00000000e0000000 aka 3584M
[    0.775513] Fam 10h mmconf [mem 0xf7000000-0xf7ffffff]
[    0.775515] node 0 link 0: mmio [a0000, bffff]
[    0.775518] node 0 link 0: mmio [e0000000, f6ffffff]
[    0.775520] node 0 link 0: mmio [f7000000, f7ffffff] ==> none
[    0.775522] node 0 link 0: mmio [f8000000, ffdfffff]
[    0.775524] TOM2: 0000000120000000 aka 4608M
[    0.775674] bus: [bus 00-1f] on node 0 link 0
[    0.775675] bus: 00 [io  0x0000-0xffff]
[    0.775677] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.775677] bus: 00 [mem 0xe0000000-0xf6ffffff]
[    0.775678] bus: 00 [mem 0xf8000000-0xffffffff]
[    0.775679] bus: 00 [mem 0x120000000-0xfcffffffff]
[    0.775736] ACPI: bus type PCI registered
[    0.776126] PCI: MMCONFIG for domain 0000 [bus 00-0f] at [mem 0xf7000000-0xf7ffffff] (base 0xf7000000)
[    0.776395] PCI: MMCONFIG at [mem 0xf7000000-0xf7ffffff] reserved in E820
[    0.777637] PCI: Using configuration type 1 for base access
[    0.778134] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.778327] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.778473] mtrr: probably your BIOS does not setup all CPUs.
[    0.778621] mtrr: corrected configuration.
[    0.784751] bio: create slab <bio-0> at 0
[    0.801284] raid6: sse2x1    2601 MB/s
[    0.818261] raid6: sse2x2    3246 MB/s
[    0.835260] raid6: sse2x4    3511 MB/s
[    0.835409] raid6: using algorithm sse2x4 (3511 MB/s)
[    0.835558] raid6: using intx1 recovery algorithm
[    0.835839] ACPI: Added _OSI(Module Device)
[    0.835990] ACPI: Added _OSI(Processor Device)
[    0.836138] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.836303] ACPI: Added _OSI(Processor Aggregator Device)
[    0.838013] ACPI: EC: Look up EC in DSDT
[    0.839711] ACPI: Executed 1 blocks of module-level executable AML code
[    0.844083] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored

This was copied out of dmesg from a running kernel with CONFIG_MICROCODE_EARLY disabled.

regards,
  Johannes
