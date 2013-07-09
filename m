Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3GIIge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:36:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49139 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3GIIgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:36:24 -0400
X-AuditID: 9c930197-b7bfbae000000e88-0a-51dbcb86e356
From: Jongsung Kim <neidhard.kim@lge.com>
To: nicolas.ferre@atmel.com, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jongsung Kim <neidhard.kim@lge.com>
Subject: [PATCH] net/cadence/macb: fix bug/typo in extracting gem_irq_read_clear bit
Date: Tue,  9 Jul 2013 17:36:00 +0900
Message-Id: <1373358960-10900-1-git-send-email-neidhard.kim@lge.com>
X-Mailer: git-send-email 1.7.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
---
 drivers/net/ethernet/cadence/macb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index c89aa41..b4e0dc8 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1070,7 +1070,7 @@ static void macb_configure_dma(struct macb *bp)
 static void macb_configure_caps(struct macb *bp)
 {
 	if (macb_is_gem(bp)) {
-		if (GEM_BF(IRQCOR, gem_readl(bp, DCFG1)) == 0)
+		if (GEM_BFEXT(IRQCOR, gem_readl(bp, DCFG1)) == 0)
 			bp->caps |= MACB_CAPS_ISR_CLEAR_ON_WRITE;
 	}
 }
-- 
1.7.1

