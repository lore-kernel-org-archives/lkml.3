Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3D2Jzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:55:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51928 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3D2Jzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:55:53 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Lucas Stach <l.stach@pengutronix.de>, Jan Luebbe <jlu@pengutronix.de>
Subject: [PATCH] rtc: rs5c372: add R2221T/L variant to the driver
Date: Mon, 29 Apr 2013 11:55:28 +0200
Message-Id: <1367229328-25564-1-git-send-email-jlu@pengutronix.de>
X-Mailer: git-send-email 1.8.2.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

Register layout is the same, so just add the variant to the
appropriate places.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
---
 drivers/rtc/rtc-rs5c372.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 581739f..b533acf 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -68,6 +68,7 @@
 enum rtc_type {
 	rtc_undef = 0,
 	rtc_r2025sd,
+	rtc_r2221tl,
 	rtc_rs5c372a,
 	rtc_rs5c372b,
 	rtc_rv5c386,
@@ -76,6 +77,7 @@ enum rtc_type {
 
 static const struct i2c_device_id rs5c372_id[] = {
 	{ "r2025sd", rtc_r2025sd },
+	{ "r2221tl", rtc_r2221tl },
 	{ "rs5c372a", rtc_rs5c372a },
 	{ "rs5c372b", rtc_rs5c372b },
 	{ "rv5c386", rtc_rv5c386 },
@@ -529,6 +531,7 @@ static int rs5c_oscillator_setup(struct rs5c372 *rs5c372)
 		rs5c372->time24 = 1;
 		break;
 	case rtc_r2025sd:
+	case rtc_r2221tl:
 	case rtc_rv5c386:
 	case rtc_rv5c387a:
 		buf[0] |= RV5C387_CTRL1_24;
@@ -607,6 +610,7 @@ static int rs5c372_probe(struct i2c_client *client,
 			rs5c372->time24 = 1;
 		break;
 	case rtc_r2025sd:
+	case rtc_r2221tl:
 	case rtc_rv5c386:
 	case rtc_rv5c387a:
 		if (rs5c372->regs[RS5C_REG_CTRL1] & RV5C387_CTRL1_24)
@@ -638,6 +642,7 @@ static int rs5c372_probe(struct i2c_client *client,
 	dev_info(&client->dev, "%s found, %s, driver version " DRV_VERSION "\n",
 			({ char *s; switch (rs5c372->type) {
 			case rtc_r2025sd:	s = "r2025sd"; break;
+			case rtc_r2221tl:	s = "r2221tl"; break;
 			case rtc_rs5c372a:	s = "rs5c372a"; break;
 			case rtc_rs5c372b:	s = "rs5c372b"; break;
 			case rtc_rv5c386:	s = "rv5c386"; break;
-- 
1.8.2.rc2

