Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbbATJrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:47:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55130 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbbATJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:47:44 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/8] soc: Add MediaTek pericfg controller support
Date: Tue, 20 Jan 2015 10:47:05 +0100
Message-Id: <1421747231-554-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the MediaTek pericfg controller found
on the MT8135/MT8173 SoCs. The pericfg controller contains
miscellaneous registers for controlling peripheral resets and
clocks.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 .../devicetree/bindings/soc/mediatek/pericfg.txt      | 19 +++++++++++++++++++
 drivers/soc/mediatek/Kconfig                          | 10 ++++++++++
 drivers/soc/mediatek/Makefile                         |  1 +
 drivers/soc/mediatek/mtk-pericfg.c                    |  1 -
 4 files changed, 30 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/pericfg.txt

diff --git a/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt b/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
new file mode 100644
index 0000000..81d1aee
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/pericfg.txt
@@ -0,0 +1,19 @@
+MediaTek pericfg Controller
+
+The pericfg controller contains miscellaneous registers for controlling
+clocks, resets and bus settings.
+
+Required properties:
+- compatible: must be one of:
+	mediatek,mt8135-pericfg
+	mediatek,mt8173-pericfg
+- reg: Address range for the pericfg controller
+
+Example:
+
+	pericfg: pericfg@10003000 {
+		#reset-cells = <1>;
+		#clock-cells = <1>;
+		compatible = "mediatek,mt8135-pericfg";
+		reg = <0 0x10003000 0 0x1000>;
+	};
diff --git a/drivers/soc/mediatek/Kconfig b/drivers/soc/mediatek/Kconfig
index 3ad39fe..9bdb88f 100644
--- a/drivers/soc/mediatek/Kconfig
+++ b/drivers/soc/mediatek/Kconfig
@@ -10,3 +10,13 @@ config MTK_INFRACFG
 	  contains several miscellaneous registers for clock, reset and bus
 	  settings. Say yes here if you want to run your kernel on one of these
 	  SoCs.
+
+config MTK_PERICFG
+	tristate "MediaTek pericfg controller support"
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	select REGMAP
+	help
+	  The MediaTek pericfg controller found on MT8135 and MT8173 SoCs
+	  contains several miscellaneous registers for clock, reset and bus
+	  settings. Say yes here if you want to run your kernel on one of these
+	  SoCs.
diff --git a/drivers/soc/mediatek/Makefile b/drivers/soc/mediatek/Makefile
index dbeb627..e67be7c 100644
--- a/drivers/soc/mediatek/Makefile
+++ b/drivers/soc/mediatek/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_MTK_INFRACFG) += mtk-infracfg.o
+obj-$(CONFIG_MTK_PERICFG) += mtk-pericfg.o
diff --git a/drivers/soc/mediatek/mtk-pericfg.c b/drivers/soc/mediatek/mtk-pericfg.c
index b7ee902..aa9a7eb 100644
--- a/drivers/soc/mediatek/mtk-pericfg.c
+++ b/drivers/soc/mediatek/mtk-pericfg.c
@@ -1,6 +1,5 @@
 /*
  * Copyright (c) 2014 MediaTek Inc.
- * Author: Flora Fu <flora.fu@mediatek.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
2.1.4

