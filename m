Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaEUIpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:45:46 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:50756 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaEUIpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:45:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v2 1/3] ARM: sti: stih416: Add support for B2020 RevE
Date: Wed, 21 May 2014 09:45:22 +0100
Message-Id: <1400661924-10745-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The B2020 RevE differs from the other B2020 boards in a few subtle ways;
including the Ethernet reset GPIO which this patch adds support for and
the LED wiring which will follow in a latter patch.  Without supplying
these differences Ethernet and the board LEDs simply will not work.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/Makefile               |  3 ++-
 arch/arm/boot/dts/stih416-b2020-revE.dts | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/stih416-b2020-revE.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 35c146f..0f89cdf 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -338,7 +338,8 @@ dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
 dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
 	stih416-b2000.dtb \
 	stih415-b2020.dtb \
-	stih416-b2020.dtb
+	stih416-b2020.dtb \
+	stih416-b2020-revE.dtb
 dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-a1000.dtb \
 	sun4i-a10-cubieboard.dtb \
diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
new file mode 100644
index 0000000..da3c1c4
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics (R&D) Limited.
+ * Author: Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+/dts-v1/;
+#include "stih416.dtsi"
+#include "stih41x-b2020.dtsi"
+/ {
+	model = "STiH416 B2020 REV-E";
+	compatible = "st,stih416-b2020", "st,stih416";
+
+	soc {
+		ethernet1: dwmac@fef08000 {
+			snps,reset-gpio = <&PIO0 7>;
+		};
+	};
+};
-- 
1.8.3.2

