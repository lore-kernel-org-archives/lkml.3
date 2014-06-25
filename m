Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbaFYQJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:09:22 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53057 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbaFYQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:09:21 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AAF424.6010302@roeck-us.net>
Date: Wed, 25 Jun 2014 09:09:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        David Laight <David.Laight@ACULAB.COM>
CC: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] sched: Fix compiler warnings
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net> <20140625071416.GM14781@pengutronix.de> <53AADC63.8080106@roeck-us.net> <20140625144955.GP14781@pengutronix.de> <53AAE4D2.5020104@roeck-us.net> <063D6719AE5E284EB5DD2968C1650D6D17265D81@AcuExch.aculab.com> <20140625155259.GQ14781@pengutronix.de>
In-Reply-To: <20140625155259.GQ14781@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 08:52 AM, Uwe Kleine-König wrote:
> Hello,
>
> On Wed, Jun 25, 2014 at 03:40:28PM +0000, David Laight wrote:
>> From: Guenter Roeck
>>> Actually turns out one can use __attribute_const__, and it is
>>>
>>> 	static inline int __attribute_const__ cpu_corepower_flags(void)
>>>
>>> which turns out to be widely used.
>>>
>>> I'll change that and resubmit after testing.
>>
>> You don't need to tell the compiler that for an inline function.
> I didn't check for the functions in question here, but in general your
> statement is wrong.
>
> For example:
>
> static inline unsigned int __attribute_const__ read_cpuid_id(void)
> {
> 	return readl(BASEADDR_V7M_SCB + V7M_SCB_CPUID);
> }
>
> from arch/arm/include/asm/cputype.h. The V7M_SCB_CPUID register never
> changes, but there is no way gcc can deduce that.
>

Sigh. As I mentioned earlier, it is much easier to introduce a problem
than to fix it.

Ok, I'll leave this alone. I already spent much more time on this than
I should or have, so it is really time to move on.

Guenter

