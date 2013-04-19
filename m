Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab3DSG3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:29:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56282 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000Ab3DSG2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:28:55 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] backlight: lp855x: remove duplicate platform data
Thread-Topic: [PATCH 4/5] backlight: lp855x: remove duplicate platform data
Thread-Index: Ac48xyABALiP3rIBQwG7aiIeDwi8Kg==
Date: Fri, 19 Apr 2013 06:28:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E562B6@DQHE06.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'load_new_rom_data' was used for checking whether new ROM data
should be updated or not.
However, we can decide it with 'size_program' data.
If the size is greater than 0, it means updating ROM area is required.
Otherwise, the default ROM data will be used.
Therefore, this duplicate platform data can be removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/backlight/lp855x-driver.txt |    4 ----
 drivers/video/backlight/lp855x_bl.c       |    2 +-
 include/linux/platform_data/lp855x.h      |    4 ----
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
index 72e2a67..1c732f0 100644
--- a/Documentation/backlight/lp855x-driver.txt
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -36,9 +36,6 @@ For supporting platform specific data, the lp855x platform data can be used.
 * initial_brightness : Initial value of backlight brightness.
 * period_ns : Platform specific PWM period value. unit is nano.
 	     Only valid when brightness is pwm input mode.
-* load_new_rom_data :
-	0 : use default configuration data
-	1 : update values of eeprom or eprom registers on loading driver
 * size_program : Total size of lp855x_rom_data.
 * rom_data : List of new eeprom/eprom registers.
 
@@ -55,7 +52,6 @@ static struct lp855x_platform_data lp8552_pdata = {
 	.name = "lcd-bl",
 	.device_control = I2C_CONFIG(LP8552),
 	.initial_brightness = INITIAL_BRT,
-	.load_new_rom_data = 1,
 	.size_program = ARRAY_SIZE(lp8552_eeprom_arr),
 	.rom_data = lp8552_eeprom_arr,
 };
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index b94dc00..f558f8f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -192,7 +192,7 @@ static int lp855x_configure(struct lp855x *lp)
 	if (ret)
 		goto err;
 
-	if (pd->load_new_rom_data && pd->size_program) {
+	if (pd->size_program > 0) {
 		for (i = 0; i < pd->size_program; i++) {
 			addr = pd->rom_data[i].addr;
 			val = pd->rom_data[i].val;
diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index a4ed0bd..ea32005 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -115,9 +115,6 @@ struct lp855x_rom_data {
  * @initial_brightness : initial value of backlight brightness
  * @period_ns : platform specific pwm period value. unit is nano.
 		Only valid when mode is PWM_BASED.
- * @load_new_rom_data :
-	0 : use default configuration data
-	1 : update values of eeprom or eprom registers on loading driver
  * @size_program : total size of lp855x_rom_data
  * @rom_data : list of new eeprom/eprom registers
  */
@@ -126,7 +123,6 @@ struct lp855x_platform_data {
 	u8 device_control;
 	u8 initial_brightness;
 	unsigned int period_ns;
-	u8 load_new_rom_data;
 	int size_program;
 	struct lp855x_rom_data *rom_data;
 };
-- 
1.7.9.5


Best Regards,
Milo


