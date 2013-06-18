Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab3FRPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:41:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3FRPln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:41:43 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jG05uceuGy4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5uFaiv9cfuIA:10 a=ayC55rCoAAAA:8 a=inHytyPPysN5Rfb2LDgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371570100.18733.30.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing: more list_empty(perf_events) checks
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Jun 2013 11:41:40 -0400
In-Reply-To: <20130618144635.GB26920@redhat.com>
References: <20130617170142.GA19780@redhat.com>
	 <20130617201818.GA12349@redhat.com>
	 <1371504473.18733.27.camel@gandalf.local.home>
	 <20130618144635.GB26920@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 16:46 +0200, Oleg Nesterov wrote:
> On 06/17, Steven Rostedt wrote:
> >
> > On Mon, 2013-06-17 at 22:18 +0200, Oleg Nesterov wrote:
> > > On 06/17, Oleg Nesterov wrote:
> > > >
> > > > DECLARE_EVENT_CLASS()->perf_trace_##call() is not trivial because
> > > > of __perf_task()
> > >
> > > Perhaps we can do something like below?
> >
> > Did this actually compile for you?
> 
> Why did you ask?
> 
> Perhaps you are trying to say that this patch needs more work...
> 
> Just because it can't be compiled? Pedant.

No, just because when I first looked at it, I didn't think it would, and
didn't delete this when I took a deeper look.

> 
> > > @@ -659,13 +665,12 @@ perf_trace_##call(void *__data, proto)					\
> > >  	int __data_size;						\
> > >  	int rctx;							\
> > >  									\
> > > -	perf_fetch_caller_regs(&__regs);				\
> > > -									\
> > >  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> >
> > OK, so here the task gets assigned the val, and so does count.
> >
> > This may not be a bad approach, but instead of having TP_perf_arg() in
> > events/sched.h, keep the TP_perf_task() and TP_perf_count(), and have
> > whatever is put there assigned.
> 
> Or this, yes.
> 
> OK. Let me try to make something working. At least, something I believe
> should work, I will mostly rely on your review anyway.

Great,

-- Steve


