Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3HTGzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:55:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55197 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3HTGzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:55:31 -0400
Message-ID: <521312CC.8060003@ti.com>
Date: Tue, 20 Aug 2013 12:25:08 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB
 ID detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com> <1376648029-30659-2-git-send-email-george.cherian@ti.com> <52127284.6030506@wwwdotorg.org>
In-Reply-To: <52127284.6030506@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for your review.

On 8/20/2013 1:01 AM, Stephen Warren wrote:

> On 08/16/2013 04:13 AM, George Cherian wrote:
>> Adding extcon driver for USB ID detection to dynamically
>> configure USB Host/Peripheral mode.
>> diff --git a/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>> +EXTCON FOR DRA7xx
>> +
>> +Required Properties:
> Please at lest explain what a DRA7xxx is, and the purpose of the HW
> module this binding describes.

DRA7xx is the SoC name and the USB VID  detection is implemented via gpio's
Basically it does only ID detection via GPIO and there is no VBUS 
detection in h/w.
>
>> + - compatible : Should be "ti,dra7xx-usb"
> If this is a USB VID detector rather than a full USB host controller,
> then "usb" in the binding is a bit over-reaching. Perhaps "-usb-vid" or
> "-usb-vid-detector" would be more accurate.

This will be renamed to dra7xx-extcon.
>
>> + - gpios : phandle to ID pin and interrupt gpio.
> This isn't just a phandle; it's phandle+args, or a GPIO specifier. Some
> reference should be made to ../gpio/gpio.txt for the format.

okay
> Why does the interrupt line need to be included in a list of GPIOs?

ID pins are connected to pcf8575, and the pcf8575's interrupt line is 
inturn connected to
gpio bank6 pin 11, we use this gpio interrupt to detect the ID pin change.
> If the DRA7xxx is a VID detector, why does it even need/have any GPIOs
> associated with it; surely it has a dedicated VID input pin. Can you
> provide more details re: how the HW is structured.
>
>> +Optional Properties:
>> +  - interrupt-parent : interrupt controller phandle
>> +  - interrupts : interrupt number
>> +
>> +
> It's typical insert the following between those two blank lines:
>
> Example:
>
> ... or delete one of the blank lines.
>
>> +dra7x_extcon1 {
>> +		compatible = "ti,dra7xx-usb";
>> +		gpios = <&pcf_usb 1 0>,
>> +			<&gpio6 11 2>;
>> +		interrupt-parent = <&gpio6>;
>> +		interrupts = <11>;
>> +	};
>> +
> No need for that trailing blank line.

okay
>


-- 
-George

