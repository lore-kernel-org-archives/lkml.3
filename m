Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab3C0JUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:20:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3C0JUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:20:48 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mst@redhat.com, Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 1/3] net: core: let skb_partial_csum_set() set transport header
Date: Wed, 27 Mar 2013 17:11:20 +0800
Message-Id: <1364375482-7439-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For untrusted packets with partial checksum, we need to set the transport header
for precise packet length estimation. We can just let skb_pratial_csum_set() to
do this to avoid extra call to skb_flow_dissect() and simplify the caller.

Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 net/core/skbuff.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 31c6737..ba64614 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3370,6 +3370,7 @@ bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off)
 	skb->ip_summed = CHECKSUM_PARTIAL;
 	skb->csum_start = skb_headroom(skb) + start;
 	skb->csum_offset = off;
+	skb_set_transport_header(skb, start);
 	return true;
 }
 EXPORT_SYMBOL_GPL(skb_partial_csum_set);
-- 
1.7.1

