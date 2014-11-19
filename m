Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaKSCQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 21:16:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:23036 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbaKSCQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 21:16:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418446203"
Date: Wed, 19 Nov 2014 10:17:10 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [mm] kernel BUG at fs/xfs/xfs_aops.c:1069!
Message-ID: <20141119021710.GD3938@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma mm-numa-protnone-v1r7
commit 5733e3f48a1f2c9ea4eb1eba38c06f65a48891a4 ("mm: Convert p[te|md]_mknonnuma and remaining page table manipulations")


+------------------------------------------+------------+------------+
|                                          | 0f455f9110 | 5733e3f48a |
+------------------------------------------+------------+------------+
| boot_successes                           | 37         | 10         |
| early-boot-hang                          | 1          |            |
| boot_failures                            | 0          | 4          |
| kernel_BUG_at_fs/xfs/xfs_aops.c          | 0          | 4          |
| invalid_opcode                           | 0          | 4          |
| RIP:xfs_vm_writepage                     | 0          | 4          |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 4          |
| backtrace:vfs_fsync_range                | 0          | 4          |
| backtrace:SyS_msync                      | 0          | 4          |
+------------------------------------------+------------+------------+


2014-11-14 12:47:11 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:47:11 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
[  136.721372] ------------[ cut here ]------------
[  136.726793] kernel BUG at fs/xfs/xfs_aops.c:1069!
[  136.733766] invalid opcode: 0000 [#1] SMP 
[  136.738504] Modules linked in: loop ipmi_watchdog snd_pcm snd_timer snd soundcore pcspkr mgag200 syscopyarea sysfillrect sysimgblt ttm drm_kms_helper sb_edac drm edac_core i2c_i801 wmi ipmi_si ipmi_msghandler acpi_power_meter
[  136.761454] CPU: 5 PID: 7251 Comm: usemem Not tainted 3.18.0-rc4-wl-ath-g788be579 #1
[  136.770312] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.TP2.0025.R02.1403131625 03/13/2014
[  136.781911] task: ffff880852ab3ac0 ti: ffff88081db58000 task.ti: ffff88081db58000
[  136.790512] RIP: 0010:[<ffffffff8132b77c>]  [<ffffffff8132b77c>] xfs_vm_writepage+0x5fc/0x680
[  136.800315] RSP: 0018:ffff88081db5bba8  EFLAGS: 00010246
[  136.806515] RAX: 0020151e0000002d RBX: ffff88103c6202f8 RCX: 000000000000000c
[  136.814768] RDX: ffff88103c6202f8 RSI: ffff88081db5be40 RDI: ffffea002062e0c0
[  136.823032] RBP: ffff88081db5bc58 R08: 0000000000000002 R09: ffff88087ffda000
[  136.831302] R10: 0000000000000035 R11: 0000000000000000 R12: ffff88103c6201a8
[  136.839580] R13: 0000000000022951 R14: ffff88081db5be40 R15: ffffea002062e0c0
[  136.847865] FS:  00007f41ec7d4700(0000) GS:ffff88085f4a0000(0000) knlGS:0000000000000000
[  136.857235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  136.863994] CR2: 00007f41e8fcda08 CR3: 000000083bc17000 CR4: 00000000001407e0
[  136.872320] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  136.880650] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  136.888984] Stack:
[  136.891595]  0000000fb1c70000 ffff88103c6202f8 ffff88081db5be40 00007f4100000001
[  136.900285]  0000000100000001 ffffea002062e0c0 0000000000001000 0000000022952000
[  136.908988]  ffff88081db5bc38 ffffffff81329e28 ffff88081db5bc58 0000000000000000
[  136.917701] Call Trace:
[  136.920846]  [<ffffffff81329e28>] ? xfs_vm_set_page_dirty+0x138/0x190
[  136.928476]  [<ffffffff81169e47>] __writepage+0x17/0x50
[  136.934751]  [<ffffffff8116a86c>] write_cache_pages+0x21c/0x4f0
[  136.941809]  [<ffffffff8188c57e>] ? __wait_on_bit+0x7e/0x90
[  136.948485]  [<ffffffff81169e30>] ? global_dirtyable_memory+0x50/0x50
[  136.956144]  [<ffffffff8116ab80>] generic_writepages+0x40/0x60
[  136.963118]  [<ffffffff8132acb3>] xfs_vm_writepages+0x43/0x50
[  136.970007]  [<ffffffff8116c77e>] do_writepages+0x1e/0x30
[  136.976518]  [<ffffffff81160c89>] __filemap_fdatawrite_range+0x59/0x60
[  136.984297]  [<ffffffff81160d8a>] filemap_write_and_wait_range+0x2a/0x70
[  136.992281]  [<ffffffff81335cb7>] xfs_file_fsync+0x57/0x1d0
[  136.999015]  [<ffffffff8120bdfb>] vfs_fsync_range+0x1b/0x30
[  137.005749]  [<ffffffff8119978d>] SyS_msync+0x1ed/0x250
[  137.012104]  [<ffffffff818912a9>] system_call_fastpath+0x12/0x17
[  137.019341] Code: 8d 78 08 89 ca 48 c7 00 00 00 00 00 48 c7 44 10 f8 00 00 00 00 48 83 e7 f8 48 29 f8 01 c1 31 c0 c1 e9 03 f3 48 ab e9 44 ff ff ff <0f> 0b 31 c0 e9 5b fd ff ff 4d 85 f6 74 0e 4c 89 f7 89 45 98 e8 
[  137.042173] RIP  [<ffffffff8132b77c>] xfs_vm_writepage+0x5fc/0x680
[  137.049667]  RSP <ffff88081db5bba8>
[  137.054165] ---[ end trace f24aad15132e6627 ]---
[  137.059929] Kernel panic - not syncing: Fatal exception


	--yliu

--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-wl-ath-g788be579 (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Fri Nov 14 10:26:19 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-1T-msync-mt-x86_64-rhel-HEAD-788be5797c6941d1eff247c1a25c7853f28c2acb-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/vmlinuz-3.18.0-rc4-wl-ath-g788be579 kconfig=x86_64-rhel commit=788be5797c6941d1eff247c1a25c7853f28c2acb branch=linux-devel/devel-hourly-2014111410 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-hsw01/vm-scalability/performance-300s-1T-msync-mt/debian-x86_64.cgz/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/0 ip=::::lkp-hsw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000736c8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000736c9000-0x0000000073775fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000073776000-0x00000000781f8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000781f9000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7d9fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7da000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000107fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.TP2.0025.R02.1403131625 03/13/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x1080000 max_arch_pfn = 0x400000000
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
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x107f1bb000, 0x107f1bbfff] PGTABLE
[    0.000000] BRK [0x107f1bc000, 0x107f1bcfff] PGTABLE
[    0.000000] BRK [0x107f1bd000, 0x107f1bdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x107fe00000-0x107fffffff]
[    0.000000]  [mem 0x107fe00000-0x107fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x107c000000-0x107fdfffff]
[    0.000000]  [mem 0x107c000000-0x107fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x107bffffff]
[    0.000000]  [mem 0x1000000000-0x107bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x736c8fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x735fffff] page 2M
[    0.000000]  [mem 0x73600000-0x736c8fff] page 4k
[    0.000000] BRK [0x107f1be000, 0x107f1befff] PGTABLE
[    0.000000] BRK [0x107f1bf000, 0x107f1bffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x73776000-0x781f8fff]
[    0.000000]  [mem 0x73776000-0x737fffff] page 4k
[    0.000000]  [mem 0x73800000-0x77ffffff] page 2M
[    0.000000]  [mem 0x78000000-0x781f8fff] page 4k
[    0.000000] BRK [0x107f1c0000, 0x107f1c0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7b7da000-0x7b7fffff]
[    0.000000]  [mem 0x7b7da000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x10764a4000-0x107dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000007B7D80E8 0000B4 (v01 INTEL  INTEL ID 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007B7D7000 0000F4 (v04 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: DSDT 0x000000007B79D000 02FE63 (v02 INTEL  INTEL ID 00000003 INTL 20091013)
[    0.000000] ACPI: FACS 0x000000007B6FB000 000040
[    0.000000] ACPI: UEFI 0x000000007B6F3000 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: HPET 0x000000007B7D6000 000038 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: APIC 0x000000007B7D5000 00085C (v02 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MCFG 0x000000007B7D4000 00003C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: MIGT 0x000000007B7D3000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MSCT 0x000000007B7D2000 000090 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: PMCT 0x000000007B7D1000 000064 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SLIT 0x000000007B7D0000 00006C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SRAT 0x000000007B7CF000 000E30 (v03 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SVOS 0x000000007B7CE000 000032 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: WDDT 0x000000007B7CD000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SSDT 0x00000000736C9000 0ACA42 (v02 INTEL  SSDT  PM 00004000 INTL 20130328)
[    0.000000] ACPI: SSDT 0x000000007B79A000 00213C (v02 INTEL  SpsNm    00000002 INTL 20130328)
[    0.000000] ACPI: SSDT 0x000000007B799000 000064 (v02 INTEL  SpsNvs   00000002 INTL 20130328)
[    0.000000] ACPI: PRAD 0x000000007B798000 000102 (v02 INTEL  SpsPrAgg 00000002 INTL 20130328)
[    0.000000] ACPI: SPCR 0x000000007B797000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: DMAR 0x000000007B796000 000098 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
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
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NODE_DATA(0) allocated [mem 0x87ffda000-0x87fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x107ffd8000-0x107fffdfff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff881056400000-ffff8810763fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x107fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x736c8fff]
[    0.000000]   node   0: [mem 0x73776000-0x781f8fff]
[    0.000000]   node   0: [mem 0x7b7da000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x87fffffff]
[    0.000000] On node 0 totalpages: 8356112
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7622 pages used for memmap
[    0.000000]   DMA32 zone: 487794 pages, LIFO batch:31
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
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
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 88 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec40000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x736c9000-0x73775fff]
[    0.000000] PM: Registered nosave memory: [mem 0x781f9000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7d9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:144 nr_cpu_ids:144 nr_node_ids:2
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88085f400000 s89088 r8192 d29696 u131072
[    0.000000] pcpu-alloc: s89088 r8192 d29696 u131072 alloc=1*2097152
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
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 16483061
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-1T-msync-mt-x86_64-rhel-HEAD-788be5797c6941d1eff247c1a25c7853f28c2acb-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/vmlinuz-3.18.0-rc4-wl-ath-g788be579 kconfig=x86_64-rhel commit=788be5797c6941d1eff247c1a25c7853f28c2acb branch=linux-devel/devel-hourly-2014111410 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-hsw01/vm-scalability/performance-300s-1T-msync-mt/debian-x86_64.cgz/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/0 ip=::::lkp-hsw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 585728 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 486004(92%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 65699068K/66978880K available (8793K kernel code, 1676K rwdata, 3896K rodata, 1840K init, 1888K bss, 1279812K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=144.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:524544 nr_irqs:2392 0
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-143.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-wl-ath-g788be579 (kbuild@cairo) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Fri Nov 14 10:26:19 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-1T-msync-mt-x86_64-rhel-HEAD-788be5797c6941d1eff247c1a25c7853f28c2acb-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/vmlinuz-3.18.0-rc4-wl-ath-g788be579 kconfig=x86_64-rhel commit=788be5797c6941d1eff247c1a25c7853f28c2acb branch=linux-devel/devel-hourly-2014111410 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-hsw01/vm-scalability/performance-300s-1T-msync-mt/debian-x86_64.cgz/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/0 ip=::::lkp-hsw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000736c8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000736c9000-0x0000000073775fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000073776000-0x00000000781f8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000781f9000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7d9fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7da000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000107fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.TP2.0025.R02.1403131625 03/13/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x1080000 max_arch_pfn = 0x400000000
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
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x107f1bb000, 0x107f1bbfff] PGTABLE
[    0.000000] BRK [0x107f1bc000, 0x107f1bcfff] PGTABLE
[    0.000000] BRK [0x107f1bd000, 0x107f1bdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x107fe00000-0x107fffffff]
[    0.000000]  [mem 0x107fe00000-0x107fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x107c000000-0x107fdfffff]
[    0.000000]  [mem 0x107c000000-0x107fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x107bffffff]
[    0.000000]  [mem 0x1000000000-0x107bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0x736c8fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x735fffff] page 2M
[    0.000000]  [mem 0x73600000-0x736c8fff] page 4k
[    0.000000] BRK [0x107f1be000, 0x107f1befff] PGTABLE
[    0.000000] BRK [0x107f1bf000, 0x107f1bffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x73776000-0x781f8fff]
[    0.000000]  [mem 0x73776000-0x737fffff] page 4k
[    0.000000]  [mem 0x73800000-0x77ffffff] page 2M
[    0.000000]  [mem 0x78000000-0x781f8fff] page 4k
[    0.000000] BRK [0x107f1c0000, 0x107f1c0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7b7da000-0x7b7fffff]
[    0.000000]  [mem 0x7b7da000-0x7b7fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000]  [mem 0x100000000-0xfffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x10764a4000-0x107dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000007B7D80E8 0000B4 (v01 INTEL  INTEL ID 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007B7D7000 0000F4 (v04 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: DSDT 0x000000007B79D000 02FE63 (v02 INTEL  INTEL ID 00000003 INTL 20091013)
[    0.000000] ACPI: FACS 0x000000007B6FB000 000040
[    0.000000] ACPI: UEFI 0x000000007B6F3000 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: HPET 0x000000007B7D6000 000038 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: APIC 0x000000007B7D5000 00085C (v02 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MCFG 0x000000007B7D4000 00003C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: MIGT 0x000000007B7D3000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MSCT 0x000000007B7D2000 000090 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: PMCT 0x000000007B7D1000 000064 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SLIT 0x000000007B7D0000 00006C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SRAT 0x000000007B7CF000 000E30 (v03 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SVOS 0x000000007B7CE000 000032 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: WDDT 0x000000007B7CD000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SSDT 0x00000000736C9000 0ACA42 (v02 INTEL  SSDT  PM 00004000 INTL 20130328)
[    0.000000] ACPI: SSDT 0x000000007B79A000 00213C (v02 INTEL  SpsNm    00000002 INTL 20130328)
[    0.000000] ACPI: SSDT 0x000000007B799000 000064 (v02 INTEL  SpsNvs   00000002 INTL 20130328)
[    0.000000] ACPI: PRAD 0x000000007B798000 000102 (v02 INTEL  SpsPrAgg 00000002 INTL 20130328)
[    0.000000] ACPI: SPCR 0x000000007B797000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: DMAR 0x000000007B796000 000098 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
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
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x87fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x880000000-0x107fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NODE_DATA(0) allocated [mem 0x87ffda000-0x87fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x107ffd8000-0x107fffdfff]
[    0.000000]  [ffffea0000000000-ffffea0021ffffff] PMD -> [ffff88085fe00000-ffff88087fdfffff] on node 0
[    0.000000]  [ffffea0022000000-ffffea0041ffffff] PMD -> [ffff881056400000-ffff8810763fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x107fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x736c8fff]
[    0.000000]   node   0: [mem 0x73776000-0x781f8fff]
[    0.000000]   node   0: [mem 0x7b7da000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   1: [mem 0x880000000-0x107fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x87fffffff]
[    0.000000] On node 0 totalpages: 8356112
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7622 pages used for memmap
[    0.000000]   DMA32 zone: 487794 pages, LIFO batch:31
[    0.000000]   Normal zone: 122880 pages used for memmap
[    0.000000]   Normal zone: 7864320 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x880000000-0x107fffffff]
[    0.000000] On node 1 totalpages: 8388608
[    0.000000]   Normal zone: 131072 pages used for memmap
[    0.000000]   Normal zone: 8388608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
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
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 144 CPUs, 88 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
[    0.000000] mapped IOAPIC to ffffffffff57a000 (fec01000)
[    0.000000] mapped IOAPIC to ffffffffff579000 (fec40000)
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x736c9000-0x73775fff]
[    0.000000] PM: Registered nosave memory: [mem 0x781f9000-0x7accefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7accf000-0x7b6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b6ff000-0x7b7d9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b800000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:144 nr_cpu_ids:144 nr_node_ids:2
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88085f400000 s89088 r8192 d29696 u131072
[    0.000000] pcpu-alloc: s89088 r8192 d29696 u131072 alloc=1*2097152
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
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 16483061
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-1T-msync-mt-x86_64-rhel-HEAD-788be5797c6941d1eff247c1a25c7853f28c2acb-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/vmlinuz-3.18.0-rc4-wl-ath-g788be579 kconfig=x86_64-rhel commit=788be5797c6941d1eff247c1a25c7853f28c2acb branch=linux-devel/devel-hourly-2014111410 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-hsw01/vm-scalability/performance-300s-1T-msync-mt/debian-x86_64.cgz/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/0 ip=::::lkp-hsw01::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 585728 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 486004(92%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 65699068K/66978880K available (8793K kernel code, 1676K rwdata, 3896K rodata, 1840K init, 1888K bss, 1279812K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=144, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=144.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=144
[    0.000000] NR_IRQS:524544 nr_irqs:2392 0
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-143.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 268435456 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2593.872 MHz processor
[    0.000062] Calibrating delay loop (skipped), value calculated using timer frequency.. 5187.74 BogoMIPS (lpj=2593872)
[    0.011919] pid_max: default: 147456 minimum: 1152
[    0.017279] ACPI: Core revision 20140926
[    0.113013] ACPI: All ACPI Tables successfully acquired
[    0.119034] Security Framework initialized
[    0.123612] SELinux:  Initializing.
[    0.127514] SELinux:  Starting in permissive mode
[    0.136002] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.154969] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.167738] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.175666] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.184641] Initializing cgroup subsys memory
[    0.189529] Initializing cgroup subsys devices
[    0.194491] Initializing cgroup subsys freezer
[    0.199453] Initializing cgroup subsys net_cls
[    0.204414] Initializing cgroup subsys blkio
[    0.209180] Initializing cgroup subsys perf_event
[    0.214449] Initializing cgroup subsys hugetlb
[    0.219455] CPU: Physical Processor ID: 0
[    0.223929] CPU: Processor Core ID: 0
[    0.228737] mce: CPU supports 22 MCE banks
[    0.233341] CPU0: Thermal LVT vector (0xfa) already installed
[    0.239768] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.239768] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.254654] Freeing SMP alternatives memory: 36K (ffffffff81fd8000 - ffffffff81fe1000)
[    0.264525] ftrace: allocating 31169 entries in 122 pages
[    0.282544] Getting VERSION: 1060015
[    0.286534] Getting VERSION: 1060015
[    0.290523] Getting ID: 0
[    0.293444] Getting ID: 0
[    0.296374] dmar: Host address width 46
[    0.300653] dmar: DRHD base: 0x000000fbffc000 flags: 0x0
[    0.306588] dmar: IOMMU 0: reg_base_addr fbffc000 ver 1:0 cap d2078c106f0466 ecap f020df
[    0.315622] dmar: DRHD base: 0x000000c7ffc000 flags: 0x1
[    0.321553] dmar: IOMMU 1: reg_base_addr c7ffc000 ver 1:0 cap d2078c106f0466 ecap f020df
[    0.330586] dmar: RMRR base: 0x00000078a8e000 end: 0x00000078a90fff
[    0.337705] IOAPIC id 10 under DRHD base  0xfbffc000 IOMMU 0
[    0.344021] IOAPIC id 8 under DRHD base  0xc7ffc000 IOMMU 1
[    0.350241] IOAPIC id 9 under DRHD base  0xc7ffc000 IOMMU 1
[    0.356461] HPET id 0 under DRHD base 0xc7ffc000
[    0.361612] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.370764] Enabled IRQ remapping in x2apic mode
[    0.375924] masked ExtINT on CPU#0
[    0.380178] ENABLING IO-APIC IRQs
[    0.383876] init IO_APIC IRQs
[    0.387185]  apic 8 pin 0 not connected
[    0.391467] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.400310] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.415362] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.424203] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.439254] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.448106] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.463160] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.471995] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.487048] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.495890] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.510945] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.519779] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.534832] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.543673] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.558726] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.567568] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.582622] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.591464] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.606517] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.615360] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.630412] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.639448] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.654500] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.663537] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.678590] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.687625] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.702677] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.711713] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.726766] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.735802] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.750856] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.759884] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.774937]  apic 8 pin 16 not connected
[    0.779314]  apic 8 pin 17 not connected
[    0.783691]  apic 8 pin 18 not connected
[    0.788068]  apic 8 pin 19 not connected
[    0.792446]  apic 8 pin 20 not connected
[    0.796823]  apic 8 pin 21 not connected
[    0.801199]  apic 8 pin 22 not connected
[    0.805576]  apic 8 pin 23 not connected
[    0.809954]  apic 9 pin 0 not connected
[    0.814234]  apic 9 pin 1 not connected
[    0.818514]  apic 9 pin 2 not connected
[    0.822794]  apic 9 pin 3 not connected
[    0.827075]  apic 9 pin 4 not connected
[    0.831355]  apic 9 pin 5 not connected
[    0.835635]  apic 9 pin 6 not connected
[    0.839914]  apic 9 pin 7 not connected
[    0.844194]  apic 9 pin 8 not connected
[    0.848474]  apic 9 pin 9 not connected
[    0.852754]  apic 9 pin 10 not connected
[    0.857131]  apic 9 pin 11 not connected
[    0.861508]  apic 9 pin 12 not connected
[    0.865885]  apic 9 pin 13 not connected
[    0.870261]  apic 9 pin 14 not connected
[    0.874638]  apic 9 pin 15 not connected
[    0.879015]  apic 9 pin 16 not connected
[    0.883392]  apic 9 pin 17 not connected
[    0.887769]  apic 9 pin 18 not connected
[    0.892146]  apic 9 pin 19 not connected
[    0.896524]  apic 9 pin 20 not connected
[    0.900900]  apic 9 pin 21 not connected
[    0.905278]  apic 9 pin 22 not connected
[    0.909654]  apic 9 pin 23 not connected
[    0.914032]  apic 10 pin 0 not connected
[    0.918410]  apic 10 pin 1 not connected
[    0.922786]  apic 10 pin 2 not connected
[    0.927163]  apic 10 pin 3 not connected
[    0.931541]  apic 10 pin 4 not connected
[    0.935918]  apic 10 pin 5 not connected
[    0.940295]  apic 10 pin 6 not connected
[    0.944672]  apic 10 pin 7 not connected
[    0.949050]  apic 10 pin 8 not connected
[    0.953426]  apic 10 pin 9 not connected
[    0.957803]  apic 10 pin 10 not connected
[    0.962277]  apic 10 pin 11 not connected
[    0.966751]  apic 10 pin 12 not connected
[    0.971225]  apic 10 pin 13 not connected
[    0.975699]  apic 10 pin 14 not connected
[    0.980173]  apic 10 pin 15 not connected
[    0.984647]  apic 10 pin 16 not connected
[    0.989121]  apic 10 pin 17 not connected
[    0.993595]  apic 10 pin 18 not connected
[    0.998069]  apic 10 pin 19 not connected
[    1.002543]  apic 10 pin 20 not connected
[    1.007017]  apic 10 pin 21 not connected
[    1.011491]  apic 10 pin 22 not connected
[    1.015964]  apic 10 pin 23 not connected
[    1.020574] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.037289] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-2697 v3 @ 2.60GHz (fam: 06, model: 3f, stepping: 02)
[    1.047816] TSC deadline timer enabled
[    1.052043] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    1.063378] ... version:                3
[    1.067852] ... bit width:              48
[    1.072423] ... generic registers:      4
[    1.076897] ... value mask:             0000ffffffffffff
[    1.082826] ... max period:             0000ffffffffffff
[    1.088756] ... fixed-purpose events:   3
[    1.093231] ... event mask:             000000070000000f
[    1.102170] x86: Booting SMP configuration:
[    1.106839] .... node  #0, CPUs:          #1
[    1.122864] masked ExtINT on CPU#1
[    1.127624] CPU1: Thermal LVT vector (0xfa) already installed
[    1.138266] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.147350]    #2
[    1.160646] masked ExtINT on CPU#2
[    1.165405] CPU2: Thermal LVT vector (0xfa) already installed
[    1.174048]    #3
[    1.187254] masked ExtINT on CPU#3
[    1.192002] CPU3: Thermal LVT vector (0xfa) already installed
[    1.200654]    #4
[    1.213844] masked ExtINT on CPU#4
[    1.218592] CPU4: Thermal LVT vector (0xfa) already installed
[    1.227251]    #5
[    1.240442] masked ExtINT on CPU#5
[    1.245207] CPU5: Thermal LVT vector (0xfa) already installed
[    1.253855]    #6
[    1.267048] masked ExtINT on CPU#6
[    1.271814] CPU6: Thermal LVT vector (0xfa) already installed
[    1.280452]    #7
[    1.293641] masked ExtINT on CPU#7
[    1.298439] CPU7: Thermal LVT vector (0xfa) already installed
[    1.307153]    #8
[    1.320342] masked ExtINT on CPU#8
[    1.325139] CPU8: Thermal LVT vector (0xfa) already installed
[    1.333851]    #9
[    1.347042] masked ExtINT on CPU#9
[    1.351823] CPU9: Thermal LVT vector (0xfa) already installed
[    1.360555]   #10
[    1.373744] masked ExtINT on CPU#10
[    1.378619] CPU10: Thermal LVT vector (0xfa) already installed
[    1.387451]   #11
[    1.400738] masked ExtINT on CPU#11
[    1.405645] CPU11: Thermal LVT vector (0xfa) already installed
[    1.414450]   #12
[    1.427742] masked ExtINT on CPU#12
[    1.432653] CPU12: Thermal LVT vector (0xfa) already installed
[    1.441453]   #13
[    1.454741] masked ExtINT on CPU#13
[    1.459677] CPU13: Thermal LVT vector (0xfa) already installed
[    1.468472] 
[    1.470136] .... node  #1, CPUs:    #14
[    1.485561] masked ExtINT on CPU#14
[    1.490426] CPU14: Thermal LVT vector (0xfa) already installed
[    1.577088]   #15
[    1.590376] masked ExtINT on CPU#15
[    1.595223] CPU15: Thermal LVT vector (0xfa) already installed
[    1.603931]   #16
[    1.617115] masked ExtINT on CPU#16
[    1.621967] CPU16: Thermal LVT vector (0xfa) already installed
[    1.630657]   #17
[    1.643943] masked ExtINT on CPU#17
[    1.648779] CPU17: Thermal LVT vector (0xfa) already installed
[    1.657498]   #18
[    1.670683] masked ExtINT on CPU#18
[    1.675522] CPU18: Thermal LVT vector (0xfa) already installed
[    1.684227]   #19
[    1.697412] masked ExtINT on CPU#19
[    1.702244] CPU19: Thermal LVT vector (0xfa) already installed
[    1.710967]   #20
[    1.724153] masked ExtINT on CPU#20
[    1.729002] CPU20: Thermal LVT vector (0xfa) already installed
[    1.737696]   #21
[    1.750882] masked ExtINT on CPU#21
[    1.755774] CPU21: Thermal LVT vector (0xfa) already installed
[    1.764540]   #22
[    1.777726] masked ExtINT on CPU#22
[    1.782613] CPU22: Thermal LVT vector (0xfa) already installed
[    1.791370]   #23
[    1.804557] masked ExtINT on CPU#23
[    1.809428] CPU23: Thermal LVT vector (0xfa) already installed
[    1.818113]   #24
[    1.831403] masked ExtINT on CPU#24
[    1.836305] CPU24: Thermal LVT vector (0xfa) already installed
[    1.845046]   #25
[    1.858334] masked ExtINT on CPU#25
[    1.863239] CPU25: Thermal LVT vector (0xfa) already installed
[    1.871991]   #26
[    1.885281] masked ExtINT on CPU#26
[    1.890209] CPU26: Thermal LVT vector (0xfa) already installed
[    1.898922]   #27
[    1.912211] masked ExtINT on CPU#27
[    1.917142] CPU27: Thermal LVT vector (0xfa) already installed
[    1.925871] 
[    1.927533] .... node  #0, CPUs:    #28
[    1.942802] masked ExtINT on CPU#28
[    1.947679] CPU28: Thermal LVT vector (0xfa) already installed
[    1.956420]   #29
[    1.969614] masked ExtINT on CPU#29
[    1.974466] CPU29: Thermal LVT vector (0xfa) already installed
[    1.983225]   #30
[    1.996415] masked ExtINT on CPU#30
[    2.001266] CPU30: Thermal LVT vector (0xfa) already installed
[    2.010022]   #31
[    2.023121] masked ExtINT on CPU#31
[    2.027961] CPU31: Thermal LVT vector (0xfa) already installed
[    2.036729]   #32
[    2.049825] masked ExtINT on CPU#32
[    2.054666] CPU32: Thermal LVT vector (0xfa) already installed
[    2.063430]   #33
[    2.076526] masked ExtINT on CPU#33
[    2.081383] CPU33: Thermal LVT vector (0xfa) already installed
[    2.090137]   #34
[    2.103237] masked ExtINT on CPU#34
[    2.108087] CPU34: Thermal LVT vector (0xfa) already installed
[    2.116843]   #35
[    2.129948] masked ExtINT on CPU#35
[    2.134839] CPU35: Thermal LVT vector (0xfa) already installed
[    2.143658]   #36
[    2.156763] masked ExtINT on CPU#36
[    2.161651] CPU36: Thermal LVT vector (0xfa) already installed
[    2.170465]   #37
[    2.183564] masked ExtINT on CPU#37
[    2.188434] CPU37: Thermal LVT vector (0xfa) already installed
[    2.197172]   #38
[    2.210269] masked ExtINT on CPU#38
[    2.215141] CPU38: Thermal LVT vector (0xfa) already installed
[    2.223876]   #39
[    2.237068] masked ExtINT on CPU#39
[    2.241969] CPU39: Thermal LVT vector (0xfa) already installed
[    2.250774]   #40
[    2.263969] masked ExtINT on CPU#40
[    2.268876] CPU40: Thermal LVT vector (0xfa) already installed
[    2.277674]   #41
[    2.290868] masked ExtINT on CPU#41
[    2.295798] CPU41: Thermal LVT vector (0xfa) already installed
[    2.304589] 
[    2.306253] .... node  #1, CPUs:    #42
[    2.321574] masked ExtINT on CPU#42
[    2.326433] CPU42: Thermal LVT vector (0xfa) already installed
[    2.335120]   #43
[    2.348307] masked ExtINT on CPU#43
[    2.353154] CPU43: Thermal LVT vector (0xfa) already installed
[    2.361867]   #44
[    2.375054] masked ExtINT on CPU#44
[    2.379904] CPU44: Thermal LVT vector (0xfa) already installed
[    2.388597]   #45
[    2.401783] masked ExtINT on CPU#45
[    2.406618] CPU45: Thermal LVT vector (0xfa) already installed
[    2.415341]   #46
[    2.428430] masked ExtINT on CPU#46
[    2.433268] CPU46: Thermal LVT vector (0xfa) already installed
[    2.441971]   #47
[    2.455160] masked ExtINT on CPU#47
[    2.459998] CPU47: Thermal LVT vector (0xfa) already installed
[    2.468716]   #48
[    2.481809] masked ExtINT on CPU#48
[    2.486666] CPU48: Thermal LVT vector (0xfa) already installed
[    2.495359]   #49
[    2.508446] masked ExtINT on CPU#49
[    2.513334] CPU49: Thermal LVT vector (0xfa) already installed
[    2.522098]   #50
[    2.535185] masked ExtINT on CPU#50
[    2.540071] CPU50: Thermal LVT vector (0xfa) already installed
[    2.548827]   #51
[    2.561915] masked ExtINT on CPU#51
[    2.566786] CPU51: Thermal LVT vector (0xfa) already installed
[    2.575468]   #52
[    2.588656] masked ExtINT on CPU#52
[    2.593554] CPU52: Thermal LVT vector (0xfa) already installed
[    2.602303]   #53
[    2.615493] masked ExtINT on CPU#53
[    2.620397] CPU53: Thermal LVT vector (0xfa) already installed
[    2.629147]   #54
[    2.642335] masked ExtINT on CPU#54
[    2.647262] CPU54: Thermal LVT vector (0xfa) already installed
[    2.655977]   #55
[    2.669165] masked ExtINT on CPU#55
[    2.674093] CPU55: Thermal LVT vector (0xfa) already installed
[    2.682716] x86: Booted up 2 nodes, 56 CPUs
[    2.687389] smpboot: Total of 56 processors activated (290634.68 BogoMIPS)
[    2.851437] devtmpfs: initialized
[    2.855192] memory block size : 2048MB
[    2.860660] evm: security.selinux
[    2.864360] evm: security.ima
[    2.867670] evm: security.capability
[    2.871814] PM: Registering ACPI NVS region [mem 0x7accf000-0x7b6fefff] (10682368 bytes)
[    2.882164] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    2.890678] NET: Registered protocol family 16
[    2.900778] cpuidle: using governor menu
[    2.905280] ACPI: bus type PCI registered
[    2.909757] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.917065] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    2.927460] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    2.935325] PCI: Using configuration type 1 for base access
[    2.951945] ACPI: Added _OSI(Module Device)
[    2.956618] ACPI: Added _OSI(Processor Device)
[    2.961577] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.966830] ACPI: Added _OSI(Processor Aggregator Device)
[    2.981767] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    2.990615] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    3.136727] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    3.178271] ACPI: Interpreter enabled
[    3.182364] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    3.192685] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    3.203012] ACPI: (supports S0 S3 S4 S5)
[    3.207391] ACPI: Using IOAPIC for interrupt routing
[    3.212952] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    3.263559] ACPI: PCI Root Bridge [UNC1] (domain 0000 [bus ff])
[    3.270173] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.279310] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    3.286723] PCI host bridge to bus 0000:ff
[    3.291298] pci_bus 0000:ff: root bus resource [bus ff]
[    3.297140] pci 0000:ff:08.0: [8086:2f80] type 00 class 0x088000
[    3.303894] pci 0000:ff:08.2: [8086:2f32] type 00 class 0x110100
[    3.310639] pci 0000:ff:08.3: [8086:2f83] type 00 class 0x088000
[    3.317384] pci 0000:ff:09.0: [8086:2f90] type 00 class 0x088000
[    3.324121] pci 0000:ff:09.2: [8086:2f33] type 00 class 0x110100
[    3.330864] pci 0000:ff:09.3: [8086:2f93] type 00 class 0x088000
[    3.337612] pci 0000:ff:0b.0: [8086:2f81] type 00 class 0x088000
[    3.344353] pci 0000:ff:0b.1: [8086:2f36] type 00 class 0x110100
[    3.351096] pci 0000:ff:0b.2: [8086:2f37] type 00 class 0x110100
[    3.357838] pci 0000:ff:0c.0: [8086:2fe0] type 00 class 0x088000
[    3.364577] pci 0000:ff:0c.1: [8086:2fe1] type 00 class 0x088000
[    3.371317] pci 0000:ff:0c.2: [8086:2fe2] type 00 class 0x088000
[    3.378057] pci 0000:ff:0c.3: [8086:2fe3] type 00 class 0x088000
[    3.384797] pci 0000:ff:0c.4: [8086:2fe4] type 00 class 0x088000
[    3.391537] pci 0000:ff:0c.5: [8086:2fe5] type 00 class 0x088000
[    3.398279] pci 0000:ff:0c.6: [8086:2fe6] type 00 class 0x088000
[    3.405019] pci 0000:ff:0c.7: [8086:2fe7] type 00 class 0x088000
[    3.411760] pci 0000:ff:0d.0: [8086:2fe8] type 00 class 0x088000
[    3.418501] pci 0000:ff:0d.1: [8086:2fe9] type 00 class 0x088000
[    3.425243] pci 0000:ff:0d.2: [8086:2fea] type 00 class 0x088000
[    3.431983] pci 0000:ff:0d.3: [8086:2feb] type 00 class 0x088000
[    3.438724] pci 0000:ff:0d.4: [8086:2fec] type 00 class 0x088000
[    3.445465] pci 0000:ff:0d.5: [8086:2fed] type 00 class 0x088000
[    3.452208] pci 0000:ff:0f.0: [8086:2ff8] type 00 class 0x088000
[    3.458953] pci 0000:ff:0f.1: [8086:2ff9] type 00 class 0x088000
[    3.465694] pci 0000:ff:0f.2: [8086:2ffa] type 00 class 0x088000
[    3.472434] pci 0000:ff:0f.3: [8086:2ffb] type 00 class 0x088000
[    3.479173] pci 0000:ff:0f.4: [8086:2ffc] type 00 class 0x088000
[    3.485917] pci 0000:ff:0f.5: [8086:2ffd] type 00 class 0x088000
[    3.492659] pci 0000:ff:0f.6: [8086:2ffe] type 00 class 0x088000
[    3.499399] pci 0000:ff:10.0: [8086:2f1d] type 00 class 0x088000
[    3.506143] pci 0000:ff:10.1: [8086:2f34] type 00 class 0x110100
[    3.512887] pci 0000:ff:10.5: [8086:2f1e] type 00 class 0x088000
[    3.519629] pci 0000:ff:10.6: [8086:2f7d] type 00 class 0x110100
[    3.526371] pci 0000:ff:10.7: [8086:2f1f] type 00 class 0x088000
[    3.533112] pci 0000:ff:12.0: [8086:2fa0] type 00 class 0x088000
[    3.539856] pci 0000:ff:12.1: [8086:2f30] type 00 class 0x110100
[    3.546599] pci 0000:ff:12.4: [8086:2f60] type 00 class 0x088000
[    3.553344] pci 0000:ff:12.5: [8086:2f38] type 00 class 0x110100
[    3.560078] pci 0000:ff:13.0: [8086:2fa8] type 00 class 0x088000
[    3.566826] pci 0000:ff:13.1: [8086:2f71] type 00 class 0x088000
[    3.573569] pci 0000:ff:13.2: [8086:2faa] type 00 class 0x088000
[    3.580312] pci 0000:ff:13.3: [8086:2fab] type 00 class 0x088000
[    3.587059] pci 0000:ff:13.6: [8086:2fae] type 00 class 0x088000
[    3.593804] pci 0000:ff:13.7: [8086:2faf] type 00 class 0x088000
[    3.600536] pci 0000:ff:14.0: [8086:2fb0] type 00 class 0x088000
[    3.607282] pci 0000:ff:14.1: [8086:2fb1] type 00 class 0x088000
[    3.614029] pci 0000:ff:14.2: [8086:2fb2] type 00 class 0x088000
[    3.620773] pci 0000:ff:14.3: [8086:2fb3] type 00 class 0x088000
[    3.627519] pci 0000:ff:14.4: [8086:2fbc] type 00 class 0x088000
[    3.634264] pci 0000:ff:14.5: [8086:2fbd] type 00 class 0x088000
[    3.641007] pci 0000:ff:14.6: [8086:2fbe] type 00 class 0x088000
[    3.647751] pci 0000:ff:14.7: [8086:2fbf] type 00 class 0x088000
[    3.654497] pci 0000:ff:16.0: [8086:2f68] type 00 class 0x088000
[    3.661243] pci 0000:ff:16.1: [8086:2f79] type 00 class 0x088000
[    3.667990] pci 0000:ff:16.2: [8086:2f6a] type 00 class 0x088000
[    3.674736] pci 0000:ff:16.3: [8086:2f6b] type 00 class 0x088000
[    3.681484] pci 0000:ff:16.6: [8086:2f6e] type 00 class 0x088000
[    3.688227] pci 0000:ff:16.7: [8086:2f6f] type 00 class 0x088000
[    3.694972] pci 0000:ff:17.0: [8086:2fd0] type 00 class 0x088000
[    3.701721] pci 0000:ff:17.1: [8086:2fd1] type 00 class 0x088000
[    3.708465] pci 0000:ff:17.2: [8086:2fd2] type 00 class 0x088000
[    3.715213] pci 0000:ff:17.3: [8086:2fd3] type 00 class 0x088000
[    3.721960] pci 0000:ff:17.4: [8086:2fb8] type 00 class 0x088000
[    3.728702] pci 0000:ff:17.5: [8086:2fb9] type 00 class 0x088000
[    3.735446] pci 0000:ff:17.6: [8086:2fba] type 00 class 0x088000
[    3.742181] pci 0000:ff:17.7: [8086:2fbb] type 00 class 0x088000
[    3.748931] pci 0000:ff:1e.0: [8086:2f98] type 00 class 0x088000
[    3.755674] pci 0000:ff:1e.1: [8086:2f99] type 00 class 0x088000
[    3.762416] pci 0000:ff:1e.2: [8086:2f9a] type 00 class 0x088000
[    3.769158] pci 0000:ff:1e.3: [8086:2fc0] type 00 class 0x088000
[    3.775868] pci 0000:ff:1e.3: reg 0x10: [mem 0x00000010-0x0000001f pref]
[    3.783384] pci 0000:ff:1e.4: [8086:2f9c] type 00 class 0x088000
[    3.790130] pci 0000:ff:1f.0: [8086:2f88] type 00 class 0x088000
[    3.796875] pci 0000:ff:1f.2: [8086:2f8a] type 00 class 0x088000
[    3.803666] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus 7f])
[    3.810278] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.819413] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    3.826817] PCI host bridge to bus 0000:7f
[    3.831391] pci_bus 0000:7f: root bus resource [bus 7f]
[    3.837228] pci 0000:7f:08.0: [8086:2f80] type 00 class 0x088000
[    3.843972] pci 0000:7f:08.2: [8086:2f32] type 00 class 0x110100
[    3.850711] pci 0000:7f:08.3: [8086:2f83] type 00 class 0x088000
[    3.857453] pci 0000:7f:09.0: [8086:2f90] type 00 class 0x088000
[    3.864192] pci 0000:7f:09.2: [8086:2f33] type 00 class 0x110100
[    3.870934] pci 0000:7f:09.3: [8086:2f93] type 00 class 0x088000
[    3.877678] pci 0000:7f:0b.0: [8086:2f81] type 00 class 0x088000
[    3.884417] pci 0000:7f:0b.1: [8086:2f36] type 00 class 0x110100
[    3.891158] pci 0000:7f:0b.2: [8086:2f37] type 00 class 0x110100
[    3.897898] pci 0000:7f:0c.0: [8086:2fe0] type 00 class 0x088000
[    3.904639] pci 0000:7f:0c.1: [8086:2fe1] type 00 class 0x088000
[    3.911378] pci 0000:7f:0c.2: [8086:2fe2] type 00 class 0x088000
[    3.918115] pci 0000:7f:0c.3: [8086:2fe3] type 00 class 0x088000
[    3.924855] pci 0000:7f:0c.4: [8086:2fe4] type 00 class 0x088000
[    3.931593] pci 0000:7f:0c.5: [8086:2fe5] type 00 class 0x088000
[    3.938332] pci 0000:7f:0c.6: [8086:2fe6] type 00 class 0x088000
[    3.945072] pci 0000:7f:0c.7: [8086:2fe7] type 00 class 0x088000
[    3.951813] pci 0000:7f:0d.0: [8086:2fe8] type 00 class 0x088000
[    3.958554] pci 0000:7f:0d.1: [8086:2fe9] type 00 class 0x088000
[    3.965295] pci 0000:7f:0d.2: [8086:2fea] type 00 class 0x088000
[    3.972034] pci 0000:7f:0d.3: [8086:2feb] type 00 class 0x088000
[    3.978772] pci 0000:7f:0d.4: [8086:2fec] type 00 class 0x088000
[    3.985510] pci 0000:7f:0d.5: [8086:2fed] type 00 class 0x088000
[    3.992247] pci 0000:7f:0f.0: [8086:2ff8] type 00 class 0x088000
[    3.998984] pci 0000:7f:0f.1: [8086:2ff9] type 00 class 0x088000
[    4.005720] pci 0000:7f:0f.2: [8086:2ffa] type 00 class 0x088000
[    4.012460] pci 0000:7f:0f.3: [8086:2ffb] type 00 class 0x088000
[    4.019197] pci 0000:7f:0f.4: [8086:2ffc] type 00 class 0x088000
[    4.025937] pci 0000:7f:0f.5: [8086:2ffd] type 00 class 0x088000
[    4.032675] pci 0000:7f:0f.6: [8086:2ffe] type 00 class 0x088000
[    4.039416] pci 0000:7f:10.0: [8086:2f1d] type 00 class 0x088000
[    4.046154] pci 0000:7f:10.1: [8086:2f34] type 00 class 0x110100
[    4.052894] pci 0000:7f:10.5: [8086:2f1e] type 00 class 0x088000
[    4.059633] pci 0000:7f:10.6: [8086:2f7d] type 00 class 0x110100
[    4.066372] pci 0000:7f:10.7: [8086:2f1f] type 00 class 0x088000
[    4.073112] pci 0000:7f:12.0: [8086:2fa0] type 00 class 0x088000
[    4.079852] pci 0000:7f:12.1: [8086:2f30] type 00 class 0x110100
[    4.086593] pci 0000:7f:12.4: [8086:2f60] type 00 class 0x088000
[    4.093333] pci 0000:7f:12.5: [8086:2f38] type 00 class 0x110100
[    4.100075] pci 0000:7f:13.0: [8086:2fa8] type 00 class 0x088000
[    4.106816] pci 0000:7f:13.1: [8086:2f71] type 00 class 0x088000
[    4.113561] pci 0000:7f:13.2: [8086:2faa] type 00 class 0x088000
[    4.120295] pci 0000:7f:13.3: [8086:2fab] type 00 class 0x088000
[    4.127039] pci 0000:7f:13.6: [8086:2fae] type 00 class 0x088000
[    4.133771] pci 0000:7f:13.7: [8086:2faf] type 00 class 0x088000
[    4.140512] pci 0000:7f:14.0: [8086:2fb0] type 00 class 0x088000
[    4.147255] pci 0000:7f:14.1: [8086:2fb1] type 00 class 0x088000
[    4.153998] pci 0000:7f:14.2: [8086:2fb2] type 00 class 0x088000
[    4.160742] pci 0000:7f:14.3: [8086:2fb3] type 00 class 0x088000
[    4.167486] pci 0000:7f:14.4: [8086:2fbc] type 00 class 0x088000
[    4.174225] pci 0000:7f:14.5: [8086:2fbd] type 00 class 0x088000
[    4.180964] pci 0000:7f:14.6: [8086:2fbe] type 00 class 0x088000
[    4.187704] pci 0000:7f:14.7: [8086:2fbf] type 00 class 0x088000
[    4.194444] pci 0000:7f:16.0: [8086:2f68] type 00 class 0x088000
[    4.201187] pci 0000:7f:16.1: [8086:2f79] type 00 class 0x088000
[    4.207929] pci 0000:7f:16.2: [8086:2f6a] type 00 class 0x088000
[    4.214672] pci 0000:7f:16.3: [8086:2f6b] type 00 class 0x088000
[    4.221416] pci 0000:7f:16.6: [8086:2f6e] type 00 class 0x088000
[    4.228160] pci 0000:7f:16.7: [8086:2f6f] type 00 class 0x088000
[    4.234898] pci 0000:7f:17.0: [8086:2fd0] type 00 class 0x088000
[    4.241641] pci 0000:7f:17.1: [8086:2fd1] type 00 class 0x088000
[    4.248385] pci 0000:7f:17.2: [8086:2fd2] type 00 class 0x088000
[    4.255129] pci 0000:7f:17.3: [8086:2fd3] type 00 class 0x088000
[    4.261873] pci 0000:7f:17.4: [8086:2fb8] type 00 class 0x088000
[    4.268614] pci 0000:7f:17.5: [8086:2fb9] type 00 class 0x088000
[    4.275356] pci 0000:7f:17.6: [8086:2fba] type 00 class 0x088000
[    4.282098] pci 0000:7f:17.7: [8086:2fbb] type 00 class 0x088000
[    4.288847] pci 0000:7f:1e.0: [8086:2f98] type 00 class 0x088000
[    4.295587] pci 0000:7f:1e.1: [8086:2f99] type 00 class 0x088000
[    4.302325] pci 0000:7f:1e.2: [8086:2f9a] type 00 class 0x088000
[    4.309063] pci 0000:7f:1e.3: [8086:2fc0] type 00 class 0x088000
[    4.315773] pci 0000:7f:1e.3: reg 0x10: [mem 0x00000010-0x0000001f pref]
[    4.323280] pci 0000:7f:1e.4: [8086:2f9c] type 00 class 0x088000
[    4.330025] pci 0000:7f:1f.0: [8086:2f88] type 00 class 0x088000
[    4.336767] pci 0000:7f:1f.2: [8086:2f8a] type 00 class 0x088000
[    4.358562] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    4.365469] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    4.376838] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    4.386161] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    4.400374] PCI host bridge to bus 0000:00
[    4.404940] pci_bus 0000:00: root bus resource [bus 00-7e]
[    4.411065] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    4.417966] pci_bus 0000:00: root bus resource [io  0x1000-0x7fff]
[    4.424869] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    4.432546] pci_bus 0000:00: root bus resource [mem 0x90000000-0xc7ffbfff]
[    4.440222] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x383fffffffff]
[    4.448678] pci 0000:00:00.0: [8086:2f00] type 00 class 0x060000
[    4.455483] pci 0000:00:01.0: [8086:2f02] type 01 class 0x060400
[    4.462231] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    4.469089] pci 0000:00:01.0: System wakeup disabled by ACPI
[    4.475431] pci 0000:00:02.0: [8086:2f04] type 01 class 0x060400
[    4.482177] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    4.489037] pci 0000:00:02.0: System wakeup disabled by ACPI
[    4.495380] pci 0000:00:02.2: [8086:2f06] type 01 class 0x060400
[    4.502125] pci 0000:00:02.2: PME# supported from D0 D3hot D3cold
[    4.508982] pci 0000:00:02.2: System wakeup disabled by ACPI
[    4.515329] pci 0000:00:03.0: [8086:2f08] type 01 class 0x060400
[    4.522073] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    4.528929] pci 0000:00:03.0: System wakeup disabled by ACPI
[    4.535271] pci 0000:00:03.2: [8086:2f0a] type 01 class 0x060400
[    4.542014] pci 0000:00:03.2: PME# supported from D0 D3hot D3cold
[    4.548871] pci 0000:00:03.2: System wakeup disabled by ACPI
[    4.555214] pci 0000:00:05.0: [8086:2f28] type 00 class 0x088000
[    4.562014] pci 0000:00:05.1: [8086:2f29] type 00 class 0x088000
[    4.568821] pci 0000:00:05.2: [8086:2f2a] type 00 class 0x088000
[    4.575618] pci 0000:00:05.4: [8086:2f2c] type 00 class 0x080020
[    4.582320] pci 0000:00:05.4: reg 0x10: [mem 0x91d03000-0x91d03fff]
[    4.589426] pci 0000:00:11.0: [8086:8d7c] type 00 class 0xff0000
[    4.596293] pci 0000:00:14.0: [8086:8d31] type 00 class 0x0c0330
[    4.603014] pci 0000:00:14.0: reg 0x10: [mem 0x383ffff00000-0x383ffff0ffff 64bit]
[    4.611419] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    4.617998] pci 0000:00:14.0: System wakeup disabled by ACPI
[    4.624355] pci 0000:00:1a.0: [8086:8d2d] type 00 class 0x0c0320
[    4.631070] pci 0000:00:1a.0: reg 0x10: [mem 0x91d01000-0x91d013ff]
[    4.638151] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    4.645024] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    4.651372] pci 0000:00:1c.0: [8086:8d16] type 01 class 0x060400
[    4.658133] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    4.664992] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    4.671350] pci 0000:00:1d.0: [8086:8d26] type 00 class 0x0c0320
[    4.678072] pci 0000:00:1d.0: reg 0x10: [mem 0x91d00000-0x91d003ff]
[    4.685150] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    4.692020] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    4.698371] pci 0000:00:1f.0: [8086:8d44] type 00 class 0x060100
[    4.705245] pci 0000:00:1f.3: [8086:8d22] type 00 class 0x0c0500
[    4.711962] pci 0000:00:1f.3: reg 0x10: [mem 0x383ffff11000-0x383ffff110ff 64bit]
[    4.720335] pci 0000:00:1f.3: reg 0x20: [io  0x2000-0x201f]
[    4.726780] acpiphp: Slot [528] registered
[    4.731372] pci 0000:00:01.0: PCI bridge to [bus 01]
[    4.737058] acpiphp: Slot [512] registered
[    4.741648] pci 0000:00:02.0: PCI bridge to [bus 02]
[    4.747330] acpiphp: Slot [0] registered
[    4.751746] pci 0000:03:00.0: [8086:1528] type 00 class 0x020000
[    4.758470] pci 0000:03:00.0: reg 0x10: [mem 0x383fffc00000-0x383fffdfffff 64bit pref]
[    4.767324] pci 0000:03:00.0: reg 0x18: [io  0x1020-0x103f]
[    4.773565] pci 0000:03:00.0: reg 0x20: [mem 0x383fffe04000-0x383fffe07fff 64bit pref]
[    4.782461] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    4.789296] pci 0000:03:00.0: reg 0x184: [mem 0x91900000-0x91903fff 64bit]
[    4.796989] pci 0000:03:00.0: reg 0x190: [mem 0x91a00000-0x91a03fff 64bit]
[    4.804733] pci 0000:03:00.1: [8086:1528] type 00 class 0x020000
[    4.811457] pci 0000:03:00.1: reg 0x10: [mem 0x383fffa00000-0x383fffbfffff 64bit pref]
[    4.820311] pci 0000:03:00.1: reg 0x18: [io  0x1000-0x101f]
[    4.826551] pci 0000:03:00.1: reg 0x20: [mem 0x383fffe00000-0x383fffe03fff 64bit pref]
[    4.835448] pci 0000:03:00.1: PME# supported from D0 D3hot D3cold
[    4.842280] pci 0000:03:00.1: reg 0x184: [mem 0x91b00000-0x91b03fff 64bit]
[    4.849974] pci 0000:03:00.1: reg 0x190: [mem 0x91c00000-0x91c03fff 64bit]
[    4.859669] pci 0000:00:02.2: PCI bridge to [bus 03-04]
[    4.865505] pci 0000:00:02.2:   bridge window [io  0x1000-0x1fff]
[    4.872311] pci 0000:00:02.2:   bridge window [mem 0x91900000-0x91cfffff]
[    4.879892] pci 0000:00:02.2:   bridge window [mem 0x383fffa00000-0x383fffefffff 64bit pref]
[    4.889460] acpiphp: Slot [785] registered
[    4.894049] pci 0000:00:03.0: PCI bridge to [bus 05]
[    4.899735] acpiphp: Slot [786] registered
[    4.904325] pci 0000:00:03.2: PCI bridge to [bus 06]
[    4.909939] pci 0000:07:00.0: [102b:0522] type 00 class 0x030000
[    4.916669] pci 0000:07:00.0: reg 0x10: [mem 0x90000000-0x90ffffff pref]
[    4.924164] pci 0000:07:00.0: reg 0x14: [mem 0x91800000-0x91803fff]
[    4.931177] pci 0000:07:00.0: reg 0x18: [mem 0x91000000-0x917fffff]
[    4.938224] pci 0000:07:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    4.947723] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    4.953261] pci 0000:00:1c.0:   bridge window [mem 0x91000000-0x918fffff]
[    4.960845] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    4.969818] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    4.979338] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    4.988852] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    4.998368] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.007884] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.017398] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.026913] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.036428] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.045929] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    5.054967] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.070255] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    5.077159] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.087165] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    5.096244] PCI host bridge to bus 0000:80
[    5.100819] pci_bus 0000:80: root bus resource [bus 80-fe]
[    5.106943] pci_bus 0000:80: root bus resource [io  0x8000-0xffff]
[    5.113846] pci_bus 0000:80: root bus resource [mem 0xc8000000-0xfbffbfff]
[    5.121523] pci_bus 0000:80: root bus resource [mem 0x384000000000-0x387fffffffff]
[    5.129984] pci 0000:80:05.0: [8086:2f28] type 00 class 0x088000
[    5.136776] pci 0000:80:05.1: [8086:2f29] type 00 class 0x088000
[    5.143570] pci 0000:80:05.2: [8086:2f2a] type 00 class 0x088000
[    5.150352] pci 0000:80:05.4: [8086:2f2c] type 00 class 0x080020
[    5.157062] pci 0000:80:05.4: reg 0x10: [mem 0xc8000000-0xc8000fff]
[    5.164353] ACPI: Enabled 4 GPEs in block 00 to 3F
[    5.169891] vgaarb: setting as boot device: PCI:0000:07:00.0
[    5.176213] vgaarb: device added: PCI:0000:07:00.0,decodes=io+mem,owns=io+mem,locks=none
[    5.185252] vgaarb: loaded
[    5.188271] vgaarb: bridge control possible 0000:07:00.0
[    5.194325] SCSI subsystem initialized
[    5.198527] ACPI: bus type USB registered
[    5.203019] usbcore: registered new interface driver usbfs
[    5.209148] usbcore: registered new interface driver hub
[    5.215266] usbcore: registered new device driver usb
[    5.220924] pps_core: LinuxPPS API ver. 1 registered
[    5.226466] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    5.236672] PTP clock support registered
[    5.241369] PCI: Using ACPI for IRQ routing
[    5.249845] PCI: pci_cache_line_size set to 64 bytes
[    5.255502] pci 0000:ff:1e.3: can't claim BAR 0 [mem 0x00000010-0x0000001f pref]: no compatible bridge window
[    5.266601] pci 0000:7f:1e.3: can't claim BAR 0 [mem 0x00000010-0x0000001f pref]: no compatible bridge window
[    5.277701] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    5.284408] e820: reserve RAM buffer [mem 0x736c9000-0x73ffffff]
[    5.291114] e820: reserve RAM buffer [mem 0x781f9000-0x7bffffff]
[    5.297821] e820: reserve RAM buffer [mem 0x7b800000-0x7bffffff]
[    5.304641] NetLabel: Initializing
[    5.308437] NetLabel:  domain hash size = 128
[    5.313301] NetLabel:  protocols = UNLABELED CIPSOv4
[    5.318851] NetLabel:  unlabeled traffic allowed by default
[    5.325169] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    5.332172] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    5.340822] Switched to clocksource hpet
[    5.354383] pnp: PnP ACPI init
[    5.358508] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    5.367360] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.382429] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.389800] system 00:01: [io  0x0500-0x053f] has been reserved
[    5.396415] system 00:01: [io  0x0400-0x047f] could not be reserved
[    5.403415] system 00:01: [io  0x0540-0x057f] has been reserved
[    5.410026] system 00:01: [io  0x0600-0x061f] has been reserved
[    5.416638] system 00:01: [io  0x0ca0-0x0ca5] has been reserved
[    5.423250] system 00:01: [io  0x0880-0x0883] has been reserved
[    5.429864] system 00:01: [io  0x0800-0x081f] has been reserved
[    5.436476] system 00:01: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[    5.444254] system 00:01: [mem 0xfed45000-0xfed8bfff] has been reserved
[    5.451642] system 00:01: [mem 0xff000000-0xffffffff] could not be reserved
[    5.459410] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[    5.466798] system 00:01: [mem 0xfed12000-0xfed1200f] has been reserved
[    5.474186] system 00:01: [mem 0xfed12010-0xfed1201f] has been reserved
[    5.481574] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    5.488964] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.496674] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    5.505521] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.520613] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.528026] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    5.536874] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.551964] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.559314] pnp 00:04: Plug and Play ACPI device, IDs IPI0001 (active)
[    5.566823] pnp: PnP ACPI: found 5 devices
[    5.577389] pci 0000:07:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[    5.588475] pci 0000:ff:1e.3: BAR 0: no space for [mem size 0x00000010 pref]
[    5.596340] pci 0000:ff:1e.3: BAR 0: trying firmware assignment [mem size 0x00000010 pref]
[    5.605571] pci 0000:ff:1e.3: BAR 0: assigned [mem 0x00000010-0x0000001f pref]
[    5.613648] pci 0000:7f:1e.3: BAR 0: no space for [mem size 0x00000010 pref]
[    5.621523] pci 0000:7f:1e.3: BAR 0: trying firmware assignment [mem size 0x00000010 pref]
[    5.630746] pci 0000:7f:1e.3: BAR 0: [mem size 0x00000010 pref] conflicts with 0000:ff:1e.3 [mem 0x00000010-0x0000001f pref]
[    5.643277] pci 0000:7f:1e.3: BAR 0: failed to assign [mem size 0x00000010 pref]
[    5.651541] pci_bus 0000:7f: Some PCI device resources are unassigned, try booting with pci=realloc
[    5.661670] pci 0000:00:01.0: PCI bridge to [bus 01]
[    5.667222] pci 0000:00:02.0: PCI bridge to [bus 02]
[    5.672769] pci 0000:00:02.2: PCI bridge to [bus 03-04]
[    5.678605] pci 0000:00:02.2:   bridge window [io  0x1000-0x1fff]
[    5.685412] pci 0000:00:02.2:   bridge window [mem 0x91900000-0x91cfffff]
[    5.692988] pci 0000:00:02.2:   bridge window [mem 0x383fffa00000-0x383fffefffff 64bit pref]
[    5.702415] pci 0000:00:03.0: PCI bridge to [bus 05]
[    5.707962] pci 0000:00:03.2: PCI bridge to [bus 06]
[    5.713514] pci 0000:07:00.0: BAR 6: assigned [mem 0x91810000-0x9181ffff pref]
[    5.721583] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    5.727131] pci 0000:00:1c.0:   bridge window [mem 0x91000000-0x918fffff]
[    5.734715] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    5.743370] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    5.749593] pci_bus 0000:00: resource 5 [io  0x1000-0x7fff]
[    5.755817] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    5.762817] pci_bus 0000:00: resource 7 [mem 0x90000000-0xc7ffbfff]
[    5.769817] pci_bus 0000:00: resource 8 [mem 0x380000000000-0x383fffffffff]
[    5.777594] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    5.783817] pci_bus 0000:03: resource 1 [mem 0x91900000-0x91cfffff]
[    5.790817] pci_bus 0000:03: resource 2 [mem 0x383fffa00000-0x383fffefffff 64bit pref]
[    5.799661] pci_bus 0000:07: resource 1 [mem 0x91000000-0x918fffff]
[    5.806653] pci_bus 0000:07: resource 2 [mem 0x90000000-0x90ffffff 64bit pref]
[    5.814722] pci_bus 0000:80: resource 4 [io  0x8000-0xffff]
[    5.820947] pci_bus 0000:80: resource 5 [mem 0xc8000000-0xfbffbfff]
[    5.827947] pci_bus 0000:80: resource 6 [mem 0x384000000000-0x387fffffffff]
[    5.835807] NET: Registered protocol family 2
[    5.841330] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    5.850265] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    5.857890] TCP: Hash tables configured (established 524288 bind 65536)
[    5.865327] TCP: reno registered
[    5.869036] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    5.876222] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    5.884214] NET: Registered protocol family 1
[    5.889329] RPC: Registered named UNIX socket transport module.
[    5.895945] RPC: Registered udp transport module.
[    5.901200] RPC: Registered tcp transport module.
[    5.906454] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.913873] IOAPIC[0]: Set routing entry (8-19 -> 0x71 -> IRQ 19 Mode:1 Active:1 Dest:1)
[    5.922919] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:71 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.938126] IOAPIC[0]: Set routing entry (8-18 -> 0x81 -> IRQ 18 Mode:1 Active:1 Dest:1)
[    5.947170] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:81 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.962345] IOAPIC[0]: Set routing entry (8-18 -> 0x91 -> IRQ 18 Mode:1 Active:1 Dest:1)
[    5.971386] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.986520] pci 0000:07:00.0: Video device with shadowed ROM
[    5.992848] PCI: CLS 32 bytes, default 64
[    5.997364] Unpacking initramfs...
[    7.761985] Freeing initrd memory: 126320K (ffff8810764a4000 - ffff88107e000000)
[    7.770358] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    7.777552] software IO TLB [mem 0x741f9000-0x781f9000] (64MB) mapped at [ffff8800741f9000-ffff8800781f8fff]
[    7.793790] futex hash table entries: 65536 (order: 10, 4194304 bytes)
[    7.801594] Initialise system trusted keyring
[    7.806491] audit: initializing netlink subsys (disabled)
[    7.812532] audit: type=2000 audit(1415969099.733:1): initialized
[    7.819800] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    7.828036] zpool: loaded
[    7.830964] zbud: loaded
[    7.833993] VFS: Disk quotas dquot_6.5.2
[    7.838454] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    7.846501] SGI XFS with ACLs, security attributes, no debug enabled
[    7.854800] 9p: Installing v9fs 9p2000 file system support
[    7.860968] msgmni has been set to 32768
[    7.865439] Key type big_key registered
[    7.869725] SELinux:  Registering netfilter hooks
[    7.877847] NET: Registered protocol family 38
[    7.882815] Key type asymmetric registered
[    7.887389] Asymmetric key parser 'x509' registered
[    7.892871] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    7.901322] io scheduler noop registered
[    7.905705] io scheduler deadline registered (default)
[    7.911449] io scheduler cfq registered
[    7.916029] IOAPIC[1]: Set routing entry (9-23 -> 0xa1 -> IRQ 24 Mode:1 Active:1 Dest:1)
[    7.925073] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A1 Dest:00000001 SID:002C SQ:0 SVT:1)
[    7.940161] pcieport 0000:00:01.0: irq 25 for MSI/MSI-X
[    7.946118] pcieport 0000:00:02.0: irq 26 for MSI/MSI-X
[    7.952076] pcieport 0000:00:02.2: irq 27 for MSI/MSI-X
[    7.958032] pcieport 0000:00:03.0: irq 28 for MSI/MSI-X
[    7.963984] pcieport 0000:00:03.2: irq 29 for MSI/MSI-X
[    7.969926] IOAPIC[0]: Set routing entry (8-19 -> 0x42 -> IRQ 19 Mode:1 Active:1 Dest:1)
[    7.978967] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:42 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    7.994063] pcieport 0000:00:1c.0: irq 30 for MSI/MSI-X
[    7.999974] aer 0000:00:01.0:pcie02: service driver aer loaded
[    8.006507] aer 0000:00:02.0:pcie02: service driver aer loaded
[    8.013038] aer 0000:00:02.2:pcie02: service driver aer loaded
[    8.019570] aer 0000:00:03.0:pcie02: service driver aer loaded
[    8.026101] aer 0000:00:03.2:pcie02: service driver aer loaded
[    8.032626] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    8.040402] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    8.047882] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    8.055659] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    8.063148] pcieport 0000:00:02.2: Signaling PME through PCIe PME interrupt
[    8.070928] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    8.078219] pci 0000:03:00.1: Signaling PME through PCIe PME interrupt
[    8.085514] pcie_pme 0000:00:02.2:pcie01: service driver pcie_pme loaded
[    8.093003] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    8.100780] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    8.108270] pcieport 0000:00:03.2: Signaling PME through PCIe PME interrupt
[    8.116046] pcie_pme 0000:00:03.2:pcie01: service driver pcie_pme loaded
[    8.123541] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    8.131321] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    8.138614] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    8.146117] ioapic: probe of 0000:00:05.4 failed with error -22
[    8.152735] ioapic: probe of 0000:80:05.4 failed with error -22
[    8.159351] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.165585] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    8.173005] intel_idle: MWAIT substates: 0x2120
[    8.178065] intel_idle: v0.4 model 0x3F
[    8.182348] intel_idle: lapic_timer_reliable_states 0xffffffff
[    8.190351] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    8.198616] ACPI: Power Button [PWRF]
[    8.273912] GHES: HEST is not enabled!
[    8.278191] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    8.305855] serial 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    8.335370] serial 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    8.344621] Non-volatile memory driver v1.3
[    8.349306] Linux agpgart interface v0.103
[    8.354601] rdac: device handler registered
[    8.359343] hp_sw: device handler registered
[    8.364107] emc: device handler registered
[    8.368683] alua: device handler registered
[    8.373372] libphy: Fixed MDIO Bus: probed
[    8.378002] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    8.385875] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    8.392316] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    8.398830] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    8.405469] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
[    8.413342] igb: Copyright (c) 2007-2014 Intel Corporation.
[    8.419589] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    8.428237] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    8.434737] IOAPIC[1]: Set routing entry (9-13 -> 0xc2 -> IRQ 31 Mode:1 Active:1 Dest:1)
[    8.443779] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C2 Dest:00000001 SID:002C SQ:0 SVT:1)
[    8.789953] tsc: Refined TSC clocksource calibration: 2593.992 MHz
[    8.890362] ixgbe 0000:03:00.0: irq 32 for MSI/MSI-X
[    8.895938] ixgbe 0000:03:00.0: irq 33 for MSI/MSI-X
[    8.901505] ixgbe 0000:03:00.0: irq 34 for MSI/MSI-X
[    8.907069] ixgbe 0000:03:00.0: irq 35 for MSI/MSI-X
[    8.912633] ixgbe 0000:03:00.0: irq 36 for MSI/MSI-X
[    8.918197] ixgbe 0000:03:00.0: irq 37 for MSI/MSI-X
[    8.923760] ixgbe 0000:03:00.0: irq 38 for MSI/MSI-X
[    8.929311] ixgbe 0000:03:00.0: irq 39 for MSI/MSI-X
[    8.934871] ixgbe 0000:03:00.0: irq 40 for MSI/MSI-X
[    8.940433] ixgbe 0000:03:00.0: irq 41 for MSI/MSI-X
[    8.945991] ixgbe 0000:03:00.0: irq 42 for MSI/MSI-X
[    8.951550] ixgbe 0000:03:00.0: irq 43 for MSI/MSI-X
[    8.957110] ixgbe 0000:03:00.0: irq 44 for MSI/MSI-X
[    8.962688] ixgbe 0000:03:00.0: irq 45 for MSI/MSI-X
[    8.968247] ixgbe 0000:03:00.0: irq 46 for MSI/MSI-X
[    8.973803] ixgbe 0000:03:00.0: irq 47 for MSI/MSI-X
[    8.979360] ixgbe 0000:03:00.0: irq 48 for MSI/MSI-X
[    8.984915] ixgbe 0000:03:00.0: irq 49 for MSI/MSI-X
[    8.990474] ixgbe 0000:03:00.0: irq 50 for MSI/MSI-X
[    8.996031] ixgbe 0000:03:00.0: irq 51 for MSI/MSI-X
[    9.001589] ixgbe 0000:03:00.0: irq 52 for MSI/MSI-X
[    9.007146] ixgbe 0000:03:00.0: irq 53 for MSI/MSI-X
[    9.012703] ixgbe 0000:03:00.0: irq 54 for MSI/MSI-X
[    9.018260] ixgbe 0000:03:00.0: irq 55 for MSI/MSI-X
[    9.023816] ixgbe 0000:03:00.0: irq 56 for MSI/MSI-X
[    9.029370] ixgbe 0000:03:00.0: irq 57 for MSI/MSI-X
[    9.034925] ixgbe 0000:03:00.0: irq 58 for MSI/MSI-X
[    9.040483] ixgbe 0000:03:00.0: irq 59 for MSI/MSI-X
[    9.046037] ixgbe 0000:03:00.0: irq 60 for MSI/MSI-X
[    9.051586] ixgbe 0000:03:00.0: irq 61 for MSI/MSI-X
[    9.057141] ixgbe 0000:03:00.0: irq 62 for MSI/MSI-X
[    9.062696] ixgbe 0000:03:00.0: irq 63 for MSI/MSI-X
[    9.068252] ixgbe 0000:03:00.0: irq 64 for MSI/MSI-X
[    9.073818] ixgbe 0000:03:00.0: irq 65 for MSI/MSI-X
[    9.079373] ixgbe 0000:03:00.0: irq 66 for MSI/MSI-X
[    9.084928] ixgbe 0000:03:00.0: irq 67 for MSI/MSI-X
[    9.090482] ixgbe 0000:03:00.0: irq 68 for MSI/MSI-X
[    9.096038] ixgbe 0000:03:00.0: irq 69 for MSI/MSI-X
[    9.101591] ixgbe 0000:03:00.0: irq 70 for MSI/MSI-X
[    9.107145] ixgbe 0000:03:00.0: irq 71 for MSI/MSI-X
[    9.112699] ixgbe 0000:03:00.0: irq 74 for MSI/MSI-X
[    9.118244] ixgbe 0000:03:00.0: irq 75 for MSI/MSI-X
[    9.123797] ixgbe 0000:03:00.0: irq 76 for MSI/MSI-X
[    9.129351] ixgbe 0000:03:00.0: irq 77 for MSI/MSI-X
[    9.134905] ixgbe 0000:03:00.0: irq 78 for MSI/MSI-X
[    9.140459] ixgbe 0000:03:00.0: irq 79 for MSI/MSI-X
[    9.146005] ixgbe 0000:03:00.0: irq 80 for MSI/MSI-X
[    9.151561] ixgbe 0000:03:00.0: irq 81 for MSI/MSI-X
[    9.157118] ixgbe 0000:03:00.0: irq 82 for MSI/MSI-X
[    9.162686] ixgbe 0000:03:00.0: irq 83 for MSI/MSI-X
[    9.168239] ixgbe 0000:03:00.0: irq 84 for MSI/MSI-X
[    9.173796] ixgbe 0000:03:00.0: irq 85 for MSI/MSI-X
[    9.179350] ixgbe 0000:03:00.0: irq 86 for MSI/MSI-X
[    9.184903] ixgbe 0000:03:00.0: irq 87 for MSI/MSI-X
[    9.190457] ixgbe 0000:03:00.0: irq 88 for MSI/MSI-X
[    9.196011] ixgbe 0000:03:00.0: irq 89 for MSI/MSI-X
[    9.201565] ixgbe 0000:03:00.0: irq 90 for MSI/MSI-X
[    9.207227] ixgbe 0000:03:00.0: Multiqueue Enabled: Rx Queue count = 56, Tx Queue count = 56
[    9.277102] ixgbe 0000:03:00.0: PCI Express bandwidth of 32GT/s available
[    9.284704] ixgbe 0000:03:00.0: (Speed:5.0GT/s, Width: x8, Encoding Loss:20%)
[    9.332962] ixgbe 0000:03:00.0: MAC: 3, PHY: 3, PBA No: 000000-000
[    9.339873] ixgbe 0000:03:00.0: 00:1e:67:94:8e:21
[    9.490499] ixgbe 0000:03:00.0: Intel(R) 10 Gigabit Network Connection
[    9.497902] IOAPIC[1]: Set routing entry (9-10 -> 0xa7 -> IRQ 91 Mode:1 Active:1 Dest:1)
[    9.506948] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A7 Dest:00000001 SID:002C SQ:0 SVT:1)
[    9.797091] Switched to clocksource tsc
[    9.953710] ixgbe 0000:03:00.1: irq 92 for MSI/MSI-X
[    9.959278] ixgbe 0000:03:00.1: irq 93 for MSI/MSI-X
[    9.964838] ixgbe 0000:03:00.1: irq 94 for MSI/MSI-X
[    9.970399] ixgbe 0000:03:00.1: irq 95 for MSI/MSI-X
[    9.975957] ixgbe 0000:03:00.1: irq 96 for MSI/MSI-X
[    9.981516] ixgbe 0000:03:00.1: irq 97 for MSI/MSI-X
[    9.987093] ixgbe 0000:03:00.1: irq 98 for MSI/MSI-X
[    9.992650] ixgbe 0000:03:00.1: irq 99 for MSI/MSI-X
[    9.998207] ixgbe 0000:03:00.1: irq 100 for MSI/MSI-X
[   10.003858] ixgbe 0000:03:00.1: irq 101 for MSI/MSI-X
[   10.009504] ixgbe 0000:03:00.1: irq 102 for MSI/MSI-X
[   10.015154] ixgbe 0000:03:00.1: irq 103 for MSI/MSI-X
[   10.020807] ixgbe 0000:03:00.1: irq 104 for MSI/MSI-X
[   10.026459] ixgbe 0000:03:00.1: irq 105 for MSI/MSI-X
[   10.032111] ixgbe 0000:03:00.1: irq 106 for MSI/MSI-X
[   10.037762] ixgbe 0000:03:00.1: irq 107 for MSI/MSI-X
[   10.043406] ixgbe 0000:03:00.1: irq 108 for MSI/MSI-X
[   10.049059] ixgbe 0000:03:00.1: irq 109 for MSI/MSI-X
[   10.054711] ixgbe 0000:03:00.1: irq 110 for MSI/MSI-X
[   10.060361] ixgbe 0000:03:00.1: irq 111 for MSI/MSI-X
[   10.066014] ixgbe 0000:03:00.1: irq 112 for MSI/MSI-X
[   10.071663] ixgbe 0000:03:00.1: irq 113 for MSI/MSI-X
[   10.077343] ixgbe 0000:03:00.1: irq 114 for MSI/MSI-X
[   10.082995] ixgbe 0000:03:00.1: irq 115 for MSI/MSI-X
[   10.088646] ixgbe 0000:03:00.1: irq 116 for MSI/MSI-X
[   10.094287] ixgbe 0000:03:00.1: irq 117 for MSI/MSI-X
[   10.099937] ixgbe 0000:03:00.1: irq 118 for MSI/MSI-X
[   10.105585] ixgbe 0000:03:00.1: irq 119 for MSI/MSI-X
[   10.111236] ixgbe 0000:03:00.1: irq 120 for MSI/MSI-X
[   10.116877] ixgbe 0000:03:00.1: irq 121 for MSI/MSI-X
[   10.122526] ixgbe 0000:03:00.1: irq 122 for MSI/MSI-X
[   10.128174] ixgbe 0000:03:00.1: irq 123 for MSI/MSI-X
[   10.133825] ixgbe 0000:03:00.1: irq 124 for MSI/MSI-X
[   10.139472] ixgbe 0000:03:00.1: irq 125 for MSI/MSI-X
[   10.145121] ixgbe 0000:03:00.1: irq 126 for MSI/MSI-X
[   10.150768] ixgbe 0000:03:00.1: irq 127 for MSI/MSI-X
[   10.156424] ixgbe 0000:03:00.1: irq 128 for MSI/MSI-X
[   10.162072] ixgbe 0000:03:00.1: irq 129 for MSI/MSI-X
[   10.167738] ixgbe 0000:03:00.1: irq 130 for MSI/MSI-X
[   10.173386] ixgbe 0000:03:00.1: irq 131 for MSI/MSI-X
[   10.179034] ixgbe 0000:03:00.1: irq 132 for MSI/MSI-X
[   10.184683] ixgbe 0000:03:00.1: irq 133 for MSI/MSI-X
[   10.190332] ixgbe 0000:03:00.1: irq 134 for MSI/MSI-X
[   10.195980] ixgbe 0000:03:00.1: irq 135 for MSI/MSI-X
[   10.201627] ixgbe 0000:03:00.1: irq 136 for MSI/MSI-X
[   10.207274] ixgbe 0000:03:00.1: irq 137 for MSI/MSI-X
[   10.212921] ixgbe 0000:03:00.1: irq 138 for MSI/MSI-X
[   10.218570] ixgbe 0000:03:00.1: irq 139 for MSI/MSI-X
[   10.224219] ixgbe 0000:03:00.1: irq 140 for MSI/MSI-X
[   10.229867] ixgbe 0000:03:00.1: irq 141 for MSI/MSI-X
[   10.235516] ixgbe 0000:03:00.1: irq 142 for MSI/MSI-X
[   10.241164] ixgbe 0000:03:00.1: irq 143 for MSI/MSI-X
[   10.246812] ixgbe 0000:03:00.1: irq 144 for MSI/MSI-X
[   10.252460] ixgbe 0000:03:00.1: irq 145 for MSI/MSI-X
[   10.258126] ixgbe 0000:03:00.1: irq 146 for MSI/MSI-X
[   10.263774] ixgbe 0000:03:00.1: irq 147 for MSI/MSI-X
[   10.269422] ixgbe 0000:03:00.1: irq 148 for MSI/MSI-X
[   10.275181] ixgbe 0000:03:00.1: Multiqueue Enabled: Rx Queue count = 56, Tx Queue count = 56
[   10.345031] ixgbe 0000:03:00.1: PCI Express bandwidth of 32GT/s available
[   10.352617] ixgbe 0000:03:00.1: (Speed:5.0GT/s, Width: x8, Encoding Loss:20%)
[   10.400859] ixgbe 0000:03:00.1: MAC: 3, PHY: 3, PBA No: 000000-000
[   10.407769] ixgbe 0000:03:00.1: 00:1e:67:94:8e:22
[   10.557155] ixgbe 0000:03:00.1: Intel(R) 10 Gigabit Network Connection
[   10.564582] usbcore: registered new interface driver catc
[   10.570621] usbcore: registered new interface driver kaweth
[   10.576845] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   10.585109] usbcore: registered new interface driver pegasus
[   10.591433] usbcore: registered new interface driver rtl8150
[   10.597759] usbcore: registered new interface driver asix
[   10.603792] usbcore: registered new interface driver cdc_ether
[   10.610310] usbcore: registered new interface driver cdc_eem
[   10.616635] usbcore: registered new interface driver dm9601
[   10.622863] usbcore: registered new interface driver smsc75xx
[   10.629286] usbcore: registered new interface driver smsc95xx
[   10.635708] usbcore: registered new interface driver gl620a
[   10.641935] usbcore: registered new interface driver net1080
[   10.648260] usbcore: registered new interface driver plusb
[   10.654389] usbcore: registered new interface driver rndis_host
[   10.661003] usbcore: registered new interface driver cdc_subset
[   10.667617] usbcore: registered new interface driver zaurus
[   10.673843] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   10.682110] usbcore: registered new interface driver int51x1
[   10.688432] usbcore: registered new interface driver ipheth
[   10.694651] usbcore: registered new interface driver sierra_net
[   10.701432] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   10.707319] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[   10.715659] xhci_hcd 0000:00:14.0: cache line size of 32 is not supported
[   10.723288] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.730871] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.738928] usb usb1: Product: xHCI Host Controller
[   10.744375] usb usb1: Manufacturer: Linux 3.18.0-rc4-wl-ath-g788be579 xhci-hcd
[   10.752440] usb usb1: SerialNumber: 0000:00:14.0
[   10.757716] hub 1-0:1.0: USB hub found
[   10.761920] hub 1-0:1.0: 15 ports detected
[   10.768488] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   10.774375] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[   10.782655] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[   10.790243] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.798308] usb usb2: Product: xHCI Host Controller
[   10.803753] usb usb2: Manufacturer: Linux 3.18.0-rc4-wl-ath-g788be579 xhci-hcd
[   10.811818] usb usb2: SerialNumber: 0000:00:14.0
[   10.817075] hub 2-0:1.0: USB hub found
[   10.821274] hub 2-0:1.0: 6 ports detected
[   10.826680] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.833978] ehci-pci: EHCI PCI platform driver
[   10.839012] IOAPIC[0]: Set routing entry (8-18 -> 0x8c -> IRQ 18 Mode:1 Active:1 Dest:1)
[   10.848051] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:8C Dest:00000001 SID:F0FF SQ:0 SVT:1)
[   10.863133] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   10.869066] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   10.877336] ehci-pci 0000:00:1a.0: debug port 2
[   10.886296] ehci-pci 0000:00:1a.0: cache line size of 32 is not supported
[   10.893885] ehci-pci 0000:00:1a.0: irq 18, io mem 0x91d01000
[   10.906206] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   10.912643] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   10.920214] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.928279] usb usb3: Product: EHCI Host Controller
[   10.933724] usb usb3: Manufacturer: Linux 3.18.0-rc4-wl-ath-g788be579 ehci_hcd
[   10.941792] usb usb3: SerialNumber: 0000:00:1a.0
[   10.947092] hub 3-0:1.0: USB hub found
[   10.951288] hub 3-0:1.0: 2 ports detected
[   10.955909] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   10.961801] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[   10.970070] ehci-pci 0000:00:1d.0: debug port 2
[   10.979036] ehci-pci 0000:00:1d.0: cache line size of 32 is not supported
[   10.986619] ehci-pci 0000:00:1d.0: irq 18, io mem 0x91d00000
[   11.121396] usb 1-2: new low-speed USB device number 2 using xhci_hcd
[   11.127366] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   11.127390] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[   11.127391] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.127392] usb usb4: Product: EHCI Host Controller
[   11.127392] usb usb4: Manufacturer: Linux 3.18.0-rc4-wl-ath-g788be579 ehci_hcd
[   11.127393] usb usb4: SerialNumber: 0000:00:1d.0
[   11.127503] hub 4-0:1.0: USB hub found
[   11.127506] hub 4-0:1.0: 2 ports detected
[   11.127573] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.127578] ohci-pci: OHCI PCI platform driver
[   11.127595] uhci_hcd: USB Universal Host Controller Interface driver
[   11.127635] usbcore: registered new interface driver usbserial
[   11.127639] usbcore: registered new interface driver usbserial_generic
[   11.127643] usbserial: USB Serial support registered for generic
[   11.127658] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   11.474104] usb 1-2: New USB device found, idVendor=0557, idProduct=2220
[   11.481591] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.489550] usb 1-2: Product: ATEN  CS-1758/54
[   11.494510] usb 1-2: Manufacturer: ATEN
[   11.498859] usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[   11.508587] usb 1-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[   11.674702] usb 1-9: new full-speed USB device number 3 using xhci_hcd
[   11.866725] usb 1-9: New USB device found, idVendor=046b, idProduct=ff10
[   11.874211] usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   11.882182] usb 1-9: Product: Virtual Keyboard and Mouse
[   11.888114] usb 1-9: Manufacturer: American Megatrends Inc.
[   11.894334] usb 1-9: SerialNumber: serial
[   11.898890] usb 1-9: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[   12.164951] i8042: No controller found
[   12.169239] mousedev: PS/2 mouse device common for all mice
[   12.175616] rtc_cmos 00:00: RTC can wake from S4
[   12.180913] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   12.187746] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   12.196310] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   12.202546] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   12.214164] iTCO_vendor_support: vendor-support=0
[   12.219439] Intel P-state driver initializing.
[   12.227430] hidraw: raw HID events driver (C) Jiri Kosina
[   12.259441] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:0557:2220.0001/input/input1
[   12.271097] usb 3-1: new high-speed USB device number 2 using ehci-pci
[   12.279706] hid-generic 0003:0557:2220.0001: input,hidraw0: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:14.0-2/input0
[   12.312221] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:0557:2220.0002/input/input2
[   12.325229] hid-generic 0003:0557:2220.0002: input,hidraw1: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:14.0-2/input1
[   12.339370] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9:1.0/0003:046B:FF10.0003/input/input3
[   12.355247] hid-generic 0003:046B:FF10.0003: input,hidraw2: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:14.0-9/input0
[   12.371171] usb 4-1: new high-speed USB device number 2 using ehci-pci
[   12.379772] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-9/1-9:1.1/0003:046B:FF10.0004/input/input4
[   12.395586] hid-generic 0003:046B:FF10.0004: input,hidraw3: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:14.0-9/input1
[   12.411844] usbcore: registered new interface driver usbhid
[   12.411868] usb 3-1: New USB device found, idVendor=8087, idProduct=800a
[   12.411871] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   12.418187] hub 3-1:1.0: USB hub found
[   12.425617] hub 3-1:1.0: 6 ports detected
[   12.442227] usbhid: USB HID core driver
[   12.446645] drop_monitor: Initializing network drop monitor service
[   12.453987] TCP: cubic registered
[   12.457701] Initializing XFRM netlink socket
[   12.462750] NET: Registered protocol family 10
[   12.468773] NET: Registered protocol family 17
[   12.473766] 9pnet: Installing 9P2000 support
[   12.480258] 
[   12.480258] printing PIC contents
[   12.485629] ... PIC  IMR: ffff
[   12.489041] ... PIC  IRR: 0c20
[   12.492463] ... PIC  ISR: 0000
[   12.495880] ... PIC ELCR: 0e20
[   12.499328] printing local APIC contents on CPU#0/0:
[   12.504877] ... APIC ID:      00000000 (0)
[   12.509448] ... APIC VERSION: 01060015
[   12.513631] ... APIC TASKPRI: 00000000 (00)
[   12.518300] ... APIC PROCPRI: 00000000
[   12.522485] ... APIC LDR: 00000001
[   12.526281] ... APIC SPIV: 000001ff
[   12.530173] ... APIC ISR field:
[   12.533679] 0000000000000000000000000000000000000000000000000000000000000000
[   12.541630] ... APIC TMR field:
[   12.545135] 0000000002000000000200020000000000000000000000000000000000000000
[   12.553090] ... APIC IRR field:
[   12.556593] 0000000000000000000000000000000000000000000000000000000000000000
[   12.564542] ... APIC ESR: 00000000
[   12.568337] ... APIC ICR: 000008fd
[   12.572133] ... APIC ICR2: 000c0000
[   12.576025] ... APIC LVTT: 000400ef
[   12.579917] ... APIC LVTPC: 00000400
[   12.583907] ... APIC LVT0: 00010700
[   12.587798] ... APIC LVT1: 00000400
[   12.591690] ... APIC LVTERR: 000000fe
[   12.595776] ... APIC TMICT: 00000000
[   12.599766] ... APIC TMCCT: 00000000
[   12.603755] ... APIC TDCR: 00000000
[   12.607647] 
[   12.609310] number of MP IRQ sources: 15.
[   12.613781] number of IO-APIC #8 registers: 24.
[   12.618841] number of IO-APIC #9 registers: 24.
[   12.623901] number of IO-APIC #10 registers: 24.
[   12.629050] testing the IO APIC.......................
[   12.634785] IO APIC #8......
[   12.638002] .... register #00: 08000000
[   12.642285] .......    : physical APIC id: 08
[   12.647150] .......    : Delivery Type: 0
[   12.651628] .......    : LTS          : 0
[   12.656107] .... register #01: 00170020
[   12.660382] .......     : max redirection entries: 17
[   12.666025] .......     : PRQ implemented: 0
[   12.670784] .......     : IO APIC version: 20
[   12.675650] .... IRQ redirection table:
[   12.679937] 0   1    0    0   0   0    0     0    00
[   12.685487] 1   0    0    0   0   0    0     0    01
[   12.691035] 1   0    0    0   0   0    0     0    02
[   12.696582] 1   0    0    0   0   0    0     0    03
[   12.702131] 1   0    0    0   0   0    0     0    04
[   12.707679] 1   0    0    0   0   0    0     0    05
[   12.713228] 1   0    0    0   0   0    0     0    06
[   12.718776] 1   0    0    0   0   0    0     0    07
[   12.724324] 1   0    0    0   0   0    0     0    08
[   12.729873] 1   0    1    0   0   0    0     0    09
[   12.735422] 1   0    0    0   0   0    0     0    0A
[   12.740971] 1   0    0    0   0   0    0     0    0B
[   12.746520] 1   0    0    0   0   0    0     0    0C
[   12.752069] 1   0    0    0   0   0    0     0    0D
[   12.757615] 1   0    0    0   0   0    0     0    0E
[   12.763164] 1   0    0    0   0   0    0     0    0F
[   12.768712] 0   1    0    0   0   0    0     0    00
[   12.774261] 0   1    0    0   0   0    0     0    00
[   12.779809] 1   0    1    0   1   0    0     0    12
[   12.785358] 1   0    1    0   1   0    0     0    13
[   12.790906] 0   1    0    0   0   0    0     0    00
[   12.796455] 0   1    0    0   0   0    0     0    00
[   12.802002] 0   1    0    0   0   0    0     0    00
[   12.807551] 0   1    0    0   0   0    0     0    00
[   12.813099] IO APIC #9......
[   12.816315] .... register #00: 09000000
[   12.820598] .......    : physical APIC id: 09
[   12.825463] .......    : Delivery Type: 0
[   12.829942] .......    : LTS          : 0
[   12.834420] .... register #01: 00170020
[   12.838703] .......     : max redirection entries: 17
[   12.844345] .......     : PRQ implemented: 0
[   12.849113] .......     : IO APIC version: 20
[   12.853978] .... register #02: 00000000
[   12.858261] .......     : arbitration: 00
[   12.862740] .... register #03: 00000001
[   12.867023] .......     : Boot DT    : 1
[   12.871404] .... IRQ redirection table:
[   12.875689] 0   1    0    0   0   0    0     0    00
[   12.881236] 0   1    0    0   0   0    0     0    00
[   12.886783] 0   1    0    0   0   0    0     0    00
[   12.892330] 0   1    0    0   0   0    0     0    00
[   12.897877] 0   1    0    0   0   0    0     0    00
[   12.903424] 0   1    0    0   0   0    0     0    00
[   12.908971] 0   1    0    0   0   0    0     0    00
[   12.914519] 0   1    0    0   0   0    0     0    00
[   12.920066] 0   1    0    0   0   0    0     0    00
[   12.925613] 0   1    0    0   0   0    0     0    00
[   12.931160] 1   1    1    0   1   0    0     0    0A
[   12.936707] 0   1    0    0   0   0    0     0    00
[   12.942254] 0   1    0    0   0   0    0     0    00
[   12.947801] 1   1    1    0   1   0    0     0    0D
[   12.953347] 0   1    0    0   0   0    0     0    00
[   12.958894] 0   1    0    0   0   0    0     0    00
[   12.964441] 0   1    0    0   0   0    0     0    00
[   12.969985] 0   1    0    0   0   0    0     0    00
[   12.975533] 0   1    0    0   0   0    0     0    00
[   12.981079] 0   1    0    0   0   0    0     0    00
[   12.986626] 0   1    0    0   0   0    0     0    00
[   12.992174] 0   1    0    0   0   0    0     0    00
[   12.997722] 0   1    0    0   0   0    0     0    00
[   13.003270] 1   1    1    0   1   0    0     0    17
[   13.008817] IO APIC #10......
[   13.012131] .... register #00: 0A000000
[   13.016414] .......    : physical APIC id: 0A
[   13.021279] .......    : Delivery Type: 0
[   13.025757] .......    : LTS          : 0
[   13.030235] .... register #01: 00170020
[   13.034518] .......     : max redirection entries: 17
[   13.040161] .......     : PRQ implemented: 0
[   13.044929] .......     : IO APIC version: 20
[   13.049794] .... register #02: 00000000
[   13.054077] .......     : arbitration: 00
[   13.058555] .... register #03: 00000001
[   13.062830] .......     : Boot DT    : 1
[   13.067210] .... IRQ redirection table:
[   13.071495] 0   1    0    0   0   0    0     0    00
[   13.077041] 0   1    0    0   0   0    0     0    00
[   13.082588] 0   1    0    0   0   0    0     0    00
[   13.088134] 0   1    0    0   0   0    0     0    00
[   13.093671] 0   1    0    0   0   0    0     0    00
[   13.099209] 0   1    0    0   0   0    0     0    00
[   13.104756] 0   1    0    0   0   0    0     0    00
[   13.110303] 0   1    0    0   0   0    0     0    00
[   13.115850] 0   1    0    0   0   0    0     0    00
[   13.121396] 0   1    0    0   0   0    0     0    00
[   13.126944] 0   1    0    0   0   0    0     0    00
[   13.132491] 0   1    0    0   0   0    0     0    00
[   13.138038] 0   1    0    0   0   0    0     0    00
[   13.143584] 0   1    0    0   0   0    0     0    00
[   13.149131] 0   1    0    0   0   0    0     0    00
[   13.154678] 0   1    0    0   0   0    0     0    00
[   13.160224] 0   1    0    0   0   0    0     0    00
[   13.165771] 0   1    0    0   0   0    0     0    00
[   13.171318] 0   1    0    0   0   0    0     0    00
[   13.176864] 0   1    0    0   0   0    0     0    00
[   13.182411] 0   1    0    0   0   0    0     0    00
[   13.187958] 0   1    0    0   0   0    0     0    00
[   13.193504] 0   1    0    0   0   0    0     0    00
[   13.199051] 0   1    0    0   0   0    0     0    00
[   13.204595] IRQ to pin mappings:
[   13.208199] IRQ0 -> 0:2
[   13.210956] IRQ1 -> 0:1
[   13.213710] IRQ3 -> 0:3
[   13.216452] IRQ4 -> 0:4
[   13.219205] IRQ5 -> 0:5
[   13.221957] IRQ6 -> 0:6
[   13.224714] IRQ7 -> 0:7
[   13.227464] IRQ8 -> 0:8
[   13.230217] IRQ9 -> 0:9
[   13.232970] IRQ10 -> 0:10
[   13.235917] IRQ11 -> 0:11
[   13.238863] IRQ12 -> 0:12
[   13.241810] IRQ13 -> 0:13
[   13.244756] IRQ14 -> 0:14
[   13.247700] IRQ15 -> 0:15
[   13.250644] IRQ18 -> 0:18
[   13.253585] IRQ19 -> 0:19
[   13.256536] IRQ24 -> 1:23
[   13.259484] IRQ31 -> 1:13
[   13.262432] IRQ91 -> 1:10
[   13.265380] .................................... done.
[   13.271417] Loading compiled-in X.509 certificates
[   13.271482] usb 4-1: New USB device found, idVendor=8087, idProduct=8002
[   13.271483] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.271620] hub 4-1:1.0: USB hub found
[   13.271730] hub 4-1:1.0: 8 ports detected
[   13.302551] Loaded X.509 cert 'Magrathea: Glacier signing key: 365053020a296531aef39d984fd5357377664529'
[   13.313196] registered taskstats version 1
[   13.320940] Key type trusted registered
[   13.327910] Key type encrypted registered
[   13.334928] ima: No TPM chip found, activating TPM-bypass!
[   13.341180] evm: HMAC attrs: 0x1
[   13.346165] rtc_cmos 00:00: setting system clock to 2014-11-14 12:45:13 UTC (1415969113)
[   13.604198] pps pps0: new PPS source ptp0
[   13.608690] ixgbe 0000:03:00.0: registered PHC device on eth0
[   13.818642] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.071835] pps pps1: new PPS source ptp1
[   14.076326] ixgbe 0000:03:00.1: registered PHC device on eth1
[   14.285465] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   17.079494] ixgbe 0000:03:00.0 eth0: NIC Link is Up 1 Gbps, Flow Control: None
[   17.089564] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.100054] Sending DHCP requests .., OK
[   20.396184] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.172
[   20.405504] ixgbe 0000:03:00.1: removed PHC on eth1
[   20.826385] IP-Config: Complete:
[   20.830006]      device=eth0, hwaddr=00:1e:67:94:8e:21, ipaddr=192.168.1.172, mask=255.255.255.0, gw=192.168.1.1
[   20.841382]      host=lkp-hsw01, domain=lkp.intel.com, nis-domain=(none)
[   20.848868]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   20.856359]      nameserver0=192.168.1.1
[   20.860962] PM: Hibernation image not present or could not be loaded.
[   20.870076] Freeing unused kernel memory: 1840K (ffffffff81e0c000 - ffffffff81fd8000)
[   21.209758] ipmi message handler version 39.2
[   21.217339] IPMI System Interface driver.
[   21.221920] ipmi_si: probing via ACPI
[   21.226031] ipmi_si 00:04: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0
[   21.233531] ipmi_si: Adding ACPI-specified kcs state machine
[   21.239911] ipmi_si: probing via SMBIOS
[   21.244204] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   21.244823] wmi: Mapper loaded
[   21.254239] ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
[   21.262723] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   21.274079] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   21.280853] EDAC MC: Ver: 3.0.0
[   21.284748] [drm] Initialized drm 1.1.0 20060810
[   21.291494] EDAC sbridge: Seeking for: PCI ID 8086:2fa0
[   21.297337] EDAC sbridge: Seeking for: PCI ID 8086:2fa0
[   21.303179] EDAC sbridge: Seeking for: PCI ID 8086:2fa0
[   21.309022] EDAC sbridge: Seeking for: PCI ID 8086:2ffc
[   21.314868] EDAC sbridge: Seeking for: PCI ID 8086:2ffc
[   21.320708] EDAC sbridge: Seeking for: PCI ID 8086:2ffc
[   21.326548] EDAC sbridge: Seeking for: PCI ID 8086:2ffd
[   21.332390] EDAC sbridge: Seeking for: PCI ID 8086:2ffd
[   21.338231] EDAC sbridge: Seeking for: PCI ID 8086:2ffd
[   21.344073] EDAC sbridge: Seeking for: PCI ID 8086:2f60
[   21.347677] ipmi_si 00:04: Found new BMC (man_id: 0x000157, prod_id: 0x006f, dev_id: 0x21)
[   21.347683] ipmi_si 00:04: IPMI kcs interface initialized
[   21.365170] EDAC sbridge: Seeking for: PCI ID 8086:2f60
[   21.371010] EDAC sbridge: Seeking for: PCI ID 8086:2f60
[   21.376848] EDAC sbridge: Seeking for: PCI ID 8086:2fa8
[   21.382688] EDAC sbridge: Seeking for: PCI ID 8086:2fa8
[   21.388528] EDAC sbridge: Seeking for: PCI ID 8086:2fa8
[   21.394367] EDAC sbridge: Seeking for: PCI ID 8086:2f71
[   21.400207] EDAC sbridge: Seeking for: PCI ID 8086:2f71
[   21.406047] EDAC sbridge: Seeking for: PCI ID 8086:2f71
[   21.411884] EDAC sbridge: Seeking for: PCI ID 8086:2faa
[   21.417716] EDAC sbridge: Seeking for: PCI ID 8086:2faa
[   21.423555] EDAC sbridge: Seeking for: PCI ID 8086:2faa
[   21.429393] EDAC sbridge: Seeking for: PCI ID 8086:2fab
[   21.435232] EDAC sbridge: Seeking for: PCI ID 8086:2fab
[   21.441072] EDAC sbridge: Seeking for: PCI ID 8086:2fab
[   21.446910] EDAC sbridge: Seeking for: PCI ID 8086:2fac
[   21.452752] EDAC sbridge: Seeking for: PCI ID 8086:2fad
[   21.458594] EDAC sbridge: Seeking for: PCI ID 8086:2fbd
[   21.464433] EDAC sbridge: Seeking for: PCI ID 8086:2fbd
[   21.470273] EDAC sbridge: Seeking for: PCI ID 8086:2fbd
[   21.476111] EDAC sbridge: Seeking for: PCI ID 8086:2f68
[   21.481950] EDAC sbridge: Seeking for: PCI ID 8086:2f68
[   21.482139] IOAPIC[0]: Set routing entry (8-16 -> 0x77 -> IRQ 16 Mode:1 Active:1 Dest:1)
[   21.482143] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:77 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[   21.494793] [TTM] Zone  kernel: Available graphics memory: 32913632 kiB
[   21.494794] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   21.494794] [TTM] Initializing pool allocator
[   21.494797] [TTM] Initializing DMA pool allocator
[   21.536674] EDAC sbridge: Seeking for: PCI ID 8086:2f68
[   21.542513] EDAC sbridge: Seeking for: PCI ID 8086:2f79
[   21.548343] EDAC sbridge: Seeking for: PCI ID 8086:2f79
[   21.554182] EDAC sbridge: Seeking for: PCI ID 8086:2f79
[   21.560020] EDAC sbridge: Seeking for: PCI ID 8086:2f6a
[   21.565863] EDAC sbridge: Seeking for: PCI ID 8086:2f6a
[   21.571703] EDAC sbridge: Seeking for: PCI ID 8086:2f6a
[   21.577544] EDAC sbridge: Seeking for: PCI ID 8086:2f6b
[   21.583385] EDAC sbridge: Seeking for: PCI ID 8086:2f6b
[   21.589226] EDAC sbridge: Seeking for: PCI ID 8086:2f6b
[   21.594753] [drm:drm_edid_block_valid [drm]] *ERROR* EDID checksum is invalid, remainder is 193
[   21.594753] Raw EDID:
[   21.594754]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.594755]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.594755]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.594756]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.594756]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.594756]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.594757]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   21.594757]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.630649] [drm:drm_edid_block_valid [drm]] *ERROR* EDID checksum is invalid, remainder is 193
[   21.630650] Raw EDID:
[   21.630651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.630651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.630651]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.630652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.630652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.630652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.630653]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   21.630653]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.666560] [drm:drm_edid_block_valid [drm]] *ERROR* EDID checksum is invalid, remainder is 193
[   21.666560] Raw EDID:
[   21.666560]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.666561]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.666561]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.666562]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.666562]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.666562]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.666563]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   21.666563]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702497] [drm:drm_edid_block_valid [drm]] *ERROR* EDID checksum is invalid, remainder is 193
[   21.702497] Raw EDID:
[   21.702498]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702498]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702499]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702499]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702499]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702500]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702500]  	ff ff ff ff ff ff ff ff ff 5a 41 54 4e ff ff ff
[   21.702501]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   21.702502] mgag200 0000:07:00.0: VGA-1: Ignoring invalid EDID block 1.
[   21.856798] EDAC sbridge: Seeking for: PCI ID 8086:2f6c
[   21.856803] EDAC sbridge: Seeking for: PCI ID 8086:2f6d
[   21.856836] fbcon: mgadrmfb (fb0) is primary device
[   21.856976] EDAC MC0: Giving out device to module sbridge_edac.c controller Haswell Socket#0: DEV 0000:ff:12.0 (POLLED)
[   21.857099] EDAC MC1: Giving out device to module sbridge_edac.c controller Haswell Socket#1: DEV 0000:7f:12.0 (POLLED)
[   21.857099] EDAC sbridge: Driver loaded.
[   21.927876] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   21.954284] Error: Driver 'pcspkr' is already registered, aborting...
[   22.056042] Console: switching to colour frame buffer device 128x48
[   22.147503] mgag200 0000:07:00.0: fb0: mgadrmfb frame buffer device
[   22.154522] mgag200 0000:07:00.0: registered panic notifier
[   22.163160] [drm] Initialized mgag200 1.0.0 20110418 for 0000:07:00.0 on minor 0
[   22.611794] random: dd urandom read with 77 bits of entropy available

==> /tmp/lkp/stdout <==

==> /tmp/lkp/stderr <==

==> /tmp/lkp/stdout <==
14 Nov 12:45:28 ntpdate[2244]: step time server 192.168.1.1 offset -0.424261 sec
Kernel tests: Boot OK!
LKP: HOSTNAME lkp-hsw01, MAC 00:1e:67:94:8e:21, kernel 3.18.0-rc4-wl-ath-g788be579 1, serial console /dev/ttyS0
/lkp/lkp/src/bin/run-lkp
RESULT_ROOT=/result/lkp-hsw01/vm-scalability/performance-300s-1T-msync-mt/debian-x86_64.cgz/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/0
job=/lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-1T-msync-mt-x86_64-rhel-HEAD-788be5797c6941d1eff247c1a25c7853f28c2acb-0.yaml
run-job /lkp/scheduled/lkp-hsw01/cyclic_vm-scalability-performance-300s-1T-msync-mt-x86_64-rhel-HEAD-788be5797c6941d1eff247c1a25c7853f28c2acb-0.yaml
run: /lkp/lkp/src/setup/cpufreq_governor performance	{}
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu10/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu11/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu12/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu13/cpufreq/scaling_governor
run: /lkp/lkp/src/monitors/wrapper watch-oom	{}
run: /lkp/lkp/src/monitors/event/wait pre-test	{}
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu14/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu15/cpufreq/scaling_governor
run: /lkp/lkp/src/monitors/wrapper watchdog	{}
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu16/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu17/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu18/cpufreq/scaling_governor
[   30.053009] IPMI Watchdog: driver initialized
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu19/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu20/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu21/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu22/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu23/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu24/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu25/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu26/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu27/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu28/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu29/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu30/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu31/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu32/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu33/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu34/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu35/cpufreq/scaling_governor
2014-11-14 12:45:29 echo performance > /sys/devices/system/cpu/cpu36/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu37/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu38/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu39/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu40/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu41/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu42/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu43/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu44/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu45/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu46/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu47/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu48/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu49/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu50/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu51/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu52/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu53/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu54/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu55/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu8/cpufreq/scaling_governor
2014-11-14 12:45:30 echo performance > /sys/devices/system/cpu/cpu9/cpufreq/scaling_governor
run: /lkp/lkp/src/monitors/no-stdout/wrapper perf-profile	{}
run: /lkp/lkp/src/setup/runtime 300s	{}
run: /lkp/lkp/src/setup/size 1T	{}
run: pre-test
run: /lkp/lkp/src/monitors/wrapper uptime	{}
run: /lkp/lkp/src/monitors/wrapper iostat	{}
run: /lkp/lkp/src/monitors/wrapper vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-numastat	{}
run: /lkp/lkp/src/monitors/wrapper numa-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper numa-meminfo	{}
run: /lkp/lkp/src/monitors/wrapper proc-vmstat	{}
run: /lkp/lkp/src/monitors/wrapper proc-stat	{}
run: /lkp/lkp/src/monitors/wrapper meminfo	{}
run: /lkp/lkp/src/monitors/wrapper slabinfo	{}
run: /lkp/lkp/src/monitors/wrapper interrupts	{}
run: /lkp/lkp/src/monitors/wrapper lock_stat	{}
run: /lkp/lkp/src/monitors/wrapper latency_stats	{}
run: /lkp/lkp/src/monitors/wrapper softirqs	{}
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping	{}
run: /lkp/lkp/src/monitors/wrapper diskstats	{}
run: /lkp/lkp/src/monitors/wrapper cpuidle	{}
run: /lkp/lkp/src/monitors/wrapper cpufreq	{}
run: /lkp/lkp/src/monitors/wrapper turbostat	{}
run: /lkp/lkp/src/monitors/wrapper sched_debug	{"interval"=>"10"}
run: /usr/bin/time -v -o /tmp/lkp/time /lkp/lkp/src/tests/wrapper vm-scalability	{"test"=>"msync-mt"}
2014-11-14 12:45:31 mount -t tmpfs -o size=100% vm-scalability-tmp /tmp/vm-scalability-tmp
2014-11-14 12:45:31 truncate -s 67407118336 /tmp/vm-scalability.img
2014-11-14 12:45:31 mkfs.xfs -q /tmp/vm-scalability.img
2014-11-14 12:45:31 mount -o loop /tmp/vm-scalab
[   31.513904] loop: module loaded
ility.img /tmp/v
[   31.516619] XFS (loop0): Mounting V4 Filesystem
m-scalability
r
[   31.518692] XFS (loop0): Ending clean mount
epeat count: 65
2014-11-14 12:45:31 ./case-msync-mt
2014-11-14 12:45:31 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:45:31 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 4990729 usecs = 132487 KB/s
677080422 bytes / 4990727 usecs = 132487 KB/s
677080422 bytes / 4990740 usecs = 132487 KB/s
677080422 bytes / 4990746 usecs = 132487 KB/s
677080422 bytes / 4990737 usecs = 132487 KB/s
677080422 bytes / 4990726 usecs = 132488 KB/s
677080422 bytes / 4990748 usecs = 132487 KB/s
677080422 bytes / 4990751 usecs = 132487 KB/s
677080422 bytes / 4990758 usecs = 132487 KB/s
677080422 bytes / 4990761 usecs = 132487 KB/s
677080422 bytes / 4990772 usecs = 132486 KB/s
677080422 bytes / 4990772 usecs = 132486 KB/s
677080422 bytes / 4990773 usecs = 132486 KB/s
677080422 bytes / 4990772 usecs = 132486 KB/s
677080422 bytes / 4990773 usecs = 132486 KB/s
677080422 bytes / 4990773 usecs = 132486 KB/s
677080422 bytes / 4990774 usecs = 132486 KB/s
677080422 bytes / 4990774 usecs = 132486 KB/s
677080422 bytes / 4990775 usecs = 132486 KB/s
677080422 bytes / 4990775 usecs = 132486 KB/s
677080422 bytes / 4990776 usecs = 132486 KB/s
677080422 bytes / 4990778 usecs = 132486 KB/s
677080422 bytes / 4990780 usecs = 132486 KB/s
677080422 bytes / 4990780 usecs = 132486 KB/s
677080422 bytes / 4990779 usecs = 132486 KB/s
677080422 bytes / 4990781 usecs = 132486 KB/s
677080422 bytes / 4990779 usecs = 132486 KB/s
677080422 bytes / 4990783 usecs = 132486 KB/s
677080422 bytes / 4990776 usecs = 132486 KB/s
677080422 bytes / 4990777 usecs = 132486 KB/s
677080422 bytes / 4990782 usecs = 132486 KB/s
677080422 bytes / 4990783 usecs = 132486 KB/s
677080422 bytes / 4990776 usecs = 132486 KB/s
677080422 bytes / 4990780 usecs = 132486 KB/s
677080422 bytes / 4990783 usecs = 132486 KB/s
677080422 bytes / 4990775 usecs = 132486 KB/s
677080422 bytes / 4990784 usecs = 132486 KB/s
677080422 bytes / 4990782 usecs = 132486 KB/s
677080422 bytes / 4990784 usecs = 132486 KB/s
677080422 bytes / 4990784 usecs = 132486 KB/s
677080422 bytes / 4990782 usecs = 132486 KB/s
677080422 bytes / 4990815 usecs = 132485 KB/s
677080422 bytes / 4990848 usecs = 132484 KB/s
677080422 bytes / 4990913 usecs = 132483 KB/s
677080422 bytes / 4990936 usecs = 132482 KB/s
677080422 bytes / 4990971 usecs = 132481 KB/s
677080422 bytes / 4990977 usecs = 132481 KB/s
677080422 bytes / 4990978 usecs = 132481 KB/s
677080422 bytes / 4990989 usecs = 132481 KB/s
677080422 bytes / 4990987 usecs = 132481 KB/s
677080422 bytes / 4990995 usecs = 132480 KB/s
677080422 bytes / 4991001 usecs = 132480 KB/s
677080422 bytes / 4991005 usecs = 132480 KB/s
677080422 bytes / 4991006 usecs = 132480 KB/s
677080422 bytes / 4991017 usecs = 132480 KB/s
677080422 bytes / 4991795 usecs = 132459 KB/s
2014-11-14 12:45:36 ./case-msync-mt
2014-11-14 12:45:36 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:45:36 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 4985328 usecs = 132631 KB/s
677080422 bytes / 4985327 usecs = 132631 KB/s
677080422 bytes / 4985325 usecs = 132631 KB/s
677080422 bytes / 4985324 usecs = 132631 KB/s
677080422 bytes / 4985324 usecs = 132631 KB/s
677080422 bytes / 4985328 usecs = 132631 KB/s
677080422 bytes / 4985377 usecs = 132630 KB/s
677080422 bytes / 4985378 usecs = 132630 KB/s
677080422 bytes / 4985378 usecs = 132630 KB/s
677080422 bytes / 4985376 usecs = 132630 KB/s
677080422 bytes / 4985381 usecs = 132630 KB/s
677080422 bytes / 4985385 usecs = 132629 KB/s
677080422 bytes / 4985380 usecs = 132630 KB/s
677080422 bytes / 4985388 usecs = 132629 KB/s
677080422 bytes / 4985391 usecs = 132629 KB/s
677080422 bytes / 4985379 usecs = 132630 KB/s
677080422 bytes / 4985393 usecs = 132629 KB/s
677080422 bytes / 4985379 usecs = 132630 KB/s
677080422 bytes / 4985381 usecs = 132630 KB/s
677080422 bytes / 4985396 usecs = 132629 KB/s
677080422 bytes / 4985382 usecs = 132630 KB/s
677080422 bytes / 4985399 usecs = 132629 KB/s
677080422 bytes / 4985400 usecs = 132629 KB/s
677080422 bytes / 4985384 usecs = 132629 KB/s
677080422 bytes / 4985388 usecs = 132629 KB/s
677080422 bytes / 4985384 usecs = 132629 KB/s
677080422 bytes / 4985383 usecs = 132630 KB/s
677080422 bytes / 4985386 usecs = 132629 KB/s
677080422 bytes / 4985384 usecs = 132629 KB/s
677080422 bytes / 4985405 usecs = 132629 KB/s
677080422 bytes / 4985384 usecs = 132629 KB/s
677080422 bytes / 4985388 usecs = 132629 KB/s
677080422 bytes / 4985389 usecs = 132629 KB/s
677080422 bytes / 4985389 usecs = 132629 KB/s
677080422 bytes / 4985392 usecs = 132629 KB/s
677080422 bytes / 4985389 usecs = 132629 KB/s
677080422 bytes / 4985413 usecs = 132629 KB/s
677080422 bytes / 4985390 usecs = 132629 KB/s
677080422 bytes / 4985394 usecs = 132629 KB/s
677080422 bytes / 4985395 usecs = 132629 KB/s
677080422 bytes / 4985395 usecs = 132629 KB/s
677080422 bytes / 4985397 usecs = 132629 KB/s
677080422 bytes / 4985397 usecs = 132629 KB/s
677080422 bytes / 4985396 usecs = 132629 KB/s
677080422 bytes / 4985398 usecs = 132629 KB/s
677080422 bytes / 4985398 usecs = 132629 KB/s
677080422 bytes / 4985400 usecs = 132629 KB/s
677080422 bytes / 4985397 usecs = 132629 KB/s
677080422 bytes / 4985401 usecs = 132629 KB/s
677080422 bytes / 4985401 usecs = 132629 KB/s
677080422 bytes / 4985428 usecs = 132628 KB/s
677080422 bytes / 4985456 usecs = 132628 KB/s
677080422 bytes / 4985587 usecs = 132624 KB/s
677080422 bytes / 4985627 usecs = 132623 KB/s
677080422 bytes / 4985911 usecs = 132615 KB/s
677080422 bytes / 4986438 usecs = 132601 KB/s
2014-11-14 12:45:41 ./case-msync-mt
2014-11-14 12:45:41 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:45:41 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5795533 usecs = 114089 KB/s
677080422 bytes / 5795584 usecs = 114088 KB/s
677080422 bytes / 5795586 usecs = 114088 KB/s
677080422 bytes / 5795585 usecs = 114088 KB/s
677080422 bytes / 5795587 usecs = 114088 KB/s
677080422 bytes / 5795587 usecs = 114088 KB/s
677080422 bytes / 5795588 usecs = 114088 KB/s
677080422 bytes / 5795590 usecs = 114088 KB/s
677080422 bytes / 5795589 usecs = 114088 KB/s
677080422 bytes / 5795589 usecs = 114088 KB/s
677080422 bytes / 5795589 usecs = 114088 KB/s
677080422 bytes / 5795587 usecs = 114088 KB/s
677080422 bytes / 5795594 usecs = 114088 KB/s
677080422 bytes / 5795592 usecs = 114088 KB/s
677080422 bytes / 5795599 usecs = 114088 KB/s
677080422 bytes / 5795591 usecs = 114088 KB/s
677080422 bytes / 5795595 usecs = 114088 KB/s
677080422 bytes / 5795602 usecs = 114088 KB/s
677080422 bytes / 5795597 usecs = 114088 KB/s
677080422 bytes / 5795593 usecs = 114088 KB/s
677080422 bytes / 5795597 usecs = 114088 KB/s
677080422 bytes / 5795593 usecs = 114088 KB/s
677080422 bytes / 5795600 usecs = 114088 KB/s
677080422 bytes / 5795585 usecs = 114088 KB/s
677080422 bytes / 5795604 usecs = 114088 KB/s
677080422 bytes / 5795605 usecs = 114088 KB/s
677080422 bytes / 5795606 usecs = 114088 KB/s
677080422 bytes / 5795605 usecs = 114088 KB/s
677080422 bytes / 5795596 usecs = 114088 KB/s
677080422 bytes / 5795605 usecs = 114088 KB/s
677080422 bytes / 5795607 usecs = 114088 KB/s
677080422 bytes / 5795598 usecs = 114088 KB/s
677080422 bytes / 5795607 usecs = 114088 KB/s
677080422 bytes / 5795592 usecs = 114088 KB/s
677080422 bytes / 5795588 usecs = 114088 KB/s
677080422 bytes / 5795617 usecs = 114088 KB/s
677080422 bytes / 5795600 usecs = 114088 KB/s
677080422 bytes / 5795596 usecs = 114088 KB/s
677080422 bytes / 5795603 usecs = 114088 KB/s
677080422 bytes / 5795596 usecs = 114088 KB/s
677080422 bytes / 5795599 usecs = 114088 KB/s
677080422 bytes / 5795599 usecs = 114088 KB/s
677080422 bytes / 5795599 usecs = 114088 KB/s
677080422 bytes / 5795596 usecs = 114088 KB/s
677080422 bytes / 5795595 usecs = 114088 KB/s
677080422 bytes / 5795600 usecs = 114088 KB/s
677080422 bytes / 5795602 usecs = 114088 KB/s
677080422 bytes / 5795593 usecs = 114088 KB/s
677080422 bytes / 5795602 usecs = 114088 KB/s
677080422 bytes / 5795602 usecs = 114088 KB/s
677080422 bytes / 5795607 usecs = 114088 KB/s
677080422 bytes / 5795672 usecs = 114087 KB/s
677080422 bytes / 5795600 usecs = 114088 KB/s
677080422 bytes / 5795781 usecs = 114084 KB/s
677080422 bytes / 5796695 usecs = 114066 KB/s
677080422 bytes / 5798438 usecs = 114032 KB/s
2014-11-14 12:45:47 ./case-msync-mt
2014-11-14 12:45:47 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:45:47 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
[   50.387472] random: nonblocking pool is initialized
677080422 bytes / 5117014 usecs = 129218 KB/s
677080422 bytes / 5117020 usecs = 129218 KB/s
677080422 bytes / 5117011 usecs = 129218 KB/s
677080422 bytes / 5117019 usecs = 129218 KB/s
677080422 bytes / 5117030 usecs = 129217 KB/s
677080422 bytes / 5117030 usecs = 129217 KB/s
677080422 bytes / 5117056 usecs = 129217 KB/s
677080422 bytes / 5117058 usecs = 129217 KB/s
677080422 bytes / 5117058 usecs = 129217 KB/s
677080422 bytes / 5117060 usecs = 129217 KB/s
677080422 bytes / 5117056 usecs = 129217 KB/s
677080422 bytes / 5117062 usecs = 129216 KB/s
677080422 bytes / 5117058 usecs = 129217 KB/s
677080422 bytes / 5117063 usecs = 129216 KB/s
677080422 bytes / 5117060 usecs = 129217 KB/s
677080422 bytes / 5117061 usecs = 129217 KB/s
677080422 bytes / 5117061 usecs = 129217 KB/s
677080422 bytes / 5117065 usecs = 129216 KB/s
677080422 bytes / 5117063 usecs = 129216 KB/s
677080422 bytes / 5117064 usecs = 129216 KB/s
677080422 bytes / 5117064 usecs = 129216 KB/s
677080422 bytes / 5117067 usecs = 129216 KB/s
677080422 bytes / 5117059 usecs = 129217 KB/s
677080422 bytes / 5117075 usecs = 129216 KB/s
677080422 bytes / 5117061 usecs = 129217 KB/s
677080422 bytes / 5117067 usecs = 129216 KB/s
677080422 bytes / 5117068 usecs = 129216 KB/s
677080422 bytes / 5117069 usecs = 129216 KB/s
677080422 bytes / 5117066 usecs = 129216 KB/s
677080422 bytes / 5117070 usecs = 129216 KB/s
677080422 bytes / 5117066 usecs = 129216 KB/s
677080422 bytes / 5117070 usecs = 129216 KB/s
677080422 bytes / 5117071 usecs = 129216 KB/s
677080422 bytes / 5117071 usecs = 129216 KB/s
677080422 bytes / 5117075 usecs = 129216 KB/s
677080422 bytes / 5117071 usecs = 129216 KB/s
677080422 bytes / 5117072 usecs = 129216 KB/s
677080422 bytes / 5117074 usecs = 129216 KB/s
677080422 bytes / 5117071 usecs = 129216 KB/s
677080422 bytes / 5117069 usecs = 129216 KB/s
677080422 bytes / 5117075 usecs = 129216 KB/s
677080422 bytes / 5117075 usecs = 129216 KB/s
677080422 bytes / 5117077 usecs = 129216 KB/s
677080422 bytes / 5117067 usecs = 129216 KB/s
677080422 bytes / 5117081 usecs = 129216 KB/s
677080422 bytes / 5117077 usecs = 129216 KB/s
677080422 bytes / 5117078 usecs = 129216 KB/s
677080422 bytes / 5117076 usecs = 129216 KB/s
677080422 bytes / 5117076 usecs = 129216 KB/s
677080422 bytes / 5117078 usecs = 129216 KB/s
677080422 bytes / 5117108 usecs = 129215 KB/s
677080422 bytes / 5117252 usecs = 129212 KB/s
677080422 bytes / 5117263 usecs = 129211 KB/s
677080422 bytes / 5117275 usecs = 129211 KB/s
677080422 bytes / 5118079 usecs = 129191 KB/s
677080422 bytes / 5118913 usecs = 129170 KB/s
2014-11-14 12:45:52 ./case-msync-mt
2014-11-14 12:45:52 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:45:52 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5049535 usecs = 130944 KB/s
677080422 bytes / 5049527 usecs = 130945 KB/s
677080422 bytes / 5049523 usecs = 130945 KB/s
677080422 bytes / 5049545 usecs = 130944 KB/s
677080422 bytes / 5049524 usecs = 130945 KB/s
677080422 bytes / 5049546 usecs = 130944 KB/s
677080422 bytes / 5049548 usecs = 130944 KB/s
677080422 bytes / 5049549 usecs = 130944 KB/s
677080422 bytes / 5049548 usecs = 130944 KB/s
677080422 bytes / 5049551 usecs = 130944 KB/s
677080422 bytes / 5049551 usecs = 130944 KB/s
677080422 bytes / 5049543 usecs = 130944 KB/s
677080422 bytes / 5049553 usecs = 130944 KB/s
677080422 bytes / 5049549 usecs = 130944 KB/s
677080422 bytes / 5049546 usecs = 130944 KB/s
677080422 bytes / 5049547 usecs = 130944 KB/s
677080422 bytes / 5049533 usecs = 130945 KB/s
677080422 bytes / 5049546 usecs = 130944 KB/s
677080422 bytes / 5049549 usecs = 130944 KB/s
677080422 bytes / 5049548 usecs = 130944 KB/s
677080422 bytes / 5049550 usecs = 130944 KB/s
677080422 bytes / 5049550 usecs = 130944 KB/s
677080422 bytes / 5049553 usecs = 130944 KB/s
677080422 bytes / 5049548 usecs = 130944 KB/s
677080422 bytes / 5049556 usecs = 130944 KB/s
677080422 bytes / 5049552 usecs = 130944 KB/s
677080422 bytes / 5049552 usecs = 130944 KB/s
677080422 bytes / 5049555 usecs = 130944 KB/s
677080422 bytes / 5049550 usecs = 130944 KB/s
677080422 bytes / 5049552 usecs = 130944 KB/s
677080422 bytes / 5049563 usecs = 130944 KB/s
677080422 bytes / 5049707 usecs = 130940 KB/s
677080422 bytes / 5049710 usecs = 130940 KB/s
677080422 bytes / 5049718 usecs = 130940 KB/s
677080422 bytes / 5049724 usecs = 130940 KB/s
677080422 bytes / 5049726 usecs = 130940 KB/s
677080422 bytes / 5049730 usecs = 130939 KB/s
677080422 bytes / 5049737 usecs = 130939 KB/s
677080422 bytes / 5049744 usecs = 130939 KB/s
677080422 bytes / 5049745 usecs = 130939 KB/s
677080422 bytes / 5049749 usecs = 130939 KB/s
677080422 bytes / 5049749 usecs = 130939 KB/s
677080422 bytes / 5049758 usecs = 130939 KB/s
677080422 bytes / 5049761 usecs = 130939 KB/s
677080422 bytes / 5049766 usecs = 130939 KB/s
677080422 bytes / 5049768 usecs = 130938 KB/s
677080422 bytes / 5049772 usecs = 130938 KB/s
677080422 bytes / 5049784 usecs = 130938 KB/s
677080422 bytes / 5049784 usecs = 130938 KB/s
677080422 bytes / 5049793 usecs = 130938 KB/s
677080422 bytes / 5049800 usecs = 130938 KB/s
677080422 bytes / 5049808 usecs = 130937 KB/s
677080422 bytes / 5049809 usecs = 130937 KB/s
677080422 bytes / 5049810 usecs = 130937 KB/s
677080422 bytes / 5049821 usecs = 130937 KB/s
677080422 bytes / 5050583 usecs = 130917 KB/s
2014-11-14 12:45:57 ./case-msync-mt
2014-11-14 12:45:57 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:45:57 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5022309 usecs = 131654 KB/s
677080422 bytes / 5022324 usecs = 131654 KB/s
677080422 bytes / 5022327 usecs = 131654 KB/s
677080422 bytes / 5022329 usecs = 131654 KB/s
677080422 bytes / 5022307 usecs = 131654 KB/s
677080422 bytes / 5022328 usecs = 131654 KB/s
677080422 bytes / 5022331 usecs = 131654 KB/s
677080422 bytes / 5022334 usecs = 131654 KB/s
677080422 bytes / 5022336 usecs = 131654 KB/s
677080422 bytes / 5022333 usecs = 131654 KB/s
677080422 bytes / 5022309 usecs = 131654 KB/s
677080422 bytes / 5022338 usecs = 131654 KB/s
677080422 bytes / 5022314 usecs = 131654 KB/s
677080422 bytes / 5022340 usecs = 131654 KB/s
677080422 bytes / 5022318 usecs = 131654 KB/s
677080422 bytes / 5022342 usecs = 131653 KB/s
677080422 bytes / 5022321 usecs = 131654 KB/s
677080422 bytes / 5022329 usecs = 131654 KB/s
677080422 bytes / 5022347 usecs = 131653 KB/s
677080422 bytes / 5022347 usecs = 131653 KB/s
677080422 bytes / 5022351 usecs = 131653 KB/s
677080422 bytes / 5022331 usecs = 131654 KB/s
677080422 bytes / 5022357 usecs = 131653 KB/s
677080422 bytes / 5022332 usecs = 131654 KB/s
677080422 bytes / 5022359 usecs = 131653 KB/s
677080422 bytes / 5022334 usecs = 131654 KB/s
677080422 bytes / 5022314 usecs = 131654 KB/s
677080422 bytes / 5022330 usecs = 131654 KB/s
677080422 bytes / 5022319 usecs = 131654 KB/s
677080422 bytes / 5022331 usecs = 131654 KB/s
677080422 bytes / 5022333 usecs = 131654 KB/s
677080422 bytes / 5022332 usecs = 131654 KB/s
677080422 bytes / 5022332 usecs = 131654 KB/s
677080422 bytes / 5022332 usecs = 131654 KB/s
677080422 bytes / 5022329 usecs = 131654 KB/s
677080422 bytes / 5022307 usecs = 131654 KB/s
677080422 bytes / 5022334 usecs = 131654 KB/s
677080422 bytes / 5022334 usecs = 131654 KB/s
677080422 bytes / 5022335 usecs = 131654 KB/s
677080422 bytes / 5022331 usecs = 131654 KB/s
677080422 bytes / 5022330 usecs = 131654 KB/s
677080422 bytes / 5022346 usecs = 131653 KB/s
677080422 bytes / 5022333 usecs = 131654 KB/s
677080422 bytes / 5022321 usecs = 131654 KB/s
677080422 bytes / 5022312 usecs = 131654 KB/s
677080422 bytes / 5022418 usecs = 131651 KB/s
677080422 bytes / 5022420 usecs = 131651 KB/s
677080422 bytes / 5022485 usecs = 131650 KB/s
677080422 bytes / 5022508 usecs = 131649 KB/s
677080422 bytes / 5022350 usecs = 131653 KB/s
677080422 bytes / 5022563 usecs = 131648 KB/s
677080422 bytes / 5022565 usecs = 131648 KB/s
677080422 bytes / 5022573 usecs = 131647 KB/s
677080422 bytes / 5022573 usecs = 131647 KB/s
677080422 bytes / 5022580 usecs = 131647 KB/s
677080422 bytes / 5023387 usecs = 131626 KB/s
2014-11-14 12:46:02 ./case-msync-mt
2014-11-14 12:46:02 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:02 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 4957351 usecs = 133379 KB/s
677080422 bytes / 4957353 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957355 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957355 usecs = 133379 KB/s
677080422 bytes / 4957362 usecs = 133379 KB/s
677080422 bytes / 4957344 usecs = 133380 KB/s
677080422 bytes / 4957365 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957347 usecs = 133380 KB/s
677080422 bytes / 4957352 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957351 usecs = 133379 KB/s
677080422 bytes / 4957350 usecs = 133380 KB/s
677080422 bytes / 4957362 usecs = 133379 KB/s
677080422 bytes / 4957355 usecs = 133379 KB/s
677080422 bytes / 4957352 usecs = 133379 KB/s
677080422 bytes / 4957354 usecs = 133379 KB/s
677080422 bytes / 4957355 usecs = 133379 KB/s
677080422 bytes / 4957358 usecs = 133379 KB/s
677080422 bytes / 4957347 usecs = 133380 KB/s
677080422 bytes / 4957357 usecs = 133379 KB/s
677080422 bytes / 4957357 usecs = 133379 KB/s
677080422 bytes / 4957348 usecs = 133380 KB/s
677080422 bytes / 4957358 usecs = 133379 KB/s
677080422 bytes / 4957358 usecs = 133379 KB/s
677080422 bytes / 4957351 usecs = 133379 KB/s
677080422 bytes / 4957360 usecs = 133379 KB/s
677080422 bytes / 4957359 usecs = 133379 KB/s
677080422 bytes / 4957362 usecs = 133379 KB/s
677080422 bytes / 4957349 usecs = 133380 KB/s
677080422 bytes / 4957349 usecs = 133380 KB/s
677080422 bytes / 4957365 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957361 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957363 usecs = 133379 KB/s
677080422 bytes / 4957350 usecs = 133380 KB/s
677080422 bytes / 4957363 usecs = 133379 KB/s
677080422 bytes / 4957362 usecs = 133379 KB/s
677080422 bytes / 4957361 usecs = 133379 KB/s
677080422 bytes / 4957346 usecs = 133380 KB/s
677080422 bytes / 4957356 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957358 usecs = 133379 KB/s
677080422 bytes / 4957364 usecs = 133379 KB/s
677080422 bytes / 4957359 usecs = 133379 KB/s
677080422 bytes / 4957364 usecs = 133379 KB/s
677080422 bytes / 4957366 usecs = 133379 KB/s
677080422 bytes / 4957345 usecs = 133380 KB/s
677080422 bytes / 4957353 usecs = 133379 KB/s
677080422 bytes / 4957626 usecs = 133372 KB/s
677080422 bytes / 4957638 usecs = 133372 KB/s
677080422 bytes / 4958650 usecs = 133345 KB/s
677080422 bytes / 4957347 usecs = 133380 KB/s
2014-11-14 12:46:07 ./case-msync-mt
2014-11-14 12:46:07 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:07 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5044023 usecs = 131088 KB/s
677080422 bytes / 5044014 usecs = 131088 KB/s
677080422 bytes / 5044025 usecs = 131088 KB/s
677080422 bytes / 5044003 usecs = 131088 KB/s
677080422 bytes / 5044003 usecs = 131088 KB/s
677080422 bytes / 5044015 usecs = 131088 KB/s
677080422 bytes / 5044030 usecs = 131087 KB/s
677080422 bytes / 5044035 usecs = 131087 KB/s
677080422 bytes / 5044049 usecs = 131087 KB/s
677080422 bytes / 5044049 usecs = 131087 KB/s
677080422 bytes / 5044050 usecs = 131087 KB/s
677080422 bytes / 5044051 usecs = 131087 KB/s
677080422 bytes / 5044052 usecs = 131087 KB/s
677080422 bytes / 5044052 usecs = 131087 KB/s
677080422 bytes / 5044054 usecs = 131087 KB/s
677080422 bytes / 5044053 usecs = 131087 KB/s
677080422 bytes / 5044056 usecs = 131087 KB/s
677080422 bytes / 5044057 usecs = 131087 KB/s
677080422 bytes / 5044059 usecs = 131087 KB/s
677080422 bytes / 5044058 usecs = 131087 KB/s
677080422 bytes / 5044059 usecs = 131087 KB/s
677080422 bytes / 5044060 usecs = 131087 KB/s
677080422 bytes / 5044056 usecs = 131087 KB/s
677080422 bytes / 5044062 usecs = 131087 KB/s
677080422 bytes / 5044062 usecs = 131087 KB/s
677080422 bytes / 5044057 usecs = 131087 KB/s
677080422 bytes / 5044067 usecs = 131086 KB/s
677080422 bytes / 5044066 usecs = 131086 KB/s
677080422 bytes / 5044067 usecs = 131086 KB/s
677080422 bytes / 5044060 usecs = 131087 KB/s
677080422 bytes / 5044059 usecs = 131087 KB/s
677080422 bytes / 5044064 usecs = 131087 KB/s
677080422 bytes / 5044067 usecs = 131086 KB/s
677080422 bytes / 5044072 usecs = 131086 KB/s
677080422 bytes / 5044070 usecs = 131086 KB/s
677080422 bytes / 5044072 usecs = 131086 KB/s
677080422 bytes / 5044071 usecs = 131086 KB/s
677080422 bytes / 5044066 usecs = 131086 KB/s
677080422 bytes / 5044064 usecs = 131087 KB/s
677080422 bytes / 5044065 usecs = 131087 KB/s
677080422 bytes / 5044053 usecs = 131087 KB/s
677080422 bytes / 5044069 usecs = 131086 KB/s
677080422 bytes / 5044064 usecs = 131087 KB/s
677080422 bytes / 5044069 usecs = 131086 KB/s
677080422 bytes / 5044073 usecs = 131086 KB/s
677080422 bytes / 5044069 usecs = 131086 KB/s
677080422 bytes / 5044058 usecs = 131087 KB/s
677080422 bytes / 5044073 usecs = 131086 KB/s
677080422 bytes / 5044073 usecs = 131086 KB/s
677080422 bytes / 5044063 usecs = 131087 KB/s
677080422 bytes / 5044033 usecs = 131087 KB/s
677080422 bytes / 5044068 usecs = 131086 KB/s
677080422 bytes / 5044233 usecs = 131082 KB/s
677080422 bytes / 5044056 usecs = 131087 KB/s
677080422 bytes / 5045157 usecs = 131058 KB/s
677080422 bytes / 5044057 usecs = 131087 KB/s
2014-11-14 12:46:13 ./case-msync-mt
2014-11-14 12:46:13 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:13 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5003854 usecs = 132140 KB/s
677080422 bytes / 5003850 usecs = 132140 KB/s
677080422 bytes / 5003858 usecs = 132140 KB/s
677080422 bytes / 5003854 usecs = 132140 KB/s
677080422 bytes / 5003861 usecs = 132140 KB/s
677080422 bytes / 5003857 usecs = 132140 KB/s
677080422 bytes / 5003862 usecs = 132140 KB/s
677080422 bytes / 5003867 usecs = 132140 KB/s
677080422 bytes / 5003854 usecs = 132140 KB/s
677080422 bytes / 5003848 usecs = 132140 KB/s
677080422 bytes / 5003870 usecs = 132139 KB/s
677080422 bytes / 5003871 usecs = 132139 KB/s
677080422 bytes / 5003873 usecs = 132139 KB/s
677080422 bytes / 5003874 usecs = 132139 KB/s
677080422 bytes / 5003876 usecs = 132139 KB/s
677080422 bytes / 5003882 usecs = 132139 KB/s
677080422 bytes / 5003882 usecs = 132139 KB/s
677080422 bytes / 5003882 usecs = 132139 KB/s
677080422 bytes / 5003882 usecs = 132139 KB/s
677080422 bytes / 5003883 usecs = 132139 KB/s
677080422 bytes / 5003883 usecs = 132139 KB/s
677080422 bytes / 5003883 usecs = 132139 KB/s
677080422 bytes / 5003886 usecs = 132139 KB/s
677080422 bytes / 5003889 usecs = 132139 KB/s
677080422 bytes / 5003888 usecs = 132139 KB/s
677080422 bytes / 5003890 usecs = 132139 KB/s
677080422 bytes / 5003885 usecs = 132139 KB/s
677080422 bytes / 5003884 usecs = 132139 KB/s
677080422 bytes / 5003891 usecs = 132139 KB/s
677080422 bytes / 5003884 usecs = 132139 KB/s
677080422 bytes / 5003884 usecs = 132139 KB/s
677080422 bytes / 5003886 usecs = 132139 KB/s
677080422 bytes / 5003888 usecs = 132139 KB/s
677080422 bytes / 5003886 usecs = 132139 KB/s
677080422 bytes / 5003890 usecs = 132139 KB/s
677080422 bytes / 5003891 usecs = 132139 KB/s
677080422 bytes / 5003892 usecs = 132139 KB/s
677080422 bytes / 5003887 usecs = 132139 KB/s
677080422 bytes / 5003931 usecs = 132138 KB/s
677080422 bytes / 5004003 usecs = 132136 KB/s
677080422 bytes / 5004014 usecs = 132136 KB/s
677080422 bytes / 5004053 usecs = 132135 KB/s
677080422 bytes / 5004055 usecs = 132135 KB/s
677080422 bytes / 5004061 usecs = 132134 KB/s
677080422 bytes / 5004061 usecs = 132134 KB/s
677080422 bytes / 5004063 usecs = 132134 KB/s
677080422 bytes / 5004067 usecs = 132134 KB/s
677080422 bytes / 5004069 usecs = 132134 KB/s
677080422 bytes / 5004097 usecs = 132133 KB/s
677080422 bytes / 5004107 usecs = 132133 KB/s
677080422 bytes / 5004108 usecs = 132133 KB/s
677080422 bytes / 5004107 usecs = 132133 KB/s
677080422 bytes / 5004110 usecs = 132133 KB/s
677080422 bytes / 5004113 usecs = 132133 KB/s
677080422 bytes / 5004115 usecs = 132133 KB/s
677080422 bytes / 5004964 usecs = 132111 KB/s
2014-11-14 12:46:18 ./case-msync-mt
2014-11-14 12:46:18 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:18 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 4880297 usecs = 135485 KB/s
677080422 bytes / 4880306 usecs = 135485 KB/s
677080422 bytes / 4880303 usecs = 135485 KB/s
677080422 bytes / 4880302 usecs = 135485 KB/s
677080422 bytes / 4880304 usecs = 135485 KB/s
677080422 bytes / 4880296 usecs = 135485 KB/s
677080422 bytes / 4880299 usecs = 135485 KB/s
677080422 bytes / 4880300 usecs = 135485 KB/s
677080422 bytes / 4880314 usecs = 135485 KB/s
677080422 bytes / 4880322 usecs = 135485 KB/s
677080422 bytes / 4880329 usecs = 135484 KB/s
677080422 bytes / 4880330 usecs = 135484 KB/s
677080422 bytes / 4880329 usecs = 135484 KB/s
677080422 bytes / 4880331 usecs = 135484 KB/s
677080422 bytes / 4880332 usecs = 135484 KB/s
677080422 bytes / 4880332 usecs = 135484 KB/s
677080422 bytes / 4880333 usecs = 135484 KB/s
677080422 bytes / 4880334 usecs = 135484 KB/s
677080422 bytes / 4880331 usecs = 135484 KB/s
677080422 bytes / 4880337 usecs = 135484 KB/s
677080422 bytes / 4880337 usecs = 135484 KB/s
677080422 bytes / 4880338 usecs = 135484 KB/s
677080422 bytes / 4880339 usecs = 135484 KB/s
677080422 bytes / 4880340 usecs = 135484 KB/s
677080422 bytes / 4880331 usecs = 135484 KB/s
677080422 bytes / 4880333 usecs = 135484 KB/s
677080422 bytes / 4880335 usecs = 135484 KB/s
677080422 bytes / 4880338 usecs = 135484 KB/s
677080422 bytes / 4880332 usecs = 135484 KB/s
677080422 bytes / 4880336 usecs = 135484 KB/s
677080422 bytes / 4880333 usecs = 135484 KB/s
677080422 bytes / 4880331 usecs = 135484 KB/s
677080422 bytes / 4880335 usecs = 135484 KB/s
677080422 bytes / 4880336 usecs = 135484 KB/s
677080422 bytes / 4880340 usecs = 135484 KB/s
677080422 bytes / 4880340 usecs = 135484 KB/s
677080422 bytes / 4880339 usecs = 135484 KB/s
677080422 bytes / 4880339 usecs = 135484 KB/s
677080422 bytes / 4880339 usecs = 135484 KB/s
677080422 bytes / 4880340 usecs = 135484 KB/s
677080422 bytes / 4880349 usecs = 135484 KB/s
677080422 bytes / 4880368 usecs = 135483 KB/s
677080422 bytes / 4880487 usecs = 135480 KB/s
677080422 bytes / 4880487 usecs = 135480 KB/s
677080422 bytes / 4880493 usecs = 135480 KB/s
677080422 bytes / 4880508 usecs = 135480 KB/s
677080422 bytes / 4880517 usecs = 135479 KB/s
677080422 bytes / 4880571 usecs = 135478 KB/s
677080422 bytes / 4880572 usecs = 135478 KB/s
677080422 bytes / 4880573 usecs = 135478 KB/s
677080422 bytes / 4880575 usecs = 135478 KB/s
677080422 bytes / 4880578 usecs = 135478 KB/s
677080422 bytes / 4880578 usecs = 135478 KB/s
677080422 bytes / 4880584 usecs = 135477 KB/s
677080422 bytes / 4880607 usecs = 135477 KB/s
677080422 bytes / 4883633 usecs = 135393 KB/s
2014-11-14 12:46:23 ./case-msync-mt
2014-11-14 12:46:23 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:23 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5805767 usecs = 113888 KB/s
677080422 bytes / 5805755 usecs = 113888 KB/s
677080422 bytes / 5805760 usecs = 113888 KB/s
677080422 bytes / 5805766 usecs = 113888 KB/s
677080422 bytes / 5805740 usecs = 113889 KB/s
677080422 bytes / 5805755 usecs = 113888 KB/s
677080422 bytes / 5805748 usecs = 113889 KB/s
677080422 bytes / 5805749 usecs = 113889 KB/s
677080422 bytes / 5805787 usecs = 113888 KB/s
677080422 bytes / 5805788 usecs = 113888 KB/s
677080422 bytes / 5805789 usecs = 113888 KB/s
677080422 bytes / 5805788 usecs = 113888 KB/s
677080422 bytes / 5805789 usecs = 113888 KB/s
677080422 bytes / 5805788 usecs = 113888 KB/s
677080422 bytes / 5805790 usecs = 113888 KB/s
677080422 bytes / 5805790 usecs = 113888 KB/s
677080422 bytes / 5805793 usecs = 113888 KB/s
677080422 bytes / 5805791 usecs = 113888 KB/s
677080422 bytes / 5805796 usecs = 113888 KB/s
677080422 bytes / 5805797 usecs = 113888 KB/s
677080422 bytes / 5805792 usecs = 113888 KB/s
677080422 bytes / 5805794 usecs = 113888 KB/s
677080422 bytes / 5805799 usecs = 113888 KB/s
677080422 bytes / 5805800 usecs = 113888 KB/s
677080422 bytes / 5805805 usecs = 113887 KB/s
677080422 bytes / 5805791 usecs = 113888 KB/s
677080422 bytes / 5805802 usecs = 113888 KB/s
677080422 bytes / 5805803 usecs = 113888 KB/s
677080422 bytes / 5805791 usecs = 113888 KB/s
677080422 bytes / 5805807 usecs = 113887 KB/s
677080422 bytes / 5805807 usecs = 113887 KB/s
677080422 bytes / 5805798 usecs = 113888 KB/s
677080422 bytes / 5805796 usecs = 113888 KB/s
677080422 bytes / 5805810 usecs = 113887 KB/s
677080422 bytes / 5805798 usecs = 113888 KB/s
677080422 bytes / 5805801 usecs = 113888 KB/s
677080422 bytes / 5805802 usecs = 113888 KB/s
677080422 bytes / 5805793 usecs = 113888 KB/s
677080422 bytes / 5805792 usecs = 113888 KB/s
677080422 bytes / 5805795 usecs = 113888 KB/s
677080422 bytes / 5805799 usecs = 113888 KB/s
677080422 bytes / 5805801 usecs = 113888 KB/s
677080422 bytes / 5805801 usecs = 113888 KB/s
677080422 bytes / 5805801 usecs = 113888 KB/s
677080422 bytes / 5805802 usecs = 113888 KB/s
677080422 bytes / 5805806 usecs = 113887 KB/s
677080422 bytes / 5805796 usecs = 113888 KB/s
677080422 bytes / 5805806 usecs = 113887 KB/s
677080422 bytes / 5805805 usecs = 113887 KB/s
677080422 bytes / 5805805 usecs = 113887 KB/s
677080422 bytes / 5805794 usecs = 113888 KB/s
677080422 bytes / 5805748 usecs = 113889 KB/s
677080422 bytes / 5806025 usecs = 113883 KB/s
677080422 bytes / 5805797 usecs = 113888 KB/s
677080422 bytes / 5806093 usecs = 113882 KB/s
677080422 bytes / 5806842 usecs = 113867 KB/s
2014-11-14 12:46:29 ./case-msync-mt
2014-11-14 12:46:29 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:29 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 4863154 usecs = 135963 KB/s
677080422 bytes / 4863143 usecs = 135963 KB/s
677080422 bytes / 4863146 usecs = 135963 KB/s
677080422 bytes / 4863160 usecs = 135963 KB/s
677080422 bytes / 4863146 usecs = 135963 KB/s
677080422 bytes / 4863153 usecs = 135963 KB/s
677080422 bytes / 4863166 usecs = 135963 KB/s
677080422 bytes / 4863168 usecs = 135963 KB/s
677080422 bytes / 4863176 usecs = 135962 KB/s
677080422 bytes / 4863178 usecs = 135962 KB/s
677080422 bytes / 4863189 usecs = 135962 KB/s
677080422 bytes / 4863191 usecs = 135962 KB/s
677080422 bytes / 4863196 usecs = 135962 KB/s
677080422 bytes / 4863197 usecs = 135962 KB/s
677080422 bytes / 4863199 usecs = 135962 KB/s
677080422 bytes / 4863197 usecs = 135962 KB/s
677080422 bytes / 4863197 usecs = 135962 KB/s
677080422 bytes / 4863198 usecs = 135962 KB/s
677080422 bytes / 4863199 usecs = 135962 KB/s
677080422 bytes / 4863200 usecs = 135962 KB/s
677080422 bytes / 4863200 usecs = 135962 KB/s
677080422 bytes / 4863200 usecs = 135962 KB/s
677080422 bytes / 4863203 usecs = 135962 KB/s
677080422 bytes / 4863201 usecs = 135962 KB/s
677080422 bytes / 4863202 usecs = 135962 KB/s
677080422 bytes / 4863200 usecs = 135962 KB/s
677080422 bytes / 4863210 usecs = 135961 KB/s
677080422 bytes / 4863211 usecs = 135961 KB/s
677080422 bytes / 4863204 usecs = 135962 KB/s
677080422 bytes / 4863206 usecs = 135962 KB/s
677080422 bytes / 4863207 usecs = 135961 KB/s
677080422 bytes / 4863208 usecs = 135961 KB/s
677080422 bytes / 4863209 usecs = 135961 KB/s
677080422 bytes / 4863210 usecs = 135961 KB/s
677080422 bytes / 4863205 usecs = 135962 KB/s
677080422 bytes / 4863209 usecs = 135961 KB/s
677080422 bytes / 4863206 usecs = 135962 KB/s
677080422 bytes / 4863209 usecs = 135961 KB/s
677080422 bytes / 4863200 usecs = 135962 KB/s
677080422 bytes / 4863210 usecs = 135961 KB/s
677080422 bytes / 4863209 usecs = 135961 KB/s
677080422 bytes / 4863205 usecs = 135962 KB/s
677080422 bytes / 4863204 usecs = 135962 KB/s
677080422 bytes / 4863199 usecs = 135962 KB/s
677080422 bytes / 4863203 usecs = 135962 KB/s
677080422 bytes / 4863236 usecs = 135961 KB/s
677080422 bytes / 4863203 usecs = 135962 KB/s
677080422 bytes / 4863243 usecs = 135960 KB/s
677080422 bytes / 4863273 usecs = 135960 KB/s
677080422 bytes / 4863288 usecs = 135959 KB/s
677080422 bytes / 4863290 usecs = 135959 KB/s
677080422 bytes / 4863199 usecs = 135962 KB/s
677080422 bytes / 4863337 usecs = 135958 KB/s
677080422 bytes / 4863340 usecs = 135958 KB/s
677080422 bytes / 4864233 usecs = 135933 KB/s
677080422 bytes / 4865941 usecs = 135885 KB/s
2014-11-14 12:46:34 ./case-msync-mt
2014-11-14 12:46:34 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:34 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5126250 usecs = 128985 KB/s
677080422 bytes / 5126252 usecs = 128985 KB/s
677080422 bytes / 5126251 usecs = 128985 KB/s
677080422 bytes / 5126312 usecs = 128983 KB/s
677080422 bytes / 5126313 usecs = 128983 KB/s
677080422 bytes / 5126314 usecs = 128983 KB/s
677080422 bytes / 5126314 usecs = 128983 KB/s
677080422 bytes / 5126319 usecs = 128983 KB/s
677080422 bytes / 5126319 usecs = 128983 KB/s
677080422 bytes / 5126320 usecs = 128983 KB/s
677080422 bytes / 5126322 usecs = 128983 KB/s
677080422 bytes / 5126322 usecs = 128983 KB/s
677080422 bytes / 5126319 usecs = 128983 KB/s
677080422 bytes / 5126315 usecs = 128983 KB/s
677080422 bytes / 5126316 usecs = 128983 KB/s
677080422 bytes / 5126330 usecs = 128983 KB/s
677080422 bytes / 5126319 usecs = 128983 KB/s
677080422 bytes / 5126319 usecs = 128983 KB/s
677080422 bytes / 5126316 usecs = 128983 KB/s
677080422 bytes / 5126316 usecs = 128983 KB/s
677080422 bytes / 5126322 usecs = 128983 KB/s
677080422 bytes / 5126322 usecs = 128983 KB/s
677080422 bytes / 5126322 usecs = 128983 KB/s
677080422 bytes / 5126323 usecs = 128983 KB/s
677080422 bytes / 5126321 usecs = 128983 KB/s
677080422 bytes / 5126325 usecs = 128983 KB/s
677080422 bytes / 5126324 usecs = 128983 KB/s
677080422 bytes / 5126315 usecs = 128983 KB/s
677080422 bytes / 5126327 usecs = 128983 KB/s
677080422 bytes / 5126323 usecs = 128983 KB/s
677080422 bytes / 5126331 usecs = 128983 KB/s
677080422 bytes / 5126326 usecs = 128983 KB/s
677080422 bytes / 5126324 usecs = 128983 KB/s
677080422 bytes / 5126322 usecs = 128983 KB/s
677080422 bytes / 5126325 usecs = 128983 KB/s
677080422 bytes / 5126330 usecs = 128983 KB/s
677080422 bytes / 5126325 usecs = 128983 KB/s
677080422 bytes / 5126325 usecs = 128983 KB/s
677080422 bytes / 5126326 usecs = 128983 KB/s
677080422 bytes / 5126324 usecs = 128983 KB/s
677080422 bytes / 5126327 usecs = 128983 KB/s
677080422 bytes / 5126329 usecs = 128983 KB/s
677080422 bytes / 5126324 usecs = 128983 KB/s
677080422 bytes / 5126329 usecs = 128983 KB/s
677080422 bytes / 5126328 usecs = 128983 KB/s
677080422 bytes / 5126352 usecs = 128982 KB/s
677080422 bytes / 5126330 usecs = 128983 KB/s
677080422 bytes / 5126323 usecs = 128983 KB/s
677080422 bytes / 5126326 usecs = 128983 KB/s
677080422 bytes / 5126324 usecs = 128983 KB/s
677080422 bytes / 5126323 usecs = 128983 KB/s
677080422 bytes / 5126375 usecs = 128982 KB/s
677080422 bytes / 5126543 usecs = 128978 KB/s
677080422 bytes / 5126561 usecs = 128977 KB/s
677080422 bytes / 5127365 usecs = 128957 KB/s
677080422 bytes / 5127368 usecs = 128957 KB/s
2014-11-14 12:46:39 ./case-msync-mt
2014-11-14 12:46:39 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:39 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5821056 usecs = 113589 KB/s
677080422 bytes / 5821074 usecs = 113589 KB/s
677080422 bytes / 5821066 usecs = 113589 KB/s
677080422 bytes / 5821068 usecs = 113589 KB/s
677080422 bytes / 5821070 usecs = 113589 KB/s
677080422 bytes / 5821059 usecs = 113589 KB/s
677080422 bytes / 5821058 usecs = 113589 KB/s
677080422 bytes / 5821054 usecs = 113589 KB/s
677080422 bytes / 5821084 usecs = 113589 KB/s
677080422 bytes / 5821085 usecs = 113589 KB/s
677080422 bytes / 5821136 usecs = 113588 KB/s
677080422 bytes / 5821136 usecs = 113588 KB/s
677080422 bytes / 5821137 usecs = 113588 KB/s
677080422 bytes / 5821136 usecs = 113588 KB/s
677080422 bytes / 5821137 usecs = 113588 KB/s
677080422 bytes / 5821138 usecs = 113587 KB/s
677080422 bytes / 5821138 usecs = 113587 KB/s
677080422 bytes / 5821137 usecs = 113588 KB/s
677080422 bytes / 5821140 usecs = 113587 KB/s
677080422 bytes / 5821140 usecs = 113587 KB/s
677080422 bytes / 5821143 usecs = 113587 KB/s
677080422 bytes / 5821142 usecs = 113587 KB/s
677080422 bytes / 5821142 usecs = 113587 KB/s
677080422 bytes / 5821148 usecs = 113587 KB/s
677080422 bytes / 5821150 usecs = 113587 KB/s
677080422 bytes / 5821141 usecs = 113587 KB/s
677080422 bytes / 5821142 usecs = 113587 KB/s
677080422 bytes / 5821146 usecs = 113587 KB/s
677080422 bytes / 5821149 usecs = 113587 KB/s
677080422 bytes / 5821153 usecs = 113587 KB/s
677080422 bytes / 5821143 usecs = 113587 KB/s
677080422 bytes / 5821145 usecs = 113587 KB/s
677080422 bytes / 5821154 usecs = 113587 KB/s
677080422 bytes / 5821155 usecs = 113587 KB/s
677080422 bytes / 5821157 usecs = 113587 KB/s
677080422 bytes / 5821157 usecs = 113587 KB/s
677080422 bytes / 5821158 usecs = 113587 KB/s
677080422 bytes / 5821158 usecs = 113587 KB/s
677080422 bytes / 5821146 usecs = 113587 KB/s
677080422 bytes / 5821151 usecs = 113587 KB/s
677080422 bytes / 5821148 usecs = 113587 KB/s
677080422 bytes / 5821145 usecs = 113587 KB/s
677080422 bytes / 5821154 usecs = 113587 KB/s
677080422 bytes / 5821150 usecs = 113587 KB/s
677080422 bytes / 5821156 usecs = 113587 KB/s
677080422 bytes / 5821156 usecs = 113587 KB/s
677080422 bytes / 5821152 usecs = 113587 KB/s
677080422 bytes / 5821152 usecs = 113587 KB/s
677080422 bytes / 5821176 usecs = 113587 KB/s
677080422 bytes / 5821170 usecs = 113587 KB/s
677080422 bytes / 5821279 usecs = 113585 KB/s
677080422 bytes / 5821294 usecs = 113584 KB/s
677080422 bytes / 5821372 usecs = 113583 KB/s
677080422 bytes / 5821374 usecs = 113583 KB/s
677080422 bytes / 5822178 usecs = 113567 KB/s
677080422 bytes / 5822258 usecs = 113566 KB/s
2014-11-14 12:46:45 ./case-msync-mt
2014-11-14 12:46:45 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:45 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5004400 usecs = 132125 KB/s
677080422 bytes / 5004405 usecs = 132125 KB/s
677080422 bytes / 5004414 usecs = 132125 KB/s
677080422 bytes / 5004400 usecs = 132125 KB/s
677080422 bytes / 5004413 usecs = 132125 KB/s
677080422 bytes / 5004422 usecs = 132125 KB/s
677080422 bytes / 5004424 usecs = 132125 KB/s
677080422 bytes / 5004426 usecs = 132125 KB/s
677080422 bytes / 5004437 usecs = 132125 KB/s
677080422 bytes / 5004443 usecs = 132124 KB/s
677080422 bytes / 5004445 usecs = 132124 KB/s
677080422 bytes / 5004446 usecs = 132124 KB/s
677080422 bytes / 5004442 usecs = 132124 KB/s
677080422 bytes / 5004446 usecs = 132124 KB/s
677080422 bytes / 5004445 usecs = 132124 KB/s
677080422 bytes / 5004447 usecs = 132124 KB/s
677080422 bytes / 5004444 usecs = 132124 KB/s
677080422 bytes / 5004447 usecs = 132124 KB/s
677080422 bytes / 5004449 usecs = 132124 KB/s
677080422 bytes / 5004445 usecs = 132124 KB/s
677080422 bytes / 5004444 usecs = 132124 KB/s
677080422 bytes / 5004449 usecs = 132124 KB/s
677080422 bytes / 5004454 usecs = 132124 KB/s
677080422 bytes / 5004449 usecs = 132124 KB/s
677080422 bytes / 5004457 usecs = 132124 KB/s
677080422 bytes / 5004447 usecs = 132124 KB/s
677080422 bytes / 5004448 usecs = 132124 KB/s
677080422 bytes / 5004448 usecs = 132124 KB/s
677080422 bytes / 5004448 usecs = 132124 KB/s
677080422 bytes / 5004451 usecs = 132124 KB/s
677080422 bytes / 5004451 usecs = 132124 KB/s
677080422 bytes / 5004453 usecs = 132124 KB/s
677080422 bytes / 5004452 usecs = 132124 KB/s
677080422 bytes / 5004452 usecs = 132124 KB/s
677080422 bytes / 5004452 usecs = 132124 KB/s
677080422 bytes / 5004453 usecs = 132124 KB/s
677080422 bytes / 5004456 usecs = 132124 KB/s
677080422 bytes / 5004456 usecs = 132124 KB/s
677080422 bytes / 5004456 usecs = 132124 KB/s
677080422 bytes / 5004455 usecs = 132124 KB/s
677080422 bytes / 5004457 usecs = 132124 KB/s
677080422 bytes / 5004457 usecs = 132124 KB/s
677080422 bytes / 5004473 usecs = 132124 KB/s
677080422 bytes / 5004515 usecs = 132122 KB/s
677080422 bytes / 5004519 usecs = 132122 KB/s
677080422 bytes / 5004521 usecs = 132122 KB/s
677080422 bytes / 5004533 usecs = 132122 KB/s
677080422 bytes / 5004539 usecs = 132122 KB/s
677080422 bytes / 5004540 usecs = 132122 KB/s
677080422 bytes / 5004549 usecs = 132122 KB/s
677080422 bytes / 5004553 usecs = 132121 KB/s
677080422 bytes / 5004559 usecs = 132121 KB/s
677080422 bytes / 5004561 usecs = 132121 KB/s
677080422 bytes / 5004568 usecs = 132121 KB/s
677080422 bytes / 5004564 usecs = 132121 KB/s
677080422 bytes / 5005534 usecs = 132096 KB/s
2014-11-14 12:46:50 ./case-msync-mt
2014-11-14 12:46:50 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:50 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5021925 usecs = 131664 KB/s
677080422 bytes / 5021924 usecs = 131664 KB/s
677080422 bytes / 5021915 usecs = 131665 KB/s
677080422 bytes / 5021917 usecs = 131665 KB/s
677080422 bytes / 5021933 usecs = 131664 KB/s
677080422 bytes / 5021915 usecs = 131665 KB/s
677080422 bytes / 5021916 usecs = 131665 KB/s
677080422 bytes / 5021929 usecs = 131664 KB/s
677080422 bytes / 5021929 usecs = 131664 KB/s
677080422 bytes / 5021931 usecs = 131664 KB/s
677080422 bytes / 5021929 usecs = 131664 KB/s
677080422 bytes / 5021933 usecs = 131664 KB/s
677080422 bytes / 5021916 usecs = 131665 KB/s
677080422 bytes / 5021933 usecs = 131664 KB/s
677080422 bytes / 5021927 usecs = 131664 KB/s
677080422 bytes / 5021934 usecs = 131664 KB/s
677080422 bytes / 5021920 usecs = 131665 KB/s
677080422 bytes / 5021920 usecs = 131665 KB/s
677080422 bytes / 5021921 usecs = 131665 KB/s
677080422 bytes / 5021921 usecs = 131665 KB/s
677080422 bytes / 5021922 usecs = 131664 KB/s
677080422 bytes / 5021925 usecs = 131664 KB/s
677080422 bytes / 5021926 usecs = 131664 KB/s
677080422 bytes / 5021930 usecs = 131664 KB/s
677080422 bytes / 5021924 usecs = 131664 KB/s
677080422 bytes / 5021916 usecs = 131665 KB/s
677080422 bytes / 5021931 usecs = 131664 KB/s
677080422 bytes / 5021928 usecs = 131664 KB/s
677080422 bytes / 5021920 usecs = 131665 KB/s
677080422 bytes / 5021934 usecs = 131664 KB/s
677080422 bytes / 5021978 usecs = 131663 KB/s
677080422 bytes / 5021921 usecs = 131665 KB/s
677080422 bytes / 5021915 usecs = 131665 KB/s
677080422 bytes / 5021916 usecs = 131665 KB/s
677080422 bytes / 5021915 usecs = 131665 KB/s
677080422 bytes / 5021922 usecs = 131664 KB/s
677080422 bytes / 5021932 usecs = 131664 KB/s
677080422 bytes / 5021917 usecs = 131665 KB/s
677080422 bytes / 5021918 usecs = 131665 KB/s
677080422 bytes / 5021923 usecs = 131664 KB/s
677080422 bytes / 5021926 usecs = 131664 KB/s
677080422 bytes / 5021915 usecs = 131665 KB/s
677080422 bytes / 5021935 usecs = 131664 KB/s
677080422 bytes / 5021934 usecs = 131664 KB/s
677080422 bytes / 5021918 usecs = 131665 KB/s
677080422 bytes / 5021932 usecs = 131664 KB/s
677080422 bytes / 5021928 usecs = 131664 KB/s
677080422 bytes / 5021920 usecs = 131665 KB/s
677080422 bytes / 5022080 usecs = 131660 KB/s
677080422 bytes / 5022223 usecs = 131657 KB/s
677080422 bytes / 5022240 usecs = 131656 KB/s
677080422 bytes / 5022262 usecs = 131656 KB/s
677080422 bytes / 5022274 usecs = 131655 KB/s
677080422 bytes / 5022277 usecs = 131655 KB/s
677080422 bytes / 5022278 usecs = 131655 KB/s
677080422 bytes / 5023200 usecs = 131631 KB/s
2014-11-14 12:46:55 ./case-msync-mt
2014-11-14 12:46:55 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:46:55 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5707945 usecs = 115840 KB/s
677080422 bytes / 5707999 usecs = 115839 KB/s
677080422 bytes / 5707999 usecs = 115839 KB/s
677080422 bytes / 5708002 usecs = 115839 KB/s
677080422 bytes / 5708000 usecs = 115839 KB/s
677080422 bytes / 5708000 usecs = 115839 KB/s
677080422 bytes / 5708006 usecs = 115839 KB/s
677080422 bytes / 5708006 usecs = 115839 KB/s
677080422 bytes / 5708005 usecs = 115839 KB/s
677080422 bytes / 5708005 usecs = 115839 KB/s
677080422 bytes / 5708006 usecs = 115839 KB/s
677080422 bytes / 5708008 usecs = 115839 KB/s
677080422 bytes / 5708002 usecs = 115839 KB/s
677080422 bytes / 5708011 usecs = 115839 KB/s
677080422 bytes / 5708011 usecs = 115839 KB/s
677080422 bytes / 5708010 usecs = 115839 KB/s
677080422 bytes / 5708012 usecs = 115839 KB/s
677080422 bytes / 5708008 usecs = 115839 KB/s
677080422 bytes / 5708009 usecs = 115839 KB/s
677080422 bytes / 5708001 usecs = 115839 KB/s
677080422 bytes / 5708018 usecs = 115839 KB/s
677080422 bytes / 5708010 usecs = 115839 KB/s
677080422 bytes / 5708001 usecs = 115839 KB/s
677080422 bytes / 5708014 usecs = 115839 KB/s
677080422 bytes / 5708016 usecs = 115839 KB/s
677080422 bytes / 5708015 usecs = 115839 KB/s
677080422 bytes / 5708003 usecs = 115839 KB/s
677080422 bytes / 5708003 usecs = 115839 KB/s
677080422 bytes / 5708007 usecs = 115839 KB/s
677080422 bytes / 5708000 usecs = 115839 KB/s
677080422 bytes / 5708014 usecs = 115839 KB/s
677080422 bytes / 5708007 usecs = 115839 KB/s
677080422 bytes / 5708019 usecs = 115839 KB/s
677080422 bytes / 5708019 usecs = 115839 KB/s
677080422 bytes / 5708020 usecs = 115839 KB/s
677080422 bytes / 5708020 usecs = 115839 KB/s
677080422 bytes / 5708020 usecs = 115839 KB/s
677080422 bytes / 5708012 usecs = 115839 KB/s
677080422 bytes / 5708012 usecs = 115839 KB/s
677080422 bytes / 5708015 usecs = 115839 KB/s
677080422 bytes / 5708014 usecs = 115839 KB/s
677080422 bytes / 5708016 usecs = 115839 KB/s
677080422 bytes / 5708017 usecs = 115839 KB/s
677080422 bytes / 5708018 usecs = 115839 KB/s
677080422 bytes / 5708004 usecs = 115839 KB/s
677080422 bytes / 5708017 usecs = 115839 KB/s
677080422 bytes / 5708014 usecs = 115839 KB/s
677080422 bytes / 5708020 usecs = 115839 KB/s
677080422 bytes / 5708020 usecs = 115839 KB/s
677080422 bytes / 5708004 usecs = 115839 KB/s
677080422 bytes / 5708008 usecs = 115839 KB/s
677080422 bytes / 5708201 usecs = 115835 KB/s
677080422 bytes / 5708235 usecs = 115834 KB/s
677080422 bytes / 5708265 usecs = 115834 KB/s
677080422 bytes / 5709776 usecs = 115803 KB/s
677080422 bytes / 5710337 usecs = 115792 KB/s
2014-11-14 12:47:01 ./case-msync-mt
2014-11-14 12:47:01 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:47:01 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
677080422 bytes / 5011750 usecs = 131932 KB/s
677080422 bytes / 5011746 usecs = 131932 KB/s
677080422 bytes / 5011746 usecs = 131932 KB/s
677080422 bytes / 5011749 usecs = 131932 KB/s
677080422 bytes / 5011741 usecs = 131932 KB/s
677080422 bytes / 5011741 usecs = 131932 KB/s
677080422 bytes / 5011741 usecs = 131932 KB/s
677080422 bytes / 5011745 usecs = 131932 KB/s
677080422 bytes / 5011800 usecs = 131930 KB/s
677080422 bytes / 5011800 usecs = 131930 KB/s
677080422 bytes / 5011800 usecs = 131930 KB/s
677080422 bytes / 5011801 usecs = 131930 KB/s
677080422 bytes / 5011801 usecs = 131930 KB/s
677080422 bytes / 5011805 usecs = 131930 KB/s
677080422 bytes / 5011806 usecs = 131930 KB/s
677080422 bytes / 5011802 usecs = 131930 KB/s
677080422 bytes / 5011803 usecs = 131930 KB/s
677080422 bytes / 5011809 usecs = 131930 KB/s
677080422 bytes / 5011804 usecs = 131930 KB/s
677080422 bytes / 5011803 usecs = 131930 KB/s
677080422 bytes / 5011803 usecs = 131930 KB/s
677080422 bytes / 5011805 usecs = 131930 KB/s
677080422 bytes / 5011814 usecs = 131930 KB/s
677080422 bytes / 5011805 usecs = 131930 KB/s
677080422 bytes / 5011804 usecs = 131930 KB/s
677080422 bytes / 5011816 usecs = 131930 KB/s
677080422 bytes / 5011816 usecs = 131930 KB/s
677080422 bytes / 5011807 usecs = 131930 KB/s
677080422 bytes / 5011807 usecs = 131930 KB/s
677080422 bytes / 5011819 usecs = 131930 KB/s
677080422 bytes / 5011819 usecs = 131930 KB/s
677080422 bytes / 5011804 usecs = 131930 KB/s
677080422 bytes / 5011809 usecs = 131930 KB/s
677080422 bytes / 5011810 usecs = 131930 KB/s
677080422 bytes / 5011810 usecs = 131930 KB/s
677080422 bytes / 5011811 usecs = 131930 KB/s
677080422 bytes / 5011812 usecs = 131930 KB/s
677080422 bytes / 5011813 usecs = 131930 KB/s
677080422 bytes / 5011812 usecs = 131930 KB/s
677080422 bytes / 5011814 usecs = 131930 KB/s
677080422 bytes / 5011816 usecs = 131930 KB/s
677080422 bytes / 5011817 usecs = 131930 KB/s
677080422 bytes / 5011814 usecs = 131930 KB/s
677080422 bytes / 5011819 usecs = 131930 KB/s
677080422 bytes / 5011815 usecs = 131930 KB/s
677080422 bytes / 5011817 usecs = 131930 KB/s
677080422 bytes / 5011819 usecs = 131930 KB/s
677080422 bytes / 5011806 usecs = 131930 KB/s
677080422 bytes / 5011838 usecs = 131929 KB/s
677080422 bytes / 5011945 usecs = 131927 KB/s
677080422 bytes / 5012002 usecs = 131925 KB/s
677080422 bytes / 5012013 usecs = 131925 KB/s
677080422 bytes / 5012025 usecs = 131924 KB/s
677080422 bytes / 5012093 usecs = 131923 KB/s
677080422 bytes / 5013446 usecs = 131887 KB/s
677080422 bytes / 5014238 usecs = 131866 KB/s
2014-11-14 12:47:06 ./case-msync-mt
2014-11-14 12:47:06 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:47:06 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
[  130.620237] perf interrupt took too long (2509 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[  130.735712] perf interrupt took too long (5060 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[  130.953082] perf interrupt took too long (10412 > 9615), lowering kernel.perf_event_max_sample_rate to 13000
677080422 bytes / 5041541 usecs = 131152 KB/s
677080422 bytes / 5041532 usecs = 131152 KB/s
677080422 bytes / 5041523 usecs = 131153 KB/s
677080422 bytes / 5041517 usecs = 131153 KB/s
677080422 bytes / 5041518 usecs = 131153 KB/s
677080422 bytes / 5041536 usecs = 131152 KB/s
677080422 bytes / 5041536 usecs = 131152 KB/s
677080422 bytes / 5041536 usecs = 131152 KB/s
677080422 bytes / 5041539 usecs = 131152 KB/s
677080422 bytes / 5041527 usecs = 131152 KB/s
677080422 bytes / 5041523 usecs = 131153 KB/s
677080422 bytes / 5041522 usecs = 131153 KB/s
677080422 bytes / 5041541 usecs = 131152 KB/s
677080422 bytes / 5041537 usecs = 131152 KB/s
677080422 bytes / 5041534 usecs = 131152 KB/s
677080422 bytes / 5041525 usecs = 131153 KB/s
677080422 bytes / 5041533 usecs = 131152 KB/s
677080422 bytes / 5041531 usecs = 131152 KB/s
677080422 bytes / 5041538 usecs = 131152 KB/s
677080422 bytes / 5041535 usecs = 131152 KB/s
677080422 bytes / 5041515 usecs = 131153 KB/s
677080422 bytes / 5041525 usecs = 131153 KB/s
677080422 bytes / 5041532 usecs = 131152 KB/s
677080422 bytes / 5041543 usecs = 131152 KB/s
677080422 bytes / 5041538 usecs = 131152 KB/s
677080422 bytes / 5041544 usecs = 131152 KB/s
677080422 bytes / 5041524 usecs = 131153 KB/s
677080422 bytes / 5041517 usecs = 131153 KB/s
677080422 bytes / 5041528 usecs = 131152 KB/s
677080422 bytes / 5041517 usecs = 131153 KB/s
677080422 bytes / 5041529 usecs = 131152 KB/s
677080422 bytes / 5041515 usecs = 131153 KB/s
677080422 bytes / 5041515 usecs = 131153 KB/s
677080422 bytes / 5041540 usecs = 131152 KB/s
677080422 bytes / 5041542 usecs = 131152 KB/s
677080422 bytes / 5041530 usecs = 131152 KB/s
677080422 bytes / 5041543 usecs = 131152 KB/s
677080422 bytes / 5041518 usecs = 131153 KB/s
677080422 bytes / 5041530 usecs = 131152 KB/s
677080422 bytes / 5041519 usecs = 131153 KB/s
677080422 bytes / 5041533 usecs = 131152 KB/s
677080422 bytes / 5041529 usecs = 131152 KB/s
677080422 bytes / 5041536 usecs = 131152 KB/s
677080422 bytes / 5041529 usecs = 131152 KB/s
677080422 bytes / 5041540 usecs = 131152 KB/s
677080422 bytes / 5041531 usecs = 131152 KB/s
677080422 bytes / 5041539 usecs = 131152 KB/s
677080422 bytes / 5041528 usecs = 131152 KB/s
677080422 bytes / 5041542 usecs = 131152 KB/s
677080422 bytes / 5041526 usecs = 131153 KB/s
677080422 bytes / 5041524 usecs = 131153 KB/s
677080422 bytes / 5041775 usecs = 131146 KB/s
677080422 bytes / 5041785 usecs = 131146 KB/s
677080422 bytes / 5041845 usecs = 131144 KB/s
677080422 bytes / 5041535 usecs = 131152 KB/s
677080422 bytes / 5043129 usecs = 131111 KB/s
2014-11-14 12:47:11 ./case-msync-mt
2014-11-14 12:47:11 truncate /tmp/vm-scalability/sparse-msync-mt -s 67407118336
2014-11-14 12:47:11 ./usemem --runtime 300 -S -t 56 -f /tmp/vm-scalability/sparse-msync-mt -F --prealloc --open-rw 601849270
[  136.721372] ------------[ cut here ]------------
[  136.726793] kernel BUG at fs/xfs/xfs_aops.c:1069!
[  136.733766] invalid opcode: 0000 [#1] SMP 
[  136.738504] Modules linked in: loop ipmi_watchdog snd_pcm snd_timer snd soundcore pcspkr mgag200 syscopyarea sysfillrect sysimgblt ttm drm_kms_helper sb_edac drm edac_core i2c_i801 wmi ipmi_si ipmi_msghandler acpi_power_meter
[  136.761454] CPU: 5 PID: 7251 Comm: usemem Not tainted 3.18.0-rc4-wl-ath-g788be579 #1
[  136.770312] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.TP2.0025.R02.1403131625 03/13/2014
[  136.781911] task: ffff880852ab3ac0 ti: ffff88081db58000 task.ti: ffff88081db58000
[  136.790512] RIP: 0010:[<ffffffff8132b77c>]  [<ffffffff8132b77c>] xfs_vm_writepage+0x5fc/0x680
[  136.800315] RSP: 0018:ffff88081db5bba8  EFLAGS: 00010246
[  136.806515] RAX: 0020151e0000002d RBX: ffff88103c6202f8 RCX: 000000000000000c
[  136.814768] RDX: ffff88103c6202f8 RSI: ffff88081db5be40 RDI: ffffea002062e0c0
[  136.823032] RBP: ffff88081db5bc58 R08: 0000000000000002 R09: ffff88087ffda000
[  136.831302] R10: 0000000000000035 R11: 0000000000000000 R12: ffff88103c6201a8
[  136.839580] R13: 0000000000022951 R14: ffff88081db5be40 R15: ffffea002062e0c0
[  136.847865] FS:  00007f41ec7d4700(0000) GS:ffff88085f4a0000(0000) knlGS:0000000000000000
[  136.857235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  136.863994] CR2: 00007f41e8fcda08 CR3: 000000083bc17000 CR4: 00000000001407e0
[  136.872320] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  136.880650] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  136.888984] Stack:
[  136.891595]  0000000fb1c70000 ffff88103c6202f8 ffff88081db5be40 00007f4100000001
[  136.900285]  0000000100000001 ffffea002062e0c0 0000000000001000 0000000022952000
[  136.908988]  ffff88081db5bc38 ffffffff81329e28 ffff88081db5bc58 0000000000000000
[  136.917701] Call Trace:
[  136.920846]  [<ffffffff81329e28>] ? xfs_vm_set_page_dirty+0x138/0x190
[  136.928476]  [<ffffffff81169e47>] __writepage+0x17/0x50
[  136.934751]  [<ffffffff8116a86c>] write_cache_pages+0x21c/0x4f0
[  136.941809]  [<ffffffff8188c57e>] ? __wait_on_bit+0x7e/0x90
[  136.948485]  [<ffffffff81169e30>] ? global_dirtyable_memory+0x50/0x50
[  136.956144]  [<ffffffff8116ab80>] generic_writepages+0x40/0x60
[  136.963118]  [<ffffffff8132acb3>] xfs_vm_writepages+0x43/0x50
[  136.970007]  [<ffffffff8116c77e>] do_writepages+0x1e/0x30
[  136.976518]  [<ffffffff81160c89>] __filemap_fdatawrite_range+0x59/0x60
[  136.984297]  [<ffffffff81160d8a>] filemap_write_and_wait_range+0x2a/0x70
[  136.992281]  [<ffffffff81335cb7>] xfs_file_fsync+0x57/0x1d0
[  136.999015]  [<ffffffff8120bdfb>] vfs_fsync_range+0x1b/0x30
[  137.005749]  [<ffffffff8119978d>] SyS_msync+0x1ed/0x250
[  137.012104]  [<ffffffff818912a9>] system_call_fastpath+0x12/0x17
[  137.019341] Code: 8d 78 08 89 ca 48 c7 00 00 00 00 00 48 c7 44 10 f8 00 00 00 00 48 83 e7 f8 48 29 f8 01 c1 31 c0 c1 e9 03 f3 48 ab e9 44 ff ff ff <0f> 0b 31 c0 e9 5b fd ff ff 4d 85 f6 74 0e 4c 89 f7 89 45 98 e8 
[  137.042173] RIP  [<ffffffff8132b77c>] xfs_vm_writepage+0x5fc/0x680
[  137.049667]  RSP <ffff88081db5bba8>
[  137.054165] ---[ end trace f24aad15132e6627 ]---
[  137.059929] Kernel panic - not syncing: Fatal exception
[  137.076809] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
ACPI MEMORY or I/O RESET_REG.
APPEND dmesg: /result/lkp-hsw01/vm-scalability/performance-300s-1T-msync-mt/debian-x86_64.cgz/x86_64-rhel/788be5797c6941d1eff247c1a25c7853f28c2acb/0/.dmesg already exists
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.6 (aaron@aaronlu.sh.intel.com) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #2 Tue Jul 22 11:25:42 CST 2014
[    0.000000] Command line: initrd=usbkey/boot/kexec/rootfs.cgz path_prefix=http://192.168.1.1/~lkp/ console=ttyS0,115200 console=tty0 BOOT_IMAGE=usbkey/boot/kexec/vmlinuz 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000736c8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000736c9000-0x0000000073775fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000073776000-0x00000000781f8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000781f9000-0x000000007accefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007accf000-0x000000007b6fefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b6ff000-0x000000007b7d9fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b7da000-0x000000007b7fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000107fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] e820: last_pfn = 0x1080000 max_arch_pfn = 0x400000000
[    0.000000] e820: last_pfn = 0x7b800 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x107fe00000-0x107fffffff]
[    0.000000] init_memory_mapping: [mem 0x107c000000-0x107fdfffff]
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x107bffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x736c8fff]
[    0.000000] init_memory_mapping: [mem 0x73776000-0x781f8fff]
[    0.000000] init_memory_mapping: [mem 0x7b7da000-0x7b7fffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000] RAMDISK: [mem 0x6f09e000-0x7369ffff]
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x000000007B7D80E8 0000B4 (v01 INTEL  INTEL ID 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007B7D7000 0000F4 (v04 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: DSDT 0x000000007B79D000 02FE63 (v02 INTEL  INTEL ID 00000003 INTL 20091013)
[    0.000000] ACPI: FACS 0x000000007B6FB000 000040
[    0.000000] ACPI: UEFI 0x000000007B6F3000 000042 (v01                 00000000      00000000)
[    0.000000] ACPI: HPET 0x000000007B7D6000 000038 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: APIC 0x000000007B7D5000 00085C (v02 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MCFG 0x000000007B7D4000 00003C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: MIGT 0x000000007B7D3000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: MSCT 0x000000007B7D2000 000090 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: PMCT 0x000000007B7D1000 000064 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SLIT 0x000000007B7D0000 00006C (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SRAT 0x000000007B7CF000 000E30 (v03 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] ACPI: SVOS 0x000000007B7CE000 000032 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: WDDT 0x000000007B7CD000 000040 (v01 INTEL  INTEL ID 00000000 INTL 20091013)
[    0.000000] ACPI: SSDT 0x00000000736C9000 0ACA42 (v02 INTEL  SSDT  PM 00004000 INTL 20130328)
[    0.000000] ACPI: SSDT 0x000000007B79A000 00213C (v02 INTEL  SpsNm    00000002 INTL 20130328)
[    0.000000] ACPI: SSDT 0x000000007B799000 000064 (v02 INTEL  SpsNvs   00000002 INTL 20130328)
[    0.000000] ACPI: PRAD 0x000000007B798000 000102 (v02 INTEL  SpsPrAgg 00000002 INTL 20130328)
[    0.000000] ACPI: SPCR 0x000000007B797000 000050 (v01                 00000000      00000000)
[    0.000000] ACPI: DMAR 0x000000007B796000 000098 (v01 INTEL  INTEL ID 00000001 INTL 20091013)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x107fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x736c8fff]
[    0.000000]   node   0: [mem 0x73776000-0x781f8fff]
[    0.000000]   node   0: [mem 0x7b7da000-0x7b7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x107fffffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x2 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 2/0x4 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 3/0x6 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 4/0x8 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 5/0xa ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 6/0xc ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x10] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 7/0x10 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x12] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 8/0x12 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x14] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 9/0x14 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x16] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 10/0x16 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x18] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 11/0x18 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1a] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 12/0x1a ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x1c] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 13/0x1c ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x20] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 14/0x20 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x22] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 15/0x22 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x24] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 16/0x24 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x26] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 17/0x26 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x28] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 18/0x28 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x2a] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 19/0x2a ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x2c] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 20/0x2c ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x30] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 21/0x30 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x32] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 22/0x32 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x34] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 23/0x34 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x36] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 24/0x36 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x38] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 25/0x38 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x3a] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 26/0x3a ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x3c] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 27/0x3c ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 28/0x1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 29/0x3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 30/0x5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 31/0x7 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 32/0x9 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 33/0xb ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 34/0xd ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x11] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 35/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 36/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 37/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x17] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 38/0x17 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x19] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 39/0x19 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1b] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 40/0x1b ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x1d] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 41/0x1d ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x21] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 42/0x21 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x23] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 43/0x23 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x25] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 44/0x25 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x27] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 45/0x27 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x29] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 46/0x29 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x2b] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 47/0x2b ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x2d] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 48/0x2d ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x31] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 49/0x31 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x33] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 50/0x33 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x35] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 51/0x35 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x37] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 52/0x37 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x39] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 53/0x39 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x3b] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 54/0x3b ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x3d] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 55/0x3d ignored.
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
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16483061
[    0.000000] Kernel command line: initrd=usbkey/boot/kexec/rootfs.cgz path_prefix=http://192.168.1.1/~lkp/ console=ttyS0,115200 console=tty0 BOOT_IMAGE=usbkey/boot/kexec/vmlinuz 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.000000] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 65679724K/66978880K available (7817K kernel code, 620K rwdata, 2420K rodata, 720K init, 640K bss, 1299156K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2594.190 MHz processor
[    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5188.38 BogoMIPS (lpj=10376760)
[    0.012264] pid_max: default: 32768 minimum: 301
[    0.017564] ACPI: Core revision 20140214
[    0.074859] ACPI: All ACPI Tables successfully acquired
[    0.081218] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.089240] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.098274] Initializing cgroup subsys debug
[    0.103191] Initializing cgroup subsys devices
[    0.108303] Initializing cgroup subsys freezer
[    0.113415] Initializing cgroup subsys blkio
[    0.118343] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.118343] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.133899] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.133899] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.133899] tlb_flushall_shift: 6
[    0.153369] CPU: Intel(R) Xeon(R) CPU E5-2697 v3 @ 2.60GHz (fam: 06, model: 3f, stepping: 02)
[    0.163439] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.175824] ... version:                3
[    0.180697] ... bit width:              48
[    0.185667] ... generic registers:      4
[    0.190539] ... value mask:             0000ffffffffffff
[    0.196874] ... max period:             0000ffffffffffff
[    0.203204] ... fixed-purpose events:   3
[    0.208074] ... event mask:             000000070000000f
[    0.215074] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.261924] devtmpfs: initialized
[    0.266130] PM: Registering ACPI NVS region [mem 0x7accf000-0x7b6fefff] (10682368 bytes)
[    0.276107] NET: Registered protocol family 16
[    0.281582] cpuidle: using governor ladder
[    0.286576] cpuidle: using governor menu
[    0.291401] ACPI: bus type PCI registered
[    0.296310] PCI: Using configuration type 1 for base access
[    0.304679] ACPI: Added _OSI(Module Device)
[    0.309735] ACPI: Added _OSI(Processor Device)
[    0.315089] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.320725] ACPI: Added _OSI(Processor Aggregator Device)
[    0.414789] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.762937] ACPI: Interpreter enabled
[    0.767421] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.778591] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.789764] ACPI: (supports S0 S3 S5)
[    0.794245] ACPI: Using IOAPIC for interrupt routing
[    0.800201] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.837898] ACPI: PCI Root Bridge [UNC1] (domain 0000 [bus ff])
[    0.844951] acpi PNP0A03:02: _OSC: OS supports [Segments]
[    0.851410] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.859246] PCI host bridge to bus 0000:ff
[    0.864241] pci_bus 0000:ff: root bus resource [bus ff]
[    0.872942] ACPI: PCI Root Bridge [UNC0] (domain 0000 [bus 7f])
[    0.879985] acpi PNP0A03:03: _OSC: OS supports [Segments]
[    0.886445] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.894283] PCI host bridge to bus 0000:7f
[    0.899248] pci_bus 0000:7f: root bus resource [bus 7f]
[    0.916474] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    0.923834] acpi PNP0A08:00: _OSC: OS supports [Segments]
[    1.935317] acpi PNP0A08:00: PCIe port services disabled; not requesting _OSC control
[    1.945050] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    1.959816] PCI host bridge to bus 0000:00
[    1.964792] pci_bus 0000:00: root bus resource [bus 00-7e]
[    1.971334] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.978641] pci_bus 0000:00: root bus resource [io  0x1000-0x7fff]
[    1.985959] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.994045] pci_bus 0000:00: root bus resource [mem 0x90000000-0xc7ffbfff]
[    2.002128] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x383fffffffff]
[    2.011474] pci 0000:00:01.0: System wakeup disabled by ACPI
[    2.018296] pci 0000:00:02.0: System wakeup disabled by ACPI
[    2.025115] pci 0000:00:02.2: System wakeup disabled by ACPI
[    2.031933] pci 0000:00:03.0: System wakeup disabled by ACPI
[    2.038749] pci 0000:00:03.2: System wakeup disabled by ACPI
[    2.046030] pci 0000:00:14.0: System wakeup disabled by ACPI
[    2.052953] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    2.059806] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    2.066706] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    2.073725] pci 0000:00:01.0: PCI bridge to [bus 01]
[    2.079730] pci 0000:00:02.0: PCI bridge to [bus 02]
[    2.085922] pci 0000:00:02.2: PCI bridge to [bus 03-04]
[    2.092210] pci 0000:00:03.0: PCI bridge to [bus 05]
[    2.098186] pci 0000:00:03.2: PCI bridge to [bus 06]
[    2.104366] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    2.110521] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.120295] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    2.130042] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.139796] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    2.149543] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    2.159286] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    2.170446] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    2.181603] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    2.192855] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-fe])
[    2.200160] acpi PNP0A08:01: _OSC: OS supports [Segments]
[    3.211634] acpi PNP0A08:01: PCIe port services disabled; not requesting _OSC control
[    3.221183] PCI host bridge to bus 0000:80
[    3.226153] pci_bus 0000:80: root bus resource [bus 80-fe]
[    3.232700] pci_bus 0000:80: root bus resource [io  0x8000-0xffff]
[    3.240009] pci_bus 0000:80: root bus resource [mem 0xc8000000-0xfbffbfff]
[    3.248093] pci_bus 0000:80: root bus resource [mem 0x384000000000-0x387fffffffff]
[    3.257720] ACPI: Enabled 4 GPEs in block 00 to 3F
[    3.263789] vgaarb: device added: PCI:0000:07:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.273565] vgaarb: loaded
[    3.276977] vgaarb: bridge control possible 0000:07:00.0
[    3.283387] SCSI subsystem initialized
[    3.288005] ACPI: bus type USB registered
[    3.292915] usbcore: registered new interface driver usbfs
[    3.299479] usbcore: registered new interface driver hub
[    3.305842] usbcore: registered new device driver usb
[    3.311903] pps_core: LinuxPPS API ver. 1 registered
[    3.317843] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.328817] PTP clock support registered
[    3.333614] Advanced Linux Sound Architecture Driver Initialized.
[    3.340846] PCI: Using ACPI for IRQ routing
[    3.346012] pci 0000:ff:1e.3: can't claim BAR 0 [mem 0x00000010-0x0000001f pref]: no compatible bridge window
[    3.357850] pci 0000:7f:1e.3: can't claim BAR 0 [mem 0x00000010-0x0000001f pref]: no compatible bridge window
[    3.369785] Switched to clocksource hpet
[    3.374606] pnp: PnP ACPI init
[    3.378412] ACPI: bus type PNP registered
[    3.383955] system 00:06: [io  0x0500-0x053f] has been reserved
[    3.391007] system 00:06: [io  0x0400-0x047f] could not be reserved
[    3.398418] system 00:06: [io  0x0540-0x057f] has been reserved
[    3.405418] system 00:06: [io  0x0600-0x061f] has been reserved
[    3.412428] system 00:06: [io  0x0ca0-0x0ca5] has been reserved
[    3.419437] system 00:06: [io  0x0880-0x0883] has been reserved
[    3.426448] system 00:06: [io  0x0800-0x081f] has been reserved
[    3.433457] system 00:06: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[    3.441637] system 00:06: [mem 0xfed45000-0xfed8bfff] has been reserved
[    3.449427] system 00:06: [mem 0xff000000-0xffffffff] could not be reserved
[    3.457603] system 00:06: [mem 0xfee00000-0xfeefffff] has been reserved
[    3.465392] system 00:06: [mem 0xfed12000-0xfed1200f] has been reserved
[    3.473184] system 00:06: [mem 0xfed12010-0xfed1201f] has been reserved
[    3.480972] system 00:06: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    3.489237] pnp: PnP ACPI: found 10 devices
[    3.494327] ACPI: bus type PNP unregistered
[    3.504514] pci 0000:07:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[    3.516389] pci 0000:ff:1e.3: BAR 0: can't assign mem pref (size 0x10)
[    3.524080] pci 0000:ff:1e.3: BAR 0: trying firmware assignment [mem size 0x00000010 pref]
[    3.534037] pci 0000:ff:1e.3: BAR 0: [mem size 0x00000010 pref] conflicts with reserved [mem 0x00000000-0x00000fff]
[    3.546572] pci_bus 0000:ff: Some PCI device resources are unassigned, try booting with pci=realloc
[    3.557464] pci 0000:7f:1e.3: BAR 0: can't assign mem pref (size 0x10)
[    3.565147] pci 0000:7f:1e.3: BAR 0: trying firmware assignment [mem size 0x00000010 pref]
[    3.575106] pci 0000:7f:1e.3: BAR 0: [mem size 0x00000010 pref] conflicts with reserved [mem 0x00000000-0x00000fff]
[    3.587644] pci_bus 0000:7f: Some PCI device resources are unassigned, try booting with pci=realloc
[    3.598499] pci 0000:00:01.0: PCI bridge to [bus 01]
[    3.604441] pci 0000:00:02.0: PCI bridge to [bus 02]
[    3.610385] pci 0000:00:02.2: PCI bridge to [bus 03-04]
[    3.616614] pci 0000:00:02.2:   bridge window [io  0x1000-0x1fff]
[    3.623820] pci 0000:00:02.2:   bridge window [mem 0x91900000-0x91cfffff]
[    3.631803] pci 0000:00:02.2:   bridge window [mem 0x383fffa00000-0x383fffefffff 64bit pref]
[    3.641961] pci 0000:00:03.0: PCI bridge to [bus 05]
[    3.647903] pci 0000:00:03.2: PCI bridge to [bus 06]
[    3.653916] pci 0000:07:00.0: BAR 6: assigned [mem 0x91810000-0x9181ffff pref]
[    3.662704] pci 0000:00:1c.0: PCI bridge to [bus 07]
[    3.668645] pci 0000:00:1c.0:   bridge window [mem 0x91000000-0x918fffff]
[    3.676630] pci 0000:00:1c.0:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    3.686042] NET: Registered protocol family 2
[    3.691352] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    3.701085] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    3.708964] TCP: Hash tables configured (established 524288 bind 65536)
[    3.716762] TCP: reno registered
[    3.720750] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    3.728317] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    3.736384] NET: Registered protocol family 1
[    3.741671] RPC: Registered named UNIX socket transport module.
[    3.756560] RPC: Registered udp transport module.
[    3.762206] RPC: Registered tcp transport module.
[    3.767852] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    5.375021] pci 0000:00:1a.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    6.984004] pci 0000:00:1d.0: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    6.992500] Trying to unpack rootfs image as initramfs...
[    7.659166] Freeing initrd memory: 71688K (ffff88006f09e000 - ffff8800736a0000)
[    7.668065] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    7.675665] software IO TLB [mem 0x741f9000-0x781f9000] (64MB) mapped at [ffff8800741f9000-ffff8800781f8fff]
[    7.687495] microcode: CPU0 sig=0x306f2, pf=0x1, revision=0x18
[    7.694461] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.705058] Scanning for low memory corruption every 60 seconds
[    7.712203] futex hash table entries: 256 (order: 0, 6144 bytes)
[    7.719365] audit: initializing netlink subsys (disabled)
[    7.725811] audit: type=2000 audit(1415969344.084:1): initialized
[    7.734544] NFS: Registering the id_resolver key type
[    7.740620] Key type id_resolver registered
[    7.745717] Key type id_legacy registered
[    7.750699] msgmni has been set to 32768
[    7.755815] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    7.764810] io scheduler noop registered
[    7.769585] io scheduler deadline registered (default)
[    7.776094] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    7.785133] ACPI: Power Button [PWRF]
[    7.794369] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.822282] 00:07: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    7.851787] 00:08: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    7.860954] Initializing Nozomi driver 2.1d
[    7.866058] Non-volatile memory driver v1.3
[    7.871194] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    7.881934] Hangcheck: Using getrawmonotonic().
[    7.888049] brd: module loaded
[    7.892152] loop: module loaded
[    7.896137] nbd: registered device at major 43
[    7.902104] Loading iSCSI transport class v2.0-870.
[    7.908343] tun: Universal TUN/TAP device driver, 1.6
[    7.914384] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    7.921852] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    7.929953] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    7.936379] Copyright (c) 2007 Atheros Corporation.
[    7.942353] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March 14, 2014)
[    7.951467] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.78.19-0 (2014/02/10)
[    7.963669] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    7.970526] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    7.978425] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    7.978425]   http://www.scyld.com/network/drivers.html
[    7.992989] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    8.001123] vxge: Copyright(c) 2002-2010 Exar Corp.
[    8.006968] vxge: Driver version: 2.5.3.22640-k
[    8.012511] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    8.019719] e100: Copyright(c) 1999-2006 Intel Corporation
[    8.026277] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    8.034557] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    8.041485] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    8.048403] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    8.055447] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    8.063629] igb: Copyright (c) 2007-2014 Intel Corporation.
[    8.070367] igbvf: Intel(R) Gigabit Virtual Function Network Driver - version 2.0.2-k
[    8.079845] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    8.086866] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[    8.096246] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[    8.585027] ixgbe 0000:03:00.0: Multiqueue Disabled: Rx Queue count = 1, Tx Queue count = 1
[    8.669091] ixgbe 0000:03:00.0: PCI Express bandwidth of 32GT/s available
[    8.677094] ixgbe 0000:03:00.0: (Speed:5.0GT/s, Width: x8, Encoding Loss:20%)
[    8.733115] tsc: Refined TSC clocksource calibration: 2593.992 MHz
[    8.740448] ixgbe 0000:03:00.0: MAC: 3, PHY: 3, PBA No: 000000-000
[    8.747759] ixgbe 0000:03:00.0: 00:1e:67:94:8e:21
[    8.753806] Switched to clocksource tsc
[    8.985281] ixgbe 0000:03:00.0: Intel(R) 10 Gigabit Network Connection
[   10.198025] ixgbe 0000:03:00.1: Multiqueue Disabled: Rx Queue count = 1, Tx Queue count = 1
[   10.302086] ixgbe 0000:03:00.1: PCI Express bandwidth of 32GT/s available
[   10.310100] ixgbe 0000:03:00.1: (Speed:5.0GT/s, Width: x8, Encoding Loss:20%)
[   10.382131] ixgbe 0000:03:00.1: MAC: 3, PHY: 3, PBA No: 000000-000
[   10.389447] ixgbe 0000:03:00.1: 00:1e:67:94:8e:22
[   10.626282] ixgbe 0000:03:00.1: Intel(R) 10 Gigabit Network Connection
[   11.242679] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   11.251084] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   11.257849] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   11.264707] sky2: driver version 1.30
[   11.269242] myri10ge: Version 1.5.3-1.534
[   11.274155] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   11.282176] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[   11.289849] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.57
[   11.297860] QLogic/NetXen Network Driver v4.0.82
[   11.303572] tlan: ThunderLAN driver v1.17
[   11.308488] tlan: 0 devices installed, PCI: 0  EISA: 0
[   11.314674] usbcore: registered new interface driver catc
[   11.321144] usbcore: registered new interface driver kaweth
[   11.327773] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   11.336855] usbcore: registered new interface driver pegasus
[   11.343619] usbcore: registered new interface driver rtl8150
[   11.350351] usbcore: registered new interface driver r8152
[   11.356886] usbcore: registered new interface driver asix
[   11.363328] usbcore: registered new interface driver ax88179_178a
[   11.370546] usbcore: registered new interface driver cdc_ether
[   11.377476] usbcore: registered new interface driver cdc_eem
[   11.384212] usbcore: registered new interface driver dm9601
[   11.390848] usbcore: registered new interface driver smsc75xx
[   11.397678] usbcore: registered new interface driver smsc95xx
[   11.404507] usbcore: registered new interface driver gl620a
[   11.411142] usbcore: registered new interface driver net1080
[   11.417875] usbcore: registered new interface driver plusb
[   11.424413] usbcore: registered new interface driver rndis_host
[   11.431436] usbcore: registered new interface driver cdc_subset
[   11.438460] usbcore: registered new interface driver zaurus
[   11.445093] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   11.454092] usbcore: registered new interface driver int51x1
[   11.460826] usbcore: registered new interface driver kalmia
[   11.467463] usbcore: registered new interface driver ipheth
[   11.474097] usbcore: registered new interface driver sierra_net
[   11.481116] usbcore: registered new interface driver cx82310_eth
[   11.488242] usbcore: registered new interface driver cdc_ncm
[   11.494973] usbcore: registered new interface driver lg-vl600
[   11.501805] usbcore: registered new interface driver qmi_wwan
[   11.508713] aoe: AoE v85 initialised.
[   11.513257] usbcore: registered new interface driver hwa-rc
[   11.519911] usbcore: registered new interface driver i1480-dfu-usb
[   11.527248] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.534945] ehci-pci: EHCI PCI platform driver
[   11.540405] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   11.546645] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[   11.555653] ehci-pci 0000:00:1a.0: debug port 2
[   11.565018] ehci-pci 0000:00:1a.0: irq 18, io mem 0x91d01000
[   11.582863] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   11.589733] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   11.597718] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.606514] usb usb1: Product: EHCI Host Controller
[   11.612362] usb usb1: Manufacturer: Linux 3.15.6 ehci_hcd
[   11.618789] usb usb1: SerialNumber: 0000:00:1a.0
[   11.624413] hub 1-0:1.0: USB hub found
[   11.629018] hub 1-0:1.0: 2 ports detected
[   11.634015] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   11.640254] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   11.649253] ehci-pci 0000:00:1d.0: debug port 2
[   11.658604] ehci-pci 0000:00:1d.0: irq 18, io mem 0x91d00000
[   11.674914] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   11.681766] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   11.689751] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.698549] usb usb2: Product: EHCI Host Controller
[   11.704393] usb usb2: Manufacturer: Linux 3.15.6 ehci_hcd
[   11.710821] usb usb2: SerialNumber: 0000:00:1d.0
[   11.716442] hub 2-0:1.0: USB hub found
[   11.721043] hub 2-0:1.0: 2 ports detected
[   11.725960] uhci_hcd: USB Universal Host Controller Interface driver
[   11.733571] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   11.739827] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[   11.748929] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   11.756917] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.765715] usb usb3: Product: xHCI Host Controller
[   11.771559] usb usb3: Manufacturer: Linux 3.15.6 xhci_hcd
[   11.777987] usb usb3: SerialNumber: 0000:00:14.0
[   11.783607] hub 3-0:1.0: USB hub found
[   11.788207] hub 3-0:1.0: 15 ports detected
[   11.794726] xhci_hcd 0000:00:14.0: xHCI Host Controller
[   11.800962] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[   11.809995] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[   11.817981] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.834721] usb usb4: Product: xHCI Host Controller
[   11.840567] usb usb4: Manufacturer: Linux 3.15.6 xhci_hcd
[   11.846993] usb usb4: SerialNumber: 0000:00:14.0
[   11.852606] hub 4-0:1.0: USB hub found
[   11.857213] hub 4-0:1.0: 6 ports detected
[   11.862816] usbcore: registered new interface driver hwa-hc
[   11.869498] usbcore: registered new interface driver cdc_acm
[   11.876223] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   11.885917] usbcore: registered new interface driver cdc_wdm
[   11.892704] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   12.928823] i8042: No controller found
[   12.933718] mousedev: PS/2 mouse device common for all mice
[   12.940497] rtc_cmos 00:02: RTC can wake from S4
[   12.946176] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[   12.953445] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   12.962793] hidraw: raw HID events driver (C) Jiri Kosina
[   12.969278] usbcore: registered new interface driver usbhid
[   12.975902] usbhid: USB HID core driver
[   12.980737] TCP: cubic registered
[   12.984848] NET: Registered protocol family 17
[   12.990214] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   12.997946] Key type dns_resolver registered
[   13.003724] console [netcon0] enabled
[   13.008208] netconsole: network logging started
[   13.013702] rtc_cmos 00:02: setting system clock to 2014-11-14 12:49:13 UTC (1415969353)
[   13.023507] ALSA device list:
[   13.027217]   No soundcards found.
[   13.031899] Freeing unused kernel memory: 720K (ffffffff81c9d000 - ffffffff81d51000)
[   13.041277] Write protecting the kernel read-only data: 12288k
[   13.048962] Freeing unused kernel memory: 364K (ffff8800017a5000 - ffff880001800000)
[   13.061578] Freeing unused kernel memory: 1676K (ffff880001a5d000 - ffff880001c00000)
[   13.132115] usb 1-1: New USB device found, idVendor=8087, idProduct=800a
[   13.140012] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.157213] hub 1-1:1.0: USB hub found
[   13.170383] hub 1-1:1.0: 6 ports detected
[   13.291871] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   13.520351] usb 2-1: New USB device found, idVendor=8087, idProduct=8002
[   13.528251] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   13.618315] hub 2-1:1.0: USB hub found
[   13.723053] hub 2-1:1.0: 8 ports detected
[   13.936268] usb 3-2: new low-speed USB device number 2 using xhci_hcd

  ----------------------------------------------------------------------------
  | # mc                "For help, press F2 key and choose RIPLinux help!"   |
  | # pdmenu            "Menu frontend to programs!"                         |
  |                                                                          |
  | # dhcpup -u         "Setup wired network connection!"                    |
  | # wificonfig        "Setup wireless network connection!"                 |
  | # mnsetup           "Setup mail and news!"                               |
  |                                                                          |
  | # lynx (or) links   "WWW browsers!"  # rtin (or) slrn  "Newsreaders!"    |
  |                                                                          |
  | # update-pciids -p -u   "Download latest PCI & USB data files!"          |
  |                                                                          |
  | You can use 'backup-mbr' to backup/restore the MBR.                      |
  |                                                                          |
  | There are 8 consoles, press left-[Alt] F1-F8 to change consoles.         |
  | # reboot (or) halt  "When done, 'reboot' or 'halt/poweroff' system!"     |
  |                                                                          |
  | login: root                                                RIPLinux 13.5 |
  ----------------------------------------------------------------------------


--/3yNEOqWowh/8j+e--
