Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3IIQQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:16:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55611 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3IIQQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:16:36 -0400
Date: Mon, 9 Sep 2013 18:15:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909161559.GE26785@twins.programming.kicks-ass.net>
References: <20130906151851.GQ3966@linux.vnet.ibm.com>
 <1378488088.31445.39.camel@edumazet-glaptop>
 <20130906174117.GU3966@linux.vnet.ibm.com>
 <20130906185927.GE2706@somewhere>
 <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909132343.GN3966@linux.vnet.ibm.com>
 <20130909133604.GC31370@twins.programming.kicks-ass.net>
 <000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
 <20130909150854.GD26785@twins.programming.kicks-ass.net>
 <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 03:24:55PM +0000, Christoph Lameter wrote:
> On Mon, 9 Sep 2013, Peter Zijlstra wrote:
> 
> > > Slander. Certainly validation is good. Its just that PREEMPT kernels are
> > > not in use
> >
> > Complete bullshit, its part of the mainline kernel, lots of people run
> > them -- including me, and any patch is supposed to keep it working.
> 
> Nonsense. There is no main line distro that supports full preempt. Its an
> academic exercise.

You have a weird definition of academia. And you might not think the
various distro's that do support PREEMPT aren't big enough for you but
that doesn't mean they're not there.

Also, you don't need a major distro to be 'in use'.

Furthermore, there's RedHat MRG that ships PREEMPT_RT which is a full
superset of PREEMPT. And I'm fairly sure there's other commercial
distros out there doing the same.

> > > and AFAICT the full preempt stuff requires significant developer
> > > support and complicates the code without much benefit.
> >
> > More bullshit, each and every patch submitted must fully support all
> > preemption modes supported by the kernel. CONFIG_PREEMPT is in, no two
> > ways about it. Breaking it is a regression and reason to revert stuff.
> 
> Right so you have enforcing that developers spend time to maintain a
> useless kernel option. We have lots of other things to worry about.

This useless option has found/exposed genuine SMP locking errors, driven
developers to create validation frameworks such as lockdep and forced
people to think harder on serialization. Yes all useless things.

> > Therefore every Linux developer supports it per definition. And clearly
> > the complication is worth it for enough people, otherwise it wouldn't be
> > there.
> 
> Where is the worth? The only thing that I heard last time that I
> brought it up is that there is some audio specialty distro. Guess that
> needs it to support broken old audio boards? Cannot believe that a kernel
> with PREEMPT_VOLUNTARY cannot handle audio. All my Linux workstations do
> just fine without full preemption.

Right.. you don't use it, therefore its useless. How classic you.

> It seems that even RT is moving away from full preemption due to the
> performance issue. Wake up!!

It is not. The main goal of RT is still to have minimal and worst case
bounded context switch time for a higher priority task. 
