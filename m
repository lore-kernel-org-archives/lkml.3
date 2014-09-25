Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaIYJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:27:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39856 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaIYJ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:27:09 -0400
Date: Thu, 25 Sep 2014 02:26:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Matt Turner <mattst88@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?utf-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Fabian Frederick <fabf@skynet.be>, Tejun Heo <tj@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        David Howells <dhowells@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        Peter Foley <pefoley2@pefoley.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andi Kleen <ak@linux.intel.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Alexei Starovoitov <ast@plumgrid.com>, Lubomir Rintel <lkundrak@v3.sk>,
        Al Viro <viro@zeniv.linux.org.uk>, Dan Streetman <ddstreet@ieee.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] rcu: Remove redundant TREE_PREEMPT_RCU config option
Message-ID: <20140925092645.GK4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1411408895-22238-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411408895-22238-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092509-0928-0000-0000-00000527C4D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 02:00:48PM -0400, Pranith Kumar wrote:
> This patch touches various files in one go. Please let me know if you want these
> split up. (doc, code, tests?)
> 
> PREEMPT_RCU and TREE_PREEMPT_RCU serve the same function after TINY_PREEMPT_RCU
> has been removed. This patch removes TREE_PREEMPT_RCU and uses PREEMPT_RCU
> config option in its place.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Queued, thank you!

Ah, I had forgotten about the old-version stuff.  That was put in place
to support testing versions of Linux predating the torture tests.  But
it is in place, so need not be kept going forward.

							Thanx, Paul

> ---
>  Documentation/RCU/rcu.txt                          |  4 ++--
>  Documentation/RCU/stallwarn.txt                    |  8 ++++----
>  Documentation/RCU/trace.txt                        |  4 ++--
>  Documentation/RCU/whatisRCU.txt                    |  2 +-
>  include/linux/init_task.h                          |  2 +-
>  include/linux/rcupdate.h                           |  6 +++---
>  include/linux/sched.h                              |  4 ++--
>  include/trace/events/rcu.h                         |  4 ++--
>  init/Kconfig                                       | 22 ++++++++--------------
>  kernel/rcu/Makefile                                |  2 +-
>  kernel/rcu/tree.h                                  | 10 +++++-----
>  kernel/rcu/tree_plugin.h                           |  6 +++---
>  kernel/rcu/update.c                                |  2 +-
>  lib/Kconfig.debug                                  |  2 +-
>  .../selftests/rcutorture/configs/rcu/TREE01        |  2 +-
>  .../selftests/rcutorture/configs/rcu/TREE02        |  2 +-
>  .../selftests/rcutorture/configs/rcu/TREE02-T      |  2 +-
>  .../selftests/rcutorture/configs/rcu/TREE03        |  2 +-
>  .../selftests/rcutorture/configs/rcu/TREE08        |  2 +-
>  .../selftests/rcutorture/configs/rcu/TREE08-T      |  2 +-
>  .../selftests/rcutorture/configs/rcu/TREE09        |  2 +-
>  .../configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP           |  2 +-
>  .../configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp           |  2 +-
>  .../configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp           |  2 +-
>  .../configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP           |  2 +-
>  .../configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp           |  2 +-
>  .../configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP          |  2 +-
>  .../configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp          |  2 +-
>  .../configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp          |  2 +-
>  .../configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP          |  2 +-
>  .../configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp          |  2 +-
>  .../configs/rcu/v3.12/P6---t-nh-SD-smp-hp          |  2 +-
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP          |  2 +-
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all      |  2 +-
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none     |  2 +-
>  .../configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp          |  2 +-
>  .../configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP           |  2 +-
>  .../configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp           |  2 +-
>  .../configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp           |  2 +-
>  .../configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP           |  2 +-
>  .../configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp           |  2 +-
>  .../configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP           |  2 +-
>  .../configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp           |  2 +-
>  .../configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp           |  2 +-
>  .../configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP           |  2 +-
>  .../configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp           |  2 +-
>  .../testing/selftests/rcutorture/doc/TINY_RCU.txt  |  2 +-
>  .../selftests/rcutorture/doc/TREE_RCU-kconfig.txt  | 10 +++++-----
>  48 files changed, 74 insertions(+), 80 deletions(-)
> 
> diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
> index bf77833..745f429 100644
> --- a/Documentation/RCU/rcu.txt
> +++ b/Documentation/RCU/rcu.txt
> @@ -36,7 +36,7 @@ o	How can the updater tell when a grace period has completed
>  	executed in user mode, or executed in the idle loop, we can
>  	safely free up that item.
> 
> -	Preemptible variants of RCU (CONFIG_TREE_PREEMPT_RCU) get the
> +	Preemptible variants of RCU (CONFIG_PREEMPT_RCU) get the
>  	same effect, but require that the readers manipulate CPU-local
>  	counters.  These counters allow limited types of blocking within
>  	RCU read-side critical sections.  SRCU also uses CPU-local
> @@ -81,7 +81,7 @@ o	I hear that RCU is patented?  What is with that?
>  o	I hear that RCU needs work in order to support realtime kernels?
> 
>  	This work is largely completed.  Realtime-friendly RCU can be
> -	enabled via the CONFIG_TREE_PREEMPT_RCU kernel configuration
> +	enabled via the CONFIG_PREEMPT_RCU kernel configuration
>  	parameter.  However, work is in progress for enabling priority
>  	boosting of preempted RCU read-side critical sections.	This is
>  	needed if you have CPU-bound realtime threads.
> diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
> index 1560efb..ed186a9 100644
> --- a/Documentation/RCU/stallwarn.txt
> +++ b/Documentation/RCU/stallwarn.txt
> @@ -71,7 +71,7 @@ This message indicates that CPU 5 detected that it was causing a stall,
>  and that the stall was affecting RCU-sched.  This message will normally be
>  followed by a stack dump of the offending CPU.  On TREE_RCU kernel builds,
>  RCU and RCU-sched are implemented by the same underlying mechanism,
> -while on TREE_PREEMPT_RCU kernel builds, RCU is instead implemented
> +while on PREEMPT_RCU kernel builds, RCU is instead implemented
>  by rcu_preempt_state.
> 
>  On the other hand, if the offending CPU fails to print out a stall-warning
> @@ -83,7 +83,7 @@ INFO: rcu_bh_state detected stalls on CPUs/tasks: { 3 5 } (detected by 2, 2502 j
>  This message indicates that CPU 2 detected that CPUs 3 and 5 were both
>  causing stalls, and that the stall was affecting RCU-bh.  This message
>  will normally be followed by stack dumps for each CPU.  Please note that
> -TREE_PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
> +PREEMPT_RCU builds can be stalled by tasks as well as by CPUs,
>  and that the tasks will be indicated by PID, for example, "P3421".
>  It is even possible for a rcu_preempt_state stall to be caused by both
>  CPUs -and- tasks, in which case the offending CPUs and tasks will all
> @@ -199,10 +199,10 @@ o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
>  o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
>  	is running at a higher priority than the RCU softirq threads.
>  	This will prevent RCU callbacks from ever being invoked,
> -	and in a CONFIG_TREE_PREEMPT_RCU kernel will further prevent
> +	and in a CONFIG_PREEMPT_RCU kernel will further prevent
>  	RCU grace periods from ever completing.  Either way, the
>  	system will eventually run out of memory and hang.  In the
> -	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
> +	CONFIG_PREEMPT_RCU case, you might see stall-warning
>  	messages.
> 
>  o	A hardware or software issue shuts off the scheduler-clock
> diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
> index 910870b..b63b9bb 100644
> --- a/Documentation/RCU/trace.txt
> +++ b/Documentation/RCU/trace.txt
> @@ -8,7 +8,7 @@ The following sections describe the debugfs files and formats, first
>  for rcutree and next for rcutiny.
> 
> 
> -CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
> +CONFIG_TREE_RCU and CONFIG_PREEMPT_RCU debugfs Files and Formats
> 
>  These implementations of RCU provide several debugfs directories under the
>  top-level directory "rcu":
> @@ -18,7 +18,7 @@ rcu/rcu_preempt
>  rcu/rcu_sched
> 
>  Each directory contains files for the corresponding flavor of RCU.
> -Note that rcu/rcu_preempt is only present for CONFIG_TREE_PREEMPT_RCU.
> +Note that rcu/rcu_preempt is only present for CONFIG_PREEMPT_RCU.
>  For CONFIG_TREE_RCU, the RCU flavor maps onto the RCU-sched flavor,
>  so that activity for both appears in rcu/rcu_sched.
> 
> diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
> index e48c57f..88dfce1 100644
> --- a/Documentation/RCU/whatisRCU.txt
> +++ b/Documentation/RCU/whatisRCU.txt
> @@ -137,7 +137,7 @@ rcu_read_lock()
>  	Used by a reader to inform the reclaimer that the reader is
>  	entering an RCU read-side critical section.  It is illegal
>  	to block while in an RCU read-side critical section, though
> -	kernels built with CONFIG_TREE_PREEMPT_RCU can preempt RCU
> +	kernels built with CONFIG_PREEMPT_RCU can preempt RCU
>  	read-side critical sections.  Any RCU-protected data structure
>  	accessed during an RCU read-side critical section is guaranteed to
>  	remain unreclaimed for the full duration of that critical section.
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 77fc43f..d996aef 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -102,7 +102,7 @@ extern struct group_info init_groups;
>  #define INIT_IDS
>  #endif
> 
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> +#ifdef CONFIG_PREEMPT_RCU
>  #define INIT_TASK_RCU_TREE_PREEMPT()					\
>  	.rcu_blocked_node = NULL,
>  #else
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index a4a819f..295bb45 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -57,7 +57,7 @@ enum rcutorture_type {
>  	INVALID_RCU_FLAVOR
>  };
> 
> -#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> +#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
>  void rcutorture_get_gp_data(enum rcutorture_type test_type, int *flags,
>  			    unsigned long *gpnum, unsigned long *completed);
>  void rcutorture_record_test_transition(void);
> @@ -365,7 +365,7 @@ typedef void call_rcu_func_t(struct rcu_head *head,
>  			     void (*func)(struct rcu_head *head));
>  void wait_rcu_gp(call_rcu_func_t crf);
> 
> -#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> +#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
>  #include <linux/rcutree.h>
>  #elif defined(CONFIG_TINY_RCU)
>  #include <linux/rcutiny.h>
> @@ -852,7 +852,7 @@ static inline void rcu_preempt_sleep_check(void)
>   *
>   * In non-preemptible RCU implementations (TREE_RCU and TINY_RCU),
>   * it is illegal to block while in an RCU read-side critical section.
> - * In preemptible RCU implementations (TREE_PREEMPT_RCU) in CONFIG_PREEMPT
> + * In preemptible RCU implementations (PREEMPT_RCU) in CONFIG_PREEMPT
>   * kernel builds, RCU read-side critical sections may be preempted,
>   * but explicit blocking is illegal.  Finally, in preemptible RCU
>   * implementations in real-time (with -rt patchset) kernel builds, RCU
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 42888d7..bce6f01 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1274,9 +1274,9 @@ struct task_struct {
>  	union rcu_special rcu_read_unlock_special;
>  	struct list_head rcu_node_entry;
>  #endif /* #ifdef CONFIG_PREEMPT_RCU */
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> +#ifdef CONFIG_PREEMPT_RCU
>  	struct rcu_node *rcu_blocked_node;
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +#endif /* #ifdef CONFIG_PREEMPT_RCU */
>  #ifdef CONFIG_TASKS_RCU
>  	unsigned long rcu_tasks_nvcsw;
>  	bool rcu_tasks_holdout;
> diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
> index 9b56f37..aa8e5ee 100644
> --- a/include/trace/events/rcu.h
> +++ b/include/trace/events/rcu.h
> @@ -36,7 +36,7 @@ TRACE_EVENT(rcu_utilization,
> 
>  #ifdef CONFIG_RCU_TRACE
> 
> -#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> +#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
> 
>  /*
>   * Tracepoint for grace-period events.  Takes a string identifying the
> @@ -345,7 +345,7 @@ TRACE_EVENT(rcu_fqs,
>  		  __entry->cpu, __entry->qsevent)
>  );
> 
> -#endif /* #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) */
> +#endif /* #if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU) */
> 
>  /*
>   * Tracepoint for dyntick-idle entry/exit events.  These take a string
> diff --git a/init/Kconfig b/init/Kconfig
> index 8a2b97c..ef97e9b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -477,7 +477,7 @@ config TREE_RCU
>  	  thousands of CPUs.  It also scales down nicely to
>  	  smaller systems.
> 
> -config TREE_PREEMPT_RCU
> +config PREEMPT_RCU
>  	bool "Preemptible tree-based hierarchical RCU"
>  	depends on PREEMPT
>  	select IRQ_WORK
> @@ -501,12 +501,6 @@ config TINY_RCU
> 
>  endchoice
> 
> -config PREEMPT_RCU
> -	def_bool TREE_PREEMPT_RCU
> -	help
> -	  This option enables preemptible-RCU code that is common between
> -	  TREE_PREEMPT_RCU and, in the old days, TINY_PREEMPT_RCU.
> -
>  config TASKS_RCU
>  	bool "Task_based RCU implementation using voluntary context switch"
>  	default n
> @@ -518,7 +512,7 @@ config TASKS_RCU
>  	  If unsure, say N.
> 
>  config RCU_STALL_COMMON
> -	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
> +	def_bool ( TREE_RCU || PREEMPT_RCU || RCU_TRACE )
>  	help
>  	  This option enables RCU CPU stall code that is common between
>  	  the TINY and TREE variants of RCU.  The purpose is to allow
> @@ -576,7 +570,7 @@ config RCU_FANOUT
>  	int "Tree-based hierarchical RCU fanout value"
>  	range 2 64 if 64BIT
>  	range 2 32 if !64BIT
> -	depends on TREE_RCU || TREE_PREEMPT_RCU
> +	depends on TREE_RCU || PREEMPT_RCU
>  	default 64 if 64BIT
>  	default 32 if !64BIT
>  	help
> @@ -596,7 +590,7 @@ config RCU_FANOUT_LEAF
>  	int "Tree-based hierarchical RCU leaf-level fanout value"
>  	range 2 RCU_FANOUT if 64BIT
>  	range 2 RCU_FANOUT if !64BIT
> -	depends on TREE_RCU || TREE_PREEMPT_RCU
> +	depends on TREE_RCU || PREEMPT_RCU
>  	default 16
>  	help
>  	  This option controls the leaf-level fanout of hierarchical
> @@ -621,7 +615,7 @@ config RCU_FANOUT_LEAF
> 
>  config RCU_FANOUT_EXACT
>  	bool "Disable tree-based hierarchical RCU auto-balancing"
> -	depends on TREE_RCU || TREE_PREEMPT_RCU
> +	depends on TREE_RCU || PREEMPT_RCU
>  	default n
>  	help
>  	  This option forces use of the exact RCU_FANOUT value specified,
> @@ -652,11 +646,11 @@ config RCU_FAST_NO_HZ
>  	  Say N if you are unsure.
> 
>  config TREE_RCU_TRACE
> -	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
> +	def_bool RCU_TRACE && ( TREE_RCU || PREEMPT_RCU )
>  	select DEBUG_FS
>  	help
>  	  This option provides tracing for the TREE_RCU and
> -	  TREE_PREEMPT_RCU implementations, permitting Makefile to
> +	  PREEMPT_RCU implementations, permitting Makefile to
>  	  trivially select kernel/rcutree_trace.c.
> 
>  config RCU_BOOST
> @@ -716,7 +710,7 @@ config RCU_BOOST_DELAY
> 
>  config RCU_NOCB_CPU
>  	bool "Offload RCU callback processing from boot-selected CPUs"
> -	depends on TREE_RCU || TREE_PREEMPT_RCU
> +	depends on TREE_RCU || PREEMPT_RCU
>  	default n
>  	help
>  	  Use this option to reduce OS jitter for aggressive HPC or
> diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
> index 807ccfb..e6fae50 100644
> --- a/kernel/rcu/Makefile
> +++ b/kernel/rcu/Makefile
> @@ -1,6 +1,6 @@
>  obj-y += update.o srcu.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
>  obj-$(CONFIG_TREE_RCU) += tree.o
> -obj-$(CONFIG_TREE_PREEMPT_RCU) += tree.o
> +obj-$(CONFIG_PREEMPT_RCU) += tree.o
>  obj-$(CONFIG_TREE_RCU_TRACE) += tree_trace.o
>  obj-$(CONFIG_TINY_RCU) += tiny.o
> diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> index 72fedc8..6999132 100644
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -139,7 +139,7 @@ struct rcu_node {
>  	unsigned long expmask;	/* Groups that have ->blkd_tasks */
>  				/*  elements that need to drain to allow the */
>  				/*  current expedited grace period to */
> -				/*  complete (only for TREE_PREEMPT_RCU). */
> +				/*  complete (only for PREEMPT_RCU). */
>  	unsigned long qsmaskinit;
>  				/* Per-GP initial value for qsmask & expmask. */
>  	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
> @@ -530,10 +530,10 @@ DECLARE_PER_CPU(struct rcu_data, rcu_sched_data);
>  extern struct rcu_state rcu_bh_state;
>  DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
> 
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> +#ifdef CONFIG_PREEMPT_RCU
>  extern struct rcu_state rcu_preempt_state;
>  DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +#endif /* #ifdef CONFIG_PREEMPT_RCU */
> 
>  #ifdef CONFIG_RCU_BOOST
>  DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
> @@ -563,10 +563,10 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
>  #endif /* #ifdef CONFIG_HOTPLUG_CPU */
>  static void rcu_preempt_check_callbacks(int cpu);
>  void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
> -#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU)
> +#if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PREEMPT_RCU)
>  static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
>  			       bool wake);
> -#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
> +#endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_PREEMPT_RCU) */
>  static void __init __rcu_init_preempt(void);
>  static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
>  static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 77f9376..11e42a2 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -97,7 +97,7 @@ static void __init rcu_bootup_announce_oddness(void)
>  #endif
>  }
> 
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> +#ifdef CONFIG_PREEMPT_RCU
> 
>  RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
>  static struct rcu_state *rcu_state_p = &rcu_preempt_state;
> @@ -919,7 +919,7 @@ void exit_rcu(void)
>  	__rcu_read_unlock();
>  }
> 
> -#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> +#else /* #ifdef CONFIG_PREEMPT_RCU */
> 
>  static struct rcu_state *rcu_state_p = &rcu_sched_state;
> 
> @@ -1070,7 +1070,7 @@ void exit_rcu(void)
>  {
>  }
> 
> -#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
> +#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
> 
>  #ifdef CONFIG_RCU_BOOST
> 
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index 3ef8ba5..27a5b17 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -306,7 +306,7 @@ struct debug_obj_descr rcuhead_debug_descr = {
>  EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
>  #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> 
> -#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
> +#if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
>  void do_trace_rcu_torture_read(const char *rcutorturename, struct rcu_head *rhp,
>  			       unsigned long secs,
>  			       unsigned long c_old, unsigned long c)
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8655b6c..16d37a4 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1219,7 +1219,7 @@ config RCU_CPU_STALL_TIMEOUT
> 
>  config RCU_CPU_STALL_INFO
>  	bool "Print additional diagnostics on RCU CPU stall"
> -	depends on (TREE_RCU || TREE_PREEMPT_RCU) && DEBUG_KERNEL
> +	depends on (TREE_RCU || PREEMPT_RCU) && DEBUG_KERNEL
>  	default n
>  	help
>  	  For each stalled CPU that is aware of the current RCU grace
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
> index a04420e..f8a10a7 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
> @@ -2,7 +2,7 @@ CONFIG_SMP=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_HZ_PERIODIC=n
>  CONFIG_NO_HZ_IDLE=y
>  CONFIG_NO_HZ_FULL=n
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02 b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
> index a4f8bfb..629122f 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02
> @@ -3,7 +3,7 @@ CONFIG_NR_CPUS=8
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_HZ_PERIODIC=n
>  CONFIG_NO_HZ_IDLE=y
>  CONFIG_NO_HZ_FULL=n
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
> index fe19aaf..a25de47 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T
> @@ -3,7 +3,7 @@ CONFIG_NR_CPUS=8
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_HZ_PERIODIC=n
>  CONFIG_NO_HZ_IDLE=y
>  CONFIG_NO_HZ_FULL=n
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE03 b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
> index f0e66db..53f24e0 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/TREE03
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE03
> @@ -3,7 +3,7 @@ CONFIG_NR_CPUS=8
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_HZ_PERIODIC=y
>  CONFIG_NO_HZ_IDLE=n
>  CONFIG_NO_HZ_FULL=n
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08 b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
> index 316aa6c..43ba43f 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08
> @@ -3,7 +3,7 @@ CONFIG_NR_CPUS=16
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_HZ_PERIODIC=n
>  CONFIG_NO_HZ_IDLE=y
>  CONFIG_NO_HZ_FULL=n
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
> index 55daf08..3eaecca 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T
> @@ -3,7 +3,7 @@ CONFIG_NR_CPUS=16
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_HZ_PERIODIC=n
>  CONFIG_NO_HZ_IDLE=y
>  CONFIG_NO_HZ_FULL=n
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE09 b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
> index 13081a8..6076b36 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/TREE09
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE09
> @@ -3,7 +3,7 @@ CONFIG_NR_CPUS=1
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_HZ_PERIODIC=n
>  CONFIG_NO_HZ_IDLE=y
>  CONFIG_NO_HZ_FULL=n
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
> index f72402d..dd7bd4d 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P1-S-T-NH-SD-SMP-HP
> @@ -9,7 +9,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
> index 0f3b667..81d4843 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P2-2-t-nh-sd-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
> index b035e14..16e22b7 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P3-3-T-nh-SD-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
> index 3ccf6a9..ea7ed3b 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P4-A-t-NH-sd-SMP-HP
> @@ -8,7 +8,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_RT_MUTEXES=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
> index a55c008..24f4d5e 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v0.0/P5-U-T-NH-sd-SMP-hp
> @@ -11,7 +11,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_OBJECTS=y
>  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
> index 9647c44..6880663 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P1-S-T-NH-SD-SMP-HP
> @@ -10,7 +10,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
> index 0f3b667..81d4843 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P2-2-t-nh-sd-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
> index b035e14..16e22b7 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P3-3-T-nh-SD-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
> index 3ccf6a9..ea7ed3b 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P4-A-t-NH-sd-SMP-HP
> @@ -8,7 +8,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_RT_MUTEXES=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
> index a55c008..24f4d5e 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P5-U-T-NH-sd-SMP-hp
> @@ -11,7 +11,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_OBJECTS=y
>  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
> index f4c9175..1be59e4 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P6---t-nh-SD-smp-hp
> @@ -8,7 +8,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -CONFIG_TREE_PREEMPT_RCU=y
> +CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
> index 77a8c5b..b49ef74 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP
> @@ -14,7 +14,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_PROVE_LOCKING=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
> index 0eecebc..a55a6ac 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-all
> @@ -14,7 +14,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_PROVE_LOCKING=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
> index 0eecebc..a55a6ac 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-HP-none
> @@ -14,7 +14,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_PROVE_LOCKING=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
> index 588bc70..3134f46 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.12/P7-4-T-NH-SD-SMP-hp
> @@ -14,7 +14,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_PROVE_LOCKING=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
> index 9647c44..6880663 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P1-S-T-NH-SD-SMP-HP
> @@ -10,7 +10,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
> index 0f3b667..81d4843 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P2-2-t-nh-sd-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
> index b035e14..16e22b7 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P3-3-T-nh-SD-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
> index 3ccf6a9..ea7ed3b 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P4-A-t-NH-sd-SMP-HP
> @@ -8,7 +8,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_RT_MUTEXES=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
> index a55c008..24f4d5e 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.3/P5-U-T-NH-sd-SMP-hp
> @@ -11,7 +11,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_OBJECTS=y
>  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
> index 9647c44..6880663 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P1-S-T-NH-SD-SMP-HP
> @@ -10,7 +10,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
> index 0f3b667..81d4843 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P2-2-t-nh-sd-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
> index b035e14..16e22b7 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P3-3-T-nh-SD-SMP-hp
> @@ -10,7 +10,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_SYSFS_DEPRECATED_V2=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
> index 3ccf6a9..ea7ed3b 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P4-A-t-NH-sd-SMP-HP
> @@ -8,7 +8,7 @@ CONFIG_HOTPLUG_CPU=y
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_RCU_TORTURE_TEST=m
>  CONFIG_MODULE_UNLOAD=y
>  CONFIG_RT_MUTEXES=y
> diff --git a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
> index a55c008..24f4d5e 100644
> --- a/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
> +++ b/tools/testing/selftests/rcutorture/configs/rcu/v3.5/P5-U-T-NH-sd-SMP-hp
> @@ -11,7 +11,7 @@ CONFIG_HIBERNATION=n
>  CONFIG_PREEMPT_NONE=n
>  CONFIG_PREEMPT_VOLUNTARY=n
>  CONFIG_PREEMPT=y
> -#CHECK#CONFIG_TREE_PREEMPT_RCU=y
> +#CHECK#CONFIG_PREEMPT_RCU=y
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_OBJECTS=y
>  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> diff --git a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
> index 28db67b..9ef33a7 100644
> --- a/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
> +++ b/tools/testing/selftests/rcutorture/doc/TINY_RCU.txt
> @@ -34,7 +34,7 @@ CONFIG_PREEMPT
>  CONFIG_PREEMPT_RCU
>  CONFIG_SMP
>  CONFIG_TINY_RCU
> -CONFIG_TREE_PREEMPT_RCU
> +CONFIG_PREEMPT_RCU
>  CONFIG_TREE_RCU
> 
>  	All forced by CONFIG_TINY_RCU.
> diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
> index f85c45e..ec03c88 100644
> --- a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
> +++ b/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
> @@ -1,5 +1,5 @@
>  This document gives a brief rationale for the TREE_RCU-related test
> -cases, a group that includes TREE_PREEMPT_RCU.
> +cases, a group that includes PREEMPT_RCU.
> 
> 
>  Kconfig Parameters:
> @@ -14,7 +14,7 @@ CONFIG_NO_HZ_FULL_SYSIDLE -- Do one.
>  CONFIG_PREEMPT -- Do half.  (First three and #8.)
>  CONFIG_PROVE_LOCKING -- Do all but two, covering CONFIG_PROVE_RCU and not.
>  CONFIG_PROVE_RCU -- Do all but one under CONFIG_PROVE_LOCKING.
> -CONFIG_RCU_BOOST -- one of TREE_PREEMPT_RCU.
> +CONFIG_RCU_BOOST -- one of PREEMPT_RCU.
>  CONFIG_RCU_KTHREAD_PRIO -- set to 2 for _BOOST testing.
>  CONFIG_RCU_CPU_STALL_INFO -- Do one.
>  CONFIG_RCU_FANOUT -- Cover hierarchy as currently, but overlap with others.
> @@ -26,7 +26,7 @@ CONFIG_RCU_NOCB_CPU_ALL -- Do one.
>  CONFIG_RCU_NOCB_CPU_NONE -- Do one.
>  CONFIG_RCU_NOCB_CPU_ZERO -- Do one.
>  CONFIG_RCU_TRACE -- Do half.
> -CONFIG_SMP -- Need one !SMP for TREE_PREEMPT_RCU.
> +CONFIG_SMP -- Need one !SMP for PREEMPT_RCU.
>  RCU-bh: Do one with PREEMPT and one with !PREEMPT.
>  RCU-sched: Do one with PREEMPT but not BOOST.
> 
> @@ -76,7 +76,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
> 
>  CONFIG_RCU_STALL_COMMON
> 
> -	Implied by TREE_RCU and TREE_PREEMPT_RCU.
> +	Implied by TREE_RCU and PREEMPT_RCU.
> 
>  CONFIG_RCU_TORTURE_TEST
>  CONFIG_RCU_TORTURE_TEST_RUNNABLE
> @@ -87,7 +87,7 @@ CONFIG_RCU_USER_QS
> 
>  	Redundant with CONFIG_NO_HZ_FULL.
> 
> -CONFIG_TREE_PREEMPT_RCU
> +CONFIG_PREEMPT_RCU
>  CONFIG_TREE_RCU
> 
>  	These are controlled by CONFIG_PREEMPT.
> -- 
> 2.1.0
> 
> 

