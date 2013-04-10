Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937014Ab3DJQGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:06:40 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51850 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934793Ab3DJQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:06:39 -0400
From: Laurent Barbe <laurent@ksperis.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Barbe <laurent@ksperis.com>
Subject: [PATCH] rbd: revalidate_disk upon rbd resize
Date: Wed, 10 Apr 2013 18:06:29 +0200
Message-Id: <1365609989-14493-1-git-send-email-laurent@ksperis.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rbd disk is open and rbd resize is done, new size is not visible by
filesystem.
Like is done in virtio-blk and dm driver, revalidate_disk() permits to
update the bd_inode size.

Signed-off-by: Laurent Barbe <laurent@ksperis.com>
---
 drivers/block/rbd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f556f8a..1963025 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2293,6 +2293,7 @@ static void rbd_update_mapping_size(struct rbd_device *rbd_dev)
 	dout("setting size to %llu sectors", (unsigned long long) size);
 	rbd_dev->mapping.size = (u64) size;
 	set_capacity(rbd_dev->disk, size);
+	revalidate_disk(rbd_dev->disk);
 }
 
 /*
-- 
1.7.10.4

