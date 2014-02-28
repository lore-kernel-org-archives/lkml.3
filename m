Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaB1MVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:21:01 -0500
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:50175 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576AbaB1MTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:19:55 -0500
X-Greylist: delayed 86149 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2014 07:19:54 EST
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH 1/5] ARM: STi: Add STiH407 SoC support
Date: Fri, 28 Feb 2014 13:17:17 +0100
Message-Id: <1393589841-6634-2-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393589841-6634-1-git-send-email-maxime.coquelin@st.com>
References: <1393589841-6634-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to STiH407 SoC.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 Documentation/arm/sti/stih407-overview.txt    | 18 ++++++++++++++++++
 Documentation/devicetree/bindings/arm/sti.txt | 15 +++++++++++++++
 arch/arm/mach-sti/Kconfig                     |  9 +++++++++
 arch/arm/mach-sti/board-dt.c                  |  1 +
 4 files changed, 43 insertions(+)
 create mode 100644 Documentation/arm/sti/stih407-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/sti.txt

diff --git a/Documentation/arm/sti/stih407-overview.txt b/Documentation/arm/sti/stih407-overview.txt
new file mode 100644
index 0000000..3343f32
--- /dev/null
+++ b/Documentation/arm/sti/stih407-overview.txt
@@ -0,0 +1,18 @@
+			STiH407 Overview
+			================
+
+Introduction
+------------
+
+    The STiH407 is the new generation of SoC for Multi-HD, AVC set-top boxes
+    and server/connected client application for satellite, cable, terrestrial
+    and IP-STB markets.
+
+    Features
+    - ARM Cortex-A9 1.5 GHz dual core CPU (28nm)
+    - SATA2, USB 3.0, PCIe, Gbit Ethernet
+
+  Document Author
+  ---------------
+
+  Maxime Coquelin <maxime.coquelin@st.com>, (c) 2014 ST Microelectronics
diff --git a/Documentation/devicetree/bindings/arm/sti.txt b/Documentation/devicetree/bindings/arm/sti.txt
new file mode 100644
index 0000000..92f16c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/sti.txt
@@ -0,0 +1,15 @@
+ST STi Platforms Device Tree Bindings
+---------------------------------------
+
+Boards with the ST STiH415 SoC shall have the following properties:
+Required root node property:
+compatible = "st,stih415";
+
+Boards with the ST STiH416 SoC shall have the following properties:
+Required root node property:
+compatible = "st,stih416";
+
+Boards with the ST STiH407 SoC shall have the following properties:
+Required root node property:
+compatible = "st,stih407";
+
diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index d71654b..e596373 100644
--- a/arch/arm/mach-sti/Kconfig
+++ b/arch/arm/mach-sti/Kconfig
@@ -43,4 +43,13 @@ config SOC_STIH416
 	  and other digital audio/video applications using Flattened Device
 	  Trees.
 
+config SOC_STIH407
+	bool "STiH407 STMicroelectronics Consumer Electronics family"
+	default y
+	help
+	  This enables support for STMicroelectronics Digital Consumer
+	  Electronics family StiH407 parts, primarily targeted at set-top-box
+	  and other digital audio/video applications using Flattened Device
+	  Trees.
+
 endif
diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
index 1217fb5..df731f2 100644
--- a/arch/arm/mach-sti/board-dt.c
+++ b/arch/arm/mach-sti/board-dt.c
@@ -36,6 +36,7 @@ static void __init stih41x_machine_init(void)
 static const char *stih41x_dt_match[] __initdata = {
 	"st,stih415",
 	"st,stih416",
+	"st,stih407",
 	NULL
 };
 
-- 
1.9.0

