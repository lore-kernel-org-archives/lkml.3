Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaHJOpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:45:39 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58495 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaHJOpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:45:34 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/22] staging: rtl8188eu: Remove unused functions odm_ConfigRF_Radio[A,B]_8188E()
Date: Sun, 10 Aug 2014 20:14:17 +0530
Message-Id: <1407681875-2611-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c  |   19 -------------------
 .../staging/rtl8188eu/include/odm_RegConfig8188E.h  |    6 ------
 2 files changed, 25 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
index 4d4978b..41caff9 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
@@ -45,25 +45,6 @@ void odm_ConfigRFReg_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
 	}
 }
 
-void odm_ConfigRF_RadioA_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u32 Data)
-{
-	u32  content = 0x1000; /*  RF_Content: radioa_txt */
-	u32 maskforPhySet = (u32)(content&0xE000);
-
-	odm_ConfigRFReg_8188E(pDM_Odm, Addr, Data, RF_PATH_A, Addr|maskforPhySet);
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_INIT, ODM_DBG_TRACE, ("===> ODM_ConfigRFWithHeaderFile: [RadioA] %08X %08X\n", Addr, Data));
-}
-
-void odm_ConfigRF_RadioB_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u32 Data)
-{
-	u32  content = 0x1001; /*  RF_Content: radiob_txt */
-	u32 maskforPhySet = (u32)(content&0xE000);
-
-	odm_ConfigRFReg_8188E(pDM_Odm, Addr, Data, RF_PATH_B, Addr|maskforPhySet);
-
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_INIT, ODM_DBG_TRACE, ("===> ODM_ConfigRFWithHeaderFile: [RadioB] %08X %08X\n", Addr, Data));
-}
-
 void odm_ConfigMAC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u8 Data)
 {
 	struct adapter *adapt = pDM_Odm->Adapter;
diff --git a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h b/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
index f2bf7a0..c33c45b 100644
--- a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
@@ -23,12 +23,6 @@
 void odm_ConfigRFReg_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u32 Data,
 			   enum rf_radio_path  RF_PATH, u32 RegAddr);
 
-void odm_ConfigRF_RadioA_8188E(struct odm_dm_struct *pDM_Odm,
-			       u32 Addr, u32 Data);
-
-void odm_ConfigRF_RadioB_8188E(struct odm_dm_struct *pDM_Odm,
-			       u32 Addr, u32 Data);
-
 void odm_ConfigMAC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u8 Data);
 
 void odm_ConfigBB_AGC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
-- 
1.7.10.4

