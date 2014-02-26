Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaBZAqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:46:38 -0500
Received: from ring0.de ([5.45.105.125]:47402 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaBZAqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:46:32 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Marek Belisko <marek@goldelico.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv1 2/2] Documentation: DT: Document rx51-battery binding
Date: Wed, 26 Feb 2014 01:46:09 +0100
Message-Id: <1393375569-21751-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393375569-21751-1-git-send-email-sre@debian.org>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for rx51-battery,
which is a simple A/D converter consumer.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/power/rx51-battery.txt     | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/rx51-battery.txt

diff --git a/Documentation/devicetree/bindings/power/rx51-battery.txt b/Documentation/devicetree/bindings/power/rx51-battery.txt
new file mode 100644
index 0000000..9043845
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/rx51-battery.txt
@@ -0,0 +1,25 @@
+Binding for Nokia N900 battery
+
+The Nokia N900 battery status can be read via the TWL4030's A/D converter.
+
+Required properties:
+- compatible: Should contain one of the following:
+ * "nokia,n900-battery"
+- io-channels: Should contain IIO channel specifiers
+               for each element in io-channel-names.
+- io-channel-names: Should contain the following values:
+ * "temp" - The ADC channel for temperature reading
+ * "bsi"  - The ADC channel for battery size identification
+ * "vbat" - The ADC channel to measure the battery voltage
+
+Example from Nokia N900:
+
+battery: n900-battery {
+	compatible = "nokia,n900-battery";
+	io-channels = <&twl4030_madc 0>,
+		      <&twl4030_madc 4>,
+		      <&twl4030_madc 12>;
+	io-channel-names = "temp",
+			   "bsi",
+			   "vbat";
+};
-- 
1.8.5.3

