Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3KTUWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:22:09 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59760 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3KTUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:22:04 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 6/7] net: mvneta: resume/suspend PHY on port start/stop
Date: Wed, 20 Nov 2013 21:21:52 +0100
Message-Id: <1384978913-8052-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network PHYs consume a noticable amount of power. This adds phy_resume
on start_dev and phy_suspend on stop_dev to save this power if the
port is down anyway.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/mvneta.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b8e232b..8688e91 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2194,6 +2194,7 @@ static void mvneta_start_dev(struct mvneta_port *pp)
 	mvreg_write(pp, MVNETA_INTR_NEW_MASK,
 		    MVNETA_RX_INTR_MASK(rxq_number));
 
+	phy_resume(pp->phy_dev);
 	phy_start(pp->phy_dev);
 	netif_tx_start_all_queues(pp->dev);
 }
@@ -2201,6 +2202,7 @@ static void mvneta_start_dev(struct mvneta_port *pp)
 static void mvneta_stop_dev(struct mvneta_port *pp)
 {
 	phy_stop(pp->phy_dev);
+	phy_suspend(pp->phy_dev);
 
 	napi_disable(&pp->napi);
 
-- 
1.7.2.5

