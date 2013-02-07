Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3BGQGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:06:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43453 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab3BGQDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:03:24 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <b-cousson@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <linux@arm.linux.org.uk>, <kishon@ti.com>,
        <mark.rutland@arm.com>, <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 06/14] USB: ohci-omap3: Get platform resources by index rather than by name
Date: Thu, 7 Feb 2013 18:02:46 +0200
Message-ID: <1360252974-7912-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360252974-7912-1-git-send-email-rogerq@ti.com>
References: <1360252974-7912-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is only one resource per type we don't really need
to use resource name to obtain it. This also also makes it easier
for device tree adaptation.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-omap3.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index eb35d96..5ed28c5 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -141,14 +141,13 @@ static int ohci_hcd_omap3_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	irq = platform_get_irq_byname(pdev, "ohci-irq");
+	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(dev, "OHCI irq failed\n");
 		return -ENODEV;
 	}
 
-	res = platform_get_resource_byname(pdev,
-				IORESOURCE_MEM, "ohci");
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(dev, "UHH OHCI get resource failed\n");
 		return -ENOMEM;
-- 
1.7.4.1

