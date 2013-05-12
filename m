Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3ELQbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 12:31:15 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:59397 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab3ELQbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 12:31:14 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH] bcache: fix compilation warning
Date: Sun, 12 May 2013 18:30:51 +0200
Message-Id: <1368376251-14622-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release function of a block device does not return a value; make
release_dev void. This fixes the following warning:

  drivers/md/bcache/super.c:653:2: warning: initialization from incompatible pointer type [enabled by default]
  drivers/md/bcache/super.c:653:2: warning: (near initialization for ‘bcache_ops.release’) [enabled by default]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
---
 drivers/md/bcache/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c8046bc..b09beb2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -634,11 +634,10 @@ static int open_dev(struct block_device *b, fmode_t mode)
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

