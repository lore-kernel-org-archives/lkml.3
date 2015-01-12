Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbbALSGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbbALSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 063/216] ath9k_hw: fix hardware queue allocation
Date: Mon, 12 Jan 2015 18:03:00 +0000
Message-Id: <1421085933-32536-64-git-send-email-luis.henriques@canonical.com>
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

commit ad8fdccf9c197a89e2d2fa78c453283dcc2c343f upstream.

The driver passes the desired hardware queue index for a WMM data queue
in qinfo->tqi_subtype. This was ignored in ath9k_hw_setuptxqueue, which
instead relied on the order in which the function is called.

Reported-by: Hubert Feurstein <h.feurstein@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/mac.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 275205ab5f15..3e58bfa0c1fd 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -311,14 +311,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 		q = ATH9K_NUM_TX_QUEUES - 3;
 		break;
 	case ATH9K_TX_QUEUE_DATA:
-		for (q = 0; q < ATH9K_NUM_TX_QUEUES; q++)
-			if (ah->txq[q].tqi_type ==
-			    ATH9K_TX_QUEUE_INACTIVE)
-				break;
-		if (q == ATH9K_NUM_TX_QUEUES) {
-			ath_err(common, "No available TX queue\n");
-			return -1;
-		}
+		q = qinfo->tqi_subtype;
 		break;
 	default:
 		ath_err(common, "Invalid TX queue type: %u\n", type);
-- 
2.1.4

