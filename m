Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaDPQZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:25:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaDPQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:25:10 -0400
From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>, Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Eric Dumazet <edumazet@google.com>
Subject: [PATCH v3] tcp: Add a TCP_FASTOPEN socket option to get a max backlog on its listner
User-agent: mu4e 0.9.9.5; emacs 24.3.1
Date: Thu, 17 Apr 2014 01:25:01 +0900
Message-ID: <87a9bljl7m.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a TCP_FASTOPEN socket option to get a max backlog on its
listener to getsockopt().

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
---
 net/ipv4/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4bd6d52..eb1dde3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2916,6 +2916,14 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 	case TCP_USER_TIMEOUT:
 		val = jiffies_to_msecs(icsk->icsk_user_timeout);
 		break;
+
+	case TCP_FASTOPEN:
+		if (icsk->icsk_accept_queue.fastopenq != NULL)
+			val = icsk->icsk_accept_queue.fastopenq->max_qlen;
+		else
+			val = 0;
+		break;
+
 	case TCP_TIMESTAMP:
 		val = tcp_time_stamp + tp->tsoffset;
 		break;
--
1.9.0
