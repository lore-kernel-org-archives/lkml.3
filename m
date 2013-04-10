Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937079Ab3DJV7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:59:21 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:51984 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676Ab3DJV7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:59:19 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] block: ioctl: Use PTR_RET function
Date: Thu, 11 Apr 2013 00:58:18 +0300
Message-Id: <1365631098-6351-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 block/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..4698c1f7 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -64,7 +64,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			part = add_partition(disk, partno, start, length,
 					     ADDPART_FLAG_NONE, NULL);
 			mutex_unlock(&bdev->bd_mutex);
-			return IS_ERR(part) ? PTR_ERR(part) : 0;
+			return PTR_RET(part);
 		case BLKPG_DEL_PARTITION:
 			part = disk_get_part(disk, partno);
 			if (!part)
-- 
1.7.9.5

