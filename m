Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbaGNUeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:34:24 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39702 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbaGNUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:34:22 -0400
Date: Tue, 15 Jul 2014 02:04:13 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Bluetooth: cmtp: Remove unnecessary null test
Message-ID: <20140714203412.GA16532@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the null test on ctrl. ctrl is initialized at the
beginning of the function to &session->ctrl. Since session is
dereferenced prior to the null test, session must be a valid pointer,
and &session->ctrl cannot be null.

The following Coccinelle script is used for detecting the change:

@r@
expression e,f;
identifier g,y;
statement S1,S2;
@@

*e = &f->g
<+...
 f->y
 ...+>
*if (e != NULL || ...)
 S1 else S2

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/bluetooth/cmtp/capi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/bluetooth/cmtp/capi.c b/net/bluetooth/cmtp/capi.c
index cd75e4d..1ca8a87 100644
--- a/net/bluetooth/cmtp/capi.c
+++ b/net/bluetooth/cmtp/capi.c
@@ -362,12 +362,6 @@ void cmtp_recv_capimsg(struct cmtp_session *session, struct sk_buff *skb)
 		CAPIMSG_SETCONTROL(skb->data, contr);
 	}
 
-	if (!ctrl) {
-		BT_ERR("Can't find controller %d for message", session->num);
-		kfree_skb(skb);
-		return;
-	}
-
 	capi_ctr_handle_message(ctrl, appl, skb);
 }
 
-- 
1.9.1

