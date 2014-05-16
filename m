Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaEPJDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:03:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42843 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbaEPJDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:03:03 -0400
Message-ID: <5375D44F.7000505@linaro.org>
Date: Fri, 16 May 2014 11:03:11 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 6/7] ARM: EXYNOS: PM: fix register setup on EXYNOS4x12
 for AFTR mode code
References: <1399287439-31376-1-git-send-email-b.zolnierkie@samsung.com> <1399287439-31376-7-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1399287439-31376-7-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 12:57 PM, Bartlomiej Zolnierkiewicz wrote:
> Add S5P_CENTRAL_SEQ_OPTION register setup for EXYNOS4x12 to AFTR
> mode code.  Without this setup AFTR mode doesn't show any benefit
> over WFI one.  When this setup is applied AFTR mode reduces power
> consumption by ~12% (as measured on Trats2 board).
>
> This change is a preparation for adding secure firmware support to
> EXYNOS cpuidle driver.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>   arch/arm/mach-exynos/pm.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
> index 18f6bf8..3922968 100644
> --- a/arch/arm/mach-exynos/pm.c
> +++ b/arch/arm/mach-exynos/pm.c
> @@ -391,6 +391,10 @@ static int exynos_cpu_pm_notifier(struct notifier_block *self,
>   	case CPU_PM_ENTER:
>   		if (cpu == 0) {
>   			exynos_pm_central_suspend();
> +			if (soc_is_exynos4212() || soc_is_exynos4412())
> +				__raw_writel(S5P_USE_STANDBY_WFI0 |
> +					     S5P_USE_STANDBY_WFE0,
> +					     S5P_CENTRAL_SEQ_OPTION);

Why not put this code in the exynos_enter_aftr() ?

>   			exynos_cpu_save_register();
>   		}
>   		break;



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

