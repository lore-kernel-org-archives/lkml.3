Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaGNTEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:04:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:14615 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752490AbaGNTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:04:27 -0400
Date: Mon, 14 Jul 2014 15:04:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] tracing/uprobes: kill the dead
 TRACE_EVENT_FL_USE_CALL_FILTER logic
Message-ID: <20140714150425.1c8ea54c@gandalf.local.home>
In-Reply-To: <20140711190650.GA19537@redhat.com>
References: <20140711190622.GA19499@redhat.com>
	<20140711190650.GA19537@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 21:06:50 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> alloc_trace_uprobe() sets TRACE_EVENT_FL_USE_CALL_FILTER for unknown
> reason and this is simply wrong. 

The reason is not unknown. The reason is "cut and paste".

-- Steve

> Fortunately this has no effect because
> register_uprobe_event() clears call->flags after that.
> 
> Kill both. This trace_uprobe was kzalloc'ed and we realy on this fact
> anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_uprobe.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 3c9b97e..33ff6a2 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -265,7 +265,6 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
>  	if (is_ret)
>  		tu->consumer.ret_handler = uretprobe_dispatcher;
>  	init_trace_uprobe_filter(&tu->filter);
> -	tu->tp.call.flags |= TRACE_EVENT_FL_USE_CALL_FILTER;
>  	return tu;
>  
>  error:
> @@ -1292,7 +1291,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
>  		kfree(call->print_fmt);
>  		return -ENODEV;
>  	}
> -	call->flags = 0;
> +
>  	call->class->reg = trace_uprobe_register;
>  	call->data = tu;
>  	ret = trace_add_event_call(call);

