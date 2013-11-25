Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3KYKG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:06:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46425 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3KYKCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:02:33 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v3 01/10] usb: dwc3: invoke phy_resume after phy_init
Date: Mon, 25 Nov 2013 15:31:21 +0530
Message-ID: <1385373690-12170-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385373690-12170-1-git-send-email-kishon@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_phy_set_suspend(phy, 0) is called before usb_phy_init. Fix it.

Reported-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 74f9cf0..4dd1f7e 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -455,9 +455,6 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
 
-	usb_phy_set_suspend(dwc->usb2_phy, 0);
-	usb_phy_set_suspend(dwc->usb3_phy, 0);
-
 	spin_lock_init(&dwc->lock);
 	platform_set_drvdata(pdev, dwc);
 
@@ -488,6 +485,9 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
+	usb_phy_set_suspend(dwc->usb2_phy, 0);
+	usb_phy_set_suspend(dwc->usb3_phy, 0);
+
 	ret = dwc3_event_buffers_setup(dwc);
 	if (ret) {
 		dev_err(dwc->dev, "failed to setup event buffers\n");
-- 
1.7.10.4

