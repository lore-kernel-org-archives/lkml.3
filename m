Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbaFZLNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:13:13 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33010 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaFZLNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:13:12 -0400
Message-ID: <53AC003E.2010608@collabora.co.uk>
Date: Thu, 26 Jun 2014 13:13:02 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/14] mfd: Add driver for Maxim 77802 Power Management
 IC
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk> <1403723019-6212-8-git-send-email-javier.martinez@collabora.co.uk> <1403775093.27156.13.camel@AMDC1943>
In-Reply-To: <1403775093.27156.13.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

Thanks a lot for your feedback.

On 06/26/2014 11:31 AM, Krzysztof Kozlowski wrote:
> Hi,
> 
> Just a few nit-picks below but overall everything looks fine:
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> 

>> +
>> +static int max77802_i2c_probe(struct i2c_client *i2c,
>> +			      const struct i2c_device_id *id)
>> +{
>> +	struct max77802_dev *max77802 = NULL;
>> +	struct max77802_platform_data *pdata = dev_get_platdata(&i2c->dev);
>> +	unsigned int data;
>> +	int ret = 0;
>> +
>> +	if (i2c->dev.of_node)
>> +		pdata = max77802_i2c_parse_dt_pdata(&i2c->dev);
>> +
>> +	if (!pdata) {
>> +		dev_err(&i2c->dev, "No platform data found.\n");
>> +		return -EIO;
>> +	}
>> +
>> +	max77802 = devm_kzalloc(&i2c->dev, sizeof(struct max77802_dev),
>> +				GFP_KERNEL);
>> +	if (max77802 == NULL)
> 
> It is inconsistent. Before you used "(!pd)" and "(!pdata)" so maybe
> stick to one format?
>

Right, I'll change to "(!max77802)" as well to be consistent.

>> +
>> +#ifdef CONFIG_PM_SLEEP
>> +static int max77802_suspend(struct device *dev)
>> +{
>> +	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>> +	struct max77802_dev *max77802 = i2c_get_clientdata(i2c);
>> +
>> +	if (device_may_wakeup(dev))
>> +		enable_irq_wake(max77802->irq);
>> +
>> +	disable_irq(max77802->irq);
> 
> Can you add short comment why this is needed? I know why but just for
> future generations which will wonder: "why do we need to disable the IRQ
> while suspending?" :). Especially that this is rather a workaround for
> issue in other driver (I2C bus).
>

Good idea, I'll add a comment here on next version so code archaeologists can
figure out what what's going on here.

>> +
>> +#define MAX77802_IRQSRC_PMIC            (0)
> 
> Shouldn't it be BIT(0) or BIT(1)? It looks odd.
> 
>> +#define MAX77802_IRQSRC_RTC	        BIT(0)
> 
> Anyway, are these defines used anywhere? Seems not. 
> 

Yes, these defines were used in the max77802-irq.c so is a left over from the
regmap IRQ chip refactoring. I'll remove these and also the ones from max77686
driver.

> Best regards,
> Krzysztof
> 
> 

Best regards
Javier
