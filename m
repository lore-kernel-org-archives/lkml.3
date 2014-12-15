Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaLOO3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:29:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39015 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaLOO3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Kozlov <xeb@mail.ru>, Yuri Chislov <yuri.chislov@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 153/168] ipv6: gre: fix wrong skb->protocol in WCCP
Date: Mon, 15 Dec 2014 14:26:47 +0000
Message-Id: <1418653622-21105-154-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Chislov <yuri.chislov@gmail.com>

commit be6572fdb1bfbe23b2624d477de50af50b02f5d6 upstream.

When using GRE redirection in WCCP, it sets the wrong skb->protocol,
that is, ETH_P_IP instead of ETH_P_IPV6 for the encapuslated traffic.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Yuri Chislov <yuri.chislov@gmail.com>
Tested-by: Yuri Chislov <yuri.chislov@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_gre.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index c3ba41cef1df..0baac7127c57 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -499,11 +499,11 @@ static int ip6gre_rcv(struct sk_buff *skb)
 
 		skb->protocol = gre_proto;
 		/* WCCP version 1 and 2 protocol decoding.
-		 * - Change protocol to IP
+		 * - Change protocol to IPv6
 		 * - When dealing with WCCPv2, Skip extra 4 bytes in GRE header
 		 */
 		if (flags == 0 && gre_proto == htons(ETH_P_WCCP)) {
-			skb->protocol = htons(ETH_P_IP);
+			skb->protocol = htons(ETH_P_IPV6);
 			if ((*(h + offset) & 0xF0) != 0x40)
 				offset += 4;
 		}
-- 
2.1.3

