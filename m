Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaEUTxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:53:11 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:44706 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaEUTxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:53:10 -0400
Message-ID: <1400701978.2646.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH] mutex: Documentation rewrite
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        waiman.long@hp.com, jason.low2@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 12:52:58 -0700
In-Reply-To: <1400698977.2970.308.camel@schen9-DESK>
References: <1400694115.2646.4.camel@buesod1.americas.hpqcorp.net>
	 <1400698977.2970.308.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 12:02 -0700, Tim Chen wrote:
> On Wed, 2014-05-21 at 10:41 -0700, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <davidlohr@hp.com>
> > 
> > Our mutexes have gone a long ways since the original implementation
> > back in 2005/2006. However, the mutex-design.txt document is still
> > stuck in the past, to the point where most of the information there
> > is practically useless and, more important, simply incorrect. This
> > patch pretty much rewrites it to resemble what we have nowadays.
> > 
> > Since regular semaphores are almost much extinct in the kernel
> > (most users now rely on mutexes or rwsems), it no longer makes
> > sense to have such a close comparison, which was copied from most
> > of the cover letter when Ingo introduced the generic mutex subsystem.
> > 
> > While users who really want to learn more about kernel mutexes can
> > go and read the code, I have marked this RFC since I'm sure more gory
> > details can be included. Also, ww_mutexes are intentionally left out,
> > leaving things as generic as possible.
> > 
> > Comments welcome!
> 
> Thanks for doing this.
> 
> > +
> > +(iii) slowpath: last resource, if the lock is still unable to be acquired
> 
> change "last resource" to "last resort"

Ops, yes, that's what I meant.

> >  
> >  Disadvantages
> >  -------------
> >  
> > -The stricter mutex API means you cannot use mutexes the same way you
> > -can use semaphores: e.g. they cannot be used from an interrupt context,
> > -nor can they be unlocked from a different context that which acquired
> > -it. [ I'm not aware of any other (e.g. performance) disadvantages from
> > -using mutexes at the moment, please let me know if you find any. ]
> > -
> 
> Should we keep this instead of deleting it?  It is still true we
> cannot use mutex from an interrupt context.

Well I wouldn't necessarily classify 'cannot be used from interrupt
context' as something bad, it's just a characteristic of mutexes. Since
we mention it in the Semantics part I thought we can remove it.

