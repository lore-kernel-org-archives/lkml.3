Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaKDE3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:29:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:20597 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbaKDE27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:28:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="410946126"
Date: Tue, 4 Nov 2014 12:29:22 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [sched] kernel BUG at kernel/smpboot.c:134!
Message-ID: <20141104042922.GM27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ELVYuRnMxQ5nnKRy"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ELVYuRnMxQ5nnKRy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://bee.sh.intel.com/git/ydu19/linux for-lkp
commit 6fe1f1b9b13f9fd76d1230944482ee5bf2832252 ("sched: Remove task and group entity load_avg when they are dead")


+---------------------------------------------------------------+------------+------------+
|                                                               | a1ec4288c6 | 6fe1f1b9b1 |
+---------------------------------------------------------------+------------+------------+
| boot_successes                                                | 10         | 71         |
| early-boot-hang                                               | 1          |            |
| boot_failures                                                 | 0          | 9          |
| kernel_BUG_at_kernel/smpboot.c                                | 0          | 5          |
| invalid_opcode                                                | 0          | 5          |
| RIP:smpboot_thread_fn                                         | 0          | 5          |
| Kernel_panic-not_syncing:Fatal_exception                      | 0          | 5          |
| Kernel_panic-not_syncing:Watchdog_detected_hard_LOCKUP_on_cpu | 0          | 1          |
| backtrace:cpu_up                                              | 0          | 1          |
| backtrace:smp_init                                            | 0          | 1          |
| backtrace:kernel_init_freeable                                | 0          | 1          |
| BUG:kernel_test_crashed                                       | 0          | 3          |
+---------------------------------------------------------------+------------+------------+


[    3.205664] masked ExtINT on CPU#98
[    3.205664] CPU98: Thermal LVT vector (0xfa) already installed
[    3.234545] ------------[ cut here ]------------
[    3.235000] kernel BUG at kernel/smpboot.c:134!
[    3.235000] invalid opcode: 0000 [#1] SMP 
[    3.235000] Modules linked in:
[    3.235000] CPU: 0 PID: 789 Comm: watchdog/98 Not tainted 3.17.0-rc7-g6fe1f1b #7
[    3.235000] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    3.235000] task: ffff881853ed8000 ti: ffff881853ee0000 task.ti: ffff881853ee0000
[    3.235000] RIP: 0010:[<ffffffff810920c0>]  [<ffffffff810920c0>] smpboot_thread_fn+0x180/0x200
[    3.235000] RSP: 0000:ffff881853ee3e88  EFLAGS: 00010202
[    3.235000] RAX: 0000000000000000 RBX: ffff881853ed8000 RCX: 0000000000000000
[    3.235000] RDX: ffff881853ee3fd8 RSI: ffff881853ed8000 RDI: 0000000000000062
[    3.235000] RBP: ffff881853ee3ec8 R08: ffff881853ee0000 R09: 0000000000000000
[    3.235000] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88185458e3e0
[    3.235000] R13: ffffffff81cc6640 R14: ffff881853ed8000 R15: ffff881853ed8000
[    3.235000] FS:  0000000000000000(0000) GS:ffff88085f800000(0000) knlGS:0000000000000000
[    3.235000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.235000] CR2: ffff88207f174000 CR3: 000000207ec38000 CR4: 00000000001407f0
[    3.235000] Stack:
[    3.235000]  0000000000000000 ffff881853ee3ea0 ffffffff81858ff9 ffff881853cfbe40
[    3.235000]  ffff88185458e3e0 ffffffff81091f40 0000000000000000 0000000000000000
[    3.235000]  ffff881853ee3f48 ffffffff8108e1ab 0000000000000001 0000000000000062
[    3.235000] Call Trace:
[    3.235000]  [<ffffffff81858ff9>] ? schedule+0x29/0x70
[    3.235000]  [<ffffffff81091f40>] ? SyS_setgroups+0x180/0x180
[    3.235000]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
[    3.235000]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[    3.235000]  [<ffffffff8185e97c>] ret_from_fork+0x7c/0xb0
[    3.235000]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[    3.235000] Code: 44 00 00 41 8b 3c 24 65 8b 14 25 2c b0 00 00 39 d7 0f 85 84 00 00 00 ff d0 41 c7 44 24 04 02 00 00 00 e9 1d ff ff ff 0f 1f 40 00 <0f> 0b 66 0f 1f 44 00 00 48 c7 45 c8 00 00 00 00 48 8b 45 c8 65 
[    3.235000] RIP  [<ffffffff810920c0>] smpboot_thread_fn+0x180/0x200
[    3.235000]  RSP <ffff881853ee3e88>
[    3.235033] ---[ end trace c537e15456e615c3 ]---
[    3.236004] Kernel panic - not syncing: Fatal exception



Thanks,
Fengguang

--ELVYuRnMxQ5nnKRy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-g6fe1f1b (kbuild@roam) (gcc version 4.9.1 (Debian 4.9.1-11) ) #7 SMP Sat Oct 11 17:57:44 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland1/lkp_will-it-scale-readseek-x86_64-rhel-HEAD-6fe1f1b9b13f9fd76d1230944482ee5bf2832252-1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/vmlinuz-3.17.0-rc7-g6fe1f1b kconfig=x86_64-rhel commit=6fe1f1b9b13f9fd76d1230944482ee5bf2832252 branch=yuyang/for-lkp root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/brickland1/will-it-scale/readseek/debian-x86_64.cgz/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/0 ip=::::brickland1::dhcp ipmi_si.tryacpi=0 ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000650a8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000650a9000-0x000000006537ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065380000-0x0000000065a6afff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065a6b000-0x0000000065b29fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065b2a000-0x0000000065df8fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065df9000-0x0000000066df8fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066df9000-0x000000007abcefff] usable
[    0.000000] BIOS-e820: [mem 0x000000007abcf000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7ebfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7ec000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x2080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 base 00007C000000 mask 3FFFFC000000 uncachable
[    0.000000]   3 base 00007FC00000 mask 3FFFFFC00000 uncachable
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
[    0.000000] Scan for SMP in [mem 0x0009d000-0x0009d3ff]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x207f174000, 0x207f174fff] PGTABLE
[    0.000000] BRK [0x207f175000, 0x207f175fff] PGTABLE
[    0.000000] BRK [0x207f176000, 0x207f176fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x650a8fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x650a8fff] page 4k
[    0.000000] BRK [0x207f177000, 0x207f177fff] PGTABLE
[    0.000000] BRK [0x207f178000, 0x207f178fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65380000-0x65a6afff]
[    0.000000]  [mem 0x65380000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x659fffff] page 2M
[    0.000000]  [mem 0x65a00000-0x65a6afff] page 4k
[    0.000000] BRK [0x207f179000, 0x207f179fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65b2a000-0x65df8fff]
[    0.000000]  [mem 0x65b2a000-0x65df8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x66df9000-0x7abcefff]
[    0.000000]  [mem 0x66df9000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]  [mem 0x7b7ec000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x2076697000-0x207dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000007B7EA0E8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 0x000000007B7E7000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 0x000000007B7B9000 022FFB (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 0x000000007AE78000 000040
[    0.000000] ACPI: TCPA 0x000000007B7E9000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 0x000000007B7E8000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 0x000000007B7E6000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 0x000000007B7E5000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 0x000000007B7E4000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 0x000000007B7E3000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 0x000000007B7E2000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 0x000000007B7E1000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 0x000000007B7E0000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 0x000000007B7DF000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 0x000000007B7DE000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 0x000000007B7DD000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 0x000000007B7DC000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0x0000000065A6B000 0BEF1B (v02 INTEL  SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 0x000000007B7B8000 00008B (v02 INTEL  SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 0x000000007B7B7000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
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
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x58 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5c -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x78 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7c -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
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
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x59 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5d -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x79 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7d -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x1080000000-0x187fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x1880000000-0x207fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87ffda000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107ffda000-0x107fffffff]
[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
[    0.000000]   NODE_DATA [mem 0x187ffda000-0x187fffffff]
[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207ffd4000-0x207fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff882056600000-ffff8820765fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x650a8fff]
[    0.000000]   node   0: [mem 0x65380000-0x65a6afff]
[    0.000000]   node   0: [mem 0x65b2a000-0x65df8fff]
[    0.000000]   node   0: [mem 0x66df9000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
[    0.000000] On node 0 totalpages: 8361962
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493645 pages, LIFO batch:31
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x80] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x82] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x84] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x86] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x88] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8a] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8c] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8e] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x90] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x92] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x94] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x96] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x98] lapic_id[0x58] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9a] lapic_id[0x5a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9c] lapic_id[0x5c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc0] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc2] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc4] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc6] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc8] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xca] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcc] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xce] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd0] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd2] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd4] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd6] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd8] lapic_id[0x78] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xda] lapic_id[0x7a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdc] lapic_id[0x7c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x81] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x83] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x85] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x87] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x89] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8b] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8d] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8f] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x91] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x93] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x95] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x97] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x99] lapic_id[0x59] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9b] lapic_id[0x5b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9d] lapic_id[0x5d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc1] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc3] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc5] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc7] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc9] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcb] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcd] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcf] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd1] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd3] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd5] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd7] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd9] lapic_id[0x79] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdb] lapic_id[0x7b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdd] lapic_id[0x7d] enabled)
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
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec80000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec80000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfecc0000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 12, version 32, address 0xfecc0000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
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
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff578000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff577000 (fecc0000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x650a9000-0x6537ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x65a6b000-0x65b29fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65df9000-0x66df8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7abcf000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7ebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:144 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88085f800000 s88896 r8192 d21696 u131072
[    0.000000] pcpu-alloc: s88896 r8192 d21696 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 060 
[    0.000000] pcpu-alloc: [0] 061 062 063 064 065 066 067 068 069 070 071 072 073 074 120 124 
[    0.000000] pcpu-alloc: [0] 128 132 136 140 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 075 
[    0.000000] pcpu-alloc: [1] 076 077 078 079 080 081 082 083 084 085 086 087 088 089 121 125 
[    0.000000] pcpu-alloc: [1] 129 133 137 141 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [2] 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 090 
[    0.000000] pcpu-alloc: [2] 091 092 093 094 095 096 097 098 099 100 101 102 103 104 122 126 
[    0.000000] pcpu-alloc: [2] 130 134 138 142 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [3] 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 105 
[    0.000000] pcpu-alloc: [3] 106 107 108 109 110 111 112 113 114 115 116 117 118 119 123 127 
[    0.000000] pcpu-alloc: [3] 131 135 139 143 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33003889
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland1/lkp_will-it-scale-readseek-x86_64-rhel-HEAD-6fe1f1b9b13f9fd76d1230944482ee5bf2832252-1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/vmlinuz-3.17.0-rc7-g6fe1f1b kconfig=x86_64-rhel commit=6fe1f1b9b13f9fd76d1230944482ee5bf2832252 branch=yuyang/for-lkp root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/brickland1/will-it-scale/readseek/debian-x86_64.cgz/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/0 ip=::::brickland1::dhcp ipmi_si.tryacpi=0 ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 585728 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 479928(91%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 131785632K/134111144K available (8590K kernel code, 1694K rwdata, 3832K rodata, 1804K init, 1888K bss, 2325512K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=144.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-143.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:524544 nr_irqs:3208 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-g6fe1f1b (kbuild@roam) (gcc version 4.9.1 (Debian 4.9.1-11) ) #7 SMP Sat Oct 11 17:57:44 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland1/lkp_will-it-scale-readseek-x86_64-rhel-HEAD-6fe1f1b9b13f9fd76d1230944482ee5bf2832252-1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/vmlinuz-3.17.0-rc7-g6fe1f1b kconfig=x86_64-rhel commit=6fe1f1b9b13f9fd76d1230944482ee5bf2832252 branch=yuyang/for-lkp root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/brickland1/will-it-scale/readseek/debian-x86_64.cgz/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/0 ip=::::brickland1::dhcp ipmi_si.tryacpi=0 ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000650a8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000650a9000-0x000000006537ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065380000-0x0000000065a6afff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065a6b000-0x0000000065b29fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065b2a000-0x0000000065df8fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065df9000-0x0000000066df8fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066df9000-0x000000007abcefff] usable
[    0.000000] BIOS-e820: [mem 0x000000007abcf000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7ebfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7ec000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x2080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000080000000 mask 3FFF80000000 uncachable
[    0.000000]   1 base 380000000000 mask 3F8000000000 uncachable
[    0.000000]   2 base 00007C000000 mask 3FFFFC000000 uncachable
[    0.000000]   3 base 00007FC00000 mask 3FFFFFC00000 uncachable
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
[    0.000000] Scan for SMP in [mem 0x0009d000-0x0009d3ff]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x207f174000, 0x207f174fff] PGTABLE
[    0.000000] BRK [0x207f175000, 0x207f175fff] PGTABLE
[    0.000000] BRK [0x207f176000, 0x207f176fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x650a8fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x650a8fff] page 4k
[    0.000000] BRK [0x207f177000, 0x207f177fff] PGTABLE
[    0.000000] BRK [0x207f178000, 0x207f178fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65380000-0x65a6afff]
[    0.000000]  [mem 0x65380000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x659fffff] page 2M
[    0.000000]  [mem 0x65a00000-0x65a6afff] page 4k
[    0.000000] BRK [0x207f179000, 0x207f179fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65b2a000-0x65df8fff]
[    0.000000]  [mem 0x65b2a000-0x65df8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x66df9000-0x7abcefff]
[    0.000000]  [mem 0x66df9000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]  [mem 0x7b7ec000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x2076697000-0x207dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000007B7EA0E8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 0x000000007B7E7000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 0x000000007B7B9000 022FFB (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 0x000000007AE78000 000040
[    0.000000] ACPI: TCPA 0x000000007B7E9000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 0x000000007B7E8000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 0x000000007B7E6000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 0x000000007B7E5000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 0x000000007B7E4000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 0x000000007B7E3000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 0x000000007B7E2000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 0x000000007B7E1000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 0x000000007B7E0000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 0x000000007B7DF000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 0x000000007B7DE000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 0x000000007B7DD000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 0x000000007B7DC000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0x0000000065A6B000 0BEF1B (v02 INTEL  SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 0x000000007B7B8000 00008B (v02 INTEL  SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 0x000000007B7B7000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x08 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0a -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0c -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0e -> Node 0
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
[    0.000000] SRAT: PXM 1 -> APIC 0x2e -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x38 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3a -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3c -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x48 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4c -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4e -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x58 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5a -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5c -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x68 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6c -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6e -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x78 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7a -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7c -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x09 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0b -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0d -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x0f -> Node 0
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
[    0.000000] SRAT: PXM 1 -> APIC 0x2f -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x39 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3b -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x3d -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x49 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4d -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x4f -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x59 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5b -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x5d -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x69 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6d -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x6f -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x79 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7b -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x7d -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x1080000000-0x187fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x1880000000-0x207fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87ffda000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107ffda000-0x107fffffff]
[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
[    0.000000]   NODE_DATA [mem 0x187ffda000-0x187fffffff]
[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207ffd4000-0x207fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff882056600000-ffff8820765fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x650a8fff]
[    0.000000]   node   0: [mem 0x65380000-0x65a6afff]
[    0.000000]   node   0: [mem 0x65b2a000-0x65df8fff]
[    0.000000]   node   0: [mem 0x66df9000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
[    0.000000] On node 0 totalpages: 8361962
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493645 pages, LIFO batch:31
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0x28] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0x2e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x50] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x52] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x54] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x56] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x58] lapic_id[0x38] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x80] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x82] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x84] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x86] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x88] lapic_id[0x48] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8a] lapic_id[0x4a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8c] lapic_id[0x4c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8e] lapic_id[0x4e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x90] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x92] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x94] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x96] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x98] lapic_id[0x58] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9a] lapic_id[0x5a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9c] lapic_id[0x5c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc0] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc2] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc4] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc6] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc8] lapic_id[0x68] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xca] lapic_id[0x6a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcc] lapic_id[0x6c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xce] lapic_id[0x6e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd0] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd2] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd4] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd6] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd8] lapic_id[0x78] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xda] lapic_id[0x7a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdc] lapic_id[0x7c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0x29] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0x2f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x51] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x53] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x55] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x57] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x59] lapic_id[0x39] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x81] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x83] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x85] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x87] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x89] lapic_id[0x49] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8b] lapic_id[0x4b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8d] lapic_id[0x4d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x8f] lapic_id[0x4f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x91] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x93] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x95] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x97] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x99] lapic_id[0x59] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9b] lapic_id[0x5b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x9d] lapic_id[0x5d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc1] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc3] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc5] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc7] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xc9] lapic_id[0x69] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcb] lapic_id[0x6b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcd] lapic_id[0x6d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xcf] lapic_id[0x6f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd1] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd3] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd5] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd7] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xd9] lapic_id[0x79] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdb] lapic_id[0x7b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0xdd] lapic_id[0x7d] enabled)
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
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec80000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec80000, GSI 72-95
[    0.000000] ACPI: IOAPIC (id[0x0c] address[0xfecc0000] gsi_base[96])
[    0.000000] IOAPIC[4]: apic_id 12, version 32, address 0xfecc0000, GSI 96-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
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
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff578000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff577000 (fecc0000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x650a9000-0x6537ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x65a6b000-0x65b29fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65df9000-0x66df8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7abcf000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7ebfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:144 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88085f800000 s88896 r8192 d21696 u131072
[    0.000000] pcpu-alloc: s88896 r8192 d21696 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 000 001 002 003 004 005 006 007 008 009 010 011 012 013 014 060 
[    0.000000] pcpu-alloc: [0] 061 062 063 064 065 066 067 068 069 070 071 072 073 074 120 124 
[    0.000000] pcpu-alloc: [0] 128 132 136 140 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [1] 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 075 
[    0.000000] pcpu-alloc: [1] 076 077 078 079 080 081 082 083 084 085 086 087 088 089 121 125 
[    0.000000] pcpu-alloc: [1] 129 133 137 141 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [2] 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 090 
[    0.000000] pcpu-alloc: [2] 091 092 093 094 095 096 097 098 099 100 101 102 103 104 122 126 
[    0.000000] pcpu-alloc: [2] 130 134 138 142 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] pcpu-alloc: [3] 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 105 
[    0.000000] pcpu-alloc: [3] 106 107 108 109 110 111 112 113 114 115 116 117 118 119 123 127 
[    0.000000] pcpu-alloc: [3] 131 135 139 143 --- --- --- --- --- --- --- --- --- --- --- --- 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33003889
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland1/lkp_will-it-scale-readseek-x86_64-rhel-HEAD-6fe1f1b9b13f9fd76d1230944482ee5bf2832252-1.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/vmlinuz-3.17.0-rc7-g6fe1f1b kconfig=x86_64-rhel commit=6fe1f1b9b13f9fd76d1230944482ee5bf2832252 branch=yuyang/for-lkp root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/brickland1/will-it-scale/readseek/debian-x86_64.cgz/x86_64-rhel/6fe1f1b9b13f9fd76d1230944482ee5bf2832252/0 ip=::::brickland1::dhcp ipmi_si.tryacpi=0 ipmi_watchdog.start_now=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 585728 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 479928(91%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 131785632K/134111144K available (8590K kernel code, 1694K rwdata, 3832K rodata, 1804K init, 1888K bss, 2325512K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=144.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-143.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:524544 nr_irqs:3208 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 536870912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2799.822 MHz processor
[    0.000334] Calibrating delay loop (skipped), value calculated using timer frequency.. 5599.64 BogoMIPS (lpj=2799822)
[    0.012248] pid_max: default: 147456 minimum: 1152
[    0.017751] ACPI: Core revision 20140724
[    0.415060] ACPI: All ACPI Tables successfully acquired
[    0.421760] Security Framework initialized
[    0.426398] SELinux:  Initializing.
[    0.430354] SELinux:  Starting in permissive mode
[    0.473736] Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.629319] Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.702502] Mount-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.711063] Mountpoint-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.724140] Initializing cgroup subsys memory
[    0.729137] Initializing cgroup subsys devices
[    0.734152] Initializing cgroup subsys freezer
[    0.739143] Initializing cgroup subsys net_cls
[    0.744129] Initializing cgroup subsys blkio
[    0.748903] Initializing cgroup subsys perf_event
[    0.754192] Initializing cgroup subsys hugetlb
[    0.759421] CPU: Physical Processor ID: 0
[    0.763901] CPU: Processor Core ID: 0
[    0.771342] mce: CPU supports 32 MCE banks
[    0.776120] CPU0: Thermal LVT vector (0xfa) already installed
[    0.782644] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.782644] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.799780] Freeing SMP alternatives memory: 36K (ffffffff81f90000 - ffffffff81f99000)
[    0.815305] ftrace: allocating 31084 entries in 122 pages
[    0.892563] Getting VERSION: 1060015
[    0.896570] Getting VERSION: 1060015
[    0.900573] Getting ID: 0
[    0.903511] Getting ID: 0
[    0.907334] Switched APIC routing to physical flat.
[    0.912791] masked ExtINT on CPU#0
[    0.918428] ENABLING IO-APIC IRQs
[    0.922137] init IO_APIC IRQs
[    0.925492]  apic 8 pin 0 not connected
[    0.929799] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.938696] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.947562] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.956504] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.965374] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.974275] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.983174] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.992040] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    1.000940] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    1.009836] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    1.018733] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    1.027805] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    1.036850] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    1.045926] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    1.055001] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    1.064076] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    1.073148]  apic 8 pin 16 not connected
[    1.077534]  apic 8 pin 17 not connected
[    1.081916]  apic 8 pin 18 not connected
[    1.086305]  apic 8 pin 19 not connected
[    1.090693]  apic 8 pin 20 not connected
[    1.095079]  apic 8 pin 21 not connected
[    1.099468]  apic 8 pin 22 not connected
[    1.103854]  apic 8 pin 23 not connected
[    1.108240]  apic 9 pin 0 not connected
[    1.112543]  apic 9 pin 1 not connected
[    1.116844]  apic 9 pin 2 not connected
[    1.121145]  apic 9 pin 3 not connected
[    1.125445]  apic 9 pin 4 not connected
[    1.129748]  apic 9 pin 5 not connected
[    1.134049]  apic 9 pin 6 not connected
[    1.138350]  apic 9 pin 7 not connected
[    1.142653]  apic 9 pin 8 not connected
[    1.146953]  apic 9 pin 9 not connected
[    1.151256]  apic 9 pin 10 not connected
[    1.155644]  apic 9 pin 11 not connected
[    1.160034]  apic 9 pin 12 not connected
[    1.164422]  apic 9 pin 13 not connected
[    1.168812]  apic 9 pin 14 not connected
[    1.173201]  apic 9 pin 15 not connected
[    1.177587]  apic 9 pin 16 not connected
[    1.181975]  apic 9 pin 17 not connected
[    1.186358]  apic 9 pin 18 not connected
[    1.190744]  apic 9 pin 19 not connected
[    1.195132]  apic 9 pin 20 not connected
[    1.199521]  apic 9 pin 21 not connected
[    1.203904]  apic 9 pin 22 not connected
[    1.208292]  apic 9 pin 23 not connected
[    1.212681]  apic 10 pin 0 not connected
[    1.217070]  apic 10 pin 1 not connected
[    1.221456]  apic 10 pin 2 not connected
[    1.225842]  apic 10 pin 3 not connected
[    1.230228]  apic 10 pin 4 not connected
[    1.234610]  apic 10 pin 5 not connected
[    1.238997]  apic 10 pin 6 not connected
[    1.243380]  apic 10 pin 7 not connected
[    1.247764]  apic 10 pin 8 not connected
[    1.252150]  apic 10 pin 9 not connected
[    1.256536]  apic 10 pin 10 not connected
[    1.261016]  apic 10 pin 11 not connected
[    1.265523]  apic 10 pin 12 not connected
[    1.270003]  apic 10 pin 13 not connected
[    1.274511]  apic 10 pin 14 not connected
[    1.278991]  apic 10 pin 15 not connected
[    1.283499]  apic 10 pin 16 not connected
[    1.287978]  apic 10 pin 17 not connected
[    1.292481]  apic 10 pin 18 not connected
[    1.296984]  apic 10 pin 19 not connected
[    1.301463]  apic 10 pin 20 not connected
[    1.305942]  apic 10 pin 21 not connected
[    1.310448]  apic 10 pin 22 not connected
[    1.314927]  apic 10 pin 23 not connected
[    1.319435]  apic 11 pin 0 not connected
[    1.323823]  apic 11 pin 1 not connected
[    1.328212]  apic 11 pin 2 not connected
[    1.332598]  apic 11 pin 3 not connected
[    1.336986]  apic 11 pin 4 not connected
[    1.341373]  apic 11 pin 5 not connected
[    1.345762]  apic 11 pin 6 not connected
[    1.350147]  apic 11 pin 7 not connected
[    1.354535]  apic 11 pin 8 not connected
[    1.358921]  apic 11 pin 9 not connected
[    1.363309]  apic 11 pin 10 not connected
[    1.367789]  apic 11 pin 11 not connected
[    1.372297]  apic 11 pin 12 not connected
[    1.376777]  apic 11 pin 13 not connected
[    1.381282]  apic 11 pin 14 not connected
[    1.385762]  apic 11 pin 15 not connected
[    1.390270]  apic 11 pin 16 not connected
[    1.394749]  apic 11 pin 17 not connected
[    1.399257]  apic 11 pin 18 not connected
[    1.403738]  apic 11 pin 19 not connected
[    1.408244]  apic 11 pin 20 not connected
[    1.412723]  apic 11 pin 21 not connected
[    1.417232]  apic 11 pin 22 not connected
[    1.421711]  apic 11 pin 23 not connected
[    1.426212]  apic 12 pin 0 not connected
[    1.430600]  apic 12 pin 1 not connected
[    1.434992]  apic 12 pin 2 not connected
[    1.439377]  apic 12 pin 3 not connected
[    1.443764]  apic 12 pin 4 not connected
[    1.448152]  apic 12 pin 5 not connected
[    1.452534]  apic 12 pin 6 not connected
[    1.456923]  apic 12 pin 7 not connected
[    1.461311]  apic 12 pin 8 not connected
[    1.465699]  apic 12 pin 9 not connected
[    1.470088]  apic 12 pin 10 not connected
[    1.474567]  apic 12 pin 11 not connected
[    1.479076]  apic 12 pin 12 not connected
[    1.483554]  apic 12 pin 13 not connected
[    1.488058]  apic 12 pin 14 not connected
[    1.492537]  apic 12 pin 15 not connected
[    1.497039]  apic 12 pin 16 not connected
[    1.501519]  apic 12 pin 17 not connected
[    1.506025]  apic 12 pin 18 not connected
[    1.510505]  apic 12 pin 19 not connected
[    1.515012]  apic 12 pin 20 not connected
[    1.519492]  apic 12 pin 21 not connected
[    1.524001]  apic 12 pin 22 not connected
[    1.528479]  apic 12 pin 23 not connected
[    1.533190] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.549955] smpboot: CPU0: Intel(R) Xeon(R) CPU E7-4890 V2 @ 2.80GHz (fam: 06, model: 3e, stepping: 07)
[    1.560525] TSC deadline timer enabled
[    1.564945] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    1.576647] ... version:                3
[    1.581156] ... bit width:              48
[    1.585755] ... generic registers:      4
[    1.590235] ... value mask:             0000ffffffffffff
[    1.596193] ... max period:             0000ffffffffffff
[    1.602151] ... fixed-purpose events:   3
[    1.606659] ... event mask:             000000070000000f
[    1.657764] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.667239] x86: Booting SMP configuration:
[    1.671937] .... node  #0, CPUs:          #1
[    1.699937] masked ExtINT on CPU#1
[    1.707646] CPU1: Thermal LVT vector (0xfa) already installed
[    1.717320]    #2
[    1.732453] masked ExtINT on CPU#2
[    1.740199] CPU2: Thermal LVT vector (0xfa) already installed
[    1.749833]    #3
[    1.764965] masked ExtINT on CPU#3
[    1.772747] CPU3: Thermal LVT vector (0xfa) already installed
[    1.782525]    #4
[    1.797644] masked ExtINT on CPU#4
[    1.805429] CPU4: Thermal LVT vector (0xfa) already installed
[    1.815228]    #5
[    1.830428] masked ExtINT on CPU#5
[    1.838455] CPU5: Thermal LVT vector (0xfa) already installed
[    1.848157]    #6
[    1.863330] masked ExtINT on CPU#6
[    1.871196] CPU6: Thermal LVT vector (0xfa) already installed
[    1.880809]    #7
[    1.895952] masked ExtINT on CPU#7
[    1.903820] CPU7: Thermal LVT vector (0xfa) already installed
[    1.913516]    #8
[    1.928682] masked ExtINT on CPU#8
[    1.936468] CPU8: Thermal LVT vector (0xfa) already installed
[    1.946248]    #9
[    1.961376] masked ExtINT on CPU#9
[    1.969159] CPU9: Thermal LVT vector (0xfa) already installed
[    1.978932]   #10
[    1.993944] masked ExtINT on CPU#10
[    2.001867] CPU10: Thermal LVT vector (0xfa) already installed
[    2.011725]   #11
[    2.026741] masked ExtINT on CPU#11
[    2.034506] CPU11: Thermal LVT vector (0xfa) already installed
[    2.044333]   #12
[    2.059346] masked ExtINT on CPU#12
[    2.067073] CPU12: Thermal LVT vector (0xfa) already installed
[    2.076843]   #13
[    2.091849] masked ExtINT on CPU#13
[    2.099521] CPU13: Thermal LVT vector (0xfa) already installed
[    2.109268]   #14
[    2.124292] masked ExtINT on CPU#14
[    2.131963] CPU14: Thermal LVT vector (0xfa) already installed
[    2.141910] 
[    2.143607] .... node  #1, CPUs:    #15
[    2.164991] masked ExtINT on CPU#15
[    2.172734] CPU15: Thermal LVT vector (0xfa) already installed
[    2.259278] TSC synchronization [CPU#0 -> CPU#15]:
[    2.264649] Measured 22578 cycles TSC warp between CPUs, turning off TSC clock.
[    2.272836] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.715831]   #16
[    0.715329] masked ExtINT on CPU#16
[    0.715329] CPU16: Thermal LVT vector (0xfa) already installed
[    0.744091]   #17
[    0.743633] masked ExtINT on CPU#17
[    0.743633] CPU17: Thermal LVT vector (0xfa) already installed
[    0.773172]   #18
[    0.772670] masked ExtINT on CPU#18
[    0.772670] CPU18: Thermal LVT vector (0xfa) already installed
[    0.802167]   #19
[    0.801709] masked ExtINT on CPU#19
[    0.801709] CPU19: Thermal LVT vector (0xfa) already installed
[    0.831215]   #20
[    0.830703] masked ExtINT on CPU#20
[    0.830703] CPU20: Thermal LVT vector (0xfa) already installed
[    0.860417]   #21
[    0.859990] masked ExtINT on CPU#21
[    0.859990] CPU21: Thermal LVT vector (0xfa) already installed
[    0.889370]   #22
[    0.888866] masked ExtINT on CPU#22
[    0.888866] CPU22: Thermal LVT vector (0xfa) already installed
[    0.918202]   #23
[    0.917746] masked ExtINT on CPU#23
[    0.917746] CPU23: Thermal LVT vector (0xfa) already installed
[    0.947247]   #24
[    0.946741] masked ExtINT on CPU#24
[    0.946741] CPU24: Thermal LVT vector (0xfa) already installed
[    0.976208]   #25
[    0.975751] masked ExtINT on CPU#25
[    0.975751] CPU25: Thermal LVT vector (0xfa) already installed
[    1.005246]   #26
[    1.004709] masked ExtINT on CPU#26
[    1.004709] CPU26: Thermal LVT vector (0xfa) already installed
[    1.033951]   #27
[    1.033532] masked ExtINT on CPU#27
[    1.033532] CPU27: Thermal LVT vector (0xfa) already installed
[    1.061947]   #28
[    1.061446] masked ExtINT on CPU#28
[    1.061446] CPU28: Thermal LVT vector (0xfa) already installed
[    1.089917]   #29
[    1.089445] masked ExtINT on CPU#29
[    1.089445] CPU29: Thermal LVT vector (0xfa) already installed
[    1.117924] 
[    1.118004] .... node  #2, CPUs:    #30
[    1.117370] masked ExtINT on CPU#30
[    1.117370] CPU30: Thermal LVT vector (0xfa) already installed
[    1.210881]   #31
[    1.210464] masked ExtINT on CPU#31
[    1.210464] CPU31: Thermal LVT vector (0xfa) already installed
[    1.239140]   #32
[    1.238657] masked ExtINT on CPU#32
[    1.238657] CPU32: Thermal LVT vector (0xfa) already installed
[    1.268156]   #33
[    1.267705] masked ExtINT on CPU#33
[    1.267705] CPU33: Thermal LVT vector (0xfa) already installed
[    1.297126]   #34
[    1.296652] masked ExtINT on CPU#34
[    1.296652] CPU34: Thermal LVT vector (0xfa) already installed
[    1.326121]   #35
[    1.325659] masked ExtINT on CPU#35
[    1.325659] CPU35: Thermal LVT vector (0xfa) already installed
[    1.355631]   #36
[    1.355154] masked ExtINT on CPU#36
[    1.355154] CPU36: Thermal LVT vector (0xfa) already installed
[    1.384165]   #37
[    1.383721] masked ExtINT on CPU#37
[    1.383721] CPU37: Thermal LVT vector (0xfa) already installed
[    1.413326]   #38
[    1.412824] masked ExtINT on CPU#38
[    1.412824] CPU38: Thermal LVT vector (0xfa) already installed
[    1.442220]   #39
[    1.441764] masked ExtINT on CPU#39
[    1.441764] CPU39: Thermal LVT vector (0xfa) already installed
[    1.471252]   #40
[    1.470722] masked ExtINT on CPU#40
[    1.470722] CPU40: Thermal LVT vector (0xfa) already installed
[    1.500126]   #41
[    1.499670] masked ExtINT on CPU#41
[    1.499670] CPU41: Thermal LVT vector (0xfa) already installed
[    1.529045]   #42
[    1.528541] masked ExtINT on CPU#42
[    1.528541] CPU42: Thermal LVT vector (0xfa) already installed
[    1.557884]   #43
[    1.557461] masked ExtINT on CPU#43
[    1.557461] CPU43: Thermal LVT vector (0xfa) already installed
[    1.585976]   #44
[    1.585464] masked ExtINT on CPU#44
[    1.585464] CPU44: Thermal LVT vector (0xfa) already installed
[    1.613968] 
[    1.614026] .... node  #3, CPUs:    #45
[    1.613463] masked ExtINT on CPU#45
[    1.613463] CPU45: Thermal LVT vector (0xfa) already installed
[    1.706922]   #46
[    1.706445] masked ExtINT on CPU#46
[    1.706445] CPU46: Thermal LVT vector (0xfa) already installed
[    1.734921]   #47
[    1.734496] masked ExtINT on CPU#47
[    1.734496] CPU47: Thermal LVT vector (0xfa) already installed
[    1.763080]   #48
[    1.762575] masked ExtINT on CPU#48
[    1.762575] CPU48: Thermal LVT vector (0xfa) already installed
[    1.792117]   #49
[    1.791635] masked ExtINT on CPU#49
[    1.791635] CPU49: Thermal LVT vector (0xfa) already installed
[    1.821078]   #50
[    1.820548] masked ExtINT on CPU#50
[    1.820548] CPU50: Thermal LVT vector (0xfa) already installed
[    1.850416]   #51
[    1.849990] masked ExtINT on CPU#51
[    1.849990] CPU51: Thermal LVT vector (0xfa) already installed
[    1.879325]   #52
[    1.878780] masked ExtINT on CPU#52
[    1.878780] CPU52: Thermal LVT vector (0xfa) already installed
[    1.908154]   #53
[    1.907715] masked ExtINT on CPU#53
[    1.907715] CPU53: Thermal LVT vector (0xfa) already installed
[    1.937168]   #54
[    1.936637] masked ExtINT on CPU#54
[    1.936637] CPU54: Thermal LVT vector (0xfa) already installed
[    1.966047]   #55
[    1.965593] masked ExtINT on CPU#55
[    1.965593] CPU55: Thermal LVT vector (0xfa) already installed
[    1.995038]   #56
[    1.994507] masked ExtINT on CPU#56
[    1.994507] CPU56: Thermal LVT vector (0xfa) already installed
[    2.023838]   #57
[    2.023412] masked ExtINT on CPU#57
[    2.023412] CPU57: Thermal LVT vector (0xfa) already installed
[    2.051796]   #58
[    2.051288] masked ExtINT on CPU#58
[    2.051288] CPU58: Thermal LVT vector (0xfa) already installed
[    2.079830]   #59
[    2.079368] masked ExtINT on CPU#59
[    2.079368] CPU59: Thermal LVT vector (0xfa) already installed
[    2.107831] 
[    2.108026] .... node  #0, CPUs:    #60
[    2.107297] masked ExtINT on CPU#60
[    2.107297] CPU60: Thermal LVT vector (0xfa) already installed
[    2.136088]   #61
[    2.135428] masked ExtINT on CPU#61
[    2.135428] CPU61: Thermal LVT vector (0xfa) already installed
[    2.165429]   #62
[    2.164823] masked ExtINT on CPU#62
[    2.164823] CPU62: Thermal LVT vector (0xfa) already installed
[    2.194496]   #63
[    2.193828] masked ExtINT on CPU#63
[    2.193828] CPU63: Thermal LVT vector (0xfa) already installed
[    2.223583]   #64
[    2.222950] masked ExtINT on CPU#64
[    2.222950] CPU64: Thermal LVT vector (0xfa) already installed
[    2.252550]   #65
[    2.251947] masked ExtINT on CPU#65
[    2.251947] CPU65: Thermal LVT vector (0xfa) already installed
[    2.281916]   #66
[    2.281275] masked ExtINT on CPU#66
[    2.281275] CPU66: Thermal LVT vector (0xfa) already installed
[    2.310669]   #67
[    2.310000] masked ExtINT on CPU#67
[    2.310000] CPU67: Thermal LVT vector (0xfa) already installed
[    2.339615]   #68
[    2.338918] masked ExtINT on CPU#68
[    2.338918] CPU68: Thermal LVT vector (0xfa) already installed
[    2.368574]   #69
[    2.367910] masked ExtINT on CPU#69
[    2.367910] CPU69: Thermal LVT vector (0xfa) already installed
[    2.397508]   #70
[    2.396843] masked ExtINT on CPU#70
[    2.396843] CPU70: Thermal LVT vector (0xfa) already installed
[    2.426424]   #71
[    2.425756] masked ExtINT on CPU#71
[    2.425756] CPU71: Thermal LVT vector (0xfa) already installed
[    2.455285]   #72
[    2.454630] masked ExtINT on CPU#72
[    2.454630] CPU72: Thermal LVT vector (0xfa) already installed
[    2.484254]   #73
[    2.483587] masked ExtINT on CPU#73
[    2.483587] CPU73: Thermal LVT vector (0xfa) already installed
[    2.513252]   #74
[    2.512590] masked ExtINT on CPU#74
[    2.512590] CPU74: Thermal LVT vector (0xfa) already installed
[    2.542292] 
[    2.543004] .... node  #1, CPUs:    #75
[    2.541541] masked ExtINT on CPU#75
[    2.541541] CPU75: Thermal LVT vector (0xfa) already installed
[    2.572389]   #76
[    2.571870] masked ExtINT on CPU#76
[    2.571870] CPU76: Thermal LVT vector (0xfa) already installed
[    2.601004]   #77
[    2.600550] masked ExtINT on CPU#77
[    2.600550] CPU77: Thermal LVT vector (0xfa) already installed
[    2.630100]   #78
[    2.629579] masked ExtINT on CPU#78
[    2.629579] CPU78: Thermal LVT vector (0xfa) already installed
[    2.659041]   #79
[    2.658580] masked ExtINT on CPU#79
[    2.658580] CPU79: Thermal LVT vector (0xfa) already installed
[    2.688139]   #80
[    2.687663] masked ExtINT on CPU#80
[    2.687663] CPU80: Thermal LVT vector (0xfa) already installed
[    2.717376]   #81
[    2.716884] masked ExtINT on CPU#81
[    2.716884] CPU81: Thermal LVT vector (0xfa) already installed
[    2.746211]   #82
[    2.745706] masked ExtINT on CPU#82
[    2.745706] CPU82: Thermal LVT vector (0xfa) already installed
[    2.775172]   #83
[    2.774716] masked ExtINT on CPU#83
[    2.774716] CPU83: Thermal LVT vector (0xfa) already installed
[    2.804193]   #84
[    2.803663] masked ExtINT on CPU#84
[    2.803663] CPU84: Thermal LVT vector (0xfa) already installed
[    2.833090]   #85
[    2.832619] masked ExtINT on CPU#85
[    2.832619] CPU85: Thermal LVT vector (0xfa) already installed
[    2.862012]   #86
[    2.861510] masked ExtINT on CPU#86
[    2.861510] CPU86: Thermal LVT vector (0xfa) already installed
[    2.890887]   #87
[    2.890421] masked ExtINT on CPU#87
[    2.890421] CPU87: Thermal LVT vector (0xfa) already installed
[    2.918916]   #88
[    2.918370] masked ExtINT on CPU#88
[    2.918370] CPU88: Thermal LVT vector (0xfa) already installed
[    2.946780]   #89
[    2.946326] masked ExtINT on CPU#89
[    2.946326] CPU89: Thermal LVT vector (0xfa) already installed
[    2.974786] 
[    2.975003] .... node  #2, CPUs:    #90
[    2.974205] masked ExtINT on CPU#90
[    2.974205] CPU90: Thermal LVT vector (0xfa) already installed
[    3.004495]   #91
[    3.004004] masked ExtINT on CPU#91
[    3.004004] CPU91: Thermal LVT vector (0xfa) already installed
[    3.032972]   #92
[    3.032466] masked ExtINT on CPU#92
[    3.032466] CPU92: Thermal LVT vector (0xfa) already installed
[    3.061035]   #93
[    3.060582] masked ExtINT on CPU#93
[    3.060582] CPU93: Thermal LVT vector (0xfa) already installed
[    3.090088]   #94
[    3.089544] masked ExtINT on CPU#94
[    3.089544] CPU94: Thermal LVT vector (0xfa) already installed
[    3.119046]   #95
[    3.118592] masked ExtINT on CPU#95
[    3.118592] CPU95: Thermal LVT vector (0xfa) already installed
[    3.148470]   #96
[    3.147922] masked ExtINT on CPU#96
[    3.147922] CPU96: Thermal LVT vector (0xfa) already installed
[    3.177201]   #97
[    3.176710] masked ExtINT on CPU#97
[    3.176710] CPU97: Thermal LVT vector (0xfa) already installed
[    3.206196]   #98
[    3.205664] masked ExtINT on CPU#98
[    3.205664] CPU98: Thermal LVT vector (0xfa) already installed
[    3.234545] ------------[ cut here ]------------
[    3.235000] kernel BUG at kernel/smpboot.c:134!
[    3.235000] invalid opcode: 0000 [#1] SMP 
[    3.235000] Modules linked in:
[    3.235000] CPU: 0 PID: 789 Comm: watchdog/98 Not tainted 3.17.0-rc7-g6fe1f1b #7
[    3.235000] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[    3.235000] task: ffff881853ed8000 ti: ffff881853ee0000 task.ti: ffff881853ee0000
[    3.235000] RIP: 0010:[<ffffffff810920c0>]  [<ffffffff810920c0>] smpboot_thread_fn+0x180/0x200
[    3.235000] RSP: 0000:ffff881853ee3e88  EFLAGS: 00010202
[    3.235000] RAX: 0000000000000000 RBX: ffff881853ed8000 RCX: 0000000000000000
[    3.235000] RDX: ffff881853ee3fd8 RSI: ffff881853ed8000 RDI: 0000000000000062
[    3.235000] RBP: ffff881853ee3ec8 R08: ffff881853ee0000 R09: 0000000000000000
[    3.235000] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88185458e3e0
[    3.235000] R13: ffffffff81cc6640 R14: ffff881853ed8000 R15: ffff881853ed8000
[    3.235000] FS:  0000000000000000(0000) GS:ffff88085f800000(0000) knlGS:0000000000000000
[    3.235000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.235000] CR2: ffff88207f174000 CR3: 000000207ec38000 CR4: 00000000001407f0
[    3.235000] Stack:
[    3.235000]  0000000000000000 ffff881853ee3ea0 ffffffff81858ff9 ffff881853cfbe40
[    3.235000]  ffff88185458e3e0 ffffffff81091f40 0000000000000000 0000000000000000
[    3.235000]  ffff881853ee3f48 ffffffff8108e1ab 0000000000000001 0000000000000062
[    3.235000] Call Trace:
[    3.235000]  [<ffffffff81858ff9>] ? schedule+0x29/0x70
[    3.235000]  [<ffffffff81091f40>] ? SyS_setgroups+0x180/0x180
[    3.235000]  [<ffffffff8108e1ab>] kthread+0xdb/0x100
[    3.235000]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[    3.235000]  [<ffffffff8185e97c>] ret_from_fork+0x7c/0xb0
[    3.235000]  [<ffffffff8108e0d0>] ? kthread_create_on_node+0x180/0x180
[    3.235000] Code: 44 00 00 41 8b 3c 24 65 8b 14 25 2c b0 00 00 39 d7 0f 85 84 00 00 00 ff d0 41 c7 44 24 04 02 00 00 00 e9 1d ff ff ff 0f 1f 40 00 <0f> 0b 66 0f 1f 44 00 00 48 c7 45 c8 00 00 00 00 48 8b 45 c8 65 
[    3.235000] RIP  [<ffffffff810920c0>] smpboot_thread_fn+0x180/0x200
[    3.235000]  RSP <ffff881853ee3e88>
[    3.235033] ---[ end trace c537e15456e615c3 ]---
[    3.236004] Kernel panic - not syncing: Fatal exception
ACPI MEMORY or I/O RESET_REG.

--ELVYuRnMxQ5nnKRy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--ELVYuRnMxQ5nnKRy--
