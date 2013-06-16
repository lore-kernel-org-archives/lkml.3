Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3FPWIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:08:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46340 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598Ab3FPWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wei Liu" <wei.liu2@citrix.com>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Jan Beulich" <jbeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.266479332@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [20/83] xen-netback: remove redundent parameter in
 netbk_count_requests
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit ac69c26e7accb04ae2cb9ab0872068983a42b3c8 upstream.

Tracking down from the caller, first_idx is always equal to vif->tx.req_cons.
Remove it to avoid confusion.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netback/netback.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -900,7 +900,6 @@ static void netbk_fatal_tx_err(struct xe
 
 static int netbk_count_requests(struct xenvif *vif,
 				struct xen_netif_tx_request *first,
-				RING_IDX first_idx,
 				struct xen_netif_tx_request *txp,
 				int work_to_do)
 {
@@ -977,7 +976,7 @@ static int netbk_count_requests(struct x
 	} while ((txp++)->flags & XEN_NETTXF_more_data);
 
 	if (drop_err) {
-		netbk_tx_err(vif, first, first_idx + slots);
+		netbk_tx_err(vif, first, cons + slots);
 		return drop_err;
 	}
 
@@ -1447,8 +1446,7 @@ static unsigned xen_netbk_tx_build_gops(
 				continue;
 		}
 
-		ret = netbk_count_requests(vif, &txreq, idx,
-					   txfrags, work_to_do);
+		ret = netbk_count_requests(vif, &txreq, txfrags, work_to_do);
 		if (unlikely(ret < 0))
 			continue;
 

