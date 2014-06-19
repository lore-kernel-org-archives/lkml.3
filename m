Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaFSDbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 23:31:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42874 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbaFSDbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 23:31:17 -0400
Message-ID: <53A25953.9030107@ti.com>
Date: Thu, 19 Jun 2014 09:00:27 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] extcon: gpio: Add dt support for the driver.
References: <1402977500-19987-1-git-send-email-george.cherian@ti.com> <1402977500-19987-3-git-send-email-george.cherian@ti.com> <20140617155719.GC8930@leverpostej>
In-Reply-To: <20140617155719.GC8930@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/2014 9:27 PM, Mark Rutland wrote:
> On Tue, Jun 17, 2014 at 04:58:20AM +0100, George Cherian wrote:
>> Add device tree support to extcon-gpio driver.
>> Add devicetree binding documentation
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   .../devicetree/bindings/extcon/extcon-gpio.txt     | 34 ++++++++++++++++++++++
>>   drivers/extcon/extcon-gpio.c                       | 29 ++++++++++++++++++
>>   2 files changed, 63 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt
>>
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
>> new file mode 100644
>> index 0000000..80b791b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
>> @@ -0,0 +1,34 @@
>> +GPIO based EXTCON
>> +
>> +EXTCON GPIO
>> +-----------
>> +
>> +Required Properties:
>> + - compatible: should be:
>> +   * "ti,extcon-gpio"
>> + - gpios: specifies the gpio pin used.
>> + - debounce: Debounce time for GPIO IRQ in ms
>> + - irq-flags: IRQ flag to be used ( eg: IRQ_TYPE_EDGE_FALLING)
> This looks distinctly odd. Why do you need this here?
The driver takes this as part of platform data. It never continues 
operation if
an invalid irq-flag is supplied. Also these can be used for different SoC's
whose GPIO's might support IRQ_TYPE_EDGE_FALLING/RISING.
Now since this is based on gpio we cant up front give a seperate
"interrupts = " property, since we dont know the gpio-pin irq number.

Chanwoo any comments?
>
>> +Optional Properties:
>> + - gpio-active-low: Property describing whether gpio active state is 1 or 0
>> +		    If defined , low state of gpio means active.
> Surely this is defined in the gpio flags?

Yes, I will make necessary changes.
>
>> + - check-on-resume: Property describing whether to check the gpio state
>> +		    while resuming from SLEEP.
> Does this need to be in DT? Surely we could jsut always check this?
okay. For my use-case I dont need this.
Chanwoo, any comments?
>> + - state-on: print_state is overriden with state_on string if provided.
>> +	     If NULL, default method of extcon class is used.
>> + - state_off: print_state is overriden with state_off string  if provided.
>> +	      If NUll, default method of extcon class is used.
> This means nothing from a HW perspective. This describes linux internal
> details.
You mean to say this should not be part of dt?

> [...]
>
>> +		of_property_read_u32(np, "debounce", (u32 *)&pdata->debounce);
>> +		of_property_read_u32(np, "irq-flags", (u32 *)&pdata->irq_flags);
> If you need theses casts, the code is broken.
I dont need this, will remove in v2.
>
> These functions can only read into a u32. If you pass a smaller type
> you'll trash aribtrary memory locations, and if you pass a larger type
> this is broken for BE.
true.
> Mark.


-- 
-George

