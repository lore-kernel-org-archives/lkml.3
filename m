Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaI1J1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:27:00 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:46088 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaI1J0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:26:34 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>, linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/5] nubus: Remove superfluous interrupt disable/restore
Date: Sun, 28 Sep 2014 11:26:25 +0200
Message-Id: <1411896385-25384-5-git-send-email-geert@linux-m68k.org>
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
 drivers/nubus/nubus.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index 5066a7ef7b6c38a2..3319cf19deebe0f2 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -920,14 +920,10 @@ void __init nubus_probe_slot(int slot)
 	rp = nubus_rom_addr(slot);	
 	for(i = 4; i; i--)
 	{
-		unsigned long flags;
 		int card_present;
 
 		rp--;
-		local_irq_save(flags);
 		card_present = hwreg_present(rp);
-		local_irq_restore(flags);
-	       
 		if (!card_present)
 			continue;
 
-- 
1.9.1

