Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3HDJ7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:59:25 -0400
Received: from up.free-electrons.com ([94.23.35.102]:37130 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752718Ab3HDJ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:59:13 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 3/9] ARM: sun7i: Add Olimex A20-Olinuxino-Micro support
Date: Sun,  4 Aug 2013 11:58:44 +0200
Message-Id: <1375610330-18185-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Olimex A20-Olinuxino is an open-hardware board based on the
Allwinner A20 SoC, with most of the pins exported on headers, a 10/100M
ethernet port, SATA, SD and uSD slots, etc.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/Makefile                      |  3 ++-
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 34 +++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 1482533..18a7374 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -211,7 +211,8 @@ dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-hackberry.dtb \
 	sun5i-a10s-olinuxino-micro.dtb \
 	sun5i-a13-olinuxino.dtb \
-	sun6i-a31-colombus.dtb
+	sun6i-a31-colombus.dtb \
+	sun7i-a20-olinuxino-micro.dtb
 dtb-$(CONFIG_ARCH_TEGRA) += tegra20-harmony.dtb \
 	tegra20-iris-512.dtb \
 	tegra20-medcom-wide.dtb \
diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
new file mode 100644
index 0000000..d339584
--- /dev/null
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -0,0 +1,34 @@
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
+/include/ "sun7i-a20.dtsi"
+
+/ {
+	model = "Olimex A20-Olinuxino Micro";
+	compatible = "olimex,a20-olinuxino-micro", "allwinner,sun7i-a20";
+
+	soc@01c00000 {
+		uart0: serial@01c28000 {
+			status = "okay";
+		};
+
+		uart6: serial@01c29800 {
+			status = "okay";
+		};
+
+		uart7: serial@01c29c00 {
+			status = "okay";
+		};
+	};
+};
-- 
1.8.3.4

