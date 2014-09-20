Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaITO1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51518 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaITO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:27:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/13] staging: rtl8188eu: Rework function odm_UpdateTxAnt_88E()
Date: Sat, 20 Sep 2014 19:55:54 +0530
Message-Id: <1411223160-17292-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase function name and local variables.
Remove unnecessary debugging messages.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 8b886c6..f3a4e28 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -222,25 +222,18 @@ void rtl88eu_dm_update_rx_idle_ant(struct odm_dm_struct *dm_odm, u8 ant)
 	dm_fat_tbl->RxIdleAnt = ant;
 }
 
-static void odm_UpdateTxAnt_88E(struct odm_dm_struct *dm_odm, u8 Ant, u32 MacId)
+static void update_tx_ant_88eu(struct odm_dm_struct *dm_odm, u8 ant, u32 mac_id)
 {
 	struct fast_ant_train *dm_fat_tbl = &dm_odm->DM_FatTable;
-	u8	TargetAnt;
+	u8 target_ant;
 
-	if (Ant == MAIN_ANT)
-		TargetAnt = MAIN_ANT_CG_TRX;
+	if (ant == MAIN_ANT)
+		target_ant = MAIN_ANT_CG_TRX;
 	else
-		TargetAnt = AUX_ANT_CG_TRX;
-	dm_fat_tbl->antsel_a[MacId] = TargetAnt&BIT0;
-	dm_fat_tbl->antsel_b[MacId] = (TargetAnt&BIT1)>>1;
-	dm_fat_tbl->antsel_c[MacId] = (TargetAnt&BIT2)>>2;
-
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
-		     ("Tx from TxInfo, TargetAnt=%s\n",
-		     (Ant == MAIN_ANT) ? "MAIN_ANT" : "AUX_ANT"));
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
-		     ("antsel_tr_mux=3'b%d%d%d\n",
-		     dm_fat_tbl->antsel_c[MacId], dm_fat_tbl->antsel_b[MacId], dm_fat_tbl->antsel_a[MacId]));
+		target_ant = AUX_ANT_CG_TRX;
+	dm_fat_tbl->antsel_a[mac_id] = target_ant&BIT0;
+	dm_fat_tbl->antsel_b[mac_id] = (target_ant&BIT1)>>1;
+	dm_fat_tbl->antsel_c[mac_id] = (target_ant&BIT2)>>2;
 }
 
 void ODM_SetTxAntByTxInfo_88E(struct odm_dm_struct *dm_odm, u8 *pDesc, u8 macId)
@@ -322,7 +315,7 @@ static void odm_HWAntDiv(struct odm_dm_struct *dm_odm)
 			}
 			/* 2 Select TRX Antenna */
 			if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
-				odm_UpdateTxAnt_88E(dm_odm, TargetAnt, i);
+				update_tx_ant_88eu(dm_odm, TargetAnt, i);
 		}
 		dm_fat_tbl->MainAnt_Sum[i] = 0;
 		dm_fat_tbl->AuxAnt_Sum[i] = 0;
-- 
1.7.10.4

