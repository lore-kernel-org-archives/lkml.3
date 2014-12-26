Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaLZMf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:35:28 -0500
Received: from ring0.de ([5.45.105.125]:36831 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbaLZMfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:35:23 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/3] DT Binding for omap3 temperature sensor
Date: Fri, 26 Dec 2014 13:34:52 +0100
Message-Id: <1419597294-21487-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419597294-21487-1-git-send-email-sre@kernel.org>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP34xx and OMAP36xx processors contain a register in the syscon area,
which can be used to determine the SoCs temperature. This provides a
DT binding specification for the temperature monitor.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 .../bindings/hwmon/omap3-temperature.txt           | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/omap3-temperature.txt

diff --git a/Documentation/devicetree/bindings/hwmon/omap3-temperature.txt b/Documentation/devicetree/bindings/hwmon/omap3-temperature.txt
new file mode 100644
index 0000000..99631ad
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/omap3-temperature.txt
@@ -0,0 +1,25 @@
+* OMAP3 temperature sensor
+
+The OMAP34xx and OMAP36xx processors contain a register in the syscon area,
+which can be used to determine the SoCs temperature.
+
+Requires node properties:
+- compatible :	should contain one of
+	- "ti,omap34xx-temperature-sensor" for OMAP34xx
+	- "ti,omap36xx-temperature-sensor" for OMAP36xx
+- syscon :	Should be a phandle to system configuration node which
+		encompases the temperature register
+- clocks :	Should contain 32KHz fclk clock specifier
+- clock-names :	Should contain clock names
+	- "fck" for the 32KHz fclk clock specifier
+
+Example for omap34xx:
+
+/ {
+	temperature-sensor {
+		compatible = "ti,omap34xx-temperature-sensor";
+		syscon = <&omap3_scm_general>;
+		clocks = <&ts_fck>;
+		clock-names = "fck";
+	};
+};
-- 
2.1.3

