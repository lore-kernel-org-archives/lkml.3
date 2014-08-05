Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaHEVM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:12:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:22378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaHEVMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:12:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,807,1400050800"; 
   d="scan'208";a="572182881"
Date: Wed, 6 Aug 2014 05:12:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [microcode/load_module] WARNING: CPU: 0 PID: 1444 at
 kernel/sched/core.c:7094 __might_sleep+0x51/0x16f()
Message-ID: <20140805211224.GA13480@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Here is a microcode/load_module error triggered by debug check commit
64c2181bc433b17f04da8fe8592aa83cceac9606 ("sched: Debug nested sleeps"):

[    6.010476] microcode: CPU0 sig=0x106a3, pf=0x1, revision=0x1
[    6.011896] microcode: CPU1 sig=0x106a3, pf=0x1, revision=0x1
[    6.020554] ------------[ cut here ]------------
[    6.021988] WARNING: CPU: 0 PID: 1444 at kernel/sched/core.c:7094 __might_sleep+0x51/0x16f()
[    6.024909] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff81111e4c>] prepare_to_wait_event+0xb2/0xee
[    6.026998] Modules linked in: microcode(+)
[    6.027998] CPU: 0 PID: 1444 Comm: modprobe Not tainted 3.16.0-02034-gf5d04af #1
[    6.029603] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    6.030674]  0000000000000000 ffff88003da2bd00 ffffffff819c7cb6 ffff88003da2bd48
[    6.032577]  ffff88003da2bd38 ffffffff810e1dd0 ffffffff810ff665 ffff88003d91b7e0
[    6.034417]  ffffffff81cd5c89 0000000000000061 0000000000000000 ffff88003da2bd98
[    6.036236] Call Trace:
[    6.036908]  [<ffffffff819c7cb6>] dump_stack+0x4d/0x66
[    6.037894]  [<ffffffff810e1dd0>] warn_slowpath_common+0x7f/0x98
[    6.038601] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.040761]  [<ffffffff810ff665>] ? __might_sleep+0x51/0x16f
[    6.041861]  [<ffffffff810e1e35>] warn_slowpath_fmt+0x4c/0x4e
[    6.043034]  [<ffffffff811c06d7>] ? __vmalloc_node_range+0x18d/0x1f1
[    6.044270]  [<ffffffff81141bf6>] ? module_alloc_update_bounds+0x14/0x5f
[    6.045458]  [<ffffffff81111e4c>] ? prepare_to_wait_event+0xb2/0xee
[    6.046592]  [<ffffffff81111e4c>] ? prepare_to_wait_event+0xb2/0xee
[    6.048258]  [<ffffffff810ff665>] __might_sleep+0x51/0x16f
[    6.049501]  [<ffffffff819cda15>] mutex_lock+0x20/0x42
[    6.050601]  [<ffffffff811403c0>] finished_loading+0x19/0x63
[    6.051823]  [<ffffffff8114217d>] load_module+0x522/0x1f0a
[    6.053086]  [<ffffffff81492e1b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[    6.054498]  [<ffffffff819d0564>] ? retint_restore_args+0x13/0x13
[    6.055607]  [<ffffffff81111f6c>] ? wait_woken+0x69/0x69
[    6.056645]  [<ffffffff81143c2f>] SyS_init_module+0xca/0xd9
[    6.057637]  [<ffffffff819cfa29>] system_call_fastpath+0x16/0x1b
[    6.058751] ---[ end trace ee9cd23bc6a36c85 ]---
[    6.098452] ------------[ cut here ]------------

Thanks,
Fengguang
