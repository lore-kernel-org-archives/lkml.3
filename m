Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3EaITS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:19:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51477 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3EaITO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:19:14 -0400
Message-ID: <51A85CFC.2000904@ti.com>
Date: Fri, 31 May 2013 11:19:08 +0300
From: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] i2c: omap: correct usage of the interrupt enable
 register
References: <1369929379-19165-1-git-send-email-oleksandr.dmytryshyn@ti.com> <1369929379-19165-2-git-send-email-oleksandr.dmytryshyn@ti.com> <87vc604dr9.fsf@linaro.org>
In-Reply-To: <87vc604dr9.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 07:46 PM, Kevin Hilman wrote:
> Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com> writes:
>
>> If the i2c controller during suspend will generate an interrupt, it
>> can lead to unpredictable behaviour in the kernel.
>>
>> Based on the logic of the kernel code interrupts from i2c should be
>> prohibited during suspend. Kernel writes 0 to the I2C_IE register in
>> the omap_i2c_runtime_suspend() function. In the other side kernel
>> writes saved interrupt flags to the I2C_IE register in
>> omap_i2c_runtime_resume() function. I.e. interrupts should be disabled
>> during suspend.
>>
>> This works for chips with version1 registers scheme. Interrupts are
>> disabled during suspend. For chips with version2 scheme registers
>> writting 0 to the I2C_IE register does nothing (because now the
>> I2C_IRQENABLE_SET register is located at this address). This register
>> is used to enable interrupts. For disabling interrupts
>> I2C_IRQENABLE_CLR register should be used.
>>
>> Because the registers I2C_IRQENABLE_SET and I2C_IE have the same
>> addresses, the interrupt enabling procedure is unchanged.
>>
>> Signed-off-by: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
> Much better, but still doesn't explain how/why this has been working up
> until now.  Have we just been lucky?
Yes, this has been working up until now because we've just been lucky.
>
>> ---
>>   drivers/i2c/busses/i2c-omap.c | 15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
>> index e02f9e3..2419899 100644
>> --- a/drivers/i2c/busses/i2c-omap.c
>> +++ b/drivers/i2c/busses/i2c-omap.c
>> @@ -180,6 +180,8 @@ enum {
>>   #define I2C_OMAP_ERRATA_I207		(1 << 0)
>>   #define I2C_OMAP_ERRATA_I462		(1 << 1)
>>   
>> +#define OMAP_I2C_INTERRUPTS_MASK	0x6FFF
> To be more clear, this should probably have v2 in the name.
I'll rename this mask in the patch-set v3
>
> Kevin
>


-- 

Best regards,
Oleksandr Dmytryshyn | OMAP4 Platform
GlobalLogic Inc. | Innovation by Design
