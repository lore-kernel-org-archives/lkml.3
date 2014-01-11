Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaAKAsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:48:18 -0500
Received: from ring0.de ([91.143.88.219]:47976 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbaAKAsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:48:05 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv3] dt: binding documentation for bq2415x charger
Date: Sat, 11 Jan 2014 01:47:48 +0100
Message-Id: <1389401268-15069-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389393286-15263-1-git-send-email-sre@debian.org>
References: <1389393286-15263-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for bq2415x charger.

Signed-off-by: Sebastian Reichel <sre@debian.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
Hi,

It's me again :) Here's another update, which fixes a sentence reported by
Pavel. I also added his Acked-by.

-- Sebastian
---
 .../devicetree/bindings/power/bq2415x.txt          | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/bq2415x.txt

diff --git a/Documentation/devicetree/bindings/power/bq2415x.txt b/Documentation/devicetree/bindings/power/bq2415x.txt
new file mode 100644
index 0000000..d0327f0
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/bq2415x.txt
@@ -0,0 +1,47 @@
+Binding for TI bq2415x Li-Ion Charger
+
+Required properties:
+- compatible: Should contain one of the following:
+ * "ti,bq24150"
+ * "ti,bq24150"
+ * "ti,bq24150a"
+ * "ti,bq24151"
+ * "ti,bq24151a"
+ * "ti,bq24152"
+ * "ti,bq24153"
+ * "ti,bq24153a"
+ * "ti,bq24155"
+ * "ti,bq24156"
+ * "ti,bq24156a"
+ * "ti,bq24158"
+- reg:			   integer, i2c address of the device.
+- ti,current-limit:	   integer, initial maximum current charger can pull
+			   from power supply in mA.
+- ti,weak-battery-voltage: integer, weak battery voltage threshold in mV.
+			   The chip will use slow precharge if battery voltage
+			   is below this value.
+- ti,battery-regulation-voltage: integer, maximum charging voltage in mV.
+- ti,charge-current:	   integer, maximum charging current in mA.
+- ti,termination-current:  integer, charge will be terminated when current in
+			   constant-voltage phase drops below this value (in mA).
+- ti,resistor-sense:	   integer, value of sensing resistor in milliohm.
+
+Optional properties:
+- ti,usb-charger-detection: phandle to usb charger detection device.
+			    (required for auto mode)
+
+Example from Nokia N900:
+
+bq24150a {
+	compatible = "ti,bq24150a";
+	reg = <0x6b>;
+
+	ti,current-limit = <100>;
+	ti,weak-battery-voltage = <3400>;
+	ti,battery-regulation-voltage = <4200>;
+	ti,charge-current = <650>;
+	ti,termination-current = <100>;
+	ti,resistor-sense = <68>;
+
+	ti,usb-charger-detection = <&isp1704>;
+};
-- 
1.8.5.2

