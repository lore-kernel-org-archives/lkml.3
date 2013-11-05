Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3KEMVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:21:12 -0500
Received: from mail.eperm.de ([89.247.134.16]:34735 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab3KEMVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:21:11 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 05 Nov 2013 13:20:57 +0100
Message-ID: <1762585.cs6mj77ady@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131103124135.GB32091@thunk.org>
References: <2579337.FPgJGgHYdz@tauon> <3537770.iLHXPOXMiU@tauon> <20131103124135.GB32091@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 3. November 2013, 07:41:35 schrieb Theodore Ts'o:

Hi Theodore,

>On Sun, Nov 03, 2013 at 08:20:34AM +0100, Stephan Mueller wrote: 
>
>Sandy Harris pointed out a very good paper that I would definitely
>recommend that people read:
>
>http://lwn.net/images/conf/rtlws11/random-hardware.pdf
>
>It basically describes some efforts made in 2009 by folks to do
>exactly the sort of experiments I was advocating.  What I actually

I am wondering whether you have seen my last measurements where I 
effectively performed the tests you were asking for: disabling all 
possible CPU features and selectively enabling them.

The tests described in the above mentioned documents and much more are 
all already in the test suite and test results I present here.

>think is more important, though, is not the doing of the experiments,
>but the development the tools to do these experiments.  If people can
>create kernel modules (and they have to be done in the kernel, since
>you need to be able to disable interrupts, L1 caches, etc., while you
>run these tests), then it will be possible to do these experiments
>each time a new CPU comes out from Intel, or each time an ARM hardware
>vendor comes out with a new ARM SOC.

The test code is available and it is executed in kernel space.
>
>It's important that these tests are done all time, and not, "OK, we

Again, the code is there for the taking, including the analysis part. 
Yes, it can be easily converted into a fully automated test such that at 
the end a result of "CPU shows sufficient variations for the RNG" or 
not.

Therefore, I am asking again:

- Which other CPU mechanisms can I disable that I did not so far?

- The execution time measurements when disabling CPU features show that 
there is still significant variations available. Given the fact that an 
adversary is not able to disable the features as I did, he will not be 
able to reduce the variations induced by the features. He may alter them 
potentially, but there are still variations which he cannot affect, let 
alone predict. Therefore, how shall an adversary make predictions of the 
variations to weaken the RNG?

I heard a nice statement from the developer who implemented the 
/dev/random device of a different, respected operating system: the last 
step to accept the underlying root cause of uncertainty for an RNG 
always requires a leap of faith. Looking at typical noise sources that 
sounds about right. For example:

- how can we be sure that nobody who measures the key stroke interrupts 
can do that with a precision that is higher than the estimated entropy 
the key stroke is awarded (note, an adversary has the means to observe 
key strokes)? Same applies to mouse movements. Note that X11 allows you 
to measure these events precisely (the xev application should give a 
glimpse).

- how can we be sure that fast_pool exhibits no correlation with the 
other noise sources?

- how can we be sure that the HDD fluctuations are random?

We simply accept that these issues do not allow predicting sequences to 
the extent that weakens the RNG.

My goal is to give another seed source to add even more uncertainty into 
the Linux RNG in addition to the existing seed sources. This would also 
support environments that were typically left in the rain so far, such 
as virtual machines, early boot sequences, Live CDs, or headless systems 
without a spinning disk.

Ciao
Stephan
