Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaHTNPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:15:20 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:38541 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaHTNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:15:17 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Ariel Elior <ariel.elior@qlogic.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] net: ethernet: broadcom: bnx2x: Remove redundant #ifdef
Date: Wed, 20 Aug 2014 15:14:49 +0200
Message-Id: <1408540489-1795-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing defines _ASM_GENERIC_INT_L64_H, it is a weird way to check for
64 bit longs, and u64 should be printed using %llx anyway.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 4e6c82e..4ccc806 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -483,11 +483,7 @@ static void bnx2x_tpa_start(struct bnx2x_fastpath *fp, u16 queue,
 
 #ifdef BNX2X_STOP_ON_ERROR
 	fp->tpa_queue_used |= (1 << queue);
-#ifdef _ASM_GENERIC_INT_L64_H
-	DP(NETIF_MSG_RX_STATUS, "fp->tpa_queue_used = 0x%lx\n",
-#else
 	DP(NETIF_MSG_RX_STATUS, "fp->tpa_queue_used = 0x%llx\n",
-#endif
 	   fp->tpa_queue_used);
 #endif
 }
-- 
1.9.2

