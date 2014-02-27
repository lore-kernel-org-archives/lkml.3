Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaB0TnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:43:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:55713 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751467AbaB0TnF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:43:05 -0500
Date: Thu, 27 Feb 2014 14:42:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: Re: [PATCH 26/46] kernel: Mark functions as static in
 kernel/trace/trace.c
Message-ID: <20140227144253.3cf5c923@gandalf.local.home>
In-Reply-To: <5b78d43c54c505b00ce6dc648f50bcbf88567822.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<5b78d43c54c505b00ce6dc648f50bcbf88567822.1393493277.git.rashika.kheria@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:33:53 +0530
Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Mark functions as static in kernel/trace/trace.c
> because they are not used outside this file.
> 
> This eliminates the following warning in kernel/trace/trace.c:
> kernel/trace/trace.c:266:9: warning: no previous prototype for ‘buffer_ftrace_now’ [-Wmissing-prototypes]
> kernel/trace/trace.c:590:6: warning: no previous prototype for ‘free_snapshot’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/trace/trace.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 815c878..f097949 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -263,7 +263,7 @@ int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
>  }
>  EXPORT_SYMBOL_GPL(call_filter_check_discard);
>  
> -cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
> +static cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
>  {
>  	u64 ts;
>  
> @@ -587,7 +587,7 @@ static int alloc_snapshot(struct trace_array *tr)
>  	return 0;
>  }
>  
> -void free_snapshot(struct trace_array *tr)
> +static void free_snapshot(struct trace_array *tr)
>  {
>  	/*
>  	 * We don't free the ring buffer. instead, resize it because

