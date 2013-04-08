Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027Ab3DHKJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:09:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935414Ab3DHJwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mirko Lindner <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 058/102] sky2: Receive Overflows not counted
Date: Mon,  8 Apr 2013 10:50:13 +0100
Message-Id: <1365414657-29191-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirko Lindner <mlindner@marvell.com>

commit 9cfe8b156c21cf340b3a10ecb3022fbbc1c39185 upstream.

The sky2 driver doesn't count the Receive Overflows because the MAC
interrupt for this event is not set in the MAC's interrupt mask.
The MAC's interrupt mask is set only for Transmit FIFO Underruns.

Fix: The correct setting should be (GM_IS_TX_FF_UR | GM_IS_RX_FF_OR)
Otherwise the Receive Overflow event will not generate any interrupt.
The  Receive Overflow interrupt is handled correctly

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
-- 
1.8.1.2

