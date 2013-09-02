Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3IBCwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:52:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1665 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3IBCwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:52:08 -0400
X-Spam-Score: -100.9
Message-ID: <5223FD16.8060308@asianux.com>
Date: Mon, 02 Sep 2013 10:51:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  h8300/kernel/setup.c: add "linux/initrd.h" to pass
 compiling
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <52202045.1050506@roeck-us.net> <52203283.4020701@asianux.com> <52207E0D.5000402@roeck-us.net>
In-Reply-To: <52207E0D.5000402@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 07:12 PM, Guenter Roeck wrote:
> On 08/29/2013 10:49 PM, Chen Gang wrote:
>> On 08/30/2013 12:32 PM, Guenter Roeck wrote:
>>> On 08/29/2013 08:59 PM, Chen Gang wrote:
>>>> The related error (allmodconfig for h8300):
>>>>
>>>>     arch/h8300/kernel/setup.c: In function 'setup_arch':
>>>>     arch/h8300/kernel/setup.c:103:3: error: 'initrd_start' undeclared
>>>> (first use in this function)
>>>>        initrd_start = memory_start;
>>>>        ^
>>>>     arch/h8300/kernel/setup.c:103:3: note: each undeclared identifier
>>>> is reported only once for each function it appears in
>>>>     arch/h8300/kernel/setup.c:104:3: error: 'initrd_end' undeclared
>>>> (first use in this function)
>>>>        initrd_end = memory_start += be32_to_cpu(((unsigned long *)
>>>> (memory_start))[2]);
>>>>        ^
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>    arch/h8300/kernel/setup.c |    4 ++++
>>>>    1 files changed, 4 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
>>>> index d0b1607..85639a1 100644
>>>> --- a/arch/h8300/kernel/setup.c
>>>> +++ b/arch/h8300/kernel/setup.c
>>>> @@ -47,6 +47,10 @@
>>>>    #include <asm/regs267x.h>
>>>>    #endif
>>>>
>>>> +#if defined(CONFIG_BLK_DEV_INITRD)
>>>> +#include <linux/initrd.h>
>>>> +#endif
>>>> +
>>>
>>> Is the #ifdef/#endif really needed ? If not you should drop it.
>>>
>>
>> "linux/initrd.h" is needed by 'initrd_start' and 'initrd_end' when
>> BLK_DEV_INITRD enabled.
>>
>> 'memory_start' is defined within this file, and also only one place may
>> use "linux/initrd.h" within this file.
>>
>> So if BLK_DEV_INITRD disabled, do not need "linux/initrd.h" either.
>>
> 
> I didn't ask if the include is needed, I asked if the ifdef is needed.
> 

Adding "ifdef" can mach original/local code style (no matter whether the
code style is good or not),


> The goal is to reduce the number of ifdefs in the code. We should not
> include new ones if not necessary. That there are already other
> (possibly unnecessary) ifdefs in the code doesn't mean we should add new
> ones.
> 

Yeah, if necessary, we need send additional patch to try to reduce all
of "ifdef" within this ".c" file.

In my opinion, we'd better to avoid 2 or more coding styles in one ".c"
file.


> Guenter
> 

Thanks.
-- 
Chen Gang
