Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbaELCCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:02:18 -0400
Received: from 1wt.eu ([62.212.114.60]:34606 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaELBmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:42 -0400
Message-Id: <20140512003201.721459702@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 026/143] ipv6: tcp: fix panic in SYN processing
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 72a3effaf633bc ([NET]: Size listen hash tables using backlog
hint) added a bug allowing inet6_synq_hash() to return an out of bound
array index, because of u16 overflow.

Bug can happen if system admins set net.core.somaxconn &
net.ipv4.tcp_max_syn_backlog sysctls to values greater than 65536

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit c16a98ed91597b40b22b540c6517103497ef8e74)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv6/inet6_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index cc4797d..59f4063 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -57,7 +57,7 @@ EXPORT_SYMBOL_GPL(inet6_csk_bind_conflict);
  * request_sock (formerly open request) hash tables.
  */
 static u32 inet6_synq_hash(const struct in6_addr *raddr, const __be16 rport,
-			   const u32 rnd, const u16 synq_hsize)
+			   const u32 rnd, const u32 synq_hsize)
 {
 	u32 a = (__force u32)raddr->s6_addr32[0];
 	u32 b = (__force u32)raddr->s6_addr32[1];
-- 
1.7.12.2.21.g234cd45.dirty



