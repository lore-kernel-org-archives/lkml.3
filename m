Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab3EAJJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 05:09:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34645
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331Ab3EAJI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 05:08:57 -0400
Date: Wed, 1 May 2013 11:07:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, eranian@google.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Add workaround for MEM_*_RETIRED errata BV98
Message-ID: <20130501090718.GA28253@dyad.programming.kicks-ass.net>
References: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367261108-9567-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:45:08AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> On IvyBridge MEM_*_RETIRED can leak through to the same counter
> on the other thread. Add a dummy extra_reg to handle this case.
> The extra reg is allocated and makes sure nothing different
> runs on the same counter in the other thread.
> 
> This is normally only visible when multiplexing.
> 
> This patch doesn't 100% plug the hole, as the event may still get lost
> when the other CPU thread does not have an enabled counter
> (e.g. with per thread counting). However it fixes it well enough
> for the common global profiling case (e.g. perf top / perf stat -a)
> In theory it would be possible to handle the other cases
> too, but it would need far more changes.

So you're saying that if two SMT siblings count the same MEM_*_RETIRED event
(on the same counter?) events can get accounted to the wrong sibling?

And when the other sibling doesn't have (the same counter?) enabled we can
loose events?

This begs the question what happens when the sibling does have the (same?)
counter enabled but counting an all together different event; do we then still
'loose' events from the one sibling and add then to the other counter?


