Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaD2DFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:05:23 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:13482 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaD2DFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:05:22 -0400
Message-ID: <1398740708.25549.47.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Mon, 28 Apr 2014 20:05:08 -0700
In-Reply-To: <1398732649.2970.89.camel@schen9-DESK>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140428231002.GO4430@linux.vnet.ibm.com>
	 <1398732649.2970.89.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 17:50 -0700, Tim Chen wrote:
> On Mon, 2014-04-28 at 16:10 -0700, Paul E. McKenney wrote:
> 
> > > +#ifdef CONFIG_SMP
> > > +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> > > +{
> > > +	int retval;
> > > +	struct task_struct *owner;
> > > +
> > > +	rcu_read_lock();
> > > +	owner = ACCESS_ONCE(sem->owner);
> > 
> > OK, I'll bite...
> > 
> > Why ACCESS_ONCE() instead of rcu_dereference()?
> 
> We're using it as a speculative check on the sem->owner to see
> if the owner is running on the cpu.  The rcu_read_lock
> is used for ensuring that the owner->on_cpu memory is
> still valid.

Something worth documenting in the code, imho. I'll add it in an
eventual v3.

Thanks,
Davidlohr

