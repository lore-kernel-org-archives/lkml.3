Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaEOKSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:18:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54445 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754293AbaEOKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:18:16 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v6 01/17] usb: ehci-orion: use platform_get_irq() for DT probing
Date: Thu, 15 May 2014 12:17:26 +0200
Message-Id: <1400149062-32661-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Commit 77dae54ab385033e488d8b07045bc7f8d931740f ('ARM: Kirkwood:
ehci-orion: Add device tree binding') added the Device Tree binding
for the ehci-orion driver. To achieve that with the irq, it used the
irq_of_parse_and_map() function when probed in DT-mode, and
platform_get_irq() when probed in non-DT mode.

This is not necessary: platform_get_irq() works just as fine in
DT-mode, since the conversion from DT information to 'struct resource'
is done by the generic layers of the kernel.

Therefore, this commit switches back to use just platform_get_irq().

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-orion.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 30d35e5e503a..7728e83007a7 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -154,10 +154,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 
 	pr_debug("Initializing Orion-SoC USB Host Controller\n");
 
-	if (pdev->dev.of_node)
-		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
-	else
-		irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_err(&pdev->dev,
 			"Found HC with no IRQ. Check %s setup!\n",
-- 
1.8.1.2

