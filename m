Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBSIiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:38:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43430 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaBSIix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:38:53 -0500
Message-ID: <53046D87.6030606@ti.com>
Date: Wed, 19 Feb 2014 14:08:31 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v2] regulator: tps65218: Remove unnecessary regulator_unregister
 call
References: <1392798801.31957.3.camel@phoenix> <1392798851.31957.4.camel@phoenix>
In-Reply-To: <1392798851.31957.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 February 2014 02:04 PM, Axel Lin wrote:
> Current code uses devm_regulator_register() so the we don't need to explicitly
> call regulator_unregister() in .remove.
> And then we don't need to save rdev pointer to tps->rdev[id].

Acked-by: Keerthy <j-keerthy@ti.com>

> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>   drivers/regulator/tps65218-regulator.c | 18 ------------------
>   1 file changed, 18 deletions(-)
>
> diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
> index d1c7831..1fb1db5 100644
> --- a/drivers/regulator/tps65218-regulator.c
> +++ b/drivers/regulator/tps65218-regulator.c
> @@ -267,23 +267,6 @@ static int tps65218_regulator_probe(struct platform_device *pdev)
>   		return PTR_ERR(rdev);
>   	}
>   
> -	/* Save regulator */
> -	tps->rdev[id] = rdev;
> -
> -	return 0;
> -}
> -
> -static int tps65218_regulator_remove(struct platform_device *pdev)
> -{
> -	struct tps65218 *tps = platform_get_drvdata(pdev);
> -	const struct of_device_id	*match;
> -	const struct tps_info		*template;
> -
> -	match = of_match_device(tps65218_of_match, &pdev->dev);
> -	template = match->data;
> -	regulator_unregister(tps->rdev[template->id]);
> -	platform_set_drvdata(pdev, NULL);
> -
>   	return 0;
>   }
>   
> @@ -294,7 +277,6 @@ static struct platform_driver tps65218_regulator_driver = {
>   		.of_match_table = of_match_ptr(tps65218_of_match),
>   	},
>   	.probe = tps65218_regulator_probe,
> -	.remove = tps65218_regulator_remove,
>   };
>   
>   module_platform_driver(tps65218_regulator_driver);

