Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaHTLs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:48:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59057 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/104] e1000: fix wrong queue idx calculation
Date: Wed, 20 Aug 2014 13:43:36 +0200
Message-Id: <da4a978cbadcf5641ba5a33e365e126474cf42e5.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Zhiguo <zhiguohong@tencent.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 49a45a0686cc2b43bcb3834a68416a201475dc77 upstream.

tx_ring and adapter->tx_ring are already of type "struct
e1000_tx_ring *"

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 59ad007dd5aa..ad6800ad1bfc 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3917,8 +3917,7 @@ static bool e1000_clean_tx_irq(struct e1000_adapter *adapter,
 			      "  next_to_watch        <%x>\n"
 			      "  jiffies              <%lx>\n"
 			      "  next_to_watch.status <%x>\n",
-				(unsigned long)((tx_ring - adapter->tx_ring) /
-					sizeof(struct e1000_tx_ring)),
+				(unsigned long)(tx_ring - adapter->tx_ring),
 				readl(hw->hw_addr + tx_ring->tdh),
 				readl(hw->hw_addr + tx_ring->tdt),
 				tx_ring->next_to_use,
-- 
2.0.4

