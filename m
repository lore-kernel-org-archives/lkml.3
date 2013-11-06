Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3KFHzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:55:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3KFHzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:55:15 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960199"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:53:06 +0800
Message-Id: <1383724386-15241-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:20,
	Serialize complete at 2013/11/06 15:53:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 3624368..3b6eea3 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4680,7 +4680,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 
 		image_id = ceph_extract_encoded_string(&p, p + ret,
 						NULL, GFP_NOIO);
-		ret = IS_ERR(image_id) ? PTR_ERR(image_id) : 0;
+		ret = PTR_ERR_OR_ZERO(image_id);
 		if (!ret)
 			rbd_dev->image_format = 2;
 	} else {
-- 
1.8.3.1

