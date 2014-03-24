Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaCXRpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:45:19 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:50376 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752653AbaCXRpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:45:17 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2538:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3871:4321:4385:5007:7652:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12517:12519:12555:13069:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: vase33_10aecb3662c4e
X-Filterd-Recvd-Size: 2310
Message-ID: <1395683112.13968.59.camel@joe-AO722>
Subject: [PATCH net-next] chelsio: Remove addressof casts to same type
From: Joe Perches <joe@perches.com>
To: Dimitris Michailidis <dm@chelsio.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 24 Mar 2014 10:45:12 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using addressof then casting to the original type is pointless,
so remove these unnecessary casts.

Done via coccinelle script:

$ cat typecast.cocci 
@@
type T;
T foo;
@@

-	(T *)&foo
+	&foo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index cc04d09..a7a41e0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3220,8 +3220,8 @@ static int cxgb4_clip_get(const struct net_device *dev,
 	c.op_to_write = htonl(FW_CMD_OP(FW_CLIP_CMD) |
 			FW_CMD_REQUEST | FW_CMD_WRITE);
 	c.alloc_to_len16 = htonl(F_FW_CLIP_CMD_ALLOC | FW_LEN16(c));
-	*(__be64 *)&c.ip_hi = *(__be64 *)(lip->s6_addr);
-	*(__be64 *)&c.ip_lo = *(__be64 *)(lip->s6_addr + 8);
+	c.ip_hi = *(__be64 *)(lip->s6_addr);
+	c.ip_lo = *(__be64 *)(lip->s6_addr + 8);
 	return t4_wr_mbox_meat(adap, adap->mbox, &c, sizeof(c), &c, false);
 }
 
@@ -3236,8 +3236,8 @@ static int cxgb4_clip_release(const struct net_device *dev,
 	c.op_to_write = htonl(FW_CMD_OP(FW_CLIP_CMD) |
 			FW_CMD_REQUEST | FW_CMD_READ);
 	c.alloc_to_len16 = htonl(F_FW_CLIP_CMD_FREE | FW_LEN16(c));
-	*(__be64 *)&c.ip_hi = *(__be64 *)(lip->s6_addr);
-	*(__be64 *)&c.ip_lo = *(__be64 *)(lip->s6_addr + 8);
+	c.ip_hi = *(__be64 *)(lip->s6_addr);
+	c.ip_lo = *(__be64 *)(lip->s6_addr + 8);
 	return t4_wr_mbox_meat(adap, adap->mbox, &c, sizeof(c), &c, false);
 }
 


