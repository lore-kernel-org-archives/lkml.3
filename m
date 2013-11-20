Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3KTUX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:23:57 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:41831 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3KTUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:22:04 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 7/7] net: cpsw: resume/suspend PHY on port start/stop
Date: Wed, 20 Nov 2013 21:21:53 +0100
Message-Id: <1384978913-8052-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network PHYs consume a noticable amount of power. This adds phy_resume
on slave_open and phy_suspend on slave_stop to save this power if the
port is down anyway.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/ti/cpsw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 90d41d2..f1dc54f 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1013,6 +1013,7 @@ static void cpsw_slave_open(struct cpsw_slave *slave, struct cpsw_priv *priv)
 	} else {
 		dev_info(priv->dev, "phy found : id is : 0x%x\n",
 			 slave->phy->phy_id);
+		phy_resume(slave->phy);
 		phy_start(slave->phy);
 
 		/* Configure GMII_SEL register */
@@ -1081,6 +1082,7 @@ static void cpsw_slave_stop(struct cpsw_slave *slave, struct cpsw_priv *priv)
 	if (!slave->phy)
 		return;
 	phy_stop(slave->phy);
+	phy_suspend(slave->phy);
 	phy_disconnect(slave->phy);
 	slave->phy = NULL;
 }
-- 
1.7.2.5

