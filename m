Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaB0T5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:57:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:61294 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751729AbaB0T5o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:57:44 -0500
Date: Thu, 27 Feb 2014 14:57:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: Re: [PATCH 29/46] kernel: Mark functions as static in
 trace/trace_functions_graph.c
Message-ID: <20140227145743.32f1c4d5@gandalf.local.home>
In-Reply-To: <4cd6a5e920322b37f250cf3d3fae3feb8e5ef2f6.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<4cd6a5e920322b37f250cf3d3fae3feb8e5ef2f6.1393493277.git.rashika.kheria@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:40:11 +0530
Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Mark functions as static in kernel/trace/trace_functions_graph.c because
> they are not used outside this file.
> 
> This eliminates the following warning in
> kernel/trace/trace_functions_graph.c:
> kernel/trace/trace_functions_graph.c:333:5: warning: no previous prototype for ‘trace_graph_thresh_entry’ [-Wmissing-prototypes]
> kernel/trace/trace_functions_graph.c:422:6: warning: no previous prototype for ‘trace_graph_thresh_return’ [-Wmissing-prototypes]
> kernel/trace/trace_functions_graph.c:1408:6: warning: no previous prototype for ‘print_graph_headers’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> ---
>  kernel/trace/trace_functions_graph.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 0b99120..9e9b5c2 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -330,7 +330,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  	return ret;
>  }
>  
> -int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
> +static int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
>  {
>  	if (tracing_thresh)
>  		return 1;
> @@ -419,7 +419,7 @@ void set_graph_array(struct trace_array *tr)
>  	smp_mb();
>  }
>  
> -void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
> +static void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
>  {
>  	if (tracing_thresh &&
>  	    (trace->rettime - trace->calltime < tracing_thresh))
> @@ -1405,7 +1405,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
>  	seq_printf(s, "               |   |   |   |\n");
>  }
>  
> -void print_graph_headers(struct seq_file *s)
> +static void print_graph_headers(struct seq_file *s)
>  {
>  	print_graph_headers_flags(s, tracer_flags.val);
>  }

