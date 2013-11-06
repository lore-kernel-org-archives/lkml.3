Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3KFH7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:59:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab3KFH7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:59:08 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960260"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it,
        airlied@linux.ie, dmitry.torokhov@gmail.com, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, devel@driverdev.osuosl.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:57:03 +0800
Message-Id: <1383724623-15801-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:57:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:57:13,
	Serialize complete at 2013/11/06 15:57:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 block/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..7d5c3b2 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -64,7 +64,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			part = add_partition(disk, partno, start, length,
 					     ADDPART_FLAG_NONE, NULL);
 			mutex_unlock(&bdev->bd_mutex);
-			return IS_ERR(part) ? PTR_ERR(part) : 0;
+			return PTR_ERR_OR_ZERO(part);
 		case BLKPG_DEL_PARTITION:
 			part = disk_get_part(disk, partno);
 			if (!part)
-- 
1.8.3.1

