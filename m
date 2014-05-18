Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaERPYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:24:12 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39287 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaERPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:24:11 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/28] staging: rtl8188eu: Remove unused function odm_DIGbyRSSI_LPS()
Date: Sun, 18 May 2014 20:49:09 +0530
Message-Id: <1400426361-19596-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |   45 -----------------------------------
 1 file changed, 45 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 89a26e3..d8482ab 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -529,51 +529,6 @@ void ODM_Write_DIG(struct odm_dm_struct *pDM_Odm, u8 CurrentIGI)
 /*  Add by Neil Chen to enable edcca to MP Platform */
 }
 
-/* Need LPS mode for CE platform --2012--08--24--- */
-/* 8723AS/8189ES */
-void odm_DIGbyRSSI_LPS(struct odm_dm_struct *pDM_Odm)
-{
-	struct adapter *pAdapter = pDM_Odm->Adapter;
-	struct false_alarm_stats *pFalseAlmCnt = &pDM_Odm->FalseAlmCnt;
-
-	u8 RSSI_Lower = DM_DIG_MIN_NIC;   /* 0x1E or 0x1C */
-	u8 bFwCurrentInPSMode = false;
-	u8 CurrentIGI = pDM_Odm->RSSI_Min;
-
-	CurrentIGI = CurrentIGI + RSSI_OFFSET_DIG;
-	bFwCurrentInPSMode = pAdapter->pwrctrlpriv.bFwCurrentInPSMode;
-
-	/*  Using FW PS mode to make IGI */
-	if (bFwCurrentInPSMode) {
-		ODM_RT_TRACE(pDM_Odm, ODM_COMP_DIG, ODM_DBG_LOUD, ("---Neil---odm_DIG is in LPS mode\n"));
-		/* Adjust by  FA in LPS MODE */
-		if (pFalseAlmCnt->Cnt_all > DM_DIG_FA_TH2_LPS)
-			CurrentIGI = CurrentIGI+2;
-		else if (pFalseAlmCnt->Cnt_all > DM_DIG_FA_TH1_LPS)
-			CurrentIGI = CurrentIGI+1;
-		else if (pFalseAlmCnt->Cnt_all < DM_DIG_FA_TH0_LPS)
-			CurrentIGI = CurrentIGI-1;
-	} else {
-		CurrentIGI = RSSI_Lower;
-	}
-
-	/* Lower bound checking */
-
-	/* RSSI Lower bound check */
-	if ((pDM_Odm->RSSI_Min-10) > DM_DIG_MIN_NIC)
-		RSSI_Lower = (pDM_Odm->RSSI_Min-10);
-	else
-		RSSI_Lower = DM_DIG_MIN_NIC;
-
-	/* Upper and Lower Bound checking */
-	 if (CurrentIGI > DM_DIG_MAX_NIC)
-		CurrentIGI = DM_DIG_MAX_NIC;
-	 else if (CurrentIGI < RSSI_Lower)
-		CurrentIGI = RSSI_Lower;
-
-	ODM_Write_DIG(pDM_Odm, CurrentIGI);/* ODM_Write_DIG(pDM_Odm, pDM_DigTable->CurIGValue); */
-}
-
 void odm_DIGInit(struct odm_dm_struct *pDM_Odm)
 {
 	struct adapter *adapter = pDM_Odm->Adapter;
-- 
1.7.10.4

