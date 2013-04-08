Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936268Ab3DHKIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:08:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42869 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935761Ab3DHJwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mirko Lindner <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 059/102] sky2: Threshold for Pause Packet is set wrong
Date: Mon,  8 Apr 2013 10:50:14 +0100
Message-Id: <1365414657-29191-60-git-send-email-luis.henriques@canonical.com>
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

commit 74f9f42c1c1650e74fb464f76644c9041f996851 upstream.

The sky2 driver sets the Rx Upper Threshold for Pause Packet generation to a
wrong value which leads to only 2kB of RAM remaining space. This can lead to
Rx overflow errors even with activated flow-control.

Fix: We should increase the value to 8192/8

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 05c2cac..af158e8 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1066,7 +1066,7 @@ static void sky2_ramset(struct sky2_hw *hw, u16 q, u32 start, u32 space)
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTHP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTHP), space/2);
 
-		tp = space - 2048/8;
+		tp = space - 8192/8;
 		sky2_write32(hw, RB_ADDR(q, RB_RX_UTPP), tp);
 		sky2_write32(hw, RB_ADDR(q, RB_RX_LTPP), space/4);
 	} else {
-- 
1.8.1.2

