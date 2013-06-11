Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3FKQp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:45:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56164 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3FKQp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:45:26 -0400
Date: Tue, 11 Jun 2013 09:45:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611164503.GI5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370911480.9844.160.camel@gandalf.local.home>
 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
 <51B6D76D.9090207@cn.fujitsu.com>
 <20130611101401.GC5146@linux.vnet.ibm.com>
 <1370964165.9844.172.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370964165.9844.172.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061116-3620-0000-0000-0000030EB77A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 11:22:45AM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-11 at 03:14 -0700, Paul E. McKenney wrote:
> >  
> > > Off-topic, although I am in this community for several years,
> > > I am not exactly clear with this problem.
> > > 
> > > 1) In general case, which lock is the most competitive in the kernel? what it protects for?
> > > 2) In which special case, which lock is the most competitive in the kernel? what it protects for?
> > > 3) In general case, which list is the most hot list?
> > > 4) In which special case, which list is the most hot list?
> > 
> > Others would know better than I, but mmap_sem has been called out as a
> 
> If the contention is with mmap_sem, then I doubt this is going to help
> much, as that's a sleeping rw semaphore. Now, rw semaphores are
> implemented with raw spinlocks, but I doubt that would be the main point
> of contention, compared to the sleeping part.

If I remember correctly, someone actually hit this earlier this year,
which prompted use of a special-purpose queued lock to guard the
semaphore data.  I don't recall whether it was mmap_sem or not, so
cannot say whether it was a straight mutex or an rw semaphore.

							Thanx, Paul

> -- Steve
> 
> > prime offender for some workloads.  There is of course some debate as
> > to whether the fault lies mmap_sem or with the workloads.  There have
> > been some efforts to solve this one on LKML, plus some in academia have
> > worked on this as well:
> > 
> 
> 

