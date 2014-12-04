Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaLDGY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:24:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40303 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaLDGYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:24:55 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>, <sfr@canb.auug.org.au>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH v2] arm: omap3: twl: remove usb phy init data
Date: Thu, 4 Dec 2014 11:54:43 +0530
Message-ID: <1417674283-31263-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141201191923.6366f9b5@canb.auug.org.au>
References: <20141201191923.6366f9b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit dbc98635e0d4 ("phy: remove the old lookup method") removes
struct phy_consumer but twl-common.c still uses the "phy_consumer"
structure resulting in the following compilation warning.

arch/arm/mach-omap2/twl-common.c:94:21: error: array type has
incomplete element type
 struct phy_consumer consumers[] = {

Removed using phy_consumer since twl4030 uses the new lookup
method.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
Fixed the commit log.
 arch/arm/mach-omap2/twl-common.c |   12 +-----------
 include/linux/i2c/twl.h          |    2 --
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
1.7.9.5

