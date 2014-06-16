Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaFPQGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:06:54 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39787 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbaFPQGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:06:52 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 5/9] staging: rtl8188eu: Remove function nat25_db_expire()
Date: Mon, 16 Jun 2014 21:35:42 +0530
Message-Id: <1402934746-29422-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
References: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've removed the code which was responsible for building NAT table,
so no use of keeping nat_db_expire().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_mlme.c      |   11 -----------
 drivers/staging/rtl8188eu/include/usb_osintf.h |    1 -
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index e0e119c..e73a784 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1516,7 +1516,6 @@ static void rtw_auto_scan_handler(struct adapter *padapter)
 
 void rtw_dynamic_check_timer_handlder(struct adapter *adapter)
 {
-	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
 	struct registry_priv *pregistrypriv = &adapter->registrypriv;
 
 	if (!adapter)
@@ -1539,16 +1538,6 @@ void rtw_dynamic_check_timer_handlder(struct adapter *adapter)
 			rtw_auto_scan_handler(adapter);
 		}
 	}
-
-	rcu_read_lock();
-
-	if (rcu_dereference(adapter->pnetdev->rx_handler_data) &&
-	    (check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_ADHOC_STATE) == true)) {
-		/*  expire NAT2.5 entry */
-		nat25_db_expire(adapter);
-	}
-
-	rcu_read_unlock();
 }
 
 #define RTW_SCAN_RESULT_EXPIRE 2000
diff --git a/drivers/staging/rtl8188eu/include/usb_osintf.h b/drivers/staging/rtl8188eu/include/usb_osintf.h
index 8036c38..484411f 100644
--- a/drivers/staging/rtl8188eu/include/usb_osintf.h
+++ b/drivers/staging/rtl8188eu/include/usb_osintf.h
@@ -33,7 +33,6 @@ void netdev_br_init(struct net_device *netdev);
 void dhcp_flag_bcast(struct adapter *priv, struct sk_buff *skb);
 void *scdb_findEntry(struct adapter *priv, unsigned char *macAddr,
 		     unsigned char *ipAddr);
-void nat25_db_expire(struct adapter *priv);
 
 int rtw_resume_process(struct adapter *padapter);
 
-- 
1.7.10.4

