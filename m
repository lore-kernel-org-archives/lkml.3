Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaE0Pgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:36:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61257 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaE0Pg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:36:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/15] staging:rtl8188eu:Remove code specific to kernel version < 2.6.35
Date: Tue, 27 May 2014 21:05:42 +0530
Message-Id: <1401204955-4093-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
index 6089bae..9172380 100644
--- a/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/xmit_linux.c
@@ -113,7 +113,6 @@ void rtw_os_xmit_resource_free(struct adapter *padapter,
 
 void rtw_os_pkt_complete(struct adapter *padapter, struct sk_buff *pkt)
 {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 35))
 	u16	queue;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
@@ -126,10 +125,6 @@ void rtw_os_pkt_complete(struct adapter *padapter, struct sk_buff *pkt)
 		if (__netif_subqueue_stopped(padapter->pnetdev, queue))
 			netif_wake_subqueue(padapter->pnetdev, queue);
 	}
-#else
-	if (netif_queue_stopped(padapter->pnetdev))
-		netif_wake_queue(padapter->pnetdev);
-#endif
 
 	dev_kfree_skb_any(pkt);
 }
-- 
1.7.10.4

