Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaI0IjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:39:23 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36157 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaI0IjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:39:19 -0400
Message-ID: <542677B2.70506@samsung.com>
Date: Sat, 27 Sep 2014 10:39:14 +0200
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v5 RESEND 1/3] ARM: EXYNOS: Move code from hotplug.c to
 platsmp.c
References: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com> <201409262313.26272.arnd@arndb.de>
In-Reply-To: <201409262313.26272.arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26.09.2014 o 23:13, Arnd Bergmann pisze:
> On Friday 05 September 2014, Krzysztof Kozlowski wrote:
>> The commit only moves code around with one additional observable change:
>> the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
>> CFLAGS are not necessary any more.
>
> This turns out to be wrong, and your change broke 'allmodconfig' builds
> in linux-next. Please apply this patch on top.

My patch definitely needed more testing.
I posted a fix here:
https://lkml.org/lkml/2014/9/24/163
However it seems that it wasn't picked up by anyone yet.

Russell, could you pick up the patch (with acks from Nicolas and Kukjin)?

Best regards,
Krzysztof


>
> 	Arnd
>
> 8<----------
>  From 4ba6bf8806caec386e35930314dbad071284c837 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Fri, 26 Sep 2014 23:09:38 +0200
> Subject: [PATCH] ARM: EXYNOS: fix build error in platsmp.c
>
> /tmp/ccYeWL3V.s: Assembler messages:
> /tmp/ccYeWL3V.s:659: Error: selected processor does not support ARM mode `isb '
> /tmp/ccYeWL3V.s:664: Error: selected processor does not support ARM mode `isb '
> /tmp/ccYeWL3V.s:665: Error: selected processor does not support ARM mode `dsb '
> make[3]: *** [arch/arm/mach-exynos/platsmp.o] Error 1
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 17342534e1d932 ("ARM: EXYNOS: Move code from hotplug.c to platsmp.c")
>
> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
> index 4e49d4efb264..64324bf5edb4 100644
> --- a/arch/arm/mach-exynos/Makefile
> +++ b/arch/arm/mach-exynos/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_PM_SLEEP)		+= suspend.o
>   obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
>
>   obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
> +CFLAGS_platsmp.o		:= -march=armv7-a
>
>   plus_sec := $(call as-instr,.arch_extension sec,+sec)
>   AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

