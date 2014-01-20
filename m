Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaATON3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:13:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46766 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbaATOMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:12:51 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <lee.jones@linaro.org>, <arnd@arndb.de>, <sre@debian.org>,
        <mark.rutland@arm.com>, <m.paolino@virtualopensystems.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v6 10/10] ARM: OMAP2+: Remove legacy_init_ehci_clk()
Date: Mon, 20 Jan 2014 16:11:31 +0200
Message-ID: <1390227091-4523-11-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390227091-4523-1-git-send-email-rogerq@ti.com>
References: <1390227091-4523-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The necessary clock phandle for the EHCI clock is now provided
via device tree so we no longer need this legacy method.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/pdata-quirks.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 39f020c..6a4e2d1 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -26,20 +26,6 @@ struct pdata_init {
 	void (*fn)(void);
 };
 
-/*
- * Create alias for USB host PHY clock.
- * Remove this when clock phandle can be provided via DT
- */
-static void __init __used legacy_init_ehci_clk(char *clkname)
-{
-	int ret;
-
-	ret = clk_add_alias("main_clk", NULL, clkname, NULL);
-	if (ret)
-		pr_err("%s:Failed to add main_clk alias to %s :%d\n",
-		       __func__, clkname, ret);
-}
-
 #if IS_ENABLED(CONFIG_WL12XX)
 
 static struct wl12xx_platform_data wl12xx __initdata;
@@ -105,7 +91,6 @@ static void __init omap4_sdp_legacy_init(void)
 static void __init omap4_panda_legacy_init(void)
 {
 	omap4_panda_display_init_of();
-	legacy_init_ehci_clk("auxclk3_ck");
 	legacy_init_wl12xx(WL12XX_REFCLOCK_38, 0, 53);
 }
 #endif
@@ -113,7 +98,6 @@ static void __init omap4_panda_legacy_init(void)
 #ifdef CONFIG_SOC_OMAP5
 static void __init omap5_uevm_legacy_init(void)
 {
-	legacy_init_ehci_clk("auxclk1_ck");
 }
 #endif
 
-- 
1.8.3.2

