Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaFDTo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:44:56 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:59283 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaFDToz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:44:55 -0400
Message-ID: <1401911076.13877.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andev <debiandev@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Tim Chen <tim.c.chen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 04 Jun 2014 12:44:36 -0700
In-Reply-To: <CAJUuVQ4j93AXCij22eCdYT4L-hrshvbuisJQe8KPkYh2vx3+Xg@mail.gmail.com>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140428231002.GO4430@linux.vnet.ibm.com>
	 <1398732649.2970.89.camel@schen9-DESK>
	 <20140429151100.GC8754@linux.vnet.ibm.com>
	 <CAJUuVQ4j93AXCij22eCdYT4L-hrshvbuisJQe8KPkYh2vx3+Xg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 13:57 -0400, Andev wrote:
> Hi,
> 
> On Tue, Apr 29, 2014 at 11:11 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Mon, Apr 28, 2014 at 05:50:49PM -0700, Tim Chen wrote:
> >> On Mon, 2014-04-28 at 16:10 -0700, Paul E. McKenney wrote:
> >>
> >> > > +#ifdef CONFIG_SMP
> >> > > +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> >> > > +{
> >> > > + int retval;
> >> > > + struct task_struct *owner;
> >> > > +
> >> > > + rcu_read_lock();
> >> > > + owner = ACCESS_ONCE(sem->owner);
> >> >
> >> > OK, I'll bite...
> >> >
> >> > Why ACCESS_ONCE() instead of rcu_dereference()?
> >>
> >> We're using it as a speculative check on the sem->owner to see
> >> if the owner is running on the cpu.  The rcu_read_lock
> >> is used for ensuring that the owner->on_cpu memory is
> >> still valid.
> >
> > OK, so if we read complete garbage, all that happens is that we
> > lose a bit of performance?  If so, I am OK with it as long as there
> > is a comment (which Davidlohr suggested later in this thread).
> >
> >                                                         Thanx, Paul
> >
> 
> The latest code seems to be missing this comment. Could you please add this?

The comment is there when we declare ->owner in struct rw_semaphore.


