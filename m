Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966092Ab3DQIYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 04:24:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46073 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966075Ab3DQIYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 04:24:38 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <holler@ahsoftware.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 2/2] USB: ehci-omap: Improve PHY error handling
Date: Wed, 17 Apr 2013 11:24:25 +0300
Message-ID: <1366187065-10795-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366026636-29198-2-git-send-email-rogerq@ti.com>
References: <1366026636-29198-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the USB PHY layer never returns NULL we don't need
to check for that condition.

CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 5de3e43..3d1491b 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -175,12 +175,12 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 			phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
 		else
 			phy = devm_usb_get_phy_dev(dev, i);
-		if (IS_ERR(phy) || !phy) {
+		if (IS_ERR(phy)) {
 			/* Don't bail out if PHY is not absolutely necessary */
 			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
 				continue;
 
-			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
+			ret = PTR_ERR(phy);
 			dev_err(dev, "Can't get PHY device for port %d: %d\n",
 					i, ret);
 			goto err_phy;
-- 
1.7.4.1

