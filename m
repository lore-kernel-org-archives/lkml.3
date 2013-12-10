Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3LJCXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:23:05 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:49136 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787Ab3LJCXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:23:01 -0500
Message-ID: <52A67A71.6020404@atmel.com>
Date: Tue, 10 Dec 2013 10:20:33 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, <plagnioj@jcrosoft.com>
CC: <linux-pwm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 1/2] PWM: atmel-pwm: add PWM controller driver
References: <1384766002-2852-1-git-send-email-voice.shen@atmel.com> <20131202105957.GD18060@ulmo.nvidia.com> <529D4B58.9020700@atmel.com>
In-Reply-To: <529D4B58.9020700@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 12/03/2013 11:09 AM, Bo Shen wrote:
>>> +        atmel_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
>>> +        atmel_pwm->chip.of_pwm_n_cells = 3;
>>> +        atmel_pwm->chip.base = -1;
>>> +    } else {
>>> +        atmel_pwm->chip.base = pdev->id;
>>
>> That's not correct. The chip cannot be tied to pdev->id, because that ID
>> is the instance number of the device. So typically you would have
>> devices name like this:
>>
>>     atmel-pwm.0
>>     atmel-pwm.1
>>     ...
>>
>> Now, if you have that, then you won't be able to register the second
>> instance because the first instance will already have requested PWMs
>> 0-3, and setting .base to 1 will cause PWMs 1-4 to be requested, which
>> intersects with the range of the first instance.
>>
>> The same applies of course if you have other PWM controllers in the
>> system which have similar instance names.
>>
>> So the right thing to do here is to provide that number via platform
>> data so that platform code can define it, knowing in advance all ranges
>> for all other PWM controllers and thereby make sure there's no
>> intersection.
>
> OK, I will fix this.

After read deeply of PWM framework, for non device tree, I think we'd 
better let the PWM core to choose chip.base as device tree, while not 
pass a number through platform data to it. Or else, it will confuse the 
user to set the chip.base, must set it in correct value to avoid 
intersection. And, actually we won't use chip.base in driver itself.

Hi J,
   what's your opinion?

Best Regards,
Bo Shen

