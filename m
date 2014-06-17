Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbaFQQ3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:29:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965397AbaFQQ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:27:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Petukhov <dmgenp@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 050/121] l2tp: take PMTU from tunnel UDP socket
Date: Tue, 17 Jun 2014 09:17:08 -0700
Message-Id: <1403021899-16708-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Petukhov <dmgenp@gmail.com>

[ Upstream commit f34c4a35d87949fbb0e0f31eba3c054e9f8199ba ]

When l2tp driver tries to get PMTU for the tunnel destination, it uses
the pointer to struct sock that represents PPPoX socket, while it
should use the pointer that represents UDP socket of the tunnel.

Signed-off-by: Dmitry Petukhov <dmgenp@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index ddf43a3..26dbd9a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -781,9 +781,9 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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

