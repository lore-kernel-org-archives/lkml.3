Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3JEQF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:05:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37150 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3JEQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:05:27 -0400
Date: Sat, 5 Oct 2013 18:05:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131005160511.GV3081@twins.programming.kicks-ass.net>
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
 <20131004170954.GK5790@linux.vnet.ibm.com>
 <20131004185239.GS15690@laptop.programming.kicks-ass.net>
 <20131004212506.GM5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004212506.GM5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 02:25:06PM -0700, Paul E. McKenney wrote:
> >                                                                     Why
> > do we still have a per-cpu kthread in nocb mode? The idea is that we do
> > not disturb the cpu, right? So I suppose these kthreads get to run on
> > another cpu.
> 
> Yep, the idea is that usermode figures out where to run them.  Even if
> usermode doesn't do that, this has the effect of getting them to be
> more out of the way of real-time tasks.
> 
> > Since its running on another cpu; we get into atomic and memory barriers
> > anyway; so why not keep the logic the same as no-nocb but have another
> > cpu check our nocb cpu's state.
> 
> You can do that today by setting rcu_nocb_poll, but that results in
> frequent polling wakeups even when the system is completely idle, which
> is out of the question for the battery-powered embedded guys.

So its this polling I don't get.. why is the different behaviour
required? And why would you continue polling if the cpus were actually
idle.

Is there some confusion between the nr_running==1 extended quiescent
state and the nr_running==0 extended quiescent state?

Now, none of this solves the issue at hand because event the 'regular'
no-nocb rcu mode has this issue of needing to wake kthreads, but I'd
like to get a better understanding of why nocb mode is as it is.


I've seen you've since send a few more emails; I might find some of the
answers in there. Let me go read the :-)
