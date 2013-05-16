Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3EPQYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:24:52 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42520 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3EPQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:24:50 -0400
From: "govindarajulu.v" <govindarajulu90@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "govindarajulu.v" <govindarajulu90@gmail.com>
Subject: [PATCH] net: 3com: 3c509: remove unnecessary code
Date: Thu, 16 May 2013 21:54:41 +0530
Message-Id: <1368721481-3602-1-git-send-email-govindarajulu90@gmail.com>
X-Mailer: git-send-email 1.8.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "govindarajulu.v" <govindarajulu90@gmail.com>

This patch removes unnecessary #if 0 code from 3c509.c

Signed-off-by: govindarajulu.v <govindarajulu90@gmail.com>
---
 drivers/net/ethernet/3com/3c509.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
index adb4bf5..ede8daa 100644
--- a/drivers/net/ethernet/3com/3c509.c
+++ b/drivers/net/ethernet/3com/3c509.c
@@ -723,25 +723,6 @@ el3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		pr_debug("%s: el3_start_xmit(length = %u) called, status %4.4x.\n",
 			   dev->name, skb->len, inw(ioaddr + EL3_STATUS));
 	}
-#if 0
-#ifndef final_version
-	{	/* Error-checking code, delete someday. */
-		ushort status = inw(ioaddr + EL3_STATUS);
-		if (status & 0x0001 && 		/* IRQ line active, missed one. */
-		    inw(ioaddr + EL3_STATUS) & 1) { 			/* Make sure. */
-			pr_debug("%s: Missed interrupt, status then %04x now %04x"
-				   "  Tx %2.2x Rx %4.4x.\n", dev->name, status,
-				   inw(ioaddr + EL3_STATUS), inb(ioaddr + TX_STATUS),
-				   inw(ioaddr + RX_STATUS));
-			/* Fake interrupt trigger by masking, acknowledge interrupts. */
-			outw(SetStatusEnb | 0x00, ioaddr + EL3_CMD);
-			outw(AckIntr | IntLatch | TxAvailable | RxEarly | IntReq,
-				 ioaddr + EL3_CMD);
-			outw(SetStatusEnb | 0xff, ioaddr + EL3_CMD);
-		}
-	}
-#endif
-#endif
 	/*
 	 *	We lock the driver against other processors. Note
 	 *	we don't need to lock versus the IRQ as we suspended
-- 
1.8.2.3

