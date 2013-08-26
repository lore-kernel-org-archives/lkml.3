Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3HZQ3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:29:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56835 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3HZQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:29:45 -0400
Date: Mon, 26 Aug 2013 09:29:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rostedt@goodmis.org
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130826162928.GQ3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130826145838.GA8377@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826145838.GA8377@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082616-5518-0000-0000-00001177FBD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 10:58:38AM -0400, Dave Jones wrote:
> Another day, another rcu backtrace..
> This says rc6, but it's pretty darn close to rc7, I think it was running
> a build from Friday.

Could you please send your .config?  Also, were you running ftrace,
perf, RCU event tracing, or what?

Looks like you are running ftrace, but I though Steven had set that
up so that it could be called from an extended quiescent state.

							Thanx, Paul

> [260431.854524] ===============================
> [260431.855485] [ INFO: suspicious RCU usage. ]
> [260431.856437] 3.11.0-rc6+ #12 Not tainted
> [260431.857377] -------------------------------
> [260431.858318] include/linux/rcupdate.h:779 rcu_read_lock() used illegally while idle!
> [260431.859278] other info that might help us debug this:
> [260431.862144] RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> [260431.864990] RCU used illegally from extended quiescent state!
> [260431.865949] 1 lock held by trinity-kid3/15917:
> [260431.866901]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff81146d50>] __perf_event_overflow+0x100/0x320
> [260431.867896] stack backtrace:
> [260431.869815] CPU: 0 PID: 15917 Comm: trinity-kid3 Not tainted 3.11.0-rc6+ #12
> [260431.871885]  0000000000000000 ffff8801095d3ad0 ffffffff816f9c6f ffff88023ce86950
> [260431.872912]  ffff8801095d3b00 ffffffff810be6a7 ffff880079695cd0 0000000000000000
> [260431.873910]  ffff8801095d3c00 0000000000000000 ffff8801095d3b80 ffffffff81146ef4
> [260431.874909] Call Trace:
> [260431.875883]  [<ffffffff816f9c6f>] dump_stack+0x54/0x74
> [260431.876869]  [<ffffffff810be6a7>] lockdep_rcu_suspicious+0xe7/0x120
> [260431.877852]  [<ffffffff81146ef4>] __perf_event_overflow+0x2a4/0x320
> [260431.878834]  [<ffffffff81146d50>] ? __perf_event_overflow+0x100/0x320
> [260431.879811]  [<ffffffff81146e0c>] ? __perf_event_overflow+0x1bc/0x320
> [260431.880784]  [<ffffffff8170ce00>] ? ftrace_call+0x5/0x2f
> [260431.881758]  [<ffffffff81147101>] perf_swevent_overflow+0x51/0xe0
> [260431.882728]  [<ffffffff811471ef>] perf_swevent_event+0x5f/0x90
> [260431.883685]  [<ffffffff81147329>] perf_tp_event+0x109/0x4f0
> [260431.884637]  [<ffffffff81147542>] ? perf_tp_event+0x322/0x4f0
> [260431.885586]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
> [260431.886539]  [<ffffffff8107a320>] ? task_work_run+0xe0/0xe0
> [260431.887486]  [<ffffffff81135910>] perf_ftrace_function_call+0xc0/0xd0
> [260431.888417]  [<ffffffff81114d37>] ? ftrace_ops_control_func+0xe7/0x110
> [260431.889353]  [<ffffffff8107a320>] ? task_work_run+0xe0/0xe0
> [260431.890281]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
> [260431.891191]  [<ffffffff81114d37>] ftrace_ops_control_func+0xe7/0x110
> [260431.892088]  [<ffffffff8170ce00>] ftrace_call+0x5/0x2f
> [260431.892975]  [<ffffffff81114cbb>] ? ftrace_ops_control_func+0x6b/0x110
> [260431.893862]  [<ffffffff8170ce00>] ? ftrace_call+0x5/0x2f
> [260431.894745]  [<ffffffff81097def>] ? local_clock+0x3f/0x50
> [260431.895631]  [<ffffffff8107a325>] ? debug_lockdep_rcu_enabled+0x5/0x40
> [260431.896516]  [<ffffffff8107a325>] ? debug_lockdep_rcu_enabled+0x5/0x40
> [260431.897387]  [<ffffffff811079fb>] ? rcu_eqs_enter_common+0x5b/0x420
> [260431.898264]  [<ffffffff81107e24>] rcu_eqs_enter+0x64/0xa0
> [260431.899133]  [<ffffffff8110c673>] rcu_user_enter+0x13/0x20
> [260431.899999]  [<ffffffff8114e67a>] user_enter+0x6a/0xd0
> [260431.900859]  [<ffffffff81010208>] syscall_trace_leave+0x78/0x150
> [260431.901712]  [<ffffffff8170d4af>] int_check_syscall_exit_work+0x34/0x3d
> 

