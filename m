Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaBZUD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:03:56 -0500
Received: from ring0.de ([5.45.105.125]:53383 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbaBZUDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:03:52 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 6/7] Documentation: DT: Document twl4030-madc binding
Date: Wed, 26 Feb 2014 21:03:09 +0100
Message-Id: <1393444990-28140-7-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393444990-28140-1-git-send-email-sre@debian.org>
References: <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393444990-28140-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for twl4030-madc
analog digital converter.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/iio/adc/twl4030-madc.txt   | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt

diff --git a/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt b/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
new file mode 100644
index 0000000..6bdd214
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
@@ -0,0 +1,24 @@
+* TWL4030 Monitoring Analog to Digital Converter (MADC)
+
+The MADC subsystem in the TWL4030 consists of a 10-bit ADC
+combined with a 16-input analog multiplexer.
+
+Required properties:
+  - compatible: Should contain "ti,twl4030-madc".
+  - interrupts: IRQ line for the MADC submodule.
+  - #io-channel-cells: Should be set to <1>.
+
+Optional properties:
+  - ti,system-uses-second-madc-irq: boolean, set if the second madc irq register
+				    should be used, which is intended to be used
+				    by Co-Processors (e.g. a modem).
+
+Example:
+
+&twl {
+	madc {
+		compatible = "ti,twl4030-madc";
+		interrupts = <3>;
+		#io-channel-cells = <1>;
+	};
+};
-- 
1.8.5.3

