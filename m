Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3JJPEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:04:20 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46209 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3JJPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:04:19 -0400
Date: Thu, 10 Oct 2013 17:04:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH, -v2] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131010150416.GB5167@gmail.com>
References: <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <20131010084535.GA10620@gmail.com>
 <20131010085506.GA11775@gmail.com>
 <20131010115617.GY28601@twins.programming.kicks-ass.net>
 <20131010123236.GH30970@tucnak.zalov.cz>
 <20131010131034.GN3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010131034.GN3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > So for >= 4.8.3 just assume no workaround is needed, otherwise scan 
> > assembly.
> 
> Right, tedious and error prone it is.. :-)
> 
> Would it make sense to create something whereby GCC can tell us about 
> these things? Maybe something like:
> 
>   __builtin_bug_fixed(58670)
> 
> Which would default return 0, and only return 1 when its a known number.
>
> But yes, I also see why you'd not want to do that. I suppose all I'm 
> saying is it would be nice to be able to detect some arbitrary issue 
> being fixed.

Basically not a monolithic 1-dimensional feature value but a more 
finegrained multi-dimensional feature vector would be nice.

It could be used not just for bugs but for all regular features as well, 
as they are added.

Something like:

	__builtin_feature(asm_goto)

would return 1 for a basic asm goto implementation and 0 for unknown 
feature strings. Any individual bug, if applications are affected by it, 
would then would be discoverable:

	__builtin_feature(asm_goto_bug_58670_fixed)

(or a fully symbolic name would suffice as well.) On old GCC this would 
return 1, on anything 4.8.2 and higher it would return 1.

Thanks,

	Ingo
