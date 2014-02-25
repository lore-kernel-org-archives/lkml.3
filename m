Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBYIwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:52:44 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42583 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBYIwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:52:41 -0500
Date: Tue, 25 Feb 2014 08:52:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com, nm@ti.com,
        khilman@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v8 03/14] mfd: omap-usb-host: Use clock names as per
 function for reference clocks
Message-ID: <20140225085234.GB19099@lee--X1>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
 <1392896409-5101-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392896409-5101-4-git-send-email-rogerq@ti.com>
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
>  drivers/mfd/omap-usb-host.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 865c276..651e249 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -718,24 +718,24 @@ static int usbhs_omap_probe(struct platform_device *pdev)
>  		goto err_mem;
>  	}
>  
> -	omap->xclk60mhsp1_ck = devm_clk_get(dev, "xclk60mhsp1_ck");
> +	omap->xclk60mhsp1_ck = devm_clk_get(dev, "refclk_60m_ext_p1");
>  	if (IS_ERR(omap->xclk60mhsp1_ck)) {
>  		ret = PTR_ERR(omap->xclk60mhsp1_ck);
> -		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
> +		dev_err(dev, "refclk_60m_ext_p1 failed error:%d\n", ret);
>  		goto err_mem;
>  	}

Will anything break if I were to apply the MFD patches seperately?

> -	omap->xclk60mhsp2_ck = devm_clk_get(dev, "xclk60mhsp2_ck");
> +	omap->xclk60mhsp2_ck = devm_clk_get(dev, "refclk_60m_ext_p2");
>  	if (IS_ERR(omap->xclk60mhsp2_ck)) {
>  		ret = PTR_ERR(omap->xclk60mhsp2_ck);
> -		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
> +		dev_err(dev, "refclk_60m_ext_p2 failed error:%d\n", ret);
>  		goto err_mem;
>  	}
>  
> -	omap->init_60m_fclk = devm_clk_get(dev, "init_60m_fclk");
> +	omap->init_60m_fclk = devm_clk_get(dev, "refclk_60m_int");
>  	if (IS_ERR(omap->init_60m_fclk)) {
>  		ret = PTR_ERR(omap->init_60m_fclk);
> -		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
> +		dev_err(dev, "refclk_60m_int failed error:%d\n", ret);
>  		goto err_mem;
>  	}
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
