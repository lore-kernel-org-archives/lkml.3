Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaHTNpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:45:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40305 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaHTNpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:45:04 -0400
X-AuditID: cbfee61a-f79e46d00000134f-2d-53f4a65efc3e
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v5 07/10] DT: Add documentation for the mfd Maxim max77693
Date: Wed, 20 Aug 2014 15:44:16 +0200
Message-id: <1408542259-415-8-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd24ZV+CDVq/GlrcWneO1WLjjPWs
	FvOPAFn9bxayWpx7tZLRovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktll6/yGQxYfpaFovW
	vUfYHXg91sxbw+hxua+XyWPl8i9sHptWdbJ59G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bf
	f3PYCy5LV3zZv56xgXGdWBcjJ4eEgInE1O/vGSFsMYkL99azdTFycQgJLGKU+NCzixXCaWeS
	WDJxJxtIFZuAocTPF6+ZQGwRgXKJnvfPwDqYBU4xSZw/0g5WJCzgJ/Hl5VR2EJtFQFXi3aEN
	QA0cHLwCbhJXdyuAmBICChJzJtmAmJwC7hJb3quAFAsBFZx+N5tlAiPvAkaGVYyiqQXJBcVJ
	6bmGesWJucWleel6yfm5mxjBgflMagfjygaLQ4wCHIxKPLwNC74EC7EmlhVX5h5ilOBgVhLh
	be8ECvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamBU/Tdn
	8w9Wv/eXJs/gk9hm0bhu9381jSl2vtPtra9smLD/aqjKldUHeVedPtwRUM94inGN8bUjKm8c
	zl47dNuAX+iq/ENlBqkHhp4yDIpFeY9uNulVRX3nTFryKVjH/KJ/yGa+b3IPWfvObk1c0vfu
	h6HGpCt7GQ+tWPl7s9xM9bs3Fwto/xL9osRSnJFoqMVcVJwIABxmNf1IAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
the flash cell of the Maxim max77693 multifunctional device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
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

