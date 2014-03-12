Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaCLLGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:06:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33101 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754045AbaCLLGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:06:09 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: berlin2q: add the Marvell BG2-Q DMP device tree
Date: Wed, 12 Mar 2014 12:06:04 +0100
Message-Id: <1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/boot/dts/Makefile         |  3 ++-
 arch/arm/boot/dts/berlin2q-dmp.dts | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/berlin2q-dmp.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 032030361bef..1a2adadfb962 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -52,7 +52,8 @@ dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm11351-brt.dtb \
 dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
 dtb-$(CONFIG_ARCH_BERLIN) += \
 	berlin2-sony-nsz-gs7.dtb	\
-	berlin2cd-google-chromecast.dtb
+	berlin2cd-google-chromecast.dtb	\
+	berlin2q-dmp.dtb
 dtb-$(CONFIG_ARCH_DAVINCI) += da850-enbw-cmc.dtb \
 	da850-evm.dtb
 dtb-$(CONFIG_ARCH_DOVE) += dove-cm-a510.dtb \
diff --git a/arch/arm/boot/dts/berlin2q-dmp.dts b/arch/arm/boot/dts/berlin2q-dmp.dts
new file mode 100644
index 000000000000..6a98860e0251
--- /dev/null
+++ b/arch/arm/boot/dts/berlin2q-dmp.dts
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2014 Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+/dts-v1/;
+#include "berlin2q.dtsi"
+
+/ {
+	model = "Marvell BG2-Q DMP";
+	compatible = "marvell,berlin2q-dmp", "marvell,berlin2q", "marvell,berlin";
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x40000000>;
+	};
+
+	choosen {
+		bootargs = "console=ttyS0,115200 earlyprintk";
+	};
+
+	soc {
+		apb@fc0000 {
+			uart0: uart@9000 {
+				status = "okay";
+			};
+		};
+	};
+};
-- 
1.8.3.2

