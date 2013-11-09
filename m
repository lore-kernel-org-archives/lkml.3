Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab3KIWF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 17:05:27 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:55779 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab3KIWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 17:05:26 -0500
Message-ID: <527EB181.2000602@ladisch.de>
Date: Sat, 09 Nov 2013 23:04:49 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
References: <2579337.FPgJGgHYdz@tauon> <9172761.DO0L6FkY0c@tauon> <20131106130432.GK14235@thunk.org> <3842150.yBzxVUWavK@tauon>
In-Reply-To: <3842150.yBzxVUWavK@tauon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> Am Mittwoch, 6. November 2013, 08:04:32 schrieb Theodore Ts'o:
>> On Wed, Nov 06, 2013 at 01:51:17PM +0100, Stephan Mueller wrote:
>>>> That's unfortunate, since it leaves open the question of whether this
>>>> jitter is something that could be at least somewhat predictable if you
>>>> had a lot more information about the internal works of the CPU or not....
>>>
>>> I do not understand that answer: I thought we are talking about the
>>> search of non-predictable noise sources. If you cannot predict the
>>> sequence even if you have the state of the CPU, that is what we are
>>> looking for, is it not?
>>
>> I was asking the question about whether someone who knew more about
>> the internal _workings_ of the CPU, note of the state of the CPU.
>> This is not necessarily "the NSA guy", but someone who knows more
>> about the internal workings of the Intel CPU (such as an Intel
>> engineer --- and I've had Intel express misgivings about approaches
>> which depend on "CPU jitter" approaches), or just someone who has
>> spent a lot more time trying to examine the black box of the Intel CPU
>> from the outside.
>
> I try to get more information from my contacts to other vendors. But I
> am wondering what shall we do if the answer is (maybe even proven with
> some test results) that they see the same issue themselves and have no
> handle on it?
>
> I mean, what is it that I would need to test and demonstrate to prove or
> disprove my RNG?

You need to prove that the CPU will never get into an internal state
where the loop execution times happen to form a predictable pattern.
Alternatively, detect this so that the measurements can be thrown away.

> We can certainly test very much, but one thing we cannot prove, and
> that is the fundamental jitter, provided it is a result of quantum
> fluctuations. Just as with any other noise source, basic fundamental
> principles are hard if not impossible to test.

You cannot test if the noise source was replaced with fake hardware.
But if you know the characteristics of the noise source, you can test
for likely failure modes, such as the output value being stuck or
oscillating.

In the case of CPU jitter measurements, you do not have direct access to
the noise source; you measure it indirectly through the CPU's internal
state.  So you need to know how the delta times of a noisy CPU are
different from the delta times of a CPU without or with unsuitable
noise source.


Regards,
Clemens
