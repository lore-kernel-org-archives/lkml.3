Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaE1N2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:28:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50959 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaE1N2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:28:08 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5385E458.3040601@roeck-us.net>
Date: Wed, 28 May 2014 06:27:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Lee Jones <lee.jones@linaro.org>
CC: Andreas Werner <andreas.werner@men.de>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org
Subject: Re: [PATCH v2 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
References: <cover.1401181010.git.andreas.werner@men.de> <a3cd43562effd2580d0174c56eff5584791217ac.1401181010.git.andreas.werner@men.de> <20140527150547.GA4227@lee--X1> <20140528070222.GA24101@jtlinux>
In-Reply-To: <20140528070222.GA24101@jtlinux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 12:02 AM, Johannes Thumshirn wrote:
[ ... ]

>>> +
>>> +static int menf21bmc_write_byte(struct i2c_client *client, u8 val)
>>> +{
>>> +	int ret;
>>> +	struct menf21bmc *data = i2c_get_clientdata(client);
>>> +
>>> +	mutex_lock(&data->lock);
>>> +	ret = i2c_smbus_write_byte(client, val);
>>> +	mutex_unlock(&data->lock);
>>> +
>>> +	return ret;
>>> +}
>>
>> Didn't we ask you to remove these?  Just make the i2c_smbus_* calls
>> from within the driver.  The I2C subsystem conducts its own locking.
>> I'm really starting to frown on aggregation for the sake of
>> aggregation.  It's just overhead.
>>
>
> Correct me if I'm wrong but as far as I remember Guenther asked to retain the
> original API, not the remove the "abstraction layer". Once we build a board with
> one of these BMCs attached via e.g. SPI we would have to reintroduce it anyways,
> in order to re-use these drivers.
>

If you introduce boards with SPI support, you'll likely have to change those APIs,
since some of the functions don't make sense in the SPI world. So I tend to agree
with Lee. If you need those APIs later on you can introduce them at that time,
and introduce them such that they truly work for all hardware variants.

Guenter

