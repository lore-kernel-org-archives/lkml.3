Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaFPQGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:06:46 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38892 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaFPQGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:06:43 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 4/9] staging: rtl8188eu: Remove pppoe_connection_in_progress from struct adapter
Date: Mon, 16 Jun 2014 21:35:41 +0530
Message-Id: <1402934746-29422-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
References: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Value stored in pppoe_connection_in_progress isn't being
used by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c     |    7 -------
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 260243b..e0e119c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1546,13 +1546,6 @@ void rtw_dynamic_check_timer_handlder(struct adapter *adapter)
 	    (check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_ADHOC_STATE) == true)) {
 		/*  expire NAT2.5 entry */
 		nat25_db_expire(adapter);
-
-		if (adapter->pppoe_connection_in_progress > 0)
-			adapter->pppoe_connection_in_progress--;
-
-		/*  due to rtw_dynamic_check_timer_handlder() is called every 2 seconds */
-		if (adapter->pppoe_connection_in_progress > 0)
-			adapter->pppoe_connection_in_progress--;
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 9c3f905..71b4af7 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -256,7 +256,6 @@ struct adapter {
 
 	spinlock_t br_ext_lock;
 	struct nat25_network_db_entry	*nethash[NAT25_HASH_SIZE];
-	int				pppoe_connection_in_progress;
 	unsigned char			pppoe_addr[MACADDRLEN];
 	unsigned char			scdb_mac[MACADDRLEN];
 	unsigned char			scdb_ip[4];
-- 
1.7.10.4

