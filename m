Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3LCKHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:07:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43735 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab3LCKHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:07:12 -0500
Message-ID: <529DAD2B.4040909@ti.com>
Date: Tue, 3 Dec 2013 15:36:35 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Keerthy <j-keerthy@ti.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <sameo@linux.intel.com>, <grant.likely@linaro.org>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] MFD: TPS65218: Add driver for the TPS65218 PMIC
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com> <1386053006-6480-3-git-send-email-j-keerthy@ti.com> <20131203092410.GD11828@lee--X1>
In-Reply-To: <20131203092410.GD11828@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 December 2013 02:54 PM, Lee Jones wrote:
>> The TPS65218 chip is a power management IC for Portable Navigation Systems
>> and Tablet Computing devices. It contains the following components:
>>
>>   - Regulators.
>>   - Over Temperature warning and Shut down.
>>
>> This patch adds support for tps65218 mfd device. At this time only
>> the regulator functionality is made available.
>>
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> ---
>>   drivers/mfd/Kconfig          |   14 ++
>>   drivers/mfd/Makefile         |    1 +
>>   drivers/mfd/tps65218.c       |  281 +++++++++++++++++++++++++++++++++++++++++
>>   include/linux/mfd/tps65218.h |  288 ++++++++++++++++++++++++++++++++++++++++++
> <snip>
>
>> +config MFD_TPS65218
>> +	tristate "TI TPS65218 Power Management chips"
>> +	depends on I2C
>> +	select MFD_CORE
>> +	select REGMAP_I2C
>> +	help
>> +	  If you say yes here you get support for the TPS65218 series of
>> +	  Power Management chips.
>> +	  These include voltage regulators, gpio and other features
>> +	  that are often used in portable devices.
> Perhaps you should add a note that only the regulator component is
> currently supported.
Ok. I will add it.

> <snip>
>
>> new file mode 100644
>> index 0000000..8c61640
>> --- /dev/null
>> +++ b/drivers/mfd/tps65218.c
>> @@ -0,0 +1,281 @@
>> +/*
>> + * TPS65218 chip family multi-function driver
> Instead of calling it an MFD driver (is there such a thing?) I think
> you should mention its true purpose, as per the datasheet.

Ok.

>
> <snip>
>
>> +static const struct of_device_id of_tps65218_match_table[] = {
>> +	{ .compatible = "ti,tps65218", },
>> +	{ /* end */ }
> I think the end comment is superfluous.
>
> However, if you _really_ want to put something in there, I dislike
> "/* Sentinel */" the least.

I will remove it.
>
>> +static int tps65218_probe(struct i2c_client *client,
>> +				const struct i2c_device_id *ids)
>> +{
> <snip>
>
>> +	ret = of_platform_populate(client->dev.of_node, NULL, NULL,
>> +				   &client->dev);
> What are you trying to do here?
>
> Register each regulator as a platform device?

Yeah. The probe will be called for every regulator separately.

> <snip>
>
>> +static const struct i2c_device_id tps65218_id_table[] = {
>> +	{"tps65218", TPS65218},
>> +};
> This has a different structure to of_tps65218_match_table, please
> ensure they're the same. I prefer spaces after '{' and before '}'.

Ok. I will add a space after '{' and before '}'. Sorry I did not
follow tps65218_id_table being different than of_tps65218_match_table.

One is of the type of_device_id and the other i2c_device_id.
>
> <snip>
>

