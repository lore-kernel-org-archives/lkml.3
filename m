Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342Ab3DBWYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:24:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933749Ab3DBWOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 45/68] sky2: Receive Overflows not counted
Date: Tue,  2 Apr 2013 15:13:34 -0700
Message-Id: <20130402221335.181363789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/sky2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -2069,7 +2069,7 @@ enum {
 	GM_IS_RX_FF_OR	= 1<<1,	/* Receive FIFO Overrun */
 	GM_IS_RX_COMPL	= 1<<0,	/* Frame Reception Complete */
 
-#define GMAC_DEF_MSK     GM_IS_TX_FF_UR
+#define GMAC_DEF_MSK     (GM_IS_TX_FF_UR | GM_IS_RX_FF_OR)
 };
 
 /*	GMAC_LINK_CTRL	16 bit	GMAC Link Control Reg (YUKON only) */


