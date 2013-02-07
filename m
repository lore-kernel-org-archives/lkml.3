Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3BGGcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:32:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43775 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3BGGcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:32:21 -0500
Message-ID: <51134A5F.1090707@ti.com>
Date: Thu, 7 Feb 2013 12:01:59 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/8] ARM: dts: omap: Add usb_otg and glue data
References: <1360162604-14320-1-git-send-email-kishon@ti.com> <1360162604-14320-4-git-send-email-kishon@ti.com> <511347E8.2030604@ti.com>
In-Reply-To: <511347E8.2030604@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 07 February 2013 11:51 AM, Rajendra Nayak wrote:
> []...
>
>>
>> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt
>> b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> index 29a043e..4688265 100644
>> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
>> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> @@ -15,6 +15,7 @@ OMAP MUSB GLUE
>>      represents PERIPHERAL.
>>    - power : Should be "50". This signifies the controller can supply
>> upto
>>      100mA when operating in host mode.
>> + - usb-phy : the phandle for the PHY device
>>
>>   SOC specific device node entry
>>   usb_otg_hs: usb_otg_hs@4a0ab000 {
>> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts
>> b/arch/arm/boot/dts/omap3-beagle-xm.dts
>> index 3705a81..cb07583 100644
>> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
>> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
>> @@ -107,3 +107,9 @@
>>        */
>>       ti,pulldowns = <0x03a1c4>;
>>   };
>> +
>> +&usb_otg_hs {
>> +    interface_type = <0>;
>> +    mode = <3>;
>> +    power = <50>;
>> +};
>> diff --git a/arch/arm/boot/dts/omap3-evm.dts
>> b/arch/arm/boot/dts/omap3-evm.dts
>> index e8ba1c2..afb9ba9 100644
>> --- a/arch/arm/boot/dts/omap3-evm.dts
>> +++ b/arch/arm/boot/dts/omap3-evm.dts
>> @@ -59,3 +59,9 @@
>>   &twl_gpio {
>>       ti,use-leds;
>>   };
>> +
>> +&usb_otg_hs {
>> +    interface_type = <0>;
>> +    mode = <3>;
>> +    power = <50>;
>> +};
>> diff --git a/arch/arm/boot/dts/omap3-overo.dtsi
>> b/arch/arm/boot/dts/omap3-overo.dtsi
>> index 89808ce..4b3d157 100644
>> --- a/arch/arm/boot/dts/omap3-overo.dtsi
>> +++ b/arch/arm/boot/dts/omap3-overo.dtsi
>> @@ -55,3 +55,9 @@
>>   &twl_gpio {
>>       ti,use-leds;
>>   };
>> +
>> +&usb_otg_hs {
>> +    interface_type = <0>;
>> +    mode = <3>;
>> +    power = <50>;
>> +};
>> diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
>> index 1acc261..b6472f7 100644
>> --- a/arch/arm/boot/dts/omap3.dtsi
>> +++ b/arch/arm/boot/dts/omap3.dtsi
>> @@ -397,5 +397,17 @@
>>               ti,timer-alwon;
>>               ti,timer-secure;
>>           };
>> +
>> +        usb_otg_hs: usb_otg_hs@480ab000 {
>> +            compatible = "ti,omap3-musb";
>> +            reg = <0x480ab000 0x1000>;
>> +            interrupts = <0 92 0x4>, <0 93 0x4>;
>> +            interrupt-names = "mc", "dma";
>> +            ti,hwmods = "usb_otg_hs";
>> +            usb-phy = <&usb2_phy>;
>> +            multipoint = <1>;
>> +            num_eps = <16>;
>> +            ram_bits = <12>;
>
> Where are these bindings documented? The general convention is to use
> a '-' for property names and not '_'

It's documented in Documentation/devicetree/bindings/usb/omap-usb.txt
Actually the documentation and the drivers got merged with this binding 
long back.

Thanks
Kishon
