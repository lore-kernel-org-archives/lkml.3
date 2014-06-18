Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbaFRFIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:08:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59099 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbaFRFIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:08:12 -0400
Message-ID: <53A11E66.9040201@ti.com>
Date: Wed, 18 Jun 2014 10:36:46 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
Subject: Re: [PATCH 4/9] mfd: palmas: Add tps65917 support
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com> <1401272423-25761-5-git-send-email-j-keerthy@ti.com> <20140617161940.GO29841@lee--X1>
In-Reply-To: <20140617161940.GO29841@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2014 09:49 PM, Lee Jones wrote:
>> Add tps65917 PMIC support. tps65917 is a subset of palmas PMIC.
>> Some of the register definitions and the interrupt mappings
>> are different.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>>   drivers/mfd/palmas.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 171 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
>> index d280d78..485d755 100644
>> --- a/drivers/mfd/palmas.c
>> +++ b/drivers/mfd/palmas.c
> [...]
>
>> +struct palmas_driver_data {
>> +	unsigned int *features;
>> +	struct regmap_irq_chip *irq_chip;
>> +};
>> +
>> +static struct palmas_driver_data palmas_data = {
>> +	.features = &palmas_features,
>> +	.irq_chip = &palmas_irq_chip,
>> +};
>> +
>> +static struct palmas_driver_data tps659038_data = {
>> +	.features = &tps659038_features,
>> +	.irq_chip = &palmas_irq_chip,
>> +};
>> +
>> +static struct palmas_driver_data tps65917_data = {
>> +	.features = &tps659038_features,
>> +	.irq_chip = &tps65917_irq_chip,
>> +};
>> +
> [...]
>
>> @@ -375,6 +539,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>>   {
>>   	struct palmas *palmas;
>>   	struct palmas_platform_data *pdata;
>> +	struct palmas_driver_data *driver_data;
>>   	struct device_node *node = i2c->dev.of_node;
>>   	int ret = 0, i;
>>   	unsigned int reg, addr, *features;
>> @@ -408,7 +573,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>>   	if (!match)
>>   		return -ENODATA;
>>   
>> -	features = (unsigned int *)match->data;
>> +	driver_data = (struct palmas_driver_data *)match->data;
>> +	features = (unsigned int *)driver_data->features;
>>   	palmas->features = *features;
> Couple of things a) I don't think the cast is required here and b) you
> may as well do away with the local features variable here.
>
> Just do:
>    palmas->features = *driver_data->features;
>
> Once fixed, re-submit with my:
>    Acked-by: Lee Jones <lee.jones@linaro.org>

Sure. I will redo and send this set.
Thanks.

>

