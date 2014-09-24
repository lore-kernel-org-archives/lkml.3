Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaIXNtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:49:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51008 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbaIXNrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:52 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/22] phy: phy-spear1340-miphy: Use module_platform_driver to register driver.
Date: Wed, 24 Sep 2014 19:17:07 +0530
Message-ID: <1411566440-19169-10-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

Using the module_platform_driver macro to register the driver as this gets
rid of a lot of the boilerplate code.

Also remove .owner field as this gets overridden in __platform_driver_register.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-spear1340-miphy.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/phy/phy-spear1340-miphy.c b/drivers/phy/phy-spear1340-miphy.c
index ee4d66f..1ecd094 100644
--- a/drivers/phy/phy-spear1340-miphy.c
+++ b/drivers/phy/phy-spear1340-miphy.c
@@ -282,23 +282,12 @@ static struct platform_driver spear1340_miphy_driver = {
 	.probe		= spear1340_miphy_probe,
 	.driver = {
 		.name = "spear1340-miphy",
-		.owner = THIS_MODULE,
 		.pm = &spear1340_miphy_pm_ops,
 		.of_match_table = of_match_ptr(spear1340_miphy_of_match),
 	},
 };
 
-static int __init spear1340_miphy_phy_init(void)
-{
-	return platform_driver_register(&spear1340_miphy_driver);
-}
-module_init(spear1340_miphy_phy_init);
-
-static void __exit spear1340_miphy_phy_exit(void)
-{
-	platform_driver_unregister(&spear1340_miphy_driver);
-}
-module_exit(spear1340_miphy_phy_exit);
+module_platform_driver(spear1340_miphy_driver);
 
 MODULE_DESCRIPTION("ST SPEAR1340-MIPHY driver");
 MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
-- 
1.7.9.5

