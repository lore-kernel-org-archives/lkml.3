Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaAIMJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:09:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43692 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbaAIMJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:09:28 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <arnd@arndb.de>, <sre@debian.org>, <mark.rutland@arm.com>,
        <m.paolino@virtualopensystems.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v5 3/9] mfd: omap-usb-host: Update DT clock binding information
Date: Thu, 9 Jan 2014 17:38:17 +0530
Message-ID: <1389269303-30465-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389269303-30465-1-git-send-email-rogerq@ti.com>
References: <1389269303-30465-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap-usb-host driver expects certained named clocks.
Add this information to the DT binding document.

Use clock names as per function for reference clocks.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/mfd/omap-usb-host.txt      | 23 ++++++++++++++++++++++
 drivers/mfd/omap-usb-host.c                        |  6 +++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
index b381fa6..4721b2d 100644
--- a/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
+++ b/Documentation/devicetree/bindings/mfd/omap-usb-host.txt
@@ -32,6 +32,29 @@ Optional properties:
 - single-ulpi-bypass: Must be present if the controller contains a single
   ULPI bypass control bit. e.g. OMAP3 silicon <= ES2.1
 
+- clocks: a list of phandles and clock-specifier pairs, one for each entry in
+  clock-names.
+
+- clock-names: should include:
+  For OMAP3
+  * "usbhost_120m_fck" - 120MHz Functional clock.
+
+  For OMAP4+
+  * "refclk_60m_int" - 60MHz internal reference clock for UTMI clock mux
+  * "refclk_60m_ext_p1" - 60MHz external ref. clock for Port 1's UTMI clock mux.
+  * "refclk_60m_ext_p2" - 60MHz external ref. clock for Port 2's UTMI clock mux
+  * "utmi_p1_gfclk" - Port 1 UTMI clock mux.
+  * "utmi_p2_gfclk" - Port 2 UTMI clock mux.
+  * "usb_host_hs_utmi_p1_clk" - Port 1 UTMI clock gate.
+  * "usb_host_hs_utmi_p2_clk" - Port 2 UTMI clock gate.
+  * "usb_host_hs_utmi_p3_clk" - Port 3 UTMI clock gate.
+  * "usb_host_hs_hsic480m_p1_clk" - Port 1 480MHz HSIC clock gate.
+  * "usb_host_hs_hsic480m_p2_clk" - Port 2 480MHz HSIC clock gate.
+  * "usb_host_hs_hsic480m_p3_clk" - Port 3 480MHz HSIC clock gate.
+  * "usb_host_hs_hsic60m_p1_clk" - Port 1 60MHz HSIC clock gate.
+  * "usb_host_hs_hsic60m_p2_clk" - Port 2 60MHz HSIC clock gate.
+  * "usb_host_hs_hsic60m_p3_clk" - Port 3 60MHz HSIC clock gate.
+
 Required properties if child node exists:
 
 - #address-cells: Must be 1
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 7202cc6..eeea6e6 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -713,21 +713,21 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		goto err_mem;
 	}
 
-	omap->xclk60mhsp1_ck = devm_clk_get(dev, "xclk60mhsp1_ck");
+	omap->xclk60mhsp1_ck = devm_clk_get(dev, "refclk_60m_ext_p1");
 	if (IS_ERR(omap->xclk60mhsp1_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp1_ck);
 		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
 		goto err_mem;
 	}
 
-	omap->xclk60mhsp2_ck = devm_clk_get(dev, "xclk60mhsp2_ck");
+	omap->xclk60mhsp2_ck = devm_clk_get(dev, "refclk_60m_ext_p2");
 	if (IS_ERR(omap->xclk60mhsp2_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp2_ck);
 		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
 		goto err_mem;
 	}
 
-	omap->init_60m_fclk = devm_clk_get(dev, "init_60m_fclk");
+	omap->init_60m_fclk = devm_clk_get(dev, "refclk_60m_int");
 	if (IS_ERR(omap->init_60m_fclk)) {
 		ret = PTR_ERR(omap->init_60m_fclk);
 		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
-- 
1.8.3.2

