Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaFZTjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:39:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36658 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFZTja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:39:30 -0400
Date: Thu, 26 Jun 2014 12:39:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH 3/5] kernel/rcu/tree_plugin.h:990 fix a sparse warning
Message-ID: <20140626193926.GZ4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
 <1402519183-12752-4-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402519183-12752-4-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062619-0928-0000-0000-000002F5508F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:39:41PM -0400, Pranith Kumar wrote:
> kernel/rcu/tree_plugin.h:990:13: warning: context imbalance in 'rcu_report_unblock_qs_rnp' - unexpected unlock
> 
> by annotating the function with __releases()
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Hearing no objections, I have queued this for 3.17.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 0c955d9..9f85469 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -988,6 +988,7 @@ static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp)
> 
>  /* Because preemptible RCU does not exist, no quieting of tasks. */
>  static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
> +	__releases(rnp->lock)
>  {
>  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  }
> -- 
> 1.9.1
> 

