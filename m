Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3JNHaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:30:05 -0400
Received: from plane.gmane.org ([80.91.229.3]:35959 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab3JNHaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:30:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Romain Izard <romain.izard.pro@gmail.com>
Subject: Re: [PATCH 2/4] drivers/mmc/host: don't use
 devm_pinctrl_get_select_default() in probe
Date: Mon, 14 Oct 2013 07:28:09 +0000 (UTC)
Message-ID: <l3g6e9$fqh$1@ger.gmane.org>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
 <1381681071-6021-3-git-send-email-wsa@the-dreams.de>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 146.187.3.109.rev.sfr.net
User-Agent: slrn/pre1.0.0-18 (Linux)
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-13, Wolfram Sang <wsa@the-dreams.de> wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for setting the default pins. Compile tested only.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/mmc/host/mvsdio.c          | 7 +------
>  drivers/mmc/host/omap_hsmmc.c      | 7 -------
>  drivers/mmc/host/sdhci-esdhc-imx.c | 8 --------
>  3 files changed, 1 insertion(+), 21 deletions(-)
>
> diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
> index 06c5b0b..8c9f448 100644
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
> @@ -685,7 +684,7 @@ static int __init mvsd_probe(struct platform_device *pdev)
>  	const struct mbus_dram_target_info *dram;
>  	struct resource *r;
>  	int ret, irq;
> -	struct pinctrl *pinctrl;
> +	int gpio_card_detect, gpio_write_protect;
>  

This new line does not belong to this patch.

>  	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	irq = platform_get_irq(pdev, 0);
> @@ -702,10 +701,6 @@ static int __init mvsd_probe(struct platform_device *pdev)
>  	host->mmc = mmc;
>  	host->dev = &pdev->dev;
>  
> -	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> -	if (IS_ERR(pinctrl))
> -		dev_warn(&pdev->dev, "no pins associated\n");
> -
>  	/*
>  	 * Some non-DT platforms do not pass a clock, and the clock
>  	 * frequency is passed through platform_data. On DT platforms,

Best regards,
-- 
Romain Izard

