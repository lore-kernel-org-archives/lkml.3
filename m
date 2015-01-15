Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbbAOLwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:52:13 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33242 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbAOLwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:52:11 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, starvik@axis.com, jesper.nilsson@axis.com,
        linux-cris-kernel@axis.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] cris: Remove unnecessary KERN_INFO from sync_serial.c
Date: Thu, 15 Jan 2015 20:52:08 +0900
Message-Id: <1421322728-18968-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.3.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary KERN_INFO in sync_serial.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/cris/arch-v32/drivers/sync_serial.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index 08a313f..91e8773 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -1286,7 +1286,7 @@ static void start_dma_out(struct sync_port *port, const char *data, int count)
 
 		tr_cfg.tr_en = regk_sser_yes;
 		REG_WR(sser, port->regi_sser, rw_tr_cfg, tr_cfg);
-		DEBUGTRDMA(pr_info(KERN_INFO "dma s\n"););
+		DEBUGTRDMA(pr_info("dma s\n"););
 	} else {
 		DMA_CONTINUE_DATA(port->regi_dmaout);
 		DEBUGTRDMA(pr_info("dma c\n"););
@@ -1443,7 +1443,7 @@ static inline void handle_rx_packet(struct sync_port *port)
 	reg_dma_rw_ack_intr ack_intr = { .data = regk_dma_yes };
 	unsigned long flags;
 
-	DEBUGRXINT(pr_info(KERN_INFO "!"));
+	DEBUGRXINT(pr_info("!"));
 	spin_lock_irqsave(&port->lock, flags);
 
 	/* If we overrun the user experience is crap regardless if we
-- 
2.3.0.rc0

