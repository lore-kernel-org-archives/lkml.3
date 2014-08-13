Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaHMSYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:24:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60639 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaHMSYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:24:12 -0400
Date: Wed, 13 Aug 2014 11:24:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813182406.GE4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
 <20140813140705.GO9918@twins.programming.kicks-ass.net>
 <20140813101301.08019895@gandalf.local.home>
 <20140813144332.GW4752@linux.vnet.ibm.com>
 <20140813163015.GT9918@twins.programming.kicks-ass.net>
 <20140813094305.225a4e1c@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813094305.225a4e1c@ultegra>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081318-3532-0000-0000-000003D244FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 09:43:05AM -0700, Jacob Pan wrote:
> On Wed, 13 Aug 2014 18:30:15 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, Aug 13, 2014 at 07:43:32AM -0700, Paul E. McKenney wrote:
> > > o	drivers/acpi/acpi_pad.c, power_saving_thread().
> > > 
> > > 	Looks like a kthread that does idle injection.  Currently,
> > > RCU sees it as not a quiescent state.  Would it kill these guys to
> > > 	put in a comment or two about what this is for???
> > > 
> > > 	So adding rcu_idle_enter() and rcu_idle_exit() here might
> > > 	actually fix a bug, though it is not clear how long this
> > > thing actually runs.  If only for a few milliseconds, no harm done.
> > > 
> > 
> > > o	drivers/thermal/intel_powerclamp.c, clamp_thread().
> > > 
> > > 	Looks similar to power_saving_thread(), but for thermal
> > > control. Probably short term, shouldn't be a problem either way.
> > > 
> > 
> > There's patches somewhere that make that go-away
> > 
> >   https://lkml.org/lkml/2014/6/4/56
> > 
> > Jacob was going to look at that.
> 
> yes, it is on my plate, plan to submit for 3.18. the idle period is
> only for a few miliseconds, default to 6ms.

OK, 6ms shouldn't be a problem.  But if you want much longer, you
will need to do rcu_idle_enter() and rcu_idle_exit().  Of course, if
you are getting rid of this entirely, no need to worry -- though the
patch looks like it just uses a different idle loop.

							Thanx, Paul

