Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaDXOSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:18:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:37422 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaDXOSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:18:32 -0400
Date: Thu, 24 Apr 2014 16:18:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, efault@gmx.de, wangyun@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: Re: [PATCH V5 3/8] sched: remove source_load and target_load
Message-ID: <20140424141826.GU11096@twins.programming.kicks-ass.net>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
 <1397616209-27275-4-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397616209-27275-4-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:43:24AM +0800, Alex Shi wrote:
> We have no load_idx any more, so source/target_load always return the
> same value as weighted_cpuload. So we can remove these 2 functions.

That's just not true:

> -/*
> - * Return a low guess at the load of a migration-source cpu weighted
> - * according to the scheduling class and "nice" value.
> - *
> - * We want to under-estimate the load of migration sources, to
> - * balance conservatively.
> - */
> -static unsigned long source_load(int cpu)
> -{
> -	struct rq *rq = cpu_rq(cpu);
> -	unsigned long total = weighted_cpuload(cpu);
> -
> -	if (!sched_feat(LB_BIAS))
> -		return total;
> -
> -	return min(rq->cpu_load, total);
> -}
> -
> -/*
> - * Return a high guess at the load of a migration-target cpu weighted
> - * according to the scheduling class and "nice" value.
> - */
> -static unsigned long target_load(int cpu)
> -{
> -	struct rq *rq = cpu_rq(cpu);
> -	unsigned long total = weighted_cpuload(cpu);
> -
> -	if (!sched_feat(LB_BIAS))
> -		return total;
> -
> -	return max(rq->cpu_load, total);
> -}


