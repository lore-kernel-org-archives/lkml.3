Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaB0OTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:19:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55296 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaB0OTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:19:08 -0500
From: Roger Quadros <rogerq@ti.com>
To: <lee.jones@linaro.org>, <tony@atomide.com>, <bcousson@baylibre.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v9 3/9] mfd: omap-usb-host: Use proper clock name instead of alias
Date: Thu, 27 Feb 2014 16:18:25 +0200
Message-ID: <1393510711-4697-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393510711-4697-1-git-send-email-rogerq@ti.com>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper clock name 'usbhost_120m_fck' instead of the
alias 'ehci_logic_fck'

Get rid of the 'ehci_logic_fck' alias from the OMAP3 hwmod data
as well.

CC: Paul Walmsley <paul@pwsan.com>
CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 6 ------
 drivers/mfd/omap-usb-host.c                | 5 +++--
 2 files changed, 3 insertions(+), 8 deletions(-)

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
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index c31baa7..865c276 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -692,10 +692,11 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 		if (need_logic_fck) {
 			omap->ehci_logic_fck = devm_clk_get(dev,
-							    "ehci_logic_fck");
+							    "usbhost_120m_fck");
 			if (IS_ERR(omap->ehci_logic_fck)) {
 				ret = PTR_ERR(omap->ehci_logic_fck);
-				dev_err(dev, "ehci_logic_fck failed:%d\n", ret);
+				dev_err(dev, "usbhost_120m_fck failed:%d\n",
+					ret);
 				goto err_mem;
 			}
 		}
-- 
1.8.3.2

