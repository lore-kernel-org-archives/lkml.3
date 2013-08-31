Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3HaUCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:02:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46420 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab3HaUCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:02:11 -0400
Date: Sat, 31 Aug 2013 13:01:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 18/18 v2] ftrace/sched: Mark functions that are RCU
 unsafe
Message-ID: <20130831200158.GW3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051703.390216483@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051703.390216483@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083120-7182-0000-0000-00000843430E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:35AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Some callbacks of the function tracer use rcu_read_lock(). This means that
> there's places that can not be traced because RCU is not tracking the CPU
> for various reasons (like NO_HZ_FULL and coming back from userspace).
> 
> Thes functions need to be marked so that callbacks that use RCU do not
> trace them.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/sched/core.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b7c32cb..9bd2aea 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1440,6 +1440,7 @@ void scheduler_ipi(void)
>  	}
>  	irq_exit();
>  }
> +FTRACE_UNSAFE_RCU(scheduler_ipi);
> 
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  {
> @@ -3222,6 +3223,7 @@ int idle_cpu(int cpu)
> 
>  	return 1;
>  }
> +FTRACE_UNSAFE_RCU(idle_cpu);
> 
>  /**
>   * idle_task - return the idle task for a given cpu.
> -- 
> 1.7.10.4
> 
> 

