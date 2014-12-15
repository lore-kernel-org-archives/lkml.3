Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaLOQVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:21:03 -0500
Received: from mx02.posteo.de ([89.146.194.165]:32940 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbaLOQTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:19:14 -0500
From: Martin Kepplinger <martink@posteo.de>
To: peterz@infradead.org
Cc: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 5/6] rtc: use sign_extend8 instead of manual conversion
Date: Mon, 15 Dec 2014 17:18:36 +0100
Message-Id: <1418660317-21750-6-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418660317-21750-1-git-send-email-martink@posteo.de>
References: <1418660317-21750-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/rtc/rtc-x1205.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index b1de58e..3ec0b95 100644
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
+	atr = sign_extend8(atr, 5);
 
 	dev_dbg(&client->dev, "%s: raw atr=%x (%d)\n", __func__, atr, atr);
 
-- 
2.1.3

