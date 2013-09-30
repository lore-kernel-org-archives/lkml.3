Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3I3MCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 08:02:54 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54401 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3I3MCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 08:02:51 -0400
MIME-Version: 1.0
In-Reply-To: <1380010102-25817-5-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
	<1380010102-25817-5-git-send-email-l.majewski@samsung.com>
Date: Mon, 30 Sep 2013 17:32:50 +0530
X-Google-Sender-Auth: QzxAUX33War4vjXYPXzjpzTJs5E
Message-ID: <CADGdYn7DMAWxrEYfkkAMSJZGRhGr6gBrypx_bmGPW9LKrLxvVw@mail.gmail.com>
Subject: Re: [PATCH 4/6] thermal: exynos: Replace SOC_ARCH_EXYNOS with SOC_ARCH_EXYNOS5250
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 1:38 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The TMU data definition is now separated to Exynos4412 and Exynos5250.
>
> Now SOC_ARCH_EXYNOS only refers to Exynos5250. Hence the name
> SOC_ARCH_EXYNOS has been changed to SOC_ARCH_EXYNOS5250.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Changes looks fine.
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>

Thanks,
Amit
> ---
>  drivers/thermal/samsung/exynos_tmu.c      |    4 ++--
>  drivers/thermal/samsung/exynos_tmu.h      |    2 +-
>  drivers/thermal/samsung/exynos_tmu_data.c |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index 21b89e4..037cd46 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -632,9 +632,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>         if (ret)
>                 return ret;
>
> -       if (pdata->type == SOC_ARCH_EXYNOS ||
> -           pdata->type == SOC_ARCH_EXYNOS4210 ||
> +       if (pdata->type == SOC_ARCH_EXYNOS4210 ||
>             pdata->type == SOC_ARCH_EXYNOS4412 ||
> +           pdata->type == SOC_ARCH_EXYNOS5250 ||
>             pdata->type == SOC_ARCH_EXYNOS5440)
>                 data->soc = pdata->type;
>         else {
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> index db37df0..b42ece4 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -42,7 +42,7 @@ enum calibration_mode {
>  enum soc_type {
>         SOC_ARCH_EXYNOS4210 = 1,
>         SOC_ARCH_EXYNOS4412,
> -       SOC_ARCH_EXYNOS,
> +       SOC_ARCH_EXYNOS5250,
>         SOC_ARCH_EXYNOS5440,
>  };
>
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> index bd08093..188223f 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -183,7 +183,7 @@ struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
>  struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
>         .tmu_data = {
>                 { EXYNOS4412_TMU_DATA,
> -               .type = SOC_ARCH_EXYNOS,
> +               .type = SOC_ARCH_EXYNOS5250,
>                 },
>         },
>         .tmu_count = 1,
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
