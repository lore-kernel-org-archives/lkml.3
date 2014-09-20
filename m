Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbaITO0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:26:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55043 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbaITO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:26:31 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/13] staging: rtl8188eu: Rework function odm_RX_HWAntDivInit()
Date: Sat, 20 Sep 2014 19:55:49 +0530
Message-Id: <1411223160-17292-3-git-send-email-navin.patidar@gmail.com>
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
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c |   31 +++++++++++++-------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 095078d..4b8bafe 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -21,34 +21,35 @@
 #include "odm_precomp.h"
 #include "phy.h"
 
-static void odm_RX_HWAntDivInit(struct odm_dm_struct *dm_odm)
+static void dm_rx_hw_antena_div_init(struct odm_dm_struct *dm_odm)
 {
 	struct adapter *adapter = dm_odm->Adapter;
-	u32	value32;
+	u32 value32;
 
 	if (*(dm_odm->mp_mode) == 1) {
 		dm_odm->AntDivType = CGCS_RX_SW_ANTDIV;
-		phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0); /*  disable HW AntDiv */
-		phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);  /*  1:CG, 0:CS */
+		phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0);
+		phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);
 		return;
 	}
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("odm_RX_HWAntDivInit()\n"));
 
 	/* MAC Setting */
 	value32 = phy_query_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
-	phy_set_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
+	phy_set_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord,
+		       value32|(BIT23|BIT25));
 	/* Pin Settings */
-	phy_set_bb_reg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0	antsel antselb by HW */
-	phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
-	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 1);	/* Regb2c[22]=1'b0	disable CS/CG switch */
-	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
+	phy_set_bb_reg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);
+	phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);
+	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 1);
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
 	ODM_UpdateRxIdleAnt_88E(dm_odm, MAIN_ANT);
-	phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, 0xFFFF, 0x0201);	/* antenna mapping table */
+	phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, 0xFFFF, 0x0201);
 }
 
 static void odm_TRX_HWAntDivInit(struct odm_dm_struct *dm_odm)
@@ -177,7 +178,7 @@ void ODM_AntennaDiversityInit_88E(struct odm_dm_struct *dm_odm)
 	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("dm_odm->bIsMPChip=%s\n", (dm_odm->bIsMPChip ? "true" : "false")));
 
 	if (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV)
-		odm_RX_HWAntDivInit(dm_odm);
+		dm_rx_hw_antena_div_init(dm_odm);
 	else if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
 		odm_TRX_HWAntDivInit(dm_odm);
 	else if (dm_odm->AntDivType == CG_TRX_SMART_ANTDIV)
-- 
1.7.10.4

