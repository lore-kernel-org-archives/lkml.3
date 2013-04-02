Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab3DBWSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:18:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab3DBWOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Erik Hugne <erik.hugne@ericsson.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 62/68] ipv6: dont accept multicast traffic with scope 0
Date: Tue,  2 Apr 2013 15:13:51 -0700
Message-Id: <20130402221337.133612533@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 20314092c1b41894d8c181bf9aa6f022be2416aa ]

v2:
a) moved before multicast source address check
b) changed comment to netdev style

Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Erik Hugne <erik.hugne@ericsson.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_input.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -111,6 +111,15 @@ int ipv6_rcv(struct sk_buff *skb, struct
 	    ipv6_addr_loopback(&hdr->daddr))
 		goto err;
 
+	/* RFC4291 2.7
+	 * Nodes must not originate a packet to a multicast address whose scope
+	 * field contains the reserved value 0; if such a packet is received, it
+	 * must be silently dropped.
+	 */
+	if (ipv6_addr_is_multicast(&hdr->daddr) &&
+	    IPV6_ADDR_MC_SCOPE(&hdr->daddr) == 0)
+		goto err;
+
 	/*
 	 * RFC4291 2.7
 	 * Multicast addresses must not be used as source addresses in IPv6


