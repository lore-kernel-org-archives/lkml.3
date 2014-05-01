Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaEAAlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:41:07 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:64111 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750810AbaEAAlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:41:05 -0400
Date: Wed, 30 Apr 2014 20:41:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4 v2] rcu: Have the RCU tracepoints use the
 tracepoint_string infrastructure
Message-ID: <20140430204102.28fa247a@gandalf.local.home>
In-Reply-To: <5361795C.2040205@oracle.com>
References: <20130802023933.677590002@goodmis.org>
	<20130802024222.969067017@goodmis.org>
	<5361795C.2040205@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 18:29:48 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Hi Steven,
> 
> It seems that this patch is causing the following for me on -next kernel:

Really? This patch has been in the kernel since 3.12. Why would it
break something in linux-next. Perhaps something was added to
linux-next that doesn't like this patch?

-- Steve

> 
> [ 1202.780629] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 1202.782056] Dumping ftrace buffer:
> [ 1202.783243]    (ftrace buffer empty)
> [ 1202.784253] Modules linked in:
> [ 1202.784778] CPU: 7 PID: 65 Comm: rcuos/0 Tainted: G        W     3.15.0-rc3-next-201
> 40429-sasha-00015-g7c7e0a7-dirty #427
> [ 1202.787872] task: ffff880035c63000 ti: ffff880035c5c000 task.ti: ffff880035c5c000
> [ 1202.788722] RIP: rcu_note_context_switch (include/trace/events/rcu.h:20 kernel/rcu/tree.c:216)
> [ 1202.790083] RSP: 0018:ffff880035c5dcc8  EFLAGS: 00010286
> [ 1202.790468] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880034608de8 RCX: 0000000000000001
> [ 1202.790468] RDX: 0000000000000000 RSI: ffffffffa56dd9ef RDI: 6b6b6b6b6b6b6b6b
> [ 1202.790468] RBP: ffff880035c5dce8 R08: 0000000000000000 R09: 0000000000000000
> [ 1202.790468] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffa56dd9ef
> [ 1202.790468] R13: 0000000000000007 R14: ffffffffa6aca2c3 R15: ffff880036dd0080
> [ 1202.790468] FS:  0000000000000000(0000) GS:ffff8801ecc00000(0000) knlGS:0000000000000000
> [ 1202.790468] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1202.790468] CR2: 0000000000000004 CR3: 0000000025e2d000 CR4: 00000000000006a0
> [ 1202.790468] DR0: 00000000006de000 DR1: 00000000006de000 DR2: 0000000000000000
> [ 1202.790468] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> [ 1202.790468] Stack:
> [ 1202.790468]  0000000000000000 ffff880036dd01f0 ffff8801ecdd7840 0000000000000007
> [ 1202.790468]  ffff880035c5dd68 ffffffffa4571dee ffff880035c5dd08 ffff880036dd01f0
> [ 1202.790468]  ffff880035c5dfd8 00000000001d7840 00000000001d7840 00000000001d7840
> [ 1202.790468] Call Trace:
> [ 1202.790468] __schedule (arch/x86/include/asm/preempt.h:22 kernel/sched/core.c:2585 kernel/sched/core.c:2678)
> [ 1202.790468] ? prepare_to_wait_event (kernel/sched/wait.c:218 kernel/sched/wait.c:216)
> [ 1202.790468] schedule (kernel/sched/core.c:2765)
> [ 1202.790468] rcu_nocb_kthread (kernel/rcu/tree_plugin.h:2234 (discriminator 9))
> [ 1202.790468] ? rcu_nocb_kthread (kernel/rcu/rcu.h:84 kernel/rcu/tree_plugin.h:2280)
> [ 1202.790468] ? preempt_count_sub (kernel/sched/core.c:2541)
> [ 1202.790468] ? bit_waitqueue (kernel/sched/wait.c:291)
> [ 1202.790468] ? rcu_cpu_notify (kernel/rcu/tree_plugin.h:2220)
> [ 1202.790468] kthread (kernel/kthread.c:210)
> [ 1202.790468] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 1202.790468] ret_from_fork (arch/x86/kernel/entry_64.S:552)
> [ 1202.790468] ? kthread_create_on_node (kernel/kthread.c:176)
> [ 1202.790468] Code: 65 ff 0c 25 a0 da 00 00 0f 84 fa 00 00 00 eb 28 0f 1f 84 00 00 00 00 00 48 8b 03 0f 1f 44 00 00 48 8b 7b 08 4c 89 e6 48 83 c3 10 <ff> d0 48 8b 03 48 85 c0 75 eb eb c9 90 44 89 ef e8 e8 71 ff ff
> [ 1202.790468] RIP rcu_note_context_switch (include/trace/events/rcu.h:20 kernel/rcu/tree.c:216)
> [ 1202.790468]  RSP <ffff880035c5dcc8>
> 
> 
> Thanks,
> Sasha

