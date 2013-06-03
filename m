Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3FCHyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:54:46 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40119 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCHyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:54:37 -0400
From: Huawei Yang <harvey.huawei.yang@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huawei Yang <harvey.huawei.yang@gmail.com>
Subject: [RFC PATCH 1/1] mwifiex: Remove stop_net_dev_queue operation when uap handling packets forwarding.
Date: Mon,  3 Jun 2013 15:54:20 +0800
Message-Id: <1370246060-9087-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under uap mode mwifiex may stop all net tx queues on forwarding packets. This may stop some tx queues and they never have chance to be waked up... There is also no need to check tx_pending and stop queues here. Because local host has such kind of check when transmitting packets and it's not proper to have forwarding affect local transmitting.

Signed-off-by: Huawei Yang <harvey.huawei.yang@gmail.com>
---
 drivers/net/wireless/mwifiex/uap_txrx.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index a018e42..11df2b2 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -95,10 +95,6 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	atomic_inc(&adapter->tx_pending);
 	atomic_inc(&adapter->pending_bridged_pkts);
 
-	if ((atomic_read(&adapter->tx_pending) >= MAX_TX_PENDING)) {
-		mwifiex_set_trans_start(priv->netdev);
-		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
-	}
 	return;
 }
 
-- 
1.7.10.4

