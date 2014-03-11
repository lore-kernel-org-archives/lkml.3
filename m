Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaCKKWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:22:17 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60677 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaCKKWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:22:15 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@st.com
Subject: [PATCH 1/3] ARM: DT: STi: Add support to B2020 revision E board.
Date: Tue, 11 Mar 2014 10:22:02 +0000
Message-Id: <1394533324-20299-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds support to rev E board of B2020 which has few minor
changes :
	PHY reset PIO (Change from PIO30 to PIO07)
	Power LED(Green) Control(Change from PIO47 to PIO13)

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/Makefile               |  3 ++-
 arch/arm/boot/dts/stih416-b2020-revE.dts | 36 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/stih416-b2020-revE.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 0320303..325218a 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -278,7 +278,8 @@ dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
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
index 0000000..bcb9d00
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+/dts-v1/;
+#include "stih416.dtsi"
+#include "stih41x-b2020.dtsi"
+/ {
+        model = "STih416 B2020 REV. E";
+	compatible = "st,stih416", "st,stih416-b2020";
+
+	soc {
+
+		leds {
+			compatible	= "gpio-leds";
+			red {
+				#gpio-cells = <1>;
+				label	= "Front Panel LED";
+				gpios	= <&PIO4 1>;
+				linux,default-trigger	= "heartbeat";
+			};
+			green {
+				gpios	= <&PIO1 3>;
+				default-state = "off";
+			};
+		};
+
+		ethernet1: ethernet@fef08000 {
+			snps,reset-gpio 	= <&PIO0 7>;
+		};
+	};
+};
-- 
1.8.3.2

