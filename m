Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab3B0T0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:26:42 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37284 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3B0T0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:26:41 -0500
MIME-Version: 1.0
In-Reply-To: <1361926029-12518-1-git-send-email-wenyou.yang@atmel.com>
References: <1361925297-11854-1-git-send-email-wenyou.yang@atmel.com>
	<1361926029-12518-1-git-send-email-wenyou.yang@atmel.com>
Date: Wed, 27 Feb 2013 20:26:40 +0100
Message-ID: <CAGhQ9VxPee+dPRPr0XdAd+fT=Ngcz=MAHdvZ3PkdUawk39oJTA@mail.gmail.com>
Subject: Re: [PATCH Resend v5 12/16] spi/spi-atmel: add pinctrl support for
 atmel spi
From: Joachim Eastwood <manabian@gmail.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        richard.genoud@gmail.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2013 01:47, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/spi/spi-atmel.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 00ca85f..0ed3e1a 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -23,6 +23,7 @@
>  #include <linux/platform_data/atmel.h>
>  #include <linux/platform_data/dma-atmel.h>
>  #include <linux/of.h>
> +#include <linux/pinctrl/consumer.h>
>
>  #include <asm/io.h>
>  #include <asm/gpio.h>
> @@ -1503,11 +1504,18 @@ static int atmel_spi_probe(struct platform_device *pdev)
>         int                     ret;
>         struct spi_master       *master;
>         struct atmel_spi        *as;
> +       struct pinctrl          *pinctrl;
>
>         regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (!regs)
>                 return -ENXIO;
>
> +       pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +       if (IS_ERR(pinctrl)) {
> +               dev_err(&pdev->dev, "Failed to request pinctrl\n");
> +               return PTR_ERR(pinctrl);
> +       }
> +

This patch should be dropped since driver core will now do this for us.

regards
Joachim Eastwood
