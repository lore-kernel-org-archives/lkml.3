Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3FSHhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:37:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36569 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab3FSHg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:36:59 -0400
Message-ID: <51C15F7E.5020305@ti.com>
Date: Wed, 19 Jun 2013 10:36:30 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
References: <1371571487-14389-1-git-send-email-rogerq@ti.com> <1371571487-14389-2-git-send-email-rogerq@ti.com> <51C106A1.9030001@ti.com>
In-Reply-To: <51C106A1.9030001@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On 06/19/2013 04:17 AM, Benoit Cousson wrote:
> Hi Roger,
> 
> On 06/18/2013 11:04 AM, Roger Quadros wrote:
>> Provide the RESET and Power regulators for the USB PHY,
>> the USB Host port mode and the PHY device.
>>
>> Also provide pin multiplexer information for the USB host
>> pins.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>   arch/arm/boot/dts/omap4-panda-common.dtsi |   62 +++++++++++++++++++++++++++++
>>   1 files changed, 62 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
>> index 00cbaa5..7a21e8e 100644
>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
>> @@ -59,6 +59,42 @@
>>               "AFML", "Line In",
>>               "AFMR", "Line In";
>>       };
>> +
>> +    /* HS USB Port 1 RESET */
>> +    hsusb1_reset: hsusb1_reset_reg {
>> +        compatible = "regulator-fixed";
>> +        regulator-name = "hsusb1_reset";
>> +        regulator-min-microvolt = <3300000>;
>> +        regulator-max-microvolt = <3300000>;
>> +        gpio = <&gpio2 30 0>;    /* gpio_62 */
>> +        startup-delay-us = <70000>;
>> +        enable-active-high;
>> +    };
> 
> Is this really a regulator? Or just a GPIO line used to reset the USB PHY?

It is in fact a GPIO line used as reset.
> 
> If this is the case, I don't think it should be represented as a regulator.

Why not? I think it fits very well in the regulator device model. I couldn't find a better
way to represent this. It gives us a way to specify not only the GPIO line but also
the polarity. I know mostly reset is active low but still there is flexibility as you never
know for sure.

Do you have any better ideas?

FYI. The USB PHY driver is already treating reset as a regulator and is into 3.10. Reworking that
will take some time. Not getting these in will prevent USB host/ethernet support on panda.

cheers,
-roger

