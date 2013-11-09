Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab3KIWEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 17:04:51 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:59461 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab3KIWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 17:04:49 -0500
Message-ID: <527EB157.70109@ladisch.de>
Date: Sat, 09 Nov 2013 23:04:07 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: Nicholas Mc Guire <der.herr@hofr.at>, "Theodore Ts'o" <tytso@mit.edu>,
        Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
References: <2579337.FPgJGgHYdz@tauon> <9172761.DO0L6FkY0c@tauon> <20131107010357.GC1950@opentech.at> <4606253.6dPOReUPaz@tauon>
In-Reply-To: <4606253.6dPOReUPaz@tauon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> Am Donnerstag, 7. November 2013, 02:03:57 schrieb Nicholas Mc Guire:
>> On Wed, 06 Nov 2013, Stephan Mueller wrote:
>>> Besides, how on earth shall an attacker even gain knowledge about the
>>> state of the CPU or disable CPU mechanisms? Oh, I forgot, your NSA
>>> guy. But if he is able to do that, all discussions are moot because
>>> he simply disables any noise sources by flipping a bit, reads the
>>> memory that is used to hold the state of the RNG or just overwrites
>>> the memory locations where data is collected, because the general
>>> protection mechanisms offered by the kernel and the underlying
>>> hardware are broken.
>>
>> No need to gain knowledge of the internal CPU state itt would be
>> sufficient to be able to put the CPU in a sub-state-space in which
>> the distribution is shifted. it may be enough to reduce the truely
>> random bits of some key only by a few bits to make it suceptible to
>> brute force attacks.
>
> Note, the proposed RNG contains an unbias operation (the Von-Neumann
> unbiaser) which is proven to remove any bias when it is established that
> the individual observations are independent. And the way the
> observations are generated ensures that they are independent.

"Independent" does not mean that your own code avoids reusing data from
the previous loop iteration; it means that the _entire_ process that
generates the bits is not affected by any memory of the past.

The observations are derived from the internal CPU state, which is *not*
reset between measurements.


Regards,
Clemens
