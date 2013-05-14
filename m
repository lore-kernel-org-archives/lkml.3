Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3ENIdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:33:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46719
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756592Ab3ENIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:33:49 -0400
Date: Tue, 14 May 2013 10:31:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [patch v6 8/8] sched: remove blocked_load_avg in tg
Message-ID: <20130514083148.GD15942@dyad.programming.kicks-ass.net>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
 <1368199049-2798-9-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368199049-2798-9-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:17:29PM +0800, Alex Shi wrote:
> blocked_load_avg sometime is too heavy and far bigger than runnable load
> avg. that make balance make wrong decision. So better don't consider it.

Would you happen to have an example around that illustrates this? 

Also, you've just changed the cgroup balancing -- did you run any tests on that?

> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 91e60ac..75c200c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1339,7 +1339,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>  	struct task_group *tg = cfs_rq->tg;
>  	s64 tg_contrib;
>  
> -	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> +	tg_contrib = cfs_rq->runnable_load_avg;
>  	tg_contrib -= cfs_rq->tg_load_contrib;
>  
>  	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> -- 
> 1.7.5.4
> 
