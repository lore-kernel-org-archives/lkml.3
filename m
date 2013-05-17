Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3EQNXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:23:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3EQNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:23:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <tomi.valkeinen@ti.com>
CC: <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [RFC PATCH 1/4] arm: omap: Add phy binding info for musb in plat data
Date: Fri, 17 May 2013 18:52:31 +0530
Message-ID: <1368796954-3499-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for controllers to get PHY in case of non dt boot, the phy
binding information (phy label) should be added in the platform
data of the controller.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/usb-musb.c |    6 +++++-
 include/linux/usb/musb.h       |    3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index 3242a55..5ddbe39 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -85,8 +85,12 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
 	musb_plat.mode = board_data->mode;
 	musb_plat.extvbus = board_data->extvbus;
 
-	if (cpu_is_omap44xx())
+	if (cpu_is_omap44xx()) {
 		musb_plat.has_mailbox = true;
+		musb_plat.phy_name = "omap-usb2";
+	} else if (cpu_is_omap34xx()) {
+		musb_plat.phy_name = "twl4030";
+	}
 
 	if (soc_is_am35xx()) {
 		oh_name = "am35x_otg_hs";
diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
index 053c268..c05d46d 100644
--- a/include/linux/usb/musb.h
+++ b/include/linux/usb/musb.h
@@ -104,6 +104,9 @@ struct musb_hdrc_platform_data {
 	/* for clk_get() */
 	const char	*clock;
 
+	/* phy device label */
+	const char	*phy_name;
+
 	/* (HOST or OTG) switch VBUS on/off */
 	int		(*set_vbus)(struct device *dev, int is_on);
 
-- 
1.7.10.4

