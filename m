Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaEGEBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:01:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44168 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaEGEBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:01:31 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/13] staging: rtl8188eu: Remove unused inline function recvframe_push()
Date: Wed,  7 May 2014 09:31:14 +0530
Message-Id: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_recv.h |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 68c2ad5f..e5b4e10 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -296,26 +296,6 @@ static inline u8 *get_rx_status(struct recv_frame *precvframe)
 	return get_rxmem(precvframe);
 }
 
-static inline u8 *recvframe_push(struct recv_frame *precvframe, int sz)
-{
-	/*  append data before rx_data */
-
-	/* add data to the start of recv_frame
- *
- *      This function extends the used data area of the recv_frame at the buffer
- *      start. rx_data must be still larger than rx_head, after pushing.
- */
-	if (precvframe == NULL)
-		return NULL;
-	precvframe->rx_data -= sz;
-	if (precvframe->rx_data < precvframe->rx_head) {
-		precvframe->rx_data += sz;
-		return NULL;
-	}
-	precvframe->len += sz;
-	return precvframe->rx_data;
-}
-
 static inline u8 *recvframe_pull(struct recv_frame *precvframe, int sz)
 {
 	/*  rx_data += sz; move rx_data sz bytes  hereafter */
-- 
1.7.10.4

