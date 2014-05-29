Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbaE2GdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:33:20 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39668 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbaE2GdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:33:17 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kishon@ti.com, sachin.kamat@linaro.org,
        Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/3] phy: sun4i-usb: Use PTR_ERR_OR_ZERO
Date: Thu, 29 May 2014 12:00:49 +0530
Message-Id: <1401345049-14779-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
References: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTR_ERR_OR_ZERO simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/phy/phy-sun4i-usb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
index 115d8d5190d5..7a4ea552f621 100644
--- a/drivers/phy/phy-sun4i-usb.c
+++ b/drivers/phy/phy-sun4i-usb.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -306,10 +307,8 @@ static int sun4i_usb_phy_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, data);
 	phy_provider = devm_of_phy_provider_register(dev, sun4i_usb_phy_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(phy_provider);
 }
 
 static const struct of_device_id sun4i_usb_phy_of_match[] = {
-- 
1.7.9.5

