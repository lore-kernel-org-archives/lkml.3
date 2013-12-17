Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3LQIuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:50:35 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44873 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3LQIud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:50:33 -0500
Date: Tue, 17 Dec 2013 00:50:27 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, grygorii.strashko@ti.com,
        dwmw2@infradead.org
Subject: Re: [PATCH v3 7/9] mtd: nand: davinci: adjust DT properties to MTD
 generic
Message-ID: <20131217085027.GK12034@norris-Latitude-E6410>
References: <1386264358-9738-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1386264358-9738-8-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386264358-9738-8-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 07:25:55PM +0200, Ivan Khoronzhuk wrote:
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -558,6 +557,8 @@ static struct davinci_nand_pdata
>  			"ti,davinci-mask-chipsel", &prop))
>  			pdata->mask_chipsel = prop;
>  		if (!of_property_read_string(pdev->dev.of_node,
> +			"nand-ecc-mode", &mode) ||

Is it possible to use the of_get_nand_ecc_mode() helper? It's
unfortunate that davinci_nand had to use custom bindings in the first
place, making this more difficult... So I can take this patch as-is.

> +		    !of_property_read_string(pdev->dev.of_node,
>  			"ti,davinci-ecc-mode", &mode)) {
>  			if (!strncmp("none", mode, 4))
>  				pdata->ecc_mode = NAND_ECC_NONE;
> @@ -570,11 +571,15 @@ static struct davinci_nand_pdata
>  			"ti,davinci-ecc-bits", &prop))
>  			pdata->ecc_bits = prop;
>  		if (!of_property_read_u32(pdev->dev.of_node,
> +			"nand-bus-width", &prop) ||

Similar story here, with of_get_nand_bus_width().

> +		    !of_property_read_u32(pdev->dev.of_node,
>  			"ti,davinci-nand-buswidth", &prop))
>  			if (prop == 16)
>  				pdata->options |= NAND_BUSWIDTH_16;
> -		if (of_find_property(pdev->dev.of_node,
> -			"ti,davinci-nand-use-bbt", &len))
> +		if (of_property_read_bool(pdev->dev.of_node,
> +			"nand-on-flash-bbt") ||
> +		    of_property_read_bool(pdev->dev.of_node,
> +			"ti,davinci-nand-use-bbt"))
>  			pdata->bbt_options = NAND_BBT_USE_FLASH;
>  	}
>  

Brian
