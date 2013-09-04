Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840Ab3IDOdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:33:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:48263 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab3IDOdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:33:33 -0400
X-Auth-Info: XG6s5U9LtmdNiq7hNDBlX6GFQj6qrePhaQzyKML44Dw=
From: Marek Vasut <marex@denx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 6/7] regulator: rc5t583: Use devm_regulator_register
Date: Wed, 4 Sep 2013 16:33:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org, nm@ti.com,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, Nancy.Chen@freescale.com
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org> <1378276263-10735-6-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1378276263-10735-6-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201309041633.33017.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sachin Kamat,

> devm_* simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/regulator/rc5t583-regulator.c |   22 ++--------------------
>  1 file changed, 2 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/regulator/rc5t583-regulator.c
> b/drivers/regulator/rc5t583-regulator.c index 5885b45..b58affb 100644
> --- a/drivers/regulator/rc5t583-regulator.c
> +++ b/drivers/regulator/rc5t583-regulator.c
> @@ -173,33 +173,16 @@ skip_ext_pwr_config:
>  		config.driver_data = reg;
>  		config.regmap = rc5t583->regmap;
> 
> -		rdev = regulator_register(&ri->desc, &config);
> +		rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
>  		if (IS_ERR(rdev)) {
>  			dev_err(&pdev->dev, "Failed to register regulator %s\n",
>  						ri->desc.name);
> -			ret = PTR_ERR(rdev);
> -			goto clean_exit;
> +			return PTR_ERR(rdev);
>  		}
>  		reg->rdev = rdev;
>  	}
>  	platform_set_drvdata(pdev, regs);
>  	return 0;
> -
> -clean_exit:
> -	while (--id >= 0)
> -		regulator_unregister(regs[id].rdev);
> -
> -	return ret;
> -}
> -
> -static int rc5t583_regulator_remove(struct platform_device *pdev)
> -{
> -	struct rc5t583_regulator *regs = platform_get_drvdata(pdev);
> -	int id;
> -
> -	for (id = 0; id < RC5T583_REGULATOR_MAX; ++id)
> -		regulator_unregister(regs[id].rdev);
> -	return 0;
>  }
> 
>  static struct platform_driver rc5t583_regulator_driver = {
> @@ -208,7 +191,6 @@ static struct platform_driver rc5t583_regulator_driver
> = { .owner	= THIS_MODULE,
>  	},
>  	.probe		= rc5t583_regulator_probe,
> -	.remove		= rc5t583_regulator_remove,
>  };
> 
>  static int __init rc5t583_regulator_init(void)

Next up, you might want to start flipping the regulator drivers to 
module_platform_driver ;-)

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
