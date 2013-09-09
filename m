Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3IINI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:08:58 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53115 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3IINI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:08:57 -0400
Date: Mon, 9 Sep 2013 15:08:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909130851.GC16280@somewhere>
References: <20130906105934.GF20519@somewhere>
 <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909085504.2ddd7e69@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 08:55:04AM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 14:45:49 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>  
> > > This just proves that the caller of rcu_is_cpu_idle() must disable
> > > preemption itself for the entire time that it needs to use the result
> > > of rcu_is_cpu_idle().
> > 
> > Sorry, I don't understand your point here. What's wrong with checking the
> > ret from another CPU?
> 
> Hmm, OK, this is why that code is in desperate need of a comment.
> 
> From reading the context a bit more, it seems that the per cpu value is
> more a "per task" value that happens to be using per cpu variables, and
> changes on context switches. Is that correct?

Yeah that's probably what confuse so many people. It's indeed at the same
time a task state and a per cpu state.

Pretty much like tsk->ti->preempt_count that people now try to implement
through a per cpu value.

> 
> Anyway, it requires a comment to explain that we are not checking the
> CPU state, but really the current task state, otherwise that 'ret'
> value wouldn't travel with the task, but would stick with the CPU.

Yeah that desperately need some comment. I'll try to output something
once I'm done with the perf comm stuff.

> -- Steve
> 
