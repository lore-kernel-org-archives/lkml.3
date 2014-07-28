Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaG1P2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:28:23 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52081 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaG1P2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:28:20 -0400
Date: Mon, 28 Jul 2014 20:58:12 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Samuel Ortiz <samuel@sortiz.org>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] net: irda: delete double assignment
Message-ID: <20140728152812.GA3000@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete successive assignments to the same location.

A simplified version of Coccinelle semantic match that finds this problem is as
follows:

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
Should the second assignment have been |=?
 net/irda/irlap_frame.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/irda/irlap_frame.c b/net/irda/irlap_frame.c
index 9ea0c93..4c169f6 100644
--- a/net/irda/irlap_frame.c
+++ b/net/irda/irlap_frame.c
@@ -621,7 +621,6 @@ void irlap_send_rd_frame(struct irlap_cb *self)
 
 	frame = (struct rd_frame *)skb_put(tx_skb, 2);
 
-	frame->caddr = self->caddr;
 	frame->caddr = RD_RSP | PF_BIT;
 
 	irlap_queue_xmit(self, tx_skb);
-- 
1.9.1

