Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaGDKyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:54:10 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17067 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaGDKyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:54:07 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-ad-53b687cc11e1
Content-transfer-encoding: 8BIT
Message-id: <1404471245.14069.1.camel@AMDC1943>
Subject: Re: [PATCH v6 06/23] mfd: max77686: Make error checking consistent
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2014 12:54:05 +0200
In-reply-to: <1404467722-26687-7-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
 <1404467722-26687-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Nd0z7duCDfa3KVgsuXiV3aJ5U7HF
	1IdP2CzmHznHanF22UE2i6O/Cyx6F1xls7j/9SijxbcrHUwWmx5fY7W4vGsOm8WM8/uYLJ5O
	uMhmcer6ZzaLvrWX2Cw2TN7NbjH3dyOrg6DH7IaLLB5/n19n8dhxdwmjx85Zd9k9Nq3qZPO4
	c20Pm8fmJfUeV040sXr0bVnF6LH5dLXH9Hk/mTw+b5IL4InisklJzcksSy3St0vgyri6eRZ7
	wXP+isV3X7M0MO7n6WLk5JAQMJE4umALE4QtJnHh3nq2LkYuDiGBpYwSnb+aWEESvAKCEj8m
	32PpYuTgYBaQlzhyKRskzCygLjFp3iJmiPrPjBKXpi9mhKjXl1i0chsziC0s4C2x8fQDsAVs
	AsYSm5cvYQOxRQTsJG6sfgjWzCxwi0Xi1/JNYMtYBFQlVl7ezAJicwoESMxYfgWsQUhgKqPE
	s1+eEJcqS8zbf4xpAqPALCT3zUK4bxaS+xYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93E
	CInDLzsYFx+zOsQowMGoxMPbuGJDsBBrYllxZe4hRgkOZiUR3t/124KFeFMSK6tSi/Lji0pz
	UosPMTJxcEo1MLJH7p3q7bnfJWf7ic1NnCU8k7lidUVkNjBtDGhqb90jVL/8o628X4pZtYL9
	/hk126e0FfJH3l2x57Tw+ft/4jN8zCt/8sedFvj+SXDB5Fwt90Xu/imWR1MOf9eZePBFgLjd
	R+P2yQyPNyl1FN+3WZ2W56pewfMpVFp8w+fvulbN+/s6P66boMRSnJFoqMVcVJwIAJLMQp+h	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-07-04 at 11:55 +0200, Javier Martinez Canillas wrote:
> Error checking across the driver is mostly consistent besides
> a few exceptions, so change these exceptions for consistency.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/mfd/max77686.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index ada4976..87fe52e 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -134,7 +134,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  
>  	max77686 = devm_kzalloc(&i2c->dev,
>  				sizeof(struct max77686_dev), GFP_KERNEL);
> -	if (max77686 == NULL)
> +	if (!max77686)
>  		return -ENOMEM;
>  
>  	i2c_set_clientdata(i2c, max77686);
> @@ -153,8 +153,8 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  		return ret;
>  	}
>  
> -	if (regmap_read(max77686->regmap,
> -			 MAX77686_REG_DEVICE_ID, &data) < 0) {
> +	ret = regmap_read(max77686->regmap, MAX77686_REG_DEVICE_ID, &data);
> +	if (ret < 0) {
>  		dev_err(max77686->dev,
>  			"device not found on this channel (this is not an error)\n");
>  		return -ENODEV;
> @@ -180,7 +180,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
>  				  IRQF_SHARED, 0, &max77686_irq_chip,
>  				  &max77686->irq_data);
> -	if (ret != 0) {
> +	if (ret) {
>  		dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
>  		goto err_unregister_i2c;
>  	}
> @@ -188,7 +188,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
>  				  IRQF_SHARED, 0, &max77686_rtc_irq_chip,
>  				  &max77686->rtc_irq_data);
> -	if (ret != 0) {
> +	if (ret) {
>  		dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n", ret);
>  		goto err_del_irqc;
>  	}

