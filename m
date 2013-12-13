Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3LMNfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:35:22 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39116 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3LMNfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:35:21 -0500
Date: Fri, 13 Dec 2013 14:35:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Alex Shi <alex.shi@linaro.org>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/3] Fix ebizzy performance regression on IvyBridge
 due to X86 TLB range flush
Message-ID: <20131213133517.GA11176@gmail.com>
References: <1386849309-22584-1-git-send-email-mgorman@suse.de>
 <20131212130107.GC5806@gmail.com>
 <20131212144029.GI11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212144029.GI11295@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> > [...]
> >
> > stddev appears to be rather large especially around a client count 
> > of 7-8. It will be difficult to fine-tune the TLB range flush 
> > constants if noise is too large.
> 
> The number of iterations were very low to have high confidence of 
> the figures. The high standard deviation for 5 clients was a single 
> large outlier. It potentially could be stabilised to some extent by 
> bumping up the number of iterations a lot and using percentiles 
> instead of means.

Fair enough - and you were bisecting so length of runtime and 
confidence of detection were obviously the primary concerns.

> I'm a bit wary of optimising the TLB flush ranges based on the 
> benchmark even if we stabilised the figures. [...]

Absolutely - but they do appear to be pretty 'adversarial' to the TLB 
optimization, with a measurable slowdown in a pretty complex, 
real-life workload pattern.

So future tuning efforts will have to take such workloads into effect 
as well, to make sure we don't regress again.

Thanks,

	Ingo
