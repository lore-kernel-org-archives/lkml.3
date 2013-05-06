Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab3EFICP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:02:15 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40049 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3EFICN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:02:13 -0400
MIME-Version: 1.0
In-Reply-To: <1367804711-30308-3-git-send-email-alex.shi@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-3-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 01:01:41 -0700
Message-ID: <CAPM31R+oBDRF4geM451-ySCtkU1NpqFT_R1mtB95jV-pnLBimQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] sched: remove SMP cover for runnable variables in cfs_rq
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
> The following variables were covered under CONFIG_SMP in struct cfs_rq.
> but similar runnable variables work for UP in struct rq and task_group.
> like rq->avg, task_group->load_avg.
> So move them out, they also can work with UP.

Is there a proposed use-case for UP?  My apologies if I missed it in
an alternate patch.

It would seem the only possibly useful thing there would the the
per-rq average for p-state selection; but we can get that without the
per-entity values already.

>
>          u64 runnable_load_avg, blocked_load_avg;
>          atomic64_t decay_counter, removed_load;
>          u64 last_decay;
>
>          u32 tg_runnable_contrib;
>          u64 tg_load_contrib;
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/sched.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 7f36024f..1a02b90 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -226,7 +226,6 @@ struct cfs_rq {
>         unsigned int nr_spread_over;
>  #endif
>
> -#ifdef CONFIG_SMP
>         /*
>          * CFS Load tracking
>          * Under CFS, load is tracked on a per-entity basis and aggregated up.
> @@ -242,6 +241,7 @@ struct cfs_rq {
>         u64 tg_load_contrib;
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>
> +#ifdef CONFIG_SMP
>         /*
>          *   h_load = weight * f(tg)
>          *
> --
> 1.7.12
>
