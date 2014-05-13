Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaEMDdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:33:22 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39801 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEMDdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:33:21 -0400
From: xuyongjiande@gmail.com
To: linux.nics@intel.com
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yongjian Xu <xuyongjiande@gmail.com>
Subject: [PATCH] e1000: To filter the negative skb->len
Date: Tue, 13 May 2014 11:33:07 +0800
Message-Id: <1399951987-10434-1-git-send-email-xuyongjiande@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yongjian Xu <xuyongjiande@gmail.com>

skb->len is unsigned int, "skb->len <= 0" should be "(int)(skb->len) <= 0".

Signed-off-by: Yongjian Xu <xuyongjiande@gmail.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 27058df..29dbfc8 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3105,7 +3105,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 	 */
 	tx_ring = adapter->tx_ring;
 
-	if (unlikely(skb->len <= 0)) {
+	if (unlikely((int)(skb->len) <= 0)) {
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
-- 
1.9.1

