Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaHaTFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:05:33 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:43245 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaHaTF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:05:28 -0400
X-ME-Helo: localhost.localdomain
X-ME-Date: Sun, 31 Aug 2014 21:05:27 +0200
X-ME-IP: 90.38.41.55
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 2/2] regulator: max1586 add device-tree support
Date: Sun, 31 Aug 2014 21:05:13 +0200
Message-Id: <1409511913-15477-2-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1409511913-15477-1-git-send-email-robert.jarzmik@free.fr>
References: <1409511913-15477-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add max1586 regulator device-tree bindings documentation.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 .../bindings/regulator/max1586-regulator.txt       | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/max1586-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/max1586-regulator.txt b/Documentation/devicetree/bindings/regulator/max1586-regulator.txt
new file mode 100644
index 0000000..c050c17
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/max1586-regulator.txt
@@ -0,0 +1,28 @@
+Maxim MAX1586 voltage regulator
+
+Required properties:
+- compatible: must be "maxim,max1586"
+- reg: I2C slave address, usually 0x14
+- v3-gain: integer specifying the V3 gain as per datasheet
+           (1 + R24/R25 + R24/185.5kOhm)
+- any required generic properties defined in regulator.txt
+
+Example:
+
+	i2c_master {
+		max1586@14 {
+			compatible = "maxim,max1586";
+			reg = <0x14>;
+			v3-gain = <1000000>;
+
+			regulators {
+				vcc_core: v3 {
+					regulator-name = "vcc_core";
+					regulator-compatible = "Output_V3";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1705000>;
+					regulator-always-on;
+				};
+			};
+		};
+	};
-- 
2.0.0.rc2

