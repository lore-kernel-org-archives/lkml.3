Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaJURzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:55:20 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:32963 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaJURzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:55:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] nubus: Remove superfluous interrupt disable/restore
Date: Tue, 21 Oct 2014 19:55:20 +0200
Message-Id: <1413914120-23894-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit e4dc601bf99ccd1c ("m68k: Disable/restore interrupts in
hwreg_present()/hwreg_write()"), this is no longer needed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
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

