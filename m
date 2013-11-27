Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3K0I7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:59:12 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:47108 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3K0I7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:59:07 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v2] rtc: rtc-ds1742: Add devicetree support
Date: Wed, 27 Nov 2013 12:55:20 +0400
Message-Id: <1385542520-20887-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the driver to be enabled with devicetree.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 Documentation/devicetree/bindings/rtc/maxim,ds1742.txt | 12 ++++++++++++
 drivers/rtc/rtc-ds1742.c                               | 10 +++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/maxim,ds1742.txt

diff --git a/Documentation/devicetree/bindings/rtc/maxim,ds1742.txt b/Documentation/devicetree/bindings/rtc/maxim,ds1742.txt
new file mode 100644
index 0000000..d0f937c
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/maxim,ds1742.txt
@@ -0,0 +1,12 @@
+* Maxim (Dallas) DS1742/DS1743 Real Time Clock
+
+Required properties:
+- compatible: Should contain "maxim,ds1742".
+- reg: Physical base address of the RTC and length of memory
+  mapped region.
+
+Example:
+	rtc: rtc@10000000 {
+		compatible = "maxim,ds1742";
+		reg = <0x10000000 0x800>;
+	};
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 17b73fd..d7f74f5 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -13,12 +13,13 @@
  */
 
 #include <linux/bcd.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 #include <linux/rtc.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -215,12 +216,19 @@ static int ds1742_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id __maybe_unused ds1742_rtc_of_match[] = {
+	{ .compatible = "maxim,ds1742", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds1742_rtc_of_match);
+
 static struct platform_driver ds1742_rtc_driver = {
 	.probe		= ds1742_rtc_probe,
 	.remove		= ds1742_rtc_remove,
 	.driver		= {
 		.name	= "rtc-ds1742",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ds1742_rtc_of_match),
 	},
 };
 
-- 
1.8.3.2

