Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3BKJWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:22:05 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40582 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3BKJWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:22:02 -0500
Date: Mon, 11 Feb 2013 14:49:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] uprobes/perf: Always increment trace_uprobe->nhit
Message-ID: <20130211091938.GC525@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130131191752.GA30410@redhat.com>
 <20130131191832.GA30457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130131191832.GA30457@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021109-7182-0000-0000-0000051AFB5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-01-31 20:18:32]:

> Move tu->nhit++ from uprobe_trace_func() to uprobe_dispatcher().
> 
> ->nhit counts how many time we hit the breakpoint inserted by this
> uprobe, we do not want to loose this info if uprobe was enabled by
> sys_perf_event_open().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 55cdc14..0a9a8de 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -473,8 +473,6 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	unsigned long irq_flags;
>  	struct ftrace_event_call *call = &tu->call;
> 
> -	tu->nhit++;
> -
>  	local_save_flags(irq_flags);
>  	pc = preempt_count();
> 
> @@ -698,6 +696,7 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
>  	struct trace_uprobe *tu;
> 
>  	tu = container_of(con, struct trace_uprobe, consumer);
> +	tu->nhit++;
> 
>  	if (tu->flags & TP_FLAG_TRACE)
>  		uprobe_trace_func(tu, regs);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

