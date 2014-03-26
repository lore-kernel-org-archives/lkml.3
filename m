Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaCZDye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:54:34 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41281 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaCZDyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:54:32 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: trivial@kernel.org, ian.campbell@citrix.com, wei.liu2@citrix.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] ixen-netback: fix trivial printf format build warning
Date: Wed, 26 Mar 2014 12:56:50 +0900
Message-Id: <1395806210-23528-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following trivial build warning:

drivers/net/xen-netback/netback.c: In function ‘xenvif_tx_dealloc_action’:
drivers/net/xen-netback/netback.c:1585:8: warning:
format ‘%x’ expects argument of type
 ‘unsigned int’, but argument 3 has type ‘long int’ [-Wformat=]
        gop - vif->tx_unmap_ops, ret);
        ^

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 5a8c4a4..90001b3 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1574,7 +1574,7 @@ static inline void xenvif_tx_dealloc_action(struct xenvif *vif)
 					vif->pages_to_unmap,
 					gop - vif->tx_unmap_ops);
 		if (ret) {
-			netdev_err(vif->dev, "Unmap fail: nr_ops %x ret %d\n",
+			netdev_err(vif->dev, "Unmap fail: nr_ops %lx ret %d\n",
 				   gop - vif->tx_unmap_ops, ret);
 			for (i = 0; i < gop - vif->tx_unmap_ops; ++i) {
 				if (gop[i].status != GNTST_okay)
-- 
1.8.3.2

