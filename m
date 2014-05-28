Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaE1NxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:53:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52695 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaE1NxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:53:13 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5385EA38.9090200@roeck-us.net>
Date: Wed, 28 May 2014 06:52:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andreas Werner <andreas.werner@men.de>, Lee Jones <lee.jones@linaro.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v2 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
References: <cover.1401181010.git.andreas.werner@men.de> <a3cd43562effd2580d0174c56eff5584791217ac.1401181010.git.andreas.werner@men.de> <20140527150547.GA4227@lee--X1> <20140528070222.GA24101@jtlinux> <20140528082404.GA10803@lee--X1> <20140528115159.GA2090@awelinux> <5385E4C9.2010204@roeck-us.net>
In-Reply-To: <5385E4C9.2010204@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 06:29 AM, Guenter Roeck wrote:
> On 05/28/2014 04:51 AM, Andreas Werner wrote:
>> aOn Wed, May 28, 2014 at 09:24:05AM +0100, Lee Jones wrote:
>>>>>> The MEN 14F021P00 Board Management Controller provides an
>>>>>> I2C interface to the host to access the feature implemented in the BMC.
>>>>>> The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
>>>>>> and on a few Box/Display Computer.
>>>>>>
>>>>>> Added MFD Core driver, supporting the I2C communication to the device.
>>>>>>
>>>>>> The MFD driver currently supports the following features:
>>>>>>     - Watchdog
>>>>>>     - LEDs
>>>>>>
>>>>>> Signed-off-by: Andreas Werner <andreas.werner@men.de>
>>>>>> ---
>>>>>>   drivers/mfd/Kconfig           |  12 +++
>>>>>>   drivers/mfd/Makefile          |   1 +
>>>>>>   drivers/mfd/menf21bmc.c       | 220 ++++++++++++++++++++++++++++++++++++++++++
>>>>>>   include/linux/mfd/menf21bmc.h |  31 ++++++
>>>>>>   4 files changed, 264 insertions(+)
>>>>>>   create mode 100644 drivers/mfd/menf21bmc.c
>>>>>>   create mode 100644 include/linux/mfd/menf21bmc.h
>>>
>>> [...]
>>>
>>>>>> +static int menf21bmc_write_byte(struct i2c_client *client, u8 val)
>>>>>> +{
>>>>>> +    int ret;
>>>>>> +    struct menf21bmc *data = i2c_get_clientdata(client);
>>>>>> +
>>>>>> +    mutex_lock(&data->lock);
>>>>>> +    ret = i2c_smbus_write_byte(client, val);
>>>>>> +    mutex_unlock(&data->lock);
>>>>>> +
>>>>>> +    return ret;
>>>>>> +}
>>>>>
>>>>> Didn't we ask you to remove these?  Just make the i2c_smbus_* calls
>>>>> from within the driver.  The I2C subsystem conducts its own locking.
>>>>> I'm really starting to frown on aggregation for the sake of
>>>>> aggregation.  It's just overhead.
>>>>>
>>>>
>>>> Correct me if I'm wrong but as far as I remember Guenther asked to retain the
>>>> original API, not the remove the "abstraction layer". Once we build a board with
>>>> one of these BMCs attached via e.g. SPI we would have to reintroduce it anyways,
>>>> in order to re-use these drivers.
>>>
>>> If there are two or more possible interfaces then I agree, these
>>> aggregations would be the best approach.  However, as it stands, that's
>>> not currently the case.
>>>
>>> Genuine question; are Men on the verge of building such a board, or
>>> are we talking about 'ifs' and 'maybes'?
>>>
>>
>> I think it was a missunderstanding. I also thought that i just
>> have to adapt the wrapper to the original API, that is what I did in the patch,
>> and not to delete the functions completly.
>>
>> Anayway, we currently have another project which use a STM32 MCR connected to USB.
>> A nice feature of this STM is to update the firmware using the USB interface.
>> This is easy to implement and fast.
>>
>> We want to use such a functionality in all of our MCRs to easily update the firmware
>> at the customer if we found a bug.
>>
>> We also plan to have a BMC connected to USB. Then we have i2c and USB.
>>
>
> Even more likely that you would have to change the API in that case to be less
> I2C centric.
>

... especially since you have "struct i2c_client *client" in your API function.

Guenter


