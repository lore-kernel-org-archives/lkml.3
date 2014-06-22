Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaFVI1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:27:31 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59771 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaFVIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:21:22 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/42] staging: rtl8188eu: Remove dummy rtl8188e_GetHalODMVar() and its wrapper
Date: Sun, 22 Jun 2014 13:49:23 +0530
Message-Id: <1403425202-11942-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c          |    9 ---------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    5 -----
 drivers/staging/rtl8188eu/include/hal_intf.h      |    6 ------
 3 files changed, 20 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 1afc566..bcd9c4d 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -156,15 +156,6 @@ void rtw_hal_set_odm_var(struct adapter *adapt,
 						      val1, set);
 }
 
-void rtw_hal_get_odm_var(struct adapter *adapt,
-			 enum hal_odm_variable var, void *val1,
-			 bool set)
-{
-	if (adapt->HalFunc.GetHalODMVarHandler)
-		adapt->HalFunc.GetHalODMVarHandler(adapt, var,
-						      val1, set);
-}
-
 void rtw_hal_enable_interrupt(struct adapter *adapt)
 {
 	if (adapt->HalFunc.enable_interrupt)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 4d3ea7c..9ce036e 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -544,10 +544,6 @@ static void rtl8188e_read_chip_version(struct adapter *padapter)
 	ReadChipVersion8188E(padapter);
 }
 
-static void rtl8188e_GetHalODMVar(struct adapter *Adapter, enum hal_odm_variable eVariable, void *pValue1, bool bSet)
-{
-}
-
 static void rtl8188e_SetHalODMVar(struct adapter *Adapter, enum hal_odm_variable eVariable, void *pValue1, bool bSet)
 {
 	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
@@ -622,7 +618,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->sreset_init_value = &sreset_init_value;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
 
-	pHalFunc->GetHalODMVarHandler = &rtl8188e_GetHalODMVar;
 	pHalFunc->SetHalODMVarHandler = &rtl8188e_SetHalODMVar;
 
 	pHalFunc->IOL_exec_cmds_sync = &rtl8188e_IOL_exec_cmds_sync;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index a86b3f8..482d0f3f 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -197,9 +197,6 @@ struct hal_ops {
 				       enum hal_def_variable eVariable,
 				       void *pValue);
 
-	void	(*GetHalODMVarHandler)(struct adapter *padapter,
-				       enum hal_odm_variable eVariable,
-				       void *pValue1, bool bSet);
 	void	(*SetHalODMVarHandler)(struct adapter *padapter,
 				       enum hal_odm_variable eVariable,
 				       void *pValue1, bool bSet);
@@ -295,9 +292,6 @@ u8 rtw_hal_get_def_var(struct adapter *padapter,
 void rtw_hal_set_odm_var(struct adapter *padapter,
 			 enum hal_odm_variable eVariable, void *pValue1,
 			 bool bSet);
-void rtw_hal_get_odm_var(struct adapter *padapter,
-			 enum hal_odm_variable eVariable,
-			 void *pValue1, bool bSet);
 
 void rtw_hal_enable_interrupt(struct adapter *padapter);
 void rtw_hal_disable_interrupt(struct adapter *padapter);
-- 
1.7.10.4

