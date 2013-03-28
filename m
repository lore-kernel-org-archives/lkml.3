Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab3C1Jxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:53:55 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:57706 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3C1Jxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:53:54 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 05:53:54 EDT
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        arc-linux-dev@synopsys.com, Vineet.Gupta1@synopsys.com
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] Input: arc_ps2 - add support for device tree
Date: Thu, 28 Mar 2013 10:46:26 +0100
Message-Id: <1364463986-23012-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add match table for device tree binding and dts binding doc.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 .../devicetree/bindings/serio/snps-arc_ps2.txt     |   16 ++++++++++++++++
 drivers/input/serio/arc_ps2.c                      |   14 ++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serio/snps-arc_ps2.txt

diff --git a/Documentation/devicetree/bindings/serio/snps-arc_ps2.txt b/Documentation/devicetree/bindings/serio/snps-arc_ps2.txt
new file mode 100644
index 0000000..38c2f21
--- /dev/null
+++ b/Documentation/devicetree/bindings/serio/snps-arc_ps2.txt
@@ -0,0 +1,16 @@
+* ARC PS/2 driver: PS/2 block used in some ARC FPGA's & nSIM OSCI model
+
+Required properties:
+- compatible		: "snps,arc_ps2"
+- reg			: offset and length (always 0x14) of registers
+- interrupts		: interrupt
+- interrupt-names	: name of interrupt, must be "arc_ps2_irq"
+
+Example:
+
+serio@c9000400 {
+	compatible = "snps,arc_ps2";
+	reg = <0xc9000400 0x14>;
+	interrupts = <13>;
+	interrupt-names = "arc_ps2_irq";
+}
diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
index c52e3e5..76a685d 100644
--- a/drivers/input/serio/arc_ps2.c
+++ b/drivers/input/serio/arc_ps2.c
@@ -14,6 +14,7 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -259,10 +260,19 @@ static int arc_ps2_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id arc_ps2_match[] = {
+	{ .compatible = "snps,arc_ps2" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, arc_ps2_match);
+#endif
+
 static struct platform_driver arc_ps2_driver = {
 	.driver	= {
-		.name	= "arc_ps2",
-		.owner	= THIS_MODULE,
+		.name		= "arc_ps2",
+		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(arc_ps2_match),
 	},
 	.probe	= arc_ps2_probe,
 	.remove	= arc_ps2_remove,
-- 
1.7.0.4

