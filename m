Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbbALIkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:40:32 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:37559 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbbALIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:40:27 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org
Subject: [PATCH 1/5] net: atarilance: Remove obsolete IRQ_TYPE_PRIO
Date: Mon, 12 Jan 2015 09:40:17 +0100
Message-Id: <1421052021-12560-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
References: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ_TYPE_PRIO is no longer used by the Atari platform interrupt code
since commit 734085651c9b80aa ("[PATCH] m68k: convert atari irq code")
in v2.6.18-rc1, so drop it.

Note that its value has been reused for a different purpose
(IRQ_TYPE_EDGE_FALLING) since commit 6a6de9ef5850d063 ("[PATCH] genirq:
core") in v2.6.18-rc1.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/amd/atarilance.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index e07ce5ff2d48bf93..b10964e8cb5469ce 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -553,8 +553,8 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 	if (lp->cardtype == PAM_CARD ||
 		memaddr == (unsigned short *)0xffe00000) {
 		/* PAMs card and Riebl on ST use level 5 autovector */
-		if (request_irq(IRQ_AUTO_5, lance_interrupt, IRQ_TYPE_PRIO,
-		            "PAM,Riebl-ST Ethernet", dev)) {
+		if (request_irq(IRQ_AUTO_5, lance_interrupt, 0,
+				"PAM,Riebl-ST Ethernet", dev)) {
 			printk( "Lance: request for irq %d failed\n", IRQ_AUTO_5 );
 			return 0;
 		}
@@ -567,8 +567,8 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 			printk( "Lance: request for VME interrupt failed\n" );
 			return 0;
 		}
-		if (request_irq(irq, lance_interrupt, IRQ_TYPE_PRIO,
-		            "Riebl-VME Ethernet", dev)) {
+		if (request_irq(irq, lance_interrupt, 0, "Riebl-VME Ethernet",
+				dev)) {
 			printk( "Lance: request for irq %u failed\n", irq );
 			return 0;
 		}
-- 
1.9.1

