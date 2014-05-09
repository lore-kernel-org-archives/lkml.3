Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbaEIUnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:43:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbaEIUnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:43:21 -0400
Date: Fri, 9 May 2014 22:43:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 06/20] arch,avr32: Fold atomic_ops
Message-ID: <20140509204309.GA13467@laptop.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.049922584@infradead.org>
 <20140509183241.GA4491@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140509183241.GA4491@samfundet.no>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:32:41PM +0200, Hans-Christian Egtvedt wrote:
> Around Thu 08 May 2014 15:58:46 +0200 or thereabout, Peter Zijlstra wrote:
> > Many of the atomic op implementations are the same except for one
> > instruction; fold the lot into a few CPP macros and reduce LoC.
> 
> The add and sub atomic operations are not 100% the same. Sub has more
> constraints on the integer size than add. Sub only takes a signed 21-bit
> integer, while add can do 32-bit additions IIRC correctly the instructions
> for AVR32.
> 
> This is why you see in atomic_sub_return() that i is typed as "rKs21", while
> in atomic_add_return, i is typed "r".
> 
> Your change limits both atomic operations to work only on signed 21-bit
> integers.

Urgh, fail on me for not seeing that.


> > -	if (__builtin_constant_p(i) && (i >= -1048575) && (i <= 1048576))
> > -		result = atomic_sub_return(-i, v);
> 
> I do not recall why we did it like this any more, I would assume both sub and
> add to be single cycle instructions.

Right and if its a constant the negate is compile time too.

OK, so if I only generate add and provide inline stubs to implement sub
with add this should be good again, right?

Any other instructions I should be careful with? I take it the bit ops
are full 32 bits again?
