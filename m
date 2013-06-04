Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3FDXJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:09:34 -0400
Received: from 1wt.eu ([62.212.114.60]:35525 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab3FDWmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:38 -0400
Message-Id: <20130604172133.786435981@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 084/184] xfrm_user: fix info leak in copy_to_user_state()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit f778a636713a435d3a922c60b1622a91136560c1 ]

The memory reserved to dump the xfrm state includes the padding bytes of
struct xfrm_usersa_info added by the compiler for alignment (7 for
amd64, 3 for i386). Add an explicit memset(0) before filling the buffer
to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b95a2d6..4823a15 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -506,6 +506,7 @@ out:
 
 static void copy_to_user_state(struct xfrm_state *x, struct xfrm_usersa_info *p)
 {
+	memset(p, 0, sizeof(*p));
 	memcpy(&p->id, &x->id, sizeof(p->id));
 	memcpy(&p->sel, &x->sel, sizeof(p->sel));
 	memcpy(&p->lft, &x->lft, sizeof(p->lft));
-- 
1.7.12.2.21.g234cd45.dirty



