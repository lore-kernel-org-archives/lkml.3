Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3APOqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:46:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37858 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab3APOpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:45:30 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v6 21/22] mfd: omap-usb-host: Don't spam console on clk_set_parent failure
Date: Wed, 16 Jan 2013 16:43:52 +0200
Message-ID: <1358347433-329-22-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358347433-329-1-git-send-email-rogerq@ti.com>
References: <1358347433-329-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_set_parent is expected to fail on OMAP3 platforms. We don't
consider that as fatal so don't spam console.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 38ec73d..56b6f69 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -668,32 +668,32 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
-		/* for OMAP3 , the clk set paretn fails */
+		/* for OMAP3, clk_set_parent fails */
 		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->xclk60mhsp1_ck);
 		if (ret != 0)
-			dev_err(dev, "xclk60mhsp1_ck set parent"
-				"failed error:%d\n", ret);
+			dev_dbg(dev, "xclk60mhsp1_ck set parent failed: %d\n",
+					ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[0])) {
 		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->init_60m_fclk);
 		if (ret != 0)
-			dev_err(dev, "init_60m_fclk set parent"
-				"failed error:%d\n", ret);
+			dev_dbg(dev, "P0 init_60m_fclk set parent failed: %d\n",
+					ret);
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[1])) {
 		ret = clk_set_parent(omap->utmi_p2_gfclk,
 					omap->xclk60mhsp2_ck);
 		if (ret != 0)
-			dev_err(dev, "xclk60mhsp2_ck set parent"
-					"failed error:%d\n", ret);
+			dev_dbg(dev, "xclk60mhsp2_ck set parent failed: %d\n",
+					ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[1])) {
 		ret = clk_set_parent(omap->utmi_p2_gfclk,
 						omap->init_60m_fclk);
 		if (ret != 0)
-			dev_err(dev, "init_60m_fclk set parent"
-				"failed error:%d\n", ret);
+			dev_dbg(dev, "P1 init_60m_fclk set parent failed: %d\n",
+					ret);
 	}
 
 	omap_usbhs_init(dev);
-- 
1.7.4.1

