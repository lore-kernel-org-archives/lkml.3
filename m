Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaIKWOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:14:31 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:53863 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaIKWOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:14:30 -0400
From: Mark Einon <mark.einon@gmail.com>
To: zambrano@broadcom.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] drivers: net: b44: Fix typo in returning multicast stats
Date: Thu, 11 Sep 2014 23:14:22 +0100
Message-Id: <1410473662-15342-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nstat->multicast refers to received packets, not transmitted as
is returned here. Change it so that received packet stats are
given.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/net/ethernet/broadcom/b44.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 4a7028d..d588136 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1697,7 +1697,7 @@ static struct rtnl_link_stats64 *b44_get_stats64(struct net_device *dev,
 				     hwstat->tx_underruns +
 				     hwstat->tx_excessive_cols +
 				     hwstat->tx_late_cols);
-		nstat->multicast  = hwstat->tx_multicast_pkts;
+		nstat->multicast  = hwstat->rx_multicast_pkts;
 		nstat->collisions = hwstat->tx_total_cols;
 
 		nstat->rx_length_errors = (hwstat->rx_oversize_pkts +
-- 
2.1.0

