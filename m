Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaGMObp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:31:45 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42789 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaGMObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:31:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/16] staging: rtl8188eu: Rename _rtw_find_network() to rtw_find_network()
Date: Sun, 13 Jul 2014 19:59:33 +0530
Message-Id: <1405261778-7653-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
References: <1405261778-7653-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c    |   14 +-------------
 drivers/staging/rtl8188eu/include/rtw_mlme.h |    5 -----
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index b1e406e..fcd3f5a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -239,7 +239,7 @@ void _rtw_free_network_nolock(struct	mlme_priv *pmlmepriv, struct wlan_network *
 
 	Shall be calle under atomic context... to avoid possible racing condition...
 */
-struct wlan_network *_rtw_find_network(struct __queue *scanned_queue, u8 *addr)
+struct wlan_network *rtw_find_network(struct __queue *scanned_queue, u8 *addr)
 {
 	struct list_head *phead, *plist;
 	struct	wlan_network *pnetwork = NULL;
@@ -360,18 +360,6 @@ static void rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
 	_rtw_free_network_nolock(pmlmepriv, pnetwork);
 }
 
-/*
-	return the wlan_network with the matching addr
-
-	Shall be calle under atomic context... to avoid possible racing condition...
-*/
-struct	wlan_network *rtw_find_network(struct __queue *scanned_queue, u8 *addr)
-{
-	struct	wlan_network *pnetwork = _rtw_find_network(scanned_queue, addr);
-
-	return pnetwork;
-}
-
 int rtw_is_same_ibss(struct adapter *adapter, struct wlan_network *pnetwork)
 {
 	int ret = true;
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 56ef600..04d3b3d 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -581,16 +581,11 @@ void _rtw_free_network(struct mlme_priv *pmlmepriv,
 void _rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
 			      struct wlan_network *pnetwork);
 
-
-struct wlan_network *_rtw_find_network(struct __queue *scanned_queue, u8 *addr);
-
 int rtw_if_up(struct adapter *padapter);
 
-
 u8 *rtw_get_capability_from_ie(u8 *ie);
 u8 *rtw_get_beacon_interval_from_ie(u8 *ie);
 
-
 void rtw_joinbss_reset(struct adapter *padapter);
 
 unsigned int rtw_restructure_ht_ie(struct adapter *padapter, u8 *in_ie,
-- 
1.7.10.4

