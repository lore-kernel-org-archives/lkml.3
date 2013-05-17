Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3EQPSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:18:37 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36594 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3EQPSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:18:36 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH 1/4] net: ethernet: sun: initialize variables directly
Date: Fri, 17 May 2013 12:07:45 -0300
Message-Id: <1368803268-27698-1-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the code a bit to initialize the variables directly when
defining them.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---

Please note that this patch is untested.

 drivers/net/ethernet/sun/sunbmac.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index 0549759..aabb40a 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -1017,10 +1017,7 @@ static void bigmac_set_multicast(struct net_device *dev)
 		tmp |= BIGMAC_RXCFG_PMISC;
 		sbus_writel(tmp, bregs + BMAC_RXCFG);
 	} else {
-		u16 hash_table[4];
-
-		for (i = 0; i < 4; i++)
-			hash_table[i] = 0;
+		u16 hash_table[4] = {0};
 
 		netdev_for_each_mc_addr(ha, dev) {
 			crc = ether_crc_le(6, ha->addr);
-- 
1.8.2.3

