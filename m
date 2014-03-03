Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaCCO4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:56:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32864 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbaCCOvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:51:09 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>, <nm@ti.com>,
        <balajitk@ti.com>, <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND Patch 1/9] ARM: dts: am437x gp-evm: add sd card dt nodes
Date: Mon, 3 Mar 2014 20:20:18 +0530
Message-ID: <1393858226-32595-3-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

enable sd card slot on am437x-gp-evm

Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/am437x-gp-evm.dts | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index 4eb72b8..df8798e 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -19,6 +19,14 @@
 	model = "TI AM437x GP EVM";
 	compatible = "ti,am437x-gp-evm","ti,am4372","ti,am43";
 
+	vmmcsd_fixed: fixedregulator-sd {
+		compatible = "regulator-fixed";
+		regulator-name = "vmmcsd_fixed";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		enable-active-high;
+	};
+
 	backlight {
 		compatible = "pwm-backlight";
 		pwms = <&ecap0 0 50000 PWM_POLARITY_INVERTED>;
@@ -62,6 +70,12 @@
 		>;
 	};
 
+	mmc1_pins: pinmux_mmc1_pins {
+		pinctrl-single,pins = <
+			0x160 (PIN_INPUT | MUX_MODE7) /* spi0_cs1.gpio0_6 */
+		>;
+	};
+
 	ecap0_pins: backlight_pins {
 		pinctrl-single,pins = <
 			0x164 MUX_MODE0       /* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
@@ -91,6 +105,10 @@
 	pinctrl-0 = <&ecap0_pins>;
 };
 
+&gpio0 {
+	status = "okay";
+};
+
 &gpio3 {
 	status = "okay";
 };
@@ -98,3 +116,12 @@
 &gpio4 {
 	status = "okay";
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&vmmcsd_fixed>;
+	bus-width = <4>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
+};
-- 
1.9.0

