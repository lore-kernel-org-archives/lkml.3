Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaCHGwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 01:52:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:20427 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaCHGwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 01:52:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,613,1389772800"; 
   d="log'?scan'208";a="488364568"
Date: Sat, 8 Mar 2014 14:51:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [reboot] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655
 perf_swevent_add()
Message-ID: <20140308065153.GA30311@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi all,

This is a very old WARNING, too old to be bisectable. The below 3 different
back traces show that it's always triggered by trinity at system reboot time.
Any ideas to quiet it? Thank you!

[   88.611838] Unregister pv shared memory for cpu 0
[   88.618866] sbc60xxwdt: Watchdog timer is now disabled...
[   88.626059] ------------[ cut here ]------------
[   88.626064] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655 perf_swevent_add+0x104/0x194()
[   88.626064] Modules linked in:
[   88.626064] CPU: 0 PID: 112 Comm: trinity-main Not tainted 3.14.0-rc5-02112-g3903b5b #240
[   88.626064]  00000000 c8d95e04 c187bedc c8d95e1c c105d6a7 c11107ac cf0b2c00 00000000
[   88.626064]  cfff3054 c8d95e2c c105d713 00000009 00000000 c8d95e3c c11107ac cf0b2c00
[   88.626064]  cf019780 c8d95e58 c110c852 b824a5a9 00000013 cf019780 cf0b2c00 c1d1c0e0
[   88.626064] Call Trace:
[   88.626064]  [<c187bedc>] dump_stack+0x40/0x5e
[   88.626064]  [<c105d6a7>] warn_slowpath_common+0xa9/0xea
[   88.626064]  [<c11107ac>] ? perf_swevent_add+0x104/0x194
[   88.626064]  [<c105d713>] warn_slowpath_null+0x2b/0x3d
[   88.626064]  [<c11107ac>] perf_swevent_add+0x104/0x194
[   88.626064]  [<c110c852>] event_sched_in+0xed/0x26f
[   88.626064]  [<c110ca43>] group_sched_in+0x6f/0x23f
[   88.626064]  [<c110ceeb>] ctx_sched_in+0x2d8/0x33e
[   88.626064]  [<c110d920>] perf_event_sched_in+0x9f/0xb6
[   88.626064]  [<c110dc7e>] perf_event_context_sched_in+0xa9/0x100
[   88.626064]  [<c110dd19>] __perf_event_task_sched_in+0x44/0x2b9
[   88.626064]  [<c1095440>] finish_task_switch.constprop.54+0x1cd/0x210
[   88.626064]  [<c1888a0e>] __schedule+0x984/0xb7e
[   88.626064]  [<c10d5598>] ? tick_program_event+0x2c/0x3f
[   88.626064]  [<c108e022>] ? hrtimer_interrupt+0x1e8/0x348
[   88.626064]  [<c10a7dd9>] ? trace_hardirqs_off_caller+0x1c7/0x262
[   88.626064]  [<c1889191>] ? preempt_schedule_irq+0x70/0x142
[   88.626064]  [<c10ab350>] ? trace_hardirqs_on_caller+0x2be/0x41d
[   88.626064]  [<c18891d4>] preempt_schedule_irq+0xb3/0x142
[   88.626064]  [<c1890f4b>] need_resched+0x1c/0x21
[   88.626064]  [<c1899400>] ? sysenter_past_esp+0x35/0x67
[   88.626064] ---[ end trace f67d3e8be5e62621 ]---
[   88.726142] reboot: Restarting system


 * Will now restart
[  474.781628] Unregister pv shared memory for cpu 0
[  474.828155] ------------[ cut here ]------------
[  474.828298] WARNING: CPU: 0 PID: 118 at kernel/events/core.c:5640 perf_swevent_add+0x121/0x135()
[  474.828298] CPU: 0 PID: 118 Comm: trinity-main Not tainted 3.13.0 #1
[  474.828298] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  474.828298]  00000000 00000000 7d3cdd18 79538855 7d3cdd30 7902d2e5 7907a77c 00000000
[  474.828298]  7ccb52c0 00000000 7d3cdd40 7902d382 00000009 00000000 7d3cdd7c 7907a77c
[  474.828298]  00000002 7d3cdd58 7901e299 00000002 00000001 7d3cdd70 7900587b 7ccb4e10
[  474.828298] Call Trace:
[  474.828298]  [<79538855>] dump_stack+0x16/0x18
[  474.828298]  [<7902d2e5>] warn_slowpath_common+0x50/0x67
[  474.828298]  [<7907a77c>] ? perf_swevent_add+0x121/0x135
[  474.828298]  [<7902d382>] warn_slowpath_null+0xf/0x13
[  474.828298]  [<7907a77c>] perf_swevent_add+0x121/0x135
[  474.828298]  [<7901e299>] ? kvm_clock_read+0x14/0x1d
[  474.828298]  [<7900587b>] ? arch_install_hw_breakpoint+0x83/0xb9
[  474.828298]  [<79077f74>] event_sched_in+0x7c/0x146
[  474.828298]  [<79078083>] group_sched_in+0x45/0x123
[  474.828298]  [<7907834b>] ctx_sched_in+0x1ea/0x2be
[  474.828298]  [<7907895a>] perf_event_sched_in+0x51/0x5a
[  474.828298]  [<790789b6>] perf_event_context_sched_in+0x53/0x72
[  474.828298]  [<79078a00>] __perf_event_task_sched_in+0x2b/0x153
[  474.828298]  [<79043f00>] finish_task_switch.constprop.58+0x75/0x8f
[  474.828298]  [<7953f0f3>] __schedule+0x341/0x4ae
[  474.828298]  [<790a2ef5>] ? kmem_cache_free+0x189/0x192
[  474.828298]  [<790a2ef5>] ? kmem_cache_free+0x189/0x192
[  474.828298]  [<790b1e70>] ? final_putname+0x2d/0x30
[  474.828298]  [<790b1ea2>] ? getname_flags+0x2f/0x11a
[  474.828298]  [<790b1e70>] ? final_putname+0x2d/0x30
[  474.828298]  [<790b1e70>] ? final_putname+0x2d/0x30
[  474.828298]  [<790b1fb8>] ? putname+0x1d/0x26
[  474.828298]  [<7953f364>] _cond_resched+0x1e/0x2f
[  474.828298]  [<7953fa52>] mutex_lock_nested+0x29/0x2d7
[  474.828298]  [<790db0a3>] sysfs_getattr+0x1d/0x40
[  474.828298]  [<790db086>] ? sysfs_refresh_inode+0x6d/0x6d
[  474.828298]  [<790ae6dc>] vfs_getattr_nosec+0x20/0x2e
[  474.828298]  [<790ae70a>] vfs_getattr+0x20/0x24
[  474.828298]  [<790ae79c>] vfs_fstatat+0x4e/0x81
[  474.828298]  [<790aea66>] SyS_fstatat64+0x1b/0x2f
[  474.828298]  [<7954311e>] ? sysenter_do_call+0x1e/0x33
[  474.828298]  [<79543112>] sysenter_do_call+0x12/0x33
[  474.828298] ---[ end trace 5a98e19615ad483e ]---
[  476.221934] reboot: Restarting system


[   76.776846] ------------[ cut here ]------------
[   76.777395] reboot: Restarting system
[   76.777397] reboot: machine restart
[   76.779244] WARNING: CPU: 1 PID: 266 at kernel/events/core.c:5640 perf_swevent_add+0x112/0x120()
[   76.781382] CPU: 1 PID: 266 Comm: trinity-main Not tainted 3.13.0-rc7 #1
[   76.782617] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   76.784121]  0000000000000009 ffff88000f1b3968 ffffffff81669783 0000000000000000
[   76.785591]  ffff88000f1b39a0 ffffffff81088f58 ffff88000f2c5000 ffff88000f0d2400
[   76.786772]  00000006860bccb1 ffff88000e7d4410 ffff88000e7d4414 ffff88000f1b39b0
[   76.786772] Call Trace:
[   76.786772]  [<ffffffff81669783>] dump_stack+0x4d/0x66
[   76.786772]  [<ffffffff81088f58>] warn_slowpath_common+0x78/0xa0
[   76.786772]  [<ffffffff8108906a>] warn_slowpath_null+0x1a/0x20
[   76.786772]  [<ffffffff81126f02>] perf_swevent_add+0x112/0x120
[   76.786772]  [<ffffffff81129e16>] event_sched_in.isra.83+0x76/0x160
[   76.786772]  [<ffffffff81129f6a>] group_sched_in+0x6a/0x1e0
[   76.786772]  [<ffffffff810ba4cd>] ? sched_clock_local+0x1d/0x80
[   76.786772]  [<ffffffff8112a1b2>] ctx_sched_in.isra.84+0xd2/0x1a0
[   76.786772]  [<ffffffff8112a2cf>] perf_event_sched_in.isra.87+0x4f/0x70
[   76.786772]  [<ffffffff8112a4c5>] perf_event_context_sched_in.isra.88+0x75/0xc0
[   76.786772]  [<ffffffff8112afa9>] __perf_event_task_sched_in+0x1a9/0x1d0
[   76.786772]  [<ffffffff810b2068>] finish_task_switch+0xa8/0x100
[   76.786772]  [<ffffffff8166c64c>] __schedule+0x38c/0x840
[   76.786772]  [<ffffffff8166cb1a>] schedule+0x1a/0x20
[   76.786772]  [<ffffffff8166bde9>] schedule_timeout+0x199/0x1f0
[   76.786772]  [<ffffffff8166d42c>] ? wait_for_completion+0xac/0x120
[   76.786772]  [<ffffffff8166d42c>] ? wait_for_completion+0xac/0x120
[   76.786772]  [<ffffffff8166d434>] wait_for_completion+0xb4/0x120
[   76.786772]  [<ffffffff810b7300>] ? wake_up_state+0x20/0x20
[   76.786772]  [<ffffffff810de630>] ? __call_rcu+0x390/0x390
[   76.786772]  [<ffffffff810dbf0a>] wait_rcu_gp+0x5a/0x70
[   76.786772]  [<ffffffff810dbd80>] ? ftrace_raw_output_rcu_utilization+0x50/0x50
[   76.786772]  [<ffffffff810c59dd>] ? complete+0x1d/0x50
[   76.786772]  [<ffffffff810e04be>] synchronize_sched+0x5e/0x70
[   76.786772]  [<ffffffff81571f45>] synchronize_net+0x35/0x50
[   76.786772]  [<ffffffff815b1347>] packet_release+0x237/0x330
[   76.786772]  [<ffffffff815572e9>] sock_release+0x19/0x70
[   76.786772]  [<ffffffff81557352>] sock_close+0x12/0x20
[   76.786772]  [<ffffffff81177a05>] __fput+0xf5/0x2b0
[   76.786772]  [<ffffffff81177c0e>] ____fput+0xe/0x10
[   76.786772]  [<ffffffff810a6764>] task_work_run+0xb4/0xe0
[   76.786772]  [<ffffffff8108b41d>] do_exit+0x27d/0xa40
[   76.786772]  [<ffffffff8123c1c6>] ? lockdep_sys_exit_thunk+0x35/0x67
[   76.786772]  [<ffffffff8108bc6c>] do_group_exit+0x4c/0xc0
[   76.786772]  [<ffffffff8108bcf4>] SyS_exit_group+0x14/0x20
[   76.786772]  [<ffffffff81672e0a>] tracesys+0xd0/0xd5
[   76.786772] ---[ end trace d1ea2a02ef886e63 ]---

git bisect  bad 3903b5b2bac33dcf80b46bc0cde1559e680b76d2  # 07:17      0-      8  0day head guard for 'devel-roam-i386-201403080639'
git bisect  bad 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52  # 07:45      7-      4  Linux 3.12
git bisect  bad 6e4664525b1db28f8c4e1130957f70a94c19213e  # 07:54      0-      1  Linux 3.11
git bisect  bad 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376  # 08:05      3-      3  Linux 3.10
git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 08:14      1-      4  Linux 3.9
git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 08:18      4-      5  Linux 3.8
git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 08:23      2-      2  Linux 3.7
git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 08:33     13-     13  Linux 3.6
git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 08:43     31-     13  Linux 3.5
git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 08:48     35-     34  Linux 3.4
git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 08:54      7-      6  Linux 3.3
git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 09:11     13-     11  Linux 3.2
git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 09:14      5-      4  Linux 3.1
git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 09:29     17-     13  Linux 3.0

Thanks,
Fengguang

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-jaketown-45:20140308070010:i386-randconfig-r5-0308::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-02112-g3903b5b (kbuild@roam) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #240 PREEMPT Sat Mar 8 06:55:44 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02781000, 0x02781fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x02782000, 0x02782fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 65436 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] ACPI: IRQ2 used by override.
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1ceb700
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r5-0308/linux-devel=
:devel-roam-i386-201403080639/.vmlinuz-3903b5b2bac33dcf80b46bc0cde1559e680b=
76d2-20140308065650-7-jaketown branch=3Dlinux-devel/devel-roam-i386-2014030=
80639 BOOT_IMAGE=3D/kernel/i386-randconfig-r5-0308/3903b5b2bac33dcf80b46bc0=
cde1559e680b76d2/vmlinuz-3.14.0-rc5-02112-g3903b5b
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 208228K/261744K available (8807K kernel code, 1839K =
rwdata, 4228K rodata, 556K init, 8516K bss, 53516K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8b000 - 0xfffff000   ( 464 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xffbfe000   ( 756 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1e8f000 - 0xc1f1a000   ( 556 kB)
[    0.000000]       .data : 0xc189a0f0 - 0xc1e8ed40   (6099 kB)
[    0.000000]       .text : 0xc1000000 - 0xc189a0f0   (8808 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0096000 soft=3Dc0080000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
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
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 1600.035 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 3200.07 Bogo=
MIPS (lpj=3D1600035)
[    0.005039] pid_max: default: 4096 minimum: 301
[    0.007657] Security Framework initialized
[    0.008043] SELinux:  Initializing.
[    0.010114] SELinux:  Starting in enforcing mode
[    0.011038] AppArmor: AppArmor disabled by boot time parameter
[    0.013310] Mount-cache hash table entries: 512
[    0.019326] Initializing cgroup subsys debug
[    0.020104] Initializing cgroup subsys freezer
[    0.022161] Initializing cgroup subsys net_cls
[    0.023050] Initializing cgroup subsys perf_event
[    0.025390] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.025390] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.025390] tlb_flushall_shift: 6
[    0.027033] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.038158] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.050163] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.051056] Getting VERSION: 50014
[    0.052058] Getting VERSION: 50014
[    0.053058] Getting ID: 0
[    0.054189] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.056302] Getting ID: f000000
[    0.058057] Getting LVT0: 8700
[    0.059046] Getting LVT1: 8400
[    0.060315] enabled ExtINT on CPU#0
[    0.065850] ENABLING IO-APIC IRQs
[    0.066048] init IO_APIC IRQs
[    0.068036]  apic 0 pin 0 not connected
[    0.070037] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.071143] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.072140] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.073144] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.074119] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.075119] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.076125] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.077128] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.078117] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.079119] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.080120] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.081122] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.082125] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.083108] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.084126] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.085103]  apic 0 pin 16 not connected
[    0.086027]  apic 0 pin 17 not connected
[    0.087028]  apic 0 pin 18 not connected
[    0.088026]  apic 0 pin 19 not connected
[    0.089026]  apic 0 pin 20 not connected
[    0.090026]  apic 0 pin 21 not connected
[    0.091025]  apic 0 pin 22 not connected
[    0.092026]  apic 0 pin 23 not connected
[    0.093263] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.094026] Using local APIC timer interrupts.
[    0.094026] calibrating APIC timer ...
[    0.096000] ... lapic delta =3D 6249819
[    0.096000] ... PM-Timer delta =3D 358097
[    0.096000] ... PM-Timer result ok
[    0.096000] ..... delta 6249819
[    0.096000] ..... mult: 268427682
[    0.096000] ..... calibration result: 999971
[    0.096000] ..... CPU clock speed is 1600.0531 MHz.
[    0.096000] ..... host bus clock speed is 999.0971 MHz.
[    0.103380] gcov: version magic: 0x3430382a
[    0.112162] EVM: security.selinux
[    0.113021] EVM: security.SMACK64
[    0.114020] EVM: security.capability
[    0.119550] prandom: seed boundary self test passed
[    0.122803] prandom: 100 self tests passed
[    0.123034] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.131306] regulator-dummy: no parameters
[    0.136023] NET: Registered protocol family 16
[    0.144183] cpuidle: using governor ladder
[    0.145032] cpuidle: using governor menu
[    0.153137] ACPI: bus type PCI registered
[    0.157215] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.158030] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.159024] PCI: Using configuration type 1 for base access
[    0.234779] ACPI: Added _OSI(Module Device)
[    0.235056] ACPI: Added _OSI(Processor Device)
[    0.236031] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.237027] ACPI: Added _OSI(Processor Aggregator Device)
[    0.305378] ACPI: Interpreter enabled
[    0.306115] ACPI: (supports S0 S5)
[    0.307024] ACPI: Using IOAPIC for interrupt routing
[    0.309377] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.324657] ACPI: No dock devices found.
[    0.462695] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.463076] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.464564] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.470664] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.474542] PCI host bridge to bus 0000:00
[    0.475044] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.477033] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.478037] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.479038] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.480076] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.482193] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.488259] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.495545] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.506042] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.515122] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.518341] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.519087] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.524896] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.528238] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.533236] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.550260] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.557350] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.562035] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.565033] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.578044] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.583401] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.587036] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.605667] pci_bus 0000:00: on NUMA node 0
[    0.615177] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.619362] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.623479] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.627531] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.630454] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.638000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.645335] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.646032] vgaarb: loaded
[    0.647022] vgaarb: bridge control possible 0000:00:02.0
[    0.660306] wmi: Mapper loaded
[    0.662492] PCI: Using ACPI for IRQ routing
[    0.663055] PCI: pci_cache_line_size set to 64 bytes
[    0.664637] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.665111] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.674483] NET: Registered protocol family 23
[    0.675301] NetLabel: Initializing
[    0.676036] NetLabel:  domain hash size =3D 128
[    0.677040] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.679281] NetLabel:  unlabeled traffic allowed by default
[    0.682401] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.685469] Switched to clocksource kvm-clock
[    0.691147] pnp: PnP ACPI init
[    0.693663] ACPI: bus type PNP registered
[    0.696921] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.703150] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.707488] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.713273] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.717655] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.723676] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.728471] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.733360] pnp 00:03: [dma 2]
[    0.736155] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.740882] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.746654] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.751369] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.757008] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.765357] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.771935] pnp: PnP ACPI: found 7 devices
[    0.774508] ACPI: bus type PNP unregistered
[    0.821561] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.825101] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.828520] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.832346] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.836912] NET: Registered protocol family 2
[    0.842747] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.851348] TCP bind hash table entries: 2048 (order: 4, 73728 bytes)
[    0.856810] TCP: Hash tables configured (established 2048 bind 2048)
[    0.861666] TCP: reno registered
[    0.863799] UDP hash table entries: 128 (order: 1, 10240 bytes)
[    0.867683] UDP-Lite hash table entries: 128 (order: 1, 10240 bytes)
[    0.873602] NET: Registered protocol family 1
[    0.876483] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.880246] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.883916] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.887736] pci 0000:00:02.0: Boot video device
[    0.890757] PCI: CLS 0 bytes, default 64
[    0.901025] Unpacking initramfs...
[   10.256124] Freeing initrd memory: 24852K (ce7ab000 - cfff0000)
[   10.544303] DMA-API: preallocated 65536 debug entries
[   10.547269] DMA-API: debugging enabled by kernel config
[   10.556835] cryptomgr_test (21) used greatest stack depth: 7272 bytes le=
ft
[   10.574725] futex hash table entries: 16 (order: -3, 640 bytes)
[   10.578299] Initialise system trusted keyring
[   10.581922] audit: initializing netlink subsys (disabled)
[   10.585770] audit: type=3D2000 audit(1394233126.459:1): initialized
[   11.552605] tsc: Refined TSC clocksource calibration: 1599.928 MHz
[   12.190555] VFS: Disk quotas dquot_6.5.2
[   12.193488] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   12.203817] msgmni has been set to 455
[   12.208448] SELinux:  Registering netfilter hooks
[   12.235343] Key type asymmetric registered
[   12.238657] Asymmetric key parser 'x509' registered
[   12.260464] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[   12.264302] crc32: self tests passed, processed 225944 bytes in 2530075 =
nsec
[   12.272412] crc32c: CRC_LE_BITS =3D 32
[   12.274488] crc32c: self tests passed, processed 225944 bytes in 1124759=
 nsec
[   13.834382] crc32_combine: 8373 self tests passed
[   14.930949] crc32c_combine: 8373 self tests passed
[   14.939473] rivafb_setup START
[   14.941676] nvidiafb_setup START
[   14.945693] vmlfb: initializing
[   14.947991] Could not find Carillo Ranch MCH device.
[   14.950812] no IO addresses supplied
[   14.954977] ipmi message handler version 39.2
[   14.957837] IPMI System Interface driver.
[   14.961122] ipmi_si: Adding default-specified kcs state machine
[   14.964572] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   14.969713] ipmi_si: Interface detection failed
[   14.972163] ipmi_si: Adding default-specified smic state machine
[   14.975260] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   14.980553] ipmi_si: Interface detection failed
[   14.983123] ipmi_si: Adding default-specified bt state machine
[   14.986254] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   14.991410] ipmi_si: Interface detection failed
[   14.995868] ipmi_si: Unable to find any System Interface(s)
[   15.002596] GHES: HEST is not enabled!
[   15.322142] HDLC line discipline maxframe=3D4096
[   15.324951] N_HDLC line discipline registered.
[   15.327514] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled

[   15.629232] serial: Freescale lpuart driver
[   15.631758] Initializing Nozomi driver 2.1d
[   15.634764] SyncLink GT
[   15.636358] SyncLink GT, tty major#251
[   15.638758] SyncLink GT no devices found
[   15.642887] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   15.647128] platform pc8736x_gpio.0: no device found
[   15.652229] nsc_gpio initializing
[   15.654342] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   15.658549] [drm] Initialized drm 1.1.0 20060810
[   15.664627] Phantom Linux Driver, version n0.9.8, init OK
[   15.676263] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   15.680183] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[   15.690633] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   15.698739] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.703934] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.720807] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   15.723888] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[   15.730214] wistron_btns: System unknown
[   15.736422] IR NEC protocol handler initialized
[   15.738564] IR JVC protocol handler initialized
[   15.741102] IR RC5 (streamzap) protocol handler initialized
[   15.744298] IR MCE Keyboard/mouse protocol handler initialized
[   15.746999] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver c=
hip loaded successfully
[   15.754300] applesmc: supported laptop not found!
[   15.756920] applesmc: driver init failed (ret=3D-19)!
[   15.770158] sbc60xxwdt: WDT driver for 60XX single board computer initia=
lised. timeout=3D30 sec (nowayout=3D1)
[   15.775020] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   15.778192] w83697hf_wdt: watchdog not found at address 0x2e
[   15.781223] w83697hf_wdt: No W83697HF/HG could be found
[   15.783646] w83877f_wdt: I/O address 0x0443 already in use
[   15.786580] w83977f_wdt: driver v1.00
[   15.788553] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   15.792682] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   15.797070] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   15.802009] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   15.812686] dell_wmi: No known WMI GUID found
[   15.815498] Initializing HPQ6001 module
[   15.821601] fujitsu_laptop: driver 0.6.0 successfully loaded
[   15.831475] u32 classifier
[   15.832904]     Performance counters on
[   15.834698]     Actions configured
[   15.837122] Netfilter messages via NETLINK v0.30.
[   15.840169] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[   15.843389] IPVS: Registered protocols (SCTP)
[   15.845996] IPVS: Connection hash table configured (size=3D4096, memory=
=3D32Kbytes)
[   15.849325] IPVS: Each connection entry needs 240 bytes at least
[   15.852393] IPVS: Creating netns size=3D1028 id=3D0
[   15.854941] IPVS: ipvs loaded.
[   15.856585] IPVS: [dh] scheduler registered.
[   15.858750] IPVS: [sed] scheduler registered.
[   15.861080] IPVS: [nq] scheduler registered.
[   15.863064] gre: GRE over IPv4 demultiplexor driver
[   15.866764] TCP: bic registered
[   15.868354] TCP: cubic registered
[   15.870077] TCP: highspeed registered
[   15.872164] TCP: lp registered
[   15.873853] TCP: illinois registered
[   15.875768] NET: Registered protocol family 17
[   15.881520] NET: Registered protocol family 15
[   15.883817] NET: Registered protocol family 5
[   15.886003] NET: Registered protocol family 9
[   15.888423] X25: Linux Version 0.2
[   15.890174] 8021q: 802.1Q VLAN Support v1.8
[   15.896431] DCCP: Activated CCID 2 (TCP-like)
[   15.898616] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   15.902238] 9pnet: Installing 9P2000 support
[   15.905334] NET: Registered protocol family 37
[   15.908638] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   15.913582]=20
[   15.913582] printing PIC contents
[   15.916193] ... PIC  IMR: ffff
[   15.917127] ... PIC  IRR: 1013
[   15.919320] ... PIC  ISR: 0000
[   15.920904] ... PIC ELCR: 0c00
[   15.922693] printing local APIC contents on CPU#0/0:
[   15.923609] ... APIC ID:      00000000 (0)
[   15.923609] ... APIC VERSION: 00050014
[   15.923609] ... APIC TASKPRI: 00000000 (00)
[   15.923609] ... APIC PROCPRI: 00000000
[   15.923609] ... APIC LDR: 01000000
[   15.923609] ... APIC DFR: ffffffff
[   15.923609] ... APIC SPIV: 000001ff
[   15.923609] ... APIC ISR field:
[   15.923609] 000000000000000000000000000000000000000000000000000000000000=
0000
[   15.923609] ... APIC TMR field:
[   15.923609] 000000000200000000000000000000000000000000000000000000000000=
0000
[   15.923609] ... APIC IRR field:
[   15.923609] 000000000000000000000000000000000000000000000000000000000000=
8000
[   15.923609] ... APIC ESR: 00000000
[   15.923609] ... APIC ICR: 000408f6
[   15.923609] ... APIC ICR2: 00000000
[   15.923609] ... APIC LVTT: 000000ef
[   15.923609] ... APIC LVTPC: 00010000
[   15.923609] ... APIC LVT0: 00010700
[   15.923609] ... APIC LVT1: 00000400
[   15.923609] ... APIC LVTERR: 000000fe
[   15.923609] ... APIC TMICT: 00005cb1
[   15.923609] ... APIC TMCCT: 00000000
[   15.923609] ... APIC TDCR: 00000003
[   15.923609]=20
[   15.975622] number of MP IRQ sources: 15.
[   15.977522] number of IO-APIC #0 registers: 24.
[   15.979854] testing the IO APIC.......................
[   15.982300] IO APIC #0......
[   15.983678] .... register #00: 00000000
[   15.985518] .......    : physical APIC id: 00
[   15.987930] .......    : Delivery Type: 0
[   15.989858] .......    : LTS          : 0
[   15.991720] .... register #01: 00170011
[   15.993646] .......     : max redirection entries: 17
[   15.996304] .......     : PRQ implemented: 0
[   15.998266] .......     : IO APIC version: 11
[   16.000489] .... register #02: 00000000
[   16.002642] .......     : arbitration: 00
[   16.004568] .... IRQ redirection table:
[   16.006521] 1    0    0   0   0    0    0    00
[   16.009262] 0    0    0   0   0    1    1    31
[   16.011563] 0    0    0   0   0    1    1    30
[   16.013743] 1    0    0   0   0    1    1    33
[   16.016305] 1    0    0   0   0    1    1    34
[   16.018535] 1    1    0   0   0    1    1    35
[   16.020763] 1    0    0   0   0    1    1    36
[   16.023453] 1    0    0   0   0    1    1    37
[   16.025764] 1    0    0   0   0    1    1    38
[   16.028123] 0    1    0   0   0    1    1    39
[   16.030846] 1    1    0   0   0    1    1    3A
[   16.033110] 1    1    0   0   0    1    1    3B
[   16.035279] 0    0    0   0   0    1    1    3C
[   16.037746] 1    0    0   0   0    1    1    3D
[   16.039945] 1    0    0   0   0    1    1    3E
[   16.042121] 1    0    0   0   0    1    1    3F
[   16.044719] 1    0    0   0   0    0    0    00
[   16.046975] 1    0    0   0   0    0    0    00
[   16.049150] 1    0    0   0   0    0    0    00
[   16.051722] 1    0    0   0   0    0    0    00
[   16.054113] 1    0    0   0   0    0    0    00
[   16.056427] 1    0    0   0   0    0    0    00
[   16.059109] 1    0    0   0   0    0    0    00
[   16.061401] 1    0    0   0   0    0    0    00
[   16.063627] IRQ to pin mappings:
[   16.065486] IRQ0 -> 0:2
[   16.067095] IRQ1 -> 0:1
[   16.068426] IRQ3 -> 0:3
[   16.069795] IRQ4 -> 0:4
[   16.071526] IRQ5 -> 0:5
[   16.073256] IRQ6 -> 0:6
[   16.074627] IRQ7 -> 0:7
[   16.076122] IRQ8 -> 0:8
[   16.077737] IRQ9 -> 0:9
[   16.079537] IRQ10 -> 0:10
[   16.081222] IRQ11 -> 0:11
[   16.082594] IRQ12 -> 0:12
[   16.084229] IRQ13 -> 0:13
[   16.085774] IRQ14 -> 0:14
[   16.087472] IRQ15 -> 0:15
[   16.088885] .................................... done.
[   16.091268] Using IPI Shortcut mode
[   16.094967] Loading compiled-in X.509 certificates
[   16.120676] Loaded X.509 cert 'Magrathea: Glacier signing key: 07005e0ff=
88212a57c52018cc0c40a90881d4a91'
[   16.130936] kworker/u2:0 (59) used greatest stack depth: 7128 bytes left
[   16.135001] kworker/u2:0 (58) used greatest stack depth: 7092 bytes left
[   16.142206] Key type trusted registered
[   16.144680] cryptomgr_probe (62) used greatest stack depth: 7080 bytes l=
eft
[   16.152904] Key type encrypted registered
[   16.160181] IMA: No TPM chip found, activating TPM-bypass!
[   16.169359] regulator-dummy: disabling
[   16.182159] Freeing unused kernel memory: 556K (c1e8f000 - c1f1a000)
[   16.187711] Write protecting the kernel text: 8812k
[   16.192784] Write protecting the kernel read-only data: 4256k
[   16.195513] NX-protecting the kernel data: 7572k
[   16.307384] random: init urandom read with 4 bits of entropy available
[   16.318919] kworker/u2:0 (80) used greatest stack depth: 7028 bytes left
[   16.390361] hostname (84) used greatest stack depth: 6896 bytes left
[   16.487985] sh (87) used greatest stack depth: 6752 bytes left
[   16.497910] sh (90) used greatest stack depth: 6468 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
[   16.717132] sh (97) used greatest stack depth: 6440 bytes left
[   16.795302] sh (104) used greatest stack depth: 6408 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   16.993557] sh (108) used greatest stack depth: 6376 bytes left
[   27.667412] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   28.954648] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
[   29.794189] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
[   30.540241] irda_setsockopt: not allowed to set MAXSDUSIZE for this sock=
et type!
plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertio=
n `loop->epoll_fd >=3D 0' failed.
[   78.263975] initctl (3194) used greatest stack depth: 6288 bytes left
/etc/lsb-base-logging.sh: line 5:  3203 Aborted                 plymouth --=
ping > /dev/null 2>&1
 * Asking all remaining processes to terminate...      =20
killall5[3206]: mount returned non-zero exit status
killall5[3206]: /proc not mounted, failed to mount.
/etc/lsb-base-logging.sh: line 5:  3210 Aborted                 plymouth --=
ping > /dev/null 2>&1

mount: proc has wrong device number or fs type proc not supported
killall5[3216]: mount returned non-zero exit status
killall5[3216]: /proc not mounted, failed to mount.
/etc/lsb-base-logging.sh: line 5:  3228 Aborted                 plymouth --=
ping > /dev/null 2>&1
 * All processes ended within 1 seconds....      =20

/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
mount: / is busy
 * Will now restart
[   88.611838] Unregister pv shared memory for cpu 0
[   88.618866] sbc60xxwdt: Watchdog timer is now disabled...
[   88.626059] ------------[ cut here ]------------
[   88.626064] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655 perf_s=
wevent_add+0x104/0x194()
[   88.626064] Modules linked in:
[   88.626064] CPU: 0 PID: 112 Comm: trinity-main Not tainted 3.14.0-rc5-02=
112-g3903b5b #240
[   88.626064]  00000000 c8d95e04 c187bedc c8d95e1c c105d6a7 c11107ac cf0b2=
c00 00000000
[   88.626064]  cfff3054 c8d95e2c c105d713 00000009 00000000 c8d95e3c c1110=
7ac cf0b2c00
[   88.626064]  cf019780 c8d95e58 c110c852 b824a5a9 00000013 cf019780 cf0b2=
c00 c1d1c0e0
[   88.626064] Call Trace:
[   88.626064]  [<c187bedc>] dump_stack+0x40/0x5e
[   88.626064]  [<c105d6a7>] warn_slowpath_common+0xa9/0xea
[   88.626064]  [<c11107ac>] ? perf_swevent_add+0x104/0x194
[   88.626064]  [<c105d713>] warn_slowpath_null+0x2b/0x3d
[   88.626064]  [<c11107ac>] perf_swevent_add+0x104/0x194
[   88.626064]  [<c110c852>] event_sched_in+0xed/0x26f
[   88.626064]  [<c110ca43>] group_sched_in+0x6f/0x23f
[   88.626064]  [<c110ceeb>] ctx_sched_in+0x2d8/0x33e
[   88.626064]  [<c110d920>] perf_event_sched_in+0x9f/0xb6
[   88.626064]  [<c110dc7e>] perf_event_context_sched_in+0xa9/0x100
[   88.626064]  [<c110dd19>] __perf_event_task_sched_in+0x44/0x2b9
[   88.626064]  [<c1095440>] finish_task_switch.constprop.54+0x1cd/0x210
[   88.626064]  [<c1888a0e>] __schedule+0x984/0xb7e
[   88.626064]  [<c10d5598>] ? tick_program_event+0x2c/0x3f
[   88.626064]  [<c108e022>] ? hrtimer_interrupt+0x1e8/0x348
[   88.626064]  [<c10a7dd9>] ? trace_hardirqs_off_caller+0x1c7/0x262
[   88.626064]  [<c1889191>] ? preempt_schedule_irq+0x70/0x142
[   88.626064]  [<c10ab350>] ? trace_hardirqs_on_caller+0x2be/0x41d
[   88.626064]  [<c18891d4>] preempt_schedule_irq+0xb3/0x142
[   88.626064]  [<c1890f4b>] need_resched+0x1c/0x21
[   88.626064]  [<c1899400>] ? sysenter_past_esp+0x35/0x67
[   88.626064] ---[ end trace f67d3e8be5e62621 ]---
[   88.726142] reboot: Restarting system
[   88.728256] reboot: machine restart
Elapsed time: 100
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
5-0308/3903b5b2bac33dcf80b46bc0cde1559e680b76d2/vmlinuz-3.14.0-rc5-02112-g3=
903b5b -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-r5-0308/linux-devel:devel-roam-i386-2=
01403080639/.vmlinuz-3903b5b2bac33dcf80b46bc0cde1559e680b76d2-2014030806565=
0-7-jaketown branch=3Dlinux-devel/devel-roam-i386-201403080639 BOOT_IMAGE=
=3D/kernel/i386-randconfig-r5-0308/3903b5b2bac33dcf80b46bc0cde1559e680b76d2=
/vmlinuz-3.14.0-rc5-02112-g3903b5b'  -initrd /kernel-tests/initrd/quantal-c=
ore-i386.cgz -m 256 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1,hostfwd=3Dtcp::17612-:22 -boot order=3Dnc -no-reboot -watchdog i6300es=
b -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-jaketown-45 -se=
rial file:/dev/shm/kboot/serial-quantal-jaketown-45 -daemonize -display non=
e -monitor null=20

--Nq2Wo0NMKNjxTN9z
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-r5-0308-3903b5b2bac33dcf80b46bc0cde1559e680b76d2-WARNING:---at----perf_swevent_add+-x-120202.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6MDQxNDg1NWZk
YzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OTpiaXNlY3QtbGludXgyCgoyMDE0LTAz
LTA4LTA3OjE3OjM3IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkg
Y29tcGlsaW5nCjUyMyByZWFsICAyMjIzIHVzZXIgIDE5NyBzeXMgIDQ2My4wMyUgY3B1IAlp
Mzg2LXJhbmRjb25maWctcjUtMDMwOAoyMDE0LTAzLTA4LTA3OjI5OjAyIDA0MTQ4NTVmZGM0
YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sg
ZXJyb3MgaW4gL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvMDQxNDg1NWZkYzRhNDBkYTA1MjIxZmM2MDYy
Y2NjYmMwYzMwZjE2OQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciAwNDE0ODU1ZmRj
NGE0MGRhMDUyMjFmYzYwNjJjY2NiYzBjMzBmMTY5CmdpdCBjaGVja291dCB2My4xMwpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgv
bGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA4MDYzOTpkOGVjMjZkN2Y4Mjg3
ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlOmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDgt
MDc6Mjk6MDUgZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZSBjb21w
aWxpbmcKMzI0IHJlYWwgIDIxMzkgdXNlciAgMTkwIHN5cyAgNzE3Ljk1JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1yNS0wMzA4CjIwMTQtMDMtMDgtMDc6MzU6MzAgZDhlYzI2ZDdmODI4N2Y1
Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZSBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJv
cyBpbiAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjUtMDMwOC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQy
MTBmMGU2NGJlCmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYzLjEzCmdpdCBjaGVj
a291dCB2My4xMgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLXI1LTAzMDgvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA4MDYz
OTo1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC1saW51
eDIKCjIwMTQtMDMtMDgtMDc6MzU6NDUgNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNj
YmQ2YTVjZWI1MiBjb21waWxpbmcKMzg0IHJlYWwgIDIxNDIgdXNlciAgMTk4IHN5cyAgNjA4
Ljk2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yNS0wMzA4CgoyMDE0LTAzLTA4LTA3OjQzOjU0
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC4uLgk3IFRFU1QgRkFJTFVSRQpbICAgODUu
MjY4NzcyXSBVbnJlZ2lzdGVyIHB2IHNoYXJlZCBtZW1vcnkgZm9yIGNwdSAwClsgICA4NS4y
NzQ0NTVdIHNiYzYweHh3ZHQ6IFdhdGNoZG9nIHRpbWVyIGlzIG5vdyBkaXNhYmxlZC4uLgpb
ICAgODUuMjc3MTI3XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
IDg1LjI3ODAyM10gV0FSTklORzogQ1BVOiAwIFBJRDogMTEyIGF0IC9rZXJuZWwtdGVzdHMv
bGludXgyL2tlcm5lbC9ldmVudHMvY29yZS5jOjU1ODggcGVyZl9zd2V2ZW50X2FkZCsweDEw
NC8weDE5NCgpClsgICA4NS4yNzgwMjNdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgODUuMjc4
MDIzXSBDUFU6IDAgUElEOiAxMTIgQ29tbTogdHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMu
MTIuMCAjMTMzClsgICA4NS4yNzgwMjNdICAwMDAwMDAwMCBjOGVjYmUwMCBjMTgzOTllOCBj
OGVjYmUxOCBjMTA1OTFiMyBjMTEwNzNmZCBjZjdmMWMwMCAwMDAwMDAwMApbICAgODUuMjc4
MDIzXSAgY2Y3NTgyODAgYzhlY2JlMjggYzEwNTkyMWYgMDAwMDAwMDkgMDAwMDAwMDAgYzhl
Y2JlMzggYzExMDczZmQgY2Y3NTgyODAKWyAgIDg1LjI3ODAyM10gIGNmN2YxYzAwIGM4ZWNi
ZTU4IGMxMTAzNTI2IGNmZmYzMDU0IGQ3NDkzNWFjIDAwMDAwMDEyIGNmNzU4MjgwIGNmN2Yx
YzAwClsgICA4NS4yNzgwMjNdIENhbGwgVHJhY2U6ClsgICA4NS4yNzgwMjNdICBbPGMxODM5
OWU4Pl0gZHVtcF9zdGFjaysweDQwLzB4NWUKWyAgIDg1LjI3ODAyM10gIFs8YzEwNTkxYjM+
XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweGE5LzB4ZWEKWyAgIDg1LjI3ODAyM10gIFs8YzEx
MDczZmQ+XSA/IHBlcmZfc3dldmVudF9hZGQrMHgxMDQvMHgxOTQKWyAgIDg1LjI3ODAyM10g
IFs8YzEwNTkyMWY+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyYi8weDNkClsgICA4NS4yNzgw
MjNdICBbPGMxMTA3M2ZkPl0gcGVyZl9zd2V2ZW50X2FkZCsweDEwNC8weDE5NApbICAgODUu
Mjc4MDIzXSAgWzxjMTEwMzUyNj5dIGV2ZW50X3NjaGVkX2luKzB4ZGIvMHgyM2MKWyAgIDg1
LjI3ODAyM10gIFs8YzExMDM2ZjY+XSBncm91cF9zY2hlZF9pbisweDZmLzB4MjNmClsgICA4
NS4yNzgwMjNdICBbPGMxMGJlNjlmPl0gPyB0cmFjZV9oYXJkaXJxc19vZmYrMHgyNy8weDM3
ClsgICA4NS4yNzgwMjNdICBbPGMxMTAzYTQ0Pl0gY3R4X3NjaGVkX2luKzB4MTdlLzB4MzNl
ClsgICA4NS4yNzgwMjNdICBbPGMxMTA0NGNjPl0gcGVyZl9ldmVudF9zY2hlZF9pbisweDUz
LzB4YjYKWyAgIDg1LjI3ODAyM10gIFs8YzExMDQ4NzY+XSBwZXJmX2V2ZW50X2NvbnRleHRf
c2NoZWRfaW4rMHhhOS8weDEwMApbICAgODUuMjc4MDIzXSAgWzxjMTEwNDkxMT5dIF9fcGVy
Zl9ldmVudF90YXNrX3NjaGVkX2luKzB4NDQvMHgyYjkKWyAgIDg1LjI3ODAyM10gIFs8YzEw
OTMyNTY+XSBmaW5pc2hfdGFza19zd2l0Y2guY29uc3Rwcm9wLjUxKzB4MWE4LzB4MWMzClsg
ICA4NS4yNzgwMjNdICBbPGMxODRhZjljPl0gX19zY2hlZHVsZSsweDhhMS8weGE4MwpbICAg
ODUuMjc4MDIzXSAgWzxjMTg0Yjc0Mz5dID8gcHJlZW1wdF9zY2hlZHVsZV9pcnErMHhjMi8w
eDE0NwpbICAgODUuMjc4MDIzXSAgWzxjMTg0Yjc0Mz5dIHByZWVtcHRfc2NoZWR1bGVfaXJx
KzB4YzIvMHgxNDcKWyAgIDg1LjI3ODAyM10gIFs8YzE4NGU1OTQ+XSBuZWVkX3Jlc2NoZWQr
MHgxYi8weDFmClsgICA4NS4yNzgwMjNdICBbPGMxODU2YzQwPl0gPyBzeXNlbnRlcl9wYXN0
X2VzcCsweDM1LzB4NjcKWyAgIDg1LjI3ODAyM10gLS0tWyBlbmQgdHJhY2UgMzQzMmI1ZWI3
NmU0YzY1ZiBdLS0tClsgICA4NS4zMjc3NjNdIHJlYm9vdDogUmVzdGFydGluZyBzeXN0ZW0K
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFj
ZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1YW50YWwtc25iLTE5OjIwMTQwMzA4MDc0NTMz
OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUt
MDMwOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1
YW50YWwtc25iLTI3OjIwMTQwMzA4MDc0NTM3OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFj
ZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1YW50YWwtc25iLTI5OjIwMTQwMzA4MDc0NTM3
OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUt
MDMwOC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1
YW50YWwtc25iLTIxOjIwMTQwMzA4MDc0NTQzOmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoK
Nzo0OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMDggMDc6
NDU6NTcgUkVQRUFUIENPVU5UOiAzNyAgIyAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTIKZ2l0IGNoZWNrb3V0
IHYzLjExCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OjZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2U6YmlzZWN0LWxpbnV4MgoK
MjAxNC0wMy0wOC0wNzo0NjowNSA2ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRj
MTkyMTNlIGNvbXBpbGluZwozNTAgcmVhbCAgMjA2NyB1c2VyICAxOTMgc3lzICA2NDQuMTQl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKCjIwMTQtMDMtMDgtMDc6NTI6MzYgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLi4uLiBURVNUIEZBSUxVUkUKWyAgIDgzLjkxMzU1
MF0gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgODMuOTE4ODAx
XSBzYmM2MHh4d2R0OiBXYXRjaGRvZyB0aW1lciBpcyBub3cgZGlzYWJsZWQuLi4KWyAgIDgz
LjkyMjM3Nl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA4My45
MjMwOThdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDExMiBhdCAva2VybmVsLXRlc3RzL2xpbnV4
Mi9rZXJuZWwvZXZlbnRzL2NvcmUuYzo1NDg1IHBlcmZfc3dldmVudF9hZGQrMHgxMDEvMHgx
OTEoKQpbICAgODMuOTIzMDk4XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDgzLjkyMzA5OF0g
Q1BVOiAwIFBJRDogMTEyIENvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjExLjAg
IzEzNApbICAgODMuOTIzMDk4XSAgMDAwMDAwMDAgYzdlY2JlM2MgYzE4MDAwY2EgYzdlY2Jl
NTQgYzEwNGQ4ZTkgYzEwZjgxNDggY2Y3ZTM4MDAgMDAwMDAwMDAKWyAgIDgzLjkyMzA5OF0g
IGMwMWVkNDgwIGM3ZWNiZTY0IGMxMDRkOTU1IDAwMDAwMDA5IDAwMDAwMDAwIGM3ZWNiZTc0
IGMxMGY4MTQ4IGMwMWVkNDgwClsgICA4My45MjMwOThdICBjZjdlMzgwMCBjN2VjYmU5NCBj
MTBmNDRjNCBjZmZmMzA1NCA2YmFiOTAzNyAwMDAwMDAxMiBjMDFlZDQ4MCBjZjdlMzgwMApb
ICAgODMuOTIzMDk4XSBDYWxsIFRyYWNlOgpbICAgODMuOTIzMDk4XSAgWzxjMTgwMDBjYT5d
IGR1bXBfc3RhY2srMHg0MC8weDVlClsgICA4My45MjMwOThdICBbPGMxMDRkOGU5Pl0gd2Fy
bl9zbG93cGF0aF9jb21tb24rMHhhOS8weGVhClsgICA4My45MjMwOThdICBbPGMxMGY4MTQ4
Pl0gPyBwZXJmX3N3ZXZlbnRfYWRkKzB4MTAxLzB4MTkxClsgICA4My45MjMwOThdICBbPGMx
MDRkOTU1Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MmIvMHgzZApbICAgODMuOTIzMDk4XSAg
WzxjMTBmODE0OD5dIHBlcmZfc3dldmVudF9hZGQrMHgxMDEvMHgxOTEKWyAgIDgzLjkyMzA5
OF0gIFs8YzEwZjQ0YzQ+XSBldmVudF9zY2hlZF9pbisweGRiLzB4MjNjClsgICA4My45MjMw
OThdICBbPGMxMGY0Njk0Pl0gZ3JvdXBfc2NoZWRfaW4rMHg2Zi8weDIyOApbICAgODMuOTIz
MDk4XSAgWzxjMTBhOTY3Zj5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4MjcvMHgzNwpbICAg
ODMuOTIzMDk4XSAgWzxjMTBmNDljOD5dIGN0eF9zY2hlZF9pbisweDE3Yi8weDMyYQpbICAg
ODMuOTIzMDk4XSAgWzxjMTBmNTQ1Mz5dIHBlcmZfZXZlbnRfc2NoZWRfaW4rMHg1My8weGI2
ClsgICA4My45MjMwOThdICBbPGMxMGY1N2ZkPl0gcGVyZl9ldmVudF9jb250ZXh0X3NjaGVk
X2luKzB4YTkvMHgxMDAKWyAgIDgzLjkyMzA5OF0gIFs8YzEwZjU4OTg+XSBfX3BlcmZfZXZl
bnRfdGFza19zY2hlZF9pbisweDQ0LzB4MmI5ClsgICA4My45MjMwOThdICBbPGMxMDg3OWEy
Pl0gZmluaXNoX3Rhc2tfc3dpdGNoLmNvbnN0cHJvcC40NisweDFhOC8weDFjMwpbICAgODMu
OTIzMDk4XSAgWzxjMTgxMDljMj5dIF9fc2NoZWR1bGUrMHg4YTEvMHhhODMKWyAgIDgzLjky
MzA5OF0gIFs8YzE4MTBkNmI+XSA/IHNjaGVkdWxlKzB4MWQvMHgyZApbICAgODMuOTIzMDk4
XSAgWzxjMTgxMGQ2Yj5dIHNjaGVkdWxlKzB4MWQvMHgyZApbICAgODMuOTIzMDk4XSAgWzxj
MTgxM2RhZT5dIHdvcmtfcmVzY2hlZCsweDUvMHgzMApbICAgODMuOTIzMDk4XSAtLS1bIGVu
ZCB0cmFjZSAyZDBkZGI0ODRmYTgwN2Y5IF0tLS0KWyAgIDgzLjk2MTgxOV0gcmVib290OiBS
ZXN0YXJ0aW5nIHN5c3RlbQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzZlNDY2
NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1zbmIt
NDY6MjAxNDAzMDgwNzU0MDk6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6OgowOjI6MSBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjExCmdpdCBj
aGVja291dCB2My4xMApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDgvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA4
MDYzOTo4YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2OmJpc2VjdC1s
aW51eDIKCjIwMTQtMDMtMDgtMDc6NTU6MTggOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3
ZjNhYzlmMDc5ZTM3NiBjb21waWxpbmcKMzkwIHJlYWwgIDIwMjMgdXNlciAgMTg1IHN5cyAg
NTY2LjQ3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yNS0wMzA4CgoyMDE0LTAzLTA4LTA4OjAy
OjQxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC4uLgkxCTIJMyBURVNUIEZBSUxVUkUK
WyAgMTAzLjM1MDc3OF0gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApb
ICAxMDMuMzUzNjcyXSBzYmM2MHh4d2R0OiBXYXRjaGRvZyB0aW1lciBpcyBub3cgZGlzYWJs
ZWQuLi4KWyAgMTAzLjM2ODg0MF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0t
LS0tClsgIDEwMy4zNjk2NzZdIFdBUk5JTkc6IGF0IC9rZXJuZWwtdGVzdHMvbGludXgyL2tl
cm5lbC9ldmVudHMvY29yZS5jOjUyNzQgcGVyZl9zd2V2ZW50X2FkZCsweDEwMS8weDE5MSgp
ClsgIDEwMy4zNjk2NzZdIE1vZHVsZXMgbGlua2VkIGluOgpbICAxMDMuMzY5Njc2XSBDUFU6
IDAgUElEOiAxMTAgQ29tbTogdHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMuMTAuMCAjMTM1
ClsgIDEwMy4zNjk2NzZdICAwMDAwMDAwMCBjY2ExYmUzYyBjMTdkZjk3NiBjY2ExYmU1NCBj
MTA0NTBiZSBjMTBlNjcxYyBjZjdjOTQwMCAwMDAwMDAwMApbICAxMDMuMzY5Njc2XSAgY2Y3
NjY2ODAgY2NhMWJlNjQgYzEwNDUxMmEgMDAwMDAwMDkgMDAwMDAwMDAgY2NhMWJlNzQgYzEw
ZTY3MWMgY2Y3NjY2ODAKWyAgMTAzLjM2OTY3Nl0gIGNmN2M5NDAwIGNjYTFiZTk0IGMxMGU5
NzNlIGNmZmYzMDE0IGE4MGMyOWYyIDAwMDAwMDE1IGNmNzY2NjgwIGNmN2M5NDAwClsgIDEw
My4zNjk2NzZdIENhbGwgVHJhY2U6ClsgIDEwMy4zNjk2NzZdICBbPGMxN2RmOTc2Pl0gZHVt
cF9zdGFjaysweDMyLzB4NDIKWyAgMTAzLjM2OTY3Nl0gIFs8YzEwNDUwYmU+XSB3YXJuX3Ns
b3dwYXRoX2NvbW1vbisweDljLzB4ZGQKWyAgMTAzLjM2OTY3Nl0gIFs8YzEwZTY3MWM+XSA/
IHBlcmZfc3dldmVudF9hZGQrMHgxMDEvMHgxOTEKWyAgMTAzLjM2OTY3Nl0gIFs8YzEwNDUx
MmE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyYi8weDNkClsgIDEwMy4zNjk2NzZdICBbPGMx
MGU2NzFjPl0gcGVyZl9zd2V2ZW50X2FkZCsweDEwMS8weDE5MQpbICAxMDMuMzY5Njc2XSAg
WzxjMTBlOTczZT5dIGV2ZW50X3NjaGVkX2luKzB4ZGIvMHgyM2MKWyAgMTAzLjM2OTY3Nl0g
IFs8YzEwZTk5MGU+XSBncm91cF9zY2hlZF9pbisweDZmLzB4MWZiClsgIDEwMy4zNjk2NzZd
ICBbPGMxMDlmOGQ3Pl0gPyB0cmFjZV9oYXJkaXJxc19vZmYrMHgyNy8weDM3ClsgIDEwMy4z
Njk2NzZdICBbPGMxMGU5YzE1Pl0gY3R4X3NjaGVkX2luKzB4MTdiLzB4MzJhClsgIDEwMy4z
Njk2NzZdICBbPGMxMGVhNmEwPl0gcGVyZl9ldmVudF9zY2hlZF9pbisweDUzLzB4YjYKWyAg
MTAzLjM2OTY3Nl0gIFs8YzEwZWFhZTk+XSBwZXJmX2V2ZW50X2NvbnRleHRfc2NoZWRfaW4r
MHhhOS8weDEwMApbICAxMDMuMzY5Njc2XSAgWzxjMTBlYWI4ND5dIF9fcGVyZl9ldmVudF90
YXNrX3NjaGVkX2luKzB4NDQvMHgyYmIKWyAgMTAzLjM2OTY3Nl0gIFs8YzEwMDExY2M+XSA/
IF9fc3dpdGNoX3RvKzB4M2ZiLzB4YTA3ClsgIDEwMy4zNjk2NzZdICBbPGMxMDg0MGQ0Pl0g
ZmluaXNoX3Rhc2tfc3dpdGNoLmNvbnN0cHJvcC40OSsweDFhOC8weDFjMwpbICAxMDMuMzY5
Njc2XSAgWzxjMTdlYzdlNz5dIF9fc2NoZWR1bGUrMHg4OTMvMHhhNzUKWyAgMTAzLjM2OTY3
Nl0gIFs8YzEwNGZlMmY+XSA/IF9fbG9jYWxfYmhfZW5hYmxlKzB4MTMwLzB4MTU2ClsgIDEw
My4zNjk2NzZdICBbPGMxMDlmODE1Pl0gPyB0cmFjZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4
MWM3LzB4MjYyClsgIDEwMy4zNjk2NzZdICBbPGMxMDlmOGQ3Pl0gPyB0cmFjZV9oYXJkaXJx
c19vZmYrMHgyNy8weDM3ClsgIDEwMy4zNjk2NzZdICBbPGMxMGRiZDA4Pl0gPyByY3VfaXJx
X2V4aXQrMHgxMDkvMHgxNTMKWyAgMTAzLjM2OTY3Nl0gIFs8YzEwOWY4MTU+XSA/IHRyYWNl
X2hhcmRpcnFzX29mZl9jYWxsZXIrMHgxYzcvMHgyNjIKWyAgMTAzLjM2OTY3Nl0gIFs8YzE3
ZWNiOTA+XSBzY2hlZHVsZSsweDFkLzB4MmQKWyAgMTAzLjM2OTY3Nl0gIFs8YzE3ZWZhY2U+
XSB3b3JrX3Jlc2NoZWQrMHg1LzB4MzAKWyAgMTAzLjM2OTY3Nl0gLS0tWyBlbmQgdHJhY2Ug
MDE1YTdmNTBmNmUxYzJlYSBdLS0tClsgIDEwMy41MTU4MTJdIFJlc3RhcnRpbmcgc3lzdGVt
Lgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2
ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0yMToyMDE0MDMw
ODA4MDUwMjppMzg2LXJhbmRjb25maWctcjUtMDMwODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXI1LTAzMDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9k
bWVzZy1xdWFudGFsLXNuYi00MToyMDE0MDMwODA4MDUwMzppMzg2LXJhbmRjb25maWctcjUt
MDMwODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvOGJiNDk1ZTNmMDI0MDFl
ZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFsLXNuYi00MzoyMDE0MDMw
ODA4MDUwNTppMzg2LXJhbmRjb25maWctcjUtMDMwODo6CjQ6MzozIGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTAKZ2l0IGNoZWNrb3V0IHYz
LjkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1y
NS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6YzFiZTVh
NWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMTpiaXNlY3QtbGludXgyCgoyMDE0
LTAzLTA4LTA4OjA2OjEwIGMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRh
ZDEgY29tcGlsaW5nCjE4MiByZWFsICAxOTQ4IHVzZXIgIDE4MSBzeXMgIDExNjUuNTMlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKCjIwMTQtMDMtMDgtMDg6MTE6MjkgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy45LjAuLi4uCTEuIFRFU1QgRkFJTFVSRQpbICAgNzMuMTY3NTQ3
XSBVbnJlZ2lzdGVyIHB2IHNoYXJlZCBtZW1vcnkgZm9yIGNwdSAwClsgICA3My4xNjg3MDld
IHNiYzYweHh3ZHQ6IFdhdGNoZG9nIHRpbWVyIGlzIG5vdyBkaXNhYmxlZC4uLgpbICAgNzMu
MTcwMzE1XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDczLjE3
MTExNF0gV0FSTklORzogYXQgL2tlcm5lbC10ZXN0cy9saW51eDIva2VybmVsL2V2ZW50cy9j
b3JlLmM6NTIwMSBwZXJmX3N3ZXZlbnRfYWRkKzB4MTAxLzB4MTkxKCkKWyAgIDczLjE3MTEx
NF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICA3My4xNzExMTRdIFBpZDogMTExLCBjb21tOiB0
cmluaXR5LW1haW4gTm90IHRhaW50ZWQgMy45LjAgIzEzNgpbICAgNzMuMTcxMTE0XSBDYWxs
IFRyYWNlOgpbICAgNzMuMTcxMTE0XSAgWzxjMTA0NDliYz5dIHdhcm5fc2xvd3BhdGhfY29t
bW9uKzB4OWMvMHhkZApbICAgNzMuMTcxMTE0XSAgWzxjMTBkZDJhMD5dID8gcGVyZl9zd2V2
ZW50X2FkZCsweDEwMS8weDE5MQpbICAgNzMuMTcxMTE0XSAgWzxjMTA0NGEyOD5dIHdhcm5f
c2xvd3BhdGhfbnVsbCsweDJiLzB4M2QKWyAgIDczLjE3MTExNF0gIFs8YzEwZGQyYTA+XSBw
ZXJmX3N3ZXZlbnRfYWRkKzB4MTAxLzB4MTkxClsgICA3My4xNzExMTRdICBbPGMxMGRmYmUx
Pl0gZXZlbnRfc2NoZWRfaW4rMHhkYi8weDIzYwpbICAgNzMuMTcxMTE0XSAgWzxjMTBkZmRi
MT5dIGdyb3VwX3NjaGVkX2luKzB4NmYvMHgxZmIKWyAgIDczLjE3MTExNF0gIFs8YzEwOTZk
Yzg+XSA/IHRyYWNlX2hhcmRpcnFzX29mZisweDI3LzB4MzcKWyAgIDczLjE3MTExNF0gIFs8
YzEwZTAyMDg+XSBjdHhfc2NoZWRfaW4rMHgyY2IvMHgzMmEKWyAgIDczLjE3MTExNF0gIFs8
YzEwZTBiOGY+XSBwZXJmX2V2ZW50X3NjaGVkX2luKzB4OWYvMHhiNgpbICAgNzMuMTcxMTE0
XSAgWzxjMTBlMGY4Yz5dIHBlcmZfZXZlbnRfY29udGV4dF9zY2hlZF9pbisweGE5LzB4MTAw
ClsgICA3My4xNzExMTRdICBbPGMxMGUxMDI3Pl0gX19wZXJmX2V2ZW50X3Rhc2tfc2NoZWRf
aW4rMHg0NC8weDJiYgpbICAgNzMuMTcxMTE0XSAgWzxjMTAwMjE0Nz5dID8gX19zd2l0Y2hf
dG8rMHgzZmIvMHhhMDcKWyAgIDczLjE3MTExNF0gIFs8YzEwN2RjODU+XSBmaW5pc2hfdGFz
a19zd2l0Y2guY29uc3Rwcm9wLjQ3KzB4MWE4LzB4MWMzClsgICA3My4xNzExMTRdICBbPGMx
N2M3ZThkPl0gX19zY2hlZHVsZSsweDg5My8weGE3NQpbICAgNzMuMTcxMTE0XSAgWzxjMTdj
ODIzNj5dID8gc2NoZWR1bGUrMHgxZC8weDJkClsgICA3My4xNzExMTRdICBbPGMxN2M4MjM2
Pl0gc2NoZWR1bGUrMHgxZC8weDJkClsgICA3My4xNzExMTRdICBbPGMxN2NiMTE2Pl0gd29y
a19yZXNjaGVkKzB4NS8weDMwClsgICA3My4xNzExMTRdIC0tLVsgZW5kIHRyYWNlIGE4MjY4
Y2JiMDc1ZGUxYjkgXS0tLQpbICAgNzMuMjAwNjM1XSBSZXN0YXJ0aW5nIHN5c3RlbS4KL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5
NzllYjY2ZGFmYTI0YWQxL2RtZXNnLXF1YW50YWwtc25iLTc6MjAxNDAzMDgwODE0MDM6aTM4
Ni1yYW5kY29uZmlnLXI1LTAzMDg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4
L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvZG1lc2ctcXVhbnRh
bC1yb2FtLTE0OjIwMTQwMzA4MDgxNDE2OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjMuOS4w
OjEzNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2MxYmU1YTViMWIzNTVkNDBl
NmNmNzljYzk3OWViNjZkYWZhMjRhZDEvZG1lc2ctcXVhbnRhbC1zbmItMTk6MjAxNDAzMDgw
ODE0MjI6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yNS0wMzA4L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvZG1l
c2ctcXVhbnRhbC1zbmItMTQ6MjAxNDAzMDgwODE0MjY6aTM4Ni1yYW5kY29uZmlnLXI1LTAz
MDg6OgoxOjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29t
bWl0IHYzLjkKZ2l0IGNoZWNrb3V0IHYzLjgKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0t
aTM4Ni0yMDE0MDMwODA2Mzk6MTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNi
MTIwMDpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTA4OjE0OjM0IDE5Zjk0OWY1MjU5OWJh
N2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAgY29tcGlsaW5nCjEyNCByZWFsICAxNzYwIHVz
ZXIgIDE1OSBzeXMgIDE1NDMuNDIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKCjIw
MTQtMDMtMDgtMDg6MTY6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy44LjAuCTMuCTQgVEVT
VCBGQUlMVVJFClsgICA4NC4wNzY2MDldIFVucmVnaXN0ZXIgcHYgc2hhcmVkIG1lbW9yeSBm
b3IgY3B1IDAKWyAgIDg0LjA4MzY2MF0gc2JjNjB4eHdkdDogV2F0Y2hkb2cgdGltZXIgaXMg
bm93IGRpc2FibGVkLi4uClsgICA4NC4wOTU2MDddIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgODQuMDk2Mzk2XSBXQVJOSU5HOiBhdCAva2VybmVsLXRlc3Rz
L2xpbnV4Mi9rZXJuZWwvZXZlbnRzL2NvcmUuYzo1MTk2IHBlcmZfc3dldmVudF9hZGQrMHgx
MDEvMHgxOTEoKQpbICAgODQuMDk2Mzk2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDg0LjA5
NjM5Nl0gUGlkOiAxMDQsIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjguMCAj
MTM3ClsgICA4NC4wOTYzOTZdIENhbGwgVHJhY2U6ClsgICA4NC4wOTYzOTZdICBbPGMxMDQz
OWMwPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg5Yy8weGRiClsgICA4NC4wOTYzOTZdICBb
PGMxMGQzMjNjPl0gPyBwZXJmX3N3ZXZlbnRfYWRkKzB4MTAxLzB4MTkxClsgICA4NC4wOTYz
OTZdICBbPGMxMDQzYTJhPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MmIvMHgzZApbICAgODQu
MDk2Mzk2XSAgWzxjMTBkMzIzYz5dIHBlcmZfc3dldmVudF9hZGQrMHgxMDEvMHgxOTEKWyAg
IDg0LjA5NjM5Nl0gIFs8YzEwZDVjNGU+XSBldmVudF9zY2hlZF9pbisweGRiLzB4MjNjClsg
ICA4NC4wOTYzOTZdICBbPGMxMGQ1ZTFlPl0gZ3JvdXBfc2NoZWRfaW4rMHg2Zi8weDFmYgpb
ICAgODQuMDk2Mzk2XSAgWzxjMTA5MmIxZT5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4Mjcv
MHgzNwpbICAgODQuMDk2Mzk2XSAgWzxjMTBkNjEyNT5dIGN0eF9zY2hlZF9pbisweDE3Yi8w
eDMyYQpbICAgODQuMDk2Mzk2XSAgWzxjMTBkNmJiMD5dIHBlcmZfZXZlbnRfc2NoZWRfaW4r
MHg1My8weGI2ClsgICA4NC4wOTYzOTZdICBbPGMxMGQ2ZmY5Pl0gcGVyZl9ldmVudF9jb250
ZXh0X3NjaGVkX2luKzB4YTkvMHgxMDAKWyAgIDg0LjA5NjM5Nl0gIFs8YzEwZDcwOTQ+XSBf
X3BlcmZfZXZlbnRfdGFza19zY2hlZF9pbisweDQ0LzB4MmJiClsgICA4NC4wOTYzOTZdICBb
PGMxMDAyMTQ3Pl0gPyBfX3N3aXRjaF90bysweDNmYi8weGEwNwpbICAgODQuMDk2Mzk2XSAg
WzxjMTA3YzczYj5dIGZpbmlzaF90YXNrX3N3aXRjaC5jb25zdHByb3AuNDUrMHgxYTgvMHgx
YzMKWyAgIDg0LjA5NjM5Nl0gIFs8YzE3MGU5MWI+XSBfX3NjaGVkdWxlKzB4ODkzLzB4YTQy
ClsgICA4NC4wOTYzOTZdICBbPGMxNzBlYzkxPl0gPyBzY2hlZHVsZSsweDFkLzB4MmQKWyAg
IDg0LjA5NjM5Nl0gIFs8YzE3MGVjOTE+XSBzY2hlZHVsZSsweDFkLzB4MmQKWyAgIDg0LjA5
NjM5Nl0gIFs8YzE3MTE5ZjY+XSB3b3JrX3Jlc2NoZWQrMHg1LzB4MzAKWyAgIDg0LjA5NjM5
Nl0gLS0tWyBlbmQgdHJhY2UgOGNjNmMyMTY1NWRjNzU3NCBdLS0tClsgICA4NC4xNDQ2Nzdd
IFJlc3RhcnRpbmcgc3lzdGVtLgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzE5
Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAvZG1lc2ctcXVhbnRhbC1q
YWtldG93bi0xMjoyMDE0MDMwODA4MTg0MTppMzg2LXJhbmRjb25maWctcjUtMDMwODo6CjA6
MTo1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA4IDA4OjE5
OjAwIFJFUEVBVCBDT1VOVDogNjAgICMgL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2Vj
dC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjgKZ2l0IGNoZWNrb3V0IHYz
LjcKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1y
NS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6Mjk1OTQ0
MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZTpiaXNlY3QtbGludXgyCgoyMDE0
LTAzLTA4LTA4OjE5OjI1IDI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2
MGUgY29tcGlsaW5nCjEyMSByZWFsICAxNjkwIHVzZXIgIDE1MyBzeXMgIDE1MjQuNjIlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKCjIwMTQtMDMtMDgtMDg6MjE6NTQgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy43LjAuLgkxCTIgVEVTVCBGQUlMVVJFClsgICA3NC4xMTM3Nzdd
IFVucmVnaXN0ZXIgcHYgc2hhcmVkIG1lbW9yeSBmb3IgY3B1IDAKWyAgIDc0LjEyMzM3MF0g
c2JjNjB4eHdkdDogV2F0Y2hkb2cgdGltZXIgaXMgbm93IGRpc2FibGVkLi4uClsgICA3NC4x
MjcyMDhdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgNzQuMTI3
OTg0XSBXQVJOSU5HOiBhdCAva2VybmVsLXRlc3RzL2xpbnV4Mi9rZXJuZWwvZXZlbnRzL2Nv
cmUuYzo1MTg3IHBlcmZfc3dldmVudF9hZGQrMHgxMDEvMHgxOTEoKQpbICAgNzQuMTI4MTA4
XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDc0LjEyODEwOF0gUGlkOiAxMDQsIGNvbW06IHRy
aW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjcuMCAjMTM4ClsgICA3NC4xMjgxMDhdIENhbGwg
VHJhY2U6ClsgICA3NC4xMjgxMDhdICBbPGMxMDQzMWFmPl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHg5Yy8weGRiClsgICA3NC4xMjgxMDhdICBbPGMxMGQxYjQ4Pl0gPyBwZXJmX3N3ZXZl
bnRfYWRkKzB4MTAxLzB4MTkxClsgICA3NC4xMjgxMDhdICBbPGMxMDQzMjE5Pl0gd2Fybl9z
bG93cGF0aF9udWxsKzB4MmIvMHgzZApbICAgNzQuMTI4MTA4XSAgWzxjMTBkMWI0OD5dIHBl
cmZfc3dldmVudF9hZGQrMHgxMDEvMHgxOTEKWyAgIDc0LjEyODEwOF0gIFs8YzEwZDQ1NTk+
XSBldmVudF9zY2hlZF9pbisweGRiLzB4MjNjClsgICA3NC4xMjgxMDhdICBbPGMxMGQ0NzI5
Pl0gZ3JvdXBfc2NoZWRfaW4rMHg2Zi8weDFmYgpbICAgNzQuMTI4MTA4XSAgWzxjMTA5MWZk
Mj5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4MjcvMHgzNwpbICAgNzQuMTI4MTA4XSAgWzxj
MTBkNGEzMD5dIGN0eF9zY2hlZF9pbisweDE3Yi8weDMyYQpbICAgNzQuMTI4MTA4XSAgWzxj
MTBkNTRiYj5dIHBlcmZfZXZlbnRfc2NoZWRfaW4rMHg1My8weGI2ClsgICA3NC4xMjgxMDhd
ICBbPGMxMGQ1OTA0Pl0gcGVyZl9ldmVudF9jb250ZXh0X3NjaGVkX2luKzB4YTkvMHgxMDAK
WyAgIDc0LjEyODEwOF0gIFs8YzEwZDU5OWY+XSBfX3BlcmZfZXZlbnRfdGFza19zY2hlZF9p
bisweDQ0LzB4MmJiClsgICA3NC4xMjgxMDhdICBbPGMxMDAyMTQzPl0gPyBfX3N3aXRjaF90
bysweDNmYi8weGEwNwpbICAgNzQuMTI4MTA4XSAgWzxjMTA3YmNlZj5dIGZpbmlzaF90YXNr
X3N3aXRjaC5jb25zdHByb3AuNDUrMHgxYTgvMHgxYzMKWyAgIDc0LjEyODEwOF0gIFs8YzE2
ZTBlNTM+XSBfX3NjaGVkdWxlKzB4ODkzLzB4YTQyClsgICA3NC4xMjgxMDhdICBbPGMxNmUx
NTkzPl0gPyBwcmVlbXB0X3NjaGVkdWxlX2lycSsweGMyLzB4MTQ3ClsgICA3NC4xMjgxMDhd
ICBbPGMxNmUxNTkzPl0gcHJlZW1wdF9zY2hlZHVsZV9pcnErMHhjMi8weDE0NwpbICAgNzQu
MTI4MTA4XSAgWzxjMTZlM2UyND5dIG5lZWRfcmVzY2hlZCsweDFiLzB4MWYKWyAgIDc0LjEy
ODEwOF0gIFs8YzE2ZWJmMDA+XSA/IHN5c2VudGVyX3Bhc3RfZXNwKzB4MzUvMHg2NwpbICAg
NzQuMTI4MTA4XSAtLS1bIGVuZCB0cmFjZSBiYjQ5MzM2MDEzOGRhN2M4IF0tLS0KWyAgIDc0
LjE0NTg2N10gUmVzdGFydGluZyBzeXN0ZW0uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDgvMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVzZy1x
dWFudGFsLWF0aGVucy0yODoyMDE0MDMwODA4MjMzMDppMzg2LXJhbmRjb25maWctcjUtMDMw
ODozLjcuMDoxMzgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC8yOTU5NDQwNGQ3
ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBlL2RtZXNnLXF1YW50YWwtYXRoZW5zLTM2
OjIwMTQwMzA4MDgyMzI4OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjMuNy4wOjEzOAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThj
NDNkY2M1Mzk3MGM2MGUvZG1lc2ctcXVhbnRhbC14Z3dvLTQ6MjAxNDAzMDgwODIzNDc6aTM4
Ni1yYW5kY29uZmlnLXI1LTAzMDg6My43LjA6MTM4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXI1LTAzMDgvMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVz
Zy1xdWFudGFsLXhnd28tNjoyMDE0MDMwODA4MjM0NDppMzg2LXJhbmRjb25maWctcjUtMDMw
ODozLjcuMDoxMzgKMjo0OjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDog
YmFkIGNvbW1pdCB2My43CmdpdCBjaGVja291dCB2My42CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZl
bC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OmEwZDI3MWNiZmVkMWRkNTAyNzhjNmIwNmJlYWQz
ZDAwYmEwYTg4Zjk6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wOC0wODoyNDozMCBhMGQyNzFj
YmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5IGNvbXBpbGluZwozMDUgcmVhbCAg
MTU3OSB1c2VyICAxMzkgc3lzICA1NjIuODAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAz
MDgKCjIwMTQtMDMtMDgtMDg6MzA6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy42LjAuLgkx
CTMJNgkxMAkxMyBURVNUIEZBSUxVUkUKWyAgIDcwLjQ1NTgzOV0gVW5yZWdpc3RlciBwdiBz
aGFyZWQgbWVtb3J5IGZvciBjcHUgMApbICAgNzAuNDU2NjI0XSBzYmM2MHh4d2R0OiBXYXRj
aGRvZyB0aW1lciBpcyBub3cgZGlzYWJsZWQuLi4KWyAgIDcwLjQ1ODE0OV0gLS0tLS0tLS0t
LS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA3MC40NTg5MjldIFdBUk5JTkc6IGF0
IC9rZXJuZWwtdGVzdHMvbGludXgyL2tlcm5lbC9ldmVudHMvY29yZS5jOjQ5OTkgcGVyZl9z
d2V2ZW50X2FkZCsweDEwMS8weDE5MSgpClsgICA3MC40NTkwNzFdIE1vZHVsZXMgbGlua2Vk
IGluOgpbICAgNzAuNDU5MDcxXSBQaWQ6IDEwMywgY29tbTogdHJpbml0eS1tYWluIE5vdCB0
YWludGVkIDMuNi4wICMxMzkKWyAgIDcwLjQ1OTA3MV0gQ2FsbCBUcmFjZToKWyAgIDcwLjQ1
OTA3MV0gIFs8YzEwNDEwOTI+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDljLzB4ZGIKWyAg
IDcwLjQ1OTA3MV0gIFs8YzEwY2QzNzI+XSA/IHBlcmZfc3dldmVudF9hZGQrMHgxMDEvMHgx
OTEKWyAgIDcwLjQ1OTA3MV0gIFs8YzEwNDEwZmM+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgy
Yi8weDNkClsgICA3MC40NTkwNzFdICBbPGMxMGNkMzcyPl0gcGVyZl9zd2V2ZW50X2FkZCsw
eDEwMS8weDE5MQpbICAgNzAuNDU5MDcxXSAgWzxjMTBjZmQ2Yj5dIGV2ZW50X3NjaGVkX2lu
KzB4ZGIvMHgyM2MKWyAgIDcwLjQ1OTA3MV0gIFs8YzEwY2ZmM2I+XSBncm91cF9zY2hlZF9p
bisweDZmLzB4MWZiClsgICA3MC40NTkwNzFdICBbPGMxMDhmMDkwPl0gPyB0cmFjZV9oYXJk
aXJxc19vZmYrMHgyNy8weDM3ClsgICA3MC40NTkwNzFdICBbPGMxMGQwMjQyPl0gY3R4X3Nj
aGVkX2luKzB4MTdiLzB4MzJhClsgICA3MC40NTkwNzFdICBbPGMxMGQwY2IyPl0gcGVyZl9l
dmVudF9zY2hlZF9pbisweDUzLzB4YjYKWyAgIDcwLjQ1OTA3MV0gIFs8YzEwZDEwZmI+XSBw
ZXJmX2V2ZW50X2NvbnRleHRfc2NoZWRfaW4rMHhhOS8weDEwMApbICAgNzAuNDU5MDcxXSAg
WzxjMTBkMTE5Nj5dIF9fcGVyZl9ldmVudF90YXNrX3NjaGVkX2luKzB4NDQvMHgyYmIKWyAg
IDcwLjQ1OTA3MV0gIFs8YzEwNzhmNGE+XSBmaW5pc2hfdGFza19zd2l0Y2guY29uc3Rwcm9w
LjQ1KzB4MWE2LzB4MWMxClsgICA3MC40NTkwNzFdICBbPGMxNjljNThlPl0gX19zY2hlZHVs
ZSsweDg4MS8weGEzMApbICAgNzAuNDU5MDcxXSAgWzxjMTY5Y2NlZD5dID8gcHJlZW1wdF9z
Y2hlZHVsZV9pcnErMHhjMi8weDE0NwpbICAgNzAuNDU5MDcxXSAgWzxjMTY5Y2NlZD5dIHBy
ZWVtcHRfc2NoZWR1bGVfaXJxKzB4YzIvMHgxNDcKWyAgIDcwLjQ1OTA3MV0gIFs8YzE2OWYz
MGM+XSBuZWVkX3Jlc2NoZWQrMHgxYi8weDFmClsgICA3MC40NTkwNzFdICBbPGMxNmE3MTk4
Pl0gPyBzeXNlbnRlcl9wYXN0X2VzcCsweDM1LzB4NjcKWyAgIDcwLjQ1OTA3MV0gLS0tWyBl
bmQgdHJhY2UgMGUwMjBhYjdlNzExZWQ2YiBdLS0tClsgICA3MC40NzkwNDFdIFJlc3RhcnRp
bmcgc3lzdGVtLgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2EwZDI3MWNiZmVk
MWRkNTAyNzhjNmIwNmJlYWQzZDAwYmEwYTg4ZjkvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMzE6
MjAxNDAzMDgwODMzMjI6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6My42LjA6MTM5Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVh
ZDNkMDBiYTBhODhmOS9kbWVzZy1xdWFudGFsLWlubi01OjIwMTQwMzA4MDgzMzIxOmkzODYt
cmFuZGNvbmZpZy1yNS0wMzA4OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9h
MGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5L2RtZXNnLXF1YW50YWwt
YmVucy00OjIwMTQwMzA4MDgzMzMwOmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjMuNi4wOjEz
OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2EwZDI3MWNiZmVkMWRkNTAyNzhj
NmIwNmJlYWQzZDAwYmEwYTg4ZjkvZG1lc2ctcXVhbnRhbC1hdGhlbnMtMTU6MjAxNDAzMDgw
ODMzNTU6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6My42LjA6MTM5CjQ6NDoxMyBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjYKZ2l0IGNoZWNr
b3V0IHYzLjUKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6
MjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5MjpiaXNlY3QtbGludXgy
CgoyMDE0LTAzLTA4LTA4OjM0OjE3IDI4YTMzY2JjMjRlNDI1NmMxNDNkY2U5NmM3ZDkzYmY0
MjMyMjlmOTIgY29tcGlsaW5nCjMyOCByZWFsICAxNTYwIHVzZXIgIDEzNyBzeXMgIDUxNy44
NSUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwOAoKMjAxNC0wMy0wOC0wODo0MDo1NCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjUuMC4JMwk3CTE4CTI0CTMxIFRFU1QgRkFJTFVSRQpb
ICAgIDcuNDg2Mzg3XSBzaCAoOTIpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDY3Mjgg
Ynl0ZXMgbGVmdAovYmluL3NoOiAvcHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBvciBk
aXJlY3RvcnkKWyAgIDE3Ljk3OTI2Ml0gc29jazogcHJvY2VzcyBgdHJpbml0eS1tYWluJyBp
cyB1c2luZyBvYnNvbGV0ZSBzZXRzb2Nrb3B0IFNPX0JTRENPTVBBVApbICAgMjAuNDk3NTYz
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IGUyMTAw
ZDc0ClsgICAyMC40OTgwNjddIElQOiBbPGMxMGM3N2Q1Pl0gcGVyZl9zd2V2ZW50X2luaXQr
MHgxNDAvMHgxNzQKWyAgIDIwLjQ5ODA2N10gKnBkcHQgPSAwMDAwMDAwMDAxYjkyMDAxICpw
ZGUgPSAwMDAwMDAwMDAwMDAwMDAwIApbICAgMjAuNDk4MDY3XSBPb3BzOiAwMDAyIFsjMV0g
UFJFRU1QVCAKWyAgIDIwLjQ5ODA2N10gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAyMC40OTgw
NjddIApbICAgMjAuNDk4MDY3XSBQaWQ6IDEwMiwgY29tbTogdHJpbml0eS1tYWluIE5vdCB0
YWludGVkIDMuNS4wICMxNDAgIApbICAgMjAuNDk4MDY3XSBFSVA6IDAwNjA6WzxjMTBjNzdk
NT5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAyMC40OTgwNjddIEVJUCBpcyBhdCBw
ZXJmX3N3ZXZlbnRfaW5pdCsweDE0MC8weDE3NApbICAgMjAuNDk4MDY3XSBFQVg6IDAwMDAw
MDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNyBFRFg6IDAwMDAwMDAzClsgICAyMC40
OTgwNjddIEVTSTogY2Y0NTE2MzggRURJOiA4ODAwOTYxNSBFQlA6IGM4YjY1ZWRjIEVTUDog
YzhiNjVlZDAKWyAgIDIwLjQ5ODA2N10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdT
OiAwMDMzIFNTOiAwMDY4ClsgICAyMC40OTgwNjddIENSMDogODAwNTAwM2IgQ1IyOiBlMjEw
MGQ3NCBDUjM6IDA4YjRmMDAwIENSNDogMDAwMDA2YjAKWyAgIDIwLjQ5ODA2N10gRFIwOiAw
MDAwMDAwMCBEUjE6IDAwMDAwMDAwIERSMjogMDAwMDAwMDAgRFIzOiAwMDAwMDAwMApbICAg
MjAuNDk4MDY3XSBEUjY6IGZmZmYwZmYwIERSNzogMDAwMDA0MDAKWyAgIDIwLjQ5ODA2N10g
UHJvY2VzcyB0cmluaXR5LW1haW4gKHBpZDogMTAyLCB0aT1jOGI2NDAwMCB0YXNrPWNmZDgy
MzMwIHRhc2sudGk9YzhiNjQwMDApClsgICAyMC40OTgwNjddIFN0YWNrOgpbICAgMjAuNDk4
MDY3XSAgYzFhMDk3YTAgY2Y0NTE2MzggMDAwMDAwMDAgYzhiNjVlZjQgYzEwY2UzNDcgYzFh
MDk3YTAgMDAwMDAwMDAgY2Y0NTE3NzAKWyAgIDIwLjQ5ODA2N10gIGNmNDUxNjM4IGM4YjY1
ZjEwIGMxMGNlNmI1IGM4YjY1ZjUwIGNmNDUxNjM4IGNmZDgyMzMwIDAwMDAwMDAwIDAwMDAw
MDAwClsgICAyMC40OTgwNjddICBjOGI2NWZhYyBjMTBjZjU0MiBjZjQ1MTYzOCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMCBjOGI2NWY5YyBjMTY5ZThjNgpbICAgMjAuNDk4MDY3XSBD
YWxsIFRyYWNlOgpbICAgMjAuNDk4MDY3XSAgWzxjMTBjZTM0Nz5dIHBlcmZfaW5pdF9ldmVu
dCsweGQ0LzB4MTNkClsgICAyMC40OTgwNjddICBbPGMxMGNlNmI1Pl0gcGVyZl9ldmVudF9h
bGxvYysweDMwNS8weDU0OApbICAgMjAuNDk4MDY3XSAgWzxjMTBjZjU0Mj5dIHN5c19wZXJm
X2V2ZW50X29wZW4rMHg2YmUvMHhlYjUKWyAgIDIwLjQ5ODA2N10gIFs8YzE2OWU4YzY+XSA/
IGRvX3BhZ2VfZmF1bHQrMHg4MDQvMHg4ZGYKWyAgIDIwLjQ5ODA2N10gIFs8YzE2YTFmOWM+
XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzYwpbICAgMjAuNDk4MDY3XSBDb2RlOiBlNiAw
ZCBjMiAwMSA4MyAxNSA1YyBlNiAwZCBjMiAwMCA4MyAwNSBiOCBlNiAwZCBjMiAwMSA4MyAx
NSBiYyBlNiAwZCBjMiAwMCA4NSBkYiA3NSAzYiA4MyAwNSBjMCBlNiAwZCBjMiAwMSA4MyAx
NSBjNCBlNiAwZCBjMiAwMCA8ZmY+IDA0IGJkIDIwIGI1IDBkIGMyIDgzIDA1IGM4IGU2IDBk
IGMyIDAxIDgzIDE1IGNjIGU2IDBkIGMyIDAwIApbICAgMjAuNDk4MDY3XSBFSVA6IFs8YzEw
Yzc3ZDU+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweDE0MC8weDE3NCBTUzpFU1AgMDA2ODpjOGI2
NWVkMApbICAgMjAuNDk4MDY3XSBDUjI6IDAwMDAwMDAwZTIxMDBkNzQKWyAgIDIwLjQ5ODA2
N10gLS0tWyBlbmQgdHJhY2UgNzU3Y2Q3OGJmNTI4MWI5YSBdLS0tClsgICAyMC40OTgwNjdd
IEJVRzogc2xlZXBpbmcgZnVuY3Rpb24gY2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0
IC9rZXJuZWwtdGVzdHMvbGludXgyL2tlcm5lbC9yd3NlbS5jOjIwCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDgvMjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIy
OWY5Mi9kbWVzZy1xdWFudGFsLXNuYi0yNjoyMDE0MDMwODA4NDMzMTppMzg2LXJhbmRjb25m
aWctcjUtMDMwODo6CjE5OjE6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1
bTIwMTQtMDMtMDggMDg6NDM6NTYgUkVQRUFUIENPVU5UOiAzMzAgICMgL2tlcm5lbC10ZXN0
cy9saW51eDIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29tbWl0IHYz
LjUKZ2l0IGNoZWNrb3V0IHYzLjQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0y
MDE0MDMwODA2Mzk6NzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYzpi
aXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTA4OjQzOjU5IDc2ZTEwZDE1OGVmYjZkNDUxNjAx
ODg0NmY2MGMyYWI1NTAxOTAwYmMgY29tcGlsaW5nCjExOSByZWFsICAxNDgzIHVzZXIgIDEz
MiBzeXMgIDEzNTEuNDclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKCjIwMTQtMDMt
MDgtMDg6NDY6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy40LjAuCTEyCTE4CTM1IFRFU1Qg
RkFJTFVSRQpbICAgODQuMjA0NjUzXSBVbnJlZ2lzdGVyIHB2IHNoYXJlZCBtZW1vcnkgZm9y
IGNwdSAwClsgICA4NC4yMTA2OThdIHNiYzYweHh3ZHQ6IFdhdGNoZG9nIHRpbWVyIGlzIG5v
dyBkaXNhYmxlZC4uLgpbICAgODQuMjE0MzIxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWyAgIDg0LjIxNTE3Nl0gV0FSTklORzogYXQgL2tlcm5lbC10ZXN0cy9s
aW51eDIva2VybmVsL2V2ZW50cy9jb3JlLmM6NDk4NiBwZXJmX3N3ZXZlbnRfYWRkKzB4ZmQv
MHgxODcoKQpbICAgODQuMjE1MTc2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDg0LjIxNTE3
Nl0gUGlkOiAxMDIsIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjQuMCAjMTQx
ClsgICA4NC4yMTUxNzZdIENhbGwgVHJhY2U6ClsgICA4NC4yMTUxNzZdICBbPGMxMDNjNzM1
Pl0gPyBjb25zb2xlX3VubG9jaysweDM0MS8weDNjNQpbICAgODQuMjE1MTc2XSAgWzxjMTAz
YjdjYT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OWMvMHhkYgpbICAgODQuMjE1MTc2XSAg
WzxjMTBiZmVmYj5dID8gcGVyZl9zd2V2ZW50X2FkZCsweGZkLzB4MTg3ClsgICA4NC4yMTUx
NzZdICBbPGMxMDNiODM0Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MmIvMHgzZApbICAgODQu
MjE1MTc2XSAgWzxjMTBiZmVmYj5dIHBlcmZfc3dldmVudF9hZGQrMHhmZC8weDE4NwpbICAg
ODQuMjE1MTc2XSAgWzxjMTBjMzVkYj5dIGV2ZW50X3NjaGVkX2luKzB4ZGIvMHgyM2MKWyAg
IDg0LjIxNTE3Nl0gIFs8YzEwYzM3YWI+XSBncm91cF9zY2hlZF9pbisweDZmLzB4MWZlClsg
ICA4NC4yMTUxNzZdICBbPGMxMDg0ZjcwPl0gPyB0cmFjZV9oYXJkaXJxc19vZmYrMHgyNy8w
eDM3ClsgICA4NC4yMTUxNzZdICBbPGMxMGMzYWI5Pl0gY3R4X3NjaGVkX2luKzB4MTdmLzB4
MzJhClsgICA4NC4yMTUxNzZdICBbPGMxMGM0NTFhPl0gcGVyZl9ldmVudF9zY2hlZF9pbisw
eDUzLzB4YjYKWyAgIDg0LjIxNTE3Nl0gIFs8YzEwYzQ5NjM+XSBwZXJmX2V2ZW50X2NvbnRl
eHRfc2NoZWRfaW4rMHhhOS8weDEwMApbICAgODQuMjE1MTc2XSAgWzxjMTBjNDlmZT5dIF9f
cGVyZl9ldmVudF90YXNrX3NjaGVkX2luKzB4NDQvMHgyYmIKWyAgIDg0LjIxNTE3Nl0gIFs8
YzEwNmY1OGQ+XSBmaW5pc2hfdGFza19zd2l0Y2guY29uc3Rwcm9wLjQ1KzB4MWE2LzB4MWMx
ClsgICA4NC4yMTUxNzZdICBbPGMxNjc3ODY5Pl0gX19zY2hlZHVsZSsweDg4MS8weGEyYgpb
ICAgODQuMjE1MTc2XSAgWzxjMTY3N2JkYT5dID8gc2NoZWR1bGUrMHgxZC8weDJkClsgICA4
NC4yMTUxNzZdICBbPGMxNjc3YmRhPl0gc2NoZWR1bGUrMHgxZC8weDJkClsgICA4NC4yMTUx
NzZdICBbPGMxNjdhNmU2Pl0gd29ya19yZXNjaGVkKzB4NS8weDMwClsgICA4NC4yMTUxNzZd
IC0tLVsgZW5kIHRyYWNlIDE4NGM5YWFiYTM2ZjFlZDEgXS0tLQpbICAgODQuMjc2OTU4XSBS
ZXN0YXJ0aW5nIHN5c3RlbS4KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC83NmUx
MGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkwMGJjL2RtZXNnLXF1YW50YWwtc25i
LTM6MjAxNDAzMDgwODQ3NDk6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yNS0wMzA4Lzc2ZTEwZDE1OGVmYjZkNDUxNjAxODg0NmY2MGMyYWI1
NTAxOTAwYmMvZG1lc2ctcXVhbnRhbC1qYWtldG93bi0zMDoyMDE0MDMwODA4NDgwNTppMzg2
LXJhbmRjb25maWctcjUtMDMwODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgv
NzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYy9kbWVzZy1xdWFudGFs
LXNuYi0zMjoyMDE0MDMwODA4NDgwMzppMzg2LXJhbmRjb25maWctcjUtMDMwODo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYw
YzJhYjU1MDE5MDBiYy9kbWVzZy1xdWFudGFsLXNuYi00NDoyMDE0MDMwODA4NDgwMzppMzg2
LXJhbmRjb25maWctcjUtMDMwODo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgv
NzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYwYzJhYjU1MDE5MDBiYy9kbWVzZy1xdWFudGFs
LXNuYi00NToyMDE0MDMwODA4NDgwMjppMzg2LXJhbmRjb25maWctcjUtMDMwODo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvNzZlMTBkMTU4ZWZiNmQ0NTE2MDE4ODQ2ZjYw
YzJhYjU1MDE5MDBiYy9kbWVzZy1xdWFudGFsLWpha2V0b3duLTM1OjIwMTQwMzA4MDg0ODEw
OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUt
MDMwOC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkwMGJjL2RtZXNnLXF1
YW50YWwtc25iLTM1OjIwMTQwMzA4MDg0ODEwOmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4
NDZmNjBjMmFiNTUwMTkwMGJjL2RtZXNnLXF1YW50YWwtc25iLTIyOjIwMTQwMzA4MDg0ODE1
OmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUt
MDMwOC83NmUxMGQxNThlZmI2ZDQ1MTYwMTg4NDZmNjBjMmFiNTUwMTkwMGJjL2RtZXNnLXF1
YW50YWwtc25iLTQ4OjIwMTQwMzA4MDg0ODExOmkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OjoK
MTI6OTozNCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0
IHYzLjQKZ2l0IGNoZWNrb3V0IHYzLjMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4
Ni0yMDE0MDMwODA2Mzk6YzE2ZmE0ZjJhZDE5OTA4YTQ3YzYzZDhmYTQzNmExMTc4NDM4Yzdl
NzpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTA4OjQ4OjQ1IGMxNmZhNGYyYWQxOTkwOGE0
N2M2M2Q4ZmE0MzZhMTE3ODQzOGM3ZTcgY29tcGlsaW5nCjE1MCByZWFsICAxNDg3IHVzZXIg
IDEzNyBzeXMgIDEwODAuNjglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKCjIwMTQt
MDMtMDgtMDg6NTI6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4zLjAuLgk0CTcuIFRFU1Qg
RkFJTFVSRQpbICAgMTcuNDgwNjk0XSBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlzIHVzaW5n
IG9ic29sZXRlIHNldHNvY2tvcHQgU09fQlNEQ09NUEFUClsgICAxOC4yOTk0MTNdIGlyZGFf
c2V0c29ja29wdDogbm90IGFsbG93ZWQgdG8gc2V0IE1BWFNEVVNJWkUgZm9yIHRoaXMgc29j
a2V0IHR5cGUhClsgICAxOS4yNzQ5NjZdIGlyZGFfc2V0c29ja29wdDogbm90IGFsbG93ZWQg
dG8gc2V0IE1BWFNEVVNJWkUgZm9yIHRoaXMgc29ja2V0IHR5cGUhClsgICAxOS43NTAyMzhd
IEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgYmZkMzhm
YTQKWyAgIDE5Ljc1MTA4M10gSVA6IFs8YzEwYmVlMjc+XSBwZXJmX3N3ZXZlbnRfaW5pdCsw
eDEyNC8weDE1MQpbICAgMTkuNzUxMDgzXSAqcGRwdCA9IDAwMDAwMDAwMDhiNGUwMDEgKnBk
ZSA9IDAwMDAwMDAwMDAwMDAwMDAgClsgICAxOS43NTEwODNdIE9vcHM6IDAwMDIgWyMxXSBQ
UkVFTVBUIApbICAgMTkuNzUxMDgzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgIDE5Ljc1MTA4
M10gClsgICAxOS43NTEwODNdIFBpZDogMTAxLCBjb21tOiB0cmluaXR5LW1haW4gTm90IHRh
aW50ZWQgMy4zLjAgIzE0MiAgClsgICAxOS43NTEwODNdIEVJUDogMDA2MDpbPGMxMGJlZTI3
Pl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAgIDE5Ljc1MTA4M10gRUlQIGlzIGF0IHBl
cmZfc3dldmVudF9pbml0KzB4MTI0LzB4MTUxClsgICAxOS43NTEwODNdIEVBWDogMDAwMDAw
MDAgRUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAwMDA3IEVEWDogMDAwMDAwMDMKWyAgIDE5Ljc1
MTA4M10gRVNJOiBjZjQ3YzI0MCBFREk6IGZmNzMyZWNkIEVCUDogYzhiNzNlZTQgRVNQOiBj
OGI3M2VkOApbICAgMTkuNzUxMDgzXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6
IDAwMzMgU1M6IDAwNjgKWyAgIDE5Ljc1MTA4M10gUHJvY2VzcyB0cmluaXR5LW1haW4gKHBp
ZDogMTAxLCB0aT1jOGI3MjAwMCB0YXNrPWNmZDc0MmIwIHRhc2sudGk9YzhiNzIwMDApClsg
ICAxOS43NTEwODNdIFN0YWNrOgpbICAgMTkuNzUxMDgzXSAgYzE5YjJjZjggY2Y0N2MyNDAg
MDAwMDAwMDAgYzhiNzNlZmMgYzEwYzYwNDEgYzE5YjJjZjggMDAwMDAwMDAgY2Y0N2MzNTgK
WyAgIDE5Ljc1MTA4M10gIGNmNDdjMjQwIGM4YjczZjE4IGMxMGM2M2E5IGM4YjczZjU4IGNm
NDdjMjQwIGNmZDc0MmIwIDAwMDAwMDAwIDAwMDAwMDAwClsgICAxOS43NTEwODNdICBjOGI3
M2ZhYyBjMTBjNzBjMCBjZjQ3YzI0MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCBjZmQ3
NDJiMCAwOGUyNDNiYwpbICAgMTkuNzUxMDgzXSBDYWxsIFRyYWNlOgpbICAgMTkuNzUxMDgz
XSAgWzxjMTBjNjA0MT5dIHBlcmZfaW5pdF9ldmVudCsweGRhLzB4MTNkClsgICAxOS43NTEw
ODNdICBbPGMxMGM2M2E5Pl0gcGVyZl9ldmVudF9hbGxvYysweDMwNS8weDRlNwpbICAgMTku
NzUxMDgzXSAgWzxjMTBjNzBjMD5dIHN5c19wZXJmX2V2ZW50X29wZW4rMHg1YTkvMHhkNjMK
WyAgIDE5Ljc1MTA4M10gIFs8YzE2NmVlOWM+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgz
YwpbICAgMTkuNzUxMDgzXSBDb2RlOiAwNCAwNyBjMiAwMSA4MyAxNSA2YyAwNCAwNyBjMiAw
MCA4MyAwNSBjMCAwNCAwNyBjMiAwMSA4MyAxNSBjNCAwNCAwNyBjMiAwMCA4NSBkYiA3NSAz
NCA4MyAwNSBjOCAwNCAwNyBjMiAwMSA4MyAxNSBjYyAwNCAwNyBjMiAwMCA8ZmY+IDA0IGJk
IDcwIGQ0IDA2IGMyIDgzIDA1IGQwIDA0IDA3IGMyIDAxIDgzIDE1IGQ0IDA0IDA3IGMyIDAw
IApbICAgMTkuNzUxMDgzXSBFSVA6IFs8YzEwYmVlMjc+XSBwZXJmX3N3ZXZlbnRfaW5pdCsw
eDEyNC8weDE1MSBTUzpFU1AgMDA2ODpjOGI3M2VkOApbICAgMTkuNzUxMDgzXSBDUjI6IDAw
MDAwMDAwYmZkMzhmYTQKWyAgIDE5LjgwMTI1M10gLS0tWyBlbmQgdHJhY2UgOThhOGVjNzNm
NzQ2YjdlOSBdLS0tClsgICAxOS44NDkyNTNdIHRyaW5pdHktbWFpbiB1c2VkIGdyZWF0ZXN0
IHN0YWNrIGRlcHRoOiA2NDMyIGJ5dGVzIGxlZnQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
cjUtMDMwOC9jMTZmYTRmMmFkMTk5MDhhNDdjNjNkOGZhNDM2YTExNzg0MzhjN2U3L2RtZXNn
LXF1YW50YWwtc25iLTY6MjAxNDAzMDgwODU0MTI6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6
Ogo0OjE6NiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0
IHYzLjMKZ2l0IGNoZWNrb3V0IHYzLjIKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4
Ni0yMDE0MDMwODA2Mzk6ODA1YTZhZjhkYmE1ZGZkZDM1ZWMzNWRjNTJlYzAxMjI0MDBiMjYx
MDpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTA4OjU0OjU4IDgwNWE2YWY4ZGJhNWRmZGQz
NWVjMzVkYzUyZWMwMTIyNDAwYjI2MTAgY29tcGlsaW5nCjIwMyByZWFsICAxMzU1IHVzZXIg
IDEyNyBzeXMgIDcyNy43NyUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwOAoKMjAxNC0w
My0wOC0wODo1ODo1OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjIuMC4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4JMQk1CTEzIFRFU1QgRkFJTFVSRQpbICAgMjYuODM2ODI3XSBpcmRhX3NldHNv
Y2tvcHQ6IG5vdCBhbGxvd2VkIHRvIHNldCBNQVhTRFVTSVpFIGZvciB0aGlzIHNvY2tldCB0
eXBlIQpbICAgMjguMDU4ODc0XSBpcmRhX3NldHNvY2tvcHQ6IG5vdCBhbGxvd2VkIHRvIHNl
dCBNQVhTRFVTSVpFIGZvciB0aGlzIHNvY2tldCB0eXBlIQpbICAgMjguNjI1OTMwXSBpcnR0
cF9vcGVuX3RzYXA6IHVuYWJsZSB0byBhbGxvY2F0ZSBMU0FQISEKWyAgIDI5LjAxMjg3MV0g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCA1ODIyNmQ2
OApbICAgMjkuMDEzMTk2XSBJUDogWzxjMTBiNjQ5YT5dIHBlcmZfc3dldmVudF9pbml0KzB4
MTI0LzB4MTUxClsgICAyOS4wMTMxOTZdICpwZHB0ID0gMDAwMDAwMDAwOGI1YjAwMSAqcGRl
ID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDI5LjAxMzE5Nl0gT29wczogMDAwMiBbIzFdIFBS
RUVNUFQgClsgICAyOS4wMTMxOTZdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgMjkuMDEzMTk2
XSAKWyAgIDI5LjAxMzE5Nl0gUGlkOiA5MiwgY29tbTogdHJpbml0eS1tYWluIE5vdCB0YWlu
dGVkIDMuMi4wICMxNDMgIApbICAgMjkuMDEzMTk2XSBFSVA6IDAwNjA6WzxjMTBiNjQ5YT5d
IEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAyOS4wMTMxOTZdIEVJUCBpcyBhdCBwZXJm
X3N3ZXZlbnRfaW5pdCsweDEyNC8weDE1MQpbICAgMjkuMDEzMTk2XSBFQVg6IDAwMDAwMDAw
IEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwNyBFRFg6IDAwMDAwMDAzClsgICAyOS4wMTMx
OTZdIEVTSTogY2Y0NTdiNTAgRURJOiBhNTg4MDkwYSBFQlA6IGM4ZWMxZWU0IEVTUDogYzhl
YzFlZDgKWyAgIDI5LjAxMzE5Nl0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAw
MDMzIFNTOiAwMDY4ClsgICAyOS4wMTMxOTZdIFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6
IDkyLCB0aT1jOGVjMDAwMCB0YXNrPWM4YWVlYzQwIHRhc2sudGk9YzhlYzAwMDApClsgICAy
OS4wMTMxOTZdIFN0YWNrOgpbICAgMjkuMDEzMTk2XSAgYzE5NzUwMDAgY2Y0NTdiNTAgMDAw
MDAwMDAgYzhlYzFlZmMgYzEwYmQ1NGUgYzE5NzUwMDAgMDAwMDAwMDAgY2Y0NTdjNjgKWyAg
IDI5LjAxMzE5Nl0gIGNmNDU3YjUwIGM4ZWMxZjE4IGMxMGJkOGIxIGM4ZWMxZjU4IGNmNDU3
YjUwIGM4YWVlYzQwIDAwMDAwMDAwIDAwMDAwMDAwClsgICAyOS4wMTMxOTZdICBjOGVjMWZh
YyBjMTBiZTdkZCBjZjQ1N2I1MCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCBjOGFlZWM0
MCAwOTY4MzliYwpbICAgMjkuMDEzMTk2XSBDYWxsIFRyYWNlOgpbICAgMjkuMDEzMTk2XSAg
WzxjMTBiZDU0ZT5dIHBlcmZfaW5pdF9ldmVudCsweGRhLzB4MTNkClsgICAyOS4wMTMxOTZd
ICBbPGMxMGJkOGIxPl0gcGVyZl9ldmVudF9hbGxvYysweDMwMC8weDZmNwpbICAgMjkuMDEz
MTk2XSAgWzxjMTBiZTdkZD5dIHN5c19wZXJmX2V2ZW50X29wZW4rMHg1YTkvMHhkNjMKWyAg
IDI5LjAxMzE5Nl0gIFs8YzE2NDYzMWM+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIvMHgzYwpb
ICAgMjkuMDEzMTk2XSBDb2RlOiA3YSAwMiBjMiAwMSA4MyAxNSA2YyA3YSAwMiBjMiAwMCA4
MyAwNSBjMCA3YSAwMiBjMiAwMSA4MyAxNSBjNCA3YSAwMiBjMiAwMCA4NSBkYiA3NSAzNCA4
MyAwNSBjOCA3YSAwMiBjMiAwMSA4MyAxNSBjYyA3YSAwMiBjMiAwMCA8ZmY+IDA0IGJkIDQw
IDQ5IDAyIGMyIDgzIDA1IGQwIDdhIDAyIGMyIDAxIDgzIDE1IGQ0IDdhIDAyIGMyIDAwIApb
ICAgMjkuMDEzMTk2XSBFSVA6IFs8YzEwYjY0OWE+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweDEy
NC8weDE1MSBTUzpFU1AgMDA2ODpjOGVjMWVkOApbICAgMjkuMDEzMTk2XSBDUjI6IDAwMDAw
MDAwNTgyMjZkNjgKWyAgIDI5LjA4NTI2OF0gLS0tWyBlbmQgdHJhY2UgYjRiNDY0NTBhYTNh
MTJhYiBdLS0tClsgICAyOS4xNDM4MTddIHRyaW5pdHktbWFpbiB1c2VkIGdyZWF0ZXN0IHN0
YWNrIGRlcHRoOiA2MzcyIGJ5dGVzIGxlZnQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUt
MDMwOC84MDVhNmFmOGRiYTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIyNjEwL2RtZXNnLXF1
YW50YWwtbGtwLXN0MDEtNjoyMDE0MDMwODA5MTEyMjppMzg2LXJhbmRjb25maWctcjUtMDMw
ODozLjIuMDoxNDMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC84MDVhNmFmOGRi
YTVkZmRkMzVlYzM1ZGM1MmVjMDEyMjQwMGIyNjEwL2RtZXNnLXF1YW50YWwtc25iLTc6MjAx
NDAzMDgwOTExMjY6aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yNS0wMzA4LzgwNWE2YWY4ZGJhNWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2
MTAvZG1lc2ctcXVhbnRhbC1zbmItMzI6MjAxNDAzMDgwOTExMjk6aTM4Ni1yYW5kY29uZmln
LXI1LTAzMDg6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzgwNWE2YWY4ZGJh
NWRmZGQzNWVjMzVkYzUyZWMwMTIyNDAwYjI2MTAvZG1lc2ctcXVhbnRhbC1zbmItNToyMDE0
MDMwODA5MTEyODppMzg2LXJhbmRjb25maWctcjUtMDMwODo6CjE0OjU6MTEgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4yCmdpdCBjaGVja291
dCB2My4xCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OmMz
YjkyYzg3ODczNjdhOGJiNTNkNTdkOTc4OWI1NThmMTI5NWNjOTY6YmlzZWN0LWxpbnV4MgoK
MjAxNC0wMy0wOC0wOToxMTo1MiBjM2I5MmM4Nzg3MzY3YThiYjUzZDU3ZDk3ODliNTU4ZjEy
OTVjYzk2IGNvbXBpbGluZwpjcDogY2Fubm90IGNyZWF0ZSByZWd1bGFyIGZpbGUgJy90bXAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2MzYjkyYzg3ODczNjdhOGJiNTNkNTdk
OTc4OWI1NThmMTI5NWNjOTYvLmNvbmZpZyc6IFBlcm1pc3Npb24gZGVuaWVkCi9jL2tlcm5l
bC10ZXN0cy9jb21tb24uc2g6IGxpbmUgMzgzMzogL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXI1LTAzMDgvYzNiOTJjODc4NzM2N2E4YmI1M2Q1N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9r
YnVpbGQubG9nOiBQZXJtaXNzaW9uIGRlbmllZAovYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNo
OiBsaW5lIDM4NDY6IC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2MzYjky
Yzg3ODczNjdhOGJiNTNkNTdkOTc4OWI1NThmMTI5NWNjOTYva2J1aWxkLmxvZzogUGVybWlz
c2lvbiBkZW5pZWQKL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaDogbGluZSAzODc0OiAvdG1w
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9jM2I5MmM4Nzg3MzY3YThiYjUzZDU3
ZDk3ODliNTU4ZjEyOTVjYzk2L2tidWlsZC5sb2c6IFBlcm1pc3Npb24gZGVuaWVkCjAgcmVh
bCAgMCB1c2VyICAwIHN5cyAgMC4wMCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwOAov
Yy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOiBsaW5lIDM5MTM6IC90bXAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yNS0wMzA4L2MzYjkyYzg3ODczNjdhOGJiNTNkNTdkOTc4OWI1NThmMTI5
NWNjOTYvY29tcGlsZTogUGVybWlzc2lvbiBkZW5pZWQKY3A6IGNhbm5vdCBzdGF0ICcvdG1w
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9jM2I5MmM4Nzg3MzY3YThiYjUzZDU3
ZDk3ODliNTU4ZjEyOTVjYzk2Ly5jb25maWcnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5
Cndhcm5pbmc6IChJTUEpIHNlbGVjdHMgVENHX1RQTSB3aGljaCBoYXMgdW5tZXQgZGlyZWN0
IGRlcGVuZGVuY2llcyAoSEFTX0lPTUVNICYmIEVYUEVSSU1FTlRBTCkKd2FybmluZzogKFND
SEVEX0FVVE9HUk9VUCkgc2VsZWN0cyBDR1JPVVBfU0NIRUQgd2hpY2ggaGFzIHVubWV0IGRp
cmVjdCBkZXBlbmRlbmNpZXMgKENHUk9VUFMgJiYgRVhQRVJJTUVOVEFMKQp3YXJuaW5nOiAo
SU1BKSBzZWxlY3RzIFRDR19UUE0gd2hpY2ggaGFzIHVubWV0IGRpcmVjdCBkZXBlbmRlbmNp
ZXMgKEhBU19JT01FTSAmJiBFWFBFUklNRU5UQUwpCndhcm5pbmc6IChTQ0hFRF9BVVRPR1JP
VVApIHNlbGVjdHMgQ0dST1VQX1NDSEVEIHdoaWNoIGhhcyB1bm1ldCBkaXJlY3QgZGVwZW5k
ZW5jaWVzIChDR1JPVVBTICYmIEVYUEVSSU1FTlRBTCkKCjIwMTQtMDMtMDgtMDk6MTI6NTEg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xLjAuCTMuCTUgVEVTVCBGQUlMVVJFClsgICA3OS40
MTM0NzldIFVucmVnaXN0ZXIgcHYgc2hhcmVkIG1lbW9yeSBmb3IgY3B1IDAKWyAgIDc5LjQx
NjI2MF0gc2JjNjB4eHdkdDogV2F0Y2hkb2cgdGltZXIgaXMgbm93IGRpc2FibGVkLi4uClsg
ICA3OS40Mjk5MjVdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAg
NzkuNDMwODA5XSBXQVJOSU5HOiBhdCAva2VybmVsLXRlc3RzL2xpbnV4Mi9rZXJuZWwvZXZl
bnRzL2NvcmUuYzo1MDI0IHBlcmZfc3dldmVudF9hZGQrMHhmZC8weDE4NygpClsgICA3OS40
MzA4MDldIE1vZHVsZXMgbGlua2VkIGluOgpbICAgNzkuNDMwODA5XSBQaWQ6IDkxLCBjb21t
OiB0cmluaXR5LW1haW4gTm90IHRhaW50ZWQgMy4yLjAgIzE0MwpbICAgNzkuNDMwODA5XSBD
YWxsIFRyYWNlOgpbICAgNzkuNDMwODA5XSAgWzxjMTAzZDYwZD5dID8gY29uc29sZV91bmxv
Y2srMHgzNDEvMHgzYzUKWyAgIDc5LjQzMDgwOV0gIFs8YzEwM2M2ODM+XSB3YXJuX3Nsb3dw
YXRoX2NvbW1vbisweDljLzB4ZGIKWyAgIDc5LjQzMDgwOV0gIFs8YzEwYjVjMDI+XSA/IHBl
cmZfc3dldmVudF9hZGQrMHhmZC8weDE4NwpbICAgNzkuNDMwODA5XSAgWzxjMTAzYzZlZD5d
IHdhcm5fc2xvd3BhdGhfbnVsbCsweDJiLzB4M2QKWyAgIDc5LjQzMDgwOV0gIFs8YzEwYjVj
MDI+XSBwZXJmX3N3ZXZlbnRfYWRkKzB4ZmQvMHgxODcKWyAgIDc5LjQzMDgwOV0gIFs8YzEw
YjhkYWI+XSBldmVudF9zY2hlZF9pbisweGRiLzB4MjAzClsgICA3OS40MzA4MDldICBbPGMx
MGI4ZjQyPl0gZ3JvdXBfc2NoZWRfaW4rMHg2Zi8weDFmZQpbICAgNzkuNDMwODA5XSAgWzxj
MTA3OWY5Mz5dID8gdHJhY2VfaGFyZGlycXNfb2ZmKzB4MjcvMHgzNwpbICAgNzkuNDMwODA5
XSAgWzxjMTBiOTI1MD5dIGN0eF9zY2hlZF9pbisweDE3Zi8weDMyYQpbICAgNzkuNDMwODA5
XSAgWzxjMTBiOWNiYT5dIHBlcmZfZXZlbnRfc2NoZWRfaW4rMHg1My8weGI2ClsgICA3OS40
MzA4MDldICBbPGMxMGJhMTAxPl0gcGVyZl9ldmVudF9jb250ZXh0X3NjaGVkX2luKzB4YTkv
MHgxMDAKWyAgIDc5LjQzMDgwOV0gIFs8YzEwYmExOWE+XSBfX3BlcmZfZXZlbnRfdGFza19z
Y2hlZF9pbisweDQyLzB4ZGQKWyAgIDc5LjQzMDgwOV0gIFs8YzEwMzI0NDc+XSBmaW5pc2hf
dGFza19zd2l0Y2guY29uc3Rwcm9wLjEwOSsweDFhNi8weDFjMQpbICAgNzkuNDMwODA5XSAg
WzxjMTYzOWI0Nz5dIF9fc2NoZWR1bGUrMHg4ODAvMHhhMjgKWyAgIDc5LjQzMDgwOV0gIFs8
YzE2MzllYjY+XSA/IHNjaGVkdWxlKzB4MWQvMHgyZApbICAgNzkuNDMwODA5XSAgWzxjMTYz
OWViNj5dIHNjaGVkdWxlKzB4MWQvMHgyZApbICAgNzkuNDMwODA5XSAgWzxjMTYzZTdjNj5d
IHdvcmtfcmVzY2hlZCsweDUvMHgzMApbICAgNzkuNDMwODA5XSAtLS1bIGVuZCB0cmFjZSBl
YzRmMTZiNmQ2ODkwMzQ2IF0tLS0KWyAgIDc5LjQ4MzkwOF0gUmVzdGFydGluZyBzeXN0ZW0u
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvYzNiOTJjODc4NzM2N2E4YmI1M2Q1
N2Q5Nzg5YjU1OGYxMjk1Y2M5Ni9kbWVzZy1xdWFudGFsLXNuYi0zNzoyMDE0MDMwODA5MTQz
NzppMzg2LXJhbmRjb25maWctcjUtMDMwODo6CjI6MTo0IGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMQpnaXQgY2hlY2tvdXQgdjMuMApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgv
bGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA4MDYzOTowMmY4YzZhZWU4ZGYz
Y2RjOTM1ZTliZGQ0ZjJkMDIwMzA2MDM1ZGJlOmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDgt
MDk6MTU6MTMgMDJmOGM2YWVlOGRmM2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZSBjb21w
aWxpbmcKMTE3IHJlYWwgIDEyNTEgdXNlciAgMTE0IHN5cyAgMTE2MS40MiUgY3B1IAlpMzg2
LXJhbmRjb25maWctcjUtMDMwOAoKMjAxNC0wMy0wOC0wOToxNzozOSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjAuMC4uLi4uLi4uLi4uLi4uLi4uLi4uCTEJNwkxNyBURVNUIEZBSUxVUkUK
WyAgIDcyLjk0Mzg4OV0gVW5yZWdpc3RlciBwdiBzaGFyZWQgbWVtb3J5IGZvciBjcHUgMApb
ICAgNzIuOTQ0ODY4XSBzYmM2MHh4d2R0OiBXYXRjaGRvZyB0aW1lciBpcyBub3cgZGlzYWJs
ZWQuLi4KWyAgIDcyLjk0NzIwM10gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0t
LS0tClsgICA3Mi45NDc5OTNdIFdBUk5JTkc6IGF0IC9rZXJuZWwtdGVzdHMvbGludXgyL2tl
cm5lbC9ldmVudHMvY29yZS5jOjUzMDMgcGVyZl9zd2V2ZW50X2FkZCsweGZkLzB4MTg3KCkK
WyAgIDcyLjk0ODExMF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICA3Mi45NDgxMTBdIFBpZDog
OTAsIGNvbW06IHRyaW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjAuMCAjMTQ0ClsgICA3Mi45
NDgxMTBdIENhbGwgVHJhY2U6ClsgICA3Mi45NDgxMTBdICBbPGMxMDNhZWFhPl0gPyBjb25z
b2xlX3VubG9jaysweDJlOC8weDMyNApbICAgNzIuOTQ4MTEwXSAgWzxjMTAzOTY2Yz5dIHdh
cm5fc2xvd3BhdGhfY29tbW9uKzB4OWMvMHhkYgpbICAgNzIuOTQ4MTEwXSAgWzxjMTBiMjM5
Nj5dID8gcGVyZl9zd2V2ZW50X2FkZCsweGZkLzB4MTg3ClsgICA3Mi45NDgxMTBdICBbPGMx
MDM5NmQ2Pl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MmIvMHgzZApbICAgNzIuOTQ4MTEwXSAg
WzxjMTBiMjM5Nj5dIHBlcmZfc3dldmVudF9hZGQrMHhmZC8weDE4NwpbICAgNzIuOTQ4MTEw
XSAgWzxjMTBiNWNmMD5dIGV2ZW50X3NjaGVkX2luKzB4ZGIvMHgyMDMKWyAgIDcyLjk0ODEx
MF0gIFs8YzEwYjVlODc+XSBncm91cF9zY2hlZF9pbisweDZmLzB4MWZlClsgICA3Mi45NDgx
MTBdICBbPGMxMDc2NTExPl0gPyB0cmFjZV9oYXJkaXJxc19vZmYrMHgyNy8weDM3ClsgICA3
Mi45NDgxMTBdICBbPGMxMGI2MThmPl0gY3R4X3NjaGVkX2luKzB4MTc5LzB4MzIyClsgICA3
Mi45NDgxMTBdICBbPGMxMGI2M2Q3Pl0gcGVyZl9ldmVudF9jb250ZXh0X3NjaGVkX2luKzB4
NzMvMHhmNwpbICAgNzIuOTQ4MTEwXSAgWzxjMTBiNjkyYj5dIF9fcGVyZl9ldmVudF90YXNr
X3NjaGVkX2luKzB4M2MvMHhiMQpbICAgNzIuOTQ4MTEwXSAgWzxjMTAyZjRjMT5dIGZpbmlz
aF90YXNrX3N3aXRjaC5jb25zdHByb3AuMTAwKzB4MWE2LzB4MWMxClsgICA3Mi45NDgxMTBd
ICBbPGMxNjA5NmM0Pl0gc2NoZWR1bGUrMHg4NDUvMHg5YjMKWyAgIDcyLjk0ODExMF0gIFs8
YzE2MGUyOTY+XSA/IHdvcmtfcmVzY2hlZCsweDUvMHgzMApbICAgNzIuOTQ4MTEwXSAgWzxj
MTYwZTI5Nj5dIHdvcmtfcmVzY2hlZCsweDUvMHgzMApbICAgNzIuOTQ4MTEwXSAtLS1bIGVu
ZCB0cmFjZSAxYWNmYWE4NTNkZmViMzBhIF0tLS0KWyAgIDcyLjk2NDI2MV0gUmVzdGFydGlu
ZyBzeXN0ZW0uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvMDJmOGM2YWVlOGRm
M2NkYzkzNWU5YmRkNGYyZDAyMDMwNjAzNWRiZS9kbWVzZy1xdWFudGFsLWF0aGVucy0yNDoy
MDE0MDMwODA5Mjg1MDppMzg2LXJhbmRjb25maWctcjUtMDMwODozLjAuMDoxNDQKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC8wMmY4YzZhZWU4ZGYzY2RjOTM1ZTliZGQ0ZjJk
MDIwMzA2MDM1ZGJlL2RtZXNnLXF1YW50YWwtaW5uLTU6MjAxNDAzMDgwOTI5MDQ6aTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDg6Ogo2OjI6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
CmJpc2VjdDogYmFkIGNvbW1pdCB2My4wCmdpdCBjaGVja291dCB2Mi42LjM5CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9saW51
eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OjYxYzRmMmM4MWM2MWY3MzU0
OTkyOGRmZDlmM2U4ZjI2YWEzNmE4Y2Y6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wOC0wOToy
OToxNCA2MWM0ZjJjODFjNjFmNzM1NDk5MjhkZmQ5ZjNlOGYyNmFhMzZhOGNmIGNvbXBpbGlu
ZwoxMzYgcmVhbCAgMTExNCB1c2VyICA5NyBzeXMgIDg4Ni41NiUgY3B1IAlpMzg2LXJhbmRj
b25maWctcjUtMDMwOAoyMDE0LTAzLTA4LTA5OjMxOjQ1IDYxYzRmMmM4MWM2MWY3MzU0OTky
OGRmZDlmM2U4ZjI2YWEzNmE4Y2YgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4g
L2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDgvNjFjNGYyYzgxYzYxZjczNTQ5OTI4ZGZkOWYzZThmMjZhYTM2
YThjZgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM5CmdpdCBjaGVja291
dCB2Mi42LjM4CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5
OjUyMWNiNDBiMGM0NDQxOGE0ZmQzNmRjNjMzZjU3NTgxM2Q1OWE0M2Q6YmlzZWN0LWxpbnV4
MgoKMjAxNC0wMy0wOC0wOTozMTo1MiA1MjFjYjQwYjBjNDQ0MThhNGZkMzZkYzYzM2Y1NzU4
MTNkNTlhNDNkIGNvbXBpbGluZwo0NDIgcmVhbCAgMTA1NCB1c2VyICA5NCBzeXMgIDI1OS4z
MyUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwOAoyMDE0LTAzLTA4LTA5OjM5OjI1IDUy
MWNiNDBiMGM0NDQxOGE0ZmQzNmRjNjMzZjU3NTgxM2Q1OWE0M2QgU0tJUCBCUk9LRU4gQlVJ
TEQKQ2hlY2sgZXJyb3MgaW4gL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCBhbmQg
L3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvNTIxY2I0MGIwYzQ0NDE4YTRm
ZDM2ZGM2MzNmNTc1ODEzZDU5YTQzZApiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2
Mi42LjM4CmdpdCBjaGVja291dCB2Mi42LjM3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2Ft
LWkzODYtMjAxNDAzMDgwNjM5OjNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0YWE2
NGY2ZDU6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wOC0wOTozOTozMCAzYzBlZWUzZmU2YTNh
MWM3NDUzNzk1NDdjN2U3YzkwNGFhNjRmNmQ1IGNvbXBpbGluZwozMjQgcmVhbCAgMTAzNCB1
c2VyICA5MiBzeXMgIDM0Ny4yNiUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwOAoyMDE0
LTAzLTA4LTA5OjQ1OjE4IDNjMGVlZTNmZTZhM2ExYzc0NTM3OTU0N2M3ZTdjOTA0YWE2NGY2
ZDUgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2tlcm5lbC10ZXN0cy9saW51
eDIvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgv
M2MwZWVlM2ZlNmEzYTFjNzQ1Mzc5NTQ3YzdlN2M5MDRhYTY0ZjZkNQpiaXNlY3Q6IHNraXAg
YnJva2VuIGJ1aWxkIGZvciB2Mi42LjM3CmdpdCBjaGVja291dCB2Mi42LjM2CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9saW51
eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OmY2Zjk0ZTJhYjFiMzNmMDA4
MmFjMjJkNzFmNjYzODVhNjBkODE1N2Y6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wOC0wOTo0
NToyMiBmNmY5NGUyYWIxYjMzZjAwODJhYzIyZDcxZjY2Mzg1YTYwZDgxNTdmIGNvbXBpbGlu
ZwoxMzkgcmVhbCAgMTAxNyB1c2VyICA5MSBzeXMgIDc5My43MSUgY3B1IAlpMzg2LXJhbmRj
b25maWctcjUtMDMwOAoyMDE0LTAzLTA4LTA5OjQ3OjUwIGY2Zjk0ZTJhYjFiMzNmMDA4MmFj
MjJkNzFmNjYzODVhNjBkODE1N2YgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4g
L2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDgvZjZmOTRlMmFiMWIzM2YwMDgyYWMyMmQ3MWY2NjM4NWE2MGQ4
MTU3ZgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjM2CmdpdCBjaGVja291
dCB2Mi42LjM1CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5
OjlmZTYyMDZmNDAwNjQ2YTIzMjIwOTZiNTZjNTk4OTFkNTMwZThkNTE6YmlzZWN0LWxpbnV4
MgoKMjAxNC0wMy0wOC0wOTo0Nzo1NSA5ZmU2MjA2ZjQwMDY0NmEyMzIyMDk2YjU2YzU5ODkx
ZDUzMGU4ZDUxIGNvbXBpbGluZwobWzE7MzVtMjAxNC0wMy0wOCAwOTo0Nzo1NyBpMzg2LXJh
bmRjb25maWctcjUtMDMwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0y
MDE0LTAzLTA4IDA5OjQ4OjAxIGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZGNv
bmZpZyBzdWNjZWVkZWQbWzBtCjkzIHJlYWwgIDk4OSB1c2VyICA4OSBzeXMgIDExNTUuNDUl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKMjAxNC0wMy0wOC0wOTo0OTo0MiA5ZmU2
MjA2ZjQwMDY0NmEyMzIyMDk2YjU2YzU5ODkxZDUzMGU4ZDUxIFNLSVAgQlJPS0VOIEJVSUxE
CkNoZWNrIGVycm9zIGluIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QgYW5kIC90
bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzlmZTYyMDZmNDAwNjQ2YTIzMjIw
OTZiNTZjNTk4OTFkNTMwZThkNTEKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIu
Ni4zNQpnaXQgY2hlY2tvdXQgdjIuNi4zNApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1p
Mzg2LTIwMTQwMzA4MDYzOTplNDAxNTJlZTFlMWM3YTYzZjQ3Nzc3OTE4NjMyMTVlM2ZhYTM3
YTg2OmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDgtMDk6NDk6NDUgZTQwMTUyZWUxZTFjN2E2
M2Y0Nzc3NzkxODYzMjE1ZTNmYWEzN2E4NiBjb21waWxpbmcKG1sxOzM1bTIwMTQtMDMtMDgg
MDk6NDk6NDYgaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkbm9jb25maWcgZmFp
bGVkG1swbQobWzE7MzVtMjAxNC0wMy0wOCAwOTo0OTo0OSBpMzg2LXJhbmRjb25maWctcjUt
MDMwODogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo5NSByZWFsICA5NDYgdXNlciAg
ODUgc3lzICAxMDc3LjIxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yNS0wMzA4CjIwMTQtMDMt
MDgtMDk6NTE6MzkgZTQwMTUyZWUxZTFjN2E2M2Y0Nzc3NzkxODYzMjE1ZTNmYWEzN2E4NiBT
S0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAva2VybmVsLXRlc3RzL2xpbnV4Mi9v
YmotYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9lNDAx
NTJlZTFlMWM3YTYzZjQ3Nzc3OTE4NjMyMTVlM2ZhYTM3YTg2CmJpc2VjdDogc2tpcCBicm9r
ZW4gYnVpbGQgZm9yIHYyLjYuMzQKZ2l0IGNoZWNrb3V0IHYyLjYuMzMKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRl
dmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6NjBiMzQxYjc3OGNjMjkyOWRmMTZj
MGE1MDRjOTE2MjFiM2M2YTRhZDpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTA5OjUxOjQ0
IDYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0YzkxNjIxYjNjNmE0YWQgY29tcGlsaW5nChtb
MTszNW0yMDE0LTAzLTA4IDA5OjUxOjQ4IGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtl
IG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDggMDk6NTE6NTAgaTM4
Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMzQ3
IHJlYWwgIDkwNCB1c2VyICA4MiBzeXMgIDI4NC4xNiUgY3B1IAlpMzg2LXJhbmRjb25maWct
cjUtMDMwOAoyMDE0LTAzLTA4LTA5OjU3OjU1IDYwYjM0MWI3NzhjYzI5MjlkZjE2YzBhNTA0
YzkxNjIxYjNjNmE0YWQgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2tlcm5l
bC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXI1LTAzMDgvNjBiMzQxYjc3OGNjMjkyOWRmMTZjMGE1MDRjOTE2MjFiM2M2YTRhZApi
aXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjMzCmdpdCBjaGVja291dCB2Mi42
LjMyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
cjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OjIyNzYz
YzVjZjM2OTBhNjgxNTUxMTYyYzE1ZDM0ZDkzNTMwOGM4ZDc6YmlzZWN0LWxpbnV4MgoKMjAx
NC0wMy0wOC0wOTo1Nzo1OSAyMjc2M2M1Y2YzNjkwYTY4MTU1MTE2MmMxNWQzNGQ5MzUzMDhj
OGQ3IGNvbXBpbGluZwobWzE7MzVtMjAxNC0wMy0wOCAwOTo1ODowMSBpMzg2LXJhbmRjb25m
aWctcjUtMDMwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAz
LTA4IDA5OjU4OjA0IGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZGNvbmZpZyBz
dWNjZWVkZWQbWzBtCjY2IHJlYWwgIDg4NiB1c2VyICA4MCBzeXMgIDE0NTIuNzglIGNwdSAJ
aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKMjAxNC0wMy0wOC0wOTo1OToyNSAyMjc2M2M1Y2Yz
NjkwYTY4MTU1MTE2MmMxNWQzNGQ5MzUzMDhjOGQ3IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNr
IGVycm9zIGluIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QgYW5kIC90bXAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzIyNzYzYzVjZjM2OTBhNjgxNTUxMTYyYzE1
ZDM0ZDkzNTMwOGM4ZDcKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4zMgpn
aXQgY2hlY2tvdXQgdjIuNi4zMQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIw
MTQwMzA4MDYzOTo3NGZjYTZhNDI4NjNmZmFjYWY3YmE2ZjE5MzZhOWYyMjg5NTBmNjU3OmJp
c2VjdC1saW51eDIKCjIwMTQtMDMtMDgtMDk6NTk6MjggNzRmY2E2YTQyODYzZmZhY2FmN2Jh
NmYxOTM2YTlmMjI4OTUwZjY1NyBjb21waWxpbmcKG1sxOzM1bTIwMTQtMDMtMDggMDk6NTk6
MzEgaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1sw
bQobWzE7MzVtMjAxNC0wMy0wOCAwOTo1OTozNCBpMzg2LXJhbmRjb25maWctcjUtMDMwODog
bWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQo5MiByZWFsICA4NDYgdXNlciAgNzggc3lz
ICAxMDAxLjYzJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yNS0wMzA4CjIwMTQtMDMtMDgtMTA6
MDE6MjAgNzRmY2E2YTQyODYzZmZhY2FmN2JhNmYxOTM2YTlmMjI4OTUwZjY1NyBTS0lQIEJS
T0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlz
ZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC83NGZjYTZhNDI4
NjNmZmFjYWY3YmE2ZjE5MzZhOWYyMjg5NTBmNjU3CmJpc2VjdDogc2tpcCBicm9rZW4gYnVp
bGQgZm9yIHYyLjYuMzEKZ2l0IGNoZWNrb3V0IHYyLjYuMzAKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRl
dmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6MDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQzZGZk
OTVkZTVjMDI2NDhjNjpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTEwOjAxOjIzIDA3YTIw
MzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1YzAyNjQ4YzYgY29tcGlsaW5nChtbMTszNW0y
MDE0LTAzLTA4IDEwOjAxOjI2IGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZG5v
Y29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDggMTA6MDE6MzAgaTM4Ni1yYW5k
Y29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMjYyIHJlYWwg
IDU4NiB1c2VyICA2NCBzeXMgIDI0OC4xMyUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMw
OAoyMDE0LTAzLTA4LTEwOjA2OjE1IDA3YTIwMzliOGViMGFmNGZmNDY0ZWZkM2RmZDk1ZGU1
YzAyNjQ4YzYgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2tlcm5lbC10ZXN0
cy9saW51eDIvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1
LTAzMDgvMDdhMjAzOWI4ZWIwYWY0ZmY0NjRlZmQzZGZkOTVkZTVjMDI2NDhjNgpiaXNlY3Q6
IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjMwCmdpdCBjaGVja291dCB2Mi42LjI5Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMw
OC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OjhlMGVlNDNiYzJj
M2UxOWRiNTZhNGFkYWE5YTliMDRjZTg4NWNkODQ6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0w
OC0xMDowNjoxOSA4ZTBlZTQzYmMyYzNlMTlkYjU2YTRhZGFhOWE5YjA0Y2U4ODVjZDg0IGNv
bXBpbGluZwobWzE7MzVtMjAxNC0wMy0wOCAxMDowNjoyMSBpMzg2LXJhbmRjb25maWctcjUt
MDMwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTA4IDEw
OjA2OjIyIGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVk
ZWQbWzBtCjQ1NiByZWFsICA1OTIgdXNlciAgNjMgc3lzICAxNDMuODMlIGNwdSAJaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDgKMjAxNC0wMy0wOC0xMDoxNDo1OCA4ZTBlZTQzYmMyYzNlMTlk
YjU2YTRhZGFhOWE5YjA0Y2U4ODVjZDg0IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9z
IGluIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yNS0wMzA4LzhlMGVlNDNiYzJjM2UxOWRiNTZhNGFkYWE5YTliMDRj
ZTg4NWNkODQKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yOQpnaXQgY2hl
Y2tvdXQgdjIuNi4yOApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDgvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA4
MDYzOTo0YTY5MDhhM2EwNTBhYWNjOWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxOmJpc2VjdC1s
aW51eDIKCjIwMTQtMDMtMDgtMTA6MTU6MDIgNGE2OTA4YTNhMDUwYWFjYzljM2EyZjM2YjI3
NmI0NmMwNjI5YWQ5MSBjb21waWxpbmcKG1sxOzM1bTIwMTQtMDMtMDggMTA6MTU6MDUgaTM4
Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7
MzVtMjAxNC0wMy0wOCAxMDoxNTowOCBpMzg2LXJhbmRjb25maWctcjUtMDMwODogbWFrZSBv
bGRjb25maWcgc3VjY2VlZGVkG1swbQoxOTcgcmVhbCAgNjIxIHVzZXIgIDY0IHN5cyAgMzQ3
LjEwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yNS0wMzA4CjIwMTQtMDMtMDgtMTA6MTg6NTQg
NGE2OTA4YTNhMDUwYWFjYzljM2EyZjM2YjI3NmI0NmMwNjI5YWQ5MSBTS0lQIEJST0tFTiBC
VUlMRApDaGVjayBlcnJvcyBpbiAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0IGFu
ZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC80YTY5MDhhM2EwNTBhYWNj
OWMzYTJmMzZiMjc2YjQ2YzA2MjlhZDkxCmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9y
IHYyLjYuMjgKZ2l0IGNoZWNrb3V0IHYyLjYuMjcKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJv
YW0taTM4Ni0yMDE0MDMwODA2Mzk6M2ZhODc0OWU1ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5
MGJhYzFlNTpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTEwOjE4OjU3IDNmYTg3NDllNTg0
YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTUgY29tcGlsaW5nCjIwMTQtMDMtMDggMTA6
MTg6NTc6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXMnICctcScgJy1GJyAnJGFyY2ggZXEg
ImkzODYiJyAnL2tlcm5lbC10ZXN0cy9saW51eDIvc2NyaXB0cy9yZWNvcmRtY291bnQucGwn
ICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2gtZ3JlcC1rYnVpbGQubG9nChtbMTszNW0yMDE0LTAzLTA4IDEw
OjE4OjU5IGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxl
ZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDggMTA6MTk6MDMgaTM4Ni1yYW5kY29uZmlnLXI1LTAz
MDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KMjQ1IHJlYWwgIDU1MSB1c2VyICA1
NyBzeXMgIDI0Ny41MCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwOAoyMDE0LTAzLTA4
LTEwOjIzOjM2IDNmYTg3NDllNTg0YjU1ZjExODA0MTFhYjFiNTExMTcxOTBiYWMxZTUgU0tJ
UCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4gL2tlcm5lbC10ZXN0cy9saW51eDIvb2Jq
LWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvM2ZhODc0
OWU1ODRiNTVmMTE4MDQxMWFiMWI1MTExNzE5MGJhYzFlNQpiaXNlY3Q6IHNraXAgYnJva2Vu
IGJ1aWxkIGZvciB2Mi42LjI3CmdpdCBjaGVja291dCB2Mi42LjI2CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9saW51eC1kZXZl
bDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5OmJjZTdmNzkzZGFlYzNlNjVlYzVjNTcw
NWQyNDU3YjgxZmU3YjU3MjU6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wOC0xMDoyMzo0MCBi
Y2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZlN2I1NzI1IGNvbXBpbGluZwoyMDE0
LTAzLTA4IDEwOjIzOjQwOiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1zJyAnLXEnICctRicg
JyRhcmNoIGVxICJpMzg2IicgJy9rZXJuZWwtdGVzdHMvbGludXgyL3NjcmlwdHMvcmVjb3Jk
bWNvdW50LnBsJyAsIHJldD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUt
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoLWdyZXAta2J1aWxkLmxvZwobWzE7MzVtMjAx
NC0wMy0wOCAxMDoyMzo0MSBpMzg2LXJhbmRjb25maWctcjUtMDMwODogbWFrZSBvbGRub2Nv
bmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAzLTA4IDEwOjIzOjQ1IGkzODYtcmFuZGNv
bmZpZy1yNS0wMzA4OiBtYWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjI1MCByZWFsICA1
MTQgdXNlciAgNTQgc3lzICAyMjYuNzklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgK
MjAxNC0wMy0wOC0xMDoyODoyNSBiY2U3Zjc5M2RhZWMzZTY1ZWM1YzU3MDVkMjQ1N2I4MWZl
N2I1NzI1IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9rZXJuZWwtdGVzdHMv
bGludXgyL29iai1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0w
MzA4L2JjZTdmNzkzZGFlYzNlNjVlYzVjNTcwNWQyNDU3YjgxZmU3YjU3MjUKYmlzZWN0OiBz
a2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4yNgpnaXQgY2hlY2tvdXQgdjIuNi4yNQpscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgv
bGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMzA4MDYzOTo0YjExOWUyMWQwYzY2
YzIyZThjYTAzZGYwNWQ5ZGU2MjNkMGViNTBmOmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDgt
MTA6Mjg6MjggNGIxMTllMjFkMGM2NmMyMmU4Y2EwM2RmMDVkOWRlNjIzZDBlYjUwZiBjb21w
aWxpbmcKMjAxNC0wMy0wOCAxMDoyODoyODogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcycg
Jy1xJyAnLUYnICckYXJjaCBlcSAiaTM4NiInICcva2VybmVsLXRlc3RzL2xpbnV4Mi9zY3Jp
cHRzL3JlY29yZG1jb3VudC5wbCcgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxl
ZC1jbWQvYmVlLWJpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaC1ncmVwLWtidWlsZC5sb2cK
G1sxOzM1bTIwMTQtMDMtMDggMTA6Mjg6MzAgaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1h
a2Ugb2xkbm9jb25maWcgZmFpbGVkG1swbQobWzE7MzVtMjAxNC0wMy0wOCAxMDoyODozMyBp
Mzg2LXJhbmRjb25maWctcjUtMDMwODogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQox
NDYgcmVhbCAgNTM3IHVzZXIgIDUzIHN5cyAgNDAzLjkyJSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1yNS0wMzA4CjIwMTQtMDMtMDgtMTA6MzE6NDEgNGIxMTllMjFkMGM2NmMyMmU4Y2EwM2Rm
MDVkOWRlNjIzZDBlYjUwZiBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAva2Vy
bmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjUtMDMwOC80YjExOWUyMWQwYzY2YzIyZThjYTAzZGYwNWQ5ZGU2MjNkMGViNTBm
CmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjUKZ2l0IGNoZWNrb3V0IHYy
LjYuMjQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6NDk5
MTQwODRlNzk3NTMwZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhODpiaXNlY3QtbGludXgyCgoy
MDE0LTAzLTA4LTEwOjMxOjQ1IDQ5OTE0MDg0ZTc5NzUzMGQ5YmFhZjUxZGY5ZWRhNzdiYWJj
OThmYTggY29tcGlsaW5nCjIwMTQtMDMtMDggMTA6MzE6NDU6IGNtZF9mYWlsOiAnL2Jpbi9n
cmVwJyAnLXMnICctcScgJy1GJyAnJGFyY2ggZXEgImkzODYiJyAnL2tlcm5lbC10ZXN0cy9s
aW51eDIvc2NyaXB0cy9yZWNvcmRtY291bnQucGwnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10
ZXN0cy9mYWlsZWQtY21kL2JlZS1iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gtZ3JlcC1r
YnVpbGQubG9nChtbMTszNW0yMDE0LTAzLTA4IDEwOjMxOjQ3IGkzODYtcmFuZGNvbmZpZy1y
NS0wMzA4OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDgg
MTA6MzE6NTAgaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2Nl
ZWRlZBtbMG0KNzYgcmVhbCAgNDcyIHVzZXIgIDUwIHN5cyAgNjgyLjc2JSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1yNS0wMzA4CjIwMTQtMDMtMDgtMTA6MzM6NDEgNDk5MTQwODRlNzk3NTMw
ZDliYWFmNTFkZjllZGE3N2JhYmM5OGZhOCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJv
cyBpbiAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjUtMDMwOC80OTkxNDA4NGU3OTc1MzBkOWJhYWY1MWRmOWVkYTc3
YmFiYzk4ZmE4CmJpc2VjdDogc2tpcCBicm9rZW4gYnVpbGQgZm9yIHYyLjYuMjQKZ2l0IGNo
ZWNrb3V0IHYyLjYuMjMKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDMw
ODA2Mzk6YmJmMjUwMTBmMWE2Yjc2MTkxNDQzMGY1ZmNhMDgxZWM4YzdhY2NkMTpiaXNlY3Qt
bGludXgyCgoyMDE0LTAzLTA4LTEwOjMzOjQ0IGJiZjI1MDEwZjFhNmI3NjE5MTQ0MzBmNWZj
YTA4MWVjOGM3YWNjZDEgY29tcGlsaW5nCjIwMTQtMDMtMDggMTA6MzM6NDU6IGNtZF9mYWls
OiAnL2Jpbi9ncmVwJyAnLXMnICctcScgJy1GJyAnJGFyY2ggZXEgImkzODYiJyAnL2tlcm5l
bC10ZXN0cy9saW51eDIvc2NyaXB0cy9yZWNvcmRtY291bnQucGwnICwgcmV0PTIsIHJlZjog
L2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2gtZ3JlcC1rYnVpbGQubG9nChtbMTszNW0yMDE0LTAzLTA4IDEwOjMzOjQ3IGkzODYtcmFu
ZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZG5vY29uZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIw
MTQtMDMtMDggMTA6MzM6NTIgaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkY29u
ZmlnIHN1Y2NlZWRlZBtbMG0KMTMzIHJlYWwgIDQ0OCB1c2VyICA0NCBzeXMgIDM2OS4xMyUg
Y3B1IAlpMzg2LXJhbmRjb25maWctcjUtMDMwOAoyMDE0LTAzLTA4LTEwOjM3OjAxIGJiZjI1
MDEwZjFhNmI3NjE5MTQ0MzBmNWZjYTA4MWVjOGM3YWNjZDEgU0tJUCBCUk9LRU4gQlVJTEQK
Q2hlY2sgZXJyb3MgaW4gL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCBhbmQgL3Rt
cC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvYmJmMjUwMTBmMWE2Yjc2MTkxNDQz
MGY1ZmNhMDgxZWM4YzdhY2NkMQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42
LjIzCmdpdCBjaGVja291dCB2Mi42LjIyCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkz
ODYtMjAxNDAzMDgwNjM5OjdkY2NhMzBhMzJhYWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUw
NWM6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wOC0xMDozNzowNCA3ZGNjYTMwYTMyYWFkYjA1
MjA0MTc1MjFiMGM0NGY0MmQwOWZlMDVjIGNvbXBpbGluZwoyMDE0LTAzLTA4IDEwOjM3OjA1
OiBjbWRfZmFpbDogJy9iaW4vZ3JlcCcgJy1zJyAnLXEnICctRicgJyRhcmNoIGVxICJpMzg2
IicgJy9rZXJuZWwtdGVzdHMvbGludXgyL3NjcmlwdHMvcmVjb3JkbWNvdW50LnBsJyAsIHJl
dD0yLCByZWY6IC9rZXJuZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoLWdyZXAta2J1aWxkLmxvZwobWzE7MzVtMjAxNC0wMy0wOCAxMDozNzox
NCBpMzg2LXJhbmRjb25maWctcjUtMDMwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBt
ChtbMTszNW0yMDE0LTAzLTA4IDEwOjM3OjE4IGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBt
YWtlIG9sZGNvbmZpZyBzdWNjZWVkZWQbWzBtCjMzOSByZWFsICA0MTkgdXNlciAgNDIgc3lz
ICAxMzYuMTUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgKMjAxNC0wMy0wOC0xMDo0
MzoyOCA3ZGNjYTMwYTMyYWFkYjA1MjA0MTc1MjFiMGM0NGY0MmQwOWZlMDVjIFNLSVAgQlJP
S0VOIEJVSUxECkNoZWNrIGVycm9zIGluIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNl
Y3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4LzdkY2NhMzBhMzJh
YWRiMDUyMDQxNzUyMWIwYzQ0ZjQyZDA5ZmUwNWMKYmlzZWN0OiBza2lwIGJyb2tlbiBidWls
ZCBmb3IgdjIuNi4yMgpnaXQgY2hlY2tvdXQgdjIuNi4yMQpscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDgvbGludXgtZGV2ZWw6ZGV2
ZWwtcm9hbS1pMzg2LTIwMTQwMzA4MDYzOTpkZTQ2YzMzNzQ1ZjVlMmFkNTk0YzcyZjJjZjVm
NDkwODYxYjE2Y2UxOmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDgtMTA6NDM6MzIgZGU0NmMz
Mzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIxNmNlMSBjb21waWxpbmcKMjAxNC0wMy0w
OCAxMDo0MzozMzogY21kX2ZhaWw6ICcvYmluL2dyZXAnICctcycgJy1xJyAnLUYnICckYXJj
aCBlcSAiaTM4NiInICcva2VybmVsLXRlc3RzL2xpbnV4Mi9zY3JpcHRzL3JlY29yZG1jb3Vu
dC5wbCcgLCByZXQ9MiwgcmVmOiAva2VybmVsLXRlc3RzL2ZhaWxlZC1jbWQvYmVlLWJpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaC1ncmVwLWtidWlsZC5sb2cKG1sxOzM1bTIwMTQtMDMt
MDggMTA6NDM6MzYgaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2Ugb2xkbm9jb25maWcg
ZmFpbGVkG1swbQobWzE7MzVtMjAxNC0wMy0wOCAxMDo0MzozOCBpMzg2LXJhbmRjb25maWct
cjUtMDMwODogbWFrZSBvbGRjb25maWcgc3VjY2VlZGVkG1swbQobWzE7MzVtMjAxNC0wMy0w
OCAxMDo0NDoxMyBpMzg2LXJhbmRjb25maWctcjUtMDMwODogbWFrZSBtb2R1bGVzX3ByZXBh
cmUgZmFpbGVkG1swbQoyMDE0LTAzLTA4LTEwOjQ0OjEzIGRlNDZjMzM3NDVmNWUyYWQ1OTRj
NzJmMmNmNWY0OTA4NjFiMTZjZTEgU0tJUCBCUk9LRU4gQlVJTEQKQ2hlY2sgZXJyb3MgaW4g
L2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdCBhbmQgL3RtcC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXI1LTAzMDgvZGU0NmMzMzc0NWY1ZTJhZDU5NGM3MmYyY2Y1ZjQ5MDg2MWIx
NmNlMQpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2Mi42LjIxCmdpdCBjaGVja291
dCB2Mi42LjIwCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctcjUtMDMwOC9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDAzMDgwNjM5
OjYyZDBjZmNiMjdjZjc1NWNlYmRjOTNjYTk1ZGFiYzgzNjA4MDA3Y2Q6YmlzZWN0LWxpbnV4
MgoKMjAxNC0wMy0wOC0xMDo0NDoxNiA2MmQwY2ZjYjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4
MzYwODAwN2NkIGNvbXBpbGluZwoyMDE0LTAzLTA4IDEwOjQ0OjE2OiBjbWRfZmFpbDogJy9i
aW4vZ3JlcCcgJy1zJyAnLXEnICctRicgJyRhcmNoIGVxICJpMzg2IicgJy9rZXJuZWwtdGVz
dHMvbGludXgyL3NjcmlwdHMvcmVjb3JkbWNvdW50LnBsJyAsIHJldD0yLCByZWY6IC9rZXJu
ZWwtdGVzdHMvZmFpbGVkLWNtZC9iZWUtYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoLWdy
ZXAta2J1aWxkLmxvZwobWzE7MzVtMjAxNC0wMy0wOCAxMDo0NDoxOSBpMzg2LXJhbmRjb25m
aWctcjUtMDMwODogbWFrZSBvbGRub2NvbmZpZyBmYWlsZWQbWzBtChtbMTszNW0yMDE0LTAz
LTA4IDEwOjQ0OjIwIGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZGNvbmZpZyBz
dWNjZWVkZWQbWzBtChtbMTszNW0yMDE0LTAzLTA4IDEwOjQ0OjQ1IGkzODYtcmFuZGNvbmZp
Zy1yNS0wMzA4OiBtYWtlIG1vZHVsZXNfcHJlcGFyZSBmYWlsZWQbWzBtCjIwMTQtMDMtMDgt
MTA6NDQ6NDUgNjJkMGNmY2IyN2NmNzU1Y2ViZGM5M2NhOTVkYWJjODM2MDgwMDdjZCBTS0lQ
IEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmot
YmlzZWN0IGFuZCAvdG1wL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjUtMDMwOC82MmQwY2Zj
YjI3Y2Y3NTVjZWJkYzkzY2E5NWRhYmM4MzYwODAwN2NkCmJpc2VjdDogc2tpcCBicm9rZW4g
YnVpbGQgZm9yIHYyLjYuMjAKZ2l0IGNoZWNrb3V0IHYyLjYuMTkKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yNS0wMzA4L2xpbnV4LWRldmVs
OmRldmVsLXJvYW0taTM4Ni0yMDE0MDMwODA2Mzk6MDIxNWZmYjA4Y2U5OWUyYmI1OWVjYTEx
NGE5OTQ5OWE0ZDA2ZTcwNDpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA4LTEwOjQ0OjQ4IDAy
MTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlhNGQwNmU3MDQgY29tcGlsaW5nCjIwMTQt
MDMtMDggMTA6NDQ6NDg6IGNtZF9mYWlsOiAnL2Jpbi9ncmVwJyAnLXMnICctcScgJy1GJyAn
JGFyY2ggZXEgImkzODYiJyAnL2tlcm5lbC10ZXN0cy9saW51eDIvc2NyaXB0cy9yZWNvcmRt
Y291bnQucGwnICwgcmV0PTIsIHJlZjogL2tlcm5lbC10ZXN0cy9mYWlsZWQtY21kL2JlZS1i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gtZ3JlcC1rYnVpbGQubG9nChtbMTszNW0yMDE0
LTAzLTA4IDEwOjQ0OjQ5IGkzODYtcmFuZGNvbmZpZy1yNS0wMzA4OiBtYWtlIG9sZG5vY29u
ZmlnIGZhaWxlZBtbMG0KG1sxOzM1bTIwMTQtMDMtMDggMTA6NDQ6NTMgaTM4Ni1yYW5kY29u
ZmlnLXI1LTAzMDg6IG1ha2Ugb2xkY29uZmlnIHN1Y2NlZWRlZBtbMG0KG1sxOzM1bTIwMTQt
MDMtMDggMTA6NDU6MjIgaTM4Ni1yYW5kY29uZmlnLXI1LTAzMDg6IG1ha2UgbW9kdWxlc19w
cmVwYXJlIGZhaWxlZBtbMG0KMjAxNC0wMy0wOC0xMDo0NToyMiAwMjE1ZmZiMDhjZTk5ZTJi
YjU5ZWNhMTE0YTk5NDk5YTRkMDZlNzA0IFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIGVycm9z
IGluIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yNS0wMzA4LzAyMTVmZmIwOGNlOTllMmJiNTllY2ExMTRhOTk0OTlh
NGQwNmU3MDQKYmlzZWN0OiBza2lwIGJyb2tlbiBidWlsZCBmb3IgdjIuNi4xOQobWzE7MzVt
MjAxNC0wMy0wOCAxMDo0NToyMiBDYW5ub3QgZmluZCB0aGUgZmlyc3QgZ29vZCBjb21taXQu
G1swbQobWzE7MzVtMjAxNC0wMy0wOCAxMDo0NToyMiBiaXNlY3QgZmFpbGVkG1swbQo=

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-02112-g3903b5b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
CONFIG_MODULE_SIG_HASH="sha512"
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_APB_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_GX_SUSPMOD=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=m
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
# CONFIG_YENTA_TOSHIBA is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=m
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=m
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=m
# CONFIG_NET_IPGRE is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=m
# CONFIG_NF_CONNTRACK is not set
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_INET=m
# CONFIG_NFT_EXTHDR is not set
CONFIG_NFT_META=m
CONFIG_NFT_RBTREE=m
CONFIG_NFT_HASH=y
CONFIG_NFT_COUNTER=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=y
CONFIG_NFT_REJECT=y
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
# CONFIG_IP_VS_PROTO_TCP is not set
# CONFIG_IP_VS_PROTO_UDP is not set
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
# CONFIG_IP_VS_WLC is not set
# CONFIG_IP_VS_LBLC is not set
CONFIG_IP_VS_LBLCR=m
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

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_NF_TABLES_IPV4=m
CONFIG_NFT_CHAIN_ROUTE_IPV4=m
CONFIG_NFT_REJECT_IPV4=m
# CONFIG_NF_TABLES_ARP is not set
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
CONFIG_NF_TABLES_IPV6=m
CONFIG_NFT_CHAIN_ROUTE_IPV6=m
CONFIG_NFT_REJECT_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_FILTER=m
# CONFIG_IP6_NF_TARGET_REJECT is not set
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_NF_TABLES_BRIDGE=y
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
# CONFIG_BRIDGE_EBT_T_FILTER is not set
CONFIG_BRIDGE_EBT_T_NAT=m
# CONFIG_BRIDGE_EBT_802_3 is not set
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
# CONFIG_BRIDGE_EBT_ARPREPLY is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=m
# CONFIG_BRIDGE_EBT_REDIRECT is not set
# CONFIG_BRIDGE_EBT_SNAT is not set
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
# CONFIG_RDS_TCP is not set
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=m
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=m
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
# CONFIG_ESI_DONGLE is not set
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
# CONFIG_MCP2120_DONGLE is not set
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_WILINK=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
CONFIG_RFKILL_GPIO=m
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=m
CONFIG_NFC_DIGITAL=m
CONFIG_NFC_NCI=m
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=m
CONFIG_NFC_MEI_PHY=m
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=m
# CONFIG_NFC_MICROREAD_I2C is not set
CONFIG_NFC_MICROREAD_MEI=m
CONFIG_NFC_MRVL=m

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
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
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=m
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
CONFIG_HP_ILO=m
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=m
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=m
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=m
CONFIG_TOUCHSCREEN_DA9052=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=m
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_INTEL_MID is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM831X=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_STMPE=m
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
CONFIG_INPUT_88PM80X_ONKEY=m
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_AD714X_SPI=m
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_TILT_POLLED=m
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=m
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_ADXL34X_SPI=m
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=m
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_MOXA_INTELLIO=m
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=m
CONFIG_N_HDLC=y
CONFIG_N_GSM=m
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MRST_MAX3110 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_HW_RANDOM_TPM=m
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=m
CONFIG_TCG_ST33_I2C=m
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=m
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=m
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_TOPCLIFF_PCH=m
CONFIG_SPI_XCOMM=m
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
CONFIG_SPI_DW_PCI=m

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=m
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_TS5500=m
CONFIG_GPIO_SCH=m
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
CONFIG_GPIO_LYNXPOINT=m

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TPS65912=m
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_ADP5520=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_MSIC=y

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_BATTERY_INTEL_MID=m
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_LP8788=m
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MAX8998=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_GEODE_WDT=m
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
# CONFIG_INTEL_SCU_WATCHDOG is not set
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=m
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_MSIC=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=m
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AAT2870=y
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=m
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8998=m
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
# CONFIG_REGULATOR_TPS6507X is not set
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=m
# CONFIG_REGULATOR_TPS65910 is not set
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_WM831X=m
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog/hybrid TV support
#

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_BUDGET_CORE is not set
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG=y
# CONFIG_DVB_PLUTO2 is not set
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
CONFIG_MANTIS_CORE=y
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=y
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m

#
# Supported MMC/SDIO adapters
#

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
# CONFIG_MEDIA_TUNER_TDA9887 is not set
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_E4000 is not set
# CONFIG_MEDIA_TUNER_FC2580 is not set
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=y
# CONFIG_DVB_STV090x is not set
CONFIG_DVB_STV6110x=m
# CONFIG_DVB_M88DS3103 is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=y
# CONFIG_DVB_STV6110 is not set
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
CONFIG_DVB_TDA8261=m
# CONFIG_DVB_VES1X93 is not set
CONFIG_DVB_TUNER_ITD1000=m
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=y
CONFIG_DVB_CX24117=m
CONFIG_DVB_SI21XX=m
# CONFIG_DVB_TS2020 is not set
CONFIG_DVB_DS3000=m
# CONFIG_DVB_MB86A16 is not set
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
# CONFIG_DVB_S5H1432 is not set
# CONFIG_DVB_DRXD is not set
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=y
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=m
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=m
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=y
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=y
# CONFIG_DVB_IT913X_FE is not set
# CONFIG_DVB_M88RS2000 is not set
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_I915_FBDEV is not set
# CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
CONFIG_DRM_I915_UMS=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_MEDFIELD is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=m
# CONFIG_DRM_BOCHS is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=m
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=m
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=m
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=m
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_OT200 is not set
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=m
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m

#
# I2C HID support
#
CONFIG_I2C_HID=m
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
CONFIG_UWB=m
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=m
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DA9052=m
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_DELL_NETBOOKS=m
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=m
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=m
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_WMI=y
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_AMILO_RFKILL=m
# CONFIG_TC1100_WMI is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=y
# CONFIG_COMPAL_LAPTOP is not set
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_SCU_IPC=y
# CONFIG_INTEL_SCU_IPC_UTIL is not set
# CONFIG_GPIO_INTEL_PMIC is not set
# CONFIG_INTEL_MID_POWER_BUTTON is not set
CONFIG_INTEL_MFLD_THERMAL=m
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=m
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=m
CONFIG_INTEL_RST=m
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=m
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=m
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
# CONFIG_AD7266 is not set
CONFIG_AD7298=m
# CONFIG_AD7476 is not set
CONFIG_AD7791=m
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=m
CONFIG_MCP320X=m
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
# CONFIG_AD5380 is not set
CONFIG_AD5421=m
CONFIG_AD5446=m
CONFIG_AD5449=m
CONFIG_AD5504=m
CONFIG_AD5624R_SPI=m
CONFIG_AD5686=m
CONFIG_AD5755=m
CONFIG_AD5764=m
CONFIG_AD5791=m
CONFIG_AD7303=m
CONFIG_MAX517=m
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16136=m
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=m
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
CONFIG_ITG3200=m

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=m
CONFIG_ADIS16480=m
# CONFIG_INV_MPU6050_IIO is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=m
# CONFIG_HID_SENSOR_PROX is not set
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_LTR501 is not set
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=m
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=m

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
CONFIG_MPL3115=m
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
CONFIG_TMP006=m
CONFIG_NTB=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
# CONFIG_UBIFS_FS_ZLIB is not set
# CONFIG_LOGFS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_EFIVAR_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
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
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_INTEGRITY_AUDIT is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=m
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--Nq2Wo0NMKNjxTN9z--
