Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaAMN14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:27:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:23717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaAMN1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:27:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457899123"
Date: Mon, 13 Jan 2014 21:27:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [intel_idle] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000048
Message-ID: <20140113132734.GA32268@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

We find commit 38207484cc9 ("intel_idle: use the common
cpuidle_[un]register() routines") triggered oops in one of our
servers:

[   12.788616] intel_idle: MWAIT substates: 0x2120
[   12.794106] intel_idle: v0.4 model 0x3F
[   12.798820] intel_idle: lapic_timer_reliable_states 0xffffffff
[   12.807169] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[   12.816854] IP: [<ffffffff814f02f1>] kobject_get+0x12/0x44
[   12.823487] PGD 0
[   12.826228] Oops: 0002 [#1] SMP
[   12.830406] Modules linked in:
[   12.834310] CPU: 18 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7-03669-ga961e1e #1
[   12.843645] Hardware name: Intel Corporation S2600WT/S2600WT, BIOS GRNDSDP1.86B.0018.R02.1310250658 10/25/2013
[   12.855602] task: ffff880469ff8000 ti: ffff880469810000 task.ti: ffff880469810000
[   12.864737] RIP: 0010:[<ffffffff814f02f1>]  [<ffffffff814f02f1>] kobject_get+0x12/0x44
[   12.874442] RSP: 0000:ffff880469811d08  EFLAGS: 00010202
[   12.880803] RAX: 0000000000000001 RBX: 0000000000000010 RCX: 0000000000000000
[   12.889209] RDX: ffffffff81f8e2ad RSI: 000000000000002f RDI: 0000000000000010
[   12.897613] RBP: ffff880469811d10 R08: 0000000000000007 R09: ffffffff81f8e2ad
[   12.906016] R10: ffff88084d2e8630 R11: 0000000000000001 R12: 0000000000000000
[   12.914419] R13: 0000000000000010 R14: 000000000000fc20 R15: 0000000000000000
[   12.922824] FS:  0000000000000000(0000) GS:ffff88086ec80000(0000) knlGS:0000000000000000
[   12.932645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.939495] CR2: 0000000000000048 CR3: 000000000220c000 CR4: 00000000001407e0
[   12.947900] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   12.956302] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   12.964704] Stack:
[   12.967367]  ffff88084d2e86a8 ffff880469811d58 ffffffff814f084d ffff88084d2e86a8
[   12.976724]  0000000000000000 ffff88084d2e86a8 0000000000000000 0000000000000010
[   12.986080]  000000000000fc20 0000000000000000 ffff880469811dc8 ffffffff814f0a90
[   12.995443] Call Trace:
[   12.998594]  [<ffffffff814f084d>] kobject_add_internal+0x5a/0x22a
[   13.005832]  [<ffffffff814f0a90>] kobject_init_and_add+0x73/0x7e
[   13.012975]  [<ffffffff811b0c7f>] ? kmem_cache_alloc_trace+0x4c/0x1b8
[   13.020602]  [<ffffffff818d55ac>] ? cpuidle_add_sysfs+0x32/0xb1
[   13.027645]  [<ffffffff8122a96d>] ? sysfs_new_dirent+0x51/0x102
[   13.034686]  [<ffffffff818d55fd>] cpuidle_add_sysfs+0x83/0xb1
[   13.041534]  [<ffffffff818d4745>] cpuidle_register_device+0xab/0xfb
[   13.048964]  [<ffffffff818d48eb>] cpuidle_register+0x79/0xae
[   13.055719]  [<ffffffff8238ff8b>] intel_idle_init+0x2c8/0x313

Full dmesg and kconfig are attached.

Thanks,
Fengguang

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7-03669-ga961e1e (kbuild@cairo) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Tue Jan 7 01:54:21 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009bbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000004fca2fff] usable
[    0.000000] BIOS-e820: [mem 0x000000004fca3000-0x000000004fd4ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000004fd50000-0x0000000064180fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000064181000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7dbfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7dc000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000087fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation S2600WT/S2600WT, BIOS GRNDSDP1.86B.0018.R02.1310250658 10/25/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x880000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009bc00-0x0009bfff]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x87fe00000-0x87fffffff]
[    0.000000]  [mem 0x87fe00000-0x87fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x87c000000-0x87fdfffff]
[    0.000000]  [mem 0x87c000000-0x87fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x800000000-0x87bffffff]
[    0.000000]  [mem 0x800000000-0x87bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x4fca2fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x4fbfffff] page 2M
[    0.000000]  [mem 0x4fc00000-0x4fca2fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x4fd50000-0x64180fff]
[    0.000000]  [mem 0x4fd50000-0x4fdfffff] page 4k
[    0.000000]  [mem 0x4fe00000-0x63ffffff] page 2M
[    0.000000]  [mem 0x64000000-0x64180fff] page 4k
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7b7dc000-0x7b7fffff]
[    0.000000]  [mem 0x7b7dc000-0x7b7fffff] page 4k
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x7ffffffff]
[    0.000000]  [mem 0x100000000-0x7ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x5852d000-0x64180fff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007b7da0e8 0000BC (v01 INTEL  INTEL ID 00000000      01000013)
[    0.000000] ACPI: FACP 000000007b7d8000 0000F4 (v04 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: DSDT 000000007b7a1000 02CED1 (v02 INTEL  INTEL ID 00000003 INTL 20091013)
[    0.000000] ACPI: FACS 000000007b6fb000 000040
[    0.000000] ACPI: UEFI 000000007b6d5000 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: BDAT 000000007b7d9000 000030 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: HPET 000000007b7d7000 000038 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: APIC 000000007b7d6000 00085C (v02 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MCFG 000000007b7d5000 00003C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: MIGT 000000007b7d4000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MSCT 000000007b7d3000 000090 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: PMCT 000000007b7d2000 000064 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SLIT 000000007b7d1000 00006C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SRAT 000000007b7d0000 000E30 (v03 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SVOS 000000007b7cf000 000032 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: WDDT 000000007b7ce000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SSDT 000000004fca3000 0ACA42 (v02  INTEL SSDT  PM 00004000 INTL 20130328)
[    0.000000] ACPI: SSDT 000000007b79e000 002130 (v02  INTEL SpsNm    00000002 INTL 20130328)
[    0.000000] ACPI: SSDT 000000007b79d000 000064 (v02  INTEL SpsNvs   00000002 INTL 20130328)
[    0.000000] ACPI: PRAD 000000007b79c000 000102 (v02  INTEL SpsPrAgg 00000002 INTL 20130328)
[    0.000000] ACPI: SPCR 000000007b79b000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: DMAR 000000007b79a000 0000F8 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1c -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1d -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x47fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x47fffffff]
[    0.000000]   NODE_DATA [mem 0x47fffb000-0x47fffffff]
[    0.000000] Initmem setup node 1 [mem 0x480000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87fff8000-0x87fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0011ffffff] PMD -> [ffff880470200000-ffff88047fdfffff] on node 0
[    0.000000]  [ffffea0012000000-ffffea0021ffffff] PMD -> [ffff88086f600000-ffff88087f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x87fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x4fca2fff]
[    0.000000]   node   0: [mem 0x4fd50000-0x64180fff]
[    0.000000]   node   0: [mem 0x7b7dc000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x47fffffff]
[    0.000000]   node   1: [mem 0x480000000-0x87fffffff]
[    0.000000] On node 0 totalpages: 4079762
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6340 pages used for memmap
[    0.000000]   DMA32 zone: 405752 pages, LIFO batch:31
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 3670016 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x52] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x53] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x54] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x55] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x58] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x59] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x60] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x61] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x62] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x63] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x64] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x65] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x66] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x67] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x68] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x69] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x70] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x71] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x72] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x73] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x74] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x75] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x76] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x77] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x78] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x79] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x80] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x81] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x82] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x83] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x84] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x85] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x86] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x87] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x88] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x89] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec40000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 88 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec40000)
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x4fca3000-0x4fd4ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x64181000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:144 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88046f800000 s81024 r8192 d21376 u131072
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 028 029 
[    0.000000] pcpu-alloc: [0] 030 031 032 033 034 035 036 037 038 039 040 041 056 058 060 062 
[    0.000000] pcpu-alloc: [0] 064 066 068 070 072 074 076 078 080 082 084 086 088 090 092 094 
[    0.000000] pcpu-alloc: [0] 096 098 100 102 104 106 108 110 112 114 116 118 120 122 124 126 
[    0.000000] pcpu-alloc: [0] 128 130 132 134 136 138 140 142 --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 014 015 016 017 018 019 020 021 022 023 024 025 026 027 042 043 
[    0.000000] pcpu-alloc: [1] 044 045 046 047 048 049 050 051 052 053 054 055 057 059 061 063 
[    0.000000] pcpu-alloc: [1] 065 067 069 071 073 075 077 079 081 083 085 087 089 091 093 095 
[    0.000000] pcpu-alloc: [1] 097 099 101 103 105 107 109 111 113 115 117 119 121 123 125 127 
[    0.000000] pcpu-alloc: [1] 129 131 133 135 137 139 141 143 --- --- --- --- --- --- --- --- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 8144761
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=wfg job=/lkp/scheduled/grantley/reconfirm_aim7-creat-clo-x86_64-lkp-a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/vmlinuz-3.13.0-rc7-03669-ga961e1e kconfig=x86_64-lkp commit=a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc modules_initrd=/kernel/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/modules.cgz max_uptime=928 RESULT_ROOT=/lkp/result/grantley/micro/aim7/creat-clo/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/3 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::grantley::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 32278216K/33096264K available (10362K kernel code, 1235K rwdata, 4148K rodata, 1428K init, 1736K bss, 818048K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=144.
[    0.000000] NR_IRQS:33024 nr_irqs:2648 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7-03669-ga961e1e (kbuild@cairo) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Tue Jan 7 01:54:21 CST 2014
[    0.000000] Command line: user=wfg job=/lkp/scheduled/grantley/reconfirm_aim7-creat-clo-x86_64-lkp-a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/vmlinuz-3.13.0-rc7-03669-ga961e1e kconfig=x86_64-lkp commit=a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc modules_initrd=/kernel/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/modules.cgz max_uptime=928 RESULT_ROOT=/lkp/result/grantley/micro/aim7/creat-clo/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/3 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::grantley::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009bbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000004fca2fff] usable
[    0.000000] BIOS-e820: [mem 0x000000004fca3000-0x000000004fd4ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000004fd50000-0x0000000064180fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000064181000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7dbfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7dc000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000087fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation S2600WT/S2600WT, BIOS GRNDSDP1.86B.0018.R02.1310250658 10/25/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x880000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009bc00-0x0009bfff]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x87fe00000-0x87fffffff]
[    0.000000]  [mem 0x87fe00000-0x87fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x87c000000-0x87fdfffff]
[    0.000000]  [mem 0x87c000000-0x87fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x800000000-0x87bffffff]
[    0.000000]  [mem 0x800000000-0x87bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x4fca2fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x4fbfffff] page 2M
[    0.000000]  [mem 0x4fc00000-0x4fca2fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x4fd50000-0x64180fff]
[    0.000000]  [mem 0x4fd50000-0x4fdfffff] page 4k
[    0.000000]  [mem 0x4fe00000-0x63ffffff] page 2M
[    0.000000]  [mem 0x64000000-0x64180fff] page 4k
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7b7dc000-0x7b7fffff]
[    0.000000]  [mem 0x7b7dc000-0x7b7fffff] page 4k
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x7ffffffff]
[    0.000000]  [mem 0x100000000-0x7ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x5852d000-0x64180fff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007b7da0e8 0000BC (v01 INTEL  INTEL ID 00000000      01000013)
[    0.000000] ACPI: FACP 000000007b7d8000 0000F4 (v04 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: DSDT 000000007b7a1000 02CED1 (v02 INTEL  INTEL ID 00000003 INTL 20091013)
[    0.000000] ACPI: FACS 000000007b6fb000 000040
[    0.000000] ACPI: UEFI 000000007b6d5000 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: BDAT 000000007b7d9000 000030 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: HPET 000000007b7d7000 000038 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: APIC 000000007b7d6000 00085C (v02 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MCFG 000000007b7d5000 00003C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: MIGT 000000007b7d4000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MSCT 000000007b7d3000 000090 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: PMCT 000000007b7d2000 000064 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SLIT 000000007b7d1000 00006C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SRAT 000000007b7d0000 000E30 (v03 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SVOS 000000007b7cf000 000032 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: WDDT 000000007b7ce000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SSDT 000000004fca3000 0ACA42 (v02  INTEL SSDT  PM 00004000 INTL 20130328)
[    0.000000] ACPI: SSDT 000000007b79e000 002130 (v02  INTEL SpsNm    00000002 INTL 20130328)
[    0.000000] ACPI: SSDT 000000007b79d000 000064 (v02  INTEL SpsNvs   00000002 INTL 20130328)
[    0.000000] ACPI: PRAD 000000007b79c000 000102 (v02  INTEL SpsPrAgg 00000002 INTL 20130328)
[    0.000000] ACPI: SPCR 000000007b79b000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: DMAR 000000007b79a000 0000F8 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1c -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2c -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1d -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2d -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x47fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x47fffffff]
[    0.000000]   NODE_DATA [mem 0x47fffb000-0x47fffffff]
[    0.000000] Initmem setup node 1 [mem 0x480000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87fff8000-0x87fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0011ffffff] PMD -> [ffff880470200000-ffff88047fdfffff] on node 0
[    0.000000]  [ffffea0012000000-ffffea0021ffffff] PMD -> [ffff88086f600000-ffff88087f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x87fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x4fca2fff]
[    0.000000]   node   0: [mem 0x4fd50000-0x64180fff]
[    0.000000]   node   0: [mem 0x7b7dc000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x47fffffff]
[    0.000000]   node   1: [mem 0x480000000-0x87fffffff]
[    0.000000] On node 0 totalpages: 4079762
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6340 pages used for memmap
[    0.000000]   DMA32 zone: 405752 pages, LIFO batch:31
[    0.000000]   Normal zone: 57344 pages used for memmap
[    0.000000]   Normal zone: 3670016 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000]   Normal zone: 65536 pages used for memmap
[    0.000000]   Normal zone: 4194304 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xff] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x50] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x51] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x52] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x53] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x54] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x55] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x56] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x57] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x58] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x59] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x5f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x60] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x61] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x62] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x63] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x64] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x65] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x66] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x67] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x68] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x69] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x6f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x70] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x71] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x72] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x73] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x74] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x75] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x76] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x77] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x78] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x79] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x7f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x80] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x81] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x82] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x83] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x84] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x85] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x86] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x87] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x88] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x89] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x8f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec40000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec40000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 88 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec40000)
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x4fca3000-0x4fd4ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x64181000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7dbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:144 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88046f800000 s81024 r8192 d21376 u131072
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 028 029 
[    0.000000] pcpu-alloc: [0] 030 031 032 033 034 035 036 037 038 039 040 041 056 058 060 062 
[    0.000000] pcpu-alloc: [0] 064 066 068 070 072 074 076 078 080 082 084 086 088 090 092 094 
[    0.000000] pcpu-alloc: [0] 096 098 100 102 104 106 108 110 112 114 116 118 120 122 124 126 
[    0.000000] pcpu-alloc: [0] 128 130 132 134 136 138 140 142 --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 014 015 016 017 018 019 020 021 022 023 024 025 026 027 042 043 
[    0.000000] pcpu-alloc: [1] 044 045 046 047 048 049 050 051 052 053 054 055 057 059 061 063 
[    0.000000] pcpu-alloc: [1] 065 067 069 071 073 075 077 079 081 083 085 087 089 091 093 095 
[    0.000000] pcpu-alloc: [1] 097 099 101 103 105 107 109 111 113 115 117 119 121 123 125 127 
[    0.000000] pcpu-alloc: [1] 129 131 133 135 137 139 141 143 --- --- --- --- --- --- --- --- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 8144761
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=wfg job=/lkp/scheduled/grantley/reconfirm_aim7-creat-clo-x86_64-lkp-a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/vmlinuz-3.13.0-rc7-03669-ga961e1e kconfig=x86_64-lkp commit=a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc modules_initrd=/kernel/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/modules.cgz max_uptime=928 RESULT_ROOT=/lkp/result/grantley/micro/aim7/creat-clo/x86_64-lkp/a961e1e9d1a4e14ac6ab02c501ae0064b4e1c6fc/3 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::grantley::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 32278216K/33096264K available (10362K kernel code, 1235K rwdata, 4148K rodata, 1428K init, 1736K bss, 818048K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=144.
[    0.000000] NR_IRQS:33024 nr_irqs:2648 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 133169152 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2194.773 MHz processor
[    0.000065] Calibrating delay loop (skipped), value calculated using timer frequency.. 4389.54 BogoMIPS (lpj=8779092)
[    0.012088] pid_max: default: 147456 minimum: 1152
[    0.020484] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.055684] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.073670] Mount-cache hash table entries: 256
[    0.079554] Initializing cgroup subsys memory
[    0.084540] Initializing cgroup subsys devices
[    0.089910] Initializing cgroup subsys freezer
[    0.095284] Initializing cgroup subsys blkio
[    0.100445] Initializing cgroup subsys perf_event
[    0.106136] Initializing cgroup subsys hugetlb
[    0.111604] CPU: Physical Processor ID: 0
[    0.116481] CPU: Processor Core ID: 0
[    0.122337] mce: CPU supports 22 MCE banks
[    0.127365] CPU0: Thermal LVT vector (0xfa) already installed
[    0.134213] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.134213] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0
[    0.134213] tlb_flushall_shift: 6
[    0.151118] Freeing SMP alternatives memory: 44K (ffffffff8249b000 - ffffffff824a6000)
[    0.162273] ACPI: Core revision 20131115
[    0.213638] ACPI: All ACPI Tables successfully acquired
[    0.220041] ftrace: allocating 39667 entries in 155 pages
[    0.246036] Getting VERSION: 1060015
[    0.250428] Getting VERSION: 1060015
[    0.254820] Getting ID: 0
[    0.258144] Getting ID: 0
[    0.261461] Switched APIC routing to physical flat.
[    0.267317] masked ExtINT on CPU#0
[    0.272016] ENABLING IO-APIC IRQs
[    0.276115] init IO_APIC IRQs
[    0.279824]  apic 8 pin 0 not connected
[    0.284514] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.294104] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.303697] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.313294] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.322885] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.332478] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.342072] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.351663] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.361253] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.370848] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.380636] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.390422] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.400210] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.409999] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.419786] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.429574]  apic 8 pin 16 not connected
[    0.434356]  apic 8 pin 17 not connected
[    0.439143]  apic 8 pin 18 not connected
[    0.443928]  apic 8 pin 19 not connected
[    0.448713]  apic 8 pin 20 not connected
[    0.453501]  apic 8 pin 21 not connected
[    0.458283]  apic 8 pin 22 not connected
[    0.463067]  apic 8 pin 23 not connected
[    0.467848]  apic 9 pin 0 not connected
[    0.472531]  apic 9 pin 1 not connected
[    0.477220]  apic 9 pin 2 not connected
[    0.481908]  apic 9 pin 3 not connected
[    0.486593]  apic 9 pin 4 not connected
[    0.491280]  apic 9 pin 5 not connected
[    0.495963]  apic 9 pin 6 not connected
[    0.500640]  apic 9 pin 7 not connected
[    0.505332]  apic 9 pin 8 not connected
[    0.510022]  apic 9 pin 9 not connected
[    0.514708]  apic 9 pin 10 not connected
[    0.519491]  apic 9 pin 11 not connected
[    0.524264]  apic 9 pin 12 not connected
[    0.529045]  apic 9 pin 13 not connected
[    0.533830]  apic 9 pin 14 not connected
[    0.538603]  apic 9 pin 15 not connected
[    0.543377]  apic 9 pin 16 not connected
[    0.548163]  apic 9 pin 17 not connected
[    0.552949]  apic 9 pin 18 not connected
[    0.557730]  apic 9 pin 19 not connected
[    0.562504]  apic 9 pin 20 not connected
[    0.567278]  apic 9 pin 21 not connected
[    0.572059]  apic 9 pin 22 not connected
[    0.576843]  apic 9 pin 23 not connected
[    0.581630]  apic 10 pin 0 not connected
[    0.586413]  apic 10 pin 1 not connected
[    0.591200]  apic 10 pin 2 not connected
[    0.595982]  apic 10 pin 3 not connected
[    0.600763]  apic 10 pin 4 not connected
[    0.605547]  apic 10 pin 5 not connected
[    0.610331]  apic 10 pin 6 not connected
[    0.615114]  apic 10 pin 7 not connected
[    0.619900]  apic 10 pin 8 not connected
[    0.624684]  apic 10 pin 9 not connected
[    0.629468]  apic 10 pin 10 not connected
[    0.634347]  apic 10 pin 11 not connected
[    0.639230]  apic 10 pin 12 not connected
[    0.644111]  apic 10 pin 13 not connected
[    0.648989]  apic 10 pin 14 not connected
[    0.653877]  apic 10 pin 15 not connected
[    0.658758]  apic 10 pin 16 not connected
[    0.663639]  apic 10 pin 17 not connected
[    0.668520]  apic 10 pin 18 not connected
[    0.673399]  apic 10 pin 19 not connected
[    0.678277]  apic 10 pin 20 not connected
[    0.683155]  apic 10 pin 21 not connected
[    0.688037]  apic 10 pin 22 not connected
[    0.692918]  apic 10 pin 23 not connected
[    0.697932] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.744773] smpboot: CPU0: Genuine Intel(R) CPU @ 2.20GHz (fam: 06, model: 3f, stepping: 01)
[    0.755164] TSC deadline timer enabled
[    0.759803] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.772211] ... version:                3
[    0.777094] ... bit width:              48
[    0.782072] ... generic registers:      4
[    0.786951] ... value mask:             0000ffffffffffff
[    0.793291] ... max period:             0000ffffffffffff
[    0.799636] ... fixed-purpose events:   3
[    0.804517] ... event mask:             000000070000000f
[    0.815422] x86: Booting SMP configuration:
[    0.820500] .... node  #0, CPUs:          #1
[    0.839929] masked ExtINT on CPU#1
[    0.845139] CPU1: Thermal LVT vector (0xfa) already installed
   #2
[    0.867029] masked ExtINT on CPU#2
[    0.872229] CPU2: Thermal LVT vector (0xfa) already installed
   #3
[    0.893898] masked ExtINT on CPU#3
[    0.899098] CPU3: Thermal LVT vector (0xfa) already installed
   #4
[    0.920760] masked ExtINT on CPU#4
[    0.925970] CPU4: Thermal LVT vector (0xfa) already installed
   #5
[    0.947794] masked ExtINT on CPU#5
[    0.953038] CPU5: Thermal LVT vector (0xfa) already installed
   #6
[    0.974780] masked ExtINT on CPU#6
[    0.980025] CPU6: Thermal LVT vector (0xfa) already installed
   #7
[    1.001761] masked ExtINT on CPU#7
[    1.007133] CPU7: Thermal LVT vector (0xfa) already installed
   #8
[    1.029149] masked ExtINT on CPU#8
[    1.034519] CPU8: Thermal LVT vector (0xfa) already installed
   #9
[    1.056169] masked ExtINT on CPU#9
[    1.061453] CPU9: Thermal LVT vector (0xfa) already installed
  #10
[    1.083084] masked ExtINT on CPU#10
[    1.088466] CPU10: Thermal LVT vector (0xfa) already installed
  #11
[    1.110636] masked ExtINT on CPU#11
[    1.116062] CPU11: Thermal LVT vector (0xfa) already installed
  #12
[    1.138173] masked ExtINT on CPU#12
[    1.143631] CPU12: Thermal LVT vector (0xfa) already installed
  #13
[    1.165777] masked ExtINT on CPU#13
[    1.171246] CPU13: Thermal LVT vector (0xfa) already installed

[    1.180742] .... node  #1, CPUs:    #14
[    1.197660] masked ExtINT on CPU#14
[    1.203008] CPU14: Thermal LVT vector (0xfa) already installed
  #15
[    1.321972] masked ExtINT on CPU#15
[    1.327285] CPU15: Thermal LVT vector (0xfa) already installed
  #16
[    1.349272] masked ExtINT on CPU#16
[    1.354617] CPU16: Thermal LVT vector (0xfa) already installed
  #17
[    1.376239] masked ExtINT on CPU#17
[    1.381586] CPU17: Thermal LVT vector (0xfa) already installed
  #18
[    1.403441] masked ExtINT on CPU#18
[    1.408790] CPU18: Thermal LVT vector (0xfa) already installed
  #19
[    1.430552] masked ExtINT on CPU#19
[    1.435898] CPU19: Thermal LVT vector (0xfa) already installed
  #20
[    1.457630] masked ExtINT on CPU#20
[    1.462979] CPU20: Thermal LVT vector (0xfa) already installed
  #21
[    1.484916] masked ExtINT on CPU#21
[    1.490394] CPU21: Thermal LVT vector (0xfa) already installed
  #22
[    1.512487] masked ExtINT on CPU#22
[    1.517961] CPU22: Thermal LVT vector (0xfa) already installed
  #23
[    1.539611] masked ExtINT on CPU#23
[    1.544999] CPU23: Thermal LVT vector (0xfa) already installed
  #24
[    1.566849] masked ExtINT on CPU#24
[    1.572241] CPU24: Thermal LVT vector (0xfa) already installed
  #25
[    1.594307] masked ExtINT on CPU#25
[    1.599780] CPU25: Thermal LVT vector (0xfa) already installed
  #26
[    1.621836] masked ExtINT on CPU#26
[    1.627312] CPU26: Thermal LVT vector (0xfa) already installed
  #27
[    1.649491] masked ExtINT on CPU#27
[    1.655054] CPU27: Thermal LVT vector (0xfa) already installed

[    1.664387] .... node  #0, CPUs:    #28
[    1.681095] masked ExtINT on CPU#28
[    1.686441] CPU28: Thermal LVT vector (0xfa) already installed
  #29
[    1.708151] masked ExtINT on CPU#29
[    1.713304] CPU29: Thermal LVT vector (0xfa) already installed
  #30
[    1.734709] masked ExtINT on CPU#30
[    1.739718] CPU30: Thermal LVT vector (0xfa) already installed
  #31
[    1.760744] masked ExtINT on CPU#31
[    1.765654] CPU31: Thermal LVT vector (0xfa) already installed
  #32
[    1.786597] masked ExtINT on CPU#32
[    1.791458] CPU32: Thermal LVT vector (0xfa) already installed
  #33
[    1.812425] masked ExtINT on CPU#33
[    1.817270] CPU33: Thermal LVT vector (0xfa) already installed
  #34
[    1.838171] masked ExtINT on CPU#34
[    1.843016] CPU34: Thermal LVT vector (0xfa) already installed
  #35
[    1.863950] masked ExtINT on CPU#35
[    1.868857] CPU35: Thermal LVT vector (0xfa) already installed
  #36
[    1.890126] masked ExtINT on CPU#36
[    1.894995] CPU36: Thermal LVT vector (0xfa) already installed
  #37
[    1.915860] masked ExtINT on CPU#37
[    1.920684] CPU37: Thermal LVT vector (0xfa) already installed
  #38
[    1.941474] masked ExtINT on CPU#38
[    1.946297] CPU38: Thermal LVT vector (0xfa) already installed
  #39
[    1.967235] masked ExtINT on CPU#39
[    1.972079] CPU39: Thermal LVT vector (0xfa) already installed
  #40
[    1.993057] masked ExtINT on CPU#40
[    1.997915] CPU40: Thermal LVT vector (0xfa) already installed
  #41
[    2.018866] masked ExtINT on CPU#41
[    2.023743] CPU41: Thermal LVT vector (0xfa) already installed

[    2.033102] .... node  #1, CPUs:    #42
[    2.048927] masked ExtINT on CPU#42
[    2.053747] CPU42: Thermal LVT vector (0xfa) already installed
  #43
[    2.074603] masked ExtINT on CPU#43
[    2.079424] CPU43: Thermal LVT vector (0xfa) already installed
  #44
[    2.100429] masked ExtINT on CPU#44
[    2.105253] CPU44: Thermal LVT vector (0xfa) already installed
  #45
[    2.126051] masked ExtINT on CPU#45
[    2.130875] CPU45: Thermal LVT vector (0xfa) already installed
  #46
[    2.151862] masked ExtINT on CPU#46
[    2.156755] CPU46: Thermal LVT vector (0xfa) already installed
  #47
[    2.177565] masked ExtINT on CPU#47
[    2.182388] CPU47: Thermal LVT vector (0xfa) already installed
  #48
[    2.203271] masked ExtINT on CPU#48
[    2.208160] CPU48: Thermal LVT vector (0xfa) already installed
  #49
[    2.229139] masked ExtINT on CPU#49
[    2.234092] CPU49: Thermal LVT vector (0xfa) already installed
  #50
[    2.255320] masked ExtINT on CPU#50
[    2.260230] CPU50: Thermal LVT vector (0xfa) already installed
  #51
[    2.280990] masked ExtINT on CPU#51
[    2.285853] CPU51: Thermal LVT vector (0xfa) already installed
  #52
[    2.306782] masked ExtINT on CPU#52
[    2.311665] CPU52: Thermal LVT vector (0xfa) already installed
  #53
[    2.332699] masked ExtINT on CPU#53
[    2.337576] CPU53: Thermal LVT vector (0xfa) already installed
  #54
[    2.358597] masked ExtINT on CPU#54
[    2.363507] CPU54: Thermal LVT vector (0xfa) already installed
  #55
[    2.384628] masked ExtINT on CPU#55
[    2.389584] CPU55: Thermal LVT vector (0xfa) already installed

[    2.398226] x86: Booted up 2 nodes, 56 CPUs
[    2.403875] smpboot: Total of 56 processors activated (245859.86 BogoMIPS)
[    2.619787] devtmpfs: initialized
[    2.628448] PM: Registering ACPI NVS region [mem 0x7accf000-0x7b6fefff] (10682368 bytes)
[    2.639816] xor: automatically using best checksumming function:
[    2.686983]    avx       : 24503.000 MB/sec
[    2.692076] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    2.700318] NET: Registered protocol family 16
[    2.706411] cpuidle: using governor ladder
[    2.711381] cpuidle: using governor menu
[    2.716610] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    2.725794] ACPI: bus type PCI registered
[    2.730666] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.738353] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    2.749486] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    2.766273] PCI: Using configuration type 1 for base access
[    2.786699] bio: create slab <bio-0> at 0
[    2.859665] raid6: sse2x1    7644 MB/s
[    2.932339] raid6: sse2x2    9916 MB/s
[    3.005017] raid6: sse2x4   11770 MB/s
[    3.077707] raid6: avx2x1   14936 MB/s
[    3.150385] raid6: avx2x2   17674 MB/s
[    3.223065] raid6: avx2x4   20633 MB/s
[    3.227643] raid6: using algorithm avx2x4 (20633 MB/s)
[    3.233779] raid6: using avx2x2 recovery algorithm
[    3.239776] ACPI: Added _OSI(Module Device)
[    3.244848] ACPI: Added _OSI(Processor Device)
[    3.250208] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.255857] ACPI: Added _OSI(Processor Aggregator Device)
[    3.369075] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    3.379403] ACPI: Dynamic OEM Table Load:
[    3.384424] ACPI: PRAD           (null) 000102 (v02  INTEL SpsPrAgg 00000002 INTL 20130328)
[    3.428255] ACPI: Interpreter enabled
[    3.432751] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    3.443939] ACPI: (supports S0 S1 S3 S4 S5)
[    3.449005] ACPI: Using IOAPIC for interrupt routing
[    3.455064] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    3.469646] ACPI: No dock devices found.
[    3.557387] ACPI: PCI Root Bridge [UNC1] (domain 0000 [bus ff])
[    3.564410] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.582193] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    3.590049] PCI host bridge to bus 0000:ff
[    3.595025] pci_bus 0000:ff: root bus resource [bus ff]
[    3.601275] pci 0000:ff:08.0: [8086:2f80] type 00 class 0x088000
[    3.608474] pci 0000:ff:08.2: [8086:2f32] type 00 class 0x110100
[    3.615666] pci 0000:ff:08.3: [8086:2f83] type 00 class 0x088000
[    3.622892] pci 0000:ff:08.5: [8086:2f85] type 00 class 0x088000
[    3.630092] pci 0000:ff:08.6: [8086:2f86] type 00 class 0x088000
[    3.637282] pci 0000:ff:08.7: [8086:2f87] type 00 class 0x088000
[    3.644478] pci 0000:ff:09.0: [8086:2f90] type 00 class 0x088000
[    3.651669] pci 0000:ff:09.2: [8086:2f33] type 00 class 0x110100
[    3.658865] pci 0000:ff:09.3: [8086:2f93] type 00 class 0x088000
[    3.666061] pci 0000:ff:09.5: [8086:2f95] type 00 class 0x088000
[    3.673256] pci 0000:ff:09.6: [8086:2f96] type 00 class 0x088000
[    3.680465] pci 0000:ff:0b.0: [8086:2f81] type 00 class 0x088000
[    3.687662] pci 0000:ff:0b.1: [8086:2f36] type 00 class 0x110100
[    3.694859] pci 0000:ff:0b.2: [8086:2f37] type 00 class 0x110100
[    3.702056] pci 0000:ff:0b.4: [8086:2f41] type 00 class 0x088000
[    3.709256] pci 0000:ff:0b.5: [8086:2f3e] type 00 class 0x110100
[    3.716461] pci 0000:ff:0b.6: [8086:2f3f] type 00 class 0x110100
[    3.723669] pci 0000:ff:0c.0: [8086:2fe0] type 00 class 0x088000
[    3.730887] pci 0000:ff:0c.1: [8086:2fe1] type 00 class 0x088000
[    3.738089] pci 0000:ff:0c.2: [8086:2fe2] type 00 class 0x088000
[    3.745294] pci 0000:ff:0c.3: [8086:2fe3] type 00 class 0x088000
[    3.752493] pci 0000:ff:0c.4: [8086:2fe4] type 00 class 0x088000
[    3.759704] pci 0000:ff:0c.5: [8086:2fe5] type 00 class 0x088000
[    3.766917] pci 0000:ff:0c.6: [8086:2fe6] type 00 class 0x088000
[    3.774133] pci 0000:ff:0c.7: [8086:2fe7] type 00 class 0x088000
[    3.781347] pci 0000:ff:0d.0: [8086:2fe8] type 00 class 0x088000
[    3.788565] pci 0000:ff:0d.1: [8086:2fe9] type 00 class 0x088000
[    3.795778] pci 0000:ff:0d.2: [8086:2fea] type 00 class 0x088000
[    3.802991] pci 0000:ff:0d.3: [8086:2feb] type 00 class 0x088000
[    3.810203] pci 0000:ff:0d.4: [8086:2fec] type 00 class 0x088000
[    3.817419] pci 0000:ff:0d.5: [8086:2fed] type 00 class 0x088000
[    3.824643] pci 0000:ff:0f.0: [8086:2ff8] type 00 class 0x088000
[    3.831860] pci 0000:ff:0f.1: [8086:2ff9] type 00 class 0x088000
[    3.839077] pci 0000:ff:0f.2: [8086:2ffa] type 00 class 0x088000
[    3.846291] pci 0000:ff:0f.3: [8086:2ffb] type 00 class 0x088000
[    3.853509] pci 0000:ff:0f.4: [8086:2ffc] type 00 class 0x088000
[    3.860725] pci 0000:ff:0f.5: [8086:2ffd] type 00 class 0x088000
[    3.867941] pci 0000:ff:0f.6: [8086:2ffe] type 00 class 0x088000
[    3.875162] pci 0000:ff:10.0: [8086:2f1d] type 00 class 0x088000
[    3.882380] pci 0000:ff:10.1: [8086:2f34] type 00 class 0x110100
[    3.889605] pci 0000:ff:10.5: [8086:2f1e] type 00 class 0x088000
[    3.896821] pci 0000:ff:10.6: [8086:2f7d] type 00 class 0x110100
[    3.904038] pci 0000:ff:10.7: [8086:2f1f] type 00 class 0x088000
[    3.911254] pci 0000:ff:12.0: [8086:2fa0] type 00 class 0x088000
[    3.918474] pci 0000:ff:12.1: [8086:2f30] type 00 class 0x110100
[    3.925700] pci 0000:ff:12.2: [8086:2f70] type 00 class 0x088000
[    3.932925] pci 0000:ff:12.4: [8086:2f60] type 00 class 0x088000
[    3.940150] pci 0000:ff:12.5: [8086:2f38] type 00 class 0x110100
[    3.947380] pci 0000:ff:12.6: [8086:2f78] type 00 class 0x088000
[    3.954609] pci 0000:ff:13.0: [8086:2fa8] type 00 class 0x088000
[    3.961832] pci 0000:ff:13.1: [8086:2f71] type 00 class 0x088000
[    3.969061] pci 0000:ff:13.2: [8086:2faa] type 00 class 0x088000
[    3.976284] pci 0000:ff:13.3: [8086:2fab] type 00 class 0x088000
[    3.983494] pci 0000:ff:13.4: [8086:2fac] type 00 class 0x088000
[    3.990723] pci 0000:ff:13.5: [8086:2fad] type 00 class 0x088000
[    3.997949] pci 0000:ff:13.6: [8086:2fae] type 00 class 0x088000
[    4.005178] pci 0000:ff:13.7: [8086:2faf] type 00 class 0x088000
[    4.012395] pci 0000:ff:14.0: [8086:2fb0] type 00 class 0x088000
[    4.019624] pci 0000:ff:14.1: [8086:2fb1] type 00 class 0x088000
[    4.026864] pci 0000:ff:14.2: [8086:2fb2] type 00 class 0x088000
[    4.034098] pci 0000:ff:14.3: [8086:2fb3] type 00 class 0x088000
[    4.041323] pci 0000:ff:14.4: [8086:2fbc] type 00 class 0x088000
[    4.048551] pci 0000:ff:14.5: [8086:2fbd] type 00 class 0x088000
[    4.055776] pci 0000:ff:14.6: [8086:2fbe] type 00 class 0x088000
[    4.063002] pci 0000:ff:14.7: [8086:2fbf] type 00 class 0x088000
[    4.070223] pci 0000:ff:15.0: [8086:2fb4] type 00 class 0x088000
[    4.077451] pci 0000:ff:15.1: [8086:2fb5] type 00 class 0x088000
[    4.084679] pci 0000:ff:15.2: [8086:2fb6] type 00 class 0x088000
[    4.091905] pci 0000:ff:15.3: [8086:2fb7] type 00 class 0x088000
[    4.099144] pci 0000:ff:16.0: [8086:2f68] type 00 class 0x088000
[    4.106371] pci 0000:ff:16.1: [8086:2f79] type 00 class 0x088000
[    4.113598] pci 0000:ff:16.2: [8086:2f6a] type 00 class 0x088000
[    4.120832] pci 0000:ff:16.3: [8086:2f6b] type 00 class 0x088000
[    4.128050] pci 0000:ff:16.4: [8086:2f6c] type 00 class 0x088000
[    4.135278] pci 0000:ff:16.5: [8086:2f6d] type 00 class 0x088000
[    4.142507] pci 0000:ff:16.6: [8086:2f6e] type 00 class 0x088000
[    4.149727] pci 0000:ff:16.7: [8086:2f6f] type 00 class 0x088000
[    4.156946] pci 0000:ff:17.0: [8086:2fd0] type 00 class 0x088000
[    4.164177] pci 0000:ff:17.1: [8086:2fd1] type 00 class 0x088000
[    4.171405] pci 0000:ff:17.2: [8086:2fd2] type 00 class 0x088000
[    4.178636] pci 0000:ff:17.3: [8086:2fd3] type 00 class 0x088000
[    4.185861] pci 0000:ff:17.4: [8086:2fb8] type 00 class 0x088000
[    4.193085] pci 0000:ff:17.5: [8086:2fb9] type 00 class 0x088000
[    4.200307] pci 0000:ff:17.6: [8086:2fba] type 00 class 0x088000
[    4.207531] pci 0000:ff:17.7: [8086:2fbb] type 00 class 0x088000
[    4.214759] pci 0000:ff:18.0: [8086:2fd4] type 00 class 0x088000
[    4.221994] pci 0000:ff:18.1: [8086:2fd5] type 00 class 0x088000
[    4.229221] pci 0000:ff:18.2: [8086:2fd6] type 00 class 0x088000
[    4.236455] pci 0000:ff:18.3: [8086:2fd7] type 00 class 0x088000
[    4.243715] pci 0000:ff:1e.0: [8086:2f98] type 00 class 0x088000
[    4.250937] pci 0000:ff:1e.1: [8086:2f99] type 00 class 0x088000
[    4.258162] pci 0000:ff:1e.2: [8086:2f9a] type 00 class 0x088000
[    4.265377] pci 0000:ff:1e.3: [8086:2fc0] type 00 class 0x088000
[    4.272507] pci 0000:ff:1e.3: reg 0x10: [mem 0x00000010-0x0000001f]
[    4.280019] pci 0000:ff:1e.4: [8086:2f9c] type 00 class 0x088000
[    4.287252] pci 0000:ff:1f.0: [8086:2f88] type 00 class 0x088000
[    4.294477] pci 0000:ff:1f.2: [8086:2f8a] type 00 class 0x088000
[    4.301796] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus 7f])
[    4.308823] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    4.318713] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    4.326591] PCI host bridge to bus 0000:7f
[    4.331577] pci_bus 0000:7f: root bus resource [bus 7f]
[    4.337831] pci 0000:7f:08.0: [8086:2f80] type 00 class 0x088000
[    4.345046] pci 0000:7f:08.2: [8086:2f32] type 00 class 0x110100
[    4.352251] pci 0000:7f:08.3: [8086:2f83] type 00 class 0x088000
[    4.359479] pci 0000:7f:08.5: [8086:2f85] type 00 class 0x088000
[    4.366694] pci 0000:7f:08.6: [8086:2f86] type 00 class 0x088000
[    4.373911] pci 0000:7f:08.7: [8086:2f87] type 00 class 0x088000
[    4.381126] pci 0000:7f:09.0: [8086:2f90] type 00 class 0x088000
[    4.388340] pci 0000:7f:09.2: [8086:2f33] type 00 class 0x110100
[    4.395553] pci 0000:7f:09.3: [8086:2f93] type 00 class 0x088000
[    4.402771] pci 0000:7f:09.5: [8086:2f95] type 00 class 0x088000
[    4.409988] pci 0000:7f:09.6: [8086:2f96] type 00 class 0x088000
[    4.417207] pci 0000:7f:0b.0: [8086:2f81] type 00 class 0x088000
[    4.424416] pci 0000:7f:0b.1: [8086:2f36] type 00 class 0x110100
[    4.431626] pci 0000:7f:0b.2: [8086:2f37] type 00 class 0x110100
[    4.438839] pci 0000:7f:0b.4: [8086:2f41] type 00 class 0x088000
[    4.446077] pci 0000:7f:0b.5: [8086:2f3e] type 00 class 0x110100
[    4.453291] pci 0000:7f:0b.6: [8086:2f3f] type 00 class 0x110100
[    4.460504] pci 0000:7f:0c.0: [8086:2fe0] type 00 class 0x088000
[    4.467719] pci 0000:7f:0c.1: [8086:2fe1] type 00 class 0x088000
[    4.474933] pci 0000:7f:0c.2: [8086:2fe2] type 00 class 0x088000
[    4.482154] pci 0000:7f:0c.3: [8086:2fe3] type 00 class 0x088000
[    4.489362] pci 0000:7f:0c.4: [8086:2fe4] type 00 class 0x088000
[    4.496570] pci 0000:7f:0c.5: [8086:2fe5] type 00 class 0x088000
[    4.503783] pci 0000:7f:0c.6: [8086:2fe6] type 00 class 0x088000
[    4.511000] pci 0000:7f:0c.7: [8086:2fe7] type 00 class 0x088000
[    4.518203] pci 0000:7f:0d.0: [8086:2fe8] type 00 class 0x088000
[    4.525417] pci 0000:7f:0d.1: [8086:2fe9] type 00 class 0x088000
[    4.532627] pci 0000:7f:0d.2: [8086:2fea] type 00 class 0x088000
[    4.539834] pci 0000:7f:0d.3: [8086:2feb] type 00 class 0x088000
[    4.547046] pci 0000:7f:0d.4: [8086:2fec] type 00 class 0x088000
[    4.554258] pci 0000:7f:0d.5: [8086:2fed] type 00 class 0x088000
[    4.561476] pci 0000:7f:0f.0: [8086:2ff8] type 00 class 0x088000
[    4.568696] pci 0000:7f:0f.1: [8086:2ff9] type 00 class 0x088000
[    4.575901] pci 0000:7f:0f.2: [8086:2ffa] type 00 class 0x088000
[    4.583115] pci 0000:7f:0f.3: [8086:2ffb] type 00 class 0x088000
[    4.590327] pci 0000:7f:0f.4: [8086:2ffc] type 00 class 0x088000
[    4.597552] pci 0000:7f:0f.5: [8086:2ffd] type 00 class 0x088000
[    4.604765] pci 0000:7f:0f.6: [8086:2ffe] type 00 class 0x088000
[    4.611980] pci 0000:7f:10.0: [8086:2f1d] type 00 class 0x088000
[    4.619191] pci 0000:7f:10.1: [8086:2f34] type 00 class 0x110100
[    4.626406] pci 0000:7f:10.5: [8086:2f1e] type 00 class 0x088000
[    4.633617] pci 0000:7f:10.6: [8086:2f7d] type 00 class 0x110100
[    4.640825] pci 0000:7f:10.7: [8086:2f1f] type 00 class 0x088000
[    4.648033] pci 0000:7f:12.0: [8086:2fa0] type 00 class 0x088000
[    4.655251] pci 0000:7f:12.1: [8086:2f30] type 00 class 0x110100
[    4.662472] pci 0000:7f:12.2: [8086:2f70] type 00 class 0x088000
[    4.669689] pci 0000:7f:12.4: [8086:2f60] type 00 class 0x088000
[    4.676906] pci 0000:7f:12.5: [8086:2f38] type 00 class 0x110100
[    4.684123] pci 0000:7f:12.6: [8086:2f78] type 00 class 0x088000
[    4.691340] pci 0000:7f:13.0: [8086:2fa8] type 00 class 0x088000
[    4.698556] pci 0000:7f:13.1: [8086:2f71] type 00 class 0x088000
[    4.705773] pci 0000:7f:13.2: [8086:2faa] type 00 class 0x088000
[    4.712981] pci 0000:7f:13.3: [8086:2fab] type 00 class 0x088000
[    4.720204] pci 0000:7f:13.4: [8086:2fac] type 00 class 0x088000
[    4.727420] pci 0000:7f:13.5: [8086:2fad] type 00 class 0x088000
[    4.734637] pci 0000:7f:13.6: [8086:2fae] type 00 class 0x088000
[    4.741854] pci 0000:7f:13.7: [8086:2faf] type 00 class 0x088000
[    4.749073] pci 0000:7f:14.0: [8086:2fb0] type 00 class 0x088000
[    4.756286] pci 0000:7f:14.1: [8086:2fb1] type 00 class 0x088000
[    4.763507] pci 0000:7f:14.2: [8086:2fb2] type 00 class 0x088000
[    4.770726] pci 0000:7f:14.3: [8086:2fb3] type 00 class 0x088000
[    4.777950] pci 0000:7f:14.4: [8086:2fbc] type 00 class 0x088000
[    4.785168] pci 0000:7f:14.5: [8086:2fbd] type 00 class 0x088000
[    4.792381] pci 0000:7f:14.6: [8086:2fbe] type 00 class 0x088000
[    4.799596] pci 0000:7f:14.7: [8086:2fbf] type 00 class 0x088000
[    4.806806] pci 0000:7f:15.0: [8086:2fb4] type 00 class 0x088000
[    4.814026] pci 0000:7f:15.1: [8086:2fb5] type 00 class 0x088000
[    4.821255] pci 0000:7f:15.2: [8086:2fb6] type 00 class 0x088000
[    4.828475] pci 0000:7f:15.3: [8086:2fb7] type 00 class 0x088000
[    4.835707] pci 0000:7f:16.0: [8086:2f68] type 00 class 0x088000
[    4.842922] pci 0000:7f:16.1: [8086:2f79] type 00 class 0x088000
[    4.850143] pci 0000:7f:16.2: [8086:2f6a] type 00 class 0x088000
[    4.857367] pci 0000:7f:16.3: [8086:2f6b] type 00 class 0x088000
[    4.872737] pci 0000:7f:16.4: [8086:2f6c] type 00 class 0x088000
[    4.879949] pci 0000:7f:16.5: [8086:2f6d] type 00 class 0x088000
[    4.887168] pci 0000:7f:16.6: [8086:2f6e] type 00 class 0x088000
[    4.894379] pci 0000:7f:16.7: [8086:2f6f] type 00 class 0x088000
[    4.901597] pci 0000:7f:17.0: [8086:2fd0] type 00 class 0x088000
[    4.908818] pci 0000:7f:17.1: [8086:2fd1] type 00 class 0x088000
[    4.916033] pci 0000:7f:17.2: [8086:2fd2] type 00 class 0x088000
[    4.923257] pci 0000:7f:17.3: [8086:2fd3] type 00 class 0x088000
[    4.930476] pci 0000:7f:17.4: [8086:2fb8] type 00 class 0x088000
[    4.937694] pci 0000:7f:17.5: [8086:2fb9] type 00 class 0x088000
[    4.944910] pci 0000:7f:17.6: [8086:2fba] type 00 class 0x088000
[    4.952122] pci 0000:7f:17.7: [8086:2fbb] type 00 class 0x088000
[    4.959337] pci 0000:7f:18.0: [8086:2fd4] type 00 class 0x088000
[    4.966555] pci 0000:7f:18.1: [8086:2fd5] type 00 class 0x088000
[    4.973782] pci 0000:7f:18.2: [8086:2fd6] type 00 class 0x088000
[    4.981004] pci 0000:7f:18.3: [8086:2fd7] type 00 class 0x088000
[    4.988260] pci 0000:7f:1e.0: [8086:2f98] type 00 class 0x088000
[    4.995475] pci 0000:7f:1e.1: [8086:2f99] type 00 class 0x088000
[    5.002690] pci 0000:7f:1e.2: [8086:2f9a] type 00 class 0x088000
[    5.009898] pci 0000:7f:1e.3: [8086:2fc0] type 00 class 0x088000
[    5.017018] pci 0000:7f:1e.3: reg 0x10: [mem 0x00000010-0x0000001f]
[    5.024520] pci 0000:7f:1e.4: [8086:2f9c] type 00 class 0x088000
[    5.031753] pci 0000:7f:1f.0: [8086:2f88] type 00 class 0x088000
[    5.038972] pci 0000:7f:1f.2: [8086:2f8a] type 00 class 0x088000
[    5.059523] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    5.066848] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.077613] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    5.087646] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    5.102759] PCI host bridge to bus 0000:00
[    5.107746] pci_bus 0000:00: root bus resource [bus 00-7e]
[    5.114285] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    5.121602] pci_bus 0000:00: root bus resource [io  0x1000-0x7fff]
[    5.128919] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    5.137013] pci_bus 0000:00: root bus resource [mem 0x90000000-0xc7ffbfff]
[    5.145106] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x383fffffffff]
[    5.154317] pci 0000:00:00.0: [8086:2f00] type 00 class 0x060000
[    5.161603] pci 0000:00:01.0: [8086:2f02] type 01 class 0x060400
[    5.168772] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    5.176055] pci 0000:00:01.0: System wakeup disabled by ACPI
[    5.182860] pci 0000:00:02.0: [8086:2f04] type 01 class 0x060400
[    5.190031] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    5.197314] pci 0000:00:02.0: System wakeup disabled by ACPI
[    5.204118] pci 0000:00:02.2: [8086:2f06] type 01 class 0x060400
[    5.211284] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[    5.218567] pci 0000:00:02.2: System wakeup disabled by ACPI
[    5.225374] pci 0000:00:03.0: [8086:2f08] type 01 class 0x060400
[    5.232541] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    5.239829] pci 0000:00:03.0: System wakeup disabled by ACPI
[    5.246636] pci 0000:00:04.0: [8086:2f20] type 00 class 0x088000
[    5.253767] pci 0000:00:04.0: reg 0x10: [mem 0x383ffff2c000-0x383ffff2ffff 64bit]
[    5.263035] pci 0000:00:04.1: [8086:2f21] type 00 class 0x088000
[    5.270168] pci 0000:00:04.1: reg 0x10: [mem 0x383ffff28000-0x383ffff2bfff 64bit]
[    5.279448] pci 0000:00:04.2: [8086:2f22] type 00 class 0x088000
[    5.286587] pci 0000:00:04.2: reg 0x10: [mem 0x383ffff24000-0x383ffff27fff 64bit]
[    5.295854] pci 0000:00:04.3: [8086:2f23] type 00 class 0x088000
[    5.302977] pci 0000:00:04.3: reg 0x10: [mem 0x383ffff20000-0x383ffff23fff 64bit]
[    5.312240] pci 0000:00:04.4: [8086:2f24] type 00 class 0x088000
[    5.319364] pci 0000:00:04.4: reg 0x10: [mem 0x383ffff1c000-0x383ffff1ffff 64bit]
[    5.328635] pci 0000:00:04.5: [8086:2f25] type 00 class 0x088000
[    5.335768] pci 0000:00:04.5: reg 0x10: [mem 0x383ffff18000-0x383ffff1bfff 64bit]
[    5.345037] pci 0000:00:04.6: [8086:2f26] type 00 class 0x088000
[    5.352171] pci 0000:00:04.6: reg 0x10: [mem 0x383ffff14000-0x383ffff17fff 64bit]
[    5.361442] pci 0000:00:04.7: [8086:2f27] type 00 class 0x088000
[    5.368573] pci 0000:00:04.7: reg 0x10: [mem 0x383ffff10000-0x383ffff13fff 64bit]
[    5.377832] pci 0000:00:05.0: [8086:2f28] type 00 class 0x088000
[    5.385106] pci 0000:00:05.1: [8086:2f29] type 00 class 0x088000
[    5.392392] pci 0000:00:05.2: [8086:2f2a] type 00 class 0x088000
[    5.399664] pci 0000:00:05.4: [8086:2f2c] type 00 class 0x080020
[    5.406793] pci 0000:00:05.4: reg 0x10: [mem 0x91d04000-0x91d04fff]
[    5.414367] pci 0000:00:05.6: [8086:2f39] type 00 class 0x110100
[    5.421643] pci 0000:00:06.0: [8086:2f10] type 00 class 0x088000
[    5.428928] pci 0000:00:06.1: [8086:2f11] type 00 class 0x088000
[    5.436203] pci 0000:00:06.2: [8086:2f12] type 00 class 0x088000
[    5.443478] pci 0000:00:06.3: [8086:2f13] type 00 class 0x088000
[    5.450753] pci 0000:00:06.4: [8086:2f14] type 00 class 0x088000
[    5.458026] pci 0000:00:06.5: [8086:2f15] type 00 class 0x088000
[    5.465307] pci 0000:00:06.6: [8086:2f16] type 00 class 0x088000
[    5.472580] pci 0000:00:06.7: [8086:2f17] type 00 class 0x088000
[    5.479857] pci 0000:00:07.0: [8086:2f18] type 00 class 0x088000
[    5.487127] pci 0000:00:07.1: [8086:2f19] type 00 class 0x088000
[    5.494402] pci 0000:00:07.2: [8086:2f1a] type 00 class 0x088000
[    5.501683] pci 0000:00:07.3: [8086:2f1b] type 00 class 0x088000
[    5.508956] pci 0000:00:07.4: [8086:2f1c] type 00 class 0x088000
[    5.516243] pci 0000:00:11.0: [8086:8d7c] type 00 class 0xff0000
[    5.523595] pci 0000:00:14.0: [8086:8d31] type 00 class 0x0c0330
[    5.530739] pci 0000:00:14.0: reg 0x10: [mem 0x383ffff00000-0x383ffff0ffff 64bit]
[    5.539893] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    5.546963] pci 0000:00:1a.0: [8086:8d2d] type 00 class 0x0c0320
[    5.554109] pci 0000:00:1a.0: reg 0x10: [mem 0x91d02000-0x91d023ff]
[    5.561611] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    5.568972] pci 0000:00:1c.0: [8086:8d10] type 01 class 0x060400
[    5.576164] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    5.583450] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    5.590259] pci 0000:00:1c.3: [8086:8d16] type 01 class 0x060400
[    5.597453] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    5.604735] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    5.611556] pci 0000:00:1d.0: [8086:8d26] type 00 class 0x0c0320
[    5.618704] pci 0000:00:1d.0: reg 0x10: [mem 0x91d01000-0x91d013ff]
[    5.626211] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    5.633573] pci 0000:00:1f.0: [8086:8d44] type 00 class 0x060100
[    5.640931] pci 0000:00:1f.2: [8086:8d02] type 00 class 0x010601
[    5.648073] pci 0000:00:1f.2: reg 0x10: [io  0x2058-0x205f]
[    5.654707] pci 0000:00:1f.2: reg 0x14: [io  0x207c-0x207f]
[    5.661346] pci 0000:00:1f.2: reg 0x18: [io  0x2050-0x2057]
[    5.667988] pci 0000:00:1f.2: reg 0x1c: [io  0x2078-0x207b]
[    5.674628] pci 0000:00:1f.2: reg 0x20: [io  0x2020-0x203f]
[    5.681268] pci 0000:00:1f.2: reg 0x24: [mem 0x91d00000-0x91d007ff]
[    5.688718] pci 0000:00:1f.2: PME# supported from D3hot
[    5.695096] pci 0000:00:1f.3: [8086:8d22] type 00 class 0x0c0500
[    5.702232] pci 0000:00:1f.3: reg 0x10: [mem 0x383ffff31000-0x383ffff310ff 64bit]
[    5.711358] pci 0000:00:1f.3: reg 0x20: [io  0x2000-0x201f]
[    5.718365] acpiphp: Slot [528] registered
[    5.723383] pci 0000:00:01.0: PCI bridge to [bus 01]
[    5.729569] acpiphp: Slot [512] registered
[    5.734586] pci 0000:00:02.0: PCI bridge to [bus 02]
[    5.740768] acpiphp: Slot [0] registered
[    5.745595] pci 0000:03:00.0: [8086:1528] type 00 class 0x020000
[    5.752731] pci 0000:03:00.0: reg 0x10: [mem 0x91e00000-0x91ffffff 64bit pref]
[    5.761539] pci 0000:03:00.0: reg 0x18: [io  0x1020-0x103f]
[    5.768187] pci 0000:03:00.0: reg 0x20: [mem 0x92200000-0x92203fff 64bit pref]
[    5.777042] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    5.784281] pci 0000:03:00.0: reg 0x184: [mem 0x91900000-0x91903fff 64bit]
[    5.792388] pci 0000:03:00.0: reg 0x190: [mem 0x91a00000-0x91a03fff 64bit]
[    5.800588] pci 0000:03:00.1: [8086:1528] type 00 class 0x020000
[    5.807725] pci 0000:03:00.1: reg 0x10: [mem 0x92000000-0x921fffff 64bit pref]
[    5.816541] pci 0000:03:00.1: reg 0x18: [io  0x1000-0x101f]
[    5.823189] pci 0000:03:00.1: reg 0x20: [mem 0x92204000-0x92207fff 64bit pref]
[    5.832043] pci 0000:03:00.1: PME# supported from D0 D3hot D3cold
[    5.839284] pci 0000:03:00.1: reg 0x184: [mem 0x91b00000-0x91b03fff 64bit]
[    5.847391] pci 0000:03:00.1: reg 0x190: [mem 0x91c00000-0x91c03fff 64bit]
[    5.863508] pci 0000:00:02.2: PCI bridge to [bus 03-04]
[    5.869753] pci 0000:00:02.2:   bridge window [io  0x1000-0x1fff]
[    5.876973] pci 0000:00:02.2:   bridge window [mem 0x91900000-0x91cfffff]
[    5.884976] pci 0000:00:02.2:   bridge window [mem 0x91e00000-0x922fffff 64bit pref]
[    5.894611] acpiphp: Slot [785] registered
[    5.899627] pci 0000:00:03.0: PCI bridge to [bus 05]
[    5.905691] pci 0000:00:1c.0: PCI bridge to [bus 06]
[    5.911654] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    5.918874] pci 0000:00:1c.0:   bridge window [mem 0x92300000-0x924fffff]
[    5.926874] pci 0000:00:1c.0:   bridge window [mem 0x92500000-0x926fffff 64bit pref]
[    5.936374] pci 0000:07:00.0: [102b:0522] type 00 class 0x030000
[    5.943521] pci 0000:07:00.0: reg 0x10: [mem 0x90000000-0x90ffffff pref]
[    5.951433] pci 0000:07:00.0: reg 0x14: [mem 0x91800000-0x91803fff]
[    5.958858] pci 0000:07:00.0: reg 0x18: [mem 0x91000000-0x917fffff]
[    5.966326] pci 0000:07:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    5.982248] pci 0000:00:1c.3: PCI bridge to [bus 07]
[    5.988208] pci 0000:00:1c.3:   bridge window [mem 0x91000000-0x918fffff]
[    5.996211] pci 0000:00:1c.3:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    6.005635] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    6.014638] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.025855] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.037087] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.048303] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.059521] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.078921] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.090154] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.101376] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    6.112730] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    6.120048] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.130769] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    6.140702] PCI host bridge to bus 0000:80
[    6.145686] pci_bus 0000:80: root bus resource [bus 80-fe]
[    6.152224] pci_bus 0000:80: root bus resource [io  0x8000-0xffff]
[    6.159540] pci_bus 0000:80: root bus resource [mem 0xc8000000-0xfbffbfff]
[    6.167636] pci_bus 0000:80: root bus resource [mem 0x384000000000-0x387fffffffff]
[    6.176849] pci 0000:80:04.0: [8086:2f20] type 00 class 0x088000
[    6.183981] pci 0000:80:04.0: reg 0x10: [mem 0x387ffff1c000-0x387ffff1ffff 64bit]
[    6.193243] pci 0000:80:04.1: [8086:2f21] type 00 class 0x088000
[    6.200379] pci 0000:80:04.1: reg 0x10: [mem 0x387ffff18000-0x387ffff1bfff 64bit]
[    6.209634] pci 0000:80:04.2: [8086:2f22] type 00 class 0x088000
[    6.216768] pci 0000:80:04.2: reg 0x10: [mem 0x387ffff14000-0x387ffff17fff 64bit]
[    6.226023] pci 0000:80:04.3: [8086:2f23] type 00 class 0x088000
[    6.233158] pci 0000:80:04.3: reg 0x10: [mem 0x387ffff10000-0x387ffff13fff 64bit]
[    6.242413] pci 0000:80:04.4: [8086:2f24] type 00 class 0x088000
[    6.249549] pci 0000:80:04.4: reg 0x10: [mem 0x387ffff0c000-0x387ffff0ffff 64bit]
[    6.258805] pci 0000:80:04.5: [8086:2f25] type 00 class 0x088000
[    6.265939] pci 0000:80:04.5: reg 0x10: [mem 0x387ffff08000-0x387ffff0bfff 64bit]
[    6.275194] pci 0000:80:04.6: [8086:2f26] type 00 class 0x088000
[    6.282333] pci 0000:80:04.6: reg 0x10: [mem 0x387ffff04000-0x387ffff07fff 64bit]
[    6.291594] pci 0000:80:04.7: [8086:2f27] type 00 class 0x088000
[    6.298726] pci 0000:80:04.7: reg 0x10: [mem 0x387ffff00000-0x387ffff03fff 64bit]
[    6.307983] pci 0000:80:05.0: [8086:2f28] type 00 class 0x088000
[    6.315237] pci 0000:80:05.1: [8086:2f29] type 00 class 0x088000
[    6.322508] pci 0000:80:05.2: [8086:2f2a] type 00 class 0x088000
[    6.329768] pci 0000:80:05.4: [8086:2f2c] type 00 class 0x080020
[    6.336898] pci 0000:80:05.4: reg 0x10: [mem 0xc8000000-0xc8000fff]
[    6.344462] pci 0000:80:05.6: [8086:2f39] type 00 class 0x110100
[    6.351725] pci 0000:80:06.0: [8086:2f10] type 00 class 0x088000
[    6.358994] pci 0000:80:06.1: [8086:2f11] type 00 class 0x088000
[    6.366252] pci 0000:80:06.2: [8086:2f12] type 00 class 0x088000
[    6.373510] pci 0000:80:06.3: [8086:2f13] type 00 class 0x088000
[    6.380779] pci 0000:80:06.4: [8086:2f14] type 00 class 0x088000
[    6.388042] pci 0000:80:06.5: [8086:2f15] type 00 class 0x088000
[    6.395302] pci 0000:80:06.6: [8086:2f16] type 00 class 0x088000
[    6.402563] pci 0000:80:06.7: [8086:2f17] type 00 class 0x088000
[    6.409827] pci 0000:80:07.0: [8086:2f18] type 00 class 0x088000
[    6.417090] pci 0000:80:07.1: [8086:2f19] type 00 class 0x088000
[    6.424398] pci 0000:80:07.2: [8086:2f1a] type 00 class 0x088000
[    6.431655] pci 0000:80:07.3: [8086:2f1b] type 00 class 0x088000
[    6.438929] pci 0000:80:07.4: [8086:2f1c] type 00 class 0x088000
[    6.446208] acpi PNP0A08:01: Disabling ASPM (FADT indicates it is unsupported)
[    6.455238] ACPI: Enabled 4 GPEs in block 00 to 3F
[    6.461515] vgaarb: device added: PCI:0000:07:00.0,decodes=io+mem,owns=io+mem,locks=none
[    6.471307] vgaarb: loaded
[    6.474726] vgaarb: bridge control possible 0000:07:00.0
[    6.481272] SCSI subsystem initialized
[    6.486210] libata version 3.00 loaded.
[    6.491074] ACPI: bus type USB registered
[    6.496046] usbcore: registered new interface driver usbfs
[    6.502631] usbcore: registered new interface driver hub
[    6.509072] usbcore: registered new device driver usb
[    6.515280] pps_core: LinuxPPS API ver. 1 registered
[    6.521238] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    6.532234] PTP clock support registered
[    6.537573] EDAC MC: Ver: 3.0.0
[    6.542007] PCI: Using ACPI for IRQ routing
[    6.552134] PCI: pci_cache_line_size set to 64 bytes
[    6.558320] pci 0000:ff:1e.3: no compatible bridge window for [mem 0x00000010-0x0000001f]
[    6.568255] pci 0000:7f:1e.3: no compatible bridge window for [mem 0x00000010-0x0000001f]
[    6.578198] e820: reserve RAM buffer [mem 0x0009bc00-0x0009ffff]
[    6.585318] e820: reserve RAM buffer [mem 0x4fca3000-0x4fffffff]
[    6.592439] e820: reserve RAM buffer [mem 0x64181000-0x67ffffff]
[    6.599559] e820: reserve RAM buffer [mem 0x7b800000-0x7bffffff]
[    6.607555] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    6.615537] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    6.624720] Switched to clocksource hpet
[    6.646934] pnp: PnP ACPI init
[    6.650790] ACPI: bus type PNP registered
[    6.656368] pnp 00:00: Plug and Play ACPI device, IDs PNP0003 (active)
[    6.664491] pnp 00:01: [dma 4]
[    6.668468] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    6.676219] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    6.685958] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.693701] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    6.703635] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    6.711485] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    6.719357] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.727618] system 00:06: [io  0x0500-0x053f] has been reserved
[    6.734669] system 00:06: [io  0x0400-0x047f] could not be reserved
[    6.742105] system 00:06: [io  0x0540-0x057f] has been reserved
[    6.749151] system 00:06: [io  0x0600-0x061f] has been reserved
[    6.756197] system 00:06: [io  0x0ca0-0x0ca5] has been reserved
[    6.763243] system 00:06: [io  0x0880-0x0883] has been reserved
[    6.770290] system 00:06: [io  0x0800-0x081f] has been reserved
[    6.777338] system 00:06: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[    6.785554] system 00:06: [mem 0xfed45000-0xfed8bfff] has been reserved
[    6.793380] system 00:06: [mem 0xff000000-0xffffffff] could not be reserved
[    6.801593] system 00:06: [mem 0xfee00000-0xfeefffff] has been reserved
[    6.809417] system 00:06: [mem 0xfed12000-0xfed1200f] has been reserved
[    6.817241] system 00:06: [mem 0xfed12010-0xfed1201f] has been reserved
[    6.825065] system 00:06: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    6.832886] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.841037] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    6.850800] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.858639] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    6.868419] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.876305] pnp 00:09: Plug and Play ACPI device, IDs IPI0001 (active)
[    6.884387] pnp: PnP ACPI: found 10 devices
[    6.889485] ACPI: bus type PNP unregistered
[    6.905382] pci 0000:07:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    6.915809] pci 0000:ff:1e.3: BAR 0: can't assign mem (size 0x10)
[    6.923050] pci 0000:ff:1e.3: BAR 0: trying firmware assignment [mem 0x00000010-0x0000001f]
[    6.933166] pci 0000:ff:1e.3: BAR 0: assigned [mem 0x00000010-0x0000001f]
[    6.941216] pci 0000:7f:1e.3: BAR 0: can't assign mem (size 0x10)
[    6.948458] pci 0000:7f:1e.3: BAR 0: trying firmware assignment [mem 0x00000010-0x0000001f]
[    6.958573] pci 0000:7f:1e.3: BAR 0: [mem 0x00000010-0x0000001f] conflicts with 0000:ff:1e.3 [mem 0x00000010-0x0000001f]
[    6.971517] pci_bus 0000:7f: Some PCI device resources are unassigned, try booting with pci=realloc
[    6.982453] pci 0000:00:01.0: PCI bridge to [bus 01]
[    6.988432] pci 0000:00:02.0: PCI bridge to [bus 02]
[    6.994413] pci 0000:00:02.2: PCI bridge to [bus 03-04]
[    7.000685] pci 0000:00:02.2:   bridge window [io  0x1000-0x1fff]
[    7.007933] pci 0000:00:02.2:   bridge window [mem 0x91900000-0x91cfffff]
[    7.015959] pci 0000:00:02.2:   bridge window [mem 0x91e00000-0x922fffff 64bit pref]
[    7.025390] pci 0000:00:03.0: PCI bridge to [bus 05]
[    7.031376] pci 0000:00:1c.0: PCI bridge to [bus 06]
[    7.037354] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    7.044598] pci 0000:00:1c.0:   bridge window [mem 0x92300000-0x924fffff]
[    7.052618] pci 0000:00:1c.0:   bridge window [mem 0x92500000-0x926fffff 64bit pref]
[    7.062059] pci 0000:07:00.0: BAR 6: assigned [mem 0x91810000-0x9181ffff pref]
[    7.070912] pci 0000:00:1c.3: PCI bridge to [bus 07]
[    7.076891] pci 0000:00:1c.3:   bridge window [mem 0x91000000-0x918fffff]
[    7.084916] pci 0000:00:1c.3:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    7.094362] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    7.101020] pci_bus 0000:00: resource 5 [io  0x1000-0x7fff]
[    7.107680] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    7.115119] pci_bus 0000:00: resource 7 [mem 0x90000000-0xc7ffbfff]
[    7.122557] pci_bus 0000:00: resource 8 [mem 0x380000000000-0x383fffffffff]
[    7.130771] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    7.137428] pci_bus 0000:03: resource 1 [mem 0x91900000-0x91cfffff]
[    7.144868] pci_bus 0000:03: resource 2 [mem 0x91e00000-0x922fffff 64bit pref]
[    7.153721] pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
[    7.160377] pci_bus 0000:06: resource 1 [mem 0x92300000-0x924fffff]
[    7.167814] pci_bus 0000:06: resource 2 [mem 0x92500000-0x926fffff 64bit pref]
[    7.176662] pci_bus 0000:07: resource 1 [mem 0x91000000-0x918fffff]
[    7.184102] pci_bus 0000:07: resource 2 [mem 0x90000000-0x90ffffff 64bit pref]
[    7.192955] pci_bus 0000:80: resource 4 [io  0x8000-0xffff]
[    7.199615] pci_bus 0000:80: resource 5 [mem 0xc8000000-0xfbffbfff]
[    7.207049] pci_bus 0000:80: resource 6 [mem 0x384000000000-0x387fffffffff]
[    7.223931] NET: Registered protocol family 2
[    7.229751] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    7.239317] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    7.247454] TCP: Hash tables configured (established 262144 bind 65536)
[    7.255383] TCP: reno registered
[    7.259513] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    7.266999] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    7.275628] NET: Registered protocol family 1
[    7.281357] RPC: Registered named UNIX socket transport module.
[    7.288407] RPC: Registered udp transport module.
[    7.294093] RPC: Registered tcp transport module.
[    7.299777] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.307858] IOAPIC[0]: Set routing entry (8-19 -> 0x41 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    7.317765] pci 0000:00:14.0: CONFIG_USB_XHCI_HCD is turned off, defaulting to EHCI.
[    7.327199] pci 0000:00:14.0: USB 3.0 devices will work at USB 2.0 speeds.
[    7.335486] IOAPIC[0]: Set routing entry (8-18 -> 0x51 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    7.345559] pci 0000:07:00.0: Boot video device
[    7.351091] PCI: CLS 64 bytes, default 64
[    7.356051] Trying to unpack rootfs image as initramfs...
[   12.302353] Freeing initrd memory: 192848K (ffff88005852d000 - ffff880064181000)
[   12.311417] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   12.319075] software IO TLB [mem 0x5452d000-0x5852d000] (64MB) mapped at [ffff88005452d000-ffff88005852cfff]
[   12.335715] Scanning for low memory corruption every 60 seconds
[   12.344837] sha1_ssse3: Using AVX optimized SHA-1 implementation
[   12.352132] AVX or AES-NI instructions are not detected.
[   12.407304] bounce pool size: 64 pages
[   12.411927] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   12.426066] VFS: Disk quotas dquot_6.5.2
[   12.431078] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   12.441619] NFS: Registering the id_resolver key type
[   12.447708] Key type id_resolver registered
[   12.452802] Key type id_legacy registered
[   12.457712] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   12.465667] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   12.474065] ROMFS MTD (C) 2007 Red Hat, Inc.
[   12.479456] fuse init (API version 7.22)
[   12.484619] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   12.498282] bio: create slab <bio-1> at 1
[   12.503974] Btrfs loaded
[   12.507244] msgmni has been set to 32768
[   12.516296] NET: Registered protocol family 38
[   12.521718] Key type asymmetric registered
[   12.526862] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   12.536170] io scheduler noop registered
[   12.540982] io scheduler deadline registered
[   12.546187] io scheduler cfq registered (default)
[   12.552773] IOAPIC[1]: Set routing entry (9-23 -> 0x61 -> IRQ 47 Mode:1 Active:1 Dest:0)
[   12.562694] pcieport 0000:00:01.0: irq 88 for MSI/MSI-X
[   12.569250] pcieport 0000:00:02.0: irq 89 for MSI/MSI-X
[   12.575784] pcieport 0000:00:02.2: irq 90 for MSI/MSI-X
[   12.582329] pcieport 0000:00:03.0: irq 91 for MSI/MSI-X
[   12.588863] IOAPIC[0]: Set routing entry (8-16 -> 0xb1 -> IRQ 16 Mode:1 Active:1 Dest:0)
[   12.598728] pcieport 0000:00:1c.0: irq 92 for MSI/MSI-X
[   12.605242] pcieport 0000:00:1c.3: irq 93 for MSI/MSI-X
[   12.611725] aer 0000:00:01.0:pcie02: service driver aer loaded
[   12.618700] aer 0000:00:02.0:pcie02: service driver aer loaded
[   12.625674] aer 0000:00:02.2:pcie02: service driver aer loaded
[   12.632646] aer 0000:00:03.0:pcie02: service driver aer loaded
[   12.639657] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[   12.647874] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[   12.655806] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[   12.664025] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[   12.671957] pcieport 0000:00:02.2: Signaling PME through PCIe PME interrupt
[   12.680173] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[   12.687904] pci 0000:03:00.1: Signaling PME through PCIe PME interrupt
[   12.695636] pcie_pme 0000:00:02.2:pcie01: service driver pcie_pme loaded
[   12.703566] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   12.711788] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   12.719733] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[   12.727951] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[   12.735898] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[   12.744112] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[   12.751845] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[   12.759842] ioapic: probe of 0000:00:05.4 failed with error -22
[   12.766898] ioapic: probe of 0000:80:05.4 failed with error -22
[   12.773993] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   12.780788] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   12.788616] intel_idle: MWAIT substates: 0x2120
[   12.794106] intel_idle: v0.4 model 0x3F
[   12.798820] intel_idle: lapic_timer_reliable_states 0xffffffff
[   12.807169] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[   12.816854] IP: [<ffffffff814f02f1>] kobject_get+0x12/0x44
[   12.823487] PGD 0 
[   12.826228] Oops: 0002 [#1] SMP 
[   12.830406] Modules linked in:
[   12.834310] CPU: 18 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7-03669-ga961e1e #1
[   12.843645] Hardware name: Intel Corporation S2600WT/S2600WT, BIOS GRNDSDP1.86B.0018.R02.1310250658 10/25/2013
[   12.855602] task: ffff880469ff8000 ti: ffff880469810000 task.ti: ffff880469810000
[   12.864737] RIP: 0010:[<ffffffff814f02f1>]  [<ffffffff814f02f1>] kobject_get+0x12/0x44
[   12.874442] RSP: 0000:ffff880469811d08  EFLAGS: 00010202
[   12.880803] RAX: 0000000000000001 RBX: 0000000000000010 RCX: 0000000000000000
[   12.889209] RDX: ffffffff81f8e2ad RSI: 000000000000002f RDI: 0000000000000010
[   12.897613] RBP: ffff880469811d10 R08: 0000000000000007 R09: ffffffff81f8e2ad
[   12.906016] R10: ffff88084d2e8630 R11: 0000000000000001 R12: 0000000000000000
[   12.914419] R13: 0000000000000010 R14: 000000000000fc20 R15: 0000000000000000
[   12.922824] FS:  0000000000000000(0000) GS:ffff88086ec80000(0000) knlGS:0000000000000000
[   12.932645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.939495] CR2: 0000000000000048 CR3: 000000000220c000 CR4: 00000000001407e0
[   12.947900] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   12.956302] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   12.964704] Stack:
[   12.967367]  ffff88084d2e86a8 ffff880469811d58 ffffffff814f084d ffff88084d2e86a8
[   12.976724]  0000000000000000 ffff88084d2e86a8 0000000000000000 0000000000000010
[   12.986080]  000000000000fc20 0000000000000000 ffff880469811dc8 ffffffff814f0a90
[   12.995443] Call Trace:
[   12.998594]  [<ffffffff814f084d>] kobject_add_internal+0x5a/0x22a
[   13.005832]  [<ffffffff814f0a90>] kobject_init_and_add+0x73/0x7e
[   13.012975]  [<ffffffff811b0c7f>] ? kmem_cache_alloc_trace+0x4c/0x1b8
[   13.020602]  [<ffffffff818d55ac>] ? cpuidle_add_sysfs+0x32/0xb1
[   13.027645]  [<ffffffff8122a96d>] ? sysfs_new_dirent+0x51/0x102
[   13.034686]  [<ffffffff818d55fd>] cpuidle_add_sysfs+0x83/0xb1
[   13.041534]  [<ffffffff818d4745>] cpuidle_register_device+0xab/0xfb
[   13.048964]  [<ffffffff818d48eb>] cpuidle_register+0x79/0xae
[   13.055719]  [<ffffffff8238ff8b>] intel_idle_init+0x2c8/0x313
[   13.062566]  [<ffffffff8238fcc3>] ? no_scroll+0x19/0x19
[   13.068831]  [<ffffffff810002c9>] do_one_initcall+0xb3/0x15d
[   13.075581]  [<ffffffff810e2400>] ? param_array_set+0x79/0xfa
[   13.082428]  [<ffffffff810e273f>] ? parse_args+0x25f/0x33d
[   13.088987]  [<ffffffff8234afb9>] kernel_init_freeable+0x1aa/0x230
[   13.096322]  [<ffffffff8234a785>] ? do_early_param+0x88/0x88
[   13.103076]  [<ffffffff819fbed5>] ? rest_init+0x89/0x89
[   13.109343]  [<ffffffff819fbee3>] kernel_init+0xe/0x109
[   13.115607]  [<ffffffff81a194bc>] ret_from_fork+0x7c/0xb0
[   13.122065]  [<ffffffff819fbed5>] ? rest_init+0x89/0x89
[   13.128330] Code: e8 47 ff ff ff 5b 41 5c 5d c3 55 48 83 c7 40 48 89 e5 e8 24 bb c0 ff 5d c3 55 48 85 ff 48 89 e5 53 48 89 fb 74 31 b8 01 00 00 00 <f0> 0f c1 47 38 ff c0 ff c8 7f 21 80 3d 1e 3e e1 00 00 75 18 be 
[   13.155706] RIP  [<ffffffff814f02f1>] kobject_get+0x12/0x44
[   13.162439]  RSP <ffff880469811d08>
[   13.166755] CR2: 0000000000000048
[   13.170882] ---[ end trace 88c781ce916f9b23 ]---
[   13.176466] Kernel panic - not syncing: Fatal exception
[   13.182764] Rebooting in 10 seconds..
[   23.120709] ACPI MEMORY or I/O RESET_REG.

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x86_64-lkp

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
# CONFIG_NFS_V4_2 is not set
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--4Ckj6UjgE2iN1+kY--
