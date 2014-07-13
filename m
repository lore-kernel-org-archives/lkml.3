Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaGMOaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:30:19 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38395 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaGMOaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:30:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/16] staging: rtl8188eu: Remove function rtw_set_channel_plan()
Date: Sun, 13 Jul 2014 19:59:24 +0530
Message-Id: <1405261778-7653-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |   15 +--------------
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |    1 -
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 39932cb..5eb21cd 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -1092,19 +1092,6 @@ int rtw_set_scan_mode(struct adapter *adapter, enum rt_scan_type scan_mode)
 }
 
 /*
-* rtw_set_channel_plan -
-* @adapter: pointer to struct adapter structure
-* @channel_plan:
-*
-* Return _SUCCESS or _FAIL
-*/
-int rtw_set_channel_plan(struct adapter *adapter, u8 channel_plan)
-{
-	/* handle by cmd_thread to sync with scan operation */
-	return rtw_set_chplan_cmd(adapter, channel_plan, 1);
-}
-
-/*
 * rtw_set_country -
 * @adapter: pointer to struct adapter structure
 * @country_code: string of country code
@@ -1130,5 +1117,5 @@ int rtw_set_country(struct adapter *adapter, const char *country_code)
 	else
 		DBG_88E("%s unknown country_code:%s\n", __func__, country_code);
 
-	return rtw_set_channel_plan(adapter, channel_plan);
+	return rtw_set_chplan_cmd(adapter, channel_plan, 1);
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
index 005ec17..7335147 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -43,7 +43,6 @@ u8 rtw_set_802_11_remove_key(struct adapter *adapt,
 u8 rtw_validate_ssid(struct ndis_802_11_ssid *ssid);
 u16 rtw_get_cur_max_rate(struct adapter *adapter);
 int rtw_set_scan_mode(struct adapter *adapter, enum rt_scan_type scan_mode);
-int rtw_set_channel_plan(struct adapter *adapter, u8 channel_plan);
 int rtw_set_country(struct adapter *adapter, const char *country_code);
 
 #endif
-- 
1.7.10.4

