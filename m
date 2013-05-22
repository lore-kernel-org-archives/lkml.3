Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab3EWAAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 20:00:39 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36659 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab3EWAAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 20:00:38 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: sfr@canb.auug.org.au, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH 2/3] net: ethernet: korina: drop unused variable
Date: Wed, 22 May 2013 20:57:36 -0300
Message-Id: <1369267057-9371-2-git-send-email-emilio@elopez.com.ar>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369267057-9371-1-git-send-email-emilio@elopez.com.ar>
References: <20130522.122624.266893118412034519.davem@davemloft.net>
 <1369267057-9371-1-git-send-email-emilio@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e998fd4 ("net: ethernet: korina: initialize variables directly")
dropped the only loop that was using i but did not remove the actual
variable, therefore causing a warning when building. This patch drops
the now redundant line.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/net/ethernet/korina.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 0b57085..e7851d1 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -483,7 +483,6 @@ static void korina_multicast_list(struct net_device *dev)
 	unsigned long flags;
 	struct netdev_hw_addr *ha;
 	u32 recognise = ETH_ARC_AB;	/* always accept broadcasts */
-	int i;
 
 	/* Set promiscuous mode */
 	if (dev->flags & IFF_PROMISC)
-- 
1.8.2.3

