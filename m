Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3JRTwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:52:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab3JRTvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:51:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 7/7] ipv6: tcp: fix panic in SYN processing
Date: Fri, 18 Oct 2013 12:52:54 -0700
Message-Id: <20131018195036.526916841@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195036.020644622@linuxfoundation.org>
References: <20131018195036.020644622@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit c16a98ed91597b40b22b540c6517103497ef8e74 upstream.

commit 72a3effaf633bc ([NET]: Size listen hash tables using backlog
hint) added a bug allowing inet6_synq_hash() to return an out of bound
array index, because of u16 overflow.

Bug can happen if system admins set net.core.somaxconn &
net.ipv4.tcp_max_syn_backlog sysctls to values greater than 65536

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/inet6_connection_sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -85,7 +85,7 @@ struct dst_entry *inet6_csk_route_req(st
  * request_sock (formerly open request) hash tables.
  */
 static u32 inet6_synq_hash(const struct in6_addr *raddr, const __be16 rport,
-			   const u32 rnd, const u16 synq_hsize)
+			   const u32 rnd, const u32 synq_hsize)
 {
 	u32 c;
 


