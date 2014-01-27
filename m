Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaA0RrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:47:06 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62368 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaA0RrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:47:03 -0500
From: Luis Ortega <luiorpe1@upv.es>
To: dmitry.torokhov@gmail.com
Cc: heiko@sntech.de, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Ortega <luiorpe1@upv.es>
Subject: [PATCH 3/4] Input: zforce - Remove unnecessary payload data checks
Date: Mon, 27 Jan 2014 19:46:12 +0100
Message-Id: <1390848373-7723-4-git-send-email-luiorpe1@upv.es>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
References: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function zforce_read_packet() reads 2 values (bytes) of payload
header, validates them and then proceeds to read the payload body.
The function stores all these in a u8 buffer.

The PAYLOAD_LENGTH check seems to be trying to detect an overflow error.
However, since we are just reading a u8 value from the buffer, these
checks are unnecessary and we should simply compare against zero.

Signed-off-by: Luis Ortega <luiorpe1@upv.es>
---
 drivers/input/touchscreen/zforce_ts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/zforce_ts.c b/drivers/input/touchscreen/zforce_ts.c
index c1b6b82..e082d5c 100644
--- a/drivers/input/touchscreen/zforce_ts.c
+++ b/drivers/input/touchscreen/zforce_ts.c
@@ -423,7 +423,7 @@ static int zforce_read_packet(struct zforce_ts *ts, u8 *buf)
 		goto unlock;
 	}
 
-	if (buf[PAYLOAD_LENGTH] <= 0 || buf[PAYLOAD_LENGTH] > 255) {
+	if (buf[PAYLOAD_LENGTH] == 0) {
 		dev_err(&client->dev, "invalid payload length: %d\n",
 			buf[PAYLOAD_LENGTH]);
 		ret = -EIO;
-- 
1.8.5.3

