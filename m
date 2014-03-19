Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbaCSJuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:50:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:18492 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627AbaCSJum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:50:42 -0400
Message-ID: <5329686E.4070202@atmel.com>
Date: Wed, 19 Mar 2014 10:50:38 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, <linux-fbdev@vger.kernel.org>,
        "Tomi Valkeinen" <tomi.valkeinen@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Video: atmel: avoid the id of fix screen info is overwritten
References: <1395215275-14345-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395215275-14345-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/2014 08:47, Bo Shen :
> Correct passing parameter sequence, which will avoid the id of
> fix screen info is overwritten.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks.

> ---
>  drivers/video/atmel_lcdfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> index cd96162..695f28a 100644
> --- a/drivers/video/atmel_lcdfb.c
> +++ b/drivers/video/atmel_lcdfb.c
> @@ -1190,12 +1190,12 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
>  	if (!sinfo->config)
>  		goto free_info;
>  
> -	strcpy(info->fix.id, sinfo->pdev->name);
>  	info->flags = ATMEL_LCDFB_FBINFO_DEFAULT;
>  	info->pseudo_palette = sinfo->pseudo_palette;
>  	info->fbops = &atmel_lcdfb_ops;
>  
>  	info->fix = atmel_lcdfb_fix;
> +	strcpy(info->fix.id, sinfo->pdev->name);
>  
>  	/* Enable LCDC Clocks */
>  	sinfo->bus_clk = clk_get(dev, "hclk");
> 


-- 
Nicolas Ferre
