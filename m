Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaCJBBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:01:37 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:24091 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752889AbaCJBBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:01:34 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Mar 2014 21:01:34 EDT
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: act8865: Remove unnecessary *rdev[] from
 struct act8865
Thread-Topic: [PATCH] regulator: act8865: Remove unnecessary *rdev[] from
 struct act8865
Thread-Index: AQHPOtEWFrxxlBN2EECleIIB7Cp+gJrZgBJQ
Date: Mon, 10 Mar 2014 00:56:21 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172FF93A6@penmbx01>
References: <1394284747.12881.4.camel@phoenix>
In-Reply-To: <1394284747.12881.4.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2A11jjU013630



> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@ingics.com]
> Sent: Saturday, March 08, 2014 9:19 PM
> To: Mark Brown
> Cc: Yang, Wenyou; Liam Girdwood; linux-kernel@vger.kernel.org
> Subject: [PATCH] regulator: act8865: Remove unnecessary *rdev[] from
> struct act8865
> 
> Now we are using devm_regulator_register(), so we don't need the *rdev[]
> array to store return value of devm_regulator_register. Use a *rdev
> variable is enough for checking return status.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Wenyou Yang <Wenyou.yang@atmel.com>
> ---
>  drivers/regulator/act8865-regulator.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/regulator/act8865-regulator.c
> b/drivers/regulator/act8865-regulator.c
> index a5ff30c..b92d7dd 100644
> --- a/drivers/regulator/act8865-regulator.c
> +++ b/drivers/regulator/act8865-regulator.c
> @@ -62,7 +62,6 @@
>  #define	ACT8865_VOLTAGE_NUM	64
> 
>  struct act8865 {
> -	struct regulator_dev *rdev[ACT8865_REG_NUM];
>  	struct regmap *regmap;
>  };
> 
> @@ -256,7 +255,7 @@ static inline int act8865_pdata_from_dt(struct
> device *dev,  static int act8865_pmic_probe(struct i2c_client *client,
>  			   const struct i2c_device_id *i2c_id)  {
> -	struct regulator_dev **rdev;
> +	struct regulator_dev *rdev;
>  	struct device *dev = &client->dev;
>  	struct act8865_platform_data *pdata = dev_get_platdata(dev);
>  	struct regulator_config config = { };
> @@ -290,8 +289,6 @@ static int act8865_pmic_probe(struct i2c_client
> *client,
>  	if (!act8865)
>  		return -ENOMEM;
> 
> -	rdev = act8865->rdev;
> -
>  	act8865->regmap = devm_regmap_init_i2c(client,
> &act8865_regmap_config);
>  	if (IS_ERR(act8865->regmap)) {
>  		error = PTR_ERR(act8865->regmap);
> @@ -311,12 +308,12 @@ static int act8865_pmic_probe(struct i2c_client
> *client,
>  		config.driver_data = act8865;
>  		config.regmap = act8865->regmap;
> 
> -		rdev[i] = devm_regulator_register(&client->dev,
> -						&act8865_reg[i], &config);
> -		if (IS_ERR(rdev[i])) {
> +		rdev = devm_regulator_register(&client->dev, &act8865_reg[i],
> +					       &config);
> +		if (IS_ERR(rdev)) {
>  			dev_err(dev, "failed to register %s\n",
>  				act8865_reg[id].name);
> -			return PTR_ERR(rdev[i]);
> +			return PTR_ERR(rdev);
>  		}
>  	}
> 
> --
> 1.8.1.2
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
