Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3EPHJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:09:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:41471 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab3EPHJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="242316334"
Date: Thu, 16 May 2013 12:04:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 38/39] dmaengine: ste_dma40: Fetch the number of
 physical channels from DT
Message-ID: <20130516063414.GB14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-39-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368611522-9984-39-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:52:01AM +0100, Lee Jones wrote:
> Some platforms insist on obscure physical channel availability. This
> information is currently passed though platform data in internal BSP
> kernels. Once those platforms land, they'll need to configure them
> appropriately, so we may as well add the infrastructure.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
Acked-by: Vinod Koul <vinod.koul@intel.com>

>  drivers/dma/ste_dma40.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index ae462d3..4e528dd 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -3482,7 +3482,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
>  			       struct device_node *np)
>  {
>  	struct stedma40_platform_data *pdata;
> -	int num_memcpy = 0;
> +	int num_phy = 0, num_memcpy = 0;
>  	const const __be32 *list;
>  
>  	pdata = devm_kzalloc(&pdev->dev,
> @@ -3491,6 +3491,11 @@ static int __init d40_of_probe(struct platform_device *pdev,
>  	if (!pdata)
>  		return -ENOMEM;
>  
> +	/* If absent this value will be obtained from h/w. */
> +	of_property_read_u32(np, "dma-channels", &num_phy);
> +	if (num_phy > 0)
> +		pdata->num_of_phy_chans = num_phy;
> +
>  	list = of_get_property(np, "memcpy-channels", &num_memcpy);
>  	num_memcpy /= sizeof(*list);
>  
> -- 
> 1.7.10.4
> 
