Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3IFM50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:57:26 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64487 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3IFM5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:57:25 -0400
Date: Fri, 6 Sep 2013 14:57:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 14/18 v2] ftrace/lockdep: Have the RCU lockdep splat
 show what function triggered
Message-ID: <20130906125719.GA3515@gmail.com>
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.766697014@goodmis.org>
 <20130905191839.GF31370@twins.programming.kicks-ass.net>
 <20130905155217.03df4d45@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905155217.03df4d45@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 5 Sep 2013 21:18:39 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, Aug 31, 2013 at 01:11:31AM -0400, Steven Rostedt wrote:
> > > +void print_ftrace_rcu_func(int cpu)
> > > +{
> > > +	unsigned long ip = per_cpu(ftrace_rcu_func, cpu);
> > > +
> > > +	if (ip)
> > > +		printk("ftrace_rcu_func: %pS\n",
> > > +		       (void *)per_cpu(ftrace_rcu_func, cpu));
> > > +}
> > 
> > That's missing { }.
> 
> Hmm, that's an interesting point. Why the  { } because I break up the
> printk for the 80 character limit?

You probably shouldn't break it up - it looks uglier.

> Although, I'm still not convinced that it needs { }, as it looks to me 
> that it flows nicely without it. I can't find a place in CodingStyle 
> that says { } are needed here.

it's somewhat of a grey area - the section quoted below talks about it 
broadly - and it's typically understood to apply to multi-line statements 
as well, as it's easy to overlook and confuse multi-statements with 
multi-line statements...

Thanks,

	Ingo

----------------------->

Do not unnecessarily use braces where a single statement will do.

if (condition)
        action();

and

if (condition)
        do_this();
else
        do_that();

This does not apply if only one branch of a conditional statement is a 
single statement; in the latter case use braces in both branches:

if (condition) {
        do_this();
        do_that();
} else {
        otherwise();
}

