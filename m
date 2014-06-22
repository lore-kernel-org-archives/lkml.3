Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaFVIVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:21:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56629 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaFVIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:21:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/42] staging: rtl8188eu: Remove dummy function odm_DynamicTxPower()
Date: Sun, 22 Jun 2014 13:49:21 +0530
Message-Id: <1403425202-11942-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c             |   14 --------------
 drivers/staging/rtl8188eu/include/odm_precomp.h |    1 -
 2 files changed, 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 60dbde7..f8dcfda 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -221,7 +221,6 @@ void ODM_DMWatchdog(struct odm_dm_struct *pDM_Odm)
 
 	ODM_TXPowerTrackingCheck(pDM_Odm);
 	odm_EdcaTurboCheck(pDM_Odm);
-	odm_DynamicTxPower(pDM_Odm);
 }
 
 /*  Init /.. Fixed HW value. Only init time. */
@@ -1110,19 +1109,6 @@ void odm_DynamicTxPowerInit(struct odm_dm_struct *pDM_Odm)
 	pdmpriv->DynamicTxHighPowerLvl = TxHighPwrLevel_Normal;
 }
 
-void odm_DynamicTxPower(struct odm_dm_struct *pDM_Odm)
-{
-	/*  For AP/ADSL use struct rtl8192cd_priv * */
-	/*  For CE/NIC use struct adapter * */
-
-	if (!(pDM_Odm->SupportAbility & ODM_BB_DYNAMIC_TXPWR))
-		return;
-
-	/*  2012/01/12 MH According to Luke's suggestion, only high power will support the feature. */
-	if (!pDM_Odm->ExtPA)
-		return;
-}
-
 /* 3============================================================ */
 /* 3 RSSI Monitor */
 /* 3============================================================ */
diff --git a/drivers/staging/rtl8188eu/include/odm_precomp.h b/drivers/staging/rtl8188eu/include/odm_precomp.h
index df61892..0ab8254 100644
--- a/drivers/staging/rtl8188eu/include/odm_precomp.h
+++ b/drivers/staging/rtl8188eu/include/odm_precomp.h
@@ -71,7 +71,6 @@ void odm_RefreshRateAdaptiveMaskMP(struct odm_dm_struct *pDM_Odm);
 void odm_DynamicBBPowerSaving(struct odm_dm_struct *pDM_Odm);
 void odm_SwAntDivChkAntSwitch(struct odm_dm_struct *pDM_Odm, u8 Step);
 void odm_EdcaTurboCheck(struct odm_dm_struct *pDM_Odm);
-void odm_DynamicTxPower(struct odm_dm_struct *pDM_Odm);
 void odm_CommonInfoSelfInit(struct odm_dm_struct *pDM_Odm);
 void odm_RSSIMonitorCheck(struct odm_dm_struct *pDM_Odm);
 void odm_RefreshRateAdaptiveMask(struct odm_dm_struct *pDM_Odm);
-- 
1.7.10.4

