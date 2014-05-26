Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaEZQHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:54 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39054 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 19/24] staging: rtl8188eu: Remove unnecessary debugging message from ODM_Write_DIG()
Date: Mon, 26 May 2014 21:35:34 +0530
Message-Id: <1401120339-23667-19-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 2bd68aa..205ba7f 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -511,19 +511,10 @@ void ODM_Write_DIG(struct odm_dm_struct *pDM_Odm, u8 CurrentIGI)
 	struct rtw_dig *pDM_DigTable = &pDM_Odm->DM_DigTable;
 	struct adapter *adapter = pDM_Odm->Adapter;
 
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_DIG, ODM_DBG_LOUD,
-		     ("ODM_REG(IGI_A,pDM_Odm)=0x%x, ODM_BIT(IGI,pDM_Odm)=0x%x\n",
-		     ODM_REG(IGI_A, pDM_Odm), ODM_BIT(IGI, pDM_Odm)));
-
 	if (pDM_DigTable->CurIGValue != CurrentIGI) {
 		PHY_SetBBReg(adapter, ODM_REG(IGI_A, pDM_Odm), ODM_BIT(IGI, pDM_Odm), CurrentIGI);
-		ODM_RT_TRACE(pDM_Odm, ODM_COMP_DIG, ODM_DBG_LOUD, ("CurrentIGI(0x%02x).\n", CurrentIGI));
-		/* pDM_DigTable->PreIGValue = pDM_DigTable->CurIGValue; */
 		pDM_DigTable->CurIGValue = CurrentIGI;
 	}
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_DIG, ODM_DBG_LOUD, ("ODM_Write_DIG():CurrentIGI=0x%x\n", CurrentIGI));
-
-/*  Add by Neil Chen to enable edcca to MP Platform */
 }
 
 void odm_DIGInit(struct odm_dm_struct *pDM_Odm)
-- 
1.7.10.4

