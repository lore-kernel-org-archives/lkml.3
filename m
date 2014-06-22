Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaFVK73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:59:29 -0400
Received: from mail.grouk.net ([92.222.18.81]:34430 "EHLO grouk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbaFVK7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:59:04 -0400
From: Thomas Vegas <thomas@grouk.net>
To: gregkh@linuxfoundation.org
Cc: Thomas Vegas <thomas@grouk.net>, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2014 13:01:52 +0200
Message-Id: <1403434912-21655-3-git-send-email-thomas@grouk.net>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403434912-21655-1-git-send-email-thomas@grouk.net>
References: <1403434912-21655-1-git-send-email-thomas@grouk.net>
X-SA-Exim-Connect-IP: 86.217.122.199
X-SA-Exim-Mail-From: thomas@grouk.net
Subject: [PATCH 3/3] staging: rtl8188eu: core: Remove extraneous blank lines
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on grouk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extraneous blank lines in rtw_alloc_xmitbuf_ext().

Signed-off-by: Thomas Vegas <thomas@grouk.net>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 4b93add..101b19f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1223,31 +1223,22 @@ struct xmit_buf *rtw_alloc_xmitbuf_ext(struct xmit_priv *pxmitpriv)
 	struct list_head *plist, *phead;
 	struct __queue *pfree_queue = &pxmitpriv->free_xmit_extbuf_queue;
 
-
 	spin_lock_irqsave(&pfree_queue->lock, irql);
-
 	if (_rtw_queue_empty(pfree_queue) == false) {
 		phead = get_list_head(pfree_queue);
-
 		plist = phead->next;
-
 		pxmitbuf = container_of(plist, struct xmit_buf, list);
 
 		rtw_list_delete(&pxmitbuf->list);
 		pxmitpriv->free_xmit_extbuf_cnt--;
-
 		pxmitbuf->priv_data = NULL;
 		/* pxmitbuf->ext_tag = true; */
-
 		if (pxmitbuf->sctx) {
 			DBG_88E("%s pxmitbuf->sctx is not NULL\n", __func__);
 			rtw_sctx_done_err(&pxmitbuf->sctx, RTW_SCTX_DONE_BUF_ALLOC);
 		}
 	}
-
 	spin_unlock_irqrestore(&pfree_queue->lock, irql);
-
-
 	return pxmitbuf;
 }
 
-- 
1.8.5.5

