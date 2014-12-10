Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbaLJXU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:20:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:63921 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125AbaLJXUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:20:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="427547890"
Date: Wed, 10 Dec 2014 15:20:49 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Michael Turquette <mturquette@deferred.io>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [sched] BUG: unable to handle kernel
Message-ID: <20141210232049.GC24163@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.linaro.org/people/mturquette/linux.git eas-next

commit 1fadb581b0be9420b143e43ff2f4a07ea7e45f6c
Author:     Dietmar Eggemann <dietmar.eggemann@arm.com>
AuthorDate: Tue Dec 2 14:06:24 2014 +0000
Commit:     Michael Turquette <mturquette@deferred.io>
CommitDate: Tue Dec 9 20:33:17 2014 -0800

    sched: Make usage and load tracking cpu scale-invariant
    
    Besides the existing frequency scale-invariance correction factor, apply
    cpu scale-invariance correction factor to usage and load tracking.
    
    Cpu scale-invariance takes cpu performance deviations due to
    micro-architectural differences (i.e. instructions per seconds) between
    cpus in HMP systems (e.g. big.LITTLE) and differences in the frequency
    value of the highest OPP between cpus in SMP systems into consideration.
    
    Each segment of the sched_avg::{running_avg_sum, runnable_avg_sum}
    geometric series is now scaled by the cpu performance factor too so the
    sched_avg::{utilization_avg_contrib, load_avg_contrib} of each entity will
    be invariant from the particular cpu of the HMP/SMP system it is gathered
    on. As a result, cfs_rq::runnable_load_avg which is the sum of
    sched_avg::load_avg_contrib, becomes cpu scale-invariant too.
    
    So the {usage, load} level that is returned by {get_cpu_usage,
    weighted_cpuload} stays relative to the max cpu performance of the system.
    
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+-------------------------------------------------------+------------+------------+------------+
|                                                       | e754569101 | 1fadb581b0 | 41ae5f4aae |
+-------------------------------------------------------+------------+------------+------------+
| boot_successes                                        | 0          | 0          | 0          |
| boot_failures                                         | 175        | 35         | 16         |
| INFO:suspicious_RCU_usage                             | 175        |            |            |
| RCU_used_illegally_from_idle_CPU                      | 42         |            |            |
| RCU_used_illegally_from_extended_quiescent_state      | 42         |            |            |
| backtrace:do_fork                                     | 175        |            |            |
| BUG:kernel_boot_crashed                               | 0          | 4          |            |
| BUG:unable_to_handle_kernel                           | 0          | 31         | 16         |
| Oops                                                  | 0          | 31         | 16         |
| RIP:default_scale_cpu_capacity                        | 0          | 31         | 16         |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 31         | 16         |
| backtrace:acpi_load_tables                            | 0          | 30         | 15         |
| backtrace:acpi_early_init                             | 0          | 31         | 15         |
| backtrace:acpi_initialize_subsystem                   | 0          | 1          |            |
| backtrace:acpi_ds_auto_serialize_method               | 0          | 6          |            |
| backtrace:acpi_ds_init_one_object                     | 0          | 6          |            |
| backtrace:kmem_cache_create                           | 0          | 0          | 1          |
| backtrace:pidmap_init                                 | 0          | 0          | 1          |
| backtrace:acpi_ns_lookup                              | 0          | 0          | 1          |
| backtrace:acpi_ds_init_field_objects                  | 0          | 0          | 1          |
+-------------------------------------------------------+------------+------------+------------+

[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI: Core revision 20140926
[    0.020018] BUG: unable to handle kernel 
[    0.020018] BUG: unable to handle kernel NULL pointer dereferenceNULL pointer dereference at 0000000000000050
 at 0000000000000050
[    0.021436] IP:
[    0.021436] IP: [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
 [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
[    0.022741] PGD 0 
[    0.022741] PGD 0 

[    0.023123] Oops: 0000 [#1] 
[    0.023123] Oops: 0000 [#1] PREEMPT PREEMPT SMP SMP 

[    0.023853] Modules linked in:
[    0.023853] Modules linked in:

[    0.024476] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-00089-g1fadb58 #3
[    0.024476] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-00089-g1fadb58 #3
[    0.026198] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    0.026198] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    0.027982] task: ffffffff81c0f500 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[    0.027982] task: ffffffff81c0f500 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[    0.029308] RIP: 0010:[<ffffffff810d68a2>] 
[    0.029308] RIP: 0010:[<ffffffff810d68a2>]  [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
 [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
[    0.030000] RSP: 0000:ffff880012603d10  EFLAGS: 00010002
[    0.030000] RSP: 0000:ffff880012603d10  EFLAGS: 00010002
[    0.030000] RAX: 0000000000000400 RBX: 0000000000000400 RCX: 0000000000000000
[    0.030000] RAX: 0000000000000400 RBX: 0000000000000400 RCX: 0000000000000000
[    0.030000] RDX: 0000000000004c4c RSI: 0000000000000000 RDI: 0000000000000000
[    0.030000] RDX: 0000000000004c4c RSI: 0000000000000000 RDI: 0000000000000000
[    0.030000] RBP: ffff880012603d18 R08: 0000000000000001 R09: 0000000000000017
[    0.030000] RBP: ffff880012603d18 R08: 0000000000000001 R09: 0000000000000017
[    0.030000] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    0.030000] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    0.030000] R13: ffffffff81c0f568 R14: ffffffff81c03b98 R15: 0000000000000000
[    0.030000] R13: ffffffff81c0f568 R14: ffffffff81c03b98 R15: 0000000000000000
[    0.030000] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:0000000000000000
[    0.030000] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:0000000000000000
[    0.030000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.030000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.030000] CR2: 0000000000000050 CR3: 0000000001c08000 CR4: 00000000000006b0
[    0.030000] CR2: 0000000000000050 CR3: 0000000001c08000 CR4: 00000000000006b0
[    0.030000] Stack:
[    0.030000] Stack:
[    0.030000]  ffffffff810d88d4
[    0.030000]  ffffffff810d88d4 ffff880012603d88 ffff880012603d88 ffffffff810d8986 ffffffff810d8986 ffffffff810cd13f ffffffff810cd13f

[    0.030000]  0000000000000000
[    0.030000]  0000000000000000 ffff880000000001 ffff880000000001 00ffffff00000000 00ffffff00000000 0000000000004c4c 0000000000004c4c

[    0.030000]  ffff880012612d70
[    0.030000]  ffff880012612d70 ffff880012603d88 ffff880012603d88 ffff880012612d70 ffff880012612d70 ffffffff81c0f500 ffffffff81c0f500

[    0.030000] Call Trace:
[    0.030000] Call Trace:
[    0.030000]  <IRQ> 
[    0.030000]  <IRQ> 

[    0.030000] 
[    0.030000]  [<ffffffff810d88d4>] ? arch_scale_cpu_capacity+0x15/0x1e
 [<ffffffff810d88d4>] ? arch_scale_cpu_capacity+0x15/0x1e
[    0.030000]  [<ffffffff810d8986>] update_entity_load_avg+0xa9/0x5e2
[    0.030000]  [<ffffffff810d8986>] update_entity_load_avg+0xa9/0x5e2
[    0.030000]  [<ffffffff810cd13f>] ? scheduler_tick+0x51/0xe4
[    0.030000]  [<ffffffff810cd13f>] ? scheduler_tick+0x51/0xe4
[    0.030000]  [<ffffffff810d8f1e>] task_tick_fair+0x5f/0x156
[    0.030000]  [<ffffffff810d8f1e>] task_tick_fair+0x5f/0x156
[    0.030000]  [<ffffffff810cd167>] scheduler_tick+0x79/0xe4
[    0.030000]  [<ffffffff810cd167>] scheduler_tick+0x79/0xe4
[    0.030000]  [<ffffffff8111c3d2>] update_process_times+0x88/0xa6
[    0.030000]  [<ffffffff8111c3d2>] update_process_times+0x88/0xa6
[    0.030000]  [<ffffffff8112d559>] ? tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff8112d559>] ? tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff8112d2a2>] tick_periodic+0x141/0x14a
[    0.030000]  [<ffffffff8112d2a2>] tick_periodic+0x141/0x14a
[    0.030000]  [<ffffffff8112d559>] tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff8112d559>] tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff81007e46>] timer_interrupt+0x1c/0x2a
[    0.030000]  [<ffffffff81007e46>] timer_interrupt+0x1c/0x2a
[    0.030000]  [<ffffffff81101e2b>] handle_irq_event_percpu+0xfe/0x592
[    0.030000]  [<ffffffff81101e2b>] handle_irq_event_percpu+0xfe/0x592
[    0.030000]  [<ffffffff8110230e>] handle_irq_event+0x4f/0x7d
[    0.030000]  [<ffffffff8110230e>] handle_irq_event+0x4f/0x7d
[    0.030000]  [<ffffffff8130010a>] ? __this_cpu_preempt_check+0x1a/0x23
[    0.030000]  [<ffffffff8130010a>] ? __this_cpu_preempt_check+0x1a/0x23
[    0.030000]  [<ffffffff81107190>] handle_level_irq+0xce/0x139
[    0.030000]  [<ffffffff81107190>] handle_level_irq+0xce/0x139
[    0.030000]  [<ffffffff81007330>] handle_irq+0x6d/0x85
[    0.030000]  [<ffffffff81007330>] handle_irq+0x6d/0x85
[    0.030000]  [<ffffffff8156f1d6>] do_IRQ+0x76/0x141
[    0.030000]  [<ffffffff8156f1d6>] do_IRQ+0x76/0x141
[    0.030000]  [<ffffffff8156dcaf>] common_interrupt+0x6f/0x6f
[    0.030000]  [<ffffffff8156dcaf>] common_interrupt+0x6f/0x6f
[    0.030000]  <EOI> 
[    0.030000]  <EOI> 

[    0.030000] 
[    0.030000]  [<ffffffff8104c846>] ? native_restore_fl+0xd/0x16
 [<ffffffff8104c846>] ? native_restore_fl+0xd/0x16
[    0.030000]  [<ffffffff810f4228>] arch_local_irq_restore+0x12/0x1b
[    0.030000]  [<ffffffff810f4228>] arch_local_irq_restore+0x12/0x1b
[    0.030000]  [<ffffffff8156bc13>] _raw_spin_unlock_irqrestore+0x8c/0x10f
[    0.030000]  [<ffffffff8156bc13>] _raw_spin_unlock_irqrestore+0x8c/0x10f
[    0.030000]  [<ffffffff8121adc2>] slob_free+0x410/0x426
[    0.030000]  [<ffffffff8121adc2>] slob_free+0x410/0x426
[    0.030000]  [<ffffffff8121adfa>] __kmem_cache_free+0x22/0x56
[    0.030000]  [<ffffffff8121adfa>] __kmem_cache_free+0x22/0x56
[    0.030000]  [<ffffffff8121aeac>] kmem_cache_free+0x7e/0x20f
[    0.030000]  [<ffffffff8121aeac>] kmem_cache_free+0x7e/0x20f
[    0.030000]  [<ffffffff8133692e>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff8133692e>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81374964>] acpi_ut_delete_generic_state+0x2b/0x34
[    0.030000]  [<ffffffff81374964>] acpi_ut_delete_generic_state+0x2b/0x34
[    0.030000]  [<ffffffff8134dec1>] acpi_ds_scope_stack_clear+0x37/0x44
[    0.030000]  [<ffffffff8134dec1>] acpi_ds_scope_stack_clear+0x37/0x44
[    0.030000]  [<ffffffff81369666>] acpi_ps_parse_aml+0x1e1/0x402
[    0.030000]  [<ffffffff81369666>] acpi_ps_parse_aml+0x1e1/0x402
[    0.030000]  [<ffffffff81349703>] acpi_ds_auto_serialize_method+0xd9/0x10b
[    0.030000]  [<ffffffff81349703>] acpi_ds_auto_serialize_method+0xd9/0x10b
[    0.030000]  [<ffffffff813494a5>] acpi_ds_init_one_object+0x110/0x144
[    0.030000]  [<ffffffff813494a5>] acpi_ds_init_one_object+0x110/0x144
[    0.030000]  [<ffffffff813658a4>] acpi_ns_walk_namespace+0x11a/0x247
[    0.030000]  [<ffffffff813658a4>] acpi_ns_walk_namespace+0x11a/0x247
[    0.030000]  [<ffffffff81349395>] ? acpi_ds_create_index_field+0x12a/0x12a
[    0.030000]  [<ffffffff81349395>] ? acpi_ds_create_index_field+0x12a/0x12a
[    0.030000]  [<ffffffff81349571>] acpi_ds_initialize_objects+0x98/0x10e
[    0.030000]  [<ffffffff81349571>] acpi_ds_initialize_objects+0x98/0x10e
[    0.030000]  [<ffffffff8156bc6c>] ? _raw_spin_unlock_irqrestore+0xe5/0x10f
[    0.030000]  [<ffffffff8156bc6c>] ? _raw_spin_unlock_irqrestore+0xe5/0x10f
[    0.030000]  [<ffffffff81361f99>] acpi_ns_load_table+0xe4/0xf3
[    0.030000]  [<ffffffff81361f99>] acpi_ns_load_table+0xe4/0xf3
[    0.030000]  [<ffffffff81f80965>] acpi_load_tables+0xea/0x225
[    0.030000]  [<ffffffff81f80965>] acpi_load_tables+0xea/0x225
[    0.030000]  [<ffffffff81f7f249>] acpi_early_init+0xd8/0x1ac
[    0.030000]  [<ffffffff81f7f249>] acpi_early_init+0xd8/0x1ac
[    0.030000]  [<ffffffff81f42602>] start_kernel+0x6d5/0x787
[    0.030000]  [<ffffffff81f42602>] start_kernel+0x6d5/0x787
[    0.030000]  [<ffffffff81f41120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff81f41120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff81f41587>] x86_64_start_reservations+0x46/0x4f
[    0.030000]  [<ffffffff81f41587>] x86_64_start_reservations+0x46/0x4f
[    0.030000]  [<ffffffff81f4175a>] x86_64_start_kernel+0x1ca/0x1e0
[    0.030000]  [<ffffffff81f4175a>] x86_64_start_kernel+0x1ca/0x1e0
[    0.030000] Code: 
[    0.030000] Code: c3 c3 55 55 be be 08 08 00 00 00 00 00 00 48 48 ff ff 05 05 ab ab 04 04 fe fe 00 00 48 48 89 89 e5 e5 e8 e8 67 67 fd fd 21 21 00 00 48 48 ff ff 05 05 a4 a4 04 04 fe fe 00 00 5d 5d c3 c3 e8 e8 55 55 87 87 49 49 00 00 48 48 ff ff 05 05 7e 7e 39 39 fe fe 00 00 <f6> <f6> 47 47 50 50 80 80 55 55 48 48 89 89 e5 e5 75 75 07 07 b8 b8 00 00 04 04 00 00 00 00 eb eb 22 22 8b 8b 8f 8f 90 90 00 00 

[    0.030000] RIP 
[    0.030000] RIP  [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
 [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
[    0.030000]  RSP <ffff880012603d10>
[    0.030000]  RSP <ffff880012603d10>
[    0.030000] CR2: 0000000000000050
[    0.030000] CR2: 0000000000000050
[    0.030000] ---[ end trace 8aa5f3406d78ad18 ]---
[    0.030000] ---[ end trace 8aa5f3406d78ad18 ]---

git bisect start 41ae5f4aaef4889974485552fd2c9e0e8d86fc2f b2776bf7149bddd1f4161f14f79520f17fc1d71d --
git bisect good e1945e18b82b6923b0e3ce492ae35fd4587d45eb  # 13:10     20+      0  Merge 'vfs/iov_iter-net-2' into devel-lkp-ib04-smoke-201412101243
git bisect  bad 524d698e93870a340afaf5b647d4cce84fb6f880  # 13:12      0-     20  Merge 'clk/eas-next' into devel-lkp-ib04-smoke-201412101243
git bisect good c1a1272dcf10f1bea314226c76245604fbf91c87  # 13:17     20+     20  sched: updated comments of CLONE_NEWUTS and CLONE_NEWIPC
git bisect good 7c2684baf9042237fa3f72c9f230637911fe9b53  # 13:21     20+     20  sched: energy_model: simple cpu frequency scaling policy
git bisect good 123c1de3f5f485b44b1b84c50b40cbafe1e379d6  # 13:25     20+      0  sched: add ftrace for io latency tracking
git bisect  bad 318e8cc222050c8c542c7471224fe3ba1ac18062  # 13:29     12-     20  arm: Frequency invariant scheduler load-tracking support
git bisect good b9ed965defe8f8ee2e57e0a9372c70b883a4ea3f  # 13:34     35+     35  Merge remote-tracking branch 'eas-next/eas-next' into sched/cpuidle/eas-next
git bisect  bad 1fadb581b0be9420b143e43ff2f4a07ea7e45f6c  # 13:38      4-     35  sched: Make usage and load tracking cpu scale-invariant
git bisect good e754569101f392e1924d8ce6f087ea4cfad91d69  # 13:45     35+     35  sched: Make load tracking frequency scale-invariant
# first bad commit: [1fadb581b0be9420b143e43ff2f4a07ea7e45f6c] sched: Make usage and load tracking cpu scale-invariant
git bisect good e754569101f392e1924d8ce6f087ea4cfad91d69  # 13:49    105+    140  sched: Make load tracking frequency scale-invariant
# extra tests on HEAD of linux-devel/devel-lkp-ib04-smoke-201412101243
git bisect  bad 41ae5f4aaef4889974485552fd2c9e0e8d86fc2f  # 13:49      0-     16  0day head guard for 'devel-lkp-ib04-smoke-201412101243'
# extra tests on tree/branch clk/eas-next
git bisect  bad 67cc03886394320689d30d65d65b386756d47e39  # 13:58     26-     96  sched: Include blocked load in weighted_cpuload
# extra tests on tree/branch linus/master
git bisect good 86c6a2fddf0b89b494c7616f2c06cf915c4bff01  # 14:22    105+      0  Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# extra tests on tree/branch next/master
git bisect good 5348e33950aad8d5ab06d83cb7ac4e6b4198f773  # 14:27    105+      0  Add linux-next specific files for 20141209


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
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

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-client8-1:20141210133740:x86_64-randconfig-ib0-12101221:3.18.0-rc2-00089-g1fadb58:3"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-00089-g1fadb58 (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #3 SMP PREEMPT Wed Dec 10 13:36:50 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:1fadb581b0b=
e9420b143e43ff2f4a07ea7e45f6c:bisect-linux-6/.vmlinuz-1fadb581b0be9420b143e=
43ff2f4a07ea7e45f6c-20141210133710-32-client8 branch=3Dlinux-devel/devel-lk=
p-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-121012=
21/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-00089-g1fadb=
58 drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fdc000, 0x02fdcfff] PGTABLE
[    0.000000] BRK [0x02fdd000, 0x02fddfff] PGTABLE
[    0.000000] BRK [0x02fde000, 0x02fdefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x02fdf000, 0x02fdffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13fdc000-0x13fdffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdb001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81790 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880012600000 s80072 r8192=
 d30520 u1048576
[    0.000000] pcpu-alloc: s80072 r8192 d30520 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260ccc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:1fad=
b581b0be9420b143e43ff2f4a07ea7e45f6c:bisect-linux-6/.vmlinuz-1fadb581b0be94=
20b143e43ff2f4a07ea7e45f6c-20141210133710-32-client8 branch=3Dlinux-devel/d=
evel-lkp-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0=
-12101221/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-00089=
-g1fadb58 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 264716K/327160K available (5567K kernel code, 3246K =
rwdata, 4268K rodata, 964K init, 16108K bss, 62444K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-00089-g1fadb58 (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #3 SMP PREEMPT Wed Dec 10 13:36:50 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:1fadb581b0b=
e9420b143e43ff2f4a07ea7e45f6c:bisect-linux-6/.vmlinuz-1fadb581b0be9420b143e=
43ff2f4a07ea7e45f6c-20141210133710-32-client8 branch=3Dlinux-devel/devel-lk=
p-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-121012=
21/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-00089-g1fadb=
58 drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fdc000, 0x02fdcfff] PGTABLE
[    0.000000] BRK [0x02fdd000, 0x02fddfff] PGTABLE
[    0.000000] BRK [0x02fde000, 0x02fdefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x02fdf000, 0x02fdffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13fdc000-0x13fdffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdb001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81790 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880012600000 s80072 r8192=
 d30520 u1048576
[    0.000000] pcpu-alloc: s80072 r8192 d30520 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260ccc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:1fad=
b581b0be9420b143e43ff2f4a07ea7e45f6c:bisect-linux-6/.vmlinuz-1fadb581b0be94=
20b143e43ff2f4a07ea7e45f6c-20141210133710-32-client8 branch=3Dlinux-devel/d=
evel-lkp-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0=
-12101221/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-00089=
-g1fadb58 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 264716K/327160K available (5567K kernel code, 3246K =
rwdata, 4268K rodata, 964K init, 16108K bss, 62444K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.000000] tsc: Detected 2925.998 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5851.99 Bogo=
MIPS (lpj=3D29259980)
5851.99 BogoMIPS (lpj=3D29259980)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI: Core revision 20140926
[    0.020018] BUG: unable to handle kernel=20
[    0.020018] BUG: unable to handle kernel NULL pointer dereferenceNULL po=
inter dereference at 0000000000000050
 at 0000000000000050
[    0.021436] IP:
[    0.021436] IP: [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
 [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
[    0.022741] PGD 0=20
[    0.022741] PGD 0=20

[    0.023123] Oops: 0000 [#1]=20
[    0.023123] Oops: 0000 [#1] PREEMPT PREEMPT SMP SMP=20

[    0.023853] Modules linked in:
[    0.023853] Modules linked in:

[    0.024476] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-00089-g=
1fadb58 #3
[    0.024476] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-00089-g=
1fadb58 #3
[    0.026198] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.026198] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.027982] task: ffffffff81c0f500 ti: ffffffff81c00000 task.ti: fffffff=
f81c00000
[    0.027982] task: ffffffff81c0f500 ti: ffffffff81c00000 task.ti: fffffff=
f81c00000
[    0.029308] RIP: 0010:[<ffffffff810d68a2>]=20
[    0.029308] RIP: 0010:[<ffffffff810d68a2>]  [<ffffffff810d68a2>] default=
_scale_cpu_capacity+0xc/0x41
 [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
[    0.030000] RSP: 0000:ffff880012603d10  EFLAGS: 00010002
[    0.030000] RSP: 0000:ffff880012603d10  EFLAGS: 00010002
[    0.030000] RAX: 0000000000000400 RBX: 0000000000000400 RCX: 00000000000=
00000
[    0.030000] RAX: 0000000000000400 RBX: 0000000000000400 RCX: 00000000000=
00000
[    0.030000] RDX: 0000000000004c4c RSI: 0000000000000000 RDI: 00000000000=
00000
[    0.030000] RDX: 0000000000004c4c RSI: 0000000000000000 RDI: 00000000000=
00000
[    0.030000] RBP: ffff880012603d18 R08: 0000000000000001 R09: 00000000000=
00017
[    0.030000] RBP: ffff880012603d18 R08: 0000000000000001 R09: 00000000000=
00017
[    0.030000] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[    0.030000] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[    0.030000] R13: ffffffff81c0f568 R14: ffffffff81c03b98 R15: 00000000000=
00000
[    0.030000] R13: ffffffff81c0f568 R14: ffffffff81c03b98 R15: 00000000000=
00000
[    0.030000] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:=
0000000000000000
[    0.030000] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:=
0000000000000000
[    0.030000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.030000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.030000] CR2: 0000000000000050 CR3: 0000000001c08000 CR4: 00000000000=
006b0
[    0.030000] CR2: 0000000000000050 CR3: 0000000001c08000 CR4: 00000000000=
006b0
[    0.030000] Stack:
[    0.030000] Stack:
[    0.030000]  ffffffff810d88d4
[    0.030000]  ffffffff810d88d4 ffff880012603d88 ffff880012603d88 ffffffff=
810d8986 ffffffff810d8986 ffffffff810cd13f ffffffff810cd13f

[    0.030000]  0000000000000000
[    0.030000]  0000000000000000 ffff880000000001 ffff880000000001 00ffffff=
00000000 00ffffff00000000 0000000000004c4c 0000000000004c4c

[    0.030000]  ffff880012612d70
[    0.030000]  ffff880012612d70 ffff880012603d88 ffff880012603d88 ffff8800=
12612d70 ffff880012612d70 ffffffff81c0f500 ffffffff81c0f500

[    0.030000] Call Trace:
[    0.030000] Call Trace:
[    0.030000]  <IRQ>=20
[    0.030000]  <IRQ>=20

[    0.030000]=20
[    0.030000]  [<ffffffff810d88d4>] ? arch_scale_cpu_capacity+0x15/0x1e
 [<ffffffff810d88d4>] ? arch_scale_cpu_capacity+0x15/0x1e
[    0.030000]  [<ffffffff810d8986>] update_entity_load_avg+0xa9/0x5e2
[    0.030000]  [<ffffffff810d8986>] update_entity_load_avg+0xa9/0x5e2
[    0.030000]  [<ffffffff810cd13f>] ? scheduler_tick+0x51/0xe4
[    0.030000]  [<ffffffff810cd13f>] ? scheduler_tick+0x51/0xe4
[    0.030000]  [<ffffffff810d8f1e>] task_tick_fair+0x5f/0x156
[    0.030000]  [<ffffffff810d8f1e>] task_tick_fair+0x5f/0x156
[    0.030000]  [<ffffffff810cd167>] scheduler_tick+0x79/0xe4
[    0.030000]  [<ffffffff810cd167>] scheduler_tick+0x79/0xe4
[    0.030000]  [<ffffffff8111c3d2>] update_process_times+0x88/0xa6
[    0.030000]  [<ffffffff8111c3d2>] update_process_times+0x88/0xa6
[    0.030000]  [<ffffffff8112d559>] ? tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff8112d559>] ? tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff8112d2a2>] tick_periodic+0x141/0x14a
[    0.030000]  [<ffffffff8112d2a2>] tick_periodic+0x141/0x14a
[    0.030000]  [<ffffffff8112d559>] tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff8112d559>] tick_handle_periodic+0x34/0xa2
[    0.030000]  [<ffffffff81007e46>] timer_interrupt+0x1c/0x2a
[    0.030000]  [<ffffffff81007e46>] timer_interrupt+0x1c/0x2a
[    0.030000]  [<ffffffff81101e2b>] handle_irq_event_percpu+0xfe/0x592
[    0.030000]  [<ffffffff81101e2b>] handle_irq_event_percpu+0xfe/0x592
[    0.030000]  [<ffffffff8110230e>] handle_irq_event+0x4f/0x7d
[    0.030000]  [<ffffffff8110230e>] handle_irq_event+0x4f/0x7d
[    0.030000]  [<ffffffff8130010a>] ? __this_cpu_preempt_check+0x1a/0x23
[    0.030000]  [<ffffffff8130010a>] ? __this_cpu_preempt_check+0x1a/0x23
[    0.030000]  [<ffffffff81107190>] handle_level_irq+0xce/0x139
[    0.030000]  [<ffffffff81107190>] handle_level_irq+0xce/0x139
[    0.030000]  [<ffffffff81007330>] handle_irq+0x6d/0x85
[    0.030000]  [<ffffffff81007330>] handle_irq+0x6d/0x85
[    0.030000]  [<ffffffff8156f1d6>] do_IRQ+0x76/0x141
[    0.030000]  [<ffffffff8156f1d6>] do_IRQ+0x76/0x141
[    0.030000]  [<ffffffff8156dcaf>] common_interrupt+0x6f/0x6f
[    0.030000]  [<ffffffff8156dcaf>] common_interrupt+0x6f/0x6f
[    0.030000]  <EOI>=20
[    0.030000]  <EOI>=20

[    0.030000]=20
[    0.030000]  [<ffffffff8104c846>] ? native_restore_fl+0xd/0x16
 [<ffffffff8104c846>] ? native_restore_fl+0xd/0x16
[    0.030000]  [<ffffffff810f4228>] arch_local_irq_restore+0x12/0x1b
[    0.030000]  [<ffffffff810f4228>] arch_local_irq_restore+0x12/0x1b
[    0.030000]  [<ffffffff8156bc13>] _raw_spin_unlock_irqrestore+0x8c/0x10f
[    0.030000]  [<ffffffff8156bc13>] _raw_spin_unlock_irqrestore+0x8c/0x10f
[    0.030000]  [<ffffffff8121adc2>] slob_free+0x410/0x426
[    0.030000]  [<ffffffff8121adc2>] slob_free+0x410/0x426
[    0.030000]  [<ffffffff8121adfa>] __kmem_cache_free+0x22/0x56
[    0.030000]  [<ffffffff8121adfa>] __kmem_cache_free+0x22/0x56
[    0.030000]  [<ffffffff8121aeac>] kmem_cache_free+0x7e/0x20f
[    0.030000]  [<ffffffff8121aeac>] kmem_cache_free+0x7e/0x20f
[    0.030000]  [<ffffffff8133692e>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff8133692e>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81374964>] acpi_ut_delete_generic_state+0x2b/0x34
[    0.030000]  [<ffffffff81374964>] acpi_ut_delete_generic_state+0x2b/0x34
[    0.030000]  [<ffffffff8134dec1>] acpi_ds_scope_stack_clear+0x37/0x44
[    0.030000]  [<ffffffff8134dec1>] acpi_ds_scope_stack_clear+0x37/0x44
[    0.030000]  [<ffffffff81369666>] acpi_ps_parse_aml+0x1e1/0x402
[    0.030000]  [<ffffffff81369666>] acpi_ps_parse_aml+0x1e1/0x402
[    0.030000]  [<ffffffff81349703>] acpi_ds_auto_serialize_method+0xd9/0x1=
0b
[    0.030000]  [<ffffffff81349703>] acpi_ds_auto_serialize_method+0xd9/0x1=
0b
[    0.030000]  [<ffffffff813494a5>] acpi_ds_init_one_object+0x110/0x144
[    0.030000]  [<ffffffff813494a5>] acpi_ds_init_one_object+0x110/0x144
[    0.030000]  [<ffffffff813658a4>] acpi_ns_walk_namespace+0x11a/0x247
[    0.030000]  [<ffffffff813658a4>] acpi_ns_walk_namespace+0x11a/0x247
[    0.030000]  [<ffffffff81349395>] ? acpi_ds_create_index_field+0x12a/0x1=
2a
[    0.030000]  [<ffffffff81349395>] ? acpi_ds_create_index_field+0x12a/0x1=
2a
[    0.030000]  [<ffffffff81349571>] acpi_ds_initialize_objects+0x98/0x10e
[    0.030000]  [<ffffffff81349571>] acpi_ds_initialize_objects+0x98/0x10e
[    0.030000]  [<ffffffff8156bc6c>] ? _raw_spin_unlock_irqrestore+0xe5/0x1=
0f
[    0.030000]  [<ffffffff8156bc6c>] ? _raw_spin_unlock_irqrestore+0xe5/0x1=
0f
[    0.030000]  [<ffffffff81361f99>] acpi_ns_load_table+0xe4/0xf3
[    0.030000]  [<ffffffff81361f99>] acpi_ns_load_table+0xe4/0xf3
[    0.030000]  [<ffffffff81f80965>] acpi_load_tables+0xea/0x225
[    0.030000]  [<ffffffff81f80965>] acpi_load_tables+0xea/0x225
[    0.030000]  [<ffffffff81f7f249>] acpi_early_init+0xd8/0x1ac
[    0.030000]  [<ffffffff81f7f249>] acpi_early_init+0xd8/0x1ac
[    0.030000]  [<ffffffff81f42602>] start_kernel+0x6d5/0x787
[    0.030000]  [<ffffffff81f42602>] start_kernel+0x6d5/0x787
[    0.030000]  [<ffffffff81f41120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff81f41120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff81f41587>] x86_64_start_reservations+0x46/0x4f
[    0.030000]  [<ffffffff81f41587>] x86_64_start_reservations+0x46/0x4f
[    0.030000]  [<ffffffff81f4175a>] x86_64_start_kernel+0x1ca/0x1e0
[    0.030000]  [<ffffffff81f4175a>] x86_64_start_kernel+0x1ca/0x1e0
[    0.030000] Code:=20
[    0.030000] Code: c3 c3 55 55 be be 08 08 00 00 00 00 00 00 48 48 ff ff =
05 05 ab ab 04 04 fe fe 00 00 48 48 89 89 e5 e5 e8 e8 67 67 fd fd 21 21 00 =
00 48 48 ff ff 05 05 a4 a4 04 04 fe fe 00 00 5d 5d c3 c3 e8 e8 55 55 87 87 =
49 49 00 00 48 48 ff ff 05 05 7e 7e 39 39 fe fe 00 00 <f6> <f6> 47 47 50 50=
 80 80 55 55 48 48 89 89 e5 e5 75 75 07 07 b8 b8 00 00 04 04 00 00 00 00 eb=
 eb 22 22 8b 8b 8f 8f 90 90 00 00=20

[    0.030000] RIP=20
[    0.030000] RIP  [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
 [<ffffffff810d68a2>] default_scale_cpu_capacity+0xc/0x41
[    0.030000]  RSP <ffff880012603d10>
[    0.030000]  RSP <ffff880012603d10>
[    0.030000] CR2: 0000000000000050
[    0.030000] CR2: 0000000000000050
[    0.030000] ---[ end trace 8aa5f3406d78ad18 ]---
[    0.030000] ---[ end trace 8aa5f3406d78ad18 ]---
[    0.030000] Kernel panic - not syncing: Fatal exception in interrupt
[    0.030000] Kernel panic - not syncing: Fatal exception in interrupt

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-ib0-12101221/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-0=
0089-g1fadb58 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-i=
b0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:1fadb581b0be9420b=
143e43ff2f4a07ea7e45f6c:bisect-linux-6/.vmlinuz-1fadb581b0be9420b143e43ff2f=
4a07ea7e45f6c-20141210133710-32-client8 branch=3Dlinux-devel/devel-lkp-ib04=
-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-12101221/1fa=
db581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-00089-g1fadb58 drb=
d.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m=
 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-quantal-client8-1 -serial file:/dev/shm/kboot/serial-quantal-cli=
ent8-1 -daemonize -display none -monitor null=20

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-client9-12:20141210134436:x86_64-randconfig-ib0-12101221:3.18.0-rc2-00088-ge754569:4"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-00088-ge754569 (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #4 SMP PREEMPT Wed Dec 10 13:42:40 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:e754569101f=
392e1924d8ce6f087ea4cfad91d69:bisect-linux-6/.vmlinuz-e754569101f392e1924d8=
ce6f087ea4cfad91d69-20141210134300-12-client9 branch=3Dlinux-devel/devel-lk=
p-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-121012=
21/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-00088-ge7545=
69 drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fdc000, 0x02fdcfff] PGTABLE
[    0.000000] BRK [0x02fdd000, 0x02fddfff] PGTABLE
[    0.000000] BRK [0x02fde000, 0x02fdefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x02fdf000, 0x02fdffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13fdc000-0x13fdffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdb001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81790 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880012600000 s80072 r8192=
 d30520 u1048576
[    0.000000] pcpu-alloc: s80072 r8192 d30520 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260ccc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:e754=
569101f392e1924d8ce6f087ea4cfad91d69:bisect-linux-6/.vmlinuz-e754569101f392=
e1924d8ce6f087ea4cfad91d69-20141210134300-12-client9 branch=3Dlinux-devel/d=
evel-lkp-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0=
-12101221/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-00088=
-ge754569 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 264716K/327160K available (5567K kernel code, 3246K =
rwdata, 4268K rodata, 964K init, 16108K bss, 62444K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-00088-ge754569 (kbuild@lkp-ib04) (g=
cc version 4.9.1 (Debian 4.9.1-19) ) #4 SMP PREEMPT Wed Dec 10 13:42:40 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:e754569101f=
392e1924d8ce6f087ea4cfad91d69:bisect-linux-6/.vmlinuz-e754569101f392e1924d8=
ce6f087ea4cfad91d69-20141210134300-12-client9 branch=3Dlinux-devel/devel-lk=
p-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-121012=
21/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-00088-ge7545=
69 drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fdc000, 0x02fdcfff] PGTABLE
[    0.000000] BRK [0x02fdd000, 0x02fddfff] PGTABLE
[    0.000000] BRK [0x02fde000, 0x02fdefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x02fdf000, 0x02fdffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13fdc000-0x13fdffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdb001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA32 zone: 1120 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81790 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880012600000 s80072 r8192=
 d30520 u1048576
[    0.000000] pcpu-alloc: s80072 r8192 d30520 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260ccc0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ib0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:e754=
569101f392e1924d8ce6f087ea4cfad91d69:bisect-linux-6/.vmlinuz-e754569101f392=
e1924d8ce6f087ea4cfad91d69-20141210134300-12-client9 branch=3Dlinux-devel/d=
evel-lkp-ib04-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0=
-12101221/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-00088=
-ge754569 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 264716K/327160K available (5567K kernel code, 3246K =
rwdata, 4268K rodata, 964K init, 16108K bss, 62444K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2925.996 MHz processor
[    0.000000] tsc: Detected 2925.996 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5851.99 Bogo=
MIPS (lpj=3D29259960)
5851.99 BogoMIPS (lpj=3D29259960)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020000] ACPI: Core revision 20140926
[    0.024921] ACPI:=20
[    0.024921] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.026105] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.026105] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.027585] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.027585] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.028831] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.028831] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.030031] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.030031] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.032949] Initializing cgroup subsys devices
[    0.032949] Initializing cgroup subsys devices
[    0.033819] Initializing cgroup subsys perf_event
[    0.033819] Initializing cgroup subsys perf_event
[    0.034704] numa_add_cpu cpu 0 node 0: mask now 0
[    0.034704] numa_add_cpu cpu 0 node 0: mask now 0
[    0.035520] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035520] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.035520] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035520] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.037730] Freeing SMP alternatives memory: 8K (ffffffff8201e000 - ffff=
ffff82020000)
[    0.037730] Freeing SMP alternatives memory: 8K (ffffffff8201e000 - ffff=
ffff82020000)
[    0.040626]=20
[    0.040626]=20
[    0.040899] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.040899] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.042121] [ INFO: suspicious RCU usage. ]
[    0.042121] [ INFO: suspicious RCU usage. ]
[    0.043076] 3.18.0-rc2-00088-ge754569 #4 Not tainted
[    0.043076] 3.18.0-rc2-00088-ge754569 #4 Not tainted
[    0.043950] -------------------------------
[    0.043950] -------------------------------
[    0.044667] kernel/sched/core.c:7569 suspicious rcu_dereference_check() =
usage!
[    0.044667] kernel/sched/core.c:7569 suspicious rcu_dereference_check() =
usage!
[    0.046142]=20
[    0.046142] other info that might help us debug this:
[    0.046142]=20
[    0.046142]=20
[    0.046142] other info that might help us debug this:
[    0.046142]=20
[    0.047492]=20
[    0.047492] rcu_scheduler_active =3D 1, debug_locks =3D 1
[    0.047492]=20
[    0.047492] rcu_scheduler_active =3D 1, debug_locks =3D 1
[    0.048601] 2 locks held by swapper/0/0:
[    0.048601] 2 locks held by swapper/0/0:
[    0.049271]  #0:=20
[    0.049271]  #0:  ( (&p->pi_lock&p->pi_lock){......}){......}, at: , at:=
 [<ffffffff810c5730>] task_rq_lock+0x44/0x144
[<ffffffff810c5730>] task_rq_lock+0x44/0x144
[    0.050000]  #1:=20
[    0.050000]  #1:  ( (&rq->lock&rq->lock){-.....}){-.....}, at: , at: [<f=
fffffff810c5752>] task_rq_lock+0x66/0x144
[<ffffffff810c5752>] task_rq_lock+0x66/0x144
[    0.050000]=20
[    0.050000] stack backtrace:
[    0.050000]=20
[    0.050000] stack backtrace:
[    0.050000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-00088-g=
e754569 #4
[    0.050000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-00088-g=
e754569 #4
[    0.050000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.050000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.050000]  0000000000000001
[    0.050000]  0000000000000001 ffffffff81c03d08 ffffffff81c03d08 ffffffff=
815610d2 ffffffff815610d2 ffffffff81c0f500 ffffffff81c0f500

[    0.050000]  0000000000000001
[    0.050000]  0000000000000001 ffffffff81c03d38 ffffffff81c03d38 ffffffff=
810ec934 ffffffff810ec934 ffff88000018a000 ffff88000018a000

[    0.050000]  ffff880012612cc0
[    0.050000]  ffff880012612cc0 0000000000000000 0000000000000000 00000000=
00000000 0000000000000000 ffffffff81c03d98 ffffffff81c03d98

[    0.050000] Call Trace:
[    0.050000] Call Trace:
[    0.050000]  [<ffffffff815610d2>] dump_stack+0xb2/0x14a
[    0.050000]  [<ffffffff815610d2>] dump_stack+0xb2/0x14a
[    0.050000]  [<ffffffff810ec934>] lockdep_rcu_suspicious+0x176/0x186
[    0.050000]  [<ffffffff810ec934>] lockdep_rcu_suspicious+0x176/0x186
[    0.050000]  [<ffffffff810d1da4>] sched_move_task+0x184/0x233
[    0.050000]  [<ffffffff810d1da4>] sched_move_task+0x184/0x233
[    0.050000]  [<ffffffff810d1eea>] cpu_cgroup_fork+0x15/0x1e
[    0.050000]  [<ffffffff810d1eea>] cpu_cgroup_fork+0x15/0x1e
[    0.050000]  [<ffffffff81150252>] cgroup_post_fork+0xea/0x109
[    0.050000]  [<ffffffff81150252>] cgroup_post_fork+0xea/0x109
[    0.050000]  [<ffffffff8108cd97>] copy_process+0x1985/0x1c91
[    0.050000]  [<ffffffff8108cd97>] copy_process+0x1985/0x1c91
[    0.050000]  [<ffffffff815586e4>] ? rest_init+0x228/0x228
[    0.050000]  [<ffffffff815586e4>] ? rest_init+0x228/0x228
[    0.050000]  [<ffffffff8108d28d>] do_fork+0xd9/0x5dc
[    0.050000]  [<ffffffff8108d28d>] do_fork+0xd9/0x5dc
[    0.050000]  [<ffffffff815586e4>] ? rest_init+0x228/0x228
[    0.050000]  [<ffffffff815586e4>] ? rest_init+0x228/0x228
[    0.050000]  [<ffffffff810c4c27>] ? cpumask_check+0xde/0xf1
[    0.050000]  [<ffffffff810c4c27>] ? cpumask_check+0xde/0xf1
[    0.050000]  [<ffffffff810c51ef>] ? cpumask_next+0x3e/0x4a
[    0.050000]  [<ffffffff810c51ef>] ? cpumask_next+0x3e/0x4a
[    0.050000]  [<ffffffff8108d7bd>] kernel_thread+0x2d/0x36
[    0.050000]  [<ffffffff8108d7bd>] kernel_thread+0x2d/0x36
[    0.050000]  [<ffffffff815584ed>] rest_init+0x31/0x228
[    0.050000]  [<ffffffff815584ed>] rest_init+0x31/0x228
[    0.050000]  [<ffffffff81f426a0>] start_kernel+0x773/0x787
[    0.050000]  [<ffffffff81f426a0>] start_kernel+0x773/0x787
[    0.050000]  [<ffffffff81f41120>] ? early_idt_handlers+0x120/0x120
[    0.050000]  [<ffffffff81f41120>] ? early_idt_handlers+0x120/0x120
[    0.050000]  [<ffffffff81f41587>] x86_64_start_reservations+0x46/0x4f
[    0.050000]  [<ffffffff81f41587>] x86_64_start_reservations+0x46/0x4f
[    0.050000]  [<ffffffff81f4175a>] x86_64_start_kernel+0x1ca/0x1e0
[    0.050000]  [<ffffffff81f4175a>] x86_64_start_kernel+0x1ca/0x1e0
[    0.050227] Getting VERSION: 1050014
[    0.050227] Getting VERSION: 1050014
[    0.050847] Getting VERSION: 1050014
[    0.050847] Getting VERSION: 1050014
[    0.051461] Getting ID: 0
[    0.051461] Getting ID: 0
[    0.051920] Getting ID: ff000000
[    0.051920] Getting ID: ff000000
[    0.052481] Getting LVT0: 8700
[    0.052481] Getting LVT0: 8700
[    0.053012] Getting LVT1: 8400
[    0.053012] Getting LVT1: 8400
[    0.053584] enabled ExtINT on CPU#0
[    0.053584] enabled ExtINT on CPU#0
[    0.060719] ENABLING IO-APIC IRQs
[    0.060719] ENABLING IO-APIC IRQs
[    0.061341] init IO_APIC IRQs
[    0.061341] init IO_APIC IRQs
[    0.061850]  apic 0 pin 0 not connected
[    0.061850]  apic 0 pin 0 not connected
[    0.062653] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.062653] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.064041] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.064041] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.065420] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.065420] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.066771] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.066771] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.068123] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.068123] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.069481] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.069481] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.070033] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.070033] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.071401] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.071401] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.072752] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.072752] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.074133] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.074133] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.075489] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.075489] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.076888] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.076888] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.078283] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.078283] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.080033] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.080033] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.081411] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.081411] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.082797] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.082797] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.084385]  apic 0 pin 16 not connected
[    0.084385]  apic 0 pin 16 not connected
[    0.085471]  apic 0 pin 17 not connected
[    0.085471]  apic 0 pin 17 not connected
[    0.086556]  apic 0 pin 18 not connected
[    0.086556]  apic 0 pin 18 not connected
[    0.087641]  apic 0 pin 19 not connected
[    0.087641]  apic 0 pin 19 not connected
[    0.088723]  apic 0 pin 20 not connected
[    0.088723]  apic 0 pin 20 not connected
[    0.090010]  apic 0 pin 21 not connected
[    0.090010]  apic 0 pin 21 not connected
[    0.091029]  apic 0 pin 22 not connected
[    0.091029]  apic 0 pin 22 not connected
[    0.092106]  apic 0 pin 23 not connected
[    0.092106]  apic 0 pin 23 not connected
[    0.092989] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.092989] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.094290] smpboot: CPU0:=20
[    0.094290] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.096053] Using local APIC timer interrupts.
[    0.096053] calibrating APIC timer ...
[    0.096053] Using local APIC timer interrupts.
[    0.096053] calibrating APIC timer ...
[    0.100000] ... lapic delta =3D 6248064
[    0.100000] ... lapic delta =3D 6248064
[    0.100000] ... PM-Timer delta =3D 357821
[    0.100000] ... PM-Timer delta =3D 357821
[    0.100000] ... PM-Timer result ok
[    0.100000] ... PM-Timer result ok
[    0.100000] ..... delta 6248064
[    0.100000] ..... delta 6248064
[    0.100000] ..... mult: 268352305
[    0.100000] ..... mult: 268352305
[    0.100000] ..... calibration result: 9996902
[    0.100000] ..... calibration result: 9996902
[    0.100000] ..... CPU clock speed is 2924.9306 MHz.
[    0.100000] ..... CPU clock speed is 2924.9306 MHz.
[    0.100000] ..... host bus clock speed is 999.6902 MHz.
[    0.100000] ..... host bus clock speed is 999.6902 MHz.
[    0.100000] Performance Events:=20
[    0.100000] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.170043] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.170043] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.191038] x86: Booting SMP configuration:
[    0.191038] x86: Booting SMP configuration:
[    0.192008] .... node  #0, CPUs: =20
[    0.192008] .... node  #0, CPUs:         #1 #1
[    0.172665] kvm-clock: cpu 1, msr 0:13fdb041, secondary cpu clock
[    0.172665] masked ExtINT on CPU#1
[    0.172665] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.210390] x86: Booted up 1 node, 2 CPUs
[    0.210390] x86: Booted up 1 node, 2 CPUs
[    0.210306] KVM setup async PF for cpu 1
[    0.210306] KVM setup async PF for cpu 1
[    0.210306] kvm-stealtime: cpu 1, msr 1270ccc0
[    0.210306] kvm-stealtime: cpu 1, msr 1270ccc0
[    0.212523] ----------------
[    0.212523] ----------------
[    0.213008] | NMI testsuite:
[    0.213008] | NMI testsuite:
[    0.213494] --------------------
[    0.213494] --------------------
[    0.220007]   remote IPI:
[    0.220007]   remote IPI:  ok  |  ok  |

[    0.230394]    local IPI:
[    0.230394]    local IPI:  ok  |  ok  |

[    0.250117] --------------------
[    0.250117] --------------------
[    0.250666] Good, all   2 testcases passed! |
[    0.250666] Good, all   2 testcases passed! |
[    0.251366] ---------------------------------
[    0.251366] ---------------------------------
[    0.252187] smpboot: Total of 2 processors activated (11703.98 BogoMIPS)
[    0.252187] smpboot: Total of 2 processors activated (11703.98 BogoMIPS)
[    0.254019]=20
[    0.254019]=20
[    0.254019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.254019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.254019] [ INFO: suspicious RCU usage. ]
[    0.254019] [ INFO: suspicious RCU usage. ]
[    0.254019] 3.18.0-rc2-00088-ge754569 #4 Not tainted
[    0.254019] 3.18.0-rc2-00088-ge754569 #4 Not tainted
[    0.254019] -------------------------------
[    0.254019] -------------------------------
[    0.254019] include/trace/events/ipi.h:68 suspicious rcu_dereference_che=
ck() usage!
[    0.254019] include/trace/events/ipi.h:68 suspicious rcu_dereference_che=
ck() usage!
[    0.254019]=20
[    0.254019] other info that might help us debug this:
[    0.254019]=20
[    0.254019]=20
[    0.254019] other info that might help us debug this:
[    0.254019]=20
[    0.254019]=20
[    0.254019] RCU used illegally from idle CPU!
[    0.254019] rcu_scheduler_active =3D 1, debug_locks =3D 1
[    0.254019]=20
[    0.254019] RCU used illegally from idle CPU!
[    0.254019] rcu_scheduler_active =3D 1, debug_locks =3D 1
[    0.254019] RCU used illegally from extended quiescent state!
[    0.254019] RCU used illegally from extended quiescent state!
[    0.254019] no locks held by swapper/1/0.
[    0.254019] no locks held by swapper/1/0.
[    0.254019]=20
[    0.254019] stack backtrace:
[    0.254019]=20
[    0.254019] stack backtrace:
[    0.254019] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc2-00088-g=
e754569 #4
[    0.254019] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc2-00088-g=
e754569 #4
[    0.254019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.254019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.254019]  0000000000000001
[    0.254019]  0000000000000001 ffff880012703f38 ffff880012703f38 ffffffff=
815610d2 ffffffff815610d2 ffff880011426000 ffff880011426000

[    0.254019]  0000000000000001
[    0.254019]  0000000000000001 ffff880012703f68 ffff880012703f68 ffffffff=
810ec934 ffffffff810ec934 0000000000000000 0000000000000000

[    0.254019]  0000000000000000
[    0.254019]  0000000000000000 ffff88001142bfd8 ffff88001142bfd8 00000000=
00000000 0000000000000000 ffff880012703f88 ffff880012703f88

[    0.254019] Call Trace:
[    0.254019] Call Trace:
[    0.254019]  <IRQ>=20
[    0.254019]  <IRQ>  [<ffffffff815610d2>] dump_stack+0xb2/0x14a
 [<ffffffff815610d2>] dump_stack+0xb2/0x14a
[    0.254019]  [<ffffffff810ec934>] lockdep_rcu_suspicious+0x176/0x186
[    0.254019]  [<ffffffff810ec934>] lockdep_rcu_suspicious+0x176/0x186
[    0.254019]  [<ffffffff810380d9>] trace_ipi_entry+0xb0/0x17c
[    0.254019]  [<ffffffff810380d9>] trace_ipi_entry+0xb0/0x17c
[    0.254019]  [<ffffffff81038586>] __smp_reschedule_interrupt+0x17/0x47
[    0.254019]  [<ffffffff81038586>] __smp_reschedule_interrupt+0x17/0x47
[    0.254019]  [<ffffffff81038b44>] smp_reschedule_interrupt+0x21/0x2a
[    0.254019]  [<ffffffff81038b44>] smp_reschedule_interrupt+0x21/0x2a
[    0.254019]  [<ffffffff8156e45f>] reschedule_interrupt+0x6f/0x80
[    0.254019]  [<ffffffff8156e45f>] reschedule_interrupt+0x6f/0x80
[    0.254019]  <EOI>=20
[    0.254019]  <EOI>  [<ffffffff811162be>] ? rcu_eqs_enter_common+0x532/0x=
579
 [<ffffffff811162be>] ? rcu_eqs_enter_common+0x532/0x579
[    0.254019]  [<ffffffff8104c886>] ? native_safe_halt+0xd/0x16
[    0.254019]  [<ffffffff8104c886>] ? native_safe_halt+0xd/0x16
[    0.254019]  [<ffffffff810eed04>] ? trace_hardirqs_on+0x1b/0x24
[    0.254019]  [<ffffffff810eed04>] ? trace_hardirqs_on+0x1b/0x24
[    0.254019]  [<ffffffff81013a49>] default_idle+0x47/0x76
[    0.254019]  [<ffffffff81013a49>] default_idle+0x47/0x76
[    0.254019]  [<ffffffff810148d0>] arch_cpu_idle+0x16/0x1f
[    0.254019]  [<ffffffff810148d0>] arch_cpu_idle+0x16/0x1f
[    0.254019]  [<ffffffff810e57ea>] cpu_idle_loop+0x4a7/0x748
[    0.254019]  [<ffffffff810e57ea>] cpu_idle_loop+0x4a7/0x748
[    0.254019]  [<ffffffff8156bc3c>] ? _raw_spin_unlock_irqrestore+0xe5/0x1=
0f
[    0.254019]  [<ffffffff8156bc3c>] ? _raw_spin_unlock_irqrestore+0xe5/0x1=
0f
[    0.254019]  [<ffffffff8112c89d>] ? clockevents_register_device+0x1e4/0x=
1f3
[    0.254019]  [<ffffffff8112c89d>] ? clockevents_register_device+0x1e4/0x=
1f3
[    0.254019]  [<ffffffff810e5aac>] cpu_startup_entry+0x21/0x21
[    0.254019]  [<ffffffff810e5aac>] cpu_startup_entry+0x21/0x21
[    0.254019]  [<ffffffff8103a3ed>] start_secondary+0x223/0x22e
[    0.254019]  [<ffffffff8103a3ed>] start_secondary+0x223/0x22e
[    0.254019]=20
[    0.254019]=20
[    0.254019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.254019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    0.254019] [ INFO: suspicious RCU usage. ]
[    0.254019] [ INFO: suspicious RCU usage. ]
[    0.254019] 3.18.0-rc2-00088-ge754569 #4 Not tainted
[    0.254019] 3.18.0-rc2-00088-ge754569 #4 Not tainted
[    0.254019] -------------------------------
[    0.254019] -------------------------------
[    0.254019] include/trace/events/ipi.h:84 suspicious rcu_dereference_che=
ck() usage!
[    0.254019] include/trace/events/ipi.h:84 suspicious rcu_dereference_che=
ck() usage!
[    0.254019]=20
[    0.254019] other info that might help us debug this:
[    0.254019]=20
[    0.254019]=20
[    0.254019] other info that might help us debug this:
[    0.254019]=20
[    0.254019]=20
[    0.254019] RCU used illegally from idle CPU!
[    0.254019] rcu_scheduler_active =3D 1, debug_locks =3D 1
[    0.254019]=20
[    0.254019] RCU used illegally from idle CPU!
[    0.254019] rcu_scheduler_active =3D 1, debug_locks =3D 1
[    0.254019] RCU used illegally from extended quiescent state!
[    0.254019] RCU used illegally from extended quiescent state!
[    0.254019] no locks held by swapper/1/0.
[    0.254019] no locks held by swapper/1/0.
[    0.254019]=20
[    0.254019] stack backtrace:
[    0.254019]=20
[    0.254019] stack backtrace:
[    0.254019] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc2-00088-g=
e754569 #4
[    0.254019] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.18.0-rc2-00088-g=
e754569 #4
[    0.254019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.254019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.254019]  0000000000000001
[    0.254019]  0000000000000001 ffff880012703f38 ffff880012703f38 ffffffff=
815610d2 ffffffff815610d2 ffff880011426000 ffff880011426000

[    0.254019]  0000000000000001
[    0.254019]  0000000000000001 ffff880012703f68 ffff880012703f68 ffffffff=
810ec934 ffffffff810ec934 0000000000000000 0000000000000000

[    0.254019]  0000000000000000
[    0.254019]  0000000000000000 ffff88001142bfd8 ffff88001142bfd8 00000000=
00000000 0000000000000000 ffff880012703f88 ffff880012703f88

[    0.254019] Call Trace:
[    0.254019] Call Trace:
[    0.254019]  <IRQ>=20
[    0.254019]  <IRQ>  [<ffffffff815610d2>] dump_stack+0xb2/0x14a
 [<ffffffff815610d2>] dump_stack+0xb2/0x14a
[    0.254019]  [<ffffffff810ec934>] lockdep_rcu_suspicious+0x176/0x186
[    0.254019]  [<ffffffff810ec934>] lockdep_rcu_suspicious+0x176/0x186
[    0.254019]  [<ffffffff81037f5d>] trace_ipi_exit+0xb0/0x17c
[    0.254019]  [<ffffffff81037f5d>] trace_ipi_exit+0xb0/0x17c
[    0.254019]  [<ffffffff810385ad>] __smp_reschedule_interrupt+0x3e/0x47
[    0.254019]  [<ffffffff810385ad>] __smp_reschedule_interrupt+0x3e/0x47
[    0.254019]  [<ffffffff81038b44>] smp_reschedule_interrupt+0x21/0x2a
[    0.254019]  [<ffffffff81038b44>] smp_reschedule_interrupt+0x21/0x2a
[    0.254019]  [<ffffffff8156e45f>] reschedule_interrupt+0x6f/0x80
[    0.254019]  [<ffffffff8156e45f>] reschedule_interrupt+0x6f/0x80
[    0.254019]  <EOI>=20
[    0.254019]  <EOI>  [<ffffffff811162be>] ? rcu_eqs_enter_common+0x532/0x=
579
 [<ffffffff811162be>] ? rcu_eqs_enter_common+0x532/0x579
[    0.254019]  [<ffffffff8104c886>] ? native_safe_halt+0xd/0x16
[    0.254019]  [<ffffffff8104c886>] ? native_safe_halt+0xd/0x16
[    0.254019]  [<ffffffff810eed04>] ? trace_hardirqs_on+0x1b/0x24
[    0.254019]  [<ffffffff810eed04>] ? trace_hardirqs_on+0x1b/0x24
[    0.254019]  [<ffffffff81013a49>] default_idle+0x47/0x76
[    0.254019]  [<ffffffff81013a49>] default_idle+0x47/0x76
[    0.254019]  [<ffffffff810148d0>] arch_cpu_idle+0x16/0x1f
[    0.254019]  [<ffffffff810148d0>] arch_cpu_idle+0x16/0x1f
[    0.254019]  [<ffffffff810e57ea>] cpu_idle_loop+0x4a7/0x748
[    0.254019]  [<ffffffff810e57ea>] cpu_idle_loop+0x4a7/0x748
[    0.254019]  [<ffffffff8156bc3c>] ? _raw_spin_unlock_irqrestore+0xe5/0x1=
0f
[    0.254019]  [<ffffffff8156bc3c>] ? _raw_spin_unlock_irqrestore+0xe5/0x1=
0f
[    0.254019]  [<ffffffff8112c89d>] ? clockevents_register_device+0x1e4/0x=
1f3
[    0.254019]  [<ffffffff8112c89d>] ? clockevents_register_device+0x1e4/0x=
1f3
[    0.254019]  [<ffffffff810e5aac>] cpu_startup_entry+0x21/0x21
[    0.254019]  [<ffffffff810e5aac>] cpu_startup_entry+0x21/0x21
[    0.254019]  [<ffffffff8103a3ed>] start_secondary+0x223/0x22e
[    0.254019]  [<ffffffff8103a3ed>] start_secondary+0x223/0x22e
[    0.331148] devtmpfs: initialized
[    0.331148] devtmpfs: initialized
[    0.331947] gcov: version magic: 0x3430392a
[    0.331947] gcov: version magic: 0x3430392a
[    0.341504] prandom: seed boundary self test passed
[    0.341504] prandom: seed boundary self test passed
[    0.341577] prandom: 100 self tests passed
[    0.341577] prandom: 100 self tests passed
[    0.343785] regulator-dummy: no parameters
[    0.343785] regulator-dummy: no parameters
[    0.345923] NET: Registered protocol family 16
[    0.345923] NET: Registered protocol family 16
[    0.350080] cpuidle: using governor ladder
[    0.350080] cpuidle: using governor ladder
[    0.360149] cpuidle: using governor menu
[    0.360149] cpuidle: using governor menu
[    0.370115] cpuidle: using governor select
[    0.370115] cpuidle: using governor select
[    0.371353] ACPI: bus type PCI registered
[    0.371353] ACPI: bus type PCI registered
[    0.372287] PCI: Using configuration type 1 for base access
[    0.372287] PCI: Using configuration type 1 for base access
[    0.380507] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.380507] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.381192] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.381192] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.382366] ACPI: Added _OSI(Module Device)
[    0.382366] ACPI: Added _OSI(Module Device)
[    0.383071] ACPI: Added _OSI(Processor Device)
[    0.383071] ACPI: Added _OSI(Processor Device)
[    0.383862] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.383862] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.384800] ACPI: Added _OSI(Processor Aggregator Device)
[    0.384800] ACPI: Added _OSI(Processor Aggregator Device)
[    0.390249] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.390249] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.400932] ACPI: Interpreter enabled
[    0.400932] ACPI: Interpreter enabled
[    0.401584] ACPI Exception: AE_NOT_FOUND,=20
[    0.401584] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
 (20140926/hwxface-580)
[    0.403201] ACPI Exception: AE_NOT_FOUND,=20
[    0.403201] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
 (20140926/hwxface-580)
[    0.404833] ACPI: (supports S0 S3 S5)
[    0.404833] ACPI: (supports S0 S3 S5)
[    0.405428] ACPI: Using IOAPIC for interrupt routing
[    0.405428] ACPI: Using IOAPIC for interrupt routing
[    0.406329] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.406329] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.431030] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.431030] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.432163] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.432163] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.433293] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.433293] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.435739] PCI host bridge to bus 0000:00
[    0.435739] PCI host bridge to bus 0000:00
[    0.436489] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.436489] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.437463] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.437463] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.438541] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.438541] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.439577] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.439577] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.440024] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.440024] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.441045] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.441045] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.442081] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.442081] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.443211] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.443211] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.444501] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.444501] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.446670] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.446670] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.448589] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.448589] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.452274] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.452274] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.454041] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.454041] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.455195] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.455195] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.456244] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.456244] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.457392] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.457392] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.459008] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.459008] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.460381] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.460381] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.461547] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.461547] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.463231] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.463231] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.465133] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.465133] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.467074] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.467074] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.472470] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.472470] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.474200] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.474200] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.476023] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.476023] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.477812] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.477812] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.482318] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.482318] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.484057] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.484057] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.485521] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.485521] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.492692] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.492692] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.494169] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.494169] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.495635] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.495635] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.497104] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.497104] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.498308] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.498308] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.500826] ACPI:=20
[    0.500826] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.502539] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.502539] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.502539] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.502539] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.502539] vgaarb: loaded
[    0.502539] vgaarb: loaded
[    0.502981] vgaarb: bridge control possible 0000:00:02.0
[    0.502981] vgaarb: bridge control possible 0000:00:02.0
[    0.504293] media: Linux media interface: v0.10
[    0.504293] media: Linux media interface: v0.10
[    0.505069] Linux video capture interface: v2.00
[    0.505069] Linux video capture interface: v2.00
[    0.505946] pps_core: LinuxPPS API ver. 1 registered
[    0.505946] pps_core: LinuxPPS API ver. 1 registered
[    0.506766] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.506766] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.510089] PCI: Using ACPI for IRQ routing
[    0.510089] PCI: Using ACPI for IRQ routing
[    0.510784] PCI: pci_cache_line_size set to 64 bytes
[    0.510784] PCI: pci_cache_line_size set to 64 bytes
[    0.511724] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.511724] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.512751] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.512751] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.515496] Switched to clocksource kvm-clock
[    0.515496] Switched to clocksource kvm-clock
[    0.517581] Warning: could not register annotated branches stats
[    0.517581] Warning: could not register annotated branches stats
[    0.543198] pnp: PnP ACPI init
[    0.543198] pnp: PnP ACPI init
[    0.543932] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.543932] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.545364] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.545364] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.546590] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.546590] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.547965] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.547965] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.549137] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.549137] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.550556] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.550556] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.551866] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.551866] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.553221] pnp 00:03: [dma 2]
[    0.553221] pnp 00:03: [dma 2]
[    0.553772] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.553772] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.555012] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.555012] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.556358] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.556358] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.557621] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.557621] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.558982] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.558982] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.561915] pnp: PnP ACPI: found 6 devices
[    0.561915] pnp: PnP ACPI: found 6 devices
[    0.570360] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.570360] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.571373] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.571373] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.572328] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.572328] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.573314] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.573314] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.574278] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.574278] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.575200] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.575200] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.576266] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.576266] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.577460] NET: Registered protocol family 1
[    0.577460] NET: Registered protocol family 1
[    0.578421] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.578421] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.579417] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.579417] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.580495] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.580495] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.581603] pci 0000:00:02.0: Video device with shadowed ROM
[    0.581603] pci 0000:00:02.0: Video device with shadowed ROM
[    0.582569] PCI: CLS 0 bytes, default 64
[    0.582569] PCI: CLS 0 bytes, default 64
[    0.584359] Unpacking initramfs...
[    0.584359] Unpacking initramfs...
[    4.531322] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    4.531322] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    4.550208] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    4.550208] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    4.575223] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    4.575223] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    4.592219] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.592219] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.593856] AVX or AES-NI instructions are not detected.
[    4.593856] AVX or AES-NI instructions are not detected.
[    4.595156] AVX instructions are not detected.
[    4.595156] AVX instructions are not detected.
[    4.596279] AVX instructions are not detected.
[    4.596279] AVX instructions are not detected.
[    4.597377] AVX instructions are not detected.
[    4.597377] AVX instructions are not detected.
[    4.599815] futex hash table entries: 512 (order: 4, 65536 bytes)
[    4.599815] futex hash table entries: 512 (order: 4, 65536 bytes)
[    4.619586] Initialise system trusted keyring
[    4.619586] Initialise system trusted keyring
[    5.540746] tsc: Refined TSC clocksource calibration: 2925.997 MHz
[    5.540746] tsc: Refined TSC clocksource calibration: 2925.997 MHz
[    6.052966] Kprobe smoke test: started
[    6.052966] Kprobe smoke test: started
[    6.540741] Kprobe smoke test: passed successfully
[    6.540741] Kprobe smoke test: passed successfully
[    6.545391] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.545391] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.551569] msgmni has been set to 562
[    6.551569] msgmni has been set to 562
[    6.552673] Key type big_key registered
[    6.552673] Key type big_key registered
[    6.636218] start plist test
[    6.636218] start plist test
[    6.657595] end plist test
[    6.657595] end plist test
[    6.658625] test_firmware: interface ready
[    6.658625] test_firmware: interface ready
[    6.706350] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    6.706350] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    6.707612] crc32: self tests passed, processed 225944 bytes in 19947582=
 nsec
[    6.707612] crc32: self tests passed, processed 225944 bytes in 19947582=
 nsec
[    6.731363] crc32c: CRC_LE_BITS =3D 1
[    6.731363] crc32c: CRC_LE_BITS =3D 1
[    6.732295] crc32c: self tests passed, processed 225944 bytes in 9104121=
 nsec
[    6.732295] crc32c: self tests passed, processed 225944 bytes in 9104121=
 nsec
[    7.533607] crc32_combine: 8373 self tests passed
[    7.533607] crc32_combine: 8373 self tests passed
[    8.213427] crc32c_combine: 8373 self tests passed
[    8.213427] crc32c_combine: 8373 self tests passed
[    8.257942] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    8.257942] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    8.260384] ACPI: Power Button [PWRF]
[    8.260384] ACPI: Power Button [PWRF]
[    8.276658] r3964: Philips r3964 Driver $Revision: 1.10 $
[    8.276658] r3964: Philips r3964 Driver $Revision: 1.10 $
[    8.279077] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.279077] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.350329] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    8.350329] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    8.355822] serial: Freescale lpuart driver
[    8.355822] serial: Freescale lpuart driver
[    8.357699] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    8.357699] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    8.360622] parport_pc 00:04: reported by Plug and Play ACPI
[    8.360622] parport_pc 00:04: reported by Plug and Play ACPI
[    8.362712] parport0: PC-style at 0x378
[    8.362712] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    8.455055] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.455055] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    8.470612] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.470612] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.472539] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.472539] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.485055] i2c /dev entries driver
[    8.485055] i2c /dev entries driver
[    8.508855] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.508855] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    8.515733] pps_parport: parallel port PPS client
[    8.515733] pps_parport: parallel port PPS client
[    8.574224] pps pps0: new PPS source pps_parport
[    8.574224] pps pps0: new PPS source pps_parport
[    8.586565] pps_parport: attached to parport0
[    8.586565] pps_parport: attached to parport0
[    8.592099] pc87360: PC8736x not detected, module not inserted
[    8.592099] pc87360: PC8736x not detected, module not inserted
[    8.600799] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    8.600799] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    8.614411] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    8.614411] wafer5823wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    8.618876] it87_wdt: no device
[    8.618876] it87_wdt: no device
[    8.619715] pc87413_wdt: Version 1.1 at io 0x2E
[    8.619715] pc87413_wdt: Version 1.1 at io 0x2E
[    8.624856] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    8.624856] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    8.630235] sbc60xxwdt: I/O address 0x0443 already in use
[    8.630235] sbc60xxwdt: I/O address 0x0443 already in use
[    8.636826] cpu5wdt: misc_register failed
[    8.636826] cpu5wdt: misc_register failed
[    8.638034] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    8.638034] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    8.641576] smsc37b787_wdt: Unable to register miscdev on minor 130
[    8.641576] smsc37b787_wdt: Unable to register miscdev on minor 130
[    8.718079] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    8.718079] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    8.720319] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[    8.720319] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[    8.722336] dgap: For the tools package please visit http://www.digi.com
[    8.722336] dgap: For the tools package please visit http://www.digi.com
[    8.762590]=20
[    8.762590] printing PIC contents
[    8.762590]=20
[    8.762590] printing PIC contents
[    8.764152] ... PIC  IMR: ffff
[    8.764152] ... PIC  IMR: ffff
[    8.765188] ... PIC  IRR: 1093
[    8.765188] ... PIC  IRR: 1093
[    8.766196] ... PIC  ISR: 0000
[    8.766196] ... PIC  ISR: 0000
[    8.775783] ... PIC ELCR: 0c00
[    8.775783] ... PIC ELCR: 0c00
[    8.776815] printing local APIC contents on CPU#0/0:
[    8.776815] printing local APIC contents on CPU#0/0:
[    8.778494] ... APIC ID:      00000000 (0)
[    8.778494] ... APIC ID:      00000000 (0)
[    8.779795] ... APIC VERSION: 01050014
[    8.779795] ... APIC VERSION: 01050014
[    8.781067] ... APIC TASKPRI: 00000000 (00)
[    8.781067] ... APIC TASKPRI: 00000000 (00)
[    8.782454] ... APIC PROCPRI: 00000000
[    8.782454] ... APIC PROCPRI: 00000000
[    8.785737] ... APIC LDR: 01000000
[    8.785737] ... APIC LDR: 01000000
[    8.785737] ... APIC DFR: ffffffff
[    8.785737] ... APIC DFR: ffffffff
[    8.785737] ... APIC SPIV: 000001ff
[    8.785737] ... APIC SPIV: 000001ff
[    8.785737] ... APIC ISR field:
[    8.785737] ... APIC ISR field:
[    8.785737] 00000000
[    8.785737] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    8.785737] ... APIC TMR field:
[    8.785737] ... APIC TMR field:
[    8.785737] 00000000
[    8.785737] 000000000e2000000e200000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[    8.785737] ... APIC IRR field:
[    8.785737] ... APIC IRR field:
[    8.785737] 00000000
[    8.785737] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[    8.785737] ... APIC ESR: 00000000
[    8.785737] ... APIC ESR: 00000000
[    8.785737] ... APIC ICR: 000008fd
[    8.785737] ... APIC ICR: 000008fd
[    8.785737] ... APIC ICR2: 02000000
[    8.785737] ... APIC ICR2: 02000000
[    8.785737] ... APIC LVTT: 000000ef
[    8.785737] ... APIC LVTT: 000000ef
[    8.785737] ... APIC LVTPC: 00010000
[    8.785737] ... APIC LVTPC: 00010000
[    8.785737] ... APIC LVT0: 00010700
[    8.785737] ... APIC LVT0: 00010700
[    8.785737] ... APIC LVT1: 00000400
[    8.785737] ... APIC LVT1: 00000400
[    8.785737] ... APIC LVTERR: 000000fe
[    8.785737] ... APIC LVTERR: 000000fe
[    8.785737] ... APIC TMICT: 00040d1e
[    8.785737] ... APIC TMICT: 00040d1e
[    8.785737] ... APIC TMCCT: 00000000
[    8.785737] ... APIC TMCCT: 00000000
[    8.785737] ... APIC TDCR: 00000003
[    8.785737] ... APIC TDCR: 00000003
[    8.785737]=20
[    8.785737]=20
[    8.841298] number of MP IRQ sources: 15.
[    8.841298] number of MP IRQ sources: 15.
[    8.842222] number of IO-APIC #0 registers: 24.
[    8.842222] number of IO-APIC #0 registers: 24.
[    8.843300] testing the IO APIC.......................
[    8.843300] testing the IO APIC.......................
[    8.858518] IO APIC #0......
[    8.858518] IO APIC #0......
[    8.859178] .... register #00: 00000000
[    8.859178] .... register #00: 00000000
[    8.860039] .......    : physical APIC id: 00
[    8.860039] .......    : physical APIC id: 00
[    8.860998] .......    : Delivery Type: 0
[    8.860998] .......    : Delivery Type: 0
[    8.861894] .......    : LTS          : 0
[    8.861894] .......    : LTS          : 0
[    8.862756] .... register #01: 00170011
[    8.862756] .... register #01: 00170011
[    8.863854] .......     : max redirection entries: 17
[    8.863854] .......     : max redirection entries: 17
[    8.865311] .......     : PRQ implemented: 0
[    8.865311] .......     : PRQ implemented: 0
[    8.866315] .......     : IO APIC version: 11
[    8.866315] .......     : IO APIC version: 11
[    8.867307] .... register #02: 00000000
[    8.867307] .... register #02: 00000000
[    8.868199] .......     : arbitration: 00
[    8.868199] .......     : arbitration: 00
[    8.869162] .... IRQ redirection table:
[    8.869162] .... IRQ redirection table:
[    8.870205] 1    0    0   0   0    0    0    00
[    8.870205] 1    0    0   0   0    0    0    00
[    8.883716] 0    0    0   0   0    1    1    31
[    8.883716] 0    0    0   0   0    1    1    31
[    8.885166] 0    0    0   0   0    1    1    30
[    8.885166] 0    0    0   0   0    1    1    30
[    8.886651] 0    0    0   0   0    1    1    33
[    8.886651] 0    0    0   0   0    1    1    33
[    8.901182] 1    0    0   0   0    1    1    34
[    8.901182] 1    0    0   0   0    1    1    34
[    8.902250] 1    1    0   0   0    1    1    35
[    8.902250] 1    1    0   0   0    1    1    35
[    8.903274] 0    0    0   0   0    1    1    36
[    8.903274] 0    0    0   0   0    1    1    36
[    8.904311] 0    0    0   0   0    1    1    37
[    8.904311] 0    0    0   0   0    1    1    37
[    8.905483] 0    0    0   0   0    1    1    38
[    8.905483] 0    0    0   0   0    1    1    38
[    8.906650] 0    1    0   0   0    1    1    39
[    8.906650] 0    1    0   0   0    1    1    39
[    8.907666] 1    1    0   0   0    1    1    3A
[    8.907666] 1    1    0   0   0    1    1    3A
[    8.908654] 1    1    0   0   0    1    1    3B
[    8.908654] 1    1    0   0   0    1    1    3B
[    8.909644] 0    0    0   0   0    1    1    3C
[    8.909644] 0    0    0   0   0    1    1    3C
[    8.913562] 0    0    0   0   0    1    1    3D
[    8.913562] 0    0    0   0   0    1    1    3D
[    8.914631] 0    0    0   0   0    1    1    3E
[    8.914631] 0    0    0   0   0    1    1    3E
[    8.915715] 0    0    0   0   0    1    1    3F
[    8.915715] 0    0    0   0   0    1    1    3F
[    8.916755] 1    0    0   0   0    0    0    00
[    8.916755] 1    0    0   0   0    0    0    00
[    8.917796] 1    0    0   0   0    0    0    00
[    8.917796] 1    0    0   0   0    0    0    00
[    8.918840] 1    0    0   0   0    0    0    00
[    8.918840] 1    0    0   0   0    0    0    00
[    8.919915] 1    0    0   0   0    0    0    00
[    8.919915] 1    0    0   0   0    0    0    00
[    8.921091] 1    0    0   0   0    0    0    00
[    8.921091] 1    0    0   0   0    0    0    00
[    8.922225] 1    0    0   0   0    0    0    00
[    8.922225] 1    0    0   0   0    0    0    00
[    8.923271] 1    0    0   0   0    0    0    00
[    8.923271] 1    0    0   0   0    0    0    00
[    8.924317] 1    0    0   0   0    0    0    00
[    8.924317] 1    0    0   0   0    0    0    00
[    8.936700] IRQ to pin mappings:
[    8.936700] IRQ to pin mappings:
[    8.937687] IRQ0=20
[    8.937687] IRQ0 -> 0:2-> 0:2

[    8.951516] IRQ1=20
[    8.951516] IRQ1 -> 0:1-> 0:1

[    8.952362] IRQ3=20
[    8.952362] IRQ3 -> 0:3-> 0:3

[    8.953240] IRQ4=20
[    8.953240] IRQ4 -> 0:4-> 0:4

[    8.954179] IRQ5=20
[    8.954179] IRQ5 -> 0:5-> 0:5

[    8.955047] IRQ6=20
[    8.955047] IRQ6 -> 0:6-> 0:6

[    8.955775] IRQ7=20
[    8.955775] IRQ7 -> 0:7-> 0:7

[    8.956419] IRQ8=20
[    8.956419] IRQ8 -> 0:8-> 0:8

[    8.957063] IRQ9=20
[    8.957063] IRQ9 -> 0:9-> 0:9

[    8.957713] IRQ10=20
[    8.957713] IRQ10 -> 0:10-> 0:10

[    8.958425] IRQ11=20
[    8.958425] IRQ11 -> 0:11-> 0:11

[    8.959106] IRQ12=20
[    8.959106] IRQ12 -> 0:12-> 0:12

[    8.959801] IRQ13=20
[    8.959801] IRQ13 -> 0:13-> 0:13

[    8.963061] IRQ14=20
[    8.963061] IRQ14 -> 0:14-> 0:14

[    8.963752] IRQ15=20
[    8.963752] IRQ15 -> 0:15-> 0:15

[    8.964467] .................................... done.
[    8.964467] .................................... done.
[    8.968893] bootconsole [earlyser0] disabled
[    8.968893] bootconsole [earlyser0] disabled
[    8.970174] Loading compiled-in X.509 certificates
[    8.971447] Running ring buffer tests...
[   19.055464] finished
[   19.056368] CPU 0:
[   19.056677]               events:    104392
[   19.057259]        dropped bytes:    0
[   19.057754]        alloced bytes:    7999300
[   19.058391]        written bytes:    7845407
[   19.058921]        biggest event:    247
[   19.059471]       smallest event:    4
[   19.122547]          read events:   16084
[   19.123139]          lost events:   88308
[   19.123689]         total events:   104392
[   19.124273]   recorded len bytes:   968288
[   19.124865]  recorded size bytes:   943605
[   19.125476]  With dropped events, record len and size may not match
[   19.125476]  alloced and written from above
[   19.145064] CPU 1:
[   19.145323]               events:    6658
[   19.145802]        dropped bytes:    0
[   19.146232]        alloced bytes:    625248
[   19.146702]        written bytes:    615080
[   19.147178]        biggest event:    202
[   19.147616]       smallest event:    6
[   19.174435]          read events:   6658
[   19.175067]          lost events:   0
[   19.175553]         total events:   6658
[   19.176091]   recorded len bytes:   625248
[   19.176656]  recorded size bytes:   615080
[   19.177248] Ring buffer PASSED!
[   19.228805] Key type encrypted registered
[   19.247897] Unregister pv shared memory for cpu 0
[   19.455938] numa_remove_cpu cpu 0 node 0: mask now 1
[   19.460780] CPU 0 is now offline
[   19.477605] Freeing unused kernel memory: 964K (ffffffff81f2d000 - fffff=
fff8201e000)
[   19.478575] Write protecting the kernel read-only data: 12288k
[   19.516801] Freeing unused kernel memory: 548K (ffff880001577000 - ffff8=
80001600000)
[   19.558001] Freeing unused kernel memory: 1876K (ffff880001a2b000 - ffff=
880001c00000)
[   19.586279] random: init urandom read with 4 bits of entropy available
mountall: Event failed
mount: unknown filesystem type 'sysfs'
mountall: mount /sys [108] terminated with status 32
mountall: Filesystem could not be mounted: /sys
mountall: Skipping mounting /sys since Plymouth is not available
[   20.157495] init: Failed to create pty - disabling logging for job
[   20.158557] init: Temporary process spawn error: No such file or directo=
ry
[   20.253116] init: Failed to create pty - disabling logging for job
[   20.254267] init: Temporary process spawn error: No such file or directo=
ry
[   20.469700] init: Failed to create pty - disabling logging for job
[   20.471554] init: Temporary process spawn error: No such file or directo=
ry
[   20.495193] init: Failed to create pty - disabling logging for job
[   20.496367] init: Temporary process spawn error: No such file or directo=
ry
[   20.835166] init: Failed to create pty - disabling logging for job
[   20.836943] init: Temporary process spawn error: No such file or directo=
ry
[   20.843248] init: Failed to create pty - disabling logging for job
[   20.844434] init: Temporary process spawn error: No such file or directo=
ry
[   20.903728] init: Failed to create pty - disabling logging for job
[   20.904922] init: Temporary process spawn error: No such file or directo=
ry
[   20.911837] init: Failed to create pty - disabling logging for job
[   20.913037] init: Temporary process spawn error: No such file or directo=
ry
[   21.101514] init: Failed to create pty - disabling logging for job
[   21.149451] init: Failed to create pty - disabling logging for job
udevd[159]: error creating signalfd
[   21.183020] init: Failed to create pty - disabling logging for job
[   21.230686] init: Failed to create pty - disabling logging for job
[   21.351906] init: Failed to create pty - disabling logging for job
[   21.392125] init: Failed to create pty - disabling logging for job
udevd[168]: error creating signalfd
[   21.473255] init: Failed to create pty - disabling logging for job
[   21.502853] init: Failed to create pty - disabling logging for job
udevd[177]: error creating signalfd
udevd[179]: error creating signalfd
udevd[181]: error creating signalfd
udevd[183]: error creating signalfd
udevd[185]: error creating signalfd
udevd[187]: error creating signalfd
udevd[189]: error creating signalfd
udevd[191]: error creating signalfd
udevd[193]: error creating signalfd
[   79.929143] init: Failed to create pty - disabling logging for job
umount: /run/lock: not mounted
 * Will now restart
[   80.601482] reboot: Restarting system
Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-ib0-12101221/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-0=
0088-ge754569 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug=
 apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-i=
b0-12101221/linux-devel:devel-lkp-ib04-smoke-201412101243:e754569101f392e19=
24d8ce6f087ea4cfad91d69:bisect-linux-6/.vmlinuz-e754569101f392e1924d8ce6f08=
7ea4cfad91d69-20141210134300-12-client9 branch=3Dlinux-devel/devel-lkp-ib04=
-smoke-201412101243 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ib0-12101221/e75=
4569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-00088-ge754569 drb=
d.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m=
 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-quantal-client9-12 -serial file:/dev/shm/kboot/serial-quantal-cl=
ient9-12 -daemonize -display none -monitor null=20

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.18.0-rc2-00089-g1fadb58"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.18.0-rc2 Kernel Configuration
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TASKS_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
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
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SCHED_IO_LATENCY is not set
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
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_ADVISE_SYSCALLS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS=y
CONFIG_MODULE_COMPRESS_GZIP=y
# CONFIG_MODULE_COMPRESS_XZ is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
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
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_IOSF_MBI is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_X86_16BIT is not set
CONFIG_I8K=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
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
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_AREAS=7
# CONFIG_MEM_SOFT_DIRTY is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_VERIFY_SIG=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
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
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ENERGY_MODEL is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
# CONFIG_CPU_FREQ_GOV_ENERGY_MODEL is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
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
CONFIG_CPU_IDLE_GOV_SELECT=y
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
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DISABLE_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
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
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
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
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_SPI_NOR=m
# CONFIG_MTD_SPI_NOR_USE_4K_SECTORS is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29020=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=y
CONFIG_DS1682=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

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
CONFIG_ECHO=m
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=m
CONFIG_TOUCHSCREEN_DA9034=m
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_WM831X=m
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=m
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=m
# CONFIG_INPUT_MAX8925_ONKEY is not set
# CONFIG_INPUT_MAX8997_HAPTIC is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_BEEPER=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PALMAS_PWRBUTTON=m
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_PWM_BEEPER=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9055_ONKEY=m
CONFIG_INPUT_WM831X_ON=m
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=m
# CONFIG_INPUT_CMA3000_I2C is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_SOC_BUTTON_ARRAY is not set
CONFIG_INPUT_DRV260X_HAPTICS=m
# CONFIG_INPUT_DRV2667_HAPTICS is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=m
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=m
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_MEN_Z135=y
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=m

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
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
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
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_DWAPB is not set
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
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_WM831X=m
# CONFIG_GPIO_WM8994 is not set
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
CONFIG_GPIO_MAX7301=m
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=m

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set

#
# USB GPIO expanders:
#
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=m
CONFIG_W1_SLAVE_DS2423=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
CONFIG_WM831X_BACKUP=m
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=m
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=m
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=m
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=y
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4260=m
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_BANG_BANG is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
# CONFIG_INT340X_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_DA9055_WATCHDOG=m
CONFIG_DA9063_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=m
# CONFIG_XILINX_WATCHDOG is not set
CONFIG_DW_WATCHDOG=y
# CONFIG_RN5T618_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_ACQUIRE_WDT=m
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=m
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_MEN_A21_WDT=y

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
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
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
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=m
# CONFIG_MFD_AXP20X is not set
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=m
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=m
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=m
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_RN5T618=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=m
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=m
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=m
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_AAT2870=m
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_BCM590XX=m
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9055=m
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_DA9211 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL9305=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LTC3589 is not set
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8925=m
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MAX77802 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_PWM=y
CONFIG_REGULATOR_RN5T618=m
CONFIG_REGULATOR_S2MPA01=m
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
CONFIG_IR_HIX5HD2=m
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
# CONFIG_IR_IMG is not set
# CONFIG_RC_LOOPBACK is not set
CONFIG_IR_GPIO_CIR=m
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVID is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_AS102_FE is not set

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

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
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_PTN3460=m
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
CONFIG_FB_CMDLINE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=m
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=y
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_LCD_LMS501KF03=m
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_BACKLIGHT_PANDORA is not set
CONFIG_BACKLIGHT_AS3711=m
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=y
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=m
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
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
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

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
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_DA903X is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC_CORE is not set
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_DMA_ACPI=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
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
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_COMEDI is not set
# CONFIG_PANEL is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
CONFIG_VIDEO_V4L2_INT_DEVICE=m
CONFIG_VIDEO_TCM825X=m

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
# CONFIG_GS_FPGABOOT is not set
CONFIG_CRYPTO_SKEIN=y
CONFIG_CRYPTO_THREEFISH=y
# CONFIG_UNISYSSPAR is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#
CONFIG_SOC_TI=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX14577=m
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_PALMAS=m
CONFIG_EXTCON_RT8973A=m
CONFIG_EXTCON_SM5502=m
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_LPSS=m
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
# CONFIG_SYSFS is not set
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m

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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHED_IDLE_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_RING_BUFFER_STARTUP_TEST=y

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_LKM is not set
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
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
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=m
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA1_MB=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
# CONFIG_CRYPTO_DRBG_HMAC is not set
CONFIG_CRYPTO_DRBG_HASH=y
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_ARCH_HAS_SG_CHAIN=y

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--Y5rl02BVI9TCfPar--
