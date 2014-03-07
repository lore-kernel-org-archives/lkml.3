Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaCGNJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:09:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:55863 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbaCGNJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:09:45 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>, Mike Turquette <mturquette@linaro.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 1/8] CLK: ti: dra7: Initialize USB_DPLL
Date: Fri, 7 Mar 2014 15:09:04 +0200
Message-ID: <1394197751-28984-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394197751-28984-1-git-send-email-rogerq@ti.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB_DPLL must be initialized and locked at boot so that
USB modules can work.

Also program USB_DLL_M2 output to half rate.

CC: Mike Turquette <mturquette@linaro.org>
CC: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/clk/ti/clk-7xx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index 9977653..f89f3c2 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -18,6 +18,7 @@
 
 #define DRA7_DPLL_ABE_DEFFREQ				361267200
 #define DRA7_DPLL_GMAC_DEFFREQ				1000000000
+#define DRA7_DPLL_USB_DEFFREQ				960000000
 
 
 static struct ti_dt_clk dra7xx_clks[] = {
@@ -328,5 +329,15 @@ int __init dra7xx_dt_clk_init(void)
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
1.8.3.2

