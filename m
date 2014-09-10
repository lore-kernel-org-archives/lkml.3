Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaIJV7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:59:12 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53911 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaIJV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:59:11 -0400
Date: Wed, 10 Sep 2014 23:59:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: BUG uncore_assign_events
Message-ID: <20140910215908.GL4120@two.firstfloor.org>
References: <20140910091626.GO16043@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910091626.GO16043@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> # addr2line -i -e ivb-ep-build/vmlinux ffffffff81025f18
> 
> arch/x86/include/asm/bitops.h:318
> arch/x86/kernel/cpu/perf_event_intel_uncore.c:3339

i == zero  (ok)
c points to some kernel looking address
hwc->idx is 64

     /* fastpath, try to reuse previous register */
        for (i = 0; i < n; i++) {
                hwc = &box->event_list[i]->hw;
                c = hwc->constraint;

                /* never assigned */
                if (hwc->idx == -1)
                        break;

                /* constraint still honored */
                if (!test_bit(hwc->idx, c->idxmsk))
                        break;

My best bet is something goes wrong in uncore_pmu_to_box or
uncore_event_to_pmu in hte caller, so the box is bogus.

Did the test do CPU hot plug?

BTW i don't think it's a security issue because the uncore driver
is only accesible for root.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
