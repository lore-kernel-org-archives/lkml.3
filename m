Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3H3LMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:12:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60807 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3H3LMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:12:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52207E0D.5000402@roeck-us.net>
Date: Fri, 30 Aug 2013 04:12:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  h8300/kernel/setup.c: add "linux/initrd.h" to pass
 compiling
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <52202045.1050506@roeck-us.net> <52203283.4020701@asianux.com>
In-Reply-To: <52203283.4020701@asianux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 10:49 PM, Chen Gang wrote:
> On 08/30/2013 12:32 PM, Guenter Roeck wrote:
>> On 08/29/2013 08:59 PM, Chen Gang wrote:
>>> The related error (allmodconfig for h8300):
>>>
>>>     arch/h8300/kernel/setup.c: In function 'setup_arch':
>>>     arch/h8300/kernel/setup.c:103:3: error: 'initrd_start' undeclared
>>> (first use in this function)
>>>        initrd_start = memory_start;
>>>        ^
>>>     arch/h8300/kernel/setup.c:103:3: note: each undeclared identifier
>>> is reported only once for each function it appears in
>>>     arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared
>>> (first use in this function)
>>>        initrd_end = memory_start += be32_to_cpu(((unsigned long *)
>>> (memory_start))[2]);
>>>        ^
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>>    arch/h8300/kernel/setup.c |    4 ++++
>>>    1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
>>> index d0b1607..85639a1 100644
>>> --- a/arch/h8300/kernel/setup.c
>>> +++ b/arch/h8300/kernel/setup.c
>>> @@ -47,6 +47,10 @@
>>>    #include <asm/regs267x.h>
>>>    #endif
>>>
>>> +#if defined(CONFIG_BLK_DEV_INITRD)
>>> +#include <linux/initrd.h>
>>> +#endif
>>> +
>>
>> Is the #ifdef/#endif really needed ? If not you should drop it.
>>
>
> "linux/initrd.h" is needed by 'initrd_start' and 'initrd_end' when
> BLK_DEV_INITRD enabled.
>
> 'memory_start' is defined within this file, and also only one place may
> use "linux/initrd.h" within this file.
>
> So if BLK_DEV_INITRD disabled, do not need "linux/initrd.h" either.
>

I didn't ask if the include is needed, I asked if the ifdef is needed.

The goal is to reduce the number of ifdefs in the code. We should not
include new ones if not necessary. That there are already other
(possibly unnecessary) ifdefs in the code doesn't mean we should add new ones.

Guenter

