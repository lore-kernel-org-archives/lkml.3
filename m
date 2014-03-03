Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaCCOvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:51:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56214 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbaCCOvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:51:07 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>, <nm@ti.com>,
        <balajitk@ti.com>, <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND Patch 3/9] ARM: dts: am43x-epos-evm: add SD card hotplug support
Date: Mon, 3 Mar 2014 20:20:20 +0530
Message-ID: <1393858226-32595-5-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balaji T K <balajitk@ti.com>

Add card detect gpio for SD card slot and include dt gpio header.

Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi        | 1 +
 arch/arm/boot/dts/am43x-epos-evm.dts | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index b687869..36d523a 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -8,6 +8,7 @@
  * kind, whether express or implied.
  */
 
+#include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index a3a53ce..167dbc8 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -132,6 +132,12 @@
 				0x19c (PIN_OUTPUT | MUX_MODE3)          /* mcasp0_ahclkr.spi1_cs0 */
 			>;
 		};
+
+		mmc1_pins: pinmux_mmc1_pins {
+			pinctrl-single,pins = <
+				0x160 (PIN_INPUT | MUX_MODE7) /* spi0_cs1.gpio0_6 */
+			>;
+		};
 	};
 
 	matrix_keypad: matrix_keypad@0 {
@@ -179,6 +185,9 @@
 	status = "okay";
 	vmmc-supply = <&vmmcsd_fixed>;
 	bus-width = <4>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+	cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
 };
 
 &mac {
-- 
1.9.0

