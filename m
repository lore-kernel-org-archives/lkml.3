Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3EQUqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:46:15 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36627 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3EQUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:46:11 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH v2 3/4] net: ethernet: davicom: dm9000: initialize variables directly
Date: Fri, 17 May 2013 17:42:55 -0300
Message-Id: <1368823376-13104-3-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1368823376-13104-1-git-send-email-emilio@elopez.com.ar>
References: <1368803268-27698-1-git-send-email-emilio@elopez.com.ar>
 <1368823376-13104-1-git-send-email-emilio@elopez.com.ar>
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

Changes from v1:
  - {0} -> { 0 } as suggested by David Miller

 drivers/net/ethernet/davicom/dm9000.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 9105465..e4ed05e 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -827,7 +827,7 @@ dm9000_hash_table_unlocked(struct net_device *dev)
 	struct netdev_hw_addr *ha;
 	int i, oft;
 	u32 hash_val;
-	u16 hash_table[4];
+	u16 hash_table[4] = { 0, 0, 0, 0x8000 }; /* broadcast address */
 	u8 rcr = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
 
 	dm9000_dbg(db, 1, "entering %s\n", __func__);
@@ -835,13 +835,6 @@ dm9000_hash_table_unlocked(struct net_device *dev)
 	for (i = 0, oft = DM9000_PAR; i < 6; i++, oft++)
 		iow(db, oft, dev->dev_addr[i]);
 
-	/* Clear Hash Table */
-	for (i = 0; i < 4; i++)
-		hash_table[i] = 0x0;
-
-	/* broadcast address */
-	hash_table[3] = 0x8000;
-
 	if (dev->flags & IFF_PROMISC)
 		rcr |= RCR_PRMSC;
 
-- 
1.8.2.3

