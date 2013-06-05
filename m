Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab3FEVnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:43:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab3FEVgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 099/127] xen-netback: remove skb in xen_netbk_alloc_page
Date: Wed,  5 Jun 2013 14:34:26 -0700
Message-Id: <20130605213229.265371127@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 27f852282ab9a028f57da96d05c26f38c424a315 upstream.

This variable is never used.

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netback/netback.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -942,7 +942,6 @@ static int netbk_count_requests(struct x
 }
 
 static struct page *xen_netbk_alloc_page(struct xen_netbk *netbk,
-					 struct sk_buff *skb,
 					 u16 pending_idx)
 {
 	struct page *page;
@@ -976,7 +975,7 @@ static struct gnttab_copy *xen_netbk_get
 
 		index = pending_index(netbk->pending_cons++);
 		pending_idx = netbk->pending_ring[index];
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = xen_netbk_alloc_page(netbk, pending_idx);
 		if (!page)
 			goto err;
 
@@ -1381,7 +1380,7 @@ static unsigned xen_netbk_tx_build_gops(
 		}
 
 		/* XXX could copy straight to head */
-		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
+		page = xen_netbk_alloc_page(netbk, pending_idx);
 		if (!page) {
 			kfree_skb(skb);
 			netbk_tx_err(vif, &txreq, idx);


