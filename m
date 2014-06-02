Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaFBQEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:04:50 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56202 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaFBQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:04:49 -0400
Message-ID: <538CA0B0.2030200@linaro.org>
Date: Mon, 02 Jun 2014 18:05:04 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 6/7] ARM: EXYNOS: PM: fix register setup on EXYNOS4x12
 for AFTR mode code
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com> <1399287439-31376-7-git-send-email-b.zolnierkie@samsung.com> <5375D44F.7000505@linaro.org> <2762097.QhkViWyNLQ@amdc1032>
In-Reply-To: <2762097.QhkViWyNLQ@amdc1032>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 02:08 PM, Bartlomiej Zolnierkiewicz wrote:
>
> Hi,
>
> On Friday, May 16, 2014 11:03:11 AM Daniel Lezcano wrote:
>> On 05/05/2014 12:57 PM, Bartlomiej Zolnierkiewicz wrote:
>>> Add S5P_CENTRAL_SEQ_OPTION register setup for EXYNOS4x12 to AFTR
>>> mode code.  Without this setup AFTR mode doesn't show any benefit
>>> over WFI one.  When this setup is applied AFTR mode reduces power
>>> consumption by ~12% (as measured on Trats2 board).
>>>
>>> This change is a preparation for adding secure firmware support to
>>> EXYNOS cpuidle driver.
>>>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>> ---
>>>    arch/arm/mach-exynos/pm.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
>>> index 18f6bf8..3922968 100644
>>> --- a/arch/arm/mach-exynos/pm.c
>>> +++ b/arch/arm/mach-exynos/pm.c
>>> @@ -391,6 +391,10 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
>>>    	case CPU_PM_ENTER:
>>>    		if (cpu == 0) {
>>>    			exynos_pm_central_suspend();
>>> +			if (soc_is_exynos4212() || soc_is_exynos4412())
>>> +				__raw_writel(S5P_USE_STANDBY_WFI0 |
>>> +					     S5P_USE_STANDBY_WFE0,
>>> +					     S5P_CENTRAL_SEQ_OPTION);
>>
>> Why not put this code in the exynos_enter_aftr() ?
>
> I would prefer to keep this code close to exynos_pm_central_suspend()
> because exynos_pm_suspend() (which calls exynos_pm_central_suspend()
> too) also contains S5P_USE_STANDBY_WF[I,E]0 setting code (done for all
> SoCs).  If possible I would like to make this code common for AFTR &
> suspend in the future (once it is tested on Exynos4210 and Exynos5250)
> by moving S5P_USE_STANDBY_WF[I,E]0 setting to exynos_pm_central_suspend()
> and doing it for all SoCs.  Are you okay with this?

Yeah, no problem.


>>>    			exynos_cpu_save_register();
>>>    		}
>>>    		break;
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

