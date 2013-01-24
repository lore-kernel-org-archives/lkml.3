Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab3AXLfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:35:00 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53530 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3AXLex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:34:53 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <anilkumar@ti.com>, <tony@atomide.com>, <hs@denx.de>,
        <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <rob@landley.net>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [PATCH 2/6] ARM: davinci: da850: add DT node for I2C0
Date: Thu, 24 Jan 2013 17:05:24 +0530
Message-ID: <1359027324-14534-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C0 device tree node information to da850-evm.
Also, add I2C0 pin muxing information in da850-evm.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
Depends on patch 
http://comments.gmane.org/gmane.linux.davinci/25993

 arch/arm/boot/dts/da850-evm.dts |   15 +++++++++++++++
 arch/arm/boot/dts/da850.dtsi    |   10 ++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 8cac9d2..3d8290a 100755
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -27,5 +27,20 @@
 		serial2: serial@1d0d000 {
 			status = "okay";
 		};
+		i2c0@1c22000 {
+			status = "okay";
+		};
+	};
+};
+&pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&i2c0_pins
+	>;
+
+	i2c0_pins: pinmux_i2c0_pins{
+		pinctrl-single,bits = <
+			0x10 0x00002200 0x0000ff00	/* I2C0_SDA,I2C0_SCL */
+		>;
 	};
 };
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 1e6d090..f5ee811 100755
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -66,5 +66,15 @@
 			interrupt-parent = <&intc>;
 			status = "disabled";
 		};
+		i2c0@1c22000 {
+			compatible = "ti,davinci-i2c";
+			reg = <0x22000 0x1000>;
+			clock-frequency = <100000>;
+			interrupts = <15>;
+			interrupt-parent = <&intc>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.4.1

