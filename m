Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaGIQ4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:56:01 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54140 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGIQz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:55:59 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: balbi@ti.com
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Removes FIXME message in usb.c
Date: Wed,  9 Jul 2014 12:55:48 -0400
Message-Id: <1404924948-3298-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a fixme message in this file for setting the usb 2
speed on the board to the correct level. We need to depend on the
bootloader for doing this as the wires may be shared for the other
things on the board with the usb chipset.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/arm/mach-omap1/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap1/usb.c b/arch/arm/mach-omap1/usb.c
index 4118db5..172245a 100644
--- a/arch/arm/mach-omap1/usb.c
+++ b/arch/arm/mach-omap1/usb.c
@@ -505,7 +505,7 @@ static u32 __init omap1_usb2_init(unsigned nwires, unsigned alt_pingroup)
 		omap_cfg_reg(W5_USB2_SE0);
 		if (nwires != 3)
 			omap_cfg_reg(Y5_USB2_RCV);
-		// FIXME omap_cfg_reg(USB2_SPEED);
+		/* Depend on boatloader for USB speed to be stated for board */
 	} else {
 		pr_debug("usb%d cpu unrecognized\n", 1);
 		return 0;
-- 
1.9.1

