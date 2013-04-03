Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727Ab3DCKqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:46:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11150 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835Ab3DCKqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:46:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 03 Apr 2013 03:45:10 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <swarren@wwwdotorg.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH resend] usb: host: tegra: Reset Tegra USB controller before init
Date: Wed, 3 Apr 2013 16:11:12 +0530
Message-ID: <1364985672-3725-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clear any configurations made by U-Boot on Tegra USB controller,
reset it before init in probe.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
reviewed-by: Stephen Warren <swarren@nvidia.com>
---
This patch was already reviewed at:  
http://marc.info/?l=linux-usb&m=136203353205291&w=2

 drivers/usb/host/ehci-tegra.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 1d2488c..60ed5d1 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/usb/ehci_def.h>
 #include <linux/usb/tegra_usb_phy.h>
+#include <linux/clk/tegra.h>
 
 #define TEGRA_USB_BASE			0xC5000000
 #define TEGRA_USB2_BASE			0xC5004000
@@ -691,6 +692,10 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	if (err)
 		goto fail_clk;
 
+	tegra_periph_reset_assert(tegra->clk);
+	udelay(1);
+	tegra_periph_reset_deassert(tegra->clk);
+
 	tegra->needs_double_reset = of_property_read_bool(pdev->dev.of_node,
 		"nvidia,needs-double-reset");
 
-- 
1.7.0.4

