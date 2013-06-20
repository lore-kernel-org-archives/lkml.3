Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965736Ab3FTSxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:53:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965649Ab3FTSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:53:13 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CP4Tl-rxqdAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9d5NqswhC6UA:10 a=kI9iRt63AAAA:8 a=fqa4Ywtmcf2SQxtFMsIA:9 a=QEXdDO2ut3YA:10 a=DtAgflh4N2wA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371754391.18733.107.camel@gandalf.local.home>
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 14:53:11 -0400
In-Reply-To: <1371754078.18733.106.camel@gandalf.local.home>
References: <20130618192147.GA19443@redhat.com>
	 <20130619121039.GA19225@twins.programming.kicks-ass.net>
	 <20130619152844.GA9176@redhat.com> <20130619175139.GA20454@redhat.com>
	 <51C1FD7F.9090606@gmail.com> <20130619195822.GA16489@redhat.com>
	 <1371752633.18733.96.camel@gandalf.local.home> <51C34B70.60808@gmail.com>
	 <1371754078.18733.106.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 14:47 -0400, Steven Rostedt wrote:
> On Thu, 2013-06-20 at 12:35 -0600, David Ahern wrote:
> > On 6/20/13 12:23 PM, Steven Rostedt wrote:
> > >
> > > I ran this:
> > >
> > >   perf stat --repeat 100 -- perf bench sched pipe > /tmp/perf-bench-sched.{before, after}
> > 
> > You want to compare:
> >    perf stat --repeat 100 -p 1 -- perf bench sched pipe
> > 
> > so that event is tagged to pid 1 and not the perf-bench workload.
> 
> I guess I'm a bit confused. What's the significance of measuring pid 1
> (init)?

Oh wait, I just noticed Oleg's:

# perf record -e sched:sched_switch -p1 &

I missed that.

bah, time to re-run it.

-- Steve


