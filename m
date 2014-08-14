Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaHNTIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:08:39 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:55541 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaHNTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <1407797345-28227-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140811224840.GA25594@linux.vnet.ibm.com> <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-5-git-send-email-paulmck@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 14 Aug 2014 15:08:06 -0400
Message-ID: <CAJhHMCA3xgLPx8Riy1xhEEy-zC-UHTE=hjST-ktV8jh11xnxsw@mail.gmail.com>
Subject: Re: [PATCH v5 tip/core/rcu 05/16] rcu: Export RCU-tasks APIs to GPL modules
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 6:48 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
>
> This commit exports the RCU-tasks APIs, call_rcu_tasks(),
> synchronize_rcu_tasks(), and rcu_barrier_tasks(), to GPL-licensed
> kernel modules.

Only two of these are being exported in this patch. Patch 1 is adding
the export for call_rcu_tasks().


>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/rcu/update.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index 4cece6e886ee..8f53a41dd9ee 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -433,6 +433,7 @@ void synchronize_rcu_tasks(void)
>         /* Wait for the grace period. */
>         wait_rcu_gp(call_rcu_tasks);
>  }
> +EXPORT_SYMBOL_GPL(synchronize_rcu_tasks);
>
>  /**
>   * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
> @@ -445,6 +446,7 @@ void rcu_barrier_tasks(void)
>         /* There is only one callback queue, so this is easy.  ;-) */
>         synchronize_rcu_tasks();
>  }
> +EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
>
>  /* See if tasks are still holding out, complain if so. */
>  static void check_holdout_task(struct task_struct *t)
> --
> 1.8.1.5
>



-- 
Pranith
