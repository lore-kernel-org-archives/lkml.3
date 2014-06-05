Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaFEFQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:16:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaFEET5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:19:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Petukhov <dmgenp@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 017/214] l2tp: take PMTU from tunnel UDP socket
Date: Wed,  4 Jun 2014 21:16:20 -0700
Message-Id: <20140605041642.075520250@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Petukhov <dmgenp@gmail.com>

[ Upstream commit f34c4a35d87949fbb0e0f31eba3c054e9f8199ba ]

When l2tp driver tries to get PMTU for the tunnel destination, it uses
the pointer to struct sock that represents PPPoX socket, while it
should use the pointer that represents UDP socket of the tunnel.

Signed-off-by: Dmitry Petukhov <dmgenp@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -772,9 +772,9 @@ static int pppol2tp_connect(struct socke
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


