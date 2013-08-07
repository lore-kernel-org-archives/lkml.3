Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3HGJYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:24:04 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36899 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab3HGJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <1370955220-2949-18-git-send-email-amit.daniel@samsung.com>
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com> <1370955220-2949-18-git-send-email-amit.daniel@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 7 Aug 2013 14:53:40 +0530
Message-ID: <CAHfPSqAqUbm8=Y3jj8T7M3+yjkQO2WfB9mnP4YN=eSzYPt+fgA@mail.gmail.com>
Subject: Re: [PATCH V5 17/30] thermal: exynos: Remove non DT based support
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2013 18:23, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> Recently non DT support from Exynos platform is removed and hence
> removing non DT support from the driver also. This will help in easy
> maintainence.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Hello Amit,

When you remove the non-DT support why have the #ifdef CONFIG_OF in the driver
instead make the dependency in Kconfig itself.
> ---
>  drivers/thermal/samsung/exynos_tmu.c |   17 +----------------
>  1 files changed, 1 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index acbd295..4356118 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -403,19 +403,6 @@ static const struct of_device_id exynos_tmu_match[] = {
>  MODULE_DEVICE_TABLE(of, exynos_tmu_match);
>  #endif
>
> -static struct platform_device_id exynos_tmu_driver_ids[] = {
> -       {
> -               .name           = "exynos4210-tmu",
> -               .driver_data    = (kernel_ulong_t)EXYNOS4210_TMU_DRV_DATA,
> -       },
> -       {
> -               .name           = "exynos5250-tmu",
> -               .driver_data    = (kernel_ulong_t)EXYNOS5250_TMU_DRV_DATA,
> -       },
> -       { },
> -};
> -MODULE_DEVICE_TABLE(platform, exynos_tmu_driver_ids);
> -
>  static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>                         struct platform_device *pdev)
>  {
> @@ -428,8 +415,7 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
>                 return (struct exynos_tmu_platform_data *) match->data;
>         }
>  #endif
> -       return (struct exynos_tmu_platform_data *)
> -                       platform_get_device_id(pdev)->driver_data;
> +       return NULL;
>  }
>
>  static int exynos_tmu_probe(struct platform_device *pdev)
> @@ -586,7 +572,6 @@ static struct platform_driver exynos_tmu_driver = {
>         },
>         .probe = exynos_tmu_probe,
>         .remove = exynos_tmu_remove,
> -       .id_table = exynos_tmu_driver_ids,
>  };
>
>  module_platform_driver(exynos_tmu_driver);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
