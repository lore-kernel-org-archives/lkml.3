Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbaFCPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:19:22 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34244 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889AbaFCPTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:19:20 -0400
Date: Tue, 3 Jun 2014 11:19:15 -0400
From: "'Matt Porter'" <mporter@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Tim Kryger'" <tim.kryger@linaro.org>
Subject: Re: [PATCH 1/3] regulator: bcm590xx: remove unnecessary OOM messages
Message-ID: <20140603151915.GV32082@beef>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 03:27:21PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/bcm590xx-regulator.c |   16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)

Looks good, thanks.

Acked-by: Matt Porter <mporter@linaro.org>

> diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
> index 57544e2..fb8c6f7 100644
> --- a/drivers/regulator/bcm590xx-regulator.c
> +++ b/drivers/regulator/bcm590xx-regulator.c
> @@ -326,10 +326,8 @@ static struct bcm590xx_board *bcm590xx_parse_dt_reg_data(
>  	}
>  
>  	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> -	if (!data) {
> -		dev_err(&pdev->dev, "failed to allocate regulator board data\n");
> +	if (!data)
>  		return NULL;
> -	}
>  
>  	np = of_node_get(np);
>  	regulators = of_get_child_by_name(np, "regulators");
> @@ -374,10 +372,8 @@ static int bcm590xx_probe(struct platform_device *pdev)
>  					      &bcm590xx_reg_matches);
>  
>  	pmu = devm_kzalloc(&pdev->dev, sizeof(*pmu), GFP_KERNEL);
> -	if (!pmu) {
> -		dev_err(&pdev->dev, "Memory allocation failed for pmu\n");
> +	if (!pmu)
>  		return -ENOMEM;
> -	}
>  
>  	pmu->mfd = bcm590xx;
>  
> @@ -385,17 +381,13 @@ static int bcm590xx_probe(struct platform_device *pdev)
>  
>  	pmu->desc = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
>  			sizeof(struct regulator_desc), GFP_KERNEL);
> -	if (!pmu->desc) {
> -		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
> +	if (!pmu->desc)
>  		return -ENOMEM;
> -	}
>  
>  	pmu->info = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
>  			sizeof(struct bcm590xx_info *), GFP_KERNEL);
> -	if (!pmu->info) {
> -		dev_err(&pdev->dev, "Memory alloc fails for info\n");
> +	if (!pmu->info)
>  		return -ENOMEM;
> -	}
>  
>  	info = bcm590xx_regs;
>  
> -- 
> 1.7.10.4
> 
> 
