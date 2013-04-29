Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941Ab3D2Tne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:43:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab3D2TCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 13/42] l2tp: fix info leak in l2tp_ip6_recvmsg()
Date: Mon, 29 Apr 2013 12:01:55 -0700
Message-Id: <20130429184753.891705903@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit b860d3cc62877fad02863e2a08efff69a19382d2 ]

The L2TP code for IPv6 fails to initialize the l2tp_conn_id member of
struct sockaddr_l2tpip6 and therefore leaks four bytes kernel stack
in l2tp_ip6_recvmsg() in case msg_name is set.

Initialize l2tp_conn_id with 0 to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ip6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -684,6 +684,7 @@ static int l2tp_ip6_recvmsg(struct kiocb
 		lsa->l2tp_addr = ipv6_hdr(skb)->saddr;
 		lsa->l2tp_flowinfo = 0;
 		lsa->l2tp_scope_id = 0;
+		lsa->l2tp_conn_id = 0;
 		if (ipv6_addr_type(&lsa->l2tp_addr) & IPV6_ADDR_LINKLOCAL)
 			lsa->l2tp_scope_id = IP6CB(skb)->iif;
 	}


