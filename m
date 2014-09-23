Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaIWObA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:31:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:19071 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753971AbaIWOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:30:58 -0400
Date: Tue, 23 Sep 2014 10:30:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signal: simplify deadlock-avoidance in
 lock_task_sighand()
Message-ID: <20140923103053.7da6b7f8@gandalf.local.home>
In-Reply-To: <20140923142037.GG3312@worktop.programming.kicks-ass.net>
References: <20140922164404.GA28910@redhat.com>
	<20140922164437.GA28939@redhat.com>
	<20140922145828.4d06108a@gandalf.local.home>
	<20140922191130.GA4527@redhat.com>
	<20140922172405.71c4a110@gandalf.local.home>
	<54215D52.8030201@redhat.com>
	<20140923142037.GG3312@worktop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 16:20:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Sep 23, 2014 at 07:45:22AM -0400, Rik van Riel wrote:
> 
> > > I really thing the preempt_disable/enable is not needed.
> > > 
> > > Paul, Thomas, care to comment?
> > 
> > I suspect you are right.  On normal kernels, rcu_read_lock() will
> > ensure preemption is disabled.
> > 
> > On -rt, the locks within are all sleepable mutexes.
> > 
> > Either way, things should be ok.
> 
> But with CONFIG_PREEMPT we get preemptible RCU but not the
> spinlock->rt_mutex conversion.

Right, I was about to say that. That is, rcu_read_lock() in mainline
does not always disable preemption (See CONFIG_PREEMPT_RCU).

But I still think this should be safe. I don't see the siglock ever
being taking in the scheduler or by rt_mutex_unlock().

-- Steve
