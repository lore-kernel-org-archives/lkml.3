Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaGQNyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:54:51 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:37205 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaGQNyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:54:50 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 2/4] drivers/message/i2o/i2o_block.c: drop negativity check of unsigned long arg
Date: Thu, 17 Jul 2014 16:54:35 +0300
Message-Id: <1405605275-13608-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-3.16-rc5/drivers/message/i2o/i2o_block.c:674]: (style) Checking if
unsigned variable 'arg' is less than zero.

Source code is

        if (arg < 0 || arg > CACHE_SMARTFETCH)
            break;
but

static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
               unsigned int cmd, unsigned long arg)

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80451
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/message/i2o/i2o_block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 6fc3866..2b684ec 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -671,7 +671,7 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case BLKI2OSRSTRAT:
 		ret = -EINVAL;
-		if (arg < 0 || arg > CACHE_SMARTFETCH)
+		if (arg > CACHE_SMARTFETCH)
 			break;
 		dev->rcache = arg;
 		ret = 0;
-- 
1.8.5.5

