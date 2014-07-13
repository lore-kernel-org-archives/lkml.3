Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaGMOb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:31:27 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58522 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaGMObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:31:03 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/16] staging: rtl8188eu: Remove unused function rtw_set_802_11_remove_wep()
Date: Sun, 13 Jul 2014 19:59:29 +0530
Message-Id: <1405261778-7653-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |   25 ---------------------
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |    1 -
 2 files changed, 26 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index f4116d1..fc280ce5 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -566,31 +566,6 @@ exit:
 	return ret;
 }
 
-u8 rtw_set_802_11_remove_wep(struct adapter *padapter, u32 keyindex)
-{
-	u8 ret = _SUCCESS;
-
-	if (keyindex >= 0x80000000 || padapter == NULL) {
-		ret = false;
-		goto exit;
-	} else {
-		int res;
-		struct security_priv *psecuritypriv = &(padapter->securitypriv);
-		if (keyindex < 4) {
-			memset(&psecuritypriv->dot11DefKey[keyindex], 0, 16);
-			res = rtw_set_key(padapter, psecuritypriv, keyindex, 0);
-			psecuritypriv->dot11DefKeylen[keyindex] = 0;
-			if (res == _FAIL)
-				ret = _FAIL;
-		} else {
-			ret = _FAIL;
-		}
-	}
-exit:
-
-	return ret;
-}
-
 /*
 * rtw_get_cur_max_rate -
 * @adapter: pointer to struct adapter structure
diff --git a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
index a325326..fa9d655 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -35,7 +35,6 @@ u8 rtw_set_802_11_bssid_list_scan(struct adapter *adapter,
 				  int ssid_max_num);
 u8 rtw_set_802_11_infrastructure_mode(struct adapter *adapter,
 				      enum ndis_802_11_network_infra type);
-u8 rtw_set_802_11_remove_wep(struct adapter *adapter, u32 keyindex);
 u8 rtw_set_802_11_ssid(struct adapter *adapt, struct ndis_802_11_ssid *ssid);
 u16 rtw_get_cur_max_rate(struct adapter *adapter);
 int rtw_set_country(struct adapter *adapter, const char *country_code);
-- 
1.7.10.4

