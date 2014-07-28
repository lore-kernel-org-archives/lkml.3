Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaG1RmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:42:20 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55124 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaG1RmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:42:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 3/9] staging: rtl8188eu: Remove wrapper function _rtw_scan_timeout_handler()
Date: Mon, 28 Jul 2014 23:11:24 +0530
Message-Id: <1406569290-19943-3-git-send-email-navin.patidar@gmail.com>
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
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c |    9 +--------
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index f63f1c2..d5b2f51 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1404,8 +1404,9 @@ void _rtw_join_timeout_handler (void *function_context)
 * rtw_scan_timeout_handler - Timeout/Faliure handler for CMD SiteSurvey
 * @adapter: pointer to struct adapter structure
 */
-void rtw_scan_timeout_handler (struct adapter *adapter)
+void rtw_scan_timeout_handler (void *function_context)
 {
+	struct adapter *adapter = (struct adapter *)function_context;
 	struct	mlme_priv *pmlmepriv = &adapter->mlmepriv;
 
 	DBG_88E(FUNC_ADPT_FMT" fw_state=%x\n", FUNC_ADPT_ARG(adapter), get_fwstate(pmlmepriv));
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 40b0c4b..8f5457b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -436,7 +436,6 @@ void indicate_wx_scan_complete_event(struct adapter *padapter);
 void rtw_indicate_wx_assoc_event(struct adapter *padapter);
 void rtw_indicate_wx_disassoc_event(struct adapter *padapter);
 int event_thread(void *context);
-void _rtw_scan_timeout_handler(void *FunctionContext);
 void rtw_free_network_queue(struct adapter *adapter, u8 isfreeall);
 int rtw_init_mlme_priv(struct adapter *adapter);
 void rtw_free_mlme_priv(struct mlme_priv *pmlmepriv);
@@ -553,7 +552,7 @@ void rtw_update_registrypriv_dev_network(struct adapter *adapter);
 void rtw_get_encrypt_decrypt_from_registrypriv(struct adapter *adapter);
 
 void _rtw_join_timeout_handler(void *function_context);
-void rtw_scan_timeout_handler(struct adapter *adapter);
+void rtw_scan_timeout_handler(void *function_context);
 
 void rtw_dynamic_check_timer_handlder(struct adapter *adapter);
 #define rtw_is_scan_deny(adapter) false
diff --git a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
index 41d2459..0bfaa78 100644
--- a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
@@ -25,13 +25,6 @@
 #include <drv_types.h>
 #include <mlme_osdep.h>
 
-void _rtw_scan_timeout_handler (void *FunctionContext)
-{
-	struct adapter *adapter = (struct adapter *)FunctionContext;
-
-	rtw_scan_timeout_handler(adapter);
-}
-
 static void _dynamic_check_timer_handlder(void *FunctionContext)
 {
 	struct adapter *adapter = (struct adapter *)FunctionContext;
@@ -47,7 +40,7 @@ void rtw_init_mlme_timer(struct adapter *padapter)
 	struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
 
 	_init_timer(&(pmlmepriv->assoc_timer), padapter->pnetdev, _rtw_join_timeout_handler, padapter);
-	_init_timer(&(pmlmepriv->scan_to_timer), padapter->pnetdev, _rtw_scan_timeout_handler, padapter);
+	_init_timer(&(pmlmepriv->scan_to_timer), padapter->pnetdev, rtw_scan_timeout_handler, padapter);
 	_init_timer(&(pmlmepriv->dynamic_chk_timer), padapter->pnetdev, _dynamic_check_timer_handlder, padapter);
 }
 
-- 
1.7.10.4

