Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaGWM24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:28:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49029 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaGWM2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:28:54 -0400
Date: Wed, 23 Jul 2014 05:28:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/16] rcu: Check for a nocb cpu before trying to spawn
 nocb threads
Message-ID: <20140723122849.GN11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-16-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406092194-13004-16-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072312-0928-0000-0000-0000039B2B99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 01:09:52AM -0400, Pranith Kumar wrote:
> This commit tries to spawn nocb kthreads only when the CPU is marked as a nocb
> cpu. This is a minor optimization.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

This only happens once at boot time, so I am happier with the single check
at the bottom.  So sorry, but no.

							Thanx, Paul

> ---
>  kernel/rcu/tree_plugin.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 541c776..8abff0a 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1490,7 +1490,8 @@ static void rcu_prepare_kthreads(int cpu)
>  		return;
> 
>  	rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
> -	rcu_spawn_all_nocb_kthreads(cpu);
> +	if (rcu_is_nocb_cpu(cpu))
> +		rcu_spawn_all_nocb_kthreads(cpu);
>  }
> 
>  #else /* #ifdef CONFIG_RCU_BOOST */
> -- 
> 2.0.0.rc2
> 

