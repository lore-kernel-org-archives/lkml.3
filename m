Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992AbaD3QuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:50:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:36730 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3QuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:50:18 -0400
Date: Wed, 30 Apr 2014 18:50:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
Message-ID: <20140430165014.GI11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
 <20140430090420.GB11096@twins.programming.kicks-ass.net>
 <CAGQ1y=4oyErcwikuyDVZchigWKw0mg_vZGA5XmmG_JghmoPC+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGQ1y=4oyErcwikuyDVZchigWKw0mg_vZGA5XmmG_JghmoPC+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 09:33:34AM -0700, Jason Low wrote:
> > static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> > {
> >         struct task_struct *owner;
> >         bool on_cpu = false;
> 
> Wouldn't we want to initialize on_cpu = true. For the !owner case, I
> would expect that we want to spin for the lock.
> 
> >         rcu_read_lock();
> >         owner = ACCESS_ONCE(sem->owner);
> >         if (owner)
> >                 on_cpu = owner->on_cpu;
> >         rcu_read_unlock();
> >
> >         return on_cpu;
> > }

That would indeed be in line with that the mutex code does. Indeed!
