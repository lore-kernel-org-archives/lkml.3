Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaHHQK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:10:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:33912 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755624AbaHHQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:10:58 -0400
Date: Fri, 8 Aug 2014 12:10:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808121055.52112b54@gandalf.local.home>
In-Reply-To: <20140808160128.GE9918@twins.programming.kicks-ass.net>
References: <20140807154907.6f59cf6e@gandalf.local.home>
	<20140807155326.18481e66@gandalf.local.home>
	<20140807200813.GB3935@laptop>
	<20140807171823.1a481290@gandalf.local.home>
	<20140808064020.GZ9918@twins.programming.kicks-ass.net>
	<20140808101221.21056900@gandalf.local.home>
	<20140808143413.GB9918@twins.programming.kicks-ass.net>
	<20140808105858.171da847@gandalf.local.home>
	<20140808151643.GD9918@twins.programming.kicks-ass.net>
	<20140808113949.046522c5@gandalf.local.home>
	<20140808160128.GE9918@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 18:01:28 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

 
> Well, see the _BIG_ difference is that currently, when I do nop >
> current_tracer all that memory is instantly freed again.
> 
> With the proposed scheme, if I setup state, reconsider, destroy state,
> try again, and generally muck about I can tie up unspecified amounts of
> memory.
> 
> And being the bumbling idiot that I am, that's actually fairly typical
> of how I end up tracing. There's no neat and tidy, I trace something,
> look at the trace, script a little, muck about with the settings and
> goto 1.


It would actually be trivial to make that case never free the
trampoline associated to function tracing. As that is a static ops that
never gets freed, the trampoline it uses doesn't need to be freed
either.

But, if you were to do:

   # cd /sys/kernel/debug/tracing
   # mkdir instances/foo
   # cd instances/foo
1: # echo function > current_tracer
   # echo nop > current_tracer
   goto 1

Then, yeah that could do it.

> 
> 
> In any case, I think I now fully understand what you're trying to do,
> just not sure its all win.

Fair enough.

-- Steve
