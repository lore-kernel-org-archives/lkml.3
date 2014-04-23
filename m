Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaDWGUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:20:06 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55203 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaDWGUC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <5356477C.1070403@linaro.org>
References: <1398080958-21677-1-git-send-email-chander.kashyap@linaro.org>
	<1398080958-21677-2-git-send-email-chander.kashyap@linaro.org>
	<5356477C.1070403@linaro.org>
Date: Wed, 23 Apr 2014 11:50:01 +0530
Message-ID: <CANuQgHHx+EyPXK0joYU-Af4dj+=ikW0SWE6g2-N0=K-dK3nMRw@mail.gmail.com>
Subject: Re: [PATCH 1/4] cpuidle: config: Add SOC_EXYNOS5420 entry to select
 cpuidle-big-little driver
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 22 April 2014 16:12, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 04/21/2014 01:49 PM, Chander Kashyap wrote:
>>
>> Exynos5420 is a big-little SoC from Samsung. It has 4 A15 and 4 A7 cores.
>> In order to use generic cpuidle-big-little driver, this patch adds
>> Exynos5420
>> specific check to initialize generic cpuidle driver.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> ---
>>   drivers/cpuidle/Kconfig.arm |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
>> index 97ccc31..5244d87 100644
>> --- a/drivers/cpuidle/Kconfig.arm
>> +++ b/drivers/cpuidle/Kconfig.arm
>> @@ -4,7 +4,7 @@
>>
>>   config ARM_BIG_LITTLE_CPUIDLE
>>         bool "Support for ARM big.LITTLE processors"
>> -       depends on ARCH_VEXPRESS_TC2_PM
>> +       depends on ARCH_VEXPRESS_TC2_PM || SOC_EXYNOS5420
>
>
> For the sake of consistency, I would prefer:
>
> depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS

Yes i will change it.

Thanks
>
> and let the current code (and future platform driver) to handle the loading
> of the driver.
>
>
>>         select ARM_CPU_SUSPEND
>>         select CPU_IDLE_MULTIPLE_DRIVERS
>>         help
>>
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>



-- 
with warm regards,
Chander Kashyap
