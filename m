Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbbAOBIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:08:14 -0500
Received: from mail.kernel.org ([198.145.29.136]:46732 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbbAOBIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:08:12 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] ARM: dts: exynos5422-odroidxu3: add on-board INA231 sensors
Date: Wed, 14 Jan 2015 17:08:09 -0800
Message-Id: <1421284089-421-1-git-send-email-khilman@kernel.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@linaro.org>

The odroid-xu3 has 4 INA231 current sensors on board which can be
accessed from the Linux via the hwmon interface.

There is one sensor for each of these power rails:

- A15 cluster: VDD_ARM
- A7 cluster: VDD_KFC
- GPU: VDD_G3D
- memory: VDD_MEM

In addition to adding the sensors, LDO26 from the PMIC needs to be
enabled because it's powering these sensor.

Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
v2: use "ti,ina231" as compatible string.

Applies on top of "ARM: dts: Add dts file for odroid XU3 board" from Sjoerd Simons.

 arch/arm/boot/dts/exynos5422-odroidxu3.dts | 39 ++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
index c29123c0734d..50353d023225 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
@@ -174,6 +174,13 @@
 					regulator-always-on;
 				};
 
+				ldo26_reg: LDO26 {
+					regulator-name = "vdd_ldo26";
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
+					regulator-always-on;
+				};
+
 				buck1_reg: BUCK1 {
 					regulator-name = "vdd_mif";
 					regulator-min-microvolt = <800000>;
@@ -257,6 +264,38 @@
 		};
 	};
 
+	i2c_0: i2c@12C60000 {
+		status = "okay";
+
+		/* A15 cluster: VDD_ARM */
+		ina231@40 {
+			compatible = "ti,ina231";
+			reg = <0x40>;
+			shunt-resistor = <10000>;
+		};
+
+		/* memory: VDD_MEM */
+		ina231@41 {
+			compatible = "ti,ina231";
+			reg = <0x41>;
+			shunt-resistor = <10000>;
+		};
+
+		/* GPU: VDD_G3D */
+		ina231@44 {
+			compatible = "ti,ina231";
+			reg = <0x44>;
+			shunt-resistor = <10000>;
+		};
+
+		/* A7 cluster: VDD_KFC */
+		ina231@45 {
+			compatible = "ti,ina231";
+			reg = <0x45>;
+			shunt-resistor = <10000>;
+		};
+	};
+
 	i2c_2: i2c@12C80000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-max-bus-freq = <66000>;
-- 
2.1.3

