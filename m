Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaBTLle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:41:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57960 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbaBTLlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:41:05 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH v8 07/14] ARM: OMAP3: hwmod data: Remove optional clock from usb_host_hs module
Date: Thu, 20 Feb 2014 13:40:02 +0200
Message-ID: <1392896409-5101-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392896409-5101-1-git-send-email-rogerq@ti.com>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB Host driver manages this clock so no need to have it in
the hwmod data. We also get rid of the 'ehci_logic_fck' alias
for 'usbhost_120m_fck' clock.

CC: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
index 4c3b1e6..ad87f46 100644
--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -1955,10 +1955,6 @@ static struct omap_hwmod_class omap3xxx_usb_host_hs_hwmod_class = {
 	.sysc = &omap3xxx_usb_host_hs_sysc,
 };
 
-static struct omap_hwmod_opt_clk omap3xxx_usb_host_hs_opt_clks[] = {
-	  { .role = "ehci_logic_fck", .clk = "usbhost_120m_fck", },
-};
-
 static struct omap_hwmod_irq_info omap3xxx_usb_host_hs_irqs[] = {
 	{ .name = "ohci-irq", .irq = 76 + OMAP_INTC_START, },
 	{ .name = "ehci-irq", .irq = 77 + OMAP_INTC_START, },
@@ -1981,8 +1977,6 @@ static struct omap_hwmod omap3xxx_usb_host_hs_hwmod = {
 			.idlest_stdby_bit = OMAP3430ES2_ST_USBHOST_STDBY_SHIFT,
 		},
 	},
-	.opt_clks	= omap3xxx_usb_host_hs_opt_clks,
-	.opt_clks_cnt	= ARRAY_SIZE(omap3xxx_usb_host_hs_opt_clks),
 
 	/*
 	 * Errata: USBHOST Configured In Smart-Idle Can Lead To a Deadlock
-- 
1.8.3.2

