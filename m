Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798Ab3DGXaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:30:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46742 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934647Ab3DGXaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:30:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        "Mirko Lindner" <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.620139356@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [52/74] sky2: Receive Overflows not counted
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mirko Lindner <mlindner@marvell.com>

[ Upstream commit 9cfe8b156c21cf340b3a10ecb3022fbbc1c39185 ]

The sky2 driver doesn't count the Receive Overflows because the MAC
interrupt for this event is not set in the MAC's interrupt mask.
The MAC's interrupt mask is set only for Transmit FIFO Underruns.

Fix: The correct setting should be (GM_IS_TX_FF_UR | GM_IS_RX_FF_OR)
Otherwise the Receive Overflow event will not generate any interrupt.
The  Receive Overflow interrupt is handled correctly

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/marvell/sky2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index 3c896ce..a0f229e 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -2069,7 +2069,7 @@ enum {
 	GM_IS_RX_FF_OR	= 1<<1,	/* Receive FIFO Overrun */
 	GM_IS_RX_COMPL	= 1<<0,	/* Frame Reception Complete */
 
-#define GMAC_DEF_MSK     GM_IS_TX_FF_UR
+#define GMAC_DEF_MSK     (GM_IS_TX_FF_UR | GM_IS_RX_FF_OR)
 };
 
 /*	GMAC_LINK_CTRL	16 bit	GMAC Link Control Reg (YUKON only) */

