Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaHDWpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:45:15 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:43434 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaHDWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:45:13 -0400
From: Adrian Remonda <adrianremonda@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adrian Remonda <adrianremonda@gmail.com>
Subject: [PATCH] Staging: rtl8188eu: Lines over 80 characters fixed.
Date: Tue,  5 Aug 2014 00:45:03 +0200
Message-Id: <1407192303-23519-1-git-send-email-adrianremonda@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the hal/rtl8188eu_recv.c file that fixes up a "line
over 80 characters" warning found by the checkpatch.pl tool.

Signed-off-by: Adrian Remonda <adrianremonda@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c | 28 +++++++++++++++++---------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index f25c87c..8be4819 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -41,15 +41,19 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 	/* init recv_buf */
 	_rtw_init_queue(&precvpriv->free_recv_buf_queue);
 
-	precvpriv->pallocated_recv_buf = kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
+	precvpriv->pallocated_recv_buf =
+		kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
 	if (precvpriv->pallocated_recv_buf == NULL) {
 		res = _FAIL;
-		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, ("alloc recv_buf fail!\n"));
+		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
+				("alloc recv_buf fail!\n"));
 		goto exit;
 	}
-	memset(precvpriv->pallocated_recv_buf, 0, NR_RECVBUFF * sizeof(struct recv_buf) + 4);
+	memset(precvpriv->pallocated_recv_buf, 0,
+			NR_RECVBUFF * sizeof(struct recv_buf) + 4);
 
-	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)(precvpriv->pallocated_recv_buf), 4);
+	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)
+			(precvpriv->pallocated_recv_buf), 4);
 
 
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
@@ -66,20 +70,23 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 	{
 		int i;
 		size_t tmpaddr = 0;
-		size_t alignment = 0;
+		size_t alignm = 0;
 		struct sk_buff *pskb = NULL;
 
 		skb_queue_head_init(&precvpriv->free_recv_skb_queue);
 
 		for (i = 0; i < NR_PREALLOC_RECV_SKB; i++) {
-			pskb = __netdev_alloc_skb(padapter->pnetdev, MAX_RECVBUF_SZ + RECVBUFF_ALIGN_SZ, GFP_KERNEL);
+			pskb = __netdev_alloc_skb(padapter->pnetdev,
+					MAX_RECVBUF_SZ + RECVBUFF_ALIGN_SZ,
+					GFP_KERNEL);
 			if (pskb) {
 				pskb->dev = padapter->pnetdev;
 				tmpaddr = (size_t)pskb->data;
-				alignment = tmpaddr & (RECVBUFF_ALIGN_SZ-1);
-				skb_reserve(pskb, (RECVBUFF_ALIGN_SZ - alignment));
+				alignm = tmpaddr & (RECVBUFF_ALIGN_SZ-1);
+				skb_reserve(pskb, (RECVBUFF_ALIGN_SZ - alignm));
 
-				skb_queue_tail(&precvpriv->free_recv_skb_queue, pskb);
+				skb_queue_tail(&precvpriv->free_recv_skb_queue,
+						pskb);
 			}
 			pskb = NULL;
 		}
@@ -109,7 +116,8 @@ void rtl8188eu_free_recv_priv(struct adapter *padapter)
 
 
 	if (skb_queue_len(&precvpriv->free_recv_skb_queue))
-		DBG_88E(KERN_WARNING "free_recv_skb_queue not empty, %d\n", skb_queue_len(&precvpriv->free_recv_skb_queue));
+		DBG_88E(KERN_WARNING "free_recv_skb_queue not empty, %d\n",
+				skb_queue_len(&precvpriv->free_recv_skb_queue));
 
 	skb_queue_purge(&precvpriv->free_recv_skb_queue);
 }
-- 
2.0.4

