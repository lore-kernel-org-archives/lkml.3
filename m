Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab3DBI7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759585Ab3DBI7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:59:03 -0400
Date: Tue, 2 Apr 2013 10:57:09 +0200
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] uprobes/tracing: Kill the pointless task_pt_regs()
 calls
Message-ID: <20130402085709.GB24889@bandura.brq.redhat.com>
References: <20130329181520.GA20670@redhat.com>
 <20130329181540.GA20687@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329181540.GA20687@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 07:15:40PM +0100, Oleg Nesterov wrote:
> uprobe_trace_func() and uprobe_perf_func() do not need task_pt_regs(),
> we already have "struct pt_regs *regs".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
Acked-by: Anton Arapov <anton@redhat.com>
