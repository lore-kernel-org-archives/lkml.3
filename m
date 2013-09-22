Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IVOfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:35:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56264 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3IVOfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:35:50 -0400
Message-ID: <523F0040.6050900@ti.com>
Date: Sun, 22 Sep 2013 23:35:44 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] Documentation: add LP3943 DT bindings and document
References: <1378949700-6384-1-git-send-email-milo.kim@ti.com> <20130912152455.GN11227@lee--X1>
In-Reply-To: <20130912152455.GN11227@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Lee,

On 09/13/2013 12:24 AM, Lee Jones wrote:
> On Thu, 12 Sep 2013, Milo Kim wrote:

...

>> new file mode 100644
>> index 0000000..576ebd0
>> --- /dev/null
>> +++ b/Documentation/lp3943.txt
>> @@ -0,0 +1,62 @@
>> +TI/National Semiconductor LP3943 MFD driver
>> +===========================================
>> +
>> +LP3943 is an integrated device capable of driving 16 output channels.
>> +It can be used for GPIO expander and PWM generators.
>> +LP3493 registers are controlled via the I2C interface.
>> +
>> +Driver structure
>> +----------------
>> +                                  LED control    General usage for a device
>> +                                  ___________   ____________________________
>> +
>> +  LP3943 MFD ---- GPIO expander    leds-gpio        eg) HW enable pin
>> +              |
>> +              --- PWM generator    leds-pwm         eg) PWM input
>> +
>> +
>> +Why do we need GPIO and PWM drivers instead of LED driver?
>> +To support LED control and general usage, GPIO and PWM drivers are necessary.
>> +
>> +According to the datasheet(1), it's just a LED driver which has 16 channels.
>> +But here is another application, a GPIO expander.(2)
>> +
>> +  (1) http://www.ti.com/lit/ds/snvs256b/snvs256b.pdf
>> +  (2) http://www.ti.com/lit/an/snva287a/snva287a.pdf
>> +
>> +Internal two PWM channels are used for LED dimming effect.
>> +And each output pin can be used as a GPIO as well.
>> +LED functionality can work with GPIOs or PWMs.
>> +LEDs can be controlled with legacy leds-gpio(static brightness) or
>> +leds-pwm drivers(dynamic brightness control).
>> +Additionally, it can be used for generic GPIO and PWM controller.
>> +For example, a GPIO is HW enable pin of a device.
>> +PWM is input pin of a backlight device.
>> +
>> +
>> +LP3943 PWM port map
>> +-------------------
>> +Each PWM channel can be mapped to one or multiple output pins.
>> +
>> +For example, PWM 0 is used for a backlight device.
>> +PWM 1 is for RGB LEDs.
>> +
>> +  PWM channel    Output pins    PWM consumer
>> +  ___________    ___________    ____________
>> +  PWM 0          pin 1          backlight
>> +  PWM 1          pin 7, 8, 9    RGB LEDs
>> +
>> +Then, PWM port map is as below.
>> +PWM 0: num_outputs = 1, output = pin 1
>> +PWM 1: num_outputs = 3, output = pin 7, 8, 9
>> +
>> +The 'lp3943_pwm_map' structure is used for this feature.
>> +
>> +
>> +Device tree supported
>> +---------------------
>> +Please refer to the documents below.
>> +
>> +Documentation/devicetree/bindings/mfd/lp3943.txt
>> +Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
>> +Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
>
> Why do you need to document your driver in this way?
>
> If this stuff is really important (and most of it really isn't), then
> put it either in the commit log or in the driver.

Unnecessary documentation makes it noisy, but I think the LP3943 still 
needs the driver documentation for better understanding.

Many people think LP3943 is just LED driver, but I really want to share 
the application usages - PWM generators and GPIO expanders.
If the driver just supports LED functionality, then it would be created 
as LED class driver. However, this patch-set enables more generic driver 
usages.
So, this documentation would be helpful.

And I want to keep the code and the documentation separate.
If the link address is changed, then only documentation file will be 
modified, not source file.

So, I'd like to create the fifth patch-set with new MFD documentation 
subdirectory.
Additionally, LP3943 platform data example code will be added in the 
'Documentation/mfd/lp3943.txt'. It's for a platform which doesn't 
support the device tree.

Best regards,
Milo
