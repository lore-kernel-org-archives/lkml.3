Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab3E3PnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 11:43:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60683 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab3E3Pm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:42:58 -0400
Message-ID: <51A7737A.5000902@ti.com>
Date: Thu, 30 May 2013 18:42:50 +0300
From: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] i2c: omap: correct usage of the interrupt enable
 register
References: <1369812944-685-1-git-send-email-oleksandr.dmytryshyn@ti.com> <1369812944-685-2-git-send-email-oleksandr.dmytryshyn@ti.com> <878v2x7lak.fsf@linaro.org> <51A71375.9030100@ti.com> <87obbsa6vh.fsf@linaro.org>
In-Reply-To: <87obbsa6vh.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 05:18 PM, Kevin Hilman wrote:
> Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com> writes:
>
>> On 05/29/2013 08:22 PM, Kevin Hilman wrote:
>>> Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com> writes:
>>>
>>>> Starting from the OMAP chips with version2 registers scheme there are
>>>> 2 registers (I2C_IRQENABLE_SET and I2C_IRQENABLE_CLR) to manage
>>>> interrupts instead of the older OMAP chips with old scheme which have
>>>> only one register (I2C_IE).  Now we should use I2C_IRQENABLE_SET
>>>> register for enabling interrupts and I2C_IRQENABLE_CLR register for
>>>> disabling interrupts.
>>> Why?  (changelogs should always answer the "why" question)
>>>
>>> IOW, what is broken without this change, how does it fail?  And equally
>>> important, how is it currently working?
>>>
>>> Kevin
>>>
>>>
>> Hi, Kevin.
>>
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
>> I2C_IRQENABLE_SET register is located at this address ). This register
>> is used to enable interrupts. For disabling interrupts
>> I2C_IRQENABLE_CLR register should be used.
>>
>> I've checked that interrupts in the i2c controller are still enabled
>> after writting 0 to the I2C_IE register. But with my patch interrupts
>> are disabled in the omap_i2c_runtime_suspend() function.
> Yes, I understand why your patch works, and it looks correct to me.
>
> My main concern is that the changelog is missing a detailed description
> of the problem that is being solved, as well as a summary of why this
> has ever worked.  I guess we've just been lucky and not seen interrupts
> during suspend?
>
> Kevin
Hi, Kevin.

Yes. You are right about the interrupts.

-- 

Best regards,
Oleksandr Dmytryshyn | OMAP4 Platform
GlobalLogic Inc. | Innovation by Design
