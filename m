Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaEGEB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:01:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46575 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaEGEBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:01:55 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/13] staging: rtl8188eu: Remove 'void  *precvbuf' from struct recv_frame
Date: Wed,  7 May 2014 09:31:16 +0530
Message-Id: <1399435278-32602-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
References: <1399435278-32602-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'void *precvbuf'.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_recv.h  |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index d8fc747..fc73147 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -333,7 +333,6 @@ static int recvbuf2recvframe(struct adapter *adapt, struct sk_buff *pskb)
 		}
 
 		_rtw_init_listhead(&precvframe->list);
-		precvframe->precvbuf = NULL;	/* can't access the precvbuf for new arch. */
 		precvframe->len = 0;
 
 		update_recvframe_attrib_88e(precvframe, prxstat);
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index dac2e0c..e14ba98 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -261,7 +261,6 @@ struct recv_frame {
 	u8 *rx_data;
 	u8 *rx_tail;
 	u8 *rx_end;
-	void *precvbuf;
 	struct sta_info *psta;
 	/* for A-MPDU Rx reordering buffer control */
 	struct recv_reorder_ctrl *preorder_ctrl;
-- 
1.7.10.4

