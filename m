Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbaFAMU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:20:29 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64618 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaFAMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:20:23 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 24/26] staging: rtl8188eu: Remove bCardDisableWOHSM from struct adapter
Date: Sun,  1 Jun 2014 17:46:50 +0530
Message-Id: <1401625013-11208-24-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver doesn't use value stored in bCardDisableWOHSM.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c  |    1 -
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c   |    4 ----
 3 files changed, 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index b8d66fa..599f2b6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -160,7 +160,6 @@ void rtw_ps_processor(struct adapter *padapter)
 			if (rfpwrstate == rf_off) {
 				pwrpriv->change_rfpwrstate = rf_off;
 				pwrpriv->brfoffbyhw = true;
-				padapter->bCardDisableWOHSM = true;
 				rtw_hw_suspend(padapter);
 			} else {
 				pwrpriv->change_rfpwrstate = rf_on;
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 1676bb4..974f12f 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -218,7 +218,6 @@ struct adapter {
 
 	s32	bDriverStopped;
 	s32	bSurpriseRemoved;
-	s32	bCardDisableWOHSM;
 
 	u8	hw_init_completed;
 
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 2df27c7..1d961bd 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -1042,7 +1042,6 @@ int _netdev_open(struct net_device *pnetdev)
 	if (!padapter->bup) {
 		padapter->bDriverStopped = false;
 		padapter->bSurpriseRemoved = false;
-		padapter->bCardDisableWOHSM = false;
 
 		status = rtw_hal_init(padapter);
 		if (status == _FAIL) {
@@ -1117,7 +1116,6 @@ static int  ips_netdrv_open(struct adapter *padapter)
 
 	padapter->bDriverStopped = false;
 	padapter->bSurpriseRemoved = false;
-	padapter->bCardDisableWOHSM = false;
 
 	status = rtw_hal_init(padapter);
 	if (status == _FAIL) {
@@ -1160,13 +1158,11 @@ void rtw_ips_pwr_down(struct adapter *padapter)
 	u32 start_time = jiffies;
 	DBG_88E("===> rtw_ips_pwr_down...................\n");
 
-	padapter->bCardDisableWOHSM = true;
 	padapter->net_closed = true;
 
 	rtw_led_control(padapter, LED_CTL_POWER_OFF);
 
 	rtw_ips_dev_unload(padapter);
-	padapter->bCardDisableWOHSM = false;
 	DBG_88E("<=== rtw_ips_pwr_down..................... in %dms\n", rtw_get_passing_time_ms(start_time));
 }
 
-- 
1.7.10.4

