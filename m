Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbbANQCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:02:09 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:34538 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbANQCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:02:05 -0500
Message-ID: <54B692FB.7030703@linaro.org>
Date: Wed, 14 Jan 2015 17:02:03 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kukjin Kim <kgene@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>
CC: tglx@linutronix.de, inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com> <54B69072.4080607@kernel.org>
In-Reply-To: <54B69072.4080607@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 04:51 PM, Kukjin Kim wrote:
> On 01/14/15 14:33, Chanwoo Choi wrote:
>
> Hi,
>
> + Doug, Olof
>
>> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
>> for Exynos 32bit SoC.
>>
> Yes, the Exynos MCT(Multi-Core Timer) is 64bit timer and it is available
> on 64bit exynos SoC such as exynos7. But basically ARMv8 architecture is
> including ARM ARCH timer (ARM Generic Timer) and exynos7 also has
> implemented it and additionally its access is faster than using memory
> mapped register called SFR for MCT...so Doug submitted patch to use MCT
> on 32bit exynos SoCs before.
>
> I know using MCT on 64bit exynos is usefulness for Power Management and
> I need to talk to relevant guys in office again. If anything, I'll let
> you know.

I will wait for your answer before digging more the patch.

Thanks
   -- Daniel

>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>> This patch set is tested on 64-bit Exynos SoC. I send only this patch from
>> following patchst[1].
>> [1] https://lkml.org/lkml/2014/12/2/134
>>
>> Changes from v2:
>> - None
>> Changes from v1:
>> - Use CONFIG_ARM instead of CONFIG_ARM64
>>
>>   drivers/clocksource/Kconfig      | 1 -
>>   drivers/clocksource/exynos_mct.c | 4 ++++
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>> index fc01ec2..be38119 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -135,7 +135,6 @@ config CLKSRC_METAG_GENERIC
>>
>>   config CLKSRC_EXYNOS_MCT
>>   	def_bool y if ARCH_EXYNOS
>> -	depends on !ARM64
>>   	help
>>   	  Support for Multi Core Timer controller on Exynos SoCs.
>>
>> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
>> index 9403061..b840ea1 100644
>> --- a/drivers/clocksource/exynos_mct.c
>> +++ b/drivers/clocksource/exynos_mct.c
>> @@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
>>   	return exynos4_read_count_32();
>>   }
>>
>> +#if defined(CONFIG_ARM)
>>   static struct delay_timer exynos4_delay_timer;
>>
>>   static cycles_t exynos4_read_current_timer(void)
>> @@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
>>   			 "cycles_t needs to move to 32-bit for ARM64 usage");
>>   	return exynos4_read_count_32();
>>   }
>> +#endif
>>
>>   static void __init exynos4_clocksource_init(void)
>>   {
>>   	exynos4_mct_frc_start();
>>
>> +#if defined(CONFIG_ARM)
>>   	exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
>>   	exynos4_delay_timer.freq = clk_rate;
>>   	register_current_timer_delay(&exynos4_delay_timer);
>> +#endif
>>
>>   	if (clocksource_register_hz(&mct_frc, clk_rate))
>>   		panic("%s: can't register clocksource\n", mct_frc.name);


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

