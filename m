Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3HDJtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:49:31 -0400
Received: from up.free-electrons.com ([94.23.35.102]:36999 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753650Ab3HDJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:48:01 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 06/10] ARM: sun6i: Add WITS Colombus A31 evaluation kit support
Date: Sun,  4 Aug 2013 11:47:33 +0200
Message-Id: <1375609657-15434-7-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375609657-15434-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This platform from WITS is the evaluation board for the Allwinner A31.
It features a quad-Cortex A7, 2048MB of RAM, NAND, USB, MMC, several
UART, HDMI, a 2048 x 1536 10" screen, powered by a PowerVR, etc.

Of course, most of these peripherals aren't supported yet, but support
for those will come eventually.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/Makefile               |  3 ++-
 arch/arm/boot/dts/sun6i-a31-colombus.dts | 30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/sun6i-a31-colombus.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 641b3c9..1482533 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -210,7 +210,8 @@ dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-mini-xplus.dtb \
 	sun4i-a10-hackberry.dtb \
 	sun5i-a10s-olinuxino-micro.dtb \
-	sun5i-a13-olinuxino.dtb
+	sun5i-a13-olinuxino.dtb \
+	sun6i-a31-colombus.dtb
 dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-iris-512.dtb \
 	tegra20-medcom-wide.dtb \
diff --git a/arch/arm/boot/dts/sun6i-a31-colombus.dts b/arch/arm/boot/dts/sun6i-a31-colombus.dts
new file mode 100644
index 0000000..99c4b18
--- /dev/null
+++ b/arch/arm/boot/dts/sun6i-a31-colombus.dts
@@ -0,0 +1,30 @@
+/*
+ * Copyright 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "sun6i-a31.dtsi"
+
+/ {
+	model = "WITS A31 Colombus Evaluation Board";
+	compatible = "wits,colombus", "allwinner,sun6i-a31";
+
+	chosen {
+		bootargs = "earlyprintk console=ttyS0,115200";
+	};
+
+	soc@01c00000 {
+		uart0: serial@01c28000 {
+			status = "okay";
+		};
+	};
+};
-- 
1.8.3.4

