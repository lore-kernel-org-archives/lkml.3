Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab3IFNQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:16:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27516 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3IFNQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:16:39 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=DA-RvV7NLMYA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6u4amIDVaRwA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=08_ebMnpsjU-GirxO4EA:9 a=CjuIK1q_8ugA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 09:16:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 14/18 v2] ftrace/lockdep: Have the RCU lockdep
 splat show what function triggered
Message-ID: <20130906091637.665ac0cd@gandalf.local.home>
In-Reply-To: <20130906125719.GA3515@gmail.com>
References: <20130831051117.884125230@goodmis.org>
	<20130831051702.766697014@goodmis.org>
	<20130905191839.GF31370@twins.programming.kicks-ass.net>
	<20130905155217.03df4d45@gandalf.local.home>
	<20130906125719.GA3515@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013 14:57:19 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Thu, 5 Sep 2013 21:18:39 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Sat, Aug 31, 2013 at 01:11:31AM -0400, Steven Rostedt wrote:
> > > > +void print_ftrace_rcu_func(int cpu)
> > > > +{
> > > > +	unsigned long ip = per_cpu(ftrace_rcu_func, cpu);
> > > > +
> > > > +	if (ip)
> > > > +		printk("ftrace_rcu_func: %pS\n",
> > > > +		       (void *)per_cpu(ftrace_rcu_func, cpu));
> > > > +}
> > > 
> > > That's missing { }.
> > 
> > Hmm, that's an interesting point. Why the  { } because I break up the
> > printk for the 80 character limit?
> 
> You probably shouldn't break it up - it looks uglier.

I thought for printk's it was fine to break after the comma, just not
the printk format line. That is,

	printk("ftrace_rcu_func: %pS\n", (void *)per_cpu(ftrace_rcu_func, cpu));

can go to:

	printk("ftrace_rcu_func: %pS\n",
	       (void *)per_cpu(ftrace_rcu_func, cpu));

But

	printk("this is a really long line and it goes on forever and might be too much to break up\n");

can't go to:

	printk("this is a really long line and it goes on forever and"
		" might be too much to break up\n");

> 
> > Although, I'm still not convinced that it needs { }, as it looks to me 
> > that it flows nicely without it. I can't find a place in CodingStyle 
> > that says { } are needed here.
> 
> it's somewhat of a grey area - the section quoted below talks about it 
> broadly - and it's typically understood to apply to multi-line statements 
> as well, as it's easy to overlook and confuse multi-statements with 
> multi-line statements...

Yeah, I read that part too.

Anyway, this conversation is all moot, as the patch is on hold, and we
may have a better way to solve this anyway, making the patch obsolete.

Thanks,

-- Steve



