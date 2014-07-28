Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaG1RmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:42:13 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44628 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaG1RmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:42:05 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 2/9] staging: rtl8188eu: Remove wrapper function rtw_join_timeout_handler()
Date: Mon, 28 Jul 2014 23:11:23 +0530
Message-Id: <1406569290-19943-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
References: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c     |    3 ++-
 drivers/staging/rtl8188eu/include/rtw_mlme.h  |    3 +--
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c |   10 +---------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index c15fab2..f63f1c2 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1362,8 +1362,9 @@ void rtw_cpwm_event_callback(struct adapter *padapter, u8 *pbuf)
 * _rtw_join_timeout_handler - Timeout/faliure handler for CMD JoinBss
 * @adapter: pointer to struct adapter structure
 */
-void _rtw_join_timeout_handler (struct adapter *adapter)
+void _rtw_join_timeout_handler (void *function_context)
 {
+	struct adapter *adapter = (struct adapter *)function_context;
 	struct	mlme_priv *pmlmepriv = &adapter->mlmepriv;
 	int do_join_r;
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 5b1fcd2..40b0c4b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -436,7 +436,6 @@ void indicate_wx_scan_complete_event(struct adapter *padapter);
 void rtw_indicate_wx_assoc_event(struct adapter *padapter);
 void rtw_indicate_wx_disassoc_event(struct adapter *padapter);
 int event_thread(void *context);
-void rtw_join_timeout_handler(void *FunctionContext);
 void _rtw_scan_timeout_handler(void *FunctionContext);
 void rtw_free_network_queue(struct adapter *adapter, u8 isfreeall);
 int rtw_init_mlme_priv(struct adapter *adapter);
@@ -553,7 +552,7 @@ void rtw_update_registrypriv_dev_network(struct adapter *adapter);
 
 void rtw_get_encrypt_decrypt_from_registrypriv(struct adapter *adapter);
 
-void _rtw_join_timeout_handler(struct adapter *adapter);
+void _rtw_join_timeout_handler(void *function_context);
 void rtw_scan_timeout_handler(struct adapter *adapter);
 
 void rtw_dynamic_check_timer_handlder(struct adapter *adapter);
diff --git a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
index 737677c..41d2459 100644
--- a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
@@ -25,14 +25,6 @@
 #include <drv_types.h>
 #include <mlme_osdep.h>
 
-void rtw_join_timeout_handler (void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-
-	_rtw_join_timeout_handler(adapter);
-}
-
-
 void _rtw_scan_timeout_handler (void *FunctionContext)
 {
 	struct adapter *adapter = (struct adapter *)FunctionContext;
@@ -54,7 +46,7 @@ void rtw_init_mlme_timer(struct adapter *padapter)
 {
 	struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
-	_init_timer(&(pmlmepriv->assoc_timer), padapter->pnetdev, rtw_join_timeout_handler, padapter);
+	_init_timer(&(pmlmepriv->assoc_timer), padapter->pnetdev, _rtw_join_timeout_handler, padapter);
 	_init_timer(&(pmlmepriv->scan_to_timer), padapter->pnetdev, _rtw_scan_timeout_handler, padapter);
 	_init_timer(&(pmlmepriv->dynamic_chk_timer), padapter->pnetdev, _dynamic_check_timer_handlder, padapter);
 }
-- 
1.7.10.4

