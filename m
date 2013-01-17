Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3AQF2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 00:28:47 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:34151 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3AQF2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 00:28:46 -0500
Message-ID: <50F78C06.8050705@gmail.com>
Date: Thu, 17 Jan 2013 14:28:38 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: lp8755: Don't show unrelated messags in lp8755_probe
 error paths
References: <1357973915.16304.1.camel@phoenix>
In-Reply-To: <1357973915.16304.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013년 01월 12일 15:58, Axel Lin 쓴 글:
> Signed-off-by: Axel Lin<axel.lin@ingics.com>
> ---
>   drivers/regulator/lp8755.c |   19 ++++++++++---------
>   1 file changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
> index decb3ad..8c3f3f2 100644
> --- a/drivers/regulator/lp8755.c
> +++ b/drivers/regulator/lp8755.c
> @@ -497,35 +497,36 @@ static int lp8755_probe(struct i2c_client *client,
>   		if (!pchip->pdata)
>   			return -ENOMEM;
>   		ret = lp8755_init_data(pchip);
> -		if (ret < 0)
> -			goto err_chip_init;
> +		if (ret < 0) {
> +			dev_err(&client->dev, "fail to initialize chip\n");
> +			return ret;
> +		}
>   	}
>   
>   	ret = lp8755_regulator_init(pchip);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dev_err(&client->dev, "fail to initialize regulators\n");
>   		goto err_regulator;
> +	}
>   
>   	pchip->irq = client->irq;
>   	ret = lp8755_int_config(pchip);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dev_err(&client->dev, "fail to irq config\n");
>   		goto err_irq;
> +	}
>   
>   	return ret;
>   
>   err_irq:
> -	dev_err(&client->dev, "fail to irq config\n");
> -
>   	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
>   		regulator_unregister(pchip->rdev[icnt]);
>   
>   err_regulator:
> -	dev_err(&client->dev, "fail to initialize regulators\n");
>   	/* output disable */
>   	for (icnt = 0; icnt < 0x06; icnt++)
>   		lp8755_write(pchip, icnt, 0x00);
>   
> -err_chip_init:
> -	dev_err(&client->dev, "fail to initialize chip\n");
>   	return ret;
>   }
>   
It is nice to us also and this patch was tested using a lp8755 board.
Thank you Axel.

