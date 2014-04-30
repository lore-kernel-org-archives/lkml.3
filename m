Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbaD3Ljo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:39:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49689 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371AbaD3Ljn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:39:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <mturquette@linaro.org>, <t-kristo@ti.com>, <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH] clk: ti: clk-54xx: Set the rate for dpll_abe_m2x2_ck
Date: Wed, 30 Apr 2014 14:39:37 +0300
Message-ID: <1398857977-30114-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get correct clock dividers for AESS/ABE we need to set the
dpll_abe_m2x2_ck rate to be double of dpll_abe_ck.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/clk/ti/clk-54xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
index 08f3d1b915b3..5e183993e3ec 100644
--- a/drivers/clk/ti/clk-54xx.c
+++ b/drivers/clk/ti/clk-54xx.c
@@ -240,6 +240,12 @@ int __init omap5xxx_dt_clk_init(void)
 	if (rc)
 		pr_err("%s: failed to configure ABE DPLL!\n", __func__);
 
+	abe_dpll = clk_get_sys(NULL, "dpll_abe_m2x2_ck");
+	if (!rc)
+		rc = clk_set_rate(abe_dpll, OMAP5_DPLL_ABE_DEFFREQ * 2);
+	if (rc)
+		pr_err("%s: failed to configure ABE m2x2 DPLL!\n", __func__);
+
 	usb_dpll = clk_get_sys(NULL, "dpll_usb_ck");
 	rc = clk_set_rate(usb_dpll, OMAP5_DPLL_USB_DEFFREQ);
 	if (rc)
-- 
1.9.2

