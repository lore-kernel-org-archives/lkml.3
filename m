Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaDQEAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 00:00:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:45079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaDQEAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 00:00:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,876,1389772800"; 
   d="scan'208";a="514549912"
Date: Thu, 17 Apr 2014 11:59:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [raid5] kernel BUG at drivers/md/raid5.c:4374!
Message-ID: <20140417035958.GE8702@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Shaohua,

We noticed the below BUG on

commit e240c1839d11152b0355442f8ac6d2d2d921be36 ("raid5: get_active_stripe avoids device_lock")

test case: lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd

27c0f68f0745218  e240c1839d11152b0355442f8  
---------------  -------------------------  
         0           +Inf%          1 ~ 0%  TOTAL dmesg.kernel_BUG_at_drivers/md/raid5.c
         0           +Inf%          1 ~ 0%  TOTAL dmesg.invalid_opcode
         0           +Inf%          1 ~ 0%  TOTAL dmesg.RIP:handle_active_stripes
         0           +Inf%          1 ~ 0%  TOTAL dmesg.Kernel_panic-not_syncing:Fatal_exception

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent

[  264.260444] kernel BUG at drivers/md/raid5.c:4374!
[  264.267590] invalid opcode: 0000 [#1] SMP
[  264.272076] Modules linked in: btrfs microcode ipmi_si ipmi_msghandler acpi_cpufreq processor
[  264.281514] CPU: 0 PID: 4005 Comm: md0_raid5 Not tainted 3.15.0-rc1-00611-g2e76799 #1
[  264.289823] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[  264.296789] task: ffff8804151e41a0 ti: ffff88041672c000 task.ti: ffff88041672c000
[  264.304750] RIP: 0010:[<ffffffff81804ef1>]  [<ffffffff81804ef1>] handle_active_stripes.isra.24+0x254/0x360
[  264.314951] RSP: 0018:ffff88041672dd10  EFLAGS: 00010002
[  264.320527] RAX: ffff88021dc46000 RBX: ffff880220a4e000 RCX: ffff880220a4e080
[  264.327926] RDX: 0000000000000001 RSI: ffff88021e0d7010 RDI: ffff880220a4e000
[  264.335325] RBP: ffff88041672dda8 R08: 0000000000000000 R09: 0000000000000000
[  264.342724] R10: 0000000000000000 R11: 000000000000ef58 R12: 0000000000000000
[  264.350131] R13: ffff880220a4e080 R14: 0000000000000000 R15: ffff880220a4e268
[  264.357530] FS:  0000000000000000(0000) GS:ffff880237c00000(0000) knlGS:0000000000000000
[  264.366099] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  264.372111] CR2: 0000000001e21d64 CR3: 000000000200f000 CR4: 00000000000007f0
[  264.379509] Stack:
[  264.381780]  ffff8804173d7de0 ffff880220a4e000 ffff88041672dd38 ffffffffffffffd8
[  264.389907]  ffffffff1e1bd000 ffff880220a4e090 ffffffff817fdba2 ffff880220a4e000
[  264.398043]  0000000000000021 ffff880220a4e268 0000000000000000 ffff88041672dd78
[  264.406172] Call Trace:
[  264.408893]  [<ffffffff817fdba2>] ? do_release_stripe+0xdf/0x158
[  264.415168]  [<ffffffff817fdc30>] ? __release_stripe+0x15/0x17
[  264.421266]  [<ffffffff818054f2>] raid5d+0x3e2/0x4f2
[  264.426497]  [<ffffffff819bcacf>] ? schedule_timeout+0x2f/0x19f
[  264.432681]  [<ffffffff81826151>] md_thread+0x123/0x139
[  264.438171]  [<ffffffff811148b6>] ? __wake_up_sync+0x12/0x12
[  264.444096]  [<ffffffff8182602e>] ? md_register_thread+0xd5/0xd5
[  264.450368]  [<ffffffff810fa267>] kthread+0xdb/0xe3
[  264.455511]  [<ffffffff810fa18c>] ? kthread_create_on_node+0x16f/0x16f
[  264.462310]  [<ffffffff819c7d7c>] ret_from_fork+0x7c/0xb0
[  264.467973]  [<ffffffff810fa18c>] ? kthread_create_on_node+0x16f/0x16f
[  264.474764] Code: 60 00 00 00 00 48 8b 70 10 48 8b 48 18 48 8d 50 10 48 89 4e 08 48 89 31 48 89 50 10 48 89 50 18 f0 ff 40 50 8b 50 50
ff ca 74 02 <0f> 0b 4a 89 44 d5 98 49 ff c2 49 83 fa 08 0f 85 d7 fd ff ff 41
[  264.498252] RIP  [<ffffffff81804ef1>] handle_active_stripes.isra.24+0x254/0x360
[  264.506112]  RSP <ffff88041672dd10>
[  264.509869] ---[ end trace 58f3875ff7b4e923 ]---

Thanks,
Fengguang

--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc1-00611-g2e76799 (kbuild@cairo) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Mon Apr 14 19:58:29 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-ws02/cyclic_dd-write-11hdd-11HDD-RAID5-cfq-ext4-10dd-HEAD-2e7679975d5c1a12410cc3a7100085ad8d7420e1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/vmlinuz-3.15.0-rc1-00611-g2e76799 kconfig=x86_64-lkp commit=2e7679975d5c1a12410cc3a7100085ad8d7420e1 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 modules_initrd=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped at [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0245e000, 0x0245efff] PGTABLE
[    0.000000] BRK [0x0245f000, 0x0245ffff] PGTABLE
[    0.000000] BRK [0x02460000, 0x02460fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x02461000, 0x02461fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x72df6000-0x7fff2fff]
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 A M I )
[    0.000000] ACPI: XSDT 0x00000000BF421E18 00008C (v01 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000BF41FD98 0000F4 (v04 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBF420F40/0x00000000BF420E40, using 64-bit address (20140325/tbfadt-271)
[    0.000000] ACPI: DSDT 0x00000000BF418018 00601B (v01 A M I  ALASKA   00000001 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BF420E40 000040
[    0.000000] ACPI: APIC 0x00000000BF41FC18 000130 (v02 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 0x00000000BF415798 0006EE (v01 AMICPU PROC     00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BF422F18 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BF414C98 000228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0x00000000BF422E98 000030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0x00000000BF422E18 000038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 0x00000000BF422D98 000040 (v05 A M I  OEMSPMI  00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 0x00000000BF41FA98 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BF414A18 000210 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BF414F18 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BF422D18 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 0x00000000BF415F18 0000D4 (v01 A M I  OEMDMAR  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23fffb000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fff8000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
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
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880237c00000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 12 13 14 15 16 17 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 06 07 08 09 10 11 18 19 20 21 22 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-ws02/cyclic_dd-write-11hdd-11HDD-RAID5-cfq-ext4-10dd-HEAD-2e7679975d5c1a12410cc3a7100085ad8d7420e1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/vmlinuz-3.15.0-rc1-00611-g2e76799 kconfig=x86_64-lkp commit=2e7679975d5c1a12410cc3a7100085ad8d7420e1 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 modules_initrd=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16198064K/16765248K available (10036K kernel code, 1261K rwdata, 4184K rodata, 1412K init, 1744K bss, 567184K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=24.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=24
[    0.000000] NR_IRQS:33024 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-rc1-00611-g2e76799 (kbuild@cairo) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Mon Apr 14 19:58:29 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-ws02/cyclic_dd-write-11hdd-11HDD-RAID5-cfq-ext4-10dd-HEAD-2e7679975d5c1a12410cc3a7100085ad8d7420e1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/vmlinuz-3.15.0-rc1-00611-g2e76799 kconfig=x86_64-lkp commit=2e7679975d5c1a12410cc3a7100085ad8d7420e1 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 modules_initrd=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf30afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf30b000-0x00000000bf38afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf38b000-0x00000000bf3a0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3a1000-0x00000000bf3a1fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3a2000-0x00000000bf3b2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3b3000-0x00000000bf3b5fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3b6000-0x00000000bf3dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf3dd000-0x00000000bf3ddfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bf3de000-0x00000000bf3defff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf3df000-0x00000000bf413fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf414000-0x00000000bf415fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf416000-0x00000000bf417fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf418000-0x00000000bf41ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf420000-0x00000000bf420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf421000-0x00000000bf422fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bf423000-0x00000000bf42afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf42b000-0x00000000bf453fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bf454000-0x00000000bf656fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000bf657000-0x00000000bf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c0000000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000043fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fcf20-0x000fcf2f] mapped at [ffff8800000fcf20]
[    0.000000]   mpc: fc9f0-fcea4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0245e000, 0x0245efff] PGTABLE
[    0.000000] BRK [0x0245f000, 0x0245ffff] PGTABLE
[    0.000000] BRK [0x02460000, 0x02460fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x43fe00000-0x43fffffff]
[    0.000000]  [mem 0x43fe00000-0x43fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x43c000000-0x43fdfffff]
[    0.000000]  [mem 0x43c000000-0x43fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x400000000-0x43bffffff]
[    0.000000]  [mem 0x400000000-0x43bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf30afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf1fffff] page 2M
[    0.000000]  [mem 0xbf200000-0xbf30afff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]  [mem 0xbf3dd000-0xbf3ddfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbf657000-0xbf7fffff]
[    0.000000]  [mem 0xbf657000-0xbf7fffff] page 4k
[    0.000000] BRK [0x02461000, 0x02461fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x72df6000-0x7fff2fff]
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 A M I )
[    0.000000] ACPI: XSDT 0x00000000BF421E18 00008C (v01 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 0x00000000BF41FD98 0000F4 (v04 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBF420F40/0x00000000BF420E40, using 64-bit address (20140325/tbfadt-271)
[    0.000000] ACPI: DSDT 0x00000000BF418018 00601B (v01 A M I  ALASKA   00000001 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000BF420E40 000040
[    0.000000] ACPI: APIC 0x00000000BF41FC18 000130 (v02 A M I  ALASKA   01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 0x00000000BF415798 0006EE (v01 AMICPU PROC     00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000BF422F18 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 0x00000000BF414C98 000228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 0x00000000BF422E98 000030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 0x00000000BF422E18 000038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 0x00000000BF422D98 000040 (v05 A M I  OEMSPMI  00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 0x00000000BF41FA98 000130 (v01 AMI    AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 0x00000000BF414A18 000210 (v01 AMIER  AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 0x00000000BF414F18 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 0x00000000BF422D18 000030 (v01 AMI    AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 0x00000000BF415F18 0000D4 (v01 A M I  OEMDMAR  00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x23fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x240000000-0x43fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x23fffffff] -> [mem 0x00000000-0x23fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x23fffffff]
[    0.000000]   NODE_DATA [mem 0x23fffb000-0x23fffffff]
[    0.000000] Initmem setup node 1 [mem 0x240000000-0x43fffffff]
[    0.000000]   NODE_DATA [mem 0x43fff8000-0x43fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880237e00000-ffff88023fdfffff] on node 0
[    0.000000]  [ffffea0009000000-ffffea0010ffffff] PMD -> [ffff880437600000-ffff88043f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x43fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xbf30afff]
[    0.000000]   node   0: [mem 0xbf3dd000-0xbf3ddfff]
[    0.000000]   node   0: [mem 0xbf657000-0xbf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
[    0.000000]   node   1: [mem 0x240000000-0x43fffffff]
[    0.000000] On node 0 totalpages: 2094160
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12179 pages used for memmap
[    0.000000]   DMA32 zone: 779445 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
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
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec02000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec90000)
[    0.000000] nr_irqs_gsi: 112
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf30b000-0xbf38afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf38b000-0xbf3a0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a1000-0xbf3a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3a2000-0xbf3b2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b3000-0xbf3b5fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3b6000-0xbf3dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3de000-0xbf3defff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf3df000-0xbf413fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf414000-0xbf415fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf416000-0xbf417fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf418000-0xbf41ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf420000-0xbf420fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf421000-0xbf422fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf423000-0xbf42afff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf42b000-0xbf453fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf454000-0xbf656fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf800000-0xbfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc0000000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880237c00000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 12 13 14 15 16 17 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 06 07 08 09 10 11 18 19 20 21 22 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4125800
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-ws02/cyclic_dd-write-11hdd-11HDD-RAID5-cfq-ext4-10dd-HEAD-2e7679975d5c1a12410cc3a7100085ad8d7420e1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/vmlinuz-3.15.0-rc1-00611-g2e76799 kconfig=x86_64-lkp commit=2e7679975d5c1a12410cc3a7100085ad8d7420e1 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 modules_initrd=/kernel/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/0 ip=::::lkp-ws02::dhcp oops=panic ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16198064K/16765248K available (10036K kernel code, 1261K rwdata, 4184K rodata, 1412K init, 1744K bss, 567184K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=24.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=24
[    0.000000] NR_IRQS:33024 nr_irqs:2096 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Disabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2800.132 MHz processor
[    0.000007] Calibrating delay loop (skipped), value calculated using timer frequency.. 5600.26 BogoMIPS (lpj=11200528)
[    0.010825] pid_max: default: 32768 minimum: 301
[    0.015503] ACPI: Core revision 20140325
[    0.024558] ACPI: All ACPI Tables successfully acquired
[    0.031046] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.042433] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.051285] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.058445] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.066548] Initializing cgroup subsys memory
[    0.071180] Initializing cgroup subsys devices
[    0.075888] Initializing cgroup subsys freezer
[    0.080597] Initializing cgroup subsys blkio
[    0.085133] Initializing cgroup subsys perf_event
[    0.090105] Initializing cgroup subsys hugetlb
[    0.094835] CPU: Physical Processor ID: 0
[    0.099106] CPU: Processor Core ID: 0
[    0.103033] mce: CPU supports 9 MCE banks
[    0.107309] CPU0: Thermal LVT vector (0xfa) already installed
[    0.113329] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.113329] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.113329] tlb_flushall_shift: 6
[    0.129152] Freeing SMP alternatives memory: 40K (ffffffff8229e000 - ffffffff822a8000)
[    0.138622] ftrace: allocating 39277 entries in 154 pages
[    0.159704] Getting VERSION: 1060015
[    0.163544] Getting VERSION: 1060015
[    0.167387] Getting ID: 0
[    0.170266] Getting ID: 0
[    0.173145] Switched APIC routing to physical flat.
[    0.178289] masked ExtINT on CPU#0
[    0.182475] ENABLING IO-APIC IRQs
[    0.186051] init IO_APIC IRQs
[    0.189280]  apic 0 pin 0 not connected
[    0.193385] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.201781] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.210177] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.218579] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.226981] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.235385] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.243789] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.252186] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.260590] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.268987] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.277556] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.286134] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.294704] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.303281] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.311851] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.320421]  apic 0 pin 16 not connected
[    0.324608]  apic 0 pin 17 not connected
[    0.328797]  apic 0 pin 18 not connected
[    0.332987]  apic 0 pin 19 not connected
[    0.337177]  apic 0 pin 20 not connected
[    0.341366]  apic 0 pin 21 not connected
[    0.345554]  apic 0 pin 22 not connected
[    0.349745]  apic 0 pin 23 not connected
[    0.353933]  apic 2 pin 0 not connected
[    0.358036]  apic 2 pin 1 not connected
[    0.362139]  apic 2 pin 2 not connected
[    0.366243]  apic 2 pin 3 not connected
[    0.370345]  apic 2 pin 4 not connected
[    0.374448]  apic 2 pin 5 not connected
[    0.378550]  apic 2 pin 6 not connected
[    0.382652]  apic 2 pin 7 not connected
[    0.386755]  apic 2 pin 8 not connected
[    0.390858]  apic 2 pin 9 not connected
[    0.394962]  apic 2 pin 10 not connected
[    0.399149]  apic 2 pin 11 not connected
[    0.403339]  apic 2 pin 12 not connected
[    0.407529]  apic 2 pin 13 not connected
[    0.411718]  apic 2 pin 14 not connected
[    0.415906]  apic 2 pin 15 not connected
[    0.420098]  apic 2 pin 16 not connected
[    0.424287]  apic 2 pin 17 not connected
[    0.428475]  apic 2 pin 18 not connected
[    0.432665]  apic 2 pin 19 not connected
[    0.436854]  apic 2 pin 20 not connected
[    0.441044]  apic 2 pin 21 not connected
[    0.445233]  apic 2 pin 22 not connected
[    0.449422]  apic 2 pin 23 not connected
[    0.453611]  apic 3 pin 0 not connected
[    0.457716]  apic 3 pin 1 not connected
[    0.461819]  apic 3 pin 2 not connected
[    0.465919]  apic 3 pin 3 not connected
[    0.470023]  apic 3 pin 4 not connected
[    0.474126]  apic 3 pin 5 not connected
[    0.478229]  apic 3 pin 6 not connected
[    0.482332]  apic 3 pin 7 not connected
[    0.486433]  apic 3 pin 8 not connected
[    0.490536]  apic 3 pin 9 not connected
[    0.494640]  apic 3 pin 10 not connected
[    0.498829]  apic 3 pin 11 not connected
[    0.503018]  apic 3 pin 12 not connected
[    0.507208]  apic 3 pin 13 not connected
[    0.511396]  apic 3 pin 14 not connected
[    0.515587]  apic 3 pin 15 not connected
[    0.519775]  apic 3 pin 16 not connected
[    0.523965]  apic 3 pin 17 not connected
[    0.528153]  apic 3 pin 18 not connected
[    0.532344]  apic 3 pin 19 not connected
[    0.536533]  apic 3 pin 20 not connected
[    0.540723]  apic 3 pin 21 not connected
[    0.544913]  apic 3 pin 22 not connected
[    0.549101]  apic 3 pin 23 not connected
[    0.553291]  apic 4 pin 0 not connected
[    0.557395]  apic 4 pin 1 not connected
[    0.561496]  apic 4 pin 2 not connected
[    0.565599]  apic 4 pin 3 not connected
[    0.569702]  apic 4 pin 4 not connected
[    0.573803]  apic 4 pin 5 not connected
[    0.577908]  apic 4 pin 6 not connected
[    0.582011]  apic 4 pin 7 not connected
[    0.586112]  apic 4 pin 8 not connected
[    0.590216]  apic 4 pin 9 not connected
[    0.594319]  apic 4 pin 10 not connected
[    0.598508]  apic 4 pin 11 not connected
[    0.602697]  apic 4 pin 12 not connected
[    0.606886]  apic 4 pin 13 not connected
[    0.611075]  apic 4 pin 14 not connected
[    0.615265]  apic 4 pin 15 not connected
[    0.619455]  apic 4 pin 16 not connected
[    0.623644]  apic 4 pin 17 not connected
[    0.627834]  apic 4 pin 18 not connected
[    0.632022]  apic 4 pin 19 not connected
[    0.636211]  apic 4 pin 20 not connected
[    0.640403]  apic 4 pin 21 not connected
[    0.644591]  apic 4 pin 22 not connected
[    0.648780]  apic 4 pin 23 not connected
[    0.653099] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.699087] smpboot: CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz (fam: 06, model: 2c, stepping: 01)
[    0.709669] Using local APIC timer interrupts.
[    0.709669] calibrating APIC timer ...
[    0.826355] ... lapic delta = 833352
[    0.830191] ... PM-Timer delta = 357950
[    0.834293] ... PM-Timer result ok
[    0.837952] ..... delta 833352
[    0.841266] ..... mult: 35792195
[    0.844754] ..... calibration result: 533345
[    0.849290] ..... CPU clock speed is 2800.0234 MHz.
[    0.854434] ..... host bus clock speed is 133.1345 MHz.
[    0.859935] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.869016] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.876154] ... version:                3
[    0.880429] ... bit width:              48
[    0.884793] ... generic registers:      4
[    0.889070] ... value mask:             0000ffffffffffff
[    0.894646] ... max period:             000000007fffffff
[    0.900224] ... fixed-purpose events:   3
[    0.904500] ... event mask:             000000070000000f
[    0.911702] x86: Booting SMP configuration:
[    0.916150] .... node  #0, CPUs:        #1
[    0.931273] masked ExtINT on CPU#1
[    0.934885] CPU1: Thermal LVT vector (0xfa) already installed
[    0.942824]   #2
[    0.955569] masked ExtINT on CPU#2
[    0.959182] CPU2: Thermal LVT vector (0xfa) already installed
[    0.967123]   #3
[    0.980080] masked ExtINT on CPU#3
[    0.983695] CPU3: Thermal LVT vector (0xfa) already installed
[    0.991628]   #4
[    1.004374] masked ExtINT on CPU#4
[    1.007986] CPU4: Thermal LVT vector (0xfa) already installed
[    1.015919]   #5
[    1.028670] masked ExtINT on CPU#5
[    1.032283] CPU5: Thermal LVT vector (0xfa) already installed
[    1.040240] 
[    1.041996] .... node  #1, CPUs:    #6
[    1.056718] masked ExtINT on CPU#6
[    1.060337] CPU6: Thermal LVT vector (0xfa) already installed
[    1.164323]   #7
[    1.177069] masked ExtINT on CPU#7
[    1.180690] CPU7: Thermal LVT vector (0xfa) already installed
[    1.188587]   #8
[    1.201328] masked ExtINT on CPU#8
[    1.204950] CPU8: Thermal LVT vector (0xfa) already installed
[    1.212847]   #9
[    1.225807] masked ExtINT on CPU#9
[    1.229427] CPU9: Thermal LVT vector (0xfa) already installed
[    1.237333]  #10
[    1.250075] masked ExtINT on CPU#10
[    1.253779] CPU10: Thermal LVT vector (0xfa) already installed
[    1.261793]  #11
[    1.274535] masked ExtINT on CPU#11
[    1.278240] CPU11: Thermal LVT vector (0xfa) already installed
[    1.286263] 
[    1.288018] .... node  #0, CPUs:   #12
[    1.302732] masked ExtINT on CPU#12
[    1.306435] CPU12: Thermal LVT vector (0xfa) already installed
[    1.314486]  #13
[    1.327227] masked ExtINT on CPU#13
[    1.330931] CPU13: Thermal LVT vector (0xfa) already installed
[    1.338980]  #14
[    1.351724] masked ExtINT on CPU#14
[    1.355425] CPU14: Thermal LVT vector (0xfa) already installed
[    1.363383]  #15
[    1.376341] masked ExtINT on CPU#15
[    1.380042] CPU15: Thermal LVT vector (0xfa) already installed
[    1.388091]  #16
[    1.400834] masked ExtINT on CPU#16
[    1.404532] CPU16: Thermal LVT vector (0xfa) already installed
[    1.412485]  #17
[    1.425230] masked ExtINT on CPU#17
[    1.428935] CPU17: Thermal LVT vector (0xfa) already installed
[    1.436996] 
[    1.438751] .... node  #1, CPUs:   #18
[    1.453463] masked ExtINT on CPU#18
[    1.457168] CPU18: Thermal LVT vector (0xfa) already installed
[    1.465188]  #19
[    1.477933] masked ExtINT on CPU#19
[    1.481641] CPU19: Thermal LVT vector (0xfa) already installed
[    1.489652]  #20
[    1.502394] masked ExtINT on CPU#20
[    1.506099] CPU20: Thermal LVT vector (0xfa) already installed
[    1.514117]  #21
[    1.527071] masked ExtINT on CPU#21
[    1.530775] CPU21: Thermal LVT vector (0xfa) already installed
[    1.538801]  #22
[    1.551552] masked ExtINT on CPU#22
[    1.555256] CPU22: Thermal LVT vector (0xfa) already installed
[    1.563273]  #23
[    1.576019] masked ExtINT on CPU#23
[    1.579721] CPU23: Thermal LVT vector (0xfa) already installed
[    1.587688] x86: Booted up 2 nodes, 24 CPUs
[    1.592355] smpboot: Total of 24 processors activated (134405.65 BogoMIPS)
[    1.627697] devtmpfs: initialized
[    1.636277] PM: Registering ACPI NVS region [mem 0xbf30b000-0xbf38afff] (524288 bytes)
[    1.644691] PM: Registering ACPI NVS region [mem 0xbf3a1000-0xbf3a1fff] (4096 bytes)
[    1.652919] PM: Registering ACPI NVS region [mem 0xbf3b3000-0xbf3b5fff] (12288 bytes)
[    1.661233] PM: Registering ACPI NVS region [mem 0xbf3de000-0xbf3defff] (4096 bytes)
[    1.675899] PM: Registering ACPI NVS region [mem 0xbf416000-0xbf417fff] (8192 bytes)
[    1.684122] PM: Registering ACPI NVS region [mem 0xbf420000-0xbf420fff] (4096 bytes)
[    1.692345] PM: Registering ACPI NVS region [mem 0xbf423000-0xbf42afff] (32768 bytes)
[    1.700656] PM: Registering ACPI NVS region [mem 0xbf454000-0xbf656fff] (2109440 bytes)
[    1.710514] xor: measuring software checksum speed
[    1.752645]    prefetch64-sse: 11587.000 MB/sec
[    1.796681]    generic_sse: 10190.000 MB/sec
[    1.801218] xor: using function: prefetch64-sse (11587.000 MB/sec)
[    1.807667] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    1.814873] NET: Registered protocol family 16
[    1.820151] cpuidle: using governor ladder
[    1.824516] cpuidle: using governor menu
[    1.829172] ACPI: bus type PCI registered
[    1.833451] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.840213] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    1.850002] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    1.875246] PCI: Using configuration type 1 for base access
[    1.952813] raid6: sse2x1    6760 MB/s
[    2.024868] raid6: sse2x2    8025 MB/s
[    2.096922] raid6: sse2x4    8914 MB/s
[    2.100940] raid6: using algorithm sse2x4 (8914 MB/s)
[    2.106256] raid6: using ssse3x2 recovery algorithm
[    2.111478] ACPI: Added _OSI(Module Device)
[    2.115931] ACPI: Added _OSI(Processor Device)
[    2.120639] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.125609] ACPI: Added _OSI(Processor Aggregator Device)
[    2.133166] ACPI: Executed 1 blocks of module-level executable AML code
[    2.142314] \_SB_:_OSC evaluation returned wrong type
[    2.147630] _OSC request data:1 1f 
[    2.165011] ACPI: Dynamic OEM Table Load:
[    2.169424] ACPI: SSDT 0xFFFF8802348CA000 001494 (v01 AMI    IST      00000001 MSFT 03000001)
[    2.182011] ACPI: Interpreter enabled
[    2.185948] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140325/hwxface-580)
[    2.195786] ACPI: (supports S0 S1 S3 S4 S5)
[    2.200237] ACPI: Using IOAPIC for interrupt routing
[    2.205538] HEST: Table parsing has been initialized.
[    2.210855] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.221250] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.233261] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.239715] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    2.248574] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    2.257318] PCI host bridge to bus 0000:00
[    2.261683] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.267433] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.273887] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.280340] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.287487] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    2.294644] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    2.300971] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    2.307418] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    2.313741] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.320188] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    2.326503] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    2.332955] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    2.339279] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    2.345731] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    2.352048] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.358499] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    2.364817] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    2.371270] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    2.377555] pci 0000:00:13.0: reg 0x10: [mem 0xfbe24000-0xfbe24fff]
[    2.384126] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    2.390569] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    2.396953] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    2.403336] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    2.409718] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    2.416096] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    2.422383] pci 0000:00:16.0: reg 0x10: [mem 0xfbe1c000-0xfbe1ffff 64bit]
[    2.429559] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    2.435842] pci 0000:00:16.1: reg 0x10: [mem 0xfbe18000-0xfbe1bfff 64bit]
[    2.443013] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    2.449295] pci 0000:00:16.2: reg 0x10: [mem 0xfbe14000-0xfbe17fff 64bit]
[    2.456469] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    2.462758] pci 0000:00:16.3: reg 0x10: [mem 0xfbe10000-0xfbe13fff 64bit]
[    2.469936] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    2.476220] pci 0000:00:16.4: reg 0x10: [mem 0xfbe0c000-0xfbe0ffff 64bit]
[    2.483398] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    2.489680] pci 0000:00:16.5: reg 0x10: [mem 0xfbe08000-0xfbe0bfff 64bit]
[    2.496848] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    2.503134] pci 0000:00:16.6: reg 0x10: [mem 0xfbe04000-0xfbe07fff 64bit]
[    2.510314] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    2.516596] pci 0000:00:16.7: reg 0x10: [mem 0xfbe00000-0xfbe03fff 64bit]
[    2.523779] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    2.530092] pci 0000:00:1a.0: reg 0x20: [io  0xf0c0-0xf0df]
[    2.536025] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    2.541997] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    2.548307] pci 0000:00:1a.2: reg 0x20: [io  0xf0a0-0xf0bf]
[    2.554231] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    2.560217] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    2.566512] pci 0000:00:1a.7: reg 0x10: [mem 0xfbe23000-0xfbe233ff]
[    2.573124] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.579536] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    2.585510] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    2.591854] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.598262] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    2.604239] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    2.610580] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.616990] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    2.622966] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    2.629277] pci 0000:00:1d.0: reg 0x20: [io  0xf080-0xf09f]
[    2.635200] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    2.641170] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    2.647484] pci 0000:00:1d.1: reg 0x20: [io  0xf060-0xf07f]
[    2.653406] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    2.659375] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    2.665690] pci 0000:00:1d.2: reg 0x20: [io  0xf040-0xf05f]
[    2.671621] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    2.677600] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    2.683895] pci 0000:00:1d.7: reg 0x10: [mem 0xfbe22000-0xfbe223ff]
[    2.690514] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.696926] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    2.702900] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    2.709260] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    2.715236] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    2.721581] pci 0000:00:1f.0: can't claim BAR 13 [io  0x0400-0x047f]: address conflict with ACPI CPU throttle [io  0x0410-0x0415]
[    2.733719] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    2.741124] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    2.749173] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    2.757222] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    2.765271] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    2.773427] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    2.779720] pci 0000:00:1f.2: reg 0x10: [io  0xf110-0xf117]
[    2.785564] pci 0000:00:1f.2: reg 0x14: [io  0xf100-0xf103]
[    2.791411] pci 0000:00:1f.2: reg 0x18: [io  0xf0f0-0xf0f7]
[    2.797257] pci 0000:00:1f.2: reg 0x1c: [io  0xf0e0-0xf0e3]
[    2.803102] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    2.808949] pci 0000:00:1f.2: reg 0x24: [mem 0xfbe21000-0xfbe217ff]
[    2.815524] pci 0000:00:1f.2: PME# supported from D3hot
[    2.821102] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    2.827388] pci 0000:00:1f.3: reg 0x10: [mem 0xfbe20000-0xfbe200ff 64bit]
[    2.834461] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    2.840443] pci 0000:01:00.0: [8086:10c9] type 00 class 0x020000
[    2.846727] pci 0000:01:00.0: reg 0x10: [mem 0xfbaa0000-0xfbabffff]
[    2.853265] pci 0000:01:00.0: reg 0x14: [mem 0xfba80000-0xfba9ffff]
[    2.859804] pci 0000:01:00.0: reg 0x18: [io  0xe020-0xe03f]
[    2.865651] pci 0000:01:00.0: reg 0x1c: [mem 0xfbb44000-0xfbb47fff]
[    2.872204] pci 0000:01:00.0: reg 0x30: [mem 0xfba60000-0xfba7ffff pref]
[    2.879224] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    2.885617] pci 0000:01:00.0: reg 0x184: [mem 0xfbb20000-0xfbb23fff 64bit]
[    2.892772] pci 0000:01:00.0: reg 0x190: [mem 0xfbb00000-0xfbb03fff 64bit]
[    2.899979] pci 0000:01:00.1: [8086:10c9] type 00 class 0x020000
[    2.906264] pci 0000:01:00.1: reg 0x10: [mem 0xfba40000-0xfba5ffff]
[    2.912810] pci 0000:01:00.1: reg 0x14: [mem 0xfba20000-0xfba3ffff]
[    2.919350] pci 0000:01:00.1: reg 0x18: [io  0xe000-0xe01f]
[    2.925196] pci 0000:01:00.1: reg 0x1c: [mem 0xfbb40000-0xfbb43fff]
[    2.931748] pci 0000:01:00.1: reg 0x30: [mem 0xfba00000-0xfba1ffff pref]
[    2.938768] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    2.945160] pci 0000:01:00.1: reg 0x184: [mem 0xfbae0000-0xfbae3fff 64bit]
[    2.952318] pci 0000:01:00.1: reg 0x190: [mem 0xfbac0000-0xfbac3fff 64bit]
[    2.968364] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.973859] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.980226] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    2.987335] pci 0000:00:03.0: PCI bridge to [bus 03]
[    2.992616] pci 0000:00:05.0: PCI bridge to [bus 04]
[    2.997897] pci 0000:00:07.0: PCI bridge to [bus 05]
[    3.003203] pci 0000:06:00.0: [8086:0329] type 01 class 0x060400
[    3.009492] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disabled
[    3.016682] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    3.023110] pci 0000:06:00.2: [8086:032a] type 01 class 0x060400
[    3.029398] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disabled
[    3.036591] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    3.043010] pci 0000:06:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.053498] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    3.065419] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    3.071787] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.078915] pci 0000:06:00.0: PCI bridge to [bus 07]
[    3.084204] pci 0000:08:01.0: [8086:1229] type 00 class 0x020000
[    3.090489] pci 0000:08:01.0: reg 0x10: [mem 0xfb900000-0xfb900fff]
[    3.097032] pci 0000:08:01.0: reg 0x14: [io  0xd000-0xd03f]
[    3.102878] pci 0000:08:01.0: reg 0x18: [mem 0xfb800000-0xfb8fffff]
[    3.109438] pci 0000:08:01.0: reg 0x30: [mem 0xfb700000-0xfb7fffff pref]
[    3.116431] pci 0000:08:01.0: supports D1 D2
[    3.120965] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.127926] pci 0000:06:00.2: PCI bridge to [bus 08]
[    3.133160] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    3.139518] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    3.146649] pci 0000:09:00.0: [1000:0058] type 00 class 0x010000
[    3.152939] pci 0000:09:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    3.158794] pci 0000:09:00.0: reg 0x14: [mem 0xfb610000-0xfb613fff 64bit]
[    3.165863] pci 0000:09:00.0: reg 0x1c: [mem 0xfb600000-0xfb60ffff 64bit]
[    3.172935] pci 0000:09:00.0: reg 0x30: [mem 0xfb400000-0xfb5fffff pref]
[    3.179954] pci 0000:09:00.0: supports D1 D2
[    3.184540] pci 0000:09:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.195026] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    3.200261] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    3.206619] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    3.213680] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    3.221979] pci 0000:0a:00.0: [197b:2368] type 00 class 0x010185
[    3.228275] pci 0000:0a:00.0: reg 0x10: [io  0xb040-0xb047]
[    3.234125] pci 0000:0a:00.0: reg 0x14: [io  0xb030-0xb033]
[    3.239979] pci 0000:0a:00.0: reg 0x18: [io  0xb020-0xb027]
[    3.245833] pci 0000:0a:00.0: reg 0x1c: [io  0xb010-0xb013]
[    3.251681] pci 0000:0a:00.0: reg 0x20: [io  0xb000-0xb00f]
[    3.257545] pci 0000:0a:00.0: reg 0x30: [mem 0xfbd00000-0xfbd0ffff pref]
[    3.264632] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    3.275122] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    3.280353] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    3.286711] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    3.293775] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    3.302048] pci 0000:0b:01.0: [1002:515e] type 00 class 0x030000
[    3.308340] pci 0000:0b:01.0: reg 0x10: [mem 0xf0000000-0xf7ffffff pref]
[    3.315315] pci 0000:0b:01.0: reg 0x14: [io  0xa000-0xa0ff]
[    3.321161] pci 0000:0b:01.0: reg 0x18: [mem 0xfbc20000-0xfbc2ffff]
[    3.327724] pci 0000:0b:01.0: reg 0x30: [mem 0xfbc00000-0xfbc1ffff pref]
[    3.334719] pci 0000:0b:01.0: supports D1 D2
[    3.339327] pci 0000:00:1e.0: PCI bridge to [bus 0b] (subtractive decode)
[    3.346387] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    3.352753] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    3.359817] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    3.368043] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    3.376442] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    3.384846] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    3.393945] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    3.403539] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    3.412635] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    3.421715] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15), disabled.
[    3.430797] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15), disabled.
[    3.439886] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.449204] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.458527] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    3.467843] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15), disabled.
[    3.476948] ACPI: Enabled 2 GPEs in block 00 to 3F
[    3.482276] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    3.490856] vgaarb: loaded
[    3.493830] vgaarb: bridge control possible 0000:0b:01.0
[    3.499510] SCSI subsystem initialized
[    3.503615] libata version 3.00 loaded.
[    3.507774] ACPI: bus type USB registered
[    3.512076] usbcore: registered new interface driver usbfs
[    3.517842] usbcore: registered new interface driver hub
[    3.523456] usbcore: registered new device driver usb
[    3.528818] pps_core: LinuxPPS API ver. 1 registered
[    3.534050] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.543677] PTP clock support registered
[    3.547998] EDAC MC: Ver: 3.0.0
[    3.551572] PCI: Using ACPI for IRQ routing
[    3.561349] PCI: Discovered peer bus fe
[    3.565450] PCI: root bus fe: using default resources
[    3.570767] PCI: Probing PCI hardware (bus fe)
[    3.575509] PCI host bridge to bus 0000:fe
[    3.579876] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    3.586327] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[    3.593648] pci_bus 0000:fe: No busn resource found for root bus, will use [bus fe-ff]
[    3.602046] pci_bus 0000:fe: busn_res: can not insert [bus fe-ff] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    3.613923] pci 0000:fe:00.0: [8086:2c70] type 00 class 0x060000
[    3.620253] pci 0000:fe:00.1: [8086:2d81] type 00 class 0x060000
[    3.626580] pci 0000:fe:02.0: [8086:2d90] type 00 class 0x060000
[    3.632900] pci 0000:fe:02.1: [8086:2d91] type 00 class 0x060000
[    3.639222] pci 0000:fe:02.2: [8086:2d92] type 00 class 0x060000
[    3.645546] pci 0000:fe:02.3: [8086:2d93] type 00 class 0x060000
[    3.651869] pci 0000:fe:02.4: [8086:2d94] type 00 class 0x060000
[    3.658193] pci 0000:fe:02.5: [8086:2d95] type 00 class 0x060000
[    3.664518] pci 0000:fe:03.0: [8086:2d98] type 00 class 0x060000
[    3.670839] pci 0000:fe:03.1: [8086:2d99] type 00 class 0x060000
[    3.677161] pci 0000:fe:03.2: [8086:2d9a] type 00 class 0x060000
[    3.683486] pci 0000:fe:03.4: [8086:2d9c] type 00 class 0x060000
[    3.689807] pci 0000:fe:04.0: [8086:2da0] type 00 class 0x060000
[    3.696132] pci 0000:fe:04.1: [8086:2da1] type 00 class 0x060000
[    3.702456] pci 0000:fe:04.2: [8086:2da2] type 00 class 0x060000
[    3.708778] pci 0000:fe:04.3: [8086:2da3] type 00 class 0x060000
[    3.715102] pci 0000:fe:05.0: [8086:2da8] type 00 class 0x060000
[    3.721423] pci 0000:fe:05.1: [8086:2da9] type 00 class 0x060000
[    3.727746] pci 0000:fe:05.2: [8086:2daa] type 00 class 0x060000
[    3.734070] pci 0000:fe:05.3: [8086:2dab] type 00 class 0x060000
[    3.740397] pci 0000:fe:06.0: [8086:2db0] type 00 class 0x060000
[    3.746719] pci 0000:fe:06.1: [8086:2db1] type 00 class 0x060000
[    3.753040] pci 0000:fe:06.2: [8086:2db2] type 00 class 0x060000
[    3.759363] pci 0000:fe:06.3: [8086:2db3] type 00 class 0x060000
[    3.765694] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to fe
[    3.772581] pci_bus 0000:fe: busn_res: can not insert [bus fe] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    3.784196] PCI: Discovered peer bus ff
[    3.788295] PCI: root bus ff: using default resources
[    3.793613] PCI: Probing PCI hardware (bus ff)
[    3.798354] PCI host bridge to bus 0000:ff
[    3.802720] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    3.809164] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    3.816476] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    3.824872] pci_bus 0000:ff: busn_res: can not insert [bus ff] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    3.836490] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
[    3.842816] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
[    3.849140] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
[    3.855463] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
[    3.861788] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
[    3.868109] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
[    3.874431] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
[    3.880753] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
[    3.887078] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
[    3.893401] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
[    3.899722] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
[    3.906049] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
[    3.912371] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
[    3.918692] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
[    3.925016] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
[    3.931339] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
[    3.937664] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
[    3.943986] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
[    3.950312] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
[    3.956633] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
[    3.962956] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
[    3.969279] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
[    3.975599] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
[    3.981924] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
[    3.988259] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    3.994881] pci_bus 0000:ff: busn_res: can not insert [bus ff] under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])
[    4.006496] PCI: pci_cache_line_size set to 64 bytes
[    4.011850] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    4.018124] e820: reserve RAM buffer [mem 0xbf30b000-0xbfffffff]
[    4.024396] e820: reserve RAM buffer [mem 0xbf3de000-0xbfffffff]
[    4.030674] e820: reserve RAM buffer [mem 0xbf800000-0xbfffffff]
[    4.037533] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    4.043251] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    4.051397] Switched to clocksource hpet
[    4.055658] Could not create debugfs 'set_ftrace_filter' entry
[    4.061765] Could not create debugfs 'set_ftrace_notrace' entry
[    4.078007] pnp: PnP ACPI init
[    4.081351] ACPI: bus type PNP registered
[    4.085721] system 00:00: [mem 0xfc000000-0xfcffffff] has been reserved
[    4.092610] system 00:00: [mem 0xfd000000-0xfdffffff] has been reserved
[    4.105941] system 00:00: [mem 0xfe000000-0xfe9fffff] has been reserved
[    4.112827] system 00:00: [mem 0xfea00000-0xfea0001f] has been reserved
[    4.119717] system 00:00: [mem 0xfeb00000-0xfebfffff] has been reserved
[    4.126601] system 00:00: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    4.133834] system 00:00: [mem 0xfed45000-0xfedfffff] has been reserved
[    4.140723] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.147968] system 00:01: [io  0x0290-0x029f] has been reserved
[    4.154160] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.161247] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    4.169687] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    4.177424] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    4.186036] pnp 00:03: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    4.194004] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    4.202415] pnp 00:04: [dma 0 disabled]
[    4.206577] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.213551] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    4.221953] pnp 00:05: [dma 0 disabled]
[    4.226109] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.232996] pnp 00:06: [dma 4]
[    4.236348] pnp 00:06: Plug and Play ACPI device, IDs PNP0200 (active)
[    4.243159] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    4.251597] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.258427] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[    4.265299] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    4.271498] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.278564] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    4.287174] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    4.294156] system 00:0b: [io  0x0400-0x047f] could not be reserved
[    4.300701] system 00:0b: [io  0x1180-0x119f] has been reserved
[    4.306893] system 00:0b: [io  0x0500-0x057f] could not be reserved
[    4.313433] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    4.320320] system 00:0b: [mem 0xfec00000-0xfecfffff] could not be reserved
[    4.327555] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    4.334441] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.341618] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.348547] pnp: PnP ACPI: found 13 devices
[    4.353002] ACPI: bus type PNP unregistered
[    4.364353] pci 0000:00:1f.0: BAR 13: [io  0x0400-0x047f] has bogus alignment
[    4.371767] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    4.377263] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    4.383633] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    4.390693] pci 0000:00:03.0: PCI bridge to [bus 03]
[    4.395934] pci 0000:00:05.0: PCI bridge to [bus 04]
[    4.401173] pci 0000:00:07.0: PCI bridge to [bus 05]
[    4.406413] pci 0000:06:00.0: PCI bridge to [bus 07]
[    4.411651] pci 0000:06:00.2: PCI bridge to [bus 08]
[    4.416893] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    4.423261] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.430324] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    4.435821] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    4.442188] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    4.449250] pci 0000:00:1c.0: PCI bridge to [bus 09]
[    4.454485] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    4.460853] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    4.467915] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd01fffff 64bit pref]
[    4.476146] pci 0000:00:1c.4: PCI bridge to [bus 0a]
[    4.481384] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    4.487757] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    4.494820] pci 0000:00:1c.4:   bridge window [mem 0xd0200000-0xd03fffff 64bit pref]
[    4.503053] pci 0000:00:1e.0: PCI bridge to [bus 0b]
[    4.508289] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    4.514657] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    4.521716] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.529950] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.535794] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.541637] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.548171] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    4.554711] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    4.560556] pci_bus 0000:01: resource 1 [mem 0xfba00000-0xfbbfffff]
[    4.567089] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    4.572933] pci_bus 0000:06: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.579466] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    4.585311] pci_bus 0000:08: resource 1 [mem 0xfb700000-0xfb9fffff]
[    4.591852] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    4.597697] pci_bus 0000:09: resource 1 [mem 0xfb400000-0xfb6fffff]
[    4.604236] pci_bus 0000:09: resource 2 [mem 0xd0000000-0xd01fffff 64bit pref]
[    4.611940] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    4.617786] pci_bus 0000:0a: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    4.624326] pci_bus 0000:0a: resource 2 [mem 0xd0200000-0xd03fffff 64bit pref]
[    4.632036] pci_bus 0000:0b: resource 0 [io  0xa000-0xafff]
[    4.637875] pci_bus 0000:0b: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    4.644414] pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    4.652116] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    4.657954] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    4.663799] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    4.670339] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xffffffff]
[    4.676882] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    4.682726] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    4.689442] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    4.695285] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    4.702043] NET: Registered protocol family 2
[    4.706914] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    4.715063] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.722209] TCP: Hash tables configured (established 131072 bind 65536)
[    4.729146] TCP: reno registered
[    4.732672] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    4.739096] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    4.746040] NET: Registered protocol family 1
[    4.750811] RPC: Registered named UNIX socket transport module.
[    4.757002] RPC: Registered udp transport module.
[    4.761980] RPC: Registered tcp transport module.
[    4.766955] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.773835] IOAPIC[0]: Set routing entry (0-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:0)
[    4.782629] IOAPIC[0]: Set routing entry (0-19 -> 0x51 -> IRQ 19 Mode:1 Active:1 Dest:0)
[    4.791419] IOAPIC[0]: Set routing entry (0-18 -> 0x61 -> IRQ 18 Mode:1 Active:1 Dest:0)
[    4.800223] IOAPIC[0]: Set routing entry (0-23 -> 0x71 -> IRQ 23 Mode:1 Active:1 Dest:0)
[    4.809529] pci 0000:06:00.0: rerouting interrupts for [8086:0329]
[    4.815983] pci 0000:06:00.2: rerouting interrupts for [8086:032a]
[    4.822450] pci 0000:0b:01.0: Boot video device
[    4.827296] PCI: CLS 64 bytes, default 64
[    4.831629] Trying to unpack rootfs image as initramfs...
[    8.659464] Freeing initrd memory: 215028K (ffff880072df6000 - ffff88007fff3000)
[    8.667352] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    8.674064] software IO TLB [mem 0xbb30b000-0xbf30b000] (64MB) mapped at [ffff8800bb30b000-ffff8800bf30afff]
[    8.685062] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    8.696612] Scanning for low memory corruption every 60 seconds
[    8.703817] SSE version of gcm_enc/dec engaged.
[    8.709210] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    8.715754] AVX or AES-NI instructions are not detected.
[    8.721332] AVX instructions are not detected.
[    8.726039] AVX instructions are not detected.
[    8.730749] AVX instructions are not detected.
[    8.735459] AVX instructions are not detected.
[    8.740779] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    8.769007] bounce pool size: 64 pages
[    8.773033] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.781808] VFS: Disk quotas dquot_6.5.2
[    8.786048] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    8.793660] NFS: Registering the id_resolver key type
[    8.798996] Key type id_resolver registered
[    8.803446] Key type id_legacy registered
[    8.807725] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    8.814699] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    8.821621] ROMFS MTD (C) 2007 Red Hat, Inc.
[    8.826232] fuse init (API version 7.23)
[    8.830562] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    8.841119] msgmni has been set to 32056
[    8.847265] NET: Registered protocol family 38
[    8.851979] Key type asymmetric registered
[    8.856393] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    8.864346] io scheduler noop registered
[    8.868534] io scheduler deadline registered
[    8.873077] io scheduler cfq registered (default)
[    8.878364] IOAPIC[3]: Set routing entry (4-4 -> 0x81 -> IRQ 76 Mode:1 Active:1 Dest:0)
[    8.886885] pcieport 0000:00:01.0: irq 112 for MSI/MSI-X
[    8.892638] IOAPIC[3]: Set routing entry (4-0 -> 0xa1 -> IRQ 72 Mode:1 Active:1 Dest:0)
[    8.901154] pcieport 0000:00:03.0: irq 113 for MSI/MSI-X
[    8.906906] IOAPIC[3]: Set routing entry (4-2 -> 0xc1 -> IRQ 74 Mode:1 Active:1 Dest:0)
[    8.915421] pcieport 0000:00:05.0: irq 114 for MSI/MSI-X
[    8.921172] IOAPIC[3]: Set routing entry (4-6 -> 0xe1 -> IRQ 78 Mode:1 Active:1 Dest:0)
[    8.929680] pcieport 0000:00:07.0: irq 115 for MSI/MSI-X
[    8.935440] IOAPIC[3]: Set routing entry (4-8 -> 0x42 -> IRQ 80 Mode:1 Active:1 Dest:0)
[    8.950391] pcieport 0000:00:09.0: irq 116 for MSI/MSI-X
[    8.956149] IOAPIC[0]: Set routing entry (0-17 -> 0x62 -> IRQ 17 Mode:1 Active:1 Dest:0)
[    8.964751] pcieport 0000:00:1c.0: irq 117 for MSI/MSI-X
[    8.970554] pcieport 0000:00:1c.4: irq 118 for MSI/MSI-X
[    8.976305] aer 0000:00:01.0:pcie02: service driver aer loaded
[    8.982438] aer 0000:00:03.0:pcie02: service driver aer loaded
[    8.988569] aer 0000:00:05.0:pcie02: service driver aer loaded
[    8.994687] aer 0000:00:07.0:pcie02: service driver aer loaded
[    9.000811] aer 0000:00:09.0:pcie02: service driver aer loaded
[    9.006931] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    9.014168] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    9.020967] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    9.027768] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    9.034747] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    9.041983] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    9.048964] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    9.056199] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    9.063179] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    9.070418] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    9.077399] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    9.084632] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    9.091430] pci 0000:06:00.2: Signaling PME through PCIe PME interrupt
[    9.098232] pci 0000:08:01.0: Signaling PME through PCIe PME interrupt
[    9.105032] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    9.112022] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    9.119257] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    9.126060] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    9.133047] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    9.140284] pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
[    9.147085] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    9.154075] ioapic: probe of 0000:00:13.0 failed with error -22
[    9.160282] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.166167] pciehp 0000:00:1c.0:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[    9.177332] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    9.183967] pciehp 0000:00:1c.4:pcie04: Slot #0 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[    9.195129] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[    9.201761] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    9.208652] intel_idle: MWAIT substates: 0x1120
[    9.213454] intel_idle: v0.4 model 0x2C
[    9.217556] intel_idle: lapic_timer_reliable_states 0xffffffff
[    9.224717] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    9.233555] ACPI: Sleep Button [SLPB]
[    9.237537] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    9.246372] ACPI: Power Button [PWRB]
[    9.250346] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    9.258228] ACPI: Power Button [PWRF]
[    9.262217] ERST: Can not request [mem 0xbf3b303f-0xbf3b503e] for ERST.
[    9.311819] ghes_edac: This EDAC driver relies on BIOS to enumerate memory and get error reports.
[    9.321176] ghes_edac: Unfortunately, not all BIOSes reflect the memory layout correctly.
[    9.329837] ghes_edac: So, the end result of using this driver varies from vendor to vendor.
[    9.338754] ghes_edac: If you find incorrect reports, please contact your hardware vendor
[    9.347410] ghes_edac: to correct its BIOS.
[    9.351860] ghes_edac: This system has 18 DIMM sockets.
[    9.357553] EDAC MC0: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[    9.367596] EDAC MC1: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
[    9.377570] [Firmware Warn]: GHES: Poll interval is 0 for generic hardware error source: 1, disabled.
[    9.387337] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    9.393897] EINJ: Error INJection is initialized.
[    9.398951] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    9.425879] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    9.454076] 00:05: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    9.462628] Non-volatile memory driver v1.3
[    9.469083] brd: module loaded
[    9.473299] loop: module loaded
[    9.476777] lkdtm: No crash points registered, enable through debugfs
[    9.483679] Loading iSCSI transport class v2.0-870.
[    9.489098] Adaptec aacraid driver 1.2-0[30300]-ms
[    9.494198] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    9.501312] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.02-k.
[    9.510026] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    9.517888] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    9.525141] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[    9.531813] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    9.538203] RocketRAID 3xxx/4xxx Controller driver v1.8
[    9.543785] ahci 0000:00:1f.2: version 3.0
[    9.548304] ahci 0000:00:1f.2: irq 119 for MSI/MSI-X
[    9.553605] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    9.562262] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs 
[    9.608796] scsi0 : ahci
[    9.611945] scsi1 : ahci
[    9.615088] scsi2 : ahci
[    9.618281] scsi3 : ahci
[    9.621408] scsi4 : ahci
[    9.624613] scsi5 : ahci
[    9.627482] ata1: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21100 irq 119
[    9.635461] ata2: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21180 irq 119
[    9.643428] ata3: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21200 irq 119
[    9.651391] ata4: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21280 irq 119
[    9.659352] ata5: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21300 irq 119
[    9.667316] ata6: SATA max UDMA/133 abar m2048@0xfbe21000 port 0xfbe21380 irq 119
[    9.675425] tun: Universal TUN/TAP device driver, 1.6
[    9.680752] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    9.687598] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    9.694789] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    9.696054] tsc: Refined TSC clocksource calibration: 2800.098 MHz
[    9.706902] Copyright (c) 2007 Atheros Corporation.
[    9.712158] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    9.719158] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    9.719158]   http://www.scyld.com/network/drivers.html
[    9.731962] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    9.739146] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    9.745509] e100: Copyright(c) 1999-2006 Intel Corporation
[    9.751309] e100 0000:08:01.0: PCI IRQ 48 -> rerouted to legacy IRQ 16
[    9.782243] e100 0000:08:01.0 eth0: addr 0xfb900000, irq 16, MAC addr 00:0e:0c:7f:c7:3e
[    9.790754] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    9.798072] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    9.804109] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    9.810215] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    9.816428] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    9.823660] igb: Copyright (c) 2007-2014 Intel Corporation.
[    9.829840] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    9.834993] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    9.840144] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    9.845304] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    9.850456] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    9.855609] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    9.860762] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    9.865912] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    9.871067] igb 0000:01:00.0: irq 128 for MSI/MSI-X
[    9.876274] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    9.881422] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    9.886573] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    9.891726] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    9.896879] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    9.902021] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    9.907174] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    9.912327] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    9.917479] igb 0000:01:00.0: irq 128 for MSI/MSI-X
[    9.992268] ata4: SATA link down (SStatus 0 SControl 300)
[    9.997959] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   10.004428] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   10.010896] ata3: SATA link down (SStatus 0 SControl 300)
[   10.016580] ata5: SATA link down (SStatus 0 SControl 300)
[   10.022269] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   10.028887] ata1.00: ATA-8: WDC WD1002FAEX-00Z3A0, 05.01D05, max UDMA/133
[   10.035955] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   10.043713] ata6.00: ATAPI: Slimtype DVD A  DS8A2S, 6P5D, max UDMA/100
[   10.052477] ata1.00: configured for UDMA/133
[   10.057335] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 05.0 PQ: 0 ANSI: 5
[   10.060901] ata6.00: configured for UDMA/100
[   10.067816] ata2.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[   10.067817] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   10.083654] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.083691] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   10.083729] sd 0:0:0:0: [sda] Write Protect is off
[   10.083730] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   10.083743] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.124867] igb 0000:01:00.0: added PHC on eth1
[   10.126168] ata2.00: configured for UDMA/133
[   10.126320] scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[   10.126477] sd 1:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[   10.126504] sd 1:0:0:0: [sdb] Write Protect is off
[   10.126506] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   10.126513] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   10.126518] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   10.128828]  sda: sda1 sda2 sda3
[   10.129100] sd 0:0:0:0: [sda] Attached SCSI disk
[   10.129486] scsi 5:0:0:0: CD-ROM            Slimtype DVD A  DS8A2S    6P5D PQ: 0 ANSI: 5
[   10.165914]  sdb: sdb1 sdb2
[   10.166132] sd 1:0:0:0: [sdb] Attached SCSI disk
[   10.207542] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   10.209549] scsi 5:0:0:0: Attached scsi generic sg2 type 5
[   10.220441] igb 0000:01:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:26
[   10.227849] igb 0000:01:00.0: eth1: PBA No: Unknown
[   10.232991] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   10.241224] IOAPIC[3]: Set routing entry (4-16 -> 0x44 -> IRQ 88 Mode:1 Active:1 Dest:0)
[   10.250052] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[   10.255203] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[   10.260418] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[   10.265587] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[   10.270745] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[   10.275896] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[   10.281054] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[   10.286211] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[   10.291364] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[   10.296571] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[   10.301728] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[   10.306878] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[   10.312032] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[   10.317182] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[   10.322335] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[   10.327487] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[   10.332639] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[   10.337791] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[   10.533253] igb 0000:01:00.1: added PHC on eth2
[   10.538077] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   10.545222] igb 0000:01:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:27
[   10.552629] igb 0000:01:00.1: eth2: PBA No: Unknown
[   10.557771] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   10.565852] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   10.574087] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   10.580144] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   10.587549] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   10.593521] sky2: driver version 1.30
[   10.597616] usbcore: registered new interface driver catc
[   10.603302] usbcore: registered new interface driver kaweth
[   10.609147] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   10.617039] usbcore: registered new interface driver pegasus
[   10.622979] usbcore: registered new interface driver rtl8150
[   10.628926] usbcore: registered new interface driver asix
[   10.634608] usbcore: registered new interface driver ax88179_178a
[   10.640978] usbcore: registered new interface driver cdc_ether
[   10.647095] usbcore: registered new interface driver cdc_eem
[   10.653036] usbcore: registered new interface driver dm9601
[   10.658893] usbcore: registered new interface driver smsc75xx
[   10.664930] usbcore: registered new interface driver smsc95xx
[   10.670956] usbcore: registered new interface driver gl620a
[   10.676811] usbcore: registered new interface driver net1080
[   10.682753] usbcore: registered new interface driver plusb
[   10.688521] usbcore: registered new interface driver rndis_host
[   22.202268] usbcore: registered new interface driver cdc_subset
[   22.202282] Switched to clocksource tsc
[   22.212581] usbcore: registered new interface driver zaurus
[   22.218429] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   22.226322] usbcore: registered new interface driver int51x1
[   22.232261] usbcore: registered new interface driver ipheth
[   22.238108] usbcore: registered new interface driver sierra_net
[   22.244307] usbcore: registered new interface driver cdc_ncm
[   22.250234] Fusion MPT base driver 3.04.20
[   22.254594] Copyright (c) 1999-2008 LSI Corporation
[   22.259745] Fusion MPT SPI Host driver 3.04.20
[   22.264479] Fusion MPT FC Host driver 3.04.20
[   22.269119] Fusion MPT SAS Host driver 3.04.20
[   22.273994] mptbase: ioc0: Initiating bringup
[   22.982905] ioc0: LSISAS1068E B2: Capabilities={Initiator}
[   42.382764] scsi6 : ioc0: LSISAS1068E B2, FwRev=01120000h, Ports=1, MaxQ=511, IRQ=16
[   42.420332] mptsas: ioc0: add expander: num_phys 25, sas_addr (0x5000155d25e3423f)
[   42.518875] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 36, phy 0, sas_addr 0x5000155d25e34200
[   42.531925] scsi 6:0:0:0: Direct-Access     ATA      ST31000528AS     CC35 PQ: 0 ANSI: 5
[   42.545418] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   42.545924] sd 6:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[   42.560579] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 28, phy 1, sas_addr 0x5000c500022c41a5
[   42.571906] scsi 6:0:1:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   42.584146] sd 6:0:1:0: Attached scsi generic sg4 type 0
[   42.611478] sd 6:0:0:0: [sdc] Write Protect is off
[   42.616558] sd 6:0:0:0: [sdc] Mode Sense: 73 00 00 08
[   42.616617] sd 6:0:1:0: [sdd] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   42.629923] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 32, phy 2, sas_addr 0x5000c50013005f59
[   42.631365] sd 6:0:1:0: [sdd] Write Protect is off
[   42.631367] sd 6:0:1:0: [sdd] Mode Sense: b3 00 10 08
[   42.632147] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   42.633045] sd 6:0:1:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   42.677598] scsi 6:0:2:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   42.689910] sd 6:0:2:0: Attached scsi generic sg5 type 0
[   42.690480] sd 6:0:2:0: [sde] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   42.692220] sd 6:0:2:0: [sde] Write Protect is off
[   42.692223] sd 6:0:2:0: [sde] Mode Sense: b3 00 10 08
[   42.693661] sd 6:0:2:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   42.715324]  sdd: sdd1 sdd2
[   42.739465] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 30, phy 3, sas_addr 0x5000c500130fe681
[   42.750901] scsi 6:0:3:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   42.753420] sd 6:0:1:0: [sdd] Attached SCSI disk
[   42.761717]  sde: sde1 sde2
[   42.766642] sd 6:0:2:0: [sde] Attached SCSI disk
[   42.775914] sd 6:0:3:0: Attached scsi generic sg6 type 0
[   42.781589]  sdc: sdc1 sdc2 sdc3
[   42.781884] sd 6:0:3:0: [sdf] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   42.783435] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 15, phy 4, sas_addr 0x5000c500022d25dd
[   42.784615] scsi 6:0:4:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   42.784711] sd 6:0:3:0: [sdf] Write Protect is off
[   42.784713] sd 6:0:3:0: [sdf] Mode Sense: b3 00 10 08
[   42.786738] sd 6:0:3:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   42.809076] sd 6:0:4:0: Attached scsi generic sg7 type 0
[   42.831243] sd 6:0:4:0: [sdg] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   42.831846] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 14, phy 5, sas_addr 0x5000c500022d09b5
[   42.832991] scsi 6:0:5:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   42.833624] sd 6:0:4:0: [sdg] Write Protect is off
[   42.833626] sd 6:0:4:0: [sdg] Mode Sense: b3 00 10 08
[   42.835835] sd 6:0:4:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   42.857310]  sdf: sdf1 sdf2
[   42.857543] sd 6:0:5:0: Attached scsi generic sg8 type 0
[   42.899395] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 19, phy 6, sas_addr 0x5000c500022c3f65
[   42.901494] sd 6:0:5:0: [sdh] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   42.903372] sd 6:0:5:0: [sdh] Write Protect is off
[   42.903374] sd 6:0:5:0: [sdh] Mode Sense: b3 00 10 08
[   42.905172] sd 6:0:5:0: [sdh] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   42.905213] sd 6:0:3:0: [sdf] Attached SCSI disk
[   42.948866]  sdg: sdg1 sdg2
[   42.949353] scsi 6:0:6:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   42.952993] sd 6:0:6:0: Attached scsi generic sg9 type 0
[   42.973856] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 17, phy 7, sas_addr 0x5000c500022d2a0d
[   42.984106]  sdh: sdh1 sdh2
[   43.005584] sd 6:0:6:0: [sdi] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   43.027111] scsi 6:0:7:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   43.028734] sd 6:0:6:0: [sdi] Write Protect is off
[   43.028736] sd 6:0:6:0: [sdi] Mode Sense: b3 00 10 08
[   43.029439] sd 6:0:0:0: [sdc] Attached SCSI disk
[   43.030416] sd 6:0:6:0: [sdi] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   43.052176] sd 6:0:4:0: [sdg] Attached SCSI disk
[   43.052302] sd 6:0:5:0: [sdh] Attached SCSI disk
[   43.080218] sd 6:0:7:0: Attached scsi generic sg10 type 0
[   43.101760]  sdi: sdi1 sdi2
[   43.102354] sd 6:0:7:0: [sdj] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   43.102987] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 16, phy 8, sas_addr 0x5000c500022d0f35
[   43.104203] scsi 6:0:8:0: Direct-Access     SEAGATE  ST3300555SS      XRT0 PQ: 0 ANSI: 5
[   43.104828] sd 6:0:7:0: [sdj] Write Protect is off
[   43.104829] sd 6:0:7:0: [sdj] Mode Sense: b3 00 10 08
[   43.107041] sd 6:0:7:0: [sdj] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   43.128763] sd 6:0:8:0: Attached scsi generic sg11 type 0
[   43.172777] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 33, phy 9, sas_addr 0x5000c500130e21cd
[   43.172829] sd 6:0:8:0: [sdk] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   43.195818] sd 6:0:8:0: [sdk] Write Protect is off
[   43.200904] sd 6:0:8:0: [sdk] Mode Sense: b3 00 10 08
[   43.207532] sd 6:0:6:0: [sdi] Attached SCSI disk
[   43.212529] sd 6:0:8:0: [sdk] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   43.212961] scsi 6:0:9:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   43.216533] sd 6:0:9:0: Attached scsi generic sg12 type 0
[   43.217027] sd 6:0:9:0: [sdl] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   43.218578] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 31, phy 10, sas_addr 0x5000c500130f4f4d
[   43.218945]  sdj: sdj1 sdj2
[   43.219902] sd 6:0:9:0: [sdl] Write Protect is off
[   43.219904] sd 6:0:9:0: [sdl] Mode Sense: b3 00 10 08
[   43.241966] scsi 6:0:10:0: Direct-Access     SEAGATE  ST3300656SS      HS09 PQ: 0 ANSI: 5
[   43.242277] sd 6:0:9:0: [sdl] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   43.266535] sd 6:0:10:0: Attached scsi generic sg13 type 0
[   43.267636] sd 6:0:7:0: [sdj] Attached SCSI disk
[   43.267638] sd 6:0:10:0: [sdm] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   43.268238] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 35, phy 11, sas_addr 0x5000c50017cc2595
[   43.269396] scsi 6:0:11:0: Direct-Access     SEAGATE  ST3300657SS      0006 PQ: 0 ANSI: 5
[   43.269912] sd 6:0:10:0: [sdm] Write Protect is off
[   43.269914] sd 6:0:10:0: [sdm] Mode Sense: b3 00 10 08
[   43.271996] sd 6:0:10:0: [sdm] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   43.272570] sd 6:0:11:0: Attached scsi generic sg14 type 0
[   43.293681] random: nonblocking pool is initialized with 136 bits of entropy and 0 bits of DRBG data
[   43.293753]  sdl: sdl1 sdl2
[   43.295067] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 34, phy 24, sas_addr 0x5000155d25e3423e
[   43.295117] sd 6:0:11:0: [sdn] 585937500 512-byte logical blocks: (300 GB/279 GiB)
[   43.296729] sd 6:0:11:0: [sdn] Write Protect is off
[   43.296731] sd 6:0:11:0: [sdn] Mode Sense: bb 00 10 08
[   43.298130] sd 6:0:11:0: [sdn] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   43.298634] scsi 6:0:12:0: Enclosure         PROMISE  2U-SAS-12-S BP   0301 PQ: 0 ANSI: 5
[   43.299451] sd 6:0:9:0: [sdl] Attached SCSI disk
[   43.322325]  sdm: sdm1 sdm2
[   43.327874] sd 6:0:10:0: [sdm] Attached SCSI disk
[   43.328343]  sdn: sdn1 sdn2
[   43.328677] scsi 6:0:12:0: Attached scsi generic sg15 type 13
[   43.331707] Fusion MPT misc device (ioctl) driver 3.04.20
[   43.331869] mptctl: Registered with Fusion MPT base driver
[   43.331870] mptctl: /dev/mptctl @ (major,minor=10,220)
[   43.332040] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   43.332044] ehci-pci: EHCI PCI platform driver
[   43.332230] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   43.332393] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   43.332408] ehci-pci 0000:00:1a.7: debug port 1
[   43.334018] sd 6:0:11:0: [sdn] Attached SCSI disk
[   43.336312] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   43.336327] ehci-pci 0000:00:1a.7: irq 18, io mem 0xfbe23000
[   43.347499] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   43.347780] hub 1-0:1.0: USB hub found
[   43.347786] hub 1-0:1.0: 6 ports detected
[   43.348078] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   43.348224] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   43.348241] ehci-pci 0000:00:1d.7: debug port 1
[   43.352133] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   43.352151] ehci-pci 0000:00:1d.7: irq 23, io mem 0xfbe22000
[   43.363528] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   43.363816] hub 2-0:1.0: USB hub found
[   43.363821] hub 2-0:1.0: 6 ports detected
[   43.363990] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   43.363993] ohci-pci: OHCI PCI platform driver
[   43.364009] uhci_hcd: USB Universal Host Controller Interface driver
[   43.364141] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   43.364266] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   43.364275] uhci_hcd 0000:00:1a.0: detected 2 ports
[   43.364298] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[   43.364563] hub 3-0:1.0: USB hub found
[   43.364568] hub 3-0:1.0: 2 ports detected
[   43.364778] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   43.364916] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   43.364923] uhci_hcd 0000:00:1a.2: detected 2 ports
[   43.364952] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
[   43.365157] hub 4-0:1.0: USB hub found
[   43.365162] hub 4-0:1.0: 2 ports detected
[   43.365372] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   43.365524] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   43.365531] uhci_hcd 0000:00:1d.0: detected 2 ports
[   43.365551] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   43.365833] hub 5-0:1.0: USB hub found
[   43.365838] hub 5-0:1.0: 2 ports detected
[   43.366049] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   43.366162] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   43.366168] uhci_hcd 0000:00:1d.1: detected 2 ports
[   43.366189] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   43.366361] hub 6-0:1.0: USB hub found
[   43.366366] hub 6-0:1.0: 2 ports detected
[   43.366572] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   43.366669] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   43.366676] uhci_hcd 0000:00:1d.2: detected 2 ports
[   43.366696] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   43.366894] hub 7-0:1.0: USB hub found
[   43.366899] hub 7-0:1.0: 2 ports detected
[   43.367035] usbcore: registered new interface driver usb-storage
[   43.367044] usbcore: registered new interface driver ums-alauda
[   43.367052] usbcore: registered new interface driver ums-datafab
[   43.367059] usbcore: registered new interface driver ums-freecom
[   43.367073] usbcore: registered new interface driver ums-isd200
[   43.367080] usbcore: registered new interface driver ums-jumpshot
[   43.367090] usbcore: registered new interface driver ums-sddr09
[   43.367098] usbcore: registered new interface driver ums-sddr55
[   43.367109] usbcore: registered new interface driver ums-usbat
[   43.367122] usbcore: registered new interface driver usbtest
[   43.367169] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   43.369602] serio: i8042 KBD port at 0x60,0x64 irq 1
[   43.369605] serio: i8042 AUX port at 0x60,0x64 irq 12
[   43.369767] mousedev: PS/2 mouse device common for all mice
[   43.370138] rtc_cmos 00:07: RTC can wake from S4
[   43.370357] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   43.370390] rtc_cmos 00:07: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[   43.370415] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   43.370432] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[   43.370642] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   43.370648] iTCO_vendor_support: vendor-support=0
[   43.370737] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   43.370737] md: linear personality registered for level -1
[   43.370738] md: raid0 personality registered for level 0
[   43.370739] md: raid1 personality registered for level 1
[   43.370739] md: raid10 personality registered for level 10
[   43.370843] md: raid6 personality registered for level 6
[   43.370844] md: raid5 personality registered for level 5
[   43.370845] md: raid4 personality registered for level 4
[   43.370845] md: multipath personality registered for level -4
[   43.370846] md: faulty personality registered for level -5
[   43.371612] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   43.372414] device-mapper: multipath: version 1.7.0 loaded
[   43.372415] device-mapper: multipath round-robin: version 1.0.0 loaded
[   43.372431] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   43.372431] device-mapper: cache cleaner: version 1.0.0 loaded
[   43.372510] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   43.372768] usbcore: registered new interface driver usbhid
[   43.372768] usbhid: USB HID core driver
[   43.372871] TCP: bic registered
[   43.372872] Initializing XFRM netlink socket
[   43.373019] NET: Registered protocol family 10
[   43.373796] sit: IPv6 over IPv4 tunneling driver
[   43.373945] NET: Registered protocol family 17
[   43.373962] 8021q: 802.1Q VLAN Support v1.8
[   43.375022] DCCP: Activated CCID 2 (TCP-like)
[   43.375034] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   43.375519] sctp: Hash tables configured (established 65536 bind 65536)
[   43.375599] tipc: Activated (version 2.0.0)
[   43.375648] NET: Registered protocol family 30
[   43.375718] tipc: Started in single node mode
[   43.375723] Key type dns_resolver registered
[   43.376914] 
[   43.376914] printing PIC contents
[   43.376918] ... PIC  IMR: ffff
[   43.376921] ... PIC  IRR: 0c20
[   43.376930] ... PIC  ISR: 0000
[   43.376932] ... PIC ELCR: 0e20
[   43.376933] printing local APIC contents on CPU#0/0:
[   43.376934] ... APIC ID:      00000000 (0)
[   43.376934] ... APIC VERSION: 01060015
[   43.376935] ... APIC TASKPRI: 00000000 (00)
[   43.376935] ... APIC PROCPRI: 00000000
[   43.376936] ... APIC LDR: 01000000
[   43.376936] ... APIC DFR: ffffffff
[   43.376936] ... APIC SPIV: 000001ff
[   43.376937] ... APIC ISR field:
[   43.376939] 0000000000000000000000000000000000000000000000000000000000000000
[   43.376939] ... APIC TMR field:
[   43.376941] 0000000000000000000000020002000000000000000000000000000000000000
[   43.376941] ... APIC IRR field:
[   43.376943] 0000000000000000000000000000000000000000000000000000000000000000
[   43.376944] ... APIC ESR: 00000000
[   43.376944] ... APIC ICR: 000000fd
[   43.376944] ... APIC ICR2: 32000000
[   43.376945] ... APIC LVTT: 000000ef
[   43.376945] ... APIC LVTPC: 00000400
[   43.376945] ... APIC LVT0: 00010700
[   43.376946] ... APIC LVT1: 00000400
[   43.376946] ... APIC LVTERR: 000000fe
[   43.376946] ... APIC TMICT: 00008201
[   43.376947] ... APIC TMCCT: 0000523f
[   43.376947] ... APIC TDCR: 00000003
[   43.376947] 
[   43.376948] number of MP IRQ sources: 15.
[   43.376948] number of IO-APIC #0 registers: 24.
[   43.376949] number of IO-APIC #2 registers: 24.
[   43.376949] number of IO-APIC #3 registers: 24.
[   43.376950] number of IO-APIC #4 registers: 24.
[   43.376950] testing the IO APIC.......................
[   43.376957] IO APIC #0......
[   43.376957] .... register #00: 00000000
[   43.376957] .......    : physical APIC id: 00
[   43.376958] .......    : Delivery Type: 0
[   43.376958] .......    : LTS          : 0
[   43.376959] .... register #01: 00170020
[   43.376959] .......     : max redirection entries: 17
[   43.376959] .......     : PRQ implemented: 0
[   43.376960] .......     : IO APIC version: 20
[   43.376960] .... IRQ redirection table:
[   43.376964] 1    0    0   0   0    0    0    00
[   43.376968] 0    0    0   0   0    0    0    31
[   43.376972] 0    0    0   0   0    0    0    30
[   43.376976] 0    0    0   0   0    0    0    33
[   43.376980] 0    0    0   0   0    0    0    34
[   43.376984] 0    0    0   0   0    0    0    35
[   43.376988] 0    0    0   0   0    0    0    36
[   43.376992] 0    0    0   0   0    0    0    37
[   43.376996] 0    0    0   0   0    0    0    38
[   43.377000] 0    1    0   0   0    0    0    39
[   43.377004] 0    0    0   0   0    0    0    3A
[   43.377008] 0    0    0   0   0    0    0    3B
[   43.377012] 0    0    0   0   0    0    0    3C
[   43.377016] 0    0    0   0   0    0    0    3D
[   43.377020] 0    0    0   0   0    0    0    3E
[   43.377024] 0    0    0   0   0    0    0    3F
[   43.377028] 0    1    0   1   0    0    0    41
[   43.377032] 1    1    0   1   0    0    0    62
[   43.377036] 0    1    0   1   0    0    0    61
[   43.377040] 0    1    0   1   0    0    0    51
[   43.377044] 1    0    0   0   0    0    0    00
[   43.377049] 1    0    0   0   0    0    2    33
[   43.377052] 1    0    0   0   0    0    0    00
[   43.377057] 0    1    0   1   0    0    0    71
[   43.377059] IO APIC #2......
[   43.377060] .... register #00: 02000000
[   43.377060] .......    : physical APIC id: 02
[   43.377060] .......    : Delivery Type: 0
[   43.377061] .......    : LTS          : 0
[   43.377061] .... register #01: 00178020
[   43.377062] .......     : max redirection entries: 17
[   43.377062] .......     : PRQ implemented: 1
[   43.377062] .......     : IO APIC version: 20
[   43.377063] .... register #02: 02000000
[   43.377063] .......     : arbitration: 02
[   43.377063] .... register #03: 00000001
[   43.377064] .......     : Boot DT    : 1
[   43.377064] .... IRQ redirection table:
[   43.377066] 1    0    0   0   0    0    0    00
[   43.377068] 1    0    0   0   0    0    0    00
[   43.377070] 1    0    0   0   0    0    0    00
[   43.377072] 1    0    0   0   0    0    0    00
[   43.377074] 1    0    0   0   0    0    0    00
[   43.377076] 1    0    0   0   0    0    0    00
[   43.377078] 1    0    0   0   0    0    0    00
[   43.377080] 1    0    0   0   0    0    0    00
[   43.377082] 1    0    0   0   0    0    0    00
[   43.377084] 1    0    0   0   0    0    0    00
[   43.377086] 1    0    0   0   0    0    0    00
[   43.377088] 1    0    0   0   0    0    0    00
[   43.377090] 1    0    0   0   0    0    0    00
[   43.377092] 1    0    0   0   0    0    0    00
[   43.377094] 1    0    0   0   0    0    0    00
[   43.377096] 1    0    0   0   0    0    0    00
[   43.377098] 1    0    0   0   0    0    0    00
[   43.377100] 1    0    0   0   0    0    0    00
[   43.377102] 1    0    0   0   0    0    0    00
[   43.377104] 1    0    0   0   0    0    0    00
[   43.377106] 1    0    0   0   0    0    0    00
[   43.377107] 1    0    0   0   0    0    0    00
[   43.377109] 1    0    0   0   0    0    0    00
[   43.377111] 1    0    0   0   0    0    0    00
[   43.377114] IO APIC #3......
[   43.377114] .... register #00: 03000000
[   43.377115] .......    : physical APIC id: 03
[   43.377115] .......    : Delivery Type: 0
[   43.377115] .......    : LTS          : 0
[   43.377116] .... register #01: 00178020
[   43.377116] .......     : max redirection entries: 17
[   43.377117] .......     : PRQ implemented: 1
[   43.377117] .......     : IO APIC version: 20
[   43.377117] .... register #02: 03000000
[   43.377118] .......     : arbitration: 03
[   43.377118] .... register #03: 00000001
[   43.377118] .......     : Boot DT    : 1
[   43.377119] .... IRQ redirection table:
[   43.377121] 1    0    0   0   0    0    0    00
[   43.377123] 1    0    0   0   0    0    0    00
[   43.377125] 1    0    0   0   0    0    0    00
[   43.377126] 1    0    0   0   0    0    0    00
[   43.377128] 1    0    0   0   0    0    0    00
[   43.377130] 1    0    0   0   0    0    0    00
[   43.377132] 1    0    0   0   0    0    0    00
[   43.377134] 1    0    0   0   0    0    0    00
[   43.377136] 1    0    0   0   0    0    0    00
[   43.377138] 1    0    0   0   0    0    0    00
[   43.377140] 1    0    0   0   0    0    0    00
[   43.377142] 1    0    0   0   0    0    0    00
[   43.377144] 1    0    0   0   0    0    0    00
[   43.377146] 1    0    0   0   0    0    0    00
[   43.377148] 1    0    0   0   0    0    0    00
[   43.377150] 1    0    0   0   0    0    0    00
[   43.377152] 1    0    0   0   0    0    0    00
[   43.377154] 1    0    0   0   0    0    0    00
[   43.377156] 1    0    0   0   0    0    0    00
[   43.377158] 1    0    0   0   0    0    0    00
[   43.377160] 1    0    0   0   0    0    0    00
[   43.377162] 1    0    0   0   0    0    0    00
[   43.377164] 1    0    0   0   0    0    0    00
[   43.377166] 1    0    0   0   0    0    0    00
[   43.377169] IO APIC #4......
[   43.377170] .... register #00: 04000000
[   43.377170] .......    : physical APIC id: 04
[   43.377170] .......    : Delivery Type: 0
[   43.377171] .......    : LTS          : 0
[   43.377171] .... register #01: 00170020
[   43.377171] .......     : max redirection entries: 17
[   43.377172] .......     : PRQ implemented: 0
[   43.377172] .......     : IO APIC version: 20
[   43.377172] .... register #02: 00000000
[   43.377173] .......     : arbitration: 00
[   43.377173] .... register #03: 00000001
[   43.377173] .......     : Boot DT    : 1
[   43.377174] .... IRQ redirection table:
[   43.377176] 1    1    0   1   0    0    0    A1
[   43.377178] 1    0    0   0   0    0    0    00
[   43.377181] 1    1    0   1   0    0    0    C1
[   43.377183] 1    0    0   0   0    0    0    00
[   43.377185] 1    1    0   1   0    0    0    81
[   43.377188] 1    0    0   0   0    0    0    00
[   43.377190] 1    1    0   1   0    0    0    E1
[   43.377193] 1    0    0   0   0    0    0    00
[   43.377195] 1    1    0   1   0    0    0    42
[   43.377197] 1    0    0   0   0    0    0    00
[   43.377200] 1    0    0   0   0    0    0    00
[   43.377202] 1    0    0   0   0    0    0    00
[   43.377204] 1    0    0   0   0    0    0    00
[   43.377207] 1    0    0   0   0    0    0    00
[   43.377209] 1    0    0   0   0    0    0    00
[   43.377211] 1    0    0   0   0    0    0    00
[   43.377214] 1    1    0   1   0    0    0    44
[   43.377216] 1    0    0   0   0    0    0    00
[   43.377219] 1    0    0   0   0    0    0    00
[   43.377221] 1    0    0   0   0    0    0    00
[   43.377223] 1    0    0   0   0    0    0    00
[   43.377226] 1    0    0   0   0    0    0    00
[   43.377228] 1    0    0   0   0    0    0    00
[   43.377230] 1    0    0   0   0    0    0    00
[   43.377231] IRQ to pin mappings:
[   43.377232] IRQ0 -> 0:2
[   43.377233] IRQ1 -> 0:1
[   43.377234] IRQ3 -> 0:3
[   43.377235] IRQ4 -> 0:4
[   43.377236] IRQ5 -> 0:5
[   43.377236] IRQ6 -> 0:6
[   43.377237] IRQ7 -> 0:7
[   43.377238] IRQ8 -> 0:8
[   43.377238] IRQ9 -> 0:9
[   43.377239] IRQ10 -> 0:10
[   43.377240] IRQ11 -> 0:11
[   43.377241] IRQ12 -> 0:12
[   43.377241] IRQ13 -> 0:13
[   43.377242] IRQ14 -> 0:14
[   43.377243] IRQ15 -> 0:15
[   43.377244] IRQ16 -> 0:16
[   43.377245] IRQ17 -> 0:17
[   43.377246] IRQ18 -> 0:18
[   43.377247] IRQ19 -> 0:19
[   43.377247] IRQ23 -> 0:23
[   43.377248] IRQ72 -> 3:0
[   43.377250] IRQ74 -> 3:2
[   43.377250] IRQ76 -> 3:4
[   43.377251] IRQ78 -> 3:6
[   43.377252] IRQ80 -> 3:8
[   43.377254] IRQ88 -> 3:16
[   43.377256] .................................... done.
[   43.377434] registered taskstats version 1
[   44.980892] rtc_cmos 00:07: setting system clock to 2014-04-14 21:05:29 UTC (1397509529)
[   44.989508] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   44.995819] EDD information not available.
[   45.032955] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   45.039787]  sdk: sdk1 sdk2
[   45.069964] sd 6:0:8:0: [sdk] Attached SCSI disk
[   45.149182] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   45.155320] 8021q: adding VLAN 0 to HW filter on device eth1
[   45.273448] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
[   45.279551] 8021q: adding VLAN 0 to HW filter on device eth2
[   45.801595] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[   46.369168] hub 5-2:1.0: USB hub found
[   46.375097] hub 5-2:1.0: 4 ports detected
[   46.659302] usb 5-2.1: new low-speed USB device number 3 using uhci_hcd
[   46.880735] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.0/0003:0557:2261.0001/input/input6
[   46.895410] hid-generic 0003:0557:2261.0001: input: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input0
[   46.943646] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.1/0003:0557:2261.0002/input/input7
[   46.958307] hid-generic 0003:0557:2261.0002: input: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input1
[   46.995775] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2.1/5-2.1:1.2/0003:0557:2261.0003/input/input8
[   47.010662] hid-generic 0003:0557:2261.0003: input: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-2.1/input2
[   53.568337] igb: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   53.576162] igb 0000:01:00.0 eth1: Link Speed was downgraded by SmartSpeed
[   53.588563] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   53.603894] Sending DHCP requests ., OK
[   54.260433] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.67
[   54.453109] IP-Config: Complete:
[   54.456618]      device=eth1, hwaddr=00:30:48:cf:17:26, ipaddr=192.168.1.67, mask=255.255.255.0, gw=192.168.1.1
[   54.467192]      host=lkp-ws02, domain=lkp.intel.com, nis-domain=(none)
[   54.474069]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   54.480827]      nameserver0=192.168.1.1
[   54.485526] PM: Hibernation image not present or could not be loaded.
[   54.496162] Freeing unused kernel memory: 1412K (ffffffff8213d000 - ffffffff8229e000)
[   54.504474] Write protecting the kernel read-only data: 16384k
[   54.515499] Freeing unused kernel memory: 192K (ffff8800019d0000 - ffff880001a00000)
[   54.529623] Freeing unused kernel memory: 1960K (ffff880001e16000 - ffff880002000000)
[   54.740697] ipmi message handler version 39.2
[   54.747686] IPMI System Interface driver.
[   54.751990] ipmi_si: probing via SMBIOS
[   54.756072] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   54.762235] ipmi_si: Adding SMBIOS-specified kcs state machine
[   54.762238] ipmi_si: probing via SPMI
[   54.762240] ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
[   54.762241] ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
[   54.762244] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[   54.762251] ipmi_si: Interface detection failed
[   54.802345] microcode: CPU0 sig=0x206c1, pf=0x1, revision=0x3
[   54.808393] microcode: CPU1 sig=0x206c1, pf=0x1, revision=0x3
[   54.808451] microcode: CPU2 sig=0x206c1, pf=0x1, revision=0x3
[   54.808468] microcode: CPU3 sig=0x206c1, pf=0x1, revision=0x3
[   54.808509] microcode: CPU4 sig=0x206c1, pf=0x1, revision=0x3
[   54.808537] microcode: CPU5 sig=0x206c1, pf=0x1, revision=0x3
[   54.808552] microcode: CPU6 sig=0x206c1, pf=0x1, revision=0x3
[   54.808585] microcode: CPU7 sig=0x206c1, pf=0x1, revision=0x3
[   54.808599] microcode: CPU8 sig=0x206c1, pf=0x1, revision=0x3
[   54.808648] microcode: CPU9 sig=0x206c1, pf=0x1, revision=0x3
[   54.808667] microcode: CPU10 sig=0x206c1, pf=0x1, revision=0x3
[   54.808680] microcode: CPU11 sig=0x206c1, pf=0x1, revision=0x3
[   54.808694] microcode: CPU12 sig=0x206c1, pf=0x1, revision=0x3
[   54.808708] microcode: CPU13 sig=0x206c1, pf=0x1, revision=0x3
[   54.808724] microcode: CPU14 sig=0x206c1, pf=0x1, revision=0x3
[   54.808740] microcode: CPU15 sig=0x206c1, pf=0x1, revision=0x3
[   54.808787] microcode: CPU16 sig=0x206c1, pf=0x1, revision=0x3
[   54.808828] microcode: CPU17 sig=0x206c1, pf=0x1, revision=0x3
[   54.808883] microcode: CPU18 sig=0x206c1, pf=0x1, revision=0x3
[   54.808926] microcode: CPU19 sig=0x206c1, pf=0x1, revision=0x3
[   54.808968] microcode: CPU20 sig=0x206c1, pf=0x1, revision=0x3
[   54.809011] microcode: CPU21 sig=0x206c1, pf=0x1, revision=0x3
[   54.809023] microcode: CPU22 sig=0x206c1, pf=0x1, revision=0x3
[   54.809054] microcode: CPU23 sig=0x206c1, pf=0x1, revision=0x3
[   54.809162] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   54.968812] Btrfs loaded
[   54.974816] BTRFS: device fsid f3082e2d-7b16-4b16-8027-d9ef0ff805ff devid 1 transid 44 /dev/sdc1

==> /lkp/lkp/src/tmp/run_log <==
Kernel tests: Boot OK!
PATH=/sbin:/usr/sbin:/bin:/usr/bin

==> /lkp/lkp/src/tmp/err_log <==

==> /lkp/lkp/src/tmp/run_log <==
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=/lkp/lkp/src
RESULT_ROOT=/lkp/result/lkp-ws02/micro/dd-write/11HDD-RAID5-cfq-ext4-10dd/x86_64-lkp/2e7679975d5c1a12410cc3a7100085ad8d7420e1/0
job=/lkp/scheduled/lkp-ws02/cyclic_dd-write-11hdd-11HDD-RAID5-cfq-ext4-10dd-HEAD-2e7679975d5c1a12410cc3a7100085ad8d7420e1.yaml
run-job /lkp/scheduled/lkp-ws02/cyclic_dd-write-11hdd-11HDD-RAID5-cfq-ext4-10dd-HEAD-2e7679975d5c1a12410cc3a7100085ad8d7420e1.yaml
run: /lkp/lkp/src/setup/disk	{"nr_hdd"=>"11"}
run: /lkp/lkp/src/setup/md	{"raid_level"=>"raid5"}
run: /lkp/lkp/src/monitors/event/wait pre-test	{}
run: /lkp/lkp/src/monitors/wrapper perf-stat	{}
run: /lkp/lkp/src/monitors/wrapper perf-profile	{}
run: /lkp/lkp/src/monitors/wrapper ftrace	{"events"=>"balance_dirty_pages bdi_dirty_ratelimit global_dirty_state writeback_single_inode"}
2014-04-14 21:05:49 mdadm -q --create /dev/md0 --chunk=256 --level=raid5 --raid-devices=11 --force --assume-clean /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1
[   63.887908] md: bind<sdd1>
[   63.891257] md: bind<sde1>
[   63.894547] md: bind<sdf1>
[   63.897843] md: bind<sdg1>
[   63.901112] md: bind<sdh1>
[   63.904346] md: bind<sdi1>
[   63.907569] md: bind<sdj1>
[   63.910805] md: bind<sdk1>
[   63.914056] md: bind<sdl1>
[   63.917284] md: bind<sdm1>
[   63.926900] md: bind<sdn1>
[   63.931568] md/raid:md0: device sdn1 operational as raid disk 10
[   63.937862] md/raid:md0: device sdm1 operational as raid disk 9
[   63.944060] md/raid:md0: device sdl1 operational as raid disk 8
[   63.950252] md/raid:md0: device sdk1 operational as raid disk 7
[   63.956445] md/raid:md0: device sdj1 operational as raid disk 6
[   63.962638] md/raid:md0: device sdi1 operational as raid disk 5
[   63.968830] md/raid:md0: device sdh1 operational as raid disk 4
[   63.975027] md/raid:md0: device sdg1 operational as raid disk 3
[   63.981220] md/raid:md0: device sdf1 operational as raid disk 2
[   63.987420] md/raid:md0: device sde1 operational as raid disk 1
[   63.993614] md/raid:md0: device sdd1 operational as raid disk 0
[   64.000491] md/raid:md0: allocated 0kB
[   64.004636] md/raid:md0: raid level 5 active with 11 out of 11 devices, algorithm 2
[   64.012795] RAID conf printout:
[   64.016207]  --- level:5 rd:11 wd:11
[   64.020061]  disk 0, o:1, dev:sdd1
[   64.023737]  disk 1, o:1, dev:sde1
[   64.027413]  disk 2, o:1, dev:sdf1
[   64.031086]  disk 3, o:1, dev:sdg1
[   64.034761]  disk 4, o:1, dev:sdh1
[   64.038438]  disk 5, o:1, dev:sdi1
[   64.042116]  disk 6, o:1, dev:sdj1
[   64.045793]  disk 7, o:1, dev:sdk1
[   64.049470]  disk 8, o:1, dev:sdl1
[   64.053149]  disk 9, o:1, dev:sdm1
[   64.056824]  disk 10, o:1, dev:sdn1
[   64.060623] md0: detected capacity change from 0 to 1998633041920
[   64.068840]  md0: unknown partition table
run: /lkp/lkp/src/setup/iosched	{"scheduler"=>"cfq"}
run: /lkp/lkp/src/setup/fs	{"fs"=>"ext4"}
2014-04-14 21:05:50 mkfs -t ext4 -q /dev/md0
2014-04-14 21:05:54 mount -t ext4 /dev/md0 /fs/md0
[   68.093049] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime	{}
run: /lkp/lkp/src/monitors/wrapper iostat	{}
run: /lkp/lkp/src/monitors/wrapper vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-numastat	{}
run: /lkp/lkp/src/monitors/wrapper numa-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-meminfo	{}
run: /lkp/lkp/src/monitors/wrapper proc-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper meminfo	{}
run: /lkp/lkp/src/monitors/wrapper slabinfo	{}
run: /lkp/lkp/src/monitors/wrapper interrupts	{}
run: /lkp/lkp/src/monitors/wrapper lock_stat	{}
run: /lkp/lkp/src/monitors/wrapper latency_stats	{}
run: /lkp/lkp/src/monitors/wrapper softirqs	{}
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping	{}
run: /lkp/lkp/src/monitors/wrapper pmeter	{}
run: /lkp/lkp/src/monitors/wrapper diskstats	{}
run: /lkp/lkp/src/monitors/wrapper zoneinfo	{}
run: /lkp/lkp/src/monitors/wrapper energy	{}
run: /lkp/lkp/src/monitors/wrapper cpuidle	{}
run: /lkp/lkp/src/monitors/wrapper turbostat	{}
run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/micro/wrapper dd	{"nr_dd"=>"10"}
[  164.135721] perf interrupt took too long (2522 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  264.255560] ------------[ cut here ]------------
[  264.260444] kernel BUG at drivers/md/raid5.c:4374!
[  264.267590] invalid opcode: 0000 [#1] SMP 
[  264.272076] Modules linked in: btrfs microcode ipmi_si ipmi_msghandler acpi_cpufreq processor
[  264.281514] CPU: 0 PID: 4005 Comm: md0_raid5 Not tainted 3.15.0-rc1-00611-g2e76799 #1
[  264.289823] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[  264.296789] task: ffff8804151e41a0 ti: ffff88041672c000 task.ti: ffff88041672c000
[  264.304750] RIP: 0010:[<ffffffff81804ef1>]  [<ffffffff81804ef1>] handle_active_stripes.isra.24+0x254/0x360
[  264.314951] RSP: 0018:ffff88041672dd10  EFLAGS: 00010002
[  264.320527] RAX: ffff88021dc46000 RBX: ffff880220a4e000 RCX: ffff880220a4e080
[  264.327926] RDX: 0000000000000001 RSI: ffff88021e0d7010 RDI: ffff880220a4e000
[  264.335325] RBP: ffff88041672dda8 R08: 0000000000000000 R09: 0000000000000000
[  264.342724] R10: 0000000000000000 R11: 000000000000ef58 R12: 0000000000000000
[  264.350131] R13: ffff880220a4e080 R14: 0000000000000000 R15: ffff880220a4e268
[  264.357530] FS:  0000000000000000(0000) GS:ffff880237c00000(0000) knlGS:0000000000000000
[  264.366099] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  264.372111] CR2: 0000000001e21d64 CR3: 000000000200f000 CR4: 00000000000007f0
[  264.379509] Stack:
[  264.381780]  ffff8804173d7de0 ffff880220a4e000 ffff88041672dd38 ffffffffffffffd8
[  264.389907]  ffffffff1e1bd000 ffff880220a4e090 ffffffff817fdba2 ffff880220a4e000
[  264.398043]  0000000000000021 ffff880220a4e268 0000000000000000 ffff88041672dd78
[  264.406172] Call Trace:
[  264.408893]  [<ffffffff817fdba2>] ? do_release_stripe+0xdf/0x158
[  264.415168]  [<ffffffff817fdc30>] ? __release_stripe+0x15/0x17
[  264.421266]  [<ffffffff818054f2>] raid5d+0x3e2/0x4f2
[  264.426497]  [<ffffffff819bcacf>] ? schedule_timeout+0x2f/0x19f
[  264.432681]  [<ffffffff81826151>] md_thread+0x123/0x139
[  264.438171]  [<ffffffff811148b6>] ? __wake_up_sync+0x12/0x12
[  264.444096]  [<ffffffff8182602e>] ? md_register_thread+0xd5/0xd5
[  264.450368]  [<ffffffff810fa267>] kthread+0xdb/0xe3
[  264.455511]  [<ffffffff810fa18c>] ? kthread_create_on_node+0x16f/0x16f
[  264.462310]  [<ffffffff819c7d7c>] ret_from_fork+0x7c/0xb0
[  264.467973]  [<ffffffff810fa18c>] ? kthread_create_on_node+0x16f/0x16f
[  264.474764] Code: 60 00 00 00 00 48 8b 70 10 48 8b 48 18 48 8d 50 10 48 89 4e 08 48 89 31 48 89 50 10 48 89 50 18 f0 ff 40 50 8b 50 50 ff ca 74 02 <0f> 0b 4a 89 44 d5 98 49 ff c2 49 83 fa 08 0f 85 d7 fd ff ff 41 
[  264.498252] RIP  [<ffffffff81804ef1>] handle_active_stripes.isra.24+0x254/0x360
[  264.506112]  RSP <ffff88041672dd10>
[  264.509869] ---[ end trace 58f3875ff7b4e923 ]---
[  264.514750] Kernel panic - not syncing: Fatal exception
[  265.556713] Shutting down cpus with NMI
[  265.560918] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
Rebooting in 10 seconds..

--lMM8JwqTlfDpEaS6--
