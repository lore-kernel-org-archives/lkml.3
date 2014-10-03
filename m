Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaJCWiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:38:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbaJCWeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:34:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Gartrell <agartrell@fb.com>, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 3.16 338/357] ipvs: Maintain all DSCP and ECN bits for ipv6 tun forwarding
Date: Fri,  3 Oct 2014 14:32:04 -0700
Message-Id: <20141003212943.612290208@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Gartrell <agartrell@fb.com>

commit 76f084bc10004b3050b2cff9cfac29148f1f6088 upstream.

Previously, only the four high bits of the tclass were maintained in the
ipv6 case.  This matches the behavior of ipv4, though whether or not we
should reflect ECN bits may be up for debate.

Signed-off-by: Alex Gartrell <agartrell@fb.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipvs/ip_vs_xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -967,8 +967,8 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb
 	iph->nexthdr		=	IPPROTO_IPV6;
 	iph->payload_len	=	old_iph->payload_len;
 	be16_add_cpu(&iph->payload_len, sizeof(*old_iph));
-	iph->priority		=	old_iph->priority;
 	memset(&iph->flow_lbl, 0, sizeof(iph->flow_lbl));
+	ipv6_change_dsfield(iph, 0, ipv6_get_dsfield(old_iph));
 	iph->daddr = cp->daddr.in6;
 	iph->saddr = saddr;
 	iph->hop_limit		=	old_iph->hop_limit;


