Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3DWGOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:14:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52632 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab3DWGOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:14:49 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, <kishon@ti.com>
Subject: [PATCH] ARM: OMAP4: change the device names in usb_bind_phy
Date: Tue, 23 Apr 2013 11:44:16 +0530
Message-ID: <1366697656-14315-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the device names are created using PLATFORM_DEVID_AUTO, the old
device names given in usb_bind_phy are no longer valid causing the musb
controller not to get the phy reference. Updated the usb_bind_phy with
the new device names to get MUSB functional in omap4 panda.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Tested in OMAP4 PANDA.
 arch/arm/mach-omap2/board-4430sdp.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 00d7290..56a9a4f 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -730,7 +730,7 @@ static void __init omap_4430sdp_init(void)
 	omap4_sdp4430_wifi_init();
 	omap4_twl6030_hsmmc_init(mmc);
 
-	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
+	usb_bind_phy("musb-hdrc.2.auto", 0, "omap-usb2.3.auto");
 	usb_musb_init(&musb_board_data);
 
 	status = omap_ethernet_init();
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index a71ad34..1e2c75e 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -435,7 +435,7 @@ static void __init omap4_panda_init(void)
 	omap_sdrc_init(NULL, NULL);
 	omap4_twl6030_hsmmc_init(mmc);
 	omap4_ehci_init();
-	usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
+	usb_bind_phy("musb-hdrc.2.auto", 0, "omap-usb2.3.auto");
 	usb_musb_init(&musb_board_data);
 	omap4_panda_display_init();
 }
-- 
1.7.10.4

