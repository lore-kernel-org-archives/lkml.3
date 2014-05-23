Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaEWLA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:00:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54726 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaEWLA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:00:56 -0400
Message-ID: <537F2A15.9060901@ti.com>
Date: Fri, 23 May 2014 16:29:33 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>, <sameo@linux.intel.com>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@linaro.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] mfd: tps65917: Add driver for the TPS65917 PMIC
References: <1400731239-3180-1-git-send-email-j-keerthy@ti.com> <1400731239-3180-4-git-send-email-j-keerthy@ti.com> <20140522083707.GM6679@lee--X1> <537DD836.3040501@ti.com> <20140522114808.GU6679@lee--X1> <537EBEE4.9050309@ti.com> <20140523100634.GP19747@lee--X1>
In-Reply-To: <20140523100634.GP19747@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014 03:36 PM, Lee Jones wrote:
>>>>>> The TPS65917 chip is a power management IC for Portable Navigation Systems
>>>>>> and Tablet Computing devices. It contains the following components:
>>>>>>
>>>>>>   - Regulators.
>>>>>>   - Over Temperature warning and Shut down.
>>>>>>
>>>>>> This patch adds support for tps65917 mfd device. At this time only
>>>>>> the regulator functionality is made available.
>>>>>>
>>>>>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>>>>>> ---
>>>>>> v3 Changes:
>>>>>>
>>>>>>   * Header file formating
>>>>>>   * Changed the cache_type to REGCACHE_RBTREE
>>>>>>   * removed unnecessary code
>>>>>>   * Corrected documentation style
>>>>>>   * Added pm_power_off function
>>>>>>
>>>>>>   v2 Changes:
>>>>>>
>>>>>>   * Added volatile register check as some of the registers
>>>>>>     in the set are volatile.
>>>>>> drivers/mfd/Kconfig          |   12 +
>>>>>>   drivers/mfd/Makefile         |    1 +
>>>>>>   drivers/mfd/tps65917.c       |  594 +++++++++++++++++
>>>>>>   include/linux/mfd/tps65917.h | 1485 ++++++++++++++++++++++++++++++++++++++++++
>>>>>>   4 files changed, 2092 insertions(+)
>>>>>>   create mode 100644 drivers/mfd/tps65917.c
>>>>>>   create mode 100644 include/linux/mfd/tps65917.h
> [...]
>
>>>>>> +		ret = regmap_read(tps65917->regmap[slave], addr, &reg);
>>>>>> +		if (ret)
>>>>>> +			goto err_irq;
>>>>>> +	}i
>>>>> What does the read do?  You're not doing anything with the value.
>>>> This pad1 and pad2 stuff is not needed. I will remove this.
>>> Then why is it in here?
>>>
>>> Did you copy this code from somewhere, if so, where?
>>>
>>> Okay, I just answered my own question.  There is so much common code
>>> in between this and palmas, there is no way I'm going to accept this
>>> driver.  Please merge it in with the palmas driver!
>>>
>> The chip is more like a subset of palmas with lot of register offset changes
>> and register bit field changes. Adding this would make it clumsy.
>> There could
>> be lot of checks. That is why i chose to write a new driver.
>>
>> Palmas driver already supports palmas variants and tps659038. Merging
>> this would mean more and more checks :-/.
> Then find an elegant way of representing the variants.  I'm not
> prepared to carry that much duplicated code in MFD.  It's already
> overladened and in need of an overhaul.  This will exacerbate the
> matter.
>

Okay. I am working on that.

Regards,
Keerthy
