Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbaEMKWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:22:39 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:33157 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbaEMKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:22:37 -0400
Message-ID: <5371F25E.6020805@imgtec.com>
Date: Tue, 13 May 2014 11:22:22 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
References: <1399971456-3941-1-git-send-email-lftan@altera.com>	<1399971749-4004-1-git-send-email-lftan@altera.com>	<CAAG0J9-ieBNfyRa6kf22TNd_3mg57GYuGHagQ-pPLY41iM3Zyg@mail.gmail.com>	<CAFiDJ5-ez-Brqr8q3=XbODzLtFFU=e4qS12bCPo=5FE1JTNr+A@mail.gmail.com>	<5371EAEB.5030100@imgtec.com> <CAFiDJ58w31gm_z3Y1Q6ZREQPW4F6uVB+vy3X1r_3kLgaEE3O1w@mail.gmail.com>
In-Reply-To: <CAFiDJ58w31gm_z3Y1Q6ZREQPW4F6uVB+vy3X1r_3kLgaEE3O1w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/05/14 11:17, Ley Foon Tan wrote:
> On Tue, May 13, 2014 at 5:50 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> Hi,
>>
>> On 13/05/14 10:32, Ley Foon Tan wrote:
>>> On Tue, May 13, 2014 at 5:15 PM, James Hogan <james.hogan@imgtec.com> wrote:
>>>> On 13 May 2014 10:02, Ley Foon Tan <lftan@altera.com> wrote:
>>>>>  /*
>>>>> + * Use 64 bit time_t and clock_t as default. 32 bit users can provide an override to
>>>>> + * define these as "long" if needed.
>>>>> + */
>>>>> +#ifndef __kernel_time_t
>>>>> +typedef long long      __kernel_time_t;
>>>>> +#endif
>>>>> +
>>>>> +#ifndef __kernel_clock_t
>>>>> +typedef long long      __kernel_clock_t;
>>>>> +#endif
>>>>
>>>> I think having this as the first patch in the series will break
>>>> bisection for existing 32-bit arches. This needs to be done in such a
>>>> way that at no intermediate commit are __kernel_time_t or
>>>> __kernel_clock_t the wrong size for existing arches, e.g. by having a
>>>> first patch which makes the typedefs conditional but leaves them as
>>>> __kernel_long_t, and a final patch that changes the default after all
>>>> the arches have got their overrides in place.
>>>
>>> Your suggestion is something as below?
>>
>> Yeh, although I like Thomas' idea better, then each existing 32-bit arch
>> can just select the Kconfig symbol to get the smaller type.
>>
>> IIRC Kconfig won't even complain if you select a symbol which doesn't
>> exist yet.
> When we export this posix_types.h file for user software, they need to
> define this config, eg: CONFIG_32BIT_TIME to use 32 bit time. Is this
> what we want to do?

Yeh, good point, that won't work.

Cheers
James
