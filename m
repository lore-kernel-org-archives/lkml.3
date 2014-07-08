Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaGHOrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:47:04 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34794 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaGHOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:47:01 -0400
Date: Tue, 8 Jul 2014 16:46:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 05/17] rcu: remove redundant ACCESS_ONCE()
 from tick_do_timer_cpu
Message-ID: <20140708144653.GE6571@localhost.localdomain>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404772701-8804-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 03:38:09PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> In kernels built with CONFIG_NO_HZ_FULL, tick_do_timer_cpu is constant
> once boot completes.  Thus, there is no need to wrap it in ACCESS_ONCE()
> in code that is built only when CONFIG_NO_HZ_FULL.  This commit therefore
> removes the redundant ACCESS_ONCE().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

ACK, thanks!

> ---
>  kernel/rcu/tree_plugin.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 02ac0fb186b8..5da9f9b3abc9 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2844,7 +2844,7 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
>  static void rcu_bind_gp_kthread(void)
>  {
>  #ifdef CONFIG_NO_HZ_FULL
> -	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
> +	int cpu = tick_do_timer_cpu;
>  
>  	if (cpu < 0 || cpu >= nr_cpu_ids)
>  		return;
> -- 
> 1.8.1.5
> 
