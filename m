Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaFWIzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55493 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 078/111] skbuff: skb_segment: s/frag/nskb_frag/
Date: Mon, 23 Jun 2014 10:31:53 +0200
Message-Id: <e7fb29afa611ca364a8f6e26af2128db2a7d7ff0.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 8cb19905e9287a93ce7c2cbbdf742a060b00e219 ]

frag points at nskb, so name it appropriately

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/skbuff.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f69f2ed1dbc3..9e99761b0211 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2753,7 +2753,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 
 	do {
 		struct sk_buff *nskb;
-		skb_frag_t *frag;
+		skb_frag_t *nskb_frag;
 		int hsize;
 		int size;
 
@@ -2853,7 +2853,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 			continue;
 		}
 
-		frag = skb_shinfo(nskb)->frags;
+		nskb_frag = skb_shinfo(nskb)->frags;
 
 		skb_copy_from_linear_data_offset(skb, offset,
 						 skb_put(nskb, hsize), hsize);
@@ -2881,13 +2881,13 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 				goto err;
 			}
 
-			*frag = *skb_frag;
-			__skb_frag_ref(frag);
-			size = skb_frag_size(frag);
+			*nskb_frag = *skb_frag;
+			__skb_frag_ref(nskb_frag);
+			size = skb_frag_size(nskb_frag);
 
 			if (pos < offset) {
-				frag->page_offset += offset - pos;
-				skb_frag_size_sub(frag, offset - pos);
+				nskb_frag->page_offset += offset - pos;
+				skb_frag_size_sub(nskb_frag, offset - pos);
 			}
 
 			skb_shinfo(nskb)->nr_frags++;
@@ -2897,11 +2897,11 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 				skb_frag++;
 				pos += size;
 			} else {
-				skb_frag_size_sub(frag, pos + size - (offset + len));
+				skb_frag_size_sub(nskb_frag, pos + size - (offset + len));
 				goto skip_fraglist;
 			}
 
-			frag++;
+			nskb_frag++;
 		}
 
 skip_fraglist:
-- 
2.0.0

