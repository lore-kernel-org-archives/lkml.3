Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaIROUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:20:11 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42315 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbaIROUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:20:09 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: fan53555: Fix null pointer dereference
Date: Thu, 18 Sep 2014 16:22:30 +0200
Message-ID: <6627306.hr5KNyAzfJ@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1411048178.18649.2.camel@phoenix>
References: <1411048128.18649.1.camel@phoenix> <1411048178.18649.2.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 18. September 2014, 21:49:38 schrieb Axel Lin:
> Set di->regulator before dereference it.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

damn ... thanks for catching this :-)

Reviewed-by: Heiko Stuebner <heiko@sntech.de>


> ---
>  drivers/regulator/fan53555.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
> index 70b31bf..c82fb9e 100644
> --- a/drivers/regulator/fan53555.c
> +++ b/drivers/regulator/fan53555.c
> @@ -361,6 +361,7 @@ static int fan53555_regulator_probe(struct i2c_client
> *client, if (!di)
>  		return -ENOMEM;
> 
> +	di->regulator = pdata->regulator;
>  	if (client->dev.of_node) {
>  		const struct of_device_id *match;
> 
> @@ -389,7 +390,6 @@ static int fan53555_regulator_probe(struct i2c_client
> *client, return PTR_ERR(di->regmap);
>  	}
>  	di->dev = &client->dev;
> -	di->regulator = pdata->regulator;
>  	i2c_set_clientdata(client, di);
>  	/* Get chip ID */
>  	ret = regmap_read(di->regmap, FAN53555_ID1, &val);

