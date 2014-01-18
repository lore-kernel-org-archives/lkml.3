Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaAROZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 09:25:26 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34000 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaAROZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 09:25:24 -0500
From: Alex Ling <kasimling@gmail.com>
To: ben-linux@fluff.org, kgene.kim@samsung.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alex Ling <kasimling@gmail.com>
Subject: [PATCH 1/2] ARM: dts: Add dwmmc host for TINY4412
Date: Sat, 18 Jan 2014 22:24:42 +0800
Message-Id: <1390055084-27483-1-git-send-email-kasimling@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dwmmc host node for to support eMMC on TINY4412 board.

Signed-off-by: Alex Ling <kasimling@gmail.com>
---
 arch/arm/boot/dts/exynos4412-tiny4412.dts |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-tiny4412.dts b/arch/arm/boot/dts/exynos4412-tiny4412.dts
index 0a98312..2c6bfe3 100644
--- a/arch/arm/boot/dts/exynos4412-tiny4412.dts
+++ b/arch/arm/boot/dts/exynos4412-tiny4412.dts
@@ -63,6 +63,25 @@
 		status = "okay";
 	};
 
+	mmc@12550000 {
+		num-slots = <1>;
+		supports-highspeed;
+		broken-cd;
+		non-removable;
+		card-detect-delay = <200>;
+		samsung,dw-mshc-ciu-div = <3>;
+		samsung,dw-mshc-sdr-timing = <2 3>;
+		samsung,dw-mshc-ddr-timing = <1 2>;
+		pinctrl-0 = <&sd4_clk &sd4_cmd &sd4_bus4 &sd4_bus8>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		slot@0 {
+			reg = <0>;
+			bus-width = <8>;
+		};
+	};
+
 	serial@13800000 {
 		status = "okay";
 	};
-- 
1.7.9.5

