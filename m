Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaEOKTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:19:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54571 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755001AbaEOKTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:19:09 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v6 09/17] Documentation: dt-bindings: update xhci-platform DT binding
Date: Thu, 15 May 2014 12:17:34 +0200
Message-Id: <1400149062-32661-10-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit extends the compatible string list of the xhci-platform
binding with the new "armada-375-xhci" and "armada-380-xhci"
compatible strings. It is used to describe the XHCI controller which
is available in the Armada 375 and 38x SoCs.

It also indicates that an optional 'clocks' property is now supported.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 Documentation/devicetree/bindings/usb/usb-xhci.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-xhci.txt b/Documentation/devicetree/bindings/usb/usb-xhci.txt
index 90f8f607d125..999be5ca901c 100644
--- a/Documentation/devicetree/bindings/usb/usb-xhci.txt
+++ b/Documentation/devicetree/bindings/usb/usb-xhci.txt
@@ -1,11 +1,16 @@
 USB xHCI controllers
 
 Required properties:
-  - compatible: should be "generic-xhci" (deprecated: "xhci-platform").
+  - compatible: should be one of "generic-xhci",
+    "marvell,armada-375-xhci", "marvell,armada-380-xhci" (deprecated:
+    "xhci-platform").
   - reg: should contain address and length of the standard XHCI
     register set for the device.
   - interrupts: one XHCI interrupt should be described here.
 
+Optional property:
+  - clocks: reference to a clock
+
 Example:
 	usb@f0931000 {
 		compatible = "generic-xhci";
-- 
1.8.1.2

