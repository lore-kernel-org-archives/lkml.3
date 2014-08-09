Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaHIQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:16:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51834 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHIQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:16:24 -0400
Date: Sat, 9 Aug 2014 09:05:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140809160510.GK5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809084439.05778e33@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809084439.05778e33@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080916-7164-0000-0000-000003B355E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 08:44:39AM -0400, Steven Rostedt wrote:
> On Sat, 9 Aug 2014 08:15:14 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> 
> > As for idle tasks, I'm not sure about those, I think that we should say
> > NO to anything that would require waking idle CPUs, push the pain to
> > ftrace/kprobes, we should _not_ be waking idle cpus.
> 
> I agree, but I haven't had a chance to review the patch set (will
> probably do that on Monday, just got back from vacation last week and
> was inundated by other things).

Let me get v5 out first.  I expect to have it out by end of Monday.

>                                 Does the idle waking happen only when
> there's something queued in the call_rcu_tasks()? It should definitely
> not be waking all the time. That's just wrong.
> 
> But if it only wakes when something is queued, it wouldn't be burdening
> anything, unless it is needed.

Indeed, idle waking only happens when there is an RCU-tasks grace period
in progress.  No RCU-tasks grace period, no RCU-tasks idle waking.

							Thanx, Paul

