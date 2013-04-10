Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937014Ab3DJVvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:51:38 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:60442 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3DJVvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:51:37 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] block: blk-core: Use PTR_RET function
Date: Thu, 11 Apr 2013 00:50:56 +0300
Message-Id: <1365630656-6162-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 074b758..3a85a55 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1622,7 +1622,7 @@ static int __init fail_make_request_debugfs(void)
 	struct dentry *dir = fault_create_debugfs_attr("fail_make_request",
 						NULL, &fail_make_request);
 
-	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
+	return PTR_RET(dir);
 }
 
 late_initcall(fail_make_request_debugfs);
-- 
1.7.9.5

