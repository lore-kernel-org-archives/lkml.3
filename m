Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaI3Ntl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:49:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:42622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbaI3Nth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:49:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,626,1406617200"; 
   d="scan'208";a="607567479"
Date: Tue, 30 Sep 2014 21:45:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [perf/x86/intel/uncore] WARNING: CPU: 3 PID: 1 at
 arch/x86/mm/ioremap.c:183 __ioremap_caller+0x24c/0x2d0()
Message-ID: <20140930134525.GA20166@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stephane,

FYI, we noticed the below WARNING on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 521e8bac67a71a6544274f39d5c61473e0e54ac0 ("perf/x86/intel/uncore: Update support for client uncore IMC PMU")

+-------------------------+------------+------------+
|                         | b10fc1c3e3 | 521e8bac67 |
+-------------------------+------------+------------+
| boot_successes          | 10         | 1          |
| boot_failures           | 0          | 9          |
| BUG:kernel_test_crashed | 0          | 9          |
+-------------------------+------------+------------+


[    6.773342] software IO TLB [mem 0xa5015000-0xa9015000] (64MB) mapped at [ffff8800a5015000-ffff8800a9014fff]
[    6.784010] resource sanity check: requesting [mem 0xfed10000-0xfed15fff], which spans more than reserved [mem 0xfed10000-0xfed13fff]
[    6.784951] ------------[ cut here ]------------
[    6.785331] WARNING: CPU: 3 PID: 1 at arch/x86/mm/ioremap.c:183 __ioremap_caller+0x24c/0x2d0()
[    6.786149] Info: mapping multiple BARs. Your kernel is fine.
[    6.786601] Modules linked in:
[    6.787046] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-wl-ath-00314-g3ec2e1e #1
[    6.787755] Hardware name: Intel Corporation 2012 Client Platform/LosLunas CRB, BIOS ACRVMBY1.86C.0054.B00.1107311147 07/31/2011
[    6.788670]  0000000000000009 ffff880437e0bb00 ffffffff818571f9 ffff880437e0bb48
[    6.789551]  ffff880437e0bb38 ffffffff8106ef1d ffffc900018d0000 0000000000006000
[    6.790349]  ffffc900018d0000 ffffc900018d0000 00000000fed10000 ffff880437e0bb98
[    6.791228] Call Trace:
[    6.791552]  [<ffffffff818571f9>] dump_stack+0x4d/0x66
[    6.791961]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
[    6.792413]  [<ffffffff8106ef8c>] warn_slowpath_fmt+0x4c/0x50
[    6.792939]  [<ffffffff8107544f>] ? iomem_map_sanity_check+0xcf/0xe0
[    6.793425]  [<ffffffff8105b82c>] __ioremap_caller+0x24c/0x2d0
[    6.793955]  [<ffffffff8105b8c7>] ioremap_nocache+0x17/0x20
[    6.794394]  [<ffffffff8103504d>] snb_uncore_imc_init_box+0x6d/0x90
[    6.794951]  [<ffffffff8103341c>] uncore_pci_probe+0xcc/0x1f0
[    6.795388]  [<ffffffff8142e8b5>] local_pci_probe+0x45/0xa0
[    6.795902]  [<ffffffff8142fba5>] ? pci_match_device+0xe5/0x110
[    6.796352]  [<ffffffff8142fce1>] pci_device_probe+0xd1/0x120
[    6.796864]  [<ffffffff815024c0>] driver_probe_device+0x90/0x3e0
[    6.797327]  [<ffffffff815028db>] __driver_attach+0x8b/0x90
[    6.797839]  [<ffffffff81502850>] ? __device_attach+0x40/0x40
[    6.798287]  [<ffffffff8150038b>] bus_for_each_dev+0x6b/0xb0
[    6.798796]  [<ffffffff81501f6e>] driver_attach+0x1e/0x20
[    6.799222]  [<ffffffff81501b60>] bus_add_driver+0x180/0x250
[    6.799730]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
[    6.800184]  [<ffffffff815030a4>] driver_register+0x64/0xf0
[    6.800698]  [<ffffffff8142e14c>] __pci_register_driver+0x4c/0x50
[    6.801161]  [<ffffffff81df6f19>] intel_uncore_init+0xc7/0x2ae
[    6.801691]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
[    6.802142]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    6.802650]  [<ffffffff8108d900>] ? parse_args+0x1c0/0x4e0
[    6.803075]  [<ffffffff81dea11b>] kernel_init_freeable+0x1b3/0x23b
[    6.803628]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
[    6.804034]  [<ffffffff8184a93e>] kernel_init+0xe/0xf0
[    6.804433]  [<ffffffff8185fe3c>] ret_from_fork+0x7c/0xb0
[    6.804928]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
[    6.805336] ---[ end trace 31a6fa76e4d9f116 ]---
[    6.808747] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer

Thanks,
Fengguang

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc6-wl-ath-00314-g3ec2e1e (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Sat Sep 27 17:08:49 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/loslunas/boot_boot-1-x86_64-rhel-3ec2e1eb7329693596b4732dbf8e022891e38e20-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/vmlinuz-3.17.0-rc6-wl-ath-00314-g3ec2e1e kconfig=x86_64-rhel commit=3ec2e1eb7329693596b4732dbf8e022891e38e20 branch=linux-devel/devel-hourly-2014092716 root=/dev/ram0 disable_mtrr_trim disable_mtrr_trim max_uptime=18000 RESULT_ROOT=/result/loslunas/boot/1/debian-x86_64.cgz/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/0 ip=::::loslunas::dhcp disable_mtrr_trim earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000a9014fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000a9015000-0x00000000a901afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a901b000-0x00000000aa7e9fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000aa7ea000-0x00000000aad79fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000aad7a000-0x00000000aaff9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000aaffa000-0x00000000aaffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000aafff000-0x00000000aaffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ab000000-0x00000000af9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffbfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000044e5fffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Intel Corporation 2012 Client Platform/LosLunas CRB, BIOS ACRVMBY1.86C.0054.B00.1107311147 07/31/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x44e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 0A0000000 mask FF8000000 write-back
[    0.000000]   3 base 0A8000000 mask FFE000000 write-back
[    0.000000]   4 base 0AA000000 mask FFF000000 write-back
[    0.000000]   5 base 100000000 mask F00000000 write-back
[    0.000000]   6 base 200000000 mask E00000000 write-back
[    0.000000]   7 base 400000000 mask FC0000000 write-back
[    0.000000]   8 base 440000000 mask FF0000000 write-back
[    0.000000]   9 base 44E000000 mask FFE000000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0xab000 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fca70-0x000fca7f] mapped at [ffff8800000fca70]
[    0.000000]   mpc: fc7c0-fc9f4
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0217a000, 0x0217afff] PGTABLE
[    0.000000] BRK [0x0217b000, 0x0217bfff] PGTABLE
[    0.000000] BRK [0x0217c000, 0x0217cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x44e400000-0x44e5fffff]
[    0.000000]  [mem 0x44e400000-0x44e5fffff] page 2M
[    0.000000] BRK [0x0217d000, 0x0217dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x44c000000-0x44e3fffff]
[    0.000000]  [mem 0x44c000000-0x44e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x44bffffff]
[    0.000000]  [mem 0x400000000-0x44bffffff] page 2M
[    0.000000] BRK [0x0217e000, 0x0217efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0xa9014fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xa8ffffff] page 2M
[    0.000000]  [mem 0xa9000000-0xa9014fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xa901b000-0xaa7e9fff]
[    0.000000]  [mem 0xa901b000-0xa91fffff] page 4k
[    0.000000]  [mem 0xa9200000-0xaa5fffff] page 2M
[    0.000000]  [mem 0xaa600000-0xaa7e9fff] page 4k
[    0.000000] BRK [0x0217f000, 0x0217ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xaafff000-0xaaffffff]
[    0.000000]  [mem 0xaafff000-0xaaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x78806000-0x7fff2fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000AAFFDE18 00006C (v01 INTEL  IVB-CPT  06222004 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000AAFE3D98 0000F4 (v04 INTEL  IVB-CPT  06222004 MSFT 00010013)
[    0.000000] ACPI: DSDT 0x00000000AAFC3018 00F8E9 (v02 INTEL  IVB-CPT  00000000 INTL 20110623)
[    0.000000] ACPI: FACS 0x00000000AAFF9E40 000040
[    0.000000] ACPI: APIC 0x00000000AAFFCF18 0000CC (v02 INTEL  IVB-CPT  06222004 MSFT 00010013)
[    0.000000] ACPI: HPET 0x00000000AAFF8F18 000038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
[    0.000000] ACPI: SSDT 0x00000000AAFE5018 0010A8 (v01 TrmRef PtidDevc 00001000 INTL 20110623)
[    0.000000] ACPI: SSDT 0x00000000AAFE4918 000411 (v01 AMI    PerfTune 00001000 INTL 20110623)
[    0.000000] ACPI: MCFG 0x00000000AAFF8E98 00003C (v01 INTEL  SNDYBRDG 06222004 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x00000000AAFF7818 000780 (v01 PmRef  Cpu0Ist  00003000 INTL 20110623)
[    0.000000] ACPI: SSDT 0x00000000AAFF6018 000A2C (v01 PmRef  CpuPm    00003000 INTL 20110623)
[    0.000000] ACPI: DMAR 0x00000000AAFE3C18 0000E8 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000044e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x44e5fffff]
[    0.000000]   NODE_DATA [mem 0x44e5ca000-0x44e5effff]
[    0.000000]  [ffffea0000000000-ffffea00113fffff] PMD -> [ffff88043dc00000-ffff88044dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x44e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0xa9014fff]
[    0.000000]   node   0: [mem 0xa901b000-0xaa7e9fff]
[    0.000000]   node   0: [mem 0xaafff000-0xaaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x44e5fffff]
[    0.000000] On node 0 totalpages: 4164990
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10848 pages used for memmap
[    0.000000]   DMA32 zone: 694245 pages, LIFO batch:31
[    0.000000]   Normal zone: 54168 pages used for memmap
[    0.000000]   Normal zone: 3466752 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xaba00000-0xaf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xa9015000-0xa901afff]
[    0.000000] PM: Registered nosave memory: [mem 0xaa7ea000-0xaad79fff]
[    0.000000] PM: Registered nosave memory: [mem 0xaad7a000-0xaaff9fff]
[    0.000000] PM: Registered nosave memory: [mem 0xaaffa000-0xaaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xab000000-0xaf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xafa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed17fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed18000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff8fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff900000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffcfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffd00000-0xffffffff]
[    0.000000] e820: [mem 0xafa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88044e200000 s88960 r8192 d21632 u131072
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4099889
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/loslunas/boot_boot-1-x86_64-rhel-3ec2e1eb7329693596b4732dbf8e022891e38e20-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/vmlinuz-3.17.0-rc6-wl-ath-00314-g3ec2e1e kconfig=x86_64-rhel commit=3ec2e1eb7329693596b4732dbf8e022891e38e20 branch=linux-devel/devel-hourly-2014092716 root=/dev/ram0 disable_mtrr_trim disable_mtrr_trim max_uptime=18000 RESULT_ROOT=/result/loslunas/boot/1/debian-x86_64.cgz/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/0 ip=::::loslunas::dhcp disable_mtrr_trim earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 16188624K/16659960K available (8595K kernel code, 1704K rwdata, 3836K rodata, 1808K init, 1888K bss, 471336K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=16.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-15.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=16
[    0.000000] NR_IRQS:524544 nr_irqs:552 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2195.063 MHz processor
[    0.000084] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.12 BogoMIPS (lpj=2195063)
[    0.000835] pid_max: default: 32768 minimum: 301
[    0.001205] ACPI: Core revision 20140724
[    0.070877] ACPI: All ACPI Tables successfully acquired
[    0.071557] Security Framework initialized
[    0.071865] SELinux:  Initializing.
[    0.072142] SELinux:  Starting in permissive mode
[    0.106155] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.127077] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.129899] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.130914] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.132338] Initializing cgroup subsys memory
[    0.132704] Initializing cgroup subsys devices
[    0.133057] Initializing cgroup subsys freezer
[    0.133408] Initializing cgroup subsys net_cls
[    0.133759] Initializing cgroup subsys blkio
[    0.134090] Initializing cgroup subsys perf_event
[    0.134463] Initializing cgroup subsys hugetlb
[    0.134861] CPU: Physical Processor ID: 0
[    0.135181] CPU: Processor Core ID: 0
[    0.135846] mce: CPU supports 9 MCE banks
[    0.136168] CPU0: Thermal LVT vector (0xfa) already installed
[    0.136599] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.136599] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.137545] Freeing SMP alternatives memory: 36K (ffffffff81f97000 - ffffffff81fa0000)
[    0.139416] ftrace: allocating 31123 entries in 122 pages
[    0.186653] Getting VERSION: 1060015
[    0.186971] Getting VERSION: 1060015
[    0.187284] Getting ID: 0
[    0.187541] Getting ID: 0
[    0.187834] dmar: Host address width 36
[    0.188155] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.188603] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.189218] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.189663] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.190277] dmar: RMRR base: 0x000000aacb7000 end: 0x000000aaccdfff
[    0.190741] dmar: RMRR base: 0x000000ab800000 end: 0x000000af9fffff
[    0.191296] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.191720] HPET id 0 under DRHD base 0xfed91000
[    0.192095] HPET id 0 under DRHD base 0xfed91000
[    0.192464] HPET id 0 under DRHD base 0xfed91000
[    0.192841] HPET id 0 under DRHD base 0xfed91000
[    0.193218] HPET id 0 under DRHD base 0xfed91000
[    0.193595] HPET id 0 under DRHD base 0xfed91000
[    0.193963] HPET id 0 under DRHD base 0xfed91000
[    0.194331] HPET id 0 under DRHD base 0xfed91000
[    0.194710] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.195632] Enabled IRQ remapping in x2apic mode
[    0.196010] masked ExtINT on CPU#0
[    0.196627] ENABLING IO-APIC IRQs
[    0.196922] init IO_APIC IRQs
[    0.197200]  apic 2 pin 0 not connected
[    0.197526] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.198151] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.199084] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.199707] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.200642] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.201248] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.202254] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.202921] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.203946] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.204614] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.205605] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.206212] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.207235] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.207903] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.208921] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.209600] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.210623] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.211247] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.212271] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.212938] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.213931] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.214625] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.215648] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.216267] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.217262] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.217957] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.218976] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.219654] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.220647] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.221263] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.222258] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.222952] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.223942]  apic 2 pin 16 not connected
[    0.224278]  apic 2 pin 17 not connected
[    0.224667]  apic 2 pin 18 not connected
[    0.224995]  apic 2 pin 19 not connected
[    0.225384]  apic 2 pin 20 not connected
[    0.225721]  apic 2 pin 21 not connected
[    0.226058]  apic 2 pin 22 not connected
[    0.226454]  apic 2 pin 23 not connected
[    0.226929] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.237466] smpboot: CPU0: Genuine Intel(R) CPU  @ 2.20GHz (fam: 06, model: 3a, stepping: 04)
[    0.238298] TSC deadline timer enabled
[    0.238710] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.239814] ... version:                3
[    0.240148] ... bit width:              48
[    0.240484] ... generic registers:      4
[    0.240871] ... value mask:             0000ffffffffffff
[    0.241288] ... max period:             0000ffffffffffff
[    0.241696] ... fixed-purpose events:   3
[    0.242091] ... event mask:             000000070000000f
[    0.256118] x86: Booting SMP configuration:
[    0.256464] .... node  #0, CPUs:        #1
[    0.268436] masked ExtINT on CPU#1
[    0.269122] CPU1: Thermal LVT vector (0xfa) already installed
[    0.272242] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.274029]   #2
[    0.285477] masked ExtINT on CPU#2
[    0.286162] CPU2: Thermal LVT vector (0xfa) already installed
[    0.289849]   #3
[    0.301168] masked ExtINT on CPU#3
[    0.301848] CPU3: Thermal LVT vector (0xfa) already installed
[    0.305582]   #4
[    0.316861] masked ExtINT on CPU#4
[    0.317567] CPU4: Thermal LVT vector (0xfa) already installed
[    0.321355]   #5
[    0.332665] masked ExtINT on CPU#5
[    0.333373] CPU5: Thermal LVT vector (0xfa) already installed
[    0.337112]   #6
[    0.348438] masked ExtINT on CPU#6
[    0.349152] CPU6: Thermal LVT vector (0xfa) already installed
[    0.352921]   #7
[    0.364214] masked ExtINT on CPU#7
[    0.364931] CPU7: Thermal LVT vector (0xfa) already installed
[    0.367581] x86: Booted up 1 node, 8 CPUs
[    0.367929] smpboot: Total of 8 processors activated (35121.00 BogoMIPS)
[    0.379306] devtmpfs: initialized
[    0.403503] evm: security.selinux
[    0.403796] evm: security.ima
[    0.404070] evm: security.capability
[    0.412034] PM: Registering ACPI NVS region [mem 0xaad7a000-0xaaff9fff] (2621440 bytes)
[    0.419598] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.420779] NET: Registered protocol family 16
[    0.429133] cpuidle: using governor menu
[    0.437027] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.437629] ACPI: bus type PCI registered
[    0.437976] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.438969] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.439737] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.440637] PCI: Using configuration type 1 for base access
[    0.469558] ACPI: Added _OSI(Module Device)
[    0.469909] ACPI: Added _OSI(Processor Device)
[    0.470275] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.470742] ACPI: Added _OSI(Processor Aggregator Device)
[    0.483267] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.483889] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.498696] ACPI: Executed 1 blocks of module-level executable AML code
[    0.535579] ACPI: Dynamic OEM Table Load:
[    0.536047] ACPI: SSDT 0xFFFF880437749000 00093B (v01 PmRef  Cpu0Cst  00003001 INTL 20110623)
[    0.544174] ACPI: Dynamic OEM Table Load:
[    0.544719] ACPI: SSDT 0xFFFF8804376DE000 000303 (v01 PmRef  ApIst    00003000 INTL 20110623)
[    0.552446] ACPI: Dynamic OEM Table Load:
[    0.552917] ACPI: SSDT 0xFFFF88043771F000 000119 (v01 PmRef  ApCst    00003000 INTL 20110623)
[    0.570689] ACPI: Interpreter enabled
[    0.571029] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.571937] ACPI: (supports S0 S1 S3 S4 S5)
[    0.572288] ACPI: Using IOAPIC for interrupt routing
[    0.574206] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.611656] acpi ABCDEFGH:00: ACPI dock station (docks/bays count: 1)
[    0.646704] ACPI: Power Resource [FN00] (off)
[    0.647666] ACPI: Power Resource [FN01] (off)
[    0.648644] ACPI: Power Resource [FN02] (on)
[    0.649678] ACPI: Power Resource [FN03] (on)
[    0.650726] ACPI: Power Resource [FN04] (on)
[    0.655481] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.655964] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.657021] \_SB_.PCI0:_OSC invalid UUID
[    0.657360] _OSC request data:1 1f 0 
[    0.657962] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.663562] PCI host bridge to bus 0000:00
[    0.663909] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.664401] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.664874] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.665352] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.665908] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.666433] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.667004] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.667528] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.668085] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.668603] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.669175] pci_bus 0000:00: root bus resource [mem 0xafa00000-0xfeafffff]
[    0.669693] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.670270] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.671229] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.671767] pci 0000:00:02.0: reg 0x10: [mem 0xafc00000-0xafffffff 64bit]
[    0.672272] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.672914] pci 0000:00:02.0: reg 0x20: [io  0x2000-0x203f]
[    0.674000] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.674501] pci 0000:00:14.0: reg 0x10: [mem 0xb02b0000-0xb02bffff 64bit]
[    0.675214] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.676010] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.676743] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.677243] pci 0000:00:16.0: reg 0x10: [mem 0xb02a0000-0xb02a000f 64bit]
[    0.677964] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.679026] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.679505] pci 0000:00:19.0: reg 0x10: [mem 0xb0200000-0xb021ffff]
[    0.680057] pci 0000:00:19.0: reg 0x14: [mem 0xb0280000-0xb0280fff]
[    0.680535] pci 0000:00:19.0: reg 0x18: [io  0x2080-0x209f]
[    0.681181] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.681980] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.682699] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.683205] pci 0000:00:1a.0: reg 0x10: [mem 0xb0270000-0xb02703ff]
[    0.683925] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.684827] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.685510] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.686058] pci 0000:00:1b.0: reg 0x10: [mem 0xb0260000-0xb0263fff 64bit]
[    0.686745] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.687601] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.688347] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.688984] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.689845] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.690603] pci 0000:00:1c.6: [8086:1e1c] type 01 class 0x060400
[    0.691250] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.692111] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.692878] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.693527] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.694394] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.695112] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.695614] pci 0000:00:1d.0: reg 0x10: [mem 0xb0250000-0xb02503ff]
[    0.696325] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.697233] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.697908] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.698863] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.699591] pci 0000:00:1f.0: [8086:1e47] type 00 class 0x060100
[    0.700772] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.701279] pci 0000:00:1f.2: reg 0x10: [io  0x20d0-0x20d7]
[    0.701790] pci 0000:00:1f.2: reg 0x14: [io  0x20c0-0x20c3]
[    0.702244] pci 0000:00:1f.2: reg 0x18: [io  0x20b0-0x20b7]
[    0.702697] pci 0000:00:1f.2: reg 0x1c: [io  0x20a0-0x20a3]
[    0.703207] pci 0000:00:1f.2: reg 0x20: [io  0x2060-0x207f]
[    0.703653] pci 0000:00:1f.2: reg 0x24: [mem 0xb0240000-0xb02407ff]
[    0.704298] pci 0000:00:1f.2: PME# supported from D3hot
[    0.705322] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.705811] pci 0000:00:1f.3: reg 0x10: [mem 0xb0230000-0xb02300ff 64bit]
[    0.706416] pci 0000:00:1f.3: reg 0x20: [io  0x2040-0x205f]
[    0.707675] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.708397] pci 0000:02:00.0: [8086:0082] type 00 class 0x028000
[    0.708973] pci 0000:02:00.0: reg 0x10: [mem 0xb0100000-0xb0101fff 64bit]
[    0.709856] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.710439] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.714110] pci 0000:00:1c.6: PCI bridge to [bus 02]
[    0.714530] pci 0000:00:1c.6:   bridge window [mem 0xb0100000-0xb01fffff]
[    0.715383] pci 0000:03:00.0: [104c:8231] type 01 class 0x060400
[    0.716142] pci 0000:03:00.0: supports D1 D2
[    0.716596] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.717330] pci 0000:00:1c.7: PCI bridge to [bus 03-04]
[    0.717763] pci 0000:00:1c.7:   bridge window [mem 0xb0000000-0xb00fffff]
[    0.718579] pci 0000:04:00.0: [104c:8235] type 00 class 0x0c0010
[    0.719085] pci 0000:04:00.0: reg 0x10: [mem 0xb0010000-0xb00107ff]
[    0.719644] pci 0000:04:00.0: reg 0x14: [mem 0xb0000000-0xb0003fff]
[    0.720293] pci 0000:04:00.0: supports D1 D2
[    0.720712] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot
[    0.721516] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.721997] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xb00fffff]
[    0.722756] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
[    0.723324] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.723955] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.724621] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.725283] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.726008] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.726663] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.727381] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    0.728054] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    0.728759] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    0.729438] pci 0000:00:1e.0:   bridge window [mem 0xafa00000-0xfeafffff] (subtractive decode)
[    0.730172] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.731889] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.732583] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.735641] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    0.737372] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.739101] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15), disabled.
[    0.740828] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    0.742491] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    0.744218] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.745959] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
[    0.747674] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    0.750662] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.751656] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.752106] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.752800] vgaarb: loaded
[    0.753071] vgaarb: bridge control possible 0000:00:02.0
[    0.754087] SCSI subsystem initialized
[    0.754565] ACPI: bus type USB registered
[    0.755089] usbcore: registered new interface driver usbfs
[    0.755576] usbcore: registered new interface driver hub
[    0.756277] usbcore: registered new device driver usb
[    0.756794] pps_core: LinuxPPS API ver. 1 registered
[    0.757276] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.757974] PTP clock support registered
[    0.759562] PCI: Using ACPI for IRQ routing
[    0.763846] PCI: pci_cache_line_size set to 64 bytes
[    0.764378] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
[    0.764900] e820: reserve RAM buffer [mem 0xa9015000-0xabffffff]
[    0.765380] e820: reserve RAM buffer [mem 0xaa7ea000-0xabffffff]
[    0.765870] e820: reserve RAM buffer [mem 0xab000000-0xabffffff]
[    0.766389] e820: reserve RAM buffer [mem 0x44e600000-0x44fffffff]
[    0.767518] NetLabel: Initializing
[    0.767835] NetLabel:  domain hash size = 128
[    0.768191] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.768700] NetLabel:  unlabeled traffic allowed by default
[    0.776358] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.777394] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.780321] Switched to clocksource hpet
[    0.879106] pnp: PnP ACPI init
[    0.879926] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.880436] system 00:00: [io  0x1000-0x100f] has been reserved
[    0.880882] system 00:00: [io  0xffff] has been reserved
[    0.881379] system 00:00: [io  0xffff] has been reserved
[    0.881792] system 00:00: [io  0x0400-0x0453] could not be reserved
[    0.882258] system 00:00: [io  0x0458-0x047f] has been reserved
[    0.882783] system 00:00: [io  0x0500-0x057f] has been reserved
[    0.884574] system 00:00: [io  0x164e-0x164f] has been reserved
[    0.885023] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.885643] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.886253] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.887453] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.888195] system 00:02: [io  0x0454-0x0457] has been reserved
[    0.888731] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.891089] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.891673] system 00:03: [mem 0xfed10000-0xfed17fff] could not be reserved
[    0.892197] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.892764] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.893254] system 00:03: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.893833] system 00:03: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.894416] system 00:03: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.894941] system 00:03: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.895522] system 00:03: [mem 0xff000000-0xffffffff] could not be reserved
[    0.896052] system 00:03: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.896653] system 00:03: [mem 0xafa00000-0xafa00fff] has been reserved
[    0.897139] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.899491] system 00:04: [mem 0x00000000-0x0009cfff] could not be reserved
[    0.900012] system 00:04: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.900858] pnp: PnP ACPI: found 5 devices
[    0.921238] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.921723] pci 0000:00:1c.6: PCI bridge to [bus 02]
[    0.922115] pci 0000:00:1c.6:   bridge window [mem 0xb0100000-0xb01fffff]
[    0.922713] pci 0000:03:00.0: PCI bridge to [bus 04]
[    0.923109] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xb00fffff]
[    0.923713] pci 0000:00:1c.7: PCI bridge to [bus 03-04]
[    0.924134] pci 0000:00:1c.7:   bridge window [mem 0xb0000000-0xb00fffff]
[    0.924719] pci 0000:00:1e.0: PCI bridge to [bus 05]
[    0.925129] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.925641] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.926073] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.926628] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.927100] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.927653] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.928115] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.928660] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.929137] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.929681] pci_bus 0000:00: resource 13 [mem 0xafa00000-0xfeafffff]
[    0.930149] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
[    0.930695] pci_bus 0000:02: resource 1 [mem 0xb0100000-0xb01fffff]
[    0.931171] pci_bus 0000:03: resource 1 [mem 0xb0000000-0xb00fffff]
[    0.931725] pci_bus 0000:04: resource 1 [mem 0xb0000000-0xb00fffff]
[    0.932188] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.932698] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.933133] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.933681] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.934144] pci_bus 0000:05: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.934686] pci_bus 0000:05: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.935150] pci_bus 0000:05: resource 10 [mem 0x000dc000-0x000dffff]
[    0.935709] pci_bus 0000:05: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.936187] pci_bus 0000:05: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.936746] pci_bus 0000:05: resource 13 [mem 0xafa00000-0xfeafffff]
[    0.937216] pci_bus 0000:05: resource 14 [mem 0xfed40000-0xfed44fff]
[    0.937956] NET: Registered protocol family 2
[    0.946838] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.949948] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.950631] TCP: Hash tables configured (established 131072 bind 65536)
[    0.951308] TCP: reno registered
[    0.952249] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.953347] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.955699] NET: Registered protocol family 1
[    0.957038] RPC: Registered named UNIX socket transport module.
[    0.957597] RPC: Registered udp transport module.
[    0.957977] RPC: Registered tcp transport module.
[    0.958356] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.958965] pci 0000:00:02.0: Video device with shadowed ROM
[    0.960064] IOAPIC[0]: Set routing entry (2-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:1)
[    0.960782] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:71 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.963073] IOAPIC[0]: Set routing entry (2-16 -> 0x81 -> IRQ 16 Mode:1 Active:1 Dest:1)
[    0.963849] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:81 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.966115] IOAPIC[0]: Set routing entry (2-23 -> 0x91 -> IRQ 23 Mode:1 Active:1 Dest:1)
[    0.966771] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    0.968364] pci 0000:03:00.0: TI XIO2000a quirk detected; secondary bus fast back-to-back transfers disabled
[    0.969188] PCI: CLS 64 bytes, default 64
[    0.969902] Unpacking initramfs...
[    6.772146] Freeing initrd memory: 122804K (ffff880078806000 - ffff88007fff3000)
[    6.772859] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    6.773342] software IO TLB [mem 0xa5015000-0xa9015000] (64MB) mapped at [ffff8800a5015000-ffff8800a9014fff]
[    6.784010] resource sanity check: requesting [mem 0xfed10000-0xfed15fff], which spans more than reserved [mem 0xfed10000-0xfed13fff]
[    6.784951] ------------[ cut here ]------------
[    6.785331] WARNING: CPU: 3 PID: 1 at arch/x86/mm/ioremap.c:183 __ioremap_caller+0x24c/0x2d0()
[    6.786149] Info: mapping multiple BARs. Your kernel is fine.
[    6.786601] Modules linked in:
[    6.787046] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-wl-ath-00314-g3ec2e1e #1
[    6.787755] Hardware name: Intel Corporation 2012 Client Platform/LosLunas CRB, BIOS ACRVMBY1.86C.0054.B00.1107311147 07/31/2011
[    6.788670]  0000000000000009 ffff880437e0bb00 ffffffff818571f9 ffff880437e0bb48
[    6.789551]  ffff880437e0bb38 ffffffff8106ef1d ffffc900018d0000 0000000000006000
[    6.790349]  ffffc900018d0000 ffffc900018d0000 00000000fed10000 ffff880437e0bb98
[    6.791228] Call Trace:
[    6.791552]  [<ffffffff818571f9>] dump_stack+0x4d/0x66
[    6.791961]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
[    6.792413]  [<ffffffff8106ef8c>] warn_slowpath_fmt+0x4c/0x50
[    6.792939]  [<ffffffff8107544f>] ? iomem_map_sanity_check+0xcf/0xe0
[    6.793425]  [<ffffffff8105b82c>] __ioremap_caller+0x24c/0x2d0
[    6.793955]  [<ffffffff8105b8c7>] ioremap_nocache+0x17/0x20
[    6.794394]  [<ffffffff8103504d>] snb_uncore_imc_init_box+0x6d/0x90
[    6.794951]  [<ffffffff8103341c>] uncore_pci_probe+0xcc/0x1f0
[    6.795388]  [<ffffffff8142e8b5>] local_pci_probe+0x45/0xa0
[    6.795902]  [<ffffffff8142fba5>] ? pci_match_device+0xe5/0x110
[    6.796352]  [<ffffffff8142fce1>] pci_device_probe+0xd1/0x120
[    6.796864]  [<ffffffff815024c0>] driver_probe_device+0x90/0x3e0
[    6.797327]  [<ffffffff815028db>] __driver_attach+0x8b/0x90
[    6.797839]  [<ffffffff81502850>] ? __device_attach+0x40/0x40
[    6.798287]  [<ffffffff8150038b>] bus_for_each_dev+0x6b/0xb0
[    6.798796]  [<ffffffff81501f6e>] driver_attach+0x1e/0x20
[    6.799222]  [<ffffffff81501b60>] bus_add_driver+0x180/0x250
[    6.799730]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
[    6.800184]  [<ffffffff815030a4>] driver_register+0x64/0xf0
[    6.800698]  [<ffffffff8142e14c>] __pci_register_driver+0x4c/0x50
[    6.801161]  [<ffffffff81df6f19>] intel_uncore_init+0xc7/0x2ae
[    6.801691]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
[    6.802142]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
[    6.802650]  [<ffffffff8108d900>] ? parse_args+0x1c0/0x4e0
[    6.803075]  [<ffffffff81dea11b>] kernel_init_freeable+0x1b3/0x23b
[    6.803628]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
[    6.804034]  [<ffffffff8184a93e>] kernel_init+0xe/0xf0
[    6.804433]  [<ffffffff8185fe3c>] ret_from_fork+0x7c/0xb0
[    6.804928]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
[    6.805336] ---[ end trace 31a6fa76e4d9f116 ]---
[    6.808747] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    6.818262] futex hash table entries: 4096 (order: 6, 262144 bytes)
[    6.818850] Initialise system trusted keyring
[    6.819286] audit: initializing netlink subsys (disabled)
[    6.819806] audit: type=2000 audit(1411838030.569:1): initialized
[    6.822462] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.837388] zpool: loaded
[    6.837727] zbud: loaded
[    6.838670] VFS: Disk quotas dquot_6.5.2
[    6.839324] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    6.844397] SGI XFS with ACLs, security attributes, no debug enabled
[    6.849473] 9p: Installing v9fs 9p2000 file system support
[    6.850235] msgmni has been set to 31858
[    6.851011] Key type big_key registered
[    6.851338] SELinux:  Registering netfilter hooks
[    6.858099] NET: Registered protocol family 38
[    6.858486] Key type asymmetric registered
[    6.858966] Asymmetric key parser 'x509' registered
[    6.859706] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    6.860917] io scheduler noop registered
[    6.861266] io scheduler deadline registered (default)
[    6.861799] io scheduler cfq registered
[    6.863039] IOAPIC[0]: Set routing entry (2-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:1)
[    6.863731] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A1 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    6.865406] IOAPIC[0]: Set routing entry (2-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:1)
[    6.866107] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B1 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    6.867871] IOAPIC[0]: Set routing entry (2-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1 Dest:1)
[    6.868489] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C1 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    6.869857] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.870352] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    6.871141] intel_idle: MWAIT substates: 0x1120
[    6.872857] intel_idle: v0.4 model 0x3A
[    6.873179] intel_idle: lapic_timer_reliable_states 0xffffffff
[    6.876344] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    6.877011] ACPI: Power Button [PWRF]
[    6.877638] ACPI: Fan [FAN0] (off)
[    6.878094] ACPI: Fan [FAN1] (off)
[    6.878533] ACPI: Fan [FAN2] (on)
[    6.879050] ACPI: Fan [FAN3] (on)
[    6.879493] ACPI: Fan [FAN4] (on)
[    6.885867] thermal LNXTHERM:00: registered as thermal_zone0
[    6.886307] ACPI: Thermal Zone [TZ00] (28 C)
[    6.888641] thermal LNXTHERM:01: registered as thermal_zone1
[    6.889079] ACPI: Thermal Zone [TZ01] (30 C)
[    6.889658] GHES: HEST is not enabled!
[    6.890432] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.894496] Non-volatile memory driver v1.3
[    6.894974] Linux agpgart interface v0.103
[    6.897145] mei_me 0000:00:16.0: irq 26 for MSI/MSI-X
[    6.900225] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20140724/utaddress-258)
[    6.901860] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.902755] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140724/utaddress-258)
[    6.904113] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.904987] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140724/utaddress-258)
[    6.906225] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.907030] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140724/utaddress-258)
[    6.908268] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    6.909011] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    6.909508] rdac: device handler registered
[    6.910243] hp_sw: device handler registered
[    6.910591] emc: device handler registered
[    6.910988] alua: device handler registered
[    6.911521] libphy: Fixed MDIO Bus: probed
[    6.912131] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    6.912757] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    6.913240] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    6.913760] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    6.914897] IOAPIC[0]: Set routing entry (2-20 -> 0x22 -> IRQ 20 Mode:1 Active:1 Dest:1)
[    6.915483] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:22 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    6.916724] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    6.917454] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[    7.122323] e1000e 0000:00:19.0 eth0: registered PHC clock
[    7.122746] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:13:20:f9:de:02
[    7.123502] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    7.124110] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    7.124691] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
[    7.125270] igb: Copyright (c) 2007-2014 Intel Corporation.
[    7.125762] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    7.126440] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    7.127298] usbcore: registered new interface driver catc
[    7.127747] usbcore: registered new interface driver kaweth
[    7.128244] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    7.128933] usbcore: registered new interface driver pegasus
[    7.129411] usbcore: registered new interface driver rtl8150
[    7.129982] usbcore: registered new interface driver asix
[    7.130444] usbcore: registered new interface driver cdc_ether
[    7.131006] usbcore: registered new interface driver cdc_eem
[    7.131488] usbcore: registered new interface driver dm9601
[    7.132043] usbcore: registered new interface driver smsc75xx
[    7.132535] usbcore: registered new interface driver smsc95xx
[    7.133078] usbcore: registered new interface driver gl620a
[    7.133537] usbcore: registered new interface driver net1080
[    7.134085] usbcore: registered new interface driver plusb
[    7.134552] usbcore: registered new interface driver rndis_host
[    7.135107] usbcore: registered new interface driver cdc_subset
[    7.135587] usbcore: registered new interface driver zaurus
[    7.136121] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    7.136735] usbcore: registered new interface driver int51x1
[    7.137292] usbcore: registered new interface driver ipheth
[    7.137763] usbcore: registered new interface driver sierra_net
[    7.138546] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.139121] ehci-pci: EHCI PCI platform driver
[    7.140192] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    7.140950] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    7.141536] ehci-pci 0000:00:1a.0: debug port 2
[    7.145946] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    7.146481] ehci-pci 0000:00:1a.0: irq 16, io mem 0xb0270000
[    7.153024] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.153933] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.154422] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.155055] usb usb1: Product: EHCI Host Controller
[    7.155446] usb usb1: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e ehci_hcd
[    7.156122] usb usb1: SerialNumber: 0000:00:1a.0
[    7.157328] hub 1-0:1.0: USB hub found
[    7.157701] hub 1-0:1.0: 2 ports detected
[    7.159709] IOAPIC[0]: Set routing entry (2-23 -> 0x62 -> IRQ 23 Mode:1 Active:1 Dest:1)
[    7.160396] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:62 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    7.161464] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    7.162247] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.162835] ehci-pci 0000:00:1d.0: debug port 2
[    7.167208] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    7.167756] ehci-pci 0000:00:1d.0: irq 23, io mem 0xb0250000
[    7.174067] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    7.174989] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.175488] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.176126] usb usb2: Product: EHCI Host Controller
[    7.176507] usb usb2: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e ehci_hcd
[    7.177164] usb usb2: SerialNumber: 0000:00:1d.0
[    7.178327] hub 2-0:1.0: USB hub found
[    7.178701] hub 2-0:1.0: 2 ports detected
[    7.180105] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.180620] ohci-pci: OHCI PCI platform driver
[    7.181117] uhci_hcd: USB Universal Host Controller Interface driver
[    7.182336] IOAPIC[0]: Set routing entry (2-21 -> 0x82 -> IRQ 21 Mode:1 Active:1 Dest:1)
[    7.183040] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:82 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[    7.184003] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    7.184677] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    7.185545] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    7.186135] xhci_hcd 0000:00:14.0: irq 28 for MSI/MSI-X
[    7.187002] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    7.187471] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.188076] usb usb3: Product: xHCI Host Controller
[    7.188420] usb usb3: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e xhci_hcd
[    7.189043] usb usb3: SerialNumber: 0000:00:14.0
[    7.190181] hub 3-0:1.0: USB hub found
[    7.190534] hub 3-0:1.0: 4 ports detected
[    7.194396] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    7.195067] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    7.196157] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    7.196661] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.197309] usb usb4: Product: xHCI Host Controller
[    7.197691] usb usb4: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e xhci_hcd
[    7.198308] usb usb4: SerialNumber: 0000:00:14.0
[    7.199382] hub 4-0:1.0: USB hub found
[    7.199750] hub 4-0:1.0: 4 ports detected
[    7.203286] usbcore: registered new interface driver usbserial
[    7.203753] usbcore: registered new interface driver usbserial_generic
[    7.204334] usbserial: USB Serial support registered for generic
[    7.204888] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    7.785910] tsc: Refined TSC clocksource calibration: 2195.012 MHz
[    8.263744] i8042: No controller found
[    8.264539] mousedev: PS/2 mouse device common for all mice
[    8.266215] rtc_cmos 00:01: RTC can wake from S4
[    8.267124] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    8.267641] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    8.268415] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    8.268926] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    8.269860] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.270471] iTCO_vendor_support: vendor-support=0
[    8.270871] Intel P-state driver initializing.
[    8.277832] hidraw: raw HID events driver (C) Jiri Kosina
[    8.279340] usbcore: registered new interface driver usbhid
[    8.279794] usbhid: USB HID core driver
[    8.281834] drop_monitor: Initializing network drop monitor service
[    8.282646] TCP: cubic registered
[    8.282970] Initializing XFRM netlink socket
[    8.284757] NET: Registered protocol family 10
[    8.287148] NET: Registered protocol family 17
[    8.287550] 9pnet: Installing 9P2000 support
[    8.298306] 
[    8.298306] printing PIC contents
[    8.298756] ... PIC  IMR: ffff
[    8.299049] ... PIC  IRR: 0c38
[    8.299438] ... PIC  ISR: 0000
[    8.299731] ... PIC ELCR: 0c38
[    8.300092] printing local APIC contents on CPU#0/0:
[    8.300718] ... APIC ID:      00000000 (0)
[    8.301265] ... APIC VERSION: 01060015
[    8.301776] ... APIC TASKPRI: 00000000 (00)
[    8.302318] ... APIC PROCPRI: 00000000
[    8.302823] ... APIC LDR: 00000001
[    8.303300] ... APIC SPIV: 000001ff
[    8.303774] ... APIC ISR field:
[    8.304240] 0000000000000000000000000000000000000000000000000000000000000000
[    8.305749] ... APIC TMR field:
[    8.306213] 0000000000000000000200000002000000020002000000000002000000000000
[    8.307734] ... APIC IRR field:
[    8.308199] 0000000000000000000000000000000000000000000000000000000000000000
[    8.309715] ... APIC ESR: 00000000
[    8.310188] ... APIC ICR: 000008fd
[    8.310660] ... APIC ICR2: 00000040
[    8.311142] ... APIC LVTT: 000400ef
[    8.311628] ... APIC LVTPC: 00000400
[    8.312113] ... APIC LVT0: 00010700
[    8.312590] ... APIC LVT1: 00000400
[    8.313064] ... APIC LVTERR: 000000fe
[    8.313552] ... APIC TMICT: 00000000
[    8.314037] ... APIC TMCCT: 00000000
[    8.314523] ... APIC TDCR: 00000000
[    8.314993] 
[    8.315288] number of MP IRQ sources: 15.
[    8.315637] number of IO-APIC #2 registers: 24.
[    8.316010] testing the IO APIC.......................
[    8.316514] IO APIC #2......
[    8.316789] .... register #00: 02000000
[    8.317204] .......    : physical APIC id: 02
[    8.317568] .......    : Delivery Type: 0
[    8.317912] .......    : LTS          : 0
[    8.318345] .... register #01: 00170020
[    8.318676] .......     : max redirection entries: 17
[    8.319161] .......     : PRQ implemented: 0
[    8.319530] .......     : IO APIC version: 20
[    8.319894] .... IRQ redirection table:
[    8.320318] 0   1    0    0   0   0    0     0    00
[    8.320722] 1   0    0    0   0   0    0     0    01
[    8.321241] 1   0    0    0   0   0    0     0    02
[    8.321646] 1   0    0    0   0   0    0     0    03
[    8.322048] 1   0    0    0   0   0    0     0    04
[    8.322534] 1   0    0    0   0   0    0     0    05
[    8.322939] 1   0    0    0   0   0    0     0    06
[    8.323426] 1   0    0    0   0   0    0     0    07
[    8.323829] 1   0    0    0   0   0    0     0    08
[    8.324316] 1   0    1    0   0   0    0     0    09
[    8.324721] 1   0    0    0   0   0    0     0    0A
[    8.325206] 1   0    0    0   0   0    0     0    0B
[    8.325610] 1   0    0    0   0   0    0     0    0C
[    8.326012] 1   0    0    0   0   0    0     0    0D
[    8.326497] 1   0    0    0   0   0    0     0    0E
[    8.326902] 1   0    0    0   0   0    0     0    0F
[    8.327392] 1   0    1    0   1   0    0     0    10
[    8.327796] 0   1    0    0   0   0    0     0    00
[    8.328279] 1   1    1    0   1   0    0     0    12
[    8.328683] 1   1    1    0   1   0    0     0    13
[    8.329170] 1   1    1    0   1   0    0     0    14
[    8.329575] 1   1    1    0   1   0    0     0    15
[    8.329977] 0   1    0    0   0   0    0     0    00
[    8.330464] 1   0    1    0   1   0    0     0    17
[    8.330865] IRQ to pin mappings:
[    8.331272] IRQ0 -> 0:2
[    8.331635] IRQ1 -> 0:1
[    8.331994] IRQ3 -> 0:3
[    8.332434] IRQ4 -> 0:4
[    8.332793] IRQ5 -> 0:5
[    8.333234] IRQ6 -> 0:6
[    8.333592] IRQ7 -> 0:7
[    8.333953] IRQ8 -> 0:8
[    8.334390] IRQ9 -> 0:9
[    8.334749] IRQ10 -> 0:10
[    8.335198] IRQ11 -> 0:11
[    8.335566] IRQ12 -> 0:12
[    8.335937] IRQ13 -> 0:13
[    8.336390] IRQ14 -> 0:14
[    8.336756] IRQ15 -> 0:15
[    8.337204] IRQ16 -> 0:16
[    8.337576] IRQ18 -> 0:18
[    8.337948] IRQ19 -> 0:19
[    8.338400] IRQ20 -> 0:20
[    8.338771] IRQ21 -> 0:21
[    8.339219] IRQ23 -> 0:23
[    8.339589] .................................... done.
[    8.340818] Loading compiled-in X.509 certificates
[    8.342383] Loaded X.509 cert 'Magrathea: Glacier signing key: 462de22c562fa37bf780a2ffe691bb14115aa05f'
[    8.343266] registered taskstats version 1
[    8.397852] Key type trusted registered
[    8.427709] Key type encrypted registered
[    8.466536] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    8.470594] ima: No TPM chip found, activating TPM-bypass!
[    8.471402] evm: HMAC attrs: 0x1
[    8.475197] rtc_cmos 00:01: setting system clock to 2014-09-27 17:13:52 UTC (1411838032)
[    8.582273] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    8.583026] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.584492] hub 1-1:1.0: USB hub found
[    8.585017] hub 1-1:1.0: 6 ports detected
[    8.604039] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[    8.692668] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    8.705840] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[    8.706629] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    8.787507] Switched to clocksource tsc
[    8.808556] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    8.809127] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.810847] hub 2-1:1.0: USB hub found
[    8.811395] hub 2-1:1.0: 8 ports detected
[    8.894287] usb 1-1.4: new low-speed USB device number 3 using ehci-pci
[    9.066332] usb 1-1.4: New USB device found, idVendor=0557, idProduct=2220
[    9.066820] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    9.067531] usb 1-1.4: Product: ATEN  CS-1758/54
[    9.068012] usb 1-1.4: Manufacturer: ATEN
[    9.105623] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/0003:0557:2220.0001/input/input1
[    9.107399] hid-generic 0003:0557:2220.0001: input,hidraw0: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-1.4/input0
[    9.133273] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.1/0003:0557:2220.0002/input/input2
[    9.135233] hid-generic 0003:0557:2220.0002: input,hidraw1: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-1.4/input1
[   11.545958] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   11.548670] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   11.559682] Sending DHCP requests ..., OK
[   18.404007] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.161
[   18.405190] IP-Config: Complete:
[   18.405489]      device=eth0, hwaddr=00:13:20:f9:de:02, ipaddr=192.168.1.161, mask=255.255.255.0, gw=192.168.1.1
[   18.406344]      host=loslunas, domain=lkp.intel.com, nis-domain=(none)
[   18.406928]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   18.407385]      nameserver0=192.168.1.1
[   18.407985] PM: Hibernation image not present or could not be loaded.
[   18.411932] Freeing unused kernel memory: 1808K (ffffffff81dd3000 - ffffffff81f97000)
[   20.697836] [drm] Initialized drm 1.1.0 20060810
[   20.708963] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   20.728300] ACPI Warning: SystemIO range 0x0000000000002040-0x000000000000205f conflicts with OpRegion 0x0000000000002040-0x000000000000204f (\_SB_.PCI0.SBUS.SMBI) (20140724/utaddress-258)
[   20.729864] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   20.756247] libata version 3.00 loaded.
[   20.757161] [drm:__gen7_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake to ack request.
[   20.760152] [drm:__gen6_gt_wait_for_thread_c0] *ERROR* GT thread status wait timed out
[   20.760836] [drm] No MT forcewake available on Ivybridge, this can result in issues
[   20.761594] [drm] when using vblank-synced partial screen updates.
[   20.762507] [drm] Memory usable by graphics device = 2048M
[   20.762966] [drm] Replacing VGA console driver
[   20.764867] Console: switching to colour dummy device 80x25
[   20.772573] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   20.774730] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[   20.775066] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   20.775602] [drm] Driver supports precise vblank timestamp query.
[   20.776517] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   20.778468] Error: Driver 'pcspkr' is already registered, aborting...
[   20.798325] firewire_ohci 0000:04:00.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[   20.828705] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   20.829307] Raw EDID:
[   20.829461]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.829847]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.830320]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.830671]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.831029]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.831485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.831862]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   20.832345]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.845311] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   20.845807] Raw EDID:
[   20.845956]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.846415]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.846780]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.847137]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.847573]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.847934]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.848381]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   20.848726]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.861855] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   20.862483] Raw EDID:
[   20.862643]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.863008]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.863429]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.863772]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.864118]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.864530]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.864873]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   20.865291]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.878160] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
[   20.878808] Raw EDID:
[   20.878960]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.879403]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.879768]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.880154]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.880627]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.881005]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.881487]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   20.881870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   20.882363] i915 0000:00:02.0: VGA-1: Ignoring invalid EDID block 1.
[   21.123178] fbcon: inteldrmfb (fb0) is primary device
[   21.147969] Console: switching to colour frame buffer device 128x48
[   21.150971] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   21.151381] i915 0000:00:02.0: registered panic notifier
[   21.178576] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   21.180337] acpi device:59: registered as cooling_device13
[   21.181190] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[   21.182239] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
[   21.183956] IOAPIC[0]: Set routing entry (2-22 -> 0x93 -> IRQ 22 Mode:1 Active:1 Dest:1)
[   21.184618] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:93 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
[   21.185720] snd_hda_intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[   21.186379] ahci 0000:00:1f.2: version 3.0
[   21.187908] ahci 0000:00:1f.2: irq 31 for MSI/MSI-X
[   21.198821] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x6 impl SATA mode
[   21.199382] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[   21.206050] scsi host0: ahci
[   21.207307] scsi host1: ahci
[   21.208365] scsi host2: ahci
[   21.209499] scsi host3: ahci
[   21.210875] scsi host4: ahci
[   21.211448] sound hdaudioC0D2: ALC889: SKU not ready 0x598301f0
[   21.212137] scsi host5: ahci
[   21.212613] sound hdaudioC0D2: autoconfig: line_outs=3 (0x14/0x19/0x16/0x0/0x0) type:line
[   21.212794] ata1: DUMMY
[   21.212799] ata2: SATA max UDMA/133 abar m2048@0xb0240000 port 0xb0240180 irq 31
[   21.212803] ata3: SATA max UDMA/133 abar m2048@0xb0240000 port 0xb0240200 irq 31
[   21.212805] ata4: DUMMY
[   21.212807] ata5: DUMMY
[   21.212809] ata6: DUMMY
[   21.220282] sound hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   21.221456] sound hdaudioC0D2:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[   21.222614] sound hdaudioC0D2:    mono: mono_out=0x0
[   21.223718] sound hdaudioC0D2:    dig-out=0x1e/0x0
[   21.224788] sound hdaudioC0D2:    inputs:
[   21.225795] sound hdaudioC0D2:      Front Mic=0x18
[   21.226861] sound hdaudioC0D2:      Rear Mic=0x1b
[   21.227881] sound hdaudioC0D2:      Line=0x1a
[   21.300365] firewire_core 0000:04:00.0: created device fw0: GUID 354fc00035e71a01, S400
[   21.518079] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   21.520056] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   21.522206] ata3.00: ATAPI: ATAPI   iHAS124   B, AL0Q, max UDMA/100
[   21.524427] ata3.00: configured for UDMA/100
[   21.543340] ata2.00: ATA-9: ST1000DM003-1CH162, CC49, max UDMA/133
[   21.544795] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   21.547452] ata2.00: configured for UDMA/133
[   21.549392] scsi 1:0:0:0: Direct-Access     ATA      ST1000DM003-1CH1 CC49 PQ: 0 ANSI: 5
[   21.556650] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS124   B      AL0Q PQ: 0 ANSI: 5
[   21.653275] sr 2:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   21.654749] cdrom: Uniform CD-ROM driver Revision: 3.20
[   21.657214] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   21.657429] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   21.657435] sd 1:0:0:0: [sda] 4096-byte physical blocks
[   21.657964] sd 1:0:0:0: [sda] Write Protect is off
[   21.657967] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   21.658275] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   21.679898]  sda: unknown partition table
[   21.682793] sd 1:0:0:0: [sda] Attached SCSI disk
[   21.685827] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   21.687580] sr 2:0:0:0: Attached scsi generic sg1 type 5
[   23.682691] floppy0: no floppy controllers found
[   24.271150] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[   24.273067] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   24.275016] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   24.276974] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   24.278946] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   24.280956] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   24.283182] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   24.285437] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   24.287567] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   24.289907] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   26.717760] floppy0: no floppy controllers found
[   26.875333] fuse init (API version 7.23)
[   28.110090] device-mapper: uevent: version 1.0.3
[   28.112211] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   28.136443] random: vgscan urandom read with 104 bits of entropy available
[   35.236319] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   35.295317] random: nonblocking pool is initialized
[   46.452544] ipmi message handler version 39.2
[   46.456772] IPMI Watchdog: driver initialized
<6>
[    0.000000] Initializing cgroup subsys cpuset
<6>
[    0.000000] Initializing cgroup subsys cpu
<5>
[    0.000000] Linux version 3.17.0-rc6-wl-ath-00314-g3ec2e1e (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Sat Sep 27 17:08:49 CST 2014
<6>
[    0.000000] Command line: user=lkp job=/lkp/scheduled/loslunas/boot_boot-1-x86_64-rhel-3ec2e1eb7329693596b4732dbf8e022891e38e20-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/vmlinuz-3.17.0-rc6-wl-ath-00314-g3ec2e1e kconfig=x86_64-rhel commit=3ec2e1eb7329693596b4732dbf8e022891e38e20 branch=linux-devel/devel-hourly-2014092716 root=/dev/ram0 disable_mtrr_trim disable_mtrr_trim max_uptime=18000 RESULT_ROOT=/result/loslunas/boot/1/debian-x86_64.cgz/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/0 ip=::::loslunas::dhcp disable_mtrr_trim earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>
[    0.000000] e820: BIOS-provided physical RAM map:
<6>
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009abff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000a9014fff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x00000000a9015000-0x00000000a901afff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000a901b000-0x00000000aa7e9fff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x00000000aa7ea000-0x00000000aad79fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000aad7a000-0x00000000aaff9fff] ACPI NVS
<6>
[    0.000000] BIOS-e820: [mem 0x00000000aaffa000-0x00000000aaffefff] ACPI data
<6>
[    0.000000] BIOS-e820: [mem 0x00000000aafff000-0x00000000aaffffff] usable
<6>
[    0.000000] BIOS-e820: [mem 0x00000000ab000000-0x00000000af9fffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffbfffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x00000000ffd00000-0x00000000ffffffff] reserved
<6>
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000044e5fffff] usable
<6>
[    0.000000] bootconsole [earlyser0] enabled
<6>
[    0.000000] NX (Execute Disable) protection: active
<6>
[    0.000000] SMBIOS 2.6 present.
<7>
[    0.000000] DMI: Intel Corporation 2012 Client Platform/LosLunas CRB, BIOS ACRVMBY1.86C.0054.B00.1107311147 07/31/2011
<7>
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>
[    0.000000] AGP: No AGP bridge found
<6>
[    0.000000] e820: last_pfn = 0x44e600 max_arch_pfn = 0x400000000
<7>
[    0.000000] MTRR default type: uncachable
<7>
[    0.000000] MTRR fixed ranges enabled:
<7>
[    0.000000]   00000-9FFFF write-back
<7>
[    0.000000]   A0000-FFFFF uncachable
<7>
[    0.000000] MTRR variable ranges enabled:
<7>
[    0.000000]   0 base 000000000 mask F80000000 write-back
<7>
[    0.000000]   1 base 080000000 mask FE0000000 write-back
<7>
[    0.000000]   2 base 0A0000000 mask FF8000000 write-back
<7>
[    0.000000]   3 base 0A8000000 mask FFE000000 write-back
<7>
[    0.000000]   4 base 0AA000000 mask FFF000000 write-back
<7>
[    0.000000]   5 base 100000000 mask F00000000 write-back
<7>
[    0.000000]   6 base 200000000 mask E00000000 write-back
<7>
[    0.000000]   7 base 400000000 mask FC0000000 write-back
<7>
[    0.000000]   8 base 440000000 mask FF0000000 write-back
<7>
[    0.000000]   9 base 44E000000 mask FFE000000 uncachable
<6>
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
<6>
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
<6>
[    0.000000] e820: last_pfn = 0xab000 max_arch_pfn = 0x400000000
<4>
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<6>
[    0.000000] found SMP MP-table at [mem 0x000fca70-0x000fca7f] mapped at [ffff8800000fca70]
<4>
[    0.000000]   mpc: fc7c0-fc9f4
<7>
[    0.000000] Base memory trampoline at [ffff880000094000] 94000 size 24576
<6>
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>
[    0.000000] BRK [0x0217a000, 0x0217afff] PGTABLE
<7>
[    0.000000] BRK [0x0217b000, 0x0217bfff] PGTABLE
<7>
[    0.000000] BRK [0x0217c000, 0x0217cfff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x44e400000-0x44e5fffff]
<7>
[    0.000000]  [mem 0x44e400000-0x44e5fffff] page 2M
<7>
[    0.000000] BRK [0x0217d000, 0x0217dfff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x44c000000-0x44e3fffff]
<7>
[    0.000000]  [mem 0x44c000000-0x44e3fffff] page 2M
<6>
[    0.000000] init_memory_mapping: [mem 0x400000000-0x44bffffff]
<7>
[    0.000000]  [mem 0x400000000-0x44bffffff] page 2M
<7>
[    0.000000] BRK [0x0217e000, 0x0217efff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0x00100000-0xa9014fff]
<7>
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>
[    0.000000]  [mem 0x00200000-0xa8ffffff] page 2M
<7>
[    0.000000]  [mem 0xa9000000-0xa9014fff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0xa901b000-0xaa7e9fff]
<7>
[    0.000000]  [mem 0xa901b000-0xa91fffff] page 4k
<7>
[    0.000000]  [mem 0xa9200000-0xaa5fffff] page 2M
<7>
[    0.000000]  [mem 0xaa600000-0xaa7e9fff] page 4k
<7>
[    0.000000] BRK [0x0217f000, 0x0217ffff] PGTABLE
<6>
[    0.000000] init_memory_mapping: [mem 0xaafff000-0xaaffffff]
<7>
[    0.000000]  [mem 0xaafff000-0xaaffffff] page 4k
<6>
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
<7>
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
<6>
[    0.000000] RAMDISK: [mem 0x78806000-0x7fff2fff]
<6>
[    0.000000] ACPI: Early table checksum verification disabled
<4>
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
<4>
[    0.000000] ACPI: XSDT 0x00000000AAFFDE18 00006C (v01 INTEL  IVB-CPT  06222004 MSFT 00010013)
<4>
[    0.000000] ACPI: FACP 0x00000000AAFE3D98 0000F4 (v04 INTEL  IVB-CPT  06222004 MSFT 00010013)
<4>
[    0.000000] ACPI: DSDT 0x00000000AAFC3018 00F8E9 (v02 INTEL  IVB-CPT  00000000 INTL 20110623)
<4>
[    0.000000] ACPI: FACS 0x00000000AAFF9E40 000040
<4>
[    0.000000] ACPI: APIC 0x00000000AAFFCF18 0000CC (v02 INTEL  IVB-CPT  06222004 MSFT 00010013)
<4>
[    0.000000] ACPI: HPET 0x00000000AAFF8F18 000038 (v01 A M I   PCHHPET 06222004 AMI. 00000003)
<4>
[    0.000000] ACPI: SSDT 0x00000000AAFE5018 0010A8 (v01 TrmRef PtidDevc 00001000 INTL 20110623)
<4>
[    0.000000] ACPI: SSDT 0x00000000AAFE4918 000411 (v01 AMI    PerfTune 00001000 INTL 20110623)
<4>
[    0.000000] ACPI: MCFG 0x00000000AAFF8E98 00003C (v01 INTEL  SNDYBRDG 06222004 MSFT 00000097)
<4>
[    0.000000] ACPI: SSDT 0x00000000AAFF7818 000780 (v01 PmRef  Cpu0Ist  00003000 INTL 20110623)
<4>
[    0.000000] ACPI: SSDT 0x00000000AAFF6018 000A2C (v01 PmRef  CpuPm    00003000 INTL 20110623)
<4>
[    0.000000] ACPI: DMAR 0x00000000AAFE3C18 0000E8 (v01 INTEL  SNB      00000001 INTL 00000001)
<7>
[    0.000000] ACPI: Local APIC address 0xfee00000
<6>
[    0.000000] Setting APIC routing to cluster x2apic.
<6>
[    0.000000] No NUMA configuration found
<6>
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000044e5fffff]
<6>
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x44e5fffff]
<6>
[    0.000000]   NODE_DATA [mem 0x44e5ca000-0x44e5effff]
<7>
[    0.000000]  [ffffea0000000000-ffffea00113fffff] PMD -> [ffff88043dc00000-ffff88044dbfffff] on node 0
<4>
[    0.000000] Zone ranges:
<4>
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<4>
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<4>
[    0.000000]   Normal   [mem 0x100000000-0x44e5fffff]
<4>
[    0.000000] Movable zone start for each node
<4>
[    0.000000] Early memory node ranges
<4>
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
<4>
[    0.000000]   node   0: [mem 0x00100000-0xa9014fff]
<4>
[    0.000000]   node   0: [mem 0xa901b000-0xaa7e9fff]
<4>
[    0.000000]   node   0: [mem 0xaafff000-0xaaffffff]
<4>
[    0.000000]   node   0: [mem 0x100000000-0x44e5fffff]
<7>
[    0.000000] On node 0 totalpages: 4164990
<7>
[    0.000000]   DMA zone: 64 pages used for memmap
<7>
[    0.000000]   DMA zone: 21 pages reserved
<7>
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
<7>
[    0.000000]   DMA32 zone: 10848 pages used for memmap
<7>
[    0.000000]   DMA32 zone: 694245 pages, LIFO batch:31
<7>
[    0.000000]   Normal zone: 54168 pages used for memmap
<7>
[    0.000000]   Normal zone: 3466752 pages, LIFO batch:31
<6>
[    0.000000] Reserving Intel graphics stolen memory at 0xaba00000-0xaf9fffff
<6>
[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>
[    0.000000] ACPI: Local APIC address 0xfee00000
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x08] disabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x09] disabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0a] disabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0b] disabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0c] disabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0d] disabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0e] disabled)
<6>
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x0f] disabled)
<6>
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
<6>
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
<6>
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
<7>
[    0.000000] ACPI: IRQ0 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
<7>
[    0.000000] ACPI: IRQ9 used by override.
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
<4>
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
<6>
[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
<6>
[    0.000000] smpboot: Allowing 16 CPUs, 8 hotplug CPUs
<4>
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009afff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009ffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xa9015000-0xa901afff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xaa7ea000-0xaad79fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xaad7a000-0xaaff9fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xaaffa000-0xaaffefff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xab000000-0xaf9fffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xafa00000-0xf7ffffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed0ffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed13fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfed14000-0xfed17fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfed18000-0xfed19fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xff8fffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xff900000-0xffbfffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffcfffff]
<6>
[    0.000000] PM: Registered nosave memory: [mem 0xffd00000-0xffffffff]
<6>
[    0.000000] e820: [mem 0xafa00000-0xf7ffffff] available for PCI devices
<6>
[    0.000000] Booting paravirtualized kernel on bare hardware
<6>
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:16 nr_cpu_ids:16 nr_node_ids:1
<6>
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88044e200000 s88960 r8192 d21632 u131072
<7>
[    0.000000] pcpu-alloc: s88960 r8192 d21632 u131072 alloc=1*2097152
<7>
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
<4>
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4099889
<4>
[    0.000000] Policy zone: Normal
<5>
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/loslunas/boot_boot-1-x86_64-rhel-3ec2e1eb7329693596b4732dbf8e022891e38e20-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/vmlinuz-3.17.0-rc6-wl-ath-00314-g3ec2e1e kconfig=x86_64-rhel commit=3ec2e1eb7329693596b4732dbf8e022891e38e20 branch=linux-devel/devel-hourly-2014092716 root=/dev/ram0 disable_mtrr_trim disable_mtrr_trim max_uptime=18000 RESULT_ROOT=/result/loslunas/boot/1/debian-x86_64.cgz/x86_64-rhel/3ec2e1eb7329693596b4732dbf8e022891e38e20/0 ip=::::loslunas::dhcp disable_mtrr_trim earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>
[    0.000000] sysrq: sysrq always enabled.
<6>
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
<6>
[    0.000000] AGP: Checking aperture...
<6>
[    0.000000] AGP: No AGP bridge found
<4>
[    0.000000] Memory: 16188624K/16659960K available (8595K kernel code, 1704K rwdata, 3836K rodata, 1808K init, 1888K bss, 471336K reserved)
<6>
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
<6>
[    0.000000] Hierarchical RCU implementation.
<6>
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=16.
<6>
[    0.000000] 	Offload RCU callbacks from all CPUs
<6>
[    0.000000] 	Offload RCU callbacks from CPUs: 0-15.
<6>
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=16
<6>
[    0.000000] NR_IRQS:524544 nr_irqs:552 0
<6>
[    0.000000] Console: colour VGA+ 80x25
<6>
[    0.000000] console [tty0] enabled
<6>
[    0.000000] bootconsole [earlyser0] disabled
<6>
[    0.000000] console [ttyS0] enabled
<6>
[    0.000000] allocated 67108864 bytes of page_cgroup
<6>
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
<7>
[    0.000000] hpet clockevent registered
<6>
[    0.000000] tsc: Fast TSC calibration using PIT
<6>
[    0.000000] tsc: Detected 2195.063 MHz processor
<6>
[    0.000084] Calibrating delay loop (skipped), value calculated using timer frequency.. 4390.12 BogoMIPS (lpj=2195063)
<6>
[    0.000835] pid_max: default: 32768 minimum: 301
<6>
[    0.001205] ACPI: Core revision 20140724
<4>
[    0.070877] ACPI: All ACPI Tables successfully acquired
<6>
[    0.071557] Security Framework initialized
<6>
[    0.071865] SELinux:  Initializing.
<7>
[    0.072142] SELinux:  Starting in permissive mode
<6>
[    0.106155] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
<6>
[    0.127077] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<6>
[    0.129899] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
<6>
[    0.130914] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
<6>
[    0.132338] Initializing cgroup subsys memory
<6>
[    0.132704] Initializing cgroup subsys devices
<6>
[    0.133057] Initializing cgroup subsys freezer
<6>
[    0.133408] Initializing cgroup subsys net_cls
<6>
[    0.133759] Initializing cgroup subsys blkio
<6>
[    0.134090] Initializing cgroup subsys perf_event
<6>
[    0.134463] Initializing cgroup subsys hugetlb
<6>
[    0.134861] CPU: Physical Processor ID: 0
<6>
[    0.135181] CPU: Processor Core ID: 0
<6>
[    0.135846] mce: CPU supports 9 MCE banks
<7>
[    0.136168] CPU0: Thermal LVT vector (0xfa) already installed
<6>
[    0.136599] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
<6>
[    0.136599] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>
[    0.137545] Freeing SMP alternatives memory: 36K (ffffffff81f97000 - ffffffff81fa0000)
<6>
[    0.139416] ftrace: allocating 31123 entries in 122 pages
<4>
[    0.186653] Getting VERSION: 1060015
<4>
[    0.186971] Getting VERSION: 1060015
<4>
[    0.187284] Getting ID: 0
<4>
[    0.187541] Getting ID: 0
<6>
[    0.187834] dmar: Host address width 36
<6>
[    0.188155] dmar: DRHD base: 0x000000fed90000 flags: 0x0
<6>
[    0.188603] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
<6>
[    0.189218] dmar: DRHD base: 0x000000fed91000 flags: 0x1
<6>
[    0.189663] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
<6>
[    0.190277] dmar: RMRR base: 0x000000aacb7000 end: 0x000000aaccdfff
<6>
[    0.190741] dmar: RMRR base: 0x000000ab800000 end: 0x000000af9fffff
<6>
[    0.191296] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
<6>
[    0.191720] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.192095] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.192464] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.192841] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.193218] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.193595] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.193963] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.194331] HPET id 0 under DRHD base 0xfed91000
<6>
[    0.194710] Queued invalidation will be enabled to support x2apic and Intr-remapping.
<6>
[    0.195632] Enabled IRQ remapping in x2apic mode
<4>
[    0.196010] masked ExtINT on CPU#0
<4>
[    0.196627] ENABLING IO-APIC IRQs
<7>
[    0.196922] init IO_APIC IRQs
<7>
[    0.197200]  apic 2 pin 0 not connected
<7>
[    0.197526] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>
[    0.198151] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.199084] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>
[    0.199707] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.200642] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>
[    0.201248] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.202254] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>
[    0.202921] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.203946] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>
[    0.204614] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.205605] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>
[    0.206212] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.207235] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>
[    0.207903] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.208921] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>
[    0.209600] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.210623] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>
[    0.211247] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.212271] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>
[    0.212938] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.213931] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>
[    0.214625] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.215648] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>
[    0.216267] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.217262] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>
[    0.217957] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.218976] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>
[    0.219654] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.220647] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>
[    0.221263] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.222258] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>
[    0.222952] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.223942]  apic 2 pin 16 not connected
<7>
[    0.224278]  apic 2 pin 17 not connected
<7>
[    0.224667]  apic 2 pin 18 not connected
<7>
[    0.224995]  apic 2 pin 19 not connected
<7>
[    0.225384]  apic 2 pin 20 not connected
<7>
[    0.225721]  apic 2 pin 21 not connected
<7>
[    0.226058]  apic 2 pin 22 not connected
<7>
[    0.226454]  apic 2 pin 23 not connected
<6>
[    0.226929] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>
[    0.237466] smpboot: CPU0: Genuine Intel(R) CPU  @ 2.20GHz (fam: 06, model: 3a, stepping: 04)
<7>
[    0.238298] TSC deadline timer enabled
<6>
[    0.238710] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
<6>
[    0.239814] ... version:                3
<6>
[    0.240148] ... bit width:              48
<6>
[    0.240484] ... generic registers:      4
<6>
[    0.240871] ... value mask:             0000ffffffffffff
<6>
[    0.241288] ... max period:             0000ffffffffffff
<6>
[    0.241696] ... fixed-purpose events:   3
<6>
[    0.242091] ... event mask:             000000070000000f
<6>
[    0.256118] x86: Booting SMP configuration:
<6>
[    0.256464] .... node  #0, CPUs:        #1
<4>
[    0.268436] masked ExtINT on CPU#1
<7>
[    0.269122] CPU1: Thermal LVT vector (0xfa) already installed
<6>
[    0.272242] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>
[    0.274029]   #2
<4>
[    0.285477] masked ExtINT on CPU#2
<7>
[    0.286162] CPU2: Thermal LVT vector (0xfa) already installed
<4>
[    0.289849]   #3
<4>
[    0.301168] masked ExtINT on CPU#3
<7>
[    0.301848] CPU3: Thermal LVT vector (0xfa) already installed
<4>
[    0.305582]   #4
<4>
[    0.316861] masked ExtINT on CPU#4
<7>
[    0.317567] CPU4: Thermal LVT vector (0xfa) already installed
<4>
[    0.321355]   #5
<4>
[    0.332665] masked ExtINT on CPU#5
<7>
[    0.333373] CPU5: Thermal LVT vector (0xfa) already installed
<4>
[    0.337112]   #6
<4>
[    0.348438] masked ExtINT on CPU#6
<7>
[    0.349152] CPU6: Thermal LVT vector (0xfa) already installed
<4>
[    0.352921]   #7
<4>
[    0.364214] masked ExtINT on CPU#7
<7>
[    0.364931] CPU7: Thermal LVT vector (0xfa) already installed
<6>
[    0.367581] x86: Booted up 1 node, 8 CPUs
<6>
[    0.367929] smpboot: Total of 8 processors activated (35121.00 BogoMIPS)
<6>
[    0.379306] devtmpfs: initialized
<6>
[    0.403503] evm: security.selinux
<6>
[    0.403796] evm: security.ima
<6>
[    0.404070] evm: security.capability
<6>
[    0.412034] PM: Registering ACPI NVS region [mem 0xaad7a000-0xaaff9fff] (2621440 bytes)
<6>
[    0.419598] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>
[    0.420779] NET: Registered protocol family 16
<6>
[    0.429133] cpuidle: using governor menu
<6>
[    0.437027] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>
[    0.437629] ACPI: bus type PCI registered
<6>
[    0.437976] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>
[    0.438969] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
<6>
[    0.439737] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
<6>
[    0.440637] PCI: Using configuration type 1 for base access
<6>
[    0.469558] ACPI: Added _OSI(Module Device)
<6>
[    0.469909] ACPI: Added _OSI(Processor Device)
<6>
[    0.470275] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>
[    0.470742] ACPI: Added _OSI(Processor Aggregator Device)
<7>
[    0.483267] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>
[    0.483889] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<4>
[    0.498696] ACPI: Executed 1 blocks of module-level executable AML code
<4>
[    0.535579] ACPI: Dynamic OEM Table Load:
<4>
[    0.536047] ACPI: SSDT 0xFFFF880437749000 00093B (v01 PmRef  Cpu0Cst  00003001 INTL 20110623)
<4>
[    0.544174] ACPI: Dynamic OEM Table Load:
<4>
[    0.544719] ACPI: SSDT 0xFFFF8804376DE000 000303 (v01 PmRef  ApIst    00003000 INTL 20110623)
<4>
[    0.552446] ACPI: Dynamic OEM Table Load:
<4>
[    0.552917] ACPI: SSDT 0xFFFF88043771F000 000119 (v01 PmRef  ApCst    00003000 INTL 20110623)
<6>
[    0.570689] ACPI: Interpreter enabled
<4>
[    0.571029] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
<6>
[    0.571937] ACPI: (supports S0 S1 S3 S4 S5)
<6>
[    0.572288] ACPI: Using IOAPIC for interrupt routing
<6>
[    0.574206] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>
[    0.611656] acpi ABCDEFGH:00: ACPI dock station (docks/bays count: 1)
<6>
[    0.646704] ACPI: Power Resource [FN00] (off)
<6>
[    0.647666] ACPI: Power Resource [FN01] (off)
<6>
[    0.648644] ACPI: Power Resource [FN02] (on)
<6>
[    0.649678] ACPI: Power Resource [FN03] (on)
<6>
[    0.650726] ACPI: Power Resource [FN04] (on)
<6>
[    0.655481] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
<6>
[    0.655964] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<7>
[    0.657021] \_SB_.PCI0:_OSC invalid UUID
<7>
[    0.657360] _OSC request data:1 1f 0 
<6>
[    0.657962] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
<6>
[    0.663562] PCI host bridge to bus 0000:00
<6>
[    0.663909] pci_bus 0000:00: root bus resource [bus 00-3e]
<6>
[    0.664401] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
<6>
[    0.664874] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>
[    0.665352] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>
[    0.665908] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
<6>
[    0.666433] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
<6>
[    0.667004] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
<6>
[    0.667528] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
<6>
[    0.668085] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
<6>
[    0.668603] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
<6>
[    0.669175] pci_bus 0000:00: root bus resource [mem 0xafa00000-0xfeafffff]
<6>
[    0.669693] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
<7>
[    0.670270] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
<7>
[    0.671229] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
<7>
[    0.671767] pci 0000:00:02.0: reg 0x10: [mem 0xafc00000-0xafffffff 64bit]
<7>
[    0.672272] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff 64bit pref]
<7>
[    0.672914] pci 0000:00:02.0: reg 0x20: [io  0x2000-0x203f]
<7>
[    0.674000] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
<7>
[    0.674501] pci 0000:00:14.0: reg 0x10: [mem 0xb02b0000-0xb02bffff 64bit]
<7>
[    0.675214] pci 0000:00:14.0: PME# supported from D3hot D3cold
<6>
[    0.676010] pci 0000:00:14.0: System wakeup disabled by ACPI
<7>
[    0.676743] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
<7>
[    0.677243] pci 0000:00:16.0: reg 0x10: [mem 0xb02a0000-0xb02a000f 64bit]
<7>
[    0.677964] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>
[    0.679026] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
<7>
[    0.679505] pci 0000:00:19.0: reg 0x10: [mem 0xb0200000-0xb021ffff]
<7>
[    0.680057] pci 0000:00:19.0: reg 0x14: [mem 0xb0280000-0xb0280fff]
<7>
[    0.680535] pci 0000:00:19.0: reg 0x18: [io  0x2080-0x209f]
<7>
[    0.681181] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
<6>
[    0.681980] pci 0000:00:19.0: System wakeup disabled by ACPI
<7>
[    0.682699] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
<7>
[    0.683205] pci 0000:00:1a.0: reg 0x10: [mem 0xb0270000-0xb02703ff]
<7>
[    0.683925] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>
[    0.684827] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>
[    0.685510] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
<7>
[    0.686058] pci 0000:00:1b.0: reg 0x10: [mem 0xb0260000-0xb0263fff 64bit]
<7>
[    0.686745] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<6>
[    0.687601] pci 0000:00:1b.0: System wakeup disabled by ACPI
<7>
[    0.688347] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
<7>
[    0.688984] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<6>
[    0.689845] pci 0000:00:1c.0: System wakeup disabled by ACPI
<7>
[    0.690603] pci 0000:00:1c.6: [8086:1e1c] type 01 class 0x060400
<7>
[    0.691250] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
<6>
[    0.692111] pci 0000:00:1c.6: System wakeup disabled by ACPI
<7>
[    0.692878] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
<7>
[    0.693527] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
<6>
[    0.694394] pci 0000:00:1c.7: System wakeup disabled by ACPI
<7>
[    0.695112] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
<7>
[    0.695614] pci 0000:00:1d.0: reg 0x10: [mem 0xb0250000-0xb02503ff]
<7>
[    0.696325] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>
[    0.697233] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>
[    0.697908] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
<6>
[    0.698863] pci 0000:00:1e.0: System wakeup disabled by ACPI
<7>
[    0.699591] pci 0000:00:1f.0: [8086:1e47] type 00 class 0x060100
<7>
[    0.700772] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
<7>
[    0.701279] pci 0000:00:1f.2: reg 0x10: [io  0x20d0-0x20d7]
<7>
[    0.701790] pci 0000:00:1f.2: reg 0x14: [io  0x20c0-0x20c3]
<7>
[    0.702244] pci 0000:00:1f.2: reg 0x18: [io  0x20b0-0x20b7]
<7>
[    0.702697] pci 0000:00:1f.2: reg 0x1c: [io  0x20a0-0x20a3]
<7>
[    0.703207] pci 0000:00:1f.2: reg 0x20: [io  0x2060-0x207f]
<7>
[    0.703653] pci 0000:00:1f.2: reg 0x24: [mem 0xb0240000-0xb02407ff]
<7>
[    0.704298] pci 0000:00:1f.2: PME# supported from D3hot
<7>
[    0.705322] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
<7>
[    0.705811] pci 0000:00:1f.3: reg 0x10: [mem 0xb0230000-0xb02300ff 64bit]
<7>
[    0.706416] pci 0000:00:1f.3: reg 0x20: [io  0x2040-0x205f]
<6>
[    0.707675] pci 0000:00:1c.0: PCI bridge to [bus 01]
<7>
[    0.708397] pci 0000:02:00.0: [8086:0082] type 00 class 0x028000
<7>
[    0.708973] pci 0000:02:00.0: reg 0x10: [mem 0xb0100000-0xb0101fff 64bit]
<7>
[    0.709856] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
<6>
[    0.710439] pci 0000:02:00.0: System wakeup disabled by ACPI
<6>
[    0.714110] pci 0000:00:1c.6: PCI bridge to [bus 02]
<7>
[    0.714530] pci 0000:00:1c.6:   bridge window [mem 0xb0100000-0xb01fffff]
<7>
[    0.715383] pci 0000:03:00.0: [104c:8231] type 01 class 0x060400
<7>
[    0.716142] pci 0000:03:00.0: supports D1 D2
<6>
[    0.716596] pci 0000:03:00.0: System wakeup disabled by ACPI
<6>
[    0.717330] pci 0000:00:1c.7: PCI bridge to [bus 03-04]
<7>
[    0.717763] pci 0000:00:1c.7:   bridge window [mem 0xb0000000-0xb00fffff]
<7>
[    0.718579] pci 0000:04:00.0: [104c:8235] type 00 class 0x0c0010
<7>
[    0.719085] pci 0000:04:00.0: reg 0x10: [mem 0xb0010000-0xb00107ff]
<7>
[    0.719644] pci 0000:04:00.0: reg 0x14: [mem 0xb0000000-0xb0003fff]
<7>
[    0.720293] pci 0000:04:00.0: supports D1 D2
<7>
[    0.720712] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot
<6>
[    0.721516] pci 0000:03:00.0: PCI bridge to [bus 04]
<7>
[    0.721997] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xb00fffff]
<6>
[    0.722756] pci 0000:00:1e.0: PCI bridge to [bus 05] (subtractive decode)
<7>
[    0.723324] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
<7>
[    0.723955] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
<7>
[    0.724621] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
<7>
[    0.725283] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
<7>
[    0.726008] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
<7>
[    0.726663] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
<7>
[    0.727381] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
<7>
[    0.728054] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
<7>
[    0.728759] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
<7>
[    0.729438] pci 0000:00:1e.0:   bridge window [mem 0xafa00000-0xfeafffff] (subtractive decode)
<7>
[    0.730172] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
<7>
[    0.731889] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>
[    0.732583] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<6>
[    0.735641] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<6>
[    0.737372] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>
[    0.739101] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15), disabled.
<6>
[    0.740828] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
<6>
[    0.742491] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
<6>
[    0.744218] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>
[    0.745959] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15), disabled.
<6>
[    0.747674] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
<4>
[    0.750662] ACPI: Enabled 5 GPEs in block 00 to 3F
<6>
[    0.751656] vgaarb: setting as boot device: PCI:0000:00:02.0
<6>
[    0.752106] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>
[    0.752800] vgaarb: loaded
<6>
[    0.753071] vgaarb: bridge control possible 0000:00:02.0
<5>
[    0.754087] SCSI subsystem initialized
<6>
[    0.754565] ACPI: bus type USB registered
<6>
[    0.755089] usbcore: registered new interface driver usbfs
<6>
[    0.755576] usbcore: registered new interface driver hub
<6>
[    0.756277] usbcore: registered new device driver usb
<6>
[    0.756794] pps_core: LinuxPPS API ver. 1 registered
<6>
[    0.757276] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>
[    0.757974] PTP clock support registered
<6>
[    0.759562] PCI: Using ACPI for IRQ routing
<7>
[    0.763846] PCI: pci_cache_line_size set to 64 bytes
<7>
[    0.764378] e820: reserve RAM buffer [mem 0x0009ac00-0x0009ffff]
<7>
[    0.764900] e820: reserve RAM buffer [mem 0xa9015000-0xabffffff]
<7>
[    0.765380] e820: reserve RAM buffer [mem 0xaa7ea000-0xabffffff]
<7>
[    0.765870] e820: reserve RAM buffer [mem 0xab000000-0xabffffff]
<7>
[    0.766389] e820: reserve RAM buffer [mem 0x44e600000-0x44fffffff]
<6>
[    0.767518] NetLabel: Initializing
<6>
[    0.767835] NetLabel:  domain hash size = 128
<6>
[    0.768191] NetLabel:  protocols = UNLABELED CIPSOv4
<6>
[    0.768700] NetLabel:  unlabeled traffic allowed by default
<6>
[    0.776358] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>
[    0.777394] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>
[    0.780321] Switched to clocksource hpet
<6>
[    0.879106] pnp: PnP ACPI init
<6>
[    0.879926] system 00:00: [io  0x0680-0x069f] has been reserved
<6>
[    0.880436] system 00:00: [io  0x1000-0x100f] has been reserved
<6>
[    0.880882] system 00:00: [io  0xffff] has been reserved
<6>
[    0.881379] system 00:00: [io  0xffff] has been reserved
<6>
[    0.881792] system 00:00: [io  0x0400-0x0453] could not be reserved
<6>
[    0.882258] system 00:00: [io  0x0458-0x047f] has been reserved
<6>
[    0.882783] system 00:00: [io  0x0500-0x057f] has been reserved
<6>
[    0.884574] system 00:00: [io  0x164e-0x164f] has been reserved
<7>
[    0.885023] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>
[    0.885643] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>
[    0.886253] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.887453] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>
[    0.888195] system 00:02: [io  0x0454-0x0457] has been reserved
<7>
[    0.888731] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
<6>
[    0.891089] system 00:03: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>
[    0.891673] system 00:03: [mem 0xfed10000-0xfed17fff] could not be reserved
<6>
[    0.892197] system 00:03: [mem 0xfed18000-0xfed18fff] has been reserved
<6>
[    0.892764] system 00:03: [mem 0xfed19000-0xfed19fff] has been reserved
<6>
[    0.893254] system 00:03: [mem 0xf8000000-0xfbffffff] has been reserved
<6>
[    0.893833] system 00:03: [mem 0xfed20000-0xfed3ffff] has been reserved
<6>
[    0.894416] system 00:03: [mem 0xfed90000-0xfed93fff] could not be reserved
<6>
[    0.894941] system 00:03: [mem 0xfed45000-0xfed8ffff] has been reserved
<6>
[    0.895522] system 00:03: [mem 0xff000000-0xffffffff] could not be reserved
<6>
[    0.896052] system 00:03: [mem 0xfee00000-0xfeefffff] could not be reserved
<6>
[    0.896653] system 00:03: [mem 0xafa00000-0xafa00fff] has been reserved
<7>
[    0.897139] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>
[    0.899491] system 00:04: [mem 0x00000000-0x0009cfff] could not be reserved
<7>
[    0.900012] system 00:04: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>
[    0.900858] pnp: PnP ACPI: found 5 devices
<6>
[    0.921238] pci 0000:00:1c.0: PCI bridge to [bus 01]
<6>
[    0.921723] pci 0000:00:1c.6: PCI bridge to [bus 02]
<6>
[    0.922115] pci 0000:00:1c.6:   bridge window [mem 0xb0100000-0xb01fffff]
<6>
[    0.922713] pci 0000:03:00.0: PCI bridge to [bus 04]
<6>
[    0.923109] pci 0000:03:00.0:   bridge window [mem 0xb0000000-0xb00fffff]
<6>
[    0.923713] pci 0000:00:1c.7: PCI bridge to [bus 03-04]
<6>
[    0.924134] pci 0000:00:1c.7:   bridge window [mem 0xb0000000-0xb00fffff]
<6>
[    0.924719] pci 0000:00:1e.0: PCI bridge to [bus 05]
<7>
[    0.925129] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>
[    0.925641] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>
[    0.926073] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>
[    0.926628] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
<7>
[    0.927100] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
<7>
[    0.927653] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
<7>
[    0.928115] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
<7>
[    0.928660] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
<7>
[    0.929137] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
<7>
[    0.929681] pci_bus 0000:00: resource 13 [mem 0xafa00000-0xfeafffff]
<7>
[    0.930149] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
<7>
[    0.930695] pci_bus 0000:02: resource 1 [mem 0xb0100000-0xb01fffff]
<7>
[    0.931171] pci_bus 0000:03: resource 1 [mem 0xb0000000-0xb00fffff]
<7>
[    0.931725] pci_bus 0000:04: resource 1 [mem 0xb0000000-0xb00fffff]
<7>
[    0.932188] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
<7>
[    0.932698] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
<7>
[    0.933133] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
<7>
[    0.933681] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000d3fff]
<7>
[    0.934144] pci_bus 0000:05: resource 8 [mem 0x000d4000-0x000d7fff]
<7>
[    0.934686] pci_bus 0000:05: resource 9 [mem 0x000d8000-0x000dbfff]
<7>
[    0.935150] pci_bus 0000:05: resource 10 [mem 0x000dc000-0x000dffff]
<7>
[    0.935709] pci_bus 0000:05: resource 11 [mem 0x000e0000-0x000e3fff]
<7>
[    0.936187] pci_bus 0000:05: resource 12 [mem 0x000e4000-0x000e7fff]
<7>
[    0.936746] pci_bus 0000:05: resource 13 [mem 0xafa00000-0xfeafffff]
<7>
[    0.937216] pci_bus 0000:05: resource 14 [mem 0xfed40000-0xfed44fff]
<6>
[    0.937956] NET: Registered protocol family 2
<6>
[    0.946838] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
<6>
[    0.949948] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>
[    0.950631] TCP: Hash tables configured (established 131072 bind 65536)
<6>
[    0.951308] TCP: reno registered
<6>
[    0.952249] UDP hash table entries: 8192 (order: 6, 262144 bytes)
<6>
[    0.953347] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
<6>
[    0.955699] NET: Registered protocol family 1
<6>
[    0.957038] RPC: Registered named UNIX socket transport module.
<6>
[    0.957597] RPC: Registered udp transport module.
<6>
[    0.957977] RPC: Registered tcp transport module.
<6>
[    0.958356] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>
[    0.958965] pci 0000:00:02.0: Video device with shadowed ROM
<7>
[    0.960064] IOAPIC[0]: Set routing entry (2-21 -> 0x71 -> IRQ 21 Mode:1 Active:1 Dest:1)
<7>
[    0.960782] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:71 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.963073] IOAPIC[0]: Set routing entry (2-16 -> 0x81 -> IRQ 16 Mode:1 Active:1 Dest:1)
<7>
[    0.963849] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:81 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    0.966115] IOAPIC[0]: Set routing entry (2-23 -> 0x91 -> IRQ 23 Mode:1 Active:1 Dest:1)
<7>
[    0.966771] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<4>
[    0.968364] pci 0000:03:00.0: TI XIO2000a quirk detected; secondary bus fast back-to-back transfers disabled
<7>
[    0.969188] PCI: CLS 64 bytes, default 64
<6>
[    0.969902] Unpacking initramfs...
<6>
[    6.772146] Freeing initrd memory: 122804K (ffff880078806000 - ffff88007fff3000)
<6>
[    6.772859] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>
[    6.773342] software IO TLB [mem 0xa5015000-0xa9015000] (64MB) mapped at [ffff8800a5015000-ffff8800a9014fff]
<4>
[    6.784010] resource sanity check: requesting [mem 0xfed10000-0xfed15fff], which spans more than reserved [mem 0xfed10000-0xfed13fff]
<4>
[    6.784951] ------------[ cut here ]------------
<4>
[    6.785331] WARNING: CPU: 3 PID: 1 at arch/x86/mm/ioremap.c:183 __ioremap_caller+0x24c/0x2d0()
<6>
[    6.786149] Info: mapping multiple BARs. Your kernel is fine.
<4>
[    6.786601] Modules linked in:
<4>
[    6.787046] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc6-wl-ath-00314-g3ec2e1e #1
<4>
[    6.787755] Hardware name: Intel Corporation 2012 Client Platform/LosLunas CRB, BIOS ACRVMBY1.86C.0054.B00.1107311147 07/31/2011
<4>
[    6.788670]  0000000000000009 ffff880437e0bb00 ffffffff818571f9 ffff880437e0bb48
<4>
[    6.789551]  ffff880437e0bb38 ffffffff8106ef1d ffffc900018d0000 0000000000006000
<4>
[    6.790349]  ffffc900018d0000 ffffc900018d0000 00000000fed10000 ffff880437e0bb98
<4>
[    6.791228] Call Trace:
<4>
[    6.791552]  [<ffffffff818571f9>] dump_stack+0x4d/0x66
<4>
[    6.791961]  [<ffffffff8106ef1d>] warn_slowpath_common+0x7d/0xa0
<4>
[    6.792413]  [<ffffffff8106ef8c>] warn_slowpath_fmt+0x4c/0x50
<4>
[    6.792939]  [<ffffffff8107544f>] ? iomem_map_sanity_check+0xcf/0xe0
<4>
[    6.793425]  [<ffffffff8105b82c>] __ioremap_caller+0x24c/0x2d0
<4>
[    6.793955]  [<ffffffff8105b8c7>] ioremap_nocache+0x17/0x20
<4>
[    6.794394]  [<ffffffff8103504d>] snb_uncore_imc_init_box+0x6d/0x90
<4>
[    6.794951]  [<ffffffff8103341c>] uncore_pci_probe+0xcc/0x1f0
<4>
[    6.795388]  [<ffffffff8142e8b5>] local_pci_probe+0x45/0xa0
<4>
[    6.795902]  [<ffffffff8142fba5>] ? pci_match_device+0xe5/0x110
<4>
[    6.796352]  [<ffffffff8142fce1>] pci_device_probe+0xd1/0x120
<4>
[    6.796864]  [<ffffffff815024c0>] driver_probe_device+0x90/0x3e0
<4>
[    6.797327]  [<ffffffff815028db>] __driver_attach+0x8b/0x90
<4>
[    6.797839]  [<ffffffff81502850>] ? __device_attach+0x40/0x40
<4>
[    6.798287]  [<ffffffff8150038b>] bus_for_each_dev+0x6b/0xb0
<4>
[    6.798796]  [<ffffffff81501f6e>] driver_attach+0x1e/0x20
<4>
[    6.799222]  [<ffffffff81501b60>] bus_add_driver+0x180/0x250
<4>
[    6.799730]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
<4>
[    6.800184]  [<ffffffff815030a4>] driver_register+0x64/0xf0
<4>
[    6.800698]  [<ffffffff8142e14c>] __pci_register_driver+0x4c/0x50
<4>
[    6.801161]  [<ffffffff81df6f19>] intel_uncore_init+0xc7/0x2ae
<4>
[    6.801691]  [<ffffffff81df6e52>] ? uncore_cpu_setup+0x13/0x13
<4>
[    6.802142]  [<ffffffff81002130>] do_one_initcall+0xc0/0x1f0
<4>
[    6.802650]  [<ffffffff8108d900>] ? parse_args+0x1c0/0x4e0
<4>
[    6.803075]  [<ffffffff81dea11b>] kernel_init_freeable+0x1b3/0x23b
<4>
[    6.803628]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
<4>
[    6.804034]  [<ffffffff8184a93e>] kernel_init+0xe/0xf0
<4>
[    6.804433]  [<ffffffff8185fe3c>] ret_from_fork+0x7c/0xb0
<4>
[    6.804928]  [<ffffffff8184a930>] ? rest_init+0x90/0x90
<4>
[    6.805336] ---[ end trace 31a6fa76e4d9f116 ]---
<6>
[    6.808747] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
<6>
[    6.818262] futex hash table entries: 4096 (order: 6, 262144 bytes)
<5>
[    6.818850] Initialise system trusted keyring
<6>
[    6.819286] audit: initializing netlink subsys (disabled)
<5>
[    6.819806] audit: type=2000 audit(1411838030.569:1): initialized
<6>
[    6.822462] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>
[    6.837388] zpool: loaded
<6>
[    6.837727] zbud: loaded
<5>
[    6.838670] VFS: Disk quotas dquot_6.5.2
<4>
[    6.839324] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>
[    6.844397] SGI XFS with ACLs, security attributes, no debug enabled
<6>
[    6.849473] 9p: Installing v9fs 9p2000 file system support
<6>
[    6.850235] msgmni has been set to 31858
<5>
[    6.851011] Key type big_key registered
<7>
[    6.851338] SELinux:  Registering netfilter hooks
<6>
[    6.858099] NET: Registered protocol family 38
<5>
[    6.858486] Key type asymmetric registered
<5>
[    6.858966] Asymmetric key parser 'x509' registered
<6>
[    6.859706] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>
[    6.860917] io scheduler noop registered
<6>
[    6.861266] io scheduler deadline registered (default)
<6>
[    6.861799] io scheduler cfq registered
<7>
[    6.863039] IOAPIC[0]: Set routing entry (2-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:1)
<7>
[    6.863731] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A1 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    6.865406] IOAPIC[0]: Set routing entry (2-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:1)
<7>
[    6.866107] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B1 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[    6.867871] IOAPIC[0]: Set routing entry (2-19 -> 0xc1 -> IRQ 19 Mode:1 Active:1 Dest:1)
<7>
[    6.868489] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C1 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<6>
[    6.869857] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>
[    6.870352] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>
[    6.871141] intel_idle: MWAIT substates: 0x1120
<7>
[    6.872857] intel_idle: v0.4 model 0x3A
<7>
[    6.873179] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>
[    6.876344] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
<6>
[    6.877011] ACPI: Power Button [PWRF]
<6>
[    6.877638] ACPI: Fan [FAN0] (off)
<6>
[    6.878094] ACPI: Fan [FAN1] (off)
<6>
[    6.878533] ACPI: Fan [FAN2] (on)
<6>
[    6.879050] ACPI: Fan [FAN3] (on)
<6>
[    6.879493] ACPI: Fan [FAN4] (on)
<6>
[    6.885867] thermal LNXTHERM:00: registered as thermal_zone0
<6>
[    6.886307] ACPI: Thermal Zone [TZ00] (28 C)
<6>
[    6.888641] thermal LNXTHERM:01: registered as thermal_zone1
<6>
[    6.889079] ACPI: Thermal Zone [TZ01] (30 C)
<6>
[    6.889658] GHES: HEST is not enabled!
<6>
[    6.890432] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>
[    6.894496] Non-volatile memory driver v1.3
<6>
[    6.894974] Linux agpgart interface v0.103
<7>
[    6.897145] mei_me 0000:00:16.0: irq 26 for MSI/MSI-X
<4>
[    6.900225] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20140724/utaddress-258)
<6>
[    6.901860] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    6.902755] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140724/utaddress-258)
<6>
[    6.904113] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    6.904987] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140724/utaddress-258)
<6>
[    6.906225] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    6.907030] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140724/utaddress-258)
<6>
[    6.908268] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>
[    6.909011] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>
[    6.909508] rdac: device handler registered
<6>
[    6.910243] hp_sw: device handler registered
<6>
[    6.910591] emc: device handler registered
<6>
[    6.910988] alua: device handler registered
<6>
[    6.911521] libphy: Fixed MDIO Bus: probed
<6>
[    6.912131] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>
[    6.912757] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>
[    6.913240] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>
[    6.913760] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<7>
[    6.914897] IOAPIC[0]: Set routing entry (2-20 -> 0x22 -> IRQ 20 Mode:1 Active:1 Dest:1)
<7>
[    6.915483] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:22 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<6>
[    6.916724] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
<7>
[    6.917454] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
<6>
[    7.122323] e1000e 0000:00:19.0 eth0: registered PHC clock
<6>
[    7.122746] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:13:20:f9:de:02
<6>
[    7.123502] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
<6>
[    7.124110] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
<6>
[    7.124691] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.13-k
<6>
[    7.125270] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>
[    7.125762] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>
[    7.126440] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>
[    7.127298] usbcore: registered new interface driver catc
<6>
[    7.127747] usbcore: registered new interface driver kaweth
<6>
[    7.128244] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>
[    7.128933] usbcore: registered new interface driver pegasus
<6>
[    7.129411] usbcore: registered new interface driver rtl8150
<6>
[    7.129982] usbcore: registered new interface driver asix
<6>
[    7.130444] usbcore: registered new interface driver cdc_ether
<6>
[    7.131006] usbcore: registered new interface driver cdc_eem
<6>
[    7.131488] usbcore: registered new interface driver dm9601
<6>
[    7.132043] usbcore: registered new interface driver smsc75xx
<6>
[    7.132535] usbcore: registered new interface driver smsc95xx
<6>
[    7.133078] usbcore: registered new interface driver gl620a
<6>
[    7.133537] usbcore: registered new interface driver net1080
<6>
[    7.134085] usbcore: registered new interface driver plusb
<6>
[    7.134552] usbcore: registered new interface driver rndis_host
<6>
[    7.135107] usbcore: registered new interface driver cdc_subset
<6>
[    7.135587] usbcore: registered new interface driver zaurus
<6>
[    7.136121] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>
[    7.136735] usbcore: registered new interface driver int51x1
<6>
[    7.137292] usbcore: registered new interface driver ipheth
<6>
[    7.137763] usbcore: registered new interface driver sierra_net
<6>
[    7.138546] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>
[    7.139121] ehci-pci: EHCI PCI platform driver
<6>
[    7.140192] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>
[    7.140950] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
<6>
[    7.141536] ehci-pci 0000:00:1a.0: debug port 2
<7>
[    7.145946] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>
[    7.146481] ehci-pci 0000:00:1a.0: irq 16, io mem 0xb0270000
<6>
[    7.153024] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>
[    7.153933] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>
[    7.154422] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    7.155055] usb usb1: Product: EHCI Host Controller
<6>
[    7.155446] usb usb1: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e ehci_hcd
<6>
[    7.156122] usb usb1: SerialNumber: 0000:00:1a.0
<6>
[    7.157328] hub 1-0:1.0: USB hub found
<6>
[    7.157701] hub 1-0:1.0: 2 ports detected
<7>
[    7.159709] IOAPIC[0]: Set routing entry (2-23 -> 0x62 -> IRQ 23 Mode:1 Active:1 Dest:1)
<7>
[    7.160396] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:62 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<6>
[    7.161464] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>
[    7.162247] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
<6>
[    7.162835] ehci-pci 0000:00:1d.0: debug port 2
<7>
[    7.167208] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>
[    7.167756] ehci-pci 0000:00:1d.0: irq 23, io mem 0xb0250000
<6>
[    7.174067] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>
[    7.174989] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>
[    7.175488] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    7.176126] usb usb2: Product: EHCI Host Controller
<6>
[    7.176507] usb usb2: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e ehci_hcd
<6>
[    7.177164] usb usb2: SerialNumber: 0000:00:1d.0
<6>
[    7.178327] hub 2-0:1.0: USB hub found
<6>
[    7.178701] hub 2-0:1.0: 2 ports detected
<6>
[    7.180105] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>
[    7.180620] ohci-pci: OHCI PCI platform driver
<6>
[    7.181117] uhci_hcd: USB Universal Host Controller Interface driver
<7>
[    7.182336] IOAPIC[0]: Set routing entry (2-21 -> 0x82 -> IRQ 21 Mode:1 Active:1 Dest:1)
<7>
[    7.183040] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:82 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<6>
[    7.184003] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>
[    7.184677] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
<7>
[    7.185545] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
<7>
[    7.186135] xhci_hcd 0000:00:14.0: irq 28 for MSI/MSI-X
<6>
[    7.187002] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
<6>
[    7.187471] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    7.188076] usb usb3: Product: xHCI Host Controller
<6>
[    7.188420] usb usb3: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e xhci_hcd
<6>
[    7.189043] usb usb3: SerialNumber: 0000:00:14.0
<6>
[    7.190181] hub 3-0:1.0: USB hub found
<6>
[    7.190534] hub 3-0:1.0: 4 ports detected
<6>
[    7.194396] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>
[    7.195067] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
<6>
[    7.196157] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
<6>
[    7.196661] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>
[    7.197309] usb usb4: Product: xHCI Host Controller
<6>
[    7.197691] usb usb4: Manufacturer: Linux 3.17.0-rc6-wl-ath-00314-g3ec2e1e xhci_hcd
<6>
[    7.198308] usb usb4: SerialNumber: 0000:00:14.0
<6>
[    7.199382] hub 4-0:1.0: USB hub found
<6>
[    7.199750] hub 4-0:1.0: 4 ports detected
<6>
[    7.203286] usbcore: registered new interface driver usbserial
<6>
[    7.203753] usbcore: registered new interface driver usbserial_generic
<6>
[    7.204334] usbserial: USB Serial support registered for generic
<6>
[    7.204888] i8042: PNP: No PS/2 controller found. Probing ports directly.
<6>
[    7.785910] tsc: Refined TSC clocksource calibration: 2195.012 MHz
<3>
[    8.263744] i8042: No controller found
<6>
[    8.264539] mousedev: PS/2 mouse device common for all mice
<6>
[    8.266215] rtc_cmos 00:01: RTC can wake from S4
<6>
[    8.267124] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
<6>
[    8.267641] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
<6>
[    8.268415] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>
[    8.268926] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
<6>
[    8.269860] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
<6>
[    8.270471] iTCO_vendor_support: vendor-support=0
<6>
[    8.270871] Intel P-state driver initializing.
<6>
[    8.277832] hidraw: raw HID events driver (C) Jiri Kosina
<6>
[    8.279340] usbcore: registered new interface driver usbhid
<6>
[    8.279794] usbhid: USB HID core driver
<6>
[    8.281834] drop_monitor: Initializing network drop monitor service
<6>
[    8.282646] TCP: cubic registered
<6>
[    8.282970] Initializing XFRM netlink socket
<6>
[    8.284757] NET: Registered protocol family 10
<6>
[    8.287148] NET: Registered protocol family 17
<6>
[    8.287550] 9pnet: Installing 9P2000 support
<7>
[    8.298306] 
<7>
[    8.298306] printing PIC contents
<7>
[    8.298756] ... PIC  IMR: ffff
<7>
[    8.299049] ... PIC  IRR: 0c38
<7>
[    8.299438] ... PIC  ISR: 0000
<7>
[    8.299731] ... PIC ELCR: 0c38
<7>
[    8.300092] printing local APIC contents on CPU#0/0:
<6>
[    8.300718] ... APIC ID:      00000000 (0)
<6>
[    8.301265] ... APIC VERSION: 01060015
<7>
[    8.301776] ... APIC TASKPRI: 00000000 (00)
<7>
[    8.302318] ... APIC PROCPRI: 00000000
<7>
[    8.302823] ... APIC LDR: 00000001
<7>
[    8.303300] ... APIC SPIV: 000001ff
<7>
[    8.303774] ... APIC ISR field:
<4>
[    8.304240] 0000000000000000000000000000000000000000000000000000000000000000
<7>
[    8.305749] ... APIC TMR field:
<4>
[    8.306213] 0000000000000000000200000002000000020002000000000002000000000000
<7>
[    8.307734] ... APIC IRR field:
<4>
[    8.308199] 0000000000000000000000000000000000000000000000000000000000000000
<7>
[    8.309715] ... APIC ESR: 00000000
<7>
[    8.310188] ... APIC ICR: 000008fd
<7>
[    8.310660] ... APIC ICR2: 00000040
<7>
[    8.311142] ... APIC LVTT: 000400ef
<7>
[    8.311628] ... APIC LVTPC: 00000400
<7>
[    8.312113] ... APIC LVT0: 00010700
<7>
[    8.312590] ... APIC LVT1: 00000400
<7>
[    8.313064] ... APIC LVTERR: 000000fe
<7>
[    8.313552] ... APIC TMICT: 00000000
<7>
[    8.314037] ... APIC TMCCT: 00000000
<7>
[    8.314523] ... APIC TDCR: 00000000
<4>
[    8.314993] 
<7>
[    8.315288] number of MP IRQ sources: 15.
<7>
[    8.315637] number of IO-APIC #2 registers: 24.
<6>
[    8.316010] testing the IO APIC.......................
<7>
[    8.316514] IO APIC #2......
<7>
[    8.316789] .... register #00: 02000000
<7>
[    8.317204] .......    : physical APIC id: 02
<7>
[    8.317568] .......    : Delivery Type: 0
<7>
[    8.317912] .......    : LTS          : 0
<7>
[    8.318345] .... register #01: 00170020
<7>
[    8.318676] .......     : max redirection entries: 17
<7>
[    8.319161] .......     : PRQ implemented: 0
<7>
[    8.319530] .......     : IO APIC version: 20
<7>
[    8.319894] .... IRQ redirection table:
<4>
[    8.320318] 0   1    0    0   0   0    0     0    00
<4>
[    8.320722] 1   0    0    0   0   0    0     0    01
<4>
[    8.321241] 1   0    0    0   0   0    0     0    02
<4>
[    8.321646] 1   0    0    0   0   0    0     0    03
<4>
[    8.322048] 1   0    0    0   0   0    0     0    04
<4>
[    8.322534] 1   0    0    0   0   0    0     0    05
<4>
[    8.322939] 1   0    0    0   0   0    0     0    06
<4>
[    8.323426] 1   0    0    0   0   0    0     0    07
<4>
[    8.323829] 1   0    0    0   0   0    0     0    08
<4>
[    8.324316] 1   0    1    0   0   0    0     0    09
<4>
[    8.324721] 1   0    0    0   0   0    0     0    0A
<4>
[    8.325206] 1   0    0    0   0   0    0     0    0B
<4>
[    8.325610] 1   0    0    0   0   0    0     0    0C
<4>
[    8.326012] 1   0    0    0   0   0    0     0    0D
<4>
[    8.326497] 1   0    0    0   0   0    0     0    0E
<4>
[    8.326902] 1   0    0    0   0   0    0     0    0F
<4>
[    8.327392] 1   0    1    0   1   0    0     0    10
<4>
[    8.327796] 0   1    0    0   0   0    0     0    00
<4>
[    8.328279] 1   1    1    0   1   0    0     0    12
<4>
[    8.328683] 1   1    1    0   1   0    0     0    13
<4>
[    8.329170] 1   1    1    0   1   0    0     0    14
<4>
[    8.329575] 1   1    1    0   1   0    0     0    15
<4>
[    8.329977] 0   1    0    0   0   0    0     0    00
<4>
[    8.330464] 1   0    1    0   1   0    0     0    17
<7>
[    8.330865] IRQ to pin mappings:
<7>
[    8.331272] IRQ0 -> 0:2
<7>
[    8.331635] IRQ1 -> 0:1
<7>
[    8.331994] IRQ3 -> 0:3
<7>
[    8.332434] IRQ4 -> 0:4
<7>
[    8.332793] IRQ5 -> 0:5
<7>
[    8.333234] IRQ6 -> 0:6
<7>
[    8.333592] IRQ7 -> 0:7
<7>
[    8.333953] IRQ8 -> 0:8
<7>
[    8.334390] IRQ9 -> 0:9
<7>
[    8.334749] IRQ10 -> 0:10
<7>
[    8.335198] IRQ11 -> 0:11
<7>
[    8.335566] IRQ12 -> 0:12
<7>
[    8.335937] IRQ13 -> 0:13
<7>
[    8.336390] IRQ14 -> 0:14
<7>
[    8.336756] IRQ15 -> 0:15
<7>
[    8.337204] IRQ16 -> 0:16
<7>
[    8.337576] IRQ18 -> 0:18
<7>
[    8.337948] IRQ19 -> 0:19
<7>
[    8.338400] IRQ20 -> 0:20
<7>
[    8.338771] IRQ21 -> 0:21
<7>
[    8.339219] IRQ23 -> 0:23
<6>
[    8.339589] .................................... done.
<5>
[    8.340818] Loading compiled-in X.509 certificates
<5>
[    8.342383] Loaded X.509 cert 'Magrathea: Glacier signing key: 462de22c562fa37bf780a2ffe691bb14115aa05f'
<6>
[    8.343266] registered taskstats version 1
<5>
[    8.397852] Key type trusted registered
<5>
[    8.427709] Key type encrypted registered
<6>
[    8.466536] usb 1-1: new high-speed USB device number 2 using ehci-pci
<6>
[    8.470594] ima: No TPM chip found, activating TPM-bypass!
<6>
[    8.471402] evm: HMAC attrs: 0x1
<6>
[    8.475197] rtc_cmos 00:01: setting system clock to 2014-09-27 17:13:52 UTC (1411838032)
<6>
[    8.582273] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
<6>
[    8.583026] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>
[    8.584492] hub 1-1:1.0: USB hub found
<6>
[    8.585017] hub 1-1:1.0: 6 ports detected
<7>
[    8.604039] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
<6>
[    8.692668] usb 2-1: new high-speed USB device number 2 using ehci-pci
<7>
[    8.705840] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
<6>
[    8.706629] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>
[    8.787507] Switched to clocksource tsc
<6>
[    8.808556] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
<6>
[    8.809127] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>
[    8.810847] hub 2-1:1.0: USB hub found
<6>
[    8.811395] hub 2-1:1.0: 8 ports detected
<6>
[    8.894287] usb 1-1.4: new low-speed USB device number 3 using ehci-pci
<6>
[    9.066332] usb 1-1.4: New USB device found, idVendor=0557, idProduct=2220
<6>
[    9.066820] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>
[    9.067531] usb 1-1.4: Product: ATEN  CS-1758/54
<6>
[    9.068012] usb 1-1.4: Manufacturer: ATEN
<6>
[    9.105623] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/0003:0557:2220.0001/input/input1
<6>
[    9.107399] hid-generic 0003:0557:2220.0001: input,hidraw0: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-1.4/input0
<6>
[    9.133273] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.1/0003:0557:2220.0002/input/input2
<6>
[    9.135233] hid-generic 0003:0557:2220.0002: input,hidraw1: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-1.4/input1
<6>
[   11.545958] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
<6>
[   11.548670] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>
[   11.559682] Sending DHCP requests ..., OK
<4>
[   18.404007] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.161
<6>
[   18.405190] IP-Config: Complete:
<6>
[   18.405489]      device=eth0, hwaddr=00:13:20:f9:de:02, ipaddr=192.168.1.161, mask=255.255.255.0, gw=192.168.1.1
<6>
[   18.406344]      host=loslunas, domain=lkp.intel.com, nis-domain=(none)
<6>
[   18.406928]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>
[   18.407385]      nameserver0=192.168.1.1
<7>
[   18.407985] PM: Hibernation image not present or could not be loaded.
<6>
[   18.411932] Freeing unused kernel memory: 1808K (ffffffff81dd3000 - ffffffff81f97000)
<6>
[   20.697836] [drm] Initialized drm 1.1.0 20060810
<6>
[   20.708963] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
<4>
[   20.728300] ACPI Warning: SystemIO range 0x0000000000002040-0x000000000000205f conflicts with OpRegion 0x0000000000002040-0x000000000000204f (\_SB_.PCI0.SBUS.SMBI) (20140724/utaddress-258)
<6>
[   20.729864] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<7>
[   20.756247] libata version 3.00 loaded.
<3>
[   20.757161] [drm:__gen7_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake to ack request.
<3>
[   20.760152] [drm:__gen6_gt_wait_for_thread_c0] *ERROR* GT thread status wait timed out
<6>
[   20.760836] [drm] No MT forcewake available on Ivybridge, this can result in issues
<6>
[   20.761594] [drm] when using vblank-synced partial screen updates.
<6>
[   20.762507] [drm] Memory usable by graphics device = 2048M
<6>
[   20.762966] [drm] Replacing VGA console driver
<6>
[   20.764867] Console: switching to colour dummy device 80x25
<6>
[   20.772573] input: PC Speaker as /devices/platform/pcspkr/input/input3
<7>
[   20.774730] i915 0000:00:02.0: irq 29 for MSI/MSI-X
<6>
[   20.775066] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>
[   20.775602] [drm] Driver supports precise vblank timestamp query.
<6>
[   20.776517] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<3>
[   20.778468] Error: Driver 'pcspkr' is already registered, aborting...
<5>
[   20.798325] firewire_ohci 0000:04:00.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
<3>
[   20.828705] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>
[   20.829307] Raw EDID:
<3>
[   20.829461]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.829847]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.830320]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.830671]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.831029]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.831485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.831862]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>
[   20.832345]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.845311] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>
[   20.845807] Raw EDID:
<3>
[   20.845956]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.846415]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.846780]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.847137]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.847573]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.847934]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.848381]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>
[   20.848726]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.861855] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>
[   20.862483] Raw EDID:
<3>
[   20.862643]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.863008]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.863429]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.863772]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.864118]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.864530]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.864873]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>
[   20.865291]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.878160] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 193
<3>
[   20.878808] Raw EDID:
<3>
[   20.878960]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.879403]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.879768]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.880154]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.880627]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.881005]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<3>
[   20.881487]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
<3>
[   20.881870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
<4>
[   20.882363] i915 0000:00:02.0: VGA-1: Ignoring invalid EDID block 1.
<6>
[   21.123178] fbcon: inteldrmfb (fb0) is primary device
<6>
[   21.147969] Console: switching to colour frame buffer device 128x48
<6>
[   21.150971] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>
[   21.151381] i915 0000:00:02.0: registered panic notifier
<6>
[   21.178576] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
<6>
[   21.180337] acpi device:59: registered as cooling_device13
<6>
[   21.181190] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
<6>
[   21.182239] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
<7>
[   21.183956] IOAPIC[0]: Set routing entry (2-22 -> 0x93 -> IRQ 22 Mode:1 Active:1 Dest:1)
<7>
[   21.184618] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:93 Dest:00000001 SID:F0F8 SQ:0 SVT:1)
<7>
[   21.185720] snd_hda_intel 0000:00:1b.0: irq 30 for MSI/MSI-X
<7>
[   21.186379] ahci 0000:00:1f.2: version 3.0
<7>
[   21.187908] ahci 0000:00:1f.2: irq 31 for MSI/MSI-X
<6>
[   21.198821] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x6 impl SATA mode
<6>
[   21.199382] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
<6>
[   21.206050] scsi host0: ahci
<6>
[   21.207307] scsi host1: ahci
<6>
[   21.208365] scsi host2: ahci
<6>
[   21.209499] scsi host3: ahci
<6>
[   21.210875] scsi host4: ahci
<6>
[   21.211448] sound hdaudioC0D2: ALC889: SKU not ready 0x598301f0
<6>
[   21.212137] scsi host5: ahci
<6>
[   21.212613] sound hdaudioC0D2: autoconfig: line_outs=3 (0x14/0x19/0x16/0x0/0x0) type:line
<6>
[   21.212794] ata1: DUMMY
<6>
[   21.212799] ata2: SATA max UDMA/133 abar m2048@0xb0240000 port 0xb0240180 irq 31
<6>
[   21.212803] ata3: SATA max UDMA/133 abar m2048@0xb0240000 port 0xb0240200 irq 31
<6>
[   21.212805] ata4: DUMMY
<6>
[   21.212807] ata5: DUMMY
<6>
[   21.212809] ata6: DUMMY
<6>
[   21.220282] sound hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<6>
[   21.221456] sound hdaudioC0D2:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
<6>
[   21.222614] sound hdaudioC0D2:    mono: mono_out=0x0
<6>
[   21.223718] sound hdaudioC0D2:    dig-out=0x1e/0x0
<6>
[   21.224788] sound hdaudioC0D2:    inputs:
<6>
[   21.225795] sound hdaudioC0D2:      Front Mic=0x18
<6>
[   21.226861] sound hdaudioC0D2:      Rear Mic=0x1b
<6>
[   21.227881] sound hdaudioC0D2:      Line=0x1a
<5>
[   21.300365] firewire_core 0000:04:00.0: created device fw0: GUID 354fc00035e71a01, S400
<6>
[   21.518079] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>
[   21.520056] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
<6>
[   21.522206] ata3.00: ATAPI: ATAPI   iHAS124   B, AL0Q, max UDMA/100
<6>
[   21.524427] ata3.00: configured for UDMA/100
<6>
[   21.543340] ata2.00: ATA-9: ST1000DM003-1CH162, CC49, max UDMA/133
<6>
[   21.544795] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<6>
[   21.547452] ata2.00: configured for UDMA/133
<5>
[   21.549392] scsi 1:0:0:0: Direct-Access     ATA      ST1000DM003-1CH1 CC49 PQ: 0 ANSI: 5
<5>
[   21.556650] scsi 2:0:0:0: CD-ROM            ATAPI    iHAS124   B      AL0Q PQ: 0 ANSI: 5
<6>
[   21.653275] sr 2:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
<6>
[   21.654749] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>
[   21.657214] sr 2:0:0:0: Attached scsi CD-ROM sr0
<5>
[   21.657429] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
<5>
[   21.657435] sd 1:0:0:0: [sda] 4096-byte physical blocks
<5>
[   21.657964] sd 1:0:0:0: [sda] Write Protect is off
<7>
[   21.657967] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>
[   21.658275] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>
[   21.679898]  sda: unknown partition table
<5>
[   21.682793] sd 1:0:0:0: [sda] Attached SCSI disk
<5>
[   21.685827] sd 1:0:0:0: Attached scsi generic sg0 type 0
<5>
[   21.687580] sr 2:0:0:0: Attached scsi generic sg1 type 5
<6>
[   23.682691] floppy0: no floppy controllers found
<6>
[   24.271150] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
<6>
[   24.273067] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
<6>
[   24.275016] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
<6>
[   24.276974] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
<6>
[   24.278946] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
<6>
[   24.280956] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
<6>
[   24.283182] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
<6>
[   24.285437] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
<6>
[   24.287567] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
<6>
[   24.289907] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
<6>
[   26.717760] floppy0: no floppy controllers found
<6>
[   26.875333] fuse init (API version 7.23)
<6>
[   28.110090] device-mapper: uevent: version 1.0.3
<6>
[   28.112211] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
<5>
[   28.136443] random: vgscan urandom read with 104 bits of entropy available
<6>
[   35.236319] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
<5>
[   35.295317] random: nonblocking pool is initialized
<6>
[   46.452544] ipmi message handler version 39.2
<6>
[   46.456772] IPMI Watchdog: driver initialized

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--IJpNTDwzlM2Ie8A6--
