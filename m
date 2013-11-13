Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab3KMLvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:51:54 -0500
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:53395 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab3KMLvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:51:52 -0500
Message-ID: <528367D0.6010900@ladisch.de>
Date: Wed, 13 Nov 2013 12:51:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
References: <2579337.FPgJGgHYdz@tauon> <8100659.WdgUuKxd0z@myon.chronox.de> <527FEC56.5070306@ladisch.de> <1391779.T98KINxAMQ@myon.chronox.de>
In-Reply-To: <1391779.T98KINxAMQ@myon.chronox.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> Am Sonntag, 10. November 2013, 21:28:06 schrieb Clemens Ladisch:
>> Many CPUs allow to disable branch prediction, but this is very vendor
>> specific (try to find MSR documentation).  The biggest offender probably
>> is the out-of-order execution engine, which cannot be disabled.
>
> For x86, I have not found a way to disable the unit.

My AMD processor can do this in the IC_CFG/DC_CFG MSRs.  (See the BKDG.)

The Intel Core family has other settings (such as data prefetching) that
are configurable in the IA32_MISC_ENABLE MSR.

(And any setting that increases accesses to main memory is likey to
introduce more entropy due to clock drift between the processor and the
memory bus.  Or where do you assume the entropy comes from?)

BTW: MFENCE is not guaranteed to flush the instruction pipeline; you
need CPUID for that.

> XOR is a bijective operation.

Only XOR with a constant, which is not what you're doing.

>>> There are so many assessments on entropy I make, I am surprised that I
>>> am said to have no entropy assessment.
>>
>> Again: Shannon entropy assumes that you have a sequence of independent
>> and identically distributed random variables.  And you cannot prove
>> these properties from the output; you need to know the process that
>> generates the values.
>
> I am absolutely on your side here. And as we cannot (yet?) fully conclude that
> the observations are independent, a safety margin must always be considered.

If the observations are not independent, you cannot just assume that the
estimate is off by a certain factor.  It means that the estimate is not
applicable _at all_.

> The RNG has the following safety margins where it is more conservative than
> measurements indicate:

You _cannot_ measure entropy by looking at the output.  How would you
differentiate between /dev/random and /dev/urandom?


Regards,
Clemens
