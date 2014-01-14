Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaANA3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:29:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaANA2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 20/77] ipv6: fix illegal mac_header comparison on 32bit
Date: Mon, 13 Jan 2014 16:27:41 -0800
Message-Id: <20140114002753.073430151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/udp_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -88,7 +88,7 @@ static struct sk_buff *udp6_ufo_fragment
 
 		/* Check if there is enough headroom to insert fragment header. */
 		tnl_hlen = skb_tnl_header_len(skb);
-		if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
+		if (skb_mac_header(skb) < skb->head + tnl_hlen + frag_hdr_sz) {
 			if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
 				goto out;
 		}


