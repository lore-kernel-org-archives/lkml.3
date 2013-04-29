Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab3D2KIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:08:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39119 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490Ab3D2KE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:04:26 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <sylvester.nawrocki@gmail.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>,
        <akpm@linux-foundation.org>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>
Subject: [PATCH v6 5/9] ARM: OMAP: USB: Add phy binding information
Date: Mon, 29 Apr 2013 15:33:28 +0530
Message-ID: <1367229812-30574-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367229812-30574-1-git-send-email-kishon@ti.com>
References: <1367229812-30574-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for controllers to get PHY in case of non dt boot, the phy
binding information (phy device name) should be added in the platform
data of the controller.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/usb-musb.c |    6 +++++-
 include/linux/usb/musb.h       |    3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index 3242a55..228288a 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -85,8 +85,12 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
 	musb_plat.mode = board_data->mode;
 	musb_plat.extvbus = board_data->extvbus;
 
-	if (cpu_is_omap44xx())
+	if (cpu_is_omap44xx()) {
 		musb_plat.has_mailbox = true;
+		musb_plat.phy_dev_name = "omap-usb2.3.auto.0";
+	} else if (cpu_is_omap34xx()) {
+		musb_plat.phy_dev_name = "twl4030_usb.0";
+	}
 
 	if (soc_is_am35xx()) {
 		oh_name = "am35x_otg_hs";
diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
index 053c268..0b733a3 100644
--- a/include/linux/usb/musb.h
+++ b/include/linux/usb/musb.h
@@ -104,6 +104,9 @@ struct musb_hdrc_platform_data {
 	/* for clk_get() */
 	const char	*clock;
 
+	/* phy device name */
+	const char	*phy_dev_name;
+
 	/* (HOST or OTG) switch VBUS on/off */
 	int		(*set_vbus)(struct device *dev, int is_on);
 
-- 
1.7.10.4

