Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbaGRTmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:42:42 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61955 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255AbaGRTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:42:40 -0400
Message-ID: <53C978AA.9090603@samsung.com>
Date: Sat, 19 Jul 2014 04:42:34 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2] ARM: EXYNOS: Fix build with PM_SLEEP=n
References: <1405323953-25954-1-git-send-email-k.kozlowski@samsung.com> <53C66924.3010303@samsung.com>
In-Reply-To: <53C66924.3010303@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/14 20:59, Tomasz Figa wrote:
> Hi Krzysztof,
>
> On 14.07.2014 09:45, Krzysztof Kozlowski wrote:
>> Fix building of exynos defconfig with disabled PM_SLEEP:
>> CONFIG_PM_SLEEP=n
>> CONFIG_PM_SLEEP_SMP=n
>> CONFIG_SUSPEND=n
>> by moving functions for power up/down of CPU and cluster to platsmp.c
>>
>> The build error messages:
>> arch/arm/mach-exynos/built-in.o: In function `exynos_boot_secondary':
>> arch/arm/mach-exynos/platsmp.c:111: undefined reference to `exynos_cpu_power_state'
>> arch/arm/mach-exynos/platsmp.c:112: undefined reference to `exynos_cpu_power_up'
>> arch/arm/mach-exynos/platsmp.c:116: undefined reference to `exynos_cpu_power_state'
>> make: *** [vmlinux] Error 1
>>
>> Signed-off-by: Krzysztof Kozlowski<k.kozlowski@samsung.com>
>>
>> ---
>> Changes since v1:
>> 1. Use different solution - just move the power up/down functions to a
>>     common place instead of adding stubs in common.h. Suggested by Tomasz
>>     Figa.
>> ---
>>   arch/arm/mach-exynos/platsmp.c | 66 ++++++++++++++++++++++++++++++++++++++++++
>>   arch/arm/mach-exynos/pm.c      | 66 ------------------------------------------
>>   2 files changed, 66 insertions(+), 66 deletions(-)
>>
>
+ Bart,

> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>
Applied, thanks.

Bart, I think this is better at this moment to fix the build breakage 
with disabling PM...if you have any comments, please let me know.

Thanks,
Kukjin
