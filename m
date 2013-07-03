Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab3GCSvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:51:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244Ab3GCSlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:00 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=emxdz9S0OHcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=2KX6EGbf2GsA:10 a=tHz9FfFoAAAA:8 a=J1Y8HTJGAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=6O0IECtVFhoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184052.851540898@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [050/141] xen-netback: remove skb in xen_netbk_alloc_page
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0050-xen-netback-remove-skb-in-xen_netbk_alloc_page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit 27f852282ab9a028f57da96d05c26f38c424a315 ]

This variable is never used.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/xen-netback/netback.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 6aa059e..0ed1b26 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -913,7 +913,6 @@ static int netbk_count_requests(struct xenvif *vif,
 }
 
 static struct page *xen_netbk_alloc_page(struct xen_netbk *netbk,
-					 struct sk_buff *skb,
 					 u16 pending_idx)
 {
 	struct page *page;
@@ -947,7 +946,7 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 
 		index = pending_index(netbk->pending_cons++);
 		pending_idx = netbk->pending_ring[index];
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = xen_netbk_alloc_page(netbk, pending_idx);
 		if (!page)
 			goto err;
 
@@ -1352,7 +1351,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		}
 
 		/* XXX could copy straight to head */
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = xen_netbk_alloc_page(netbk, pending_idx);
 		if (!page) {
 			kfree_skb(skb);
 			netbk_tx_err(vif, &txreq, idx);
-- 
1.7.10.4


