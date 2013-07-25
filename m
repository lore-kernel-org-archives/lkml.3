Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab3GYSic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:38:32 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7869 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab3GYSi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:38:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 25 Jul 2013 11:37:14 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 3/9] usb: tegra: host: Remove references to plat data
Date: Thu, 25 Jul 2013 21:38:03 +0300
Message-ID: <1374777489-13093-4-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1374777489-13093-1-git-send-email-ttynkkynen@nvidia.com>
References: <1374777489-13093-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data is not used in tegra-ehci anymore, so remove all
references to it.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/usb/host/ehci-tegra.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 06e8feb..a208cea 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -27,7 +27,6 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_device.h>
-#include <linux/platform_data/tegra_usb.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/usb/ehci_def.h>
@@ -327,18 +326,11 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	struct ehci_hcd *ehci;
 	struct tegra_ehci_hcd *tegra;
-	struct tegra_ehci_platform_data *pdata;
 	int err = 0;
 	int irq;
 	struct device_node *np_phy;
 	struct usb_phy *u_phy;
 
-	pdata = pdev->dev.platform_data;
-	if (!pdata) {
-		dev_err(&pdev->dev, "Platform data missing\n");
-		return -EINVAL;
-	}
-
 	/* Right now device-tree probed devices don't get dma_mask set.
 	 * Since shared usb code relies on it, set it here for now.
 	 * Once we have dma capability bindings this can go away.
-- 
1.8.1.5

