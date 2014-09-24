Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaIXNm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:42:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56243 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaIXNmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:42:01 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/5] ARCNET: return IRQ_NONE if the interface isn't running
Date: Wed, 24 Sep 2014 15:41:49 +0200
Message-Id: <1411566113-15583-2-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411566113-15583-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1411566113-15583-1-git-send-email-m.grzeschik@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt handler needs to return IRQ_NONE in case
two devices are used with the shared interrupt handler.
Otherwise it could steal interrupts from the other
interface.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/net/arcnet/arcnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index 3b790de..09de683 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -777,7 +777,7 @@ irqreturn_t arcnet_interrupt(int irq, void *dev_id)
 			ACOMMAND(CFLAGScmd | RESETclear);
 		AINTMASK(0);
 		spin_unlock(&lp->lock);
-		return IRQ_HANDLED;
+		return retval;
 	}
 
 	BUGMSG(D_DURING, "in arcnet_inthandler (status=%Xh, intmask=%Xh)\n",
-- 
2.1.0

