Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaHKD3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:29:07 -0400
Received: from s87.loopia.se ([194.9.94.112]:51852 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaHKD3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:29:06 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH] staging: rtl8192ee: fix %d confusingly prefixed with 0x in format strings
Date: Sun, 10 Aug 2014 20:28:42 -0700
Message-Id: <1407727722-28095-2-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1407727722-28095-1-git-send-email-hans@hanshq.net>
References: <20140810042358.GA15249@kroah.com>
 <1407727722-28095-1-git-send-email-hans@hanshq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/staging/rtl8192ee/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192ee/pci.c b/drivers/staging/rtl8192ee/pci.c
index 0215aef..349e636 100644
--- a/drivers/staging/rtl8192ee/pci.c
+++ b/drivers/staging/rtl8192ee/pci.c
@@ -649,7 +649,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 
 		if ((ring->entries - skb_queue_len(&ring->queue)) == 2) {
 			RT_TRACE(COMP_ERR, DBG_LOUD,
-				 ("more desc left, wake skb_queue@%d,ring->idx = %d, skb_queue_len = 0x%d\n",
+				 ("more desc left, wake skb_queue@%d,ring->idx = %d, skb_queue_len = 0x%x\n",
 					 prio, ring->idx,
 					 skb_queue_len(&ring->queue)));
 
@@ -1628,7 +1628,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 
 		if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
 			RT_TRACE(COMP_ERR, DBG_WARNING,
-				 ("No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+				 ("No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%x\n",
 				  hw_queue, ring->idx, idx,
 				  skb_queue_len(&ring->queue)));
 
@@ -1670,7 +1670,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 	if ((ring->entries - skb_queue_len(&ring->queue)) < 2 &&
 	    hw_queue != BEACON_QUEUE) {
 		RT_TRACE(COMP_ERR, DBG_LOUD,
-			 ("less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+			 ("less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%x\n",
 			  hw_queue, ring->idx, idx,
 			  skb_queue_len(&ring->queue)));
 
-- 
2.0.0.526.g5318336

