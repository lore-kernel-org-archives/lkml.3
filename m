Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaELB5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:57:52 -0400
Received: from 1wt.eu ([62.212.114.60]:34663 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaELBm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:59 -0400
Message-Id: <20140512003204.125407052@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 084/143] ipv6: fix leaking uninitialized port number of offender sockaddr
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 1fa4c710b6fe7b0aac9907240291b6fe6aafc3b8 ]

Offenders don't have port numbers, so set it to 0.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/datagram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index ef6436d..5da306b 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -342,6 +342,7 @@ int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 	if (serr->ee.ee_origin != SO_EE_ORIGIN_LOCAL) {
 		sin->sin6_family = AF_INET6;
 		sin->sin6_flowinfo = 0;
+		sin->sin6_port = 0;
 		sin->sin6_scope_id = 0;
 		if (serr->ee.ee_origin == SO_EE_ORIGIN_ICMP6) {
 			ipv6_addr_copy(&sin->sin6_addr, &ipv6_hdr(skb)->saddr);
-- 
1.7.12.2.21.g234cd45.dirty



