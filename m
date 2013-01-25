Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3AYK6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:58:06 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:48859 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814Ab3AYK4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:38 -0500
From: Guo Chao <yan@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/7] block: remove redundant check to bd_openers
Date: Fri, 25 Jan 2013 18:56:17 +0800
Message-Id: <1359111382-12654-3-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012510-5816-0000-0000-000006687A1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bd_openers is stable under bd_mutex, no need to check it twice.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 82b7c9a..2f70584 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1119,7 +1119,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				}
 			}
 
-			if (!ret && !bdev->bd_openers) {
+			if (!ret) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
 				if (bdi == NULL)
-- 
1.7.9.5

