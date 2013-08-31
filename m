Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3HaTVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:21:46 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60598 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3HaTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:21:45 -0400
Date: Sat, 31 Aug 2013 12:21:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 08/18 v2] ftrace/rcu: Do not trace
 debug_lockdep_rcu_enabled()
Message-ID: <20130831192101.GG3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051701.767976027@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051701.767976027@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-8236-0000-0000-0000014F3DED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:25AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The function debug_lockdep_rcu_enabled() is part of the RCU lockdep
> debugging, and is called very frequently. I found that if I enable
> a lot of debugging and run the function graph tracer, this
> function can cause a live lock of the system.
> 
> We don't usually trace lockdep infrastructure, no need to trace
> this either.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Or I can just take it, if you would rather.  (If so, 3.12 or 3.13?)

> ---
>  kernel/rcupdate.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index cce6ba8..4f20c6c 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -122,7 +122,7 @@ struct lockdep_map rcu_sched_lock_map =
>  	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
>  EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
> 
> -int debug_lockdep_rcu_enabled(void)
> +int notrace debug_lockdep_rcu_enabled(void)
>  {
>  	return rcu_scheduler_active && debug_locks &&
>  	       current->lockdep_recursion == 0;
> -- 
> 1.7.10.4
> 
> 

