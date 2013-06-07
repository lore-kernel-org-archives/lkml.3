Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3FGKOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:14:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53005 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab3FGKOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:14:14 -0400
Message-ID: <51B1B19E.1050200@ti.com>
Date: Fri, 7 Jun 2013 13:10:38 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] i2c: Let users disable "Probe an I2C bus for certain
 devices"
References: <1370367222-19353-1-git-send-email-grygorii.strashko@ti.com> <20130604174900.GA2992@katana> <51AF63C7.9070007@ti.com> <20130607090623.GC3428@katana>
In-Reply-To: <20130607090623.GC3428@katana>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,
On 06/07/2013 12:06 PM, Wolfram Sang wrote:
>> 3) Thinking about Mainline: To reach the same target - no I2C
>> detection - and taking
>> into account above assumption "No changes in default behavior"
>> the following will need to be done:
>> - change i2c-omap/i2c-gpio DT bindings and add parameter which will
>> allow to change
>>    .class value for adapter. Not sure, it's possible because this parameter
>>    will be Linux and not HW specific (smth. like "i2c_disable_detection")
>> - update drivers i2c-omap/i2c-gpio to use "i2c_disable_detection"
>> - update OMAP4/5 DTS files
>>
>> So, It seemed a good solution for me to add 6 lines of code in i2c-core.c
>> instead of doing all that stuff.
> Well... I understand the "default behaviour" issue, yet I still think
> that setting class to 0 is the right thing to do. OMAP is an embedded
> SoC which always had i2c_board_info or devictree which are the preferred
> ways of instantiating. Given that, I would accept a patch setting it to
> 0. The more user friendly way might be to introduce a new class which
> makes users aware of the issue. Proof of concept follows, only compile
> tested.
>
That sounds good to me - I can prepare patch for i2c-omap.c.
But, there is still an open question regarding *i2c-gpio.c* which,
actually, a source of biggest part of delay.

Potentially, it can be tunned using "timeout" value. But, again, this
is additional work/patches to workaround unneeded system feature:
- "timeout" should not break interaction with I2C devices on i2c-gpio
bus and, at same time, speed up boot;
- DTS/board files need to be updated.

May be, just may be), we can continue with 
CONFIG_I2C_DISABLE_DEVICE_DETECTION,
and print deprecation warning for each registered adapter
if this config option is defined.

- grygorii
