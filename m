Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaFVK6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:58:47 -0400
Received: from mail.grouk.net ([92.222.18.81]:34372 "EHLO grouk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaFVK6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:58:46 -0400
From: Thomas Vegas <thomas@grouk.net>
To: gregkh@linuxfoundation.org
Cc: Thomas Vegas <thomas@grouk.net>, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2014 13:01:50 +0200
Message-Id: <1403434912-21655-1-git-send-email-thomas@grouk.net>
X-Mailer: git-send-email 1.8.5.5
X-SA-Exim-Connect-IP: 86.217.122.199
X-SA-Exim-Mail-From: thomas@grouk.net
Subject: [PATCH 1/3] staging: rtl8188eu: core: Remove unnecessary conditionals
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on grouk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'pxmitbuf' is already set to NULL when entering the
function. We can remove the first conditional. When _rtw_queue_empty()
returns false, 'pxmitbuf' if not NULL. We can merge the second and
third conditional.

Signed-off-by: Thomas Vegas <thomas@grouk.net>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index a113f0f..bb290a3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1226,9 +1226,7 @@ struct xmit_buf *rtw_alloc_xmitbuf_ext(struct xmit_priv *pxmitpriv)
 
 	spin_lock_irqsave(&pfree_queue->lock, irql);
 
-	if (_rtw_queue_empty(pfree_queue) == true) {
-		pxmitbuf = NULL;
-	} else {
+	if (_rtw_queue_empty(pfree_queue) == false) {
 		phead = get_list_head(pfree_queue);
 
 		plist = phead->next;
@@ -1236,9 +1234,6 @@ struct xmit_buf *rtw_alloc_xmitbuf_ext(struct xmit_priv *pxmitpriv)
 		pxmitbuf = container_of(plist, struct xmit_buf, list);
 
 		rtw_list_delete(&(pxmitbuf->list));
-	}
-
-	if (pxmitbuf !=  NULL) {
 		pxmitpriv->free_xmit_extbuf_cnt--;
 
 		pxmitbuf->priv_data = NULL;
-- 
1.8.5.5

