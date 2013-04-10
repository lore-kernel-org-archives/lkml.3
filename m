Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937061Ab3DJVyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:54:24 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45595 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3DJVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:54:22 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] block: blk-timeout: Use PTR_RET function
Date: Thu, 11 Apr 2013 00:53:41 +0300
Message-Id: <1365630821-6233-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 block/blk-timeout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 6e4744c..2a6aba0 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -31,7 +31,7 @@ static int __init fail_io_timeout_debugfs(void)
 	struct dentry *dir = fault_create_debugfs_attr("fail_io_timeout",
 						NULL, &fail_io_timeout);
 
-	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
+	return PTR_RET(dir);
 }
 
 late_initcall(fail_io_timeout_debugfs);
-- 
1.7.9.5

