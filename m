Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaCFWlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 17:41:50 -0500
Received: from one.firstfloor.org ([193.170.194.197]:34898 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaCFWlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 17:41:49 -0500
Date: Thu, 6 Mar 2014 23:41:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kevin Easton <kevin@guarana.org>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Khalid Aziz <khalid.aziz@oracle.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140306224146.GG22728@two.firstfloor.org>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
 <531641A8.40306@zytor.com>
 <53164824.3000704@oracle.com>
 <20140304222356.41c55bbc@alan.etchedpixels.co.uk>
 <5316574F.6040105@oracle.com>
 <8738ix5uyk.fsf@tassilo.jf.intel.com>
 <20140306121333.GA12127@chicago.guarana.org>
 <20140306135946.GM9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306135946.GM9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 02:59:46PM +0100, Peter Zijlstra wrote:
> On Thu, Mar 06, 2014 at 11:13:33PM +1100, Kevin Easton wrote:
> > On Tue, Mar 04, 2014 at 04:51:15PM -0800, Andi Kleen wrote:
> > > Anything else?
> > 
> > If it was possible to make the time remaining in the current timeslice
> > available to userspace through the vdso, the thread could do something like:
> 
> Assuming we can do per-cpu values in the VDSO; this would mean hitting
> that cacheline on every context switch and wakeup. That's a complete
> non-starter performance wise.

If you worry about fetching it you can always prefetch it early.

> > if (sys_timeleft() < CRITICAL_SECTION_SIZE)
> >     yield();
> > lock();
> > 
> > to avoid running out of timeslice in the middle of the critical section.
> 
> Can still happen, the effective slice of a single runnable task is
> infinite, the moment another task gets woken this gets reduced to a finite
> amount, we then keep reducing the slice until there are about 8 runnable
> tasks (assuming you've not poked at any sysctls).

I guess it could be some predicted value, similar to how the menu
governour works.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
