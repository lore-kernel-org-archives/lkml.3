Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaE0Pi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:38:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44328 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaE0Php (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:45 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/15] staging: rtl8188eu:Remove inline function rtw_netif_stop_queue()
Date: Tue, 27 May 2014 21:05:53 +0530
Message-Id: <1401204955-4093-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    5 -----
 drivers/staging/rtl8188eu/os_dep/os_intfs.c       |    4 ++--
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |    4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index e82ba63..9d32bb2 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -119,11 +119,6 @@ static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
 		netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 3));
 }
 
-static inline void rtw_netif_stop_queue(struct net_device *pnetdev)
-{
-	netif_tx_stop_all_queues(pnetdev);
-}
-
 #ifndef BIT
 	#define BIT(x)	(1 << (x))
 #endif
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index e6596d5..0e0c32d 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -1096,7 +1096,7 @@ netdev_open_normal_process:
 netdev_open_error:
 	padapter->bup = false;
 	netif_carrier_off(pnetdev);
-	rtw_netif_stop_queue(pnetdev);
+	netif_tx_stop_all_queues(pnetdev);
 	RT_TRACE(_module_os_intfs_c_, _drv_err_, ("-88eu_drv - dev_open, fail!\n"));
 	DBG_88E("-88eu_drv - drv_open fail, bup =%d\n", padapter->bup);
 	return -1;
@@ -1219,7 +1219,7 @@ int netdev_close(struct net_device *pnetdev)
 		/* s1. */
 		if (pnetdev) {
 			if (!rtw_netif_queue_stopped(pnetdev))
-				rtw_netif_stop_queue(pnetdev);
+				netif_tx_stop_all_queues(pnetdev);
 		}
 
 		/* s2. */
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 7b1c774..7526b98 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -307,7 +307,7 @@ int rtw_hw_suspend(struct adapter *padapter)
 	/* s1. */
 	if (pnetdev) {
 		netif_carrier_off(pnetdev);
-		rtw_netif_stop_queue(pnetdev);
+		netif_tx_stop_all_queues(pnetdev);
 	}
 
 	/* s2. */
@@ -416,7 +416,7 @@ static int rtw_suspend(struct usb_interface *pusb_intf, pm_message_t message)
 	/* s1. */
 	if (pnetdev) {
 		netif_carrier_off(pnetdev);
-		rtw_netif_stop_queue(pnetdev);
+		netif_tx_stop_all_queues(pnetdev);
 	}
 
 	/* s2. */
-- 
1.7.10.4

