Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3HPJIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:08:14 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37963 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab3HPJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:08:06 -0400
Message-ID: <520DEBF1.6070605@baylibre.com>
Date: Fri, 16 Aug 2013 11:08:01 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux@arm.linux.org.uk, a-kishore@ti.com, afzal@ti.com,
        linux-kernel@vger.kernel.org, balbi@ti.com,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH v3] arm: dts: AM43x: Add usb DT nodes for AM4372
References: <1373444082-4169-1-git-send-email-george.cherian@ti.com> <520B9144.5000701@ti.com> <520B958B.1000900@baylibre.com> <520D9A3E.1040903@ti.com>
In-Reply-To: <520D9A3E.1040903@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/2013 05:19, George Cherian wrote:
> Hi Benoit ,
>
> Thanks for your review.
>
> On 8/14/2013 8:04 PM, Benoit Cousson wrote:
>> + Roger
>>
>> Hi George,
>>
>> Yes, I had some comment about the "ti'type" in Roger's series that
>> will be applicable here as well.
>>
>
>
>>
>> On 14/08/2013 16:16, George Cherian wrote:
>>> +Benoit
>>>   If you dont have any comments, can you take this for 3.12?
>>>
>>> Regards
>>> -George
>>>
>>> On 7/10/2013 1:44 PM, George Cherian wrote:
>>>
>>>> This patch adds
>>>>     - HS USB nodes
>>>>     - phy nodes
>>>>     - usb control module nodes.
>>>>
>>>> Signed-off-by: George Cherian <george.cherian@ti.com>
>>>> ---
>>>>
>>>> changes from v2
>>>> change synopsis to snps
>>>> use simple node names
>>>> add both USB and PHY instances
>>>> add usbctrl node
>>>>
>>>> changes from v1
>>>> renamed synopsis to snps
>>>> removed flag tx-fifo-resize
>>>>
>>>>   arch/arm/boot/dts/am4372.dtsi | 58
>>>> +++++++++++++++++++++++++++++++++++++++++++
>>>>   1 file changed, 58 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/am4372.dtsi
>>>> b/arch/arm/boot/dts/am4372.dtsi
>>>> index ddc1df7..37f196f 100644
>>>> --- a/arch/arm/boot/dts/am4372.dtsi
>>>> +++ b/arch/arm/boot/dts/am4372.dtsi
>>>> @@ -64,5 +64,63 @@
>>>>               compatible = "ti,am4372-counter32k","ti,omap-counter32k";
>>>>               reg = <0x44e86000 0x40>;
>>>>           };
>>>> +
>>>> +        phy1: usbphy1 {
>>>> +            compatible = "ti,am4372-usb2";
>>
>> That's not a very good name for a phy? It looks like a usb module.
>>
>> The bindings specify only ti,omap-usb2 or ti,omap-usb3 for USB2 or USB3.
>> I guess it should be one of them and potentially the binding should be
>> updated with ti,omap-usb2-phy and ti,omap-usb3-phy names while we can
>> still do it.
>>
>>>> +            #phy-cells = <0>;
>>>> +            id = <0>;
>>>> +            status = "disabled";
>>>> +        };
>>>> +
>>>> +        phy2: usbphy2 {
>>
>> Why do you need a different node name here? It should be a generic
>> name to identify the function, so usbphy or usb-phy seems good enough.
>
> There are 2 instances of usb controllers and these instances for those 2
> phys, which essentially dont have any reg property. So I named it as
> usbphy1 and usbphy2.
>>
>>>> +            compatible = "ti,am4372-usb2";
>>>> +            #phy-cells = <0>;
>>>> +            id = <1>;
>>>> +            status = "disabled";
>>>> +        };
>>>> +
>>>> +        usbctrl: omap-control-usb@44e10620 {
>>>> +            compatible = "ti,omap-control-usb";
>>>> +            reg = <0x44e10620 0x10>;
>>>> +            reg-names = "control_dev_conf";
>>>> +            ti,type = <3>;
>>>> +            status = "disabled";
>>>> +        };
>>>> +
>>>> +        usb1: am4372_dwc3@48380000 {
>>>> +            status = "disabled";
>>>> +            compatible = "ti,am4372-dwc3";
>>>> +            reg = <0x48380000 0x200>;
>>>> +            interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
>>>> +            #address-cells = <1>;
>>>> +            #size-cells = <1>;
>>>> +            utmi-mode = <1>;
>>>> +            ranges;
>>
>> A blank line here will be nice.
>
> okay
>>
>>>> +            dwc3@48390000 {
>>>> +                compatible = "snps,dwc3";
>>>> +                reg = <0x48390000 0xd000>;
>>>> +                interrupts = <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
>>>> +                phys = <&phy1>;
>>>> +                phy-names = "am4372-usb1";
>>
>> What is the purpose of the phy-names? Is it relevant to add the SoC
>> name in something that usually, at least for the clocks and IRQs, is
>> IP specific?
>>
>> The current documentation does not explain it and does not support
>> phys property either.
>>
>>   synopsys DWC3 CORE
>>
>>   DWC3- USB3 CONTROLLER
>>
>>   Required properties:
>>    - compatible: must be "synopsys,dwc3"
>>    - reg : Address and length of the register set for the device
>>    - interrupts: Interrupts used by the dwc3 controller.
>>    - usb-phy : array of phandle for the PHY device
>>
>> Is there some binding update ongoing for 3.12?
>
> The phy part, especially was added with the generic phy framework in
> mind. The generic phy framework uses phys and phy-names instead of usb-phy.
> Also all synopsys  references for compatible are being replaced with snps.

That's fine, but that was not my question. Is there any already bindings 
that defined phys and phy-names in the kernel?

I couldn't find them in 3.11-rc5.

And anyway the current bindings for dwc3 is not aligned with what you 
are doing here.
So you have to change the binding before using it in this DTS.

Regards,
Benoit

