Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3DYRUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:20:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56877
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373Ab3DYRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:20:00 -0400
Date: Thu, 25 Apr 2013 19:18:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130425171842.GA8669@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <20130425162535.GA5828@dyad.programming.kicks-ass.net>
 <20130425164100.GC16732@two.firstfloor.org>
 <20130425164837.GD5828@dyad.programming.kicks-ass.net>
 <20130425170037.GD16732@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425170037.GD16732@two.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:00:37PM +0200, Andi Kleen wrote:
> > Traping the read deals with the first. The second shouldn't be a problem since
> > we generally only allow kernel info for CAP_ADMIN; if we don't already for LBR
> > that needs to be fixed separately.
> 
> Where is that check?  I don't see it.

Then that might need fixing.

> Also remember that precise == 2 can enable LBR implicitly.

Sure.. but it doesn't need the filter stuff. Now I completely forgot if it will
actually still use the filter muck.. /me goes check

I think intel_pmu_lbr_filter() will typically bail on the X86_BR_ALL test for
PEBS fixup, it might only end up in the filter code if precise_br_compat()
finds another LBR user compatible with the fixup.

> > That only leaves the third.. can we descern MMIO maps from the kernel page tables?
> 
> In theory you could use some bits in the PTE for vmalloc, but it would need quite a
> few changes.
> 
> Also there may be corner cases where MMIO is in the direct mapping or in
> the kernel mapping.

Hrmm... do we keep track of the MMIO regions somewhere at all?
