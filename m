Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbaCTUPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:15:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57562 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbaCTUPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:15:49 -0400
Message-ID: <532B4C36.8060405@ti.com>
Date: Thu, 20 Mar 2014 16:14:46 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <galak@codeaurora.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <m-karicheri2@ti.com>,
        Warner Losh <imp@bsdimp.com>
Subject: Re: [PATCH v2] mtd: davinci-nand: disable subpage write for keystone-nand
References: <1395346112-13350-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1395346112-13350-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 04:08 PM, Ivan Khoronzhuk wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> 
> Sub page write doesn't work because of hw issue in controller found on
> Keystone SOCs. AEMIF controller is also used on DaVinci SOCs which
> don't seems to have any issue. So add "ti,keysone-nand" compatible
> to nand driver in order to set NAND_NO_SUBPAGE_WRITE option.
> 
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: Warner Losh <imp@bsdimp.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
> 
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

> This patch is a result of discussion on patch v1:
> https://lkml.org/lkml/2014/3/20/461
> 
>  drivers/mtd/nand/davinci_nand.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index 4615d79..b922c8e 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -523,6 +523,7 @@ static struct nand_ecclayout hwecc4_2048 = {
>  #if defined(CONFIG_OF)
>  static const struct of_device_id davinci_nand_of_match[] = {
>  	{.compatible = "ti,davinci-nand", },
> +	{.compatible = "ti,keystone-nand", },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, davinci_nand_of_match);
> @@ -581,6 +582,11 @@ static struct davinci_nand_pdata
>  		    of_property_read_bool(pdev->dev.of_node,
>  			"ti,davinci-nand-use-bbt"))
>  			pdata->bbt_options = NAND_BBT_USE_FLASH;
> +
> +		if (of_device_is_compatible(pdev->dev.of_node,
> +					    "ti,keystone-nand")) {
> +			pdata->options |= NAND_NO_SUBPAGE_WRITE;
> +		}
>  	}
>  
>  	return dev_get_platdata(&pdev->dev);
> 

