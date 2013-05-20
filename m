Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3ETPib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:38:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:21442 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab3ETPia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:38:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="316659348"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH 20/33] drivers/thermal: don't check resource with
 devm_ioremap_resource
Thread-Topic: [PATCH 20/33] drivers/thermal: don't check resource with
 devm_ioremap_resource
Thread-Index: AQHOUiaoGbBask4iPUu3I+u+gw4T/JkOO3Og
Date: Mon, 20 May 2013 15:38:26 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B9092630110238B@SHSMSX101.ccr.corp.intel.com>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
 <1368702961-4325-21-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368702961-4325-21-git-send-email-wsa@the-dreams.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Thursday, May 16, 2013 7:16 PM
> To: linux-kernel@vger.kernel.org
> Cc: Wolfram Sang; Zhang, Rui; Eduardo Valentin; linux-
> pm@vger.kernel.org
> Subject: [PATCH 20/33] drivers/thermal: don't check resource with
> devm_ioremap_resource
> Importance: High
> 
> devm_ioremap_resource does sanity checks on the given resource. No need
> to duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

I'd prefer the RFC version, besides, I have two patches to fix
armada_thermal.c and spear_thermal.c as well.
Thus, RFC version applied to thermal -next tree.

Thanks,
rui
> ---
>  drivers/thermal/armada_thermal.c |   10 ----------
>  drivers/thermal/dove_thermal.c   |    4 ----
>  drivers/thermal/exynos_thermal.c |    5 -----
>  3 files changed, 19 deletions(-)
> 
> diff --git a/drivers/thermal/armada_thermal.c
> b/drivers/thermal/armada_thermal.c
> index 5b4d75f..54ffd64 100644
> --- a/drivers/thermal/armada_thermal.c
> +++ b/drivers/thermal/armada_thermal.c
> @@ -169,21 +169,11 @@ static int armada_thermal_probe(struct
> platform_device *pdev)
>  		return -ENOMEM;
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
> -
>  	priv->sensor = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->sensor))
>  		return PTR_ERR(priv->sensor);
> 
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENODEV;
> -	}
> -
>  	priv->control = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(priv->control))
>  		return PTR_ERR(priv->control);
> diff --git a/drivers/thermal/dove_thermal.c
> b/drivers/thermal/dove_thermal.c index 4b15a5f..a088d13 100644
> --- a/drivers/thermal/dove_thermal.c
> +++ b/drivers/thermal/dove_thermal.c
> @@ -149,10 +149,6 @@ static int dove_thermal_probe(struct
> platform_device *pdev)
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
> diff --git a/drivers/thermal/exynos_thermal.c
> b/drivers/thermal/exynos_thermal.c
> index d20ce9e..788b1dd 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -925,11 +925,6 @@ static int exynos_tmu_probe(struct platform_device
> *pdev)
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
> --
> 1.7.10.4

