Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaCJQ3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:29:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbaCJQ3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:29:46 -0400
Date: Mon, 10 Mar 2014 18:29:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jbenc@redhat.com, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Simon Horman <horms@verge.net.au>,
        Paul Durrant <Paul.Durrant@citrix.com>, Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Miklos Szeredi <mszeredi@suse.cz>,
        =?us-ascii?B?PT9VVEYtOD9xP1BldGVyPTIwUGFuPTI4PUU2PUJEPTk4PUU1PThEPUFC?=
	 =?us-ascii?B?PUU1PUI5PUIzPTI5Pz0=?= <panweiping3@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/5] skbuff: skb_segment: s/frag/nskb_frag/
Message-ID: <1394468807-25980-2-git-send-email-mst@redhat.com>
References: <1394468807-25980-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394468807-25980-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frag points at nskb, so name it appropriately

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/core/skbuff.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5976ef0..3bc6d75 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2879,7 +2879,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 
 	do {
 		struct sk_buff *nskb;
-		skb_frag_t *frag;
+		skb_frag_t *nskb_frag;
 		int hsize;
 		int size;
 
@@ -2972,7 +2972,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
 			continue;
 		}
 
-		frag = skb_shinfo(nskb)->frags;
+		nskb_frag = skb_shinfo(nskb)->frags;
 
 		skb_copy_from_linear_data_offset(skb, offset,
 						 skb_put(nskb, hsize), hsize);
@@ -3000,13 +3000,13 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
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
@@ -3016,11 +3016,11 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features)
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
MST

