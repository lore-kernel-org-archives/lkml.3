Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3BLKYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:24:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60979 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab3BLKYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:24:02 -0500
Message-ID: <1360664639.4485.15.camel@laptop>
Subject: Re: [patch v4 06/18] sched: give initial value for runnable avg of
 sched entities.
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:23:59 +0100
In-Reply-To: <1358996820-23036-7-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-7-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
> after a new task forked.
> Otherwise random values of above variables cause mess when do new task
> enqueue:
>     enqueue_task_fair
>         enqueue_entity
>             enqueue_entity_load_avg
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..1743746 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1559,6 +1559,8 @@ static void __sched_fork(struct task_struct *p)
>  #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
>  	p->se.avg.runnable_avg_period = 0;
>  	p->se.avg.runnable_avg_sum = 0;
> +	p->se.avg.decay_count = 0;
> +	p->se.avg.load_avg_contrib = 0;
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));

pjt?

