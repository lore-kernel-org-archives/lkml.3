Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaD2QHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:07:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:55397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbaD2QHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,951,1389772800"; 
   d="scan'208";a="503003241"
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Tim Chen <tim.c.chen@linux.intel.com>
To: paulmck@linux.vnet.ibm.com
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
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
In-Reply-To: <20140429151100.GC8754@linux.vnet.ibm.com>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140428231002.GO4430@linux.vnet.ibm.com>
	 <1398732649.2970.89.camel@schen9-DESK>
	 <20140429151100.GC8754@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Apr 2014 09:00:05 -0700
Message-ID: <1398787205.2970.90.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-29 at 08:11 -0700, Paul E. McKenney wrote:
> On Mon, Apr 28, 2014 at 05:50:49PM -0700, Tim Chen wrote:
> > On Mon, 2014-04-28 at 16:10 -0700, Paul E. McKenney wrote:
> > 
> > > > +#ifdef CONFIG_SMP
> > > > +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> > > > +{
> > > > +	int retval;
> > > > +	struct task_struct *owner;
> > > > +
> > > > +	rcu_read_lock();
> > > > +	owner = ACCESS_ONCE(sem->owner);
> > > 
> > > OK, I'll bite...
> > > 
> > > Why ACCESS_ONCE() instead of rcu_dereference()?
> > 
> > We're using it as a speculative check on the sem->owner to see
> > if the owner is running on the cpu.  The rcu_read_lock
> > is used for ensuring that the owner->on_cpu memory is
> > still valid.
> 
> OK, so if we read complete garbage, all that happens is that we
> lose a bit of performance?  

Correct.

> If so, I am OK with it as long as there
> is a comment (which Davidlohr suggested later in this thread).
> 
Yes, we should add some comments to clarify things.

Thanks.

Tim


