Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaHDAVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:21:20 -0400
Received: from s87.loopia.se ([194.9.94.112]:35871 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbaHDAVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:21:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 17/19] staging: rtl8821ae: fix %d confusingly prefixed with 0x in format strings
Date: Sun,  3 Aug 2014 17:21:06 -0700
Message-Id: <1407111666-15274-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/staging/rtl8821ae/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index 26d7b2f..b818788 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -662,7 +662,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 			RT_TRACE(COMP_ERR, DBG_LOUD,
 					("more desc left, wake"
 					 "skb_queue@%d,ring->idx = %d,"
-					 "skb_queue_len = 0x%d\n",
+					 "skb_queue_len = 0x%x\n",
 					 prio, ring->idx,
 					 skb_queue_len(&ring->queue)));
 
@@ -1650,7 +1650,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 		if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
 			RT_TRACE(COMP_ERR, DBG_WARNING,
 				 ("No more TX desc@%d, ring->idx = %d,"
-				  "idx = %d, skb_queue_len = 0x%d\n",
+				  "idx = %d, skb_queue_len = 0x%x\n",
 				  hw_queue, ring->idx, idx,
 				  skb_queue_len(&ring->queue)));
 
@@ -1695,7 +1695,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 		RT_TRACE(COMP_ERR, DBG_LOUD,
 			 ("less desc left, stop skb_queue@%d, "
 			  "ring->idx = %d,"
-			  "idx = %d, skb_queue_len = 0x%d\n",
+			  "idx = %d, skb_queue_len = 0x%x\n",
 			  hw_queue, ring->idx, idx,
 			  skb_queue_len(&ring->queue)));
 
-- 
2.0.0.526.g5318336

