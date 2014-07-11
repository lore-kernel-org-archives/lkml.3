Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaGKOHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:07:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49215 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaGKOFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:38 -0400
X-AuditID: cbfee61b-f79f86d00000144c-35-53bfef30680a
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v4 17/21] DT: Add documentation for the mfd Maxim max77693
Date: Fri, 11 Jul 2014 16:04:20 +0200
Message-id: <1405087464-13762-18-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQV2D9/uDDQ6ckLG4te4cq8XGGetZ
	LeYfAbL63yxktTj3aiWjRe/V54wWZ5vesFtc3jWHzWLrm3WMFj0btrJaLL1+kcliwvS1LBat
	e4+wO/B6rJm3htHjcl8vk8fK5V/YPDat6mTz6NuyitHj8ya5ALYoLpuU1JzMstQifbsErozu
	PdvYC6ZLVxx6qNPA+F20i5GTQ0LAROLsu9ksELaYxIV769m6GLk4hASmM0ocaupngnDamSQe
	Ne0Dq2ITMJT4+eI1E4gtIlAu0fP+GVgHs8ApJonzR9rZQBLCAn4Sq99dArNZBFQlvh+9ywxi
	8wp4Svx+dpe1i5EDaJ2CxJxJNiBhTqDwwf6bYOVCAh4SD9eeYJ/AyLuAkWEVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnBoPpPewbiqweIQowAHoxIP74k1+4KFWBPLiitzDzFKcDArifBe
	fbM/WIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVANjufip
	dc23Pq9t7PAIXupxPjH/dt+tNu2LEbNluM/8PuuV2VMmrXOqaMEDGdcFJSLr6hMnPpj+yGxj
	54+Yv1FOU/9XrvhvUdE+Z8IG8ynsrQdv9OpUOzL+kjUyOjHZhGn33wV9CxV/X39kyvS4evuN
	4NBNysr90owNthNMt+qcMTLPUUteOP2/EktxRqKhFnNRcSIAGsEpbkkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
the flash cell of the Maxim max77693 multifunctional device.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/max77693.txt |   62 ++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc..0c3db3d 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,55 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+Optional node:
+- led-flash : the LED submodule device node
+
+Required properties of "led-flash" node:
+- compatible : must be "maxim,max77693-flash"
+- maxim,num-leds : number of connected leds
+	Possible values: 1 or 2.
+- maxim,fleds : array of current outputs in order: fled1, fled2
+	Note: both current outputs can be connected to a single led
+	Possible values:
+		0 - the output is left disconnected,
+		1 - a diode is connected to the output.
+
+Optional properties of "led-flash" node:
+- maxim,boost-mode :
+	In boost mode the device can produce up to 1.2A of total current
+	on both outputs. The maximum current on each output is reduced
+	to 625mA then. If maxim,num-leds == <2> boost must be enabled
+	(it defaults to 1 if not set):
+	Possible values:
+		0 - no boost,
+		1 - adaptive mode,
+		2 - fixed mode.
+- iout-torch : Array of maximum intensities in microamperes of the torch
+	led currents in order: fled1, fled2.
+		15625 - 250000
+- iout-flash : Array of maximum intensities in microamperes of the flash
+	led currents in order: fled1, fled2.
+	Range:
+		15625 - 1000000 (max 625000 if boost mode is enabled)
+- flash-timeout : timeout in microseconds after which flash led
+		  is turned off
+	Range:
+		62500 - 1000000
+- maxim,trigger : Array of flags indicating which trigger can activate given led
+	in order: fled1, fled2
+	Possible flag values (can be combined):
+		1 - FLASH pin of the chip,
+		2 - TORCH pin of the chip,
+		4 - software via I2C command.
+- maxim,trigger-type : Array of trigger types in order: flash, torch.
+	Possible trigger types:
+		0 - Rising edge of the signal triggers the flash/torch,
+		1 - Signal level controls duration of the flash/torch.
+- maxim,boost-vout : Output voltage of the boost module in millivolts.
+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
+	if chip estimates that system voltage could drop below this level due
+	to flash power consumption.
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +101,17 @@ Example:
 					regulator-boot-on;
 			};
 		};
+		led_flash: led-flash {
+			compatible = "maxim,max77693-flash";
+			iout-torch = <500000 0>;
+			iout-flash = <1250000 0>;
+			flash-timeout = <1000000 1000000>;
+			maxim,num-leds = <1>;
+			maxim,fleds = <1 1>;
+			maxim,trigger = <7 7>;
+			maxim,trigger-type = <0 1>;
+			maxim,boost-mode = <1>;
+			maxim,boost-vout = <5000>;
+			maxim,vsys-min = <2400>;
+		};
 	};
-- 
1.7.9.5

