Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3FZEbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:31:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3FZEbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:31:20 -0400
Date: Wed, 26 Jun 2013 00:31:06 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: a.p.zijlstra@chello.nl, mingo@redhat.com
Subject: __perf_event_overflow suspicious RCU usage.
Message-ID: <20130626043106.GA31416@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl,
	mingo@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[40924.102878] ===============================
[40924.102898] [ INFO: suspicious RCU usage. ]
[40924.102918] 3.10.0-rc7+ #4 Not tainted
[40924.102936] -------------------------------
[40924.102957] include/linux/rcupdate.h:780 rcu_read_lock() used illegally while idle!
[40924.102987] 
other info that might help us debug this:

[40924.103019] 
RCU used illegally from idle CPU!
rcu_scheduler_active = 1, debug_locks = 0
[40924.103059] RCU used illegally from extended quiescent state!
[40924.103084] 1 lock held by trinity-child2/7828:
[40924.103104]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8113e2e8>] __perf_event_overflow+0x108/0x310
[40924.103960] 
stack backtrace:
[40924.105608] CPU: 2 PID: 7828 Comm: trinity-child2 Not tainted 3.10.0-rc7+ #4
[40924.107348]  0000000000000001 ffff8801df29ba90 ffffffff816dfc58 ffff8801df29bac0
[40924.108251]  ffffffff810b5c47 ffff880231947000 0000000000000000 ffff8801df29bbc0
[40924.109152]  0000000000000000 ffff8801df29bb40 ffffffff8113e474 ffffffff8113e2e8
[40924.110059] Call Trace:
[40924.110949]  [<ffffffff816dfc58>] dump_stack+0x19/0x1b
[40924.111848]  [<ffffffff810b5c47>] lockdep_rcu_suspicious+0xe7/0x120
[40924.112752]  [<ffffffff8113e474>] __perf_event_overflow+0x294/0x310
[40924.113654]  [<ffffffff8113e2e8>] ? __perf_event_overflow+0x108/0x310
[40924.114556]  [<ffffffff816f0d40>] ? ftrace_call+0x5/0x2f
[40924.115450]  [<ffffffff8113e541>] perf_swevent_overflow+0x51/0xe0
[40924.116352]  [<ffffffff8113e62f>] perf_swevent_event+0x5f/0x90
[40924.117251]  [<ffffffff8113e769>] perf_tp_event+0x109/0x4f0
[40924.118149]  [<ffffffff8113e90f>] ? perf_tp_event+0x2af/0x4f0
[40924.119049]  [<ffffffff810745b0>] ? __rcu_read_lock+0x20/0x20
[40924.119944]  [<ffffffff8112db5f>] perf_ftrace_function_call+0xbf/0xd0
[40924.120841]  [<ffffffff8110dab5>] ? ftrace_ops_control_func+0x105/0x140
[40924.121743]  [<ffffffff810745b0>] ? __rcu_read_lock+0x20/0x20
[40924.122645]  [<ffffffff81100dee>] ? rcu_eqs_enter_common+0x5e/0x470
[40924.123544]  [<ffffffff8110dab5>] ftrace_ops_control_func+0x105/0x140
[40924.124444]  [<ffffffff810745b0>] ? __rcu_read_lock+0x20/0x20
[40924.125344]  [<ffffffff81100dee>] ? rcu_eqs_enter_common+0x5e/0x470
[40924.126242]  [<ffffffff8110e6a6>] ftrace_ops_list_func+0x156/0x180
[40924.127139]  [<ffffffff816f0d40>] ftrace_call+0x5/0x2f
[40924.128031]  [<ffffffff8110e602>] ? ftrace_ops_list_func+0xb2/0x180
[40924.128932]  [<ffffffff816f0d40>] ? ftrace_call+0x5/0x2f
[40924.129825]  [<ffffffff810745b5>] ? debug_lockdep_rcu_enabled+0x5/0x40
[40924.130723]  [<ffffffff810745b5>] ? debug_lockdep_rcu_enabled+0x5/0x40
[40924.131611]  [<ffffffff81100dee>] ? rcu_eqs_enter_common+0x5e/0x470
[40924.132492]  [<ffffffff8110126a>] rcu_eqs_enter+0x6a/0xb0
[40924.133367]  [<ffffffff81103a73>] rcu_user_enter+0x13/0x20
[40924.134244]  [<ffffffff811459ba>] user_enter+0x6a/0xd0
[40924.135113]  [<ffffffff8100f678>] syscall_trace_leave+0x78/0x140
[40924.135975]  [<ffffffff816f13ef>] int_check_syscall_exit_work+0x34/0x3d


