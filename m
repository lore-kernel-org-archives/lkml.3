Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3CaVGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 17:06:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56579 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3CaVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 17:06:07 -0400
Date: Sun, 31 Mar 2013 23:06:05 +0200
From: Pavel Machek <pavel@denx.de>
To: kernel list <linux-kernel@vger.kernel.org>, fabio.estevam@freescale.com,
        l.stach@pengutronix.de, Frank.Li@freescale.com, netdev@vger.kernel.org
Subject: Freescale FEC: fall back to random address
Message-ID: <20130331210605.GA29191@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there's no valid ethernet address, fall back to randomly generated
one.

(Yes, I need to get newer u-boot for the board, but as the only
available one is from 2009... this might be good idea).

Signed-off-by: Pavel Machek <pavel@denx.de>


index e3f3937..5a7d1e1 100644
pp--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -906,6 +914,16 @@ static void fec_get_mac(struct net_device *ndev)
 		iap = &tmpaddr[0];
 	}
 
+	/*
+	 * 5) random mac address
+	 */
+	if (!is_valid_ether_addr(iap)) {
+		/* Report it and use a random ethernet address instead */
+		netdev_err(ndev, "Invalid MAC address: %pM\n", iap);
+		random_ether_addr(iap);
+		netdev_info(ndev, "Using random MAC address: %pM\n", iap);
+	}
+
 	memcpy(ndev->dev_addr, iap, ETH_ALEN);
 
 	/* Adjust MAC if using macaddr */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
