Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760620AbaJ1HIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:08:19 -0400
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:53403 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758774AbaJ1HIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:08:10 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: sre@kernel.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, devicetree@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] Add devicetree binding documentation for the LTC2941/LTC2943 driver
Date: Tue, 28 Oct 2014 08:08:04 +0100
Message-Id: <1414480084-3604-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141027163842.GB20765@earth.universe>
References: <20141027163842.GB20765@earth.universe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the devicetree binding documentation for the LTC2941 and LTC2943
driver. These are I2C connected battery gas gauge ICs.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 .../devicetree/bindings/power/ltc2941.txt          |   27 ++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/ltc2941.txt

diff --git a/Documentation/devicetree/bindings/power/ltc2941.txt b/Documentation/devicetree/bindings/power/ltc2941.txt
new file mode 100644
index 0000000..ea42ae1
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/ltc2941.txt
@@ -0,0 +1,27 @@
+binding for LTC2941 and LTC2943 battery gauges
+
+Both the LTC2941 and LTC2943 measure battery capacity.
+The LTC2943 is compatible with the LTC2941, it adds voltage and
+temperature monitoring, and uses a slightly different conversion
+formula for the charge counter.
+
+Required properties:
+- compatible: Should contain "ltc2941" or "ltc2943" which also indicates the
+    type of I2C chip attached.
+- reg: The 7-bit I2C address.
+- lltc,resistor-sense: The sense resistor value in milli-ohms. Can be a 32-bit
+    negative value when the battery has been connected to the wrong end of the
+    resistor.
+- lltc,prescaler-exponent: The prescaler exponent as explained in the datasheet.
+    This determines the range and accuracy of the gauge. The value is programmed
+    into the chip only if it differs from the current setting. The setting is
+    lost when the battery is disconnected.
+
+Example from the Topic Miami Florida board:
+
+	fuelgauge: ltc2943@64 {
+		compatible = "ltc2943";
+		reg = <0x64>;
+		lltc,resistor-sense = <15>;
+		lltc,prescaler-exponent = <5>; /* 2^(2*5) = 1024 */
+	};
-- 
1.7.9.5

