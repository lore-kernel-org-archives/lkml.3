Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaF1Lw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:52:27 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:63137 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbaF1Lw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:52:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHALerrlNbsk2v/2dsb2JhbABZgw2regUBAQEBAQEFAW0BmQKBBxd1hDEvI1ZEN4hGAcUZF4VkiSEdhC0Fml2LP4g8ggCBRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 1/1] drivers/infiniband/ulp/ipoib/ipoib_fs.c: remove unnecessary null test before debugfs_remove
Date: Sat, 28 Jun 2014 13:51:04 +0200
Message-Id: <1403956264-2936-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: debugfs_remove(NULL) is safe this check is probably not required

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/infiniband/ulp/ipoib/ipoib_fs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_fs.c b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
index 5006185..6bd5740 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
@@ -281,10 +281,8 @@ void ipoib_delete_debug_files(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
-	if (priv->mcg_dentry)
-		debugfs_remove(priv->mcg_dentry);
-	if (priv->path_dentry)
-		debugfs_remove(priv->path_dentry);
+	debugfs_remove(priv->mcg_dentry);
+	debugfs_remove(priv->path_dentry);
 }
 
 int ipoib_register_debugfs(void)
-- 
1.8.4.5

