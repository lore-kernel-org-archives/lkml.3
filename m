Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab3BAVSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:18:45 -0500
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35986 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab3BAVSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:18:40 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Vincent Palatin <vpalatin@chromium.org>, linux-kernel@vger.kernel.org,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH] hwmon: (lm90) Add device tree support
Date: Fri,  1 Feb 2013 13:18:22 -0800
Message-Id: <1359753502-13240-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to instantiate LM90-compatible sensors from a device-tree
configuration.
When the kernel has device tree support, we avoid doing the auto-detection
as probing the busses might mess-up sensitive I2C devices or trigger long
timeouts on non-functional busses.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 .../devicetree/bindings/i2c/trivial-devices.txt    | 19 +++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  1 +
 drivers/hwmon/lm90.c                               | 47 +++++++++++++++++++++-
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 446859f..4d991ca 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -10,6 +10,7 @@ document for it just like any other devices.
 Compatible		Vendor / Chip
 ==========		=============
 ad,ad7414		SMBus/I2C Digital Temperature Sensor in 6-Pin SOT with SMBus Alert and Over Temperature Pin
+ad,adm1032		+/-1C Remote and local system temperature monitor
 ad,adm9240		ADM9240:  Complete System Hardware Monitor for uProcessor-Based Systems
 adi,adt7461		+/-1C TDM Extended Temp Range I.C
 adt7461			+/-1C TDM Extended Temp Range I.C
@@ -35,16 +36,33 @@ fsl,mc13892		MC13892: Power Management Integrated Circuit (PMIC) for i.MX35/51
 fsl,mma8450		MMA8450Q: Xtrinsic Low-power, 3-axis Xtrinsic Accelerometer
 fsl,mpr121		MPR121: Proximity Capacitive Touch Sensor Controller
 fsl,sgtl5000		SGTL5000: Ultra Low-Power Audio Codec
+gmt,g781		+/-1C Remote and local temperature sensor
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
 maxim,max6625		9-Bit/12-Bit Temperature Sensors with I²C-Compatible Serial Interface
+maxim,max6646		+145C Precision SMBus-Compatible Remote/Local Sensors
+maxim,max6647		+145C Precision SMBus-Compatible Remote/Local Sensors
+maxim,max6649		+145C Precision SMBus-Compatible Remote/Local Sensors
+maxim,max6657		+/-1C SMBus-Compatible Remote/Local Sensors
+maxim,max6658		+/-1C SMBus-Compatible Remote/Local Sensors
+maxim,max6659		+/-1C SMBus-Compatible Remote/Local Sensors
+maxim,max6680		+/-1C Fail-Safe Remote/Local Temperature Sensors
+maxim,max6681		+/-1C Fail-Safe Remote/Local Temperature Sensors
+maxim,max6695		Dual Remote/Local Temperature Sensors
+maxim,max6696		Dual Remote/Local Temperature Sensors
 mc,rv3029c2		Real Time Clock Module with I2C-Bus
 national,lm75		I2C TEMP SENSOR
 national,lm80		Serial Interface ACPI-Compatible Microprocessor System Hardware Monitor
+national,lm86		+/-0.75C Accurate, Remote Diode and Local Digital Temperature Sensor with Two-Wire Interface
+national,lm89		+/-0.75C Remote and Local Digital Temperature Sensor with Two-Wire Interface-Wire Interface
+national,lm90		+/-3C Accurate, Remote Diode and Local Digital Temperature Sensor with Two-Wire Interface
 national,lm92		±0.33°C Accurate, 12-Bit + Sign Temperature Sensor and Thermal Window Comparator with Two-Wire Interface
+national,lm99		+/-1C Accurate, Remote Diode and Local Digital Temperature Sensor with Two-Wire Interface
 nxp,pca9556		Octal SMBus and I2C registered interface
 nxp,pca9557		8-bit I2C-bus and SMBus I/O port with reset
 nxp,pcf8563		Real-time clock/calendar
+nxp,sa56004		remote/local digital temperature sensor with overtemperature alarms
+onnn,nct1008		+/-1C Temperature Monitor with Series Resistance Cancellation
 ovti,ov5642		OV5642: Color CMOS QSXGA (5-megapixel) Image Sensor with OmniBSI and Embedded TrueFocus
 pericom,pt7c4338	Real-time Clock Module
 plx,pex8648		48-Lane, 12-Port PCI Express Gen 2 (5.0 GT/s) Switch
@@ -59,3 +77,4 @@ taos,tsl2550		Ambient Light Sensor with SMBUS/Two Wire Serial Interface
 ti,tsc2003		I2C Touch-Screen Controller
 ti,tmp102		Low Power Digital Temperature Sensor with SMBUS/Two Wire Serial Interface
 ti,tmp275		Digital Temperature Sensor
+winbond,w83l771		H/W Monitor IC
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 902b1b1..2074699 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -23,6 +23,7 @@ est	ESTeem Wireless Modems
 fsl	Freescale Semiconductor
 GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
 gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
+gmt	Global Mixed-mode Technology Inc.
 hp	Hewlett Packard
 ibm	International Business Machines (IBM)
 idt	Integrated Device Technologies, Inc.
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 863412a..c07fd19 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -106,8 +106,11 @@
  */
 
 static const unsigned short normal_i2c[] = {
+#ifndef CONFIG_OF
 	0x18, 0x19, 0x1a, 0x29, 0x2a, 0x2b, 0x48, 0x49, 0x4a, 0x4b, 0x4c,
-	0x4d, 0x4e, 0x4f, I2C_CLIENT_END };
+	0x4d, 0x4e, 0x4f,
+#endif
+	I2C_CLIENT_END };
 
 enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
 	max6646, w83l771, max6696, sa56004, g781 };
@@ -209,6 +212,32 @@ static const struct i2c_device_id lm90_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, lm90_id);
 
+#ifdef CONFIG_OF
+static struct of_device_id lm90_dt_match[] = {
+	{ .compatible = "ad,adm1032", .data = (void *)adm1032 },
+	{ .compatible = "adi,adt7461", .data = (void *)adt7461 },
+	{ .compatible = "gmt,g781", .data = (void *)g781 },
+	{ .compatible = "national,lm90", .data = (void *)lm90 },
+	{ .compatible = "national,lm86", .data = (void *)lm86 },
+	{ .compatible = "national,lm89", .data = (void *)lm86 },
+	{ .compatible = "national,lm99", .data = (void *)lm99 },
+	{ .compatible = "maxim,max6646", .data = (void *)max6646 },
+	{ .compatible = "maxim,max6647", .data = (void *)max6646 },
+	{ .compatible = "maxim,max6649", .data = (void *)max6646 },
+	{ .compatible = "maxim,max6657", .data = (void *)max6657 },
+	{ .compatible = "maxim,max6658", .data = (void *)max6657 },
+	{ .compatible = "maxim,max6659", .data = (void *)max6659 },
+	{ .compatible = "maxim,max6680", .data = (void *)max6680 },
+	{ .compatible = "maxim,max6681", .data = (void *)max6680 },
+	{ .compatible = "maxim,max6695", .data = (void *)max6696 },
+	{ .compatible = "maxim,max6696", .data = (void *)max6696 },
+	{ .compatible = "onnn,nct1008", .data = (void *)adt7461 },
+	{ .compatible = "winbond,w83l771", .data = (void *)w83l771 },
+	{ .compatible = "nxp,sa56004", .data = (void *)sa56004 },
+	{ }
+};
+#endif
+
 /*
  * chip type specific parameters
  */
@@ -1391,6 +1420,19 @@ static void lm90_init_client(struct i2c_client *client)
 		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
 }
 
+static inline int lm90_get_driver_data(struct i2c_client *i2c,
+				       const struct i2c_device_id *id)
+{
+#ifdef CONFIG_OF
+	if (i2c->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(lm90_dt_match, i2c->dev.of_node);
+		return (int)match->data;
+	}
+#endif
+	return (int)id->driver_data;
+}
+
 static int lm90_probe(struct i2c_client *client,
 		      const struct i2c_device_id *id)
 {
@@ -1407,7 +1449,7 @@ static int lm90_probe(struct i2c_client *client,
 	mutex_init(&data->update_lock);
 
 	/* Set the device type */
-	data->kind = id->driver_data;
+	data->kind = lm90_get_driver_data(client, id);
 	if (data->kind == adm1032) {
 		if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
 			client->flags &= ~I2C_CLIENT_PEC;
@@ -1533,6 +1575,7 @@ static struct i2c_driver lm90_driver = {
 	.class		= I2C_CLASS_HWMON,
 	.driver = {
 		.name	= "lm90",
+		.of_match_table = of_match_ptr(lm90_dt_match),
 	},
 	.probe		= lm90_probe,
 	.remove		= lm90_remove,
-- 
1.8.1

