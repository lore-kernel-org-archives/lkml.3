Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbaGOWxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:53:20 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34291 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaGOWxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:53:17 -0400
Date: Tue, 15 Jul 2014 15:53:13 -0700
From: josh@joshtriplett.org
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
Message-ID: <20140715225313.GB24290@cloud>
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
 <1405463509-2468-2-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405463509-2468-2-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:31:48PM -0400, Pranith Kumar wrote:
> This commit removes a stale comment in rcu/tree.c.
> FYI, an updated comment exists a few lines below this.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

In general, when removing a stale comment, I'd suggest explaining why
the comment is stale.  Was code removed without removing the
corresponding comment, or was code changed such that the comment no
longer applies, or...?

- Josh Triplett

>  kernel/rcu/tree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index a1abaa8..e67246e 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2211,8 +2211,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
>  	/* Adjust any no-longer-needed kthreads. */
>  	rcu_boost_kthread_setaffinity(rnp, -1);
>  
> -	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
> -
>  	/* Exclude any attempts to start a new grace period. */
>  	mutex_lock(&rsp->onoff_mutex);
>  	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
> -- 
> 1.9.1
> 
