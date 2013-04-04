Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690Ab3DDOaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:30:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56971 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760617Ab3DDOaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:30:07 -0400
Date: Thu, 4 Apr 2013 19:54:14 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes/tracing: Kill the pointless task_pt_regs()
 calls
Message-ID: <20130404142414.GA8986@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130329181520.GA20670@redhat.com>
 <20130329181540.GA20687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130329181540.GA20687@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040414-7182-0000-0000-00000615FB58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-03-29 19:15:40]:

> uprobe_trace_func() and uprobe_perf_func() do not need task_pt_regs(),
> we already have "struct pt_regs *regs".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Adding Masami in the cc.

> ---
>  kernel/trace/trace_uprobe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 8dad2a9..af5b773 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -507,7 +507,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  		return 0;
> 
>  	entry = ring_buffer_event_data(event);
> -	entry->ip = instruction_pointer(task_pt_regs(current));
> +	entry->ip = instruction_pointer(regs);
>  	data = (u8 *)&entry[1];
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
> @@ -777,7 +777,7 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	if (!entry)
>  		goto out;
> 
> -	entry->ip = instruction_pointer(task_pt_regs(current));
> +	entry->ip = instruction_pointer(regs);
>  	data = (u8 *)&entry[1];
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

