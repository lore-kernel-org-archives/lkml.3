Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3CYQWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:22:13 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.102]:12347 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757896Ab3CYQWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:22:12 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-7.tower-201.messagelabs.com!1364228528!6572352!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: <zbr@ioremap.net>, <hector.palacios@digi.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20w1=3A=20ds2482=3A=20add=20device=20tree=20probe=20support?=
Date: Mon, 25 Mar 2013 17:21:34 +0100
Message-ID: <1364228494-11580-1-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It adds device tree probe support for ds2482 driver.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---
 .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
 drivers/w1/masters/ds2482.c                        |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 446859f..c16882b 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -36,6 +36,7 @@ fsl,mma8450		MMA8450Q: Xtrinsic Low-power, 3-axis Xtrinsic Accelerometer
 fsl,mpr121		MPR121: Proximity Capacitive Touch Sensor Controller
 fsl,sgtl5000		SGTL5000: Ultra Low-Power Audio Codec
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
+maxim,ds2482		i2c to w1-master bridge(s)
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
 maxim,max6625		9-Bit/12-Bit Temperature Sensors with I²C-Compatible Serial Interface
 mc,rv3029c2		Real Time Clock Module with I2C-Bus
diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index 6429b9e..a93e431 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <asm/delay.h>
+#include <linux/of_device.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -85,7 +86,6 @@ static int ds2482_probe(struct i2c_client *client,
 			const struct i2c_device_id *id);
 static int ds2482_remove(struct i2c_client *client);
 
-
 /**
  * Driver data (common to all clients)
  */
@@ -94,10 +94,17 @@ static const struct i2c_device_id ds2482_id[] = {
 	{ }
 };
 
+static const struct of_device_id ds2482_dt_ids[] = {
+	{ .compatible = "maxim,ds2482" },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, ds2482_dt_ids);
+
 static struct i2c_driver ds2482_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= "ds2482",
+		.of_match_table = ds2482_dt_ids,
 	},
 	.probe		= ds2482_probe,
 	.remove		= ds2482_remove,
-- 
1.7.9.5

