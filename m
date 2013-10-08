Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3JHKXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:23:40 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46875 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3JHKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:23:35 -0400
Date: Tue, 8 Oct 2013 12:23:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo.kernel.org@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131008102331.GB8852@gmail.com>
References: <20131002092217.784439754@infradead.org>
 <20131004204405.GU3081@twins.programming.kicks-ass.net>
 <20131004204438.GR26785@twins.programming.kicks-ass.net>
 <20131005080416.GA25193@gmail.com>
 <20131008095927.GS3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008095927.GS3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, Oct 05, 2013 at 10:04:16AM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Fri, Oct 04, 2013 at 10:44:05PM +0200, Peter Zijlstra wrote:
> > > > 
> > > > slightly related; do we want to do something like the following two
> > > > patches?
> > > 
> > > and
> > 
> > Yeah, both look good to me - but I'd move them into 
> > kernel/sched/completion.c and kernel/sched/wait.c if no-one objects.
> 
> Do you also want to suck in semaphore.c mutex.c rwsem.c spinlock.c etc? 
> Or do you want to create something like kernel/locking/ for all that.

Yeah, I think kernel/locking/ would be a suitable place for those, and I'd 
move lockdep*.c there too. (Such things are best done near the end of a 
merge window, when there's not much pending, to not disrupt development.)

kernel/*.c is a pretty crowded place with 100+ files currently, I've been 
gradually working towards depopulating it slowly but surely for subsystems 
that I co-maintain or where I'm frequently active. We already have:

  kernel/sched/
  kernel/events/
  kernel/irq/
  kernel/time/
  kernel/trace/

and the deeper kernel/*/* hierarchies already host another ~100 .c files. 
So the transition is half done already I suspect.

Thanks,

	Ingo
