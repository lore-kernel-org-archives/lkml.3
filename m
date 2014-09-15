Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaIOPGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:06:34 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44147 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaIOPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:06:31 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-fd-541700749c32
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2] ARM: dts: Add Maxim 77693 PMIC to the Trats2 board
Date: Mon, 15 Sep 2014 17:06:04 +0200
Message-id: <1410793564-30445-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t/xK7olDOIhBi9b1S02zljPajFp3QEm
	i/lHzrFa9L9ZyGpx7tVKRoujvwssXr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv
	81qsPXKX3WLp9YtMFhOmr2WxaN17hN1i1a4/jA5CHmvmrWH0aGnuYfO43NfL5PH3+XUWj7+r
	XjB77Jx1l91j5fIvbB6bVnWyeWxeUu/Rt2UVo8fnTXIB3FFcNimpOZllqUX6dglcGav+rGIp
	aBGp+HV6JWsD40/+LkZODgkBE4m2rttMELaYxIV769m6GLk4hASWMkoc73jEApIQEuhjkti5
	JQLEZhMwlti8fAlYkYjANmaJdY2/GEEcZoFVTBLvr30CGyUs4CZx9+wxsG4WAVWJX/eWs4LY
	vALuEu/nfGOFWCcncfLYZNYJjNwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE8tcd
	jEuPWR1iFOBgVOLhnbFRLESINbGsuDL3EKMEB7OSCC/vL6AQb0piZVVqUX58UWlOavEhRiYO
	TqkGxtxNlS/b3mW0rpFerL8zZlJ65kGG8qkVKUo2TD4Oe5/PUz07t+L4css54qEXxRL5ztyc
	LtK1WWbF87QDa5mLfq49/tFv6q2oe2drb8wQ1f31aekpS+8LIR/li4RnPYg53/1yxrrYvu2L
	ptz4Uv/yD8/3g8KC01e2b7dc8ODOCQHu7QWrfbbMey+pxFKckWioxVxUnAgAhgSQzUMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX77693 is a companion power management IC for smart phones and tablets.

The MAX77693 contains input over-voltage protection (OVP),
a fully-integrated 2.5A switching charger for Lithium Ion battery with
integrated battery disconnect, OTG/accessory 5V output power,
a high-current white LED driver for camera flash, two safeout LDOs,
a haptic motor driver, Model Gauge m3 battery fuel gauge and MicroUSB
Interface Controller (MUIC). I2C serial interface is used for
communicating.

Add MAX77693 node to the Trats2 board. This allows using:
 - charger regulator,
 - 2 safeout LDO regulators (for USB OTG),
 - extcon.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

---

Changes since v1:
==================
1. Use GPIO_ACTIVE_HIGH for gpio flags (suggested by Javier Martinez
   Canillas).
2. Use regulator node name instead of deprecated regulator-compatible
   property (suggested by Javier Martinez Canillas).
3. Add Javier Martinez Canillas' reviewed-by tag.
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 11967f4561e0..1953317bd658 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -14,6 +14,7 @@
 
 /dts-v1/;
 #include "exynos4412.dtsi"
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	model = "Samsung Trats 2 based on Exynos4412";
@@ -22,6 +23,7 @@
 	aliases {
 		i2c9 = &i2c_ak8975;
 		i2c10 = &i2c_cm36651;
+		i2c11 = &i2c_max77693;
 	};
 
 	memory {
@@ -518,6 +520,36 @@
 		};
 	};
 
+	i2c_max77693: i2c-gpio-1 {
+		compatible = "i2c-gpio";
+		gpios = <&gpm2 0 GPIO_ACTIVE_HIGH>, <&gpm2 1 GPIO_ACTIVE_HIGH>;
+		i2c-gpio,delay-us = <2>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+
+		max77693@66 {
+			compatible = "maxim,max77693";
+			interrupt-parent = <&gpx1>;
+			interrupts = <5 2>;
+			reg = <0x66>;
+
+			regulators {
+				esafeout1_reg: ESAFEOUT1@1 {
+					regulator-name = "ESAFEOUT1";
+				};
+				esafeout2_reg: ESAFEOUT2@2 {
+					regulator-name = "ESAFEOUT2";
+				};
+				charger_reg: CHARGER@0 {
+					regulator-name = "CHARGER";
+					regulator-min-microamp = <60000>;
+					regulator-max-microamp = <2580000>;
+				};
+			};
+		};
+	};
+
 	mmc@12550000 {
 		num-slots = <1>;
 		supports-highspeed;
-- 
1.9.1

