Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaERPZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:25:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaERPZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:25:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/28] staging:rtl8188eu: Remove unused function iodm_1R_CCA()
Date: Sun, 18 May 2014 20:49:12 +0530
Message-Id: <1400426361-19596-20-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |   34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index e8ad880..7319b3e 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -848,40 +848,6 @@ void ODM_Write_CCK_CCA_Thres(struct odm_dm_struct *pDM_Odm, u8 CurCCK_CCAThres)
 	pDM_DigTable->CurCCK_CCAThres = CurCCK_CCAThres;
 }
 
-void odm_1R_CCA(struct odm_dm_struct *pDM_Odm)
-{
-	struct adapter *adapter = pDM_Odm->Adapter;
-	struct rtl_ps *pDM_PSTable = &pDM_Odm->DM_PSTable;
-
-	if (pDM_Odm->RSSI_Min != 0xFF) {
-		if (pDM_PSTable->PreCCAState == CCA_2R) {
-			if (pDM_Odm->RSSI_Min >= 35)
-				pDM_PSTable->CurCCAState = CCA_1R;
-			else
-				pDM_PSTable->CurCCAState = CCA_2R;
-		} else {
-			if (pDM_Odm->RSSI_Min <= 30)
-				pDM_PSTable->CurCCAState = CCA_2R;
-			else
-				pDM_PSTable->CurCCAState = CCA_1R;
-		}
-	} else {
-		pDM_PSTable->CurCCAState = CCA_MAX;
-	}
-
-	if (pDM_PSTable->PreCCAState != pDM_PSTable->CurCCAState) {
-		if (pDM_PSTable->CurCCAState == CCA_1R) {
-			if (pDM_Odm->RFType == ODM_2T2R)
-				PHY_SetBBReg(adapter, 0xc04, bMaskByte0, 0x13);
-			else
-				PHY_SetBBReg(adapter, 0xc04, bMaskByte0, 0x23);
-		} else {
-			PHY_SetBBReg(adapter, 0xc04, bMaskByte0, 0x33);
-		}
-		pDM_PSTable->PreCCAState = pDM_PSTable->CurCCAState;
-	}
-}
-
 void ODM_RF_Saving(struct odm_dm_struct *pDM_Odm, u8 bForceInNormal)
 {
 	struct adapter *adapter = pDM_Odm->Adapter;
-- 
1.7.10.4

