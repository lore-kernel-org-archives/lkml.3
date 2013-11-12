Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab3KLO6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:58:50 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51859 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab3KLOyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:21 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v4 08/15] usb: phy: msm: Remove HSUSB prefix from regulator names
Date: Tue, 12 Nov 2013 16:51:43 +0200
Message-Id: <1384267910-32066-9-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Prefix did not bring any useful information. Currently none
of the MSM platforms define these regulators, so it is safe
to rename them.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 9e9d4a3..258bca2 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1417,19 +1417,19 @@ static int __init msm_otg_probe(struct platform_device *pdev)
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

