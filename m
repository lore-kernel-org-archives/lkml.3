Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaDKO6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:58:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43428 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbaDKO5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:57:43 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-30-534802e5178e
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC v3 4/5] DT: Add documentation for the mfd Maxim max77693
 flash cell
Date: Fri, 11 Apr 2014 16:56:55 +0200
Message-id: <1397228216-6657-5-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd2nTB7BBgd/WljcWneO1WL+ESDR
	/2Yhq8W5VysZLXqvPme0ONv0ht3i8q45bBZb36xjtOjZsJXVYun1i0wWE6avZbFo3XuE3eLw
	m3ZWB16PNfPWMHpc7utl8li5/Aubx6ZVnWwefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbHp
	+i/Wgj1SFR+urmJrYFwu2sXIySEhYCIx+0kPM4QtJnHh3nq2LkYuDiGBRYwSn2f8YIZw2pkk
	ri/sZwGpYhMwlPj54jUTiC0iUC4xbeojJpAiZoFtTBKbmr8BFXFwCAtESnQelgWpYRFQlfh1
	Zh7YBl4Bd4kZ67qYQEokBBQk5kyyAQlzCnhI3Hm4Bmy8EFDJsedTmSYw8i5gZFjFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERyaz6R3MK5qsDjEKMDBqMTDe+CSW7AQa2JZcWXuIUYJDmYl
	Ed5NV92DhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTAG
	Oqk/mH5u3+a4L6kZb+ad0iy7lc515ETIvn1au3hcpu844dCmtPNTncR9pd8LWnodWw9mHbDJ
	f7Np/aHV2R2+Nc4xxc6cV/+579WewPZH5IL7DKM9+lutXA0W/ZLamRq+d29+e+nksC089jqv
	zL35DfatFxEpU7lQfuh/iMw/+4JLRnPX/bqhxFKckWioxVxUnAgAGkcie0kCAAA=
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
 Documentation/devicetree/bindings/mfd/max77693.txt |   57 ++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
index 11921cc..f58d192 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,53 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+Optional node:
+- led-flash : the LED submodule device node
+
+Required properties of "led-flash" node:
+- compatible : must be "maxim,max77693-flash"
+
+Optional properties of "led-flash" node:
+- maxim,iout : Array of four maximum intensities in microamperes of the current
+	in order: flash1, flash2, torch1, torch2.
+	Range:
+		flash - 15625 - 1000000 (max 625000 if boost mode
+					 is enabled for both outputs),
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
+	If both current outputs are connected then the same non-zero value
+	has to be set for them. This setting influences also maximum
+	current value for torch and flash modes:
+		flash1 and flash2 set to 1 or 2:
+			- max flash current: 1250 mA (625 mA on each output)
+			- max torch current: 500 mA (250 mA on each output)
+		flash1 or flash2 set to 0:
+			- max flash current: 1000 mA
+			- max torch current: 250 mA
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
@@ -52,4 +99,14 @@ Example:
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

