Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbaDIPmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:42:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46722 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaDIPmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:42:31 -0400
Date: Wed, 9 Apr 2014 17:42:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        linux-man@vger.kernel.org
Subject: Re: sched_{set,get}attr() manpage
Message-ID: <20140409154204.GD10526@twins.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123352.692059839@infradead.org>
 <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
 <20140121153851.GZ31570@twins.programming.kicks-ass.net>
 <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com>
 <20140214161929.GL27965@twins.programming.kicks-ass.net>
 <53020C9D.1050208@gmail.com>
 <20140409092510.GQ11096@twins.programming.kicks-ass.net>
 <20140409151911.GA4041@austad.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140409151911.GA4041@austad.us>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:19:11PM +0200, Henrik Austad wrote:
> > 	The following "real-time" policies are also supported, for
> 
> why the "'s?

I borrowed those from SCHED_SETSCHEDULER(2).

> > 	sched_attr::sched_flags additional flags that can influence
> > 	scheduling behaviour. Currently as per Linux kernel 3.14:
> > 
> > 		SCHED_FLAG_RESET_ON_FORK - resets the scheduling policy
> > 		to: (struct sched_attr){ .sched_policy = SCHED_OTHER, }
> > 		on fork().
> > 
> > 	is the only supported flag.

...

> > 	The flags argument should be 0.
> 
> What about SCHED_FLAG_RESET_ON_FOR?

Different flags. The one is sched_attr::flags the other is
sched_setattr(.flags).

> > 	The other sched_attr fields are filled out as described in
> > 	sched_setattr().
> > 
> >    Scheduling Policies
> >        The  scheduler  is  the  kernel  component  that decides which runnable
> >        process will be executed by the CPU next.  Each process has an  associ‐
> >        ated  scheduling  policy and a static scheduling priority, sched_prior‐
> >        ity; these are the settings that are modified by  sched_setscheduler().
> >        The  scheduler  makes it decisions based on knowledge of the scheduling
> >        policy and static priority of all processes on the system.
> 
> Isn't this last sentence redundant/sliglhtly repetitive?

I borrowed that from SCHED_SETSCHEDULER(2) again.

> >     SCHED_DEADLINE: Sporadic task model deadline scheduling
> > 	SCHED_DEADLINE is an implementation of GEDF (Global Earliest
> > 	Deadline First) with additional CBS (Constant Bandwidth Server).
> > 	The CBS guarantees that tasks that over-run their specified
> > 	budget are throttled and do not affect the correct performance
> > 	of other SCHED_DEADLINE tasks.
> > 
> > 	SCHED_DEADLINE tasks will fail FORK(2) with -EAGAIN
> > 
> > 	Setting SCHED_DEADLINE can fail with -EINVAL when admission
> > 	control tests fail.
> 
> Perhaps add a note about the deadline-class having higher priority than the 
> other classes; i.e. if a deadline-task is runnable, it will preempt any 
> other SCHED_(RR|FIFO) regardless of priority?

Yes, good point, will do.

> >    SCHED_FIFO: First In-First Out scheduling
> >        SCHED_FIFO can only be used with static priorities higher than 0, which
> >        means that when a SCHED_FIFO processes becomes runnable, it will always
> >        immediately preempt any currently running SCHED_OTHER, SCHED_BATCH,  or
> >        SCHED_IDLE  process.  SCHED_FIFO is a simple scheduling algorithm with‐
> >        out time slicing.  For processes scheduled under the SCHED_FIFO policy,
> >        the following rules apply:
> > 
> >        *  A  SCHED_FIFO  process that has been preempted by another process of
> >           higher priority will stay at the head of the list for  its  priority
> >           and  will resume execution as soon as all processes of higher prior‐
> >           ity are blocked again.
> > 
> >        *  When a SCHED_FIFO process becomes runnable, it will be  inserted  at
> >           the end of the list for its priority.
> > 
> >        *  A  call  to  sched_setscheduler()  or sched_setparam(2) will put the
> >           SCHED_FIFO (or SCHED_RR) process identified by pid at the  start  of
> >           the  list  if it was runnable.  As a consequence, it may preempt the
> >           currently  running  process   if   it   has   the   same   priority.
> >           (POSIX.1-2001 specifies that the process should go to the end of the
> >           list.)
> > 
> >        *  A process calling sched_yield(2) will be put at the end of the list.
> 
> How about the recent discussion regarding sched_yield(). Is this correct?
> 
> lkml.kernel.org/r/alpine.DEB.2.02.1403312333100.14882@ionos.tec.linutronix.de
> 
> Is this the correct place to add a note explaining te potentional pitfalls 
> using sched_yield?

I'm not sure; there's a SCHED_YIELD(2) manpage to fill with that
nonsense.

Also; I realized I have not described the DEADLINE sched_yield()
behaviour.

> >        No other events will move a process scheduled under the SCHED_FIFO pol‐
> >        icy in the wait list of runnable processes with equal static priority.
> > 
> >        A SCHED_FIFO process runs until either it is blocked by an I/O request,
> >        it  is  preempted  by  a  higher  priority   process,   or   it   calls
> >        sched_yield(2).
> > 
> >    SCHED_RR: Round Robin scheduling
> >        SCHED_RR  is  a simple enhancement of SCHED_FIFO.  Everything described
> >        above for SCHED_FIFO also applies to SCHED_RR, except that each process
> >        is  only  allowed  to  run  for  a maximum time quantum.  If a SCHED_RR
> >        process has been running for a time period equal to or longer than  the
> >        time  quantum,  it will be put at the end of the list for its priority.
> >        A SCHED_RR process that has been preempted by a higher priority process
> >        and  subsequently  resumes execution as a running process will complete
> >        the unexpired portion of its round robin time quantum.  The  length  of
> >        the time quantum can be retrieved using sched_rr_get_interval(2).
> 
> -> Default is 0.1HZ ms
> 
> This is a question I get form time to time, having this in the manpage 
> would be helpful.

Again, brazenly stolen from SCHED_SETSCHEDULER(2); but yes. Also I'm not
sure I'd call RR an enhancement of anything much at all ;-)

> > ERRORS
> >        EINVAL The scheduling policy is not one  of  the  recognized  policies,
> >               param is NULL, or param does not make sense for the policy.
> > 
> >        EPERM  The calling process does not have appropriate privileges.
> > 
> >        ESRCH  The process whose ID is pid could not be found.
> > 
> >        E2BIG  The provided storage for struct sched_attr is either too
> >               big, see sched_setattr(), or too small, see sched_getattr().
> 
> Where's the EBUSY? It can throw this from __sched_setscheduler() when it 
> checks if there's enough bandwidth to run the task.

Uhhm.. it got lost :-) /me quickly adds.
