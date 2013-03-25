Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab3CYV1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:27:23 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59662 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758631Ab3CYV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:27:21 -0400
Message-ID: <1364246839.1390.299.camel@x61.thuisdomein>
Subject: [PATCH] MIPS: remove obsolete Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-mips@linux-mips.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 22:27:19 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 21:27:19.0330 (UTC) FILETIME=[87AFB020:01CE299F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support for PB1100, PB1500, and PB1550 got merged into the code for
DB1000 and DB1550 code in v3.7. When that was done the three related
Kconfig symbols were dropped. But not all related Kconfig macros were
removed. Do so now.

Note that the PB1100 code in the Au1100 LCD driver is removed entirely
and not converted to use its current Kconfig macro. That is done because
the macros it uses (PB1100_G_CONTROL, PB1100_G_CONTROL_BL, and
PB1100_G_CONTROL_VDD) are never defined. Actually only one of these was
ever defined (PB1100_G_CONTROL) but that define was removed in v2.6.34.
So, as far as I can tell, this code could have never compiled.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
None of this is tested.

 arch/mips/alchemy/Platform | 22 ++--------------------
 drivers/video/au1100fb.c   | 22 ++++------------------
 2 files changed, 6 insertions(+), 38 deletions(-)

diff --git a/arch/mips/alchemy/Platform b/arch/mips/alchemy/Platform
index fa1bdd1..b3afcdd 100644
--- a/arch/mips/alchemy/Platform
+++ b/arch/mips/alchemy/Platform
@@ -5,32 +5,14 @@ platform-$(CONFIG_MIPS_ALCHEMY) += alchemy/common/
 

 #
-# AMD Alchemy Pb1100 eval board
-#
-platform-$(CONFIG_MIPS_PB1100)	+= alchemy/devboards/
-load-$(CONFIG_MIPS_PB1100)	+= 0xffffffff80100000
-
-#
-# AMD Alchemy Pb1500 eval board
-#
-platform-$(CONFIG_MIPS_PB1500)	+= alchemy/devboards/
-load-$(CONFIG_MIPS_PB1500)	+= 0xffffffff80100000
-
-#
-# AMD Alchemy Pb1550 eval board
-#
-platform-$(CONFIG_MIPS_PB1550)	+= alchemy/devboards/
-load-$(CONFIG_MIPS_PB1550)	+= 0xffffffff80100000
-
-#
-# AMD Alchemy Db1000/Db1500/Db1100 eval boards
+# AMD Alchemy Db1000/Db1500/Pb1500/Db1100/Pb1100 eval boards
 #
 platform-$(CONFIG_MIPS_DB1000)	+= alchemy/devboards/
 cflags-$(CONFIG_MIPS_DB1000)	+= -I$(srctree)/arch/mips/include/asm/mach-db1x00
 load-$(CONFIG_MIPS_DB1000)	+= 0xffffffff80100000
 
 #
-# AMD Alchemy Db1200/Pb1200/Db1550/Db1300 eval boards
+# AMD Alchemy Db1200/Pb1200/Db1550/Pb1550/Db1300 eval boards
 #
 platform-$(CONFIG_MIPS_DB1235)	+= alchemy/devboards/
 cflags-$(CONFIG_MIPS_DB1235)	+= -I$(srctree)/arch/mips/include/asm/mach-db1x00
diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index ddabaa8..700cac0 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -111,30 +111,16 @@ static int au1100fb_fb_blank(int blank_mode, struct fb_info *fbi)
 	switch (blank_mode) {
 
 	case VESA_NO_BLANKING:
-			/* Turn on panel */
-			fbdev->regs->lcd_control |= LCD_CONTROL_GO;
-#ifdef CONFIG_MIPS_PB1100
-			if (fbdev->panel_idx == 1) {
-				au_writew(au_readw(PB1100_G_CONTROL)
-					  | (PB1100_G_CONTROL_BL | PB1100_G_CONTROL_VDD),
-			PB1100_G_CONTROL);
-			}
-#endif
+		/* Turn on panel */
+		fbdev->regs->lcd_control |= LCD_CONTROL_GO;
 		au_sync();
 		break;
 
 	case VESA_VSYNC_SUSPEND:
 	case VESA_HSYNC_SUSPEND:
 	case VESA_POWERDOWN:
-			/* Turn off panel */
-			fbdev->regs->lcd_control &= ~LCD_CONTROL_GO;
-#ifdef CONFIG_MIPS_PB1100
-			if (fbdev->panel_idx == 1) {
-				au_writew(au_readw(PB1100_G_CONTROL)
-				  	  & ~(PB1100_G_CONTROL_BL | PB1100_G_CONTROL_VDD),
-			PB1100_G_CONTROL);
-			}
-#endif
+		/* Turn off panel */
+		fbdev->regs->lcd_control &= ~LCD_CONTROL_GO;
 		au_sync();
 		break;
 	default:
-- 
1.7.11.7

