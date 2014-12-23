Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbaLWPhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:37:55 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:47632 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbaLWPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:37:53 -0500
MIME-Version: 1.0
In-Reply-To: <1419286616-9893-2-git-send-email-wsa@the-dreams.de>
References: <1419286616-9893-1-git-send-email-wsa@the-dreams.de>
	<1419286616-9893-2-git-send-email-wsa@the-dreams.de>
Date: Tue, 23 Dec 2014 16:37:52 +0100
Message-ID: <CAPDyKFrroxHw4qm4GRE2C1iWgf5_-P4W3O9Mxf-7vgg7pXiGqA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mmc: host: don't use devm_pinctrl_get_select_default()
 in probe
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <chris@printf.net>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 December 2014 at 23:16, Wolfram Sang <wsa@the-dreams.de> wrote:
> Since commit ab78029ecc34 (drivers/pinctrl: grab default handles from device
> core), we can rely on device core for setting the default pins.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Thanks! Applied for next, with an updated prefix of the commit header
to "mmc: mvsdio:".

Kind regards
Uffe

> ---
>  drivers/mmc/host/mvsdio.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
> index 4f8618f4522d..a2cb92851f1f 100644
> --- a/drivers/mmc/host/mvsdio.c
> +++ b/drivers/mmc/host/mvsdio.c
> @@ -25,7 +25,6 @@
>  #include <linux/of_irq.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/slot-gpio.h>
> -#include <linux/pinctrl/consumer.h>
>
>  #include <asm/sizes.h>
>  #include <asm/unaligned.h>
> @@ -704,7 +703,6 @@ static int mvsd_probe(struct platform_device *pdev)
>         const struct mbus_dram_target_info *dram;
>         struct resource *r;
>         int ret, irq;
> -       struct pinctrl *pinctrl;
>
>         r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         irq = platform_get_irq(pdev, 0);
> @@ -721,10 +719,6 @@ static int mvsd_probe(struct platform_device *pdev)
>         host->mmc = mmc;
>         host->dev = &pdev->dev;
>
> -       pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> -       if (IS_ERR(pinctrl))
> -               dev_warn(&pdev->dev, "no pins associated\n");
> -
>         /*
>          * Some non-DT platforms do not pass a clock, and the clock
>          * frequency is passed through platform_data. On DT platforms,
> --
> 2.1.3
>
