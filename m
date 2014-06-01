Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbaFAMUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:20:20 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64243 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaFAMUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:20:16 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 23/26] staging: rtl8188eu: Remove pbuddy_adapter from struct adapter
Date: Sun,  1 Jun 2014 17:46:49 +0530
Message-Id: <1401625013-11208-23-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
References: <1401625013-11208-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c  |   19 -------------------
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c   |    4 ----
 3 files changed, 24 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index 739e250..b8d66fa 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -114,7 +114,6 @@ int ips_leave(struct adapter *padapter)
 
 static bool rtw_pwr_unassociated_idle(struct adapter *adapter)
 {
-	struct adapter *buddy = adapter->pbuddy_adapter;
 	struct mlme_priv *pmlmepriv = &(adapter->mlmepriv);
 #ifdef CONFIG_88EU_P2P
 	struct wifidirect_info	*pwdinfo = &(adapter->wdinfo);
@@ -136,24 +135,6 @@ static bool rtw_pwr_unassociated_idle(struct adapter *adapter)
 #endif
 		goto exit;
 
-	/* consider buddy, if exist */
-	if (buddy) {
-		struct mlme_priv *b_pmlmepriv = &(buddy->mlmepriv);
-		#ifdef CONFIG_88EU_P2P
-		struct wifidirect_info *b_pwdinfo = &(buddy->wdinfo);
-		#endif
-
-		if (check_fwstate(b_pmlmepriv, WIFI_ASOC_STATE|WIFI_SITE_MONITOR) ||
-		    check_fwstate(b_pmlmepriv, WIFI_UNDER_LINKING|WIFI_UNDER_WPS) ||
-		    check_fwstate(b_pmlmepriv, WIFI_AP_STATE) ||
-		    check_fwstate(b_pmlmepriv, WIFI_ADHOC_MASTER_STATE|WIFI_ADHOC_STATE) ||
-#if defined(CONFIG_88EU_P2P)
-		    !rtw_p2p_chk_state(b_pwdinfo, P2P_STATE_NONE))
-#else
-		    0)
-#endif
-			goto exit;
-	}
 	ret = true;
 
 exit:
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index ec9ad4a..1676bb4 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -254,7 +254,6 @@ struct adapter {
 	 * upper application reads it. */
 	u8 bShowGetP2PState;
 #endif
-	struct adapter *pbuddy_adapter;
 
 	struct mutex hw_init_mutex;
 
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index c9906e3..2df27c7 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -993,10 +993,6 @@ u8 rtw_free_drv_sw(struct adapter *padapter)
 		padapter->rereg_nd_name_priv.old_pnetdev = NULL;
 	}
 
-	/*  clear pbuddystruct adapter to avoid access wrong pointer. */
-	if (padapter->pbuddy_adapter != NULL)
-		padapter->pbuddy_adapter->pbuddy_adapter = NULL;
-
 	mutex_destroy(&padapter->hw_init_mutex);
 
 	RT_TRACE(_module_os_intfs_c_, _drv_info_, ("-rtw_free_drv_sw\n"));
-- 
1.7.10.4

