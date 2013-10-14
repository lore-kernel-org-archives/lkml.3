Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab3JNP06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:26:58 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49841 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976Ab3JNP0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH v3 11/13] usb: phy: msm: Remove HSUSB prefix from requlator names
Date: Mon, 14 Oct 2013 18:24:38 +0300
Message-Id: <1381764280-28420-12-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Prefix did not bring any useful information.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 0bd3ba5..ca2abe6 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1420,19 +1420,19 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		return motg->irq;
 	}
 
-	motg->vddcx = devm_regulator_get(motg->phy.dev, "HSUSB_VDDCX");
+	motg->vddcx = devm_regulator_get(motg->phy.dev, "vddcx");
 	if (IS_ERR(motg->vddcx)) {
 		dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
 		return PTR_ERR(motg->vddcx);
 	}
 
-	motg->v3p3 = devm_regulator_get(motg->phy.dev, "HSUSB_3p3");
+	motg->v3p3 = devm_regulator_get(motg->phy.dev, "v3p3");
 	if (IS_ERR(motg->v3p3)) {
 		dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
 		return PTR_ERR(motg->v3p3);
 	}
 
-	motg->v1p8 = devm_regulator_get(motg->phy.dev, "HSUSB_1p8");
+	motg->v1p8 = devm_regulator_get(motg->phy.dev, "v1p8");
 	if (IS_ERR(motg->v1p8)) {
 		dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
 		return PTR_ERR(motg->v1p8);
-- 
1.7.9.5

