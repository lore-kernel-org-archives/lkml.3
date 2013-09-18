Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3IRMvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:51:09 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33519 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3IRMvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:51:07 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: tsi108: Prevent compiler warning
Date: Wed, 18 Sep 2013 14:49:55 +0200
Message-Id: <1379508595-30252-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dump_eth_one() function is only used if DEBUG is enabled, so protect
it by a corresponding #ifdef DEBUG block.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index c4dbf98..a452d93 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -168,6 +168,7 @@ static struct platform_driver tsi_eth_driver = {
 
 static void tsi108_timed_checker(unsigned long dev_ptr);
 
+#ifdef DEBUG
 static void dump_eth_one(struct net_device *dev)
 {
 	struct tsi108_prv_data *data = netdev_priv(dev);
@@ -192,6 +193,7 @@ static void dump_eth_one(struct net_device *dev)
 	       TSI_READ(TSI108_EC_RXESTAT),
 	       TSI_READ(TSI108_EC_RXERR), data->rxpending);
 }
+#endif
 
 /* Synchronization is needed between the thread and up/down events.
  * Note that the PHY is accessed through the same registers for both
-- 
1.8.4

