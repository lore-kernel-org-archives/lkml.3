Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab3EGOFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:05:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42352 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab3EGNl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 060/118] l2tp: fix info leak in l2tp_ip6_recvmsg()
Date: Tue,  7 May 2013 14:38:26 +0100
Message-Id: <1367933964-1564-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit b860d3cc62877fad02863e2a08efff69a19382d2 upstream.

The L2TP code for IPv6 fails to initialize the l2tp_conn_id member of
struct sockaddr_l2tpip6 and therefore leaks four bytes kernel stack
in l2tp_ip6_recvmsg() in case msg_name is set.

Initialize l2tp_conn_id with 0 to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/l2tp/l2tp_ip6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 9275471..2c9ccce 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -684,6 +684,7 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		lsa->l2tp_addr = ipv6_hdr(skb)->saddr;
 		lsa->l2tp_flowinfo = 0;
 		lsa->l2tp_scope_id = 0;
+		lsa->l2tp_conn_id = 0;
 		if (ipv6_addr_type(&lsa->l2tp_addr) & IPV6_ADDR_LINKLOCAL)
 			lsa->l2tp_scope_id = IP6CB(skb)->iif;
 	}
-- 
1.8.1.2

