Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaGMObG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:31:06 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63268 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbaGMOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:30:54 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/16] staging: rtl8188eu: Remove unused function rtw_set_802_11_remove_key()
Date: Sun, 13 Jul 2014 19:59:28 +0530
Message-Id: <1405261778-7653-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |   38 ---------------------
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |    2 --
 2 files changed, 40 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 8c107f8..f4116d1 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -591,44 +591,6 @@ exit:
 	return ret;
 }
 
-u8 rtw_set_802_11_remove_key(struct adapter *padapter, struct ndis_802_11_remove_key *key)
-{
-	u8 *pbssid;
-	struct sta_info *stainfo;
-	u8	bgroup = (key->KeyIndex & 0x4000000) > 0 ? false : true;
-	u8	keyIndex = (u8)key->KeyIndex & 0x03;
-	u8	ret = _SUCCESS;
-
-
-	if ((key->KeyIndex & 0xbffffffc) > 0) {
-		ret = _FAIL;
-		goto exit;
-	}
-
-	if (bgroup) {
-		/*  clear group key by index */
-
-		memset(&padapter->securitypriv.dot118021XGrpKey[keyIndex], 0, 16);
-
-		/*  \todo Send a H2C Command to Firmware for removing this Key in CAM Entry. */
-	} else {
-		pbssid = get_bssid(&padapter->mlmepriv);
-		stainfo = rtw_get_stainfo(&padapter->stapriv, pbssid);
-		if (stainfo) {
-			/*  clear key by BSSID */
-			memset(&stainfo->dot118021x_UncstKey, 0, 16);
-
-			/*  \todo Send a H2C Command to Firmware for disable this Key in CAM Entry. */
-		} else {
-			ret = _FAIL;
-			goto exit;
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
index 9ec6456..a325326 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -37,8 +37,6 @@ u8 rtw_set_802_11_infrastructure_mode(struct adapter *adapter,
 				      enum ndis_802_11_network_infra type);
 u8 rtw_set_802_11_remove_wep(struct adapter *adapter, u32 keyindex);
 u8 rtw_set_802_11_ssid(struct adapter *adapt, struct ndis_802_11_ssid *ssid);
-u8 rtw_set_802_11_remove_key(struct adapter *adapt,
-			     struct ndis_802_11_remove_key *key);
 u16 rtw_get_cur_max_rate(struct adapter *adapter);
 int rtw_set_country(struct adapter *adapter, const char *country_code);
 
-- 
1.7.10.4

