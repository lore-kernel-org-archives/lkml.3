Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaBTLl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:41:26 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52383 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbaBTLlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:41:01 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v8 04/14] mfd: omap-usb-host: Update DT clock binding information
Date: Thu, 20 Feb 2014 13:39:59 +0200
Message-ID: <1392896409-5101-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392896409-5101-1-git-send-email-rogerq@ti.com>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap-usb-host driver expects certained named clocks.
Add this information to the DT binding document.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/mfd/omap-usb-host.txt      | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

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
-- 
1.8.3.2

