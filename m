Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab3HNI2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:28:48 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:39413 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769Ab3HNI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:28:45 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 4/4] mfd: 88pm805: add device tree support
Date: Wed, 14 Aug 2013 04:28:50 -0400
Message-ID: <1376468930-9794-5-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 Documentation/devicetree/bindings/mfd/88pm805.c |   15 +++++++++++++++
 drivers/mfd/88pm805.c                           |    8 ++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/88pm805.c

diff --git a/Documentation/devicetree/bindings/mfd/88pm805.c b/Documentation/devicetree/bindings/mfd/88pm805.c
new file mode 100644
index 0000000..f3878a3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/88pm805.c
@@ -0,0 +1,15 @@
+* Marvell 88PM805 Power Management IC
+
+Required parent device properties:
+- compatible : "marvell,88pm805"
+- reg : the I2C slave address for the 88pm805 chip
+- interrupts : IRQ line for the 88pm805 chip
+
+Example:
+
+	pmic: 88pm805@38 {
+		compatible = "marvell,88pm805";
+		reg = <0x38>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <124 0x1>;
+	};
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 57135bb..f6e0e55 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -28,6 +28,7 @@
 #include <linux/mfd/88pm80x.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/of_device.h>
 
 static const struct i2c_device_id pm80x_id_table[] = {
 	{"88PM805", 0},
@@ -35,6 +36,12 @@ static const struct i2c_device_id pm80x_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, pm80x_id_table);
 
+static const struct of_device_id pm80x_dt_ids[] = {
+	{ .compatible = "marvell,88pm805", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, pm80x_dt_ids);
+
 /* Interrupt Number in 88PM805 */
 enum {
 	PM805_IRQ_LDO_OFF,	/*0 */
@@ -269,6 +276,7 @@ static struct i2c_driver pm805_driver = {
 		.name = "88PM805",
 		.owner = THIS_MODULE,
 		.pm = &pm80x_pm_ops,
+		.of_match_table	= of_match_ptr(pm80x_dt_ids),
 		},
 	.probe = pm805_probe,
 	.remove = pm805_remove,
-- 
1.7.4.1

