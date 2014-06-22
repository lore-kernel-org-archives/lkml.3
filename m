Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaFVIVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:21:38 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56791 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaFVIVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:21:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/42] staging: rtl8188eu: Remove dummy rtl8188e_start_thread() and its wrapper
Date: Sun, 22 Jun 2014 13:49:24 +0530
Message-Id: <1403425202-11942-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c          |    7 -------
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |    5 -----
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 --
 drivers/staging/rtl8188eu/os_dep/os_intfs.c       |    1 -
 4 files changed, 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index bcd9c4d..4506fd8 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -263,13 +263,6 @@ void rtw_hal_add_ra_tid(struct adapter *adapt, u32 bitmap, u8 arg,
 }
 
 /*	Start specifical interface thread		*/
-void rtw_hal_start_thread(struct adapter *adapt)
-{
-	if (adapt->HalFunc.run_thread)
-		adapt->HalFunc.run_thread(adapt);
-}
-
-/*	Start specifical interface thread		*/
 void rtw_hal_stop_thread(struct adapter *adapt)
 {
 	if (adapt->HalFunc.cancel_thread)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 9ce036e..f08696a 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -573,10 +573,6 @@ static void rtl8188e_SetHalODMVar(struct adapter *Adapter, enum hal_odm_variable
 	}
 }
 
-void rtl8188e_start_thread(struct adapter *padapter)
-{
-}
-
 void rtl8188e_stop_thread(struct adapter *padapter)
 {
 }
@@ -605,7 +601,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->hal_dm_watchdog = &rtl8188e_HalDmWatchDog;
 
 	pHalFunc->Add_RateATid = &rtl8188e_Add_RateATid;
-	pHalFunc->run_thread = &rtl8188e_start_thread;
 	pHalFunc->cancel_thread = &rtl8188e_stop_thread;
 
 	pHalFunc->AntDivBeforeLinkHandler = &AntDivBeforeLink8188E;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index 482d0f3f..d80dd72 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -207,7 +207,6 @@ struct hal_ops {
 
 	void	(*Add_RateATid)(struct adapter *adapter, u32 bitmap, u8 arg,
 				u8 rssi_level);
-	void	(*run_thread)(struct adapter *adapter);
 	void	(*cancel_thread)(struct adapter *adapter);
 
 	u8	(*AntDivBeforeLinkHandler)(struct adapter *adapter);
@@ -313,7 +312,6 @@ void rtw_hal_update_ra_mask(struct adapter *padapter, u32 mac_id, u8 level);
 void	rtw_hal_add_ra_tid(struct adapter *adapt, u32 bitmap, u8 arg, u8 level);
 void	rtw_hal_clone_data(struct adapter *dst_adapt,
 			   struct adapter *src_adapt);
-void	rtw_hal_start_thread(struct adapter *padapter);
 void	rtw_hal_stop_thread(struct adapter *padapter);
 
 void rtw_hal_bcn_related_reg_setting(struct adapter *padapter);
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index e19ec25..287126a 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -749,7 +749,6 @@ u32 rtw_start_drv_threads(struct adapter *padapter)
 	else
 		_rtw_down_sema(&padapter->cmdpriv.terminate_cmdthread_sema); /* wait for cmd_thread to run */
 
-	rtw_hal_start_thread(padapter);
 	return _status;
 }
 
-- 
1.7.10.4

