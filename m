Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3IRMtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:49:45 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:51763 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3IRMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:49:43 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] radeon: Conditionally compile PM code
Date: Wed, 18 Sep 2013 14:48:32 +0200
Message-Id: <1379508512-30155-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power management code is only used on X86 and PowerMac. To prevent
the compiler from warning about unused code, only build when PM and one
of X86 or PowerMac is selected.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/video/aty/radeon_pm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index f7091ec..f4317f1 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -1427,6 +1427,8 @@ static void radeon_pm_full_reset_sdram(struct radeonfb_info *rinfo)
 	mdelay( 15);
 }
 
+#if defined(CONFIG_PM)
+#if defined(CONFIG_X86) || defined(CONFIG_PPC_PMAC)
 static void radeon_pm_reset_pad_ctlr_strength(struct radeonfb_info *rinfo)
 {
 	u32 tmp, tmp2;
@@ -1939,9 +1941,10 @@ static void radeon_reinitialize_M10(struct radeonfb_info *rinfo)
 	 */
 	radeon_pm_m10_enable_lvds_spread_spectrum(rinfo);
 }
+#endif
 
 #ifdef CONFIG_PPC_OF
-
+#ifdef CONFIG_PPC_PMAC
 static void radeon_pm_m9p_reconfigure_mc(struct radeonfb_info *rinfo)
 {
 	OUTREG(MC_CNTL, rinfo->save_regs[46]);
@@ -2202,6 +2205,8 @@ static void radeon_reinitialize_M9P(struct radeonfb_info *rinfo)
 	radeon_pm_restore_pixel_pll(rinfo);
 	radeon_pm_m10_enable_lvds_spread_spectrum(rinfo);
 }
+#endif
+#endif
 
 #if 0 /* Not ready yet */
 static void radeon_reinitialize_QW(struct radeonfb_info *rinfo)
-- 
1.8.4

