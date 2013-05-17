Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3EQPSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:18:45 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36599 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3EQPSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:18:43 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH 2/4] net: ethernet: apple: initialize variables directly
Date: Fri, 17 May 2013 12:07:46 -0300
Message-Id: <1368803268-27698-2-git-send-email-emilio@elopez.com.ar>
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

 drivers/net/ethernet/apple/bmac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index f36bbd6..253030c 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1030,14 +1030,12 @@ static void bmac_set_multicast(struct net_device *dev)
 		rx_cfg |= RxPromiscEnable;
 		bmwrite(dev, RXCFG, rx_cfg);
 	} else {
-		u16 hash_table[4];
+		u16 hash_table[4] = {0};
 
 		rx_cfg = bmread(dev, RXCFG);
 		rx_cfg &= ~RxPromiscEnable;
 		bmwrite(dev, RXCFG, rx_cfg);
 
-		for(i = 0; i < 4; i++) hash_table[i] = 0;
-
 		netdev_for_each_mc_addr(ha, dev) {
 			crc = ether_crc_le(6, ha->addr);
 			crc >>= 26;
-- 
1.8.2.3

