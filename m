Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3FDXBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:01:43 -0400
Received: from 1wt.eu ([62.212.114.60]:35667 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab3FDWnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:08 -0400
Message-Id: <20130604172136.725114430@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 155/184] net: guard tcp_set_keepalive() to tcp sockets
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3e10986d1d698140747fcfc2761ec9cb64c1d582 ]

Its possible to use RAW sockets to get a crash in
tcp_set_keepalive() / sk_reset_timer()

Fix is to make sure socket is a SOCK_STREAM one.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 4538a34..eafa660 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -562,7 +562,8 @@ set_rcvbuf:
 
 	case SO_KEEPALIVE:
 #ifdef CONFIG_INET
-		if (sk->sk_protocol == IPPROTO_TCP)
+		if (sk->sk_protocol == IPPROTO_TCP &&
+		    sk->sk_type == SOCK_STREAM)
 			tcp_set_keepalive(sk, valbool);
 #endif
 		sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
-- 
1.7.12.2.21.g234cd45.dirty



