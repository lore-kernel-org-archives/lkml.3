Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3DSG2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 02:28:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35030 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3DSG2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 02:28:48 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] backlight: lp855x: convert a type of device name
Thread-Topic: [PATCH 1/5] backlight: lp855x: convert a type of device name
Thread-Index: Ac48xxu2gIULZeO8SEa8sAK1sWq87w==
Date: Fri, 19 Apr 2013 06:28:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E5629E@DQHE06.ent.ti.com>
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

Configurable data, backlight device name is set to constant character type.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c  |    2 +-
 include/linux/platform_data/lp855x.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index c98bdbf..df937ce 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -273,7 +273,7 @@ static int lp855x_backlight_register(struct lp855x *lp)
 	struct backlight_device *bl;
 	struct backlight_properties props;
 	struct lp855x_platform_data *pdata = lp->pdata;
-	char *name = pdata->name ? : DEFAULT_BL_NAME;
+	const char *name = pdata->name ? : DEFAULT_BL_NAME;
 
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = MAX_BRIGHTNESS;
diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index 20ee8b2..d135939 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -128,7 +128,7 @@ struct lp855x_rom_data {
  * @rom_data : list of new eeprom/eprom registers
  */
 struct lp855x_platform_data {
-	char *name;
+	const char *name;
 	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
-- 
1.7.9.5


Best Regards,
Milo


