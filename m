Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaE0Pht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:37:49 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:44750 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaE0Phi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:38 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/15] staging: rtl8188eu:Remove inline function rtw_netif_start_queue()
Date: Tue, 27 May 2014 21:05:52 +0530
Message-Id: <1401204955-4093-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    5 -----
 drivers/staging/rtl8188eu/os_dep/os_intfs.c       |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index e5012f3..e82ba63 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -119,11 +119,6 @@ static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
 		netif_tx_queue_stopped(netdev_get_tx_queue(pnetdev, 3));
 }
 
-static inline void rtw_netif_start_queue(struct net_device *pnetdev)
-{
-	netif_tx_start_all_queues(pnetdev);
-}
-
 static inline void rtw_netif_stop_queue(struct net_device *pnetdev)
 {
 	netif_tx_stop_all_queues(pnetdev);
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 93f9f25..e6596d5 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -1082,7 +1082,7 @@ int _netdev_open(struct net_device *pnetdev)
 	rtw_set_pwr_state_check_timer(&padapter->pwrctrlpriv);
 
 	if (!rtw_netif_queue_stopped(pnetdev))
-		rtw_netif_start_queue(pnetdev);
+		netif_tx_start_all_queues(pnetdev);
 	else
 		netif_tx_wake_all_queues(pnetdev);
 
-- 
1.7.10.4

