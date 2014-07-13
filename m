Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaGMOak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:30:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60656 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaGMOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:30:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/16] staging: rtl8188eu: Remove unused function rtw_validate_ssid()
Date: Sun, 13 Jul 2014 19:59:26 +0530
Message-Id: <1405261778-7653-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |   26 ---------------------
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |    1 -
 2 files changed, 27 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 09d5bf4..95c6539 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -34,32 +34,6 @@ extern void indicate_wx_scan_complete_event(struct adapter *padapter);
 		(addr[4] == 0xff) && (addr[5] == 0xff))  ? true : false \
 )
 
-u8 rtw_validate_ssid(struct ndis_802_11_ssid *ssid)
-{
-	u8	 i;
-	u8	ret = true;
-
-
-	if (ssid->SsidLength > 32) {
-		RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("ssid length >32\n"));
-		ret = false;
-		goto exit;
-	}
-
-	for (i = 0; i < ssid->SsidLength; i++) {
-		/* wifi, printable ascii code must be supported */
-		if (!((ssid->Ssid[i] >= 0x20) && (ssid->Ssid[i] <= 0x7e))) {
-			RT_TRACE(_module_rtl871x_ioctl_set_c_, _drv_err_, ("ssid has nonprintabl ascii\n"));
-			ret = false;
-			break;
-		}
-	}
-
-exit:
-
-	return ret;
-}
-
 u8 rtw_do_join(struct adapter *padapter)
 {
 	struct list_head *plist, *phead;
diff --git a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
index 525abbd..11791cb 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -40,7 +40,6 @@ u8 rtw_set_802_11_remove_wep(struct adapter *adapter, u32 keyindex);
 u8 rtw_set_802_11_ssid(struct adapter *adapt, struct ndis_802_11_ssid *ssid);
 u8 rtw_set_802_11_remove_key(struct adapter *adapt,
 			     struct ndis_802_11_remove_key *key);
-u8 rtw_validate_ssid(struct ndis_802_11_ssid *ssid);
 u16 rtw_get_cur_max_rate(struct adapter *adapter);
 int rtw_set_country(struct adapter *adapter, const char *country_code);
 
-- 
1.7.10.4

