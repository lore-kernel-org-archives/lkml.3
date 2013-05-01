Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab3EAJ4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 05:56:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:12679 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab3EAJ4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 05:56:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,587,1363158000"; 
   d="scan'208";a="235263430"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
	<20130501090718.GA28253@dyad.programming.kicks-ass.net>
Date: Wed, 01 May 2013 02:56:32 -0700
In-Reply-To: <20130501090718.GA28253@dyad.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 1 May 2013 11:07:19 +0200")
Message-ID: <m261z3uipb.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> So you're saying that if two SMT siblings count the same MEM_*_RETIRED event
> (on the same counter?) events can get accounted to the wrong sibling?

It can happen regardless of what event is enabled on the other counter.

> And when the other sibling doesn't have (the same counter?) enabled we
> can loose events?

doesn't have any events enabled.

> This begs the question what happens when the sibling does have the (same?)
> counter enabled but counting an all together different event; do we then still
> 'loose' events from the one sibling and add then to the other counter?

Yes, that is what the patch fixes.

Of course only if you actually apply it, and not lose it as usual.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
