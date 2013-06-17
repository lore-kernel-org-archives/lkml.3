Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3FQJjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:39:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38569 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3FQJjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:39:01 -0400
Date: Mon, 17 Jun 2013 11:38:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 9/9] sched/tg: remove blocked_load_avg in balance
Message-ID: <20130617093838.GN3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-10-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370589652-24549-10-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:20:52PM +0800, Alex Shi wrote:
> blocked_load_avg sometime is too heavy and far bigger than runnable load
> avg, that make balance make wrong decision. So remove it.
> 
> Changlong tested this patch, found ltp cgroup stress testing get better
> performance: https://lkml.org/lkml/2013/5/23/65
> ---
> 3.10-rc1          patch1-7         patch1-8
> duration=764   duration=754   duration=750
> duration=764   duration=754   duration=751
> duration=763   duration=755   duration=751
> 
> duration means the seconds of testing cost.
> ---
> 
> And Jason also tested this patchset on his 8 sockets machine:
> https://lkml.org/lkml/2013/5/29/673
> ---
> When using a 3.10-rc2 tip kernel with patches 1-8, there was about a 40%
> improvement in performance of the workload compared to when using the
> vanilla 3.10-rc2 tip kernel with no patches. When using a 3.10-rc2 tip
> kernel with just patches 1-7, the performance improvement of the
> workload over the vanilla 3.10-rc2 tip kernel was about 25%.
> ---
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Tested-by: Changlong Xie <changlongx.xie@intel.com>
> Tested-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3aa1dc0..985d47e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1358,7 +1358,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>  	struct task_group *tg = cfs_rq->tg;
>  	s64 tg_contrib;
>  
> -	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> +	tg_contrib = cfs_rq->runnable_load_avg;
>  	tg_contrib -= cfs_rq->tg_load_contrib;
>  
>  	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {

PJT ping! ;-)
