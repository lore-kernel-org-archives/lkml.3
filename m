Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbbANHft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:35:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58637 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbbANHfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:35:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 14/77] ath5k: fix hardware queue index assignment
Date: Tue, 13 Jan 2015 23:22:54 -0800
Message-Id: <20150114072224.959767986@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 9e4982f6a51a2442f1bb588fee42521b44b4531c upstream.

Like with ath9k, ath5k queues also need to be ordered by priority.
queue_info->tqi_subtype already contains the correct index, so use it
instead of relying on the order of ath5k_hw_setup_tx_queue calls.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath5k/qcu.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -225,13 +225,7 @@ ath5k_hw_setup_tx_queue(struct ath5k_hw
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


