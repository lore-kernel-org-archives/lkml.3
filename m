Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab3KOKH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:07:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48638 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab3KOKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:07:19 -0500
Date: Fri, 15 Nov 2013 11:07:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH TRIVIAL] sched: Fix comments in struct root_domain
Message-ID: <20131115100715.GE2965@twins.programming.kicks-ass.net>
References: <1384505917-18366-1-git-send-email-kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384505917-18366-1-git-send-email-kamalesh@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 02:28:37PM +0530, Kamalesh Babulal wrote:
> Move comments related to RT overload, above rto_count.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
>  kernel/sched/sched.h | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 88c85b21d633..ca452e63f203 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -372,19 +372,18 @@ struct rt_rq {
>   * fully partitioning the member cpus from any other cpuset. Whenever a new
>   * exclusive cpuset is created, we also create and attach a new root-domain
>   * object.
> - *
>   */
>  struct root_domain {
>  	atomic_t refcount;
> -	atomic_t rto_count;
> -	struct rcu_head rcu;
> -	cpumask_var_t span;
> -	cpumask_var_t online;

The span and online mask aren't actually related to the overload muck.

>  
>  	/*
>  	 * The "RT overload" flag: it gets set if a CPU has more than
>  	 * one runnable RT task.
>  	 */
> +	atomic_t rto_count;
> +	struct rcu_head rcu;
> +	cpumask_var_t span;
> +	cpumask_var_t online;
>  	cpumask_var_t rto_mask;
>  	struct cpupri cpupri;
>  };
> -- 
> 1.8.4.474.g128a96c
> 
