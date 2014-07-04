Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbaGDRCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:02:10 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38448 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaGDRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:02:08 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: balbi@ti.com
Cc: tony@atomide.com, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mach-omap1: Fix call to omap_cfg_reg
Date: Fri,  4 Jul 2014 13:02:00 -0400
Message-Id: <1404493320-5606-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the call to ompa_cfg_reg(USB2_SPEED) in the case
that the cpu is a omap16xx and the nwires are not equal to 3.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/arm/mach-omap1/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap1/usb.c b/arch/arm/mach-omap1/usb.c
index 4118db5..17e3139 100644
--- a/arch/arm/mach-omap1/usb.c
+++ b/arch/arm/mach-omap1/usb.c
@@ -504,8 +504,7 @@ static u32 __init omap1_usb2_init(unsigned nwires, unsigned alt_pingroup)
 		omap_cfg_reg(W9_USB2_TXEN);
 		omap_cfg_reg(W5_USB2_SE0);
 		if (nwires != 3)
-			omap_cfg_reg(Y5_USB2_RCV);
-		// FIXME omap_cfg_reg(USB2_SPEED);
+			omap_cfg_reg(USB2_SPEED)
 	} else {
 		pr_debug("usb%d cpu unrecognized\n", 1);
 		return 0;
-- 
1.9.1

