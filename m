Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbbAXQFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 11:05:48 -0500
Received: from mx02.posteo.de ([89.146.194.165]:48801 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbbAXQFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 11:05:47 -0500
From: Martin Kepplinger <martink@posteo.de>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] rtc: (x1205) use sign_extend32() for sign extension
Date: Sat, 24 Jan 2015 17:05:24 +0100
Message-Id: <1422115524-12823-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
Despite it's name, sign_extend32() is safe to use for 8 bit types
too. (see https://lkml.org/lkml/2015/1/18/289 if interested)

 drivers/rtc/rtc-x1205.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index b1de58e..5638b7b 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -22,6 +22,7 @@
 #include <linux/rtc.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/bitops.h>
 
 #define DRV_VERSION "1.0.8"
 
@@ -366,8 +367,7 @@ static int x1205_get_atrim(struct i2c_client *client, int *trim)
 	 * perform sign extension. The formula is
 	 * Catr = (atr * 0.25pF) + 11.00pF.
 	 */
-	if (atr & 0x20)
-		atr |= 0xC0;
+	atr = sign_extend32(atr, 5);
 
 	dev_dbg(&client->dev, "%s: raw atr=%x (%d)\n", __func__, atr, atr);
 
-- 
2.1.4

