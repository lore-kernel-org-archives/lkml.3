Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaIXP27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:28:59 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:44088 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIXP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:28:58 -0400
Message-ID: <5422E335.2020907@atmel.com>
Date: Wed, 24 Sep 2014 17:28:53 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] Revert "net/macb: add pinctrl consumer support"
References: <1411429748-31444-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1411429748-31444-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/2014 01:49, Soren Brinkmann :
> This reverts commit 8ef29f8aae524bd51298fb10ac6a5ce6c4c5a3d8.
> The driver core already calls pinctrl_get() and claims the default
> state. There is no need to replicate this in the driver.
> ---
> Hi,
> 
> I might be mistaken, but I think the driver core does already take care of
> calling into the pinctrl framework and the driver does not need to do it on its
> own (drivers/base/dd.c:really_probe() calls 'pinctrl_bind_pins() which takes
> care of the pinctrl setup).

True, thanks for your patch:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


>  drivers/net/ethernet/cadence/macb.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index ca5d7798b265..e1e02fba4fcc 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -30,7 +30,6 @@
>  #include <linux/of_device.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
> -#include <linux/pinctrl/consumer.h>
>  
>  #include "macb.h"
>  
> @@ -2071,7 +2070,6 @@ static int __init macb_probe(struct platform_device *pdev)
>  	struct phy_device *phydev;
>  	u32 config;
>  	int err = -ENXIO;
> -	struct pinctrl *pinctrl;
>  	const char *mac;
>  
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -2080,15 +2078,6 @@ static int __init macb_probe(struct platform_device *pdev)
>  		goto err_out;
>  	}
>  
> -	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> -	if (IS_ERR(pinctrl)) {
> -		err = PTR_ERR(pinctrl);
> -		if (err == -EPROBE_DEFER)
> -			goto err_out;
> -
> -		dev_warn(&pdev->dev, "No pinctrl provided\n");
> -	}
> -
>  	err = -ENOMEM;
>  	dev = alloc_etherdev(sizeof(*bp));
>  	if (!dev)
> 


-- 
Nicolas Ferre
