Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbaITO15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:57 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36139 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaITO1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:27:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/13] staging: rtl8188eu: odm.h: Remove unused struct dyn_primary_cca
Date: Sat, 20 Sep 2014 19:55:59 +0530
Message-Id: <1411223160-17292-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct odm_dm_struct has a member of struct dyn_primary_cca,
which is initialized once and then never used by driver, so
we can remove struct dyn_promary_cca and code which initialize
it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c              |    1 -
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c     |   15 ---------------
 drivers/staging/rtl8188eu/include/odm.h          |    9 ---------
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h |    2 --
 4 files changed, 27 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 7da7fd7..e4df837 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -191,7 +191,6 @@ void ODM_DMInit(struct odm_dm_struct *pDM_Odm)
 	odm_DIGInit(pDM_Odm);
 	odm_RateAdaptiveMaskInit(pDM_Odm);
 
-	odm_PrimaryCCA_Init(pDM_Odm);    /*  Gary */
 	odm_DynamicTxPowerInit(pDM_Odm);
 	odm_TXPowerTrackingInit(pDM_Odm);
 	ODM_EdcaTurboInit(pDM_Odm);
diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 495d9ec..5342af7 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -370,18 +370,3 @@ void rtl88eu_dm_antenna_diversity(struct odm_dm_struct *dm_odm)
 	    (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV))
 		rtl88eu_dm_hw_ant_div(dm_odm);
 }
-
-/* 3============================================================ */
-/* 3 Dynamic Primary CCA */
-/* 3============================================================ */
-
-void odm_PrimaryCCA_Init(struct odm_dm_struct *dm_odm)
-{
-	struct dyn_primary_cca *PrimaryCCA = &(dm_odm->DM_PriCCA);
-
-	PrimaryCCA->DupRTS_flag = 0;
-	PrimaryCCA->intf_flag = 0;
-	PrimaryCCA->intf_type = 0;
-	PrimaryCCA->Monitor_flag = 0;
-	PrimaryCCA->PriCCA_flag = 0;
-}
diff --git a/drivers/staging/rtl8188eu/include/odm.h b/drivers/staging/rtl8188eu/include/odm.h
index e83812f..525eb10 100644
--- a/drivers/staging/rtl8188eu/include/odm.h
+++ b/drivers/staging/rtl8188eu/include/odm.h
@@ -164,14 +164,6 @@ struct false_alarm_stats {
 	u32	Cnt_BW_LSC;	/* Gary */
 };
 
-struct dyn_primary_cca {
-	u8		PriCCA_flag;
-	u8		intf_flag;
-	u8		intf_type;
-	u8		DupRTS_flag;
-	u8		Monitor_flag;
-};
-
 struct rx_hpc {
 	u8		RXHP_flag;
 	u8		PSD_func_trigger;
@@ -867,7 +859,6 @@ struct odm_dm_struct {
 	struct fast_ant_train DM_FatTable;
 	struct rtw_dig	DM_DigTable;
 	struct rtl_ps	DM_PSTable;
-	struct dyn_primary_cca DM_PriCCA;
 	struct rx_hpc	DM_RXHP_Table;
 	struct false_alarm_stats FalseAlmCnt;
 	struct false_alarm_stats FlaseAlmCntBuddyAdapter;
diff --git a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
index eabef39..14dce6c 100644
--- a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
@@ -47,8 +47,6 @@ void odm_FastAntTrainingCallback(struct odm_dm_struct *pDM_Odm);
 
 void odm_FastAntTrainingWorkItemCallback(struct odm_dm_struct *pDM_Odm);
 
-void odm_PrimaryCCA_Init(struct odm_dm_struct *pDM_Odm);
-
 bool ODM_DynamicPrimaryCCA_DupRTS(struct odm_dm_struct *pDM_Odm);
 
 #endif
-- 
1.7.10.4

