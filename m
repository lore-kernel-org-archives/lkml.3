Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaIQNI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:08:26 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53751 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaIQNIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:08:24 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dt-bindings: add devicetree bindings for st-pwm regulator
Date: Wed, 17 Sep 2014 21:08:00 +0800
Message-Id: <1410959280-29662-3-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the st-pwm regulator

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

 .../devicetree/bindings/regulator/st-pwm.txt       |   35 ++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/st-pwm.txt

diff --git a/Documentation/devicetree/bindings/regulator/st-pwm.txt b/Documentation/devicetree/bindings/regulator/st-pwm.txt
new file mode 100644
index 0000000..38fec1d
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/st-pwm.txt
@@ -0,0 +1,35 @@
+st pwm regulator bindings
+
+Required properties:
+  - compatible: "pwm-regulator"
+  - pwms: OF device-tree PWM specification (see PWM binding pwm.txt)
+  - voltage-table: voltage and duty table, include 2 merbers in each set of
+    brackets, first one is voltage(unit: uv), the next is duty(unit: percent)
+  - pwm-reg-period: duration (in nanoseconds) of one cycle
+
+Any property defined as part of the core regulator binding defined in
+regulator.txt can also be used.
+
+Example:
+	pwm_regulator {
+                compatible = "st,b2105-pwm-regulator;
+                pwms = <&pwm1 0 1000000 0>;
+
+		voltage-table = <1114000 0>,
+				<1095000 10>,
+				<1076000 20>,
+				<1056000 30>,
+				<1036000 40>,
+				<1016000 50>;
+
+		pwm-reg-period = <8448>;
+		regulators {
+			vdd_logic: pwm-regulator {
+				regulator-always-on;
+				regulator-boot-on;
+				regulator-min-microvolt = <1016000>;
+				regulator-max-microvolt = <1114000>;
+				regulator-name = "vdd_logic";
+			};
+		};
+	};
-- 
1.7.9.5

