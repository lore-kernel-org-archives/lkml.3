Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab3DZJN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:13:29 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:38470 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab3DZJN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:13:28 -0400
From: Matus Ujhelyi <ujhelyi.m@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.belisko@streamunlimited.com,
        zonque@gmail.com, ujhelyi.m@gmail.com,
        Matus Ujhelyi <matus.ujhelyi@streamunlimited.com>
Subject: [PATCH 1/1] Documentation: add missing documentation for tps65217-bl device tree binding
Date: Fri, 26 Apr 2013 11:12:58 +0200
Message-Id: <1366967578-29906-1-git-send-email-matus.ujhelyi@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matus Ujhelyi <matus.ujhelyi@streamunlimited.com>
---
 .../video/backlight/tps65217-backlight.txt         |   25 ++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt

diff --git a/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
new file mode 100644
index 0000000..cc4ee25
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/tps65217-backlight.txt
@@ -0,0 +1,25 @@
+TPS65217 family of regulators
+
+The TPS65217 chip contains a boost converter and current sinks which can be
+used to drive LEDs for use as backlights.
+
+Required properties:
+- compatible: "ti,tps65217"
+- reg: I2C slave address
+- backlight: node for specifying WLED1 and WLED2 lines in TPS65217
+- isel: selection bit, valid values: 1 for ISEL1 (low-level) and 2 for ISEL2 (high-level)
+- fdim: PWM dimming frequency, valid values: 100, 200, 500, 1000
+
+Each regulator is defined using the standard binding for regulators.
+
+Example:
+
+	tps: tps@24 {
+		reg = <0x24>;
+		compatible = "ti,tps65217";
+		backlight {
+			isel = <1>;  /* 1 - ISET1, 2 ISET2 */
+			fdim = <100>; /* TPS65217_BL_FDIM_100HZ */
+		};
+	};
+
-- 
1.7.9.5

