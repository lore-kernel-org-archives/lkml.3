Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaFGBtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:49:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35918 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Dmitry Petukhov" <dmgenp@gmail.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.289474340@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 07/92] l2tp: take PMTU from tunnel UDP socket
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Petukhov <dmgenp@gmail.com>

[ Upstream commit f34c4a35d87949fbb0e0f31eba3c054e9f8199ba ]

When l2tp driver tries to get PMTU for the tunnel destination, it uses
the pointer to struct sock that represents PPPoX socket, while it
should use the pointer that represents UDP socket of the tunnel.

Signed-off-by: Dmitry Petukhov <dmgenp@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_ppp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 969cd3e..e0f0934 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -772,9 +772,9 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
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

