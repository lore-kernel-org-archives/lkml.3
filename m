Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161314AbaGRNX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:23:58 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17946 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030805AbaGRNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/170] xhci: correct burst count field for isoc transfers on 1.0 xhci hosts
Date: Fri, 18 Jul 2014 14:11:09 +0200
Message-Id: <02fe41346ccc70b4d4b487072c644e3483d51a88.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3213b151387df0b95f4eada104f68eb1c1409cb3 upstream.

The transfer burst count (TBC) field in xhci 1.0 hosts should be set
to the number of bursts needed to transfer all packets in a isoc TD.
Supported values are 0-2 (1 to 3 bursts per service interval).

Formula for TBC calculation is given in xhci spec section 4.11.2.3:
TBC = roundup( Transfer Descriptor Packet Count / Max Burst Size +1 ) - 1

This patch should be applied to stable kernels since 3.0 that contain
the commit 5cd43e33b9519143f06f507dd7cbee6b7a621885
"xhci 1.0: Set transfer burst count field."

Suggested-by: ShiChun Ma <masc2008@qq.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1dbfb52dbcd6..6118e292d5df 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3633,7 +3633,7 @@ static unsigned int xhci_get_burst_count(struct xhci_hcd *xhci,
 		return 0;
 
 	max_burst = urb->ep->ss_ep_comp.bMaxBurst;
-	return roundup(total_packet_count, max_burst + 1) - 1;
+	return DIV_ROUND_UP(total_packet_count, max_burst + 1) - 1;
 }
 
 /*
-- 
2.0.0

