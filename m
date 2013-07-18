Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab3GRDGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 23:06:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26326 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab3GRDGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 23:06:43 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=CP4Tl-rxqdAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9d5NqswhC6UA:10 a=-305aJ_IDpQvUcWqkfUA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374116802.6458.205.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2013 23:06:42 -0400
In-Reply-To: <20130618192147.GA19443@redhat.com>
References: <20130618192147.GA19443@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 21:21 +0200, Oleg Nesterov wrote:
> Hello.
> 
> On top of "PATCH 0/3] tracing: more list_empty(perf_events) checks"
> series I sent yesterday.
> 
> Compile tested only, not for inclusion yet.

Oleg, I know you sent me a mbox with these patches, but I rather pull
the real email. But this is the only one I have. With a comment like
that, I wouldn't pull it in.

But as you sent me them to include them, I take it, this is ready.

Peter, Frederic, can you review these patches and ack or nack them?

Thanks,

-- Steve

> 
> But I'll appreciate if you can take a look. I'll try to test this
> tomorrow somehow and let you know. Right now I am looking at asm code,
> looks correct...
> 
> I also compiled the kernel with the additional patch below, everything
> compiles except sched/core.o as expected.
> 
> Oleg.
> 
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -664,6 +664,8 @@ perf_trace_##call(void *__data, proto)					\
>  									\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>  									\
> +	BUILD_BUG_ON(!(__builtin_constant_p(!__task) && !__task));	\
> +									\
>  	head = this_cpu_ptr(event_call->perf_events);			\
>  	if (__builtin_constant_p(!__task) && !__task &&			\
>  				hlist_empty(head))			\


