Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbaGYQkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:40:46 -0400
Received: from one.firstfloor.org ([193.170.194.197]:59129 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760823AbaGYQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:40:45 -0400
Date: Fri, 25 Jul 2014 18:40:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS
 buffer
Message-ID: <20140725164041.GH18735@two.firstfloor.org>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <20140725150445.GG18735@two.firstfloor.org>
 <20140725155332.GC6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725155332.GC6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Suppose two pebs events, one has exclude_kernel set. It overflows,
> before entering the kernel, the other event generates PEBS records from
> inside the kernel with both events marked in the overflow field.
> 
> And only once we leave the kernel can the exclude_kernel event tick
> again and trigger the assist, finalyl clearing the bit.
> 
> If you were to report the records to both events, one would get a lot of
> kernel info he was not entitled to.

Ok that case can be filtered in software. Shouldn't be too difficult.
Perhaps just using ip

	if (event->attr.exclude_kernel && pebs->ip >= __PAGE_OFFSET)
	    skip;
	if (event->attr.exclude_user && pebs->ip < __PAGE_OFFSET)
	    skip;

This would also help with the existing skid.

Any other concerns?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
