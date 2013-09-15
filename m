Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab3IOWHG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 18:07:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278Ab3IOWHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 18:07:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 15/16] arm: dts: add omap5 thermal data
Date: Sun, 15 Sep 2013 18:02:42 -0400
Message-ID: <1379282563-14650-16-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1379282563-14650-1-git-send-email-eduardo.valentin@ti.com>
References: <1379282563-14650-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the dtsi entry on omap5 to contain
the thermal data. This data will enable the passive
cooling with CPUfreq cooling device at 100C. The
system will do a thermal shutdown at 125C whenever
any of its sensors sees this level.

Cc: "Benoît Cousson" <bcousson@baylibre.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 07be2cd..b2ca0cf 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -33,7 +33,7 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
-		cpu@0 {
+		cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a15";
 			reg = <0x0>;
@@ -45,6 +45,12 @@
 		};
 	};
 
+	thermal-zones {
+		#include "omap4-cpu-thermal.dtsi"
+		#include "omap5-gpu-thermal.dtsi"
+		#include "omap5-core-thermal.dtsi"
+	};
+
 	timer {
 		compatible = "arm,armv7-timer";
 		/* PPI secure/nonsecure IRQ */
@@ -704,13 +710,15 @@
 			};
 		};
 
-		bandgap@4a0021e0 {
+		bandgap: bandgap@4a0021e0 {
 			reg = <0x4a0021e0 0xc
 			       0x4a00232c 0xc
 			       0x4a002380 0x2c
 			       0x4a0023C0 0x3c>;
 			interrupts = <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
 			compatible = "ti,omap5430-bandgap";
+
+			#sensor-cells = <1>;
 		};
 	};
 };
-- 
1.8.2.1.342.gfa7285d

