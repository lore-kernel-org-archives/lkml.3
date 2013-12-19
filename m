Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab3LSVA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:00:26 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23390 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3LSVAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:00:25 -0500
Message-ID: <1387486823.5494.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v4 3/4] futex: Document ordering guarantees
From: Davidlohr Bueso <davidlohr@hp.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, dvhart@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        efault@gmx.de, jeffm@suse.com, torvalds@linux-foundation.org,
        jason.low2@hp.com, Waiman.Long@hp.com, tom.vaden@hp.com,
        scott.norton@hp.com, aswin@hp.com, Ingo Molnar <mingo@kernel.org>
Date: Thu, 19 Dec 2013 13:00:23 -0800
In-Reply-To: <52B35C64.3050504@infradead.org>
References: <1387485950-7320-1-git-send-email-davidlohr@hp.com>
	 <1387485950-7320-4-git-send-email-davidlohr@hp.com>
	 <52B35C64.3050504@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 12:51 -0800, Randy Dunlap wrote:
> On 12/19/13 12:45, Davidlohr Bueso wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > That's essential, if you want to hack on futexes.
> > 
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Darren Hart <dvhart@linux.intel.com>
> > Acked-by: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Jeff Mahoney <jeffm@suse.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Scott Norton <scott.norton@hp.com>
> > Cc: Tom Vaden <tom.vaden@hp.com>
> > Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> > Cc: Waiman Long <Waiman.Long@hp.com>
> > Cc: Jason Low <jason.low2@hp.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  kernel/futex.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 57 insertions(+)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 577481d..af1fc31 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -69,6 +69,63 @@
> >  
> >  #include "locking/rtmutex_common.h"
> >  
> > +/*
> > + * Basic futex operation and ordering guarantees:
> > + *
> > + * The waiter reads the futex value in user space and calls
> > + * futex_wait(). It computes the hash bucket and acquires the hash
> 
> does                It
> refer to "the waiter" or to futex_wait()?
> I read it as referring to the waiter, but ISTM that the comments are using It
> to refer to futex_wait()... ???
> 

Yes, it refers to futex_wait(), which IMO in a futex context is pretty
clear.

Thanks,
Davidlohr

