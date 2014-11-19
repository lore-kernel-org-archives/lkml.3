Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaKSTIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:08:31 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60138 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbaKSTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:08:29 -0500
Date: Wed, 19 Nov 2014 11:08:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@fedoraproject.org>, linux-kernel@vger.kernel.org
Subject: Re: rcu warning caused by [sched: Fix race between task_group and
 sched_task_group]
Message-ID: <20141119190824.GM5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141119100946.GB4163@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119100946.GB4163@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111919-0029-0000-0000-000005BA0224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:09:46AM +0100, Heiko Carstens wrote:
> Hi Kirill,
> 
> the problem below has already been reported here:
> https://lkml.org/lkml/2014/11/11/505
> 
> but seems there is still no fix available upstream?
> Would be good to have it soon, since this basically renders lockdep unusable.

This one fixes this bug for me:

https://lkml.org/lkml/2014/11/4/613

								Thanx, Paul

> [    0.173906] ===============================
> [    0.173907] [ INFO: suspicious RCU usage. ]
> [    0.173909] 3.18.0-rc5 #15 Not tainted
> [    0.173909] -------------------------------
> [    0.173910] kernel/sched/core.c:7449 suspicious rcu_dereference_check() usage!
> [    0.173912] 
>                other info that might help us debug this:
> [    0.173913] 
>                rcu_scheduler_active = 1, debug_locks = 0
> [    0.173914] 2 locks held by swapper/0/0:
> [    0.173915]  #0:  (&p->pi_lock){......}, at: [<000000000017baae>] task_rq_lock+0x4e/0xf8
> [    0.173925]  #1:  (&rq->lock){......}, at: [<000000000017bad6>] task_rq_lock+0x76/0xf8
> [    0.173928] 
> [    0.173930] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc5 #15
> [    0.173931]        0000000000b9fb70 0000000000b9fb80 0000000000000002 0000000000000000 
>                       0000000000b9fc10 0000000000b9fb88 0000000000b9fb88 0000000000112638 
>                       0000000000000000 00000000009d5b8c 00000000009be240 000000000000000b 
>                       0000000000b9fbd0 0000000000b9fb70 0000000000000000 0000000000000000 
>                       0000000000000000 0000000000112638 0000000000b9fb70 0000000000b9fbd0 
> [    0.173944] Call Trace:
> [    0.173947] ([<000000000011251c>] show_trace+0xf4/0x158)
> [    0.173949]  [<00000000001125ea>] show_stack+0x6a/0xe8
> [    0.173952]  [<0000000000807ac2>] dump_stack+0x82/0xb0
> [    0.173955]  [<000000000018700a>] sched_move_task+0x20a/0x210
> [    0.173959]  [<0000000000203bf0>] cgroup_post_fork+0x60/0x148
> [    0.173963]  [<000000000014c5b8>] copy_process.part.46+0xfe8/0x1bc8
> [    0.173964]  [<000000000014d39c>] do_fork+0x104/0x7d8
> [    0.173965]  [<000000000014dab6>] kernel_thread+0x46/0x58
> [    0.173968]  [<00000000007fe890>] rest_init+0x38/0x170
> [    0.173971]  [<0000000000c45b40>] start_kernel+0x460/0x470
> [    0.173972]  [<0000000000100020>] _stext+0x20/0x80
> [    0.173973] INFO: lockdep is turned off.
> 
> caused by (bisected):
> 
> commit eeb61e53ea19be0c4015b00b2e8b3b2185436f2b
> Author: Kirill Tkhai <ktkhai@parallels.com>
> Date:   Mon Oct 27 14:18:25 2014 +0400
> 
>     sched: Fix race between task_group and sched_task_group
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

