Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaECLsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:48:06 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49276 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaECLsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:48:04 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/15] staging: rtl8188eu: Remove pdata, phead, ptail and pend from struct recv_buf
Date: Sat,  3 May 2014 17:15:25 +0530
Message-Id: <1399117532-8521-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver is not making use of value stored in removed variables.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    8 --------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c  |    9 ---------
 drivers/staging/rtl8188eu/include/rtw_recv.h   |    4 ----
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    4 ----
 4 files changed, 25 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index ee7fa64..41a0c0d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -31,15 +31,7 @@
 void rtl8188eu_init_recvbuf(struct adapter *padapter, struct recv_buf *precvbuf)
 {
 	precvbuf->len = 0;
-
 	precvbuf->ref_cnt = 0;
-
-	if (precvbuf->pbuf) {
-		precvbuf->pdata = precvbuf->pbuf;
-		precvbuf->phead = precvbuf->pbuf;
-		precvbuf->ptail = precvbuf->pbuf;
-		precvbuf->pend = precvbuf->pdata + MAX_RECVBUF_SZ;
-	}
 }
 
 int	rtl8188eu_init_recv_priv(struct adapter *padapter)
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 285cb5f..654c5b3 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -615,18 +615,9 @@ static u32 usb_read_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem)
 		alignment = tmpaddr & (RECVBUFF_ALIGN_SZ-1);
 		skb_reserve(precvbuf->pskb, (RECVBUFF_ALIGN_SZ - alignment));
 
-		precvbuf->phead = precvbuf->pskb->head;
-		precvbuf->pdata = precvbuf->pskb->data;
-		precvbuf->ptail = skb_tail_pointer(precvbuf->pskb);
-		precvbuf->pend = skb_end_pointer(precvbuf->pskb);
 		precvbuf->pbuf = precvbuf->pskb->data;
 	} else { /* reuse skb */
-		precvbuf->phead = precvbuf->pskb->head;
-		precvbuf->pdata = precvbuf->pskb->data;
-		precvbuf->ptail = skb_tail_pointer(precvbuf->pskb);
-		precvbuf->pend = skb_end_pointer(precvbuf->pskb);
 		precvbuf->pbuf = precvbuf->pskb->data;
-
 		precvbuf->reuse = false;
 	}
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index cac8acb..8d3424b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -240,10 +240,6 @@ struct recv_buf {
 	u8	*pbuf;
 	u8	*pallocated_buf;
 	u32	len;
-	u8	*phead;
-	u8	*pdata;
-	u8	*ptail;
-	u8	*pend;
 	struct urb *purb;
 	u32 alloc_sz;
 	u8  irp_pending;
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 0838339..99b5910 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -63,10 +63,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 	precvbuf->reuse = false;
 	precvbuf->pallocated_buf = NULL;
 	precvbuf->pbuf = NULL;
-	precvbuf->pdata = NULL;
-	precvbuf->phead = NULL;
-	precvbuf->ptail = NULL;
-	precvbuf->pend = NULL;
 	precvbuf->len = 0;
 	return res;
 }
-- 
1.7.10.4

