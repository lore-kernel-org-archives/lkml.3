Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaHJSkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 14:40:14 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:55472 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaHJSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 14:40:09 -0400
From: Adrian Remonda <adrianremonda@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adrian Remonda <adrianremonda@gmail.com>
Subject: [PATCHv3 2/2] Staging: rtl8188eu: Removed unneeded code.
Date: Sun, 10 Aug 2014 20:39:57 +0200
Message-Id: <1407695997-9567-2-git-send-email-adrianremonda@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407695997-9567-1-git-send-email-adrianremonda@gmail.com>
References: <1407695997-9567-1-git-send-email-adrianremonda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some unneeded code.
1) kzalloc() allocates 4 extra bytes so that we can align the return
   value.  But actually the return value is already aligned so we can
   remove the + 4 and the call to N_BYTE_ALIGMENT().
2) The memset() isn't needed because kzalloc() zeroes the allocation.

Suggested-by: Larry Finger <Larry.Finger@lwfinger.net>

Signed-off-by: Adrian Remonda <adrianremonda@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 8be4819..bc275b2 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -42,18 +42,15 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 	_rtw_init_queue(&precvpriv->free_recv_buf_queue);
 
 	precvpriv->pallocated_recv_buf =
-		kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
+		kzalloc(NR_RECVBUFF * sizeof(struct recv_buf), GFP_KERNEL);
 	if (precvpriv->pallocated_recv_buf == NULL) {
 		res = _FAIL;
 		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
 				("alloc recv_buf fail!\n"));
 		goto exit;
 	}
-	memset(precvpriv->pallocated_recv_buf, 0,
-			NR_RECVBUFF * sizeof(struct recv_buf) + 4);
 
-	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)
-			(precvpriv->pallocated_recv_buf), 4);
+	precvpriv->precv_buf = precvpriv->pallocated_recv_buf;
 
 
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
-- 
2.0.4

