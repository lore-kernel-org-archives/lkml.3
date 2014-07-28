Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaG1RnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:43:02 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57411 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaG1Rm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:42:56 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 8/9] staging: rtl81888eu: Remove unused function rtw_os_read_port()
Date: Mon, 28 Jul 2014 23:11:29 +0530
Message-Id: <1406569290-19943-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
References: <1406569290-19943-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/recv_osdep.h |    2 --
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |   12 ------------
 2 files changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/recv_osdep.h b/drivers/staging/rtl8188eu/include/recv_osdep.h
index a52a696..5aabd39 100644
--- a/drivers/staging/rtl8188eu/include/recv_osdep.h
+++ b/drivers/staging/rtl8188eu/include/recv_osdep.h
@@ -43,8 +43,6 @@ int rtw_os_recv_resource_alloc(struct adapter *adapt,
 
 int rtw_os_recvbuf_resource_alloc(struct adapter *adapt, struct recv_buf *buf);
 
-void rtw_os_read_port(struct adapter *padapter, struct recv_buf *precvbuf);
-
 void rtw_init_recv_timer(struct recv_reorder_ctrl *preorder_ctrl);
 int _netdev_open(struct net_device *pnetdev);
 int netdev_open(struct net_device *pnetdev);
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index f8ac996..f7d53dd 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -191,18 +191,6 @@ _recv_indicatepkt_drop:
 	 return _FAIL;
 }
 
-void rtw_os_read_port(struct adapter *padapter, struct recv_buf *precvbuf)
-{
-	struct recv_priv *precvpriv = &padapter->recvpriv;
-
-	/* free skb in recv_buf */
-	dev_kfree_skb_any(precvbuf->pskb);
-	precvbuf->pskb = NULL;
-	precvbuf->reuse = false;
-	usb_read_port(padapter, precvpriv->ff_hwaddr, 0,
-			(unsigned char *)precvbuf);
-}
-
 static void _rtw_reordering_ctrl_timeout_handler(void *func_context)
 {
 	struct recv_reorder_ctrl *preorder_ctrl;
-- 
1.7.10.4

