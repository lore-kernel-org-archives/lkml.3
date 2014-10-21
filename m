Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbaJURxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:53:54 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:47199 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933523AbaJURxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:53:52 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] natsemi/macsonic: Remove superfluous interrupt disable/restore
Date: Tue, 21 Oct 2014 19:53:57 +0200
Message-Id: <1413914037-23693-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit e4dc601bf99ccd1c ("m68k: Disable/restore interrupts in
hwreg_present()/hwreg_write()"), this is no longer needed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/natsemi/macsonic.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 9e4ddbba70363b8f..66c2d50d5b8d12df 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -326,13 +326,9 @@ static int mac_onboard_sonic_probe(struct net_device *dev)
 	    macintosh_config->ident == MAC_MODEL_P588 ||
 	    macintosh_config->ident == MAC_MODEL_P575 ||
 	    macintosh_config->ident == MAC_MODEL_C610) {
-		unsigned long flags;
 		int card_present;
 
-		local_irq_save(flags);
 		card_present = hwreg_present((void*)ONBOARD_SONIC_REGISTERS);
-		local_irq_restore(flags);
-
 		if (!card_present) {
 			printk("none.\n");
 			return -ENODEV;
-- 
1.9.1

