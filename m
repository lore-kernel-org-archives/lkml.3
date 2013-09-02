Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab3IBORn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:17:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40743 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab3IBORl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:17:41 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Pavel Machek <pavel@ucw.cz>, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH RFC 2/6] doc: dt: binding: omap: am43x/am335x prcm reset
Date: Mon, 2 Sep 2013 19:46:56 +0530
Message-ID: <4aa6c41809a53c6e91dacae9fc52e40c3ccf61c4.1378129416.git.afzal@ti.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <cover.1378129416.git.afzal@ti.com>
References: <cover.1378129416.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prcm reset binding for AM43x/AM335x SoC's.

This was started with an attempt to add reset binding without a clear
idea on the device node where binding should appear. So a new node
with compatible "am4372-reset" to represent reset managment in prcm
was added. But finally ended up with a node to represent prcm (with
compatible "am4372-prcm") which was felt to be the natural one.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 Documentation/devicetree/bindings/arm/omap/prcm.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/omap/prcm.txt

diff --git a/Documentation/devicetree/bindings/arm/omap/prcm.txt b/Documentation/devicetree/bindings/arm/omap/prcm.txt
new file mode 100644
index 0000000..ad25abc
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/omap/prcm.txt
@@ -0,0 +1,13 @@
+TI Power Reset Clock Manager (PRCM)
+
+Properties:
+- compatible:	"ti,am4372-prcm" for prcm in am43x SoC's
+		"ti,am3352-prcm" for prcm in am335x SoC's
+- #reset-cells: 1 (refer generic reset bindings for details)
+
+example:
+	prcm: prcm@44df0000 {
+		compatible = "ti,am4372-prcm";
+		reg = <0x44df0000 0xa000>;
+		#reset-cells = <1>;
+	};
-- 
1.8.3.4

