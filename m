Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab3CHNbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:31:05 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:59357 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab3CHNbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:31:03 -0500
Date: Fri, 8 Mar 2013 14:30:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michel Lespinasse <walken@google.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: make sched_group_{get,set}_rt_{runtime,period}
 functions static
Message-ID: <20130308133059.GA27992@gmail.com>
References: <20130308021013.GA11284@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308021013.GA11284@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michel Lespinasse <walken@google.com> wrote:

> Just a tiny cleanup I did while I was looking through scheduler code
> doing a tasklist_lock change. Please consider applying if you find it
> appropriate.
> 
> ------------------------------8<-----------------------------------------
> sched: make sched_group_{get,set}_rt_{runtime,period} functions static
> 
> These functions, as well as sched_rt_can_attach(), used to be public so
> that kernel/user.c could use them; however this use has now disappeared
> so that these functions can be made static again.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  include/linux/sched.h |  9 ---------
>  kernel/sched/core.c   | 11 ++++++-----
>  2 files changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d35d2b6ddbfb..ac8dbca5ea15 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2694,15 +2694,6 @@ extern void sched_move_task(struct task_struct *tsk);
>  extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
>  extern unsigned long sched_group_shares(struct task_group *tg);
>  #endif
> -#ifdef CONFIG_RT_GROUP_SCHED
> -extern int sched_group_set_rt_runtime(struct task_group *tg,
> -				      long rt_runtime_us);
> -extern long sched_group_rt_runtime(struct task_group *tg);
> -extern int sched_group_set_rt_period(struct task_group *tg,
> -				      long rt_period_us);
> -extern long sched_group_rt_period(struct task_group *tg);
> -extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
> -#endif
>  #endif /* CONFIG_CGROUP_SCHED */

Makes sense - but Li Zefan has beaten you to it by a few days:

  25cc7da7e633 sched: Move group scheduling functions out of include/linux/sched.h

Which can be found in the latest scheduler development tree, queued up for v3.10:

  git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master    # or sched/core

Thanks,

	Ingo

