Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaLCCjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:39:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:50074 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaLCCjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:39:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="492669228"
Date: Wed, 3 Dec 2014 10:40:01 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [sched] WARNING: CPU: 0 PID: 13608 at kernel/sched/core.c:7323
 __might_sleep+0xbd/0xd0()
Message-ID: <20141203024001.GD10048@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 8eb23b9f35aae413140d3fda766a98092c21e9b0 ("sched: Debug nested sleeps")


+-------------------------------------------------+------------+------------+
|                                                 | 26cabd3125 | 8eb23b9f35 |
+-------------------------------------------------+------------+------------+
| boot_successes                                  | 10         | 15         |
| boot_failures                                   | 0          | 25         |
| WARNING:at_kernel/sched/core.c:__might_sleep()  | 0          | 5          |
| backtrace:SyS_read                              | 0          | 5          |
| backtrace:vfs_read                              | 0          | 5          |
| WARNING:at_kernel/sched/core.c:#__might_sleep() | 0          | 20         |
| backtrace:SyS_io_getevents                      | 0          | 10         |
| backtrace:read_events                           | 0          | 7          |
| backtrace:kauditd_thread                        | 0          | 10         |
+-------------------------------------------------+------------+------------+



<4>[  839.494114] ------------[ cut here ]------------
<4>[  839.494131] WARNING: CPU: 0 PID: 13608 at /kbuild/src/lkp/kernel/sched/core.c:7323 __might_sleep+0xbd/0xd0()
<4>[  839.494137] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff810b3fff>] prepare_to_wait+0x2f/0x90
<4>[  839.494256] Modules linked in: tun ipmi_watchdog loop btrfs xor raid6_pq sg sd_mod ast snd_pcm syscopyarea sysfillrect snd_timer sysimgblt snd ie6xx_wdt ttm i2c_isch drm_kms_helper soundcore drm ahci libahci pcspkr i2c_ismt lpc_sch ipmi_si libata shpchp ipmi_msghandler acpi_cpufreq
<4>[  839.494264] CPU: 0 PID: 13608 Comm: fanotify01 Not tainted 3.18.0-rc4-next-20141117 #1
<4>[  839.494266] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Double Cove , BIOS BWDEXT.86B.000.012.D127 10/08/2012
<4>[  839.494273]  ffffffff81b5ebb8 ffff88023cf37d18 ffffffff81892f54 0000000064026402
<4>[  839.494277]  ffff88023cf37d68 ffff88023cf37d58 ffffffff8107047a ffff88023cf37db8
<4>[  839.494281]  ffffffff81b5f5e8 0000000000000061 0000000000000000 0000000000006000
<4>[  839.494285] Call Trace:
<4>[  839.494315]  [<ffffffff81892f54>] dump_stack+0x4c/0x65
<4>[  839.494323]  [<ffffffff8107047a>] warn_slowpath_common+0x8a/0xc0
<4>[  839.494327]  [<ffffffff810704f6>] warn_slowpath_fmt+0x46/0x50
<4>[  839.494333]  [<ffffffff810b3fff>] ? prepare_to_wait+0x2f/0x90
<4>[  839.494337]  [<ffffffff810b3fff>] ? prepare_to_wait+0x2f/0x90
<4>[  839.494341]  [<ffffffff810961fd>] __might_sleep+0xbd/0xd0
<4>[  839.494348]  [<ffffffff81898974>] mutex_lock+0x24/0x50
<4>[  839.494354]  [<ffffffff812250f5>] fanotify_read+0xd5/0x620
<4>[  839.494370]  [<ffffffff8139c906>] ? selinux_file_permission+0xa6/0x120
<4>[  839.494374]  [<ffffffff810b43e0>] ? wait_woken+0xc0/0xc0
<4>[  839.494381]  [<ffffffff811e14c8>] __vfs_read+0x18/0x50
<4>[  839.494385]  [<ffffffff811e158a>] vfs_read+0x8a/0x140
<4>[  839.494390]  [<ffffffff811e1686>] SyS_read+0x46/0xb0
<4>[  839.494403]  [<ffffffff8189b629>] system_call_fastpath+0x12/0x17
<4>[  839.494409] ---[ end trace 5a2207521429f889 ]---



	--yliu

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc4-next-20141117 (kbuild@roam) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Tue Nov 18 11:46:52 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-a06/cyclic_ltp-performance-syscalls-x86_64-rhel-HEAD-efefb5ca5da52f7537c7ced03d6e53408f13a26e-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/vmlinuz-3.18.0-rc4-next-20141117 kconfig=x86_64-rhel commit=efefb5ca5da52f7537c7ced03d6e53408f13a26e branch=next/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-a06/ltp/performance-syscalls/debian-x86_64.cgz/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/0 ip=::::lkp-a06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
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
[    0.000000] BRK [0x23f1d4000, 0x23f1d4fff] PGTABLE
[    0.000000] BRK [0x23f1d5000, 0x23f1d5fff] PGTABLE
[    0.000000] BRK [0x23f1d6000, 0x23f1d6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23fe00000-0x23fffffff]
[    0.000000]  [mem 0x23fe00000-0x23fffffff] page 2M
[    0.000000] BRK [0x23f1d7000, 0x23f1d7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x23c000000-0x23fdfffff]
[    0.000000]  [mem 0x23c000000-0x23fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
[    0.000000]  [mem 0x200000000-0x23bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf67afff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf67afff] page 4k
[    0.000000] BRK [0x23f1d8000, 0x23f1d8fff] PGTABLE
[    0.000000] BRK [0x23f1d9000, 0x23f1d9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbfc84000-0xbfc84fff]
[    0.000000]  [mem 0xbfc84000-0xbfc84fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xbfd3f000-0xbfeeffff]
[    0.000000]  [mem 0xbfd3f000-0xbfeeffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x233160000-0x23dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000BFC85098 000084 (v01 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000BFC89870 0000F4 (v04 INTEL  CRNBEACH 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBFCCDF40/0x00000000BFCCDF80, using 32-bit address (20140926/tbfadt-283)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140926/tbfadt-618)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x00000000000009F4/0x0 (20140926/tbfadt-649)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140926/tbfadt-699)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20140926/tbfadt-699)
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
[    0.000000] NODE_DATA(0) allocated [mem 0x23ffd3000-0x23fff8fff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff88022b000000-ffff880232ffffff] on node 0
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
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x23fffffff]
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
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
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
[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88023fc00000 s89280 r8192 d29504 u524288
[    0.000000] pcpu-alloc: s89280 r8192 d29504 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2062292
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-a06/cyclic_ltp-performance-syscalls-x86_64-rhel-HEAD-efefb5ca5da52f7537c7ced03d6e53408f13a26e-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/vmlinuz-3.18.0-rc4-next-20141117 kconfig=x86_64-rhel commit=efefb5ca5da52f7537c7ced03d6e53408f13a26e branch=next/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-a06/ltp/performance-syscalls/debian-x86_64.cgz/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/0 ip=::::lkp-a06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 7984960K/8380200K available (8834K kernel code, 1720K rwdata, 3920K rodata, 1844K init, 1876K bss, 395240K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:524544 nr_irqs:456 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1600.013 MHz processor
[    0.000067] Calibrating delay loop (skipped), value calculated using timer frequency.. 3200.02 BogoMIPS (lpj=1600013)
[    0.010696] pid_max: default: 32768 minimum: 301
[    0.015336] ACPI: Core revision 20140926
[    0.038216] ACPI: All ACPI Tables successfully acquired
[    0.043569] Security Framework initialized
[    0.047677] SELinux:  Initializing.
[    0.051182] SELinux:  Starting in permissive mode
[    0.057821] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.072727] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.083257] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.090173] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.098247] Initializing cgroup subsys memory
[    0.102636] Initializing cgroup subsys devices
[    0.107089] Initializing cgroup subsys freezer
[    0.111533] Initializing cgroup subsys net_cls
[    0.115978] Initializing cgroup subsys blkio
[    0.120251] Initializing cgroup subsys perf_event
[    0.124958] Initializing cgroup subsys hugetlb
[    0.129470] CPU: Physical Processor ID: 0
[    0.133482] CPU: Processor Core ID: 0
[    0.137148] mce: CPU supports 5 MCE banks
[    0.141170] CPU0: Thermal LVT vector (0xfa) already installed
[    0.147118] Freeing SMP alternatives memory: 36K (ffffffff81ff4000 - ffffffff81ffd000)
[    0.157035] ftrace: allocating 31465 entries in 123 pages
[    0.190803] Getting VERSION: 50014
[    0.194220] Getting VERSION: 50014
[    0.197627] Getting ID: 0
[    0.200254] Getting ID: 0
[    0.202888] masked ExtINT on CPU#0
[    0.206410] ENABLING IO-APIC IRQs
[    0.209729] init IO_APIC IRQs
[    0.212700]  apic 2 pin 0 not connected
[    0.216548] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.224469] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.232387] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.240344] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.248278] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.256206] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.264136] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.272066] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.279996] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.287927] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.295857] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
[    0.303962] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
[    0.312065] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.320169] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.328272] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.336375] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.344474]  apic 2 pin 16 not connected
[    0.348406]  apic 2 pin 17 not connected
[    0.352340]  apic 2 pin 18 not connected
[    0.356266]  apic 2 pin 19 not connected
[    0.360194]  apic 2 pin 20 not connected
[    0.364129]  apic 2 pin 21 not connected
[    0.368063]  apic 2 pin 22 not connected
[    0.371998]  apic 2 pin 23 not connected
[    0.376069] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.392081] smpboot: CPU0: Intel(R) Atom(TM) CPU S1240   @ 1.60GHz (fam: 06, model: 36, stepping: 09)
[    0.401380] Using local APIC timer interrupts.
[    0.401380] calibrating APIC timer ...
[    0.510938] ... lapic delta = 625014
[    0.514513] ... PM-Timer delta = 357950
[    0.518350] ... PM-Timer result ok
[    0.521750] ..... delta 625014
[    0.524808] ..... mult: 26844146
[    0.528041] ..... calibration result: 100002
[    0.532314] ..... CPU clock speed is 1600.0033 MHz.
[    0.537194] ..... host bus clock speed is 100.0002 MHz.
[    0.542490] Performance Events: PEBS fmt0+, 8-deep LBR, Atom events, Intel PMU driver.
[    0.550531] ... version:                3
[    0.554551] ... bit width:              40
[    0.558649] ... generic registers:      2
[    0.562663] ... value mask:             000000ffffffffff
[    0.567976] ... max period:             000000007fffffff
[    0.573289] ... fixed-purpose events:   3
[    0.577302] ... event mask:             0000000700000003
[    0.588364] x86: Booting SMP configuration:
[    0.592582] .... node  #0, CPUs:      #1
[    0.607411] masked ExtINT on CPU#1
[    0.611057] CPU1: Thermal LVT vector (0xfa) already installed
[    0.619113] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.627627]  #2
[    0.640261] masked ExtINT on CPU#2
[    0.643898] CPU2: Thermal LVT vector (0xfa) already installed
[    0.652199]  #3
[    0.664826] masked ExtINT on CPU#3
[    0.668460] CPU3: Thermal LVT vector (0xfa) already installed
[    0.676346] x86: Booted up 1 node, 4 CPUs
[    0.680375] smpboot: Total of 4 processors activated (12800.10 BogoMIPS)
[    0.688796] devtmpfs: initialized
[    0.703461] evm: security.selinux
[    0.706797] evm: security.ima
[    0.709778] evm: security.capability
[    0.713995] PM: Registering ACPI NVS region [mem 0xbf67b000-0xbfb3dfff] (4993024 bytes)
[    0.722274] PM: Registering ACPI NVS region [mem 0xbfc51000-0xbfc51fff] (4096 bytes)
[    0.730028] PM: Registering ACPI NVS region [mem 0xbfc63000-0xbfc65fff] (12288 bytes)
[    0.737861] PM: Registering ACPI NVS region [mem 0xbfc8b000-0xbfc8cfff] (8192 bytes)
[    0.745618] PM: Registering ACPI NVS region [mem 0xbfcc8000-0xbfcd0fff] (36864 bytes)
[    0.753455] PM: Registering ACPI NVS region [mem 0xbfcfc000-0xbfd3efff] (274432 bytes)
[    0.765791] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.773172] NET: Registered protocol family 16
[    0.781482] cpuidle: using governor menu
[    0.785982] ACPI: bus type PCI registered
[    0.790003] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.796663] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    0.805981] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    0.814112] PCI: Using configuration type 1 for base access
[    0.829897] ACPI: Added _OSI(Module Device)
[    0.834108] ACPI: Added _OSI(Processor Device)
[    0.838564] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.843279] ACPI: Added _OSI(Processor Aggregator Device)
[    0.850735] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
[    0.861113] ACPI: Executed 1 blocks of module-level executable AML code
[    0.878777] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.886715] ACPI: Dynamic OEM Table Load:
[    0.890797] ACPI: SSDT 0xFFFF88022996F800 0002BD (v02 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.900787] ACPI: Dynamic OEM Table Load:
[    0.904866] ACPI: SSDT 0xFFFF880229FAD800 0006AB (v02 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.916222] ACPI: Dynamic OEM Table Load:
[    0.920296] ACPI: SSDT 0xFFFF880229971C00 00015F (v02 PmRef  Cpu1Ist  00003000 INTL 20051117)
[    0.930030] ACPI: Dynamic OEM Table Load:
[    0.934101] ACPI: SSDT 0xFFFF880229969780 00008D (v02 PmRef  Cpu1Cst  00003000 INTL 20051117)
[    0.946308] ACPI: Interpreter enabled
[    0.950013] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.959292] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.968604] ACPI: (supports S0 S3 S4 S5)
[    0.972539] ACPI: Using IOAPIC for interrupt routing
[    0.977797] HEST: Table parsing has been initialized.
[    0.982866] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.008358] ACPI: Power Resource [PFAN] (off)
[    1.014795] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.021004] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.030503] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    1.040512] acpi PNP0A08:00: host bridge window [0x0-0x0] (ignored, not CPU addressable)
[    1.049177] PCI host bridge to bus 0000:00
[    1.053287] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.058778] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    1.064967] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    1.071159] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    1.077342] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.083533] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.090412] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    1.097295] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfeffffff]
[    1.104190] pci 0000:00:00.0: [8086:0c72] type 00 class 0x060000
[    1.110498] pci 0000:00:01.0: [8086:0c46] type 01 class 0x060400
[    1.116541] pci 0000:00:01.0: reg 0x10: [mem 0xfe460000-0xfe47ffff 64bit]
[    1.123418] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.129677] pci 0000:00:01.0: System wakeup disabled by ACPI
[    1.135471] pci 0000:00:02.0: [8086:0c47] type 01 class 0x060400
[    1.141509] pci 0000:00:02.0: reg 0x10: [mem 0xfe440000-0xfe45ffff 64bit]
[    1.148385] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.154640] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.160432] pci 0000:00:03.0: [8086:0c48] type 01 class 0x060400
[    1.166469] pci 0000:00:03.0: reg 0x10: [mem 0xfe420000-0xfe43ffff 64bit]
[    1.173340] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.179593] pci 0000:00:03.0: System wakeup disabled by ACPI
[    1.185392] pci 0000:00:04.0: [8086:0c49] type 01 class 0x060400
[    1.191431] pci 0000:00:04.0: reg 0x10: [mem 0xfe400000-0xfe41ffff 64bit]
[    1.198310] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    1.204558] pci 0000:00:04.0: System wakeup disabled by ACPI
[    1.210359] pci 0000:00:0e.0: [8086:0c54] type 00 class 0x080600
[    1.216453] pci 0000:00:0e.0: PME# supported from D0 D3hot D3cold
[    1.222805] pci 0000:00:13.0: [8086:0c59] type 00 class 0x088000
[    1.228838] pci 0000:00:13.0: reg 0x10: [mem 0xfe482000-0xfe4823ff 64bit]
[    1.235943] pci 0000:00:13.1: [8086:0c5a] type 00 class 0x088000
[    1.241976] pci 0000:00:13.1: reg 0x10: [mem 0xfe481000-0xfe4813ff 64bit]
[    1.249089] pci 0000:00:14.0: [8086:0c5f] type 00 class 0x070002
[    1.255123] pci 0000:00:14.0: reg 0x10: [io  0xf000-0xf007]
[    1.260711] pci 0000:00:14.0: reg 0x14: [mem 0xfe480000-0xfe4800ff]
[    1.267295] pci 0000:00:1f.0: [8086:0c60] type 00 class 0x060100
[    1.273733] pci 0000:01:00.0: [1033:0194] type 00 class 0x0c0330
[    1.279780] pci 0000:01:00.0: reg 0x10: [mem 0xfe300000-0xfe301fff 64bit]
[    1.286714] pci 0000:01:00.0: PME# supported from D0 D3hot
[    1.293775] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.298758] pci 0000:00:01.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    1.305689] pci 0000:02:00.0: [1b4b:9130] type 00 class 0x010601
[    1.311733] pci 0000:02:00.0: reg 0x10: [io  0xe040-0xe047]
[    1.317325] pci 0000:02:00.0: reg 0x14: [io  0xe030-0xe033]
[    1.322915] pci 0000:02:00.0: reg 0x18: [io  0xe020-0xe027]
[    1.328507] pci 0000:02:00.0: reg 0x1c: [io  0xe010-0xe013]
[    1.334097] pci 0000:02:00.0: reg 0x20: [io  0xe000-0xe00f]
[    1.339687] pci 0000:02:00.0: reg 0x24: [mem 0xfe210000-0xfe2107ff]
[    1.345972] pci 0000:02:00.0: reg 0x30: [mem 0xfe200000-0xfe20ffff pref]
[    1.352759] pci 0000:02:00.0: PME# supported from D3hot
[    1.359765] pci 0000:00:02.0: PCI bridge to [bus 02]
[    1.364746] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    1.370848] pci 0000:00:02.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    1.377778] pci 0000:03:00.0: [1a03:1150] type 01 class 0x060400
[    1.383954] pci 0000:03:00.0: supports D1 D2
[    1.388239] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.396764] pci 0000:00:03.0: PCI bridge to [bus 03-04]
[    1.402005] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    1.408107] pci 0000:00:03.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    1.415041] pci 0000:04:00.0: [1a03:2000] type 00 class 0x030000
[    1.421084] pci 0000:04:00.0: reg 0x10: [mem 0xfd000000-0xfdffffff]
[    1.427379] pci 0000:04:00.0: reg 0x14: [mem 0xfe000000-0xfe01ffff]
[    1.433672] pci 0000:04:00.0: reg 0x18: [io  0xd000-0xd07f]
[    1.439384] pci 0000:04:00.0: supports D1 D2
[    1.443664] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.450491] pci 0000:03:00.0: PCI bridge to [bus 04]
[    1.455476] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    1.461584] pci 0000:03:00.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    1.468532] pci 0000:05:00.0: [8086:1523] type 00 class 0x020000
[    1.474568] pci 0000:05:00.0: reg 0x10: [mem 0xfe120000-0xfe13ffff]
[    1.480868] pci 0000:05:00.0: reg 0x18: [io  0xc020-0xc03f]
[    1.486458] pci 0000:05:00.0: reg 0x1c: [mem 0xfe144000-0xfe147fff]
[    1.492863] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.499013] pci 0000:05:00.0: reg 0x184: [mem 0xd0000000-0xd0003fff 64bit pref]
[    1.506349] pci 0000:05:00.0: reg 0x190: [mem 0xd0020000-0xd0023fff 64bit pref]
[    1.513837] pci 0000:05:00.1: [8086:1523] type 00 class 0x020000
[    1.519868] pci 0000:05:00.1: reg 0x10: [mem 0xfe100000-0xfe11ffff]
[    1.526166] pci 0000:05:00.1: reg 0x18: [io  0xc000-0xc01f]
[    1.531760] pci 0000:05:00.1: reg 0x1c: [mem 0xfe140000-0xfe143fff]
[    1.538161] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
[    1.544310] pci 0000:05:00.1: reg 0x184: [mem 0xd0040000-0xd0043fff 64bit pref]
[    1.551653] pci 0000:05:00.1: reg 0x190: [mem 0xd0060000-0xd0063fff 64bit pref]
[    1.560768] pci 0000:00:04.0: PCI bridge to [bus 05]
[    1.565744] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    1.571843] pci 0000:00:04.0:   bridge window [mem 0xfe100000-0xfe1fffff]
[    1.578641] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    1.587393] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
[    1.596638] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 12 14 15), disabled.
[    1.605180] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.613906] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.622638] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.631367] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.640096] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
[    1.648629] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
[    1.657160] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15), disabled.
[    1.665686] ACPI: Enabled 3 GPEs in block 00 to 1F
[    1.670942] vgaarb: setting as boot device: PCI:0000:04:00.0
[    1.676613] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.684715] vgaarb: loaded
[    1.687433] vgaarb: bridge control possible 0000:04:00.0
[    1.693020] SCSI subsystem initialized
[    1.696901] ACPI: bus type USB registered
[    1.700988] usbcore: registered new interface driver usbfs
[    1.706525] usbcore: registered new interface driver hub
[    1.711941] usbcore: registered new device driver usb
[    1.717092] pps_core: LinuxPPS API ver. 1 registered
[    1.722065] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.731218] PTP clock support registered
[    1.735543] PCI: Using ACPI for IRQ routing
[    1.747011] PCI: pci_cache_line_size set to 64 bytes
[    1.752058] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    1.759026] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
[    1.765040] e820: reserve RAM buffer [mem 0xbf67b000-0xbfffffff]
[    1.771054] e820: reserve RAM buffer [mem 0xbfc85000-0xbfffffff]
[    1.777068] e820: reserve RAM buffer [mem 0xbfef0000-0xbfffffff]
[    1.783462] NetLabel: Initializing
[    1.786880] NetLabel:  domain hash size = 128
[    1.791245] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.796243] NetLabel:  unlabeled traffic allowed by default
[    1.802310] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.807276] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.815200] Switched to clocksource hpet
[    1.862271] pnp: PnP ACPI init
[    1.865894] system 00:00: [mem 0xc0000000-0xcfffffff] has been reserved
[    1.872541] system 00:00: [mem 0xbff00000-0xbfffffff] has been reserved
[    1.879167] system 00:00: [mem 0xfee00000-0xfeefffff] has been reserved
[    1.885800] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.893086] system 00:01: [io  0x0a00-0x0a1f] has been reserved
[    1.899034] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.906869] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
[    1.914903] pnp 00:02: [dma 0 disabled]
[    1.918926] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.925539] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
[    1.933618] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.940372] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    1.946316] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.953792] pnp 00:05: Plug and Play ACPI device, IDs IPI0001 (active)
[    1.961499] system 00:06: [io  0x0900-0x097f] could not be reserved
[    1.967794] system 00:06: [io  0x09c0-0x09ff] has been reserved
[    1.973732] system 00:06: [io  0x0400-0x043f] has been reserved
[    1.979668] system 00:06: [io  0x0500-0x057f] has been reserved
[    1.985608] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.992584] system 00:06: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.999214] system 00:06: [mem 0x000c0000-0x000dffff] could not be reserved
[    2.006190] system 00:06: [mem 0x000e0000-0x000effff] could not be reserved
[    2.013168] system 00:06: [mem 0x000f0000-0x000fffff] could not be reserved
[    2.020144] system 00:06: [mem 0xff800000-0xffffffff] has been reserved
[    2.026777] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.033844] system 00:07: [mem 0xbfef0000-0xbfefffff] has been reserved
[    2.040486] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.048096] pnp: PnP ACPI: found 8 devices
[    2.064013] pci 0000:00:01.0: PCI bridge to [bus 01]
[    2.069007] pci 0000:00:01.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    2.075819] pci 0000:00:02.0: PCI bridge to [bus 02]
[    2.080797] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    2.086909] pci 0000:00:02.0:   bridge window [mem 0xfe200000-0xfe2fffff]
[    2.093719] pci 0000:03:00.0: PCI bridge to [bus 04]
[    2.098702] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
[    2.104816] pci 0000:03:00.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    2.111626] pci 0000:00:03.0: PCI bridge to [bus 03-04]
[    2.116868] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    2.122980] pci 0000:00:03.0:   bridge window [mem 0xfd000000-0xfe0fffff]
[    2.129790] pci 0000:00:04.0: PCI bridge to [bus 05]
[    2.134775] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
[    2.140888] pci 0000:00:04.0:   bridge window [mem 0xfe100000-0xfe1fffff]
[    2.147689] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    2.155452] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    2.161035] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    2.166623] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    2.172213] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    2.177796] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    2.184079] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    2.190355] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfeffffff]
[    2.196717] pci_bus 0000:01: resource 1 [mem 0xfe300000-0xfe3fffff]
[    2.203000] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    2.208581] pci_bus 0000:02: resource 1 [mem 0xfe200000-0xfe2fffff]
[    2.214857] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    2.220437] pci_bus 0000:03: resource 1 [mem 0xfd000000-0xfe0fffff]
[    2.226712] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    2.232294] pci_bus 0000:04: resource 1 [mem 0xfd000000-0xfe0fffff]
[    2.238570] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    2.244152] pci_bus 0000:05: resource 1 [mem 0xfe100000-0xfe1fffff]
[    2.250436] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    2.257750] NET: Registered protocol family 2
[    2.262774] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    2.270662] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.278120] TCP: Hash tables configured (established 65536 bind 65536)
[    2.284884] TCP: reno registered
[    2.288220] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    2.294456] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    2.301361] NET: Registered protocol family 1
[    2.306121] RPC: Registered named UNIX socket transport module.
[    2.312097] RPC: Registered udp transport module.
[    2.316817] RPC: Registered tcp transport module.
[    2.321540] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.328620] IOAPIC[0]: Set routing entry (2-21 -> 0x41 -> IRQ 21 Mode:1 Active:1 Dest:15)
[    2.337078] pci 0000:04:00.0: Video device with shadowed ROM
[    2.342772] PCI: CLS 64 bytes, default 64
[    2.347028] Unpacking initramfs...
[   11.770395] Freeing initrd memory: 178816K (ffff880233160000 - ffff88023e000000)
[   11.777876] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   11.784343] software IO TLB [mem 0xbb67b000-0xbf67b000] (64MB) mapped at [ffff8800bb67b000-ffff8800bf67afff]
[   11.797247] futex hash table entries: 1024 (order: 4, 65536 bytes)
[   11.803497] Initialise system trusted keyring
[   11.807920] audit: initializing netlink subsys (disabled)
[   11.813372] audit: type=2000 audit(1416320274.099:1): initialized
[   11.820414] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   11.833220] zpool: loaded
[   11.835889] zbud: loaded
[   11.838933] VFS: Disk quotas dquot_6.5.2
[   11.843032] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   11.852103] SGI XFS with ACLs, security attributes, no debug enabled
[   11.860006] 9p: Installing v9fs 9p2000 file system support
[   11.865859] Key type big_key registered
[   11.869722] SELinux:  Registering netfilter hooks
[   11.876031] NET: Registered protocol family 38
[   11.880535] Key type asymmetric registered
[   11.884654] Asymmetric key parser 'x509' registered
[   11.889732] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   11.897271] io scheduler noop registered
[   11.901226] io scheduler deadline registered (default)
[   11.906423] io scheduler cfq registered
[   11.911300] IOAPIC[0]: Set routing entry (2-22 -> 0x61 -> IRQ 22 Mode:1 Active:1 Dest:15)
[   11.920177] IOAPIC[0]: Set routing entry (2-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:15)
[   11.929024] IOAPIC[0]: Set routing entry (2-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:15)
[   11.937542] aer 0000:00:01.0:pcie02: service driver aer loaded
[   11.943457] aer 0000:00:02.0:pcie02: service driver aer loaded
[   11.949363] aer 0000:00:03.0:pcie02: service driver aer loaded
[   11.949371] pcieport 0000:00:03.0: AER: Multiple Uncorrected (Non-Fatal) error received: id=0018
[   11.949384] pcieport 0000:00:03.0: can't find device of ID0018
[   11.969916] aer 0000:00:04.0:pcie02: service driver aer loaded
[   11.975821] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[   11.982796] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[   11.989340] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[   11.996078] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[   12.003047] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[   12.009588] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[   12.016323] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[   12.023300] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[   12.029839] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[   12.036384] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[   12.043122] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[   12.050095] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[   12.056637] pci 0000:05:00.1: Signaling PME through PCIe PME interrupt
[   12.063183] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[   12.069921] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   12.075579] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   12.082315] intel_idle: MWAIT substates: 0x3020220
[   12.087120] intel_idle: v0.4 model 0x36
[   12.090972] intel_idle: lapic_timer_reliable_states 0xffffffff
[   12.097498] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[   12.105870] ACPI: Power Button [PWRB]
[   12.117954] thermal LNXTHERM:00: registered as thermal_zone0
[   12.123637] ACPI: Thermal Zone [TZ00] (34 C)
[   12.128068] ERST: Can not request [mem 0xbfc6303f-0xbfc6503e] for ERST.
[   12.134775] [Firmware Warn]: GHES: Poll interval is 0 for generic hardware error source: 1, disabled.
[   12.144302] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[   12.150946] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   12.177937] serial 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   12.206743] platform serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   12.236856] serial 0000:00:14.0: ttyS2 at I/O 0xf000 (irq = 16, base_baud = 115200) is a 16550A
[   12.246652] Non-volatile memory driver v1.3
[   12.250901] Linux agpgart interface v0.103
[   12.255350] error detecting cacheinfo..cpu0
[   12.259812] rdac: device handler registered
[   12.264190] hp_sw: device handler registered
[   12.268484] emc: device handler registered
[   12.272597] alua: device handler registered
[   12.276947] libphy: Fixed MDIO Bus: probed
[   12.281199] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   12.288256] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   12.294065] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   12.299912] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   12.305892] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
[   12.312949] igb: Copyright (c) 2007-2014 Intel Corporation.
[   12.705681] igb 0000:05:00.0: added PHC on eth0
[   12.710243] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connection
[   12.717133] igb 0000:05:00.0: eth0: (PCIe:5.0Gb/s:Width x2) 00:1e:67:68:b4:20
[   12.724360] igb 0000:05:00.0: eth0: PBA No: 106100-000
[   12.729514] igb 0000:05:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[   12.795705] tsc: Refined TSC clocksource calibration: 1600.055 MHz
[   12.802130] igb 0000:05:00.1: added PHC on eth1
[   12.806692] igb 0000:05:00.1: Intel(R) Gigabit Ethernet Network Connection
[   12.813576] igb 0000:05:00.1: eth1: (PCIe:5.0Gb/s:Width x2) 00:1e:67:68:b4:21
[   12.820807] igb 0000:05:00.1: eth1: PBA No: 106100-000
[   12.825961] igb 0000:05:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[   12.833629] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
[   12.841391] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   12.847410] usbcore: registered new interface driver catc
[   12.852854] usbcore: registered new interface driver kaweth
[   12.858441] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[   12.865872] usbcore: registered new interface driver pegasus
[   12.871578] usbcore: registered new interface driver rtl8150
[   12.877297] usbcore: registered new interface driver asix
[   12.882748] usbcore: registered new interface driver cdc_ether
[   12.888628] usbcore: registered new interface driver cdc_eem
[   12.894329] usbcore: registered new interface driver dm9601
[   12.899958] usbcore: registered new interface driver smsc75xx
[   12.905754] usbcore: registered new interface driver smsc95xx
[   12.911554] usbcore: registered new interface driver gl620a
[   12.917169] usbcore: registered new interface driver net1080
[   12.922871] usbcore: registered new interface driver plusb
[   12.928400] usbcore: registered new interface driver rndis_host
[   12.934364] usbcore: registered new interface driver cdc_subset
[   12.940330] usbcore: registered new interface driver zaurus
[   12.945944] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   12.953390] usbcore: registered new interface driver int51x1
[   12.959092] usbcore: registered new interface driver ipheth
[   12.964719] usbcore: registered new interface driver sierra_net
[   12.971105] xhci_hcd 0000:01:00.0: xHCI Host Controller
[   12.976571] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
[   12.984552] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   12.991365] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.998602] usb usb1: Product: xHCI Host Controller
[   13.003498] usb usb1: Manufacturer: Linux 3.18.0-rc4-next-20141117 xhci-hcd
[   13.010475] usb usb1: SerialNumber: 0000:01:00.0
[   13.015560] hub 1-0:1.0: USB hub found
[   13.019378] hub 1-0:1.0: 2 ports detected
[   13.023722] xhci_hcd 0000:01:00.0: xHCI Host Controller
[   13.029140] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 2
[   13.036742] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[   13.043550] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.050785] usb usb2: Product: xHCI Host Controller
[   13.055674] usb usb2: Manufacturer: Linux 3.18.0-rc4-next-20141117 xhci-hcd
[   13.062649] usb usb2: SerialNumber: 0000:01:00.0
[   13.067712] hub 2-0:1.0: USB hub found
[   13.071513] hub 2-0:1.0: 2 ports detected
[   13.075914] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.082477] ehci-pci: EHCI PCI platform driver
[   13.086983] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.093192] ohci-pci: OHCI PCI platform driver
[   13.097681] uhci_hcd: USB Universal Host Controller Interface driver
[   13.104226] usbcore: registered new interface driver usbserial
[   13.110112] usbcore: registered new interface driver usbserial_generic
[   13.116678] usbserial: USB Serial support registered for generic
[   13.122888] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   14.163496] i8042: No controller found
[   14.167292] Switched to clocksource tsc
[   14.167580] mousedev: PS/2 mouse device common for all mice
[   14.168089] rtc_cmos 00:03: RTC can wake from S4
[   14.168405] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[   14.168456] rtc_cmos 00:03: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[   14.168549] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   14.168586] iTCO_vendor_support: vendor-support=0
[   14.169717] hidraw: raw HID events driver (C) Jiri Kosina
[   14.170236] usbcore: registered new interface driver usbhid
[   14.170237] usbhid: USB HID core driver
[   14.170315] drop_monitor: Initializing network drop monitor service
[   14.170486] TCP: cubic registered
[   14.170500] Initializing XFRM netlink socket
[   14.171076] NET: Registered protocol family 10
[   14.172025] NET: Registered protocol family 17
[   14.172061] 9pnet: Installing 9P2000 support
[   14.173189] ... APIC ID:      00000000 (0)
[   14.173191] ... APIC VERSION: 00050014
[   14.173202] 0000000000000000000000000000000000000000000000000000000000000000
[   14.173209] 0000000000000000000000020000000200000000000000020000000000000000
[   14.173216] 0000000000000000000000000000000000000000000000000000000000000000
[   14.173218] 
[   14.173223] number of MP IRQ sources: 15.
[   14.173225] number of IO-APIC #2 registers: 24.
[   14.173226] testing the IO APIC.......................
[   14.173234] IO APIC #2......
[   14.173235] .... register #00: 02000000
[   14.173237] .......    : physical APIC id: 02
[   14.173238] .......    : Delivery Type: 0
[   14.173239] .......    : LTS          : 0
[   14.173240] .... register #01: 00170020
[   14.173241] .......     : max redirection entries: 17
[   14.173242] .......     : PRQ implemented: 0
[   14.173243] .......     : IO APIC version: 20
[   14.173244] .... IRQ redirection table:
[   14.173250] 1    0    0   0   0    0    0    00
[   14.173255] 0    0    0   0   0    1    1    31
[   14.173260] 0    0    0   0   0    1    1    30
[   14.173265] 0    0    0   0   0    1    1    33
[   14.173272] 1    0    0   0   0    1    1    34
[   14.173278] 1    0    0   0   0    1    1    35
[   14.173283] 0    0    0   0   0    1    1    36
[   14.173289] 0    0    0   0   0    1    1    37
[   14.173294] 0    0    0   0   0    1    1    38
[   14.173300] 0    1    0   0   0    1    1    39
[   14.173305] 0    0    0   0   0    1    1    3A
[   14.173311] 0    0    0   0   0    1    1    3B
[   14.173316] 0    0    0   0   0    1    1    3C
[   14.173322] 0    0    0   0   0    1    1    3D
[   14.173327] 0    0    0   0   0    1    1    3E
[   14.173333] 0    0    0   0   0    1    1    3F
[   14.173338] 1    1    0   1   0    1    1    A1
[   14.173344] 1    0    0   0   0    0    0    00
[   14.173349] 1    0    0   0   0    0    0    00
[   14.173355] 1    0    0   0   0    0    0    00
[   14.173361] 1    0    0   0   0    0    0    00
[   14.173366] 1    1    0   1   0    1    1    41
[   14.173372] 1    1    0   1   0    1    1    61
[   14.173377] 1    1    0   1   0    1    1    81
[   14.173378] IRQ to pin mappings:
[   14.173384] IRQ0 -> 0:2
[   14.173387] IRQ1 -> 0:1
[   14.173390] IRQ3 -> 0:3
[   14.173392] IRQ4 -> 0:4
[   14.173395] IRQ5 -> 0:5
[   14.173398] IRQ6 -> 0:6
[   14.173400] IRQ7 -> 0:7
[   14.173403] IRQ8 -> 0:8
[   14.173406] IRQ9 -> 0:9
[   14.173408] IRQ10 -> 0:10
[   14.173411] IRQ11 -> 0:11
[   14.173414] IRQ12 -> 0:12
[   14.173417] IRQ13 -> 0:13
[   14.173420] IRQ14 -> 0:14
[   14.173422] IRQ15 -> 0:15
[   14.173426] IRQ16 -> 0:16
[   14.173428] IRQ21 -> 0:21
[   14.173431] IRQ22 -> 0:22
[   14.173434] IRQ23 -> 0:23
[   14.173441] .................................... done.
[   14.173953] Loading compiled-in X.509 certificates
[   14.179745] Loaded X.509 cert 'Magrathea: Glacier signing key: dccb5c83b0b8f8d191ef88cf5322ac96b03f7b4f'
[   14.179810] registered taskstats version 1
[   14.185493] Key type trusted registered
[   14.190708] Key type encrypted registered
[   14.195764] ima: No TPM chip found, activating TPM-bypass!
[   14.195895] evm: HMAC attrs: 0x1
[   14.200672] rtc_cmos 00:03: setting system clock to 2014-11-18 14:17:58 UTC (1416320278)
[   14.244820] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.288262] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[   14.294781] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[   14.414002] usb 1-1: New USB device found, idVendor=0624, idProduct=0248
[   14.414007] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.414011] usb 1-1: Product: Gadget USB HUB
[   14.414014] usb 1-1: Manufacturer: no manufacturer
[   14.414017] usb 1-1: SerialNumber: 0123456789
[   14.418489] hub 1-1:1.0: USB hub found
[   14.423108] hub 1-1:1.0: 5 ports detected
[   14.697355] usb 1-1.1: new high-speed USB device number 3 using xhci_hcd
[   14.782360] usb 1-1.1: New USB device found, idVendor=0624, idProduct=0249
[   14.789267] usb 1-1.1: New USB device strings: Mfr=4, Product=5, SerialNumber=6
[   14.796590] usb 1-1.1: Product: Keyboard/Mouse Function
[   14.801830] usb 1-1.1: Manufacturer: Avocent
[   14.806117] usb 1-1.1: SerialNumber: 20120124
[   14.821012] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:0624:0249.0001/input/input1
[   14.886980] hid-generic 0003:0624:0249.0001: input,hidraw0: USB HID v1.00 Keyboard [Avocent Keyboard/Mouse Function] on usb-0000:01:00.0-1.1/input0
[   14.904117] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/1-1.1/1-1.1:1.1/0003:0624:0249.0002/input/input2
[   14.918592] hid-generic 0003:0624:0249.0002: input,hidraw1: USB HID v1.00 Mouse [Avocent Keyboard/Mouse Function] on usb-0000:01:00.0-1.1/input1
[   14.934282] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:0624:0249.0003/input/input3
[   14.948788] hid-generic 0003:0624:0249.0003: input,hidraw2: USB HID v1.00 Mouse [Avocent Keyboard/Mouse Function] on usb-0000:01:00.0-1.1/input2
[   16.020853] igb 0000:05:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   16.030982] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   16.041827] Sending DHCP requests ..., OK
[   25.311243] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.113
[   25.347898] IP-Config: Complete:
[   25.351168]      device=eth0, hwaddr=00:1e:67:68:b4:20, ipaddr=192.168.1.113, mask=255.255.255.0, gw=192.168.1.1
[   25.361349]      host=lkp-a06, domain=lkp.intel.com, nis-domain=(none)
[   25.367884]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   25.374592]      nameserver0=192.168.1.1
[   25.378759] PM: Hibernation image not present or could not be loaded.
[   25.389390] Freeing unused kernel memory: 1844K (ffffffff81e27000 - ffffffff81ff4000)
[   25.929573] ipmi message handler version 39.2
[   25.947921] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   25.967963] IPMI System Interface driver.
[   25.972207] ipmi_si: probing via ACPI
[   25.983001] libata version 3.00 loaded.
[   25.994321] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   26.006206] ipmi_si 00:05: [io  0x0ca0] regsize 1 spacing 4 irq 0
[   26.012359] ipmi_si: Adding ACPI-specified kcs state machine
[   26.034280] ahci 0000:02:00.0: version 3.0
[   26.046136] 
[   26.047731] ipmi_si: probing via SMBIOS
[   26.051616] ipmi_si: SMBIOS: io 0xca0 regsize 1 spacing 1 irq 0
[   26.057575] ipmi_si: Adding SMBIOS-specified kcs state machine
[   26.063405] ahci 0000:02:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[   26.071881] ahci 0000:02:00.0: flags: 64bit ncq pio 
[   26.086893] [drm] Initialized drm 1.1.0 20060810
[   26.092971]  duplicate interface
[   26.103897] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca0, slave address 0x0, irq 0
[   26.114364] scsi host0: ahci
[   26.118499] scsi host1: ahci
[   26.136241] scsi host2: ahci
[   26.139736] ie6xx_wdt ie6xx_wdt.3168: Watchdog Timer is Locked (Reg=0x1)
[   26.146779] scsi host3: ahci
[   26.157202] scsi host4: ahci
[   26.160735] scsi host5: ahci
[   26.166239] scsi host6: ahci
[   26.169641] scsi host7: ahci
[   26.172906] ata1: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210100 irq 53
[   26.180382] ata2: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210180 irq 53
[   26.187855] ata3: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210200 irq 53
[   26.195311] ata4: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210280 irq 53
[   26.202765] ata5: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210300 irq 53
[   26.210207] ata6: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210380 irq 53
[   26.217665] ata7: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210400 irq 53
[   26.221277] ipmi_si 00:05: Found new BMC (man_id: 0x002b99, prod_id: 0x0000, dev_id: 0x20)
[   26.221305] ipmi_si 00:05: IPMI kcs interface initialized
[   26.238844] ata8: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210480 irq 53
[   26.247308] Error: Driver 'pcspkr' is already registered, aborting...
[   26.248382] [drm] AST 2300 detected
[   26.248411] [drm] Analog VGA only
[   26.248441] [drm] dram 1632000000 1 32 01000000
[   26.249923] [TTM] Zone  kernel: Available graphics memory: 4082828 kiB
[   26.249926] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   26.249928] [TTM] Initializing pool allocator
[   26.249947] [TTM] Initializing DMA pool allocator
[   26.287393] fbcon: astdrmfb (fb0) is primary device
[   26.305243] Console: switching to colour frame buffer device 128x48
[   26.351255] ast 0000:04:00.0: fb0: astdrmfb frame buffer device
[   26.357311] ast 0000:04:00.0: registered panic notifier
[   26.377195] [drm] Initialized ast 0.1.0 20120228 for 0000:04:00.0 on minor 0
[   26.553390] ata3: SATA link down (SStatus 0 SControl 300)
[   26.559289] ata2: SATA link down (SStatus 0 SControl 300)
[   26.565166] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   26.571703] ata7: SATA link down (SStatus 0 SControl 300)
[   26.577261] ata8.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[   26.583509] ata4: SATA link down (SStatus 0 SControl 300)
[   26.589142] ata5: SATA link down (SStatus 0 SControl 300)
[   26.594706] ata6: SATA link down (SStatus 0 SControl 300)
[   26.600288] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   26.606890] ata8.00: configured for UDMA/66
[   26.663301] ata1.00: ATA-8: TOSHIBA MK8061GSYB, ME0A, max UDMA/100
[   26.669696] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   26.679035] ata1.00: configured for UDMA/100
[   26.683880] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8061GS ME0A PQ: 0 ANSI: 5
[   26.694333] scsi 7:0:0:0: Processor         Marvell  91xx Config      1.01 PQ: 0 ANSI: 5
[   26.714374] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[   26.721191] ata8.00: irq_stat 0x40000001
[   26.725323] scsi 7:0:0:0: CDB: 
[   26.728621] Inquiry: 12 01 00 00 ff 00
[   26.740240] ata8.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 dma 16640 in
[   26.740240]          res 50/00:02:00:00:00/00:00:00:00:00/a0 Emask 0x1 (device error)
[   26.770315] ata8.00: status: { DRDY }
[   26.898845] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[   26.899372] sd 0:0:0:0: [sda] Write Protect is off
[   26.899389] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   26.899611] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.946427] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   26.959703] scsi 7:0:0:0: Attached scsi generic sg1 type 3
[   26.960924]  sda: sda1 sda2
[   26.962231] sd 0:0:0:0: [sda] Attached SCSI disk
[   27.287174] raid6: sse2x1     140 MB/s
[   27.311343] raid6: sse2x2     218 MB/s
[   27.335176] raid6: sse2x4     382 MB/s
[   27.342214] raid6: using algorithm sse2x4 (382 MB/s)
[   27.350431] raid6: using ssse3x2 recovery algorithm
[   27.369794] xor: measuring software checksum speed
[   27.384102]    prefetch64-sse: 11968.000 MB/sec
[   27.401093]    generic_sse:  4732.000 MB/sec
[   27.408576] xor: using function: prefetch64-sse (11968.000 MB/sec)
[   27.538857] Btrfs loaded
[   27.550221] BTRFS: device fsid 91075fbe-9acf-4d0e-ad71-6c2ed15f00ab devid 1 transid 14 /dev/sda1
[   29.716484] random: dd urandom read with 82 bits of entropy available
<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 3.18.0-rc4-next-20141117 (kbuild@roam) (gcc version 4.9.1 (Debian 4.9.1-19) ) #1 SMP Tue Nov 18 11:46:52 CST 2014
<6>[    0.000000] Command line: user=lkp job=/lkp/scheduled/lkp-a06/cyclic_ltp-performance-syscalls-x86_64-rhel-HEAD-efefb5ca5da52f7537c7ced03d6e53408f13a26e-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/vmlinuz-3.18.0-rc4-next-20141117 kconfig=x86_64-rhel commit=efefb5ca5da52f7537c7ced03d6e53408f13a26e branch=next/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-a06/ltp/performance-syscalls/debian-x86_64.cgz/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/0 ip=::::lkp-a06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009e3ff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009e400-0x000000000009ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bf67afff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000bf67b000-0x00000000bfb3dfff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfb3e000-0x00000000bfc50fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc51000-0x00000000bfc51fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc52000-0x00000000bfc62fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc63000-0x00000000bfc65fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc66000-0x00000000bfc83fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc84000-0x00000000bfc84fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc85000-0x00000000bfc8afff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc8b000-0x00000000bfc8cfff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfc8d000-0x00000000bfcc7fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfcc8000-0x00000000bfcd0fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfcd1000-0x00000000bfcfbfff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfcfc000-0x00000000bfd3efff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfd3f000-0x00000000bfeeffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000bfef0000-0x00000000cfffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000023fffffff] usable
<6>[    0.000000] bootconsole [earlyser0] enabled
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] SMBIOS 2.7 present.
<7>[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./Double Cove , BIOS BWDEXT.86B.000.012.D127 10/08/2012
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] AGP: No AGP bridge found
<6>[    0.000000] e820: last_pfn = 0x240000 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-E7FFF write-through
<7>[    0.000000]   E8000-FFFFF write-protect
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 000000000 mask E00000000 write-back
<7>[    0.000000]   1 base 200000000 mask FC0000000 write-back
<7>[    0.000000]   2 base 0BFEF0000 mask FFFFF0000 uncachable
<7>[    0.000000]   3 base 0BFF00000 mask FFFF00000 write-through
<7>[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
<7>[    0.000000]   5 disabled
<7>[    0.000000]   6 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
<6>[    0.000000] e820: last_pfn = 0xbfef0 max_arch_pfn = 0x400000000
<4>[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
<4>[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
<4>[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
<4>[    0.000000] Scan for SMP in [mem 0x0009e400-0x0009e7ff]
<7>[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x23f1d4000, 0x23f1d4fff] PGTABLE
<7>[    0.000000] BRK [0x23f1d5000, 0x23f1d5fff] PGTABLE
<7>[    0.000000] BRK [0x23f1d6000, 0x23f1d6fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x23fe00000-0x23fffffff]
<7>[    0.000000]  [mem 0x23fe00000-0x23fffffff] page 2M
<7>[    0.000000] BRK [0x23f1d7000, 0x23f1d7fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x23c000000-0x23fdfffff]
<7>[    0.000000]  [mem 0x23c000000-0x23fdfffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x200000000-0x23bffffff]
<7>[    0.000000]  [mem 0x200000000-0x23bffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf67afff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0xbf5fffff] page 2M
<7>[    0.000000]  [mem 0xbf600000-0xbf67afff] page 4k
<7>[    0.000000] BRK [0x23f1d8000, 0x23f1d8fff] PGTABLE
<7>[    0.000000] BRK [0x23f1d9000, 0x23f1d9fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0xbfc84000-0xbfc84fff]
<7>[    0.000000]  [mem 0xbfc84000-0xbfc84fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0xbfd3f000-0xbfeeffff]
<7>[    0.000000]  [mem 0xbfd3f000-0xbfeeffff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
<7>[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
<6>[    0.000000] RAMDISK: [mem 0x233160000-0x23dffffff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 INTEL )
<4>[    0.000000] ACPI: XSDT 0x00000000BFC85098 000084 (v01 INTEL  CRNBEACH 01072009 AMI  00010013)
<4>[    0.000000] ACPI: FACP 0x00000000BFC89870 0000F4 (v04 INTEL  CRNBEACH 01072009 AMI  00010013)
<4>[    0.000000] ACPI BIOS Warning (bug): 32/64X FACS address mismatch in FADT: 0xBFCCDF40/0x00000000BFCCDF80, using 32-bit address (20140926/tbfadt-283)
<4>[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Pm1aControlBlock: 16/32 (20140926/tbfadt-618)
<4>[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x00000000000009F4/0x0 (20140926/tbfadt-649)
<4>[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm1aControlBlock: 32, using default 16 (20140926/tbfadt-699)
<4>[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20140926/tbfadt-699)
<4>[    0.000000] ACPI: DSDT 0x00000000BFC851B0 0046BE (v02 INTEL  CRNBEACH 00000000 INTL 20051117)
<4>[    0.000000] ACPI: FACS 0x00000000BFCCDF40 000040
<4>[    0.000000] ACPI: APIC 0x00000000BFC89968 000072 (v02 INTEL  CRNBEACH 01072009 AMI  00010013)
<4>[    0.000000] ACPI: MCFG 0x00000000BFC899E0 00003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
<4>[    0.000000] ACPI: HPET 0x00000000BFC89A20 000038 (v01 A M I  OEMHPET  01072009 AMI. 00000003)
<4>[    0.000000] ACPI: SSDT 0x00000000BFC89A58 000679 (v02 PmRef  CpuPm    00003000 INTL 20051117)
<4>[    0.000000] ACPI: SSDT 0x00000000BFC8A0D8 000232 (v02 PmRef  Cpu0Tst  00003000 INTL 20051117)
<4>[    0.000000] ACPI: SSDT 0x00000000BFC8A310 00020F (v02 PmRef  Cpu1Tst  00003000 INTL 20051117)
<4>[    0.000000] ACPI: SPCR 0x00000000BFC8A520 000050 (v01 A M I  APTIO4   01072009 AMI. 00000003)
<4>[    0.000000] ACPI: EINJ 0x00000000BFC8A570 000130 (v01 AMI    AMI EINJ 00000000      00000000)
<4>[    0.000000] ACPI: ERST 0x00000000BFC8A6A0 000210 (v01 AMIER  AMI ERST 00000000      00000000)
<4>[    0.000000] ACPI: HEST 0x00000000BFC8A8B0 0000A8 (v01 AMI    AMI HEST 00000000      00000000)
<4>[    0.000000] ACPI: BERT 0x00000000BFC8A958 000030 (v01 AMI    AMI BERT 00000000      00000000)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000023fffffff]
<6>[    0.000000] NODE_DATA(0) allocated [mem 0x23ffd3000-0x23fff8fff]
<7>[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff88022b000000-ffff880232ffffff] on node 0
<6>[    0.000000] Zone ranges:
<6>[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
<6>[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
<6>[    0.000000]   Normal   [mem 0x100000000-0x23fffffff]
<6>[    0.000000] Movable zone start for each node
<6>[    0.000000] Early memory node ranges
<6>[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
<6>[    0.000000]   node   0: [mem 0x00100000-0xbf67afff]
<6>[    0.000000]   node   0: [mem 0xbfc84000-0xbfc84fff]
<6>[    0.000000]   node   0: [mem 0xbfd3f000-0xbfeeffff]
<6>[    0.000000]   node   0: [mem 0x100000000-0x23fffffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x00001000-0x23fffffff]
<7>[    0.000000] On node 0 totalpages: 2095050
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 21 pages reserved
<7>[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 12193 pages used for memmap
<7>[    0.000000]   DMA32 zone: 780333 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 20480 pages used for memmap
<7>[    0.000000]   Normal zone: 1310720 pages, LIFO batch:31
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x908
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<4>[    0.000000] mapped APIC to ffffffffff57c000 (        fee00000)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<4>[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
<7>[    0.000000] ACPI: IRQ0 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
<7>[    0.000000] ACPI: IRQ9 used by override.
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
<4>[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
<4>[    0.000000] mapped IOAPIC to ffffffffff57b000 (fec00000)
<6>[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbf67b000-0xbfb3dfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfb3e000-0xbfc50fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfc51000-0xbfc51fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfc52000-0xbfc62fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfc63000-0xbfc65fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfc66000-0xbfc83fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfc85000-0xbfc8afff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfc8b000-0xbfc8cfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfc8d000-0xbfcc7fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfcc8000-0xbfcd0fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfcd1000-0xbfcfbfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfcfc000-0xbfd3efff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xbfef0000-0xcfffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xfebfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed1bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfeefffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xff7fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
<6>[    0.000000] e820: [mem 0xd0000000-0xfebfffff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 31 pages/cpu @ffff88023fc00000 s89280 r8192 d29504 u524288
<7>[    0.000000] pcpu-alloc: s89280 r8192 d29504 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<6>[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2062292
<6>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/lkp-a06/cyclic_ltp-performance-syscalls-x86_64-rhel-HEAD-efefb5ca5da52f7537c7ced03d6e53408f13a26e-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/vmlinuz-3.18.0-rc4-next-20141117 kconfig=x86_64-rhel commit=efefb5ca5da52f7537c7ced03d6e53408f13a26e branch=next/master root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-a06/ltp/performance-syscalls/debian-x86_64.cgz/x86_64-rhel/efefb5ca5da52f7537c7ced03d6e53408f13a26e/0 ip=::::lkp-a06::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
<6>[    0.000000] sysrq: sysrq always enabled.
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.000000] AGP: Checking aperture...
<6>[    0.000000] AGP: No AGP bridge found
<6>[    0.000000] Memory: 7984960K/8380200K available (8834K kernel code, 1720K rwdata, 3920K rodata, 1844K init, 1876K bss, 395240K reserved, 0K cma-reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=4.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
<6>[    0.000000] NR_IRQS:524544 nr_irqs:456 16
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
<6>[    0.000000] Console: colour dummy device 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] bootconsole [earlyser0] disabled
<6>[    0.000000] console [ttyS0] enabled
<7>[    0.000000] hpet clockevent registered
<6>[    0.000000] tsc: Fast TSC calibration using PIT
<6>[    0.000000] tsc: Detected 1600.013 MHz processor
<6>[    0.000067] Calibrating delay loop (skipped), value calculated using timer frequency.. 3200.02 BogoMIPS (lpj=1600013)
<6>[    0.010696] pid_max: default: 32768 minimum: 301
<6>[    0.015336] ACPI: Core revision 20140926
<4>[    0.038216] ACPI: All ACPI Tables successfully acquired
<6>[    0.043569] Security Framework initialized
<6>[    0.047677] SELinux:  Initializing.
<7>[    0.051182] SELinux:  Starting in permissive mode
<6>[    0.057821] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
<6>[    0.072727] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
<6>[    0.083257] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.090173] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
<6>[    0.098247] Initializing cgroup subsys memory
<6>[    0.102636] Initializing cgroup subsys devices
<6>[    0.107089] Initializing cgroup subsys freezer
<6>[    0.111533] Initializing cgroup subsys net_cls
<6>[    0.115978] Initializing cgroup subsys blkio
<6>[    0.120251] Initializing cgroup subsys perf_event
<6>[    0.124958] Initializing cgroup subsys hugetlb
<6>[    0.129470] CPU: Physical Processor ID: 0
<6>[    0.133482] CPU: Processor Core ID: 0
<6>[    0.137148] mce: CPU supports 5 MCE banks
<7>[    0.141170] CPU0: Thermal LVT vector (0xfa) already installed
<6>[    0.147118] Freeing SMP alternatives memory: 36K (ffffffff81ff4000 - ffffffff81ffd000)
<6>[    0.157035] ftrace: allocating 31465 entries in 123 pages
<4>[    0.190803] Getting VERSION: 50014
<4>[    0.194220] Getting VERSION: 50014
<4>[    0.197627] Getting ID: 0
<4>[    0.200254] Getting ID: 0
<4>[    0.202888] masked ExtINT on CPU#0
<4>[    0.206410] ENABLING IO-APIC IRQs
<7>[    0.209729] init IO_APIC IRQs
<7>[    0.212700]  apic 2 pin 0 not connected
<7>[    0.216548] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
<7>[    0.224469] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.232387] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
<7>[    0.240344] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
<7>[    0.248278] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
<7>[    0.256206] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
<7>[    0.264136] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
<7>[    0.272066] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
<7>[    0.279996] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
<7>[    0.287927] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
<7>[    0.295857] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:1)
<7>[    0.303962] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:1)
<7>[    0.312065] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
<7>[    0.320169] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
<7>[    0.328272] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
<7>[    0.336375] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
<7>[    0.344474]  apic 2 pin 16 not connected
<7>[    0.348406]  apic 2 pin 17 not connected
<7>[    0.352340]  apic 2 pin 18 not connected
<7>[    0.356266]  apic 2 pin 19 not connected
<7>[    0.360194]  apic 2 pin 20 not connected
<7>[    0.364129]  apic 2 pin 21 not connected
<7>[    0.368063]  apic 2 pin 22 not connected
<7>[    0.371998]  apic 2 pin 23 not connected
<6>[    0.376069] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.392081] smpboot: CPU0: Intel(R) Atom(TM) CPU S1240   @ 1.60GHz (fam: 06, model: 36, stepping: 09)
<4>[    0.401380] Using local APIC timer interrupts.
<4>[    0.401380] calibrating APIC timer ...
<4>[    0.510938] ... lapic delta = 625014
<4>[    0.514513] ... PM-Timer delta = 357950
<4>[    0.518350] ... PM-Timer result ok
<4>[    0.521750] ..... delta 625014
<4>[    0.524808] ..... mult: 26844146
<4>[    0.528041] ..... calibration result: 100002
<4>[    0.532314] ..... CPU clock speed is 1600.0033 MHz.
<4>[    0.537194] ..... host bus clock speed is 100.0002 MHz.
<6>[    0.542490] Performance Events: PEBS fmt0+, 8-deep LBR, Atom events, Intel PMU driver.
<6>[    0.550531] ... version:                3
<6>[    0.554551] ... bit width:              40
<6>[    0.558649] ... generic registers:      2
<6>[    0.562663] ... value mask:             000000ffffffffff
<6>[    0.567976] ... max period:             000000007fffffff
<6>[    0.573289] ... fixed-purpose events:   3
<6>[    0.577302] ... event mask:             0000000700000003
<6>[    0.588364] x86: Booting SMP configuration:
<6>[    0.592582] .... node  #0, CPUs:      #1
<4>[    0.607411] masked ExtINT on CPU#1
<7>[    0.611057] CPU1: Thermal LVT vector (0xfa) already installed
<6>[    0.619113] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.627627]  #2
<4>[    0.640261] masked ExtINT on CPU#2
<7>[    0.643898] CPU2: Thermal LVT vector (0xfa) already installed
<4>[    0.652199]  #3
<4>[    0.664826] masked ExtINT on CPU#3
<7>[    0.668460] CPU3: Thermal LVT vector (0xfa) already installed
<6>[    0.676346] x86: Booted up 1 node, 4 CPUs
<6>[    0.680375] smpboot: Total of 4 processors activated (12800.10 BogoMIPS)
<6>[    0.688796] devtmpfs: initialized
<6>[    0.703461] evm: security.selinux
<6>[    0.706797] evm: security.ima
<6>[    0.709778] evm: security.capability
<6>[    0.713995] PM: Registering ACPI NVS region [mem 0xbf67b000-0xbfb3dfff] (4993024 bytes)
<6>[    0.722274] PM: Registering ACPI NVS region [mem 0xbfc51000-0xbfc51fff] (4096 bytes)
<6>[    0.730028] PM: Registering ACPI NVS region [mem 0xbfc63000-0xbfc65fff] (12288 bytes)
<6>[    0.737861] PM: Registering ACPI NVS region [mem 0xbfc8b000-0xbfc8cfff] (8192 bytes)
<6>[    0.745618] PM: Registering ACPI NVS region [mem 0xbfcc8000-0xbfcd0fff] (36864 bytes)
<6>[    0.753455] PM: Registering ACPI NVS region [mem 0xbfcfc000-0xbfd3efff] (274432 bytes)
<6>[    0.765791] atomic64_test: passed for x86-64 platform with CX8 and with SSE
<6>[    0.773172] NET: Registered protocol family 16
<6>[    0.781482] cpuidle: using governor menu
<6>[    0.785982] ACPI: bus type PCI registered
<6>[    0.790003] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    0.796663] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
<6>[    0.805981] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
<6>[    0.814112] PCI: Using configuration type 1 for base access
<6>[    0.829897] ACPI: Added _OSI(Module Device)
<6>[    0.834108] ACPI: Added _OSI(Processor Device)
<6>[    0.838564] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.843279] ACPI: Added _OSI(Processor Aggregator Device)
<7>[    0.850735] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:15)
<4>[    0.861113] ACPI: Executed 1 blocks of module-level executable AML code
<5>[    0.878777] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<4>[    0.886715] ACPI: Dynamic OEM Table Load:
<4>[    0.890797] ACPI: SSDT 0xFFFF88022996F800 0002BD (v02 PmRef  Cpu0Ist  00003000 INTL 20051117)
<4>[    0.900787] ACPI: Dynamic OEM Table Load:
<4>[    0.904866] ACPI: SSDT 0xFFFF880229FAD800 0006AB (v02 PmRef  Cpu0Cst  00003001 INTL 20051117)
<4>[    0.916222] ACPI: Dynamic OEM Table Load:
<4>[    0.920296] ACPI: SSDT 0xFFFF880229971C00 00015F (v02 PmRef  Cpu1Ist  00003000 INTL 20051117)
<4>[    0.930030] ACPI: Dynamic OEM Table Load:
<4>[    0.934101] ACPI: SSDT 0xFFFF880229969780 00008D (v02 PmRef  Cpu1Cst  00003000 INTL 20051117)
<6>[    0.946308] ACPI: Interpreter enabled
<4>[    0.950013] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
<4>[    0.959292] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
<6>[    0.968604] ACPI: (supports S0 S3 S4 S5)
<6>[    0.972539] ACPI: Using IOAPIC for interrupt routing
<6>[    0.977797] HEST: Table parsing has been initialized.
<6>[    0.982866] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    1.008358] ACPI: Power Resource [PFAN] (off)
<6>[    1.014795] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<6>[    1.021004] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    1.030503] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
<6>[    1.040512] acpi PNP0A08:00: host bridge window [0x0-0x0] (ignored, not CPU addressable)
<6>[    1.049177] PCI host bridge to bus 0000:00
<6>[    1.053287] pci_bus 0000:00: root bus resource [bus 00-ff]
<6>[    1.058778] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
<6>[    1.064967] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
<6>[    1.071159] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
<6>[    1.077342] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
<6>[    1.083533] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
<6>[    1.090412] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
<6>[    1.097295] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfeffffff]
<7>[    1.104190] pci 0000:00:00.0: [8086:0c72] type 00 class 0x060000
<7>[    1.110498] pci 0000:00:01.0: [8086:0c46] type 01 class 0x060400
<7>[    1.116541] pci 0000:00:01.0: reg 0x10: [mem 0xfe460000-0xfe47ffff 64bit]
<7>[    1.123418] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
<6>[    1.129677] pci 0000:00:01.0: System wakeup disabled by ACPI
<7>[    1.135471] pci 0000:00:02.0: [8086:0c47] type 01 class 0x060400
<7>[    1.141509] pci 0000:00:02.0: reg 0x10: [mem 0xfe440000-0xfe45ffff 64bit]
<7>[    1.148385] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
<6>[    1.154640] pci 0000:00:02.0: System wakeup disabled by ACPI
<7>[    1.160432] pci 0000:00:03.0: [8086:0c48] type 01 class 0x060400
<7>[    1.166469] pci 0000:00:03.0: reg 0x10: [mem 0xfe420000-0xfe43ffff 64bit]
<7>[    1.173340] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
<6>[    1.179593] pci 0000:00:03.0: System wakeup disabled by ACPI
<7>[    1.185392] pci 0000:00:04.0: [8086:0c49] type 01 class 0x060400
<7>[    1.191431] pci 0000:00:04.0: reg 0x10: [mem 0xfe400000-0xfe41ffff 64bit]
<7>[    1.198310] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
<6>[    1.204558] pci 0000:00:04.0: System wakeup disabled by ACPI
<7>[    1.210359] pci 0000:00:0e.0: [8086:0c54] type 00 class 0x080600
<7>[    1.216453] pci 0000:00:0e.0: PME# supported from D0 D3hot D3cold
<7>[    1.222805] pci 0000:00:13.0: [8086:0c59] type 00 class 0x088000
<7>[    1.228838] pci 0000:00:13.0: reg 0x10: [mem 0xfe482000-0xfe4823ff 64bit]
<7>[    1.235943] pci 0000:00:13.1: [8086:0c5a] type 00 class 0x088000
<7>[    1.241976] pci 0000:00:13.1: reg 0x10: [mem 0xfe481000-0xfe4813ff 64bit]
<7>[    1.249089] pci 0000:00:14.0: [8086:0c5f] type 00 class 0x070002
<7>[    1.255123] pci 0000:00:14.0: reg 0x10: [io  0xf000-0xf007]
<7>[    1.260711] pci 0000:00:14.0: reg 0x14: [mem 0xfe480000-0xfe4800ff]
<7>[    1.267295] pci 0000:00:1f.0: [8086:0c60] type 00 class 0x060100
<7>[    1.273733] pci 0000:01:00.0: [1033:0194] type 00 class 0x0c0330
<7>[    1.279780] pci 0000:01:00.0: reg 0x10: [mem 0xfe300000-0xfe301fff 64bit]
<7>[    1.286714] pci 0000:01:00.0: PME# supported from D0 D3hot
<6>[    1.293775] pci 0000:00:01.0: PCI bridge to [bus 01]
<7>[    1.298758] pci 0000:00:01.0:   bridge window [mem 0xfe300000-0xfe3fffff]
<7>[    1.305689] pci 0000:02:00.0: [1b4b:9130] type 00 class 0x010601
<7>[    1.311733] pci 0000:02:00.0: reg 0x10: [io  0xe040-0xe047]
<7>[    1.317325] pci 0000:02:00.0: reg 0x14: [io  0xe030-0xe033]
<7>[    1.322915] pci 0000:02:00.0: reg 0x18: [io  0xe020-0xe027]
<7>[    1.328507] pci 0000:02:00.0: reg 0x1c: [io  0xe010-0xe013]
<7>[    1.334097] pci 0000:02:00.0: reg 0x20: [io  0xe000-0xe00f]
<7>[    1.339687] pci 0000:02:00.0: reg 0x24: [mem 0xfe210000-0xfe2107ff]
<7>[    1.345972] pci 0000:02:00.0: reg 0x30: [mem 0xfe200000-0xfe20ffff pref]
<7>[    1.352759] pci 0000:02:00.0: PME# supported from D3hot
<6>[    1.359765] pci 0000:00:02.0: PCI bridge to [bus 02]
<7>[    1.364746] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
<7>[    1.370848] pci 0000:00:02.0:   bridge window [mem 0xfe200000-0xfe2fffff]
<7>[    1.377778] pci 0000:03:00.0: [1a03:1150] type 01 class 0x060400
<7>[    1.383954] pci 0000:03:00.0: supports D1 D2
<7>[    1.388239] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    1.396764] pci 0000:00:03.0: PCI bridge to [bus 03-04]
<7>[    1.402005] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
<7>[    1.408107] pci 0000:00:03.0:   bridge window [mem 0xfd000000-0xfe0fffff]
<7>[    1.415041] pci 0000:04:00.0: [1a03:2000] type 00 class 0x030000
<7>[    1.421084] pci 0000:04:00.0: reg 0x10: [mem 0xfd000000-0xfdffffff]
<7>[    1.427379] pci 0000:04:00.0: reg 0x14: [mem 0xfe000000-0xfe01ffff]
<7>[    1.433672] pci 0000:04:00.0: reg 0x18: [io  0xd000-0xd07f]
<7>[    1.439384] pci 0000:04:00.0: supports D1 D2
<7>[    1.443664] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<6>[    1.450491] pci 0000:03:00.0: PCI bridge to [bus 04]
<7>[    1.455476] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
<7>[    1.461584] pci 0000:03:00.0:   bridge window [mem 0xfd000000-0xfe0fffff]
<7>[    1.468532] pci 0000:05:00.0: [8086:1523] type 00 class 0x020000
<7>[    1.474568] pci 0000:05:00.0: reg 0x10: [mem 0xfe120000-0xfe13ffff]
<7>[    1.480868] pci 0000:05:00.0: reg 0x18: [io  0xc020-0xc03f]
<7>[    1.486458] pci 0000:05:00.0: reg 0x1c: [mem 0xfe144000-0xfe147fff]
<7>[    1.492863] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
<7>[    1.499013] pci 0000:05:00.0: reg 0x184: [mem 0xd0000000-0xd0003fff 64bit pref]
<7>[    1.506349] pci 0000:05:00.0: reg 0x190: [mem 0xd0020000-0xd0023fff 64bit pref]
<7>[    1.513837] pci 0000:05:00.1: [8086:1523] type 00 class 0x020000
<7>[    1.519868] pci 0000:05:00.1: reg 0x10: [mem 0xfe100000-0xfe11ffff]
<7>[    1.526166] pci 0000:05:00.1: reg 0x18: [io  0xc000-0xc01f]
<7>[    1.531760] pci 0000:05:00.1: reg 0x1c: [mem 0xfe140000-0xfe143fff]
<7>[    1.538161] pci 0000:05:00.1: PME# supported from D0 D3hot D3cold
<7>[    1.544310] pci 0000:05:00.1: reg 0x184: [mem 0xd0040000-0xd0043fff 64bit pref]
<7>[    1.551653] pci 0000:05:00.1: reg 0x190: [mem 0xd0060000-0xd0063fff 64bit pref]
<6>[    1.560768] pci 0000:00:04.0: PCI bridge to [bus 05]
<7>[    1.565744] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
<7>[    1.571843] pci 0000:00:04.0:   bridge window [mem 0xfe100000-0xfe1fffff]
<7>[    1.578641] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
<7>[    1.587393] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:15)
<6>[    1.596638] ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 12 14 15), disabled.
<6>[    1.605180] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
<6>[    1.613906] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
<6>[    1.622638] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
<6>[    1.631367] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
<6>[    1.640096] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15), disabled.
<6>[    1.648629] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15), disabled.
<6>[    1.657160] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15), disabled.
<4>[    1.665686] ACPI: Enabled 3 GPEs in block 00 to 1F
<6>[    1.670942] vgaarb: setting as boot device: PCI:0000:04:00.0
<6>[    1.676613] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    1.684715] vgaarb: loaded
<6>[    1.687433] vgaarb: bridge control possible 0000:04:00.0
<5>[    1.693020] SCSI subsystem initialized
<6>[    1.696901] ACPI: bus type USB registered
<6>[    1.700988] usbcore: registered new interface driver usbfs
<6>[    1.706525] usbcore: registered new interface driver hub
<6>[    1.711941] usbcore: registered new device driver usb
<6>[    1.717092] pps_core: LinuxPPS API ver. 1 registered
<6>[    1.722065] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
<6>[    1.731218] PTP clock support registered
<6>[    1.735543] PCI: Using ACPI for IRQ routing
<7>[    1.747011] PCI: pci_cache_line_size set to 64 bytes
<4>[    1.752058] Expanded resource reserved due to conflict with PCI Bus 0000:00
<7>[    1.759026] e820: reserve RAM buffer [mem 0x0009e400-0x0009ffff]
<7>[    1.765040] e820: reserve RAM buffer [mem 0xbf67b000-0xbfffffff]
<7>[    1.771054] e820: reserve RAM buffer [mem 0xbfc85000-0xbfffffff]
<7>[    1.777068] e820: reserve RAM buffer [mem 0xbfef0000-0xbfffffff]
<6>[    1.783462] NetLabel: Initializing
<6>[    1.786880] NetLabel:  domain hash size = 128
<6>[    1.791245] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    1.796243] NetLabel:  unlabeled traffic allowed by default
<6>[    1.802310] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
<6>[    1.807276] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
<6>[    1.815200] Switched to clocksource hpet
<6>[    1.862271] pnp: PnP ACPI init
<6>[    1.865894] system 00:00: [mem 0xc0000000-0xcfffffff] has been reserved
<6>[    1.872541] system 00:00: [mem 0xbff00000-0xbfffffff] has been reserved
<6>[    1.879167] system 00:00: [mem 0xfee00000-0xfeefffff] has been reserved
<7>[    1.885800] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    1.893086] system 00:01: [io  0x0a00-0x0a1f] has been reserved
<7>[    1.899034] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    1.906869] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:15)
<7>[    1.914903] pnp 00:02: [dma 0 disabled]
<7>[    1.918926] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
<7>[    1.925539] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:15)
<7>[    1.933618] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>[    1.940372] system 00:04: [io  0x04d0-0x04d1] has been reserved
<7>[    1.946316] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    1.953792] pnp 00:05: Plug and Play ACPI device, IDs IPI0001 (active)
<6>[    1.961499] system 00:06: [io  0x0900-0x097f] could not be reserved
<6>[    1.967794] system 00:06: [io  0x09c0-0x09ff] has been reserved
<6>[    1.973732] system 00:06: [io  0x0400-0x043f] has been reserved
<6>[    1.979668] system 00:06: [io  0x0500-0x057f] has been reserved
<6>[    1.985608] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
<6>[    1.992584] system 00:06: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    1.999214] system 00:06: [mem 0x000c0000-0x000dffff] could not be reserved
<6>[    2.006190] system 00:06: [mem 0x000e0000-0x000effff] could not be reserved
<6>[    2.013168] system 00:06: [mem 0x000f0000-0x000fffff] could not be reserved
<6>[    2.020144] system 00:06: [mem 0xff800000-0xffffffff] has been reserved
<7>[    2.026777] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    2.033844] system 00:07: [mem 0xbfef0000-0xbfefffff] has been reserved
<7>[    2.040486] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    2.048096] pnp: PnP ACPI: found 8 devices
<6>[    2.064013] pci 0000:00:01.0: PCI bridge to [bus 01]
<6>[    2.069007] pci 0000:00:01.0:   bridge window [mem 0xfe300000-0xfe3fffff]
<6>[    2.075819] pci 0000:00:02.0: PCI bridge to [bus 02]
<6>[    2.080797] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
<6>[    2.086909] pci 0000:00:02.0:   bridge window [mem 0xfe200000-0xfe2fffff]
<6>[    2.093719] pci 0000:03:00.0: PCI bridge to [bus 04]
<6>[    2.098702] pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
<6>[    2.104816] pci 0000:03:00.0:   bridge window [mem 0xfd000000-0xfe0fffff]
<6>[    2.111626] pci 0000:00:03.0: PCI bridge to [bus 03-04]
<6>[    2.116868] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
<6>[    2.122980] pci 0000:00:03.0:   bridge window [mem 0xfd000000-0xfe0fffff]
<6>[    2.129790] pci 0000:00:04.0: PCI bridge to [bus 05]
<6>[    2.134775] pci 0000:00:04.0:   bridge window [io  0xc000-0xcfff]
<6>[    2.140888] pci 0000:00:04.0:   bridge window [mem 0xfe100000-0xfe1fffff]
<6>[    2.147689] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
<7>[    2.155452] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
<7>[    2.161035] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
<7>[    2.166623] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
<7>[    2.172213] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
<7>[    2.177796] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
<7>[    2.184079] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
<7>[    2.190355] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xfeffffff]
<7>[    2.196717] pci_bus 0000:01: resource 1 [mem 0xfe300000-0xfe3fffff]
<7>[    2.203000] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
<7>[    2.208581] pci_bus 0000:02: resource 1 [mem 0xfe200000-0xfe2fffff]
<7>[    2.214857] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
<7>[    2.220437] pci_bus 0000:03: resource 1 [mem 0xfd000000-0xfe0fffff]
<7>[    2.226712] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
<7>[    2.232294] pci_bus 0000:04: resource 1 [mem 0xfd000000-0xfe0fffff]
<7>[    2.238570] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
<7>[    2.244152] pci_bus 0000:05: resource 1 [mem 0xfe100000-0xfe1fffff]
<7>[    2.250436] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
<6>[    2.257750] NET: Registered protocol family 2
<6>[    2.262774] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
<6>[    2.270662] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>[    2.278120] TCP: Hash tables configured (established 65536 bind 65536)
<6>[    2.284884] TCP: reno registered
<6>[    2.288220] UDP hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    2.294456] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
<6>[    2.301361] NET: Registered protocol family 1
<6>[    2.306121] RPC: Registered named UNIX socket transport module.
<6>[    2.312097] RPC: Registered udp transport module.
<6>[    2.316817] RPC: Registered tcp transport module.
<6>[    2.321540] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    2.328620] IOAPIC[0]: Set routing entry (2-21 -> 0x41 -> IRQ 21 Mode:1 Active:1 Dest:15)
<7>[    2.337078] pci 0000:04:00.0: Video device with shadowed ROM
<7>[    2.342772] PCI: CLS 64 bytes, default 64
<6>[    2.347028] Unpacking initramfs...
<6>[   11.770395] Freeing initrd memory: 178816K (ffff880233160000 - ffff88023e000000)
<6>[   11.777876] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[   11.784343] software IO TLB [mem 0xbb67b000-0xbf67b000] (64MB) mapped at [ffff8800bb67b000-ffff8800bf67afff]
<6>[   11.797247] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>[   11.803497] Initialise system trusted keyring
<6>[   11.807920] audit: initializing netlink subsys (disabled)
<5>[   11.813372] audit: type=2000 audit(1416320274.099:1): initialized
<6>[   11.820414] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[   11.833220] zpool: loaded
<6>[   11.835889] zbud: loaded
<5>[   11.838933] VFS: Disk quotas dquot_6.5.2
<6>[   11.843032] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[   11.852103] SGI XFS with ACLs, security attributes, no debug enabled
<6>[   11.860006] 9p: Installing v9fs 9p2000 file system support
<5>[   11.865859] Key type big_key registered
<7>[   11.869722] SELinux:  Registering netfilter hooks
<6>[   11.876031] NET: Registered protocol family 38
<5>[   11.880535] Key type asymmetric registered
<5>[   11.884654] Asymmetric key parser 'x509' registered
<6>[   11.889732] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
<6>[   11.897271] io scheduler noop registered
<6>[   11.901226] io scheduler deadline registered (default)
<6>[   11.906423] io scheduler cfq registered
<7>[   11.911300] IOAPIC[0]: Set routing entry (2-22 -> 0x61 -> IRQ 22 Mode:1 Active:1 Dest:15)
<7>[   11.920177] IOAPIC[0]: Set routing entry (2-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:15)
<7>[   11.929024] IOAPIC[0]: Set routing entry (2-16 -> 0xa1 -> IRQ 16 Mode:1 Active:1 Dest:15)
<7>[   11.937542] aer 0000:00:01.0:pcie02: service driver aer loaded
<7>[   11.943457] aer 0000:00:02.0:pcie02: service driver aer loaded
<7>[   11.949363] aer 0000:00:03.0:pcie02: service driver aer loaded
<6>[   11.949371] pcieport 0000:00:03.0: AER: Multiple Uncorrected (Non-Fatal) error received: id=0018
<7>[   11.949384] pcieport 0000:00:03.0: can't find device of ID0018
<7>[   11.969916] aer 0000:00:04.0:pcie02: service driver aer loaded
<6>[   11.975821] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
<6>[   11.982796] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
<7>[   11.989340] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
<6>[   11.996078] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
<6>[   12.003047] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
<7>[   12.009588] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
<6>[   12.016323] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
<6>[   12.023300] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
<6>[   12.029839] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
<7>[   12.036384] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
<6>[   12.043122] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
<6>[   12.050095] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
<6>[   12.056637] pci 0000:05:00.1: Signaling PME through PCIe PME interrupt
<7>[   12.063183] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
<6>[   12.069921] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[   12.075579] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<7>[   12.082315] intel_idle: MWAIT substates: 0x3020220
<7>[   12.087120] intel_idle: v0.4 model 0x36
<7>[   12.090972] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[   12.097498] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
<6>[   12.105870] ACPI: Power Button [PWRB]
<6>[   12.117954] thermal LNXTHERM:00: registered as thermal_zone0
<6>[   12.123637] ACPI: Thermal Zone [TZ00] (34 C)
<3>[   12.128068] ERST: Can not request [mem 0xbfc6303f-0xbfc6503e] for ERST.
<4>[   12.134775] [Firmware Warn]: GHES: Poll interval is 0 for generic hardware error source: 1, disabled.
<6>[   12.144302] GHES: APEI firmware first mode is enabled by WHEA _OSC.
<6>[   12.150946] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
<6>[   12.177937] serial 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
<6>[   12.206743] platform serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
<6>[   12.236856] serial 0000:00:14.0: ttyS2 at I/O 0xf000 (irq = 16, base_baud = 115200) is a 16550A
<6>[   12.246652] Non-volatile memory driver v1.3
<6>[   12.250901] Linux agpgart interface v0.103
<3>[   12.255350] error detecting cacheinfo..cpu0
<6>[   12.259812] rdac: device handler registered
<6>[   12.264190] hp_sw: device handler registered
<6>[   12.268484] emc: device handler registered
<6>[   12.272597] alua: device handler registered
<6>[   12.276947] libphy: Fixed MDIO Bus: probed
<6>[   12.281199] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
<6>[   12.288256] e1000: Copyright (c) 1999-2006 Intel Corporation.
<6>[   12.294065] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
<6>[   12.299912] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
<6>[   12.305892] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
<6>[   12.312949] igb: Copyright (c) 2007-2014 Intel Corporation.
<6>[   12.705681] igb 0000:05:00.0: added PHC on eth0
<6>[   12.710243] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connection
<6>[   12.717133] igb 0000:05:00.0: eth0: (PCIe:5.0Gb/s:Width x2) 00:1e:67:68:b4:20
<6>[   12.724360] igb 0000:05:00.0: eth0: PBA No: 106100-000
<6>[   12.729514] igb 0000:05:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
<6>[   12.795705] tsc: Refined TSC clocksource calibration: 1600.055 MHz
<6>[   12.802130] igb 0000:05:00.1: added PHC on eth1
<6>[   12.806692] igb 0000:05:00.1: Intel(R) Gigabit Ethernet Network Connection
<6>[   12.813576] igb 0000:05:00.1: eth1: (PCIe:5.0Gb/s:Width x2) 00:1e:67:68:b4:21
<6>[   12.820807] igb 0000:05:00.1: eth1: PBA No: 106100-000
<6>[   12.825961] igb 0000:05:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
<6>[   12.833629] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.19.1-k
<6>[   12.841391] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
<6>[   12.847410] usbcore: registered new interface driver catc
<6>[   12.852854] usbcore: registered new interface driver kaweth
<6>[   12.858441] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
<6>[   12.865872] usbcore: registered new interface driver pegasus
<6>[   12.871578] usbcore: registered new interface driver rtl8150
<6>[   12.877297] usbcore: registered new interface driver asix
<6>[   12.882748] usbcore: registered new interface driver cdc_ether
<6>[   12.888628] usbcore: registered new interface driver cdc_eem
<6>[   12.894329] usbcore: registered new interface driver dm9601
<6>[   12.899958] usbcore: registered new interface driver smsc75xx
<6>[   12.905754] usbcore: registered new interface driver smsc95xx
<6>[   12.911554] usbcore: registered new interface driver gl620a
<6>[   12.917169] usbcore: registered new interface driver net1080
<6>[   12.922871] usbcore: registered new interface driver plusb
<6>[   12.928400] usbcore: registered new interface driver rndis_host
<6>[   12.934364] usbcore: registered new interface driver cdc_subset
<6>[   12.940330] usbcore: registered new interface driver zaurus
<6>[   12.945944] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
<6>[   12.953390] usbcore: registered new interface driver int51x1
<6>[   12.959092] usbcore: registered new interface driver ipheth
<6>[   12.964719] usbcore: registered new interface driver sierra_net
<6>[   12.971105] xhci_hcd 0000:01:00.0: xHCI Host Controller
<6>[   12.976571] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 1
<6>[   12.984552] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[   12.991365] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   12.998602] usb usb1: Product: xHCI Host Controller
<6>[   13.003498] usb usb1: Manufacturer: Linux 3.18.0-rc4-next-20141117 xhci-hcd
<6>[   13.010475] usb usb1: SerialNumber: 0000:01:00.0
<6>[   13.015560] hub 1-0:1.0: USB hub found
<6>[   13.019378] hub 1-0:1.0: 2 ports detected
<6>[   13.023722] xhci_hcd 0000:01:00.0: xHCI Host Controller
<6>[   13.029140] xhci_hcd 0000:01:00.0: new USB bus registered, assigned bus number 2
<6>[   13.036742] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
<6>[   13.043550] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[   13.050785] usb usb2: Product: xHCI Host Controller
<6>[   13.055674] usb usb2: Manufacturer: Linux 3.18.0-rc4-next-20141117 xhci-hcd
<6>[   13.062649] usb usb2: SerialNumber: 0000:01:00.0
<6>[   13.067712] hub 2-0:1.0: USB hub found
<6>[   13.071513] hub 2-0:1.0: 2 ports detected
<6>[   13.075914] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[   13.082477] ehci-pci: EHCI PCI platform driver
<6>[   13.086983] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[   13.093192] ohci-pci: OHCI PCI platform driver
<6>[   13.097681] uhci_hcd: USB Universal Host Controller Interface driver
<6>[   13.104226] usbcore: registered new interface driver usbserial
<6>[   13.110112] usbcore: registered new interface driver usbserial_generic
<6>[   13.116678] usbserial: USB Serial support registered for generic
<6>[   13.122888] i8042: PNP: No PS/2 controller found. Probing ports directly.
<3>[   14.163496] i8042: No controller found
<6>[   14.167292] Switched to clocksource tsc
<6>[   14.167580] mousedev: PS/2 mouse device common for all mice
<6>[   14.168089] rtc_cmos 00:03: RTC can wake from S4
<6>[   14.168405] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
<6>[   14.168456] rtc_cmos 00:03: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
<6>[   14.168549] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
<6>[   14.168586] iTCO_vendor_support: vendor-support=0
<6>[   14.169717] hidraw: raw HID events driver (C) Jiri Kosina
<6>[   14.170236] usbcore: registered new interface driver usbhid
<6>[   14.170237] usbhid: USB HID core driver
<6>[   14.170315] drop_monitor: Initializing network drop monitor service
<6>[   14.170486] TCP: cubic registered
<6>[   14.170500] Initializing XFRM netlink socket
<6>[   14.171076] NET: Registered protocol family 10
<6>[   14.172025] NET: Registered protocol family 17
<6>[   14.172061] 9pnet: Installing 9P2000 support
<6>[   14.173189] ... APIC ID:      00000000 (0)
<6>[   14.173191] ... APIC VERSION: 00050014
<4>[   14.173202] 0000000000000000000000000000000000000000000000000000000000000000
<4>[   14.173209] 0000000000000000000000020000000200000000000000020000000000000000
<4>[   14.173216] 0000000000000000000000000000000000000000000000000000000000000000
<4>[   14.173218] 
<7>[   14.173223] number of MP IRQ sources: 15.
<7>[   14.173225] number of IO-APIC #2 registers: 24.
<6>[   14.173226] testing the IO APIC.......................
<7>[   14.173234] IO APIC #2......
<7>[   14.173235] .... register #00: 02000000
<7>[   14.173237] .......    : physical APIC id: 02
<7>[   14.173238] .......    : Delivery Type: 0
<7>[   14.173239] .......    : LTS          : 0
<7>[   14.173240] .... register #01: 00170020
<7>[   14.173241] .......     : max redirection entries: 17
<7>[   14.173242] .......     : PRQ implemented: 0
<7>[   14.173243] .......     : IO APIC version: 20
<7>[   14.173244] .... IRQ redirection table:
<4>[   14.173250] 1    0    0   0   0    0    0    00
<4>[   14.173255] 0    0    0   0   0    1    1    31
<4>[   14.173260] 0    0    0   0   0    1    1    30
<4>[   14.173265] 0    0    0   0   0    1    1    33
<4>[   14.173272] 1    0    0   0   0    1    1    34
<4>[   14.173278] 1    0    0   0   0    1    1    35
<4>[   14.173283] 0    0    0   0   0    1    1    36
<4>[   14.173289] 0    0    0   0   0    1    1    37
<4>[   14.173294] 0    0    0   0   0    1    1    38
<4>[   14.173300] 0    1    0   0   0    1    1    39
<4>[   14.173305] 0    0    0   0   0    1    1    3A
<4>[   14.173311] 0    0    0   0   0    1    1    3B
<4>[   14.173316] 0    0    0   0   0    1    1    3C
<4>[   14.173322] 0    0    0   0   0    1    1    3D
<4>[   14.173327] 0    0    0   0   0    1    1    3E
<4>[   14.173333] 0    0    0   0   0    1    1    3F
<4>[   14.173338] 1    1    0   1   0    1    1    A1
<4>[   14.173344] 1    0    0   0   0    0    0    00
<4>[   14.173349] 1    0    0   0   0    0    0    00
<4>[   14.173355] 1    0    0   0   0    0    0    00
<4>[   14.173361] 1    0    0   0   0    0    0    00
<4>[   14.173366] 1    1    0   1   0    1    1    41
<4>[   14.173372] 1    1    0   1   0    1    1    61
<4>[   14.173377] 1    1    0   1   0    1    1    81
<7>[   14.173378] IRQ to pin mappings:
<7>[   14.173384] IRQ0 -> 0:2
<7>[   14.173387] IRQ1 -> 0:1
<7>[   14.173390] IRQ3 -> 0:3
<7>[   14.173392] IRQ4 -> 0:4
<7>[   14.173395] IRQ5 -> 0:5
<7>[   14.173398] IRQ6 -> 0:6
<7>[   14.173400] IRQ7 -> 0:7
<7>[   14.173403] IRQ8 -> 0:8
<7>[   14.173406] IRQ9 -> 0:9
<7>[   14.173408] IRQ10 -> 0:10
<7>[   14.173411] IRQ11 -> 0:11
<7>[   14.173414] IRQ12 -> 0:12
<7>[   14.173417] IRQ13 -> 0:13
<7>[   14.173420] IRQ14 -> 0:14
<7>[   14.173422] IRQ15 -> 0:15
<7>[   14.173426] IRQ16 -> 0:16
<7>[   14.173428] IRQ21 -> 0:21
<7>[   14.173431] IRQ22 -> 0:22
<7>[   14.173434] IRQ23 -> 0:23
<6>[   14.173441] .................................... done.
<5>[   14.173953] Loading compiled-in X.509 certificates
<5>[   14.179745] Loaded X.509 cert 'Magrathea: Glacier signing key: dccb5c83b0b8f8d191ef88cf5322ac96b03f7b4f'
<6>[   14.179810] registered taskstats version 1
<5>[   14.185493] Key type trusted registered
<5>[   14.190708] Key type encrypted registered
<6>[   14.195764] ima: No TPM chip found, activating TPM-bypass!
<6>[   14.195895] evm: HMAC attrs: 0x1
<6>[   14.200672] rtc_cmos 00:03: setting system clock to 2014-11-18 14:17:58 UTC (1416320278)
<6>[   14.244820] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
<6>[   14.288262] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
<6>[   14.294781] usb 1-1: new high-speed USB device number 2 using xhci_hcd
<6>[   14.414002] usb 1-1: New USB device found, idVendor=0624, idProduct=0248
<6>[   14.414007] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<6>[   14.414011] usb 1-1: Product: Gadget USB HUB
<6>[   14.414014] usb 1-1: Manufacturer: no manufacturer
<6>[   14.414017] usb 1-1: SerialNumber: 0123456789
<6>[   14.418489] hub 1-1:1.0: USB hub found
<6>[   14.423108] hub 1-1:1.0: 5 ports detected
<6>[   14.697355] usb 1-1.1: new high-speed USB device number 3 using xhci_hcd
<6>[   14.782360] usb 1-1.1: New USB device found, idVendor=0624, idProduct=0249
<6>[   14.789267] usb 1-1.1: New USB device strings: Mfr=4, Product=5, SerialNumber=6
<6>[   14.796590] usb 1-1.1: Product: Keyboard/Mouse Function
<6>[   14.801830] usb 1-1.1: Manufacturer: Avocent
<6>[   14.806117] usb 1-1.1: SerialNumber: 20120124
<6>[   14.821012] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:0624:0249.0001/input/input1
<6>[   14.886980] hid-generic 0003:0624:0249.0001: input,hidraw0: USB HID v1.00 Keyboard [Avocent Keyboard/Mouse Function] on usb-0000:01:00.0-1.1/input0
<6>[   14.904117] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/1-1.1/1-1.1:1.1/0003:0624:0249.0002/input/input2
<6>[   14.918592] hid-generic 0003:0624:0249.0002: input,hidraw1: USB HID v1.00 Mouse [Avocent Keyboard/Mouse Function] on usb-0000:01:00.0-1.1/input1
<6>[   14.934282] input: Avocent Keyboard/Mouse Function as /devices/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/1-1.1/1-1.1:1.2/0003:0624:0249.0003/input/input3
<6>[   14.948788] hid-generic 0003:0624:0249.0003: input,hidraw2: USB HID v1.00 Mouse [Avocent Keyboard/Mouse Function] on usb-0000:01:00.0-1.1/input2
<6>[   16.020853] igb 0000:05:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
<6>[   16.030982] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<5>[   16.041827] Sending DHCP requests ..., OK
<4>[   25.311243] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.113
<6>[   25.347898] IP-Config: Complete:
<6>[   25.351168]      device=eth0, hwaddr=00:1e:67:68:b4:20, ipaddr=192.168.1.113, mask=255.255.255.0, gw=192.168.1.1
<6>[   25.361349]      host=lkp-a06, domain=lkp.intel.com, nis-domain=(none)
<6>[   25.367884]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
<6>[   25.374592]      nameserver0=192.168.1.1
<7>[   25.378759] PM: Hibernation image not present or could not be loaded.
<6>[   25.389390] Freeing unused kernel memory: 1844K (ffffffff81e27000 - ffffffff81ff4000)
<6>[   25.929573] ipmi message handler version 39.2
<6>[   25.947921] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
<6>[   25.967963] IPMI System Interface driver.
<6>[   25.972207] ipmi_si: probing via ACPI
<7>[   25.983001] libata version 3.00 loaded.
<6>[   25.994321] input: PC Speaker as /devices/platform/pcspkr/input/input4
<6>[   26.006206] ipmi_si 00:05: [io  0x0ca0] regsize 1 spacing 4 irq 0
<6>[   26.012359] ipmi_si: Adding ACPI-specified kcs state machine
<7>[   26.034280] ahci 0000:02:00.0: version 3.0
<4>[   26.046136] 
<6>[   26.047731] ipmi_si: probing via SMBIOS
<6>[   26.051616] ipmi_si: SMBIOS: io 0xca0 regsize 1 spacing 1 irq 0
<6>[   26.057575] ipmi_si: Adding SMBIOS-specified kcs state machine
<6>[   26.063405] ahci 0000:02:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
<6>[   26.071881] ahci 0000:02:00.0: flags: 64bit ncq pio 
<6>[   26.086893] [drm] Initialized drm 1.1.0 20060810
<4>[   26.092971]  duplicate interface
<6>[   26.103897] ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca0, slave address 0x0, irq 0
<6>[   26.114364] scsi host0: ahci
<6>[   26.118499] scsi host1: ahci
<6>[   26.136241] scsi host2: ahci
<4>[   26.139736] ie6xx_wdt ie6xx_wdt.3168: Watchdog Timer is Locked (Reg=0x1)
<6>[   26.146779] scsi host3: ahci
<6>[   26.157202] scsi host4: ahci
<6>[   26.160735] scsi host5: ahci
<6>[   26.166239] scsi host6: ahci
<6>[   26.169641] scsi host7: ahci
<6>[   26.172906] ata1: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210100 irq 53
<6>[   26.180382] ata2: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210180 irq 53
<6>[   26.187855] ata3: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210200 irq 53
<6>[   26.195311] ata4: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210280 irq 53
<6>[   26.202765] ata5: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210300 irq 53
<6>[   26.210207] ata6: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210380 irq 53
<6>[   26.217665] ata7: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210400 irq 53
<6>[   26.221277] ipmi_si 00:05: Found new BMC (man_id: 0x002b99, prod_id: 0x0000, dev_id: 0x20)
<6>[   26.221305] ipmi_si 00:05: IPMI kcs interface initialized
<6>[   26.238844] ata8: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210480 irq 53
<3>[   26.247308] Error: Driver 'pcspkr' is already registered, aborting...
<6>[   26.248382] [drm] AST 2300 detected
<6>[   26.248411] [drm] Analog VGA only
<6>[   26.248441] [drm] dram 1632000000 1 32 01000000
<6>[   26.249923] [TTM] Zone  kernel: Available graphics memory: 4082828 kiB
<6>[   26.249926] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
<6>[   26.249928] [TTM] Initializing pool allocator
<6>[   26.249947] [TTM] Initializing DMA pool allocator
<6>[   26.287393] fbcon: astdrmfb (fb0) is primary device
<6>[   26.305243] Console: switching to colour frame buffer device 128x48
<6>[   26.351255] ast 0000:04:00.0: fb0: astdrmfb frame buffer device
<6>[   26.357311] ast 0000:04:00.0: registered panic notifier
<6>[   26.377195] [drm] Initialized ast 0.1.0 20120228 for 0000:04:00.0 on minor 0
<6>[   26.553390] ata3: SATA link down (SStatus 0 SControl 300)
<6>[   26.559289] ata2: SATA link down (SStatus 0 SControl 300)
<6>[   26.565166] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[   26.571703] ata7: SATA link down (SStatus 0 SControl 300)
<6>[   26.577261] ata8.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
<6>[   26.583509] ata4: SATA link down (SStatus 0 SControl 300)
<6>[   26.589142] ata5: SATA link down (SStatus 0 SControl 300)
<6>[   26.594706] ata6: SATA link down (SStatus 0 SControl 300)
<6>[   26.600288] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[   26.606890] ata8.00: configured for UDMA/66
<6>[   26.663301] ata1.00: ATA-8: TOSHIBA MK8061GSYB, ME0A, max UDMA/100
<6>[   26.669696] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<6>[   26.679035] ata1.00: configured for UDMA/100
<5>[   26.683880] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK8061GS ME0A PQ: 0 ANSI: 5
<5>[   26.694333] scsi 7:0:0:0: Processor         Marvell  91xx Config      1.01 PQ: 0 ANSI: 5
<3>[   26.714374] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
<3>[   26.721191] ata8.00: irq_stat 0x40000001
<6>[   26.725323] scsi 7:0:0:0: CDB: 
<4>[   26.728621] Inquiry: 12 01 00 00 ff 00
<3>[   26.740240] ata8.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 dma 16640 in
<3>[   26.740240]          res 50/00:02:00:00:00/00:00:00:00:00/a0 Emask 0x1 (device error)
<3>[   26.770315] ata8.00: status: { DRDY }
<5>[   26.898845] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
<5>[   26.899372] sd 0:0:0:0: [sda] Write Protect is off
<7>[   26.899389] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[   26.899611] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<5>[   26.946427] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>[   26.959703] scsi 7:0:0:0: Attached scsi generic sg1 type 3
<6>[   26.960924]  sda: sda1 sda2
<5>[   26.962231] sd 0:0:0:0: [sda] Attached SCSI disk
<6>[   27.287174] raid6: sse2x1     140 MB/s
<6>[   27.311343] raid6: sse2x2     218 MB/s
<6>[   27.335176] raid6: sse2x4     382 MB/s
<6>[   27.342214] raid6: using algorithm sse2x4 (382 MB/s)
<6>[   27.350431] raid6: using ssse3x2 recovery algorithm
<6>[   27.369794] xor: measuring software checksum speed
<6>[   27.384102]    prefetch64-sse: 11968.000 MB/sec
<6>[   27.401093]    generic_sse:  4732.000 MB/sec
<6>[   27.408576] xor: using function: prefetch64-sse (11968.000 MB/sec)
<6>[   27.538857] Btrfs loaded
<6>[   27.550221] BTRFS: device fsid 91075fbe-9acf-4d0e-ad71-6c2ed15f00ab devid 1 transid 14 /dev/sda1
<5>[   29.716484] random: dd urandom read with 82 bits of entropy available
<6>[   41.455872] loop: module loaded
<6>[   41.675440] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[   41.677393] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[   41.839955] Process accounting resumed
<6>[   41.874362] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[   41.876456] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[   41.877528] EXT4-fs (loop0): re-mounted. Opts: (null)
<5>[   52.550675] random: nonblocking pool is initialized
<6>[   70.293816] capability: warning: `capget01' uses 32-bit capabilities (legacy support in use)
<6>[   70.479648] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[   70.482081] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[   70.733198] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[   70.734790] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[   70.911772] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[   70.913383] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<2>[  100.155905] IPMI Watchdog: Unable to register misc device
<4>[  100.163217] IPMI Watchdog: set timeout error: -22
<6>[  100.169814] IPMI Watchdog: driver initialized
<6>[  123.906028] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  123.907597] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  147.814893] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  147.817344] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  147.819600] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[  148.086172] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  148.087924] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  148.089224] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[  148.306122] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  148.307839] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  148.311653] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[  839.117618] tun: Universal TUN/TAP device driver, 1.6
<6>[  839.117621] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
<6>[  839.184649] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  839.187724] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<4>[  839.494114] ------------[ cut here ]------------
<4>[  839.494131] WARNING: CPU: 0 PID: 13608 at /kbuild/src/lkp/kernel/sched/core.c:7323 __might_sleep+0xbd/0xd0()
<4>[  839.494137] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff810b3fff>] prepare_to_wait+0x2f/0x90
<4>[  839.494256] Modules linked in: tun ipmi_watchdog loop btrfs xor raid6_pq sg sd_mod ast snd_pcm syscopyarea sysfillrect snd_timer sysimgblt snd ie6xx_wdt ttm i2c_isch drm_kms_helper soundcore drm ahci libahci pcspkr i2c_ismt lpc_sch ipmi_si libata shpchp ipmi_msghandler acpi_cpufreq
<4>[  839.494264] CPU: 0 PID: 13608 Comm: fanotify01 Not tainted 3.18.0-rc4-next-20141117 #1
<4>[  839.494266] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Double Cove , BIOS BWDEXT.86B.000.012.D127 10/08/2012
<4>[  839.494273]  ffffffff81b5ebb8 ffff88023cf37d18 ffffffff81892f54 0000000064026402
<4>[  839.494277]  ffff88023cf37d68 ffff88023cf37d58 ffffffff8107047a ffff88023cf37db8
<4>[  839.494281]  ffffffff81b5f5e8 0000000000000061 0000000000000000 0000000000006000
<4>[  839.494285] Call Trace:
<4>[  839.494315]  [<ffffffff81892f54>] dump_stack+0x4c/0x65
<4>[  839.494323]  [<ffffffff8107047a>] warn_slowpath_common+0x8a/0xc0
<4>[  839.494327]  [<ffffffff810704f6>] warn_slowpath_fmt+0x46/0x50
<4>[  839.494333]  [<ffffffff810b3fff>] ? prepare_to_wait+0x2f/0x90
<4>[  839.494337]  [<ffffffff810b3fff>] ? prepare_to_wait+0x2f/0x90
<4>[  839.494341]  [<ffffffff810961fd>] __might_sleep+0xbd/0xd0
<4>[  839.494348]  [<ffffffff81898974>] mutex_lock+0x24/0x50
<4>[  839.494354]  [<ffffffff812250f5>] fanotify_read+0xd5/0x620
<4>[  839.494370]  [<ffffffff8139c906>] ? selinux_file_permission+0xa6/0x120
<4>[  839.494374]  [<ffffffff810b43e0>] ? wait_woken+0xc0/0xc0
<4>[  839.494381]  [<ffffffff811e14c8>] __vfs_read+0x18/0x50
<4>[  839.494385]  [<ffffffff811e158a>] vfs_read+0x8a/0x140
<4>[  839.494390]  [<ffffffff811e1686>] SyS_read+0x46/0xb0
<4>[  839.494403]  [<ffffffff8189b629>] system_call_fastpath+0x12/0x17
<4>[  839.494409] ---[ end trace 5a2207521429f889 ]---
<6>[  857.378636] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  857.381306] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  857.612231] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  857.615669] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  857.897048] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  857.898582] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  857.900089] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[  858.103915] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  858.105469] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  859.406545] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[  859.777310] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  859.778531] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  870.099752] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  870.100875] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  870.408353] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  870.410490] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  870.623338] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  870.624983] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<4>[  870.941929] Bits 55-60 of /proc/PID/pagemap entries are about to stop being page-shift some time soon. See the linux/Documentation/vm/pagemap.txt for details.
<6>[  871.014228] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.015540] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.115411] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.116794] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.279943] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.281154] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.442273] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.443659] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.467234] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.469202] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.565898] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.567132] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.626074] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.627339] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.787907] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.789127] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.896159] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  871.897336] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  871.897554] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[  872.007870] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  872.009190] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  872.117640] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  872.119294] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[  873.433010] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[  873.434564] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<5>[ 1343.191428] audit: type=1702 audit(1416292807.730:2): op=follow_link ppid=1718 pid=32527 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="prot_hsymlinks" exe="/lkp/benchmarks/ltp/testcases/bin/prot_hsymlinks" subj=kernel res=0
<5>[ 1343.191456] audit: type=1302 audit(1416292807.730:3): item=0 name="/tmp/ltp-p9qoDuvZd5/prokoSV8w/tmp_root/link_4" inode=303596 dev=00:16 mode=0120777 ouid=1085 ogid=1085 rdev=00:00 obj=unlabeled nametype=NORMAL
<5>[ 1343.191511] audit: type=1702 audit(1416292807.730:4): op=follow_link ppid=1718 pid=32527 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="prot_hsymlinks" exe="/lkp/benchmarks/ltp/testcases/bin/prot_hsymlinks" subj=kernel res=0
<5>[ 1343.191527] audit: type=1302 audit(1416292807.730:5): item=0 name="/tmp/ltp-p9qoDuvZd5/prokoSV8w/tmp_root/link_4" inode=303596 dev=00:16 mode=0120777 ouid=1085 ogid=1085 rdev=00:00 obj=unlabeled nametype=NORMAL
<5>[ 1343.191562] audit: type=1702 audit(1416292807.730:6): op=follow_link ppid=1718 pid=32527 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="prot_hsymlinks" exe="/lkp/benchmarks/ltp/testcases/bin/prot_hsymlinks" subj=kernel res=0
<5>[ 1343.191577] audit: type=1302 audit(1416292807.730:7): item=0 name="/tmp/ltp-p9qoDuvZd5/prokoSV8w/tmp_root/link_4" inode=303596 dev=00:16 mode=0120777 ouid=1085 ogid=1085 rdev=00:00 obj=unlabeled nametype=NORMAL
<5>[ 1343.191608] audit: type=1702 audit(1416292807.730:8): op=follow_link ppid=1718 pid=32527 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="prot_hsymlinks" exe="/lkp/benchmarks/ltp/testcases/bin/prot_hsymlinks" subj=kernel res=0
<5>[ 1343.191624] audit: type=1302 audit(1416292807.730:9): item=0 name="/tmp/ltp-p9qoDuvZd5/prokoSV8w/tmp_root/link_4" inode=303596 dev=00:16 mode=0120777 ouid=1085 ogid=1085 rdev=00:00 obj=unlabeled nametype=NORMAL
<5>[ 1343.191963] audit: type=1702 audit(1416292807.730:10): op=follow_link ppid=1718 pid=32527 auid=4294967295 uid=0 gid=0 euid=1085 suid=0 fsuid=1085 egid=1085 sgid=0 fsgid=1085 tty=(none) ses=4294967295 comm="prot_hsymlinks" exe="/lkp/benchmarks/ltp/testcases/bin/prot_hsymlinks" subj=kernel res=0
<5>[ 1343.191980] audit: type=1302 audit(1416292807.730:11): item=0 name="/tmp/ltp-p9qoDuvZd5/prokoSV8w/tmp_hsym/link_5" inode=303597 dev=00:16 mode=0120777 ouid=0 ogid=0 rdev=00:00 obj=unlabeled nametype=NORMAL
<6>[ 1366.525079] readahead02 (32638): drop_caches: 1
<6>[ 1366.771752] readahead02 (32638): drop_caches: 1
<4>[ 1367.057737] mmap: remap_file_page (32660) uses deprecated remap_file_pages() syscall. See Documentation/vm/remap_file_pages.txt.
<6>[ 1367.214085] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1367.215884] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1369.177761] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[ 1369.178555] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[ 1414.377106] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1414.379377] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1414.380839] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[ 1415.848521] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1415.851234] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1415.852227] EXT4-fs (loop0): re-mounted. Opts: (null)
<6>[ 1494.194333] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1494.195908] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1494.390489] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1494.391759] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1494.573350] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1494.574611] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1506.876862] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1506.879317] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1507.089008] EXT4-fs (loop0): mounting ext2 file system using the ext4 subsystem
<6>[ 1507.090981] EXT4-fs (loop0): mounted filesystem without journal. Opts: (null)
<6>[ 1507.092812] EXT4-fs (loop0): re-mounted. Opts: (null)

--TRYliJ5NKNqkz5bu--
