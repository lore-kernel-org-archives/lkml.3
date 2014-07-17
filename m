Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbaGQMzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:55:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:52958 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755188AbaGQMzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:55:44 -0400
Date: Thu, 17 Jul 2014 08:55:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [patch V2 64/64] ftrace: Provide trace clocks monotonic
Message-ID: <20140717085535.782e1fc1@gandalf.local.home>
In-Reply-To: <20140716205057.643948282@linutronix.de>
References: <20140716205018.175419210@linutronix.de>
	<20140716205057.643948282@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 21:05:25 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> Expose the new NMI safe accessor to clock monotonic to the tracer.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/trace/trace.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> Index: tip/kernel/trace/trace.c
> ===================================================================
> --- tip.orig/kernel/trace/trace.c
> +++ tip/kernel/trace/trace.c
> @@ -806,11 +806,12 @@ static struct {
>  	const char *name;
>  	int in_ns;		/* is this clock in nanoseconds? */
>  } trace_clocks[] = {
> -	{ trace_clock_local,	"local",	1 },
> -	{ trace_clock_global,	"global",	1 },
> -	{ trace_clock_counter,	"counter",	0 },
> -	{ trace_clock_jiffies,	"uptime",	1 },
> -	{ trace_clock,		"perf",		1 },
> +	{ trace_clock_local,		"local",	1 },
> +	{ trace_clock_global,		"global",	1 },
> +	{ trace_clock_counter,		"counter",	0 },
> +	{ trace_clock_jiffies,		"uptime",	1 },
> +	{ trace_clock,			"perf",		1 },
> +	{ ktime_get_mono_fast_ns,	"mono",		1 },

I'm not sure I like the name "mono" because all the clocks listed are
considered monolithic (with the view of tracing). What about calling it
"user" as I believe this clock is the one that will be used to
synchronize userspace times with the kernel. Right?

-- Steve

>  	ARCH_TRACE_CLOCKS
>  };
>  
> 

