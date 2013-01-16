Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3APOp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:45:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45242 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3APOpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:45:22 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v6 18/22] USB: ehci-omap: Don't free gpios that we didn't request
Date: Wed, 16 Jan 2013 16:43:49 +0200
Message-ID: <1358347433-329-19-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358347433-329-1-git-send-email-rogerq@ti.com>
References: <1358347433-329-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver does not request any gpios so don't free them.
Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
with ehci-omap in use.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 134c789..b96a4bf 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -288,7 +288,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
 	struct device *dev				= &pdev->dev;
 	struct usb_hcd *hcd				= dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data *pdata		= dev->platform_data;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
@@ -298,13 +297,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_free(pdata->reset_gpio_port[0]);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_free(pdata->reset_gpio_port[1]);
-	}
 	return 0;
 }
 
-- 
1.7.4.1

