Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbbA2J7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:59:02 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44779 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758308AbbA2JCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 008/176] ath5k: fix hardware queue index assignment
Date: Wed, 28 Jan 2015 15:27:18 +0100
Message-Id: <939c0896c85b324de081975d21b77b7678fff2af.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9e4982f6a51a2442f1bb588fee42521b44b4531c upstream.

Like with ath9k, ath5k queues also need to be ordered by priority.
queue_info->tqi_subtype already contains the correct index, so use it
instead of relying on the order of ath5k_hw_setup_tx_queue calls.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.2.2

