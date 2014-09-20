Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaITO0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:26:52 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60595 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaITO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:26:50 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/13] staging: rtl8188eu: Rework function odm_FastAntTrainingInit()
Date: Sat, 20 Sep 2014 19:55:51 +0530
Message-Id: <1411223160-17292-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase function name.
Remove unnecessary comments and debugging messages.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c |   53 ++++++++++++--------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 8cbd578..68d0235 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -96,17 +96,14 @@ static void dm_trx_hw_antenna_div_init(struct odm_dm_struct *dm_odm)
 	}
 }
 
-static void odm_FastAntTrainingInit(struct odm_dm_struct *dm_odm)
+static void dm_fast_training_init(struct odm_dm_struct *dm_odm)
 {
 	struct adapter *adapter = dm_odm->Adapter;
-	u32	value32, i;
+	u32 value32, i;
 	struct fast_ant_train *dm_fat_tbl = &dm_odm->DM_FatTable;
-	u32	AntCombination = 2;
-
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("odm_FastAntTrainingInit()\n"));
+	u32 AntCombination = 2;
 
 	if (*(dm_odm->mp_mode) == 1) {
-		ODM_RT_TRACE(dm_odm, ODM_COMP_INIT, ODM_DBG_LOUD, ("dm_odm->AntDivType: %d\n", dm_odm->AntDivType));
 		return;
 	}
 
@@ -121,40 +118,40 @@ static void odm_FastAntTrainingInit(struct odm_dm_struct *dm_odm)
 
 	/* MAC Setting */
 	value32 = phy_query_bb_reg(adapter, 0x4c, bMaskDWord);
-	phy_set_bb_reg(adapter, 0x4c, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
+	phy_set_bb_reg(adapter, 0x4c, bMaskDWord, value32|(BIT23|BIT25));
 	value32 = phy_query_bb_reg(adapter,  0x7B4, bMaskDWord);
-	phy_set_bb_reg(adapter, 0x7b4, bMaskDWord, value32|(BIT16|BIT17)); /* Reg7B4[16]=1 enable antenna training, Reg7B4[17]=1 enable A2 match */
+	phy_set_bb_reg(adapter, 0x7b4, bMaskDWord, value32|(BIT16|BIT17));
 
 	/* Match MAC ADDR */
 	phy_set_bb_reg(adapter, 0x7b4, 0xFFFF, 0);
 	phy_set_bb_reg(adapter, 0x7b0, bMaskDWord, 0);
 
-	phy_set_bb_reg(adapter, 0x870, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0		antsel antselb by HW */
-	phy_set_bb_reg(adapter, 0x864, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
-	phy_set_bb_reg(adapter, 0xb2c, BIT22, 0);	/* Regb2c[22]=1'b0	disable CS/CG switch */
-	phy_set_bb_reg(adapter, 0xb2c, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
+	phy_set_bb_reg(adapter, 0x870, BIT9|BIT8, 0);
+	phy_set_bb_reg(adapter, 0x864, BIT10, 0);
+	phy_set_bb_reg(adapter, 0xb2c, BIT22, 0);
+	phy_set_bb_reg(adapter, 0xb2c, BIT31, 1);
 	phy_set_bb_reg(adapter, 0xca4, bMaskDWord, 0x000000a0);
 
 	/* antenna mapping table */
 	if (AntCombination == 2) {
 		if (!dm_odm->bIsMPChip) { /* testchip */
-			phy_set_bb_reg(adapter, 0x858, BIT10|BIT9|BIT8, 1);	/* Reg858[10:8]=3'b001 */
-			phy_set_bb_reg(adapter, 0x858, BIT13|BIT12|BIT11, 2);	/* Reg858[13:11]=3'b010 */
+			phy_set_bb_reg(adapter, 0x858, BIT10|BIT9|BIT8, 1);
+			phy_set_bb_reg(adapter, 0x858, BIT13|BIT12|BIT11, 2);
 		} else { /* MPchip */
 			phy_set_bb_reg(adapter, 0x914, bMaskByte0, 1);
 			phy_set_bb_reg(adapter, 0x914, bMaskByte1, 2);
 		}
 	} else if (AntCombination == 7) {
 		if (!dm_odm->bIsMPChip) { /* testchip */
-			phy_set_bb_reg(adapter, 0x858, BIT10|BIT9|BIT8, 0);	/* Reg858[10:8]=3'b000 */
-			phy_set_bb_reg(adapter, 0x858, BIT13|BIT12|BIT11, 1);	/* Reg858[13:11]=3'b001 */
+			phy_set_bb_reg(adapter, 0x858, BIT10|BIT9|BIT8, 0);
+			phy_set_bb_reg(adapter, 0x858, BIT13|BIT12|BIT11, 1);
 			phy_set_bb_reg(adapter, 0x878, BIT16, 0);
-			phy_set_bb_reg(adapter, 0x858, BIT15|BIT14, 2);	/* Reg878[0],Reg858[14:15])=3'b010 */
-			phy_set_bb_reg(adapter, 0x878, BIT19|BIT18|BIT17, 3);/* Reg878[3:1]=3b'011 */
-			phy_set_bb_reg(adapter, 0x878, BIT22|BIT21|BIT20, 4);/* Reg878[6:4]=3b'100 */
-			phy_set_bb_reg(adapter, 0x878, BIT25|BIT24|BIT23, 5);/* Reg878[9:7]=3b'101 */
-			phy_set_bb_reg(adapter, 0x878, BIT28|BIT27|BIT26, 6);/* Reg878[12:10]=3b'110 */
-			phy_set_bb_reg(adapter, 0x878, BIT31|BIT30|BIT29, 7);/* Reg878[15:13]=3b'111 */
+			phy_set_bb_reg(adapter, 0x858, BIT15|BIT14, 2);
+			phy_set_bb_reg(adapter, 0x878, BIT19|BIT18|BIT17, 3);
+			phy_set_bb_reg(adapter, 0x878, BIT22|BIT21|BIT20, 4);
+			phy_set_bb_reg(adapter, 0x878, BIT25|BIT24|BIT23, 5);
+			phy_set_bb_reg(adapter, 0x878, BIT28|BIT27|BIT26, 6);
+			phy_set_bb_reg(adapter, 0x878, BIT31|BIT30|BIT29, 7);
 		} else { /* MPchip */
 			phy_set_bb_reg(adapter, 0x914, bMaskByte0, 0);
 			phy_set_bb_reg(adapter, 0x914, bMaskByte1, 1);
@@ -168,13 +165,13 @@ static void odm_FastAntTrainingInit(struct odm_dm_struct *dm_odm)
 	}
 
 	/* Default Ant Setting when no fast training */
-	phy_set_bb_reg(adapter, 0x80c, BIT21, 1); /* Reg80c[21]=1'b1		from TX Info */
-	phy_set_bb_reg(adapter, 0x864, BIT5|BIT4|BIT3, 0);	/* Default RX */
-	phy_set_bb_reg(adapter, 0x864, BIT8|BIT7|BIT6, 1);	/* Optional RX */
+	phy_set_bb_reg(adapter, 0x80c, BIT21, 1);
+	phy_set_bb_reg(adapter, 0x864, BIT5|BIT4|BIT3, 0);
+	phy_set_bb_reg(adapter, 0x864, BIT8|BIT7|BIT6, 1);
 
 	/* Enter Traing state */
-	phy_set_bb_reg(adapter, 0x864, BIT2|BIT1|BIT0, (AntCombination-1));	/* Reg864[2:0]=3'd6	ant combination=reg864[2:0]+1 */
-	phy_set_bb_reg(adapter, 0xc50, BIT7, 1);	/* RegC50[7]=1'b1		enable HW AntDiv */
+	phy_set_bb_reg(adapter, 0x864, BIT2|BIT1|BIT0, (AntCombination-1));
+	phy_set_bb_reg(adapter, 0xc50, BIT7, 1);
 }
 
 void ODM_AntennaDiversityInit_88E(struct odm_dm_struct *dm_odm)
@@ -187,7 +184,7 @@ void ODM_AntennaDiversityInit_88E(struct odm_dm_struct *dm_odm)
 	else if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
 		dm_trx_hw_antenna_div_init(dm_odm);
 	else if (dm_odm->AntDivType == CG_TRX_SMART_ANTDIV)
-		odm_FastAntTrainingInit(dm_odm);
+		dm_fast_training_init(dm_odm);
 }
 
 void ODM_UpdateRxIdleAnt_88E(struct odm_dm_struct *dm_odm, u8 Ant)
-- 
1.7.10.4

