Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaG1GWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:22:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49756 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaG1GWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:22:12 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-patch-review@list.ti.com>
CC: <nm@ti.com>, <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <tony@atomide.com>, <galak@codeaurora.org>, <lokeshvutla@ti.com>
Subject: [PATCH 1/2] ARM: dts: dra72-evm: Enable I2C1 node
Date: Mon, 28 Jul 2014 11:48:53 +0530
Message-ID: <1406528334-4415-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406528334-4415-1-git-send-email-j-keerthy@ti.com>
References: <1406528334-4415-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keerthy J <j-keerthy@ti.com>

I2C1 bus is used for the following peripherals
	P8 connector (MLB)
	TLV320AIC3106 Audio codec
	J15 LCD header
	24WC256 eeprom
	TMP102AIDRLT temperature sensor
	PCF8575 GPIO expander
	PCA9306 i2c voltage translator -> Goes to P9 for comm interface
	P2 expansion connector
	TPS65917 PMIC

The slowest speed of all the peripherals seems to be 400KHz.

Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 arch/arm/boot/dts/dra72-evm.dts |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/boot/dts/dra72-evm.dts b/arch/arm/boot/dts/dra72-evm.dts
index 5147023..1e12862 100644
--- a/arch/arm/boot/dts/dra72-evm.dts
+++ b/arch/arm/boot/dts/dra72-evm.dts
@@ -19,6 +19,22 @@
 	};
 };
 
+&dra7_pmx_core {
+	i2c1_pins: pinmux_i2c1_pins {
+		pinctrl-single,pins = <
+			0x400 (PIN_INPUT | MUX_MODE0) /* i2c1_sda.i2c1_sda */
+			0x404 (PIN_INPUT | MUX_MODE0) /* i2c1_scl.i2c1_scl */
+		>;
+	};
+};
+
+&i2c1 {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c1_pins>;
+	clock-frequency = <400000>;
+};
+
 &uart1 {
 	status = "okay";
 };
-- 
1.7.9.5

