Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaHKNWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:22:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:26622 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbaHKNWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:22:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="574973202"
Date: Mon, 11 Aug 2014 21:22:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "lkp@01.org" <lkp@01.org>
Subject: [percpu] BUG: unable to handle kernel paging request at
 000000000000de40
Message-ID: <20140811132213.GA7713@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Christoph,

This kernel oops happens on a Nehalem-EX machine and is related to
some commit in the percpu branch(*). I'm not able to bisect it down
because the machine failed to reboot itself on this oops..

(*) head commit is

commit 8d20cc9cfe7f5c466dac63509c8f80db41e31015
Commit:     Christoph Lameter <cl@gentwo.org>
CommitDate: Fri Aug 8 11:11:03 2014 -0500

    One & too much

[    1.473733] x86: Booting SMP configuration:
[    1.478547] .... node  #1, CPUs:        #1
[    1.495060] masked ExtINT on CPU#1
[    1.578419] BUG: unable to handle kernel paging request at 000000000000de40
[    1.586556] IP: [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.594057] PGD 0
[    1.596508] Oops: 0000 [#1] SMP
[    1.600381] Modules linked in:
[    1.603998] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-00251-g7d674bb #1
[    1.612284] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0023.020920102021 02/09/2010
[    1.622901] task: ffff882027ba8000 ti: ffff8810273fc000 task.ti: ffff8810273fc000
[    1.631478] RIP: 0010:[<ffffffff8104c8c9>]  [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.641767] RSP: 0000:ffff8810273ffc48  EFLAGS: 00010096
[    1.647840] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81d6c4e0
[    1.655954] RDX: 0000000000080000 RSI: 00000000000000fd RDI: ffffffff81848260
[    1.664069] RBP: ffff8810273ffc98 R08: 0000000000000008 R09: 0000000000000000
[    1.672183] R10: ffffffff81848260 R11: ffff8810273ffb5e R12: ffff882027bad880
[    1.680297] R13: ffff88203fc14840 R14: 0000000000000001 R15: 0000000000080000
[    1.688412] FS:  0000000000000000(0000) GS:ffff88103fa00000(0000) knlGS:0000000000000000
[    1.697674] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.704232] CR2: 000000000000de40 CR3: 0000000001bfd000 CR4: 00000000000007f0
[    1.712347] Stack:
[    1.714725]  0000000000000096 000000fd810ace79 000000ea27ba8068 00000000000000df
[    1.723484]  ffff882027bad8e8 0000000000000001 ffff882027bad880 ffff88203fc14840
[    1.732231]  0000000000000001 ffff88203fc14840 ffff8810273ffca8 ffffffff8104ca93
[    1.740992] Call Trace:
[    1.743861]  [<ffffffff8104ca93>] x2apic_send_IPI_mask+0x13/0x20
[    1.750714]  [<ffffffff8104346a>] native_smp_send_reschedule+0x4a/0x60
[    1.758149]  [<ffffffff8109da08>] resched_task+0xa8/0xd0
[    1.764222]  [<ffffffff8109e685>] check_preempt_curr+0x75/0xa0
[    1.770883]  [<ffffffff8109e6c9>] ttwu_do_wakeup+0x19/0xe0
[    1.777155]  [<ffffffff8109e83d>] ttwu_do_activate.constprop.85+0x5d/0x70
[    1.784876]  [<ffffffff810a14b4>] try_to_wake_up+0x1d4/0x350
[    1.791344]  [<ffffffff810a1680>] wake_up_state+0x10/0x20
[    1.797514]  [<ffffffff810909bd>] __kthread_unpark+0x5d/0x60
[    1.803975]  [<ffffffff81090f4e>] kthread_unpark+0x1e/0x30
[    1.810245]  [<ffffffff81097e2c>] smpboot_unpark_thread.isra.1+0x2c/0x30
[    1.817874]  [<ffffffff8109824f>] smpboot_unpark_threads+0x3f/0x60
[    1.824922]  [<ffffffff8106d45d>] _cpu_up+0x15d/0x180
[    1.830697]  [<ffffffff8106d509>] cpu_up+0x89/0xb0
[    1.836187]  [<ffffffff81db5b71>] smp_init+0x85/0x87
[    1.841871]  [<ffffffff81d9217f>] kernel_init_freeable+0x119/0x22b
[    1.848919]  [<ffffffff81817af0>] ? rest_init+0x90/0x90
[    1.854895]  [<ffffffff81817afe>] kernel_init+0xe/0xf0
[    1.860774]  [<ffffffff818322fc>] ret_from_fork+0x7c/0xb0
[    1.866946]  [<ffffffff81817af0>] ? rest_init+0x90/0x90
[    1.872923] Code: 41 56 41 55 41 54 53 48 83 ec 28 89 75 bc 0f ae f0 9c 58 66 66 90 66 90 48 89 45 b0 fa 66 66 90 66 66 90 65 8b 04 25 2
c b0 00 00 <4c> 8b 25 70 15 fc 7e 89 45 c8 65 4c 03 24 25 a8 dc 00 00 48 63
[    1.898786] RIP  [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.906386]  RSP <ffff8810273ffc48>
[    1.910419] CR2: 000000000000de40
[    1.914261] ---[ end trace 840db19b2eaea46d ]---
[    1.919556] Kernel panic - not syncing: Fatal exception

Thanks,
Fengguang

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-00251-g7d674bb (kbuild@xian) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun Aug 10 23:38:38 CST 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb user=lkp job=/lkp/scheduled/lkp-nex05/vip_boot-1-x86_64-rhel-7d674bb90a0f94adad0b907761c3855aae7c21c2-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb kconfig=x86_64-rhel commit=7d674bb90a0f94adad0b907761c3855aae7c21c2 root=/dev/ram0 RESULT_ROOT=/result/lkp-nex05/boot/1/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/0 ip=::::lkp-nex05:eth1:dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw kexec_jump_back_entry=0xffffffff
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000078c73fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078c74000-0x0000000078e88fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000078e89000-0x0000000079247fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079248000-0x00000000792bbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792bc000-0x00000000792c7fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792c8000-0x00000000792dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792dd000-0x00000000792eafff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792eb000-0x00000000792ebfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792ec000-0x00000000792f8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792f9000-0x0000000079305fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079306000-0x0000000079308fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079309000-0x000000007930efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007930f000-0x000000007932ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079330000-0x0000000079350fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079351000-0x000000007937ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079380000-0x00000000793c0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000793c1000-0x0000000079979fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007997a000-0x0000000079b79fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b7a000-0x0000000079cbdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079cbe000-0x0000000079cedfff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079cee000-0x0000000079d81fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079d82000-0x0000000079d84fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079d85000-0x0000000079e14fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079e15000-0x0000000079e7ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079e80000-0x000000007bd5efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007be4efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf86fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bf87000-0x000000007bfcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000307fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0023.020920102021 02/09/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x3080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00080000000 mask FFF80000000 uncachable
[    0.000000]   1 base FC000000000 mask FFF00000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x78c74 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdd80-0x000fdd8f] mapped at [ffff8800000fdd80]
[    0.000000]   mpc: 12-f012
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02118000, 0x02118fff] PGTABLE
[    0.000000] BRK [0x02119000, 0x02119fff] PGTABLE
[    0.000000] BRK [0x0211a000, 0x0211afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x307fe00000-0x307fffffff]
[    0.000000]  [mem 0x307fe00000-0x307fffffff] page 2M
[    0.000000] BRK [0x0211b000, 0x0211bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x307c000000-0x307fdfffff]
[    0.000000]  [mem 0x307c000000-0x307fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3000000000-0x307bffffff]
[    0.000000]  [mem 0x3000000000-0x307bffffff] page 2M
[    0.000000] BRK [0x0211c000, 0x0211cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x2fffffffff]
[    0.000000]  [mem 0x2000000000-0x2fffffffff] page 2M
[    0.000000] BRK [0x0211d000, 0x0211dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x78c73fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x78bfffff] page 2M
[    0.000000]  [mem 0x78c00000-0x78c73fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1fffffffff]
[    0.000000]  [mem 0x100000000-0x1fffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x71691000-0x78c69fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 0x000000007BFFE120 0000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007BFFD000 0000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 0x000000007BFE3000 019F6A (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 0x000000007BF87000 000040
[    0.000000] ACPI: APIC 0x000000007BFE2000 0003E4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MSCT 0x000000007BFE1000 000090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: MCFG 0x000000007BFE0000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 0x000000007BFDF000 000038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 0x000000007BFDE000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 0x000000007BFDD000 000930 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 0x000000007BFDC000 000050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 0x000000007BFDB000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 0x000000007BF4A000 03CFA4 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x000000007BFDA000 000174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: PMCT 0x000000007BFD9000 000060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MIGT 0x000000007BFD8000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: TCPA 0x000000007BFD5000 000032 (v00 QUANTA QSSC-S4R 00000000      00000000)
[    0.000000] ACPI: HEST 0x000000007BFD4000 0000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000007BFD3000 000030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000007BFD2000 000230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000007BFD1000 000130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 0x000000007BFD0000 000350 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x107fffffff]
[    0.000000] SRAT: Node 1 PXM 2 [mem 0x1080000000-0x207fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x2080000000-0x307fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x3100000000-0x50ffffffff] hotplug
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x5100000000-0x70ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 1 [mem 0x7100000000-0x90ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 1 [mem 0x9100000000-0xb0ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 2 [mem 0xb100000000-0xd0ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 2 [mem 0xd100000000-0xf0ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xf100000000-0x110ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x11100000000-0x130ffffffff] hotplug
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x107fffffff] -> [mem 0x00000000-0x107fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107ffd9000-0x107fffffff]
[    0.000000] Initmem setup node 1 [mem 0x1080000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207ffd9000-0x207fffffff]
[    0.000000] Initmem setup node 3 [mem 0x2080000000-0x307fffffff]
[    0.000000]   NODE_DATA [mem 0x307ff1b000-0x307ff41fff]
[    0.000000]  [ffffea0000000000-ffffea0041ffffff] PMD -> [ffff88103fe00000-ffff88107fdfffff] on node 0
[    0.000000]  [ffffea0042000000-ffffea0081ffffff] PMD -> [ffff88203fe00000-ffff88207fdfffff] on node 1
[    0.000000]  [ffffea0082000000-ffffea00c1ffffff] PMD -> [ffff88303f600000-ffff88307f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x307fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x78c73fff]
[    0.000000]   node   0: [mem 0x100000000-0x107fffffff]
[    0.000000]   node   1: [mem 0x1080000000-0x207fffffff]
[    0.000000]   node   3: [mem 0x2080000000-0x307fffffff]
[    0.000000] On node 0 totalpages: 16747534
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7666 pages used for memmap
[    0.000000]   DMA32 zone: 490612 pages, LIFO batch:31
[    0.000000]   Normal zone: 253952 pages used for memmap
[    0.000000]   Normal zone: 16252928 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 16777216
[    0.000000]   Normal zone: 262144 pages used for memmap
[    0.000000]   Normal zone: 16777216 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 16777216
[    0.000000]   Normal zone: 262144 pages used for memmap
[    0.000000]   Normal zone: 16777216 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
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
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
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
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] smpboot: Allowing 64 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec04000)
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x78c74000-0x78e88fff]
[    0.000000] PM: Registered nosave memory: [mem 0x78e89000-0x79247fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79248000-0x792bbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792bc000-0x792c7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792c8000-0x792dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792dd000-0x792eafff]
[    0.000000] PM: Registered nosave memory: [mem 0x792eb000-0x792ebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792ec000-0x792f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f9000-0x79305fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79306000-0x79308fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79309000-0x7930efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7930f000-0x7932ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x79330000-0x79350fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79351000-0x7937ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x79380000-0x793c0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x793c1000-0x79979fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7997a000-0x79b79fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79b7a000-0x79cbdfff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cbe000-0x79cedfff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cee000-0x79d81fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d82000-0x79d84fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d85000-0x79e14fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e15000-0x79e7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e80000-0x7bd5efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bd5f000-0x7be4efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7be4f000-0x7bf86fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bf87000-0x7bfcefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bfcf000-0x7bffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bfff000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfd000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:64 nr_cpu_ids:64 nr_node_ids:4
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88103fa00000 s87488 r8192 d23104 u131072
[    0.000000] pcpu-alloc: s87488 r8192 d23104 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 
[    0.000000] pcpu-alloc: [0] 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 
[    0.000000] pcpu-alloc: [1] 01 05 09 13 17 21 25 29 33 37 41 45 49 53 57 61 
[    0.000000] pcpu-alloc: [2] 03 07 11 15 19 23 27 31 35 39 43 47 51 55 59 63 
[    0.000000] Built 3 zonelists in Zone order, mobility grouping on.  Total pages: 49515975
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb user=lkp job=/lkp/scheduled/lkp-nex05/vip_boot-1-x86_64-rhel-7d674bb90a0f94adad0b907761c3855aae7c21c2-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb kconfig=x86_64-rhel commit=7d674bb90a0f94adad0b907761c3855aae7c21c2 root=/dev/ram0 RESULT_ROOT=/result/lkp-nex05/boot/1/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/0 ip=::::lkp-nex05:eth1:dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw kexec_jump_back_entry=0xffffffff
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 197848592K/201207864K available (8412K kernel code, 1596K rwdata, 3776K rodata, 1788K init, 1872K bss, 3359272K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=64.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-63.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=64
[    0.000000] NR_IRQS:524544 nr_irqs:2008 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-00251-g7d674bb (kbuild@xian) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Sun Aug 10 23:38:38 CST 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb user=lkp job=/lkp/scheduled/lkp-nex05/vip_boot-1-x86_64-rhel-7d674bb90a0f94adad0b907761c3855aae7c21c2-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb kconfig=x86_64-rhel commit=7d674bb90a0f94adad0b907761c3855aae7c21c2 root=/dev/ram0 RESULT_ROOT=/result/lkp-nex05/boot/1/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/0 ip=::::lkp-nex05:eth1:dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw kexec_jump_back_entry=0xffffffff
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000078c73fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078c74000-0x0000000078e88fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000078e89000-0x0000000079247fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079248000-0x00000000792bbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792bc000-0x00000000792c7fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792c8000-0x00000000792dcfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792dd000-0x00000000792eafff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792eb000-0x00000000792ebfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792ec000-0x00000000792f8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792f9000-0x0000000079305fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079306000-0x0000000079308fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079309000-0x000000007930efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007930f000-0x000000007932ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079330000-0x0000000079350fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079351000-0x000000007937ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079380000-0x00000000793c0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000793c1000-0x0000000079979fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007997a000-0x0000000079b79fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b7a000-0x0000000079cbdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079cbe000-0x0000000079cedfff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079cee000-0x0000000079d81fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079d82000-0x0000000079d84fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079d85000-0x0000000079e14fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079e15000-0x0000000079e7ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079e80000-0x000000007bd5efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007be4efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf86fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bf87000-0x000000007bfcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000307fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0023.020920102021 02/09/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x3080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00080000000 mask FFF80000000 uncachable
[    0.000000]   1 base FC000000000 mask FFF00000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x78c74 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdd80-0x000fdd8f] mapped at [ffff8800000fdd80]
[    0.000000]   mpc: 12-f012
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02118000, 0x02118fff] PGTABLE
[    0.000000] BRK [0x02119000, 0x02119fff] PGTABLE
[    0.000000] BRK [0x0211a000, 0x0211afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x307fe00000-0x307fffffff]
[    0.000000]  [mem 0x307fe00000-0x307fffffff] page 2M
[    0.000000] BRK [0x0211b000, 0x0211bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x307c000000-0x307fdfffff]
[    0.000000]  [mem 0x307c000000-0x307fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3000000000-0x307bffffff]
[    0.000000]  [mem 0x3000000000-0x307bffffff] page 2M
[    0.000000] BRK [0x0211c000, 0x0211cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x2fffffffff]
[    0.000000]  [mem 0x2000000000-0x2fffffffff] page 2M
[    0.000000] BRK [0x0211d000, 0x0211dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x78c73fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x78bfffff] page 2M
[    0.000000]  [mem 0x78c00000-0x78c73fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1fffffffff]
[    0.000000]  [mem 0x100000000-0x1fffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x71691000-0x78c69fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 0x000000007BFFE120 0000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007BFFD000 0000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 0x000000007BFE3000 019F6A (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 0x000000007BF87000 000040
[    0.000000] ACPI: APIC 0x000000007BFE2000 0003E4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MSCT 0x000000007BFE1000 000090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: MCFG 0x000000007BFE0000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 0x000000007BFDF000 000038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 0x000000007BFDE000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 0x000000007BFDD000 000930 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 0x000000007BFDC000 000050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 0x000000007BFDB000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 0x000000007BF4A000 03CFA4 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x000000007BFDA000 000174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: PMCT 0x000000007BFD9000 000060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MIGT 0x000000007BFD8000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: TCPA 0x000000007BFD5000 000032 (v00 QUANTA QSSC-S4R 00000000      00000000)
[    0.000000] ACPI: HEST 0x000000007BFD4000 0000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000007BFD3000 000030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000007BFD2000 000230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000007BFD1000 000130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 0x000000007BFD0000 000350 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x107fffffff]
[    0.000000] SRAT: Node 1 PXM 2 [mem 0x1080000000-0x207fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x2080000000-0x307fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x3100000000-0x50ffffffff] hotplug
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x5100000000-0x70ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 1 [mem 0x7100000000-0x90ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 1 [mem 0x9100000000-0xb0ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 2 [mem 0xb100000000-0xd0ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 2 [mem 0xd100000000-0xf0ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xf100000000-0x110ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x11100000000-0x130ffffffff] hotplug
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x107fffffff] -> [mem 0x00000000-0x107fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107ffd9000-0x107fffffff]
[    0.000000] Initmem setup node 1 [mem 0x1080000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207ffd9000-0x207fffffff]
[    0.000000] Initmem setup node 3 [mem 0x2080000000-0x307fffffff]
[    0.000000]   NODE_DATA [mem 0x307ff1b000-0x307ff41fff]
[    0.000000]  [ffffea0000000000-ffffea0041ffffff] PMD -> [ffff88103fe00000-ffff88107fdfffff] on node 0
[    0.000000]  [ffffea0042000000-ffffea0081ffffff] PMD -> [ffff88203fe00000-ffff88207fdfffff] on node 1
[    0.000000]  [ffffea0082000000-ffffea00c1ffffff] PMD -> [ffff88303f600000-ffff88307f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x307fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x78c73fff]
[    0.000000]   node   0: [mem 0x100000000-0x107fffffff]
[    0.000000]   node   1: [mem 0x1080000000-0x207fffffff]
[    0.000000]   node   3: [mem 0x2080000000-0x307fffffff]
[    0.000000] On node 0 totalpages: 16747534
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7666 pages used for memmap
[    0.000000]   DMA32 zone: 490612 pages, LIFO batch:31
[    0.000000]   Normal zone: 253952 pages used for memmap
[    0.000000]   Normal zone: 16252928 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 16777216
[    0.000000]   Normal zone: 262144 pages used for memmap
[    0.000000]   Normal zone: 16777216 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 16777216
[    0.000000]   Normal zone: 262144 pages used for memmap
[    0.000000]   Normal zone: 16777216 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
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
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
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
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] smpboot: Allowing 64 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec04000)
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: [mem 0x0009b000-0x0009bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x78c74000-0x78e88fff]
[    0.000000] PM: Registered nosave memory: [mem 0x78e89000-0x79247fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79248000-0x792bbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792bc000-0x792c7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792c8000-0x792dcfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792dd000-0x792eafff]
[    0.000000] PM: Registered nosave memory: [mem 0x792eb000-0x792ebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792ec000-0x792f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f9000-0x79305fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79306000-0x79308fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79309000-0x7930efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7930f000-0x7932ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x79330000-0x79350fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79351000-0x7937ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x79380000-0x793c0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x793c1000-0x79979fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7997a000-0x79b79fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79b7a000-0x79cbdfff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cbe000-0x79cedfff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cee000-0x79d81fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d82000-0x79d84fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d85000-0x79e14fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e15000-0x79e7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e80000-0x7bd5efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bd5f000-0x7be4efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7be4f000-0x7bf86fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bf87000-0x7bfcefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bfcf000-0x7bffefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7bfff000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfd000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:64 nr_cpu_ids:64 nr_node_ids:4
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88103fa00000 s87488 r8192 d23104 u131072
[    0.000000] pcpu-alloc: s87488 r8192 d23104 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 02 04 06 08 10 12 14 16 18 20 22 24 26 28 30 
[    0.000000] pcpu-alloc: [0] 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 
[    0.000000] pcpu-alloc: [1] 01 05 09 13 17 21 25 29 33 37 41 45 49 53 57 61 
[    0.000000] pcpu-alloc: [2] 03 07 11 15 19 23 27 31 35 39 43 47 51 55 59 63 
[    0.000000] Built 3 zonelists in Zone order, mobility grouping on.  Total pages: 49515975
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb user=lkp job=/lkp/scheduled/lkp-nex05/vip_boot-1-x86_64-rhel-7d674bb90a0f94adad0b907761c3855aae7c21c2-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/vmlinuz-3.16.0-00251-g7d674bb kconfig=x86_64-rhel commit=7d674bb90a0f94adad0b907761c3855aae7c21c2 root=/dev/ram0 RESULT_ROOT=/result/lkp-nex05/boot/1/x86_64-rhel/7d674bb90a0f94adad0b907761c3855aae7c21c2/0 ip=::::lkp-nex05:eth1:dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw kexec_jump_back_entry=0xffffffff
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 197848592K/201207864K available (8412K kernel code, 1596K rwdata, 3776K rodata, 1788K init, 1872K bss, 3359272K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=64.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-63.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=64
[    0.000000] NR_IRQS:524544 nr_irqs:2008 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 805306368 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1995.045 MHz processor
[    0.000066] Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.09 BogoMIPS (lpj=1995045)
[    0.012063] pid_max: default: 65536 minimum: 512
[    0.017306] ACPI: Core revision 20140724
[    0.092461] ACPI: All ACPI Tables successfully acquired
[    0.098634] Security Framework initialized
[    0.103283] SELinux:  Initializing.
[    0.107251] SELinux:  Starting in permissive mode
[    0.137650] Dentry cache hash table entries: 33554432 (order: 16, 268435456 bytes)
[    0.236876] Inode-cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.283650] Mount-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.292185] Mountpoint-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.303671] Initializing cgroup subsys memory
[    0.308733] Initializing cgroup subsys devices
[    0.313841] Initializing cgroup subsys freezer
[    0.318946] Initializing cgroup subsys net_cls
[    0.324053] Initializing cgroup subsys blkio
[    0.328963] Initializing cgroup subsys perf_event
[    0.334360] Initializing cgroup subsys hugetlb
[    0.339544] CPU: Physical Processor ID: 0
[    0.344164] CPU: Processor Core ID: 0
[    0.348402] mce: CPU supports 22 MCE banks
[    0.353136] CPU0: Thermal monitoring enabled (TM1)
[    0.358646] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.358646] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.358646] tlb_flushall_shift: 6
[    0.375882] Freeing SMP alternatives memory: 32K (ffffffff81f3a000 - ffffffff81f42000)
[    0.386468] ftrace: allocating 30735 entries in 121 pages
[    0.412792] Getting VERSION: 60015
[    0.416720] Getting VERSION: 60015
[    0.420657] Getting ID: 0
[    0.423720] Getting ID: 0
[    0.426793] dmar: Host address width 48
[    0.431215] dmar: DRHD base: 0x000000fd800000 flags: 0x0
[    0.437289] dmar: IOMMU 0: reg_base_addr fd800000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.446544] dmar: DRHD base: 0x000000fd000000 flags: 0x1
[    0.452624] dmar: IOMMU 1: reg_base_addr fd000000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.461879] dmar: RMRR base: 0x0000007be28000 end: 0x0000007be2afff
[    0.469021] dmar: RMRR base: 0x0000007be15000 end: 0x0000007be15fff
[    0.476165] dmar: RMRR base: 0x0000007be12000 end: 0x0000007be12fff
[    0.483308] dmar: RMRR base: 0x0000007be0f000 end: 0x0000007be0ffff
[    0.490451] dmar: RMRR base: 0x0000007be0c000 end: 0x0000007be0cfff
[    0.497597] dmar: RMRR base: 0x0000007be09000 end: 0x0000007be09fff
[    0.504741] dmar: RMRR base: 0x0000007be06000 end: 0x0000007be06fff
[    0.511882] dmar: RMRR base: 0x0000007be03000 end: 0x0000007be03fff
[    0.519022] dmar: RMRR base: 0x0000007be00000 end: 0x0000007be00fff
[    0.526169] dmar: ATSR flags: 0x0
[    0.530004] dmar: ATSR flags: 0x0
[    0.533842] dmar: RHSA base: 0x000000fd000000 proximity domain: 0x0
[    0.540983] dmar: RHSA base: 0x000000fd800000 proximity domain: 0x2
[    0.548277] IOAPIC id 10 under DRHD base  0xfd800000 IOMMU 0
[    0.554741] IOAPIC id 8 under DRHD base  0xfd000000 IOMMU 1
[    0.561105] IOAPIC id 9 under DRHD base  0xfd000000 IOMMU 1
[    0.567470] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.577227] Enabled IRQ remapping in x2apic mode
[    0.582523] Enabling x2apic
[    0.585778] Enabled x2apic
[    0.588939] Switched APIC routing to cluster x2apic.
[    0.594632] masked ExtINT on CPU#0
[    0.599155] ENABLING IO-APIC IRQs
[    0.602996] init IO_APIC IRQs
[    0.606445]  apic 8 pin 0 not connected
[    0.610868] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.619938] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.635226] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.644294] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.659582] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.668665] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.683954] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.693024] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.708312] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.717380] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.732671] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.741740] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.757027] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.766100] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.781393] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.790468] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.805755] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.814823] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.830113] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.839376] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.854664] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.863928] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.879205] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.888477] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.903768] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.913030] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.928319] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.937582] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.952859] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.962121] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.977407]  apic 8 pin 16 not connected
[    0.981926]  apic 8 pin 17 not connected
[    0.986444]  apic 8 pin 18 not connected
[    0.990965]  apic 8 pin 19 not connected
[    0.995483]  apic 8 pin 20 not connected
[    1.000001]  apic 8 pin 21 not connected
[    1.004520]  apic 8 pin 22 not connected
[    1.009038]  apic 8 pin 23 not connected
[    1.013558]  apic 9 pin 0 not connected
[    1.017980]  apic 9 pin 1 not connected
[    1.022401]  apic 9 pin 2 not connected
[    1.026822]  apic 9 pin 3 not connected
[    1.031243]  apic 9 pin 4 not connected
[    1.035665]  apic 9 pin 5 not connected
[    1.040086]  apic 9 pin 6 not connected
[    1.044509]  apic 9 pin 7 not connected
[    1.048931]  apic 9 pin 8 not connected
[    1.053351]  apic 9 pin 9 not connected
[    1.057772]  apic 9 pin 10 not connected
[    1.062293]  apic 9 pin 11 not connected
[    1.066811]  apic 9 pin 12 not connected
[    1.071330]  apic 9 pin 13 not connected
[    1.075850]  apic 9 pin 14 not connected
[    1.080370]  apic 9 pin 15 not connected
[    1.084889]  apic 9 pin 16 not connected
[    1.089406]  apic 9 pin 17 not connected
[    1.093928]  apic 9 pin 18 not connected
[    1.098448]  apic 9 pin 19 not connected
[    1.102967]  apic 9 pin 20 not connected
[    1.107488]  apic 9 pin 21 not connected
[    1.112007]  apic 9 pin 22 not connected
[    1.116526]  apic 9 pin 23 not connected
[    1.121045]  apic 10 pin 0 not connected
[    1.125564]  apic 10 pin 1 not connected
[    1.130083]  apic 10 pin 2 not connected
[    1.134601]  apic 10 pin 3 not connected
[    1.139118]  apic 10 pin 4 not connected
[    1.143644]  apic 10 pin 5 not connected
[    1.148163]  apic 10 pin 6 not connected
[    1.152681]  apic 10 pin 7 not connected
[    1.157199]  apic 10 pin 8 not connected
[    1.161718]  apic 10 pin 9 not connected
[    1.166236]  apic 10 pin 10 not connected
[    1.170853]  apic 10 pin 11 not connected
[    1.175470]  apic 10 pin 12 not connected
[    1.180088]  apic 10 pin 13 not connected
[    1.184706]  apic 10 pin 14 not connected
[    1.189323]  apic 10 pin 15 not connected
[    1.193938]  apic 10 pin 16 not connected
[    1.198554]  apic 10 pin 17 not connected
[    1.203170]  apic 10 pin 18 not connected
[    1.207787]  apic 10 pin 19 not connected
[    1.212404]  apic 10 pin 20 not connected
[    1.217022]  apic 10 pin 21 not connected
[    1.221640]  apic 10 pin 22 not connected
[    1.226258]  apic 10 pin 23 not connected
[    1.231012] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.247860] smpboot: CPU0: Intel(R) Xeon(R) CPU           X7550  @ 2.00GHz (fam: 06, model: 2e, stepping: 06)
[    1.259376] Using local APIC timer interrupts.
[    1.259376] calibrating APIC timer ...
[    1.371255] ... lapic delta = 831240
[    1.375383] ... PM-Timer delta = 357950
[    1.379802] ... PM-Timer result ok
[    1.383737] ..... delta 831240
[    1.387274] ..... mult: 35701486
[    1.391015] ..... calibration result: 132998
[    1.395922] ..... CPU clock speed is 1994.0974 MHz.
[    1.401509] ..... host bus clock speed is 132.0998 MHz.
[    1.407537] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    1.417285] perf_event_intel: CPU erratum AAJ80 worked around
[    1.423837] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    1.431661] ... version:                3
[    1.436278] ... bit width:              48
[    1.440993] ... generic registers:      4
[    1.445610] ... value mask:             0000ffffffffffff
[    1.451683] ... max period:             000000007fffffff
[    1.457757] ... fixed-purpose events:   3
[    1.462371] ... event mask:             000000070000000f
[    1.473733] x86: Booting SMP configuration:
[    1.478547] .... node  #1, CPUs:        #1
[    1.495060] masked ExtINT on CPU#1
[    1.578419] BUG: unable to handle kernel paging request at 000000000000de40
[    1.586556] IP: [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.594057] PGD 0 
[    1.596508] Oops: 0000 [#1] SMP 
[    1.600381] Modules linked in:
[    1.603998] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-00251-g7d674bb #1
[    1.612284] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0023.020920102021 02/09/2010
[    1.622901] task: ffff882027ba8000 ti: ffff8810273fc000 task.ti: ffff8810273fc000
[    1.631478] RIP: 0010:[<ffffffff8104c8c9>]  [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.641767] RSP: 0000:ffff8810273ffc48  EFLAGS: 00010096
[    1.647840] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff81d6c4e0
[    1.655954] RDX: 0000000000080000 RSI: 00000000000000fd RDI: ffffffff81848260
[    1.664069] RBP: ffff8810273ffc98 R08: 0000000000000008 R09: 0000000000000000
[    1.672183] R10: ffffffff81848260 R11: ffff8810273ffb5e R12: ffff882027bad880
[    1.680297] R13: ffff88203fc14840 R14: 0000000000000001 R15: 0000000000080000
[    1.688412] FS:  0000000000000000(0000) GS:ffff88103fa00000(0000) knlGS:0000000000000000
[    1.697674] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    1.704232] CR2: 000000000000de40 CR3: 0000000001bfd000 CR4: 00000000000007f0
[    1.712347] Stack:
[    1.714725]  0000000000000096 000000fd810ace79 000000ea27ba8068 00000000000000df
[    1.723484]  ffff882027bad8e8 0000000000000001 ffff882027bad880 ffff88203fc14840
[    1.732231]  0000000000000001 ffff88203fc14840 ffff8810273ffca8 ffffffff8104ca93
[    1.740992] Call Trace:
[    1.743861]  [<ffffffff8104ca93>] x2apic_send_IPI_mask+0x13/0x20
[    1.750714]  [<ffffffff8104346a>] native_smp_send_reschedule+0x4a/0x60
[    1.758149]  [<ffffffff8109da08>] resched_task+0xa8/0xd0
[    1.764222]  [<ffffffff8109e685>] check_preempt_curr+0x75/0xa0
[    1.770883]  [<ffffffff8109e6c9>] ttwu_do_wakeup+0x19/0xe0
[    1.777155]  [<ffffffff8109e83d>] ttwu_do_activate.constprop.85+0x5d/0x70
[    1.784876]  [<ffffffff810a14b4>] try_to_wake_up+0x1d4/0x350
[    1.791344]  [<ffffffff810a1680>] wake_up_state+0x10/0x20
[    1.797514]  [<ffffffff810909bd>] __kthread_unpark+0x5d/0x60
[    1.803975]  [<ffffffff81090f4e>] kthread_unpark+0x1e/0x30
[    1.810245]  [<ffffffff81097e2c>] smpboot_unpark_thread.isra.1+0x2c/0x30
[    1.817874]  [<ffffffff8109824f>] smpboot_unpark_threads+0x3f/0x60
[    1.824922]  [<ffffffff8106d45d>] _cpu_up+0x15d/0x180
[    1.830697]  [<ffffffff8106d509>] cpu_up+0x89/0xb0
[    1.836187]  [<ffffffff81db5b71>] smp_init+0x85/0x87
[    1.841871]  [<ffffffff81d9217f>] kernel_init_freeable+0x119/0x22b
[    1.848919]  [<ffffffff81817af0>] ? rest_init+0x90/0x90
[    1.854895]  [<ffffffff81817afe>] kernel_init+0xe/0xf0
[    1.860774]  [<ffffffff818322fc>] ret_from_fork+0x7c/0xb0
[    1.866946]  [<ffffffff81817af0>] ? rest_init+0x90/0x90
[    1.872923] Code: 41 56 41 55 41 54 53 48 83 ec 28 89 75 bc 0f ae f0 9c 58 66 66 90 66 90 48 89 45 b0 fa 66 66 90 66 66 90 65 8b 04 25 2c b0 00 00 <4c> 8b 25 70 15 fc 7e 89 45 c8 65 4c 03 24 25 a8 dc 00 00 48 63 
[    1.898786] RIP  [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.906386]  RSP <ffff8810273ffc48>
[    1.910419] CR2: 000000000000de40
[    1.914261] ---[ end trace 840db19b2eaea46d ]---
[    1.919556] Kernel panic - not syncing: Fatal exception
[    1.925534] BUG: unable to handle kernel paging request at 000000000000de40
[    1.933594] IP: [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.941101] PGD 0 
[    1.943549] Oops: 0000 [#2] SMP 
[    1.947431] Modules linked in:
[    1.951042] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G      D       3.16.0-00251-g7d674bb #1
[    1.960493] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0023.020920102021 02/09/2010
[    1.971110] task: ffff882027ba8000 ti: ffff8810273fc000 task.ti: ffff8810273fc000
[    1.979685] RIP: 0010:[<ffffffff8104c8c9>]  [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    1.989974] RSP: 0000:ffff8810273ff890  EFLAGS: 00010086
[    1.996047] RAX: 0000000000000000 RBX: 00000000000f4240 RCX: 0000000000000001
[    2.004161] RDX: 00000000000c0000 RSI: 00000000000000f8 RDI: ffffffff81d6c4e0
[    2.012274] RBP: ffff8810273ff8e0 R08: 0000000000000002 R09: 0000000000000001
[    2.020388] R10: ffffffff81d6c4e0 R11: ffff8810273ff656 R12: 0000000000000000
[    2.028505] R13: ffffffff81d6c4e0 R14: ffff882027ba8000 R15: 00000000000c0000
[    2.036620] FS:  0000000000000000(0000) GS:ffff88103fa00000(0000) knlGS:0000000000000000
[    2.045880] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.052439] CR2: 000000000000de40 CR3: 0000000001bfd000 CR4: 00000000000007f0
[    2.060553] Stack:
[    2.062933]  0000000000000086 000000f881acbd24 ffff8810273ffb98 0000000000000046
[    2.071689]  ffff882027ba8000 00000000000f4240 0000000000000000 ffffffff81d6c4e0
[    2.080448]  ffff882027ba8000 000000000000de40 ffff8810273ff8f0 ffffffff8104ca5c
[    2.089206] Call Trace:
[    2.092073]  [<ffffffff8104ca5c>] x2apic_send_IPI_allbutself+0x1c/0x20
[    2.099509]  [<ffffffff810435ea>] native_stop_other_cpus+0x7a/0x160
[    2.106655]  [<ffffffff818217d0>] panic+0xe0/0x1fc
[    2.112147]  [<ffffffff810177cb>] oops_end+0x12b/0x150
[    2.118027]  [<ffffffff8182101a>] no_context+0x2b3/0x2c0
[    2.124103]  [<ffffffff8182109a>] __bad_area_nosemaphore+0x73/0x1ca
[    2.131247]  [<ffffffff81821204>] bad_area_nosemaphore+0x13/0x15
[    2.138103]  [<ffffffff81058c10>] __do_page_fault+0x90/0x550
[    2.144574]  [<ffffffff8115e084>] ? __alloc_pages_nodemask+0x164/0xb00
[    2.152009]  [<ffffffff813e0322>] ? put_dec+0x72/0x90
[    2.157792]  [<ffffffff813e11f0>] ? number.isra.2+0x2f0/0x320
[    2.164351]  [<ffffffff813e0322>] ? put_dec+0x72/0x90
[    2.170135]  [<ffffffff81059101>] do_page_fault+0x31/0x70
[    2.176305]  [<ffffffff81834348>] page_fault+0x28/0x30
[    2.182185]  [<ffffffff8104c8c9>] ? __x2apic_send_IPI_mask+0x39/0x190
[    2.189523]  [<ffffffff8104ca93>] x2apic_send_IPI_mask+0x13/0x20
[    2.196376]  [<ffffffff8104346a>] native_smp_send_reschedule+0x4a/0x60
[    2.203811]  [<ffffffff8109da08>] resched_task+0xa8/0xd0
[    2.209885]  [<ffffffff8109e685>] check_preempt_curr+0x75/0xa0
[    2.216543]  [<ffffffff8109e6c9>] ttwu_do_wakeup+0x19/0xe0
[    2.222811]  [<ffffffff8109e83d>] ttwu_do_activate.constprop.85+0x5d/0x70
[    2.230537]  [<ffffffff810a14b4>] try_to_wake_up+0x1d4/0x350
[    2.237001]  [<ffffffff810a1680>] wake_up_state+0x10/0x20
[    2.243171]  [<ffffffff810909bd>] __kthread_unpark+0x5d/0x60
[    2.249635]  [<ffffffff81090f4e>] kthread_unpark+0x1e/0x30
[    2.255905]  [<ffffffff81097e2c>] smpboot_unpark_thread.isra.1+0x2c/0x30
[    2.263534]  [<ffffffff8109824f>] smpboot_unpark_threads+0x3f/0x60
[    2.270581]  [<ffffffff8106d45d>] _cpu_up+0x15d/0x180
[    2.276363]  [<ffffffff8106d509>] cpu_up+0x89/0xb0
[    2.281855]  [<ffffffff81db5b71>] smp_init+0x85/0x87
[    2.287540]  [<ffffffff81d9217f>] kernel_init_freeable+0x119/0x22b
[    2.294585]  [<ffffffff81817af0>] ? rest_init+0x90/0x90
[    2.300562]  [<ffffffff81817afe>] kernel_init+0xe/0xf0
[    2.306434]  [<ffffffff818322fc>] ret_from_fork+0x7c/0xb0
[    2.312606]  [<ffffffff81817af0>] ? rest_init+0x90/0x90
[    2.318579] Code: 41 56 41 55 41 54 53 48 83 ec 28 89 75 bc 0f ae f0 9c 58 66 66 90 66 90 48 89 45 b0 fa 66 66 90 66 66 90 65 8b 04 25 2c b0 00 00 <4c> 8b 25 70 15 fc 7e 89 45 c8 65 4c 03 24 25 a8 dc 00 00 48 63 
[    2.344437] RIP  [<ffffffff8104c8c9>] __x2apic_send_IPI_mask+0x39/0x190
[    2.352038]  RSP <ffff8810273ff890>
[    2.356068] CR2: 000000000000de40
[    2.359906] ---[ end trace 840db19b2eaea46e ]---

--OXfL5xGRrasGEqWY--
