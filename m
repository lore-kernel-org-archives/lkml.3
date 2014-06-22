Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaFVIVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:21:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49739 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaFVIVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:21:42 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/42] staging: rtl8188eu: Remove dummy rtl8188e_stop_thread() and its wrapper
Date: Sun, 22 Jun 2014 13:49:25 +0530
Message-Id: <1403425202-11942-6-git-send-email-navin.patidar@gmail.com>
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
index 4506fd8..799c314 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -262,13 +262,6 @@ void rtw_hal_add_ra_tid(struct adapter *adapt, u32 bitmap, u8 arg,
 					       rssi_level);
 }
 
-/*	Start specifical interface thread		*/
-void rtw_hal_stop_thread(struct adapter *adapt)
-{
-	if (adapt->HalFunc.cancel_thread)
-		adapt->HalFunc.cancel_thread(adapt);
-}
-
 u32 rtw_hal_read_bbreg(struct adapter *adapt, u32 regaddr, u32 bitmask)
 {
 	u32 data = 0;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index f08696a..bee20a0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -573,10 +573,6 @@ static void rtl8188e_SetHalODMVar(struct adapter *Adapter, enum hal_odm_variable
 	}
 }
 
-void rtl8188e_stop_thread(struct adapter *padapter)
-{
-}
-
 static void hal_notch_filter_8188e(struct adapter *adapter, bool enable)
 {
 	if (enable) {
@@ -601,7 +597,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->hal_dm_watchdog = &rtl8188e_HalDmWatchDog;
 
 	pHalFunc->Add_RateATid = &rtl8188e_Add_RateATid;
-	pHalFunc->cancel_thread = &rtl8188e_stop_thread;
 
 	pHalFunc->AntDivBeforeLinkHandler = &AntDivBeforeLink8188E;
 	pHalFunc->AntDivCompareHandler = &AntDivCompare8188E;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index d80dd72..05e363e 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -207,7 +207,6 @@ struct hal_ops {
 
 	void	(*Add_RateATid)(struct adapter *adapter, u32 bitmap, u8 arg,
 				u8 rssi_level);
-	void	(*cancel_thread)(struct adapter *adapter);
 
 	u8	(*AntDivBeforeLinkHandler)(struct adapter *adapter);
 	void	(*AntDivCompareHandler)(struct adapter *adapter,
@@ -312,7 +311,6 @@ void rtw_hal_update_ra_mask(struct adapter *padapter, u32 mac_id, u8 level);
 void	rtw_hal_add_ra_tid(struct adapter *adapt, u32 bitmap, u8 arg, u8 level);
 void	rtw_hal_clone_data(struct adapter *dst_adapt,
 			   struct adapter *src_adapt);
-void	rtw_hal_stop_thread(struct adapter *padapter);
 
 void rtw_hal_bcn_related_reg_setting(struct adapter *padapter);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 287126a..19fd812 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -761,7 +761,6 @@ void rtw_stop_drv_threads(struct adapter *padapter)
 	if (padapter->cmdThread)
 		_rtw_down_sema(&padapter->cmdpriv.terminate_cmdthread_sema);
 
-	rtw_hal_stop_thread(padapter);
 }
 
 static u8 rtw_init_default_value(struct adapter *padapter)
-- 
1.7.10.4

