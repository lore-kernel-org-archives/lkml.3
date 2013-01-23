Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3AWFpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:45:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58265 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3AWFpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:45:17 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: fix module build error for LP55xx common driver
Thread-Topic: [PATCH] leds: fix module build error for LP55xx common driver
Thread-Index: Ac35LM0JVhO/wZONSii0iT/CpmAj8A==
Date: Wed, 23 Jan 2013 05:45:08 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E1C1FD@DQHE02.ent.ti.com>
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

To solve undefined symbol errors for LED class and I2C, lp55xx-common driver
should support a module build as well.

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
 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index c7c5280..bba1bac 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -194,7 +194,7 @@ config LEDS_LP3944
 	  module will be called leds-lp3944.
 
 config LEDS_LP55XX_COMMON
-	bool "Common Driver for TI/National LP5521 and LP5523/55231"
+	tristate "Common Driver for TI/National LP5521 and LP5523/55231"
 	depends on LEDS_LP5521 || LEDS_LP5523
 	depends on I2C
 	select FW_LOADER
-- 
1.7.9.5


Best Regards,
Milo


