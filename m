Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaESFuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:50:54 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:44192 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaESFuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:50:52 -0400
MIME-Version: 1.0
In-Reply-To: <1399288539-1793-7-git-send-email-b.zolnierkie@samsung.com>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
	<1399288539-1793-7-git-send-email-b.zolnierkie@samsung.com>
Date: Mon, 19 May 2014 11:20:51 +0530
Message-ID: <CADGdYn5z8QYDrpA771fSqBZVX4=3q6ig4RU+XHP44qaUpPO_Jg@mail.gmail.com>
Subject: Re: [PATCH 06/10] thermal: exynos: remove redundant threshold_code
 checks from exynos_tmu_initialize()
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/14, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> Remove runtime checks for negative return values of temp_to_code()
> from exynos_tmu_initialize().  The current level temperature data
> hardcoded in pdata will never cause a negative temp_to_code()
> return values and for the new code potential mistakes should be
> caught during development/review phases.
Your arguments looks fine.
>
> Theres should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

> ---
>  drivers/thermal/samsung/exynos_tmu.c | 16 +---------------
>  1 file changed, 1 insertion(+), 15 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c
> b/drivers/thermal/samsung/exynos_tmu.c
> index 789d745..a415829 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -170,10 +170,6 @@ static int exynos_tmu_initialize(struct platform_device
> *pdev)
>  	if (data->soc == SOC_ARCH_EXYNOS4210) {
>  		/* Write temperature code for threshold */
>  		threshold_code = temp_to_code(data, pdata->threshold);
> -		if (threshold_code < 0) {
> -			ret = threshold_code;
> -			goto out;
> -		}
>  		writeb(threshold_code,
>  			data->base + reg->threshold_temp);
>  		for (i = 0; i < trigger_levs; i++)
> @@ -187,18 +183,12 @@ static int exynos_tmu_initialize(struct
> platform_device *pdev)
>  		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
>  			threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i]);
> -			if (threshold_code < 0) {
> -				ret = threshold_code;
> -				goto out;
> -			}
>  			rising_threshold |= threshold_code << 8 * i;
>  			if (pdata->threshold_falling) {
>  				threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i] -
>  						pdata->threshold_falling);
> -				if (threshold_code > 0)
> -					falling_threshold |=
> -						threshold_code << 8 * i;
> +				falling_threshold |= threshold_code << 8 * i;
>  			}
>  		}
>
> @@ -217,10 +207,6 @@ static int exynos_tmu_initialize(struct platform_device
> *pdev)
>  				(pdata->trigger_type[i] == HW_TRIP)) {
>  			threshold_code = temp_to_code(data,
>  						pdata->trigger_levels[i]);
> -			if (threshold_code < 0) {
> -				ret = threshold_code;
> -				goto out;
> -			}
>  			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
>  				/* 1-4 level to be assigned in th0 reg */
>  				rising_threshold |= threshold_code << 8 * i;
> --
> 1.8.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
