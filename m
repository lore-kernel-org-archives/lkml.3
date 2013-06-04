Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3FDOKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:10:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab3FDOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 65/70] xen-netback: remove redundent parameter in netbk_count_requests
Date: Tue,  4 Jun 2013 15:07:21 +0100
Message-Id: <1370354846-14213-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit ac69c26e7accb04ae2cb9ab0872068983a42b3c8 upstream.

Tracking down from the caller, first_idx is always equal to vif->tx.req_cons.
Remove it to avoid confusion.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/netback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 9990bd8..bc812b7 100644
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
1.8.1.2

