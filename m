Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab3GSTlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:41:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:51428 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3GSTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:41:20 -0400
Date: Fri, 19 Jul 2013 21:41:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
In-Reply-To: <51E98EB4.3080307@hp.com>
Message-ID: <alpine.DEB.2.02.1307192139140.4089@ionos.tec.linutronix.de>
References: <20130719183101.GA20909@twins.programming.kicks-ass.net> <51E98EB4.3080307@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, Waiman Long wrote:
> On 07/19/2013 02:31 PM, Peter Zijlstra wrote:
> >   	rcu_read_lock();
> > -	if (lock->owner)
> > -		retval = lock->owner->on_cpu;
> > +	owner = ACCESS_ONCE(lock->owner);
> > +	if (owner)
> > +		retval = owner->on_cpu;
> >   	rcu_read_unlock();
> >   	/*
> >   	 * if lock->owner is not set, the mutex owner may have just
> > acquired
> 

> I am fine with this change. However, the compiler is smart enough to
> not do two memory accesses to the same memory location. So this will
> not change the generated code. Below is the relevant x86 code for
> that section of code:

That's true for your particular compiler, but it's not guaranteed at
all. So it matters even when your compiler generates the same
code. Others might not. There is a world outside of x8664.
 
Thanks,

	tglx
