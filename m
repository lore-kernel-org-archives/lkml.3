Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab3EHOSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:18:40 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:46907 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab3EHORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:17:21 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux@arm.linux.org.uk, arnd@arndb.de, olof@lixom.net
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
Subject: [RFC 7/8] ARM:stih41x: Add B2000 board support
Date: Wed,  8 May 2013 15:12:09 +0100
Message-Id: <1368022329-2424-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

B2000 board is reference board for STIH415/416 SOCs, it has
2 x UART, 4x USB, 2 x Ethernet, 1 x SATA, 1 x PCIe, and 1GB RAM.

This patch add initial support to b2000 with STiH415/416 with UART2 as
console and a heard beat LED.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
CC: Stephen Gallimore <stephen.gallimore@st.com>
CC: Stuart Menefy <stuart.menefy@st.com>
---
 arch/arm/boot/dts/Makefile           |    2 +
 arch/arm/boot/dts/stih415-b2000.dtsp |   15 ++++++++++++
 arch/arm/boot/dts/stih416-b2000.dtsp |   16 +++++++++++++
 arch/arm/boot/dts/stih41x-b2000.dtsi |   41 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-stih41x/board-dt.c     |    2 +
 5 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/stih415-b2000.dtsp
 create mode 100644 arch/arm/boot/dts/stih416-b2000.dtsp
 create mode 100644 arch/arm/boot/dts/stih41x-b2000.dtsi

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 9c62558..78b0271 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -147,6 +147,8 @@ dtb-$(CONFIG_ARCH_SPEAR3XX)+= spear300-evb.dtb \
 	spear320-evb.dtb \
 	spear320-hmi.dtb
 dtb-$(CONFIG_ARCH_SPEAR6XX)+= spear600-evb.dtb
+dtb-$(CONFIG_ARCH_STIH41X)+= stih415-b2000.dtb \
+	stih416-b2000.dtb
 dtb-$(CONFIG_ARCH_SUNXI) += sun4i-a10-cubieboard.dtb \
 	sun4i-a10-hackberry.dtb \
 	sun5i-a13-olinuxino.dtb
diff --git a/arch/arm/boot/dts/stih415-b2000.dtsp b/arch/arm/boot/dts/stih415-b2000.dtsp
new file mode 100644
index 0000000..d4af531
--- /dev/null
+++ b/arch/arm/boot/dts/stih415-b2000.dtsp
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
diff --git a/arch/arm/boot/dts/stih416-b2000.dtsp b/arch/arm/boot/dts/stih416-b2000.dtsp
new file mode 100644
index 0000000..a5eb6ee
--- /dev/null
+++ b/arch/arm/boot/dts/stih416-b2000.dtsp
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
index 0000000..8c17e4a
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
+		linux,stdout-path = &uart2;
+	};
+
+	aliases {
+		ttyAS0 = &uart2;
+	};
+
+	soc {
+		uart2: uart@fed32000 {
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
diff --git a/arch/arm/mach-stih41x/board-dt.c b/arch/arm/mach-stih41x/board-dt.c
index 8005f71..1f23aca 100644
--- a/arch/arm/mach-stih41x/board-dt.c
+++ b/arch/arm/mach-stih41x/board-dt.c
@@ -63,6 +63,8 @@ void __init stih41x_dt_init(void)
 }
 
 static const char *stih41x_dt_match[] __initdata = {
+	"st,stih415-b2000",
+	"st,stih416-b2000",
 	NULL
 };
 
-- 
1.7.6.5

