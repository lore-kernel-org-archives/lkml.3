Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab3FPWbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:31:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46339 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608Ab3FPWIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wei Liu" <wei.liu2@citrix.com>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.39065530@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [16/83] netback: remove redundant assignment
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

commit 16ecba2605a3bbd374cd993e532264e2d8de49e5 upstream.

New value for netbk->mmap_pages[pending_idx] is assigned in
xen_netbk_alloc_page(), no need for a second assignment which
exposes internal to the outside world.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netback/netback.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -951,8 +951,6 @@ static struct gnttab_copy *xen_netbk_get
 		if (!page)
 			goto err;
 
-		netbk->mmap_pages[pending_idx] = page;
-
 		gop->source.u.ref = txp->gref;
 		gop->source.domid = vif->domid;
 		gop->source.offset = txp->offset;
@@ -1361,8 +1359,6 @@ static unsigned xen_netbk_tx_build_gops(
 			continue;
 		}
 
-		netbk->mmap_pages[pending_idx] = page;
-
 		gop->source.u.ref = txreq.gref;
 		gop->source.domid = vif->domid;
 		gop->source.offset = txreq.offset;

