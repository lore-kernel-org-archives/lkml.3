Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3FROvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:51:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab3FROvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:51:23 -0400
Date: Tue, 18 Jun 2013 16:46:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
Message-ID: <20130618144635.GB26920@redhat.com>
References: <20130617170142.GA19780@redhat.com> <20130617201818.GA12349@redhat.com> <1371504473.18733.27.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371504473.18733.27.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Steven Rostedt wrote:
>
> On Mon, 2013-06-17 at 22:18 +0200, Oleg Nesterov wrote:
> > On 06/17, Oleg Nesterov wrote:
> > >
> > > DECLARE_EVENT_CLASS()->perf_trace_##call() is not trivial because
> > > of __perf_task()
> >
> > Perhaps we can do something like below?
>
> Did this actually compile for you?

Why did you ask?

Perhaps you are trying to say that this patch needs more work...

Just because it can't be compiled? Pedant.

> > @@ -659,13 +665,12 @@ perf_trace_##call(void *__data, proto)					\
> >  	int __data_size;						\
> >  	int rctx;							\
> >  									\
> > -	perf_fetch_caller_regs(&__regs);				\
> > -									\
> >  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>
> OK, so here the task gets assigned the val, and so does count.
>
> This may not be a bad approach, but instead of having TP_perf_arg() in
> events/sched.h, keep the TP_perf_task() and TP_perf_count(), and have
> whatever is put there assigned.

Or this, yes.

OK. Let me try to make something working. At least, something I believe
should work, I will mostly rely on your review anyway.

Oleg.

