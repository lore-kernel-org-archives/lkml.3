Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3EIUjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:39:46 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44865 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3EIUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:39:43 -0400
From: Emil Goode <emilgoode@gmail.com>
To: koverstreet@google.com, neilb@suse.de
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] bcache: Fix incompatible pointer type warning
Date: Thu,  9 May 2013 22:39:26 +0200
Message-Id: <1368131966-17512-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pointer release in struct block_device_operations
should point to functions declared as void.

Sparse warnings:

drivers/md/bcache/super.c:656:27: warning:
	incorrect type in initializer (different base types)
	drivers/md/bcache/super.c:656:27:
	expected void ( *release )( ... )
	drivers/md/bcache/super.c:656:27:
	got int ( static [toplevel] *<noident> )( ... )

drivers/md/bcache/super.c:656:2: warning:
	initialization from incompatible pointer type [enabled by default]

drivers/md/bcache/super.c:656:2: warning:
	(near initialization for ‘bcache_ops.release’) [enabled by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/md/bcache/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 76c7f6c..938bbff 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -637,11 +637,10 @@ static int open_dev(struct block_device *b, fmode_t mode)
 	return 0;
 }
 
-static int release_dev(struct gendisk *b, fmode_t mode)
+static void release_dev(struct gendisk *b, fmode_t mode)
 {
 	struct bcache_device *d = b->private_data;
 	closure_put(&d->cl);
-	return 0;
 }
 
 static int ioctl_dev(struct block_device *b, fmode_t mode,
-- 
1.7.10.4

