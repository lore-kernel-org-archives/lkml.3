Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab3E0OiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:38:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35674 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777Ab3E0OiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:38:11 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Ankur Kishore <a-kishore@ti.com>
Subject: [PATCH v2 14/14] ARM: dts: AM43x: initial support
Date: Mon, 27 May 2013 20:07:36 +0530
Message-ID: <3790fa57fc4c69da12224fbcec17cd07c59771a0.1369658705.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
References: <cover.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT source (minimal) for AM4372 SoC to represent AM43x SoC's. Those
represented here are the minimal DT nodes necessary to get kernel
booting.

In DT nodes, "ti,hwmod" property has not been added, this would be
added along with PRCM support for AM43x.

Signed-off-by: Ankur Kishore <a-kishore@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v2: Add gptimer 1ms, timer2, synctimer and remove twd local timer

 arch/arm/boot/dts/am4372.dtsi | 66 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 arch/arm/boot/dts/am4372.dtsi

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
new file mode 100644
index 0000000..1d58298
--- /dev/null
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -0,0 +1,66 @@
+/*
+ * Device Tree Source for AM4372 SoC
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "ti,am4372", "ti,am43";
+	interrupt-parent = <&gic>;
+
+
+	aliases {
+		serial0 = &uart1;
+	};
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+		};
+	};
+
+	gic: interrupt-controller@48241000 {
+		compatible = "arm,cortex-a9-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = <0x48241000 0x1000>,
+		      <0x48240100 0x0100>;
+	};
+
+	ocp {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		uart1: serial@44e09000 {
+			compatible = "ti,am4372-uart","ti,omap2-uart";
+			reg = <0x44e09000 0x2000>;
+			interrupts = <0 72 0x4>;
+		};
+
+		timer1: timer@44e31000 {
+			compatible = "ti,am4372-timer-1ms","ti,am335x-timer-1ms";
+			reg = <0x44e31000 0x400>;
+			interrupts = <0 67 0x4>;
+			ti,timer-alwon;
+		};
+
+		timer2: timer@48040000  {
+			compatible = "ti,am4372-timer","ti,am335x-timer";
+			reg = <0x48040000  0x400>;
+			interrupts = <0 68 0x4>;
+		};
+
+		counter32k: counter@44e86000 {
+			compatible = "ti,am4372-counter32k","ti,omap-counter32k";
+			reg = <0x44e86000 0x40>;
+		};
+	};
+};
-- 
1.7.12

