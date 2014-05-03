Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaECLqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:46:20 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41384 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaECLqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:46:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 01/15] staging: rtl8188eu: Remove function rtw_dequeue_recvbuf()
Date: Sat,  3 May 2014 17:15:18 +0530
Message-Id: <1399117532-8521-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtw_dequeue_recvbuf() is not being used by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_recv.c    |   25 -------------------------
 drivers/staging/rtl8188eu/include/rtw_recv.h |    1 -
 2 files changed, 26 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index 5c1d2d2..eac5260 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -313,31 +313,6 @@ int rtw_enqueue_recvbuf(struct recv_buf *precvbuf, struct __queue *queue)
 	return _SUCCESS;
 }
 
-struct recv_buf *rtw_dequeue_recvbuf (struct __queue *queue)
-{
-	unsigned long irqL;
-	struct recv_buf *precvbuf;
-	struct list_head *plist, *phead;
-
-	spin_lock_irqsave(&queue->lock, irqL);
-
-	if (_rtw_queue_empty(queue)) {
-		precvbuf = NULL;
-	} else {
-		phead = get_list_head(queue);
-
-		plist = phead->next;
-
-		precvbuf = container_of(plist, struct recv_buf, list);
-
-		rtw_list_delete(&precvbuf->list);
-	}
-
-	spin_unlock_irqrestore(&queue->lock, irqL);
-
-	return precvbuf;
-}
-
 static int recvframe_chkmic(struct adapter *adapter,
 			    struct recv_frame *precvframe)
 {
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index bcbce46..7b95860 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -304,7 +304,6 @@ void rtw_free_recvframe_queue(struct __queue *pframequeue,
 u32 rtw_free_uc_swdec_pending_queue(struct adapter *adapter);
 int rtw_enqueue_recvbuf_to_head(struct recv_buf *buf, struct __queue *queue);
 int rtw_enqueue_recvbuf(struct recv_buf *precvbuf, struct __queue *queue);
-struct recv_buf *rtw_dequeue_recvbuf(struct __queue *queue);
 
 void rtw_reordering_ctrl_timeout_handler(void *pcontext);
 
-- 
1.7.10.4

