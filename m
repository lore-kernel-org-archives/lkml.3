Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbbAIKuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:50:09 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44539 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757433AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yuri Chislov <yuri.chislov@gmail.com>,
        Dmitry Kozlov <xeb@mail.ru>, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 01/78] ipv6: gre: fix wrong skb->protocol in WCCP
Date: Fri,  9 Jan 2015 11:31:10 +0100
Message-Id: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuri Chislov <yuri.chislov@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit be6572fdb1bfbe23b2624d477de50af50b02f5d6 ]

When using GRE redirection in WCCP, it sets the wrong skb->protocol,
that is, ETH_P_IP instead of ETH_P_IPV6 for the encapuslated traffic.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Yuri Chislov <yuri.chislov@gmail.com>
Tested-by: Yuri Chislov <yuri.chislov@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/ip6_gre.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 88774ccb3dda..7d640f276e87 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -511,11 +511,11 @@ static int ip6gre_rcv(struct sk_buff *skb)
 
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
2.2.1

