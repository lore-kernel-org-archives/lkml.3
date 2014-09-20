Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaITO1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59631 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaITO1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:27:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/13] staging: rtl8188eu: Rework function ODM_SetTxAntByTxInfo_88E()
Date: Sat, 20 Sep 2014 19:55:55 +0530
Message-Id: <1411223160-17292-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase function name and local variables.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c     |   12 +++++++-----
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c   |    3 ++-
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h |    4 ++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index f3a4e28..5a51405 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -236,14 +236,16 @@ static void update_tx_ant_88eu(struct odm_dm_struct *dm_odm, u8 ant, u32 mac_id)
 	dm_fat_tbl->antsel_c[mac_id] = (target_ant&BIT2)>>2;
 }
 
-void ODM_SetTxAntByTxInfo_88E(struct odm_dm_struct *dm_odm, u8 *pDesc, u8 macId)
+void rtl88eu_dm_set_tx_ant_by_tx_info(struct odm_dm_struct *dm_odm,
+				      u8 *desc, u8 mac_id)
 {
 	struct fast_ant_train *dm_fat_tbl = &dm_odm->DM_FatTable;
 
-	if ((dm_odm->AntDivType == CG_TRX_HW_ANTDIV) || (dm_odm->AntDivType == CG_TRX_SMART_ANTDIV)) {
-		SET_TX_DESC_ANTSEL_A_88E(pDesc, dm_fat_tbl->antsel_a[macId]);
-		SET_TX_DESC_ANTSEL_B_88E(pDesc, dm_fat_tbl->antsel_b[macId]);
-		SET_TX_DESC_ANTSEL_C_88E(pDesc, dm_fat_tbl->antsel_c[macId]);
+	if ((dm_odm->AntDivType == CG_TRX_HW_ANTDIV) ||
+	    (dm_odm->AntDivType == CG_TRX_SMART_ANTDIV)) {
+		SET_TX_DESC_ANTSEL_A_88E(desc, dm_fat_tbl->antsel_a[mac_id]);
+		SET_TX_DESC_ANTSEL_B_88E(desc, dm_fat_tbl->antsel_b[mac_id]);
+		SET_TX_DESC_ANTSEL_C_88E(desc, dm_fat_tbl->antsel_c[mac_id]);
 	}
 }
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 3494ac6..be9eede 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -336,7 +336,8 @@ static s32 update_txdesc(struct xmit_frame *pxmitframe, u8 *pmem, s32 sz, u8 bag
 		ptxdesc->txdw4 |= cpu_to_le32(HW_SSN);	/*  Hw set sequence number */
 	}
 
-	ODM_SetTxAntByTxInfo_88E(&haldata->odmpriv, pmem, pattrib->mac_id);
+	rtl88eu_dm_set_tx_ant_by_tx_info(&haldata->odmpriv, pmem,
+					 pattrib->mac_id);
 
 	rtl8188eu_cal_txdesc_chksum(ptxdesc);
 	_dbg_dump_tx_info(adapt, pxmitframe->frame_tag, ptxdesc);
diff --git a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
index 7dc2698..7a10101 100644
--- a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
@@ -33,8 +33,8 @@ void rtl88eu_dm_antenna_div_init(struct odm_dm_struct *dm_odm);
 
 void ODM_AntennaDiversity_88E(struct odm_dm_struct *pDM_Odm);
 
-void ODM_SetTxAntByTxInfo_88E(struct odm_dm_struct *pDM_Odm, u8 *pDesc,
-			      u8 macId);
+void rtl88eu_dm_set_tx_ant_by_tx_info(struct odm_dm_struct *dm_odm, u8 *desc,
+				      u8 mac_id);
 
 void rtl88eu_dm_update_rx_idle_ant(struct odm_dm_struct *dm_odm, u8 ant);
 
-- 
1.7.10.4

