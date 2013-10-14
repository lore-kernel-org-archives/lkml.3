Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3JNP07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:26:59 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49840 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974Ab3JNP0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:07 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 12/13] usb: phy: msm: Properly check core interrupt number
Date: Mon, 14 Oct 2013 18:24:39 +0300
Message-Id: <1381764280-28420-13-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

IRQ with number 0 is valid case, so check for negative
numbers instead.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index ca2abe6..f34c8a9 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1415,7 +1415,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "OTG regs = %p\n", motg->regs);
 
 	motg->irq = platform_get_irq(pdev, 0);
-	if (!motg->irq) {
+	if (motg->irq < 0) {
 		dev_err(&pdev->dev, "platform_get_irq failed\n");
 		return motg->irq;
 	}
-- 
1.7.9.5

