Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3KFH6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:58:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3KFH56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:57:58 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960247"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk, a.zummo@towertech.it,
        airlied@linux.ie, dmitry.torokhov@gmail.com, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, devel@driverdev.osuosl.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:55:44 +0800
Message-Id: <1383724544-15662-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:56:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:56:03,
	Serialize complete at 2013/11/06 15:56:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 block/blk-timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 4e9cfd1..cdf5711 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -32,7 +32,7 @@ static int __init fail_io_timeout_debugfs(void)
 	struct dentry *dir = fault_create_debugfs_attr("fail_io_timeout",
 						NULL, &fail_io_timeout);
 
-	return IS_ERR(dir) ? PTR_ERR(dir) : 0;
+	return PTR_ERR_OR_ZERO(dir);
 }
 
 late_initcall(fail_io_timeout_debugfs);
-- 
1.8.3.1

