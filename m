Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3K2FZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 00:25:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:9051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3K2FZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 00:25:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,795,1378882800"; 
   d="scan'208";a="416757526"
Date: Fri, 29 Nov 2013 13:25:52 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: kernel panic due to "PCI / ACPI: Use acpi_find_child_device() for
 child devices lookup"
Message-ID: <20131129052552.GC23378@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

We got the follow kernel panic dmesg(full dmesg is attached):

[    7.781306] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[    7.791041] IP: [<ffffffff8154f5e5>] acpi_find_child_device+0x23/0xc3
[    7.798776] PGD 0 
[    7.801547] Oops: 0000 [#1] SMP 
[    7.805759] Modules linked in:
[    7.809698] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-01248-g32f2968 #1874
[    7.819272] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.R3.27.D685.1305151734 05/15/2013
[    7.831275] task: ffff88080cd98000 ti: ffff88080cda0000 task.ti: ffff88080cda0000
[    7.840461] RIP: 0010:[<ffffffff8154f5e5>]  [<ffffffff8154f5e5>] acpi_find_child_device+0x23/0xc3
[    7.851282] RSP: 0000:ffff88080cda19b0  EFLAGS: 00010282
[    7.857666] RAX: ffff88080ba52098 RBX: ffff88080cda1a18 RCX: 0000000000000000
[    7.866089] RDX: 0000000000000001 RSI: 0000000000080000 RDI: 0000000000000000
[    7.874512] RBP: ffff88080cda19e8 R08: 0000000000000000 R09: 0000000000000000
[    7.882935] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[    7.891361] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000080000
[    7.899785] FS:  0000000000000000(0000) GS:ffff880818a00000(0000) knlGS:0000000000000000
[    7.909652] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.916521] CR2: 0000000000000018 CR3: 000000000220c000 CR4: 00000000001407e0
[    7.924945] Stack:
[    7.927632]  ffffffff81550091 ffff88080ba53098 ffff88080cda1a18 ffff88080ba53098
[    7.937044]  ffffffff822b6a70 ffff88080ba52098 ffff88080ba43000 ffff88080cda1a00
[    7.946443]  ffffffff81548f73 ffff88080ba53098 ffff88080cda1a30 ffffffff8154fac6
[    7.955843] Call Trace:
[    7.959021]  [<ffffffff81550091>] ? acpi_bus_get_device+0x21/0x3e
[    7.966281]  [<ffffffff81548f73>] acpi_pci_find_device+0x3c/0x54
[    7.973442]  [<ffffffff8154fac6>] acpi_platform_notify+0x3a/0x6c
[    7.980603]  [<ffffffff815b671b>] device_add+0x143/0x550
[    7.986988]  [<ffffffff8152f2f8>] pci_device_add+0x123/0x13f
[    7.993760]  [<ffffffff81a3a444>] pci_scan_single_device+0x93/0x9e
[    8.001118]  [<ffffffff8152f36b>] pci_scan_slot+0x57/0x108
[    8.007696]  [<ffffffff8152fec0>] pci_scan_child_bus+0x53/0x10d
[    8.023921]  [<ffffffff8152fb53>] pci_scan_bridge+0x1d2/0x4ec
[    8.030792]  [<ffffffff8152ff32>] pci_scan_child_bus+0xc5/0x10d
[    8.037848]  [<ffffffff8152fb53>] pci_scan_bridge+0x1d2/0x4ec
[    8.044718]  [<ffffffff81a3a3f2>] ? pci_scan_single_device+0x41/0x9e
[    8.052268]  [<ffffffff8152ff32>] pci_scan_child_bus+0xc5/0x10d
[    8.059327]  [<ffffffff8191f767>] pci_acpi_scan_root+0x31f/0x3aa
[    8.066488]  [<ffffffff8155593d>] acpi_pci_root_add+0x35e/0x45a
[    8.073554]  [<ffffffff81551dcc>] acpi_bus_attach+0x86/0xf6
[    8.080220]  [<ffffffff81551e28>] acpi_bus_attach+0xe2/0xf6
[    8.086896]  [<ffffffff81551e28>] acpi_bus_attach+0xe2/0xf6
[    8.093573]  [<ffffffff81551e97>] acpi_bus_scan+0x5b/0x6b
[    8.100059]  [<ffffffff82578b47>] ? acpi_sleep_proc_init+0x2a/0x2a
[    8.107414]  [<ffffffff82578f48>] acpi_scan_init+0x61/0x18f
[    8.114090]  [<ffffffff82578b47>] ? acpi_sleep_proc_init+0x2a/0x2a
[    8.121435]  [<ffffffff82578d96>] acpi_init+0x24f/0x267
[    8.127724]  [<ffffffff810002ba>] do_one_initcall+0xa4/0x13a
[    8.134497]  [<ffffffff810e28cc>] ? parse_args+0x261/0x33f
[    8.141081]  [<ffffffff82533fd0>] kernel_init_freeable+0x1d9/0x25f
[    8.148438]  [<ffffffff82533785>] ? do_early_param+0x88/0x88
[    8.155209]  [<ffffffff81a37d99>] ? rest_init+0xcd/0xcd
[    8.161496]  [<ffffffff81a37da7>] kernel_init+0xe/0x109
[    8.167782]  [<ffffffff81a5c0fc>] ret_from_fork+0x7c/0xb0
[    8.174263]  [<ffffffff81a37d99>] ? rest_init+0xcd/0xcd
[    8.180550] Code: ff ff 5a 5b 41 5c 5d c3 0f 1f 44 00 00 55 48 89 e5 41 57 49 89 f7 41 56 45 31 f6 41 55 44 0f b6 ea 41 54 45 31 e4 53 48 83 ec 10 <48> 8b 47 18 48 8d 58 d8 48 8d 47 18 48 89 45 c8 48 8d 43 28 48 
[    8.208097] RIP  [<ffffffff8154f5e5>] acpi_find_child_device+0x23/0xc3
[    8.215920]  RSP <ffff88080cda19b0>
[    8.220261] CR2: 0000000000000018
[    8.224413] ---[ end trace 56dc910562aec71f ]---
[    8.230019] Kernel panic - not syncing: Fatal exception


And the first bad commit we bisected is:

caa223f31b414427e7d12c130587bf3261b257de is the first bad commit
commit caa223f31b414427e7d12c130587bf3261b257de
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Mon Nov 25 22:49:35 2013 +0100

    PCI / ACPI: Use acpi_find_child_device() for child devices lookup
    
    It is much more efficient to use acpi_find_child_device()
    for child devices lookup in acpi_pci_find_device() and pass
    ACPI_COMPANION(dev->parent) to it directly instead of obtaining
    ACPI_HANDLE() of ACPI_COMPANION(dev->parent) and passing it to
    acpi_find_child() which has to run acpi_bus_get_device() to
    obtain ACPI_COMPANION(dev->parent) from that again.
    
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Reviewed-by: Aaron Lu <aaron.lu@intel.com>

:040000 040000 eb2cd7279dafcce191ecc17b442130649366e376 bd1101a919edda8ece2e12b9b152426251cd78f0 M	drivers
bisect run success

# bad: [32f296837b2323b3c8d88e9e97135b2ed1de123f] Merge 'openvswitch/master' into devel-hourly-2013112708
# good: [6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae] Linux 3.13-rc1
git bisect start '32f296837b2323b3c8d88e9e97135b2ed1de123f' '6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae' '--'
# good: [7b797b94fc2592fa130c44d502fb08adfc015647] Merge 'staging/work-next' into devel-hourly-2013112708
git bisect good 7b797b94fc2592fa130c44d502fb08adfc015647
# bad: [caec74c0c122b289f685372f183be0d75877dea9] Merge 'perf/perf/core' into devel-hourly-2013112708
git bisect bad caec74c0c122b289f685372f183be0d75877dea9
# bad: [93bf277e43d6a22edb7a470634cb5fbb372307da] Merge 'shawnguo/for-next' into devel-hourly-2013112708
git bisect bad 93bf277e43d6a22edb7a470634cb5fbb372307da
# bad: [3f127a6bc56a4034016fc53c3add06c5cbc3bc5c] Merge 'm68k/for-3.14' into devel-hourly-2013112708
git bisect bad 3f127a6bc56a4034016fc53c3add06c5cbc3bc5c
# bad: [5e445066299a6a0c0a4a73946561e24da3ed6209] Merge 'pm/bleeding-edge' into devel-hourly-2013112708
git bisect bad 5e445066299a6a0c0a4a73946561e24da3ed6209
# bad: [955423d41f199c649b89fe36fc3b3fd8a102a894] ACPI / bind: Redefine acpi_preset_companion()
git bisect bad 955423d41f199c649b89fe36fc3b3fd8a102a894
# good: [202317a573b20d77a9abb7c16a3fd5b40cef3d9d] ACPI / scan: Add acpi_device objects for all device nodes in the namespace
git bisect good 202317a573b20d77a9abb7c16a3fd5b40cef3d9d
# good: [f4b734c35e98c343cd99824153de09e48867b97e] ACPI / hotplug: Drop unfinished global notification handling routines
git bisect good f4b734c35e98c343cd99824153de09e48867b97e
# good: [c1b5a568803400f131a93cdfdf65e779222122e6] ACPI / bind: Simplify child device lookups
git bisect good c1b5a568803400f131a93cdfdf65e779222122e6
# bad: [313d082956729d896f1a12e6892cf2901a7c2987] ACPI / bind: Redefine acpi_get_child()
git bisect bad 313d082956729d896f1a12e6892cf2901a7c2987
# bad: [caa223f31b414427e7d12c130587bf3261b257de] PCI / ACPI: Use acpi_find_child_device() for child devices lookup
git bisect bad caa223f31b414427e7d12c130587bf3261b257de
# first bad commit: [caa223f31b414427e7d12c130587bf3261b257de] PCI / ACPI: Use acpi_find_child_device() for child devices lookup

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.panic"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc1-01248-g32f2968 (kbuild@inn) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1874 SMP Wed Nov 27 08:38:37 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009bbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009bc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ba77ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ba780000-0x00000000baca5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000baca6000-0x00000000bb049fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bb04a000-0x00000000bd956fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bd957000-0x00000000bdb5bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdb5c000-0x00000000bdde6fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bdde7000-0x00000000bde2cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bde2d000-0x00000000bdf00fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf01000-0x00000000bdf01fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdf02000-0x00000000bdf1ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bdf20000-0x00000000bdffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000be000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed19000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000103fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.R3.27.D685.1305151734 05/15/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1040000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-through
[    0.000000]   CC000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask 3FFF80000000 write-back
[    0.000000]   1 base 000080000000 mask 3FFFC0000000 write-back
[    0.000000]   2 base 000100000000 mask 3FFF00000000 write-back
[    0.000000]   3 base 000200000000 mask 3FFE00000000 write-back
[    0.000000]   4 base 000400000000 mask 3FFC00000000 write-back
[    0.000000]   5 base 000800000000 mask 3FF800000000 write-back
[    0.000000]   6 base 001000000000 mask 3FFFC0000000 write-back
[    0.000000]   7 base 0000FFC00000 mask 3FFFFFC00000 write-protect
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xba780 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcb10-0x000fcb1f] mapped at [ffff8800000fcb10]
[    0.000000]   mpc: fc510-fca04
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02feb000, 0x02febfff] PGTABLE
[    0.000000] BRK [0x02fec000, 0x02fecfff] PGTABLE
[    0.000000] BRK [0x02fed000, 0x02fedfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x103fe00000-0x103fffffff]
[    0.000000]  [mem 0x103fe00000-0x103fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x103c000000-0x103fdfffff]
[    0.000000]  [mem 0x103c000000-0x103fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x103bffffff]
[    0.000000]  [mem 0x1000000000-0x103bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xba77ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xba5fffff] page 2M
[    0.000000]  [mem 0xba600000-0xba77ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 1042548(99%)
[    0.000000] RAMDISK: [mem 0x74389000-0x7fff2fff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000bdf1dd98 00008C (v01  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI: FACP 00000000bdf1da98 0000F4 (v04  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20131115/tbfadt-653)
[    0.000000] ACPI: DSDT 00000000bdf02018 019B5A (v02  INTEL   ROMLEY 00000027 INTL 20100331)
[    0.000000] ACPI: FACS 00000000bdf1df40 000040
[    0.000000] ACPI: APIC 00000000bdf1c018 000BAA (v03  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI: SPMI 00000000bdf1ff18 000041 (v05  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI: MCFG 00000000bdf1fe98 00003C (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SRAT 00000000bdf1cc18 0003A8 (v03  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI: SLIT 00000000bdf1fd98 000030 (v01  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI: MSCT 00000000bdf1fd18 00004E (v01  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI: HPET 00000000bdf1fe18 000038 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000bdf1fc98 00002B (v02  INTEL PtidDevc 00001000 INTL 20100331)
[    0.000000] ACPI: BOOT 00000000bdf1fc18 000028 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: SSDT 00000000bde2d018 0D3050 (v02  INTEL    CpuPm 00004000 INTL 20100331)
[    0.000000] ACPI: DMAR 00000000bdf1d918 000120 (v01 INTEL  ROMLEY   06222004 INTL 20090903)
[    0.000000] ACPI: BDAT 00000000bdf1fb98 000030 (v01  INTEL   ROMLEY 06222004 INTL 20090903)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x18 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x19 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x1b -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x28 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x29 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x2b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x83fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x840000000-0x103fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x83fffffff] -> [mem 0x00000000-0x83fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x83fffffff]
[    0.000000]   NODE_DATA [mem 0x83fffb000-0x83fffffff]
[    0.000000] Initmem setup node 1 [mem 0x840000000-0x103fffffff]
[    0.000000]   NODE_DATA [mem 0x103f7f8000-0x103f7fcfff]
[    0.000000]  [ffffea0000000000-ffffea0020ffffff] PMD -> [ffff88081fe00000-ffff88083fdfffff] on node 0
[    0.000000]  [ffffea0021000000-ffffea0040ffffff] PMD -> [ffff88101ee00000-ffff88103edfffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x103fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0xba77ffff]
[    0.000000]   node   0: [mem 0x100000000-0x83fffffff]
[    0.000000]   node   1: [mem 0x840000000-0x103fffffff]
[    0.000000] On node 0 totalpages: 8365850
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11870 pages used for memmap
[    0.000000]   DMA32 zone: 759680 pages, LIFO batch:31
[    0.000000]   Normal zone: 118784 pages used for memmap
[    0.000000]   Normal zone: 7602176 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] ACPI: X2APIC (apic_id[0x00] uid[0x00] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x01] uid[0x01] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x02] uid[0x02] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x03] uid[0x03] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x04] uid[0x04] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x05] uid[0x05] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x06] uid[0x06] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x07] uid[0x07] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x08] uid[0x08] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x09] uid[0x09] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0a] uid[0x0a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0b] uid[0x0b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0c] uid[0x0c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0d] uid[0x0d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0e] uid[0x0e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x0f] uid[0x0f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x10] uid[0x10] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x11] uid[0x11] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x12] uid[0x12] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x13] uid[0x13] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x14] uid[0x14] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x15] uid[0x15] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x16] uid[0x16] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x17] uid[0x17] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x18] uid[0x18] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x19] uid[0x19] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1a] uid[0x1a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1b] uid[0x1b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1c] uid[0x1c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1d] uid[0x1d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1e] uid[0x1e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x1f] uid[0x1f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x20] uid[0x20] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x21] uid[0x21] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x22] uid[0x22] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x23] uid[0x23] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x24] uid[0x24] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x25] uid[0x25] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x26] uid[0x26] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x27] uid[0x27] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x28] uid[0x28] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x29] uid[0x29] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2a] uid[0x2a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2b] uid[0x2b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2c] uid[0x2c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2d] uid[0x2d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2e] uid[0x2e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x2f] uid[0x2f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x30] uid[0x30] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x31] uid[0x31] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x32] uid[0x32] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x33] uid[0x33] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x34] uid[0x34] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x35] uid[0x35] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x36] uid[0x36] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x37] uid[0x37] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x38] uid[0x38] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x39] uid[0x39] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3a] uid[0x3a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3b] uid[0x3b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3c] uid[0x3c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3d] uid[0x3d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3e] uid[0x3e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x3f] uid[0x3f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x40] uid[0x40] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x41] uid[0x41] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x42] uid[0x42] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x43] uid[0x43] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x44] uid[0x44] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x45] uid[0x45] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x46] uid[0x46] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x47] uid[0x47] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x48] uid[0x48] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x49] uid[0x49] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x4a] uid[0x4a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x4b] uid[0x4b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x4c] uid[0x4c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x4d] uid[0x4d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x4e] uid[0x4e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x4f] uid[0x4f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x50] uid[0x50] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x51] uid[0x51] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x52] uid[0x52] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x53] uid[0x53] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x54] uid[0x54] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x55] uid[0x55] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x56] uid[0x56] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x57] uid[0x57] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x58] uid[0x58] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x59] uid[0x59] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x5a] uid[0x5a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x5b] uid[0x5b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x5c] uid[0x5c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x5d] uid[0x5d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x5e] uid[0x5e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x5f] uid[0x5f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x60] uid[0x60] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x61] uid[0x61] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x62] uid[0x62] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x63] uid[0x63] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x64] uid[0x64] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x65] uid[0x65] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x66] uid[0x66] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x67] uid[0x67] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x68] uid[0x68] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x69] uid[0x69] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x6a] uid[0x6a] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x6b] uid[0x6b] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x6c] uid[0x6c] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x6d] uid[0x6d] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x6e] uid[0x6e] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x6f] uid[0x6f] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x70] uid[0x70] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x71] uid[0x71] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x72] uid[0x72] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x73] uid[0x73] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x74] uid[0x74] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x75] uid[0x75] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x76] uid[0x76] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: X2APIC (apic_id[0x77] uid[0x77] disabled)
[    0.000000] ACPI: x2apic entry ignored
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x60] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x61] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x62] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x63] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x64] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x65] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x66] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x67] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x68] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x69] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x6f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x70] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x71] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x72] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x73] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x74] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x75] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x76] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x77] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec3f000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec7f000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 120 CPUs, 72 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f6000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f5000 (fec3f000)
[    0.000000] mapped IOAPIC to ffffffffff5f4000 (fec7f000)
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xba780000-0xbaca5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbaca6000-0xbb049fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbb04a000-0xbd956fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd957000-0xbdb5bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdb5c000-0xbdde6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdde7000-0xbde2cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbde2d000-0xbdf00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf01000-0xbdf01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf02000-0xbdf1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdf20000-0xbdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed18fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed19000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:120 nr_node_ids:2
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880818600000 s1920576 r8192 d20928 u2097152
[    0.000000] pcpu-alloc: s1920576 r8192 d20928 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 [0] 001 [0] 002 [0] 003 
[    0.000000] pcpu-alloc: [0] 004 [0] 005 [0] 006 [0] 007 
[    0.000000] pcpu-alloc: [0] 008 [0] 009 [0] 010 [0] 011 
[    0.000000] pcpu-alloc: [0] 024 [0] 025 [0] 026 [0] 027 
[    0.000000] pcpu-alloc: [0] 028 [0] 029 [0] 030 [0] 031 
[    0.000000] pcpu-alloc: [0] 032 [0] 033 [0] 034 [0] 035 
[    0.000000] pcpu-alloc: [0] 048 [0] 050 [0] 052 [0] 054 
[    0.000000] pcpu-alloc: [0] 056 [0] 058 [0] 060 [0] 062 
[    0.000000] pcpu-alloc: [0] 064 [0] 066 [0] 068 [0] 070 
[    0.000000] pcpu-alloc: [0] 072 [0] 074 [0] 076 [0] 078 
[    0.000000] pcpu-alloc: [0] 080 [0] 082 [0] 084 [0] 086 
[    0.000000] pcpu-alloc: [0] 088 [0] 090 [0] 092 [0] 094 
[    0.000000] pcpu-alloc: [0] 096 [0] 098 [0] 100 [0] 102 
[    0.000000] pcpu-alloc: [0] 104 [0] 106 [0] 108 [0] 110 
[    0.000000] pcpu-alloc: [0] 112 [0] 114 [0] 116 [0] 118 
[    0.000000] pcpu-alloc: [1] 012 [1] 013 [1] 014 [1] 015 
[    0.000000] pcpu-alloc: [1] 016 [1] 017 [1] 018 [1] 019 
[    0.000000] pcpu-alloc: [1] 020 [1] 021 [1] 022 [1] 023 
[    0.000000] pcpu-alloc: [1] 036 [1] 037 [1] 038 [1] 039 
[    0.000000] pcpu-alloc: [1] 040 [1] 041 [1] 042 [1] 043 
[    0.000000] pcpu-alloc: [1] 044 [1] 045 [1] 046 [1] 047 
[    0.000000] pcpu-alloc: [1] 049 [1] 051 [1] 053 [1] 055 
[    0.000000] pcpu-alloc: [1] 057 [1] 059 [1] 061 [1] 063 
[    0.000000] pcpu-alloc: [1] 065 [1] 067 [1] 069 [1] 071 
[    0.000000] pcpu-alloc: [1] 073 [1] 075 [1] 077 [1] 079 
[    0.000000] pcpu-alloc: [1] 081 [1] 083 [1] 085 [1] 087 
[    0.000000] pcpu-alloc: [1] 089 [1] 091 [1] 093 [1] 095 
[    0.000000] pcpu-alloc: [1] 097 [1] 099 [1] 101 [1] 103 
[    0.000000] pcpu-alloc: [1] 105 [1] 107 [1] 109 [1] 111 
[    0.000000] pcpu-alloc: [1] 113 [1] 115 [1] 117 [1] 119 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 16492647
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-ib03/cyclic_tcrypt-2s-500-504-HEAD.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/32f296837b2323b3c8d88e9e97135b2ed1de123f/vmlinuz-3.13.0-rc1-01248-g32f2968 kconfig=x86_64-lkp commit=32f296837b2323b3c8d88e9e97135b2ed1de123f modules_initrd=/kernel/x86_64-lkp/32f296837b2323b3c8d88e9e97135b2ed1de123f/modules.cgz nowatchdog rcupdate.rcu_cpu_stall_suppress=1 RESULT_ROOT=/lkp/result/lkp-ib03/crypto/tcrypt/2s-500-504/x86_64-lkp/32f296837b2323b3c8d88e9e97135b2ed1de123f/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::lkp-ib03:eth0:dhcp oops=panic log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 65439344K/67017832K available (10629K kernel code, 1395K rwdata, 5404K rodata, 3212K init, 9592K bss, 1578488K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=120, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=120.
[    0.000000] NR_IRQS:16640 nr_irqs:2456 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 268435456 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2693.498 MHz processor
[    0.000039] Calibrating delay loop (skipped), value calculated using timer frequency.. 5386.99 BogoMIPS (lpj=10773992)
[    0.022059] pid_max: default: 122880 minimum: 960
[    0.038356] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.065545] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.080965] Mount-cache hash table entries: 256
[    0.087141] Initializing cgroup subsys memory
[    0.092490] Initializing cgroup subsys blkio
[    0.097706] Initializing cgroup subsys perf_event
[    0.103430] Initializing cgroup subsys hugetlb
[    0.108960] CPU: Physical Processor ID: 0
[    0.113883] CPU: Processor Core ID: 1
[    0.119236] mce: CPU supports 29 MCE banks
[    0.124296] CPU0: Thermal LVT vector (0xfa) already installed
[    0.131183] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.131183] Last level dTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.131183] tlb_flushall_shift: 6
[    0.148585] Freeing SMP alternatives memory: 40K (ffffffff82681000 - ffffffff8268b000)
[    0.159582] ACPI: Core revision 20131115
[    0.222319] ACPI: All ACPI Tables successfully acquired
[    0.228774] ftrace: allocating 40035 entries in 157 pages
[    0.252330] Getting VERSION: 1060015
[    0.256770] Getting VERSION: 1060015
[    0.261207] Getting ID: 2000000
[    0.265160] Getting ID: 2000000
[    0.269114] Switched APIC routing to physical flat.
[    0.275012] masked ExtINT on CPU#0
[    0.279730] ENABLING IO-APIC IRQs
[    0.283876] init IO_APIC IRQs
[    0.287637]  apic 0 pin 0 not connected
[    0.292374] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:2)
[    0.302052] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:2)
[    0.311727] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:2)
[    0.321428] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:2)
[    0.331108] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:2)
[    0.340787] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:2)
[    0.350465] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:2)
[    0.360146] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:2)
[    0.369825] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:2)
[    0.379504] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:2)
[    0.389379] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:2)
[    0.399252] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:2)
[    0.409124] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:2)
[    0.418997] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:2)
[    0.428871] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:2)
[    0.438743]  apic 0 pin 16 not connected
[    0.443566]  apic 0 pin 17 not connected
[    0.448396]  apic 0 pin 18 not connected
[    0.453230]  apic 0 pin 19 not connected
[    0.458064]  apic 0 pin 20 not connected
[    0.462892]  apic 0 pin 21 not connected
[    0.467725]  apic 0 pin 22 not connected
[    0.472557]  apic 0 pin 23 not connected
[    0.477386]  apic 1 pin 0 not connected
[    0.482117]  apic 1 pin 1 not connected
[    0.486850]  apic 1 pin 2 not connected
[    0.491583]  apic 1 pin 3 not connected
[    0.496317]  apic 1 pin 4 not connected
[    0.501052]  apic 1 pin 5 not connected
[    0.505783]  apic 1 pin 6 not connected
[    0.510517]  apic 1 pin 7 not connected
[    0.515251]  apic 1 pin 8 not connected
[    0.519985]  apic 1 pin 9 not connected
[    0.524716]  apic 1 pin 10 not connected
[    0.529547]  apic 1 pin 11 not connected
[    0.534375]  apic 1 pin 12 not connected
[    0.539204]  apic 1 pin 13 not connected
[    0.544036]  apic 1 pin 14 not connected
[    0.548864]  apic 1 pin 15 not connected
[    0.553692]  apic 1 pin 16 not connected
[    0.558523]  apic 1 pin 17 not connected
[    0.563354]  apic 1 pin 18 not connected
[    0.568185]  apic 1 pin 19 not connected
[    0.573017]  apic 1 pin 20 not connected
[    0.577848]  apic 1 pin 21 not connected
[    0.582676]  apic 1 pin 22 not connected
[    0.587506]  apic 1 pin 23 not connected
[    0.592336]  apic 2 pin 0 not connected
[    0.597070]  apic 2 pin 1 not connected
[    0.601804]  apic 2 pin 2 not connected
[    0.606537]  apic 2 pin 3 not connected
[    0.611271]  apic 2 pin 4 not connected
[    0.616004]  apic 2 pin 5 not connected
[    0.620739]  apic 2 pin 6 not connected
[    0.625472]  apic 2 pin 7 not connected
[    0.630206]  apic 2 pin 8 not connected
[    0.634939]  apic 2 pin 9 not connected
[    0.639673]  apic 2 pin 10 not connected
[    0.644503]  apic 2 pin 11 not connected
[    0.649334]  apic 2 pin 12 not connected
[    0.654162]  apic 2 pin 13 not connected
[    0.658991]  apic 2 pin 14 not connected
[    0.663819]  apic 2 pin 15 not connected
[    0.668651]  apic 2 pin 16 not connected
[    0.673483]  apic 2 pin 17 not connected
[    0.678313]  apic 2 pin 18 not connected
[    0.683144]  apic 2 pin 19 not connected
[    0.687975]  apic 2 pin 20 not connected
[    0.692803]  apic 2 pin 21 not connected
[    0.697634]  apic 2 pin 22 not connected
[    0.702465]  apic 2 pin 23 not connected
[    0.707426] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.754253] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (fam: 06, model: 3e, stepping: 04)
[    0.765826] TSC deadline timer enabled
[    0.770610] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.783325] ... version:                3
[    0.788251] ... bit width:              48
[    0.793274] ... generic registers:      4
[    0.798200] ... value mask:             0000ffffffffffff
[    0.804585] ... max period:             0000ffffffffffff
[    0.810969] ... fixed-purpose events:   3
[    0.815895] ... event mask:             000000070000000f
[    0.826680] x86: Booting SMP configuration:
[    0.831806] .... node  #0, CPUs:          #1
[    0.847636] masked ExtINT on CPU#1
[    0.852284] CPU1: Thermal LVT vector (0xfa) already installed
   #2
[    0.872847] masked ExtINT on CPU#2
[    0.877523] CPU2: Thermal LVT vector (0xfa) already installed
   #3
[    0.898065] masked ExtINT on CPU#3
[    0.902746] CPU3: Thermal LVT vector (0xfa) already installed
   #4
[    0.923318] masked ExtINT on CPU#4
[    0.928012] CPU4: Thermal LVT vector (0xfa) already installed
   #5
[    0.948618] masked ExtINT on CPU#5
[    0.953315] CPU5: Thermal LVT vector (0xfa) already installed
   #6
[    0.973848] masked ExtINT on CPU#6
[    0.978530] CPU6: Thermal LVT vector (0xfa) already installed
   #7
[    0.999052] masked ExtINT on CPU#7
[    1.003734] CPU7: Thermal LVT vector (0xfa) already installed
   #8
[    1.024656] masked ExtINT on CPU#8
[    1.029315] CPU8: Thermal LVT vector (0xfa) already installed
   #9
[    1.049851] masked ExtINT on CPU#9
[    1.054505] CPU9: Thermal LVT vector (0xfa) already installed
  #10
[    1.074962] masked ExtINT on CPU#10
[    1.079706] CPU10: Thermal LVT vector (0xfa) already installed
  #11
[    1.100296] masked ExtINT on CPU#11
[    1.105038] CPU11: Thermal LVT vector (0xfa) already installed

[    1.114706] .... node  #1, CPUs:    #12
[    1.133744] masked ExtINT on CPU#12
[    1.138493] CPU12: Thermal LVT vector (0xfa) already installed
  #13
[    1.254379] masked ExtINT on CPU#13
[    1.259151] CPU13: Thermal LVT vector (0xfa) already installed
  #14
[    1.279662] masked ExtINT on CPU#14
[    1.284439] CPU14: Thermal LVT vector (0xfa) already installed
  #15
[    1.304916] masked ExtINT on CPU#15
[    1.309698] CPU15: Thermal LVT vector (0xfa) already installed
  #16
[    1.330212] masked ExtINT on CPU#16
[    1.335009] CPU16: Thermal LVT vector (0xfa) already installed
  #17
[    1.355474] masked ExtINT on CPU#17
[    1.360274] CPU17: Thermal LVT vector (0xfa) already installed
  #18
[    1.380751] masked ExtINT on CPU#18
[    1.385536] CPU18: Thermal LVT vector (0xfa) already installed
  #19
[    1.405991] masked ExtINT on CPU#19
[    1.410775] CPU19: Thermal LVT vector (0xfa) already installed
  #20
[    1.431633] masked ExtINT on CPU#20
[    1.436393] CPU20: Thermal LVT vector (0xfa) already installed
  #21
[    1.456900] masked ExtINT on CPU#21
[    1.461655] CPU21: Thermal LVT vector (0xfa) already installed
  #22
[    1.482060] masked ExtINT on CPU#22
[    1.486808] CPU22: Thermal LVT vector (0xfa) already installed
  #23
[    1.507247] masked ExtINT on CPU#23
[    1.511997] CPU23: Thermal LVT vector (0xfa) already installed

[    1.521493] .... node  #0, CPUs:    #24
[    1.537012] masked ExtINT on CPU#24
[    1.541756] CPU24: Thermal LVT vector (0xfa) already installed
  #25
[    1.562416] masked ExtINT on CPU#25
[    1.567197] CPU25: Thermal LVT vector (0xfa) already installed
  #26
[    1.587879] masked ExtINT on CPU#26
[    1.592649] CPU26: Thermal LVT vector (0xfa) already installed
  #27
[    1.613317] masked ExtINT on CPU#27
[    1.618095] CPU27: Thermal LVT vector (0xfa) already installed
  #28
[    1.638786] masked ExtINT on CPU#28
[    1.643577] CPU28: Thermal LVT vector (0xfa) already installed
  #29
[    1.664282] masked ExtINT on CPU#29
[    1.669065] CPU29: Thermal LVT vector (0xfa) already installed
  #30
[    1.689732] masked ExtINT on CPU#30
[    1.694510] CPU30: Thermal LVT vector (0xfa) already installed
  #31
[    1.715147] masked ExtINT on CPU#31
[    1.719924] CPU31: Thermal LVT vector (0xfa) already installed
  #32
[    1.740964] masked ExtINT on CPU#32
[    1.745720] CPU32: Thermal LVT vector (0xfa) already installed
  #33
[    1.766367] masked ExtINT on CPU#33
[    1.771108] CPU33: Thermal LVT vector (0xfa) already installed
  #34
[    1.791694] masked ExtINT on CPU#34
[    1.796438] CPU34: Thermal LVT vector (0xfa) already installed
  #35
[    1.817031] masked ExtINT on CPU#35
[    1.821766] CPU35: Thermal LVT vector (0xfa) already installed

[    1.831425] .... node  #1, CPUs:    #36
[    1.846774] masked ExtINT on CPU#36
[    1.851519] CPU36: Thermal LVT vector (0xfa) already installed
  #37
[    1.872066] masked ExtINT on CPU#37
[    1.876833] CPU37: Thermal LVT vector (0xfa) already installed
  #38
[    1.897367] masked ExtINT on CPU#38
[    1.902138] CPU38: Thermal LVT vector (0xfa) already installed
  #39
[    1.922621] masked ExtINT on CPU#39
[    1.927401] CPU39: Thermal LVT vector (0xfa) already installed
  #40
[    1.947940] masked ExtINT on CPU#40
[    1.952731] CPU40: Thermal LVT vector (0xfa) already installed
  #41
[    1.973200] masked ExtINT on CPU#41
[    1.977995] CPU41: Thermal LVT vector (0xfa) already installed
  #42
[    1.998479] masked ExtINT on CPU#42
[    2.003258] CPU42: Thermal LVT vector (0xfa) already installed
  #43
[    2.023734] masked ExtINT on CPU#43
[    2.028514] CPU43: Thermal LVT vector (0xfa) already installed
  #44
[    2.049386] masked ExtINT on CPU#44
[    2.054143] CPU44: Thermal LVT vector (0xfa) already installed
  #45
[    2.074667] masked ExtINT on CPU#45
[    2.079419] CPU45: Thermal LVT vector (0xfa) already installed
  #46
[    2.099836] masked ExtINT on CPU#46
[    2.104582] CPU46: Thermal LVT vector (0xfa) already installed
  #47
[    2.125000] masked ExtINT on CPU#47
[    2.129745] CPU47: Thermal LVT vector (0xfa) already installed

[    2.138452] x86: Booted up 2 nodes, 48 CPUs
[    2.144228] smpboot: Total of 48 processors activated (258653.83 BogoMIPS)
[    2.276601] CPU0 attaching sched-domain:
[    2.281447]  domain 0: span 0,25 level SIBLING
[    2.286934]   groups: 0 (cpu_power = 589) 25 (cpu_power = 589)
[    2.294306]   domain 1: span 0-11,24-35 level MC
[    2.299999]    groups: 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178)
[    2.334411]    domain 2: span 0-47 level NUMA
[    2.339810]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.349898] CPU1 attaching sched-domain:
[    2.354730]  domain 0: span 1,24 level SIBLING
[    2.360230]   groups: 1 (cpu_power = 589) 24 (cpu_power = 589)
[    2.367604]   domain 1: span 0-11,24-35 level MC
[    2.373297]    groups: 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178)
[    2.407720]    domain 2: span 0-47 level NUMA
[    2.413119]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.423206] CPU2 attaching sched-domain:
[    2.428030]  domain 0: span 2,26 level SIBLING
[    2.433528]   groups: 2 (cpu_power = 589) 26 (cpu_power = 589)
[    2.440901]   domain 1: span 0-11,24-35 level MC
[    2.446590]    groups: 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178)
[    2.481001]    domain 2: span 0-47 level NUMA
[    2.486395]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.496522] CPU3 attaching sched-domain:
[    2.501356]  domain 0: span 3,27 level SIBLING
[    2.506852]   groups: 3 (cpu_power = 589) 27 (cpu_power = 589)
[    2.514233]   domain 1: span 0-11,24-35 level MC
[    2.519927]    groups: 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178)
[    2.563516]    domain 2: span 0-47 level NUMA
[    2.568915]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.579004] CPU4 attaching sched-domain:
[    2.583836]  domain 0: span 4,28 level SIBLING
[    2.589323]   groups: 4 (cpu_power = 589) 28 (cpu_power = 589)
[    2.596701]   domain 1: span 0-11,24-35 level MC
[    2.602384]    groups: 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178)
[    2.636802]    domain 2: span 0-47 level NUMA
[    2.642190]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.652266] CPU5 attaching sched-domain:
[    2.657096]  domain 0: span 5,29 level SIBLING
[    2.662591]   groups: 5 (cpu_power = 589) 29 (cpu_power = 589)
[    2.669967]   domain 1: span 0-11,24-35 level MC
[    2.675651]    groups: 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178)
[    2.710069]    domain 2: span 0-47 level NUMA
[    2.715465]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.725544] CPU6 attaching sched-domain:
[    2.730377]  domain 0: span 6,30 level SIBLING
[    2.735871]   groups: 6 (cpu_power = 589) 30 (cpu_power = 589)
[    2.743250]   domain 1: span 0-11,24-35 level MC
[    2.748938]    groups: 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178)
[    2.783370]    domain 2: span 0-47 level NUMA
[    2.788768]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.798854] CPU7 attaching sched-domain:
[    2.803688]  domain 0: span 7,31 level SIBLING
[    2.809183]   groups: 7 (cpu_power = 589) 31 (cpu_power = 589)
[    2.816556]   domain 1: span 0-11,24-35 level MC
[    2.822246]    groups: 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178)
[    2.856673]    domain 2: span 0-47 level NUMA
[    2.862069]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.872150] CPU8 attaching sched-domain:
[    2.876984]  domain 0: span 8,32 level SIBLING
[    2.882478]   groups: 8 (cpu_power = 589) 32 (cpu_power = 589)
[    2.889845]   domain 1: span 0-11,24-35 level MC
[    2.895536]    groups: 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178)
[    2.929939]    domain 2: span 0-47 level NUMA
[    2.935337]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    2.945423] CPU9 attaching sched-domain:
[    2.950257]  domain 0: span 9,33 level SIBLING
[    2.955754]   groups: 9 (cpu_power = 589) 33 (cpu_power = 589)
[    2.963121]   domain 1: span 0-11,24-35 level MC
[    2.968810]    groups: 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178)
[    3.003224]    domain 2: span 0-47 level NUMA
[    3.008612]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    3.018679] CPU10 attaching sched-domain:
[    3.023609]  domain 0: span 10,34 level SIBLING
[    3.029201]   groups: 10 (cpu_power = 589) 34 (cpu_power = 589)
[    3.036673]   domain 1: span 0-11,24-35 level MC
[    3.042357]    groups: 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178)
[    3.076777]    domain 2: span 0-47 level NUMA
[    3.082175]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    3.092259] CPU11 attaching sched-domain:
[    3.097188]  domain 0: span 11,35 level SIBLING
[    3.102782]   groups: 11 (cpu_power = 589) 35 (cpu_power = 589)
[    3.110244]   domain 1: span 0-11,24-35 level MC
[    3.115934]    groups: 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178)
[    3.150335]    domain 2: span 0-47 level NUMA
[    3.155733]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    3.165816] CPU12 attaching sched-domain:
[    3.170743]  domain 0: span 12,36 level SIBLING
[    3.176336]   groups: 12 (cpu_power = 589) 36 (cpu_power = 589)
[    3.183807]   domain 1: span 12-23,36-47 level MC
[    3.189593]    groups: 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178)
[    3.225326]    domain 2: span 0-47 level NUMA
[    3.230721]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.240797] CPU13 attaching sched-domain:
[    3.245723]  domain 0: span 13,37 level SIBLING
[    3.251317]   groups: 13 (cpu_power = 589) 37 (cpu_power = 589)
[    3.258789]   domain 1: span 12-23,36-47 level MC
[    3.264574]    groups: 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178)
[    3.300326]    domain 2: span 0-47 level NUMA
[    3.305722]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.315811] CPU14 attaching sched-domain:
[    3.320741]  domain 0: span 14,38 level SIBLING
[    3.326325]   groups: 14 (cpu_power = 589) 38 (cpu_power = 589)
[    3.333788]   domain 1: span 12-23,36-47 level MC
[    3.339574]    groups: 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178)
[    3.375309]    domain 2: span 0-47 level NUMA
[    3.380707]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.390783] CPU15 attaching sched-domain:
[    3.395712]  domain 0: span 15,39 level SIBLING
[    3.401305]   groups: 15 (cpu_power = 589) 39 (cpu_power = 589)
[    3.408770]   domain 1: span 12-23,36-47 level MC
[    3.414557]    groups: 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178)
[    3.450267]    domain 2: span 0-47 level NUMA
[    3.455664]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.465749] CPU16 attaching sched-domain:
[    3.470669]  domain 0: span 16,40 level SIBLING
[    3.476265]   groups: 16 (cpu_power = 589) 40 (cpu_power = 589)
[    3.483732]   domain 1: span 12-23,36-47 level MC
[    3.489520]    groups: 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178)
[    3.525212]    domain 2: span 0-47 level NUMA
[    3.530606]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.540681] CPU17 attaching sched-domain:
[    3.545607]  domain 0: span 17,41 level SIBLING
[    3.551203]   groups: 17 (cpu_power = 589) 41 (cpu_power = 589)
[    3.558667]   domain 1: span 12-23,36-47 level MC
[    3.564448]    groups: 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178)
[    3.600160]    domain 2: span 0-47 level NUMA
[    3.605556]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.615627] CPU18 attaching sched-domain:
[    3.620558]  domain 0: span 18,42 level SIBLING
[    3.626148]   groups: 18 (cpu_power = 589) 42 (cpu_power = 589)
[    3.633619]   domain 1: span 12-23,36-47 level MC
[    3.639405]    groups: 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178)
[    3.675081]    domain 2: span 0-47 level NUMA
[    3.680478]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.690562] CPU19 attaching sched-domain:
[    3.695492]  domain 0: span 19,43 level SIBLING
[    3.701076]   groups: 19 (cpu_power = 589) 43 (cpu_power = 589)
[    3.717720]   domain 1: span 12-23,36-47 level MC
[    3.723498]    groups: 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178)
[    3.759208]    domain 2: span 0-47 level NUMA
[    3.764606]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.774691] CPU20 attaching sched-domain:
[    3.779621]  domain 0: span 20,44 level SIBLING
[    3.785212]   groups: 20 (cpu_power = 589) 44 (cpu_power = 589)
[    3.792683]   domain 1: span 12-23,36-47 level MC
[    3.798470]    groups: 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178)
[    3.834205]    domain 2: span 0-47 level NUMA
[    3.839600]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.849682] CPU21 attaching sched-domain:
[    3.854611]  domain 0: span 21,45 level SIBLING
[    3.860205]   groups: 21 (cpu_power = 589) 45 (cpu_power = 589)
[    3.867679]   domain 1: span 12-23,36-47 level MC
[    3.873465]    groups: 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178)
[    3.909204]    domain 2: span 0-47 level NUMA
[    3.914598]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.924679] CPU22 attaching sched-domain:
[    3.929609]  domain 0: span 22,46 level SIBLING
[    3.935193]   groups: 22 (cpu_power = 589) 46 (cpu_power = 589)
[    3.942667]   domain 1: span 12-23,36-47 level MC
[    3.948447]    groups: 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178)
[    3.984174]    domain 2: span 0-47 level NUMA
[    3.989572]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    3.999645] CPU23 attaching sched-domain:
[    4.004572]  domain 0: span 23,47 level SIBLING
[    4.010164]   groups: 23 (cpu_power = 589) 47 (cpu_power = 589)
[    4.017641]   domain 1: span 12-23,36-47 level MC
[    4.023427]    groups: 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178)
[    4.059138]    domain 2: span 0-47 level NUMA
[    4.064537]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    4.074623] CPU24 attaching sched-domain:
[    4.079554]  domain 0: span 1,24 level SIBLING
[    4.085040]   groups: 24 (cpu_power = 589) 1 (cpu_power = 589)
[    4.092413]   domain 1: span 0-11,24-35 level MC
[    4.098102]    groups: 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178)
[    4.132477]    domain 2: span 0-47 level NUMA
[    4.137863]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.147946] CPU25 attaching sched-domain:
[    4.152878]  domain 0: span 0,25 level SIBLING
[    4.158370]   groups: 25 (cpu_power = 589) 0 (cpu_power = 589)
[    4.165744]   domain 1: span 0-11,24-35 level MC
[    4.171427]    groups: 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178)
[    4.205826]    domain 2: span 0-47 level NUMA
[    4.211220]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.221300] CPU26 attaching sched-domain:
[    4.226228]  domain 0: span 2,26 level SIBLING
[    4.231722]   groups: 26 (cpu_power = 589) 2 (cpu_power = 589)
[    4.239098]   domain 1: span 0-11,24-35 level MC
[    4.244788]    groups: 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178)
[    4.279187]    domain 2: span 0-47 level NUMA
[    4.284582]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.294662] CPU27 attaching sched-domain:
[    4.299591]  domain 0: span 3,27 level SIBLING
[    4.305078]   groups: 27 (cpu_power = 589) 3 (cpu_power = 589)
[    4.312454]   domain 1: span 0-11,24-35 level MC
[    4.318137]    groups: 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178)
[    4.352526]    domain 2: span 0-47 level NUMA
[    4.357923]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.368009] CPU28 attaching sched-domain:
[    4.372938]  domain 0: span 4,28 level SIBLING
[    4.378433]   groups: 28 (cpu_power = 589) 4 (cpu_power = 589)
[    4.385805]   domain 1: span 0-11,24-35 level MC
[    4.391493]    groups: 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178)
[    4.425894]    domain 2: span 0-47 level NUMA
[    4.431291]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.441376] CPU29 attaching sched-domain:
[    4.446304]  domain 0: span 5,29 level SIBLING
[    4.451798]   groups: 29 (cpu_power = 589) 5 (cpu_power = 589)
[    4.459177]   domain 1: span 0-11,24-35 level MC
[    4.464864]    groups: 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178)
[    4.499247]    domain 2: span 0-47 level NUMA
[    4.504646]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.514733] CPU30 attaching sched-domain:
[    4.519661]  domain 0: span 6,30 level SIBLING
[    4.525155]   groups: 30 (cpu_power = 589) 6 (cpu_power = 589)
[    4.532528]   domain 1: span 0-11,24-35 level MC
[    4.538216]    groups: 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178)
[    4.572630]    domain 2: span 0-47 level NUMA
[    4.578027]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.588109] CPU31 attaching sched-domain:
[    4.593038]  domain 0: span 7,31 level SIBLING
[    4.598533]   groups: 31 (cpu_power = 589) 7 (cpu_power = 589)
[    4.605909]   domain 1: span 0-11,24-35 level MC
[    4.611600]    groups: 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178)
[    4.645986]    domain 2: span 0-47 level NUMA
[    4.651382]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.661455] CPU32 attaching sched-domain:
[    4.666382]  domain 0: span 8,32 level SIBLING
[    4.671876]   groups: 32 (cpu_power = 589) 8 (cpu_power = 589)
[    4.679252]   domain 1: span 0-11,24-35 level MC
[    4.684940]    groups: 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178)
[    4.719334]    domain 2: span 0-47 level NUMA
[    4.724731]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.734810] CPU33 attaching sched-domain:
[    4.739737]  domain 0: span 9,33 level SIBLING
[    4.745234]   groups: 33 (cpu_power = 589) 9 (cpu_power = 589)
[    4.752609]   domain 1: span 0-11,24-35 level MC
[    4.758298]    groups: 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178)
[    4.792696]    domain 2: span 0-47 level NUMA
[    4.798093]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.808168] CPU34 attaching sched-domain:
[    4.813097]  domain 0: span 10,34 level SIBLING
[    4.818693]   groups: 34 (cpu_power = 589) 10 (cpu_power = 589)
[    4.826166]   domain 1: span 0-11,24-35 level MC
[    4.831855]    groups: 10,34 (cpu_power = 1178) 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178)
[    4.866259]    domain 2: span 0-47 level NUMA
[    4.871655]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.881730] CPU35 attaching sched-domain:
[    4.886658]  domain 0: span 11,35 level SIBLING
[    4.901404]   groups: 35 (cpu_power = 589) 11 (cpu_power = 589)
[    4.908867]   domain 1: span 0-11,24-35 level MC
[    4.914555]    groups: 11,35 (cpu_power = 1178) 0,25 (cpu_power = 1178) 1,24 (cpu_power = 1178) 2,26 (cpu_power = 1178) 3,27 (cpu_power = 1178) 4,28 (cpu_power = 1178) 5,29 (cpu_power = 1178) 6,30 (cpu_power = 1178) 7,31 (cpu_power = 1178) 8,32 (cpu_power = 1178) 9,33 (cpu_power = 1178) 10,34 (cpu_power = 1178)
[    4.948948]    domain 2: span 0-47 level NUMA
[    4.954345]     groups: 0-11,24-35 (cpu_power = 14136) 12-23,36-47 (cpu_power = 14136)
[    4.964419] CPU36 attaching sched-domain:
[    4.969350]  domain 0: span 12,36 level SIBLING
[    4.974942]   groups: 36 (cpu_power = 589) 12 (cpu_power = 589)
[    4.982414]   domain 1: span 12-23,36-47 level MC
[    4.988200]    groups: 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178)
[    5.023915]    domain 2: span 0-47 level NUMA
[    5.029313]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.039396] CPU37 attaching sched-domain:
[    5.044323]  domain 0: span 13,37 level SIBLING
[    5.049915]   groups: 37 (cpu_power = 589) 13 (cpu_power = 589)
[    5.057386]   domain 1: span 12-23,36-47 level MC
[    5.063172]    groups: 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178)
[    5.098936]    domain 2: span 0-47 level NUMA
[    5.104334]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.114418] CPU38 attaching sched-domain:
[    5.119349]  domain 0: span 14,38 level SIBLING
[    5.124940]   groups: 38 (cpu_power = 589) 14 (cpu_power = 589)
[    5.132408]   domain 1: span 12-23,36-47 level MC
[    5.138193]    groups: 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178)
[    5.173926]    domain 2: span 0-47 level NUMA
[    5.179321]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.189404] CPU39 attaching sched-domain:
[    5.194334]  domain 0: span 15,39 level SIBLING
[    5.199924]   groups: 39 (cpu_power = 589) 15 (cpu_power = 589)
[    5.207397]   domain 1: span 12-23,36-47 level MC
[    5.213182]    groups: 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178)
[    5.248874]    domain 2: span 0-47 level NUMA
[    5.254272]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.264358] CPU40 attaching sched-domain:
[    5.269289]  domain 0: span 16,40 level SIBLING
[    5.274881]   groups: 40 (cpu_power = 589) 16 (cpu_power = 589)
[    5.282358]   domain 1: span 12-23,36-47 level MC
[    5.288145]    groups: 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178)
[    5.323877]    domain 2: span 0-47 level NUMA
[    5.329274]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.339346] CPU41 attaching sched-domain:
[    5.344274]  domain 0: span 17,41 level SIBLING
[    5.349866]   groups: 41 (cpu_power = 589) 17 (cpu_power = 589)
[    5.357328]   domain 1: span 12-23,36-47 level MC
[    5.363116]    groups: 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178)
[    5.398861]    domain 2: span 0-47 level NUMA
[    5.404249]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.414324] CPU42 attaching sched-domain:
[    5.419256]  domain 0: span 18,42 level SIBLING
[    5.424838]   groups: 42 (cpu_power = 589) 18 (cpu_power = 589)
[    5.432312]   domain 1: span 12-23,36-47 level MC
[    5.438092]    groups: 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178)
[    5.473784]    domain 2: span 0-47 level NUMA
[    5.479179]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.489256] CPU43 attaching sched-domain:
[    5.494189]  domain 0: span 19,43 level SIBLING
[    5.499783]   groups: 43 (cpu_power = 589) 19 (cpu_power = 589)
[    5.507254]   domain 1: span 12-23,36-47 level MC
[    5.513042]    groups: 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178)
[    5.548769]    domain 2: span 0-47 level NUMA
[    5.554164]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.564247] CPU44 attaching sched-domain:
[    5.569177]  domain 0: span 20,44 level SIBLING
[    5.574767]   groups: 44 (cpu_power = 589) 20 (cpu_power = 589)
[    5.582241]   domain 1: span 12-23,36-47 level MC
[    5.588027]    groups: 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178)
[    5.623740]    domain 2: span 0-47 level NUMA
[    5.629137]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.639218] CPU45 attaching sched-domain:
[    5.644144]  domain 0: span 21,45 level SIBLING
[    5.649738]   groups: 45 (cpu_power = 589) 21 (cpu_power = 589)
[    5.657211]   domain 1: span 12-23,36-47 level MC
[    5.662999]    groups: 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178)
[    5.698679]    domain 2: span 0-47 level NUMA
[    5.704077]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.714151] CPU46 attaching sched-domain:
[    5.719077]  domain 0: span 22,46 level SIBLING
[    5.724669]   groups: 46 (cpu_power = 589) 22 (cpu_power = 589)
[    5.732138]   domain 1: span 12-23,36-47 level MC
[    5.737927]    groups: 22,46 (cpu_power = 1178) 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178)
[    5.773645]    domain 2: span 0-47 level NUMA
[    5.779045]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.789114] CPU47 attaching sched-domain:
[    5.794041]  domain 0: span 23,47 level SIBLING
[    5.799636]   groups: 47 (cpu_power = 589) 23 (cpu_power = 589)
[    5.807108]   domain 1: span 12-23,36-47 level MC
[    5.812894]    groups: 23,47 (cpu_power = 1178) 12,36 (cpu_power = 1178) 13,37 (cpu_power = 1178) 14,38 (cpu_power = 1178) 15,39 (cpu_power = 1178) 16,40 (cpu_power = 1178) 17,41 (cpu_power = 1178) 18,42 (cpu_power = 1178) 19,43 (cpu_power = 1178) 20,44 (cpu_power = 1178) 21,45 (cpu_power = 1178) 22,46 (cpu_power = 1178)
[    5.848616]    domain 2: span 0-47 level NUMA
[    5.854012]     groups: 12-23,36-47 (cpu_power = 14136) 0-11,24-35 (cpu_power = 14136)
[    5.865784] devtmpfs: initialized
[    5.885181] PM: Registering ACPI NVS region [mem 0xbaca6000-0xbb049fff] (3817472 bytes)
[    5.895017] PM: Registering ACPI NVS region [mem 0xbd957000-0xbdb5bfff] (2117632 bytes)
[    5.904832] PM: Registering ACPI NVS region [mem 0xbdde7000-0xbde2cfff] (286720 bytes)
[    5.914515] PM: Registering ACPI NVS region [mem 0xbdf01000-0xbdf01fff] (4096 bytes)
[    5.923996] PM: Registering ACPI NVS region [mem 0xbdf20000-0xbdffffff] (917504 bytes)
[    5.935633] xor: automatically using best checksumming function:
[    5.982813]    avx       : 20185.000 MB/sec
[    5.987959] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    5.996351] NET: Registered protocol family 16
[    6.002913] cpuidle: using governor ladder
[    6.007942] cpuidle: using governor menu
[    6.013300] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    6.022598] ACPI: bus type PCI registered
[    6.027530] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    6.035366] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    6.046607] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    6.075602] PCI: Using configuration type 1 for base access
[    6.113099] bio: create slab <bio-0> at 0
[    6.186066] raid6: sse2x1    5885 MB/s
[    6.267949] raid6: sse2x2    7542 MB/s
[    6.340615] raid6: sse2x4   10215 MB/s
[    6.345252] raid6: using algorithm sse2x4 (10215 MB/s)
[    6.351443] raid6: using ssse3x2 recovery algorithm
[    6.357830] ACPI: Added _OSI(Module Device)
[    6.362954] ACPI: Added _OSI(Processor Device)
[    6.368370] ACPI: Added _OSI(3.0 _SCP Extensions)
[    6.374066] ACPI: Added _OSI(Processor Aggregator Device)
[    6.482025] ACPI: Executed 1 blocks of module-level executable AML code
[    6.740803] ACPI: Interpreter enabled
[    6.745358] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    6.756675] ACPI: (supports S0 S1 S3 S4 S5)
[    6.761797] ACPI: Using IOAPIC for interrupt routing
[    6.767939] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    6.783395] ACPI: No dock devices found.
[    6.882115] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    6.889480] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.899667] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    6.908764] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    6.917383] ACPI: \_SB_.PCI0.PDRC: can't evaluate _ADR (0x5)
[    6.924162] ACPI: \_SB_.PCI0.VTRC: can't evaluate _ADR (0x5)
[    6.931007] PCI host bridge to bus 0000:00
[    6.936034] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x38007fffffff]
[    6.945319] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xebffffff]
[    6.953455] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    6.961591] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    6.969728] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    6.977863] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    6.985998] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    6.994133] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    7.002268] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    7.010402] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    7.018539] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    7.026674] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    7.034809] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    7.042946] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    7.051081] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    7.059217] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    7.067353] pci_bus 0000:00: root bus resource [io  0x0000-0xbfff]
[    7.074712] pci_bus 0000:00: root bus resource [bus 00-7e]
[    7.081304] pci 0000:00:00.0: [8086:0e00] type 00 class 0x060000
[    7.088559] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    7.096052] pci 0000:00:01.0: [8086:0e02] type 01 class 0x060400
[    7.103310] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    7.110689] pci 0000:00:01.0: System wakeup disabled by ACPI
[    7.117580] pci 0000:00:01.1: [8086:0e03] type 01 class 0x060400
[    7.124835] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    7.132210] pci 0000:00:01.1: System wakeup disabled by ACPI
[    7.139095] pci 0000:00:02.0: [8086:0e04] type 01 class 0x060400
[    7.146350] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    7.153726] pci 0000:00:02.0: System wakeup disabled by ACPI
[    7.160606] pci 0000:00:02.2: [8086:0e06] type 01 class 0x060400
[    7.167860] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[    7.175235] pci 0000:00:02.2: System wakeup disabled by ACPI
[    7.182119] pci 0000:00:03.0: [8086:0e08] type 01 class 0x060400
[    7.189376] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    7.196751] pci 0000:00:03.0: System wakeup disabled by ACPI
[    7.203628] pci 0000:00:03.2: [8086:0e0a] type 01 class 0x060400
[    7.210882] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    7.218264] pci 0000:00:03.2: System wakeup disabled by ACPI
[    7.225143] pci 0000:00:04.0: [8086:0e20] type 00 class 0x088000
[    7.232326] pci 0000:00:04.0: reg 0x10: [mem 0xebf90000-0xebf93fff 64bit]
[    7.240647] pci 0000:00:04.1: [8086:0e21] type 00 class 0x088000
[    7.247830] pci 0000:00:04.1: reg 0x10: [mem 0xebf80000-0xebf83fff 64bit]
[    7.256148] pci 0000:00:04.2: [8086:0e22] type 00 class 0x088000
[    7.263329] pci 0000:00:04.2: reg 0x10: [mem 0xebf70000-0xebf73fff 64bit]
[    7.271644] pci 0000:00:04.3: [8086:0e23] type 00 class 0x088000
[    7.278826] pci 0000:00:04.3: reg 0x10: [mem 0xebf60000-0xebf63fff 64bit]
[    7.287143] pci 0000:00:04.4: [8086:0e24] type 00 class 0x088000
[    7.294325] pci 0000:00:04.4: reg 0x10: [mem 0xebf50000-0xebf53fff 64bit]
[    7.302642] pci 0000:00:04.5: [8086:0e25] type 00 class 0x088000
[    7.309825] pci 0000:00:04.5: reg 0x10: [mem 0xebf40000-0xebf43fff 64bit]
[    7.318136] pci 0000:00:04.6: [8086:0e26] type 00 class 0x088000
[    7.325318] pci 0000:00:04.6: reg 0x10: [mem 0xebf30000-0xebf33fff 64bit]
[    7.333636] pci 0000:00:04.7: [8086:0e27] type 00 class 0x088000
[    7.340819] pci 0000:00:04.7: reg 0x10: [mem 0xebf20000-0xebf23fff 64bit]
[    7.349136] pci 0000:00:05.0: [8086:0e28] type 00 class 0x088000
[    7.356555] pci 0000:00:05.1: [8086:0e29] type 00 class 0x088000
[    7.364000] pci 0000:00:05.2: [8086:0e2a] type 00 class 0x088000
[    7.371418] pci 0000:00:05.4: [8086:0e2c] type 00 class 0x080020
[    7.378599] pci 0000:00:05.4: reg 0x10: [mem 0xd0e60000-0xd0e60fff]
[    7.386331] pci 0000:00:05.6: [8086:0e39] type 00 class 0x110100
[    7.393750] pci 0000:00:06.0: [8086:0e10] type 00 class 0x088000
[    7.401166] pci 0000:00:06.1: [8086:0e11] type 00 class 0x088000
[    7.408584] pci 0000:00:06.2: [8086:0e12] type 00 class 0x088000
[    7.416009] pci 0000:00:06.3: [8086:0e13] type 00 class 0x088000
[    7.423429] pci 0000:00:06.4: [8086:0e14] type 00 class 0x088000
[    7.430855] pci 0000:00:06.5: [8086:0e15] type 00 class 0x088000
[    7.438276] pci 0000:00:06.6: [8086:0e16] type 00 class 0x088000
[    7.445691] pci 0000:00:06.7: [8086:0e17] type 00 class 0x088000
[    7.453114] pci 0000:00:07.0: [8086:0e18] type 00 class 0x088000
[    7.460525] pci 0000:00:07.1: [8086:0e19] type 00 class 0x088000
[    7.467945] pci 0000:00:07.2: [8086:0e1a] type 00 class 0x088000
[    7.475369] pci 0000:00:07.3: [8086:0e1b] type 00 class 0x088000
[    7.482787] pci 0000:00:07.4: [8086:0e1c] type 00 class 0x088000
[    7.490244] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[    7.497425] pci 0000:00:1a.0: reg 0x10: [mem 0xd0e20000-0xd0e203ff]
[    7.505001] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    7.512398] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    7.519277] pci 0000:00:1c.0: [8086:1d10] type 01 class 0x060400
[    7.526552] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    7.533932] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    7.540816] pci 0000:00:1c.7: [8086:1d1e] type 01 class 0x060400
[    7.548089] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    7.555466] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    7.562350] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[    7.569540] pci 0000:00:1d.0: reg 0x10: [mem 0xd0e10000-0xd0e103ff]
[    7.577114] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    7.584513] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    7.591397] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    7.598734] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    7.605613] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
[    7.613107] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
[    7.620301] pci 0000:00:1f.2: reg 0x10: [io  0x5070-0x5077]
[    7.626989] pci 0000:00:1f.2: reg 0x14: [io  0x5060-0x5063]
[    7.633675] pci 0000:00:1f.2: reg 0x18: [io  0x5050-0x5057]
[    7.640363] pci 0000:00:1f.2: reg 0x1c: [io  0x5040-0x5043]
[    7.647041] pci 0000:00:1f.2: reg 0x20: [io  0x5020-0x503f]
[    7.653728] pci 0000:00:1f.2: reg 0x24: [mem 0xd0e00000-0xd0e007ff]
[    7.661249] pci 0000:00:1f.2: PME# supported from D3hot
[    7.667747] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[    7.674933] pci 0000:00:1f.3: reg 0x10: [mem 0xebf10000-0xebf100ff 64bit]
[    7.682998] pci 0000:00:1f.3: reg 0x20: [io  0x5000-0x501f]
[    7.689900] pci 0000:00:1f.6: [8086:1d24] type 00 class 0x118000
[    7.697090] pci 0000:00:1f.6: reg 0x10: [mem 0xebf00000-0xebf00fff 64bit]
[    7.705536] pci 0000:01:00.0: [8086:1d74] type 01 class 0x060400
[    7.712714] pci 0000:01:00.0: reg 0x10: [mem 0xd0c00000-0xd0c03fff]
[    7.720244] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    7.735519] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    7.741818] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    7.749085] pci 0000:00:01.0:   bridge window [mem 0xd0b00000-0xd0cfffff]
[    7.757132] pci 0000:00:01.0:   bridge window [mem 0xeb000000-0xeb9fffff 64bit pref]
[    7.766747] pci 0000:02:08.0: [8086:1d3f] type 01 class 0x060400
[    7.774023] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    7.781306] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[    7.791041] IP: [<ffffffff8154f5e5>] acpi_find_child_device+0x23/0xc3
[    7.798776] PGD 0 
[    7.801547] Oops: 0000 [#1] SMP 
[    7.805759] Modules linked in:
[    7.809698] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-01248-g32f2968 #1874
[    7.819272] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.R3.27.D685.1305151734 05/15/2013
[    7.831275] task: ffff88080cd98000 ti: ffff88080cda0000 task.ti: ffff88080cda0000
[    7.840461] RIP: 0010:[<ffffffff8154f5e5>]  [<ffffffff8154f5e5>] acpi_find_child_device+0x23/0xc3
[    7.851282] RSP: 0000:ffff88080cda19b0  EFLAGS: 00010282
[    7.857666] RAX: ffff88080ba52098 RBX: ffff88080cda1a18 RCX: 0000000000000000
[    7.866089] RDX: 0000000000000001 RSI: 0000000000080000 RDI: 0000000000000000
[    7.874512] RBP: ffff88080cda19e8 R08: 0000000000000000 R09: 0000000000000000
[    7.882935] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[    7.891361] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000080000
[    7.899785] FS:  0000000000000000(0000) GS:ffff880818a00000(0000) knlGS:0000000000000000
[    7.909652] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.916521] CR2: 0000000000000018 CR3: 000000000220c000 CR4: 00000000001407e0
[    7.924945] Stack:
[    7.927632]  ffffffff81550091 ffff88080ba53098 ffff88080cda1a18 ffff88080ba53098
[    7.937044]  ffffffff822b6a70 ffff88080ba52098 ffff88080ba43000 ffff88080cda1a00
[    7.946443]  ffffffff81548f73 ffff88080ba53098 ffff88080cda1a30 ffffffff8154fac6
[    7.955843] Call Trace:
[    7.959021]  [<ffffffff81550091>] ? acpi_bus_get_device+0x21/0x3e
[    7.966281]  [<ffffffff81548f73>] acpi_pci_find_device+0x3c/0x54
[    7.973442]  [<ffffffff8154fac6>] acpi_platform_notify+0x3a/0x6c
[    7.980603]  [<ffffffff815b671b>] device_add+0x143/0x550
[    7.986988]  [<ffffffff8152f2f8>] pci_device_add+0x123/0x13f
[    7.993760]  [<ffffffff81a3a444>] pci_scan_single_device+0x93/0x9e
[    8.001118]  [<ffffffff8152f36b>] pci_scan_slot+0x57/0x108
[    8.007696]  [<ffffffff8152fec0>] pci_scan_child_bus+0x53/0x10d
[    8.023921]  [<ffffffff8152fb53>] pci_scan_bridge+0x1d2/0x4ec
[    8.030792]  [<ffffffff8152ff32>] pci_scan_child_bus+0xc5/0x10d
[    8.037848]  [<ffffffff8152fb53>] pci_scan_bridge+0x1d2/0x4ec
[    8.044718]  [<ffffffff81a3a3f2>] ? pci_scan_single_device+0x41/0x9e
[    8.052268]  [<ffffffff8152ff32>] pci_scan_child_bus+0xc5/0x10d
[    8.059327]  [<ffffffff8191f767>] pci_acpi_scan_root+0x31f/0x3aa
[    8.066488]  [<ffffffff8155593d>] acpi_pci_root_add+0x35e/0x45a
[    8.073554]  [<ffffffff81551dcc>] acpi_bus_attach+0x86/0xf6
[    8.080220]  [<ffffffff81551e28>] acpi_bus_attach+0xe2/0xf6
[    8.086896]  [<ffffffff81551e28>] acpi_bus_attach+0xe2/0xf6
[    8.093573]  [<ffffffff81551e97>] acpi_bus_scan+0x5b/0x6b
[    8.100059]  [<ffffffff82578b47>] ? acpi_sleep_proc_init+0x2a/0x2a
[    8.107414]  [<ffffffff82578f48>] acpi_scan_init+0x61/0x18f
[    8.114090]  [<ffffffff82578b47>] ? acpi_sleep_proc_init+0x2a/0x2a
[    8.121435]  [<ffffffff82578d96>] acpi_init+0x24f/0x267
[    8.127724]  [<ffffffff810002ba>] do_one_initcall+0xa4/0x13a
[    8.134497]  [<ffffffff810e28cc>] ? parse_args+0x261/0x33f
[    8.141081]  [<ffffffff82533fd0>] kernel_init_freeable+0x1d9/0x25f
[    8.148438]  [<ffffffff82533785>] ? do_early_param+0x88/0x88
[    8.155209]  [<ffffffff81a37d99>] ? rest_init+0xcd/0xcd
[    8.161496]  [<ffffffff81a37da7>] kernel_init+0xe/0x109
[    8.167782]  [<ffffffff81a5c0fc>] ret_from_fork+0x7c/0xb0
[    8.174263]  [<ffffffff81a37d99>] ? rest_init+0xcd/0xcd
[    8.180550] Code: ff ff 5a 5b 41 5c 5d c3 0f 1f 44 00 00 55 48 89 e5 41 57 49 89 f7 41 56 45 31 f6 41 55 44 0f b6 ea 41 54 45 31 e4 53 48 83 ec 10 <48> 8b 47 18 48 8d 58 d8 48 8d 47 18 48 89 45 c8 48 8d 43 28 48 
[    8.208097] RIP  [<ffffffff8154f5e5>] acpi_find_child_device+0x23/0xc3
[    8.215920]  RSP <ffff88080cda19b0>
[    8.220261] CR2: 0000000000000018
[    8.224413] ---[ end trace 56dc910562aec71f ]---
[    8.230019] Kernel panic - not syncing: Fatal exception

--a8Wt8u1KmwUX3Y2C--
