Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832Ab3EALvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:51:37 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45103 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3EALva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:51:30 -0400
Date: Wed, 1 May 2013 13:51:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
Message-ID: <20130501115125.GA19497@gmail.com>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <20130425162535.GA5828@dyad.programming.kicks-ass.net>
 <20130425164100.GC16732@two.firstfloor.org>
 <20130425164837.GD5828@dyad.programming.kicks-ass.net>
 <20130425170037.GD16732@two.firstfloor.org>
 <20130425171842.GA8669@dyad.programming.kicks-ass.net>
 <20130425174211.GE16732@two.firstfloor.org>
 <20130426075601.GB8669@dyad.programming.kicks-ass.net>
 <20130426194633.GF16732@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426194633.GF16732@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > 
> > OK, so how about we use something like:
> > 
> > 	 is_kernel_text() || is_module_text_address()
> 
> is_module_text_address() has to walk all modules.
> A random system with a distro kernel I checked has 101 modules loaded.

I checked another random distro and it had 30 modules loaded.

> 16 * 101 = too much
>
> I don't think you want to spend that many cycles in the NMI
> handler for a dubious feature.  Ok in theory you could
> add something with binary search, but that would be quite
> a bit of effort and it would be probably challenging 
> to do that all NMI safe.

If anyone using LBR sees that overhead it can be improved. You or others 
who care can improve it.

(Or if the hardware gets fully fixed, it can be removed for that 
hardware.)

> Also it wouldn't work for all these new kernel JITs people are doing of 
> course.

They'll miss the filtering, until they offer the proper 
is_kernel_jit_text() primitive that is.

> Still think my patch is the best so far? (plus the missing root check)

Your patch simply disables the filtering for kernel addresses, it's the 
worst of all options so far.

Anyway, what Peter asked for is a trivial change that solves the bug - are 
you willing to respond to his review feedback and submit an updated 
series?

Thanks,

	Ingo
