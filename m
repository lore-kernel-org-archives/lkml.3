Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaIXNri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:47:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38802 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaIXNrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/22] phy: phy-spear1310-miphy: Use module_platform_driver to register driver.
Date: Wed, 24 Sep 2014 19:17:06 +0530
Message-ID: <1411566440-19169-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

Use the module_platform_driver macro to register the driver as this gets
rid of a lot of the boilerplate code.

Also remove .owner field as this gets overridden in __platform_driver_register.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-spear1310-miphy.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/phy/phy-spear1310-miphy.c b/drivers/phy/phy-spear1310-miphy.c
index 911d25b..5f4c586 100644
--- a/drivers/phy/phy-spear1310-miphy.c
+++ b/drivers/phy/phy-spear1310-miphy.c
@@ -250,22 +250,11 @@ static struct platform_driver spear1310_miphy_driver = {
 	.probe		= spear1310_miphy_probe,
 	.driver = {
 		.name = "spear1310-miphy",
-		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(spear1310_miphy_of_match),
 	},
 };
 
-static int __init spear1310_miphy_phy_init(void)
-{
-	return platform_driver_register(&spear1310_miphy_driver);
-}
-module_init(spear1310_miphy_phy_init);
-
-static void __exit spear1310_miphy_phy_exit(void)
-{
-	platform_driver_unregister(&spear1310_miphy_driver);
-}
-module_exit(spear1310_miphy_phy_exit);
+module_platform_driver(spear1310_miphy_driver);
 
 MODULE_DESCRIPTION("ST SPEAR1310-MIPHY driver");
 MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
-- 
1.7.9.5

