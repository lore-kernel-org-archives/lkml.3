Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbbA2CgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:36:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964969AbbA2CgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 064/139] ath5k: fix hardware queue index assignment
Date: Wed, 28 Jan 2015 14:20:07 -0800
Message-Id: <1422483682-15393-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 9e4982f6a51a2442f1bb588fee42521b44b4531c upstream.

Like with ath9k, ath5k queues also need to be ordered by priority.
queue_info->tqi_subtype already contains the correct index, so use it
instead of relying on the order of ath5k_hw_setup_tx_queue calls.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath5k/qcu.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 0583c69..ddaad71 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -225,13 +225,7 @@ ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 	} else {
 		switch (queue_type) {
 		case AR5K_TX_QUEUE_DATA:
-			for (queue = AR5K_TX_QUEUE_ID_DATA_MIN;
-				ah->ah_txq[queue].tqi_type !=
-				AR5K_TX_QUEUE_INACTIVE; queue++) {
-
-				if (queue > AR5K_TX_QUEUE_ID_DATA_MAX)
-					return -EINVAL;
-			}
+			queue = queue_info->tqi_subtype;
 			break;
 		case AR5K_TX_QUEUE_UAPSD:
 			queue = AR5K_TX_QUEUE_ID_UAPSD;
-- 
1.9.1

