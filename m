Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaFVIh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:37:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40935 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaFVIhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:37:53 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 24/42] staging: rtl8188eu: Replace _cancel_workitem_sync() with cancel_work_sync()
Date: Sun, 22 Jun 2014 14:06:30 +0530
Message-Id: <1403426208-12413-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    2 +-
 drivers/staging/rtl8188eu/core/rtw_led.c          |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    5 -----
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 8d36e2c..a292c5d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -96,7 +96,7 @@ void rtw_free_evt_priv(struct evt_priv *pevtpriv)
 
 	RT_TRACE(_module_rtl871x_cmd_c_, _drv_info_, ("+rtw_free_evt_priv\n"));
 
-	_cancel_workitem_sync(&pevtpriv->c2h_wk);
+	cancel_work_sync(&pevtpriv->c2h_wk);
 	while (pevtpriv->c2h_wk_alive)
 		msleep(10);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_led.c b/drivers/staging/rtl8188eu/core/rtw_led.c
index 87d6f06..a266f34 100644
--- a/drivers/staging/rtl8188eu/core/rtw_led.c
+++ b/drivers/staging/rtl8188eu/core/rtw_led.c
@@ -88,7 +88,7 @@ void InitLed871x(struct adapter *padapter, struct LED_871x *pLed)
 /*  */
 void DeInitLed871x(struct LED_871x *pLed)
 {
-	_cancel_workitem_sync(&(pLed->BlinkWorkItem));
+	cancel_work_sync(&(pLed->BlinkWorkItem));
 	_cancel_timer_ex(&(pLed->BlinkTimer));
 	ResetLedStatus(pLed);
 }
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index a55b786..bc1ffd4 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -101,11 +101,6 @@ static inline void _cancel_timer(struct timer_list *ptimer, u8 *bcancelled)
 #define RTW_DECLARE_TIMER_HDL(name) \
 	void RTW_TIMER_HDL_NAME(name)(RTW_TIMER_HDL_ARGS)
 
-static inline void _cancel_workitem_sync(struct work_struct *pwork)
-{
-	cancel_work_sync(pwork);
-}
-
 static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
 {
 	return  netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 0)) &&
-- 
1.7.10.4

