Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3F1Vim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:38:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13544 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3F1ViD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:38:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Jun 2013 14:35:56 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 4/9] ARM: tegra: Remove USB platform data
Date: Sat, 29 Jun 2013 00:37:02 +0300
Message-ID: <1372455427-20898-5-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB-related platform data is not used anymore in the Tegra USB drivers,
so remove all of it.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 arch/arm/mach-tegra/tegra.c             | 38 +--------------------------------
 include/linux/platform_data/tegra_usb.h | 32 ---------------------------
 include/linux/usb/tegra_usb_phy.h       |  5 -----
 3 files changed, 1 insertion(+), 74 deletions(-)
 delete mode 100644 include/linux/platform_data/tegra_usb.h

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 0d1e412..fc97cfd 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -29,7 +29,6 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 #include <linux/pda_power.h>
-#include <linux/platform_data/tegra_usb.h>
 #include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/sys_soc.h>
@@ -46,40 +45,6 @@
 #include "fuse.h"
 #include "iomap.h"
 
-static struct tegra_ehci_platform_data tegra_ehci1_pdata = {
-	.operating_mode = TEGRA_USB_OTG,
-	.power_down_on_bus_suspend = 1,
-	.vbus_gpio = -1,
-};
-
-static struct tegra_ulpi_config tegra_ehci2_ulpi_phy_config = {
-	.reset_gpio = -1,
-	.clk = "cdev2",
-};
-
-static struct tegra_ehci_platform_data tegra_ehci2_pdata = {
-	.phy_config = &tegra_ehci2_ulpi_phy_config,
-	.operating_mode = TEGRA_USB_HOST,
-	.power_down_on_bus_suspend = 1,
-	.vbus_gpio = -1,
-};
-
-static struct tegra_ehci_platform_data tegra_ehci3_pdata = {
-	.operating_mode = TEGRA_USB_HOST,
-	.power_down_on_bus_suspend = 1,
-	.vbus_gpio = -1,
-};
-
-static struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5000000, "tegra-ehci.0",
-		       &tegra_ehci1_pdata),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5004000, "tegra-ehci.1",
-		       &tegra_ehci2_pdata),
-	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5008000, "tegra-ehci.2",
-		       &tegra_ehci3_pdata),
-	{}
-};
-
 static void __init tegra_dt_init(void)
 {
 	struct soc_device_attribute *soc_dev_attr;
@@ -112,8 +77,7 @@ static void __init tegra_dt_init(void)
 	 * devices
 	 */
 out:
-	of_platform_populate(NULL, of_default_bus_match_table,
-				tegra20_auxdata_lookup, parent);
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);
 }
 
 static void __init trimslice_init(void)
diff --git a/include/linux/platform_data/tegra_usb.h b/include/linux/platform_data/tegra_usb.h
deleted file mode 100644
index 66c673f..0000000
--- a/include/linux/platform_data/tegra_usb.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (C) 2010 Google, Inc.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef _TEGRA_USB_H_
-#define _TEGRA_USB_H_
-
-enum tegra_usb_operating_modes {
-	TEGRA_USB_DEVICE,
-	TEGRA_USB_HOST,
-	TEGRA_USB_OTG,
-};
-
-struct tegra_ehci_platform_data {
-	enum tegra_usb_operating_modes operating_mode;
-	/* power down the phy on bus suspend */
-	int power_down_on_bus_suspend;
-	void *phy_config;
-	int vbus_gpio;
-};
-
-#endif /* _TEGRA_USB_H_ */
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index c2bc710..8474153 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -28,11 +28,6 @@ struct tegra_utmip_config {
 	u8 xcvr_lsrslew;
 };
 
-struct tegra_ulpi_config {
-	int reset_gpio;
-	const char *clk;
-};
-
 enum tegra_usb_phy_port_speed {
 	TEGRA_USB_PHY_PORT_SPEED_FULL = 0,
 	TEGRA_USB_PHY_PORT_SPEED_LOW,
-- 
1.8.1.5

