Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3I3UMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:12:33 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46502 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab3I3UMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:12:30 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/3] net: calxedaxgmac: fix clearing of old filter addresses
Date: Mon, 30 Sep 2013 15:12:15 -0500
Message-Id: <1380571937-23439-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380571937-23439-1-git-send-email-robherring2@gmail.com>
References: <1380571937-23439-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

In commit 2ee68f621af280 (net: calxedaxgmac: fix various errors in
xgmac_set_rx_mode), a fix to clean-up old address entries was added.
However, the loop to zero out the entries failed to increment the register
address resulting in only 1 entry getting cleared. Fix this to correctly
use the loop index. Also, the end of the loop condition was off by 1 and
should have been <= rather than <.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 78d6d6b..94358d2 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1342,8 +1342,8 @@ static void xgmac_set_rx_mode(struct net_device *dev)
 	}
 
 out:
-	for (i = reg; i < XGMAC_MAX_FILTER_ADDR; i++)
-		xgmac_set_mac_addr(ioaddr, NULL, reg);
+	for (i = reg; i <= XGMAC_MAX_FILTER_ADDR; i++)
+		xgmac_set_mac_addr(ioaddr, NULL, i);
 	for (i = 0; i < XGMAC_NUM_HASH; i++)
 		writel(hash_filter[i], ioaddr + XGMAC_HASH(i));
 
-- 
1.8.1.2

