Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3HaToo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:44:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40164 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3HaTon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:44:43 -0400
Date: Sat, 31 Aug 2013 12:44:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 03/18 v2] ftrace: Set ftrace internal function
 tracing RCU safe
Message-ID: <20130831194431.GK3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051700.928372852@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051700.928372852@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-7606-0000-0000-00000EC190A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:20AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Since none of the internal ftrace function tracing uses RCU in
> their callbacks, it is OK to set the global_ops (the one that
> they all use) to RCU safe.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/ftrace.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index d61f431..a45deaa 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1146,7 +1146,9 @@ static struct ftrace_ops global_ops = {
>  	.func			= ftrace_stub,
>  	.notrace_hash		= EMPTY_HASH,
>  	.filter_hash		= EMPTY_HASH,
> -	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
> +	.flags			= FTRACE_OPS_FL_RECURSION_SAFE |
> +				  FTRACE_OPS_FL_INITIALIZED |
> +				  FTRACE_OPS_FL_RCU_SAFE,
>  	INIT_REGEX_LOCK(global_ops)
>  };
> 
> -- 
> 1.7.10.4
> 
> 

