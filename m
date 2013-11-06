Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3KFHze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:55:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab3KFHzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:55:33 -0500
X-IronPort-AV: E=Sophos;i="4.93,644,1378828800"; 
   d="scan'208";a="8960205"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] dca: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Wed, 6 Nov 2013 15:53:24 +0800
Message-Id: <1383724404-15290-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 15:53:39,
	Serialize complete at 2013/11/06 15:53:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/dca/dca-sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
index 126cf29..b2f8be0 100644
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -40,9 +40,7 @@ int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
 
 	cd = device_create(dca_class, dca->cd, MKDEV(0, slot + 1), NULL,
 			   "requester%d", req_count++);
-	if (IS_ERR(cd))
-		return PTR_ERR(cd);
-	return 0;
+	return PTR_ERR_OR_ZERO(cd);
 }
 
 void dca_sysfs_remove_req(struct dca_provider *dca, int slot)
-- 
1.8.3.1

