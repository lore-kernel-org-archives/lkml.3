Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbaCEUwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:52:53 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:47501 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbaCEUwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:52:49 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org
Cc: hns@goldelico.com, sre@debian.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2] Documentation: DT: Document twl4030-madc-battery bindings.
Date: Wed,  5 Mar 2014 21:52:19 +0100
Message-Id: <1394052739-8589-4-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394052739-8589-1-git-send-email-marek@goldelico.com>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 .../bindings/power_supply/twl4030_madc_battery.txt | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt

diff --git a/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
new file mode 100644
index 0000000..fd0b6d2
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
@@ -0,0 +1,43 @@
+twl4030_madc_battery
+
+Required properties:
+ - compatible : "ti,twl4030-madc-battery"
+ - capacity : battery capacity in uAh
+ - charging-calibration-data : list of voltage(mV):level(%) values
+	for charging calibration (see example)
+ - discharging-calibration-data : list of voltage(mV):level(%) values
+	for discharging calibration (see example)
+ - io-channels: Should contain IIO channel specifiers
+	for each element in io-channel-names.
+- io-channel-names: Should contain the following values:
+ * "temp" - The ADC channel for temperature reading
+ * "ichg" - The ADC channel for battery charging status
+ * "vbat" - The ADC channel to measure the battery voltage
+
+Example:
+	madc-battery {
+		compatible = "ti,twl4030-madc-battery";
+		capacity = <1200000>;
+		charging-calibration-data = <4200 100
+					     4100 75
+					     4000 55
+					     3900 25
+					     3800 5
+					     3700 2
+					     3600 1
+					     3300 0>;
+
+		discharging-calibration-data = <4200 100
+						4100 95
+						4000 70
+						3800 50
+						3700 10
+						3600 5
+						3300 0>;
+		io-channels = <&twl_madc 1>,
+	                      <&twl_madc 10>,
+			      <&twl_madc 12>;
+		io-channel-names = "temp",
+		                   "ichg",
+		                   "vbat";
+	};
-- 
1.8.3.2

