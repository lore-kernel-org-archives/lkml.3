Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3LTIRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:17:19 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36672 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3LTIRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:17:18 -0500
Date: Fri, 20 Dec 2013 09:17:13 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Davidlohr Bueso <davidlohr@hp.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Subject: Re: [PATCH v4 3/4] futex: Document ordering guarantees
Message-ID: <20131220081713.GC12937@gmail.com>
References: <1387485950-7320-1-git-send-email-davidlohr@hp.com>
 <1387485950-7320-4-git-send-email-davidlohr@hp.com>
 <52B35C64.3050504@infradead.org>
 <1387486823.5494.5.camel@buesod1.americas.hpqcorp.net>
 <1387487274.3510.18.camel@dvhart-mobl4.amr.corp.intel.com>
 <52B37BAA.60200@infradead.org>
 <1387495199.3510.38.camel@dvhart-mobl4.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387495199.3510.38.camel@dvhart-mobl4.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhart@linux.intel.com> wrote:

> On Thu, 2013-12-19 at 15:05 -0800, Randy Dunlap wrote:
> > On 12/19/13 13:07, Darren Hart wrote:
> > > On Thu, 2013-12-19 at 13:00 -0800, Davidlohr Bueso wrote:
> > >> On Thu, 2013-12-19 at 12:51 -0800, Randy Dunlap wrote:
> > >>> On 12/19/13 12:45, Davidlohr Bueso wrote:
> > >>>> From: Thomas Gleixner <tglx@linutronix.de>
> > >>>>
> > >>>> That's essential, if you want to hack on futexes.
> > >>>>
> > >>>> Cc: Ingo Molnar <mingo@kernel.org>
> > >>>> Cc: Darren Hart <dvhart@linux.intel.com>
> > >>>> Acked-by: Peter Zijlstra <peterz@infradead.org>
> > >>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> > >>>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >>>> Cc: Mike Galbraith <efault@gmx.de>
> > >>>> Cc: Jeff Mahoney <jeffm@suse.com>
> > >>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > >>>> Cc: Scott Norton <scott.norton@hp.com>
> > >>>> Cc: Tom Vaden <tom.vaden@hp.com>
> > >>>> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> > >>>> Cc: Waiman Long <Waiman.Long@hp.com>
> > >>>> Cc: Jason Low <jason.low2@hp.com>
> > >>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > >>>> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > >>>> ---
> > >>>>  kernel/futex.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >>>>  1 file changed, 57 insertions(+)
> > >>>>
> > >>>> diff --git a/kernel/futex.c b/kernel/futex.c
> > >>>> index 577481d..af1fc31 100644
> > >>>> --- a/kernel/futex.c
> > >>>> +++ b/kernel/futex.c
> > >>>> @@ -69,6 +69,63 @@
> > >>>>  
> > >>>>  #include "locking/rtmutex_common.h"
> > >>>>  
> > >>>> +/*
> > >>>> + * Basic futex operation and ordering guarantees:
> > >>>> + *
> > >>>> + * The waiter reads the futex value in user space and calls
> > >>>> + * futex_wait(). It computes the hash bucket and acquires the hash
> > >>>
> > >>> does                It
> > >>> refer to "the waiter" or to futex_wait()?
> > >>> I read it as referring to the waiter, but ISTM that the comments are using It
> > >>> to refer to futex_wait()... ???
> > >>>
> > >>
> > >> Yes, it refers to futex_wait(), which IMO in a futex context is pretty
> > >> clear.
> > > 
> > > 
> > > Agreed.
> > > 
> > > 
> > 
> > I'll just have to get by with disagreeing with both of you then.
> > I say that the pronoun's antecedent is ambiguous (unclear).
> > 
> 
> You are correct from a purely grammatical perspective, no argument 
> there. I just feel that the comment is clear enough from the context 
> - although perhaps people that hack on futexes should be excluded 
> from having an opinion here as we are biased :-)

It doesn't really matter that to _you_ (the futex expert) the sentence 
seems unambiguous, such comments are mostly meant for new people 
reading the code, such as Randy!

So guys please fix the comment instead of arguing about it.

Thanks,

	Ingo
