Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaHSNKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:10:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:47487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaHSNKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="578736886"
Date: Tue, 19 Aug 2014 21:10:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: [irq] BUG: unable to handle kernel NULL pointer dereference at (null)
Message-ID: <20140819131027.GA27766@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Will,

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git irq
commit f6a4fe388d2fcb57eb0d9ea58342a8d46f70c57d ("irq: allow percpu_devid interrupts to be requested with target mask")

+---------------------------------------------------------+-----------+------------+
|                                                         | v3.17-rc1 | f6a4fe388d |
+---------------------------------------------------------+-----------+------------+
| boot_successes                                          | 367       | 0          |
| boot_failures                                           | 2         | 15         |
| BUG:kernel_test_crashed                                 | 1         |            |
| WARNING:CPU:PID:at_mm/early_ioremap.c:__early_ioremap() | 1         | 10         |
| backtrace:acpi_initialize_tables                        | 1         | 10         |
| backtrace:acpi_table_init                               | 1         | 10         |
| backtrace:acpi_boot_table_init                          | 1         | 10         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference    | 0         | 5          |
| Oops                                                    | 0         | 5          |
| RIP:__bitmap_intersects                                 | 0         | 5          |
| Kernel_panic-not_syncing:Fatal_exception                | 0         | 5          |
| backtrace:pcie_port_service_register                    | 0         | 5          |
| backtrace:pcie_pme_service_init                         | 0         | 5          |
| backtrace:kernel_init_freeable                          | 0         | 5          |
+---------------------------------------------------------+-----------+------------+


[    9.185399] aer 0000:00:02.0:pcie02: service driver aer loaded
[    9.191430] aer 0000:00:03.0:pcie02: service driver aer loaded
[    9.197460] aer 0000:00:04.0:pcie02: service driver aer loaded
[    9.203486] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    9.211673] IP: [<ffffffff813f0859>] __bitmap_intersects+0x49/0x80
[    9.218069] PGD 0 
[    9.220288] Oops: 0000 [#1] SMP 
[    9.223809] Modules linked in:
[    9.227078] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1-00898-g9426769 #1
[    9.234842] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Double Cove , BIOS BWDEXT.86B.000.012.D127 10/08/2012
[    9.246432] task: ffff880234180000 ti: ffff88023417c000 task.ti: ffff88023417c000
[    9.254109] RIP: 0010:[<ffffffff813f0859>]  [<ffffffff813f0859>] __bitmap_intersects+0x49/0x80
[    9.263001] RSP: 0000:ffff88023417fc18  EFLAGS: 00010002
[    9.268444] RAX: 0000000000000000 RBX: ffff880222b49a00 RCX: 0000000000000004
[    9.275716] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff880222bac800
[    9.282989] RBP: ffff88023417fc18 R08: 0000000000000246 R09: 0000000000000000
[    9.290258] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[    9.297523] R13: 0000000000000018 R14: ffff8800b1de7900 R15: ffff880222b49200
[    9.304796] FS:  0000000000000000(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
[    9.313080] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    9.318956] CR2: 0000000000000000 CR3: 0000000001c2c000 CR4: 00000000000007e0
[    9.326228] Stack:
[    9.328369]  ffff88023417fc68 ffffffff810c6117 0000000000000246 ffff8800b1de798c
[    9.336299]  ffff880222bac800 ffffffff8142eab0 0000000000000080 0000000000000018
[    9.344211]  ffff880225d83800 ffff8800b1de7900 ffff88023417fcb0 ffffffff810c65bc
[    9.352124] Call Trace:
[    9.354707]  [<ffffffff810c6117>] __setup_irq+0x297/0x5e0
[    9.360250]  [<ffffffff8142eab0>] ? pcie_pme_probe+0x1c0/0x1c0
[    9.366222]  [<ffffffff810c65bc>] request_threaded_irq+0xcc/0x170
[    9.372453]  [<ffffffff8142e98c>] pcie_pme_probe+0x9c/0x1c0
[    9.378164]  [<ffffffff8142b1e2>] pcie_port_probe_service+0x32/0x80
[    9.384572]  [<ffffffff814ee6c0>] driver_probe_device+0x90/0x3c0
[    9.390714]  [<ffffffff814eeac3>] __driver_attach+0x93/0xa0
[    9.396424]  [<ffffffff814eea30>] ? __device_attach+0x40/0x40
[    9.402302]  [<ffffffff814ec743>] bus_for_each_dev+0x63/0xa0
[    9.408101]  [<ffffffff814ee15e>] driver_attach+0x1e/0x20
[    9.413630]  [<ffffffff814edd70>] bus_add_driver+0x180/0x250
[    9.419429]  [<ffffffff81e0d00f>] ? pcie_pme_setup+0x27/0x27
[    9.425225]  [<ffffffff814ef294>] driver_register+0x64/0xf0
[    9.430931]  [<ffffffff8142b146>] pcie_port_service_register+0x46/0x50
[    9.437594]  [<ffffffff81e0d01f>] pcie_pme_service_init+0x10/0x12
[    9.443827]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.449626]  [<ffffffff8108bd55>] ? parse_args+0x235/0x450
[    9.455252]  [<ffffffff81dc4231>] kernel_init_freeable+0x1a0/0x22b
[    9.461567]  [<ffffffff81dc3990>] ? initcall_blacklist+0xb0/0xb0
[    9.467707]  [<ffffffff8182ff20>] ? rest_init+0x90/0x90
[    9.473068]  [<ffffffff8182ff2e>] kernel_init+0xe/0xf0
[    9.478341]  [<ffffffff81849bbc>] ret_from_fork+0x7c/0xb0
[    9.483877]  [<ffffffff8182ff20>] ? rest_init+0x90/0x90
[    9.489230] Code: 14 90 4c 8b 44 06 08 4c 23 44 07 08 48 83 c0 08 4d 85 c0 75 35 41 83 c1 01 45 39 d1 75 e4 89 d1 31 c0 83 e1 3f 74 1d 4a 8b 04 cf <4a> 23 04 ce be 01 00 00 00 48 d3 e6 48 83 ee 01 48 85 f0 0f 95 
[    9.513695] RIP  [<ffffffff813f0859>] __bitmap_intersects+0x49/0x80
[    9.520180]  RSP <ffff88023417fc18>
[    9.523804] CR2: 0000000000000000
[    9.527265] ---[ end trace 2b176a518018b253 ]---
[    9.532011] Kernel panic - not syncing: Fatal exception

Thanks,
Fengguang

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc1-00898-g9426769 (kbuild@ivytown2) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Tue Aug 19 11:09:22 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-a05/vip_boot-1-x86_64-rhel-942676949dfefd548ff9ef9d8557f474bacdc7b7-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/vmlinuz-3.17.0-rc1-00898-g9426769 kconfig=x86_64-rhel commit=942676949dfefd548ff9ef9d8557f474bacdc7b7 root=/dev/ram0 RESULT_ROOT=/result/lkp-a05/boot/1/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/0 ip=::::lkp-a05::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf67afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf67b000-0x00000000bfb3dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfb3e000-0x00000000bfc50fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfc51000-0x00000000bfc51fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfc52000-0x00000000bfc62fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfc63000-0x00000000bfc65fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfc66000-0x00000000bfc83fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfc84000-0x00000000bfc84fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfc85000-0x00000000bfc8afff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bfc8b000-0x00000000bfc8cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfc8d000-0x00000000bfcc7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfcc8000-0x00000000bfcd0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfcd1000-0x00000000bfcfbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfcfc000-0x00000000bfd3efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfd3f000-0x00000000bfeeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfef0000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./Double Cove , BIOS BWDEXT.86B.000.012.D127 10/08/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0BFEF0000 mask FFFFF0000 uncachable
[    0.000000]   3 base 0BFF00000 mask FFFF00000 write-through
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xbfef0 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009e400-0x0009e7ff]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02150000, 0x02150fff] PGTABLE
[    0.000000] BRK [0x02151000, 0x02151fff] PGTABLE
[    0.000000] BRK [0x02152000, 0x02152fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23fe00000-0x23fffffff]
[    0.000000]  [mem 0x23fe00000-0x23fffffff] page 2M
[    0.000000] BRK [0x02153000, 0x02153fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23c000000-0x23fdfffff]
[    0.000000]  [mem 0x23c000000-0x23fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
[    0.000000]  [mem 0x200000000-0x23bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf67afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf67afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbfc84000-0xbfc84fff]
[    0.000000]  [mem 0xbfc84000-0xbfc84fff] page 4k
[    0.000000] BRK [0x02154000, 0x02154fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbfd3f000-0xbfeeffff]
[    0.000000]  [mem 0xbfd3f000-0xbfeeffff] page 4k
[    0.000000] BRK [0x02155000, 0x02155fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x78a08000-0x7fff2fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000BFC85098 000084 (v01 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000BFC89870 0000F4 (v04 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBFCCDF40/0x00000000BFCCDF80, using 32-bit address (20140724/tbfadt-283)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140724/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x00000000000009F4/0x0 (20140724/tbfadt-649)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140724/tbfadt-699)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20140724/tbfadt-699)
[    0.000000] ACPI: DSDT 0x00000000BFC851B0 0046BE (v02 INTEL  CRNBEACH 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BFCCDF40 000040
[    0.000000] ACPI: APIC 0x00000000BFC89968 000072 (v02 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000BFC899E0 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BFC89A20 000038 (v01 A M I  OEMHPET  01072009 AMI. 00000003)
[    0.000000] ACPI: SSDT 0x00000000BFC89A58 000679 (v02 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000BFC8A0D8 000232 (v02 PmRef  Cpu0Tst  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000BFC8A310 00020F (v02 PmRef  Cpu1Tst  00003000 INTL 20051117)
[    0.000000] ACPI: SPCR 0x00000000BFC8A520 000050 (v01 A M I  APTIO4   01072009 AMI. 00000003)
[    0.000000] ACPI: EINJ 0x00000000BFC8A570 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BFC8A6A0 000210 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BFC8A8B0 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BFC8A958 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23ffd3000-0x23fff8fff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237600000-ffff88023f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf67afff]
[    0.000000]   node   0: [mem 0xbfc84000-0xbfc84fff]
[    0.000000]   node   0: [mem 0xbfd3f000-0xbfeeffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000] On node 0 totalpages: 2095050
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12193 pages used for memmap
[    0.000000]   DMA32 zone: 780333 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
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
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf67b000-0xbfb3dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfb3e000-0xbfc50fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc51000-0xbfc51fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc52000-0xbfc62fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc63000-0xbfc65fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc66000-0xbfc83fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc85000-0xbfc8afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc8b000-0xbfc8cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc8d000-0xbfcc7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfcc8000-0xbfcd0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfcd1000-0xbfcfbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfcfc000-0xbfd3efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfef0000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88023fc00000 s87936 r8192 d22656 u524288
[    0.000000] pcpu-alloc: s87936 r8192 d22656 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2062292
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-a05/vip_boot-1-x86_64-rhel-942676949dfefd548ff9ef9d8557f474bacdc7b7-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/vmlinuz-3.17.0-rc1-00898-g9426769 kconfig=x86_64-rhel commit=942676949dfefd548ff9ef9d8557f474bacdc7b7 root=/dev/ram0 RESULT_ROOT=/result/lkp-a05/boot/1/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/0 ip=::::lkp-a05::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 8043592K/8380200K available (8507K kernel code, 1621K rwdata, 3856K rodata, 1800K init, 1884K bss, 336608K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:456 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc1-00898-g9426769 (kbuild@ivytown2) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Tue Aug 19 11:09:22 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-a05/vip_boot-1-x86_64-rhel-942676949dfefd548ff9ef9d8557f474bacdc7b7-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/vmlinuz-3.17.0-rc1-00898-g9426769 kconfig=x86_64-rhel commit=942676949dfefd548ff9ef9d8557f474bacdc7b7 root=/dev/ram0 RESULT_ROOT=/result/lkp-a05/boot/1/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/0 ip=::::lkp-a05::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf67afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf67b000-0x00000000bfb3dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfb3e000-0x00000000bfc50fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfc51000-0x00000000bfc51fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfc52000-0x00000000bfc62fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfc63000-0x00000000bfc65fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfc66000-0x00000000bfc83fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfc84000-0x00000000bfc84fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfc85000-0x00000000bfc8afff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bfc8b000-0x00000000bfc8cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfc8d000-0x00000000bfcc7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfcc8000-0x00000000bfcd0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfcd1000-0x00000000bfcfbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bfcfc000-0x00000000bfd3efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bfd3f000-0x00000000bfeeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bfef0000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./Double Cove , BIOS BWDEXT.86B.000.012.D127 10/08/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0BFEF0000 mask FFFFF0000 uncachable
[    0.000000]   3 base 0BFF00000 mask FFFF00000 write-through
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xbfef0 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009e400-0x0009e7ff]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02150000, 0x02150fff] PGTABLE
[    0.000000] BRK [0x02151000, 0x02151fff] PGTABLE
[    0.000000] BRK [0x02152000, 0x02152fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23fe00000-0x23fffffff]
[    0.000000]  [mem 0x23fe00000-0x23fffffff] page 2M
[    0.000000] BRK [0x02153000, 0x02153fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23c000000-0x23fdfffff]
[    0.000000]  [mem 0x23c000000-0x23fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
[    0.000000]  [mem 0x200000000-0x23bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf67afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf67afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbfc84000-0xbfc84fff]
[    0.000000]  [mem 0xbfc84000-0xbfc84fff] page 4k
[    0.000000] BRK [0x02154000, 0x02154fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbfd3f000-0xbfeeffff]
[    0.000000]  [mem 0xbfd3f000-0xbfeeffff] page 4k
[    0.000000] BRK [0x02155000, 0x02155fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x78a08000-0x7fff2fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000BFC85098 000084 (v01 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000BFC89870 0000F4 (v04 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBFCCDF40/0x00000000BFCCDF80, using 32-bit address (20140724/tbfadt-283)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140724/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x00000000000009F4/0x0 (20140724/tbfadt-649)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140724/tbfadt-699)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20140724/tbfadt-699)
[    0.000000] ACPI: DSDT 0x00000000BFC851B0 0046BE (v02 INTEL  CRNBEACH 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BFCCDF40 000040
[    0.000000] ACPI: APIC 0x00000000BFC89968 000072 (v02 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000BFC899E0 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BFC89A20 000038 (v01 A M I  OEMHPET  01072009 AMI. 00000003)
[    0.000000] ACPI: SSDT 0x00000000BFC89A58 000679 (v02 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000BFC8A0D8 000232 (v02 PmRef  Cpu0Tst  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000BFC8A310 00020F (v02 PmRef  Cpu1Tst  00003000 INTL 20051117)
[    0.000000] ACPI: SPCR 0x00000000BFC8A520 000050 (v01 A M I  APTIO4   01072009 AMI. 00000003)
[    0.000000] ACPI: EINJ 0x00000000BFC8A570 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BFC8A6A0 000210 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BFC8A8B0 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BFC8A958 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23ffd3000-0x23fff8fff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237600000-ffff88023f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x23fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf67afff]
[    0.000000]   node   0: [mem 0xbfc84000-0xbfc84fff]
[    0.000000]   node   0: [mem 0xbfd3f000-0xbfeeffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000] On node 0 totalpages: 2095050
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12193 pages used for memmap
[    0.000000]   DMA32 zone: 780333 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
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
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf67b000-0xbfb3dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfb3e000-0xbfc50fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc51000-0xbfc51fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc52000-0xbfc62fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc63000-0xbfc65fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc66000-0xbfc83fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc85000-0xbfc8afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc8b000-0xbfc8cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfc8d000-0xbfcc7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfcc8000-0xbfcd0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfcd1000-0xbfcfbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfcfc000-0xbfd3efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfef0000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88023fc00000 s87936 r8192 d22656 u524288
[    0.000000] pcpu-alloc: s87936 r8192 d22656 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2062292
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-a05/vip_boot-1-x86_64-rhel-942676949dfefd548ff9ef9d8557f474bacdc7b7-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/vmlinuz-3.17.0-rc1-00898-g9426769 kconfig=x86_64-rhel commit=942676949dfefd548ff9ef9d8557f474bacdc7b7 root=/dev/ram0 RESULT_ROOT=/result/lkp-a05/boot/1/x86_64-rhel/942676949dfefd548ff9ef9d8557f474bacdc7b7/0 ip=::::lkp-a05::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 8043592K/8380200K available (8507K kernel code, 1621K rwdata, 3856K rodata, 1800K init, 1884K bss, 336608K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:456 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1600.024 MHz processor
[    0.000071] Calibrating delay loop (skipped), value calculated using timer frequency.. lpj=1600024
[    0.009190] pid_max: default: 32768 minimum: 301
[    0.013905] ACPI: Core revision 20140724
[    0.029326] ACPI: All ACPI Tables successfully acquired
[    0.034893] Security Framework initialized
[    0.039072] SELinux:  Initializing.
[    0.042646] SELinux:  Starting in permissive mode
[    0.049321] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.064293] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.074902] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.081958] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.090230] Initializing cgroup subsys memory
[    0.094751] Initializing cgroup subsys devices
[    0.099333] Initializing cgroup subsys freezer
[    0.103916] Initializing cgroup subsys net_cls
[    0.108492] Initializing cgroup subsys blkio
[    0.112895] Initializing cgroup subsys perf_event
[    0.117732] Initializing cgroup subsys hugetlb
[    0.122365] CPU: Physical Processor ID: 0
[    0.126506] CPU: Processor Core ID: 0
[    0.130305] mce: CPU supports 5 MCE banks
[    0.134453] CPU0: Thermal LVT vector (0xfa) already installed
[    0.140344] Last level iTLB entries: 4KB 32, 2MB 0, 4MB 0
[    0.140344] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 8, 1GB 0
[    0.152127] Freeing SMP alternatives memory: 32K (ffffffff81f6f000 - ffffffff81f77000)
[    0.162201] ftrace: allocating 31170 entries in 122 pages
[    0.195753] Getting VERSION: 50014
[    0.199292] Getting VERSION: 50014
[    0.202821] Getting ID: 0
[    0.205568] Getting ID: 0
[    0.208325] masked ExtINT on CPU#0
[    0.211974] ENABLING IO-APIC IRQs
[    0.215428] init IO_APIC IRQs
[    0.218527]  apic 2 pin 0 not connected
[    0.222505] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.230626] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.238745] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.246897] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.255022] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.263149] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.271271] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.279401] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.287531] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.295660] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.303955] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.312250] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.320553] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.328857] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.337159] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.345458]  apic 2 pin 16 not connected
[    0.349520]  apic 2 pin 17 not connected
[    0.353584]  apic 2 pin 18 not connected
[    0.357649]  apic 2 pin 19 not connected
[    0.361717]  apic 2 pin 20 not connected
[    0.365779]  apic 2 pin 21 not connected
[    0.369843]  apic 2 pin 22 not connected
[    0.373899]  apic 2 pin 23 not connected
[    0.378089] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.394233] smpboot: CPU0: Intel(R) Atom(TM) CPU S1240   @ 1.60GHz (fam: 06, model: 36, stepping: 09)
[    0.403923] Using local APIC timer interrupts.
[    0.403923] calibrating APIC timer ...
[    0.513718] ... lapic delta = 625013
[    0.517430] ... PM-Timer delta = 357950
[    0.521399] ... PM-Timer result ok
[    0.524937] ..... delta 625013
[    0.528125] ..... mult: 26844103
[    0.531488] ..... calibration result: 100002
[    0.535890] ..... CPU clock speed is 1600.0034 MHz.
[    0.540900] ..... host bus clock speed is 100.0002 MHz.
[    0.546322] Performance Events: PEBS fmt0+, 8-deep LBR, Atom events, Intel PMU driver.
[    0.554793] ... version:                3
[    0.558940] ... bit width:              40
[    0.563170] ... generic registers:      2
[    0.567314] ... value mask:             000000ffffffffff
[    0.572765] ... max period:             000000007fffffff
[    0.578217] ... fixed-purpose events:   3
[    0.582361] ... event mask:             0000000700000003
[    0.593716] x86: Booting SMP configuration:
[    0.598062] .... node  #0, CPUs:      #1
[    0.613066] masked ExtINT on CPU#1
[    0.616709] CPU1: Thermal LVT vector (0xfa) already installed
[    0.624781] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.633406]  #2
[    0.646085] masked ExtINT on CPU#2
[    0.649718] CPU2: Thermal LVT vector (0xfa) already installed
[    0.657930]  #3
[    0.670614] masked ExtINT on CPU#3
[    0.674244] CPU3: Thermal LVT vector (0xfa) already installed
[    0.682140] x86: Booted up 1 node, 4 CPUs
[    0.686291] smpboot: Total of 4 processors activated (12800.19 BogoMIPS)
[    0.694769] devtmpfs: initialized
[    0.709339] evm: security.selinux
[    0.712802] evm: security.ima
[    0.715904] evm: security.capability
[    0.720215] PM: Registering ACPI NVS region [mem 0xbf67b000-0xbfb3dfff] (4993024 bytes)
[    0.728672] PM: Registering ACPI NVS region [mem 0xbfc51000-0xbfc51fff] (4096 bytes)
[    0.736620] PM: Registering ACPI NVS region [mem 0xbfc63000-0xbfc65fff] (12288 bytes)
[    0.744656] PM: Registering ACPI NVS region [mem 0xbfc8b000-0xbfc8cfff] (8192 bytes)
[    0.752604] PM: Registering ACPI NVS region [mem 0xbfcc8000-0xbfcd0fff] (36864 bytes)
[    0.760637] PM: Registering ACPI NVS region [mem 0xbfcfc000-0xbfd3efff] (274432 bytes)
[    0.772600] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.780060] NET: Registered protocol family 16
[    0.785538] cpuidle: using governor menu
[    0.790109] ACPI: bus type PCI registered
[    0.794257] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.801058] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    0.810571] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    0.818718] PCI: Using configuration type 1 for base access
[    0.834136] ACPI: Added _OSI(Module Device)
[    0.838470] ACPI: Added _OSI(Processor Device)
[    0.843052] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.847895] ACPI: Added _OSI(Processor Aggregator Device)
[    0.856915] ACPI: Executed 1 blocks of module-level executable AML code
[    0.869950] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.877172] ACPI: Dynamic OEM Table Load:
[    0.881513] ACPI: SSDT 0xFFFF8802342BE800 0002BD (v02 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.891251] ACPI: Dynamic OEM Table Load:
[    0.895586] ACPI: SSDT 0xFFFF880233DA9000 0006AB (v02 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.910044] ACPI: Dynamic OEM Table Load:
[    0.914375] ACPI: SSDT 0xFFFF880233D6F800 00015F (v02 PmRef  Cpu1Ist  00003000 INTL 20051117)
[    0.925805] ACPI: Dynamic OEM Table Load:
[    0.930131] ACPI: SSDT 0xFFFF88023439DCC0 00008D (v02 PmRef  Cpu1Cst  00003000 INTL 20051117)
[    0.942901] ACPI: Interpreter enabled
[    0.946719] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.956327] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.965959] ACPI: (supports S0 S3 S4 S5)
[    0.970017] ACPI: Using IOAPIC for interrupt routing
[    0.975340] HEST: Table parsing has been initialized.
[    0.980534] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.000870] ACPI: Power Resource [PFAN] (off)
[    1.006736] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.013071] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.022143] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    1.031715] PCI host bridge to bus 0000:00
[    1.035962] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.041592] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    1.047920] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    1.054246] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    1.060573] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.066893] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.073916] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    1.080932] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfeffffff]
[    1.087965] pci 0000:00:00.0: [8086:0c72] type 00 class 0x060000
[    1.094357] pci 0000:00:01.0: [8086:0c46] type 01 class 0x060400
[    1.100535] pci 0000:00:01.0: reg 0x10: [mem 0xfe460000-0xfe47ffff 64bit]
[    1.107527] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.113875] pci 0000:00:01.0: System wakeup disabled by ACPI
[    1.119801] pci 0000:00:02.0: [8086:0c47] type 01 class 0x060400
[    1.125969] pci 0000:00:02.0: reg 0x10: [mem 0xfe440000-0xfe45ffff 64bit]
[    1.132964] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.139309] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.145239] pci 0000:00:03.0: [8086:0c48] type 01 class 0x060400
[    1.151408] pci 0000:00:03.0: reg 0x10: [mem 0xfe420000-0xfe43ffff 64bit]
[    1.158401] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.164741] pci 0000:00:03.0: System wakeup disabled by ACPI
[    1.170679] pci 0000:00:04.0: [8086:0c49] type 01 class 0x060400
[    1.176845] pci 0000:00:04.0: reg 0x10: [mem 0xfe400000-0xfe41ffff 64bit]
[    1.183842] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    1.190178] pci 0000:00:04.0: System wakeup disabled by ACPI
[    1.196109] pci 0000:00:0e.0: [8086:0c54] type 00 class 0x080600
[    1.202331] pci 0000:00:0e.0: PME# supported from D0 D3hot D3cold
[    1.208773] pci 0000:00:13.0: [8086:0c59] type 00 class 0x088000
[    1.216159] pci 0000:00:13.0: reg 0x10: [mem 0xfe482000-0xfe4823ff 64bit]
[    1.223350] pci 0000:00:13.1: [8086:0c5a] type 00 class 0x088000
[    1.229516] pci 0000:00:13.1: reg 0x10: [mem 0xfe481000-0xfe4813ff 64bit]
[    1.236718] pci 0000:00:14.0: [8086:0c5f] type 00 class 0x070002
[    1.242888] pci 0000:00:14.0: reg 0x10: [io  0xf000-0xf007]
[    1.248615] pci 0000:00:14.0: reg 0x14: [mem 0xfe480000-0xfe4800ff]
[    1.255278] pci 0000:00:1f.0: [8086:0c60] type 00 class 0x060100
[    1.261797] pci 0000:01:00.0: [1033:0194] type 00 class 0x0c0330
[    1.267970] pci 0000:01:00.0: reg 0x10: [mem 0xfe300000-0xfe301fff 64bit]
[    1.275027] pci 0000:01:00.0: PME# supported from D0 D3hot
[    1.282602] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.287720] pci 0000:00:01.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    1.294768] pci 0000:02:00.0: [1b4b:9130] type 00 class 0x010601
[    1.300941] pci 0000:02:00.0: reg 0x10: [io  0xe040-0xe047]
[    1.306670] pci 0000:02:00.0: reg 0x14: [io  0xe030-0xe033]
[    1.312397] pci 0000:02:00.0: reg 0x18: [io  0xe020-0xe027]
[    1.318117] pci 0000:02:00.0: reg 0x1c: [io  0xe010-0xe013]
[    1.323838] pci 0000:02:00.0: reg 0x20: [io  0xe000-0xe00f]
[    1.329562] pci 0000:02:00.0: reg 0x24: [mem 0xfe210000-0xfe2107ff]
[    1.335981] pci 0000:02:00.0: reg 0x30: [mem 0xfe200000-0xfe20ffff pref]
[    1.342880] pci 0000:02:00.0: PME# supported from D3hot
[    1.350590] pci 0000:00:02.0: PCI bridge to [bus 02]
[    1.355700] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    1.361941] pci 0000:00:02.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    1.368999] pci 0000:03:00.0: [1a03:1150] type 01 class 0x060400
[    1.375292] pci 0000:03:00.0: supports D1 D2
[    1.379704] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.388589] pci 0000:00:03.0: PCI bridge to [bus 03-04]
[    1.393959] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    1.400196] pci 0000:00:03.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    1.407280] pci 0000:04:00.0: [1a03:2000] type 00 class 0x030000
[    1.413460] pci 0000:04:00.0: reg 0x10: [mem 0xfd000000-0xfdffffff]
[    1.419885] pci 0000:04:00.0: reg 0x14: [mem 0xfe000000-0xfe01ffff]
[    1.426306] pci 0000:04:00.0: reg 0x18: [io  0xd000-0xd07f]
[    1.432133] pci 0000:04:00.0: supports D1 D2
[    1.436544] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.443507] pci 0000:03:00.0: PCI bridge to [bus 04]
[    1.448616] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    1.454853] pci 0000:03:00.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    1.461920] pci 0000:05:00.0: [8086:1523] type 00 class 0x020000
[    1.468088] pci 0000:05:00.0: reg 0x10: [mem 0xfe120000-0xfe13ffff]
[    1.474520] pci 0000:05:00.0: reg 0x18: [io  0xc020-0xc03f]
[    1.480248] pci 0000:05:00.0: reg 0x1c: [mem 0xfe144000-0xfe147fff]
[    1.486774] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.493062] pci 0000:05:00.0: reg 0x184: [mem 0xd0000000-0xd0003fff 64bit pref]
[    1.500591] pci 0000:05:00.0: reg 0x190: [mem 0xd0020000-0xd0023fff 64bit pref]
[    1.508260] pci 0000:05:00.1: [8086:1523] type 00 class 0x020000
[    1.514429] pci 0000:05:00.1: reg 0x10: [mem 0xfe100000-0xfe11ffff]
[    1.520865] pci 0000:05:00.1: reg 0x18: [io  0xc000-0xc01f]
[    1.526589] pci 0000:05:00.1: reg 0x1c: [mem 0xfe140000-0xfe143fff]
[    1.533113] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    1.539388] pci 0000:05:00.1: reg 0x184: [mem 0xd0040000-0xd0043fff 64bit pref]
[    1.546925] pci 0000:05:00.1: reg 0x190: [mem 0xd0060000-0xd0063fff 64bit pref]
[    1.556592] pci 0000:00:04.0: PCI bridge to [bus 05]
[    1.561702] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    1.567940] pci 0000:00:04.0:   bridge window [mem 0xfe100000-0xfe1fffff]
[    1.574877] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    1.584148] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 12 14 15), disabled.
[    1.593638] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.603359] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.613075] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.622802] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.632508] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.641967] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.651424] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15), disabled.
[    1.660943] ACPI: Enabled 3 GPEs in block 00 to 1F
[    1.666502] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.674806] vgaarb: loaded
[    1.677652] vgaarb: bridge control possible 0000:04:00.0
[    1.683416] SCSI subsystem initialized
[    1.687417] ACPI: bus type USB registered
[    1.691642] usbcore: registered new interface driver usbfs
[    1.697300] usbcore: registered new interface driver hub
[    1.702886] usbcore: registered new device driver usb
[    1.708155] pps_core: LinuxPPS API ver. 1 registered
[    1.713257] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.722614] PTP clock support registered
[    1.726918] PCI: Using ACPI for IRQ routing
[    1.738504] PCI: pci_cache_line_size set to 64 bytes
[    1.743681] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    1.750789] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    1.756934] e820: reserve RAM buffer [mem 0xbf67b000-0xbfffffff]
[    1.763080] e820: reserve RAM buffer [mem 0xbfc85000-0xbfffffff]
[    1.769232] e820: reserve RAM buffer [mem 0xbfef0000-0xbfffffff]
[    1.775748] NetLabel: Initializing
[    1.779292] NetLabel:  domain hash size = 128
[    1.783788] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.788928] NetLabel:  unlabeled traffic allowed by default
[    1.795101] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.800461] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.808513] Switched to clocksource hpet
[    1.854298] pnp: PnP ACPI init
[    1.857923] system 00:00: [mem 0xc0000000-0xcfffffff] has been reserved
[    1.864700] system 00:00: [mem 0xbff00000-0xbfffffff] has been reserved
[    1.871468] system 00:00: [mem 0xfee00000-0xfeefffff] has been reserved
[    1.878230] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.885464] system 00:01: [io  0x0a00-0x0a1f] has been reserved
[    1.891537] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.899044] pnp 00:02: [dma 0 disabled]
[    1.903166] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.909941] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.916764] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    1.922843] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.930119] pnp 00:05: Plug and Play ACPI device, IDs IPI0001 (active)
[    1.937372] system 00:06: [io  0x0900-0x097f] could not be reserved
[    1.943787] system 00:06: [io  0x09c0-0x09ff] has been reserved
[    1.949853] system 00:06: [io  0x0400-0x043f] has been reserved
[    1.955919] system 00:06: [io  0x0500-0x057f] has been reserved
[    1.961989] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.969103] system 00:06: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.975863] system 00:06: [mem 0x000c0000-0x000dffff] could not be reserved
[    1.982971] system 00:06: [mem 0x000e0000-0x000effff] could not be reserved
[    1.990076] system 00:06: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.997184] system 00:06: [mem 0xff800000-0xffffffff] has been reserved
[    2.003947] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.011058] system 00:07: [mem 0xbfef0000-0xbfefffff] has been reserved
[    2.017824] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.025222] pnp: PnP ACPI: found 8 devices
[    2.041279] pci 0000:00:01.0: PCI bridge to [bus 01]
[    2.046402] pci 0000:00:01.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    2.053353] pci 0000:00:02.0: PCI bridge to [bus 02]
[    2.058460] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    2.064703] pci 0000:00:02.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    2.071643] pci 0000:03:00.0: PCI bridge to [bus 04]
[    2.076756] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    2.083000] pci 0000:03:00.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    2.089950] pci 0000:00:03.0: PCI bridge to [bus 03-04]
[    2.095323] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    2.101565] pci 0000:00:03.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    2.108512] pci 0000:00:04.0: PCI bridge to [bus 05]
[    2.113634] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    2.119879] pci 0000:00:04.0:   bridge window [mem 0xfe100000-0xfe1fffff]
[    2.126819] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    2.134781] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    2.140502] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    2.146223] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    2.151943] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    2.157664] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    2.164077] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    2.170490] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfeffffff]
[    2.176992] pci_bus 0000:01: resource 1 [mem 0xfe300000-0xfe3fffff]
[    2.183410] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    2.189126] pci_bus 0000:02: resource 1 [mem 0xfe200000-0xfe2fffff]
[    2.195540] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    2.201258] pci_bus 0000:03: resource 1 [mem 0xfd000000-0xfe0fffff]
[    2.207671] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    2.213392] pci_bus 0000:04: resource 1 [mem 0xfd000000-0xfe0fffff]
[    2.219808] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    2.225532] pci_bus 0000:05: resource 1 [mem 0xfe100000-0xfe1fffff]
[    2.231949] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    2.239459] NET: Registered protocol family 2
[    2.244713] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    2.252789] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.260376] TCP: Hash tables configured (established 65536 bind 65536)
[    2.267282] TCP: reno registered
[    2.270737] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.277110] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.284131] NET: Registered protocol family 1
[    2.289057] RPC: Registered named UNIX socket transport module.
[    2.295164] RPC: Registered udp transport module.
[    2.300021] RPC: Registered tcp transport module.
[    2.304875] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.313213] IOAPIC[0]: Set routing entry (2-21 -> 0x41 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    2.321823] pci 0000:04:00.0: Boot video device
[    2.326512] PCI: CLS 64 bytes, default 64
[    2.330837] Unpacking initramfs...
[    8.984589] Freeing initrd memory: 120748K (ffff880078a08000 - ffff88007fff3000)
[    8.992266] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    8.998867] software IO TLB [mem 0xbb67b000-0xbf67b000] (64MB) mapped at [ffff8800bb67b000-ffff8800bf67afff]
[    9.011633] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    9.018028] Initialise system trusted keyring
[    9.022602] audit: initializing netlink subsys (disabled)
[    9.028178] audit: type=2000 audit(1408447657.370:1): initialized
[    9.035368] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    9.048301] zpool: loaded
[    9.051081] zbud: loaded
[    9.054241] VFS: Disk quotas dquot_6.5.2
[    9.058473] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    9.066984] SGI XFS with ACLs, security attributes, no debug enabled
[    9.074855] 9p: Installing v9fs 9p2000 file system support
[    9.080617] msgmni has been set to 15946
[    9.084911] Key type big_key registered
[    9.088896] SELinux:  Registering netfilter hooks
[    9.095199] NET: Registered protocol family 38
[    9.099818] Key type asymmetric registered
[    9.104074] Asymmetric key parser 'x509' registered
[    9.109272] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    9.117015] io scheduler noop registered
[    9.121087] io scheduler deadline registered (default)
[    9.126397] io scheduler cfq registered
[    9.130751] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    9.136686] IOAPIC[0]: Set routing entry (2-22 -> 0x61 -> IRQ 22 Mode:1 Active:1 Dest:15)
[    9.145128] pcieport 0000:00:02.0: irq 25 for MSI/MSI-X
[    9.151002] IOAPIC[0]: Set routing entry (2-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:15)
[    9.159445] pcieport 0000:00:03.0: irq 26 for MSI/MSI-X
[    9.165283] IOAPIC[0]: Set routing entry (2-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:15)
[    9.173722] pcieport 0000:00:04.0: irq 27 for MSI/MSI-X
[    9.179358] aer 0000:00:01.0:pcie02: service driver aer loaded
[    9.185399] aer 0000:00:02.0:pcie02: service driver aer loaded
[    9.191430] aer 0000:00:03.0:pcie02: service driver aer loaded
[    9.197460] aer 0000:00:04.0:pcie02: service driver aer loaded
[    9.203486] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    9.211673] IP: [<ffffffff813f0859>] __bitmap_intersects+0x49/0x80
[    9.218069] PGD 0 
[    9.220288] Oops: 0000 [#1] SMP 
[    9.223809] Modules linked in:
[    9.227078] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1-00898-g9426769 #1
[    9.234842] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Double Cove , BIOS BWDEXT.86B.000.012.D127 10/08/2012
[    9.246432] task: ffff880234180000 ti: ffff88023417c000 task.ti: ffff88023417c000
[    9.254109] RIP: 0010:[<ffffffff813f0859>]  [<ffffffff813f0859>] __bitmap_intersects+0x49/0x80
[    9.263001] RSP: 0000:ffff88023417fc18  EFLAGS: 00010002
[    9.268444] RAX: 0000000000000000 RBX: ffff880222b49a00 RCX: 0000000000000004
[    9.275716] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff880222bac800
[    9.282989] RBP: ffff88023417fc18 R08: 0000000000000246 R09: 0000000000000000
[    9.290258] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[    9.297523] R13: 0000000000000018 R14: ffff8800b1de7900 R15: ffff880222b49200
[    9.304796] FS:  0000000000000000(0000) GS:ffff88023fd00000(0000) knlGS:0000000000000000
[    9.313080] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    9.318956] CR2: 0000000000000000 CR3: 0000000001c2c000 CR4: 00000000000007e0
[    9.326228] Stack:
[    9.328369]  ffff88023417fc68 ffffffff810c6117 0000000000000246 ffff8800b1de798c
[    9.336299]  ffff880222bac800 ffffffff8142eab0 0000000000000080 0000000000000018
[    9.344211]  ffff880225d83800 ffff8800b1de7900 ffff88023417fcb0 ffffffff810c65bc
[    9.352124] Call Trace:
[    9.354707]  [<ffffffff810c6117>] __setup_irq+0x297/0x5e0
[    9.360250]  [<ffffffff8142eab0>] ? pcie_pme_probe+0x1c0/0x1c0
[    9.366222]  [<ffffffff810c65bc>] request_threaded_irq+0xcc/0x170
[    9.372453]  [<ffffffff8142e98c>] pcie_pme_probe+0x9c/0x1c0
[    9.378164]  [<ffffffff8142b1e2>] pcie_port_probe_service+0x32/0x80
[    9.384572]  [<ffffffff814ee6c0>] driver_probe_device+0x90/0x3c0
[    9.390714]  [<ffffffff814eeac3>] __driver_attach+0x93/0xa0
[    9.396424]  [<ffffffff814eea30>] ? __device_attach+0x40/0x40
[    9.402302]  [<ffffffff814ec743>] bus_for_each_dev+0x63/0xa0
[    9.408101]  [<ffffffff814ee15e>] driver_attach+0x1e/0x20
[    9.413630]  [<ffffffff814edd70>] bus_add_driver+0x180/0x250
[    9.419429]  [<ffffffff81e0d00f>] ? pcie_pme_setup+0x27/0x27
[    9.425225]  [<ffffffff814ef294>] driver_register+0x64/0xf0
[    9.430931]  [<ffffffff8142b146>] pcie_port_service_register+0x46/0x50
[    9.437594]  [<ffffffff81e0d01f>] pcie_pme_service_init+0x10/0x12
[    9.443827]  [<ffffffff8100212c>] do_one_initcall+0xbc/0x1f0
[    9.449626]  [<ffffffff8108bd55>] ? parse_args+0x235/0x450
[    9.455252]  [<ffffffff81dc4231>] kernel_init_freeable+0x1a0/0x22b
[    9.461567]  [<ffffffff81dc3990>] ? initcall_blacklist+0xb0/0xb0
[    9.467707]  [<ffffffff8182ff20>] ? rest_init+0x90/0x90
[    9.473068]  [<ffffffff8182ff2e>] kernel_init+0xe/0xf0
[    9.478341]  [<ffffffff81849bbc>] ret_from_fork+0x7c/0xb0
[    9.483877]  [<ffffffff8182ff20>] ? rest_init+0x90/0x90
[    9.489230] Code: 14 90 4c 8b 44 06 08 4c 23 44 07 08 48 83 c0 08 4d 85 c0 75 35 41 83 c1 01 45 39 d1 75 e4 89 d1 31 c0 83 e1 3f 74 1d 4a 8b 04 cf <4a> 23 04 ce be 01 00 00 00 48 d3 e6 48 83 ee 01 48 85 f0 0f 95 
[    9.513695] RIP  [<ffffffff813f0859>] __bitmap_intersects+0x49/0x80
[    9.520180]  RSP <ffff88023417fc18>
[    9.523804] CR2: 0000000000000000
[    9.527265] ---[ end trace 2b176a518018b253 ]---
[    9.532011] Kernel panic - not syncing: Fatal exception
[    9.537380] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
Rebooting in 10 seconds..

--RnlQjJ0d97Da+TV1--
