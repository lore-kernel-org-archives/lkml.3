Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab3FAJpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:45:31 -0400
Received: from www17.your-server.de ([213.133.104.17]:59356 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3FAJpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:45:25 -0400
Message-ID: <1370079920.29224.17.camel@localhost.localdomain>
Subject: [PATCH] block: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:45:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/block/blk-core.c b/block/blk-core.c
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1626,7 +1626,7 @@ static int __init fail_make_request_debu
 	struct dentry *dir = fault_create_debugfs_attr("fail_make_request",
 						NULL, &fail_make_request);
 
-	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
+	return PTR_RET(dir);
 }
 
 late_initcall(fail_make_request_debugfs);
diff -u -p a/block/blk-timeout.c b/block/blk-timeout.c
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -31,7 +31,7 @@ static int __init fail_io_timeout_debugf
 	struct dentry *dir = fault_create_debugfs_attr("fail_io_timeout",
 						NULL, &fail_io_timeout);
 
-	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
+	return PTR_RET(dir);
 }
 
 late_initcall(fail_io_timeout_debugfs);
diff -u -p a/block/ioctl.c b/block/ioctl.c
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -64,7 +64,7 @@ static int blkpg_ioctl(struct block_devi
 			part = add_partition(disk, partno, start, length,
 					     ADDPART_FLAG_NONE, NULL);
 			mutex_unlock(&bdev->bd_mutex);
-			return IS_ERR(part) ? PTR_ERR(part) : 0;
+			return PTR_RET(part);
 		case BLKPG_DEL_PARTITION:
 			part = disk_get_part(disk, partno);
 			if (!part)


