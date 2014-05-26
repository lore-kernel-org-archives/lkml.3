Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaEZQGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:06:45 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49825 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaEZQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:06:42 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/24] staging: rtl8188eu: Remove function rtw_hal_dm_deinit()
Date: Mon, 26 May 2014 21:35:23 +0530
Message-Id: <1401120339-23667-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_hal_dm_deinit() calls rtl8188e_deinit_dm_priv() using funtion pointer.
rtl8188e_deinit_dm_priv() has empty defination, so we can remove
rtw_hal_dm_deinit() and later rtl8188e_deinit_dm_priv() also will be
removed.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/hal_intf.c     |    7 -------
 drivers/staging/rtl8188eu/include/hal_intf.h |    1 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c  |    2 --
 3 files changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/hal_intf.c b/drivers/staging/rtl8188eu/hal/hal_intf.c
index 43eee48..d0ac4a1 100644
--- a/drivers/staging/rtl8188eu/hal/hal_intf.c
+++ b/drivers/staging/rtl8188eu/hal/hal_intf.c
@@ -60,13 +60,6 @@ void rtw_hal_dm_init(struct adapter *adapt)
 		adapt->HalFunc.dm_init(adapt);
 }
 
-void rtw_hal_dm_deinit(struct adapter *adapt)
-{
-	/*  cancel dm  timer */
-	if (adapt->HalFunc.dm_deinit)
-		adapt->HalFunc.dm_deinit(adapt);
-}
-
 void rtw_hal_sw_led_init(struct adapter *adapt)
 {
 	if (adapt->HalFunc.InitSwLeds)
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index acdef1d..a8f25c9 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -296,7 +296,6 @@ void rtw_hal_def_value_init(struct adapter *padapter);
 void	rtw_hal_free_data(struct adapter *padapter);
 
 void rtw_hal_dm_init(struct adapter *padapter);
-void rtw_hal_dm_deinit(struct adapter *padapter);
 void rtw_hal_sw_led_init(struct adapter *padapter);
 void rtw_hal_sw_led_deinit(struct adapter *padapter);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 9edb8e8..c1368b8 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -951,8 +951,6 @@ void rtw_cancel_all_timer(struct adapter *padapter)
 	_cancel_timer_ex(&padapter->pwrctrlpriv.pwr_state_check_timer);
 
 	_cancel_timer_ex(&padapter->recvpriv.signal_stat_timer);
-	/* cancel dm timer */
-	rtw_hal_dm_deinit(padapter);
 }
 
 u8 rtw_free_drv_sw(struct adapter *padapter)
-- 
1.7.10.4

