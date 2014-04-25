Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaDYLbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:31:50 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33637 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaDYLbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:31:43 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, stern@rowland.harvard.edu, kishon@ti.com,
        k.debski@samsung.com, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v7 2/2] ARM: dts: Add usb2phy to Exynos 5250
Date: Fri, 25 Apr 2014 17:01:25 +0530
Message-Id: <1398425485-20574-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398425485-20574-1-git-send-email-gautam.vivek@samsung.com>
References: <1398425485-20574-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

Add support to PHY of USB2 of the Exynos 5250 SoC.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
[gautam.vivek@samsung.com: Split the usb phy entries from
syscon entries from earlier patch: dts: Add usb2phy to Exynos 5250]
[gautam.vivek@samsung.com: Added phy entry for OHCI also along with EHCI]
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 70f0cd5..51e554c 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -563,6 +563,14 @@
 
 		clocks = <&clock CLK_USB2>;
 		clock-names = "usbhost";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			reg = <0>;
+			phys = <&usb2_phy_gen 1>;
+			phy-names = "host";
+			status = "ok";
+		};
 	};
 
 	usb@12120000 {
@@ -572,6 +580,14 @@
 
 		clocks = <&clock CLK_USB2>;
 		clock-names = "usbhost";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		port@0 {
+			reg = <0>;
+			phys = <&usb2_phy_gen 1>;
+			phy-names = "host";
+			status = "ok";
+		};
 	};
 
 	usb2_phy: usbphy@12130000 {
@@ -589,6 +605,16 @@
 		};
 	};
 
+	usb2_phy_gen: phy@12130000 {
+		compatible = "samsung,exynos5250-usb2-phy";
+		reg = <0x12130000 0x100>;
+		clocks = <&clock CLK_USB2>, <&clock CLK_FIN_PLL>;
+		clock-names = "phy", "ref";
+		#phy-cells = <1>;
+		samsung,sysreg-phandle = <&sysreg_system_controller>;
+		samsung,pmureg-phandle = <&pmu_system_controller>;
+	};
+
 	pwm: pwm@12dd0000 {
 		compatible = "samsung,exynos4210-pwm";
 		reg = <0x12dd0000 0x100>;
-- 
1.7.10.4

