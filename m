Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927AbaDKQwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:52:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422776AbaDKQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 19/65] skbuff: skb_segment: s/skb_frag/frag/
Date: Fri, 11 Apr 2014 09:10:51 -0700
Message-Id: <20140411161000.348683625@linuxfoundation.org>
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

[ Upstream commit 4e1beba12d094c6c761ba5c49032b9b9e46380e8 ]

skb_frag can in fact point at either skb
or fskb so rename it generally "frag".

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2768,7 +2768,7 @@ struct sk_buff *skb_segment(struct sk_bu
 	struct sk_buff *segs = NULL;
 	struct sk_buff *tail = NULL;
 	struct sk_buff *fskb = skb_shinfo(skb)->frag_list;
-	skb_frag_t *skb_frag = skb_shinfo(skb)->frags;
+	skb_frag_t *frag = skb_shinfo(skb)->frags;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 	unsigned int doffset = skb->data - skb_mac_header(skb);
 	unsigned int offset = doffset;
@@ -2814,19 +2814,19 @@ struct sk_buff *skb_segment(struct sk_bu
 
 			i = 0;
 			nfrags = skb_shinfo(fskb)->nr_frags;
-			skb_frag = skb_shinfo(fskb)->frags;
+			frag = skb_shinfo(fskb)->frags;
 			pos += skb_headlen(fskb);
 
 			while (pos < offset + len) {
 				BUG_ON(i >= nfrags);
 
-				size = skb_frag_size(skb_frag);
+				size = skb_frag_size(frag);
 				if (pos + size > offset + len)
 					break;
 
 				i++;
 				pos += size;
-				skb_frag++;
+				frag++;
 			}
 
 			nskb = skb_clone(fskb, GFP_ATOMIC);
@@ -2900,7 +2900,7 @@ struct sk_buff *skb_segment(struct sk_bu
 
 				i = 0;
 				nfrags = skb_shinfo(fskb)->nr_frags;
-				skb_frag = skb_shinfo(fskb)->frags;
+				frag = skb_shinfo(fskb)->frags;
 
 				BUG_ON(!nfrags);
 
@@ -2915,7 +2915,7 @@ struct sk_buff *skb_segment(struct sk_bu
 				goto err;
 			}
 
-			*nskb_frag = *skb_frag;
+			*nskb_frag = *frag;
 			__skb_frag_ref(nskb_frag);
 			size = skb_frag_size(nskb_frag);
 
@@ -2928,7 +2928,7 @@ struct sk_buff *skb_segment(struct sk_bu
 
 			if (pos + size <= offset + len) {
 				i++;
-				skb_frag++;
+				frag++;
 				pos += size;
 			} else {
 				skb_frag_size_sub(nskb_frag, pos + size - (offset + len));


