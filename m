Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaITO0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:26:43 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34825 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbaITO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:26:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/13] staging: rtl8188eu: Rework function odm_TRX_HWAntDivInit()
Date: Sat, 20 Sep 2014 19:55:50 +0530
Message-Id: <1411223160-17292-4-git-send-email-navin.patidar@gmail.com>
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
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c |   39 +++++++++++++++-----------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 4b8bafe..8cbd578 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -52,42 +52,47 @@ static void dm_rx_hw_antena_div_init(struct odm_dm_struct *dm_odm)
 	phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, 0xFFFF, 0x0201);
 }
 
-static void odm_TRX_HWAntDivInit(struct odm_dm_struct *dm_odm)
+static void dm_trx_hw_antenna_div_init(struct odm_dm_struct *dm_odm)
 {
 	struct adapter *adapter = dm_odm->Adapter;
 	u32	value32;
 
 	if (*(dm_odm->mp_mode) == 1) {
 		dm_odm->AntDivType = CGCS_RX_SW_ANTDIV;
-		phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0); /*  disable HW AntDiv */
-		phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, 0); /* Default RX   (0/1) */
+		phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0);
+		phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N,
+			       BIT5|BIT4|BIT3, 0);
 		return;
 	}
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("odm_TRX_HWAntDivInit()\n"));
 
 	/* MAC Setting */
 	value32 = phy_query_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
-	phy_set_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
+	phy_set_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord,
+		       value32|(BIT23|BIT25));
 	/* Pin Settings */
-	phy_set_bb_reg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0		antsel antselb by HW */
-	phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
-	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 0);	/* Regb2c[22]=1'b0	disable CS/CG switch */
-	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
+	phy_set_bb_reg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);
+	phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);
+	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 0);
+	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);
 	/* OFDM Settings */
-	phy_set_bb_reg(adapter, ODM_REG_ANTDIV_PARA1_11N, bMaskDWord, 0x000000a0);
+	phy_set_bb_reg(adapter, ODM_REG_ANTDIV_PARA1_11N, bMaskDWord,
+		       0x000000a0);
 	/* CCK Settings */
-	phy_set_bb_reg(adapter, ODM_REG_BB_PWR_SAV4_11N, BIT7, 1); /* Fix CCK PHY status report issue */
-	phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1); /* CCK complete HW AntDiv within 64 samples */
+	phy_set_bb_reg(adapter, ODM_REG_BB_PWR_SAV4_11N, BIT7, 1);
+	phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1);
 	/* Tx Settings */
-	phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0); /* Reg80c[21]=1'b0		from TX Reg */
+	phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0);
 	ODM_UpdateRxIdleAnt_88E(dm_odm, MAIN_ANT);
 
 	/* antenna mapping table */
 	if (!dm_odm->bIsMPChip) { /* testchip */
-		phy_set_bb_reg(adapter, ODM_REG_RX_DEFUALT_A_11N, BIT10|BIT9|BIT8, 1);	/* Reg858[10:8]=3'b001 */
-		phy_set_bb_reg(adapter, ODM_REG_RX_DEFUALT_A_11N, BIT13|BIT12|BIT11, 2);	/* Reg858[13:11]=3'b010 */
+		phy_set_bb_reg(adapter, ODM_REG_RX_DEFUALT_A_11N,
+			       BIT10|BIT9|BIT8, 1);
+		phy_set_bb_reg(adapter, ODM_REG_RX_DEFUALT_A_11N,
+			       BIT13|BIT12|BIT11, 2);
 	} else { /* MPchip */
-		phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, bMaskDWord, 0x0201);	/* Reg914=3'b010, Reg915=3'b001 */
+		phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, bMaskDWord,
+			       0x0201);
 	}
 }
 
@@ -180,7 +185,7 @@ void ODM_AntennaDiversityInit_88E(struct odm_dm_struct *dm_odm)
 	if (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV)
 		dm_rx_hw_antena_div_init(dm_odm);
 	else if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
-		odm_TRX_HWAntDivInit(dm_odm);
+		dm_trx_hw_antenna_div_init(dm_odm);
 	else if (dm_odm->AntDivType == CG_TRX_SMART_ANTDIV)
 		odm_FastAntTrainingInit(dm_odm);
 }
-- 
1.7.10.4

