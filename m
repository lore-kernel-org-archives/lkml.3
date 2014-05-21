Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaEUO3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:29:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54814 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaEUO3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:29:52 -0400
Message-ID: <537CB81B.4020205@ti.com>
Date: Wed, 21 May 2014 17:28:43 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <ijc+devicetree@hellion.org.uk>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch v3 0/5] Introduce keystone reset driver
References: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com> <537B5D5D.8030106@ti.com> <537BA06B.5060200@ti.com> <10992709.10WgsOixXr@wuerfel>
In-Reply-To: <10992709.10WgsOixXr@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/20/2014 10:27 PM, Arnd Bergmann wrote:
> On Tuesday 20 May 2014 21:35:23 Ivan Khoronzhuk wrote:
>> Thank for the note.
>>
>> Ok.
>>
>> Memory map:
>> [00 02310000 - 00 023101FF] size=512 PLL Controller
>> [00 02620000 - 00 02620FFF] size=4K device state control registers
>>
>> I'll define in DT two new syscon compatible nodes like:
>>
>>           pllctrl: pll_controller {
>>               compatible = "syscon";
>>               reg = <0x2310000 0x200>;
>>           };
>>
>>           devctrl: device_state_control {
>>               compatible = "syscon";
>>               reg = <0x2620000 0x1000>;
>>           };
> Please add a well-defined compatible-string in addition to "syscon" as
> well.
>
>> then correct reset-controller node like:
>>
>>           rstctrl: reset-controller {
>>               compatible = "ti,keystone-reset";
>>               reg = <0xE4 0x10>, <0x328 0x10>;
>>               reg-names = "pllregs", "muxregs";
>>               syscon1 = <&pllctrl>;
>>               syscon2 = <&devctrl>;
>>               ti,wdt_list = <0>;
>>           };
> You can't really use the "reg" property to refer to syscon
> registers, but you can make up your own property for that,
> or put the register numbers into the syscon1/2 properties,
> or just hardcode the offsets in the driver.
>
>> And correct reset-controller code to get regmap by phandle,
>> then access registers by regmap.
>>
>> Also I'll post two separate patches that add syscon nodes in question.
> Sounds good, thanks!
>
> 	Arnd

Arnd,

I've sent an updated patch series v4 with your notes applied.
Could you please take a glance on it.


-- 
Regards,
Ivan Khoronzhuk

