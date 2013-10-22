Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3JVWSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:18:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34125 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3JVWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:18:20 -0400
Date: Wed, 23 Oct 2013 00:18:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/3] sched: Fix asymmetric scheduling for POWER7
Message-ID: <20131022221808.GK2490@laptop.programming.kicks-ass.net>
References: <20131021114002.13291.31478.stgit@drishya>
 <20131021114452.13291.19947.stgit@drishya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131021114452.13291.19947.stgit@drishya>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:14:52PM +0530, Vaidyanathan Srinivasan wrote:
>  kernel/sched/fair.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 12f0eab..828ed97 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5821,8 +5821,8 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  				goto need_kick_unlock;
>  		}
>  
> -		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
> -		    && (cpumask_first_and(nohz.idle_cpus_mask,
> +		if (sd->flags & SD_ASYM_PACKING &&
> +			(cpumask_first_and(nohz.idle_cpus_mask,
>  					  sched_domain_span(sd)) < cpu))
>  			goto need_kick_unlock;
>  
> 

Ahh, so here you remove the nr_busy usage.. this patch should really go
before the first one that makes this all weird and funny.


