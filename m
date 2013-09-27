Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3I0GZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:25:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38404 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3I0GZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:25:19 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <kishon@ti.com>,
        <balbi@ti.com>, <s.nawrocki@samsung.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <jkosina@suse.cz>, <m.chehab@samsung.com>,
        <cesarb@cesarb.net>, <joe@perches.com>, <davem@davemloft.net>,
        <davidb@codeaurora.org>, <sameo@linux.intel.com>,
        <peter.ujfalusi@ti.com>, <t-kristo@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <akpm@linux-foundation.org>, <balajitk@ti.com>,
        <george.cherian@ti.com>, <nsekhar@ti.com>, <rogerq@ti.com>
Subject: [PATCH v12 4/7] arm: omap3: twl: add phy consumer data in twl4030_usb_data
Date: Fri, 27 Sep 2013 11:53:28 +0530
Message-ID: <1380263012-9687-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380263012-9687-1-git-send-email-kishon@ti.com>
References: <1380263012-9687-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PHY framework uses the phy consumer data populated in platform data in the
case of non-dt boot to return the reference to the PHY when the controller
(PHY consumer) requests for it. So populated the phy consumer data in the platform
data of twl usb.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/twl-common.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index c05898f..b0d54da 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -24,6 +24,7 @@
 #include <linux/i2c/twl.h>
 #include <linux/gpio.h>
 #include <linux/string.h>
+#include <linux/phy/phy.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 
@@ -90,8 +91,18 @@ void __init omap_pmic_late_init(void)
 }
 
 #if defined(CONFIG_ARCH_OMAP3)
+struct phy_consumer consumers[] = {
+	PHY_CONSUMER("musb-hdrc.0", "usb"),
+};
+
+struct phy_init_data init_data = {
+	.consumers = consumers,
+	.num_consumers = ARRAY_SIZE(consumers),
+};
+
 static struct twl4030_usb_data omap3_usb_pdata = {
 	.usb_mode	= T2_USB_MODE_ULPI,
+	.init_data	= &init_data,
 };
 
 static int omap3_batt_table[] = {
-- 
1.7.10.4

