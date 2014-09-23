Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbaIWPyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:54:11 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37124 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbaIWPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:54:08 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, lee.jones@linaro.org,
        broonie@kernel.org, Chris Zhong <zyw@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/2] dt-bindings: add devicetree bindings for st-pwm regulator
Date: Tue, 23 Sep 2014 23:53:42 +0800
Message-Id: <1411487622-10881-3-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411487622-10881-1-git-send-email-zyw@rock-chips.com>
References: <1411487622-10881-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the st-pwm regulator

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>

---

Changes in v6:
Adviced by Mark Rutland
- fix a spelling error

Changes in v4:
Adviced by Doug Anderson
- remove regulator-always-on and regulator-boot-on from the Example

Changes in v3:
Adviced by Doug Anderson
- update the Example

Changes in v2:
Adviced by Lee Jones
- rename the documentation
Adviced by Doug Anderson
- update the example
Adviced by Mark Rutland
- remove pwm-reg-period

 .../bindings/regulator/pwm-regulator.txt           |   27 ++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/pwm-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/pwm-regulator.txt b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
new file mode 100644
index 0000000..ce91f61
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/pwm-regulator.txt
@@ -0,0 +1,27 @@
+pwm regulator bindings
+
+Required properties:
+- compatible: Should be "pwm-regulator"
+- pwms: OF device-tree PWM specification (see PWM binding pwm.txt)
+- voltage-table: voltage and duty table, include 2 members in each set of
+  brackets, first one is voltage(unit: uv), the next is duty(unit: percent)
+
+Any property defined as part of the core regulator binding defined in
+regulator.txt can also be used.
+
+Example:
+	pwm_regulator {
+		compatible = "pwm-regulator;
+		pwms = <&pwm1 0 8448 0>;
+
+		voltage-table = <1114000 0>,
+				<1095000 10>,
+				<1076000 20>,
+				<1056000 30>,
+				<1036000 40>,
+				<1016000 50>;
+
+		regulator-min-microvolt = <1016000>;
+		regulator-max-microvolt = <1114000>;
+		regulator-name = "vdd_logic";
+	};
-- 
1.7.9.5

