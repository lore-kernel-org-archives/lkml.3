Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805Ab3DDOai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:30:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53151 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009Ab3DDOah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:30:37 -0400
Date: Thu, 4 Apr 2013 19:54:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 2/4] uprobes/tracing: Kill the pointless
 seq_print_ip_sym() call
Message-ID: <20130404142445.GB8986@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130329181520.GA20670@redhat.com>
 <20130329181543.GA20690@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130329181543.GA20690@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040414-9360-0000-0000-0000119906A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-03-29 19:15:43]:

> seq_print_ip_sym(ip) in print_uprobe_event() is pointless,
> kallsyms_lookup(ip) can not resolve a user-space address.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index af5b773..8e00901 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -531,13 +531,7 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
>  	field = (struct uprobe_trace_entry_head *)iter->ent;
>  	tu = container_of(event, struct trace_uprobe, call.event);
> 
> -	if (!trace_seq_printf(s, "%s: (", tu->call.name))
> -		goto partial;
> -
> -	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
> -		goto partial;
> -
> -	if (!trace_seq_puts(s, ")"))
> +	if (!trace_seq_printf(s, "%s: (0x%lx)", tu->call.name, field->ip))
>  		goto partial;
> 
>  	data = (u8 *)&field[1];
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

