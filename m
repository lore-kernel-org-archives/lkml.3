Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935174Ab3BTEkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:40:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33368 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935176Ab3BTEka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:40:30 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] backlight: lp855x_bl: simplify bl_get_brightness()
Thread-Topic: [PATCH 3/3] backlight: lp855x_bl: simplify bl_get_brightness()
Thread-Index: Ac4PJGJQ7DBO0j0GSpuZgOili6bgZQ==
Date: Wed, 20 Feb 2013 04:40:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792735D5@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting the brightness value is not critical, no need to read the actual
register value. To simplify it, just return the 'bl->props.brightness' value.
Then, lp855x_read_byte() can be removed, not used any more.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c |   24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index edd2041..7ae9ae6 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -66,20 +66,6 @@ struct lp855x {
 	struct pwm_device *pwm;
 };
 
-static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
-{
-	int ret;
-
-	ret = i2c_smbus_read_byte_data(lp->client, reg);
-	if (ret < 0) {
-		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
-		return ret;
-	}
-
-	*data = (u8)ret;
-	return 0;
-}
-
 static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
 {
 	return i2c_smbus_write_byte_data(lp->client, reg, data);
@@ -274,16 +260,6 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
 
 static int lp855x_bl_get_brightness(struct backlight_device *bl)
 {
-	struct lp855x *lp = bl_get_data(bl);
-	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
-
-	if (mode == REGISTER_BASED) {
-		u8 val = 0;
-
-		lp855x_read_byte(lp, lp->cfg->reg_brightness, &val);
-		bl->props.brightness = val;
-	}
-
 	return bl->props.brightness;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


