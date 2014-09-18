Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaIRHcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:32:22 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50891 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaIRHcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:32:18 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        lee.jones@linaro.org, broonie@kernel.org,
        Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] dt-bindings: add devicetree bindings for st-pwm regulator
Date: Thu, 18 Sep 2014 15:31:45 +0800
Message-Id: <1411025505-21628-3-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411025505-21628-1-git-send-email-zyw@rock-chips.com>
References: <1411025505-21628-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the st-pwm regulator

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v2:
Adviced by Lee Jones
- rename the documentation
Adviced by Doug Anderson
- update the example
Adviced by Mark Rutland
- remove pwm-reg-period

 .../bindings/regulator/pwm-regulator.txt           |   29 ++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/pwm-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/pwm-regulator.txt b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
new file mode 100644
index 0000000..7c62a30
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
@@ -0,0 +1,29 @@
+pwm regulator bindings
+
+Required properties:
+  - compatible: Should be "pwm-regulator"
+  - pwms: OF device-tree PWM specification (see PWM binding pwm.txt)
+  - voltage-table: voltage and duty table, include 2 merbers in each set of
+    brackets, first one is voltage(unit: uv), the next is duty(unit: percent)
+
+Any property defined as part of the core regulator binding defined in
+regulator.txt can also be used.
+
+Example:
+	pwm_regulator {
+		compatible = "pwm-regulator;
+		pwms = <&pwm1 0 1000000 0>;
+
+		voltage-table = <1114000 0>,
+				<1095000 10>,
+				<1076000 20>,
+				<1056000 30>,
+				<1036000 40>,
+				<1016000 50>;
+
+		regulator-always-on;
+		regulator-boot-on;
+		regulator-min-microvolt = <1016000>;
+		regulator-max-microvolt = <1114000>;
+		regulator-name = "vdd_logic";
+	};
-- 
1.7.9.5

