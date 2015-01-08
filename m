Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbbAHJln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:41:43 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53349 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbAHJlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:41:40 -0500
Date: Thu, 8 Jan 2015 10:41:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
Message-ID: <20150108094102.GD29390@twins.programming.kicks-ass.net>
References: <20150107173215.GA897@linux.vnet.ibm.com>
 <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 09:32:20AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit prevents random compiler optimizations by applying
> ACCESS_ONCE() to lockless accesses.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcu/tree_plugin.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 3ec85cb5d544..d59913ef8360 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1127,7 +1127,8 @@ static int rcu_boost(struct rcu_node *rnp)
>  	struct task_struct *t;
>  	struct list_head *tb;
>  
> -	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
> +	if (ACCESS_ONCE(rnp->exp_tasks) == NULL &&
> +	    ACCESS_ONCE(rnp->boost_tasks) == NULL)
>  		return 0;  /* Nothing left to boost. */

Didn't we just obsolete ACCESS_ONCE with that {READ,WRITE}_ONCE stuff?
