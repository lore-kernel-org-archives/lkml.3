Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab3GWSDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:03:52 -0400
Received: from sauhun.de ([89.238.76.85]:58769 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933643Ab3GWSDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:03:50 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 19/27] drivers/usb/phy: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:52 +0200
Message-Id: <1374602524-3398-20-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/usb/phy/phy-rcar-usb.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/usb/phy/phy-rcar-usb.c b/drivers/usb/phy/phy-rcar-usb.c
index ae90940..deb7f97 100644
--- a/drivers/usb/phy/phy-rcar-usb.c
+++ b/drivers/usb/phy/phy-rcar-usb.c
@@ -190,11 +190,6 @@ static int rcar_usb_phy_probe(struct platform_device *pdev)
 	}
 
 	res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res0) {
-		dev_err(dev, "Not enough platform resources\n");
-		return -EINVAL;
-	}
-
 	reg0 = devm_ioremap_resource(dev, res0);
 	if (IS_ERR(reg0))
 		return PTR_ERR(reg0);
-- 
1.7.10.4

