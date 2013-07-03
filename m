Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133Ab3GCTBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:01:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28068 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068Ab3GCTAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:36 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=wXyqo-V3uawA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=CupyHCsm3sgA:10 a=tHz9FfFoAAAA:8 a=iox4zFpeAAAA:8 a=J1Y8HTJGAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=6O0IECtVFhoA:10 a=n9GBPR9yFnkA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184054.930692150@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Beulich <jbeulich@suse.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [062/141] xen-netback: remove redundent parameter in netbk_count_requests
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0062-xen-netback-remove-redundent-parameter-in-netbk_coun.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit ac69c26e7accb04ae2cb9ab0872068983a42b3c8 ]

Tracking down from the caller, first_idx is always equal to vif->tx.req_cons.
Remove it to avoid confusion.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/xen-netback/netback.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 89dd960..b78839e 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -899,7 +899,6 @@ static void netbk_fatal_tx_err(struct xenvif *vif)
 
 static int netbk_count_requests(struct xenvif *vif,
 				struct xen_netif_tx_request *first,
-				RING_IDX first_idx,
 				struct xen_netif_tx_request *txp,
 				int work_to_do)
 {
@@ -976,7 +975,7 @@ static int netbk_count_requests(struct xenvif *vif,
 	} while ((txp++)->flags & XEN_NETTXF_more_data);
 
 	if (drop_err) {
-		netbk_tx_err(vif, first, first_idx + slots);
+		netbk_tx_err(vif, first, cons + slots);
 		return drop_err;
 	}
 
@@ -1446,8 +1445,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 				continue;
 		}
 
-		ret = netbk_count_requests(vif, &txreq, idx,
-					   txfrags, work_to_do);
+		ret = netbk_count_requests(vif, &txreq, txfrags, work_to_do);
 		if (unlikely(ret < 0))
 			continue;
 
-- 
1.7.10.4


