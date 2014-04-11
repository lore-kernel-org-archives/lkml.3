Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422975AbaDKQyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:54:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422767AbaDKQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 18/65] skbuff: skb_segment: s/frag/nskb_frag/
Date: Fri, 11 Apr 2014 09:10:50 -0700
Message-Id: <20140411161000.209758558@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 8cb19905e9287a93ce7c2cbbdf742a060b00e219 ]

frag points at nskb, so name it appropriately

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2794,7 +2794,7 @@ struct sk_buff *skb_segment(struct sk_bu
 
 	do {
 		struct sk_buff *nskb;
-		skb_frag_t *frag;
+		skb_frag_t *nskb_frag;
 		int hsize;
 		int size;
 
@@ -2887,7 +2887,7 @@ struct sk_buff *skb_segment(struct sk_bu
 			continue;
 		}
 
-		frag = skb_shinfo(nskb)->frags;
+		nskb_frag = skb_shinfo(nskb)->frags;
 
 		skb_copy_from_linear_data_offset(skb, offset,
 						 skb_put(nskb, hsize), hsize);
@@ -2915,13 +2915,13 @@ struct sk_buff *skb_segment(struct sk_bu
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
@@ -2931,11 +2931,11 @@ struct sk_buff *skb_segment(struct sk_bu
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


