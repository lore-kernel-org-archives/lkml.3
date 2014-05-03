Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaECLqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:46:34 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34199 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaECLqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:46:32 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/15] staging: rtl8188eu: Remove function rtw_enqueue_recvbuf_to_head()
Date: Sat,  3 May 2014 17:15:19 +0530
Message-Id: <1399117532-8521-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_enqueue_recvbuf_to_head() is not being used by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c    |   12 ------------
 drivers/staging/rtl8188eu/include/rtw_recv.h |    1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index eac5260..21aa89d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -289,18 +289,6 @@ u32 rtw_free_uc_swdec_pending_queue(struct adapter *adapter)
 	return cnt;
 }
 
-int rtw_enqueue_recvbuf_to_head(struct recv_buf *precvbuf, struct __queue *queue)
-{
-	spin_lock_bh(&queue->lock);
-
-	rtw_list_delete(&precvbuf->list);
-	rtw_list_insert_head(&precvbuf->list, get_list_head(queue));
-
-	spin_unlock_bh(&queue->lock);
-
-	return _SUCCESS;
-}
-
 int rtw_enqueue_recvbuf(struct recv_buf *precvbuf, struct __queue *queue)
 {
 	unsigned long irqL;
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 7b95860..21ce405 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -302,7 +302,6 @@ int rtw_enqueue_recvframe(struct recv_frame *precvframe, struct __queue *queue);
 void rtw_free_recvframe_queue(struct __queue *pframequeue,
 			      struct __queue *pfree_recv_queue);
 u32 rtw_free_uc_swdec_pending_queue(struct adapter *adapter);
-int rtw_enqueue_recvbuf_to_head(struct recv_buf *buf, struct __queue *queue);
 int rtw_enqueue_recvbuf(struct recv_buf *precvbuf, struct __queue *queue);
 
 void rtw_reordering_ctrl_timeout_handler(void *pcontext);
-- 
1.7.10.4

