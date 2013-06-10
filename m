Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3FJLux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:53 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47415 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3FJLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:50:50 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 14/15] usb: phy: rcar-usb: Fix comment w.r.t. devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:05:12 +0530
Message-Id: <1370864113-17895-15-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: linux-usb@vger.kernel.org
CC: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/phy/phy-rcar-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-rcar-usb.c b/drivers/usb/phy/phy-rcar-usb.c
index a35681b..23c3dd3 100644
--- a/drivers/usb/phy/phy-rcar-usb.c
+++ b/drivers/usb/phy/phy-rcar-usb.c
@@ -161,7 +161,7 @@ static int rcar_usb_phy_probe(struct platform_device *pdev)
 	 * CAUTION
 	 *
 	 * Because this phy address is also mapped under OHCI/EHCI address area,
-	 * this driver can't use devm_request_and_ioremap(dev, res) here
+	 * this driver can't use devm_ioremap_resource(dev, res) here
 	 */
 	reg0 = devm_ioremap_nocache(dev, res0->start, resource_size(res0));
 	reg1 = devm_ioremap_nocache(dev, res1->start, resource_size(res1));
-- 
1.7.9.5

