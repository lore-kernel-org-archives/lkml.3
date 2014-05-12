Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbaELQ5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:57:09 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59959 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaELQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:57:05 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 6/9] dt: deps: WIP: well done drivers
Date: Mon, 12 May 2014 18:47:57 +0200
Message-Id: <1399913280-6915-7-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the necessary changes for some drivers which are used
by the boards I have. The list isn't complete (therefor the WIP) and is
meant as an example. If considered to be mainlined, I assume these changes
should end up in one patch for every changed driver.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/dma/mv_xor.c                       | 2 +-
 drivers/dma/omap-dma.c                     | 2 +-
 drivers/gpio/gpio-mvebu.c                  | 2 +-
 drivers/gpio/gpio-twl4030.c                | 2 +-
 drivers/i2c/busses/i2c-omap.c              | 2 +-
 drivers/iommu/omap-iommu.c                 | 2 +-
 drivers/mailbox/mailbox-omap2.c            | 2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
 drivers/regulator/fixed.c                  | 2 +-
 drivers/regulator/twl-regulator.c          | 2 +-
 drivers/usb/host/ehci-omap.c               | 2 +-
 drivers/usb/host/ehci-orion.c              | 2 +-
 drivers/usb/host/ohci-omap3.c              | 2 +-
 drivers/usb/phy/phy-generic.c              | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 766b68e..7f1091a 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1316,7 +1316,7 @@ static int __init mv_xor_init(void)
 {
 	return platform_driver_register(&mv_xor_driver);
 }
-module_init(mv_xor_init);
+well_done_platform_module_init(mv_xor_init);
 
 /* it's currently unsafe to unload this module */
 #if 0
diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 362e7c4..a523025 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -707,7 +707,7 @@ static int omap_dma_init(void)
 {
 	return platform_driver_register(&omap_dma_driver);
 }
-subsys_initcall(omap_dma_init);
+well_done_platform_initcall(subsys, omap_dma_init);
 
 static void __exit omap_dma_exit(void)
 {
diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 3b1fd1c..c151f6e 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -736,4 +736,4 @@ static int __init mvebu_gpio_init(void)
 {
 	return platform_driver_register(&mvebu_gpio_driver);
 }
-postcore_initcall(mvebu_gpio_init);
+well_done_platform_initcall(postcore, mvebu_gpio_init);
diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index 8b88ca2..6c18f4a 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -618,7 +618,7 @@ static int __init gpio_twl4030_init(void)
 {
 	return platform_driver_register(&gpio_twl4030_driver);
 }
-subsys_initcall(gpio_twl4030_init);
+well_done_platform_initcall(subsys, gpio_twl4030_init);
 
 static void __exit gpio_twl4030_exit(void)
 {
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 90dcc2e..4df05c0 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1352,7 +1352,7 @@ omap_i2c_init_driver(void)
 {
 	return platform_driver_register(&omap_i2c_driver);
 }
-subsys_initcall(omap_i2c_init_driver);
+well_done_platform_initcall(subsys, omap_i2c_init_driver);
 
 static void __exit omap_i2c_exit_driver(void)
 {
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index bcd78a7..c121708 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1282,7 +1282,7 @@ static int __init omap_iommu_init(void)
 	return platform_driver_register(&omap_iommu_driver);
 }
 /* must be ready before omap3isp is probed */
-subsys_initcall(omap_iommu_init);
+well_done_platform_initcall(subsys, omap_iommu_init);
 
 static void __exit omap_iommu_exit(void)
 {
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 42d2b89..919da67 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -347,7 +347,7 @@ static void __exit omap2_mbox_exit(void)
 	platform_driver_unregister(&omap2_mbox_driver);
 }
 
-module_init(omap2_mbox_init);
+well_done_platform_module_init(omap2_mbox_init);
 module_exit(omap2_mbox_exit);
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index a2565ce..2fcd832 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3011,7 +3011,7 @@ static int __init mv643xx_eth_init_module(void)
 
 	return rc;
 }
-module_init(mv643xx_eth_init_module);
+well_done_platform_module_init(mv643xx_eth_init_module);
 
 static void __exit mv643xx_eth_cleanup_module(void)
 {
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 5ea64b9..3a71016 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -241,7 +241,7 @@ static int __init regulator_fixed_voltage_init(void)
 {
 	return platform_driver_register(&regulator_fixed_voltage_driver);
 }
-subsys_initcall(regulator_fixed_voltage_init);
+well_done_platform_initcall(subsys, regulator_fixed_voltage_init);
 
 static void __exit regulator_fixed_voltage_exit(void)
 {
diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index fed28ab..646caf6 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1240,7 +1240,7 @@ static int __init twlreg_init(void)
 {
 	return platform_driver_register(&twlreg_driver);
 }
-subsys_initcall(twlreg_init);
+well_done_platform_initcall(subsys, twlreg_init);
 
 static void __exit twlreg_exit(void)
 {
diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index a24720b..19bca40 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -310,7 +310,7 @@ static int __init ehci_omap_init(void)
 	ehci_init_driver(&ehci_omap_hc_driver, &ehci_omap_overrides);
 	return platform_driver_register(&ehci_hcd_omap_driver);
 }
-module_init(ehci_omap_init);
+well_done_platform_module_init(ehci_omap_init);
 
 static void __exit ehci_omap_cleanup(void)
 {
diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 30d35e5..6d59923 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -298,7 +298,7 @@ static int __init ehci_orion_init(void)
 	ehci_init_driver(&ehci_orion_hc_driver, NULL);
 	return platform_driver_register(&ehci_orion_driver);
 }
-module_init(ehci_orion_init);
+well_done_platform_module_init(ehci_orion_init);
 
 static void __exit ehci_orion_cleanup(void)
 {
diff --git a/drivers/usb/host/ohci-omap3.c b/drivers/usb/host/ohci-omap3.c
index ec15aeb..26bb8d1 100644
--- a/drivers/usb/host/ohci-omap3.c
+++ b/drivers/usb/host/ohci-omap3.c
@@ -197,7 +197,7 @@ static int __init ohci_omap3_init(void)
 	ohci_init_driver(&ohci_omap3_hc_driver, NULL);
 	return platform_driver_register(&ohci_hcd_omap3_driver);
 }
-module_init(ohci_omap3_init);
+well_done_module_init(ohci_omap3_init);
 
 static void __exit ohci_omap3_cleanup(void)
 {
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index bb39498..6405efe 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -304,7 +304,7 @@ static int __init usb_phy_gen_xceiv_init(void)
 {
 	return platform_driver_register(&usb_phy_gen_xceiv_driver);
 }
-subsys_initcall(usb_phy_gen_xceiv_init);
+well_done_platform_initcall(subsys, usb_phy_gen_xceiv_init);
 
 static void __exit usb_phy_gen_xceiv_exit(void)
 {
-- 
1.8.3.1

