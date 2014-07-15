Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaGOWyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:54:45 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47169 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbaGOWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:54:42 -0400
Date: Tue, 15 Jul 2014 15:54:39 -0700
From: josh@joshtriplett.org
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] rcu: Use rcu_num_nodes instead of NUM_RCU_NODES
Message-ID: <20140715225439.GC24290@cloud>
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com>
 <1405463509-2468-3-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405463509-2468-3-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 06:31:49PM -0400, Pranith Kumar wrote:
> NUM_RCU_NODES is set at build time and is usually a huge number. We calculate the
> actual number of rcu nodes necessary at boot time based on nr_cpu_ids in
> rcu_init_geometry() and store it in rcu_num_nodes. We should use this variable
> instead of NUM_RCU_NODES.
> 
> This commit changes all such uses of NUM_RCU_NODES to rcu_num_nodes.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

(On a separate note, these names really need to provide clearer
explanations of the difference, grumble.  Case and word order explains
little.)

>  kernel/rcu/tree_plugin.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index cedb020..17ccb62 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -46,6 +46,8 @@ static bool __read_mostly rcu_nocb_poll;    /* Offload kthread are to poll. */
>  static char __initdata nocb_buf[NR_CPUS * 5];
>  #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
>  
> +extern int rcu_num_nodes;
> +
>  /*
>   * Check the RCU kernel configuration parameters and print informative
>   * messages about anything out of the ordinary.  If you like #ifdef, you
> @@ -885,7 +887,7 @@ void synchronize_rcu_expedited(void)
>  	/* Snapshot current state of ->blkd_tasks lists. */
>  	rcu_for_each_leaf_node(rsp, rnp)
>  		sync_rcu_preempt_exp_init(rsp, rnp);
> -	if (NUM_RCU_NODES > 1)
> +	if (rcu_num_nodes > 1)
>  		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
>  
>  	put_online_cpus();
> @@ -1475,7 +1477,7 @@ static void __init rcu_spawn_boost_kthreads(void)
>  	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
>  	rnp = rcu_get_root(rcu_state_p);
>  	(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
> -	if (NUM_RCU_NODES > 1) {
> +	if (rcu_num_nodes > 1) {
>  		rcu_for_each_leaf_node(rcu_state_p, rnp)
>  			(void)rcu_spawn_one_boost_kthread(rcu_state_p, rnp);
>  	}
> -- 
> 1.9.1
> 
