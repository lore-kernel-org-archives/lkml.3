Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaECLru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:47:50 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59836 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaECLrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:47:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/15] staging: rtl8188eu: Remove 'int transfer_len' from struct recv_buf
Date: Sat,  3 May 2014 17:15:24 +0530
Message-Id: <1399117532-8521-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver is not making any use of value stored in this variable.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    2 --
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c  |    1 -
 drivers/staging/rtl8188eu/include/rtw_recv.h   |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    1 -
 4 files changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 52d83a4..ee7fa64 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -30,8 +30,6 @@
 
 void rtl8188eu_init_recvbuf(struct adapter *padapter, struct recv_buf *precvbuf)
 {
-	precvbuf->transfer_len = 0;
-
 	precvbuf->len = 0;
 
 	precvbuf->ref_cnt = 0;
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 1fa5370..285cb5f 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -518,7 +518,6 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 		} else {
 			rtw_reset_continual_urb_error(adapter_to_dvobj(adapt));
 
-			precvbuf->transfer_len = purb->actual_length;
 			skb_put(precvbuf->pskb, purb->actual_length);
 			skb_queue_tail(&precvpriv->rx_skb_queue, precvbuf->pskb);
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index bf9af77..cac8acb 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -247,7 +247,6 @@ struct recv_buf {
 	struct urb *purb;
 	u32 alloc_sz;
 	u8  irp_pending;
-	int  transfer_len;
 	struct sk_buff *pskb;
 	u8	reuse;
 };
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index da397e4..0838339 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -67,7 +67,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 	precvbuf->phead = NULL;
 	precvbuf->ptail = NULL;
 	precvbuf->pend = NULL;
-	precvbuf->transfer_len = 0;
 	precvbuf->len = 0;
 	return res;
 }
-- 
1.7.10.4

