Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaC1Pdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:33:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29986 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaC1P3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:29:43 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-f6-53359565fd2a
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v2 5/8] DT: Add documentation for the mfd Maxim max77693
 flash cell
Date: Fri, 28 Mar 2014 16:29:02 +0100
Message-id: <1396020545-15727-6-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQd20qabBBiduM1ncWneO1WL+ESDR
	/2Yhq8W5VysZLXqvPme0ONv0ht3i8q45bBZb36xjtOjZsJXVYun1i0wWE6avZbFo3XuE3eLw
	m3ZWB16PNfPWMHpc7utl8li5/Aubx6ZVnWwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAldH0
	o5Ol4JJYxcOuTqYGxu1CXYycHBICJhLT3h1lhbDFJC7cW88GYgsJTGeUuLoNqIYLyO5kkti7
	tosFJMEmYCjx88VrJhBbRKBcYtrUR0wgRcwC25gkNjV/AysSFoiUWPdoGdgkFgFVifmnLoPZ
	vAIeEtcvnQfaxgG0TUFiziQbkDCngKfE7RftjBCLPSS+zDnJPoGRdwEjwypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4NB8JrWDcWWDxSFGAQ5GJR5egVbTYCHWxLLiytxDjBIczEoivFkT
	gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoY22+Yla10
	Xbhy16W562+xz6pTcvlQ79z0hMFRb09uYNvvL3esPI77fypTYwrbwSivyFJgsXrZaQGLDx59
	k5NfNZz1lIgW677w/dymGx/c31sdi00ql1+9cX+P46KuT1Pt5577soKzSrC/oSBI2urNysSr
	meeebOrcoZvzwyY1PeRiEo+I/EtRJZbijERDLeai4kQAdfUDg0kCAAA=
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
 Documentation/devicetree/bindings/mfd/max77693.txt |   47 ++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc..7a9a4d5 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,43 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+Optional node:
+- led-flash : the LED submodule device node
+
+Required properties of "led-flash" node:
+- compatible : must be "maxim,max77693-flash"
+
+Optional properties of "led-flash" node:
+- maxim,iout : Array of four maximum intensities in microampheres of the current
+	in order: flash1, flash2, torch1, torch2.
+	Range:
+		flash - 15625 - 1000000,
+		torch - 15625 - 250000.
+- maxim,trigger : Array of flags indicating which trigger can activate given led
+	in order: flash1, flash2, torch1, torch2.
+	Possible flag values (can be combined):
+		1 - FLASH pin of the chip,
+		2 - TORCH pin of the chip,
+		4 - software via I2C command.
+- maxim,trigger-type : Array of trigger types in order: flash, torch.
+	Possible trigger types:
+		0 - Rising edge of the signal triggers the flash/torch,
+		1 - Signal level controls duration of the flash/torch.
+- maxim,timeout : Array of timeouts in microseconds after which leds are
+	turned off in order: flash, torch.
+	Range:
+		flash: 62500 - 1000000,
+		torch: 0 (no timeout) - 15728000.
+- maxim,boost-mode : Array of the flash boost modes in order: flash1, flash2.
+	Possible values:
+		0 - no boost,
+		1 - adaptive mode,
+		2 - fixed mode.
+- maxim,boost-vout : Output voltage of the boost module in millivolts.
+- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
+	if chip estimates that system voltage could drop below this level due
+	to flash power consumption.
+
 Example:
 	max77693@66 {
 		compatible = "maxim,max77693";
@@ -52,4 +89,14 @@ Example:
 					regulator-boot-on;
 			};
 		};
+		led_flash: led-flash {
+			compatible = "maxim,max77693-flash";
+			maxim,iout = <625000 625000 250000 250000>;
+			maxim,trigger = <5 5 6 6>;
+			maxim,trigger-type = <0 1>;
+			maxim,timeout = <500000 0>;
+			maxim,boost-mode = <1 1>;
+			maxim,boost-vout = <5000>;
+			maxim,vsys-min = <2400>;
+		};
 	};
-- 
1.7.9.5

