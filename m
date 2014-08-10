Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaHJOpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:45:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52092 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaHJOpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:45:42 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/22] staging: rtl8188eu: Remove unused function odm_ConfigRFReg_8188E()
Date: Sun, 10 Aug 2014 20:14:18 +0530
Message-Id: <1407681875-2611-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |   25 --------------------
 .../staging/rtl8188eu/include/odm_RegConfig8188E.h |    3 ---
 2 files changed, 28 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
index 41caff9..9c6ad5b 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
@@ -20,31 +20,6 @@
 
 #include "odm_precomp.h"
 
-void odm_ConfigRFReg_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
-			   u32 Data, enum rf_radio_path RF_PATH,
-			   u32 RegAddr)
-{
-	struct adapter *adapter = pDM_Odm->Adapter;
-
-	if (Addr == 0xffe) {
-		msleep(50);
-	} else if (Addr == 0xfd) {
-		mdelay(5);
-	} else if (Addr == 0xfc) {
-		mdelay(1);
-	} else if (Addr == 0xfb) {
-		udelay(50);
-	} else if (Addr == 0xfa) {
-		udelay(5);
-	} else if (Addr == 0xf9) {
-		udelay(1);
-	} else {
-		PHY_SetRFReg(adapter, RF_PATH, RegAddr, bRFRegOffsetMask, Data);
-		/*  Add 1us delay between BB/RF register setting. */
-		udelay(1);
-	}
-}
-
 void odm_ConfigMAC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u8 Data)
 {
 	struct adapter *adapt = pDM_Odm->Adapter;
diff --git a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h b/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
index c33c45b..b0d94e1 100644
--- a/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
@@ -20,9 +20,6 @@
 #ifndef __INC_ODM_REGCONFIG_H_8188E
 #define __INC_ODM_REGCONFIG_H_8188E
 
-void odm_ConfigRFReg_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u32 Data,
-			   enum rf_radio_path  RF_PATH, u32 RegAddr);
-
 void odm_ConfigMAC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr, u8 Data);
 
 void odm_ConfigBB_AGC_8188E(struct odm_dm_struct *pDM_Odm, u32 Addr,
-- 
1.7.10.4

