Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaHETxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:53:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58249 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaHETxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:53:06 -0400
Message-ID: <53E1361C.2070905@gmail.com>
Date: Tue, 05 Aug 2014 21:53:00 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v5 1/3] ARM: EXYNOS: Move code from hotplug.c to platsmp.c
References: <1407235425-13937-1-git-send-email-k.kozlowski@samsung.com> <53E0EE32.7060500@linaro.org> <1407251006.9849.8.camel@AMDC1943>
In-Reply-To: <1407251006.9849.8.camel@AMDC1943>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.2014 17:03, Krzysztof Kozlowski wrote:
> On wto, 2014-08-05 at 16:46 +0200, Daniel Lezcano wrote:
>> On 08/05/2014 12:43 PM, Krzysztof Kozlowski wrote:
>>> Cleanup a little the SMP/hotplug code for Exynos by:
>>> 1. Moving completely all functions from hotplug.c into the platsmp.c;
>>> 2. Deleting the hotplug.c file.
>>>
>>> After recent cleanups (e.g. 75ad2ab28f0f "ARM: EXYNOS: use
>>> v7_exit_coherency_flush macro for cache disabling") there was only CPU
>>> power down related code in hotplug.c file. Keeping this file does not
>>> give any benefits.
>>>
>>> The commit only moves code around with one additional observable change:
>>> the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
>>> CFLAGS are not necessary any more.
>>
>> What is the benefit of moving this code around ?
>>
>> Usually the cpu hotplug code is located in hotplug.c for most of the 
>> platforms, so why moving pm code inside platsmp ?
> 
> The benefits are:
> 
> 1. Less dependencies, cleaner code because platsmp.c is the only user of
> code located in hotplug.c. So the exynos_cpu_die() had to be declared in
> common.h.
> 
> 2. Less dependencies between modules after adding patch 3/3 [1] which
> introduces exynos_set_delayed_reset_assertion() function. The
> exynos_set_delayed_reset_assertion() is called by:
>  - cpu_leave_power (hotplug.c)
>  - platform_do_lowpower (hotplug.c)
>  - exynos_boot_secondary (platsmp.c)
> 
> so merging everything into one file seemed simpler and cleaner.

mach-exynos/hotplug.c does not have too much code right now and as
Krzysztof noticed the only user of functions from it is platsmp.c
anyway. We don't need to follow other machs in something that makes no
sense, so

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
