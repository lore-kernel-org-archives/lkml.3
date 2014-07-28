Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaG1Rmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:42:43 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56052 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaG1Rmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:42:39 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 6/9] staging: rtl8188eu: Remove wrapper function _link_timer_hdl()
Date: Mon, 28 Jul 2014 23:11:27 +0530
Message-Id: <1406569290-19943-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
References: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |    3 ++-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h |    2 +-
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c    |    8 +-------
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index b113f0b..f18bb78 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -4873,8 +4873,9 @@ exit_survey_timer_hdl:
 	return;
 }
 
-void link_timer_hdl(struct adapter *padapter)
+void link_timer_hdl(void *function_context)
 {
+	struct adapter *padapter = (struct adapter *)function_context;
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index a948d45..05a010f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -647,7 +647,7 @@ void mlmeext_sta_add_event_callback(struct adapter *padapter,
 void linked_status_chk(struct adapter *padapter);
 
 void survey_timer_hdl (void *function_context);
-void link_timer_hdl (struct adapter *padapter);
+void link_timer_hdl (void *funtion_context);
 void addba_timer_hdl(struct sta_info *psta);
 
 #define set_survey_timer(mlmeext, ms) \
diff --git a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
index f59e130..4f5fa08 100644
--- a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
@@ -129,12 +129,6 @@ void rtw_report_sec_ie(struct adapter *adapter, u8 authmode, u8 *sec_ie)
 	}
 }
 
-static void _link_timer_hdl(void *FunctionContext)
-{
-	struct adapter *padapter = (struct adapter *)FunctionContext;
-	link_timer_hdl(padapter);
-}
-
 static void _addba_timer_hdl(void *FunctionContext)
 {
 	struct sta_info *psta = (struct sta_info *)FunctionContext;
@@ -151,7 +145,7 @@ void init_mlme_ext_timer(struct adapter *padapter)
 	struct	mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 
 	_init_timer(&pmlmeext->survey_timer, padapter->pnetdev, survey_timer_hdl, padapter);
-	_init_timer(&pmlmeext->link_timer, padapter->pnetdev, _link_timer_hdl, padapter);
+	_init_timer(&pmlmeext->link_timer, padapter->pnetdev, link_timer_hdl, padapter);
 }
 
 #ifdef CONFIG_88EU_AP_MODE
-- 
1.7.10.4

