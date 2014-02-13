Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaBMMfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:35:48 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8905 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbaBMMfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:35:45 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-06-52fcbc201836
Message-id: <52FCBC1D.7050501@samsung.com>
Date: Thu, 13 Feb 2014 13:35:41 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Arend van Spriel <arend@broadcom.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
References: <1392059868-8782-1-git-send-email-arend@broadcom.com>
 <52FC8CB3.4090305@gmail.com> <52FCB571.4020904@broadcom.com>
In-reply-to: <52FCB571.4020904@broadcom.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7oKe/4EGXxrkbJoftPPbDH14RM2
	i/lHzrFaXN41h82ide8RdotVu/4wWvw8dJ7Jgd1j1v2zbB4bHq1m9dg56y67x6ZVnWwenzfJ
	BbBGcdmkpOZklqUW6dslcGXsfriIveCkZsWsS9fYGxh3K3YxcnJICJhIzNi1kBHCFpO4cG89
	WxcjF4eQwFJGiWXNvcwQzmdGicYTK4GqODh4BbQkJsznAWlgEVCVWPf1EhOIzSagJvG54REb
	iC0qECHxd956sKG8AoISPybfYwGxRQSKJHa9+wdWwyxQKzFv0xQWkJHCAv4Sv/t4IVY1MEps
	P9MH1sspoCPx/GE3C0S9tcTKSdsYIWx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqaXFCc
	lJ5rpFecmFtcmpeul5yfu4kREuRfdzAuPWZ1iFGAg1GJh/fB4t9BQqyJZcWVuYcYJTiYlUR4
	G7f9CRLiTUmsrEotyo8vKs1JLT7EyMTBKdXAuIk1SbKxNZ5ropTcc/tNxxV0HsiumHNVX8N/
	t8zimvYElZO3A5l/nljK9XRTsORafv3Pf6eGZ51+9SWinTX52SKGdJGUhIANTD9Pbn8Zuak/
	3kpgmVwhR2AE67afV7KvP2IQtXMt3LPiphZH2qxfOXtO3zBs+6t9/NDPylym59rmEvJGfi/t
	lFiKMxINtZiLihMBKdUMMFACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.2014 13:07, Arend van Spriel wrote:
> On 02/13/2014 10:13 AM, Tomasz Figa wrote:
>> Hi Arend,
>>
>> On 10.02.2014 20:17, Arend van Spriel wrote:
>>> The Broadcom bcm43xx sdio devices are fullmac devices that may be
>>> integrated in ARM platforms. Currently, the brcmfmac driver for
>>> these devices support use of platform data. This patch specifies
>>> the bindings that allow this platform data to be expressed in the
>>> devicetree.
>>>
>>> Cc: Chen-Yu Tsai <wens@csie.org>
>>> Cc: Tomasz Figa <tomasz.figa@gmail.com>
>>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>> ---
>>> This devicetree binding proposal is intended for platforms with
>>> Broadcom wireless device in MMC sdio slot. These devices may
>>> have their own interrupt and power line. Also the SDIO drive
>>> strength is often hardware dependent and expressed in this
>>> binding.
>>>
>>> Not sure if this should go in staging or not. Feel free to
>>> comment on this proposal.
>>>
>>> Regards,
>>> Arend
>>> ---
>>>    .../staging/net/wireless/brcm,bcm43xx-fmac.txt     |   37
>>> ++++++++++++++++++++
>>>    1 file changed, 37 insertions(+)
>>>    create mode 100644
>>> Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>>>
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>>> b/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>>>
>>> new file mode 100644
>>> index 0000000..535f343
>>> --- /dev/null
>>> +++
>>> b/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>>>
>>> @@ -0,0 +1,37 @@
>>> +Broadcom BCM43xx Fullmac wireless SDIO devices
>>> +
>>> +This node provides properties for controlling the Broadcom wireless
>>> device. The
>>> +node is expected to be specified as a child node to the MMC
>>> controller that
>>> +connects the device to the system.
>>> +
>>> +Required properties:
>>> +
>>> + - compatible : Should be "brcm,bcm43xx-fmac".
>>> + - wlan-supply : phandle for fixed regulator used to control power for
>>> +    the device/module.
>>
>> The BCM43xx WLAN chips I used to work always have been controlled by a
>> simple power enable GPIO of the chip itself. Has this changed in newer
>> chips?
>>
>> If you need to simply toggle a GPIO to control the power, you don't need
>> to use the regulator API at all, controlling the GPIO directly.
>
> Not sure I understand. Do you really mean 'chip' or 'wifi module' here.
> The chip needs to be powered and for that it is hooked up to a
> host/module provided GPIO (at least that is my understanding).

Your binding asks for a regulator, not a simple GPIO, which is all I 
believe you need for BCM43xx power handling.

Mark (added to Cc), could we get your opinion on this?

>
>>> +
>>> +Optional properties:
>>> + - drive-strength : drive strength used for SDIO pins on device
>>> (default = 6mA).
>>
>> This should be a part of the MMC binding, I think. Probably also moved
>> under MMC controller's node, since it's a board-specific property
>> altering the parameters of the MMC controller, not the WLAN chip.
>
> It is an electrical interfacing parameter between MMC controller and the
> device. The specified drive-strength here is used to configure the PMU
> on the chip so it is really related to the the chip.
>

Aha, so I misunderstood the description. Anyway, if it's a 
device-specific property, it should have vendor prefix ("brcm,").

>>> + - interrupt-parent : the phandle for the interrupt controller to
>>> which the
>>> +    device interrupt (HOST_WAKE) is connected.
>>> + - interrupts : interrupt specifier encoded according the interrupt
>>> controller
>>> +    specified by interrupt-parent property.
>>
>> I would also add a clock here, since the BCM43xx chips usually need a
>> 32k clock to operate (or at least the ones I used to work with did). It
>> can be optional, as not all systems can control this clock.
>>
>>> +
>>> +Example:
>>> +
>>> +mmc3: mmc@01c20000 {
>>> +    pinctrl-0 = <&mmc3_pins>;
>>> +    pinctrl-1 = <&wifi_host_wake>;
>>
>> WLAN_HOST_WAKE pin (aka the OOB interrupt) is specific to the WLAN chip,
>> so this should be rather configured in a pinctrl state of the WLAN chip
>> itself.
>
> You mean that pinctrl-1 should move inside the "brcm,bcm43xx-fmac" node,
> right?

Yes.

By the way, if not moved to device node, shouldn't it rather be just 
another entry of pinctrl-0? Also isn't pinctrl-names property missing here?

>
>>> +    vmmc-supply = <&mmc3_supply>;
>>> +    bus-width = <4>;
>>> +
>>> +    bcm4335: bcm4335@0 {
>>
>> nit: Why @0, if there is no reg property under this node?
>
> I am not fluent with devicetree specifications (yet) nor know all the
> conventions.

The "@" suffix is reserved for bus constructs, where the unit-address 
value after "@" corresponds to first address in reg property of the 
node. Here you could just simply use "bcm4335" or if you somehow manage 
to have two such chips (which I don't think is likely to happen) then 
you could use "bcm4335-1".

Best regards,
Tomasz
