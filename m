Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBQJBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:01:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48152 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaBQI7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:33 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 3/8] usb: phy: bcm-kona-usb2: Use PTR_ERR_OR_ZERO
Date: Mon, 17 Feb 2014 14:29:20 +0530
Message-ID: <1392627565-1829-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@linaro.org>

PTR_ERR_OR_ZERO simplifies the code.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Matt Porter <mporter@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-bcm-kona-usb2.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
index efc5c1a..e94f5a6 100644
--- a/drivers/phy/phy-bcm-kona-usb2.c
+++ b/drivers/phy/phy-bcm-kona-usb2.c
@@ -128,10 +128,8 @@ static int bcm_kona_usb2_probe(struct platform_device *pdev)
 
 	phy_provider = devm_of_phy_provider_register(dev,
 			of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		return PTR_ERR(phy_provider);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(phy_provider);
 }
 
 static const struct of_device_id bcm_kona_usb2_dt_ids[] = {
-- 
1.7.10.4

