Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbaCTPnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:43:19 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:49789 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaCTPnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:43:16 -0400
Date: Thu, 20 Mar 2014 11:42:57 -0400
From: Matt Porter <mporter@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] regulator: bcm590xx: Use array to save desc and *info
Message-ID: <20140320154257.GL25092@beef>
References: <1394762274.8460.1.camel@phoenix>
 <1394762428.8460.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394762428.8460.5.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:00:28AM +0800, Axel Lin wrote:
> BCM590XX_NUM_REGS is known in compile time.
> Use array to save desc and *info makes the code simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Well, ok. It was coded for dynamic allocation because I'm starting to
work on BCM59054 support, which is similar but different. The actual
regulators are different but, due to luck, the total number is the
same between 59056 and 59054...so this can still work for the moment.
However, another 590xx part does have a different number of regulators
so I'm not sure this is worth doing when we know we'll go back to
dynamic allocation in the future.

-Matt

> ---
>  drivers/regulator/bcm590xx-regulator.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
> index ab08ca7..fe21855 100644
> --- a/drivers/regulator/bcm590xx-regulator.c
> +++ b/drivers/regulator/bcm590xx-regulator.c
> @@ -151,9 +151,9 @@ static struct bcm590xx_info bcm590xx_regs[] = {
>  };
>  
>  struct bcm590xx_reg {
> -	struct regulator_desc *desc;
> +	struct regulator_desc desc[BCM590XX_NUM_REGS];
>  	struct bcm590xx *mfd;
> -	struct bcm590xx_info **info;
> +	struct bcm590xx_info *info[BCM590XX_NUM_REGS];
>  };
>  
>  static int bcm590xx_get_vsel_register(int id)
> @@ -319,20 +319,6 @@ static int bcm590xx_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, pmu);
>  
> -	pmu->desc = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
> -			sizeof(struct regulator_desc), GFP_KERNEL);
> -	if (!pmu->desc) {
> -		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
> -		return -ENOMEM;
> -	}
> -
> -	pmu->info = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
> -			sizeof(struct bcm590xx_info *), GFP_KERNEL);
> -	if (!pmu->info) {
> -		dev_err(&pdev->dev, "Memory alloc fails for info\n");
> -		return -ENOMEM;
> -	}
> -
>  	info = bcm590xx_regs;
>  
>  	for (i = 0; i < BCM590XX_NUM_REGS; i++, info++) {
> -- 
> 1.8.1.2
> 
> 
> 
