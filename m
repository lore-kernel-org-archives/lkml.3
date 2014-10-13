Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaJMRfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:35:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbaJMRfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:35:15 -0400
Date: Mon, 13 Oct 2014 13:35:04 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: paulmck@linux.vnet.ibm.com, htejun@gmail.com
Subject: rcu_preempt detected stalls.
Message-ID: <20141013173504.GA27955@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	paulmck@linux.vnet.ibm.com, htejun@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today in "rcu stall while fuzzing" news:

INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)
trinity-c342    R  running task    13384   766  32295 0x00000000
 ffff880068943d58 0000000000000002 0000000000000002 ffff880193c8c680
 00000000001d4100 0000000000000000 ffff880068943fd8 00000000001d4100
 ffff88024302c680 ffff880193c8c680 ffff880068943fd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff880d9424>] ? lock_acquire+0xd4/0x2b0
 [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
 [<ffffffff8808d4d5>] kill_pid_info+0x45/0x130
 [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
 [<ffffffff8808d6d2>] SYSC_kill+0xf2/0x2f0
 [<ffffffff8808d67b>] ? SYSC_kill+0x9b/0x2f0
 [<ffffffff8819c2b7>] ? context_tracking_user_exit+0x57/0x280
 [<ffffffff880136bd>] ? syscall_trace_enter+0x13d/0x310
 [<ffffffff8808fd9e>] SyS_kill+0xe/0x10
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
trinity-c225    R  running task    13448   646  32295 0x00000000
 ffff880161ccfb28 0000000000000002 ffff880161ccfe10 ffff88000bf85e00
 00000000001d4100 0000000000000003 ffff880161ccffd8 00000000001d4100
 ffff880030124680 ffff88000bf85e00 ffff880161ccffd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff88233d41>] ? __d_lookup_rcu+0xd1/0x1e0
 [<ffffffff88233dd6>] ? __d_lookup_rcu+0x166/0x1e0
 [<ffffffff88222f9f>] lookup_fast+0x4f/0x3d0
 [<ffffffff88224857>] link_path_walk+0x1a7/0x8a0
 [<ffffffff88224f95>] ? path_lookupat+0x45/0x7b0
 [<ffffffff88224fb7>] path_lookupat+0x67/0x7b0
 [<ffffffff880d385d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8883dda4>] ? retint_restore_args+0xe/0xe
 [<ffffffff8822572b>] filename_lookup+0x2b/0xc0
 [<ffffffff88229c77>] user_path_at_empty+0x67/0xc0
 [<ffffffff880d3dbe>] ? put_lock_stats.isra.27+0xe/0x30
 [<ffffffff880d42a6>] ? lock_release_holdtime.part.28+0xe6/0x160
 [<ffffffff880b15ad>] ? get_parent_ip+0xd/0x50
 [<ffffffff88229ce1>] user_path_at+0x11/0x20
 [<ffffffff8824fac1>] do_utimes+0xd1/0x180
 [<ffffffff8824fbef>] SyS_utime+0x7f/0xc0
 [<ffffffff8883d345>] ? tracesys+0x7e/0xe2
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
trinity-c342    R  running task    13384   766  32295 0x00000000
 ffff880068943d58 0000000000000002 0000000000000002 ffff880193c8c680
 00000000001d4100 0000000000000000 ffff880068943fd8 00000000001d4100
 ffff88024302c680 ffff880193c8c680 ffff880068943fd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff880d9424>] ? lock_acquire+0xd4/0x2b0
 [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
 [<ffffffff8808d4d5>] kill_pid_info+0x45/0x130
 [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
 [<ffffffff8808d6d2>] SYSC_kill+0xf2/0x2f0
 [<ffffffff8808d67b>] ? SYSC_kill+0x9b/0x2f0
 [<ffffffff8819c2b7>] ? context_tracking_user_exit+0x57/0x280
 [<ffffffff880136bd>] ? syscall_trace_enter+0x13d/0x310
 [<ffffffff8808fd9e>] SyS_kill+0xe/0x10
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
trinity-c225    R  running task    13448   646  32295 0x00000000
 ffff880161ccfb28 0000000000000002 ffff880161ccfe10 ffff88000bf85e00
 00000000001d4100 0000000000000003 ffff880161ccffd8 00000000001d4100
 ffff880030124680 ffff88000bf85e00 ffff880161ccffd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff88233d41>] ? __d_lookup_rcu+0xd1/0x1e0
 [<ffffffff88233dd6>] ? __d_lookup_rcu+0x166/0x1e0
 [<ffffffff88222f9f>] lookup_fast+0x4f/0x3d0
 [<ffffffff88224857>] link_path_walk+0x1a7/0x8a0
 [<ffffffff88224f95>] ? path_lookupat+0x45/0x7b0
 [<ffffffff88224fb7>] path_lookupat+0x67/0x7b0
 [<ffffffff880d385d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8883dda4>] ? retint_restore_args+0xe/0xe
 [<ffffffff8822572b>] filename_lookup+0x2b/0xc0
 [<ffffffff88229c77>] user_path_at_empty+0x67/0xc0
 [<ffffffff880d3dbe>] ? put_lock_stats.isra.27+0xe/0x30
 [<ffffffff880d42a6>] ? lock_release_holdtime.part.28+0xe6/0x160
 [<ffffffff880b15ad>] ? get_parent_ip+0xd/0x50
 [<ffffffff88229ce1>] user_path_at+0x11/0x20
 [<ffffffff8824fac1>] do_utimes+0xd1/0x180
 [<ffffffff8824fbef>] SyS_utime+0x7f/0xc0
 [<ffffffff8883d345>] ? tracesys+0x7e/0xe2
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
INFO: rcu_preempt detected stalls on CPUs/tasks:
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
	(detected by 3, t=26007 jiffies, g=75434, c=75433, q=0)
trinity-c342    R  running task    13384   766  32295 0x00000000
 ffff880068943d98 0000000000000002 0000000000000000 ffff880193c8c680
 00000000001d4100 0000000000000000 ffff880068943fd8 00000000001d4100
 ffff88000188af00 ffff880193c8c680 ffff880068943fd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff8809f767>] ? pid_task+0x47/0xa0
 [<ffffffff8809f73d>] ? pid_task+0x1d/0xa0
 [<ffffffff8808d4f1>] kill_pid_info+0x61/0x130
 [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
 [<ffffffff8808d6d2>] SYSC_kill+0xf2/0x2f0
 [<ffffffff8808d67b>] ? SYSC_kill+0x9b/0x2f0
 [<ffffffff8819c2b7>] ? context_tracking_user_exit+0x57/0x280
 [<ffffffff880136bd>] ? syscall_trace_enter+0x13d/0x310
 [<ffffffff8808fd9e>] SyS_kill+0xe/0x10
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
trinity-c225    R  running task    13448   646  32295 0x00000000
 ffff880161ccfb78 0000000000000002 ffffffff88c993ed ffff88000bf85e00
 00000000001d4100 0000000000000003 ffff880161ccffd8 00000000001d4100
 ffff88005ea89780 ffff88000bf85e00 ffff880161ccffd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff8822303a>] ? lookup_fast+0xea/0x3d0
 [<ffffffff88223025>] ? lookup_fast+0xd5/0x3d0
 [<ffffffff88224857>] link_path_walk+0x1a7/0x8a0
 [<ffffffff88224f95>] ? path_lookupat+0x45/0x7b0
 [<ffffffff88224fb7>] path_lookupat+0x67/0x7b0
 [<ffffffff880d385d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8883dda4>] ? retint_restore_args+0xe/0xe
 [<ffffffff8822572b>] filename_lookup+0x2b/0xc0
 [<ffffffff88229c77>] user_path_at_empty+0x67/0xc0
 [<ffffffff880d3dbe>] ? put_lock_stats.isra.27+0xe/0x30
 [<ffffffff880d42a6>] ? lock_release_holdtime.part.28+0xe6/0x160
 [<ffffffff880b15ad>] ? get_parent_ip+0xd/0x50
 [<ffffffff88229ce1>] user_path_at+0x11/0x20
 [<ffffffff8824fac1>] do_utimes+0xd1/0x180
 [<ffffffff8824fbef>] SyS_utime+0x7f/0xc0
 [<ffffffff8883d345>] ? tracesys+0x7e/0xe2
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
trinity-c342    R  running task    13384   766  32295 0x00000000
 ffff880068943d98 0000000000000002 0000000000000000 ffff880193c8c680
 00000000001d4100 0000000000000000 ffff880068943fd8 00000000001d4100
 ffff88000188af00 ffff880193c8c680 ffff880068943fd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff8809f767>] ? pid_task+0x47/0xa0
 [<ffffffff8809f73d>] ? pid_task+0x1d/0xa0
 [<ffffffff8808d4f1>] kill_pid_info+0x61/0x130
 [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
 [<ffffffff8808d6d2>] SYSC_kill+0xf2/0x2f0
 [<ffffffff8808d67b>] ? SYSC_kill+0x9b/0x2f0
 [<ffffffff8819c2b7>] ? context_tracking_user_exit+0x57/0x280
 [<ffffffff880136bd>] ? syscall_trace_enter+0x13d/0x310
 [<ffffffff8808fd9e>] SyS_kill+0xe/0x10
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
trinity-c225    R  running task    13448   646  32295 0x00000000
 ffff880161ccfb78 0000000000000002 ffffffff88c993ed ffff88000bf85e00
 00000000001d4100 0000000000000003 ffff880161ccffd8 00000000001d4100
 ffff88005ea89780 ffff88000bf85e00 ffff880161ccffd8 0000000000000000
Call Trace:
 [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
 [<ffffffff8883df10>] retint_kernel+0x20/0x30
 [<ffffffff8822303a>] ? lookup_fast+0xea/0x3d0
 [<ffffffff88223025>] ? lookup_fast+0xd5/0x3d0
 [<ffffffff88224857>] link_path_walk+0x1a7/0x8a0
 [<ffffffff88224f95>] ? path_lookupat+0x45/0x7b0
 [<ffffffff88224fb7>] path_lookupat+0x67/0x7b0
 [<ffffffff880d385d>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8883dda4>] ? retint_restore_args+0xe/0xe
 [<ffffffff8822572b>] filename_lookup+0x2b/0xc0
 [<ffffffff88229c77>] user_path_at_empty+0x67/0xc0
 [<ffffffff880d3dbe>] ? put_lock_stats.isra.27+0xe/0x30
 [<ffffffff880d42a6>] ? lock_release_holdtime.part.28+0xe6/0x160
 [<ffffffff880b15ad>] ? get_parent_ip+0xd/0x50
 [<ffffffff88229ce1>] user_path_at+0x11/0x20
 [<ffffffff8824fac1>] do_utimes+0xd1/0x180
 [<ffffffff8824fbef>] SyS_utime+0x7f/0xc0
 [<ffffffff8883d345>] ? tracesys+0x7e/0xe2
 [<ffffffff8883d3a4>] tracesys+0xdd/0xe2

This is on Linus' current tree, with the new CONFIG_TASKS_RCU unset.

	Dave

