Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaITO1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:40 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33965 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaITO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:27:38 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/13] staging: rtl8188eu: Rework function ODM_AntselStatistics_88E()
Date: Sat, 20 Sep 2014 19:55:56 +0530
Message-Id: <1411223160-17292-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase function name and local variables.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c     |    2 +-
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c     |   19 ++++++++++---------
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h |    4 ++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
index dbc1368..4e4e219 100644
--- a/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
+++ b/drivers/staging/rtl8188eu/hal/odm_HWConfig.c
@@ -315,7 +315,7 @@ static void odm_Process_RSSIForDM(struct odm_dm_struct *dm_odm,
 		if (pPktinfo->bPacketToSelf || pPktinfo->bPacketBeacon) {
 			antsel_tr_mux = (pDM_FatTable->antsel_rx_keep_2<<2) |
 					(pDM_FatTable->antsel_rx_keep_1<<1) | pDM_FatTable->antsel_rx_keep_0;
-			ODM_AntselStatistics_88E(dm_odm, antsel_tr_mux, pPktinfo->StationID, pPhyInfo->RxPWDBAll);
+			rtl88eu_dm_ant_sel_statistics(dm_odm, antsel_tr_mux, pPktinfo->StationID, pPhyInfo->RxPWDBAll);
 		}
 	}
 	/* Smart Antenna Debug Message------------------ */
diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 5a51405..95bcc0a 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -249,24 +249,25 @@ void rtl88eu_dm_set_tx_ant_by_tx_info(struct odm_dm_struct *dm_odm,
 	}
 }
 
-void ODM_AntselStatistics_88E(struct odm_dm_struct *dm_odm, u8 antsel_tr_mux, u32 MacId, u8 RxPWDBAll)
+void rtl88eu_dm_ant_sel_statistics(struct odm_dm_struct *dm_odm,
+				   u8 antsel_tr_mux, u32 mac_id, u8 rx_pwdb_all)
 {
 	struct fast_ant_train *dm_fat_tbl = &dm_odm->DM_FatTable;
 	if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) {
 		if (antsel_tr_mux == MAIN_ANT_CG_TRX) {
-			dm_fat_tbl->MainAnt_Sum[MacId] += RxPWDBAll;
-			dm_fat_tbl->MainAnt_Cnt[MacId]++;
+			dm_fat_tbl->MainAnt_Sum[mac_id] += rx_pwdb_all;
+			dm_fat_tbl->MainAnt_Cnt[mac_id]++;
 		} else {
-			dm_fat_tbl->AuxAnt_Sum[MacId] += RxPWDBAll;
-			dm_fat_tbl->AuxAnt_Cnt[MacId]++;
+			dm_fat_tbl->AuxAnt_Sum[mac_id] += rx_pwdb_all;
+			dm_fat_tbl->AuxAnt_Cnt[mac_id]++;
 		}
 	} else if (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV) {
 		if (antsel_tr_mux == MAIN_ANT_CGCS_RX) {
-			dm_fat_tbl->MainAnt_Sum[MacId] += RxPWDBAll;
-			dm_fat_tbl->MainAnt_Cnt[MacId]++;
+			dm_fat_tbl->MainAnt_Sum[mac_id] += rx_pwdb_all;
+			dm_fat_tbl->MainAnt_Cnt[mac_id]++;
 		} else {
-			dm_fat_tbl->AuxAnt_Sum[MacId] += RxPWDBAll;
-			dm_fat_tbl->AuxAnt_Cnt[MacId]++;
+			dm_fat_tbl->AuxAnt_Sum[mac_id] += rx_pwdb_all;
+			dm_fat_tbl->AuxAnt_Cnt[mac_id]++;
 		}
 	}
 }
diff --git a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
index 7a10101..684947f 100644
--- a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
@@ -38,8 +38,8 @@ void rtl88eu_dm_set_tx_ant_by_tx_info(struct odm_dm_struct *dm_odm, u8 *desc,
 
 void rtl88eu_dm_update_rx_idle_ant(struct odm_dm_struct *dm_odm, u8 ant);
 
-void ODM_AntselStatistics_88E(struct odm_dm_struct *pDM_Odm, u8	antsel_tr_mux,
-			      u32 MacId, u8 RxPWDBAll);
+void rtl88eu_dm_ant_sel_statistics(struct odm_dm_struct *dm_odm, u8 antsel_tr_mux,
+				   u32 mac_id, u8 rx_pwdb_all);
 
 void odm_FastAntTraining(struct odm_dm_struct *pDM_Odm);
 
-- 
1.7.10.4

