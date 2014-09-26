Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaIZHXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:23:13 -0400
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:57600
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753357AbaIZHXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:23:12 -0400
X-Greylist: delayed 2009 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2014 03:23:12 EDT
From: Dongsheng Wang <dongsheng.wang@freescale.com>
To: <santosh.shilimkar@ti.com>, <sandeep_n@ti.com>, <olof@lixom.net>,
        <galak@codeaurora.org>, <shawn.guo@linaro.org>
CC: <gregkh@linuxfoundation.org>, <paul@pwsan.com>, <arnd@arndb.de>,
        <dongsheng.wang@freescale.com>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@freescale.com>
Subject: [PATCH 1/2] soc/fsl: add freescale dir for SOC specific drivers
Date: Fri, 26 Sep 2014 14:48:40 +0800
Message-ID: <1411714121-32138-1-git-send-email-dongsheng.wang@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(47776003)(104016003)(20776003)(50986999)(69596002)(83072002)(85852003)(64706001)(84676001)(88136002)(89996001)(104166001)(33646002)(99396003)(44976005)(68736004)(19580395003)(83322001)(107046002)(19580405001)(48376002)(229853001)(62966002)(50466002)(77156001)(85306004)(31966008)(21056001)(46102003)(50226001)(77982003)(4396001)(102836001)(120916001)(95666004)(575784001)(92566001)(86362001)(2201001)(105606002)(87936001)(93916002)(87286001)(6806004)(92726001)(97736003)(10300001)(79102003)(81342003)(90102001)(81156004)(76482002)(74502003)(74662003)(106466001)(80022003)(81542003)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Dongsheng.Wang@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB562;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Dongsheng <dongsheng.wang@freescale.com>

Some Freescale device drivers need to move to soc/, because these drivers
are specific drivers. Before the soc/ to be created, the drivers had been
there arch/ or drivers/misc/, but now soc/ dir is a better choice.

Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>

diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index c854385..063af9e 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -2,4 +2,17 @@ menu "SOC (System On Chip) specific Drivers"
 
 source "drivers/soc/qcom/Kconfig"
 
+config	FSL_SOC_DRIVERS
+	bool "Freescale Soc Drivers"
+	depends on FSL_SOC || ARCH_MXC
+	default n
+	help
+	Say y here to enable Freescale Soc Device Drivers support.
+	The Soc Drivers provides the device driver that is a specific block
+	or feature on Freescale platform.
+
+if FSL_SOC_DRIVERS
+	source "drivers/soc/fsl/Kconfig"
+endif
+
 endmenu
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 3b1b95d..b8f32c3 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
+obj-$(CONFIG_FSL_SOC_DRIVERS)	+= fsl/
diff --git a/drivers/soc/fsl/Kconfig b/drivers/soc/fsl/Kconfig
new file mode 100644
index 0000000..72df9b3
--- /dev/null
+++ b/drivers/soc/fsl/Kconfig
@@ -0,0 +1,3 @@
+if ARM
+source "drivers/soc/fsl/Kconfig.arm"
+endif
diff --git a/drivers/soc/fsl/Kconfig.arm b/drivers/soc/fsl/Kconfig.arm
new file mode 100644
index 0000000..8c90b82
--- /dev/null
+++ b/drivers/soc/fsl/Kconfig.arm
@@ -0,0 +1,16 @@
+#
+# Freescale ARM SOC Drivers
+#
+
+config	LS1_SOC_DRIVERS
+	bool "LS1021A Soc Drivers"
+	depends on SOC_LS1021A
+	default n
+	help
+	Say y here to enable Freescale LS1021A Soc Device Drivers support.
+	The Soc Drivers provides the device driver that is a specific block
+	or feature on LS1021A platform.
+
+if LS1_SOC_DRIVERS
+	source "drivers/soc/fsl/ls1/Kconfig"
+endif
diff --git a/drivers/soc/fsl/Makefile b/drivers/soc/fsl/Makefile
new file mode 100644
index 0000000..5ca0e1c
--- /dev/null
+++ b/drivers/soc/fsl/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for ls1 Soc specific device drivers.
+#
+
+obj-$(CONFIG_LS1_SOC_DRIVERS) += ls1/
diff --git a/drivers/soc/fsl/ls1/Kconfig b/drivers/soc/fsl/ls1/Kconfig
new file mode 100644
index 0000000..7556f44
--- /dev/null
+++ b/drivers/soc/fsl/ls1/Kconfig
@@ -0,0 +1,3 @@
+#
+# LS-1 Soc drivers
+#
-- 
2.1.0.27.g96db324

