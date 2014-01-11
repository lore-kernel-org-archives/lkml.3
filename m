Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaAKVRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 16:17:38 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45272 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaAKVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 16:17:35 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        jic23@kernel.org, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH] iio: gyro: itg3200: Add DT support.
Date: Sat, 11 Jan 2014 22:17:27 +0100
Message-Id: <1389475047-4353-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 .../devicetree/bindings/iio/gyro/itg3200.txt       | 22 ++++++++++++++++++++++
 drivers/iio/gyro/itg3200_core.c                    |  9 +++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/gyro/itg3200.txt

diff --git a/Documentation/devicetree/bindings/iio/gyro/itg3200.txt b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
new file mode 100644
index 0000000..b1b18dc
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/gyro/itg3200.txt
@@ -0,0 +1,22 @@
+* InvenSense ITG-3200 gyroscope
+
+http://www.invensense.com/mems/gyro/itg3200.html
+
+Required properties:
+
+  - compatible : should be "invensense,itg3200"
+  - reg : the I2C address of the sensor
+
+Optional properties:
+
+  - interrupt-parent : should be the phandle for the interrupt controller
+  - interrupts : interrupt mapping for GPIO IRQ
+
+Example:
+
+itg3200@68 {
+	compatible = "invensense,itg3200";
+	reg = <0x68>;
+	interrupt-parent = <&gpio2>;
+	interrupts = <29 IRQ_TYPE_EDGE_RISING>;
+};
diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200_core.c
index 4d3f3b9..adbf20d 100644
--- a/drivers/iio/gyro/itg3200_core.c
+++ b/drivers/iio/gyro/itg3200_core.c
@@ -374,10 +374,19 @@ static const struct i2c_device_id itg3200_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, itg3200_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id itg3200_of_match[] = {
+	{ .compatible = "invensense,itg3200", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, itg3200_of_match);
+#endif
+
 static struct i2c_driver itg3200_driver = {
 	.driver = {
 		.owner  = THIS_MODULE,
 		.name	= "itg3200",
+		.of_match_table = of_match_ptr(itg3200_of_match),
 	},
 	.id_table	= itg3200_id,
 	.probe		= itg3200_probe,
-- 
1.8.4.2

