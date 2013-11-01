Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3KAKLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:11:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43060 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3KAKLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:11:45 -0400
X-IronPort-AV: E=Sophos;i="4.93,616,1378828800"; 
   d="scan'208";a="8921330"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] drivers: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 1 Nov 2013 18:09:43 +0800
Message-Id: <1383300583-6953-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 18:09:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/01 18:09:58,
	Serialize complete at 2013/11/01 18:09:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/misc/carma/carma-fpga.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 08b18f3..9a32e98 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -956,10 +956,7 @@ static int data_debugfs_init(struct fpga_device *priv)
 {
 	priv->dbg_entry = debugfs_create_file(drv_name, S_IRUGO, NULL, priv,
 					      &data_debug_fops);
-	if (IS_ERR(priv->dbg_entry))
-		return PTR_ERR(priv->dbg_entry);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(priv->dbg_entry);
 }
 
 static void data_debugfs_exit(struct fpga_device *priv)
-- 
1.8.3.1

