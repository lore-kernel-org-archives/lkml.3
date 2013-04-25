Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab3DYRAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:00:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab3DYRAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:00:40 -0400
Date: Thu, 25 Apr 2013 19:00:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130425170037.GD16732@two.firstfloor.org>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <20130425162535.GA5828@dyad.programming.kicks-ass.net>
 <20130425164100.GC16732@two.firstfloor.org>
 <20130425164837.GD5828@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425164837.GD5828@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Traping the read deals with the first. The second shouldn't be a problem since
> we generally only allow kernel info for CAP_ADMIN; if we don't already for LBR
> that needs to be fixed separately.

Where is that check?  I don't see it.

Also remember that precise == 2 can enable LBR implicitly.

> That only leaves the third.. can we descern MMIO maps from the kernel page tables?

In theory you could use some bits in the PTE for vmalloc, but it would need quite a
few changes.

Also there may be corner cases where MMIO is in the direct mapping or in
the kernel mapping.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
