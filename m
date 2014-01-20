Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaATOM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:12:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44465 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaATOMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:12:45 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <lee.jones@linaro.org>, <arnd@arndb.de>, <sre@debian.org>,
        <mark.rutland@arm.com>, <m.paolino@virtualopensystems.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v6 04/10] mfd: omap-usb-host: Update DT clock binding information
Date: Mon, 20 Jan 2014 16:11:25 +0200
Message-ID: <1390227091-4523-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390227091-4523-1-git-send-email-rogerq@ti.com>
References: <1390227091-4523-1-git-send-email-rogerq@ti.com>
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

