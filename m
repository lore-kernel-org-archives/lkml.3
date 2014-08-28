Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaH1Op6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:45:58 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62863 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaH1OpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:45:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/4] mfd: 88pm860x-i2c: Fix variable length array Sparse warning
Date: Thu, 28 Aug 2014 15:44:44 +0100
Message-Id: <1409237086-21421-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409237086-21421-1-git-send-email-lee.jones@linaro.org>
References: <1409237086-21421-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mfd/88pm860x-i2c.c:125:33:
  warning: Variable length array is used.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/88pm860x-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm860x-i2c.c b/drivers/mfd/88pm860x-i2c.c
index 7063cfd..84e3131 100644
--- a/drivers/mfd/88pm860x-i2c.c
+++ b/drivers/mfd/88pm860x-i2c.c
@@ -122,7 +122,7 @@ static int read_device(struct i2c_client *i2c, int reg,
 static int write_device(struct i2c_client *i2c, int reg,
 			int bytes, void *src)
 {
-	unsigned char buf[bytes + 1];
+	unsigned char buf[2];
 	struct i2c_adapter *adap = i2c->adapter;
 	struct i2c_msg msg;
 	int ret;
-- 
1.9.1

