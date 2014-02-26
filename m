Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaBZRUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:20:37 -0500
Received: from mail.efficios.com ([78.47.125.74]:42573 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaBZRUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:20:34 -0500
Date: Wed, 26 Feb 2014 17:20:34 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <118766423.31006.1393435234610.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140226110313.4d92fb83@gandalf.local.home>
References: <20140226110313.4d92fb83@gandalf.local.home>
Subject: Re: [RFC][PATCH] tracepoint: Do not waste memory on mods with no
 tracepoints
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracepoint: Do not waste memory on mods with no tracepoints
Thread-Index: LTsaphPvdgIJ43Hd5uzripCXD0PlqQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "Ingo Molnar" <mingo@kernel.org>, "Rusty Russell" <rusty@rustcorp.com.au>, "Peter Zijlstra"
> <peterz@infradead.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Andrew Morton"
> <akpm@linux-foundation.org>
> Sent: Wednesday, February 26, 2014 11:03:13 AM
> Subject: [RFC][PATCH] tracepoint: Do not waste memory on mods with no tracepoints
> 
> 
> No reason to allocate tp_module structures for modules that have no
> tracepoints. This just wastes memory.

Good catch! Thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Fixes: b75ef8b44b1c "Tracepoint: Dissociate from module mutex"
> Cc: stable@vger.kernel.org # 3.2+
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/tracepoint.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 29f2654..0d4ef26 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -636,6 +636,9 @@ static int tracepoint_module_coming(struct module *mod)
>  	struct tp_module *tp_mod, *iter;
>  	int ret = 0;
>  
> +	if (!mod->num_tracepoints)
> +		return 0;
> +
>  	/*
>  	 * We skip modules that taint the kernel, especially those with different
>  	 * module headers (for forced load), to make sure we don't cause a crash.
> @@ -679,6 +682,9 @@ static int tracepoint_module_going(struct module *mod)
>  {
>  	struct tp_module *pos;
>  
> +	if (!mod->num_tracepoints)
> +		return 0;
> +
>  	mutex_lock(&tracepoints_mutex);
>  	tracepoint_update_probe_range(mod->tracepoints_ptrs,
>  		mod->tracepoints_ptrs + mod->num_tracepoints);
> --
> 1.8.1.4
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
