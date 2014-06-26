Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaFZTjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:39:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44520 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaFZTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:39:18 -0400
Date: Thu, 26 Jun 2014 12:39:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH 2/5] kernel/rcu/tree_plugin.h:1494 fix a sparse
 warning
Message-ID: <20140626193912.GY4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-3-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402519183-12752-3-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062619-1542-0000-0000-000002DE3C6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:39:40PM -0400, Pranith Kumar wrote:
> kernel/rcu/tree_plugin.h:1494:13: warning: context imbalance in 'rcu_initiate_boost' - unexpected unlock
> 
> by annotating the function with releases()
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Hearing no objections, I have queued this for 3.17.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index cbc2c45..0c955d9 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1256,6 +1256,7 @@ static int rcu_boost_kthread(void *arg)
>   * about it going away.
>   */
>  static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
> +	__releases(rnp->lock)
>  {
>  	struct task_struct *t;
> 
> @@ -1491,6 +1492,7 @@ static void rcu_prepare_kthreads(int cpu)
>  #else /* #ifdef CONFIG_RCU_BOOST */
> 
>  static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
> +	__releases(rnp->lock)
>  {
>  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  }
> -- 
> 1.9.1
> 

