Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaB0RQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:16:52 -0500
Received: from mail.efficios.com ([78.47.125.74]:47931 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaB0RQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:16:50 -0500
Date: Thu, 27 Feb 2014 17:16:52 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Message-ID: <1115204009.31806.1393521412861.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140227120925.7da36f0b@gandalf.local.home>
References: <20140227154616.703252665@goodmis.org> <20140227154923.563572071@goodmis.org> <1493277105.31789.1393518830647.JavaMail.zimbra@efficios.com> <20140227120925.7da36f0b@gandalf.local.home>
Subject: Re: [RFA][PATCH 5/5] tracepoint: Warn and notify if tracepoints are
 not loaded due to module taint
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracepoint: Warn and notify if tracepoints are not loaded due to module taint
Thread-Index: 4WJjpeoEduJcban4ArbM0muYxfeJLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
> "Peter Zijlstra" <peterz@infradead.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, stable@vger.kernel.org,
> "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
> Sent: Thursday, February 27, 2014 12:09:25 PM
> Subject: Re: [RFA][PATCH 5/5] tracepoint: Warn and notify if tracepoints are not loaded due to module taint
> 
> On Thu, 27 Feb 2014 16:33:50 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> 
> > I'd recommend the following message instead:
> > 
> >  pr_err("Module '%s' is tainted, ignoring its tracepoints\n",
> > 
> 
> Better?

Yep, thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> -- Steve
> 
> From 08ea384dc937d75a2a1444a06c3e4553bd118fc1 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Mon, 24 Feb 2014 11:06:04 -0500
> Subject: [PATCH] tracepoint: Warn and notify if tracepoints are not loaded
> due
>  to module taint
> 
> If a module is loaded that is tainted with anything but OOT or CRAP, then
> it will not create the tracepoint infrastructure for the module. The user
> needs
> to be warned when this happens instead of exiting silently.
> 
> Fixes: 97e1c18e8d17 "tracing: Kernel Tracepoints"
> Cc: stable@vger.kernel.org
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/tracepoint.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 63630ae..1d33831 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -649,8 +649,12 @@ static int tracepoint_module_coming(struct module *mod)
>  	 * module headers (for forced load), to make sure we don't cause a crash.
>  	 * Staging and out-of-tree GPL modules are fine.
>  	 */
> -	if (trace_module_has_bad_taint(mod))
> +	if (trace_module_has_bad_taint(mod)) {
> +		pr_err("Module '%s' is tainted, ignoring its tracepoints\n",
> +		       mod->name);
>  		return 0;
> +	}
> +
>  	mutex_lock(&tracepoints_mutex);
>  	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
>  	if (!tp_mod) {
> --
> 1.8.1.4
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
