Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3IYK4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:56:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40910 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3IYK4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:56:37 -0400
Message-ID: <1380106593.7211.5.camel@hornet>
Subject: Re: [PATCH 20/20] regulator: vexpress: use devm_regulator_register()
From: Pawel Moll <pawel.moll@arm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 11:56:33 +0100
In-Reply-To: <001d01ceb9c7$9cf167e0$d6d437a0$%han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
	 <001d01ceb9c7$9cf167e0$d6d437a0$%han@samsung.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Sep 2013 10:56:33.0646 (UTC) FILETIME=[E5E898E0:01CEB9DD]
X-MC-Unique: 113092511563503201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 09:17 +0100, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/vexpress.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
> index 4668c7f..f3ae28a 100644
> --- a/drivers/regulator/vexpress.c
> +++ b/drivers/regulator/vexpress.c
> @@ -96,7 +96,7 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
>  	config.driver_data = reg;
>  	config.of_node = pdev->dev.of_node;
>  
> -	reg->regdev = regulator_register(&reg->desc, &config);
> +	reg->regdev = devm_regulator_register(&pdev->dev, &reg->desc, &config);
>  	if (IS_ERR(reg->regdev)) {
>  		err = PTR_ERR(reg->regdev);
>  		goto error_regulator_register;
> @@ -119,7 +119,6 @@ static int vexpress_regulator_remove(struct platform_device *pdev)
>  	struct vexpress_regulator *reg = platform_get_drvdata(pdev);
>  
>  	vexpress_config_func_put(reg->func);
> -	regulator_unregister(reg->regdev);
>  
>  	return 0;
>  }

I'm assuming it's following a patch adding devm_regulator_register()?

Based on this:

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks!

Pawel


