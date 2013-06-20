Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303Ab3FTOLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:11:31 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:44561 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935500Ab3FTOLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:11:24 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 09/10] ARM:stih41x: Add B2000 board support
Date: Thu, 20 Jun 2013 15:06:49 +0100
Message-Id: <1371737209-9607-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B2000 board is reference board for STIH415/416 SOCs, it has
2 x UART, 4x USB, 2 x Ethernet, 1 x SATA, 1 x PCIe, and 1GB RAM.

This patch add initial support to b2000 with STiH415/416 with UART2 as
console and a heard beat LED.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/Makefile           |    2 +
 arch/arm/boot/dts/stih415-b2000.dts  |   15 ++++++++++++
 arch/arm/boot/dts/stih416-b2000.dts  |   16 +++++++++++++
 arch/arm/boot/dts/stih41x-b2000.dtsi |   41 ++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih415-b2000.dts
 create mode 100644 arch/arm/boot/dts/stih416-b2000.dts
 create mode 100644 arch/arm/boot/dts/stih41x-b2000.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f0895c5..d4615fd 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -177,6 +177,8 @@ dtb-$(CONFIG_ARCH_SPEAR3XX)+= spear300-evb.dtb \
 	spear320-evb.dtb \
 	spear320-hmi.dtb
 dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
+dtb-$(CONFIG_ARCH_STIXXXX)+= stih415-b2000.dtb \
+	stih416-b2000.dtb
 dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-cubieboard.dtb \
 	sun4i-a10-mini-xplus.dtb \
diff --git a/arch/arm/boot/dts/stih415-b2000.dts b/arch/arm/boot/dts/stih415-b2000.dts
new file mode 100644
index 0000000..d4af531
--- /dev/null
+++ b/arch/arm/boot/dts/stih415-b2000.dts
@@ -0,0 +1,15 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+/dts-v1/;
+#include "stih415.dtsi"
+#include "stih41x-b2000.dtsi"
+/ {
+	model = "STiH415 B2000 Board";
+	compatible = "st,stih415", "st,stih415-b2000";
+};
diff --git a/arch/arm/boot/dts/stih416-b2000.dts b/arch/arm/boot/dts/stih416-b2000.dts
new file mode 100644
index 0000000..a5eb6ee
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-b2000.dts
@@ -0,0 +1,16 @@
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
+#include "stih41x-b2000.dtsi"
+
+/ {
+	compatible = "st,stih416", "st,stih416-b2000";
+	model = "STiH416 B2000";
+};
diff --git a/arch/arm/boot/dts/stih41x-b2000.dtsi b/arch/arm/boot/dts/stih41x-b2000.dtsi
new file mode 100644
index 0000000..8e694d2
--- /dev/null
+++ b/arch/arm/boot/dts/stih41x-b2000.dtsi
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+/ {
+
+	memory{
+		device_type = "memory";
+		reg = <0x60000000 0x40000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyAS0,115200";
+		linux,stdout-path = &serial2;
+	};
+
+	aliases {
+		ttyAS0 = &serial2;
+	};
+
+	soc {
+		serial2: serial@fed32000 {
+			status = "okay";
+		};
+
+		leds {
+			compatible	= "gpio-leds";
+			fp_led {
+				#gpio-cells = <1>;
+				label	= "Front Panel LED";
+				gpios	= <&PIO105 7>;
+				linux,default-trigger	= "heartbeat";
+			};
+		};
+
+	};
+};
-- 
1.7.6.5

