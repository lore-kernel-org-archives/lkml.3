Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaKSP2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:28:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:1978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbaKSP2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:28:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="639756181"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, andrew.kim@intel.com
Subject: [PATCHv5 4/7] arm: omap3: twl: remove usb phy init data
Date: Wed, 19 Nov 2014 17:28:20 +0200
Message-Id: <1416410903-162369-5-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1416410903-162369-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver does no use it any more.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 arch/arm/mach-omap2/twl-common.c | 12 +-----------
 include/linux/i2c/twl.h          |  2 --
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index b0d54da..4457e73 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -91,18 +91,8 @@ void __init omap_pmic_late_init(void)
 }
 
 #if defined(CONFIG_ARCH_OMAP3)
-struct phy_consumer consumers[] = {
-	PHY_CONSUMER("musb-hdrc.0", "usb"),
-};
-
-struct phy_init_data init_data = {
-	.consumers = consumers,
-	.num_consumers = ARRAY_SIZE(consumers),
-};
-
 static struct twl4030_usb_data omap3_usb_pdata = {
-	.usb_mode	= T2_USB_MODE_ULPI,
-	.init_data	= &init_data,
+	.usb_mode = T2_USB_MODE_ULPI,
 };
 
 static int omap3_batt_table[] = {
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 8cfb50f..0bc03f1 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -26,7 +26,6 @@
 #define __TWL_H_
 
 #include <linux/types.h>
-#include <linux/phy/phy.h>
 #include <linux/input/matrix_keypad.h>
 
 /*
@@ -634,7 +633,6 @@ enum twl4030_usb_mode {
 struct twl4030_usb_data {
 	enum twl4030_usb_mode	usb_mode;
 	unsigned long		features;
-	struct phy_init_data	*init_data;
 
 	int		(*phy_init)(struct device *dev);
 	int		(*phy_exit)(struct device *dev);
-- 
2.1.3

