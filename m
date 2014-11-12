Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaKLBVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:21:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaKLBVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:21:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 007/319] vxlan: fix a free after use
Date: Wed, 12 Nov 2014 10:12:25 +0900
Message-Id: <20141112010953.846912929@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 7a9f526fc3ee49b6034af2f243676ee0a27dcaa8 ]

pskb_may_pull maybe change skb->data and make eth pointer oboslete,
so eth needs to reload

Fixes: 91269e390d062 ("vxlan: using pskb_may_pull as early as possible")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1936,6 +1936,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 				    msg->icmph.icmp6_type == NDISC_NEIGHBOUR_SOLICITATION)
 					return neigh_reduce(dev, skb);
 		}
+		eth = eth_hdr(skb);
 #endif
 	}
 


