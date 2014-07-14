Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaGNN6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:58:34 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36274 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaGNN6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:58:25 -0400
Subject: Re: [PATCH 7/7] tracing: change filter_free_subsystem_*() to check
 ->subsystem rather then ->name
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140711190655.GA19549@redhat.com>
References: <20140711190655.GA19549@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jul 2014 22:58:19 +0900
Message-ID: <1405346299.1745.21.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-11 (금), 21:06 +0200, Oleg Nesterov:
> filter_free_subsystem_preds() and filter_free_subsystem_filters()
> can rely on file->system->subsystem and avoid strcmp().

I guess the same can go to the replace_system_preds() too.

Thanks,
Namhyung


> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_events_filter.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 54a125c..59655bc 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -846,13 +846,10 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
>  					struct trace_array *tr)
>  {
>  	struct ftrace_event_file *file;
> -	struct ftrace_event_call *call;
>  
>  	list_for_each_entry(file, &tr->events, list) {
> -		call = file->event_call;
> -		if (strcmp(call->class->system, system->name) != 0)
> +		if (file->system->subsystem != system)
>  			continue;
> -
>  		__remove_filter(file);
>  	}
>  }
> @@ -874,11 +871,9 @@ static void filter_free_subsystem_filters(struct event_subsystem *system,
>  					  struct trace_array *tr)
>  {
>  	struct ftrace_event_file *file;
> -	struct ftrace_event_call *call;
>  
>  	list_for_each_entry(file, &tr->events, list) {
> -		call = file->event_call;
> -		if (strcmp(call->class->system, system->name) != 0)
> +		if (file->system->subsystem != system)
>  			continue;
>  		__free_subsystem_filter(file);
>  	}



