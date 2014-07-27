Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaG0HHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 03:07:03 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43911 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaG0HHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 03:07:00 -0400
Date: Sun, 27 Jul 2014 12:36:51 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Kozlov <xeb@mail.ru>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] net/ipv4: Use IS_ERR_OR_NULL
Message-ID: <20140727070651.GA4787@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the macro IS_ERR_OR_NULL in place of
tests for NULL and IS_ERR.

The following Coccinelle semantic patch was used for making the change:

@@
expression e;
@@

- e == NULL || IS_ERR(e)
+ IS_ERR_OR_NULL(e)
 || ...

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/ipv4/gre_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index f0bdd47..6556263 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -74,7 +74,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	/* segment inner packet. */
 	enc_features = skb->dev->hw_enc_features & netif_skb_features(skb);
 	segs = skb_mac_gso_segment(skb, enc_features);
-	if (!segs || IS_ERR(segs)) {
+	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, protocol, ghl, mac_offset, mac_len);
 		goto out;
 	}
-- 
1.9.1

