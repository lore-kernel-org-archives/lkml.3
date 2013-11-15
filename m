Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3KOB24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:28:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:18897 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754156Ab3KOB2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:28:46 -0500
Date: Thu, 14 Nov 2013 20:28:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] tracing: Updates for 3.13
Message-ID: <20131115012843.GA12548@home.goodmis.org>
References: <20131111201422.01723f5a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111201422.01723f5a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Just making sure that you see my pull request and I'm hoping that I didn't
end up in your spam folder again.

-- Steve

On Mon, Nov 11, 2013 at 08:14:22PM -0500, Steven Rostedt wrote:
> 
> Linus,
> 
> This batch of changes is mostly clean ups and small bug fixes.
> The only real feature that was added this release is from Namhyung Kim,
> who introduced "set_graph_notrace" filter that lets you run the function
> graph tracer and not trace particular functions and their call chain.
> 
> Tom Zanussi added some updates to the ftrace multibuffer tracing that
> made it more consistent with the top level tracing.
> 
> One of the fixes for perf function tracing required an API change in
> RCU; the addition of "rcu_is_watching()". As Paul McKenney is pushing
> that change in this release too, he gave me a branch that included
> all the changes to get that working, and I pulled that into my tree
> in order to complete the perf function tracing fix.
> 
> 
> Please pull the latest trace-3.13 tree, which can be found at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> trace-3.13
> 
> Tag SHA1: 63324be28450067b875cd74c07b42e8d389b533c
> Head SHA1: 3a81a5210b7d33bb6d836b4c4952a54166a336f3
> 
> 
> Cody P Schafer (2)
>       trace/trace_stat: use rbtree postorder iteration helper instead of opencoding
>       tracing: Open tracer when ftrace_dump_on_oops is used
> 
> Geyslan G. Bem (2)
>       tracing: Add helper function tracing_is_disabled()
>       tracing: Do not assign filp->private_data to freed memory
> 
> Jamie Iles (1)
>       recordmcount.pl: Add support for __fentry__
> 
> Kevin Hao (1)
>       ftrace/x86: skip over the breakpoint for ftrace caller
> 
> Namhyung Kim (4)
>       ftrace: Get rid of ftrace_graph_filter_enabled
>       ftrace: Introduce struct ftrace_graph_data
>       ftrace: Narrow down the protected area of graph_lock
>       ftrace: Add set_graph_notrace filter
> 
> Paul E. McKenney (6)
>       rcu: Remove redundant code from rcu_cleanup_after_idle()
>       rcu: Throttle rcu_try_advance_all_cbs() execution
>       rcu: Throttle invoke_rcu_core() invocations due to non-lazy callbacks
>       rcu: Is it safe to enter an RCU read-side critical section?
>       rcu: Change EXPORT_SYMBOL() to EXPORT_SYMBOL_GPL()
>       rcu: Consistent rcu_is_watching() naming
> 
> Steven Rostedt (2)
>       tracing: Fix potential out-of-bounds in trace_get_user()
>       rcu: Do not trace rcu_is_watching() functions
> 
> Steven Rostedt (Red Hat) (4)
>       ftrace: Have control op function callback only trace when RCU is watching
>       tracing: Remove unused function ftrace_off_permanent()
>       tracing: Do not use signed enums with unsigned long long in fgragh output
>       tracing: Add rcu annotation for syscall trace descriptors
> 
> Tom Zanussi (3)
>       tracing: Update event filters for multibuffer
>       tracing: Make register/unregister_ftrace_command __init
>       tracing: Add support for SOFT_DISABLE to syscall events
> 
> Wang YanQing (1)
>       tracing: Show more exact help information about snapshot
> 
> ----
>  arch/x86/kernel/ftrace.c             |   14 ++
>  include/linux/ftrace.h               |    5 
>  include/linux/ftrace_event.h         |   25 +++-
>  include/linux/kernel.h               |    2 
>  include/linux/rcupdate.h             |   26 ++--
>  include/linux/rcutiny.h              |   25 +++-
>  include/linux/rcutree.h              |    4 
>  include/linux/syscalls.h             |    8 -
>  include/trace/ftrace.h               |    7 -
>  kernel/lockdep.c                     |    4 
>  kernel/rcupdate.c                    |    2 
>  kernel/rcutiny.c                     |   12 -
>  kernel/rcutree.c                     |   55 +++++---
>  kernel/rcutree.h                     |    2 
>  kernel/rcutree_plugin.h              |   24 ++-
>  kernel/trace/ftrace.c                |  163 +++++++++++++++++++-------
>  kernel/trace/trace.c                 |   82 ++++++++-----
>  kernel/trace/trace.h                 |   54 +++++---
>  kernel/trace/trace_branch.c          |    2 
>  kernel/trace/trace_events.c          |   32 +++--
>  kernel/trace/trace_events_filter.c   |  218 ++++++++++++++++++++++++++++-------
>  kernel/trace/trace_export.c          |    2 
>  kernel/trace/trace_functions_graph.c |   82 ++++++++++---
>  kernel/trace/trace_kprobe.c          |    4 
>  kernel/trace/trace_mmiotrace.c       |    4 
>  kernel/trace/trace_sched_switch.c    |    4 
>  kernel/trace/trace_stat.c            |   41 ------
>  kernel/trace/trace_syscalls.c        |   50 +++++---
>  kernel/trace/trace_uprobe.c          |    3 
>  scripts/recordmcount.pl              |    4 
>  30 files changed, 665 insertions(+), 295 deletions(-)
> ---------------------------
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 130c97b..18d9c91 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1768,17 +1768,11 @@ static void rcu_prepare_for_idle(int cpu)
>   */
>  static void rcu_cleanup_after_idle(int cpu)
>  {
> -	struct rcu_data *rdp;
> -	struct rcu_state *rsp;
>  
>  	if (rcu_is_nocb_cpu(cpu))
>  		return;
> -	rcu_try_advance_all_cbs();
> -	for_each_rcu_flavor(rsp) {
> -		rdp = per_cpu_ptr(rsp->rda, cpu);
> -		if (cpu_has_callbacks_ready_to_invoke(rdp))
> -			invoke_rcu_core();
> -	}
> +	if (rcu_try_advance_all_cbs())
> +		invoke_rcu_core();
>  }
>  
>  /*
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 5f97eab..52be957 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -104,6 +104,8 @@ struct rcu_dynticks {
>  				    /* idle-period nonlazy_posted snapshot. */
>  	unsigned long last_accelerate;
>  				    /* Last jiffy CBs were accelerated. */
> +	unsigned long last_advance_all;
> +				    /* Last jiffy CBs were all advanced. */
>  	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
>  #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
>  };
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 18d9c91..d81e385 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1630,17 +1630,23 @@ module_param(rcu_idle_lazy_gp_delay, int, 0644);
>  extern int tick_nohz_enabled;
>  
>  /*
> - * Try to advance callbacks for all flavors of RCU on the current CPU.
> - * Afterwards, if there are any callbacks ready for immediate invocation,
> - * return true.
> + * Try to advance callbacks for all flavors of RCU on the current CPU, but
> + * only if it has been awhile since the last time we did so.  Afterwards,
> + * if there are any callbacks ready for immediate invocation, return true.
>   */
>  static bool rcu_try_advance_all_cbs(void)
>  {
>  	bool cbs_ready = false;
>  	struct rcu_data *rdp;
> +	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
>  	struct rcu_node *rnp;
>  	struct rcu_state *rsp;
>  
> +	/* Exit early if we advanced recently. */
> +	if (jiffies == rdtp->last_advance_all)
> +		return 0;
> +	rdtp->last_advance_all = jiffies;
> +
>  	for_each_rcu_flavor(rsp) {
>  		rdp = this_cpu_ptr(rsp->rda);
>  		rnp = rdp->mynode;
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index d81e385..2c15d7c 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1745,6 +1745,8 @@ static void rcu_prepare_for_idle(int cpu)
>  	 */
>  	if (rdtp->all_lazy &&
>  	    rdtp->nonlazy_posted != rdtp->nonlazy_posted_snap) {
> +		rdtp->all_lazy = false;
> +		rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
>  		invoke_rcu_core();
>  		return;
>  	}
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index f1f1bc3..a53a21a 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -261,6 +261,10 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
>  		rcu_irq_exit(); \
>  	} while (0)
>  
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
> +extern int rcu_is_cpu_idle(void);
> +#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
> +
>  /*
>   * Infrastructure to implement the synchronize_() primitives in
>   * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
> @@ -297,10 +301,6 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
>  }
>  #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
>  
> -#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP)
> -extern int rcu_is_cpu_idle(void);
> -#endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_SMP) */
> -
>  #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU)
>  bool rcu_lockdep_current_cpu_online(void);
>  #else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index e31005e..bee6659 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -132,4 +132,13 @@ static inline void rcu_scheduler_starting(void)
>  }
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
> +#ifdef CONFIG_RCU_TRACE
> +
> +static inline bool __rcu_is_watching(void)
> +{
> +	return !rcu_is_cpu_idle();
> +}
> +
> +#endif /* #ifdef CONFIG_RCU_TRACE */
> +
>  #endif /* __LINUX_RCUTINY_H */
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 226169d..293613d 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -90,4 +90,6 @@ extern void exit_rcu(void);
>  extern void rcu_scheduler_starting(void);
>  extern int rcu_scheduler_active __read_mostly;
>  
> +extern bool __rcu_is_watching(void);
> +
>  #endif /* __LINUX_RCUTREE_H */
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 9ed6075..b4bc618 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -174,7 +174,7 @@ void rcu_irq_enter(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_irq_enter);
>  
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE)
>  
>  /*
>   * Test whether RCU thinks that the current CPU is idle.
> @@ -185,7 +185,7 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
>  
> -#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> +#endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
>  
>  /*
>   * Test whether the current CPU was interrupted from idle.  Nested
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 32618b3..910d868 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -671,6 +671,19 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
>  
> +/**
> + * __rcu_is_watching - are RCU read-side critical sections safe?
> + *
> + * Return true if RCU is watching the running CPU, which means that
> + * this CPU can safely enter RCU read-side critical sections.  Unlike
> + * rcu_is_cpu_idle(), the caller of __rcu_is_watching() must have at
> + * least disabled preemption.
> + */
> +bool __rcu_is_watching(void)
> +{
> +	return !!(atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1);
> +}
> +
>  #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
>  
>  /*
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 910d868..1b123e1 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -669,7 +669,7 @@ int rcu_is_cpu_idle(void)
>  	preempt_enable();
>  	return ret;
>  }
> -EXPORT_SYMBOL(rcu_is_cpu_idle);
> +EXPORT_SYMBOL_GPL(rcu_is_cpu_idle);
>  
>  /**
>   * __rcu_is_watching - are RCU read-side critical sections safe?
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index a53a21a..39cbb88 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -262,7 +262,7 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
>  	} while (0)
>  
>  #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
> -extern int rcu_is_cpu_idle(void);
> +extern bool __rcu_is_watching(void);
>  #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
>  
>  /*
> @@ -351,7 +351,7 @@ static inline int rcu_read_lock_held(void)
>  {
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
> -	if (rcu_is_cpu_idle())
> +	if (!rcu_is_watching())
>  		return 0;
>  	if (!rcu_lockdep_current_cpu_online())
>  		return 0;
> @@ -402,7 +402,7 @@ static inline int rcu_read_lock_sched_held(void)
>  
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
> -	if (rcu_is_cpu_idle())
> +	if (!rcu_is_watching())
>  		return 0;
>  	if (!rcu_lockdep_current_cpu_online())
>  		return 0;
> @@ -771,7 +771,7 @@ static inline void rcu_read_lock(void)
>  	__rcu_read_lock();
>  	__acquire(RCU);
>  	rcu_lock_acquire(&rcu_lock_map);
> -	rcu_lockdep_assert(!rcu_is_cpu_idle(),
> +	rcu_lockdep_assert(rcu_is_watching(),
>  			   "rcu_read_lock() used illegally while idle");
>  }
>  
> @@ -792,7 +792,7 @@ static inline void rcu_read_lock(void)
>   */
>  static inline void rcu_read_unlock(void)
>  {
> -	rcu_lockdep_assert(!rcu_is_cpu_idle(),
> +	rcu_lockdep_assert(rcu_is_watching(),
>  			   "rcu_read_unlock() used illegally while idle");
>  	rcu_lock_release(&rcu_lock_map);
>  	__release(RCU);
> @@ -821,7 +821,7 @@ static inline void rcu_read_lock_bh(void)
>  	local_bh_disable();
>  	__acquire(RCU_BH);
>  	rcu_lock_acquire(&rcu_bh_lock_map);
> -	rcu_lockdep_assert(!rcu_is_cpu_idle(),
> +	rcu_lockdep_assert(rcu_is_watching(),
>  			   "rcu_read_lock_bh() used illegally while idle");
>  }
>  
> @@ -832,7 +832,7 @@ static inline void rcu_read_lock_bh(void)
>   */
>  static inline void rcu_read_unlock_bh(void)
>  {
> -	rcu_lockdep_assert(!rcu_is_cpu_idle(),
> +	rcu_lockdep_assert(rcu_is_watching(),
>  			   "rcu_read_unlock_bh() used illegally while idle");
>  	rcu_lock_release(&rcu_bh_lock_map);
>  	__release(RCU_BH);
> @@ -857,7 +857,7 @@ static inline void rcu_read_lock_sched(void)
>  	preempt_disable();
>  	__acquire(RCU_SCHED);
>  	rcu_lock_acquire(&rcu_sched_lock_map);
> -	rcu_lockdep_assert(!rcu_is_cpu_idle(),
> +	rcu_lockdep_assert(rcu_is_watching(),
>  			   "rcu_read_lock_sched() used illegally while idle");
>  }
>  
> @@ -875,7 +875,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
>   */
>  static inline void rcu_read_unlock_sched(void)
>  {
> -	rcu_lockdep_assert(!rcu_is_cpu_idle(),
> +	rcu_lockdep_assert(rcu_is_watching(),
>  			   "rcu_read_unlock_sched() used illegally while idle");
>  	rcu_lock_release(&rcu_sched_lock_map);
>  	__release(RCU_SCHED);
> diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
> index bee6659..09ebcbe 100644
> --- a/include/linux/rcutiny.h
> +++ b/include/linux/rcutiny.h
> @@ -132,13 +132,21 @@ static inline void rcu_scheduler_starting(void)
>  }
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
> -#ifdef CONFIG_RCU_TRACE
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE)
>  
> -static inline bool __rcu_is_watching(void)
> +static inline bool rcu_is_watching(void)
>  {
> -	return !rcu_is_cpu_idle();
> +	return __rcu_is_watching();
>  }
>  
> -#endif /* #ifdef CONFIG_RCU_TRACE */
> +#else /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
> +
> +static inline bool rcu_is_watching(void)
> +{
> +	return true;
> +}
> +
> +
> +#endif /* #else defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
>  
>  #endif /* __LINUX_RCUTINY_H */
> diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
> index 293613d..4b9c815 100644
> --- a/include/linux/rcutree.h
> +++ b/include/linux/rcutree.h
> @@ -90,6 +90,6 @@ extern void exit_rcu(void);
>  extern void rcu_scheduler_starting(void);
>  extern int rcu_scheduler_active __read_mostly;
>  
> -extern bool __rcu_is_watching(void);
> +extern bool rcu_is_watching(void);
>  
>  #endif /* __LINUX_RCUTREE_H */
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index e16c45b..4e8e14c 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -4224,7 +4224,7 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
>  	printk("\n%srcu_scheduler_active = %d, debug_locks = %d\n",
>  	       !rcu_lockdep_current_cpu_online()
>  			? "RCU used illegally from offline CPU!\n"
> -			: rcu_is_cpu_idle()
> +			: !rcu_is_watching()
>  				? "RCU used illegally from idle CPU!\n"
>  				: "",
>  	       rcu_scheduler_active, debug_locks);
> @@ -4247,7 +4247,7 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
>  	 * So complain bitterly if someone does call rcu_read_lock(),
>  	 * rcu_read_lock_bh() and so on from extended quiescent states.
>  	 */
> -	if (rcu_is_cpu_idle())
> +	if (!rcu_is_watching())
>  		printk("RCU used illegally from extended quiescent state!\n");
>  
>  	lockdep_print_held_locks(curr);
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index b02a339..3b3c046 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -148,7 +148,7 @@ int rcu_read_lock_bh_held(void)
>  {
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
> -	if (rcu_is_cpu_idle())
> +	if (!rcu_is_watching())
>  		return 0;
>  	if (!rcu_lockdep_current_cpu_online())
>  		return 0;
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index b4bc618..0fa061d 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -179,11 +179,11 @@ EXPORT_SYMBOL_GPL(rcu_irq_enter);
>  /*
>   * Test whether RCU thinks that the current CPU is idle.
>   */
> -int rcu_is_cpu_idle(void)
> +bool __rcu_is_watching(void)
>  {
> -	return !rcu_dynticks_nesting;
> +	return rcu_dynticks_nesting;
>  }
> -EXPORT_SYMBOL(rcu_is_cpu_idle);
> +EXPORT_SYMBOL(__rcu_is_watching);
>  
>  #endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
>  
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 1b123e1..981d0c1 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -655,34 +655,34 @@ void rcu_nmi_exit(void)
>  }
>  
>  /**
> - * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
> + * __rcu_is_watching - are RCU read-side critical sections safe?
> + *
> + * Return true if RCU is watching the running CPU, which means that
> + * this CPU can safely enter RCU read-side critical sections.  Unlike
> + * rcu_is_watching(), the caller of __rcu_is_watching() must have at
> + * least disabled preemption.
> + */
> +bool __rcu_is_watching(void)
> +{
> +	return atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1;
> +}
> +
> +/**
> + * rcu_is_watching - see if RCU thinks that the current CPU is idle
>   *
>   * If the current CPU is in its idle loop and is neither in an interrupt
>   * or NMI handler, return true.
>   */
> -int rcu_is_cpu_idle(void)
> +bool rcu_is_watching(void)
>  {
>  	int ret;
>  
>  	preempt_disable();
> -	ret = (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> +	ret = __rcu_is_watching();
>  	preempt_enable();
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(rcu_is_cpu_idle);
> -
> -/**
> - * __rcu_is_watching - are RCU read-side critical sections safe?
> - *
> - * Return true if RCU is watching the running CPU, which means that
> - * this CPU can safely enter RCU read-side critical sections.  Unlike
> - * rcu_is_cpu_idle(), the caller of __rcu_is_watching() must have at
> - * least disabled preemption.
> - */
> -bool __rcu_is_watching(void)
> -{
> -	return !!(atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1);
> -}
> +EXPORT_SYMBOL_GPL(rcu_is_watching);
>  
>  #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
>  
> @@ -2268,7 +2268,7 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
>  	 * If called from an extended quiescent state, invoke the RCU
>  	 * core in order to force a re-evaluation of RCU's idleness.
>  	 */
> -	if (rcu_is_cpu_idle() && cpu_online(smp_processor_id()))
> +	if (!rcu_is_watching() && cpu_online(smp_processor_id()))
>  		invoke_rcu_core();
>  
>  	/* If interrupts were disabled or CPU offline, don't invoke RCU core. */
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7974ba2..d5f7c4d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2760,7 +2760,7 @@ static void show_snapshot_main_help(struct seq_file *m)
>  	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
>  	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.\n");
>  	seq_printf(m, "#                      Takes a snapshot of the main buffer.\n");
> -	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate)\n");
> +	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not allocate or free)\n");
>  	seq_printf(m, "#                      (Doesn't have to be '2' works with any number that\n");
>  	seq_printf(m, "#                       is not a '0' or '1')\n");
>  }
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d5f7c4d..063a92b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -843,9 +843,12 @@ int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
>  	if (isspace(ch)) {
>  		parser->buffer[parser->idx] = 0;
>  		parser->cont = false;
> -	} else {
> +	} else if (parser->idx < parser->size - 1) {
>  		parser->cont = true;
>  		parser->buffer[parser->idx++] = ch;
> +	} else {
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  
>  	*ppos += read;
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 03cf44a..a77e4a0 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3776,7 +3776,6 @@ static const struct file_operations ftrace_notrace_fops = {
>  static DEFINE_MUTEX(graph_lock);
>  
>  int ftrace_graph_count;
> -int ftrace_graph_filter_enabled;
>  unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
>  
>  static void *
> @@ -3799,7 +3798,7 @@ static void *g_start(struct seq_file *m, loff_t *pos)
>  	mutex_lock(&graph_lock);
>  
>  	/* Nothing, tell g_show to print all functions are enabled */
> -	if (!ftrace_graph_filter_enabled && !*pos)
> +	if (!ftrace_graph_count && !*pos)
>  		return (void *)1;
>  
>  	return __g_next(m, pos);
> @@ -3845,7 +3844,6 @@ ftrace_graph_open(struct inode *inode, struct file *file)
>  	mutex_lock(&graph_lock);
>  	if ((file->f_mode & FMODE_WRITE) &&
>  	    (file->f_flags & O_TRUNC)) {
> -		ftrace_graph_filter_enabled = 0;
>  		ftrace_graph_count = 0;
>  		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
>  	}
> @@ -3925,8 +3923,6 @@ out:
>  	if (fail)
>  		return -EINVAL;
>  
> -	ftrace_graph_filter_enabled = !!(*idx);
> -
>  	return 0;
>  }
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 10c86fb..40211ce 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -730,7 +730,6 @@ extern void __trace_graph_return(struct trace_array *tr,
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  /* TODO: make this variable */
>  #define FTRACE_GRAPH_MAX_FUNCS		32
> -extern int ftrace_graph_filter_enabled;
>  extern int ftrace_graph_count;
>  extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
>  
> @@ -738,7 +737,7 @@ static inline int ftrace_graph_addr(unsigned long addr)
>  {
>  	int i;
>  
> -	if (!ftrace_graph_filter_enabled)
> +	if (!ftrace_graph_count)
>  		return 1;
>  
>  	for (i = 0; i < ftrace_graph_count; i++) {
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index a77e4a0..0ff3449 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3641,7 +3641,7 @@ __setup("ftrace_filter=", set_ftrace_filter);
>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
> -static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
> +static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
>  
>  static int __init set_graph_function(char *str)
>  {
> @@ -3659,7 +3659,7 @@ static void __init set_ftrace_early_graph(char *buf)
>  		func = strsep(&buf, ",");
>  		/* we allow only one expression at a time */
>  		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
> -				      func);
> +				      FTRACE_GRAPH_MAX_FUNCS, func);
>  		if (ret)
>  			printk(KERN_DEBUG "ftrace: function %s not "
>  					  "traceable\n", func);
> @@ -3778,12 +3778,21 @@ static DEFINE_MUTEX(graph_lock);
>  int ftrace_graph_count;
>  unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
>  
> +struct ftrace_graph_data {
> +	unsigned long *table;
> +	size_t size;
> +	int *count;
> +	const struct seq_operations *seq_ops;
> +};
> +
>  static void *
>  __g_next(struct seq_file *m, loff_t *pos)
>  {
> -	if (*pos >= ftrace_graph_count)
> +	struct ftrace_graph_data *fgd = m->private;
> +
> +	if (*pos >= *fgd->count)
>  		return NULL;
> -	return &ftrace_graph_funcs[*pos];
> +	return &fgd->table[*pos];
>  }
>  
>  static void *
> @@ -3795,10 +3804,12 @@ g_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  static void *g_start(struct seq_file *m, loff_t *pos)
>  {
> +	struct ftrace_graph_data *fgd = m->private;
> +
>  	mutex_lock(&graph_lock);
>  
>  	/* Nothing, tell g_show to print all functions are enabled */
> -	if (!ftrace_graph_count && !*pos)
> +	if (!*fgd->count && !*pos)
>  		return (void *)1;
>  
>  	return __g_next(m, pos);
> @@ -3834,37 +3845,68 @@ static const struct seq_operations ftrace_graph_seq_ops = {
>  };
>  
>  static int
> -ftrace_graph_open(struct inode *inode, struct file *file)
> +__ftrace_graph_open(struct inode *inode, struct file *file,
> +		    struct ftrace_graph_data *fgd)
>  {
>  	int ret = 0;
>  
> -	if (unlikely(ftrace_disabled))
> -		return -ENODEV;
> -
>  	mutex_lock(&graph_lock);
>  	if ((file->f_mode & FMODE_WRITE) &&
>  	    (file->f_flags & O_TRUNC)) {
> -		ftrace_graph_count = 0;
> -		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
> +		*fgd->count = 0;
> +		memset(fgd->table, 0, fgd->size * sizeof(*fgd->table));
>  	}
>  	mutex_unlock(&graph_lock);
>  
> -	if (file->f_mode & FMODE_READ)
> -		ret = seq_open(file, &ftrace_graph_seq_ops);
> +	if (file->f_mode & FMODE_READ) {
> +		ret = seq_open(file, fgd->seq_ops);
> +		if (!ret) {
> +			struct seq_file *m = file->private_data;
> +			m->private = fgd;
> +		}
> +	} else
> +		file->private_data = fgd;
>  
>  	return ret;
>  }
>  
>  static int
> +ftrace_graph_open(struct inode *inode, struct file *file)
> +{
> +	struct ftrace_graph_data *fgd;
> +
> +	if (unlikely(ftrace_disabled))
> +		return -ENODEV;
> +
> +	fgd = kmalloc(sizeof(*fgd), GFP_KERNEL);
> +	if (fgd == NULL)
> +		return -ENOMEM;
> +
> +	fgd->table = ftrace_graph_funcs;
> +	fgd->size = FTRACE_GRAPH_MAX_FUNCS;
> +	fgd->count = &ftrace_graph_count;
> +	fgd->seq_ops = &ftrace_graph_seq_ops;
> +
> +	return __ftrace_graph_open(inode, file, fgd);
> +}
> +
> +static int
>  ftrace_graph_release(struct inode *inode, struct file *file)
>  {
> -	if (file->f_mode & FMODE_READ)
> +	if (file->f_mode & FMODE_READ) {
> +		struct seq_file *m = file->private_data;
> +
> +		kfree(m->private);
>  		seq_release(inode, file);
> +	} else {
> +		kfree(file->private_data);
> +	}
> +
>  	return 0;
>  }
>  
>  static int
> -ftrace_set_func(unsigned long *array, int *idx, char *buffer)
> +ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer)
>  {
>  	struct dyn_ftrace *rec;
>  	struct ftrace_page *pg;
> @@ -3877,7 +3919,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
>  
>  	/* decode regex */
>  	type = filter_parse_regex(buffer, strlen(buffer), &search, &not);
> -	if (!not && *idx >= FTRACE_GRAPH_MAX_FUNCS)
> +	if (!not && *idx >= size)
>  		return -EBUSY;
>  
>  	search_len = strlen(search);
> @@ -3905,7 +3947,7 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
>  				fail = 0;
>  				if (!exists) {
>  					array[(*idx)++] = rec->ip;
> -					if (*idx >= FTRACE_GRAPH_MAX_FUNCS)
> +					if (*idx >= size)
>  						goto out;
>  				}
>  			} else {
> @@ -3932,6 +3974,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  {
>  	struct trace_parser parser;
>  	ssize_t read, ret;
> +	struct ftrace_graph_data *fgd = file->private_data;
>  
>  	if (!cnt)
>  		return 0;
> @@ -3949,8 +3992,8 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  		parser.buffer[parser.idx] = 0;
>  
>  		/* we allow only one expression at a time */
> -		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
> -					parser.buffer);
> +		ret = ftrace_set_func(fgd->table, fgd->count, fgd->size,
> +				      parser.buffer);
>  		if (ret)
>  			goto out_free;
>  	}
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 0ff3449..26a229a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3973,37 +3973,33 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>  		   size_t cnt, loff_t *ppos)
>  {
>  	struct trace_parser parser;
> -	ssize_t read, ret;
> +	ssize_t read, ret = 0;
>  	struct ftrace_graph_data *fgd = file->private_data;
>  
>  	if (!cnt)
>  		return 0;
>  
> -	mutex_lock(&graph_lock);
> -
> -	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
> -		ret = -ENOMEM;
> -		goto out_unlock;
> -	}
> +	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX))
> +		return -ENOMEM;
>  
>  	read = trace_get_user(&parser, ubuf, cnt, ppos);
>  
>  	if (read >= 0 && trace_parser_loaded((&parser))) {
>  		parser.buffer[parser.idx] = 0;
>  
> +		mutex_lock(&graph_lock);
> +
>  		/* we allow only one expression at a time */
>  		ret = ftrace_set_func(fgd->table, fgd->count, fgd->size,
>  				      parser.buffer);
> -		if (ret)
> -			goto out_free;
> +
> +		mutex_unlock(&graph_lock);
>  	}
>  
> -	ret = read;
> +	if (!ret)
> +		ret = read;
>  
> -out_free:
>  	trace_parser_put(&parser);
> -out_unlock:
> -	mutex_unlock(&graph_lock);
>  
>  	return ret;
>  }
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9f15c00..ec85d48 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -721,6 +721,7 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
>  extern char __irqentry_text_start[];
>  extern char __irqentry_text_end[];
>  
> +#define FTRACE_NOTRACE_DEPTH 65536
>  #define FTRACE_RETFUNC_DEPTH 50
>  #define FTRACE_RETSTACK_ALLOC_SIZE 32
>  extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 26a229a..44e826a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3776,7 +3776,9 @@ static const struct file_operations ftrace_notrace_fops = {
>  static DEFINE_MUTEX(graph_lock);
>  
>  int ftrace_graph_count;
> +int ftrace_graph_notrace_count;
>  unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
> +unsigned long ftrace_graph_notrace_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
>  
>  struct ftrace_graph_data {
>  	unsigned long *table;
> @@ -3891,6 +3893,26 @@ ftrace_graph_open(struct inode *inode, struct file *file)
>  }
>  
>  static int
> +ftrace_graph_notrace_open(struct inode *inode, struct file *file)
> +{
> +	struct ftrace_graph_data *fgd;
> +
> +	if (unlikely(ftrace_disabled))
> +		return -ENODEV;
> +
> +	fgd = kmalloc(sizeof(*fgd), GFP_KERNEL);
> +	if (fgd == NULL)
> +		return -ENOMEM;
> +
> +	fgd->table = ftrace_graph_notrace_funcs;
> +	fgd->size = FTRACE_GRAPH_MAX_FUNCS;
> +	fgd->count = &ftrace_graph_notrace_count;
> +	fgd->seq_ops = &ftrace_graph_seq_ops;
> +
> +	return __ftrace_graph_open(inode, file, fgd);
> +}
> +
> +static int
>  ftrace_graph_release(struct inode *inode, struct file *file)
>  {
>  	if (file->f_mode & FMODE_READ) {
> @@ -4011,6 +4033,14 @@ static const struct file_operations ftrace_graph_fops = {
>  	.llseek		= ftrace_filter_lseek,
>  	.release	= ftrace_graph_release,
>  };
> +
> +static const struct file_operations ftrace_graph_notrace_fops = {
> +	.open		= ftrace_graph_notrace_open,
> +	.read		= seq_read,
> +	.write		= ftrace_graph_write,
> +	.llseek		= ftrace_filter_lseek,
> +	.release	= ftrace_graph_release,
> +};
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
>  static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
> @@ -4032,6 +4062,9 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
>  	trace_create_file("set_graph_function", 0444, d_tracer,
>  				    NULL,
>  				    &ftrace_graph_fops);
> +	trace_create_file("set_graph_notrace", 0444, d_tracer,
> +				    NULL,
> +				    &ftrace_graph_notrace_fops);
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
>  	return 0;
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 40211ce..d1cf515 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -732,6 +732,8 @@ extern void __trace_graph_return(struct trace_array *tr,
>  #define FTRACE_GRAPH_MAX_FUNCS		32
>  extern int ftrace_graph_count;
>  extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
> +extern int ftrace_graph_notrace_count;
> +extern unsigned long ftrace_graph_notrace_funcs[FTRACE_GRAPH_MAX_FUNCS];
>  
>  static inline int ftrace_graph_addr(unsigned long addr)
>  {
> @@ -757,11 +759,31 @@ static inline int ftrace_graph_addr(unsigned long addr)
>  
>  	return 0;
>  }
> +
> +static inline int ftrace_graph_notrace_addr(unsigned long addr)
> +{
> +	int i;
> +
> +	if (!ftrace_graph_notrace_count)
> +		return 0;
> +
> +	for (i = 0; i < ftrace_graph_notrace_count; i++) {
> +		if (addr == ftrace_graph_notrace_funcs[i])
> +			return 1;
> +	}
> +
> +	return 0;
> +}
>  #else
>  static inline int ftrace_graph_addr(unsigned long addr)
>  {
>  	return 1;
>  }
> +
> +static inline int ftrace_graph_notrace_addr(unsigned long addr)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_DYNAMIC_FTRACE */
>  #else /* CONFIG_FUNCTION_GRAPH_TRACER */
>  static inline enum print_line_t
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index b5c0924..e08c030 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -114,16 +114,37 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
>  		return -EBUSY;
>  	}
>  
> +	/*
> +	 * The curr_ret_stack is an index to ftrace return stack of
> +	 * current task.  Its value should be in [0, FTRACE_RETFUNC_
> +	 * DEPTH) when the function graph tracer is used.  To support
> +	 * filtering out specific functions, it makes the index
> +	 * negative by subtracting huge value (FTRACE_NOTRACE_DEPTH)
> +	 * so when it sees a negative index the ftrace will ignore
> +	 * the record.  And the index gets recovered when returning
> +	 * from the filtered function by adding the FTRACE_NOTRACE_
> +	 * DEPTH and then it'll continue to record functions normally.
> +	 *
> +	 * The curr_ret_stack is initialized to -1 and get increased
> +	 * in this function.  So it can be less than -1 only if it was
> +	 * filtered out via ftrace_graph_notrace_addr() which can be
> +	 * set from set_graph_notrace file in debugfs by user.
> +	 */
> +	if (current->curr_ret_stack < -1)
> +		return -EBUSY;
> +
>  	calltime = trace_clock_local();
>  
>  	index = ++current->curr_ret_stack;
> +	if (ftrace_graph_notrace_addr(func))
> +		current->curr_ret_stack -= FTRACE_NOTRACE_DEPTH;
>  	barrier();
>  	current->ret_stack[index].ret = ret;
>  	current->ret_stack[index].func = func;
>  	current->ret_stack[index].calltime = calltime;
>  	current->ret_stack[index].subtime = 0;
>  	current->ret_stack[index].fp = frame_pointer;
> -	*depth = index;
> +	*depth = current->curr_ret_stack;
>  
>  	return 0;
>  }
> @@ -137,7 +158,17 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
>  
>  	index = current->curr_ret_stack;
>  
> -	if (unlikely(index < 0)) {
> +	/*
> +	 * A negative index here means that it's just returned from a
> +	 * notrace'd function.  Recover index to get an original
> +	 * return address.  See ftrace_push_return_trace().
> +	 *
> +	 * TODO: Need to check whether the stack gets corrupted.
> +	 */
> +	if (index < 0)
> +		index += FTRACE_NOTRACE_DEPTH;
> +
> +	if (unlikely(index < 0 || index >= FTRACE_RETFUNC_DEPTH)) {
>  		ftrace_graph_stop();
>  		WARN_ON(1);
>  		/* Might as well panic, otherwise we have no where to go */
> @@ -193,6 +224,15 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
>  	trace.rettime = trace_clock_local();
>  	barrier();
>  	current->curr_ret_stack--;
> +	/*
> +	 * The curr_ret_stack can be less than -1 only if it was
> +	 * filtered out and it's about to return from the function.
> +	 * Recover the index and continue to trace normal functions.
> +	 */
> +	if (current->curr_ret_stack < -1) {
> +		current->curr_ret_stack += FTRACE_NOTRACE_DEPTH;
> +		return ret;
> +	}
>  
>  	/*
>  	 * The trace should run after decrementing the ret counter
> @@ -259,10 +299,20 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  
>  	/* trace it when it is-nested-in or is a function enabled. */
>  	if ((!(trace->depth || ftrace_graph_addr(trace->func)) ||
> -	     ftrace_graph_ignore_irqs()) ||
> +	     ftrace_graph_ignore_irqs()) || (trace->depth < 0) ||
>  	    (max_depth && trace->depth >= max_depth))
>  		return 0;
>  
> +	/*
> +	 * Do not trace a function if it's filtered by set_graph_notrace.
> +	 * Make the index of ret stack negative to indicate that it should
> +	 * ignore further functions.  But it needs its own ret stack entry
> +	 * to recover the original index in order to continue tracing after
> +	 * returning from the function.
> +	 */
> +	if (ftrace_graph_notrace_addr(trace->func))
> +		return 1;
> +
>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
>  	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
> diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
> index 847f88a..7af6736 100644
> --- a/kernel/trace/trace_stat.c
> +++ b/kernel/trace/trace_stat.c
> @@ -43,46 +43,15 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
>  /* The root directory for all stat files */
>  static struct dentry		*stat_dir;
>  
> -/*
> - * Iterate through the rbtree using a post order traversal path
> - * to release the next node.
> - * It won't necessary release one at each iteration
> - * but it will at least advance closer to the next one
> - * to be released.
> - */
> -static struct rb_node *release_next(struct tracer_stat *ts,
> -				    struct rb_node *node)
> +static void __reset_stat_session(struct stat_session *session)
>  {
> -	struct stat_node *snode;
> -	struct rb_node *parent = rb_parent(node);
> -
> -	if (node->rb_left)
> -		return node->rb_left;
> -	else if (node->rb_right)
> -		return node->rb_right;
> -	else {
> -		if (!parent)
> -			;
> -		else if (parent->rb_left == node)
> -			parent->rb_left = NULL;
> -		else
> -			parent->rb_right = NULL;
> +	struct stat_node *snode, *n;
>  
> -		snode = container_of(node, struct stat_node, node);
> -		if (ts->stat_release)
> -			ts->stat_release(snode->stat);
> +	rbtree_postorder_for_each_entry_safe(snode, n, &session->stat_root, node) {
> +		if (session->ts->stat_release)
> +			session->ts->stat_release(snode->stat);
>  		kfree(snode);
> -
> -		return parent;
>  	}
> -}
> -
> -static void __reset_stat_session(struct stat_session *session)
> -{
> -	struct rb_node *node = session->stat_root.rb_node;
> -
> -	while (node)
> -		node = release_next(session->ts, node);
>  
>  	session->stat_root = RB_ROOT;
>  }
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 42a392a..d4bdd25 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -248,6 +248,15 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
>  	return ret;
>  }
>  
> +static int is_ftrace_caller(unsigned long ip)
> +{
> +	if (ip == (unsigned long)(&ftrace_call) ||
> +		ip == (unsigned long)(&ftrace_regs_call))
> +		return 1;
> +
> +	return 0;
> +}
> +
>  /*
>   * A breakpoint was added to the code address we are about to
>   * modify, and this is the handle that will just skip over it.
> @@ -257,10 +266,13 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
>   */
>  int ftrace_int3_handler(struct pt_regs *regs)
>  {
> +	unsigned long ip;
> +
>  	if (WARN_ON_ONCE(!regs))
>  		return 0;
>  
> -	if (!ftrace_location(regs->ip - 1))
> +	ip = regs->ip - 1;
> +	if (!ftrace_location(ip) && !is_ftrace_caller(ip))
>  		return 0;
>  
>  	regs->ip += MCOUNT_INSN_SIZE - 1;
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 0fa061d..590c8a8 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -179,7 +179,7 @@ EXPORT_SYMBOL_GPL(rcu_irq_enter);
>  /*
>   * Test whether RCU thinks that the current CPU is idle.
>   */
> -bool __rcu_is_watching(void)
> +bool notrace __rcu_is_watching(void)
>  {
>  	return rcu_dynticks_nesting;
>  }
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 981d0c1..499bb2b 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -662,7 +662,7 @@ void rcu_nmi_exit(void)
>   * rcu_is_watching(), the caller of __rcu_is_watching() must have at
>   * least disabled preemption.
>   */
> -bool __rcu_is_watching(void)
> +bool notrace __rcu_is_watching(void)
>  {
>  	return atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1;
>  }
> @@ -673,7 +673,7 @@ bool __rcu_is_watching(void)
>   * If the current CPU is in its idle loop and is neither in an interrupt
>   * or NMI handler, return true.
>   */
> -bool rcu_is_watching(void)
> +bool notrace rcu_is_watching(void)
>  {
>  	int ret;
>  
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 44e826a..080b7d4 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4388,12 +4388,21 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
>  	 */
>  	preempt_disable_notrace();
>  	trace_recursion_set(TRACE_CONTROL_BIT);
> +
> +	/*
> +	 * Control funcs (perf) uses RCU. Only trace if
> +	 * RCU is currently active.
> +	 */
> +	if (!rcu_is_watching())
> +		goto out;
> +
>  	do_for_each_ftrace_op(op, ftrace_control_list) {
>  		if (!(op->flags & FTRACE_OPS_FL_STUB) &&
>  		    !ftrace_function_local_disabled(op) &&
>  		    ftrace_ops_test(op, ip, regs))
>  			op->func(ip, parent_ip, op, regs);
>  	} while_for_each_ftrace_op(op);
> + out:
>  	trace_recursion_clear(TRACE_CONTROL_BIT);
>  	preempt_enable_notrace();
>  }
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index a674fd5..d0da663 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -214,13 +214,13 @@ $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
>  $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
>  $section_regex = "Disassembly of section\\s+(\\S+):";
>  $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> -$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
> +$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
>  $section_type = '@progbits';
>  $mcount_adjust = 0;
>  $type = ".long";
>  
>  if ($arch eq "x86_64") {
> -    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)([+-]0x[0-9a-zA-Z]+)?\$";
>      $type = ".quad";
>      $alignment = 8;
>      $mcount_adjust = -1;
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5eaa746..9abbe63 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -202,6 +202,7 @@ enum {
>  	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
>  	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
>  	TRACE_EVENT_FL_WAS_ENABLED_BIT,
> +	TRACE_EVENT_FL_USE_CALL_FILTER_BIT,
>  };
>  
>  /*
> @@ -213,6 +214,7 @@ enum {
>   *  WAS_ENABLED   - Set and stays set when an event was ever enabled
>   *                    (used for module unloading, if a module event is enabled,
>   *                     it is best to clear the buffers that used it).
> + *  USE_CALL_FILTER - For ftrace internal events, don't use file filter
>   */
>  enum {
>  	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
> @@ -220,6 +222,7 @@ enum {
>  	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
>  	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
>  	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
> +	TRACE_EVENT_FL_USE_CALL_FILTER	= (1 << TRACE_EVENT_FL_USE_CALL_FILTER_BIT),
>  };
>  
>  struct ftrace_event_call {
> @@ -238,6 +241,7 @@ struct ftrace_event_call {
>  	 *   bit 2:		failed to apply filter
>  	 *   bit 3:		ftrace internal event (do not enable)
>  	 *   bit 4:		Event was enabled by module
> +	 *   bit 5:		use call filter rather than file filter
>  	 */
>  	int			flags; /* static flags of different events */
>  
> @@ -253,6 +257,8 @@ struct ftrace_subsystem_dir;
>  enum {
>  	FTRACE_EVENT_FL_ENABLED_BIT,
>  	FTRACE_EVENT_FL_RECORDED_CMD_BIT,
> +	FTRACE_EVENT_FL_FILTERED_BIT,
> +	FTRACE_EVENT_FL_NO_SET_FILTER_BIT,
>  	FTRACE_EVENT_FL_SOFT_MODE_BIT,
>  	FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
>  };
> @@ -261,6 +267,8 @@ enum {
>   * Ftrace event file flags:
>   *  ENABLED	  - The event is enabled
>   *  RECORDED_CMD  - The comms should be recorded at sched_switch
> + *  FILTERED	  - The event has a filter attached
> + *  NO_SET_FILTER - Set when filter has error and is to be ignored
>   *  SOFT_MODE     - The event is enabled/disabled by SOFT_DISABLED
>   *  SOFT_DISABLED - When set, do not trace the event (even though its
>   *                   tracepoint may be enabled)
> @@ -268,6 +276,8 @@ enum {
>  enum {
>  	FTRACE_EVENT_FL_ENABLED		= (1 << FTRACE_EVENT_FL_ENABLED_BIT),
>  	FTRACE_EVENT_FL_RECORDED_CMD	= (1 << FTRACE_EVENT_FL_RECORDED_CMD_BIT),
> +	FTRACE_EVENT_FL_FILTERED	= (1 << FTRACE_EVENT_FL_FILTERED_BIT),
> +	FTRACE_EVENT_FL_NO_SET_FILTER	= (1 << FTRACE_EVENT_FL_NO_SET_FILTER_BIT),
>  	FTRACE_EVENT_FL_SOFT_MODE	= (1 << FTRACE_EVENT_FL_SOFT_MODE_BIT),
>  	FTRACE_EVENT_FL_SOFT_DISABLED	= (1 << FTRACE_EVENT_FL_SOFT_DISABLED_BIT),
>  };
> @@ -275,6 +285,7 @@ enum {
>  struct ftrace_event_file {
>  	struct list_head		list;
>  	struct ftrace_event_call	*event_call;
> +	struct event_filter		*filter;
>  	struct dentry			*dir;
>  	struct trace_array		*tr;
>  	struct ftrace_subsystem_dir	*system;
> @@ -310,12 +321,16 @@ struct ftrace_event_file {
>  
>  #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
>  
> -extern void destroy_preds(struct ftrace_event_call *call);
> +extern void destroy_preds(struct ftrace_event_file *file);
> +extern void destroy_call_preds(struct ftrace_event_call *call);
>  extern int filter_match_preds(struct event_filter *filter, void *rec);
> -extern int filter_current_check_discard(struct ring_buffer *buffer,
> -					struct ftrace_event_call *call,
> -					void *rec,
> -					struct ring_buffer_event *event);
> +
> +extern int filter_check_discard(struct ftrace_event_file *file, void *rec,
> +				struct ring_buffer *buffer,
> +				struct ring_buffer_event *event);
> +extern int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
> +				     struct ring_buffer *buffer,
> +				     struct ring_buffer_event *event);
>  
>  enum {
>  	FILTER_OTHER = 0,
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 7fac04e..10bafa9 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -120,7 +120,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.class			= &event_class_syscall_enter,	\
>  		.event.funcs            = &enter_syscall_print_funcs,	\
>  		.data			= (void *)&__syscall_meta_##sname,\
> -		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
> +		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
>  	};								\
>  	static struct ftrace_event_call __used				\
>  	  __attribute__((section("_ftrace_events")))			\
> @@ -134,7 +134,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.class			= &event_class_syscall_exit,	\
>  		.event.funcs		= &exit_syscall_print_funcs,	\
>  		.data			= (void *)&__syscall_meta_##sname,\
> -		.flags			= TRACE_EVENT_FL_CAP_ANY,	\
> +		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
>  	};								\
>  	static struct ftrace_event_call __used				\
>  	  __attribute__((section("_ftrace_events")))			\
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 5c7ab17..52594b2 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -437,9 +437,8 @@ static inline notrace int ftrace_get_offsets_##call(			\
>   *	{ <assign>; }  <-- Here we assign the entries by the __field and
>   *			   __array macros.
>   *
> - *	if (!filter_current_check_discard(buffer, event_call, entry, event))
> - *		trace_nowake_buffer_unlock_commit(buffer,
> - *						   event, irq_flags, pc);
> + *	if (!filter_check_discard(ftrace_file, entry, buffer, event))
> + *		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
>   * }
>   *
>   * static struct trace_event ftrace_event_type_<call> = {
> @@ -553,7 +552,7 @@ ftrace_raw_event_##call(void *__data, proto)				\
>  									\
>  	{ assign; }							\
>  									\
> -	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
> +	if (!filter_check_discard(ftrace_file, entry, buffer, event))	\
>  		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
>  }
>  /*
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 063a92b..489da8b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -235,13 +235,33 @@ void trace_array_put(struct trace_array *this_tr)
>  	mutex_unlock(&trace_types_lock);
>  }
>  
> -int filter_current_check_discard(struct ring_buffer *buffer,
> -				 struct ftrace_event_call *call, void *rec,
> -				 struct ring_buffer_event *event)
> +int filter_check_discard(struct ftrace_event_file *file, void *rec,
> +			 struct ring_buffer *buffer,
> +			 struct ring_buffer_event *event)
>  {
> -	return filter_check_discard(call, rec, buffer, event);
> +	if (unlikely(file->flags & FTRACE_EVENT_FL_FILTERED) &&
> +	    !filter_match_preds(file->filter, rec)) {
> +		ring_buffer_discard_commit(buffer, event);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(filter_check_discard);
> +
> +int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
> +			      struct ring_buffer *buffer,
> +			      struct ring_buffer_event *event)
> +{
> +	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
> +	    !filter_match_preds(call->filter, rec)) {
> +		ring_buffer_discard_commit(buffer, event);
> +		return 1;
> +	}
> +
> +	return 0;
>  }
> -EXPORT_SYMBOL_GPL(filter_current_check_discard);
> +EXPORT_SYMBOL_GPL(call_filter_check_discard);
>  
>  cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
>  {
> @@ -1633,7 +1653,7 @@ trace_function(struct trace_array *tr,
>  	entry->ip			= ip;
>  	entry->parent_ip		= parent_ip;
>  
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		__buffer_unlock_commit(buffer, event);
>  }
>  
> @@ -1717,7 +1737,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
>  
>  	entry->size = trace.nr_entries;
>  
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		__buffer_unlock_commit(buffer, event);
>  
>   out:
> @@ -1819,7 +1839,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>  	trace.entries		= entry->caller;
>  
>  	save_stack_trace_user(&trace);
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		__buffer_unlock_commit(buffer, event);
>  
>   out_drop_count:
> @@ -2011,7 +2031,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
>  	entry->fmt			= fmt;
>  
>  	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
> -	if (!filter_check_discard(call, entry, buffer, event)) {
> +	if (!call_filter_check_discard(call, entry, buffer, event)) {
>  		__buffer_unlock_commit(buffer, event);
>  		ftrace_trace_stack(buffer, flags, 6, pc);
>  	}
> @@ -2066,7 +2086,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
>  
>  	memcpy(&entry->buf, tbuffer, len);
>  	entry->buf[len] = '\0';
> -	if (!filter_check_discard(call, entry, buffer, event)) {
> +	if (!call_filter_check_discard(call, entry, buffer, event)) {
>  		__buffer_unlock_commit(buffer, event);
>  		ftrace_trace_stack(buffer, flags, 6, pc);
>  	}
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index d1cf515..12d1a61 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1007,9 +1007,9 @@ struct filter_pred {
>  
>  extern enum regex_type
>  filter_parse_regex(char *buff, int len, char **search, int *not);
> -extern void print_event_filter(struct ftrace_event_call *call,
> +extern void print_event_filter(struct ftrace_event_file *file,
>  			       struct trace_seq *s);
> -extern int apply_event_filter(struct ftrace_event_call *call,
> +extern int apply_event_filter(struct ftrace_event_file *file,
>  			      char *filter_string);
>  extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
>  					char *filter_string);
> @@ -1020,20 +1020,6 @@ extern int filter_assign_type(const char *type);
>  struct ftrace_event_field *
>  trace_find_event_field(struct ftrace_event_call *call, char *name);
>  
> -static inline int
> -filter_check_discard(struct ftrace_event_call *call, void *rec,
> -		     struct ring_buffer *buffer,
> -		     struct ring_buffer_event *event)
> -{
> -	if (unlikely(call->flags & TRACE_EVENT_FL_FILTERED) &&
> -	    !filter_match_preds(call->filter, rec)) {
> -		ring_buffer_discard_commit(buffer, event);
> -		return 1;
> -	}
> -
> -	return 0;
> -}
> -
>  extern void trace_event_enable_cmd_record(bool enable);
>  extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
>  extern int event_trace_del_tracer(struct trace_array *tr);
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index d594da0..697fb9b 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -78,7 +78,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  	entry->line = f->line;
>  	entry->correct = val == expect;
>  
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		__buffer_unlock_commit(buffer, event);
>  
>   out:
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 368a4d5..043f833 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -989,7 +989,7 @@ static ssize_t
>  event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
>  		  loff_t *ppos)
>  {
> -	struct ftrace_event_call *call;
> +	struct ftrace_event_file *file;
>  	struct trace_seq *s;
>  	int r = -ENODEV;
>  
> @@ -1004,12 +1004,12 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
>  	trace_seq_init(s);
>  
>  	mutex_lock(&event_mutex);
> -	call = event_file_data(filp);
> -	if (call)
> -		print_event_filter(call, s);
> +	file = event_file_data(filp);
> +	if (file)
> +		print_event_filter(file, s);
>  	mutex_unlock(&event_mutex);
>  
> -	if (call)
> +	if (file)
>  		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
>  
>  	kfree(s);
> @@ -1021,7 +1021,7 @@ static ssize_t
>  event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  		   loff_t *ppos)
>  {
> -	struct ftrace_event_call *call;
> +	struct ftrace_event_file *file;
>  	char *buf;
>  	int err = -ENODEV;
>  
> @@ -1039,9 +1039,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
>  	buf[cnt] = '\0';
>  
>  	mutex_lock(&event_mutex);
> -	call = event_file_data(filp);
> -	if (call)
> -		err = apply_event_filter(call, buf);
> +	file = event_file_data(filp);
> +	if (file)
> +		err = apply_event_filter(file, buf);
>  	mutex_unlock(&event_mutex);
>  
>  	free_page((unsigned long) buf);
> @@ -1539,7 +1539,7 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
>  			return -1;
>  		}
>  	}
> -	trace_create_file("filter", 0644, file->dir, call,
> +	trace_create_file("filter", 0644, file->dir, file,
>  			  &ftrace_event_filter_fops);
>  
>  	trace_create_file("format", 0444, file->dir, call,
> @@ -1577,6 +1577,7 @@ static void event_remove(struct ftrace_event_call *call)
>  		if (file->event_call != call)
>  			continue;
>  		ftrace_event_enable_disable(file, 0);
> +		destroy_preds(file);
>  		/*
>  		 * The do_for_each_event_file() is
>  		 * a double loop. After finding the call for this
> @@ -1700,7 +1701,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>  {
>  	event_remove(call);
>  	trace_destroy_fields(call);
> -	destroy_preds(call);
> +	destroy_call_preds(call);
>  }
>  
>  static int probe_remove_event_call(struct ftrace_event_call *call)
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 97daa8c..2468f56 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -637,10 +637,18 @@ static void append_filter_err(struct filter_parse_state *ps,
>  	free_page((unsigned long) buf);
>  }
>  
> +static inline struct event_filter *event_filter(struct ftrace_event_file *file)
> +{
> +	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		return file->event_call->filter;
> +	else
> +		return file->filter;
> +}
> +
>  /* caller must hold event_mutex */
> -void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
> +void print_event_filter(struct ftrace_event_file *file, struct trace_seq *s)
>  {
> -	struct event_filter *filter = call->filter;
> +	struct event_filter *filter = event_filter(file);
>  
>  	if (filter && filter->filter_string)
>  		trace_seq_printf(s, "%s\n", filter->filter_string);
> @@ -766,11 +774,21 @@ static void __free_preds(struct event_filter *filter)
>  	filter->n_preds = 0;
>  }
>  
> -static void filter_disable(struct ftrace_event_call *call)
> +static void call_filter_disable(struct ftrace_event_call *call)
>  {
>  	call->flags &= ~TRACE_EVENT_FL_FILTERED;
>  }
>  
> +static void filter_disable(struct ftrace_event_file *file)
> +{
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		call_filter_disable(call);
> +	else
> +		file->flags &= ~FTRACE_EVENT_FL_FILTERED;
> +}
> +
>  static void __free_filter(struct event_filter *filter)
>  {
>  	if (!filter)
> @@ -781,16 +799,30 @@ static void __free_filter(struct event_filter *filter)
>  	kfree(filter);
>  }
>  
> +void destroy_call_preds(struct ftrace_event_call *call)
> +{
> +	__free_filter(call->filter);
> +	call->filter = NULL;
> +}
> +
> +static void destroy_file_preds(struct ftrace_event_file *file)
> +{
> +	__free_filter(file->filter);
> +	file->filter = NULL;
> +}
> +
>  /*
> - * Called when destroying the ftrace_event_call.
> - * The call is being freed, so we do not need to worry about
> - * the call being currently used. This is for module code removing
> + * Called when destroying the ftrace_event_file.
> + * The file is being freed, so we do not need to worry about
> + * the file being currently used. This is for module code removing
>   * the tracepoints from within it.
>   */
> -void destroy_preds(struct ftrace_event_call *call)
> +void destroy_preds(struct ftrace_event_file *file)
>  {
> -	__free_filter(call->filter);
> -	call->filter = NULL;
> +	if (file->event_call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		destroy_call_preds(file->event_call);
> +	else
> +		destroy_file_preds(file);
>  }
>  
>  static struct event_filter *__alloc_filter(void)
> @@ -825,28 +857,56 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
>  	return 0;
>  }
>  
> -static void filter_free_subsystem_preds(struct event_subsystem *system)
> +static inline void __remove_filter(struct ftrace_event_file *file)
>  {
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	filter_disable(file);
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		remove_filter_string(call->filter);
> +	else
> +		remove_filter_string(file->filter);
> +}
> +
> +static void filter_free_subsystem_preds(struct event_subsystem *system,
> +					struct trace_array *tr)
> +{
> +	struct ftrace_event_file *file;
>  	struct ftrace_event_call *call;
>  
> -	list_for_each_entry(call, &ftrace_events, list) {
> +	list_for_each_entry(file, &tr->events, list) {
> +		call = file->event_call;
>  		if (strcmp(call->class->system, system->name) != 0)
>  			continue;
>  
> -		filter_disable(call);
> -		remove_filter_string(call->filter);
> +		__remove_filter(file);
>  	}
>  }
>  
> -static void filter_free_subsystem_filters(struct event_subsystem *system)
> +static inline void __free_subsystem_filter(struct ftrace_event_file *file)
>  {
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) {
> +		__free_filter(call->filter);
> +		call->filter = NULL;
> +	} else {
> +		__free_filter(file->filter);
> +		file->filter = NULL;
> +	}
> +}
> +
> +static void filter_free_subsystem_filters(struct event_subsystem *system,
> +					  struct trace_array *tr)
> +{
> +	struct ftrace_event_file *file;
>  	struct ftrace_event_call *call;
>  
> -	list_for_each_entry(call, &ftrace_events, list) {
> +	list_for_each_entry(file, &tr->events, list) {
> +		call = file->event_call;
>  		if (strcmp(call->class->system, system->name) != 0)
>  			continue;
> -		__free_filter(call->filter);
> -		call->filter = NULL;
> +		__free_subsystem_filter(file);
>  	}
>  }
>  
> @@ -1617,15 +1677,85 @@ fail:
>  	return err;
>  }
>  
> +static inline void event_set_filtered_flag(struct ftrace_event_file *file)
> +{
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		call->flags |= TRACE_EVENT_FL_FILTERED;
> +	else
> +		file->flags |= FTRACE_EVENT_FL_FILTERED;
> +}
> +
> +static inline void event_set_filter(struct ftrace_event_file *file,
> +				    struct event_filter *filter)
> +{
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		rcu_assign_pointer(call->filter, filter);
> +	else
> +		rcu_assign_pointer(file->filter, filter);
> +}
> +
> +static inline void event_clear_filter(struct ftrace_event_file *file)
> +{
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		RCU_INIT_POINTER(call->filter, NULL);
> +	else
> +		RCU_INIT_POINTER(file->filter, NULL);
> +}
> +
> +static inline void
> +event_set_no_set_filter_flag(struct ftrace_event_file *file)
> +{
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
> +	else
> +		file->flags |= FTRACE_EVENT_FL_NO_SET_FILTER;
> +}
> +
> +static inline void
> +event_clear_no_set_filter_flag(struct ftrace_event_file *file)
> +{
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> +		call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
> +	else
> +		file->flags &= ~FTRACE_EVENT_FL_NO_SET_FILTER;
> +}
> +
> +static inline bool
> +event_no_set_filter_flag(struct ftrace_event_file *file)
> +{
> +	struct ftrace_event_call *call = file->event_call;
> +
> +	if (file->flags & FTRACE_EVENT_FL_NO_SET_FILTER)
> +		return true;
> +
> +	if ((call->flags & TRACE_EVENT_FL_USE_CALL_FILTER) &&
> +	    (call->flags & TRACE_EVENT_FL_NO_SET_FILTER))
> +		return true;
> +
> +	return false;
> +}
> +
>  struct filter_list {
>  	struct list_head	list;
>  	struct event_filter	*filter;
>  };
>  
>  static int replace_system_preds(struct event_subsystem *system,
> +				struct trace_array *tr,
>  				struct filter_parse_state *ps,
>  				char *filter_string)
>  {
> +	struct ftrace_event_file *file;
>  	struct ftrace_event_call *call;
>  	struct filter_list *filter_item;
>  	struct filter_list *tmp;
> @@ -1633,8 +1763,8 @@ static int replace_system_preds(struct event_subsystem *system,
>  	bool fail = true;
>  	int err;
>  
> -	list_for_each_entry(call, &ftrace_events, list) {
> -
> +	list_for_each_entry(file, &tr->events, list) {
> +		call = file->event_call;
>  		if (strcmp(call->class->system, system->name) != 0)
>  			continue;
>  
> @@ -1644,18 +1774,20 @@ static int replace_system_preds(struct event_subsystem *system,
>  		 */
>  		err = replace_preds(call, NULL, ps, filter_string, true);
>  		if (err)
> -			call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
> +			event_set_no_set_filter_flag(file);
>  		else
> -			call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
> +			event_clear_no_set_filter_flag(file);
>  	}
>  
> -	list_for_each_entry(call, &ftrace_events, list) {
> +	list_for_each_entry(file, &tr->events, list) {
>  		struct event_filter *filter;
>  
> +		call = file->event_call;
> +
>  		if (strcmp(call->class->system, system->name) != 0)
>  			continue;
>  
> -		if (call->flags & TRACE_EVENT_FL_NO_SET_FILTER)
> +		if (event_no_set_filter_flag(file))
>  			continue;
>  
>  		filter_item = kzalloc(sizeof(*filter_item), GFP_KERNEL);
> @@ -1676,17 +1808,17 @@ static int replace_system_preds(struct event_subsystem *system,
>  
>  		err = replace_preds(call, filter, ps, filter_string, false);
>  		if (err) {
> -			filter_disable(call);
> +			filter_disable(file);
>  			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
>  			append_filter_err(ps, filter);
>  		} else
> -			call->flags |= TRACE_EVENT_FL_FILTERED;
> +			event_set_filtered_flag(file);
>  		/*
>  		 * Regardless of if this returned an error, we still
>  		 * replace the filter for the call.
>  		 */
> -		filter = call->filter;
> -		rcu_assign_pointer(call->filter, filter_item->filter);
> +		filter = event_filter(file);
> +		event_set_filter(file, filter_item->filter);
>  		filter_item->filter = filter;
>  
>  		fail = false;
> @@ -1816,6 +1948,7 @@ static int create_filter(struct ftrace_event_call *call,
>   * and always remembers @filter_str.
>   */
>  static int create_system_filter(struct event_subsystem *system,
> +				struct trace_array *tr,
>  				char *filter_str, struct event_filter **filterp)
>  {
>  	struct event_filter *filter = NULL;
> @@ -1824,7 +1957,7 @@ static int create_system_filter(struct event_subsystem *system,
>  
>  	err = create_filter_start(filter_str, true, &ps, &filter);
>  	if (!err) {
> -		err = replace_system_preds(system, ps, filter_str);
> +		err = replace_system_preds(system, tr, ps, filter_str);
>  		if (!err) {
>  			/* System filters just show a default message */
>  			kfree(filter->filter_string);
> @@ -1840,20 +1973,25 @@ static int create_system_filter(struct event_subsystem *system,
>  }
>  
>  /* caller must hold event_mutex */
> -int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
> +int apply_event_filter(struct ftrace_event_file *file, char *filter_string)
>  {
> +	struct ftrace_event_call *call = file->event_call;
>  	struct event_filter *filter;
>  	int err;
>  
>  	if (!strcmp(strstrip(filter_string), "0")) {
> -		filter_disable(call);
> -		filter = call->filter;
> +		filter_disable(file);
> +		filter = event_filter(file);
> +
>  		if (!filter)
>  			return 0;
> -		RCU_INIT_POINTER(call->filter, NULL);
> +
> +		event_clear_filter(file);
> +
>  		/* Make sure the filter is not being used */
>  		synchronize_sched();
>  		__free_filter(filter);
> +
>  		return 0;
>  	}
>  
> @@ -1866,14 +2004,15 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
>  	 * string
>  	 */
>  	if (filter) {
> -		struct event_filter *tmp = call->filter;
> +		struct event_filter *tmp;
>  
> +		tmp = event_filter(file);
>  		if (!err)
> -			call->flags |= TRACE_EVENT_FL_FILTERED;
> +			event_set_filtered_flag(file);
>  		else
> -			filter_disable(call);
> +			filter_disable(file);
>  
> -		rcu_assign_pointer(call->filter, filter);
> +		event_set_filter(file, filter);
>  
>  		if (tmp) {
>  			/* Make sure the call is done with the filter */
> @@ -1889,6 +2028,7 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
>  				 char *filter_string)
>  {
>  	struct event_subsystem *system = dir->subsystem;
> +	struct trace_array *tr = dir->tr;
>  	struct event_filter *filter;
>  	int err = 0;
>  
> @@ -1901,18 +2041,18 @@ int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
>  	}
>  
>  	if (!strcmp(strstrip(filter_string), "0")) {
> -		filter_free_subsystem_preds(system);
> +		filter_free_subsystem_preds(system, tr);
>  		remove_filter_string(system->filter);
>  		filter = system->filter;
>  		system->filter = NULL;
>  		/* Ensure all filters are no longer used */
>  		synchronize_sched();
> -		filter_free_subsystem_filters(system);
> +		filter_free_subsystem_filters(system, tr);
>  		__free_filter(filter);
>  		goto out_unlock;
>  	}
>  
> -	err = create_system_filter(system, filter_string, &filter);
> +	err = create_system_filter(system, tr, filter_string, &filter);
>  	if (filter) {
>  		/*
>  		 * No event actually uses the system filter
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index d21a746..7c3e3e7 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -180,7 +180,7 @@ struct ftrace_event_call __used event_##call = {			\
>  	.event.type		= etype,				\
>  	.class			= &event_class_ftrace_##call,		\
>  	.print_fmt		= print,				\
> -	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE,		\
> +	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE | TRACE_EVENT_FL_USE_CALL_FILTER, \
>  };									\
>  struct ftrace_event_call __used						\
>  __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index e08c030..80387d1 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -270,7 +270,7 @@ int __trace_graph_entry(struct trace_array *tr,
>  		return 0;
>  	entry	= ring_buffer_event_data(event);
>  	entry->graph_ent			= *trace;
> -	if (!filter_current_check_discard(buffer, call, entry, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		__buffer_unlock_commit(buffer, event);
>  
>  	return 1;
> @@ -385,7 +385,7 @@ void __trace_graph_return(struct trace_array *tr,
>  		return;
>  	entry	= ring_buffer_event_data(event);
>  	entry->ret				= *trace;
> -	if (!filter_current_check_discard(buffer, call, entry, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		__buffer_unlock_commit(buffer, event);
>  }
>  
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 243f683..dae9541 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -835,7 +835,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
>  	entry->ip = (unsigned long)tp->rp.kp.addr;
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
>  
> -	if (!filter_current_check_discard(buffer, call, entry, event))
> +	if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_buffer_unlock_commit_regs(buffer, event,
>  						irq_flags, pc, regs);
>  }
> @@ -884,7 +884,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	entry->ret_ip = (unsigned long)ri->ret_addr;
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
>  
> -	if (!filter_current_check_discard(buffer, call, entry, event))
> +	if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_buffer_unlock_commit_regs(buffer, event,
>  						irq_flags, pc, regs);
>  }
> diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
> index b3dcfb2..0abd9b8 100644
> --- a/kernel/trace/trace_mmiotrace.c
> +++ b/kernel/trace/trace_mmiotrace.c
> @@ -323,7 +323,7 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
>  	entry	= ring_buffer_event_data(event);
>  	entry->rw			= *rw;
>  
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		trace_buffer_unlock_commit(buffer, event, 0, pc);
>  }
>  
> @@ -353,7 +353,7 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
>  	entry	= ring_buffer_event_data(event);
>  	entry->map			= *map;
>  
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		trace_buffer_unlock_commit(buffer, event, 0, pc);
>  }
>  
> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> index 4e98e3b..3f34dc9 100644
> --- a/kernel/trace/trace_sched_switch.c
> +++ b/kernel/trace/trace_sched_switch.c
> @@ -45,7 +45,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
>  	entry->next_state		= next->state;
>  	entry->next_cpu	= task_cpu(next);
>  
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		trace_buffer_unlock_commit(buffer, event, flags, pc);
>  }
>  
> @@ -101,7 +101,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
>  	entry->next_state		= wakee->state;
>  	entry->next_cpu			= task_cpu(wakee);
>  
> -	if (!filter_check_discard(call, entry, buffer, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		trace_buffer_unlock_commit(buffer, event, flags, pc);
>  }
>  
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 559329d..32644ee 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -336,8 +336,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	entry->nr = syscall_nr;
>  	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
>  
> -	if (!filter_current_check_discard(buffer, sys_data->enter_event,
> -					  entry, event))
> +	if (!call_filter_check_discard(sys_data->enter_event, entry,
> +				       buffer, event))
>  		trace_current_buffer_unlock_commit(buffer, event,
>  						   irq_flags, pc);
>  }
> @@ -377,8 +377,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  	entry->nr = syscall_nr;
>  	entry->ret = syscall_get_return_value(current, regs);
>  
> -	if (!filter_current_check_discard(buffer, sys_data->exit_event,
> -					  entry, event))
> +	if (!call_filter_check_discard(sys_data->exit_event, entry,
> +				       buffer, event))
>  		trace_current_buffer_unlock_commit(buffer, event,
>  						   irq_flags, pc);
>  }
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 272261b..b6dcc42 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -128,6 +128,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
>  	if (is_ret)
>  		tu->consumer.ret_handler = uretprobe_dispatcher;
>  	init_trace_uprobe_filter(&tu->filter);
> +	tu->call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
>  	return tu;
>  
>  error:
> @@ -561,7 +562,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
>  
> -	if (!filter_current_check_discard(buffer, call, entry, event))
> +	if (!call_filter_check_discard(call, entry, buffer, event))
>  		trace_buffer_unlock_commit(buffer, event, 0, 0);
>  }
>  
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index ec85d48..31ea4b4 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -533,11 +533,11 @@ static inline int ftrace_force_update(void) { return 0; }
>  static inline void ftrace_disable_daemon(void) { }
>  static inline void ftrace_enable_daemon(void) { }
>  static inline void ftrace_release_mod(struct module *mod) {}
> -static inline int register_ftrace_command(struct ftrace_func_command *cmd)
> +static inline __init int register_ftrace_command(struct ftrace_func_command *cmd)
>  {
>  	return -EINVAL;
>  }
> -static inline int unregister_ftrace_command(char *cmd_name)
> +static inline __init int unregister_ftrace_command(char *cmd_name)
>  {
>  	return -EINVAL;
>  }
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 080b7d4..22fa556 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3307,7 +3307,11 @@ void unregister_ftrace_function_probe_all(char *glob)
>  static LIST_HEAD(ftrace_commands);
>  static DEFINE_MUTEX(ftrace_cmd_mutex);
>  
> -int register_ftrace_command(struct ftrace_func_command *cmd)
> +/*
> + * Currently we only register ftrace commands from __init, so mark this
> + * __init too.
> + */
> +__init int register_ftrace_command(struct ftrace_func_command *cmd)
>  {
>  	struct ftrace_func_command *p;
>  	int ret = 0;
> @@ -3326,7 +3330,11 @@ int register_ftrace_command(struct ftrace_func_command *cmd)
>  	return ret;
>  }
>  
> -int unregister_ftrace_command(struct ftrace_func_command *cmd)
> +/*
> + * Currently we only unregister ftrace commands from __init, so mark
> + * this __init too.
> + */
> +__init int unregister_ftrace_command(struct ftrace_func_command *cmd)
>  {
>  	struct ftrace_func_command *p, *n;
>  	int ret = -ENODEV;
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 489da8b..f9fa42b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -5477,12 +5477,12 @@ static struct ftrace_func_command ftrace_snapshot_cmd = {
>  	.func			= ftrace_trace_snapshot_callback,
>  };
>  
> -static int register_snapshot_cmd(void)
> +static __init int register_snapshot_cmd(void)
>  {
>  	return register_ftrace_command(&ftrace_snapshot_cmd);
>  }
>  #else
> -static inline int register_snapshot_cmd(void) { return 0; }
> +static inline __init int register_snapshot_cmd(void) { return 0; }
>  #endif /* defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE) */
>  
>  struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 10bafa9..2ef31bf 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -120,7 +120,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.class			= &event_class_syscall_enter,	\
>  		.event.funcs            = &enter_syscall_print_funcs,	\
>  		.data			= (void *)&__syscall_meta_##sname,\
> -		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
> +		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
>  	};								\
>  	static struct ftrace_event_call __used				\
>  	  __attribute__((section("_ftrace_events")))			\
> @@ -134,7 +134,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  		.class			= &event_class_syscall_exit,	\
>  		.event.funcs		= &exit_syscall_print_funcs,	\
>  		.data			= (void *)&__syscall_meta_##sname,\
> -		.flags			= TRACE_EVENT_FL_CAP_ANY | TRACE_EVENT_FL_USE_CALL_FILTER,\
> +		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
>  	};								\
>  	static struct ftrace_event_call __used				\
>  	  __attribute__((section("_ftrace_events")))			\
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 12d1a61..9c27cda 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -192,8 +192,8 @@ struct trace_array {
>  #ifdef CONFIG_FTRACE_SYSCALLS
>  	int			sys_refcount_enter;
>  	int			sys_refcount_exit;
> -	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
> -	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
> +	struct ftrace_event_file *enter_syscall_files[NR_syscalls];
> +	struct ftrace_event_file *exit_syscall_files[NR_syscalls];
>  #endif
>  	int			stop_count;
>  	int			clock_id;
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 32644ee..e4b6d11 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -302,6 +302,7 @@ static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
>  static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  {
>  	struct trace_array *tr = data;
> +	struct ftrace_event_file *ftrace_file;
>  	struct syscall_trace_enter *entry;
>  	struct syscall_metadata *sys_data;
>  	struct ring_buffer_event *event;
> @@ -314,7 +315,13 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	syscall_nr = trace_get_syscall_nr(current, regs);
>  	if (syscall_nr < 0)
>  		return;
> -	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
> +
> +	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE) */
> +	ftrace_file = rcu_dereference_sched(tr->enter_syscall_files[syscall_nr]);
> +	if (!ftrace_file)
> +		return;
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
>  		return;
>  
>  	sys_data = syscall_nr_to_meta(syscall_nr);
> @@ -336,8 +343,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	entry->nr = syscall_nr;
>  	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
>  
> -	if (!call_filter_check_discard(sys_data->enter_event, entry,
> -				       buffer, event))
> +	if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_current_buffer_unlock_commit(buffer, event,
>  						   irq_flags, pc);
>  }
> @@ -345,6 +351,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  {
>  	struct trace_array *tr = data;
> +	struct ftrace_event_file *ftrace_file;
>  	struct syscall_trace_exit *entry;
>  	struct syscall_metadata *sys_data;
>  	struct ring_buffer_event *event;
> @@ -356,7 +363,13 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  	syscall_nr = trace_get_syscall_nr(current, regs);
>  	if (syscall_nr < 0)
>  		return;
> -	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
> +
> +	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE()) */
> +	ftrace_file = rcu_dereference_sched(tr->exit_syscall_files[syscall_nr]);
> +	if (!ftrace_file)
> +		return;
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
>  		return;
>  
>  	sys_data = syscall_nr_to_meta(syscall_nr);
> @@ -377,8 +390,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  	entry->nr = syscall_nr;
>  	entry->ret = syscall_get_return_value(current, regs);
>  
> -	if (!call_filter_check_discard(sys_data->exit_event, entry,
> -				       buffer, event))
> +	if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_current_buffer_unlock_commit(buffer, event,
>  						   irq_flags, pc);
>  }
> @@ -397,7 +409,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
>  	if (!tr->sys_refcount_enter)
>  		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
>  	if (!ret) {
> -		set_bit(num, tr->enabled_enter_syscalls);
> +		rcu_assign_pointer(tr->enter_syscall_files[num], file);
>  		tr->sys_refcount_enter++;
>  	}
>  	mutex_unlock(&syscall_trace_lock);
> @@ -415,10 +427,15 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
>  		return;
>  	mutex_lock(&syscall_trace_lock);
>  	tr->sys_refcount_enter--;
> -	clear_bit(num, tr->enabled_enter_syscalls);
> +	rcu_assign_pointer(tr->enter_syscall_files[num], NULL);
>  	if (!tr->sys_refcount_enter)
>  		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
>  	mutex_unlock(&syscall_trace_lock);
> +	/*
> +	 * Callers expect the event to be completely disabled on
> +	 * return, so wait for current handlers to finish.
> +	 */
> +	synchronize_sched();
>  }
>  
>  static int reg_event_syscall_exit(struct ftrace_event_file *file,
> @@ -435,7 +452,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
>  	if (!tr->sys_refcount_exit)
>  		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
>  	if (!ret) {
> -		set_bit(num, tr->enabled_exit_syscalls);
> +		rcu_assign_pointer(tr->exit_syscall_files[num], file);
>  		tr->sys_refcount_exit++;
>  	}
>  	mutex_unlock(&syscall_trace_lock);
> @@ -453,10 +470,15 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
>  		return;
>  	mutex_lock(&syscall_trace_lock);
>  	tr->sys_refcount_exit--;
> -	clear_bit(num, tr->enabled_exit_syscalls);
> +	rcu_assign_pointer(tr->exit_syscall_files[num], NULL);
>  	if (!tr->sys_refcount_exit)
>  		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
>  	mutex_unlock(&syscall_trace_lock);
> +	/*
> +	 * Callers expect the event to be completely disabled on
> +	 * return, so wait for current handlers to finish.
> +	 */
> +	synchronize_sched();
>  }
>  
>  static int __init init_syscall_trace(struct ftrace_event_call *call)
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f9fa42b..eaacd3a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -6276,6 +6276,17 @@ void trace_init_global_iter(struct trace_iterator *iter)
>  	iter->trace = iter->tr->current_trace;
>  	iter->cpu_file = RING_BUFFER_ALL_CPUS;
>  	iter->trace_buffer = &global_trace.trace_buffer;
> +
> +	if (iter->trace && iter->trace->open)
> +		iter->trace->open(iter);
> +
> +	/* Annotate start of buffers if we had overruns */
> +	if (ring_buffer_overruns(iter->trace_buffer->buffer))
> +		iter->iter_flags |= TRACE_FILE_ANNOTATE;
> +
> +	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
> +	if (trace_clocks[iter->tr->clock_id].in_ns)
> +		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
>  }
>  
>  void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index eaacd3a..2a595cf 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2987,6 +2987,11 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> +bool tracing_is_disabled(void)
> +{
> +	return (tracing_disabled) ? true: false;
> +}
> +
>  /*
>   * Open and update trace_array ref count.
>   * Must have the current trace_array passed to it.
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 9c27cda..4388e16 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -514,6 +514,7 @@ void tracing_reset_online_cpus(struct trace_buffer *buf);
>  void tracing_reset_current(int cpu);
>  void tracing_reset_all_online_cpus(void);
>  int tracing_open_generic(struct inode *inode, struct file *filp);
> +bool tracing_is_disabled(void);
>  struct dentry *trace_create_file(const char *name,
>  				 umode_t mode,
>  				 struct dentry *parent,
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 043f833..f919a2e 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1062,6 +1062,9 @@ static int subsystem_open(struct inode *inode, struct file *filp)
>  	struct trace_array *tr;
>  	int ret;
>  
> +	if (tracing_is_disabled())
> +		return -ENODEV;
> +
>  	/* Make sure the system still exists */
>  	mutex_lock(&trace_types_lock);
>  	mutex_lock(&event_mutex);
> @@ -1108,6 +1111,9 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>  	struct trace_array *tr = inode->i_private;
>  	int ret;
>  
> +	if (tracing_is_disabled())
> +		return -ENODEV;
> +
>  	if (trace_array_get(tr) < 0)
>  		return -ENODEV;
>  
> @@ -1124,11 +1130,12 @@ static int system_tr_open(struct inode *inode, struct file *filp)
>  	if (ret < 0) {
>  		trace_array_put(tr);
>  		kfree(dir);
> +		return ret;
>  	}
>  
>  	filp->private_data = dir;
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int subsystem_release(struct inode *inode, struct file *file)
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 672ddc4..d4e98d1 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -501,7 +501,6 @@ void tracing_snapshot_alloc(void);
>  
>  extern void tracing_start(void);
>  extern void tracing_stop(void);
> -extern void ftrace_off_permanent(void);
>  
>  static inline __printf(1, 2)
>  void ____trace_printk_check_format(const char *fmt, ...)
> @@ -639,7 +638,6 @@ extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
>  #else
>  static inline void tracing_start(void) { }
>  static inline void tracing_stop(void) { }
> -static inline void ftrace_off_permanent(void) { }
>  static inline void trace_dump_stack(int skip) { }
>  
>  static inline void tracing_on(void) { }
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 2a595cf..d72a15c 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1284,21 +1284,6 @@ int is_tracing_stopped(void)
>  }
>  
>  /**
> - * ftrace_off_permanent - disable all ftrace code permanently
> - *
> - * This should only be called when a serious anomally has
> - * been detected.  This will turn off the function tracing,
> - * ring buffers, and other tracing utilites. It takes no
> - * locks and can be called from any context.
> - */
> -void ftrace_off_permanent(void)
> -{
> -	tracing_disabled = 1;
> -	ftrace_stop();
> -	tracing_off_permanent();
> -}
> -
> -/**
>   * tracing_start - quick start of the tracer
>   *
>   * If tracing is enabled but was stopped by tracing_stop,
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 4388e16..11a04d6 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -712,6 +712,8 @@ extern unsigned long trace_flags;
>  #define TRACE_GRAPH_PRINT_PROC          0x8
>  #define TRACE_GRAPH_PRINT_DURATION      0x10
>  #define TRACE_GRAPH_PRINT_ABS_TIME      0x20
> +#define TRACE_GRAPH_PRINT_FILL_SHIFT	28
> +#define TRACE_GRAPH_PRINT_FILL_MASK	(0x3 << TRACE_GRAPH_PRINT_FILL_SHIFT)
>  
>  extern enum print_line_t
>  print_graph_function_flags(struct trace_iterator *iter, u32 flags);
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 80387d1..0b99120 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -82,9 +82,9 @@ static struct trace_array *graph_array;
>   * to fill in space into DURATION column.
>   */
>  enum {
> -	DURATION_FILL_FULL  = -1,
> -	DURATION_FILL_START = -2,
> -	DURATION_FILL_END   = -3,
> +	FLAGS_FILL_FULL  = 1 << TRACE_GRAPH_PRINT_FILL_SHIFT,
> +	FLAGS_FILL_START = 2 << TRACE_GRAPH_PRINT_FILL_SHIFT,
> +	FLAGS_FILL_END   = 3 << TRACE_GRAPH_PRINT_FILL_SHIFT,
>  };
>  
>  static enum print_line_t
> @@ -702,7 +702,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
>  	}
>  
>  	/* No overhead */
> -	ret = print_graph_duration(DURATION_FILL_START, s, flags);
> +	ret = print_graph_duration(0, s, flags | FLAGS_FILL_START);
>  	if (ret != TRACE_TYPE_HANDLED)
>  		return ret;
>  
> @@ -714,7 +714,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	ret = print_graph_duration(DURATION_FILL_END, s, flags);
> +	ret = print_graph_duration(0, s, flags | FLAGS_FILL_END);
>  	if (ret != TRACE_TYPE_HANDLED)
>  		return ret;
>  
> @@ -779,14 +779,14 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
>  			return TRACE_TYPE_HANDLED;
>  
>  	/* No real adata, just filling the column with spaces */
> -	switch (duration) {
> -	case DURATION_FILL_FULL:
> +	switch (flags & TRACE_GRAPH_PRINT_FILL_MASK) {
> +	case FLAGS_FILL_FULL:
>  		ret = trace_seq_puts(s, "              |  ");
>  		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
> -	case DURATION_FILL_START:
> +	case FLAGS_FILL_START:
>  		ret = trace_seq_puts(s, "  ");
>  		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
> -	case DURATION_FILL_END:
> +	case FLAGS_FILL_END:
>  		ret = trace_seq_puts(s, " |");
>  		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
>  	}
> @@ -902,7 +902,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
>  	}
>  
>  	/* No time */
> -	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
> +	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
>  	if (ret != TRACE_TYPE_HANDLED)
>  		return ret;
>  
> @@ -1222,7 +1222,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	/* No time */
> -	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
> +	ret = print_graph_duration(0, s, flags | FLAGS_FILL_FULL);
>  	if (ret != TRACE_TYPE_HANDLED)
>  		return ret;
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 11a04d6..7ca1993 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -192,8 +192,8 @@ struct trace_array {
>  #ifdef CONFIG_FTRACE_SYSCALLS
>  	int			sys_refcount_enter;
>  	int			sys_refcount_exit;
> -	struct ftrace_event_file *enter_syscall_files[NR_syscalls];
> -	struct ftrace_event_file *exit_syscall_files[NR_syscalls];
> +	struct ftrace_event_file __rcu *enter_syscall_files[NR_syscalls];
> +	struct ftrace_event_file __rcu *exit_syscall_files[NR_syscalls];
>  #endif
>  	int			stop_count;
>  	int			clock_id;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
