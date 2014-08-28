Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbaH1Fgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 01:36:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:59272 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaH1Fgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 01:36:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,416,1406617200"; 
   d="log'?scan'208";a="582727785"
Date: Thu, 28 Aug 2014 13:36:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [rcutorture] RIP: 0010:[<ffffffff8111b24f>] [<ffffffff8111b24f>]
 __might_sleep
Message-ID: <20140828053635.GA7361@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/exp

commit 86d8f10e35c1e63d5a839792efd7c3cb6a564fe4
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri Aug 22 14:03:38 2014 -0700
Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CommitDate: Wed Aug 27 10:00:30 2014 -0700

    rcutorture: Add preemption-slam testing
    
    This commit adds kernel threads whose sole purpose is to add random
    preemption of the code under test.  It adds four kernel boot parameters
    to control the number of preemption-slam kthreads, their real-time
    priority, the length of time that they sleep, and the length of time
    that they spin at the real-time priority.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================
Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+------------------------------------------------+------------+------------+------------------+
|                                                | b52938be99 | 86d8f10e35 | v3.17-rc2_082810 |
+------------------------------------------------+------------+------------+------------------+
| boot_successes                                 | 112        | 19         | 0                |
| boot_failures                                  | 8          | 9          | 11               |
| BUG:kernel_boot_crashed                        | 6          |            |                  |
| BUG:kernel_boot_hang                           | 2          |            |                  |
| RIP:__might_sleep                              | 0          | 2          | 7                |
| Kernel_panic-not_syncing:softlockup:hung_tasks | 0          | 9          | 11               |
| backtrace:stutter_wait                         | 0          | 2          | 5                |
| RIP:_cond_resched                              | 0          | 3          | 1                |
| backtrace:trace_apic_timer_interrupt           | 0          | 1          |                  |
| RIP:stutter_wait                               | 0          | 4          | 2                |
| backtrace:apic_timer_interrupt                 | 0          | 6          | 5                |
| RIP:function_test_events_call                  | 0          | 0          | 1                |
| backtrace:ftrace_call                          | 0          | 0          | 1                |
+------------------------------------------------+------------+------------+------------------+

[    9.123983] Testing event mm_vmscan_direct_reclaim_end: 
[   32.110003] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [torture_slam_kt:115]
[   32.110003] CPU: 1 PID: 115 Comm: torture_slam_kt Not tainted 3.17.0-rc2-00063-g86d8f10 #7
[   32.110003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   32.110003] task: ffff88000b395650 ti: ffff88000b210000 task.ti: ffff88000b210000
[   32.110003] RIP: 0010:[<ffffffff8111b24f>]  [<ffffffff8111b24f>] __might_sleep+0x18f/0x1a0
[   32.110003] RSP: 0000:ffff88000b213e10  EFLAGS: 00000202
[   32.110003] RAX: ffff88000b395650 RBX: 0000000000000000 RCX: 00000000000002a0
[   32.110003] RDX: 0000000000000073 RSI: 0000000000000276 RDI: ffffffff82da8b58
[   32.110003] RBP: ffff88000b213e10 R08: 0000000000000ae8 R09: 0000000000000000
[   32.110003] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000b213df0
[   32.110003] R13: ffff88000b213e10 R14: ffffffff8240723f R15: ffff88000b213d80
[   32.110003] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:0000000000000000
[   32.110003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.110003] CR2: 0000000000000000 CR3: 0000000003012000 CR4: 00000000000406e0
[   32.110003] Stack:
[   32.110003]  ffff88000b213e28 ffffffff8120075b ffff880009048c90 ffff88000b213e48
[   32.110003]  ffffffff81201063 0000006300000000 ffff880010e48300 ffff88000b213f48
[   32.110003]  ffffffff81105150 0000000000000000 ffff88000b395650 0000000000000000
[   32.110003] Call Trace:
[   32.110003]  [<ffffffff8120075b>] stutter_wait+0x9b/0x130
[   32.110003]  [<ffffffff81201063>] torture_slam_kthread+0xe3/0x190
[   32.110003]  [<ffffffff81105150>] kthread+0x130/0x160
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003]  [<ffffffff824087bc>] ret_from_fork+0x7c/0xb0
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003] Code: 44 00 00 48 83 05 c1 e5 a3 02 01 f6 c4 02 0f 84 ae fe ff ff 65 48 8b 04 25 00 b9 00 00 8b 90 b0 03 00 00 48 83 05 a9 e5 a3 02 01 <85> d2 0f 84 8f fe ff ff 5d c3 0f 1f 80 00 00 00 00 0f 1f 44 00 
[   32.110003] Kernel panic - not syncing: softlockup: hung tasks
[   32.110003] CPU: 1 PID: 115 Comm: torture_slam_kt Tainted: G             L 3.17.0-rc2-00063-g86d8f10 #7
[   32.110003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   32.110003]  0000000000000007 ffff880012403df8 ffffffff823f8f74 ffffffff82d98e85
[   32.110003]  ffff880012403e70 ffffffff823f0db6 0000000000000008 ffff880012403e80
[   32.110003]  ffff880012403e20 0000000000000001 0000000000000000 ffffffff811504f3
[   32.110003] Call Trace:
[   32.110003]  <IRQ>  [<ffffffff823f8f74>] dump_stack+0x85/0xba
[   32.110003]  [<ffffffff823f0db6>] panic+0x110/0x300
[   32.110003]  [<ffffffff811504f3>] ? console_unlock+0x373/0x680
[   32.110003]  [<ffffffff811ad3b3>] watchdog_timer_fn+0x283/0x2e0
[   32.110003]  [<ffffffff81171c99>] hrtimer_run_queues+0x159/0x470
[   32.110003]  [<ffffffff811ad130>] ? watchdog+0x40/0x40
[   32.110003]  [<ffffffff811708e2>] update_process_times+0x42/0xc0
[   32.110003]  [<ffffffff81183d08>] tick_periodic+0x38/0x130
[   32.110003]  [<ffffffff8118400e>] tick_handle_periodic+0x2e/0xb0
[   32.110003]  [<ffffffff81200f80>] ? torture_stutter+0x1d0/0x1d0
[   32.110003]  [<ffffffff81050dbf>] local_apic_timer_interrupt+0x3f/0x80
[   32.110003]  [<ffffffff8240b43f>] smp_apic_timer_interrupt+0x5f/0x80
[   32.110003]  [<ffffffff8240981d>] apic_timer_interrupt+0x6d/0x80
[   32.110003]  <EOI>  [<ffffffff8111b24f>] ? __might_sleep+0x18f/0x1a0
[   32.110003]  [<ffffffff8120075b>] stutter_wait+0x9b/0x130
[   32.110003]  [<ffffffff81201063>] torture_slam_kthread+0xe3/0x190
[   32.110003]  [<ffffffff81105150>] kthread+0x130/0x160
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003]  [<ffffffff824087bc>] ret_from_fork+0x7c/0xb0
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 40

git bisect start 8153a6bbcc340b292248b66a6db89b991fe23995 52addcf9d6669fa439387610bc65c92fa0980cef --
git bisect good fa5b2a0d6039cf49777a5dc734820b5b4935d569  # 10:55     25+      0  Merge 'spi/fix/dw' into devel-hourly-2014082810
git bisect  bad bab6cbcfc9ff6b0abb1506a6c42e93765f3c5162  # 11:04     11-     20  Merge 'arm-soc/for-next' into devel-hourly-2014082810
git bisect good 61ca93aaede4e63c82b1ce60cddab0f922290115  # 11:09     28+      4  Merge 'kvmarm/queue' into devel-hourly-2014082810
git bisect good 5cde56d94f0761101b235d1c88c674034bdd101a  # 11:23     28+      1  Merge 'netdev-next/master' into devel-hourly-2014082810
git bisect  bad dd7ed2643b17336d0103ddda2c385b59812a40b8  # 11:26      5-     14  Merge 'hid/for-3.18/picolcd' into devel-hourly-2014082810
git bisect  bad aa6fe56cf691d0587229cb5c21c44899fc312134  # 11:28      2-      6  Merge 'rcu/rcu/exp' into devel-hourly-2014082810
git bisect  bad a31a69e0a7601d78b242d1e0c367e53e6bdc47f8  # 11:31      1-      3  rcu: Eliminate deadlock between CPU hotplug and expedited grace periods
git bisect  bad 86d8f10e35c1e63d5a839792efd7c3cb6a564fe4  # 11:34      4-      6  rcutorture: Add preemption-slam testing
# first bad commit: [86d8f10e35c1e63d5a839792efd7c3cb6a564fe4] rcutorture: Add preemption-slam testing
git bisect good b52938be99a099b452979ed805b480337ee2df0f  # 11:41    120+      8  Merge branch 'rcu-tasks.2014.08.27a' into HEAD
git bisect  bad 8153a6bbcc340b292248b66a6db89b991fe23995  # 11:41      0-     11  0day head guard for 'devel-hourly-2014082810'
git bisect good f1bd473f95e02bc382d4dae94d7f82e2a455e05d  # 12:00    120+      3  Merge branch 'sec-v3.17-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-security
git bisect good d05446ae2128064a4bb8f74c84f6901ffb5c94bc  # 12:24    120+      4  Add linux-next specific files for 20140827


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-20:20140828113306:x86_64-randconfig-s1-08281038:3.17.0-rc2-00063-g86d8f10:7"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Linux version 3.17.0-rc2-00063-g86d8f10 (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #7 SMP Thu Aug 28 19:32:58 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-s1-08281038/linux-devel:devel-hourly-2014082810:86d8f10e35c1e63d5a8397=
92efd7c3cb6a564fe4:bisect-linux-8/.vmlinuz-86d8f10e35c1e63d5a839792efd7c3cb=
6a564fe4-20140828193329-3-kbuild branch=3Dlinux-devel/devel-hourly-20140828=
10 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-08281038/86d8f10e35c1e63d5a839=
792efd7c3cb6a564fe4/vmlinuz-3.17.0-rc2-00063-g86d8f10 drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04dc6000, 0x04dc6fff] PGTABLE
[    0.000000] BRK [0x04dc7000, 0x04dc7fff] PGTABLE
[    0.000000] BRK [0x04dc8000, 0x04dc8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x04dc9000, 0x04dc9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x04dca000, 0x04dcafff] PGTABLE
[    0.000000] BRK [0x04dcb000, 0x04dcbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012200000 s1918912 r0=
 d22592 u2097152
[    0.000000] pcpu-alloc: s1918912 r0 d22592 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1220ce00
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s1-08281038/linux-devel:devel-hourly-2014082810:86d8f10e35c1e63=
d5a839792efd7c3cb6a564fe4:bisect-linux-8/.vmlinuz-86d8f10e35c1e63d5a839792e=
fd7c3cb6a564fe4-20140828193329-3-kbuild branch=3Dlinux-devel/devel-hourly-2=
014082810 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-08281038/86d8f10e35c1e6=
3d5a839792efd7c3cb6a564fe4/vmlinuz-3.17.0-rc2-00063-g86d8f10 drbd.minor_cou=
nt=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Memory: 230008K/327280K available (20534K kernel code, 7361K=
 rwdata, 9716K rodata, 3632K init, 19440K bss, 97272K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.35 Bogo=
MIPS (lpj=3D8978173)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] ACPI: Core revision 20140724
[    0.010817] ACPI: All ACPI Tables successfully acquired
[    0.011858] Security Framework initialized
[    0.012451] AppArmor: AppArmor initialized
[    0.013043] Yama: becoming mindful.
[    0.013670] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.015390] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.016963] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.017919] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.019857] mce: CPU supports 10 MCE banks
[    0.020055] numa_add_cpu cpu 0 node 0: mask now 0
[    0.020742] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020742] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.022806] debug: unmapping init [mem 0xffffffff83abe000-0xffffffff83ac=
7fff]
[    0.028750] ftrace: allocating 48608 entries in 190 pages
[    0.047090] Getting VERSION: 1050014
[    0.047638] Getting VERSION: 1050014
[    0.048151] Getting ID: 0
[    0.050019] Getting ID: ff000000
[    0.050504] Getting LVT0: 8700
[    0.050953] Getting LVT1: 8400
[    0.051477] enabled ExtINT on CPU#0
[    0.053580] ENABLING IO-APIC IRQs
[    0.054097] init IO_APIC IRQs
[    0.054534]  apic 0 pin 0 not connected
[    0.055168] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.056424] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.056699] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.057862] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.060032] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.061166] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.062284] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.063362] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.064508] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.065768] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.066701] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.067835] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.068995] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.070032] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.071175] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.072345]  apic 0 pin 16 not connected
[    0.073338]  apic 0 pin 17 not connected
[    0.073918]  apic 0 pin 18 not connected
[    0.074558]  apic 0 pin 19 not connected
[    0.075213]  apic 0 pin 20 not connected
[    0.075771]  apic 0 pin 21 not connected
[    0.076672]  apic 0 pin 22 not connected
[    0.077259]  apic 0 pin 23 not connected
[    0.077956] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.078935] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, mode=
l: 3c, stepping: 01)
[    0.080311] TSC deadline timer enabled
[    0.081037] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.083333] Testing tracer nop: PASSED
[    0.086274] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.087586] x86: Booting SMP configuration:
[    0.088281] .... node  #0, CPUs:      #1
[    0.006666] kvm-clock: cpu 1, msr 0:13ff8041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.006666] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.103530] x86: Booted up 1 node, 2 CPUs
[    0.103471] KVM setup async PF for cpu 1
[    0.103471] kvm-stealtime: cpu 1, msr 1240ce00
[    0.105230] smpboot: Total of 2 processors activated (10778.71 BogoMIPS)
[    0.107921] devtmpfs: initialized
[    0.109075] gcov: version magic: 0x3430382a
[    0.133513] Testing tracer function: PASSED
[    0.301809] Testing dynamic ftrace: PASSED
[    0.600212] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 1 2 0 0) (2 1 =
3 0 193) (2 2 4 0 295) PASSED
[    0.816406] Testing dynamic ftrace ops #2: (1 0 1 183 0) (1 1 2 295 0) (=
2 1 3 2 386) (2 2 4 117 501) PASSED
[    1.054747] Testing ftrace recursion: PASSED
[    1.093340] Testing ftrace recursion safe: PASSED
[    1.132306] Testing ftrace regs: PASSED
[    1.243363] Testing tracer wakeup: ret =3D 0
[    1.457553] PASSED
[    1.477550] Testing tracer wakeup_rt: ret =3D 0
[    1.697500] PASSED
[    1.717518] Testing tracer wakeup_dl: ret =3D 0
[    1.933787] PASSED
[    1.953721] Testing tracer function_graph: PASSED
[    2.550624] xor: automatically using best checksumming function:
[    2.583367]    avx       :    93.600 MB/sec
[    2.584044] prandom: seed boundary self test passed
[    2.585421] prandom: 100 self tests passed
[    2.586752] regulator-dummy: no parameters
[    2.588253] NET: Registered protocol family 16
[    2.590021] cpuidle: using governor ladder
[    2.590617] cpuidle: using governor menu
[    2.591701] ACPI: bus type PCI registered
[    2.592435] PCI: Using configuration type 1 for base access
[    2.686699] raid6: sse2x1    1023 MB/s
[    2.743357] raid6: sse2x2    1556 MB/s
[    2.800046] raid6: sse2x4    1591 MB/s
[    2.800841] raid6: using algorithm sse2x4 (1591 MB/s)
[    2.801523] raid6: using ssse3x2 recovery algorithm
[    2.803716] ACPI: Added _OSI(Module Device)
[    2.804339] ACPI: Added _OSI(Processor Device)
[    2.805460] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.806248] ACPI: Added _OSI(Processor Aggregator Device)
[    2.819938] ACPI: Interpreter enabled
[    2.820021] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    2.821495] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    2.823095] ACPI: (supports S0 S3 S4 S5)
[    2.823345] ACPI: Using IOAPIC for interrupt routing
[    2.824196] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    2.839988] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.840020] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    2.840964] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    2.842642] PCI host bridge to bus 0000:00
[    2.843236] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.843346] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.844268] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.845176] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    2.846187] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    2.846769] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.848612] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.850680] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.854892] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    2.857073] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    2.858222] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    2.859243] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    2.860011] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    2.861477] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.862961] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    2.863362] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    2.865172] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.867515] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    2.870105] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    2.879471] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    2.881307] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.883346] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    2.885444] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    2.891781] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    2.893411] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    2.894937] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    2.902065] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.903265] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.903873] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.905134] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.906248] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    2.907920] ACPI: Enabled 16 GPEs in block 00 to 0F
[    2.910874] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    2.912092] vgaarb: loaded
[    2.912497] vgaarb: bridge control possible 0000:00:02.0
[    2.913333] SCSI subsystem initialized
[    2.913333] media: Linux media interface: v0.10
[    2.913333] Linux video capture interface: v2.00
[    2.913333] pps_core: LinuxPPS API ver. 1 registered
[    2.913333] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    2.913333] PTP clock support registered
[    2.917320] Advanced Linux Sound Architecture Driver Initialized.
[    2.918277] PCI: Using ACPI for IRQ routing
[    2.918872] PCI: pci_cache_line_size set to 64 bytes
[    2.919750] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    2.920019] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    2.921860] irda_init()
[    2.922339] NET: Registered protocol family 23
[    2.923078] Bluetooth: Core ver 2.19
[    2.923400] NET: Registered protocol family 31
[    2.924056] Bluetooth: HCI device and connection manager initialized
[    2.925003] Bluetooth: HCI socket layer initialized
[    2.925715] Bluetooth: L2CAP socket layer initialized
[    2.926518] Bluetooth: SCO socket layer initialized
[    2.926707] NET: Registered protocol family 8
[    2.927324] NET: Registered protocol family 20
[    2.928034] NetLabel: Initializing
[    2.928516] NetLabel:  domain hash size =3D 128
[    2.929134] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    2.929933] NetLabel:  unlabeled traffic allowed by default
[    2.934254] Switched to clocksource kvm-clock
[    3.027310] FS-Cache: Loaded
[    3.028459] CacheFiles: Loaded
[    3.029458] AppArmor: AppArmor Filesystem Enabled
[    3.030752] pnp: PnP ACPI init
[    3.031843] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.033542] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.034681] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.036113] pnp 00:03: [dma 2]
[    3.037092] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    3.038243] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.039867] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.041416] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.044363] pnp: PnP ACPI: found 7 devices
[    3.052013] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.053202] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.054509] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.055439] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    3.057079] NET: Registered protocol family 2
[    3.059955] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    3.061775] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    3.063753] TCP: Hash tables configured (established 4096 bind 4096)
[    3.065207] TCP: reno registered
[    3.065743] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    3.067165] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    3.069039] NET: Registered protocol family 1
[    3.070216] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.071508] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.072379] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.073826] pci 0000:00:02.0: Boot video device
[    3.074953] PCI: CLS 0 bytes, default 64
[    3.075999] Unpacking initramfs...
[    4.065487] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    4.074374] Machine check injector initialized
[    4.075318] microcode: CPU0 sig=3D0x306c1, pf=3D0x1, revision=3D0x1
[    4.076183] microcode: CPU1 sig=3D0x306c1, pf=3D0x1, revision=3D0x1
[    4.077528] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    4.086845] AVX version of gcm_enc/dec engaged.
[    4.087557] AES CTR mode by8 optimization enabled
[    4.093022] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    4.094634] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    4.106539] AVX2 or AES-NI instructions are not detected.
[    4.107890] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    4.112454] rcu-torture: Creating rcu_torture_writer task
[    4.113485] rcu-torture: Creating rcu_torture_fakewriter task
[    4.113499] rcu-torture: rcu_torture_writer task started
[    4.115341] rcu-torture: Creating rcu_torture_fakewriter task
[    4.115366] rcu-torture: rcu_torture_fakewriter task started
[    4.118316] rcu-torture: Creating rcu_torture_fakewriter task
[    4.118360] rcu-torture: rcu_torture_fakewriter task started
[    4.120303] rcu-torture: Creating rcu_torture_fakewriter task
[    4.120323] rcu-torture: rcu_torture_fakewriter task started
[    4.122164] rcu-torture: Creating rcu_torture_reader task
[    4.122184] rcu-torture: rcu_torture_fakewriter task started
[    4.124642] rcu-torture: rcu_torture_reader task started
[    4.124658] rcu-torture: Creating rcu_torture_stats task
[    4.124739] rcu-torture: Creating torture_shuffle task
[    4.124787] rcu-torture: rcu_torture_stats task started
[    4.128166] rcu-torture: Creating torture_stutter task
[    4.129176] rcu-torture: torture_shuffle task started
[    4.130105] rcu-torture: Creating rcu_torture_cbflood task
[    4.130118] rcu-torture: torture_stutter task started
[    4.132331] rcu-torture: Creating torture_slam_kthread task
[    4.132917] rcu-torture: rcu_torture_cbflood task started
[    4.134541] rcu-torture: torture_slam_kthread started
[    4.138230] futex hash table entries: 512 (order: 4, 65536 bytes)
[    4.139348] audit: initializing netlink subsys (disabled)
[    4.140585] audit: type=3D2000 audit(1409196751.063:1): initialized
[    5.070348] tsc: Refined TSC clocksource calibration: 2693.501 MHz
[    5.424817] zpool: loaded
[    5.425325] zbud: loaded
[    5.428205] VFS: Disk quotas dquot_6.5.2
[    5.429226] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.433918] DLM installed
[    5.448422] FS-Cache: Netfs 'cifs' registered for caching
[    5.449887] Key type cifs.spnego registered
[    5.450844] Key type cifs.idmap registered
[    5.453120] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    5.454223] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    5.458723] fuse init (API version 7.23)
[    5.460733] NILFS version 2 loaded
[    5.461205] befs: version: 0.9.3
[    5.462975] ocfs2: Registered cluster interface user
[    5.466195] OCFS2 User DLM kernel interface loaded
[    5.471035] gfs2: GFS2 installed
[    5.471756] ceph: loaded (mds proto 32)
[    5.472360] msgmni has been set to 449
[    5.504884] NET: Registered protocol family 38
[    5.506171] Key type asymmetric registered
[    5.508270] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    5.512621] io scheduler noop registered (default)
[    5.516551] io scheduler deadline registered
[    5.518405] io scheduler cfq registered
[    5.519451] test_string_helpers: Running tests...
[    5.520569] test_firmware: interface ready
[    5.522802] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    5.523701] crc32: self tests passed, processed 225944 bytes in 679122 n=
sec
[    5.525309] crc32c: CRC_LE_BITS =3D 8
[    5.525975] crc32c: self tests passed, processed 225944 bytes in 320275 =
nsec
[    5.580561] crc32_combine: 8373 self tests passed
[    5.644086] crc32c_combine: 8373 self tests passed
[    5.664831] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    5.666021] ACPI: Power Button [PWRF]
[    5.860719] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.889167] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    5.900675] ppdev: user-space parallel port driver
[    5.901421] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.903019] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.905221] [drm] Initialized drm 1.1.0 20060810
[    5.906658] dummy-irq: no IRQ given.  Use irq=3DN
[    5.908111] lkdtm: No crash points registered, enable through debugfs
[    5.909903] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.911683] c2port c2port0: C2 port uc added
[    5.912314] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.917322] Loading iSCSI transport class v2.0-870.
[    5.922172] iscsi: registered transport (tcp)
[    5.924041] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    5.925307] osst :I: Tape driver with OnStream support version 0.99.4
[    5.925307] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    5.928678] SCSI Media Changer driver v0.25=20
[    5.948467] scsi_debug: host protection
[    5.949054] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[    5.951497] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 5
[    5.955150] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    5.961464] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    5.962421] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    5.963471] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    5.965257] vcan: Virtual CAN interface driver
[    5.965848] YAM driver version 0.8 by F1OAT/F6FBB
[    5.966748] sd 0:0:0:0: [sda] Write Protect is off
[    5.967669] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    5.970947] AX.25: bpqether driver version 004
[    5.971711] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    5.971711] baycom_ser_fdx: version 0.10
[    5.973419] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    5.978886] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    5.979651] hdlcdrv: version 0.8
[    5.980153] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    5.980153] baycom_ser_hdx: version 0.10
[    5.984590] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    5.984590] baycom_par: version 0.9
[    5.993215] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.999459] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.000379]  sda: unknown partition table
[    6.002121] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.002975] parkbd: no such parport
[    6.008935] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.017696] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.022777] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    6.030274] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    6.039375] i2c /dev entries driver
[    6.041351] i2c-parport: adapter type unspecified
[    6.041968] i2c-parport-light: adapter type unspecified
[    6.050772] pps pps0: new PPS source ktimer
[    6.051466] pps pps0: ktimer PPS source registered
[    6.052077] pps_parport: parallel port PPS client
[    6.052826] Driver for 1-wire Dallas network protocol.
[    6.054542] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    6.055898] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    6.064137] applesmc: supported laptop not found!
[    6.064805] applesmc: driver init failed (ret=3D-19)!
[    6.073325] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    6.076139] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    6.077286] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    6.079433] ib700wdt: START method I/O 443 is not available
[    6.081008] ib700wdt: probe of ib700wdt failed with error -5
[    6.082453] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    6.083608] wafer5823wdt: I/O address 0x0443 already in use
[    6.084530] it87_wdt: no device
[    6.084973] sc1200wdt: build 20020303
[    6.085560] sc1200wdt: io parameter must be specified
[    6.086344] sbc60xxwdt: I/O address 0x0443 already in use
[    6.088010] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    6.090277] smsc37b787_wdt: Unable to register miscdev on minor 130
[    6.091682] w83877f_wdt: I/O address 0x0443 already in use
[    6.092471] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    6.093321] machzwd: no ZF-Logic found
[    6.095010] Bluetooth: Virtual HCI driver ver 1.5
[    6.096446] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    6.098167] sdhci: Secure Digital Host Controller Interface driver
[    6.099028] sdhci: Copyright(c) Pierre Ossman
[    6.099642] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    6.100511] wbsd: Copyright(c) Pierre Ossman
[    6.102201] sdhci-pltfm: SDHCI platform and OF driver helper
[    6.108275] ledtrig-cpu: registered to indicate activity on CPUs
[    6.114243] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.116644] hidraw: raw HID events driver (C) Jiri Kosina
[    6.124828] panel: driver version 0.9.5 not yet registered
[    6.135277] logger: created 256K log 'log_main'
[    6.143495] logger: created 256K log 'log_events'
[    6.145066] logger: created 256K log 'log_radio'
[    6.146213] logger: created 256K log 'log_system'
[    6.161186]  fake-fmc-carrier: mezzanine 0
[    6.161889]       Manufacturer: fake-vendor
[    6.162483]       Product name: fake-design-for-testing
[    6.164072] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.165226] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    6.168207] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.169693] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    6.171340] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.173479] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    6.185119] oprofile: using timer interrupt.
[    6.185810] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    6.188164] NET: Registered protocol family 26
[    6.189183] Netfilter messages via NETLINK v0.30.
[    6.191346] nf_conntrack version 0.5.0 (1796 buckets, 7184 max)
[    6.192764] ctnetlink v0.93: registering with nfnetlink.
[    6.193851] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    6.195072] ip_set: protocol 6
[    6.195660] IPVS: Registered protocols (TCP, UDP, ESP)
[    6.197050] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[    6.198101] IPVS: Each connection entry needs 408 bytes at least
[    6.200209] IPVS: Creating netns size=3D2568 id=3D0
[    6.204335] IPVS: ipvs loaded.
[    6.205043] IPVS: [rr] scheduler registered.
[    6.206408] IPVS: [lc] scheduler registered.
[    6.207054] IPVS: [wlc] scheduler registered.
[    6.207707] IPVS: [lblc] scheduler registered.
[    6.208462] IPVS: [lblcr] scheduler registered.
[    6.209282] IPVS: [dh] scheduler registered.
[    6.210607] IPVS: [sed] scheduler registered.
[    6.211494] IPVS: [nq] scheduler registered.
[    6.213667] TCP: bic registered
[    6.214137] TCP: westwood registered
[    6.214815] TCP: highspeed registered
[    6.215352] TCP: hybla registered
[    6.215835] TCP: htcp registered
[    6.216298] TCP: vegas registered
[    6.218685] TCP: veno registered
[    6.219250] TCP: scalable registered
[    6.219841] TCP: lp registered
[    6.220458] TCP: yeah registered
[    6.221205] Initializing XFRM netlink socket
[    6.222394] NET: Registered protocol family 10
[    6.228840] mip6: Mobile IPv6
[    6.229405] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    6.231702] sit: IPv6 over IPv4 tunneling driver
[    6.237920] ip6_gre: GRE over IPv6 tunneling driver
[    6.242364] NET: Registered protocol family 15
[    6.243183] NET: Registered protocol family 5
[    6.244524] NET: Registered protocol family 9
[    6.245492] X25: Linux Version 0.2
[    6.267435] NET: Registered protocol family 11
[    6.268397] NET: Registered protocol family 3
[    6.269786] can: controller area network core (rev 20120528 abi 9)
[    6.271028] NET: Registered protocol family 29
[    6.271819] can: raw protocol (rev 20120528)
[    6.272472] can: broadcast manager protocol (rev 20120528 t)
[    6.273512] can: netlink gateway (rev 20130117) max_hops=3D1
[    6.277136] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    6.278237] Bluetooth: HIDP socket layer initialized
[    6.279524] NET: Registered protocol family 33
[    6.280265] Key type rxrpc registered
[    6.280805] Key type rxrpc_s registered
[    6.283286] RxRPC: Registered security type 2 'rxkad'
[    6.284401] lec:lane_module_init: lec.c: initialized
[    6.285683] mpoa:atm_mpoa_init: mpc.c: initialized
[    6.286658] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    6.289891] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[    6.291893] NET: Registered protocol family 12
[    6.292901] NET: Registered protocol family 35
[    6.295068] 8021q: 802.1Q VLAN Support v1.8
[    6.296218] sctp: Hash tables configured (established 819 bind 819)
[    6.302798] Key type dns_resolver registered
[    6.303862] Key type ceph registered
[    6.304791] libceph: loaded (mon/osd proto 15/24)
[    6.305602] openvswitch: Open vSwitch switching datapath
[    6.308731] mpls_gso: MPLS GSO support
[    6.312723]=20
[    6.312723] printing PIC contents
[    6.313464] ... PIC  IMR: ffff
[    6.313914] ... PIC  IRR: 1013
[    6.314373] ... PIC  ISR: 0000
[    6.314893] ... PIC ELCR: 0c00
[    6.315342] printing local APIC contents on CPU#0/0:
[    6.316121] ... APIC ID:      00000000 (0)
[    6.316768] ... APIC VERSION: 01050014
[    6.316773] ... APIC TASKPRI: 00000000 (00)
[    6.317645] ... APIC PROCPRI: 00000000
[    6.317645] ... APIC LDR: 01000000
[    6.317645] ... APIC DFR: ffffffff
[    6.317645] ... APIC SPIV: 000001ff
[    6.317645] ... APIC ISR field:
[    6.317645] 000000000000000000000000000000000000000000000000000000000000=
0000
[    6.317645] ... APIC TMR field:
[    6.317645] 000000000200000000000000000000000000000000000000000000000000=
0000
[    6.317645] ... APIC IRR field:
[    6.317645] 000000000000000000000000000000000000000000000000000000002000=
8000
[    6.317645] ... APIC ESR: 00000000
[    6.317645] ... APIC ICR: 000008fd
[    6.317645] ... APIC ICR2: 02000000
[    6.317645] ... APIC LVTT: 000400ef
[    6.317645] ... APIC LVTPC: 00010000
[    6.317645] ... APIC LVT0: 00010700
[    6.317645] ... APIC LVT1: 00000400
[    6.317645] ... APIC LVTERR: 000000fe
[    6.317645] ... APIC TMICT: 00000000
[    6.317645] ... APIC TMCCT: 00000000
[    6.317645] ... APIC TDCR: 00000000
[    6.317645]=20
[    6.332649] number of MP IRQ sources: 15.
[    6.333214] number of IO-APIC #0 registers: 24.
[    6.334217] testing the IO APIC.......................
[    6.335136] IO APIC #0......
[    6.335549] .... register #00: 00000000
[    6.336093] .......    : physical APIC id: 00
[    6.336952] .......    : Delivery Type: 0
[    6.337530] .......    : LTS          : 0
[    6.338079] .... register #01: 00170011
[    6.338773] .......     : max redirection entries: 17
[    6.339481] .......     : PRQ implemented: 0
[    6.340265] .......     : IO APIC version: 11
[    6.340900] .... register #02: 00000000
[    6.341451] .......     : arbitration: 00
[    6.342190] .... IRQ redirection table:
[    6.343004] 1    0    0   0   0    0    0    00
[    6.343691] 0    0    0   0   0    1    1    31
[    6.344357] 0    0    0   0   0    1    1    30
[    6.345098] 0    0    0   0   0    1    1    33
[    6.345914] 1    0    0   0   0    1    1    34
[    6.346625] 1    1    0   0   0    1    1    35
[    6.347311] 0    0    0   0   0    1    1    36
[    6.347959] 0    0    0   0   0    1    1    37
[    6.348881] 0    0    0   0   0    1    1    38
[    6.349659] 0    1    0   0   0    1    1    39
[    6.350349] 1    1    0   0   0    1    1    3A
[    6.351020] 1    1    0   0   0    1    1    3B
[    6.351821] 0    0    0   0   0    1    1    3C
[    6.352482] 0    0    0   0   0    1    1    3D
[    6.353130] 0    0    0   0   0    1    1    3E
[    6.353808] 0    0    0   0   0    1    1    3F
[    6.354476] 1    0    0   0   0    0    0    00
[    6.355377] 1    0    0   0   0    0    0    00
[    6.356026] 1    0    0   0   0    0    0    00
[    6.356763] 1    0    0   0   0    0    0    00
[    6.357429] 1    0    0   0   0    0    0    00
[    6.358252] 1    0    0   0   0    0    0    00
[    6.359053] 1    0    0   0   0    0    0    00
[    6.359782] 1    0    0   0   0    0    0    00
[    6.360443] IRQ to pin mappings:
[    6.360996] IRQ0 -> 0:2
[    6.361397] IRQ1 -> 0:1
[    6.361927] IRQ3 -> 0:3
[    6.362373] IRQ4 -> 0:4
[    6.362772] IRQ5 -> 0:5
[    6.363172] IRQ6 -> 0:6
[    6.363778] IRQ7 -> 0:7
[    6.364172] IRQ8 -> 0:8
[    6.364679] IRQ9 -> 0:9
[    6.365179] IRQ10 -> 0:10
[    6.365607] IRQ11 -> 0:11
[    6.366029] IRQ12 -> 0:12
[    6.366510] IRQ13 -> 0:13
[    6.367128] IRQ14 -> 0:14
[    6.367565] IRQ15 -> 0:15
[    6.367994] .................................... done.
[    6.376388] Running tests on trace events:
[    6.377018] Testing event thermal_apic_exit: OK
[    6.394752] Testing event thermal_apic_entry: OK
[    6.532400] Testing event threshold_apic_exit:=20
[    6.546647] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    6.550960] OK
[    6.551898] Testing event threshold_apic_entry: OK
[    6.571356] Testing event call_function_single_exit: OK
[    6.636091] Testing event call_function_single_entry: OK
[    6.667422] Testing event call_function_exit: OK
[    6.684746] Testing event call_function_entry: OK
[    6.697408] Testing event irq_work_exit: OK
[    6.711739] Testing event irq_work_entry: OK
[    6.772472] Testing event x86_platform_ipi_exit: OK
[    6.790808] Testing event x86_platform_ipi_entry: OK
[    6.804127] Testing event error_apic_exit: OK
[    6.817334] Testing event error_apic_entry: OK
[    6.830744] Testing event spurious_apic_exit: OK
[    6.844049] Testing event spurious_apic_entry: OK
[    6.871818] Testing event reschedule_exit: OK
[    6.895700] Testing event reschedule_entry: OK
[    6.921677] Testing event local_timer_exit: OK
[    6.939890] Testing event local_timer_entry: OK
[    6.964419] Testing event nmi_handler: OK
[    6.982987] Testing event emulate_vsyscall: OK
[    7.006124] Testing event sys_exit: OK
[    7.034453] Testing event sys_enter: OK
[    7.099728] Testing event mce_record: OK
[    7.120876] Testing event tlb_flush: OK
[    7.157937] Testing event page_fault_kernel: OK
[    7.172518] Testing event page_fault_user: OK
[    7.188005] Testing event task_rename: OK
[    7.201685] Testing event task_newtask: OK
[    7.213920] Testing event softirq_raise: OK
[    7.230569] Testing event softirq_exit: OK
[    7.252591] Testing event softirq_entry: OK
[    7.324056] Testing event irq_handler_exit: OK
[    7.340615] Testing event irq_handler_entry: OK
[    7.355678] Testing event signal_deliver: OK
[    7.384820] Testing event signal_generate: OK
[    7.416092] Testing event workqueue_execute_end: OK
[    7.474053] Testing event workqueue_execute_start: OK
[    7.487085] Testing event workqueue_activate_work: OK
[    7.500452] Testing event workqueue_queue_work: OK
[    7.518424] Testing event sched_wake_idle_without_ipi: OK
[    7.531853] Testing event sched_swap_numa: OK
[    7.543728] Testing event sched_stick_numa: OK
[    7.576498] Testing event sched_move_numa: OK
[    7.593949] Testing event sched_process_hang: OK
[    7.607593] Testing event sched_pi_setprio: OK
[    7.620731] Testing event sched_stat_runtime: OK
[    7.634486] Testing event sched_stat_blocked: OK
[    7.665944] Testing event sched_stat_iowait: OK
[    7.684468] Testing event sched_stat_sleep: OK
[    7.701391] Testing event sched_stat_wait: OK
[    7.713826] Testing event sched_process_exec: OK
[    7.727402] Testing event sched_process_fork: OK
[    7.753824] Testing event sched_process_wait: OK
[    7.768591] Testing event sched_wait_task: OK
[    7.786505] Testing event sched_process_exit: OK
[    7.804081] Testing event sched_process_free: OK
[    7.830559] Testing event sched_migrate_task: OK
[    7.884551] Testing event sched_switch: OK
[    7.897697] Testing event sched_wakeup_new: OK
[    7.913874] Testing event sched_wakeup: OK
[    7.927230] Testing event sched_kthread_stop_ret: OK
[    7.941013] Testing event sched_kthread_stop: OK
[    7.997629] Testing event lock_acquired: OK
[    8.058008] Testing event lock_contended: OK
[    8.070653] Testing event lock_release: OK
[    8.084360] Testing event lock_acquire: OK
[    8.144055] Testing event console: OK
[    8.203089] Testing event rcu_utilization: OK
[    8.217737] Testing event itimer_expire: OK
[    8.230715] Testing event itimer_state: OK
[    8.244194] Testing event hrtimer_cancel: OK
[    8.257604] Testing event hrtimer_expire_exit: OK
[    8.272601] Testing event hrtimer_expire_entry: OK
[    8.287781] Testing event hrtimer_start: OK
[    8.300943] Testing event hrtimer_init: OK
[    8.314137] Testing event timer_cancel: OK
[    8.376761] Testing event timer_expire_exit: OK
[    8.392094] Testing event timer_expire_entry: OK
[    8.407291] Testing event timer_start: OK
[    8.421025] Testing event timer_init: OK
[    8.434101] Testing event ftrace_test_filter: OK
[    8.447401] Testing event dev_pm_qos_remove_request: OK
[    8.460620] Testing event dev_pm_qos_update_request: OK
[    8.474102] Testing event dev_pm_qos_add_request: OK
[    8.487288] Testing event pm_qos_update_flags: OK
[    8.500801] Testing event pm_qos_update_target: OK
[    8.513976] Testing event pm_qos_update_request_timeout: OK
[    8.527395] Testing event pm_qos_remove_request: OK
[    8.540782] Testing event pm_qos_update_request: OK
[    8.553969] Testing event pm_qos_add_request: OK
[    8.617284] Testing event power_domain_target: OK
[    8.632806] Testing event clock_set_rate: OK
[    8.648293] Testing event clock_disable: OK
[    8.672824] Testing event clock_enable: OK
[    8.687210] Testing event wakeup_source_deactivate: OK
[    8.747662] Testing event wakeup_source_activate: OK
[    8.760608] Testing event suspend_resume: OK
[    8.781362] Testing event device_pm_callback_end: OK
[    8.797656] Testing event device_pm_callback_start: OK
[    8.810975] Testing event cpu_frequency: OK
[    8.827296] Testing event pstate_sample: OK
[    8.890596] Testing event cpu_idle: OK
[    8.904797] Testing event mm_filemap_add_to_page_cache: OK
[    8.918911] Testing event mm_filemap_delete_from_page_cache: OK
[    8.933902] Testing event oom_score_adj_update: OK
[    8.947625] Testing event mm_lru_activate: OK
[    8.960752] Testing event mm_lru_insertion: OK
[    8.973899] Testing event mm_vmscan_lru_shrink_inactive: OK
[    8.987570] Testing event mm_vmscan_writepage: OK
[    9.000691] Testing event mm_vmscan_memcg_isolate: OK
[    9.014100] Testing event mm_vmscan_lru_isolate: OK
[    9.070908] Testing event mm_shrink_slab_end: OK
[    9.084837] Testing event mm_shrink_slab_start: OK
[    9.097740] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    9.110837] Testing event mm_vmscan_memcg_reclaim_end: OK
[    9.123983] Testing event mm_vmscan_direct_reclaim_end:=20
[   32.110003] NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [tortu=
re_slam_kt:115]
[   32.110003] CPU: 1 PID: 115 Comm: torture_slam_kt Not tainted 3.17.0-rc2=
-00063-g86d8f10 #7
[   32.110003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   32.110003] task: ffff88000b395650 ti: ffff88000b210000 task.ti: ffff880=
00b210000
[   32.110003] RIP: 0010:[<ffffffff8111b24f>]  [<ffffffff8111b24f>] __might=
_sleep+0x18f/0x1a0
[   32.110003] RSP: 0000:ffff88000b213e10  EFLAGS: 00000202
[   32.110003] RAX: ffff88000b395650 RBX: 0000000000000000 RCX: 00000000000=
002a0
[   32.110003] RDX: 0000000000000073 RSI: 0000000000000276 RDI: ffffffff82d=
a8b58
[   32.110003] RBP: ffff88000b213e10 R08: 0000000000000ae8 R09: 00000000000=
00000
[   32.110003] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000b2=
13df0
[   32.110003] R13: ffff88000b213e10 R14: ffffffff8240723f R15: ffff88000b2=
13d80
[   32.110003] FS:  0000000000000000(0000) GS:ffff880012400000(0000) knlGS:=
0000000000000000
[   32.110003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.110003] CR2: 0000000000000000 CR3: 0000000003012000 CR4: 00000000000=
406e0
[   32.110003] Stack:
[   32.110003]  ffff88000b213e28 ffffffff8120075b ffff880009048c90 ffff8800=
0b213e48
[   32.110003]  ffffffff81201063 0000006300000000 ffff880010e48300 ffff8800=
0b213f48
[   32.110003]  ffffffff81105150 0000000000000000 ffff88000b395650 00000000=
00000000
[   32.110003] Call Trace:
[   32.110003]  [<ffffffff8120075b>] stutter_wait+0x9b/0x130
[   32.110003]  [<ffffffff81201063>] torture_slam_kthread+0xe3/0x190
[   32.110003]  [<ffffffff81105150>] kthread+0x130/0x160
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003]  [<ffffffff824087bc>] ret_from_fork+0x7c/0xb0
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003] Code: 44 00 00 48 83 05 c1 e5 a3 02 01 f6 c4 02 0f 84 ae fe =
ff ff 65 48 8b 04 25 00 b9 00 00 8b 90 b0 03 00 00 48 83 05 a9 e5 a3 02 01 =
<85> d2 0f 84 8f fe ff ff 5d c3 0f 1f 80 00 00 00 00 0f 1f 44 00=20
[   32.110003] Kernel panic - not syncing: softlockup: hung tasks
[   32.110003] CPU: 1 PID: 115 Comm: torture_slam_kt Tainted: G            =
 L 3.17.0-rc2-00063-g86d8f10 #7
[   32.110003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   32.110003]  0000000000000007 ffff880012403df8 ffffffff823f8f74 ffffffff=
82d98e85
[   32.110003]  ffff880012403e70 ffffffff823f0db6 0000000000000008 ffff8800=
12403e80
[   32.110003]  ffff880012403e20 0000000000000001 0000000000000000 ffffffff=
811504f3
[   32.110003] Call Trace:
[   32.110003]  <IRQ>  [<ffffffff823f8f74>] dump_stack+0x85/0xba
[   32.110003]  [<ffffffff823f0db6>] panic+0x110/0x300
[   32.110003]  [<ffffffff811504f3>] ? console_unlock+0x373/0x680
[   32.110003]  [<ffffffff811ad3b3>] watchdog_timer_fn+0x283/0x2e0
[   32.110003]  [<ffffffff81171c99>] hrtimer_run_queues+0x159/0x470
[   32.110003]  [<ffffffff811ad130>] ? watchdog+0x40/0x40
[   32.110003]  [<ffffffff811708e2>] update_process_times+0x42/0xc0
[   32.110003]  [<ffffffff81183d08>] tick_periodic+0x38/0x130
[   32.110003]  [<ffffffff8118400e>] tick_handle_periodic+0x2e/0xb0
[   32.110003]  [<ffffffff81200f80>] ? torture_stutter+0x1d0/0x1d0
[   32.110003]  [<ffffffff81050dbf>] local_apic_timer_interrupt+0x3f/0x80
[   32.110003]  [<ffffffff8240b43f>] smp_apic_timer_interrupt+0x5f/0x80
[   32.110003]  [<ffffffff8240981d>] apic_timer_interrupt+0x6d/0x80
[   32.110003]  <EOI>  [<ffffffff8111b24f>] ? __might_sleep+0x18f/0x1a0
[   32.110003]  [<ffffffff8120075b>] stutter_wait+0x9b/0x130
[   32.110003]  [<ffffffff81201063>] torture_slam_kthread+0xe3/0x190
[   32.110003]  [<ffffffff81105150>] kthread+0x130/0x160
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003]  [<ffffffff824087bc>] ret_from_fork+0x7c/0xb0
[   32.110003]  [<ffffffff81105020>] ? __kthread_unpark+0xa0/0xa0
[   32.110003] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 40
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-s1-08281038/86d8f10e35c1e63d5a839792efd7c3cb6a564fe4/vmlinuz=
-3.17.0-rc2-00063-g86d8f10 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s1-08281038/linux-devel:devel-hourly-2014082810:86d8f10e35c1e63=
d5a839792efd7c3cb6a564fe4:bisect-linux-8/.vmlinuz-86d8f10e35c1e63d5a839792e=
fd7c3cb6a564fe4-20140828193329-3-kbuild branch=3Dlinux-devel/devel-hourly-2=
014082810 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-08281038/86d8f10e35c1e6=
3d5a839792efd7c3cb6a564fe4/vmlinuz-3.17.0-rc2-00063-g86d8f10 drbd.minor_cou=
nt=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2=
 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-q=
uantal-kbuild-20 -serial file:/dev/shm/kboot/serial-quantal-kbuild-20 -daem=
onize -display none -monitor null=20

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-10:20140828113842:x86_64-randconfig-s1-08281038:3.17.0-rc2-00062-gb52938b:8"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Linux version 3.17.0-rc2-00062-gb52938b (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #8 SMP Thu Aug 28 19:35:47 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-s1-08281038/linux-devel:devel-hourly-2014082810:b52938be99a099b452979e=
d805b480337ee2df0f:bisect-linux-8/.vmlinuz-b52938be99a099b452979ed805b48033=
7ee2df0f-20140828193620-58-kbuild branch=3Dlinux-devel/devel-hourly-2014082=
810 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-08281038/b52938be99a099b45297=
9ed805b480337ee2df0f/vmlinuz-3.17.0-rc2-00062-gb52938b drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x04dc6000, 0x04dc6fff] PGTABLE
[    0.000000] BRK [0x04dc7000, 0x04dc7fff] PGTABLE
[    0.000000] BRK [0x04dc8000, 0x04dc8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 4k
[    0.000000] BRK [0x04dc9000, 0x04dc9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x04dca000, 0x04dcafff] PGTABLE
[    0.000000] BRK [0x04dcb000, 0x04dcbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13ffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
[    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880012200000 s1918912 r0=
 d22592 u2097152
[    0.000000] pcpu-alloc: s1918912 r0 d22592 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1220ce00
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s1-08281038/linux-devel:devel-hourly-2014082810:b52938be99a099b=
452979ed805b480337ee2df0f:bisect-linux-8/.vmlinuz-b52938be99a099b452979ed80=
5b480337ee2df0f-20140828193620-58-kbuild branch=3Dlinux-devel/devel-hourly-=
2014082810 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-08281038/b52938be99a09=
9b452979ed805b480337ee2df0f/vmlinuz-3.17.0-rc2-00062-gb52938b drbd.minor_co=
unt=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Memory: 230008K/327280K available (20532K kernel code, 7361K=
 rwdata, 9716K rodata, 3632K init, 19440K bss, 97272K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.452 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.35 Bogo=
MIPS (lpj=3D8978173)
[    0.006676] pid_max: default: 32768 minimum: 301
[    0.007524] ACPI: Core revision 20140724
[    0.012514] ACPI: All ACPI Tables successfully acquired
[    0.013690] Security Framework initialized
[    0.014870] AppArmor: AppArmor initialized
[    0.016678] Yama: becoming mindful.
[    0.017830] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.020862] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.022510] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.023355] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.026735] mce: CPU supports 10 MCE banks
[    0.027474] numa_add_cpu cpu 0 node 0: mask now 0
[    0.028326] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.028326] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030594] debug: unmapping init [mem 0xffffffff83abe000-0xffffffff83ac=
7fff]
[    0.041198] ftrace: allocating 48604 entries in 190 pages
[    0.060444] Getting VERSION: 1050014
[    0.061089] Getting VERSION: 1050014
[    0.061596] Getting ID: 0
[    0.063350] Getting ID: ff000000
[    0.063811] Getting LVT0: 8700
[    0.064264] Getting LVT1: 8400
[    0.064771] enabled ExtINT on CPU#0
[    0.066710] ENABLING IO-APIC IRQs
[    0.067238] init IO_APIC IRQs
[    0.067734]  apic 0 pin 0 not connected
[    0.068436] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.069674] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.073368] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.074505] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.075733] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.076701] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.077841] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.080035] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.083369] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.086031] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.086698] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.090032] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.091143] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.093367] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.096724] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.100028]  apic 0 pin 16 not connected
[    0.100578]  apic 0 pin 17 not connected
[    0.101367]  apic 0 pin 18 not connected
[    0.101912]  apic 0 pin 19 not connected
[    0.103340]  apic 0 pin 20 not connected
[    0.103892]  apic 0 pin 21 not connected
[    0.106672]  apic 0 pin 22 not connected
[    0.107239]  apic 0 pin 23 not connected
[    0.107962] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.110007] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, mode=
l: 3c, stepping: 01)
[    0.111478] TSC deadline timer enabled
[    0.113378] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.116425] Testing tracer nop: PASSED
[    0.119805] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.120900] x86: Booting SMP configuration:
[    0.121801] .... node  #0, CPUs:      #1
[    0.006666] kvm-clock: cpu 1, msr 0:13ff8041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.006666] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.136831] x86: Booted up 1 node, 2 CPUs
[    0.137412] smpboot: Total of 2 processors activated (10778.71 BogoMIPS)
[    0.136736] KVM setup async PF for cpu 1
[    0.136736] kvm-stealtime: cpu 1, msr 1240ce00
[    0.167193] devtmpfs: initialized
[    0.168414] gcov: version magic: 0x3430382a
[    0.190980] Testing tracer function: PASSED
[    0.368343] Testing dynamic ftrace: PASSED
[    0.690204] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 1 2 0 0) (2 1 =
3 0 279) (2 2 4 0 381) PASSED
[    0.938171] Testing dynamic ftrace ops #2: (1 0 1 223 0) (1 1 2 338 0) (=
2 1 3 2 402) (2 2 4 112 512) PASSED
[    1.211119] Testing ftrace recursion: PASSED
[    1.253716] Testing ftrace recursion safe: PASSED
[    1.295205] Testing ftrace regs: PASSED
[    1.413369] Testing tracer wakeup: ret =3D 0
[    1.683370] PASSED
[    1.723371] Testing tracer wakeup_rt: ret =3D 0
[    1.986706] PASSED
[    2.026707] Testing tracer wakeup_dl: ret =3D 0
[    2.290045] PASSED
[    2.330062] Testing tracer function_graph: PASSED
[    2.934559] xor: automatically using best checksumming function:
[    2.967490]    avx       :   134.400 MB/sec
[    2.968158] prandom: seed boundary self test passed
[    2.969574] prandom: 100 self tests passed
[    2.970552] regulator-dummy: no parameters
[    2.971841] NET: Registered protocol family 16
[    2.973545] cpuidle: using governor ladder
[    2.974162] cpuidle: using governor menu
[    2.975286] ACPI: bus type PCI registered
[    2.976045] PCI: Using configuration type 1 for base access
[    3.064148] raid6: sse2x1    1510 MB/s
[    3.120646] raid6: sse2x2    1856 MB/s
[    3.177486] raid6: sse2x4    1838 MB/s
[    3.178107] raid6: using algorithm sse2x2 (1856 MB/s)
[    3.178887] raid6: using ssse3x2 recovery algorithm
[    3.183068] ACPI: Added _OSI(Module Device)
[    3.183068] ACPI: Added _OSI(Processor Device)
[    3.183068] ACPI: Added _OSI(3.0 _SCP Extensions)
[    3.183068] ACPI: Added _OSI(Processor Aggregator Device)
[    3.193653] ACPI: Interpreter enabled
[    3.194230] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    3.195613] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    3.197059] ACPI: (supports S0 S3 S4 S5)
[    3.197664] ACPI: Using IOAPIC for interrupt routing
[    3.198485] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    3.212813] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.213353] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    3.214207] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    3.222027] PCI host bridge to bus 0000:00
[    3.222673] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.223347] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    3.224225] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    3.225133] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    3.226105] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    3.233453] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    3.235272] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    3.237205] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    3.241172] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    3.243267] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    3.243346] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    3.244287] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    3.245320] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    3.246854] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    3.248268] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    3.249371] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    3.250692] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    3.257507] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    3.260100] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    3.268372] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    3.270573] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    3.272499] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    3.273876] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    3.280018] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    3.281707] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    3.283276] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    3.289474] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    3.290502] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    3.291591] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    3.292692] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    3.293646] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    3.295391] ACPI: Enabled 16 GPEs in block 00 to 0F
[    3.297906] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    3.299152] vgaarb: loaded
[    3.299546] vgaarb: bridge control possible 0000:00:02.0
[    3.301843] SCSI subsystem initialized
[    3.302767] media: Linux media interface: v0.10
[    3.303392] Linux video capture interface: v2.00
[    3.304235] pps_core: LinuxPPS API ver. 1 registered
[    3.304988] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    3.306376] PTP clock support registered
[    3.307482] Advanced Linux Sound Architecture Driver Initialized.
[    3.308483] PCI: Using ACPI for IRQ routing
[    3.309115] PCI: pci_cache_line_size set to 64 bytes
[    3.310082] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    3.311021] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    3.312877] irda_init()
[    3.313365] NET: Registered protocol family 23
[    3.314033] Bluetooth: Core ver 2.19
[    3.314583] NET: Registered protocol family 31
[    3.315201] Bluetooth: HCI device and connection manager initialized
[    3.316030] Bluetooth: HCI socket layer initialized
[    3.316692] Bluetooth: L2CAP socket layer initialized
[    3.317496] Bluetooth: SCO socket layer initialized
[    3.318217] NET: Registered protocol family 8
[    3.318776] NET: Registered protocol family 20
[    3.319434] NetLabel: Initializing
[    3.319873] NetLabel:  domain hash size =3D 128
[    3.320008] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    3.320850] NetLabel:  unlabeled traffic allowed by default
[    3.323344] Switched to clocksource kvm-clock
[    3.480935] FS-Cache: Loaded
[    3.481680] CacheFiles: Loaded
[    3.490936] AppArmor: AppArmor Filesystem Enabled
[    3.491830] pnp: PnP ACPI init
[    3.492857] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.494245] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.495454] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.497015] pnp 00:03: [dma 2]
[    3.497741] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    3.499573] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.500858] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.502062] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.510396] pnp: PnP ACPI: found 7 devices
[    3.518489] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    3.519594] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    3.520447] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    3.521548] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    3.522876] NET: Registered protocol family 2
[    3.525169] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    3.526464] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    3.527877] TCP: Hash tables configured (established 4096 bind 4096)
[    3.529049] TCP: reno registered
[    3.529588] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    3.530791] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    3.532610] NET: Registered protocol family 1
[    3.533627] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.534628] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.535613] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.536625] pci 0000:00:02.0: Boot video device
[    3.537459] PCI: CLS 0 bytes, default 64
[    3.538466] Unpacking initramfs...
[    4.699045] debug: unmapping init [mem 0xffff88001293d000-0xffff880013fe=
ffff]
[    4.708058] Machine check injector initialized
[    4.708990] microcode: CPU0 sig=3D0x306c1, pf=3D0x1, revision=3D0x1
[    4.709838] microcode: CPU1 sig=3D0x306c1, pf=3D0x1, revision=3D0x1
[    4.711022] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    4.732106] AVX version of gcm_enc/dec engaged.
[    4.732804] AES CTR mode by8 optimization enabled
[    4.737398] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    4.745539] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    4.754281] AVX2 or AES-NI instructions are not detected.
[    4.755453] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    4.759803] rcu-torture: Creating rcu_torture_writer task
[    4.760761] rcu-torture: rcu_torture_writer task started
[    4.761546] rcu-torture: Creating rcu_torture_fakewriter task
[    4.784562] rcu-torture: Creating rcu_torture_fakewriter task
[    4.785494] rcu-torture: Creating rcu_torture_fakewriter task
[    4.785651] rcu-torture: rcu_torture_fakewriter task started
[    4.787230] rcu-torture: rcu_torture_fakewriter task started
[    4.788083] rcu-torture: Creating rcu_torture_fakewriter task
[    4.788626] rcu-torture: rcu_torture_fakewriter task started
[    4.789839] rcu-torture: Creating rcu_torture_reader task
[    4.791100] rcu-torture: rcu_torture_fakewriter task started
[    4.792001] rcu-torture: Creating rcu_torture_stats task
[    4.799338] rcu-torture: rcu_torture_reader task started
[    4.804331] rcu-torture: Creating torture_shuffle task
[    4.805260] rcu-torture: rcu_torture_stats task started
[    4.806160] rcu-torture: Creating torture_stutter task
[    4.806167] rcu-torture: torture_shuffle task started
[    4.807898] rcu-torture: Creating rcu_torture_cbflood task
[    4.807900] rcu-torture: torture_stutter task started
[    4.811300] rcu-torture: rcu_torture_cbflood task started
[    4.811388] futex hash table entries: 512 (order: 4, 65536 bytes)
[    4.811493] audit: initializing netlink subsys (disabled)
[    4.811677] audit: type=3D2000 audit(1409197062.426:1): initialized
[    5.703738] tsc: Refined TSC clocksource calibration: 2693.501 MHz
[    6.294975] zpool: loaded
[    6.295425] zbud: loaded
[    6.296462] VFS: Disk quotas dquot_6.5.2
[    6.297149] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    6.299157] DLM installed
[    6.302386] FS-Cache: Netfs 'cifs' registered for caching
[    6.303483] Key type cifs.spnego registered
[    6.304190] Key type cifs.idmap registered
[    6.304815] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    6.305823] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    6.308485] fuse init (API version 7.23)
[    6.309641] NILFS version 2 loaded
[    6.310194] befs: version: 0.9.3
[    6.311291] ocfs2: Registered cluster interface user
[    6.312295] OCFS2 User DLM kernel interface loaded
[    6.314889] gfs2: GFS2 installed
[    6.315676] ceph: loaded (mds proto 32)
[    6.316301] msgmni has been set to 449
[    6.338935] NET: Registered protocol family 38
[    6.339649] Key type asymmetric registered
[    6.340370] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    6.346570] io scheduler noop registered (default)
[    6.347357] io scheduler deadline registered
[    6.348447] io scheduler cfq registered
[    6.349565] test_string_helpers: Running tests...
[    6.355035] test_firmware: interface ready
[    6.359155] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    6.359880] crc32: self tests passed, processed 225944 bytes in 982795 n=
sec
[    6.365820] crc32c: CRC_LE_BITS =3D 8
[    6.366340] crc32c: self tests passed, processed 225944 bytes in 4278473=
 nsec
[    6.452547] crc32_combine: 8373 self tests passed
[    6.573201] crc32c_combine: 8373 self tests passed
[    6.580595] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    6.582841] ACPI: Power Button [PWRF]
[    6.701420] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    6.759185] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    6.762935] ppdev: user-space parallel port driver
[    6.763668] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    6.764497] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    6.766276] [drm] Initialized drm 1.1.0 20060810
[    6.768247] dummy-irq: no IRQ given.  Use irq=3DN
[    6.771756] lkdtm: No crash points registered, enable through debugfs
[    6.772989] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    6.774293] c2port c2port0: C2 port uc added
[    6.775248] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    6.777973] Loading iSCSI transport class v2.0-870.
[    6.820902] iscsi: registered transport (tcp)
[    6.827591] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    6.839295] osst :I: Tape driver with OnStream support version 0.99.4
[    6.839295] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    6.843089] SCSI Media Changer driver v0.25=20
[    6.886388] scsi_debug: host protection
[    6.887009] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[    6.889250] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 5
[    6.893900] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    6.900455] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    6.901661] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    6.903243] vcan: Virtual CAN interface driver
[    6.904195] YAM driver version 0.8 by F1OAT/F6FBB
[    6.910640] AX.25: bpqether driver version 004
[    6.911438] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.911438] baycom_ser_fdx: version 0.10
[    6.913496] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    6.916821] sd 0:0:0:0: [sda] Write Protect is off
[    6.916982] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    6.916984] hdlcdrv: version 0.8
[    6.916986] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.916986] baycom_ser_hdx: version 0.10
[    6.918596] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.918596] baycom_par: version 0.9
[    6.923187] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.923498] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.928803] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.929609] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.933070] parkbd: no such parport
[    6.933391] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    6.940605] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.960201]  sda: unknown partition table
[    6.990471] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.009357] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    7.012763] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    7.030628] i2c /dev entries driver
[    7.036323] i2c-parport: adapter type unspecified
[    7.037145] i2c-parport-light: adapter type unspecified
[    7.044328] pps pps0: new PPS source ktimer
[    7.044972] pps pps0: ktimer PPS source registered
[    7.045724] pps_parport: parallel port PPS client
[    7.046640] Driver for 1-wire Dallas network protocol.
[    7.047603] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    7.049068] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    7.055548] applesmc: supported laptop not found!
[    7.056261] applesmc: driver init failed (ret=3D-19)!
[    7.067267] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    7.069402] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    7.070391] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    7.071646] ib700wdt: START method I/O 443 is not available
[    7.072476] ib700wdt: probe of ib700wdt failed with error -5
[    7.073743] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    7.074936] wafer5823wdt: I/O address 0x0443 already in use
[    7.075905] it87_wdt: no device
[    7.076379] sc1200wdt: build 20020303
[    7.077034] sc1200wdt: io parameter must be specified
[    7.077811] sbc60xxwdt: I/O address 0x0443 already in use
[    7.078658] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    7.080820] smsc37b787_wdt: Unable to register miscdev on minor 130
[    7.081879] w83877f_wdt: I/O address 0x0443 already in use
[    7.082690] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    7.083603] machzwd: no ZF-Logic found
[    7.084363] Bluetooth: Virtual HCI driver ver 1.5
[    7.086908] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    7.088288] sdhci: Secure Digital Host Controller Interface driver
[    7.089206] sdhci: Copyright(c) Pierre Ossman
[    7.089866] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    7.090767] wbsd: Copyright(c) Pierre Ossman
[    7.091570] sdhci-pltfm: SDHCI platform and OF driver helper
[    7.094837] ledtrig-cpu: registered to indicate activity on CPUs
[    7.097457] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    7.098953] hidraw: raw HID events driver (C) Jiri Kosina
[    7.101311] panel: driver version 0.9.5 not yet registered
[    7.105335] logger: created 256K log 'log_main'
[    7.106322] logger: created 256K log 'log_events'
[    7.107351] logger: created 256K log 'log_radio'
[    7.108644] logger: created 256K log 'log_system'
[    7.115963]  fake-fmc-carrier: mezzanine 0
[    7.116627]       Manufacturer: fake-vendor
[    7.117323]       Product name: fake-design-for-testing
[    7.118357] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.119489] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    7.120928] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.122004] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    7.123545] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    7.124900] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    7.130153] oprofile: using timer interrupt.
[    7.130802] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    7.176914] NET: Registered protocol family 26
[    7.177734] Netfilter messages via NETLINK v0.30.
[    7.178543] nf_conntrack version 0.5.0 (1796 buckets, 7184 max)
[    7.181813] ctnetlink v0.93: registering with nfnetlink.
[    7.182904] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    7.184163] ip_set: protocol 6
[    7.184748] IPVS: Registered protocols (TCP, UDP, ESP)
[    7.185664] IPVS: Connection hash table configured (size=3D4096, memory=
=3D64Kbytes)
[    7.186784] IPVS: Each connection entry needs 408 bytes at least
[    7.187974] IPVS: Creating netns size=3D2568 id=3D0
[    7.190636] IPVS: ipvs loaded.
[    7.191150] IPVS: [rr] scheduler registered.
[    7.191805] IPVS: [lc] scheduler registered.
[    7.192479] IPVS: [wlc] scheduler registered.
[    7.193262] IPVS: [lblc] scheduler registered.
[    7.194038] IPVS: [lblcr] scheduler registered.
[    7.194732] IPVS: [dh] scheduler registered.
[    7.195403] IPVS: [sed] scheduler registered.
[    7.196066] IPVS: [nq] scheduler registered.
[    7.197605] TCP: bic registered
[    7.198101] TCP: westwood registered
[    7.198655] TCP: highspeed registered
[    7.199171] TCP: hybla registered
[    7.199682] TCP: htcp registered
[    7.200244] TCP: vegas registered
[    7.200768] TCP: veno registered
[    7.201255] TCP: scalable registered
[    7.201819] TCP: lp registered
[    7.202310] TCP: yeah registered
[    7.202874] Initializing XFRM netlink socket
[    7.204150] NET: Registered protocol family 10
[    7.206540] mip6: Mobile IPv6
[    7.207318] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    7.209361] sit: IPv6 over IPv4 tunneling driver
[    7.211360] ip6_gre: GRE over IPv6 tunneling driver
[    7.212764] NET: Registered protocol family 15
[    7.213719] NET: Registered protocol family 5
[    7.214589] NET: Registered protocol family 9
[    7.215283] X25: Linux Version 0.2
[    7.227874] NET: Registered protocol family 11
[    7.228821] NET: Registered protocol family 3
[    7.229507] can: controller area network core (rev 20120528 abi 9)
[    7.232444] NET: Registered protocol family 29
[    7.233240] can: raw protocol (rev 20120528)
[    7.234044] can: broadcast manager protocol (rev 20120528 t)
[    7.234893] can: netlink gateway (rev 20130117) max_hops=3D1
[    7.237809] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    7.238737] Bluetooth: HIDP socket layer initialized
[    7.239619] NET: Registered protocol family 33
[    7.240393] Key type rxrpc registered
[    7.240933] Key type rxrpc_s registered
[    7.243556] RxRPC: Registered security type 2 'rxkad'
[    7.244403] lec:lane_module_init: lec.c: initialized
[    7.245160] mpoa:atm_mpoa_init: mpc.c: initialized
[    7.250827] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    7.252916] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[    7.253976] NET: Registered protocol family 12
[    7.254796] NET: Registered protocol family 35
[    7.256442] 8021q: 802.1Q VLAN Support v1.8
[    7.257827] sctp: Hash tables configured (established 819 bind 819)
[    7.259518] Key type dns_resolver registered
[    7.260498] Key type ceph registered
[    7.263046] libceph: loaded (mon/osd proto 15/24)
[    7.264282] openvswitch: Open vSwitch switching datapath
[    7.267973] mpls_gso: MPLS GSO support
[    7.271509]=20
[    7.271509] printing PIC contents
[    7.272215] ... PIC  IMR: ffff
[    7.272666] ... PIC  IRR: 1013
[    7.273106] ... PIC  ISR: 0000
[    7.282678] ... PIC ELCR: 0c00
[    7.283163] printing local APIC contents on CPU#0/0:
[    7.283344] ... APIC ID:      00000000 (0)
[    7.283344] ... APIC VERSION: 01050014
[    7.283344] ... APIC TASKPRI: 00000000 (00)
[    7.283344] ... APIC PROCPRI: 00000000
[    7.283344] ... APIC LDR: 01000000
[    7.283344] ... APIC DFR: ffffffff
[    7.283344] ... APIC SPIV: 000001ff
[    7.283344] ... APIC ISR field:
[    7.283344] 000000000000000000000000000000000000000000000000000000000000=
0000
[    7.283344] ... APIC TMR field:
[    7.283344] 000000000200000000000000000000000000000000000000000000000000=
0000
[    7.283344] ... APIC IRR field:
[    7.283344] 000000000000000000000000000000000000000000000000000000000000=
8000
[    7.283344] ... APIC ESR: 00000000
[    7.283344] ... APIC ICR: 000008fd
[    7.283344] ... APIC ICR2: 02000000
[    7.283344] ... APIC LVTT: 000400ef
[    7.283344] ... APIC LVTPC: 00010000
[    7.283344] ... APIC LVT0: 00010700
[    7.283344] ... APIC LVT1: 00000400
[    7.283344] ... APIC LVTERR: 000000fe
[    7.283344] ... APIC TMICT: 00000000
[    7.283344] ... APIC TMCCT: 00000000
[    7.283344] ... APIC TDCR: 00000000
[    7.283344]=20
[    7.300256] number of MP IRQ sources: 15.
[    7.300914] number of IO-APIC #0 registers: 24.
[    7.301630] testing the IO APIC.......................
[    7.302468] IO APIC #0......
[    7.302878] .... register #00: 00000000
[    7.305503] .......    : physical APIC id: 00
[    7.306124] .......    : Delivery Type: 0
[    7.306774] .......    : LTS          : 0
[    7.307616] .... register #01: 00170011
[    7.308169] .......     : max redirection entries: 17
[    7.308894] .......     : PRQ implemented: 0
[    7.315516] .......     : IO APIC version: 11
[    7.316147] .... register #02: 00000000
[    7.316751] .......     : arbitration: 00
[    7.317351] .... IRQ redirection table:
[    7.317944] 1    0    0   0   0    0    0    00
[    7.318644] 0    0    0   0   0    1    1    31
[    7.319336] 0    0    0   0   0    1    1    30
[    7.320045] 0    0    0   0   0    1    1    33
[    7.320742] 1    0    0   0   0    1    1    34
[    7.321446] 1    1    0   0   0    1    1    35
[    7.322128] 0    0    0   0   0    1    1    36
[    7.322827] 0    0    0   0   0    1    1    37
[    7.323542] 0    0    0   0   0    1    1    38
[    7.324221] 0    1    0   0   0    1    1    39
[    7.324909] 1    1    0   0   0    1    1    3A
[    7.335677] 1    1    0   0   0    1    1    3B
[    7.336411] 0    0    0   0   0    1    1    3C
[    7.337131] 0    0    0   0   0    1    1    3D
[    7.337851] 0    0    0   0   0    1    1    3E
[    7.338570] 0    0    0   0   0    1    1    3F
[    7.339270] 1    0    0   0   0    0    0    00
[    7.339983] 1    0    0   0   0    0    0    00
[    7.340723] 1    0    0   0   0    0    0    00
[    7.341442] 1    0    0   0   0    0    0    00
[    7.342132] 1    0    0   0   0    0    0    00
[    7.342837] 1    0    0   0   0    0    0    00
[    7.343555] 1    0    0   0   0    0    0    00
[    7.344254] 1    0    0   0   0    0    0    00
[    7.344947] IRQ to pin mappings:
[    7.347607] IRQ0 -> 0:2
[    7.348035] IRQ1 -> 0:1
[    7.348499] IRQ3 -> 0:3
[    7.348922] IRQ4 -> 0:4
[    7.349362] IRQ5 -> 0:5
[    7.349779] IRQ6 -> 0:6
[    7.350223] IRQ7 -> 0:7
[    7.350664] IRQ8 -> 0:8
[    7.351086] IRQ9 -> 0:9
[    7.351531] IRQ10 -> 0:10
[    7.351971] IRQ11 -> 0:11
[    7.352438] IRQ12 -> 0:12
[    7.352886] IRQ13 -> 0:13
[    7.353365] IRQ14 -> 0:14
[    7.353814] IRQ15 -> 0:15
[    7.354266] .................................... done.
[    7.364178] Running tests on trace events:
[    7.364819] Testing event thermal_apic_exit: OK
[    7.394931] Testing event thermal_apic_entry: OK
[    7.502622] Testing event threshold_apic_exit: OK
[    7.517217] Testing event threshold_apic_entry: OK
[    7.582642] Testing event call_function_single_exit:=20
[    7.590808] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.597215] OK
[    7.597481] Testing event call_function_single_entry: OK
[    7.614108] Testing event call_function_exit: OK
[    7.627823] Testing event call_function_entry: OK
[    7.666724] Testing event irq_work_exit: OK
[    7.701334] Testing event irq_work_entry: OK
[    7.714346] Testing event x86_platform_ipi_exit: OK
[    7.730833] Testing event x86_platform_ipi_entry: OK
[    7.748485] Testing event error_apic_exit: OK
[    7.771220] Testing event error_apic_entry: OK
[    7.805366] Testing event spurious_apic_exit: OK
[    7.845383] Testing event spurious_apic_entry: OK
[    7.881187] Testing event reschedule_exit: OK
[    7.893843] Testing event reschedule_entry: OK
[    7.907165] Testing event local_timer_exit: OK
[    7.936192] Testing event local_timer_entry: OK
[    7.962287] Testing event nmi_handler: OK
[    7.993722] Testing event emulate_vsyscall: OK
[    8.022935] Testing event sys_exit: OK
[    8.062644] Testing event sys_enter: OK
[    8.081121] Testing event mce_record: OK
[    8.095210] Testing event tlb_flush: OK
[    8.108785] Testing event page_fault_kernel: OK
[    8.121371] Testing event page_fault_user: OK
[    8.145952] Testing event task_rename: OK
[    8.210487] Testing event task_newtask: OK
[    8.263448] Testing event softirq_raise: OK
[    8.277231] Testing event softirq_exit: OK
[    8.294655] Testing event softirq_entry: OK
[    8.312424] Testing event irq_handler_exit: OK
[    8.327570] Testing event irq_handler_entry: OK
[    8.341163] Testing event signal_deliver: OK
[    8.358341] Testing event signal_generate: OK
[    8.376184] Testing event workqueue_execute_end: OK
[    8.483983] Testing event workqueue_execute_start: OK
[    8.591196] Testing event workqueue_activate_work: OK
[    8.607589] Testing event workqueue_queue_work: OK
[    8.621176] Testing event sched_wake_idle_without_ipi: OK
[    8.641190] Testing event sched_swap_numa: OK
[    8.714785] Testing event sched_stick_numa: OK
[    8.727148] Testing event sched_move_numa: OK
[    8.740926] Testing event sched_process_hang: OK
[    8.754819] Testing event sched_pi_setprio: OK
[    8.767180] Testing event sched_stat_runtime: OK
[    8.782202] Testing event sched_stat_blocked: OK
[    8.798630] Testing event sched_stat_iowait: OK
[    8.810715] Testing event sched_stat_sleep: OK
[    8.824889] Testing event sched_stat_wait: OK
[    8.837455] Testing event sched_process_exec: OK
[    8.854180] Testing event sched_process_fork: OK
[    8.868322] Testing event sched_process_wait: OK
[    8.881040] Testing event sched_wait_task: OK
[    8.895894] Testing event sched_process_exit: OK
[    8.911690] Testing event sched_process_free: OK
[    8.927813] Testing event sched_migrate_task: OK
[    9.052747] Testing event sched_switch: OK
[    9.087726] Testing event sched_wakeup_new: OK
[    9.138673] Testing event sched_wakeup: OK
[    9.187688] Testing event sched_kthread_stop_ret: OK
[    9.225607] Testing event sched_kthread_stop: OK
[    9.255691] Testing event lock_acquired: OK
[    9.287086] Testing event lock_contended: OK
[    9.328846] Testing event lock_release: OK
[    9.350485] Testing event lock_acquire: OK
[    9.367256] Testing event console: OK
[    9.380453] Testing event rcu_utilization: OK
[    9.394130] Testing event itimer_expire: OK
[    9.407224] Testing event itimer_state: OK
[    9.420499] Testing event hrtimer_cancel: OK
[    9.480613] Testing event hrtimer_expire_exit: OK
[    9.493796] Testing event hrtimer_expire_entry: OK
[    9.526418] Testing event hrtimer_start: OK
[    9.559585] Testing event hrtimer_init: OK
[    9.593010] Testing event timer_cancel: OK
[    9.616618] Testing event timer_expire_exit: OK
[    9.643574] Testing event timer_expire_entry: OK
[    9.665264] Testing event timer_start: OK
[    9.680910] Testing event timer_init: OK
[    9.695078] Testing event ftrace_test_filter: OK
[    9.708591] Testing event dev_pm_qos_remove_request: OK
[    9.728052] Testing event dev_pm_qos_update_request: OK
[    9.744744] Testing event dev_pm_qos_add_request: OK
[    9.758256] Testing event pm_qos_update_flags: OK
[    9.770425] Testing event pm_qos_update_target: OK
[    9.794150] Testing event pm_qos_update_request_timeout: OK
[    9.805856] Testing event pm_qos_remove_request: OK
[    9.823784] Testing event pm_qos_update_request: OK
[    9.843774] Testing event pm_qos_add_request: OK
[    9.857105] Testing event power_domain_target: OK
[    9.873748] Testing event clock_set_rate: OK
[   10.005576] Testing event clock_disable: OK
[   10.215650] Testing event clock_enable: OK
[   10.435568] Testing event wakeup_source_deactivate: OK
[   10.638423] Testing event wakeup_source_activate: OK
[   10.653162] Testing event suspend_resume: OK
[   10.682723] Testing event device_pm_callback_end: OK
[   10.709001] Testing event device_pm_callback_start: OK
[   10.723995] Testing event cpu_frequency: OK
[   10.737168] Testing event pstate_sample: OK
[   10.752163] Testing event cpu_idle: OK
[   10.764394] Testing event mm_filemap_add_to_page_cache: OK
[   10.778935] Testing event mm_filemap_delete_from_page_cache: OK
[   10.794177] Testing event oom_score_adj_update: OK
[   10.807163] Testing event mm_lru_activate: OK
[   10.823899] Testing event mm_lru_insertion: OK
[   10.882986] Testing event mm_vmscan_lru_shrink_inactive: OK
[   10.903879] Testing event mm_vmscan_writepage: OK
[   10.921127] Testing event mm_vmscan_memcg_isolate: OK
[   10.937025] Testing event mm_vmscan_lru_isolate: OK
[   10.953772] Testing event mm_shrink_slab_end: OK
[   10.971157] Testing event mm_shrink_slab_start: OK
[   10.983727] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   10.997069] Testing event mm_vmscan_memcg_reclaim_end: OK
[   11.013769] Testing event mm_vmscan_direct_reclaim_end: OK
[   11.027096] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   11.040387] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   11.057075] Testing event mm_vmscan_direct_reclaim_begin: OK
[   11.070447] Testing event mm_vmscan_wakeup_kswapd: OK
[   11.083950] Testing event mm_vmscan_kswapd_wake: OK
[   11.107153] Testing event mm_vmscan_kswapd_sleep: OK
[   11.152283] Testing event mm_page_alloc_extfrag: OK
[   11.179108] Testing event mm_page_pcpu_drain: OK
[   11.213802] Testing event mm_page_alloc_zone_locked: OK
[   11.233820] Testing event mm_page_alloc: OK
[   11.247123] Testing event mm_page_free_batched: OK
[   11.263913] Testing event mm_page_free: OK
[   11.277136] Testing event kmem_cache_free: OK
[   11.295871] Testing event kfree: OK
[   11.315908] Testing event kmem_cache_alloc_node: OK
[   11.343104] Testing event kmalloc_node: OK
[   11.363844] Testing event kmem_cache_alloc: OK
[   11.377208] Testing event kmalloc: OK
[   11.393996] Testing event mm_compaction_end: OK
[   11.407116] Testing event mm_compaction_begin: OK
[   11.420507] Testing event mm_compaction_migratepages: OK
[   11.437166] Testing event mm_compaction_isolate_freepages: OK
[   11.457164] Testing event mm_compaction_isolate_migratepages: OK
[   11.473809] Testing event mm_numa_migrate_ratelimit: OK
[   11.487083] Testing event mm_migrate_pages: OK
[   11.501716] Testing event writeback_single_inode: OK
[   11.513796] Testing event writeback_single_inode_start: OK
[   11.530407] Testing event writeback_wait_iff_congested: OK
[   11.547107] Testing event writeback_congestion_wait: OK
[   11.567133] Testing event writeback_sb_inodes_requeue: OK
[   11.583787] Testing event balance_dirty_pages: OK
[   11.597178] Testing event bdi_dirty_ratelimit: OK
[   11.610473] Testing event global_dirty_state: OK
[   11.623798] Testing event writeback_queue_io: OK
[   11.637867] Testing event wbc_writepage: OK
[   11.650532] Testing event writeback_bdi_unregister: OK
[   11.731029] Testing event writeback_bdi_register: OK
[   11.743746] Testing event writeback_wake_background: OK
[   11.757037] Testing event writeback_nowork: OK
[   11.770408] Testing event writeback_pages_written: OK
[   11.783779] Testing event writeback_wait: OK
[   11.797089] Testing event writeback_written: OK
[   11.813298] Testing event writeback_start: OK
[   11.830423] Testing event writeback_exec: OK
[   11.847088] Testing event writeback_queue: OK
[   11.860385] Testing event writeback_write_inode: OK
[   11.873957] Testing event writeback_write_inode_start: OK
[   11.890483] Testing event writeback_dirty_inode: OK
[   11.907510] Testing event writeback_dirty_inode_start: OK
[   11.927091] Testing event writeback_dirty_page: OK
[   11.943748] Testing event ext3_load_inode: OK
[   11.960417] Testing event ext3_get_blocks_exit: OK
[   11.975857] Testing event ext3_get_blocks_enter: OK
[   12.100929] Testing event ext3_truncate_exit: OK
[   12.314309] Testing event ext3_truncate_enter: OK
[   12.534281] Testing event ext3_unlink_exit: OK
[   12.774275] Testing event ext3_unlink_enter: OK
[   12.837072] Testing event ext3_direct_IO_exit: OK
[   12.850427] Testing event ext3_direct_IO_enter: OK
[   12.863712] Testing event ext3_read_block_bitmap: OK
[   12.877086] Testing event ext3_forget: OK
[   12.890417] Testing event ext3_reserved: OK
[   13.014247] Testing event ext3_alloc_new_reservation: OK
[   13.170917] Testing event ext3_discard_reservation: OK
[   13.282409] Testing event ext3_rsv_window_add: OK
[   13.417614] Testing event ext3_sync_fs: OK
[   13.594244] Testing event ext3_sync_file_exit: OK
[   13.834274] Testing event ext3_sync_file_enter: OK
[   13.860444] Testing event ext3_free_blocks: OK
[   13.873726] Testing event ext3_allocate_blocks: OK
[   13.887059] Testing event ext3_request_blocks: OK
[   13.900395] Testing event ext3_discard_blocks: OK
[   13.913759] Testing event ext3_invalidatepage: OK
[   13.927110] Testing event ext3_releasepage: OK
[   13.940401] Testing event ext3_readpage: OK
[   13.953728] Testing event ext3_journalled_writepage: OK
[   13.967058] Testing event ext3_writeback_writepage: OK
[   13.983046] Testing event ext3_ordered_writepage: OK
[   14.000450] Testing event ext3_journalled_write_end: OK
[   14.017919] Testing event ext3_writeback_write_end: OK
[   14.034732] Testing event ext3_ordered_write_end: OK
[   14.050558] Testing event ext3_write_begin: OK
[   14.063843] Testing event ext3_mark_inode_dirty: OK
[   14.078287] Testing event ext3_drop_inode: OK
[   14.091706] Testing event ext3_evict_inode: OK
[   14.103796] Testing event ext3_allocate_inode: OK
[   14.121894] Testing event ext3_request_inode: OK
[   14.135585] Testing event ext3_free_inode: OK
[   14.148711] Testing event journal_write_superblock: OK
[   14.163789] Testing event jbd_cleanup_journal_tail: OK
[   14.182250] Testing event jbd_do_submit_data: OK
[   14.195813] Testing event jbd_end_commit: OK
[   14.215845] Testing event jbd_drop_transaction: OK
[   14.230490] Testing event jbd_commit_logging: OK
[   14.243786] Testing event jbd_commit_flushing: OK
[   14.262724] Testing event jbd_commit_locking: OK
[   14.277103] Testing event jbd_start_commit: OK
[   14.290473] Testing event jbd_checkpoint: OK
[   14.304906] Testing event jbd2_lock_buffer_stall: OK
[   14.319837] Testing event jbd2_write_superblock: OK
[   14.339921] Testing event jbd2_update_log_tail: OK
[   14.359929] Testing event jbd2_checkpoint_stats: OK
[   14.379967] Testing event jbd2_run_stats: OK
[   14.396053] Testing event jbd2_handle_stats: OK
[   14.413262] Testing event jbd2_handle_extend: OK
[   14.430280] Testing event jbd2_handle_start: OK
[   14.445950] Testing event jbd2_submit_inode_data: OK
[   14.463218] Testing event jbd2_end_commit: OK
[   14.477257] Testing event jbd2_drop_transaction: OK
[   14.490464] Testing event jbd2_commit_logging: OK
[   14.504259] Testing event jbd2_commit_flushing: OK
[   14.520538] Testing event jbd2_commit_locking: OK
[   14.537804] Testing event jbd2_start_commit: OK
[   14.550470] Testing event jbd2_checkpoint: OK
[   14.568331] Testing event ocfs2_remove_block_from_cache: OK
[   14.584695] Testing event ocfs2_remove_metadata_tree: OK
[   14.599852] Testing event ocfs2_remove_metadata_array: OK
[   14.614910] Testing event ocfs2_set_buffer_uptodate_begin: OK
[   14.628293] Testing event ocfs2_set_buffer_uptodate: OK
[   14.641693] Testing event ocfs2_expand_cache: OK
[   14.658471] Testing event ocfs2_insert_cache_tree: OK
[   14.671889] Testing event ocfs2_append_cache_array: OK
[   14.685286] Testing event ocfs2_buffer_cached_end: OK
[   14.698672] Testing event ocfs2_buffer_cached_begin: OK
[   14.712080] Testing event ocfs2_metadata_cache_purge: OK
[   14.725527] Testing event ocfs2_purge_copied_metadata_tree: OK
[   14.745626] Testing event ocfs2_read_blocks_begin: OK
[   14.759033] Testing event ocfs2_write_block: OK
[   14.772453] Testing event ocfs2_read_blocks_end: OK
[   14.823656] Testing event ocfs2_read_blocks_bh: OK
[   14.843902] Testing event ocfs2_read_blocks_from_disk: OK
[   14.857379] Testing event ocfs2_read_blocks_sync_jbd: OK
[   14.954422] Testing event ocfs2_read_blocks_sync: OK
[   14.967308] Testing event ocfs2_wait_on_mount: OK
[   14.980505] Testing event ocfs2_recover_orphans_iput: OK
[   15.005459] Testing event ocfs2_recover_orphans: OK
[   15.021269] Testing event ocfs2_orphan_filldir: OK
[   15.037961] Testing event ocfs2_queue_orphan_scan_end: OK
[   15.061483] Testing event ocfs2_queue_orphan_scan_begin: OK
[   15.091673] Testing event ocfs2_mark_dead_nodes: OK
[   15.126481] Testing event ocfs2_recover_node_skip: OK
[   15.152670] Testing event ocfs2_recover_node: OK
[   15.187514] Testing event ocfs2_replay_journal_skip: OK
[   15.217047] Testing event ocfs2_replay_journal_lock_err: OK
[   15.258115] Testing event ocfs2_replay_journal_recovered: OK
[   15.295984] Testing event ocfs2_recovery_thread: OK
[   15.339301] Testing event ocfs2_recovery_thread_end: OK
[   15.359394] Testing event ocfs2_recovery_thread_node: OK
[   15.397865] Testing event ocfs2_complete_recovery_slot: OK
[   15.420341] Testing event ocfs2_complete_recovery_end: OK
[   15.445837] Testing event ocfs2_complete_recovery: OK
[   15.489459] Testing event ocfs2_journal_shutdown_wait: OK
[   15.529548] Testing event ocfs2_journal_shutdown: OK
[   15.585320] Testing event ocfs2_journal_init_maxlen: OK
[   15.608200] Testing event ocfs2_journal_init: OK
[   15.620800] Testing event ocfs2_journal_dirty: OK
[   15.647302] Testing event ocfs2_journal_access: OK
[   15.661257] Testing event ocfs2_allocate_extend_trans: OK
[   15.677160] Testing event ocfs2_extend_trans_restart: OK
[   15.691252] Testing event ocfs2_extend_trans: OK
[   15.708209] Testing event ocfs2_commit_cache_end: OK
[   15.721022] Testing event ocfs2_commit_cache_begin: OK
[   15.734409] Testing event ocfs2_encode_fh_type: OK
[   15.747954] Testing event ocfs2_encode_fh_parent: OK
[   15.763911] Testing event ocfs2_encode_fh_self: OK
[   15.779173] Testing event ocfs2_encode_fh_begin: OK
[   15.797836] Testing event ocfs2_get_parent_end: OK
[   15.814059] Testing event ocfs2_get_parent: OK
[   15.844580] Testing event ocfs2_get_dentry_end: OK
[   15.934050] Testing event ocfs2_get_dentry_generation: OK
[   16.014403] Testing event ocfs2_get_dentry_stale: OK
[   16.034376] Testing event ocfs2_get_dentry_test_bit: OK
[   16.054444] Testing event ocfs2_get_dentry_begin: OK
[   16.071041] Testing event ocfs2_dentry_attach_lock_found: OK
[   16.095364] Testing event ocfs2_dentry_attach_lock: OK
[   16.118658] Testing event ocfs2_find_local_alias: OK
[   16.225250] Testing event ocfs2_dentry_revalidate_ret: OK
[   16.267181] Testing event ocfs2_dentry_revalidate_nofsdata: OK
[   16.291070] Testing event ocfs2_dentry_revalidate_orphaned: OK
[   16.310835] Testing event ocfs2_dentry_revalidate_delete: OK
[   16.334223] Testing event ocfs2_dentry_revalidate_negative: OK
[   16.357664] Testing event ocfs2_dentry_revalidate: OK
[   16.373593] Testing event ocfs2_orphan_del: OK
[   16.393526] Testing event ocfs2_orphan_add_end: OK
[   16.420971] Testing event ocfs2_orphan_add_begin: OK
[   16.433911] Testing event ocfs2_blkno_stringify: OK
[   16.447768] Testing event ocfs2_symlink_begin: OK
[   16.470785] Testing event ocfs2_create_symlink_data: OK
[   16.579529] Testing event ocfs2_rename_over_existing: OK
[   16.611229] Testing event ocfs2_rename_disagree: OK
[   16.626210] Testing event ocfs2_rename_target_exists: OK
[   16.646948] Testing event ocfs2_rename_not_permitted: OK
[   16.662183] Testing event ocfs2_rename: OK
[   16.677279] Testing event ocfs2_double_lock_end: OK
[   16.694657] Testing event ocfs2_double_lock: OK
[   16.713266] Testing event ocfs2_unlink_noent: OK
[   16.734295] Testing event ocfs2_link: OK
[   16.748206] Testing event ocfs2_mknod: OK
[   16.768162] Testing event ocfs2_lookup_ret: OK
[   16.788180] Testing event ocfs2_mv_orphaned_inode_to_new: OK
[   16.826217] Testing event ocfs2_symlink_create: OK
[   16.857214] Testing event ocfs2_unlink: OK
[   16.882684] Testing event ocfs2_create: OK
[   16.906073] Testing event ocfs2_mkdir: OK
[   16.920489] Testing event ocfs2_lookup: OK
[   16.940535] Testing event ocfs2_prepare_dir_for_insert: OK
[   16.960477] Testing event ocfs2_dx_dir_rebalance_split: OK
[   16.983898] Testing event ocfs2_dx_dir_rebalance: OK
[   17.000459] Testing event ocfs2_extend_dir: OK
[   17.022370] Testing event ocfs2_dx_dir_index_root_block: OK
[   17.038710] Testing event ocfs2_dx_dir_format_cluster: OK
[   17.090444] Testing event ocfs2_dx_dir_attach_index: OK
[   17.129873] Testing event ocfs2_check_dir_for_entry: OK
[   17.157263] Testing event ocfs2_find_files_on_disk: OK
[   17.192057] Testing event ocfs2_readdir: OK
[   17.236248] Testing event ocfs2_delete_entry_dx: OK
[   17.266741] Testing event ocfs2_dx_dir_search_leaf_info: OK
[   17.299957] Testing event ocfs2_dx_dir_search: OK
[   17.380800] Testing event ocfs2_find_entry_el: OK
[   17.482237] Testing event ocfs2_validate_dir_block: OK
[   17.515524] Testing event ocfs2_search_dirblock: OK
[   17.564073] Testing event ocfs2_mark_dquot_dirty: OK
[   17.583814] Testing event ocfs2_acquire_dquot: OK
[   17.603787] Testing event ocfs2_release_dquot: OK
[   17.620465] Testing event ocfs2_write_dquot: OK
[   17.640431] Testing event ocfs2_sync_dquot_helper: OK
[   17.660424] Testing event ocfs2_sync_dquot: OK
[   17.677094] Testing event ocfs2_validate_quota_block: OK
[   17.694420] Testing event olq_set_dquot: OK
[   17.710571] Testing event ocfs2_finish_quota_recovery: OK
[   17.735962] Testing event ocfs2_recover_local_quota_file: OK
[   17.756003] Testing event ocfs2_resmap_claimed_bits_end: OK
[   17.770395] Testing event ocfs2_resmap_claimed_bits_begin: OK
[   17.791008] Testing event ocfs2_resmap_resv_bits: OK
[   17.810407] Testing event ocfs2_cannibalize_resv_end: OK
[   17.830498] Testing event ocfs2_cannibalize_resv_begin: OK
[   17.850434] Testing event ocfs2_resv_find_window_next: OK
[   17.870624] Testing event ocfs2_resv_find_window_prev: OK
[   17.890624] Testing event ocfs2_resv_find_window_begin: OK
[   17.910640] Testing event ocfs2_resmap_find_free_bits_end: OK
[   18.017149] Testing event ocfs2_resmap_find_free_bits_begin: OK
[   18.041953] Testing event ocfs2_resv_insert: OK
[   18.060616] Testing event ocfs2_reflink_xattr_rec: OK
[   18.099789] Testing event ocfs2_reflink_xattr_buckets: OK
[   18.129455] Testing event ocfs2_xattr_bucket_value_refcount: OK
[   18.177523] Testing event ocfs2_xattr_set_entry_index_block: OK
[   18.255498] Testing event ocfs2_xattr_set_entry_bucket: OK
[   18.292962] Testing event ocfs2_create_empty_xattr_block: OK
[   18.318878] Testing event ocfs2_reflink_xattr_header: OK
[   18.341131] Testing event ocfs2_rm_xattr_cluster: OK
[   18.361472] Testing event ocfs2_xattr_bucket_value_truncate: OK
[   18.480493] Testing event ocfs2_add_new_xattr_bucket: OK
[   18.493893] Testing event ocfs2_extend_xattr_bucket: OK
[   18.527591] Testing event ocfs2_add_new_xattr_cluster_insert: OK
[   18.576341] Testing event ocfs2_add_new_xattr_cluster: OK
[   18.611313] Testing event ocfs2_add_new_xattr_cluster_begin: OK
[   18.636051] Testing event ocfs2_adjust_xattr_cross_cluster: OK
[   18.661041] Testing event ocfs2_mv_xattr_buckets: OK
[   18.677191] Testing event ocfs2_cp_xattr_bucket: OK
[   18.693512] Testing event ocfs2_divide_xattr_bucket_move: OK
[   18.732219] Testing event ocfs2_divide_xattr_bucket_begin: OK
[   18.768305] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
[   18.788487] Testing event ocfs2_defrag_xattr_bucket: OK
[   18.810825] Testing event ocfs2_xattr_create_index_block: OK
[   18.887039] Testing event ocfs2_xattr_create_index_block_begin: OK
[   18.907254] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
[   18.921108] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
[   18.934977] Testing event ocfs2_iterate_xattr_bucket: OK
[   18.960609] Testing event ocfs2_iterate_xattr_buckets: OK
[   18.984920] Testing event ocfs2_xattr_index_block_find_rec: OK
[   18.998712] Testing event ocfs2_xattr_index_block_find: OK
[   19.013900] Testing event ocfs2_xattr_bucket_find: OK
[   19.028323] Testing event ocfs2_init_xattr_set_ctxt: OK
[   19.043918] Testing event ocfs2_xattr_extend_allocation: OK
[   19.087336] Testing event ocfs2_validate_xattr_block: OK
[   19.123372] Testing event ocfs2_initialize_super: OK
[   19.153978] Testing event ocfs2_dismount_volume: OK
[   19.182650] Testing event ocfs2_statfs: OK
[   19.227508] Testing event ocfs2_put_super: OK
[   19.268167] Testing event ocfs2_parse_options: OK
[   19.355863] Testing event ocfs2_fill_super: OK
[   19.431088] Testing event ocfs2_remount: OK
[   19.489884] Testing event ocfs2_do_node_down: OK
[   19.514548] Testing event ocfs2_find_slot: OK
[   19.546009] Testing event ocfs2_map_slot_buffers_block: OK
[   19.560373] Testing event ocfs2_map_slot_buffers: OK
[   19.573776] Testing event ocfs2_refresh_slot_info: OK
[   19.606964] Testing event ocfs2_read_virt_blocks: OK
[   19.649211] Testing event ocfs2_mark_inode_dirty: OK
[   19.688354] Testing event ocfs2_inode_revalidate: OK
[   19.716983] Testing event ocfs2_drop_inode: OK
[   19.747258] Testing event ocfs2_clear_inode: OK
[   19.816721] Testing event ocfs2_delete_inode: OK
[   19.850582] Testing event ocfs2_cleanup_delete_inode: OK
[   19.935908] Testing event ocfs2_query_inode_wipe_end: OK
[   20.073768] Testing event ocfs2_query_inode_wipe_succ: OK
[   20.087041] Testing event ocfs2_query_inode_wipe_begin: OK
[   20.100372] Testing event ocfs2_inode_is_valid_to_delete: OK
[   20.113705] Testing event ocfs2_validate_inode_block: OK
[   20.127059] Testing event ocfs2_check_orphan_recovery_state: OK
[   20.140359] Testing event ocfs2_read_locked_inode: OK
[   20.153710] Testing event ocfs2_populate_inode: OK
[   20.170385] Testing event ocfs2_find_actor: OK
[   20.183706] Testing event ocfs2_iget_end: OK
[   20.197045] Testing event ocfs2_iget5_locked: OK
[   20.289869] Testing event ocfs2_iget_begin: OK
[   20.341080] Testing event generic_file_aio_read_ret: OK
[   20.363722] Testing event ocfs2_prepare_inode_for_write: OK
[   20.380353] Testing event ocfs2_remove_inode_range: OK
[   20.403736] Testing event ocfs2_zero_partial_clusters_range2: OK
[   20.420395] Testing event ocfs2_zero_partial_clusters_range1: OK
[   20.492438] Testing event ocfs2_zero_partial_clusters: OK
[   20.530449] Testing event ocfs2_write_remove_suid: OK
[   20.543724] Testing event ocfs2_setattr: OK
[   20.567662] Testing event ocfs2_zero_extend: OK
[   20.580439] Testing event ocfs2_zero_extend_range: OK
[   20.598454] Testing event ocfs2_write_zero_page: OK
[   20.613799] Testing event ocfs2_extend_allocation_end: OK
[   20.630496] Testing event ocfs2_extend_allocation: OK
[   20.694001] Testing event ocfs2_truncate_file_error: OK
[   20.707138] Testing event ocfs2_truncate_file: OK
[   20.723784] Testing event ocfs2_file_aio_read: OK
[   20.785909] Testing event ocfs2_file_splice_read: OK
[   20.889157] Testing event ocfs2_file_splice_write: OK
[   20.910676] Testing event ocfs2_file_aio_write: OK
[   20.927258] Testing event ocfs2_sync_file: OK
[   20.943909] Testing event ocfs2_file_release: OK
[   20.957281] Testing event ocfs2_file_open: OK
[   20.973725] Testing event ocfs2_fault: OK
[   20.987828] Testing event ocfs2_write_end_inline: OK
[   21.004453] Testing event ocfs2_write_begin_nolock: OK
[   21.021578] Testing event ocfs2_try_to_write_inline_data: OK
[   21.037836] Testing event ocfs2_bmap: OK
[   21.054646] Testing event ocfs2_writepage: OK
[   21.070440] Testing event ocfs2_readpage: OK
[   21.087096] Testing event ocfs2_get_block_end: OK
[   21.155754] Testing event ocfs2_get_block: OK
[   21.211824] Testing event ocfs2_symlink_get_block: OK
[   21.231004] Testing event ocfs2_refcount_cow_hunk: OK
[   21.247904] Testing event ocfs2_make_clusters_writable: OK
[   21.264824] Testing event ocfs2_replace_clusters: OK
[   21.281991] Testing event ocfs2_clear_ext_refcount: OK
[   21.301639] Testing event ocfs2_duplicate_clusters_by_jbd: OK
[   21.313856] Testing event ocfs2_duplicate_clusters_by_page: OK
[   21.330737] Testing event ocfs2_lock_refcount_allocators: OK
[   21.347266] Testing event ocfs2_prepare_refcount_change_for_del: OK
[   21.365239] Testing event ocfs2_add_refcount_flag: OK
[   21.383938] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
[   21.400660] Testing event ocfs2_calc_refcount_meta_credits: OK
[   21.417111] Testing event ocfs2_mark_extent_refcounted: OK
[   21.431203] Testing event ocfs2_decrease_refcount: OK
[   21.443763] Testing event ocfs2_decrease_refcount_rec: OK
[   21.457120] Testing event ocfs2_restore_refcount_block: OK
[   21.473824] Testing event ocfs2_remove_refcount_extent: OK
[   21.487119] Testing event ocfs2_increase_refcount_split: OK
[   21.515044] Testing event ocfs2_increase_refcount_insert: OK
[   21.530458] Testing event ocfs2_increase_refcount_change: OK
[   21.543764] Testing event ocfs2_increase_refcount_begin: OK
[   21.563807] Testing event ocfs2_split_refcount_rec_insert: OK
[   21.577801] Testing event ocfs2_split_refcount_rec: OK
[   21.590720] Testing event ocfs2_insert_refcount_rec: OK
[   21.607113] Testing event ocfs2_new_leaf_refcount_block: OK
[   21.620434] Testing event ocfs2_divide_leaf_refcount_block: OK
[   21.634147] Testing event ocfs2_expand_inline_ref_root: OK
[   21.647101] Testing event ocfs2_change_refcount_rec: OK
[   21.660435] Testing event ocfs2_create_refcount_tree_blkno: OK
[   21.673794] Testing event ocfs2_create_refcount_tree: OK
[   21.690456] Testing event ocfs2_purge_refcount_trees: OK
[   21.712358] Testing event ocfs2_validate_refcount_block: OK
[   21.727111] Testing event ocfs2_test_inode_bit: OK
[   21.740433] Testing event ocfs2_test_suballoc_bit: OK
[   21.753783] Testing event ocfs2_get_suballoc_slot_bit: OK
[   21.767092] Testing event ocfs2_free_clusters: OK
[   21.780435] Testing event ocfs2_free_suballoc_bits: OK
[   21.793801] Testing event ocfs2_block_group_clear_bits: OK
[   21.807088] Testing event ocfs2_claim_new_inode_at_loc: OK
[   21.820437] Testing event ocfs2_claim_suballoc_bits: OK
[   21.833911] Testing event ocfs2_search_chain_end: OK
[   21.847130] Testing event ocfs2_search_chain_succ: OK
[   21.860920] Testing event ocfs2_search_chain_begin: OK
[   21.873830] Testing event ocfs2_block_group_search_max_block: OK
[   21.888774] Testing event ocfs2_cluster_group_search_max_block: OK
[   21.903792] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
[   21.917136] Testing event ocfs2_relink_block_group: OK
[   21.930462] Testing event ocfs2_block_group_set_bits: OK
[   21.943847] Testing event ocfs2_reserve_new_inode_new_group: OK
[   21.957120] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
[   21.970425] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
[   21.983813] Testing event ocfs2_block_group_alloc: OK
[   21.997101] Testing event ocfs2_block_group_alloc_discontig: OK
[   22.010425] Testing event ocfs2_block_group_alloc_contig: OK
[   22.023852] Testing event ocfs2_validate_group_descriptor: OK
[   22.037106] Testing event ocfs2_group_add: OK
[   22.050449] Testing event ocfs2_group_extend: OK
[   22.073787] Testing event ocfs2_update_last_group_and_inode: OK
[   22.092323] Testing event ocfs2_local_alloc_new_window_result: OK
[   22.110435] Testing event ocfs2_local_alloc_new_window: OK
[   22.123800] Testing event ocfs2_sync_local_to_main_free: OK
[   22.140425] Testing event ocfs2_sync_local_to_main: OK
[   22.153774] Testing event ocfs2_local_alloc_find_clear_bits: OK
[   22.167112] Testing event ocfs2_local_alloc_find_clear_bits_search_bitma=
p: OK
[   22.180417] Testing event ocfs2_local_alloc_count_bits: OK
[   22.193805] Testing event ocfs2_reserve_local_alloc_bits: OK
[   22.207113] Testing event ocfs2_begin_local_alloc_recovery: OK
[   22.220419] Testing event ocfs2_load_local_alloc: OK
[   22.233786] Testing event ocfs2_alloc_should_use_local: OK
[   22.267201] Testing event ocfs2_la_set_sizes: OK
[   22.287122] Testing event ocfs2_trim_fs: OK
[   22.300458] Testing event ocfs2_trim_group: OK
[   22.313813] Testing event ocfs2_trim_extent: OK
[   22.327125] Testing event ocfs2_cache_block_dealloc: OK
[   22.340457] Testing event ocfs2_run_deallocs: OK
[   22.353886] Testing event ocfs2_cache_cluster_dealloc: OK
[   22.367130] Testing event ocfs2_free_cached_blocks: OK
[   22.380430] Testing event ocfs2_complete_truncate_log_recovery: OK
[   22.393793] Testing event ocfs2_truncate_log_recovery_num: OK
[   22.407120] Testing event ocfs2_begin_truncate_log_recovery: OK
[   22.420454] Testing event ocfs2_flush_truncate_log: OK
[   22.433723] Testing event ocfs2_replay_truncate_records: OK
[   22.447072] Testing event ocfs2_truncate_log_append: OK
[   22.460443] Testing event ocfs2_mark_extent_written: OK
[   22.473789] Testing event ocfs2_add_clusters_in_btree_ret: OK
[   22.487050] Testing event ocfs2_rotate_leaf: OK
[   22.500414] Testing event ocfs2_validate_extent_block: OK
[   22.513758] Testing event ocfs2_commit_truncate: OK
[   22.527060] Testing event ocfs2_remove_extent: OK
[   22.540400] Testing event ocfs2_split_extent: OK
[   22.553760] Testing event ocfs2_insert_extent: OK
[   22.567112] Testing event ocfs2_rotate_subtree: OK
[   22.580462] Testing event ocfs2_grow_tree: OK
[   22.593760] Testing event ocfs2_complete_edge_insert: OK
[   22.607085] Testing event ocfs2_num_free_extents: OK
[   22.627103] Testing event ocfs2_add_clusters_in_btree: OK
[   22.647103] Testing event ocfs2_insert_extent_start: OK
[   22.660418] Testing event ocfs2_append_rec_to_path: OK
[   22.673770] Testing event ocfs2_rotate_tree_right: OK
[   22.687164] Testing event ocfs2_adjust_rightmost_branch: OK
[   22.700430] Testing event btrfs_workqueue_destroy: OK
[   22.713867] Testing event btrfs_workqueue_alloc: OK
[   22.727166] Testing event btrfs_ordered_sched: OK
[   22.865790] Testing event btrfs_all_work_done: OK
[   22.920428] Testing event btrfs_normal_work_done: OK
[   23.035794] Testing event btrfs_work_sched: OK
[   23.050377] Testing event btrfs_work_queued: OK
[   23.063722] Testing event free_extent_state: OK
[   23.077091] Testing event alloc_extent_state: OK
[   23.100413] Testing event btrfs_setup_cluster: OK
[   23.120460] Testing event btrfs_failed_cluster_setup: OK
[   23.225925] Testing event btrfs_find_cluster: OK
[   23.246034] Testing event btrfs_reserve_extent_cluster: OK
[   23.280489] Testing event btrfs_reserve_extent: OK
[   23.300482] Testing event find_free_extent: OK
[   23.320422] Testing event btrfs_reserved_extent_free: OK
[   23.340664] Testing event btrfs_reserved_extent_alloc: OK
[   23.363837] Testing event btrfs_space_reservation: OK
[   23.398289] Testing event btrfs_cow_block: OK
[   23.423806] Testing event btrfs_chunk_free: OK
[   23.456206] Testing event btrfs_chunk_alloc: OK
[   23.480448] Testing event run_delayed_ref_head: OK
[   23.500432] Testing event add_delayed_ref_head: OK
[   23.546006] Testing event run_delayed_data_ref: OK
[   23.580463] Testing event add_delayed_data_ref: OK
[   23.606153] Testing event run_delayed_tree_ref: OK
[   23.630523] Testing event add_delayed_tree_ref: OK
[   23.785842] Testing event btrfs_sync_fs: OK
[   23.826115] Testing event btrfs_sync_file: OK
[   23.853778] Testing event btrfs_writepage_end_io_hook: OK
[   23.900470] Testing event __extent_writepage: OK
[   23.920436] Testing event btrfs_ordered_extent_put: OK
[   23.966219] Testing event btrfs_ordered_extent_start: OK
[   23.990433] Testing event btrfs_ordered_extent_remove: OK
[   24.013791] Testing event btrfs_ordered_extent_add: OK
[   24.125952] Testing event btrfs_get_extent: OK
[   24.146196] Testing event btrfs_inode_evict: OK
[   24.170448] Testing event btrfs_inode_request: OK
[   24.187084] Testing event btrfs_inode_new: OK
[   24.203726] Testing event btrfs_transaction_commit: OK
[   24.220500] Testing event gfs2_rs: OK
[   24.237179] Testing event gfs2_block_alloc: OK
[   24.253894] Testing event gfs2_bmap: OK
[   24.270470] Testing event gfs2_ail_flush: OK
[   24.287162] Testing event gfs2_log_blocks: OK
[   24.304044] Testing event gfs2_log_flush: OK
[   24.320475] Testing event gfs2_pin: OK
[   24.337189] Testing event gfs2_glock_lock_time: OK
[   24.353693] Testing event gfs2_glock_queue: OK
[   24.370741] Testing event gfs2_promote: OK
[   24.387125] Testing event gfs2_demote_rq: OK
[   24.403771] Testing event gfs2_glock_put: OK
[   24.420411] Testing event gfs2_glock_state_change: OK
[   24.437085] Testing event block_rq_remap: OK
[   24.453694] Testing event block_bio_remap: OK
[   24.470412] Testing event block_split: OK
[   24.487070] Testing event block_unplug: OK
[   24.503825] Testing event block_plug: OK
[   24.520550] Testing event block_sleeprq: OK
[   24.541510] Testing event block_getrq: OK
[   24.557541] Testing event block_bio_queue: OK
[   24.579966] Testing event block_bio_frontmerge: OK
[   24.597125] Testing event block_bio_backmerge: OK
[   24.612821] Testing event block_bio_complete: OK
[   24.628215] Testing event block_bio_bounce: OK
[   24.643743] Testing event block_rq_issue: OK
[   24.663850] Testing event block_rq_insert: OK
[   24.677205] Testing event block_rq_complete: OK
[   24.697072] Testing event block_rq_requeue: OK
[   24.713834] Testing event block_rq_abort: OK
[   24.734802] Testing event block_dirty_buffer: OK
[   24.754904] Testing event block_touch_buffer: OK
[   24.776000] Testing event swiotlb_bounced: OK
[   24.800876] Testing event gpio_value: OK
[   24.814983] Testing event gpio_direction: OK
[   24.833881] Testing event regulator_set_voltage_complete: OK
[   24.847281] Testing event regulator_set_voltage: OK
[   24.863945] Testing event regulator_disable_complete: OK
[   24.877345] Testing event regulator_disable: OK
[   24.946393] Testing event regulator_enable_complete: OK
[   24.966269] Testing event regulator_enable_delay: OK
[   24.984068] Testing event regulator_enable: OK
[   25.000606] Testing event urandom_read: OK
[   25.058148] Testing event random_read: OK
[   25.073823] Testing event extract_entropy_user: OK
[   25.130797] Testing event extract_entropy: OK
[   25.154447] Testing event get_random_bytes_arch: OK
[   25.178146] Testing event get_random_bytes: OK
[   25.194745] Testing event xfer_secondary_pool: OK
[   25.208945] Testing event add_disk_randomness: OK
[   25.236218] Testing event add_input_randomness: OK
[   25.253749] Testing event debit_entropy: OK
[   25.356935] Testing event push_to_pool: OK
[   25.370585] Testing event credit_entropy_bits: OK
[   25.390555] Testing event mix_pool_bytes_nolock: OK
[   25.404775] Testing event mix_pool_bytes: OK
[   25.420834] Testing event add_device_randomness: OK
[   25.434772] Testing event drm_vblank_event_delivered: OK
[   25.447605] Testing event drm_vblank_event_queued: OK
[   25.470853] Testing event drm_vblank_event: OK
[   25.484577] Testing event regcache_drop_region: OK
[   25.514660] Testing event regmap_async_complete_done: OK
[   25.556894] Testing event regmap_async_complete_start: OK
[   25.580497] Testing event regmap_async_io_complete: OK
[   25.597110] Testing event regmap_async_write_start: OK
[   25.613847] Testing event regmap_cache_bypass: OK
[   25.630929] Testing event regmap_cache_only: OK
[   25.733261] Testing event regcache_sync: OK
[   25.748291] Testing event regmap_hw_write_done: OK
[   25.760595] Testing event regmap_hw_write_start: OK
[   25.774469] Testing event regmap_hw_read_done: OK
[   25.833987] Testing event regmap_hw_read_start: OK
[   25.847532] Testing event regmap_reg_read_cache: OK
[   25.876232] Testing event regmap_reg_read: OK
[   25.937631] Testing event regmap_reg_write: OK
[   25.957416] Testing event fence_wait_end: OK
[   26.040416] Testing event fence_wait_start: OK
[   26.078387] Testing event fence_signaled: OK
[   26.144215] Testing event fence_enable_signal: OK
[   26.214931] Testing event fence_destroy: OK
[   26.252567] Testing event fence_init: OK
[   26.323881] Testing event fence_emit: OK
[   26.337209] Testing event fence_annotate_wait_on: OK
[   26.350429] Testing event scsi_eh_wakeup: OK
[   26.392115] Testing event scsi_dispatch_cmd_timeout: OK
[   26.452277] Testing event scsi_dispatch_cmd_done: OK
[   26.606529] Testing event scsi_dispatch_cmd_error: OK
[   26.682674] Testing event scsi_dispatch_cmd_start: OK
[   26.742285] Testing event target_cmd_complete: OK
[   26.781126] Testing event target_sequencer_start: OK
[   26.816374] Testing event spi_transfer_stop: OK
[   26.846622] Testing event spi_transfer_start: OK
[   26.881717] Testing event spi_message_done: OK
[   26.911086] Testing event spi_message_start: OK
[   26.949762] Testing event spi_message_submit: OK
[   26.994839] Testing event spi_master_busy: OK
[   27.035020] Testing event spi_master_idle: OK
[   27.133880] Testing event smbus_result: OK
[   27.170332] Testing event smbus_reply: OK
[   27.207174] Testing event smbus_read: OK
[   27.240494] Testing event smbus_write: OK
[   27.276376] Testing event i2c_result: OK
[   27.319832] Testing event i2c_reply: OK
[   27.337232] Testing event i2c_read: OK
[   27.350640] Testing event i2c_write: OK
[   27.393316] Testing event v4l2_qbuf: OK
[   27.427966] Testing event v4l2_dqbuf: OK
[   27.470345] Testing event snd_soc_cache_sync: OK
[   27.517059] Testing event snd_soc_jack_notify: OK
[   27.546151] Testing event snd_soc_jack_report: OK
[   27.560389] Testing event snd_soc_jack_irq: OK
[   27.573827] Testing event snd_soc_dapm_connected: OK
[   27.636812] Testing event snd_soc_dapm_input_path: OK
[   27.650455] Testing event snd_soc_dapm_output_path: OK
[   27.664420] Testing event snd_soc_dapm_walk_done: OK
[   27.677578] Testing event snd_soc_dapm_widget_event_done: OK
[   27.690414] Testing event snd_soc_dapm_widget_event_start: OK
[   27.703935] Testing event snd_soc_dapm_widget_power: OK
[   27.717067] Testing event snd_soc_dapm_done: OK
[   27.767144] Testing event snd_soc_dapm_start: OK
[   27.780477] Testing event snd_soc_bias_level_done: OK
[   27.793722] Testing event snd_soc_bias_level_start: OK
[   27.808733] Testing event udp_fail_queue_rcv_skb: OK
[   27.820384] Testing event sock_exceed_buf_limit: OK
[   27.833748] Testing event sock_rcvqueue_full: OK
[   27.847123] Testing event napi_poll: OK
[   27.926248] Testing event netif_rx_ni_entry: OK
[   27.940383] Testing event netif_rx_entry: OK
[   27.953732] Testing event netif_receive_skb_entry: OK
[   27.967173] Testing event napi_gro_receive_entry: OK
[   27.980440] Testing event napi_gro_frags_entry: OK
[   27.993776] Testing event netif_rx: OK
[   28.007058] Testing event netif_receive_skb: OK
[   28.020529] Testing event net_dev_queue: OK
[   28.033781] Testing event net_dev_xmit: OK
[   28.047174] Testing event net_dev_start_xmit: OK
[   28.060489] Testing event skb_copy_datagram_iovec: OK
[   28.084973] Testing event consume_skb: OK
[   28.101599] Testing event kfree_skb: OK
[   28.207296] Running tests on trace event systems:
[   28.207926] Testing event system skb: OK
[   28.253032] Testing event system net: OK
[   28.286121] Testing event system napi: OK
[   28.301547] Testing event system sock: OK
[   28.313841] Testing event system udp: OK
[   28.347020] Testing event system asoc: OK
[   28.385329] Testing event system v4l2: OK
[   28.401565] Testing event system i2c: OK
[   28.414243] Testing event system spi: OK
[   28.493089] Testing event system target: OK
[   28.517114] Testing event system scsi: OK
[   28.541061] Testing event system fence: OK
[   28.574044] Testing event system regmap: OK
[   28.605292] Testing event system drm: OK
[   28.634975] Testing event system random: OK
[   28.724176] Testing event system regulator: OK
[   28.756485] Testing event system gpio: OK
[   28.777215] Testing event system swiotlb: OK
[   28.804696] Testing event system block: OK
[   28.833849] Testing event system gfs2: OK
[   28.875198] Testing event system btrfs: OK
[   28.925536] Testing event system ocfs2: OK
[   29.038475] Testing event system jbd2: OK
[   29.094457] Testing event system jbd: OK
[   29.116469] Testing event system ext3: OK
[   29.185327] Testing event system writeback: OK
[   29.261222] Testing event system migrate: OK
[   29.285149] Testing event system compaction: OK
[   29.348726] Testing event system kmem: OK
[   29.372623] Testing event system vmscan: OK
[   29.395739] Testing event system pagemap: OK
[   29.417980] Testing event system oom: OK
[   29.440670] Testing event system filemap: OK
[   29.463557] Testing event system power: OK
[   29.508635] Testing event system test: OK
[   29.529586] Testing event system timer: OK
[   29.559193] Testing event system rcu: OK
[   29.596009] Testing event system printk: OK
[   29.628977] Testing event system lock: OK
[   29.656569] Testing event system sched: OK
[   29.729773] Testing event system workqueue: OK
[   29.811834] Testing event system signal: OK
[   29.905918] Testing event system irq: OK
[   30.014081] Testing event system task: OK
[   30.117125] Testing event system exceptions: OK
[   30.218071] Testing event system tlb: OK
[   30.473091] Testing event system mce: OK
[   30.577122] Testing event system raw_syscalls: OK
[   30.684110] Testing event system vsyscall: OK
[   30.760099] Testing event system nmi: OK
[   30.844068] Testing event system irq_vectors: OK
[   31.193089] Running tests on all trace events:
[   31.193741] Testing all events: OK
[   32.437891] Running tests again, along with the function tracer
[   32.438962] Running tests on trace events:
[   32.439686] Testing event thermal_apic_exit: OK
[   32.464067] Testing event thermal_apic_entry: OK
[   32.491676] Testing event threshold_apic_exit: OK
[   32.514233] Testing event threshold_apic_entry: OK
[   32.541789] Testing event call_function_single_exit: OK
[   32.573924] Testing event call_function_single_entry: OK
[   32.603964] Testing event call_function_exit: OK
[   32.641785] Testing event call_function_entry: OK
[   32.667674] Testing event irq_work_exit: OK
[   32.697613] Testing event irq_work_entry: OK
[   32.729605] Testing event x86_platform_ipi_exit: OK
[   32.750988] Testing event x86_platform_ipi_entry: OK
[   32.791711] Testing event error_apic_exit: OK
[   32.812964] Testing event error_apic_entry: OK
[   32.832903] Testing event spurious_apic_exit: OK
[   32.852906] Testing event spurious_apic_entry: OK
[   32.879515] Testing event reschedule_exit: OK
[   32.899344] Testing event reschedule_entry: OK
[   32.914283] Testing event local_timer_exit: OK
[   32.953180] Testing event local_timer_entry: OK
[   32.975028] Testing event nmi_handler: OK
[   32.990936] Testing event emulate_vsyscall: OK
[   33.016300] Testing event sys_exit: OK
[   33.126041] Testing event sys_enter: OK
[   33.456031] Testing event mce_record: OK
[   33.766061] Testing event tlb_flush: OK
[   33.962140] Testing event page_fault_kernel: OK
[   33.982835] Testing event page_fault_user: OK
[   33.997589] Testing event task_rename: OK
[   34.014247] Testing event task_newtask: OK
[   34.032849] Testing event softirq_raise: OK
[   34.049626] Testing event softirq_exit: OK
[   34.203101] Testing event softirq_entry: OK
[   34.217666] Testing event irq_handler_exit: OK
[   34.247739] Testing event irq_handler_entry: OK
[   34.271085] Testing event signal_deliver: OK
[   34.296839] Testing event signal_generate: OK
[   34.486133] Testing event workqueue_execute_end: OK
[   34.806080] Testing event workqueue_execute_start: OK
[   34.986123] Testing event workqueue_activate_work: OK
[   35.065610] Testing event workqueue_queue_work: OK
[   35.141304] Testing event sched_wake_idle_without_ipi: OK
[   35.270181] Testing event sched_swap_numa: OK
[   35.324490] Testing event sched_stick_numa: OK
[   35.391012] Testing event sched_move_numa: OK
[   35.443996] Testing event sched_process_hang: OK
[   35.580379] Testing event sched_pi_setprio: OK
[   35.653785] Testing event sched_stat_runtime: OK
[   35.690941] Testing event sched_stat_blocked: OK
[   35.704145] Testing event sched_stat_iowait: OK
[   35.724160] Testing event sched_stat_sleep: OK
[   35.740980] Testing event sched_stat_wait: OK
[   35.764257] Testing event sched_process_exec: OK
[   35.797001] Testing event sched_process_fork: OK
[   35.817038] Testing event sched_process_wait: OK
[   35.837468] Testing event sched_wait_task: OK
[   35.857848] Testing event sched_process_exit: OK
[   35.907441] Testing event sched_process_free: OK
[   35.976107] Testing event sched_migrate_task: OK
[   36.127428] Testing event sched_switch: OK
[   36.176999] Testing event sched_wakeup_new: OK
[   36.207267] Testing event sched_wakeup: OK
[   36.264739] Testing event sched_kthread_stop_ret: OK
[   36.308787] Testing event sched_kthread_stop: OK
[   36.360314] Testing event lock_acquired: OK
[   36.407469] Testing event lock_contended: OK
[   36.454629] Testing event lock_release: OK
[   36.487931] Testing event lock_acquire: OK
[   36.540892] Testing event console: OK
[   36.585381] Testing event rcu_utilization: OK
[   36.670590] Testing event itimer_expire: OK
[   36.717665] Testing event itimer_state: OK
[   36.771940] Testing event hrtimer_cancel: OK
[   36.811477] Testing event hrtimer_expire_exit: OK
[   36.850774] Testing event hrtimer_expire_entry: OK
[   36.907769] Testing event hrtimer_start: OK
[   36.942419] Testing event hrtimer_init: OK
[   36.977276] Testing event timer_cancel: OK
[   37.019701] Testing event timer_expire_exit: OK
[   37.037602] Testing event timer_expire_entry: OK
[   37.050830] Testing event timer_start: OK
[   37.104412] Testing event timer_init: OK
[   37.147768] Testing event ftrace_test_filter: OK
[   37.206312] Testing event dev_pm_qos_remove_request: OK
[   37.220929] Testing event dev_pm_qos_update_request: OK
[   37.235281] Testing event dev_pm_qos_add_request: OK
[   37.251221] Testing event pm_qos_update_flags: OK
[   37.264183] Testing event pm_qos_update_target: OK
[   37.278853] Testing event pm_qos_update_request_timeout: OK
[   37.294196] Testing event pm_qos_remove_request: OK
[   37.307523] Testing event pm_qos_update_request: OK
[   37.346484] Testing event pm_qos_add_request: OK
[   37.386973] Testing event power_domain_target: OK
[   37.404096] Testing event clock_set_rate: OK
[   37.417494] Testing event clock_disable: OK
[   37.447099] Testing event clock_enable: OK
[   37.474022] Testing event wakeup_source_deactivate: OK
[   37.506393] Testing event wakeup_source_activate: OK
[   37.554900] Testing event suspend_resume: OK
[   37.777861] Testing event device_pm_callback_end: OK
[   37.830594] Testing event device_pm_callback_start: OK
[   37.878208] Testing event cpu_frequency: OK
[   37.932287] Testing event pstate_sample: OK
[   37.965323] Testing event cpu_idle: OK
[   38.023865] Testing event mm_filemap_add_to_page_cache: OK
[   38.060477] Testing event mm_filemap_delete_from_page_cache: OK
[   38.108263] Testing event oom_score_adj_update: OK
[   38.140902] Testing event mm_lru_activate: OK
[   38.197285] Testing event mm_lru_insertion: OK
[   38.306168] Testing event mm_vmscan_lru_shrink_inactive: OK
[   38.463610] Testing event mm_vmscan_writepage: OK
[   38.484292] Testing event mm_vmscan_memcg_isolate: OK
[   38.507365] Testing event mm_vmscan_lru_isolate: OK
[   38.520765] Testing event mm_shrink_slab_end: OK
[   38.534165] Testing event mm_shrink_slab_start: OK
[   38.547508] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   38.560750] Testing event mm_vmscan_memcg_reclaim_end: OK
[   38.574261] Testing event mm_vmscan_direct_reclaim_end: OK
[   38.587492] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   38.600854] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   38.614101] Testing event mm_vmscan_direct_reclaim_begin: OK
[   38.654443] Testing event mm_vmscan_wakeup_kswapd: OK
[   38.714215] Testing event mm_vmscan_kswapd_wake: OK
[   38.782899] Testing event mm_vmscan_kswapd_sleep: OK
[   38.833465] Testing event mm_page_alloc_extfrag: OK
[   38.867355] Testing event mm_page_pcpu_drain: OK
[   38.888677] Testing event mm_page_alloc_zone_locked: OK
[   38.913892] Testing event mm_page_alloc: OK
[   38.953831] Testing event mm_page_free_batched: OK
[   38.997629] Testing event mm_page_free: OK
[   39.057554] Testing event kmem_cache_free: OK
[   39.100277] Testing event kfree: OK
[   39.153271] Testing event kmem_cache_alloc_node: OK
[   39.217231] Testing event kmalloc_node: OK
[   39.230907] Testing event kmem_cache_alloc: OK
[   39.276817] Testing event kmalloc: OK
[   39.291172] Testing event mm_compaction_end: OK
[   39.304199] Testing event mm_compaction_begin: OK
[   39.317594] Testing event mm_compaction_migratepages: OK
[   39.330864] Testing event mm_compaction_isolate_freepages: OK
[   39.344171] Testing event mm_compaction_isolate_migratepages: OK
[   39.360789] Testing event mm_numa_migrate_ratelimit: OK
[   39.374059] Testing event mm_migrate_pages: OK
[   39.387634] Testing event writeback_single_inode: OK
[   39.400977] Testing event writeback_single_inode_start: OK
[   39.414221] Testing event writeback_wait_iff_congested: OK
[   39.427522] Testing event writeback_congestion_wait: OK
[   39.440832] Testing event writeback_sb_inodes_requeue: OK
[   39.454206] Testing event balance_dirty_pages: OK
[   39.467755] Testing event bdi_dirty_ratelimit: OK
[   39.480839] Testing event global_dirty_state: OK
[   39.517656] Testing event writeback_queue_io: OK
[   39.575590] Testing event wbc_writepage: OK
[   39.627139] Testing event writeback_bdi_unregister: OK
[   39.737204] Testing event writeback_bdi_register: OK
[   39.790868] Testing event writeback_wake_background: OK
[   39.804375] Testing event writeback_nowork: OK
[   39.817635] Testing event writeback_pages_written: OK
[   39.831056] Testing event writeback_wait: OK
[   39.844278] Testing event writeback_written: OK
[   39.860947] Testing event writeback_start: OK
[   39.874309] Testing event writeback_exec: OK
[   39.887686] Testing event writeback_queue: OK
[   39.900970] Testing event writeback_write_inode: OK
[   39.917573] Testing event writeback_write_inode_start: OK
[   40.016752] Testing event writeback_dirty_inode: OK
[   40.030860] Testing event writeback_dirty_inode_start: OK
[   40.044262] Testing event writeback_dirty_page: OK
[   40.060920] Testing event ext3_load_inode: OK
[   40.074299] Testing event ext3_get_blocks_exit: OK
[   40.090959] Testing event ext3_get_blocks_enter: OK
[   40.146734] Testing event ext3_truncate_exit: OK
[   40.160995] Testing event ext3_truncate_enter: OK
[   40.174237] Testing event ext3_unlink_exit: OK
[   40.187550] Testing event ext3_unlink_enter: OK
[   40.200877] Testing event ext3_direct_IO_exit: OK
[   40.214214] Testing event ext3_direct_IO_enter: OK
[   40.227546] Testing event ext3_read_block_bitmap: OK
[   40.240993] Testing event ext3_forget: OK
[   40.254277] Testing event ext3_reserved: OK
[   40.267591] Testing event ext3_alloc_new_reservation: OK
[   40.280924] Testing event ext3_discard_reservation: OK
[   40.294268] Testing event ext3_rsv_window_add: OK
[   40.307605] Testing event ext3_sync_fs: OK
[   40.320926] Testing event ext3_sync_file_exit: OK
[   40.334279] Testing event ext3_sync_file_enter: OK
[   40.347556] Testing event ext3_free_blocks: OK
[   40.360997] Testing event ext3_allocate_blocks: OK
[   40.380931] Testing event ext3_request_blocks: OK
[   40.394225] Testing event ext3_discard_blocks: OK
[   40.407578] Testing event ext3_invalidatepage: OK
[   40.420875] Testing event ext3_releasepage: OK
[   40.434215] Testing event ext3_readpage: OK
[   40.447547] Testing event ext3_journalled_writepage: OK
[   40.460910] Testing event ext3_writeback_writepage: OK
[   40.474199] Testing event ext3_ordered_writepage: OK
[   40.487586] Testing event ext3_journalled_write_end: OK
[   40.500866] Testing event ext3_writeback_write_end: OK
[   40.514261] Testing event ext3_ordered_write_end: OK
[   40.527601] Testing event ext3_write_begin: OK
[   40.540863] Testing event ext3_mark_inode_dirty: OK
[   40.554236] Testing event ext3_drop_inode: OK
[   40.567537] Testing event ext3_evict_inode: OK
[   40.580965] Testing event ext3_allocate_inode: OK
[   40.594243] Testing event ext3_request_inode: OK
[   40.607584] Testing event ext3_free_inode: OK
[   40.620914] Testing event journal_write_superblock: OK
[   40.634261] Testing event jbd_cleanup_journal_tail: OK
[   40.647579] Testing event jbd_do_submit_data: OK
[   40.661160] Testing event jbd_end_commit: OK
[   40.674290] Testing event jbd_drop_transaction: OK
[   40.690978] Testing event jbd_commit_logging: OK
[   40.704317] Testing event jbd_commit_flushing: OK
[   40.717601] Testing event jbd_commit_locking: OK
[   40.754298] Testing event jbd_start_commit: OK
[   40.810392] Testing event jbd_checkpoint: OK
[   40.935051] Testing event jbd2_lock_buffer_stall: OK
[   40.950883] Testing event jbd2_write_superblock: OK
[   40.964197] Testing event jbd2_update_log_tail: OK
[   40.980955] Testing event jbd2_checkpoint_stats: OK
[   40.994272] Testing event jbd2_run_stats: OK
[   41.008238] Testing event jbd2_handle_stats: OK
[   41.024221] Testing event jbd2_handle_extend: OK
[   41.038219] Testing event jbd2_handle_start: OK
[   41.054341] Testing event jbd2_submit_inode_data: OK
[   41.067638] Testing event jbd2_end_commit: OK
[   41.080929] Testing event jbd2_drop_transaction: OK
[   41.095234] Testing event jbd2_commit_logging: OK
[   41.114631] Testing event jbd2_commit_flushing: OK
[   41.141627] Testing event jbd2_commit_locking: OK
[   41.165234] Testing event jbd2_start_commit: OK
[   41.186744] Testing event jbd2_checkpoint: OK
[   41.205138] Testing event ocfs2_remove_block_from_cache: OK
[   41.221959] Testing event ocfs2_remove_metadata_tree: OK
[   41.248719] Testing event ocfs2_remove_metadata_array: OK
[   41.282341] Testing event ocfs2_set_buffer_uptodate_begin: OK
[   41.306939] Testing event ocfs2_set_buffer_uptodate: OK
[   41.335802] Testing event ocfs2_expand_cache: OK
[   41.356049] Testing event ocfs2_insert_cache_tree: OK
[   41.375584] Testing event ocfs2_append_cache_array: OK
[   41.395385] Testing event ocfs2_buffer_cached_end: OK
[   41.415362] Testing event ocfs2_buffer_cached_begin: OK
[   41.435583] Testing event ocfs2_metadata_cache_purge: OK
[   41.455378] Testing event ocfs2_purge_copied_metadata_tree: OK
[   41.479241] Testing event ocfs2_read_blocks_begin: OK
[   41.503733] Testing event ocfs2_write_block: OK
[   41.528320] Testing event ocfs2_read_blocks_end: OK
[   41.563982] Testing event ocfs2_read_blocks_bh: OK
[   41.582387] Testing event ocfs2_read_blocks_from_disk: OK
[   41.604478] Testing event ocfs2_read_blocks_sync_jbd: OK
[   41.626281] Testing event ocfs2_read_blocks_sync: OK
[   41.667315] Testing event ocfs2_wait_on_mount: OK
[   41.699090] Testing event ocfs2_recover_orphans_iput: OK
[   41.726637] Testing event ocfs2_recover_orphans: OK
[   41.751760] Testing event ocfs2_orphan_filldir: OK
[   41.808514] Testing event ocfs2_queue_orphan_scan_end: OK
[   41.835793] Testing event ocfs2_queue_orphan_scan_begin: OK
[   41.872536] Testing event ocfs2_mark_dead_nodes: OK
[   41.898379] Testing event ocfs2_recover_node_skip: OK
[   41.937677] Testing event ocfs2_recover_node: OK
[   41.975289] Testing event ocfs2_replay_journal_skip: OK
[   42.003138] Testing event ocfs2_replay_journal_lock_err: OK
[   42.098993] Testing event ocfs2_replay_journal_recovered: OK
[   42.122822] Testing event ocfs2_recovery_thread: OK
[   42.159405] Testing event ocfs2_recovery_thread_end: OK
[   42.203902] Testing event ocfs2_recovery_thread_node: OK
[   42.237471] Testing event ocfs2_complete_recovery_slot: OK
[   42.267909] Testing event ocfs2_complete_recovery_end: OK
[   42.294334] Testing event ocfs2_complete_recovery: OK
[   42.330366] Testing event ocfs2_journal_shutdown_wait: OK
[   42.373089] Testing event ocfs2_journal_shutdown: OK
[   42.439817] Testing event ocfs2_journal_init_maxlen: OK
[   42.462119] Testing event ocfs2_journal_init: OK
[   42.497138] Testing event ocfs2_journal_dirty: OK
[   42.532671] Testing event ocfs2_journal_access: OK
[   42.555786] Testing event ocfs2_allocate_extend_trans: OK
[   42.578609] Testing event ocfs2_extend_trans_restart: OK
[   42.605397] Testing event ocfs2_extend_trans: OK
[   42.645804] Testing event ocfs2_commit_cache_end: OK
[   42.673597] Testing event ocfs2_commit_cache_begin: OK
[   42.705910] Testing event ocfs2_encode_fh_type: OK
[   42.735490] Testing event ocfs2_encode_fh_parent: OK
[   42.772144] Testing event ocfs2_encode_fh_self: OK
[   42.811977] Testing event ocfs2_encode_fh_begin: OK
[   42.840742] Testing event ocfs2_get_parent_end: OK
[   42.899386] Testing event ocfs2_get_parent: OK
[   42.951166] Testing event ocfs2_get_dentry_end: OK
[   42.993657] Testing event ocfs2_get_dentry_generation: OK
[   43.052484] Testing event ocfs2_get_dentry_stale: OK
[   43.094711] Testing event ocfs2_get_dentry_test_bit: OK
[   43.129339] Testing event ocfs2_get_dentry_begin: OK
[   43.172379] Testing event ocfs2_dentry_attach_lock_found: OK
[   43.208410] Testing event ocfs2_dentry_attach_lock: OK
[   43.254419] Testing event ocfs2_find_local_alias: OK
[   43.311414] Testing event ocfs2_dentry_revalidate_ret: OK
[   43.358823] Testing event ocfs2_dentry_revalidate_nofsdata: OK
[   43.391077] Testing event ocfs2_dentry_revalidate_orphaned: OK
[   43.428195] Testing event ocfs2_dentry_revalidate_delete: OK
[   43.474175] Testing event ocfs2_dentry_revalidate_negative: OK
[   43.519889] Testing event ocfs2_dentry_revalidate: OK
[   43.563768] Testing event ocfs2_orphan_del: OK
[   43.614626] Testing event ocfs2_orphan_add_end: OK
[   43.673455] Testing event ocfs2_orphan_add_begin: OK
[   43.722223] Testing event ocfs2_blkno_stringify: OK
[   43.768499] Testing event ocfs2_symlink_begin: OK
[   43.814816] Testing event ocfs2_create_symlink_data: OK
[   43.857854] Testing event ocfs2_rename_over_existing: OK
[   43.908970] Testing event ocfs2_rename_disagree: OK
[   43.954216] Testing event ocfs2_rename_target_exists: OK
[   44.007041] Testing event ocfs2_rename_not_permitted: OK
[   44.036196] Testing event ocfs2_rename: OK
[   44.078799] Testing event ocfs2_double_lock_end: OK
[   44.118616] Testing event ocfs2_double_lock: OK
[   44.146982] Testing event ocfs2_unlink_noent: OK
[   44.194185] Testing event ocfs2_link: OK
[   44.219150] Testing event ocfs2_mknod: OK
[   44.297596] Testing event ocfs2_lookup_ret: OK
[   44.315631] Testing event ocfs2_mv_orphaned_inode_to_new: OK
[   44.344622] Testing event ocfs2_symlink_create: OK
[   44.369978] Testing event ocfs2_unlink: OK
[   44.395312] Testing event ocfs2_create: OK
[   44.421408] Testing event ocfs2_mkdir: OK
[   44.445370] Testing event ocfs2_lookup: OK
[   44.502041] Testing event ocfs2_prepare_dir_for_insert: OK
[   44.557577] Testing event ocfs2_dx_dir_rebalance_split: OK
[   44.587628] Testing event ocfs2_dx_dir_rebalance: OK
[   44.608283] Testing event ocfs2_extend_dir: OK
[   44.630606] Testing event ocfs2_dx_dir_index_root_block: OK
[   44.661314] Testing event ocfs2_dx_dir_format_cluster: OK
[   44.695733] Testing event ocfs2_dx_dir_attach_index: OK
[   44.721343] Testing event ocfs2_check_dir_for_entry: OK
[   44.747833] Testing event ocfs2_find_files_on_disk: OK
[   44.765572] Testing event ocfs2_readdir: OK
[   44.781801] Testing event ocfs2_delete_entry_dx: OK
[   44.806372] Testing event ocfs2_dx_dir_search_leaf_info: OK
[   44.825488] Testing event ocfs2_dx_dir_search: OK
[   44.926916] Testing event ocfs2_find_entry_el: OK
[   44.955441] Testing event ocfs2_validate_dir_block: OK
[   44.974177] Testing event ocfs2_search_dirblock: OK
[   44.991258] Testing event ocfs2_mark_dquot_dirty: OK
[   45.017930] Testing event ocfs2_acquire_dquot: OK
[   45.035708] Testing event ocfs2_release_dquot: OK
[   45.051838] Testing event ocfs2_write_dquot: OK
[   45.076470] Testing event ocfs2_sync_dquot_helper: OK
[   45.103711] Testing event ocfs2_sync_dquot: OK
[   45.125315] Testing event ocfs2_validate_quota_block: OK
[   45.146967] Testing event olq_set_dquot: OK
[   45.165992] Testing event ocfs2_finish_quota_recovery: OK
[   45.185593] Testing event ocfs2_recover_local_quota_file: OK
[   45.208014] Testing event ocfs2_resmap_claimed_bits_end: OK
[   45.225402] Testing event ocfs2_resmap_claimed_bits_begin: OK
[   45.257809] Testing event ocfs2_resmap_resv_bits: OK
[   45.320632] Testing event ocfs2_cannibalize_resv_end: OK
[   45.347499] Testing event ocfs2_cannibalize_resv_begin: OK
[   45.404011] Testing event ocfs2_resv_find_window_next: OK
[   45.438987] Testing event ocfs2_resv_find_window_prev: OK
[   45.520892] Testing event ocfs2_resv_find_window_begin: OK
[   45.623691] Testing event ocfs2_resmap_find_free_bits_end: OK
[   45.664806] Testing event ocfs2_resmap_find_free_bits_begin: OK
[   45.720953] Testing event ocfs2_resv_insert: OK
[   45.771788] Testing event ocfs2_reflink_xattr_rec: OK
[   45.810656] Testing event ocfs2_reflink_xattr_buckets: OK
[   45.857522] Testing event ocfs2_xattr_bucket_value_refcount: OK
[   45.907478] Testing event ocfs2_xattr_set_entry_index_block: OK
[   45.989098] Testing event ocfs2_xattr_set_entry_bucket: OK
[   46.112973] Testing event ocfs2_create_empty_xattr_block: OK
[   46.148082] Testing event ocfs2_reflink_xattr_header: OK
[   46.168501] Testing event ocfs2_rm_xattr_cluster: OK
[   46.204931] Testing event ocfs2_xattr_bucket_value_truncate: OK
[   46.227049] Testing event ocfs2_add_new_xattr_bucket: OK
[   46.306337] Testing event ocfs2_extend_xattr_bucket: OK
[   46.334143] Testing event ocfs2_add_new_xattr_cluster_insert: OK
[   46.370355] Testing event ocfs2_add_new_xattr_cluster: OK
[   46.407471] Testing event ocfs2_add_new_xattr_cluster_begin: OK
[   46.428804] Testing event ocfs2_adjust_xattr_cross_cluster: OK
[   46.449329] Testing event ocfs2_mv_xattr_buckets: OK
[   46.478240] Testing event ocfs2_cp_xattr_bucket: OK
[   46.498818] Testing event ocfs2_divide_xattr_bucket_move: OK
[   46.514954] Testing event ocfs2_divide_xattr_bucket_begin: OK
[   46.547664] Testing event ocfs2_mv_xattr_bucket_cross_cluster: OK
[   46.565224] Testing event ocfs2_defrag_xattr_bucket: OK
[   46.584231] Testing event ocfs2_xattr_create_index_block: OK
[   46.605555] Testing event ocfs2_xattr_create_index_block_begin: OK
[   46.624857] Testing event ocfs2_cp_xattr_block_to_bucket_end: OK
[   46.645150] Testing event ocfs2_cp_xattr_block_to_bucket_begin: OK
[   46.664664] Testing event ocfs2_iterate_xattr_bucket: OK
[   46.684829] Testing event ocfs2_iterate_xattr_buckets: OK
[   46.701974] Testing event ocfs2_xattr_index_block_find_rec: OK
[   46.722548] Testing event ocfs2_xattr_index_block_find: OK
[   46.741354] Testing event ocfs2_xattr_bucket_find: OK
[   46.760759] Testing event ocfs2_init_xattr_set_ctxt: OK
[   46.781154] Testing event ocfs2_xattr_extend_allocation: OK
[   46.807528] Testing event ocfs2_validate_xattr_block: OK
[   46.828505] Testing event ocfs2_initialize_super: OK
[   46.848776] Testing event ocfs2_dismount_volume: OK
[   46.867835] Testing event ocfs2_statfs: OK
[   46.884988] Testing event ocfs2_put_super: OK
[   46.905051] Testing event ocfs2_parse_options: OK
[   46.953847] Testing event ocfs2_fill_super: OK
[   47.022522] Testing event ocfs2_remount: OK
[   47.037963] Testing event ocfs2_do_node_down: OK
[   47.054188] Testing event ocfs2_find_slot: OK
[   47.072407] Testing event ocfs2_map_slot_buffers_block: OK
[   47.088214] Testing event ocfs2_map_slot_buffers: OK
[   47.104855] Testing event ocfs2_refresh_slot_info: OK
[   47.135160] Testing event ocfs2_read_virt_blocks: OK
[   47.214059] Testing event ocfs2_mark_inode_dirty: OK
[   47.259034] Testing event ocfs2_inode_revalidate: OK
[   47.329974] Testing event ocfs2_drop_inode: OK
[   47.457560] Testing event ocfs2_clear_inode: OK
[   47.488289] Testing event ocfs2_delete_inode: OK
[   47.522652] Testing event ocfs2_cleanup_delete_inode: OK
[   47.614289] Testing event ocfs2_query_inode_wipe_end: OK
[   47.668991] Testing event ocfs2_query_inode_wipe_succ: OK
[   47.713567] Testing event ocfs2_query_inode_wipe_begin: OK
[   47.763983] Testing event ocfs2_inode_is_valid_to_delete: OK
[   47.856923] Testing event ocfs2_validate_inode_block: OK
[   47.956287] Testing event ocfs2_check_orphan_recovery_state: OK
[   48.009845] Testing event ocfs2_read_locked_inode: OK
[   48.052430] Testing event ocfs2_populate_inode: OK
[   48.070950] Testing event ocfs2_find_actor: OK
[   48.084259] Testing event ocfs2_iget_end: OK
[   48.097508] Testing event ocfs2_iget5_locked: OK
[   48.111008] Testing event ocfs2_iget_begin: OK
[   48.124258] Testing event generic_file_aio_read_ret: OK
[   48.137746] Testing event ocfs2_prepare_inode_for_write: OK
[   48.150955] Testing event ocfs2_remove_inode_range: OK
[   48.164325] Testing event ocfs2_zero_partial_clusters_range2: OK
[   48.180904] Testing event ocfs2_zero_partial_clusters_range1: OK
[   48.195126] Testing event ocfs2_zero_partial_clusters: OK
[   48.210843] Testing event ocfs2_write_remove_suid: OK
[   48.224199] Testing event ocfs2_setattr: OK
[   48.237595] Testing event ocfs2_zero_extend: OK
[   48.250939] Testing event ocfs2_zero_extend_range: OK
[   48.300339] Testing event ocfs2_write_zero_page: OK
[   48.471130] Testing event ocfs2_extend_allocation_end: OK
[   48.577695] Testing event ocfs2_extend_allocation: OK
[   48.644357] Testing event ocfs2_truncate_file_error: OK
[   48.692096] Testing event ocfs2_truncate_file: OK
[   48.735838] Testing event ocfs2_file_aio_read: OK
[   48.788704] Testing event ocfs2_file_splice_read: OK
[   48.846031] Testing event ocfs2_file_splice_write: OK
[   48.864189] Testing event ocfs2_file_aio_write: OK
[   48.877599] Testing event ocfs2_sync_file: OK
[   48.907576] Testing event ocfs2_file_release: OK
[   48.924217] Testing event ocfs2_file_open: OK
[   48.968231] Testing event ocfs2_fault: OK
[   48.980854] Testing event ocfs2_write_end_inline: OK
[   49.000930] Testing event ocfs2_write_begin_nolock: OK
[   49.020862] Testing event ocfs2_try_to_write_inline_data: OK
[   49.040846] Testing event ocfs2_bmap: OK
[   49.098308] Testing event ocfs2_writepage: OK
[   49.160551] Testing event ocfs2_readpage: OK
[   49.203851] Testing event ocfs2_get_block_end: OK
[   49.257007] Testing event ocfs2_get_block: OK
[   49.277511] Testing event ocfs2_symlink_get_block: OK
[   49.294259] Testing event ocfs2_refcount_cow_hunk: OK
[   49.320680] Testing event ocfs2_make_clusters_writable: OK
[   49.334256] Testing event ocfs2_replace_clusters: OK
[   49.350950] Testing event ocfs2_clear_ext_refcount: OK
[   49.367487] Testing event ocfs2_duplicate_clusters_by_jbd: OK
[   49.418086] Testing event ocfs2_duplicate_clusters_by_page: OK
[   49.454451] Testing event ocfs2_lock_refcount_allocators: OK
[   49.553593] Testing event ocfs2_prepare_refcount_change_for_del: OK
[   49.672224] Testing event ocfs2_add_refcount_flag: OK
[   49.754431] Testing event ocfs2_calc_refcount_meta_credits_iterate: OK
[   49.860626] Testing event ocfs2_calc_refcount_meta_credits: OK
[   49.897897] Testing event ocfs2_mark_extent_refcounted: OK
[   49.937553] Testing event ocfs2_decrease_refcount: OK
[   49.971371] Testing event ocfs2_decrease_refcount_rec: OK
[   50.019802] Testing event ocfs2_restore_refcount_block: OK
[   50.034272] Testing event ocfs2_remove_refcount_extent: OK
[   50.047640] Testing event ocfs2_increase_refcount_split: OK
[   50.060990] Testing event ocfs2_increase_refcount_insert: OK
[   50.074307] Testing event ocfs2_increase_refcount_change: OK
[   50.087775] Testing event ocfs2_increase_refcount_begin: OK
[   50.100943] Testing event ocfs2_split_refcount_rec_insert: OK
[   50.114277] Testing event ocfs2_split_refcount_rec: OK
[   50.127563] Testing event ocfs2_insert_refcount_rec: OK
[   50.140876] Testing event ocfs2_new_leaf_refcount_block: OK
[   50.154196] Testing event ocfs2_divide_leaf_refcount_block: OK
[   50.167563] Testing event ocfs2_expand_inline_ref_root: OK
[   50.180862] Testing event ocfs2_change_refcount_rec: OK
[   50.194184] Testing event ocfs2_create_refcount_tree_blkno: OK
[   50.207564] Testing event ocfs2_create_refcount_tree: OK
[   50.220962] Testing event ocfs2_purge_refcount_trees: OK
[   50.234332] Testing event ocfs2_validate_refcount_block: OK
[   50.247629] Testing event ocfs2_test_inode_bit: OK
[   50.260963] Testing event ocfs2_test_suballoc_bit: OK
[   50.274293] Testing event ocfs2_get_suballoc_slot_bit: OK
[   50.287651] Testing event ocfs2_free_clusters: OK
[   50.300977] Testing event ocfs2_free_suballoc_bits: OK
[   50.314309] Testing event ocfs2_block_group_clear_bits: OK
[   50.327672] Testing event ocfs2_claim_new_inode_at_loc: OK
[   50.347645] Testing event ocfs2_claim_suballoc_bits: OK
[   50.377625] Testing event ocfs2_search_chain_end: OK
[   50.410685] Testing event ocfs2_search_chain_succ: OK
[   50.457742] Testing event ocfs2_search_chain_begin: OK
[   50.478656] Testing event ocfs2_block_group_search_max_block: OK
[   50.517237] Testing event ocfs2_cluster_group_search_max_block: OK
[   50.536411] Testing event ocfs2_cluster_group_search_wrong_max_bits: OK
[   50.554789] Testing event ocfs2_relink_block_group: OK
[   50.572088] Testing event ocfs2_block_group_set_bits: OK
[   50.591751] Testing event ocfs2_reserve_new_inode_new_group: OK
[   50.611848] Testing event ocfs2_reserve_suballoc_bits_no_new_group: OK
[   50.631805] Testing event ocfs2_reserve_suballoc_bits_nospc: OK
[   50.648124] Testing event ocfs2_block_group_alloc: OK
[   50.665200] Testing event ocfs2_block_group_alloc_discontig: OK
[   50.681537] Testing event ocfs2_block_group_alloc_contig: OK
[   50.698208] Testing event ocfs2_validate_group_descriptor: OK
[   50.727597] Testing event ocfs2_group_add: OK
[   50.797774] Testing event ocfs2_group_extend: OK
[   50.996392] Testing event ocfs2_update_last_group_and_inode: OK
[   51.182949] Testing event ocfs2_local_alloc_new_window_result: OK
[   51.218850] Testing event ocfs2_local_alloc_new_window: OK
[   51.238435] Testing event ocfs2_sync_local_to_main_free: OK
[   51.265320] Testing event ocfs2_sync_local_to_main: OK
[   51.285242] Testing event ocfs2_local_alloc_find_clear_bits: OK
[   51.302798] Testing event ocfs2_local_alloc_find_clear_bits_search_bitma=
p: OK
[   51.321873] Testing event ocfs2_local_alloc_count_bits: OK
[   51.347510] Testing event ocfs2_reserve_local_alloc_bits: OK
[   51.422277] Testing event ocfs2_begin_local_alloc_recovery: OK
[   51.437819] Testing event ocfs2_load_local_alloc: OK
[   51.457287] Testing event ocfs2_alloc_should_use_local: OK
[   51.471118] Testing event ocfs2_la_set_sizes: OK
[   51.484425] Testing event ocfs2_trim_fs: OK
[   51.548793] Testing event ocfs2_trim_group: OK
[   51.575315] Testing event ocfs2_trim_extent: OK
[   51.601401] Testing event ocfs2_cache_block_dealloc: OK
[   51.620426] Testing event ocfs2_run_deallocs: OK
[   51.635250] Testing event ocfs2_cache_cluster_dealloc: OK
[   51.651614] Testing event ocfs2_free_cached_blocks: OK
[   51.668519] Testing event ocfs2_complete_truncate_log_recovery: OK
[   51.684989] Testing event ocfs2_truncate_log_recovery_num: OK
[   51.701730] Testing event ocfs2_begin_truncate_log_recovery: OK
[   51.718670] Testing event ocfs2_flush_truncate_log: OK
[   51.735214] Testing event ocfs2_replay_truncate_records: OK
[   51.751684] Testing event ocfs2_truncate_log_append: OK
[   51.768499] Testing event ocfs2_mark_extent_written: OK
[   51.785478] Testing event ocfs2_add_clusters_in_btree_ret: OK
[   51.801725] Testing event ocfs2_rotate_leaf: OK
[   51.818535] Testing event ocfs2_validate_extent_block: OK
[   51.835147] Testing event ocfs2_commit_truncate: OK
[   51.851741] Testing event ocfs2_remove_extent: OK
[   51.868443] Testing event ocfs2_split_extent: OK
[   51.885048] Testing event ocfs2_insert_extent: OK
[   51.901860] Testing event ocfs2_rotate_subtree: OK
[   51.918671] Testing event ocfs2_grow_tree: OK
[   51.935162] Testing event ocfs2_complete_edge_insert: OK
[   51.951747] Testing event ocfs2_num_free_extents: OK
[   51.968631] Testing event ocfs2_add_clusters_in_btree: OK
[   51.985087] Testing event ocfs2_insert_extent_start: OK
[   52.001754] Testing event ocfs2_append_rec_to_path: OK
[   52.018299] Testing event ocfs2_rotate_tree_right: OK
[   52.038865] Testing event ocfs2_adjust_rightmost_branch: OK
[   52.055038] Testing event btrfs_workqueue_destroy: OK
[   52.072177] Testing event btrfs_workqueue_alloc: OK
[   52.088673] Testing event btrfs_ordered_sched: OK
[   52.105072] Testing event btrfs_all_work_done: OK
[   52.121954] Testing event btrfs_normal_work_done: OK
[   52.138220] Testing event btrfs_work_sched: OK
[   52.155055] Testing event btrfs_work_queued: OK
[   52.171911] Testing event free_extent_state: OK
[   52.188676] Testing event alloc_extent_state: OK
[   52.205089] Testing event btrfs_setup_cluster: OK
[   52.221971] Testing event btrfs_failed_cluster_setup: OK
[   52.238542] Testing event btrfs_find_cluster: OK
[   52.255197] Testing event btrfs_reserve_extent_cluster: OK
[   52.272084] Testing event btrfs_reserve_extent: OK
[   52.288478] Testing event find_free_extent: OK
[   52.312086] Testing event btrfs_reserved_extent_free: OK
[   52.328852] Testing event btrfs_reserved_extent_alloc: OK
[   52.368969] Testing event btrfs_space_reservation: OK
[   52.397033] Testing event btrfs_cow_block: OK
[   52.418524] Testing event btrfs_chunk_free: OK
[   52.435422] Testing event btrfs_chunk_alloc: OK
[   52.458525] Testing event run_delayed_ref_head: OK
[   52.478568] Testing event add_delayed_ref_head: OK
[   52.502163] Testing event run_delayed_data_ref: OK
[   52.518354] Testing event add_delayed_data_ref: OK
[   52.535565] Testing event run_delayed_tree_ref: OK
[   52.557741] Testing event add_delayed_tree_ref: OK
[   52.585382] Testing event btrfs_sync_fs: OK
[   52.608585] Testing event btrfs_sync_file: OK
[   52.625176] Testing event btrfs_writepage_end_io_hook: OK
[   52.641799] Testing event __extent_writepage: OK
[   52.658421] Testing event btrfs_ordered_extent_put: OK
[   52.678415] Testing event btrfs_ordered_extent_start: OK
[   52.695404] Testing event btrfs_ordered_extent_remove: OK
[   52.721779] Testing event btrfs_ordered_extent_add: OK
[   52.738626] Testing event btrfs_get_extent: OK
[   52.755176] Testing event btrfs_inode_evict: OK
[   52.772126] Testing event btrfs_inode_request: OK
[   52.788572] Testing event btrfs_inode_new: OK
[   52.805237] Testing event btrfs_transaction_commit: OK
[   52.835184] Testing event gfs2_rs: OK
[   52.855478] Testing event gfs2_block_alloc: OK
[   52.872766] Testing event gfs2_bmap: OK
[   52.888784] Testing event gfs2_ail_flush: OK
[   52.905456] Testing event gfs2_log_blocks: OK
[   52.922982] Testing event gfs2_log_flush: OK
[   52.938650] Testing event gfs2_pin: OK
[   52.962007] Testing event gfs2_glock_lock_time: OK
[   52.978545] Testing event gfs2_glock_queue: OK
[   52.999846] Testing event gfs2_promote: OK
[   53.015397] Testing event gfs2_demote_rq: OK
[   53.035337] Testing event gfs2_glock_put: OK
[   53.051858] Testing event gfs2_glock_state_change: OK
[   53.068513] Testing event block_rq_remap: OK
[   53.088477] Testing event block_bio_remap: OK
[   53.107430] Testing event block_split: OK
[   53.135166] Testing event block_unplug: OK
[   53.152186] Testing event block_plug: OK
[   53.177436] Testing event block_sleeprq: OK
[   53.191951] Testing event block_getrq: OK
[   53.217402] Testing event block_bio_queue: OK
[   53.231520] Testing event block_bio_frontmerge: OK
[   53.251547] Testing event block_bio_backmerge: OK
[   53.268423] Testing event block_bio_complete: OK
[   53.291074] Testing event block_bio_bounce: OK
[   53.339950] Testing event block_rq_issue: OK
[   53.397801] Testing event block_rq_insert: OK
[   53.454580] Testing event block_rq_complete: OK
[   53.511085] Testing event block_rq_requeue: OK
[   53.548987] Testing event block_rq_abort: OK
[   53.567603] Testing event block_dirty_buffer: OK
[   53.585089] Testing event block_touch_buffer: OK
[   53.605067] Testing event swiotlb_bounced: OK
[   53.625521] Testing event gpio_value: OK
[   53.657721] Testing event gpio_direction: OK
[   53.701047] Testing event regulator_set_voltage_complete: OK
[   53.747482] Testing event regulator_set_voltage: OK
[   53.801837] Testing event regulator_disable_complete: OK
[   53.818731] Testing event regulator_disable: OK
[   53.834963] Testing event regulator_enable_complete: OK
[   53.851865] Testing event regulator_enable_delay: OK
[   53.868331] Testing event regulator_enable: OK
[   53.885813] Testing event urandom_read: OK
[   53.901967] Testing event random_read: OK
[   53.918431] Testing event extract_entropy_user: OK
[   53.934947] Testing event extract_entropy: OK
[   53.951980] Testing event get_random_bytes_arch: OK
[   53.968408] Testing event get_random_bytes: OK
[   54.006493] Testing event xfer_secondary_pool: OK
[   54.137212] Testing event add_disk_randomness: OK
[   54.223920] Testing event add_input_randomness: OK
[   54.271006] Testing event debit_entropy: OK
[   54.284359] Testing event push_to_pool: OK
[   54.297877] Testing event credit_entropy_bits: OK
[   54.310966] Testing event mix_pool_bytes_nolock: OK
[   54.324389] Testing event mix_pool_bytes: OK
[   54.337669] Testing event add_device_randomness: OK
[   54.351137] Testing event drm_vblank_event_delivered: OK
[   54.364491] Testing event drm_vblank_event_queued: OK
[   54.377744] Testing event drm_vblank_event: OK
[   54.391146] Testing event regcache_drop_region: OK
[   54.404402] Testing event regmap_async_complete_done: OK
[   54.417706] Testing event regmap_async_complete_start: OK
[   54.430966] Testing event regmap_async_io_complete: OK
[   54.444496] Testing event regmap_async_write_start: OK
[   54.457783] Testing event regmap_cache_bypass: OK
[   54.471033] Testing event regmap_cache_only: OK
[   54.484410] Testing event regcache_sync: OK
[   54.498034] Testing event regmap_hw_write_done: OK
[   54.514621] Testing event regmap_hw_write_start: OK
[   54.538038] Testing event regmap_hw_read_done: OK
[   54.586523] Testing event regmap_hw_read_start: OK
[   54.601866] Testing event regmap_reg_read_cache: OK
[   54.618296] Testing event regmap_reg_read: OK
[   54.635526] Testing event regmap_reg_write: OK
[   54.651593] Testing event fence_wait_end: OK
[   54.671744] Testing event fence_wait_start: OK
[   54.692508] Testing event fence_signaled: OK
[   54.708492] Testing event fence_enable_signal: OK
[   54.739649] Testing event fence_destroy: OK
[   54.755059] Testing event fence_init: OK
[   54.771873] Testing event fence_emit: OK
[   54.788242] Testing event fence_annotate_wait_on: OK
[   54.804938] Testing event scsi_eh_wakeup: OK
[   54.821646] Testing event scsi_dispatch_cmd_timeout: OK
[   54.845974] Testing event scsi_dispatch_cmd_done: OK
[   54.877694] Testing event scsi_dispatch_cmd_error: OK
[   54.911507] Testing event scsi_dispatch_cmd_start: OK
[   54.958124] Testing event target_cmd_complete: OK
[   55.028108] Testing event target_sequencer_start: OK
[   55.111055] Testing event spi_transfer_stop: OK
[   55.148346] Testing event spi_transfer_start: OK
[   55.165477] Testing event spi_message_done: OK
[   55.208568] Testing event spi_message_start: OK
[   55.235022] Testing event spi_message_submit: OK
[   55.264961] Testing event spi_master_busy: OK
[   55.292006] Testing event spi_master_idle: OK
[   55.321610] Testing event smbus_result: OK
[   55.348760] Testing event smbus_reply: OK
[   55.371773] Testing event smbus_read: OK
[   55.395169] Testing event smbus_write: OK
[   55.428492] Testing event i2c_result: OK
[   55.455689] Testing event i2c_reply: OK
[   55.488649] Testing event i2c_read: OK
[   55.557276] Testing event i2c_write: OK
[   55.667806] Testing event v4l2_qbuf: OK
[   55.692222] Testing event v4l2_dqbuf: OK
[   55.714250] Testing event snd_soc_cache_sync: OK
[   55.734277] Testing event snd_soc_jack_notify: OK
[   55.754196] Testing event snd_soc_jack_report: OK
[   55.770870] Testing event snd_soc_jack_irq: OK
[   55.791083] Testing event snd_soc_dapm_connected: OK
[   55.810929] Testing event snd_soc_dapm_input_path: OK
[   55.824177] Testing event snd_soc_dapm_output_path: OK
[   55.897435] Testing event snd_soc_dapm_walk_done: OK
[   55.970255] Testing event snd_soc_dapm_widget_event_done: OK
[   56.118276] Testing event snd_soc_dapm_widget_event_start: OK
[   56.179574] Testing event snd_soc_dapm_widget_power: OK
[   56.211207] Testing event snd_soc_dapm_done: OK
[   56.259536] Testing event snd_soc_dapm_start: OK
[   56.297701] Testing event snd_soc_bias_level_done: OK
[   56.337443] Testing event snd_soc_bias_level_start: OK
[   56.367582] Testing event udp_fail_queue_rcv_skb: OK
[   56.407330] Testing event sock_exceed_buf_limit: OK
[   56.507135] Testing event sock_rcvqueue_full: OK
[   56.601837] Testing event napi_poll: OK
[   56.690849] Testing event netif_rx_ni_entry: OK
[   56.737741] Testing event netif_rx_entry: OK
[   56.790129] Testing event netif_receive_skb_entry: OK
[   56.847334] Testing event napi_gro_receive_entry: OK
[   56.892039] Testing event napi_gro_frags_entry: OK
[   56.939736] Testing event netif_rx: OK
[   56.980478] Testing event netif_receive_skb: OK
[   57.029338] Testing event net_dev_queue: OK
[   57.077019] Testing event net_dev_xmit: OK
[   57.130656] Testing event net_dev_start_xmit: OK
[   57.406563] Testing event skb_copy_datagram_iovec: OK
[   57.473984] Testing event consume_skb: OK
[   57.504732] Testing event kfree_skb: OK
[   57.538093] Running tests on trace event systems:
[   57.538958] Testing event system skb: OK
[   57.575098] Testing event system net: OK
[   57.615700] Testing event system napi: OK
[   57.647695] Testing event system sock: OK
[   57.667860] Testing event system udp: OK
[   57.748010] Testing event system asoc: OK
[   57.809554] Testing event system v4l2: OK
[   57.831148] Testing event system i2c: OK
[   57.879753] Testing event system spi: OK
[   57.984085] Testing event system target: OK
[   58.011941] Testing event system scsi: OK
[   58.058054] Testing event system fence: OK
[   58.102495] Testing event system regmap: OK
[   58.168539] Testing event system drm: OK
[   58.196258] Testing event system random: OK
[   58.229975] Testing event system regulator: OK
[   58.286647] Testing event system gpio: OK
[   58.334379] Testing event system swiotlb: OK
[   58.388100] Testing event system block: OK
[   58.675244] Testing event system gfs2: OK
[   58.811612] Testing event system btrfs: OK
[   59.350133] Testing event system ocfs2: OK
[   59.710977] Testing event system jbd2: OK
[   59.729693] Testing event system jbd: OK
[   59.958898] Testing event system ext3: OK
[   60.169340] Testing event system writeback: OK
[   60.232480] Testing event system migrate: OK
[   60.270798] Testing event system compaction: OK
[   60.289633] Testing event system kmem: OK
[   60.322111] Testing event system vmscan: OK
[   60.361835] Testing event system pagemap: OK
[   60.385822] Testing event system oom: OK
[   60.422896] Testing event system filemap: OK
[   60.462333] Testing event system power: OK
[   60.536030] Testing event system test: OK
[   60.551920] Testing event system timer: OK
[   60.595498] Testing event system rcu: OK
[   60.627951] Testing event system printk: OK
[   60.645261] Testing event system lock: OK
[   60.678049] Testing event system sched: OK
[   60.715474] Testing event system workqueue: OK
[   60.740309] Testing event system signal: OK
[   60.763805] Testing event system irq: OK
[   60.793794] Testing event system task: OK
[   60.822176] Testing event system exceptions: OK
[   60.840868] Testing event system tlb: OK
[   60.887500] Testing event system mce: OK
[   60.981304] Testing event system raw_syscalls: OK
[   61.005892] Testing event system vsyscall: OK
[   61.074927] Testing event system nmi: OK
[   61.095070] Testing event system irq_vectors: OK
[   61.152128] Running tests on all trace events:
[   61.152995] Testing all events: OK
[   62.590097] Testing ftrace filter: OK
[   62.597049] kAFS: Red Hat AFS client v0.1 registering.
[   62.598086] FS-Cache: Netfs 'afs' registered for caching
[   62.610295] Btrfs loaded, debug=3Don
[   62.612448] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   62.614844] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   62.616202] EDD information not available.
[   62.617013] ALSA device list:
[   62.617459]   No soundcards found.
[   62.618835] debug: unmapping init [mem 0xffffffff83732000-0xffffffff83ab=
dfff]
[   62.625277] Write protecting the kernel read-only data: 32768k
[   62.627475] debug: unmapping init [mem 0xffff88000242c000-0xffff8800025f=
ffff]
[   62.629036] debug: unmapping init [mem 0xffff880002f7d000-0xffff880002ff=
ffff]
[   62.643630] random: init urandom read with 17 bits of entropy available
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_=
fd >=3D 0' failed.
[   62.811344] Unregister pv shared memory for cpu 1
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[   62.816088] Unregister pv shared memory for cpu 0
[   62.816806] rcu-torture: Unscheduled system shutdown detected
[   62.817787] torture thread rcu_torture_writer parking due to system shut=
down
[   62.818834] torture thread rcu_torture_cbflood parking due to system shu=
tdown
[   62.819940] torture thread rcu_torture_fakewriter parking due to system =
shutdown
[   62.821624] torture thread rcu_torture_fakewriter parking due to system =
shutdown
[   62.822808] torture thread rcu_torture_fakewriter parking due to system =
shutdown
[   62.827228] torture thread rcu_torture_fakewriter parking due to system =
shutdown

BUG: kernel boot crashed
Elapsed time: 75
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-s1-08281038/b52938be99a099b452979ed805b480337ee2df0f/vmlinuz=
-3.17.0-rc2-00062-gb52938b -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-s1-08281038/linux-devel:devel-hourly-2014082810:b52938be99a099b=
452979ed805b480337ee2df0f:bisect-linux-8/.vmlinuz-b52938be99a099b452979ed80=
5b480337ee2df0f-20140828193620-58-kbuild branch=3Dlinux-devel/devel-hourly-=
2014082810 BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-08281038/b52938be99a09=
9b452979ed805b480337ee2df0f/vmlinuz-3.17.0-rc2-00062-gb52938b drbd.minor_co=
unt=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp =
2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-r=
eboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-=
quantal-kbuild-10 -serial file:/dev/shm/kboot/serial-quantal-kbuild-10 -dae=
monize -display none -monitor null=20

--+QahgC5+KEYLbs62
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s1-08281038-8153a6bbcc340b292248b66a6db89b991fe23995-RIP:----__might_sleep+-x-43743.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgODE1M2E2Yi4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA4MjgxMCcKZ2l0IGNoZWNrb3V0IDUyYWRkY2Y5ZDY2NjlmYTQzOTM4NzYx
MGJjNjVjOTJmYTA5ODBjZWYKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDgyODEwOjUyYWRkY2Y5ZDY2NjlmYTQzOTM4NzYxMGJjNjVjOTJmYTA5ODBjZWY6Ymlz
ZWN0LWxpbnV4LTgKCjIwMTQtMDgtMjggMTA6NDY6MDQgNTJhZGRjZjlkNjY2OWZhNDM5Mzg3
NjEwYmM2NWM5MmZhMDk4MGNlZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC01
MmFkZGNmOWQ2NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgwY2VmCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC81MmFkZGNmOWQ2
NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgwY2VmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4
MTAzOC01MmFkZGNmOWQ2NjY5ZmE0MzkzODc2MTBiYzY1YzkyZmEwOTgwY2VmCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEt
Y29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgtNTJhZGRjZjlkNjY2OWZh
NDM5Mzg3NjEwYmM2NWM5MmZhMDk4MGNlZgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDgyODEwMzgvNTJhZGRjZjlkNjY2OWZhNDM5Mzg3NjEwYmM2NWM5MmZhMDk4
MGNlZi92bWxpbnV6LTMuMTcuMC1yYzIKCjIwMTQtMDgtMjggMTA6NDk6MDQgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgCTI1IFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgNTJhZGRjZjlk
NjY2OWZhNDM5Mzg3NjEwYmM2NWM5MmZhMDk4MGNlZgpnaXQgYmlzZWN0IHN0YXJ0IDgxNTNh
NmJiY2MzNDBiMjkyMjQ4YjY2YTZkYjg5Yjk5MWZlMjM5OTUgNTJhZGRjZjlkNjY2OWZhNDM5
Mzg3NjEwYmM2NWM5MmZhMDk4MGNlZiAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2Vj
dDogWyItYiIsICI4MTUzYTZiYmNjMzQwYjI5MjI0OGI2NmE2ZGI4OWI5OTFmZTIzOTk1Iiwg
Ii1nIiwgIjUyYWRkY2Y5ZDY2NjlmYTQzOTM4NzYxMGJjNjVjOTJmYTA5ODBjZWYiLCAiL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvYy9ib290LWJp
c2VjdC9saW51eC04L29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDIyMDYgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBzKQpbZmE1YjJhMGQ2MDM5
Y2Y0OTc3N2E1ZGM3MzQ4MjBiNWI0OTM1ZDU2OV0gTWVyZ2UgJ3NwaS9maXgvZHcnIGludG8g
ZGV2ZWwtaG91cmx5LTIwMTQwODI4MTAKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2Vj
dApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
czEtMDgyODEwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODI4MTA6ZmE1YjJh
MGQ2MDM5Y2Y0OTc3N2E1ZGM3MzQ4MjBiNWI0OTM1ZDU2OTpiaXNlY3QtbGludXgtOAoKMjAx
NC0wOC0yOCAxMDo0OTozNSBmYTViMmEwZDYwMzljZjQ5Nzc3YTVkYzczNDgyMGI1YjQ5MzVk
NTY5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4LWZhNWIyYTBkNjAzOWNmNDk3
NzdhNWRjNzM0ODIwYjViNDkzNWQ1NjkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2ZhNWIyYTBkNjAzOWNmNDk3NzdhNWRjNzM0
ODIwYjViNDkzNWQ1NjkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4LWZhNWIyYTBkNjAz
OWNmNDk3NzdhNWRjNzM0ODIwYjViNDkzNWQ1NjkKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA4MjgxMDM4L2ZhNWIyYTBkNjAzOWNmNDk3NzdhNWRjNzM0ODIwYjVi
NDkzNWQ1Njkvdm1saW51ei0zLjE3LjAtcmMyLXdsLWF0aC0wMTUwOC1nZmE1YjJhMAoKMjAx
NC0wOC0yOCAxMDo1MTozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyCTIyLgkyNAkyNSBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDY5OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTAgc3RlcHMpCltiYWI2Y2JjZmM5ZmY2YjBhYmIxNTA2YTZjNDJlOTM3
NjVmM2M1MTYyXSBNZXJnZSAnYXJtLXNvYy9mb3ItbmV4dCcgaW50byBkZXZlbC1ob3VybHkt
MjAxNDA4MjgxMApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOC9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA4MjgxMDpiYWI2Y2JjZmM5ZmY2YjBhYmIx
NTA2YTZjNDJlOTM3NjVmM2M1MTYyOmJpc2VjdC1saW51eC04CgoyMDE0LTA4LTI4IDEwOjU1
OjA2IGJhYjZjYmNmYzlmZjZiMGFiYjE1MDZhNmM0MmU5Mzc2NWYzYzUxNjIgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctczEtMDgyODEwMzgtYmFiNmNiY2ZjOWZmNmIwYWJiMTUwNmE2YzQyZTkz
NzY1ZjNjNTE2MgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDgyODEwMzgvYmFiNmNiY2ZjOWZmNmIwYWJiMTUwNmE2YzQyZTkzNzY1ZjNjNTE2
Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgtYmFiNmNiY2ZjOWZmNmIwYWJiMTUwNmE2
YzQyZTkzNzY1ZjNjNTE2Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctczEt
MDgyODEwMzgtYmFiNmNiY2ZjOWZmNmIwYWJiMTUwNmE2YzQyZTkzNzY1ZjNjNTE2MgprZXJu
ZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvYmFiNmNiY2ZjOWZm
NmIwYWJiMTUwNmE2YzQyZTkzNzY1ZjNjNTE2Mi92bWxpbnV6LTMuMTcuMC1yYzItd2wtYXRo
LTAxODA4LWdiYWI2Y2JjCgoyMDE0LTA4LTI4IDExOjAzOjA2IGRldGVjdGluZyBib290IHN0
YXRlIC4uCTExIFRFU1QgRkFJTFVSRQpbICAgMTkuMTc0MTQ2XSBUZXN0aW5nIGV2ZW50IHN5
c3RlbSBvY2ZzMjogClsgICA0MC4wODMzNDRdIE5NSSB3YXRjaGRvZzogQlVHOiBzb2Z0IGxv
Y2t1cCAtIENQVSMxIHN0dWNrIGZvciAyM3MhIFt0b3J0dXJlX3NsYW1fa3Q6MTE1XQpbICAg
NDAuMDgzMzQ0XSBDUFU6IDEgUElEOiAxMTUgQ29tbTogdG9ydHVyZV9zbGFtX2t0IE5vdCB0
YWludGVkIDMuMTcuMC1yYzItd2wtYXRoLTAxODA4LWdiYWI2Y2JjICMxClsgICA0MC4wODMz
NDRdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEK
WyAgIDQwLjA4MzM0NF0gdGFzazogZmZmZjg4MDAwYjM1ZDUxMCB0aTogZmZmZjg4MDAwYjIy
YzAwMCB0YXNrLnRpOiBmZmZmODgwMDBiMjJjMDAwClsgICA0MC4wODMzNDRdIFJJUDogMDAx
MDpbPGZmZmZmZmZmODExMWIwZWI+XSAgWzxmZmZmZmZmZjgxMTFiMGViPl0gX19taWdodF9z
bGVlcCsweDFiLzB4MWEwClsgICA0MC4wODMzNDRdIFJTUDogMDAwMDpmZmZmODgwMDBiMjJm
ZTEwICBFRkxBR1M6IDAwMDAwMjAyClsgICA0MC4wODMzNDRdIFJBWDogMDAwMDAwMDAwMDAw
MDAwMCBSQlg6IDAwMDAwMDAwMDAwMDAwMDAgUkNYOiAwMDAwMDAwMDAwMDAwMmEwClsgICA0
MC4wODMzNDRdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAyNzYg
UkRJOiBmZmZmZmZmZjgyZGIzZTY4ClsgICA0MC4wODMzNDRdIFJCUDogZmZmZjg4MDAwYjIy
ZmUyOCBSMDg6IDAwMDAwMDAwMDAwMDA4ZDggUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICA0
MC4wODMzNDRdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAg
UjEyOiBmZmZmODgwMDBiMjJmZGYwClsgICA0MC4wODMzNDRdIFIxMzogZmZmZjg4MDAwYjIy
ZmUxMCBSMTQ6IGZmZmZmZmZmODI0MTRiZGYgUjE1OiBmZmZmODgwMDBiMjJmZDgwClsgICA0
MC4wODMzNDRdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyNDAw
MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDQwLjA4MzM0NF0gQ1M6ICAw
MDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAgNDAuMDgz
MzQ0XSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDAzMDEyMDAwIENSNDog
MDAwMDAwMDAwMDA0MDZlMApbICAgNDAuMDgzMzQ0XSBTdGFjazoKWyAgIDQwLjA4MzM0NF0g
IGZmZmY4ODAwMGIyMmZlMjggZmZmZmZmZmY4MTIwMDllYiBmZmZmODgwMDA5NzA0YTUwIGZm
ZmY4ODAwMGIyMmZlNDgKWyAgIDQwLjA4MzM0NF0gIGZmZmZmZmZmODEyMDEyZjMgMDAwMDAw
NjMwMDAwMDAwMCBmZmZmODgwMDExNzM1YWMwIGZmZmY4ODAwMGIyMmZmNDgKWyAgIDQwLjA4
MzM0NF0gIGZmZmZmZmZmODExMDUxNjAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBiMzVk
NTEwIDAwMDAwMDAwMDAwMDAwMDAKWyAgIDQwLjA4MzM0NF0gQ2FsbCBUcmFjZToKWyAgIDQw
LjA4MzM0NF0gIFs8ZmZmZmZmZmY4MTIwMDllYj5dID8gc3R1dHRlcl93YWl0KzB4OWIvMHgx
MzAKWyAgIDQwLjA4MzM0NF0gIFs8ZmZmZmZmZmY4MTIwMTJmMz5dIHRvcnR1cmVfc2xhbV9r
dGhyZWFkKzB4ZTMvMHgxOTAKWyAgIDQwLjA4MzM0NF0gIFs8ZmZmZmZmZmY4MTEwNTE2MD5d
IGt0aHJlYWQrMHgxMzAvMHgxNjAKWyAgIDQwLjA4MzM0NF0gIFs8ZmZmZmZmZmY4MTEwNTAz
MD5dID8gX19rdGhyZWFkX3VucGFyaysweGEwLzB4YTAKWyAgIDQwLjA4MzM0NF0gIFs8ZmZm
ZmZmZmY4MjQxNjE3Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICA0MC4wODMzNDRd
ICBbPGZmZmZmZmZmODExMDUwMzA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHhhMC8weGEwClsg
ICA0MC4wODMzNDRdIENvZGU6IGE0IDAyIDAxIDVkIGMzIDBmIDFmIDAwIDViIGI4IDAxIDAw
IDAwIDAwIDVkIGMzIDBmIDFmIDQ0IDAwIDAwIDY1IDhiIDA0IDI1IGUwIGI4IDAwIDAwIDU1
IDI1IGZmIGZmIGRmIDdmIDQ4IDgzIDA1IGI1IDc2IGE0IDAyIDAxIDwzOT4gYzIgNDggODkg
ZTUgMGYgODQgMzIgMDEgMDAgMDAgODMgM2QgMDcgZWQgNjAgMDIgMDEgNzQgMTEgNDggClsg
ICA0MC4wODMzNDRdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBzb2Z0bG9ja3VwOiBo
dW5nIHRhc2tzClsgICA0MC4wODMzNDRdIENQVTogMSBQSUQ6IDExNSBDb21tOiB0b3J0dXJl
X3NsYW1fa3QgVGFpbnRlZDogRyAgICAgICAgICAgICBMIDMuMTcuMC1yYzItd2wtYXRoLTAx
ODA4LWdiYWI2Y2JjICMxClsgICA0MC4wODMzNDRdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJv
Y2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDQwLjA4MzM0NF0gIDAwMDAwMDAwMDAw
MDAwMGUgZmZmZjg4MDAxMjQwM2RmOCBmZmZmZmZmZjgyNDA2OGM0IGZmZmZmZmZmODJkYTQx
NzMKWyAgIDQwLjA4MzM0NF0gIGZmZmY4ODAwMTI0MDNlNzAgZmZmZmZmZmY4MjNmZTcwNiAw
MDAwMDAwMDAwMDAwMDA4IGZmZmY4ODAwMTI0MDNlODAKWyAgIDQwLjA4MzM0NF0gIGZmZmY4
ODAwMTI0MDNlMjAgMDAwMDAwMDAwMDAwMDAwMSAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZm
ODExNTA1NDMKWyAgIDQwLjA4MzM0NF0gQ2FsbCBUcmFjZToKWyAgIDQwLjA4MzM0NF0gIDxJ
UlE+ICBbPGZmZmZmZmZmODI0MDY4YzQ+XSBkdW1wX3N0YWNrKzB4ODUvMHhiYQpbICAgNDAu
MDgzMzQ0XSAgWzxmZmZmZmZmZjgyM2ZlNzA2Pl0gcGFuaWMrMHgxMTAvMHgzMDAKWyAgIDQw
LjA4MzM0NF0gIFs8ZmZmZmZmZmY4MTE1MDU0Mz5dID8gY29uc29sZV91bmxvY2srMHgzNzMv
MHg2ODAKWyAgIDQwLjA4MzM0NF0gIFs8ZmZmZmZmZmY4MTFhZDY2Mz5dIHdhdGNoZG9nX3Rp
bWVyX2ZuKzB4MjgzLzB4MmUwClsgICA0MC4wODMzNDRdICBbPGZmZmZmZmZmODExNzFmNDk+
XSBocnRpbWVyX3J1bl9xdWV1ZXMrMHgxNTkvMHg0NzAKWyAgIDQwLjA4MzM0NF0gIFs8ZmZm
ZmZmZmY4MTFhZDNlMD5dID8gd2F0Y2hkb2crMHg0MC8weDQwClsgICA0MC4wODMzNDRdICBb
PGZmZmZmZmZmODExNzBiOTI+XSB1cGRhdGVfcHJvY2Vzc190aW1lcysweDQyLzB4YzAKWyAg
IDQwLjA4MzM0NF0gIFs8ZmZmZmZmZmY4MTE4M2ZiOD5dIHRpY2tfcGVyaW9kaWMrMHgzOC8w
eDEzMApbICAgNDAuMDgzMzQ0XSAgWzxmZmZmZmZmZjgxMTg0MmJlPl0gdGlja19oYW5kbGVf
cGVyaW9kaWMrMHgyZS8weGIwClsgICA0MC4wODMzNDRdICBbPGZmZmZmZmZmODEyMDEyMTA+
XSA/IHRvcnR1cmVfc3R1dHRlcisweDFkMC8weDFkMApbICAgNDAuMDgzMzQ0XSAgWzxmZmZm
ZmZmZjgxMDUwY2RmPl0gbG9jYWxfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzZi8weDgwClsg
ICA0MC4wODMzNDRdICBbPGZmZmZmZmZmODI0MThkZmY+XSBzbXBfYXBpY190aW1lcl9pbnRl
cnJ1cHQrMHg1Zi8weDgwClsgICA0MC4wODMzNDRdICBbPGZmZmZmZmZmODI0MTcxZGQ+XSBh
cGljX3RpbWVyX2ludGVycnVwdCsweDZkLzB4ODAKWyAgIDQwLjA4MzM0NF0gIDxFT0k+ICBb
PGZmZmZmZmZmODExMWIwZWI+XSA/IF9fbWlnaHRfc2xlZXArMHgxYi8weDFhMApbICAgNDAu
MDgzMzQ0XSAgWzxmZmZmZmZmZjgxMjAwOWViPl0gPyBzdHV0dGVyX3dhaXQrMHg5Yi8weDEz
MApbICAgNDAuMDgzMzQ0XSAgWzxmZmZmZmZmZjgxMjAxMmYzPl0gdG9ydHVyZV9zbGFtX2t0
aHJlYWQrMHhlMy8weDE5MApbICAgNDAuMDgzMzQ0XSAgWzxmZmZmZmZmZjgxMTA1MTYwPl0g
a3RocmVhZCsweDEzMC8weDE2MApbICAgNDAuMDgzMzQ0XSAgWzxmZmZmZmZmZjgxMTA1MDMw
Pl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4YTAvMHhhMApbICAgNDAuMDgzMzQ0XSAgWzxmZmZm
ZmZmZjgyNDE2MTdjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDQwLjA4MzM0NF0g
IFs8ZmZmZmZmZmY4MTEwNTAzMD5dID8gX19rdGhyZWFkX3VucGFyaysweGEwLzB4YTAKWyAg
IDQwLjA4MzM0NF0gS2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhmZmZmZmZmZjgxMDAwMDAw
IChyZWxvY2F0aW9uIHJhbmdlOiAweGZmZmZmZmZmODAwMDAwMDAtMHhmZmZmZmZmZjlmZmZm
ZmZmKQoKRWxhcHNlZCB0aW1lOiA0NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4
MjgxMDM4L2JhYjZjYmNmYzlmZjZiMGFiYjE1MDZhNmM0MmU5Mzc2NWYzYzUxNjIvZG1lc2ct
cXVhbnRhbC1rYnVpbGQtMTA6MjAxNDA4MjgxMTAyMzg6eDg2XzY0LXJhbmRjb25maWctczEt
MDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE4MDgtZ2JhYjZjYmM6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2JhYjZjYmNmYzlmZjZiMGFiYjE1MDZhNmM0
MmU5Mzc2NWYzYzUxNjIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTI6MjAxNDA4MjgxMTAyNDE6
eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE4MDgt
Z2JhYjZjYmM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2JhYjZj
YmNmYzlmZjZiMGFiYjE1MDZhNmM0MmU5Mzc2NWYzYzUxNjIvZG1lc2ctcXVhbnRhbC1rYnVp
bGQtMTU6MjAxNDA4MjgxMTAyMzQ6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4x
Ny4wLXJjMi13bC1hdGgtMDE4MDgtZ2JhYjZjYmM6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA4MjgxMDM4L2JhYjZjYmNmYzlmZjZiMGFiYjE1MDZhNmM0MmU5Mzc2NWYzYzUx
NjIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjM6MjAxNDA4MjgxMTAyMzc6eDg2XzY0LXJhbmRj
b25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE4MDgtZ2JhYjZjYmM6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2JhYjZjYmNmYzlmZjZiMGFi
YjE1MDZhNmM0MmU5Mzc2NWYzYzUxNjIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjg6MjAxNDA4
MjgxMTAyMzg6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi13bC1h
dGgtMDE4MDgtZ2JhYjZjYmM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4Mjgx
MDM4L2JhYjZjYmNmYzlmZjZiMGFiYjE1MDZhNmM0MmU5Mzc2NWYzYzUxNjIvZG1lc2ctcXVh
bnRhbC1rYnVpbGQtMjk6MjAxNDA4MjgxMTAyNDE6eDg2XzY0LXJhbmRjb25maWctczEtMDgy
ODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE4MDgtZ2JhYjZjYmM6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2JhYjZjYmNmYzlmZjZiMGFiYjE1MDZhNmM0MmU5
Mzc2NWYzYzUxNjIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtNjoyMDE0MDgyODExMDI0MDp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzODozLjE3LjAtcmMyLXdsLWF0aC0wMTgwOC1nYmFi
NmNiYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvYmFiNmNiY2Zj
OWZmNmIwYWJiMTUwNmE2YzQyZTkzNzY1ZjNjNTE2Mi9kbWVzZy1xdWFudGFsLWtidWlsZC03
OjIwMTQwODI4MTEwMjMzOng4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1y
YzItd2wtYXRoLTAxODA4LWdiYWI2Y2JjOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wODI4MTAzOC9iYWI2Y2JjZmM5ZmY2YjBhYmIxNTA2YTZjNDJlOTM3NjVmM2M1MTYyL2Rt
ZXNnLXF1YW50YWwta2J1aWxkLTMxOjIwMTQwODI4MTEwMjQyOng4Nl82NC1yYW5kY29uZmln
LXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wtYXRoLTAxODA4LWdiYWI2Y2JjOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9iYWI2Y2JjZmM5ZmY2YjBhYmIxNTA2
YTZjNDJlOTM3NjVmM2M1MTYyL2RtZXNnLXF1YW50YWwta2J1aWxkLTU6MjAxNDA4MjgxMTAy
NDM6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE4
MDgtZ2JhYjZjYmM6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2Jh
YjZjYmNmYzlmZjZiMGFiYjE1MDZhNmM0MmU5Mzc2NWYzYzUxNjIvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtOToyMDE0MDgyODExMDI0ODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzODoz
LjE3LjAtcmMyLXdsLWF0aC0wMTgwOC1nYmFiNmNiYzoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDgyODEwMzgvYmFiNmNiY2ZjOWZmNmIwYWJiMTUwNmE2YzQyZTkzNzY1ZjNj
NTE2Mi9kbWVzZy1xdWFudGFsLWtidWlsZC0xOjIwMTQwODI4MTEwMjU2Ong4Nl82NC1yYW5k
Y29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wtYXRoLTAxODA4LWdiYWI2Y2JjOjEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9iYWI2Y2JjZmM5ZmY2YjBh
YmIxNTA2YTZjNDJlOTM3NjVmM2M1MTYyL2RtZXNnLXF1YW50YWwta2J1aWxkLTI3OjIwMTQw
ODI4MTEwMjU1Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wt
YXRoLTAxODA4LWdiYWI2Y2JjOjEKNDoxMzoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wOC0yOCAxMTowNDozNyBSRVBFQVQgQ09VTlQ6IDI4ICAjIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAz
MDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMp
Cls2MWNhOTNhYWVkZTRlNjNjODJiMWNlNjBjZGRhYjBmOTIyMjkwMTE1XSBNZXJnZSAna3Zt
YXJtL3F1ZXVlJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDgyODEwCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9s
aW51eC04L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDgyODEwOjYxY2E5M2FhZWRlNGU2M2M4MmIxY2U2MGNkZGFiMGY5MjIyOTAxMTU6Ymlz
ZWN0LWxpbnV4LTgKCjIwMTQtMDgtMjggMTE6MDQ6MzggNjFjYTkzYWFlZGU0ZTYzYzgyYjFj
ZTYwY2RkYWIwZjkyMjI5MDExNSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC02
MWNhOTNhYWVkZTRlNjNjODJiMWNlNjBjZGRhYjBmOTIyMjkwMTE1CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC82MWNhOTNhYWVk
ZTRlNjNjODJiMWNlNjBjZGRhYjBmOTIyMjkwMTE1CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4
MTAzOC02MWNhOTNhYWVkZTRlNjNjODJiMWNlNjBjZGRhYjBmOTIyMjkwMTE1Cmtlcm5lbDog
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC82MWNhOTNhYWVkZTRlNjNj
ODJiMWNlNjBjZGRhYjBmOTIyMjkwMTE1L3ZtbGludXotMy4xNy4wLXJjMi13bC1hdGgtMDE1
OTktZzYxY2E5M2EKCjIwMTQtMDgtMjggMTE6MDY6MzggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4JMi4JMjEJMjggU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMDkgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCls1Y2RlNTZkOTRmMDc2MTEwMWIy
MzVkMWM4OGM2NzQwMzRiZGQxMDFhXSBNZXJnZSAnbmV0ZGV2LW5leHQvbWFzdGVyJyBpbnRv
IGRldmVsLWhvdXJseS0yMDE0MDgyODEwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC04L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA4MjgxMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDgyODEwOjVjZGU1
NmQ5NGYwNzYxMTAxYjIzNWQxYzg4YzY3NDAzNGJkZDEwMWE6YmlzZWN0LWxpbnV4LTgKCjIw
MTQtMDgtMjggMTE6MDk6MzkgNWNkZTU2ZDk0ZjA3NjExMDFiMjM1ZDFjODhjNjc0MDM0YmRk
MTAxYSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC01Y2RlNTZkOTRmMDc2MTEw
MWIyMzVkMWM4OGM2NzQwMzRiZGQxMDFhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC81Y2RlNTZkOTRmMDc2MTEwMWIyMzVkMWM4
OGM2NzQwMzRiZGQxMDFhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC01Y2RlNTZkOTRm
MDc2MTEwMWIyMzVkMWM4OGM2NzQwMzRiZGQxMDFhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wODI4MTAzOC01Y2RlNTZkOTRmMDc2MTEwMWIyMzVkMWM4OGM2NzQw
MzRiZGQxMDFhCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAz
OC81Y2RlNTZkOTRmMDc2MTEwMWIyMzVkMWM4OGM2NzQwMzRiZGQxMDFhL3ZtbGludXotMy4x
Ny4wLXJjMi13bC1hdGgtMDE2MjUtZzVjZGU1NmQ5CgoyMDE0LTA4LTI4IDExOjE3OjM5IGRl
dGVjdGluZyBib290IHN0YXRlIC4uLi4uLgkxMgkyMQkyNC4JMjggU1VDQ0VTUwoKQmlzZWN0
aW5nOiAxODMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDgg
c3RlcHMpCltkZDdlZDI2NDNiMTczMzZkMDEwM2RkZGEyYzM4NWI1OTgxMmE0MGI4XSBNZXJn
ZSAnaGlkL2Zvci0zLjE4L3BpY29sY2QnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwODI4MTAK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwODI4MTA6ZGQ3ZWQyNjQzYjE3MzM2ZDAxMDNkZGRhMmMzODVi
NTk4MTJhNDBiODpiaXNlY3QtbGludXgtOAoKMjAxNC0wOC0yOCAxMToyMzowOSBkZDdlZDI2
NDNiMTczMzZkMDEwM2RkZGEyYzM4NWI1OTgxMmE0MGI4IGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXMxLTA4MjgxMDM4LWRkN2VkMjY0M2IxNzMzNmQwMTAzZGRkYTJjMzg1YjU5ODEyYTQwYjgK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4Mjgx
MDM4L2RkN2VkMjY0M2IxNzMzNmQwMTAzZGRkYTJjMzg1YjU5ODEyYTQwYjgKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTA4MjgxMDM4LWRkN2VkMjY0M2IxNzMzNmQwMTAzZGRkYTJjMzg1YjU5ODEy
YTQwYjgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2Rk
N2VkMjY0M2IxNzMzNmQwMTAzZGRkYTJjMzg1YjU5ODEyYTQwYjgvdm1saW51ei0zLjE3LjAt
cmMyLXdsLWF0aC0wMTYzMC1nZGQ3ZWQyNgoKMjAxNC0wOC0yOCAxMToyNToxMCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuCTUgVEVTVCBGQUlMVVJFClsgICAxMC43OTE1MjZdIFRlc3Rpbmcg
ZXZlbnQgb29tX3Njb3JlX2Fkal91cGRhdGU6IApbICAgMzIuMTE5NTE1XSBOTUkgd2F0Y2hk
b2c6IEJVRzogc29mdCBsb2NrdXAgLSBDUFUjMSBzdHVjayBmb3IgMjJzISBbdG9ydHVyZV9z
bGFtX2t0OjQ1XQpbICAgMzIuMTE5NTE1XSBDUFU6IDEgUElEOiA0NSBDb21tOiB0b3J0dXJl
X3NsYW1fa3QgTm90IHRhaW50ZWQgMy4xNy4wLXJjMi13bC1hdGgtMDE2MzAtZ2RkN2VkMjYg
IzQKWyAgIDMyLjExOTUxNV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9j
aHMgMDEvMDEvMjAxMQpbICAgMzIuMTE5NTE1XSB0YXNrOiBmZmZmODgwMDBiMmQwYTUwIHRp
OiBmZmZmODgwMDBiMmQ0MDAwIHRhc2sudGk6IGZmZmY4ODAwMGIyZDQwMDAKWyAgIDMyLjEx
OTUxNV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTExYjBkZT5dICBbPGZmZmZmZmZmODExMWIw
ZGU+XSBfX21pZ2h0X3NsZWVwKzB4ZS8weDFhMApbICAgMzIuMTE5NTE1XSBSU1A6IDAwMDA6
ZmZmZjg4MDAwYjJkN2UxMCAgRUZMQUdTOiAwMDAwMDIwNgpbICAgMzIuMTE5NTE1XSBSQVg6
IDAwMDAwMDAwODAwMDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJDWDogMDAwMDAwMDAw
MDAwMDJhMApbICAgMzIuMTE5NTE1XSBSRFg6IDAwMDAwMDAwMDAwMDAwMDAgUlNJOiAwMDAw
MDAwMDAwMDAwMjc2IFJESTogZmZmZmZmZmY4MmRiM2U2OApbICAgMzIuMTE5NTE1XSBSQlA6
IGZmZmY4ODAwMGIyZDdlMjggUjA4OiAwMDAwMDAwMDAwMDAwOGIyIFIwOTogMDAwMDAwMDAw
MDAwMDAwMApbICAgMzIuMTE5NTE1XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDAgUjExOiAwMDAw
MDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4MDAwYjJkN2RmMApbICAgMzIuMTE5NTE1XSBSMTM6
IGZmZmY4ODAwMGIyZDdlMTAgUjE0OiBmZmZmZmZmZjgyNDE0YmRmIFIxNTogZmZmZjg4MDAw
YjJkN2Q4MApbICAgMzIuMTE5NTE1XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6
ZmZmZjg4MDAxMjQwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAzMi4x
MTk1MTVdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAw
M2IKWyAgIDMyLjExOTUxNV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENSMzogMDAwMDAwMDAw
MzAxMjAwMCBDUjQ6IDAwMDAwMDAwMDAwMDA2ZTAKWyAgIDMyLjExOTUxNV0gU3RhY2s6Clsg
ICAzMi4xMTk1MTVdICBmZmZmODgwMDBiMmQ3ZTI4IGZmZmZmZmZmODEyMDA5ZWIgZmZmZjg4
MDAwYTViZDUxMCBmZmZmODgwMDBiMmQ3ZTQ4ClsgICAzMi4xMTk1MTVdICBmZmZmZmZmZjgx
MjAxMmYzIDAwMDAwMDYzMDAwMDAwMDAgZmZmZjg4MDAxMGU5MzNjMCBmZmZmODgwMDBiMmQ3
ZjQ4ClsgICAzMi4xMTk1MTVdICBmZmZmZmZmZjgxMTA1MTYwIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZjg4MDAwYjJkMGE1MCAwMDAwMDAwMDAwMDAwMDAwClsgICAzMi4xMTk1MTVdIENhbGwg
VHJhY2U6ClsgICAzMi4xMTk1MTVdICBbPGZmZmZmZmZmODEyMDA5ZWI+XSA/IHN0dXR0ZXJf
d2FpdCsweDliLzB4MTMwClsgICAzMi4xMTk1MTVdICBbPGZmZmZmZmZmODEyMDEyZjM+XSB0
b3J0dXJlX3NsYW1fa3RocmVhZCsweGUzLzB4MTkwClsgICAzMi4xMTk1MTVdICBbPGZmZmZm
ZmZmODExMDUxNjA+XSBrdGhyZWFkKzB4MTMwLzB4MTYwClsgICAzMi4xMTk1MTVdICBbPGZm
ZmZmZmZmODExMDUwMzA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHhhMC8weGEwClsgICAzMi4x
MTk1MTVdICBbPGZmZmZmZmZmODI0MTYxN2M+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApb
ICAgMzIuMTE5NTE1XSAgWzxmZmZmZmZmZjgxMTA1MDMwPl0gPyBfX2t0aHJlYWRfdW5wYXJr
KzB4YTAvMHhhMApbICAgMzIuMTE5NTE1XSBDb2RlOiA0NSA0MSA4MiA3MiAxMCA1YiAzMSBj
MCA0OCA4MyAwNSBkZCA3NSBhNCAwMiAwMSA1ZCBjMyAwZiAxZiAwMCA1YiBiOCAwMSAwMCAw
MCAwMCA1ZCBjMyAwZiAxZiA0NCAwMCAwMCA2NSA4YiAwNCAyNSBlMCBiOCAwMCAwMCA1NSA8
MjU+IGZmIGZmIGRmIDdmIDQ4IDgzIDA1IGI1IDc2IGE0IDAyIDAxIDM5IGMyIDQ4IDg5IGU1
IDBmIDg0IDMyIApbICAgMzIuMTE5NTE1XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzog
c29mdGxvY2t1cDogaHVuZyB0YXNrcwpbICAgMzIuMTE5NTE1XSBDUFU6IDEgUElEOiA0NSBD
b21tOiB0b3J0dXJlX3NsYW1fa3QgVGFpbnRlZDogRyAgICAgICAgICAgICBMIDMuMTcuMC1y
YzItd2wtYXRoLTAxNjMwLWdkZDdlZDI2ICM0ClsgICAzMi4xMTk1MTVdIEhhcmR3YXJlIG5h
bWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDMyLjExOTUxNV0g
IDAwMDAwMDAwMDAwMDAwMDcgZmZmZjg4MDAxMjQwM2RmOCBmZmZmZmZmZjgyNDA2OGM0IGZm
ZmZmZmZmODJkYTQxNzMKWyAgIDMyLjExOTUxNV0gIGZmZmY4ODAwMTI0MDNlNzAgZmZmZmZm
ZmY4MjNmZTcwNiAwMDAwMDAwMDAwMDAwMDA4IGZmZmY4ODAwMTI0MDNlODAKWyAgIDMyLjEx
OTUxNV0gIGZmZmY4ODAwMTI0MDNlMjAgMDAwMDAwMDAwMDAwMDAwMSAwMDAwMDAwMDAwMDAw
MDAwIGZmZmZmZmZmODExNTA1NDMKWyAgIDMyLjExOTUxNV0gQ2FsbCBUcmFjZToKWyAgIDMy
LjExOTUxNV0gIDxJUlE+ICBbPGZmZmZmZmZmODI0MDY4YzQ+XSBkdW1wX3N0YWNrKzB4ODUv
MHhiYQpbICAgMzIuMTE5NTE1XSAgWzxmZmZmZmZmZjgyM2ZlNzA2Pl0gcGFuaWMrMHgxMTAv
MHgzMDAKWyAgIDMyLjExOTUxNV0gIFs8ZmZmZmZmZmY4MTE1MDU0Mz5dID8gY29uc29sZV91
bmxvY2srMHgzNzMvMHg2ODAKWyAgIDMyLjExOTUxNV0gIFs8ZmZmZmZmZmY4MTFhZDY2Mz5d
IHdhdGNoZG9nX3RpbWVyX2ZuKzB4MjgzLzB4MmUwClsgICAzMi4xMTk1MTVdICBbPGZmZmZm
ZmZmODExNzFmNDk+XSBocnRpbWVyX3J1bl9xdWV1ZXMrMHgxNTkvMHg0NzAKWyAgIDMyLjEx
OTUxNV0gIFs8ZmZmZmZmZmY4MTFhZDNlMD5dID8gd2F0Y2hkb2crMHg0MC8weDQwClsgICAz
Mi4xMTk1MTVdICBbPGZmZmZmZmZmODExNzBiOTI+XSB1cGRhdGVfcHJvY2Vzc190aW1lcysw
eDQyLzB4YzAKWyAgIDMyLjExOTUxNV0gIFs8ZmZmZmZmZmY4MTE4M2ZiOD5dIHRpY2tfcGVy
aW9kaWMrMHgzOC8weDEzMApbICAgMzIuMTE5NTE1XSAgWzxmZmZmZmZmZjgxMTg0MmJlPl0g
dGlja19oYW5kbGVfcGVyaW9kaWMrMHgyZS8weGIwClsgICAzMi4xMTk1MTVdICBbPGZmZmZm
ZmZmODEyMDEyMTA+XSA/IHRvcnR1cmVfc3R1dHRlcisweDFkMC8weDFkMApbICAgMzIuMTE5
NTE1XSAgWzxmZmZmZmZmZjgxMDUwY2RmPl0gbG9jYWxfYXBpY190aW1lcl9pbnRlcnJ1cHQr
MHgzZi8weDgwClsgICAzMi4xMTk1MTVdICBbPGZmZmZmZmZmODI0MThkZmY+XSBzbXBfYXBp
Y190aW1lcl9pbnRlcnJ1cHQrMHg1Zi8weDgwClsgICAzMi4xMTk1MTVdICBbPGZmZmZmZmZm
ODI0MTcxZGQ+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDZkLzB4ODAKWyAgIDMyLjExOTUx
NV0gIDxFT0k+ICBbPGZmZmZmZmZmODExMWIwZGU+XSA/IF9fbWlnaHRfc2xlZXArMHhlLzB4
MWEwClsgICAzMi4xMTk1MTVdICBbPGZmZmZmZmZmODEyMDA5ZWI+XSA/IHN0dXR0ZXJfd2Fp
dCsweDliLzB4MTMwClsgICAzMi4xMTk1MTVdICBbPGZmZmZmZmZmODEyMDEyZjM+XSB0b3J0
dXJlX3NsYW1fa3RocmVhZCsweGUzLzB4MTkwClsgICAzMi4xMTk1MTVdICBbPGZmZmZmZmZm
ODExMDUxNjA+XSBrdGhyZWFkKzB4MTMwLzB4MTYwClsgICAzMi4xMTk1MTVdICBbPGZmZmZm
ZmZmODExMDUwMzA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHhhMC8weGEwClsgICAzMi4xMTk1
MTVdICBbPGZmZmZmZmZmODI0MTYxN2M+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAg
MzIuMTE5NTE1XSAgWzxmZmZmZmZmZjgxMTA1MDMwPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4
YTAvMHhhMApbICAgMzIuMTE5NTE1XSBLZXJuZWwgT2Zmc2V0OiAweDAgZnJvbSAweGZmZmZm
ZmZmODEwMDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4ZmZmZmZmZmY4MDAwMDAwMC0weGZm
ZmZmZmZmOWZmZmZmZmYpCgpFbGFwc2VkIHRpbWU6IDQwCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctczEtMDgyODEwMzgvZGQ3ZWQyNjQzYjE3MzM2ZDAxMDNkZGRhMmMzODViNTk4MTJh
NDBiOC9kbWVzZy1xdWFudGFsLXZwLTEyOjIwMTQwODI4MTEyNTQ1Ong4Nl82NC1yYW5kY29u
ZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wtYXRoLTAxNjMwLWdkZDdlZDI2OjQKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9kZDdlZDI2NDNiMTczMzZkMDEw
M2RkZGEyYzM4NWI1OTgxMmE0MGI4L2RtZXNnLXF1YW50YWwtdnAtMTM6MjAxNDA4MjgxMTI1
NDU6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE2
MzAtZ2RkN2VkMjY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2Rk
N2VkMjY0M2IxNzMzNmQwMTAzZGRkYTJjMzg1YjU5ODEyYTQwYjgvZG1lc2ctcXVhbnRhbC12
cC0xNToyMDE0MDgyODExMjU0Njp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzODozLjE3
LjAtcmMyLXdsLWF0aC0wMTYzMC1nZGQ3ZWQyNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDgyODEwMzgvZGQ3ZWQyNjQzYjE3MzM2ZDAxMDNkZGRhMmMzODViNTk4MTJhNDBi
OC9kbWVzZy1xdWFudGFsLXZwLTI1OjIwMTQwODI4MTEyNTQyOng4Nl82NC1yYW5kY29uZmln
LXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wtYXRoLTAxNjMwLWdkZDdlZDI2OjQKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9kZDdlZDI2NDNiMTczMzZkMDEwM2Rk
ZGEyYzM4NWI1OTgxMmE0MGI4L2RtZXNnLXF1YW50YWwtdnAtMjY6MjAxNDA4MjgxMTI1NDM6
eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE2MzAt
Z2RkN2VkMjY6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2RkN2Vk
MjY0M2IxNzMzNmQwMTAzZGRkYTJjMzg1YjU5ODEyYTQwYjgvZG1lc2ctcXVhbnRhbC12cC05
OjIwMTQwODI4MTEyNTUwOng4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1y
YzItd2wtYXRoLTAxNjMwLWdkZDdlZDI2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wODI4MTAzOC9kZDdlZDI2NDNiMTczMzZkMDEwM2RkZGEyYzM4NWI1OTgxMmE0MGI4L2Rt
ZXNnLXF1YW50YWwtdnAtMTE6MjAxNDA4MjgxMTI1NTM6eDg2XzY0LXJhbmRjb25maWctczEt
MDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE2MzAtZ2RkN2VkMjY6NAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2RkN2VkMjY0M2IxNzMzNmQwMTAzZGRkYTJj
Mzg1YjU5ODEyYTQwYjgvZG1lc2ctcXVhbnRhbC12cC0yNzoyMDE0MDgyODExMjYwMTp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzODozLjE3LjAtcmMyLXdsLWF0aC0wMTYzMC1nZGQ3
ZWQyNjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvZGQ3ZWQyNjQz
YjE3MzM2ZDAxMDNkZGRhMmMzODViNTk4MTJhNDBiOC9kbWVzZy1xdWFudGFsLXZwLTMwOjIw
MTQwODI4MTEyNTU4Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzIt
d2wtYXRoLTAxNjMwLWdkZDdlZDI2OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
ODI4MTAzOC9kZDdlZDI2NDNiMTczMzZkMDEwM2RkZGEyYzM4NWI1OTgxMmE0MGI4L2RtZXNn
LXF1YW50YWwtdnAtMzI6MjAxNDA4MjgxMTI1NTQ6eDg2XzY0LXJhbmRjb25maWctczEtMDgy
ODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDE2MzAtZ2RkN2VkMjY6NAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2RkN2VkMjY0M2IxNzMzNmQwMTAzZGRkYTJjMzg1
YjU5ODEyYTQwYjgvZG1lc2ctcXVhbnRhbC12cC02OjIwMTQwODI4MTEyNTU3Ong4Nl82NC1y
YW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wtYXRoLTAxNjMwLWdkZDdlZDI2
OjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9kZDdlZDI2NDNiMTcz
MzZkMDEwM2RkZGEyYzM4NWI1OTgxMmE0MGI4L2RtZXNnLXF1YW50YWwtdnAtMToyMDE0MDgy
ODExMjYwMzp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzODozLjE3LjAtcmMyLXdsLWF0
aC0wMTYzMC1nZGQ3ZWQyNjo0CjM6MTI6MTQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
CkJpc2VjdGluZzogNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMyBzdGVwcykKW2FhNmZlNTZjZjY5MWQwNTg3MjI5Y2I1YzIxYzQ0ODk5ZmMzMTIxMzRd
IE1lcmdlICdyY3UvcmN1L2V4cCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA4MjgxMApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgtOC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDA4MjgxMDphYTZmZTU2Y2Y2OTFkMDU4NzIyOWNiNWMyMWM0NDg5OWZj
MzEyMTM0OmJpc2VjdC1saW51eC04CgoyMDE0LTA4LTI4IDExOjI2OjExIGFhNmZlNTZjZjY5
MWQwNTg3MjI5Y2I1YzIxYzQ0ODk5ZmMzMTIxMzQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEt
MDgyODEwMzgtYWE2ZmU1NmNmNjkxZDA1ODcyMjljYjVjMjFjNDQ4OTlmYzMxMjEzNApDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgv
YWE2ZmU1NmNmNjkxZDA1ODcyMjljYjVjMjFjNDQ4OTlmYzMxMjEzNAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctczEtMDgyODEwMzgtYWE2ZmU1NmNmNjkxZDA1ODcyMjljYjVjMjFjNDQ4OTlmYzMxMjEz
NAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvYWE2ZmU1
NmNmNjkxZDA1ODcyMjljYjVjMjFjNDQ4OTlmYzMxMjEzNC92bWxpbnV6LTMuMTcuMC1yYzIt
d2wtYXRoLTAxNjI4LWdhYTZmZTU2CgoyMDE0LTA4LTI4IDExOjI4OjExIGRldGVjdGluZyBi
b290IHN0YXRlIAkyIFRFU1QgRkFJTFVSRQpbICAgIDkuNDI3MTY2XSBUZXN0aW5nIGV2ZW50
IGttYWxsb2M6IApbICAgMzIuMTAwMDAyXSBOTUkgd2F0Y2hkb2c6IEJVRzogc29mdCBsb2Nr
dXAgLSBDUFUjMSBzdHVjayBmb3IgMjJzISBbdG9ydHVyZV9zbGFtX2t0OjExNV0KWyAgIDMy
LjEwMDAwMl0gQ1BVOiAxIFBJRDogMTE1IENvbW06IHRvcnR1cmVfc2xhbV9rdCBOb3QgdGFp
bnRlZCAzLjE3LjAtcmMyLXdsLWF0aC0wMTYyOC1nYWE2ZmU1NiAjNQpbICAgMzIuMTAwMDAy
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
ICAzMi4xMDAwMDJdIHRhc2s6IGZmZmY4ODAwMGIxZTRhMTAgdGk6IGZmZmY4ODAwMGIxOTgw
MDAgdGFzay50aTogZmZmZjg4MDAwYjE5ODAwMApbICAgMzIuMTAwMDAyXSBSSVA6IDAwMTA6
WzxmZmZmZmZmZjgyNDBjZTZkPl0gIFs8ZmZmZmZmZmY4MjQwY2U2ZD5dIF9jb25kX3Jlc2No
ZWQrMHhkLzB4NjAKWyAgIDMyLjEwMDAwMl0gUlNQOiAwMDAwOmZmZmY4ODAwMGIxOWJlMTgg
IEVGTEFHUzogMDAwMDAyMDIKWyAgIDMyLjEwMDAwMl0gUkFYOiBmZmZmODgwMDBiMWU0YTEw
IFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAwMDAwMDAyYTAKWyAgIDMyLjEw
MDAwMl0gUkRYOiAwMDAwMDAwMDAwMDAwMDczIFJTSTogMDAwMDAwMDAwMDAwMDI3NiBSREk6
IGZmZmZmZmZmODJkYjNlNjgKWyAgIDMyLjEwMDAwMl0gUkJQOiBmZmZmODgwMDBiMTliZTI4
IFIwODogMDAwMDAwMDAwMDAwMDlkOCBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKWyAgIDMyLjEw
MDAwMl0gUjEwOiAwMDAwMDAwMDAwMDAwMDAwIFIxMTogMDAwMDAwMDAwMDAwMDAwMCBSMTI6
IGZmZmY4ODAwMGIxOWJkZjAKWyAgIDMyLjEwMDAwMl0gUjEzOiBmZmZmODgwMDBiMTliZTEw
IFIxNDogZmZmZmZmZmY4MjQxNGJkZiBSMTU6IGZmZmY4ODAwMGIxOWJkODAKWyAgIDMyLjEw
MDAwMl0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODAwMTI0MDAwMDAo
MDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgMzIuMTAwMDAyXSBDUzogIDAwMTAg
RFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAzMi4xMDAwMDJd
IENSMjogMDAwMDAwMDAwMDAwMDAwMCBDUjM6IDAwMDAwMDAwMDMwMTIwMDAgQ1I0OiAwMDAw
MDAwMDAwMDQwNmUwClsgICAzMi4xMDAwMDJdIFN0YWNrOgpbICAgMzIuMTAwMDAyXSAgZmZm
ZmZmZmY4MTIwMDlmOCBmZmZmODgwMDA5NzkwZDUwIGZmZmY4ODAwMGIxOWJlNDggZmZmZmZm
ZmY4MTIwMTJmMwpbICAgMzIuMTAwMDAyXSAgMDAwMDAwNjMwMDAwMDAwMCBmZmZmODgwMDEw
MGIwYTgwIGZmZmY4ODAwMGIxOWJmNDggZmZmZmZmZmY4MTEwNTE2MApbICAgMzIuMTAwMDAy
XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBiMWU0YTEwIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZjg4MDAwMDAwMDAwMApbICAgMzIuMTAwMDAyXSBDYWxsIFRyYWNlOgpbICAgMzIuMTAw
MDAyXSAgWzxmZmZmZmZmZjgxMjAwOWY4Pl0gPyBzdHV0dGVyX3dhaXQrMHhhOC8weDEzMApb
ICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgxMjAxMmYzPl0gdG9ydHVyZV9zbGFtX2t0aHJl
YWQrMHhlMy8weDE5MApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgxMTA1MTYwPl0ga3Ro
cmVhZCsweDEzMC8weDE2MApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgxMTA1MDMwPl0g
PyBfX2t0aHJlYWRfdW5wYXJrKzB4YTAvMHhhMApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZm
ZjgyNDE2MTdjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDMyLjEwMDAwMl0gIFs8
ZmZmZmZmZmY4MTEwNTAzMD5dID8gX19rdGhyZWFkX3VucGFyaysweGEwLzB4YTAKWyAgIDMy
LjEwMDAwMl0gQ29kZTogZmYgZmYgYTggMDggNzUgYWEgNWIgNDggODMgMDUgMzcgMTYgNzUg
MDEgMDEgNWQgYzMgMGYgMGIgNDggODMgMDUgZmIgMTUgNzUgMDEgMDEgMGYgMWYgMDAgMGYg
MWYgNDQgMDAgMDAgNDggODMgMDUgMTMgMjQgNzUgMDEgMDEgPDY1PiA4YiAwNCAyNSBlMCBi
OCAwMCAwMCA4NSBjMCA3NCAwMyAzMSBjMCBjMyA1NSA0OCA4MyAwNSAwMyAyNCAKWyAgIDMy
LjEwMDAwMl0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IHNvZnRsb2NrdXA6IGh1bmcg
dGFza3MKWyAgIDMyLjEwMDAwMl0gQ1BVOiAxIFBJRDogMTE1IENvbW06IHRvcnR1cmVfc2xh
bV9rdCBUYWludGVkOiBHICAgICAgICAgICAgIEwgMy4xNy4wLXJjMi13bC1hdGgtMDE2Mjgt
Z2FhNmZlNTYgIzUKWyAgIDMyLjEwMDAwMl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMzIuMTAwMDAyXSAgMDAwMDAwMDAwMDAwMDAw
NyBmZmZmODgwMDEyNDAzZGY4IGZmZmZmZmZmODI0MDY4YzQgZmZmZmZmZmY4MmRhNDE3Mwpb
ICAgMzIuMTAwMDAyXSAgZmZmZjg4MDAxMjQwM2U3MCBmZmZmZmZmZjgyM2ZlNzA2IDAwMDAw
MDAwMDAwMDAwMDggZmZmZjg4MDAxMjQwM2U4MApbICAgMzIuMTAwMDAyXSAgZmZmZjg4MDAx
MjQwM2UyMCAwMDAwMDAwMDAwMDAwMDAxIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MTE1
MDU0MwpbICAgMzIuMTAwMDAyXSBDYWxsIFRyYWNlOgpbICAgMzIuMTAwMDAyXSAgPElSUT4g
IFs8ZmZmZmZmZmY4MjQwNjhjND5dIGR1bXBfc3RhY2srMHg4NS8weGJhClsgICAzMi4xMDAw
MDJdICBbPGZmZmZmZmZmODIzZmU3MDY+XSBwYW5pYysweDExMC8weDMwMApbICAgMzIuMTAw
MDAyXSAgWzxmZmZmZmZmZjgxMTUwNTQzPl0gPyBjb25zb2xlX3VubG9jaysweDM3My8weDY4
MApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgxMWFkNjYzPl0gd2F0Y2hkb2dfdGltZXJf
Zm4rMHgyODMvMHgyZTAKWyAgIDMyLjEwMDAwMl0gIFs8ZmZmZmZmZmY4MTE3MWY0OT5dIGhy
dGltZXJfcnVuX3F1ZXVlcysweDE1OS8weDQ3MApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZm
ZjgxMWFkM2UwPl0gPyB3YXRjaGRvZysweDQwLzB4NDAKWyAgIDMyLjEwMDAwMl0gIFs8ZmZm
ZmZmZmY4MTE3MGI5Mj5dIHVwZGF0ZV9wcm9jZXNzX3RpbWVzKzB4NDIvMHhjMApbICAgMzIu
MTAwMDAyXSAgWzxmZmZmZmZmZjgxMTgzZmI4Pl0gdGlja19wZXJpb2RpYysweDM4LzB4MTMw
ClsgICAzMi4xMDAwMDJdICBbPGZmZmZmZmZmODExODQyYmU+XSB0aWNrX2hhbmRsZV9wZXJp
b2RpYysweDJlLzB4YjAKWyAgIDMyLjEwMDAwMl0gIFs8ZmZmZmZmZmY4MTIwMTIxMD5dID8g
dG9ydHVyZV9zdHV0dGVyKzB4MWQwLzB4MWQwClsgICAzMi4xMDAwMDJdICBbPGZmZmZmZmZm
ODEwNTBjZGY+XSBsb2NhbF9hcGljX3RpbWVyX2ludGVycnVwdCsweDNmLzB4ODAKWyAgIDMy
LjEwMDAwMl0gIFs8ZmZmZmZmZmY4MjQxOGRmZj5dIHNtcF9hcGljX3RpbWVyX2ludGVycnVw
dCsweDVmLzB4ODAKWyAgIDMyLjEwMDAwMl0gIFs8ZmZmZmZmZmY4MjQxNzFkZD5dIGFwaWNf
dGltZXJfaW50ZXJydXB0KzB4NmQvMHg4MApbICAgMzIuMTAwMDAyXSAgPEVPST4gIFs8ZmZm
ZmZmZmY4MjQwY2U2ZD5dID8gX2NvbmRfcmVzY2hlZCsweGQvMHg2MApbICAgMzIuMTAwMDAy
XSAgWzxmZmZmZmZmZjgxMjAwOWY4Pl0gPyBzdHV0dGVyX3dhaXQrMHhhOC8weDEzMApbICAg
MzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgxMjAxMmYzPl0gdG9ydHVyZV9zbGFtX2t0aHJlYWQr
MHhlMy8weDE5MApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgxMTA1MTYwPl0ga3RocmVh
ZCsweDEzMC8weDE2MApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgxMTA1MDMwPl0gPyBf
X2t0aHJlYWRfdW5wYXJrKzB4YTAvMHhhMApbICAgMzIuMTAwMDAyXSAgWzxmZmZmZmZmZjgy
NDE2MTdjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgIDMyLjEwMDAwMl0gIFs8ZmZm
ZmZmZmY4MTEwNTAzMD5dID8gX19rdGhyZWFkX3VucGFyaysweGEwLzB4YTAKWyAgIDMyLjEw
MDAwMl0gS2VybmVsIE9mZnNldDogMHgwIGZyb20gMHhmZmZmZmZmZjgxMDAwMDAwIChyZWxv
Y2F0aW9uIHJhbmdlOiAweGZmZmZmZmZmODAwMDAwMDAtMHhmZmZmZmZmZjlmZmZmZmZmKQoK
RWxhcHNlZCB0aW1lOiA0MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4
L2FhNmZlNTZjZjY5MWQwNTg3MjI5Y2I1YzIxYzQ0ODk5ZmMzMTIxMzQvZG1lc2ctcXVhbnRh
bC1rYnVpbGQtMTk6MjAxNDA4MjgxMTI2Mzc6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEw
Mzg6My4xNy4wLXJjMi13bC1hdGgtMDE2MjgtZ2FhNmZlNTY6NQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA4MjgxMDM4L2FhNmZlNTZjZjY5MWQwNTg3MjI5Y2I1YzIxYzQ0ODk5
ZmMzMTIxMzQvZG1lc2ctcXVhbnRhbC12cC0yNToyMDE0MDgyODExMjgxNDp4ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wODI4MTAzODozLjE3LjAtcmMyLXdsLWF0aC0wMTYyOC1nYWE2ZmU1Njo1
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvYWE2ZmU1NmNmNjkxZDA1
ODcyMjljYjVjMjFjNDQ4OTlmYzMxMjEzNC9kbWVzZy1xdWFudGFsLWtidWlsZC03OjIwMTQw
ODI4MTEyNjU3Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wt
YXRoLTAxNjI4LWdhYTZmZTU2OjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4
MTAzOC9hYTZmZTU2Y2Y2OTFkMDU4NzIyOWNiNWMyMWM0NDg5OWZjMzEyMTM0L2RtZXNnLXF1
YW50YWwtdnAtMTA6MjAxNDA4MjgxMTI4Mjk6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEw
Mzg6My4xNy4wLXJjMi13bC1hdGgtMDE2MjgtZ2FhNmZlNTY6NQowOjQ6NiBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgcmN1
L3JjdS9leHAKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5l
YXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGFhNmZlNTZjZjY5MWQwNTg3MjI5Y2I1YzIx
YzQ0ODk5ZmMzMTIxMzQgNWNkZTU2ZDk0ZjA3NjExMDFiMjM1ZDFjODhjNjc0MDM0YmRkMTAx
YSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBhYTZmZTU2Li4uIE1lcmdlICdyY3Uv
cmN1L2V4cCcgaW50byBkZXZlbC1ob3VybHktMjAxNDA4MjgxMApIRUFEIGlzIG5vdyBhdCBi
NGQzMzE4Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2NyeXB0by9tYXN0ZXIn
CkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMSBzdGVwKQpbYTMxYTY5ZTBhNzYwMWQ3OGIyNDJkMWUwYzM2N2U1M2U2YmRjNDdmOF0g
cmN1OiBFbGltaW5hdGUgZGVhZGxvY2sgYmV0d2VlbiBDUFUgaG90cGx1ZyBhbmQgZXhwZWRp
dGVkIGdyYWNlIHBlcmlvZHMKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9s
aW51eC04L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDgy
ODEwMzgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwODI4MTA6YTMxYTY5ZTBhNzYw
MWQ3OGIyNDJkMWUwYzM2N2U1M2U2YmRjNDdmODpiaXNlY3QtbGludXgtOAoKMjAxNC0wOC0y
OCAxMToyODo0NyBhMzFhNjllMGE3NjAxZDc4YjI0MmQxZTBjMzY3ZTUzZTZiZGM0N2Y4IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4LWEzMWE2OWUwYTc2MDFkNzhiMjQyZDFl
MGMzNjdlNTNlNmJkYzQ3ZjgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXMxLTA4MjgxMDM4L2EzMWE2OWUwYTc2MDFkNzhiMjQyZDFlMGMzNjdlNTNl
NmJkYzQ3ZjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4LWEzMWE2OWUwYTc2MDFkNzhi
MjQyZDFlMGMzNjdlNTNlNmJkYzQ3ZjgKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTA4MjgxMDM4L2EzMWE2OWUwYTc2MDFkNzhiMjQyZDFlMGMzNjdlNTNlNmJkYzQ3
Zjgvdm1saW51ei0zLjE3LjAtcmMyLTAwMDY0LWdhMzFhNjllMAoKMjAxNC0wOC0yOCAxMToz
MDo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMSBURVNUIEZBSUxVUkUKWyAgICA5LjU5MDc5
Ml0gVGVzdGluZyBldmVudCBkZXZpY2VfcG1fY2FsbGJhY2tfc3RhcnQ6IApbICAgMzIuMTIw
MDAyXSBOTUkgd2F0Y2hkb2c6IEJVRzogc29mdCBsb2NrdXAgLSBDUFUjMSBzdHVjayBmb3Ig
MjJzISBbdG9ydHVyZV9zbGFtX2t0OjExNV0KWyAgIDMyLjEyMDAwMl0gQ1BVOiAxIFBJRDog
MTE1IENvbW06IHRvcnR1cmVfc2xhbV9rdCBOb3QgdGFpbnRlZCAzLjE3LjAtcmMyLTAwMDY0
LWdhMzFhNjllMCAjNgpbICAgMzIuMTIwMDAyXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2No
cywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAzMi4xMjAwMDJdIHRhc2s6IGZmZmY4ODAw
MTE3OTA1ZDAgdGk6IGZmZmY4ODAwMGIzODgwMDAgdGFzay50aTogZmZmZjg4MDAwYjM4ODAw
MApbICAgMzIuMTIwMDAyXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMTFiMWFiPl0gIFs8ZmZm
ZmZmZmY4MTExYjFhYj5dIF9fbWlnaHRfc2xlZXArMHgxYi8weDFhMApbICAgMzIuMTIwMDAy
XSBSU1A6IDAwMDA6ZmZmZjg4MDAwYjM4YmUxMCAgRUZMQUdTOiAwMDAwMDIwMgpbICAgMzIu
MTIwMDAyXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiAwMDAwMDAwMDAwMDAwMDAwIFJD
WDogMDAwMDAwMDAwMDAwMDJhMApbICAgMzIuMTIwMDAyXSBSRFg6IDAwMDAwMDAwMDAwMDAw
MDAgUlNJOiAwMDAwMDAwMDAwMDAwMjc2IFJESTogZmZmZmZmZmY4MmRhOGI4OApbICAgMzIu
MTIwMDAyXSBSQlA6IGZmZmY4ODAwMGIzOGJlMjggUjA4OiAwMDAwMDAwMDAwMDAwN2RhIFIw
OTogMDAwMDAwMDAwMDAwMDAwMApbICAgMzIuMTIwMDAyXSBSMTA6IDAwMDAwMDAwMDAwMDAw
MDAgUjExOiAwMDAwMDAwMDAwMDAwMDAwIFIxMjogZmZmZjg4MDAwYjM4YmRmMApbICAgMzIu
MTIwMDAyXSBSMTM6IGZmZmY4ODAwMGIzOGJlMTAgUjE0OiBmZmZmZmZmZjgyNDA3MzVmIFIx
NTogZmZmZjg4MDAwYjM4YmQ4MApbICAgMzIuMTIwMDAyXSBGUzogIDAwMDAwMDAwMDAwMDAw
MDAoMDAwMCkgR1M6ZmZmZjg4MDAxMjQwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAw
MDAwClsgICAzMi4xMjAwMDJdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAw
MDAwMDAwODAwNTAwMzMKWyAgIDMyLjEyMDAwMl0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwIENS
MzogMDAwMDAwMDAwMzAxMjAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZTAKWyAgIDMyLjEyMDAw
Ml0gU3RhY2s6ClsgICAzMi4xMjAwMDJdICBmZmZmODgwMDBiMzhiZTI4IGZmZmZmZmZmODEy
MDA4N2IgZmZmZjg4MDAwOTdiY2NkMCBmZmZmODgwMDBiMzhiZTQ4ClsgICAzMi4xMjAwMDJd
ICBmZmZmZmZmZjgxMjAxMTgzIDAwMDAwMDYzMDAwMDAwMDAgZmZmZjg4MDAxMGYxMTk4MCBm
ZmZmODgwMDBiMzhiZjQ4ClsgICAzMi4xMjAwMDJdICBmZmZmZmZmZjgxMTA1MjIwIDAwMDAw
MDAwMDAwMDAwMDAgZmZmZjg4MDAxMTc5MDVkMCAwMDAwMDAwMDAwMDAwMDAwClsgICAzMi4x
MjAwMDJdIENhbGwgVHJhY2U6ClsgICAzMi4xMjAwMDJdICBbPGZmZmZmZmZmODEyMDA4N2I+
XSA/IHN0dXR0ZXJfd2FpdCsweDliLzB4MTMwClsgICAzMi4xMjAwMDJdICBbPGZmZmZmZmZm
ODEyMDExODM+XSB0b3J0dXJlX3NsYW1fa3RocmVhZCsweGUzLzB4MTkwClsgICAzMi4xMjAw
MDJdICBbPGZmZmZmZmZmODExMDUyMjA+XSBrdGhyZWFkKzB4MTMwLzB4MTYwClsgICAzMi4x
MjAwMDJdICBbPGZmZmZmZmZmODExMDUwZjA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHhhMC8w
eGEwClsgICAzMi4xMjAwMDJdICBbPGZmZmZmZmZmODI0MDg4ZmM+XSByZXRfZnJvbV9mb3Jr
KzB4N2MvMHhiMApbICAgMzIuMTIwMDAyXSAgWzxmZmZmZmZmZjgxMTA1MGYwPl0gPyBfX2t0
aHJlYWRfdW5wYXJrKzB4YTAvMHhhMApbICAgMzIuMTIwMDAyXSBDb2RlOiBhMyAwMiAwMSA1
ZCBjMyAwZiAxZiAwMCA1YiBiOCAwMSAwMCAwMCAwMCA1ZCBjMyAwZiAxZiA0NCAwMCAwMCA2
NSA4YiAwNCAyNSBlMCBiOCAwMCAwMCA1NSAyNSBmZiBmZiBkZiA3ZiA0OCA4MyAwNSA3NSBl
NiBhMyAwMiAwMSA8Mzk+IGMyIDQ4IDg5IGU1IDBmIDg0IDMyIDAxIDAwIDAwIDgzIDNkIDQ3
IDZiIDYwIDAyIDAxIDc0IDExIDQ4IApbICAgMzIuMTIwMDAyXSBLZXJuZWwgcGFuaWMgLSBu
b3Qgc3luY2luZzogc29mdGxvY2t1cDogaHVuZyB0YXNrcwpbICAgMzIuMTIwMDAyXSBDUFU6
IDEgUElEOiAxMTUgQ29tbTogdG9ydHVyZV9zbGFtX2t0IFRhaW50ZWQ6IEcgICAgICAgICAg
ICAgTCAzLjE3LjAtcmMyLTAwMDY0LWdhMzFhNjllMCAjNgpbICAgMzIuMTIwMDAyXSBIYXJk
d2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAzMi4x
MjAwMDJdICAwMDAwMDAwMDAwMDAwMDA3IGZmZmY4ODAwMTI0MDNkZjggZmZmZmZmZmY4MjNm
OTA5NCBmZmZmZmZmZjgyZDk4ZWI2ClsgICAzMi4xMjAwMDJdICBmZmZmODgwMDEyNDAzZTcw
IGZmZmZmZmZmODIzZjBlZDYgMDAwMDAwMDAwMDAwMDAwOCBmZmZmODgwMDEyNDAzZTgwClsg
ICAzMi4xMjAwMDJdICBmZmZmODgwMDEyNDAzZTIwIDAwMDAwMDAwMDAwMDAwMDEgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmZmZmZjgxMTUwNWMzClsgICAzMi4xMjAwMDJdIENhbGwgVHJhY2U6
ClsgICAzMi4xMjAwMDJdICA8SVJRPiAgWzxmZmZmZmZmZjgyM2Y5MDk0Pl0gZHVtcF9zdGFj
aysweDg1LzB4YmEKWyAgIDMyLjEyMDAwMl0gIFs8ZmZmZmZmZmY4MjNmMGVkNj5dIHBhbmlj
KzB4MTEwLzB4MzAwClsgICAzMi4xMjAwMDJdICBbPGZmZmZmZmZmODExNTA1YzM+XSA/IGNv
bnNvbGVfdW5sb2NrKzB4MzczLzB4NjgwClsgICAzMi4xMjAwMDJdICBbPGZmZmZmZmZmODEx
YWQ0ZDM+XSB3YXRjaGRvZ190aW1lcl9mbisweDI4My8weDJlMApbICAgMzIuMTIwMDAyXSAg
WzxmZmZmZmZmZjgxMTcxZGI5Pl0gaHJ0aW1lcl9ydW5fcXVldWVzKzB4MTU5LzB4NDcwClsg
ICAzMi4xMjAwMDJdICBbPGZmZmZmZmZmODExYWQyNTA+XSA/IHdhdGNoZG9nKzB4NDAvMHg0
MApbICAgMzIuMTIwMDAyXSAgWzxmZmZmZmZmZjgxMTcwYTAyPl0gdXBkYXRlX3Byb2Nlc3Nf
dGltZXMrMHg0Mi8weGMwClsgICAzMi4xMjAwMDJdICBbPGZmZmZmZmZmODExODNlMjg+XSB0
aWNrX3BlcmlvZGljKzB4MzgvMHgxMzAKWyAgIDMyLjEyMDAwMl0gIFs8ZmZmZmZmZmY4MTE4
NDEyZT5dIHRpY2tfaGFuZGxlX3BlcmlvZGljKzB4MmUvMHhiMApbICAgMzIuMTIwMDAyXSAg
WzxmZmZmZmZmZjgxMjAxMGEwPl0gPyB0b3J0dXJlX3N0dXR0ZXIrMHgxZDAvMHgxZDAKWyAg
IDMyLjEyMDAwMl0gIFs8ZmZmZmZmZmY4MTA1MGRiZj5dIGxvY2FsX2FwaWNfdGltZXJfaW50
ZXJydXB0KzB4M2YvMHg4MApbICAgMzIuMTIwMDAyXSAgWzxmZmZmZmZmZjgyNDBiNTdmPl0g
c21wX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4NWYvMHg4MApbICAgMzIuMTIwMDAyXSAgWzxm
ZmZmZmZmZjgyNDA5OTVkPl0gYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg2ZC8weDgwClsgICAz
Mi4xMjAwMDJdICA8RU9JPiAgWzxmZmZmZmZmZjgxMTFiMWFiPl0gPyBfX21pZ2h0X3NsZWVw
KzB4MWIvMHgxYTAKWyAgIDMyLjEyMDAwMl0gIFs8ZmZmZmZmZmY4MTIwMDg3Yj5dID8gc3R1
dHRlcl93YWl0KzB4OWIvMHgxMzAKWyAgIDMyLjEyMDAwMl0gIFs8ZmZmZmZmZmY4MTIwMTE4
Mz5dIHRvcnR1cmVfc2xhbV9rdGhyZWFkKzB4ZTMvMHgxOTAKWyAgIDMyLjEyMDAwMl0gIFs8
ZmZmZmZmZmY4MTEwNTIyMD5dIGt0aHJlYWQrMHgxMzAvMHgxNjAKWyAgIDMyLjEyMDAwMl0g
IFs8ZmZmZmZmZmY4MTEwNTBmMD5dID8gX19rdGhyZWFkX3VucGFyaysweGEwLzB4YTAKWyAg
IDMyLjEyMDAwMl0gIFs8ZmZmZmZmZmY4MjQwODhmYz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8w
eGIwClsgICAzMi4xMjAwMDJdICBbPGZmZmZmZmZmODExMDUwZjA+XSA/IF9fa3RocmVhZF91
bnBhcmsrMHhhMC8weGEwClsgICAzMi4xMjAwMDJdIEtlcm5lbCBPZmZzZXQ6IDB4MCBmcm9t
IDB4ZmZmZmZmZmY4MTAwMDAwMCAocmVsb2NhdGlvbiByYW5nZTogMHhmZmZmZmZmZjgwMDAw
MDAwLTB4ZmZmZmZmZmY5ZmZmZmZmZikKCkVsYXBzZWQgdGltZTogNDAKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9hMzFhNjllMGE3NjAxZDc4YjI0MmQxZTBjMzY3
ZTUzZTZiZGM0N2Y4L2RtZXNnLXF1YW50YWwta2J1aWxkLTI3OjIwMTQwODI4MTEyOTI1Ong4
Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItMDAwNjQtZ2EzMWE2OWUw
OjYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9hMzFhNjllMGE3NjAx
ZDc4YjI0MmQxZTBjMzY3ZTUzZTZiZGM0N2Y4L2RtZXNnLXF1YW50YWwta2J1aWxkLTk6MjAx
NDA4MjgxMTI5MjY6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi0w
MDA2NC1nYTMxYTY5ZTA6NgowOjI6MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlz
ZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAw
IHN0ZXBzKQpbODZkOGYxMGUzNWMxZTYzZDVhODM5NzkyZWZkN2MzY2I2YTU2NGZlNF0gcmN1
dG9ydHVyZTogQWRkIHByZWVtcHRpb24tc2xhbSB0ZXN0aW5nCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC04L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0
MDgyODEwOjg2ZDhmMTBlMzVjMWU2M2Q1YTgzOTc5MmVmZDdjM2NiNmE1NjRmZTQ6YmlzZWN0
LWxpbnV4LTgKCjIwMTQtMDgtMjggMTE6MzE6MTkgODZkOGYxMGUzNWMxZTYzZDVhODM5Nzky
ZWZkN2MzY2I2YTU2NGZlNCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC04NmQ4
ZjEwZTM1YzFlNjNkNWE4Mzk3OTJlZmQ3YzNjYjZhNTY0ZmU0CkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC84NmQ4ZjEwZTM1YzFl
NjNkNWE4Mzk3OTJlZmQ3YzNjYjZhNTY0ZmU0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAz
OC04NmQ4ZjEwZTM1YzFlNjNkNWE4Mzk3OTJlZmQ3YzNjYjZhNTY0ZmU0Cmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC84NmQ4ZjEwZTM1YzFlNjNkNWE4
Mzk3OTJlZmQ3YzNjYjZhNTY0ZmU0L3ZtbGludXotMy4xNy4wLXJjMi0wMDA2My1nODZkOGYx
MAoKMjAxNC0wOC0yOCAxMTozMzoxOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMQkyCTQgVEVT
VCBGQUlMVVJFClsgICAgOS40MjA4NDFdIFRlc3RpbmcgZXZlbnQgbW1fdm1zY2FuX3dyaXRl
cGFnZTogClsgICAzMi4wODMzMzhdIE5NSSB3YXRjaGRvZzogQlVHOiBzb2Z0IGxvY2t1cCAt
IENQVSMxIHN0dWNrIGZvciAyMnMhIFt0b3J0dXJlX3NsYW1fa3Q6MTE1XQpbICAgMzIuMDgz
MzM4XSBDUFU6IDEgUElEOiAxMTUgQ29tbTogdG9ydHVyZV9zbGFtX2t0IE5vdCB0YWludGVk
IDMuMTcuMC1yYzItMDAwNjMtZzg2ZDhmMTAgIzcKWyAgIDMyLjA4MzMzOF0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgMzIuMDgzMzM4
XSB0YXNrOiBmZmZmODgwMDBiMzkxNjUwIHRpOiBmZmZmODgwMDBiMjc4MDAwIHRhc2sudGk6
IGZmZmY4ODAwMGIyNzgwMDAKWyAgIDMyLjA4MzMzOF0gUklQOiAwMDEwOls8ZmZmZmZmZmY4
MTExYjIyMj5dICBbPGZmZmZmZmZmODExMWIyMjI+XSBfX21pZ2h0X3NsZWVwKzB4MTYyLzB4
MWEwClsgICAzMi4wODMzMzhdIFJTUDogMDAwMDpmZmZmODgwMDBiMjdiZTEwICBFRkxBR1M6
IDAwMDAwMjAyClsgICAzMi4wODMzMzhdIFJBWDogMDAwMDAwMDAwMDAwMDIwMiBSQlg6IDAw
MDAwMDAwMDAwMDAwMDAgUkNYOiAwMDAwMDAwMDAwMDAwMmEwClsgICAzMi4wODMzMzhdIFJE
WDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAyNzYgUkRJOiBmZmZmZmZm
ZjgyZGE4YjU4ClsgICAzMi4wODMzMzhdIFJCUDogZmZmZjg4MDAwYjI3YmUxMCBSMDg6IDAw
MDAwMDAwMDAwMDA5MGYgUjA5OiAwMDAwMDAwMDAwMDAwMDAwClsgICAzMi4wODMzMzhdIFIx
MDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmODgw
MDBiMjdiZGYwClsgICAzMi4wODMzMzhdIFIxMzogZmZmZjg4MDAwYjI3YmUxMCBSMTQ6IGZm
ZmZmZmZmODI0MDcyM2YgUjE1OiBmZmZmODgwMDBiMjdiZDgwClsgICAzMi4wODMzMzhdIEZT
OiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmODgwMDEyNDAwMDAwKDAwMDApIGtu
bEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgIDMyLjA4MzMzOF0gQ1M6ICAwMDEwIERTOiAwMDAw
IEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAgMzIuMDgzMzM4XSBDUjI6IDAw
MDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAwMDAzMDEyMDAwIENSNDogMDAwMDAwMDAwMDA0
MDZlMApbICAgMzIuMDgzMzM4XSBTdGFjazoKWyAgIDMyLjA4MzMzOF0gIGZmZmY4ODAwMGIy
N2JlMjggZmZmZmZmZmY4MTIwMDc1YiBmZmZmODgwMDA5N2VjYTEwIGZmZmY4ODAwMGIyN2Jl
NDgKWyAgIDMyLjA4MzMzOF0gIGZmZmZmZmZmODEyMDEwNjMgMDAwMDAwNjMwMDAwMDAwMCBm
ZmZmODgwMDEwMWFmZWMwIGZmZmY4ODAwMGIyN2JmNDgKWyAgIDMyLjA4MzMzOF0gIGZmZmZm
ZmZmODExMDUxNTAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBiMzkxNjUwIDAwMDAwMDAw
MDAwMDAwMDAKWyAgIDMyLjA4MzMzOF0gQ2FsbCBUcmFjZToKWyAgIDMyLjA4MzMzOF0gIFs8
ZmZmZmZmZmY4MTIwMDc1Yj5dIHN0dXR0ZXJfd2FpdCsweDliLzB4MTMwClsgICAzMi4wODMz
MzhdICBbPGZmZmZmZmZmODEyMDEwNjM+XSB0b3J0dXJlX3NsYW1fa3RocmVhZCsweGUzLzB4
MTkwClsgICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODExMDUxNTA+XSBrdGhyZWFkKzB4MTMw
LzB4MTYwClsgICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODExMDUwMjA+XSA/IF9fa3RocmVh
ZF91bnBhcmsrMHhhMC8weGEwClsgICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODI0MDg3YmM+
XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgMzIuMDgzMzM4XSAgWzxmZmZmZmZmZjgx
MTA1MDIwPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4YTAvMHhhMApbICAgMzIuMDgzMzM4XSBD
b2RlOiAwMiA3NSAwOCA0OCA4MyAwNSA0ZSBlNiBhMyAwMiAwMSBlOCBlOCBkYyAyZCAwMSA0
OCA4MyAwNSA0OSBlNiBhMyAwMiAwMSA1ZCBjMyAwZiAxZiA4MCAwMCAwMCAwMCAwMCA0OCA4
MyAwNSBjOCBlNSBhMyAwMiAwMSA5YyA1OCA8MGY+IDFmIDQ0IDAwIDAwIDQ4IDgzIDA1IGMx
IGU1IGEzIDAyIDAxIGY2IGM0IDAyIDBmIDg0IGFlIGZlIGZmIApbICAgMzIuMDgzMzM4XSBL
ZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogc29mdGxvY2t1cDogaHVuZyB0YXNrcwpbICAg
MzIuMDgzMzM4XSBDUFU6IDEgUElEOiAxMTUgQ29tbTogdG9ydHVyZV9zbGFtX2t0IFRhaW50
ZWQ6IEcgICAgICAgICAgICAgTCAzLjE3LjAtcmMyLTAwMDYzLWc4NmQ4ZjEwICM3ClsgICAz
Mi4wODMzMzhdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgIDMyLjA4MzMzOF0gIDAwMDAwMDAwMDAwMDAwMDcgZmZmZjg4MDAxMjQwM2Rm
OCBmZmZmZmZmZjgyM2Y4Zjc0IGZmZmZmZmZmODJkOThlODUKWyAgIDMyLjA4MzMzOF0gIGZm
ZmY4ODAwMTI0MDNlNzAgZmZmZmZmZmY4MjNmMGRiNiAwMDAwMDAwMDAwMDAwMDA4IGZmZmY4
ODAwMTI0MDNlODAKWyAgIDMyLjA4MzMzOF0gIGZmZmY4ODAwMTI0MDNlMjAgMDAwMDAwMDAw
MDAwMDAwMSAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODExNTA0ZjMKWyAgIDMyLjA4MzMz
OF0gQ2FsbCBUcmFjZToKWyAgIDMyLjA4MzMzOF0gIDxJUlE+ICBbPGZmZmZmZmZmODIzZjhm
NzQ+XSBkdW1wX3N0YWNrKzB4ODUvMHhiYQpbICAgMzIuMDgzMzM4XSAgWzxmZmZmZmZmZjgy
M2YwZGI2Pl0gcGFuaWMrMHgxMTAvMHgzMDAKWyAgIDMyLjA4MzMzOF0gIFs8ZmZmZmZmZmY4
MTE1MDRmMz5dID8gY29uc29sZV91bmxvY2srMHgzNzMvMHg2ODAKWyAgIDMyLjA4MzMzOF0g
IFs8ZmZmZmZmZmY4MTFhZDNiMz5dIHdhdGNoZG9nX3RpbWVyX2ZuKzB4MjgzLzB4MmUwClsg
ICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODExNzFjOTk+XSBocnRpbWVyX3J1bl9xdWV1ZXMr
MHgxNTkvMHg0NzAKWyAgIDMyLjA4MzMzOF0gIFs8ZmZmZmZmZmY4MTFhZDEzMD5dID8gd2F0
Y2hkb2crMHg0MC8weDQwClsgICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODExNzA4ZTI+XSB1
cGRhdGVfcHJvY2Vzc190aW1lcysweDQyLzB4YzAKWyAgIDMyLjA4MzMzOF0gIFs8ZmZmZmZm
ZmY4MTE4M2QwOD5dIHRpY2tfcGVyaW9kaWMrMHgzOC8weDEzMApbICAgMzIuMDgzMzM4XSAg
WzxmZmZmZmZmZjgxMTg0MDBlPl0gdGlja19oYW5kbGVfcGVyaW9kaWMrMHgyZS8weGIwClsg
ICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODEyMDBmODA+XSA/IHRvcnR1cmVfc3R1dHRlcisw
eDFkMC8weDFkMApbICAgMzIuMDgzMzM4XSAgWzxmZmZmZmZmZjgxMDUwZGJmPl0gbG9jYWxf
YXBpY190aW1lcl9pbnRlcnJ1cHQrMHgzZi8weDgwClsgICAzMi4wODMzMzhdICBbPGZmZmZm
ZmZmODI0MGI0M2Y+XSBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg1Zi8weDgwClsgICAz
Mi4wODMzMzhdICBbPGZmZmZmZmZmODI0MDk4MWQ+XSBhcGljX3RpbWVyX2ludGVycnVwdCsw
eDZkLzB4ODAKWyAgIDMyLjA4MzMzOF0gIDxFT0k+ICBbPGZmZmZmZmZmODExMWIyMjI+XSA/
IF9fbWlnaHRfc2xlZXArMHgxNjIvMHgxYTAKWyAgIDMyLjA4MzMzOF0gIFs8ZmZmZmZmZmY4
MTIwMDc1Yj5dIHN0dXR0ZXJfd2FpdCsweDliLzB4MTMwClsgICAzMi4wODMzMzhdICBbPGZm
ZmZmZmZmODEyMDEwNjM+XSB0b3J0dXJlX3NsYW1fa3RocmVhZCsweGUzLzB4MTkwClsgICAz
Mi4wODMzMzhdICBbPGZmZmZmZmZmODExMDUxNTA+XSBrdGhyZWFkKzB4MTMwLzB4MTYwClsg
ICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODExMDUwMjA+XSA/IF9fa3RocmVhZF91bnBhcmsr
MHhhMC8weGEwClsgICAzMi4wODMzMzhdICBbPGZmZmZmZmZmODI0MDg3YmM+XSByZXRfZnJv
bV9mb3JrKzB4N2MvMHhiMApbICAgMzIuMDgzMzM4XSAgWzxmZmZmZmZmZjgxMTA1MDIwPl0g
PyBfX2t0aHJlYWRfdW5wYXJrKzB4YTAvMHhhMApbICAgMzIuMDgzMzM4XSBLZXJuZWwgT2Zm
c2V0OiAweDAgZnJvbSAweGZmZmZmZmZmODEwMDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4
ZmZmZmZmZmY4MDAwMDAwMC0weGZmZmZmZmZmOWZmZmZmZmYpCgpFbGFwc2VkIHRpbWU6IDQw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvODZkOGYxMGUzNWMxZTYz
ZDVhODM5NzkyZWZkN2MzY2I2YTU2NGZlNC9kbWVzZy1xdWFudGFsLWtidWlsZC0xNzoyMDE0
MDgyODExMzMwNjp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzODozLjE3LjAtcmMyLTAw
MDYzLWc4NmQ4ZjEwOjcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC84
NmQ4ZjEwZTM1YzFlNjNkNWE4Mzk3OTJlZmQ3YzNjYjZhNTY0ZmU0L2RtZXNnLXF1YW50YWwt
a2J1aWxkLTIwOjIwMTQwODI4MTEzMzA2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4
OjMuMTcuMC1yYzItMDAwNjMtZzg2ZDhmMTA6NwowOjI6NiBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wOC0yOCAxMTozNDo1MCBSRVBFQVQgQ09VTlQ6IDQwICAj
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKODZkOGYx
MGUzNWMxZTYzZDVhODM5NzkyZWZkN2MzY2I2YTU2NGZlNCBpcyB0aGUgZmlyc3QgYmFkIGNv
bW1pdApjb21taXQgODZkOGYxMGUzNWMxZTYzZDVhODM5NzkyZWZkN2MzY2I2YTU2NGZlNApB
dXRob3I6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXgudm5ldC5pYm0uY29tPgpE
YXRlOiAgIEZyaSBBdWcgMjIgMTQ6MDM6MzggMjAxNCAtMDcwMAoKICAgIHJjdXRvcnR1cmU6
IEFkZCBwcmVlbXB0aW9uLXNsYW0gdGVzdGluZwogICAgCiAgICBUaGlzIGNvbW1pdCBhZGRz
IGtlcm5lbCB0aHJlYWRzIHdob3NlIHNvbGUgcHVycG9zZSBpcyB0byBhZGQgcmFuZG9tCiAg
ICBwcmVlbXB0aW9uIG9mIHRoZSBjb2RlIHVuZGVyIHRlc3QuICBJdCBhZGRzIGZvdXIga2Vy
bmVsIGJvb3QgcGFyYW1ldGVycwogICAgdG8gY29udHJvbCB0aGUgbnVtYmVyIG9mIHByZWVt
cHRpb24tc2xhbSBrdGhyZWFkcywgdGhlaXIgcmVhbC10aW1lCiAgICBwcmlvcml0eSwgdGhl
IGxlbmd0aCBvZiB0aW1lIHRoYXQgdGhleSBzbGVlcCwgYW5kIHRoZSBsZW5ndGggb2YgdGlt
ZQogICAgdGhhdCB0aGV5IHNwaW4gYXQgdGhlIHJlYWwtdGltZSBwcmlvcml0eS4KICAgIAog
ICAgU2lnbmVkLW9mZi1ieTogUGF1bCBFLiBNY0tlbm5leSA8cGF1bG1ja0BsaW51eC52bmV0
LmlibS5jb20+Cgo6MDQwMDAwIDA0MDAwMCA4YTMwNDE2MDM2NzZhNmZkZDZlN2Q4MzMwZGM0
NGVmOGFhMTFmYTk2IDQ3Yzg5OWNhZWFhZGJiMWQyMTk4YzNhNTUxZTUxNTI5YTUyMWIzNzQg
TQlEb2N1bWVudGF0aW9uCjowNDAwMDAgMDQwMDAwIDY5YjI3NGM0MjM0ZmVjMjc1OTIxYzVi
NjIwMDU2MmJkMWZjODYyYzMgZjkwODkyYWI1MDlkNmMxODU4NjcxNjFhYzZlYzQzOWQwMDYw
MjkxMCBNCWluY2x1ZGUKOjA0MDAwMCAwNDAwMDAgMmY0Njg1MmE3YmE0ZGUzZDlmOGZiNzkz
ODZiYWY1YjU4NWRmMTlmOSAwMDBmZDQyMGExYWQyMmUyYmZlM2I0OGMyMWIxNWEzNGY4YmQ3
NzQ0IE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyA4NmQ4ZjEwZS4uLiByY3V0b3J0dXJlOiBBZGQgcHJlZW1wdGlvbi1zbGFtIHRlc3Rp
bmcKSEVBRCBpcyBub3cgYXQgYjUyOTM4Yi4uLiBNZXJnZSBicmFuY2ggJ3JjdS10YXNrcy4y
MDE0LjA4LjI3YScgaW50byBIRUFECmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9saW51eC1kZXZlbDpkZXZlbC1ob3Vy
bHktMjAxNDA4MjgxMDpiNTI5MzhiZTk5YTA5OWI0NTI5NzllZDgwNWI0ODAzMzdlZTJkZjBm
OmJpc2VjdC1saW51eC04CgoyMDE0LTA4LTI4IDExOjM0OjUxIGI1MjkzOGJlOTlhMDk5YjQ1
Mjk3OWVkODA1YjQ4MDMzN2VlMmRmMGYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEw
MzgtYjUyOTM4YmU5OWEwOTliNDUyOTc5ZWQ4MDViNDgwMzM3ZWUyZGYwZgpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvYjUyOTM4
YmU5OWEwOTliNDUyOTc5ZWQ4MDViNDgwMzM3ZWUyZGYwZgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEt
MDgyODEwMzgtYjUyOTM4YmU5OWEwOTliNDUyOTc5ZWQ4MDViNDgwMzM3ZWUyZGYwZgprZXJu
ZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvYjUyOTM4YmU5OWEw
OTliNDUyOTc5ZWQ4MDViNDgwMzM3ZWUyZGYwZi92bWxpbnV6LTMuMTcuMC1yYzItMDAwNjIt
Z2I1MjkzOGIKCjIwMTQtMDgtMjggMTE6MzY6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkx
MQkxOQkzNQk0OQk1OAk2Nwk5OAkxMjAgU1VDQ0VTUwoKUHJldmlvdXMgSEVBRCBwb3NpdGlv
biB3YXMgYjUyOTM4Yi4uLiBNZXJnZSBicmFuY2ggJ3JjdS10YXNrcy4yMDE0LjA4LjI3YScg
aW50byBIRUFECkhFQUQgaXMgbm93IGF0IDgxNTNhNmIuLi4gMGRheSBoZWFkIGd1YXJkIGZv
ciAnZGV2ZWwtaG91cmx5LTIwMTQwODI4MTAnCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDA4MjgxMDo4MTUzYTZiYmNjMzQwYjI5MjI0OGI2NmE2ZGI4OWI5OTFm
ZTIzOTk1OmJpc2VjdC1saW51eC04CiBURVNUIEZBSUxVUkUKWyAgIDM4LjcwOTg4Nl0gVGVz
dGluZyBldmVudCBkcm1fdmJsYW5rX2V2ZW50OiAKWyAgIDY0LjA2MzMzOV0gTk1JIHdhdGNo
ZG9nOiBCVUc6IHNvZnQgbG9ja3VwIC0gQ1BVIzAgc3R1Y2sgZm9yIDIycyEgW3RvcnR1cmVf
c2xhbV9rdDoxMTVdClsgICA2NC4wNjMzMzldIENQVTogMCBQSUQ6IDExNSBDb21tOiB0b3J0
dXJlX3NsYW1fa3QgTm90IHRhaW50ZWQgMy4xNy4wLXJjMi13bC1hdGgtMDIyMDYtZzgxNTNh
NmIgIzE0NwpbICAgNjQuMDYzMzM5XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklP
UyBCb2NocyAwMS8wMS8yMDExClsgICA2NC4wNjMzMzldIHRhc2s6IGZmZmY4ODAwMGIzNDUz
ZDAgdGk6IGZmZmY4ODAwMGIzY2MwMDAgdGFzay50aTogZmZmZjg4MDAwYjNjYzAwMApbICAg
NjQuMDYzMzM5XSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMWRkMzI4Pl0gIFs8ZmZmZmZmZmY4
MTFkZDMyOD5dIGZ1bmN0aW9uX3Rlc3RfZXZlbnRzX2NhbGwrMHg1OC8weDE0MApbICAgNjQu
MDYzMzM5XSBSU1A6IDAwMDA6ZmZmZjg4MDAwYjNjZmNlMCAgRUZMQUdTOiAwMDAwMDIwMgpb
ICAgNjQuMDYzMzM5XSBSQVg6IGZmZmY4ODAwMTIzY2VkMTQgUkJYOiBmZmZmODgwMDExNTQ1
NDAwIFJDWDogMDAwMDAwMDAwMDAwMDAwMApbICAgNjQuMDYzMzM5XSBSRFg6IDAwMDAwMDAw
MDAwMDAwMDAgUlNJOiBmZmZmZmZmZjgxMjAwOWY4IFJESTogZmZmZmZmZmY4MjQwZTg4MApb
ICAgNjQuMDYzMzM5XSBSQlA6IGZmZmY4ODAwMGIzY2ZkMjAgUjA4OiAwMDAwMDAwMDAwMDA0
MDJlIFIwOTogMDAwMDAwMDAwMDAwMDAwMApbICAgNjQuMDYzMzM5XSBSMTA6IDAwMDAwMDAw
MDAwMDEyYzAgUjExOiAwMDAwMDAxMDIwNGM4MmFjIFIxMjogZmZmZjg4MDAwYjNjZmM3OApb
ICAgNjQuMDYzMzM5XSBSMTM6IGZmZmY4ODAwMTE1NDU0YzggUjE0OiBmZmZmODgwMDExNTQ1
NDAwIFIxNTogZmZmZjg4MDAxMTU0MjQwMApbICAgNjQuMDYzMzM5XSBGUzogIDAwMDAwMDAw
MDAwMDAwMDAoMDAwMCkgR1M6ZmZmZjg4MDAxMjIwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAw
MDAwMDAwMDAwClsgICA2NC4wNjMzMzldIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBD
UjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgIDY0LjA2MzMzOV0gQ1IyOiAwMDAwMDAwMGZmZmZm
ZmZmIENSMzogMDAwMDAwMDAwMzAxMjAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZjAKWyAgIDY0
LjA2MzMzOV0gU3RhY2s6ClsgICA2NC4wNjMzMzldICBmZmZmODgwMDExNjgyNmJjIDAwMDAw
MDAwMDAwMDAyMDYgZmZmZjg4MDAxMTU0MjQwMCBmZmZmZmZmZjgzYTA4OTgwClsgICA2NC4w
NjMzMzldICBmZmZmZmZmZjgyNDBlODgwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MTIw
MDlmOCAwMDAwMDAwMDAwMDAwODAwClsgICA2NC4wNjMzMzldICBmZmZmODgwMDBiM2NmZDU4
IGZmZmZmZmZmODExYmExZjggZmZmZmZmZmY4MmRhNWZhNiAwMDAwMDAwMDAwMDAwMDAwClsg
ICA2NC4wNjMzMzldIENhbGwgVHJhY2U6ClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODI0
MGU4ODA+XSA/IHByZWVtcHRfc2NoZWR1bGVfaXJxKzB4YzAvMHhjMApbICAgNjQuMDYzMzM5
XSAgWzxmZmZmZmZmZjgxMjAwOWY4Pl0gPyBzdHV0dGVyX3dhaXQrMHhhOC8weDEzMApbICAg
NjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgxMWJhMWY4Pl0gZnRyYWNlX29wc19saXN0X2Z1bmMr
MHgxMTgvMHgyMjAKWyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MTIwMTIxMD5dID8gdG9y
dHVyZV9zdHV0dGVyKzB4MWQwLzB4MWQwClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODI0
MTlkYTE+XSBmdHJhY2VfY2FsbCsweDUvMHgyZgpbICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZm
ZjgyNDE5ZGExPl0gPyBmdHJhY2VfY2FsbCsweDUvMHgyZgpbICAgNjQuMDYzMzM5XSAgWzxm
ZmZmZmZmZjgyNDBlODg1Pl0gPyBfY29uZF9yZXNjaGVkKzB4NS8weDYwClsgICA2NC4wNjMz
MzldICBbPGZmZmZmZmZmODI0MGU4ODU+XSA/IF9jb25kX3Jlc2NoZWQrMHg1LzB4NjAKWyAg
IDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MTIwMDlmOD5dID8gc3R1dHRlcl93YWl0KzB4YTgv
MHgxMzAKWyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MTIwMTJmMz5dIHRvcnR1cmVfc2xh
bV9rdGhyZWFkKzB4ZTMvMHgxOTAKWyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MTEwNTE2
MD5dIGt0aHJlYWQrMHgxMzAvMHgxNjAKWyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MTEw
NTAzMD5dID8gX19rdGhyZWFkX3VucGFyaysweGEwLzB4YTAKWyAgIDY0LjA2MzMzOV0gIFs8
ZmZmZmZmZmY4MjQxN2I3Yz5dIHJldF9mcm9tX2ZvcmsrMHg3Yy8weGIwClsgICA2NC4wNjMz
MzldICBbPGZmZmZmZmZmODExMDUwMzA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHhhMC8weGEw
ClsgICA2NC4wNjMzMzldIENvZGU6IDI1IDFjIGIwIDAwIDAwIDQ5IGM3IGM2IDE0IGVkIDFj
IDAwIDQ4IDYzIGRiIDQ4IDgzIDA1IGI0IDM3IDQ3IDAzIDAxIDRjIDg5IGYwIGJhIDAxIDAw
IDAwIDAwIDQ4IDAzIDA0IGRkIDAwIGMwIDcyIDgzIGYwIDBmIGMxIDEwIDw0OD4gODMgMDUg
YTAgMzcgNDcgMDMgMDEgODUgZDIgNzQgM2MgNGMgODkgZjAgNDggMDMgMDQgZGQgMDAgYzAg
ClsgICA2NC4wNjMzMzldIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBzb2Z0bG9ja3Vw
OiBodW5nIHRhc2tzClsgICA2NC4wNjMzMzldIENQVTogMCBQSUQ6IDExNSBDb21tOiB0b3J0
dXJlX3NsYW1fa3QgVGFpbnRlZDogRyAgICAgICAgICAgICBMIDMuMTcuMC1yYzItd2wtYXRo
LTAyMjA2LWc4MTUzYTZiICMxNDcKWyAgIDY0LjA2MzMzOV0gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgNjQuMDYzMzM5XSAgMDAwMDAw
MDAwMDAwMDAyNSBmZmZmODgwMDEyMjAzZGY4IGZmZmZmZmZmODI0MDgzYTQgZmZmZmZmZmY4
MmRhNDcwMApbICAgNjQuMDYzMzM5XSAgZmZmZjg4MDAxMjIwM2U3MCBmZmZmZmZmZjgyNDAw
MWU2IDAwMDAwMDAwMDAwMDAwMDggZmZmZjg4MDAxMjIwM2U4MApbICAgNjQuMDYzMzM5XSAg
ZmZmZjg4MDAxMjIwM2UyMCAwMDAwMDAwMDAwMDBiOWI4IDAwMDAwMDAwMDAwMDAwMDAgZmZm
ZmZmZmY4MTE1MDU0MwpbICAgNjQuMDYzMzM5XSBDYWxsIFRyYWNlOgpbICAgNjQuMDYzMzM5
XSAgPElSUT4gIFs8ZmZmZmZmZmY4MjQwODNhND5dIGR1bXBfc3RhY2srMHg4NS8weGJhClsg
ICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODI0MDAxZTY+XSBwYW5pYysweDExMC8weDMwMApb
ICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgxMTUwNTQzPl0gPyBjb25zb2xlX3VubG9jaysw
eDM3My8weDY4MApbICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgxMWFkNjYzPl0gd2F0Y2hk
b2dfdGltZXJfZm4rMHgyODMvMHgyZTAKWyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MTE3
MWY0OT5dIGhydGltZXJfcnVuX3F1ZXVlcysweDE1OS8weDQ3MApbICAgNjQuMDYzMzM5XSAg
WzxmZmZmZmZmZjgxMWFkM2UwPl0gPyB3YXRjaGRvZysweDQwLzB4NDAKWyAgIDY0LjA2MzMz
OV0gIFs8ZmZmZmZmZmY4MTE3MGI5Mj5dIHVwZGF0ZV9wcm9jZXNzX3RpbWVzKzB4NDIvMHhj
MApbICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgxMTgzZmI4Pl0gdGlja19wZXJpb2RpYysw
eDM4LzB4MTMwClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODExODQyYmU+XSA/IHRpY2tf
aGFuZGxlX3BlcmlvZGljKzB4MmUvMHhiMApbICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgx
MTg0MmJlPl0gdGlja19oYW5kbGVfcGVyaW9kaWMrMHgyZS8weGIwClsgICA2NC4wNjMzMzld
ICBbPGZmZmZmZmZmODI0MGU4ODA+XSA/IHByZWVtcHRfc2NoZWR1bGVfaXJxKzB4YzAvMHhj
MApbICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgxMDUwY2RmPl0gbG9jYWxfYXBpY190aW1l
cl9pbnRlcnJ1cHQrMHgzZi8weDgwClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODI0MWE3
ZmY+XSBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg1Zi8weDgwClsgICA2NC4wNjMzMzld
ICBbPGZmZmZmZmZmODI0MThiZGQ+XSBhcGljX3RpbWVyX2ludGVycnVwdCsweDZkLzB4ODAK
WyAgIDY0LjA2MzMzOV0gIDxFT0k+ICBbPGZmZmZmZmZmODEyMDA5Zjg+XSA/IHN0dXR0ZXJf
d2FpdCsweGE4LzB4MTMwClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODI0MGU4ODA+XSA/
IHByZWVtcHRfc2NoZWR1bGVfaXJxKzB4YzAvMHhjMApbICAgNjQuMDYzMzM5XSAgWzxmZmZm
ZmZmZjgxMWRkMzI4Pl0gPyBmdW5jdGlvbl90ZXN0X2V2ZW50c19jYWxsKzB4NTgvMHgxNDAK
WyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MjQwZTg4MD5dID8gcHJlZW1wdF9zY2hlZHVs
ZV9pcnErMHhjMC8weGMwClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODEyMDA5Zjg+XSA/
IHN0dXR0ZXJfd2FpdCsweGE4LzB4MTMwClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODEx
YmExZjg+XSBmdHJhY2Vfb3BzX2xpc3RfZnVuYysweDExOC8weDIyMApbICAgNjQuMDYzMzM5
XSAgWzxmZmZmZmZmZjgxMjAxMjEwPl0gPyB0b3J0dXJlX3N0dXR0ZXIrMHgxZDAvMHgxZDAK
WyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MjQxOWRhMT5dIGZ0cmFjZV9jYWxsKzB4NS8w
eDJmClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODI0MTlkYTE+XSA/IGZ0cmFjZV9jYWxs
KzB4NS8weDJmClsgICA2NC4wNjMzMzldICBbPGZmZmZmZmZmODI0MGU4ODU+XSA/IF9jb25k
X3Jlc2NoZWQrMHg1LzB4NjAKWyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MjQwZTg4NT5d
ID8gX2NvbmRfcmVzY2hlZCsweDUvMHg2MApbICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgx
MjAwOWY4Pl0gPyBzdHV0dGVyX3dhaXQrMHhhOC8weDEzMApbICAgNjQuMDYzMzM5XSAgWzxm
ZmZmZmZmZjgxMjAxMmYzPl0gdG9ydHVyZV9zbGFtX2t0aHJlYWQrMHhlMy8weDE5MApbICAg
NjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgxMTA1MTYwPl0ga3RocmVhZCsweDEzMC8weDE2MApb
ICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgxMTA1MDMwPl0gPyBfX2t0aHJlYWRfdW5wYXJr
KzB4YTAvMHhhMApbICAgNjQuMDYzMzM5XSAgWzxmZmZmZmZmZjgyNDE3YjdjPl0gcmV0X2Zy
b21fZm9yaysweDdjLzB4YjAKWyAgIDY0LjA2MzMzOV0gIFs8ZmZmZmZmZmY4MTEwNTAzMD5d
ID8gX19rdGhyZWFkX3VucGFyaysweGEwLzB4YTAKWyAgIDY0LjA2MzMzOV0gS2VybmVsIE9m
ZnNldDogMHgwIGZyb20gMHhmZmZmZmZmZjgxMDAwMDAwIChyZWxvY2F0aW9uIHJhbmdlOiAw
eGZmZmZmZmZmODAwMDAwMDAtMHhmZmZmZmZmZjlmZmZmZmZmKQoKRWxhcHNlZCB0aW1lOiA3
MAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4LzgxNTNhNmJiY2MzNDBi
MjkyMjQ4YjY2YTZkYjg5Yjk5MWZlMjM5OTUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtNjoyMDE0
MDgyODEwNDQxODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzODozLjE3LjAtcmMyLXds
LWF0aC0wMjIwNi1nODE1M2E2YjoxNDcKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
ODI4MTAzOC84MTUzYTZiYmNjMzQwYjI5MjI0OGI2NmE2ZGI4OWI5OTFmZTIzOTk1L2RtZXNn
LXF1YW50YWwta2J1aWxkLTMxOjIwMTQwODI4MTA0NDE4Ong4Nl82NC1yYW5kY29uZmlnLXMx
LTA4MjgxMDM4OjMuMTcuMC1yYzItd2wtYXRoLTAyMjA2LWc4MTUzYTZiOjE0Nwova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4LzgxNTNhNmJiY2MzNDBiMjkyMjQ4YjY2
YTZkYjg5Yjk5MWZlMjM5OTUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTg6MjAxNDA4MjgxMDQy
MDQ6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4wLXJjMi13bC1hdGgtMDIy
MDYtZzgxNTNhNmI6MTQ3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgv
ODE1M2E2YmJjYzM0MGIyOTIyNDhiNjZhNmRiODliOTkxZmUyMzk5NS9kbWVzZy1xdWFudGFs
LWtidWlsZC0xNToyMDE0MDgyODEwNDQxODp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAz
ODozLjE3LjAtcmMyLXdsLWF0aC0wMjIwNi1nODE1M2E2YjoxNDcKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wODI4MTAzOC84MTUzYTZiYmNjMzQwYjI5MjI0OGI2NmE2ZGI4OWI5
OTFmZTIzOTk1L2RtZXNnLXF1YW50YWwta2J1aWxkLTMyOjIwMTQwODI4MTA0NDE4Ong4Nl82
NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4OjMuMTcuMC1yYzItd2wtYXRoLTAyMjA2LWc4MTUz
YTZiOjE0Nwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4LzgxNTNhNmJi
Y2MzNDBiMjkyMjQ4YjY2YTZkYjg5Yjk5MWZlMjM5OTUvZG1lc2ctcXVhbnRhbC1rYnVpbGQt
MjU6MjAxNDA4MjgxMDQ0Mjg6eDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzg6My4xNy4w
LXJjMi13bC1hdGgtMDIyMDYtZzgxNTNhNmI6MTQ3Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctczEtMDgyODEwMzgvODE1M2E2YmJjYzM0MGIyOTIyNDhiNjZhNmRiODliOTkxZmUyMzk5
NS9kbWVzZy1xdWFudGFsLWtidWlsZC0xNjoyMDE0MDgyODEwNDQyMzp4ODZfNjQtcmFuZGNv
bmZpZy1zMS0wODI4MTAzODozLjE3LjAtcmMyLXdsLWF0aC0wMjIwNi1nODE1M2E2YjoxNDcK
MDo3OjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA4MTUz
YTZiIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDgyODEwJwoKPT09
PT09PT09IGxpbnVzL21hc3RlciA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3
YXMgODE1M2E2Yi4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA4
MjgxMCcKSEVBRCBpcyBub3cgYXQgZjFiZDQ3My4uLiBNZXJnZSBicmFuY2ggJ3NlYy12My4x
Ny1yYzInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9zZXJnZWgvbGludXgtc2VjdXJpdHkKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTA4MjgxMDM4L2xpbnVzOm1hc3RlcjpmMWJkNDcz
Zjk1ZTAyYmMzODJkNGRhZTk0ZDdmODJlMmE0NTVlMDVkOmJpc2VjdC1saW51eC04CgoyMDE0
LTA4LTI4IDExOjQxOjI3IGYxYmQ0NzNmOTVlMDJiYzM4MmQ0ZGFlOTRkN2Y4MmUyYTQ1NWUw
NWQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgtZjFiZDQ3M2Y5NWUwMmJjMzgy
ZDRkYWU5NGQ3ZjgyZTJhNDU1ZTA1ZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgvZjFiZDQ3M2Y5NWUwMmJjMzgyZDRkYWU5NGQ3
ZjgyZTJhNDU1ZTA1ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctczEtMDgyODEwMzgtZjFiZDQ3M2Y5NWUw
MmJjMzgyZDRkYWU5NGQ3ZjgyZTJhNDU1ZTA1ZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctczEtMDgyODEwMzgvZjFiZDQ3M2Y5NWUwMmJjMzgyZDRkYWU5NGQ3ZjgyZTJh
NDU1ZTA1ZC92bWxpbnV6LTMuMTcuMC1yYzItMDAwNDItZ2YxYmQ0NzMKCjIwMTQtMDgtMjgg
MTE6NDM6MjcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMi4JMTgJMjMJMjkJMzYJMzcuCTQw
CTQ1CTUyCTU0CTU2CTU5Lgk2MAk2OAk3MQk3NAk3Ngk3Nwk4Mgk4OQk5Mwk5OAkxMDEJMTAz
CTEwNwkxMTAJMTE3CTExOAkxMjAgU1VDQ0VTUwoKCj09PT09PT09PSBuZXh0L21hc3RlciA9
PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZjFiZDQ3My4uLiBNZXJnZSBi
cmFuY2ggJ3NlYy12My4xNy1yYzInIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9zZXJnZWgvbGludXgtc2VjdXJpdHkKSEVBRCBpcyBub3cgYXQg
ZDA1NDQ2YS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA4MjcK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTA4MjgxMDM4L25leHQ6bWFzdGVyOmQwNTQ0NmFlMjEyODA2NGE0YmI4Zjc0Yzg0ZjY5MDFm
ZmI1Yzk0YmM6YmlzZWN0LWxpbnV4LTgKCjIwMTQtMDgtMjggMTI6MDA6MjggZDA1NDQ2YWUy
MTI4MDY0YTRiYjhmNzRjODRmNjkwMWZmYjVjOTRiYyBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1z
MS0wODI4MTAzOC1kMDU0NDZhZTIxMjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5NGJjCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAz
OC9kMDU0NDZhZTIxMjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5NGJjCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wODI4MTAzOC1kMDU0NDZhZTIxMjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5
NGJjCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wODI4MTAzOC9kMDU0
NDZhZTIxMjgwNjRhNGJiOGY3NGM4NGY2OTAxZmZiNWM5NGJjL3ZtbGludXotMy4xNy4wLXJj
Mi1uZXh0LTIwMTQwODI3CgoyMDE0LTA4LTI4IDEyOjAyOjI4IGRldGVjdGluZyBib290IHN0
YXRlIC4uLgkxCTcJOQkxNy4uCTIwCTIxCTIzLi4uCTI2CTI4CTI5CTM0CTM2CTM5CTQzCTUz
CTU3CTYwCTYzCTY2CTY5CTcwCTcyCTc2CTgxCTg0CTkwCTkyCTk1CTk3CTEwMAkxMDMJMTA0
CTEwNgkxMTQJMTE1CTEyMCBTVUNDRVNTCgo=

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc2-00063-g86d8f10"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.17.0-rc2 Kernel Configuration
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
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
CONFIG_RCU_NOCB_CPU_ZERO=y
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
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
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_X86_16BIT is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_CMA_AREAS=7
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_KEXEC_VERIFY_SIG=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
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
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_UDP_TUNNEL is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_COMMON=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_PROCFS is not set
CONFIG_NF_CONNTRACK_FTP=y
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CT_NETLINK=y
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_INET=y
CONFIG_NFT_EXTHDR=y
CONFIG_NFT_META=y
CONFIG_NFT_CT=y
CONFIG_NFT_RBTREE=y
CONFIG_NFT_HASH=y
CONFIG_NFT_COUNTER=y
CONFIG_NFT_LOG=y
CONFIG_NFT_LIMIT=y
CONFIG_NFT_REJECT=y
CONFIG_NFT_REJECT_INET=y
# CONFIG_NFT_COMPAT is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CONNSECMARK is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_IP_SET=y
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=y
# CONFIG_IP_SET_BITMAP_IPMAC is not set
CONFIG_IP_SET_BITMAP_PORT=y
# CONFIG_IP_SET_HASH_IP is not set
# CONFIG_IP_SET_HASH_IPMARK is not set
CONFIG_IP_SET_HASH_IPPORT=y
# CONFIG_IP_SET_HASH_IPPORTIP is not set
CONFIG_IP_SET_HASH_IPPORTNET=y
CONFIG_IP_SET_HASH_NETPORTNET=y
CONFIG_IP_SET_HASH_NET=y
CONFIG_IP_SET_HASH_NETNET=y
# CONFIG_IP_SET_HASH_NETPORT is not set
CONFIG_IP_SET_HASH_NETIFACE=y
# CONFIG_IP_SET_LIST_SET is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=y
# CONFIG_IP_VS_WRR is not set
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
# CONFIG_IP_VS_SH is not set
CONFIG_IP_VS_SED=y
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
# CONFIG_IP_VS_NFCT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_LOG_ARP=y
# CONFIG_NF_LOG_IPV4 is not set
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_CHAIN_ROUTE_IPV4=y
CONFIG_NFT_REJECT_IPV4=y
CONFIG_NF_TABLES_ARP=y
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_CHAIN_ROUTE_IPV6=y
CONFIG_NFT_REJECT_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_FILTER=y
# CONFIG_IP6_NF_TARGET_REJECT is not set
CONFIG_IP6_NF_MANGLE=y
# CONFIG_IP6_NF_RAW is not set
CONFIG_NF_TABLES_BRIDGE=y
CONFIG_NFT_BRIDGE_META=y
CONFIG_NFT_BRIDGE_REJECT=y
CONFIG_NF_LOG_BRIDGE=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_RFKILL_GPIO is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
# CONFIG_MTD_UBI is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=y
CONFIG_LOOPBACK_TARGET=y
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_CYPRESS is not set
CONFIG_MOUSE_PS2_LIFEBOOK=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_ARIZONA_HAPTICS is not set
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_BEEPER=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
CONFIG_INPUT_SOC_BUTTON_ARRAY=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

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
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_CRYSTAL_COVE is not set
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS65910 is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2406 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
# CONFIG_WM831X_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
CONFIG_INTEL_SOC_PMIC=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_AXP20X=y
# CONFIG_REGULATOR_BCM590XX is not set
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPA01=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_IMG=y
# CONFIG_IR_IMG_RAW is not set
CONFIG_IR_IMG_HW=y
# CONFIG_IR_IMG_NEC is not set
CONFIG_IR_IMG_JVC=y
# CONFIG_IR_IMG_SONY is not set
CONFIG_IR_IMG_SHARP=y
CONFIG_IR_IMG_SANYO=y
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=y
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=y
CONFIG_VIDEO_SH_VEU=y
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_SI4713=y
CONFIG_PLATFORM_SI4713=y
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI476X=y
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
# CONFIG_VIDEO_IR_I2C is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
CONFIG_VIDEO_OV7670=y
# CONFIG_VIDEO_VS6624 is not set
CONFIG_VIDEO_MT9V011=y
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_AS3645A is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MSI001=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
# CONFIG_MEDIA_TUNER_MT2063 is not set
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_SI2157=y
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_PTN3460=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_TPS65217 is not set
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_SPI=y
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_ATMEL_SOC is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_ASRC=y
CONFIG_SND_SOC_FSL_SAI=y
CONFIG_SND_SOC_FSL_SSI=y
CONFIG_SND_SOC_FSL_SPDIF=y
# CONFIG_SND_SOC_FSL_ESAI is not set
CONFIG_SND_SOC_IMX_AUDMUX=y
# CONFIG_SND_SOC_INTEL_SST is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4554=y
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L56=y
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4265=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CS42XX8=y
CONFIG_SND_SOC_CS42XX8_I2C=y
CONFIG_SND_SOC_HDMI_CODEC=y
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM1792A=y
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
CONFIG_SND_SOC_PCM512x_SPI=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SI476X=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_STA350=y
CONFIG_SND_SOC_TAS2552=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC31XX=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8770=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS65910 is not set
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1343=y
CONFIG_RTC_DRV_DS1347=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
# CONFIG_RTC_DRV_DS3234 is not set
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y
CONFIG_RTC_DRV_MCP795=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_XGENE is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_RTS5208 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
CONFIG_ADIS16203=y
CONFIG_ADIS16204=y
# CONFIG_ADIS16209 is not set
CONFIG_ADIS16220=y
# CONFIG_ADIS16240 is not set
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
# CONFIG_AD7606_IFACE_SPI is not set
CONFIG_AD7780=y
CONFIG_AD7816=y
CONFIG_AD7192=y
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_SPI=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
CONFIG_AD9832=y
# CONFIG_AD9834 is not set
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
# CONFIG_AD9910 is not set
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_TSL2583 is not set
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y
CONFIG_SENSORS_HMC5843_SPI=y

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
CONFIG_ADE7758=y
# CONFIG_ADE7759 is not set
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
CONFIG_AD2S1200=y
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_FT1000=y
CONFIG_FT1000_PCMCIA=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ASHMEM is not set
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
CONFIG_ANDROID_INTF_ALARM_DEV=y
# CONFIG_SYNC is not set
# CONFIG_ION is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_CRYPTO_SKEIN is not set
# CONFIG_CRYPTO_THREEFISH is not set
CONFIG_UNISYSSPAR=y
CONFIG_UNISYS_VISORUTIL=y
# CONFIG_UNISYS_VISORCHANNEL is not set
CONFIG_UNISYS_CHANNELSTUB=y
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_ARIZONA=y
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX14577=y
CONFIG_EXTCON_MAX77693=y
# CONFIG_EXTCON_PALMAS is not set
CONFIG_EXTCON_SM5502=y
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y
CONFIG_MMA8452=y
CONFIG_KXCJK1013=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7291=y
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
CONFIG_AD7887=y
CONFIG_AD7923=y
# CONFIG_AD799X is not set
# CONFIG_LP8788_ADC is not set
# CONFIG_MAX1027 is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_MEN_Z188_ADC=y
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
# CONFIG_AD5755 is not set
# CONFIG_AD5764 is not set
CONFIG_AD5791=y
CONFIG_AD7303=y
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=y
# CONFIG_HID_SENSOR_GYRO_3D is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
CONFIG_ISL29125=y
CONFIG_HID_SENSOR_ALS=y
# CONFIG_HID_SENSOR_PROX is not set
CONFIG_SENSORS_LM3533=y
# CONFIG_LTR501 is not set
CONFIG_TCS3414=y
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_AK09911=y
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=y
CONFIG_HID_SENSOR_DEVICE_ROTATION=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=y
CONFIG_MPL115=y
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set
CONFIG_T5403=y

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_LPSS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_ST_SPEAR1310_MIPHY=y
CONFIG_PHY_ST_SPEAR1340_MIPHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_DLM is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
# CONFIG_CEPH_FSCACHE is not set
# CONFIG_CEPH_FS_POSIX_ACL is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
# CONFIG_CIFS_POSIX is not set
CONFIG_CIFS_ACL=y
# CONFIG_CIFS_DEBUG is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
CONFIG_CIFS_FSCACHE=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
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
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
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
# CONFIG_CRYPTO_CTS is not set
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
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

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
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
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
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_DRBG_MENU is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--+QahgC5+KEYLbs62--
