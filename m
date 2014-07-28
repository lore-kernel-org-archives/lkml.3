Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaG1Rmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:42:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54349 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaG1Rmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:42:47 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 7/9] staging: rtl8188eu: Remove wrapper function _addba_timer_hdl()
Date: Mon, 28 Jul 2014 23:11:28 +0530
Message-Id: <1406569290-19943-7-git-send-email-navin.patidar@gmail.com>
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
index f18bb78..5ba5099 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -4910,8 +4910,9 @@ void link_timer_hdl(void *function_context)
 	return;
 }
 
-void addba_timer_hdl(struct sta_info *psta)
+void addba_timer_hdl(void *function_context)
 {
+	struct sta_info *psta = (struct sta_info *)function_context;
 	struct ht_priv	*phtpriv;
 
 	if (!psta)
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 05a010f..d699ca1 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -648,7 +648,7 @@ void linked_status_chk(struct adapter *padapter);
 
 void survey_timer_hdl (void *function_context);
 void link_timer_hdl (void *funtion_context);
-void addba_timer_hdl(struct sta_info *psta);
+void addba_timer_hdl(void *function_context);
 
 #define set_survey_timer(mlmeext, ms) \
 	do { \
diff --git a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
index 4f5fa08..1b892c4 100644
--- a/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/mlme_linux.c
@@ -129,15 +129,9 @@ void rtw_report_sec_ie(struct adapter *adapter, u8 authmode, u8 *sec_ie)
 	}
 }
 
-static void _addba_timer_hdl(void *FunctionContext)
-{
-	struct sta_info *psta = (struct sta_info *)FunctionContext;
-	addba_timer_hdl(psta);
-}
-
 void init_addba_retry_timer(struct adapter *padapter, struct sta_info *psta)
 {
-	_init_timer(&psta->addba_retry_timer, padapter->pnetdev, _addba_timer_hdl, psta);
+	_init_timer(&psta->addba_retry_timer, padapter->pnetdev, addba_timer_hdl, psta);
 }
 
 void init_mlme_ext_timer(struct adapter *padapter)
-- 
1.7.10.4

