Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3IINzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:55:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15380 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3IINzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:55:16 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=lVfAMxzXEWcdVMD1qmMA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 09:55:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909095511.735bcffc@gandalf.local.home>
In-Reply-To: <20130909134605.GP3966@linux.vnet.ibm.com>
References: <20130906151851.GQ3966@linux.vnet.ibm.com>
	<1378488088.31445.39.camel@edumazet-glaptop>
	<20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909121329.GA16280@somewhere>
	<20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
	<20130909085504.2ddd7e69@gandalf.local.home>
	<20130909131452.GA31370@twins.programming.kicks-ass.net>
	<20130909134605.GP3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 06:46:05 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

 
> > Also, if its per-task, why don't we have this in the task struct? The
> > current scheme makes the context switch more expensive -- is this the
> > right trade-off?
> 
> There are constraints based on the task, but RCU really is
> paying attention to CPUs, not than tasks.  (With the exception of
> TREE_PREEMPT_RCU, which does keep lists of tasks that it has to pay
> attention to, namely those that have been preempted within their current
> RCU read-side critical section.)

Conceptually wise, RCU keeps track of task state, not CPU state. In all
your diagrams in your presentations, where you talk about grace periods
and quiescent states, you show tasks, not CPUs.

RCU's implementation is based on CPUs, and only when rcu_read_lock()
prevents preemption. As you stated above, TREE_PREEMPT_RCU needs to
keep track of tasks.

I think you are too deep into the implementation, that you are
forgetting the concept that you created :-)

-- Steve

