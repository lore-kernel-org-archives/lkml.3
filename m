Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967AbaGBQzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:55:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54047 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946AbaGBQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:55:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 48/48] staging: rtl8188eu: Remove dummy function rtw_free_cmd_priv()
Date: Wed,  2 Jul 2014 22:17:44 +0530
Message-Id: <1404319664-8327-48-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |    5 -----
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    1 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c |    2 --
 3 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 0841de2..dd9ed74 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -39,11 +39,6 @@ int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 	return _SUCCESS;
 }
 
-void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
-{
-
-}
-
 /*
 Calling Context:
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index e59d6d4..9e9f5f4 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -68,7 +68,6 @@ void rtw_free_cmd_obj(struct cmd_obj *pcmd);
 int rtw_cmd_thread(void *context);
 
 int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv);
-void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv);
 
 enum rtw_drvextra_cmd_id {
 	NONE_WK_CID,
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index f331aae..b0c38a4 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -932,8 +932,6 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 
 	free_mlme_ext_priv(&padapter->mlmeextpriv);
 
-	rtw_free_cmd_priv(&padapter->cmdpriv);
-
 	rtw_free_mlme_priv(&padapter->mlmepriv);
 	_rtw_free_xmit_priv(&padapter->xmitpriv);
 
-- 
1.7.10.4

