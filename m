Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587Ab3DKVUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:20:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935465Ab3DKUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:55 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=03g1QcyTCAIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3YZVYQ6q82QA:10 a=M5GUcnROAAAA:8 a=jZVsG21pAAAA:8 a=J1Y8HTJGAAAA:8 a=G6R51qgJZkie1HANS_gA:9 a=9RRF0ttvEvMA:10 a=v-EnS7xDjQoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202610.388961118@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 147/171 ] sky2: Receive Overflows not counted
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0147-sky2-Receive-Overflows-not-counted.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/marvell/sky2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
index 615ac63..ec6dcd8 100644
--- a/drivers/net/ethernet/marvell/sky2.h
+++ b/drivers/net/ethernet/marvell/sky2.h
@@ -2074,7 +2074,7 @@ enum {
 	GM_IS_RX_FF_OR	= 1<<1,	/* Receive FIFO Overrun */
 	GM_IS_RX_COMPL	= 1<<0,	/* Frame Reception Complete */
 
-#define GMAC_DEF_MSK     GM_IS_TX_FF_UR
+#define GMAC_DEF_MSK     (GM_IS_TX_FF_UR | GM_IS_RX_FF_OR)
 };
 
 /*	GMAC_LINK_CTRL	16 bit	GMAC Link Control Reg (YUKON only) */
-- 
1.7.10.4


