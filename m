Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaG1Rmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:42:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49146 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaG1Rmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:42:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 5/9] staging: rtl8188eu: Remove wrapper function _survey_timer_hdl()
Date: Mon, 28 Jul 2014 23:11:26 +0530
Message-Id: <1406569290-19943-5-git-send-email-navin.patidar@gmail.com>
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
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c    |    9 +--------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 41cfd30..b113f0b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -4833,8 +4833,9 @@ void linked_status_chk(struct adapter *padapter)
 	}
 }
 
-void survey_timer_hdl(struct adapter *padapter)
+void survey_timer_hdl(void *function_context)
 {
+	struct adapter *padapter = (struct adapter *)function_context;
 	struct cmd_obj	*ph2c;
 	struct sitesurvey_parm	*psurveyPara;
 	struct cmd_priv					*pcmdpriv = &padapter->cmdpriv;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 654bd36..a948d45 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -646,7 +646,7 @@ void mlmeext_sta_add_event_callback(struct adapter *padapter,
 
 void linked_status_chk(struct adapter *padapter);
 
-void survey_timer_hdl (struct adapter *padapter);
+void survey_timer_hdl (void *function_context);
 void link_timer_hdl (struct adapter *padapter);
 void addba_timer_hdl(struct sta_info *psta);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
index 82b71fa..f59e130 100644
--- a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
@@ -129,13 +129,6 @@ void rtw_report_sec_ie(struct adapter *adapter, u8 authmode, u8 *sec_ie)
 	}
 }
 
-static void _survey_timer_hdl(void *FunctionContext)
-{
-	struct adapter *padapter = (struct adapter *)FunctionContext;
-
-	survey_timer_hdl(padapter);
-}
-
 static void _link_timer_hdl(void *FunctionContext)
 {
 	struct adapter *padapter = (struct adapter *)FunctionContext;
@@ -157,7 +150,7 @@ void init_mlme_ext_timer(struct adapter *padapter)
 {
 	struct	mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 
-	_init_timer(&pmlmeext->survey_timer, padapter->pnetdev, _survey_timer_hdl, padapter);
+	_init_timer(&pmlmeext->survey_timer, padapter->pnetdev, survey_timer_hdl, padapter);
 	_init_timer(&pmlmeext->link_timer, padapter->pnetdev, _link_timer_hdl, padapter);
 }
 
-- 
1.7.10.4

