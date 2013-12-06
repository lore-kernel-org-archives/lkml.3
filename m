Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161616Ab3LFWot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:44:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab3LFVwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 02/83] net: mv643xx_eth: potential NULL dereference in probe()
Date: Fri,  6 Dec 2013 13:50:52 -0800
Message-Id: <20131206214640.286784135@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

upstream commit 6115c11fe1a5a636ac99fc823b00df4ff3c0674e

We assume that "mp->phy" can be NULL a couple lines before the
dereference.

Fixes: 1cce16d37d0f ('net: mv643xx_eth: Add missing phy_addr_set in DT mode')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2890,7 +2890,8 @@ static int mv643xx_eth_probe(struct plat
 					 PHY_INTERFACE_MODE_GMII);
 		if (!mp->phy)
 			err = -ENODEV;
-		phy_addr_set(mp, mp->phy->addr);
+		else
+			phy_addr_set(mp, mp->phy->addr);
 	} else if (pd->phy_addr != MV643XX_ETH_PHY_NONE) {
 		mp->phy = phy_scan(mp, pd->phy_addr);
 


