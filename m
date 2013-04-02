Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab3DBI7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:59:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667Ab3DBI7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:59:04 -0400
Date: Tue, 2 Apr 2013 10:57:45 +0200
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes/tracing: Kill the pointless
 seq_print_ip_sym() call
Message-ID: <20130402085745.GC24889@bandura.brq.redhat.com>
References: <20130329181520.GA20670@redhat.com>
 <20130329181543.GA20690@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329181543.GA20690@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 07:15:43PM +0100, Oleg Nesterov wrote:
> seq_print_ip_sym(ip) in print_uprobe_event() is pointless,
> kallsyms_lookup(ip) can not resolve a user-space address.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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

Acked-by: Anton Arapov <anton@redhat.com> 
