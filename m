Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaL2S3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:29:00 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:61779 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaL2S26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:28:58 -0500
From: Joshua Clayton <stillcompiling@gmail.com>
To: mark.rutland@arm.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, a.zummo@towertech.it, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Joshua Clayton <stillcompiling@gmail.com>
Subject: [PATCH] rtc: rtc-pfc2123: Add support for devicetree
Date: Mon, 29 Dec 2014 10:28:46 -0800
Message-Id: <1419877726-8458-1-git-send-email-stillcompiling@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatible string "nxp,rtc-pcf2123"
Document the binding

Signed-off-by: Joshua Clayton <stillcompiling@gmail.com>
---
 Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt | 16 ++++++++++++++++
 drivers/rtc/rtc-pcf2123.c                              | 10 ++++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt

diff --git a/Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt b/Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt
new file mode 100644
index 0000000..5cbc0b1
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/nxp,rtc-2123.txt
@@ -0,0 +1,16 @@
+NXP PCF2123 SPI Real Time Clock
+
+Required properties:
+- compatible: should be: "nxp,rtc-pcf2123"
+- reg: should be the SPI slave chipselect address
+
+Optional properties:
+- spi-cs-high: PCF2123 needs chipselect high
+
+Example:
+
+rtc: nxp,rtc-pcf2123@3 {
+	compatible = "nxp,rtc-pcf2123"
+	reg = <3>
+	spi-cs-high;
+};
diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index d1953bb..8a7556c 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -38,6 +38,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/of.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/rtc.h>
@@ -340,10 +341,19 @@ static int pcf2123_remove(struct spi_device *spi)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id pcf2123_dt_ids[] = {
+	{ .compatible = "nxp,rtc-pcf2123", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, pcf2123_dt_ids);
+#endif
+
 static struct spi_driver pcf2123_driver = {
 	.driver	= {
 			.name	= "rtc-pcf2123",
 			.owner	= THIS_MODULE,
+			.of_match_table = of_match_ptr(pcf2123_dt_ids),
 	},
 	.probe	= pcf2123_probe,
 	.remove	= pcf2123_remove,
-- 
2.1.0

