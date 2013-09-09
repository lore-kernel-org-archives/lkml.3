Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3IIN5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:57:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60305 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3IIN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:57:06 -0400
Date: Mon, 9 Sep 2013 06:56:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909135656.GT3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909134505.GF16280@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909134505.GF16280@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090913-0928-0000-0000-00000165DA1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 03:45:06PM +0200, Frederic Weisbecker wrote:
> On Mon, Sep 09, 2013 at 09:21:42AM -0400, Steven Rostedt wrote:
> > On Mon, 9 Sep 2013 15:08:53 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Mon, Sep 09, 2013 at 08:55:04AM -0400, Steven Rostedt wrote:
> > 
> > > > From reading the context a bit more, it seems that the per cpu value is
> > > > more a "per task" value that happens to be using per cpu variables, and
> > > > changes on context switches. Is that correct?
> > > 
> > > Yeah that's probably what confuse so many people. It's indeed at the same
> > > time a task state and a per cpu state.
> > 
> > Especially since the function name itself is "rcu_is_cpu_idle()" which
> > tells you it's a cpu state, and not a task state. Why would you care in
> > RCU if CPU 1 is idle if you are on CPU 2? The name should be changed.
> 
> OTOH it's referring to RCU extended quiescent states that are really per
> CPU from the RCU point of view, implementation and design wise.
> 
> Perhaps a name that has a meaning close to task_is_in_cpu_extqs().
> 
> I'm not sure it makes things clearer though.

Indeed, there is on ongoing naming debate as well.  About the only point
of agreement thus far is that the current names are inadequate. ;-)

My current feeling is that rcu_is_cpu_idle() should be called
rcu_watching_this_cpu() and what is called rcu_watching_this_cpu()
in my local tree should be called __rcu_watching_this_cpu().


							Thanx, Paul

> > > Pretty much like tsk->ti->preempt_count that people now try to implement
> > > through a per cpu value.
> > 
> > Actually, preempt_count is more a CPU state than a task state. When
> > preempt_count is set, that CPU can not schedule out the current task.
> > It really has nothing to do with the task itself. It's the CPU that
> > can't do something. Preempt count should never traverse with a task
> > from one CPU to another.
> 
> Yep.
> 

