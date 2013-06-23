Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab3FWFKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 01:10:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:51661 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3FWFKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 01:10:20 -0400
Date: Sun, 23 Jun 2013 07:10:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] rwsem: check the lock before cpmxchg in
 down_write_trylock and rwsem_do_wake
Message-ID: <20130623051018.GS6123@two.firstfloor.org>
References: <cover.1371855277.git.tim.c.chen@linux.intel.com>
 <1371858695.22432.4.camel@schen9-DESK>
 <51C55082.5040500@hurleysoftware.com>
 <51C64C5D.5090400@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C64C5D.5090400@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
> >> index bb1e2cd..052d973 100644
> >> --- a/include/asm-generic/rwsem.h
> >> +++ b/include/asm-generic/rwsem.h
> >> @@ -70,11 +70,11 @@ static inline void __down_write(struct
> >> rw_semaphore *sem)
> >>
> >>   static inline int __down_write_trylock(struct rw_semaphore *sem)
> >>   {
> >> -    long tmp;
> >> +    if (unlikely(&sem->count != RWSEM_UNLOCKED_VALUE))
> >                      ^^^^^^^^^^^
> > 
> > This is probably not what you want.
> > 
> 
> this function logical is quite simple. check the sem->count before
> cmpxchg is no harm this logical.
> 
> So could you like to tell us what should we want?

You are comparing the address, not the value. Remove the &
This was a nop too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
