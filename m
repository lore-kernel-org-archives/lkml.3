Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaBNKJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:09:25 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50125 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBNKJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:09:22 -0500
Date: Fri, 14 Feb 2014 10:09:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com, nm@ti.com,
        khilman@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v7 03/12] mfd: omap-usb-host: Use clock names as per
 function for reference clocks
Message-ID: <20140214100915.GD7380@lee--X1>
References: <1392200333-28397-1-git-send-email-rogerq@ti.com>
 <1392200333-28397-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392200333-28397-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use a meaningful name for the reference clocks so that it indicates the function.
> 
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 60a3bed..ce620a8 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -714,21 +714,21 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>  		goto err_mem;
>  	}
>  
> -	omap->xclk60mhsp1_ck = devm_clk_get(dev, "xclk60mhsp1_ck");
> +	omap->xclk60mhsp1_ck = devm_clk_get(dev, "refclk_60m_ext_p1");

You can't do that. These changes will have to be in the same patch as
the core change i.e. where they are initialised.

>  	if (IS_ERR(omap->xclk60mhsp1_ck)) {
>  		ret = PTR_ERR(omap->xclk60mhsp1_ck);
>  		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
>  		goto err_mem;
>  	}
>  
> -	omap->xclk60mhsp2_ck = devm_clk_get(dev, "xclk60mhsp2_ck");
> +	omap->xclk60mhsp2_ck = devm_clk_get(dev, "refclk_60m_ext_p2");
>  	if (IS_ERR(omap->xclk60mhsp2_ck)) {
>  		ret = PTR_ERR(omap->xclk60mhsp2_ck);
>  		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
>  		goto err_mem;
>  	}
>  
> -	omap->init_60m_fclk = devm_clk_get(dev, "init_60m_fclk");
> +	omap->init_60m_fclk = devm_clk_get(dev, "refclk_60m_int");
>  	if (IS_ERR(omap->init_60m_fclk)) {
>  		ret = PTR_ERR(omap->init_60m_fclk);
>  		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
