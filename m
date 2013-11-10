Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3KJBQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 20:16:57 -0500
Received: from mail.eperm.de ([89.247.134.16]:58974 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554Ab3KJBQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 20:16:56 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Nicholas Mc Guire <der.herr@hofr.at>, "Theodore Ts'o" <tytso@mit.edu>,
        Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Sun, 10 Nov 2013 02:16:13 +0100
Message-ID: <5040268.j2ZYME4FFf@myon.chronox.de>
User-Agent: KMail/4.11.2 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <527EB157.70109@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <4606253.6dPOReUPaz@tauon> <527EB157.70109@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 9. November 2013, 23:04:07 schrieb Clemens Ladisch:

Hi Clemens,

> Stephan Mueller wrote:
> > Am Donnerstag, 7. November 2013, 02:03:57 schrieb Nicholas Mc Guire:
> >> On Wed, 06 Nov 2013, Stephan Mueller wrote:
> >>> Besides, how on earth shall an attacker even gain knowledge about the
> >>> state of the CPU or disable CPU mechanisms? Oh, I forgot, your NSA
> >>> guy. But if he is able to do that, all discussions are moot because
> >>> he simply disables any noise sources by flipping a bit, reads the
> >>> memory that is used to hold the state of the RNG or just overwrites
> >>> the memory locations where data is collected, because the general
> >>> protection mechanisms offered by the kernel and the underlying
> >>> hardware are broken.
> >> 
> >> No need to gain knowledge of the internal CPU state itt would be
> >> sufficient to be able to put the CPU in a sub-state-space in which
> >> the distribution is shifted. it may be enough to reduce the truely
> >> random bits of some key only by a few bits to make it suceptible to
> >> brute force attacks.
> > 
> > Note, the proposed RNG contains an unbias operation (the Von-Neumann
> > unbiaser) which is proven to remove any bias when it is established that
> > the individual observations are independent. And the way the
> > observations are generated ensures that they are independent.
> 
> "Independent" does not mean that your own code avoids reusing data from
> the previous loop iteration; it means that the _entire_ process that
> generates the bits is not affected by any memory of the past.

In the other email, I explained the different types of tests I performed. All 
of these tests show proper statistical results.

Now, I also performed these tests without the Von-Neumann unbiaser. All of the 
statistical tests results still showed a white noise (note, in the next code 
release, I will have an allocation flag added that you can use to very simply 
deactivate the Von-Neumann unbiaser for testing).

So, the Von-Neumann unbiaser is to be considered a line of defence against 
(not yet observed, but potential) skews. Similarly, the optional whitening 
(non-cryptographic) function of jent_stir_pool is yet another line of defence.

So, bottom line: I fully concur that using two separate measurements may not 
imply that they are independent. But testing shows that it does not matter.
> 
> The observations are derived from the internal CPU state, which is *not*
> reset between measurements.
> 
> 
> Regards,
> Clemens


Ciao
Stephan
-- 
| Cui bono? |
