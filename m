Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbaFYPEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:04:00 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61293 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaFYPD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:03:59 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AAE4D2.5020104@roeck-us.net>
Date: Wed, 25 Jun 2014 08:03:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linuxppc-dev@lists.ozlabs.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] sched: Fix compiler warnings
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net> <20140625071416.GM14781@pengutronix.de> <53AADC63.8080106@roeck-us.net> <20140625144955.GP14781@pengutronix.de>
In-Reply-To: <20140625144955.GP14781@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 07:49 AM, Uwe Kleine-König wrote:
> Hello Guenter,
>
> On Wed, Jun 25, 2014 at 07:27:47AM -0700, Guenter Roeck wrote:
>>> Maybe the author's intention was:
>>>
>>> 	static inline int cpu_corepower_flags(void) __attribute__((const));
>>>
>>> ?
>>> This specifies that the function has no side effects and the return value
>>> only depends on the (here non-existing) function arguments.
>>>
>>
>> Possibly, but either I am missing something or this doesn't compile.
> You need to do a separate declaration:
>
> 	static inline int cpu_corepower_flags(void) __attribute__((const));
> 	static inline int cpu_corepower_flags(void)
> 	{
> 		...

Actually turns out one can use __attribute_const__, and it is

	static inline int __attribute_const__ cpu_corepower_flags(void)

which turns out to be widely used.

I'll change that and resubmit after testing.

Guenter

