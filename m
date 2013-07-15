Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3GOVHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:07:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab3GOVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:07:50 -0400
Date: Mon, 15 Jul 2013 23:06:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130715210650.GF23818@dyad.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
 <51E166C8.3000902@linux.intel.com>
 <20130715195914.GC23818@dyad.programming.kicks-ass.net>
 <51E45E8B.705@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E45E8B.705@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 01:41:47PM -0700, Arjan van de Ven wrote:
> On 7/15/2013 12:59 PM, Peter Zijlstra wrote:
> >On Sat, Jul 13, 2013 at 07:40:08AM -0700, Arjan van de Ven wrote:
> >>On 7/12/2013 11:49 PM, Peter Zijlstra wrote:
> >>>
> >>>Arjan; from reading your emails you're mostly busy explaining what cannot be
> >>>done. Please explain what _can_ be done and what Intel wants. From what I can
> >>>see you basically promote a max P state max concurrency race to idle FTW.
> >>
> >>>
> >>>Since you can't say what the max P state is; and I think I understand the
> >>>reasons for that, and the hardware might not even respect the P state you tell
> >>>it to run at, does it even make sense to talk about Intel P states? When would
> >>>you not program the max P state?
> >>
> >>this is where it gets complicated ;-( the race-to-idle depends on the type of
> >>code that is running, if things are memory bound it's outright not true, but
> >>for compute bound it often is.
> >
> >So you didn't actually answer the question about when you'd program a less than
> >max P state.
> (oops missed this part in my previous reply)
> 
> so race to halt is all great, but it has a core limitation, it is fundamentally
> assuming that if you go at a higher clock frequency, the code actually finishes sooner.
> This is generally true for the normal "compute" kind of instructions, but
> if you have an instruction that goes to memory (and misses caches), that is not the
> case because memory itself does not go faster or slower with the CPU frequency.
> 
> so depending of the mix of compute and memory instructions, different tradeoffs
> might be needed.
> 
> (for an example of this, AMD exposes a CPU counter for this as of recently and added
> patches to "ondemand" to use it)

OK, but isn't that part of why the micro controller might not make you go
faster even if you do program a higher P state?

But yes, I understand this issue in the 'traditional' cpufreq sense. There's no
point in ramping the speed if all you do is stall more.

But I was under the impression the 'hardware' was doing this. If not then we
need the whole go-faster and go-slower thing and places to call them and means
to determine to call them etc.
