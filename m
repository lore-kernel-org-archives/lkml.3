Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3HTQxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:53:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37198 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3HTQxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:53:40 -0400
Message-ID: <52139F0F.6090507@wwwdotorg.org>
Date: Tue, 20 Aug 2013 10:53:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: balbi@ti.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        ian.campbell@citrix.com, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, bcousson@baylibre.com
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB
 ID detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com> <1376648029-30659-2-git-send-email-george.cherian@ti.com> <52127284.6030506@wwwdotorg.org> <521312CC.8060003@ti.com>
In-Reply-To: <521312CC.8060003@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 12:55 AM, George Cherian wrote:
> Hi Stephen,
> 
> Thanks for your review.
> 
> On 8/20/2013 1:01 AM, Stephen Warren wrote:
> 
>> On 08/16/2013 04:13 AM, George Cherian wrote:
>>> Adding extcon driver for USB ID detection to dynamically
>>> configure USB Host/Peripheral mode.
>>> diff --git
>>> a/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>>> b/Documentation/devicetree/bindings/extcon/extcon-dra7xx.txt
>>> +EXTCON FOR DRA7xx
>>> +
>>> +Required Properties:
>> Please at lest explain what a DRA7xxx is, and the purpose of the HW
>> module this binding describes.
> 
> DRA7xx is the SoC name and the USB VID  detection is implemented via gpio's
> Basically it does only ID detection via GPIO and there is no VBUS
> detection in h/w.

If there's no SoC-specific HW, then the binding has nothing to do with
the SoC; it's entirely generic.

I think instead, you need to define a generic "gpio-usb-vid" binding
instead.

Otherwise, ever SoC that doesn't have explicit USB VID detection HW is
going to re-invent the exact same binding, with pointless differences,
rather than using a single generic binding.

>>> + - compatible : Should be "ti,dra7xx-usb"
>>
>> If this is a USB VID detector rather than a full USB host controller,
>> then "usb" in the binding is a bit over-reaching. Perhaps "-usb-vid" or
>> "-usb-vid-detector" would be more accurate.
> 
> This will be renamed to dra7xx-extcon.

So no, that rename doesn't sound correct.

>>> + - gpios : phandle to ID pin and interrupt gpio.
>>
>> Why does the interrupt line need to be included in a list of GPIOs?
> 
> ID pins are connected to pcf8575, and the pcf8575's interrupt line is
> inturn connected to
> gpio bank6 pin 11, we use this gpio interrupt to detect the ID pin change.

In that case, the PCF8575 node needs to be a GPIO controller and an IRQ
controller, as does the driver for the PCF8575. This binding should have
a single entry in the gpios property, and the driver can call
gpio_to_irq() on that so it knows which IRQ to request.
