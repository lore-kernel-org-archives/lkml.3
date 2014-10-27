Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaJ0TzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:55:17 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:48525 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347AbaJ0TzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:55:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEPAKaiTlRXQ3zJ/2dsb2JhbABcgw6BLLlDCwUBdJpDgR4XAX2EMC8jgRo3iEUBvG2OZyyGNIpUHYQ1BZ1hli6BRwGCMTwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH V2 net-next] ipx: remove unnecessary casting on ntohl
Date: Mon, 27 Oct 2014 20:55:08 +0100
Message-Id: <1414439709-5870-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use %08X instead of %08lX and remove casting.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: remove casting instead of long unsigned int -> unsigned long
(suggested by Joe Perches)

 net/ipx/ipx_proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipx/ipx_proc.c b/net/ipx/ipx_proc.c
index e15c16a..8391191 100644
--- a/net/ipx/ipx_proc.c
+++ b/net/ipx/ipx_proc.c
@@ -89,8 +89,8 @@ static int ipx_seq_route_show(struct seq_file *seq, void *v)
 
 	seq_printf(seq, "%08lX   ", (unsigned long int)ntohl(rt->ir_net));
 	if (rt->ir_routed)
-		seq_printf(seq, "%08lX     %02X%02X%02X%02X%02X%02X\n",
-			   (long unsigned int)ntohl(rt->ir_intrfc->if_netnum),
+		seq_printf(seq, "%08X     %02X%02X%02X%02X%02X%02X\n",
+			   ntohl(rt->ir_intrfc->if_netnum),
 			   rt->ir_router_node[0], rt->ir_router_node[1],
 			   rt->ir_router_node[2], rt->ir_router_node[3],
 			   rt->ir_router_node[4], rt->ir_router_node[5]);
-- 
1.9.1

