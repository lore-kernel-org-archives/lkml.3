Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaAIMLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:11:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34698 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbaAIMJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:09:34 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <arnd@arndb.de>, <sre@debian.org>, <mark.rutland@arm.com>,
        <m.paolino@virtualopensystems.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v5 4/9] mfd: omap-usb-tll: Update DT clock binding information
Date: Thu, 9 Jan 2014 17:38:18 +0530
Message-ID: <1389269303-30465-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389269303-30465-1-git-send-email-rogerq@ti.com>
References: <1389269303-30465-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The omap-usb-tll driver needs one clock for each TLL channel.
Add this information to the DT binding document.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/mfd/omap-usb-tll.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt b/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
index 62fe697..c58d704 100644
--- a/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
+++ b/Documentation/devicetree/bindings/mfd/omap-usb-tll.txt
@@ -7,6 +7,16 @@ Required properties:
 - interrupts : should contain the TLL module's interrupt
 - ti,hwmod : must contain "usb_tll_hs"
 
+Optional properties:
+
+- clocks: a list of phandles and clock-specifier pairs, one for each entry in
+  clock-names.
+
+- clock-names: should include:
+  * "usb_tll_hs_usb_ch0_clk" - USB TLL channel 0 clock
+  * "usb_tll_hs_usb_ch1_clk" - USB TLL channel 1 clock
+  * "usb_tll_hs_usb_ch2_clk" - USB TLL channel 2 clock
+
 Example:
 
 	usbhstll: usbhstll@4a062000 {
-- 
1.8.3.2

