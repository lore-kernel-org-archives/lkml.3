Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851AbaCSL5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:57:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:15674 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518AbaCSL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:57:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,685,1389772800"; 
   d="scan'208";a="495036777"
Date: Wed, 19 Mar 2014 19:56:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched/balance] BUG: unable to handle kernel NULL pointer
 dereference at 000000000000015d
Message-ID: <20140319115654.GB7277@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Alex,

FYI, we noticed the below BUG on

https://github.com/alexshi/power-scheduling.git single-balance
commit ac76eed9c784ed577d0f26cc0bfd3bba02465942 ("sched/balance: send resched to load pulled cpu")

[   55.934564] BUG: unable to handle kernel NULL pointer dereference at 000000000000015d
[   55.937722] IP: [<ffffffff81a44659>] __schedule+0x585/0x787                          
[   55.937722] PGD 103f54f067 PUD 103f528067 PMD 0            
[   55.937722] Oops: 0000 [#1] SMP
[   55.937722] Modules linked in: x86_pkg_temp_thermal microcode mpt2sas ipmi_si ipmi_msghandler processor
[   55.937722] CPU: 91 PID: 375 Comm: migration/91 Not tainted 3.14.0-rc6-00004-g018e9d5 #1               
[   55.937722] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[   55.937722] task: ffff8818545ad190 ti: ffff881854604000 task.ti: ffff881854604000                                 
[   55.937722] RIP: 0010:[<ffffffff81a44659>]  [<ffffffff81a44659>] __schedule+0x585/0x787
[   55.937722] RSP: 0018:ffff881854605d78  EFLAGS: 00010246                               
[   55.937722] RAX: 000000000000005b RBX: ffff88185fa13000 RCX: 0000005b00000000
[   55.937722] RDX: ffff8818545ad640 RSI: ffff8818545ad190 RDI: ffff88185fa13000
[   55.937722] RBP: 000000000000024d R08: ffff881854604000 R09: 0000000000000073
[   55.937722] R10: 0000000000005c00 R11: 0000000000005b8d R12: ffff88103eb192c0
[   55.937722] R13: 0000000000000000 R14: 000000000000005b R15: ffff8818545ad190
[   55.937722] FS:  0000000000000000(0000) GS:ffff88185fa00000(0000) knlGS:0000000000000000
[   55.937722] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                           
[   55.937722] CR2: 000000000000015d CR3: 000000103f550000 CR4: 00000000001407e0
[   55.937722] Stack:
[   55.937722]  ffff8818546061f9 0000000000000000 0000000000000000 000000000000001e
[   55.937722]  0000000000000000 ffffffffffffffe4 0000000000000000 000000000000024d
[   55.937722]  0000000000000000 ffff881854605e09 0000000000000000 0000000000000000
[   55.937722] Call Trace:
[   55.937722] Code: 58 08 00 00 48 8b 40 60 48 8b 50 58 48 85 d2 74 05 48 89 df ff d2 4c 89 e6 48 89 df e8 c3 2e 00 00 c7 83 b4 08 00 00
00 00 00 00 <48> 8b 85 10 ff ff ff 65 ff 0c 25 50 b9 00 00 48 8b 80 38 e0 ff
[   55.937722] RIP  [<ffffffff81a44659>] __schedule+0x585/0x787             
[   55.937722]  RSP <ffff881854605d78>
[   55.937722] CR2: 000000000000015d
[   55.937722] ---[ end trace 905b5ff6abaedc72 ]---
[   55.937722] Kernel panic - not syncing: Fatal exception
[   55.937722] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   55.937722] Rebooting in 10 seconds..

Thanks,
Fengguang

--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-00004-g018e9d5 (kbuild@ant) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Mar 15 14:15:54 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-018e9d502823f3ec13b5044841062c95f6a718c1-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/vmlinuz-3.14.0-rc6-00004-g018e9d5 kconfig=x86_64-lkp commit=018e9d502823f3ec13b5044841062c95f6a718c1 modules_initrd=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006509ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000650a0000-0x0000000065375fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065376000-0x0000000065a6afff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065a6b000-0x0000000065b29fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065b2a000-0x0000000065df7fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065df8000-0x0000000066df7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066df8000-0x000000007abcefff] usable
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
[    0.000000] No AGP bridge found
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02669000, 0x02669fff] PGTABLE
[    0.000000] BRK [0x0266a000, 0x0266afff] PGTABLE
[    0.000000] BRK [0x0266b000, 0x0266bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6509ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x6509ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x65376000-0x65a6afff]
[    0.000000]  [mem 0x65376000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x659fffff] page 2M
[    0.000000]  [mem 0x65a00000-0x65a6afff] page 4k
[    0.000000] BRK [0x0266c000, 0x0266cfff] PGTABLE
[    0.000000] BRK [0x0266d000, 0x0266dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65b2a000-0x65df7fff]
[    0.000000]  [mem 0x65b2a000-0x65df7fff] page 4k
[    0.000000] BRK [0x0266e000, 0x0266efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x66df8000-0x7abcefff]
[    0.000000]  [mem 0x66df8000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]  [mem 0x7b7ec000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x6dbd7000-0x7abcefff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007b7ea0e8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 000000007b7e7000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000007b7b9000 022FFB (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007ae78000 000040
[    0.000000] ACPI: TCPA 000000007b7e9000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 000000007b7e8000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 000000007b7e6000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000007b7e5000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000007b7e4000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 000000007b7e3000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 000000007b7e2000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 000000007b7e1000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 000000007b7e0000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 000000007b7df000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 000000007b7de000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 000000007b7dd000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 000000007b7dc000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0000000065a6b000 0BEF1B (v02  INTEL SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 000000007b7b8000 00008B (v02  INTEL SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 000000007b7b7000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
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
[    0.000000]   NODE_DATA [mem 0x87fffb000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107fffb000-0x107fffffff]
[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
[    0.000000]   NODE_DATA [mem 0x187fffb000-0x187fffffff]
[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207fff5000-0x207fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff88205f600000-ffff88207f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x6509ffff]
[    0.000000]   node   0: [mem 0x65376000-0x65a6afff]
[    0.000000]   node   0: [mem 0x65b2a000-0x65df7fff]
[    0.000000]   node   0: [mem 0x66df8000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
[    0.000000] On node 0 totalpages: 8361963
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493646 pages, LIFO batch:31
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
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
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
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff5ee000 (fecc0000)
[    0.000000] nr_irqs_gsi: 136
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x650a0000-0x65375fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65a6b000-0x65b29fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65df8000-0x66df7fff]
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
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88085f800000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
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
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33003890
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-018e9d502823f3ec13b5044841062c95f6a718c1-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/vmlinuz-3.14.0-rc6-00004-g018e9d5 kconfig=x86_64-lkp commit=018e9d502823f3ec13b5044841062c95f6a718c1 modules_initrd=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 131695652K/134111148K available (10577K kernel code, 1252K rwdata, 4268K rodata, 1440K init, 1760K bss, 2415496K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=144.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:33024 nr_irqs:3464 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc6-00004-g018e9d5 (kbuild@ant) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sat Mar 15 14:15:54 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-018e9d502823f3ec13b5044841062c95f6a718c1-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/vmlinuz-3.14.0-rc6-00004-g018e9d5 kconfig=x86_64-lkp commit=018e9d502823f3ec13b5044841062c95f6a718c1 modules_initrd=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006509ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000650a0000-0x0000000065375fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000065376000-0x0000000065a6afff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065a6b000-0x0000000065b29fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000065b2a000-0x0000000065df7fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000065df8000-0x0000000066df7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000066df8000-0x000000007abcefff] usable
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
[    0.000000] No AGP bridge found
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02669000, 0x02669fff] PGTABLE
[    0.000000] BRK [0x0266a000, 0x0266afff] PGTABLE
[    0.000000] BRK [0x0266b000, 0x0266bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x207fe00000-0x207fffffff]
[    0.000000]  [mem 0x207fe00000-0x207fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x207c000000-0x207fdfffff]
[    0.000000]  [mem 0x207c000000-0x207fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x2000000000-0x207bffffff]
[    0.000000]  [mem 0x2000000000-0x207bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x1fffffffff]
[    0.000000]  [mem 0x1000000000-0x1fffffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x6509ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x64ffffff] page 2M
[    0.000000]  [mem 0x65000000-0x6509ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x65376000-0x65a6afff]
[    0.000000]  [mem 0x65376000-0x653fffff] page 4k
[    0.000000]  [mem 0x65400000-0x659fffff] page 2M
[    0.000000]  [mem 0x65a00000-0x65a6afff] page 4k
[    0.000000] BRK [0x0266c000, 0x0266cfff] PGTABLE
[    0.000000] BRK [0x0266d000, 0x0266dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x65b2a000-0x65df7fff]
[    0.000000]  [mem 0x65b2a000-0x65df7fff] page 4k
[    0.000000] BRK [0x0266e000, 0x0266efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x66df8000-0x7abcefff]
[    0.000000]  [mem 0x66df8000-0x66dfffff] page 4k
[    0.000000]  [mem 0x66e00000-0x7a9fffff] page 2M
[    0.000000]  [mem 0x7aa00000-0x7abcefff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]  [mem 0x7b7ec000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x6dbd7000-0x7abcefff]
[    0.000000] ACPI: RSDP 00000000000f0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 000000007b7ea0e8 0000AC (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: FACP 000000007b7e7000 0000F4 (v04 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000007b7b9000 022FFB (v02 INTEL  TIANO    00000003 MSFT 01000013)
[    0.000000] ACPI: FACS 000000007ae78000 000040
[    0.000000] ACPI: TCPA 000000007b7e9000 000064 (v02 INTEL  BRICKLAN 06222004 INTL 20121004)
[    0.000000] ACPI: BDAT 000000007b7e8000 000030 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: HPET 000000007b7e6000 000038 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000007b7e5000 00085C (v03 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000007b7e4000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: MSCT 000000007b7e3000 000090 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: PCCT 000000007b7e2000 0000AC (v01 INTEL  TIANO    00000002 MSFT 01000013)
[    0.000000] ACPI: PMCT 000000007b7e1000 000060 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: RASF 000000007b7e0000 000030 (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SLIT 000000007b7df000 00003C (v01 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SRAT 000000007b7de000 000E30 (v03 INTEL  TIANO    00000001 MSFT 01000013)
[    0.000000] ACPI: SVOS 000000007b7dd000 000032 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: WDDT 000000007b7dc000 000040 (v01 INTEL  TIANO    00000000 MSFT 01000013)
[    0.000000] ACPI: SSDT 0000000065a6b000 0BEF1B (v02  INTEL SSDT  PM 00004000 INTL 20090521)
[    0.000000] ACPI: SSDT 000000007b7b8000 00008B (v02  INTEL SpsNvs   00000002 INTL 20090521)
[    0.000000] ACPI: SPCR 000000007b7b7000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
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
[    0.000000]   NODE_DATA [mem 0x87fffb000-0x87fffffff]
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107fffb000-0x107fffffff]
[    0.000000] Initmem setup node 2 [mem 0x1080000000-0x187fffffff]
[    0.000000]   NODE_DATA [mem 0x187fffb000-0x187fffffff]
[    0.000000] Initmem setup node 3 [mem 0x1880000000-0x207fffffff]
[    0.000000]   NODE_DATA [mem 0x207fff5000-0x207fff9fff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff88105fe00000-ffff88107fdfffff] on node 1
[    0.000000]  [ffffea0042000000-ffffea0061ffffff] PMD -> [ffff88185fe00000-ffff88187fdfffff] on node 2
[    0.000000]  [ffffea0062000000-ffffea0081ffffff] PMD -> [ffff88205f600000-ffff88207f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x207fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x6509ffff]
[    0.000000]   node   0: [mem 0x65376000-0x65a6afff]
[    0.000000]   node   0: [mem 0x65b2a000-0x65df7fff]
[    0.000000]   node   0: [mem 0x66df8000-0x7abcefff]
[    0.000000]   node   0: [mem 0x7b7ec000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000]   node   2: [mem 0x1080000000-0x187fffffff]
[    0.000000]   node   3: [mem 0x1880000000-0x207fffffff]
[    0.000000] On node 0 totalpages: 8361963
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7714 pages used for memmap
[    0.000000]   DMA32 zone: 493646 pages, LIFO batch:31
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
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
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
[    0.000000] smpboot: Allowing 144 CPUs, 24 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff5f1000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff5f0000 (fec40000)
[    0.000000] mapped IOAPIC to ffffffffff5ef000 (fec80000)
[    0.000000] mapped IOAPIC to ffffffffff5ee000 (fecc0000)
[    0.000000] nr_irqs_gsi: 136
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x650a0000-0x65375fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65a6b000-0x65b29fff]
[    0.000000] PM: Registered nosave memory: [mem 0x65df8000-0x66df7fff]
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
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:144 nr_node_ids:4
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88085f800000 s81088 r8192 d21312 u131072
[    0.000000] pcpu-alloc: s81088 r8192 d21312 u131072 alloc=1*2097152
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
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33003890
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/brickland2/bisect_boot-1-x86_64-lkp-018e9d502823f3ec13b5044841062c95f6a718c1-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/vmlinuz-3.14.0-rc6-00004-g018e9d5 kconfig=x86_64-lkp commit=018e9d502823f3ec13b5044841062c95f6a718c1 modules_initrd=/kernel/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/modules.cgz RESULT_ROOT=/lkp/result/brickland2/fake/boot/1/x86_64-lkp/018e9d502823f3ec13b5044841062c95f6a718c1/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::brickland2::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 131695652K/134111148K available (10577K kernel code, 1252K rwdata, 4268K rodata, 1440K init, 1760K bss, 2415496K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=144.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:33024 nr_irqs:3464 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 536870912 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Disabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 2799.816 MHz processor
[    0.000184] Calibrating delay loop (skipped), value calculated using timer frequency.. 5599.63 BogoMIPS (lpj=11199264)
[    0.012555] pid_max: default: 147456 minimum: 1152
[    0.057239] Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.213316] Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.286052] Mount-cache hash table entries: 256
[    0.294245] Initializing cgroup subsys memory
[    0.300261] Initializing cgroup subsys devices
[    0.306203] Initializing cgroup subsys freezer
[    0.312163] Initializing cgroup subsys blkio
[    0.317921] Initializing cgroup subsys perf_event
[    0.324166] Initializing cgroup subsys hugetlb
[    0.330568] CPU: Physical Processor ID: 0
[    0.336049] CPU: Processor Core ID: 0
[    0.344421] mce: CPU supports 32 MCE banks
[    0.350175] CPU0: Thermal LVT vector (0xfa) already installed
[    0.357629] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.357629] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.357629] tlb_flushall_shift: 6
[    0.377772] Freeing SMP alternatives memory: 44K (ffffffff824a3000 - ffffffff824ae000)
[    0.395390] ftrace: allocating 40432 entries in 158 pages
[    0.483317] Getting VERSION: 1060015
[    0.488302] Getting VERSION: 1060015
[    0.493287] Getting ID: 0
[    0.497203] Getting ID: 0
[    0.501117] Switched APIC routing to physical flat.
[    0.507556] masked ExtINT on CPU#0
[    0.514171] ENABLING IO-APIC IRQs
[    0.518853] init IO_APIC IRQs
[    0.523158]  apic 8 pin 0 not connected
[    0.528447] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:0)
[    0.539138] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:0)
[    0.549820] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[    0.560511] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[    0.571161] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:0)
[    0.581844] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:0)
[    0.592525] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:0)
[    0.603216] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    0.613904] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:0)
[    0.624594] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:0)
[    0.635488] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:0)
[    0.646361] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:0)
[    0.657220] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[    0.668113] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:0)
[    0.678984] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:0)
[    0.689810]  apic 8 pin 16 not connected
[    0.695167]  apic 8 pin 17 not connected
[    0.700528]  apic 8 pin 18 not connected
[    0.705898]  apic 8 pin 19 not connected
[    0.711265]  apic 8 pin 20 not connected
[    0.716626]  apic 8 pin 21 not connected
[    0.721994]  apic 8 pin 22 not connected
[    0.727359]  apic 8 pin 23 not connected
[    0.732726]  apic 9 pin 0 not connected
[    0.738007]  apic 9 pin 1 not connected
[    0.743288]  apic 9 pin 2 not connected
[    0.748569]  apic 9 pin 3 not connected
[    0.753843]  apic 9 pin 4 not connected
[    0.759126]  apic 9 pin 5 not connected
[    0.764400]  apic 9 pin 6 not connected
[    0.769680]  apic 9 pin 7 not connected
[    0.774962]  apic 9 pin 8 not connected
[    0.780238]  apic 9 pin 9 not connected
[    0.785526]  apic 9 pin 10 not connected
[    0.790892]  apic 9 pin 11 not connected
[    0.796252]  apic 9 pin 12 not connected
[    0.801617]  apic 9 pin 13 not connected
[    0.806981]  apic 9 pin 14 not connected
[    0.812349]  apic 9 pin 15 not connected
[    0.817718]  apic 9 pin 16 not connected
[    0.823083]  apic 9 pin 17 not connected
[    0.828449]  apic 9 pin 18 not connected
[    0.833818]  apic 9 pin 19 not connected
[    0.839180]  apic 9 pin 20 not connected
[    0.844547]  apic 9 pin 21 not connected
[    0.849916]  apic 9 pin 22 not connected
[    0.855282]  apic 9 pin 23 not connected
[    0.860648]  apic 10 pin 0 not connected
[    0.866017]  apic 10 pin 1 not connected
[    0.871378]  apic 10 pin 2 not connected
[    0.876738]  apic 10 pin 3 not connected
[    0.882103]  apic 10 pin 4 not connected
[    0.887472]  apic 10 pin 5 not connected
[    0.892837]  apic 10 pin 6 not connected
[    0.898205]  apic 10 pin 7 not connected
[    0.903569]  apic 10 pin 8 not connected
[    0.908927]  apic 10 pin 9 not connected
[    0.914289]  apic 10 pin 10 not connected
[    0.919748]  apic 10 pin 11 not connected
[    0.925207]  apic 10 pin 12 not connected
[    0.930663]  apic 10 pin 13 not connected
[    0.936120]  apic 10 pin 14 not connected
[    0.941603]  apic 10 pin 15 not connected
[    0.947062]  apic 10 pin 16 not connected
[    0.952520]  apic 10 pin 17 not connected
[    0.957998]  apic 10 pin 18 not connected
[    0.963454]  apic 10 pin 19 not connected
[    0.968914]  apic 10 pin 20 not connected
[    0.974392]  apic 10 pin 21 not connected
[    0.979849]  apic 10 pin 22 not connected
[    0.985328]  apic 10 pin 23 not connected
[    0.990789]  apic 11 pin 0 not connected
[    0.996156]  apic 11 pin 1 not connected
[    1.001522]  apic 11 pin 2 not connected
[    1.006887]  apic 11 pin 3 not connected
[    1.012254]  apic 11 pin 4 not connected
[    1.017613]  apic 11 pin 5 not connected
[    1.022975]  apic 11 pin 6 not connected
[    1.028341]  apic 11 pin 7 not connected
[    1.033710]  apic 11 pin 8 not connected
[    1.039078]  apic 11 pin 9 not connected
[    1.044438]  apic 11 pin 10 not connected
[    1.049919]  apic 11 pin 11 not connected
[    1.055377]  apic 11 pin 12 not connected
[    1.060836]  apic 11 pin 13 not connected
[    1.066294]  apic 11 pin 14 not connected
[    1.071753]  apic 11 pin 15 not connected
[    1.077213]  apic 11 pin 16 not connected
[    1.082672]  apic 11 pin 17 not connected
[    1.088123]  apic 11 pin 18 not connected
[    1.093579]  apic 11 pin 19 not connected
[    1.099035]  apic 11 pin 20 not connected
[    1.104492]  apic 11 pin 21 not connected
[    1.109973]  apic 11 pin 22 not connected
[    1.115432]  apic 11 pin 23 not connected
[    1.120894]  apic 12 pin 0 not connected
[    1.126251]  apic 12 pin 1 not connected
[    1.131619]  apic 12 pin 2 not connected
[    1.136988]  apic 12 pin 3 not connected
[    1.142351]  apic 12 pin 4 not connected
[    1.147722]  apic 12 pin 5 not connected
[    1.153092]  apic 12 pin 6 not connected
[    1.158459]  apic 12 pin 7 not connected
[    1.163826]  apic 12 pin 8 not connected
[    1.169195]  apic 12 pin 9 not connected
[    1.174560]  apic 12 pin 10 not connected
[    1.180021]  apic 12 pin 11 not connected
[    1.185501]  apic 12 pin 12 not connected
[    1.190961]  apic 12 pin 13 not connected
[    1.196439]  apic 12 pin 14 not connected
[    1.201900]  apic 12 pin 15 not connected
[    1.207351]  apic 12 pin 16 not connected
[    1.212799]  apic 12 pin 17 not connected
[    1.218259]  apic 12 pin 18 not connected
[    1.223720]  apic 12 pin 19 not connected
[    1.229181]  apic 12 pin 20 not connected
[    1.234664]  apic 12 pin 21 not connected
[    1.240123]  apic 12 pin 22 not connected
[    1.245583]  apic 12 pin 23 not connected
[    1.251241] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.298974] smpboot: CPU0: Intel(R) Xeon(R) CPU E7-4890 V2 @ 2.80GHz (fam: 06, model: 3e, stepping: 07)
[    1.311842] TSC deadline timer enabled
[    1.317155] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    1.331398] ... version:                3
[    1.336855] ... bit width:              48
[    1.342425] ... generic registers:      4
[    1.347885] ... value mask:             0000ffffffffffff
[    1.354814] ... max period:             0000ffffffffffff
[    1.361758] ... fixed-purpose events:   3
[    1.367215] ... event mask:             000000070000000f
[    1.388945] x86: Booting SMP configuration:
[    1.394622] .... node  #0, CPUs:          #1
[    1.422114] masked ExtINT on CPU#1
[    1.429776] CPU1: Thermal LVT vector (0xfa) already installed
[    1.439216]    #2
[    1.454536] masked ExtINT on CPU#2
[    1.462239] CPU2: Thermal LVT vector (0xfa) already installed
[    1.471644]    #3
[    1.487714] masked ExtINT on CPU#3
[    1.495441] CPU3: Thermal LVT vector (0xfa) already installed
[    1.505064]    #4
[    1.520343] masked ExtINT on CPU#4
[    1.528059] CPU4: Thermal LVT vector (0xfa) already installed
[    1.537679]    #5
[    1.553064] masked ExtINT on CPU#5
[    1.561045] CPU5: Thermal LVT vector (0xfa) already installed
[    1.570618]    #6
[    1.585976] masked ExtINT on CPU#6
[    1.593796] CPU6: Thermal LVT vector (0xfa) already installed
[    1.603219]    #7
[    1.619307] masked ExtINT on CPU#7
[    1.627123] CPU7: Thermal LVT vector (0xfa) already installed
[    1.636718]    #8
[    1.652067] masked ExtINT on CPU#8
[    1.659785] CPU8: Thermal LVT vector (0xfa) already installed
[    1.669193]    #9
[    1.684464] masked ExtINT on CPU#9
[    1.692200] CPU9: Thermal LVT vector (0xfa) already installed
[    1.701554]   #10
[    1.716720] masked ExtINT on CPU#10
[    1.724600] CPU10: Thermal LVT vector (0xfa) already installed
[    1.734122]   #11
[    1.750108] masked ExtINT on CPU#11
[    1.757828] CPU11: Thermal LVT vector (0xfa) already installed
[    1.767331]   #12
[    1.782506] masked ExtINT on CPU#12
[    1.790216] CPU12: Thermal LVT vector (0xfa) already installed
[    1.799694]   #13
[    1.814876] masked ExtINT on CPU#13
[    1.822515] CPU13: Thermal LVT vector (0xfa) already installed
[    1.832137]   #14
[    1.847320] masked ExtINT on CPU#14
[    1.854956] CPU14: Thermal LVT vector (0xfa) already installed
[    1.864634] 
[    1.868090] .... node  #1, CPUs:    #15
[    1.889950] masked ExtINT on CPU#15
[    1.897624] CPU15: Thermal LVT vector (0xfa) already installed
[    2.000994] TSC synchronization [CPU#0 -> CPU#15]:
[    2.028122] Measured 23670 cycles TSC warp between CPUs, turning off TSC clock.
[    2.038087] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    1.152009]   #16
[    0.004000] masked ExtINT on CPU#16
[    0.004000] CPU16: Thermal LVT vector (0xfa) already installed
[    1.182924]   #17
[    0.004000] masked ExtINT on CPU#17
[    0.004000] CPU17: Thermal LVT vector (0xfa) already installed
[    1.212124]   #18
[    0.004000] masked ExtINT on CPU#18
[    0.004000] CPU18: Thermal LVT vector (0xfa) already installed
[    1.242384]   #19
[    0.004000] masked ExtINT on CPU#19
[    0.004000] CPU19: Thermal LVT vector (0xfa) already installed
[    1.272172]   #20
[    0.004000] masked ExtINT on CPU#20
[    0.004000] CPU20: Thermal LVT vector (0xfa) already installed
[    1.303548]   #21
[    0.004000] masked ExtINT on CPU#21
[    0.004000] CPU21: Thermal LVT vector (0xfa) already installed
[    1.332127]   #22
[    0.004000] masked ExtINT on CPU#22
[    0.004000] CPU22: Thermal LVT vector (0xfa) already installed
[    1.362578]   #23
[    0.004000] masked ExtINT on CPU#23
[    0.004000] CPU23: Thermal LVT vector (0xfa) already installed
[    1.392210]   #24
[    0.004000] masked ExtINT on CPU#24
[    0.004000] CPU24: Thermal LVT vector (0xfa) already installed
[    1.423286]   #25
[    0.004000] masked ExtINT on CPU#25
[    0.004000] CPU25: Thermal LVT vector (0xfa) already installed
[    1.452127]   #26
[    0.004000] masked ExtINT on CPU#26
[    0.004000] CPU26: Thermal LVT vector (0xfa) already installed
[    1.482061]   #27
[    0.004000] masked ExtINT on CPU#27
[    0.004000] CPU27: Thermal LVT vector (0xfa) already installed
[    1.511762]   #28
[    0.004000] masked ExtINT on CPU#28
[    0.004000] CPU28: Thermal LVT vector (0xfa) already installed
[    1.539751]   #29
[    0.004000] masked ExtINT on CPU#29
[    0.004000] CPU29: Thermal LVT vector (0xfa) already installed
[    1.567889] 
[    1.568003] .... node  #2, CPUs:    #30
[    0.004000] masked ExtINT on CPU#30
[    0.004000] CPU30: Thermal LVT vector (0xfa) already installed
[    1.680792]   #31
[    0.004000] masked ExtINT on CPU#31
[    0.004000] CPU31: Thermal LVT vector (0xfa) already installed
[    1.711007]   #32
[    0.004000] masked ExtINT on CPU#32
[    0.004000] CPU32: Thermal LVT vector (0xfa) already installed
[    1.740007]   #33
[    0.004000] masked ExtINT on CPU#33
[    0.004000] CPU33: Thermal LVT vector (0xfa) already installed
[    1.770339]   #34
[    0.004000] masked ExtINT on CPU#34
[    0.004000] CPU34: Thermal LVT vector (0xfa) already installed
[    1.800172]   #35
[    0.004000] masked ExtINT on CPU#35
[    0.004000] CPU35: Thermal LVT vector (0xfa) already installed
[    1.830720]   #36
[    0.004000] masked ExtINT on CPU#36
[    0.004000] CPU36: Thermal LVT vector (0xfa) already installed
[    1.860291]   #37
[    0.004000] masked ExtINT on CPU#37
[    0.004000] CPU37: Thermal LVT vector (0xfa) already installed
[    1.890468]   #38
[    0.004000] masked ExtINT on CPU#38
[    0.004000] CPU38: Thermal LVT vector (0xfa) already installed
[    1.920160]   #39
[    0.004000] masked ExtINT on CPU#39
[    0.004000] CPU39: Thermal LVT vector (0xfa) already installed
[    1.950506]   #40
[    0.004000] masked ExtINT on CPU#40
[    0.004000] CPU40: Thermal LVT vector (0xfa) already installed
[    1.980042]   #41
[    0.004000] masked ExtINT on CPU#41
[    0.004000] CPU41: Thermal LVT vector (0xfa) already installed
[    2.010131]   #42
[    0.004000] masked ExtINT on CPU#42
[    0.004000] CPU42: Thermal LVT vector (0xfa) already installed
[    2.039847]   #43
[    0.004000] masked ExtINT on CPU#43
[    0.004000] CPU43: Thermal LVT vector (0xfa) already installed
[    2.067828]   #44
[    0.004000] masked ExtINT on CPU#44
[    0.004000] CPU44: Thermal LVT vector (0xfa) already installed
[    2.096036] 
[    2.098675] .... node  #3, CPUs:    #45
[    0.004000] masked ExtINT on CPU#45
[    0.004000] CPU45: Thermal LVT vector (0xfa) already installed
[    2.212682]   #46
[    0.004000] masked ExtINT on CPU#46
[    0.004000] CPU46: Thermal LVT vector (0xfa) already installed
[    2.242913]   #47
[    0.004000] masked ExtINT on CPU#47
[    0.004000] CPU47: Thermal LVT vector (0xfa) already installed
[    2.272094]   #48
[    0.004000] masked ExtINT on CPU#48
[    0.004000] CPU48: Thermal LVT vector (0xfa) already installed
[    2.302382]   #49
[    0.004000] masked ExtINT on CPU#49
[    0.004000] CPU49: Thermal LVT vector (0xfa) already installed
[    2.332179]   #50
[    0.004000] masked ExtINT on CPU#50
[    0.004000] CPU50: Thermal LVT vector (0xfa) already installed
[    2.362963]   #51
[    0.004000] masked ExtINT on CPU#51
[    0.004000] CPU51: Thermal LVT vector (0xfa) already installed
[    2.392295]   #52
[    0.004000] masked ExtINT on CPU#52
[    0.004000] CPU52: Thermal LVT vector (0xfa) already installed
[    2.422683]   #53
[    0.004000] masked ExtINT on CPU#53
[    0.004000] CPU53: Thermal LVT vector (0xfa) already installed
[    2.452084]   #54
[    0.004000] masked ExtINT on CPU#54
[    0.004000] CPU54: Thermal LVT vector (0xfa) already installed
[    2.482403]   #55
[    0.004000] masked ExtINT on CPU#55
[    0.004000] CPU55: Thermal LVT vector (0xfa) already installed
[    2.512166]   #56
[    0.004000] masked ExtINT on CPU#56
[    0.004000] CPU56: Thermal LVT vector (0xfa) already installed
[    2.542198]   #57
[    0.004000] masked ExtINT on CPU#57
[    0.004000] CPU57: Thermal LVT vector (0xfa) already installed
[    2.571895]   #58
[    0.004000] masked ExtINT on CPU#58
[    0.004000] CPU58: Thermal LVT vector (0xfa) already installed
[    2.599913]   #59
[    0.004000] masked ExtINT on CPU#59
[    0.004000] CPU59: Thermal LVT vector (0xfa) already installed
[    2.627766] 
[    2.628003] .... node  #0, CPUs:    #60
[    0.004000] masked ExtINT on CPU#60
[    0.004000] CPU60: Thermal LVT vector (0xfa) already installed
[    2.659932]   #61
[    0.004000] masked ExtINT on CPU#61
[    0.004000] CPU61: Thermal LVT vector (0xfa) already installed
[    2.688351]   #62
[    0.004000] masked ExtINT on CPU#62
[    0.004000] CPU62: Thermal LVT vector (0xfa) already installed
[    2.719707]   #63
[    0.004000] masked ExtINT on CPU#63
[    0.004000] CPU63: Thermal LVT vector (0xfa) already installed
[    2.748545]   #64
[    0.004000] masked ExtINT on CPU#64
[    0.004000] CPU64: Thermal LVT vector (0xfa) already installed
[    2.779088]   #65
[    0.004000] masked ExtINT on CPU#65
[    0.004000] CPU65: Thermal LVT vector (0xfa) already installed
[    2.808863]   #66
[    0.004000] masked ExtINT on CPU#66
[    0.004000] CPU66: Thermal LVT vector (0xfa) already installed
[    2.840414]   #67
[    0.004000] masked ExtINT on CPU#67
[    0.004000] CPU67: Thermal LVT vector (0xfa) already installed
[    2.871100]   #68
[    0.004000] masked ExtINT on CPU#68
[    0.004000] CPU68: Thermal LVT vector (0xfa) already installed
[    2.900554]   #69
[    0.004000] masked ExtINT on CPU#69
[    0.004000] CPU69: Thermal LVT vector (0xfa) already installed
[    2.931203]   #70
[    0.004000] masked ExtINT on CPU#70
[    0.004000] CPU70: Thermal LVT vector (0xfa) already installed
[    2.960374]   #71
[    0.004000] masked ExtINT on CPU#71
[    0.004000] CPU71: Thermal LVT vector (0xfa) already installed
[    2.990805]   #72
[    0.004000] masked ExtINT on CPU#72
[    0.004000] CPU72: Thermal LVT vector (0xfa) already installed
[    3.020173]   #73
[    0.004000] masked ExtINT on CPU#73
[    0.004000] CPU73: Thermal LVT vector (0xfa) already installed
[    3.050546]   #74
[    0.004000] masked ExtINT on CPU#74
[    0.004000] CPU74: Thermal LVT vector (0xfa) already installed
[    3.080257] 
[    3.082896] .... node  #1, CPUs:    #75
[    0.004000] masked ExtINT on CPU#75
[    0.004000] CPU75: Thermal LVT vector (0xfa) already installed
[    3.112717]   #76
[    0.004000] masked ExtINT on CPU#76
[    0.004000] CPU76: Thermal LVT vector (0xfa) already installed
[    3.143043]   #77
[    0.004000] masked ExtINT on CPU#77
[    0.004000] CPU77: Thermal LVT vector (0xfa) already installed
[    3.172116]   #78
[    0.004000] masked ExtINT on CPU#78
[    0.004000] CPU78: Thermal LVT vector (0xfa) already installed
[    3.202404]   #79
[    0.004000] masked ExtINT on CPU#79
[    0.004000] CPU79: Thermal LVT vector (0xfa) already installed
[    3.232172]   #80
[    0.004000] masked ExtINT on CPU#80
[    0.004000] CPU80: Thermal LVT vector (0xfa) already installed
[    3.262759]   #81
[    0.004000] masked ExtINT on CPU#81
[    0.004000] CPU81: Thermal LVT vector (0xfa) already installed
[    3.292266]   #82
[    0.004000] masked ExtINT on CPU#82
[    0.004000] CPU82: Thermal LVT vector (0xfa) already installed
[    3.322684]   #83
[    0.004000] masked ExtINT on CPU#83
[    0.004000] CPU83: Thermal LVT vector (0xfa) already installed
[    3.352126]   #84
[    0.004000] masked ExtINT on CPU#84
[    0.004000] CPU84: Thermal LVT vector (0xfa) already installed
[    3.382387]   #85
[    0.004000] masked ExtINT on CPU#85
[    0.004000] CPU85: Thermal LVT vector (0xfa) already installed
[    3.412034]   #86
[    0.004000] masked ExtINT on CPU#86
[    0.004000] CPU86: Thermal LVT vector (0xfa) already installed
[    3.442210]   #87
[    0.004000] masked ExtINT on CPU#87
[    0.004000] CPU87: Thermal LVT vector (0xfa) already installed
[    3.472004]   #88
[    0.004000] masked ExtINT on CPU#88
[    0.004000] CPU88: Thermal LVT vector (0xfa) already installed
[    3.501965]   #89
[    0.004000] masked ExtINT on CPU#89
[    0.004000] CPU89: Thermal LVT vector (0xfa) already installed
[    3.531878] 
[    3.532026] .... node  #2, CPUs:    #90
[    0.004000] masked ExtINT on CPU#90
[    0.004000] CPU90: Thermal LVT vector (0xfa) already installed
[    3.564045]   #91
[    0.004000] masked ExtINT on CPU#91
[    0.004000] CPU91: Thermal LVT vector (0xfa) already installed
[    3.594208]   #92
[    0.004000] masked ExtINT on CPU#92
[    0.004000] CPU92: Thermal LVT vector (0xfa) already installed
[    3.624123]   #93
[    0.004000] masked ExtINT on CPU#93
[    0.004000] CPU93: Thermal LVT vector (0xfa) already installed
[    3.654339]   #94
[    0.004000] masked ExtINT on CPU#94
[    0.004000] CPU94: Thermal LVT vector (0xfa) already installed
[    3.684167]   #95
[    0.004000] masked ExtINT on CPU#95
[    0.004000] CPU95: Thermal LVT vector (0xfa) already installed
[    3.714838]   #96
[    0.004000] masked ExtINT on CPU#96
[    0.004000] CPU96: Thermal LVT vector (0xfa) already installed
[    3.744208]   #97
[    0.004000] masked ExtINT on CPU#97
[    0.004000] CPU97: Thermal LVT vector (0xfa) already installed
[    3.774675]   #98
[    0.004000] masked ExtINT on CPU#98
[    0.004000] CPU98: Thermal LVT vector (0xfa) already installed
[    3.804251]   #99
[    0.004000] masked ExtINT on CPU#99
[    0.004000] CPU99: Thermal LVT vector (0xfa) already installed
[    3.834473]  #100
[    0.004000] masked ExtINT on CPU#100
[    0.004000] CPU100: Thermal LVT vector (0xfa) already installed
[    3.864221]  #101
[    0.004000] masked ExtINT on CPU#101
[    0.004000] CPU101: Thermal LVT vector (0xfa) already installed
[    3.894500]  #102
[    0.004000] masked ExtINT on CPU#102
[    0.004000] CPU102: Thermal LVT vector (0xfa) already installed
[    3.924179]  #103
[    0.004000] masked ExtINT on CPU#103
[    0.004000] CPU103: Thermal LVT vector (0xfa) already installed
[    3.954382]  #104
[    0.004000] masked ExtINT on CPU#104
[    0.004000] CPU104: Thermal LVT vector (0xfa) already installed
[    3.984078] 
[    3.986724] .... node  #3, CPUs:   #105
[    0.004000] masked ExtINT on CPU#105
[    0.004000] CPU105: Thermal LVT vector (0xfa) already installed
[    4.016955]  #106
[    0.004000] masked ExtINT on CPU#106
[    0.004000] CPU106: Thermal LVT vector (0xfa) already installed
[    4.047403]  #107
[    0.004000] masked ExtINT on CPU#107
[    0.004000] CPU107: Thermal LVT vector (0xfa) already installed
[    4.076350]  #108
[    0.004000] masked ExtINT on CPU#108
[    0.004000] CPU108: Thermal LVT vector (0xfa) already installed
[    4.106910]  #109
[    0.004000] masked ExtINT on CPU#109
[    0.004000] CPU109: Thermal LVT vector (0xfa) already installed
[    4.136332]  #110
[    0.004000] masked ExtINT on CPU#110
[    0.004000] CPU110: Thermal LVT vector (0xfa) already installed
[    4.167168]  #111
[    0.004000] masked ExtINT on CPU#111
[    0.004000] CPU111: Thermal LVT vector (0xfa) already installed
[    4.196538]  #112
[    0.004000] masked ExtINT on CPU#112
[    0.004000] CPU112: Thermal LVT vector (0xfa) already installed
[    4.227009]  #113
[    0.004000] masked ExtINT on CPU#113
[    0.004000] CPU113: Thermal LVT vector (0xfa) already installed
[    4.256373]  #114
[    0.004000] masked ExtINT on CPU#114
[    0.004000] CPU114: Thermal LVT vector (0xfa) already installed
[    4.286850]  #115
[    0.004000] masked ExtINT on CPU#115
[    0.004000] CPU115: Thermal LVT vector (0xfa) already installed
[    4.316217]  #116
[    0.004000] masked ExtINT on CPU#116
[    0.004000] CPU116: Thermal LVT vector (0xfa) already installed
[    4.346628]  #117
[    0.004000] masked ExtINT on CPU#117
[    0.004000] CPU117: Thermal LVT vector (0xfa) already installed
[    4.375973]  #118
[    0.004000] masked ExtINT on CPU#118
[    0.004000] CPU118: Thermal LVT vector (0xfa) already installed
[    4.404097]  #119
[    0.004000] masked ExtINT on CPU#119
[    0.004000] CPU119: Thermal LVT vector (0xfa) already installed
[    4.434743] x86: Booted up 4 nodes, 120 CPUs
[    4.436008] smpboot: Total of 120 processors activated (673353.69 BogoMIPS)
[    4.457853] devtmpfs: initialized
[    4.548124] PM: Registering ACPI NVS region [mem 0x650a0000-0x65375fff] (2973696 bytes)
[    4.552338] PM: Registering ACPI NVS region [mem 0x65df8000-0x66df7fff] (16777216 bytes)
[    4.557308] PM: Registering ACPI NVS region [mem 0x7accf000-0x7b6fefff] (10682368 bytes)
[    4.570199] xor: automatically using best checksumming function:
[    4.612055]    avx       :  3981.000 MB/sec
[    4.616203] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    4.620715] NET: Registered protocol family 16
[    4.628081] cpuidle: using governor ladder
[    4.632080] cpuidle: using governor menu
[    4.638390] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    4.640080] ACPI: bus type PCI registered
[    4.644079] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    4.648137] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    4.652083] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    4.736848] PCI: Using configuration type 1 for base access
[    4.832165] bio: create slab <bio-0> at 0
[    4.904127] raid6: sse2x1    1174 MB/s
[    4.976092] raid6: sse2x2    1514 MB/s
[    5.048080] raid6: sse2x4    2001 MB/s
[    5.052055] raid6: using algorithm sse2x4 (2001 MB/s)
[    5.056078] raid6: using ssse3x2 recovery algorithm
[    5.062016] ACPI: Added _OSI(Module Device)
[    5.064085] ACPI: Added _OSI(Processor Device)
[    5.068079] ACPI: Added _OSI(3.0 _SCP Extensions)
[    5.072051] ACPI: Added _OSI(Processor Aggregator Device)
[    5.627352] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20131218/dsopcode-236)
[    5.635578] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88085f43cc80), AE_AML_BUFFER_LIMIT (20131218/psparse-536)
[    5.790170] ACPI: Interpreter enabled
[    5.792119] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    5.803467] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131218/hwxface-580)
[    5.811500] ACPI: (supports S0 S1 S4 S5)
[    5.812077] ACPI: Using IOAPIC for interrupt routing
[    5.816237] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    5.833806] ACPI: No dock devices found.
[    6.116423] ACPI: PCI Root Bridge [UNC3] (domain 0000 [bus ff])
[    6.120089] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.124085] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    6.128264] PCI host bridge to bus 0000:ff
[    6.132083] pci_bus 0000:ff: root bus resource [bus ff]
[    6.136120] pci 0000:ff:08.0: [8086:0e80] type 00 class 0x088000
[    6.140327] pci 0000:ff:08.2: [8086:0e32] type 00 class 0x110100
[    6.144331] pci 0000:ff:08.3: [8086:0e83] type 00 class 0x088000
[    6.148334] pci 0000:ff:08.4: [8086:0e84] type 00 class 0x088000
[    6.152385] pci 0000:ff:09.0: [8086:0e90] type 00 class 0x088000
[    6.156295] pci 0000:ff:09.2: [8086:0e33] type 00 class 0x110100
[    6.160300] pci 0000:ff:09.3: [8086:0e93] type 00 class 0x088000
[    6.164334] pci 0000:ff:09.4: [8086:0e94] type 00 class 0x088000
[    6.168371] pci 0000:ff:0a.0: [8086:0ec0] type 00 class 0x088000
[    6.172291] pci 0000:ff:0a.1: [8086:0ec1] type 00 class 0x088000
[    6.176298] pci 0000:ff:0a.2: [8086:0ec2] type 00 class 0x088000
[    6.180290] pci 0000:ff:0a.3: [8086:0ec3] type 00 class 0x088000
[    6.184330] pci 0000:ff:0b.0: [8086:0e1e] type 00 class 0x088000
[    6.188290] pci 0000:ff:0b.3: [8086:0e1f] type 00 class 0x088000
[    6.192294] pci 0000:ff:0c.0: [8086:0ee0] type 00 class 0x088000
[    6.196289] pci 0000:ff:0c.1: [8086:0ee2] type 00 class 0x088000
[    6.200303] pci 0000:ff:0c.2: [8086:0ee4] type 00 class 0x088000
[    6.204290] pci 0000:ff:0c.3: [8086:0ee6] type 00 class 0x088000
[    6.208304] pci 0000:ff:0c.4: [8086:0ee8] type 00 class 0x088000
[    6.212292] pci 0000:ff:0c.5: [8086:0eea] type 00 class 0x088000
[    6.216330] pci 0000:ff:0c.6: [8086:0eec] type 00 class 0x088000
[    6.220291] pci 0000:ff:0c.7: [8086:0eee] type 00 class 0x088000
[    6.224304] pci 0000:ff:0d.0: [8086:0ee1] type 00 class 0x088000
[    6.228292] pci 0000:ff:0d.1: [8086:0ee3] type 00 class 0x088000
[    6.232289] pci 0000:ff:0d.2: [8086:0ee5] type 00 class 0x088000
[    6.236299] pci 0000:ff:0d.3: [8086:0ee7] type 00 class 0x088000
[    6.240290] pci 0000:ff:0d.4: [8086:0ee9] type 00 class 0x088000
[    6.244327] pci 0000:ff:0d.5: [8086:0eeb] type 00 class 0x088000
[    6.248297] pci 0000:ff:0d.6: [8086:0eed] type 00 class 0x088000
[    6.252303] pci 0000:ff:0e.0: [8086:0ea0] type 00 class 0x088000
[    6.256297] pci 0000:ff:0e.1: [8086:0e30] type 00 class 0x110100
[    6.260332] pci 0000:ff:0f.0: [8086:0ea8] type 00 class 0x088000
[    6.264334] pci 0000:ff:0f.1: [8086:0e71] type 00 class 0x088000
[    6.268374] pci 0000:ff:0f.2: [8086:0eaa] type 00 class 0x088000
[    6.272332] pci 0000:ff:0f.3: [8086:0eab] type 00 class 0x088000
[    6.276341] pci 0000:ff:0f.4: [8086:0eac] type 00 class 0x088000
[    6.280338] pci 0000:ff:0f.5: [8086:0ead] type 00 class 0x088000
[    6.284373] pci 0000:ff:10.0: [8086:0eb0] type 00 class 0x088000
[    6.288334] pci 0000:ff:10.1: [8086:0eb1] type 00 class 0x088000
[    6.292372] pci 0000:ff:10.2: [8086:0eb2] type 00 class 0x088000
[    6.296374] pci 0000:ff:10.3: [8086:0eb3] type 00 class 0x088000
[    6.300370] pci 0000:ff:10.4: [8086:0eb4] type 00 class 0x088000
[    6.304339] pci 0000:ff:10.5: [8086:0eb5] type 00 class 0x088000
[    6.308369] pci 0000:ff:10.6: [8086:0eb6] type 00 class 0x088000
[    6.312342] pci 0000:ff:10.7: [8086:0eb7] type 00 class 0x088000
[    6.316369] pci 0000:ff:11.0: [8086:0ef8] type 00 class 0x088000
[    6.320335] pci 0000:ff:13.0: [8086:0e1d] type 00 class 0x088000
[    6.324295] pci 0000:ff:13.1: [8086:0e34] type 00 class 0x110100
[    6.328291] pci 0000:ff:13.4: [8086:0e81] type 00 class 0x088000
[    6.332300] pci 0000:ff:13.5: [8086:0e36] type 00 class 0x110100
[    6.336293] pci 0000:ff:13.6: [8086:0e37] type 00 class 0x110100
[    6.340295] pci 0000:ff:16.0: [8086:0ec8] type 00 class 0x088000
[    6.344297] pci 0000:ff:16.1: [8086:0ec9] type 00 class 0x088000
[    6.348304] pci 0000:ff:16.2: [8086:0eca] type 00 class 0x088000
[    6.352293] pci 0000:ff:18.0: [8086:0e40] type 00 class 0x088000
[    6.356300] pci 0000:ff:18.2: [8086:0e3a] type 00 class 0x110100
[    6.360291] pci 0000:ff:18.3: [8086:0e43] type 00 class 0x088000
[    6.364345] pci 0000:ff:18.4: [8086:0e44] type 00 class 0x088000
[    6.368334] pci 0000:ff:1c.0: [8086:0e60] type 00 class 0x088000
[    6.372295] pci 0000:ff:1c.1: [8086:0e38] type 00 class 0x110100
[    6.376330] pci 0000:ff:1d.0: [8086:0e68] type 00 class 0x088000
[    6.380339] pci 0000:ff:1d.1: [8086:0e79] type 00 class 0x088000
[    6.384371] pci 0000:ff:1d.2: [8086:0e6a] type 00 class 0x088000
[    6.388336] pci 0000:ff:1d.3: [8086:0e6b] type 00 class 0x088000
[    6.392368] pci 0000:ff:1d.4: [8086:0e6c] type 00 class 0x088000
[    6.396337] pci 0000:ff:1d.5: [8086:0e6d] type 00 class 0x088000
[    6.400344] pci 0000:ff:1e.0: [8086:0ef0] type 00 class 0x088000
[    6.404342] pci 0000:ff:1e.1: [8086:0ef1] type 00 class 0x088000
[    6.408380] pci 0000:ff:1e.2: [8086:0ef2] type 00 class 0x088000
[    6.412341] pci 0000:ff:1e.3: [8086:0ef3] type 00 class 0x088000
[    6.416373] pci 0000:ff:1e.4: [8086:0ef4] type 00 class 0x088000
[    6.420343] pci 0000:ff:1e.5: [8086:0ef5] type 00 class 0x088000
[    6.424380] pci 0000:ff:1e.6: [8086:0ef6] type 00 class 0x088000
[    6.428338] pci 0000:ff:1e.7: [8086:0ef7] type 00 class 0x088000
[    6.432374] pci 0000:ff:1f.0: [8086:0ed8] type 00 class 0x088000
[    6.436337] pci 0000:ff:1f.1: [8086:0ed9] type 00 class 0x088000
[    6.440384] pci 0000:ff:1f.4: [8086:0edc] type 00 class 0x088000
[    6.444340] pci 0000:ff:1f.5: [8086:0edd] type 00 class 0x088000
[    6.448379] pci 0000:ff:1f.6: [8086:0ede] type 00 class 0x088000
[    6.452335] pci 0000:ff:1f.7: [8086:0edf] type 00 class 0x088000
[    6.456372] ACPI: PCI Root Bridge [UNC2] (domain 0000 [bus bf])
[    6.460086] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.464084] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    6.468253] PCI host bridge to bus 0000:bf
[    6.472082] pci_bus 0000:bf: root bus resource [bus bf]
[    6.476095] pci 0000:bf:08.0: [8086:0e80] type 00 class 0x088000
[    6.480333] pci 0000:bf:08.2: [8086:0e32] type 00 class 0x110100
[    6.484295] pci 0000:bf:08.3: [8086:0e83] type 00 class 0x088000
[    6.488375] pci 0000:bf:08.4: [8086:0e84] type 00 class 0x088000
[    6.492369] pci 0000:bf:09.0: [8086:0e90] type 00 class 0x088000
[    6.496331] pci 0000:bf:09.2: [8086:0e33] type 00 class 0x110100
[    6.500296] pci 0000:bf:09.3: [8086:0e93] type 00 class 0x088000
[    6.504370] pci 0000:bf:09.4: [8086:0e94] type 00 class 0x088000
[    6.508339] pci 0000:bf:0a.0: [8086:0ec0] type 00 class 0x088000
[    6.512334] pci 0000:bf:0a.1: [8086:0ec1] type 00 class 0x088000
[    6.516289] pci 0000:bf:0a.2: [8086:0ec2] type 00 class 0x088000
[    6.520298] pci 0000:bf:0a.3: [8086:0ec3] type 00 class 0x088000
[    6.524330] pci 0000:bf:0b.0: [8086:0e1e] type 00 class 0x088000
[    6.528297] pci 0000:bf:0b.3: [8086:0e1f] type 00 class 0x088000
[    6.532302] pci 0000:bf:0c.0: [8086:0ee0] type 00 class 0x088000
[    6.536297] pci 0000:bf:0c.1: [8086:0ee2] type 00 class 0x088000
[    6.540341] pci 0000:bf:0c.2: [8086:0ee4] type 00 class 0x088000
[    6.544298] pci 0000:bf:0c.3: [8086:0ee6] type 00 class 0x088000
[    6.548327] pci 0000:bf:0c.4: [8086:0ee8] type 00 class 0x088000
[    6.552289] pci 0000:bf:0c.5: [8086:0eea] type 00 class 0x088000
[    6.556330] pci 0000:bf:0c.6: [8086:0eec] type 00 class 0x088000
[    6.560288] pci 0000:bf:0c.7: [8086:0eee] type 00 class 0x088000
[    6.564299] pci 0000:bf:0d.0: [8086:0ee1] type 00 class 0x088000
[    6.568291] pci 0000:bf:0d.1: [8086:0ee3] type 00 class 0x088000
[    6.572327] pci 0000:bf:0d.2: [8086:0ee5] type 00 class 0x088000
[    6.576294] pci 0000:bf:0d.3: [8086:0ee7] type 00 class 0x088000
[    6.580301] pci 0000:bf:0d.4: [8086:0ee9] type 00 class 0x088000
[    6.584291] pci 0000:bf:0d.5: [8086:0eeb] type 00 class 0x088000
[    6.588330] pci 0000:bf:0d.6: [8086:0eed] type 00 class 0x088000
[    6.592289] pci 0000:bf:0e.0: [8086:0ea0] type 00 class 0x088000
[    6.596333] pci 0000:bf:0e.1: [8086:0e30] type 00 class 0x110100
[    6.600296] pci 0000:bf:0f.0: [8086:0ea8] type 00 class 0x088000
[    6.604337] pci 0000:bf:0f.1: [8086:0e71] type 00 class 0x088000
[    6.608333] pci 0000:bf:0f.2: [8086:0eaa] type 00 class 0x088000
[    6.612368] pci 0000:bf:0f.3: [8086:0eab] type 00 class 0x088000
[    6.616334] pci 0000:bf:0f.4: [8086:0eac] type 00 class 0x088000
[    6.620370] pci 0000:bf:0f.5: [8086:0ead] type 00 class 0x088000
[    6.624335] pci 0000:bf:10.0: [8086:0eb0] type 00 class 0x088000
[    6.628343] pci 0000:bf:10.1: [8086:0eb1] type 00 class 0x088000
[    6.632334] pci 0000:bf:10.2: [8086:0eb2] type 00 class 0x088000
[    6.636370] pci 0000:bf:10.3: [8086:0eb3] type 00 class 0x088000
[    6.640336] pci 0000:bf:10.4: [8086:0eb4] type 00 class 0x088000
[    6.644385] pci 0000:bf:10.5: [8086:0eb5] type 00 class 0x088000
[    6.648369] pci 0000:bf:10.6: [8086:0eb6] type 00 class 0x088000
[    6.652375] pci 0000:bf:10.7: [8086:0eb7] type 00 class 0x088000
[    6.656330] pci 0000:bf:11.0: [8086:0ef8] type 00 class 0x088000
[    6.660330] pci 0000:bf:13.0: [8086:0e1d] type 00 class 0x088000
[    6.664328] pci 0000:bf:13.1: [8086:0e34] type 00 class 0x110100
[    6.668288] pci 0000:bf:13.4: [8086:0e81] type 00 class 0x088000
[    6.672303] pci 0000:bf:13.5: [8086:0e36] type 00 class 0x110100
[    6.676288] pci 0000:bf:13.6: [8086:0e37] type 00 class 0x110100
[    6.680328] pci 0000:bf:16.0: [8086:0ec8] type 00 class 0x088000
[    6.684294] pci 0000:bf:16.1: [8086:0ec9] type 00 class 0x088000
[    6.688330] pci 0000:bf:16.2: [8086:0eca] type 00 class 0x088000
[    6.692288] pci 0000:bf:18.0: [8086:0e40] type 00 class 0x088000
[    6.696300] pci 0000:bf:18.2: [8086:0e3a] type 00 class 0x110100
[    6.700290] pci 0000:bf:18.3: [8086:0e43] type 00 class 0x088000
[    6.704342] pci 0000:bf:18.4: [8086:0e44] type 00 class 0x088000
[    6.708332] pci 0000:bf:1c.0: [8086:0e60] type 00 class 0x088000
[    6.712333] pci 0000:bf:1c.1: [8086:0e38] type 00 class 0x110100
[    6.716302] pci 0000:bf:1d.0: [8086:0e68] type 00 class 0x088000
[    6.720372] pci 0000:bf:1d.1: [8086:0e79] type 00 class 0x088000
[    6.724331] pci 0000:bf:1d.2: [8086:0e6a] type 00 class 0x088000
[    6.728381] pci 0000:bf:1d.3: [8086:0e6b] type 00 class 0x088000
[    6.732336] pci 0000:bf:1d.4: [8086:0e6c] type 00 class 0x088000
[    6.736371] pci 0000:bf:1d.5: [8086:0e6d] type 00 class 0x088000
[    6.740335] pci 0000:bf:1e.0: [8086:0ef0] type 00 class 0x088000
[    6.744367] pci 0000:bf:1e.1: [8086:0ef1] type 00 class 0x088000
[    6.748340] pci 0000:bf:1e.2: [8086:0ef2] type 00 class 0x088000
[    6.752371] pci 0000:bf:1e.3: [8086:0ef3] type 00 class 0x088000
[    6.756333] pci 0000:bf:1e.4: [8086:0ef4] type 00 class 0x088000
[    6.760374] pci 0000:bf:1e.5: [8086:0ef5] type 00 class 0x088000
[    6.764334] pci 0000:bf:1e.6: [8086:0ef6] type 00 class 0x088000
[    6.768371] pci 0000:bf:1e.7: [8086:0ef7] type 00 class 0x088000
[    6.772335] pci 0000:bf:1f.0: [8086:0ed8] type 00 class 0x088000
[    6.776374] pci 0000:bf:1f.1: [8086:0ed9] type 00 class 0x088000
[    6.780338] pci 0000:bf:1f.4: [8086:0edc] type 00 class 0x088000
[    6.784372] pci 0000:bf:1f.5: [8086:0edd] type 00 class 0x088000
[    6.788332] pci 0000:bf:1f.6: [8086:0ede] type 00 class 0x088000
[    6.792332] pci 0000:bf:1f.7: [8086:0edf] type 00 class 0x088000
[    6.796341] ACPI: PCI Root Bridge [UNC1] (domain 0000 [bus 7f])
[    6.800090] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.804085] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    6.808252] PCI host bridge to bus 0000:7f
[    6.812084] pci_bus 0000:7f: root bus resource [bus 7f]
[    6.816094] pci 0000:7f:08.0: [8086:0e80] type 00 class 0x088000
[    6.820302] pci 0000:7f:08.2: [8086:0e32] type 00 class 0x110100
[    6.824305] pci 0000:7f:08.3: [8086:0e83] type 00 class 0x088000
[    6.828344] pci 0000:7f:08.4: [8086:0e84] type 00 class 0x088000
[    6.832342] pci 0000:7f:09.0: [8086:0e90] type 00 class 0x088000
[    6.836331] pci 0000:7f:09.2: [8086:0e33] type 00 class 0x110100
[    6.840291] pci 0000:7f:09.3: [8086:0e93] type 00 class 0x088000
[    6.844371] pci 0000:7f:09.4: [8086:0e94] type 00 class 0x088000
[    6.848335] pci 0000:7f:0a.0: [8086:0ec0] type 00 class 0x088000
[    6.852328] pci 0000:7f:0a.1: [8086:0ec1] type 00 class 0x088000
[    6.856288] pci 0000:7f:0a.2: [8086:0ec2] type 00 class 0x088000
[    6.860300] pci 0000:7f:0a.3: [8086:0ec3] type 00 class 0x088000
[    6.864293] pci 0000:7f:0b.0: [8086:0e1e] type 00 class 0x088000
[    6.868327] pci 0000:7f:0b.3: [8086:0e1f] type 00 class 0x088000
[    6.872285] pci 0000:7f:0c.0: [8086:0ee0] type 00 class 0x088000
[    6.876301] pci 0000:7f:0c.1: [8086:0ee2] type 00 class 0x088000
[    6.880286] pci 0000:7f:0c.2: [8086:0ee4] type 00 class 0x088000
[    6.884330] pci 0000:7f:0c.3: [8086:0ee6] type 00 class 0x088000
[    6.888288] pci 0000:7f:0c.4: [8086:0ee8] type 00 class 0x088000
[    6.892300] pci 0000:7f:0c.5: [8086:0eea] type 00 class 0x088000
[    6.896294] pci 0000:7f:0c.6: [8086:0eec] type 00 class 0x088000
[    6.900302] pci 0000:7f:0c.7: [8086:0eee] type 00 class 0x088000
[    6.904288] pci 0000:7f:0d.0: [8086:0ee1] type 00 class 0x088000
[    6.908329] pci 0000:7f:0d.1: [8086:0ee3] type 00 class 0x088000
[    6.912289] pci 0000:7f:0d.2: [8086:0ee5] type 00 class 0x088000
[    6.916331] pci 0000:7f:0d.3: [8086:0ee7] type 00 class 0x088000
[    6.920302] pci 0000:7f:0d.4: [8086:0ee9] type 00 class 0x088000
[    6.924332] pci 0000:7f:0d.5: [8086:0eeb] type 00 class 0x088000
[    6.928296] pci 0000:7f:0d.6: [8086:0eed] type 00 class 0x088000
[    6.932302] pci 0000:7f:0e.0: [8086:0ea0] type 00 class 0x088000
[    6.936297] pci 0000:7f:0e.1: [8086:0e30] type 00 class 0x110100
[    6.940334] pci 0000:7f:0f.0: [8086:0ea8] type 00 class 0x088000
[    6.944340] pci 0000:7f:0f.1: [8086:0e71] type 00 class 0x088000
[    6.948335] pci 0000:7f:0f.2: [8086:0eaa] type 00 class 0x088000
[    6.952379] pci 0000:7f:0f.3: [8086:0eab] type 00 class 0x088000
[    6.956331] pci 0000:7f:0f.4: [8086:0eac] type 00 class 0x088000
[    6.960383] pci 0000:7f:0f.5: [8086:0ead] type 00 class 0x088000
[    6.964337] pci 0000:7f:10.0: [8086:0eb0] type 00 class 0x088000
[    6.968379] pci 0000:7f:10.1: [8086:0eb1] type 00 class 0x088000
[    6.972331] pci 0000:7f:10.2: [8086:0eb2] type 00 class 0x088000
[    6.976379] pci 0000:7f:10.3: [8086:0eb3] type 00 class 0x088000
[    6.980334] pci 0000:7f:10.4: [8086:0eb4] type 00 class 0x088000
[    6.984380] pci 0000:7f:10.5: [8086:0eb5] type 00 class 0x088000
[    6.988336] pci 0000:7f:10.6: [8086:0eb6] type 00 class 0x088000
[    6.992420] pci 0000:7f:10.7: [8086:0eb7] type 00 class 0x088000
[    6.996375] pci 0000:7f:11.0: [8086:0ef8] type 00 class 0x088000
[    7.000384] pci 0000:7f:13.0: [8086:0e1d] type 00 class 0x088000
[    7.004290] pci 0000:7f:13.1: [8086:0e34] type 00 class 0x110100
[    7.008327] pci 0000:7f:13.4: [8086:0e81] type 00 class 0x088000
[    7.012290] pci 0000:7f:13.5: [8086:0e36] type 00 class 0x110100
[    7.016336] pci 0000:7f:13.6: [8086:0e37] type 00 class 0x110100
[    7.020291] pci 0000:7f:16.0: [8086:0ec8] type 00 class 0x088000
[    7.024342] pci 0000:7f:16.1: [8086:0ec9] type 00 class 0x088000
[    7.028291] pci 0000:7f:16.2: [8086:0eca] type 00 class 0x088000
[    7.032336] pci 0000:7f:18.0: [8086:0e40] type 00 class 0x088000
[    7.036293] pci 0000:7f:18.2: [8086:0e3a] type 00 class 0x110100
[    7.040337] pci 0000:7f:18.3: [8086:0e43] type 00 class 0x088000
[    7.044331] pci 0000:7f:18.4: [8086:0e44] type 00 class 0x088000
[    7.048379] pci 0000:7f:1c.0: [8086:0e60] type 00 class 0x088000
[    7.052297] pci 0000:7f:1c.1: [8086:0e38] type 00 class 0x110100
[    7.056369] pci 0000:7f:1d.0: [8086:0e68] type 00 class 0x088000
[    7.060339] pci 0000:7f:1d.1: [8086:0e79] type 00 class 0x088000
[    7.064382] pci 0000:7f:1d.2: [8086:0e6a] type 00 class 0x088000
[    7.068334] pci 0000:7f:1d.3: [8086:0e6b] type 00 class 0x088000
[    7.072409] pci 0000:7f:1d.4: [8086:0e6c] type 00 class 0x088000
[    7.076338] pci 0000:7f:1d.5: [8086:0e6d] type 00 class 0x088000
[    7.080332] pci 0000:7f:1e.0: [8086:0ef0] type 00 class 0x088000
[    7.084370] pci 0000:7f:1e.1: [8086:0ef1] type 00 class 0x088000
[    7.088339] pci 0000:7f:1e.2: [8086:0ef2] type 00 class 0x088000
[    7.092348] pci 0000:7f:1e.3: [8086:0ef3] type 00 class 0x088000
[    7.096333] pci 0000:7f:1e.4: [8086:0ef4] type 00 class 0x088000
[    7.100374] pci 0000:7f:1e.5: [8086:0ef5] type 00 class 0x088000
[    7.104333] pci 0000:7f:1e.6: [8086:0ef6] type 00 class 0x088000
[    7.108371] pci 0000:7f:1e.7: [8086:0ef7] type 00 class 0x088000
[    7.112310] pci 0000:7f:1f.0: [8086:0ed8] type 00 class 0x088000
[    7.116374] pci 0000:7f:1f.1: [8086:0ed9] type 00 class 0x088000
[    7.120338] pci 0000:7f:1f.4: [8086:0edc] type 00 class 0x088000
[    7.124372] pci 0000:7f:1f.5: [8086:0edd] type 00 class 0x088000
[    7.128330] pci 0000:7f:1f.6: [8086:0ede] type 00 class 0x088000
[    7.132340] pci 0000:7f:1f.7: [8086:0edf] type 00 class 0x088000
[    7.136332] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus 3f])
[    7.140086] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    7.144084] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    7.148261] PCI host bridge to bus 0000:3f
[    7.152081] pci_bus 0000:3f: root bus resource [bus 3f]
[    7.156116] pci 0000:3f:08.0: [8086:0e80] type 00 class 0x088000
[    7.160289] pci 0000:3f:08.2: [8086:0e32] type 00 class 0x110100
[    7.164303] pci 0000:3f:08.3: [8086:0e83] type 00 class 0x088000
[    7.168303] pci 0000:3f:08.4: [8086:0e84] type 00 class 0x088000
[    7.172412] pci 0000:3f:09.0: [8086:0e90] type 00 class 0x088000
[    7.176288] pci 0000:3f:09.2: [8086:0e33] type 00 class 0x110100
[    7.180300] pci 0000:3f:09.3: [8086:0e93] type 00 class 0x088000
[    7.184301] pci 0000:3f:09.4: [8086:0e94] type 00 class 0x088000
[    7.188374] pci 0000:3f:0a.0: [8086:0ec0] type 00 class 0x088000
[    7.192295] pci 0000:3f:0a.1: [8086:0ec1] type 00 class 0x088000
[    7.196326] pci 0000:3f:0a.2: [8086:0ec2] type 00 class 0x088000
[    7.200285] pci 0000:3f:0a.3: [8086:0ec3] type 00 class 0x088000
[    7.204331] pci 0000:3f:0b.0: [8086:0e1e] type 00 class 0x088000
[    7.208255] pci 0000:3f:0b.3: [8086:0e1f] type 00 class 0x088000
[    7.212302] pci 0000:3f:0c.0: [8086:0ee0] type 00 class 0x088000
[    7.216261] pci 0000:3f:0c.1: [8086:0ee2] type 00 class 0x088000
[    7.220289] pci 0000:3f:0c.2: [8086:0ee4] type 00 class 0x088000
[    7.224286] pci 0000:3f:0c.3: [8086:0ee6] type 00 class 0x088000
[    7.228294] pci 0000:3f:0c.4: [8086:0ee8] type 00 class 0x088000
[    7.232290] pci 0000:3f:0c.5: [8086:0eea] type 00 class 0x088000
[    7.236289] pci 0000:3f:0c.6: [8086:0eec] type 00 class 0x088000
[    7.240302] pci 0000:3f:0c.7: [8086:0eee] type 00 class 0x088000
[    7.244284] pci 0000:3f:0d.0: [8086:0ee1] type 00 class 0x088000
[    7.248295] pci 0000:3f:0d.1: [8086:0ee3] type 00 class 0x088000
[    7.252284] pci 0000:3f:0d.2: [8086:0ee5] type 00 class 0x088000
[    7.256334] pci 0000:3f:0d.3: [8086:0ee7] type 00 class 0x088000
[    7.260290] pci 0000:3f:0d.4: [8086:0ee9] type 00 class 0x088000
[    7.264328] pci 0000:3f:0d.5: [8086:0eeb] type 00 class 0x088000
[    7.268289] pci 0000:3f:0d.6: [8086:0eed] type 00 class 0x088000
[    7.272326] pci 0000:3f:0e.0: [8086:0ea0] type 00 class 0x088000
[    7.276292] pci 0000:3f:0e.1: [8086:0e30] type 00 class 0x110100
[    7.280302] pci 0000:3f:0f.0: [8086:0ea8] type 00 class 0x088000
[    7.284328] pci 0000:3f:0f.1: [8086:0e71] type 00 class 0x088000
[    7.288368] pci 0000:3f:0f.2: [8086:0eaa] type 00 class 0x088000
[    7.292327] pci 0000:3f:0f.3: [8086:0eab] type 00 class 0x088000
[    7.296342] pci 0000:3f:0f.4: [8086:0eac] type 00 class 0x088000
[    7.300331] pci 0000:3f:0f.5: [8086:0ead] type 00 class 0x088000
[    7.304335] pci 0000:3f:10.0: [8086:0eb0] type 00 class 0x088000
[    7.308326] pci 0000:3f:10.1: [8086:0eb1] type 00 class 0x088000
[    7.312341] pci 0000:3f:10.2: [8086:0eb2] type 00 class 0x088000
[    7.316330] pci 0000:3f:10.3: [8086:0eb3] type 00 class 0x088000
[    7.320340] pci 0000:3f:10.4: [8086:0eb4] type 00 class 0x088000
[    7.324331] pci 0000:3f:10.5: [8086:0eb5] type 00 class 0x088000
[    7.328341] pci 0000:3f:10.6: [8086:0eb6] type 00 class 0x088000
[    7.332336] pci 0000:3f:10.7: [8086:0eb7] type 00 class 0x088000
[    7.336343] pci 0000:3f:11.0: [8086:0ef8] type 00 class 0x088000
[    7.340344] pci 0000:3f:13.0: [8086:0e1d] type 00 class 0x088000
[    7.344300] pci 0000:3f:13.1: [8086:0e34] type 00 class 0x110100
[    7.348288] pci 0000:3f:13.4: [8086:0e81] type 00 class 0x088000
[    7.352299] pci 0000:3f:13.5: [8086:0e36] type 00 class 0x110100
[    7.356290] pci 0000:3f:13.6: [8086:0e37] type 00 class 0x110100
[    7.360300] pci 0000:3f:16.0: [8086:0ec8] type 00 class 0x088000
[    7.364295] pci 0000:3f:16.1: [8086:0ec9] type 00 class 0x088000
[    7.368285] pci 0000:3f:16.2: [8086:0eca] type 00 class 0x088000
[    7.372327] pci 0000:3f:18.0: [8086:0e40] type 00 class 0x088000
[    7.376287] pci 0000:3f:18.2: [8086:0e3a] type 00 class 0x110100
[    7.380298] pci 0000:3f:18.3: [8086:0e43] type 00 class 0x088000
[    7.384302] pci 0000:3f:18.4: [8086:0e44] type 00 class 0x088000
[    7.388344] pci 0000:3f:1c.0: [8086:0e60] type 00 class 0x088000
[    7.392293] pci 0000:3f:1c.1: [8086:0e38] type 00 class 0x110100
[    7.396336] pci 0000:3f:1d.0: [8086:0e68] type 00 class 0x088000
[    7.400333] pci 0000:3f:1d.1: [8086:0e79] type 00 class 0x088000
[    7.404343] pci 0000:3f:1d.2: [8086:0e6a] type 00 class 0x088000
[    7.408330] pci 0000:3f:1d.3: [8086:0e6b] type 00 class 0x088000
[    7.412344] pci 0000:3f:1d.4: [8086:0e6c] type 00 class 0x088000
[    7.416331] pci 0000:3f:1d.5: [8086:0e6d] type 00 class 0x088000
[    7.420343] pci 0000:3f:1e.0: [8086:0ef0] type 00 class 0x088000
[    7.424331] pci 0000:3f:1e.1: [8086:0ef1] type 00 class 0x088000
[    7.428373] pci 0000:3f:1e.2: [8086:0ef2] type 00 class 0x088000
[    7.432331] pci 0000:3f:1e.3: [8086:0ef3] type 00 class 0x088000
[    7.436344] pci 0000:3f:1e.4: [8086:0ef4] type 00 class 0x088000
[    7.440330] pci 0000:3f:1e.5: [8086:0ef5] type 00 class 0x088000
[    7.444341] pci 0000:3f:1e.6: [8086:0ef6] type 00 class 0x088000
[    7.448369] pci 0000:3f:1e.7: [8086:0ef7] type 00 class 0x088000
[    7.452343] pci 0000:3f:1f.0: [8086:0ed8] type 00 class 0x088000
[    7.456329] pci 0000:3f:1f.1: [8086:0ed9] type 00 class 0x088000
[    7.460345] pci 0000:3f:1f.4: [8086:0edc] type 00 class 0x088000
[    7.464326] pci 0000:3f:1f.5: [8086:0edd] type 00 class 0x088000
[    7.468342] pci 0000:3f:1f.6: [8086:0ede] type 00 class 0x088000
[    7.472332] pci 0000:3f:1f.7: [8086:0edf] type 00 class 0x088000
[    7.602736] ACPI: PCI Root Bridge [IIO0] (domain 0000 [bus 00-3e])
[    7.608035] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    7.620430] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug]
[    7.628382] acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapability]
[    7.641427] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    7.657103] PCI host bridge to bus 0000:00
[    7.664009] pci_bus 0000:00: root bus resource [bus 00-3e]
[    7.672005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    7.676004] pci_bus 0000:00: root bus resource [io  0x1000-0x3fff]
[    7.684004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    7.696004] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    7.704004] pci_bus 0000:00: root bus resource [mem 0x90000000-0xabffbfff]
[    7.712004] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x381fffffffff]
[    7.720042] pci 0000:00:00.0: [8086:0e00] type 00 class 0x060000
[    7.728180] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    7.740163] pci 0000:00:02.0: [8086:0e04] type 01 class 0x060400
[    7.744246] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    7.752259] pci 0000:00:02.0: System wakeup disabled by ACPI
[    7.760204] pci 0000:00:03.0: [8086:0e08] type 01 class 0x060400
[    7.768216] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    7.776254] pci 0000:00:03.0: System wakeup disabled by ACPI
[    7.784217] pci 0000:00:03.2: [8086:0e0a] type 01 class 0x060400
[    7.792222] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    7.800256] pci 0000:00:03.2: System wakeup disabled by ACPI
[    7.808173] pci 0000:00:03.3: [8086:0e0b] type 01 class 0x060400
[    7.816218] pci 0000:00:03.3: PME# supported from D0 D3hot D3cold
[    7.824255] pci 0000:00:03.3: System wakeup disabled by ACPI
[    7.832137] pci 0000:00:05.0: [8086:0e28] type 00 class 0x088000
[    7.840512] pci 0000:00:05.1: [8086:0e29] type 00 class 0x088000
[    7.848546] pci 0000:00:05.2: [8086:0e2a] type 00 class 0x088000
[    7.856512] pci 0000:00:05.4: [8086:0e2c] type 00 class 0x080020
[    7.864041] pci 0000:00:05.4: reg 0x10: [mem 0x93406000-0x93406fff]
[    7.872534] pci 0000:00:11.0: [8086:1d3e] type 01 class 0x060400
[    7.880266] pci 0000:00:11.0: PME# supported from D0 D3hot D3cold
[    7.888419] pci 0000:00:1a.0: [8086:1d2d] type 00 class 0x0c0320
[    7.896054] pci 0000:00:1a.0: reg 0x10: [mem 0x93402000-0x934023ff]
[    7.904278] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    7.916087] pci 0000:00:1c.0: [8086:1d10] type 01 class 0x060400
[    7.920300] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    7.928261] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    7.936138] pci 0000:00:1c.7: [8086:1d1e] type 01 class 0x060400
[    7.944223] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    7.952253] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    7.960178] pci 0000:00:1d.0: [8086:1d26] type 00 class 0x0c0320
[    7.968053] pci 0000:00:1d.0: reg 0x10: [mem 0x93401000-0x934013ff]
[    7.976278] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    7.984389] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    7.992374] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    8.000137] pci 0000:00:1f.0: [8086:1d41] type 00 class 0x060100
[    8.008640] pci 0000:00:1f.2: [8086:1d02] type 00 class 0x010601
[    8.016052] pci 0000:00:1f.2: reg 0x10: [io  0x2058-0x205f]
[    8.024035] pci 0000:00:1f.2: reg 0x14: [io  0x207c-0x207f]
[    8.032034] pci 0000:00:1f.2: reg 0x18: [io  0x2040-0x2047]
[    8.040035] pci 0000:00:1f.2: reg 0x1c: [io  0x2048-0x204b]
[    8.048012] pci 0000:00:1f.2: reg 0x20: [io  0x2020-0x203f]
[    8.052035] pci 0000:00:1f.2: reg 0x24: [mem 0x93400000-0x934007ff]
[    8.060136] pci 0000:00:1f.2: PME# supported from D3hot
[    8.068415] pci 0000:00:1f.3: [8086:1d22] type 00 class 0x0c0500
[    8.076047] pci 0000:00:1f.3: reg 0x10: [mem 0x381ffff00000-0x381ffff000ff 64bit]
[    8.088075] pci 0000:00:1f.3: reg 0x20: [io  0x2000-0x201f]
[    8.096632] acpiphp: Slot [8] registered
[    8.100169] pci 0000:01:00.0: [1000:0087] type 00 class 0x010700
[    8.108038] pci 0000:01:00.0: reg 0x10: [io  0x1000-0x10ff]
[    8.116037] pci 0000:01:00.0: reg 0x14: [mem 0x93340000-0x9334ffff 64bit]
[    8.124037] pci 0000:01:00.0: reg 0x1c: [mem 0x93300000-0x9333ffff 64bit]
[    8.132040] pci 0000:01:00.0: reg 0x30: [mem 0xfff00000-0xffffffff pref]
[    8.140123] pci 0000:01:00.0: supports D1 D2
[    8.148208] pci 0000:00:02.0: PCI bridge to [bus 01]
[    8.156030] pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
[    8.160006] pci 0000:00:02.0:   bridge window [mem 0x93300000-0x933fffff]
[    8.172009] pci 0000:00:02.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[    8.180546] acpiphp: Slot [2] registered
[    8.188128] pci 0000:00:03.0: PCI bridge to [bus 02]
[    8.196557] acpiphp: Slot [1] registered
[    8.200209] pci 0000:03:00.0: [8086:1528] type 00 class 0x020000
[    8.208044] pci 0000:03:00.0: reg 0x10: [mem 0x92c00000-0x92dfffff 64bit pref]
[    8.216054] pci 0000:03:00.0: reg 0x20: [mem 0x92e04000-0x92e07fff 64bit pref]
[    8.228012] pci 0000:03:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[    8.236131] pci 0000:03:00.0: PME# supported from D0 D3hot
[    8.244082] pci 0000:03:00.0: reg 0x184: [mem 0x93100000-0x93103fff 64bit]
[    8.252041] pci 0000:03:00.0: reg 0x190: [mem 0x93200000-0x93203fff 64bit]
[    8.260257] pci 0000:03:00.1: [8086:1528] type 00 class 0x020000
[    8.268044] pci 0000:03:00.1: reg 0x10: [mem 0x92a00000-0x92bfffff 64bit pref]
[    8.280077] pci 0000:03:00.1: reg 0x20: [mem 0x92e00000-0x92e03fff 64bit pref]
[    8.288034] pci 0000:03:00.1: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[    8.296130] pci 0000:03:00.1: PME# supported from D0 D3hot
[    8.304080] pci 0000:03:00.1: reg 0x184: [mem 0x92f00000-0x92f03fff 64bit]
[    8.312041] pci 0000:03:00.1: reg 0x190: [mem 0x93000000-0x93003fff 64bit]
[    8.332043] pci 0000:00:03.2: PCI bridge to [bus 03-04]
[    8.340080] pci 0000:00:03.2:   bridge window [mem 0x92f00000-0x932fffff]
[    8.348032] pci 0000:00:03.2:   bridge window [mem 0x92a00000-0x92efffff 64bit pref]
[    8.360599] acpiphp: Slot [0] registered
[    8.364126] pci 0000:00:03.3: PCI bridge to [bus 05]
[    8.372295] pci 0000:00:11.0: PCI bridge to [bus 06]
[    8.380322] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    8.388287] pci 0000:08:00.0: [102b:0522] type 00 class 0x030000
[    8.396081] pci 0000:08:00.0: reg 0x10: [mem 0x91000000-0x91ffffff pref]
[    8.404045] pci 0000:08:00.0: reg 0x14: [mem 0x92800000-0x92803fff]
[    8.412044] pci 0000:08:00.0: reg 0x18: [mem 0x92000000-0x927fffff]
[    8.420141] pci 0000:08:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    8.428476] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    8.436034] pci 0000:00:1c.7:   bridge window [mem 0x92000000-0x928fffff]
[    8.464033] pci 0000:00:1c.7:   bridge window [mem 0x91000000-0x91ffffff 64bit pref]
[    8.472133] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
[    8.484038] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    8.492004] pci 0000:00:1e.0:   bridge window [io  0x1000-0x3fff] (subtractive decode)
[    8.504004] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    8.516004] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    8.528004] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xabffbfff] (subtractive decode)
[    8.536004] pci 0000:00:1e.0:   bridge window [mem 0x380000000000-0x381fffffffff] (subtractive decode)
[    8.548129] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    8.560519] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.576179] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.588173] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.600172] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.616172] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.628171] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.644172] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.656171] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    8.672554] ACPI: PCI Root Bridge [IIO1] (domain 0000 [bus 40-7e])
[    8.680009] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    8.692009] acpi PNP0A08:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    8.700544] PCI host bridge to bus 0000:40
[    8.704007] pci_bus 0000:40: root bus resource [bus 40-7e]
[    8.712005] pci_bus 0000:40: root bus resource [io  0x4000-0x7fff]
[    8.720004] pci_bus 0000:40: root bus resource [mem 0xac000000-0xc7ffbfff]
[    8.728027] pci_bus 0000:40: root bus resource [mem 0x382000000000-0x383fffffffff]
[    8.740048] pci 0000:40:02.0: [8086:0e04] type 01 class 0x060400
[    8.748252] pci 0000:40:02.0: PME# supported from D0 D3hot D3cold
[    8.756171] pci 0000:40:02.0: System wakeup disabled by ACPI
[    8.764171] pci 0000:40:02.2: [8086:0e06] type 01 class 0x060400
[    8.772252] pci 0000:40:02.2: PME# supported from D0 D3hot D3cold
[    8.780169] pci 0000:40:02.2: System wakeup disabled by ACPI
[    8.788180] pci 0000:40:03.0: [8086:0e08] type 01 class 0x060400
[    8.796222] pci 0000:40:03.0: PME# supported from D0 D3hot D3cold
[    8.804206] pci 0000:40:03.0: System wakeup disabled by ACPI
[    8.808194] pci 0000:40:05.0: [8086:0e28] type 00 class 0x088000
[    8.820082] pci 0000:40:05.1: [8086:0e29] type 00 class 0x088000
[    8.828129] pci 0000:40:05.2: [8086:0e2a] type 00 class 0x088000
[    8.836600] pci 0000:40:05.4: [8086:0e2c] type 00 class 0x080020
[    8.844043] pci 0000:40:05.4: reg 0x10: [mem 0xac000000-0xac000fff]
[    8.852716] acpiphp: Slot [5] registered
[    8.860161] pci 0000:40:02.0: PCI bridge to [bus 41]
[    8.864031] pci 0000:40:02.0:   bridge window [io  0x4000-0x4fff]
[    8.872007] pci 0000:40:02.0:   bridge window [mem 0xac100000-0xac2fffff]
[    8.880012] pci 0000:40:02.0:   bridge window [mem 0xac300000-0xac4fffff 64bit pref]
[    8.892558] acpiphp: Slot [7] registered
[    8.896136] pci 0000:40:02.2: PCI bridge to [bus 42]
[    8.904008] pci 0000:40:02.2:   bridge window [io  0x5000-0x5fff]
[    8.912006] pci 0000:40:02.2:   bridge window [mem 0xac500000-0xac6fffff]
[    8.920009] pci 0000:40:02.2:   bridge window [mem 0xac700000-0xac8fffff 64bit pref]
[    8.932578] acpiphp: Slot [6] registered
[    8.936166] pci 0000:40:03.0: PCI bridge to [bus 43]
[    8.944465] ACPI: PCI Root Bridge [IIO2] (domain 0000 [bus 80-be])
[    8.952036] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    8.964033] acpi PNP0A08:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    8.972111] acpi PNP0A08:02: ignoring host bridge window [io  0x4558-0xffff] (conflicts with PCI Bus 0000:40 [io  0x4000-0x7fff])
[    8.988580] PCI host bridge to bus 0000:80
[    8.992031] pci_bus 0000:80: root bus resource [bus 80-be]
[    9.000005] pci_bus 0000:80: root bus resource [mem 0xc8000000-0xe3ffbfff]
[    9.008004] pci_bus 0000:80: root bus resource [mem 0x384000000000-0x385fffffffff]
[    9.020073] pci 0000:80:02.0: [8086:0e04] type 01 class 0x060400
[    9.028277] pci 0000:80:02.0: PME# supported from D0 D3hot D3cold
[    9.036174] pci 0000:80:02.0: System wakeup disabled by ACPI
[    9.044209] pci 0000:80:02.2: [8086:0e06] type 01 class 0x060400
[    9.052254] pci 0000:80:02.2: PME# supported from D0 D3hot D3cold
[    9.060172] pci 0000:80:02.2: System wakeup disabled by ACPI
[    9.068079] pci 0000:80:03.0: [8086:0e08] type 01 class 0x060400
[    9.072248] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    9.080194] pci 0000:80:03.0: System wakeup disabled by ACPI
[    9.088210] pci 0000:80:05.0: [8086:0e28] type 00 class 0x088000
[    9.096533] pci 0000:80:05.1: [8086:0e29] type 00 class 0x088000
[    9.108082] pci 0000:80:05.2: [8086:0e2a] type 00 class 0x088000
[    9.116082] pci 0000:80:05.4: [8086:0e2c] type 00 class 0x080020
[    9.124043] pci 0000:80:05.4: reg 0x10: [mem 0xc8000000-0xc8000fff]
[    9.132674] acpiphp: Slot [4] registered
[    9.136165] pci 0000:80:02.0: PCI bridge to [bus 81]
[    9.144601] acpiphp: Slot [3] registered
[    9.152133] pci 0000:80:02.2: PCI bridge to [bus 82]
[    9.156579] acpiphp: Slot [9] registered
[    9.164133] pci 0000:80:03.0: PCI bridge to [bus 83]
[    9.168457] ACPI: PCI Root Bridge [IIO3] (domain 0000 [bus c0-fe])
[    9.180009] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    9.188032] acpi PNP0A08:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    9.196580] PCI host bridge to bus 0000:c0
[    9.204008] pci_bus 0000:c0: root bus resource [bus c0-fe]
[    9.212005] pci_bus 0000:c0: root bus resource [io  0xc000-0xffff]
[    9.220004] pci_bus 0000:c0: root bus resource [mem 0xe4000000-0xfbffbfff]
[    9.228004] pci_bus 0000:c0: root bus resource [mem 0x386000000000-0x387fffffffff]
[    9.236048] pci 0000:c0:02.0: [8086:0e04] type 01 class 0x060400
[    9.244253] pci 0000:c0:02.0: PME# supported from D0 D3hot D3cold
[    9.252173] pci 0000:c0:02.0: System wakeup disabled by ACPI
[    9.260178] pci 0000:c0:02.2: [8086:0e06] type 01 class 0x060400
[    9.268255] pci 0000:c0:02.2: PME# supported from D0 D3hot D3cold
[    9.276174] pci 0000:c0:02.2: System wakeup disabled by ACPI
[    9.284164] pci 0000:c0:03.0: [8086:0e08] type 01 class 0x060400
[    9.292248] pci 0000:c0:03.0: PME# supported from D0 D3hot D3cold
[    9.300169] pci 0000:c0:03.0: System wakeup disabled by ACPI
[    9.308201] pci 0000:c0:05.0: [8086:0e28] type 00 class 0x088000
[    9.316425] pci 0000:c0:05.1: [8086:0e29] type 00 class 0x088000
[    9.324510] pci 0000:c0:05.2: [8086:0e2a] type 00 class 0x088000
[    9.332420] pci 0000:c0:05.4: [8086:0e2c] type 00 class 0x080020
[    9.340045] pci 0000:c0:05.4: reg 0x10: [mem 0xe4000000-0xe4000fff]
[    9.352081] acpiphp: Slot [12] registered
[    9.356159] pci 0000:c0:02.0: PCI bridge to [bus c1]
[    9.364008] pci 0000:c0:02.0:   bridge window [io  0xc000-0xcfff]
[    9.372007] pci 0000:c0:02.0:   bridge window [mem 0xe4100000-0xe42fffff]
[    9.380009] pci 0000:c0:02.0:   bridge window [mem 0xe4300000-0xe44fffff 64bit pref]
[    9.392081] acpiphp: Slot [10] registered
[    9.396164] pci 0000:c0:02.2: PCI bridge to [bus c2]
[    9.404030] pci 0000:c0:02.2:   bridge window [io  0xd000-0xdfff]
[    9.412006] pci 0000:c0:02.2:   bridge window [mem 0xe4500000-0xe46fffff]
[    9.420009] pci 0000:c0:02.2:   bridge window [mem 0xe4700000-0xe48fffff 64bit pref]
[    9.432053] acpiphp: Slot [11] registered
[    9.436131] pci 0000:c0:03.0: PCI bridge to [bus c3]
[    9.444505] ACPI: Enabled 3 GPEs in block 00 to 3F
[    9.452546] vgaarb: device added: PCI:0000:08:00.0,decodes=io+mem,owns=io+mem,locks=none
[    9.464044] vgaarb: loaded
[    9.468004] vgaarb: bridge control possible 0000:08:00.0
[    9.476131] SCSI subsystem initialized
[    9.481076] libata version 3.00 loaded.
[    9.488168] ACPI: bus type USB registered
[    9.492115] usbcore: registered new interface driver usbfs
[    9.500088] usbcore: registered new interface driver hub
[    9.508133] usbcore: registered new device driver usb
[    9.516115] pps_core: LinuxPPS API ver. 1 registered
[    9.524004] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    9.536083] PTP clock support registered
[    9.544025] EDAC MC: Ver: 3.0.0
[    9.549788] PCI: Using ACPI for IRQ routing
[    9.568642] PCI: pci_cache_line_size set to 64 bytes
[    9.577891] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    9.584005] e820: reserve RAM buffer [mem 0x650a0000-0x67ffffff]
[    9.592004] e820: reserve RAM buffer [mem 0x65a6b000-0x67ffffff]
[    9.600027] e820: reserve RAM buffer [mem 0x65df8000-0x67ffffff]
[    9.608004] e820: reserve RAM buffer [mem 0x7abcf000-0x7bffffff]
[    9.616004] e820: reserve RAM buffer [mem 0x7b800000-0x7bffffff]
[    9.626419] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    9.636004] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    9.646839] Switched to clocksource hpet
[    9.710781] pnp: PnP ACPI init
[    9.715462] ACPI: bus type PNP registered
[    9.767055] pnp 00:00: Plug and Play ACPI device, IDs PNP0c80 (active)
[    9.820314] pnp 00:01: Plug and Play ACPI device, IDs PNP0c80 (active)
[    9.873561] pnp 00:02: Plug and Play ACPI device, IDs PNP0c80 (active)
[    9.926801] pnp 00:03: Plug and Play ACPI device, IDs PNP0c80 (active)
[    9.935937] pnp 00:04: Plug and Play ACPI device, IDs PNP0003 (active)
[    9.945354] pnp 00:05: [dma 4]
[    9.950147] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    9.958560] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:0)
[    9.969642] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    9.978052] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:0)
[   10.009726] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[   10.018391] pnp 00:08: Plug and Play ACPI device, IDs PNP0800 (active)
[   10.027229] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[   10.036884] system 00:0a: [io  0x0500-0x053f] has been reserved
[   10.044539] system 00:0a: [io  0x0400-0x047f] could not be reserved
[   10.052595] system 00:0a: [io  0x0540-0x057f] has been reserved
[   10.060214] system 00:0a: [io  0x0600-0x061f] has been reserved
[   10.067857] system 00:0a: [io  0x0ca0-0x0ca5] has been reserved
[   10.075502] system 00:0a: [io  0x0880-0x0883] has been reserved
[   10.083152] system 00:0a: [io  0x0800-0x081f] has been reserved
[   10.090801] system 00:0a: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[   10.099628] system 00:0a: [mem 0xfed45000-0xfed8bfff] has been reserved
[   10.108074] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[   10.116896] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[   10.125337] system 00:0a: [mem 0xfed12000-0xfed1200f] has been reserved
[   10.133779] system 00:0a: [mem 0xfed12010-0xfed1201f] has been reserved
[   10.142223] system 00:0a: [mem 0xfed1b000-0xfed1bfff] has been reserved
[   10.150673] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[   10.159746] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:0)
[   10.170919] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[   10.179641] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:0)
[   10.190803] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[   10.199682] pnp 00:0d: Plug and Play ACPI device, IDs IPI0001 (active)
[   10.209986] pnp: PnP ACPI: found 14 devices
[   10.215693] ACPI: bus type PNP unregistered
[   10.248442] pci 0000:01:00.0: no compatible bridge window for [mem 0xfff00000-0xffffffff pref]
[   10.259938] pci 0000:03:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
[   10.271433] pci 0000:03:00.1: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
[   10.282928] pci 0000:08:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[   10.295089] pci 0000:01:00.0: BAR 6: assigned [mem 0x90000000-0x900fffff pref]
[   10.305029] pci 0000:00:02.0: PCI bridge to [bus 01]
[   10.311614] pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
[   10.319492] pci 0000:00:02.0:   bridge window [mem 0x93300000-0x933fffff]
[   10.328105] pci 0000:00:02.0:   bridge window [mem 0x90000000-0x900fffff 64bit pref]
[   10.338659] pci 0000:00:03.0: PCI bridge to [bus 02]
[   10.345258] pci 0000:03:00.0: BAR 6: assigned [mem 0x92e80000-0x92efffff pref]
[   10.355201] pci 0000:03:00.1: BAR 6: can't assign mem pref (size 0x80000)
[   10.363841] pci 0000:00:03.2: PCI bridge to [bus 03-04]
[   10.370722] pci 0000:00:03.2:   bridge window [mem 0x92f00000-0x932fffff]
[   10.379354] pci 0000:00:03.2:   bridge window [mem 0x92a00000-0x92efffff 64bit pref]
[   10.389915] pci 0000:00:03.3: PCI bridge to [bus 05]
[   10.396510] pci 0000:00:11.0: PCI bridge to [bus 06]
[   10.403102] pci 0000:00:1c.0: PCI bridge to [bus 07]
[   10.409736] pci 0000:08:00.0: BAR 6: assigned [mem 0x92810000-0x9281ffff pref]
[   10.419677] pci 0000:00:1c.7: PCI bridge to [bus 08]
[   10.426285] pci 0000:00:1c.7:   bridge window [mem 0x92000000-0x928fffff]
[   10.434904] pci 0000:00:1c.7:   bridge window [mem 0x91000000-0x91ffffff 64bit pref]
[   10.445422] pci 0000:00:1e.0: PCI bridge to [bus 09]
[   10.452047] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   10.459312] pci_bus 0000:00: resource 5 [io  0x1000-0x3fff]
[   10.466575] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   10.474626] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
[   10.482683] pci_bus 0000:00: resource 8 [mem 0x90000000-0xabffbfff]
[   10.490740] pci_bus 0000:00: resource 9 [mem 0x380000000000-0x381fffffffff]
[   10.499568] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[   10.506835] pci_bus 0000:01: resource 1 [mem 0x93300000-0x933fffff]
[   10.514888] pci_bus 0000:01: resource 2 [mem 0x90000000-0x900fffff 64bit pref]
[   10.524819] pci_bus 0000:03: resource 1 [mem 0x92f00000-0x932fffff]
[   10.532868] pci_bus 0000:03: resource 2 [mem 0x92a00000-0x92efffff 64bit pref]
[   10.542778] pci_bus 0000:08: resource 1 [mem 0x92000000-0x928fffff]
[   10.550834] pci_bus 0000:08: resource 2 [mem 0x91000000-0x91ffffff 64bit pref]
[   10.560762] pci_bus 0000:09: resource 4 [io  0x0000-0x0cf7]
[   10.568017] pci_bus 0000:09: resource 5 [io  0x1000-0x3fff]
[   10.575276] pci_bus 0000:09: resource 6 [mem 0x000a0000-0x000bffff]
[   10.583327] pci_bus 0000:09: resource 7 [mem 0xfed40000-0xfedfffff]
[   10.591356] pci_bus 0000:09: resource 8 [mem 0x90000000-0xabffbfff]
[   10.599406] pci_bus 0000:09: resource 9 [mem 0x380000000000-0x381fffffffff]
[   10.608304] pci 0000:40:02.0: PCI bridge to [bus 41]
[   10.614857] pci 0000:40:02.0:   bridge window [io  0x4000-0x4fff]
[   10.622714] pci 0000:40:02.0:   bridge window [mem 0xac100000-0xac2fffff]
[   10.631357] pci 0000:40:02.0:   bridge window [mem 0xac300000-0xac4fffff 64bit pref]
[   10.641913] pci 0000:40:02.2: PCI bridge to [bus 42]
[   10.648478] pci 0000:40:02.2:   bridge window [io  0x5000-0x5fff]
[   10.656327] pci 0000:40:02.2:   bridge window [mem 0xac500000-0xac6fffff]
[   10.664964] pci 0000:40:02.2:   bridge window [mem 0xac700000-0xac8fffff 64bit pref]
[   10.675517] pci 0000:40:03.0: PCI bridge to [bus 43]
[   10.682109] pci_bus 0000:40: resource 4 [io  0x4000-0x7fff]
[   10.689340] pci_bus 0000:40: resource 5 [mem 0xac000000-0xc7ffbfff]
[   10.697393] pci_bus 0000:40: resource 6 [mem 0x382000000000-0x383fffffffff]
[   10.706221] pci_bus 0000:41: resource 0 [io  0x4000-0x4fff]
[   10.713477] pci_bus 0000:41: resource 1 [mem 0xac100000-0xac2fffff]
[   10.721530] pci_bus 0000:41: resource 2 [mem 0xac300000-0xac4fffff 64bit pref]
[   10.731469] pci_bus 0000:42: resource 0 [io  0x5000-0x5fff]
[   10.738727] pci_bus 0000:42: resource 1 [mem 0xac500000-0xac6fffff]
[   10.746781] pci_bus 0000:42: resource 2 [mem 0xac700000-0xac8fffff 64bit pref]
[   10.756794] pci 0000:80:02.0: PCI bridge to [bus 81]
[   10.763381] pci 0000:80:02.2: PCI bridge to [bus 82]
[   10.769968] pci 0000:80:03.0: PCI bridge to [bus 83]
[   10.776555] pci_bus 0000:80: resource 4 [mem 0xc8000000-0xe3ffbfff]
[   10.784612] pci_bus 0000:80: resource 5 [mem 0x384000000000-0x385fffffffff]
[   10.793508] pci 0000:c0:02.0: PCI bridge to [bus c1]
[   10.800067] pci 0000:c0:02.0:   bridge window [io  0xc000-0xcfff]
[   10.807917] pci 0000:c0:02.0:   bridge window [mem 0xe4100000-0xe42fffff]
[   10.816551] pci 0000:c0:02.0:   bridge window [mem 0xe4300000-0xe44fffff 64bit pref]
[   10.827097] pci 0000:c0:02.2: PCI bridge to [bus c2]
[   10.833660] pci 0000:c0:02.2:   bridge window [io  0xd000-0xdfff]
[   10.841516] pci 0000:c0:02.2:   bridge window [mem 0xe4500000-0xe46fffff]
[   10.850157] pci 0000:c0:02.2:   bridge window [mem 0xe4700000-0xe48fffff 64bit pref]
[   10.860695] pci 0000:c0:03.0: PCI bridge to [bus c3]
[   10.867293] pci_bus 0000:c0: resource 4 [io  0xc000-0xffff]
[   10.874559] pci_bus 0000:c0: resource 5 [mem 0xe4000000-0xfbffbfff]
[   10.882613] pci_bus 0000:c0: resource 6 [mem 0x386000000000-0x387fffffffff]
[   10.891435] pci_bus 0000:c1: resource 0 [io  0xc000-0xcfff]
[   10.898694] pci_bus 0000:c1: resource 1 [mem 0xe4100000-0xe42fffff]
[   10.906740] pci_bus 0000:c1: resource 2 [mem 0xe4300000-0xe44fffff 64bit pref]
[   10.916677] pci_bus 0000:c2: resource 0 [io  0xd000-0xdfff]
[   10.923939] pci_bus 0000:c2: resource 1 [mem 0xe4500000-0xe46fffff]
[   10.931989] pci_bus 0000:c2: resource 2 [mem 0xe4700000-0xe48fffff 64bit pref]
[   10.942359] NET: Registered protocol family 2
[   10.950453] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[   10.964405] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   10.973719] TCP: Hash tables configured (established 524288 bind 65536)
[   10.982447] TCP: reno registered
[   10.987825] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
[   10.998101] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
[   11.010364] NET: Registered protocol family 1
[   11.017915] RPC: Registered named UNIX socket transport module.
[   11.025624] RPC: Registered udp transport module.
[   11.031928] RPC: Registered tcp transport module.
[   11.038336] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   11.100850] IOAPIC[0]: Set routing entry (8-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:0)
[   11.112812] IOAPIC[0]: Set routing entry (8-23 -> 0x51 -> IRQ 23 Mode:1 Active:1 Dest:0)
[   11.124340] pci 0000:08:00.0: Boot video device
[   11.130605] PCI: CLS 64 bytes, default 64
[   11.136477] Trying to unpack rootfs image as initramfs...
[   30.248735] Freeing initrd memory: 212960K (ffff88006dbd7000 - ffff88007abcf000)
[   30.258930] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   30.267233] software IO TLB [mem 0x69bd7000-0x6dbd7000] (64MB) mapped at [ffff880069bd7000-ffff88006dbd6fff]
[   30.330431] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[   30.344354] Scanning for low memory corruption every 60 seconds
[   30.356618] AVX version of gcm_enc/dec engaged.
[   30.366246] sha1_ssse3: Using AVX optimized SHA-1 implementation
[   30.416997] futex hash table entries: 65536 (order: 10, 4194304 bytes)
[   30.548276] bounce pool size: 64 pages
[   30.553548] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   30.580152] VFS: Disk quotas dquot_6.5.2
[   30.586363] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   30.604639] NFS: Registering the id_resolver key type
[   30.611424] Key type id_resolver registered
[   30.617153] Key type id_legacy registered
[   30.622755] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   30.631334] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   30.643242] ROMFS MTD (C) 2007 Red Hat, Inc.
[   30.649630] fuse init (API version 7.22)
[   30.656388] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   30.675495] msgmni has been set to 32768
[   30.696037] NET: Registered protocol family 38
[   30.702066] Key type asymmetric registered
[   30.708232] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   30.740010] io scheduler noop registered
[   30.745478] io scheduler deadline registered
[   30.751354] io scheduler cfq registered (default)
[   30.760915] IOAPIC[1]: Set routing entry (9-23 -> 0x61 -> IRQ 47 Mode:1 Active:1 Dest:0)
[   30.772144] pcieport 0000:00:02.0: irq 136 for MSI/MSI-X
[   30.780293] pcieport 0000:00:03.0: irq 137 for MSI/MSI-X
[   30.788431] pcieport 0000:00:03.2: irq 138 for MSI/MSI-X
[   30.796819] pcieport 0000:00:03.3: irq 139 for MSI/MSI-X
[   30.805040] IOAPIC[0]: Set routing entry (8-19 -> 0xb1 -> IRQ 19 Mode:1 Active:1 Dest:0)
[   30.816109] pcieport 0000:00:11.0: irq 140 for MSI/MSI-X
[   30.824365] pcieport 0000:00:1c.0: irq 141 for MSI/MSI-X
[   30.832469] pcieport 0000:00:1c.7: irq 142 for MSI/MSI-X
[   30.840354] IOAPIC[2]: Set routing entry (10-23 -> 0x22 -> IRQ 71 Mode:1 Active:1 Dest:0)
[   30.852754] IOAPIC[3]: Set routing entry (11-23 -> 0x42 -> IRQ 95 Mode:1 Active:1 Dest:0)
[   30.865124] IOAPIC[4]: Set routing entry (12-23 -> 0x52 -> IRQ 119 Mode:1 Active:1 Dest:0)
[   30.877536] aer 0000:00:02.0:pcie02: service driver aer loaded
[   30.885263] aer 0000:00:03.0:pcie02: service driver aer loaded
[   30.892978] aer 0000:00:03.2:pcie02: service driver aer loaded
[   30.900665] aer 0000:00:03.3:pcie02: service driver aer loaded
[   30.908389] aer 0000:00:11.0:pcie02: service driver aer loaded
[   30.916448] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[   30.925356] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[   30.933722] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[   30.942331] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   30.951228] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   30.959841] pcieport 0000:00:03.2: Signaling PME through PCIe PME interrupt
[   30.968735] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[   30.977109] pci 0000:03:00.1: Signaling PME through PCIe PME interrupt
[   30.985506] pcie_pme 0000:00:03.2:pcie01: service driver pcie_pme loaded
[   30.994116] pcieport 0000:00:03.3: Signaling PME through PCIe PME interrupt
[   31.003012] pcie_pme 0000:00:03.3:pcie01: service driver pcie_pme loaded
[   31.011630] pcieport 0000:00:11.0: Signaling PME through PCIe PME interrupt
[   31.020522] pcie_pme 0000:00:11.0:pcie01: service driver pcie_pme loaded
[   31.029146] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[   31.038040] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[   31.046695] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[   31.055588] pci 0000:08:00.0: Signaling PME through PCIe PME interrupt
[   31.063988] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[   31.072936] ioapic: probe of 0000:00:05.4 failed with error -22
[   31.080666] ioapic: probe of 0000:40:05.4 failed with error -22
[   31.088390] ioapic: probe of 0000:80:05.4 failed with error -22
[   31.096113] ioapic: probe of 0000:c0:05.4 failed with error -22
[   31.103969] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   31.111851] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   31.120327] intel_idle: MWAIT substates: 0x1120
[   31.126413] intel_idle: v0.4 model 0x3E
[   31.131714] intel_idle: lapic_timer_reliable_states 0xffffffff
[   31.158091] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[   31.169204] ACPI: Sleep Button [SLPB]
[   31.174797] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   31.184920] ACPI: Power Button [PWRF]
[   31.191961] GHES: HEST is not enabled!
[   31.198458] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   31.228310] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   31.260240] 00:0c: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   31.275440] Non-volatile memory driver v1.3
[   31.303274] brd: module loaded
[   31.317509] loop: module loaded
[   31.323437] lkdtm: No crash points registered, enable through debugfs
[   31.333121] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000428-0x000000000000042f (\GPE0) (20131218/utaddress-258)
[   31.353621] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   31.366848] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x000000000000052c-0x000000000000052d (\GPIV) (20131218/utaddress-258)
[   31.387244] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   31.400831] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   31.410309] Loading iSCSI transport class v2.0-870.
[   31.420831] Adaptec aacraid driver 1.2-0[30200]-ms
[   31.427798] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   31.437371] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.06.00.12-k.
[   31.449113] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   31.459687] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   31.469053] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[   31.477954] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   31.486336] RocketRAID 3xxx/4xxx Controller driver v1.8
[   31.495315] ahci 0000:00:1f.2: version 3.0
[   31.501563] ahci 0000:00:1f.2: irq 143 for MSI/MSI-X
[   31.524151] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x10 impl SATA mode
[   31.535182] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[   31.552104] scsi0 : ahci
[   31.557155] scsi1 : ahci
[   31.561823] scsi2 : ahci
[   31.566829] scsi3 : ahci
[   31.571724] scsi4 : ahci
[   31.576500] scsi5 : ahci
[   31.581025] ata1: DUMMY
[   31.584844] ata2: DUMMY
[   31.588632] ata3: DUMMY
[   31.592448] ata4: DUMMY
[   31.596300] ata5: SATA max UDMA/133 abar m2048@0x93400000 port 0x93400300 irq 143
[   31.606652] ata6: DUMMY
[   31.614119] tun: Universal TUN/TAP device driver, 1.6
[   31.620825] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   31.630108] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   31.639597] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   31.646731] Copyright (c) 2007 Atheros Corporation.
[   31.655402] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   31.664437] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   31.664437]   http://www.scyld.com/network/drivers.html
[   31.681138] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   31.690865] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   31.698784] e100: Copyright(c) 1999-2006 Intel Corporation
[   31.706713] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   31.715658] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   31.723727] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   31.731287] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   31.739713] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[   31.748618] igb: Copyright (c) 2007-2013 Intel Corporation.
[   31.756585] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   31.767119] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[   31.775102] IOAPIC[1]: Set routing entry (9-21 -> 0x72 -> IRQ 45 Mode:1 Active:1 Dest:0)
[   31.928214] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   31.938291] ata5.00: ATAPI: TEAC    DV-W28S-W, 1.0A, max UDMA/100
[   31.948285] ata5.00: configured for UDMA/100
[   31.955704] scsi 4:0:0:0: CD-ROM            TEAC     DV-W28S-W        1.0A PQ: 0 ANSI: 5
[   31.968250] scsi 4:0:0:0: Attached scsi generic sg0 type 5
[   32.204170] ixgbe 0000:03:00.0: irq 144 for MSI/MSI-X
[   32.211006] ixgbe 0000:03:00.0: irq 145 for MSI/MSI-X
[   32.217772] ixgbe 0000:03:00.0: irq 146 for MSI/MSI-X
[   32.224534] ixgbe 0000:03:00.0: irq 147 for MSI/MSI-X
[   32.231297] ixgbe 0000:03:00.0: irq 148 for MSI/MSI-X
[   32.238055] ixgbe 0000:03:00.0: irq 149 for MSI/MSI-X
[   32.244815] ixgbe 0000:03:00.0: irq 150 for MSI/MSI-X
[   32.251577] ixgbe 0000:03:00.0: irq 151 for MSI/MSI-X
[   32.258341] ixgbe 0000:03:00.0: irq 152 for MSI/MSI-X
[   32.265103] ixgbe 0000:03:00.0: irq 153 for MSI/MSI-X
[   32.271867] ixgbe 0000:03:00.0: irq 154 for MSI/MSI-X
[   32.278631] ixgbe 0000:03:00.0: irq 155 for MSI/MSI-X
[   32.285387] ixgbe 0000:03:00.0: irq 156 for MSI/MSI-X
[   32.292147] ixgbe 0000:03:00.0: irq 157 for MSI/MSI-X
[   32.298910] ixgbe 0000:03:00.0: irq 158 for MSI/MSI-X
[   32.305674] ixgbe 0000:03:00.0: irq 159 for MSI/MSI-X
[   32.312491] ixgbe 0000:03:00.0: irq 160 for MSI/MSI-X
[   32.319284] ixgbe 0000:03:00.0: irq 161 for MSI/MSI-X
[   32.326047] ixgbe 0000:03:00.0: irq 162 for MSI/MSI-X
[   32.332809] ixgbe 0000:03:00.0: irq 163 for MSI/MSI-X
[   32.339572] ixgbe 0000:03:00.0: irq 164 for MSI/MSI-X
[   32.346372] ixgbe 0000:03:00.0: irq 165 for MSI/MSI-X
[   32.353128] ixgbe 0000:03:00.0: irq 166 for MSI/MSI-X
[   32.359891] ixgbe 0000:03:00.0: irq 167 for MSI/MSI-X
[   32.366651] ixgbe 0000:03:00.0: irq 168 for MSI/MSI-X
[   32.373417] ixgbe 0000:03:00.0: irq 169 for MSI/MSI-X
[   32.380219] ixgbe 0000:03:00.0: irq 170 for MSI/MSI-X
[   32.386984] ixgbe 0000:03:00.0: irq 171 for MSI/MSI-X
[   32.393742] ixgbe 0000:03:00.0: irq 172 for MSI/MSI-X
[   32.400502] ixgbe 0000:03:00.0: irq 173 for MSI/MSI-X
[   32.407263] ixgbe 0000:03:00.0: irq 174 for MSI/MSI-X
[   32.414024] ixgbe 0000:03:00.0: irq 175 for MSI/MSI-X
[   32.420848] ixgbe 0000:03:00.0: irq 176 for MSI/MSI-X
[   32.427639] ixgbe 0000:03:00.0: irq 177 for MSI/MSI-X
[   32.434400] ixgbe 0000:03:00.0: irq 178 for MSI/MSI-X
[   32.441158] ixgbe 0000:03:00.0: irq 179 for MSI/MSI-X
[   32.447921] ixgbe 0000:03:00.0: irq 180 for MSI/MSI-X
[   32.454685] ixgbe 0000:03:00.0: irq 181 for MSI/MSI-X
[   32.461451] ixgbe 0000:03:00.0: irq 182 for MSI/MSI-X
[   32.468216] ixgbe 0000:03:00.0: irq 183 for MSI/MSI-X
[   32.474974] ixgbe 0000:03:00.0: irq 184 for MSI/MSI-X
[   32.481730] ixgbe 0000:03:00.0: irq 185 for MSI/MSI-X
[   32.508909] ixgbe 0000:03:00.0: irq 186 for MSI/MSI-X
[   32.515686] ixgbe 0000:03:00.0: irq 187 for MSI/MSI-X
[   32.522481] ixgbe 0000:03:00.0: irq 188 for MSI/MSI-X
[   32.529239] ixgbe 0000:03:00.0: irq 189 for MSI/MSI-X
[   32.535998] ixgbe 0000:03:00.0: irq 190 for MSI/MSI-X
[   32.542762] ixgbe 0000:03:00.0: irq 191 for MSI/MSI-X
[   32.549579] ixgbe 0000:03:00.0: irq 192 for MSI/MSI-X
[   32.556370] ixgbe 0000:03:00.0: irq 193 for MSI/MSI-X
[   32.563135] ixgbe 0000:03:00.0: irq 194 for MSI/MSI-X
[   32.569900] ixgbe 0000:03:00.0: irq 195 for MSI/MSI-X
[   32.576656] ixgbe 0000:03:00.0: irq 196 for MSI/MSI-X
[   32.583413] ixgbe 0000:03:00.0: irq 197 for MSI/MSI-X
[   32.590177] ixgbe 0000:03:00.0: irq 198 for MSI/MSI-X
[   32.597036] ixgbe 0000:03:00.0: irq 199 for MSI/MSI-X
[   32.603868] ixgbe 0000:03:00.0: irq 200 for MSI/MSI-X
[   32.610627] ixgbe 0000:03:00.0: irq 201 for MSI/MSI-X
[   32.617385] ixgbe 0000:03:00.0: irq 202 for MSI/MSI-X
[   32.624140] ixgbe 0000:03:00.0: irq 203 for MSI/MSI-X
[   32.630900] ixgbe 0000:03:00.0: irq 204 for MSI/MSI-X
[   32.637670] ixgbe 0000:03:00.0: irq 205 for MSI/MSI-X
[   32.644436] ixgbe 0000:03:00.0: irq 206 for MSI/MSI-X
[   32.651201] ixgbe 0000:03:00.0: irq 207 for MSI/MSI-X
[   32.658560] ixgbe 0000:03:00.0: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63
[   32.730558] ixgbe 0000:03:00.0: PCI Express bandwidth of 16GT/s available
[   32.739265] ixgbe 0000:03:00.0: (Speed:5.0GT/s, Width: x4, Encoding Loss:20%)
[   32.748343] ixgbe 0000:03:00.0: This is not sufficient for optimal performance of this card.
[   32.759663] ixgbe 0000:03:00.0: For optimal performance, at least 20GT/s of bandwidth is required.
[   32.771595] ixgbe 0000:03:00.0: A slot with more lanes and/or higher speed is suggested.
[   32.944036] ixgbe 0000:03:00.0: MAC: 3, PHY: 3, PBA No: G36748-004
[   32.952099] ixgbe 0000:03:00.0: a0:36:9f:0e:f0:c8
[   33.126399] ixgbe 0000:03:00.0: Intel(R) 10 Gigabit Network Connection
[   33.135148] IOAPIC[1]: Set routing entry (9-18 -> 0xc7 -> IRQ 42 Mode:1 Active:1 Dest:0)
[   33.563926] ixgbe 0000:03:00.1: irq 208 for MSI/MSI-X
[   33.570770] ixgbe 0000:03:00.1: irq 209 for MSI/MSI-X
[   33.577539] ixgbe 0000:03:00.1: irq 210 for MSI/MSI-X
[   33.584302] ixgbe 0000:03:00.1: irq 211 for MSI/MSI-X
[   33.591061] ixgbe 0000:03:00.1: irq 212 for MSI/MSI-X
[   33.597915] ixgbe 0000:03:00.1: irq 213 for MSI/MSI-X
[   33.604708] ixgbe 0000:03:00.1: irq 214 for MSI/MSI-X
[   33.611472] ixgbe 0000:03:00.1: irq 215 for MSI/MSI-X
[   33.618229] ixgbe 0000:03:00.1: irq 216 for MSI/MSI-X
[   33.624991] ixgbe 0000:03:00.1: irq 217 for MSI/MSI-X
[   33.631751] ixgbe 0000:03:00.1: irq 218 for MSI/MSI-X
[   33.638507] ixgbe 0000:03:00.1: irq 219 for MSI/MSI-X
[   33.645273] ixgbe 0000:03:00.1: irq 220 for MSI/MSI-X
[   33.652090] ixgbe 0000:03:00.1: irq 221 for MSI/MSI-X
[   33.658934] ixgbe 0000:03:00.1: irq 222 for MSI/MSI-X
[   33.665720] ixgbe 0000:03:00.1: irq 223 for MSI/MSI-X
[   33.672485] ixgbe 0000:03:00.1: irq 224 for MSI/MSI-X
[   33.679247] ixgbe 0000:03:00.1: irq 225 for MSI/MSI-X
[   33.686016] ixgbe 0000:03:00.1: irq 226 for MSI/MSI-X
[   33.692783] ixgbe 0000:03:00.1: irq 227 for MSI/MSI-X
[   33.699543] ixgbe 0000:03:00.1: irq 228 for MSI/MSI-X
[   33.706306] ixgbe 0000:03:00.1: irq 229 for MSI/MSI-X
[   33.713070] ixgbe 0000:03:00.1: irq 230 for MSI/MSI-X
[   33.719869] ixgbe 0000:03:00.1: irq 231 for MSI/MSI-X
[   33.726634] ixgbe 0000:03:00.1: irq 232 for MSI/MSI-X
[   33.733401] ixgbe 0000:03:00.1: irq 233 for MSI/MSI-X
[   33.740166] ixgbe 0000:03:00.1: irq 234 for MSI/MSI-X
[   33.746925] ixgbe 0000:03:00.1: irq 235 for MSI/MSI-X
[   33.753690] ixgbe 0000:03:00.1: irq 236 for MSI/MSI-X
[   33.760454] ixgbe 0000:03:00.1: irq 237 for MSI/MSI-X
[   33.767275] ixgbe 0000:03:00.1: irq 238 for MSI/MSI-X
[   33.774066] ixgbe 0000:03:00.1: irq 239 for MSI/MSI-X
[   33.780828] ixgbe 0000:03:00.1: irq 240 for MSI/MSI-X
[   33.787590] ixgbe 0000:03:00.1: irq 241 for MSI/MSI-X
[   33.794354] ixgbe 0000:03:00.1: irq 242 for MSI/MSI-X
[   33.801122] ixgbe 0000:03:00.1: irq 243 for MSI/MSI-X
[   33.807885] ixgbe 0000:03:00.1: irq 244 for MSI/MSI-X
[   33.814651] ixgbe 0000:03:00.1: irq 245 for MSI/MSI-X
[   33.821456] ixgbe 0000:03:00.1: irq 246 for MSI/MSI-X
[   33.828217] ixgbe 0000:03:00.1: irq 247 for MSI/MSI-X
[   33.834976] ixgbe 0000:03:00.1: irq 248 for MSI/MSI-X
[   33.841735] ixgbe 0000:03:00.1: irq 249 for MSI/MSI-X
[   33.848499] ixgbe 0000:03:00.1: irq 250 for MSI/MSI-X
[   33.855264] ixgbe 0000:03:00.1: irq 251 for MSI/MSI-X
[   33.862066] ixgbe 0000:03:00.1: irq 252 for MSI/MSI-X
[   33.868831] ixgbe 0000:03:00.1: irq 253 for MSI/MSI-X
[   33.875651] ixgbe 0000:03:00.1: irq 254 for MSI/MSI-X
[   33.882438] ixgbe 0000:03:00.1: irq 255 for MSI/MSI-X
[   33.889196] ixgbe 0000:03:00.1: irq 256 for MSI/MSI-X
[   33.895959] ixgbe 0000:03:00.1: irq 257 for MSI/MSI-X
[   33.902721] ixgbe 0000:03:00.1: irq 258 for MSI/MSI-X
[   33.909486] ixgbe 0000:03:00.1: irq 259 for MSI/MSI-X
[   33.916248] ixgbe 0000:03:00.1: irq 260 for MSI/MSI-X
[   33.923015] ixgbe 0000:03:00.1: irq 261 for MSI/MSI-X
[   33.929771] ixgbe 0000:03:00.1: irq 262 for MSI/MSI-X
[   33.936534] ixgbe 0000:03:00.1: irq 263 for MSI/MSI-X
[   33.943299] ixgbe 0000:03:00.1: irq 264 for MSI/MSI-X
[   33.950059] ixgbe 0000:03:00.1: irq 265 for MSI/MSI-X
[   33.956821] ixgbe 0000:03:00.1: irq 266 for MSI/MSI-X
[   33.963584] ixgbe 0000:03:00.1: irq 267 for MSI/MSI-X
[   33.970342] ixgbe 0000:03:00.1: irq 268 for MSI/MSI-X
[   33.977140] ixgbe 0000:03:00.1: irq 269 for MSI/MSI-X
[   33.983962] ixgbe 0000:03:00.1: irq 270 for MSI/MSI-X
[   33.990754] ixgbe 0000:03:00.1: irq 271 for MSI/MSI-X
[   33.998055] ixgbe 0000:03:00.1: Multiqueue Enabled: Rx Queue count = 63, Tx Queue count = 63
[   34.069946] ixgbe 0000:03:00.1: PCI Express bandwidth of 16GT/s available
[   34.078662] ixgbe 0000:03:00.1: (Speed:5.0GT/s, Width: x4, Encoding Loss:20%)
[   34.087735] ixgbe 0000:03:00.1: This is not sufficient for optimal performance of this card.
[   34.099048] ixgbe 0000:03:00.1: For optimal performance, at least 20GT/s of bandwidth is required.
[   34.110984] ixgbe 0000:03:00.1: A slot with more lanes and/or higher speed is suggested.
[   34.283362] ixgbe 0000:03:00.1: MAC: 3, PHY: 3, PBA No: G36748-004
[   34.291395] ixgbe 0000:03:00.1: a0:36:9f:0e:f0:ca
[   34.463886] ixgbe 0000:03:00.1: Intel(R) 10 Gigabit Network Connection
[   34.472469] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   34.481575] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   34.489724] sky2: driver version 1.30
[   34.498307] usbcore: registered new interface driver catc
[   34.505529] usbcore: registered new interface driver kaweth
[   34.512795] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   34.523103] usbcore: registered new interface driver pegasus
[   34.530701] usbcore: registered new interface driver rtl8150
[   34.538341] usbcore: registered new interface driver asix
[   34.545730] usbcore: registered new interface driver ax88179_178a
[   34.553875] usbcore: registered new interface driver cdc_ether
[   34.561723] usbcore: registered new interface driver r815x
[   34.569236] usbcore: registered new interface driver cdc_eem
[   34.576896] usbcore: registered new interface driver dm9601
[   34.584453] usbcore: registered new interface driver smsc75xx
[   34.592301] usbcore: registered new interface driver smsc95xx
[   34.600143] usbcore: registered new interface driver gl620a
[   34.607867] usbcore: registered new interface driver net1080
[   34.615504] usbcore: registered new interface driver plusb
[   34.622975] usbcore: registered new interface driver rndis_host
[   34.630951] usbcore: registered new interface driver cdc_subset
[   34.638846] usbcore: registered new interface driver zaurus
[   34.646396] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   34.656707] usbcore: registered new interface driver int51x1
[   34.664347] usbcore: registered new interface driver ipheth
[   34.671858] usbcore: registered new interface driver sierra_net
[   34.679796] usbcore: registered new interface driver cdc_ncm
[   34.687143] Fusion MPT base driver 3.04.20
[   34.692762] Copyright (c) 1999-2008 LSI Corporation
[   34.699306] Fusion MPT SPI Host driver 3.04.20
[   34.705643] Fusion MPT FC Host driver 3.04.20
[   34.711929] Fusion MPT SAS Host driver 3.04.20
[   34.718271] Fusion MPT misc device (ioctl) driver 3.04.20
[   34.725582] mptctl: Registered with Fusion MPT base driver
[   34.732763] mptctl: /dev/mptctl @ (major,minor=10,220)
[   34.740508] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   34.748918] ehci-pci: EHCI PCI platform driver
[   34.755925] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   34.763368] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   34.773528] ehci-pci 0000:00:1a.0: debug port 2
[   34.783608] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[   34.792295] ehci-pci 0000:00:1a.0: irq 16, io mem 0x93402000
[   34.808157] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   34.816841] hub 1-0:1.0: USB hub found
[   34.822120] hub 1-0:1.0: 2 ports detected
[   34.829045] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   34.836756] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   34.847026] ehci-pci 0000:00:1d.0: debug port 2
[   34.857124] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[   34.865885] ehci-pci 0000:00:1d.0: irq 23, io mem 0x93401000
[   34.884159] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   34.893030] hub 2-0:1.0: USB hub found
[   34.898265] hub 2-0:1.0: 2 ports detected
[   34.904707] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   34.912676] ohci-pci: OHCI PCI platform driver
[   34.918994] uhci_hcd: USB Universal Host Controller Interface driver
[   34.927741] usbcore: registered new interface driver usb-storage
[   34.935673] usbcore: registered new interface driver ums-alauda
[   34.943512] usbcore: registered new interface driver ums-datafab
[   34.951559] usbcore: registered new interface driver ums-freecom
[   34.959511] usbcore: registered new interface driver ums-isd200
[   34.967444] usbcore: registered new interface driver ums-jumpshot
[   34.995933] usbcore: registered new interface driver ums-sddr09
[   35.003852] usbcore: registered new interface driver ums-sddr55
[   35.011936] usbcore: registered new interface driver ums-usbat
[   35.019728] usbcore: registered new interface driver usbtest
[   35.027788] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   35.136348] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   35.277602] hub 1-1:1.0: USB hub found
[   35.282966] hub 1-1:1.0: 6 ports detected
[   35.634851] i8042: Can't read CTR while initializing i8042
[   35.642058] i8042: probe of i8042 failed with error -5
[   35.650007] mousedev: PS/2 mouse device common for all mice
[   35.658965] rtc_cmos 00:06: RTC can wake from S4
[   35.665871] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[   35.673897] rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   35.684832] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   35.692194] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   35.703260] iTCO_vendor_support: vendor-support=0
[   35.710176] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   35.724458] md: linear personality registered for level -1
[   35.731667] md: raid0 personality registered for level 0
[   35.738705] md: raid1 personality registered for level 1
[   35.745745] md: raid10 personality registered for level 10
[   35.752094] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   35.761663] md: raid6 personality registered for level 6
[   35.768705] md: raid5 personality registered for level 5
[   35.775741] md: raid4 personality registered for level 4
[   35.782782] md: multipath personality registered for level -4
[   35.790264] md: faulty personality registered for level -5
[   35.801016] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   35.814164] device-mapper: multipath: version 1.6.0 loaded
[   35.821443] device-mapper: multipath round-robin: version 1.0.0 loaded
[   35.829947] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   35.837724] device-mapper: cache cleaner: version 1.0.0 loaded
[   35.845996] Intel P-state driver initializing.
[   35.852103] Intel pstate controlling: cpu 0
[   35.857350] Intel pstate controlling: cpu 1
[   35.862550] Intel pstate controlling: cpu 2
[   35.867751] Intel pstate controlling: cpu 3
[   35.872982] Intel pstate controlling: cpu 4
[   35.878199] Intel pstate controlling: cpu 5
[   35.883401] Intel pstate controlling: cpu 6
[   35.885427] hub 2-1:1.0: USB hub found
[   35.885587] hub 2-1:1.0: 8 ports detected
[   35.898214] Intel pstate controlling: cpu 7
[   35.903413] Intel pstate controlling: cpu 8
[   35.908607] Intel pstate controlling: cpu 9
[   35.913816] Intel pstate controlling: cpu 10
[   35.919111] Intel pstate controlling: cpu 11
[   35.924413] Intel pstate controlling: cpu 12
[   35.929709] Intel pstate controlling: cpu 13
[   35.935003] Intel pstate controlling: cpu 14
[   35.940291] Intel pstate controlling: cpu 15
[   35.945596] Intel pstate controlling: cpu 16
[   35.950894] Intel pstate controlling: cpu 17
[   35.956181] Intel pstate controlling: cpu 18
[   35.961474] Intel pstate controlling: cpu 19
[   35.966763] Intel pstate controlling: cpu 20
[   35.972119] Intel pstate controlling: cpu 21
[   35.977435] Intel pstate controlling: cpu 22
[   35.982727] Intel pstate controlling: cpu 23
[   35.988222] Intel pstate controlling: cpu 24
[   35.993570] Intel pstate controlling: cpu 25
[   35.998945] Intel pstate controlling: cpu 26
[   36.004270] Intel pstate controlling: cpu 27
[   36.009644] Intel pstate controlling: cpu 28
[   36.014972] Intel pstate controlling: cpu 29
[   36.020320] Intel pstate controlling: cpu 30
[   36.025665] Intel pstate controlling: cpu 31
[   36.030961] Intel pstate controlling: cpu 32
[   36.036294] Intel pstate controlling: cpu 33
[   36.041615] Intel pstate controlling: cpu 34
[   36.046905] Intel pstate controlling: cpu 35
[   36.052268] Intel pstate controlling: cpu 36
[   36.057599] Intel pstate controlling: cpu 37
[   36.062896] Intel pstate controlling: cpu 38
[   36.068254] Intel pstate controlling: cpu 39
[   36.073567] Intel pstate controlling: cpu 40
[   36.078860] Intel pstate controlling: cpu 41
[   36.084237] Intel pstate controlling: cpu 42
[   36.089563] Intel pstate controlling: cpu 43
[   36.094852] Intel pstate controlling: cpu 44
[   36.100215] Intel pstate controlling: cpu 45
[   36.105533] Intel pstate controlling: cpu 46
[   36.110837] Intel pstate controlling: cpu 47
[   36.116202] Intel pstate controlling: cpu 48
[   36.121524] Intel pstate controlling: cpu 49
[   36.126820] Intel pstate controlling: cpu 50
[   36.132183] Intel pstate controlling: cpu 51
[   36.137509] Intel pstate controlling: cpu 52
[   36.142806] Intel pstate controlling: cpu 53
[   36.148157] Intel pstate controlling: cpu 54
[   36.153468] Intel pstate controlling: cpu 55
[   36.158767] Intel pstate controlling: cpu 56
[   36.160243] usb 2-1.2: new full-speed USB device number 3 using ehci-pci
[   36.172237] Intel pstate controlling: cpu 57
[   36.177556] Intel pstate controlling: cpu 58
[   36.182920] Intel pstate controlling: cpu 59
[   36.188253] Intel pstate controlling: cpu 60
[   36.193618] Intel pstate controlling: cpu 61
[   36.198941] Intel pstate controlling: cpu 62
[   36.204311] Intel pstate controlling: cpu 63
[   36.209649] Intel pstate controlling: cpu 64
[   36.214948] Intel pstate controlling: cpu 65
[   36.220310] Intel pstate controlling: cpu 66
[   36.225624] Intel pstate controlling: cpu 67
[   36.230933] Intel pstate controlling: cpu 68
[   36.236292] Intel pstate controlling: cpu 69
[   36.241621] Intel pstate controlling: cpu 70
[   36.246926] Intel pstate controlling: cpu 71
[   36.252288] Intel pstate controlling: cpu 72
[   36.254085] hub 2-1.2:1.0: USB hub found
[   36.254252] hub 2-1.2:1.0: 4 ports detected
[   36.267697] Intel pstate controlling: cpu 73
[   36.273026] Intel pstate controlling: cpu 74
[   36.278387] Intel pstate controlling: cpu 75
[   36.283716] Intel pstate controlling: cpu 76
[   36.289088] Intel pstate controlling: cpu 77
[   36.294427] Intel pstate controlling: cpu 78
[   36.299721] Intel pstate controlling: cpu 79
[   36.305090] Intel pstate controlling: cpu 80
[   36.310407] Intel pstate controlling: cpu 81
[   36.315704] Intel pstate controlling: cpu 82
[   36.321072] Intel pstate controlling: cpu 83
[   36.324248] usb 2-1.4: new full-speed USB device number 4 using ehci-pci
[   36.334440] Intel pstate controlling: cpu 84
[   36.339769] Intel pstate controlling: cpu 85
[   36.345137] Intel pstate controlling: cpu 86
[   36.350464] Intel pstate controlling: cpu 87
[   36.355756] Intel pstate controlling: cpu 88
[   36.361138] Intel pstate controlling: cpu 89
[   36.366467] Intel pstate controlling: cpu 90
[   36.371768] Intel pstate controlling: cpu 91
[   36.377170] Intel pstate controlling: cpu 92
[   36.382486] Intel pstate controlling: cpu 93
[   36.387802] Intel pstate controlling: cpu 94
[   36.393165] Intel pstate controlling: cpu 95
[   36.398480] Intel pstate controlling: cpu 96
[   36.403781] Intel pstate controlling: cpu 97
[   36.409149] Intel pstate controlling: cpu 98
[   36.414476] Intel pstate controlling: cpu 99
[   36.419774] Intel pstate controlling: cpu 100
[   36.425233] Intel pstate controlling: cpu 101
[   36.430644] Intel pstate controlling: cpu 102
[   36.436186] Intel pstate controlling: cpu 103
[   36.441612] Intel pstate controlling: cpu 104
[   36.447024] Intel pstate controlling: cpu 105
[   36.452489] Intel pstate controlling: cpu 106
[   36.457918] Intel pstate controlling: cpu 107
[   36.463317] Intel pstate controlling: cpu 108
[   36.468778] Intel pstate controlling: cpu 109
[   36.474211] Intel pstate controlling: cpu 110
[   36.479604] Intel pstate controlling: cpu 111
[   36.485065] Intel pstate controlling: cpu 112
[   36.490487] Intel pstate controlling: cpu 113
[   36.495880] Intel pstate controlling: cpu 114
[   36.501360] Intel pstate controlling: cpu 115
[   36.506787] Intel pstate controlling: cpu 116
[   36.512246] Intel pstate controlling: cpu 117
[   36.517667] Intel pstate controlling: cpu 118
[   36.523065] Intel pstate controlling: cpu 119
[   36.524252] usb 2-1.2.1: new low-speed USB device number 5 using ehci-pci
[   36.537337] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   36.554598] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/0003:046B:FF10.0001/input/input2
[   36.574278] hid-generic 0003:046B:FF10.0001: input: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input0
[   36.595750] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/0003:046B:FF10.0002/input/input3
[   36.616314] hid-generic 0003:046B:FF10.0002: input: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.0-1.4/input1
[   36.634077] usbcore: registered new interface driver usbhid
[   36.641441] usbhid: USB HID core driver
[   36.669802] TCP: bic registered
[   36.674426] Initializing XFRM netlink socket
[   36.682898] NET: Registered protocol family 10
[   36.692219] sit: IPv6 over IPv4 tunneling driver
[   36.700404] NET: Registered protocol family 17
[   36.706574] 8021q: 802.1Q VLAN Support v1.8
[   36.717309] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.1/2-1.2.1:1.0/0003:0557:2261.0003/input/input4
[   36.717878] DCCP: Activated CCID 2 (TCP-like)
[   36.717917] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   36.722559] sctp: Hash tables configured (established 65536 bind 65536)
[   36.723622] tipc: Activated (version 2.0.0)
[   36.723918] NET: Registered protocol family 30
[   36.724923] tipc: Started in single node mode
[   36.724958] Key type dns_resolver registered
[   36.771480] 
[   36.771480] printing PIC contents
[   36.771485] ... PIC  IMR: ffff
[   36.771490] ... PIC  IRR: 0c00
[   36.771525] ... PIC  ISR: 0000
[   36.771529] ... PIC ELCR: 0e00
[   36.721274] printing local APIC contents on CPU#0/0:
[   36.721274] ... APIC ID:      00000000 (0)
[   36.721274] ... APIC VERSION: 01060015
[   36.721274] ... APIC TASKPRI: 00000000 (00)
[   36.721274] ... APIC PROCPRI: 00000000
[   36.721274] ... APIC LDR: 01000000
[   36.721274] ... APIC DFR: ffffffff
[   36.721274] ... APIC SPIV: 000001ff
[   36.721274] ... APIC ISR field:
[   36.721274] 0000000000000000000000000000000000000000000000000000000000000000
[   36.721274] ... APIC TMR field:
[   36.721274] 0000000000000000000200020000000000000000000000000000000000000000
[   36.721274] ... APIC IRR field:
[   36.721274] 0000000000000000000200000000000000000000000000000000000000008000
[   36.721274] ... APIC ESR: 00000000
[   36.721274] ... APIC ICR: 000000fd
[   36.721274] ... APIC ICR2: 26000000
[   36.721274] ... APIC LVTT: 000400ef
[   36.721274] ... APIC LVTPC: 00000400
[   36.721274] ... APIC LVT0: 00010700
[   36.721274] ... APIC LVT1: 00000400
[   36.721274] ... APIC LVTERR: 000000fe
[   36.721274] ... APIC TMICT: 00000000
[   36.721274] ... APIC TMCCT: 00000000
[   36.721274] ... APIC TDCR: 00000000
[   36.721274] 
[   36.950147] number of MP IRQ sources: 15.
[   36.951176] hid-generic 0003:0557:2261.0003: input: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.2.1/input0
[   36.972700] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.1/2-1.2.1:1.1/0003:0557:2261.0004/input/input5
[   36.973470] hid-generic 0003:0557:2261.0004: input: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.2.1/input1
[   36.990667] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.1/2-1.2.1:1.2/0003:0557:2261.0005/input/input6
[   36.992141] hid-generic 0003:0557:2261.0005: input: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.2.1/input2
[   37.045501] number of IO-APIC #8 registers: 24.
[   37.051588] number of IO-APIC #9 registers: 24.
[   37.057683] number of IO-APIC #10 registers: 24.
[   37.063864] number of IO-APIC #11 registers: 24.
[   37.070051] number of IO-APIC #12 registers: 24.
[   37.076256] testing the IO APIC.......................
[   37.083052] IO APIC #8......
[   37.087291] .... register #00: 08000000
[   37.092599] .......    : physical APIC id: 08
[   37.098508] .......    : Delivery Type: 0
[   37.103984] .......    : LTS          : 0
[   37.109486] .... register #01: 00170020
[   37.114814] .......     : max redirection entries: 17
[   37.121500] .......     : PRQ implemented: 0
[   37.127292] .......     : IO APIC version: 20
[   37.133177] .... IRQ redirection table:
[   37.138474] 1    0    0   0   0    0    0    00
[   37.144560] 0    0    0   0   0    0    0    31
[   37.150651] 0    0    0   0   0    0    0    30
[   37.156739] 0    0    0   0   0    0    0    33
[   37.162826] 0    0    0   0   0    0    0    34
[   37.168918] 0    0    0   0   0    0    0    35
[   37.175004] 0    0    0   0   0    0    0    36
[   37.181091] 0    0    0   0   0    0    0    37
[   37.187179] 0    0    0   0   0    0    0    38
[   37.193269] 0    1    0   0   0    0    0    39
[   37.199358] 0    0    0   0   0    0    0    3A
[   37.205450] 0    0    0   0   0    0    0    3B
[   37.211534] 0    0    0   0   0    0    0    3C
[   37.217624] 0    0    0   0   0    0    0    3D
[   37.223710] 0    0    0   0   0    0    0    3E
[   37.229802] 0    0    0   0   0    0    0    3F
[   37.235890] 0    1    0   1   0    0    0    41
[   37.241977] 1    0    0   0   0    0    0    00
[   37.248069] 1    0    0   0   0    0    0    00
[   37.254158] 1    1    0   1   0    0    0    B1
[   37.260245] 1    0    0   0   0    0    0    00
[   37.266334] 1    0    0   0   0    0    0    00
[   37.272422] 1    0    0   0   0    0    0    00
[   37.278511] 0    1    0   1   0    0    0    51
[   37.284602] IO APIC #9......
[   37.288833] .... register #00: 09000000
[   37.294130] .......    : physical APIC id: 09
[   37.300046] .......    : Delivery Type: 0
[   37.305545] .......    : LTS          : 0
[   37.311018] .... register #01: 00170020
[   37.316343] .......     : max redirection entries: 17
[   37.323019] .......     : PRQ implemented: 0
[   37.328817] .......     : IO APIC version: 20
[   37.334729] .... register #02: 00000000
[   37.340035] .......     : arbitration: 00
[   37.345565] .... register #03: 00000001
[   37.350862] .......     : Boot DT    : 1
[   37.356242] .... IRQ redirection table:
[   37.361572] 1    0    0   0   0    0    0    00
[   37.367661] 1    0    0   0   0    0    0    00
[   37.373750] 1    0    0   0   0    0    0    00
[   37.379839] 1    0    0   0   0    0    0    00
[   37.385925] 1    0    0   0   0    0    0    00
[   37.392009] 1    0    0   0   0    0    0    00
[   37.398096] 1    0    0   0   0    0    0    00
[   37.404187] 1    0    0   0   0    0    0    00
[   37.410273] 1    0    0   0   0    0    0    00
[   37.416361] 1    0    0   0   0    0    0    00
[   37.422452] 1    0    0   0   0    0    0    00
[   37.428540] 1    0    0   0   0    0    0    00
[   37.434624] 1    0    0   0   0    0    0    00
[   37.440716] 1    0    0   0   0    0    0    00
[   37.446803] 1    0    0   0   0    0    0    00
[   37.452887] 1    0    0   0   0    0    0    00
[   37.458973] 1    0    0   0   0    0    0    00
[   37.465059] 1    0    0   0   0    0    0    00
[   37.471152] 1    1    0   1   0    0    0    C7
[   37.477240] 1    0    0   0   0    0    0    00
[   37.483325] 1    0    0   0   0    0    0    00
[   37.489414] 1    1    0   1   0    0    0    72
[   37.495496] 1    0    0   0   0    0    0    00
[   37.501578] 1    1    0   1   0    0    0    61
[   37.507668] IO APIC #10......
[   37.512028] .... register #00: 0A000000
[   37.517325] .......    : physical APIC id: 0A
[   37.523240] .......    : Delivery Type: 0
[   37.528742] .......    : LTS          : 0
[   37.534237] .... register #01: 00170020
[   37.539539] .......     : max redirection entries: 17
[   37.546215] .......     : PRQ implemented: 0
[   37.552012] .......     : IO APIC version: 20
[   37.557923] .... register #02: 00000000
[   37.563223] .......     : arbitration: 00
[   37.568728] .... register #03: 00000001
[   37.574054] .......     : Boot DT    : 1
[   37.579437] .... IRQ redirection table:
[   37.584771] 1    0    0   0   0    0    0    00
[   37.590855] 1    0    0   0   0    0    0    00
[   37.596943] 1    0    0   0   0    0    0    00
[   37.603030] 1    0    0   0   0    0    0    00
[   37.609119] 1    0    0   0   0    0    0    00
[   37.615208] 1    0    0   0   0    0    0    00
[   37.621299] 1    0    0   0   0    0    0    00
[   37.627382] 1    0    0   0   0    0    0    00
[   37.633601] 1    0    0   0   0    0    0    00
[   37.639807] 1    0    0   0   0    0    0    00
[   37.645760] 1    0    0   0   0    0    0    00
[   37.651944] 1    0    0   0   0    0    0    00
[   37.657980] 1    0    0   0   0    0    0    00
[   37.664168] 1    0    0   0   0    0    0    00
[   37.670346] 1    0    0   0   0    0    0    00
[   37.676523] 1    0    0   0   0    0    0    00
[   37.682736] 1    0    0   0   0    0    0    00
[   37.688917] 1    0    0   0   0    0    0    00
[   37.695121] 1    0    0   0   0    0    0    00
[   37.701303] 1    0    0   0   0    0    0    00
[   37.707508] 1    0    0   0   0    0    0    00
[   37.713724] 1    0    0   0   0    0    0    00
[   37.719903] 1    0    0   0   0    0    0    00
[   37.726118] 1    1    0   1   0    0    0    22
[   37.732304] IO APIC #11......
[   37.736748] .... register #00: 0B000000
[   37.742165] .......    : physical APIC id: 0B
[   37.768619] .......    : Delivery Type: 0
[   37.774238] .......    : LTS          : 0
[   37.779836] .... register #01: 00170020
[   37.785259] .......     : max redirection entries: 17
[   37.792053] .......     : PRQ implemented: 0
[   37.797939] .......     : IO APIC version: 20
[   37.803941] .... register #02: 00000000
[   37.809366] .......     : arbitration: 00
[   37.814962] .... register #03: 00000001
[   37.820381] .......     : Boot DT    : 1
[   37.825881] .... IRQ redirection table:
[   37.831300] 1    0    0   0   0    0    0    00
[   37.837481] 1    0    0   0   0    0    0    00
[   37.843663] 1    0    0   0   0    0    0    00
[   37.849839] 1    0    0   0   0    0    0    00
[   37.856027] 1    0    0   0   0    0    0    00
[   37.862235] 1    0    0   0   0    0    0    00
[   37.868413] 1    0    0   0   0    0    0    00
[   37.874596] 1    0    0   0   0    0    0    00
[   37.880776] 1    0    0   0   0    0    0    00
[   37.886955] 1    0    0   0   0    0    0    00
[   37.893138] 1    0    0   0   0    0    0    00
[   37.899320] 1    0    0   0   0    0    0    00
[   37.905528] 1    0    0   0   0    0    0    00
[   37.911704] 1    0    0   0   0    0    0    00
[   37.917911] 1    0    0   0   0    0    0    00
[   37.924100] 1    0    0   0   0    0    0    00
[   37.930308] 1    0    0   0   0    0    0    00
[   37.936486] 1    0    0   0   0    0    0    00
[   37.942694] 1    0    0   0   0    0    0    00
[   37.948870] 1    0    0   0   0    0    0    00
[   37.955052] 1    0    0   0   0    0    0    00
[   37.961266] 1    0    0   0   0    0    0    00
[   37.967442] 1    0    0   0   0    0    0    00
[   37.973623] 1    1    0   1   0    0    0    42
[   37.979800] IO APIC #12......
[   37.984243] .... register #00: 0C000000
[   37.989660] .......    : physical APIC id: 0C
[   37.995640] .......    : Delivery Type: 0
[   38.001266] .......    : LTS          : 0
[   38.006882] .... register #01: 00170020
[   38.012298] .......     : max redirection entries: 17
[   38.019064] .......     : PRQ implemented: 0
[   38.024953] .......     : IO APIC version: 20
[   38.030928] .... register #02: 00000000
[   38.036368] .......     : arbitration: 00
[   38.041961] .... register #03: 00000001
[   38.047354] .......     : Boot DT    : 1
[   38.052877] .... IRQ redirection table:
[   38.058297] 1    0    0   0   0    0    0    00
[   38.064479] 1    0    0   0   0    0    0    00
[   38.070691] 1    0    0   0   0    0    0    00
[   38.076870] 1    0    0   0   0    0    0    00
[   38.083047] 1    0    0   0   0    0    0    00
[   38.089228] 1    0    0   0   0    0    0    00
[   38.095405] 1    0    0   0   0    0    0    00
[   38.101592] 1    0    0   0   0    0    0    00
[   38.107791] 1    0    0   0   0    0    0    00
[   38.113969] 1    0    0   0   0    0    0    00
[   38.120180] 1    0    0   0   0    0    0    00
[   38.126358] 1    0    0   0   0    0    0    00
[   38.132543] 1    0    0   0   0    0    0    00
[   38.138726] 1    0    0   0   0    0    0    00
[   38.144931] 1    0    0   0   0    0    0    00
[   38.151107] 1    0    0   0   0    0    0    00
[   38.157316] 1    0    0   0   0    0    0    00
[   38.163497] 1    0    0   0   0    0    0    00
[   38.169679] 1    0    0   0   0    0    0    00
[   38.175889] 1    0    0   0   0    0    0    00
[   38.182071] 1    0    0   0   0    0    0    00
[   38.188279] 1    0    0   0   0    0    0    00
[   38.194460] 1    0    0   0   0    0    0    00
[   38.200668] 1    1    0   1   0    0    0    52
[   38.206840] IRQ to pin mappings:
[   38.211561] IRQ0 -> 0:2
[   38.215796] IRQ1 -> 0:1
[   38.220123] IRQ3 -> 0:3
[   38.224333] IRQ4 -> 0:4
[   38.228578] IRQ5 -> 0:5
[   38.232790] IRQ6 -> 0:6
[   38.237034] IRQ7 -> 0:7
[   38.241277] IRQ8 -> 0:8
[   38.245489] IRQ9 -> 0:9
[   38.249700] IRQ10 -> 0:10
[   38.254115] IRQ11 -> 0:11
[   38.258532] IRQ12 -> 0:12
[   38.262952] IRQ13 -> 0:13
[   38.267371] IRQ14 -> 0:14
[   38.271789] IRQ15 -> 0:15
[   38.276325] IRQ16 -> 0:16
[   38.280741] IRQ19 -> 0:19
[   38.285160] IRQ23 -> 0:23
[   38.289588] IRQ42 -> 1:18
[   38.294007] IRQ45 -> 1:21
[   38.298427] IRQ47 -> 1:23
[   38.302844] IRQ71 -> 2:23
[   38.307265] IRQ95 -> 3:23
[   38.311686] IRQ119 -> 4:23
[   38.316312] .................................... done.
[   38.325201] registered taskstats version 1
[   38.332343] bio: create slab <bio-1> at 1
[   38.340142] Btrfs loaded
[   38.352572] rtc_cmos 00:06: setting system clock to 2014-03-15 14:28:53 UTC (1394893733)
[   38.363444] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   38.371246] EDD information not available.
[   38.665910] pps pps0: new PPS source ptp0
[   38.671076] ixgbe 0000:03:00.0: registered PHC device on eth0
[   39.087939] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   39.095675] 8021q: adding VLAN 0 to HW filter on device eth0
[   39.408786] pps pps1: new PPS source ptp1
[   39.414122] ixgbe 0000:03:00.1: registered PHC device on eth1
[   39.831403] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   39.839039] 8021q: adding VLAN 0 to HW filter on device eth1
[   42.271365] ixgbe 0000:03:00.0 eth0: NIC Link is Up 1 Gbps, Flow Control: None
[   42.284296] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   42.300160] Sending DHCP requests .
[   42.601252] ixgbe 0000:03:00.1 eth1: NIC Link is Up 1 Gbps, Flow Control: RX/TX
[   42.613525] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   42.808141] , OK
[   42.908143] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.178
[   42.922969] ixgbe 0000:03:00.0: removed PHC on eth0
[   43.362755] IP-Config: Complete:
[   43.367483]      device=eth1, hwaddr=a0:36:9f:0e:f0:ca, ipaddr=192.168.1.178, mask=255.255.255.0, gw=192.168.1.1
[   43.380796]      host=brickland2, domain=lkp.intel.com, nis-domain=(none)
[   43.389449]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   43.397211]      nameserver0=192.168.1.1
[   43.404095] PM: Hibernation image not present or could not be loaded.
[   43.419076] Freeing unused kernel memory: 1440K (ffffffff8233b000 - ffffffff824a3000)
[   43.429741] Write protecting the kernel read-only data: 18432k
[   43.458061] Freeing unused kernel memory: 1700K (ffff880001a57000 - ffff880001c00000)
[   43.489112] Freeing unused kernel memory: 1876K (ffff88000202b000 - ffff880002200000)
[   44.609759] ipmi message handler version 39.2
[   44.621186] IPMI System Interface driver.
[   44.627023] ipmi_si: probing via ACPI
[   44.632229] ipmi_si 00:0d: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
[   44.640359] ipmi_si: Adding ACPI-specified kcs state machine
[   44.647636] ipmi_si: probing via SMBIOS
[   44.652489] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   44.659744] ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
[   44.669932] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   44.693226] mpt2sas version 16.100.00.00 loaded
[   44.701059] scsi6 : Fusion MPT SAS Host
[   44.710823] IOAPIC[1]: Set routing entry (9-8 -> 0x5d -> IRQ 32 Mode:1 Active:1 Dest:0)
[   44.721840] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (131913672 kB)
[   44.733082] mpt2sas 0000:01:00.0: irq 272 for MSI/MSI-X
[   44.740131] mpt2sas 0000:01:00.0: irq 273 for MSI/MSI-X
[   44.747123] mpt2sas 0000:01:00.0: irq 274 for MSI/MSI-X
[   44.754176] mpt2sas 0000:01:00.0: irq 275 for MSI/MSI-X
[   44.760855] mpt2sas 0000:01:00.0: irq 276 for MSI/MSI-X
[   44.767995] mpt2sas 0000:01:00.0: irq 277 for MSI/MSI-X
[   44.775082] mpt2sas 0000:01:00.0: irq 278 for MSI/MSI-X
[   44.782086] mpt2sas 0000:01:00.0: irq 279 for MSI/MSI-X
[   44.789078] mpt2sas 0000:01:00.0: irq 280 for MSI/MSI-X
[   44.796435] mpt2sas 0000:01:00.0: irq 281 for MSI/MSI-X
[   44.803852] mpt2sas 0000:01:00.0: irq 282 for MSI/MSI-X
[   44.811228] mpt2sas 0000:01:00.0: irq 283 for MSI/MSI-X
[   44.818684] mpt2sas 0000:01:00.0: irq 284 for MSI/MSI-X
[   44.825905] mpt2sas 0000:01:00.0: irq 285 for MSI/MSI-X
[   44.826731] ipmi_si 00:0d: Found new BMC (man_id: 0x000157, prod_id: 0x0063, dev_id: 0x21)
[   44.826772] ipmi_si 00:0d: IPMI kcs interface initialized
[   44.851200] mpt2sas 0000:01:00.0: irq 286 for MSI/MSI-X
[   44.878848] mpt2sas 0000:01:00.0: irq 287 for MSI/MSI-X
[   44.886511] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 272
[   44.893462] mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 273
[   44.900364] mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 274
[   44.907234] mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 275
[   44.913905] mpt2sas0-msix4: PCI-MSI-X enabled: IRQ 276
[   44.920611] mpt2sas0-msix5: PCI-MSI-X enabled: IRQ 277
[   44.927248] mpt2sas0-msix6: PCI-MSI-X enabled: IRQ 278
[   44.933967] mpt2sas0-msix7: PCI-MSI-X enabled: IRQ 279
[   44.940820] mpt2sas0-msix8: PCI-MSI-X enabled: IRQ 280
[   44.947540] mpt2sas0-msix9: PCI-MSI-X enabled: IRQ 281
[   44.954367] mpt2sas0-msix10: PCI-MSI-X enabled: IRQ 282
[   44.961149] mpt2sas0-msix11: PCI-MSI-X enabled: IRQ 283
[   44.961301] microcode: CPU0 sig=0x306e7, pf=0x80, revision=0x0
[   44.961398] microcode: CPU1 sig=0x306e7, pf=0x80, revision=0x0
[   44.961476] microcode: CPU2 sig=0x306e7, pf=0x80, revision=0x0
[   44.961669] microcode: CPU3 sig=0x306e7, pf=0x80, revision=0x0
[   44.961821] microcode: CPU4 sig=0x306e7, pf=0x80, revision=0x0
[   44.961920] microcode: CPU5 sig=0x306e7, pf=0x80, revision=0x0
[   44.962033] microcode: CPU6 sig=0x306e7, pf=0x80, revision=0x0
[   44.962149] microcode: CPU7 sig=0x306e7, pf=0x80, revision=0x0
[   44.962244] microcode: CPU8 sig=0x306e7, pf=0x80, revision=0x0
[   44.962342] microcode: CPU9 sig=0x306e7, pf=0x80, revision=0x0
[   44.962439] microcode: CPU10 sig=0x306e7, pf=0x80, revision=0x0
[   44.962556] microcode: CPU11 sig=0x306e7, pf=0x80, revision=0x0
[   44.962680] microcode: CPU12 sig=0x306e7, pf=0x80, revision=0x0
[   44.962801] microcode: CPU13 sig=0x306e7, pf=0x80, revision=0x0
[   44.962900] microcode: CPU14 sig=0x306e7, pf=0x80, revision=0x0
[   44.962985] microcode: CPU15 sig=0x306e7, pf=0x80, revision=0x0
[   44.963089] microcode: CPU16 sig=0x306e7, pf=0x80, revision=0x0
[   44.963183] microcode: CPU17 sig=0x306e7, pf=0x80, revision=0x0
[   44.963280] microcode: CPU18 sig=0x306e7, pf=0x80, revision=0x0
[   44.963385] microcode: CPU19 sig=0x306e7, pf=0x80, revision=0x0
[   44.963529] microcode: CPU20 sig=0x306e7, pf=0x80, revision=0x0
[   44.965070] microcode: CPU21 sig=0x306e7, pf=0x80, revision=0x0
[   45.135935] mpt2sas0-msix12: PCI-MSI-X enabled: IRQ 284
[   45.141571] microcode: CPU22 sig=0x306e7, pf=0x80, revision=0x0
[   45.141674] microcode: CPU23 sig=0x306e7, pf=0x80, revision=0x0
[   45.141796] microcode: CPU24 sig=0x306e7, pf=0x80, revision=0x0
[   45.141927] microcode: CPU25 sig=0x306e7, pf=0x80, revision=0x0
[   45.142028] microcode: CPU26 sig=0x306e7, pf=0x80, revision=0x0
[   45.142136] microcode: CPU27 sig=0x306e7, pf=0x80, revision=0x0
[   45.142260] microcode: CPU28 sig=0x306e7, pf=0x80, revision=0x0
[   45.142386] microcode: CPU29 sig=0x306e7, pf=0x80, revision=0x0
[   45.142493] microcode: CPU30 sig=0x306e7, pf=0x80, revision=0x0
[   45.142596] microcode: CPU31 sig=0x306e7, pf=0x80, revision=0x0
[   45.142746] microcode: CPU32 sig=0x306e7, pf=0x80, revision=0x0
[   45.142800] microcode: CPU33 sig=0x306e7, pf=0x80, revision=0x0
[   45.142903] microcode: CPU34 sig=0x306e7, pf=0x80, revision=0x0
[   45.143024] microcode: CPU35 sig=0x306e7, pf=0x80, revision=0x0
[   45.143162] microcode: CPU36 sig=0x306e7, pf=0x80, revision=0x0
[   45.143270] microcode: CPU37 sig=0x306e7, pf=0x80, revision=0x0
[   45.143393] microcode: CPU38 sig=0x306e7, pf=0x80, revision=0x0
[   45.143548] microcode: CPU39 sig=0x306e7, pf=0x80, revision=0x0
[   45.143674] microcode: CPU40 sig=0x306e7, pf=0x80, revision=0x0
[   45.143785] microcode: CPU41 sig=0x306e7, pf=0x80, revision=0x0
[   45.143936] microcode: CPU42 sig=0x306e7, pf=0x80, revision=0x0
[   45.144061] microcode: CPU43 sig=0x306e7, pf=0x80, revision=0x0
[   45.144179] microcode: CPU44 sig=0x306e7, pf=0x80, revision=0x0
[   45.144313] microcode: CPU45 sig=0x306e7, pf=0x80, revision=0x0
[   45.144476] microcode: CPU46 sig=0x306e7, pf=0x80, revision=0x0
[   45.144548] microcode: CPU47 sig=0x306e7, pf=0x80, revision=0x0
[   45.144631] microcode: CPU48 sig=0x306e7, pf=0x80, revision=0x0
[   45.144744] microcode: CPU49 sig=0x306e7, pf=0x80, revision=0x0
[   45.144851] microcode: CPU50 sig=0x306e7, pf=0x80, revision=0x0
[   45.144976] microcode: CPU51 sig=0x306e7, pf=0x80, revision=0x0
[   45.145122] microcode: CPU52 sig=0x306e7, pf=0x80, revision=0x0
[   45.145239] microcode: CPU53 sig=0x306e7, pf=0x80, revision=0x0
[   45.145329] microcode: CPU54 sig=0x306e7, pf=0x80, revision=0x0
[   45.145460] microcode: CPU55 sig=0x306e7, pf=0x80, revision=0x0
[   45.145532] microcode: CPU56 sig=0x306e7, pf=0x80, revision=0x0
[   45.145644] microcode: CPU57 sig=0x306e7, pf=0x80, revision=0x0
[   45.145741] microcode: CPU58 sig=0x306e7, pf=0x80, revision=0x0
[   45.145825] microcode: CPU59 sig=0x306e7, pf=0x80, revision=0x0
[   45.145946] microcode: CPU60 sig=0x306e7, pf=0x80, revision=0x0
[   45.146063] microcode: CPU61 sig=0x306e7, pf=0x80, revision=0x0
[   45.146167] microcode: CPU62 sig=0x306e7, pf=0x80, revision=0x0
[   45.146284] microcode: CPU63 sig=0x306e7, pf=0x80, revision=0x0
[   45.146401] microcode: CPU64 sig=0x306e7, pf=0x80, revision=0x0
[   45.146526] microcode: CPU65 sig=0x306e7, pf=0x80, revision=0x0
[   45.146629] microcode: CPU66 sig=0x306e7, pf=0x80, revision=0x0
[   45.146711] microcode: CPU67 sig=0x306e7, pf=0x80, revision=0x0
[   45.146834] microcode: CPU68 sig=0x306e7, pf=0x80, revision=0x0
[   45.146951] microcode: CPU69 sig=0x306e7, pf=0x80, revision=0x0
[   45.147069] microcode: CPU70 sig=0x306e7, pf=0x80, revision=0x0
[   45.147173] microcode: CPU71 sig=0x306e7, pf=0x80, revision=0x0
[   45.147257] microcode: CPU72 sig=0x306e7, pf=0x80, revision=0x0
[   45.147341] microcode: CPU73 sig=0x306e7, pf=0x80, revision=0x0
[   45.147457] microcode: CPU74 sig=0x306e7, pf=0x80, revision=0x0
[   45.147550] microcode: CPU75 sig=0x306e7, pf=0x80, revision=0x0
[   45.147647] microcode: CPU76 sig=0x306e7, pf=0x80, revision=0x0
[   45.147708] microcode: CPU77 sig=0x306e7, pf=0x80, revision=0x0
[   45.147840] microcode: CPU78 sig=0x306e7, pf=0x80, revision=0x0
[   45.147941] microcode: CPU79 sig=0x306e7, pf=0x80, revision=0x0
[   45.148200] microcode: CPU80 sig=0x306e7, pf=0x80, revision=0x0
[   45.148322] microcode: CPU81 sig=0x306e7, pf=0x80, revision=0x0
[   45.148399] microcode: CPU82 sig=0x306e7, pf=0x80, revision=0x0
[   45.148505] microcode: CPU83 sig=0x306e7, pf=0x80, revision=0x0
[   45.148658] microcode: CPU84 sig=0x306e7, pf=0x80, revision=0x0
[   45.148761] microcode: CPU85 sig=0x306e7, pf=0x80, revision=0x0
[   45.148844] microcode: CPU86 sig=0x306e7, pf=0x80, revision=0x0
[   45.148922] microcode: CPU87 sig=0x306e7, pf=0x80, revision=0x0
[   45.149018] microcode: CPU88 sig=0x306e7, pf=0x80, revision=0x0
[   45.149103] microcode: CPU89 sig=0x306e7, pf=0x80, revision=0x0
[   45.149213] microcode: CPU90 sig=0x306e7, pf=0x80, revision=0x0
[   45.149384] microcode: CPU91 sig=0x306e7, pf=0x80, revision=0x0
[   45.149461] microcode: CPU92 sig=0x306e7, pf=0x80, revision=0x0
[   45.149561] microcode: CPU93 sig=0x306e7, pf=0x80, revision=0x0
[   45.149664] microcode: CPU94 sig=0x306e7, pf=0x80, revision=0x0
[   45.149801] microcode: CPU95 sig=0x306e7, pf=0x80, revision=0x0
[   45.149893] microcode: CPU96 sig=0x306e7, pf=0x80, revision=0x0
[   45.150008] microcode: CPU97 sig=0x306e7, pf=0x80, revision=0x0
[   45.150101] microcode: CPU98 sig=0x306e7, pf=0x80, revision=0x0
[   45.150186] microcode: CPU99 sig=0x306e7, pf=0x80, revision=0x0
[   45.150345] microcode: CPU100 sig=0x306e7, pf=0x80, revision=0x0
[   45.150440] microcode: CPU101 sig=0x306e7, pf=0x80, revision=0x0
[   45.150558] microcode: CPU102 sig=0x306e7, pf=0x80, revision=0x0
[   45.150687] microcode: CPU103 sig=0x306e7, pf=0x80, revision=0x0
[   45.150780] microcode: CPU104 sig=0x306e7, pf=0x80, revision=0x0
[   45.150937] microcode: CPU105 sig=0x306e7, pf=0x80, revision=0x0
[   45.151032] microcode: CPU106 sig=0x306e7, pf=0x80, revision=0x0
[   45.151079] microcode: CPU107 sig=0x306e7, pf=0x80, revision=0x0
[   45.151190] microcode: CPU108 sig=0x306e7, pf=0x80, revision=0x0
[   45.151202] microcode: CPU109 sig=0x306e7, pf=0x80, revision=0x0
[   45.151329] microcode: CPU110 sig=0x306e7, pf=0x80, revision=0x0
[   45.151447] microcode: CPU111 sig=0x306e7, pf=0x80, revision=0x0
[   45.151531] microcode: CPU112 sig=0x306e7, pf=0x80, revision=0x0
[   45.151606] microcode: CPU113 sig=0x306e7, pf=0x80, revision=0x0
[   45.151688] microcode: CPU114 sig=0x306e7, pf=0x80, revision=0x0
[   45.151774] microcode: CPU115 sig=0x306e7, pf=0x80, revision=0x0
[   45.151940] microcode: CPU116 sig=0x306e7, pf=0x80, revision=0x0
[   45.152058] microcode: CPU117 sig=0x306e7, pf=0x80, revision=0x0
[   45.152175] microcode: CPU118 sig=0x306e7, pf=0x80, revision=0x0
[   45.152305] microcode: CPU119 sig=0x306e7, pf=0x80, revision=0x0
[   45.152871] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   45.908067] mpt2sas0-msix13: PCI-MSI-X enabled: IRQ 285
[   45.914845] mpt2sas0-msix14: PCI-MSI-X enabled: IRQ 286
[   45.921652] mpt2sas0-msix15: PCI-MSI-X enabled: IRQ 287
[   45.928272] mpt2sas0: iomem(0x0000000093340000), mapped(0xffffc9001dfc0000), size(65536)
[   45.938240] mpt2sas0: ioport(0x0000000000001000), size(256)
[   46.418098] mpt2sas0: Allocated physical memory: size(7101 kB)
[   46.425763] mpt2sas0: Current Controller Queue Depth(2811), Max Controller Queue Depth(3072)
[   46.437075] mpt2sas0: Scatter Gather Elements per IO(128)
[   46.676938] mpt2sas0: LSISAS2308: FWVersion(15.00.00.00), ChipRevision(0x05), BiosVersion(07.29.01.00)
[   46.689284] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[   46.706145] mpt2sas0: sending port enable !!
[   48.335358] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b005c34b20), phys(8)
[   54.456136] mpt2sas0: port enable: SUCCESS
[   54.462932] scsi 6:1:0:0: Direct-Access     LSI      Logical Volume   3000 PQ: 0 ANSI: 6
[   54.474289] scsi 6:1:0:0: RAID0: handle(0x011e), wwid(0x0d900f640c63339a), pd_count(2), type(SSP)
[   54.486104] scsi 6:1:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[   54.500534] scsi 6:0:0:0: Direct-Access     SEAGATE  ST9300653SS      0004 PQ: 0 ANSI: 6
[   54.511692] scsi 6:0:0:0: SSP: handle(0x0009), sas_addr(0x5000c50067b47751), phy(2), device_name(0x5000c50067b47750)
[   54.515679] scsi 6:0:0:0: SSP: enclosure_logical_id(0x500605b005c34b20), slot(1)
[   54.535386] scsi 6:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[   54.550676] scsi 6:0:1:0: Direct-Access     SEAGATE  ST9300653SS      0004 PQ: 0 ANSI: 6
[   54.561849] scsi 6:0:1:0: SSP: handle(0x000a), sas_addr(0x5000c50067b4697d), phy(3), device_name(0x5000c50067b4697c)
[   54.565837] scsi 6:0:1:0: SSP: enclosure_logical_id(0x500605b005c34b20), slot(0)
[   54.585555] scsi 6:0:1:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[   54.599694] sd 6:1:0:0: [sda] 1167966208 512-byte logical blocks: (597 GB/556 GiB)
[   54.600097] sd 6:1:0:0: Attached scsi generic sg1 type 0
[   54.601218] scsi 6:0:0:0: Attached scsi generic sg2 type 0
[   54.602257] scsi 6:0:1:0: Attached scsi generic sg3 type 0
[   54.651155] sd 6:1:0:0: [sda] 4096-byte physical blocks
[   54.658451] sd 6:1:0:0: [sda] Write Protect is off
[   54.664892] sd 6:1:0:0: [sda] Mode Sense: 03 00 00 08
[   54.671698] sd 6:1:0:0: [sda] No Caching mode page found
[   54.678700] sd 6:1:0:0: [sda] Assuming drive cache: write through
[   54.687696] sd 6:1:0:0: [sda] No Caching mode page found
[   54.694720] sd 6:1:0:0: [sda] Assuming drive cache: write through
[   54.705754]  sda: sda1 sda2 sda3
[   54.712799] sd 6:1:0:0: [sda] No Caching mode page found
[   54.719746] sd 6:1:0:0: [sda] Assuming drive cache: write through
[   54.727615] sd 6:1:0:0: [sda] Attached SCSI disk
[   55.934564] BUG: unable to handle kernel NULL pointer dereference at 000000000000015d
[   55.937722] IP: [<ffffffff81a44659>] __schedule+0x585/0x787
[   55.937722] PGD 103f54f067 PUD 103f528067 PMD 0 
[   55.937722] Oops: 0000 [#1] SMP 
[   55.937722] Modules linked in: x86_pkg_temp_thermal microcode mpt2sas ipmi_si ipmi_msghandler processor
[   55.937722] CPU: 91 PID: 375 Comm: migration/91 Not tainted 3.14.0-rc6-00004-g018e9d5 #1
[   55.937722] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BKLDSDP1.86B.0031.R01.1304221600 04/22/2013
[   55.937722] task: ffff8818545ad190 ti: ffff881854604000 task.ti: ffff881854604000
[   55.937722] RIP: 0010:[<ffffffff81a44659>]  [<ffffffff81a44659>] __schedule+0x585/0x787
[   55.937722] RSP: 0018:ffff881854605d78  EFLAGS: 00010246
[   55.937722] RAX: 000000000000005b RBX: ffff88185fa13000 RCX: 0000005b00000000
[   55.937722] RDX: ffff8818545ad640 RSI: ffff8818545ad190 RDI: ffff88185fa13000
[   55.937722] RBP: 000000000000024d R08: ffff881854604000 R09: 0000000000000073
[   55.937722] R10: 0000000000005c00 R11: 0000000000005b8d R12: ffff88103eb192c0
[   55.937722] R13: 0000000000000000 R14: 000000000000005b R15: ffff8818545ad190
[   55.937722] FS:  0000000000000000(0000) GS:ffff88185fa00000(0000) knlGS:0000000000000000
[   55.937722] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.937722] CR2: 000000000000015d CR3: 000000103f550000 CR4: 00000000001407e0
[   55.937722] Stack:
[   55.937722]  ffff8818546061f9 0000000000000000 0000000000000000 000000000000001e
[   55.937722]  0000000000000000 ffffffffffffffe4 0000000000000000 000000000000024d
[   55.937722]  0000000000000000 ffff881854605e09 0000000000000000 0000000000000000
[   55.937722] Call Trace:
[   55.937722] Code: 58 08 00 00 48 8b 40 60 48 8b 50 58 48 85 d2 74 05 48 89 df ff d2 4c 89 e6 48 89 df e8 c3 2e 00 00 c7 83 b4 08 00 00 00 00 00 00 <48> 8b 85 10 ff ff ff 65 ff 0c 25 50 b9 00 00 48 8b 80 38 e0 ff 
[   55.937722] RIP  [<ffffffff81a44659>] __schedule+0x585/0x787
[   55.937722]  RSP <ffff881854605d78>
[   55.937722] CR2: 000000000000015d
[   55.937722] ---[ end trace 905b5ff6abaedc72 ]---
[   55.937722] Kernel panic - not syncing: Fatal exception
[   55.937722] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   55.937722] Rebooting in 10 seconds..
[   55.937722] ACPI MEMORY or I/O RESET_REG.

--ADZbWkCsHQ7r3kzd--
