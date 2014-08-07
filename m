Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaHGViV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:38:21 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59870 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaHGViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:38:07 -0400
From: Adrian Remonda <adrianremonda@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adrian Remonda <adrianremonda@gmail.com>
Subject: [PATCHv2 2/2] Staging: rtl8188eu: Removed unnecessarry code.
Date: Thu,  7 Aug 2014 23:37:51 +0200
Message-Id: <1407447471-11632-2-git-send-email-adrianremonda@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407447471-11632-1-git-send-email-adrianremonda@gmail.com>
References: <1407447471-11632-1-git-send-email-adrianremonda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clear some code that was not doing any help.
Pointed out by Larry.Finger

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

