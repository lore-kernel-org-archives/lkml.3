Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbbA2JID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:08:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44915 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932456AbbA2JHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:55 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/176] ath9k_hw: fix hardware queue allocation
Date: Wed, 28 Jan 2015 15:27:14 +0100
Message-Id: <7a2dbfb651aeb95a78029b01af55cde96a2f8db7.1422455352.git.jslaby@suse.cz>
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

commit ad8fdccf9c197a89e2d2fa78c453283dcc2c343f upstream.

The driver passes the desired hardware queue index for a WMM data queue
in qinfo->tqi_subtype. This was ignored in ath9k_hw_setuptxqueue, which
instead relied on the order in which the function is called.

Reported-by: Hubert Feurstein <h.feurstein@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/ath/ath9k/mac.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index a3eff0986a3f..02446801cb3a 100644
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
2.2.2

