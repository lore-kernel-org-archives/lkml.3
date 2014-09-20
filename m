Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaITO1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:08 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41990 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaITO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:27:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/13] staging: rtl8188eu: Rework function ODM_UpdateRxIdleAnt_88E()
Date: Sat, 20 Sep 2014 19:55:53 +0530
Message-Id: <1411223160-17292-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase function name and local variables.
Remove unnecessary debugging messages and comments.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c     |   51 ++++++++++++----------
 drivers/staging/rtl8188eu/hal/usb_halinit.c      |    2 +-
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h |    2 +-
 3 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 74105b5..8b886c6 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -48,7 +48,7 @@ static void dm_rx_hw_antena_div_init(struct odm_dm_struct *dm_odm)
 	/* CCK Settings */
 	phy_set_bb_reg(adapter, ODM_REG_BB_PWR_SAV4_11N, BIT7, 1);
 	phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1);
-	ODM_UpdateRxIdleAnt_88E(dm_odm, MAIN_ANT);
+	rtl88eu_dm_update_rx_idle_ant(dm_odm, MAIN_ANT);
 	phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, 0xFFFF, 0x0201);
 }
 
@@ -82,7 +82,7 @@ static void dm_trx_hw_antenna_div_init(struct odm_dm_struct *dm_odm)
 	phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1);
 	/* Tx Settings */
 	phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0);
-	ODM_UpdateRxIdleAnt_88E(dm_odm, MAIN_ANT);
+	rtl88eu_dm_update_rx_idle_ant(dm_odm, MAIN_ANT);
 
 	/* antenna mapping table */
 	if (!dm_odm->bIsMPChip) { /* testchip */
@@ -184,35 +184,42 @@ void rtl88eu_dm_antenna_div_init(struct odm_dm_struct *dm_odm)
 		dm_fast_training_init(dm_odm);
 }
 
-void ODM_UpdateRxIdleAnt_88E(struct odm_dm_struct *dm_odm, u8 Ant)
+void rtl88eu_dm_update_rx_idle_ant(struct odm_dm_struct *dm_odm, u8 ant)
 {
 	struct fast_ant_train *dm_fat_tbl = &dm_odm->DM_FatTable;
 	struct adapter *adapter = dm_odm->Adapter;
-	u32	DefaultAnt, OptionalAnt;
-
-	if (dm_fat_tbl->RxIdleAnt != Ant) {
-		ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("Need to Update Rx Idle Ant\n"));
-		if (Ant == MAIN_ANT) {
-			DefaultAnt = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ? MAIN_ANT_CG_TRX : MAIN_ANT_CGCS_RX;
-			OptionalAnt = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ? AUX_ANT_CG_TRX : AUX_ANT_CGCS_RX;
+	u32 default_ant, optional_ant;
+
+	if (dm_fat_tbl->RxIdleAnt != ant) {
+		if (ant == MAIN_ANT) {
+			default_ant = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ?
+				       MAIN_ANT_CG_TRX : MAIN_ANT_CGCS_RX;
+			optional_ant = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ?
+					AUX_ANT_CG_TRX : AUX_ANT_CGCS_RX;
 		} else {
-			DefaultAnt = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ? AUX_ANT_CG_TRX : AUX_ANT_CGCS_RX;
-			OptionalAnt = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ? MAIN_ANT_CG_TRX : MAIN_ANT_CGCS_RX;
+			default_ant = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ?
+				       AUX_ANT_CG_TRX : AUX_ANT_CGCS_RX;
+			optional_ant = (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ?
+					MAIN_ANT_CG_TRX : MAIN_ANT_CGCS_RX;
 		}
 
 		if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) {
-			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, DefaultAnt);	/* Default RX */
-			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT8|BIT7|BIT6, OptionalAnt);		/* Optional RX */
-			phy_set_bb_reg(adapter, ODM_REG_ANTSEL_CTRL_11N, BIT14|BIT13|BIT12, DefaultAnt);	/* Default TX */
-			phy_set_bb_reg(adapter, ODM_REG_RESP_TX_11N, BIT6|BIT7, DefaultAnt);	/* Resp Tx */
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N,
+				       BIT5|BIT4|BIT3, default_ant);
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N,
+				       BIT8|BIT7|BIT6, optional_ant);
+			phy_set_bb_reg(adapter, ODM_REG_ANTSEL_CTRL_11N,
+				       BIT14|BIT13|BIT12, default_ant);
+			phy_set_bb_reg(adapter, ODM_REG_RESP_TX_11N,
+				       BIT6|BIT7, default_ant);
 		} else if (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV) {
-			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, DefaultAnt);	/* Default RX */
-			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT8|BIT7|BIT6, OptionalAnt);		/* Optional RX */
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N,
+				       BIT5|BIT4|BIT3, default_ant);
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N,
+				       BIT8|BIT7|BIT6, optional_ant);
 		}
 	}
-	dm_fat_tbl->RxIdleAnt = Ant;
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("RxIdleAnt=%s\n", (Ant == MAIN_ANT) ? "MAIN_ANT" : "AUX_ANT"));
-	pr_info("RxIdleAnt=%s\n", (Ant == MAIN_ANT) ? "MAIN_ANT" : "AUX_ANT");
+	dm_fat_tbl->RxIdleAnt = ant;
 }
 
 static void odm_UpdateTxAnt_88E(struct odm_dm_struct *dm_odm, u8 Ant, u32 MacId)
@@ -324,7 +331,7 @@ static void odm_HWAntDiv(struct odm_dm_struct *dm_odm)
 	}
 
 	/* 2 Set RX Idle Antenna */
-	ODM_UpdateRxIdleAnt_88E(dm_odm, RxIdleAnt);
+	rtl88eu_dm_update_rx_idle_ant(dm_odm, RxIdleAnt);
 
 	pDM_DigTable->AntDiv_RSSI_max = AntDivMaxRSSI;
 	pDM_DigTable->RSSI_max = MaxRSSI;
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index c4c0087..caf2ca3 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -1745,7 +1745,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 			/* switch antenna to Optimum_antenna */
 			if (haldata->CurAntenna !=  Optimum_antenna) {
 				Ant = (Optimum_antenna == 2) ? MAIN_ANT : AUX_ANT;
-				ODM_UpdateRxIdleAnt_88E(&haldata->odmpriv, Ant);
+				rtl88eu_dm_update_rx_idle_ant(&haldata->odmpriv, Ant);
 
 				haldata->CurAntenna = Optimum_antenna;
 			}
diff --git a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
index 7ef8c36..7dc2698 100644
--- a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
@@ -36,7 +36,7 @@ void ODM_AntennaDiversity_88E(struct odm_dm_struct *pDM_Odm);
 void ODM_SetTxAntByTxInfo_88E(struct odm_dm_struct *pDM_Odm, u8 *pDesc,
 			      u8 macId);
 
-void ODM_UpdateRxIdleAnt_88E(struct odm_dm_struct *pDM_Odm, u8 Ant);
+void rtl88eu_dm_update_rx_idle_ant(struct odm_dm_struct *dm_odm, u8 ant);
 
 void ODM_AntselStatistics_88E(struct odm_dm_struct *pDM_Odm, u8	antsel_tr_mux,
 			      u32 MacId, u8 RxPWDBAll);
-- 
1.7.10.4

