Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab3LFVwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3LFVwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 01/83] net: mv643xx_eth: Add missing phy_addr_set in DT mode
Date: Fri,  6 Dec 2013 13:50:51 -0800
Message-Id: <20131206214640.198508936@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Commit cc9d4598 'net: mv643xx_eth: use of_phy_connect if phy_node
present' made the call to phy_scan optional, if the DT has a link to
the phy node.

However phy_scan has the side effect of calling phy_addr_set, which
writes the phy MDIO address to the ethernet controller. If phy_addr_set
is not called, and the bootloader has not set the correct address then
the driver will fail to function.

Tested on Kirkwood.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2890,6 +2890,7 @@ static int mv643xx_eth_probe(struct plat
 					 PHY_INTERFACE_MODE_GMII);
 		if (!mp->phy)
 			err = -ENODEV;
+		phy_addr_set(mp, mp->phy->addr);
 	} else if (pd->phy_addr != MV643XX_ETH_PHY_NONE) {
 		mp->phy = phy_scan(mp, pd->phy_addr);
 


