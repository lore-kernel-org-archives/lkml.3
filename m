Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbbAOBfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:35:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:47691 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbAOBfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:35:01 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org
Cc: linux-samsung-soc@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jean Delvare <jdelvare@suse.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] hwmon: (ina2xx) Add ina231 compatible string
Date: Wed, 14 Jan 2015 17:34:58 -0800
Message-Id: <1421285699-8469-1-git-send-email-khilman@kernel.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@linaro.org>

Add support for "ina231" as compatible string, and update
Documentation and Kconfig accordingly.

Tested with the Exynos5422-based odroid-xu3 board which has on-board
INA231 sensors.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 Documentation/hwmon/ina2xx | 9 +++++++++
 drivers/hwmon/Kconfig      | 4 ++--
 drivers/hwmon/ina2xx.c     | 1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
index 4223c2d3b508..c2f838f65ee4 100644
--- a/Documentation/hwmon/ina2xx
+++ b/Documentation/hwmon/ina2xx
@@ -26,6 +26,12 @@ Supported chips:
     Datasheet: Publicly available at the Texas Instruments website
                http://www.ti.com/
 
+  * Texas Instruments INA231
+    Prefix: 'ina231'
+    Addresses: I2C 0x40 - 0x4f
+    Datasheet: Publicly available at the Texas Instruments website
+               http://www.ti.com/
+
 Author: Lothar Felten <l-felten@ti.com>
 
 Description
@@ -44,6 +50,9 @@ The INA226 monitors both a shunt voltage drop and bus supply voltage.
 The INA230 is a high or low side current shunt and power monitor with an I2C
 interface. The INA230 monitors both a shunt voltage drop and bus supply voltage.
 
+The INA231 is a high or low side current shunt and power monitor with an I2C
+interface. The INA230 monitors both a shunt voltage drop and bus supply voltage.
+
 The shunt value in micro-ohms can be set via platform data or device tree.
 Please refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
 if the device tree is used.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 6529c09c46f0..408fb6f5f055 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1420,8 +1420,8 @@ config SENSORS_INA2XX
 	tristate "Texas Instruments INA219 and compatibles"
 	depends on I2C
 	help
-	  If you say yes here you get support for INA219, INA220, INA226, and
-	  INA230 power monitor chips.
+	  If you say yes here you get support for INA219, INA220, INA226,
+	  INA230, and INA231 power monitor chips.
 
 	  The INA2xx driver is configured for the default configuration of
 	  the part as described in the datasheet.
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index e01feba909c3..8c4a29bd2eaf 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -287,6 +287,7 @@ static const struct i2c_device_id ina2xx_id[] = {
 	{ "ina220", ina219 },
 	{ "ina226", ina226 },
 	{ "ina230", ina226 },
+	{ "ina231", ina226 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ina2xx_id);
-- 
2.1.3

