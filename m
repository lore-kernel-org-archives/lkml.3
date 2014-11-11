Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaKKLrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:47:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaKKLKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Herbert <therbert@google.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 082/170] gre: Use inner mac length when computing tunnel length
Date: Tue, 11 Nov 2014 11:07:21 +0000
Message-Id: <1415704129-12709-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Herbert <therbert@google.com>

commit 14051f0452a2c26a3f4791e6ad6a435e8f1945ff upstream.

Currently, skb_inner_network_header is used but this does not account
for Ethernet header for ETH_P_TEB. Use skb_inner_mac_header which
handles TEB and also should work with IP encapsulation in which case
inner mac and inner network headers are the same.

Tested: Ran TCP_STREAM over GRE, worked as expected.

Signed-off-by: Tom Herbert <therbert@google.com>
Acked-by: Alexander Duyck <alexander.h.duyck@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/gre_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index f0bdd47bbbcb..32041ecbeafb 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -51,7 +51,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 
 	greh = (struct gre_base_hdr *)skb_transport_header(skb);
 
-	ghl = skb_inner_network_header(skb) - skb_transport_header(skb);
+	ghl = skb_inner_mac_header(skb) - skb_transport_header(skb);
 	if (unlikely(ghl < sizeof(*greh)))
 		goto out;
 
-- 
2.1.0

