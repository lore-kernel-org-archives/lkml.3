Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab3IDBZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:25:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39516 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3IDBZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:25:11 -0400
Date: Tue, 3 Sep 2013 18:25:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 19/18] ftrace: Print a message when the rcu checker
 is disabled
Message-ID: <20130904012505.GJ3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051700.601365837@goodmis.org>
 <20130903171516.16290c47@gandalf.local.home>
 <20130903221808.GH3871@linux.vnet.ibm.com>
 <20130903195705.3ba3442f@gandalf.local.home>
 <20130903201831.2ae872e4@gandalf.local.home>
 <20130903211127.1d09c66e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903211127.1d09c66e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090401-4834-0000-0000-00000AB2CD78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 09:11:27PM -0400, Steven Rostedt wrote:
> From f8f5d278e272c42349b3cd32485faf426d0c459e Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Tue, 3 Sep 2013 20:47:59 -0400
> Subject: [PATCH] ftrace: Print a message when the rcu checker is disabled
> 
> Let the user know that the RCU safety checker for function tracing
> has been disabled. The checker only runs when the user specifically
> configures it in the kernel, and this is done to search for locations
> in the kernel that may be unsafe for a function trace callback to
> use rcu_read_lock()s. But if things like function graph tracing is
> started, which can live lock the machine when the checker is running,
> it is disabled. It would be nice if the kernel let the user know that
> the checker is disabled, and when it is re-enabled again.
> 
> As the checker only gets disabled and re-enabled by user actions
> (starting and stoping the function graph tracer or the irqsoff tracer)
> it is fine to have a printk display that it is disabled or not.
> 
> Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_functions.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 0883069..dd59827 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -569,6 +569,8 @@ void ftrace_unsafe_rcu_checker_disable(void)
>  	atomic_inc(&ftrace_unsafe_rcu_disabled);
>  	/* Make sure the update is seen immediately */
>  	smp_wmb();
> +	pr_info("Disabled FTRACE RCU checker (%pS)\n",
> +		__builtin_return_address(0));
>  }
>  
>  void ftrace_unsafe_rcu_checker_enable(void)
> @@ -576,6 +578,8 @@ void ftrace_unsafe_rcu_checker_enable(void)
>  	atomic_dec(&ftrace_unsafe_rcu_disabled);
>  	/* Make sure the update is seen immediately */
>  	smp_wmb();
> +	pr_info("Enabled FTRACE RCU checker (%pS)\n",
> +		__builtin_return_address(0));
>  }
>  
>  static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
> -- 
> 1.8.1.4
> 

