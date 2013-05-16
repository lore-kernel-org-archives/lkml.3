Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3EPHXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:23:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:32360 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab3EPHXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:23:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="334937851"
Message-ID: <1368688977.2063.35.camel@rzhang1-mobl4>
Subject: Re: [RFC 26/42] drivers/thermal: don't check resource with
 devm_ioremap_resource
From: Zhang Rui <rui.zhang@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Thu, 16 May 2013 15:22:57 +0800
In-Reply-To: <1368173847-5661-27-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	 <1368173847-5661-27-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-10 at 10:17 +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

applied to thermal -next.

thanks,
rui
> ---
>  drivers/thermal/dove_thermal.c     |   11 +----------
>  drivers/thermal/exynos_thermal.c   |    5 -----
>  drivers/thermal/kirkwood_thermal.c |    7 +------
>  drivers/thermal/rcar_thermal.c     |    6 +-----
>  4 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/thermal/dove_thermal.c b/drivers/thermal/dove_thermal.c
> index 3078c40..5c53c53 100644
> --- a/drivers/thermal/dove_thermal.c
> +++ b/drivers/thermal/dove_thermal.c
> @@ -133,25 +133,16 @@ static int dove_thermal_probe(struct platform_device *pdev)
>  	struct resource *res;
>  	int ret;
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
> -
>  	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	priv->sensor = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->sensor))
>  		return PTR_ERR(priv->sensor);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
>  	priv->control = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->control))
>  		return PTR_ERR(priv->control);
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index b777ae6..a7bef42 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -967,11 +967,6 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>  	INIT_WORK(&data->irq_work, exynos_tmu_work);
>  
>  	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!data->mem) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENOENT;
> -	}
> -
>  	data->base = devm_ioremap_resource(&pdev->dev, data->mem);
>  	if (IS_ERR(data->base))
>  		return PTR_ERR(data->base);
> diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
> index e5500ed..e3ca1b4 100644
> --- a/drivers/thermal/kirkwood_thermal.c
> +++ b/drivers/thermal/kirkwood_thermal.c
> @@ -75,16 +75,11 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
>  	struct kirkwood_thermal_priv *priv;
>  	struct resource *res;
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
> -
>  	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	priv->sensor = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->sensor))
>  		return PTR_ERR(priv->sensor);
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> index 2cc5b61..b2217b3 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -385,11 +385,6 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>  		 * platform has IRQ support.
>  		 * Then, drier use common register
>  		 */
> -		res = platform_get_resource(pdev, IORESOURCE_MEM, mres++);
> -		if (!res) {
> -			dev_err(dev, "Could not get platform resource\n");
> -			return -ENODEV;
> -		}
>  
>  		ret = devm_request_irq(dev, irq->start, rcar_thermal_irq, 0,
>  				       dev_name(dev), common);
> @@ -401,6 +396,7 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>  		/*
>  		 * rcar_has_irq_support() will be enabled
>  		 */
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, mres++);
>  		common->base = devm_ioremap_resource(dev, res);
>  		if (IS_ERR(common->base))
>  			return PTR_ERR(common->base);


