Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3IVTv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 15:51:59 -0400
Received: from svenfoo.org ([82.94.215.22]:59109 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3IVTv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 15:51:57 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, devicetree@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>
Subject: [PATCH 4/4] drivers: misc: ti_dac7512: add support for DT matching
Date: Sun, 22 Sep 2013 21:51:49 +0200
Message-Id: <1379879509-3608-5-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379879509-3608-1-git-send-email-zonque@gmail.com>
References: <1379879509-3608-1-git-send-email-zonque@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only matching is done via DT, no other details can be passed.

Signed-off-by: Daniel Mack <zonque@gmail.com>
---
 .../devicetree/bindings/misc/ti,dac7512.txt          | 20 ++++++++++++++++++++
 drivers/misc/ti_dac7512.c                            | 10 ++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/ti,dac7512.txt

diff --git a/Documentation/devicetree/bindings/misc/ti,dac7512.txt b/Documentation/devicetree/bindings/misc/ti,dac7512.txt
new file mode 100644
index 0000000..1db4593
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/ti,dac7512.txt
@@ -0,0 +1,20 @@
+TI DAC7512 DEVICETREE BINDINGS
+
+Required properties:
+
+	- "compatible"		Must be set to "ti,dac7512"
+
+Property rules described in Documentation/devicetree/bindings/spi/spi-bus.txt
+apply. In particular, "reg" and "spi-max-frequency" properties must be given.
+
+
+Example:
+
+	spi_master {
+		dac7512: dac7512@0 {
+			compatible = "ti,dac7512";
+			reg = <0>; /* CS0 */
+			spi-max-frequency = <1000000>;
+		};
+	};
+
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index 6393a68..83da711 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/spi/spi.h>
+#include <linux/of.h>
 
 static ssize_t dac7512_store_val(struct device *dev,
 				 struct device_attribute *attr,
@@ -78,10 +79,19 @@ static const struct spi_device_id dac7512_id_table[] = {
 };
 MODULE_DEVICE_TABLE(spi, dac7512_id_table);
 
+#ifdef CONFIG_OF
+static const struct of_device_id dac7512_of_match[] = {
+	{ .compatible = "ti,dac7512", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, dac7512_of_match);
+#endif
+
 static struct spi_driver dac7512_driver = {
 	.driver = {
 		.name	= "dac7512",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(dac7512_of_match),
 	},
 	.probe	= dac7512_probe,
 	.remove	= dac7512_remove,
-- 
1.8.3.1

