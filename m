Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaB0T42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:56:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:58887 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753234AbaB0T41 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:56:27 -0500
Date: Thu, 27 Feb 2014 14:56:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: Re: [PATCH 28/46] kernel: Add prototype declaration to header file
 linux/ftrace.h
Message-ID: <20140227145624.58b5f9b1@gandalf.local.home>
In-Reply-To: <5238e052310ffdcaae2287783013afc42d3f7266.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<5238e052310ffdcaae2287783013afc42d3f7266.1393493277.git.rashika.kheria@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:38:01 +0530
Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Add prototye declaration of function to header file
> include/linux/ftrace.h
> because it is used by more than one file.
> 
> This eliminates the following warning in
> kernel/trace/trace_functions_graph.c:
> kernel/trace/trace_functions_graph.c:218:15: warning: no previous prototype for ‘ftrace_return_to_handler’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  include/linux/ftrace.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index da1c31f..c4d1048 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -673,6 +673,7 @@ typedef void (*trace_func_graph_ret_t)(struct ftrace_graph_ret *); /* return */
>  typedef int (*trace_func_graph_ent_t)(struct ftrace_graph_ent *); /* entry */
>  
>  int ftrace_graph_entry_stub(struct ftrace_graph_ent *trace);
> +unsigned long ftrace_return_to_handler(unsigned long frame_pointer);

Like ftrace_graph_entry_stub() this too is only called from assembly.
Just make the comment I asked to add apply to both of them.

-- Steve

>  
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  

