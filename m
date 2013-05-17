Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab3EQPTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:19:08 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36611 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3EQPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:19:04 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH 4/4] net: ethernet: korina: initialize variables directly
Date: Fri, 17 May 2013 12:07:48 -0300
Message-Id: <1368803268-27698-4-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1368803268-27698-1-git-send-email-emilio@elopez.com.ar>
References: <1368803268-27698-1-git-send-email-emilio@elopez.com.ar>
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

 drivers/net/ethernet/korina.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 5409fe8..3756d95 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -495,12 +495,9 @@ static void korina_multicast_list(struct net_device *dev)
 
 	/* Build the hash table */
 	if (netdev_mc_count(dev) > 4) {
-		u16 hash_table[4];
+		u16 hash_table[4] = {0};
 		u32 crc;
 
-		for (i = 0; i < 4; i++)
-			hash_table[i] = 0;
-
 		netdev_for_each_mc_addr(ha, dev) {
 			crc = ether_crc_le(6, ha->addr);
 			crc >>= 26;
-- 
1.8.2.3

