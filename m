Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaIRPrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:47:00 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:42293 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbaIRPq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:46:59 -0400
From: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        peter.p.waskiewicz.jr@intel.com, antoine@schweitzer-chaput.fr,
        Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Subject: [PATCH v2] staging: rtl8192u: delete unused function CAM_read_entry
Date: Thu, 18 Sep 2014 17:46:23 +0200
Message-Id: <1411055183-3535-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the sparse warning: symbol 'CAM_read_entry' was not declared. Should it be static?

The function CAM_read_entry is not used and therefore deleted.

Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
---
changes in v2:
add Signed-off-by line

 drivers/staging/rtl8192u/r8192U_core.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index a4e1d6b..3d8ad5f 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3190,34 +3190,6 @@ RESET_START:
 	}
 }
 
-void CAM_read_entry(struct net_device *dev, u32 iIndex)
-{
-	u32 target_command = 0;
-	u32 target_content = 0;
-	u8 entry_i = 0;
-	u32 ulStatus;
-	s32 i = 100;
-	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
-		// polling bit, and No Write enable, and address
-		target_command = entry_i+CAM_CONTENT_COUNT*iIndex;
-		target_command = target_command | BIT31;
-
-		//Check polling bit is clear
-		while ((i--) >= 0) {
-			read_nic_dword(dev, RWCAM, &ulStatus);
-			if (ulStatus & BIT31)
-				continue;
-			else
-				break;
-		}
-		write_nic_dword(dev, RWCAM, target_command);
-		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A0: %x \n", target_command);
-		read_nic_dword(dev, RCAMO, &target_content);
-		RT_TRACE(COMP_SEC, "CAM_read_entry(): WRITE A8: %x \n", target_content);
-	}
-	printk("\n");
-}
-
 static void rtl819x_update_rxcounts(struct r8192_priv *priv, u32 *TotalRxBcnNum,
 			     u32 *TotalRxDataNum)
 {
-- 
2.1.0

