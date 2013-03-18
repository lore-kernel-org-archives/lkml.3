Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3CRVMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:12:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab3CRVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 38/40] ipv6: stop multicast forwarding to process interface scoped addresses
Date: Mon, 18 Mar 2013 14:11:16 -0700
Message-Id: <20130318211018.995100066@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit ddf64354af4a702ee0b85d0a285ba74c7278a460 ]

v2:
a) used struct ipv6_addr_props

v3:
a) reverted changes for ipv6_addr_props

v4:
a) do not use __ipv6_addr_needs_scope_id

Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_input.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -257,7 +257,8 @@ int ip6_mc_input(struct sk_buff *skb)
 	 *      IPv6 multicast router mode is now supported ;)
 	 */
 	if (dev_net(skb->dev)->ipv6.devconf_all->mc_forwarding &&
-	    !(ipv6_addr_type(&hdr->daddr) & IPV6_ADDR_LINKLOCAL) &&
+	    !(ipv6_addr_type(&hdr->daddr) &
+	      (IPV6_ADDR_LOOPBACK|IPV6_ADDR_LINKLOCAL)) &&
 	    likely(!(IP6CB(skb)->flags & IP6SKB_FORWARDED))) {
 		/*
 		 * Okay, we try to forward - split and duplicate


