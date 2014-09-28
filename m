Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaI1J0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:26:35 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:42382 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaI1J0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:26:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>, linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/5] cirrus/mac89x0: Remove superfluous interrupt disable/restore
Date: Sun, 28 Sep 2014 11:26:23 +0200
Message-Id: <1411896385-25384-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
References: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit XXX ("m68k: Disable/restore interrupts in
hwreg_present()/hwreg_write()"), this is no longer needed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Do not apply before commit XXX has been applied.
---
 drivers/net/ethernet/cirrus/mac89x0.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
index e285f384b0966dfe..07719676c305fc0b 100644
--- a/drivers/net/ethernet/cirrus/mac89x0.c
+++ b/drivers/net/ethernet/cirrus/mac89x0.c
@@ -216,14 +216,10 @@ struct net_device * __init mac89x0_probe(int unit)
 	ioaddr = (unsigned long)
 		nubus_slot_addr(slot) | (((slot&0xf) << 20) + DEFAULTIOBASE);
 	{
-		unsigned long flags;
 		int card_present;
 
-		local_irq_save(flags);
-		card_present = (hwreg_present((void*) ioaddr+4) &&
-				hwreg_present((void*) ioaddr + DATA_PORT));
-		local_irq_restore(flags);
-
+		card_present = (hwreg_present((void *)ioaddr + 4) &&
+				hwreg_present((void *)ioaddr + DATA_PORT));
 		if (!card_present)
 			goto out;
 	}
-- 
1.9.1

