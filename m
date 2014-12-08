Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaLHLUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:20:22 -0500
Received: from box2.japko.eu ([91.121.152.53]:49413 "EHLO box2.japko.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaLHLUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:20:20 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2014 06:20:20 EST
Date: Mon, 8 Dec 2014 12:13:41 +0100
From: Krzysztof Adamski <k@japko.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Malcolm Priestley <tvboxspy@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6656: Use ether_addr_copy() in
 vnt_fill_ieee80211_rts.
Message-ID: <20141208111341.GA11489@x61s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both struct ieee80211_rts and struct ieee80211_hdr defined in
linux/ieee80211.h are declared as __aligned(2) so it is safe to use
ether_addr_copy() instead of memcpy().

Signed-off-by: Krzysztof Adamski <k@japko.eu>
---
 drivers/staging/vt6656/rxtx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index ea5140a..280c923 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -36,6 +36,7 @@
  *
  */
 
+#include <linux/etherdevice.h>
 #include "device.h"
 #include "rxtx.h"
 #include "card.h"
@@ -392,8 +393,8 @@ static int vnt_fill_ieee80211_rts(struct vnt_usb_send_context *tx_context,
 	rts->frame_control =
 		cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS);
 
-	memcpy(rts->ra, hdr->addr1, ETH_ALEN);
-	memcpy(rts->ta, hdr->addr2, ETH_ALEN);
+	ether_addr_copy(rts->ra, hdr->addr1);
+	ether_addr_copy(rts->ta, hdr->addr2);
 
 	return 0;
 }
-- 
1.9.3

