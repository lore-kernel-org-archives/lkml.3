Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3IYM7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:59:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38495 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab3IYM7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:59:49 -0400
Date: Wed, 25 Sep 2013 07:59:42 -0500
From: Nishanth Menon <nm@ti.com>
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, "'Balaji T K'" <balajitk@ti.com>
Subject: Re: [PATCH 19/20] regulator: twl: use devm_regulator_register()
Message-ID: <20130925125942.GA21425@kahuna>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
 <001c01ceb9c7$72a353e0$57e9fba0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <001c01ceb9c7$72a353e0$57e9fba0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:15-20130925, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/twl-regulator.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> index 78aae4c..8ebd785 100644
> --- a/drivers/regulator/twl-regulator.c
> +++ b/drivers/regulator/twl-regulator.c
> @@ -1188,7 +1188,7 @@ static int twlreg_probe(struct platform_device *pdev)
>  	config.driver_data = info;
>  	config.of_node = pdev->dev.of_node;
>  
> -	rdev = regulator_register(&info->desc, &config);
> +	rdev = devm_regulator_register(&pdev->dev, &info->desc, &config);
>  	if (IS_ERR(rdev)) {
>  		dev_err(&pdev->dev, "can't register %s, %ld\n",
>  				info->desc.name, PTR_ERR(rdev));
> @@ -1217,7 +1217,6 @@ static int twlreg_remove(struct platform_device *pdev)
>  	struct regulator_dev *rdev = platform_get_drvdata(pdev);
>  	struct twlreg_info *info = rdev->reg_data;
>  
> -	regulator_unregister(rdev);
>  	kfree(info);
>  	return 0;
>  }
> -- 
> 1.7.10.4
> 
> 
Acked-by: Nishanth Menon <nm@ti.com>
-- 
Regards,
Nishanth Menon
