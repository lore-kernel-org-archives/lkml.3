Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbaI1Emb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 00:42:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34013 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaI1Ema (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 00:42:30 -0400
Message-ID: <542791AD.5080105@samsung.com>
Date: Sun, 28 Sep 2014 13:42:21 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v5 RESEND 1/3] ARM: EXYNOS: Move code from hotplug.c to
 platsmp.c
References: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com> <201409262313.26272.arnd@arndb.de> <542677B2.70506@samsung.com>
In-Reply-To: <542677B2.70506@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/14 17:39, Krzysztof Kozlowski wrote:
> W dniu 26.09.2014 o 23:13, Arnd Bergmann pisze:
>> On Friday 05 September 2014, Krzysztof Kozlowski wrote:
>>> The commit only moves code around with one additional observable change:
>>> the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
>>> CFLAGS are not necessary any more.
>>
>> This turns out to be wrong, and your change broke 'allmodconfig' builds
>> in linux-next. Please apply this patch on top.
>
Arnd, Krzysztof commented its fix has been submitted and landed in my 
-test tree not -next because it should be handled in rmk's tree I think.

I sent the patch to RMK patch tracking system just now and it should be 
fine in there.

BTW, I just applied the fix in my -next until its ladning in RMK tree 
but as you know it will be not be sent to arm-soc via samsung tree...

One more, Arnd please pull my pull-request 2nd round and 3rd round for 
samsung stuff for 3.18.

> My patch definitely needed more testing.
> I posted a fix here:
> https://lkml.org/lkml/2014/9/24/163
> However it seems that it wasn't picked up by anyone yet.
>
> Russell, could you pick up the patch (with acks from Nicolas and Kukjin)?
>
I believe Russell will take the patch in his tree.

Thanks,
Kukjin

>> 8<----------
>> From 4ba6bf8806caec386e35930314dbad071284c837 Mon Sep 17 00:00:00 2001
>> From: Arnd Bergmann <arnd@arndb.de>
>> Date: Fri, 26 Sep 2014 23:09:38 +0200
>> Subject: [PATCH] ARM: EXYNOS: fix build error in platsmp.c
>>
>> /tmp/ccYeWL3V.s: Assembler messages:
>> /tmp/ccYeWL3V.s:659: Error: selected processor does not support ARM
>> mode `isb '
>> /tmp/ccYeWL3V.s:664: Error: selected processor does not support ARM
>> mode `isb '
>> /tmp/ccYeWL3V.s:665: Error: selected processor does not support ARM
>> mode `dsb '
>> make[3]: *** [arch/arm/mach-exynos/platsmp.o] Error 1
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Fixes: 17342534e1d932 ("ARM: EXYNOS: Move code from hotplug.c to
>> platsmp.c")
>>
>> diff --git a/arch/arm/mach-exynos/Makefile
>> b/arch/arm/mach-exynos/Makefile
>> index 4e49d4efb264..64324bf5edb4 100644
>> --- a/arch/arm/mach-exynos/Makefile
>> +++ b/arch/arm/mach-exynos/Makefile
>> @@ -21,6 +21,7 @@ obj-$(CONFIG_PM_SLEEP) += suspend.o
>> obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
>>
>> obj-$(CONFIG_SMP) += platsmp.o headsmp.o
>> +CFLAGS_platsmp.o := -march=armv7-a
>>
>> plus_sec := $(call as-instr,.arch_extension sec,+sec)
>> AFLAGS_exynos-smc.o :=-Wa,-march=armv7-a$(plus_sec)
