Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3BPVUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 16:20:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34261 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754503Ab3BPVUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 16:20:08 -0500
From: Joe Perches <joe@perches.com>
To: Michael Chan <mchan@broadcom.com>
Cc: Matt Carlson <mcarlson@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tg3: Remove define and single use of GET_CHIP_REV_ID
Date: Sat, 16 Feb 2013 13:20:03 -0800
Message-Id: <dea1c655b2c1380821aae6cd8438ad742ddf6e12.1361049158.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's the same value as tp->pci_chip_rev_id so use that
instead.  This makes all CHIPREV_ID_<foo> tests the same.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 10 ++++------
 drivers/net/ethernet/broadcom/tg3.h |  4 +---
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 1b59876..f511e8b 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -15761,12 +15761,10 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
 			      &pci_state_reg);
 	if ((pci_state_reg & PCISTATE_CONV_PCI_MODE) == 0 &&
 	    !tg3_flag(tp, PCIX_TARGET_HWBUG)) {
-		u32 chiprevid = GET_CHIP_REV_ID(tp->misc_host_ctrl);
-
-		if (chiprevid == CHIPREV_ID_5701_A0 ||
-		    chiprevid == CHIPREV_ID_5701_B0 ||
-		    chiprevid == CHIPREV_ID_5701_B2 ||
-		    chiprevid == CHIPREV_ID_5701_B5) {
+		if (tp->pci_chip_rev_id == CHIPREV_ID_5701_A0 ||
+		    tp->pci_chip_rev_id == CHIPREV_ID_5701_B0 ||
+		    tp->pci_chip_rev_id == CHIPREV_ID_5701_B2 ||
+		    tp->pci_chip_rev_id == CHIPREV_ID_5701_B5) {
 			void __iomem *sram_base;
 
 			/* Write some dummy words into the SRAM status block
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index b676728..3e27f2e 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -120,9 +120,7 @@
 #define  MISC_HOST_CTRL_TAGGED_STATUS	 0x00000200
 #define  MISC_HOST_CTRL_CHIPREV		 0xffff0000
 #define  MISC_HOST_CTRL_CHIPREV_SHIFT	 16
-#define  GET_CHIP_REV_ID(MISC_HOST_CTRL) \
-	 (((MISC_HOST_CTRL) & MISC_HOST_CTRL_CHIPREV) >> \
-	  MISC_HOST_CTRL_CHIPREV_SHIFT)
+
 #define  CHIPREV_ID_5700_A0		 0x7000
 #define  CHIPREV_ID_5700_A1		 0x7001
 #define  CHIPREV_ID_5700_B0		 0x7100
-- 
1.8.1.2.459.gbcd45b4.dirty

