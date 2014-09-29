Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaI2Otd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:49:33 -0400
Received: from smtp-out-058.synserver.de ([212.40.185.58]:1140 "EHLO
	smtp-out-058.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbaI2Ota (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:49:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1417
Message-ID: <54297186.1070801@metafoo.de>
Date: Mon, 29 Sep 2014 16:49:42 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] ASoC: ssm2602: add device tree bindings
References: <1411891072-22637-1-git-send-email-stefan.kristiansson@saunalahti.fi> <54291D50.30002@metafoo.de> <20140929143452.GA11763@chokladfabriken.org>
In-Reply-To: <20140929143452.GA11763@chokladfabriken.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 04:34 PM, Stefan Kristiansson wrote:
> On Mon, Sep 29, 2014 at 10:50:24AM +0200, Lars-Peter Clausen wrote:
>> On 09/28/2014 09:57 AM, Stefan Kristiansson wrote:
>>> Allow the ssm2602/ssm2603/ssm2604 codec driver to be
>>> instantiated from the device tree.
>>>
>>> Also, add Kconfig prompts to allow manual selection of both the
>>> I2C and SPI configuration versions of the driver.
>>>
>>> Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
>>
>> Looks mostly good, but you should Cc both the devicetree and the
>> ASoC maintainers.
>>
>
> Ok, I'll make sure to do that in v2.
>
>> [...]
>>> diff --git a/sound/soc/codecs/ssm2602-i2c.c b/sound/soc/codecs/ssm2602-i2c.c
>>> index abd63d5..0d9779d 100644
>>> --- a/sound/soc/codecs/ssm2602-i2c.c
>>> +++ b/sound/soc/codecs/ssm2602-i2c.c
>>> @@ -41,10 +41,19 @@ static const struct i2c_device_id ssm2602_i2c_id[] = {
>>>   };
>>>   MODULE_DEVICE_TABLE(i2c, ssm2602_i2c_id);
>>>
>>> +static const struct of_device_id ssm2602_of_match[] = {
>>> +	{ .compatible = "adi,ssm2602", },
>>> +	{ .compatible = "adi,ssm2603", },
>>> +	{ .compatible = "adi,ssm2604", },
>>
>> Since the driver is supposed to behave different depending on the
>> device you should set the driver data similar to like it is done in
>> the ssm2602_i2c_id table and add code in the probe function to
>> extract the driver data.
>>
>
> As far as I understand, that is already covered for, ssm2602_i2c_probe() get
> called with the i2c_device_id struct set according to the compatible string.
> I.e. if I set it to "adi,ssm2603" in the .dts, ssm2602_i2c_probe() is called
> with id->name = "ssm2603" and id->driver_data = 0 and if I set it to
> "adi,ssm2604" I get id->name = "ssm2603" and id->driver_data = 1.

Ok, looks like the I2C core extracts the string after the "," and than 
matches the I2C device id table against it.

>
> However, when looking into that, I noticed this in ssm2602_probe()
>
> 	 ssm2602->type = SSM2602;
>
> so the value from id->driver_data is never used.
> (it should be ssm2602->type = type;)

Yes, that's clearly a bug.

[...]
