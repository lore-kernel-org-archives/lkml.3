Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaLNUWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:22:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaLNUVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kozlov <xeb@mail.ru>, Yuri Chislov <yuri.chislov@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 13/24] ipv6: gre: fix wrong skb->protocol in WCCP
Date: Sun, 14 Dec 2014 12:20:33 -0800
Message-Id: <20141214201801.058866623@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuri Chislov <yuri.chislov@gmail.com>

[ Upstream commit be6572fdb1bfbe23b2624d477de50af50b02f5d6 ]

When using GRE redirection in WCCP, it sets the wrong skb->protocol,
that is, ETH_P_IP instead of ETH_P_IPV6 for the encapuslated traffic.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Cc: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Yuri Chislov <yuri.chislov@gmail.com>
Tested-by: Yuri Chislov <yuri.chislov@gmail.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -512,11 +512,11 @@ static int ip6gre_rcv(struct sk_buff *sk
 
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


