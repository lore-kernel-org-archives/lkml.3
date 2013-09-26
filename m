Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3IZMAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:00:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37602 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab3IZMAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:00:36 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-4f-524421e22ea9
Message-id: <524421DF.4010200@samsung.com>
Date: Thu, 26 Sep 2013 14:00:31 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: lee.jones@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] max77693: remove device wakeup from driver
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com>
 <1377104014-21910-2-git-send-email-a.hajda@samsung.com>
In-reply-to: <1377104014-21910-2-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xa7qPFF2CDCY+F7K4te4cq8X8I0Di
	wJ8djBZvejtYLDrPPmG2ONv0ht3i/tejjBaXd81hs1h6/SKTxYTpa1ksDq84wGSx7uV0IOtN
	O6vF6W5Wi1cH21gc+D3WzFvD6LHg8xV2j9eTJzB6vFo9k9XjzrU9bB7zTgZ69G1ZxejxeZOc
	x8a5oQGcUVw2Kak5mWWpRfp2CVwZ29sMC/aKVLR9/MrewLhBoIuRg0NCwETi+x+lLkZOIFNM
	4sK99WxdjFwcQgJLGSWW/+xlh3A+MUpM//qTHaSKV0BLoullGxuIzSKgKnHq5mEWEJtNQFPi
	7+abYHFRgQiJlUsesELUC0r8mHwPrEZEQF1i9sk7zCBDmQX2skgsvrwQbKiwgJvEg5/rwBqE
	BGolFhxezwxicwq4SMw6+JQRxGYW0JHY3zqNDcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWM
	oqmlyQXFSem5RnrFibnFpXnpesn5uZsYIXH1dQfj0mNWhxgFOBiVeHgvMDsHCbEmlhVX5h5i
	lOBgVhLhfSvrEiTEm5JYWZValB9fVJqTWnyIkYmDU6qB8VTXv8g1/90zdwiHpZz0+7jS8cKF
	pCaPRo4Mt/hNZn81zwj3az34lej6MHeLd7hC5I2zXx33aMdIVX+MinpdfzLBgvWbdlKU0rrq
	DZWc5xerVemtmvZt4gTeyv1hk+2Srq38v4zHNqgpTcn3FvManS0ZUYJeIREu56KTJ3+3WXBF
	5v+S3CBmJZbijERDLeai4kQASrvRUokCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 06:53 PM, Andrzej Hajda wrote:
> The patch removes wakeup related code from
> the driver and plaftorm data - it is already
> handled by i2c core using I2C_CLIENT_WAKE flag
> from struct i2c_board_info. As a result MFD
> itself do not requires platform data.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max77693.c               | 10 ----------
>  include/linux/mfd/max77693-private.h |  1 -
>  include/linux/mfd/max77693.h         |  2 --
>  3 files changed, 13 deletions(-)
>
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 9e60fed..27f5da3 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -110,15 +110,9 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  			      const struct i2c_device_id *id)
>  {
>  	struct max77693_dev *max77693;
> -	struct max77693_platform_data *pdata = i2c->dev.platform_data;
>  	u8 reg_data;
>  	int ret = 0;
>  
> -	if (!pdata) {
> -		dev_err(&i2c->dev, "No platform data found.\n");
> -		return -EINVAL;
> -	}
> -
>  	max77693 = devm_kzalloc(&i2c->dev,
>  			sizeof(struct max77693_dev), GFP_KERNEL);
>  	if (max77693 == NULL)
> @@ -138,8 +132,6 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  		return ret;
>  	}
>  
> -	max77693->wakeup = pdata->wakeup;
> -
>  	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_PMIC_ID2,
>  				&reg_data);
>  	if (ret < 0) {
> @@ -179,8 +171,6 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  	if (ret < 0)
>  		goto err_mfd;
>  
> -	device_init_wakeup(max77693->dev, pdata->wakeup);
> -
>  	return ret;
>  
>  err_mfd:
> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index 244fb0d..3e050b9 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -323,7 +323,6 @@ struct max77693_dev {
>  
>  	int irq;
>  	int irq_gpio;
> -	bool wakeup;
>  	struct mutex irqlock;
>  	int irq_masks_cur[MAX77693_IRQ_GROUP_NR];
>  	int irq_masks_cache[MAX77693_IRQ_GROUP_NR];
> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> index 676f0f3..3f3dc45 100644
> --- a/include/linux/mfd/max77693.h
> +++ b/include/linux/mfd/max77693.h
> @@ -64,8 +64,6 @@ struct max77693_muic_platform_data {
>  };
>  
>  struct max77693_platform_data {
> -	int wakeup;
> -
>  	/* regulator data */
>  	struct max77693_regulator_data *regulators;
>  	int num_regulators;

Ping.

Regards
Andrzej

