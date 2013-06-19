Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652Ab3FSMFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:05:07 -0400
Received: from smtp0.epfl.ch ([128.178.224.218]:59765 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934297Ab3FSMFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:05:05 -0400
Message-ID: <51C19E6C.4040802@epfl.ch>
Date: Wed, 19 Jun 2013 14:05:00 +0200
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
References: <1371571487-14389-1-git-send-email-rogerq@ti.com> <1371571487-14389-2-git-send-email-rogerq@ti.com> <51C106A1.9030001@ti.com> <51C15F7E.5020305@ti.com> <20130619074605.GW5523@atomide.com> <51C183AC.8040801@ti.com> <51C19011.5050107@ti.com>
In-Reply-To: <51C19011.5050107@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/19/2013 01:03 PM, Roger Quadros wrote:
> On 06/19/2013 01:10 PM, Benoit Cousson wrote:
>> On 06/19/2013 02:46 AM, Tony Lindgren wrote:
>>> * Roger Quadros <rogerq@ti.com> [130619 00:42]:
>>>> Hi Benoit,
>>>>
>>>> On 06/19/2013 04:17 AM, Benoit Cousson wrote:
>>>>> Hi Roger,
>>>>>
>>>>> On 06/18/2013 11:04 AM, Roger Quadros wrote:
>>>>>> Provide the RESET and Power regulators for the USB PHY,
>>>>>> the USB Host port mode and the PHY device.
>>>>>>
>>>>>> Also provide pin multiplexer information for the USB host
>>>>>> pins.
>>>>>>
>>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>>>> ---
>>>>>>     arch/arm/boot/dts/omap4-panda-common.dtsi |   62 +++++++++++++++++++++++++++++
>>>>>>     1 files changed, 62 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>>>> index 00cbaa5..7a21e8e 100644
>>>>>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>>>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
>>>>>> @@ -59,6 +59,42 @@
>>>>>>                 "AFML", "Line In",
>>>>>>                 "AFMR", "Line In";
>>>>>>         };
>>>>>> +
>>>>>> +    /* HS USB Port 1 RESET */
>>>>>> +    hsusb1_reset: hsusb1_reset_reg {
>>>>>> +        compatible = "regulator-fixed";
>>>>>> +        regulator-name = "hsusb1_reset";
>>>>>> +        regulator-min-microvolt = <3300000>;
>>>>>> +        regulator-max-microvolt = <3300000>;
>>>>>> +        gpio = <&gpio2 30 0>;    /* gpio_62 */
>>>>>> +        startup-delay-us = <70000>;
>>>>>> +        enable-active-high;
>>>>>> +    };
>>>>>
>>>>> Is this really a regulator? Or just a GPIO line used to reset the USB PHY?
>>>>
>>>> It is in fact a GPIO line used as reset.
>>>>>
>>>>> If this is the case, I don't think it should be represented as a regulator.
>>>>
>>>> Why not? I think it fits very well in the regulator device model.
>>
>> I'm not sure fitting very well is the correct term.
>> It works, for sure, but it is no different than when we were trying to abuse the regulator fmwk to enable the 32k clock in phoenix.
>> It is just a hack.
>>
>
> The only difference is there is a dedicated framework for clocks. Since there is nothing specific to
> handle reset lines it is left to the driver writer how he wants to manage it.
>

There is a proposed binding for gpio-controlled reset lines, but it is 
not yet merged [1].
I guess it can fit most usage patterns, and it can be an interesting 
move in the future.

Regards,

Florian

[1] http://thread.gmane.org/gmane.linux.drivers.devicetree/36830
