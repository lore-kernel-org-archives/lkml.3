Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaBOHgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 02:36:32 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:23206
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbaBOHga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 02:36:30 -0500
X-IronPort-AV: E=Sophos;i="4.95,849,1384297200"; 
   d="scan'208";a="49183509"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: r8188eu: delete unnecessary field initialization
Date: Sat, 15 Feb 2014 08:36:12 +0100
Message-Id: <1392449773-23429-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 74ee2e6..b92b4f5 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -384,7 +384,6 @@ static int recvbuf2recvframe(struct adapter *adapt, struct sk_buff *pskb)
 
 		pkt_copy = netdev_alloc_skb(adapt->pnetdev, alloc_sz);
 		if (pkt_copy) {
-			pkt_copy->dev = adapt->pnetdev;
 			precvframe->u.hdr.pkt = pkt_copy;
 			precvframe->u.hdr.rx_head = pkt_copy->data;
 			precvframe->u.hdr.rx_end = pkt_copy->data + alloc_sz;

