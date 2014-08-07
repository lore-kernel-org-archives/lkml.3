Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaHGUIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:08:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:48620 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaHGUIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:08:16 -0400
Date: Thu, 7 Aug 2014 22:08:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807200813.GB3935@laptop>
References: <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
 <20140806224518.GA8101@linux.vnet.ibm.com>
 <20140807084544.GJ19379@twins.programming.kicks-ass.net>
 <20140807150031.GB5821@linux.vnet.ibm.com>
 <20140807152600.GW9918@twins.programming.kicks-ass.net>
 <20140807172753.GG3588@twins.programming.kicks-ass.net>
 <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807155326.18481e66@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:53:26PM -0400, Steven Rostedt wrote:
> On Thu, 7 Aug 2014 15:49:07 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
> > Only voluntary calls to schedule() will be a quiescent state. Preempt
> > doesn't count. And no, function callbacks to not call schedule(),
> > function callbacks should be treated even stricter than interrupt
> > handlers. They should never call schedule() directly or even take any
> > locks. Heck, they should be stricter than NMIs for that matter.
> > 
> > Hence, once something calls schedule() directly, we know that it is not
> > on a trampoline, nor is it going to return to one.
> 
> I should also be a bit clearer here. It's not just function callbacks,
> but anything that adds a trampoline that can be called from any context
> (like for kprobes). The point is, these trampolines that can execute
> anywhere (including in NMIs), must have strict use cases. These are not
> a notifier or other generic operation that normal RCU is fine for.
> These are for really specific cases that require the call_rcu_task() to
> free.
> 
> call_rcu_task() should seldom be used. The only cases really are for
> kprobes and function tracing, and perhaps other dynamic callers.

OK, you've got to start over and start at the beginning, because I'm
really not understanding this..

What is a 'trampoline' and what are you going to use them for.

