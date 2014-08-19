Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaHSUNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:13:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60744 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaHSUNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:13:37 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6] input: drv260x: Add TI drv260x haptics driver
Thread-Topic: [PATCH v6] input: drv260x: Add TI drv260x haptics driver
Thread-Index: AQHPuKBG/Qme4vynlkWiIpuXx8CBGw==
Date: Tue, 19 Aug 2014 20:13:32 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DEC3E6@DFLE09.ent.ti.com>
References: <1408117670-19750-1-git-send-email-dmurphy@ti.com>
 <20140819192401.GA32080@core.coreip.homeip.net>
 <00FC9A978A94B7418C33AFAE8A35ED49DEC1EF@DFLE09.ent.ti.com>
 <20140819200748.GB3626@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 03:07 PM, Dmitry Torokhov wrote:
> On Tue, Aug 19, 2014 at 07:35:06PM +0000, Murphy, Dan wrote:
>> Dmitry
>>
>> On 08/19/2014 02:24 PM, Dmitry Torokhov wrote:
>>> Hi Dan,
>>>
>>> On Fri, Aug 15, 2014 at 10:47:50AM -0500, Dan Murphy wrote:
>>>> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
>>>> index 2ff4425..99f6762 100644
>>>> --- a/drivers/input/misc/Kconfig
>>>> +++ b/drivers/input/misc/Kconfig
>>>> @@ -676,4 +676,13 @@ config INPUT_SOC_BUTTON_ARRAY
>>>>  	  To compile this driver as a module, choose M here: the
>>>>  	  module will be called soc_button_array.
>>>>  
>>>> +config INPUT_DRV260X_HAPTICS
>>>> +	tristate "TI DRV260X haptics support"
>>>> +	depends on INPUT && I2C
>>>
>>> This also needs "select REGMAP_I2C"
>>>
>>
>> This one is OK
>>
>>>> +	help
>>>> +	  Say Y to enable support for the TI DRV260X haptics driver.
>>>> +
>>>> +	  To compile this driver as a module, choose M here: the
>>>> +	  module will be called drv260x-haptics.
>>>> +
>>>
>>> [...]
>>>
>>>> +#ifndef _LINUX_DRV260X_PDATA_H
>>>> +#define _LINUX_DRV260X_PDATA_H
>>>> +
>>>> +struct drv260x_platform_data {
>>>> +	int enable_gpio;
>>>
>>> I do not see this used anywhere.
>>
>> But this is actually used here
>>
>> haptics->enable_gpio = devm_gpiod_get(&client->dev, "enable");
>>
>> for the non-dt case
> 
> "haptics" is not instance of drv260x_platform_data but drv260x_data which
> defines:
> 
> struct drv260x_data {
> 	...
> 	struct gpio_desc *enable_gpio;
> 	...
> 
> That one I kept.
> 

Yes that is correct but the enable_gpio for non-dt enabled devices this enable_gpio
needs to come from the platform data structure.  Without the enable gpio in the platform data
structure there is no way for non-dt enabled devices to set the gpio value.

The haptics instance just stores the gpio descriptor returned from this call.

The devm_gpiod looks at the platform data is CONFIG_OF is not set.

Dan

-- 
------------------
Dan Murphy
