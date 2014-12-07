Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaLGVq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:46:57 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51065 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLGVqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:46:55 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-omap2: clkt2xxx_apll.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 22:49:34 +0100
Message-Id: <1417988974-17688-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
omap2_clk_apll54_disable() omap2_clk_apll96_disable()
omap2_clk_apll54_enable() omap2_clk_apll96_enable() omap2xxx_get_apll_clkin()
omap2_clk_apll96_recalc() omap2_clk_apll54_recalc()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-omap2/clkt2xxx_apll.c |   52 -----------------------------------
 arch/arm/mach-omap2/clock2xxx.h     |    9 ------
 2 files changed, 61 deletions(-)

diff --git a/arch/arm/mach-omap2/clkt2xxx_apll.c b/arch/arm/mach-omap2/clkt2xxx_apll.c
index c78e893..65880e7 100644
--- a/arch/arm/mach-omap2/clkt2xxx_apll.c
+++ b/arch/arm/mach-omap2/clkt2xxx_apll.c
@@ -57,16 +57,6 @@ static bool omap2xxx_clk_apll_locked(struct clk_hw *hw)
 	return ((r & apll_mask) == apll_mask) ? true : false;
 }
 
-int omap2_clk_apll96_enable(struct clk_hw *hw)
-{
-	return omap2xxx_cm_apll96_enable();
-}
-
-int omap2_clk_apll54_enable(struct clk_hw *hw)
-{
-	return omap2xxx_cm_apll54_enable();
-}
-
 static void _apll96_allow_idle(struct clk_hw_omap *clk)
 {
 	omap2xxx_cm_set_apll96_auto_low_power_stop();
@@ -87,28 +77,6 @@ static void _apll54_deny_idle(struct clk_hw_omap *clk)
 	omap2xxx_cm_set_apll54_disable_autoidle();
 }
 
-void omap2_clk_apll96_disable(struct clk_hw *hw)
-{
-	omap2xxx_cm_apll96_disable();
-}
-
-void omap2_clk_apll54_disable(struct clk_hw *hw)
-{
-	omap2xxx_cm_apll54_disable();
-}
-
-unsigned long omap2_clk_apll54_recalc(struct clk_hw *hw,
-				      unsigned long parent_rate)
-{
-	return (omap2xxx_clk_apll_locked(hw)) ? 54000000 : 0;
-}
-
-unsigned long omap2_clk_apll96_recalc(struct clk_hw *hw,
-				      unsigned long parent_rate)
-{
-	return (omap2xxx_clk_apll_locked(hw)) ? 96000000 : 0;
-}
-
 /* Public data */
 const struct clk_hw_omap_ops clkhwops_apll54 = {
 	.allow_idle	= _apll54_allow_idle,
@@ -120,23 +88,3 @@ const struct clk_hw_omap_ops clkhwops_apll96 = {
 	.deny_idle	= _apll96_deny_idle,
 };
 
-/* Public functions */
-
-u32 omap2xxx_get_apll_clkin(void)
-{
-	u32 aplls, srate = 0;
-
-	aplls = omap2xxx_cm_get_pll_config();
-	aplls &= OMAP24XX_APLLS_CLKIN_MASK;
-	aplls >>= OMAP24XX_APLLS_CLKIN_SHIFT;
-
-	if (aplls == APLLS_CLKIN_19_2MHZ)
-		srate = 19200000;
-	else if (aplls == APLLS_CLKIN_13MHZ)
-		srate = 13000000;
-	else if (aplls == APLLS_CLKIN_12MHZ)
-		srate = 12000000;
-
-	return srate;
-}
-
diff --git a/arch/arm/mach-omap2/clock2xxx.h b/arch/arm/mach-omap2/clock2xxx.h
index a090225..364a4cc 100644
--- a/arch/arm/mach-omap2/clock2xxx.h
+++ b/arch/arm/mach-omap2/clock2xxx.h
@@ -22,12 +22,7 @@ unsigned long omap2xxx_sys_clk_recalc(struct clk_hw *clk,
 unsigned long omap2_osc_clk_recalc(struct clk_hw *clk,
 				   unsigned long parent_rate);
 void omap2xxx_clkt_dpllcore_init(struct clk_hw *hw);
-unsigned long omap2_clk_apll54_recalc(struct clk_hw *hw,
-				      unsigned long parent_rate);
-unsigned long omap2_clk_apll96_recalc(struct clk_hw *hw,
-				      unsigned long parent_rate);
 unsigned long omap2xxx_clk_get_core_rate(void);
-u32 omap2xxx_get_apll_clkin(void);
 u32 omap2xxx_get_sysclkdiv(void);
 void omap2xxx_clk_prepare_for_reboot(void);
 void omap2xxx_clkt_vps_check_bootloader_rates(void);
@@ -48,9 +43,5 @@ int omap2430_clk_init(void);
 extern struct clk_hw *dclk_hw;
 int omap2_enable_osc_ck(struct clk_hw *hw);
 void omap2_disable_osc_ck(struct clk_hw *hw);
-int omap2_clk_apll96_enable(struct clk_hw *hw);
-int omap2_clk_apll54_enable(struct clk_hw *hw);
-void omap2_clk_apll96_disable(struct clk_hw *hw);
-void omap2_clk_apll54_disable(struct clk_hw *hw);
 
 #endif
-- 
1.7.10.4

