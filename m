Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbbAXVQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:16:49 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:38383 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbAXVQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:16:47 -0500
Date: Sat, 24 Jan 2015 13:16:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/32] rcu: use %*pb[l] to print bitmaps including
 cpumasks and nodemasks
Message-ID: <20150124211642.GC9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
 <1422108218-25398-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422108218-25398-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012421-0025-0000-0000-000008082049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 09:03:20AM -0500, Tejun Heo wrote:
> printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
> and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
> respectively which can be used to generate the two printf arguments
> necessary to format the specified cpu/nodemask.
> 
> This patch is dependent on the following two patches.
> 
>  lib/vsprintf: implement bitmap printing through '%*pb[l]'
>  cpumask, nodemask: implement cpumask/nodemask_pr_args()
> 
> Please wait till the forementioned patches are merged to mainline
> before applying to subsystem trees.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Nice!!!  I would be happy to take these, if you would like.  If so, please
let me know when the two patches above hit mainline.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 3ec85cb..26e04cf 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -53,7 +53,6 @@ DEFINE_PER_CPU(char, rcu_cpu_has_work);
>  static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
>  static bool have_rcu_nocb_mask;	    /* Was rcu_nocb_mask allocated? */
>  static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
> -static char __initdata nocb_buf[NR_CPUS * 5];
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
> 
>  /*
> @@ -2513,8 +2512,8 @@ void __init rcu_init_nohz(void)
>  		cpumask_and(rcu_nocb_mask, cpu_possible_mask,
>  			    rcu_nocb_mask);
>  	}
> -	cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
> -	pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
> +	pr_info("\tOffload RCU callbacks from CPUs: %*pbl.\n",
> +		cpumask_pr_args(rcu_nocb_mask));
>  	if (rcu_nocb_poll)
>  		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
> 
> -- 
> 2.1.0
> 

