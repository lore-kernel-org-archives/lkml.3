Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaKDCOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:14:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:4081 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751217AbaKDCOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:14:45 -0500
Date: Mon, 3 Nov 2014 21:14:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Document ftrace command line limitations
Message-ID: <20141103211431.0d8a80b8@gandalf.local.home>
In-Reply-To: <1415065525-8267-1-git-send-email-peter@hurleysoftware.com>
References: <1415065525-8267-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Nov 2014 20:45:25 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> When using the function or function_graph tracers from the command
> line, certain command line options have limitations.
> 
> Document that only kernel built-in functions can be filtered via
> ftrace_filter= or ftrace_graph_filter=. Also document that tracer-
> specific options cannot be set on the command line via trace_options.

It's not just a command line limitation. The command line behaves
exactly like set_ftrace_filter does. That is, it only affects the
functions that are loaded when the filter is modified. It never updates
functions that will be loaded when modules are.

Adding this documentation makes it seem that set_ftrace_filter has the
ability to update functions that were not loaded yet. This is not true.
The command line filtering behaves exactly like set_ftrace_filter does.
It only enables the functions that are loaded at the time the function
is set. Which was at boot up, and it just happens to be only built in
functions at that time.

-- Steve



> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  Documentation/kernel-parameters.txt | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4c81a86..6f9dfa0 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1121,6 +1121,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			list of functions. This list can be changed at run
>  			time by the set_ftrace_filter file in the debugfs
>  			tracing directory.
> +			Only built-in functions can be traced when specified
> +			this way.
>  
>  	ftrace_notrace=[function-list]
>  			[FTRACE] Do not trace the functions specified in
> @@ -1134,6 +1136,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			function-list is a comma separated list of functions
>  			that can be changed at run time by the
>  			set_graph_function file in the debugfs tracing directory.
> +			Only built-in functions can be traced when specified
> +			this way.
>  
>  	ftrace_graph_notrace=[function-list]
>  			[FTRACE] Do not trace from the functions specified in
> @@ -3521,6 +3525,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  			      trace_options=stacktrace
>  
> +			Tracer-specific options are ignored when set this way.
> +			For example, the 'func_stack_trace' option cannot be
> +			set here.
> +
>  			See also Documentation/trace/ftrace.txt "trace options"
>  			section.
>  

