Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161116Ab3DKVU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:20:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935463Ab3DKUsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:54 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ldP8bsAfXrQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FlX38IoGXR8A:10 a=M5GUcnROAAAA:8 a=jZVsG21pAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=9RRF0ttvEvMA:10 a=v-EnS7xDjQoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202610.552846384@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 148/171 ] sky2: Threshold for Pause Packet is set wrong
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0148-sky2-Threshold-for-Pause-Packet-is-set-wrong.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mirko Lindner <mlindner@marvell.com>

[ Upstream commit 74f9f42c1c1650e74fb464f76644c9041f996851 ]

The sky2 driver sets the Rx Upper Threshold for Pause Packet generation to a
wrong value which leads to only 2kB of RAM remaining space. This can lead to
Rx overflow errors even with activated flow-control.

Fix: We should increase the value to 8192/8

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/marvell/sky2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 2b0748d..c8d7e5f 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1067,7 +1067,7 @@ static void sky2_ramset(struct sky2_hw *hw, u16 q, u32 start, u32 space)
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTHP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTHP), space/2);
 
-		tp = space - 2048/8;
+		tp = space - 8192/8;
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTPP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTPP), space/4);
 	} else {
-- 
1.7.10.4


