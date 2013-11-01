Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3KAIA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:00:56 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:44182 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3KAIAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:00:55 -0400
From: Bo Shen <voice.shen@atmel.com>
To: devicetree@vger.kernel.org
Cc: plagnioj@jcrosoft.com, nicolas.ferre@atmel.com,
        alexandre.belloni@free-electrons.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Bo Shen <voice.shen@atmel.com>
Subject: [PATCH v6 2/2] PWM: atmel-pwm: add device tree binding document
Date: Fri,  1 Nov 2013 16:00:11 +0800
Message-Id: <1383292811-11343-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add atmel pwm driver device tree binding document

Signed-off-by: Bo Shen <voice.shen@atmel.com>

---
Changes in v6:
  - New, split binding document as a separate patch

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/pwm/atmel-pwm.txt          |   41 ++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt

diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
new file mode 100644
index 0000000..1c1a5fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
@@ -0,0 +1,41 @@
+Atmel PWM controller
+
+Required properties:
+  - compatible: should be one of:
+    - "atmel,at91sam9rl-pwm"
+    - "atmel,sama5d3-pwm"
+  - reg: physical base address and length of the controller's registers
+  - #pwm-cells: Should be 3. See pwm.txt in this directory for a
+    description of the cells format
+
+Example:
+
+	pwm0: pwm@f8034000 {
+		compatible = "atmel,at91sam9rl-pwm";
+		reg = <0xf8034000 0x400>;
+		#pwm-cells = <3>;
+	};
+
+The following the pwm led based example:
+
+	pwm0: pwm@f8034000 {
+		compatible = "atmel,at91sam9rl-pwm";
+		reg = <0xf8034000 0x400>;
+		#pwm-cells = <3>;
+	};
+
+	pwdleds {
+		compatible = "pwm-leds";
+
+		d1 {
+			label = "d1";
+			pwms = <&pwm0 3 5000 0>
+			max-brightness = <255>;
+		};
+
+		d2 {
+			label = "d2";
+			pwms = <&pwm0 1 5000 1>
+			max-brightness = <255>;
+		};
+	};
-- 
1.7.9.5

