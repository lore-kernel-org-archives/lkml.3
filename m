Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaFEDJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 23:09:05 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:1840 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFEDJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 23:09:03 -0400
Message-ID: <1401937739.6680.5.camel@j-VirtualBox>
Subject: Re: [RFC PATCH 3/3] locking/mutex: Optimize mutex trylock slowpath
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tim.c.chen@linux.intel.com,
        peter@hurleysoftware.com, riel@redhat.com, hpa@zytor.com,
        walken@google.com, Waiman.Long@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Date: Wed, 04 Jun 2014 20:08:59 -0700
In-Reply-To: <1401930628.13877.29.camel@buesod1.americas.hpqcorp.net>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
	 <1401908911-8947-4-git-send-email-jason.low2@hp.com>
	 <1401913714.13877.11.camel@buesod1.americas.hpqcorp.net>
	 <1401918431.2232.32.camel@j-VirtualBox>
	 <1401930628.13877.29.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 18:10 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-06-04 at 14:47 -0700, Jason Low wrote:
> > On Wed, 2014-06-04 at 13:28 -0700, Davidlohr Bueso wrote:
> > > On Wed, 2014-06-04 at 12:08 -0700, Jason Low wrote:
> > > > In __mutex_trylock_slowpath(), we acquire the wait_lock spinlock,
> > > > xchg() lock->count with -1, then set lock->count back to 0 if there
> > > > are no waiters, and return true if the prev lock count was 1.
> > > > 
> > > > However, if we the mutex is already locked, then there may not be
> > >              ^^ leave that out.
> > > 
> > > > much point in attempting the above operations. 
> > > 
> > > Isn't this redundant? I mean, if we enter the slowpath its because
> > > __mutex_fastpath_trylock() already failed so we already know that the
> > > lock is taken.
> > 
> > This function is really just used as an alternative method of trylock
> > for !__HAVE_ARCH_CMPXCHG.  In that case, the fastpath can call directly
> > into the slowpath function, without checking for if the lock is taken.
> 
> Ah, ok I hadn't seen that we do this in 32bit x86 and was wondering why
> the heck we fallback on a slowpath for something like trylock, which
> should return right away no matter what. I'd suggest explicitly
> mentioning this in the changelog. Otherwise makes sense now.

Yup, I was also initially wondering why we have a slowpath for trylock,
which prompted me to take a look into this function. I'll add some more
information about this to the changelog.

Thanks,
Jason

