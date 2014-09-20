Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaITO1C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:27:02 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39724 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaITO07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:26:59 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/13] staging: rtl8188eu: Rework function ODM_AntennaDiversityInit_88E()
Date: Sat, 20 Sep 2014 19:55:52 +0530
Message-Id: <1411223160-17292-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
References: <1411223160-17292-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase function name.
Remove unnecessary debugging messages.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c              |    2 +-
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c     |    5 +----
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h |    2 +-
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index ae98379..bc891e9 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1265,7 +1265,7 @@ void odm_InitHybridAntDiv(struct odm_dm_struct *pDM_Odm)
 		return;
 	}
 
-	ODM_AntennaDiversityInit_88E(pDM_Odm);
+	rtl88eu_dm_antenna_div_init(pDM_Odm);
 }
 
 void odm_HwAntDiv(struct odm_dm_struct *pDM_Odm)
diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 68d0235..74105b5 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -174,11 +174,8 @@ static void dm_fast_training_init(struct odm_dm_struct *dm_odm)
 	phy_set_bb_reg(adapter, 0xc50, BIT7, 1);
 }
 
-void ODM_AntennaDiversityInit_88E(struct odm_dm_struct *dm_odm)
+void rtl88eu_dm_antenna_div_init(struct odm_dm_struct *dm_odm)
 {
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("dm_odm->AntDivType=%d\n", dm_odm->AntDivType));
-	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("dm_odm->bIsMPChip=%s\n", (dm_odm->bIsMPChip ? "true" : "false")));
-
 	if (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV)
 		dm_rx_hw_antena_div_init(dm_odm);
 	else if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
diff --git a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
index 02ac78d..7ef8c36 100644
--- a/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
+++ b/drivers/staging/rtl8188eu/include/odm_RTL8188E.h
@@ -29,7 +29,7 @@
 
 void ODM_DIG_LowerBound_88E(struct odm_dm_struct *pDM_Odm);
 
-void ODM_AntennaDiversityInit_88E(struct odm_dm_struct *pDM_Odm);
+void rtl88eu_dm_antenna_div_init(struct odm_dm_struct *dm_odm);
 
 void ODM_AntennaDiversity_88E(struct odm_dm_struct *pDM_Odm);
 
-- 
1.7.10.4

