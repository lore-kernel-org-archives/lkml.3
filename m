Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3EWAA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 20:00:56 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:36663 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3EWAAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 20:00:54 -0400
From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
To: sfr@canb.auug.org.au, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
Subject: [PATCH 3/3] net: ethernet: sun: drop unused variable
Date: Wed, 22 May 2013 20:57:37 -0300
Message-Id: <1369267057-9371-3-git-send-email-emilio@elopez.com.ar>
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

Commit bfd428d ("net: ethernet: sun: initialize variables directly")
dropped the only loop that was using i but did not remove the actual
variable, therefore causing a warning when building. This patch drops
the now redundant line.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/net/ethernet/sun/sunbmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index 09b4f8c..0d43fa9 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -995,7 +995,6 @@ static void bigmac_set_multicast(struct net_device *dev)
 	struct bigmac *bp = netdev_priv(dev);
 	void __iomem *bregs = bp->bregs;
 	struct netdev_hw_addr *ha;
-	int i;
 	u32 tmp, crc;
 
 	/* Disable the receiver.  The bit self-clears when
-- 
1.8.2.3

