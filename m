Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaHTWSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:18:45 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39481 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHTWST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:18:19 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 7/8] staging: et131x: Fix ET_INTR_TXDMA_ISR register name typo
Date: Wed, 20 Aug 2014 23:17:57 +0100
Message-Id: <1408573078-9320-8-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We actually mean to clear the ET_INTR_TXDMA_ISR reg after handling
a completed transfer, not the ET_INTR_TXDMA_ERR reg, which should
get handled immediately after.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index df83ea3..bf9ac15 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -3891,7 +3891,7 @@ static void et131x_isr_handler(struct work_struct *work)
 	if (status & ET_INTR_RXDMA_XFR_DONE)
 		et131x_handle_recv_interrupt(adapter);
 
-	status &= ~(ET_INTR_TXDMA_ERR | ET_INTR_RXDMA_XFR_DONE);
+	status &= ~(ET_INTR_TXDMA_ISR | ET_INTR_RXDMA_XFR_DONE);
 
 	if (!status)
 		goto out;
-- 
2.1.0

