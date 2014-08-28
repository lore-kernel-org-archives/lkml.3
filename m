Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaH1LtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:49:23 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61923 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaH1LtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:49:19 -0400
Message-ID: <53FF16BC.9050701@gmail.com>
Date: Thu, 28 Aug 2014 17:17:08 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH v2 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com> <d6c7de200c9447dbafa74ee76739da943a0b73b2.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <d6c7de200c9447dbafa74ee76739da943a0b73b2.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 04:18 PM, Adam Thomson wrote:

(...)

> +static int da9150_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct da9150 *da9150;
> +	int ret;
> +
> +	da9150 = devm_kzalloc(&client->dev, sizeof(struct da9150), GFP_KERNEL);
> +	if (da9150 == NULL)
> +		return -ENOMEM;

da9150 = devm_kzalloc(&client->dev, sizeof(*da9150), GFP_KERNEL);
if (!da9150)
	return -ENOMEM;

> +	da9150->dev = &client->dev;
> +	da9150->irq = client->irq;
> +	i2c_set_clientdata(client, da9150);
> +	dev_set_drvdata(da9150->dev, da9150);
> +
> +	da9150->regmap = devm_regmap_init_i2c(client, &da9150_regmap_config);
> +	if (IS_ERR(da9150->regmap)) {
> +		ret = PTR_ERR(da9150->regmap);
> +		dev_err(da9150->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	return da9150_device_init(da9150);
> +}
> +
> +static int da9150_remove(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	da9150_device_exit(da9150);
> +
> +	return 0;
> +}
> +
> +static void da9150_shutdown(struct i2c_client *client)
> +{
> +	struct da9150 *da9150 = i2c_get_clientdata(client);
> +
> +	da9150_device_shutdown(da9150);
> +}
> +
> +static const struct i2c_device_id da9150_i2c_id[] = {
> +	{ "da9150", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, da9150_i2c_id);
> +
> +static const struct of_device_id da9150_of_match[] = {
> +	{ .compatible = "dlg,da9150", },
> +	{ }
> +};
> +

missed MODULE_DEVICE_TABLE(of, ...)   ?

> +static struct i2c_driver da9150_driver = {
> +	.driver	= {
> +		.name	= "da9150",
> +		.owner	= THIS_MODULE,

No need to update this field...

> +		.of_match_table = of_match_ptr(da9150_of_match),
> +	},
> +	.probe		= da9150_probe,
> +	.remove		= da9150_remove,
> +	.shutdown	= da9150_shutdown,
> +	.id_table	= da9150_i2c_id,
> +};
> +
> +module_i2c_driver(da9150_driver);
> +
> +MODULE_DESCRIPTION("I2C Driver for DA9150");
> +MODULE_AUTHOR("Adam Thomson <Adam.Thomson.Opensource@diasemi.com");
> +MODULE_LICENSE("GPL");
>
-- 
Regards,
Varka Bhadram.

