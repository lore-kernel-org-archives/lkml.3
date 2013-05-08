Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3EHORc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:17:32 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:49966 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585Ab3EHOR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:17:29 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: arnd@arndb.de, linux@arm.linux.org.uk, olof@lixom.net
Cc: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>
Subject: [RFC 8/8] ARM:stih41x: Add B2020 board support
Date: Wed,  8 May 2013 15:12:19 +0100
Message-Id: <1368022339-2468-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
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
---
 arch/arm/boot/dts/Makefile           |    4 ++-
 arch/arm/boot/dts/stih415-b2020.dtsp |   15 ++++++++++++
 arch/arm/boot/dts/stih416-b2020.dtsp |   16 +++++++++++++
 arch/arm/boot/dts/stih41x-b2020.dtsi |   42 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-stih41x/board-dt.c     |    2 +
 5 files changed, 78 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih415-b2020.dtsp
 create mode 100644 arch/arm/boot/dts/stih416-b2020.dtsp
 create mode 100644 arch/arm/boot/dts/stih41x-b2020.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 78b0271..2e69b90 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -148,7 +148,9 @@ dtb-$(CONFIG_ARCH_SPEAR3XX)+= spear300-evb.dtb \
 	spear320-hmi.dtb
 dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
 dtb-$(CONFIG_ARCH_STIH41X)+= stih415-b2000.dtb \
-	stih416-b2000.dtb
+	stih416-b2000.dtb \
+	stih415-b2020.dtb \
+	stih416-b2020.dtb
 dtb-$(CONFIG_ARCH_SUNXI) += sun4i-a10-cubieboard.dtb \
 	sun4i-a10-hackberry.dtb \
 	sun5i-a13-olinuxino.dtb
diff --git a/arch/arm/boot/dts/stih415-b2020.dtsp b/arch/arm/boot/dts/stih415-b2020.dtsp
new file mode 100644
index 0000000..442b019
--- /dev/null
+++ b/arch/arm/boot/dts/stih415-b2020.dtsp
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
diff --git a/arch/arm/boot/dts/stih416-b2020.dtsp b/arch/arm/boot/dts/stih416-b2020.dtsp
new file mode 100644
index 0000000..276f28d
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-b2020.dtsp
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
index 0000000..855b583
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
+		linux,stdout-path = &sbc_uart1;
+	};
+
+	aliases {
+		ttyAS0 = &sbc_uart1;
+	};
+	soc {
+		sbc_uart1: uart@fe531000 {
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
diff --git a/arch/arm/mach-stih41x/board-dt.c b/arch/arm/mach-stih41x/board-dt.c
index 1f23aca..ed0ccae 100644
--- a/arch/arm/mach-stih41x/board-dt.c
+++ b/arch/arm/mach-stih41x/board-dt.c
@@ -65,6 +65,8 @@ void __init stih41x_dt_init(void)
 static const char *stih41x_dt_match[] __initdata = {
 	"st,stih415-b2000",
 	"st,stih416-b2000",
+	"st,stih415-b2020",
+	"st,stih416-b2020",
 	NULL
 };
 
-- 
1.7.6.5

