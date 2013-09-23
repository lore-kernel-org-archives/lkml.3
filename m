Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab3IWJj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:39:27 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14273 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:39:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Sep 2013 02:39:24 -0700
Message-ID: <5240117C.8060300@nvidia.com>
Date: Mon, 23 Sep 2013 15:31:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [rtc-linux] [PATCH V2 3/5] gpio: add support for AMS AS3722 gpio
 driver
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com> <1379680214-9143-4-git-send-email-ldewangan@nvidia.com> <CACRpkdbJ6N-5RET+cmF=14jKVDnuAZtZwjcKym75ySER2gCpBQ@mail.gmail.com> <524001F3.3060602@nvidia.com> <CACRpkdYVTdh3+ayy96D4=iNO6ZASfTfeQOHF9vdoPjfLDCtB5Q@mail.gmail.com>
In-Reply-To: <CACRpkdYVTdh3+ayy96D4=iNO6ZASfTfeQOHF9vdoPjfLDCtB5Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 September 2013 02:56 PM, Linus Walleij wrote:
> On Mon, Sep 23, 2013 at 10:55 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
>> On Monday 23 September 2013 01:36 PM, Linus Walleij wrote:
>>> This is pin control. Do not try to shoehorn pin control drivers into
>>> the GPIO subsystem. Take a good day off, read through
>>> Documentation/pinctrl.txt and come back with a thoroughly rewritten
>>> driver in drivers/pinctrl/pinctrl-as3722.c.
> (...)
>> Yes, the appropriate location is pin control for pull up/down etc
>> configuration but with this device, the actual issue is with the way it is
>> require to configure the pull up/down and input/output of the pin. There is
>> no separate bits for pull up/down and direction and it is  clubbed together.
>> The register's bits are defined as:
>>
>> Selects the GPIO mode (I, I/O, Tri, Pulls) (BIT 2:0)
>>    0 : Input
>>    1 : Output (push and pull) VSUP_GPIO
>>    2 : Output/Input (open drain, only NMOS is active)
>>    3 : ADC input (Tristate)
>>    4 : Input with pull-up to VDD_GPIO_lv
>>    5 : Input with pull-down
>>    6 : Output/Input open drain (nmos) with pull-up to VDD_GPIO_lv,
>>    7 : Output (push and pull) VDD_GPIO_lv
>>
>> So I can not actually configure the pull up/down, open drain and direction
>> independently until every thing is known.
>> Direction come from gpio driver but pull up/down and open drain
>> configuration come from the pin control.
>> And this is only the reason to make all configuration in single driver.
> This is nothing special. Create a single combined GPIO and
> pin control driver using the pin control framework and device
> tree bindings.
>

Ok, I was thinking that we should not call gpiochip_add() from the pin 
control driver in any new driver and that's why I developed gpio driver 
but it seems it is allowed. I saw some of driver in pinctrl are doing 
pin control and gpio functionality in single driver i.e. 
pincntrl-nomadik, pinctrl-samsung, pincntrl-st etc.
So this gpio driver can be moved now to the pincntrl folder and can use 
pincontrol and gpio framework.

I will respin the change.


