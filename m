Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab3ICKQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:16:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17822 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759836Ab3ICKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:16:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Sep 2013 03:16:39 -0700
Message-ID: <5225B701.6020502@nvidia.com>
Date: Tue, 3 Sep 2013 19:16:33 +0900
From: jinyoungp <jinyoungp@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Thunderbird/22.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] regulator: aat2870: Convert to devm_regulator_register
References: <1378189056.4621.1.camel@phoenix> <1378189140.4621.3.camel@phoenix>
In-Reply-To: <1378189140.4621.3.camel@phoenix>
X-NVConfidentiality: public
Content-Type: text/plain; charset="EUC-KR"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jinyoung Park <jinyoungp@nvidia.com>

On 09/03/2013 03:19 PM, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/aat2870-regulator.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/drivers/regulator/aat2870-regulator.c b/drivers/regulator/aat2870-regulator.c
> index 8b58763..1ca60ac 100644
> --- a/drivers/regulator/aat2870-regulator.c
> +++ b/drivers/regulator/aat2870-regulator.c
> @@ -176,7 +176,7 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
>  	config.driver_data = ri;
>  	config.init_data = pdev->dev.platform_data;
>  
> -	rdev = regulator_register(&ri->desc, &config);
> +	rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
>  	if (IS_ERR(rdev)) {
>  		dev_err(&pdev->dev, "Failed to register regulator %s\n",
>  			ri->desc.name);
> @@ -187,21 +187,12 @@ static int aat2870_regulator_probe(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static int aat2870_regulator_remove(struct platform_device *pdev)
> -{
> -	struct regulator_dev *rdev = platform_get_drvdata(pdev);
> -
> -	regulator_unregister(rdev);
> -	return 0;
> -}
> -
>  static struct platform_driver aat2870_regulator_driver = {
>  	.driver = {
>  		.name	= "aat2870-regulator",
>  		.owner	= THIS_MODULE,
>  	},
>  	.probe	= aat2870_regulator_probe,
> -	.remove	= aat2870_regulator_remove,
>  };
>  
>  static int __init aat2870_regulator_init(void)

