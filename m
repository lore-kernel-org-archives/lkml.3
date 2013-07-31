Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab3GaJk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:40:27 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47205 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab3GaJkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:40:22 -0400
Date: Wed, 31 Jul 2013 13:39:45 +0400
From: Dmitry Popov <dp@highloadlab.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] tcp: Remove unused tcpct declarations and comments
Message-Id: <20130731133945.5b7b3f7487491f41ea45a7f6@highloadlab.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.20; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove declaration, 4 defines and confusing comment that are no longer used
since 1a2c6181c4 ("tcp: Remove TCPCT").

Signed-off-by: Dmitry Popov <dp@highloadlab.com>
---
 include/linux/tcp.h | 1 -
 include/net/tcp.h   | 4 ----
 net/ipv4/tcp.c      | 4 ----
 3 files changed, 9 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 472120b..b7e01bc 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -107,7 +107,6 @@ static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
  * only four options will fit in a standard TCP header */
 #define TCP_NUM_SACKS 4
 
-struct tcp_cookie_values;
 struct tcp_request_sock_ops;
 
 struct tcp_request_sock {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index d198005..fa6893c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -192,10 +192,6 @@ extern void tcp_time_wait(struct sock *sk, int state, int timeo);
 #define TCPOLEN_TIMESTAMP      10
 #define TCPOLEN_MD5SIG         18
 #define TCPOLEN_EXP_FASTOPEN_BASE  4
-#define TCPOLEN_COOKIE_BASE    2	/* Cookie-less header extension */
-#define TCPOLEN_COOKIE_PAIR    3	/* Cookie pair header extension */
-#define TCPOLEN_COOKIE_MIN     (TCPOLEN_COOKIE_BASE+TCP_COOKIE_MIN)
-#define TCPOLEN_COOKIE_MAX     (TCPOLEN_COOKIE_BASE+TCP_COOKIE_MAX)
 
 /* But this is what stacks really send out. */
 #define TCPOLEN_TSTAMP_ALIGNED		12
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5423223..077abde 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -410,10 +410,6 @@ void tcp_init_sock(struct sock *sk)
 
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
-	/* Presumed zeroed, in order of appearance:
-	 *	cookie_in_always, cookie_out_never,
-	 *	s_data_constant, s_data_in, s_data_out
-	 */
 	sk->sk_sndbuf = sysctl_tcp_wmem[1];
 	sk->sk_rcvbuf = sysctl_tcp_rmem[1];
 
