Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaJALkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:40:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50378 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaJALj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:39:59 -0400
Message-ID: <542BE804.5010007@ti.com>
Date: Wed, 1 Oct 2014 06:39:48 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, <broonie@kernel.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] regmap: Allow read_reg_mask to be 0
References: <1412093220-24690-1-git-send-email-dmurphy@ti.com> <542B1ABE.5000900@metafoo.de> <542B1E38.4020702@ti.com> <542B20BE.3060200@metafoo.de>
In-Reply-To: <542B20BE.3060200@metafoo.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars

On 09/30/2014 04:29 PM, Lars-Peter Clausen wrote:
> On 09/30/2014 11:18 PM, Dan Murphy wrote:
>> Lars
>>
>> On 09/30/2014 04:03 PM, Lars-Peter Clausen wrote:
>>> On 09/30/2014 06:07 PM, Dan Murphy wrote:
>>>> There may be spi devices that do not require a
>>>> register read mask to read the registers.
>>>>
>>>> Currently the code sets the read mask based on
>>>> a non-zero value passed in from the driver or if that
>>>> value is 0 sets the read mask to 0x80.
>>>
>>> It only sets it to the bus default if both read_flag_mask and write_flag_mask are 0. The assumption is that both of them being zero is a invalid configuration and either of them (or both) have to be non-zero for proper operation, since otherwise the device can't tell the difference between a read and a write.
>>>
>>> Do you have a device where both the read and the write mask is 0?
>>>
>>> - Lars
>>
>> Yes I do have a device that the read/write mask are both 0.
>>
>> The device, which is already in production, has a specific control register that sets either the reading or writing of the rest of the registers.
>>
>> Here is the data sheet
>>
>> http://www.ti.com/lit/ds/symlink/afe4403.pdf
>>
>> See page 61 control0.
>>
>> Driver is written for this part just want to get this lead patch in or maybe an alternate solution.
>
> Looking at this the generic SPI regmap implementation might not necessarily be the best thing to use here and you are probably better of implementing either your own regmap bus or reg_read/reg_write callbacks that automatically set/clear the SPI_READ bit in the control register depending on the operation.
>
> - Lars

I am not sure implementing a different SPI regmap implementation is really the best thing.
I am handling this control bit toggling in the peripheral driver.
The device only needs to be written at init and then during calibration.  Other then that it is read read read.

Dan

-- 
------------------
Dan Murphy

