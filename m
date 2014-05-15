Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaEOSaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:30:55 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:56841 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaEOSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:30:54 -0400
From: greearb@candelatech.com
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Ensure rx-frag ignores rssi.
Date: Thu, 15 May 2014 11:30:51 -0700
Message-Id: <1400178651-25594-1-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

It seems ath10k firmware gives us no way to know
the rssi for rx-fragments.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Patch is against my tree, hopefully will apply OK against upstream
but have not tested that yet.

 drivers/net/wireless/ath/ath10k/htt_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f94ac44..f62b0e4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1343,6 +1343,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	}
 
 	/* FIXME: implement signal strength */
+	rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 	hdr = (struct ieee80211_hdr *)msdu_head->data;
 	rxd = (void *)msdu_head->data - sizeof(*rxd);
-- 
1.7.11.7

