Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3KMDhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:37:34 -0500
Received: from mail.eperm.de ([89.247.134.16]:59447 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab3KMDh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:37:27 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>,
        Clemens Ladisch <clemens@ladisch.de>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] CPU Jitter RNG: Executing time variation tests on bare metal
Date: Wed, 13 Nov 2013 04:37:18 +0100
Message-ID: <2783048.WEALGJott2@myon.chronox.de>
User-Agent: KMail/4.11.2 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131029132448.GB691@thunk.org>
References: <2579337.FPgJGgHYdz@tauon> <3160817.9DcncHidey@tauon> <20131029132448.GB691@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Oktober 2013, 09:24:48 schrieb Theodore Ts'o:

Hi Theodore,

> On Tue, Oct 29, 2013 at 09:42:30AM +0100, Stephan Mueller wrote:
> > Based on this suggestion, I now added the tests in Appendix F.46.8 where
> > I disable the caches and the tests in Appendix F.46.9 where I disable
> > the caches and interrupts.
> 
> What you've added in F.46 is a good start, but as a suggestiom,
> instead of disabling one thing at a time, try disabling *everything*
> and then see what you get, and then enabling one thing at a time.  The
> best thing is if you can get to the point where the amount of entropy
> is close to zero.  Then as you add things back, there's a much better
> sense of where the unpredictability might be coming from, and whether
> the unpredictability is coming from something which is fundamentally
> arising from something which is chaotic or quantum effect, or just
> because we don't have a good way of modelling the behavior of the
> L1/L2 cache (for example) and that is spoofing your entropy estimator.

I was now able to implement two more test buckets that were in my mind for 
quite some time. They are documented in the new sections 6.3 and 6.4 in [1].

The tests for the time variation measurements are now executed on bare metal, 
i.e. without *any* operating system underneath. For achieving that, I used the 
memtest86+ tool, ripped out the memory tests and added the time variation 
testing into it.

The time variation tests now execute single threaded without any interference 
from an underlying operating system. Again, I added all the variations of 
disabling CPU support (TLB flushes, L1/2 flushes, cache disabling, ...).

And, surprise: all the jitter is still there.

Furthermore, I use the same vehicle to just measure the variations by 
obtaining two timestamps immediately after each other and calculate the 
difference. As before, there are various tests which disable the different CPU 
mechanisms.

And, surprise: there is still variations visible. Granted, these variations 
are smaller than the ones for the folding loop. But the smallest variations 
still have way more than 1 bit when applying the Shannon Entropy formula.

The code is uploaded to [2] and can be used to play with.

In addition, I added test resutls with varying loads as explained in section 
6.2 (thanks to Nicholas Mc Guire for helping here).

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

[2] http://www.chronox.de/

Ciao
Stephan
-- 
| Cui bono? |
