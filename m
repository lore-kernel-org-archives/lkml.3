Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaAHFpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 00:45:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50383 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAHFpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 00:45:34 -0500
Message-ID: <52CCE5DD.4040301@ti.com>
Date: Wed, 8 Jan 2014 11:15:01 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] ARM: dts: OMAP5: Add 60MHz clock reference to
 USB Host module
References: <1389096889-22179-1-git-send-email-rogerq@ti.com> <1389096889-22179-2-git-send-email-rogerq@ti.com> <201401071613.39245.arnd@arndb.de>
In-Reply-To: <201401071613.39245.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 08:43 PM, Arnd Bergmann wrote:
> On Tuesday 07 January 2014, Roger Quadros wrote:
>> USB Host driver (drivers/mfd/omap-usb-host.c) expects the 60MHz
>> reference clock to be named "init_60m_fclk". Provide this
>> information.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  arch/arm/boot/dts/omap5.dtsi | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
>> index 2f12a47..e0ab379 100644
>> --- a/arch/arm/boot/dts/omap5.dtsi
>> +++ b/arch/arm/boot/dts/omap5.dtsi
>> @@ -765,6 +765,8 @@
>>                         #address-cells = <1>;
>>                         #size-cells = <1>;
>>                         ranges;
>> +                       clocks = <&l3init_60m_fclk>;
>> +                       clock-names = "init_60m_fclk";
>>  
>>                         usbhsohci: ohci@4a064800 {
>>                                 compatible = "ti,ohci-omap3", "usb-ohci";
> 
> The bindings/mfd/omap-usb-host.txt file doesn't document any clocks.
> Please create another patch to document the clock names in this binding
> before you start putting them into the dtsi file. So far the clock
> names are an implementation detail of Linux as they are not part
> of the binding, and with your patch it becomes part of the ABI.
> 
Right. I'll re-post the series.

cheers,
-roger
