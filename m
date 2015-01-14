Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbbANBLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:11:40 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56007 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbANBLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:11:38 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 14 Jan 2015 10:09:05 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingo@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, paulmck@linux.vnet.ibm.com,
        mathieu.desnoyers@efficios.com,
        xiakaixu 00238161 <xiakaixu@huawei.com>
Subject: Re: [PATCH 1/2] tracing: Move enabling tracepoints to just after
 rcu_init()
Message-ID: <20150114010905.GA800@sejong>
References: <E1Y9QLr-0000h7-Qw@feisty.vs19.net>
 <54AF53BD.5070303@huawei.com>
 <54B5B478.1020401@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54B5B478.1020401@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 08:12:40AM +0800, Wang Nan wrote:
> Ping...
> 
> On 2015/1/9 12:06, Wang Nan wrote:
> > Hi Steven Rostedt,
> > 
> > During studying your code we find a problem, please see below.
> > 
> >>
> >> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> >>
> >> Enabling tracepoints at boot up can be very useful. The tracepoint
> >> can be initialized right after RCU has been. There's no need to
> >> wait for the early_initcall() to be called. That's too late for some
> >> things that can use tracepoints for debugging. Move the logic to
> >> enable tracepoints out of the initcalls and into init/main.c to
> >> right after rcu_init().
> >>
> >> This also allows trace_printk() to be used early too.
> >>
> >> Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos
> >> Link: http://lkml.kernel.org/r/20141214164104.307127356@goodmis.org
> >>
> >> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> >> Tested-by: Thomas Gleixner <tglx@linutronix.de>
> >> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> >> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > [...]
> > 
> >> +void __init trace_init(void)
> >> +{
> >> +	tracer_alloc_buffers();
> >> +	init_ftrace_syscalls();
> >> +	trace_event_init();	
> >> +}
> >> +
> > 
> > [...]
> > 
> >> +
> >> +void __init trace_event_init(void)
> >> +{
> >> +	event_trace_memsetup();
> >> +	init_ftrace_syscalls();
> >> +	event_trace_enable();
> >> +}
> >> +
> > 
> > init_ftrace_syscalls() get called twice by trace_init() and trace_event_init(), some resources are wasted.
> > At lease one of them can be removed.

I think it's more natural to keep it in the trace_event_init().

Thanks,
Namhyung
