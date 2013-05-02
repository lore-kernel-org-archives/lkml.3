Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab3EBVaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:30:52 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33863 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3EBVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:30:51 -0400
MIME-Version: 1.0
In-Reply-To: <1367529031-4915-1-git-send-email-laurent.navet@gmail.com>
References: <1367529031-4915-1-git-send-email-laurent.navet@gmail.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 2 May 2013 14:30:30 -0700
Message-ID: <CAHfPSqAn1tki7-NSKmJfqgEcvj1gQg0q99Q1Sed7cTvDuYNkWg@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: exynos_adc: use devm_ioremap_resource()
To: Laurent Navet <laurent.navet@gmail.com>
Cc: jic23@cam.ac.uk, My self <ch.naveen@samsung.com>, lars@metafoo.de,
        sachin.kamat@linaro.org, dianders@chromium.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2013 14:10, Laurent Navet <laurent.navet@gmail.com> wrote:
> Replace calls to deprecated devm_request_and_ioremap by devm_ioremap_resource.
>
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_request_and_ioremap.cocci.
>
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
Hello Laurent,


But, we already have patch from Sachin
http://patches.linaro.org/15833/
lined up for merge.

Thanks for the post.
Naveen
> ---
>  drivers/iio/adc/exynos_adc.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index 9f3a8ef..22d034a 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -270,16 +270,16 @@ static int exynos_adc_probe(struct platform_device *pdev)
>         info = iio_priv(indio_dev);
>
>         mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       info->regs = devm_request_and_ioremap(&pdev->dev, mem);
> -       if (!info->regs) {
> -               ret = -ENOMEM;
> +       info->regs = devm_ioremap_resource(&pdev->dev, mem);
> +       if (IS_ERR(info->regs)) {
> +               ret = PTR_ERR(info->regs);
>                 goto err_iio;
>         }
>
>         mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -       info->enable_reg = devm_request_and_ioremap(&pdev->dev, mem);
> -       if (!info->enable_reg) {
> -               ret = -ENOMEM;
> +       info->enable_reg = devm_ioremap_resource(&pdev->dev, mem);
> +       if (IS_ERR(info->enable_reg)) {
> +               ret = PTR_ERR(info->enable_reg);
>                 goto err_iio;
>         }
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Shine bright,
(: Nav :)
