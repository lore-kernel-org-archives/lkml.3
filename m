Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3EFGXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 02:23:38 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45298 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3EFGXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 02:23:37 -0400
Message-ID: <51872D7F.30909@linux.vnet.ibm.com>
Date: Mon, 06 May 2013 09:41:43 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [PATCH v5 2/7] sched: remove SMP cover for runnable variables
 in cfs_rq
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-3-git-send-email-alex.shi@intel.com>
In-Reply-To: <1367804711-30308-3-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050606-6102-0000-0000-000003740A4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

You might want to do the below for struct sched_entity also?
AFAIK,struct sched_entity has struct sched_avg under CONFIG_SMP.

Regards
Preeti U Murthy

On 05/06/2013 07:15 AM, Alex Shi wrote:
> The following variables were covered under CONFIG_SMP in struct cfs_rq.
> but similar runnable variables work for UP in struct rq and task_group.
> like rq->avg, task_group->load_avg.
> So move them out, they also can work with UP.
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
>  	unsigned int nr_spread_over;
>  #endif
> 
> -#ifdef CONFIG_SMP
>  	/*
>  	 * CFS Load tracking
>  	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
> @@ -242,6 +241,7 @@ struct cfs_rq {
>  	u64 tg_load_contrib;
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
> 
> +#ifdef CONFIG_SMP
>  	/*
>  	 *   h_load = weight * f(tg)
>  	 *
> 

