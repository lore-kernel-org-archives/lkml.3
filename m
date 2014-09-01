Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaIAOZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:25:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31564 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaIAOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:25:41 -0400
X-AuditID: cbfee61b-f79f86d00000144c-74-540481e364bd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: sh_eth: fix driver dependencies
Date: Mon, 01 Sep 2014 16:25:35 +0200
Message-id: <1749721.1a6rN6K2Gg@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd3HjSwhBrc6NCzmnG9hsWje+pXR
	4mzTG3aLy7vmsFnM+TOF2eLB6rdsFscWiDmwe2xZeZPJY+esu+wefVtWMXrM+fmNxePzJrkA
	1igum5TUnMyy1CJ9uwSujDPvnzEXrGKvaDlwhLGBcRFbFyMnh4SAicTUtsWsELaYxIV764Hi
	XBxCAosYJVo3bYNyWpgk+ld+ZAepYhOwkpjYvooRxBYR0JZYd6CHFaSIWeAko8TaSRBjhQUs
	JH7taWUCsVkEVCWWn//BDGLzCmhK3Lo/EWyQqICnxI7tK9kg4oISPybfYwGxmQXkJfbtn8oK
	YWtJrN95nGkCI98sJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw2D6T
	3sG4qsHiEKMAB6MSD++DWcwhQqyJZcWVuYcYJTiYlUR4UzNYQoR4UxIrq1KL8uOLSnNSiw8x
	SnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwCp/XUzVsvbh51yNf278Mix6veK7L1mPu
	tSD06oMFy8LmrD163Xl9Tmz6vx/ZJ2/M1F+/Y8bsQxGis2OVDxgFHVl3ucC60rOjpbNs7RnX
	gqfrSu4tO7qBPX8rY9RNh5+Jc/5y715isv09a8jDn2Z/o191hFyuE1gUdPoJv0yueaR+kK/e
	3ZUvLiqxFGckGmoxFxUnAgBH5UAVVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renesas SuperH Ethernet support should be available only on
Renesas ARM SoCs and SuperH architecture.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
---
v2:
- s/ARCH_SH/SUPERH/ (thanks to Sergei Shtylyov)

 drivers/net/ethernet/renesas/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/net/ethernet/renesas/Kconfig
===================================================================
--- a/drivers/net/ethernet/renesas/Kconfig	2014-07-30 14:31:20.479522692 +0200
+++ b/drivers/net/ethernet/renesas/Kconfig	2014-09-01 14:45:36.160544016 +0200
@@ -5,6 +5,7 @@
 config SH_ETH
 	tristate "Renesas SuperH Ethernet support"
 	depends on HAS_DMA
+	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
 	select CRC32
 	select MII
 	select MDIO_BITBANG

