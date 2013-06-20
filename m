Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab3FTNCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:02:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40735 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab3FTNCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:02:48 -0400
Message-ID: <51C2FD5B.1090508@ti.com>
Date: Thu, 20 Jun 2013 16:02:19 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>
Subject: Re: [RFC PATCH 5/6] ARM: dts: omap3beagle-xm: Add idle state pins
 for USB host
References: <1371650753-11452-1-git-send-email-rogerq@ti.com> <1371650753-11452-6-git-send-email-rogerq@ti.com> <87obb26ixm.fsf@linaro.org> <51C2EDB1.3080801@ti.com> <51C2EF50.3070707@ti.com>
In-Reply-To: <51C2EF50.3070707@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 03:02 PM, Roger Quadros wrote:
> On 06/20/2013 02:55 PM, Roger Quadros wrote:
>> On 06/19/2013 09:42 PM, Kevin Hilman wrote:
>>> Roger Quadros <rogerq@ti.com> writes:
>>>
>>>> Add the Idle state pins for USB host and enable WAKEUP on
>>>> DIR, DAT0-3, so that the PHY can wakeup the OMAP SoC from
>>>> sleep on any USB activity (e.g. remote wakeup or connect/disconnect).
>>>>
>>>> CC: Benoît Cousson <b-cousson@ti.com>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>
>>> This one doesn't apply...
>>>
>>>> ---
>>>>  arch/arm/boot/dts/omap3-beagle-xm.dts |   29 +++++++++++++++++++++++------
>>>>  1 files changed, 23 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
>>>> index d3808ed..f1d56c2 100644
>>>> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
>>>> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
>>>> @@ -89,12 +89,7 @@
>>>>  };
>>>>  
>>>>  &omap3_pmx_core {
>>>> -	pinctrl-names = "default";
>>>> -	pinctrl-0 = <
>>>> -			&hsusbb2_pins
>>>> -	>;
>>>> -
>>>> -	hsusbb2_pins: pinmux_hsusbb2_pins {
>>>
>>> This omap3_pmx_core section doesn't exist upstream in the xM DTS file
>>> (but does in omap3-beagle.dts.)  
>>>
>>> Is there a dependency patch missing?
>>>
>>
>> Sorry for not mentioning it earlier. This is based on Benoit's tree [1]
>> and you need these patches
>>
>> http://thread.gmane.org/gmane.linux.drivers.devicetree/38383
> 
> Just noticed that this no longer applies today. I'll send a revision soon.
> 

OK. In case you are eager to test, please use the series [1] on l-o on top of Benoit's
for_3.11/_dts branch and then the $subject series with the updated patch 5 below [2].

[1] - [PATCH v5 0/2] ARM: dts: Add USB host support for Beagle-xm

[2] - Updated Patch 5

>From b712a1fb936f65fa05f21fcd2c62fff5628d0628 Mon Sep 17 00:00:00 2001
From: Roger Quadros <rogerq@ti.com>
Date: Wed, 19 Jun 2013 11:14:35 +0300
Subject: [PATCH] ARM: dts: omap3beagle-xm: Add idle state pins for USB host
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add the Idle state pins for USB host and enable WAKEUP on
DIR, DAT0-3, so that the PHY can wakeup the OMAP SoC from
sleep on any USB activity (e.g. remote wakeup or connect/disconnect).

CC: Benoît Cousson <b-cousson@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index 371b1e2..91d19fa 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -113,11 +113,6 @@
 };
 
 &omap3_pmx_core {
-	pinctrl-names = "default";
-	pinctrl-0 = <
-			&hsusbb2_pins
-	>;
-
 	uart3_pins: pinmux_uart3_pins {
 		pinctrl-single,pins = <
 			0x16e (PIN_INPUT | PIN_OFF_WAKEUPENABLE | MUX_MODE0) /* uart3_rx_irrx.uart3_rx_irrx */
@@ -125,7 +120,7 @@
 		>;
 	};
 
-	hsusbb2_pins: pinmux_hsusbb2_pins {
+	hsusb2_pins: pinmux_hsusb2_pins {
 		pinctrl-single,pins = <
 			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
 			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
@@ -141,6 +136,25 @@
 			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
 		>;
 	};
+
+	/* WAKEUP enabled on DIR, DAT0-3 */
+	hsusb2_idle_pins: pinmux_hsusb2_idle_pins {
+		pinctrl-single,pins = <
+			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			0x5c4 (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)			/* etk_d13.hsusb2_nxt */
+			0x5c8 (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			0x5cA (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
+			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
+			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
+			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
+			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
+			0x1ae (PIN_INPUT_PULLDOWN | WAKEUP_EN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
+		>;
+		interrupts = <77>; /* route padconf wakeup to EHCI IRQ */
+	};
 };
 
 &i2c1 {
@@ -223,6 +237,9 @@
 };
 
 &usbhshost {
+	pinctrl-names = "default", "idle";
+	pinctrl-0 = <&hsusb2_pins>;
+	pinctrl-1 = <&hsusb2_idle_pins>;
 	port2-mode = "ehci-phy";
 };
 
-- 
1.7.4.1


