Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaHKSrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:47:39 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:33682 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaHKSrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:47:37 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Kever Yang <kever.yang@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: Move the PMIC interrupt pinctrl line to rk3288-evb common
Date: Mon, 11 Aug 2014 11:47:29 -0700
Message-Id: <1407782849-11056-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PMIC interrupt pinctrl line was added to the rk3288-evb-act8846,
but it's the same line on both the ACT8846 version and the RK808
version.  This makes a lot of sense since they share the same SoC
daugherboard.  Move the pinctrl definition to the common file so we
can use it for the RK808 version.

NOTE: The PMIC interrupt doesn't _actually_ go to the PMIC on the
ACT8846 version of the board (it does on the RK808), but our
convention is to label things as they're labelled on the schematics.
In the very least you can argue that this is the interrupt from the
PMIC daughtercard even if it doesn't actually go to the PMIC chip.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/rk3288-evb-act8846.dts | 10 +---------
 arch/arm/boot/dts/rk3288-evb.dtsi        |  6 ++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288-evb-act8846.dts b/arch/arm/boot/dts/rk3288-evb-act8846.dts
index 7d59ff4..a76dd44 100644
--- a/arch/arm/boot/dts/rk3288-evb-act8846.dts
+++ b/arch/arm/boot/dts/rk3288-evb-act8846.dts
@@ -26,7 +26,7 @@
 		interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
 
 		pinctrl-names = "default";
-		pinctrl-0 = <&hym8563_int>;
+		pinctrl-0 = <&pmic_int>;
 
 		#clock-cells = <0>;
 		clock-output-names = "xin32k";
@@ -124,11 +124,3 @@
 		};
 	};
 };
-
-&pinctrl {
-	hym8563 {
-		hym8563_int: hym8563-int {
-			rockchip,pins = <RK_GPIO0 4 RK_FUNC_GPIO &pcfg_pull_up>;
-		};
-	};
-};
diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 4f57209..ae3e10b 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -84,6 +84,12 @@
 		};
 	};
 
+	pmic {
+		pmic_int: pmic-int {
+			rockchip,pins = <RK_GPIO0 4 RK_FUNC_GPIO &pcfg_pull_up>;
+		};
+	};
+
 	usb {
 		host_vbus_drv: host-vbus-drv {
 			rockchip,pins = <0 14 RK_FUNC_GPIO &pcfg_pull_none>;
-- 
2.0.0.526.g5318336

