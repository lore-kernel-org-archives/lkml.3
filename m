Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaBYQXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:23:03 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44838 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaBYQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:23:00 -0500
Date: Tue, 25 Feb 2014 21:52:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, james.hogan@imgtec.com, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: Re: [PATCH 02/11] sched: remove rq->cpu_load[load_idx] array
Message-ID: <20140225162252.GA13532@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1393293054-11378-1-git-send-email-alex.shi@linaro.org>
 <1393293054-11378-3-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1393293054-11378-3-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022516-8878-0000-0000-00000B0AF477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> -/**
> - * get_sd_load_idx - Obtain the load index for a given sched domain.
> - * @sd: The sched_domain whose load_idx is to be obtained.
> - * @idle: The idle status of the CPU for whose sd load_idx is obtained.
> - *
> - * Return: The load index.
> - */
> -static inline int get_sd_load_idx(struct sched_domain *sd,
> -					enum cpu_idle_type idle)
> -{
> -	int load_idx;
> -
> -	switch (idle) {
> -	case CPU_NOT_IDLE:
> -		load_idx = sd->busy_idx;
> -		break;
> -
> -	case CPU_NEWLY_IDLE:
> -		load_idx = sd->newidle_idx;
> -		break;
> -	default:
> -		load_idx = sd->idle_idx;
> -		break;
> -	}
> -
> -	return load_idx;
> -}
> -

Since the last caller to get_sd_load_idx(), does it make sense to remove
the function definition for get_sd_load_idx() in the previous patch itself?

Or

> @@ -5903,13 +5868,11 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>  	struct sched_domain *child = env->sd->child;
>  	struct sched_group *sg = env->sd->groups;
>  	struct sg_lb_stats tmp_sgs;
> -	int load_idx, prefer_sibling = 0;
> +	int prefer_sibling = 0;
>  
>  	if (child && child->flags & SD_PREFER_SIBLING)
>  		prefer_sibling = 1;
>  
> -	load_idx = 0;
> -
>  	do {
>  		struct sg_lb_stats *sgs = &tmp_sgs;
>  		int local_group;


The single line change in the previous patch gets removed here so why
not club them.

-- 
Thanks and Regards
Srikar Dronamraju

