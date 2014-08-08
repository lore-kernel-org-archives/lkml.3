Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbaHHQkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:40:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:33003 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752646AbaHHQkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:40:22 -0400
Date: Fri, 8 Aug 2014 12:40:18 -0400
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
Message-ID: <20140808124018.46724b50@gandalf.local.home>
In-Reply-To: <20140808161709.GF9918@twins.programming.kicks-ass.net>
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
	<20140808161709.GF9918@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014 18:17:09 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Aug 08, 2014 at 11:39:49AM -0400, Steven Rostedt wrote:
> > Also, anyone can register a function handler (perf, systemtap, and even
> > LTTng can).
> 
> So how common is it to have more than 1 function event handler, and how
> many of those cases is there significant difference in the actual
> functions?

For me, it's quite common. Of course, I tend to poweruse function
tracing :-).  I do make instances and trace a few functions here and
there, while tracing all functions.

Note, if you are tracing all functions, all it takes is just adding one
other ops callback to a single function. That is, if you are tracing
all functions, and add another ops, it will make all users use the list
function. That is. Even though only one function has two callbacks
attached to it, all functions will call the list function, which does
make a noticeable difference. I measured it once before, I'll have to
do it again.

Tracing all functions is extremely invasive, and any increase in the
time of the function callback handlers will have a dramatic hit on
performance.

An mcount nop, causes 13% slowdown. Imagine what adding a loop does.


> 
> Because that's the case you're optimizing for. Why is that an important
> enough case.
> 
> I'm thinking I'll never trigger that, I only ever have the one normal
> ftrace handler. So no trampolines for me, the code you have now works
> just fine.
> 


And it will work just fine afterward :-)
 
I will treat any regressions as a significant (high priority) bug.

-- Steve
