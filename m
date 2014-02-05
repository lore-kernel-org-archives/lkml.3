Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbaBEVGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:06:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48007 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaBEUEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:50 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 044/213] net: guard tcp_set_keepalive() to tcp sockets
Date: Wed, 5 Feb 2014 14:59:59 -0500
Message-ID: <1391630568-49251-45-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3e10986d1d698140747fcfc2761ec9cb64c1d582 upstream.

Its possible to use RAW sockets to get a crash in
tcp_set_keepalive() / sk_reset_timer()

Fix is to make sure socket is a SOCK_STREAM one.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 4b45ad8f6b9e..8ad61ba17a39 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -582,7 +582,8 @@ set_rcvbuf:
 
 	case SO_KEEPALIVE:
 #ifdef CONFIG_INET
-		if (sk->sk_protocol == IPPROTO_TCP)
+		if (sk->sk_protocol == IPPROTO_TCP &&
+		    sk->sk_type == SOCK_STREAM)
 			tcp_set_keepalive(sk, valbool);
 #endif
 		sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
-- 
1.8.5.2

