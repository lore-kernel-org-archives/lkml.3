Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaCUUKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:10:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58687 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751831AbaCUUI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:08:58 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v2 2/5] clk: berlin: add berlin clocks DT bindings documentation
Date: Fri, 21 Mar 2014 21:08:38 +0100
Message-Id: <1395432521-11055-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the device tree bindings for the PLLs found on the Marvell Berlin SoCs.

Cc: devicetree@vger.kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 .../devicetree/bindings/clock/berlin-clock.txt     | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/berlin-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/berlin-clock.txt b/Documentation/devicetree/bindings/clock/berlin-clock.txt
new file mode 100644
index 000000000000..49b7860bffb8
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/berlin-clock.txt
@@ -0,0 +1,29 @@
+Device Tree Clock bindings for Marvell Berlin clocks
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible: shall be one of the following:
+	"marvell,berlin2-pll",
+	"marvell,berlin2q-pll":
+		CPU PLL and System PLL
+- reg: Address and length of the clock register set.
+- #clock-cells: from common clock binding; shall be set to 0.
+- clocks: from common clock binding
+
+smclk: sysmgr-clock {
+	compatible = "fixed-clock";
+	#clock-cells = <0>;
+	clock-frequency = <25000000>;
+};
+
+cpupll: cpupll@ea003c {
+	compatible = "marvell,berlin2-pll";
+	clocks = <&smclk>;
+	#clock-cells = <0>;
+	reg = <0xea003c 0x8>;
+};
+
+
-- 
1.8.3.2

