Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3H0NxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:53:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34210 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3H0NxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:53:23 -0400
Date: Tue, 27 Aug 2013 15:53:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexander Fyodorov <halcy@yandex.ru>, Waiman Long <waiman.long@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue
 spinlock implementation
Message-ID: <20130827135309.GF10002@twins.programming.kicks-ass.net>
References: <15321377012704@web8h.yandex.ru>
 <52142D6C.6000400@hp.com>
 <336901377100289@web16f.yandex.ru>
 <5215638E.5020702@hp.com>
 <169431377178121@web21f.yandex.ru>
 <521BB71F.6080300@hp.com>
 <66111377605355@web12m.yandex.ru>
 <20130827091436.3d5971a0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827091436.3d5971a0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 09:14:36AM -0400, Steven Rostedt wrote:

> I just had this conversation with Paul McKenney. Should there be a
> smp_mb_after_spin_unlock()?

Depends on the benefits I suppose :-) Oleg and Linus did recently add
smp_mb__before_spinlock();

> Although we blew it off as adding too many extensions to smp_mb(). But
> it may be better than reimplementing something as complex as a lock.

Locks should be as light weight as possible and never implement anything
heavier than the ACQUISITION / RELEASE barriers if at all possible. We
should certainly not re-implement spinlocks just to get full barriers
out of them, that's crazy.
