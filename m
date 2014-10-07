Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaJGOQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:16:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48627 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaJGOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:16:33 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, nm@ti.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] ARM: OMAP2: Remove unnecessary KERN_* in omap_phy_internal.c
Date: Tue,  7 Oct 2014 23:16:16 +0900
Message-Id: <1412691376-7895-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.1.273.g97b8860
In-Reply-To: <20141006162151.GA21908@kahuna>
References: <20141006162151.GA21908@kahuna>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove unnecessary KERN_INFO and KERN_ERR from omap_phy_internal.c.
Add pr_fmt. 

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-omap2/omap_phy_internal.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
index 50640b3..1a19fa0 100644
--- a/arch/arm/mach-omap2/omap_phy_internal.c
+++ b/arch/arm/mach-omap2/omap_phy_internal.c
@@ -21,6 +21,8 @@
   *
   */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
@@ -97,13 +99,13 @@ void am35x_musb_phy_power(u8 on)
 
 		omap_ctrl_writel(devconf2, AM35XX_CONTROL_DEVCONF2);
 
-		pr_info(KERN_INFO "Waiting for PHY clock good...\n");
+		pr_info("Waiting for PHY clock good...\n");
 		while (!(omap_ctrl_readl(AM35XX_CONTROL_DEVCONF2)
 				& CONF2_PHYCLKGD)) {
 			cpu_relax();
 
 			if (time_after(jiffies, timeout)) {
-				pr_err(KERN_ERR "musb PHY clock good timed out\n");
+				pr_err("musb PHY clock good timed out\n");
 				break;
 			}
 		}
@@ -145,7 +147,7 @@ void am35x_set_mode(u8 musb_mode)
 		devconf2 |= CONF2_NO_OVERRIDE;
 		break;
 	default:
-		pr_info(KERN_INFO "Unsupported mode %u\n", musb_mode);
+		pr_info("Unsupported mode %u\n", musb_mode);
 	}
 
 	omap_ctrl_writel(devconf2, AM35XX_CONTROL_DEVCONF2);
-- 
2.1.1.273.g97b8860

