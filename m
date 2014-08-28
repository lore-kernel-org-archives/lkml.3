Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaH1OpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:45:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38261 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaH1OpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:45:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/4] mfd: max8925-i2c: Fix variable length array Sparse warning
Date: Thu, 28 Aug 2014 15:44:45 +0100
Message-Id: <1409237086-21421-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409237086-21421-1-git-send-email-lee.jones@linaro.org>
References: <1409237086-21421-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The largest byte size in use currently is 8.  Fix array size to 9.

drivers/mfd/max8925-i2c.c:40:33:
  warning: Variable length array is used

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max8925-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
index ecbe78e..c880c89 100644
--- a/drivers/mfd/max8925-i2c.c
+++ b/drivers/mfd/max8925-i2c.c
@@ -37,7 +37,7 @@ static inline int max8925_read_device(struct i2c_client *i2c,
 static inline int max8925_write_device(struct i2c_client *i2c,
 				       int reg, int bytes, void *src)
 {
-	unsigned char buf[bytes + 1];
+	unsigned char buf[9];
 	int ret;
 
 	buf[0] = (unsigned char)reg;
-- 
1.9.1

