Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbaCTPVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:21:52 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44375 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaCTPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:21:51 -0400
Date: Thu, 20 Mar 2014 11:21:42 -0400
From: Matt Porter <mporter@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: bcm590xx: Remove **rdev from struct
 bcm590xx_reg
Message-ID: <20140320152142.GK25092@beef>
References: <1394762274.8460.1.camel@phoenix>
 <1394762347.8460.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394762347.8460.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 09:59:07AM +0800, Axel Lin wrote:
> The **rdev of 'struct bcm590xx_reg' isn't used anywhere in the driver so
> remove it.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/bcm590xx-regulator.c | 10 ----------
>  1 file changed, 10 deletions(-)

Looks good, thanks for catching this.

Acked-by: Matt Porter <mporter@linaro.org>

> 
> diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
> index d12d6d6..ab08ca7 100644
> --- a/drivers/regulator/bcm590xx-regulator.c
> +++ b/drivers/regulator/bcm590xx-regulator.c
> @@ -153,7 +153,6 @@ static struct bcm590xx_info bcm590xx_regs[] = {
>  struct bcm590xx_reg {
>  	struct regulator_desc *desc;
>  	struct bcm590xx *mfd;
> -	struct regulator_dev **rdev;
>  	struct bcm590xx_info **info;
>  };
>  
> @@ -334,13 +333,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	pmu->rdev = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
> -			sizeof(struct regulator_dev *), GFP_KERNEL);
> -	if (!pmu->rdev) {
> -		dev_err(&pdev->dev, "Memory alloc fails for rdev\n");
> -		return -ENOMEM;
> -	}
> -
>  	info = bcm590xx_regs;
>  
>  	for (i = 0; i < BCM590XX_NUM_REGS; i++, info++) {
> @@ -391,8 +383,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
>  				pdev->name);
>  			return PTR_ERR(rdev);
>  		}
> -
> -		pmu->rdev[i] = rdev;
>  	}
>  
>  	return 0;
> -- 
> 1.8.1.2
> 
> 
> 
