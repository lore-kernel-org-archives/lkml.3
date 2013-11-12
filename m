Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3KLO51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:57:27 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51877 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab3KLOyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:22 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v4 09/15] usb: phy: msm: Properly check result from platform_get_irq()
Date: Tue, 12 Nov 2013 16:51:44 +0200
Message-Id: <1384267910-32066-10-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Function return negative code on error.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 258bca2..fa8e672d 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1412,7 +1412,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "OTG regs = %p\n", motg->regs);
 
 	motg->irq = platform_get_irq(pdev, 0);
-	if (!motg->irq) {
+	if (motg->irq < 0) {
 		dev_err(&pdev->dev, "platform_get_irq failed\n");
 		return motg->irq;
 	}
-- 
1.7.9.5

