Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3HAO7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:59:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44638 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab3HAO7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:59:02 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <rnayak@ti.com>
CC: <benoit.cousson@linaro.org>, <balbi@ti.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <dmurphy@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/4] CLK: ti: dra7: Initialize USB_DPLL
Date: Thu, 1 Aug 2013 17:58:51 +0300
Message-ID: <1375369134-26398-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375369134-26398-1-git-send-email-rogerq@ti.com>
References: <1375369134-26398-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB_DPLL must be initialized and locked at boot so that
USB modules can work.

Also program USB_DLL_M2 output to half rate.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/clk/omap/clk-7xx.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/omap/clk-7xx.c b/drivers/clk/omap/clk-7xx.c
index ddb39dd..f444513 100644
--- a/drivers/clk/omap/clk-7xx.c
+++ b/drivers/clk/omap/clk-7xx.c
@@ -19,6 +19,7 @@
 
 #define DRA7_DPLL_ABE_DEFFREQ				361267200
 #define DRA7_DPLL_GMAC_DEFFREQ				1000000000
+#define DRA7_DPLL_USB_DEFFREQ				960000000
 
 
 static struct omap_dt_clk dra7xx_clks[] = {
@@ -63,5 +64,15 @@ int __init dra7xx_clk_init(void)
 	if (rc)
 		pr_err("%s: failed to configure GMAC DPLL!\n", __func__);
 
+	dpll_ck = clk_get_sys(NULL, "dpll_usb_ck");
+	rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ);
+	if (rc)
+		pr_err("%s: failed to configure USB DPLL!\n", __func__);
+
+	dpll_ck = clk_get_sys(NULL, "dpll_usb_m2_ck");
+	rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ/2);
+	if (rc)
+		pr_err("%s: failed to set USB_DPLL M2 OUT\n", __func__);
+
 	return rc;
 }
-- 
1.7.4.1

