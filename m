Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab3HZO6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:58:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab3HZO6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:58:47 -0400
Date: Mon, 26 Aug 2013 10:58:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: suspicious RCU usage (perf)
Message-ID: <20130826145838.GA8377@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another day, another rcu backtrace..
This says rc6, but it's pretty darn close to rc7, I think it was running
a build from Friday.

[260431.854524] ===============================
[260431.855485] [ INFO: suspicious RCU usage. ]
[260431.856437] 3.11.0-rc6+ #12 Not tainted
[260431.857377] -------------------------------
[260431.858318] include/linux/rcupdate.h:779 rcu_read_lock() used illegally while idle!
[260431.859278] other info that might help us debug this:
[260431.862144] RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
[260431.864990] RCU used illegally from extended quiescent state!
[260431.865949] 1 lock held by trinity-kid3/15917:
[260431.866901]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81146d50>] __perf_event_overflow+0x100/0x320
[260431.867896] stack backtrace:
[260431.869815] CPU: 0 PID: 15917 Comm: trinity-kid3 Not tainted 3.11.0-rc6+ #12
[260431.871885]  0000000000000000 ffff8801095d3ad0 ffffffff816f9c6f ffff88023ce86950
[260431.872912]  ffff8801095d3b00 ffffffff810be6a7 ffff880079695cd0 0000000000000000
[260431.873910]  ffff8801095d3c00 0000000000000000 ffff8801095d3b80 ffffffff81146ef4
[260431.874909] Call Trace:
[260431.875883]  [<ffffffff816f9c6f>] dump_stack+0x54/0x74
[260431.876869]  [<ffffffff810be6a7>] lockdep_rcu_suspicious+0xe7/0x120
[260431.877852]  [<ffffffff81146ef4>] __perf_event_overflow+0x2a4/0x320
[260431.878834]  [<ffffffff81146d50>] ? __perf_event_overflow+0x100/0x320
[260431.879811]  [<ffffffff81146e0c>] ? __perf_event_overflow+0x1bc/0x320
[260431.880784]  [<ffffffff8170ce00>] ? ftrace_call+0x5/0x2f
[260431.881758]  [<ffffffff81147101>] perf_swevent_overflow+0x51/0xe0
[260431.882728]  [<ffffffff811471ef>] perf_swevent_event+0x5f/0x90
[260431.883685]  [<ffffffff81147329>] perf_tp_event+0x109/0x4f0
[260431.884637]  [<ffffffff81147542>] ? perf_tp_event+0x322/0x4f0
[260431.885586]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
[260431.886539]  [<ffffffff8107a320>] ? task_work_run+0xe0/0xe0
[260431.887486]  [<ffffffff81135910>] perf_ftrace_function_call+0xc0/0xd0
[260431.888417]  [<ffffffff81114d37>] ? ftrace_ops_control_func+0xe7/0x110
[260431.889353]  [<ffffffff8107a320>] ? task_work_run+0xe0/0xe0
[260431.890281]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
[260431.891191]  [<ffffffff81114d37>] ftrace_ops_control_func+0xe7/0x110
[260431.892088]  [<ffffffff8170ce00>] ftrace_call+0x5/0x2f
[260431.892975]  [<ffffffff81114cbb>] ? ftrace_ops_control_func+0x6b/0x110
[260431.893862]  [<ffffffff8170ce00>] ? ftrace_call+0x5/0x2f
[260431.894745]  [<ffffffff81097def>] ? local_clock+0x3f/0x50
[260431.895631]  [<ffffffff8107a325>] ? debug_lockdep_rcu_enabled+0x5/0x40
[260431.896516]  [<ffffffff8107a325>] ? debug_lockdep_rcu_enabled+0x5/0x40
[260431.897387]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
[260431.898264]  [<ffffffff81107e24>] rcu_eqs_enter+0x64/0xa0
[260431.899133]  [<ffffffff8110c673>] rcu_user_enter+0x13/0x20
[260431.899999]  [<ffffffff8114e67a>] user_enter+0x6a/0xd0
[260431.900859]  [<ffffffff81010208>] syscall_trace_leave+0x78/0x150
[260431.901712]  [<ffffffff8170d4af>] int_check_syscall_exit_work+0x34/0x3d
