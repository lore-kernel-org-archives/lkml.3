Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaCEMXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:23:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37951 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaCEMXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:23:36 -0500
Message-ID: <5317172A.1050803@ti.com>
Date: Wed, 5 Mar 2014 14:23:06 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, George Cherian <george.cherian@ti.com>
CC: <kishon@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 02/12] phy: omap-control: Update DT binding information
References: <1393859254-10937-1-git-send-email-rogerq@ti.com> <1393859254-10937-3-git-send-email-rogerq@ti.com> <20140303190247.GD25804@atomide.com> <5315995F.5050206@ti.com> <20140304162855.GB3376@atomide.com>
In-Reply-To: <20140304162855.GB3376@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ George

Tony,

On 03/04/2014 06:28 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140304 01:17]:
>> Hi Tony,
>>
>> On 03/03/2014 09:02 PM, Tony Lindgren wrote:
>>> * Roger Quadros <rogerq@ti.com> [140303 07:10]:
>>>> Move omap-control binding information to the right location.
>>>>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>> ---
>>>>  Documentation/devicetree/bindings/phy/ti-phy.txt   | 25 ++++++++++++++++++++++
>>>>  Documentation/devicetree/bindings/usb/omap-usb.txt | 24 ---------------------
>>>>  2 files changed, 25 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>> index 207e14c..41dc132 100644
>>>> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>> @@ -1,5 +1,30 @@
>>>>  TI PHY: DT DOCUMENTATION FOR PHYs in TI PLATFORMs
>>>>  
>>>> +OMAP CONTROL PHY
>>>> +
>>>> +Required properties:
>>>> + - compatible: Should be one of
>>>> + "ti,control-phy-otghs" - if it has otghs_control mailbox register as on OMAP4.
>>>> + "ti,control-phy-usb2" - if it has Power down bit in control_dev_conf register
>>>> +                        e.g. USB2_PHY on OMAP5.
>>>> + "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
>>>> +                        e.g. USB3 PHY and SATA PHY on OMAP5.
>>>> + "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
>>>> +                        DRA7 platform.
>>>> + "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
>>>> +                        AM437 platform.
>>>
>>> To me it seems that you can leave out all the above. You can set these falgs
>>> flags directly in the driver based on the compatible flag. Then just initialize
>>> the .data in the driver based on the compatible flag.
>>
>> I'm not sure if I got you. A single platform can have different type of phys.
>>
>> e.g. OMAP5 has both usb2 and pipe3 PHYs,
>> DRA7 has both pipe3 and usb2 PHYs, but this usb2 PHY is not compatible with OMAP5 one
>> so we need a new compatible id for that.
>>
>> To add to the woes, the designers were creative enough to make another mutation to
>> the USB2 PHY for AM437x, :(
> 
> Oh OK, in that case the compatible flag may not be enough for configuring the
> various instances.
>  
>> What do you suggest the compatible ids should look like for these 5 types of PHY control?
>> OTGHS	(OMAP4 & 5)
>> USB2	(OMAP5)
>> PIPE3	(OMAP5 & DRA7)
>> USB2x	(DRA7)
>> USB2y	(AM437)
> 
> I think in that case having the various instances fully configurable from
> device tree is OK if you prefer that. But if you wanted to use the
> compatible flag, then you could do something like this:
> 
> ti,control-phy-omap4-otghs	(assuming same on omap4 & 5)
> ti,control-phy-omap5-usb2
> ti,control-phy-omap5-pipe3	(assuming same on omap5 & dra7)
> ti,control-phy-dra7-usb2x
> ti,control-phy-am437-usb2y
> ...
> 

Please note that the original bindings were added in v3.13 and I'm just moving the documentation
to the right location. So I don't think we should change the bindings now.

"ti,control-phy-dra7usb2" and "ti,control-phy-am437usb2" have no users still so we could probably
change those to "ti,control-phy-dra7-usb2" and "ti,control-phy-am437-usb2".

What do you say?

cheers,
-roger
