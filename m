Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaITO1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:52 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56204 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaITO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:27:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/13] staging: rtl8188eu: Rework function ODM_AntennaDiversity_88E()
Date: Sat, 20 Sep 2014 19:55:58 +0530
Message-Id: <1411223160-17292-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase function name.
Remove unnecessary comments.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c              |    2 +-
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c     |   31 +++++++++++++---------
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h |    2 +-
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index bc891e9..7da7fd7 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1275,7 +1275,7 @@ void odm_HwAntDiv(struct odm_dm_struct *pDM_Odm)
 		return;
 	}
 
-	ODM_AntennaDiversity_88E(pDM_Odm);
+	rtl88eu_dm_antenna_diversity(pDM_Odm);
 }
 
 /* EDCA Turbo */
diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 4e390d9..495d9ec 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -331,7 +331,7 @@ static void rtl88eu_dm_hw_ant_div(struct odm_dm_struct *dm_odm)
 	dig_table->RSSI_max = max_rssi;
 }
 
-void ODM_AntennaDiversity_88E(struct odm_dm_struct *dm_odm)
+void rtl88eu_dm_antenna_diversity(struct odm_dm_struct *dm_odm)
 {
 	struct fast_ant_train *dm_fat_tbl = &dm_odm->DM_FatTable;
 	struct adapter *adapter = dm_odm->Adapter;
@@ -339,28 +339,35 @@ void ODM_AntennaDiversity_88E(struct odm_dm_struct *dm_odm)
 	if (!(dm_odm->SupportAbility & ODM_BB_ANT_DIV))
 		return;
 	if (!dm_odm->bLinked) {
-		ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("ODM_AntennaDiversity_88E(): No Link.\n"));
+		ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
+			     ("ODM_AntennaDiversity_88E(): No Link.\n"));
 		if (dm_fat_tbl->bBecomeLinked) {
-			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("Need to Turn off HW AntDiv\n"));
-			phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0);	/* RegC50[7]=1'b1		enable HW AntDiv */
-			phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N, BIT15, 0); /* Enable CCK AntDiv */
+			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
+				     ("Need to Turn off HW AntDiv\n"));
+			phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0);
+			phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N,
+				       BIT15, 0);
 			if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
-				phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0); /* Reg80c[21]=1'b0		from TX Reg */
+				phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N,
+					       BIT21, 0);
 			dm_fat_tbl->bBecomeLinked = dm_odm->bLinked;
 		}
 		return;
 	} else {
 		if (!dm_fat_tbl->bBecomeLinked) {
-			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("Need to Turn on HW AntDiv\n"));
-			/* Because HW AntDiv is disabled before Link, we enable HW AntDiv after link */
-			phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 1);	/* RegC50[7]=1'b1		enable HW AntDiv */
-			phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N, BIT15, 1); /* Enable CCK AntDiv */
+			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD,
+				     ("Need to Turn on HW AntDiv\n"));
+			phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 1);
+			phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N,
+				       BIT15, 1);
 			if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
-				phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 1); /* Reg80c[21]=1'b1		from TX Info */
+				phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N,
+					       BIT21, 1);
 			dm_fat_tbl->bBecomeLinked = dm_odm->bLinked;
 		}
 	}
-	if ((dm_odm->AntDivType == CG_TRX_HW_ANTDIV) || (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV))
+	if ((dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ||
+	    (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV))
 		rtl88eu_dm_hw_ant_div(dm_odm);
 }
 
diff --git a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
index 684947f..eabef39 100644
--- a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
@@ -31,7 +31,7 @@ void ODM_DIG_LowerBound_88E(struct odm_dm_struct *pDM_Odm);
 
 void rtl88eu_dm_antenna_div_init(struct odm_dm_struct *dm_odm);
 
-void ODM_AntennaDiversity_88E(struct odm_dm_struct *pDM_Odm);
+void rtl88eu_dm_antenna_diversity(struct odm_dm_struct *dm_odm);
 
 void rtl88eu_dm_set_tx_ant_by_tx_info(struct odm_dm_struct *dm_odm, u8 *desc,
 				      u8 mac_id);
-- 
1.7.10.4

