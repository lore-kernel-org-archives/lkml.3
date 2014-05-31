Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaEaUAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:00:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:47243 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751577AbaEaUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:00:44 -0400
Date: Sat, 31 May 2014 16:00:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 2/5] rtmutex: Cleanup deadlock detector debug logic
Message-ID: <20140531160043.1d4bfb07@gandalf.local.home>
In-Reply-To: <20140531155739.265673091@linutronix.de>
References: <20140531155229.493650009@linutronix.de>
	<20140531155739.265673091@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014 15:57:49 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:


> Index: tip/kernel/locking/rtmutex.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex.c
> +++ tip/kernel/locking/rtmutex.c
> @@ -256,6 +256,25 @@ static void rt_mutex_adjust_prio(struct
>  }
>  
>  /*
> + * Deadlock detection is conditional:
> + *
> + * If CONFIG_DEBUG_RT_MUTEXES=n, deadlock detection is only conducted
> + * if the detect argument is == RT_MUTEX_FULL_CHAINWALK.
> + *
> + * If CONFIG_DEBUG_RT_MUTEXES=y, deadlock detection is always
> + * conducted independent of the detect argument.
> + *
> + * If the waiter argument is NULL this indicates the deboost path and
> + * deadlock detection is disabled independent of the detect argument
> + * and the config settings.
> + */
> +static int rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
> +					 enum rtmutex_chainwalk detect)
> +{
> +	return debug_rt_mutex_detect_deadlock(waiter, detect);
> +}
> +
> +/*

I'm curious to why you created this wrapper function that adds no
value? Why not call debug_rt_mutex_detect_deadlock() directly?

Anyway...

Again, I didn't really check this version of the patch except to see
the additions of what I mentioned before. I did thoroughly review the
first version.


Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
