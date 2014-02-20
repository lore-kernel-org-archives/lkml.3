Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaBTLlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:41:31 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52384 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbaBTLlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:41:01 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v8 06/14] CLK: TI: OMAP3: Get rid of unused USB Host dummy clocks
Date: Thu, 20 Feb 2014 13:40:01 +0200
Message-ID: <1392896409-5101-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392896409-5101-1-git-send-email-rogerq@ti.com>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP USB Host MFD driver no longer expects these non-existing
clocks from the OMAP3 platform, so get rid of them.

CC: Tero Kristo <t-kristo@ti.com>
CC: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c | 4 ----
 drivers/clk/ti/clk-3xxx.c             | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 3b05aea..4299a55 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -3495,10 +3495,6 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"dss_tv_fck",	&dss_tv_fck),
 	CLK(NULL,	"dss_96m_fck",	&dss_96m_fck),
 	CLK(NULL,	"dss2_alwon_fck",	&dss2_alwon_fck),
-	CLK(NULL,	"utmi_p1_gfclk",	&dummy_ck),
-	CLK(NULL,	"utmi_p2_gfclk",	&dummy_ck),
-	CLK(NULL,	"xclk60mhsp1_ck",	&dummy_ck),
-	CLK(NULL,	"xclk60mhsp2_ck",	&dummy_ck),
 	CLK(NULL,	"init_60m_fclk",	&dummy_ck),
 	CLK(NULL,	"gpt1_fck",	&gpt1_fck),
 	CLK(NULL,	"aes2_ick",	&aes2_ick),
diff --git a/drivers/clk/ti/clk-3xxx.c b/drivers/clk/ti/clk-3xxx.c
index d323023..0d1750a 100644
--- a/drivers/clk/ti/clk-3xxx.c
+++ b/drivers/clk/ti/clk-3xxx.c
@@ -130,10 +130,6 @@ static struct ti_dt_clk omap3xxx_clks[] = {
 	DT_CLK(NULL, "dss_tv_fck", "dss_tv_fck"),
 	DT_CLK(NULL, "dss_96m_fck", "dss_96m_fck"),
 	DT_CLK(NULL, "dss2_alwon_fck", "dss2_alwon_fck"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "dummy_ck"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "dummy_ck"),
-	DT_CLK(NULL, "xclk60mhsp1_ck", "dummy_ck"),
-	DT_CLK(NULL, "xclk60mhsp2_ck", "dummy_ck"),
 	DT_CLK(NULL, "init_60m_fclk", "dummy_ck"),
 	DT_CLK(NULL, "gpt1_fck", "gpt1_fck"),
 	DT_CLK(NULL, "aes2_ick", "aes2_ick"),
-- 
1.8.3.2

