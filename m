Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbaCDJOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:14:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54121 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463AbaCDJOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:14:39 -0500
Message-ID: <5315995F.5050206@ti.com>
Date: Tue, 4 Mar 2014 11:14:07 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <kishon@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>,
        <balajitk@ti.com>, <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 02/12] phy: omap-control: Update DT binding information
References: <1393859254-10937-1-git-send-email-rogerq@ti.com> <1393859254-10937-3-git-send-email-rogerq@ti.com> <20140303190247.GD25804@atomide.com>
In-Reply-To: <20140303190247.GD25804@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 03/03/2014 09:02 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140303 07:10]:
>> Move omap-control binding information to the right location.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  Documentation/devicetree/bindings/phy/ti-phy.txt   | 25 ++++++++++++++++++++++
>>  Documentation/devicetree/bindings/usb/omap-usb.txt | 24 ---------------------
>>  2 files changed, 25 insertions(+), 24 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
>> index 207e14c..41dc132 100644
>> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
>> @@ -1,5 +1,30 @@
>>  TI PHY: DT DOCUMENTATION FOR PHYs in TI PLATFORMs
>>  
>> +OMAP CONTROL PHY
>> +
>> +Required properties:
>> + - compatible: Should be one of
>> + "ti,control-phy-otghs" - if it has otghs_control mailbox register as on OMAP4.
>> + "ti,control-phy-usb2" - if it has Power down bit in control_dev_conf register
>> +                        e.g. USB2_PHY on OMAP5.
>> + "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
>> +                        e.g. USB3 PHY and SATA PHY on OMAP5.
>> + "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
>> +                        DRA7 platform.
>> + "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
>> +                        AM437 platform.
> 
> To me it seems that you can leave out all the above. You can set these falgs
> flags directly in the driver based on the compatible flag. Then just initialize
> the .data in the driver based on the compatible flag.

I'm not sure if I got you. A single platform can have different type of phys.

e.g. OMAP5 has both usb2 and pipe3 PHYs,
DRA7 has both pipe3 and usb2 PHYs, but this usb2 PHY is not compatible with OMAP5 one
so we need a new compatible id for that.

To add to the woes, the designers were creative enough to make another mutation to
the USB2 PHY for AM437x, :(

What do you suggest the compatible ids should look like for these 5 types of PHY control?
OTGHS	(OMAP4 & 5)
USB2	(OMAP5)
PIPE3	(OMAP5 & DRA7)
USB2x	(DRA7)
USB2y	(AM437)

cheers,
-roger

> 
>> + - reg : Address and length of the register set for the device. It contains
>> +   the address of "otghs_control" for control-phy-otghs or "power" register
>> +   for other types.
>> + - reg-names: should be "otghs_control" control-phy-otghs and "power" for
>> +   other types.
>> +
>> +omap_control_usb: omap-control-usb@4a002300 {
>> +        compatible = "ti,control-phy-otghs";
>> +        reg = <0x4a00233c 0x4>;
>> +        reg-names = "otghs_control";
>> +};
> 
> Then you would instead have something like this:
> 
> 	compatible = "ti,am347-control-phy-otghs";
> 
> That way you can initialize things without a need for custom bindings.
> 
> Regards,
> 
> Tony
> 

