Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaJCN1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:27:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:52855 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaJCN1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,647,1406617200"; 
   d="scan'208";a="612683675"
Date: Fri, 3 Oct 2014 21:26:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [perf/x86/intel] WARNING: CPU: 48 PID: 7540 at
 arch/x86/kernel/cpu/perf_event_intel_ds.c:316
 reserve_ds_buffers+0x208/0x430()
Message-ID: <20141003132657.GB32634@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

FYI, we noticed the below changes on commit

4485154138f6ffa5b252cb490aba3e8eb30124e4 ("perf/x86/intel: Avoid spamming kernel log for BTS buffer failure")

+---------------------------------------------------------------------------+------------+------------+
|                                                                           | 338b522ca4 | 4485154138 |
+---------------------------------------------------------------------------+------------+------------+
| boot_successes                                                            | 3          | 5          |
| boot_failures                                                             | 21         | 15         |
| page_allocation_failure:order:,mode                                       | 11         |            |
| backtrace:reserve_ds_buffers                                              | 11         | 5          |
| backtrace:x86_pmu_event_init                                              | 11         | 5          |
| backtrace:perf_init_event                                                 | 11         | 5          |
| backtrace:SYSC_perf_event_open                                            | 11         | 5          |
| backtrace:SyS_perf_event_open                                             | 11         | 5          |
| BUG:kernel_test_crashed                                                   | 10         | 10         |
| WARNING:at_arch/x86/kernel/cpu/perf_event_intel_ds.c:reserve_ds_buffers() | 0          | 5          |
+---------------------------------------------------------------------------+------------+------------+


2014-10-03 01:27:35 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-60 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:36 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-62 -E --prealloc --readonly --random 17179869184
[  192.496567] ------------[ cut here ]------------
[  192.505045] WARNING: CPU: 48 PID: 7540 at arch/x86/kernel/cpu/perf_event_intel_ds.c:316 reserve_ds_buffers+0x208/0x430()
[  192.524168] alloc_bts_buffer: BTS buffer allocation failure
[  192.533339] Modules linked in: loop ipmi_watchdog nfsd auth_rpcgss dm_mod fuse sg sd_mod crct10dif_generic sr_mod crc_t10dif cdrom crct10dif_common ata_generic pata_acpi mgag200 syscopyarea snd_pcm sysfillrect sysimgblt snd_timer ttm snd drm_kms_helper soundcore ata_piix pcspkr i7core_edac drm libata megaraid_sas i2c_i801 edac_core ipmi_si ipmi_msghandler acpi_cpufreq
[  192.581450] CPU: 48 PID: 7540 Comm: perf Not tainted 3.16.0-rc2-00011-g4485154 #1
[  192.592393] Hardware name: Quanta MP Server/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0028.090220101116 09/02/2010
[  192.606455]  0000000000000009 ffff88005de53ce8 ffffffff81844e55 ffff88005de53d30
[  192.618370]  ffff88005de53d20 ffffffff8106de6d 0000000000000000 0000000000010528
[  192.630786]  0000000000000000 0000000000000000 0000000000000000 ffff88005de53d80
[  192.642465] Call Trace:
[  192.647913]  [<ffffffff81844e55>] dump_stack+0x4d/0x66
[  192.656643]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
[  192.666961]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
[  192.677047]  [<ffffffff81030863>] ? reserve_ds_buffers+0x2b3/0x430
[  192.687420]  [<ffffffff810307b8>] reserve_ds_buffers+0x208/0x430
[  192.697838]  [<ffffffff8118abec>] ? handle_mm_fault+0x8ac/0xf70
[  192.707522]  [<ffffffff8102a354>] x86_pmu_event_init+0x434/0x450
[  192.717351]  [<ffffffff8115241b>] perf_init_event+0xdb/0x140
[  192.727292]  [<ffffffff81152808>] perf_event_alloc+0x388/0x440
[  192.738117]  [<ffffffff81152c60>] SYSC_perf_event_open+0x3a0/0xd20
[  192.750511]  [<ffffffff81153979>] SyS_perf_event_open+0x9/0x10
[  192.761657]  [<ffffffff8184da29>] system_call_fastpath+0x16/0x1b
[  192.771904] ---[ end trace 6d601571820ebee0 ]---
4331667464 bytes / 300293184 usecs = 14086 KB/s

Thanks,
Fengguang

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc2-00011-g4485154 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Tue Sep 30 19:18:36 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-nex06/bisect_vm-scalability-300s-mremap-xread-rand-mt-x86_64-rhel-4485154138f6ffa5b252cb490aba3e8eb30124e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/vmlinuz-3.16.0-rc2-00011-g4485154 kconfig=x86_64-rhel commit=4485154138f6ffa5b252cb490aba3e8eb30124e4 branch=linus/master root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-nex06/vm-scalability/300s-mremap-xread-rand-mt/debian-x86_64.cgz/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/0 ip=::::lkp-nex06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000078c75fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078c76000-0x0000000078e8cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000078e8d000-0x0000000079244fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079245000-0x00000000792bbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792bc000-0x00000000792c3fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792c4000-0x00000000792d9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792da000-0x00000000792f4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792f5000-0x00000000792f7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792f8000-0x00000000792f8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792f9000-0x0000000079303fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079304000-0x0000000079307fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079308000-0x000000007930cfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007930d000-0x0000000079332fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079333000-0x0000000079353fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079354000-0x0000000079384fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079385000-0x00000000793c5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000793c6000-0x000000007997bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007997c000-0x0000000079b7bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b7c000-0x0000000079cc0fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079cc1000-0x0000000079cf0fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079cf1000-0x0000000079d83fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079d84000-0x0000000079d86fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079d87000-0x0000000079e17fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079e18000-0x0000000079e82fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079e83000-0x000000007bd5efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007be4efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf86fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bf87000-0x000000007bfcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000087fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Quanta MP Server/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0028.090220101116 09/02/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x880000 max_arch_pfn = 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0x78c76 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdd90-0x000fdd9f] mapped at [ffff8800000fdd90]
[    0.000000]   mpc: efbb0-efe74
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02151000, 0x02151fff] PGTABLE
[    0.000000] BRK [0x02152000, 0x02152fff] PGTABLE
[    0.000000] BRK [0x02153000, 0x02153fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x87fe00000-0x87fffffff]
[    0.000000]  [mem 0x87fe00000-0x87fffffff] page 2M
[    0.000000] BRK [0x02154000, 0x02154fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x87c000000-0x87fdfffff]
[    0.000000]  [mem 0x87c000000-0x87fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x800000000-0x87bffffff]
[    0.000000]  [mem 0x800000000-0x87bffffff] page 2M
[    0.000000] BRK [0x02155000, 0x02155fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x78c75fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x78bfffff] page 2M
[    0.000000]  [mem 0x78c00000-0x78c75fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x7ffffffff]
[    0.000000]  [mem 0x100000000-0x7ffffffff] page 2M
[    0.000000] BRK [0x02156000, 0x02156fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7146e000-0x78c69fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 0x000000007BFFE120 0000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007BFFD000 0000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 0x000000007BFE2000 01A1B2 (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 0x000000007BF87000 000040
[    0.000000] ACPI: APIC 0x000000007BFE1000 0003E4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MSCT 0x000000007BFE0000 000090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: MCFG 0x000000007BFDF000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 0x000000007BFDE000 000038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 0x000000007BFDD000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 0x000000007BFDC000 000930 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 0x000000007BFDB000 000050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 0x000000007BFDA000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 0x000000007BF4A000 03CFA4 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x000000007BFD9000 000174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: PMCT 0x000000007BFD8000 000060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MIGT 0x000000007BFD7000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: TCPA 0x000000007BFD4000 000032 (v00 QUANTA QSSC-S4R 00000000      00000000)
[    0.000000] ACPI: HEST 0x000000007BFD3000 0000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000007BFD2000 000030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000007BFD1000 000230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000007BFD0000 000130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 0x000000007BFCF000 000300 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x27fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x280000000-0x47fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x480000000-0x67fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x680000000-0x87fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x900000000-0x28ffffffff] hotplug
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x2900000000-0x48ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x4900000000-0x68ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x6900000000-0x88ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x8900000000-0xa8ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 2 [mem 0xa900000000-0xc8ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xc900000000-0xe8ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xe900000000-0x108ffffffff] hotplug
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x27fffffff] -> [mem 0x00000000-0x27fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x27fffffff]
[    0.000000]   NODE_DATA [mem 0x27ffd9000-0x27fffffff]
[    0.000000] Initmem setup node 1 [mem 0x280000000-0x47fffffff]
[    0.000000]   NODE_DATA [mem 0x47ffd9000-0x47fffffff]
[    0.000000] Initmem setup node 2 [mem 0x480000000-0x67fffffff]
[    0.000000]   NODE_DATA [mem 0x67ffd9000-0x67fffffff]
[    0.000000] Initmem setup node 3 [mem 0x680000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87ffbb000-0x87ffe1fff]
[    0.000000]  [ffffea0000000000-ffffea0009ffffff] PMD -> [ffff880277e00000-ffff88027fdfffff] on node 0
[    0.000000]  [ffffea000a000000-ffffea0011ffffff] PMD -> [ffff880477e00000-ffff88047fdfffff] on node 1
[    0.000000]  [ffffea0012000000-ffffea0019ffffff] PMD -> [ffff880677e00000-ffff88067fdfffff] on node 2
[    0.000000]  [ffffea001a000000-ffffea0021ffffff] PMD -> [ffff880877600000-ffff88087f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x87fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x78c75fff]
[    0.000000]   node   0: [mem 0x100000000-0x27fffffff]
[    0.000000]   node   1: [mem 0x280000000-0x47fffffff]
[    0.000000]   node   2: [mem 0x480000000-0x67fffffff]
[    0.000000]   node   3: [mem 0x680000000-0x87fffffff]
[    0.000000] On node 0 totalpages: 2067472
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7666 pages used for memmap
[    0.000000]   DMA32 zone: 490614 pages, LIFO batch:31
[    0.000000]   Normal zone: 24576 pages used for memmap
[    0.000000]   Normal zone: 1572864 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
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
[    0.000000] PM: Registered nosave memory: [mem 0x78c76000-0x78e8cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x78e8d000-0x79244fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79245000-0x792bbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792bc000-0x792c3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792c4000-0x792d9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792da000-0x792f4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f5000-0x792f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f8000-0x792f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f9000-0x79303fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79304000-0x79307fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79308000-0x7930cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7930d000-0x79332fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79333000-0x79353fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79354000-0x79384fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79385000-0x793c5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x793c6000-0x7997bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7997c000-0x79b7bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x79b7c000-0x79cc0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cc1000-0x79cf0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cf1000-0x79d83fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d84000-0x79d86fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d87000-0x79e17fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e18000-0x79e82fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e83000-0x7bd5efff]
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
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880277c00000 s88768 r8192 d21824 u131072
[    0.000000] pcpu-alloc: s88768 r8192 d21824 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 32 33 34 35 36 37 38 39 
[    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 40 41 42 43 44 45 46 47 
[    0.000000] pcpu-alloc: [2] 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55 
[    0.000000] pcpu-alloc: [3] 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 8228297
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-nex06/bisect_vm-scalability-300s-mremap-xread-rand-mt-x86_64-rhel-4485154138f6ffa5b252cb490aba3e8eb30124e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/vmlinuz-3.16.0-rc2-00011-g4485154 kconfig=x86_64-rhel commit=4485154138f6ffa5b252cb490aba3e8eb30124e4 branch=linus/master root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-nex06/vm-scalability/300s-mremap-xread-rand-mt/debian-x86_64.cgz/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/0 ip=::::lkp-nex06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 32695936K/33435712K available (8522K kernel code, 1677K rwdata, 3796K rodata, 1796K init, 1880K bss, 739776K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=64.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-63.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=64
[    0.000000] NR_IRQS:524544 nr_irqs:2008 16
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc2-00011-g4485154 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Tue Sep 30 19:18:36 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-nex06/bisect_vm-scalability-300s-mremap-xread-rand-mt-x86_64-rhel-4485154138f6ffa5b252cb490aba3e8eb30124e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/vmlinuz-3.16.0-rc2-00011-g4485154 kconfig=x86_64-rhel commit=4485154138f6ffa5b252cb490aba3e8eb30124e4 branch=linus/master root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-nex06/vm-scalability/300s-mremap-xread-rand-mt/debian-x86_64.cgz/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/0 ip=::::lkp-nex06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009b3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009b400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000078c75fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078c76000-0x0000000078e8cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000078e8d000-0x0000000079244fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079245000-0x00000000792bbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792bc000-0x00000000792c3fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792c4000-0x00000000792d9fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792da000-0x00000000792f4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792f5000-0x00000000792f7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000792f8000-0x00000000792f8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000792f9000-0x0000000079303fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079304000-0x0000000079307fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079308000-0x000000007930cfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007930d000-0x0000000079332fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079333000-0x0000000079353fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079354000-0x0000000079384fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079385000-0x00000000793c5fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000793c6000-0x000000007997bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007997c000-0x0000000079b7bfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000079b7c000-0x0000000079cc0fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079cc1000-0x0000000079cf0fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079cf1000-0x0000000079d83fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079d84000-0x0000000079d86fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079d87000-0x0000000079e17fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000079e18000-0x0000000079e82fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000079e83000-0x000000007bd5efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007be4efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf86fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bf87000-0x000000007bfcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000087fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Quanta MP Server/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0028.090220101116 09/02/2010
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x880000 max_arch_pfn = 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] x2apic enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0x78c76 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdd90-0x000fdd9f] mapped at [ffff8800000fdd90]
[    0.000000]   mpc: efbb0-efe74
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02151000, 0x02151fff] PGTABLE
[    0.000000] BRK [0x02152000, 0x02152fff] PGTABLE
[    0.000000] BRK [0x02153000, 0x02153fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x87fe00000-0x87fffffff]
[    0.000000]  [mem 0x87fe00000-0x87fffffff] page 2M
[    0.000000] BRK [0x02154000, 0x02154fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x87c000000-0x87fdfffff]
[    0.000000]  [mem 0x87c000000-0x87fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x800000000-0x87bffffff]
[    0.000000]  [mem 0x800000000-0x87bffffff] page 2M
[    0.000000] BRK [0x02155000, 0x02155fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x78c75fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x78bfffff] page 2M
[    0.000000]  [mem 0x78c00000-0x78c75fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x7ffffffff]
[    0.000000]  [mem 0x100000000-0x7ffffffff] page 2M
[    0.000000] BRK [0x02156000, 0x02156fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x7146e000-0x78c69fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0410 000024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 0x000000007BFFE120 0000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007BFFD000 0000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 0x000000007BFE2000 01A1B2 (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 0x000000007BF87000 000040
[    0.000000] ACPI: APIC 0x000000007BFE1000 0003E4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MSCT 0x000000007BFE0000 000090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: MCFG 0x000000007BFDF000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 0x000000007BFDE000 000038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 0x000000007BFDD000 00003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 0x000000007BFDC000 000930 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 0x000000007BFDB000 000050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 0x000000007BFDA000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 0x000000007BF4A000 03CFA4 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x000000007BFD9000 000174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: PMCT 0x000000007BFD8000 000060 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MIGT 0x000000007BFD7000 000040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: TCPA 0x000000007BFD4000 000032 (v00 QUANTA QSSC-S4R 00000000      00000000)
[    0.000000] ACPI: HEST 0x000000007BFD3000 0000A8 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x000000007BFD2000 000030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x000000007BFD1000 000230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x000000007BFD0000 000130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 0x000000007BFCF000 000300 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Setting APIC routing to cluster x2apic.
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x27fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x280000000-0x47fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x480000000-0x67fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x680000000-0x87fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x900000000-0x28ffffffff] hotplug
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x2900000000-0x48ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x4900000000-0x68ffffffff] hotplug
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x6900000000-0x88ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x8900000000-0xa8ffffffff] hotplug
[    0.000000] SRAT: Node 2 PXM 2 [mem 0xa900000000-0xc8ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xc900000000-0xe8ffffffff] hotplug
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xe900000000-0x108ffffffff] hotplug
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x27fffffff] -> [mem 0x00000000-0x27fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x27fffffff]
[    0.000000]   NODE_DATA [mem 0x27ffd9000-0x27fffffff]
[    0.000000] Initmem setup node 1 [mem 0x280000000-0x47fffffff]
[    0.000000]   NODE_DATA [mem 0x47ffd9000-0x47fffffff]
[    0.000000] Initmem setup node 2 [mem 0x480000000-0x67fffffff]
[    0.000000]   NODE_DATA [mem 0x67ffd9000-0x67fffffff]
[    0.000000] Initmem setup node 3 [mem 0x680000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87ffbb000-0x87ffe1fff]
[    0.000000]  [ffffea0000000000-ffffea0009ffffff] PMD -> [ffff880277e00000-ffff88027fdfffff] on node 0
[    0.000000]  [ffffea000a000000-ffffea0011ffffff] PMD -> [ffff880477e00000-ffff88047fdfffff] on node 1
[    0.000000]  [ffffea0012000000-ffffea0019ffffff] PMD -> [ffff880677e00000-ffff88067fdfffff] on node 2
[    0.000000]  [ffffea001a000000-ffffea0021ffffff] PMD -> [ffff880877600000-ffff88087f5fffff] on node 3
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x87fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009afff]
[    0.000000]   node   0: [mem 0x00100000-0x78c75fff]
[    0.000000]   node   0: [mem 0x100000000-0x27fffffff]
[    0.000000]   node   1: [mem 0x280000000-0x47fffffff]
[    0.000000]   node   2: [mem 0x480000000-0x67fffffff]
[    0.000000]   node   3: [mem 0x680000000-0x87fffffff]
[    0.000000] On node 0 totalpages: 2067472
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3994 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7666 pages used for memmap
[    0.000000]   DMA32 zone: 490614 pages, LIFO batch:31
[    0.000000]   Normal zone: 24576 pages used for memmap
[    0.000000]   Normal zone: 1572864 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
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
[    0.000000] PM: Registered nosave memory: [mem 0x78c76000-0x78e8cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x78e8d000-0x79244fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79245000-0x792bbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x792bc000-0x792c3fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792c4000-0x792d9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792da000-0x792f4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f5000-0x792f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f8000-0x792f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0x792f9000-0x79303fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79304000-0x79307fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79308000-0x7930cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7930d000-0x79332fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79333000-0x79353fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79354000-0x79384fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79385000-0x793c5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x793c6000-0x7997bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7997c000-0x79b7bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x79b7c000-0x79cc0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cc1000-0x79cf0fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79cf1000-0x79d83fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d84000-0x79d86fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79d87000-0x79e17fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e18000-0x79e82fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79e83000-0x7bd5efff]
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
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880277c00000 s88768 r8192 d21824 u131072
[    0.000000] pcpu-alloc: s88768 r8192 d21824 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 32 33 34 35 36 37 38 39 
[    0.000000] pcpu-alloc: [1] 08 09 10 11 12 13 14 15 40 41 42 43 44 45 46 47 
[    0.000000] pcpu-alloc: [2] 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55 
[    0.000000] pcpu-alloc: [3] 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63 
[    0.000000] Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 8228297
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-nex06/bisect_vm-scalability-300s-mremap-xread-rand-mt-x86_64-rhel-4485154138f6ffa5b252cb490aba3e8eb30124e4-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/vmlinuz-3.16.0-rc2-00011-g4485154 kconfig=x86_64-rhel commit=4485154138f6ffa5b252cb490aba3e8eb30124e4 branch=linus/master root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-nex06/vm-scalability/300s-mremap-xread-rand-mt/debian-x86_64.cgz/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/0 ip=::::lkp-nex06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 32695936K/33435712K available (8522K kernel code, 1677K rwdata, 3796K rodata, 1796K init, 1880K bss, 739776K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=64.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-63.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=64
[    0.000000] NR_IRQS:524544 nr_irqs:2008 16
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 134217728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2261.099 MHz processor
[    0.000060] Calibrating delay loop (skipped), value calculated using timer frequency.. 4522.19 BogoMIPS (lpj=2261099)
[    0.011915] pid_max: default: 65536 minimum: 512
[    0.017098] ACPI: Core revision 20140424
[    0.080545] ACPI: All ACPI Tables successfully acquired
[    0.086526] Security Framework initialized
[    0.091104] SELinux:  Initializing.
[    0.095004] SELinux:  Starting in permissive mode
[    0.103282] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.122019] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.134819] Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.142543] Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.151407] Initializing cgroup subsys memory
[    0.156332] Initializing cgroup subsys devices
[    0.161298] Initializing cgroup subsys freezer
[    0.166258] Initializing cgroup subsys net_cls
[    0.171220] Initializing cgroup subsys blkio
[    0.175988] Initializing cgroup subsys perf_event
[    0.181249] Initializing cgroup subsys hugetlb
[    0.186255] CPU: Physical Processor ID: 0
[    0.190727] CPU: Processor Core ID: 0
[    0.194818] mce: CPU supports 22 MCE banks
[    0.199407] CPU0: Thermal LVT vector (0xfa) already installed
[    0.205833] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.205833] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.205833] tlb_flushall_shift: 6
[    0.222746] Freeing SMP alternatives memory: 36K (ffffffff81f70000 - ffffffff81f79000)
[    0.232997] ftrace: allocating 30823 entries in 121 pages
[    0.257154] Getting VERSION: 60015
[    0.260950] Getting VERSION: 60015
[    0.264743] Getting ID: 0
[    0.267664] Getting ID: 0
[    0.270596] dmar: Host address width 48
[    0.274876] dmar: DRHD base: 0x000000fd800000 flags: 0x0
[    0.280812] dmar: IOMMU 0: reg_base_addr fd800000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.289843] dmar: DRHD base: 0x000000fd000000 flags: 0x1
[    0.295776] dmar: IOMMU 1: reg_base_addr fd000000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.304806] dmar: RMRR base: 0x0000007be29000 end: 0x0000007be2bfff
[    0.311800] dmar: RMRR base: 0x0000007be16000 end: 0x0000007be16fff
[    0.318794] dmar: RMRR base: 0x0000007be13000 end: 0x0000007be13fff
[    0.325787] dmar: RMRR base: 0x0000007be10000 end: 0x0000007be10fff
[    0.332781] dmar: RMRR base: 0x0000007be0d000 end: 0x0000007be0dfff
[    0.339774] dmar: RMRR base: 0x0000007be0a000 end: 0x0000007be0afff
[    0.346768] dmar: RMRR base: 0x0000007be07000 end: 0x0000007be07fff
[    0.353762] dmar: RMRR base: 0x0000007be04000 end: 0x0000007be04fff
[    0.360755] dmar: RMRR base: 0x0000007be01000 end: 0x0000007be01fff
[    0.367749] dmar: ATSR flags: 0x0
[    0.371445] dmar: ATSR flags: 0x0
[    0.375140] dmar: RHSA base: 0x000000fd000000 proximity domain: 0x0
[    0.382133] dmar: RHSA base: 0x000000fd800000 proximity domain: 0x2
[    0.389277] IOAPIC id 10 under DRHD base  0xfd800000 IOMMU 0
[    0.395593] IOAPIC id 8 under DRHD base  0xfd000000 IOMMU 1
[    0.401811] IOAPIC id 9 under DRHD base  0xfd000000 IOMMU 1
[    0.408029] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.417553] Enabled IRQ remapping in x2apic mode
[    0.422714] masked ExtINT on CPU#0
[    0.427091] ENABLING IO-APIC IRQs
[    0.430789] init IO_APIC IRQs
[    0.434097]  apic 8 pin 0 not connected
[    0.438377] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.447221] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:31 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.462271] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.471112] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:30 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.486160] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.495012] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.510063] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.518905] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.533955] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.542797] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:35 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.557848] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.566690] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:36 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.581739] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.590582] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:37 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.605632] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.614476] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.629527] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.638368] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:39 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.653419] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.662455] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3A Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.677505] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.686542] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3B Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.701592] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.710628] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3C Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.725679] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.734717] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.749767] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.758803] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3E Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.773854] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.782889] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3F Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    0.797938]  apic 8 pin 16 not connected
[    0.802314]  apic 8 pin 17 not connected
[    0.806692]  apic 8 pin 18 not connected
[    0.811069]  apic 8 pin 19 not connected
[    0.815446]  apic 8 pin 20 not connected
[    0.819823]  apic 8 pin 21 not connected
[    0.824201]  apic 8 pin 22 not connected
[    0.828577]  apic 8 pin 23 not connected
[    0.832953]  apic 9 pin 0 not connected
[    0.837233]  apic 9 pin 1 not connected
[    0.841512]  apic 9 pin 2 not connected
[    0.845792]  apic 9 pin 3 not connected
[    0.850072]  apic 9 pin 4 not connected
[    0.854351]  apic 9 pin 5 not connected
[    0.858630]  apic 9 pin 6 not connected
[    0.862910]  apic 9 pin 7 not connected
[    0.867189]  apic 9 pin 8 not connected
[    0.871468]  apic 9 pin 9 not connected
[    0.875747]  apic 9 pin 10 not connected
[    0.880124]  apic 9 pin 11 not connected
[    0.884501]  apic 9 pin 12 not connected
[    0.888878]  apic 9 pin 13 not connected
[    0.893255]  apic 9 pin 14 not connected
[    0.897631]  apic 9 pin 15 not connected
[    0.902008]  apic 9 pin 16 not connected
[    0.906384]  apic 9 pin 17 not connected
[    0.910761]  apic 9 pin 18 not connected
[    0.915137]  apic 9 pin 19 not connected
[    0.919514]  apic 9 pin 20 not connected
[    0.923891]  apic 9 pin 21 not connected
[    0.928267]  apic 9 pin 22 not connected
[    0.932644]  apic 9 pin 23 not connected
[    0.937020]  apic 10 pin 0 not connected
[    0.941397]  apic 10 pin 1 not connected
[    0.945774]  apic 10 pin 2 not connected
[    0.950150]  apic 10 pin 3 not connected
[    0.954526]  apic 10 pin 4 not connected
[    0.958902]  apic 10 pin 5 not connected
[    0.963279]  apic 10 pin 6 not connected
[    0.967655]  apic 10 pin 7 not connected
[    0.972032]  apic 10 pin 8 not connected
[    0.976409]  apic 10 pin 9 not connected
[    0.980785]  apic 10 pin 10 not connected
[    0.985259]  apic 10 pin 11 not connected
[    0.989734]  apic 10 pin 12 not connected
[    0.994208]  apic 10 pin 13 not connected
[    0.998682]  apic 10 pin 14 not connected
[    1.003156]  apic 10 pin 15 not connected
[    1.007630]  apic 10 pin 16 not connected
[    1.012105]  apic 10 pin 17 not connected
[    1.016578]  apic 10 pin 18 not connected
[    1.021052]  apic 10 pin 19 not connected
[    1.025525]  apic 10 pin 20 not connected
[    1.030000]  apic 10 pin 21 not connected
[    1.034473]  apic 10 pin 22 not connected
[    1.038947]  apic 10 pin 23 not connected
[    1.043556] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.060264] smpboot: CPU0: Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz (fam: 06, model: 2e, stepping: 06)
[    1.071368] Using local APIC timer interrupts.
[    1.071368] calibrating APIC timer ...
[    1.181552] ... lapic delta = 831240
[    1.185530] ... PM-Timer delta = 357950
[    1.189808] ... PM-Timer result ok
[    1.193601] ..... delta 831240
[    1.197007] ..... mult: 35701486
[    1.200606] ..... calibration result: 132998
[    1.205368] ..... CPU clock speed is 2260.0971 MHz.
[    1.210809] ..... host bus clock speed is 132.0998 MHz.
[    1.216687] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    1.225974] perf_event_intel: CPU erratum AAJ80 worked around
[    1.232389] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    1.240063] ... version:                3
[    1.244537] ... bit width:              48
[    1.249108] ... generic registers:      4
[    1.253581] ... value mask:             0000ffffffffffff
[    1.259508] ... max period:             000000007fffffff
[    1.265435] ... fixed-purpose events:   3
[    1.269908] ... event mask:             000000070000000f
[    1.280715] x86: Booting SMP configuration:
[    1.285386] .... node  #0, CPUs:        #1
[    1.301572] masked ExtINT on CPU#1
[    1.305619] CPU1: Thermal LVT vector (0xfa) already installed
[    1.316102] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.325222]   #2
[    1.338786] masked ExtINT on CPU#2
[    1.342843] CPU2: Thermal LVT vector (0xfa) already installed
[    1.351554]   #3
[    1.365032] masked ExtINT on CPU#3
[    1.369093] CPU3: Thermal LVT vector (0xfa) already installed
[    1.377783]   #4
[    1.391260] masked ExtINT on CPU#4
[    1.395318] CPU4: Thermal LVT vector (0xfa) already installed
[    1.404017]   #5
[    1.417495] masked ExtINT on CPU#5
[    1.421547] CPU5: Thermal LVT vector (0xfa) already installed
[    1.430242]   #6
[    1.443720] masked ExtINT on CPU#6
[    1.447777] CPU6: Thermal LVT vector (0xfa) already installed
[    1.456467]   #7
[    1.469944] masked ExtINT on CPU#7
[    1.474002] CPU7: Thermal LVT vector (0xfa) already installed
[    1.482751] 
[    1.484417] .... node  #1, CPUs:    #8
[    1.500641] masked ExtINT on CPU#8
[    1.504692] CPU8: Thermal LVT vector (0xfa) already installed
[    1.590941]   #9
[    1.605035] masked ExtINT on CPU#9
[    1.609103] CPU9: Thermal LVT vector (0xfa) already installed
[    1.617804]  #10
[    1.631902] masked ExtINT on CPU#10
[    1.636069] CPU10: Thermal LVT vector (0xfa) already installed
[    1.644845]  #11
[    1.658942] masked ExtINT on CPU#11
[    1.663104] CPU11: Thermal LVT vector (0xfa) already installed
[    1.671899]  #12
[    1.685995] masked ExtINT on CPU#12
[    1.690158] CPU12: Thermal LVT vector (0xfa) already installed
[    1.698948]  #13
[    1.713044] masked ExtINT on CPU#13
[    1.717214] CPU13: Thermal LVT vector (0xfa) already installed
[    1.725999]  #14
[    1.740096] masked ExtINT on CPU#14
[    1.744252] CPU14: Thermal LVT vector (0xfa) already installed
[    1.753055]  #15
[    1.767153] masked ExtINT on CPU#15
[    1.771324] CPU15: Thermal LVT vector (0xfa) already installed
[    1.780140] 
[    1.781806] .... node  #2, CPUs:   #16
[    1.797412] masked ExtINT on CPU#16
[    1.801561] CPU16: Thermal LVT vector (0xfa) already installed
[    1.887928]  #17
[    1.901415] masked ExtINT on CPU#17
[    1.905575] CPU17: Thermal LVT vector (0xfa) already installed
[    1.914374]  #18
[    1.927861] masked ExtINT on CPU#18
[    1.932020] CPU18: Thermal LVT vector (0xfa) already installed
[    1.940834]  #19
[    1.954319] masked ExtINT on CPU#19
[    1.958479] CPU19: Thermal LVT vector (0xfa) already installed
[    1.967294]  #20
[    1.980778] masked ExtINT on CPU#20
[    1.984940] CPU20: Thermal LVT vector (0xfa) already installed
[    1.993739]  #21
[    2.007223] masked ExtINT on CPU#21
[    2.011386] CPU21: Thermal LVT vector (0xfa) already installed
[    2.020187]  #22
[    2.033664] masked ExtINT on CPU#22
[    2.037825] CPU22: Thermal LVT vector (0xfa) already installed
[    2.046631]  #23
[    2.060118] masked ExtINT on CPU#23
[    2.064277] CPU23: Thermal LVT vector (0xfa) already installed
[    2.073135] 
[    2.074799] .... node  #3, CPUs:   #24
[    2.092403] masked ExtINT on CPU#24
[    2.096573] CPU24: Thermal LVT vector (0xfa) already installed
[    2.182929]  #25
[    2.198404] masked ExtINT on CPU#25
[    2.202593] CPU25: Thermal LVT vector (0xfa) already installed
[    2.211384]  #26
[    2.226859] masked ExtINT on CPU#26
[    2.231049] CPU26: Thermal LVT vector (0xfa) already installed
[    2.239835]  #27
[    2.255314] masked ExtINT on CPU#27
[    2.259501] CPU27: Thermal LVT vector (0xfa) already installed
[    2.268304]  #28
[    2.283776] masked ExtINT on CPU#28
[    2.287959] CPU28: Thermal LVT vector (0xfa) already installed
[    2.296767]  #29
[    2.312240] masked ExtINT on CPU#29
[    2.316422] CPU29: Thermal LVT vector (0xfa) already installed
[    2.325218]  #30
[    2.340690] masked ExtINT on CPU#30
[    2.344873] CPU30: Thermal LVT vector (0xfa) already installed
[    2.353668]  #31
[    2.369143] masked ExtINT on CPU#31
[    2.373324] CPU31: Thermal LVT vector (0xfa) already installed
[    2.382135] 
[    2.383799] .... node  #0, CPUs:   #32
[    2.399583] masked ExtINT on CPU#32
[    2.403733] CPU32: Thermal LVT vector (0xfa) already installed
[    2.412548]  #33
[    2.426029] masked ExtINT on CPU#33
[    2.430175] CPU33: Thermal LVT vector (0xfa) already installed
[    2.438974]  #34
[    2.452458] masked ExtINT on CPU#34
[    2.456606] CPU34: Thermal LVT vector (0xfa) already installed
[    2.465403]  #35
[    2.478887] masked ExtINT on CPU#35
[    2.483035] CPU35: Thermal LVT vector (0xfa) already installed
[    2.491861]  #36
[    2.505342] masked ExtINT on CPU#36
[    2.509490] CPU36: Thermal LVT vector (0xfa) already installed
[    2.518293]  #37
[    2.531775] masked ExtINT on CPU#37
[    2.535922] CPU37: Thermal LVT vector (0xfa) already installed
[    2.544734]  #38
[    2.558216] masked ExtINT on CPU#38
[    2.562364] CPU38: Thermal LVT vector (0xfa) already installed
[    2.571174]  #39
[    2.584658] masked ExtINT on CPU#39
[    2.588811] CPU39: Thermal LVT vector (0xfa) already installed
[    2.597631] 
[    2.599299] .... node  #1, CPUs:   #40
[    2.615526] masked ExtINT on CPU#40
[    2.619677] CPU40: Thermal LVT vector (0xfa) already installed
[    2.628403]  #41
[    2.642501] masked ExtINT on CPU#41
[    2.646681] CPU41: Thermal LVT vector (0xfa) already installed
[    2.655501]  #42
[    2.669599] masked ExtINT on CPU#42
[    2.673770] CPU42: Thermal LVT vector (0xfa) already installed
[    2.682556]  #43
[    2.696656] masked ExtINT on CPU#43
[    2.700824] CPU43: Thermal LVT vector (0xfa) already installed
[    2.709636]  #44
[    2.723735] masked ExtINT on CPU#44
[    2.727897] CPU44: Thermal LVT vector (0xfa) already installed
[    2.736691]  #45
[    2.750790] masked ExtINT on CPU#45
[    2.754962] CPU45: Thermal LVT vector (0xfa) already installed
[    2.763762]  #46
[    2.777861] masked ExtINT on CPU#46
[    2.782031] CPU46: Thermal LVT vector (0xfa) already installed
[    2.790830]  #47
[    2.804929] masked ExtINT on CPU#47
[    2.809090] CPU47: Thermal LVT vector (0xfa) already installed
[    2.817920] 
[    2.819585] .... node  #2, CPUs:   #48
[    2.835201] masked ExtINT on CPU#48
[    2.839341] CPU48: Thermal LVT vector (0xfa) already installed
[    2.848079]  #49
[    2.861567] masked ExtINT on CPU#49
[    2.865725] CPU49: Thermal LVT vector (0xfa) already installed
[    2.874551]  #50
[    2.888038] masked ExtINT on CPU#50
[    2.892195] CPU50: Thermal LVT vector (0xfa) already installed
[    2.901039]  #51
[    2.914518] masked ExtINT on CPU#51
[    2.918677] CPU51: Thermal LVT vector (0xfa) already installed
[    2.927484]  #52
[    2.940972] masked ExtINT on CPU#52
[    2.945134] CPU52: Thermal LVT vector (0xfa) already installed
[    2.953930]  #53
[    2.967419] masked ExtINT on CPU#53
[    2.971576] CPU53: Thermal LVT vector (0xfa) already installed
[    2.980392]  #54
[    2.993880] masked ExtINT on CPU#54
[    2.998038] CPU54: Thermal LVT vector (0xfa) already installed
[    3.006857]  #55
[    3.020346] masked ExtINT on CPU#55
[    3.024508] CPU55: Thermal LVT vector (0xfa) already installed
[    3.033338] 
[    3.035003] .... node  #3, CPUs:   #56
[    3.052609] masked ExtINT on CPU#56
[    3.056772] CPU56: Thermal LVT vector (0xfa) already installed
[    3.065504]  #57
[    3.080980] masked ExtINT on CPU#57
[    3.085160] CPU57: Thermal LVT vector (0xfa) already installed
[    3.093993]  #58
[    3.109471] masked ExtINT on CPU#58
[    3.113652] CPU58: Thermal LVT vector (0xfa) already installed
[    3.122455]  #59
[    3.137934] masked ExtINT on CPU#59
[    3.142117] CPU59: Thermal LVT vector (0xfa) already installed
[    3.150931]  #60
[    3.166409] masked ExtINT on CPU#60
[    3.170598] CPU60: Thermal LVT vector (0xfa) already installed
[    3.179391]  #61
[    3.194868] masked ExtINT on CPU#61
[    3.199054] CPU61: Thermal LVT vector (0xfa) already installed
[    3.207871]  #62
[    3.223349] masked ExtINT on CPU#62
[    3.227533] CPU62: Thermal LVT vector (0xfa) already installed
[    3.236324]  #63
[    3.251803] masked ExtINT on CPU#63
[    3.255981] CPU63: Thermal LVT vector (0xfa) already installed
[    3.264651] x86: Booted up 4 nodes, 64 CPUs
[    3.269324] smpboot: Total of 64 processors activated (289378.75 BogoMIPS)
[    3.654772] devtmpfs: initialized
[    3.664207] evm: security.selinux
[    3.667909] evm: security.ima
[    3.671221] evm: security.capability
[    3.675435] PM: Registering ACPI NVS region [mem 0x78c76000-0x78e8cfff] (2191360 bytes)
[    3.684437] PM: Registering ACPI NVS region [mem 0x7997c000-0x79b7bfff] (2097152 bytes)
[    3.693440] PM: Registering ACPI NVS region [mem 0x7bf87000-0x7bfcefff] (294912 bytes)
[    3.704199] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    3.712106] NET: Registered protocol family 16
[    3.717359] cpuidle: using governor menu
[    3.721906] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    3.730359] ACPI: bus type PCI registered
[    3.734834] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    3.742157] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    3.752553] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    3.760791] PCI: Using configuration type 1 for base access
[    3.774211] ACPI: Added _OSI(Module Device)
[    3.778883] ACPI: Added _OSI(Processor Device)
[    3.783842] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.789091] ACPI: Added _OSI(Processor Aggregator Device)
[    3.846509] ACPI Error: Field [CPB3] at 96 exceeds Buffer [NULL] size 64 (bits) (20140424/dsopcode-236)
[    3.857024] ACPI Error: Method parse/execution failed [\_SB_._OSC] (Node ffff88087f80d3e8), AE_AML_BUFFER_LIMIT (20140424/psparse-536)
[    3.883901] ACPI: Interpreter enabled
[    3.888000] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    3.898319] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140424/hwxface-580)
[    3.908639] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20140424/hwxface-580)
[    3.918960] ACPI: (supports S0 S1 S5)
[    3.923047] ACPI: Using IOAPIC for interrupt routing
[    3.928641] HEST: Table parsing has been initialized.
[    3.934282] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    3.965622] ACPI: PCI Root Bridge [IOH0] (domain 0000 [bus 00-7f])
[    3.972528] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.984346] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    3.991717] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    4.000658] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    4.014896] PCI host bridge to bus 0000:00
[    4.019470] pci_bus 0000:00: root bus resource [bus 00-7f]
[    4.025586] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    4.032485] pci_bus 0000:00: root bus resource [io  0x1000-0x9fff]
[    4.039385] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    4.047061] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    4.054738] pci_bus 0000:00: root bus resource [mem 0x90000000-0xcfffffff]
[    4.062414] pci_bus 0000:00: root bus resource [mem 0xfc000000000-0xfc07fffffff]
[    4.070684] pci 0000:00:00.0: [8086:3407] type 00 class 0x060000
[    4.077449] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    4.084362] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    4.091125] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    4.097989] pci 0000:00:01.0: System wakeup disabled by ACPI
[    4.104351] pci 0000:00:02.0: [8086:3409] type 01 class 0x060400
[    4.111113] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    4.117974] pci 0000:00:02.0: System wakeup disabled by ACPI
[    4.124337] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    4.131100] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    4.138004] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    4.144765] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    4.151626] pci 0000:00:05.0: System wakeup disabled by ACPI
[    4.157988] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    4.164742] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    4.171602] pci 0000:00:07.0: System wakeup disabled by ACPI
[    4.177965] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    4.184717] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    4.191577] pci 0000:00:09.0: System wakeup disabled by ACPI
[    4.197936] pci 0000:00:0a.0: [8086:3411] type 01 class 0x060400
[    4.204697] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    4.211560] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    4.217922] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[    4.224749] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[    4.231570] pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
[    4.238396] pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
[    4.245221] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    4.251938] pci 0000:00:13.0: reg 0x10: [mem 0x9bb02000-0x9bb02fff]
[    4.258970] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    4.265864] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    4.272698] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    4.279531] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    4.286356] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    4.293173] pci 0000:00:15.0: [8086:342f] type 00 class 0x080020
[    4.300001] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    4.306719] pci 0000:00:16.0: reg 0x10: [mem 0xcff1c000-0xcff1ffff 64bit]
[    4.314440] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    4.321157] pci 0000:00:16.1: reg 0x10: [mem 0xcff18000-0xcff1bfff 64bit]
[    4.328873] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    4.335590] pci 0000:00:16.2: reg 0x10: [mem 0xcff14000-0xcff17fff 64bit]
[    4.343306] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    4.350024] pci 0000:00:16.3: reg 0x10: [mem 0xcff10000-0xcff13fff 64bit]
[    4.357738] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    4.364455] pci 0000:00:16.4: reg 0x10: [mem 0xcff0c000-0xcff0ffff 64bit]
[    4.372164] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    4.378886] pci 0000:00:16.5: reg 0x10: [mem 0xcff08000-0xcff0bfff 64bit]
[    4.386600] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    4.393318] pci 0000:00:16.6: reg 0x10: [mem 0xcff04000-0xcff07fff 64bit]
[    4.401037] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    4.407754] pci 0000:00:16.7: reg 0x10: [mem 0xcff00000-0xcff03fff 64bit]
[    4.415479] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    4.422223] pci 0000:00:1a.0: reg 0x20: [io  0x50c0-0x50df]
[    4.428551] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    4.434917] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    4.441664] pci 0000:00:1a.1: reg 0x20: [io  0x50a0-0x50bf]
[    4.447988] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    4.454351] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    4.461088] pci 0000:00:1a.2: reg 0x20: [io  0x5080-0x509f]
[    4.467414] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    4.473784] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    4.480507] pci 0000:00:1a.7: reg 0x10: [mem 0x9bb01000-0x9bb013ff]
[    4.487582] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    4.494459] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    4.500822] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    4.507603] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    4.514469] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    4.520838] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    4.527614] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    4.534478] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    4.540843] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    4.547588] pci 0000:00:1d.0: reg 0x20: [io  0x5060-0x507f]
[    4.553912] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    4.560277] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    4.567025] pci 0000:00:1d.1: reg 0x20: [io  0x5040-0x505f]
[    4.573351] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    4.579714] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    4.586459] pci 0000:00:1d.2: reg 0x20: [io  0x5020-0x503f]
[    4.592782] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    4.599155] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    4.605878] pci 0000:00:1d.7: reg 0x10: [mem 0x9bb00000-0x9bb003ff]
[    4.612952] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    4.619831] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    4.626194] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    4.633002] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    4.639367] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    4.646147] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    4.654990] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    4.662957] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    4.671411] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    4.679863] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 001f)
[    4.688434] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[    4.695153] pci 0000:00:1f.2: reg 0x10: [io  0x5138-0x513f]
[    4.701379] pci 0000:00:1f.2: reg 0x14: [io  0x514c-0x514f]
[    4.707605] pci 0000:00:1f.2: reg 0x18: [io  0x5130-0x5137]
[    4.713831] pci 0000:00:1f.2: reg 0x1c: [io  0x5148-0x514b]
[    4.720056] pci 0000:00:1f.2: reg 0x20: [io  0x5110-0x511f]
[    4.726283] pci 0000:00:1f.2: reg 0x24: [io  0x5100-0x510f]
[    4.732624] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    4.739344] pci 0000:00:1f.3: reg 0x10: [mem 0xcff20000-0xcff200ff 64bit]
[    4.746940] pci 0000:00:1f.3: reg 0x20: [io  0x5000-0x501f]
[    4.753267] pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
[    4.759986] pci 0000:00:1f.5: reg 0x10: [io  0x5128-0x512f]
[    4.766213] pci 0000:00:1f.5: reg 0x14: [io  0x5144-0x5147]
[    4.772440] pci 0000:00:1f.5: reg 0x18: [io  0x5120-0x5127]
[    4.778666] pci 0000:00:1f.5: reg 0x1c: [io  0x5140-0x5143]
[    4.784893] pci 0000:00:1f.5: reg 0x20: [io  0x50f0-0x50ff]
[    4.791119] pci 0000:00:1f.5: reg 0x24: [io  0x50e0-0x50ef]
[    4.797569] pci 0000:01:00.0: [8086:150a] type 00 class 0x020000
[    4.804293] pci 0000:01:00.0: reg 0x10: [mem 0x9ba20000-0x9ba3ffff]
[    4.811308] pci 0000:01:00.0: reg 0x18: [io  0x4020-0x403f]
[    4.817538] pci 0000:01:00.0: reg 0x1c: [mem 0x9bac4000-0x9bac7fff]
[    4.824626] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    4.831474] pci 0000:01:00.0: reg 0x184: [mem 0x9ba40000-0x9ba43fff 64bit]
[    4.839169] pci 0000:01:00.0: reg 0x190: [mem 0x9ba60000-0x9ba63fff 64bit]
[    4.846934] pci 0000:01:00.1: [8086:150a] type 00 class 0x020000
[    4.853656] pci 0000:01:00.1: reg 0x10: [mem 0x9ba00000-0x9ba1ffff]
[    4.860671] pci 0000:01:00.1: reg 0x18: [io  0x4000-0x401f]
[    4.866901] pci 0000:01:00.1: reg 0x1c: [mem 0x9bac0000-0x9bac3fff]
[    4.873991] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    4.880835] pci 0000:01:00.1: reg 0x184: [mem 0x9ba80000-0x9ba83fff 64bit]
[    4.888531] pci 0000:01:00.1: reg 0x190: [mem 0x9baa0000-0x9baa3fff 64bit]
[    4.899519] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    4.905354] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    4.912160] pci 0000:00:01.0:   bridge window [mem 0x9ba00000-0x9bafffff]
[    4.919860] pci 0000:04:00.0: [8086:150a] type 00 class 0x020000
[    4.926582] pci 0000:04:00.0: reg 0x10: [mem 0x9b920000-0x9b93ffff]
[    4.933595] pci 0000:04:00.0: reg 0x18: [io  0x3020-0x303f]
[    4.939825] pci 0000:04:00.0: reg 0x1c: [mem 0x9b9c4000-0x9b9c7fff]
[    4.946915] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    4.953763] pci 0000:04:00.0: reg 0x184: [mem 0x9b940000-0x9b943fff 64bit]
[    4.961451] pci 0000:04:00.0: reg 0x190: [mem 0x9b960000-0x9b963fff 64bit]
[    4.969215] pci 0000:04:00.1: [8086:150a] type 00 class 0x020000
[    4.975928] pci 0000:04:00.1: reg 0x10: [mem 0x9b900000-0x9b91ffff]
[    4.982941] pci 0000:04:00.1: reg 0x18: [io  0x3000-0x301f]
[    4.989170] pci 0000:04:00.1: reg 0x1c: [mem 0x9b9c0000-0x9b9c3fff]
[    4.996260] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    5.003103] pci 0000:04:00.1: reg 0x184: [mem 0x9b980000-0x9b983fff 64bit]
[    5.010798] pci 0000:04:00.1: reg 0x190: [mem 0x9b9a0000-0x9b9a3fff 64bit]
[    5.020525] pci 0000:00:02.0: PCI bridge to [bus 04-06]
[    5.026362] pci 0000:00:02.0:   bridge window [io  0x3000-0x3fff]
[    5.033165] pci 0000:00:02.0:   bridge window [mem 0x9b900000-0x9b9fffff]
[    5.040828] pci 0000:00:03.0: PCI bridge to [bus 07]
[    5.046574] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
[    5.052410] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    5.059214] pci 0000:00:05.0:   bridge window [mem 0x9a900000-0x9b8fffff]
[    5.066786] pci 0000:00:05.0:   bridge window [mem 0x95900000-0x998fffff 64bit pref]
[    5.075633] pci 0000:0b:00.0: [1000:0060] type 00 class 0x010400
[    5.082356] pci 0000:0b:00.0: reg 0x10: [mem 0x99900000-0x9993ffff 64bit]
[    5.089942] pci 0000:0b:00.0: reg 0x18: [io  0x1000-0x10ff]
[    5.096172] pci 0000:0b:00.0: reg 0x1c: [mem 0x99940000-0x9997ffff 64bit]
[    5.103764] pci 0000:0b:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
[    5.111290] pci 0000:0b:00.0: supports D1
[    5.118525] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
[    5.124361] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
[    5.131157] pci 0000:00:07.0:   bridge window [mem 0x99900000-0x9a8fffff]
[    5.138728] pci 0000:00:07.0:   bridge window [mem 0x91900000-0x958fffff 64bit pref]
[    5.147568] pci 0000:00:09.0: PCI bridge to [bus 0e]
[    5.153302] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    5.158959] pci 0000:00:1c.0: PCI bridge to [bus 10]
[    5.164505] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    5.171309] pci 0000:00:1c.0:   bridge window [mem 0x9bc00000-0x9bdfffff]
[    5.178892] pci 0000:00:1c.0:   bridge window [mem 0xfc000000000-0xfc0001fffff 64bit pref]
[    5.188201] pci 0000:11:00.0: [102b:0522] type 00 class 0x030000
[    5.194930] pci 0000:11:00.0: reg 0x10: [mem 0x90000000-0x90ffffff pref]
[    5.202424] pci 0000:11:00.0: reg 0x14: [mem 0x91800000-0x91803fff]
[    5.209434] pci 0000:11:00.0: reg 0x18: [mem 0x91000000-0x917fffff]
[    5.216481] pci 0000:11:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    5.226534] pci 0000:00:1c.4: PCI bridge to [bus 11]
[    5.232081] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x918fffff]
[    5.239664] pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    5.248379] pci 0000:00:1e.0: PCI bridge to [bus 12] (subtractive decode)
[    5.255966] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    5.264807] pci 0000:00:1e.0:   bridge window [io  0x1000-0x9fff] (subtractive decode)
[    5.273646] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    5.283262] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    5.292877] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xcfffffff] (subtractive decode)
[    5.302494] pci 0000:00:1e.0:   bridge window [mem 0xfc000000000-0xfc07fffffff] (subtractive decode)
[    5.312726] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    5.320998] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.330536] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.340068] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.349603] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.359135] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.368670] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.378201] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.387728] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    5.397247] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    5.406288] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:3D Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    5.421619] ACPI: PCI Root Bridge [IOH1] (domain 0000 [bus 80-f7])
[    5.428522] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.437759] acpi PNP0A08:01: _OSC: platform does not support [AER]
[    5.444750] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    5.453448] PCI host bridge to bus 0000:80
[    5.458023] pci_bus 0000:80: root bus resource [bus 80-f7]
[    5.464139] pci_bus 0000:80: root bus resource [io  0xa000-0xffff]
[    5.471039] pci_bus 0000:80: root bus resource [mem 0xd0000000-0xfbffffff]
[    5.478716] pci_bus 0000:80: root bus resource [mem 0xfc080000000-0xfc0ffffffff]
[    5.486988] pci 0000:80:00.0: [8086:3420] type 01 class 0x060400
[    5.493756] pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
[    5.500586] pci 0000:80:00.0: System wakeup disabled by ACPI
[    5.506954] pci 0000:80:01.0: [8086:3408] type 01 class 0x060400
[    5.513721] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
[    5.520558] pci 0000:80:01.0: System wakeup disabled by ACPI
[    5.526921] pci 0000:80:03.0: [8086:340a] type 01 class 0x060400
[    5.533679] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    5.540514] pci 0000:80:03.0: System wakeup disabled by ACPI
[    5.546877] pci 0000:80:07.0: [8086:340e] type 01 class 0x060400
[    5.553644] pci 0000:80:07.0: PME# supported from D0 D3hot D3cold
[    5.560478] pci 0000:80:07.0: System wakeup disabled by ACPI
[    5.566843] pci 0000:80:09.0: [8086:3410] type 01 class 0x060400
[    5.573608] pci 0000:80:09.0: PME# supported from D0 D3hot D3cold
[    5.580442] pci 0000:80:09.0: System wakeup disabled by ACPI
[    5.586803] pci 0000:80:10.0: [8086:3425] type 00 class 0x080000
[    5.593606] pci 0000:80:10.1: [8086:3426] type 00 class 0x080000
[    5.600401] pci 0000:80:11.0: [8086:3427] type 00 class 0x080000
[    5.607203] pci 0000:80:11.1: [8086:3428] type 00 class 0x080000
[    5.613992] pci 0000:80:13.0: [8086:342d] type 00 class 0x080020
[    5.620710] pci 0000:80:13.0: reg 0x10: [mem 0xd2000000-0xd2000fff]
[    5.627752] pci 0000:80:13.0: PME# supported from D0 D3hot D3cold
[    5.634620] pci 0000:80:14.0: [8086:342e] type 00 class 0x080000
[    5.641428] pci 0000:80:14.1: [8086:3422] type 00 class 0x080000
[    5.648236] pci 0000:80:14.2: [8086:3423] type 00 class 0x080000
[    5.655040] pci 0000:80:14.3: [8086:3438] type 00 class 0x080000
[    5.661833] pci 0000:80:15.0: [8086:342f] type 00 class 0x080020
[    5.668630] pci 0000:80:16.0: [8086:3430] type 00 class 0x088000
[    5.675348] pci 0000:80:16.0: reg 0x10: [mem 0xfbf1c000-0xfbf1ffff 64bit]
[    5.683044] pci 0000:80:16.1: [8086:3431] type 00 class 0x088000
[    5.689761] pci 0000:80:16.1: reg 0x10: [mem 0xfbf18000-0xfbf1bfff 64bit]
[    5.697449] pci 0000:80:16.2: [8086:3432] type 00 class 0x088000
[    5.704168] pci 0000:80:16.2: reg 0x10: [mem 0xfbf14000-0xfbf17fff 64bit]
[    5.711861] pci 0000:80:16.3: [8086:3433] type 00 class 0x088000
[    5.718578] pci 0000:80:16.3: reg 0x10: [mem 0xfbf10000-0xfbf13fff 64bit]
[    5.726270] pci 0000:80:16.4: [8086:3429] type 00 class 0x088000
[    5.732989] pci 0000:80:16.4: reg 0x10: [mem 0xfbf0c000-0xfbf0ffff 64bit]
[    5.740689] pci 0000:80:16.5: [8086:342a] type 00 class 0x088000
[    5.747407] pci 0000:80:16.5: reg 0x10: [mem 0xfbf08000-0xfbf0bfff 64bit]
[    5.755100] pci 0000:80:16.6: [8086:342b] type 00 class 0x088000
[    5.761817] pci 0000:80:16.6: reg 0x10: [mem 0xfbf04000-0xfbf07fff 64bit]
[    5.769510] pci 0000:80:16.7: [8086:342c] type 00 class 0x088000
[    5.776228] pci 0000:80:16.7: reg 0x10: [mem 0xfbf00000-0xfbf03fff 64bit]
[    5.784111] pci 0000:80:00.0: PCI bridge to [bus 81]
[    5.789851] pci 0000:80:01.0: PCI bridge to [bus 82]
[    5.795593] pci 0000:80:03.0: PCI bridge to [bus 83]
[    5.801332] pci 0000:80:07.0: PCI bridge to [bus 84-86]
[    5.807168] pci 0000:80:07.0:   bridge window [io  0xb000-0xbfff]
[    5.813972] pci 0000:80:07.0:   bridge window [mem 0xd1000000-0xd1ffffff]
[    5.821555] pci 0000:80:07.0:   bridge window [mem 0xf3f00000-0xf7efffff 64bit pref]
[    5.830394] pci 0000:80:09.0: PCI bridge to [bus 87-89]
[    5.836230] pci 0000:80:09.0:   bridge window [io  0xa000-0xafff]
[    5.843035] pci 0000:80:09.0:   bridge window [mem 0xd0000000-0xd0ffffff]
[    5.850607] pci 0000:80:09.0:   bridge window [mem 0xf7f00000-0xfbefffff 64bit pref]
[    5.859269] acpi PNP0A08:01: Disabling ASPM (FADT indicates it is unsupported)
[    5.867528] ACPI: PCI Root Bridge [PRB3] (domain 0000 [bus fc])
[    5.874142] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    5.883277] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    5.890694] PCI host bridge to bus 0000:fc
[    5.895268] pci_bus 0000:fc: root bus resource [bus fc]
[    5.901106] pci 0000:fc:00.0: [8086:2b00] type 00 class 0x060000
[    5.907868] pci 0000:fc:00.2: [8086:2b02] type 00 class 0x060000
[    5.914628] pci 0000:fc:00.4: [8086:2b22] type 00 class 0x060000
[    5.921379] pci 0000:fc:00.6: [8086:2b2a] type 00 class 0x060000
[    5.928138] pci 0000:fc:01.0: [8086:2b04] type 00 class 0x060000
[    5.934897] pci 0000:fc:02.0: [8086:2b08] type 00 class 0x060000
[    5.941659] pci 0000:fc:03.0: [8086:2b0c] type 00 class 0x060000
[    5.948420] pci 0000:fc:04.0: [8086:2b10] type 00 class 0x060000
[    5.955183] pci 0000:fc:05.0: [8086:2b14] type 00 class 0x060000
[    5.961941] pci 0000:fc:05.2: [8086:2b16] type 00 class 0x060000
[    5.968700] pci 0000:fc:05.4: [8086:2b13] type 00 class 0x060000
[    5.975455] pci 0000:fc:06.0: [8086:2b18] type 00 class 0x060000
[    5.982218] pci 0000:fc:07.0: [8086:2b1c] type 00 class 0x060000
[    5.988979] pci 0000:fc:07.2: [8086:2b1e] type 00 class 0x060000
[    5.995739] pci 0000:fc:07.4: [8086:2b1b] type 00 class 0x060000
[    6.002493] pci 0000:fc:08.0: [8086:2b20] type 00 class 0x060000
[    6.009266] pci 0000:fc:09.0: [8086:2b24] type 00 class 0x060000
[    6.016025] pci 0000:fc:0a.0: [8086:2b28] type 00 class 0x060000
[    6.022781] pci 0000:fc:0b.0: [8086:2b2c] type 00 class 0x060000
[    6.029543] pci 0000:fc:0c.0: [8086:2b30] type 00 class 0x060000
[    6.036308] pci 0000:fc:0d.0: [8086:2b34] type 00 class 0x060000
[    6.043074] pci 0000:fc:0e.0: [8086:2b38] type 00 class 0x060000
[    6.049836] pci 0000:fc:0f.0: [8086:2b3c] type 00 class 0x060000
[    6.056594] pci 0000:fc:10.0: [8086:2b40] type 00 class 0x060000
[    6.063356] pci 0000:fc:10.2: [8086:2b42] type 00 class 0x060000
[    6.070115] pci 0000:fc:10.4: [8086:2b32] type 00 class 0x060000
[    6.076865] pci 0000:fc:10.6: [8086:2b3a] type 00 class 0x060000
[    6.083624] pci 0000:fc:11.0: [8086:2b44] type 00 class 0x060000
[    6.090385] pci 0000:fc:11.2: [8086:2b46] type 00 class 0x060000
[    6.097143] pci 0000:fc:11.4: [8086:2b36] type 00 class 0x060000
[    6.103905] pci 0000:fc:11.6: [8086:2b3e] type 00 class 0x060000
[    6.110665] pci 0000:fc:12.0: [8086:2b48] type 00 class 0x060000
[    6.117429] pci 0000:fc:13.0: [8086:2b4c] type 00 class 0x060000
[    6.124195] pci 0000:fc:14.0: [8086:2b50] type 00 class 0x060000
[    6.130959] pci 0000:fc:14.2: [8086:2b52] type 00 class 0x060000
[    6.137717] pci 0000:fc:15.0: [8086:2b54] type 00 class 0x060000
[    6.144488] pci 0000:fc:15.2: [8086:2b56] type 00 class 0x060000
[    6.151255] pci 0000:fc:16.0: [8086:2b58] type 00 class 0x060000
[    6.158015] pci 0000:fc:16.2: [8086:2b5a] type 00 class 0x060000
[    6.164779] pci 0000:fc:17.0: [8086:2b5c] type 00 class 0x060000
[    6.171540] pci 0000:fc:17.2: [8086:2b5e] type 00 class 0x060000
[    6.178297] pci 0000:fc:18.0: [8086:2b60] type 00 class 0x060000
[    6.185058] pci 0000:fc:18.2: [8086:2b62] type 00 class 0x060000
[    6.191821] pci 0000:fc:19.0: [8086:2b64] type 00 class 0x060000
[    6.198583] pci 0000:fc:19.2: [8086:2b66] type 00 class 0x060000
[    6.205408] ACPI: PCI Root Bridge [PRB2] (domain 0000 [bus fd])
[    6.212023] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.221156] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    6.228582] PCI host bridge to bus 0000:fd
[    6.233154] pci_bus 0000:fd: root bus resource [bus fd]
[    6.238992] pci 0000:fd:00.0: [8086:2b00] type 00 class 0x060000
[    6.245747] pci 0000:fd:00.2: [8086:2b02] type 00 class 0x060000
[    6.252507] pci 0000:fd:00.4: [8086:2b22] type 00 class 0x060000
[    6.259267] pci 0000:fd:00.6: [8086:2b2a] type 00 class 0x060000
[    6.266026] pci 0000:fd:01.0: [8086:2b04] type 00 class 0x060000
[    6.272781] pci 0000:fd:02.0: [8086:2b08] type 00 class 0x060000
[    6.279544] pci 0000:fd:03.0: [8086:2b0c] type 00 class 0x060000
[    6.286303] pci 0000:fd:04.0: [8086:2b10] type 00 class 0x060000
[    6.293067] pci 0000:fd:05.0: [8086:2b14] type 00 class 0x060000
[    6.299827] pci 0000:fd:05.2: [8086:2b16] type 00 class 0x060000
[    6.306593] pci 0000:fd:05.4: [8086:2b13] type 00 class 0x060000
[    6.313357] pci 0000:fd:06.0: [8086:2b18] type 00 class 0x060000
[    6.320120] pci 0000:fd:07.0: [8086:2b1c] type 00 class 0x060000
[    6.326873] pci 0000:fd:07.2: [8086:2b1e] type 00 class 0x060000
[    6.333633] pci 0000:fd:07.4: [8086:2b1b] type 00 class 0x060000
[    6.340395] pci 0000:fd:08.0: [8086:2b20] type 00 class 0x060000
[    6.347161] pci 0000:fd:09.0: [8086:2b24] type 00 class 0x060000
[    6.353925] pci 0000:fd:0a.0: [8086:2b28] type 00 class 0x060000
[    6.360688] pci 0000:fd:0b.0: [8086:2b2c] type 00 class 0x060000
[    6.367446] pci 0000:fd:0c.0: [8086:2b30] type 00 class 0x060000
[    6.374209] pci 0000:fd:0d.0: [8086:2b34] type 00 class 0x060000
[    6.380971] pci 0000:fd:0e.0: [8086:2b38] type 00 class 0x060000
[    6.387733] pci 0000:fd:0f.0: [8086:2b3c] type 00 class 0x060000
[    6.394498] pci 0000:fd:10.0: [8086:2b40] type 00 class 0x060000
[    6.401260] pci 0000:fd:10.2: [8086:2b42] type 00 class 0x060000
[    6.408015] pci 0000:fd:10.4: [8086:2b32] type 00 class 0x060000
[    6.414774] pci 0000:fd:10.6: [8086:2b3a] type 00 class 0x060000
[    6.421525] pci 0000:fd:11.0: [8086:2b44] type 00 class 0x060000
[    6.428278] pci 0000:fd:11.2: [8086:2b46] type 00 class 0x060000
[    6.435036] pci 0000:fd:11.4: [8086:2b36] type 00 class 0x060000
[    6.441796] pci 0000:fd:11.6: [8086:2b3e] type 00 class 0x060000
[    6.448561] pci 0000:fd:12.0: [8086:2b48] type 00 class 0x060000
[    6.455328] pci 0000:fd:13.0: [8086:2b4c] type 00 class 0x060000
[    6.462093] pci 0000:fd:14.0: [8086:2b50] type 00 class 0x060000
[    6.468855] pci 0000:fd:14.2: [8086:2b52] type 00 class 0x060000
[    6.475619] pci 0000:fd:15.0: [8086:2b54] type 00 class 0x060000
[    6.482380] pci 0000:fd:15.2: [8086:2b56] type 00 class 0x060000
[    6.489139] pci 0000:fd:16.0: [8086:2b58] type 00 class 0x060000
[    6.495899] pci 0000:fd:16.2: [8086:2b5a] type 00 class 0x060000
[    6.502663] pci 0000:fd:17.0: [8086:2b5c] type 00 class 0x060000
[    6.509428] pci 0000:fd:17.2: [8086:2b5e] type 00 class 0x060000
[    6.516190] pci 0000:fd:18.0: [8086:2b60] type 00 class 0x060000
[    6.522952] pci 0000:fd:18.2: [8086:2b62] type 00 class 0x060000
[    6.529713] pci 0000:fd:19.0: [8086:2b64] type 00 class 0x060000
[    6.536474] pci 0000:fd:19.2: [8086:2b66] type 00 class 0x060000
[    6.543293] ACPI: PCI Root Bridge [PRB1] (domain 0000 [bus fe])
[    6.549907] acpi PNP0A03:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.559041] acpi PNP0A03:02: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    6.566464] PCI host bridge to bus 0000:fe
[    6.571036] pci_bus 0000:fe: root bus resource [bus fe]
[    6.576873] pci 0000:fe:00.0: [8086:2b00] type 00 class 0x060000
[    6.583635] pci 0000:fe:00.2: [8086:2b02] type 00 class 0x060000
[    6.590390] pci 0000:fe:00.4: [8086:2b22] type 00 class 0x060000
[    6.597149] pci 0000:fe:00.6: [8086:2b2a] type 00 class 0x060000
[    6.603898] pci 0000:fe:01.0: [8086:2b04] type 00 class 0x060000
[    6.610660] pci 0000:fe:02.0: [8086:2b08] type 00 class 0x060000
[    6.617425] pci 0000:fe:03.0: [8086:2b0c] type 00 class 0x060000
[    6.624191] pci 0000:fe:04.0: [8086:2b10] type 00 class 0x060000
[    6.630947] pci 0000:fe:05.0: [8086:2b14] type 00 class 0x060000
[    6.637705] pci 0000:fe:05.2: [8086:2b16] type 00 class 0x060000
[    6.644464] pci 0000:fe:05.4: [8086:2b13] type 00 class 0x060000
[    6.651225] pci 0000:fe:06.0: [8086:2b18] type 00 class 0x060000
[    6.657989] pci 0000:fe:07.0: [8086:2b1c] type 00 class 0x060000
[    6.664748] pci 0000:fe:07.2: [8086:2b1e] type 00 class 0x060000
[    6.671502] pci 0000:fe:07.4: [8086:2b1b] type 00 class 0x060000
[    6.678262] pci 0000:fe:08.0: [8086:2b20] type 00 class 0x060000
[    6.685027] pci 0000:fe:09.0: [8086:2b24] type 00 class 0x060000
[    6.691789] pci 0000:fe:0a.0: [8086:2b28] type 00 class 0x060000
[    6.698552] pci 0000:fe:0b.0: [8086:2b2c] type 00 class 0x060000
[    6.705315] pci 0000:fe:0c.0: [8086:2b30] type 00 class 0x060000
[    6.712073] pci 0000:fe:0d.0: [8086:2b34] type 00 class 0x060000
[    6.718836] pci 0000:fe:0e.0: [8086:2b38] type 00 class 0x060000
[    6.725602] pci 0000:fe:0f.0: [8086:2b3c] type 00 class 0x060000
[    6.732362] pci 0000:fe:10.0: [8086:2b40] type 00 class 0x060000
[    6.739123] pci 0000:fe:10.2: [8086:2b42] type 00 class 0x060000
[    6.745880] pci 0000:fe:10.4: [8086:2b32] type 00 class 0x060000
[    6.752647] pci 0000:fe:10.6: [8086:2b3a] type 00 class 0x060000
[    6.759409] pci 0000:fe:11.0: [8086:2b44] type 00 class 0x060000
[    6.766175] pci 0000:fe:11.2: [8086:2b46] type 00 class 0x060000
[    6.772933] pci 0000:fe:11.4: [8086:2b36] type 00 class 0x060000
[    6.779696] pci 0000:fe:11.6: [8086:2b3e] type 00 class 0x060000
[    6.786456] pci 0000:fe:12.0: [8086:2b48] type 00 class 0x060000
[    6.793215] pci 0000:fe:13.0: [8086:2b4c] type 00 class 0x060000
[    6.799978] pci 0000:fe:14.0: [8086:2b50] type 00 class 0x060000
[    6.806736] pci 0000:fe:14.2: [8086:2b52] type 00 class 0x060000
[    6.813502] pci 0000:fe:15.0: [8086:2b54] type 00 class 0x060000
[    6.820264] pci 0000:fe:15.2: [8086:2b56] type 00 class 0x060000
[    6.827024] pci 0000:fe:16.0: [8086:2b58] type 00 class 0x060000
[    6.833779] pci 0000:fe:16.2: [8086:2b5a] type 00 class 0x060000
[    6.840541] pci 0000:fe:17.0: [8086:2b5c] type 00 class 0x060000
[    6.847300] pci 0000:fe:17.2: [8086:2b5e] type 00 class 0x060000
[    6.854061] pci 0000:fe:18.0: [8086:2b60] type 00 class 0x060000
[    6.860822] pci 0000:fe:18.2: [8086:2b62] type 00 class 0x060000
[    6.867586] pci 0000:fe:19.0: [8086:2b64] type 00 class 0x060000
[    6.874341] pci 0000:fe:19.2: [8086:2b66] type 00 class 0x060000
[    6.881158] ACPI: PCI Root Bridge [PRB0] (domain 0000 [bus ff])
[    6.887770] acpi PNP0A03:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    6.896905] acpi PNP0A03:03: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    6.904332] PCI host bridge to bus 0000:ff
[    6.908905] pci_bus 0000:ff: root bus resource [bus ff]
[    6.914744] pci 0000:ff:00.0: [8086:2b00] type 00 class 0x060000
[    6.921502] pci 0000:ff:00.2: [8086:2b02] type 00 class 0x060000
[    6.928258] pci 0000:ff:00.4: [8086:2b22] type 00 class 0x060000
[    6.935009] pci 0000:ff:00.6: [8086:2b2a] type 00 class 0x060000
[    6.941764] pci 0000:ff:01.0: [8086:2b04] type 00 class 0x060000
[    6.948524] pci 0000:ff:02.0: [8086:2b08] type 00 class 0x060000
[    6.955285] pci 0000:ff:03.0: [8086:2b0c] type 00 class 0x060000
[    6.962043] pci 0000:ff:04.0: [8086:2b10] type 00 class 0x060000
[    6.968802] pci 0000:ff:05.0: [8086:2b14] type 00 class 0x060000
[    6.975554] pci 0000:ff:05.2: [8086:2b16] type 00 class 0x060000
[    6.982310] pci 0000:ff:05.4: [8086:2b13] type 00 class 0x060000
[    6.989070] pci 0000:ff:06.0: [8086:2b18] type 00 class 0x060000
[    6.995828] pci 0000:ff:07.0: [8086:2b1c] type 00 class 0x060000
[    7.002586] pci 0000:ff:07.2: [8086:2b1e] type 00 class 0x060000
[    7.009345] pci 0000:ff:07.4: [8086:2b1b] type 00 class 0x060000
[    7.016098] pci 0000:ff:08.0: [8086:2b20] type 00 class 0x060000
[    7.022855] pci 0000:ff:09.0: [8086:2b24] type 00 class 0x060000
[    7.029616] pci 0000:ff:0a.0: [8086:2b28] type 00 class 0x060000
[    7.036374] pci 0000:ff:0b.0: [8086:2b2c] type 00 class 0x060000
[    7.043135] pci 0000:ff:0c.0: [8086:2b30] type 00 class 0x060000
[    7.049893] pci 0000:ff:0d.0: [8086:2b34] type 00 class 0x060000
[    7.056662] pci 0000:ff:0e.0: [8086:2b38] type 00 class 0x060000
[    7.063427] pci 0000:ff:0f.0: [8086:2b3c] type 00 class 0x060000
[    7.070186] pci 0000:ff:10.0: [8086:2b40] type 00 class 0x060000
[    7.076934] pci 0000:ff:10.2: [8086:2b42] type 00 class 0x060000
[    7.083693] pci 0000:ff:10.4: [8086:2b32] type 00 class 0x060000
[    7.090442] pci 0000:ff:10.6: [8086:2b3a] type 00 class 0x060000
[    7.097193] pci 0000:ff:11.0: [8086:2b44] type 00 class 0x060000
[    7.103950] pci 0000:ff:11.2: [8086:2b46] type 00 class 0x060000
[    7.110709] pci 0000:ff:11.4: [8086:2b36] type 00 class 0x060000
[    7.117468] pci 0000:ff:11.6: [8086:2b3e] type 00 class 0x060000
[    7.124215] pci 0000:ff:12.0: [8086:2b48] type 00 class 0x060000
[    7.130975] pci 0000:ff:13.0: [8086:2b4c] type 00 class 0x060000
[    7.137731] pci 0000:ff:14.0: [8086:2b50] type 00 class 0x060000
[    7.144488] pci 0000:ff:14.2: [8086:2b52] type 00 class 0x060000
[    7.151246] pci 0000:ff:15.0: [8086:2b54] type 00 class 0x060000
[    7.158002] pci 0000:ff:15.2: [8086:2b56] type 00 class 0x060000
[    7.164762] pci 0000:ff:16.0: [8086:2b58] type 00 class 0x060000
[    7.171524] pci 0000:ff:16.2: [8086:2b5a] type 00 class 0x060000
[    7.178278] pci 0000:ff:17.0: [8086:2b5c] type 00 class 0x060000
[    7.185035] pci 0000:ff:17.2: [8086:2b5e] type 00 class 0x060000
[    7.191796] pci 0000:ff:18.0: [8086:2b60] type 00 class 0x060000
[    7.198553] pci 0000:ff:18.2: [8086:2b62] type 00 class 0x060000
[    7.205316] pci 0000:ff:19.0: [8086:2b64] type 00 class 0x060000
[    7.212073] pci 0000:ff:19.2: [8086:2b66] type 00 class 0x060000
[    7.231629] Section-unaligned hotplug range: start 0x1000000, size 0x7b000000
[    7.288240] ACPI: Enabled 34 GPEs in block 00 to 3F
[    7.293930] vgaarb: device added: PCI:0000:11:00.0,decodes=io+mem,owns=io+mem,locks=none
[    7.303063] vgaarb: loaded
[    7.306085] vgaarb: bridge control possible 0000:11:00.0
[    7.312235] SCSI subsystem initialized
[    7.316467] ACPI: bus type USB registered
[    7.320981] usbcore: registered new interface driver usbfs
[    7.327119] usbcore: registered new interface driver hub
[    7.333102] usbcore: registered new device driver usb
[    7.338779] pps_core: LinuxPPS API ver. 1 registered
[    7.344321] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    7.354528] PTP clock support registered
[    7.359364] PCI: Using ACPI for IRQ routing
[    7.369199] PCI: pci_cache_line_size set to 64 bytes
[    7.375152] e820: reserve RAM buffer [mem 0x0009b400-0x0009ffff]
[    7.381861] e820: reserve RAM buffer [mem 0x78c76000-0x7bffffff]
[    7.388778] NetLabel: Initializing
[    7.392578] NetLabel:  domain hash size = 128
[    7.397439] NetLabel:  protocols = UNLABELED CIPSOv4
[    7.403005] NetLabel:  unlabeled traffic allowed by default
[    7.409418] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    7.417283] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    7.423076] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    7.437449] Switched to clocksource hpet
[    7.468659] pnp: PnP ACPI init
[    7.472105] ACPI: bus type PNP registered
[    7.477183] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    7.486048] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:38 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    7.501185] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    7.508958] system 00:01: [io  0x0500-0x057f] could not be reserved
[    7.515966] system 00:01: [io  0x0400-0x047f] could not be reserved
[    7.522975] system 00:01: [io  0x0540-0x057f] has been reserved
[    7.529593] system 00:01: [io  0x0ca2-0x0ca3] has been reserved
[    7.536211] system 00:01: [io  0x0600-0x061f] has been reserved
[    7.542831] system 00:01: [io  0x0ca0-0x0ca5] could not be reserved
[    7.549838] system 00:01: [io  0x0880-0x0883] has been reserved
[    7.556453] system 00:01: [io  0x0ca4-0x0ca5] has been reserved
[    7.563075] system 00:01: [io  0x0800-0x081f] has been reserved
[    7.569694] system 00:01: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[    7.577477] system 00:01: [mem 0xfed45000-0xfed8bfff] has been reserved
[    7.584863] system 00:01: [mem 0xff000000-0xffffffff] has been reserved
[    7.592257] system 00:01: [mem 0xfee00000-0xfeefffff] has been reserved
[    7.599654] system 00:01: [mem 0xfed12000-0xfed1200f] has been reserved
[    7.607048] system 00:01: [mem 0xfed12010-0xfed1201f] has been reserved
[    7.614443] system 00:01: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    7.621841] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    7.629681] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    7.638542] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:34 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    7.653729] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    7.661243] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    7.670096] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:33 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    7.685283] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    7.692695] pnp 00:04: Plug and Play ACPI device, IDs PNP0c31 (active)
[    7.700116] pnp 00:05: Plug and Play ACPI device, IDs IPI0001 (active)
[    7.709111] pnp: PnP ACPI: found 6 devices
[    7.713701] ACPI: bus type PNP unregistered
[    7.725745] pci 0000:0b:00.0: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window
[    7.736827] pci 0000:11:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[    7.747995] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    7.753836] pci 0000:00:01.0:   bridge window [io  0x4000-0x4fff]
[    7.760646] pci 0000:00:01.0:   bridge window [mem 0x9ba00000-0x9bafffff]
[    7.768235] pci 0000:00:02.0: PCI bridge to [bus 04-06]
[    7.774074] pci 0000:00:02.0:   bridge window [io  0x3000-0x3fff]
[    7.780884] pci 0000:00:02.0:   bridge window [mem 0x9b900000-0x9b9fffff]
[    7.788472] pci 0000:00:03.0: PCI bridge to [bus 07]
[    7.794026] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
[    7.799865] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    7.806675] pci 0000:00:05.0:   bridge window [mem 0x9a900000-0x9b8fffff]
[    7.814260] pci 0000:00:05.0:   bridge window [mem 0x95900000-0x998fffff 64bit pref]
[    7.822918] pci 0000:0b:00.0: BAR 6: assigned [mem 0x99980000-0x9999ffff pref]
[    7.830987] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
[    7.836830] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
[    7.843631] pci 0000:00:07.0:   bridge window [mem 0x99900000-0x9a8fffff]
[    7.851216] pci 0000:00:07.0:   bridge window [mem 0x91900000-0x958fffff 64bit pref]
[    7.859870] pci 0000:00:09.0: PCI bridge to [bus 0e]
[    7.865424] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    7.870978] pci 0000:00:1c.0: PCI bridge to [bus 10]
[    7.876527] pci 0000:00:1c.0:   bridge window [io  0x6000-0x6fff]
[    7.883337] pci 0000:00:1c.0:   bridge window [mem 0x9bc00000-0x9bdfffff]
[    7.890923] pci 0000:00:1c.0:   bridge window [mem 0xfc000000000-0xfc0001fffff 64bit pref]
[    7.900162] pci 0000:11:00.0: BAR 6: assigned [mem 0x91810000-0x9181ffff pref]
[    7.908230] pci 0000:00:1c.4: PCI bridge to [bus 11]
[    7.913780] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x918fffff]
[    7.921364] pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x90ffffff 64bit pref]
[    7.930017] pci 0000:00:1e.0: PCI bridge to [bus 12]
[    7.935574] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    7.941799] pci_bus 0000:00: resource 5 [io  0x1000-0x9fff]
[    7.948022] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    7.955024] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
[    7.962025] pci_bus 0000:00: resource 8 [mem 0x90000000-0xcfffffff]
[    7.969028] pci_bus 0000:00: resource 9 [mem 0xfc000000000-0xfc07fffffff]
[    7.976611] pci_bus 0000:01: resource 0 [io  0x4000-0x4fff]
[    7.982836] pci_bus 0000:01: resource 1 [mem 0x9ba00000-0x9bafffff]
[    7.989838] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    7.996064] pci_bus 0000:04: resource 1 [mem 0x9b900000-0x9b9fffff]
[    8.003066] pci_bus 0000:08: resource 0 [io  0x2000-0x2fff]
[    8.009291] pci_bus 0000:08: resource 1 [mem 0x9a900000-0x9b8fffff]
[    8.016292] pci_bus 0000:08: resource 2 [mem 0x95900000-0x998fffff 64bit pref]
[    8.024361] pci_bus 0000:0b: resource 0 [io  0x1000-0x1fff]
[    8.030585] pci_bus 0000:0b: resource 1 [mem 0x99900000-0x9a8fffff]
[    8.037586] pci_bus 0000:0b: resource 2 [mem 0x91900000-0x958fffff 64bit pref]
[    8.045655] pci_bus 0000:10: resource 0 [io  0x6000-0x6fff]
[    8.051879] pci_bus 0000:10: resource 1 [mem 0x9bc00000-0x9bdfffff]
[    8.058879] pci_bus 0000:10: resource 2 [mem 0xfc000000000-0xfc0001fffff 64bit pref]
[    8.067529] pci_bus 0000:11: resource 1 [mem 0x91000000-0x918fffff]
[    8.074528] pci_bus 0000:11: resource 2 [mem 0x90000000-0x90ffffff 64bit pref]
[    8.082599] pci_bus 0000:12: resource 4 [io  0x0000-0x0cf7]
[    8.088822] pci_bus 0000:12: resource 5 [io  0x1000-0x9fff]
[    8.095046] pci_bus 0000:12: resource 6 [mem 0x000a0000-0x000bffff]
[    8.102049] pci_bus 0000:12: resource 7 [mem 0xfed40000-0xfedfffff]
[    8.109051] pci_bus 0000:12: resource 8 [mem 0x90000000-0xcfffffff]
[    8.116053] pci_bus 0000:12: resource 9 [mem 0xfc000000000-0xfc07fffffff]
[    8.123682] pci 0000:80:00.0: PCI bridge to [bus 81]
[    8.129238] pci 0000:80:01.0: PCI bridge to [bus 82]
[    8.134792] pci 0000:80:03.0: PCI bridge to [bus 83]
[    8.140344] pci 0000:80:07.0: PCI bridge to [bus 84-86]
[    8.146174] pci 0000:80:07.0:   bridge window [io  0xb000-0xbfff]
[    8.152984] pci 0000:80:07.0:   bridge window [mem 0xd1000000-0xd1ffffff]
[    8.160569] pci 0000:80:07.0:   bridge window [mem 0xf3f00000-0xf7efffff 64bit pref]
[    8.169223] pci 0000:80:09.0: PCI bridge to [bus 87-89]
[    8.175060] pci 0000:80:09.0:   bridge window [io  0xa000-0xafff]
[    8.181870] pci 0000:80:09.0:   bridge window [mem 0xd0000000-0xd0ffffff]
[    8.189455] pci 0000:80:09.0:   bridge window [mem 0xf7f00000-0xfbefffff 64bit pref]
[    8.198108] pci_bus 0000:80: resource 4 [io  0xa000-0xffff]
[    8.204334] pci_bus 0000:80: resource 5 [mem 0xd0000000-0xfbffffff]
[    8.211334] pci_bus 0000:80: resource 6 [mem 0xfc080000000-0xfc0ffffffff]
[    8.218917] pci_bus 0000:84: resource 0 [io  0xb000-0xbfff]
[    8.225143] pci_bus 0000:84: resource 1 [mem 0xd1000000-0xd1ffffff]
[    8.232146] pci_bus 0000:84: resource 2 [mem 0xf3f00000-0xf7efffff 64bit pref]
[    8.240216] pci_bus 0000:87: resource 0 [io  0xa000-0xafff]
[    8.246440] pci_bus 0000:87: resource 1 [mem 0xd0000000-0xd0ffffff]
[    8.253440] pci_bus 0000:87: resource 2 [mem 0xf7f00000-0xfbefffff 64bit pref]
[    8.261644] NET: Registered protocol family 2
[    8.267340] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    8.276352] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    8.284109] TCP: Hash tables configured (established 262144 bind 65536)
[    8.291562] TCP: reno registered
[    8.295253] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    8.302361] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
[    8.310200] NET: Registered protocol family 1
[    8.315378] RPC: Registered named UNIX socket transport module.
[    8.321999] RPC: Registered udp transport module.
[    8.327254] RPC: Registered tcp transport module.
[    8.332510] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    8.340015] IOAPIC[0]: Set routing entry (8-16 -> 0x81 -> IRQ 16 Mode:1 Active:1 Dest:1)
[    8.349069] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:81 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.364469] IOAPIC[0]: Set routing entry (8-21 -> 0x91 -> IRQ 21 Mode:1 Active:1 Dest:1)
[    8.373516] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:91 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.388914] IOAPIC[0]: Set routing entry (8-19 -> 0xa1 -> IRQ 19 Mode:1 Active:1 Dest:1)
[    8.397961] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:A1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.413352] IOAPIC[0]: Set routing entry (8-18 -> 0xb1 -> IRQ 18 Mode:1 Active:1 Dest:1)
[    8.422400] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.437829] IOAPIC[0]: Set routing entry (8-23 -> 0xc1 -> IRQ 23 Mode:1 Active:1 Dest:1)
[    8.446876] IOAPIC[0]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:C1 Dest:00000001 SID:F0FF SQ:0 SVT:1)
[    8.463112] pci 0000:11:00.0: Boot video device
[    8.468525] PCI: CLS 64 bytes, default 64
[    8.473086] Unpacking initramfs...
[   12.143805] Freeing initrd memory: 122864K (ffff88007146e000 - ffff880078c6a000)
[   12.152433] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   12.159667] software IO TLB [mem 0x6d46e000-0x7146e000] (64MB) mapped at [ffff88006d46e000-ffff88007146dfff]
[   12.182041] futex hash table entries: 16384 (order: 8, 1048576 bytes)
[   12.189568] Initialise system trusted keyring
[   12.194503] audit: initializing netlink subsys (disabled)
[   12.200605] audit: type=2000 audit(1412299582.367:1): initialized
[   12.208783] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   12.218333] zbud: loaded
[   12.221541] VFS: Disk quotas dquot_6.5.2
[   12.226039] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   12.234604] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[   12.245612] 9p: Installing v9fs 9p2000 file system support
[   12.251808] msgmni has been set to 32768
[   12.256325] Key type big_key registered
[   12.260615] SELinux:  Registering netfilter hooks
[   12.269389] NET: Registered protocol family 38
[   12.274387] Key type asymmetric registered
[   12.278966] Asymmetric key parser 'x509' registered
[   12.284524] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   12.293036] io scheduler noop registered
[   12.297427] io scheduler deadline registered (default)
[   12.303208] io scheduler cfq registered
[   12.308289] IOAPIC[1]: Set routing entry (9-4 -> 0xd1 -> IRQ 28 Mode:1 Active:1 Dest:1)
[   12.317246] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:D1 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.332350] pcieport 0000:00:01.0: irq 90 for MSI/MSI-X
[   12.338444] IOAPIC[1]: Set routing entry (9-5 -> 0x22 -> IRQ 29 Mode:1 Active:1 Dest:1)
[   12.347397] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:22 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.362485] pcieport 0000:00:02.0: irq 91 for MSI/MSI-X
[   12.368573] IOAPIC[1]: Set routing entry (9-0 -> 0x52 -> IRQ 24 Mode:1 Active:1 Dest:1)
[   12.377522] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:52 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.392612] pcieport 0000:00:03.0: irq 92 for MSI/MSI-X
[   12.398699] IOAPIC[1]: Set routing entry (9-2 -> 0x72 -> IRQ 26 Mode:1 Active:1 Dest:1)
[   12.407654] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:72 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.422746] pcieport 0000:00:05.0: irq 93 for MSI/MSI-X
[   12.428842] IOAPIC[1]: Set routing entry (9-6 -> 0x92 -> IRQ 30 Mode:1 Active:1 Dest:1)
[   12.437794] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:92 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.452885] pcieport 0000:00:07.0: irq 94 for MSI/MSI-X
[   12.458976] IOAPIC[1]: Set routing entry (9-8 -> 0xb2 -> IRQ 32 Mode:1 Active:1 Dest:1)
[   12.467929] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B2 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.483019] pcieport 0000:00:09.0: irq 95 for MSI/MSI-X
[   12.489099] IOAPIC[1]: Set routing entry (9-9 -> 0xd2 -> IRQ 33 Mode:1 Active:1 Dest:1)
[   12.498050] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:D2 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   12.513157] pcieport 0000:00:0a.0: irq 96 for MSI/MSI-X
[   12.519272] pcieport 0000:00:1c.0: irq 97 for MSI/MSI-X
[   12.525420] pcieport 0000:00:1c.4: irq 98 for MSI/MSI-X
[   12.531504] IOAPIC[2]: Set routing entry (10-23 -> 0x53 -> IRQ 71 Mode:1 Active:1 Dest:1)
[   12.540652] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:53 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.555743] pcieport 0000:80:00.0: irq 99 for MSI/MSI-X
[   12.561786] IOAPIC[2]: Set routing entry (10-4 -> 0x73 -> IRQ 52 Mode:1 Active:1 Dest:1)
[   12.570833] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:73 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.585931] pcieport 0000:80:01.0: irq 100 for MSI/MSI-X
[   12.592070] IOAPIC[2]: Set routing entry (10-0 -> 0x93 -> IRQ 48 Mode:1 Active:1 Dest:1)
[   12.601116] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:93 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.616206] pcieport 0000:80:03.0: irq 101 for MSI/MSI-X
[   12.622349] IOAPIC[2]: Set routing entry (10-6 -> 0xb3 -> IRQ 54 Mode:1 Active:1 Dest:1)
[   12.631398] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B3 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.646491] pcieport 0000:80:07.0: irq 102 for MSI/MSI-X
[   12.652649] IOAPIC[2]: Set routing entry (10-8 -> 0xd3 -> IRQ 56 Mode:1 Active:1 Dest:1)
[   12.661695] IOAPIC[2]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:D3 Dest:00000001 SID:8098 SQ:0 SVT:1)
[   12.676788] pcieport 0000:80:09.0: irq 103 for MSI/MSI-X
[   12.682885] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[   12.690669] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[   12.697961] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[   12.705256] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[   12.712777] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[   12.720558] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[   12.727848] pci 0000:04:00.1: Signaling PME through PCIe PME interrupt
[   12.735143] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[   12.742648] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   12.750431] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   12.757939] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[   12.765721] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[   12.773233] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[   12.781013] pci 0000:0b:00.0: Signaling PME through PCIe PME interrupt
[   12.788307] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[   12.795815] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[   12.803601] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[   12.811109] pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
[   12.818891] pcie_pme 0000:00:0a.0:pcie01: service driver pcie_pme loaded
[   12.826397] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[   12.834181] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[   12.841679] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[   12.849457] pci 0000:11:00.0: Signaling PME through PCIe PME interrupt
[   12.856753] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[   12.864270] pcieport 0000:80:00.0: Signaling PME through PCIe PME interrupt
[   12.872052] pcie_pme 0000:80:00.0:pcie01: service driver pcie_pme loaded
[   12.879558] pcieport 0000:80:01.0: Signaling PME through PCIe PME interrupt
[   12.887341] pcie_pme 0000:80:01.0:pcie01: service driver pcie_pme loaded
[   12.894849] pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
[   12.902629] pcie_pme 0000:80:03.0:pcie01: service driver pcie_pme loaded
[   12.910134] pcieport 0000:80:07.0: Signaling PME through PCIe PME interrupt
[   12.917915] pcie_pme 0000:80:07.0:pcie01: service driver pcie_pme loaded
[   12.925421] pcieport 0000:80:09.0: Signaling PME through PCIe PME interrupt
[   12.933204] pcie_pme 0000:80:09.0:pcie01: service driver pcie_pme loaded
[   12.940712] ioapic: probe of 0000:00:13.0 failed with error -22
[   12.947331] ioapic: probe of 0000:00:15.0 failed with error -22
[   12.953952] ioapic: probe of 0000:80:13.0 failed with error -22
[   12.960570] ioapic: probe of 0000:80:15.0 failed with error -22
[   12.967210] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   13.171690] tsc: Refined TSC clocksource calibration: 2260.999 MHz
[   14.072900] pciehp 0000:00:05.0:pcie04: Slot #1 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   14.178237] Switched to clocksource tsc
[   15.085137] pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
[   16.192375] pciehp 0000:00:07.0:pcie04: Slot #2 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   17.204618] pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
[   17.211781] pciehp 0000:00:1c.0:pcie04: Slot #10 AttnBtn- AttnInd- PwrInd- PwrCtrl- MRL- Interlock- NoCompl- LLActRep+
[   17.223930] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[   18.330860] pciehp 0000:80:07.0:pcie04: Slot #6 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   19.343103] pciehp 0000:80:07.0:pcie04: service driver pciehp loaded
[   20.450341] pciehp 0000:80:09.0:pcie04: Slot #7 AttnBtn+ AttnInd+ PwrInd+ PwrCtrl+ MRL- Interlock- NoCompl- LLActRep+
[   21.462578] pciehp 0000:80:09.0:pcie04: service driver pciehp loaded
[   21.469684] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   21.477177] intel_idle: MWAIT substates: 0x120
[   21.482327] intel_idle: v0.4 model 0x2E
[   21.486609] intel_idle: lapic_timer_reliable_states 0x2
[   21.495618] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[   21.504961] ACPI: Sleep Button [SLPB]
[   21.509121] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   21.517384] ACPI: Power Button [PWRF]
[   21.580163] ERST: Error Record Serialization Table (ERST) support is initialized.
[   21.588546] pstore: Registered erst as persistent store backend
[   21.596360] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[   21.603810] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   21.631446] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   21.660418] 00:03: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   21.670424] Non-volatile memory driver v1.3
[   21.675124] Linux agpgart interface v0.103
[   21.680797] tpm_tis 00:04: 1.2 TPM (device-id 0x4A10, rev-id 78)
[   21.722831] tpm_tis 00:04: TPM is disabled/deactivated (0x7)
[   21.729942] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000428-0x000000000000042f (\GPE0) (20140424/utaddress-258)
[   21.747265] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.758623] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x000000000000052c-0x000000000000052c (\GPIV) (20140424/utaddress-258)
[   21.775930] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x000000000000052f (\_SI_.SIOR) (20140424/utaddress-258)
[   21.793723] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.805116] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   21.812215] rdac: device handler registered
[   21.817279] hp_sw: device handler registered
[   21.822059] emc: device handler registered
[   21.826635] alua: device handler registered
[   21.831361] libphy: Fixed MDIO Bus: probed
[   21.836102] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   21.843975] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   21.850455] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   21.856971] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   21.863676] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[   21.871442] igb: Copyright (c) 2007-2014 Intel Corporation.
[   21.878016] igb 0000:01:00.0: irq 104 for MSI/MSI-X
[   21.883491] igb 0000:01:00.0: irq 105 for MSI/MSI-X
[   21.888955] igb 0000:01:00.0: irq 106 for MSI/MSI-X
[   21.894419] igb 0000:01:00.0: irq 107 for MSI/MSI-X
[   21.899885] igb 0000:01:00.0: irq 108 for MSI/MSI-X
[   21.905348] igb 0000:01:00.0: irq 109 for MSI/MSI-X
[   21.910813] igb 0000:01:00.0: irq 110 for MSI/MSI-X
[   21.916268] igb 0000:01:00.0: irq 111 for MSI/MSI-X
[   21.921724] igb 0000:01:00.0: irq 112 for MSI/MSI-X
[   21.927278] igb 0000:01:00.0: irq 113 for MSI/MSI-X
[   21.932824] igb 0000:01:00.0: irq 114 for MSI/MSI-X
[   21.938307] igb 0000:01:00.0: irq 115 for MSI/MSI-X
[   21.943773] igb 0000:01:00.0: irq 116 for MSI/MSI-X
[   21.949235] igb 0000:01:00.0: irq 117 for MSI/MSI-X
[   21.954697] igb 0000:01:00.0: irq 118 for MSI/MSI-X
[   21.960157] igb 0000:01:00.0: irq 119 for MSI/MSI-X
[   21.965631] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[   21.971101] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[   22.168028] igb 0000:01:00.0: added PHC on eth0
[   22.173096] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   22.180777] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:05:ea
[   22.188749] igb 0000:01:00.0: eth0: PBA No: Unknown
[   22.194195] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   22.202720] IOAPIC[1]: Set routing entry (9-16 -> 0xb6 -> IRQ 40 Mode:1 Active:1 Dest:1)
[   22.211767] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B6 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   22.227111] igb 0000:01:00.1: irq 122 for MSI/MSI-X
[   22.232577] igb 0000:01:00.1: irq 123 for MSI/MSI-X
[   22.238041] igb 0000:01:00.1: irq 124 for MSI/MSI-X
[   22.243495] igb 0000:01:00.1: irq 125 for MSI/MSI-X
[   22.248965] igb 0000:01:00.1: irq 126 for MSI/MSI-X
[   22.254429] igb 0000:01:00.1: irq 127 for MSI/MSI-X
[   22.259885] igb 0000:01:00.1: irq 128 for MSI/MSI-X
[   22.265348] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[   22.270886] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[   22.276432] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[   22.281977] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[   22.287456] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[   22.292926] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[   22.298397] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[   22.303859] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[   22.309321] igb 0000:01:00.1: irq 137 for MSI/MSI-X
[   22.314792] igb 0000:01:00.1: irq 138 for MSI/MSI-X
[   22.320256] igb 0000:01:00.1: irq 139 for MSI/MSI-X
[   22.508384] igb 0000:01:00.1: added PHC on eth1
[   22.513457] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   22.521210] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:05:eb
[   22.529250] igb 0000:01:00.1: eth1: PBA No: Unknown
[   22.534767] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   22.543709] igb 0000:04:00.0: irq 140 for MSI/MSI-X
[   22.549224] igb 0000:04:00.0: irq 141 for MSI/MSI-X
[   22.554705] igb 0000:04:00.0: irq 142 for MSI/MSI-X
[   22.560188] igb 0000:04:00.0: irq 143 for MSI/MSI-X
[   22.565663] igb 0000:04:00.0: irq 144 for MSI/MSI-X
[   22.571136] igb 0000:04:00.0: irq 145 for MSI/MSI-X
[   22.576602] igb 0000:04:00.0: irq 146 for MSI/MSI-X
[   22.582088] igb 0000:04:00.0: irq 147 for MSI/MSI-X
[   22.587564] igb 0000:04:00.0: irq 148 for MSI/MSI-X
[   22.593144] igb 0000:04:00.0: irq 149 for MSI/MSI-X
[   22.598714] igb 0000:04:00.0: irq 150 for MSI/MSI-X
[   22.604213] igb 0000:04:00.0: irq 151 for MSI/MSI-X
[   22.609682] igb 0000:04:00.0: irq 152 for MSI/MSI-X
[   22.615157] igb 0000:04:00.0: irq 153 for MSI/MSI-X
[   22.620631] igb 0000:04:00.0: irq 154 for MSI/MSI-X
[   22.626106] igb 0000:04:00.0: irq 155 for MSI/MSI-X
[   22.631579] igb 0000:04:00.0: irq 156 for MSI/MSI-X
[   22.637052] igb 0000:04:00.0: irq 157 for MSI/MSI-X
[   22.822524] igb 0000:04:00.0: added PHC on eth2
[   22.827599] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
[   22.835283] igb 0000:04:00.0: eth2: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:05:ec
[   22.843257] igb 0000:04:00.0: eth2: PBA No: Unknown
[   22.848710] igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   22.857273] IOAPIC[1]: Set routing entry (9-17 -> 0xb9 -> IRQ 41 Mode:1 Active:1 Dest:1)
[   22.866325] IOAPIC[1]: Set IRTE entry (P:1 FPD:0 Dst_Mode:1 Redir_hint:1 Trig_Mode:0 Dlvry_Mode:1 Avail:0 Vector:B9 Dest:00000001 SID:0098 SQ:0 SVT:1)
[   22.881724] igb 0000:04:00.1: irq 158 for MSI/MSI-X
[   22.887203] igb 0000:04:00.1: irq 159 for MSI/MSI-X
[   22.892678] igb 0000:04:00.1: irq 160 for MSI/MSI-X
[   22.898153] igb 0000:04:00.1: irq 161 for MSI/MSI-X
[   22.903627] igb 0000:04:00.1: irq 162 for MSI/MSI-X
[   22.909101] igb 0000:04:00.1: irq 163 for MSI/MSI-X
[   22.914583] igb 0000:04:00.1: irq 164 for MSI/MSI-X
[   22.920066] igb 0000:04:00.1: irq 165 for MSI/MSI-X
[   22.925542] igb 0000:04:00.1: irq 166 for MSI/MSI-X
[   22.931139] igb 0000:04:00.1: irq 167 for MSI/MSI-X
[   22.936700] igb 0000:04:00.1: irq 168 for MSI/MSI-X
[   22.942198] igb 0000:04:00.1: irq 169 for MSI/MSI-X
[   22.947679] igb 0000:04:00.1: irq 170 for MSI/MSI-X
[   22.953156] igb 0000:04:00.1: irq 171 for MSI/MSI-X
[   22.958629] igb 0000:04:00.1: irq 172 for MSI/MSI-X
[   22.964103] igb 0000:04:00.1: irq 173 for MSI/MSI-X
[   22.969576] igb 0000:04:00.1: irq 174 for MSI/MSI-X
[   22.975047] igb 0000:04:00.1: irq 175 for MSI/MSI-X
[   23.162646] igb 0000:04:00.1: added PHC on eth3
[   23.167721] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
[   23.175409] igb 0000:04:00.1: eth3: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:05:ed
[   23.183389] igb 0000:04:00.1: eth3: PBA No: Unknown
[   23.188840] igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[   23.197399] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   23.206127] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   23.212945] usbcore: registered new interface driver catc
[   23.219000] usbcore: registered new interface driver kaweth
[   23.225222] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   23.233491] usbcore: registered new interface driver pegasus
[   23.239832] usbcore: registered new interface driver rtl8150
[   23.246185] usbcore: registered new interface driver asix
[   23.252237] usbcore: registered new interface driver cdc_ether
[   23.258772] usbcore: registered new interface driver cdc_eem
[   23.265113] usbcore: registered new interface driver dm9601
[   23.271365] usbcore: registered new interface driver smsc75xx
[   23.277813] usbcore: registered new interface driver smsc95xx
[   23.284251] usbcore: registered new interface driver gl620a
[   23.290499] usbcore: registered new interface driver net1080
[   23.296840] usbcore: registered new interface driver plusb
[   23.302990] usbcore: registered new interface driver rndis_host
[   23.309623] usbcore: registered new interface driver cdc_subset
[   23.316260] usbcore: registered new interface driver zaurus
[   23.322508] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   23.330788] usbcore: registered new interface driver int51x1
[   23.337130] usbcore: registered new interface driver ipheth
[   23.343378] usbcore: registered new interface driver sierra_net
[   23.350168] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   23.357481] ehci-pci: EHCI PCI platform driver
[   23.362880] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   23.368887] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   23.377170] ehci-pci 0000:00:1a.7: debug port 1
[   23.386166] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   23.393780] ehci-pci 0000:00:1a.7: irq 18, io mem 0x9bb01000
[   23.406198] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   23.412722] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   23.420315] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.428485] usb usb1: Product: EHCI Host Controller
[   23.434019] usb usb1: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 ehci_hcd
[   23.441969] usb usb1: SerialNumber: 0000:00:1a.7
[   23.447516] hub 1-0:1.0: USB hub found
[   23.451721] hub 1-0:1.0: 6 ports detected
[   23.456669] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   23.462748] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   23.471033] ehci-pci 0000:00:1d.7: debug port 1
[   23.480019] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   23.487613] ehci-pci 0000:00:1d.7: irq 23, io mem 0x9bb00000
[   23.499217] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   23.505704] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   23.513288] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.521423] usb usb2: Product: EHCI Host Controller
[   23.526941] usb usb2: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 ehci_hcd
[   23.534887] usb usb2: SerialNumber: 0000:00:1d.7
[   23.540450] hub 2-0:1.0: USB hub found
[   23.544677] hub 2-0:1.0: 6 ports detected
[   23.549527] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   23.556448] ohci-pci: OHCI PCI platform driver
[   23.561478] uhci_hcd: USB Universal Host Controller Interface driver
[   23.568895] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   23.574904] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   23.583185] uhci_hcd 0000:00:1a.0: detected 2 ports
[   23.588680] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000050c0
[   23.595199] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   23.602789] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.610863] usb usb3: Product: UHCI Host Controller
[   23.616314] usb usb3: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 uhci_hcd
[   23.624191] usb usb3: SerialNumber: 0000:00:1a.0
[   23.629615] hub 3-0:1.0: USB hub found
[   23.633842] hub 3-0:1.0: 2 ports detected
[   23.638833] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   23.644809] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   23.653152] uhci_hcd 0000:00:1a.1: detected 2 ports
[   23.658651] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000050a0
[   23.665165] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   23.672753] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.680826] usb usb4: Product: UHCI Host Controller
[   23.686280] usb usb4: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 uhci_hcd
[   23.694157] usb usb4: SerialNumber: 0000:00:1a.1
[   23.699657] hub 4-0:1.0: USB hub found
[   23.703880] hub 4-0:1.0: 2 ports detected
[   23.708874] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   23.714861] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   23.723142] uhci_hcd 0000:00:1a.2: detected 2 ports
[   23.728651] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00005080
[   23.735163] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   23.742756] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.750894] usb usb5: Product: UHCI Host Controller
[   23.756414] usb usb5: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 uhci_hcd
[   23.764361] usb usb5: SerialNumber: 0000:00:1a.2
[   23.769873] hub 5-0:1.0: USB hub found
[   23.774073] hub 5-0:1.0: 2 ports detected
[   23.778902] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   23.784884] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   23.793167] uhci_hcd 0000:00:1d.0: detected 2 ports
[   23.798635] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00005060
[   23.805117] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   23.812701] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.820769] usb usb6: Product: UHCI Host Controller
[   23.826216] usb usb6: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 uhci_hcd
[   23.834078] usb usb6: SerialNumber: 0000:00:1d.0
[   23.839555] hub 6-0:1.0: USB hub found
[   23.843754] hub 6-0:1.0: 2 ports detected
[   23.848585] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   23.854572] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   23.862847] uhci_hcd 0000:00:1d.1: detected 2 ports
[   23.868313] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00005040
[   23.874799] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   23.882374] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.890516] usb usb7: Product: UHCI Host Controller
[   23.896041] usb usb7: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 uhci_hcd
[   23.903989] usb usb7: SerialNumber: 0000:00:1d.1
[   23.909667] hub 7-0:1.0: USB hub found
[   23.913998] hub 7-0:1.0: 2 ports detected
[   23.919087] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   23.925195] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   23.933478] uhci_hcd 0000:00:1d.2: detected 2 ports
[   23.938956] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005020
[   23.945474] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   23.953065] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.961137] usb usb8: Product: UHCI Host Controller
[   23.966589] usb usb8: Manufacturer: Linux 3.16.0-rc2-00011-g4485154 uhci_hcd
[   23.974466] usb usb8: SerialNumber: 0000:00:1d.2
[   23.980017] hub 8-0:1.0: USB hub found
[   23.984216] hub 8-0:1.0: 2 ports detected
[   23.989010] usbcore: registered new interface driver usbserial
[   23.995540] usbcore: registered new interface driver usbserial_generic
[   24.002840] usbserial: USB Serial support registered for generic
[   24.009584] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   24.114418] usb 4-1: new full-speed USB device number 2 using uhci_hcd
[   24.266365] usb 4-1: New USB device found, idVendor=046b, idProduct=ff10
[   24.273901] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   24.281924] usb 4-1: Product: Virtual Keyboard and Mouse
[   24.287860] usb 4-1: Manufacturer: American Megatrends Inc.
[   24.294131] usb 4-1: SerialNumber: serial
[   25.056310] i8042: No controller found
[   25.060809] mousedev: PS/2 mouse device common for all mice
[   25.067759] rtc_cmos 00:00: RTC can wake from S4
[   25.073193] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   25.080056] rtc_cmos 00:00: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   25.088784] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   25.095041] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   25.103910] iTCO_vendor_support: vendor-support=0
[   25.112218] hidraw: raw HID events driver (C) Jiri Kosina
[   25.124013] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/0003:046B:FF10.0001/input/input2
[   25.140177] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.1-1/input0
[   25.162009] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/0003:046B:FF10.0002/input/input3
[   25.178143] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1a.1-1/input1
[   25.194397] usbcore: registered new interface driver usbhid
[   25.200619] usbhid: USB HID core driver
[   25.204966] drop_monitor: Initializing network drop monitor service
[   25.212199] TCP: cubic registered
[   25.215909] Initializing XFRM netlink socket
[   25.220988] NET: Registered protocol family 10
[   25.227153] NET: Registered protocol family 17
[   25.232144] 9pnet: Installing 9P2000 support
[   25.239810] 
[   25.239810] printing PIC contents
[   25.245168] ... PIC  IMR: ffff
[   25.248578] ... PIC  IRR: 0c21
[   25.251993] ... PIC  ISR: 0000
[   25.255404] ... PIC ELCR: 0e20
[   25.258893] printing local APIC contents on CPU#0/0:
[   25.264442] ... APIC ID:      00000000 (0)
[   25.269014] ... APIC VERSION: 00060015
[   25.273199] ... APIC TASKPRI: 00000000 (00)
[   25.277867] ... APIC PROCPRI: 00000000
[   25.282051] ... APIC LDR: 00000001
[   25.285848] ... APIC SPIV: 000001ff
[   25.289739] ... APIC ISR field:
[   25.293245] 0000000000000000000000000000000000000000000000000000000000000000
[   25.301205] ... APIC TMR field:
[   25.304710] 0000000000000000000200000002000000020000000200020000000200000000
[   25.312669] ... APIC IRR field:
[   25.316174] 0000000000000000000000000000000000000000000000000000000000000000
[   25.324134] ... APIC ESR: 00000000
[   25.327929] ... APIC ICR: 000008ef
[   25.331725] ... APIC ICR2: 00020020
[   25.335619] ... APIC LVTT: 000000ef
[   25.339513] ... APIC LVTPC: 00000400
[   25.343502] ... APIC LVT0: 00010700
[   25.347396] ... APIC LVT1: 00000400
[   25.351288] ... APIC LVTERR: 000000fe
[   25.355374] ... APIC TMICT: 005bc575
[   25.359363] ... APIC TMCCT: 004f07af
[   25.363352] ... APIC TDCR: 00000003
[   25.367245] 
[   25.368908] number of MP IRQ sources: 15.
[   25.373387] number of IO-APIC #8 registers: 24.
[   25.378445] number of IO-APIC #9 registers: 24.
[   25.383503] number of IO-APIC #10 registers: 24.
[   25.388657] testing the IO APIC.......................
[   25.394398] IO APIC #8......
[   25.397612] .... register #00: 08000000
[   25.401892] .......    : physical APIC id: 08
[   25.406756] .......    : Delivery Type: 0
[   25.411231] .......    : LTS          : 0
[   25.415705] .... register #01: 00170020
[   25.419986] .......     : max redirection entries: 17
[   25.425625] .......     : PRQ implemented: 0
[   25.430392] .......     : IO APIC version: 20
[   25.435256] .... IRQ redirection table:
[   25.439543] 0   1    0    0   0   0    0     0    00
[   25.445089] 1   0    0    0   0   0    0     0    01
[   25.450635] 1   0    0    0   0   0    0     0    02
[   25.456182] 1   0    0    0   0   0    0     0    03
[   25.461728] 1   0    0    0   0   0    0     0    04
[   25.467272] 1   0    0    0   0   0    0     0    05
[   25.472817] 1   0    0    0   0   0    0     0    06
[   25.478364] 1   0    0    0   0   0    0     0    07
[   25.483911] 1   0    0    0   0   0    0     0    08
[   25.489457] 1   0    1    0   0   0    0     0    09
[   25.495002] 1   0    0    0   0   0    0     0    0A
[   25.500548] 1   0    0    0   0   0    0     0    0B
[   25.506093] 1   0    0    0   0   0    0     0    0C
[   25.511639] 1   0    0    0   0   0    0     0    0D
[   25.517184] 1   0    0    0   0   0    0     0    0E
[   25.522731] 1   0    0    0   0   0    0     0    0F
[   25.528277] 1   0    1    0   1   0    0     0    10
[   25.533822] 0   1    0    0   0   0    0     0    00
[   25.539369] 1   0    1    0   1   0    0     0    12
[   25.544915] 1   0    1    0   1   0    0     0    13
[   25.550462] 0   1    0    0   0   0    0     0    00
[   25.556007] 1   0    1    0   1   0    0     0    15
[   25.561554] 0   1    0    0   0   0    0     0    00
[   25.567100] 1   0    1    0   1   0    0     0    17
[   25.572645] IO APIC #9......
[   25.575860] .... register #00: 09000000
[   25.580144] .......    : physical APIC id: 09
[   25.585008] .......    : Delivery Type: 0
[   25.589482] .......    : LTS          : 0
[   25.593957] .... register #01: 00170020
[   25.598237] .......     : max redirection entries: 17
[   25.603876] .......     : PRQ implemented: 0
[   25.608641] .......     : IO APIC version: 20
[   25.613506] .... register #02: 00000000
[   25.617788] .......     : arbitration: 00
[   25.622254] .... register #03: 00000001
[   25.626534] .......     : Boot DT    : 1
[   25.630913] .... IRQ redirection table:
[   25.635198] 1   1    1    0   1   0    0     0    00
[   25.640744] 0   1    0    0   0   0    0     0    00
[   25.646289] 1   1    1    0   1   0    0     0    02
[   25.651835] 0   1    0    0   0   0    0     0    00
[   25.657379] 1   1    1    0   1   0    0     0    04
[   25.662914] 1   1    1    0   1   0    0     0    05
[   25.668458] 1   1    1    0   1   0    0     0    06
[   25.673993] 0   1    0    0   0   0    0     0    00
[   25.679539] 1   1    1    0   1   0    0     0    08
[   25.685085] 1   1    1    0   1   0    0     0    09
[   25.690630] 0   1    0    0   0   0    0     0    00
[   25.696176] 0   1    0    0   0   0    0     0    00
[   25.701722] 0   1    0    0   0   0    0     0    00
[   25.707266] 0   1    0    0   0   0    0     0    00
[   25.712811] 0   1    0    0   0   0    0     0    00
[   25.718355] 0   1    0    0   0   0    0     0    00
[   25.723900] 1   1    1    0   1   0    0     0    10
[   25.729444] 1   1    1    0   1   0    0     0    11
[   25.734980] 0   1    0    0   0   0    0     0    00
[   25.740525] 0   1    0    0   0   0    0     0    00
[   25.746071] 0   1    0    0   0   0    0     0    00
[   25.751616] 0   1    0    0   0   0    0     0    00
[   25.757160] 0   1    0    0   0   0    0     0    00
[   25.762696] 0   1    0    0   0   0    0     0    00
[   25.768241] IO APIC #10......
[   25.771554] .... register #00: 0A000000
[   25.775834] .......    : physical APIC id: 0A
[   25.780697] .......    : Delivery Type: 0
[   25.785172] .......    : LTS          : 0
[   25.789649] .... register #01: 00170020
[   25.793930] .......     : max redirection entries: 17
[   25.799569] .......     : PRQ implemented: 0
[   25.804337] .......     : IO APIC version: 20
[   25.809201] .... register #02: 00000000
[   25.813483] .......     : arbitration: 00
[   25.817959] .... register #03: 00000001
[   25.822239] .......     : Boot DT    : 1
[   25.826617] .... IRQ redirection table:
[   25.830900] 1   1    1    0   1   0    0     0    00
[   25.836445] 0   1    0    0   0   0    0     0    00
[   25.841993] 0   1    0    0   0   0    0     0    00
[   25.847539] 0   1    0    0   0   0    0     0    00
[   25.853085] 1   1    1    0   1   0    0     0    04
[   25.858630] 0   1    0    0   0   0    0     0    00
[   25.864176] 1   1    1    0   1   0    0     0    06
[   25.869721] 0   1    0    0   0   0    0     0    00
[   25.875265] 1   1    1    0   1   0    0     0    08
[   25.880811] 0   1    0    0   0   0    0     0    00
[   25.886357] 0   1    0    0   0   0    0     0    00
[   25.891903] 0   1    0    0   0   0    0     0    00
[   25.897449] 0   1    0    0   0   0    0     0    00
[   25.902994] 0   1    0    0   0   0    0     0    00
[   25.908539] 0   1    0    0   0   0    0     0    00
[   25.914083] 0   1    0    0   0   0    0     0    00
[   25.919629] 0   1    0    0   0   0    0     0    00
[   25.925175] 0   1    0    0   0   0    0     0    00
[   25.930722] 0   1    0    0   0   0    0     0    00
[   25.936268] 0   1    0    0   0   0    0     0    00
[   25.941811] 0   1    0    0   0   0    0     0    00
[   25.947347] 0   1    0    0   0   0    0     0    00
[   25.952892] 0   1    0    0   0   0    0     0    00
[   25.958438] 1   1    1    0   1   0    0     0    17
[   25.963982] IRQ to pin mappings:
[   25.967585] IRQ0 -> 0:2
[   25.970337] IRQ1 -> 0:1
[   25.973091] IRQ3 -> 0:3
[   25.975841] IRQ4 -> 0:4
[   25.978592] IRQ5 -> 0:5
[   25.981344] IRQ6 -> 0:6
[   25.984097] IRQ7 -> 0:7
[   25.986847] IRQ8 -> 0:8
[   25.989598] IRQ9 -> 0:9
[   25.992348] IRQ10 -> 0:10
[   25.995292] IRQ11 -> 0:11
[   25.998237] IRQ12 -> 0:12
[   26.001182] IRQ13 -> 0:13
[   26.004127] IRQ14 -> 0:14
[   26.007072] IRQ15 -> 0:15
[   26.010018] IRQ16 -> 0:16
[   26.012963] IRQ18 -> 0:18
[   26.015910] IRQ19 -> 0:19
[   26.018855] IRQ21 -> 0:21
[   26.021799] IRQ23 -> 0:23
[   26.024746] IRQ24 -> 1:0
[   26.027590] IRQ26 -> 1:2
[   26.030435] IRQ28 -> 1:4
[   26.033283] IRQ29 -> 1:5
[   26.036128] IRQ30 -> 1:6
[   26.038976] IRQ32 -> 1:8
[   26.041826] IRQ33 -> 1:9
[   26.044677] IRQ40 -> 1:16
[   26.047622] IRQ41 -> 1:17
[   26.050565] IRQ48 -> 2:0
[   26.053413] IRQ52 -> 2:4
[   26.056264] IRQ54 -> 2:6
[   26.059113] IRQ56 -> 2:8
[   26.061965] IRQ71 -> 2:23
[   26.064916] .................................... done.
[   26.071027] Loading compiled-in X.509 certificates
[   26.077902] Loaded X.509 cert 'Magrathea: Glacier signing key: d9c98d250c40719ec6cbc12e0c181e80314a3c88'
[   26.088593] registered taskstats version 1
[   26.098933] Key type trusted registered
[   26.107752] Key type encrypted registered
[   26.122835] tpm_tis 00:04: A TPM error (7) occurred attempting to read a pcr value
[   26.131299] ima: No TPM chip found, activating TPM-bypass!
[   26.137532] evm: HMAC attrs: 0x1
[   26.143720] rtc_cmos 00:00: setting system clock to 2014-10-03 01:26:42 UTC (1412299602)
[   26.261633] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   26.378550] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   26.493218] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
[   26.608117] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
[   34.978494] igb 0000:01:00.0 eth0: igb: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   34.988631] igb 0000:01:00.0 eth0: Link Speed was downgraded by SmartSpeed
[   34.996585] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   35.006697] Sending DHCP requests .
[   35.407431] DHCP/BOOTP: Reply not for us, op[2] xid[2617cf49]
[   35.782172] random: nonblocking pool is initialized
[   37.630426] DHCP/BOOTP: Reply not for us, op[2] xid[2617cf49]
[   39.094740] ., OK
[   39.142899] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.132
[   39.659997] IP-Config: Complete:
[   39.663620]      device=eth0, hwaddr=00:23:8b:e0:05:ea, ipaddr=192.168.1.132, mask=255.255.255.0, gw=192.168.1.1
[   39.675063]      host=lkp-nex06, domain=lkp.intel.com, nis-domain=(none)
[   39.682624]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   39.690180]      nameserver0=192.168.1.1
[   39.694889] PM: Hibernation image not present or could not be loaded.
[   39.707186] Freeing unused kernel memory: 1796K (ffffffff81daf000 - ffffffff81f70000)
[   40.170513] ipmi message handler version 39.2
[   40.181454] IPMI System Interface driver.
[   40.186088] ipmi_si: probing via ACPI
[   40.190254] ipmi_si 00:05: [io  0x0ca2] regsize 1 spacing 1 irq 0
[   40.197056] ipmi_si: Adding ACPI-specified kcs state machine
[   40.203449] ipmi_si: probing via SMBIOS
[   40.207739] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   40.214355] ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
[   40.223347] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[   40.234681] EDAC MC: Ver: 3.0.0
[   40.241578] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   40.251746] megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
[   40.259387] megasas: 0x1000:0x0060:0x8086:0x1013: bus 11:slot 0:func 0
[   40.268330] megasas: Waiting for FW to come to ready state
[   40.277904] megasas: FW now in Ready state
[   40.288994] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   40.289456] libata version 3.00 loaded.
[   40.302860] [drm] Initialized drm 1.1.0 20060810
[   40.305344] ipmi_si 00:05: Found new BMC (man_id: 0x000157, prod_id: 0x0040, dev_id: 0x21)
[   40.305359] ipmi_si 00:05: IPMI kcs interface initialized
[   40.325974] megasas_init_mfi: fw_support_ieee=0
[   40.330843] megasas: INIT adapter done
[   40.337307] ata_piix 0000:00:1f.2: version 2.13
[   40.342739] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   40.350440] scsi1 : ata_piix
[   40.354314] scsi2 : ata_piix
[   40.357595] ata1: SATA max UDMA/133 cmd 0x5138 ctl 0x514c bmdma 0x5110 irq 19
[   40.365565] ata2: SATA max UDMA/133 cmd 0x5130 ctl 0x5148 bmdma 0x5118 irq 19
[   40.373845] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[   40.419137] megaraid_sas 0000:0b:00.0: Controller type: MR,Memory size is: 256MB
[   40.427522] scsi0 : LSI SAS based MegaRAID driver
[   40.434078] Error: Driver 'pcspkr' is already registered, aborting...
[   40.435912] scsi 0:0:8:0: Direct-Access     SEAGATE  ST9146802SS      0003 PQ: 0 ANSI: 5
[   40.436921] scsi 0:0:9:0: Direct-Access     SEAGATE  ST9146802SS      0003 PQ: 0 ANSI: 5
[   40.466161] [TTM] Zone  kernel: Available graphics memory: 16410316 kiB
[   40.473565] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   40.480911] [TTM] Initializing pool allocator
[   40.485851] [TTM] Initializing DMA pool allocator
[   40.515230] scsi 0:2:0:0: Direct-Access     INTEL    SRCSASBB8I       1.12 PQ: 0 ANSI: 5
[   40.527855] fbcon: mgadrmfb (fb0) is primary device
[   40.531568] scsi3 : ata_piix
[   40.532243] scsi4 : ata_piix
[   40.532348] ata3: SATA max UDMA/133 cmd 0x5128 ctl 0x5144 bmdma 0x50f0 irq 21
[   40.532351] ata4: SATA max UDMA/133 cmd 0x5120 ctl 0x5140 bmdma 0x50f8 irq 21
[   40.742101] Console: switching to colour frame buffer device 128x48
[   40.819123] mgag200 0000:11:00.0: fb0: mgadrmfb frame buffer device
[   40.826222] mgag200 0000:11:00.0: registered panic notifier
[   40.835242] [drm] Initialized mgag200 1.0.0 20110418 for 0000:11:00.0 on minor 0
[   40.849265] ata4: SATA link down (SStatus 0 SControl 300)
[   40.866414] ata3: SATA link down (SStatus 4 SControl 300)
[   40.995259] ata2.00: SATA link down (SStatus 0 SControl 300)
[   41.001720] ata2.01: SATA link down (SStatus 0 SControl 300)
[   41.134350] ata1.00: SATA link down (SStatus 0 SControl 300)
[   41.140751] ata1.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   41.178430] ata1.01: ATAPI: Optiarc DVD RW AD-7580S, FX04, max UDMA/100
[   41.207422] ata1.01: configured for UDMA/100
[   41.218693] scsi 1:0:1:0: CD-ROM            Optiarc  DVD RW AD-7580S  FX04 PQ: 0 ANSI: 5
[   41.290257] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   41.298698] cdrom: Uniform CD-ROM driver Revision: 3.20
[   41.304914] sr 1:0:1:0: Attached scsi CD-ROM sr0
[   41.314179] sd 0:2:0:0: [sda] 570310656 512-byte logical blocks: (291 GB/271 GiB)
[   41.323298] sd 0:2:0:0: [sda] Write Protect is off
[   41.328705] sd 0:2:0:0: [sda] Mode Sense: 1f 00 10 08
[   41.336613] sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   41.348985]  sda: sda1 sda2 < sda5 >
[   41.354538] sd 0:2:0:0: Attached scsi generic sg0 type 0
[   41.354949] sd 0:2:0:0: [sda] Attached SCSI disk
[   41.368672] sr 1:0:1:0: Attached scsi generic sg1 type 5
[   43.316202] fuse init (API version 7.23)
[   43.574181] device-mapper: uevent: version 1.0.3
[   43.580744] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   45.295822] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).

==> /lkp/lkp/src/tmp/run_log <==

==> /lkp/lkp/src/tmp/err_log <==

==> /lkp/lkp/src/tmp/run_log <==
 3 Oct 01:27:08 ntpdate[2697]: step time server 192.168.1.1 offset -0.383263 sec
Kernel tests: Boot OK!
LKP: HOSTNAME lkp-nex06, MAC 00:23:8b:e0:05:ea, kernel 3.16.0-rc2-00011-g4485154 1, serial console /dev/ttyS0
/lkp/lkp/src/bin/run-lkp
[   52.931658] IPMI Watchdog: driver initialized
Stopping watchdog keepalive daemon....
RESULT_ROOT=/result/lkp-nex06/vm-scalability/300s-mremap-xread-rand-mt/debian-x86_64.cgz/x86_64-rhel/4485154138f6ffa5b252cb490aba3e8eb30124e4/0
job=/lkp/scheduled/lkp-nex06/bisect_vm-scalability-300s-mremap-xread-rand-mt-x86_64-rhel-4485154138f6ffa5b252cb490aba3e8eb30124e4-0.yaml
Starting watchdog daemon....
run-job /lkp/scheduled/lkp-nex06/bisect_vm-scalability-300s-mremap-xread-rand-mt-x86_64-rhel-4485154138f6ffa5b252cb490aba3e8eb30124e4-0.yaml
run: /lkp/lkp/src/monitors/no-stdout/wrapper perf-profile	{}
run: /lkp/lkp/src/setup/runtime 300s	{}
run: /lkp/lkp/src/setup/size	{}
run: /lkp/lkp/src/monitors/wrapper watch-oom	{}
run: pre-test
run: /lkp/lkp/src/monitors/event/wait pre-test	{}
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
run: /lkp/lkp/src/monitors/wrapper energy	{}
run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/wrapper vm-scalability	{"test"=>"mremap-xread-rand-mt"}
run: /lkp/lkp/src/monitors/wrapper cpuidle	{}
run: /lkp/lkp/src/monitors/wrapper cpufreq	{}
2014-10-03 01:27:10 mount -t tmpfs -o size=100% vm-scalability-tmp /tmp/vm-scalability-tmp
2014-10-03 01:27:10 truncate -s 33608327168 /tmp/vm-scalability.img
run: /lkp/lkp/src/monitors/wrapper turbostat	{}
2014-10-03 01:27:10 mkfs.xfs -q /tmp/vm-scalability.img
2014-10-03 01:27:10 mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
[   54.593677] loop: module loaded
run: /lkp/lkp/sr
[   54.602565] XFS (loop0): Mounting V4 Filesystem
c/monitors/wrapp
[   54.606718] XFS (loop0): Ending clean mount
er sched_debug	{"interval"=>"10"}
run: /lkp/lkp/src/monitors/wrapper pmeter	{}
2014-10-03 01:27:10 ./case-mremap-xread-rand-mt
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-1 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-1 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-2 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-2 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-3 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-3 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-4 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-4 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-5 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-5 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-6 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-6 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-7 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-7 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-8 -s 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-9 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-8 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-9 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-10 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-10 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-11 -s 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-12 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-11 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-13 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-12 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-13 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-14 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-14 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-15 -s 17179869184
2014-10-03 01:27:10 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-15 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:10 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-16 -s 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-17 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-16 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-17 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-18 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-18 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-19 -s 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-20 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-19 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-20 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-21 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-21 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-22 -s 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-23 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-22 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-23 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-24 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-24 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-25 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-25 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-26 -s 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-27 -s 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-27 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-26 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:11 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-28 -s 17179869184
2014-10-03 01:27:12 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-29 -s 17179869184
2014-10-03 01:27:12 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-28 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:12 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-29 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:12 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-30 -s 17179869184
2014-10-03 01:27:12 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-31 -s 17179869184
2014-10-03 01:27:12 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-31 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:12 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-32 -s 17179869184
2014-10-03 01:27:12 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-30 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:12 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-32 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:13 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-33 -s 17179869184
2014-10-03 01:27:13 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-33 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:13 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-34 -s 17179869184
2014-10-03 01:27:13 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-34 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:13 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-35 -s 17179869184
2014-10-03 01:27:13 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-35 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:13 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-36 -s 17179869184
2014-10-03 01:27:14 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-36 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:14 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-37 -s 17179869184
2014-10-03 01:27:14 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-37 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:16 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-38 -s 17179869184
2014-10-03 01:27:16 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-38 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:16 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-39 -s 17179869184
2014-10-03 01:27:16 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-40 -s 17179869184
2014-10-03 01:27:16 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-39 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:16 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-40 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:17 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-41 -s 17179869184
2014-10-03 01:27:17 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-41 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:17 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-42 -s 17179869184
2014-10-03 01:27:17 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-42 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:20 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-43 -s 17179869184
2014-10-03 01:27:20 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-44 -s 17179869184
2014-10-03 01:27:21 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-44 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:22 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-43 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:24 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-45 -s 17179869184
2014-10-03 01:27:25 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-45 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:26 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-46 -s 17179869184
2014-10-03 01:27:26 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-46 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:26 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-47 -s 17179869184
2014-10-03 01:27:26 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-48 -s 17179869184
2014-10-03 01:27:26 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-48 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:26 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-49 -s 17179869184
2014-10-03 01:27:26 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-50 -s 17179869184
2014-10-03 01:27:26 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-50 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:26 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-51 -s 17179869184
2014-10-03 01:27:26 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-51 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:26 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-52 -s 17179869184
2014-10-03 01:27:27 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-53 -s 17179869184
2014-10-03 01:27:27 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-52 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:27 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-54 -s 17179869184
2014-10-03 01:27:27 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-53 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:27 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-55 -s 17179869184
2014-10-03 01:27:27 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-54 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:27 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-56 -s 17179869184
2014-10-03 01:27:27 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-56 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:27 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-57 -s 17179869184
2014-10-03 01:27:27 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-57 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:27 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-58 -s 17179869184
2014-10-03 01:27:27 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-58 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:27 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-49 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:28 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-47 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:29 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-55 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:31 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-59 -s 17179869184
2014-10-03 01:27:31 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-60 -s 17179869184
2014-10-03 01:27:32 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-59 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:32 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-61 -s 17179869184
2014-10-03 01:27:32 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-61 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:32 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-62 -s 17179869184
2014-10-03 01:27:34 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-63 -s 17179869184
2014-10-03 01:27:34 truncate /tmp/vm-scalability/sparse-mremap-xread-rand-mt-64 -s 17179869184
2014-10-03 01:27:34 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-64 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:35 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-63 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:35 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-60 -E --prealloc --readonly --random 17179869184
2014-10-03 01:27:36 ./usemem --runtime 300 -t 64 -f /tmp/vm-scalability/sparse-mremap-xread-rand-mt-62 -E --prealloc --readonly --random 17179869184
[  192.496567] ------------[ cut here ]------------
[  192.505045] WARNING: CPU: 48 PID: 7540 at arch/x86/kernel/cpu/perf_event_intel_ds.c:316 reserve_ds_buffers+0x208/0x430()
[  192.524168] alloc_bts_buffer: BTS buffer allocation failure
[  192.533339] Modules linked in: loop ipmi_watchdog nfsd auth_rpcgss dm_mod fuse sg sd_mod crct10dif_generic sr_mod crc_t10dif cdrom crct10dif_common ata_generic pata_acpi mgag200 syscopyarea snd_pcm sysfillrect sysimgblt snd_timer ttm snd drm_kms_helper soundcore ata_piix pcspkr i7core_edac drm libata megaraid_sas i2c_i801 edac_core ipmi_si ipmi_msghandler acpi_cpufreq
[  192.581450] CPU: 48 PID: 7540 Comm: perf Not tainted 3.16.0-rc2-00011-g4485154 #1
[  192.592393] Hardware name: Quanta MP Server/QSSC-S4R, BIOS QSSC-S4R.QCI.01.00.0028.090220101116 09/02/2010
[  192.606455]  0000000000000009 ffff88005de53ce8 ffffffff81844e55 ffff88005de53d30
[  192.618370]  ffff88005de53d20 ffffffff8106de6d 0000000000000000 0000000000010528
[  192.630786]  0000000000000000 0000000000000000 0000000000000000 ffff88005de53d80
[  192.642465] Call Trace:
[  192.647913]  [<ffffffff81844e55>] dump_stack+0x4d/0x66
[  192.656643]  [<ffffffff8106de6d>] warn_slowpath_common+0x7d/0xa0
[  192.666961]  [<ffffffff8106dedc>] warn_slowpath_fmt+0x4c/0x50
[  192.677047]  [<ffffffff81030863>] ? reserve_ds_buffers+0x2b3/0x430
[  192.687420]  [<ffffffff810307b8>] reserve_ds_buffers+0x208/0x430
[  192.697838]  [<ffffffff8118abec>] ? handle_mm_fault+0x8ac/0xf70
[  192.707522]  [<ffffffff8102a354>] x86_pmu_event_init+0x434/0x450
[  192.717351]  [<ffffffff8115241b>] perf_init_event+0xdb/0x140
[  192.727292]  [<ffffffff81152808>] perf_event_alloc+0x388/0x440
[  192.738117]  [<ffffffff81152c60>] SYSC_perf_event_open+0x3a0/0xd20
[  192.750511]  [<ffffffff81153979>] SyS_perf_event_open+0x9/0x10
[  192.761657]  [<ffffffff8184da29>] system_call_fastpath+0x16/0x1b
[  192.771904] ---[ end trace 6d601571820ebee0 ]---
4331667464 bytes / 300293184 usecs = 14086 KB/s
4311744520 bytes / 300271782 usecs = 14022 KB/s
4319608840 bytes / 300310142 usecs = 14046 KB/s
4331667464 bytes / 300324655 usecs = 14085 KB/s
4310171656 bytes / 300182795 usecs = 14021 KB/s
4331667464 bytes / 300324630 usecs = 14085 KB/s
4318035976 bytes / 300234337 usecs = 14045 KB/s
4330618888 bytes / 300169667 usecs = 14089 KB/s
4319608840 bytes / 300307900 usecs = 14046 KB/s
4311744520 bytes / 300308560 usecs = 14021 KB/s
4318035976 bytes / 300255807 usecs = 14044 KB/s
4330618888 bytes / 300171949 usecs = 14088 KB/s
4330618888 bytes / 300200542 usecs = 14087 KB/s
4330618888 bytes / 300201473 usecs = 14087 KB/s
4326424584 bytes / 300317052 usecs = 14068 KB/s
4318035976 bytes / 300327947 usecs = 14040 KB/s
4319608840 bytes / 300434967 usecs = 14040 KB/s
4313317384 bytes / 300460317 usecs = 14019 KB/s
4319608840 bytes / 300468463 usecs = 14039 KB/s
4319608840 bytes / 300479189 usecs = 14038 KB/s
4331667464 bytes / 300483704 usecs = 14077 KB/s
4330618888 bytes / 300359171 usecs = 14080 KB/s
4318035976 bytes / 300449612 usecs = 14035 KB/s
4330618888 bytes / 300370236 usecs = 14079 KB/s
4319608840 bytes / 300536462 usecs = 14036 KB/s
4313317384 bytes / 300549104 usecs = 14015 KB/s
4318035976 bytes / 300483332 usecs = 14033 KB/s
4318035976 bytes / 300484917 usecs = 14033 KB/s
4322754568 bytes / 300576177 usecs = 14044 KB/s
4318035976 bytes / 300512947 usecs = 14032 KB/s
4326424584 bytes / 300518386 usecs = 14059 KB/s
4330618888 bytes / 300454449 usecs = 14075 KB/s
4326424584 bytes / 300535922 usecs = 14058 KB/s
4330618888 bytes / 300470340 usecs = 14074 KB/s
4330618888 bytes / 300491017 usecs = 14074 KB/s
4300210184 bytes / 300476622 usecs = 13975 KB/s
4313317384 bytes / 300674373 usecs = 14009 KB/s
4300210184 bytes / 300500160 usecs = 13974 KB/s
4310171656 bytes / 300557328 usecs = 14004 KB/s
4318035976 bytes / 300628531 usecs = 14026 KB/s
4330618888 bytes / 300569805 usecs = 14070 KB/s
4304928776 bytes / 300771294 usecs = 13977 KB/s
4318035976 bytes / 300644655 usecs = 14025 KB/s
4311744520 bytes / 300714867 usecs = 14002 KB/s
4330618888 bytes / 300587885 usecs = 14069 KB/s
4311744520 bytes / 300740277 usecs = 14001 KB/s
4311744520 bytes / 300745695 usecs = 14000 KB/s
4313317384 bytes / 300825959 usecs = 14002 KB/s
4330618888 bytes / 300669307 usecs = 14065 KB/s
4330618888 bytes / 300623735 usecs = 14067 KB/s
4330618888 bytes / 300687162 usecs = 14064 KB/s
4330618888 bytes / 300695401 usecs = 14064 KB/s
4330618888 bytes / 300701285 usecs = 14064 KB/s
4330618888 bytes / 300661789 usecs = 14066 KB/s
4330618888 bytes / 300718735 usecs = 14063 KB/s
4330618888 bytes / 300720840 usecs = 14063 KB/s
4318035976 bytes / 300796108 usecs = 14018 KB/s
4330618888 bytes / 300744704 usecs = 14062 KB/s
4330618888 bytes / 300749869 usecs = 14061 KB/s
4319608840 bytes / 301004660 usecs = 14014 KB/s
4330618888 bytes / 300872784 usecs = 14056 KB/s
4330618888 bytes / 300874914 usecs = 14056 KB/s
4313317384 bytes / 301032050 usecs = 13992 KB/s
4330618888 bytes / 300909201 usecs = 14054 KB/s
4330618888 bytes / 300899468 usecs = 14054 KB/s
4318035976 bytes / 301003996 usecs = 14009 KB/s
4330618888 bytes / 300970868 usecs = 14051 KB/s
4318035976 bytes / 301044871 usecs = 14007 KB/s
4336386056 bytes / 301029392 usecs = 14067 KB/s
4330618888 bytes / 300961960 usecs = 14052 KB/s
4330618888 bytes / 300948557 usecs = 14052 KB/s
4318035976 bytes / 301157137 usecs = 14002 KB/s
4348444680 bytes / 300972999 usecs = 14109 KB/s
4348968968 bytes / 300918651 usecs = 14113 KB/s
4306501640 bytes / 300358538 usecs = 14001 KB/s
4306501640 bytes / 300359189 usecs = 14001 KB/s
4306501640 bytes / 300366351 usecs = 14001 KB/s
4334288904 bytes / 300327838 usecs = 14093 KB/s
4348444680 bytes / 301007831 usecs = 14107 KB/s
4337958920 bytes / 300849386 usecs = 14081 KB/s
4330618888 bytes / 301196247 usecs = 14041 KB/s
4348968968 bytes / 301049970 usecs = 14107 KB/s
4348968968 bytes / 301060601 usecs = 14106 KB/s
4306501640 bytes / 300436536 usecs = 13998 KB/s
4348444680 bytes / 301077436 usecs = 14104 KB/s
4348968968 bytes / 301059753 usecs = 14106 KB/s
4348444680 bytes / 301086298 usecs = 14104 KB/s
4348968968 bytes / 301090027 usecs = 14105 KB/s
4319608840 bytes / 301409536 usecs = 13995 KB/s
4330618888 bytes / 301209029 usecs = 14040 KB/s
4348968968 bytes / 301051900 usecs = 14107 KB/s
4337958920 bytes / 300996869 usecs = 14074 KB/s
4325900296 bytes / 300766383 usecs = 14045 KB/s
4325900296 bytes / 300781602 usecs = 14045 KB/s
4325900296 bytes / 300781602 usecs = 14045 KB/s
4348968968 bytes / 301133347 usecs = 14103 KB/s
4337958920 bytes / 301026847 usecs = 14072 KB/s
4348444680 bytes / 301150608 usecs = 14101 KB/s
4348444680 bytes / 301147562 usecs = 14101 KB/s
4311744520 bytes / 301439638 usecs = 13968 KB/s
4298637320 bytes / 300263160 usecs = 13980 KB/s
4348968968 bytes / 301119729 usecs = 14104 KB/s
4330618888 bytes / 301282542 usecs = 14037 KB/s
4348968968 bytes / 301128557 usecs = 14103 KB/s
4318035976 bytes / 301418304 usecs = 13989 KB/s
4303355912 bytes / 300296053 usecs = 13994 KB/s
4300210184 bytes / 301324968 usecs = 13936 KB/s
4298637320 bytes / 300298384 usecs = 13979 KB/s
4334288904 bytes / 300569562 usecs = 14082 KB/s
4348968968 bytes / 301149415 usecs = 14102 KB/s
4348968968 bytes / 301207685 usecs = 14100 KB/s
4334288904 bytes / 300569562 usecs = 14082 KB/s
4348444680 bytes / 301219189 usecs = 14097 KB/s
4325900296 bytes / 300856187 usecs = 14041 KB/s
4311744520 bytes / 301423842 usecs = 13969 KB/s
4330618888 bytes / 301303540 usecs = 14036 KB/s
4330618888 bytes / 301326360 usecs = 14035 KB/s
4348968968 bytes / 301170059 usecs = 14101 KB/s
4348444680 bytes / 301234372 usecs = 14097 KB/s
4348444680 bytes / 301234372 usecs = 14097 KB/s
4348444680 bytes / 301234372 usecs = 14097 KB/s
4306501640 bytes / 300594469 usecs = 13990 KB/s
4337958920 bytes / 301130673 usecs = 14067 KB/s
4348444680 bytes / 301254010 usecs = 14096 KB/s
4337958920 bytes / 301139404 usecs = 14067 KB/s
4337958920 bytes / 301143899 usecs = 14067 KB/s
4334288904 bytes / 300643026 usecs = 14078 KB/s
4348444680 bytes / 301283288 usecs = 14094 KB/s
4348444680 bytes / 301286451 usecs = 14094 KB/s
4348444680 bytes / 301301634 usecs = 14093 KB/s
4306501640 bytes / 300661610 usecs = 13987 KB/s
4309123080 bytes / 300974283 usecs = 13981 KB/s
4318035976 bytes / 301523211 usecs = 13985 KB/s
4348968968 bytes / 301308648 usecs = 14095 KB/s
4325900296 bytes / 300950394 usecs = 14037 KB/s
4337958920 bytes / 301192544 usecs = 14065 KB/s
4330618888 bytes / 301367654 usecs = 14033 KB/s
4334288904 bytes / 300698597 usecs = 14076 KB/s
4348968968 bytes / 301280387 usecs = 14096 KB/s
4330618888 bytes / 301438069 usecs = 14029 KB/s
4348444680 bytes / 301282314 usecs = 14094 KB/s
4337958920 bytes / 301223798 usecs = 14063 KB/s
4348968968 bytes / 301346889 usecs = 14093 KB/s
4334288904 bytes / 300693050 usecs = 14076 KB/s
4330618888 bytes / 301453103 usecs = 14029 KB/s
4337958920 bytes / 301246306 usecs = 14062 KB/s
4347396104 bytes / 300842678 usecs = 14112 KB/s
4348968968 bytes / 301321189 usecs = 14094 KB/s
4330618888 bytes / 301501975 usecs = 14026 KB/s
4298637320 bytes / 300475130 usecs = 13970 KB/s
4318035976 bytes / 301532224 usecs = 13984 KB/s
4318035976 bytes / 301532391 usecs = 13984 KB/s
4318035976 bytes / 301534201 usecs = 13984 KB/s
4336386056 bytes / 301583864 usecs = 14041 KB/s
4319608840 bytes / 301712119 usecs = 13981 KB/s
4296540168 bytes / 301717131 usecs = 13906 KB/s
4347396104 bytes / 300876421 usecs = 14110 KB/s
4330618888 bytes / 301501138 usecs = 14026 KB/s
4325900296 bytes / 301041237 usecs = 14033 KB/s
4318035976 bytes / 301575617 usecs = 13982 KB/s
4330618888 bytes / 301503958 usecs = 14026 KB/s
4330618888 bytes / 301558164 usecs = 14024 KB/s
4318035976 bytes / 301565287 usecs = 13983 KB/s
4347396104 bytes / 300898437 usecs = 14109 KB/s
4348968968 bytes / 301424154 usecs = 14089 KB/s
4348444680 bytes / 301431248 usecs = 14087 KB/s
4348444680 bytes / 301431248 usecs = 14087 KB/s
4337958920 bytes / 301309781 usecs = 14059 KB/s
4337958920 bytes / 301310569 usecs = 14059 KB/s
4347396104 bytes / 300912565 usecs = 14108 KB/s
4347396104 bytes / 300910003 usecs = 14108 KB/s
4325900296 bytes / 301077328 usecs = 14031 KB/s
4303355912 bytes / 300535544 usecs = 13983 KB/s
4347396104 bytes / 300921907 usecs = 14108 KB/s
4348968968 bytes / 301389027 usecs = 14091 KB/s
4325900296 bytes / 301093499 usecs = 14030 KB/s
4318035976 bytes / 301597110 usecs = 13981 KB/s
4325900296 bytes / 301099353 usecs = 14030 KB/s
4348968968 bytes / 301461361 usecs = 14088 KB/s
4347396104 bytes / 300944411 usecs = 14107 KB/s
4337958920 bytes / 301353067 usecs = 14057 KB/s
4330618888 bytes / 301631814 usecs = 14020 KB/s
4318035976 bytes / 301636873 usecs = 13979 KB/s
4348968968 bytes / 301432898 usecs = 14089 KB/s
4330618888 bytes / 301599159 usecs = 14022 KB/s
4311744520 bytes / 301773825 usecs = 13953 KB/s
4348444680 bytes / 301526602 usecs = 14083 KB/s
4337958920 bytes / 301408041 usecs = 14054 KB/s
4337958920 bytes / 301408040 usecs = 14054 KB/s
4348968968 bytes / 301529105 usecs = 14085 KB/s
4347396104 bytes / 300981885 usecs = 14105 KB/s
4348968968 bytes / 301533693 usecs = 14084 KB/s
4337958920 bytes / 301424732 usecs = 14054 KB/s
4318035976 bytes / 301762752 usecs = 13973 KB/s
4318035976 bytes / 301694261 usecs = 13977 KB/s
4348444680 bytes / 301553626 usecs = 14082 KB/s
4347396104 bytes / 301028392 usecs = 14103 KB/s
4348968968 bytes / 301453807 usecs = 14088 KB/s
4299161608 bytes / 301621460 usecs = 13919 KB/s
4337958920 bytes / 301443931 usecs = 14053 KB/s
4337958920 bytes / 301443931 usecs = 14053 KB/s
4348444680 bytes / 301582893 usecs = 14080 KB/s
4348968968 bytes / 301524605 usecs = 14085 KB/s
4348968968 bytes / 301572009 usecs = 14083 KB/s
4334288904 bytes / 300949504 usecs = 14064 KB/s
4348968968 bytes / 301574050 usecs = 14082 KB/s
4347396104 bytes / 301069155 usecs = 14101 KB/s
4347396104 bytes / 301079887 usecs = 14100 KB/s
4347396104 bytes / 301080270 usecs = 14100 KB/s
4330618888 bytes / 301709488 usecs = 14017 KB/s
4347396104 bytes / 301092326 usecs = 14100 KB/s
4334288904 bytes / 300984864 usecs = 14062 KB/s
4337958920 bytes / 301505112 usecs = 14050 KB/s
4337958920 bytes / 301507055 usecs = 14050 KB/s
4330618888 bytes / 301727481 usecs = 14016 KB/s
4348444680 bytes / 301633505 usecs = 14078 KB/s
4318035976 bytes / 301784427 usecs = 13972 KB/s
4325900296 bytes / 301260007 usecs = 14022 KB/s
4348444680 bytes / 301654641 usecs = 14077 KB/s
4348444680 bytes / 301656906 usecs = 14077 KB/s
4318035976 bytes / 301760153 usecs = 13974 KB/s
4330618888 bytes / 301763143 usecs = 14014 KB/s
4347396104 bytes / 301144465 usecs = 14097 KB/s
4347396104 bytes / 301147174 usecs = 14097 KB/s
4325900296 bytes / 301313460 usecs = 14020 KB/s
4337958920 bytes / 301567534 usecs = 14047 KB/s
4348444680 bytes / 301712569 usecs = 14074 KB/s
4318035976 bytes / 301864229 usecs = 13969 KB/s
4330618888 bytes / 301817942 usecs = 14012 KB/s
4318035976 bytes / 301946448 usecs = 13965 KB/s
4348968968 bytes / 301727150 usecs = 14075 KB/s
4348444680 bytes / 301731303 usecs = 14073 KB/s
4325900296 bytes / 301372970 usecs = 14017 KB/s
4347396104 bytes / 301210718 usecs = 14094 KB/s
4337958920 bytes / 301629311 usecs = 14044 KB/s
4348444680 bytes / 301753460 usecs = 14072 KB/s
4318035976 bytes / 301899856 usecs = 13967 KB/s
4330618888 bytes / 301860678 usecs = 14010 KB/s
4311744520 bytes / 302048716 usecs = 13940 KB/s
4348968968 bytes / 301771691 usecs = 14073 KB/s
4330618888 bytes / 301929770 usecs = 14006 KB/s
4334288904 bytes / 301148831 usecs = 14055 KB/s
4334288904 bytes / 301158588 usecs = 14054 KB/s
4337958920 bytes / 301667567 usecs = 14042 KB/s
4337958920 bytes / 301682130 usecs = 14042 KB/s
4325900296 bytes / 301449395 usecs = 14014 KB/s
4330618888 bytes / 301958113 usecs = 14005 KB/s
4337958920 bytes / 301690486 usecs = 14041 KB/s
4348968968 bytes / 301813389 usecs = 14071 KB/s
4330618888 bytes / 301919880 usecs = 14007 KB/s
4334813192 bytes / 302184480 usecs = 14008 KB/s
4337958920 bytes / 301704173 usecs = 14041 KB/s
4325376008 bytes / 302098990 usecs = 13982 KB/s
4334813192 bytes / 302200817 usecs = 14007 KB/s
4347396104 bytes / 301321211 usecs = 14089 KB/s
4330618888 bytes / 301956553 usecs = 14005 KB/s
4298113032 bytes / 301808538 usecs = 13907 KB/s
4303355912 bytes / 300975600 usecs = 13962 KB/s
4348444680 bytes / 301903328 usecs = 14065 KB/s
4348968968 bytes / 301915038 usecs = 14067 KB/s
4300210184 bytes / 302227797 usecs = 13894 KB/s
4325900296 bytes / 301588427 usecs = 14007 KB/s
4348968968 bytes / 301943104 usecs = 14065 KB/s
4334288904 bytes / 301348031 usecs = 14045 KB/s
4334813192 bytes / 302356553 usecs = 14000 KB/s
4318035976 bytes / 302216187 usecs = 13953 KB/s
4347396104 bytes / 301486848 usecs = 14081 KB/s
4334813192 bytes / 302352070 usecs = 14000 KB/s
4333240328 bytes / 300373767 usecs = 14088 KB/s
4334813192 bytes / 302372101 usecs = 14000 KB/s
4348444680 bytes / 302018595 usecs = 14060 KB/s
4347396104 bytes / 301491414 usecs = 14081 KB/s
4333240328 bytes / 300400461 usecs = 14086 KB/s
4337958920 bytes / 301919397 usecs = 14031 KB/s
4330618888 bytes / 302188352 usecs = 13994 KB/s
4348968968 bytes / 302041134 usecs = 14061 KB/s
4333240328 bytes / 300427873 usecs = 14085 KB/s
4348444680 bytes / 302074758 usecs = 14057 KB/s
4348968968 bytes / 302017723 usecs = 14062 KB/s
4330618888 bytes / 302153196 usecs = 13996 KB/s
4333240328 bytes / 300424081 usecs = 14085 KB/s
4326948872 bytes / 300776878 usecs = 14048 KB/s
4347396104 bytes / 301597504 usecs = 14076 KB/s
4331667464 bytes / 302435869 usecs = 13986 KB/s
4348444680 bytes / 302128562 usecs = 14055 KB/s
4330618888 bytes / 302277130 usecs = 13990 KB/s
4334813192 bytes / 302494558 usecs = 13994 KB/s
4326948872 bytes / 300845068 usecs = 14045 KB/s
4337958920 bytes / 302001168 usecs = 14027 KB/s
4318035976 bytes / 302304356 usecs = 13948 KB/s
4347396104 bytes / 301641732 usecs = 14074 KB/s
4348968968 bytes / 302178228 usecs = 14054 KB/s
4347396104 bytes / 301660509 usecs = 14073 KB/s
4347396104 bytes / 301660752 usecs = 14073 KB/s
4348444680 bytes / 302198980 usecs = 14052 KB/s
4334813192 bytes / 302564325 usecs = 13991 KB/s
4326948872 bytes / 300907079 usecs = 14042 KB/s
4347396104 bytes / 301684919 usecs = 14072 KB/s
4348444680 bytes / 302215105 usecs = 14051 KB/s
4326948872 bytes / 300838983 usecs = 14045 KB/s
4330618888 bytes / 302317652 usecs = 13988 KB/s
4324851720 bytes / 302514589 usecs = 13961 KB/s
4324851720 bytes / 302514699 usecs = 13961 KB/s
4330618888 bytes / 302319928 usecs = 13988 KB/s
4334813192 bytes / 302586136 usecs = 13990 KB/s
4333764616 bytes / 300444467 usecs = 14086 KB/s
4347396104 bytes / 301647112 usecs = 14074 KB/s
4327473160 bytes / 302457061 usecs = 13972 KB/s
4337958920 bytes / 302117495 usecs = 14021 KB/s
4347396104 bytes / 301713853 usecs = 14071 KB/s
4327473160 bytes / 302460153 usecs = 13972 KB/s
4347396104 bytes / 301714155 usecs = 14071 KB/s
4337958920 bytes / 302088133 usecs = 14023 KB/s
4348444680 bytes / 302222288 usecs = 14051 KB/s
4327473160 bytes / 302465438 usecs = 13972 KB/s
4299161608 bytes / 302306383 usecs = 13887 KB/s
4348968968 bytes / 302250947 usecs = 14051 KB/s
4318035976 bytes / 302403004 usecs = 13944 KB/s
4334288904 bytes / 301618934 usecs = 14033 KB/s
4324851720 bytes / 302556211 usecs = 13959 KB/s
4348968968 bytes / 302266989 usecs = 14050 KB/s
4324851720 bytes / 302565474 usecs = 13958 KB/s
4326948872 bytes / 300973066 usecs = 14039 KB/s
4348444680 bytes / 302160924 usecs = 14053 KB/s
4327473160 bytes / 302465593 usecs = 13971 KB/s
4333240328 bytes / 300649995 usecs = 14075 KB/s
4324851720 bytes / 302586736 usecs = 13957 KB/s
4333240328 bytes / 300654144 usecs = 14074 KB/s
4347396104 bytes / 301770503 usecs = 14068 KB/s
4334288904 bytes / 301657332 usecs = 14031 KB/s
4318035976 bytes / 302444231 usecs = 13942 KB/s
4347396104 bytes / 301773197 usecs = 14068 KB/s
4327473160 bytes / 302521260 usecs = 13969 KB/s
4333240328 bytes / 300654374 usecs = 14074 KB/s
4325900296 bytes / 301942263 usecs = 13991 KB/s
4348444680 bytes / 302309763 usecs = 14046 KB/s
4324851720 bytes / 302610854 usecs = 13956 KB/s
4337958920 bytes / 302197760 usecs = 14018 KB/s
4326948872 bytes / 301018838 usecs = 14037 KB/s
4333764616 bytes / 300564172 usecs = 14080 KB/s
4333764616 bytes / 300568318 usecs = 14080 KB/s
4298637320 bytes / 301428980 usecs = 13926 KB/s
4318035976 bytes / 302484270 usecs = 13940 KB/s
4333240328 bytes / 300706523 usecs = 14072 KB/s
4330618888 bytes / 302447067 usecs = 13983 KB/s
4324851720 bytes / 302646744 usecs = 13955 KB/s
4313317384 bytes / 302715286 usecs = 13914 KB/s
4334813192 bytes / 302720897 usecs = 13983 KB/s
4347396104 bytes / 301845204 usecs = 14065 KB/s
4334288904 bytes / 301702850 usecs = 14029 KB/s
4333764616 bytes / 300619843 usecs = 14078 KB/s
4334813192 bytes / 302743829 usecs = 13982 KB/s
4326948872 bytes / 301082642 usecs = 14034 KB/s
4330618888 bytes / 302487292 usecs = 13981 KB/s
4347396104 bytes / 301866508 usecs = 14064 KB/s
4333240328 bytes / 300755006 usecs = 14070 KB/s
4334813192 bytes / 302750533 usecs = 13982 KB/s
4333240328 bytes / 300759260 usecs = 14069 KB/s
4333764616 bytes / 300645424 usecs = 14077 KB/s
4333764616 bytes / 300645425 usecs = 14077 KB/s
4325900296 bytes / 302046234 usecs = 13986 KB/s
4334813192 bytes / 302772777 usecs = 13981 KB/s
4324851720 bytes / 302705925 usecs = 13952 KB/s
4327473160 bytes / 302583211 usecs = 13966 KB/s
4333764616 bytes / 300652128 usecs = 14076 KB/s
4348968968 bytes / 302355362 usecs = 14046 KB/s
4333764616 bytes / 300654778 usecs = 14076 KB/s
4333764616 bytes / 300655279 usecs = 14076 KB/s
4337958920 bytes / 302297765 usecs = 14013 KB/s
4333764616 bytes / 300649885 usecs = 14076 KB/s
4325900296 bytes / 302057953 usecs = 13985 KB/s
4325900296 bytes / 302062462 usecs = 13985 KB/s
4326948872 bytes / 301124433 usecs = 14032 KB/s
4327473160 bytes / 302656577 usecs = 13963 KB/s
4347396104 bytes / 301915127 usecs = 14061 KB/s
4330618888 bytes / 302592538 usecs = 13976 KB/s
4348444680 bytes / 302454288 usecs = 14040 KB/s
4320657416 bytes / 302678786 usecs = 13940 KB/s
4333240328 bytes / 300825814 usecs = 14066 KB/s
4330618888 bytes / 302568068 usecs = 13977 KB/s
4330618888 bytes / 302790183 usecs = 13967 KB/s
4330618888 bytes / 302790390 usecs = 13967 KB/s
4330618888 bytes / 302790278 usecs = 13967 KB/s
4347396104 bytes / 301953125 usecs = 14060 KB/s
4330618888 bytes / 302577680 usecs = 13976 KB/s
4327473160 bytes / 302702659 usecs = 13961 KB/s
4347396104 bytes / 301962687 usecs = 14059 KB/s
4327473160 bytes / 302711925 usecs = 13960 KB/s
4333764616 bytes / 300732421 usecs = 14072 KB/s
4333764616 bytes / 300735184 usecs = 14072 KB/s
4333240328 bytes / 300860003 usecs = 14065 KB/s
4330618888 bytes / 302818945 usecs = 13965 KB/s
4347396104 bytes / 301976472 usecs = 14059 KB/s
4327473160 bytes / 302726014 usecs = 13959 KB/s
4326948872 bytes / 301203121 usecs = 14028 KB/s
4348968968 bytes / 302449660 usecs = 14042 KB/s
4334813192 bytes / 302871748 usecs = 13976 KB/s
4327473160 bytes / 302735426 usecs = 13959 KB/s
4347396104 bytes / 301991680 usecs = 14058 KB/s
4325900296 bytes / 302156355 usecs = 13981 KB/s
4334813192 bytes / 302880588 usecs = 13976 KB/s
4324851720 bytes / 302808848 usecs = 13947 KB/s
4320657416 bytes / 302750188 usecs = 13936 KB/s
4337958920 bytes / 302408820 usecs = 14008 KB/s
4330618888 bytes / 302608895 usecs = 13975 KB/s
4333240328 bytes / 300889969 usecs = 14063 KB/s
4347396104 bytes / 302006484 usecs = 14057 KB/s
4330618888 bytes / 302854241 usecs = 13964 KB/s
4330618888 bytes / 302839367 usecs = 13964 KB/s
4333764616 bytes / 300781248 usecs = 14070 KB/s
4326948872 bytes / 301241270 usecs = 14027 KB/s
4326948872 bytes / 301241271 usecs = 14027 KB/s
4327473160 bytes / 302767629 usecs = 13958 KB/s
4333240328 bytes / 300908940 usecs = 14062 KB/s
4326948872 bytes / 301248421 usecs = 14026 KB/s
4333764616 bytes / 300764847 usecs = 14071 KB/s
4347396104 bytes / 302019539 usecs = 14057 KB/s
4330618888 bytes / 302876630 usecs = 13963 KB/s
4324851720 bytes / 302853629 usecs = 13945 KB/s
4330618888 bytes / 302705714 usecs = 13971 KB/s
4326948872 bytes / 301259196 usecs = 14026 KB/s
4324851720 bytes / 302846414 usecs = 13945 KB/s
4307025928 bytes / 302843837 usecs = 13888 KB/s
4326948872 bytes / 301266849 usecs = 14025 KB/s
4333240328 bytes / 300933848 usecs = 14061 KB/s
4334288904 bytes / 301937384 usecs = 14018 KB/s
4334813192 bytes / 302940901 usecs = 13973 KB/s
4296015880 bytes / 302639326 usecs = 13862 KB/s
4320657416 bytes / 302810620 usecs = 13934 KB/s
4333240328 bytes / 300958196 usecs = 14060 KB/s
4324851720 bytes / 302900511 usecs = 13943 KB/s
4325900296 bytes / 302884627 usecs = 13947 KB/s
4327473160 bytes / 302830078 usecs = 13955 KB/s
4318035976 bytes / 302826753 usecs = 13924 KB/s
4326948872 bytes / 301308331 usecs = 14023 KB/s
4325900296 bytes / 302889859 usecs = 13947 KB/s
4330618888 bytes / 302930106 usecs = 13960 KB/s
4342153224 bytes / 302458417 usecs = 14019 KB/s
4333764616 bytes / 300858799 usecs = 14067 KB/s
4330618888 bytes / 302939646 usecs = 13960 KB/s
4325900296 bytes / 302263247 usecs = 13976 KB/s
4325900296 bytes / 302903108 usecs = 13946 KB/s
4342153224 bytes / 302447109 usecs = 14020 KB/s
4333764616 bytes / 300866051 usecs = 14066 KB/s
4334288904 bytes / 301992951 usecs = 14015 KB/s
4334288904 bytes / 301994321 usecs = 14015 KB/s
4327473160 bytes / 302854979 usecs = 13954 KB/s
4325900296 bytes / 302280052 usecs = 13975 KB/s
4342153224 bytes / 302488753 usecs = 14018 KB/s
4320657416 bytes / 302871132 usecs = 13931 KB/s
4320657416 bytes / 302875902 usecs = 13931 KB/s
4320657416 bytes / 302876248 usecs = 13931 KB/s
4347396104 bytes / 302097719 usecs = 14053 KB/s
4330618888 bytes / 302759789 usecs = 13968 KB/s
4330618888 bytes / 302987002 usecs = 13958 KB/s
4342153224 bytes / 302511394 usecs = 14017 KB/s
4342153224 bytes / 302511394 usecs = 14017 KB/s
4333240328 bytes / 301031014 usecs = 14057 KB/s
4342153224 bytes / 302513741 usecs = 14017 KB/s
4296015880 bytes / 302732580 usecs = 13858 KB/s
4342153224 bytes / 302513392 usecs = 14017 KB/s
4326948872 bytes / 301373459 usecs = 14020 KB/s
4324851720 bytes / 302974189 usecs = 13940 KB/s
4324851720 bytes / 302977520 usecs = 13939 KB/s
4342153224 bytes / 302523304 usecs = 14016 KB/s
4342153224 bytes / 302526504 usecs = 14016 KB/s
4347396104 bytes / 302164424 usecs = 14050 KB/s
4324851720 bytes / 302986791 usecs = 13939 KB/s
4334813192 bytes / 303055568 usecs = 13968 KB/s
4334813192 bytes / 303064857 usecs = 13968 KB/s
4342153224 bytes / 302521816 usecs = 14016 KB/s
4326948872 bytes / 301402555 usecs = 14019 KB/s
4333764616 bytes / 300945186 usecs = 14062 KB/s
4342153224 bytes / 302547534 usecs = 14015 KB/s
4334813192 bytes / 303061373 usecs = 13968 KB/s
4333240328 bytes / 301067441 usecs = 14055 KB/s
4327473160 bytes / 302931858 usecs = 13950 KB/s
4342153224 bytes / 302511394 usecs = 14017 KB/s
4342153224 bytes / 302550541 usecs = 14015 KB/s
4330618888 bytes / 303030643 usecs = 13956 KB/s
4333764616 bytes / 300952506 usecs = 14062 KB/s
4324851720 bytes / 303005772 usecs = 13938 KB/s
4325900296 bytes / 302992039 usecs = 13942 KB/s
4330618888 bytes / 302819589 usecs = 13965 KB/s
4333764616 bytes / 300963972 usecs = 14062 KB/s
4348444680 bytes / 302728610 usecs = 14027 KB/s
4342153224 bytes / 302568091 usecs = 14014 KB/s
4348968968 bytes / 302672012 usecs = 14031 KB/s
4342153224 bytes / 302567833 usecs = 14014 KB/s
4333240328 bytes / 301091580 usecs = 14054 KB/s
4330618888 bytes / 303049390 usecs = 13955 KB/s
4327473160 bytes / 302953537 usecs = 13949 KB/s
4333764616 bytes / 300971198 usecs = 14061 KB/s
4347396104 bytes / 302208539 usecs = 14048 KB/s
4330618888 bytes / 303051458 usecs = 13955 KB/s
4330618888 bytes / 303053332 usecs = 13955 KB/s
4333240328 bytes / 301096410 usecs = 14054 KB/s
4327473160 bytes / 302959007 usecs = 13949 KB/s
4320657416 bytes / 302977964 usecs = 13926 KB/s
4334813192 bytes / 303161414 usecs = 13963 KB/s
4296015880 bytes / 301572372 usecs = 13911 KB/s
4330618888 bytes / 303161599 usecs = 13950 KB/s
4347396104 bytes / 302322143 usecs = 14042 KB/s
4333240328 bytes / 301244328 usecs = 14047 KB/s
4325900296 bytes / 303163361 usecs = 13934 KB/s
4347396104 bytes / 302362553 usecs = 14041 KB/s
4298113032 bytes / 302035394 usecs = 13896 KB/s
4327473160 bytes / 303115766 usecs = 13942 KB/s
4334813192 bytes / 303314508 usecs = 13956 KB/s
4334813192 bytes / 303289516 usecs = 13957 KB/s
4327473160 bytes / 303181867 usecs = 13938 KB/s
4348968968 bytes / 302875653 usecs = 14022 KB/s
4325900296 bytes / 303239160 usecs = 13931 KB/s
4325900296 bytes / 303266575 usecs = 13930 KB/s
4324851720 bytes / 303288903 usecs = 13925 KB/s
4325900296 bytes / 303281849 usecs = 13929 KB/s
4348968968 bytes / 303006047 usecs = 14016 KB/s
4324851720 bytes / 303304351 usecs = 13924 KB/s
4329570312 bytes / 303368309 usecs = 13937 KB/s
4330618888 bytes / 303343238 usecs = 13941 KB/s
4329570312 bytes / 303372415 usecs = 13936 KB/s
4329570312 bytes / 303380580 usecs = 13936 KB/s
4321705992 bytes / 300807373 usecs = 14030 KB/s
4334813192 bytes / 303399321 usecs = 13952 KB/s
4348968968 bytes / 302978096 usecs = 14017 KB/s
4342153224 bytes / 302854414 usecs = 14001 KB/s
4329570312 bytes / 303386872 usecs = 13936 KB/s
4320657416 bytes / 303268064 usecs = 13913 KB/s
4325900296 bytes / 303333598 usecs = 13926 KB/s
4321705992 bytes / 300837971 usecs = 14028 KB/s
4347396104 bytes / 302534782 usecs = 14033 KB/s
4348444680 bytes / 303063761 usecs = 14011 KB/s
4321705992 bytes / 300839668 usecs = 14028 KB/s
4336910344 bytes / 303258978 usecs = 13965 KB/s
4336910344 bytes / 303259772 usecs = 13965 KB/s
4336910344 bytes / 303263010 usecs = 13965 KB/s
4320657416 bytes / 303295868 usecs = 13911 KB/s
4327473160 bytes / 303297768 usecs = 13933 KB/s
4330618888 bytes / 303395526 usecs = 13939 KB/s
4333764616 bytes / 301317268 usecs = 14045 KB/s
4333764616 bytes / 301307181 usecs = 14046 KB/s
4327473160 bytes / 303308690 usecs = 13933 KB/s
4347396104 bytes / 302564353 usecs = 14031 KB/s
4333764616 bytes / 301337217 usecs = 14044 KB/s
4324851720 bytes / 303395174 usecs = 13920 KB/s
4334288904 bytes / 302466360 usecs = 13993 KB/s
4303355912 bytes / 302200728 usecs = 13906 KB/s
4334288904 bytes / 302479392 usecs = 13993 KB/s
4321705992 bytes / 300855683 usecs = 14028 KB/s
4333240328 bytes / 301482173 usecs = 14036 KB/s
4333240328 bytes / 301486453 usecs = 14036 KB/s
4325900296 bytes / 303404020 usecs = 13923 KB/s
4347396104 bytes / 302605915 usecs = 14029 KB/s
4321705992 bytes / 300912908 usecs = 14025 KB/s
4325900296 bytes / 303413737 usecs = 13923 KB/s
4312793096 bytes / 303235011 usecs = 13889 KB/s
4312793096 bytes / 303235710 usecs = 13889 KB/s
4342153224 bytes / 302978348 usecs = 13995 KB/s
4333764616 bytes / 301378677 usecs = 14042 KB/s
4321705992 bytes / 300931197 usecs = 14024 KB/s
4342153224 bytes / 302995309 usecs = 13994 KB/s
4342153224 bytes / 302995666 usecs = 13994 KB/s
4342153224 bytes / 302996560 usecs = 13994 KB/s
4296015880 bytes / 301909115 usecs = 13895 KB/s
4326948872 bytes / 301854773 usecs = 13998 KB/s
4326948872 bytes / 301865007 usecs = 13998 KB/s
4295491592 bytes / 301130143 usecs = 13930 KB/s
4320657416 bytes / 303396866 usecs = 13907 KB/s
4330618888 bytes / 303495620 usecs = 13934 KB/s
4330618888 bytes / 303497049 usecs = 13934 KB/s
4336910344 bytes / 303355676 usecs = 13961 KB/s
4321705992 bytes / 300958672 usecs = 14023 KB/s
4347396104 bytes / 302660162 usecs = 14027 KB/s
4333764616 bytes / 301413504 usecs = 14041 KB/s
4330618888 bytes / 303506346 usecs = 13934 KB/s
4327473160 bytes / 303411855 usecs = 13928 KB/s
4342153224 bytes / 303032887 usecs = 13993 KB/s
4329570312 bytes / 303544769 usecs = 13929 KB/s
4329570312 bytes / 303546250 usecs = 13929 KB/s
4329570312 bytes / 303546662 usecs = 13928 KB/s
4329570312 bytes / 303547071 usecs = 13928 KB/s
4321705992 bytes / 300978947 usecs = 14022 KB/s
4336910344 bytes / 303321751 usecs = 13962 KB/s
4321705992 bytes / 300978984 usecs = 14022 KB/s
4320657416 bytes / 303429672 usecs = 13905 KB/s
4312793096 bytes / 303307630 usecs = 13885 KB/s
4296015880 bytes / 302864308 usecs = 13852 KB/s
4342153224 bytes / 303029530 usecs = 13993 KB/s
4333240328 bytes / 301578985 usecs = 14031 KB/s
4333764616 bytes / 301458215 usecs = 14039 KB/s
4333764616 bytes / 301474423 usecs = 14038 KB/s
4327473160 bytes / 303462849 usecs = 13926 KB/s
4313317384 bytes / 303539883 usecs = 13877 KB/s
4342153224 bytes / 303086902 usecs = 13990 KB/s
4327473160 bytes / 303472554 usecs = 13925 KB/s
4342153224 bytes / 303084298 usecs = 13990 KB/s
4329570312 bytes / 303612897 usecs = 13925 KB/s
4327473160 bytes / 303410515 usecs = 13928 KB/s
4320657416 bytes / 303500568 usecs = 13902 KB/s
4329570312 bytes / 303625712 usecs = 13925 KB/s
4329570312 bytes / 303631744 usecs = 13925 KB/s
4320657416 bytes / 303519234 usecs = 13901 KB/s
4336910344 bytes / 303506909 usecs = 13954 KB/s
4336910344 bytes / 303507842 usecs = 13954 KB/s
4312793096 bytes / 303407049 usecs = 13881 KB/s
4314890248 bytes / 300770575 usecs = 14009 KB/s
4329570312 bytes / 303692177 usecs = 13922 KB/s
4347396104 bytes / 302854136 usecs = 14018 KB/s
4314890248 bytes / 300839510 usecs = 14006 KB/s
4313317384 bytes / 303692799 usecs = 13870 KB/s
4313317384 bytes / 303722286 usecs = 13868 KB/s
4333764616 bytes / 301678252 usecs = 14028 KB/s
4324851720 bytes / 303736607 usecs = 13905 KB/s
4321705992 bytes / 301222485 usecs = 14010 KB/s
4336910344 bytes / 303650855 usecs = 13947 KB/s
4333764616 bytes / 301669142 usecs = 14029 KB/s
4314890248 bytes / 300852407 usecs = 14006 KB/s
4320657416 bytes / 303687555 usecs = 13893 KB/s
4321705992 bytes / 301246310 usecs = 14009 KB/s
4347396104 bytes / 302945595 usecs = 14014 KB/s
4333764616 bytes / 301684341 usecs = 14028 KB/s
4348968968 bytes / 303479877 usecs = 13994 KB/s
4330618888 bytes / 303808634 usecs = 13920 KB/s
4321705992 bytes / 301215003 usecs = 14011 KB/s
4336910344 bytes / 303659336 usecs = 13947 KB/s
4326948872 bytes / 302229090 usecs = 13981 KB/s
4325900296 bytes / 303816809 usecs = 13904 KB/s
4333240328 bytes / 301898281 usecs = 14016 KB/s
4325900296 bytes / 303176407 usecs = 13934 KB/s
4320657416 bytes / 303758676 usecs = 13890 KB/s
4329570312 bytes / 303890234 usecs = 13913 KB/s
4333764616 bytes / 301787625 usecs = 14023 KB/s
4314890248 bytes / 300997252 usecs = 13999 KB/s
4312793096 bytes / 303651930 usecs = 13870 KB/s
4324851720 bytes / 303832180 usecs = 13900 KB/s
4347396104 bytes / 303031871 usecs = 14010 KB/s
4330618888 bytes / 303874797 usecs = 13917 KB/s
4342153224 bytes / 303400151 usecs = 13976 KB/s
4336910344 bytes / 303758584 usecs = 13942 KB/s
4342153224 bytes / 303363504 usecs = 13977 KB/s
4314890248 bytes / 301009543 usecs = 13998 KB/s
4314890248 bytes / 301012277 usecs = 13998 KB/s
4321705992 bytes / 301314986 usecs = 14006 KB/s
4314890248 bytes / 301012782 usecs = 13998 KB/s
4329570312 bytes / 303916958 usecs = 13912 KB/s
4302831624 bytes / 303211310 usecs = 13858 KB/s
4330618888 bytes / 303891676 usecs = 13916 KB/s
4336910344 bytes / 303771264 usecs = 13942 KB/s
4314890248 bytes / 301019414 usecs = 13998 KB/s
4348444680 bytes / 303560789 usecs = 13989 KB/s
4342153224 bytes / 303425361 usecs = 13975 KB/s
4333764616 bytes / 301841477 usecs = 14021 KB/s
4314890248 bytes / 301047896 usecs = 13996 KB/s
4336910344 bytes / 303806236 usecs = 13940 KB/s
4329570312 bytes / 303960652 usecs = 13910 KB/s
4330618888 bytes / 303933150 usecs = 13914 KB/s
4329570312 bytes / 303967133 usecs = 13909 KB/s
4327473160 bytes / 303844299 usecs = 13908 KB/s
4314890248 bytes / 301068266 usecs = 13996 KB/s
4306501640 bytes / 303886784 usecs = 13839 KB/s
4329570312 bytes / 303971911 usecs = 13909 KB/s
4321705992 bytes / 301405539 usecs = 14002 KB/s
4329570312 bytes / 303975368 usecs = 13909 KB/s
4314890248 bytes / 301062415 usecs = 13996 KB/s
4325900296 bytes / 303275337 usecs = 13929 KB/s
4312793096 bytes / 303736877 usecs = 13866 KB/s
4330618888 bytes / 303737326 usecs = 13923 KB/s
4320657416 bytes / 303861079 usecs = 13885 KB/s
4326948872 bytes / 302338583 usecs = 13976 KB/s
4325900296 bytes / 303916168 usecs = 13900 KB/s
4324851720 bytes / 303940026 usecs = 13895 KB/s
4347396104 bytes / 303139926 usecs = 14005 KB/s
4329570312 bytes / 304012966 usecs = 13907 KB/s
4333764616 bytes / 301908008 usecs = 14018 KB/s
4347396104 bytes / 303152723 usecs = 14004 KB/s
4329570312 bytes / 304029172 usecs = 13906 KB/s
4314890248 bytes / 301131023 usecs = 13993 KB/s
4312793096 bytes / 301896434 usecs = 13950 KB/s
4296015880 bytes / 301632587 usecs = 13908 KB/s
4327473160 bytes / 303931324 usecs = 13904 KB/s
4329570312 bytes / 304061271 usecs = 13905 KB/s
4329570312 bytes / 304062699 usecs = 13905 KB/s
4342153224 bytes / 303573560 usecs = 13968 KB/s
4342153224 bytes / 303566063 usecs = 13968 KB/s
4347396104 bytes / 303213275 usecs = 14001 KB/s
4312793096 bytes / 301934830 usecs = 13949 KB/s
4314890248 bytes / 301184555 usecs = 13990 KB/s
4318035976 bytes / 303887961 usecs = 13876 KB/s
4330618888 bytes / 304062159 usecs = 13908 KB/s
4325900296 bytes / 304025127 usecs = 13895 KB/s
4333240328 bytes / 302109089 usecs = 14007 KB/s
4342153224 bytes / 303590102 usecs = 13967 KB/s
4333764616 bytes / 301994193 usecs = 14014 KB/s
4312793096 bytes / 303843660 usecs = 13861 KB/s
4320657416 bytes / 303988692 usecs = 13880 KB/s
4336910344 bytes / 303964136 usecs = 13933 KB/s
4312793096 bytes / 301964410 usecs = 13947 KB/s
4333764616 bytes / 302019603 usecs = 14012 KB/s
4329570312 bytes / 304134585 usecs = 13902 KB/s
4312793096 bytes / 301988880 usecs = 13946 KB/s
4304404488 bytes / 303915926 usecs = 13831 KB/s
4320657416 bytes / 304019170 usecs = 13878 KB/s
4342153224 bytes / 303638903 usecs = 13965 KB/s
4333240328 bytes / 302158852 usecs = 14004 KB/s
4342153224 bytes / 303641284 usecs = 13965 KB/s
4314890248 bytes / 301251263 usecs = 13987 KB/s
4312793096 bytes / 302002423 usecs = 13945 KB/s
4314890248 bytes / 301255134 usecs = 13987 KB/s
4330618888 bytes / 304138010 usecs = 13905 KB/s
4312793096 bytes / 302020834 usecs = 13945 KB/s
4314890248 bytes / 301255401 usecs = 13987 KB/s
4329570312 bytes / 304193346 usecs = 13899 KB/s
4326948872 bytes / 302548245 usecs = 13966 KB/s
4312793096 bytes / 302045230 usecs = 13943 KB/s
4314890248 bytes / 301299474 usecs = 13985 KB/s
4327473160 bytes / 304080257 usecs = 13897 KB/s
4336910344 bytes / 304070661 usecs = 13928 KB/s
4329570312 bytes / 304221401 usecs = 13898 KB/s
4314890248 bytes / 301323146 usecs = 13984 KB/s
4300210184 bytes / 303978102 usecs = 13814 KB/s
4336910344 bytes / 304076025 usecs = 13928 KB/s
4312793096 bytes / 302085117 usecs = 13942 KB/s
4336910344 bytes / 304091164 usecs = 13927 KB/s
4325900296 bytes / 304173903 usecs = 13888 KB/s
4342153224 bytes / 303742444 usecs = 13960 KB/s
4312793096 bytes / 302097105 usecs = 13941 KB/s
4333764616 bytes / 302142369 usecs = 14007 KB/s
4333764616 bytes / 302154922 usecs = 14006 KB/s
4296015880 bytes / 301849222 usecs = 13898 KB/s
4333764616 bytes / 302169489 usecs = 14006 KB/s
4312793096 bytes / 304018923 usecs = 13853 KB/s
4325900296 bytes / 304216216 usecs = 13886 KB/s
4314890248 bytes / 301387134 usecs = 13981 KB/s
4296015880 bytes / 301871371 usecs = 13897 KB/s
4298113032 bytes / 301726674 usecs = 13911 KB/s
4336910344 bytes / 304149132 usecs = 13924 KB/s
4333240328 bytes / 302316679 usecs = 13997 KB/s
4330618888 bytes / 304286192 usecs = 13898 KB/s
4298113032 bytes / 301749542 usecs = 13910 KB/s
4321705992 bytes / 301751832 usecs = 13986 KB/s
4312793096 bytes / 302169963 usecs = 13938 KB/s
4336910344 bytes / 304171466 usecs = 13923 KB/s
4330618888 bytes / 304293238 usecs = 13898 KB/s
4336910344 bytes / 304195425 usecs = 13922 KB/s
4312793096 bytes / 302195584 usecs = 13937 KB/s
4325900296 bytes / 304290709 usecs = 13883 KB/s
4333240328 bytes / 302373685 usecs = 13994 KB/s
4312793096 bytes / 304120735 usecs = 13848 KB/s
4329570312 bytes / 304369423 usecs = 13891 KB/s
4314890248 bytes / 301484485 usecs = 13976 KB/s
4336910344 bytes / 304236879 usecs = 13920 KB/s
4342153224 bytes / 303854321 usecs = 13955 KB/s
4336910344 bytes / 304243164 usecs = 13920 KB/s
4336910344 bytes / 304241979 usecs = 13920 KB/s
4312793096 bytes / 304149542 usecs = 13847 KB/s
4330618888 bytes / 304383694 usecs = 13894 KB/s
4314890248 bytes / 301511617 usecs = 13975 KB/s
4325900296 bytes / 303707838 usecs = 13909 KB/s
4329570312 bytes / 304417676 usecs = 13889 KB/s
4336910344 bytes / 304267948 usecs = 13919 KB/s
4342153224 bytes / 303902060 usecs = 13953 KB/s
4327473160 bytes / 304301927 usecs = 13887 KB/s
4314890248 bytes / 301529061 usecs = 13974 KB/s
4302831624 bytes / 303166822 usecs = 13860 KB/s
4349493256 bytes / 304027222 usecs = 13970 KB/s
4349493256 bytes / 304027400 usecs = 13970 KB/s
4312793096 bytes / 302278264 usecs = 13933 KB/s
4321705992 bytes / 301860486 usecs = 13981 KB/s
4320657416 bytes / 304315949 usecs = 13865 KB/s
4336910344 bytes / 304290844 usecs = 13918 KB/s
4336910344 bytes / 304292015 usecs = 13918 KB/s
4336910344 bytes / 304293006 usecs = 13918 KB/s
4342153224 bytes / 303937671 usecs = 13951 KB/s
4349493256 bytes / 304039441 usecs = 13970 KB/s
4314890248 bytes / 301545624 usecs = 13973 KB/s
4325900296 bytes / 304382536 usecs = 13878 KB/s
4325900296 bytes / 304383299 usecs = 13878 KB/s
4333764616 bytes / 302350010 usecs = 13997 KB/s
4349493256 bytes / 304059510 usecs = 13969 KB/s
4349493256 bytes / 304059653 usecs = 13969 KB/s
4342153224 bytes / 303947662 usecs = 13951 KB/s
4330618888 bytes / 304443232 usecs = 13891 KB/s
4347396104 bytes / 303601115 usecs = 13983 KB/s
4325900296 bytes / 304404017 usecs = 13877 KB/s
4348968968 bytes / 304131446 usecs = 13964 KB/s
4314890248 bytes / 301577992 usecs = 13972 KB/s
4312793096 bytes / 302330216 usecs = 13930 KB/s
4349493256 bytes / 304077358 usecs = 13968 KB/s
4342153224 bytes / 303981015 usecs = 13949 KB/s
4312793096 bytes / 302354876 usecs = 13929 KB/s
4312793096 bytes / 304262387 usecs = 13842 KB/s
4306501640 bytes / 303527064 usecs = 13855 KB/s
4349493256 bytes / 304107925 usecs = 13967 KB/s
4325900296 bytes / 304458190 usecs = 13875 KB/s
4298113032 bytes / 301965761 usecs = 13900 KB/s
4349493256 bytes / 304131801 usecs = 13966 KB/s
4312793096 bytes / 302392013 usecs = 13927 KB/s
4342153224 bytes / 304042523 usecs = 13946 KB/s
4347396104 bytes / 303679435 usecs = 13980 KB/s
4333764616 bytes / 302448983 usecs = 13993 KB/s
4349493256 bytes / 304152727 usecs = 13965 KB/s
4349493256 bytes / 304152727 usecs = 13965 KB/s
4349493256 bytes / 304153574 usecs = 13965 KB/s
4349493256 bytes / 304158713 usecs = 13964 KB/s
4314890248 bytes / 301670705 usecs = 13968 KB/s
4348968968 bytes / 304243161 usecs = 13959 KB/s
4329570312 bytes / 304594201 usecs = 13881 KB/s
4312793096 bytes / 302445475 usecs = 13925 KB/s
4312793096 bytes / 302431567 usecs = 13926 KB/s
4349493256 bytes / 304210858 usecs = 13962 KB/s
4312793096 bytes / 302467893 usecs = 13924 KB/s
4295491592 bytes / 304326284 usecs = 13783 KB/s
4349493256 bytes / 304220894 usecs = 13962 KB/s
4349493256 bytes / 304222352 usecs = 13961 KB/s
4349493256 bytes / 304226071 usecs = 13961 KB/s
4312793096 bytes / 302499846 usecs = 13923 KB/s
4314890248 bytes / 301736986 usecs = 13965 KB/s
4325900296 bytes / 304593329 usecs = 13869 KB/s
4300734472 bytes / 304421302 usecs = 13796 KB/s
4349493256 bytes / 304285350 usecs = 13959 KB/s
4327473160 bytes / 304574385 usecs = 13875 KB/s
4349493256 bytes / 304294542 usecs = 13958 KB/s
4349493256 bytes / 304297009 usecs = 13958 KB/s
4314890248 bytes / 301801235 usecs = 13962 KB/s
4349493256 bytes / 304303746 usecs = 13958 KB/s
4349493256 bytes / 304304737 usecs = 13958 KB/s
4349493256 bytes / 304312518 usecs = 13957 KB/s
4312793096 bytes / 302573041 usecs = 13919 KB/s
4314890248 bytes / 301822615 usecs = 13961 KB/s
4349493256 bytes / 304321471 usecs = 13957 KB/s
4329570312 bytes / 304727820 usecs = 13874 KB/s
4312793096 bytes / 302579803 usecs = 13919 KB/s
4333764616 bytes / 302626789 usecs = 13984 KB/s
4325900296 bytes / 304666427 usecs = 13866 KB/s
4349493256 bytes / 304333528 usecs = 13956 KB/s
4325900296 bytes / 304043529 usecs = 13894 KB/s
4312793096 bytes / 302607049 usecs = 13918 KB/s
4325900296 bytes / 304693406 usecs = 13864 KB/s
4349493256 bytes / 304368927 usecs = 13955 KB/s
4314890248 bytes / 301908797 usecs = 13957 KB/s
4342153224 bytes / 304308383 usecs = 13934 KB/s
4298113032 bytes / 302261640 usecs = 13886 KB/s
4321705992 bytes / 302288369 usecs = 13961 KB/s
4320657416 bytes / 304753804 usecs = 13845 KB/s
4312793096 bytes / 302733195 usecs = 13912 KB/s
4349493256 bytes / 304482545 usecs = 13950 KB/s
4296015880 bytes / 304713056 usecs = 13768 KB/s
4349493256 bytes / 304485766 usecs = 13949 KB/s
4330618888 bytes / 304893154 usecs = 13870 KB/s
4314890248 bytes / 302037326 usecs = 13951 KB/s
4329570312 bytes / 304962542 usecs = 13864 KB/s
4312793096 bytes / 304737116 usecs = 13820 KB/s
4325900296 bytes / 304923322 usecs = 13854 KB/s
4300734472 bytes / 304766391 usecs = 13780 KB/s
4312793096 bytes / 302867227 usecs = 13906 KB/s
4306501640 bytes / 304944928 usecs = 13791 KB/s
4325900296 bytes / 304945868 usecs = 13853 KB/s
4325900296 bytes / 304945869 usecs = 13853 KB/s
4297588744 bytes / 301460968 usecs = 13921 KB/s
4349493256 bytes / 304640601 usecs = 13942 KB/s
4325900296 bytes / 304976928 usecs = 13851 KB/s
4349493256 bytes / 304663543 usecs = 13941 KB/s
4325900296 bytes / 305004986 usecs = 13850 KB/s
4325900296 bytes / 305005313 usecs = 13850 KB/s
4349493256 bytes / 304687864 usecs = 13940 KB/s
4337958920 bytes / 302427130 usecs = 14007 KB/s
4300734472 bytes / 304847678 usecs = 13777 KB/s
4337958920 bytes / 303986492 usecs = 13935 KB/s
4337958920 bytes / 303130040 usecs = 13975 KB/s
4337958920 bytes / 302745938 usecs = 13992 KB/s
4349493256 bytes / 304696502 usecs = 13940 KB/s
4349493256 bytes / 304698495 usecs = 13940 KB/s
4312793096 bytes / 303001799 usecs = 13899 KB/s
4298637320 bytes / 303924136 usecs = 13812 KB/s
4349493256 bytes / 304775251 usecs = 13936 KB/s
4334813192 bytes / 303418121 usecs = 13951 KB/s
4334813192 bytes / 304024467 usecs = 13923 KB/s
4334813192 bytes / 304308510 usecs = 13910 KB/s
4334813192 bytes / 303563606 usecs = 13945 KB/s
4334813192 bytes / 304716993 usecs = 13892 KB/s
4334813192 bytes / 303755084 usecs = 13936 KB/s
4334813192 bytes / 304493029 usecs = 13902 KB/s
4329570312 bytes / 305185630 usecs = 13854 KB/s
4334813192 bytes / 305203281 usecs = 13870 KB/s
4334813192 bytes / 303893793 usecs = 13929 KB/s
4302307336 bytes / 304962833 usecs = 13776 KB/s
4334813192 bytes / 304058830 usecs = 13922 KB/s
4325900296 bytes / 305103940 usecs = 13846 KB/s
4334813192 bytes / 303569833 usecs = 13944 KB/s
4334813192 bytes / 305214304 usecs = 13869 KB/s
4349493256 bytes / 304793674 usecs = 13935 KB/s
4326948872 bytes / 305078225 usecs = 13850 KB/s
4349493256 bytes / 304817961 usecs = 13934 KB/s
4334813192 bytes / 305219653 usecs = 13869 KB/s
4326948872 bytes / 305097378 usecs = 13849 KB/s
4326948872 bytes / 305106765 usecs = 13849 KB/s
4334813192 bytes / 305253206 usecs = 13867 KB/s
4329570312 bytes / 305246617 usecs = 13851 KB/s
4310695944 bytes / 305001111 usecs = 13802 KB/s
4298637320 bytes / 304001604 usecs = 13808 KB/s
4312793096 bytes / 303108627 usecs = 13895 KB/s
4326948872 bytes / 305162189 usecs = 13846 KB/s
4325900296 bytes / 305225172 usecs = 13840 KB/s
4308598792 bytes / 304836306 usecs = 13802 KB/s
4326948872 bytes / 305183838 usecs = 13845 KB/s
4326948872 bytes / 305196717 usecs = 13845 KB/s
4326948872 bytes / 305214342 usecs = 13844 KB/s
4325900296 bytes / 305284295 usecs = 13837 KB/s
4308598792 bytes / 304901181 usecs = 13799 KB/s
4308598792 bytes / 304901181 usecs = 13799 KB/s
4329570312 bytes / 305417750 usecs = 13843 KB/s
4326948872 bytes / 305295417 usecs = 13840 KB/s
4326948872 bytes / 305303113 usecs = 13840 KB/s
4308598792 bytes / 304937973 usecs = 13798 KB/s
4312793096 bytes / 305195420 usecs = 13800 KB/s
4326948872 bytes / 305319278 usecs = 13839 KB/s
4325900296 bytes / 305366183 usecs = 13834 KB/s
4326948872 bytes / 305322720 usecs = 13839 KB/s
4325900296 bytes / 305379545 usecs = 13833 KB/s
4308598792 bytes / 305017066 usecs = 13794 KB/s
4308598792 bytes / 305046568 usecs = 13793 KB/s
4320657416 bytes / 305395862 usecs = 13816 KB/s
4325900296 bytes / 305449460 usecs = 13830 KB/s
4325900296 bytes / 305451008 usecs = 13830 KB/s
4326948872 bytes / 305437914 usecs = 13834 KB/s
4349493256 bytes / 305178753 usecs = 13918 KB/s
4304404488 bytes / 303989559 usecs = 13827 KB/s
4349493256 bytes / 305184524 usecs = 13917 KB/s
4326948872 bytes / 305474979 usecs = 13832 KB/s
4308598792 bytes / 305139534 usecs = 13789 KB/s
4308598792 bytes / 305144096 usecs = 13788 KB/s
4314890248 bytes / 302725432 usecs = 13919 KB/s
4308598792 bytes / 305145842 usecs = 13788 KB/s
4304404488 bytes / 304035568 usecs = 13825 KB/s
4304404488 bytes / 304059297 usecs = 13824 KB/s
4332191752 bytes / 305621492 usecs = 13842 KB/s
4326948872 bytes / 305525811 usecs = 13830 KB/s
4325900296 bytes / 305571814 usecs = 13824 KB/s
4332191752 bytes / 305625502 usecs = 13842 KB/s
4332191752 bytes / 305641802 usecs = 13841 KB/s
4332191752 bytes / 305644028 usecs = 13841 KB/s
4332191752 bytes / 305644282 usecs = 13841 KB/s
4325900296 bytes / 305596757 usecs = 13823 KB/s
4326948872 bytes / 305564176 usecs = 13828 KB/s
4304404488 bytes / 304102281 usecs = 13822 KB/s
4297064456 bytes / 305477392 usecs = 13737 KB/s
4325900296 bytes / 305619863 usecs = 13822 KB/s
4304404488 bytes / 304111966 usecs = 13822 KB/s
4326948872 bytes / 305578259 usecs = 13827 KB/s
4304404488 bytes / 304109746 usecs = 13822 KB/s
4332191752 bytes / 305679368 usecs = 13840 KB/s
4349493256 bytes / 305367159 usecs = 13909 KB/s
4308598792 bytes / 305554392 usecs = 13770 KB/s
4325900296 bytes / 305648064 usecs = 13821 KB/s
4349493256 bytes / 305400147 usecs = 13908 KB/s
4349493256 bytes / 305404476 usecs = 13907 KB/s
4349493256 bytes / 305404473 usecs = 13907 KB/s
4326948872 bytes / 305630028 usecs = 13825 KB/s
4304404488 bytes / 304166570 usecs = 13819 KB/s
4332191752 bytes / 305730686 usecs = 13837 KB/s
4308598792 bytes / 305298314 usecs = 13781 KB/s
4332191752 bytes / 305744485 usecs = 13837 KB/s
4308598792 bytes / 305617171 usecs = 13767 KB/s
4349493256 bytes / 305446105 usecs = 13906 KB/s
4308598792 bytes / 305623058 usecs = 13767 KB/s
4308598792 bytes / 305625114 usecs = 13767 KB/s
4326948872 bytes / 305677511 usecs = 13823 KB/s
4349493256 bytes / 305471158 usecs = 13904 KB/s
4308598792 bytes / 305653498 usecs = 13765 KB/s
4349493256 bytes / 305485798 usecs = 13904 KB/s
4349493256 bytes / 305492819 usecs = 13903 KB/s
4326948872 bytes / 305728881 usecs = 13821 KB/s
4326948872 bytes / 305737496 usecs = 13820 KB/s
4325900296 bytes / 305783262 usecs = 13815 KB/s
4308598792 bytes / 305396588 usecs = 13777 KB/s
4325900296 bytes / 305790926 usecs = 13815 KB/s
4332191752 bytes / 305843691 usecs = 13832 KB/s
4308598792 bytes / 305708479 usecs = 13763 KB/s
4308598792 bytes / 305710269 usecs = 13763 KB/s
4308598792 bytes / 305708120 usecs = 13763 KB/s
4308598792 bytes / 305419198 usecs = 13776 KB/s
4308598792 bytes / 305423528 usecs = 13776 KB/s
4349493256 bytes / 305554111 usecs = 13901 KB/s
4349493256 bytes / 305498416 usecs = 13903 KB/s
4304404488 bytes / 304310078 usecs = 13813 KB/s
4349493256 bytes / 305559193 usecs = 13900 KB/s
4296540168 bytes / 303340524 usecs = 13832 KB/s
4298113032 bytes / 305737273 usecs = 13728 KB/s
4307025928 bytes / 305211652 usecs = 13780 KB/s
4307025928 bytes / 305212444 usecs = 13780 KB/s
4304404488 bytes / 304341611 usecs = 13811 KB/s
4332191752 bytes / 305917483 usecs = 13829 KB/s
4349493256 bytes / 305613244 usecs = 13898 KB/s
4332191752 bytes / 305928694 usecs = 13828 KB/s
4330618888 bytes / 304566397 usecs = 13885 KB/s
4313317384 bytes / 304085667 usecs = 13852 KB/s
4313317384 bytes / 304715700 usecs = 13823 KB/s
4313317384 bytes / 304126816 usecs = 13850 KB/s
4313317384 bytes / 305014343 usecs = 13809 KB/s
4313317384 bytes / 304797572 usecs = 13819 KB/s
4324851720 bytes / 305105570 usecs = 13842 KB/s
4324851720 bytes / 304257153 usecs = 13881 KB/s
4313317384 bytes / 304272470 usecs = 13843 KB/s
4324851720 bytes / 303979253 usecs = 13894 KB/s
4332191752 bytes / 305624491 usecs = 13842 KB/s
4308598792 bytes / 305493045 usecs = 13773 KB/s
4330618888 bytes / 304517931 usecs = 13887 KB/s
4313317384 bytes / 305226940 usecs = 13800 KB/s
4313317384 bytes / 304677307 usecs = 13825 KB/s
4349493256 bytes / 305633225 usecs = 13897 KB/s
4301783048 bytes / 305789873 usecs = 13738 KB/s
4313317384 bytes / 305058446 usecs = 13807 KB/s
4349493256 bytes / 305642865 usecs = 13897 KB/s
4308598792 bytes / 305532575 usecs = 13771 KB/s
4325900296 bytes / 305926059 usecs = 13808 KB/s
4326948872 bytes / 305885825 usecs = 13814 KB/s
4304404488 bytes / 304424672 usecs = 13808 KB/s
4325900296 bytes / 305933947 usecs = 13808 KB/s
4308598792 bytes / 305846384 usecs = 13757 KB/s
4298637320 bytes / 304779302 usecs = 13773 KB/s
4307025928 bytes / 305326169 usecs = 13775 KB/s
4326948872 bytes / 305916677 usecs = 13812 KB/s
4325900296 bytes / 305963691 usecs = 13807 KB/s
4325900296 bytes / 305970148 usecs = 13806 KB/s
4349493256 bytes / 305710055 usecs = 13894 KB/s
4349493256 bytes / 305742141 usecs = 13892 KB/s
4312793096 bytes / 303948433 usecs = 13856 KB/s
4332191752 bytes / 306075422 usecs = 13822 KB/s
4332191752 bytes / 306075422 usecs = 13822 KB/s
4312793096 bytes / 303973011 usecs = 13855 KB/s
4349493256 bytes / 305781103 usecs = 13890 KB/s
4308598792 bytes / 305654564 usecs = 13765 KB/s
4332191752 bytes / 306102149 usecs = 13821 KB/s
4309647368 bytes / 305491311 usecs = 13776 KB/s
4332191752 bytes / 306144464 usecs = 13819 KB/s
4304404488 bytes / 304588997 usecs = 13800 KB/s
4332191752 bytes / 306159250 usecs = 13818 KB/s
4309647368 bytes / 305521531 usecs = 13775 KB/s
4312793096 bytes / 304070612 usecs = 13851 KB/s
4308598792 bytes / 306046463 usecs = 13748 KB/s
4332191752 bytes / 306206797 usecs = 13816 KB/s
4309647368 bytes / 305565826 usecs = 13773 KB/s
4309647368 bytes / 305567353 usecs = 13773 KB/s
4309647368 bytes / 305567442 usecs = 13773 KB/s
4308598792 bytes / 305766178 usecs = 13760 KB/s
4342153224 bytes / 304045182 usecs = 13946 KB/s
4342153224 bytes / 304963759 usecs = 13904 KB/s
4342153224 bytes / 305742159 usecs = 13869 KB/s
4342153224 bytes / 304245836 usecs = 13937 KB/s
4332191752 bytes / 306234488 usecs = 13815 KB/s
4309647368 bytes / 305597770 usecs = 13771 KB/s
4304404488 bytes / 304679719 usecs = 13796 KB/s
4326948872 bytes / 306148735 usecs = 13802 KB/s
4308598792 bytes / 305810917 usecs = 13758 KB/s
4308598792 bytes / 306124971 usecs = 13744 KB/s
4304404488 bytes / 304715178 usecs = 13794 KB/s
4325900296 bytes / 306230338 usecs = 13795 KB/s
4308598792 bytes / 305841553 usecs = 13757 KB/s
4298637320 bytes / 305070175 usecs = 13760 KB/s
4332191752 bytes / 306293054 usecs = 13812 KB/s
4294967304 bytes / 300748427 usecs = 13946 KB/s
4294967304 bytes / 300751055 usecs = 13946 KB/s
4326948872 bytes / 306202080 usecs = 13799 KB/s
4298637320 bytes / 305082474 usecs = 13759 KB/s
4349493256 bytes / 306007704 usecs = 13880 KB/s
4349493256 bytes / 306010437 usecs = 13880 KB/s
4296540168 bytes / 303808149 usecs = 13810 KB/s
4309647368 bytes / 305719158 usecs = 13766 KB/s
4332191752 bytes / 306374433 usecs = 13808 KB/s
4349493256 bytes / 306062723 usecs = 13878 KB/s
4309647368 bytes / 305756804 usecs = 13764 KB/s
4309647368 bytes / 305764192 usecs = 13764 KB/s
4309647368 bytes / 305764368 usecs = 13764 KB/s
4307025928 bytes / 305732162 usecs = 13757 KB/s
4309647368 bytes / 305765361 usecs = 13764 KB/s
4294967304 bytes / 302139310 usecs = 13882 KB/s
4295491592 bytes / 305203898 usecs = 13744 KB/s
4349493256 bytes / 306114973 usecs = 13875 KB/s
4349493256 bytes / 306114972 usecs = 13875 KB/s
4294967304 bytes / 302172243 usecs = 13880 KB/s
4349493256 bytes / 306170416 usecs = 13873 KB/s
4336910344 bytes / 304827974 usecs = 13893 KB/s
4336910344 bytes / 306122819 usecs = 13835 KB/s
4336910344 bytes / 304351521 usecs = 13915 KB/s
4336910344 bytes / 304540035 usecs = 13907 KB/s
4336910344 bytes / 305690168 usecs = 13854 KB/s
4336910344 bytes / 304347244 usecs = 13915 KB/s
4336910344 bytes / 305052671 usecs = 13883 KB/s
4336910344 bytes / 305397380 usecs = 13868 KB/s
4336910344 bytes / 304371761 usecs = 13914 KB/s
4336910344 bytes / 305219723 usecs = 13876 KB/s
4336910344 bytes / 304325722 usecs = 13916 KB/s
4309647368 bytes / 305877528 usecs = 13759 KB/s
4298637320 bytes / 305311039 usecs = 13749 KB/s
4308598792 bytes / 306118701 usecs = 13745 KB/s
4304404488 bytes / 305005889 usecs = 13781 KB/s
4349493256 bytes / 306278223 usecs = 13868 KB/s
4332191752 bytes / 306605227 usecs = 13798 KB/s
4332191752 bytes / 306605247 usecs = 13798 KB/s
4309647368 bytes / 305978921 usecs = 13754 KB/s
4349493256 bytes / 306316393 usecs = 13866 KB/s
4332191752 bytes / 306646125 usecs = 13796 KB/s
4307025928 bytes / 305984889 usecs = 13746 KB/s
4349493256 bytes / 306354938 usecs = 13864 KB/s
4308598792 bytes / 306228651 usecs = 13740 KB/s
4332191752 bytes / 306676216 usecs = 13795 KB/s
4309647368 bytes / 306063952 usecs = 13750 KB/s
4304404488 bytes / 305144998 usecs = 13775 KB/s
4326948872 bytes / 306617526 usecs = 13781 KB/s
4304404488 bytes / 305151268 usecs = 13775 KB/s
4297588744 bytes / 303190351 usecs = 13842 KB/s
4332191752 bytes / 306740160 usecs = 13792 KB/s
4309647368 bytes / 306121041 usecs = 13748 KB/s
4304404488 bytes / 305241319 usecs = 13771 KB/s
4307025928 bytes / 306140563 usecs = 13739 KB/s
4307025928 bytes / 306287791 usecs = 13732 KB/s
4309647368 bytes / 306345277 usecs = 13738 KB/s
4309647368 bytes / 306360730 usecs = 13737 KB/s
4296540168 bytes / 303463614 usecs = 13826 KB/s
4308598792 bytes / 306896088 usecs = 13710 KB/s
4314890248 bytes / 304189880 usecs = 13852 KB/s
4332191752 bytes / 307110472 usecs = 13775 KB/s
4299161608 bytes / 306948015 usecs = 13677 KB/s
4326948872 bytes / 307046974 usecs = 13761 KB/s
4300734472 bytes / 306888565 usecs = 13685 KB/s
4314890248 bytes / 306951812 usecs = 13727 KB/s
4314890248 bytes / 307033164 usecs = 13724 KB/s
4334813192 bytes / 306293177 usecs = 13820 KB/s
4314890248 bytes / 307052444 usecs = 13723 KB/s
4314890248 bytes / 307081981 usecs = 13721 KB/s
4314890248 bytes / 307090838 usecs = 13721 KB/s
4349493256 bytes / 306994624 usecs = 13835 KB/s
4334813192 bytes / 306360116 usecs = 13817 KB/s
4322754568 bytes / 307186357 usecs = 13742 KB/s
4334813192 bytes / 306432673 usecs = 13814 KB/s
4334813192 bytes / 306468525 usecs = 13812 KB/s
4314890248 bytes / 307271288 usecs = 13713 KB/s
4314890248 bytes / 307277820 usecs = 13713 KB/s
4296540168 bytes / 303958572 usecs = 13803 KB/s
4334813192 bytes / 306562673 usecs = 13808 KB/s
4303880200 bytes / 307159951 usecs = 13683 KB/s
4314890248 bytes / 307349260 usecs = 13710 KB/s
4334813192 bytes / 306588819 usecs = 13807 KB/s
4325900296 bytes / 306247432 usecs = 13794 KB/s
4334813192 bytes / 306610347 usecs = 13806 KB/s
4304404488 bytes / 306042769 usecs = 13735 KB/s
4295491592 bytes / 306979284 usecs = 13664 KB/s
4334813192 bytes / 306703924 usecs = 13802 KB/s
4315414536 bytes / 307645118 usecs = 13698 KB/s
4299685896 bytes / 307203793 usecs = 13668 KB/s
4294967304 bytes / 301053827 usecs = 13932 KB/s
4294967304 bytes / 301028430 usecs = 13933 KB/s
4314890248 bytes / 307501411 usecs = 13703 KB/s
4300734472 bytes / 307495849 usecs = 13658 KB/s
4314890248 bytes / 307571395 usecs = 13700 KB/s
4334813192 bytes / 306818914 usecs = 13797 KB/s
4296540168 bytes / 304250183 usecs = 13790 KB/s
4334813192 bytes / 306870580 usecs = 13794 KB/s
4334813192 bytes / 306893757 usecs = 13793 KB/s
4334813192 bytes / 306918353 usecs = 13792 KB/s
4295491592 bytes / 307457774 usecs = 13643 KB/s
4300210184 bytes / 305830446 usecs = 13731 KB/s
4295491592 bytes / 307696515 usecs = 13632 KB/s
4334813192 bytes / 307005057 usecs = 13788 KB/s
4297588744 bytes / 305590664 usecs = 13733 KB/s
4314890248 bytes / 307790540 usecs = 13690 KB/s
4295491592 bytes / 307343531 usecs = 13648 KB/s
4334813192 bytes / 307133710 usecs = 13782 KB/s
4300210184 bytes / 305972400 usecs = 13724 KB/s
4314890248 bytes / 307916785 usecs = 13684 KB/s
4296015880 bytes / 307672099 usecs = 13635 KB/s
4336910344 bytes / 306395256 usecs = 13822 KB/s
4309647368 bytes / 307489712 usecs = 13687 KB/s
4300734472 bytes / 307921773 usecs = 13639 KB/s
4297588744 bytes / 308033536 usecs = 13624 KB/s
4312268808 bytes / 308113209 usecs = 13667 KB/s
4296015880 bytes / 307768876 usecs = 13631 KB/s
4308598792 bytes / 308062147 usecs = 13658 KB/s
4308598792 bytes / 308067055 usecs = 13658 KB/s
4334813192 bytes / 307313994 usecs = 13774 KB/s
4348968968 bytes / 308007650 usecs = 13788 KB/s
4308598792 bytes / 308164455 usecs = 13653 KB/s
4334813192 bytes / 307431159 usecs = 13769 KB/s
4297588744 bytes / 305532043 usecs = 13736 KB/s
4321181704 bytes / 305871985 usecs = 13796 KB/s
4308598792 bytes / 308262425 usecs = 13649 KB/s
4308598792 bytes / 308340236 usecs = 13646 KB/s
4348968968 bytes / 308230487 usecs = 13778 KB/s
4297588744 bytes / 306158215 usecs = 13708 KB/s
4348968968 bytes / 308239081 usecs = 13778 KB/s
4348968968 bytes / 308259284 usecs = 13777 KB/s
4300210184 bytes / 306214647 usecs = 13713 KB/s
4308598792 bytes / 308440190 usecs = 13641 KB/s
4295491592 bytes / 308386027 usecs = 13602 KB/s
4332191752 bytes / 308654839 usecs = 13706 KB/s
4313841672 bytes / 308499524 usecs = 13655 KB/s
4300210184 bytes / 306328958 usecs = 13708 KB/s
4308598792 bytes / 308537501 usecs = 13637 KB/s
4322230280 bytes / 306202419 usecs = 13784 KB/s
4322230280 bytes / 306214972 usecs = 13784 KB/s
4300210184 bytes / 306635377 usecs = 13695 KB/s
4300210184 bytes / 306646645 usecs = 13694 KB/s
4300210184 bytes / 306382501 usecs = 13706 KB/s
4322230280 bytes / 306240337 usecs = 13783 KB/s
4314365960 bytes / 308562624 usecs = 13654 KB/s
4348968968 bytes / 308478322 usecs = 13767 KB/s
4322230280 bytes / 306260554 usecs = 13782 KB/s
4322230280 bytes / 306270311 usecs = 13781 KB/s
4300210184 bytes / 306448440 usecs = 13703 KB/s
4322230280 bytes / 306363276 usecs = 13777 KB/s
4322230280 bytes / 306368121 usecs = 13777 KB/s
4322230280 bytes / 306371534 usecs = 13777 KB/s
4300210184 bytes / 306557166 usecs = 13698 KB/s
4322230280 bytes / 306408070 usecs = 13775 KB/s
4322230280 bytes / 306420844 usecs = 13774 KB/s
4334813192 bytes / 308017427 usecs = 13743 KB/s
4311744520 bytes / 309005826 usecs = 13626 KB/s
4300210184 bytes / 306599503 usecs = 13696 KB/s
4340580360 bytes / 308155696 usecs = 13755 KB/s
4300210184 bytes / 306895965 usecs = 13683 KB/s
4300210184 bytes / 306900059 usecs = 13683 KB/s
4333764616 bytes / 307071233 usecs = 13782 KB/s
4311744520 bytes / 309061403 usecs = 13624 KB/s
4296015880 bytes / 308918786 usecs = 13580 KB/s
4310695944 bytes / 308994940 usecs = 13623 KB/s
4322230280 bytes / 306558563 usecs = 13768 KB/s
4300734472 bytes / 308668500 usecs = 13606 KB/s
4333764616 bytes / 307162531 usecs = 13778 KB/s
4333764616 bytes / 307179732 usecs = 13777 KB/s
4295491592 bytes / 308711345 usecs = 13588 KB/s
4295491592 bytes / 307973293 usecs = 13620 KB/s
4348968968 bytes / 308908631 usecs = 13748 KB/s
4308598792 bytes / 309038076 usecs = 13615 KB/s
4297064456 bytes / 303761945 usecs = 13814 KB/s
4333764616 bytes / 307298862 usecs = 13772 KB/s
4327473160 bytes / 309088452 usecs = 13672 KB/s
4333764616 bytes / 307350191 usecs = 13769 KB/s
4300210184 bytes / 306954439 usecs = 13680 KB/s
4295491592 bytes / 308910721 usecs = 13579 KB/s
4308598792 bytes / 309173690 usecs = 13609 KB/s
4297588744 bytes / 306989509 usecs = 13671 KB/s
4297588744 bytes / 303969197 usecs = 13806 KB/s
4311744520 bytes / 309499267 usecs = 13604 KB/s
4300210184 bytes / 307109754 usecs = 13674 KB/s
4333764616 bytes / 307580005 usecs = 13759 KB/s
4307550216 bytes / 309440140 usecs = 13594 KB/s
4297064456 bytes / 304059814 usecs = 13801 KB/s
4310695944 bytes / 309417591 usecs = 13605 KB/s
4297064456 bytes / 304097343 usecs = 13799 KB/s
4310695944 bytes / 309476400 usecs = 13602 KB/s
4310695944 bytes / 309485723 usecs = 13602 KB/s
4333764616 bytes / 307682683 usecs = 13755 KB/s
4311744520 bytes / 309673006 usecs = 13597 KB/s
4300210184 bytes / 307263535 usecs = 13667 KB/s
4334813192 bytes / 309253388 usecs = 13688 KB/s
4327473160 bytes / 308075821 usecs = 13717 KB/s
4295491592 bytes / 307303693 usecs = 13650 KB/s
4333764616 bytes / 307745051 usecs = 13752 KB/s
4333764616 bytes / 307745050 usecs = 13752 KB/s
4327473160 bytes / 308092464 usecs = 13716 KB/s
4309647368 bytes / 309580636 usecs = 13594 KB/s
4327473160 bytes / 308112348 usecs = 13715 KB/s
4300210184 bytes / 307348437 usecs = 13663 KB/s
4333764616 bytes / 307787239 usecs = 13750 KB/s
4310695944 bytes / 309603214 usecs = 13596 KB/s
4311744520 bytes / 309787231 usecs = 13592 KB/s
4299161608 bytes / 309334740 usecs = 13572 KB/s
4297064456 bytes / 304347679 usecs = 13788 KB/s
4297588744 bytes / 307789314 usecs = 13635 KB/s
4327473160 bytes / 308258869 usecs = 13709 KB/s
4300734472 bytes / 306350193 usecs = 13709 KB/s
4311744520 bytes / 309925184 usecs = 13586 KB/s
4297588744 bytes / 304424075 usecs = 13786 KB/s
4300734472 bytes / 306388961 usecs = 13707 KB/s
4327473160 bytes / 308321402 usecs = 13706 KB/s
4310695944 bytes / 309806945 usecs = 13588 KB/s
4310695944 bytes / 309809968 usecs = 13587 KB/s
4297064456 bytes / 304481532 usecs = 13781 KB/s
4296015880 bytes / 308414611 usecs = 13602 KB/s
4297588744 bytes / 307906475 usecs = 13630 KB/s
4311220232 bytes / 309972228 usecs = 13582 KB/s
4295491592 bytes / 309777962 usecs = 13541 KB/s
4295491592 bytes / 304558405 usecs = 13773 KB/s
4297588744 bytes / 304619638 usecs = 13777 KB/s
4308598792 bytes / 309917997 usecs = 13576 KB/s
4327473160 bytes / 308499408 usecs = 13698 KB/s
4310695944 bytes / 309997424 usecs = 13579 KB/s
4333764616 bytes / 308201904 usecs = 13731 KB/s
4330618888 bytes / 309799304 usecs = 13651 KB/s
4327473160 bytes / 308599458 usecs = 13694 KB/s
4310695944 bytes / 310072999 usecs = 13576 KB/s
4310695944 bytes / 310089603 usecs = 13575 KB/s
4296015880 bytes / 308674778 usecs = 13591 KB/s
4300210184 bytes / 308140366 usecs = 13628 KB/s
4297588744 bytes / 304769327 usecs = 13770 KB/s
4327473160 bytes / 308672281 usecs = 13691 KB/s
4311744520 bytes / 310325253 usecs = 13568 KB/s
4310695944 bytes / 310170507 usecs = 13572 KB/s
4297588744 bytes / 304842678 usecs = 13767 KB/s
4318560264 bytes / 310341416 usecs = 13589 KB/s
4297588744 bytes / 308284544 usecs = 13613 KB/s
4347396104 bytes / 309999175 usecs = 13695 KB/s
4322230280 bytes / 306757323 usecs = 13759 KB/s
4322230280 bytes / 306684956 usecs = 13763 KB/s
4322230280 bytes / 306594385 usecs = 13767 KB/s
4322230280 bytes / 306822036 usecs = 13756 KB/s
4322230280 bytes / 306977245 usecs = 13749 KB/s
4322230280 bytes / 307845148 usecs = 13711 KB/s
4348968968 bytes / 309205277 usecs = 13735 KB/s
4348968968 bytes / 308761734 usecs = 13755 KB/s
4348968968 bytes / 308824659 usecs = 13752 KB/s
4348968968 bytes / 308916568 usecs = 13748 KB/s
4348968968 bytes / 308995675 usecs = 13744 KB/s
4348968968 bytes / 308622781 usecs = 13761 KB/s
4348968968 bytes / 309225657 usecs = 13734 KB/s
4348968968 bytes / 309057272 usecs = 13741 KB/s
4348968968 bytes / 310073628 usecs = 13696 KB/s
4327473160 bytes / 308780029 usecs = 13686 KB/s
4310695944 bytes / 310287926 usecs = 13566 KB/s
4310695944 bytes / 310287926 usecs = 13566 KB/s
4300734472 bytes / 310237720 usecs = 13537 KB/s
4300210184 bytes / 310246670 usecs = 13535 KB/s
4300210184 bytes / 310290583 usecs = 13533 KB/s
4300210184 bytes / 308533453 usecs = 13610 KB/s
4297064456 bytes / 309303111 usecs = 13567 KB/s
4327473160 bytes / 308929908 usecs = 13679 KB/s
4296015880 bytes / 310118681 usecs = 13528 KB/s
4300734472 bytes / 307021620 usecs = 13679 KB/s
4297588744 bytes / 305080071 usecs = 13756 KB/s
4327473160 bytes / 308985576 usecs = 13677 KB/s
4300210184 bytes / 308654233 usecs = 13605 KB/s
4327473160 bytes / 309025508 usecs = 13675 KB/s
4327473160 bytes / 309026224 usecs = 13675 KB/s
4331667464 bytes / 310678111 usecs = 13615 KB/s
4333764616 bytes / 308786308 usecs = 13705 KB/s
4299161608 bytes / 310107741 usecs = 13538 KB/s
4300210184 bytes / 310624115 usecs = 13519 KB/s
4300734472 bytes / 307294021 usecs = 13667 KB/s
4324851720 bytes / 310741009 usecs = 13591 KB/s
4297588744 bytes / 305377694 usecs = 13743 KB/s
4297064456 bytes / 308749979 usecs = 13591 KB/s
4297064456 bytes / 308749977 usecs = 13591 KB/s
4296015880 bytes / 309332995 usecs = 13562 KB/s
4294967304 bytes / 306622686 usecs = 13679 KB/s
4296015880 bytes / 309351011 usecs = 13561 KB/s
4300734472 bytes / 307380034 usecs = 13663 KB/s
4300210184 bytes / 309021486 usecs = 13589 KB/s
4295491592 bytes / 310564494 usecs = 13507 KB/s
4301258760 bytes / 311028067 usecs = 13505 KB/s
4300734472 bytes / 308979890 usecs = 13592 KB/s
4297064456 bytes / 309842724 usecs = 13543 KB/s
4300734472 bytes / 310900753 usecs = 13508 KB/s
4294967304 bytes / 304470073 usecs = 13775 KB/s
4300734472 bytes / 307598405 usecs = 13653 KB/s
4295491592 bytes / 308756005 usecs = 13586 KB/s
4300210184 bytes / 310735249 usecs = 13514 KB/s
4296015880 bytes / 310741987 usecs = 13501 KB/s
4297064456 bytes / 310737365 usecs = 13504 KB/s
4300734472 bytes / 307638075 usecs = 13652 KB/s
4299161608 bytes / 310522294 usecs = 13520 KB/s
4300734472 bytes / 307660956 usecs = 13651 KB/s
4300734472 bytes / 307742706 usecs = 13647 KB/s
4300210184 bytes / 311106632 usecs = 13498 KB/s
4297064456 bytes / 310879507 usecs = 13498 KB/s
4297064456 bytes / 305852990 usecs = 13720 KB/s
4333764616 bytes / 309419039 usecs = 13677 KB/s
4297064456 bytes / 309404875 usecs = 13562 KB/s
4300210184 bytes / 311091050 usecs = 13499 KB/s
4297064456 bytes / 311145880 usecs = 13486 KB/s
4313317384 bytes / 311574440 usecs = 13519 KB/s
4308074504 bytes / 311576949 usecs = 13502 KB/s
4302307336 bytes / 311407724 usecs = 13491 KB/s
4302307336 bytes / 311411173 usecs = 13491 KB/s
4300210184 bytes / 311244996 usecs = 13492 KB/s
4320133128 bytes / 311683842 usecs = 13535 KB/s
4298113032 bytes / 311471265 usecs = 13475 KB/s
4300734472 bytes / 308210119 usecs = 13626 KB/s
4301258760 bytes / 311117270 usecs = 13501 KB/s
4302307336 bytes / 311527716 usecs = 13486 KB/s
4302831624 bytes / 311779735 usecs = 13477 KB/s
4320133128 bytes / 311798843 usecs = 13530 KB/s
4320133128 bytes / 311811553 usecs = 13530 KB/s
4294967304 bytes / 300587329 usecs = 13953 KB/s
4314890248 bytes / 310906353 usecs = 13553 KB/s
4302307336 bytes / 311607975 usecs = 13483 KB/s
4301258760 bytes / 311224300 usecs = 13496 KB/s
4302307336 bytes / 311621436 usecs = 13482 KB/s
4311744520 bytes / 311915570 usecs = 13499 KB/s
4320133128 bytes / 311883955 usecs = 13527 KB/s
4298113032 bytes / 311629303 usecs = 13469 KB/s
4302307336 bytes / 311652070 usecs = 13481 KB/s
4298113032 bytes / 311653574 usecs = 13468 KB/s
4295491592 bytes / 309792670 usecs = 13540 KB/s
4301258760 bytes / 311279052 usecs = 13494 KB/s
4295491592 bytes / 310380366 usecs = 13515 KB/s
4300210184 bytes / 311512736 usecs = 13480 KB/s
4301258760 bytes / 311318163 usecs = 13492 KB/s
4301258760 bytes / 311318902 usecs = 13492 KB/s
4320133128 bytes / 311973619 usecs = 13523 KB/s
4313317384 bytes / 311958613 usecs = 13502 KB/s
4298113032 bytes / 311724956 usecs = 13464 KB/s
4300210184 bytes / 311572917 usecs = 13478 KB/s
4302307336 bytes / 311805990 usecs = 13474 KB/s
4319084552 bytes / 312083624 usecs = 13515 KB/s
4308598792 bytes / 311996954 usecs = 13486 KB/s
4302831624 bytes / 312144884 usecs = 13461 KB/s
4308598792 bytes / 312086155 usecs = 13482 KB/s
4300210184 bytes / 305597416 usecs = 13741 KB/s
4300210184 bytes / 305608477 usecs = 13741 KB/s
4320133128 bytes / 312281002 usecs = 13509 KB/s
4320133128 bytes / 312338862 usecs = 13507 KB/s
4298113032 bytes / 312106870 usecs = 13448 KB/s
4300210184 bytes / 305713635 usecs = 13736 KB/s
4327473160 bytes / 309297356 usecs = 13663 KB/s
4327473160 bytes / 310787963 usecs = 13597 KB/s
4300210184 bytes / 305758165 usecs = 13734 KB/s
4320657416 bytes / 312393713 usecs = 13506 KB/s
4299685896 bytes / 311255545 usecs = 13490 KB/s
4297064456 bytes / 311255653 usecs = 13482 KB/s
4302831624 bytes / 312458882 usecs = 13448 KB/s
4301258760 bytes / 311838348 usecs = 13469 KB/s
4300210184 bytes / 305822090 usecs = 13731 KB/s
4294967304 bytes / 306984721 usecs = 13662 KB/s
4294967304 bytes / 305895803 usecs = 13711 KB/s
4320133128 bytes / 312522224 usecs = 13499 KB/s
4297588744 bytes / 312471577 usecs = 13431 KB/s
4300210184 bytes / 305872854 usecs = 13729 KB/s
4294967304 bytes / 301328578 usecs = 13919 KB/s
4298113032 bytes / 311958794 usecs = 13454 KB/s
4300210184 bytes / 305930151 usecs = 13726 KB/s
4294967304 bytes / 306047723 usecs = 13704 KB/s
4300210184 bytes / 306033791 usecs = 13722 KB/s
4300210184 bytes / 306074624 usecs = 13720 KB/s
4308074504 bytes / 312107312 usecs = 13479 KB/s
4299685896 bytes / 311556577 usecs = 13477 KB/s
4300210184 bytes / 306089430 usecs = 13719 KB/s
4300210184 bytes / 306090488 usecs = 13719 KB/s
4294967304 bytes / 307232296 usecs = 13651 KB/s
4294967304 bytes / 307240734 usecs = 13651 KB/s
4297588744 bytes / 312752872 usecs = 13419 KB/s
4299685896 bytes / 311602923 usecs = 13475 KB/s
4309123080 bytes / 312799039 usecs = 13453 KB/s
4299685896 bytes / 311628252 usecs = 13474 KB/s
4318035976 bytes / 312629246 usecs = 13488 KB/s
4302831624 bytes / 312833390 usecs = 13432 KB/s
4299685896 bytes / 311653776 usecs = 13473 KB/s
4312793096 bytes / 312802408 usecs = 13464 KB/s
4296540168 bytes / 311637152 usecs = 13463 KB/s
4300210184 bytes / 306203331 usecs = 13714 KB/s
4295491592 bytes / 311316456 usecs = 13474 KB/s
4300210184 bytes / 306238389 usecs = 13712 KB/s
4301258760 bytes / 311990379 usecs = 13463 KB/s
4302831624 bytes / 312941976 usecs = 13427 KB/s
4312793096 bytes / 312943753 usecs = 13458 KB/s
4312793096 bytes / 312946275 usecs = 13458 KB/s
4295491592 bytes / 311815141 usecs = 13452 KB/s
4295491592 bytes / 310952605 usecs = 13490 KB/s
4303355912 bytes / 312618545 usecs = 13442 KB/s
4312793096 bytes / 313049966 usecs = 13453 KB/s
4324327432 bytes / 313103252 usecs = 13487 KB/s
4300210184 bytes / 306482673 usecs = 13701 KB/s
4299685896 bytes / 311991438 usecs = 13458 KB/s
4301258760 bytes / 313015679 usecs = 13419 KB/s
4299685896 bytes / 312012462 usecs = 13457 KB/s
4324327432 bytes / 313182618 usecs = 13484 KB/s
4301258760 bytes / 312277914 usecs = 13450 KB/s
4303355912 bytes / 312757122 usecs = 13436 KB/s
4296540168 bytes / 310707869 usecs = 13504 KB/s
4319608840 bytes / 313299481 usecs = 13464 KB/s
4301258760 bytes / 312314614 usecs = 13449 KB/s
4312793096 bytes / 313241122 usecs = 13445 KB/s
4295491592 bytes / 312865347 usecs = 13407 KB/s
4303355912 bytes / 312881143 usecs = 13431 KB/s
4296540168 bytes / 312743469 usecs = 13416 KB/s
4303355912 bytes / 312918128 usecs = 13430 KB/s
4294967304 bytes / 307851890 usecs = 13624 KB/s
4312793096 bytes / 313404527 usecs = 13438 KB/s
4297064456 bytes / 313339958 usecs = 13392 KB/s
4295491592 bytes / 310015524 usecs = 13530 KB/s
4302307336 bytes / 312332649 usecs = 13451 KB/s
4302307336 bytes / 312394876 usecs = 13449 KB/s
4298637320 bytes / 310056857 usecs = 13539 KB/s
4303880200 bytes / 313698912 usecs = 13398 KB/s
4300210184 bytes / 306982014 usecs = 13679 KB/s
4322230280 bytes / 313670825 usecs = 13456 KB/s
4298113032 bytes / 313043428 usecs = 13408 KB/s
4312793096 bytes / 313675242 usecs = 13426 KB/s
4337958920 bytes / 313304079 usecs = 13521 KB/s
4295491592 bytes / 312267270 usecs = 13433 KB/s
4296540168 bytes / 313259119 usecs = 13394 KB/s
4308598792 bytes / 313951080 usecs = 13402 KB/s
4298113032 bytes / 313458672 usecs = 13390 KB/s
4298113032 bytes / 313495446 usecs = 13388 KB/s
4298113032 bytes / 313527617 usecs = 13387 KB/s
4303355912 bytes / 313498568 usecs = 13405 KB/s
4294967304 bytes / 302744373 usecs = 13854 KB/s
4297588744 bytes / 311949612 usecs = 13453 KB/s
4294967304 bytes / 307406412 usecs = 13644 KB/s
4295491592 bytes / 312818303 usecs = 13409 KB/s
4312793096 bytes / 314030669 usecs = 13411 KB/s
4298113032 bytes / 313663624 usecs = 13381 KB/s
4295491592 bytes / 312932815 usecs = 13404 KB/s
4297064456 bytes / 302678463 usecs = 13864 KB/s
4295491592 bytes / 310617611 usecs = 13504 KB/s
4297064456 bytes / 302684946 usecs = 13863 KB/s
4297064456 bytes / 302710216 usecs = 13862 KB/s
4294967304 bytes / 309930205 usecs = 13533 KB/s
4303355912 bytes / 313006709 usecs = 13426 KB/s
4294967304 bytes / 308710382 usecs = 13586 KB/s
4297064456 bytes / 302847513 usecs = 13856 KB/s
4298113032 bytes / 313771981 usecs = 13377 KB/s
4312268808 bytes / 314420587 usecs = 13393 KB/s
4298113032 bytes / 313821716 usecs = 13375 KB/s
4295491592 bytes / 313860629 usecs = 13365 KB/s
4303355912 bytes / 314411347 usecs = 13366 KB/s
4302831624 bytes / 314502656 usecs = 13360 KB/s
4294967304 bytes / 309043408 usecs = 13571 KB/s
4297588744 bytes / 312555781 usecs = 13427 KB/s
4297064456 bytes / 303195774 usecs = 13840 KB/s
4314890248 bytes / 314625879 usecs = 13392 KB/s
4298113032 bytes / 314760897 usecs = 13335 KB/s
4312268808 bytes / 314683546 usecs = 13382 KB/s
4313841672 bytes / 314920029 usecs = 13377 KB/s
4297064456 bytes / 303402984 usecs = 13830 KB/s
4295491592 bytes / 313773388 usecs = 13368 KB/s
4297064456 bytes / 303510203 usecs = 13826 KB/s
4313841672 bytes / 315070537 usecs = 13370 KB/s
4294967304 bytes / 310762412 usecs = 13496 KB/s
4313841672 bytes / 315112871 usecs = 13368 KB/s
4313841672 bytes / 315122512 usecs = 13368 KB/s
4313841672 bytes / 315134550 usecs = 13368 KB/s
4298113032 bytes / 314447381 usecs = 13348 KB/s
4298113032 bytes / 315085007 usecs = 13321 KB/s
4298113032 bytes / 315088644 usecs = 13321 KB/s
4313841672 bytes / 315208809 usecs = 13364 KB/s
4313841672 bytes / 315226870 usecs = 13364 KB/s
4295491592 bytes / 313631790 usecs = 13374 KB/s
4301783048 bytes / 314262489 usecs = 13367 KB/s
4313841672 bytes / 315345921 usecs = 13359 KB/s
4294967304 bytes / 308682274 usecs = 13587 KB/s
4298113032 bytes / 315311097 usecs = 13311 KB/s
4321181704 bytes / 315376305 usecs = 13380 KB/s
4300210184 bytes / 314586828 usecs = 13349 KB/s
4299161608 bytes / 313392785 usecs = 13396 KB/s
4313841672 bytes / 315660780 usecs = 13345 KB/s
4310695944 bytes / 315563797 usecs = 13340 KB/s
4335337480 bytes / 315206302 usecs = 13431 KB/s
4313841672 bytes / 315760473 usecs = 13341 KB/s
4297064456 bytes / 315579707 usecs = 13297 KB/s
4299685896 bytes / 315602182 usecs = 13304 KB/s
4299161608 bytes / 315699148 usecs = 13298 KB/s
4298113032 bytes / 313450382 usecs = 13390 KB/s
4307550216 bytes / 315938202 usecs = 13314 KB/s
4312268808 bytes / 315881822 usecs = 13331 KB/s
4300210184 bytes / 315101528 usecs = 13327 KB/s
4299685896 bytes / 315818800 usecs = 13295 KB/s
4298113032 bytes / 313581891 usecs = 13385 KB/s
4295491592 bytes / 315331217 usecs = 13302 KB/s
4313841672 bytes / 316051108 usecs = 13329 KB/s
4299685896 bytes / 315865998 usecs = 13293 KB/s
4298113032 bytes / 313624749 usecs = 13383 KB/s
4307550216 bytes / 316067945 usecs = 13309 KB/s
4297064456 bytes / 316017821 usecs = 13278 KB/s
4318560264 bytes / 316192986 usecs = 13337 KB/s
4299161608 bytes / 316239362 usecs = 13276 KB/s
4297064456 bytes / 300127291 usecs = 13981 KB/s
4299161608 bytes / 316299624 usecs = 13273 KB/s
4295491592 bytes / 300179831 usecs = 13974 KB/s
4299685896 bytes / 316233076 usecs = 13277 KB/s
4295491592 bytes / 312838735 usecs = 13408 KB/s
4295491592 bytes / 316059786 usecs = 13272 KB/s
4313841672 bytes / 316552193 usecs = 13308 KB/s
4295491592 bytes / 316096842 usecs = 13270 KB/s
4295491592 bytes / 315910711 usecs = 13278 KB/s
4300210184 bytes / 315769703 usecs = 13299 KB/s
4295491592 bytes / 316321078 usecs = 13261 KB/s
4322230280 bytes / 316493650 usecs = 13336 KB/s
4295491592 bytes / 316268769 usecs = 13263 KB/s
4296540168 bytes / 305434597 usecs = 13737 KB/s
4296540168 bytes / 310410553 usecs = 13517 KB/s
4295491592 bytes / 315866276 usecs = 13280 KB/s
4298637320 bytes / 310469923 usecs = 13521 KB/s
4297064456 bytes / 314611857 usecs = 13338 KB/s
4294967304 bytes / 301204591 usecs = 13925 KB/s
4315414536 bytes / 317204904 usecs = 13285 KB/s
4300734472 bytes / 315655316 usecs = 13305 KB/s
4307025928 bytes / 317026082 usecs = 13267 KB/s
4296015880 bytes / 315306685 usecs = 13305 KB/s
4295491592 bytes / 317089584 usecs = 13229 KB/s
4294967304 bytes / 301357862 usecs = 13918 KB/s
4296540168 bytes / 311872257 usecs = 13453 KB/s
4297064456 bytes / 301248776 usecs = 13929 KB/s
4294967304 bytes / 300492289 usecs = 13958 KB/s
4294967304 bytes / 300340250 usecs = 13965 KB/s
4298113032 bytes / 315600093 usecs = 13299 KB/s
4297064456 bytes / 300807613 usecs = 13950 KB/s
4297064456 bytes / 300811983 usecs = 13950 KB/s
4301783048 bytes / 317449163 usecs = 13233 KB/s
4297064456 bytes / 315260036 usecs = 13310 KB/s
4295491592 bytes / 316616790 usecs = 13248 KB/s
4296540168 bytes / 317654507 usecs = 13208 KB/s
4299685896 bytes / 317656178 usecs = 13218 KB/s
4295491592 bytes / 312396427 usecs = 13427 KB/s
4297064456 bytes / 301147123 usecs = 13934 KB/s
4298113032 bytes / 316102392 usecs = 13278 KB/s
4304404488 bytes / 317982002 usecs = 13219 KB/s
4299685896 bytes / 317876923 usecs = 13209 KB/s
4302307336 bytes / 317660072 usecs = 13226 KB/s
4299161608 bytes / 315805829 usecs = 13294 KB/s
4295491592 bytes / 306760344 usecs = 13674 KB/s
4296540168 bytes / 317990084 usecs = 13194 KB/s
4299685896 bytes / 318008972 usecs = 13203 KB/s
4295491592 bytes / 301401075 usecs = 13917 KB/s
4307550216 bytes / 318165229 usecs = 13221 KB/s
4299685896 bytes / 318106460 usecs = 13199 KB/s
4299685896 bytes / 317445820 usecs = 13227 KB/s
4296540168 bytes / 318215469 usecs = 13185 KB/s
4299685896 bytes / 318237724 usecs = 13194 KB/s
4298113032 bytes / 318482222 usecs = 13179 KB/s
4299685896 bytes / 317627530 usecs = 13219 KB/s
4294967304 bytes / 301574626 usecs = 13908 KB/s
4295491592 bytes / 317476969 usecs = 13212 KB/s
4299161608 bytes / 315135498 usecs = 13322 KB/s
4299161608 bytes / 315148852 usecs = 13321 KB/s
4299685896 bytes / 318437448 usecs = 13185 KB/s
4299161608 bytes / 315153634 usecs = 13321 KB/s
4295491592 bytes / 317512409 usecs = 13211 KB/s
4299685896 bytes / 317816887 usecs = 13211 KB/s
4299161608 bytes / 315272835 usecs = 13316 KB/s
4296015880 bytes / 315289479 usecs = 13306 KB/s
4295491592 bytes / 307375901 usecs = 13647 KB/s
4298113032 bytes / 316825690 usecs = 13248 KB/s
4296540168 bytes / 315382549 usecs = 13303 KB/s
4296540168 bytes / 316465087 usecs = 13258 KB/s
4299685896 bytes / 318079698 usecs = 13200 KB/s
4299161608 bytes / 315490905 usecs = 13307 KB/s
4298113032 bytes / 316977240 usecs = 13241 KB/s
4295491592 bytes / 313527563 usecs = 13379 KB/s
4295491592 bytes / 312427520 usecs = 13426 KB/s
4295491592 bytes / 302269718 usecs = 13877 KB/s
4294967304 bytes / 302416031 usecs = 13869 KB/s
4299161608 bytes / 319091837 usecs = 13157 KB/s
4296540168 bytes / 316724973 usecs = 13247 KB/s
4298637320 bytes / 319029272 usecs = 13158 KB/s
4296540168 bytes / 312581868 usecs = 13423 KB/s
4296540168 bytes / 312357790 usecs = 13432 KB/s
4295491592 bytes / 317819683 usecs = 13198 KB/s
4298637320 bytes / 319126473 usecs = 13154 KB/s
4294967304 bytes / 312569749 usecs = 13418 KB/s
4294967304 bytes / 303448076 usecs = 13822 KB/s
4298637320 bytes / 319191739 usecs = 13151 KB/s
4298637320 bytes / 319370224 usecs = 13144 KB/s
4294967304 bytes / 303454695 usecs = 13821 KB/s
4298637320 bytes / 319450039 usecs = 13140 KB/s
4327997448 bytes / 319723006 usecs = 13219 KB/s
4313841672 bytes / 319770704 usecs = 13174 KB/s
4313841672 bytes / 319797790 usecs = 13173 KB/s
4303355912 bytes / 319869265 usecs = 13138 KB/s
4299685896 bytes / 319213657 usecs = 13153 KB/s
4299685896 bytes / 319605635 usecs = 13137 KB/s
4295491592 bytes / 302990388 usecs = 13844 KB/s
4294967304 bytes / 302043979 usecs = 13886 KB/s
4295491592 bytes / 319784091 usecs = 13117 KB/s
4344250376 bytes / 319678922 usecs = 13270 KB/s
4311744520 bytes / 319952713 usecs = 13160 KB/s
4313841672 bytes / 320146816 usecs = 13158 KB/s
4313841672 bytes / 320155821 usecs = 13158 KB/s
4296540168 bytes / 303337447 usecs = 13832 KB/s
4294967304 bytes / 303154055 usecs = 13835 KB/s
4297064456 bytes / 320042325 usecs = 13111 KB/s
4313841672 bytes / 320193743 usecs = 13156 KB/s
4297588744 bytes / 317663417 usecs = 13211 KB/s
4294967304 bytes / 314658533 usecs = 13329 KB/s
4313841672 bytes / 320245930 usecs = 13154 KB/s
4297588744 bytes / 317738087 usecs = 13208 KB/s
4313841672 bytes / 320318566 usecs = 13151 KB/s
4296540168 bytes / 316585525 usecs = 13253 KB/s
4299161608 bytes / 315624214 usecs = 13301 KB/s
4313841672 bytes / 320365497 usecs = 13149 KB/s
4312268808 bytes / 320350893 usecs = 13145 KB/s
4312268808 bytes / 320375941 usecs = 13144 KB/s
4312268808 bytes / 320386434 usecs = 13144 KB/s
4312268808 bytes / 320429511 usecs = 13142 KB/s
4313841672 bytes / 320470212 usecs = 13145 KB/s
4309123080 bytes / 320490306 usecs = 13130 KB/s
4294967304 bytes / 302007997 usecs = 13888 KB/s
4313841672 bytes / 320574880 usecs = 13141 KB/s
4294967304 bytes / 304599825 usecs = 13769 KB/s
4294967304 bytes / 304608595 usecs = 13769 KB/s
4294967304 bytes / 301323661 usecs = 13919 KB/s
4295491592 bytes / 304629088 usecs = 13770 KB/s
4303880200 bytes / 319619168 usecs = 13150 KB/s
4303880200 bytes / 319637627 usecs = 13149 KB/s
4313841672 bytes / 320880766 usecs = 13128 KB/s
4297588744 bytes / 318356873 usecs = 13182 KB/s
4295491592 bytes / 319747131 usecs = 13119 KB/s
4294967304 bytes / 301602177 usecs = 13906 KB/s
4298113032 bytes / 321012208 usecs = 13075 KB/s
4295491592 bytes / 320611307 usecs = 13083 KB/s
4297064456 bytes / 319495674 usecs = 13134 KB/s
4295491592 bytes / 320887027 usecs = 13072 KB/s
4294967304 bytes / 303298472 usecs = 13828 KB/s
4298113032 bytes / 321225106 usecs = 13066 KB/s
4303880200 bytes / 320029425 usecs = 13133 KB/s
4294967304 bytes / 304488012 usecs = 13774 KB/s
4294967304 bytes / 304313211 usecs = 13782 KB/s
4295491592 bytes / 314672558 usecs = 13330 KB/s
4298113032 bytes / 320983552 usecs = 13076 KB/s
4303880200 bytes / 320191121 usecs = 13126 KB/s
4303880200 bytes / 320199304 usecs = 13126 KB/s
4298113032 bytes / 305252319 usecs = 13750 KB/s
4298113032 bytes / 305270823 usecs = 13749 KB/s
4297064456 bytes / 319832801 usecs = 13120 KB/s
4298113032 bytes / 305281616 usecs = 13749 KB/s
4297064456 bytes / 319847338 usecs = 13119 KB/s
4308598792 bytes / 321423784 usecs = 13090 KB/s
4298113032 bytes / 305398716 usecs = 13743 KB/s
4294967304 bytes / 316037332 usecs = 13271 KB/s
4296015880 bytes / 321151292 usecs = 13063 KB/s
4294967304 bytes / 306785880 usecs = 13671 KB/s
4294967304 bytes / 306789149 usecs = 13671 KB/s
4308598792 bytes / 321188476 usecs = 13100 KB/s
4296540168 bytes / 304739439 usecs = 13768 KB/s
4298113032 bytes / 305487686 usecs = 13739 KB/s
4297064456 bytes / 319710281 usecs = 13125 KB/s
4297064456 bytes / 316223295 usecs = 13270 KB/s
4298113032 bytes / 305558768 usecs = 13736 KB/s
4296540168 bytes / 304831352 usecs = 13764 KB/s
4297064456 bytes / 319812122 usecs = 13121 KB/s
4294967304 bytes / 302969992 usecs = 13843 KB/s
4295491592 bytes / 320215404 usecs = 13099 KB/s
4296015880 bytes / 305795988 usecs = 13719 KB/s
4296540168 bytes / 304909168 usecs = 13760 KB/s
4298113032 bytes / 305638416 usecs = 13733 KB/s
4308598792 bytes / 321383571 usecs = 13092 KB/s
4298113032 bytes / 305656746 usecs = 13732 KB/s
4304404488 bytes / 321879748 usecs = 13059 KB/s
4301258760 bytes / 321634776 usecs = 13059 KB/s
4296540168 bytes / 320690295 usecs = 13083 KB/s
4294967304 bytes / 304755272 usecs = 13762 KB/s
4298113032 bytes / 305719774 usecs = 13729 KB/s
4296540168 bytes / 320695180 usecs = 13083 KB/s
4298113032 bytes / 305807179 usecs = 13725 KB/s
4299685896 bytes / 321951611 usecs = 13042 KB/s
4294967304 bytes / 302579408 usecs = 13861 KB/s
4299685896 bytes / 321976423 usecs = 13041 KB/s
4298113032 bytes / 305852545 usecs = 13723 KB/s
4299685896 bytes / 322007578 usecs = 13039 KB/s
4296540168 bytes / 305181278 usecs = 13748 KB/s
4296540168 bytes / 305189521 usecs = 13748 KB/s
4294967304 bytes / 305333373 usecs = 13736 KB/s
4297588744 bytes / 319997620 usecs = 13115 KB/s
4294967304 bytes / 305356416 usecs = 13735 KB/s
4295491592 bytes / 317918283 usecs = 13194 KB/s
4326424584 bytes / 321521393 usecs = 13140 KB/s
4294967304 bytes / 304351340 usecs = 13781 KB/s
4296015880 bytes / 305437599 usecs = 13735 KB/s
4295491592 bytes / 321076567 usecs = 13064 KB/s
4296540168 bytes / 321108160 usecs = 13066 KB/s
4326424584 bytes / 321639134 usecs = 13135 KB/s
4297588744 bytes / 320237061 usecs = 13105 KB/s
4297064456 bytes / 320745124 usecs = 13083 KB/s
4305453064 bytes / 322075049 usecs = 13054 KB/s
4297064456 bytes / 320503351 usecs = 13093 KB/s
4297064456 bytes / 320556785 usecs = 13090 KB/s
4299685896 bytes / 322481804 usecs = 13020 KB/s
4295491592 bytes / 315900587 usecs = 13278 KB/s
4296015880 bytes / 321018139 usecs = 13068 KB/s
4326424584 bytes / 321917712 usecs = 13124 KB/s
4294967304 bytes / 305459757 usecs = 13731 KB/s
4295491592 bytes / 322212489 usecs = 13018 KB/s
4297588744 bytes / 320760186 usecs = 13084 KB/s
4295491592 bytes / 321786234 usecs = 13036 KB/s
4296015880 bytes / 321451082 usecs = 13051 KB/s
4294967304 bytes / 306063501 usecs = 13704 KB/s
4294967304 bytes / 306994991 usecs = 13662 KB/s
4294967304 bytes / 306948850 usecs = 13664 KB/s
4294967304 bytes / 306986067 usecs = 13662 KB/s
4296540168 bytes / 322029247 usecs = 13029 KB/s
4296540168 bytes / 321652991 usecs = 13044 KB/s
4312268808 bytes / 323222441 usecs = 13028 KB/s
4305453064 bytes / 323420883 usecs = 13000 KB/s
4294967304 bytes / 303999686 usecs = 13797 KB/s
4326424584 bytes / 322801639 usecs = 13088 KB/s
4299685896 bytes / 321994115 usecs = 13040 KB/s
4295491592 bytes / 305867362 usecs = 13714 KB/s
4298113032 bytes / 306019794 usecs = 13716 KB/s
4294967304 bytes / 304799077 usecs = 13760 KB/s
4294967304 bytes / 304828656 usecs = 13759 KB/s
4296540168 bytes / 322498305 usecs = 13010 KB/s
4294967304 bytes / 305845955 usecs = 13713 KB/s
4303880200 bytes / 323855564 usecs = 12978 KB/s
4297064456 bytes / 323215035 usecs = 12983 KB/s
4294967304 bytes / 306767747 usecs = 13672 KB/s
4322754568 bytes / 323846601 usecs = 13035 KB/s
4295491592 bytes / 322386698 usecs = 13011 KB/s
4294967304 bytes / 306935023 usecs = 13665 KB/s
4294967304 bytes / 307182223 usecs = 13654 KB/s
4294967304 bytes / 306180984 usecs = 13698 KB/s
4294967304 bytes / 318526542 usecs = 13167 KB/s
4295491592 bytes / 323895086 usecs = 12951 KB/s
4298113032 bytes / 322553797 usecs = 13012 KB/s
4322754568 bytes / 324087213 usecs = 13025 KB/s
4294967304 bytes / 306383251 usecs = 13689 KB/s
4298113032 bytes / 323084027 usecs = 12991 KB/s
4338483208 bytes / 323887862 usecs = 13081 KB/s
4302831624 bytes / 323107617 usecs = 13004 KB/s
4338483208 bytes / 323939756 usecs = 13078 KB/s
4338483208 bytes / 323985008 usecs = 13077 KB/s
4297064456 bytes / 324322065 usecs = 12938 KB/s
4294967304 bytes / 303087431 usecs = 13838 KB/s
4300734472 bytes / 324443803 usecs = 12945 KB/s
4294967304 bytes / 303108121 usecs = 13837 KB/s
4338483208 bytes / 324059260 usecs = 13074 KB/s
4294967304 bytes / 308287930 usecs = 13605 KB/s
4297064456 bytes / 324391552 usecs = 12936 KB/s
4295491592 bytes / 323367988 usecs = 12972 KB/s
4295491592 bytes / 323409638 usecs = 12970 KB/s
4338483208 bytes / 324217307 usecs = 13067 KB/s
4298113032 bytes / 323086929 usecs = 12991 KB/s
4295491592 bytes / 323239190 usecs = 12977 KB/s
4294967304 bytes / 302749515 usecs = 13854 KB/s
4296540168 bytes / 323642208 usecs = 12964 KB/s
4296540168 bytes / 320593982 usecs = 13087 KB/s
4296540168 bytes / 320635633 usecs = 13086 KB/s
4295491592 bytes / 323379450 usecs = 12971 KB/s
4297064456 bytes / 323337082 usecs = 12978 KB/s
4297064456 bytes / 324873554 usecs = 12916 KB/s
4296540168 bytes / 320789368 usecs = 13079 KB/s
4302831624 bytes / 323859888 usecs = 12974 KB/s
4319084552 bytes / 324693804 usecs = 12990 KB/s
4298113032 bytes / 323551968 usecs = 12972 KB/s
4296540168 bytes / 320897021 usecs = 13075 KB/s
4295491592 bytes / 324044548 usecs = 12945 KB/s
4294967304 bytes / 309243379 usecs = 13563 KB/s
4294967304 bytes / 309250363 usecs = 13562 KB/s
4300210184 bytes / 325117358 usecs = 12916 KB/s
4310695944 bytes / 325355859 usecs = 12938 KB/s
4297064456 bytes / 325284989 usecs = 12900 KB/s
4296540168 bytes / 321150336 usecs = 13065 KB/s
4294967304 bytes / 308468644 usecs = 13597 KB/s
4295491592 bytes / 324307451 usecs = 12934 KB/s
4296540168 bytes / 321312548 usecs = 13058 KB/s
4296540168 bytes / 321404126 usecs = 13054 KB/s
4299685896 bytes / 323314418 usecs = 12987 KB/s
4297064456 bytes / 324233328 usecs = 12942 KB/s
4297064456 bytes / 325680374 usecs = 12884 KB/s
4294967304 bytes / 304552151 usecs = 13772 KB/s
4297588744 bytes / 324418933 usecs = 12936 KB/s
4295491592 bytes / 309153145 usecs = 13568 KB/s
4295491592 bytes / 314897163 usecs = 13321 KB/s
4294967304 bytes / 309181852 usecs = 13565 KB/s
4300734472 bytes / 325714790 usecs = 12894 KB/s
4297064456 bytes / 326107471 usecs = 12868 KB/s
4300734472 bytes / 325824661 usecs = 12890 KB/s
4300734472 bytes / 325891967 usecs = 12887 KB/s
4295491592 bytes / 323949187 usecs = 12948 KB/s
4297588744 bytes / 324727046 usecs = 12924 KB/s
4299161608 bytes / 325672311 usecs = 12891 KB/s
4310695944 bytes / 326234028 usecs = 12903 KB/s
4336910344 bytes / 326236078 usecs = 12982 KB/s
4296015880 bytes / 326250940 usecs = 12859 KB/s
4313317384 bytes / 326273758 usecs = 12910 KB/s
4294967304 bytes / 302071035 usecs = 13885 KB/s
4299685896 bytes / 324224445 usecs = 12950 KB/s
4295491592 bytes / 325404473 usecs = 12891 KB/s
4295491592 bytes / 315390649 usecs = 13300 KB/s
4299685896 bytes / 324698352 usecs = 12931 KB/s
4297064456 bytes / 326666252 usecs = 12845 KB/s
4297064456 bytes / 326867189 usecs = 12838 KB/s
4294967304 bytes / 303437189 usecs = 13822 KB/s
4299161608 bytes / 326396617 usecs = 12862 KB/s
4294967304 bytes / 301004273 usecs = 13934 KB/s
4294967304 bytes / 312335441 usecs = 13428 KB/s
4294967304 bytes / 312335891 usecs = 13428 KB/s
4294967304 bytes / 311177652 usecs = 13478 KB/s
4298637320 bytes / 327374339 usecs = 12822 KB/s
4294967304 bytes / 309514462 usecs = 13551 KB/s
4298637320 bytes / 327467081 usecs = 12819 KB/s
4298637320 bytes / 327517105 usecs = 12817 KB/s
4330094600 bytes / 326721828 usecs = 12942 KB/s
4312268808 bytes / 327564016 usecs = 12856 KB/s
4295491592 bytes / 327354812 usecs = 12814 KB/s
4301783048 bytes / 327812081 usecs = 12815 KB/s
4299161608 bytes / 327222063 usecs = 12830 KB/s
4294967304 bytes / 305843327 usecs = 13713 KB/s
4295491592 bytes / 326744416 usecs = 12838 KB/s
4296015880 bytes / 321326379 usecs = 13056 KB/s
4295491592 bytes / 323767433 usecs = 12956 KB/s
4310695944 bytes / 327882565 usecs = 12838 KB/s
4295491592 bytes / 327797818 usecs = 12796 KB/s
4294967304 bytes / 311940746 usecs = 13445 KB/s
4294967304 bytes / 311972174 usecs = 13444 KB/s
4299685896 bytes / 326762309 usecs = 12850 KB/s
4295491592 bytes / 324216300 usecs = 12938 KB/s
4294967304 bytes / 304006611 usecs = 13796 KB/s
4296015880 bytes / 321871065 usecs = 13034 KB/s
4295491592 bytes / 326978409 usecs = 12829 KB/s
4296015880 bytes / 326615791 usecs = 12844 KB/s
4295491592 bytes / 326210327 usecs = 12859 KB/s
4294967304 bytes / 305044578 usecs = 13749 KB/s
4296015880 bytes / 326407083 usecs = 12853 KB/s
4294967304 bytes / 304328541 usecs = 13782 KB/s
4294967304 bytes / 312773639 usecs = 13410 KB/s
4294967304 bytes / 311926040 usecs = 13446 KB/s
4312793096 bytes / 328974290 usecs = 12802 KB/s
4294967304 bytes / 310201842 usecs = 13521 KB/s
4294967304 bytes / 310211428 usecs = 13520 KB/s
4304404488 bytes / 328606926 usecs = 12791 KB/s
4294967304 bytes / 303100791 usecs = 13837 KB/s
4294967304 bytes / 303124291 usecs = 13836 KB/s
4294967304 bytes / 312220827 usecs = 13433 KB/s
4294967304 bytes / 310449487 usecs = 13510 KB/s
4295491592 bytes / 325713060 usecs = 12878 KB/s
4294967304 bytes / 307895926 usecs = 13622 KB/s
4296015880 bytes / 312577943 usecs = 13421 KB/s
4296015880 bytes / 327108068 usecs = 12825 KB/s
4294967304 bytes / 308155821 usecs = 13610 KB/s
4296540168 bytes / 328919987 usecs = 12756 KB/s
4294967304 bytes / 311711598 usecs = 13455 KB/s
4297588744 bytes / 327983509 usecs = 12795 KB/s
4297064456 bytes / 329459866 usecs = 12737 KB/s
4295491592 bytes / 327255223 usecs = 12818 KB/s
4294967304 bytes / 313477005 usecs = 13379 KB/s
4314890248 bytes / 329538084 usecs = 12786 KB/s
4296015880 bytes / 327788844 usecs = 12798 KB/s
4330094600 bytes / 329798072 usecs = 12821 KB/s
4305453064 bytes / 329810663 usecs = 12748 KB/s
4294967304 bytes / 305275956 usecs = 13739 KB/s
4294967304 bytes / 307844588 usecs = 13624 KB/s
4296540168 bytes / 329276692 usecs = 12742 KB/s
4301258760 bytes / 329483771 usecs = 12748 KB/s
4311220232 bytes / 329506796 usecs = 12777 KB/s
4302307336 bytes / 329365547 usecs = 12756 KB/s
4299685896 bytes / 329889208 usecs = 12728 KB/s
4304404488 bytes / 329514782 usecs = 12756 KB/s
4297588744 bytes / 328654444 usecs = 12769 KB/s
4297588744 bytes / 328714311 usecs = 12767 KB/s
4318035976 bytes / 330233647 usecs = 12769 KB/s
4295491592 bytes / 329215209 usecs = 12741 KB/s
4294967304 bytes / 313305435 usecs = 13387 KB/s
4294967304 bytes / 313305767 usecs = 13387 KB/s
4295491592 bytes / 328899352 usecs = 12754 KB/s
4299685896 bytes / 330296495 usecs = 12712 KB/s
4297588744 bytes / 328964064 usecs = 12757 KB/s
4312793096 bytes / 330508699 usecs = 12743 KB/s
4295491592 bytes / 329383351 usecs = 12735 KB/s
4320657416 bytes / 330653691 usecs = 12760 KB/s
4295491592 bytes / 330517102 usecs = 12691 KB/s
4294967304 bytes / 315970920 usecs = 13274 KB/s
4300734472 bytes / 330105385 usecs = 12723 KB/s
4297064456 bytes / 325266388 usecs = 12901 KB/s
4320657416 bytes / 330628277 usecs = 12761 KB/s
4295491592 bytes / 329679367 usecs = 12723 KB/s
4316987400 bytes / 330451346 usecs = 12757 KB/s
4297064456 bytes / 325397183 usecs = 12896 KB/s
4297588744 bytes / 329358573 usecs = 12742 KB/s
4295491592 bytes / 328610708 usecs = 12765 KB/s
4298637320 bytes / 329815097 usecs = 12728 KB/s
4297064456 bytes / 325573873 usecs = 12889 KB/s
4297588744 bytes / 329511487 usecs = 12736 KB/s
4295491592 bytes / 328757127 usecs = 12759 KB/s
4317511688 bytes / 331098718 usecs = 12734 KB/s
4295491592 bytes / 314364633 usecs = 13343 KB/s
4314365960 bytes / 331079112 usecs = 12725 KB/s
4297588744 bytes / 329676241 usecs = 12730 KB/s
4294967304 bytes / 306797337 usecs = 13671 KB/s
4298637320 bytes / 330099214 usecs = 12717 KB/s
4297064456 bytes / 325828832 usecs = 12879 KB/s
4300734472 bytes / 330724556 usecs = 12699 KB/s
4294967304 bytes / 314481138 usecs = 13337 KB/s
4297064456 bytes / 331407064 usecs = 12662 KB/s
4324851720 bytes / 330619808 usecs = 12774 KB/s
4311220232 bytes / 331680533 usecs = 12693 KB/s
4300734472 bytes / 331673583 usecs = 12662 KB/s
4300210184 bytes / 331481997 usecs = 12668 KB/s
4296015880 bytes / 331570813 usecs = 12652 KB/s
4304928776 bytes / 331405893 usecs = 12685 KB/s
4318035976 bytes / 331460589 usecs = 12721 KB/s
4300734472 bytes / 331784175 usecs = 12658 KB/s
4318035976 bytes / 331479471 usecs = 12721 KB/s
4294967304 bytes / 308222881 usecs = 13608 KB/s
4295491592 bytes / 325196476 usecs = 12899 KB/s
4295491592 bytes / 315019107 usecs = 13316 KB/s
4296015880 bytes / 329394080 usecs = 12736 KB/s
4297064456 bytes / 326491250 usecs = 12852 KB/s
4296540168 bytes / 331476064 usecs = 12658 KB/s
4309647368 bytes / 331984072 usecs = 12677 KB/s
4300734472 bytes / 332227072 usecs = 12641 KB/s
4311220232 bytes / 331871411 usecs = 12686 KB/s
4302307336 bytes / 332192216 usecs = 12647 KB/s
4294967304 bytes / 306245717 usecs = 13695 KB/s
4309123080 bytes / 332436143 usecs = 12658 KB/s
4315414536 bytes / 329870191 usecs = 12775 KB/s
4297064456 bytes / 330340511 usecs = 12703 KB/s
4296015880 bytes / 315521891 usecs = 13296 KB/s
4298113032 bytes / 329579492 usecs = 12735 KB/s
4309647368 bytes / 332306051 usecs = 12664 KB/s
4302831624 bytes / 332464536 usecs = 12638 KB/s
4309647368 bytes / 332314438 usecs = 12664 KB/s
4301783048 bytes / 332481594 usecs = 12635 KB/s
4298113032 bytes / 332447573 usecs = 12625 KB/s
4296540168 bytes / 315779228 usecs = 13287 KB/s
4296540168 bytes / 315786013 usecs = 13286 KB/s
4327473160 bytes / 331617861 usecs = 12743 KB/s
4296540168 bytes / 315794332 usecs = 13286 KB/s
4294967304 bytes / 316466900 usecs = 13253 KB/s
4314365960 bytes / 332389465 usecs = 12675 KB/s
4298113032 bytes / 329719996 usecs = 12730 KB/s
4297064456 bytes / 330979035 usecs = 12678 KB/s
4298113032 bytes / 332573163 usecs = 12620 KB/s
4297064456 bytes / 332699858 usecs = 12613 KB/s
4296540168 bytes / 315984752 usecs = 13278 KB/s
4295491592 bytes / 321534297 usecs = 13046 KB/s
4312268808 bytes / 332780787 usecs = 12654 KB/s
4297064456 bytes / 331255998 usecs = 12668 KB/s
4294967304 bytes / 308424571 usecs = 13599 KB/s
4295491592 bytes / 332745414 usecs = 12606 KB/s
4298113032 bytes / 330135521 usecs = 12714 KB/s
4297064456 bytes / 326410345 usecs = 12856 KB/s
4297064456 bytes / 326410713 usecs = 12856 KB/s
4295491592 bytes / 321855175 usecs = 13033 KB/s
4297064456 bytes / 326477974 usecs = 12853 KB/s
4297064456 bytes / 326519924 usecs = 12851 KB/s
4296015880 bytes / 317323957 usecs = 13220 KB/s
4301783048 bytes / 333326380 usecs = 12603 KB/s
4297064456 bytes / 331759475 usecs = 12648 KB/s
4297064456 bytes / 331823298 usecs = 12646 KB/s
4294967304 bytes / 314665791 usecs = 13329 KB/s
4297064456 bytes / 331399743 usecs = 12662 KB/s
4294967304 bytes / 311459167 usecs = 13466 KB/s
4296540168 bytes / 316740629 usecs = 13246 KB/s
4298113032 bytes / 330791987 usecs = 12688 KB/s
4301258760 bytes / 331599818 usecs = 12667 KB/s
4296540168 bytes / 316869092 usecs = 13241 KB/s
4296015880 bytes / 316825319 usecs = 13241 KB/s
4296540168 bytes / 316969986 usecs = 13237 KB/s
4301258760 bytes / 331689218 usecs = 12663 KB/s
4310695944 bytes / 333571157 usecs = 12619 KB/s
4296540168 bytes / 316969058 usecs = 13237 KB/s
4304928776 bytes / 333136098 usecs = 12619 KB/s
4315938824 bytes / 333847335 usecs = 12624 KB/s
4294967304 bytes / 309246480 usecs = 13562 KB/s
4294967304 bytes / 309249322 usecs = 13562 KB/s
4295491592 bytes / 330324766 usecs = 12699 KB/s
4295491592 bytes / 322651145 usecs = 13001 KB/s
4294967304 bytes / 316747252 usecs = 13241 KB/s
4297064456 bytes / 327266175 usecs = 12822 KB/s
4295491592 bytes / 332678019 usecs = 12609 KB/s
4295491592 bytes / 332712564 usecs = 12607 KB/s
4294967304 bytes / 316941355 usecs = 13233 KB/s
4295491592 bytes / 331569299 usecs = 12651 KB/s
4294967304 bytes / 308055123 usecs = 13615 KB/s
4296015880 bytes / 330630846 usecs = 12688 KB/s
4294967304 bytes / 319486335 usecs = 13128 KB/s
4296540168 bytes / 317495740 usecs = 13215 KB/s
4311220232 bytes / 334211072 usecs = 12597 KB/s
4301258760 bytes / 332332142 usecs = 12639 KB/s
4296015880 bytes / 317515888 usecs = 13212 KB/s
4294967304 bytes / 309942334 usecs = 13532 KB/s
4295491592 bytes / 332076441 usecs = 12632 KB/s
4296540168 bytes / 332425371 usecs = 12621 KB/s
4328521736 bytes / 334677735 usecs = 12630 KB/s
4296015880 bytes / 332286954 usecs = 12625 KB/s
4296015880 bytes / 332312752 usecs = 12624 KB/s
4294967304 bytes / 315924287 usecs = 13276 KB/s
4311220232 bytes / 334556921 usecs = 12584 KB/s
4304404488 bytes / 334666033 usecs = 12560 KB/s
4295491592 bytes / 323344593 usecs = 12973 KB/s
4322754568 bytes / 332764414 usecs = 12685 KB/s
4299161608 bytes / 334412380 usecs = 12554 KB/s
4322754568 bytes / 333927719 usecs = 12641 KB/s
4297064456 bytes / 334815026 usecs = 12533 KB/s
4296540168 bytes / 332899328 usecs = 12603 KB/s
4295491592 bytes / 323545309 usecs = 12965 KB/s
4295491592 bytes / 332649452 usecs = 12610 KB/s
4294967304 bytes / 318024384 usecs = 13188 KB/s
4297588744 bytes / 334655312 usecs = 12540 KB/s
4294967304 bytes / 319011839 usecs = 13147 KB/s
4296015880 bytes / 331594210 usecs = 12651 KB/s
4297064456 bytes / 313929356 usecs = 13367 KB/s
4298637320 bytes / 328690558 usecs = 12771 KB/s
4296540168 bytes / 318636211 usecs = 13168 KB/s
4295491592 bytes / 334204881 usecs = 12551 KB/s
4298637320 bytes / 335341688 usecs = 12518 KB/s
4294967304 bytes / 311970802 usecs = 13444 KB/s
4298637320 bytes / 335478008 usecs = 12513 KB/s
4295491592 bytes / 334448525 usecs = 12542 KB/s
4295491592 bytes / 334167219 usecs = 12553 KB/s
4294967304 bytes / 320977499 usecs = 13067 KB/s
4295491592 bytes / 334610057 usecs = 12536 KB/s
4312268808 bytes / 335864043 usecs = 12538 KB/s
4304404488 bytes / 335236502 usecs = 12538 KB/s
4297064456 bytes / 335776198 usecs = 12497 KB/s
4296015880 bytes / 324543006 usecs = 12926 KB/s
4306501640 bytes / 335901128 usecs = 12520 KB/s
4313317384 bytes / 335952933 usecs = 12538 KB/s
4313317384 bytes / 335985477 usecs = 12536 KB/s
4313317384 bytes / 335985494 usecs = 12536 KB/s
4313317384 bytes / 335985939 usecs = 12536 KB/s
4297588744 bytes / 336001403 usecs = 12490 KB/s
4313317384 bytes / 336140400 usecs = 12531 KB/s
4296015880 bytes / 324778471 usecs = 12917 KB/s
4294967304 bytes / 314226042 usecs = 13348 KB/s
4300734472 bytes / 335067329 usecs = 12534 KB/s
4294967304 bytes / 319338869 usecs = 13134 KB/s
4295491592 bytes / 334782168 usecs = 12529 KB/s
4325376008 bytes / 335923677 usecs = 12574 KB/s
4313317384 bytes / 336293739 usecs = 12525 KB/s
4294967304 bytes / 310366583 usecs = 13514 KB/s
4300210184 bytes / 334464971 usecs = 12555 KB/s
4306501640 bytes / 336602181 usecs = 12494 KB/s
4295491592 bytes / 317214418 usecs = 13223 KB/s
4295491592 bytes / 330002412 usecs = 12711 KB/s
4297064456 bytes / 334557749 usecs = 12542 KB/s
4303355912 bytes / 336609294 usecs = 12484 KB/s
4296540168 bytes / 317366135 usecs = 13220 KB/s
4313317384 bytes / 336676803 usecs = 12511 KB/s
4297064456 bytes / 335877320 usecs = 12493 KB/s
4295491592 bytes / 333369227 usecs = 12583 KB/s
4296540168 bytes / 317503116 usecs = 13215 KB/s
4295491592 bytes / 325706724 usecs = 12879 KB/s
4296015880 bytes / 320954682 usecs = 13071 KB/s
4313317384 bytes / 336851313 usecs = 12504 KB/s
4294967304 bytes / 312394937 usecs = 13426 KB/s
4296540168 bytes / 317622270 usecs = 13210 KB/s
4299161608 bytes / 334988670 usecs = 12532 KB/s
4295491592 bytes / 334737059 usecs = 12531 KB/s
4308074504 bytes / 336460610 usecs = 12504 KB/s
4298113032 bytes / 336894175 usecs = 12459 KB/s
4307025928 bytes / 335548224 usecs = 12534 KB/s
4296540168 bytes / 335628592 usecs = 12501 KB/s
4313317384 bytes / 337137554 usecs = 12494 KB/s
4296540168 bytes / 317857623 usecs = 13200 KB/s
4300210184 bytes / 336870586 usecs = 12465 KB/s
4313317384 bytes / 337189719 usecs = 12492 KB/s
4295491592 bytes / 330644199 usecs = 12686 KB/s
4296015880 bytes / 321347600 usecs = 13055 KB/s
4296540168 bytes / 317957146 usecs = 13196 KB/s
4296015880 bytes / 326297961 usecs = 12857 KB/s
4296015880 bytes / 326108481 usecs = 12864 KB/s
4303880200 bytes / 335058719 usecs = 12544 KB/s
4296015880 bytes / 321676748 usecs = 13042 KB/s
4295491592 bytes / 332185119 usecs = 12627 KB/s
4295491592 bytes / 335391707 usecs = 12507 KB/s
4295491592 bytes / 335393117 usecs = 12507 KB/s
4294967304 bytes / 313300452 usecs = 13387 KB/s
4296015880 bytes / 326321246 usecs = 12856 KB/s
4295491592 bytes / 318418011 usecs = 13173 KB/s
4298637320 bytes / 337216304 usecs = 12448 KB/s
4298637320 bytes / 337319708 usecs = 12444 KB/s
4300210184 bytes / 337550179 usecs = 12440 KB/s
4309647368 bytes / 338093187 usecs = 12448 KB/s
4317511688 bytes / 338096181 usecs = 12470 KB/s
4296540168 bytes / 332611789 usecs = 12614 KB/s
4297588744 bytes / 321318730 usecs = 13061 KB/s
4298113032 bytes / 337914083 usecs = 12421 KB/s
4296015880 bytes / 326956760 usecs = 12831 KB/s
4295491592 bytes / 335870750 usecs = 12489 KB/s
4297588744 bytes / 321446196 usecs = 13056 KB/s
4294967304 bytes / 321332856 usecs = 13052 KB/s
4295491592 bytes / 337172923 usecs = 12441 KB/s
4310171656 bytes / 338267114 usecs = 12443 KB/s
4296015880 bytes / 322426803 usecs = 13011 KB/s
4296540168 bytes / 332887419 usecs = 12604 KB/s
4297064456 bytes / 337806610 usecs = 12422 KB/s
4296015880 bytes / 338359956 usecs = 12399 KB/s
4297064456 bytes / 337861856 usecs = 12420 KB/s
4296540168 bytes / 335642629 usecs = 12500 KB/s
4295491592 bytes / 333018957 usecs = 12596 KB/s
4297588744 bytes / 321746030 usecs = 13044 KB/s
4297588744 bytes / 321763153 usecs = 13043 KB/s
4296540168 bytes / 337440989 usecs = 12434 KB/s
4310171656 bytes / 338546333 usecs = 12433 KB/s
4295491592 bytes / 333295115 usecs = 12585 KB/s
4295491592 bytes / 336404602 usecs = 12469 KB/s
4296540168 bytes / 337298748 usecs = 12439 KB/s
4298113032 bytes / 338540446 usecs = 12398 KB/s
4294967304 bytes / 320485425 usecs = 13087 KB/s
4294967304 bytes / 322081215 usecs = 13022 KB/s
4296540168 bytes / 323067586 usecs = 12987 KB/s
4295491592 bytes / 333596881 usecs = 12574 KB/s
4295491592 bytes / 332444440 usecs = 12618 KB/s
4298637320 bytes / 339048833 usecs = 12381 KB/s
4298113032 bytes / 338776541 usecs = 12389 KB/s
4296540168 bytes / 323247127 usecs = 12980 KB/s
4294967304 bytes / 313204006 usecs = 13391 KB/s
4296015880 bytes / 328062067 usecs = 12788 KB/s
4296540168 bytes / 338121300 usecs = 12409 KB/s
4296015880 bytes / 336804173 usecs = 12456 KB/s
4298113032 bytes / 339077232 usecs = 12378 KB/s
4296540168 bytes / 323572275 usecs = 12967 KB/s
4295491592 bytes / 332902105 usecs = 12600 KB/s
4296015880 bytes / 334067622 usecs = 12558 KB/s
4295491592 bytes / 332945714 usecs = 12599 KB/s
4296540168 bytes / 334138334 usecs = 12557 KB/s
4294967304 bytes / 324868460 usecs = 12910 KB/s
4296015880 bytes / 334157330 usecs = 12554 KB/s
4294967304 bytes / 317683232 usecs = 13202 KB/s
4295491592 bytes / 338562392 usecs = 12390 KB/s
4295491592 bytes / 338625471 usecs = 12387 KB/s
4295491592 bytes / 321128992 usecs = 13062 KB/s
4296540168 bytes / 337070692 usecs = 12447 KB/s
4297064456 bytes / 328483717 usecs = 12774 KB/s
4299685896 bytes / 337108856 usecs = 12455 KB/s
4296015880 bytes / 337144343 usecs = 12443 KB/s
4295491592 bytes / 337666573 usecs = 12422 KB/s
4299685896 bytes / 337281568 usecs = 12449 KB/s
4295491592 bytes / 338648915 usecs = 12386 KB/s
4295491592 bytes / 321616889 usecs = 13042 KB/s
4295491592 bytes / 336881783 usecs = 12451 KB/s
4307025928 bytes / 338378967 usecs = 12430 KB/s
4297588744 bytes / 322484221 usecs = 13014 KB/s
4296540168 bytes / 324610686 usecs = 12925 KB/s
4296540168 bytes / 324861581 usecs = 12915 KB/s
4294967304 bytes / 316323378 usecs = 13259 KB/s
4295491592 bytes / 339787847 usecs = 12345 KB/s
4296540168 bytes / 324847213 usecs = 12916 KB/s
4295491592 bytes / 339512636 usecs = 12355 KB/s
4294967304 bytes / 315088980 usecs = 13311 KB/s
4295491592 bytes / 338803360 usecs = 12381 KB/s
4297588744 bytes / 339971316 usecs = 12344 KB/s
4295491592 bytes / 334534826 usecs = 12539 KB/s
4312793096 bytes / 339628968 usecs = 12400 KB/s
4295491592 bytes / 340237387 usecs = 12329 KB/s
4296015880 bytes / 341372015 usecs = 12289 KB/s
4296540168 bytes / 325374830 usecs = 12895 KB/s
4294967304 bytes / 324614600 usecs = 12920 KB/s
4327997448 bytes / 341323099 usecs = 12382 KB/s
4295491592 bytes / 340141361 usecs = 12332 KB/s
4296015880 bytes / 335101073 usecs = 12519 KB/s
4297064456 bytes / 330326395 usecs = 12703 KB/s
4295491592 bytes / 340352065 usecs = 12324 KB/s
4296015880 bytes / 337648901 usecs = 12425 KB/s
4294967304 bytes / 324790970 usecs = 12913 KB/s
4296540168 bytes / 325808024 usecs = 12878 KB/s
4296015880 bytes / 335517601 usecs = 12504 KB/s
4297588744 bytes / 340988266 usecs = 12307 KB/s
4296015880 bytes / 338025971 usecs = 12411 KB/s
4295491592 bytes / 341942910 usecs = 12267 KB/s
4307550216 bytes / 342431853 usecs = 12284 KB/s
4296015880 bytes / 336861107 usecs = 12454 KB/s
4295491592 bytes / 340919169 usecs = 12304 KB/s
4296015880 bytes / 337162845 usecs = 12443 KB/s
4296540168 bytes / 339847001 usecs = 12346 KB/s
4296015880 bytes / 338481565 usecs = 12394 KB/s
4297064456 bytes / 340697224 usecs = 12316 KB/s
4294967304 bytes / 320728068 usecs = 13077 KB/s
4295491592 bytes / 336203455 usecs = 12477 KB/s
4296015880 bytes / 337414596 usecs = 12433 KB/s
4296015880 bytes / 337462794 usecs = 12431 KB/s
4295491592 bytes / 341829602 usecs = 12271 KB/s
4294967304 bytes / 326122574 usecs = 12861 KB/s
4294967304 bytes / 328378041 usecs = 12772 KB/s
4295491592 bytes / 340839390 usecs = 12307 KB/s
4303355912 bytes / 343313558 usecs = 12240 KB/s
4296540168 bytes / 339755115 usecs = 12349 KB/s
4297064456 bytes / 321942882 usecs = 13034 KB/s
4296540168 bytes / 342862293 usecs = 12237 KB/s
4296015880 bytes / 341980640 usecs = 12267 KB/s
4321705992 bytes / 343118420 usecs = 12300 KB/s
4297064456 bytes / 322185088 usecs = 13024 KB/s
4295491592 bytes / 341211697 usecs = 12293 KB/s
4297588744 bytes / 343441796 usecs = 12220 KB/s
4296540168 bytes / 342133788 usecs = 12263 KB/s
4295491592 bytes / 341354156 usecs = 12288 KB/s
4295491592 bytes / 333777212 usecs = 12567 KB/s
4299161608 bytes / 343838371 usecs = 12210 KB/s
4299161608 bytes / 343838986 usecs = 12210 KB/s
4298113032 bytes / 343797226 usecs = 12208 KB/s
4295491592 bytes / 337460617 usecs = 12430 KB/s
4294967304 bytes / 327165484 usecs = 12820 KB/s
4295491592 bytes / 342682417 usecs = 12241 KB/s
4297064456 bytes / 343633346 usecs = 12211 KB/s
4296015880 bytes / 342760239 usecs = 12239 KB/s
4305453064 bytes / 344287399 usecs = 12212 KB/s
4295491592 bytes / 337736510 usecs = 12420 KB/s
4296540168 bytes / 342887249 usecs = 12236 KB/s
4304928776 bytes / 344282118 usecs = 12211 KB/s
4295491592 bytes / 342934989 usecs = 12232 KB/s
4295491592 bytes / 338025490 usecs = 12409 KB/s
4305453064 bytes / 344695459 usecs = 12197 KB/s
4314365960 bytes / 344158448 usecs = 12242 KB/s
4295491592 bytes / 333611790 usecs = 12573 KB/s
4295491592 bytes / 338325560 usecs = 12398 KB/s
4294967304 bytes / 320555753 usecs = 13084 KB/s
4295491592 bytes / 342914189 usecs = 12232 KB/s
4295491592 bytes / 343757957 usecs = 12202 KB/s
4297064456 bytes / 344687905 usecs = 12174 KB/s
4295491592 bytes / 344159011 usecs = 12188 KB/s
4295491592 bytes / 344193347 usecs = 12187 KB/s
4299685896 bytes / 345612783 usecs = 12149 KB/s
4302831624 bytes / 344535409 usecs = 12196 KB/s
4294967304 bytes / 323797327 usecs = 12953 KB/s
4296540168 bytes / 344683120 usecs = 12173 KB/s
4299161608 bytes / 343073376 usecs = 12237 KB/s
4296540168 bytes / 344887567 usecs = 12165 KB/s
4299161608 bytes / 344057245 usecs = 12202 KB/s
4295491592 bytes / 343835384 usecs = 12200 KB/s
4296015880 bytes / 329561173 usecs = 12730 KB/s
4294967304 bytes / 329382196 usecs = 12733 KB/s
4294967304 bytes / 331549262 usecs = 12650 KB/s
4302831624 bytes / 345178089 usecs = 12173 KB/s
4300210184 bytes / 346568233 usecs = 12117 KB/s
4295491592 bytes / 343343180 usecs = 12217 KB/s
4296015880 bytes / 328174168 usecs = 12783 KB/s
4296015880 bytes / 328192776 usecs = 12783 KB/s
4298113032 bytes / 325608776 usecs = 12890 KB/s
4298113032 bytes / 325634624 usecs = 12889 KB/s
4297064456 bytes / 345833127 usecs = 12134 KB/s
4298113032 bytes / 325691879 usecs = 12887 KB/s
4298113032 bytes / 325727000 usecs = 12886 KB/s
4295491592 bytes / 344735283 usecs = 12168 KB/s
4298113032 bytes / 325800838 usecs = 12883 KB/s
4295491592 bytes / 343643787 usecs = 12206 KB/s
4299161608 bytes / 345685332 usecs = 12145 KB/s
4298113032 bytes / 325890338 usecs = 12879 KB/s
4296015880 bytes / 328512240 usecs = 12770 KB/s
4308074504 bytes / 347221785 usecs = 12116 KB/s
4298113032 bytes / 325931093 usecs = 12878 KB/s
4296015880 bytes / 328575256 usecs = 12768 KB/s
4296015880 bytes / 330617844 usecs = 12689 KB/s
4298113032 bytes / 326040326 usecs = 12873 KB/s
4315414536 bytes / 346539906 usecs = 12161 KB/s
4295491592 bytes / 331506756 usecs = 12653 KB/s
4295491592 bytes / 346297422 usecs = 12113 KB/s
4296015880 bytes / 346890019 usecs = 12094 KB/s
4298637320 bytes / 345598815 usecs = 12146 KB/s
4296015880 bytes / 328794304 usecs = 12759 KB/s
4297588744 bytes / 347459083 usecs = 12078 KB/s
4295491592 bytes / 331831697 usecs = 12641 KB/s
4296015880 bytes / 345330619 usecs = 12148 KB/s
4298113032 bytes / 326488787 usecs = 12856 KB/s
4295491592 bytes / 331950180 usecs = 12636 KB/s
4296015880 bytes / 330188122 usecs = 12705 KB/s
4296015880 bytes / 341560281 usecs = 12282 KB/s
4295491592 bytes / 341519143 usecs = 12282 KB/s
4296015880 bytes / 344730469 usecs = 12169 KB/s
4298637320 bytes / 347089801 usecs = 12094 KB/s
4298637320 bytes / 346389313 usecs = 12118 KB/s
4296015880 bytes / 347125173 usecs = 12085 KB/s
4296015880 bytes / 341828198 usecs = 12273 KB/s
4295491592 bytes / 347271897 usecs = 12079 KB/s
4295491592 bytes / 347386964 usecs = 12075 KB/s
4296015880 bytes / 342032503 usecs = 12265 KB/s
4294967304 bytes / 331722543 usecs = 12644 KB/s
4295491592 bytes / 337278639 usecs = 12437 KB/s
4298637320 bytes / 347568722 usecs = 12077 KB/s
4295491592 bytes / 347664722 usecs = 12065 KB/s
4295491592 bytes / 346480312 usecs = 12106 KB/s
4294967304 bytes / 331859062 usecs = 12638 KB/s
4297064456 bytes / 346095823 usecs = 12124 KB/s
4295491592 bytes / 342307193 usecs = 12254 KB/s
4295491592 bytes / 332080773 usecs = 12631 KB/s
4295491592 bytes / 347960735 usecs = 12055 KB/s
4297064456 bytes / 346340638 usecs = 12116 KB/s
4295491592 bytes / 348114916 usecs = 12050 KB/s
4298113032 bytes / 348730515 usecs = 12036 KB/s
4294967304 bytes / 327379753 usecs = 12811 KB/s
4295491592 bytes / 338063215 usecs = 12408 KB/s
4295491592 bytes / 347472964 usecs = 12072 KB/s
4295491592 bytes / 338708854 usecs = 12384 KB/s
4298113032 bytes / 350105675 usecs = 11988 KB/s
4295491592 bytes / 347925780 usecs = 12056 KB/s
4334813192 bytes / 350053421 usecs = 12093 KB/s
4295491592 bytes / 348057351 usecs = 12052 KB/s
4302307336 bytes / 349987368 usecs = 12004 KB/s
4297064456 bytes / 344084110 usecs = 12195 KB/s
4295491592 bytes / 333902401 usecs = 12563 KB/s
4294967304 bytes / 333906582 usecs = 12561 KB/s
4295491592 bytes / 349748638 usecs = 11993 KB/s
4295491592 bytes / 348569965 usecs = 12034 KB/s
4295491592 bytes / 334074661 usecs = 12556 KB/s
4295491592 bytes / 334119342 usecs = 12554 KB/s
4295491592 bytes / 334121874 usecs = 12554 KB/s
4296015880 bytes / 350434547 usecs = 11971 KB/s
4295491592 bytes / 345646273 usecs = 12136 KB/s
4295491592 bytes / 345823181 usecs = 12129 KB/s
4295491592 bytes / 345839365 usecs = 12129 KB/s
4296540168 bytes / 333615491 usecs = 12576 KB/s
4295491592 bytes / 350301819 usecs = 11974 KB/s
4316987400 bytes / 351349027 usecs = 11998 KB/s
4296540168 bytes / 333724146 usecs = 12572 KB/s
4294967304 bytes / 327255550 usecs = 12816 KB/s
4294967304 bytes / 327255719 usecs = 12816 KB/s
4304404488 bytes / 350941376 usecs = 11977 KB/s
4296540168 bytes / 334147371 usecs = 12556 KB/s
4296540168 bytes / 351409137 usecs = 11940 KB/s
4315414536 bytes / 351986465 usecs = 11972 KB/s
4300734472 bytes / 352004166 usecs = 11931 KB/s
4296540168 bytes / 334289584 usecs = 12551 KB/s
4295491592 bytes / 349771631 usecs = 11993 KB/s
4315938824 bytes / 352078284 usecs = 11971 KB/s
4295491592 bytes / 335287629 usecs = 12511 KB/s
4295491592 bytes / 351816034 usecs = 11923 KB/s
4297588744 bytes / 352325512 usecs = 11911 KB/s
4295491592 bytes / 332954063 usecs = 12598 KB/s
4296540168 bytes / 334551417 usecs = 12541 KB/s
4295491592 bytes / 351230965 usecs = 11943 KB/s
4332191752 bytes / 351995610 usecs = 12019 KB/s
4295491592 bytes / 335599549 usecs = 12499 KB/s
4295491592 bytes / 335653260 usecs = 12497 KB/s
4296540168 bytes / 334838589 usecs = 12530 KB/s
4309123080 bytes / 353014464 usecs = 11920 KB/s
4294967304 bytes / 331046605 usecs = 12669 KB/s
4295491592 bytes / 350731263 usecs = 11960 KB/s
4295491592 bytes / 333710890 usecs = 12570 KB/s
4295491592 bytes / 336369765 usecs = 12470 KB/s
4302831624 bytes / 352995396 usecs = 11903 KB/s
4295491592 bytes / 333833205 usecs = 12565 KB/s
4295491592 bytes / 336397128 usecs = 12469 KB/s
4308074504 bytes / 353474532 usecs = 11902 KB/s
4295491592 bytes / 334088565 usecs = 12555 KB/s
4296540168 bytes / 347004180 usecs = 12091 KB/s
4294967304 bytes / 329214090 usecs = 12740 KB/s
4295491592 bytes / 334437459 usecs = 12542 KB/s
4295491592 bytes / 337097594 usecs = 12443 KB/s
4295491592 bytes / 347229405 usecs = 12080 KB/s
4312793096 bytes / 351322933 usecs = 11988 KB/s
4295491592 bytes / 348952178 usecs = 12021 KB/s
4320133128 bytes / 352378290 usecs = 11972 KB/s
4305977352 bytes / 353905716 usecs = 11881 KB/s
4295491592 bytes / 343177932 usecs = 12223 KB/s
4296540168 bytes / 354469826 usecs = 11836 KB/s
4294967304 bytes / 332878186 usecs = 12600 KB/s
4295491592 bytes / 348464676 usecs = 12037 KB/s
4295491592 bytes / 338420279 usecs = 12395 KB/s
4318035976 bytes / 355346985 usecs = 11866 KB/s
4295491592 bytes / 353084416 usecs = 11880 KB/s
4320133128 bytes / 353516264 usecs = 11934 KB/s
4295491592 bytes / 344201953 usecs = 12187 KB/s
4307025928 bytes / 355074834 usecs = 11845 KB/s
4295491592 bytes / 354566070 usecs = 11830 KB/s
4295491592 bytes / 336361742 usecs = 12471 KB/s
4295491592 bytes / 354636667 usecs = 11828 KB/s
4314890248 bytes / 355943823 usecs = 11838 KB/s
4295491592 bytes / 336746166 usecs = 12456 KB/s
4295491592 bytes / 353772485 usecs = 11857 KB/s
4295491592 bytes / 351927724 usecs = 11919 KB/s
4295491592 bytes / 350715656 usecs = 11960 KB/s
4295491592 bytes / 350765682 usecs = 11959 KB/s
4296015880 bytes / 349662089 usecs = 11998 KB/s
4321705992 bytes / 355673891 usecs = 11865 KB/s
4295491592 bytes / 350927402 usecs = 11953 KB/s
4295491592 bytes / 350948577 usecs = 11952 KB/s
4295491592 bytes / 352218134 usecs = 11909 KB/s
4295491592 bytes / 340550995 usecs = 12317 KB/s
4316987400 bytes / 355985743 usecs = 11842 KB/s
4294967304 bytes / 332202884 usecs = 12625 KB/s
4295491592 bytes / 345552594 usecs = 12139 KB/s
4295491592 bytes / 355895500 usecs = 11786 KB/s
4295491592 bytes / 355916181 usecs = 11785 KB/s
4314890248 bytes / 356366849 usecs = 11824 KB/s
4295491592 bytes / 350816532 usecs = 11957 KB/s
4295491592 bytes / 351982099 usecs = 11917 KB/s
4295491592 bytes / 346343052 usecs = 12111 KB/s
4296015880 bytes / 356103260 usecs = 11781 KB/s
4297064456 bytes / 357570657 usecs = 11735 KB/s
4295491592 bytes / 346534602 usecs = 12105 KB/s
4295491592 bytes / 355626607 usecs = 11795 KB/s
4295491592 bytes / 352674144 usecs = 11894 KB/s
4316987400 bytes / 357053660 usecs = 11807 KB/s
4297064456 bytes / 357538170 usecs = 11736 KB/s
4295491592 bytes / 333745732 usecs = 12568 KB/s
4295491592 bytes / 357203905 usecs = 11743 KB/s
4310171656 bytes / 358589798 usecs = 11738 KB/s
4299685896 bytes / 357981946 usecs = 11729 KB/s
4295491592 bytes / 334319836 usecs = 12547 KB/s
4296015880 bytes / 356332852 usecs = 11773 KB/s
4294967304 bytes / 336871993 usecs = 12450 KB/s
4295491592 bytes / 355624358 usecs = 11795 KB/s
4305453064 bytes / 358863014 usecs = 11716 KB/s
4298637320 bytes / 359123234 usecs = 11689 KB/s
4295491592 bytes / 355709161 usecs = 11792 KB/s
4296540168 bytes / 359094672 usecs = 11684 KB/s
4296015880 bytes / 357360844 usecs = 11739 KB/s
4295491592 bytes / 348082080 usecs = 12051 KB/s
4296540168 bytes / 359334470 usecs = 11676 KB/s
4299685896 bytes / 359407151 usecs = 11682 KB/s
4303880200 bytes / 359682595 usecs = 11685 KB/s
4296540168 bytes / 343725124 usecs = 12206 KB/s
4307550216 bytes / 359999503 usecs = 11684 KB/s
4295491592 bytes / 348916090 usecs = 12022 KB/s
4301783048 bytes / 359006057 usecs = 11701 KB/s
4295491592 bytes / 355977627 usecs = 11783 KB/s
4299161608 bytes / 359090424 usecs = 11691 KB/s
4298113032 bytes / 359654240 usecs = 11670 KB/s
4295491592 bytes / 349143272 usecs = 12014 KB/s
4296015880 bytes / 357573031 usecs = 11732 KB/s
4296540168 bytes / 344341433 usecs = 12185 KB/s
4295491592 bytes / 353907632 usecs = 11852 KB/s
4297064456 bytes / 360568417 usecs = 11638 KB/s
4294967304 bytes / 338571329 usecs = 12388 KB/s
4295491592 bytes / 337076371 usecs = 12444 KB/s
4295491592 bytes / 359651179 usecs = 11663 KB/s
4296540168 bytes / 344640684 usecs = 12174 KB/s
4296015880 bytes / 358780905 usecs = 11693 KB/s
4296540168 bytes / 344686867 usecs = 12172 KB/s
4295491592 bytes / 334977570 usecs = 12522 KB/s
4295491592 bytes / 356873219 usecs = 11754 KB/s
4295491592 bytes / 355697408 usecs = 11793 KB/s
4295491592 bytes / 335122429 usecs = 12517 KB/s
4295491592 bytes / 344304762 usecs = 12183 KB/s
4296540168 bytes / 349948521 usecs = 11989 KB/s
4295491592 bytes / 350244113 usecs = 11976 KB/s
4295491592 bytes / 360316762 usecs = 11642 KB/s
4299685896 bytes / 361339968 usecs = 11620 KB/s
4295491592 bytes / 344882259 usecs = 12163 KB/s
4295491592 bytes / 355411040 usecs = 11802 KB/s
4296540168 bytes / 355465512 usecs = 11803 KB/s
4295491592 bytes / 336109313 usecs = 12480 KB/s
4295491592 bytes / 343718547 usecs = 12204 KB/s
4296015880 bytes / 360020140 usecs = 11653 KB/s
4295491592 bytes / 360182570 usecs = 11646 KB/s
4295491592 bytes / 345719050 usecs = 12133 KB/s
4295491592 bytes / 356033673 usecs = 11782 KB/s
4295491592 bytes / 356054156 usecs = 11781 KB/s
4297064456 bytes / 356385004 usecs = 11774 KB/s
4297064456 bytes / 356486282 usecs = 11771 KB/s
4294967304 bytes / 341100359 usecs = 12296 KB/s
4296015880 bytes / 362554489 usecs = 11571 KB/s
4301258760 bytes / 363324969 usecs = 11561 KB/s
4313841672 bytes / 363265150 usecs = 11596 KB/s
4295491592 bytes / 346814326 usecs = 12095 KB/s
4295491592 bytes / 347679403 usecs = 12065 KB/s
4295491592 bytes / 359577676 usecs = 11665 KB/s
4295491592 bytes / 359592661 usecs = 11665 KB/s
4295491592 bytes / 347928943 usecs = 12056 KB/s
4333764616 bytes / 361978905 usecs = 11691 KB/s
4307025928 bytes / 363531463 usecs = 11570 KB/s
4295491592 bytes / 359900292 usecs = 11655 KB/s
4295491592 bytes / 360660093 usecs = 11630 KB/s
4294967304 bytes / 342166155 usecs = 12258 KB/s
4304928776 bytes / 364129482 usecs = 11545 KB/s
4296015880 bytes / 363736234 usecs = 11533 KB/s
4295491592 bytes / 347636550 usecs = 12066 KB/s
4301258760 bytes / 363901864 usecs = 11542 KB/s
4324327432 bytes / 364433873 usecs = 11587 KB/s
4309647368 bytes / 364655043 usecs = 11541 KB/s
4295491592 bytes / 361107290 usecs = 11616 KB/s
4311220232 bytes / 364613737 usecs = 11546 KB/s
4295491592 bytes / 363625814 usecs = 11536 KB/s
4295491592 bytes / 359504419 usecs = 11668 KB/s
4296540168 bytes / 363432039 usecs = 11545 KB/s
4302831624 bytes / 365234051 usecs = 11504 KB/s
4297588744 bytes / 343887813 usecs = 12204 KB/s
4314890248 bytes / 364759937 usecs = 11552 KB/s
4320133128 bytes / 365337101 usecs = 11547 KB/s
4295491592 bytes / 349774241 usecs = 11992 KB/s
4296015880 bytes / 349697227 usecs = 11997 KB/s
4296015880 bytes / 349719067 usecs = 11996 KB/s
4296015880 bytes / 349793859 usecs = 11993 KB/s
4296015880 bytes / 346511729 usecs = 12107 KB/s
4324851720 bytes / 365668328 usecs = 11550 KB/s
4295491592 bytes / 360862539 usecs = 11624 KB/s
4310695944 bytes / 366297176 usecs = 11492 KB/s
4295491592 bytes / 354967915 usecs = 11817 KB/s
4294967304 bytes / 344462388 usecs = 12176 KB/s
4295491592 bytes / 365321003 usecs = 11482 KB/s
4295491592 bytes / 365342830 usecs = 11481 KB/s
4295491592 bytes / 361033977 usecs = 11618 KB/s
4313841672 bytes / 365006566 usecs = 11541 KB/s
4298637320 bytes / 366323888 usecs = 11459 KB/s
4309647368 bytes / 366745682 usecs = 11475 KB/s
4295491592 bytes / 363179576 usecs = 11550 KB/s
4344250376 bytes / 366487607 usecs = 11575 KB/s
4295491592 bytes / 349951039 usecs = 11986 KB/s
4298637320 bytes / 366543095 usecs = 11452 KB/s
4295491592 bytes / 361328145 usecs = 11609 KB/s
4295491592 bytes / 355680675 usecs = 11793 KB/s
4296015880 bytes / 361555925 usecs = 11603 KB/s
4295491592 bytes / 361525390 usecs = 11603 KB/s
4295491592 bytes / 350181379 usecs = 11978 KB/s
4296015880 bytes / 361600004 usecs = 11602 KB/s
4295491592 bytes / 360430102 usecs = 11638 KB/s
4295491592 bytes / 365910239 usecs = 11464 KB/s
4295491592 bytes / 350163327 usecs = 11979 KB/s
4295491592 bytes / 360597367 usecs = 11632 KB/s
4295491592 bytes / 350589277 usecs = 11965 KB/s
4295491592 bytes / 349561535 usecs = 12000 KB/s
4296015880 bytes / 364583338 usecs = 11507 KB/s
4323278856 bytes / 367483464 usecs = 11488 KB/s
4295491592 bytes / 350768120 usecs = 11958 KB/s
4294967304 bytes / 345516901 usecs = 12139 KB/s
4295491592 bytes / 350797857 usecs = 11957 KB/s
4296015880 bytes / 365559387 usecs = 11476 KB/s
4311744520 bytes / 365183532 usecs = 11530 KB/s
4295491592 bytes / 361094975 usecs = 11616 KB/s
4295491592 bytes / 356552104 usecs = 11764 KB/s
4318035976 bytes / 367972556 usecs = 11459 KB/s
4324327432 bytes / 367947488 usecs = 11477 KB/s
4295491592 bytes / 351998701 usecs = 11917 KB/s
4295491592 bytes / 350140956 usecs = 11980 KB/s
4295491592 bytes / 351029702 usecs = 11950 KB/s
4304928776 bytes / 368031106 usecs = 11423 KB/s
4296015880 bytes / 367614569 usecs = 11412 KB/s
4295491592 bytes / 351359137 usecs = 11938 KB/s
4295491592 bytes / 365883502 usecs = 11464 KB/s
4295491592 bytes / 367117441 usecs = 11426 KB/s
4296540168 bytes / 366351215 usecs = 11453 KB/s
4310695944 bytes / 368237040 usecs = 11431 KB/s
4296015880 bytes / 366565940 usecs = 11444 KB/s
4295491592 bytes / 351786933 usecs = 11924 KB/s
4295491592 bytes / 351812380 usecs = 11923 KB/s
4295491592 bytes / 349369224 usecs = 12006 KB/s
4309123080 bytes / 368625175 usecs = 11415 KB/s
4295491592 bytes / 351683932 usecs = 11927 KB/s
4295491592 bytes / 367768434 usecs = 11406 KB/s
4295491592 bytes / 352203109 usecs = 11910 KB/s
4294967304 bytes / 346963301 usecs = 12088 KB/s
4294967304 bytes / 347000201 usecs = 12087 KB/s
4295491592 bytes / 363577677 usecs = 11537 KB/s
4295491592 bytes / 352242096 usecs = 11908 KB/s
4297588744 bytes / 367584541 usecs = 11417 KB/s
4295491592 bytes / 349936924 usecs = 11987 KB/s
4300734472 bytes / 369393874 usecs = 11369 KB/s
4297064456 bytes / 367302424 usecs = 11424 KB/s
4295491592 bytes / 350054839 usecs = 11983 KB/s
4296015880 bytes / 364050845 usecs = 11524 KB/s
4309123080 bytes / 369498292 usecs = 11388 KB/s
4296015880 bytes / 367116274 usecs = 11427 KB/s
4295491592 bytes / 346084634 usecs = 12120 KB/s
4295491592 bytes / 350337681 usecs = 11973 KB/s
4295491592 bytes / 353045952 usecs = 11881 KB/s
4295491592 bytes / 363241834 usecs = 11548 KB/s
4295491592 bytes / 363214609 usecs = 11549 KB/s
4295491592 bytes / 346323845 usecs = 12112 KB/s
4300734472 bytes / 369941946 usecs = 11352 KB/s
4296015880 bytes / 369646125 usecs = 11349 KB/s
4295491592 bytes / 363478945 usecs = 11540 KB/s
4295491592 bytes / 368911464 usecs = 11370 KB/s
4295491592 bytes / 354074241 usecs = 11847 KB/s
4295491592 bytes / 358892363 usecs = 11688 KB/s
4295491592 bytes / 359137998 usecs = 11680 KB/s
4295491592 bytes / 364936925 usecs = 11494 KB/s
4295491592 bytes / 363798992 usecs = 11530 KB/s
4295491592 bytes / 363858066 usecs = 11528 KB/s
4295491592 bytes / 359016004 usecs = 11684 KB/s
4295491592 bytes / 359021371 usecs = 11684 KB/s
4296015880 bytes / 369863604 usecs = 11342 KB/s
4295491592 bytes / 353699031 usecs = 11859 KB/s
4295491592 bytes / 369438055 usecs = 11354 KB/s
4295491592 bytes / 353750483 usecs = 11858 KB/s
4296015880 bytes / 347108828 usecs = 12086 KB/s
4296015880 bytes / 347121680 usecs = 12086 KB/s
4295491592 bytes / 359493700 usecs = 11668 KB/s
4295491592 bytes / 359442036 usecs = 11670 KB/s
4295491592 bytes / 359452369 usecs = 11670 KB/s
4295491592 bytes / 367406780 usecs = 11417 KB/s
4295491592 bytes / 369842312 usecs = 11342 KB/s
4316987400 bytes / 370934133 usecs = 11365 KB/s
4295491592 bytes / 354307234 usecs = 11839 KB/s
4296015880 bytes / 347554115 usecs = 12071 KB/s
4306501640 bytes / 370261277 usecs = 11358 KB/s
4295491592 bytes / 354446461 usecs = 11834 KB/s
4295491592 bytes / 364679221 usecs = 11502 KB/s
4297064456 bytes / 371303886 usecs = 11301 KB/s
4295491592 bytes / 364702034 usecs = 11502 KB/s
4295491592 bytes / 365954773 usecs = 11462 KB/s
4295491592 bytes / 360013810 usecs = 11651 KB/s
4295491592 bytes / 354665992 usecs = 11827 KB/s
4295491592 bytes / 360340967 usecs = 11641 KB/s
4298637320 bytes / 370113578 usecs = 11342 KB/s
4298637320 bytes / 371422005 usecs = 11302 KB/s
4295491592 bytes / 366278638 usecs = 11452 KB/s
4295491592 bytes / 354851773 usecs = 11821 KB/s
4295491592 bytes / 366298398 usecs = 11451 KB/s
4295491592 bytes / 355069975 usecs = 11814 KB/s
4295491592 bytes / 360811642 usecs = 11626 KB/s
4295491592 bytes / 356110452 usecs = 11779 KB/s
4295491592 bytes / 354245447 usecs = 11841 KB/s
4295491592 bytes / 355297656 usecs = 11806 KB/s
4295491592 bytes / 355436332 usecs = 11801 KB/s
4295491592 bytes / 356301569 usecs = 11773 KB/s
4316463112 bytes / 372145523 usecs = 11327 KB/s
4295491592 bytes / 368771508 usecs = 11375 KB/s
4310695944 bytes / 372311099 usecs = 11306 KB/s
4295491592 bytes / 371224078 usecs = 11299 KB/s
4296015880 bytes / 371848730 usecs = 11282 KB/s
4295491592 bytes / 356608074 usecs = 11763 KB/s
4299685896 bytes / 371401441 usecs = 11305 KB/s
4295491592 bytes / 355828609 usecs = 11788 KB/s
4337958920 bytes / 371884422 usecs = 11391 KB/s
4295491592 bytes / 369233875 usecs = 11360 KB/s
4296015880 bytes / 370016240 usecs = 11338 KB/s
4299685896 bytes / 370521731 usecs = 11332 KB/s
4298637320 bytes / 370815232 usecs = 11320 KB/s
4295491592 bytes / 355137319 usecs = 11811 KB/s
4296015880 bytes / 372420432 usecs = 11265 KB/s
4296540168 bytes / 372685926 usecs = 11258 KB/s
4295491592 bytes / 367613012 usecs = 11410 KB/s
4296015880 bytes / 371033132 usecs = 11307 KB/s
4295491592 bytes / 366534316 usecs = 11444 KB/s
4295491592 bytes / 366581611 usecs = 11443 KB/s
4296015880 bytes / 356116118 usecs = 11780 KB/s
4299685896 bytes / 366593553 usecs = 11453 KB/s
4296015880 bytes / 356186271 usecs = 11778 KB/s
4298113032 bytes / 370614648 usecs = 11325 KB/s
4295491592 bytes / 368007861 usecs = 11398 KB/s
4295491592 bytes / 356683640 usecs = 11760 KB/s
4327997448 bytes / 372564289 usecs = 11344 KB/s
4295491592 bytes / 356637841 usecs = 11762 KB/s
4295491592 bytes / 356690738 usecs = 11760 KB/s
4295491592 bytes / 356770040 usecs = 11757 KB/s
4295491592 bytes / 357761313 usecs = 11725 KB/s
4296015880 bytes / 371242760 usecs = 11300 KB/s
4296015880 bytes / 356741731 usecs = 11760 KB/s
4298113032 bytes / 372780983 usecs = 11259 KB/s
4295491592 bytes / 357211451 usecs = 11743 KB/s
4301258760 bytes / 373757871 usecs = 11238 KB/s
4295491592 bytes / 368689538 usecs = 11377 KB/s
4295491592 bytes / 368814621 usecs = 11373 KB/s
4297588744 bytes / 373734204 usecs = 11229 KB/s
4295491592 bytes / 363245451 usecs = 11548 KB/s
4295491592 bytes / 358403985 usecs = 11704 KB/s
4295491592 bytes / 371044089 usecs = 11305 KB/s
4295491592 bytes / 357766627 usecs = 11725 KB/s
4311220232 bytes / 374641423 usecs = 11237 KB/s
4319084552 bytes / 374688812 usecs = 11256 KB/s
4295491592 bytes / 357787523 usecs = 11724 KB/s
4295491592 bytes / 363557142 usecs = 11538 KB/s
4308074504 bytes / 374320919 usecs = 11239 KB/s
4295491592 bytes / 363331473 usecs = 11545 KB/s
4295491592 bytes / 358639801 usecs = 11696 KB/s
4316463112 bytes / 374999430 usecs = 11240 KB/s
4329570312 bytes / 374580967 usecs = 11287 KB/s
4295491592 bytes / 363477162 usecs = 11540 KB/s
4295491592 bytes / 363724696 usecs = 11532 KB/s
4295491592 bytes / 358132249 usecs = 11713 KB/s
4297588744 bytes / 374787122 usecs = 11197 KB/s
4297588744 bytes / 374360733 usecs = 11210 KB/s
4323278856 bytes / 374728202 usecs = 11266 KB/s
4295491592 bytes / 359060879 usecs = 11682 KB/s
4295491592 bytes / 369558523 usecs = 11350 KB/s
4295491592 bytes / 370843037 usecs = 11311 KB/s
4301783048 bytes / 375094090 usecs = 11199 KB/s
4300734472 bytes / 375236005 usecs = 11192 KB/s
4295491592 bytes / 371859784 usecs = 11280 KB/s
4295491592 bytes / 371875679 usecs = 11280 KB/s
4296015880 bytes / 373379993 usecs = 11236 KB/s
4300210184 bytes / 373613392 usecs = 11240 KB/s
4295491592 bytes / 364430097 usecs = 11510 KB/s
4295491592 bytes / 359684144 usecs = 11662 KB/s
4298113032 bytes / 375321567 usecs = 11183 KB/s
4295491592 bytes / 371522164 usecs = 11290 KB/s
4295491592 bytes / 359821389 usecs = 11658 KB/s
4295491592 bytes / 356565453 usecs = 11764 KB/s
4327997448 bytes / 375697425 usecs = 11249 KB/s
4295491592 bytes / 369424366 usecs = 11355 KB/s
4295491592 bytes / 359273247 usecs = 11675 KB/s
4300734472 bytes / 375515255 usecs = 11184 KB/s
4295491592 bytes / 360046375 usecs = 11650 KB/s
4298113032 bytes / 373850243 usecs = 11227 KB/s
4295491592 bytes / 373918447 usecs = 11218 KB/s
4295491592 bytes / 359431663 usecs = 11670 KB/s
4310695944 bytes / 376344869 usecs = 11185 KB/s
4295491592 bytes / 372826768 usecs = 11251 KB/s
4299685896 bytes / 374430210 usecs = 11214 KB/s
4310171656 bytes / 376193383 usecs = 11188 KB/s
4295491592 bytes / 360205210 usecs = 11645 KB/s
4295491592 bytes / 360222951 usecs = 11645 KB/s
4295491592 bytes / 360473767 usecs = 11636 KB/s
4295491592 bytes / 365043874 usecs = 11491 KB/s
4295491592 bytes / 365319240 usecs = 11482 KB/s
4304404488 bytes / 376620154 usecs = 11161 KB/s
4295491592 bytes / 359714162 usecs = 11661 KB/s
4295491592 bytes / 359908491 usecs = 11655 KB/s
4295491592 bytes / 371168581 usecs = 11301 KB/s
4295491592 bytes / 359798049 usecs = 11658 KB/s
4295491592 bytes / 360700522 usecs = 11629 KB/s
4295491592 bytes / 360129981 usecs = 11648 KB/s
4320657416 bytes / 376879015 usecs = 11195 KB/s
4295491592 bytes / 360180536 usecs = 11646 KB/s
4295491592 bytes / 360111310 usecs = 11648 KB/s
4295491592 bytes / 360189206 usecs = 11646 KB/s
4295491592 bytes / 371558778 usecs = 11289 KB/s
4297064456 bytes / 371613266 usecs = 11292 KB/s
4306501640 bytes / 377147025 usecs = 11151 KB/s
4295491592 bytes / 366149941 usecs = 11456 KB/s
4297588744 bytes / 375310272 usecs = 11182 KB/s
4295491592 bytes / 372007234 usecs = 11276 KB/s
4297588744 bytes / 375481321 usecs = 11177 KB/s
4295491592 bytes / 372297143 usecs = 11267 KB/s
4302831624 bytes / 377640119 usecs = 11126 KB/s
4296015880 bytes / 375354157 usecs = 11176 KB/s
4312793096 bytes / 377431017 usecs = 11158 KB/s
4309647368 bytes / 378009764 usecs = 11133 KB/s
4295491592 bytes / 361314635 usecs = 11609 KB/s
4295491592 bytes / 361444690 usecs = 11605 KB/s
4302831624 bytes / 378334204 usecs = 11106 KB/s
4295491592 bytes / 367159800 usecs = 11425 KB/s
4304404488 bytes / 378420513 usecs = 11108 KB/s
4295491592 bytes / 375015608 usecs = 11185 KB/s
4295491592 bytes / 354086413 usecs = 11846 KB/s
4303355912 bytes / 378629859 usecs = 11099 KB/s
4309123080 bytes / 376123861 usecs = 11188 KB/s
4295491592 bytes / 361768558 usecs = 11595 KB/s
4295491592 bytes / 375217779 usecs = 11179 KB/s
4305453064 bytes / 378198916 usecs = 11117 KB/s
4295491592 bytes / 373461869 usecs = 11232 KB/s
4295491592 bytes / 354470028 usecs = 11834 KB/s
4295491592 bytes / 375432990 usecs = 11173 KB/s
4295491592 bytes / 373516744 usecs = 11230 KB/s
4295491592 bytes / 354597806 usecs = 11829 KB/s
4302831624 bytes / 377602674 usecs = 11128 KB/s
4295491592 bytes / 372630368 usecs = 11257 KB/s
4295491592 bytes / 362438956 usecs = 11573 KB/s
4295491592 bytes / 353211244 usecs = 11876 KB/s
4298113032 bytes / 378166780 usecs = 11099 KB/s
4295491592 bytes / 375840047 usecs = 11161 KB/s
4296015880 bytes / 378216083 usecs = 11092 KB/s
4295491592 bytes / 362742815 usecs = 11564 KB/s
4296015880 bytes / 363347454 usecs = 11546 KB/s
4295491592 bytes / 353462881 usecs = 11867 KB/s
[  434.573383] perf interrupt took too long (2522 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
4296015880 bytes / 363565643 usecs = 11539 KB/s
4295491592 bytes / 362943378 usecs = 11557 KB/s
[  434.593445] perf interrupt took too long (5004 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[  434.620449] perf interrupt took too long (10019 > 9615), lowering kernel.perf_event_max_sample_rate to 13000
4295491592 bytes / 368394110 usecs = 11386 KB/s
4295491592 bytes / 374567173 usecs = 11199 KB/s
4296015880 bytes / 377946674 usecs = 11100 KB/s
4298637320 bytes / 380153286 usecs = 11042 KB/s
4295491592 bytes / 361392862 usecs = 11607 KB/s
4295491592 bytes / 373651199 usecs = 11226 KB/s
4295491592 bytes / 373709261 usecs = 11224 KB/s
4318035976 bytes / 380496499 usecs = 11082 KB/s
4299685896 bytes / 379706110 usecs = 11058 KB/s
4295491592 bytes / 363724349 usecs = 11532 KB/s
4295491592 bytes / 363816292 usecs = 11530 KB/s
4324851720 bytes / 380610054 usecs = 11096 KB/s
4295491592 bytes / 361920527 usecs = 11590 KB/s
4295491592 bytes / 357133224 usecs = 11745 KB/s
4295491592 bytes / 363957928 usecs = 11525 KB/s
4295491592 bytes / 375278573 usecs = 11177 KB/s
4295491592 bytes / 377304004 usecs = 11117 KB/s
4305977352 bytes / 380435314 usecs = 11053 KB/s
4295491592 bytes / 357378610 usecs = 11737 KB/s
4296015880 bytes / 379050897 usecs = 11067 KB/s
4295491592 bytes / 364423766 usecs = 11510 KB/s
4327473160 bytes / 381270581 usecs = 11084 KB/s
4296015880 bytes / 379178139 usecs = 11064 KB/s
4295491592 bytes / 370066772 usecs = 11335 KB/s
4295491592 bytes / 369837175 usecs = 11342 KB/s
4299161608 bytes / 379348222 usecs = 11067 KB/s
4295491592 bytes / 370001473 usecs = 11337 KB/s
4295491592 bytes / 364864953 usecs = 11496 KB/s
4295491592 bytes / 370542073 usecs = 11320 KB/s
4295491592 bytes / 365644956 usecs = 11472 KB/s
4296540168 bytes / 365031246 usecs = 11494 KB/s
4295491592 bytes / 365053101 usecs = 11490 KB/s
4309123080 bytes / 381185909 usecs = 11039 KB/s
4295491592 bytes / 362691284 usecs = 11565 KB/s
4295491592 bytes / 375455115 usecs = 11172 KB/s
4295491592 bytes / 376642035 usecs = 11137 KB/s
4301258760 bytes / 380686088 usecs = 11033 KB/s
4295491592 bytes / 362897634 usecs = 11559 KB/s
4295491592 bytes / 365480315 usecs = 11477 KB/s
4295491592 bytes / 378107950 usecs = 11094 KB/s
4295491592 bytes / 366398500 usecs = 11448 KB/s
4297064456 bytes / 382282540 usecs = 10977 KB/s
4305977352 bytes / 381511074 usecs = 11022 KB/s
4295491592 bytes / 366345818 usecs = 11450 KB/s
4307550216 bytes / 382432953 usecs = 10999 KB/s
4295491592 bytes / 378266813 usecs = 11089 KB/s
4295491592 bytes / 363189626 usecs = 11549 KB/s
4295491592 bytes / 371380247 usecs = 11295 KB/s
4295491592 bytes / 365892401 usecs = 11464 KB/s
4295491592 bytes / 371644620 usecs = 11287 KB/s
4295491592 bytes / 379414371 usecs = 11056 KB/s
4320657416 bytes / 382976002 usecs = 11017 KB/s
4295491592 bytes / 381787691 usecs = 10987 KB/s
4295491592 bytes / 381788524 usecs = 10987 KB/s
4295491592 bytes / 376401880 usecs = 11144 KB/s
4295491592 bytes / 366331260 usecs = 11450 KB/s
4295491592 bytes / 366231372 usecs = 11454 KB/s
4295491592 bytes / 367180968 usecs = 11424 KB/s
4295491592 bytes / 377682359 usecs = 11106 KB/s
4295491592 bytes / 377748640 usecs = 11104 KB/s
4296015880 bytes / 379723203 usecs = 11048 KB/s
4309647368 bytes / 383113403 usecs = 10985 KB/s
4296015880 bytes / 372047951 usecs = 11276 KB/s
4295491592 bytes / 377851731 usecs = 11101 KB/s
4295491592 bytes / 367221958 usecs = 11423 KB/s
4295491592 bytes / 379158449 usecs = 11063 KB/s
4339007496 bytes / 382977933 usecs = 11064 KB/s
4295491592 bytes / 377979415 usecs = 11098 KB/s
4308598792 bytes / 383377989 usecs = 10975 KB/s
4295491592 bytes / 379294420 usecs = 11059 KB/s
4305977352 bytes / 383445333 usecs = 10966 KB/s
4322230280 bytes / 383576846 usecs = 11004 KB/s
4295491592 bytes / 379399666 usecs = 11056 KB/s
4295491592 bytes / 379449467 usecs = 11055 KB/s
4295491592 bytes / 367943777 usecs = 11400 KB/s
4296015880 bytes / 367214766 usecs = 11424 KB/s
4295491592 bytes / 379991093 usecs = 11039 KB/s
4295491592 bytes / 380035339 usecs = 11037 KB/s
4295491592 bytes / 380038116 usecs = 11037 KB/s
4296015880 bytes / 367321423 usecs = 11421 KB/s
4302307336 bytes / 384249064 usecs = 10934 KB/s
4295491592 bytes / 368408187 usecs = 11386 KB/s
4295491592 bytes / 368239342 usecs = 11391 KB/s
4295491592 bytes / 380945270 usecs = 11011 KB/s
4295491592 bytes / 379005451 usecs = 11067 KB/s
4295491592 bytes / 368385427 usecs = 11387 KB/s
4299161608 bytes / 384591752 usecs = 10916 KB/s
4295491592 bytes / 365229446 usecs = 11485 KB/s
4295491592 bytes / 367924362 usecs = 11401 KB/s
4310695944 bytes / 384823196 usecs = 10939 KB/s
4299161608 bytes / 383416765 usecs = 10949 KB/s
4295491592 bytes / 368099546 usecs = 11395 KB/s
4295491592 bytes / 369107253 usecs = 11364 KB/s
4295491592 bytes / 379715214 usecs = 11047 KB/s
4295491592 bytes / 380930263 usecs = 11012 KB/s
4321181704 bytes / 385106342 usecs = 10957 KB/s
4296015880 bytes / 360705325 usecs = 11630 KB/s
4321181704 bytes / 384900895 usecs = 10963 KB/s
4295491592 bytes / 363996104 usecs = 11524 KB/s
4296015880 bytes / 360851590 usecs = 11626 KB/s
4310695944 bytes / 385555835 usecs = 10918 KB/s
4295491592 bytes / 364302118 usecs = 11514 KB/s
4296540168 bytes / 385516473 usecs = 10883 KB/s
4295491592 bytes / 381495489 usecs = 10995 KB/s
4296015880 bytes / 383005569 usecs = 10953 KB/s
4295491592 bytes / 381718741 usecs = 10989 KB/s
4300210184 bytes / 385775222 usecs = 10885 KB/s
4296015880 bytes / 371309544 usecs = 11298 KB/s
4313841672 bytes / 386097754 usecs = 10911 KB/s
4296015880 bytes / 385529010 usecs = 10882 KB/s
4295491592 bytes / 364833998 usecs = 11497 KB/s
4295491592 bytes / 366873559 usecs = 11433 KB/s
4295491592 bytes / 370304759 usecs = 11328 KB/s
4296015880 bytes / 371503279 usecs = 11292 KB/s
4296015880 bytes / 369412994 usecs = 11356 KB/s
4295491592 bytes / 370372987 usecs = 11325 KB/s
4295491592 bytes / 370192326 usecs = 11331 KB/s
4295491592 bytes / 379737191 usecs = 11046 KB/s
4323278856 bytes / 386465658 usecs = 10924 KB/s
4296015880 bytes / 383677107 usecs = 10934 KB/s
4295491592 bytes / 385376769 usecs = 10884 KB/s
4296015880 bytes / 371796428 usecs = 11283 KB/s
4295491592 bytes / 381076762 usecs = 11007 KB/s
4295491592 bytes / 385426889 usecs = 10883 KB/s
4295491592 bytes / 367330065 usecs = 11419 KB/s
4300210184 bytes / 386328572 usecs = 10870 KB/s
4295491592 bytes / 382609626 usecs = 10963 KB/s
4305977352 bytes / 386051541 usecs = 10892 KB/s
4295491592 bytes / 381466489 usecs = 10996 KB/s
4295491592 bytes / 381576419 usecs = 10993 KB/s
4295491592 bytes / 370320382 usecs = 11327 KB/s
4298113032 bytes / 387133117 usecs = 10842 KB/s
4295491592 bytes / 381693967 usecs = 10989 KB/s
4320133128 bytes / 385309753 usecs = 10949 KB/s
4299161608 bytes / 385154859 usecs = 10900 KB/s
4295491592 bytes / 380680084 usecs = 11019 KB/s
4295491592 bytes / 371382386 usecs = 11295 KB/s
4324327432 bytes / 387069794 usecs = 10910 KB/s
4295491592 bytes / 381879123 usecs = 10984 KB/s
4295491592 bytes / 370621383 usecs = 11318 KB/s
4295491592 bytes / 371471881 usecs = 11292 KB/s
4295491592 bytes / 382022990 usecs = 10980 KB/s
4295491592 bytes / 376131300 usecs = 11152 KB/s
4295491592 bytes / 371679135 usecs = 11286 KB/s
4295491592 bytes / 382205294 usecs = 10975 KB/s
4295491592 bytes / 370933875 usecs = 11308 KB/s
4331143176 bytes / 387324631 usecs = 10920 KB/s
4295491592 bytes / 366462965 usecs = 11446 KB/s
4295491592 bytes / 371039183 usecs = 11305 KB/s
4295491592 bytes / 371750050 usecs = 11283 KB/s
4296015880 bytes / 385414179 usecs = 10885 KB/s
4295491592 bytes / 382483446 usecs = 10967 KB/s
4295491592 bytes / 363516227 usecs = 11539 KB/s
4295491592 bytes / 376575813 usecs = 11139 KB/s
4295491592 bytes / 372099892 usecs = 11273 KB/s
4304928776 bytes / 387269483 usecs = 10855 KB/s
4295491592 bytes / 381505546 usecs = 10995 KB/s
4295491592 bytes / 363664055 usecs = 11534 KB/s
4296015880 bytes / 387769846 usecs = 10819 KB/s
4295491592 bytes / 372066086 usecs = 11274 KB/s
4295491592 bytes / 368858113 usecs = 11372 KB/s
4301258760 bytes / 388319589 usecs = 10816 KB/s
4295491592 bytes / 371460305 usecs = 11292 KB/s
4295491592 bytes / 372166555 usecs = 11271 KB/s
4295491592 bytes / 372178732 usecs = 11270 KB/s
4296015880 bytes / 385588812 usecs = 10880 KB/s
4295491592 bytes / 371771462 usecs = 11283 KB/s
4295491592 bytes / 371838004 usecs = 11281 KB/s
4295491592 bytes / 385077719 usecs = 10893 KB/s
4295491592 bytes / 372646174 usecs = 11256 KB/s
4295491592 bytes / 372445395 usecs = 11262 KB/s
4295491592 bytes / 369264304 usecs = 11359 KB/s
4295491592 bytes / 372579308 usecs = 11258 KB/s
4295491592 bytes / 372603355 usecs = 11258 KB/s
4295491592 bytes / 370939691 usecs = 11308 KB/s
4295491592 bytes / 385293455 usecs = 10887 KB/s
4295491592 bytes / 372871737 usecs = 11250 KB/s
4295491592 bytes / 369488022 usecs = 11353 KB/s
4295491592 bytes / 372135405 usecs = 11272 KB/s
4295491592 bytes / 383437977 usecs = 10940 KB/s
4295491592 bytes / 382343619 usecs = 10971 KB/s
4295491592 bytes / 372241110 usecs = 11269 KB/s
4295491592 bytes / 377564013 usecs = 11110 KB/s
4295491592 bytes / 372396684 usecs = 11264 KB/s
4295491592 bytes / 385702249 usecs = 10875 KB/s
4295491592 bytes / 373143373 usecs = 11241 KB/s
4295491592 bytes / 372525272 usecs = 11260 KB/s
4295491592 bytes / 382691518 usecs = 10961 KB/s
4295491592 bytes / 372650215 usecs = 11256 KB/s
4332191752 bytes / 389476874 usecs = 10862 KB/s
4295491592 bytes / 372669757 usecs = 11256 KB/s
4296015880 bytes / 386666652 usecs = 10849 KB/s
4296015880 bytes / 387424064 usecs = 10828 KB/s
4295491592 bytes / 384132751 usecs = 10920 KB/s
4296015880 bytes / 387231463 usecs = 10834 KB/s
4295491592 bytes / 373967089 usecs = 11217 KB/s
4295491592 bytes / 383399911 usecs = 10941 KB/s
4296540168 bytes / 386649093 usecs = 10851 KB/s
4295491592 bytes / 384676881 usecs = 10904 KB/s
4296015880 bytes / 389783852 usecs = 10763 KB/s
4295491592 bytes / 385992501 usecs = 10867 KB/s
4295491592 bytes / 368939358 usecs = 11369 KB/s
4295491592 bytes / 374297373 usecs = 11207 KB/s
4295491592 bytes / 374251339 usecs = 11208 KB/s
4295491592 bytes / 379022329 usecs = 11067 KB/s
4314365960 bytes / 390587053 usecs = 10786 KB/s
4295491592 bytes / 373642342 usecs = 11226 KB/s
4295491592 bytes / 385077958 usecs = 10893 KB/s
4296015880 bytes / 390427229 usecs = 10745 KB/s
4295491592 bytes / 366266748 usecs = 11452 KB/s
4295491592 bytes / 386569646 usecs = 10851 KB/s
4295491592 bytes / 374785743 usecs = 11192 KB/s
4295491592 bytes / 379412477 usecs = 11056 KB/s
4295491592 bytes / 371507750 usecs = 11291 KB/s
4295491592 bytes / 385578454 usecs = 10879 KB/s
4295491592 bytes / 366593605 usecs = 11442 KB/s
4296015880 bytes / 390659899 usecs = 10739 KB/s
4295491592 bytes / 374992391 usecs = 11186 KB/s
4306501640 bytes / 391215402 usecs = 10750 KB/s
4314365960 bytes / 389327316 usecs = 10821 KB/s
4302831624 bytes / 391198905 usecs = 10741 KB/s
4295491592 bytes / 366827075 usecs = 11435 KB/s
4295491592 bytes / 375326350 usecs = 11176 KB/s
4295491592 bytes / 384873701 usecs = 10899 KB/s
4295491592 bytes / 380062308 usecs = 11037 KB/s
4295491592 bytes / 384940150 usecs = 10897 KB/s
4295491592 bytes / 380091190 usecs = 11036 KB/s
4295491592 bytes / 375525265 usecs = 11170 KB/s
4321181704 bytes / 391181646 usecs = 10787 KB/s
4295491592 bytes / 375445363 usecs = 11172 KB/s
4295491592 bytes / 380218381 usecs = 11032 KB/s
4295491592 bytes / 387500261 usecs = 10825 KB/s
4295491592 bytes / 386279930 usecs = 10859 KB/s
4295491592 bytes / 386298753 usecs = 10858 KB/s
4298637320 bytes / 391470334 usecs = 10723 KB/s
4295491592 bytes / 375909623 usecs = 11159 KB/s
4295491592 bytes / 387700221 usecs = 10819 KB/s
4295491592 bytes / 375067681 usecs = 11184 KB/s
4295491592 bytes / 376063997 usecs = 11154 KB/s
4302831624 bytes / 392163082 usecs = 10714 KB/s
4295491592 bytes / 372794865 usecs = 11252 KB/s
4295491592 bytes / 376257837 usecs = 11148 KB/s
4295491592 bytes / 385589218 usecs = 10878 KB/s
4295491592 bytes / 385631176 usecs = 10877 KB/s
4295491592 bytes / 368709111 usecs = 11377 KB/s
4295491592 bytes / 372994947 usecs = 11246 KB/s
4295491592 bytes / 386866480 usecs = 10843 KB/s
4312793096 bytes / 392559311 usecs = 10728 KB/s
4295491592 bytes / 385959376 usecs = 10868 KB/s
4295491592 bytes / 376486294 usecs = 11142 KB/s
4295491592 bytes / 387068140 usecs = 10837 KB/s
4295491592 bytes / 375634978 usecs = 11167 KB/s
4296015880 bytes / 389776460 usecs = 10763 KB/s
4295491592 bytes / 388370870 usecs = 10801 KB/s
4295491592 bytes / 376442356 usecs = 11143 KB/s
4296540168 bytes / 389205439 usecs = 10780 KB/s
4295491592 bytes / 386081615 usecs = 10865 KB/s
4295491592 bytes / 376806244 usecs = 11132 KB/s
4295491592 bytes / 369200667 usecs = 11361 KB/s
4295491592 bytes / 387314459 usecs = 10830 KB/s
4295491592 bytes / 376649883 usecs = 11137 KB/s
4295491592 bytes / 374072117 usecs = 11213 KB/s
4295491592 bytes / 387352063 usecs = 10829 KB/s
4295491592 bytes / 371524450 usecs = 11290 KB/s
4295491592 bytes / 374144478 usecs = 11211 KB/s
4295491592 bytes / 376170005 usecs = 11151 KB/s
4295491592 bytes / 388685705 usecs = 10792 KB/s
4301258760 bytes / 392850630 usecs = 10692 KB/s
4295491592 bytes / 387510926 usecs = 10825 KB/s
4295491592 bytes / 376839549 usecs = 11131 KB/s
4295491592 bytes / 377050936 usecs = 11125 KB/s
4295491592 bytes / 376137348 usecs = 11152 KB/s
4296015880 bytes / 392598039 usecs = 10686 KB/s
4295491592 bytes / 377120869 usecs = 11123 KB/s
4295491592 bytes / 386569391 usecs = 10851 KB/s
4295491592 bytes / 389014909 usecs = 10783 KB/s
4318560264 bytes / 391340373 usecs = 10776 KB/s
4295491592 bytes / 377267110 usecs = 11118 KB/s
4295491592 bytes / 387965019 usecs = 10812 KB/s
4295491592 bytes / 374110427 usecs = 11212 KB/s
4295491592 bytes / 388005149 usecs = 10811 KB/s
4296540168 bytes / 391624298 usecs = 10713 KB/s
4295491592 bytes / 387003123 usecs = 10839 KB/s
4295491592 bytes / 389362585 usecs = 10773 KB/s
4295491592 bytes / 369223307 usecs = 11361 KB/s
4295491592 bytes / 374345919 usecs = 11205 KB/s
4295491592 bytes / 388320835 usecs = 10802 KB/s
4295491592 bytes / 376677586 usecs = 11136 KB/s
4295491592 bytes / 388274456 usecs = 10803 KB/s
4295491592 bytes / 387211007 usecs = 10833 KB/s
4295491592 bytes / 382377598 usecs = 10970 KB/s
4295491592 bytes / 382417502 usecs = 10969 KB/s
4295491592 bytes / 376835343 usecs = 11131 KB/s
4295491592 bytes / 382547351 usecs = 10965 KB/s
4295491592 bytes / 374636996 usecs = 11197 KB/s
4295491592 bytes / 376304343 usecs = 11147 KB/s
4295491592 bytes / 383028684 usecs = 10951 KB/s
4295491592 bytes / 388740668 usecs = 10790 KB/s
4295491592 bytes / 373003867 usecs = 11246 KB/s
4295491592 bytes / 377615074 usecs = 11108 KB/s
4295491592 bytes / 388902413 usecs = 10786 KB/s
4295491592 bytes / 370861628 usecs = 11311 KB/s
4295491592 bytes / 377599527 usecs = 11109 KB/s
4295491592 bytes / 383050112 usecs = 10951 KB/s
4295491592 bytes / 373241855 usecs = 11238 KB/s
4295491592 bytes / 378644180 usecs = 11078 KB/s
4295491592 bytes / 377917585 usecs = 11099 KB/s
4295491592 bytes / 383500438 usecs = 10938 KB/s
4312268808 bytes / 394775025 usecs = 10667 KB/s
4311744520 bytes / 394721807 usecs = 10667 KB/s
4295491592 bytes / 377854090 usecs = 11101 KB/s
4295491592 bytes / 371278989 usecs = 11298 KB/s
4295491592 bytes / 376103947 usecs = 11153 KB/s
4295491592 bytes / 388271823 usecs = 10803 KB/s
4307550216 bytes / 394971380 usecs = 10650 KB/s
4295491592 bytes / 376177728 usecs = 11151 KB/s
4295491592 bytes / 378232595 usecs = 11090 KB/s
4295491592 bytes / 389507188 usecs = 10769 KB/s
4297064456 bytes / 395145707 usecs = 10619 KB/s
4295491592 bytes / 373166373 usecs = 11241 KB/s
4295491592 bytes / 389800465 usecs = 10761 KB/s
4295491592 bytes / 384114180 usecs = 10920 KB/s
4295491592 bytes / 374029921 usecs = 11215 KB/s
4296015880 bytes / 395186576 usecs = 10616 KB/s
4296015880 bytes / 373596976 usecs = 11229 KB/s
4296015880 bytes / 373766343 usecs = 11224 KB/s
4295491592 bytes / 378044440 usecs = 11096 KB/s
4296540168 bytes / 395256128 usecs = 10615 KB/s
4296015880 bytes / 393062928 usecs = 10673 KB/s
4311220232 bytes / 396035867 usecs = 10630 KB/s
4295491592 bytes / 389366801 usecs = 10773 KB/s
4295491592 bytes / 379238231 usecs = 11061 KB/s
4295491592 bytes / 379915673 usecs = 11041 KB/s
4295491592 bytes / 372462980 usecs = 11262 KB/s
4295491592 bytes / 390542254 usecs = 10741 KB/s
4296015880 bytes / 395807698 usecs = 10599 KB/s
4295491592 bytes / 380326558 usecs = 11029 KB/s
4305453064 bytes / 396154755 usecs = 10613 KB/s
4295491592 bytes / 389715288 usecs = 10763 KB/s
4295491592 bytes / 389776307 usecs = 10762 KB/s
4295491592 bytes / 390875515 usecs = 10731 KB/s
4330094600 bytes / 396112863 usecs = 10675 KB/s
4296015880 bytes / 396262054 usecs = 10587 KB/s
4295491592 bytes / 392251185 usecs = 10694 KB/s
4295491592 bytes / 391119599 usecs = 10725 KB/s
4295491592 bytes / 390023628 usecs = 10755 KB/s
4295491592 bytes / 391196047 usecs = 10723 KB/s
4295491592 bytes / 392473308 usecs = 10688 KB/s
4295491592 bytes / 380534305 usecs = 11023 KB/s
4296540168 bytes / 396764182 usecs = 10575 KB/s
4295491592 bytes / 385701161 usecs = 10875 KB/s
4295491592 bytes / 391459200 usecs = 10715 KB/s
4296015880 bytes / 394114541 usecs = 10644 KB/s
4295491592 bytes / 390356815 usecs = 10746 KB/s
4295491592 bytes / 385753061 usecs = 10874 KB/s
4295491592 bytes / 380774874 usecs = 11016 KB/s
4297064456 bytes / 394972390 usecs = 10624 KB/s
4295491592 bytes / 379215372 usecs = 11061 KB/s
4295491592 bytes / 385607660 usecs = 10878 KB/s
4296015880 bytes / 394250942 usecs = 10641 KB/s
4322230280 bytes / 395507783 usecs = 10672 KB/s
4295491592 bytes / 385648522 usecs = 10877 KB/s
4295491592 bytes / 391759749 usecs = 10707 KB/s
4295491592 bytes / 391898585 usecs = 10703 KB/s
4295491592 bytes / 381276601 usecs = 11002 KB/s
4296015880 bytes / 394643729 usecs = 10630 KB/s
4295491592 bytes / 376158002 usecs = 11151 KB/s
4295491592 bytes / 373085746 usecs = 11243 KB/s
4295491592 bytes / 380818396 usecs = 11015 KB/s
4295491592 bytes / 386171970 usecs = 10862 KB/s
4295491592 bytes / 382869099 usecs = 10956 KB/s
4295491592 bytes / 392210208 usecs = 10695 KB/s
4295491592 bytes / 379845025 usecs = 11043 KB/s
4295491592 bytes / 386487816 usecs = 10853 KB/s
4295491592 bytes / 393458332 usecs = 10661 KB/s
4296540168 bytes / 381795273 usecs = 10989 KB/s
4295491592 bytes / 391115526 usecs = 10725 KB/s
4295491592 bytes / 391221310 usecs = 10722 KB/s
4295491592 bytes / 381044185 usecs = 11008 KB/s
4295491592 bytes / 392476826 usecs = 10688 KB/s
4295491592 bytes / 393710545 usecs = 10654 KB/s
4295491592 bytes / 386795240 usecs = 10845 KB/s
4295491592 bytes / 373560761 usecs = 11229 KB/s
4295491592 bytes / 386857516 usecs = 10843 KB/s
4295491592 bytes / 392728886 usecs = 10681 KB/s
4295491592 bytes / 381469042 usecs = 10996 KB/s
4300734472 bytes / 398231833 usecs = 10546 KB/s
4295491592 bytes / 374701354 usecs = 11195 KB/s
4295491592 bytes / 391702587 usecs = 10709 KB/s
4295491592 bytes / 380491965 usecs = 11024 KB/s
4295491592 bytes / 387146753 usecs = 10835 KB/s
4295491592 bytes / 381589263 usecs = 10993 KB/s
4296015880 bytes / 398238390 usecs = 10534 KB/s
4295491592 bytes / 381522762 usecs = 10994 KB/s
4295491592 bytes / 380700975 usecs = 11018 KB/s
4295491592 bytes / 393121526 usecs = 10670 KB/s
4295491592 bytes / 393216294 usecs = 10667 KB/s
4295491592 bytes / 381962090 usecs = 10982 KB/s
4295491592 bytes / 393302660 usecs = 10665 KB/s
4295491592 bytes / 375208121 usecs = 11179 KB/s
4311744520 bytes / 398791789 usecs = 10558 KB/s
4295491592 bytes / 376783334 usecs = 11133 KB/s
4295491592 bytes / 381986258 usecs = 10981 KB/s
4331667464 bytes / 398959610 usecs = 10602 KB/s
4295491592 bytes / 381091544 usecs = 11007 KB/s
4295491592 bytes / 381107168 usecs = 11006 KB/s
4295491592 bytes / 393443325 usecs = 10661 KB/s
4297064456 bytes / 398750646 usecs = 10523 KB/s
4295491592 bytes / 375413397 usecs = 11173 KB/s
4295491592 bytes / 393521439 usecs = 10659 KB/s
4295491592 bytes / 394755852 usecs = 10626 KB/s
4295491592 bytes / 394764504 usecs = 10626 KB/s
4295491592 bytes / 381235839 usecs = 11003 KB/s
4295491592 bytes / 375531998 usecs = 11170 KB/s
4295491592 bytes / 387918393 usecs = 10813 KB/s
4295491592 bytes / 383061580 usecs = 10950 KB/s
4295491592 bytes / 377825654 usecs = 11102 KB/s
4295491592 bytes / 382995085 usecs = 10952 KB/s
4301783048 bytes / 399180336 usecs = 10523 KB/s
4295491592 bytes / 388082858 usecs = 10809 KB/s
4295491592 bytes / 393814494 usecs = 10651 KB/s
4295491592 bytes / 392778448 usecs = 10679 KB/s
4295491592 bytes / 380629900 usecs = 11020 KB/s
4295491592 bytes / 375839602 usecs = 11161 KB/s
4295491592 bytes / 393960806 usecs = 10647 KB/s
4295491592 bytes / 392797277 usecs = 10679 KB/s
4295491592 bytes / 393932141 usecs = 10648 KB/s
4295491592 bytes / 392854488 usecs = 10677 KB/s
4295491592 bytes / 394001859 usecs = 10646 KB/s
4295491592 bytes / 382624807 usecs = 10963 KB/s
4295491592 bytes / 380127306 usecs = 11035 KB/s
4295491592 bytes / 378193859 usecs = 11091 KB/s
4295491592 bytes / 382823468 usecs = 10957 KB/s
4325376008 bytes / 399552868 usecs = 10571 KB/s
4295491592 bytes / 382844444 usecs = 10956 KB/s
4295491592 bytes / 388456040 usecs = 10798 KB/s
4295491592 bytes / 382863881 usecs = 10956 KB/s
4296015880 bytes / 399253682 usecs = 10507 KB/s
4295491592 bytes / 375143548 usecs = 11181 KB/s
4295491592 bytes / 382823507 usecs = 10957 KB/s
4295491592 bytes / 388566170 usecs = 10795 KB/s
4295491592 bytes / 388569854 usecs = 10795 KB/s
4306501640 bytes / 398854687 usecs = 10544 KB/s
4295491592 bytes / 395530846 usecs = 10605 KB/s
4295491592 bytes / 394336676 usecs = 10637 KB/s
4295491592 bytes / 382996902 usecs = 10952 KB/s
4295491592 bytes / 395601369 usecs = 10603 KB/s
4295491592 bytes / 383108850 usecs = 10949 KB/s
4295491592 bytes / 375506289 usecs = 11171 KB/s
4295491592 bytes / 385283979 usecs = 10887 KB/s
4295491592 bytes / 395827279 usecs = 10597 KB/s
4330618888 bytes / 399795656 usecs = 10578 KB/s
4295491592 bytes / 393479519 usecs = 10660 KB/s
4295491592 bytes / 393527078 usecs = 10659 KB/s
4295491592 bytes / 383035385 usecs = 10951 KB/s
4295491592 bytes / 383402033 usecs = 10941 KB/s
4295491592 bytes / 394750583 usecs = 10626 KB/s
4295491592 bytes / 384088946 usecs = 10921 KB/s
4296015880 bytes / 400091393 usecs = 10485 KB/s
4295491592 bytes / 396121862 usecs = 10589 KB/s
4311220232 bytes / 400378863 usecs = 10515 KB/s
4295491592 bytes / 383605069 usecs = 10935 KB/s
4295491592 bytes / 375904220 usecs = 11159 KB/s
4295491592 bytes / 383531143 usecs = 10937 KB/s
4296015880 bytes / 400253667 usecs = 10481 KB/s
4295491592 bytes / 385721770 usecs = 10875 KB/s
4295491592 bytes / 376014679 usecs = 11155 KB/s
4295491592 bytes / 377084232 usecs = 11124 KB/s
4295491592 bytes / 396420837 usecs = 10581 KB/s
4296015880 bytes / 376133181 usecs = 11153 KB/s
4295491592 bytes / 395270968 usecs = 10612 KB/s
4295491592 bytes / 383872366 usecs = 10927 KB/s
4295491592 bytes / 383934373 usecs = 10925 KB/s
4295491592 bytes / 384025523 usecs = 10923 KB/s
4301783048 bytes / 400783998 usecs = 10481 KB/s
4295491592 bytes / 384710239 usecs = 10903 KB/s
4295491592 bytes / 384070992 usecs = 10921 KB/s
4295491592 bytes / 383881166 usecs = 10927 KB/s
4296015880 bytes / 400824708 usecs = 10466 KB/s
4295491592 bytes / 384345441 usecs = 10914 KB/s
4296015880 bytes / 398275065 usecs = 10533 KB/s
4296015880 bytes / 400900371 usecs = 10464 KB/s
4295491592 bytes / 384393251 usecs = 10912 KB/s
4296015880 bytes / 398315653 usecs = 10532 KB/s
4295491592 bytes / 396909696 usecs = 10568 KB/s
4295491592 bytes / 384428663 usecs = 10911 KB/s
4295491592 bytes / 381859320 usecs = 10985 KB/s
4295491592 bytes / 381881954 usecs = 10984 KB/s
4295491592 bytes / 379918335 usecs = 11041 KB/s
4295491592 bytes / 394673949 usecs = 10628 KB/s
4295491592 bytes / 395887919 usecs = 10595 KB/s
4295491592 bytes / 375413567 usecs = 11173 KB/s
4295491592 bytes / 395959396 usecs = 10594 KB/s
4295491592 bytes / 385544848 usecs = 10880 KB/s
4295491592 bytes / 384409773 usecs = 10912 KB/s
4295491592 bytes / 390324290 usecs = 10747 KB/s
4295491592 bytes / 377060094 usecs = 11125 KB/s
4295491592 bytes / 385469386 usecs = 10882 KB/s
4296015880 bytes / 398058279 usecs = 10539 KB/s
4300210184 bytes / 401667548 usecs = 10454 KB/s
4295491592 bytes / 385566734 usecs = 10879 KB/s
4325376008 bytes / 401370832 usecs = 10523 KB/s
4295491592 bytes / 384736343 usecs = 10903 KB/s
4295491592 bytes / 385613403 usecs = 10878 KB/s
4295491592 bytes / 397616948 usecs = 10549 KB/s
4295491592 bytes / 396358926 usecs = 10583 KB/s
4295491592 bytes / 390716085 usecs = 10736 KB/s
4295491592 bytes / 377458138 usecs = 11113 KB/s
4295491592 bytes / 384952573 usecs = 10896 KB/s
4295491592 bytes / 385879746 usecs = 10870 KB/s
4295491592 bytes / 395380505 usecs = 10609 KB/s
4295491592 bytes / 385212387 usecs = 10889 KB/s
4295491592 bytes / 385413778 usecs = 10883 KB/s
4295491592 bytes / 385416530 usecs = 10883 KB/s
4295491592 bytes / 385423944 usecs = 10883 KB/s
4295491592 bytes / 396880262 usecs = 10569 KB/s
4295491592 bytes / 391171454 usecs = 10723 KB/s
4295491592 bytes / 386233052 usecs = 10860 KB/s
4295491592 bytes / 385662697 usecs = 10876 KB/s
4295491592 bytes / 387631222 usecs = 10821 KB/s
4295491592 bytes / 396893502 usecs = 10569 KB/s
4295491592 bytes / 377973647 usecs = 11098 KB/s
4295491592 bytes / 390997245 usecs = 10728 KB/s
4295491592 bytes / 378069843 usecs = 11095 KB/s
4295491592 bytes / 384731884 usecs = 10903 KB/s
4295491592 bytes / 385839566 usecs = 10871 KB/s
4295491592 bytes / 386439962 usecs = 10855 KB/s
4295491592 bytes / 376602149 usecs = 11138 KB/s
4295491592 bytes / 391200246 usecs = 10722 KB/s
4295491592 bytes / 397199640 usecs = 10560 KB/s
4296015880 bytes / 385716953 usecs = 10876 KB/s
4295491592 bytes / 386612936 usecs = 10850 KB/s
4301783048 bytes / 400255905 usecs = 10495 KB/s
4295491592 bytes / 397303128 usecs = 10558 KB/s
4295491592 bytes / 380739598 usecs = 11017 KB/s
4295491592 bytes / 397314466 usecs = 10557 KB/s
4295491592 bytes / 388105134 usecs = 10808 KB/s
4295491592 bytes / 376904465 usecs = 11129 KB/s
4295491592 bytes / 384249397 usecs = 10916 KB/s
4295491592 bytes / 379449110 usecs = 11055 KB/s
4296015880 bytes / 400221493 usecs = 10482 KB/s
4295491592 bytes / 386207665 usecs = 10861 KB/s
4295491592 bytes / 386308580 usecs = 10858 KB/s
4302831624 bytes / 403231600 usecs = 10420 KB/s
4295491592 bytes / 392068366 usecs = 10699 KB/s
4295491592 bytes / 386587750 usecs = 10850 KB/s
4295491592 bytes / 382051387 usecs = 10979 KB/s
4295491592 bytes / 387210648 usecs = 10833 KB/s
4295491592 bytes / 386647469 usecs = 10849 KB/s
4295491592 bytes / 384749911 usecs = 10902 KB/s
4295491592 bytes / 398091406 usecs = 10537 KB/s
4295491592 bytes / 387458694 usecs = 10826 KB/s
4295491592 bytes / 379059368 usecs = 11066 KB/s
4295491592 bytes / 397094800 usecs = 10563 KB/s
4295491592 bytes / 398196893 usecs = 10534 KB/s
4295491592 bytes / 398298566 usecs = 10531 KB/s
4295491592 bytes / 392595846 usecs = 10684 KB/s
4295491592 bytes / 392596527 usecs = 10684 KB/s
4295491592 bytes / 387013699 usecs = 10838 KB/s
4295491592 bytes / 387658826 usecs = 10820 KB/s
4295491592 bytes / 392687489 usecs = 10682 KB/s
4295491592 bytes / 382555431 usecs = 10965 KB/s
4295491592 bytes / 399662035 usecs = 10495 KB/s
4295491592 bytes / 392762546 usecs = 10680 KB/s
4295491592 bytes / 386860741 usecs = 10843 KB/s
4295491592 bytes / 382622421 usecs = 10963 KB/s
4295491592 bytes / 387192153 usecs = 10833 KB/s
4295491592 bytes / 387269383 usecs = 10831 KB/s
4295491592 bytes / 382003508 usecs = 10981 KB/s
4295491592 bytes / 386217428 usecs = 10861 KB/s
4295491592 bytes / 379607071 usecs = 11050 KB/s
4295491592 bytes / 387934425 usecs = 10813 KB/s
4295491592 bytes / 385346593 usecs = 10885 KB/s
4295491592 bytes / 398628473 usecs = 10523 KB/s
4295491592 bytes / 379675419 usecs = 11048 KB/s
4295491592 bytes / 398712598 usecs = 10520 KB/s
4295491592 bytes / 388030336 usecs = 10810 KB/s
4295491592 bytes / 386399554 usecs = 10856 KB/s
4295491592 bytes / 387121246 usecs = 10835 KB/s
4295491592 bytes / 386413477 usecs = 10855 KB/s
4295491592 bytes / 382274393 usecs = 10973 KB/s
4295491592 bytes / 379953059 usecs = 11040 KB/s
4295491592 bytes / 393286395 usecs = 10666 KB/s
4295491592 bytes / 387818706 usecs = 10816 KB/s
4295491592 bytes / 389825729 usecs = 10760 KB/s
4295491592 bytes / 388489544 usecs = 10797 KB/s
4295491592 bytes / 386835904 usecs = 10843 KB/s
4295491592 bytes / 388592119 usecs = 10794 KB/s
4296015880 bytes / 404271817 usecs = 10377 KB/s
4295491592 bytes / 387748383 usecs = 10818 KB/s
4295491592 bytes / 385931138 usecs = 10869 KB/s
4295491592 bytes / 388503516 usecs = 10797 KB/s
4295491592 bytes / 388584356 usecs = 10795 KB/s
4295491592 bytes / 378728303 usecs = 11076 KB/s
4295491592 bytes / 387786944 usecs = 10817 KB/s
4295491592 bytes / 399411794 usecs = 10502 KB/s
4295491592 bytes / 387896620 usecs = 10814 KB/s
4295491592 bytes / 378985182 usecs = 11068 KB/s
4295491592 bytes / 399528621 usecs = 10499 KB/s
4295491592 bytes / 399587864 usecs = 10497 KB/s
4295491592 bytes / 389040773 usecs = 10782 KB/s
4296540168 bytes / 402278991 usecs = 10430 KB/s
4295491592 bytes / 399624523 usecs = 10496 KB/s
4295491592 bytes / 388395382 usecs = 10800 KB/s
4295491592 bytes / 398583409 usecs = 10524 KB/s
4295491592 bytes / 379143810 usecs = 11063 KB/s
4295491592 bytes / 389077409 usecs = 10781 KB/s
4295491592 bytes / 389050021 usecs = 10782 KB/s
4295491592 bytes / 389323940 usecs = 10774 KB/s
4295491592 bytes / 393838913 usecs = 10651 KB/s
4295491592 bytes / 381721966 usecs = 10989 KB/s
4295491592 bytes / 388325606 usecs = 10802 KB/s
4295491592 bytes / 383985250 usecs = 10924 KB/s
4295491592 bytes / 381799442 usecs = 10986 KB/s
4295491592 bytes / 380970616 usecs = 11010 KB/s
4295491592 bytes / 379405297 usecs = 11056 KB/s
4295491592 bytes / 394256317 usecs = 10639 KB/s
4295491592 bytes / 379423020 usecs = 11055 KB/s
4295491592 bytes / 389428464 usecs = 10771 KB/s
4295491592 bytes / 379550073 usecs = 11052 KB/s
4295491592 bytes / 387805363 usecs = 10816 KB/s
4295491592 bytes / 388871741 usecs = 10787 KB/s
4295491592 bytes / 388874546 usecs = 10787 KB/s
4295491592 bytes / 388742183 usecs = 10790 KB/s
4295491592 bytes / 400328413 usecs = 10478 KB/s
4295491592 bytes / 382264833 usecs = 10973 KB/s
4295491592 bytes / 384489572 usecs = 10910 KB/s
4295491592 bytes / 389783535 usecs = 10761 KB/s
4295491592 bytes / 383870089 usecs = 10927 KB/s
4295491592 bytes / 399316915 usecs = 10504 KB/s
4295491592 bytes / 388091112 usecs = 10808 KB/s
4295491592 bytes / 401708379 usecs = 10442 KB/s
4295491592 bytes / 394563395 usecs = 10631 KB/s
4295491592 bytes / 394814938 usecs = 10624 KB/s
4295491592 bytes / 389056670 usecs = 10782 KB/s
4295491592 bytes / 394933981 usecs = 10621 KB/s
4295491592 bytes / 384133203 usecs = 10920 KB/s
4295491592 bytes / 400679538 usecs = 10469 KB/s
4295491592 bytes / 400698667 usecs = 10468 KB/s
4295491592 bytes / 391457363 usecs = 10715 KB/s
4295491592 bytes / 384226845 usecs = 10917 KB/s
4295491592 bytes / 380246392 usecs = 11031 KB/s
4295491592 bytes / 386921024 usecs = 10841 KB/s
4295491592 bytes / 384290836 usecs = 10915 KB/s
4295491592 bytes / 384296375 usecs = 10915 KB/s
4295491592 bytes / 388503682 usecs = 10797 KB/s
4295491592 bytes / 399765133 usecs = 10493 KB/s
4295491592 bytes / 394932165 usecs = 10621 KB/s
4295491592 bytes / 394932760 usecs = 10621 KB/s
4295491592 bytes / 394945997 usecs = 10621 KB/s
4295491592 bytes / 394946257 usecs = 10621 KB/s
4295491592 bytes / 389297173 usecs = 10775 KB/s
4295491592 bytes / 388594172 usecs = 10794 KB/s
4295491592 bytes / 388614177 usecs = 10794 KB/s
4295491592 bytes / 387061033 usecs = 10837 KB/s
4295491592 bytes / 390271774 usecs = 10748 KB/s
4295491592 bytes / 382022165 usecs = 10980 KB/s
4295491592 bytes / 387734108 usecs = 10818 KB/s
4295491592 bytes / 390457856 usecs = 10743 KB/s
4295491592 bytes / 380496607 usecs = 11024 KB/s
4295491592 bytes / 390479180 usecs = 10742 KB/s
4295491592 bytes / 384540578 usecs = 10908 KB/s
4295491592 bytes / 401155172 usecs = 10456 KB/s
4295491592 bytes / 395495306 usecs = 10606 KB/s
4295491592 bytes / 390676687 usecs = 10737 KB/s
4295491592 bytes / 384761516 usecs = 10902 KB/s
4295491592 bytes / 383224473 usecs = 10946 KB/s
4295491592 bytes / 400202238 usecs = 10481 KB/s
4295491592 bytes / 400203657 usecs = 10481 KB/s
4295491592 bytes / 400206267 usecs = 10481 KB/s
4295491592 bytes / 387434410 usecs = 10827 KB/s
4295491592 bytes / 390956318 usecs = 10729 KB/s
4295491592 bytes / 389934916 usecs = 10757 KB/s
4295491592 bytes / 382469561 usecs = 10967 KB/s
4295491592 bytes / 389960532 usecs = 10757 KB/s
4295491592 bytes / 389139420 usecs = 10779 KB/s
4295491592 bytes / 383491772 usecs = 10938 KB/s
4295491592 bytes / 387702201 usecs = 10819 KB/s
4295491592 bytes / 390119188 usecs = 10752 KB/s
4295491592 bytes / 383563249 usecs = 10936 KB/s
4295491592 bytes / 390200147 usecs = 10750 KB/s
4295491592 bytes / 382625571 usecs = 10963 KB/s
4295491592 bytes / 401658795 usecs = 10443 KB/s
4295491592 bytes / 400609892 usecs = 10471 KB/s
4295491592 bytes / 401718791 usecs = 10442 KB/s
4295491592 bytes / 401785826 usecs = 10440 KB/s
4295491592 bytes / 401785956 usecs = 10440 KB/s
4295491592 bytes / 387925234 usecs = 10813 KB/s
4295491592 bytes / 401847351 usecs = 10438 KB/s
4295491592 bytes / 382892822 usecs = 10955 KB/s
4295491592 bytes / 390273676 usecs = 10748 KB/s
4295491592 bytes / 390283067 usecs = 10748 KB/s
4295491592 bytes / 390325865 usecs = 10746 KB/s
4295491592 bytes / 391494211 usecs = 10714 KB/s
4295491592 bytes / 401997047 usecs = 10434 KB/s
4295491592 bytes / 391501718 usecs = 10714 KB/s
4295491592 bytes / 401991194 usecs = 10435 KB/s
4295491592 bytes / 382987264 usecs = 10952 KB/s
4295491592 bytes / 391409404 usecs = 10717 KB/s
4295491592 bytes / 402103059 usecs = 10432 KB/s
4295491592 bytes / 391692637 usecs = 10709 KB/s
4295491592 bytes / 386303794 usecs = 10858 KB/s
4295491592 bytes / 384092016 usecs = 10921 KB/s
4295491592 bytes / 392922350 usecs = 10675 KB/s
4295491592 bytes / 383221100 usecs = 10946 KB/s
4295491592 bytes / 389003852 usecs = 10783 KB/s
4295491592 bytes / 383360386 usecs = 10942 KB/s
4295491592 bytes / 383395475 usecs = 10941 KB/s
4295491592 bytes / 391817104 usecs = 10706 KB/s
4295491592 bytes / 383360813 usecs = 10942 KB/s
4295491592 bytes / 402512361 usecs = 10421 KB/s
4296015880 bytes / 407587047 usecs = 10293 KB/s
4295491592 bytes / 402509916 usecs = 10421 KB/s
4295491592 bytes / 391845346 usecs = 10705 KB/s
4295491592 bytes / 386689372 usecs = 10848 KB/s
4295491592 bytes / 383494556 usecs = 10938 KB/s
4295491592 bytes / 391040857 usecs = 10727 KB/s
4295491592 bytes / 389486973 usecs = 10770 KB/s
4296015880 bytes / 383711450 usecs = 10933 KB/s
4295491592 bytes / 391358305 usecs = 10718 KB/s
4295491592 bytes / 391577792 usecs = 10712 KB/s
4312268808 bytes / 408248437 usecs = 10315 KB/s
4295491592 bytes / 402847979 usecs = 10412 KB/s
4295491592 bytes / 382324819 usecs = 10971 KB/s
4295491592 bytes / 392293122 usecs = 10693 KB/s
4295491592 bytes / 391453043 usecs = 10716 KB/s
4295491592 bytes / 391413229 usecs = 10717 KB/s
4295491592 bytes / 393621776 usecs = 10656 KB/s
4295491592 bytes / 392327764 usecs = 10692 KB/s
4295491592 bytes / 389036292 usecs = 10782 KB/s
4295491592 bytes / 387090907 usecs = 10836 KB/s
4295491592 bytes / 401863280 usecs = 10438 KB/s
4295491592 bytes / 401865566 usecs = 10438 KB/s
4295491592 bytes / 391715222 usecs = 10708 KB/s
4295491592 bytes / 384965333 usecs = 10896 KB/s
4295491592 bytes / 389220270 usecs = 10777 KB/s
4295491592 bytes / 392462388 usecs = 10688 KB/s
4295491592 bytes / 392558193 usecs = 10685 KB/s
4295491592 bytes / 403123763 usecs = 10405 KB/s
4295491592 bytes / 384196845 usecs = 10918 KB/s
4295491592 bytes / 403259802 usecs = 10402 KB/s
4295491592 bytes / 391825164 usecs = 10705 KB/s
4295491592 bytes / 404575420 usecs = 10368 KB/s
4295491592 bytes / 392034044 usecs = 10700 KB/s
4295491592 bytes / 392098834 usecs = 10698 KB/s
4295491592 bytes / 403372718 usecs = 10399 KB/s
4295491592 bytes / 387532401 usecs = 10824 KB/s
4295491592 bytes / 394119016 usecs = 10643 KB/s
4295491592 bytes / 397721720 usecs = 10547 KB/s
4295491592 bytes / 385364477 usecs = 10885 KB/s
4295491592 bytes / 382964314 usecs = 10953 KB/s
4295491592 bytes / 391204789 usecs = 10722 KB/s
4295491592 bytes / 390306590 usecs = 10747 KB/s
4295491592 bytes / 387829797 usecs = 10816 KB/s
4295491592 bytes / 390427017 usecs = 10744 KB/s
4295491592 bytes / 393079773 usecs = 10671 KB/s
4295491592 bytes / 383216381 usecs = 10946 KB/s
4295491592 bytes / 384726500 usecs = 10903 KB/s
4295491592 bytes / 402733065 usecs = 10415 KB/s
4295491592 bytes / 384790091 usecs = 10901 KB/s
4295491592 bytes / 388019402 usecs = 10810 KB/s
4295491592 bytes / 403988752 usecs = 10383 KB/s
4295491592 bytes / 384967286 usecs = 10896 KB/s
4295491592 bytes / 392798802 usecs = 10679 KB/s
4295491592 bytes / 392804018 usecs = 10679 KB/s
4295491592 bytes / 390786106 usecs = 10734 KB/s
4295491592 bytes / 402959818 usecs = 10410 KB/s
4295491592 bytes / 393512413 usecs = 10659 KB/s
4295491592 bytes / 393534421 usecs = 10659 KB/s
4295491592 bytes / 391817709 usecs = 10706 KB/s
4295491592 bytes / 390314399 usecs = 10747 KB/s
4295491592 bytes / 404181889 usecs = 10378 KB/s
4295491592 bytes / 390963971 usecs = 10729 KB/s
4295491592 bytes / 398302273 usecs = 10531 KB/s
4295491592 bytes / 395065645 usecs = 10618 KB/s
4295491592 bytes / 385358417 usecs = 10885 KB/s
4295491592 bytes / 391141966 usecs = 10724 KB/s
4295491592 bytes / 393789278 usecs = 10652 KB/s
4295491592 bytes / 386437628 usecs = 10855 KB/s
4295491592 bytes / 387988103 usecs = 10811 KB/s
4295491592 bytes / 404513591 usecs = 10370 KB/s
4295491592 bytes / 393328711 usecs = 10664 KB/s
4295491592 bytes / 395324808 usecs = 10611 KB/s
4295491592 bytes / 404588951 usecs = 10368 KB/s
4295491592 bytes / 404683002 usecs = 10365 KB/s
4295491592 bytes / 393244962 usecs = 10667 KB/s
4295491592 bytes / 393631348 usecs = 10656 KB/s
4295491592 bytes / 398962582 usecs = 10514 KB/s
4295491592 bytes / 384377210 usecs = 10913 KB/s
4295491592 bytes / 384388552 usecs = 10912 KB/s
4295491592 bytes / 394358460 usecs = 10637 KB/s
4295491592 bytes / 384484404 usecs = 10910 KB/s
4295491592 bytes / 393591359 usecs = 10657 KB/s
4295491592 bytes / 392732755 usecs = 10681 KB/s
4295491592 bytes / 393639205 usecs = 10656 KB/s
4296015880 bytes / 393668418 usecs = 10657 KB/s
4295491592 bytes / 394652497 usecs = 10629 KB/s
4295491592 bytes / 394607139 usecs = 10630 KB/s
4295491592 bytes / 394608893 usecs = 10630 KB/s
4295491592 bytes / 386261357 usecs = 10860 KB/s
4295491592 bytes / 396075022 usecs = 10590 KB/s
4295491592 bytes / 396084695 usecs = 10590 KB/s
4295491592 bytes / 394145647 usecs = 10642 KB/s
4295491592 bytes / 394003639 usecs = 10646 KB/s
4295491592 bytes / 389001971 usecs = 10783 KB/s
4295491592 bytes / 389677001 usecs = 10764 KB/s
4295491592 bytes / 389010135 usecs = 10783 KB/s
4295491592 bytes / 394100711 usecs = 10644 KB/s
4295491592 bytes / 394915945 usecs = 10622 KB/s
4295491592 bytes / 395010693 usecs = 10619 KB/s
4295491592 bytes / 394181434 usecs = 10641 KB/s
4295491592 bytes / 394982919 usecs = 10620 KB/s
4295491592 bytes / 394936388 usecs = 10621 KB/s
4295491592 bytes / 394039092 usecs = 10645 KB/s
4295491592 bytes / 391769724 usecs = 10707 KB/s
4295491592 bytes / 389164368 usecs = 10779 KB/s
4295491592 bytes / 389166004 usecs = 10778 KB/s
4295491592 bytes / 391842022 usecs = 10705 KB/s
4295491592 bytes / 396472963 usecs = 10580 KB/s
4295491592 bytes / 394147503 usecs = 10642 KB/s
4295491592 bytes / 395114434 usecs = 10616 KB/s
4295491592 bytes / 385225806 usecs = 10889 KB/s
4295491592 bytes / 396574506 usecs = 10577 KB/s
4295491592 bytes / 395395963 usecs = 10609 KB/s
4295491592 bytes / 391975630 usecs = 10701 KB/s
4295491592 bytes / 391993624 usecs = 10701 KB/s
4295491592 bytes / 395247352 usecs = 10613 KB/s
4295491592 bytes / 394520143 usecs = 10632 KB/s
4295491592 bytes / 392094579 usecs = 10698 KB/s
4295491592 bytes / 394557650 usecs = 10631 KB/s
4295491592 bytes / 394707837 usecs = 10627 KB/s
4295491592 bytes / 385500324 usecs = 10881 KB/s
4295491592 bytes / 385502150 usecs = 10881 KB/s
4295491592 bytes / 388073401 usecs = 10809 KB/s
4295491592 bytes / 385638143 usecs = 10877 KB/s
4295491592 bytes / 394988088 usecs = 10620 KB/s
4295491592 bytes / 392968841 usecs = 10674 KB/s
4295491592 bytes / 389724656 usecs = 10763 KB/s
4295491592 bytes / 393927345 usecs = 10648 KB/s
4295491592 bytes / 389737932 usecs = 10763 KB/s
4295491592 bytes / 395590164 usecs = 10603 KB/s
4295491592 bytes / 385753983 usecs = 10874 KB/s
4295491592 bytes / 387253108 usecs = 10832 KB/s
4295491592 bytes / 387332036 usecs = 10830 KB/s
4295491592 bytes / 388235838 usecs = 10804 KB/s
4295491592 bytes / 388280968 usecs = 10803 KB/s
4295491592 bytes / 395910203 usecs = 10595 KB/s
4295491592 bytes / 392503163 usecs = 10687 KB/s
4295491592 bytes / 392503691 usecs = 10687 KB/s
4295491592 bytes / 390578589 usecs = 10740 KB/s
4295491592 bytes / 397161890 usecs = 10561 KB/s
4295491592 bytes / 395800321 usecs = 10598 KB/s
4295491592 bytes / 395814954 usecs = 10597 KB/s
4295491592 bytes / 406495329 usecs = 10319 KB/s
4295491592 bytes / 387483184 usecs = 10825 KB/s
4295491592 bytes / 397260645 usecs = 10559 KB/s
4295491592 bytes / 390032399 usecs = 10755 KB/s
4295491592 bytes / 387594440 usecs = 10822 KB/s
4295491592 bytes / 406607644 usecs = 10316 KB/s
4295491592 bytes / 397346449 usecs = 10557 KB/s
4295491592 bytes / 386141428 usecs = 10863 KB/s
4295491592 bytes / 397412736 usecs = 10555 KB/s
4295491592 bytes / 396260252 usecs = 10586 KB/s
4295491592 bytes / 387788164 usecs = 10817 KB/s
4295491592 bytes / 406767771 usecs = 10312 KB/s
4295491592 bytes / 387764493 usecs = 10817 KB/s
4295491592 bytes / 395207882 usecs = 10614 KB/s
4295491592 bytes / 395218708 usecs = 10613 KB/s
4295491592 bytes / 396165687 usecs = 10588 KB/s
4295491592 bytes / 395260363 usecs = 10612 KB/s
4295491592 bytes / 406872169 usecs = 10309 KB/s
4295491592 bytes / 397625210 usecs = 10549 KB/s
4295491592 bytes / 388845042 usecs = 10787 KB/s
4295491592 bytes / 395303980 usecs = 10611 KB/s
4295491592 bytes / 396302990 usecs = 10584 KB/s
4295491592 bytes / 395746639 usecs = 10599 KB/s
4295491592 bytes / 388033410 usecs = 10810 KB/s
4295491592 bytes / 391232508 usecs = 10722 KB/s
4295491592 bytes / 393819859 usecs = 10651 KB/s
4295491592 bytes / 395669927 usecs = 10601 KB/s
4295491592 bytes / 393890180 usecs = 10649 KB/s
4295491592 bytes / 388208639 usecs = 10805 KB/s
4295491592 bytes / 395890423 usecs = 10595 KB/s
4295491592 bytes / 393988556 usecs = 10647 KB/s
4295491592 bytes / 396582776 usecs = 10577 KB/s
4295491592 bytes / 394034504 usecs = 10645 KB/s
4295491592 bytes / 388353939 usecs = 10801 KB/s
4295491592 bytes / 391505333 usecs = 10714 KB/s
4295491592 bytes / 395054256 usecs = 10618 KB/s
4295491592 bytes / 390883879 usecs = 10731 KB/s
4295491592 bytes / 389345650 usecs = 10774 KB/s
4295491592 bytes / 388455673 usecs = 10798 KB/s
4295491592 bytes / 386928937 usecs = 10841 KB/s
4295491592 bytes / 396837368 usecs = 10570 KB/s
4295491592 bytes / 388527476 usecs = 10796 KB/s
4295491592 bytes / 388530769 usecs = 10796 KB/s
4295491592 bytes / 386980884 usecs = 10839 KB/s
4295491592 bytes / 388577228 usecs = 10795 KB/s
4295491592 bytes / 391029122 usecs = 10727 KB/s
4295491592 bytes / 396894428 usecs = 10569 KB/s
4295491592 bytes / 388621755 usecs = 10794 KB/s
4295491592 bytes / 391069739 usecs = 10726 KB/s
4295491592 bytes / 407616083 usecs = 10291 KB/s
4295491592 bytes / 398338749 usecs = 10530 KB/s
4295491592 bytes / 387107250 usecs = 10836 KB/s
4295491592 bytes / 396425900 usecs = 10581 KB/s
4295491592 bytes / 397249755 usecs = 10559 KB/s
4295491592 bytes / 398429576 usecs = 10528 KB/s
4295491592 bytes / 391197675 usecs = 10723 KB/s
4295491592 bytes / 387196800 usecs = 10833 KB/s
4295491592 bytes / 398499518 usecs = 10526 KB/s
4295491592 bytes / 391260468 usecs = 10721 KB/s
4295491592 bytes / 398517221 usecs = 10526 KB/s
4295491592 bytes / 396256922 usecs = 10586 KB/s
4295491592 bytes / 397241544 usecs = 10559 KB/s
4295491592 bytes / 396278446 usecs = 10585 KB/s
4295491592 bytes / 388926388 usecs = 10785 KB/s
4295491592 bytes / 396289244 usecs = 10585 KB/s
4295491592 bytes / 394019125 usecs = 10646 KB/s
4295491592 bytes / 396315274 usecs = 10584 KB/s
4295491592 bytes / 397496478 usecs = 10553 KB/s
4295491592 bytes / 397312307 usecs = 10557 KB/s
4295491592 bytes / 395682822 usecs = 10601 KB/s
4295491592 bytes / 394751748 usecs = 10626 KB/s
4295491592 bytes / 394756542 usecs = 10626 KB/s
4295491592 bytes / 389067187 usecs = 10781 KB/s
4295491592 bytes / 397464808 usecs = 10553 KB/s
4295491592 bytes / 397464901 usecs = 10553 KB/s
4295491592 bytes / 396437945 usecs = 10581 KB/s
4295491592 bytes / 397588572 usecs = 10550 KB/s
4295491592 bytes / 389980896 usecs = 10756 KB/s
4295491592 bytes / 398799890 usecs = 10518 KB/s
4295491592 bytes / 394820702 usecs = 10624 KB/s
4295491592 bytes / 389120019 usecs = 10780 KB/s
4295491592 bytes / 391566233 usecs = 10712 KB/s
4295491592 bytes / 394844987 usecs = 10623 KB/s
4295491592 bytes / 396516487 usecs = 10579 KB/s
4295491592 bytes / 396660834 usecs = 10575 KB/s
4295491592 bytes / 396551688 usecs = 10578 KB/s
4295491592 bytes / 398950096 usecs = 10514 KB/s
4295491592 bytes / 397592202 usecs = 10550 KB/s
4295491592 bytes / 397006835 usecs = 10566 KB/s
4295491592 bytes / 391757083 usecs = 10707 KB/s
4295491592 bytes / 394400482 usecs = 10635 KB/s
4295491592 bytes / 399085954 usecs = 10511 KB/s
4295491592 bytes / 397815302 usecs = 10544 KB/s
4295491592 bytes / 397820492 usecs = 10544 KB/s
4295491592 bytes / 389432333 usecs = 10771 KB/s
4295491592 bytes / 395160735 usecs = 10615 KB/s
4295491592 bytes / 397852848 usecs = 10543 KB/s
4295491592 bytes / 391933268 usecs = 10702 KB/s
4295491592 bytes / 397768054 usecs = 10545 KB/s
4295491592 bytes / 397887437 usecs = 10542 KB/s
4295491592 bytes / 394609631 usecs = 10630 KB/s
4295491592 bytes / 391968326 usecs = 10701 KB/s
4295491592 bytes / 395246192 usecs = 10613 KB/s
4295491592 bytes / 389465458 usecs = 10770 KB/s
4295491592 bytes / 396927774 usecs = 10568 KB/s
4295491592 bytes / 390469380 usecs = 10743 KB/s
4295491592 bytes / 397880937 usecs = 10542 KB/s
4295491592 bytes / 388033079 usecs = 10810 KB/s
4295491592 bytes / 395333572 usecs = 10610 KB/s
4295491592 bytes / 395379032 usecs = 10609 KB/s
4295491592 bytes / 397958364 usecs = 10540 KB/s
4295491592 bytes / 397065359 usecs = 10564 KB/s
4295491592 bytes / 397066357 usecs = 10564 KB/s
4295491592 bytes / 395417430 usecs = 10608 KB/s
4295491592 bytes / 395431021 usecs = 10608 KB/s
4295491592 bytes / 389673613 usecs = 10764 KB/s
4295491592 bytes / 392878127 usecs = 10677 KB/s
4295491592 bytes / 398050018 usecs = 10538 KB/s
4295491592 bytes / 397519181 usecs = 10552 KB/s
4295491592 bytes / 390712557 usecs = 10736 KB/s
4295491592 bytes / 390714827 usecs = 10736 KB/s
4295491592 bytes / 395536345 usecs = 10605 KB/s
4295491592 bytes / 398347775 usecs = 10530 KB/s
4295491592 bytes / 389800684 usecs = 10761 KB/s
4295491592 bytes / 397513882 usecs = 10552 KB/s
4295491592 bytes / 388423434 usecs = 10799 KB/s
4295491592 bytes / 396637965 usecs = 10575 KB/s
4295491592 bytes / 389935085 usecs = 10757 KB/s
4295491592 bytes / 395743981 usecs = 10599 KB/s
4295491592 bytes / 397577480 usecs = 10550 KB/s
4295491592 bytes / 398332337 usecs = 10530 KB/s
4295491592 bytes / 398337313 usecs = 10530 KB/s
4295491592 bytes / 396704751 usecs = 10574 KB/s
4295491592 bytes / 391010561 usecs = 10728 KB/s
4295491592 bytes / 396753060 usecs = 10572 KB/s
4295491592 bytes / 398405511 usecs = 10529 KB/s
4295491592 bytes / 391067057 usecs = 10726 KB/s
4295491592 bytes / 391067866 usecs = 10726 KB/s
4295491592 bytes / 392629725 usecs = 10683 KB/s
4295491592 bytes / 390210866 usecs = 10750 KB/s
4295491592 bytes / 395924284 usecs = 10594 KB/s
4295491592 bytes / 390239356 usecs = 10749 KB/s
4295491592 bytes / 396885212 usecs = 10569 KB/s
4295491592 bytes / 395335339 usecs = 10610 KB/s
4295491592 bytes / 396895686 usecs = 10569 KB/s
4295491592 bytes / 390263268 usecs = 10748 KB/s
4295491592 bytes / 398546571 usecs = 10525 KB/s
4295491592 bytes / 397754748 usecs = 10546 KB/s
4295491592 bytes / 398556699 usecs = 10525 KB/s
4295491592 bytes / 390224388 usecs = 10749 KB/s
4295491592 bytes / 397697519 usecs = 10547 KB/s
4295491592 bytes / 392789344 usecs = 10679 KB/s
4295491592 bytes / 397714337 usecs = 10547 KB/s
4295491592 bytes / 397050715 usecs = 10564 KB/s
4295491592 bytes / 397051932 usecs = 10564 KB/s
4295491592 bytes / 391316341 usecs = 10719 KB/s
4295491592 bytes / 391319154 usecs = 10719 KB/s
4295491592 bytes / 395507726 usecs = 10606 KB/s
4295491592 bytes / 390458037 usecs = 10743 KB/s
4295491592 bytes / 396177046 usecs = 10588 KB/s
4295491592 bytes / 390478664 usecs = 10742 KB/s
4295491592 bytes / 391406456 usecs = 10717 KB/s
4295491592 bytes / 390566121 usecs = 10740 KB/s
4295491592 bytes / 398847327 usecs = 10517 KB/s
4295491592 bytes / 398100904 usecs = 10537 KB/s
4295491592 bytes / 397966042 usecs = 10540 KB/s
4295491592 bytes / 398098526 usecs = 10537 KB/s
4295491592 bytes / 396356910 usecs = 10583 KB/s
4295491592 bytes / 398158077 usecs = 10535 KB/s
4295491592 bytes / 398169560 usecs = 10535 KB/s
4295491592 bytes / 390688708 usecs = 10736 KB/s
4295491592 bytes / 393149122 usecs = 10669 KB/s
4295491592 bytes / 395791695 usecs = 10598 KB/s
4295491592 bytes / 398234042 usecs = 10533 KB/s
4295491592 bytes / 397353425 usecs = 10556 KB/s
4295491592 bytes / 398990069 usecs = 10513 KB/s
4295491592 bytes / 393172955 usecs = 10669 KB/s
4295491592 bytes / 396432939 usecs = 10581 KB/s
4295491592 bytes / 391634744 usecs = 10711 KB/s
4295491592 bytes / 391634857 usecs = 10711 KB/s
4295491592 bytes / 396438519 usecs = 10581 KB/s
4295491592 bytes / 393209108 usecs = 10668 KB/s
4295491592 bytes / 391689158 usecs = 10709 KB/s
4295491592 bytes / 399082244 usecs = 10511 KB/s
4295491592 bytes / 393260146 usecs = 10666 KB/s
4295491592 bytes / 398558575 usecs = 10524 KB/s
4295491592 bytes / 398370480 usecs = 10529 KB/s
4295491592 bytes / 399240599 usecs = 10506 KB/s
4295491592 bytes / 398225638 usecs = 10533 KB/s
4295491592 bytes / 398405853 usecs = 10529 KB/s
4295491592 bytes / 398420172 usecs = 10528 KB/s
4295491592 bytes / 399195725 usecs = 10508 KB/s
4295491592 bytes / 390844052 usecs = 10732 KB/s
4295491592 bytes / 400615305 usecs = 10470 KB/s
4295491592 bytes / 398458596 usecs = 10527 KB/s
4295491592 bytes / 398663359 usecs = 10522 KB/s
4295491592 bytes / 398467351 usecs = 10527 KB/s
4295491592 bytes / 399244216 usecs = 10506 KB/s
4295491592 bytes / 396678567 usecs = 10574 KB/s
4295491592 bytes / 391016881 usecs = 10727 KB/s
4295491592 bytes / 398536728 usecs = 10525 KB/s
4295491592 bytes / 398583917 usecs = 10524 KB/s
4295491592 bytes / 398573494 usecs = 10524 KB/s
4295491592 bytes / 392024064 usecs = 10700 KB/s
4295491592 bytes / 398606732 usecs = 10523 KB/s
4295491592 bytes / 398650857 usecs = 10522 KB/s
4295491592 bytes / 398634636 usecs = 10522 KB/s
4295491592 bytes / 392055101 usecs = 10699 KB/s
4295491592 bytes / 396256608 usecs = 10586 KB/s
4295491592 bytes / 398714723 usecs = 10520 KB/s
4295491592 bytes / 396916939 usecs = 10568 KB/s
4295491592 bytes / 396918406 usecs = 10568 KB/s
4295491592 bytes / 398593438 usecs = 10524 KB/s
4295491592 bytes / 398607276 usecs = 10523 KB/s
4295491592 bytes / 392169213 usecs = 10696 KB/s
4295491592 bytes / 394385595 usecs = 10636 KB/s
4295491592 bytes / 391196387 usecs = 10723 KB/s
4295491592 bytes / 398805920 usecs = 10518 KB/s
4295491592 bytes / 392203906 usecs = 10695 KB/s
4295491592 bytes / 399717218 usecs = 10494 KB/s
4295491592 bytes / 394444658 usecs = 10634 KB/s
4295491592 bytes / 391251995 usecs = 10721 KB/s
4295491592 bytes / 398704453 usecs = 10521 KB/s
4295491592 bytes / 398745829 usecs = 10520 KB/s
4295491592 bytes / 393846944 usecs = 10650 KB/s
4295491592 bytes / 399824542 usecs = 10491 KB/s
4295491592 bytes / 391360763 usecs = 10718 KB/s
4295491592 bytes / 398086034 usecs = 10537 KB/s
4295491592 bytes / 398086398 usecs = 10537 KB/s
4295491592 bytes / 398974682 usecs = 10513 KB/s
4295491592 bytes / 397170782 usecs = 10561 KB/s
4295491592 bytes / 391465634 usecs = 10715 KB/s
4295491592 bytes / 397251197 usecs = 10559 KB/s
4295491592 bytes / 397252522 usecs = 10559 KB/s
4295491592 bytes / 399096987 usecs = 10510 KB/s
4295491592 bytes / 394046773 usecs = 10645 KB/s
4295491592 bytes / 399884831 usecs = 10490 KB/s
4295491592 bytes / 394731411 usecs = 10627 KB/s
4296015880 bytes / 394075475 usecs = 10646 KB/s
4295491592 bytes / 401349010 usecs = 10451 KB/s
4295491592 bytes / 394830446 usecs = 10624 KB/s
4295491592 bytes / 400015595 usecs = 10486 KB/s
4295491592 bytes / 400139932 usecs = 10483 KB/s
4295491592 bytes / 394876495 usecs = 10623 KB/s
4295491592 bytes / 398413581 usecs = 10528 KB/s
4295491592 bytes / 399160988 usecs = 10509 KB/s
4295491592 bytes / 399349497 usecs = 10504 KB/s
4295491592 bytes / 400227932 usecs = 10481 KB/s
4295491592 bytes / 401526054 usecs = 10447 KB/s
4295491592 bytes / 400125561 usecs = 10483 KB/s
4295491592 bytes / 399384678 usecs = 10503 KB/s
4295491592 bytes / 399233341 usecs = 10507 KB/s
4295491592 bytes / 401563740 usecs = 10446 KB/s
4295491592 bytes / 399404309 usecs = 10502 KB/s
4295491592 bytes / 394999631 usecs = 10619 KB/s
4295491592 bytes / 399369652 usecs = 10503 KB/s
4295491592 bytes / 399383729 usecs = 10503 KB/s
4295491592 bytes / 399265047 usecs = 10506 KB/s
4295491592 bytes / 399404901 usecs = 10502 KB/s
4295491592 bytes / 401637616 usecs = 10444 KB/s
4295491592 bytes / 399484466 usecs = 10500 KB/s
4295491592 bytes / 399364766 usecs = 10503 KB/s
4295491592 bytes / 400401253 usecs = 10476 KB/s
4295491592 bytes / 399492172 usecs = 10500 KB/s
4295491592 bytes / 395150130 usecs = 10615 KB/s
4295491592 bytes / 401735247 usecs = 10441 KB/s
4295491592 bytes / 400444181 usecs = 10475 KB/s
4295491592 bytes / 398691790 usecs = 10521 KB/s
4295491592 bytes / 398703332 usecs = 10521 KB/s
4295491592 bytes / 399425355 usecs = 10502 KB/s
4295491592 bytes / 399438546 usecs = 10501 KB/s
4295491592 bytes / 397790156 usecs = 10545 KB/s
4295491592 bytes / 399584031 usecs = 10497 KB/s
4295491592 bytes / 400559866 usecs = 10472 KB/s
4295491592 bytes / 398840029 usecs = 10517 KB/s
4295491592 bytes / 401891460 usecs = 10437 KB/s
4295491592 bytes / 394691563 usecs = 10628 KB/s
4295491592 bytes / 390676371 usecs = 10737 KB/s
4295491592 bytes / 392193136 usecs = 10695 KB/s
4295491592 bytes / 395398312 usecs = 10609 KB/s
4295491592 bytes / 395409208 usecs = 10608 KB/s
4295491592 bytes / 400575330 usecs = 10471 KB/s
4295491592 bytes / 392299895 usecs = 10692 KB/s
4295491592 bytes / 393209082 usecs = 10668 KB/s
4295491592 bytes / 399839492 usecs = 10491 KB/s
4295491592 bytes / 393236509 usecs = 10667 KB/s
4295491592 bytes / 395456433 usecs = 10607 KB/s
4295491592 bytes / 399829944 usecs = 10491 KB/s
4295491592 bytes / 402054429 usecs = 10433 KB/s
4295491592 bytes / 400776235 usecs = 10466 KB/s
4295491592 bytes / 392306164 usecs = 10692 KB/s
4295491592 bytes / 399052119 usecs = 10511 KB/s
4295491592 bytes / 399066683 usecs = 10511 KB/s
4295491592 bytes / 393330862 usecs = 10664 KB/s
4295491592 bytes / 402122423 usecs = 10431 KB/s
4295491592 bytes / 393363081 usecs = 10663 KB/s
4295491592 bytes / 402160207 usecs = 10430 KB/s
4295491592 bytes / 399954631 usecs = 10488 KB/s
4295491592 bytes / 402169721 usecs = 10430 KB/s
4295491592 bytes / 392481056 usecs = 10687 KB/s
4295491592 bytes / 402187150 usecs = 10430 KB/s
4295491592 bytes / 393399629 usecs = 10662 KB/s
4295491592 bytes / 392498708 usecs = 10687 KB/s
4295491592 bytes / 392502741 usecs = 10687 KB/s
4295491592 bytes / 395623723 usecs = 10603 KB/s
4295491592 bytes / 393425902 usecs = 10662 KB/s
4295491592 bytes / 400800906 usecs = 10466 KB/s
4295491592 bytes / 400826299 usecs = 10465 KB/s
4295491592 bytes / 390983396 usecs = 10728 KB/s
4295491592 bytes / 400979137 usecs = 10461 KB/s
4295491592 bytes / 391015469 usecs = 10728 KB/s
4295491592 bytes / 392596008 usecs = 10684 KB/s
4295491592 bytes / 395717350 usecs = 10600 KB/s
4295491592 bytes / 393506241 usecs = 10660 KB/s
4295491592 bytes / 402294760 usecs = 10427 KB/s
4295491592 bytes / 401011120 usecs = 10460 KB/s
4295491592 bytes / 393521602 usecs = 10659 KB/s
4295491592 bytes / 399293249 usecs = 10505 KB/s
4295491592 bytes / 400155046 usecs = 10482 KB/s
4295491592 bytes / 391102930 usecs = 10725 KB/s
4295491592 bytes / 400160101 usecs = 10482 KB/s
4295491592 bytes / 400067538 usecs = 10485 KB/s
4295491592 bytes / 400076108 usecs = 10485 KB/s
4295491592 bytes / 402413372 usecs = 10424 KB/s
4295491592 bytes / 401115916 usecs = 10457 KB/s
4295491592 bytes / 402438072 usecs = 10423 KB/s
4295491592 bytes / 391175794 usecs = 10723 KB/s
4295491592 bytes / 391175826 usecs = 10723 KB/s
4295491592 bytes / 392671341 usecs = 10682 KB/s
4295491592 bytes / 401147415 usecs = 10457 KB/s
4295491592 bytes / 401162486 usecs = 10456 KB/s
4295491592 bytes / 400257034 usecs = 10480 KB/s
4295491592 bytes / 392697835 usecs = 10682 KB/s
4295491592 bytes / 401179187 usecs = 10456 KB/s
4295491592 bytes / 391216442 usecs = 10722 KB/s
4295491592 bytes / 400316063 usecs = 10478 KB/s
4295491592 bytes / 392802805 usecs = 10679 KB/s
4295491592 bytes / 395930414 usecs = 10594 KB/s
4295491592 bytes / 392740605 usecs = 10680 KB/s
4295491592 bytes / 402525880 usecs = 10421 KB/s
4295491592 bytes / 392767217 usecs = 10680 KB/s
4295491592 bytes / 402538553 usecs = 10420 KB/s
4295491592 bytes / 395975137 usecs = 10593 KB/s
4295491592 bytes / 391289661 usecs = 10720 KB/s
4295491592 bytes / 395984597 usecs = 10593 KB/s
4295491592 bytes / 400396000 usecs = 10476 KB/s
4295491592 bytes / 392842952 usecs = 10678 KB/s
4295491592 bytes / 396042201 usecs = 10591 KB/s
4295491592 bytes / 399566210 usecs = 10498 KB/s
4295491592 bytes / 402638108 usecs = 10418 KB/s
4295491592 bytes / 400476192 usecs = 10474 KB/s
4295491592 bytes / 391381827 usecs = 10717 KB/s
4295491592 bytes / 400488019 usecs = 10474 KB/s
4295491592 bytes / 395414946 usecs = 10608 KB/s
4295491592 bytes / 391400966 usecs = 10717 KB/s
4295491592 bytes / 391408580 usecs = 10717 KB/s
4295491592 bytes / 392999330 usecs = 10673 KB/s
4295491592 bytes / 400548634 usecs = 10472 KB/s
4295491592 bytes / 395471979 usecs = 10607 KB/s
4295491592 bytes / 402726694 usecs = 10416 KB/s
4295491592 bytes / 395484050 usecs = 10606 KB/s
4295491592 bytes / 402736057 usecs = 10415 KB/s
4295491592 bytes / 402737235 usecs = 10415 KB/s
4295491592 bytes / 402743586 usecs = 10415 KB/s
4295491592 bytes / 396177212 usecs = 10588 KB/s
4295491592 bytes / 400424074 usecs = 10475 KB/s
4295491592 bytes / 400425897 usecs = 10475 KB/s
4295491592 bytes / 392988053 usecs = 10674 KB/s
4295491592 bytes / 402774823 usecs = 10414 KB/s
4295491592 bytes / 401481766 usecs = 10448 KB/s
4295491592 bytes / 400614100 usecs = 10470 KB/s
4295491592 bytes / 400574648 usecs = 10471 KB/s
4295491592 bytes / 401491719 usecs = 10448 KB/s
4295491592 bytes / 400626218 usecs = 10470 KB/s
4295491592 bytes / 393032527 usecs = 10672 KB/s
4295491592 bytes / 393033966 usecs = 10672 KB/s
4295491592 bytes / 400600433 usecs = 10471 KB/s
4295491592 bytes / 401524173 usecs = 10447 KB/s
4295491592 bytes / 401529744 usecs = 10447 KB/s
4295491592 bytes / 395589429 usecs = 10603 KB/s
4295491592 bytes / 400507203 usecs = 10473 KB/s
4295491592 bytes / 400673331 usecs = 10469 KB/s
4295491592 bytes / 400509965 usecs = 10473 KB/s
4295491592 bytes / 400512795 usecs = 10473 KB/s
4295491592 bytes / 400718290 usecs = 10468 KB/s
4295491592 bytes / 400730207 usecs = 10467 KB/s
4295491592 bytes / 393126676 usecs = 10670 KB/s
4295491592 bytes / 400731061 usecs = 10467 KB/s
4295491592 bytes / 391631828 usecs = 10711 KB/s
4295491592 bytes / 401601179 usecs = 10445 KB/s
4295491592 bytes / 391641931 usecs = 10710 KB/s
4295491592 bytes / 400698924 usecs = 10468 KB/s
4295491592 bytes / 400699532 usecs = 10468 KB/s
4295491592 bytes / 393144341 usecs = 10669 KB/s
4295491592 bytes / 400749350 usecs = 10467 KB/s
4295491592 bytes / 393145963 usecs = 10669 KB/s
4295491592 bytes / 391657644 usecs = 10710 KB/s
4295491592 bytes / 400714287 usecs = 10468 KB/s
4295491592 bytes / 393159856 usecs = 10669 KB/s
4295491592 bytes / 400747561 usecs = 10467 KB/s
4295491592 bytes / 400753054 usecs = 10467 KB/s
4295491592 bytes / 400758246 usecs = 10467 KB/s
4295491592 bytes / 391702853 usecs = 10709 KB/s
4295491592 bytes / 391704739 usecs = 10709 KB/s
4295491592 bytes / 401676177 usecs = 10443 KB/s
4295491592 bytes / 400767622 usecs = 10466 KB/s
4295491592 bytes / 393209172 usecs = 10668 KB/s
4295491592 bytes / 400771560 usecs = 10466 KB/s
4295491592 bytes / 391717430 usecs = 10708 KB/s
4295491592 bytes / 391722814 usecs = 10708 KB/s
4295491592 bytes / 391727884 usecs = 10708 KB/s
4295491592 bytes / 393225432 usecs = 10667 KB/s
4295491592 bytes / 391730934 usecs = 10708 KB/s
4295491592 bytes / 400834066 usecs = 10465 KB/s
4295491592 bytes / 393231176 usecs = 10667 KB/s
4295491592 bytes / 400837290 usecs = 10465 KB/s
4295491592 bytes / 400797902 usecs = 10466 KB/s
4295491592 bytes / 393238316 usecs = 10667 KB/s
4295491592 bytes / 391744661 usecs = 10708 KB/s
4295491592 bytes / 400813873 usecs = 10465 KB/s
4295491592 bytes / 391760592 usecs = 10707 KB/s
4295491592 bytes / 400818069 usecs = 10465 KB/s
4295491592 bytes / 400828196 usecs = 10465 KB/s
4295491592 bytes / 393267337 usecs = 10666 KB/s
4295491592 bytes / 393272287 usecs = 10666 KB/s
4295491592 bytes / 393289377 usecs = 10665 KB/s
4295491592 bytes / 393306578 usecs = 10665 KB/s
2014-10-03 01:34:26 umount /tmp/vm-scalability-tmp
2014-10-03 01:34:26 umount /tmp/vm-scalability
2014-10-03 01:34:26 rm /tmp/vm-scalability.img
geting new job...

==> /lkp/lkp/src/tmp/err_log <==
2014-10-03 01:34:39 URL:http://inn/~lkp/cgi-bin/gpxelinux.cgi?hostname=lkp-nex06&lkp_wtmp [1210] -> "/tmp/next-job-lkp" [1]

==> /lkp/lkp/src/tmp/run_log <==
downloading kernel image ...

==> /lkp/lkp/src/tmp/err_log <==
2014-10-03 01:34:40 URL:http://inn/~lkp//kernel/x86_64-rhel/fe82dcec644244676d55a1384c958d5f67979adb/vmlinuz-3.17.0-rc7 [6576560/6576560] -> "/tmp//kernel/x86_64-rhel/fe82dcec644244676d55a1384c958d5f67979adb/vmlinuz-3.17.0-rc7" [1]

==> /lkp/lkp/src/tmp/run_log <==
downloading initrds ...

==> /lkp/lkp/src/tmp/err_log <==
2014-10-03 01:34:49 URL:http://inn/~lkp//kernel-tests/initrd/debian-x86_64.cgz [101400154/101400154] -> "/tmp//kernel-tests/initrd/debian-x86_64.cgz" [1]
2014-10-03 01:34:49 URL:http://inn/~lkp//lkp/lkp/lkp-x86_64.cgz [619532/619532] -> "/tmp//lkp/lkp/lkp-x86_64.cgz" [1]
2014-10-03 01:34:49 URL:http://inn/~lkp//lkp/benchmarks/vm-scalability.cgz [48132/48132] -> "/tmp//lkp/benchmarks/vm-scalability.cgz" [1]
2014-10-03 01:34:49 URL:http://inn/~lkp//lkp/benchmarks/vm-scalability-debian.cgz [24824/24824] -> "/tmp//lkp/benchmarks/vm-scalability-debian.cgz" [1]
2014-10-03 01:34:51 URL:http://inn/~lkp//kernel/x86_64-rhel/fe82dcec644244676d55a1384c958d5f67979adb/modules.cgz [23723922/23723922] -> "/tmp//kernel/x86_64-rhel/fe82dcec644244676d55a1384c958d5f67979adb/modules.cgz" [1]

==> /lkp/lkp/src/tmp/run_log <==
kexecing...
kexec -l /tmp//kernel/x86_64-rhel/fe82dcec644244676d55a1384c958d5f67979adb/vmlinuz-3.17.0-rc7 --initrd=/tmp/initrd-13312 --append="user=lkp job=/lkp/scheduled/lkp-nex06/cyclic_vm-scalability-performance-300s-anon-r-seq-x86_64-rhel-BASE-fe82dcec644244676d55a1384c958d5f67979adb-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/fe82dcec644244676d55a1384c958d5f67979adb/vmlinuz-3.17.0-rc7 kconfig=x86_64-rhel commit=fe82dcec644244676d55a1384c958d5f67979adb branch=linux-devel/devel-hourly-2014100222 root=/dev/ram0 max_uptime=1500 RESULT_ROOT=/result/lkp-nex06/vm-scalability/performance-300s-anon-r-seq/debian-x86_64.cgz/x86_64-rhel/fe82dcec644244676d55a1384c958d5f67979adb/0 ip=::::lkp-nex06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw"

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--gatW/ieO32f1wygP--
