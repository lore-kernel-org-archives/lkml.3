Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbaFCLmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaFCLmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Petukhov <dmgenp@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 097/138] l2tp: take PMTU from tunnel UDP socket
Date: Tue,  3 Jun 2014 12:39:03 +0100
Message-Id: <1401795584-22664-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Petukhov <dmgenp@gmail.com>

commit f34c4a35d87949fbb0e0f31eba3c054e9f8199ba upstream.

When l2tp driver tries to get PMTU for the tunnel destination, it uses
the pointer to struct sock that represents PPPoX socket, while it
should use the pointer that represents UDP socket of the tunnel.

Signed-off-by: Dmitry Petukhov <dmgenp@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 44441c0c5037..9a0e5874e73e 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -754,9 +754,9 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	session->deref = pppol2tp_session_sock_put;
 
 	/* If PMTU discovery was enabled, use the MTU that was discovered */
-	dst = sk_dst_get(sk);
+	dst = sk_dst_get(tunnel->sock);
 	if (dst != NULL) {
-		u32 pmtu = dst_mtu(__sk_dst_get(sk));
+		u32 pmtu = dst_mtu(__sk_dst_get(tunnel->sock));
 		if (pmtu != 0)
 			session->mtu = session->mru = pmtu -
 				PPPOL2TP_HEADER_OVERHEAD;
-- 
1.9.1

