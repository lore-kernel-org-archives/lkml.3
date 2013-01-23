Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3AWJiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:38:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37594 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3AWJiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:38:09 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] leds: fix build error for LP55xx Common driver
Thread-Topic: [PATCH v2] leds: fix build error for LP55xx Common driver
Thread-Index: Ac35TVWGvO+1Z1FLRRiR/F1JZ8E8SA==
Date: Wed, 23 Jan 2013 09:38:00 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1C2B9@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To solve undefined symbols for LED class and I2C, lp55xx-common driver should
support a module build as well.

In case of CONFIG_I2C=m, CONFIG_LEDS_LP5521/5523=m, it still has undefined
symbol problems because CONFIG_LEDS_LP55XX_COMMON can be selected as 'y'.
Moreover, I2C functions are used in both LP5521 and LP5523 drivers.
Therefore, each LP55xx driver should have an 'I2C' dependency.

make x86_64 allmodconfig failed like this:

drivers/built-in.o: In function `lp55xx_unregister_leds':
(.text+0x161dab): undefined reference to `led_classdev_unregister'

drivers/built-in.o: In function `lp55xx_init_led':
leds-lp55xx-common.c:(.text+0x161f23): undefined reference to `led_classdev_register'
leds-lp55xx-common.c:(.text+0x161f9f): undefined reference to `led_classdev_unregister'

drivers/built-in.o: In function `lp55xx_read':
(.text+0x1621b3): undefined reference to `i2c_smbus_read_byte_data'
drivers/built-in.o: In function `lp55xx_init_device':
(.text+0x1622f0): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `lp55xx_init_device':
(.text+0x162331): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `lp55xx_update_bits':
(.text+0x162492): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `lp55xx_write':
(.text+0x1624c5): undefined reference to `i2c_smbus_write_byte_data'

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index c7c5280..09a6984 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -194,9 +194,8 @@ config LEDS_LP3944
 	  module will be called leds-lp3944.
 
 config LEDS_LP55XX_COMMON
-	bool "Common Driver for TI/National LP5521 and LP5523/55231"
+	tristate "Common Driver for TI/National LP5521 and LP5523/55231"
 	depends on LEDS_LP5521 || LEDS_LP5523
-	depends on I2C
 	select FW_LOADER
 	help
 	  This option supports common operations for LP5521 and LP5523/55231
@@ -205,6 +204,7 @@ config LEDS_LP55XX_COMMON
 config LEDS_LP5521
 	tristate "LED Support for N.S. LP5521 LED driver chip"
 	depends on LEDS_CLASS
+	depends on I2C
 	select LEDS_LP55XX_COMMON
 	help
 	  If you say yes here you get support for the National Semiconductor
@@ -215,6 +215,7 @@ config LEDS_LP5521
 config LEDS_LP5523
 	tristate "LED Support for TI/National LP5523/55231 LED driver chip"
 	depends on LEDS_CLASS
+	depends on I2C
 	select LEDS_LP55XX_COMMON
 	help
 	  If you say yes here you get support for TI/National Semiconductor
-- 
1.7.9.5


Best Regards,
Milo


