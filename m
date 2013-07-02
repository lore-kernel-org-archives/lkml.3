Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3GBXpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:45:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25955 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3GBXpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:45:35 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=R9ABi8c0fyEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=CzMUbcFnfaUA:10 a=i0EeH86SAAAA:8 a=JcOgjUnZS_3TGIQb_PEA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372808734.22688.85.camel@gandalf.local.home>
Subject: Re: [PATCH v3 09/12] tracing: remove ftrace(...) function
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 19:45:34 -0400
In-Reply-To: <1365564393-10972-10-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
	 <1365564393-10972-10-git-send-email-jovi.zhangwei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> 
> The only caller of function ftrace(...) was removed at long time ago,
> so remove the function body also.

Looks reasonable, pulled.

Thanks,

-- Steve

> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace.c |    9 ---------
>  kernel/trace/trace.h |    5 -----
>  2 files changed, 14 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 224b152..dd0c122 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1534,15 +1534,6 @@ trace_function(struct trace_array *tr,
>  		__buffer_unlock_commit(buffer, event);
>  }
>  
> -void
> -ftrace(struct trace_array *tr, struct trace_array_cpu *data,
> -       unsigned long ip, unsigned long parent_ip, unsigned long flags,
> -       int pc)
> -{
> -	if (likely(!atomic_read(&data->disabled)))
> -		trace_function(tr, ip, parent_ip, flags, pc);
> -}
> -
>  #ifdef CONFIG_STACKTRACE
>  
>  #define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 9964695..bb3fd1b 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -445,11 +445,6 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu);
>  
>  void poll_wait_pipe(struct trace_iterator *iter);
>  
> -void ftrace(struct trace_array *tr,
> -			    struct trace_array_cpu *data,
> -			    unsigned long ip,
> -			    unsigned long parent_ip,
> -			    unsigned long flags, int pc);
>  void tracing_sched_switch_trace(struct trace_array *tr,
>  				struct task_struct *prev,
>  				struct task_struct *next,


