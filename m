Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab3FMIsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:48:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41196 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291Ab3FMIpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:45:11 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <sylvester.nawrocki@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: [PATCH v7 5/9] ARM: OMAP: USB: Add phy binding information
Date: Thu, 13 Jun 2013 14:13:55 +0530
Message-ID: <1371113039-5784-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371113039-5784-1-git-send-email-kishon@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
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
index 3242a55..284ba51 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -85,8 +85,12 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
 	musb_plat.mode = board_data->mode;
 	musb_plat.extvbus = board_data->extvbus;
 
-	if (cpu_is_omap44xx())
+	if (cpu_is_omap44xx()) {
 		musb_plat.has_mailbox = true;
+		musb_plat.phy_label = "omap-usb2";
+	} else if (cpu_is_omap34xx()) {
+		musb_plat.phy_label = "twl4030";
+	}
 
 	if (soc_is_am35xx()) {
 		oh_name = "am35x_otg_hs";
diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
index 053c268..596f8c8 100644
--- a/include/linux/usb/musb.h
+++ b/include/linux/usb/musb.h
@@ -104,6 +104,9 @@ struct musb_hdrc_platform_data {
 	/* for clk_get() */
 	const char	*clock;
 
+	/* phy label */
+	const char	*phy_label;
+
 	/* (HOST or OTG) switch VBUS on/off */
 	int		(*set_vbus)(struct device *dev, int is_on);
 
-- 
1.7.10.4

