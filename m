Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBOHhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 02:37:17 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:23206
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbaBOHgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 02:36:31 -0500
X-IronPort-AV: E=Sophos;i="4.95,849,1384297200"; 
   d="scan'208";a="49183508"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kernel-janitors@vger.kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: r8712u: delete unnecessary field initialization
Date: Sat, 15 Feb 2014 08:36:11 +0100
Message-Id: <1392449773-23429-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

On success, the function netdev_alloc_skb initializes the dev field of its
result to its first argument, so this doesn't have to be done in the
calling context.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression skb,privn,e;
@@

skb = netdev_alloc_skb(privn,...);
... when strict
(
-skb->dev = privn;
|
?skb = e
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/rtl8712/rtl8712_recv.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index ea96537..0723b2f 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -90,7 +90,6 @@ int r8712_init_recv_priv(struct recv_priv *precvpriv, struct _adapter *padapter)
 		pskb = netdev_alloc_skb(padapter->pnetdev, MAX_RECVBUF_SZ +
 		       RECVBUFF_ALIGN_SZ);
 		if (pskb) {
-			pskb->dev = padapter->pnetdev;
 			tmpaddr = (addr_t)pskb->data;
 			alignment = tmpaddr & (RECVBUFF_ALIGN_SZ-1);
 			skb_reserve(pskb, (RECVBUFF_ALIGN_SZ - alignment));
@@ -1083,7 +1082,6 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 		alloc_sz += 6;
 		pkt_copy = netdev_alloc_skb(padapter->pnetdev, alloc_sz);
 		if (pkt_copy) {
-			pkt_copy->dev = padapter->pnetdev;
 			precvframe->u.hdr.pkt = pkt_copy;
 			skb_reserve(pkt_copy, 4 - ((addr_t)(pkt_copy->data)
 				    % 4));

