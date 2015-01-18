Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbbARBEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:04:16 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59671 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbbARBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:04:15 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: rtl8712: recv_linux: Remove unused function
Date: Sun, 18 Jan 2015 02:07:23 +0100
Message-Id: <1421543243-18074-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function r8712_os_read_port() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8712/recv_linux.c |   14 --------------
 drivers/staging/rtl8712/recv_osdep.h |    1 -
 2 files changed, 15 deletions(-)

diff --git a/drivers/staging/rtl8712/recv_linux.c b/drivers/staging/rtl8712/recv_linux.c
index 0631f36..409c8c8 100644
--- a/drivers/staging/rtl8712/recv_linux.c
+++ b/drivers/staging/rtl8712/recv_linux.c
@@ -137,20 +137,6 @@ _recv_indicatepkt_drop:
 	 precvpriv->rx_drop++;
 }
 
-void r8712_os_read_port(struct _adapter *padapter, struct recv_buf *precvbuf)
-{
-	struct recv_priv *precvpriv = &padapter->recvpriv;
-
-	precvbuf->ref_cnt--;
-	/*free skb in recv_buf*/
-	dev_kfree_skb_any(precvbuf->pskb);
-	precvbuf->pskb = NULL;
-	precvbuf->reuse = false;
-	if (!precvbuf->irp_pending)
-		r8712_read_port(padapter, precvpriv->ff_hwaddr, 0,
-			 (unsigned char *)precvbuf);
-}
-
 static void _r8712_reordering_ctrl_timeout_handler (void *FunctionContext)
 {
 	struct recv_reorder_ctrl *preorder_ctrl =
diff --git a/drivers/staging/rtl8712/recv_osdep.h b/drivers/staging/rtl8712/recv_osdep.h
index f4384ef..1f4986e 100644
--- a/drivers/staging/rtl8712/recv_osdep.h
+++ b/drivers/staging/rtl8712/recv_osdep.h
@@ -46,7 +46,6 @@ int r8712_os_recvbuf_resource_alloc(struct _adapter *padapter,
 				    struct recv_buf *precvbuf);
 int r8712_os_recvbuf_resource_free(struct _adapter *padapter,
 				   struct recv_buf *precvbuf);
-void r8712_os_read_port(struct _adapter *padapter, struct recv_buf *precvbuf);
 void r8712_init_recv_timer(struct recv_reorder_ctrl *preorder_ctrl);
 
 #endif
-- 
1.7.10.4

