Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab3DYRmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:42:15 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37045 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab3DYRmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:42:14 -0400
Date: Thu, 25 Apr 2013 19:42:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130425174211.GE16732@two.firstfloor.org>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <20130425162535.GA5828@dyad.programming.kicks-ass.net>
 <20130425164100.GC16732@two.firstfloor.org>
 <20130425164837.GD5828@dyad.programming.kicks-ass.net>
 <20130425170037.GD16732@two.firstfloor.org>
 <20130425171842.GA8669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425171842.GA8669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:18:42PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 25, 2013 at 07:00:37PM +0200, Andi Kleen wrote:
> > > Traping the read deals with the first. The second shouldn't be a problem since
> > > we generally only allow kernel info for CAP_ADMIN; if we don't already for LBR
> > > that needs to be fixed separately.
> > 
> > Where is that check?  I don't see it.
> 
> Then that might need fixing.

Ok.

BTW I would just still argue that even paranoid == -1 should not allow
crashes. So even with that added it would still be a problem.

> 
> > Also remember that precise == 2 can enable LBR implicitly.
> 
> Sure.. but it doesn't need the filter stuff. Now I completely forgot if it will
> actually still use the filter muck.. /me goes check

True. It doesn't filter.

> I think intel_pmu_lbr_filter() will typically bail on the X86_BR_ALL test for
> PEBS fixup, it might only end up in the filter code if precise_br_compat()
> finds another LBR user compatible with the fixup.

Yes it does.

> 
> > > That only leaves the third.. can we descern MMIO maps from the kernel page tables?
> > 
> > In theory you could use some bits in the PTE for vmalloc, but it would need quite a
> > few changes.
> > 
> > Also there may be corner cases where MMIO is in the direct mapping or in
> > the kernel mapping.
> 
> Hrmm... do we keep track of the MMIO regions somewhere at all?

There's the non cachable region tracking. But there's no guarantee a
MMIO has to be in there, driver may still rely just on MTRRs. Also
there may be MMIOs the kernel doesn't know about which just happen
to be somewhere in the direct mapping.

I don't see any reliable way to detect all mmios.

-Andi
