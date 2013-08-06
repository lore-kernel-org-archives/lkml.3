Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3HFN07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:26:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44447 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3HFN05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:26:57 -0400
Message-ID: <5200F99C.8010200@ti.com>
Date: Tue, 6 Aug 2013 16:26:52 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] usb: phy: omap: Add new PHY types and remove omap_control_usb3_phy_power()
References: <1375365915-21380-1-git-send-email-rogerq@ti.com> <1375365915-21380-2-git-send-email-rogerq@ti.com> <5200E1DB.8040006@ti.com>
In-Reply-To: <5200E1DB.8040006@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 02:45 PM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Thursday 01 August 2013 07:35 PM, Roger Quadros wrote:
>> TYPE2 meaning has changed. It is now a USB2 phy with Power down bit in
>> control_dev_conf register.
>>
>> Introduce TYPE3 and TYPE4 PHY. TYPE3 is USB3 phy with DPLL and individual
>> TX/RX power control. TYPE4 is USB2 phy with power aux register.
>>
>> Update DT binding information to reflect these changes.
>>
>> Also get rid of omap_control_usb3_phy_power(). Just one function
>> i.e. omap_control_usb_phy_power() will now take care of all PHY types.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Tested-by: Kishon Vijay Abraham I <kishon@ti.com>
> but one minor comment below.
>> ---
>>   Documentation/devicetree/bindings/usb/omap-usb.txt |   23 ++--
>>   drivers/usb/phy/phy-omap-control.c                 |  129 +++++++++++---------
>>   drivers/usb/phy/phy-omap-usb2.c                    |    4 +
>>   drivers/usb/phy/phy-omap-usb3.c                    |    6 +-
>>   include/linux/usb/omap_control_usb.h               |   18 ++--
>>   5 files changed, 100 insertions(+), 80 deletions(-)
>>
> .
> .
> <snip>
> .
> .
> 
>> +    omap_control_usb_phy_power(phy->control_dev, 0);
>>       usb_add_phy_dev(&phy->phy);
>>
>>       platform_set_drvdata(pdev, phy);
>> diff --git a/include/linux/usb/omap_control_usb.h b/include/linux/usb/omap_control_usb.h
>> index 27b5b8c..7f027d3 100644
>> --- a/include/linux/usb/omap_control_usb.h
>> +++ b/include/linux/usb/omap_control_usb.h
>> @@ -22,9 +22,9 @@
> 
>>   struct omap_control_usb {
>>       struct device *dev;
>>
>> -    u32 __iomem *dev_conf;
>>       u32 __iomem *otghs_control;
>> -    u32 __iomem *phy_power;
>> +    u32 __iomem *power;
>> +    u32 __iomem *power_aux;
>>
>>       struct clk *sys_clk;
>>
> you can remove omap_control_usb_platform_data from here.
> 
OK.

cheers,
-roger
