Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab3CZRxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:53:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3CZRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:17 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5k5sGqvUnZsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=iP-HGH3nTWwA:10 a=6ohNodAXAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=gDjHQkheYgsA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173608.583813675@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Cristian Bercaru <B43982@freescale.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 54/86] bridging: fix rx_handlers return code
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0054-bridging-fix-rx_handlers-return-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Cristian Bercaru <B43982@freescale.com>

[ Upstream commit 3bc1b1add7a8484cc4a261c3e128dbe1528ce01f ]

The frames for which rx_handlers return RX_HANDLER_CONSUMED are no longer
counted as dropped. They are counted as successfully received by
'netif_receive_skb'.

This allows network interface drivers to correctly update their RX-OK and
RX-DRP counters based on the result of 'netif_receive_skb'.

Signed-off-by: Cristian Bercaru <B43982@freescale.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1dce5b5..c41efb7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3296,6 +3296,7 @@ ncls:
 		}
 		switch (rx_handler(&skb)) {
 		case RX_HANDLER_CONSUMED:
+			ret = NET_RX_SUCCESS;
 			goto unlock;
 		case RX_HANDLER_ANOTHER:
 			goto another_round;
-- 
1.7.10.4


