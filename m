Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaJ0ORT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:17:19 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39057 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaJ0ORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:17:14 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/6] rtc: pcf8563 Remove leftover code
Date: Mon, 27 Oct 2014 15:16:56 +0100
Message-Id: <1414419421-11098-2-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
References: <1414419421-11098-1-git-send-email-jan.kardell@telliq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some code that was left from before block read/write was used.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
---
 drivers/rtc/rtc-pcf8563.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index c2ef0a2..1a865c9 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -118,22 +118,21 @@ static int pcf8563_write_block_data(struct i2c_client *client,
 
 static int pcf8563_set_alarm_mode(struct i2c_client *client, bool on)
 {
-	unsigned char buf[2];
+	unsigned char buf;
 	int err;
 
-	err = pcf8563_read_block_data(client, PCF8563_REG_ST2, 1, buf + 1);
+	err = pcf8563_read_block_data(client, PCF8563_REG_ST2, 1, &buf);
 	if (err < 0)
 		return err;
 
 	if (on)
-		buf[1] |= PCF8563_BIT_AIE;
+		buf |= PCF8563_BIT_AIE;
 	else
-		buf[1] &= ~PCF8563_BIT_AIE;
+		buf &= ~PCF8563_BIT_AIE;
 
-	buf[1] &= ~PCF8563_BIT_AF;
-	buf[0] = PCF8563_REG_ST2;
+	buf &= ~PCF8563_BIT_AF;
 
-	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, buf + 1);
+	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, &buf);
 	if (err < 0) {
 		dev_err(&client->dev, "%s: write error\n", __func__);
 		return -EIO;
-- 
1.8.4.5

