Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3J3M73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:59:29 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:55609 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3J3M7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:59:25 -0400
MIME-Version: 1.0
In-Reply-To: <20131028214549.GA31746@thunk.org>
References: <2579337.FPgJGgHYdz@tauon>
	<2049321.gMV6JUDze7@tauon>
	<20131028214549.GA31746@thunk.org>
Date: Wed, 30 Oct 2013 08:59:24 -0400
Message-ID: <CACXcFmnEiNFjQ1dUeAJQYHuudEYv7Mo-TJBoYZNMdeHaPBzG+g@mail.gmail.com>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
From: Sandy Harris <sandyinchina@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        sandy harris <sandyinchina@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> wrote:

> Fundamentally, what worries me about this scheme (actually, causes the
> hair on the back of my neck to rise up on end) is this statement in
> your documentation[1]:
>
>    When looking at the sequence of time deltas gathered
>    during testing [D] , no pattern can be detected. Therefore, the
>    fluctuation and the resulting distribution are not based on a
>    repeating pattern and must be considered random.
>
> [1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html
>
> Just because we can't detect a pattern does **not** mean that it is
> not based on a repeating pattern, and therefore must be considered
> random.  We can't detect a pattern in RDRAND, so does that mean it's
> automatically random?  Why, no.
> ...
> It may be that there is some very complex state which is hidden inside
> the the CPU execution pipeline, the L1 cache, etc., etc.  But just
> because *you* can't figure it out, and just because *I* can't figure
> it out doesn't mean that it is ipso facto something which a really
> bright NSA analyst working in Fort Meade can't figure out.  (Or heck,
> a really clever Intel engineer who has full visibility into the
> internal design of an Intel CPU....)
>
> Now, it may be that in practice, an adversary won't be able to carry
> out a practical attack ...

It seems worth noting here that Ted's reasons for skepticism
apply not just to Stephan's Jitter generator, but to others such
as Havege (already in Debian) which are based on differences
in speed of arithmetic operations, presumably due to cache
& TLB misses, pipeline stalls, etc. Also to ones based on
variations in delays from timer calls such as my maxwell(8).

It is also worth mentioning that, while Stephan has done
thorough testing on a range of CPUs, others have test
& rationale info as well. The Havege papers have a lot,
my maxwell paper has a little, and there's:
McGuire, Okech & Schiesser,
Analysis of inherent randomness of the Linux kernel,
http://lwn.net/images/conf/rtlws11/random-hardware.pdf

I know my stuff is not an adequate answer to Ted, but
I suspect some of the others may be.
