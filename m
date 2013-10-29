Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3J2WZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:25:44 -0400
Received: from mail.eperm.de ([89.247.134.16]:47960 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3J2WZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:25:43 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 29 Oct 2013 23:25:28 +0100
Message-ID: <11529328.Jgjayj3SHB@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <7861469.OAmn4h8An0@tauon>
References: <2579337.FPgJGgHYdz@tauon> <20131029132448.GB691@thunk.org> <7861469.OAmn4h8An0@tauon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Oktober 2013, 15:00:31 schrieb Stephan Mueller:

Hi Ted,

>Am Dienstag, 29. Oktober 2013, 09:24:48 schrieb Theodore Ts'o:
>
>Hi Theodore,
>
>>On Tue, Oct 29, 2013 at 09:42:30AM +0100, Stephan Mueller wrote:
>>> Based on this suggestion, I now added the tests in Appendix F.46.8
>>> where I disable the caches and the tests in Appendix F.46.9 where I
>>> disable the caches and interrupts.
>>
>>What you've added in F.46 is a good start, but as a suggestiom,
>>instead of disabling one thing at a time, try disabling *everything*
>>and then see what you get, and then enabling one thing at a time.  The
>>best thing is if you can get to the point where the amount of entropy
>>is close to zero.  Then as you add things back, there's a much better
>
>I will try to do that.
>
>But please see the different lower boundary values in the different
>subsections of F.46: none of them fall when I disable or change
>anything in the base system (except the power management -- where I
>added additional analyses). Some of the changes imply that the jitter
>increases when I disable certain support.
>
>Thus, expect that we will not see a significant drop in the jitter as
>you fear or expect.
>
>Yet, I will try and report back.

Please have a look at the updated documentation, appendix F.46.10 
provided in [1].

The interesting result is that some combinations of disabling CPU 
support do reduce the CPU execution jitter. However, disabling all 
support is not the lowest jitter measurement.

Though, none of the tried combinations deteriorate the measurement so 
much that the execution jitter would be insufficient for use in the RNG.

[...]
>>sense of where the unpredictability might be coming from, and whether
>>the unpredictability is coming from something which is fundamentally
>>arising from something which is chaotic or quantum effect, or just
>>because we don't have a good way of modelling the behavior of the
>>L1/L2 cache (for example) and that is spoofing your entropy estimator.
>
>Please note: if the jitter really comes from the oscillator effect of
>the RAM clock vs. the CPU clock (which I suspect), we will not be able
>to alter the jitter software wise.

My current conclusion is that software can have some impact on the 
execution jitter (as it is visible when executing different OSes on the 
same hardware system as outlined in appendix F.45.

But none of the software impacts can deteriorate the jitter to the level 
that it is not usable any more for the RNG and still keep the claim that 
each output bit would have one bit of entropy.

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

Ciao
Stephan
