Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaCFNMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:12:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54944 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaCFNM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:12:28 -0500
Message-ID: <53187429.1000408@ti.com>
Date: Thu, 6 Mar 2014 15:12:09 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <anatol.pomozov@gmail.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <kishon@ti.com>, <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <bcousson@baylibre.com>,
        <tony@atomide.com>
Subject: Re: [PATCH 2/5] ARM: dts: AM4372: Add USB nodes
References: <1393854834-23810-1-git-send-email-george.cherian@ti.com> <1393854834-23810-3-git-send-email-george.cherian@ti.com> <53183699.8070106@ti.com> <531869C2.3070905@ti.com>
In-Reply-To: <531869C2.3070905@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 02:27 PM, George Cherian wrote:
> Hi Roger,
> 
> On 3/6/2014 2:19 PM, Roger Quadros wrote:
>> Hi George,
>>
>> On 03/03/2014 03:53 PM, George Cherian wrote:
>>> Add nodes for 2 instances each of
>>>     - ocp2scp
>>>     - USB PHY control module
>>>     - USB PHY
>>>     - dwc3_omap
>>>     - USB
>>>
>>> for AM43xx.
>>>
>>> Signed-off-by: George Cherian <george.cherian@ti.com>
>>> ---
>>>   arch/arm/boot/dts/am4372.dtsi | 99 +++++++++++++++++++++++++++++++++++++++++++
>>>   1 file changed, 99 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
>>> index 5a7cc38..90408b3 100644
>>> --- a/arch/arm/boot/dts/am4372.dtsi
>>> +++ b/arch/arm/boot/dts/am4372.dtsi
>>> @@ -698,6 +698,105 @@
>>>                      <&edma 11>;
>>>               dma-names = "tx", "rx";
>>>           };
>>> +
>>> +        am43xx_control_usb2phy1: control-phy@44e10620 {
>>> +            compatible = "ti,control-phy-am437usb2";
>> Since this is the first usage of this compatible ID, we still have room to
>> change it to be better. Tony's suggestion was to use "ti,control-phy-am437-usb2"
>>
>> Please see
>> http://article.gmane.org/gmane.linux.drivers.devicetree/64833
> 
> Okay.
>>> +            reg = <0x44e10620 0x4>;
>>> +            reg-names = "power";
>>> +            status = "disabled";
>> Why disable something that is within the SoC and does not affect board configurations?
>>
>> Question applies for all the nodes in this patch except the ones that come out on the
>> SoC pins. e.g. PHY.
> Okay
>>> +        };
>>> +
>>> +        am43xx_control_usb2phy2: control-phy@0x44e10628 {
>>> +            compatible = "ti,control-phy-am437usb2";
>>> +            reg = <0x44e10628 0x4>;
>>> +            reg-names = "power";
>>> +            status = "disabled";
>>> +        };
>>> +
>>> +        ocp2scp0: ocp2scp@483a8000 {
>>> +            compatible = "ti,omap-ocp2scp";
>>> +            #address-cells = <1>;
>>> +            #size-cells = <1>;
>>> +            ranges;
>>> +            ti,hwmods = "ocp2scp0";
>>> +            status = "disabled";
>>> +
>>> +            usb2_phy1: usb2phy1@483a8000 {
>> should be
> okay
>>             usb2_phy1: phy@483a8000 {
>>
>>> +                compatible = "ti,am437x-usb2";
>>> +                reg = <0x483a8000 0x8000>;
>>> +                ctrl-module = <&am43xx_control_usb2phy1>;
>>> +                clocks = <&clk_32768_ck>,
>>> +                     <&usb_otg_ss0_refclk960m>;
>>> +                clock-names = "usb_phy_cm_clk32k",
>>> +                          "usb_otg_ss_refclk960m";
>> clock-names should be platform independent. Better option would be to
>> modify the usb2 driver to use names like "wkupclk" and "refclk"
> The phy driver still does devm_get_clk using above clock names and not "wkupclk" and "refclk".
> 

I'll post a patch soon that takes care of both clock names and the compatible ids in
the phy-omap-usb2.c driver.

>>> +                #phy-cells = <0>;
>>> +                status = "disabled";
>>> +            };
>>> +        };
>>> +
>>> +        ocp2scp1: ocp2scp@483e8000 {
>>> +            compatible = "ti,omap-ocp2scp";
>>> +            #address-cells = <1>;
>>> +            #size-cells = <1>;
>>> +            ranges;
>>> +            ti,hwmods = "ocp2scp1";
>>> +            status = "disabled";
>>> +
>>> +            usb2_phy2: usb2phy2@483e8000 {
>>> +                compatible = "ti,am437x-usb2";
>>> +                reg = <0x483e8000 0x8000>;
>>> +                ctrl-module = <&am43xx_control_usb2phy2>;
>>> +                clocks = <&clk_32768_ck>,
>>> +                     <&usb_otg_ss1_refclk960m>;
>>> +                clock-names = "usb_phy_cm_clk32k",
>>> +                          "usb_otg_ss_refclk960m";
>>> +                #phy-cells = <0>;
>>> +                status = "disabled";
>>> +            };
>>> +        };
>>> +
>>> +        dwc3_1: omap_dwc3_1@48380000 {
>>> +            compatible = "ti,am437x-dwc3";
>>> +            ti,hwmods = "usb_otg_ss0";
>>> +            reg = <0x48380000 0x10000>;
>>> +            interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
>>> +            #address-cells = <1>;
>>> +            #size-cells = <1>;
>>> +            utmi-mode = <1>;
>>> +            ranges;
>>> +            status = "disabled";
>>> +
>>> +            usb1: usb@48390000 {
>>> +                compatible = "synopsys,dwc3";
>>> +                reg = <0x48390000 0x17000>;
>>> +                interrupts = <GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>;
>>> +                usb-phy = <&usb2_phy1>;
>> shouldn't this be        phys = <&usb2_phy1>;    ?
> 
> At the time of writing this patch phys property is still not in.
> Also generic-phy conversion for dwc3 was recently posted by kishon.
>>> +                phy-names = "usb2-phy";
>> what about
>>     maximum-speed = "high-speed";
>> and
>>     dr_mode = "otg"; ?
> 
> Done from board file. Actually maximum-speed I can set here.
> dr_mode is a board property.

Is it a known standard that dr_mode must come from board dts?

I think dr_mode can be set here by default. Board can always override if it
needs non otg operation.

cheers,
-roger

>>> +                status = "disabled";
>>> +            };
>>> +        };
>>> +
>>> +        dwc3_2: omap_dwc3_2@483c0000 {
>>> +            compatible = "ti,am437x-dwc3";
>>> +            ti,hwmods = "usb_otg_ss1";
>>> +            reg = <0x483c0000 0x10000>;
>>> +            interrupts = <GIC_SPI 178 IRQ_TYPE_LEVEL_HIGH>;
>>> +            #address-cells = <1>;
>>> +            #size-cells = <1>;
>>> +            utmi-mode = <1>;
>>> +            ranges;
>>> +            status = "disabled";
>>> +
>>> +            usb2: usb@483d0000 {
>>> +                compatible = "synopsys,dwc3";
>>> +                reg = <0x483d0000 0x17000>;
>>> +                interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
>>> +                usb-phy = <&usb2_phy2>;
>>> +                phy-names = "usb2-phy";
>>> +                status = "disabled";
>>> +            };
>>> +        };
>>> +
>>>       };
>>>   };
>>>  
>> cheers,
>> -roger
> 
> 

