Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421AbaHWOAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:00:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59413 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaHWOAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:00:46 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53F89E8C.3070200@roeck-us.net>
Date: Sat, 23 Aug 2014 07:00:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: atull <atull@opensource.altera.com>, Mark Brown <broonie@kernel.org>
CC: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 1/2] pmbus: add regulator support
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com> <1408741894-24879-2-git-send-email-atull@opensource.altera.com> <20140822214417.GC24407@sirena.org.uk> <alpine.DEB.2.10.1408221927370.2334@shineypoop>
In-Reply-To: <alpine.DEB.2.10.1408221927370.2334@shineypoop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 05:31 PM, atull wrote:
> On Fri, 22 Aug 2014, Mark Brown wrote:
>
>> On Fri, Aug 22, 2014 at 04:11:33PM -0500, atull@opensource.altera.com wrote:
>>
>>> +	if (pdata && pdata->reg_init_data) {
>>> +		config.init_data = pdata->reg_init_data;
>>> +	} else {
>>> +		config.init_data = of_get_regulator_init_data(dev, np);
>>> +		if (!config.init_data)
>>> +			return -ENOMEM;
>>> +	}
>>
>> It should be fine to start with no init data - just let the regulator
>> core worry about it.  This will allow users to read back the state even
>> if they can't change anything which is useful for system bringup or
>> general debugging.
>>
>
> of_get_regulator_init_data() will only have an error if it cannot alloc
> the regulator_init_data struct.  That's why I did -ENOMEM.  If there
> is no platform data and nothing about the regulator in the device tree, we
> should end up with a zeroed out regulator_init_data.
>
Yes, but if OF is not defined it will return NULL as well. Unless I am
missing something, that means that the code will now fail if there is
no platform init data and OF is not configured.

Guenter

