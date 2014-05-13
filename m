Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaEMWAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:00:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49373 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaEMWAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:00:15 -0400
Date: Tue, 13 May 2014 15:00:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
Message-ID: <20140513220009.GW18164@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140512190438.314125476@linutronix.de>
 <20140512201700.999660035@linutronix.de>
 <5371B2D9.8060405@cn.fujitsu.com>
 <20140513084815.GB2485@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.02.1405132117110.6261@ionos.tec.linutronix.de>
 <20140513162041.3405b668@gandalf.local.home>
 <20140513203619.GV18164@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1405132301530.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405132301530.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051322-9332-0000-0000-000000C76DB0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:27:16PM +0200, Thomas Gleixner wrote:
> On Tue, 13 May 2014, Paul E. McKenney wrote:
> > On Tue, May 13, 2014 at 04:20:41PM -0400, Steven Rostedt wrote:
> > > What about having a module that creates a bunch of threads and forces
> > > all the scenarios that we want to test? Wouldn't it be easier to do
> > > than to have a userspace interface to dictate commands to the kernel?
> > 
> > I second this approach!  The kernel environment makes it -much- easier
> > to force races and other conditions, which turns into much simpler and
> > more effective tests.
> 
> The point of the rtmutex tester was NOT to force races and stuff, it
> was intended to be a formal test for certain static scenarios:
> 
>    - verify boosting / debosting
>    - verify set_scheduler interaction
>    - verify deadlock detection 
> 
> The latter was incomplete and therefor missed the futex wreckage :(
> 
> Having a formal checker makes a lot of sense.
> 
> Plastering the code with a gazillion of trace_printks, waiting several
> hours for each iteration and staring into several GB of traces just to
> figure out, that it is an algorithmic issue, is utter waste of time
> and nerves. And that stuff is definitely complex enough to justify a
> static checker.
> 
> Back then when I wrote it, it unearthed quite some logic bugs. And I
> needed the schedule_rt_mutex() hack to verify the BKL interaction and
> the lock steal machinery, which made it impossible to be a module. It
> could have been done, but that'd have been even more ugly hackery.
> 
> So I made it a user space interface to add/modify test cases without
> recompiling the kernel.  But now with BKL and the lock steal muck
> gone, we simply might kill it.
> 
> Now that allows a module, but then I'm still not sure whether formal
> verification rules are fun to code in C. There are certainly better
> ways than the *.tst rules I defined back then. But yes, we could add a
> similar cryptic thing with static arrays of OP/Data pairs in C.

Good points -- I was indeed thinking about stress testing instead of
algorithmic testing.

							Thanx, Paul

