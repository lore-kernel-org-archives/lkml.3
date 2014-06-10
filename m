Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaFJNrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 09:47:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55311 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751276AbaFJNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 09:47:23 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 1/2] i2c: sunxi: add P2WI DT bindings documentation
Date: Tue, 10 Jun 2014 15:47:15 +0200
Message-Id: <1402408036-5235-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

P2WI (Push/Pull 2 Wire Interface) is an SMBus like bus used to communicate
with some PMICs (like the AXP221).

Document P2WI DT bindings which are pretty much the same as the one defined
for the marvell's mv64xxx controller.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/i2c/i2c-sunxi-p2wi.txt     | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-sunxi-p2wi.txt

diff --git a/Documentation/devicetree/bindings/i2c/i2c-sunxi-p2wi.txt b/Documentation/devicetree/bindings/i2c/i2c-sunxi-p2wi.txt
new file mode 100644
index 0000000..6b76548
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-sunxi-p2wi.txt
@@ -0,0 +1,41 @@
+
+* Allwinner P2WI (Push/Pull 2 Wire Interface) controller
+
+Required properties :
+
+ - reg             : Offset and length of the register set for the device.
+ - compatible      : Should one of the following:
+                     - "allwinner,sun6i-a31-p2wi"
+ - interrupts      : The interrupt line connected to the P2WI peripheral.
+ - clocks          : The gate clk connected to the P2WI peripheral.
+ - resets          : The reset line connected to the P2WI peripheral.
+
+Optional properties :
+
+ - clock-frequency : Desired P2WI bus clock frequency in Hz. If not set the
+default frequency is 100kHz
+
+A P2WI may contain one child node encoding a P2WI slave device.
+
+Slave device properties:
+  Required properties:
+   - reg           : the I2C slave address used during the initialization
+                     process to switch from I2C to P2WI mode
+
+Example:
+
+	p2wi@01f03400 {
+		compatible = "allwinner,sun6i-a31-p2wi";
+		reg = <0x01f03400 0x400>;
+		interrupts = <0 39 4>;
+		clocks = <&apb0_gates 3>;
+		clock-frequency = <6000000>;
+		resets = <&apb0_rst 3>;
+
+		axp221: pmic@68 {
+			compatible = "x-powers,axp221";
+			reg = <0x68>;
+
+			/* ... */
+		};
+	};
-- 
1.8.3.2

