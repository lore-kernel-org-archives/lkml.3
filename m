Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3EPLPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:16 -0400
Received: from sauhun.de ([89.238.76.85]:56182 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3EPLPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:13 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 18/33] drivers/staging/dwc2: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:46 +0200
Message-Id: <1368702961-4325-19-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/staging/dwc2/platform.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/dwc2/platform.c b/drivers/staging/dwc2/platform.c
index 1f3d581..b610960 100644
--- a/drivers/staging/dwc2/platform.c
+++ b/drivers/staging/dwc2/platform.c
@@ -102,11 +102,6 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	}
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&dev->dev, "missing memory base resource\n");
-		return -EINVAL;
-	}
-
 	hsotg->regs = devm_ioremap_resource(&dev->dev, res);
 	if (IS_ERR(hsotg->regs))
 		return PTR_ERR(hsotg->regs);
-- 
1.7.10.4

