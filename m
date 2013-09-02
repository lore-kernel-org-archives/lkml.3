Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3IBPom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:44:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47703 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760Ab3IBPoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:44:34 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rogerq@ti.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
Date: Mon, 2 Sep 2013 21:13:09 +0530
Message-ID: <1378136591-7463-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1378136591-7463-1-git-send-email-kishon@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. Moved omap_usb.h from linux/usb/ to linux/phy/.
Also removed the unused members of struct omap_usb (after phy-omap-pipe3
started using it's own header file)

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-omap-usb2.c           |    2 +-
 drivers/usb/phy/phy-twl6030-usb.c     |    2 +-
 include/linux/{usb => phy}/omap_usb.h |    3 ---
 3 files changed, 2 insertions(+), 5 deletions(-)
 rename include/linux/{usb => phy}/omap_usb.h (95%)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index b25d623..6c78584 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -21,7 +21,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/io.h>
-#include <linux/usb/omap_usb.h>
+#include <linux/phy/omap_usb.h>
 #include <linux/usb/phy_companion.h>
 #include <linux/clk.h>
 #include <linux/err.h>
diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index 16dbc93..b5ad3eb 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -26,8 +26,8 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/usb/musb-omap.h>
+#include <linux/phy/omap_usb.h>
 #include <linux/usb/phy_companion.h>
-#include <linux/usb/omap_usb.h>
 #include <linux/i2c/twl.h>
 #include <linux/regulator/consumer.h>
 #include <linux/err.h>
diff --git a/include/linux/usb/omap_usb.h b/include/linux/phy/omap_usb.h
similarity index 95%
rename from include/linux/usb/omap_usb.h
rename to include/linux/phy/omap_usb.h
index 6ae2936..19d343c3 100644
--- a/include/linux/usb/omap_usb.h
+++ b/include/linux/phy/omap_usb.h
@@ -33,13 +33,10 @@ struct usb_dpll_params {
 struct omap_usb {
 	struct usb_phy		phy;
 	struct phy_companion	*comparator;
-	void __iomem		*pll_ctrl_base;
 	struct device		*dev;
 	struct device		*control_dev;
 	struct clk		*wkupclk;
-	struct clk		*sys_clk;
 	struct clk		*optclk;
-	u8			is_suspended:1;
 };
 
 #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
-- 
1.7.10.4

