Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbaCTOxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:53:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29194 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542AbaCTOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:59 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-17-532b008daa4a
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH/RFC 7/8] DT: Add documentation for the mfd Maxim max77693 flash
 cell
Date: Thu, 20 Mar 2014 15:51:09 +0100
Message-id: <1395327070-20215-8-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd0+Bu1gg8XPmC1urTvHajH/CJDo
	f7OQ1eLcq5WMFr1XnzNanG16w25xedccNoutb9YxWvRs2MpqsfT6RSaLCdPXsli07j3CbnH4
	TTurA6/HmnlrGD0u9/Uyeaxc/oXNY9OqTjaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyuhe
	0chacEysYvbm3YwNjGuEuhg5OSQETCSuTZ7KDGGLSVy4t56ti5GLQ0hgOqPE69/nwBJCAp1M
	Ens3iIDYbAKGEj9fvGYCsUUEyiWmTX3EBNLALLCNSWJT8zcWkISwQJjE6zUrwIpYBFQlPh3t
	YASxeQU8JDa9uMHaxcgBtE1BYs4kG5Awp4CnxNKlXcwgYSGgkrMTIyYw8i5gZFjFKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJERyYz6R3MK5qsDjEKMDBqMTDu2KPZrAQa2JZcWXuIUYJDmYl
	EV6751rBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhi7
	jml/WHNZZv1Mjp4U/rvL512uY7jGvedQ4KW9m7Rsnq4XrcyydJFfXKSxplqLOf7zlpbac30T
	6gL435SLrC9L7vKUkWp7xOstXpPFGnjz57KZ4hoyd014flTUvF5aWqXEfayIvYPZ5pJWbOX3
	MCPHSY1L/i/eczjx3tTtSVHz4lduPHcpzEaJpTgj0VCLuag4EQDSrNeWSAIAAA==
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
index 11921cc..9e1aa97 100644
--- a/Documentation/devicetree/bindings/mfd/max77693.txt
+++ b/Documentation/devicetree/bindings/mfd/max77693.txt
@@ -27,6 +27,43 @@ Optional properties:
 
 	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
 
+Optional node:
+- led-flash : the LED submodule device node
+
+Required properties of "led-flash" node:
+- compatible : must be "maxim,max77693-led"
+
+Optional properties of "led-flash" node:
+- maxim,iout : Array of four intensities in microampheres of the current
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
+			compatible = "maxim,max77693-led";
+			maxim,iout = <625000 625000 250000 250000>;
+			maxim,trigger = <5 5 6 0>;
+			maxim,trigger-type = <0 1>;
+			maxim,timeout = <500000 0>;
+			maxim,boost-mode = <1 1>;
+			maxim,boost-vout = <5000>;
+			maxim,vsys-min = <2400>;
+		};
 	};
-- 
1.7.9.5

