Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbaGQXdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:33:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59359 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGQXdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:33:46 -0400
Message-ID: <53C85D50.5040901@zytor.com>
Date: Thu, 17 Jul 2014 16:33:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] random: limit the contribution of the hw rng to at most
 half
References: <1405591436-15445-1-git-send-email-tytso@mit.edu> <53C80A6D.5010201@zytor.com> <20140717220806.GW1491@thunk.org>
In-Reply-To: <20140717220806.GW1491@thunk.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 03:08 PM, Theodore Ts'o wrote:
> 
> There was another complaint more recently, that wasn't related to
> nordrand.  And I was rather disturbed that in
> add_interrupt_randomness() 97% of the entropy was coming from RDSEED.
> I'm willing to have some of the entropy come from RDSEED by default,
> but 97% seems to really way too much.
> 

OK, the that formula was Linus' suggestion.

> And the emergency refill code in random_read() was extremely
> problematic.  First of all, we're dropping 512 bytes on the stack,
> which is kind of bad, but hopefully all of the code paths which call
> random_read() won't have a terribly deep stack.

512 bytes is fine here (1K would possibly not have been.)

> Secondly, even after the emergency refill, we block anyway.

Not unless we don't get any data back.  For a nonzero return we loop
back to extract_entropy_user().

> Remember, regardless of whether or not you believe (as a former head
> of NSA's technology directorate recently claimed) that the DUAL-EC p
> and q were generated using NSA's standard high-quality HW RNG system
> which they use to generate all of their crypto variables, or (as the
> NIST advisory panel has recently concluded) that it was highly likely
> that DUAL-EC was backdoored, it's the optics that matter, because
> those of us without top-drawer SI security clearances can't prove
> things one way or another.

Dual-EC was also heavily criticized by the civilian cryptographic
community since at least 2006.

> And when 99.95% of the entropy when reading large quantities of keying
> material from /dev/random is coming from RDSEED, that just has
> terrible, terrible optics....

I just want to make sure we don't negatively impact the real security of
users because of "optics".  We already have a lot of problems with
people extracting long-living keys from /dev/urandom because /dev/random
is too slow.

I have no objection to the khwrngd route -- in fact, as you know, I have
been heavily encouraging the development of khwrngd with exactly this in
mind -- but it is just an issue of timing.

	-hpa


