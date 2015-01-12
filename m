Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbbALSTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:19:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbbALSGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 065/216] ath5k: fix hardware queue index assignment
Date: Mon, 12 Jan 2015 18:03:02 +0000
Message-Id: <1421085933-32536-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 9e4982f6a51a2442f1bb588fee42521b44b4531c upstream.

Like with ath9k, ath5k queues also need to be ordered by priority.
queue_info->tqi_subtype already contains the correct index, so use it
instead of relying on the order of ath5k_hw_setup_tx_queue calls.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath5k/qcu.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 0583c69d26db..ddaad712c59a 100644
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
2.1.4

