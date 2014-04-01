Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaDALQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaDALQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 008/144] mwifiex: clean pcie ring only when device is present
Date: Tue,  1 Apr 2014 12:13:32 +0100
Message-Id: <1396350948-29910-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit 4f7ba432202c8330cc03ab959c6228d0de5dc4a3 upstream.

Write io memory to clean PCIe buffer only when PCIe device is
present else this results into crash because of invalid memory
access.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index fbf0915..03877ec 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -559,7 +559,8 @@ mwifiex_clean_txrx(struct mwifiex_private *priv)
 	mwifiex_wmm_delete_all_ralist(priv);
 	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
 
-	if (priv->adapter->if_ops.clean_pcie_ring)
+	if (priv->adapter->if_ops.clean_pcie_ring &&
+	    !priv->adapter->surprise_removed)
 		priv->adapter->if_ops.clean_pcie_ring(priv->adapter);
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
-- 
1.9.1

