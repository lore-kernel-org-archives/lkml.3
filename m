Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaCBQ7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 11:59:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:5675 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750878AbaCBQ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 11:59:14 -0500
Date: Sun, 2 Mar 2014 11:59:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 2/3] perf: Disallow user space stack dump for function
 trace event
Message-ID: <20140302115907.4c11bce5@gandalf.local.home>
In-Reply-To: <1393775800-13524-3-git-send-email-jolsa@redhat.com>
References: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
	<1393775800-13524-3-git-send-email-jolsa@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Mar 2014 16:56:39 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> Disabling user space stack dump for function trace event.
> 
> Recent issues with user space callchains processing within
> page fault handler tracing showed as Peter said 'there's
> just too much fail surface'.
> 
> The user space stack dump is just another source of the this issue.
> 
> Related list discussions:
>   http://marc.info/?t=139302086500001&r=1&w=2
>   http://marc.info/?t=139301437300003&r=1&w=2

For Linux git change logs, it's more preferable to use the kernel.org
link (it may go to the same place, but at least kernel.org has more
control of where it goes in the future).

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu

-- Steve

> 
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Vince Weaver <vincent.weaver@maine.edu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_event_perf.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index d5e01c3..c894614 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -42,6 +42,13 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
>  		 */
>  		if (!p_event->attr.exclude_callchain_user)
>  			return -EINVAL;
> +
> +		/*
> +		 * Same reason to disable user stack dump as for user space
> +		 * callchains above.
> +		 */
> +		if (p_event->attr.sample_type & PERF_SAMPLE_STACK_USER)
> +			return -EINVAL;
>  	}
>  
>  	/* No tracing, just counting, so no obvious leak */

