Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3H1ITy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:19:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3H1ITw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:19:52 -0400
Date: Wed, 28 Aug 2013 10:19:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Fyodorov <halcy@yandex.ru>,
        Waiman Long <waiman.long@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue
 spinlock implementation
Message-ID: <20130828081937.GH10002@twins.programming.kicks-ass.net>
References: <15321377012704@web8h.yandex.ru>
 <52142D6C.6000400@hp.com>
 <336901377100289@web16f.yandex.ru>
 <5215638E.5020702@hp.com>
 <169431377178121@web21f.yandex.ru>
 <521BB71F.6080300@hp.com>
 <66111377605355@web12m.yandex.ru>
 <20130827091436.3d5971a0@gandalf.local.home>
 <20130827135309.GF10002@twins.programming.kicks-ass.net>
 <20130828012128.GT3871@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828012128.GT3871@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 06:21:29PM -0700, Paul E. McKenney wrote:
> On Tue, Aug 27, 2013 at 03:53:10PM +0200, Peter Zijlstra wrote:
> > On Tue, Aug 27, 2013 at 09:14:36AM -0400, Steven Rostedt wrote:
> > 
> > > I just had this conversation with Paul McKenney. Should there be a
> > > smp_mb_after_spin_unlock()?
> > 
> > Depends on the benefits I suppose :-) Oleg and Linus did recently add
> > smp_mb__before_spinlock();
> > 
> > > Although we blew it off as adding too many extensions to smp_mb(). But
> > > it may be better than reimplementing something as complex as a lock.
> > 
> > Locks should be as light weight as possible and never implement anything
> > heavier than the ACQUISITION / RELEASE barriers if at all possible. We
> > should certainly not re-implement spinlocks just to get full barriers
> > out of them, that's crazy.
> 
> An unlock followed by a lock needs to act like a full barrier, but there
> is no requirement that a lock or unlock taken separately act like a
> full barrier.

But that is already a property of the acquisition/release barrier.
