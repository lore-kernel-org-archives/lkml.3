Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3FYLVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:21:19 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:54363 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960Ab3FYLVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:21:15 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v5 7/7] ARM:stih41x: Add B2020 board support
Date: Tue, 25 Jun 2013 12:16:13 +0100
Message-Id: <1372158973-19896-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
References: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

B2020 ADI board is reference board for STIH415/416 SOCs, it has 2 x
UART, 4x USB, 1 x Ethernet, 1 x SATA, 1 x PCIe, and 2GB RAM  with
standard set-top box IPs.

This patch adds initial support to B2020 with STiH415/416 with SBC_UART1
as console and a heard beat LED.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Stuart Menefy <stuart.menefy@st.com>
CC: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/Makefile           |    4 ++-
 arch/arm/boot/dts/stih415-b2020.dts  |   15 ++++++++++++
 arch/arm/boot/dts/stih416-b2020.dts  |   16 +++++++++++++
 arch/arm/boot/dts/stih41x-b2020.dtsi |   42 ++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih415-b2020.dts
 create mode 100644 arch/arm/boot/dts/stih416-b2020.dts
 create mode 100644 arch/arm/boot/dts/stih41x-b2020.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 53ee542..31f3488 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -178,7 +178,9 @@ dtb-$(CONFIG_ARCH_SPEAR3XX)+= spear300-evb.dtb \
 	spear320-hmi.dtb
 dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
 dtb-$(CONFIG_ARCH_STI)+= stih415-b2000.dtb \
-	stih416-b2000.dtb
+	stih416-b2000.dtb \
+	stih415-b2020.dtb \
+	stih416-b2020.dtb
 dtb-$(CONFIG_ARCH_SUNXI) += \
 	sun4i-a10-cubieboard.dtb \
 	sun4i-a10-mini-xplus.dtb \
diff --git a/arch/arm/boot/dts/stih415-b2020.dts b/arch/arm/boot/dts/stih415-b2020.dts
new file mode 100644
index 0000000..442b019
--- /dev/null
+++ b/arch/arm/boot/dts/stih415-b2020.dts
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
+#include "stih41x-b2020.dtsi"
+/ {
+	model = "STiH415 B2020 Board";
+	compatible = "st,stih415", "st,stih415-b2020";
+};
diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
new file mode 100644
index 0000000..276f28d
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-b2020.dts
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
+#include "stih41x-b2020.dtsi"
+/ {
+	model = "STiH416 B2020";
+	compatible = "st,stih416", "st,stih416-b2020";
+
+};
diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
new file mode 100644
index 0000000..133e181
--- /dev/null
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited.
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+/ {
+	memory{
+		device_type = "memory";
+		reg = <0x40000000 0x80000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyAS0,115200";
+		linux,stdout-path = &sbc_serial1;
+	};
+
+	aliases {
+		ttyAS0 = &sbc_serial1;
+	};
+	soc {
+		sbc_serial1: serial@fe531000 {
+			status = "okay";
+		};
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
+				gpios	= <&PIO4 7>;
+				default-state = "off";
+			};
+		};
+	};
+};
-- 
1.7.6.5

