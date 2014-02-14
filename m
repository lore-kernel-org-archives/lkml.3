Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaBNNV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:21:27 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:56240 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaBNNVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:21:25 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        jdelvare@suse.de, linux@roeck-us.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH] hwmon: twl4030-madc-hwmon: Add device tree support.
Date: Fri, 14 Feb 2014 14:20:58 +0100
Message-Id: <1392384058-14240-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt |  9 +++++++++
 drivers/hwmon/twl4030-madc-hwmon.c                             | 10 ++++++++++
 2 files changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt

diff --git a/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
new file mode 100644
index 0000000..e8016d1
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
@@ -0,0 +1,9 @@
+TWL4030 MADC hwmon.
+
+Required properties:
+- compatible: "ti,twl4030-madc-hwmon"
+
+Example:
+madc-hwmon {
+	compatible = "ti,twl4030-madc-hwmon";
+};
diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
index 6c6d440..05fb572 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -96,6 +96,15 @@ static const struct attribute_group twl4030_madc_group = {
 	.attrs = twl4030_madc_attributes,
 };
 
+#ifdef CONFIG_OF
+
+static const struct of_device_id of_twl4030_madc_hwmon_match[] = {
+	{ .compatible = "ti,twl4030-madc-hwmon", },
+	{},
+};
+
+#endif
+
 static int twl4030_madc_hwmon_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -134,6 +143,7 @@ static struct platform_driver twl4030_madc_hwmon_driver = {
 	.driver = {
 		   .name = "twl4030_madc_hwmon",
 		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(of_twl4030_madc_hwmon_match),
 		   },
 };
 
-- 
1.8.3.2

