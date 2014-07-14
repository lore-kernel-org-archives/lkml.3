Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbaGNTDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:03:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:13915 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752490AbaGNTD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:03:29 -0400
Date: Mon, 14 Jul 2014 15:03:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] tracing: kill call_filter_disable()
Message-ID: <20140714150327.01fefa69@gandalf.local.home>
In-Reply-To: <20140711190647.GA19530@redhat.com>
References: <20140711190622.GA19499@redhat.com>
	<20140711190647.GA19530@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 21:06:47 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> It seems that the only purpose of call_filter_disable() is to
> make filter_disable() less clear and symmetrical, remove it.

But what will replace the purpose of making it less symmetrical and
clear?

This is the result of modifications over time.

-- Steve

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events_filter.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 1edec32..54a125c 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -774,17 +774,12 @@ static void __free_preds(struct event_filter *filter)
>  	filter->n_preds = 0;
>  }
>  
> -static void call_filter_disable(struct ftrace_event_call *call)
> -{
> -	call->flags &= ~TRACE_EVENT_FL_FILTERED;
> -}
> -
>  static void filter_disable(struct ftrace_event_file *file)
>  {
>  	struct ftrace_event_call *call = file->event_call;
>  
>  	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> -		call_filter_disable(call);
> +		call->flags &= ~TRACE_EVENT_FL_FILTERED;
>  	else
>  		file->flags &= ~FTRACE_EVENT_FL_FILTERED;
>  }

