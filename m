Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3BQWzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45670 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab3BQWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:21 -0500
Message-Id: <20130217225008.498347835@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:51:00 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Campbell <Ian.Campbell@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jan Beulich <JBeulich@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 59/66] netback: correct netbk_tx_err to handle wrap around.
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

[ Upstream commit b9149729ebdcfce63f853aa54a404c6a8f6ebbf3 ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/xen-netback/netback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a14b3a2..b802bb3 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -852,7 +852,7 @@ static void netbk_tx_err(struct xenvif *vif,
 
 	do {
 		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		if (cons >= end)
+		if (cons == end)
 			break;
 		txp = RING_GET_REQUEST(&vif->tx, cons++);
 	} while (1);


