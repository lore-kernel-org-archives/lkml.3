Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab3J2OAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:00:50 -0400
Received: from mail.eperm.de ([89.247.134.16]:58485 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab3J2OAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:00:49 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 29 Oct 2013 15:00:31 +0100
Message-ID: <7861469.OAmn4h8An0@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
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

>On Tue, Oct 29, 2013 at 09:42:30AM +0100, Stephan Mueller wrote:
>> Based on this suggestion, I now added the tests in Appendix F.46.8
>> where I disable the caches and the tests in Appendix F.46.9 where I
>> disable the caches and interrupts.
>
>What you've added in F.46 is a good start, but as a suggestiom,
>instead of disabling one thing at a time, try disabling *everything*
>and then see what you get, and then enabling one thing at a time.  The
>best thing is if you can get to the point where the amount of entropy
>is close to zero.  Then as you add things back, there's a much better

I will try to do that.

But please see the different lower boundary values in the different 
subsections of F.46: none of them fall when I disable or change anything 
in the base system (except the power management -- where I added 
additional analyses). Some of the changes imply that the jitter 
increases when I disable certain support.

Thus, expect that we will not see a significant drop in the jitter as 
you fear or expect.

Yet, I will try and report back.

Though, does anybody has an idea how to flush/disable branch prediction 
on x86 (short of using an ARM where I can disable the branch prediction 
unit with CP15)? That is the last unit that I do not have a handle on.


>sense of where the unpredictability might be coming from, and whether
>the unpredictability is coming from something which is fundamentally
>arising from something which is chaotic or quantum effect, or just
>because we don't have a good way of modelling the behavior of the
>L1/L2 cache (for example) and that is spoofing your entropy estimator.

Please note: if the jitter really comes from the oscillator effect of 
the RAM clock vs. the CPU clock (which I suspect), we will not be able 
to alter the jitter software wise.

The reason why I suspect that oscillating effect is the following: I 
spoke with two different employees from the research departments of 
major chip vendors. They mentioned that they see the very same jitter in 
their measurements albeit they tried to get rid of it. So, when they 
cannot get rid of that, I guess we will not be able to lower or even 
eliminate the jitter significantly.

Ciao
Stephan
