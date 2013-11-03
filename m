Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3KCHUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 02:20:48 -0500
Received: from mail.eperm.de ([89.247.134.16]:43376 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab3KCHUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 02:20:43 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Sun, 03 Nov 2013 08:20:34 +0100
Message-ID: <3537770.iLHXPOXMiU@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131102110112.GA16231@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon> <7861469.OAmn4h8An0@tauon> <20131102110112.GA16231@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 2. November 2013, 12:01:13 schrieb Pavel Machek:

Hi Pavel,

>Hi!
>
>> >sense of where the unpredictability might be coming from, and
>> >whether
>> >the unpredictability is coming from something which is fundamentally
>> >arising from something which is chaotic or quantum effect, or just
>> >because we don't have a good way of modelling the behavior of the
>> >L1/L2 cache (for example) and that is spoofing your entropy
>> >estimator.
>> 
>> Please note: if the jitter really comes from the oscillator effect of
>> the RAM clock vs. the CPU clock (which I suspect), we will not be
>> able
>> to alter the jitter software wise.
>
>Well... if it is really oscillator effect, there should be _no_
>entropy when running with L1/L2 enabled (because DRAM will not be
>accessed at all at that case).

That is a good one!

Another friend of mine mentioned that he assumes the rise and fall times 
of transistors varies very slightly and could be the main reason for the 
jitter. I do not think that this is really the case, because our gates 
that form the CPU instructions comprise of many transistors. The 
combined raise/fall jitter should cancel each other out.

That said, the full root cause is is not really known at this time 
considering that major chip vendors have no real clue either.

>
>There should be way to extract entropy more directly from various
>oscillator effects, no?

I am working a different way of measuring such oscillator effects by 
using the high-resolution timer of the CPU and measure it with a 
Jiffies-based snapshotting window. So, here I would combine two timers 
that are differently generated. If their frequencies would be relative 
prime to each other, we would measure a direct oscillator effect.

This already was tried in the cryptlib RNG, but I try a slightly 
different approach.

Yet, nothing is complete at this point.
>
>For DRAM, just perform timing, have entropy. Plus we could for example
>measure PIT vs. other timer sources... (but I suspect that on PCs we
>already have enough entropy...)

I suspect so too, but my measurements as of now are not conclusive.
>									
Pavel


Ciao
Stephan
