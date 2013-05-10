Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3EJOuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:50:16 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:59800 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754238Ab3EJOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:50:12 -0400
Date: Fri, 10 May 2013 16:30:34 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [RFC 18/42] drivers/pinctrl: don't check resource with
 devm_ioremap_resource
Message-ID: <20130510143034.GA22508@game.jcrosoft.org>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-19-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368173847-5661-19-git-send-email-wsa@the-dreams.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 399975942273280877
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:17 Fri 10 May     , Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/pinctrl/pinctrl-at91.c       |    7 +------
for at91
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

>  drivers/pinctrl/pinctrl-coh901.c     |    5 -----
>  drivers/pinctrl/pinctrl-exynos5440.c |    5 -----
>  drivers/pinctrl/pinctrl-samsung.c    |    5 -----
>  drivers/pinctrl/pinctrl-xway.c       |    4 ----
>  5 files changed, 1 insertion(+), 25 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 5d7529e..b90a3a0 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -1543,12 +1543,6 @@ static int at91_gpio_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		ret = -ENOENT;
> -		goto err;
> -	}
> -
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
>  		ret = irq;
> @@ -1561,6 +1555,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	at91_chip->regbase = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(at91_chip->regbase)) {
>  		ret = PTR_ERR(at91_chip->regbase);
> diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
> index edde3ac..a67af41 100644
> --- a/drivers/pinctrl/pinctrl-coh901.c
> +++ b/drivers/pinctrl/pinctrl-coh901.c
> @@ -713,11 +713,6 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
>  	gpio->dev = &pdev->dev;
>  
>  	memres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!memres) {
> -		dev_err(gpio->dev, "could not get GPIO memory resource\n");
> -		return -ENODEV;
> -	}
> -
>  	gpio->base = devm_ioremap_resource(&pdev->dev, memres);
>  	if (IS_ERR(gpio->base))
>  		return PTR_ERR(gpio->base);
> diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
> index 6038503..32a48f4 100644
> --- a/drivers/pinctrl/pinctrl-exynos5440.c
> +++ b/drivers/pinctrl/pinctrl-exynos5440.c
> @@ -1000,11 +1000,6 @@ static int exynos5440_pinctrl_probe(struct platform_device *pdev)
>  	}
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(dev, "cannot find IO resource\n");
> -		return -ENOENT;
> -	}
> -
>  	priv->reg_base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->reg_base))
>  		return PTR_ERR(priv->reg_base);
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> index 9763668..055d016 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -932,11 +932,6 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
>  	drvdata->dev = dev;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(dev, "cannot find IO resource\n");
> -		return -ENOENT;
> -	}
> -
>  	drvdata->virt_base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(drvdata->virt_base))
>  		return PTR_ERR(drvdata->virt_base);
> diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
> index f2977cf..e92132c 100644
> --- a/drivers/pinctrl/pinctrl-xway.c
> +++ b/drivers/pinctrl/pinctrl-xway.c
> @@ -716,10 +716,6 @@ static int pinmux_xway_probe(struct platform_device *pdev)
>  
>  	/* get and remap our register range */
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get resource\n");
> -		return -ENOENT;
> -	}
>  	xway_info.membase[0] = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(xway_info.membase[0]))
>  		return PTR_ERR(xway_info.membase[0]);
> -- 
> 1.7.10.4
> 
